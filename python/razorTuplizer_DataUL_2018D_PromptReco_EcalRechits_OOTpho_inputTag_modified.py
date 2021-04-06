import FWCore.ParameterSet.Config as cms

#------ Setup ------#

#initialize the process
process = cms.Process("RazorTuplizer")
process.load("FWCore.MessageService.MessageLogger_cfi")
process.load("PhysicsTools.PatAlgos.producersLayer1.patCandidates_cff")
process.load("Configuration.EventContent.EventContent_cff")

#load input files
process.source = cms.Source("PoolSource",
    fileNames = cms.untracked.vstring(
        'file:01F6D50E-0AF1-324C-872D-09FB91869B70.root'                
    )
)
process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32(1000) )
process.MessageLogger.cerr.FwkReport.reportEvery = 100

#TFileService for output 
process.TFileService = cms.Service("TFileService", 
    fileName = cms.string("razorNtuple_recal_modified_inputtag.root"),
    closeFileFast = cms.untracked.bool(True),
)

#load run conditions
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_condDBv2_cff')
process.load('Configuration.Geometry.GeometryIdeal_cff')
process.load("Configuration.StandardSequences.MagneticField_cff")

#------ Declare the correct global tag ------#

# https://twiki.cern.ch/twiki/bin/viewauth/CMS/PdmVAnalysisSummaryTable
#process.GlobalTag.globaltag = '106X_upgrade2018_realistic_v15_L1v1'

from CondCore.CondDB.CondDB_cfi import *
process.GlobalTag = cms.ESSource("PoolDBESSource",
                                 CondDB.clone(connect = cms.string('frontier://FrontierProd/CMS_CONDITIONS')),
                                 #globaltag = cms.string('106X_upgrade2018_realistic_v15_L1v1'), # From the 
                                 globaltag = cms.string('106X_dataRun2_v32'), # From the hypernews
                                 # Get time calibration (corrections) tag
                                 toGet = cms.VPSet(
                                     cms.PSet(record = cms.string("EcalTimeCalibConstantsRcd"),
                                              tag = cms.string("EcalTimeCalibConstants_2018_RunD_UL_Corr_v2"),
                                              connect = cms.string("sqlite_file:EcalTimeCalibConstants_2018_RunD_UL_Corr_v2.db"),
                                          )
                                 )
)


#------ Time re-calibration for 2018D legacy reco ------#

