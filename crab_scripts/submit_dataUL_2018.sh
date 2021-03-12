source /cvmfs/cms.cern.ch/crab3/crab.sh

if [ ! -d submit ];
then
    mkdir submit
fi

for PS in 'EGamma'
do
        for era in D
        do
                subfile=submit/${PS}_Run2018${era}UL.py
                query_="dasgoclient --query=\"dataset=/${PS}/Run2018${era}-12Nov2019_UL2018-v4/MINIAOD instance=prod/global\""
                inputDataset=`eval ${query_}`
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_DataUL2018_${PS}_Run2018${era}_copy'" >> ${subfile} 
                echo "config.General.workArea = 'crab'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"JobType\")" >> ${subfile} 
                echo "config.JobType.pluginName = 'Analysis'" >> ${subfile} 
                echo "config.JobType.psetName = '${CMSSW_BASE}/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_DataUL_2018D_PromptReco_EcalRechits_OOTpho.py'" >> ${subfile} 
                echo "config.JobType.allowUndistributedCMSSW = True" >> ${subfile} 
                echo "config.JobType.inputFiles = ['EcalTimeCalibConstants_2018_RunD_UL_Corr_v2.db']" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Data\")" >> ${subfile} 
                echo "config.Data.publication = False" >> ${subfile} 
                echo "config.Data.inputDataset = '${inputDataset}'" >> ${subfile} 
                echo "config.Data.splitting = 'LumiBased'" >> ${subfile} 
                echo "config.Data.unitsPerJob = 100" >> ${subfile}
                #echo "config.Data.splitting = 'Automatic'" >> ${subfile} 
                echo "config.Data.lumiMask = 'https://cms-service-dqm.web.cern.ch/cms-service-dqm/CAF/certification/Collisions18/13TeV/Legacy_2018/Cert_314472-325175_13TeV_Legacy2018_Collisions18_JSON.txt'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/DataUL2018/'" >> ${subfile} 
                crab submit -c ${subfile} 
        done
done
