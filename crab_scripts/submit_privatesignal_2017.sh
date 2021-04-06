source /cvmfs/cms.cern.ch/crab3/crab.sh

for lambda in 100 150 200 250 300 350 400
do
        for ctau in 10000
        do
                subfile=submit/GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                inputDataset=`dasgoclient --query="dataset=/GMSB_L${lambda}TeV*Ctau${ctau}cm_13TeV-pythia8/zhicaiz*CMSSW_9_3_6*GMSB_L${lambda}TeV*Ctau${ctau}cm*22Apr2019*/* instance=prod/phys03"`
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_MC2017_GMSB_L${lambda}TeV_Ctau-${ctau}cm_10May2019_private'" >> ${subfile} 
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
                echo "config.Data.inputDBS = 'phys03'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC2017/MC2017PrivateGMSB/'" >> ${subfile} 
                crab submit -c ${subfile} 
        done

        for ctau in 1 50 100
        do
                subfile=submit/GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                inputDataset=`dasgoclient --query="dataset=/GMSB_L${lambda}TeV*Ctau${ctau}cm_13TeV-pythia8/zhicaiz-crab_CMSSW_9_4_7_GMSB_L${lambda}TeV*Ctau${ctau}cm_MINIAODSIM_CaltechT2_10May2019*/* instance=prod/phys03"`
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_MC2017_GMSB_L${lambda}TeV_Ctau-${ctau}cm_10May2019_private'" >> ${subfile} 
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
                echo "config.Data.inputDBS = 'phys03'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC2017/MC2017PrivateGMSB/'" >> ${subfile} 
                crab submit -c ${subfile} 
        done
done
