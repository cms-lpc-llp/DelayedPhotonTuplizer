import os, sys
import glob
import subprocess
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-s","--sample", help='Sample to check')
parser.add_argument("-r","--resubmit", action='store_true', default=False, help='Whether to resubmit failed jobs even if task is not finished')
parser.add_argument("-k","--kill", action='store_true', default=False, help='Killed unfinished tasks')
args = parser.parse_args()

if not args.sample: 
    to_check = '*'
else:
    to_check = '*{}*'.format(args.sample)
cmssw = os.environ["CMSSW_BASE"]
if cmssw == "": 
    print("CMSSW environment not found.")
    sys.exit(0)
base_dir = cmssw + "/src/Tuplizer/DelayedPhotonTuplizer/crab_scripts/"
tasks = glob.glob("{}/crab/{}".format(base_dir, to_check))
for task in tasks:
    print("\n*********\n{}".format(task))
    cmd = "crab status -d {}".format(task)
    proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = proc.communicate()
    lines = stdout.split('\n')
    isFailed = False
    isCompleted = False
    endPrint = None
    for i, line in enumerate(lines):
        if "Status on the scheduler" in line:
            if 'FAILED' in line: 
                isFailed = True
            if 'COMPLETED' in line:
                isCompleted = True
            beginPrint = i
        if "transferring" in line:
            endPrint = i+1
    if not endPrint: endPrint = beginPrint + 5
    print("\n".join(lines[beginPrint:endPrint]))
    if (args.resubmit or isFailed) and not args.kill: 
        cmd = 'crab resubmit -d {}'.format(task)
        print(cmd)
        subprocess.call(cmd, shell=True)
    if (args.kill and not isCompleted):
        cmd = 'crab kill -d {}'.format(task)
        print(cmd)
        subprocess.call(cmd, shell=True)

