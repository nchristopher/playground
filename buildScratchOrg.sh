#!/bin/bash

# Initialize
current_dir=$PWD
expected_current_dir="payroll-cloud-us"
current_base_dir=$(pwd | grep -o '[^/]*$')
payroll_cloud_user_alias=$1
hcmPackageId=04t24000000RrSv
installWaitTimer=5 #in minutes

# Check usage
if [ "$#" -ne 1 ]; then
    echo "Invalid Usage"
    echo "Correct usage $0 <name_of_scratch_org>"
    echo "Use command sfdx force:org:list to display all orgs you have"
    echo "If you want to create a new org - use $0 <name_of_scratch_org_to_create>"
    exit 1
fi

# Check Correct Directory
if [ $current_base_dir != $expected_current_dir ] ; then
    echo "Make sure you are in the payroll-cloud directory! "
    exit 1
fi

echo current dir - $current_dir
echo expected current dir - $expected_current_dir
echo current_base_dir - $current_base_dir

# Check create scratch org
echo "Would you like to create a new scratch org with alias "$payroll_cloud_user_alias"? Type Y or N, followed by [ENTER]:"
read create_scratch_org
if [ "$create_scratch_org" == "Y" ] || [ "$create_scratch_org" == "y" ] ; then
    echo "Creating scratch org with alias $payroll_cloud_user_alias"
    sfdx force:org:create -f config/project-scratch-def.json -s -v DevHub -a "$payroll_cloud_user_alias"
    echo "Scratch org with alias $payroll_cloud_user_alias created"
elif [ "$create_scratch_org" == "N" ] || [ "$create_scratch_org" == "n" ] ; then
    echo "Not creating scratch org"
else
    echo "Unknown Input - Use Y/y or N/n"
    exit 1
fi

echo "Would you like to install Sage People? Sage People is required before proceeding - Type Y or N, followed by [Enter]:"
read installHCM
if [ "$installHCM" == "Y" ] || [ "$installHCM" == "y" ] ; then
    echo Installing HCM -   Wait for installation to complete
    output=$( sfdx force:package:install -i "$hcmPackageId" -u "$payroll_cloud_user_alias")
    if [ $? -eq 0 ] ; then
    statusId=$( echo "$output" | sed -n '1!p' )
    statusId=$( echo "$statusId" | sed -E 's/.*-i (.*) -u.*/\1/')
    installCheck=true
    echo Installation in Progress. Please Wait.... Will check for progress every "$installWaitTimer" minutes
        while ($installCheck) ;
        do
            sleep $(($installWaitTimer*60))
            echo Installation in Progress. Please Wait....
            installationStatus=$( sfdx force:package:install:get -i "$statusId" -u "$payroll_cloud_user_alias")
            if [[ $installationStatus == *"Successfully installed"* ]] ; then
                echo HCM installation complete
                installCheck=false
            elif [[ $installationStatus == *"InProgress or Unknown"* ]] ; then
                installCheck=true
            else
                echo $installationStatus
                exit 1
            fi
        done
    else
        echo "Error installing script - Fix errors and run again"
    fi
else
    echo "Not installing HCM in scratch org"
fi

echo "Would you like to use the local checkout? Type Y or N, followed by [ENTER]:"
read deploy_local

rm -rf dependencies
mkdir dependencies


# Check if dependencies sage-utils, people adaptor etc need to be deployed
echo "Would you like to deploy dependencies? Type Y or N, followed by [ENTER]:"
read deploy_dependencies

