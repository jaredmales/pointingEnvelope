
#include <vector>

#include <mx/mxlib.hpp>

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

#include <mx/ipc/ompLoopWatcher.hpp>

#include "pointingEnv_git_version.h"

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
            long npix,
            realT ron
          )
{
   realT Tint = 3*T0;

   if(Tint > 2700) Tint = 2700.;

   vectorScale(freq, 0.5*fs*Tint+1, 1.0/Tint);

   psd.resize(freq.size());

   vonKarmanPSD(psd, freq, alpha, T0, t0, 1.0);

   normPSD(psd, freq, pow(sig_nm*two_pi<realT>()/lambda,2), 1./Tint);

   psd_n.resize(freq.size());

   wfsNoisePSD<realT>(psd_n, beta_p, Fg, 1.0/fs, npix, 0.0, ron);

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

   int T0i = std::stoi(argv[1]);
   realT T0 = T0i; //

   std::cerr << "T0 = " << T0 << "\n";

   realT t0 = 0.0;

   realT ron = 2.0;

   //Based on MagAO-X r' filter:
   realT lambda = 615.0;
   realT Fg = 7.92909e+16*1.10786e-7*0.25*3.14159*pow(3,2); //photons/sec at primary mirror
   //and info from Kian:
   Fg = Fg * 0.06 /*throughput*/ * 0.75 /*lyot stop capture*/ * 0.8 /*QE*/;

   realT beta_p = 2.0; //Bad Zernike, to-do: what is beta_p of LLOWFS?
   long npix = 1692; //number of pixels from Kian

   realT rmsSpec = 10.0;

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

   std::vector<std::vector<realT>> ofs;
   ofs.resize(alpha.size());
   for(size_t na =0; na < alpha.size(); ++na)
   {
      ofs[na].resize(sig_nm.size());
   }

   //======================================
   //Run the grids
   //=====================================
   int Npts = alpha.size() * sig_nm.size();
   mx::ipc::ompLoopWatcher omplw(Npts, std::cerr);

   #pragma omp parallel for
   for(size_t na =0; na < alpha.size(); ++na)
   {
      std::vector<realT> rms, logrms;

      rms.resize(fs.size());
      logrms.resize(logfs.size());

      std::vector<realT> rmsgoal = {log10(rmsSpec)};
      std::vector<realT> fsgoal = {0.};

      std::vector<realT> freq, psd_ol, psd_n, psd_cl;

      for(size_t ns = 0; ns < sig_nm.size(); ++ns)
      {
         for(size_t n=0; n< fs.size(); ++n)
         {
            realT tau = 2.0/fs[n];
            psdRun(psd_ol, psd_n, freq, fs[n], T0, t0, alpha[na], sig_nm[ns], lambda, beta_p, Fg, npix, ron);

            clGainOpt<realT> gopt(1.0/fs[n], tau);
            gopt.f(freq);

            realT opt_g, opt_var;
            realT gmax = 1;
            opt_g = gopt.optGainOpenLoop(opt_var, psd_ol, psd_n, false);

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

         omplw.incrementAndOutputStatus();
      }
      //std::cout << std::endl;
   }
   omplw.clearOutput();
   omplw.outputFinalStatus();
   std::cerr << '\n';

   std::string fnout = "../output/3m10nm/out_T0-";
   fnout += std::to_string(T0i) + ".dat";

   std::ofstream fout;
   fout.open(fnout);

   fout << "# T0 = " << T0 << "\n";
   fout << "# mxlib uncomp [";
   fout << MXLIB_UNCOMP_BRANCH;
   fout <<  "]: ";
   fout << MXLIB_UNCOMP_CURRENT_SHA1;
   if(MXLIB_UNCOMP_REPO_MODIFIED) fout << " (modified)";
   fout << "\n";

   fout << "# mxlib comp [";
   fout << MXLIB_UNCOMP_BRANCH;
   fout << "]: ";
   fout << mx::mxlib_comp_current_sha1();
   if(mx::mxlib_comp_repo_modified()) fout << " (modified)";
   fout << "\n";

   fout << "# pointingEnv [";
   fout << POINTINGENV_GIT_BRANCH;
   fout << "]: ";
   fout << POINTINGENV_GIT_CURRENT_SHA1;
   if(POINTINGENV_GIT_REPO_MODIFIED) fout << " (modified)";
   fout << "\n";

   for(size_t na =0; na < alpha.size(); ++na)
   {
      for(size_t ns = 0; ns < sig_nm.size(); ++ns)
      {
         fout << alpha[na] << " " << sig_nm[ns] << " " << ofs[na][ns] << "\n";
      }
      fout << "\n";
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
