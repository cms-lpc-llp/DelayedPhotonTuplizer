import FWCore.ParameterSet.Config as cms

#------ Setup ------#

#initialize the process
process = cms.Process("razorTuplizer")
process.load("FWCore.MessageService.MessageLogger_cfi")
process.load("PhysicsTools.PatAlgos.producersLayer1.patCandidates_cff")
process.load("Configuration.EventContent.EventContent_cff")

#load input files
process.source = cms.Source("PoolSource",
    fileNames = cms.untracked.vstring(
     #'/store/mc/RunIIFall17MiniAOD/DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM-pythia8/MINIAODSIM/RECOSIMstep_94X_mc2017_realistic_v10_ext1-v1/00000/02350E8C-32F4-E711-89CB-02163E0145CA.root'
     '/store/mc/RunIIFall17MiniAODv2/GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8/MINIAODSIM/PU2017_12Apr2018_94X_mc2017_realistic_v14-v1/90000/044F95FB-A342-E811-907F-5065F3816251.root'
     #'/store/mc/RunIIFall17MiniAODv2/GluGluHToGG_M125_13TeV_amcatnloFXFX_pythia8_PSWeights/MINIAODSIM/PU2017_12Apr2018_94X_mc2017_realistic_v14_ext1-v1/50000/9447AB9D-0C44-E811-B07A-0025905C9742.root'
    )
)
process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32(1000) )
process.MessageLogger.cerr.FwkReport.reportEvery = 100

#TFileService for output 
process.TFileService = cms.Service("TFileService", 
    fileName = cms.string("razorNtuple.root"),
    closeFileFast = cms.untracked.bool(True)
)

#load run conditions
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_cff')
process.load('Configuration.Geometry.GeometryIdeal_cff')
process.load('Configuration.StandardSequences.MagneticField_38T_cff')

#------ Declare the correct global tag ------#

#Global Tag for Run2015D
process.GlobalTag.globaltag = '94X_mc2017_realistic_v14'

#------ If we add any inputs beyond standard miniAOD event content, import them here ------#

#process.load('CommonTools.RecoAlgos.HBHENoiseFilterResultProducer_cfi')
#process.HBHENoiseFilterResultProducer.minZeros = cms.int32(99999)
#process.HBHENoiseFilterResultProducer.IgnoreTS4TS5ifJetInLowBVRegion=cms.bool(False) 
#process.HBHENoiseFilterResultProducer.defaultDecision = cms.string("HBHENoiseFilterResultRun2Loose")

process.load('RecoMET.METFilters.BadChargedCandidateFilter_cfi')
process.BadChargedCandidateFilter.muons = cms.InputTag("slimmedMuons")
process.BadChargedCandidateFilter.PFCandidates = cms.InputTag("packedPFCandidates")
process.BadChargedCandidateFilter.taggingMode = cms.bool(True)

process.load('RecoMET.METFilters.BadPFMuonFilter_cfi')
process.BadPFMuonFilter.muons = cms.InputTag("slimmedMuons")
process.BadPFMuonFilter.PFCandidates = cms.InputTag("packedPFCandidates")
process.BadPFMuonFilter.taggingMode = cms.bool(True)


#------ Electron MVA Setup ------#
# define which IDs we want to produce
from PhysicsTools.SelectorUtils.tools.vid_id_tools import *
dataFormat = DataFormat.MiniAOD
switchOnVIDElectronIdProducer(process, dataFormat)
my_id_modules = ['RecoEgamma.ElectronIdentification.Identification.mvaElectronID_Spring16_GeneralPurpose_V1_cff','RecoEgamma.ElectronIdentification.Identification.mvaElectronID_Spring16_HZZ_V1_cff']

#add them to the VID producer
for idmod in my_id_modules:
    setupAllVIDIdsInModule(process,idmod,setupVIDElectronSelection)



#------ Analyzer ------#
from PhysicsTools.PatAlgos.slimming.unpackedTracksAndVertices_cfi import unpackedTracksAndVertices
process.unpackedTracksAndVertices = unpackedTracksAndVertices.clone()

