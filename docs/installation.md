# Dataiku Docs — installation

## [installation/cloudstacks-aws/concepts]

# Conceptual overview

## Fleet Manager (FM)

The Dataiku Cloud Stacks for AWS setup uses a central component, called Dataiku Fleet Manager (FM) in order to deploy, upgrade, backup, restore and configure one or several Dataiku instances.

Fleet Manager handles the entire lifecycle of the Dataiku instances, freeing you from most administration tasks. The instances managed by Fleet Manager come builtin with the ability to scale computation on elastic computation clusters, powered by Kubernetes.

To deploy Dataiku Cloud Stacks for AWS, Dataiku provides a Cloud Formation template that deploys Fleet Manager. From Fleet Manager, you then deploy the Dataiku instances.

## Instance

An instance is a single installation of a DSS design node, automation node or deployer node. It is the main object manipulated by FM. Each instance is backed by a virtual machine dedicated to it.

When you create an instance, you _provision_ it. Provisioning an instance means FM creates the required cloud resources to host the DSS node. See [instances lifecycle](<instances.html#cloudstacks-instance-lifecycle>) for more information.

## Instance template

An instance template is a set of configuration information that can be reused to start several instances with common properties. An instance is always launched from an instance template and stays linked to it throughout its lifetime.

Enabling Stories on the instance template will set up Stories on compatible nodes (design and automation).

Modifying an instance template impacts the provisioning behavior of all the instances launched from it. Reprovisioning is not enforced, but required for the new setup to be applied.

## Virtual network

A virtual network represents the network context in which the instances will be launched. That means a reference to the virtual network used in the cloud provider, but also other configurations such as how DNS and HTTPS are handled.

Instance templates are not tied to a specific virtual network.

## Load balancer

A load balancer is a device that distributes traffic across different instances.

It acts as an application gateway by linking hostnames to various instances and helps secure inbound traffic.

For automation nodes, it can also perform actual load balancing to ensure high availability.

## Account

An account represents an identity manipulating the objects in the cloud on behalf of Fleet Manager.

## Agent

The FM agent is a Dataiku software that runs alongside DSS in your instances. It manages communication with the FM server, sends technical information to it, and performs administrative tasks on behalf of the FM server authority.

---

## [installation/cloudstacks-aws/dss-backup]

# Backup and restore of DSS instances

## Manual snapshots

You can manually backup your instance at any time by clicking on **New snapshot** in the **Snapshots** tab of the instance. It is not required to stop or deprovision the instance to make a snapshot. It has no impact the the instance users.

## Automated snaphots

You can enable automated snapshots in the **Settings** tab of the instance. Once enabled, FM will create snapshots at the required frequency and delete old snapshots if required, by specifying a maximum number of snapshots.

---

## [installation/cloudstacks-aws/dss-upgrade]

# Upgrades of DSS instances

Fleet Manager manages upgrades of DSS. Upgrades are always done under administrator control and are not performed automatically.

To upgrade an instance:

  * Go to the settings of the instance

  * In the “Version” field, select the new DSS version you want to upgrade to

  * Reprovision the instance




Upon reprovisioning, DSS will start a new virtual machine with the new DSS version and will reattach the data volume to the new DSS version, performing any upgrade on the fly as required.

## Updating the list of available versions

If your Fleet Manager instance has direct outgoing Internet access (without proxy), Fleet Manager will automatically fetch the list of newly available DSS versions, and these versions will appear directly in your Fleet Manager.

If this is not the case, please contact your Dataiku Technical Account Manager or Customer Success Manager.

---

## [installation/cloudstacks-aws/fm-upgrade-cf]

# Upgrading FM

## Description

This guided setup allows you to upgrade an existing Dataiku Cloud Stacks for AWS. It assumes you had followed [the guided setup example](<guided-setup-new-vpc-elastic-compute.html>) to build your initial setup.

**Prerequisites**

You need to have administrative access to an existing AWS subscription

## Steps

Warning

For any upgrade to Fleet Manager version 12.6.0 or higher, it is required to previously stop the virtual machine hosting Fleet Manager, or the upgrade process could fail.

### Stop Fleet Manager server

  * Under _Cloud Formation_ , find your already created stack and click on it

  * Go to the _Resources_ tab

  * Copy the _Instance ID_ (do not click on it)

  * Go to the _EC2 console_ , in the _Instances list_

  * Add a filter `Instance ID = <instance id>`, a single running instance shows up

  * Click on the instance ID to open instance page

  * Find FM private IP in _Private IPv4 addresses_ and copy it

  * Then, click on _Instance State > Stop instance_

  * Wait for the instance to reach the state _Stopped_




### Backup Fleet Manager’s data disk

  * Under _Cloud Formation_ , find your already created stack and click on it

  * Go to the _Resources_ tab

  * Copy your data volume ID

  * In _EC2 > Elastic Block Store > Volumes_, search using your volume ID

  * Select your volume and click on _Actions > Create snapshot_

  * Enter a description and click on _Create snapshot_

  * Copy the snapshot ID




### Delete your existing stack

  * Under Cloud Formation, find your stack and click on _Resources_

  * Click on the instance

  * Note its IAM Role

  * Go back in _Cloud Formation_ and delete your stack

  * Wait for the stack to be fully deleted




### Create the new stack

  * Click on ‘Create stack’ > ‘With new resources’

  * In “Amazon S3 URL”, enter `https://dataiku-cloudstacks.s3.amazonaws.com/templates/fleet-manager/14.5.1/fleet-manager-instance.yml`

  * Click on Next

  * Enter the stack name

  * Put the same basic settings as in the original setup including FM role / VPC and subnet

  * Under _Advanced settings_ , put the FM private IP you copied before and the snapshot ID

  * If you have used a KMS key, specify it

  * Click on _Next_

  * Click on _Next_ again

  * Acknowledge the resources creation and submit




## Troubleshooting

### PostgreSQL related error messages

If you are troubleshooting a non-responsive Fleet Manager after an upgrade, you might want to observe the logs displayed by `sudo journalctl -u fm-setup`.

If you see the message `Postgres server cannot be upgraded because it was not stopped properly. Please consult documentation.` or `PostgreSQL upgrade failed`, it is likely the machine hosting Fleet Manager was not properly stopped before the upgrade. You can fix it by upgrading to an intermediate version first.

Follow these instructions:

  * Replay step _Stop Fleet Manager server_ above

  * Make sure you still have the snapshot ID of the last working version of Fleet Manager

  * Replay step _Delete your existing stack_ above

  * Replay step _Create the new stack_ above but change the documented S3 URL to `https://dataiku-cloudstacks.s3.amazonaws.com/templates/fleet-manager/12.5.2/fleet-manager-instance.yml`

  * Resume the upgrade process




### DSS machines seem unresponsive

In case the DSS machines seem unresponsive in the FM UI following the upgrade, reprovision the different DSS machines for them to be able to communicate again with FM.

---

## [installation/cloudstacks-aws/guided-setup-new-vpc-elastic-compute]

# Guided setup 1: Deploy in a new VPC with Elastic Compute

## Description

This guided setup allows you to setup a full Dataiku Cloud Stacks for AWS setup, including the ability to run workloads on Elastic Compute clusters powered by Kubernetes (using Amazon EKS).

At the end of this setup, you’ll have:

  * A fully-managed DSS design node, with either a public IP or a private one

  * The ability to one-click create elastic compute clusters

  * The elastic compute clusters running with public IPs (and no NAT gateway overhead)




## Prerequisites

You need to have administrative access to an existing AWS subscription

## Steps

### VPC setup

In the AWS console, go to the _VPC_ service

  * Create a new VPC. Select a /16 CIDR, for example `10.0.0.0/16`. In the rest of this document, the id of this VPC will be noted as `vpc-id`

  * Right-click on the VPC, and select “Edit VPC settings”, enable the option “Enable DNS hostnames” and save. Check that “Enable DNS resolution” is also enabled

  * Inside the VPC, create two subnets in different availability zones, each with a /20 CIDR. For example `10.0.0.0/20` and `10.0.16.0/20`. In the rest of this document, the id of these subnets will be noted as `subnet1-id` and `subnet2-id`

  * For each of `subnet1-id` and `subnet2-id`, right-click on it, select “Edit subnet settings” and tick the box to “Enable auto-assign public IPv4 address”. Then “Save”

  * Create an Internet Gateway and attach it to `vpc-id`

  * Edit the main route table of `vpc-id`, and add a new route:

  * Destination: `0.0.0.0/0`

  * Target: select “Internet gateway”, then the Internet gateway that you just created




Your new network is now setup and ready to receive a Dataiku Cloud Stacks setup

### IAM setup

In the AWS console, go to the _IAM_ service

#### Role for DSS

  * Click on “Roles”, then on “Create role”

  * In “Type of trusted entity”, select “AWS service” and click on “EC2”

  * Click on “Next” (Add permissions) and on “Next” (Name, review, and create)

  * Give a name to the role. In the rest of this document, this role name will be noted as `dss-role-name`

  * Click on the role, click on “Add permissions”, then on “Attach policies” and select the following policies:

  * `AmazonEC2FullAccess`

  * `AWSCloudFormationFullAccess`

  * Click on “Attach policy”

  * Click on “Add permissions” and then on “Create inline policy”

  * In the policy editor, click on the JSON tab and enter this policy. In the whole JSON, replace `<account_id>` by your AWS account id



    
    
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ecr:CreateRepository",
                    "ecr:BatchGetImage",
                    "ecr:CompleteLayerUpload",
                    "ecr:DescribeImages",
                    "ecr:TagResource",
                    "ecr:GetAuthorizationToken",
                    "ecr:DescribeRepositories",
                    "ecr:UploadLayerPart",
                    "ecr:InitiateLayerUpload",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:PutImage",
                    "ecr:BatchDeleteImage",
                    "kms:CreateGrant",
                    "kms:DescribeKey",
                    "eks:*",
                    "secretsmanager:*"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "ssm:GetParameter",
                    "ssm:GetParameters"
                ],
                "Resource": [
                    "arn:aws:ssm:*:<account_id>:parameter/aws/*",
                    "arn:aws:ssm:*::parameter/aws/*"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "iam:CreateInstanceProfile",
                    "iam:DeleteInstanceProfile",
                    "iam:GetInstanceProfile",
                    "iam:ListInstanceProfiles",
                    "iam:AddRoleToInstanceProfile",
                    "iam:ListInstanceProfilesForRole",
                    "iam:RemoveRoleFromInstanceProfile",
                    "iam:GetRole",
                    "iam:CreateRole",
                    "iam:DeleteRole",
                    "iam:AttachRolePolicy",
                    "iam:PutRolePolicy",
                    "iam:PassRole",
                    "iam:DetachRolePolicy",
                    "iam:DeleteRolePolicy",
                    "iam:GetRolePolicy",
                    "iam:GetOpenIDConnectProvider",
                    "iam:CreateOpenIDConnectProvider",
                    "iam:DeleteOpenIDConnectProvider",
                    "iam:ListAttachedRolePolicies",
                    "iam:TagRole"
                ],
                "Resource": [
                    "arn:aws:iam::<account_id>:instance-profile/eksctl-*",
                    "arn:aws:iam::<account_id>:role/eksctl-*",
                    "arn:aws:iam::<account_id>:oidc-provider/*",
                    "arn:aws:iam::<account_id>:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodeGroup",
                    "arn:aws:iam::<account_id>:role/eksctl-managed-*"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "iam:GetRole"
                ],
                "Resource": [
                    "arn:aws:iam::<account_id>:role/*"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "iam:CreateServiceLinkedRole"
                ],
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "iam:AWSServiceName": [
                            "eks.amazonaws.com",
                            "eks-nodegroup.amazonaws.com",
                            "eks-fargate.amazonaws.com"
                        ]
                    }
                }
            },
            {
                "Sid": "EKSAutoScalingWrite",
                "Effect": "Allow",
                "Action": [
                    "autoscaling:UpdateAutoScalingGroup",
                    "autoscaling:DeleteAutoScalingGroup",
                    "autoscaling:CreateAutoScalingGroup"
                ],
                "Resource": [
                    "arn:aws:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/*"
                ]
            },
            {
                "Sid": "EKSAutoScalingRead",
                "Effect": "Allow",
                "Action": [
                    "autoscaling:DescribeAutoScalingGroups",
                    "autoscaling:DescribeScalingActivities",
                    "autoscaling:DescribeLaunchConfigurations"
                ],
                "Resource": "*"
            }
        ]
    }
    

  * Click on “Review Policy”, then on “Create policy”

  * Take note of the “Instance profile ARN”. In the rest of this document, it will be noted as `dss-role-instance-profile-arn`

  * Take note of the “Role ARN”. In the rest of this document, it will be noted as `dss-role-arn`




#### Role for Fleet Manager

  * Click on Roles, then on Create role

  * In “Type of trusted entity”, select “AWS service” and click on “EC2”

  * Click on “Next” (Add permissions) and on “Next” (Name, review, and create)

  * Give a name to the role. In the rest of this document, this role name will be noted as `fm-role-name`

  * Click on the role, click on “Add permissions”, then on “Create inline policy”

  * In the policy editor, click on the JSON tab and enter this policy. In the whole JSON, replace `<dss-role-arn>` by the role ARN you noted earlier



    
    
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "ec2:DeleteVolume",
            "ec2:StartInstances",
            "ec2:StopInstances",
            "ec2:AttachVolume",
            "ec2:ModifyVolume",
            "ec2:DeleteSnapshot",
            "ec2:RebootInstances",
            "ec2:TerminateInstances",
            "ec2:AssociateIamInstanceProfile",
            "ec2:DisassociateIamInstanceProfile",
            "ec2:CreateTags",
            "ec2:DeleteSecurityGroup",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CreateVolume",
            "ec2:CreateTags",
            "ec2:DescribeVpcs",
            "ec2:DescribeSubnets",
            "ec2:DescribeVolumes",
            "ec2:DescribeInstances",
            "ec2:DescribeIamInstanceProfileAssociations",
            "ec2:DescribeSecurityGroups",
            "ec2:CreateSecurityGroup",
            "ec2:RunInstances",
            "ec2:CreateSnapshot",
            "ec2:AssociateAddress",
            "ec2:CreateRoute",
            "ec2:DeleteRoute",
            "ec2:DescribeRouteTables",
            "ec2:AcceptVpcPeeringConnection",
            "ec2:DeleteVpcPeeringConnection",
            "ec2:CreateVpcPeeringConnection",
            "ec2:DescribeVpcPeeringConnections",
            "sts:GetCallerIdentity",
            "sts:AssumeRole",
            "route53:GetHostedZone",
            "route53:ChangeResourceRecordSets",
            "route53:ListResourceRecordSets",
            "route53:GetChange",
            "acm:DescribeCertificate",
            "acm:ExportCertificate",
            "acm:ListCertificates",
            "acm:RenewCertificate",
            "acm:DeleteCertificate",
            "acm:UpdateCertificateOptions",
            "elasticloadbalancing:*"
        ],
        "Resource": [
            "*"
        ]
        },
        {
        "Effect": "Allow",
        "Action": "iam:PassRole",
        "Resource": "<dss-role-arn>"
        }
    ]
    }
    

  * Click on “Review policy”, enter a policy name and click on “Create policy”




### Fleet Manager setup

In the AWS console, go to the _CloudFormation_ service

  * Click on “Create stack” and then “With new resources”

  * In “Amazon S3 URL”, enter `https://dataiku-cloudstacks.s3.amazonaws.com/templates/fleet-manager/14.5.1/fleet-manager-instance.yml`




Note

This template creates an IAM role to setup a daily backup policy. An alternative template without role creation (nor backup policy) is available at `https://dataiku-cloudstacks.s3.amazonaws.com/templates/fleet-manager/14.5.1/fleet-manager-instance-no-dlm.yml`

  * Click on “Next”

  * Enter a name for your deployment

  * In “VPC Id”, enter `vpc-id`

  * In “Subnet Id”, enter `subnet1-id`

  * In “IP addresses allowed to connect to Fleet Manager”, either enter `0.0.0.0/0` to authorize TCP connection to Fleet Manager from anywhere, or enter the CIDR corresponding to your own IP address range (w.x.y.z/32)

  * In “SSH KeyPair”, select an existing keypair that will be able to connect to Fleet Manager (it is not normally required)

  * In “Fleet Manager IAM role”, enter `fm-role-name`

  * In “Fleet Manager password”, enter a strong password. This is the password that you’ll need to manage your Dataiku Cloud Stacks fleet

  * Click on “Next”

  * Optionally, you can add tags that you would like to be propagated to the deploying resources then click again on “Next”

  * At the bottom, check the “I acknowledge that AWS CloudFormation might create IAM resources with custom names.”

  * Click on “Create Stack”

  * Wait for your stack to appear as “CREATE_COMPLETE”

  * In the “Resources” tab of the stack, click on the “Instance” entry

  * Copy the “Public IPv4 address”




This is the address at which your Cloud Stacks Fleet manager is deployed. Open a new tab to this address.

### Start your first DSS

  * Log into Fleet Manager with “admin” as the login, and the password you previously entered

  * In “Cloud Setup”, click on “Enter license” and enter your Dataiku license. Save

  * Refresh the page in your browser

  * In “Fleet Blueprints”, click on “DEPLOY ELASTIC DESIGN”, give a name to your new fleet and in “Instance profile ARN”, enter the `dss-role-instance-profile-arn`

  * Click on “Deploy”

  * Go to “Instances > All”, click on the design node

  * Click “Provision”

  * Wait for your DSS instance to be ready

  * Click on “Retrieve password” and write-down the password

  * Click on “Go to DSS”

  * Login with “admin” as the login, and the password you just retrieved




You can now start using DSS

### (Optional) Start your first Elastic compute cluster

  * In Fleet Manager, go to your Virtual Network, and note the id of the “Default security group”. In the rest of the document, this will be noted as `defaultsg-id`

  * In DSS, go to “Administration > Clusters”

  * Click on “Create EKS cluster”, give it a name

  * In “Connection”, enter your region name

  * In “Network settings”, set to “Manually defined”

  * In “VPC subnets”, enter `subnet1-id`, then Enter, then `subnet2-id`, then Enter

  * In “Security groups”, enter `defaultsg-id`, then Enter

  * In “Initial node pool”, set to “Manually defined”

  * Click on “Start”

  * Wait for your cluster to be available

  * In “Settings”, go to “Containerized execution”, and in “Default cluster”, select the cluster you just created

  * In a project, you can now use containerized execution for any activity, using the `eks-default` containerized config

---

## [installation/cloudstacks-aws/high-availability]

# High availability

Fleet Manager enables high availability for automation nodes.

## Load balancing

Fleet Manager manages load balancers.

When defining load balancer node mappings, a single hostname can be associated with multiple automation nodes to enable load balancing between them.

## Deployer infrastructures

When an automation node is added to a fleet containing a deployer node, the necessary infrastructure is automatically created in the deployer node to allow deployments to the new automation node.

If the **Create a single-node infrastructure** option is enabled on the automation node, a single-node infrastructure will be created, allowing deployments only to this node.

If the automation node is placed behind a load balancer, a multi-node infrastructure will be created. As additional nodes are added behind the same hostname, the multi-node infrastructure will expand accordingly. This setup enables deployments to all nodes that make up the high-availability infrastructure simultaneously.

---

## [installation/cloudstacks-aws/how-to-setup-fm-init-scripts]

# Howto: Install a script on your Fleet Manager to be run at VM restart time

This application note documents how it is possible to install scripts on the Fleet Manager (FM) VM so that they are run when the VM is restarted.

## Overview

The FM startup process looks for folders `/data/etc/dataiku-fm-init-scripts/{before|after}-startup.d` in the VM. The shell executable scripts found in these folders will be executed in lexicographic order respectively before or after FM startup.

The logs for the different executions will be stored in `/data/var/log/dataiku-fm-init-scripts/{before|after}-startup.d` with the execution time in the file name.

Both scripts and script logs are available in FM diag.

## Installing scripts

Let’s take the example of a script to be executed before FM startup.

In order to install the script, SSH on the FM machine and run the following:
    
    
    sudo su root
    mkdir -p /data/etc/dataiku-fm-init-scripts/before-startup.d
    chown dataiku:dataiku /data/etc/dataiku-fm-init-scripts/before-startup.d
    cd /data/etc/dataiku-fm-init-scripts/before-startup.d
    touch test.sh
    chmod +x test.sh
    # implement your script in test.sh
    # change script folder to after-startup.d if you want the script to run after FM startup
    

## Script examples

### Deprovision DSS nodes for the night

#### Overview

This script will create all the necessary to install a system.d timer running every night at 8:00 PM in order to deprovision all the DSS machines listed in this FM instance.

Machine deprovisioning can be prevented by adding tag `no-auto-deprovision` to the machines needing it.

#### Script

Create an executable bash script in `/data/etc/dataiku-fm-init-scripts/after-startup.d` with the following code:
    
    
    #!/usr/bin/env bash
    
    # Get an API key and API secret for FM Python API
    output="$(sudo -u dataiku /data/dataiku/fmhome/bin/fmadmin create-personal-api-key admin /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes_credentials.json)"
    
    # create the Python script deprovisioning the instances
    if [ ! -f /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes.py ]; then
    cat > /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes.py << EOF
    import dataikuapi
    import sys
    import json
    from pathlib import Path
    from dataikuapi.fm.instancesettingstemplates import FMSetupAction, FMSetupActionType
    
    FM_URL = "http://localhost:10000"
    NO_DEPROVISION_TAG = "no-auto-deprovision"
    
    def read_credentials(credentials_file_location):
        credentials_file_path = Path(credentials_file_location)
        if not credentials_file_path.is_file():
            raise Error("The provided credentials path does not match an existing JSON file")
    
        try:
            with open(credentials_file_location) as credentials_file:
                credentials_json = json.load(credentials_file)
            if not "id" in credentials_json or not "secret" in credentials_json:
                raise Error("The provided credentials file has incorrect JSON format")
        except:
            raise Error("The provided credentials file has incorrect JSON format")
    
        api_key = credentials_json["id"]
        api_secret = credentials_json["secret"]
    
        return api_key, api_secret
    
    def read_cloud():
        user_data_file_location = "/data/dataiku/fmhome/config/user-data.json"
        with open(user_data_file_location) as user_data_file:
            user_data = json.load(user_data_file)
        return str.lower(user_data['cloud'])
    
    def deprovision_instances(cloud, credentials_file_location):
        # Read credentials from the JSON file
        api_key, api_secret = read_credentials(credentials_file_location)
    
        # Create an FM client
        if cloud == "aws":
            print("Creating FM client for AWS")
            fm_client = dataikuapi.FMClientAWS(FM_URL, api_key, api_secret)
        elif cloud == "gcp":
            print("Creating FM client for GCP")
            fm_client = dataikuapi.FMClientGCP(FM_URL, api_key, api_secret)
        elif cloud == "azure":
            print("Creating FM client for Azure")
            fm_client = dataikuapi.FMClientAzure(FM_URL, api_key, api_secret)
        else:
            print(f"Unknown cloud provider: {cloud}")
    
        # List and display instances with their status in a table
        instances = fm_client.list_instances()
        futures = []
    
        print("Listing instances to be deprovisioned...")
        for instance in instances:
            if NO_DEPROVISION_TAG in instance.instance_data["fmTags"]:
                print(f"  - Skipping deprovision for instance with ID [{instance.instance_data['id']}]")
                continue
            instance_status = instance.get_status()
            if 'hasPhysicalInstance' in instance_status and instance_status['hasPhysicalInstance']:
                print(f"  - Scheduling deprovision for instance with ID [{instance.instance_data['id']}]")
                futures.append(instance.deprovision())
    
        print("Deprovisioning instances...")
        for future in futures:
            future.wait_for_result()
    
        print("Completed")
    
    if __name__ == "__main__":
        credentials_file_location = sys.argv[1]
    
        deprovision_instances(read_cloud(), credentials_file_location)
    EOF
    fi
    
    # Create system.d service file
    if [ -f /etc/systemd/system/deprovision_fm_nodes.timer ]; then
    systemctl stop deprovision_fm_nodes.timer
    rm -f /etc/systemd/system/deprovision_fm_nodes.timer
    fi
    
    if [ -f /etc/systemd/system/deprovision_fm_nodes.service ]; then
    rm -f /etc/systemd/system/deprovision_fm_nodes.service
    fi
    
    cat > /etc/systemd/system/deprovision_fm_nodes.service << EOF
    [Unit]
    Description="Deprovision DSS machines for the night"
    
    [Service]
    ExecStart=/data/dataiku/fmhome/pyenv/bin/python /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes.py "/data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes_credentials.json"
    EOF
    
    # Create system.d corresponding timer file
    cat > /etc/systemd/system/deprovision_fm_nodes.timer << EOF
    [Unit]
    Description="Deprovision DSS nodes attached to this FM for the night"
    
    [Timer]
    OnCalendar=Mon..Fri *-*-* 20:00
    Unit=deprovision_fm_nodes.service
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    # Load the new files
    systemctl daemon-reload
    
    # Start timer
    systemctl start deprovision_fm_nodes.timer
    
    # Check timer status to have it in logs
    systemctl status deprovision_fm_nodes.timer
    

### Provision DSS nodes in the morning

#### Overview

This script will create all the necessary to install a system.d timer running every morning at 8:00 AM in order to provision all the DSS machines listed in this FM instance.

Machine provisioning can be prevented by adding tag `no-auto-provision` to the machines needing it.

#### Script

Create an executable bash script in `/data/etc/dataiku-fm-init-scripts/after-startup.d` with the following code:
    
    
    #!/usr/bin/env bash
    
    # Get an API key and API secret for FM Python API
    output="$(sudo -u dataiku /data/dataiku/fmhome/bin/fmadmin create-personal-api-key admin /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes_credentials.json)"
    
    # create the Python script provisioning the instances
    if [ ! -f /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes.py ]; then
    cat > /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes.py << EOF
    import dataikuapi
    import sys
    import json
    from pathlib import Path
    from dataikuapi.fm.instancesettingstemplates import FMSetupAction, FMSetupActionType
    
    FM_URL = "http://localhost:10000"
    NO_PROVISION_TAG = "no-auto-provision"
    
    def read_credentials(credentials_file_location):
        credentials_file_path = Path(credentials_file_location)
        if not credentials_file_path.is_file():
            raise Error("The provided credentials path does not match an existing JSON file")
    
        try:
            with open(credentials_file_location) as credentials_file:
                credentials_json = json.load(credentials_file)
            if not "id" in credentials_json or not "secret" in credentials_json:
                raise Error("The provided credentials file has incorrect JSON format")
        except:
            raise Error("The provided credentials file has incorrect JSON format")
    
        api_key = credentials_json["id"]
        api_secret = credentials_json["secret"]
    
        return api_key, api_secret
    
    def read_cloud():
        user_data_file_location = "/data/dataiku/fmhome/config/user-data.json"
        with open(user_data_file_location) as user_data_file:
            user_data = json.load(user_data_file)
        return str.lower(user_data['cloud'])
    
    def provision_instances(cloud, credentials_file_location):
        # Read credentials from the JSON file
        api_key, api_secret = read_credentials(credentials_file_location)
    
        # Create an FM client
        if cloud == "aws":
            print("Creating FM client for AWS")
            fm_client = dataikuapi.FMClientAWS(FM_URL, api_key, api_secret)
        elif cloud == "gcp":
            print("Creating FM client for GCP")
            fm_client = dataikuapi.FMClientGCP(FM_URL, api_key, api_secret)
        elif cloud == "azure":
            print("Creating FM client for Azure")
            fm_client = dataikuapi.FMClientAzure(FM_URL, api_key, api_secret)
        else:
            print(f"Unknown cloud provider: {cloud}")
    
        # List and display instances with their status in a table
        instances = fm_client.list_instances()
        futures = []
    
        print("Listing instances to be provisioned...")
        for instance in instances:
            if NO_PROVISION_TAG in instance.instance_data["fmTags"]:
                print(f"  - Skipping provision for instance with ID [{instance.instance_data['id']}]")
                continue
            instance_status = instance.get_status()
            if 'hasPhysicalInstance' in instance_status and not instance_status['hasPhysicalInstance']:
                print(f"  - Scheduling provision for instance with ID [{instance.instance_data['id']}]")
                futures.append(instance.reprovision())
    
        print("Provisioning instances...")
        for future in futures:
            future.wait_for_result()
    
        print("Completed")
    
    if __name__ == "__main__":
        credentials_file_location = sys.argv[1]
    
        provision_instances(read_cloud(), credentials_file_location)
    EOF
    fi
    
    # Create system.d service file
    if [ -f /etc/systemd/system/provision_fm_nodes.timer ]; then
    systemctl stop provision_fm_nodes.timer
    rm -f /etc/systemd/system/provision_fm_nodes.timer
    fi
    
    if [ -f /etc/systemd/system/provision_fm_nodes.service ]; then
    rm -f /etc/systemd/system/provision_fm_nodes.service
    fi
    
    cat > /etc/systemd/system/provision_fm_nodes.service << EOF
    [Unit]
    Description="Provision DSS machines in the morning"
    
    [Service]
    ExecStart=/data/dataiku/fmhome/pyenv/bin/python /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes.py "/data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes_credentials.json"
    EOF
    
    # Create system.d corresponding timer file
    cat > /etc/systemd/system/provision_fm_nodes.timer << EOF
    [Unit]
    Description="Provision DSS nodes attached to this FM in the morning"
    
    [Timer]
    OnCalendar=Mon..Fri *-*-* 08:00
    Unit=provision_fm_nodes.service
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    # Load the new files
    systemctl daemon-reload
    
    # Start timer
    systemctl start provision_fm_nodes.timer
    
    # Check timer status to have it in logs
    systemctl status provision_fm_nodes.timer

---

## [installation/cloudstacks-aws/index]

# Dataiku Cloud Stacks for AWS

This setup allows you to deploy a fully-managed Dataiku setup on AWS. The setup comes fully-featured with Elastic AI, advanced security, R support, auto-healing setup, …

Everything is deployed in your cloud tenant, Dataiku does not have access to your data.

---

## [installation/cloudstacks-aws/instances]

# Instances

Fleet Manager manages three kinds of DSS instances:

  * Design nodes

  * Execution (aka automation) nodes

  * Deployer nodes (usually you only have a single deployer node in your fleet)




## Dashboard

