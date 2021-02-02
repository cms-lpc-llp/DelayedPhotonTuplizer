source /cvmfs/cms.cern.ch/crab3/crab.sh

if [ ! -d submit ];
then
    mkdir submit
fi


for PS in DYJetsToEE
do
             subfile=submit/${PS}_2018UL.py
             query_="dasgoclient --query=\"dataset=/${PS}_M-50_TuneCP5_13TeV-madgraphMLM-pythia8/RunIISummer19UL18MiniAOD-106X_upgrade2018_realistic_v11_L1v1-v3/MINIAODSIM instance=prod/global\""
             inputDataset=`eval ${query_}`
             echo ${inputDataset}
             echo "from WMCore.Configuration import Configuration" > ${subfile}
             echo "config = Configuration()" >> ${subfile}
             echo "" >> ${subfile}
             echo "config.section_(\"General\")" >> ${subfile}
             echo "config.General.requestName = 'Run2DelayedPhotonNtupler_MCUL2018_${PS}'" >> ${subfile} 
             echo "config.General.workArea = 'crab'" >> ${subfile} 
             echo "" >> ${subfile} 
             echo "config.section_(\"JobType\")" >> ${subfile} 
             echo "config.JobType.pluginName = 'Analysis'" >> ${subfile} 
             echo "config.JobType.psetName = '${CMSSW_BASE}/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_DYJetsToEE_UL_2018_EcalRechits_OOTpho.py'" >> ${subfile} 
             echo "config.JobType.allowUndistributedCMSSW = True" >> ${subfile} 
             echo "" >> ${subfile} 
             echo "config.section_(\"Data\")" >> ${subfile} 
             echo "config.Data.publication = False" >> ${subfile} 
             echo "config.Data.inputDataset = '${inputDataset}'" >> ${subfile} 
             echo "config.Data.splitting = 'LumiBased'" >> ${subfile} 
             echo "config.Data.unitsPerJob = 1000" >> ${subfile}
             #echo "config.Data.splitting = 'Automatic'" >> ${subfile} 
             echo "" >> ${subfile} 
             echo "config.section_(\"Site\")" >> ${subfile} 
             echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
             echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MCUL2018/'" >> ${subfile} 
             crab submit -c ${subfile} 
done
