for lambda in 100 150 200 250 300 350 400
do
        for ctau in 1 50 100 10000
        do
                inputDataset=`dasgoclient --query="dataset=/GMSB_L${lambda}TeV*Ctau${ctau}cm_13TeV-pythia8/zhicaiz-crab_CMSSW_9_4_7_GMSB_L${lambda}TeV*Ctau${ctau}cm_MINIAODSIM_CaltechT2_10May2019*/* instance=prod/phys03"`
                echo "from WMCore.Configuration import Configuration" > GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config = Configuration()" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.section_(\"General\")" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_MC2017_GMSB_L${lambda}TeV_Ctau-${ctau}cm_10May2019_private'" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.General.workArea = 'crab'" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.section_(\"JobType\")" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.JobType.pluginName = 'Analysis'" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.JobType.psetName = '../python/razorTuplizer_MC_Fall17_EcalRechits_reMiniAOD_OOT.py'" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.JobType.allowUndistributedCMSSW = True" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.section_(\"Data\")" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.Data.publication = False" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.Data.inputDataset = '${inputDataset}'" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.Data.splitting = 'FileBased'" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.Data.unitsPerJob = 1" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.section_(\"Site\")" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.Site.storageSite = 'T2_US_Caltech'" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.Data.inputDBS = 'phys03'" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC/MC2017PrivateGMSB/'" >> GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
                crab submit -c GMSB_L-${lambda}TeV_Ctau-${ctau}cm_private.py
        done
done