if [ "$deploy_dependencies" == "Y" ] || [ "$deploy_dependencies" == "y" ] ; then
    # configure dependent repository branches
    source "git_branch.config"
    : ${PAYROLL_CLOUD_BRANCH:=master}
    : ${SAGE_SF_UTILS_BRANCH:=master}
    : ${SAGE_OBJECT_BUS_BRANCH:=master}
    : ${PPL_US_STUB_BRANCH:=master}
    : ${SAGE_SF_UI_COMP_BRANCH:=master}
    : ${SAGE_PPL_US_LOCALIZATION_BRANCH:=master}

    echo Cloning Dependencies

    if [ -z "${GIT_USE_SSH}" ]; then
        git clone -b $SAGE_SF_UTILS_BRANCH https://github.com/Sage/sage-salesforce-utils.git dependencies/salesforce-utils
        git clone -b $SAGE_OBJECT_BUS_BRANCH https://github.com/Sage/sage-object-bus.git dependencies/sage-object-bus
        git clone -b $PPL_US_STUB_BRANCH https://github.com/Sage/sage-people-us-stub.git dependencies/sage-people-us-stub
        git clone -b $SAGE_SF_UI_COMP_BRANCH https://github.com/Sage/sage-sf-ui-components.git dependencies/sage-sf-ui-components
        git clone -b $PAYROLL_CLOUD_BRANCH https://github.com/Sage/payroll-cloud.git dependencies/payroll-cloud
        git clone -b $SAGE_PPL_US_LOCALIZATION_BRANCH https://github.com/Sage/sage-people-us-localization.git dependencies/sage-people-us-localization
    else
        git clone -b $SAGE_SF_UTILS_BRANCH git@github.com:Sage/sage-salesforce-utils.git dependencies/salesforce-utils
        git clone -b $SAGE_OBJECT_BUS_BRANCH git@github.com:Sage/sage-object-bus.git dependencies/sage-object-bus
        git clone -b $PPL_US_STUB_BRANCH git@github.com:Sage/sage-people-us-stub.git dependencies/sage-people-us-stub
        git clone -b $SAGE_SF_UI_COMP_BRANCH git@github.com:Sage/sage-sf-ui-components.git dependencies/sage-sf-ui-components
        git clone -b $PAYROLL_CLOUD_BRANCH git@github.com:Sage/payroll-cloud.git dependencies/payroll-cloud
        git clone -b $SAGE_PPL_US_LOCALIZATION_BRANCH git@github.com:Sage/sage-people-us-localization.git dependencies/sage-people-us-localization
    fi

    cd dependencies/salesforce-utils/
    # push salesforce utils
    echo pushing salesforce utils to scratch org
    sfdx force:source:push -u "$payroll_cloud_user_alias"
    # push salesforce object bus
    cd ../sage-object-bus/
    echo pushing sage object bus to scratch org
    sfdx force:source:push -u "$payroll_cloud_user_alias"
    # push sage salesforce ui components
    cd ../sage-sf-ui-components/
    echo pushing sage salesforce ui components to scratch org
    sfdx force:source:push -u "$payroll_cloud_user_alias"
    # push payroll cloud
    cd ../payroll-cloud/
    echo pushing payroll-cloud to scratch org
    sfdx force:source:push -u "$payroll_cloud_user_alias"
    # push sage-people-us-localization
    cd ../sage-people-us-localization/
    echo pushing sage-people-us-localization to scratch org
    sfdx force:source:push -u "$payroll_cloud_user_alias"
fi

# Check if dependencies sage-utils, people adaptor etc need to be deployed
echo "Would you like to deploy payroll-cloud-us source? Type Y or N, followed by [ENTER]:"
read response

if [ "$response" == "Y" ] || [ "$response" == "y" ] ; then
    cd $current_dir

    if [ "$deploy_local" == "Y" ] || [ "$deploy_local" == "y" ] ; then
      echo "Pushing sage-payroll-cloud-us to scratch org..."
      if ! sfdx force:source:push -u "$payroll_cloud_user_alias"
      then
          echo -e "$ERROR_MARKER Problem pushing payroll-cloud-us to scratch org"
          exit 1
      fi
    else
      # configure dependent repository branches
      source "git_branch.config"
      : ${PAYROLL_CLOUD_US_BRANCH:=master}

      echo Cloning Source

      if [ -z "${GIT_USE_SSH}" ]; then
          if [ "$deploy_local" != "Y" ] && [ "$deploy_local" != "y" ] ; then
            git clone -b $PAYROLL_CLOUD_US_BRANCH https://github.com/Sage/payroll-cloud-us.git dependencies/payroll-cloud-us
          fi
      else
          if [ "$deploy_local" != "Y" ] && [ "$deploy_local" != "y" ] ; then
            git clone -b $PAYROLL_CLOUD_US_BRANCH git@github.com:Sage/payroll-cloud-us.git dependencies/payroll-cloud-us
          fi
      fi

      # push payroll-cloud-us
      cd dependencies/payroll-cloud-us/
      echo pushing payroll-cloud-us to scratch org
      sfdx force:source:push -u "$payroll_cloud_user_alias"
    fi
