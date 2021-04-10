Delayed Photon Ntuplizer
=============================

Razor ntuplizer for running over LHC Run 2 miniAOD compatible with CMSSW_9_4_9.

N.B. For 2018 data, please use CMSSW_10_2_X. Note that CMSSW_10_6_X will break and you will need to use the Tuplize_2018UL branch. Full recipe by PPD can be found here https://twiki.cern.ch/twiki/bin/viewauth/CMS/PdmVAnalysisSummaryTable. 
Also, extra packages need to be installed for 2018 data to obtain the photon energy corrections, according to https://twiki.cern.ch/twiki/bin/view/CMS/EgammaMiniAODV2#2018_MiniAOD

If you are running on lxplus, you will likely need to use Singularity because 10_2_X only compiles in SLC6, which is not supported on lxplus.

To start singularity:
    
    export SINGULARITY_CACHEDIR=/tmp/$(whoami)/singularity;singularity shell -B /cvmfs -B /afs -B /eos /cvmfs/singularity.opensciencegrid.org/bbockelm/cms:rhel6
    source /cvmfs/cms.cern.ch/cmsset_default.sh 

To install extra packages for photon energy corrections:

    export SCRAM_ARCH=slc6_amd64_gcc700
    cmsrel CMSSW_10_2_10
    cd CMSSW_10_2_10/src
    cmsenv
    git cms-init
    git cms-merge-topic cms-egamma:EgammaPostRecoTools #just adds in an extra file to have a setup function to make things easier
    git cms-merge-topic cms-egamma:PhotonIDValueMapSpeedup1029 #optional but speeds up the photon ID value module so things fun faster
    git cms-merge-topic cms-egamma:slava77-btvDictFix_10210 #fixes the Run2018D dictionary issue, see https://github.com/cms-sw/cmssw/issues/26182, may not be necessary for later releases, try it first and see if it works
    #now to add the scale and smearing for 2018 (eventually this will not be necessary in later releases but is harmless to do regardless)
    git cms-addpkg EgammaAnalysis/ElectronTools
    rm EgammaAnalysis/ElectronTools/data -rf
    git clone git@github.com:cms-data/EgammaAnalysis-ElectronTools.git EgammaAnalysis/ElectronTools/data
    #now build everything
    scram b -j 8

Now install and compile our tuplizer:
 
    git clone git@github.com:cms-lpc-llp/DelayedPhotonTuplizer.git Tuplizer/DelayedPhotonTuplizer
    scram b

---------------------    
Running the ntuplizer
---------------------

    cmsRun python/razorTuplizer_MC_Fall17_EcalRechits_reMiniAOD_OOT.py

    
Before running, check python/razorTuplizer.py to make sure that the correct global tag is defined. (process.GlobalTag.globaltag = ...)

To run a test job with CRAB3:

    source /cvmfs/cms.cern.ch/crab3/crab.sh
    crab submit -c crabConfigRazorTuplizer.py

To submit mass production, use bash scripts in `crab_scripts` directory. Make 2018 copies based on `submit_data.sh`, `submit_DiPhoton.sh`, `submit_GJet16_DoubleEMEnriched.sh`, and `submit_QCD16_DoubleEMEnriched.sh` (we don't have signals for 2018 yet). Before running each script, please check every line to make sure it's correct and updated. For data lumi mask, use this https://cms-service-dqm.web.cern.ch/cms-service-dqm/CAF/certification/Collisions18/13TeV/PromptReco/Cert_314472-325175_13TeV_PromptReco_Collisions18_JSON.txt (please cross check with PPD recommendation for update https://twiki.cern.ch/twiki/bin/view/CMS/PdmV2018Analysis#DATA). 

After crab submission, job status can be checked with `python check_crab.py -s [KEY_WORD]` where `KEY_WORD` is any word matched with the crab directory of the sample you want to check. For example `python check_crab.py -s QCD`. Optional arguments: 
   - `-r`: to resubmit failed jobs even when the task is not finished, 
   - `-k`: to kill unfinished task.
