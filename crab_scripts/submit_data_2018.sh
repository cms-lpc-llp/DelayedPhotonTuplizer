#source /cvmfs/cms.cern.ch/crab3/crab_slc6.sh.standalone
source /cvmfs/cms.cern.ch/crab3/crab.sh

if [ ! -d submit ];
then
    mkdir submit
fi
#
#for PS in 'EGamma'
#do
#        for era in A B C
#        do
#                subfile=submit/${PS}_Run2018${era}.py
#                query_="dasgoclient --query=\"dataset=/${PS}/Run2018${era}-17Sep2018-v*/MINIAOD* instance=prod/global\""
#                inputDataset=`eval ${query_}`
#                echo ${inputDataset}
#                echo "from WMCore.Configuration import Configuration" > ${subfile}
#                echo "config = Configuration()" >> ${subfile}
#                echo "" >> ${subfile}
#                echo "config.section_(\"General\")" >> ${subfile}
#                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_Data2018_${PS}_Run2018${era}'" >> ${subfile} 
#                echo "config.General.workArea = 'crab'" >> ${subfile} 
#                echo "" >> ${subfile} 
#                echo "config.section_(\"JobType\")" >> ${subfile} 
#                echo "config.JobType.pluginName = 'Analysis'" >> ${subfile} 
#                echo "config.JobType.psetName = '${CMSSW_BASE}/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_Data_2018ABC_Rereco_EcalRechits_OOTpho.py'" >> ${subfile} 
#                echo "config.JobType.allowUndistributedCMSSW = True" >> ${subfile} 
#                echo "" >> ${subfile} 
#                echo "config.section_(\"Data\")" >> ${subfile} 
#                echo "config.Data.publication = False" >> ${subfile} 
#                echo "config.Data.inputDataset = '${inputDataset}'" >> ${subfile} 
#                echo "config.Data.splitting = 'Automatic'" >> ${subfile} 
#                echo "config.Data.lumiMask = '/afs/cern.ch/cms/CAF/CMSCOMM/COMM_DQM/certification/Collisions18/13TeV/ReReco/Cert_314472-325175_13TeV_17SeptEarlyReReco2018ABC_PromptEraD_Collisions18_JSON.txt'" >> ${subfile} 
#                echo "" >> ${subfile} 
#                echo "config.section_(\"Site\")" >> ${subfile} 
#                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
#                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/Data2018_pho_corr/'" >> ${subfile} 
#                crab submit -c ${subfile} 
#        done
#done
#

for PS in 'EGamma'
do
        for era in D
        do
                subfile=submit/${PS}_Run2018${era}.py
                query_="dasgoclient --query=\"dataset=/${PS}/Run2018${era}-PromptReco-v2/MINIAOD instance=prod/global\""
                inputDataset=`eval ${query_}`
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_Data2018_${PS}_Run2018${era}'" >> ${subfile} 
                echo "config.General.workArea = 'crab'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"JobType\")" >> ${subfile} 
                echo "config.JobType.pluginName = 'Analysis'" >> ${subfile} 
                echo "config.JobType.psetName = '${CMSSW_BASE}/src/Tuplizer/DelayedPhotonTuplizer/python/razorTuplizer_Data_2018D_PromptReco_EcalRechits_OOTpho.py'" >> ${subfile} 
                echo "config.JobType.allowUndistributedCMSSW = True" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Data\")" >> ${subfile} 
                echo "config.Data.publication = False" >> ${subfile} 
                echo "config.Data.inputDataset = '${inputDataset}'" >> ${subfile} 
                echo "config.Data.splitting = 'Automatic'" >> ${subfile} 
                echo "config.Data.lumiMask = '/afs/cern.ch/cms/CAF/CMSCOMM/COMM_DQM/certification/Collisions18/13TeV/ReReco/Cert_314472-325175_13TeV_17SeptEarlyReReco2018ABC_PromptEraD_Collisions18_JSON.txt'" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/Data2018_pho_corr/'" >> ${subfile} 
                crab submit -c ${subfile} 
        done
done
