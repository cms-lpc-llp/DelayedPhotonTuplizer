source /cvmfs/cms.cern.ch/crab3/crab.sh

if [ ! -d submit ];
then
    mkdir submit
fi

for PS in 'DoubleEG' 'SinglePhoton'
do
        for era in C D E F G H
        do
                subfile=submit/${PS}_Run2016${era}.py
                query_="dasgoclient --query=\"dataset=/${PS}/Run2016${era}-17Jul2018*/MINIAOD* instance=prod/global\""
                inputDataset=`eval ${query_}`
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_Data2016_${PS}_Run2016${era}'" >> ${subfile} 
                echo "config.General.workArea = 'crab'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"JobType\")" >> ${subfile} 
                echo "config.JobType.pluginName = 'Analysis'" >> ${subfile} 
                echo "config.JobType.psetName = '${CMSSW_BASE}/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_Data_2016_Rereco_reMiniAOD_EcalRechits_OOTpho.py'" >> ${subfile} 
                echo "config.JobType.allowUndistributedCMSSW = True" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Data\")" >> ${subfile} 
                echo "config.Data.publication = False" >> ${subfile} 
                echo "config.Data.inputDataset = '${inputDataset}'" >> ${subfile} 
                echo "config.Data.splitting = 'Automatic'" >> ${subfile} 
                echo "config.Data.lumiMask = 'https://cms-service-dqm.web.cern.ch/cms-service-dqm/CAF/certification/Collisions16/13TeV/ReReco/Final/Cert_271036-284044_13TeV_ReReco_07Aug2017_Collisions16_JSON.txt'" >> ${subfile}
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/Data2016/'" >> ${subfile} 
                crab submit -c ${subfile} 
        done
done

# Era B needs special treatment (2 datasets). Bash string processing sucks so I will just write separate cases
for PS in 'DoubleEG' 'SinglePhoton'
do
        for era in B
        do
            i=0
            for inputDataset in "/${PS}/Run2016B-17Jul2018_ver1-v1/MINIAOD" "/${PS}/Run2016B-17Jul2018_ver2-v1/MINIAOD" 
            do
                let "i=i+1"
                subfile=submit/${PS}_Run2016${era}.py
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_Data2016_${PS}_Run2016${era}_v${i}'" >> ${subfile} 
                echo "config.General.workArea = 'crab'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"JobType\")" >> ${subfile} 
                echo "config.JobType.pluginName = 'Analysis'" >> ${subfile} 
                echo "config.JobType.psetName = '${CMSSW_BASE}/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_Data_2016_Rereco_reMiniAOD_EcalRechits_OOTpho.py'" >> ${subfile} 
                echo "config.JobType.allowUndistributedCMSSW = True" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Data\")" >> ${subfile} 
                echo "config.Data.publication = False" >> ${subfile} 
                echo "config.Data.inputDataset = '${inputDataset}'" >> ${subfile} 
                echo "config.Data.splitting = 'Automatic'" >> ${subfile} 
                echo "config.Data.lumiMask = 'https://cms-service-dqm.web.cern.ch/cms-service-dqm/CAF/certification/Collisions16/13TeV/ReReco/Final/Cert_271036-284044_13TeV_ReReco_07Aug2017_Collisions16_JSON.txt'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/Data2016/'" >> ${subfile} 
                crab submit -c ${subfile}
            done 
        done
done