fi

#you can only configure the org if you ahve the dependencies
if [ "$deploy_dependencies" == "Y" ] || [ "$deploy_dependencies" == "y" ] ; then

    echo "Would you like to configure the scratch org? Type Y or N, followed by [ENTER]:"
    read response

    if [ "$response" == "Y" ] || [ "$response" == "y" ] ; then

        cd $current_dir

        #put apex for configuration in one place
        mkdir dependencies/apex
        cp -r dependencies/payroll-cloud/config/apex dependencies/
        cp dependencies/sage-people-us-localization/config/apex/build-data.apex dependencies/apex

        if [ "$deploy_local" != "Y" ] && [ "$deploy_local" != "y" ] ; then
          cp -r dependencies/payroll-cloud-us/config/apex dependencies/
        else
          cp -r config/apex dependencies/
        fi

        echo Assigning Object_Bus_Admin permission set
        #TODO check if perm set already assigned
        if ! sfdx force:user:permset:assign -u "$payroll_cloud_user_alias" -n Object_Bus_Admin
        then
            echo -e "$ERROR_MARKER Problem assigning Object_Bus_Admin permission set"
            exit 1
        fi

        echo Assigning Payroll_Administrator permission set
        #TODO check if perm set already assigned
        if ! sfdx force:user:permset:assign -u "$payroll_cloud_user_alias" -n Payroll_Administrator
        then
            echo -e "$ERROR_MARKER Problem assigning Payroll_Administrator permission set"
            exit 1
        fi

        cd dependencies/sage-people-us-localization/

        echo "Registering object providers and subscribers..."
        if [[ -z `sh configurescratchorg.sh "$payroll_cloud_user_alias"` ]]
        then
            echo -e "$ERROR_MARKER Problem registering people configuration with object bus"
            exit 1
        fi

        cd $current_dir

        echo "Creating Sample Sage People Data..."
        sfdx force:apex:execute -f ./dependencies/apex/build-data.apex -u "$payroll_cloud_user_alias"
        RETVAL=$?
        if [ $RETVAL -ne 0 ]; then
            echo "$ERROR_MARKER Failed to create sample people data"
            exit 1
        fi

        echo "Seeding Payroll Data"
        if [[ -z `sfdx force:apex:execute -f ./dependencies/apex/execute-seed-us-data.apex -u "$payroll_cloud_user_alias"` ]]
        then
            echo -e "$ERROR_MARKER Problem seeding payroll US data"
            exit 1
        fi

        if [[ -z `sfdx force:apex:execute -f ./dependencies/apex/register-taxes.apex -u "$payroll_cloud_user_alias"` ]]
        then
            echo -e "$ERROR_MARKER Problem registering US Federal & State Taxes"
            exit 1
        fi

        echo "Adjusting US Tax Entity Page Layout..."
        if [[ -z `sfdx force:apex:execute -f ./dependencies/apex/adjust-tax-entity-layout.apex -u "$payroll_cloud_user_alias"` ]]
        then
            echo -e "$ERROR_MARKER Problem adjusting tax entity layout"
            exit 1
        fi

        echo "Assigning US Payroll Admin permission set..."
        #TODO check if perm set already assigned
        if ! sfdx force:user:permset:assign -u "$payroll_cloud_user_alias" -n US_Payroll_Administrator
        then
            echo -e "$ERROR_MARKER Problem assigning US_Payroll_Admin permission set"
            exit 1
        fi
    fi
fi

cd $current_dir
rm -rf dependencies
echo Use sfdx force:org:open -u "$payroll_cloud_user_alias" to open scratch org in browser
exit 0