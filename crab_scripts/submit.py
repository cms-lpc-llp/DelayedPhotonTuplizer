import os, sys

SIGNAL_POINTS = {
        "Lambda": [100, 150, 200, 250, 300, 350, 400],
        "ctau": [10, 200, 400, 600, 800, 1000, 1200],
        }

SIGNAL_NAMES = []
for ld in SIGNAL_POINTS['Lambda']:
    for ct in SIGNAL_POINTS['ctau']:
        SIGNAL_NAMES.append('/GMSB_L-{}TeV_Ctau-{}cm_TuneCP5_13TeV-pythia8/RunIIFall17MiniAODv2-PU2017_12Apr2018_94X_mc2017_realistic_v14-v1/MINIAODSIM'.format(ld, ct))

print('\n'.join(SIGNAL_NAMES))