The main screen through which you will get information about your instance is the dashboard. It is refreshed automatically and displays basic network information, data disk usage as well as the [agent](<concepts.html#cloudstacks-concept-agent>) logs.

## Lifecycle

### Provisioning

The provisioning is the sequence of operations required to have a running DSS reachable by users. Provisioning an instance has two main stages:

  * The provisioning of cloud resources required for the instance to run. It is mostly a virtual machine and a data disk.

  * A software startup sequence run by the [agent](<concepts.html#cloudstacks-concept-agent>) which runs internal setup tasks, the setup actions you defined in your instance template, and installs and upgrades DSS if required.




Some settings changes require that you deprovision an instance an provision it again, which is denoted as _reprovisioning_.

### Deprovisioning

Deprovisioning an instance consists of terminating the cloud virtual machine. The EBS is kept. A deprovisioned instance costs the EBS storage fee.

## Data management

When an instance is created, a data disk distinct from the OS disk is created, attached and mounted to store all the persistent data. The persistent data on an instance includes, but is not limited to:

  * The DSS data directory

  * The docker daemon data directory

  * The certificates generated if self-signed certificates or Let’s Encrypt certificates are in use.




## Settings

An instance has various settings that can be set at different point of its lifecycle.

### General settings

Not documented yet

### SSL settings

The SSL settings define how your DSS instance will be exposed over SSL. This varies depending on the value you choose for HTTPS strategy in your virtual network:

#### None (HTTP only)

SSL will be disabled and your DSS instance will be accessible by HTTP only. No SSL settings are required.

#### Self-signed certificates

A self-signed certificate will be generated when the DSS instance is installed. Self-signed means that no official certificate authority has signed this certificate. Your DSS instance will be accessible over HTTPS, but the certificate won’t be trusted by your users by default. Each user will need to manually trust the self-signed certificate. We only recommend this HTTPS strategy if all DSS users are familiar and comfortable with trusting a self signed certificate.

To make this mode more convenient, in the SSL settings, you can define the hostnames that will be injected in the self-signed certificate as Subject Alternative Name. This is required if you define a hostname pointing to the DSS instance and you want your users to access DSS via this hostname instead. Each user will still need to trust this certificate manually, but once done, their browser will accept the connection to this DSS instance using the hostname defined as Subject Alternative Name.

#### Certificate/key for each instance

This strategy will allow you to manually define a certificate for each instance, in the SSL settings of the instance.

The advantage is that you can use a certificate signed by an official certificate authority and for a given hostname you own, so your users can access the DSS instance via this hostname and see the given certificate as trusted by their browser.

Generating or retrieving such certificate is not documented here, as this process generally depends on your company policy. Please ask your IT department on how to get a trusted certificate.

Once you have a certificate, the SSL settings offer three storage modes:

##### Enter key

The certificate will be stored in Fleet Manager, encrypted with a key from your AWS Key Management Service (KMS) and retrieved by the DSS instance at startup.

The format expected is PEM, for both the public and private key. If you don’t have the certificate in this format, please use OpenSSL accordingly.

The private key will be encrypted with your AWS KMS, so you will need to configure the Key Vault.

Create a key for encryption in your Key Vault:

  * Go to your AWS KMS, ideally in the same region than your FM

  * Click on Create key

  * Choose a Symmetric key type for a encrypt and decrypt usage

  * Click Next

  * Define the alias of your choice, like FMKey

  * Click Next

  * Choose your FM role (that’s the role you assigned to FM during the provisioning of FM, under the reference fm-role-name)

  * Click Next

  * Choose your FM role

  * Click Next

  * Click Finish

  * Copy the key ID. In the rest of this document, this role name will be noted as fm-kms-key-id




Then in FM, setup the Key vault:

  * Go in “Cloud Setup > Edit”

  * Set the “AWS CMK Id” to fm-kms-key-id (AWS KMS is replacing the term customer master key (CMK) with AWS KMS key and KMS key)

  * Click Save




Your fleet manager is now ready to handle manual certificates. In your instance settings, in the SSL section:

  * Set the public PEM and private PEM




##### Secret stored in Key Vault

The certificate public PEM will be stored in FM, whereas the private key will be stored as an AWS secret.

In AWS: \- Go to the AWS Secret Manager in the same zone than your DSS instance. \- Click on Store a new secret \- Select the type Other type of secret \- Select the format Plaintext \- Replace the sample text by your certificate private key as PEM \- Click Next \- Put a secret name. In the rest of this document, this role name will be noted as dss-cert-secret-name \- Click Next \- Click Next \- Click Store

In AWS IAM

Verify that your DSS role (referred as dss-role-name in the FM provisioning documentation) has the secret manager role. \- Go to the AWS IAM \- Find your DSS role dss-role-name \- Verify if any of the policy has the permission secretsmanager:*. If not, add it to one of the policy and save. \- Take note of the “Instance profile ARN”. In the rest of this document, it will be noted as dss-role-instance-profile-arn

In Fleet manager, SSL settings, configure the instance as follows:

  * **Key storage mode** : Secret stored in ASM

  * **SSL certificate (PEM data)** : The public certificate as PEM

  * **ASM secret id** : dss-cert-secret-name

  * **ASM Region** : This field is deprecated and will be remove in future release. You can ignore this value.




Note

In the instance template, make sure the Runtime instance profile ARN is setup to dss-role-instance-profile-arn, otherwise the agent won’t be able to access the key vault.

Provision or reprovision your DSS instance. At startup, the certificate will be retrieved from the AWS Secret Manager and you will notice that your DSS instance is now exposed using this certificate.

#### Generate certificates using Let’s Encrypt

Let’s Encrypt is a certificate authority, trusted by default by most browsers, which offers a certificate service for free, given you own a domain. This means that Let’s Encrypt can generate a certificate for your DSS instance, if you point your domain hostname to the DSS IP.

Note

Prerequisites

You need to own a domain, like `mydss.example.com` and point the DNS A record to a public static IP. This IP will then be assigned to the DSS instance.

In Fleet manager, on the virtual network, settings tab:

  * setup the SSL > Strategy to Generate certificates using Let’s Encrypt

  * setup the Contact Mail to an email address of your choice




In Fleet manager, on the instance page, settings tab, configure the instance as follows:

  * in the SSL part, click on \+ ADD DOMAIN

  * Add the hostname of your domain. Example: `mydss.example.com`

  * Assign the public IP to this instance.




Provision the DSS instance. When completed, you should be able to access your DSS instance with `https://mydss.example.com` and see a valid HTTPs certificate signed by Let’s Encrypt.

## Operations

Not documented yet

---

## [installation/cloudstacks-aws/load-balancers]

# Load balancers

Fleet Manager manages load balancers.

They act as application gateways in front of Dataiku nodes. They can also be used to perform load balancing in front of automation nodes to achieve high availability.

## Dashboard

The main screen through which you will get information about the load balancer is the dashboard. It is refreshed automatically and displays the different node mappings, the components created in the cloud and status information.

## Lifecycle

### Provisioning

The provisioning is a sequence of operations required to have the load balancer created in the cloud.

### Updating

When modifying the load balancer configuration in Fleet Manager, the load balancer must be updated for the changes to be propagated to the cloud. A reconciliation mechanism automatically detects these modifications and updates the relevant cloud structures to align with the defined configuration.

### Deprovisioning

Deprovisioning a load balancer consists of deleting the different cloud objects that were created as well as the load balancer.

## Settings

A load balancer has various settings.

Note

You can create a load balancer at fleet creation time using the **Fleet blueprints**.

In this case, a best practice setup will be implemented:

  * No public IP for the DSS nodes

  * The load balancer exposes the DSS nodes

  * The load balancer forwards traffic to the DSS nodes with HTTP




### Virtual network

Select the virtual network in which the load balancer will be created. This virtual network needs to have two subnets defined in Fleet Manager. Note that the secondary subnet can be added at any time but won’t be editable afterwards.

#### Virtual network HTTPS strategy

The virtual network **HTTPS strategy** only applies to the nodes. The load balancer can still be exposed using HTTPs.

Note

If your virtual network HTTPS strategy is **Self-signed certificates** , you need to add manually the self-signed certificate to the load balancer.

### Node mappings

Node mappings define the hostnames that point to each DSS node.

Each node must have a unique hostname, except for automation nodes which can share the same hostname for load balancing purposes.

Note

If the virtual network DNS strategy is **Assign a Route53 domain name you manage** , the hostnames correspond to sub domains within this zone. Fleet Manager will manage both the sub domains and the load balancer.

Otherwise, the hostnames must be fully qualified domain names.

### Certificate mode

Assigns a certificate to the load balancer to secure the load balancer hostnames.

Multiple modes are available:

  * **No certificate**

  * **Certificate ARN** : Certificate has been created in AWS console and its ARN is used to assign it to the load balancer

  * **Certificate manager** : A certificate will be created by Fleet Manager in the provided certificate manager. This works only if the DNS is also managed by Fleet Manager through the virtual network (see [virtual networks DNS strategy](<virtual-networks.html#aws-cloudstacks-vnet-dnsstrategy>)). It ensures that Fleet Manager fully manages the certificate: if the hostnames are modified, the certificate will be automatically regenerated accordingly




### Public IP mode

Assigns a public IP to the load balancer.

Only **Dynamic public IP** mode is supported. Fleet Manager will manage the load balancer public IP.

---

## [installation/cloudstacks-aws/multi-region-account]

# Multi-region and multi-account support

Fleet Manager can manage cloud objects across different regions and impersonate different identities.

By default, it operates within the same region where it is deployed and uses its own identity.

If you are reusing an existing Fleet Manager role, ensure that its permissions match those documented in the [Fleet Manager installation procedure](<guided-setup-new-vpc-elastic-compute.html>).

## Multi-account support

In order to manipulate cloud objects with a different identity, an account needs to be created in Fleet Manager.

This account needs the same permissions as the [initial Fleet Manager account](<guided-setup-new-vpc-elastic-compute.html>).

Multiple authentication modes are available:

  * **IAM role**

  * **Keypair**




### IAM role

When using another IAM role, Fleet Manager role needs to be added to its _Trust Relationship_.

## Multi-region support

To enable multi-region functionality, you need to create a new VPC in the AWS console, following the same process used when setting up the Fleet Manager VPC during the [Fleet Manager installation](<guided-setup-new-vpc-elastic-compute.html>). Ensure that its IP range does not overlap with the Fleet Manager VPC’s IP range.

When creating the corresponding virtual network in Fleet Manager, specify the desired region. Any objects deployed in this virtual network will be located in that region.

In this case, both the virtual network where Fleet Manager is deployed and the virtual network where the objects will be deployed must be paired. Fleet Manager can handle this pairing process.

## Combining Multi-region and Multi-account

You can use both multi-region and multi-account capabilities simultaneously.

To do so, select an account different from the default Fleet Manager account when creating a virtual network in Fleet Manager.

---

## [installation/cloudstacks-aws/sso]

# Single Sign-On

Single sign-on (SSO) refers to the ability for users to log in just one time with one set of credentials to get access to all corporate apps, websites, and data for which they have permission.

By setting up SSO in FM, your users will be able to access FM using their corporate credentials.

SSO solves key problems for the business by providing:

>   * Greater security and compliance.
> 
>   * Improved usability and user satisfaction.
> 
> 


Delegating the FM authentication to your corporate identity provider using SSO allows you to enable a stronger authentication journey to FM, with multi-factor authentication (MFA) for example.

FM supports the following SSO protocols:

>   * OpenID connect
> 
>   * SAML
> 
> 


## Users database

Since FM users all have the same privileges, we recommend that you simply map all your login users to the admin user.

If you choose not to map to the same user, you must create FM user accounts for each SSO user. When creating these users, select “Local (no auth, for SSO only)” as the source type. Since users won’t enter passwords in SSO mode, only a login and display name are required.

## OpenID Connect

### About OIDC

#### Glossary

  * **OIDC** : **O** pen**ID** **C** onnect

  * **IDP** : An **Id** entity **P** rovider is a system entity that creates, maintains, and manages identity information for principals and also provides authentication services to relying applications within a federation or distributed network

  * **End-user** : The end user is the entity for whom we are requesting identity information. In our case, it is the FM user that need to login to access FM.

  * **OIDC Client** : Also called Relying party **RP** in the OIDC specification, the OIDC client is the application that relies on the IDP to authenticate the end user. In our case, it is FM.

  * **ID Token** : Similar to a ID card or passport, it contains many required attributes or claims about the user. This token is then used by FM to map the claims to a corresponding FM user. Digitally signed, the ID token can be verified by the intended recipients (FM).

  * **Claim** : In FM context, claims are name/value pairs that contain information about a user.

  * **Scope** : In the context of OIDC, scope references a set of claims the OIDC client needs. Example: email

  * **Authorization code** : During the OIDC protocol, the authorization code is generated by the IDP and sent to the end-user, which passes it to the OIDC client. It is then used by the OIDC client, who sends the authorization code to the IDP, and receives in exchange an ID token. Using an intermediate authorization code allows the IDP to mandate the OIDC client to authenticate itself in order to retrieve the ID token.

  * **Confidential client** : An OIDC client with the capacity to exchange the authorization code for an ID token in a secured back channel. This is the case of FM.

  * **Public client** : An OIDC client not able to store secret securely and needs to exchange the authorization code for an ID token in a public channel. FM is not a public client.

  * **PKCE** : **P** roof **K** ey for **C** ode **E** xchange is an extension of the OIDC protocol, to allow public clients to exchange the authorization code in a public channel.




#### Compatibility

FM OIDC integration has been successfully tested against the following OIDC identity providers:

  * OKTA

  * Azure Active Directory

  * Google G.Suite

  * Keycloak




#### OIDC features supported by FM

  * authorization code grant flow

  * simple string claims in the ID token

  * non encrypted or signed authentication requests

  * ID token signed with RSA or EC

  * FM behind a proxy

  * response mode supported: query or fragment

  * token endpoint auth method supported: client secret basic or client secret POST

  * confidential OIDC client only (PKCE not supported)




#### How OIDC looks like with FM

Once configured for OIDC SSO, FM acts as an OIDC client, which delegates user authentication to an identity provider.

  1. When the end user tries to access FM and is not authenticated yet, FM will redirect him to the IDP. The URL used will be the authorization endpoint of the IDP, which some specific GET parameters specific to the FM setup.

  2. The IDP will validate the GET parameters and will present a login page to the user. The authentication journey now depends on your IDP capabilities. Sometimes, when already logged-in on the IDP side, the login page is skipped and the user may not see the redirection to the IDP.

  3. The IDP has authenticated the end user and will redirect the user to FM with an authorization code. Depending of your OIDC client setup in your IDP, the code may be passed through via the query parameters or the fragment.

  4. The front-end of FM will parse and send the parameters, including the authorization code, to the FM backend.

  5. The FM backend will exchange this authorization code for an access token, by calling the token endpoint with the credentials you previously have configured in FM SSO settings. If successful, the IDP will return an ID token corresponding the end user.

  6. FM uses the ID token to map the end user to a FM user. The mapping setup is part of the SSO configuration of OIDC.

  7. FM creates a user session corresponding to the FM user. At this point, OIDC is completed and the user session is agnostic of the authentication protocol used.




### Setup OIDC in FM

To set up OIDC integration, you need:

  * to register a new OIDC Client (sometimes called an ‘application’) for FM in your identity provider,

  * to configure FM with the parameters of the identity provider as well as the parameters corresponding to the OIDC client created earlier,

  * to configure which of the user attributes returned by the IDP is to be used as the FM username, and optionally configure rewrite rules to extract the FM username from the chosen user attribute.




These steps are individually detailed below.

#### Registering a service provider entry for FM on the identity provider.

The exact steps for this depend on the identity provider platform which you plan to connect to, and should be performed by your IDP administrator. This entry may also be called an “OIDC application”. You will sometimes be asked to select the type of application, which would be in our case a web application.

You will typically need:

  * to setup the OIDC client to use the authorization code grant flow,

  * a client ID,

  * a client secret,




Note

The OIDC client needed by FM is a confidential client (opposite of public client). Meaning FM is able to protect the client secret, by exchanging the authorization code (and using the secret in the request) from the backend.

  * setup the redirect URI BASE_URL/login/openid-redirect-uri/,




Note

This URL must be configured as BASE_URL/login/openid-redirect-uri/, where BASE_URL is the URL through which FM users access this FM instance.

For example, if FM is accessed at https://dataiku.mycompany.corp/, the OIDC redirect uri must be defined as https://dataiku.mycompany.corp/login/openid-redirect-uri/.

Note that some identity providers require the redirect URI to use the HTTPS scheme.

  * associate some OIDC scopes to the OIDC client. Some IDPs refer to these as permissions, like user.read. You will need to setup the scope openid as well as some identity claims. You must ensure that FM is able to access and retrieve all the user attributes needed to identify the corresponding user in FM.




Note

FM will need to map to an existing user from one of the user claims. It’s important that you allow FM to retrieve a claim that is easily mappable to the username. A good candidate is email, of which you can strip the part after ‘@’ to compose a unique identifier for usernames.

#### Configuring FM for OIDC authentication.

OIDC configuration is in the “Settings / Security & Audit / User login & provisioning / SSO” screen.

Select “Enable”, choose protocol “OIDC”.

##### IDP configuration

Contact your IDP administrator to retrieve this information or check your IDP documentation.

The easiest way to setup the IDP configuration is using the well-known endpoint: The OIDC standard defines an endpoint, called well-known, to discover the IDP configuration. FM lets you enter the well-known endpoint of your IDP and fetch the rest of the configuration for you. If you don’t know the well-known endpoint, you can still enter the other configurations manually, the well-known input being optional.

  * **Well-known URL** : Optional, defines the well-known endpoint, which is a URI ending with /.well-known/openid-configuration. Click Fetch IDP configuration to auto-complete the rest of the IDP configuration.

  * **Issuer** : The issuer is a URI to identify the IDP. It is used in particular to verify that the ID token was signed by the right IDP. Per specification, the issuer is a URI, for which you can append the path /.well-known/openid-configuration to get the IDP well-known endpoint.




Note

Tips: If you have an example of a valid ID token, you can read its content with [jwt.io](<https://jwt.io>) and find the issuer value behind the iss claim. You can then build up the well-known URI by appending /.well-known/openid-configuration to it.

  * **Authorization endpoint** : The authorization endpoint is used to redirect the user to the IDP for the authentication.

  * **Token endpoint** : The token endpoint is used by FM to exchange the authorization code with an ID token. This endpoint will be called from the backend of FM. If FM is behind a proxy, please make sure FM is able to call this endpoint.

  * **JWKs URI** : The JWKs URI is a way for the IDP to specify all its public keys. This is used by FM to verify the signature of the ID token.




Examples of well-known endpoints:

  * **Google** : <https://accounts.google.com/.well-known/openid-configuration>

  * **Azure** : <https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration>

  * **Okta** : <https://common.okta.com/.well-known/openid-configuration>

  * **Keycloak** : <https://your-keycloak-instance/auth/realms/your-realm/.well-known/openid-configuration>




Note

In some case, the well-known can be the same for everyone, like for google. In other scenario, the IDP will generate a dedicated one for your application, like Okta or Azure for which it is configured by tenant.

##### OIDC Client configuration

In the previous section, you created an OIDC client. Use this client to complete the following section:

  * **Token endpoint auth method** : This is the authentication method that FM will use to specify the credentials during the token exchange. Most of the time, when supporting client secret, the IDP will allow either of the two methods. Leave this field by default if you are unsure, as it will most likely work.

  * **Client ID** : the client ID generated by the IDP. In the IDP portal, it could be named application id. Refer to your IDP documentation for more details on how to retrieve your client ID.

  * **Client secret** : The client secret your IDP generated for this client. Sometimes, it is not generated by default by your IDP (like Azure). In this case, look for a section ‘secrets’ in your IDP setup for the OIDC client.

  * **Scope** : Specify the scope that FM needs to use during the login flow. As a minima, it should contain openid. The scope contains a list of scopes separated by spaces.




Note

The scope is essential for doing the mapping with the username, as it defines the user claims the IDP needs to send back to FM. We recommend to add either email or/and profile, two common scopes supported by most IDPs. Most IDPs will mandate that you add some dedicated permissions before associating those scopes to your OIDC client. See your IDP documentation for more details.

Note

The list of scopes supported by your IDP is listed in the well-known, under the attribute claims_supported. Even if they are supported, you will still need to authorise the OIDC client to use those scopes, via your IDP portal.

##### Examples of scopes by IDPs

For Google, Azure, Okta and Keycloak, the simplest scope is email, which will return two claims - email and email_verified. Set in Identifier claim key the claim email.

Azure, Okta and Keycloak also support another claim called preferred_username, which is returned as part of the profile scope.

Resources:

  * [Google documentation](<https://developers.google.com/identity/protocols/oauth2/openid-connect#an-id-tokens-payload>)

  * [Azure documentation](<https://docs.microsoft.com/en-us/azure/active-directory/develop/id-tokens>)

  * [Okta documentation](<https://developer.okta.com/docs/reference/api/oidc/#scope-values>)

  * [Keycloak documentation](<https://www.keycloak.org/docs/latest/securing_apps/>) (search for principal-attribute in the page)




#### Mapping to the FM user

When FM successfully retrieves the ID token from the IDP, it needs to map it to a user in FM. The ID token will contain user claims that depend on the scope you defined earlier. The following two fields will help FM map the ID token to a FM user:

  * **Identifier claim key** : Depending on the scope you configured, the IDP will return different user claims. Define here the one you want to use to map to the corresponding username in FM. One easy way that works for most IDP, is to use the email and then strip the part after the ‘@’.

  * **Login remapping rules** : Map a claim received from the IDP to your username format. Example: stripping the part after ‘@’ in an email. You may not need this field if your IDP is returning a user claim that matches exactly the username (it’s the case of keycloak if you use the preferred_username claim for example).




Warning

The Login remapping rules are evaluated in order. If you have multiple rules and their regexes overlap (ie ^(.*)@mycompany.corp$ and ^(.*)$), make sure the most specific one is defined first.

Note

Example of mapping if you choose the email as identifier claim: ^(.*)@mycompany.corp$ -> $1

Note

FM logs all the claims received from the IDP in the backend log file, which may help configuring the Identifier claim key and the mapping for it.

#### User Supplier

DSS SSO implementation is able to supply users from an SSO context. Meaning you can configure DSS to auto-provision or synchronize users when a user authenticates via SSO.

Once you have enabled the Login-time provisioning and/or Login-time resync options, you must configure the mapping between the ID token (the identity provider’s response to DSS) and the representation of an identity in DSS. See your OpenID identity provider’s documentation or contact your identity provider’s administrator for the required information.

#### Testing OIDC SSO

  * Configure OIDC integration as described above

  * Access the FM URL from another browser or an anonymous window

  * You should be redirected to the IDP for authentication, then back to the FM redirect URL, then to the FM homepage

  * If login fails, check the logs for more information




Important

Once SSO has been enabled, if you access the root FM URL, SSO login will be attempted. If SSO login fails, you will only see an error.

You can still use the regular login/password login by going to the `/login/` URL on FM. This allows you to still log in using a local account if SSO login is dysfunctional.

## SAML

### About SAML

#### Compatibility

FM has been successfully tested against the following SAML identity providers:

  * OKTA

  * PingFederate PingIdentity (see note below)

  * Azure Active Directory

  * Google G.Suite

  * Microsoft Active Directory Federation Service (tested against Windows 2012 R2)

  * Auth0

  * Keycloak




Note

For AD FS, it is mandatory to configure at least one claim mapping rule which maps to “Name ID”, even if another attribute is used as the FM login attribute.

FM does not support SAML encryption.

### Setup SAML in FM

To set up SAML integration, you need:

  * to register a new service provider entry on your SAML identity provider, for this FM instance. This entry is identified by a unique “entity ID”, and is bound to the SAML login URL for this FM instance.

  * to configure FM with the IdP parameters, so that FM can redirect non logged-in users to the IdP for authentication, and can authentify the IdP response

  * optionally, to configure which of the user attributes returned by the IdP is to be used as the FM username, or configure rewrite rules to extract the FM username from the chosen IdP attribute




These steps are individually detailed below.

#### Registering a service provider entry for FM on the identity provider.

The exact steps for this depend on the identity provider platform which you plan to connect to, and should be performed by your IdP administrator. This entry may also be called a “SAML application”.

You will typically need:

  * an “Entity ID” which uniquely represents this FM instance on the IdP (sometimes also called “Application ID URI”).

This entity ID is allocated by the IdP, or chosen by the IdP admin.

  * the SAML login URL for FM (“Assertion Consumer Service Endpoint”, which may also be called “Redirect URI”, “Callback URL”, or “ACS URL”).

This URL _must_ be configured as
        
        BASE_URL/api/saml-callback

where `BASE_URL` is the URL through which FM users access this FM instance.

For example, if FM is accessed at <https://fm.mycompany.corp>, the SAML callback URL must be defined as



    
    
    <https://fm.mycompany.corp/api/saml-callback>

Note that some SAML identity providers require the callback URL to use the HTTPS scheme.

As an additional step, you may also have to authorize your users to access this new SAML application at the IdP level.

Finally, you will need to retrieve the “IdP Metadata” XML document from the identity provider, which is required to configure FM (also called “Federation metadata document”).

#### Configuring FM for SAML authentication.

SAML configuration is in the “Settings / Security & Audit / User login & provisioning / SSO” screen.

Select “Enable”, choose protocol “SAML” and fill up the associated configuration fields:

  * IdP Metadata XML : the XML document describing the IdP connection parameters, which you should have retrieved from the IdP.

It should contain a <EntityDescriptor> record itself containing a <IDPSSODescriptor> record.

  * SP entity ID : the entity ID (or application ID) which you have configured on the IdP in the step above

  * SP ACS URL : the redirect URL (or callback URL) which you have configured on the IdP in the step above




Warning

You need to restart FM after any modification to the SAML configuration parameters.

##### Optional: configuring signed requests

If your IdP requires it (this is generally not the case) you can configure FM to digitally sign SAML requests so that the IdP can authentify them.

For this, you need to provide a file containing a RSA or DSA keypair (private key plus associated certificate), which FM will use for signing, and provide the associated certificate to the IdP so that it can verify the signatures.

This file must be in the standard PKCS#12 format, and installed on the FM host. It can be generated using standard tools, as follows:
    
    
    # Generate a PKCS12 file containing a self-signed RSA key and certificate with the "keytool" java command:
    keytool -keystore <FILENAME>.p12 -storetype pkcs12 -storepass <PASSWORD> -genkeypair -keyalg RSA -dname "CN=DSS" -validity 3650
    
    # Generate a PKCS12 file containing a self-signed RSA key and certificate with the openssl suite:
    openssl req -x509 -newkey rsa:2048 -nodes -keyout <FILENAME>.key -subj "/CN=DSS" -days 3650 -out <FILENAME>.crt
    openssl pkcs12 -export -out <FILENAME>.p12 -in <FILENAME>.crt -inkey <FILENAME>.key -passout pass:<PASSWORD>
    

You then need to complete the FM configuration as follows:

  * check the “Sign requests” box

  * Keystore file : absolute path to the PKCS#12 file generated above

  * Keystore password : PKCS#12 file password

  * Key alias in keystore : optional name of the key to use, in case the PKCS#12 file contains multiple entries




#### Choosing the login attribute

Upon successful authentication at the IdP level, the IdP sends to FM an assertion, which contains all attributes of the logged in user. Each attribute is named. You need to indicate which of the attributes contains the user’s login, that FM will use.

Note that FM logs all attributes received from the SAML server in the backend log file, which may help configuring this field.

If this field is left empty, FM will use the default SAML “name ID” attribute.

#### Login remapping rules

Optionally, you can define one or several rewriting rules to transform the selected SAML attribute into the intended FM username. These rules are standard search-and-replace Java regular expressions, where `(...)` can be used to capture a substring in the input, and `$1`, `$2`… mark the place where to insert these captured substrings in the output. Rules are evaluated in order, until a match is found. Only the first matching rule is taken into account.

A standard use case for such rewriting rules would be to strip the domain part from email-address-like attributes. For example, configuring the following rule:
    
    
    ([^@]*)@mydomain.com     ->     $1
    

would rewrite a SAML attribute `first.last@mydomain.com` into `first.last`, and do nothing on SAML attribute `first.last@otherdomain.com` (as the left-hand part of the rule would not match).

Warning

The Login remapping rules are evaluated in order. If you have multiple rules and their regexes overlap (ie ^(.*)@mycompany.corp$ and ^(.*)$), make sure the most specific one is defined first.

#### User Supplier

DSS SSO implementation is able to supply users from an SSO context. Meaning you can configure DSS to auto-provision or synchronize users when a user authenticates via SSO.

Once you have enabled the Login-time provisioning and/or Login-time resync option, in the SAML context you need to configure the mapping between the SAML assertion (the identity provider’s response to DSS) and the DSS representation of an identity. (See the documentation of your identity provider or contact your identity provider’s administrator for the required information).

#### Testing SAML SSO

  * Configure SAML integration as described above

  * Restart FM

  * Access the FM URL from another browser or an anonymous window

  * You should be redirected to the IDP for authentication, then back to the FM redirect URL, then to the FM homepage

  * If login fails, check the logs for more information




Note

Once SSO has been enabled, if you access the root FM URL, SSO login will be attempted. If SSO login fails, you will only see an error.

You can still use the regular login/password login by going to the `/login/` URL on FM. This allows you to still log in using a local account if SSO login is dysfunctional.

If the SAML configuration is invalid (in particular if the IdP metadata XML is malformed) FM will not restart. You will need to manually disable SAML in the general-settings.json configuration file as described below.

---

## [installation/cloudstacks-aws/tagging]

# Tagging on Dataiku Cloud Stacks

Dataiku Cloud Stacks (DCS) allows to tag (or label) cloud resources in order to leverage cloud provider specific features such as managing, identifying, organizing, searching for, and filtering resources. Cloud tags are supported on the following DCS entities:

  * Tenants

  * Cloud Accounts

  * Virtual Networks

  * Load Balancers

  * Instances




Cloud tags are key-value pairs that are applied as metadata on the cloud resources created by DCS during provisioning of entities like instances or load balancers. Some entities like cloud accounts are not provisioned and do not create cloud resources themselves, but tags are inherited according to the following hierarchy:

**Tenants ⇒ Cloud Accounts ⇒ Virtual Networks ⇒ Load Balancers ⇒ Instances**

This means that any cloud tags in a Tenant will be inherited by the Cloud Accounts in that Tenant, that any cloud tags in a Cloud Account will be inherited by the Virtual Networks attached to that Cloud Account, etc.

You will be able to find a list of inherited tags in the Virtual Networks, Load Balancers and Instances dashboard pages:

Cloud tags are also now displayed on the listing pages of Instances, Load Balancers, Cloud Accounts and Virtual Networks. They can also be used for filtering the list.

## Limitations

Tagging in Dataiku Cloud Stacks has some limitations related to the cloud provider that the platform is deployed on. Please refer to each Cloud specific requirements section for more information.

Tags are not updated on cloud resources while saving of the form of the entity being modified. The entity must be reprovisioned for the new tags to be applied when supported.

Virtual Networks are not reprovisionable, thus the resources created (e.g. security groups) will not be updated with new tags upon modification. However, due to the inheritance, new or reprovisioned instances and load balancers created within the Virtual Network will contain the updated tags.

Warning

The data disk of an instance is kept throughout its lifecycle, thus reprovisioning will overwrite already existing tags and add new ones, but it will not delete ones that were removed. Be mindful that tags may accumulate on the data disk of an instance if changed often and this might cause issues related to Cloud provider limitations.

## AWS specific requirements

You can find any AWS specific tagging requirements in the [AWS documentation](<https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html#tag-restrictions>)

---

## [installation/cloudstacks-aws/templates-actions]

# Instance templates and setup actions

Instance template represent common configuration for instances, reusable across several instances. It is required to use an instance template to launch an instance. Instances stay linked to their instance template for their whole lifecycle.

What is configured through the instance templates includes, but is not limited to:

  * Identities able to SSH to the instance

  * Cloud credentials for the managed DSS

  * Installation of additional dependencies and resources

  * Pre-baked and custom configurations for DSS




To create, edit and delete templates, head to the _Instance templates_ in the left menu of FM. The following document explains each section of the configuration.

## SSH keypair

Use this field to select which AWS EC2 keypair will be deployed on the instance. This is useful for admins to connect to the machine with SSH. This field is optional.

This key will be available on the `ec2-user` account (`centos` for DSS instances prior version 12), i.e. you will be able to login as `ec2-user@DSS.HOST.IP`

## AWS credentials

In most cases, your DSS instances will require AWS credentials in order to operate. These credentials will be used notably to integrate with ECR and EKS. They can also be used (optionally) for S3 connectivity.

The recommended way to offer AWS credentials to DSS instance is the use of an IAM instance profile. You can create a role, and put its instance profile ARN as the “runtime instance profile ARN” field.

Keep “restrict access to metadata server” enabled so that DSS end-users cannot access these credentials.

### Atypical options

There may be some cases where you want setup to have additional permissions, notably being able to retrieve secrets from ASM, or perform other tasks that might require permissions useful for startup only (see setup actions).

If that’s needed, you can add a “Startup instance profile ARN” that will only be available during startup and that will be replaced by the “Runtime instance profile ARN” once startup is complete.

Alternatively to IAM instance profile, you can also use a keypair that will be given to the DSS service account.

The AWS Secret Access Key can be stored in ASM (in which case the **Startup instance profile ARN** must be able to read it) or encrypted and stored by FM (in which case the **Startup instance profile ARN** must be able to user the CMK to decrypt it).

## Setup actions

Setup actions are configuration steps ran by the [agent](<concepts.html#cloudstacks-concept-agent>). As a user, you create a list a setup actions you wish to see executed on the machine.

### Install system packages

This setup action is a convenient way to install additional system packages on the machine should you need them. It takes a list of Almalinux packages as only parameter. The package name or the package URL can be used.

### Add authorized SSH key

This setup action ensures the SSH public key passed as a parameter is present in ~/.ssh/authorized_keys file of the default admin account. The default admin is the ec2-user user with currently provided images.

### Set advanced security

This setup actions ensures DSS add security related HTTP headers. HSTS headers can be toggled separately.

### Install a JDBC driver

Instances come pre-configured with drivers for PostgresSQL, MariaDB, Snowflake, AWS Athena and Google BigQuery. If you need another driver, this setup action eases the process. It can download a file by HTTP, HTTPS, from S3 bucket or from an ABS container.

Install JDBC Driver parameters Parameter | Expected value  
---|---  
Database type |  The type of database you will use. This parameter has no actual effect, it is used for readability.  
URL |  This field expects the full address to the driver file or archive.   
Download from HTTP(S) endpoint:
    
    
    http(s)://hostname/path/to/file.(jar|tar.gz|zip)
    

Redirections are solved before download.   
Download from a S3 bucket:
    
    
    s3://BUCKET_NAME/OBJECT_NAME
    

Download from Azure Blob Storage:
    
    
    abs://STORAGE_ACCOUNT_NAME/CONTAINER_NAME/OBJECT_NAME
    

Use a driver available on the machine:
    
    
    file://path/to/file.(jar|tar.gz|zip)
      
  
Paths in archive |  This field must be used when the driver is shipped as a tarball or a ZIP file. Add here all the paths to find the JAR files in the driver archive. Paths are relative to the top of the archive. Wildcards are supported. Examples of paths:
    
    
    *.jar
    
    
    
    subdirA/*.jar
    subdirB/*.jar
      
  
HTTP Headers | List of HTTP headers to add to the query. One header per line.
    
    
    Header1: Value1
    Header2: Value2
    

Parameter ignored for all other kinds of download.  
HTTP Username |  **HTTP**   
If the endpoint expect Basic Authentication, use this parameter to specify the user name.   
**Azure**   
If the instance have several Managed Identities, set the _client_id_ of the targeted one in this parameter.   
To connect to Azure Blob Storage with a SAS Token (not recommended), set the value of this parameter to _token_.  
HTTP Password |  **HTTP**   
If the endpoint expect Basic Authentication, use this parameter to specify the password.   
**Azure**   
To connect to Azure Blob Storage with a SAS Token (not recommended), store the token value in this parameter.  
Datadir subdirectory | For very specific use-cases only, we recommend to let it empty.  
  
### Run Ansible tasks

This setup action allows you to run arbitrary ansible tasks at different point of the startup process.

The **Stage** parameter specificies at which point of the startup sequence it must be executed. There is three stages:

  * **Before DSS install** : These tasks will be run before the agent installs (if not already installed) or upgrades (if required) DSS.

  * **After DSS install** : These tasks will be run once DSS is installed or upgraded, but not yet started.

  * **After DSS is started** : These tasks will be run once DSS is ready to receive public API calls from the agent.




The **Ansible tasks** allows you to Write a YAML list of ansible tasks as if they were written in a role. Available tasks are base Ansible tasks and [Ansible modules for Dataiku DSS](<https://github.com/dataiku/dataiku-ansible-modules>). When using Dataiku modules, it is not required to use the connection and authentication options. It is automatically handled by FM.

Some additional facts are available:

  * dataiku.dss.port

  * dataiku.dss.datadir

  * dataiku.dss.version

  * dataiku.dss.node_id: Identifier matching the node id in Fleet Manager, unique per fleet

  * dataiku.dss.node_type: Node type is either design, automation, deployer or govern

  * dataiku.dss.logical_instance_id: Unique ID that identifies this instance in the Fleet Manager

  * dataiku.dss.instance_type: The cloud instance type (also referred to as instance size) used to run this instance

  * dataiku.dss.was_installed: Available only for stages **After DSS install** and **After DSS startup**

  * dataiku.dss.was_upgraded: Available only for stages **After DSS install** and **After DSS startup**

  * dataiku.dss.api_key: Available only for stage **After DSS startup**




Example:
    
    
    ---
    - dss_group:
        name: datascienceguys
    - dss_user:
        login: dsadmin
        password: verylongbutinsecurepassword
        groups: [datascienceguys]
    

Ansible is ran with the unix user held by the agent, and can run administrative tasks with become.

### Setup Kubernetes and Spark-on-Kubernetes

This task takes no parameter and pre-configures DSS so you can use Kubernetes clusters and Spark integration with them. It prepares the base images and enables DSS Spark integration.

### Add environment variables

This setup action enables to add environment variables that can be used in DSS. These variables are stored in bin/env-site.sh file.

### Add properties

Ansible is ran with the unix user held by the agent, and can run administrative tasks with become.

### Add SSH keys

This setup action enables to add SSH keys to ~/.ssh folder that can be used to connect to other machines from the DSS one.

To generate your public key on Dataiku Cloud:

  * go to your launchpad > extension tab > add an extension,

  * select the SSH integration feature,

  * enter the hostnames of the remote that this key is allowed to connect to,

  * click to validate and generate the key.




Dataiku Cloud will then automatically generate the key and run a command to the origin to get (and verify) the SSH host key of this server. You can now copy the generated key and add it to your hosts. To find this key in the future or generate a new one go to the extension tab and edit the SSH Integration feature.

### Setup proxy

This setup action enables to configure a proxy in front of DSS.

The default value for the NO_PROXY variable is: localhost,127.0.0.1,169.254.169.254.

169.254.169.254 is the IP used by AWS to host the metadata service.

### Add Certificate Authority to DSS truststore

This setup action is a convenient way to add a Certificate Authority to your DSS instances’ truststore. It will then be trusted for Java, R and Python processes. It takes a Certificate Authority in the public PEM format. A chain of trust can also be added by appending all the certificates in the same setup action.

Example (single CA):
    
    
    -----BEGIN CERTIFICATE-----
    (Your Root certificate authority)
    -----END CERTIFICATE-----
    

Example (Chain of Trust):
    
    
    -----BEGIN CERTIFICATE-----
    (Your Primary SSL certificate)
    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----
    (Your Intermediate certificate)
    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----
    (Your Root certificate authority)
    -----END CERTIFICATE-----
    

Warning

The name must be unique for each CA as it is used to write the CA in your instances.

### Install code env with Visual ML preset

This setup action installs a code environment with the Visual Machine Learning and Visual Time series forecasting preset.

Enable **Install GPU-based preset** to install the GPU-compatible packages. Otherwise, the CPU packages are installed.

Leaving **Allow in-place update** enabled means that if there is a newer version of the preset the next time the setup action runs, and it is compatible with the previously installed code environment, said code environment is updated in place. Otherwise, a new code environment is created with the updated preset.

---

## [installation/cloudstacks-aws/tenant-settings]

# Global settings

There are only a few global settings in Fleet Manager, accessible from the “Cloud Setup” screen.

## AWS authentication

Fleet Manager needs to perform various calls to the AWS API in order to manage resources.

The recommended way is to ensure that the instance that is running Fleet Manager has an IAM instance profile with the proper permissions. See [Guided setup 1: Deploy in a new VPC with Elastic Compute](<guided-setup-new-vpc-elastic-compute.html>) for more details. In that setup, you should keep the AWS authentication mode to “Same as Fleet Manager”.

## Secrets encryption

If you use Fleet Manager to store secrets, these secrets will be encrypted with an AWS KMS CMK.

Secrets that can be stored are:

  * AWS credentials for DSS (not recommended, see [Instance templates and setup actions](<templates-actions.html>) for more details)

  * SSL certificates (only if you use “custom certificate” mode, see [Virtual networks](<virtual-networks.html>) for more details)




## License

In order to benefit from most capabilities, you’ll need a Dataiku License or Dataiku License Token. You need to enter it here.

## HTTP proxy

Fleet Manager can run behind a proxy. Once you define at least a proxy host and port, Fleet Manager will use it to access different resources through HTTP:

  * to fetch new DSS image lists

  * to update or verify licenses

  * to log users in with the OpenID Connect protocol




The calls to AWS services won’t be proxied. As such, please make sure the following AWS services you require are reachable from the Fleet Manager virtual machine: EC2, STS, Route53 and KMS. You can for example create VPC private endpoints to make AWS services available on the local network of the Fleet Manager virtual machine.

---

## [installation/cloudstacks-aws/virtual-networks]

# Virtual networks

A virtual network in Fleet Manager is an object representing the networking setup of instances created into it.

The virtual network defines in which VPC and subnet the instances will be launched, as well as how DNS hostnames and HTTPS certificates for the instances will be used.

Each instance belongs to a virtual network. At least one virtual network is required to deploy instances.

## Networking requirements

The most important requirement is that the DSS instances must be able to reach FM on its main port. FM has a single URL that must be reachable by all DSS instances it creates, even if they span over several networks.

## Creation

Go to _Virtual networks_ and click on _New virtual network_ at the top right. You will be required to provide the mandatory values for virtual networks:

  * _Label_ : the name of the network that will be displayed in FM. It can be changed later.

  * _VPC id_ : Id of the VPC in which you want to deploy instances. If is pre-filled with the VPC in which FM is currently running. It cannot be changed after creation.

  * _Subnet id_ : Id of the subnet in which you want to deploy instances. If is pre-filled with the subnet in which FM is currently running. It cannot be changed after creation.

  * _Security groups_ : By default, FM automatically creates security groups when creating the virtual network. You can also manually list security groups you want attached on the created instances.




Note

Auto-creation of security groups adds two groups:

  * A security group that opens SSH (22), HTTP (80) and HTTPS (443) on all traffic.

  * A “default”-like security group that allows all traffic between instances having it attached. It is used for elastic AI setups where clusters need to be able to contact back the instances.




## Edition

Once a virtual network has been created, you can edit its settings.

### Public IP address

By default, FM assigns public IPs to your instances. You can disable this. Note that this requires that the subnet on which the instances are started has a default route through an Internet Gateway

Changing the public IP policy requires reprovisioning the affected instances.

### DNS Strategy

By default, instances only get IP addresses. FM can assist in assigning hostnames. It is also required if you want to apply a verified HTTPS strategy.

Changing the DNS strategy requires reprovisioning the affected instances.

In the virtual networks list, click on the desired network to display its dashboard, then select the _Settings_ tabs to change the configuration. Select _Assign a Route53 domain name_ in the _DNS Strategy_ drop-down menu. Then fill in the Zone ID for each required zone, one to have DNS records for private IPs, a second one for the public IPs. If you need only one, let the unused field empty. Click on _Save_ at the top right to apply your changes.

If using DNS records for both private IPs and public IPs, the zone IDs must be distinct.

The IAM Role used by the Fleet Manager must have the following permissions:

> 
>     route53:GetHostedZone
>     route53:ChangeResourceRecordSets
>     

### HTTPS configuration

When using this strategy, instances are deployed with self-signed certificates. These will trigger security alerts in your browser.

FM supports several strategies for configuring HTTPS.

#### None

This is the default. This simple mode means no certificate is involved and instances are exposed on HTTP.

#### Self-signed certificate

When using this strategy, each instance will create its own self-signed certificate if none exists yet, and uses it to expose DSS on port 443. You can choose wether HTTP is closed or redirects to HTTPS.

Additional domain names can be handled by the self-signed certificate at instance level.

#### Custom certificate for each instance

Select _Enter a certificate/key for each instance_ to use the certificates emitted with by your PKI. When using this strategy, each instance will have to be configured with the certificate and private key intended for it. The secret key can be stored encrypted by FM or into your cloud provider secret manager.

You can choose wether HTTP is closed or redirects to HTTPS.

This mode requires instance level settings.

##### Let’s Encrypt

This mode makes use of [Let’s Encrypt](<https://letsencrypt.org/>) and [certbot](<https://certbot.eff.org/>) to generate and renew automatically a publicly recognized certificate. When using this mode, you must specify an email address representing the legal person owning the certificate.

Instances must be reachable on HTTP (80) and HTTPS (443) from the internet.

Additional domain names can be added at instance level.

Warning

Let’s Encrypt service has [rate limits](<https://letsencrypt.org/docs/rate-limits/>) that makes it unsuitable for numerous deletions and creations. Be careful to use it for stable deployments. If you hit your quota, there is no way to reset it.

---

## [installation/cloudstacks-azure/concepts]

# Conceptual overview

## Fleet Manager (FM)

The Dataiku Cloud Stacks for Azure setup uses a central component, called Dataiku Fleet Manager (FM) in order to deploy, upgrade, backup, restore and configure one or several Dataiku instances.

Fleet Manager handles the entire lifecycle of the Dataiku instances, freeing you from most administration tasks. The instances managed by Fleet Manager come builtin with the ability to scale computation on elastic computation clusters, powered by Kubernetes.

To deploy Dataiku Cloud Stacks for Azure, Dataiku provides an ARM template that deploys Fleet Manager. From Fleet Manager, you then deploy the Dataiku instances.

## Instance

An instance is a single installation of a DSS design node, automation node or deployer node. It is the main object manipulated by FM. Each instance is backed by a virtual machine dedicated to it.

When you create an instance, you _provision_ it. Provisioning an instance means FM creates the required cloud resources to host the DSS node. See [instances lifecycle](<instances.html#azure-cloudstacks-instance-lifecycle>) for more information.

## Instance template

An instance template is a set of configuration information that can be reused to start several instances with common properties. An instance is always launched from an instance template and stays linked to it throughout its lifetime.

Enabling Stories on the instance template will set up Stories on compatible nodes (design and automation).

Modifying an instance template impacts the provisioning behavior of all the instances launched from it. Reprovisioning is not enforced, but required for the new setup to be applied.

## Virtual network

A virtual network represents the network context in which the instances will be launched. That means a reference to the virtual network used in the cloud provider, but also other configurations such as how DNS and HTTPS are handled.

Instance templates are not tied to a specific virtual network.

## Load balancer

A load balancer is a device that distributes traffic across different instances.

It acts as an application gateway by linking hostnames to various instances and helps secure inbound traffic.

For automation nodes, it can also perform actual load balancing to ensure high availability.

## Account

An account represents an identity manipulating the objects in the cloud on behalf of Fleet Manager.

## Agent

The FM agent is a Dataiku software that runs alongside DSS in your instances. It manages communication with the FM server, sends technical information to it, and performs administrative tasks on behalf of the FM server authority.

---

## [installation/cloudstacks-azure/dss-backup]

# Backup and restore of DSS instances

## Manual snapshots

You can manually backup your instance at any time by clicking on **New snapshot** in the **Snapshots** tab of the instance. It is not required to stop or deprovision the instance to make a snapshot. It has no impact on the instance users.

## Automated snapshots

You can enable automated snapshots in the **Settings** tab of the instance. Once enabled, FM will create snapshots at the required frequency and delete old snapshots if required, by specifying a maximum number of snapshots.

---

## [installation/cloudstacks-azure/dss-upgrade]

# Upgrades of DSS instances

Fleet Manager manages upgrades of DSS. Upgrades are always done under administrator control and are not performed automatically.

To upgrade an instance:

  * Go to the settings of the instance

  * In the “Version” field, select the new DSS version you want to upgrade to

  * Reprovision the instance




Upon reprovisioning, DSS will start a new virtual machine with the new DSS version and will reattach the data volume to the new DSS version, performing any upgrade on the fly as required.

## Updating the list of available versions

If your Fleet Manager instance has direct outgoing Internet access (without proxy), Fleet Manager will automatically fetch the list of newly available DSS versions, and these versions will appear directly in your Fleet Manager.

If this is not the case, please contact your Dataiku Technical Account Manager or Customer Success Manager.

---

## [installation/cloudstacks-azure/fm-upgrade]

# Upgrading FM

## Description

This guided setup allows you to upgrade an existing Dataiku Cloud Stacks for Azure. It assumes you had followed [the guided setup example](<guided-setup-new-vnet-elastic-compute.html>) to build your initial setup.

## Steps

Warning

For any upgrade to Fleet Manager version 12.6.0 or higher, it is required to previously stop the virtual machine hosting Fleet Manager, or the upgrade process could fail.

### Stop Fleet Manager server

  * Go into the resource group into which the deployment was made. We call it `<resource-group>`

  * Find the machine hosting Fleet Manager. Its name should be `<resource-group>-instance`

  * Click on its name, the instance blade opens

  * In _Properties_ tab, section _Networking_ , find the _Private IP address_ of the instance and make a note of it

  * Click on the _Stop_ button

  * Wait for the machine the reach the state _Stopped (deallocated)_




### Backup Fleet Manager’s data disk

  * Find the data disk, its name should be `<resource-group>-instance-data-disk`

  * Click on its name, the volume blade opens

  * Click on _\+ Create snapshot_

  * Choose an identifiable name, for instance `fm-backup-YYYYMMDD`, and click on _Review+Create_

  * Click on _Create_

  * Wait for the deployment to finish, and click on _Go to resource_

  * Click on _Properties_ in the left menu and make a note of _Resource ID_ value




### Delete the existing server

  * Go back to the instance of step _Stop Fleet Manager server_

  * Click on _Delete_

  * On the blade opening from the right hand side, select _OS disk_ and _Data disks_ , do not select the network resources

  * Tick the deletion disclaimer then click on _Delete_ at the bottom of the blade

  * Wait for the resources (machine and disks) to disappear from the resource group even after multiple refreshes of the resources list




### Create the new stack

  * Follow [the guided setup example](<guided-setup-new-vnet-elastic-compute.html>) to deploy the new version of Fleet Manager

    * Populate the _Private Ip Address_ field with the previous FM IP address previously noted

    * Populate the _Snapshot_ field with the snapshot _Resource ID_ previously noted




## Troubleshooting

### PostgreSQL related error messages

If you are troubleshooting a non-responsive Fleet Manager after an upgrade, you might want to observe the logs displayed by `sudo journalctl -u fm-setup`.

If you see the message `Postgres server cannot be upgraded because it was not stopped properly. Please consult documentation.` or `PostgreSQL upgrade failed`, it is likely the machine hosting Fleet Manager was not properly stopped before the upgrade. You can fix it by **upgrading** to an intermediate version first.

Follow these instructions:

  * Replay step _Stop Fleet Manager server_ above

  * Make sure you still have the snapshot ID of the last working version of Fleet Manager

  * Replay step _Delete the existing server_ above

  * Replay step _Create the new stack_ above clicking on the button below instead


[](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fdkutemplates.blob.core.windows.net%2Ffleet-manager-templates%2F12.5.2%2Ffleet-manager-network-fixed.json>)

  * Resume the upgrade process




### DSS machines seem unresponsive

In case the DSS machines seem unresponsive in the FM UI following the upgrade, reprovision the different DSS machines for them to be able to communicate again with FM.

---

## [installation/cloudstacks-azure/guided-setup-new-vnet-elastic-compute]

# Guided setup 1: Deploy in a new VNet with Elastic Compute

## Description

This guided setup allows you to setup a full Dataiku Cloud Stacks for Azure setup, including the ability to run workloads on Elastic Compute clusters powered by Kubernetes (using Azure AKS).

At the end of this setup, you’ll have:

  * A fully-managed DSS design node, with either a public IP or a private one

  * The ability to one-click create elastic compute clusters

  * The elastic compute clusters running with public IPs (and no NAT gateway overhead)




## Prerequisites

You need to have, as an administrator, the Owner role on the resource group. Ownership is required to give permissions to the managed identities used by the software at runtime. Said identities do not require to have the role Owner themselves. Owner privileges are only used by the administrator for initial setup and is not required by the software during usage.

For the following steps, we assume an ACR (Azure Container Registry) is created and available in your resource group.

## Steps

### Create a managed identity for your Fleet Manager instance

  * In your Microsoft Azure portal, click on “Create a resource”

  * Search for “User Assigned Managed Identity”

  * Click on create

  * Select the correct subscription and resource group

  * Select the region

  * Enter a name for your managed identity, this will be referred as `fm-id-name`

  * Click on “Review + Create”, then on “Create”

  * When your deployment is ready, click on “Go to resource”

  * Click on “Azure role assignments”, then “Add role assignment”

  * For the “Scope”, select “Resource group”

  * Select the correct subscription and resource group

  * For the “Role” select “Contributor”

  * Click on “Save”

  * Go to the “Properties” tab and copy the “Resource ID”, this will be refered as `fm-id`




### Create a managed identity for your DSS instances

Reproduce the exact same step as above (i.e. the steps for the Fleet Manager managed identity) for the DSS managed identity. We will refer to its name by `dss-id-name` and to its “Resource ID” by `dss-id`

As a consequence of role assignments inheritance, this identity is also Contributor on the ACR.

### Deploy Fleet Manager

Click the following link to deploy the Fleet Manager and all needed resources from the Azure portal:

[](<https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fdkutemplates.blob.core.windows.net%2Ffleet-manager-templates%2F14.5.1%2Ffleet-manager-network.json>)

In the portal fill the required information for the deployment:

  * Choose the target subscription

  * Choose an existing resource group or create a new one

  * Select the region where the resource should be deployed

  * Select the size of the Virtual machine

  * In “Instance identity”, enter the `fm-id-name`

  * In “Username”, choose a username for logging in to Fleet Manager

  * In “Password”, enter a strong password for logging in to Fleet Manager

  * In “SSH Username”, choose a username for logging in to the underlying Fleet Manager virtual machine (it is not normally required)

  * In “SSH public key source”, enter a RSA public key for SSH logging in to the underlying Fleet Manager virtual machine (it is not normally required)

  * In “Virtual Network CIDR”, enter a /16 CIDR, for example `10.0.0.0/16`

  * In “Subnet CIDR”, enter a CIDR included in the chosen Virtual Network CIDR, for example `10.0.1.0/24`

  * In “Secondary subnet CIDR”, enter a CIDR included in the chosen Virtual Network CIDR that does not overlap with the previously chosen Subnet CIDR, for example `10.0.2.0/24`

  * In “Associate Public Ip Address”, select whether you want a public IP to connect to Fleet Manager

  * In “Resources Tags”, you can optionally add tags that you would like to be applied to the resources deployed. They must be valid according to Azure guidelines. Example:



    
    
    {
      "tag_key": "tag_value",
      "tag_novalue": ""
    }
    

  * Click on “Review + create”

  * Verify the creation information, then click on “Create”

  * Wait for your deployment to appear as completed

  * Click on “Go to resource group”

  * Click on the Virtual Machine

  * Copy the “Public IP address”




This is the address at which your Cloud Stacks Fleet manager is deployed. Open a new tab to this address and wait for the login screen to appear.

### Start your first DSS

  * Log into Fleet Manager with the login and the password you previously entered

  * In “Cloud Setup”, click on “Edit”, set “License mode” to “Manually entered”, click on “Enter license” and enter your Dataiku license. Click on “Done” then on “Save”

  * Refresh the page in your browser

  * In “Fleet Blueprints”, click on “Elastic Design”

  * Give a name to your new fleet, this will be referred to as `fleet-name`

  * In “Authorized SSH Key”, enter your RSA public key

  * In “Instance managed identity”, enter the `dss-id`

  * Click on “Deploy”

  * Go to “Instances > All”, click on the design node

  * Click “Provision”

  * Wait for your DSS instance to be ready

  * Click on “Retrieve password” and write-down the password

  * Click on “Go to DSS”

  * Login with “admin” as the login, and the password you just retrieved




You can now start using DSS

### (Optional) Start your first Elastic compute cluster

#### Deploy your Elastic Compute cluster

  * In DSS, go to Administration > Clusters

  * Click on “Create AKS cluster”, give it a name

  * In “Credentials”, check it is set to “Manually defined” -> “Default credentials, from environment”

  * In section “Identity assumed by cluster components”, check it is set to “Manually defined” -> “Managed identities”. The option “Inherit DSS identity” should be checked.

  * In “Cluster Nodes”, Click on “+ Add a preset”

  * Update “Machine type” and “Disk size” as you see fit

  * Tick the “Enable nodes autoscaling” box

  * Untick the “Availability zones” option in “Networking” section of the node pool.

  * In “Service CIDR” add a CIDR for your cluster, it should not overlap `10.0.0.0/16`. For example: `10.1.0.0/16`

  * In “DNS IP”, set an IP for the DNS, in your specified CIDR range. For example: `10.1.0.10`

  * Click on “Start”

  * Wait for your cluster to be available

  * In Settings, go to “Containerized execution”, and in “Default cluster”, select the cluster you just created.

  * Click on “+ Add another config”

  * In “Configuration name” add a name

  * In “Image registry url” enter `acr-name`.azurecr.io

  * In “Image pre-push hook”, select “Enable push to ACR”

  * Click on “Save” then “Push base images”. When finished, click on “(Re)Install Jupyter kernels”.

  * In a project, you can now use containerized execution for any activity, using the containerized config you created




## Troubleshooting

### “Tenant ID, application ID, principal ID, and scope are not allowed to be updated (code: RoleAssignmentUpdateNotPermitted)”

This error is known to happen whenever a new stack is deployed in a resource group in which an existing stack have been deleted. The most likely reason is some role assignments were left over and must be deleted before you can deploy again.

  * In your Microsoft Azure portal, display your resource group, then click on “Access Control (IAM)”

  * Select the “Role assignments” tab in the right blade.

  * Find all the entries with name “Identity not found” and scope “This resource” and select them.

  * Click on the “Remove” button at the top of the blade.

  * You can then redeploy the ARM template. No need to delete the resources which creation succeeded, just redeploy it like you did before the failure.




### “The requested identity has not been assigned to this resource”

This error means you instructed DSS to authenticate with a specific User Assigned Managed Identity but this specific identity has not been assigned to the machine. Check your instance template for correct assignment of the desired identity, and reprovision if the error persists.

---

## [installation/cloudstacks-azure/high-availability]

# High availability

Fleet Manager enables high availability for automation nodes.

## Load balancing

Fleet Manager manages load balancers.

When defining load balancer node mappings, a single hostname can be associated with multiple automation nodes to enable load balancing between them.

## Deployer infrastructures

When an automation node is added to a fleet containing a deployer node, the necessary infrastructure is automatically created in the deployer node to allow deployments to the new automation node.

If the **Create a single-node infrastructure** option is enabled on the automation node, a single-node infrastructure will be created, allowing deployments only to this node.

If the automation node is placed behind a load balancer, a multi-node infrastructure will be created. As additional nodes are added behind the same hostname, the multi-node infrastructure will expand accordingly. This setup enables deployments to all nodes that make up the high-availability infrastructure simultaneously.

---

## [installation/cloudstacks-azure/how-to-setup-fm-init-scripts]

# Howto: Install a script on your Fleet Manager to be run at VM restart time

This application note documents how it is possible to install scripts on the Fleet Manager (FM) VM so that they are run when the VM is restarted.

## Overview

The FM startup process looks for folders `/data/etc/dataiku-fm-init-scripts/{before|after}-startup.d` in the VM. The shell executable scripts found in these folders will be executed in lexicographic order respectively before or after FM startup.

The logs for the different executions will be stored in `/data/var/log/dataiku-fm-init-scripts/{before|after}-startup.d` with the execution time in the file name.

Both scripts and script logs are available in FM diag.

## Installing scripts

Let’s take the example of a script to be executed before FM startup.

In order to install the script, SSH on the FM machine and run the following:
    
    
    sudo su root
    mkdir -p /data/etc/dataiku-fm-init-scripts/before-startup.d
    chown dataiku:dataiku /data/etc/dataiku-fm-init-scripts/before-startup.d
    cd /data/etc/dataiku-fm-init-scripts/before-startup.d
    touch test.sh
    chmod +x test.sh
    # implement your script in test.sh
    # change script folder to after-startup.d if you want the script to run after FM startup
    

## Script examples

### Deprovision DSS nodes for the night

#### Overview

This script will create all the necessary to install a system.d timer running every night at 8:00 PM in order to deprovision all the DSS machines listed in this FM instance.

Machine deprovisioning can be prevented by adding tag `no-auto-deprovision` to the machines needing it.

#### Script

Create an executable bash script in `/data/etc/dataiku-fm-init-scripts/after-startup.d` with the following code:
    
    
    #!/usr/bin/env bash
    
    # Get an API key and API secret for FM Python API
    output="$(sudo -u dataiku /data/dataiku/fmhome/bin/fmadmin create-personal-api-key admin /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes_credentials.json)"
    
    # create the Python script deprovisioning the instances
    if [ ! -f /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes.py ]; then
    cat > /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes.py << EOF
    import dataikuapi
    import sys
    import json
    from pathlib import Path
    from dataikuapi.fm.instancesettingstemplates import FMSetupAction, FMSetupActionType
    
    FM_URL = "http://localhost:10000"
    NO_DEPROVISION_TAG = "no-auto-deprovision"
    
    def read_credentials(credentials_file_location):
        credentials_file_path = Path(credentials_file_location)
        if not credentials_file_path.is_file():
            raise Error("The provided credentials path does not match an existing JSON file")
    
        try:
            with open(credentials_file_location) as credentials_file:
                credentials_json = json.load(credentials_file)
            if not "id" in credentials_json or not "secret" in credentials_json:
                raise Error("The provided credentials file has incorrect JSON format")
        except:
            raise Error("The provided credentials file has incorrect JSON format")
    
        api_key = credentials_json["id"]
        api_secret = credentials_json["secret"]
    
        return api_key, api_secret
    
    def read_cloud():
        user_data_file_location = "/data/dataiku/fmhome/config/user-data.json"
        with open(user_data_file_location) as user_data_file:
            user_data = json.load(user_data_file)
        return str.lower(user_data['cloud'])
    
    def deprovision_instances(cloud, credentials_file_location):
        # Read credentials from the JSON file
        api_key, api_secret = read_credentials(credentials_file_location)
    
        # Create an FM client
        if cloud == "aws":
            print("Creating FM client for AWS")
            fm_client = dataikuapi.FMClientAWS(FM_URL, api_key, api_secret)
        elif cloud == "gcp":
            print("Creating FM client for GCP")
            fm_client = dataikuapi.FMClientGCP(FM_URL, api_key, api_secret)
        elif cloud == "azure":
            print("Creating FM client for Azure")
            fm_client = dataikuapi.FMClientAzure(FM_URL, api_key, api_secret)
        else:
            print(f"Unknown cloud provider: {cloud}")
    
        # List and display instances with their status in a table
        instances = fm_client.list_instances()
        futures = []
    
        print("Listing instances to be deprovisioned...")
        for instance in instances:
            if NO_DEPROVISION_TAG in instance.instance_data["fmTags"]:
                print(f"  - Skipping deprovision for instance with ID [{instance.instance_data['id']}]")
                continue
            instance_status = instance.get_status()
            if 'hasPhysicalInstance' in instance_status and instance_status['hasPhysicalInstance']:
                print(f"  - Scheduling deprovision for instance with ID [{instance.instance_data['id']}]")
                futures.append(instance.deprovision())
    
        print("Deprovisioning instances...")
        for future in futures:
            future.wait_for_result()
    
        print("Completed")
    
    if __name__ == "__main__":
        credentials_file_location = sys.argv[1]
    
        deprovision_instances(read_cloud(), credentials_file_location)
    EOF
    fi
    
    # Create system.d service file
    if [ -f /etc/systemd/system/deprovision_fm_nodes.timer ]; then
    systemctl stop deprovision_fm_nodes.timer
    rm -f /etc/systemd/system/deprovision_fm_nodes.timer
    fi
    
    if [ -f /etc/systemd/system/deprovision_fm_nodes.service ]; then
    rm -f /etc/systemd/system/deprovision_fm_nodes.service
    fi
    
    cat > /etc/systemd/system/deprovision_fm_nodes.service << EOF
    [Unit]
    Description="Deprovision DSS machines for the night"
    
    [Service]
    ExecStart=/data/dataiku/fmhome/pyenv/bin/python /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes.py "/data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes_credentials.json"
    EOF
    
    # Create system.d corresponding timer file
    cat > /etc/systemd/system/deprovision_fm_nodes.timer << EOF
    [Unit]
    Description="Deprovision DSS nodes attached to this FM for the night"
    
    [Timer]
    OnCalendar=Mon..Fri *-*-* 20:00
    Unit=deprovision_fm_nodes.service
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    # Load the new files
    systemctl daemon-reload
    
    # Start timer
    systemctl start deprovision_fm_nodes.timer
    
    # Check timer status to have it in logs
    systemctl status deprovision_fm_nodes.timer
    

### Provision DSS nodes in the morning

#### Overview

This script will create all the necessary to install a system.d timer running every morning at 8:00 AM in order to provision all the DSS machines listed in this FM instance.

Machine provisioning can be prevented by adding tag `no-auto-provision` to the machines needing it.

#### Script

Create an executable bash script in `/data/etc/dataiku-fm-init-scripts/after-startup.d` with the following code:
    
    
    #!/usr/bin/env bash
    
    # Get an API key and API secret for FM Python API
    output="$(sudo -u dataiku /data/dataiku/fmhome/bin/fmadmin create-personal-api-key admin /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes_credentials.json)"
    
    # create the Python script provisioning the instances
    if [ ! -f /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes.py ]; then
    cat > /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes.py << EOF
    import dataikuapi
    import sys
    import json
    from pathlib import Path
    from dataikuapi.fm.instancesettingstemplates import FMSetupAction, FMSetupActionType
    
    FM_URL = "http://localhost:10000"
    NO_PROVISION_TAG = "no-auto-provision"
    
    def read_credentials(credentials_file_location):
        credentials_file_path = Path(credentials_file_location)
        if not credentials_file_path.is_file():
            raise Error("The provided credentials path does not match an existing JSON file")
    
        try:
            with open(credentials_file_location) as credentials_file:
                credentials_json = json.load(credentials_file)
            if not "id" in credentials_json or not "secret" in credentials_json:
                raise Error("The provided credentials file has incorrect JSON format")
        except:
            raise Error("The provided credentials file has incorrect JSON format")
    
        api_key = credentials_json["id"]
        api_secret = credentials_json["secret"]
    
        return api_key, api_secret
    
    def read_cloud():
        user_data_file_location = "/data/dataiku/fmhome/config/user-data.json"
        with open(user_data_file_location) as user_data_file:
            user_data = json.load(user_data_file)
        return str.lower(user_data['cloud'])
    
    def provision_instances(cloud, credentials_file_location):
        # Read credentials from the JSON file
        api_key, api_secret = read_credentials(credentials_file_location)
    
        # Create an FM client
        if cloud == "aws":
            print("Creating FM client for AWS")
            fm_client = dataikuapi.FMClientAWS(FM_URL, api_key, api_secret)
        elif cloud == "gcp":
            print("Creating FM client for GCP")
            fm_client = dataikuapi.FMClientGCP(FM_URL, api_key, api_secret)
        elif cloud == "azure":
            print("Creating FM client for Azure")
            fm_client = dataikuapi.FMClientAzure(FM_URL, api_key, api_secret)
        else:
            print(f"Unknown cloud provider: {cloud}")
    
        # List and display instances with their status in a table
        instances = fm_client.list_instances()
        futures = []
    
        print("Listing instances to be provisioned...")
        for instance in instances:
            if NO_PROVISION_TAG in instance.instance_data["fmTags"]:
                print(f"  - Skipping provision for instance with ID [{instance.instance_data['id']}]")
                continue
            instance_status = instance.get_status()
            if 'hasPhysicalInstance' in instance_status and not instance_status['hasPhysicalInstance']:
                print(f"  - Scheduling provision for instance with ID [{instance.instance_data['id']}]")
                futures.append(instance.reprovision())
    
        print("Provisioning instances...")
        for future in futures:
            future.wait_for_result()
    
        print("Completed")
    
    if __name__ == "__main__":
        credentials_file_location = sys.argv[1]
    
        provision_instances(read_cloud(), credentials_file_location)
    EOF
    fi
    
    # Create system.d service file
    if [ -f /etc/systemd/system/provision_fm_nodes.timer ]; then
    systemctl stop provision_fm_nodes.timer
    rm -f /etc/systemd/system/provision_fm_nodes.timer
    fi
    
    if [ -f /etc/systemd/system/provision_fm_nodes.service ]; then
    rm -f /etc/systemd/system/provision_fm_nodes.service
    fi
    
    cat > /etc/systemd/system/provision_fm_nodes.service << EOF
    [Unit]
    Description="Provision DSS machines in the morning"
    
    [Service]
    ExecStart=/data/dataiku/fmhome/pyenv/bin/python /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes.py "/data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes_credentials.json"
    EOF
    
    # Create system.d corresponding timer file
    cat > /etc/systemd/system/provision_fm_nodes.timer << EOF
    [Unit]
    Description="Provision DSS nodes attached to this FM in the morning"
    
    [Timer]
    OnCalendar=Mon..Fri *-*-* 08:00
    Unit=provision_fm_nodes.service
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    # Load the new files
    systemctl daemon-reload
    
    # Start timer
    systemctl start provision_fm_nodes.timer
    
    # Check timer status to have it in logs
    systemctl status provision_fm_nodes.timer

---

## [installation/cloudstacks-azure/index]

# Dataiku Cloud Stacks for Azure

This setup allows you to deploy a fully-managed Dataiku setup on Azure. The setup comes fully-featured with Elastic AI, advanced security, R support, auto-healing setup, …

Everything is deployed in your cloud tenant, Dataiku does not have access to your data.

---

## [installation/cloudstacks-azure/instances]

# Instances

Fleet Manager manages three kinds of DSS instances:

  * Design nodes

  * Execution (aka automation) nodes

  * Deployer nodes (usually you only have a single deployer node in your fleet)




## Dashboard

The main screen through which you will get information about your instance is the dashboard. It is refreshed automatically and displays basic network information, data disk usage as well as the [agent](<concepts.html#azure-cloudstacks-concept-agent>) logs.

## Lifecycle

### Provisioning

The provisioning is the sequence of operations required to have a running DSS reachable by users. Provisioning an instance has two main stages:

  * The provisioning of cloud resources required for the instance to run. It is mostly a virtual machine and a data disk.

  * A software startup sequence run by the [agent](<concepts.html#azure-cloudstacks-concept-agent>) which runs internal setup tasks, the setup actions you defined in your instance template, and installs and upgrades DSS if required.




Some settings changes require that you deprovision an instance and provision it again, which is denoted as _reprovisioning_.

### Deprovisioning

Deprovisioning an instance consists of terminating the cloud virtual machine. The Persistent Disk is kept. A deprovisioned instance costs the Persistent Disk storage fee.

## Data management

When an instance is created, a data disk distinct from the OS disk is created, attached and mounted to store all the persistent data. The persistent data on an instance includes, but is not limited to:

  * The DSS data directory

  * The docker daemon data directory

  * The certificates generated if self-signed certificates or Let’s Encrypt certificates are in use.




## Settings

An instance has various settings that can be set at different point of its lifecycle.

### General settings

Not documented yet

### SSL settings

The SSL settings define how your DSS instance will be exposed over SSL. This varies depending on the value you choose for HTTPS strategy in your virtual network:

#### None (HTTP only)

SSL will be disabled and your DSS instance will be accessible by HTTP only. No SSL settings are required.

#### Self-signed certificates

A self-signed certificate will be generated when the DSS instance is installed. Self-signed means that no official certificate authority has signed this certificate. Your DSS instance will be accessible over HTTPS, but the certificate won’t be trusted by your users by default. Each user will need to manually trust the self-signed certificate. We only recommend this HTTPS strategy if all DSS users are familiar and confortable with trusting a self signed certificate.

To make this mode more convenient, in the SSL settings, you can define the hostnames that will be injected in the self-signed certificate as Subject Alternative Name. This is required if you define a hostname pointing to the DSS instance and you want your users to access DSS via this hostname instead. Each user will still need to trust this certificate manually, but once done, their browser will accept the connection to this DSS instance using the hostname defined as Subject Alternative Name.

#### Certificate/key for each instance

This strategy will allow you to manually define a certificate for each instance, in the SSL settings of the instance.

The advantage is that you can use a certificate signed by an official certificate authority and for a given hostname you own, so your users can access the DSS instance via this hostname and see the given certificate as trusted by their browser.

Generating or retrieving such certificate is not documented here, as this process generally depends on your company policy. Please ask your IT departement on how to get a trusted certificate.

Once you have a certificate, the SSL settings offer three storage modes:

##### Enter key

The certificate will be stored in Fleet Manager, encrypted with a key from your Azure Key Vault and retrieved by the DSS instance at startup.

The format expected is PEM, for both the public and private key. If you don’t have the certificate in this format, please use OpenSSL accordingly.

The private key will be encrypted with your Azure Key Vault, so you will need to configure the Key Vault.

Create a key for encryption in your Key Vault:

  * Go to your Azure Key Vault portal

  * Go to the “Keys” section on the left navigation

  * Create a new RSA key and give it a name that we will refer to as `encryption-key-name`. The version of the key will also be needed later, which we will refer to as `encryption-key-version`

  * Click on “Access policies” to give the permissions to the FM and DSS managed identities so that they can access the key

  * Click on “Add access policy”

  * Give the “Cryptographic Operations” permissions to the FM and DSS managed identities, as well as the “Get” key management operations




Then in FM, setup the Key vault:

  * Go in “Cloud Setup > Edit”

  * Set the “Encryption KeyVault Id”, it’s the resource ID corresponding to your Azure Key vault. Example: `/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/YOUR_RESOURCE_GROUP/providers/Microsoft.KeyVault/vaults/KEY_VAULT_NAME`

  * Set the “Encryption Key Name” to `encryption-key-name`

  * Set the “Encryption Key Version” to `encryption-key-version`




Your fleet manager is now ready to handle manual certificates. In your instance settings, in the SSL section:

  * Set the public PEM and private PEM




##### Secret stored in Key Vault

Warning

This mode is now deprecrated by Azure. Azure advises to switch to Certificate stored in Key Vault instead.

The certificate public PEM will be stored in FM, whereas the private key will be stored as an Azure Key Vault secret.

Create a new Secret in Azure Key Vault with the private key as 1) PEM and 2) base64 encoded (important). Give to the DSS managed identity the READ permissions to the secret Key Vault.

In Fleet manager, SSL settings, configure the instance as follows:

  * **Key storage mode** : Secret stored in Azure Key Vault

  * **SSL certificate (PEM data)** : The public certificate as PEM

  * **Keyvault Url** : The vault URI, you can find it in your Key Vault dashboard. It usually looks like `https://YOUR_VAULT_NAME.vault.azure.net/`

  * **Secret Name** : Secret name you defined for the private key

  * **Secret version** : Secret version for the private key. If not defined, the latest version of the certificate will be taken.

  * **User Assigned Managed Service Identity Resource Id** : The resource ID of the DSS managed identity. Example: `/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/YOUR_RESOURCE_GROUP/providers/Microsoft.ManagedIdentity/userAssignedIdentities/YOUR_DSS_MANAGED_IDENTITY_NAME`

  * **User Assigned Managed Service Client Id** : The client ID of the DSS managed identity. This can be found in the dashboard of the managed identity.




Provision or reprovision your DSS instance. At startup, the certificate will be retrieved from the Azure Key Vault and you will notice that your DSS instance is now exposed using this certificate.

##### Certificated stored in Key Vault

The certificate will be stored entirely into the Azure certificate Key vault.

Import or create a new certificate in Azure Key Vault, see the Azure documentation for more details. Remember the “Content Type” you selected for this certificate, this will be necessary for the SSL settings in FM.

Give to the managed identity of DSS the READ permissions to the secret Key Vault.

In Fleet manager, in the SSL settings of the instance, configure as follows:

  * **Key storage mode** : Certificate stored in Azure Key Vault

  * **Keyvault Url** : The vault URI, you can find it in your key vault dashboard. It usually looks like `https://YOUR_VAULT_NAME.vault.azure.net/`

  * **Certificate name** : The certificate name in the Azure certificate Key Vault

  * **Certificate version** : The certificate version in the Azure certificate Key Vault. If not defined, the latest version of the certificate will be taken.

  * **Certificate Content Type** : The content type you selected when storing the certificate in Azure Key vault

  * **User Assigned Managed Service Identity Resource Id** : The resource ID of the DSS managed identity. Example: `/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/YOUR_RESOURCE_GROUP/providers/Microsoft.ManagedIdentity/userAssignedIdentities/YOUR_DSS_MANAGED_IDENTITY_NAME`

  * **User Assigned Managed Service Client Id** : The client ID of the DSS managed identity. This can be found in the dashboard of the managed identity.




Provision or reprovision your DSS instance. At startup, the certificate will be retrieved from the Azure Key Vault and you will notice that your DSS instance is now exposed using this certificate.

#### Generate certificates using Let’s Encrypt

Let’s Encrypt is a certificate authority, trusted by default by most browsers, which offers a certificate service for free, given you own a domain. This means that Let’s Encrypt can generate a certificate for your DSS instance, if you point your domain hostname to the DSS IP.

Note

Prerequisites

You need to own a domain, like `mydss.example.com` and point the DNS A record to a public static IP. This IP will then be assigned to the DSS instance.

In Fleet manager, on the virtual network, settings tab:

  * setup the SSL > Strategy to Generate certificates using Let’s Encrypt

  * setup the Contact Mail to an email address of your choice




In Fleet manager, on the instance page, settings tab, configure the instance as follows:

  * in the SSL part, click on \+ ADD DOMAIN

  * Add the hostname of your domain. Example: `mydss.example.com`

  * Assign the public IP to this instance.




Provision the DSS instance. When completed, you should be able to access your DSS instance with `https://mydss.example.com` and see a valid HTTPs certificate signed by Let’s Encrypt.

## Operations

Not documented yet

---

## [installation/cloudstacks-azure/load-balancers]

# Load balancers

Fleet Manager manages load balancers.

They act as application gateways in front of Dataiku nodes. They can also be used to perform load balancing in front of automation nodes to achieve high availability.

## Dashboard

The main screen through which you will get information about the load balancer is the dashboard. It is refreshed automatically and displays the different node mappings, the components created in the cloud and status information.

## Lifecycle

### Provisioning

The provisioning is a sequence of operations required to have the load balancer created in the cloud.

### Updating

When modifying the load balancer configuration in Fleet Manager, the load balancer must be updated for the changes to be propagated to the cloud. A reconciliation mechanism automatically detects these modifications and updates the relevant cloud structures to align with the defined configuration.

### Deprovisioning

Deprovisioning a load balancer consists of deleting the different cloud objects that were created as well as the load balancer.

## Settings

A load balancer has various settings.

Note

You can create a load balancer at fleet creation time using the **Fleet blueprints**.

In this case, a best practice setup will be implemented:

  * No public IP for the DSS nodes

  * The load balancer exposes the DSS nodes

  * The load balancer forwards traffic to the DSS nodes with HTTP




### Virtual network

Select the virtual network in which the load balancer will be created. This virtual network needs to have two subnets defined in Fleet Manager. Note that the secondary subnet can be added at any time but won’t be editable afterwards.

#### Virtual network HTTPS strategy

The virtual network **HTTPS strategy** only applies to the nodes. The load balancer can still be exposed using HTTPs.

Note

If your virtual network HTTPS strategy is **Self-signed certificates** , you need to add manually the self-signed certificate to the load balancer.

### Node mappings

Node mappings define the hostnames that point to each DSS node.

Each node must have a unique hostname, except for automation nodes which can share the same hostname for load balancing purposes.

Note

If the virtual network DNS strategy is **Assign a Azure DNS domain name you manage** , the hostnames correspond to sub domains within this zone. Fleet Manager will manage both the sub domains and the load balancer.

Otherwise, the hostnames must be fully qualified domain names.

### Load balancer tier

Defines the [Azure application gateway](<https://learn.microsoft.com/en-gb/azure/application-gateway/overview-v2>) tier.

Multiple options are available:

  * **Standard v2**

  * **WAF v2**




### Public IP mode

Assigns a public IP to the load balancer.

Multiple options are available:

  * **Static public IP** : A public IP is already created and managed outside of Fleet Manager

  * **Dynamic public IP** : Fleet Manager manages the load balancer public IP




### Certificate mode

Assigns a certificate to the load balancer to secure the load balancer hostnames.

Multiple modes are available:

  * **No certificate**

  * **Certificate secret ID** : Certificate has been created in Azure portal and its ID is used to assign it to the load balancer

---

## [installation/cloudstacks-azure/multi-region-account]

# Multi-region and multi-account support

Fleet Manager can manage cloud objects across different regions and impersonate different identities.

By default, it operates within the same region where it is deployed and uses its own identity.

If you are reusing an existing Fleet Manager role, ensure that its permissions match those documented in the [Fleet Manager installation procedure](<guided-setup-new-vnet-elastic-compute.html>).

## Multi-account support

In order to manipulate cloud objects with a different identity, an account needs to be created in Fleet Manager.

This account needs the same permissions as the [initial Fleet Manager account](<guided-setup-new-vnet-elastic-compute.html>).

The following information need to be specified:

  * **Environment**

  * **Subscription**

  * **Tenant ID**




Multiple authentication modes are available:

  * **Managed identity** : The resource ID of the managed identity has to be provided

  * **Application with secret credentials** : The application (client) ID has to be provided

  * **Application with certificate credentials** : The application (client) ID has to be provided




## Multi-region support

In the region where you want to manage the cloud objects:

  * Create a new resource group

  * Create a new network security group and add an inbound rule _IngressAllowForFM_ with the following configuration:

>     * Source: `IP Adresses`
> 
>     * CIDR range: `0.0.0.0/0`
> 
>     * Destination: `Service Tag`
> 
>     * Destination service tag: `VirtualNetwork`
> 
>     * Service: `Custom`
> 
>     * Destination port ranges: `22,80,443`
> 
>     * Protocol: `TCP`

  * Create a new virtual Network with an IP range that does not conflict with the one in Fleet Manager virtual Network

  * Add a role Assignment to your virtual network for Fleet Manager managed identity as a _Network contributor_

  * Create a subnet in this virtual Network using the previously created network security group

  * Add a role Assignment to your resource group for Fleet Manager managed identity as a _Contributor_




When creating the corresponding virtual network in Fleet Manager, specify the desired region. Any objects deployed in this virtual network will be located in that region.

In this case, both the virtual network where Fleet Manager is deployed and the virtual network where the objects will be deployed must be paired. Fleet Manager can handle this pairing process.

## Combining Multi-region and Multi-account

You can use both multi-region and multi-account capabilities simultaneously.

To do so, select an account different from the default Fleet Manager account when creating a virtual network in Fleet Manager.

---

## [installation/cloudstacks-azure/sso]

# Single Sign-On

Single sign-on (SSO) refers to the ability for users to log in just one time with one set of credentials to get access to all corporate apps, websites, and data for which they have permission.

By setting up SSO in FM, your users will be able to access FM using their corporate credentials.

SSO solves key problems for the business by providing:

>   * Greater security and compliance.
> 
>   * Improved usability and user satisfaction.
> 
> 


Delegating the FM authentication to your corporate identity provider using SSO allows you to enable a stronger authentication journey to FM, with multi-factor authentication (MFA) for example.

FM supports the following SSO protocols:

>   * OpenID connect
> 
>   * SAML
> 
> 


## Users database

Since FM users all have the same privileges, we recommend that you simply map all your login users to the admin user.

If you choose not to map to the same user, you must create FM user accounts for each SSO user. When creating these users, select “Local (no auth, for SSO only)” as the source type. Since users won’t enter passwords in SSO mode, only a login and display name are required.

## OpenID Connect

### About OIDC

#### Glossary

  * **OIDC** : **O** pen**ID** **C** onnect

  * **IDP** : An **Id** entity **P** rovider is a system entity that creates, maintains, and manages identity information for principals and also provides authentication services to relying applications within a federation or distributed network

  * **End-user** : The end user is the entity for whom we are requesting identity information. In our case, it is the FM user that need to login to access FM.

  * **OIDC Client** : Also called Relying party **RP** in the OIDC specification, the OIDC client is the application that relies on the IDP to authenticate the end user. In our case, it is FM.

  * **ID Token** : Similar to a ID card or passport, it contains many required attributes or claims about the user. This token is then used by FM to map the claims to a corresponding FM user. Digitally signed, the ID token can be verified by the intended recipients (FM).

  * **Claim** : In FM context, claims are name/value pairs that contain information about a user.

  * **Scope** : In the context of OIDC, scope references a set of claims the OIDC client needs. Example: email

  * **Authorization code** : During the OIDC protocol, the authorization code is generated by the IDP and sent to the end-user, which passes it to the OIDC client. It is then used by the OIDC client, who sends the authorization code to the IDP, and receives in exchange an ID token. Using an intermediate authorization code allows the IDP to mandate the OIDC client to authenticate itself in order to retrieve the ID token.

  * **Confidential client** : An OIDC client with the capacity to exchange the authorization code for an ID token in a secured back channel. This is the case of FM.

  * **Public client** : An OIDC client not able to store secret securely and needs to exchange the authorization code for an ID token in a public channel. FM is not a public client.

  * **PKCE** : **P** roof **K** ey for **C** ode **E** xchange is an extension of the OIDC protocol, to allow public clients to exchange the authorization code in a public channel.




#### Compatibility

FM OIDC integration has been successfully tested against the following OIDC identity providers:

  * OKTA

  * Azure Active Directory

  * Google G.Suite

  * Keycloak




#### OIDC features supported by FM

  * authorization code grant flow

  * simple string claims in the ID token

  * non encrypted or signed authentication requests

  * ID token signed with RSA or EC

  * FM behind a proxy

  * response mode supported: query or fragment

  * token endpoint auth method supported: client secret basic or client secret POST

  * confidential OIDC client only (PKCE not supported)




#### How OIDC looks like with FM

Once configured for OIDC SSO, FM acts as an OIDC client, which delegates user authentication to an identity provider.

  1. When the end user tries to access FM and is not authenticated yet, FM will redirect him to the IDP. The URL used will be the authorization endpoint of the IDP, which some specific GET parameters specific to the FM setup.

  2. The IDP will validate the GET parameters and will present a login page to the user. The authentication journey now depends on your IDP capabilities. Sometimes, when already logged-in on the IDP side, the login page is skipped and the user may not see the redirection to the IDP.

  3. The IDP has authenticated the end user and will redirect the user to FM with an authorization code. Depending of your OIDC client setup in your IDP, the code may be passed through via the query parameters or the fragment.

  4. The front-end of FM will parse and send the parameters, including the authorization code, to the FM backend.

  5. The FM backend will exchange this authorization code for an access token, by calling the token endpoint with the credentials you previously have configured in FM SSO settings. If successful, the IDP will return an ID token corresponding the end user.

  6. FM uses the ID token to map the end user to a FM user. The mapping setup is part of the SSO configuration of OIDC.

  7. FM creates a user session corresponding to the FM user. At this point, OIDC is completed and the user session is agnostic of the authentication protocol used.




### Setup OIDC in FM

To set up OIDC integration, you need:

  * to register a new OIDC Client (sometimes called an ‘application’) for FM in your identity provider,

  * to configure FM with the parameters of the identity provider as well as the parameters corresponding to the OIDC client created earlier,

  * to configure which of the user attributes returned by the IDP is to be used as the FM username, and optionally configure rewrite rules to extract the FM username from the chosen user attribute.




These steps are individually detailed below.

#### Registering a service provider entry for FM on the identity provider.

The exact steps for this depend on the identity provider platform which you plan to connect to, and should be performed by your IDP administrator. This entry may also be called an “OIDC application”. You will sometimes be asked to select the type of application, which would be in our case a web application.

You will typically need:

  * to setup the OIDC client to use the authorization code grant flow,

  * a client ID,

  * a client secret,




Note

The OIDC client needed by FM is a confidential client (opposite of public client). Meaning FM is able to protect the client secret, by exchanging the authorization code (and using the secret in the request) from the backend.

  * setup the redirect URI BASE_URL/login/openid-redirect-uri/,




Note

This URL must be configured as BASE_URL/login/openid-redirect-uri/, where BASE_URL is the URL through which FM users access this FM instance.

For example, if FM is accessed at https://dataiku.mycompany.corp/, the OIDC redirect uri must be defined as https://dataiku.mycompany.corp/login/openid-redirect-uri/.

Note that some identity providers require the redirect URI to use the HTTPS scheme.

  * associate some OIDC scopes to the OIDC client. Some IDPs refer to these as permissions, like user.read. You will need to setup the scope openid as well as some identity claims. You must ensure that FM is able to access and retrieve all the user attributes needed to identify the corresponding user in FM.




Note

FM will need to map to an existing user from one of the user claims. It’s important that you allow FM to retrieve a claim that is easily mappable to the username. A good candidate is email, of which you can strip the part after ‘@’ to compose a unique identifier for usernames.

#### Configuring FM for OIDC authentication.

OIDC configuration is in the “Settings / Security & Audit / User login & provisioning / SSO” screen.

Select “Enable”, choose protocol “OIDC”.

##### IDP configuration

Contact your IDP administrator to retrieve this information or check your IDP documentation.

The easiest way to setup the IDP configuration is using the well-known endpoint: The OIDC standard defines an endpoint, called well-known, to discover the IDP configuration. FM lets you enter the well-known endpoint of your IDP and fetch the rest of the configuration for you. If you don’t know the well-known endpoint, you can still enter the other configurations manually, the well-known input being optional.

  * **Well-known URL** : Optional, defines the well-known endpoint, which is a URI ending with /.well-known/openid-configuration. Click Fetch IDP configuration to auto-complete the rest of the IDP configuration.

  * **Issuer** : The issuer is a URI to identify the IDP. It is used in particular to verify that the ID token was signed by the right IDP. Per specification, the issuer is a URI, for which you can append the path /.well-known/openid-configuration to get the IDP well-known endpoint.




Note

Tips: If you have an example of a valid ID token, you can read its content with [jwt.io](<https://jwt.io>) and find the issuer value behind the iss claim. You can then build up the well-known URI by appending /.well-known/openid-configuration to it.

  * **Authorization endpoint** : The authorization endpoint is used to redirect the user to the IDP for the authentication.

  * **Token endpoint** : The token endpoint is used by FM to exchange the authorization code with an ID token. This endpoint will be called from the backend of FM. If FM is behind a proxy, please make sure FM is able to call this endpoint.

  * **JWKs URI** : The JWKs URI is a way for the IDP to specify all its public keys. This is used by FM to verify the signature of the ID token.




Examples of well-known endpoints:

  * **Google** : <https://accounts.google.com/.well-known/openid-configuration>

  * **Azure** : <https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration>

  * **Okta** : <https://common.okta.com/.well-known/openid-configuration>

  * **Keycloak** : <https://your-keycloak-instance/auth/realms/your-realm/.well-known/openid-configuration>




Note

In some case, the well-known can be the same for everyone, like for google. In other scenario, the IDP will generate a dedicated one for your application, like Okta or Azure for which it is configured by tenant.

##### OIDC Client configuration

In the previous section, you created an OIDC client. Use this client to complete the following section:

  * **Token endpoint auth method** : This is the authentication method that FM will use to specify the credentials during the token exchange. Most of the time, when supporting client secret, the IDP will allow either of the two methods. Leave this field by default if you are unsure, as it will most likely work.

  * **Client ID** : the client ID generated by the IDP. In the IDP portal, it could be named application id. Refer to your IDP documentation for more details on how to retrieve your client ID.

  * **Client secret** : The client secret your IDP generated for this client. Sometimes, it is not generated by default by your IDP (like Azure). In this case, look for a section ‘secrets’ in your IDP setup for the OIDC client.

  * **Scope** : Specify the scope that FM needs to use during the login flow. As a minima, it should contain openid. The scope contains a list of scopes separated by spaces.




Note

The scope is essential for doing the mapping with the username, as it defines the user claims the IDP needs to send back to FM. We recommend to add either email or/and profile, two common scopes supported by most IDPs. Most IDPs will mandate that you add some dedicated permissions before associating those scopes to your OIDC client. See your IDP documentation for more details.

Note

The list of scopes supported by your IDP is listed in the well-known, under the attribute claims_supported. Even if they are supported, you will still need to authorise the OIDC client to use those scopes, via your IDP portal.

##### Examples of scopes by IDPs

For Google, Azure, Okta and Keycloak, the simplest scope is email, which will return two claims - email and email_verified. Set in Identifier claim key the claim email.

Azure, Okta and Keycloak also support another claim called preferred_username, which is returned as part of the profile scope.

Resources:

  * [Google documentation](<https://developers.google.com/identity/protocols/oauth2/openid-connect#an-id-tokens-payload>)

  * [Azure documentation](<https://docs.microsoft.com/en-us/azure/active-directory/develop/id-tokens>)

  * [Okta documentation](<https://developer.okta.com/docs/reference/api/oidc/#scope-values>)

  * [Keycloak documentation](<https://www.keycloak.org/docs/latest/securing_apps/>) (search for principal-attribute in the page)




#### Mapping to the FM user

When FM successfully retrieves the ID token from the IDP, it needs to map it to a user in FM. The ID token will contain user claims that depend on the scope you defined earlier. The following two fields will help FM map the ID token to a FM user:

  * **Identifier claim key** : Depending on the scope you configured, the IDP will return different user claims. Define here the one you want to use to map to the corresponding username in FM. One easy way that works for most IDP, is to use the email and then strip the part after the ‘@’.

  * **Login remapping rules** : Map a claim received from the IDP to your username format. Example: stripping the part after ‘@’ in an email. You may not need this field if your IDP is returning a user claim that matches exactly the username (it’s the case of keycloak if you use the preferred_username claim for example).




Warning

The Login remapping rules are evaluated in order. If you have multiple rules and their regexes overlap (ie ^(.*)@mycompany.corp$ and ^(.*)$), make sure the most specific one is defined first.

Note

Example of mapping if you choose the email as identifier claim: ^(.*)@mycompany.corp$ -> $1

Note

FM logs all the claims received from the IDP in the backend log file, which may help configuring the Identifier claim key and the mapping for it.

#### User Supplier

DSS SSO implementation is able to supply users from an SSO context. Meaning you can configure DSS to auto-provision or synchronize users when a user authenticates via SSO.

Once you have enabled the Login-time provisioning and/or Login-time resync options, you must configure the mapping between the ID token (the identity provider’s response to DSS) and the representation of an identity in DSS. See your OpenID identity provider’s documentation or contact your identity provider’s administrator for the required information.

#### Testing OIDC SSO

  * Configure OIDC integration as described above

  * Access the FM URL from another browser or an anonymous window

  * You should be redirected to the IDP for authentication, then back to the FM redirect URL, then to the FM homepage

  * If login fails, check the logs for more information




Important

Once SSO has been enabled, if you access the root FM URL, SSO login will be attempted. If SSO login fails, you will only see an error.

You can still use the regular login/password login by going to the `/login/` URL on FM. This allows you to still log in using a local account if SSO login is dysfunctional.

## SAML

### About SAML

#### Compatibility

FM has been successfully tested against the following SAML identity providers:

  * OKTA

  * PingFederate PingIdentity (see note below)

  * Azure Active Directory

  * Google G.Suite

  * Microsoft Active Directory Federation Service (tested against Windows 2012 R2)

  * Auth0

  * Keycloak




Note

For AD FS, it is mandatory to configure at least one claim mapping rule which maps to “Name ID”, even if another attribute is used as the FM login attribute.

FM does not support SAML encryption.

### Setup SAML in FM

To set up SAML integration, you need:

  * to register a new service provider entry on your SAML identity provider, for this FM instance. This entry is identified by a unique “entity ID”, and is bound to the SAML login URL for this FM instance.

  * to configure FM with the IdP parameters, so that FM can redirect non logged-in users to the IdP for authentication, and can authentify the IdP response

  * optionally, to configure which of the user attributes returned by the IdP is to be used as the FM username, or configure rewrite rules to extract the FM username from the chosen IdP attribute




These steps are individually detailed below.

#### Registering a service provider entry for FM on the identity provider.

The exact steps for this depend on the identity provider platform which you plan to connect to, and should be performed by your IdP administrator. This entry may also be called a “SAML application”.

You will typically need:

  * an “Entity ID” which uniquely represents this FM instance on the IdP (sometimes also called “Application ID URI”).

This entity ID is allocated by the IdP, or chosen by the IdP admin.

  * the SAML login URL for FM (“Assertion Consumer Service Endpoint”, which may also be called “Redirect URI”, “Callback URL”, or “ACS URL”).

This URL _must_ be configured as
        
        BASE_URL/api/saml-callback

where `BASE_URL` is the URL through which FM users access this FM instance.

For example, if FM is accessed at <https://fm.mycompany.corp>, the SAML callback URL must be defined as



    
    
    <https://fm.mycompany.corp/api/saml-callback>

Note that some SAML identity providers require the callback URL to use the HTTPS scheme.

As an additional step, you may also have to authorize your users to access this new SAML application at the IdP level.

Finally, you will need to retrieve the “IdP Metadata” XML document from the identity provider, which is required to configure FM (also called “Federation metadata document”).

#### Configuring FM for SAML authentication.

SAML configuration is in the “Settings / Security & Audit / User login & provisioning / SSO” screen.

Select “Enable”, choose protocol “SAML” and fill up the associated configuration fields:

  * IdP Metadata XML : the XML document describing the IdP connection parameters, which you should have retrieved from the IdP.

It should contain a <EntityDescriptor> record itself containing a <IDPSSODescriptor> record.

  * SP entity ID : the entity ID (or application ID) which you have configured on the IdP in the step above

  * SP ACS URL : the redirect URL (or callback URL) which you have configured on the IdP in the step above




Warning

You need to restart FM after any modification to the SAML configuration parameters.

##### Optional: configuring signed requests

If your IdP requires it (this is generally not the case) you can configure FM to digitally sign SAML requests so that the IdP can authentify them.

For this, you need to provide a file containing a RSA or DSA keypair (private key plus associated certificate), which FM will use for signing, and provide the associated certificate to the IdP so that it can verify the signatures.

This file must be in the standard PKCS#12 format, and installed on the FM host. It can be generated using standard tools, as follows:
    
    
    # Generate a PKCS12 file containing a self-signed RSA key and certificate with the "keytool" java command:
    keytool -keystore <FILENAME>.p12 -storetype pkcs12 -storepass <PASSWORD> -genkeypair -keyalg RSA -dname "CN=DSS" -validity 3650
    
    # Generate a PKCS12 file containing a self-signed RSA key and certificate with the openssl suite:
    openssl req -x509 -newkey rsa:2048 -nodes -keyout <FILENAME>.key -subj "/CN=DSS" -days 3650 -out <FILENAME>.crt
    openssl pkcs12 -export -out <FILENAME>.p12 -in <FILENAME>.crt -inkey <FILENAME>.key -passout pass:<PASSWORD>
    

You then need to complete the FM configuration as follows:

  * check the “Sign requests” box

  * Keystore file : absolute path to the PKCS#12 file generated above

  * Keystore password : PKCS#12 file password

  * Key alias in keystore : optional name of the key to use, in case the PKCS#12 file contains multiple entries




#### Choosing the login attribute

Upon successful authentication at the IdP level, the IdP sends to FM an assertion, which contains all attributes of the logged in user. Each attribute is named. You need to indicate which of the attributes contains the user’s login, that FM will use.

Note that FM logs all attributes received from the SAML server in the backend log file, which may help configuring this field.

If this field is left empty, FM will use the default SAML “name ID” attribute.

#### Login remapping rules

Optionally, you can define one or several rewriting rules to transform the selected SAML attribute into the intended FM username. These rules are standard search-and-replace Java regular expressions, where `(...)` can be used to capture a substring in the input, and `$1`, `$2`… mark the place where to insert these captured substrings in the output. Rules are evaluated in order, until a match is found. Only the first matching rule is taken into account.

A standard use case for such rewriting rules would be to strip the domain part from email-address-like attributes. For example, configuring the following rule:
    
    
    ([^@]*)@mydomain.com     ->     $1
    

would rewrite a SAML attribute `first.last@mydomain.com` into `first.last`, and do nothing on SAML attribute `first.last@otherdomain.com` (as the left-hand part of the rule would not match).

Warning

The Login remapping rules are evaluated in order. If you have multiple rules and their regexes overlap (ie ^(.*)@mycompany.corp$ and ^(.*)$), make sure the most specific one is defined first.

#### User Supplier

DSS SSO implementation is able to supply users from an SSO context. Meaning you can configure DSS to auto-provision or synchronize users when a user authenticates via SSO.

Once you have enabled the Login-time provisioning and/or Login-time resync option, in the SAML context you need to configure the mapping between the SAML assertion (the identity provider’s response to DSS) and the DSS representation of an identity. (See the documentation of your identity provider or contact your identity provider’s administrator for the required information).

#### Testing SAML SSO

  * Configure SAML integration as described above

  * Restart FM

  * Access the FM URL from another browser or an anonymous window

  * You should be redirected to the IDP for authentication, then back to the FM redirect URL, then to the FM homepage

  * If login fails, check the logs for more information




Note

Once SSO has been enabled, if you access the root FM URL, SSO login will be attempted. If SSO login fails, you will only see an error.

You can still use the regular login/password login by going to the `/login/` URL on FM. This allows you to still log in using a local account if SSO login is dysfunctional.

If the SAML configuration is invalid (in particular if the IdP metadata XML is malformed) FM will not restart. You will need to manually disable SAML in the general-settings.json configuration file as described below.

---

## [installation/cloudstacks-azure/tagging]

# Tagging on Dataiku Cloud Stacks

Dataiku Cloud Stacks (DCS) allows to tag (or label) cloud resources in order to leverage cloud provider specific features such as managing, identifying, organizing, searching for, and filtering resources. Cloud tags are supported on the following DCS entities:

  * Tenants

  * Cloud Accounts

  * Virtual Networks

  * Load Balancers

  * Instances




Cloud tags are key-value pairs that are applied as metadata on the cloud resources created by DCS during provisioning of entities like instances or load balancers. Some entities like cloud accounts are not provisioned and do not create cloud resources themselves, but tags are inherited according to the following hierarchy:

**Tenants ⇒ Cloud Accounts ⇒ Virtual Networks ⇒ Load Balancers ⇒ Instances**

This means that any cloud tags in a Tenant will be inherited by the Cloud Accounts in that Tenant, that any cloud tags in a Cloud Account will be inherited by the Virtual Networks attached to that Cloud Account, etc.

You will be able to find a list of inherited tags in the Virtual Networks, Load Balancers and Instances dashboard pages:

Cloud tags are also now displayed on the listing pages of Instances, Load Balancers, Cloud Accounts and Virtual Networks. They can also be used for filtering the list.

## Limitations

Tagging in Dataiku Cloud Stacks has some limitations related to the cloud provider that the platform is deployed on. Please refer to each Cloud specific requirements section for more information.

Tags are not updated on cloud resources while saving of the form of the entity being modified. The entity must be reprovisioned for the new tags to be applied when supported.

Virtual Networks are not reprovisionable, thus the resources created (e.g. security groups) will not be updated with new tags upon modification. However, due to the inheritance, new or reprovisioned instances and load balancers created within the Virtual Network will contain the updated tags.

Warning

The data disk of an instance is kept throughout its lifecycle, thus reprovisioning will overwrite already existing tags and add new ones, but it will not delete ones that were removed. Be mindful that tags may accumulate on the data disk of an instance if changed often and this might cause issues related to Cloud provider limitations.

## Azure specific requirements

You can find any Azure specific tagging requirements in the [Azure documentation](<https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources#limitations>)

---

## [installation/cloudstacks-azure/templates-actions]

# Instance templates and setup actions

Instance template represent common configuration for instances, reusable across several instances. It is required to use an instance template to launch an instance. Instances stay linked to their instance template for their whole lifecycle.

What is configured through the instance templates includes, but is not limited to:

  * Identities able to SSH to the instance

  * Cloud credentials for the managed DSS

  * Installation of additional dependencies and resources

  * Pre-baked and custom configurations for DSS




To create, edit and delete templates, head to the _Instance templates_ in the left menu of FM. The following document explains each section of the configuration.

## SSH Key

Use this field to enter a public SSH key that will be deployed on the instance. This is useful for admins to connect to the machine with SSH. This field is optional.

This key will be available on the `centos` account, i.e. you will be able to login as `centos@DSS.HOST.IP`

## User-assigned managed identities

In most cases, your DSS instances will require Azure credentials in order to operate. These credentials will be used notably to integrate with ACR and AKS

The recommended way to offer Azure credentials to DSS instance is the use of an User-Assigned Managed Identity.

Keep “restrict access to metadata server” enabled so that DSS end-users cannot access these credentials.

### Atypical options

There may be some cases where you want setup to have additional permissions at startup time (see setup actions).

If that’s needed, you can add a “Startup managed identity” that will only be available during startup and that will be replaced by the “Runtime managed identity” once startup is complete.

## Setup actions

Setup actions are configuration steps ran by the [agent](<concepts.html#azure-cloudstacks-concept-agent>). As a user, you create a list a setup actions you wish to see executed on the machine.

### Add authorized SSH key

This setup action ensures the SSH public key passed as a parameter is present in ~/.ssh/authorized_keys file of the default admin account. The default admin is the centos user with currently provided images.

### Install system packages

This setup action is a convenient way to install additional system packages on the machine should you need them. It takes a list of Almalinux packages as only parameter. The package name or the package URL can be used.

### Set advanced security

This setup actions ensures DSS add security related HTTP headers. HSTS headers can be toggled separately.

### Install a JDBC driver

Instances come pre-configured with drivers for PostgresSQL, MariaDB, Snowflake, AWS Athena and Google BigQuery. If you need another driver, this setup action eases the process. It can download a file by HTTP, HTTPS, from S3 bucket or from an ABS container.

Install JDBC Driver parameters Parameter | Expected value  
---|---  
Database type |  The type of database you will use. This parameter has no actual effect, it is used for readability.  
URL |  This field expects the full address to the driver file or archive.   
Download from HTTP(S) endpoint:
    
    
    http(s)://hostname/path/to/file.(jar|tar.gz|zip)
    

Redirections are solved before download.   
Download from a S3 bucket:
    
    
    s3://BUCKET_NAME/OBJECT_NAME
    

Download from Azure Blob Storage:
    
    
    abs://STORAGE_ACCOUNT_NAME/CONTAINER_NAME/OBJECT_NAME
    

Use a driver available on the machine:
    
    
    file://path/to/file.(jar|tar.gz|zip)
      
  
Paths in archive |  This field must be used when the driver is shipped as a tarball or a ZIP file. Add here all the paths to find the JAR files in the driver archive. Paths are relative to the top of the archive. Wildcards are supported. Examples of paths:
    
    
    *.jar
    
    
    
    subdirA/*.jar
    subdirB/*.jar
      
  
HTTP Headers | List of HTTP headers to add to the query. One header per line.
    
    
    Header1: Value1
    Header2: Value2
    

Parameter ignored for all other kinds of download.  
HTTP Username |  **HTTP**   
If the endpoint expect Basic Authentication, use this parameter to specify the user name.   
**Azure**   
If the instance have several Managed Identities, set the _client_id_ of the targeted one in this parameter.   
To connect to Azure Blob Storage with a SAS Token (not recommended), set the value of this parameter to _token_.  
HTTP Password |  **HTTP**   
If the endpoint expect Basic Authentication, use this parameter to specify the password.   
**Azure**   
To connect to Azure Blob Storage with a SAS Token (not recommended), store the token value in this parameter.  
Datadir subdirectory | For very specific use-cases only, we recommend to let it empty.  
  
### Run Ansible tasks

This setup action allows you to run arbitrary ansible tasks at different point of the startup process.

The **Stage** parameter specificies at which point of the startup sequence it must be executed. There is three stages:

  * **Before DSS install** : These tasks will be run before the agent installs (if not already installed) or upgrades (if required) DSS.

  * **After DSS install** : These tasks will be run once DSS is installed or upgraded, but not yet started.

  * **After DSS is started** : These tasks will be run once DSS is ready to receive public API calls from the agent.




The **Ansible tasks** allows you to Write a YAML list of ansible tasks as if they were written in a role. Available tasks are base Ansible tasks and [Ansible modules for Dataiku DSS](<https://github.com/dataiku/dataiku-ansible-modules>). When using Dataiku modules, it is not required to use the connection and authentication options. It is automatically handled by FM.

Some additional facts are available:

  * dataiku.dss.port

  * dataiku.dss.datadir

  * dataiku.dss.version

  * dataiku.dss.node_id: Identifier matching the node id in Fleet Manager, unique per fleet

  * dataiku.dss.node_type: Node type is either design, automation, deployer or govern

  * dataiku.dss.logical_instance_id: Unique ID that identifies this instance in the Fleet Manager

  * dataiku.dss.instance_type: The cloud instance type (also referred to as instance size) used to run this instance

  * dataiku.dss.was_installed: Available only for stages **After DSS install** and **After DSS startup**

  * dataiku.dss.was_upgraded: Available only for stages **After DSS install** and **After DSS startup**

  * dataiku.dss.api_key: Available only for stage **After DSS startup**




Example:
    
    
    ---
    - dss_group:
        name: datascienceguys
    - dss_user:
        login: dsadmin
        password: verylongbutinsecurepassword
        groups: [datascienceguys]
    

Ansible is ran with the unix user held by the agent, and can run administrative tasks with become.

### Setup Kubernetes and Spark-on-Kubernetes

This task takes no parameter and pre-configures DSS so you can use Kubernetes clusters and Spark integration with them. It prepares the base images and enables DSS Spark integration.

### Add environment variables

This setup action enables to add environment variables that can be used in DSS. These variables are stored in bin/env-site.sh file.

### Add properties

Ansible is ran with the unix user held by the agent, and can run administrative tasks with become.

### Add SSH keys

This setup action enables to add SSH keys to ~/.ssh folder that can be used to connect to other machines from the DSS one.

To generate your public key on Dataiku Cloud:

  * go to your launchpad > extension tab > add an extension,

  * select the SSH integration feature,

  * enter the hostnames of the remote that this key is allowed to connect to,

  * click to validate and generate the key.




Dataiku Cloud will then automatically generate the key and run a command to the origin to get (and verify) the SSH host key of this server. You can now copy the generated key and add it to your hosts. To find this key in the future or generate a new one go to the extension tab and edit the SSH Integration feature.

### Setup proxy

This setup action enables to configure a proxy in front of DSS.

The default value for the NO_PROXY variable is: localhost,127.0.0.1,169.254.169.254.

169.254.169.254 is the IP used by Azure to host the metadata service.

### Add Certificate Authority to DSS truststore

This setup action is a convenient way to add a Certificate Authority to your DSS instances’ truststore. It will then be trusted for Java, R and Python processes. It takes a Certificate Authority in the public PEM format. A chain of trust can also be added by appending all the certificates in the same setup action.

Example (single CA):
    
    
    -----BEGIN CERTIFICATE-----
    (Your Root certificate authority)
    -----END CERTIFICATE-----
    

Example (Chain of Trust):
    
    
    -----BEGIN CERTIFICATE-----
    (Your Primary SSL certificate)
    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----
    (Your Intermediate certificate)
    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----
    (Your Root certificate authority)
    -----END CERTIFICATE-----
    

Warning

The name must be unique for each CA as it is used to write the CA in your instances.

### Install code env with Visual ML preset

This setup action installs a code environment with the Visual Machine Learning and Visual Time series forecasting preset.

Enable **Install GPU-based preset** to install the GPU-compatible packages. Otherwise, the CPU packages are installed.

Leaving **Allow in-place update** enabled means that if there is a newer version of the preset the next time the setup action runs, and it is compatible with the previously installed code environment, said code environment is updated in place. Otherwise, a new code environment is created with the updated preset.

---

## [installation/cloudstacks-azure/tenant-settings]

# Global settings

There are only a few global settings in Fleet Manager, accessible from the “Cloud Setup” screen.

## Azure authentication

Fleet Manager needs to perform various calls to the Azure API in order to manage resources.

When you deploy Cloud Stacks using the recommended guided setup, the Fleet Manager virtual machine has a User Assigned Managed Identity with Contributor access to the Resource Group, which it uses.

## License

In order to benefit from most capabilities, you’ll need a Dataiku License or Dataiku License Token. You need to enter it here.

## HTTP proxy

Fleet Manager can run behind a proxy. Once you define at least a proxy host and port, Fleet Manager will use it to access different resources through HTTP:

  * to fetch new DSS image lists

  * to update or verify licenses

  * to log users in with the OpenID Connect protocol




The calls to Azure services won’t be proxied. As such, please make sure the following Azure services you require are reachable from the Fleet Manager virtual machine: Azure Resource Manager, Virtual Network, Storage, Azure Key Vault. You can for example use Service Tags to open access to Azure services in your network security group.

---

## [installation/cloudstacks-azure/virtual-networks]

# Virtual networks

A virtual network in Fleet Manager is an object representing the networking setup of instances created into it.

The virtual network defines in which VNet and subnet the instances will be launched, as well as how DNS hostnames and HTTPS certificates for the instances will be used.

Each instance belongs to a virtual network. At least one virtual network is required to deploy instances.

## Networking requirements

The most important requirement is that the DSS instances must be able to reach FM on its main port. FM has a single URL that must be reachable by all DSS instances it creates, even if they span over several networks.

## Creation

Go to _Virtual networks_ and click on _New virtual network_ at the top right. You will be required to provide the mandatory values for virtual networks:

  * _Label_ : the name of the network that will be displayed in FM. It can be changed later.

  * _Virtual network id_ : complete id of the Vnet in which you want to deploy instances. It is pre-filled with the Vnet in which FM is currently running. It cannot be changed after creation.

  * _Subnet name_ : Name of the subnet in which you want to deploy instances. If is pre-filled with the subnet in which FM is currently running. It cannot be changed after creation.

  * _Security groups_ : By default, FM automatically creates security groups when creating the virtual network. You can also manually list security groups you want attached on the created instances.




Note

Auto-creation of security groups adds two groups:

  * A security group that opens SSH (22), HTTP (80) and HTTPS (443) on all traffic.

  * A “default”-like security group that allows all traffic between instances having it attached. It is used for elastic AI setups where clusters need to be able to contact back the instances.




## Edition

Once a virtual network has been created, you can edit its settings.

### Public IP address

By default, FM assigns public IPs to your instances. You can disable this. Note that this requires that the subnet on which the instances are started has a default route through an Internet Gateway

Changing the public IP policy requires reprovisioning the affected instances.

### DNS Strategy

By default, instances only get IP addresses. FM can assist in assigning hostnames. It is also required if you want to apply a verified HTTPS strategy.

Changing the DNS strategy requires reprovisioning the affected instances.

In the virtual networks list, click on the desired network to display its dashboard, then select the _Settings_ tabs to change the configuration. Select _Assign a Azure DNS domain name that you manage_ in the _DNS Strategy_ drop-down menu. Then fill in the _Azure Dns Zone Id_.

### HTTPS configuration

When using this strategy, instances are deployed with self-signed certificates. These will trigger security alerts in your browser.

FM supports several strategies for configuring HTTPS.

#### None

This is the default. This simple mode means no certificate is involved and instances are exposed on HTTP.

#### Self-signed certificate

When using this strategy, each instance will create its own self-signed certificate if none exists yet, and uses it to expose DSS on port 443. You can choose wether HTTP is closed or redirects to HTTPS.

Additional domain names can be handled by the self-signed certificate at instance level.

#### Custom certificate for each instance

Select _Enter a certificate/key for each instance_ to use the certificates emitted with by your PKI. When using this strategy, each instance will have to be configured with the certificate and private key intended for it. The secret key can be stored encrypted by FM or into your cloud provider secret manager.

You can choose wether HTTP is closed or redirects to HTTPS.

This mode requires instance level settings.

##### Let’s Encrypt

This mode makes use of [Let’s Encrypt](<https://letsencrypt.org/>) and [certbot](<https://certbot.eff.org/>) to generate and renew automatically a publicly recognized certificate. When using this mode, you must specify an email address representing the legal person owning the certificate.

Instances must be reachable on HTTP (80) and HTTPS (443) from the internet.

Additional domain names can be added at instance level.

Warning

Let’s Encrypt service has [rate limits](<https://letsencrypt.org/docs/rate-limits/>) that makes it unsuitable for numerous deletions and creations. Be careful to use it for stable deployments. If you hit your quota, there is no way to reset it.

---

## [installation/cloudstacks-gcp/concepts]

# Conceptual overview

## Fleet Manager (FM)

The Dataiku Cloud Stacks for GCP setup uses a central component, called Dataiku Fleet Manager (FM) in order to deploy, upgrade, backup, restore and configure one or several Dataiku instances.

Fleet Manager handles the entire lifecycle of the Dataiku instances, freeing you from most administration tasks. The instances managed by Fleet Manager come builtin with the ability to scale computation on elastic computation clusters, powered by Kubernetes.

To deploy Dataiku Cloud Stacks for GCP, Dataiku provides a Deployment Manager template that deploys Fleet Manager. From Fleet Manager, you then deploy the Dataiku instances.

## Instance

An instance is a single installation of a DSS design node, automation node or deployer node. It is the main object manipulated by FM. Each instance is backed by a virtual machine dedicated to it.

When you create an instance, you _provision_ it. Provisioning an instance means FM creates the required cloud resources to host the DSS node. See [instances lifecycle](<instances.html#gcp-cloudstacks-instance-lifecycle>) for more information.

## Instance template

An instance template is a set of configuration information that can be reused to start several instances with common properties. An instance is always launched from an instance template and stays linked to it throughout its lifetime.

Enabling Stories on the instance template will set up Stories on compatible nodes (design and automation).

Modifying an instance template impacts the provisioning behavior of all the instances launched from it. Reprovisioning is not enforced, but required for the new setup to be applied.

## Virtual network

A virtual network represents the network context in which the instances will be launched. That means a reference to the virtual network used in the cloud provider, but also other configurations such as how DNS and HTTPS are handled.

Instance templates are not tied to a specific virtual network.

## Agent

The FM agent is a Dataiku software that runs alongside DSS in your instances. It manages communication with the FM server, sends technical information to it, and performs administrative tasks on behalf of the FM server authority.

---

## [installation/cloudstacks-gcp/dss-backup]

# Backup and restore of DSS instances

## Manual snapshots

You can manually backup your instance at any time by clicking on **New snapshot** in the **Snapshots** tab of the instance. It is not required to stop or deprovision the instance to make a snapshot. It has no impact the the instance users.

## Automated snaphots

You can enable automated snapshots in the **Settings** tab of the instance. Once enabled, FM will create snapshots at the required frequency and delete old snapshots if required, by specifying a maximum number of snapshots.

---

## [installation/cloudstacks-gcp/dss-upgrade]

# Upgrades of DSS instances

Fleet Manager manages upgrades of DSS. Upgrades are always done under administrator control and are not performed automatically.

To upgrade an instance:

  * Go to the settings of the instance

  * In the “Version” field, select the new DSS version you want to upgrade to

  * Reprovision the instance




Upon reprovisioning, DSS will start a new virtual machine with the new DSS version and will reattach the data volume to the new DSS version, performing any upgrade on the fly as required.

## Updating the list of available versions

If your Fleet Manager instance has direct outgoing Internet access (without proxy), Fleet Manager will automatically fetch the list of newly available DSS versions, and these versions will appear directly in your Fleet Manager.

If this is not the case, please contact your Dataiku Technical Account Manager or Customer Success Manager.

---

## [installation/cloudstacks-gcp/fm-upgrade]

# Upgrading FM

## Description

This guided setup allows you to upgrade an existing Dataiku Cloud Stacks for Google Cloud. It assumes you had followed [the guided setup example](<guided-setup-new-vpc-elastic-compute.html>) to build your initial setup.

This guide is also valid when switching from Google Deployment Manager to Infrastructure Manager, as [Deployment Manager will be discontinued](<https://docs.cloud.google.com/deployment-manager/docs/deprecations>).

## Steps

Warning

For any upgrade to Fleet Manager version 12.6.0 or higher, it is required to previously stop the virtual machine hosting Fleet Manager, or the upgrade process could fail.

### Stop Fleet Manager server

  * In Infrastructure Manager (or Deployment Manager), find your deployment. We call it `<deployment>`

  * Find the Fleet Manager instance `instance-<deployment>` in [Compute Engine VM instances](<https://console.cloud.google.com/compute/instances>)

  * In section _Network interfaces_ , find the _Primary internal IP address_ and make a note of it. We call it `<fm-ip-address>`

  * Then, click on the vertical dots _More actions_ menu at the top right, then click on _Stop_

  * Wait for the instance the reach the state _Stopped_




### Backup Fleet Manager’s data disk

  * Go to [Compute Engine Disks](<https://console.cloud.google.com/compute/disks>)

  * Look for `data-<deployment>`

  * Click on _Manage resource_ at the top right

  * Click on _Create snapshot_

  * Give it an identifiable name, for instance `fm-backup-YYYYMMDD`, make a note of it, then click on _Create_

  * Wait for the snapshot to reach status _Ready for use_




### Delete the existing deployment

  * Go back to the deployment in the Infrastucture Manager

  * Click on _Delete_ , then _Confirm_




If you were previously using Deployment Manager, and the tool is no longer accessible, you may need to delete resources manually.

### Create the new stack

  * Follow [the guided setup example](<guided-setup-new-vpc-elastic-compute.html>) to deploy the new version of Fleet Manager, but add new elements to the `terraform.tfvars` file:

    * `private_ip_address = <fm-private-ip>`

    * `snapshot = "global/snapshots/<snapshot-name>"` or `snapshot = "projects/<project-name>/global/snapshots/<snapshot-name>"` if the snapshot is in a different project




## Troubleshooting

### DSS machines seem unresponsive

In case the DSS machines seem unresponsive in the FM UI following the upgrade, reprovision the different DSS machines for them to be able to communicate again with FM.

---

## [installation/cloudstacks-gcp/guided-setup-new-vpc-elastic-compute]

# Guided setup 1: Deploy in a new VPC with Elastic Compute

## Description

This guided setup allows you to install a full Dataiku Cloud Stacks for GCP, including the ability to run workloads on Elastic Compute clusters powered by Kubernetes (using GKE).

At the end of this walkthrough, you’ll have:

  * A fully-managed DSS design node, with either a public IP or a private one

  * The ability to one-click create elastic compute clusters

  * The elastic compute clusters running with public IPs (and no NAT gateway overhead)




## Prerequisites

You need to have, as an administrator, the permissions to create service accounts in the project and to grant IAM rights to these service accounts. Said service accounts need not have permission to grant IAM rights, they’re only needed for the initial setup and required by the software during usage.

You need to have installed the [Cloud SDK](<https://cloud.google.com/sdk/docs/install>) on a machine, and be able to run the gcloud command line assuming the same identity as in the console, and with the project set to the GCP project where the FM instance is to be deployed.

## Steps

### Create a service account for your Fleet Manager instance

  * In your Google cloud controls, go to your project, and to the “IAM & admin” section

  * In the “Service accounts” tab, click “Create service account”

  * Enter a name for your service account

  * Click on “Create and continue”

  * In the “Grant this service account access to the project (optional)” part of the Service account creation screen, select and add the following roles: “Service account user”, “Compute admin”, “DNS administrator”, “Cloud KMS Crypto operator”

  * Click on “Continue” then “Done”

  * In the list, take note of the “email” of the service account, this will be refered as `fm-email`

  * More permissions can be granted to the service account on the “IAM” tab, either by editing the service account line (with the pencil icon on the right) or by adding role assignments (with the “Add” button at the top)




### Create a service account for your DSS instance

  * In your Google cloud controls, go to your project, and to the “IAM & admin” section

  * In the “Service accounts” tab, click “Create service account”

  * Enter a name for your service account

  * Click on “Create and continue”

  * In the “Grant this service account access to the project (optional)” part of the Service account creation screen, select and add the following roles: “Service account user”, “Kubernetes engine admin”, “Secret Manager Secret Accessor”, “Compute viewer”, “Artifact Registry Create-on-Push Writer” or “Artifact Registry administrator” if you want DSS to create the Artifact Registry repository for you.

  * Click on “Continue” then “Done”

  * In the list, take note of the “email” of the service account, this will be refered as `dss-email`

  * More permissions can be granted to the service account on the “IAM” tab, either by editing the service account line (with the pencil icon on the right) or by adding role assignments (with the “Add” button at the top)




### Create a VPC to host the fleet manager

You’ll need 2 CIDR for the network:

  * one will be used for the network itself, and in fine for putting the VMs on the network. You can for example use “10.0.0.0/16”. This CIDR will be referred as `network-cidr`

  * one will be used to allow internal routing on the network, between the VMs but also between secondary IP ranges that might be created in the network. This CIDR thus needs to be larger than `network-cidr`, for example “10.0.0.0/8”. This CIDR will be referred as `internal-cidr`. Secondary ranges are used by GKE for pods and services (see [GKE doc](<https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips>))




Then you can create a VPC network:

  * In your Google cloud controls, go to your project, and to the “VPC network” section

  * In the “VPC networks” tab, click “Create VPC network”

  * Enter a name for the network; this will be referred as `fm-network`

  * In the “Subnets” section, make sure “Custom” is selected and create one subnet

  * Enter a name for the subnet; this will be referred as `fm-subnetwork`

  * Enter a region for the subnet. The FM instance will be deployed in a zone of that region. This region will be referred as `fm-region`

  * For IPv4 range, enter the value chosen for `network-cidr`

  * Set “Private Google Access” to off

  * Click “Create”

  * Once the network is created, go to the “Firewall” tab

  * Click “Create firewall rule”

  * Set the name to “`fm-network`-external”

  * Select :

>     * “Network” -> `fm-network`
> 
>     * “Direction” -> “Ingress”
> 
>     * “Action” -> “Allow”
> 
>     * “Targets” -> “All instances in the network”
> 
>     * “Source filter” -> “IPv4 ranges”
> 
>     * “Source IPv4 ranges” -> `0.0.0.0/0`
> 
>     * “Protocols and ports” -> “Specified protocols and ports”
>
>>       * check “Tcp” and set the port to 22, 80, 443

  * Click “Create”

  * Again, click “Create firewall rule”

  * Set the name to “`fm-network`-internal”

  * Select :

>     * “Network” -> `fm-network`
> 
>     * “Direction” -> “Ingress”
> 
>     * “Action” -> “Allow”
> 
>     * “Targets” -> “All instances in the network”
> 
>     * “Source filter” -> “IPv4 ranges”
> 
>     * “Source IPv4 ranges” -> the value chosen for `internal-cidr`
> 
>     * “Protocols and ports” -> “Allow all”

  * Click “Create”




### Deploy Fleet Manager

We use Infrastructure Manager to deploy Fleet Manager in GCP. It is Google’s replacement of Deployment Manager, based on Terraform.

Warning

Deployment Manager will be decommissioned by Google soon. Fleet Manager no longer support it. Reference: <https://cloud.google.com/deployment-manager/docs/deprecations>

  * Fetch the Terraform file by running on the command line:



    
    
    gsutil cp gs://dataiku-cloudstacks/templates/fleet-manager/14.5.1/fleet-manager-instance.tf .
    

  * Create a terraform.tfvars file with inputs for the Terraform variables. Here is an example:



    
    
    project_id = "<project-id>"
    region = "<region>"
    zone = "<zone>"
    deployment_name = "<deployment-name>"
    machine_type = "<machine-type>"
    network = "<network>"
    subnetwork = "<subnetwork>"
    username = "<fm-username>"
    password = "<fm-password>"
    service_account = "<fm-email>"
    allowed_cidr = "<allowed-cidr>"
    

where:
    

  * project-id is the ID of the project in Google cloud console

  * region is the GCP region where the resource should be deployed

  * zone is the GCP zone where the resource should be deployed (within the specified region)

  * deployment-name is a name for your deployment in the GCP Infrastructure Manager

  * machine-type is a GCE machine type like “n1-standard-4”

  * network is `fm-network`

  * subnetwork is `fm-subnetwork`

  * fm-username is a username for logging in to Fleet Manager

  * fm-password is a strong password for logging in to Fleet Manager

  * fm-email is the email of the service account for the FM instance that you created above

  * allowed-cidr is a CIDR of IP addresses that are allowed to connect to the FM instance



Additional options that can be used in the above parameters:
    

  * ssh_key is a RSA public key for SSH logging in to the underlying Fleet Manager virtual machine

  * network_project_id: project of the network (default is the current project). If different from the current project, allowed_cidr has no effect

  * dss_service_account: email of the service account DSS instances are to run as

  * snapshot: optional snapshot to create the instance with. Can be “projects/{project}/global/snapshots/{snapshot}” or “global/snapshots/{snapshot}”

  * image: optional image to create the instance with. Can be “projects/{project}/global/images/{image}” or “global/images/{image}”

  * public_ip_address: the public IP address to use for Fleet Manager

  * ssl_mode: the SSL mode for FM instance (`SELF_SIGNED` if using a self-signed certificate, `SECRET_MANAGER` if using a certificate from the Certificate Manager)

  * ssl_public_key: the certificate in base 64

  * ssl_gsm_secret_id: the private key secret name

  * kms_key_name: the name of your encryption key in a KMS

  * labels: optional list of labels in key=value format to add to the resources that support them created by the deployment



    
    
    labels = {
        key1 = "value1"
        key2 = "value2"
    }
    

  * Make sure you have a service account that has the permissions necessary to apply the deployment. It needs to have at least edit permissions on the project resources, as well as role roles/config.agent (needed for Infrastructure Manager).

  * Run the following command to apply an Infrastructure Manager deployment:



    
    
    gcloud infra-manager deployments apply <deployment-name> \
        --location <region> \
        --service-account projects/<project-id>/serviceAccounts/<service-account-email> \
        --local-source <terraform-folder>
    

where:
    

  * deployment-name is the name of the deployment object in Infrastructure Manager

  * region is the GCP region where the resource should be deployed

  * service-account-email is the email of the GCP service account that will run the operation

  * terraform-folder is the folder containing both the Terraform template and the .tfvars input file




  * Wait for your deployment to complete




In order to retrieve the address at which your Cloud Stacks Fleet Manager is deployed, run
    
    
    gcloud infra-manager deployments export-statefile <deployment-name> \
        --location <region> \
        --file=state
    

where:
    

  * deployment-name is the name of the deployment object in Infrastructure Manager

  * region is the GCP region where the resource should be deployed




The deployment state will be stored in file state.tfstate and the IP can be found in outputs.fm_server_ip field.

### Start your first DSS

  * Log into Fleet Manager with the login and the password you previously entered

  * In “Cloud Setup”, click on “Edit”, set “License mode” to “Manually entered”, click on “Enter license” and enter your Dataiku license. Click on “Done” then on “Save”

  * Refresh the page in your browser

  * In “Fleet Blueprints”, click on “Deploy Elastic Design”

  * Give a name to your new fleet, this will be refered as `fleet-name`

  * In “Instance service account”, enter the `dss-email`

  * Click on “Deploy”

  * Go to “Virtual Networks”, select the “Virtual network for fleet `fleet name`”

  * In the settings, in “Network tags”, put “tag-<deployment-name>”, where <deployment-name> is the name used for the deployment in the previous commands, and Save

  * Go to “Instances > All”, click on the design node

  * Click “Provision”

  * Wait for your DSS instance to be ready

  * Click on the **Retrieve** button under “Retrieve password” and write down the password

  * Click on “Go to DSS”

  * Login with “admin” as the login, and the password you just retrieved




You can now start using DSS

### (Optional) Start your first Elastic compute cluster

#### Deploy your Elastic Compute cluster

  * In DSS, go to Administration > Clusters

  * Click on “Create GKE cluster”, give it a name

  * In “Connection”, check it is set to “Manually defined”

  * In section “Networking”, check that “Inherit DSS host settings” is checked.

  * In section “Networking”, check that “Make cluster VPC-native” is checked, and fill “Pod IP range” and “Service IP range”. Both ranges should be within the internal-cidr used when deploying the FM template, and non-overlapping with network-cidr. If network-cidr is x.y.0.0/16 and internal-cidr is x.0.0.0/8 then you can leave GKE to create automatically the ranges.

  * In “Cluster Nodes”, Click on “+ Add a preset”

  * Update “Machine type” and “Disk size” as you see fit

  * Tick the “Enable nodes autoscaling” box

  * In “Advanced options”, set “Service account type” to “Same as DSS host”

  * Click on “Start”

  * Wait for your cluster to be available

  * In Settings, go to “Containerized execution”, and in “Default cluster”, select the cluster you just created.

  * In the “gke-default” configuration, adjust the “Image registry url” if needed

  * Click on “Save” then “Push base images”. When finished, click on “(Re)Install Jupyter kernels”.

  * In a project, you can now use containerized execution for any activity, using the containerized config you created

---

## [installation/cloudstacks-gcp/how-to-setup-fm-init-scripts]

# Howto: Install a script on your Fleet Manager to be run at VM restart time

This application note documents how it is possible to install scripts on the Fleet Manager (FM) VM so that they are run when the VM is restarted.

## Overview

The FM startup process looks for folders `/data/etc/dataiku-fm-init-scripts/{before|after}-startup.d` in the VM. The shell executable scripts found in these folders will be executed in lexicographic order respectively before or after FM startup.

The logs for the different executions will be stored in `/data/var/log/dataiku-fm-init-scripts/{before|after}-startup.d` with the execution time in the file name.

Both scripts and script logs are available in FM diag.

## Installing scripts

Let’s take the example of a script to be executed before FM startup.

In order to install the script, SSH on the FM machine and run the following:
    
    
    sudo su root
    mkdir -p /data/etc/dataiku-fm-init-scripts/before-startup.d
    chown dataiku:dataiku /data/etc/dataiku-fm-init-scripts/before-startup.d
    cd /data/etc/dataiku-fm-init-scripts/before-startup.d
    touch test.sh
    chmod +x test.sh
    # implement your script in test.sh
    # change script folder to after-startup.d if you want the script to run after FM startup
    

## Script examples

### Deprovision DSS nodes for the night

#### Overview

This script will create all the necessary to install a system.d timer running every night at 8:00 PM in order to deprovision all the DSS machines listed in this FM instance.

Machine deprovisioning can be prevented by adding tag `no-auto-deprovision` to the machines needing it.

#### Script

Create an executable bash script in `/data/etc/dataiku-fm-init-scripts/after-startup.d` with the following code:
    
    
    #!/usr/bin/env bash
    
    # Get an API key and API secret for FM Python API
    output="$(sudo -u dataiku /data/dataiku/fmhome/bin/fmadmin create-personal-api-key admin /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes_credentials.json)"
    
    # create the Python script deprovisioning the instances
    if [ ! -f /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes.py ]; then
    cat > /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes.py << EOF
    import dataikuapi
    import sys
    import json
    from pathlib import Path
    from dataikuapi.fm.instancesettingstemplates import FMSetupAction, FMSetupActionType
    
    FM_URL = "http://localhost:10000"
    NO_DEPROVISION_TAG = "no-auto-deprovision"
    
    def read_credentials(credentials_file_location):
        credentials_file_path = Path(credentials_file_location)
        if not credentials_file_path.is_file():
            raise Error("The provided credentials path does not match an existing JSON file")
    
        try:
            with open(credentials_file_location) as credentials_file:
                credentials_json = json.load(credentials_file)
            if not "id" in credentials_json or not "secret" in credentials_json:
                raise Error("The provided credentials file has incorrect JSON format")
        except:
            raise Error("The provided credentials file has incorrect JSON format")
    
        api_key = credentials_json["id"]
        api_secret = credentials_json["secret"]
    
        return api_key, api_secret
    
    def read_cloud():
        user_data_file_location = "/data/dataiku/fmhome/config/user-data.json"
        with open(user_data_file_location) as user_data_file:
            user_data = json.load(user_data_file)
        return str.lower(user_data['cloud'])
    
    def deprovision_instances(cloud, credentials_file_location):
        # Read credentials from the JSON file
        api_key, api_secret = read_credentials(credentials_file_location)
    
        # Create an FM client
        if cloud == "aws":
            print("Creating FM client for AWS")
            fm_client = dataikuapi.FMClientAWS(FM_URL, api_key, api_secret)
        elif cloud == "gcp":
            print("Creating FM client for GCP")
            fm_client = dataikuapi.FMClientGCP(FM_URL, api_key, api_secret)
        elif cloud == "azure":
            print("Creating FM client for Azure")
            fm_client = dataikuapi.FMClientAzure(FM_URL, api_key, api_secret)
        else:
            print(f"Unknown cloud provider: {cloud}")
    
        # List and display instances with their status in a table
        instances = fm_client.list_instances()
        futures = []
    
        print("Listing instances to be deprovisioned...")
        for instance in instances:
            if NO_DEPROVISION_TAG in instance.instance_data["fmTags"]:
                print(f"  - Skipping deprovision for instance with ID [{instance.instance_data['id']}]")
                continue
            instance_status = instance.get_status()
            if 'hasPhysicalInstance' in instance_status and instance_status['hasPhysicalInstance']:
                print(f"  - Scheduling deprovision for instance with ID [{instance.instance_data['id']}]")
                futures.append(instance.deprovision())
    
        print("Deprovisioning instances...")
        for future in futures:
            future.wait_for_result()
    
        print("Completed")
    
    if __name__ == "__main__":
        credentials_file_location = sys.argv[1]
    
        deprovision_instances(read_cloud(), credentials_file_location)
    EOF
    fi
    
    # Create system.d service file
    if [ -f /etc/systemd/system/deprovision_fm_nodes.timer ]; then
    systemctl stop deprovision_fm_nodes.timer
    rm -f /etc/systemd/system/deprovision_fm_nodes.timer
    fi
    
    if [ -f /etc/systemd/system/deprovision_fm_nodes.service ]; then
    rm -f /etc/systemd/system/deprovision_fm_nodes.service
    fi
    
    cat > /etc/systemd/system/deprovision_fm_nodes.service << EOF
    [Unit]
    Description="Deprovision DSS machines for the night"
    
    [Service]
    ExecStart=/data/dataiku/fmhome/pyenv/bin/python /data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes.py "/data/etc/dataiku-fm-init-scripts/after-startup.d/deprovision_fm_nodes_credentials.json"
    EOF
    
    # Create system.d corresponding timer file
    cat > /etc/systemd/system/deprovision_fm_nodes.timer << EOF
    [Unit]
    Description="Deprovision DSS nodes attached to this FM for the night"
    
    [Timer]
    OnCalendar=Mon..Fri *-*-* 20:00
    Unit=deprovision_fm_nodes.service
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    # Load the new files
    systemctl daemon-reload
    
    # Start timer
    systemctl start deprovision_fm_nodes.timer
    
    # Check timer status to have it in logs
    systemctl status deprovision_fm_nodes.timer
    

### Provision DSS nodes in the morning

#### Overview

This script will create all the necessary to install a system.d timer running every morning at 8:00 AM in order to provision all the DSS machines listed in this FM instance.

Machine provisioning can be prevented by adding tag `no-auto-provision` to the machines needing it.

#### Script

Create an executable bash script in `/data/etc/dataiku-fm-init-scripts/after-startup.d` with the following code:
    
    
    #!/usr/bin/env bash
    
    # Get an API key and API secret for FM Python API
    output="$(sudo -u dataiku /data/dataiku/fmhome/bin/fmadmin create-personal-api-key admin /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes_credentials.json)"
    
    # create the Python script provisioning the instances
    if [ ! -f /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes.py ]; then
    cat > /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes.py << EOF
    import dataikuapi
    import sys
    import json
    from pathlib import Path
    from dataikuapi.fm.instancesettingstemplates import FMSetupAction, FMSetupActionType
    
    FM_URL = "http://localhost:10000"
    NO_PROVISION_TAG = "no-auto-provision"
    
    def read_credentials(credentials_file_location):
        credentials_file_path = Path(credentials_file_location)
        if not credentials_file_path.is_file():
            raise Error("The provided credentials path does not match an existing JSON file")
    
        try:
            with open(credentials_file_location) as credentials_file:
                credentials_json = json.load(credentials_file)
            if not "id" in credentials_json or not "secret" in credentials_json:
                raise Error("The provided credentials file has incorrect JSON format")
        except:
            raise Error("The provided credentials file has incorrect JSON format")
    
        api_key = credentials_json["id"]
        api_secret = credentials_json["secret"]
    
        return api_key, api_secret
    
    def read_cloud():
        user_data_file_location = "/data/dataiku/fmhome/config/user-data.json"
        with open(user_data_file_location) as user_data_file:
            user_data = json.load(user_data_file)
        return str.lower(user_data['cloud'])
    
    def provision_instances(cloud, credentials_file_location):
        # Read credentials from the JSON file
        api_key, api_secret = read_credentials(credentials_file_location)
    
        # Create an FM client
        if cloud == "aws":
            print("Creating FM client for AWS")
            fm_client = dataikuapi.FMClientAWS(FM_URL, api_key, api_secret)
        elif cloud == "gcp":
            print("Creating FM client for GCP")
            fm_client = dataikuapi.FMClientGCP(FM_URL, api_key, api_secret)
        elif cloud == "azure":
            print("Creating FM client for Azure")
            fm_client = dataikuapi.FMClientAzure(FM_URL, api_key, api_secret)
        else:
            print(f"Unknown cloud provider: {cloud}")
    
        # List and display instances with their status in a table
        instances = fm_client.list_instances()
        futures = []
    
        print("Listing instances to be provisioned...")
        for instance in instances:
            if NO_PROVISION_TAG in instance.instance_data["fmTags"]:
                print(f"  - Skipping provision for instance with ID [{instance.instance_data['id']}]")
                continue
            instance_status = instance.get_status()
            if 'hasPhysicalInstance' in instance_status and not instance_status['hasPhysicalInstance']:
                print(f"  - Scheduling provision for instance with ID [{instance.instance_data['id']}]")
                futures.append(instance.reprovision())
    
        print("Provisioning instances...")
        for future in futures:
            future.wait_for_result()
    
        print("Completed")
    
    if __name__ == "__main__":
        credentials_file_location = sys.argv[1]
    
        provision_instances(read_cloud(), credentials_file_location)
    EOF
    fi
    
    # Create system.d service file
    if [ -f /etc/systemd/system/provision_fm_nodes.timer ]; then
    systemctl stop provision_fm_nodes.timer
    rm -f /etc/systemd/system/provision_fm_nodes.timer
    fi
    
    if [ -f /etc/systemd/system/provision_fm_nodes.service ]; then
    rm -f /etc/systemd/system/provision_fm_nodes.service
    fi
    
    cat > /etc/systemd/system/provision_fm_nodes.service << EOF
    [Unit]
    Description="Provision DSS machines in the morning"
    
    [Service]
    ExecStart=/data/dataiku/fmhome/pyenv/bin/python /data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes.py "/data/etc/dataiku-fm-init-scripts/after-startup.d/provision_fm_nodes_credentials.json"
    EOF
    
    # Create system.d corresponding timer file
    cat > /etc/systemd/system/provision_fm_nodes.timer << EOF
    [Unit]
    Description="Provision DSS nodes attached to this FM in the morning"
    
    [Timer]
    OnCalendar=Mon..Fri *-*-* 08:00
    Unit=provision_fm_nodes.service
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    # Load the new files
    systemctl daemon-reload
    
    # Start timer
    systemctl start provision_fm_nodes.timer
    
    # Check timer status to have it in logs
    systemctl status provision_fm_nodes.timer

---

## [installation/cloudstacks-gcp/index]

# Dataiku Cloud Stacks for GCP

Cloud stacks allow you to deploy a fully-managed Dataiku setup on Google cloud. The setup comes fully-featured with Elastic AI, advanced security, R support, auto-healing setup, …

Everything is deployed in your GCP organization and projects, Dataiku does not have access to your data.

---

## [installation/cloudstacks-gcp/instances]

# Instances

Fleet Manager manages three kinds of DSS instances:

  * Design nodes

  * Execution (aka automation) nodes

  * Deployer nodes (usually you only have a single deployer node in your fleet)




## Dashboard

The main screen through which you will get information about your instance is the dashboard. It is refreshed automatically and displays basic network information, data disk usage as well as the [agent](<concepts.html#gcp-cloudstacks-concept-agent>) logs.

## Lifecycle

### Provisioning

The provisioning is the sequence of operations required to have a running DSS reachable by users. Provisioning an instance has two main stages:

  * The provisioning of cloud resources required for the instance to run. It is mostly a virtual machine and a data disk.

  * A software startup sequence run by the [agent](<concepts.html#gcp-cloudstacks-concept-agent>) which runs internal setup tasks, the setup actions you defined in your instance template, and installs and upgrades DSS if required.




Some settings changes require that you deprovision an instance an provision it again, which is denoted as _reprovisioning_.

### Deprovisioning

Deprovisioning an instance consists of terminating the cloud virtual machine. The Persistent Disk is kept. A deprovisioned instance costs the Persistent Disk storage fee.

## Data management

When an instance is created, a data disk distinct from the OS disk is created, attached and mounted to store all the persistent data. The persistent data on an instance includes, but is not limited to:

  * The DSS data directory

  * The docker daemon data directory

  * The certificates generated if self-signed certificates or Let’s Encrypt certificates are in use.




## Settings

An instance has various settings that can be set at different point of its lifecycle.

### General settings

Not documented yet

### HTTPS settings

Not documented yet

## Operations

Not documented yet

---

## [installation/cloudstacks-gcp/multi-region-account]

# Multi-region and multi-account support

Fleet Manager can manage cloud objects across different regions and impersonate different identities.

By default, it operates within the same region where it is deployed and uses its own identity.

If you are reusing an existing Fleet Manager role, ensure that its permissions match those documented in the [Fleet Manager installation procedure](<guided-setup-new-vpc-elastic-compute.html>).

## Multi-account support

In order to manipulate cloud objects with a different identity, an account needs to be created in Fleet Manager.

One authentication mode is available:

  * **JSON key**




### JSON key

  * Create a service account the same way Fleet Manager service account was created during [Fleet Manager installation](<guided-setup-new-vpc-elastic-compute.html>)

  * Create a JSON key for this service account and take note of the key JSON content




## Multi-region support

In Google Cloud Console, a new VPC in the target region has to be created the same way Fleet Manager VPC was created in [Fleet Manager installation](<guided-setup-new-vpc-elastic-compute.html>).

When creating the corresponding virtual network in Fleet Manager, specify the desired region. Any objects deployed in this virtual network will be located in that region.

In this case, both the virtual network where Fleet Manager is deployed and the virtual network where the objects will be deployed must be paired. Fleet Manager can handle this pairing process.

Make sure the _Compute Engine API_ is activated on your project as it will be required when creating the VPC.

## Combining Multi-region and Multi-account

You can use both multi-region and multi-account capabilities simultaneously.

To do so, select an account different from the default Fleet Manager account when creating a virtual network in Fleet Manager.

---

## [installation/cloudstacks-gcp/sso]

# Single Sign-On

Single sign-on (SSO) refers to the ability for users to log in just one time with one set of credentials to get access to all corporate apps, websites, and data for which they have permission.

By setting up SSO in FM, your users will be able to access FM using their corporate credentials.

SSO solves key problems for the business by providing:

>   * Greater security and compliance.
> 
>   * Improved usability and user satisfaction.
> 
> 


Delegating the FM authentication to your corporate identity provider using SSO allows you to enable a stronger authentication journey to FM, with multi-factor authentication (MFA) for example.

FM supports the following SSO protocols:

>   * OpenID connect
> 
>   * SAML
> 
> 


## Users database

Since FM users all have the same privileges, we recommend that you simply map all your login users to the admin user.

If you choose not to map to the same user, you must create FM user accounts for each SSO user. When creating these users, select “Local (no auth, for SSO only)” as the source type. Since users won’t enter passwords in SSO mode, only a login and display name are required.

## OpenID Connect

### About OIDC

#### Glossary

  * **OIDC** : **O** pen**ID** **C** onnect

  * **IDP** : An **Id** entity **P** rovider is a system entity that creates, maintains, and manages identity information for principals and also provides authentication services to relying applications within a federation or distributed network

  * **End-user** : The end user is the entity for whom we are requesting identity information. In our case, it is the FM user that need to login to access FM.

  * **OIDC Client** : Also called Relying party **RP** in the OIDC specification, the OIDC client is the application that relies on the IDP to authenticate the end user. In our case, it is FM.

  * **ID Token** : Similar to a ID card or passport, it contains many required attributes or claims about the user. This token is then used by FM to map the claims to a corresponding FM user. Digitally signed, the ID token can be verified by the intended recipients (FM).

  * **Claim** : In FM context, claims are name/value pairs that contain information about a user.

  * **Scope** : In the context of OIDC, scope references a set of claims the OIDC client needs. Example: email

  * **Authorization code** : During the OIDC protocol, the authorization code is generated by the IDP and sent to the end-user, which passes it to the OIDC client. It is then used by the OIDC client, who sends the authorization code to the IDP, and receives in exchange an ID token. Using an intermediate authorization code allows the IDP to mandate the OIDC client to authenticate itself in order to retrieve the ID token.

  * **Confidential client** : An OIDC client with the capacity to exchange the authorization code for an ID token in a secured back channel. This is the case of FM.

  * **Public client** : An OIDC client not able to store secret securely and needs to exchange the authorization code for an ID token in a public channel. FM is not a public client.

  * **PKCE** : **P** roof **K** ey for **C** ode **E** xchange is an extension of the OIDC protocol, to allow public clients to exchange the authorization code in a public channel.




#### Compatibility

FM OIDC integration has been successfully tested against the following OIDC identity providers:

  * OKTA

  * Azure Active Directory

  * Google G.Suite

  * Keycloak




#### OIDC features supported by FM

  * authorization code grant flow

  * simple string claims in the ID token

  * non encrypted or signed authentication requests

  * ID token signed with RSA or EC

  * FM behind a proxy

  * response mode supported: query or fragment

  * token endpoint auth method supported: client secret basic or client secret POST

  * confidential OIDC client only (PKCE not supported)




#### How OIDC looks like with FM

Once configured for OIDC SSO, FM acts as an OIDC client, which delegates user authentication to an identity provider.

  1. When the end user tries to access FM and is not authenticated yet, FM will redirect him to the IDP. The URL used will be the authorization endpoint of the IDP, which some specific GET parameters specific to the FM setup.

  2. The IDP will validate the GET parameters and will present a login page to the user. The authentication journey now depends on your IDP capabilities. Sometimes, when already logged-in on the IDP side, the login page is skipped and the user may not see the redirection to the IDP.

  3. The IDP has authenticated the end user and will redirect the user to FM with an authorization code. Depending of your OIDC client setup in your IDP, the code may be passed through via the query parameters or the fragment.

  4. The front-end of FM will parse and send the parameters, including the authorization code, to the FM backend.

  5. The FM backend will exchange this authorization code for an access token, by calling the token endpoint with the credentials you previously have configured in FM SSO settings. If successful, the IDP will return an ID token corresponding the end user.

  6. FM uses the ID token to map the end user to a FM user. The mapping setup is part of the SSO configuration of OIDC.

  7. FM creates a user session corresponding to the FM user. At this point, OIDC is completed and the user session is agnostic of the authentication protocol used.




### Setup OIDC in FM

To set up OIDC integration, you need:

  * to register a new OIDC Client (sometimes called an ‘application’) for FM in your identity provider,

  * to configure FM with the parameters of the identity provider as well as the parameters corresponding to the OIDC client created earlier,

  * to configure which of the user attributes returned by the IDP is to be used as the FM username, and optionally configure rewrite rules to extract the FM username from the chosen user attribute.




These steps are individually detailed below.

#### Registering a service provider entry for FM on the identity provider.

The exact steps for this depend on the identity provider platform which you plan to connect to, and should be performed by your IDP administrator. This entry may also be called an “OIDC application”. You will sometimes be asked to select the type of application, which would be in our case a web application.

You will typically need:

  * to setup the OIDC client to use the authorization code grant flow,

  * a client ID,

  * a client secret,




Note

The OIDC client needed by FM is a confidential client (opposite of public client). Meaning FM is able to protect the client secret, by exchanging the authorization code (and using the secret in the request) from the backend.

  * setup the redirect URI BASE_URL/login/openid-redirect-uri/,




Note

This URL must be configured as BASE_URL/login/openid-redirect-uri/, where BASE_URL is the URL through which FM users access this FM instance.

For example, if FM is accessed at https://dataiku.mycompany.corp/, the OIDC redirect uri must be defined as https://dataiku.mycompany.corp/login/openid-redirect-uri/.

Note that some identity providers require the redirect URI to use the HTTPS scheme.

  * associate some OIDC scopes to the OIDC client. Some IDPs refer to these as permissions, like user.read. You will need to setup the scope openid as well as some identity claims. You must ensure that FM is able to access and retrieve all the user attributes needed to identify the corresponding user in FM.




Note

FM will need to map to an existing user from one of the user claims. It’s important that you allow FM to retrieve a claim that is easily mappable to the username. A good candidate is email, of which you can strip the part after ‘@’ to compose a unique identifier for usernames.

#### Configuring FM for OIDC authentication.

OIDC configuration is in the “Settings / Security & Audit / User login & provisioning / SSO” screen.

Select “Enable”, choose protocol “OIDC”.

##### IDP configuration

Contact your IDP administrator to retrieve this information or check your IDP documentation.

The easiest way to setup the IDP configuration is using the well-known endpoint: The OIDC standard defines an endpoint, called well-known, to discover the IDP configuration. FM lets you enter the well-known endpoint of your IDP and fetch the rest of the configuration for you. If you don’t know the well-known endpoint, you can still enter the other configurations manually, the well-known input being optional.

  * **Well-known URL** : Optional, defines the well-known endpoint, which is a URI ending with /.well-known/openid-configuration. Click Fetch IDP configuration to auto-complete the rest of the IDP configuration.

  * **Issuer** : The issuer is a URI to identify the IDP. It is used in particular to verify that the ID token was signed by the right IDP. Per specification, the issuer is a URI, for which you can append the path /.well-known/openid-configuration to get the IDP well-known endpoint.




Note

Tips: If you have an example of a valid ID token, you can read its content with [jwt.io](<https://jwt.io>) and find the issuer value behind the iss claim. You can then build up the well-known URI by appending /.well-known/openid-configuration to it.

  * **Authorization endpoint** : The authorization endpoint is used to redirect the user to the IDP for the authentication.

  * **Token endpoint** : The token endpoint is used by FM to exchange the authorization code with an ID token. This endpoint will be called from the backend of FM. If FM is behind a proxy, please make sure FM is able to call this endpoint.

  * **JWKs URI** : The JWKs URI is a way for the IDP to specify all its public keys. This is used by FM to verify the signature of the ID token.




Examples of well-known endpoints:

  * **Google** : <https://accounts.google.com/.well-known/openid-configuration>

  * **Azure** : <https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration>

  * **Okta** : <https://common.okta.com/.well-known/openid-configuration>

  * **Keycloak** : <https://your-keycloak-instance/auth/realms/your-realm/.well-known/openid-configuration>




Note

In some case, the well-known can be the same for everyone, like for google. In other scenario, the IDP will generate a dedicated one for your application, like Okta or Azure for which it is configured by tenant.

##### OIDC Client configuration

In the previous section, you created an OIDC client. Use this client to complete the following section:

  * **Token endpoint auth method** : This is the authentication method that FM will use to specify the credentials during the token exchange. Most of the time, when supporting client secret, the IDP will allow either of the two methods. Leave this field by default if you are unsure, as it will most likely work.

  * **Client ID** : the client ID generated by the IDP. In the IDP portal, it could be named application id. Refer to your IDP documentation for more details on how to retrieve your client ID.

  * **Client secret** : The client secret your IDP generated for this client. Sometimes, it is not generated by default by your IDP (like Azure). In this case, look for a section ‘secrets’ in your IDP setup for the OIDC client.

  * **Scope** : Specify the scope that FM needs to use during the login flow. As a minima, it should contain openid. The scope contains a list of scopes separated by spaces.




Note

The scope is essential for doing the mapping with the username, as it defines the user claims the IDP needs to send back to FM. We recommend to add either email or/and profile, two common scopes supported by most IDPs. Most IDPs will mandate that you add some dedicated permissions before associating those scopes to your OIDC client. See your IDP documentation for more details.

Note

The list of scopes supported by your IDP is listed in the well-known, under the attribute claims_supported. Even if they are supported, you will still need to authorise the OIDC client to use those scopes, via your IDP portal.

##### Examples of scopes by IDPs

For Google, Azure, Okta and Keycloak, the simplest scope is email, which will return two claims - email and email_verified. Set in Identifier claim key the claim email.

Azure, Okta and Keycloak also support another claim called preferred_username, which is returned as part of the profile scope.

Resources:

  * [Google documentation](<https://developers.google.com/identity/protocols/oauth2/openid-connect#an-id-tokens-payload>)

  * [Azure documentation](<https://docs.microsoft.com/en-us/azure/active-directory/develop/id-tokens>)

  * [Okta documentation](<https://developer.okta.com/docs/reference/api/oidc/#scope-values>)

  * [Keycloak documentation](<https://www.keycloak.org/docs/latest/securing_apps/>) (search for principal-attribute in the page)




#### Mapping to the FM user

When FM successfully retrieves the ID token from the IDP, it needs to map it to a user in FM. The ID token will contain user claims that depend on the scope you defined earlier. The following two fields will help FM map the ID token to a FM user:

  * **Identifier claim key** : Depending on the scope you configured, the IDP will return different user claims. Define here the one you want to use to map to the corresponding username in FM. One easy way that works for most IDP, is to use the email and then strip the part after the ‘@’.

  * **Login remapping rules** : Map a claim received from the IDP to your username format. Example: stripping the part after ‘@’ in an email. You may not need this field if your IDP is returning a user claim that matches exactly the username (it’s the case of keycloak if you use the preferred_username claim for example).




Warning

The Login remapping rules are evaluated in order. If you have multiple rules and their regexes overlap (ie ^(.*)@mycompany.corp$ and ^(.*)$), make sure the most specific one is defined first.

Note

Example of mapping if you choose the email as identifier claim: ^(.*)@mycompany.corp$ -> $1

Note

FM logs all the claims received from the IDP in the backend log file, which may help configuring the Identifier claim key and the mapping for it.

#### User Supplier

DSS SSO implementation is able to supply users from an SSO context. Meaning you can configure DSS to auto-provision or synchronize users when a user authenticates via SSO.

Once you have enabled the Login-time provisioning and/or Login-time resync options, you must configure the mapping between the ID token (the identity provider’s response to DSS) and the representation of an identity in DSS. See your OpenID identity provider’s documentation or contact your identity provider’s administrator for the required information.

#### Testing OIDC SSO

  * Configure OIDC integration as described above

  * Access the FM URL from another browser or an anonymous window

  * You should be redirected to the IDP for authentication, then back to the FM redirect URL, then to the FM homepage

  * If login fails, check the logs for more information




Important

Once SSO has been enabled, if you access the root FM URL, SSO login will be attempted. If SSO login fails, you will only see an error.

You can still use the regular login/password login by going to the `/login/` URL on FM. This allows you to still log in using a local account if SSO login is dysfunctional.

## SAML

### About SAML

#### Compatibility

FM has been successfully tested against the following SAML identity providers:

  * OKTA

  * PingFederate PingIdentity (see note below)

  * Azure Active Directory

  * Google G.Suite

  * Microsoft Active Directory Federation Service (tested against Windows 2012 R2)

  * Auth0

  * Keycloak




Note

For AD FS, it is mandatory to configure at least one claim mapping rule which maps to “Name ID”, even if another attribute is used as the FM login attribute.

FM does not support SAML encryption.

### Setup SAML in FM

To set up SAML integration, you need:

  * to register a new service provider entry on your SAML identity provider, for this FM instance. This entry is identified by a unique “entity ID”, and is bound to the SAML login URL for this FM instance.

  * to configure FM with the IdP parameters, so that FM can redirect non logged-in users to the IdP for authentication, and can authentify the IdP response

  * optionally, to configure which of the user attributes returned by the IdP is to be used as the FM username, or configure rewrite rules to extract the FM username from the chosen IdP attribute




These steps are individually detailed below.

#### Registering a service provider entry for FM on the identity provider.

The exact steps for this depend on the identity provider platform which you plan to connect to, and should be performed by your IdP administrator. This entry may also be called a “SAML application”.

You will typically need:

  * an “Entity ID” which uniquely represents this FM instance on the IdP (sometimes also called “Application ID URI”).

This entity ID is allocated by the IdP, or chosen by the IdP admin.

  * the SAML login URL for FM (“Assertion Consumer Service Endpoint”, which may also be called “Redirect URI”, “Callback URL”, or “ACS URL”).

This URL _must_ be configured as
        
        BASE_URL/api/saml-callback

where `BASE_URL` is the URL through which FM users access this FM instance.

For example, if FM is accessed at <https://fm.mycompany.corp>, the SAML callback URL must be defined as



    
    
    <https://fm.mycompany.corp/api/saml-callback>

Note that some SAML identity providers require the callback URL to use the HTTPS scheme.

As an additional step, you may also have to authorize your users to access this new SAML application at the IdP level.

Finally, you will need to retrieve the “IdP Metadata” XML document from the identity provider, which is required to configure FM (also called “Federation metadata document”).

#### Configuring FM for SAML authentication.

SAML configuration is in the “Settings / Security & Audit / User login & provisioning / SSO” screen.

Select “Enable”, choose protocol “SAML” and fill up the associated configuration fields:

  * IdP Metadata XML : the XML document describing the IdP connection parameters, which you should have retrieved from the IdP.

It should contain a <EntityDescriptor> record itself containing a <IDPSSODescriptor> record.

  * SP entity ID : the entity ID (or application ID) which you have configured on the IdP in the step above

  * SP ACS URL : the redirect URL (or callback URL) which you have configured on the IdP in the step above




Warning

You need to restart FM after any modification to the SAML configuration parameters.

##### Optional: configuring signed requests

If your IdP requires it (this is generally not the case) you can configure FM to digitally sign SAML requests so that the IdP can authentify them.

For this, you need to provide a file containing a RSA or DSA keypair (private key plus associated certificate), which FM will use for signing, and provide the associated certificate to the IdP so that it can verify the signatures.

This file must be in the standard PKCS#12 format, and installed on the FM host. It can be generated using standard tools, as follows:
    
    
    # Generate a PKCS12 file containing a self-signed RSA key and certificate with the "keytool" java command:
    keytool -keystore <FILENAME>.p12 -storetype pkcs12 -storepass <PASSWORD> -genkeypair -keyalg RSA -dname "CN=DSS" -validity 3650
    
    # Generate a PKCS12 file containing a self-signed RSA key and certificate with the openssl suite:
    openssl req -x509 -newkey rsa:2048 -nodes -keyout <FILENAME>.key -subj "/CN=DSS" -days 3650 -out <FILENAME>.crt
    openssl pkcs12 -export -out <FILENAME>.p12 -in <FILENAME>.crt -inkey <FILENAME>.key -passout pass:<PASSWORD>
    

You then need to complete the FM configuration as follows:

  * check the “Sign requests” box

  * Keystore file : absolute path to the PKCS#12 file generated above

  * Keystore password : PKCS#12 file password

  * Key alias in keystore : optional name of the key to use, in case the PKCS#12 file contains multiple entries




#### Choosing the login attribute

Upon successful authentication at the IdP level, the IdP sends to FM an assertion, which contains all attributes of the logged in user. Each attribute is named. You need to indicate which of the attributes contains the user’s login, that FM will use.

Note that FM logs all attributes received from the SAML server in the backend log file, which may help configuring this field.

If this field is left empty, FM will use the default SAML “name ID” attribute.

#### Login remapping rules

Optionally, you can define one or several rewriting rules to transform the selected SAML attribute into the intended FM username. These rules are standard search-and-replace Java regular expressions, where `(...)` can be used to capture a substring in the input, and `$1`, `$2`… mark the place where to insert these captured substrings in the output. Rules are evaluated in order, until a match is found. Only the first matching rule is taken into account.

A standard use case for such rewriting rules would be to strip the domain part from email-address-like attributes. For example, configuring the following rule:
    
    
    ([^@]*)@mydomain.com     ->     $1
    

would rewrite a SAML attribute `first.last@mydomain.com` into `first.last`, and do nothing on SAML attribute `first.last@otherdomain.com` (as the left-hand part of the rule would not match).

Warning

The Login remapping rules are evaluated in order. If you have multiple rules and their regexes overlap (ie ^(.*)@mycompany.corp$ and ^(.*)$), make sure the most specific one is defined first.

#### User Supplier

DSS SSO implementation is able to supply users from an SSO context. Meaning you can configure DSS to auto-provision or synchronize users when a user authenticates via SSO.

Once you have enabled the Login-time provisioning and/or Login-time resync option, in the SAML context you need to configure the mapping between the SAML assertion (the identity provider’s response to DSS) and the DSS representation of an identity. (See the documentation of your identity provider or contact your identity provider’s administrator for the required information).

#### Testing SAML SSO

  * Configure SAML integration as described above

  * Restart FM

  * Access the FM URL from another browser or an anonymous window

  * You should be redirected to the IDP for authentication, then back to the FM redirect URL, then to the FM homepage

  * If login fails, check the logs for more information




Note

Once SSO has been enabled, if you access the root FM URL, SSO login will be attempted. If SSO login fails, you will only see an error.

You can still use the regular login/password login by going to the `/login/` URL on FM. This allows you to still log in using a local account if SSO login is dysfunctional.

If the SAML configuration is invalid (in particular if the IdP metadata XML is malformed) FM will not restart. You will need to manually disable SAML in the general-settings.json configuration file as described below.

---

## [installation/cloudstacks-gcp/tagging]

Note

The following section refers to cloud tags. Those are equivalent to Google Cloud labels. You can find more information on the [GCP Labels documentation](<https://cloud.google.com/compute/docs/labeling-resources#what-are-labels>) page.

# Tagging on Dataiku Cloud Stacks

Dataiku Cloud Stacks (DCS) allows to tag (or label) cloud resources in order to leverage cloud provider specific features such as managing, identifying, organizing, searching for, and filtering resources. Cloud tags are supported on the following DCS entities:

  * Tenants

  * Cloud Accounts

  * Virtual Networks

  * Load Balancers

  * Instances




Cloud tags are key-value pairs that are applied as metadata on the cloud resources created by DCS during provisioning of entities like instances or load balancers. Some entities like cloud accounts are not provisioned and do not create cloud resources themselves, but tags are inherited according to the following hierarchy:

**Tenants ⇒ Cloud Accounts ⇒ Virtual Networks ⇒ Load Balancers ⇒ Instances**

This means that any cloud tags in a Tenant will be inherited by the Cloud Accounts in that Tenant, that any cloud tags in a Cloud Account will be inherited by the Virtual Networks attached to that Cloud Account, etc.

You will be able to find a list of inherited tags in the Virtual Networks, Load Balancers and Instances dashboard pages:

Cloud tags are also now displayed on the listing pages of Instances, Load Balancers, Cloud Accounts and Virtual Networks. They can also be used for filtering the list.

## Limitations

Tagging in Dataiku Cloud Stacks has some limitations related to the cloud provider that the platform is deployed on. Please refer to each Cloud specific requirements section for more information.

Tags are not updated on cloud resources while saving of the form of the entity being modified. The entity must be reprovisioned for the new tags to be applied when supported.

Virtual Networks are not reprovisionable, thus the resources created (e.g. security groups) will not be updated with new tags upon modification. However, due to the inheritance, new or reprovisioned instances and load balancers created within the Virtual Network will contain the updated tags.

Warning

The data disk of an instance is kept throughout its lifecycle, thus reprovisioning will overwrite already existing tags and add new ones, but it will not delete ones that were removed. Be mindful that tags may accumulate on the data disk of an instance if changed often and this might cause issues related to Cloud provider limitations.

## Google Cloud specific requirements

You can find any Google Cloud specific labeling requirements in the [Google Cloud documentation](<https://cloud.google.com/compute/docs/labeling-resources#requirements>)

---

## [installation/cloudstacks-gcp/templates-actions]

# Instance templates and setup actions

Instance template represent common configuration for instances, reusable across several instances. It is required to use an instance template to launch an instance. Instances stay linked to their instance template for their whole lifecycle.

What is configured through the instance templates includes, but is not limited to:

  * Identities able to SSH to the instance

  * Cloud credentials for the managed DSS

  * Installation of additional dependencies and resources

  * Pre-baked and custom configurations for DSS




To create, edit and delete templates, head to the _Instance templates_ in the left menu of FM. The following document explains each section of the configuration.

## SSH Key

Use this field to enter a public SSH key that will be deployed on the instance. This is useful for admins to connect to the machine with SSH. This field is optional.

This key will be available on the `centos` account, i.e. you will be able to login as `centos@DSS.HOST.IP`

## User-assigned service accounts

In most cases, your DSS instances will require GCP credentials in order to operate. These credentials will be used notably to integrate with GAR and GKE.

The recommended way to offer GCP credentials to DSS instance is the use of a _service account_.

## Setup actions

Setup actions are configuration steps ran by the [agent](<concepts.html#gcp-cloudstacks-concept-agent>). As a user, you create a list a setup actions you wish to see executed on the machine.

### Add authorized SSH key

This setup action ensures the SSH public key passed as a parameter is present in ~/.ssh/authorized_keys file of the default admin account. The default admin is the centos user with currently provided images.

### Install system packages

This setup action is a convenient way to install additional system packages on the machine should you need them. It takes a list of Almalinux packages as only parameter. The package name or the package URL can be used.

### Set advanced security

This setup actions ensures DSS add security related HTTP headers. HSTS headers can be toggled separately.

### Install a JDBC driver

Instances come pre-configured with drivers for PostgresSQL, MariaDB, Snowflake, AWS Athena and Google BigQuery. If you need another driver, this setup action eases the process. It can download a file by HTTP, HTTPS, from S3 bucket or from an ABS container.

Install JDBC Driver parameters Parameter | Expected value  
---|---  
Database type |  The type of database you will use. This parameter has no actual effect, it is used for readability.  
URL |  This field expects the full address to the driver file or archive.   
Download from HTTP(S) endpoint:
    
    
    http(s)://hostname/path/to/file.(jar|tar.gz|zip)
    

Redirections are solved before download.   
Download from a S3 bucket:
    
    
    s3://BUCKET_NAME/OBJECT_NAME
    

Download from Azure Blob Storage:
    
    
    abs://STORAGE_ACCOUNT_NAME/CONTAINER_NAME/OBJECT_NAME
    

Use a driver available on the machine:
    
    
    file://path/to/file.(jar|tar.gz|zip)
      
  
Paths in archive |  This field must be used when the driver is shipped as a tarball or a ZIP file. Add here all the paths to find the JAR files in the driver archive. Paths are relative to the top of the archive. Wildcards are supported. Examples of paths:
    
    
    *.jar
    
    
    
    subdirA/*.jar
    subdirB/*.jar
      
  
HTTP Headers | List of HTTP headers to add to the query. One header per line.
    
    
    Header1: Value1
    Header2: Value2
    

Parameter ignored for all other kinds of download.  
HTTP Username |  **HTTP**   
If the endpoint expect Basic Authentication, use this parameter to specify the user name.   
**Azure**   
If the instance have several Managed Identities, set the _client_id_ of the targeted one in this parameter.   
To connect to Azure Blob Storage with a SAS Token (not recommended), set the value of this parameter to _token_.  
HTTP Password |  **HTTP**   
If the endpoint expect Basic Authentication, use this parameter to specify the password.   
**Azure**   
To connect to Azure Blob Storage with a SAS Token (not recommended), store the token value in this parameter.  
Datadir subdirectory | For very specific use-cases only, we recommend to let it empty.  
  
### Run Ansible tasks

This setup action allows you to run arbitrary ansible tasks at different point of the startup process.

The **Stage** parameter specificies at which point of the startup sequence it must be executed. There is three stages:

  * **Before DSS install** : These tasks will be run before the agent installs (if not already installed) or upgrades (if required) DSS.

  * **After DSS install** : These tasks will be run once DSS is installed or upgraded, but not yet started.

  * **After DSS is started** : These tasks will be run once DSS is ready to receive public API calls from the agent.




The **Ansible tasks** allows you to Write a YAML list of ansible tasks as if they were written in a role. Available tasks are base Ansible tasks and [Ansible modules for Dataiku DSS](<https://github.com/dataiku/dataiku-ansible-modules>). When using Dataiku modules, it is not required to use the connection and authentication options. It is automatically handled by FM.

Some additional facts are available:

  * dataiku.dss.port

  * dataiku.dss.datadir

  * dataiku.dss.version

  * dataiku.dss.node_id: Identifier matching the node id in Fleet Manager, unique per fleet

  * dataiku.dss.node_type: Node type is either design, automation, deployer or govern

  * dataiku.dss.logical_instance_id: Unique ID that identifies this instance in the Fleet Manager

  * dataiku.dss.instance_type: The cloud instance type (also referred to as instance size) used to run this instance

  * dataiku.dss.was_installed: Available only for stages **After DSS install** and **After DSS startup**

  * dataiku.dss.was_upgraded: Available only for stages **After DSS install** and **After DSS startup**

  * dataiku.dss.api_key: Available only for stage **After DSS startup**




Example:
    
    
    ---
    - dss_group:
        name: datascienceguys
    - dss_user:
        login: dsadmin
        password: verylongbutinsecurepassword
        groups: [datascienceguys]
    

Ansible is ran with the unix user held by the agent, and can run administrative tasks with become.

### Setup Kubernetes and Spark-on-Kubernetes

This task takes no parameter and pre-configures DSS so you can use Kubernetes clusters and Spark integration with them. It prepares the base images and enables DSS Spark integration.

### Add environment variables

This setup action enables to add environment variables that can be used in DSS. These variables are stored in bin/env-site.sh file.

### Add properties

Ansible is ran with the unix user held by the agent, and can run administrative tasks with become.

### Add SSH keys

This setup action enables to add SSH keys to ~/.ssh folder that can be used to connect to other machines from the DSS one.

To generate your public key on Dataiku Cloud:

  * go to your launchpad > extension tab > add an extension,

  * select the SSH integration feature,

  * enter the hostnames of the remote that this key is allowed to connect to,

  * click to validate and generate the key.




Dataiku Cloud will then automatically generate the key and run a command to the origin to get (and verify) the SSH host key of this server. You can now copy the generated key and add it to your hosts. To find this key in the future or generate a new one go to the extension tab and edit the SSH Integration feature.

### Setup proxy

This setup action enables to configure a proxy in front of DSS.

The default value for the NO_PROXY variable is: localhost,127.0.0.1,169.254.169.254,metadata,.google.internal.

169.254.169.254 is the IP used by GCP to host the metadata service.

### Add Certificate Authority to DSS truststore

This setup action is a convenient way to add a Certificate Authority to your DSS instances’ truststore. It will then be trusted for Java, R and Python processes. It takes a Certificate Authority in the public PEM format. A chain of trust can also be added by appending all the certificates in the same setup action.

Example (single CA):
    
    
    -----BEGIN CERTIFICATE-----
    (Your Root certificate authority)
    -----END CERTIFICATE-----
    

Example (Chain of Trust):
    
    
    -----BEGIN CERTIFICATE-----
    (Your Primary SSL certificate)
    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----
    (Your Intermediate certificate)
    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----
    (Your Root certificate authority)
    -----END CERTIFICATE-----
    

Warning

The name must be unique for each CA as it is used to write the CA in your instances.

### Install code env with Visual ML preset

This setup action installs a code environment with the Visual Machine Learning and Visual Time series forecasting preset.

Enable **Install GPU-based preset** to install the GPU-compatible packages. Otherwise, the CPU packages are installed.

Leaving **Allow in-place update** enabled means that if there is a newer version of the preset the next time the setup action runs, and it is compatible with the previously installed code environment, said code environment is updated in place. Otherwise, a new code environment is created with the updated preset.

---

## [installation/cloudstacks-gcp/tenant-settings]

# Global settings

There are only a few global settings in Fleet Manager, accessible from the “Cloud Setup” screen.

## GCP authentication

Fleet Manager needs to perform various calls to the GCP API in order to manage resources.

When you deploy Cloud Stacks using the recommended guided setup, the Fleet Manager virtual machine has a service account, whose permissions it uses.

## License

In order to benefit from most capabilities, you’ll need a Dataiku License or Dataiku License Token. You need to enter it here.

## HTTP proxy

Fleet Manager can run behind a proxy. Once you define at least a proxy host and port, Fleet Manager will use it to access different resources through HTTP:

  * to fetch new DSS image lists

  * to update or verify licenses

  * to log users in with the OpenID Connect protocol




The calls to GCP services won’t be proxied. As such, please make sure the following GCP services you require are reachable from the Fleet Manager virtual machine: Cloud APIs, Cloud KMS, Cloud DNS. You can for example use Private Service Connect to open access to GCP services in your network security group.

---

## [installation/cloudstacks-gcp/virtual-networks]

# Virtual networks

A virtual network in Fleet Manager is an object representing the networking setup of instances created into it.

The virtual network defines in which network and subnetwork the instances will be launched, as well as how DNS hostnames and HTTPS certificates for the instances will be used.

Each instance belongs to a virtual network. At least one virtual network is required to deploy instances.

## Networking requirements

The most important requirement is that the DSS instances must be able to reach FM on its main port. FM has a single URL that must be reachable by all DSS instances it creates, even if they span over several networks.

## Creating

Go to _Virtual networks_ and click on _New virtual network_ at the top right. You will be required to provide the mandatory values for virtual networks:

  * _Label_ : the name of the network that will be displayed in FM. It can be changed later.

  * _Project_ : project of the network in which you want to deploy instances. It is pre-filled with the project of the network in which FM is currently running. It cannot be changed after creation.

  * _Network_ : name of the network in which you want to deploy instances. It is pre-filled with the network in which FM is currently running. It cannot be changed after creation.

  * _Subnetwork_ : Name of the subnetwork in which you want to deploy instances. If is pre-filled with the subnetwork in which FM is currently running. It cannot be changed after creation.




## Editing

Once a virtual network has been created, you can edit its settings.

### Public IP address

By default, creates instances with a NAT gateway. You can disable this.

Changing the public IP policy requires reprovisioning the affected instances.

### DNS Strategy

When using this strategy, instances only get IP addresses. FM can assist in assigning hostnames. It is also required if you want to apply a verified HTTPS strategy.

Changing the DNS strategy requires reprovisioning the affected instances.

In the virtual networks list, click on the desired network to display its dashboard, then select the _Settings_ tabs to change the configuration. Select _Assign a GCP DNS domain name_ in the _DNS Strategy_ drop-down menu. Then fill in the Zone ID for each required zone, one to have DNS records for private IPs, a second one for the public IPs. If you need only one, let the unused field empty. Click on _Save_ at the top right to apply your changes.

If using DNS records for both private IPs and public IPs, the zone IDs must be distinct.

### HTTPS configuration

By default, instances are deployed with self-signed certificates. These will trigger security alerts in your browser.

FM supports several strategies for configuring HTTPS.

#### None

This is the default. This simple mode means no certificate is involved and instances are exposed on HTTP.

#### Self-signed certificate

When using this strategy, each instance will create its own self-signed certificate if none exists yet, and uses it to expose DSS on port 443. You can choose wether HTTP is closed or redirects to HTTPS.

Additional domain names can be handled by the self-signed certificate at instance level.

#### Custom certificate for each instance

Select _Enter a certificate/key for each instance_ to use the certificates emitted with by your PKI. When using this strategy, each instance will have to be configured with the certificate and private key intended for it. The secret key can be stored encrypted by FM or into your cloud provider secret manager.

You can choose wether HTTP is closed or redirects to HTTPS.

This mode requires instance level settings.

##### Let’s Encrypt

This mode makes use of [Let’s Encrypt](<https://letsencrypt.org/>) and [certbot](<https://certbot.eff.org/>) to generate and renew automatically a publicly recognized certificate. When using this mode, you must specify an email address representing the legal person owning the certificate.

Instances must be reachable on HTTP (80) and HTTPS (443) from the internet.

Additional domain names can be added at instance level.

Warning

Let’s Encrypt service has [rate limits](<https://letsencrypt.org/docs/rate-limits/>) that makes it unsuitable for numerous deletions and creations. Be careful to use it for stable deployments. If you hit your quota, there is no way to reset it.

---

## [installation/custom/advanced-customization]

# Customizing DSS installation

## Installation configuration file

The installation process for Data Science Studio can be customized through the `DATADIR/install.ini` configuration file.

This file is initialized with default values when the data directory is first created. It can be edited to specify a number of non-default installation options, which are then preserved upon upgrades.

Modifying this file requires running a post-installation command to propagate the changes, and restarting DSS, as follows:
    
    
    # Stop DSS
    DATADIR/bin/dss stop
    # Edit installation options
    vi DATADIR/install.ini
    # Regenerate DSS configuration according to the new settings
    DATADIR/bin/dssadmin regenerate-config
    # Restart DSS
    DATADIR/bin/dss start
    

The `install.ini` installation configuration file is a standard INI-style [Python configuration file](<https://docs.python.org/2/library/configparser.html>) with `[section]` headers followed by `key = value` entries. The following entries are set up by the initial installation and are mandatory:
    
    
    [general]
    # DSS node type (design node, api node...)
    nodetype = design
    
    [server]
    # DSS base port
    port = 11200
    

Additional installation options are described throughout this manual.

## Configuring HTTPS

By default, DSS listens to HTTP connections on the given base port, i.e. is accessible at address `http://DSS_HOST:DSS_PORT`. Using installation configuration directives, you can switch DSS to accepting HTTPS connection instead, i.e. answering `https://DSS_HOST:DSS_PORT`.

You will need to generate and provide a SSL server certificate and private key file matching the domain name used by end users to reach DSS. You can then configure DSS to switch to HTTPS by adding the following entries to the `[server]` section of the `install.ini` installation configuration file:
    
    
    [server]
    ssl = true
    ssl_certificate = PATH_TO_CERTIFICATE_FILE
    ssl_certificate_key = PATH_TO_PRIVATE_KEY_FILE
    ssl_ciphers = recommended
    

You should then regenerate DSS configuration and restart DSS, as described in Installation configuration file.

Note

The optional `ssl_ciphers = recommended` configuration key restricts the set of SSL ciphers accepted by DSS to a safe subset, for better protection against known attacks, while staying compatible with most recent browsers and DSS-supported Linux platforms.

Setting this key to `default` (or omitting it altogether) does not configure any restriction on the accepted SSL ciphers, which then fall back to the default list built into the nginx server.

Note

You can also expose DSS to users over HTTPS by interposing a [reverse proxy](<reverse-proxy.html>). This option is mandatory if you want to use default HTTPS port 443, as DSS cannot run with the superuser privileges necessary to listen on this port.

Note

If all DSS users access it over HTTPS, you can enforce session cookies security as described in [Advanced security options](<../../security/advanced-options.html>).

## Configuring IPv6 support

By default, DSS listens to IPv4 connections only. Using the following installation configuration directive, you can configure DSS to listen to IPv6 connections to its base port, in addition to IPv4 connections.
    
    
    [server]
    ipv6 = true
    

You should then regenerate DSS configuration and restart DSS, as described in Installation configuration file.

## Configuring log file rotation

### Main DSS processes log files

DSS processes write their log files to directory `DATADIR/run`:

backend.log | Main DSS process (backend)  
---|---  
hproxy.log | Hadoop connectivity process (hproxy, optional)  
nginx.log | HTTP server (nginx)  
ipython.log | Python / R notebook server (ipython)  
supervisord.log | Process control and supervision  
  
By default, these log files are rotated when they reach a given size, and purged after a given number of rotations. The following installation configuration directives can be used to customize this behavior:
    
    
    [logs]
    # Maximum file size, default 100MB.
    # Suffix multipliers "KB", "MB" and "GB" can be used in this value.
    logfiles_maxbytes = SIZE
    # Number of retained files, default 10.
    logfiles_backups = NUMBER_OF_FILES
    

You should then regenerate DSS configuration and restart DSS, as described in Installation configuration file.

### Additional DSS log files

In addition to the main log files described above, DSS generates two additional log files in directory `DATADIR/run`, which are handled differently:

  * `nginx/access.log` : This is the access log for DSS HTTP server. Under normal utilization this file grows only slowly compared to the previous ones. It is not rotated automatically, but can be rotated manually through the standard nginx procedure, or using the manual log file rotation command described below.

  * `frontend.log` : This is a low-level log for debug purposes only. It is rotated independently of the others, on a non-configurable schedule.




### Manual log file rotation

The following command forces DSS to close and reopen its log files (main DSS processes log files and nginx access log). Combined with standard tools like `logrotate(8)`, and the possibility to disable automatic log rotation as described above, this lets you take full control over the DSS log rotation process, and integrate it in your log file handling framework.
    
    
    # Use standard Unix commands to rename DSS current log files
    ...
    # Force DSS to reopen new log files
    DATADIR/bin/dss reopenlogs

---

## [installation/custom/advanced-java-customization]

# Advanced Java runtime configuration

## Java requirements

DSS is a Java application, and requires a compatible Java environment to run. Supported versions are [OpenJDK](<http://openjdk.java.net>), Amazon Corretto and [Oracle JDK](<https://www.oracle.com/technetwork/java/javase/downloads/index.html>), version 17

Unless instructed otherwise (see below) the DSS installer will automatically look for a suitable version of Java in standard locations. If none is found, it will install an appropriate OpenJDK package as part of its dependency installation phase.

Note

Starting with DSS 14, Java 8 and Java 11 are no longer supported.

While the Java Runtime Environment (JRE) is technically sufficient for DSS to run, it is recommended to install the full Java Development Kit (JDK) as this includes additional tools for diagnosing performance and other technical issues. Dataiku support may require you to install the full JDK to investigate some cases.

### Choosing the JVM

You can force Data Science Studio to use a specific version of Java (for example, when there are several versions installed on the server, or when you manually installed Java in a non-standard place) by setting the **JAVA_HOME** environment variable while running the DSS installer script. This variable should point to the installation directory of the Java runtime to use. For example:
    
    
    $ JAVA_HOME=/usr/lib/jvm/java-17-openjdk dataiku-dss-VERSION/installer.sh <INSTALLER_OPTIONS>
    

Note that the installer script stores this value in the file `DSS_DATADIR/bin/env-default.sh` (in variable `DKUJAVABIN`), so this environment variable is only needed at installation time. It must be provided for all subsequent DSS updates however, unless one wishes DSS to revert to the automatically-detected version of Java.

### Switching the JVM

You can switch an existing DSS instance to an different version of Java by rerunning the installer in update mode with a new value for **JAVA_HOME** , as follows:
    
    
    # Stop DSS
    $ DSS_DATADIR/bin/dss stop
    
    # Switch this DSS instance to a different Java runtime
    $ JAVA_HOME=/PATH/TO/NEW/java dataiku-dss-VERSION/installer.sh -d DSS_DATADIR -u
    
    # Restart DSS
    $ DSS_DATADIR/bin/dss start
    

## Customizing Java runtime options

The DSS installer generates a default set of runtime options for the DSS Java processes, based on the Java version in use and the memory size of the hosting server. These options can be customized if needed.

### The different Java processes

DSS is made up of 4 different kinds of Java processes:

  * The “backend” is the main server, which handles all interaction with users, the configuration, and the visual data preparation. There is only one backend.

  * The “jek” is a process which runs the jobs (ie, what happens when you use “Build”). There are multiple jeks (one per running job)

  * The “fek” handles long-running background tasks. It is also responsible for building the data samples. There are multiple feks (one per running background task)

  * The “hproxy” handles interactions with Hive. There is only one hproxy.




For the API node:

  * The “apimain” is the main server.




For the Govern node:

  * The “governserver” is the main server.




### What can be customized

All Java options of these 6 kinds of processes can be customized.

For each of these, DSS provides an easy way to:

  * configure the amount of memory allocated to each process (Java “-Xmx”)

  * add custom options




These customizations can be done by editing the [install.ini](<advanced-customization.html#install-ini>) file.

More advanced customization (taking precedence over default DSS options) can be done via environment files.

### Customizing maximum memory size (xmx)

Most often, you will want to customize the amount of memory (“xmx”) variable, which is the maximum memory allocated to the Java process.

Xmx is configured by setting the `<processtype>.xmx` setting in the `javaopts` section of the install.ini file (where `<processtype>` is one of backend, jek, fek or hproxy).

The installer sets Xmx to a default value between 2 and 6 GB, depending on the memory size of the host. This might not be enough for DSS instances with a large number of users. If that amount of memory is not sufficient, the DSS backend may crash, and all users would get disconnected until it automatically restarts.

#### Example: Set Xmx of backend to 8g

  * Go to the DSS data directory




Note

On macOS, the `DSS_DATADIR` is always: `$HOME/Library/DataScienceStudio/dss_home`

  * Stop DSS

> ./bin/dss stop
>         

  * Edit the install.ini file

  * If it does not exist, add a `[javaopts]` section

  * Add a line: `backend.xmx = 8g`

  * Regenerate the runtime config:

> ./bin/dssadmin regenerate-config
>         

  * Start DSS

> ./bin/dss start
>         




#### Example install.ini

Here is an example of an install.ini file that configures the Xmx for backend and jek:
    
    
    [javaopts]
    backend.xmx = 8g
    jek.xmx = 4g
    

Memory amounts can be suffixed with “m” or “g” for megabytes and gigabytes

### Adding additional Java options

You can add arbitrary options to the DSS Java processes. Use the same procedure as above, with `<processtype>.additional.opts` directives:
    
    
    [javaopts]
    backend.additional.opts = -Dmy.option=value
    

### Advanced customization

The full Java runtime options can be configured by setting environment variables in the `DSS_DATADIR/bin/env-site.sh` file in the Data Science Studio data directory.

Warning

You should only use this section if you could not obtain the desired set of options using the options above.

The default runtime options are stored in several environment variables:

>   * DKU_BACKEND_JAVA_OPTS
> 
>   * DKU_JEK_JAVA_OPTS
> 
>   * DKU_FEK_JAVA_OPTS
> 
>   * DKU_HPROXY_JAVA_OPTS
> 
>   * DKU_APIMAIN_JAVA_OPTS
> 
>   * DKU_GOVERNSERVER_JAVA_OPTS
> 
> 


The default values for these files (computed from `DSS_DATADIR/install.ini`) are stored in `DSS_DATADIR/bin/env-default.sh`.

Warning

Do not modify `DSS_DATADIR/bin/env-default.sh`, it would get overwritten at the next Data Science Studio upgrade and after each call to `./bin/dssadmin regenerate-config` or `./bin/governadmin regenerate-config` for the Govern node

To configure these options:

  * Stop DSS

> ./bin/dss stop
>         

  * Open the `DSS_DATADIR/bin/env-default.sh` file

  * Copy the line you want to change. They look like `export DKU_BACKEND_JAVA_OPTS`, `export DKU_JEK_JAVA_OPTS`, …

  * Open the `DSS_DATADIR/bin/env-site.sh` file

  * Paste the line and modify it to your needs

  * Start DSS

> ./bin/dss start
>         




## Adding SSL certificates to the Java truststore

There are a number of configurations where DSS needs to connect to external resources using secure network connections (SSL / TLS). This includes (but is not limited to):

  * connecting to a secure LDAP server

  * connecting to Hadoop components (Hive, Impala) over SSL-based connections

  * connecting to SQL databases, MongoDB, Cassandra, … over secure connections




In all these cases, the Java runtime used by DSS needs to be able to verify the identity of the remote server, by checking that its certificate is derived from a trusted certification authority. The JVM comes with a default list of well-known Internet-based certification authorities, which normally covers all legitimate publicly-accessible Internet resources. However, resources internal to your organization are typically certified by private certification authorities, or by standalone (self-signed) certificates. It is then necessary to add additional certificates to the trusted list of the JVM used by DSS (a.k.a. truststore).

You should refer to the documentation of your JVM and/or Linux distribution for the precise procedure for this. In most cases, you can use one of the following options:

### Add a local certificate to the global JVM truststore

You will need write access to the Java installation for this (that would be root access for the typical case where the JVM has been installed through a package manager).

  * check which JVM is used by DSS by looking for variable `DKUJAVABIN` in file `DSS_DATADIR/bin/env-default.sh`

  * locate the physical installation directory of this JVM with : `readlink -f /PATH/TO/java`. This should resolve to `JAVA_HOME/bin/java` where `JAVA_HOME` is the installation directory for this JVM.

  * locate the default truststore file, at `JAVA_HOME/lib/security/cacerts`

  * prepare the certificate(s) to add, in one of the supported file formats (binary- or base64-encoded DER, typically named .pem, .cer, .crt, or .der, or PKCS#7 certificate chain, typically named .p7b, or .p7c)

  * import your certificate in the JVM trustore with `keytool` (the certificate store management tool, shipped with the JVM). This command prompts for the trustore password, which by default is `changeit` on Oracle and OpenJDK distributions.
        
        keytool -import [-alias FRIENDLY_NAME] -keystore /PATH/TO/cacerts -file /PATH/TO/CERT_TO_IMPORT
        

You may need to first make this file writable with chmod, if it is write-protected.

You can check that the import was successful by listing the new truststore contents:
        
        keytool -list -keystore /PATH/TO/cacerts
        




You need to restart DSS after this operation.

Warning

This operation may need to be redone after an update of the JVM, or of the global system-wide certificate trust list.

Note

Instead of directly modifying the default trustore at `JAVA_HOME/lib/security/cacerts`, you can duplicate it to a file named `jssecacerts` in the same directory, and update this file instead. When this file exists, it overrides the default one, which lets you preserve the original, distribution-provided version.

For full reference to the management of SSL certificate trust stores, refer to the documentation of your Java runtime. For Oracle JRE, you can refer to:

  * <https://docs.oracle.com/en/java/javase/17/security/java-secure-socket-extension-jsse-reference-guide.html#GUID-7D9F43B8-AABF-4C5B-93E6-3AFB18B66150>

  * <https://docs.oracle.com/en/java/javase/17/tools/keytool.html>




### Add a local certificate to the system-wide certificate trust list

You need to be root for this operation.

Most Unix distributions maintain and distribute a system-wide trusted certificate list, which is in turn used by the various subsystems which need it, including all distribution-installed JVMs. Following distributions-specific procedures to add custom certificates to this list ensures that these additions are not lost upon system or JVM updates, and are available to other subsystems as well (eg command-line tools).

On RedHat-compatible systems, the global trustore is built with `update-ca-trust(8)` as follows (refer to the manpage for details):

  * (as root) add any local certificates to trust in directory `/etc/pki/ca-trust/source/anchors/`

  * (as root) run : `update-ca-trust extract`

  * optionally, check with: `keytool -list -keystore JAVA_HOME/lib/security/cacerts -storepass changeit`




On Debian / Ubuntu systems, the global truststore is built with `update-ca-certificates(8)` as follows (refer to the manpage for details):

  * (as root) add any local certificates to trust in directory `/usr/local/share/ca-certificates` (or a subdirectory of it), as a file with extension “.crt”

  * (as root) run : `update-ca-certificates`

  * optionally, check with: `keytool -list -keystore JAVA_HOME/lib/security/cacerts -storepass changeit`




You need to restart DSS after this operation.

### Run DSS with a private truststore

If you lack administrative access required to update the global truststore (system-wide, or JVM default), you can copy the global trustore to a private location, add your custom certificates to it, and direct DSS to use it instead of the default trustore.

  * Using the same steps as the first solution above, locate the default JVM truststore at `JAVA_HOME/lib/security/cacerts`

  * Copy this file to a private location, for instance $HOME/pki/cacerts, and make it writable

  * Using the same keytool command as the first solution above, add your custom certificates to this private truststore (the default password is again `changeit`)

  * In order to have DSS use it for all Java processes, you need to add command-line option `-Djavax.net.ssl.trustStore=/PATH/TO/PRIVATE/TRUSTSTORE` to all Java processes, using the procedure documented at Adding additional Java options
        
        [javaopts]
        backend.additional.opts = -Djavax.net.ssl.trustStore=/PATH/TO/PRIVATE/TRUSTSTORE
        jek.additional.opts = -Djavax.net.ssl.trustStore=/PATH/TO/PRIVATE/TRUSTSTORE
        fek.additional.opts = -Djavax.net.ssl.trustStore=/PATH/TO/PRIVATE/TRUSTSTORE
        hproxy.additional.opts = -Djavax.net.ssl.trustStore=/PATH/TO/PRIVATE/TRUSTSTORE
        

  * Run `dssadmin regenerate-config` and restart DSS to complete the operation

---

## [installation/custom/api-node]

# Installing an API node

You need to manually install one or several API Nodes:
    

  * If you want to create a static infrastructure in the API Deployer. See [Concepts](<../../apinode/concepts.html>) for more information.

  * If you don’t plan on using API Deployer




If you plan to use Kubernetes-based infrastructures in the API Deployer, you do not need to install any API node. Installation will be fully managed.

The process of installing a DSS API node instance is very similar to a regular DSS installation. [Requirements](<requirements.html>) and [Installing a new DSS instance](<initial-install.html>) thus remain mostly valid.

## Installation

Unpack the kit like for a design node.

Then from the user account which will be used to run the DSS API node, enter the following command:
    
    
    dataiku-dss-VERSION/installer.sh -t api -d DATA_DIR -p PORT -l LICENSE_FILE
    

Where:

  * DATA_DIR is the location of the data directory that you want to use. If the directory already exists, it must be empty.

  * PORT is the base TCP port.

  * LICENSE_FILE is your DSS license file.




In short, all installation steps are the same as for a design node, you simply need to add `-t api` to the `installer.sh` command-line.

Note

Using the API node requires a specific DSS license. Please contact Dataiku for more information.

Dependencies handling, enabling startup at boot time, and starting the API node, work exactly as for the DSS design node.

---

## [installation/custom/automation-node]

# Installing an automation node

You need to manually install an automation node if you plan to deploy projects to automation. See [Production deployments and bundles](<../../deployment/index.html>) for more information.

The process of installing a DSS automation node instance is very similar to a regular DSS installation. [Requirements](<requirements.html>) and [Installing a new DSS instance](<initial-install.html>) thus remain mostly valid.

## Installation

Unpack the kit like for a design node.

Then from the user account which will be used to run the DSS automation node, enter the following command:
    
    
    dataiku-dss-VERSION/installer.sh -t automation -d DATA_DIR -p PORT [-l LICENSE_FILE] [-w true]
    

Where:

  * DATA_DIR is the location of the data directory that you want to use. If the directory already exists, it must be empty.

  * PORT is the base TCP port.

  * LICENSE_FILE is your DSS license file.




In short, all installation steps are the same as for a design node, you simply need to add `-t automation` to the `installer.sh` command-line.

Note

Using the automation node requires a specific DSS license. Please contact Dataiku for more information.

Note

Option `-w true` will install Stories.

Dependencies handling, enabling startup at boot time, and starting the automation node, work exactly as for the DSS design node.

---

## [installation/custom/deployer-node]

# Installing a deployer node

You need to manually install a deployer node if you plan to use the “Remote deployer” mode, either for API or projects. See [Production deployments and bundles](<../../deployment/index.html>) for more information.

The process of installing a DSS deployer node instance is very similar to a regular DSS installation. [Requirements](<requirements.html>) and [Installing a new DSS instance](<initial-install.html>) thus remain mostly valid.

## Installation

Unpack the kit like for a design node.

Then from the user account which will be used to run the DSS deployer node, enter the following command:
    
    
    dataiku-dss-VERSION/installer.sh -t deployer -d DATA_DIR -p PORT -l LICENSE_FILE
    

Where:

  * DATA_DIR is the location of the data directory that you want to use. If the directory already exists, it must be empty.

  * PORT is the base TCP port.

  * LICENSE_FILE is your DSS license file.




In short, all installation steps are the same as for a design node, you simply need to add `-t deployer` to the `installer.sh` command-line.

Note

Using the deployer node requires a specific DSS license. Please contact Dataiku for more information.

Dependencies handling, enabling startup at boot time, and starting the deployer node, work exactly as for the DSS design node.

---

## [installation/custom/govern-node]

# Installing a Govern node

You need to manually install a Govern node if you plan to use Dataiku governance capabilities. See [AI Governance](<../../governance/index.html>) for more information.

The process of installing a Govern instance is very similar to a regular DSS installation, except for the database requirement below. [Requirements](<requirements.html>) and [Installing a new DSS instance](<initial-install.html>) thus remain mostly valid.

## Database requirements

Govern is based on a PostgreSQL 15+ database for the storage of data. We recommend using an up-to-date minor version of PostgreSQL database, which will include the latest fixes. A dedicated database and user need to be created on the PostgreSQL instance for Govern:
    
    
    CREATE USER <govern_user> WITH ENCRYPTED PASSWORD '<govern_pwd>';
    CREATE DATABASE <govern_db> OWNER <govern_user>;
    

Where `<govern_user>`, `<govern_pwd>` and `<govern_db>` are the values of your choice.

Important

We recommend regular PostgreSQL backups. Additionally, always perform a fresh backup before a Govern migration to ensure you can roll back the automatic schema changes if needed.

## Installation

Unpack the kit, just like for a design node.

Then from the user account which will be used to run Dataiku Govern, enter the following command:
    
    
    dataiku-dss-VERSION/installer.sh -t govern -d DATA_DIR -p PORT -l LICENSE_FILE
    

Where:

  * `DATA_DIR` is the location of the data directory that you want to use. If the directory already exists, it must be empty.

  * `PORT` is the base TCP port to be used for Govern.

  * `LICENSE_FILE` is the path to your DSS license file.




In short, all installation steps are the same as for a design node, you simply need to add `-t govern` to the `installer.sh` command-line.

Dependencies handling, enabling startup at boot time, and starting the govern node, work exactly as for the design node.

## Post-installation steps

Before starting Govern, the PostgreSQL database connection needs to be setup in the settings. Edit `DATA_DIR/config/dip.properties` and add the connection setting there:
    
    
    psql.jdbc.url=jdbc:postgresql://<psql_host>:<psql_port>/<govern_db>?currentSchema=<govern_schema>
    psql.jdbc.user=<govern_user>
    psql.jdbc.password=<govern_pwd>
    

Where `<govern_user>`, `<govern_pwd>` and `<govern_db>` should be replaced with the value used previously to create the user and database for Govern.

In case there’s a specific schema to be used for govern, it can be specified with `?currentSchema=<govern_schema>`. This is optional, and this part may be removed from the URL if default schema configured in the database is to be used. `<psql_host>` and `<psql_port>` should point to a running PostgreSQL server.

In order to avoid writing a password in cleartext in the configuration file, encrypt it first using:
    
    
    DATA_DIR/bin/govern-admin encrypt-password <govern_pwd>
    

Use the encrypted password string (starting with `e:AES:`) in the `psql.jdbc.password` field.

Finally, for bootstrapping the initial configuration of govern, issue the following command (only first time after kit installation):
    
    
    DATA_DIR/bin/govern-admin init-db
    

Govern can then be started with the standard command:
    
    
    DATA_DIR/bin/dss start
    

## Connection pool configuration

Important

**PostgreSQL Server Requirement**

Configure the `max_connections` setting of your PostgreSQL server to at least `500`. High `max_connections` have very low cost on PostgreSQL and there is no significant drawback to high `max_connections`. Too low `max_connections` can fully prevent Govern from working. There is no direct correlation between “instance size”, “what jobs do” and required connection count. `500` is sufficient for almost all instances.

### Configuration Steps

Warning

We highly discourage changing any of the following settings without guidance from Dataiku Support.

  1. Stop the Govern instance.

  2. Edit `config/general-settings.json` and find the top-level `"datasourceConnectionSettings"` key.




Fill it out as follows:

> 
>     "datasourceConnectionSettings": {
>         "connectionTimeoutMS": 30000,
>         "minimumIdle": 50,
>         "maximumPoolSize": 50,
>         "idleTimeoutMS": 600000,
>         "maxLifetimeMS": 1800000,
>         "leakDetectionThresholdMS": 1800000
>     }
>     

  3. Save the file, then start the Govern instance.

---

## [installation/custom/graphics-export]

# Setting up DSS item exports to PDF or images

The Flow, Dashboards and Wiki articles can be exported to PDF or image (PNG, JPG) files in order to share a snapshot of the details within your organization more easily. The graphics export feature must be setup before DSS items can be exported.

## Prerequisites

  * The export feature does not work on Centos 6 and AmazonLinux

  * Internet access is required to install additional dependencies required by the export feature

  * The account running DSS needs write access to the DSS installation directory at install time;




## Precautions

The export feature uses an embedded Chrome browser to perform the actual snapshotting. When you install the feature, an up-to-date Chrome browser is downloaded. We recommend that you regularly perform again the install procedure in order to fetch latest updates, which may be required since Chrome regularly releases security updates.

Security updates of the embedded Chrome browser are not the responsibility of Dataiku.

The embedded Chrome browser is in the `resources/graphics-export/node_modules` folder of the DSS installation directory. In case of doubt, you can remove this folder, which will prevent the feature from working.

As of DSS 13.4, this will download and install puppeteer 23.11.1 and its associated headless chromium version (131.0.6778.204) on systems with Node.js is 18+. For systems with older version of Node.js, this will install the last version of puppeteer that is compatible with the installed Node.js.

## Install

  * Go to the DSS data dir

  * Stop DSS

> ./bin/dss stop
>         

  * Run the installation script

> ./bin/dssadmin install-graphics-export
>         

  * If prompted to, run the dependencies installation script as root

  * Start DSS

> ./bin/dss start
>         




Test the feature by going to a dashboard, in view mode, and clicking Actions > Export. Alternatively you can test the feature by going to the Flow of a project and clicking Flow Actions > Export to PDF/Image

If you get an error about sandbox mode, it means that the embedded Chrome browser could not start in the most secure “sandbox” mode

### Option 1: Enable user namespaces

The sandbox mode of Chrome runs using a feature of the Linux kernel known as user process namespaces. This feature is not always enabled, you may need to enable it.

Run the following command:
    
    
    sysctl user.max_user_namespaces
    

If the result is 0, run the following command as root:
    
    
    sysctl user.max_user_namespaces=1000
    

If the result was 0 in the previous step, you will also want to add this entry to your `/etc/sysctl.conf` file so that this setting is retained upon server reboot:
    
    
    # edit your /etc/sysctl.conf file
    sudo vi /etc/sysctl.conf
    
    # add the following entry to the end of the file
    user.max_user_namespaces=1000
    

Then retry exporting the Flow or dashboard

### Option 2: Disable sandbox

If you are not able to run the previous, or if it fails (which may be possible if you have a too old kernel), you can disable the additional sandbox protection. The sandbox is a “second level” of security to mitigate exploitation possibilities in case of a security bug in Chrome.

  * Edit the `config/dip.properties` file

  * Add the following line: `dku.exports.chrome.sandbox=false`

  * Restart DSS

---

## [installation/custom/hadoop-spark]

# Setting up Hadoop and Spark integration

Data Science Studio is able to connect to a Hadoop cluster and to:

  * Read and write HDFS datasets

  * Run Hive queries and scripts

  * Run Impala queries

  * Run preparation recipes on Hadoop




In addition, if you [setup Spark integration](<../../spark/installation.html>), you can:

  * Run SparkSQL queries

  * Run preparation, join, stack and group recipes on Spark

  * Run PySpark & SparkR scripts

  * Train & use Spark MLLib models




See [Setting up Hadoop integration](<../../hadoop/installation.html>) and [Setting up Spark integration](<../../spark/installation.html>)

---

## [installation/custom/index]

# Custom Dataiku install on Linux

Download and install Dataiku DSS on your own Linux server.

---

## [installation/custom/initial-install]

# Installing a new DSS instance

Note

This is the documentation to perform a Custom Dataiku install of a new Dataiku DSS instance on a Linux server

Other installation options are available (Dataiku Cloud Stacks, macOS, Windows, AWS sandbox, Azure sandbox, or Virtual Machine). Please see [Installing and setting up](<../index.html>).

## Pre-requisites

To install Dataiku DSS, you need:

  * the installation tar.gz file

  * to make sure that you meet the installation [Requirements](<requirements.html>).




## Installation folders

A Dataiku DSS installation spans over two folders:

  * The installation directory, which contains the code of Dataiku DSS. This is the directory where the Dataiku DSS tarball is unzipped (denoted as “INSTALL_DIR”)

  * The data directory (which will later be named “DATA_DIR”).




The data directory contains :

  * The configuration of Dataiku DSS, including all user-generated configuration (datasets, recipes, insights, models, …)

  * Log files for the server components

  * Log files of job executions

  * Various caches and temporary files

  * A Python virtual environment dedicated to running the Python components of Dataiku DSS, including any user-installed supplementary packages

  * Dataiku DSS startup and shutdown scripts and command-line tools




Depending on your configuration, the data directory can also contain some managed datasets. Managed datasets can also be created outside of the data directory with some additional configuration.

It is highly recommended that you reserve at least 100 GB of space for the data directory.

The data directory should be entirely contained within a single mount and be a regular folder. Having foreign mounts within the data directory, or symlinking parts of the data directory to foreign mounts is not supported.

## Installation

### Unpack

Unpack the tar.gz in the location you have chosen for the installation directory.
    
    
    cd SOMEDIR
    tar xzf /PATH/TO/dataiku-dss-VERSION.tar.gz
    # This creates a directory named dataiku-dss-VERSION in the current directory
    # which contains DSS code for this version (no user file is written to it by DSS).
    # This directory is referred to as INSTALL_DIR in this document.
    

### Install Dataiku DSS

From the user account which will be used to run Dataiku DSS, enter the following command:
    
    
    dataiku-dss-VERSION/installer.sh -d /path/to/DATA_DIR -p PORT [-l LICENSE_FILE] [-w true]
    

Where:

  * DATA_DIR is the location of the data directory that you want to use. If the directory already exists, it must be empty.

  * PORT is the base TCP port. Dataiku DSS will use several ports between PORT and PORT+10

  * LICENSE_FILE is your Dataiku DSS license file.




Warning

DATA_DIR must be outside of the install dir (i.e. DATA_DIR must not be within dataiku-dss-VERSION)

Note

If you don’t enter a license file at this point, DSS will start as a Free Edition. You can enter a license file at any time.

Note

Option `-w true` will install Stories.

The installer automatically checks for any missing system dependencies. If any is missing, it will give you the command to run to install them with superuser privileges. After installation of dependencies is complete, you can start the Dataiku DSS installer again, using the same command as above.

### (Optional) Enable startup at boot time

At the end of installation, Dataiku DSS will show you the optional command to run with superuser privileges to configure automatic boot-time startup:
    
    
    sudo INSTALL_DIR/scripts/install/install-boot.sh [-n INSTANCE_NAME] DSS_DATADIR DSS_USER
    

This configures a systemd-based system service with a default name of “dataiku” (in `/etc/systemd/system/dataiku.service`), and enables it to automatically start at boot. You can then use standard service management commands to control this DSS instance, as in:
    
    
    # Start the DSS service
    sudo systemctl start dataiku
    # Stop the DSS service
    sudo systemctl stop dataiku
    # Get service status
    sudo systemctl status dataiku
    # Get service log
    sudo journalctl -u dataiku
    # Disable boot-time startup
    sudo systemctl disable dataiku
    

Note

If you have several instances of DSS installed on the same host, and want more than one to automatically start at boot time, you need to provide different, non-default names for them so as to configure independent boot-time system services, as follows:
    
    
    # Defines system service "dataiku.dev" for DSS design instance
    sudo DESIGN_INSTALL_DIR/scripts/install/install-boot.sh -n dev DESIGN_DATA_DIR DESIGN_USER_ACCOUNT
    # Defines system service "dataiku.prod" for DSS automation instance
    sudo AUTOMATION_INSTALL_DIR/scripts/install/install-boot.sh -n prod AUTOMATION_DATA_DIR AUTOMATION_USER_ACCOUNT
    

This system service is implemented by a helper script installed at `/etc/dataiku/INSTANCE_ID/dataiku-boot`, where `INSTANCE_ID` is the unique id of this DSS instance (generated at installation time in `DATA_DIR/install.ini`).

This script has an associated configuration file `dataiku-boot.conf` in the same directory (`/etc/dataiku/INSTANCE_ID/dataiku-boot.conf`). This file can be used to configure the optional creation of resource control cgroups for use by this DSS instance, as described [here](<../../operations/cgroups.html>).

Warning

Versions of Dataiku DSS prior to 13.x were using legacy systemv-based init scripts in `/etc/init.d/dataiku[.NAME]` for boot-time startup.

In order to migrate an instance to the new systemd-based setup, you need to first remove its legacy startup script if any.

Note that any customization for the legacy script (in `/etc/default/dataiku` or `/etc/sysconfig/dataiku`) would have to be reinstalled in the new service configuration file at `/etc/dataiku/INSTANCE_ID/dataiku-boot.conf`.

Note also that service configuration keys have been renamed from `DIP_xxx` (legacy syntax) to `DSS_xxx` (new syntax).

### Start Dataiku DSS

To directly start Dataiku DSS, run the following command:
    
    
    DATA_DIR/bin/dss start
    

To start the Dataiku DSS system service, run the following command:
    
    
    # Default DSS service
    sudo systemctl start dataiku
    
    # Named DSS service
    sudo systemctl start dataiku.INSTANCE_NAME
    

Warning

Do not mix manual- and system-service-based startup and shutdown. A DSS instance started through systemctl (or at boot) should only be stopped or restarted through systemctl, so the operating system service manager can correctly keep track of the Dataiku DSS service status.

## Complete installation example

The following shows a transcript from a complete installation sequence:
    
    
    # Start from the home directory of user account "dataiku"
    # which will be used to run the Dataiku DSS
    # We will install DSS using data directory: /home/dataiku/dss_data
    $ pwd
    /home/dataiku
    $ ls -l
    -rw-rw-r-- 1 dataiku dataiku 159284660 Feb  4 15:20 dataiku-dss-VERSION.tar.gz
    -r-------- 1 dataiku dataiku       786 Jan 31 07:42 license.json
    
    # Unpack the distribution kit
    $ tar xzf dataiku-dss-VERSION.tar.gz
    
    # If the User Isolation Framework is to be configured on this instance,
    # make sure all user accounts have read-execute permission to the installation directory
    $ chmod a+x .
    $ umask 22
    
    # Run installer, with data directory $HOME/dss_data and base port 10000
    # This fails because of missing system dependencies
    $ dataiku-dss-VERSION/installer.sh -d /home/dataiku/dss_data -l /home/dataiku/license.json -p 10000
    
    # Install dependencies with elevated privileges, using the command shown by the previous step
    $ sudo -i "/home/dataiku/dataiku-dss-VERSION/scripts/install/install-deps.sh"
    
    # Rerun installer script, which will succeed this time
    $ dataiku-dss-VERSION/installer.sh -d /home/dataiku/dss_data -l /home/dataiku/license.json -p 10000
    
    # Manually start DSS, using the command shown by the installer step
    $ /home/dataiku/dss_data/bin/dss start
    
    # Connect to Dataiku DSS by opening the following URL in a web browser:
    #    http://HOSTNAME:10000
    # Initial credentials : username = "admin" / password = "admin"
    
    # [Optional] To finalize the installation, restart as a system-managed service:
    #
    # Stop the manually-started instance
    $ /home/dataiku/dss_data/bin/dss stop
    #
    # Create a system service, using the command shown by the previous step
    $ sudo "/home/dataiku/dataiku-dss-VERSION/scripts/install/install-boot.sh" "/home/dataiku/dss_data" dataiku
    #
    # Start the system service
    $ sudo systemctl start dataiku
    

## Manual dependency installation

The Dataiku DSS installer includes a dependency management script, to be run with superuser privileges, which automatically installs the additional Linux packages required for your particular configuration.

In some cases however, it might be necessary to manually install these dependencies, for instance when the person installing DSS does not have access to administrative privileges, or when the server does not have access to the required package repositories.

You can check for missing packages by running the dependency installer script with option `-check`. This does not require superuser privileges:
    
    
    $ dataiku-dss-VERSION/scripts/install/install-deps.sh -check [-with-r]
    

If you manually pre-installed all the dependencies that would have been selected by the automated script, you can continue installing Dataiku DSS using standard procedures. If that is not the case (because you explicitly chose to leave a component missing, or you installed some component from an alternate source) you must then run the DSS installer with the “-n” flag, to disable the default dependency checks.
    
    
    # Python 3 has been installed from a custom source instead of the standard system RPM
    # Force the DSS installer to run without checking for missing dependencies (option "-n")
    $ dataiku-dss-VERSION/installer.sh -n -d /home/dataiku/dss_data -l /home/dataiku/license.json -p 10000
    

### RHEL-compatible distributions

You may need to configure the EPEL additional repository, for R support (and for nginx, on version 7.x systems).

You may need to enable the “CodeReady”, “PowerTools” or “Optional” repositories, for indirect dependencies required by R.

Dataiku DSS depends on the following packages:

Name | Notes  
---|---  
acl | For User Isolation Framework support  
expat git nginx unzip zip | Mandatory  
java-17-openjdk-headless | See “Java” note below  
python3 _or_ python39 _or_ python3.10 _or_ python3.11 | For built-in Python packages. See “Python” note below  
freetype libgfortran libgomp | Built-in Python packages dependencies  
policycoreutils policycoreutils-python-utils | For SELinux support  
R-core-devel libicu-devel libcurl-devel openssl-devel libxml2-devel | For R support. See “R” note below  
fontconfig dejavu-sans-fonts | For font support  
glibc-langpack-en | For localization support  
procps-ng | For process management tools  
  
### Debian / Ubuntu Linux distributions

You may need to configure the CRAN repository, for R support (<https://cran.r-project.org/>).

Dataiku DSS depends on the following packages:

Name | Notes  
---|---  
acl | For User Isolation Framework support  
curl git libexpat1 nginx unzip zip | Mandatory  
openjdk-17-jre-headless | See “Java” note below  
python3.9 _or_ python3.10 _or_ python3.11 | For built-in Python packages. See “Python” note below  
python3-distutils libfreetype6 libgomp1 | Built-in Python packages dependencies  
r-base-dev libicu-dev libcurl4-openssl-dev libssl-dev libxml2-dev pkg-config | For R support. See “R” note below  
fontconfig fonts-dejavu | For font support  
locales | For localization support  
procps | For process management tools  
  
### Amazon Linux distributions

On Amazon Linux 2, you may need to enable “extra” repositories for nginx and Java 17, and EPEL for R support.

Dataiku DSS depends on the following packages:

Name | Notes  
---|---  
acl | For User Isolation Framework support  
expat git nginx unzip zip | Mandatory  
java-17-amazon-corretto-headless | See “Java” note below  
python3 | For built-in Python packages. See “Python” note below  
libgomp | Built-in Python packages dependencies  
freetype compat-gcc-48-libgfortran | [Amazon Linux 2] Built-in Python packages dependencies  
R-core-devel libicu-devel libcurl-devel openssl-devel libxml2-devel | For R support. See “R” note below  
glibc-langpack-en | For localization support  
dejavu-sans-fonts fontconfig | For font support  
procps-ng | For process management tools  
  
### SUSE Linux Enterprise Server distributions

You may need to configure the following additional repositories:

Name | Address | Notes  
---|---|---  
nginx | <https://nginx.org/> | [SLES 12.x] For nginx  
R | obs://devel:languages:R:patched/<SLES_VERSION> | For R support  
  
Dataiku DSS depends on the following packages:

Name | Notes  
---|---  
acl | For User Isolation Framework support  
git-core libexpat1 nginx unzip zip gawk | Mandatory  
java-17-openjdk-headless | See “Java” note below  
python3 _or_ python39 _or_ python310 _or_ python311 | For built-in Python packages. See “Python” note below  
libfreetype6 libgomp1 | Built-in Python packages dependencies  
libgfortran3 | [SLES 12.x] Built-in Python packages dependencies  
gcc-fortran R-core-devel libicu-devel libcurl-devel libopenssl-devel libxml2-devel | For R support. See “R” note below  
Base development tools | For R support.  
dejavu-fonts fontconfig | For font support  
procps | For process management tools  
  
### Additional notes

Java
    

DSS supports Java 17.

The suggested dependency package is the platform default, but DSS can use other Java runtime environments. The Java version to use can be specified with the JAVA_HOME environment variable when running the DSS installer.

See [Advanced Java runtime configuration](<advanced-java-customization.html>) for details.

Python
    

DSS supports Python 3.9, 3.10 and 3.11 for its built-in environment.

One of these versions must be installed on the host, and can be chosen with the `-P PYTHONBIN` option to the installer.

Additional Python versions may be used for code environments.

Additional python packages
    

Installing additional Python packages which include native code may require the system development tools to be installed (typically C/C++ compilers and headers), in addition to any package-specific system dependency.

R
    

DSS requires R 4.x

The dependencies listed above as well as the system development tools are necessary to enable the initial R integration in DSS. Additional dependencies are usually needed in order to build additional R packages.

---

## [installation/custom/jdbc]

# Installing database drivers

Before being able to create SQL-based datasets, you need to install the proper JDBC drivers for the database that you intend to connect to.

Additionally, PostgreSQL script recipe support requires the command-line psql client to be installed. See PostgreSQL support.

## Download the driver

Data Science Studio comes with bundled drivers for :

  * PostgreSQL

  * Pivotal Greenplum

  * Amazon Redshift

  * SQlite




Drivers for other databases must be downloaded from your database vendor.

Database Drivers Database | Website | Download link  
---|---|---  
MySQL | <http://dev.mysql.com/downloads/connector/j/> | <https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-8.4.0.tar.gz>  
Vertica | <https://my.vertica.com/download-community-edition/> | Requires a My Vertica account  
Oracle | <http://www.oracle.com/technetwork/database/features/jdbc/index-091264.html> |   
SQL Server | <https://msdn.microsoft.com/en-us/data/aa937724.aspx> | <https://learn.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server>  
BigQuery | See note below |   
  
To install BigQuery driver, please follow the instructions listed in [connecting to BigQuery](<../../connecting/bigquery.html>)

## Stop Data Science Studio

In this page, DATA_DIR refers to the data directory where you installed Data Science Studio.

Note

On macOS, the DATA_DIR is always: $HOME/Library/DataScienceStudio/dss_home

Installation of JDBC drivers must be done while Data Science Studio is stopped.
    
    
    DATA_DIR/bin/dss stop
    

## Copy the driver

Copy the driver’s JAR file (and its dependencies, if any) to the DATA_DIR/lib/jdbc folder

## Restart Data Science Studio
    
    
    DATA_DIR/bin/dss start
    

## PostgreSQL support

Data Science Studio supports datasets stored in PostgreSQL 9 and above.

Warning

PostgreSQL version 8 is not supported.

PostgreSQL script recipe support additionally requires the command-line psql client to be available in the search PATH of the Studio Linux account.

You should install a command-line client compatible with your version of the server. Depending on your Linux distribution, the appropriate client may be available in a standard OS package named “postgresql-client” (Debian / Ubuntu) or “postgresql” (RedHat / CentOS / AlmaLinux). If that is not the case, you can install the correct client for your server and OS by configuring an extra package repository as described at <http://www.postgresql.org/download/> .

---

## [installation/custom/migrations]

# Migration operations

## Migrating the base port

It is possible to change the base port of an existing Data Science Studio instance, by editing the [installation configuration file](<advanced-customization.html#install-ini>):

  * Stop DSS
        
        DATADIR/bin/dss stop
        

  * Edit the `DATADIR/install.ini` installation configuration file
        
        [server]
        port = NEW_BASE_PORT
        

  * Regenerate DSS configuration
        
        DATADIR/bin/dssadmin regenerate-config
        

  * Restart DSS
        
        DATADIR/bin/dss start
        




## Migrating the installation directory

It is possible to change the installation directory of an existing Data Science Studio instance, by replaying the installer in “upgrade” mode:

  * Stop DSS
        
        DATADIR/bin/dss stop
        

  * Move the installed kit to its new location (or unpack the .tar.gz distribution archive to a new location)
        
        mv OLD_DIR/dataiku-dss-VERSION NEW_DIR/
        # or
        cd NEW_DIR
        tar xf /PATH/TO/dataiku-dss-VERSION.tar.gz
        

  * Run the installer in upgrade mode
        
        NEW_DIR/dataiku-dss-VERSION/installer.sh -d DATA_DIR -u
        

  * If you have configured DSS with [User Isolation Framework](<../../user-isolation/index.html>), run the impersonation installation step as `root` from `DATADIR`
        
        ./bin/dssadmin install-impersonation DSSUSER
        

  * Restart DSS
        
        DATADIR/bin/dss start
        




## Migrating the data directory

It is possible to change the path of the data directory of an existing Data Science Studio instance, by replaying the installer in “upgrade” mode. Note that the Python virtual environment has to be rebuilt after migration. This is because Python virtual environments embed their installation path in various places.

  * Stop DSS
        
        DATADIR/bin/dss stop
        

  * Save the list of locally-installed Python packages
        
        DATADIR/bin/pip freeze -l >local-python-packages.txt
        

  * Move the data directory to its new location
        
        mv DATADIR NEWDATADIR
        

  * Remove the Python virtualenv, keeping a backup copy
        
        mv NEWDATADIR/pyenv NEWDATADIR/pyenv.backup
        

  * Run the installer in upgrade mode. This recreates the Python virtualenv
        
        dataiku-dss-VERSION/installer.sh -d NEWDATADIR -u
        

  * Reinstall locally-installed Python packages (if any)
        
        NEWDATADIR/bin/pip install -r local-python-packages.txt
        

  * If you have configured DSS with [User Isolation Framework](<../../user-isolation/index.html>):

>     * As `root`, edit the file `/etc/dataiku-security/INSTALL_ID/security/security-config.ini` to update, in section `dirs`, the path under `dss_data_dir`. For information on finding INSTALL_ID, see [Initial Setup](<../../user-isolation/initial-setup.html>).
> 
>     * Still as `root`, update the paths in sudoers file `/etc/sudoers.d/dataiku-dss-<dss_user>-<dss_instance_id>` to point to `NEWDATADIR`
> 
>     * Still as `root`, either:
> 
>       * Run `NEWDATADIR/bin/dssadmin install-impersonation DSSUSER` to update `NEWDATADIR/security/execwrapper.sh`
> 
>       * Or, edit `NEWDATADIR/security/execwrapper.sh` and update the path to `CONFIGDIR` to point to `NEWDATADIR`

  * Restart DSS
        
        NEWDATADIR/bin/dss start
        

  * If you have configured DSS to [start automatically on server boot](<initial-install.html#boot-startup>):

    * Re-run the `install-boot.sh` command (as root), or

    * Directly adjust the data directory path in the service configuration file, which you can locate with: `ls -l /etc/default/dataiku* /etc/sysconfig/dataiku*`

  * When everything is considered stable, remove the backup
        
        rm -rf NEWDATADIR/pyenv.backup
        




Note

If you could not save the list of locally-installed Python packages before migration (step 2 above), it is possible to reconstitute it by looking at the package installation directory:
    
    
    ls -l NEWDATADIR/pyenv.backup/lib/python?.?/site-packages
    

## Migrating DSS to start with a new user

To switch the user that runs DSS or to switch DSS to run with a service account, you will perform a migration operation. In this section:

>   * `olddssuser` is the original UNIX user which runs the DSS software
> 
>   * `newdssuser` is the new UNIX user to run the DSS software
> 
> 


Before you start, make sure you have a [backup](<../../operations/backups.html>) of your data directory. If you don’t have one, create one now.

  * As the user `olddssuser`, stop DSS:
        
        DATADIR/bin/dss stop
        

  * Update the ownership of your install directory and data directory so that the new UNIX user `newdssuser` has proper access/permissions:
        
        sudo chown -Rh NEW_USER:NEW_GROUP INSTALLDIR DATADIR
        

  * As the new `newdssuser`, re-run installer in upgrade mode:
        
        INSTALLDIR/installer.sh -d DATADIR -u
        

  * If you have UIF configured in your environment, re-run the [install-impersonation script](<../../user-isolation/initial-setup.html>) as root, to point to the new `newdssuser`:
        
        ./DATADIR/bin/dssadmin install-impersonation newdssuser
        

  * As the new `newdssuser` unix user, restart DSS:
        
        DATADIR/bin/dss start
        

  * If you have a boot-up script installed, set start on boot to the new `newdssuser`. Note that INSTALLDIR and DATADIR must be referenced by their full paths:
        
        sudo -i INSTALLDIR/scripts/install/install-boot.sh DATADIR newdssuser

---

## [installation/custom/python]

# Python integration

DSS comes with native Python integration, and the ability to create multiple isolated Python environments, through code envs. See [Code environments](<../../code-envs/index.html>) for more details.

The DSS installation phase creates an initial “builtin” Python environment, which is used to run all Python-based internal DSS operations, and is also used as a default environment to run user-provided Python code. This builtin Python environment comes with a default set of packages, suitable for this version of DSS. These are setup by the DSS installer and updated accordingly on DSS upgrades. This builtin environment is not controllable nor configurable by users.

DSS supports Python 3.9, 3.10 and 3.11 for its builtin Python environment. Depending on the OS used, a suitable Python version is automatically selected for the Python environment. If required, this version can be controlled with the optional `-P PYTHONBIN` option to the DSS installer.

## Rebuilding the builtin Python environment

Warning

This procedure should only be performed under instructions from Dataiku Support

It is possible to rebuild the builtin Python virtual environment, if necessary. This is the case if you moved or renamed DSS’s data directory, as Python virtual environments embed their full directory name. This may be also be the case if you want to reset the virtualenv to a pristine state following accidental installation / deinstallation of additional packages.
    
    
    # Stop DSS
    DATA_DIR/bin/dss stop
    
    # Remove the builtin virtual environment, keeping backup
    mv DATA_DIR/pyenv DATA_DIR/pyenv.backup
    
    # Reinstall DSS (upgrade mode), using the default Python version for this platform
    # This recreates the builtin env in DATA_DIR/pyenv
    dataiku-dss-VERSION/installer.sh -d DATA_DIR -u
    
    # Reinstall DSS (upgrade mode), choosing the underlying base Python to use
    dataiku-dss-VERSION/installer.sh -d DATA_DIR -u -P /usr/local/bin/python3.9
    
    # Restart DSS
    DATA_DIR/bin/dss start
    
    # When everything is considered stable, remove the backup
    rm -rf DATA_DIR/pyenv.backup

---

## [installation/custom/r]

# R integration

Due to the large number of additional system dependencies, DSS R integration is not installed by default.

You can install R integration at any time.

## Prerequisites

DSS requires R version 4.

Warning

While DSS still supports R 3.6, it is legacy and strongly discouraged.

For R version 3.6, DSS only supports up to snapshot `2024-06-10`. You can use the CRAN repository `https://packagemanager.posit.co/cran/2024-06-10` to freeze package versions when running the R integration script or in administration settings for code environments.

Only a single version of R can be used.

Note

On some platforms (notably, at the time of writing, SLES 15 systems) the version of R available through the system package manager may not be compatible with DSS.

In that case, automatic installation of R itself by the DSS installer is not possible, and integrating DSS with R requires manually installing a compatible version of R.

On macOS, you must first install R from <http://www.r-project.org/>. Note that you might need to also install XQuartz.

On Dataiku Cloud, to install R you only need to activate the R integration in the Extension tab of the Launchpad.

## Case 1: Automatic installation, if your DSS server has Internet access

This procedure installs the required R packages and configures R integration for DSS. It prompts you to install any missing dependency as root if needed. Internet access (direct or through a proxy) may be needed to download missing packages.

  * Go to the DSS data dir
        
        cd DATADIR
        

  * Stop DSS
        
        ./bin/dss stop
        

  * Run the installation script
        
        ./bin/dssadmin install-R-integration
        




Note

The install-R-integration script automatically checks for any missing system dependencies. If any is missing, it will give you the command to run to install them with superuser privileges. After the installation of dependencies is complete, you can retry the install-R-integration script

  * Start DSS
        
        ./bin/dss start
        




Note

The above procedure downloads missing R packages from a default Internet-based repository using the HTTPS protocol. If required, you can switch to another repository ([CRAN mirror](<https://cran.r-project.org/mirrors.html>)) by specifying option `-repo REPO_URL`, as in:
    
    
    ./bin/dssadmin install-R-integration -repo http://cran.univ-paris1.fr
    

Note

If the DSS server has Internet access only through a web proxy, you can configure it using the standard `http_proxy` and/or `https_proxy` environment variables, as follows:
    
    
    export http_proxy=http://PROXY_HOST:PROXY_PORT
    export https_proxy=http://PROXY_HOST:PROXY_PORT
    ./bin/dssadmin install-R-integration
    

## Case 2: If your DSS server does not have Internet access

To help with R package installation when the DSS server does not have Internet access (directly nor through a proxy), the DSS installation kit includes a standalone script which may be used to download the required set of R package sources on a third-party Internet-connected system, and store them to a directory suitable for offline installation on the DSS server.

  * Check for missing system dependencies on the DSS server, including the base R system, the development tools, and libraries required by the mandatory R packages. If any dependency is missing, you will need to install it from a local package repository for your OS distribution.
        
        dataiku-dss-VERSION/scripts/install/install-deps.sh -check -without-java -without-python -with-r
        

  * Retrieve the standalone download script `dataiku-dss-VERSION/scripts/install/download-R-packages.sh` and transport it to the system which you will use for download. This system should run Linux or macOS, should have R installed, and should have Internet connection, directly or through a proxy.

  * On this download system, run the download script as follows:
        
        ./download-R-packages.sh -dir DIR
        

where `DIR` is a temporary directory which will hold the downloaded packages.

  * Transport the resulting directory `DIR` to the DSS server.

  * On the DSS server, install any missing R packages from this download directory, and finish configuring DSS R integration:
        
        DATADIR/bin/dssadmin install-R-integration -pkgDir DIR
        

  * Restart DSS
        
        DATADIR/bin/dss restart
        




Note

The `download-R-packages.sh` can be run with additional command-line arguments naming R packages. It will then download these packages along with their dependencies in addition to the mandatory set of packages required by DSS.

This can be used to install additional R packages to DSS on a server without Internet access, by running `DATADIR/bin/R` and calling `install.packages(PACKAGE_NAME, repos = "file://PATH_TO_PKGDIR_DIRECTORY")`

## Case 3: Custom installation

Installing DSS R integration consists in the following steps, which you can perform in any way suitable to your environment:

  * Install R on the DSS server (version 3.6 or version 4)

Data Science Studio references it by looking up “R” in the PATH. If needed, you can override this by defining environment variable `DKURBIN` in the local customization file `DATADIR/bin/env-site.sh`.

  * Install the following R packages, either in the global R library, or in the user library of the DSS user account:

Packages | Repository  
---|---  
httr RJSONIO dplyr curl IRkernel sparklyr ggplot2 gtools tidyr rmarkdown base64enc filelock | CRAN (<https://cran.r-project.org>)  
  * Configure DSS R integration, with the option which omits the default dependency check, and restart DSS
        
        cd DATADIR
        ./bin/dssadmin install-R-integration -noDeps
        ./bin/dss restart
        




## Troubleshooting

### Rebuilding the R environment

In case a system upgrade of the DSS host installed a new version of R (for example: R 3.4.x to R 3.5.x), DSS-installed R packages may become incompatible and stop working properly.

You should then force a full rebuild of all R environments, as follows:

#### Rebuilding the default R environment

  * Rename the `DATADIR/R.lib` directory into `DATADIR/R.lib.BAK`

  * Replay the `dssadmin install-R-integration` command using one of the methods above, to reinstall all required R packages from scratch

  * Optionally, check the `DATADIR/R.lib.BAK` directory for additional packages which you would have manually installed, and reinstall those as well

  * Restart DSS

  * Once R has been checked to work correctly, remove the backup directory.




#### Rebuilding managed R code environments

You should force a full rebuild of all R-based managed code environments by navigating to the Administration / Code Envs page, opening each R environment, selecting “Rebuild env” and clicking “UPDATE”.

Warning

If any R packages were manually installed in the default R library (typically, by calling “install.packages()” from a R session run by the root account), they may need to be reinstalled as well.

### macOS

Some R versions (notably the one coming through Homebrew) are configured to use source packages by default rather than binary packages. If you leave this option, automatic installation may fail as you need the development tools installed, and quite a number of additional libraries.

If you get a compilation error when installing one of the missing packages while running install-R-integration, you may try to manually install the binary version of this package instead. At the R prompt:
    
    
    options(pkgType="both")
    install.packages("PACKAGE_NAME", repos = "http://cloud.r-project.org/")
    

Then run the install-R-integration command again.

---

## [installation/custom/requirements]

# Requirements

## Server

DSS must be installed on a Linux x86-64 server.

### Linux distributions

The following Linux distributions are fully supported, in 64-bit version only:

  * Red Hat Enterprise Linux, version 8.10

  * Red Hat Enterprise Linux, versions 9.x

  * AlmaLinux, version 8.10

  * AlmaLinux, versions 9.x

  * Rocky Linux, version 8.10

  * Rocky Linux, versions 9.x

  * Oracle Linux, version 8.10

  * Oracle Linux, versions 9.x

  * Ubuntu Server, versions 20.04 LTS and 22.04 LTS

  * Debian, versions 11 and 12

  * Amazon Linux 2023

  * SUSE Linux Enterprise Server 15 SP5, SP6 and SP7




These distributions should be up-to-date with respect to Linux patches and updates.

Support for the following Linux distributions is deprecated and will be removed in a future release:

  * Amazon Linux 2




### CPU

There are no specific CPU requirements. More cores will be required to maintain performance with larger DSS instances, or with more workloads.

### RAM

A minimum of 32 GB of RAM is required. More RAM will be required if you intend to load large datasets in memory (for example in the Jupyter notebook component), or for accomodating more users.

### Disks

It is highly recommended to run DSS on SSD drives.

While legacy rotational hard drives can be used, performance will be severely impacted, especially for larger instances, with many users. In these instances, rotational hard drives may lead to a non-workable experience.

### Filesystem

**We strongly recommend only using XFS or ext4 as the filesystem on which DSS is installedd**

The filesystem on which DSS is installed must be POSIX compliant, case-sensitive, support POSIX file locks, POSIX ACLs and symbolic links.

Warning

**Do NOT** install Dataiku DSS on a NFS filesystem (v3 or v4). This is known not to work, and will cause failures, hangs, and possible corruptions. This includes Amazon EFS.

GlusterFS is known to cause instabilities and is not supported as the filesystem for installing DSS

Dataiku makes no particular recommendation as to the underlying block device. In particular, Dataiku does not have experience working with DRDB as the underlying block device and cannot provide recommendations about it.

### System settings

  * The hard limit on the maximum number of open files for the Unix user account running DSS must be at least 65536 (`ulimit -Hn`). For very large DSS instances, larger values may be required.

  * The hard limit on the maximum number of user processes for the Unix user account running DSS must be at least 65536 (`ulimit -Hu`). For very large DSS instances, larger values may be required.

  * The en_US.utf8 locale must be installed.

  * Root access is not strictly required, but you might need it to install dependencies. If you want to start DSS at machine boot time, or use the [User Isolation Framework](<../../user-isolation/index.html>), root access is required.

  * It is highly recommended to create an UNIX user dedicated to running the DSS. Running DSS as root is not supported.

  * DSS has experimental support for running on Redhat 8 with FIPS-140-2 mode enabled. Please reach out to your Dataiku Customer Success Manager to learn more.




### Networking

DSS may use up to 10 consecutive TCP ports. Only the first of these ports needs to be opened out of the machine. It is highly recommended to firewall the other ports.

## Browser support

Dataiku DSS is accessed over a Web browser.

The following browsers are supported:

  * Google Chrome (latest version)

  * Mozilla Firefox (latest ESR version)

  * Microsoft Edge (latest version)




Warning

Proxy support

DSS makes use of WebSockets technology. If a proxy is used between the user’s browser and the DSS server, the proxy must support WebSockets. In case of doubt, it is recommended not to use any proxy between the browser and the DSS server.

---

## [installation/custom/reverse-proxy]

# Using reverse proxies

If you want to expose DSS to your users on a different host and/or port than its native installation, you need
    

to configure a reverse proxy in front of DSS. This is the case in particular if you want to expose DSS on the standard HTTP/80 or HTTPS/443 ports, as DSS should not run with superuser privileges.

The following configuration snippets can be adapted to forward Data Science Studio interface through an external nginx or Apache web server, to accomodate deployments where users should access it through a different base URL than that of its native host and port installation (for example to expose Data Science Studio on the standard HTTP port 80, or on a different host name).

Warning

Data Science Studio does not currently support being remapped to a base URL with a non-empty path prefix (that is, to `http://HOST:PORT/PREFIX/` where `PREFIX` is not empty).

## HTTP deployment behind a nginx reverse proxy
    
    
    # nginx reverse proxy configuration for Dataiku Data Science Studio
    # requires nginx version 1.4 or above
    server {
        # Host/port on which to expose Data Science Studio to users
        listen 80;
        server_name dss.example.com;
        location / {
            # Base url of the Data Science Studio installation
            proxy_pass http://DSS_HOST:DSS_PORT/;
            proxy_redirect off;
            # Allow long queries
            proxy_read_timeout 3600;
            proxy_send_timeout 600;
            # Allow large uploads
            client_max_body_size 0;
            # Allow large downloads
            proxy_max_temp_file_size 0;
            # Allow protocol upgrade to websocket
            proxy_http_version 1.1;
            proxy_set_header Host $http_host;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
    

## HTTPS deployment behind a nginx reverse proxy

DSS can also be accessed using secure HTTPS connections, provided you have a valid certificate for the host name on which it should be visible (some browsers do not accept secure WebSocket connections using untrusted certificates).

You can configure this by deploying a nginx reverse proxy server, on the same or another host than Data Science Studio, using a variant of the following configuration snippet:
    
    
    # nginx SSL reverse proxy configuration for Dataiku Data Science Studio
    # requires nginx version 1.4 or above
    server {
        # Host/port on which to expose Data Science Studio to users
        listen 443 ssl;
        server_name dss.example.com;
        ssl_certificate /etc/nginx/ssl/dss_server_cert.pem;
        ssl_certificate_key /etc/nginx/ssl/dss_server.key;
        location / {
            # Base url of the Data Science Studio installation
            proxy_pass http://DSS_HOST:DSS_PORT/;
            proxy_redirect http://$proxy_host https://$host;
            proxy_redirect http://$host https://$host;
            # Allow long queries
            proxy_read_timeout 3600;
            proxy_send_timeout 600;
            # Allow large uploads
            client_max_body_size 0;
            # Allow large downloads
            proxy_max_temp_file_size 0;
            # Allow protocol upgrade to websocket
            proxy_http_version 1.1;
            proxy_set_header Host $http_host;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
    

Note

If all DSS users access it over HTTPS, you can enforce session cookies security as described in [Advanced security options](<../../security/advanced-options.html>).

## HTTP deployment behind an Apache reverse proxy

The following configuration snippet can be used to forward DSS through an Apache HTTP server:
    
    
    # Apache reverse proxy configuration for Dataiku Data Science Studio
    # requires Apache version 2.4.5 or above
    LoadModule proxy_module modules/mod_proxy.so
    LoadModule proxy_http_module modules/mod_proxy_http.so
    LoadModule proxy_wstunnel_module modules/mod_proxy_wstunnel.so
    LoadModule rewrite_module modules/mod_rewrite.so
    
    <VirtualHost *:80>
        ServerName dss.example.com
        RewriteEngine On
        RewriteCond %{HTTP:Connection} Upgrade [NC]
        RewriteCond %{HTTP:Upgrade} WebSocket [NC]
        RewriteRule /(.*) ws://DSS_HOST:DSS_PORT/$1 [P]
        RewriteRule /(.*) http://DSS_HOST:DSS_PORT/$1 [P]
        ProxyPassReverse / http://DSS_HOST:DSS_PORT/
        ProxyPreserveHost on
        ProxyTimeout 3600
    </VirtualHost>

---

## [installation/custom/upgrade]

# Upgrading a DSS instance

Note

On macOS, upgrade your instance by following the instructions on <https://www.dataiku.com/product/get-started/mac/>, and install directly over the existing application. It’s still a good idea to make a backup of the data directory first.

In the rest of this procedure, DATA_DIR denotes the location of the DSS Data directory.

## Notes and limitations

For each version of DSS, we publish [Release notes](<../../release_notes/index.html>), which indicate the detailed limitations, attention points and notes about release. We strongly advise that you read all release notes for the new DSS version before starting the upgrade.

Notably, some machine learning models often need to be retrained when upgrading between major DSS upgrades.

## Ways to upgrade a DSS instance

### Upgrading an instance in-place

This documentation explains how to upgrade a single DSS instance. After the upgrade completes, it is not possible to rollback the upgrade. We therefore strongly advise that you take a backup of the whole DATA_DIR prior to starting the upgrade procedure

### Upgrading by project import/export

Some people perform upgrades by:

  * Creating a new DSS instance

  * Exporting projects from the old instance

  * Importing the projects into the new instance

  * Then only shutting down the old DSS instance




We _do not_ recommend that you use this approach for the following reasons:

  * It is much slower and requires much more operations than an instance clone

  * While a project export carries all important parts of the projects, some things are NOT part of a project export and will be lost. This includes files written from Jupyter notebooks, SQL notebooks results, and the whole “state” of the Flow. In other words, all incremental computation state will be lost and all datasets / partitions will need to be recomputed.




If you want to keep the original instance up and running while trying the migration, please see the following procedure.

### Upgrading by cloning the instance

Some people prefer to keep an old instance running and to clone it to a new DSS instance that will be upgraded to the new version.

This requires a few additional migration operations and care:

  * If you are going to run it on the same machine, keep in mind that each instance needs its own block of 10 consecutive TCP ports. Thus, the new instance needs to be installed on a different port range

  * Changing the `installid` flag of the new instance is recommended to avoid conflicts.

  * The new instance will run all scenarios just like the old one. This could lead to corrupted data

  * If Graphite reporting is enabled, you need to change the prefix for the new instance in order not to corrupt the metrics.




We recommend that you get in touch with your Dataiku Customer Success Manager before such a procedure.

In any case, the path would be “duplicate the instance, migrate ports and DATA_DIR, upgrade the new instance” (copying DATA_DIR between DSS instances of distinct versions is not supported).

## Pre-upgrade tasks

Warning

Before upgrading, it is very highly recommended to backup the whole content of the data directory.

Stop the old version of DSS
    
    
    DATA_DIR/bin/dss stop
    

## Unpack the new software

Unpack the distribution tarball in the location you have chosen for the new installation directory.
    
    
    cd SOMEDIR
    tar xzf /PATH/TO/dataiku-dss-NEWVERSION.tar.gz
    # This creates installation directory SOMEDIR/dataiku-dss-NEWVERSION for the new version
    

## Perform the upgrade
    
    
    dataiku-dss-NEWVERSION/installer.sh -d DATA_DIR -u
    

Like for normal install, DSS will check for missing system dependencies, and ask you to run a dependencies installation command with superuser privileges if needed.

DSS will ask you to confirm migration of the existing data directory

## Post-upgrade tasks (before startup)

### Update R installation

If R installation has been performed (see: [R integration](<r.html>)), you must perform again the “install-R-integration” step after upgrade.
    
    
    DATA_DIR/bin/dssadmin install-R-integration
    

### Reinstall graphics exports

If [graphics exports have been enabled](<graphics-export.html>), you must replay the same installation procedure

### Reinstall standalone Hadoop and Spark

If you used standalone libraries for Hadoop and/or Spark, you need to rerun the corresponding install procedure.

### User-isolation framework instances only: secure the new installation

If [User Isolation Framework](<../../user-isolation/index.html>) is enabled, you must rerun the [install-impersonation](<../../user-isolation/initial-setup.html#install-impersonation>) step (as root) to secure the new installation.

### Rebuild base images

If [containerized execution has been enabled](<../../containers/setup-k8s.html>), you will need to [rebuild all base images](<../../containers/setup-k8s.html#rebuild-base-images>).

## Start the new version of DSS

To start DSS, run the following command:
    
    
    DATA_DIR/bin/dss start
    

## Post-upgrade tasks (after startup)

### Rebuild code envs

For some major upgrades, you may need to rebuild the code environments that you already have. The reason is that core dependencies may have been updated, and DSS may not be compatible with the old core dependencies anymore.

If you are using code environments with containerized execution, make sure that all your [code env images have been rebuilt](<../../containers/code-envs.html>) and you will need to update all your code environments accordingly (for the appropriate selected container configurations).

For more details, please check the release notes of your version

### Retrain machine learning models

For some major upgrades, you may need to retrain some of the machine learning models.

Note that in these cases, the packages deployed in an API node also need to be regenerated on DSS and redeployed on the API node.

For more details, please check the release notes of your version.

### Rebuild code studio templates

If [containerized execution has been enabled](<../../containers/setup-k8s.html>), and you have already rebuilt your base images, you will also need to rebuild all your code studio templates.

To rebuild these, there are two options:

  * Run the following command:



    
    
    DATA_DIR/bin/dsscli code-studio-templates-build
    

  * Or rebuild them via the Dataiku DSS interface. Go to Administration > Code Studios, select all the templates, and choose **Build** from the selection drop-down menu.

---

## [installation/index]

# Installing and setting up

There are three main ways to setup Dataiku DSS.

  * **Dataiku Cloud** : Dataiku provides free trials and paying hosted plans on its own cloud. Data and compute are hosted by Dataiku.

  * **Dataiku Cloud Stacks** : Deploy a fully-managed Dataiku setup on a cloud provider. The setup comes fully-featured with Elastic AI, advanced security, R support, auto-healing setup… Everything is deployed in your cloud tenant, Dataiku does not have access to your data. This is the recommended setup for deploying on a cloud provider in your tenant. Supported cloud providers are:

>     * Amazon Web Services (AWS)
> 
>     * Google Cloud Platform (GCP)
> 
>     * Microsoft Azure

  * **Custom Dataiku** : Download and install Dataiku DSS on your own Linux server. This can be deployed either on-premises or on any cloud. Use this setup if you cannot use Dataiku Cloud or Dataiku Cloud Stacks

---

## [installation/other/aws]

# AWS “Sandbox” marketplace image

Dataiku provides a pre-built Marketplace AMI for running DSS on AWS EC2.

Note

Of course, you can use the regular Linux installation procedure ([Installing a new DSS instance](<../custom/initial-install.html>)) on any compatible EC2 instance.

The AMI provides a shorter path to having a working standalone DSS instance with default options.

Warning

This AMI is provided as a way to quick start a DSS instance, mainly for testing purposes. It comes with several “pre-made” choices (accounts, disks, installation directories, …) and installed packages and may not be suitable for all purposes.

For production purposes, we strongly recommend using [Dataiku Cloud Stacks for AWS](<../cloudstacks-aws/index.html>) instead

This AMI does not come with any specific upgrade features. Use the regular DSS upgrade mechanisms.

This AMI is generally not suitable for use as edge node of an existing Hadoop cluster. See [DSS and Hadoop](<../../hadoop/index.html>) for more information. For these cases, we recommend you install a new instance of DSS on a manually installed Linux EC2 instance. Note that edge nodes for Hadoop clusters (except EMR) must generally not use AmazonLinux.

This AMI is not usable out of the box with EMR. Additional setup is required. Alternatively, you can use our EMR-ready AMI. See [Amazon Elastic MapReduce](<../../hadoop/distributions/emr.html>) for more information.

## Prerequisites

You need an AWS account to proceed. You will be billed only for the EC2 instance, the Marketplace AMI itself is free.

## Installation

See <https://www.dataiku.com/dss/trynow/aws/>

### Manual launch details

If you go with the Manual Launch, you should:

  * In instance details, **enable the auto-assign public IP**.

  * In security groups, **expose the standard HTTP and/or HTTPS ports and SSH port** for administration.

  * At the launch, **select or create a public key** to be able to administrate the instance via SSH.




## How to

### How do I use DSS?

DSS is available:

  * As regular HTTP, on the port 80 of the EC2 instance.

  * As HTTPS, on the port 443 of the EC2 instance - DSS is preloaded with a self-signed certificate, so you will get a security error. You can replace this with a real certificate afterwards.




At first launch, you will have to prove that you are the owner of the instance. Authenticate with:

  * the instance id (i-xxxxxxxx) as login

  * an empty password.




When first accessing the DSS UI, you will be prompted to register for the DSS free edition, or enter your DSS enterprise license.

### How do I log into the EC2 instance?

You can log into the instance using the `ec2-user` account and the keypair that you specified during setup of the instance.

Beware: DSS does not run under the `ec2-user` account, but under the `dataiku` account. The `ec2-user` is sudoer, so from the `ec2-user` shell, you can use `sudo su dataiku` to get a shell as the `dataiku` user.

Out of the box, you cannot login as the `dataiku` user, and the `dataiku` user is not sudoer. (you can add your SSH key to the authorized keys of dataiku, though).

### Where is the DSS data directory?

The DSS data directory on the EC2 instance is `/home/dataiku/dss`. All operations on this data directory (like installing R, JDBC drivers, …) must be performed as the `dataiku` user (see above).

### What is installed by default?

The Dataiku AMI is based on AlmaLinux 8. It contains:

  * A standard installation of Dataiku DSS running under Linux user account “dataiku”.

  * A local PostgreSQL database, with a connection to it pre-configured in DSS.

  * A standard installation of R, also pre-configured in DSS.

  * A nginx reverse proxy exposing DSS onto the standard HTTP port 80, and the standard HTTPS port 443 using a self-signed certificate. For better security, you can provide your own certificate in directory /etc/nginx/ssl.




### How do I install JDBC drivers?

JDBC drivers must be installed by copying the relevant files in the “lib/jdbc” folder of the DSS data directory (See [Installing database drivers](<../custom/jdbc.html>)).

You can either download files from the instance or upload them using SSH. Copy into the `/home/dataiku/dss/lib/jdbc` folder must be done as the `dataiku` user (see above).

---

## [installation/other/azure]

# Azure “Sandbox” marketplace image

Dataiku provides a pre-built image for running DSS on Azure

Note

Of course, you can use the regular Linux installation procedure ([Installing a new DSS instance](<../custom/initial-install.html>)) on any compatible Azure Linux instance.

The image provides a shorter path to having a working standalone DSS instance with default options.

Warning

This image is provided as a way to quick start a DSS instance, mainly for testing purposes. It comes with several “pre-made” choices (accounts, disks, installation directories, …) and installed packages and may not be suitable for all purposes.

For production purposes, we strongly recommend using [Dataiku Cloud Stacks for Azure](<../cloudstacks-azure/index.html>) instead

This image does not come with any specific upgrade features. Use the regular DSS upgrade mechanisms.

This image is generally not suitable for use as edge node of an existing Hadoop cluster. See [DSS and Hadoop](<../../hadoop/index.html>) for more information. For these cases, we recommend you install a new instance of DSS on a manually installed Linux Azure instance.

## Prerequisites

You need an Azure account to proceed. You will be billed only for the virtual machine instance, the image itself is free.

## Installation

See <https://www.dataiku.com/dss/trynow/azure/>

## How to

### How do I use DSS?

DSS is available:

  * As regular HTTP, on the port 80 of the Azure VM instance.

  * As HTTPS, on the port 443 of the Azure VM instance - DSS is preloaded with a self-signed certificate, so you will get a security error. You can replace this with a real certificate afterwards.




When first accessing the DSS UI, you will be prompted to register for the DSS free edition, or enter your DSS enterprise license.

### How do I log into the virtual machine instance?

Administrative (command-line) access can be obtained by logging-in through SSH using the credentials specified when creating the machine.

Beware: DSS does not run under this account, but under the `dataiku` account. The administrative account is sudoer, so from its shell, you can use `sudo su dataiku` to get a shell as the `dataiku` user.

Out of the box, you cannot login as the `dataiku` user, and the `dataiku` user is not sudoer (you can add your SSH key to the authorized keys of dataiku, though).

### Where is the DSS data directory?

The DSS data directory on the Azure VM instance is `/home/dataiku/dss`. All operations on this data directory (like installing JDBC drivers, …) must be performed as the `dataiku` user (see above).

### What is installed by default?

The Dataiku image is based on on CentOS 7. It contains:

  * A standard installation of Dataiku DSS running under Linux user account “dataiku”.

  * A local PostgreSQL database, with a connection to it pre-configured in DSS.

  * A standard installation of R, also pre-configured in DSS.

  * A nginx reverse proxy exposing DSS onto the standard HTTP port 80, and the standard HTTPS port 443 using a self-signed certificate. For better security, you can provide your own certificate in directory /etc/nginx/ssl.




### How do I install JDBC drivers?

JDBC drivers must be installed by copying the relevant files in the “lib/jdbc” folder of the DSS data directory (See [Installing database drivers](<../custom/jdbc.html>)).

You can either download files from the instance or upload them using SSH. Copy into the `/home/dataiku/dss/lib/jdbc` folder must be done as the `dataiku` user (see above).

---

## [installation/other/container]

# Running DSS as a container (in Docker or Kubernetes)

Warning

Running DSS inside a container is a relatively complex setup. It requires good familiarity with building and running container images, notably familarity with writing Dockerfiles.

Running DSS itself as a container (either by running Docker directly, or through Kubernetes) is generally speaking incompatible with the ability to leverage containers as a processing engine. See [Elastic AI computation](<../../containers/index.html>). While some things are possible, it requires high expertise with networking and image building capabilities.

We do not recommend running DSS inside a container without discussing first with your Dataiku Account Manager or Customer Success Manager.

---

## [installation/other/gcp]

# GCP “Sandbox” marketplace image

Dataiku provides a pre-built image for running DSS on GCP

Note

Of course, you can use the regular Linux installation procedure ([Installing a new DSS instance](<../custom/initial-install.html>)) on any compatible GCP Linux instance.

The image provides a shorter path to having a working standalone DSS instance with default options.

Warning

This image is provided as a way to quick start a DSS instance, mainly for testing purposes. It comes with several “pre-made” choices (accounts, disks, installation directories, …) and installed packages and may not be suitable for all purposes.

For production purposes, we strongly recommend using [Dataiku Cloud Stacks for GCP](<../cloudstacks-gcp/index.html>) instead

This image does not come with any specific upgrade features. Use the regular DSS upgrade mechanisms.

This image is generally not suitable for use as edge node of an existing Hadoop cluster. See [DSS and Hadoop](<../../hadoop/index.html>) for more information. For these cases, we recommend you install a new instance of DSS on a manually installed Linux Azure instance.

## Prerequisites

You need a Google Cloud account and a Cloud project to proceed. You will be billed only for the virtual machine instance; the image itself is free.

## Installation

See <https://www.dataiku.com/product/get-started/google/>

## How to

### How do I use DSS?

DSS is available:

  * As regular HTTP, on the port 80 of the instance.

  * As HTTPS, on the port 443 of the instance - DSS is preloaded with a self-signed certificate, so you will get a security error. You can replace this with a real certificate afterwards.




When first accessing the DSS UI:

  * You will be required to provide the login and password printed in the Solution deployment UI.

  * You will be prompted to register for the DSS free edition, or enter your DSS enterprise license.




### How do I log into the virtual machine instance?

Administrative (command-line) access can be obtained by logging in through SSH using the credentials configured in your compute engine metadata configuration .

Beware: DSS run under the `dataiku` account. The administrative account is sudoer, so from its shell, you can use `sudo su dataiku` to get a shell as the `dataiku` user.

Out of the box, you cannot login as the `dataiku` user, and the `dataiku` user is not sudoer (you can add your SSH key to the authorized keys of dataiku, though) unless you configure your public key in the in your Compute engine Metadata to be deployed in DSS.

### Where is the DSS data directory?

The DSS data directory on the Compute Engine instance is `/home/dataiku/dss`. All operations on this data directory (like installing JDBC drivers, …) must be performed as the `dataiku` user (see above).

### What is installed by default?

The Dataiku image is based on on CentOS 7. It contains:

  * A standard installation of Dataiku DSS running under Linux user account “dataiku”.

  * A local PostgreSQL database, with a connection to it pre-configured in DSS.

  * A standard installation of R, also pre-configured in DSS.

  * A nginx reverse proxy exposing DSS onto the standard HTTP port 80, and the standard HTTPS port 443 using a self-signed certificate. For better security, you can provide your own certificate in directory /etc/nginx/ssl.




### How do I install JDBC drivers?

JDBC drivers must be installed by copying the relevant files in the “lib/jdbc” folder of the DSS data directory (See [Installing database drivers](<../custom/jdbc.html>)).

You can either download files from the instance or upload them using SSH. Copy into the `/home/dataiku/dss/lib/jdbc` folder must be done as the `dataiku` user (see above).

---

## [installation/other/index]

# Other installation options

In addition to the only supported ways to install DSS ([Dataiku Cloud Stacks for AWS](<../cloudstacks-aws/index.html>), [Dataiku Cloud Stacks for Azure](<../cloudstacks-azure/index.html>), [Dataiku Cloud Stacks for GCP](<../cloudstacks-gcp/index.html>), [Dataiku Cloud](<../index.html>) and [Custom Dataiku installation on Linux](<../custom/initial-install.html>)), DSS can be installed using other options.

Warning

Dataiku does not provide support for any of these installation options.

---

## [installation/other/osx]

# Install on macOS

Warning

  * DSS on macOS is not meant for production usage.

  * DSS on macOS is only provided for testing and experiments.

  * Dataiku will not provide support on this platform.




## macOS prerequisites

>   * macOS 10.9 “Mavericks” or later
> 
>   * At least 8Gb of RAM
> 
>   * Intel x86-64 or Apple Silicon
> 
> 


Note

On Apple silicon, DSS runs using Rosetta (no additional installation or setup is required). It is currently not possible to run DSS **natively** on Apple silicon.

## Install and use DataScienceStudio

For standard desktop use, download the native macOS Dataiku Launcher package [from our website](<https://www.dataiku.com/product/get-started/mac/>). Double click on DataScienceStudio.dmg and drag-and-drop the DataScienceStudio.app into the Applications folder.

To start DataScienceStudio, click on DataScienceStudio.app in the Applications folder. DSS will automatically start.

Note

DSS and it’s dependencies will be downloaded and installed automatically upon first start of the Applications

The Dataiku Launcher will install DSS alongside its dependencies (Java, Python, R) on your machine with the following configuration:

>   * Installation directory: $HOME/Library/DataScienceStudio/kits
> 
>   * Data directory: $HOME/Library/DataScienceStudio/dss_home
> 
>   * Python directory: $HOME/Library/DataScienceStudio/Python
> 
>   * Java directory: $HOME/Library/DataScienceStudio/Java
> 
>   * R directory: $HOME/Library/DataScienceStudio/R
> 
>   * TCP base port: 11200
> 
>   * SSL certificate file path: $HOME/Library/DataScienceStudio/certificates.pem
> 
> 


Warning

Do not modify any of the above installations as it might break the setup. Dependencies versions and updates are managed by the launcher.

By defaut R is not installed. To enable the R integration you need to select the corresponding option by right clicking on the tray icon. (DSS must be started)

Note

The logs are stored in the $HOME/Library/DataScienceStudio/launcher.log file. For other logs check [Logging in DSS](<../../operations/logging.html>)

## Alternative macOS installation (not recommended)

For advanced or non-standard uses, although not recommended, it is possible to install DSS on macOS using the regular Linux procedure (see [Installing a new DSS instance](<../custom/initial-install.html>)), using a specific dataiku-dss-VERSION-osx.tar.gz installation kit. The installation kit can be downloaded from <https://cdn.downloads.dataiku.com/public/studio>

You can follow the Linux installation procedure, apart from the script installing dependencies and the script configuring DSS to start on boot.

In that mode, you keep full control over all installation parameters (directories, port, Java and Python subsystems used). However, the native widget enabling start/stop of DSS from the macOS dock is not available.

---

## [installation/other/vm]

# Install a virtual machine

Dataiku provides a pre-built virtual machine for Virtualbox and VMWare player. This allows you to install DSS if you only have access to a Windows machine.

Installation instructions and details are available here: <https://www.dataiku.com/dss/trynow/virtualbox/> \- please read carefully the following prerequisites.

## Prerequisites

### CPU and OS

You need to have a 64 bits CPU, with a 64 bits OS. The virtual machine will not start without.

On Windows, you can check that you have a 64 bits CPU and a 64 bits OS by going to the System information window.

### Hardware virtualization

Hardware virtualization is mandatory for the DSS virtual machine. This is generally called “AMD-V” or “VT-x”.

All 64 bits CPU support hardware virtualization, but it is often disabled in the BIOS/UEFI of the machines.

If hardware virtualization is missing, the virtual machine will not start and emit messages like `VT-x is not available (VERR_VMX_NO_VMX).` or `VT-x is disabled in the BIOS for all CPU modes (VERR_VMX_MSR_ALL_VMX_DISABLED).`

The following links provide some help on how to enable hardware virtualization:

  * <https://www.google.com/search?q=VT-x+is+not+available+(VERR_VMX_NO_VMX>).

  * <https://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/>

  * <http://druss.co/2015/06/fix-vt-x-is-not-available-verr_vmx_no_vmx-in-virtualbox/>




### Host memory

It is strongly recommended that you have at least 8 GB of RAM to run the DSS virtual machine.

The DSS virtual machine is preconfigured to use 4 GB of memory. If you only have 4 or 6 GB of memory, your host might become unresponsive when starting the DSS virtual machine. If you have less than 8 GB of RAM, we strongly recommend that you lower the amount of memory allocated to the DSS virtual machine before starting it. You can go as low as 2 GB of memory for the DSS virtual machine.

### Hypervisor

The DSS virtual machine is provided as a .ova file that can be opened with Virtualbox or VMWare.

If you use VMWare Player, you’ll encounter a warning while importing the OVA file. You can ignore it and select “Retry”.

## Installation

Step by step instructions are available at <https://www.dataiku.com/dss/trynow/virtualbox/>

### How do I use DSS?

When the virtual machine starts up, it starts by displaying a “DSS is starting” message. When startup is complete, the virtual machine displays a connection banner like this one:

You need to open your browser on the URL referenced as “Data Science Studio interface”

## Troubleshooting

### VT-x is not available (VERR_VMX_NO_VMX)

This error means that hardware virtualization is not enabled.

See Hardware virtualization

### VT-x is disabled in the BIOS for all CPU modes (VERR_VMX_MSR_ALL_VMX_DISABLED)

This error means that hardware virtualization is not enabled.

See Hardware virtualization

### The URL to connect does not appear

When the virtual machine starts up, it starts by displaying a “DSS is starting” message.

When startup is complete, the virtual machine displays a connection banner like this one:

If, after 5-10 minutes, this connection banner is still not displayed and you instead still have the “DSS starting” message, the most probable cause is that your machine does not have enough memory to run both your regular OS and the DSS virtual machine, and the host machine is swapping. We strongly recommend having 8 GB of RAM to run the DSS virtual machine. You can also try to lower the memory allocated to the virtual machine to around 2 GB.

Please see: Host memory

### The URL to connect does not work

When you connect to the “Data Science Studio interface” URL, the Dataiku registration page should appear.

If it does not appear and you get a browser error message like:

  * Connection timeout

  * Connection refused




The most probable cause is that you have a corporate security suite (like McAfee Total Security) that restricts connection from your host machine to the virtual machine. If this is the case:

  * You might be able to ask your security administrator for more details

  * In some cases, VMWare player is an approved application, and switching from Virtualbox to VMWare player might work.




However, fairly often, this kind of problem is not workaroundable (meaning you won’t be able to use the DSS virtual machine) as it is part of the company corporate security policy. See below for other options.

## How to

### I cannot get the virtual machine to work

If you cannot meet the prerequisites or are blocked by a corporate security system, you might want to try our cloud installation options: [AWS “Sandbox” marketplace image](<aws.html>) or [Azure “Sandbox” marketplace image](<azure.html>).

You might also want to try a hosted trial of DSS (running on Dataiku’s servers): <https://www.dataiku.com/dss/trynow>

### How do I log into the virtual machine?

Note that you do not need to log into the virtual machine to simply run DSS. See above documentation.

If you need to log into the virtual machine console (for troubleshooting or installing additional software), use the console login prompt. Login details (login and password) are displayed in the welcome banner of the virtual machine.

### Where is the DSS data directory?

DSS is installed in `/home/dataiku/dss`

### How do I check if DSS is running?

  * Login to the instance as detailed above

  * Go to the DSS data directory : `cd /home/dataiku/dss`

  * Run `./bin/dss status`

  * The status should display all processes as `RUNNING`.




### How do I install JDBC drivers?

JDBC drivers must be installed by copying the relevant files in the “lib/jdbc” folder of the DSS data directory (See [Installing database drivers](<../custom/jdbc.html>)).

To upload files to the DSS data directory, the best solution is to use WinSCP to connect to the virtual machine. The SSH connection details are displayed in the welcome banner of the virtual machine. The DSS data directory is `/home/dataiku/dss`

---

## [installation/other/windows]

# Install on Windows

Warning

  * DSS on Windows is purely experimental and still in its early stages.

  * DSS on Windows is not meant for production usage.

  * DSS on Windows is only provided for testing and experiments.

  * Dataiku will not provide support on this platform.




DSS can be installed on Windows 10 or later through the Dataiku Launcher.

Download the Dataiku Launcher installer for Windows [from our website](<https://www.dataiku.com/product/get-started/windows/>) and run it to install the Dataiku Launcher.

When the application is running an icon will appear in the tray on which you can right click to manage the application.

The Dataiku Launcher will install DSS alongside its dependencies (Java, Python, R) on your machine with the following configuration:

>   * Installation directory: %LOCALAPPDATA%/Dataiku/DataScienceStudio/kits
> 
>   * Data directory: %LOCALAPPDATA%/Dataiku/DataScienceStudio/dss_home
> 
>   * Python directory: %LOCALAPPDATA%/Dataiku/DataScienceStudio/Python
> 
>   * Java directory: %LOCALAPPDATA%/Dataiku/DataScienceStudio/Java
> 
>   * R directory: %LOCALAPPDATA%/Dataiku/DataScienceStudio/R
> 
>   * TCP base port: 11200
> 
> 


Warning

Do not modify any of the above installations as it might break the setup. Dependencies versions and updates are managed by the launcher.

Warning

It is important that the **%LOCALAPPDATA%** path does not include any spaces or non-ASCII characters. In case your username has unsupported characters, you may need to create a new user before installing DSS.

By defaut R is not installed. To enable the R integration you need to select the corresponding option by right clicking on the tray icon.

Warning

Installation of the R integration can take a significant amount of time.

Note

The logs are stored in the %LOCALAPPDATA%/Dataiku/DataScienceStudio/launcher.log file. For other logs check [Logging in DSS](<../../operations/logging.html>)

## Windows prerequisites

>   * Windows 10 or later
> 
>   * At least 8Gb of RAM
> 
>   * Windows [Long Path must be enabled.](<https://docs.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=powershell#enable-long-paths-in-windows-10-version-1607-and-later>) If not enabled, the Dataiku Launcher will prompt you to enable it.
> 
>

---

## [installation/setup-actions/_add_ssh_key]

# Add SSH keys

This setup action enables to add SSH keys to ~/.ssh folder that can be used to connect to other machines from the DSS one.

To generate your public key on Dataiku Cloud:

  * go to your launchpad > extension tab > add an extension,

  * select the SSH integration feature,

  * enter the hostnames of the remote that this key is allowed to connect to,

  * click to validate and generate the key.




Dataiku Cloud will then automatically generate the key and run a command to the origin to get (and verify) the SSH host key of this server. You can now copy the generated key and add it to your hosts. To find this key in the future or generate a new one go to the extension tab and edit the SSH Integration feature.