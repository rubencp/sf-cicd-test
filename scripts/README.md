
sf org create shape (on Prod)
Successfully created org shape for .

sf org shape list


sfdx force:config:get defaultusername
sfdx force:config:set defaultusername=rcp-jih-1234 

# Activate Tracking
 
 sf org enable tracking --target-org barthhaas--paymentuat

 sfdx force:source:tracking:clear --target-org barthhaas--paymentuat
  - Deletes *all local* source tracking information.

 sfdx force:source:tracking:reset --target-org barthhaas--paymentuat --noprompt
  - Resets *local and remote* source tracking so that Salesforce CLI no longer registers differences between your local files and those in the org. 

sf project retrieve preview
sf project retrieve preview --ignore-conflicts --target-org barthhaas--paymentuat
sfdx retrieve:metadata:preview

sf org:login:web --alias jih-s5dev1 --instance-url https://test.salesforce.com --set-default
sf org:login:web --alias jih-s5dev2 --instance-url https://test.salesforce.com
sf org:login:web --alias jih-s5dev3 --instance-url https://test.salesforce.com
sf org:login:web --alias jih-s5dev4 --instance-url https://test.salesforce.com

# Deployment Validation

sfdx force:source:deploy --checkonly -x "manifest/DeploymentSteps/DPL-01.xml" --testlevel NoTestRun --verbose -w 300 

sf project deploy validate --manifest manifest/DeploymentSteps/JIH-CustomObjects.xml --target-org jih-s5dev4
