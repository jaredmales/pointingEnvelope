
#include <vector>

#include <mx/math/vectorUtils.hpp>
#include <mx/math/constants.hpp>
#include <mx/math/gslInterpolation.hpp>
using namespace mx::math;

#include <mx/sigproc/psdUtils.hpp>
using namespace mx::sigproc;

#include <mx/ao/analysis/wfsNoisePSD.hpp>
#include <mx/ao/analysis/clGainOpt.hpp>
#include <mx/ao/analysis/clAOLinearPredictor.hpp>
using namespace mx::AO::analysis;

//#include "../legendreModes.hpp"
//using namespace mx::sigproc;

// go down to 3 * T0 <-- parameterize
template<typename realT>
int psdRun( std::vector<realT> & psd,
            std::vector<realT> & psd_n,
            std::vector<realT> & freq,
            realT fs,
            realT T0,
            realT t0,
            realT alpha,
            realT sig_nm,
            realT lambda,
            realT beta_p,
            realT Fg,
            realT ron
          )
{
   realT Tint = 3*T0;
   
   if(Tint > 2700) Tint = 2700.;
   
   vectorScale(freq, 0.5*fs*Tint+1, 1.0/Tint);
   
   psd.resize(freq.size());
   
   vonKarmanPSD(psd, freq, 1.0, T0, t0, alpha);
   
   normPSD(psd, freq, pow(sig_nm*two_pi<realT>()/lambda,2), 1./Tint);
   
   psd_n.resize(freq.size());
    
   wfsNoisePSD<realT>(psd_n, beta_p, Fg, 1.0/fs, 32*32, 0.0, ron);
   
   return 0;
}


int main( int argc,
          char **argv
        )
{
   typedef double realT;

   if(argc < 2)
   {
      std::cerr << "Not enough args\n";
      return -1;
   }
   
   realT T0 = std::stod(argv[1]); //
   
   std::cerr << "T0 = " << T0 << "\n";
   
   realT t0 = 0.0;
   
   realT ron = 2.0;

   realT lambda = 600.0;

   realT Fg = 5.12e9; //10% band at 0.6 microns, 50% of rejected starlight used for LLOWFS WFS&C
   realT beta_p = 2.0; //Bad Zernike, to-do: what is beta_p of LLOWFS?

   //std::vector<realT> freq, psd_ol, psd_n, psd_cl;
  
   //------------------------
   //Create fs grid
   realT fsMin = 0.25;
   realT fsMax = 5000.;
   realT dfs = 2;
   
   std::vector<realT> fs, logfs;
   for(realT f = fsMin; f <= fsMax; f*=dfs) fs.push_back(f);
   
   logfs.resize(fs.size());
   for(size_t n=0; n< fs.size(); ++n) logfs[n] = log10(fs[ fs.size()-1 - n]);
   
   
   //--------------------------
   //Create sig_nm grid
   realT sigMin = pow(2, 0.25);
   realT sigMax = 4000.;
   realT dsig = pow(2, 0.25);
   
   std::vector<realT> sig_nm;
   for(realT s = sigMin; s <= sigMax; s*=dsig) sig_nm.push_back(s);
   
   //--------------------------
   //create alpha grid
   realT alphaMin = 1.0;
   realT alphaMid = 2.9;
   realT alphaMax = 6.0;
   realT dalphaMid = 0.1;
   realT dalpha = pow(2, 0.25);
   
   std::vector<realT> alpha;
   for(realT a = alphaMin; a < alphaMid; a += dalphaMid) alpha.push_back(a);
   for(realT a = alphaMid; a < alphaMax*dalpha*0.99; a*=dalpha) alpha.push_back(a);
   
   
   std::cout << "# T0 = " << T0 << "\n";
   
   std::vector<std::vector<realT>> ofs;
   ofs.resize(alpha.size());
   for(size_t na =0; na < alpha.size(); ++na)
   {
      ofs[na].resize(sig_nm.size());
   }
   
   //======================================
   //Run the grids
   //=====================================
   #pragma omp parallel for
   for(size_t na =0; na < alpha.size(); ++na)
   {
      std::vector<realT> rms, logrms;
      
      rms.resize(fs.size());
      logrms.resize(logfs.size());
   
      std::vector<realT> rmsgoal = {log10(1.0)};
      std::vector<realT> fsgoal = {0.};

      std::vector<realT> freq, psd_ol, psd_n, psd_cl;
   
      for(size_t ns = 0; ns < sig_nm.size(); ++ns)
      {
         for(size_t n=0; n< fs.size(); ++n)
         {
            realT tau = 2.0/fs[n];
            psdRun(psd_ol, psd_n, freq, fs[n], T0, t0, alpha[na], sig_nm[ns], lambda, beta_p, Fg, ron);
            
            clGainOpt<realT> gopt(1.0/fs[n], tau);
            gopt.f(freq);
            
            realT opt_g, opt_var;
            realT gmax = 1;
            opt_g = gopt.optGainOpenLoop(opt_var, psd_ol, psd_n);
            
            rms[n] = sqrt(opt_var)*lambda/two_pi<realT>();
            logrms[fs.size()-1-n] = log10(rms[n]);
         }
         
         size_t nst = 0;
         for(size_t n=0; n < rms.size()-1; ++n)
         {
            if(logrms[n] >= logrms[n+1]) ++nst;
            else break;
         }
         
         size_t ned = nst+1;
         for(size_t n=nst+1; n < rms.size()-1; ++n)
         {
            if(logrms[n] < logrms[n+1]) ++ned;
            else break;
         }
         ++ned;
         if(ned >= rms.size()) ned = rms.size();
         
         if(logrms[ned-1] <= rmsgoal[0])
         {
            fsgoal[0] = logfs[ned-1];
         }
         else
         { 
            gsl_interpolate(gsl_interp_linear, logrms.data()+nst, logfs.data()+nst, ned-nst, rmsgoal.data(), fsgoal.data(), rmsgoal.size());
         }

         realT fst = pow(10., fsgoal[0]);
         ofs[na][ns] = fst;
         //std::cout << alpha[na] << " " << sig_nm[ns] << " " << fst << "\n";
      }
      //std::cout << std::endl;
   }
   
   for(size_t na =0; na < alpha.size(); ++na)
   {
      for(size_t ns = 0; ns < sig_nm.size(); ++ns)
      {
         std::cout << alpha[na] << " " << sig_nm[ns] << " " << ofs[na][ns] << "\n";
      }
      std::cout << "\n";
   }
   
   //realT opt_g_lp, opt_var_lp;

   /*
   clAOLinearPredictor<realT> claolp;
   gmax = 10;
   claolp.regularizeCoefficients( gmax, opt_g_lp, opt_var_lp, gopt, psd_ol, psd_n, lpNc);
   std::cerr << "lp: " << opt_g_lp << " " << opt_var_lp << " " << sqrt(opt_var_lp)*lambda/two_pi<realT>() << "\n";
   /**/

   /*
   realT ETF, NTF;
   for(int n=0; n < freq.size(); ++n)
   {
      gopt.clTF2(ETF, NTF, n, opt_g); 
      std::cout << freq[n] << " " << psd_ol[n] << " " << psd_n[n] << " " << ETF << " " << NTF << "\n";
   }*/

   return 0;

}
