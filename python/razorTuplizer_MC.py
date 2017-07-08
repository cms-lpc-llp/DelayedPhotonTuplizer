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
        #'/store/mc/RunIISpring16MiniAODv1/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8/MINIAODSIM/PUSpring16_80X_mcRun2_asymptotic_2016_v3_ext1-v1/20000/0017320C-7BFC-E511-9B2D-0CC47A4C8E34.root'
        #'/store/mc/RunIISpring16MiniAODv1/SMS-T2bH_mSbottom-300_mLSP-1_TuneCUETP8M1_13TeV-madgraphMLM-pythia8/MINIAODSIM/PUSpring16RAWAODSIM_80X_mcRun2_asymptotic_2016_v3-v1/30000/329EF9EB-C217-E611-A0A1-0CC47A6C1818.root'
#        '/store/mc/RunIISpring16MiniAODv2/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8/MINIAODSIM/PUSpring16RAWAODSIM_80X_mcRun2_asymptotic_2016_miniAODv2_v0_ext1-v1/00000/001B3734-EE39-E611-9D0B-A0000420FE80.root'
         '/store/mc/RunIISummer16MiniAODv2/DYJetsToLL_M-50_TuneCUETP8M1_13TeV-madgraphMLM-pythia8/MINIAODSIM/PUMoriond17_80X_mcRun2_asymptotic_2016_TrancheIV_v6_ext1-v2/120000/0EA60289-18C4-E611-8A8F-008CFA110AB4.root'
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
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_condDBv2_cff')
process.load('Configuration.Geometry.GeometryIdeal_cff')
process.load("Configuration.StandardSequences.MagneticField_cff")

#------ Declare the correct global tag ------#

process.GlobalTag.globaltag = '80X_mcRun2_asymptotic_2016_TrancheIV_v8'

#------ If we add any inputs beyond standard miniAOD event content, import them here ------#

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

#list input collections
process.ntuples = cms.EDAnalyzer('RazorTuplizer', 
    isData = cms.bool(False),    
    useGen = cms.bool(True),
    isFastsim = cms.bool(False),
    enableTriggerInfo = cms.bool(True),                                 
    enableEcalRechits = cms.bool(False), 
    triggerPathNamesFile = cms.string("SUSYBSMAnalysis/RazorTuplizer/data/RazorHLTPathnames.dat"),
    eleHLTFilterNamesFile = cms.string("SUSYBSMAnalysis/RazorTuplizer/data/RazorElectronHLTFilterNames.dat"),
    muonHLTFilterNamesFile = cms.string("SUSYBSMAnalysis/RazorTuplizer/data/RazorMuonHLTFilterNames.dat"),
    photonHLTFilterNamesFile = cms.string("SUSYBSMAnalysis/RazorTuplizer/data/RazorPhotonHLTFilterNames.dat"),

    vertices = cms.InputTag("offlineSlimmedPrimaryVertices"),
    
    muons = cms.InputTag("slimmedMuons"),
    electrons = cms.InputTag("slimmedElectrons"),
    taus = cms.InputTag("slimmedTaus"),
    photons = cms.InputTag("slimmedPhotons"),
    jets = cms.InputTag("slimmedJets"),
    jetsPuppi = cms.InputTag("slimmedJetsPuppi"),
    jetsAK8 = cms.InputTag("selectedPatJetsAK8PFCHS"),
    puppiSDjetLabel = cms.InputTag('packedPatJetsAK8PFPuppiSoftDrop'),
    mets = cms.InputTag("slimmedMETs","","PAT"),
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
    triggerObjects = cms.InputTag("selectedPatTrigger"),
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
    esClusters = cms.InputTag("reducedEgamma", "reducedESClusters", "PAT"),
    conversions = cms.InputTag("reducedEgamma", "reducedConversions", "PAT"),
    singleLegConversions = cms.InputTag("reducedEgamma", "reducedSingleLegConversions", "PAT"),
    gedGsfElectronCores = cms.InputTag("reducedEgamma", "reducedGedGsfElectronCores", "PAT"),
    gedPhotonCores = cms.InputTag("reducedEgamma", "reducedGedPhotonCores", "PAT"),
    superClusters = cms.InputTag("reducedEgamma", "reducedSuperClusters", "PAT"),

    lostTracks = cms.InputTag("lostTracks", "", "PAT"),
    mvaGeneralPurposeValuesMap     = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16GeneralPurposeV1Values"),
    mvaGeneralPurposeCategoriesMap = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16GeneralPurposeV1Categories"),
    mvaHZZValuesMap     = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16HZZV1Values"),
    mvaHZZCategoriesMap = cms.InputTag("electronMVAValueMapProducer:ElectronMVAEstimatorRun2Spring16HZZV1Categories")
)

#run electron ID sequence
process.egmIDPath = cms.Path(process.egmGsfElectronIDSequence)

#run met bad track filters 
process.hipMetFiltersPath = cms.Path(process.BadChargedCandidateFilter *
                                     process.BadPFMuonFilter)

