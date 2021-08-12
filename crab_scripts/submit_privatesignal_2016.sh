source /cvmfs/cms.cern.ch/crab3/crab.sh

for lambda in 100 #150 200 250 300 350 400
do
        for ctau in 800 # 50 100 1200 10000
        do
                inputDataset=`dasgoclient --query="dataset=/GMSB_L${lambda}TeV*Ctau${ctau}cm_13TeV-pythia8/*CMSSW_9_3_6*22Apr2019*/* instance=prod/phys03"`
                if [[ -z "${inputDataset}" ]]; then
                    inputDataset=`dasgoclient --query="dataset=/GMSB_L${lambda}TeV*Ctau${ctau}cm_13TeV-pythia8/*CMSSW_9_3_6*/* instance=prod/phys03"`
                fi
                if [ -n "${inputDataset}" ]; then
                    echo "---------------"
                    echo "${inputDataset}"
                    subfile=submit/GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                    echo "from WMCore.Configuration import Configuration" > ${subfile}
                    echo "config = Configuration()" >> ${subfile}
                    echo "" >> ${subfile}
                    echo "config.section_(\"General\")" >> ${subfile}
                    echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_MC2016_GMSB_L${lambda}TeV_Ctau-${ctau}cm_22Apr2019_private'" >> ${subfile} 
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
                    echo "config.Data.unitsPerJob = 50" >> ${subfile} 
                    echo "" >> ${subfile} 
                    echo "config.section_(\"Site\")" >> ${subfile} 
                    echo "config.Site.storageSite = 'T2_US_Caltech_Ceph'" >> ${subfile} 
                    echo "config.Data.inputDBS = 'phys03'" >> ${subfile} 
                    echo "config.Data.outLFNDirBase = '/store/group/phys_llp/Run2DelayedPhotonNtuple/2016/MC2016PrivateGMSB/'" >> ${subfile} 
                    crab submit -c ${subfile}
                fi  
        done
done
