# Dataiku Docs — dss-cloud

## [cloud/aws/index]

# DSS in AWS

DSS features deep integration with multiple AWS services:

  * Connecting to S3 data

  * Connecting to RDS

  * Connecting to Redshift, including fast copy between S3 and Redshift

  * Leveraging EMR, including dynamically-managed EMR clusters

  * Leveraging EKS, including dynamically-managed EKS clusters

  * Leveraging Athena over S3 data

---

## [cloud/aws/reference-architectures/eks-glue-athena]

# Reference architecture: managed compute on EKS with Glue and Athena

Warning

Use this reference already if you are not using a Dataiku Cloud Stacks for AWS installation. When using a Dataiku Cloud Stacks for AWS installation, these steps are already taken care of.

## Overview

This architecture document explains how to deploy:

  * DSS running on an EC2 machine

  * Computation (Python and R recipes, Python and R notebooks, in-memory visual ML, visual Spark recipes, coding Spark recipes, Spark notebooks) running over dynamically-spawned EKS clusters

  * Data assets produced by DSS synced to the Glue metastore catalog

  * Ability to use Athena as engine for running visual recipes, SQL notebooks and charts

  * Security handled by multiple sets of AWS connection credentials




For information on calculating costs of AWS services, please see the AWS pricing documentation here: <https://aws.amazon.com/pricing/>.

## Architecture diagram

>   * DSS software deployed to EC2 instances inside customer subscription
> 
>   * DSS uses Glue as a metastore, and Athena for interactive SQL queries, against data stored in customers’s own S3*
> 
>   * DSS uses EKS for containerized Python, R and Spark data processing and Machine Learning, as well as API service deployment
> 
>   * DSS uses EMR as a Data Lake for in-cluster Hive and Spark processing
> 
>   * DSS uses Redshift for in-database SQL processing
> 
>   * DSS integrates with SageMaker, Rekognition ad Comprehend ML & AI services
> 
> 


## Security

The `dssuser` needs to have an AWS keypair installed on the EC2 machine in order to manage EKS clusters. The AWS keypair needs all associated permissions to interact with EKS.

This AWS keypair will not be accessible to DSS users.

End-users use dedicated AWS keypairs to access S3 data.

For information on IAM please see the AWS documentation at <https://aws.amazon.com/iam/faqs/>

## Main steps

### Prepare the instance

  * Setup an AlmaLinux 8 EC2 machine

  * Make sure that the EC2 machine has the “default” security group assigned

  * Install and configure Docker CE

  * Install kubectl

  * Install the `aws` command line client

  * Setup a non-root user for the `dssuser`




### Setup connectivity to AWS

  * As the `dssuser`, run `aws configure` to setup AWS credentials private to the `dssuser`. These AWS credentials require:

    * Authorization to push to ECR

    * Full control on EKS




### Install DSS

  * Download DSS, together with the “generic-hadoop3” standalone Hadoop libraries and standalone Spark binaries

  * Install DSS, see [Custom Dataiku install on Linux](<../../../installation/custom/index.html>)

  * Build base container-exec and Spark images, see [Initial setup](<../../../containers/setup-k8s.html>)




### Setup container configuration in DSS

  * Create a new container config, of type K8S

  * Set `ACCOUNT.dkr.ecr.REGION.amazonaws.com` as the Image URL

  * Set the pre-push hook to “Enable ECR”

  * Push base images




### Setup Spark and Metastore in DSS

  * Enable “Managed Spark on K8S” in Spark configurations in DSS

  * Set `ACCOUNT.dkr.ecr.REGION.amazonaws.com` as the Image URL

  * Set the pre-push hook to “Enable ECR”

  * Push base images

  * Set metastore catalog to “Glue”




### Setup S3 connections

  * Setup as many S3 connections as required, with credentials and appropriate permissions

  * Make sure that “S3A” is selected as the HDFS interface

  * Enable synchronization on the S3 connections, and select a Glue database




### Setup Athena connections

  * For each S3 connection, setup an Athena connection

  * Setup the Athena connection to get credentials from the corresponding S3 connection

  * Setup the S3 connection to be associated to the corresponding Athena connection




### Install EKS plugin

  * Install the EKS plugin

  * Create a new preset for “Connection”, leaving all empty

  * Create a new preset for “Networking settings”

    * Enter the identifiers of two subnets in the same VPC as DSS

    * Enter the same security group identifiers as DSS




