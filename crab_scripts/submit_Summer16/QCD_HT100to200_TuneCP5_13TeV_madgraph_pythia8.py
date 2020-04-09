from WMCore.Configuration import Configuration
config = Configuration()

config.section_("General")
config.General.requestName = 'prodSummer16_Run2DelayedPhotonNtupler_QCD_HT100to200_TuneCP5_13TeV_madgraph_pythia8'
config.General.workArea = 'crab'

config.section_("JobType")
config.JobType.pluginName = 'Analysis'
config.JobType.psetName = '/storage/user/qnguyen/DelayedPhoton/CMSSW_9_4_9/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_MC_EcalRechits_reMiniAOD_OOT.py'
config.JobType.allowUndistributedCMSSW = True

config.section_("Data")
config.Data.publication = False
config.Data.inputDataset = '/QCD_HT100to200_TuneCUETP8M1_13TeV-madgraphMLM-pythia8/RunIISummer16MiniAODv3-PUMoriond17_94X_mcRun2_asymptotic_v3-v1/MINIAODSIM'
config.Data.splitting = 'FileBased'
config.Data.unitsPerJob = 2

config.section_("Site")
config.Site.storageSite = 'T2_US_Caltech'
config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC2016/QCD/'
