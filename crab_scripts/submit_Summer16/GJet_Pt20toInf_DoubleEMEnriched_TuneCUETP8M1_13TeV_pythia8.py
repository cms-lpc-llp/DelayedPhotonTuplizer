from WMCore.Configuration import Configuration
config = Configuration()

config.section_("General")
config.General.requestName = 'prodSummer16_Run2DelayedPhotonNtupler_GJet_Pt_20toInf_DoubleEMEnriched_TuneCUETP8M1_13TeV_pythia8'
config.General.workArea = 'crab'

config.section_("JobType")
config.JobType.pluginName = 'Analysis'
config.JobType.psetName = '/storage/user/qnguyen/DelayedPhoton/CMSSW_9_4_9/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_MC_EcalRechits_reMiniAOD_OOT.py'
config.JobType.allowUndistributedCMSSW = True

config.section_("Data")
config.Data.publication = False
config.Data.inputDataset = '/GJet_Pt-20toInf_DoubleEMEnriched_MGG-40to80_TuneCUETP8M1_13TeV_Pythia8/RunIISummer16MiniAODv3-PUMoriond17_94X_mcRun2_asymptotic_v3-v2/MINIAODSIM'
config.Data.splitting = 'LumiBased'
config.Data.unitsPerJob = 1000

config.section_("Site")
config.Site.storageSite = 'T2_US_Caltech'
config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC2016/GJet_DoubleEMEnriched/'
