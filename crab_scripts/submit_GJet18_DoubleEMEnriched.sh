source /cvmfs/cms.cern.ch/crab3/crab.sh

if [ ! -d submit ];
then
    mkdir submit
fi

for PT in \
    20to40 \
    40toInf \
    20toInf
do
                subfile=submit_Autumn18/GJet_Pt${PT}_DoubleEMEnriched_TuneCP5_13TeV_pythia8.py
                query_="dasgoclient --query=\"dataset=/GJet_Pt-${PT}*DoubleEMEnriched*/RunIIAutumn18MiniAOD-102X_upgrade2018_realistic_v15*/MINIAODSIM* instance=prod/global\""
                inputDataset=`eval ${query_}`
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prodSummer18_Run2DelayedPhotonNtupler_GJet_Pt_${PT}_DoubleEMEnriched_TuneCP5_13TeV_pythia8'" >> ${subfile} 
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
                echo "config.Data.splitting = 'LumiBased'" >> ${subfile} 
                echo "config.Data.unitsPerJob = 1000" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC2018/GJet_DoubleEMEnriched/'" >> ${subfile} 
                echo "Written to ${subfile}"
                crab submit -c ${subfile} 
done