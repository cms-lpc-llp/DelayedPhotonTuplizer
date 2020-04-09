source /cvmfs/cms.cern.ch/crab3/crab.sh

if [ ! -d submit ];
then
    mkdir submit
fi

for HT in \
    100to200
#    50to100 \
#    200to300 \
#    300to500 \
#    500to700 \
#    700to1000 \
#    1000to1500 \
#    1500to2000 \
#    2000toInf
do
                subfile=submit_Summer16/QCD_HT${HT}_TuneCP5_13TeV_madgraph_pythia8.py
                query_="dasgoclient --query=\"dataset=/QCD_HT${HT}_TuneCUETP8M1_13TeV*/RunIISummer16MiniAODv3*/MINIAODSIM instance=prod/global\""
                inputDataset=`eval ${query_}`
                if [[ -z  $inputDataset  ]]; then
                    query_="dasgoclient --query=\"dataset=/QCD_HT${HT}*/RunIISummer16MiniAODv3*/MINIAODSIM instance=prod/global\""
                    inputDataset=`eval ${query_}`
                fi
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prodSummer16_Run2DelayedPhotonNtupler_QCD_HT${HT}_TuneCP5_13TeV_madgraph_pythia8'" >> ${subfile} 
                echo "config.General.workArea = 'crab'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"JobType\")" >> ${subfile} 
                echo "config.JobType.pluginName = 'Analysis'" >> ${subfile} 
                echo "config.JobType.psetName = '${CMSSW_BASE}/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_MC_EcalRechits_reMiniAOD_OOT.py'" >> ${subfile} 
                echo "config.JobType.allowUndistributedCMSSW = True" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Data\")" >> ${subfile} 
                echo "config.Data.publication = False" >> ${subfile} 
                echo "config.Data.inputDataset = '${inputDataset}'" >> ${subfile} 
                echo "config.Data.splitting = 'FileBased'" >> ${subfile} 
                echo "config.Data.unitsPerJob = 2" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC2016/QCD/'" >> ${subfile} 
                echo "Written to ${subfile}"
                crab submit -c ${subfile} 
done