process.load("RecoLocalCalo.EcalRecProducers.ecalRecalibRecHit_cfi")
process.ecalRecalibRecHit.EBRecHitCollection = cms.InputTag("reducedEgamma", "reducedEBRecHits")
process.ecalRecalibRecHit.EERecHitCollection = cms.InputTag("reducedEgamma", "reducedEERecHits")
process.ecalRecalibRecHit.EBRecalibRecHitCollection = cms.string('recalibEcalRecHitsEB')
process.ecalRecalibRecHit.EERecalibRecHitCollection = cms.string('recalibEcalRecHitsEE')
process.ecalRecalibRecHit.doTimeCalib = True
process.recalib_sequence = cms.Sequence(process.ecalRecalibRecHit)

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
    isData = cms.bool(True),    
    useGen = cms.bool(False),
    isFastsim = cms.bool(False),
    enableTriggerInfo = cms.bool(True),                                 
    enableEcalRechits = cms.bool(True),                    
    enableAK8Jets = cms.bool(False), 
    triggerPathNamesFile = cms.string("Tuplizer/DelayedPhotonTuplizer/data/RazorHLTPathnames2018.dat"),
    eleHLTFilterNamesFile = cms.string("Tuplizer/DelayedPhotonTuplizer/data/RazorElectronHLTFilterNames2018.dat"),
    muonHLTFilterNamesFile = cms.string("Tuplizer/DelayedPhotonTuplizer/data/RazorMuonHLTFilterNames2018.dat"),
    photonHLTFilterNamesFile = cms.string("Tuplizer/DelayedPhotonTuplizer/data/RazorPhotonHLTFilterNames2018.dat"),

    vertices = cms.InputTag("offlineSlimmedPrimaryVertices"),
    tracks = cms.InputTag("unpackedTracksAndVertices"),
    muons = cms.InputTag("slimmedMuons"),
    electrons = cms.InputTag("slimmedElectrons"),
    taus = cms.InputTag("slimmedTaus"),
    photons = cms.VInputTag(cms.InputTag("slimmedPhotons"), cms.InputTag("slimmedOOTPhotons")), #standard photon first, OOT and other photons follow next
    jets = cms.InputTag("slimmedJets"),
    jetsPuppi = cms.InputTag("slimmedJetsPuppi"),
    jetsAK8 = cms.InputTag("slimmedJetsAK8"),
    puppiSDjetLabel = cms.InputTag('packedPatJetsAK8PFPuppiSoftDrop'),
    jetsAK8SoftDropPacked = cms.InputTag("selectedPatJetsAK8PFCHSSoftDropPacked"),
    jetsAK8Subjets = cms.InputTag("selectedPatJetsAK8PFCHSSoftDropPacked", "SubJets"),
    mets = cms.InputTag("slimmedMETs"),
    metsNoHF = cms.InputTag("slimmedMETsNoHF"),
    metsPuppi = cms.InputTag("slimmedMETsPuppi"),
    packedPfCands = cms.InputTag("packedPFCandidates"),

    packedGenParticles = cms.InputTag("packedGenParticles"),
    prunedGenParticles = cms.InputTag("prunedGenParticles"),
    genJets = cms.InputTag("slimmedGenJets", "", "RECO"),

    triggerBits = cms.InputTag("TriggerResults","","HLT"),
    triggerPrescales = cms.InputTag("patTrigger"),
    triggerObjects = cms.InputTag("slimmedPatTrigger"),
    metFilterBits = cms.InputTag("TriggerResults", "", "RECO"),
    hbheNoiseFilter = cms.InputTag("HBHENoiseFilterResultProducer","HBHENoiseFilterResult"),
    hbheTightNoiseFilter = cms.InputTag("HBHENoiseFilterResultProducer","HBHENoiseFilterResultRun2Tight"),
    hbheIsoNoiseFilter = cms.InputTag("HBHENoiseFilterResultProducer","HBHEIsoNoiseFilterResult"),
    BadChargedCandidateFilter = cms.InputTag("BadChargedCandidateFilter",""),
    BadMuonFilter = cms.InputTag("BadPFMuonFilter",""),

    lheInfo = cms.InputTag("externalLHEProducer", "", "LHE"),
    genInfo = cms.InputTag("generator", "", "GEN"),
    puInfo = cms.InputTag("addPileupInfo", "", "HLT"), #uncomment if no pre-mixing
    #puInfo = cms.InputTag("mixData", "", "HLT"), #uncomment for samples with pre-mixed pileup
    hcalNoiseInfo = cms.InputTag("hcalnoise", "", "RECO"),

    secondaryVertices = cms.InputTag("slimmedSecondaryVertices", "", "RECO"),

    rhoAll = cms.InputTag("fixedGridRhoAll", "", "RECO"),
    rhoFastjetAll = cms.InputTag("fixedGridRhoFastjetAll", "", "RECO"),
    rhoFastjetAllCalo = cms.InputTag("fixedGridRhoFastjetAllCalo", "", "RECO"),
    rhoFastjetCentralCalo = cms.InputTag("fixedGridRhoFastjetCentralCalo", "", "RECO"),
    rhoFastjetCentralChargedPileUp = cms.InputTag("fixedGridRhoFastjetCentralChargedPileUp", "", "RECO"),
    rhoFastjetCentralNeutral = cms.InputTag("fixedGridRhoFastjetCentralNeutral", "", "RECO"),

    beamSpot = cms.InputTag("offlineBeamSpot", "", "RECO"),

    ebRecHits = cms.InputTag("ecalRecalibRecHit", "recalibEcalRecHitsEB"),
    eeRecHits = cms.InputTag("ecalRecalibRecHit", "recalibEcalRecHitsEE"),
    esRecHits = cms.InputTag("reducedEgamma", "reducedESRecHits", "RECO"),
    ebeeClusters = cms.InputTag("reducedEgamma", "reducedEBEEClusters", "RECO"),
    esClusters = cms.InputTag("reducedEgamma", "reducedESClusters", "RECO"),
    conversions = cms.InputTag("reducedEgamma", "reducedConversions", "RECO"),
    singleLegConversions = cms.InputTag("reducedEgamma", "reducedSingleLegConversions", "RECO"),
    gedGsfElectronCores = cms.InputTag("reducedEgamma", "reducedGedGsfElectronCores", "RECO"),
    gedPhotonCores = cms.InputTag("reducedEgamma", "reducedGedPhotonCores", "RECO"),
    superClusters = cms.InputTag("reducedEgamma", "reducedSuperClusters", "RECO"),

    lostTracks = cms.InputTag("lostTracks", "", "RECO"),
    mvaGeneralPurposeValuesMap     = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16GeneralPurposeV1Values"),
    mvaGeneralPurposeCategoriesMap = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16GeneralPurposeV1Categories"),
    mvaHZZValuesMap     = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16HZZV1Values"),
    mvaHZZCategoriesMap = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16HZZV1Categories"),
)

#run
process.p = cms.Path( 
                      process.egmGsfElectronIDSequence *
                      process.recalib_sequence *
                      #process.BadChargedCandidateFilter*
                      #process.BadPFMuonFilter*
                      process.unpackedTracksAndVertices *
                      process.ntuples)