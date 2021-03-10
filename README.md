Delayed Photon Ntuplizer
=============================

Razor ntuplizer for running over LHC Run 2 miniAOD compatible with CMSSW_9_4_9.

N.B. For 2018 UL data, please use at least CMSSW_10_6_X. Full recipe by PPD can be found here https://twiki.cern.ch/twiki/bin/view/CMS/PdmVRun2LegacyAnalysisSummaryTable

-----------------------------------
Instructions for compiling in CMSSW
-----------------------------------

    export SCRAM_ARCH=slc7_amd64_gcc700
    cmsrel CMSSW_10_6_12
    cd CMSSW_10_6_12/src
    cmsenv
    git clone -b Tuplize_2018UL git@github.com:cms-lpc-llp/DelayedPhotonTuplizer.git Tuplizer/DelayedPhotonTuplizer
    scram b

---------------------    
Running the ntuplizer
---------------------

    cmsRun python/razorTuplizer_DataUL_2018_Rereco_EcalRechits_OOTpho.py

    
Before running, check python/razorTuplizer.py to make sure that the correct global tag is defined. (process.GlobalTag.globaltag = ...)


To run a test job with CRAB3:

    source /cvmfs/cms.cern.ch/crab3/crab.sh
    crab submit -c crabConfigRazorTuplizer.py

To submit mass production, use bash scripts in `crab_scripts` directory. Make 2018 copies based on `submit_data.sh`, `submit_DiPhoton.sh`, `submit_GJet16_DoubleEMEnriched.sh`, and `submit_QCD16_DoubleEMEnriched.sh` (we don't have signals for 2018 yet). Before running each script, please check every line to make sure it's correct and updated. For data lumi mask, use this https://cms-service-dqm.web.cern.ch/cms-service-dqm/CAF/certification/Collisions18/13TeV/PromptReco/Cert_314472-325175_13TeV_PromptReco_Collisions18_JSON.txt (please cross check with PPD recommendation for update https://twiki.cern.ch/twiki/bin/view/CMS/PdmV2018Analysis#DATA). 

After crab submission, job status can be checked with `python check_crab.py -s [KEY_WORD]` where `KEY_WORD` is any word matched with the crab directory of the sample you want to check. For example `python check_crab.py -s QCD`. Optional arguments: 
   - `-r`: to resubmit failed jobs even when the task is not finished, 
   - `-k`: to kill unfinished task.