### Create your first cluster

  * Go to Admin > Clusters, Create cluster

  * Select “Create EKS cluster”, enter a name

  * Select the predefined connection and networking settings

  * Select the node pool size

  * Create the cluster

  * Cluster creation takes around 15-20 minutes




### Use it

  * Configure a project to use this cluster

  * You can now perform all Spark operations over Kubernetes

  * Datasets built will sync to the Glue metastore

  * You can now create SQL notebooks on Athena

  * You can create SQL recipes over the S3 datasets, this will use Athena




Warning

  * This configuration requires baseline knowledge of AWS.

  * These instructions refer to a customer managed deployment (i.e. not Saas or a managed service). It is the customer’s responsibility to manage where and how data is stored (e.g. regarding sensitive data and encryption).

  * These steps are provided for information only. Dataiku does not guarantee the accuracy of these or the fact that they are still up to date.

  * Many AWS services allow instance size selection, and suitable choices should be made according to individual requirements.

  * This reference architecture assumes a deployment on a single Availability Zone. For information on what to do in the event of an AWS AZ fault, please see the AWS documentation here : <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html>

  * Further information on logging in AWS can be found here: <https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html>

  * Further information on creating and restoring backups on AWS can be found here: <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSSnapshots.html>

  * DSS-specific information on managing backups can be found here: <https://doc.dataiku.com/dss/latest/operations/index.html>

  * Redeployment of AWS services, for example following a disaster, require sufficient service quotas. Information on how to view and increase service quotas can be found here: <https://docs.aws.amazon.com/general/latest/gr/aws_service_limits.html>

  * It is recommended for the customer to define the desired Recovery Time Objective and Recovery Point Objective as part of their disaster recovery strategy.

  * It is recommended for the customer to define a strategy for managing system credentials & cryptographic keys.

---

## [cloud/azure/index]

# DSS in Azure

DSS features deep integration with multiple Azure services:

  * Connecting to WASB and ADLS data

  * Connecting to Azure SQL databases

  * Leveraging AKS, inclduing dynamically-managed AKS clusters

---

## [cloud/azure/reference-architectures/azure-aks-adls]

# Reference architecture: manage compute on AKS and storage on ADLS gen2

## Overview

This architecture document explains how to deploy:

  * A DSS instance running on an Azure virtual machine

  * Dynamically-spawned Azure Kubernetes Service (AKS) clusters for computation (Python and R recipes/notebooks, in-memory visual ML, visual and code Spark recipes, Spark notebooks)

  * Ability to store data in Azure DataLake Storage (ADLS) gen2




## Security

We assume that all operations described here are done within a common Azure Resource Group (RG), in which the Service Principal (SP) you are using has sufficient permissions to:

  * Manage AKS clusters

  * Push Docker images to Azure Container Registry (ACR)

  * Read/write from/to ADLS gen 2




## Main steps

### Prepare the instance

  * Setup an AlmaLinux 8 Azure VM in your target RG

  * Install and configure Docker CE

  * Install kubectl

  * Setup a non-root user for the `dssuser`




### Install DSS

  * Download DSS, together with the “generic-hadoop3” standalone Hadoop libraries and standalone Spark binaries.

  * Install DSS, see [Installing and setting up](<../../../installation/index.html>)

  * Build base container-exec and Spark images, see [Initial setup](<../../../containers/setup-k8s.html>)




### Setup containerized execution configuration in DSS

  * Create a new “Kubernetes” containerized execution configuration

  * Set `your-cr.azurecr.io` as the “Image registry URL”

  * Push base images




### Setup Spark and metastore in DSS

  * Create a new Spark configuration and enable “Managed Spark-on-K8S”

  * Set `your-cr.azurecr.io` as the “Image registry URL”

  * Push base images

  * Set metastore catalog to “Internal DSS catalog”




### Setup ADLS gen2 connections

  * Setup as many Azure blob storage connections as required, with appropriate credentials and permissions

  * Make sure that “ABFS” is selected as the HDFS interface




### Install AKS plugin

  * Install the AKS plugin

  * Create a new “AKS connection” preset and fill in:

>     * the Azure subscription ID
> 
>     * the tenant ID
> 
>     * the client ID
> 
>     * the password (client secret)

  * Create a new “Node pools” preset and fill in:

