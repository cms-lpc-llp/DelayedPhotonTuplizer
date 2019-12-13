import os
import glob
import subprocess
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-s","--sample", help='Sample to check')
parser.add_argument("-r","--resubmit", action='store_true', default=False, help='Whether to resubmit failed jobs')
args = parser.parse_args()

to_check = args.sample

tasks = glob.glob("crab/*{}*".format(to_check))
for task in tasks:
    print("\n*********\n{}".format(task))
    cmd = "crab status -d {}".format(task)
    proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = proc.communicate()
    lines = stdout.split('\n')
    isComplete = False
    endPrint = None
    for i, line in enumerate(lines):
        if "Status on the scheduler" in line:
            if 'COMPLETED' in line: 
                isComplete = True
            beginPrint = i
        if "transferring" in line:
            endPrint = i+1
    if not endPrint: endPrint = beginPrint + 5
    print("\n".join(lines[beginPrint:endPrint]))
    if args.resubmit: 
        cmd = 'crab resubmit -d {}'.format(task)
        print(cmd)
        subprocess.call(cmd, shell=True)

