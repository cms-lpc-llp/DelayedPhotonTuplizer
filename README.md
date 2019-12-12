Delayed Photon Ntuplizer
=============================

Razor ntuplizer for running over LHC Run 2 miniAOD compatible with CMSSW_9_4_9.

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

To run using CRAB3:

    source /cvmfs/cms.cern.ch/crab3/crab.sh
    crab submit -c crabConfigRazorTuplizer.py

