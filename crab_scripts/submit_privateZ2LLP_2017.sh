source /cvmfs/cms.cern.ch/crab3/crab.sh

for Zp in 500
do
        for s in 100
        do
                subfile=submit/ZpToSSTo4Photon_mZp${Zp}_ms${s}_private.py
                inputDataset=`dasgoclient --query="dataset=/ZpToSSTo4Photon_mZp${Zp}_ms${s}_pl1000/apresyan-crab_PrivateProduction_Fall18_DR_step3_ZpToSSTo4Photon_mZp${Zp}_ms${s}_pl1000_batch2_v1-3ee3afd6b5a1410aea6d0b4d52723d06/* instance=prod/phys03"`
                echo "from WMCore.Configuration import Configuration" > ${subfile}
                echo "config = Configuration()" >> ${subfile}
                echo "" >> ${subfile}
                echo "config.section_(\"General\")" >> ${subfile}
                echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler_MC2017_ZpToSSTo4Photon_mZp${Zp}_ms${s}'" >> ${subfile} 
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
                echo "config.Data.unitsPerJob = 10" >> ${subfile}
                echo "" >> ${subfile} 
                echo "config.section_(\"Site\")" >> ${subfile} 
                echo "config.Site.storageSite = 'T2_US_Caltech_Ceph'" >> ${subfile} 
                echo "config.Data.inputDBS = 'phys03'" >> ${subfile} 
                echo "config.Data.outLFNDirBase = '/store/group/phys_llp/Run2DelayedPhotonNtuple/2017/MC2017PrivateZpToSSTo4Photon/'" >> ${subfile} 
                crab submit -c ${subfile} 
        done
done
