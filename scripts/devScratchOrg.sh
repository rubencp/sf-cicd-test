#!/usr/bin/env bash
#function to delete scratchOrg and feature branch
clearSetup(){
    echo y | sfdx force:org:delete --target-org $1 --noprompt
    git checkout develop
    git branch -D feature/$1
    echo "An error occured during the scratch org creation. Please ask your Salesforce Admin for help."
    exit 1
}

    echo "The value of 1 is:  $1"

if [ -z $1 ]
  then
    echo "Please add argument for the branch name. Recommended format is <initials of develop>-<User story id>"
    exit 1
fi

git fetch --prune && git checkout develop && git pull origin develop && git checkout -b feature/$1 || {
    echo "something went wrong. Make a screenshot from the console and send to your admin."
    exit 1
}

echo "Starting the build of the scratch Org"

bash ./scripts/buildScratchOrg.sh $1

#clearSetup $1
    
#git push --set-upstream origin feature/$1