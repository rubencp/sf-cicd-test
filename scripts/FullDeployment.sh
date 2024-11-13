#!/bin/bash
# Run full deployment command only if the generated package contains new or changed metadata
echo "---- 🎁 Deploying new/changed metadata ❇🎁 ----"
sfdx force:source:deploy -p force-app --testlevel NoTestRun --verbose -w 300 || exit 1

# Run full destructive deployment command only if the generated package contains destructive metadata
if grep -q '<types>' ./changed-sources/destructiveChanges/destructiveChanges.xml ; then
  echo "---- ❗ Deploying destructive metadata ❗ ----"
  #sfdx force:mdapi:deploy -d "changed-sources/destructiveChanges" --ignorewarnings --verbose -w 300 || exit 1
else
  echo "---- 📭 No destrutive metadata to deploy 📭 ----"
fi
