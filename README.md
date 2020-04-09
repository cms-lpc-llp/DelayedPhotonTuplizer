Delayed Photon Ntuplizer
=============================

Razor ntuplizer for running over LHC Run 2 miniAOD compatible with CMSSW_9_4_9.

N.B. For 2018 data, please use at least CMSSW_10_2_X. Full recipe by PPD can be found here https://twiki.cern.ch/twiki/bin/viewauth/CMS/PdmVAnalysisSummaryTable

-----------------------------------
Instructions for compiling in CMSSW
-----------------------------------

    cmsrel CMSSW_9_4_9
    cd CMSSW_9_4_9/src
    cmsenv
    git clone git@github.com:cms-lpc-llp/DelayedPhotonTuplizer.git Tuplizer/DelayedPhotonTuplizer
    scram b

---------------------    
Running the ntuplizer
---------------------

    cmsRun python/razorTuplizer_MC_Fall17_EcalRechits_reMiniAOD_OOT.py

    
Before running, check python/razorTuplizer.py to make sure that the correct global tag is defined. (process.GlobalTag.globaltag = ...)

To run on 2018 data, there is no python config file yet. Please make a version for 2018 based on `razorTuplizer_MC_Fall17_EcalRechits_reMiniAOD_OOT.py` and `razorTuplizer_Data_2017_Rereco_EcalRechits_OOTpho.py` and update proper tags and other necessary changes.

To run a test job with CRAB3:

    source /cvmfs/cms.cern.ch/crab3/crab.sh
    crab submit -c crabConfigRazorTuplizer.py

To submit mass production, use bash scripts in `crab_scripts` directory. Make 2018 copies based on `submit_data.sh`, `submit_DiPhoton.sh`, `submit_GJet16_DoubleEMEnriched.sh`, and `submit_QCD16_DoubleEMEnriched.sh` (we don't have signals for 2018 yet). Before running each script, please check every line to make sure it's correct and updated. For data lumi mask, use this https://cms-service-dqm.web.cern.ch/cms-service-dqm/CAF/certification/Collisions18/13TeV/PromptReco/Cert_314472-325175_13TeV_PromptReco_Collisions18_JSON.txt (please cross check with PPD recommendation for update https://twiki.cern.ch/twiki/bin/view/CMS/PdmV2018Analysis#DATA). 

After crab submission, job status can be checked with `python check_crab.py -s [KEY_WORD]` where `KEY_WORD` is any word matched with the crab directory of the sample you want to check. For example `python check_crab.py -s QCD`. Optional arguments: 
   - `-r`: to resubmit failed jobs even when the task is not finished, 
   - `-k`: to kill unfinished task.
