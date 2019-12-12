for lambda in 100 150 200 250 300 350 400
do
        for ctau in 10 200 400 600 800 1000 1200
        do
                subfile=submit/GMSB_L-${lambda}TeV_Ctau-${ctau}cm_central.py
                query_="dasgoclient --query=\"dataset=/GMSB_L-${lambda}TeV*Ctau-${ctau}cm*/RunIIFall17MiniAODv2*/* instance=prod/global\""
                inputDataset=`eval ${query_}`
                echo ${inputDataset}
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_MC2017_GMSB_L${lambda}TeV_Ctau-${ctau}cm_central'" >> ${subfile} 
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
                echo "config.Data.splitting = 'FileBased'" >> ${subfile} 
                echo "config.Data.unitsPerJob = 1" >> ${subfile} 
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC/MC2017CentralGMSB/'" >> ${subfile} 
                #crab submit -c ${subfile} 
        done
done
