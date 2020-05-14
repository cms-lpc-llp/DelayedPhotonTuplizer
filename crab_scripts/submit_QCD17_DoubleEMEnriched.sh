source /cvmfs/cms.cern.ch/crab3/crab.sh

if [ ! -d submit ];
then
    mkdir submit
fi

for PT in \
    30to40 \
    40toInf \
    30toInf
do
                query_="dasgoclient --query=\"dataset=/QCD_Pt-${PT}*DoubleEMEnriched*/RunIIFall17MiniAODv2*/MINIAODSIM instance=prod/global\""
                inputDataset=`eval ${query_}`
                if [ ! -z $inputDataset ]; 
                then
                    subfile=submit/QCD_Pt${PT}_DoubleEMEnriched_TuneCUETP8M1_13TeV_pythia8.py
                    echo ${inputDataset}
                    echo "from WMCore.Configuration import Configuration" > ${subfile}
                    echo "config = Configuration()" >> ${subfile}
                    echo "" >> ${subfile}
                    echo "config.section_(\"General\")" >> ${subfile}
                    echo "config.General.requestName = 'prod_Run2DelayedPhotonNtupler2017_QCD_Pt_${PT}_DoubleEMEnriched_TuneCUETP8M1_13TeV_pythia8'" >> ${subfile} 
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
                    echo "config.Data.outLFNDirBase = '/store/group/phys_susy/razor/run2/Run2DelayedPhotonNtuple/MC2017/QCD_DoubleEMEnriched/'" >> ${subfile} 
                    echo "Written to ${subfile}"
                    crab submit -c ${subfile} 
                fi
done
