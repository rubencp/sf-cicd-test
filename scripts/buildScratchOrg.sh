#!/usr/bin/env bash
if [ -z $1 ]
  then
    echo "No argument for a branch name. Recommended format is <initials of developer>.<User story id>"
    exit 1
fi
# Set tracker for time elapsed
SECONDS=0

# Creating function to display echo successes with a bold green
function echo_success() {
  local green='\033[1;32m'
  local no_color='\033[0m'
  echo -e "${green}$1${no_color}"
}
# Creating function to display echo failures with a bold red
function echo_fail() {
  local red='\033[1;31m'
  local no_color='\033[0m'
  echo -e "${red}$1${no_color}"
}
# Creating function to display neutral echo failures with a light blue
function echo_neutral() {
  local blue='\033[1;34m'
  local no_color='\033[0m'
  echo -e "${blue}$1${no_color}"
}

# create dev scratch Org 
sf env create scratch --definition-file config/project-scratch-def.json -a $1 --set-default --duration-days 7 --wait 100 || {
    echo_fail "Scratch Org creation failed"
    exit 1
}

#install Einstein Package
#echo y | sfdx force:package:beta:install --package 04t58000000SGw3 --target-org $1 -w 90 --noprompt && echo_success "Succesfully installed the Einstein Package 🧐" || {
#    echo_fail "Einstein Package installation failed"
#    exit 1
#}

#install FlowActionsBasePack package (Version 3.0.0 Managed)
#https://unofficialsf.com/flow-action-and-screen-component-basepacks/
#echo_attention y | sfdx force:package:install --package 04t8b000001Eh4YAAS --target-org $1 -w 10 || {
#    exit 1
#}

#install FlowScreenComponentsBasePack package (Version 3.0.6 Unmanaged)
#https://unofficialsf.com/flow-action-and-screen-component-basepacks/
#echo y | sfdx force:package:install --package 04t5G000003rUvVQAU --target-org $1 -w 10 || {
#    exit 1
#}

#install Datatable 4.0.3 package
#https://unofficialsf.com/datatable-lightning-web-component-for-flow-screens-2/#Installation
#echo y | sfdx force:package:install --package 04t5G000003rUvLQAU --target-org $1 -w 10 || {
#    exit 1
#}

#install Launch Flow Modal package
#https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000FZRGPUA5
#echo y | sfdx force:package:install --package 04t2E000003VsuMQAS --target-org $1 -w 10 || {
#    exit 1
#}

# sleep to avoid "The org cannot be found"
sleep 7

#Set as defult org
#sfdx config:set defaultusername=$1

# Set Email Deliverability to No-Access
# sfdx browserforce:apply -f config/browserforce-email-no-access.json

#push metadata to the empty scratch org
sfdx force:source:push -f --target-org $1 -g -w 300 && echo_success "Succesfully pushed the metadata to the empty scratch org 😎" || {
    echo_fail "Not possible to push the metadata to scratch Org ❌"
    exit 1
}

# Assign custom admin permission set to user
sfdx force:user:permset:assign --target-org $1 -n "sb_Admin" && echo_success "You now have the sb_Admin permission Set assigned to you 🤺" ||
    echo_fail "Not possible to assign the sb_Admin permission set. Please assign it manually ❌"

# sleep to avoid "The org cannot be found"
sleep 7

# Import data to scratch org
#sfdx force:data:tree:import --target-org $1 -p ./data/plan.json --loglevel DEBUG && echo_success "Added some data to play around with 🧾" ||
#    echo_fail "Not possible to insert the data records. However, you still have some standard data records in your scratch org."

# Deploy network access setting so devs can login in each other SOs without code verficiation
#sfdx force:source:deploy --target-org $1 -p post-creation-so/settings/Security.settings-meta.xml

# Update Custom Settings fields to true so that validation/flows run per deafult when triggered
#sfdx force:apex:execute --target-org $1 --apexcodefile scripts/apex/updateGlobalSwitchSettings.apex && echo_success "Updated the global switch Object 🏂" || echo_fail "Not possible to update the global switch ❌"

# Update account record types
#sfdx force:apex:execute --target-org $1 --apexcodefile scripts/apex/updateAccountRecordTypes.apex && echo_success "Updated some accounts data with 'Prospect' Record Type 👽" || echo_fail "Not possible to update the the account record types ❌"

# Reset tracking to avoid unnessesary changes like layouts being pulled
sfdx force:source:tracking:reset --target-org $1 --noprompt

# Sleep after reseting the source control
sleep 5

# Count and display the time it takes for creating the SO
duration=$SECONDS
echo_neutral "🤖This script build took $(($duration / 60)) minutes and $(($duration % 60)) seconds to complete 🕓."

# Opens the scratch Org in a browser Tab when the build is finished
echo_success "All done! Your new scratch org with open in your browser tab in a few seconds 🎮"
sfdx force:org:open --target-org $1
