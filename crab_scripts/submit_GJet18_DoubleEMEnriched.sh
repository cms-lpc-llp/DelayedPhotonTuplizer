source /cvmfs/cms.cern.ch/crab3/crab.sh

if [ ! -d submit ];
then
    mkdir submit
fi

for HT in \
    40To100 \
    100To200 \
    200To400 \
    400To600 \
    600ToInf \

do
                subfile=submit/GJets_HT-${HT}_DoubleEMEnriched_MGG80ToInf.py
                query_="dasgoclient --query=\"dataset=/GJets_HT-${HT}*DoubleEMEnriched_MGG-80toInf*/RunIIAutumn18MiniAOD*/MINIAODSIM instance=prod/global\""
                inputDataset=`eval ${query_}`
#                if [[ -z  $inputDataset  ]]; then
#                    query_="dasgoclient --query=\"dataset=/GJet_HT${HT}*/RunIISummer16MiniAODv3*/MINIAODSIM instance=prod/global\""
#                    inputDataset=`eval ${query_}`
#                fi
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prodAutumn18_Run2DelayedPhotonNtupler_GJet_${HT}_DoubleEMEnriched_TuneCUETP8M1_13TeV_pythia8'" >> ${subfile} 
                echo "config.General.workArea = 'crab'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"JobType\")" >> ${subfile} 
                echo "config.JobType.pluginName = 'Analysis'" >> ${subfile} 
                echo "config.JobType.psetName = '${CMSSW_BASE}/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_MC_Autumn18_EcalRechits_OOT.py'" >> ${subfile} 
                echo "config.JobType.allowUndistributedCMSSW = True" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Data\")" >> ${subfile} 
                echo "config.Data.publication = False" >> ${subfile} 
                echo "config.Data.inputDataset = '${inputDataset}'" >> ${subfile} 
                echo "config.Data.splitting = 'Automatic'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC2018/GJets_DoubleEMEnriched_pho_corr/'" >> ${subfile} 
                echo "Written to ${subfile}"
                crab submit -c ${subfile} 
done


for Pt in \
    PtG-20MGG-40To80 \
    PtG-20MGG-80 \
    PtG-40MGG-80 \

do
                subfile=submit/GJets_DoubleEMEnriched_${Pt}.py
                query_="dasgoclient --query=\"dataset=/GJets_DoubleEMEnriched_${Pt}*/RunIIAutumn18MiniAOD*/MINIAODSIM instance=prod/global\""
                inputDataset=`eval ${query_}`
#                if [[ -z  $inputDataset  ]]; then
#                    query_="dasgoclient --query=\"dataset=/GJet_HT${HT}*/RunIISummer16MiniAODv3*/MINIAODSIM instance=prod/global\""
#                    inputDataset=`eval ${query_}`
#                fi
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prodAutumn18_Run2DelayedPhotonNtupler_GJets_DoubleEMEnriched_${Pt}'" >> ${subfile} 
                echo "config.General.workArea = 'crab'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"JobType\")" >> ${subfile} 
                echo "config.JobType.pluginName = 'Analysis'" >> ${subfile} 
                echo "config.JobType.psetName = '${CMSSW_BASE}/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_MC_Autumn18_EcalRechits_OOT.py'" >> ${subfile} 
                echo "config.JobType.allowUndistributedCMSSW = True" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Data\")" >> ${subfile} 
                echo "config.Data.publication = False" >> ${subfile} 
                echo "config.Data.inputDataset = '${inputDataset}'" >> ${subfile} 
                echo "config.Data.splitting = 'Automatic'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC2018/GJets_DoubleEMEnriched_pho_corr/'" >> ${subfile} 
                echo "Written to ${subfile}"
                crab submit -c ${subfile} 
done