>     * the machine type
> 
>     * the default number of nodes




### Create your first cluster

  * Create a new cluster, select “Create AKS cluster” and enter the desired name

  * Select the previously created presets

  * In the “Advanced options” section, type an IP range for the Service CIDR (e.g. 10.0.0.0/16) and an IP address for the DNS IP (e.g. 10.0.0.10).

  * Click on “Start/attach”. Cluster creation takes between 5 and 10 minutes.




### Use your cluster

  * Create a new DSS project and configure it to use your newly-created cluster

  * You can now perform all Spark operations over Kubernetes

  * ADLS gen2 datasets that are built will sync to the local DSS metastore.

---

## [cloud/gcp/index]

# DSS in GCP

DSS features deep integration with multiple GCP services:

  * Connecting to GCS data

  * Connecting to Google Cloud SQL

  * Connecting to BigQuery, including fast copy between GCS and BigQuery

  * Leveraging Dataproc, including dynamically-managed Dataproc clusters

  * Leveraging GKE, including dynamically-managed GKE clusters

---

## [cloud/gcp/reference-architectures/gke-gcs]

# Reference architecture: managed compute on GKE and storage on GCS

## Overview

This architecture document explains how to deploy:

  * A DSS instance running on a Google Compute Engine (GCE) virtual machine

  * Dynamically-spawned Google Kubernetes Engine (GKE) clusters for computation (Python and R recipes/notebooks, in-memory visual ML, visual and code Spark recipes, Spark notebooks)

  * Ability to store data in Google Cloud Storage




## Security

The `dssuser` needs to be authenticated on the GCE machine hosting DSS with a GCP Service Account that has sufficient permissions to:

>   * manage GKE clusters
> 
>   * push Docker images to Google Artifact Registry (GAR)
> 
> 


## Main steps

### Prepare the instance

  * Setup an AlmaLinux 8 GCE machine and make sure that:

>     * you select the right Service Account
> 
>     * you set the access scope to “read + write” for the Storage API

  * Install and configure Docker CE

  * Install kubectl

  * Setup a non-root user for the `dssuser`




### Install DSS

  * Download DSS, together with the “generic-hadoop3” standalone Hadoop libraries and standalone Spark binaries.

  * Install DSS, see [Installing and setting up](<../../../installation/index.html>)

  * Build base container-exec and Spark images, see [Initial setup](<../../../containers/setup-k8s.html>)




### Setup containerized execution configuration in DSS

  * Create a new “Kubernetes” containerized execution configuration

  * Set `<region>-docker.pkg.dev/<gcp-project>/<repository-name>` as the “Image registry URL”

  * Push base images




### Setup Spark and metastore in DSS

  * Create a new Spark configuration and enable “Managed Spark-on-K8S”

  * Set `<region>-docker.pkg.dev/<gcp-project>/<repository-name>` as the “Image registry URL”

  * Push base images

  * Set metastore catalog to “Internal DSS catalog”




### Setup GCS connections

  * Setup as many GCS connections as required, with appropriate credentials and permissions

  * Make sure that “GS” is selected as the HDFS interface




### Install GKE plugin

  * Install the GKE plugin

  * Create a new “GKE connections” preset and fill in :

>     * the GCP project key
> 
>     * the GCP zone

  * Create a new “Node pools” preset and fill in:

>     * the machine type
> 
>     * the number of nodes




### Create your first cluster

  * Create a new cluster, select “create GKE cluster” and enter the desired name

  * Select the previously created presets and create the cluster

  * Cluster creation takes around 5 minutes




### Use your cluster

  * Create a new DSS project and configure it to use your newly-created cluster

  * You can now perform all Spark operations over Kubernetes

  * GCS datasets that are built will sync to the local DSS metastore

---

## [cloud/index]

# DSS in the cloud

DSS can run fully in the cloud.

When running in the cloud, DSS features advanced integrations with the managed services of the cloud providers, allowing deployment of complex architectures in a fully managed fashion.

DSS has advanced support for:

  * [Amazon Web Services (AWS)](<aws/index.html>)

  * [Microsoft Azure](<azure/index.html>)

  * [Google Cloud Platform (GCP)](<gcp/index.html>)




This section documents the various integration points, and provides some reference architectures for fully-managed cloud services