#####################################################################
#Jet Reclustering for AK8 jets
#####################################################################
process.options = cms.untracked.PSet( allowUnscheduled = cms.untracked.bool(True) )

from JMEAnalysis.JetToolbox.jetToolbox_cff import jetToolbox
listBTagInfos = [
     'pfInclusiveSecondaryVertexFinderTagInfos',
     ]
listBtagDiscriminatorsAK4 = [ 
		'pfJetProbabilityBJetTags',
		'pfCombinedInclusiveSecondaryVertexV2BJetTags',
		'pfCombinedMVAV2BJetTags',
		'pfCombinedCvsLJetTags',
		'pfCombinedCvsBJetTags',
		]
listBtagDiscriminatorsAK8 = [ 
		'pfJetProbabilityBJetTags',
		'pfCombinedInclusiveSecondaryVertexV2BJetTags',
		'pfCombinedMVAV2BJetTags',
		'pfCombinedCvsLJetTags',
		'pfCombinedCvsBJetTags',
		'pfBoostedDoubleSecondaryVertexAK8BJetTags',
		'pfBoostedDoubleSecondaryVertexCA15BJetTags',
		]
# JER Twiki:
#   https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookJetEnergyResolution#Scale_factors
# Get Latest txt files from:
#   https://github.com/cms-jet/JRDatabase/tree/master/textFiles
jetAlgoAK8      = 'AK8PFchs'
jetAlgoAK8Puppi = 'AK8PFPuppi'

ak8Cut='pt > 170 && abs(eta) < 2.4'

jetToolbox( process, 
		'ak8', 
		'analysisPath', 
		'edmNtuplesOut', 
		runOnMC=True, 
		#updateCollection=jetAK8Label, 
		#updateCollectionSubjets=subjetAK8Label, 
		#JETCorrPayload=jetAlgoAK8, 
		addSoftDropSubjets=True, 
		addTrimming=True, 
		rFiltTrim=0.1, 
		addPruning=True, 
		addFiltering=True, 
		addSoftDrop=True, 
		addNsub=True, 
		bTagInfos=listBTagInfos, 
		bTagDiscriminators=listBtagDiscriminatorsAK8, 
		Cut=ak8Cut, 
		addNsubSubjets=True, 
		subjetMaxTau=4 )

jetToolbox( process, 
		'ak8', 
		'analysisPath', 
		'edmNtuplesOut', 
		runOnMC=True, 
		PUMethod='Puppi', 
		addSoftDropSubjets=True, 
		addTrimming=True, 
		addPruning=True, 
		addFiltering=True, 
		addSoftDrop=True, 
		addNsub=True, 
		bTagInfos=listBTagInfos, 
		bTagDiscriminators=listBtagDiscriminatorsAK8, 
		Cut=ak8Cut, 
		addNsubSubjets=True, 
		subjetMaxTau=4 )

jLabelAK8	= 'selectedPatJetsAK8PFCHS'
jLabelAK8Puppi  = 'selectedPatJetsAK8PFPuppi'

process.ak8PFJetsPuppiValueMap = cms.EDProducer("RecoJetToPatJetDeltaRValueMapProducer",
				    src = cms.InputTag("ak8PFJetsCHS"),
				    matched = cms.InputTag("patJetsAK8PFPuppi"),                                         
				    distMax = cms.double(0.8),
				    values = cms.vstring([
					'userFloat("NjettinessAK8Puppi:tau1")',
					'userFloat("NjettinessAK8Puppi:tau2")',
					'userFloat("NjettinessAK8Puppi:tau3")',
          				'userFloat("ak8PFJetsPuppiSoftDropMass")', 
					'pt','eta','phi','mass'
				    ]),
				    valueLabels = cms.vstring( [
					'NjettinessAK8PuppiTau1',
					'NjettinessAK8PuppiTau2',
					'NjettinessAK8PuppiTau3',
					'softDropMassPuppi',
					'pt','eta','phi','mass'
				    ])
)

getattr( process, 'patJetsAK8PFCHS' ).userData.userFloats.src += [
                cms.InputTag('ak8PFJetsPuppiValueMap','NjettinessAK8PuppiTau1'),
		cms.InputTag('ak8PFJetsPuppiValueMap','NjettinessAK8PuppiTau2'),
		cms.InputTag('ak8PFJetsPuppiValueMap','NjettinessAK8PuppiTau3'),
                cms.InputTag('ak8PFJetsPuppiValueMap','softDropMassPuppi'),
		cms.InputTag('ak8PFJetsPuppiValueMap','pt'),
		cms.InputTag('ak8PFJetsPuppiValueMap','eta'),
		cms.InputTag('ak8PFJetsPuppiValueMap','phi'),
		cms.InputTag('ak8PFJetsPuppiValueMap','mass'),
]

#####################################################################
#####################################################################

process.ntupleStep = cms.Path(process.ntuples)

process.schedule = cms.Schedule( process.egmIDPath,
                                 process.hipMetFiltersPath,                                 
                                 process.ntupleStep)