#list input collections
process.ntuples = cms.EDAnalyzer('RazorTuplizer', 
    isData = cms.bool(False),    
    useGen = cms.bool(True),
    isFastsim = cms.bool(False),
    enableTriggerInfo = cms.bool(True),                                 
    enableEcalRechits = cms.bool(True),                                 
    readGenVertexTime = cms.untracked.bool(True),
    genParticles_t0 = cms.InputTag("genParticles", "t0", ""), 
    triggerPathNamesFile = cms.string("Tuplizer/DelayedPhotonTuplizer/data/RazorHLTPathnames2017.dat"),
    eleHLTFilterNamesFile = cms.string("Tuplizer/DelayedPhotonTuplizer/data/RazorElectronHLTFilterNames2017.dat"),
    muonHLTFilterNamesFile = cms.string("Tuplizer/DelayedPhotonTuplizer/data/RazorMuonHLTFilterNames2017.dat"),
    photonHLTFilterNamesFile = cms.string("Tuplizer/DelayedPhotonTuplizer/data/RazorPhotonHLTFilterNames2017.dat"),

    vertices = cms.InputTag("offlineSlimmedPrimaryVertices"),
    tracks = cms.InputTag("unpackedTracksAndVertices"),
    
    muons = cms.InputTag("slimmedMuons"),
    electrons = cms.InputTag("slimmedElectrons"),
    taus = cms.InputTag("slimmedTaus"),
    photons = cms.VInputTag(cms.InputTag("slimmedPhotons"),cms.InputTag("slimmedOOTPhotons")), # please put the standard photon collection to the first one
    jets = cms.InputTag("slimmedJets"),
    jetsPuppi = cms.InputTag("slimmedJetsPuppi"),
    jetsAK8 = cms.InputTag("slimmedJetsAK8"),
    enableAK8Jets = cms.bool(False),
    jetsAK8SoftDropPacked = cms.InputTag("selectedPatJetsAK8PFCHSSoftDropPacked"),
    jetsAK8Subjets = cms.InputTag("selectedPatJetsAK8PFCHSSoftDropPacked", "SubJets"),
    puppiSDjetLabel = cms.InputTag('packedPatJetsAK8PFPuppiSoftDrop'),
    mets = cms.InputTag("slimmedMETs"),
    metsEGClean = cms.InputTag("slimmedMETsEGClean","","PAT"),
    metsMuEGClean = cms.InputTag("slimmedMETsMuEGClean","","PAT"),
    metsMuEGCleanCorr = cms.InputTag("slimmedMETsMuEGClean","","razorTuplizer"),
    metsUncorrected = cms.InputTag("slimmedMETsUncorrected"),
    metsNoHF = cms.InputTag("slimmedMETsNoHF"),
    metsPuppi = cms.InputTag("slimmedMETsPuppi"),
    packedPfCands = cms.InputTag("packedPFCandidates"),

    packedGenParticles = cms.InputTag("packedGenParticles"),
    prunedGenParticles = cms.InputTag("prunedGenParticles"),
    genJets = cms.InputTag("slimmedGenJets", "", "PAT"),

    triggerBits = cms.InputTag("TriggerResults","","HLT"),
    triggerPrescales = cms.InputTag("patTrigger"),
    triggerObjects = cms.InputTag("slimmedPatTrigger"),
    metFilterBits = cms.InputTag("TriggerResults", "", "PAT"),
    hbheNoiseFilter = cms.InputTag("HBHENoiseFilterResultProducer","HBHENoiseFilterResult"),
    hbheTightNoiseFilter = cms.InputTag("HBHENoiseFilterResultProducer","HBHENoiseFilterResultRun2Tight"),
    hbheIsoNoiseFilter = cms.InputTag("HBHENoiseFilterResultProducer","HBHEIsoNoiseFilterResult"),
    BadChargedCandidateFilter = cms.InputTag("BadChargedCandidateFilter",""),
    BadMuonFilter = cms.InputTag("BadPFMuonFilter",""),
    badGlobalMuonFilter = cms.InputTag("badGlobalMuonTagger","bad"),
    duplicateMuonFilter = cms.InputTag("cloneGlobalMuonTagger","bad"),

    lheInfo = cms.InputTag("externalLHEProducer", "", ""),
    genInfo = cms.InputTag("generator", "", "SIM"),
    puInfo = cms.InputTag("slimmedAddPileupInfo", "", "PAT"), #uncomment if no pre-mixing
    #puInfo = cms.InputTag("mixData", "", "HLT"), #uncomment for samples with pre-mixed pileup
    hcalNoiseInfo = cms.InputTag("hcalnoise", "", "PAT"),

    secondaryVertices = cms.InputTag("slimmedSecondaryVertices", "", "PAT"),

    rhoAll = cms.InputTag("fixedGridRhoAll", "", "RECO"),
    rhoFastjetAll = cms.InputTag("fixedGridRhoFastjetAll", "", "RECO"),
    rhoFastjetAllCalo = cms.InputTag("fixedGridRhoFastjetAllCalo", "", "RECO"),
    rhoFastjetCentralCalo = cms.InputTag("fixedGridRhoFastjetCentralCalo", "", "RECO"),
    rhoFastjetCentralChargedPileUp = cms.InputTag("fixedGridRhoFastjetCentralChargedPileUp", "", "RECO"),
    rhoFastjetCentralNeutral = cms.InputTag("fixedGridRhoFastjetCentralNeutral", "", "RECO"),

    beamSpot = cms.InputTag("offlineBeamSpot", "", "RECO"),

    ebRecHits = cms.InputTag("reducedEgamma", "reducedEBRecHits", "PAT"), 
    eeRecHits = cms.InputTag("reducedEgamma", "reducedEERecHits", "PAT"),
    esRecHits = cms.InputTag("reducedEgamma", "reducedESRecHits", "PAT"),
    ebeeClusters = cms.InputTag("reducedEgamma", "reducedEBEEClusters", "PAT"),
    #ebeeClusters = cms.VInputTag(cms.InputTag("reducedEgamma", "reducedEBEEClusters", "PAT"), cms.InputTag("reducedEgamma", "reducedOOTEBEEClusters", "PAT")),
    esClusters = cms.InputTag("reducedEgamma", "reducedESClusters", "PAT"),
    #esClusters = cms.VInputTag(cms.InputTag("reducedEgamma", "reducedESClusters", "PAT"), cms.InputTag("reducedEgamma", "reducedOOTESClusters", "PAT")),
    conversions = cms.InputTag("reducedEgamma", "reducedConversions", "PAT"),
    singleLegConversions = cms.InputTag("reducedEgamma", "reducedSingleLegConversions", "PAT"),
    gedGsfElectronCores = cms.InputTag("reducedEgamma", "reducedGedGsfElectronCores", "PAT"),
    gedPhotonCores = cms.InputTag("reducedEgamma", "reducedGedPhotonCores", "PAT"),
    #gedPhotonCores = cms.VInputTag(cms.InputTag("reducedEgamma", "reducedGedPhotonCores", "PAT"), cms.InputTag("reducedEgamma", "reducedOOTPhotonCores", "PAT")),
    superClusters = cms.InputTag("reducedEgamma", "reducedSuperClusters", "PAT"),
    #superClusters = cms.VInputTag(cms.InputTag("reducedEgamma", "reducedSuperClusters", "PAT"), cms.InputTag("reducedEgamma", "reducedOOTSuperClusters", "PAT")),

    lostTracks = cms.InputTag("lostTracks", "", "PAT"),
    mvaGeneralPurposeValuesMap     = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16GeneralPurposeV1Values"),
    mvaGeneralPurposeCategoriesMap = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16GeneralPurposeV1Categories"),
    mvaHZZValuesMap     = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16HZZV1Values"),
    mvaHZZCategoriesMap = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16HZZV1Categories"),
)

#run
process.p = cms.Path( process.egmGsfElectronIDSequence *
                      #process.HBHENoiseFilterResultProducer*
                      process.BadChargedCandidateFilter*
                      process.BadPFMuonFilter*
                      process.unpackedTracksAndVertices *
                      process.ntuples)
