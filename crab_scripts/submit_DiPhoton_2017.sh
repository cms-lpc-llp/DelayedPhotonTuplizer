source /cvmfs/cms.cern.ch/crab3/crab.sh

if [ ! -d submit ];
then
    mkdir submit
fi

for HT in \
    40_80 \
    80toInf
do
                subfile=submit/DiPhotonJetsBox_M${HT}_Sherpa.py
                query_="dasgoclient --query=\"dataset=/DiPhotonJetsBox_M*${HT}*/RunIIFall17MiniAODv2-PU2017_12Apr2018_94X_mc2017_realistic_v14*/MINIAODSIM instance=prod/global\""
                inputDataset=`eval ${query_}`
                if [[ -z  $inputDataset  ]]; then
                    query_="dasgoclient --query=\"dataset=/DiPhotonJetsBox_M*${HT}*/RunIIFall17MiniAODv2*/MINIAODSIM instance=prod/global\""
                    inputDataset=`eval ${query_}`
                fi
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_DiPhotonJetsBox_M${HT}_Sherpa'" >> ${subfile} 
                echo "config.General.workArea = 'crab'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"JobType\")" >> ${subfile} 
                echo "config.JobType.pluginName = 'Analysis'" >> ${subfile} 
                echo "config.JobType.psetName = '${CMSSW_BASE}/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_MC_Fall17_EcalRechits_reMiniAOD_OOT.py'" >> ${subfile} 
                echo "config.JobType.allowUndistributedCMSSW = True" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Data\")" >> ${subfile} 
                echo "config.Data.publication = False" >> ${subfile} 
                echo "config.Data.inputDataset = '${inputDataset}'" >> ${subfile} 
                echo "config.Data.splitting = 'Automatic'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC2017/DiPhoton/'" >> ${subfile} 
               crab submit -c ${subfile} 
done
