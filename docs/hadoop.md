# Dataiku Docs — hadoop

## [hadoop/distributions/cdh]

# Cloudera CDH

Warning

Support for CDH in DSS is [Removed](<../../troubleshooting/support-tiers.html>)

All versions of Cloudera CDH are past their End Of Support date by Cloudera. Users are strongly encouraged to migrate to CDP or [Elastic AI infrastructure](<../../containers/index.html>)

---

## [hadoop/distributions/cdp]

# Cloudera CDP

Dataiku supports

  * Cloudera Data Platform - CDP Private Cloud Base:

    * 7.1.7 (aka 7.1.7.p0)

    * 7.1.7 SP1 (aka 7.1.7.p1000 and above)

    * 7.1.7 SP2 (aka 7.1.7.p2000 and above)

    * 7.1.8

    * 7.1.9

    * 7.1.9 SP1

  * Cloudera Base on Premises

    * 7.3.1




## Spark support

  * Dataiku supports the Spark 3 version provided by CDP

  * The Spark 2 version provided by CDP is not supported anymore

  * Connection to Azure Blob (abfs:// URLs) with Spark 3 is not supported




## Security

  * Connecting to secure clusters is supported

  * User isolation is supported with Ranger

  * Using Knox is not supported. DSS must be deployed within the zone protected by Knox




## Known issues

  * DSS 14 requires at least Java 17 to run. If the Java version used for Spark is lower, it should be updated via the properties `spark.executorEnv.JAVA_HOME` and `spark.yarn.appMasterEnv.JAVA_HOME` in the Spark Settings to point to a suitable JDK (Java 17)

  * The Hive version deployed by CDP 7.1.9 and 7.3.1 doesn’t support unbounded ranges (<https://issues.apache.org/jira/browse/HIVE-24905>) in analytical function, which impacts Window recipes in DSS if they use an unbounded window frame. It can be worked around by setting the following Hive property:



    
    
    set hive.vectorized.execution.reduce.enabled=false

---

## [hadoop/distributions/emr]

# Amazon Elastic MapReduce

Warning

**Removed** : Support for Amazon EMR is [Removed](<../../troubleshooting/support-tiers.html>)

We recommend that you use a fully Elastic AI infrastructure based on EKS. Please see [Elastic AI computation](<../../containers/index.html>), or get in touch with your Dataiku Customer Success Manager, Technical Account Manager or Sales Engineer for more information and studying the best options.

---

## [hadoop/distributions/hdp]

# Cloudera (ex-Hortonworks) HDP

Warning

Support for HDP in DSS is [Removed](<../../troubleshooting/support-tiers.html>)

All versions of HDP are past their End Of Support date by Cloudera. Users are strongly encouraged to migrate to CDP or [Elastic AI infrastructure](<../../containers/index.html>)

---

## [hadoop/distributions/index]

# Distribution-specific notes

Each supported Hadoop distribution makes different choices in terms of packaging, versions of the different components of the Hadoop stack, supported ecosystems.

Each distribution bundles its own libraries and backports specific bugs that can modify the behavior of the Hadoop ecosystem components.

Therefore, there are some specificities related to the support of each Hadoop distribution

---

## [hadoop/distributions/mapr]

# MapR

Warning

**REMOVED** Support for MapR is [REMOVED](<../../troubleshooting/support-tiers.html>). We recommend that users plan a migration toward a Kubernetes-based infrastructure.

---

## [hadoop/dynamic-emr]

# Dynamic AWS EMR clusters

Warning

**Removed** : Support for EMR clusters is now Removed from DSS. Starting from version 14.2, the plugin is no longer available for download.

We recommend that you use a fully Elastic AI infrastructure based on EKS. Please see [Elastic AI computation](<../containers/index.html>), or get in touch with your Dataiku Customer Success Manager, Technical Account Manager or Sales Engineer for more information and studying the best options.

DSS can create and manage multiple EMR clusters, allowing you to easily scale your workloads across multiple clusters, use clusters dynamically for some scenarios, …

For more information on dynamic clusters and the usage of a dynamic cluster for a scenario, please see [Multiple Hadoop clusters](<multi-clusters.html>).

Support for dynamic EMR clusters is provided through the “EMR Dynamic clusters” plugin. You will need to install this plugin in order to use this feature.

## Prerequisites and limitations

  * Like for other kind of multi-cluster setups, the server that runs DSS needs to have the client libraries for the proper Hadoop distribution. In that case, your server needs to have the EMR client libraries for the EMR version you will use. Dataiku provides a ready-to-use AMI that already includes the required EMR client libraries

  * The previous requirement implies that the server that will run DSS and start the EMR clusters cannot be an edge node of a different kind of cluster. For example, you cannot manage dynamic EMR clusters from a DSS machine primarily connected to a MapR cluster.

  * When working with multiple EMR clusters, all clusters should run the same EMR version. If running different versions, some incompatibilities may occur.

  * It is not possible to create secure dynamic clusters




## Create your first cluster

### Machine setup

We strongly recommend that you use our “dataiku-emrclient” AMI which contains everything required for EMR support.

This AMI is named `dataiku-emrclient-EMR_VERSION-BUILD_DATE`, where EMR_VERSION is the EMR version with which it is compatible, and BUILD_DATE is its build date using format YYYYMMDD.

At the time of writing, the latest version of this AMI supports EMR 5.30.2 (“dataiku-emrclient-5.30.2-20220126”). It is available in the following AWS regions:

  * eu-west-1 (AMI id: ami-0a3edce0134083c4f)

  * us-east-1 (AMI id: ami-0cda7552753449447)

  * us-west-1 (AMI id: ami-0c4d7c638ac4a9097)

  * us-west-2 (AMI id: ami-00846b24187673dd2)




This AMI can be copied to other regions as desired.

Warning

EMR versions earlier than 5.30 are based on the Amazon Linux 1 Linux distribution, which is not supported by DSS any more. Although “dataiku-emrclient” images are still available for these EMR versions, they should not be used for new deployments.

Dataiku may periodically rebuild this image to incorporate new updates or support new EMR versions. It is recommended to check for its latest versions, as follows:

  * using the AWS EC2 console: select the “AMIs” display in the leftmost column, select “Public images” in the drop-down menu at the left of the search field, and search for “dataiku-emrclient”.

  * using the AWS CLI:
        
        aws ec2 --region eu-west-1 describe-images \
          --owners 067063543704 \
          --filter 'Name=name,Values=dataiku-emrclient-*' \
          --query 'Images[].[ImageId,Name]' \
          --output table
        




The AMI does not include DSS. You need to install DSS using the regular DSS installation procedure.

### AWS credentials

The user account running DSS must have the required credentials in order to create EMR clusters.

The two main ways to accomplish this are:

  * Make sure that your machine has an IAM role that grants sufficient rights to create EMR clusters

  * Make sure that your `~/.aws/credentials` file has valid credentials. This can be achieved by running `aws login` prior to starting DSS




### Install the plugin

From Administration > Plugins, install the “EMR dynamic clusters” plugin.

### Define EMRFS connections

Most of the time, when using dynamic EMR clusters, you will store all inputs and outputs of your flows on S3. Access to S3 from DSS and from the EMR cluster is done through EMRFS.

  * Go to Administration > Connections, and add a new HDFS connection

  * Enter “s3://your-bucket” or “s3://your-bucket/prefix” as the root path URI




Unless the DSS host has implicit access to the bucket through its IAM role or default credentials in `~/.aws/credentials`, define connection-level S3 credentials in “Extra Hadoop conf”:

  * Add a property called “fs.s3.awsAccessKeyId” with your AWS access key id

  * Add a property called “fs.s3.awsSecretAccessKey” with your AWS secret key




### Create the cluster and configure it

Go to Administration > Cluster and click “Create cluster”

In “Type”, select “EMR cluster (create cluster)” and give a name to your new cluster. You are taken to the “managed cluster” configuration page, where you will set all of your EMR cluster settings.

The minimal settings that you need to set are:

  * Your AWS region (leave empty to use the same as the EC2 node running DSS)

  * The EC2 instance type for the master and worker nodes

  * The total number of instances you require (there will be 1 master and N-1 slaves in the CORE group)

  * The version of EMR you want to use. Beware, this should be consistent with the AMI you used.

  * The VPC Subnet identifier in which you want to create your EMR cluster. This should be the same VPC that the DSS machine is running. Leave empty to use the same as the EC2 node running DSS

  * The security groups to associate to all of the cluster machines. Make sure to add security groups that grant full access between the DSS host and the EMR cluster members.




Click on “Start/Attach”. Your EMR cluster is created. This phase generally lasts 5 to 10 minutes. When the progress modal closes, you have a working EMR cluster, and an associated DSS dynamic cluster definition that can talk to oit

### Use your cluster

In any project, go to Settings > Cluster, and select the identifier you gave to the EMR cluster. Any recipe or Hive notebook running in this project will now use your EMR cluster

### Stop the cluster

Go to Administration > Clusters > Your cluster and click “Stop/Detach” to destroy the EMR cluster and release resources.

Note that the DSS cluster definition itself remains, allowing you to recreate the EMR cluster at a later time. Projects that are configured to use this cluster while it is in “Stopped/Detached” state will fail.

## Using dynamic EMR clusters for scenarios

For a fully elastic approach, you can create EMR clusters at the beginning of a sequence of scenarios, run the scenarios and then destroy the EMR cluster, fully automatically.

Please see [Multiple Hadoop clusters](<multi-clusters.html>) for more information. In the “Setup Cluster” scenario step, you will need to enter the EMR cluster configuration details

## Cluster actions

In addition to the basic “Start” and “Stop”, the Dynamic EMR clusters plugin provides the ability to scale up and down an attached EMR cluster.

### Manual run

Go to the “Actions” tab of your cluster, and select the “Scale” action. You will have to specify the target number of instances in the CORE and TASK groups. We recommend that you never scale down the CORE group (which contains a small HDFS needed for cluster operations), and instead scale up and down the TASK group

### As part of a scenario

You can scale up/down a cluster as part of a scenario

  * Add a “Execute macro” step

  * Select the “Scale cluster up/down” step

  * Enter the DSS cluster identifier, either directly, or using a variable - the latter case is required if you setup your cluster as part of the scenario.

  * Select the settings




In this kind of setup you will generally scale up at the beginning of the scenario and scale down at the end. You will need two steps for that. Make sure to select “Run this step > Always” for the “scale down” step. This way, even if your scenario failed, the scale down operation will be executed.

## Advanced settings

In addition to the basic settings outlined above, the Dynamic EMR Clusters plugin provides some advanced settings

### Security settings

  * Key pair

  * Roles

  * Security configuration




### Metastore

  * Database mode




### Tags

You can add tags to your cluster. Variables expansion is not supported here.

### Misc

  * Path for logs

---

## [hadoop/hadoop-fs-connections]

# Hadoop filesystems connections (HDFS, S3, EMRFS, WASB, ADLS, GS)

DSS can connect to multiple “Hadoop Filesystems”. A Hadoop filesystem is defined by a URL. Implementations of Hadoop filesystems exist that provide connectivity to:

  * HDFS

  * Amazon S3

  * Azure Data Lake Storage

  * Azure Blob Storage

  * Google Cloud Storage

  * …




The “main” Hadoop filesystem is traditionally a HDFS running on the cluster, but through Hadoop filesystems, you can also access to HDFS filesystems on other clusters, or even to different filesystem types like cloud storage.

The prime benefit of framing other filesystems as Hadoop filesystems is that it enables the use of the Hadoop I/O layers, and as a corollary, of important Hadoop file formats: Parquet and ORC.

To access data on a filesystem using Hadoop, 3 things are needed:

  * libraries to handle the filesystem have to be installed on the cluster and on the node hosting DSS. Hadoop distributions normally come with at least HDFS and S3A

  * a fully-qualified URI to the file, of the form `scheme://host[:port]/path-to-file` . Depending on the scheme, the `host[port]` part can have different meanings; for example, for cloud storage filesystems, it is the bucket.

  * Hadoop configuration parameters that get passed to the relevant tools (Spark, Hive, MapReduce, HDFS libraries) - This is generally used to pass credentials and tuning options




## HDFS connections in DSS

Warning

In DSS, all Hadoop filesystem connections are called “HDFS”. This wording is not very precise since there can be “Hadoop filesystem” connections that precisely do not use “HDFS” which in theory only refers to the distributed implementation using NameNode/DataNode.

To setup a new Hadoop filesystem connection, go to Administration → Connections → New connection → HDFS.

A HDFS connection in DSS consists of :

  * a root path, under which all the data accessible through that connection resides. The root path can be fully-qualified, starting with a `scheme://`, or starting with `/` and relative to what is defined in _fs.defaultFS_

  * Hadoop configuration parameters that get passed to the relevant tools (Spark, Hive, MapReduce, HDFS libraries)




### Managed datasets setup

We suggest to have at least two connections:

  * A read-only connection to all data:

>     * `root: /`  _(This is a path on HDFS, the Hadoop file system.)_
> 
>     * Allow write, allow managed datasets: unchecked
> 
>     * max nb of activities: 0
> 
>     * name: hdfs_root

  * A read-write connection, to allow DSS to create and store managed datasets:

>     * root: /user/dataiku/dss_managed_datasets
> 
>     * allow write, allow managed datasets: checked
> 
>     * name: hdfs_managed




When “Hive database name” is configured, DSS declares its HDFS datasets in the Hive metastore, in this database namespace. This allows you to refer to DSS datasets in external Hive programs, or in Hive notebooks within DSS.

## Connecting to the “default” FS

All Hadoop clusters define a ‘default’ filesystem, which is traditionally a HDFS on the cluster.

When missing, the `scheme://host[:port]` is taken from the `fs.defaultFS` Hadoop property in `core-site.xml`, so that a URI like ‘/user/john/data/file’ is generally interpreted as a path on the local HDFS filesystem of the cluster. However, if the `fs.defaultFS` of your cluster points to S3, an unqualified URI will similarly point to S3.

## Connecting to the HDFS of other clusters

A HDFS located on a different cluster can be accessed with a HDFS connection that specified the host (and port) of the namenode of that other filesystem, like `hdfs://namenode_host:8020/user/johndoe/` . DSS will access the files on all HDFS filesystems with the same user name (even if [User Isolation Framework](<../user-isolation/index.html>) is being used for HDFS access).

Warning

When the local cluster is using Kerberos, it is possible to access a non-kerberized cluster, but a HDFS configuration property is needed : `ipc.client.fallback-to-simple-auth-allowed=true`

## Connecting to S3

There are several options to access S3 as a Hadoop filesystem (see the [Apache doc](<https://cwiki.apache.org/confluence/display/HADOOP2/AmazonS3>)).

Note

The S3 dataset in DSS has native support for using Hadoop software layers whenever needed, including for fast read/write from Spark and Parquet support. Using a Hadoop dataset for accessing S3 is not usually required.

Warning

  * Using S3 as a Hadoop filesystem is not supported on [MapR](<distributions/mapr.html>)




### Using S3A

“S3A” is the primary mean of connecting to S3 as a Hadoop filesystem.

Warning

S3A is not supported when running on [EMR](<distributions/emr.html>)

S3A support has not been validated on [MapR](<distributions/mapr.html>)

Access using the S3A filesystem involves using a URI like `s3a://bucket_name/path/inside/bucket/` , and ensuring the credentials are available. The credentials consist of the access key and the secret key. They can be passed :

  * either globally, using the `fs.s3a.access.key` and `fs.s3a.secret.key` Hadoop property

  * or for the bucket only, using the `fs.s3a.bucket_name.access.key` and `fs.s3a.bucket_name.secret.key` Hadoop property




### Using EMRFS

EMRFS is an alternative mean of connecting to S3 as a Hadoop filesystem, which is only available on [EMR](<distributions/emr.html>)

Access using the EMRFS filesystem involves using a URI like `s3://bucket_name/path/inside/bucket/` , and ensuring the credentials are available. The configuration keys for the access and secret keys are named `fs.s3.awsAccessKeyId` and `fs.s3.awsSecretAccessKey`. Note that this is only possible from an EMR-aware machine.

### Using VPC Endpoints

When accessing S3 buckets through a VPC Endpoint (of the form `http[s]://bucket.vpce-__identifier__.s3.__region__.vpce.amazonaws.com`), an additional config file is required.

You will have to download and edit [awssdk_config_default.json](<https://github.com/aws/aws-sdk-java/blob/master/aws-java-sdk-core/src/main/resources/com/amazonaws/internal/config/awssdk_config_default.json#L145>), and add the following in the `hostRegexToRegionMappings` section :
    
    
    {
        "hostNameRegex" : "https://bucket\\.vpce\\-.+\\.s3\\.us\\-west\\-1\\.vpce\\.amazonaws\\.com",
        "regionName"    : "us-west-1"
    }
    

(replacing `us\\-west\\-1` by the region of your bucket as needed).

This file is to be repacked in a jar and moved to your lib/java folder:
    
    
    mkdir -p com/amazonaws/internal/config/
    mv awssdk_config_default.json com/amazonaws/internal/config/
    jar -cf awssdk_config.jar com
    mv awssdk_config.jar DATA_DIR/lib/java
    

## Connecting to Azure Blob Storage

Note

The Azure Blob dataset in DSS has native support for using Hadoop software layers whenever needed, including for fast read/write from Spark and Parquet support. Using a Hadoop dataset for accessing Azure Blob Storage is not usually required.

The URI to access blobs on Azure is `wasb://container_name@your_account.blob.core.windows.net/path/inside/container/` (see the [Hadoop Azure support](<http://hadoop.apache.org/docs/r2.7.1/hadoop-azure/index.html>)).

The credentials being already partly in the URI (the account name), the only property needed to allow access is `fs.azure.account.key.your_account.blob.core.windows.net` to pass the access key.

## Connecting to Google Cloud Storage

Note

The Google Cloud Storage dataset in DSS has native support for using Hadoop software layers whenever needed, including for fast read/write from Spark and Parquet support. Using a Hadoop dataset for accessing Google Cloud Storage is not usually required.

The URI to access blobs on Google Cloud Storage is `gs://bucket_name/path/inside/bucket/` (see the [GCS connect](<https://cloud.google.com/dataproc/docs/connectors/cloud-storage>))

## Connecting to Azure Data Lake Store (gen1)

Access to ADLS gen 1 is possible with Oauth tokens provided by Azure

  * Make sure that your service principal is owner of the ADLS account and has read/write/execute access to the ADLS gen 1 root container recursively

  * Retrieve your App Id, Token endpoint and Secret for the registered application in Azure portal




The URI to access ADLS is `adl://<datalake_storage_name>.azuredatalakestore.net/<optional_path>` (see the [Hadoop ADLS support](<https://hadoop.apache.org/docs/current/hadoop-azure-datalake/index.html>)).

Add the following key values as Extra Hadoop Conf of the connection:

  * `fs.adl.oauth2.access.token.provider.type` -> `ClientCredential`

  * `fs.adl.oauth2.refresh.url` -> `<your_token_endpoint>`

  * `fs.adl.oauth2.client.id` -> `<your_app_id>`

  * `fs.adl.oauth2.credential` -> `<your_app_secret_key`




## Connecting to Azure Data Lake Store (gen2)

Note

The Azure Blob Storage dataset in DSS has native support ADLS gen2 and for using Hadoop software layers whenever needed, including for fast read/write from Spark and Parquet support. Using a Hadoop dataset for accessing ADLS gen2 is not usually required.

## Additional details

### Cloud storage credentials

Cloud storage filesystems require credentials to give access to the data they hold. Most of them allow these credentials to be passed by environment variable or by Hadoop configuration key (the preferred way). The mechanisms to make the credentials available to DSS are:

  * adding them as configuration properties for the entire cluster (ie. in `core-site.xml`)

  * adding them as environment variables in DSS’s `$DATADIR/bin/env-site.sh` (when it’s possible to pass them as environment variables), and DSS and any of its subprocess can access them

  * adding them as extra configuration keys on DSS’s HDFS connections, and then only usages of the HDFS connection will receive the credentials




Warning

Proper usage of cloud storage filesystems implies that the credentials are passed to the processes needing them. In particular, the Hive metastore and Sentry will need to be given the credentials in their configurations.

### Checking access to a Hadoop filesystem

Since DSS uses the standard Hadoop libraries, before attempting to access files on different filesystems, command-line access to these filesystems should be checked. The simplest test is to run:
    
    
    > hadoop fs -ls uri_to_file
    

If Kerberos authentication is active, logging in with `kinit` first is required. If credentials need to be passed as Hadoop configuration properties, they can be added using the `-D` flag, like
    
    
    > hadoop fs -D fs.s3a.access.key=ABABABABA -D fs.s3a.secret.key=ABCDABCDABCDCDA -ls uri_to_file
    

To check that Hive is functional and gets the credentials it needs, creating a dummy table will uncover potential problems :
    
    
    > beeline -u 'jdbc:hive2://localhost:10000/default'
    beeline> CREATE EXTERNAL TABLE dummy (a string) STORED AS PARQUET LOCATION 'fully_qualified_uri_to_some_folder'
    

### Relation to the Hive metastore

Hadoop clusters most often have Hive installed, and with Hive comes a Hive Metastore to hold the definitions and locations of the tables Hive can access. The location of a Hive table does not need to be on the local cluster, but can be any location provided it’s defined as a fully-qualified URI. But a given Hive installation, and in particular a given Hiveserver2, only knows one Hive Metastore. If Hive tables are defined in a different Hive Metastore, on a different cluster, Hive doesn’t access them.

---

## [hadoop/hive-dataset]

# Hive datasets

Most of the time, to read and write data in the Hadoop ecosystem, DSS handles HDFS datasets, that is file-oriented datasets pointing to files residing on one or several HDFS-like filesystems.

DSS can also handle Hive datasets. Hive datasets are pointers to Hive tables already defined in the Hive metastore.

  * Hive datasets can only be used for reading, not for writing

  * To read data from Hive datasets, DSS uses HiveServer2 (using a JDBC connection). In essence a Hive dataset is a SQL-like dataset




## Use cases

HDFS dataset remains the “to-go” dataset for interacting with Hadoop-hosted data. The HDFS dataset provides the most features, the most ability to parallelize work and execute it on the cluster.

However, there are some cases of (existing) source data for which the HDFS isn’t able to read them properly. In that case, using a Hive dataset as the source of your Flow will allow you to read your data. Since Hive dataset is read-only, only the sources of the Flow use a Hive dataset, and subsequent parts of the Flow revert to regular HDFS datasets.

### Hive views

If you have existing data which is available through a Hive view, there are no HDFS files materializing this particular data. In that case, you cannot use a HDFS dataset and should use a Hive dataset.

### No read access on source files

Through the Hive security mechanisms (Ranger), it is possible to have existing tables in the Hive metastore, with read access to these tables using HiveServer2, but not read access to the underlying HDFS files.

In that case, you cannot use a HDFS dataset and should use a Hive dataset.

### ACID tables (ORC)

You can create ACID tables in Hive (in the ORC format). These tables support UPDATE statements that regular Hive tables don’t support. These tables are stored in a very specific format that only HiveServer2 can read. DSS cannot properly read the underlying files of these tables.

In that case, you cannot use a HDFS dataset and should use a Hive dataset.

### DATE and DECIMAL data types

There are various difficulties in reading tables containing these kind of columns. It is recommended to use Hive datasets preferably when reading these tables.

## Creating a Hive dataset

You do not need to setup a connection to create a Hive dataset. As soon as connectivity with Hadoop (and your HiveServer2) is established, you can create Hive datasets

### New dataset

  * Select New Dataset > Hive

  * Select the database and the table

  * Click on test to retrieve the schema

  * Your Hive dataset is ready to use




### Import

Either from the catalog or connections explorer, when selecting an existing Hive table, you will have the option to import it either as a HDFS dataset or Hive dataset.

## Using a Hive dataset

A Hive dataset can be used with most kinds of DSS recipes.

### Hive recipes

You can create Hive recipes with Hive datasets as inputs.

Note

The recipe MUST be in “Hive CLI (global metastore)” or HiveServer2 mode for this to work. Please see [Hive](<hive.html>) for more information.

### Visual recipes with Hive as execution engine

You can create visual recipes and select the Hive execution engine (when available) with Hive datasets as inputs.

Note

The recipe MUST be in “Hive CLI (global metastore)” or HiveServer2 mode for this to work. Please see [Hive](<hive.html>) for more information.

### Spark recipes

You can create Spark (code) recipes with Hive datasets as inputs.

Note

The recipe MUST be in “Use global metastore)” mode for this to work.

Note

You must have filesystem-level access to the underlying files of this Hive table for this to work.

### Visual recipes with Spark as execution engine

You can create visual recipes and select the Spark execution engine (when available) recipes with Hive datasets as inputs.

Note

The recipe MUST be in “Use global metastore)” mode for this to work.

Note

You must have filesystem-level access to the underlying files of this Hive table for this to work.

### Limitations

  * SQL recipes cannot be used. Use a Hive recipe instead

  * Spark engine (and Spark recipes) cannot be used if you don’t have filesystem access to the underlying tables.

---

## [hadoop/hive]

# Hive

Hive is a tool of the Hadoop environment that allows running SQL queries on top of large amounts of HDFS data by leveraging the computation capabilities of the cluster. It can be used either as a semi-interactive SQL query interface to obtain query results, or as a batch tool to compute new datasets.

Hive maps datasets to virtual SQL tables.

DSS provides the following integration points with Hive :

  * The Hive Recipe allows you to compute HDFS datasets as the results of Hive scripts

  * All HDFS datasets can be made available in the Hive environment, where they can be used by any Hive-capable tool, even if these datasets were not computed using a Hive recipe. This is called “Hive metastore synchronization”

  * The “Hive notebook” allows you to run Hive queries on any Hive database, whether they have been created by DSS or not

  * DSS can import table definitions from Hive, and convert them to DSS HDFS dataset definitions




Note

HDFS datasets in DSS are always true “HDFS datasets”. They are primarily a path on HDFS and may have an associated Hive table. DSS does not have “Hive-only datasets”, and accessing Hive tables as SQL datasets using “Other SQL databases” option is not supported.

## Interaction with the Hive global metastore

The global metastore is the metastore that is used when the “hive” command is launched without arguments. These tables are defined in the database namespace configured in the corresponding HDFS connection.

DSS can:

>   * Create tables for the HDFS datasets into the global Hive metastore
> 
>   * Import table definitions from the global Hive metastore as HDFS datasets
> 
> 


Note

It is strongly recommended that your Hadoop cluster uses the “Shared metastore” mode for the global metastore.

This is the default behavior for Cloudera and Hortonworks Hadoop distributions

## Synchronisation to the Hive metastore

HDFS datasets in DSS are primarily what their name implies: HDFS datasets. In other words, a HDFS dataset in DSS is a reference to a folder on HDFS. It is not directly a reference to a Hive table.

However, each HDFS dataset in DSS can point to a Hive table. When a managed dataset is built, DSS automatically “pushes” its definition as the corresponding Hive table in the Hive metastore.

This means that as soon as a compatible HDFS dataset has been built, you can use the Hive notebook or any Hive query tool (like Cloudera Hue)

Note

Whenever possible, metastore synchronization also ensures that the dataset is usable by Impala, ie. you can use the Impala Notebook, perform data visualization, or use with any Impala query tool (like impala-shell)

For more details, please see [Impala](<impala.html>)

Metastore synchronization normally happens as part of the normal job run, after the dataset is built, but you can also force it manually by following the procedure outlined below.

If the schema of the DSS dataset has changed, DSS automatically updates it in the Hive metastore.

The Hive database and table associated to each dataset is configured in the settings of this dataset.

### For external datasets

Only managed datasets are automatically synchronized to the Hive metastore. However, you can also manually synchronize an external HDFS dataset.

  * Go to the settings of the HDFS dataset

  * Fill in the Hive database and table information in the dataset

  * Save the dataset settings

  * Go to the Advanced tab

  * Click on the “Synchronize” button




## Importing from the Hive metastore

In addition to the ability to “push” datasets’ definition into the Hive Metastore, DSS can also read preexisting table definitions from the metastore to create associated HDFS datasets in DSS.

To import Hive tables as HDFS datasets:

>   * Go to the datasets list
> 
>   * Click “New dataset”, then “Import from connection”
> 
>   * In the list, select your Hive database
> 
> 


Import lists all tables in the Hive database. If there is already a dataset corresponding to each table, you get a link to the existing dataset.

Select the tables that you want to import. If needed, customize the resulting dataset name, then click “Create”.

The tool will report which of the Hive tables it managed to import.

The following limitations apply:

  * Existing compression settings are not detected, notably on files in the Parquet format. As a result, the output compression is not preserved (if you plan on using this dataset in write mode).

  * For partitioned tables, it tries to detect the partitioning scheme, and will import those tables whose partitioning scheme can be handled by DSS. This excludes notably tables where the partition locations can’t all be translated into a concatenation of the partitioning columns’ values.

  * The table definitions are imported ‘as is’ and the user’s HDFS rights on the table’s files are not checked, so that an imported table can not necessarily be read from or written to in DSS.




Note

The name of the created datasets default to the Hive table name. In case of conflict, DSS adds a distinctive suffix to the dataset name.

## Hive execution engines

### Notebooks and metrics

Hive notebooks and metrics computations are always executed using Hiveserver2 (and therefore using the global metastore).

If you encounter issues with tables not found, you can check that the datasets that you try to reach have properly been synchronized to the Hive metastore.

### Recipes

There are three ways to run Hive recipes in DSS.

Warning

Hive CLI modes are deprecated and will be removed in a future DSS release. Only HiveServer 2 mode will remain available.

#### Hiveserver 2

In this mode, recipes use Hiveserver2. DSS automatically synchronizes the recipe’s inputs and outputs to the global metastore when running such a recipe.

#### Hive CLI (global metastore)

Warning

This mode is deprecated and will be removed in a future DSS release

In this mode, DSS uses the `hive` command-line, targeting the global mode. DSS automatically synchronizes the recipe’s inputs and outputs to the global metastore when running such a recipe.

#### Hive CLI (isolated metastore)

Warning

This mode is deprecated and will be removed in a future DSS release

In this mode, DSS uses the `hive` command-line, but creates a specific metastore for running each recipe.

This mode ensures that your query only uses the proper input and output datasets, since only these ones will be added to the isolated metastore.

#### Choosing the mode

When DSS [User Isolation](<../user-isolation/index.html>) is enabled, only Hiveserver2 mode is supported.

In some setups, running the Hive CLI is not possible. For these setups, only Hiveserver2 mode is possible.

“Hive CLI (isolated metastore)” mode has interesting safety advantages: because the isolated metastore only contains the requested datasets and partitions, you cannot accidentally access data which is not properly declared in your Flow, thus improving the reproducibility.

However, the isolated metastore does not have dataset stats. When Hive runs on Tez, dataset stats are used to compute an optimal execution plan. Not having dataset stats can lead to worse performance. In that case, we recommend using “Hive CLI (global metastore)” or HiveServer2 modes.

In addition, depending on the Hive authorization mode, only some recipe modes might be possible. Check below for more information.

#### Configuring the mode

The execution mode can be configured in each Hive recipe (and also in visual recipes running with the Hive engine), in the “Advanced tab”.

In addition, you can configure in Administration > Settings > Hive the “Default execution engine”, which will select the initial value for newly created recipes. This global setting has no impact on existing recipes.

## Support for Hive authentication modes

DSS supports the following authentication modes for HiveServer2:

  * PLAIN authentication for non-secure Hadoop clusters

  * KERBEROS authentication for secure Hadoop clusters




## Support for Hive authorization modes

DSS supports several security authorization modes for Hive, depending on the DSS security mode. For more information, please see [User Isolation](<../user-isolation/index.html>)

Please read carefully the information below, since some authorization modes impose additional constraints.

Modes not explicitly listed here are not supported.

### No Hive security (No DSS User Isolation)

In this mode, the Hive metastore accepts requests to create external tables without checks on the storage permissions. HiveServer2 impersonation must be enabled.

### Ranger (No DSS User Isolation)

When Ranger is enabled, it controls:

  * DDL and DML queries through Hive policies

  * HDFS access through HDFS policies




Prerequisites for this mode are:

  * Ranger enabled

  * Hiveserver2 impersonation disabled




In this mode, you need to add Hive policies in Ranger to allow the `dssuser` user full access on the databases used by DSS. In addition, you need to add in your Hive policies grants on other databases used as inputs in DSS.

If, in addition to Ranger, storage-based metastore security is enabled (which is the default on HDP when enabling Ranger mode), you must add a HDFS policy allowing the `hive` user full control on the root paths of the DSS HDFS connections. This is required because, since HiveServer2 does not impersonate in this mode, queries to create tables on the metastore are done on behalf of the `hive` user, who must thus have write access to the locations of the created tables.

### Ranger (DSS User Isolation enabled)

When Ranger is enabled, it controls:

  * DDL and DML queries through Hive policies

  * HDFS access through HDFS policies




Prerequisites for this mode are:

  * Ranger enabled

  * Hiveserver2 impersonation disabled




In this mode, you need to add Hive policies in Ranger to allow the `dssuser` user full access on the databases used by DSS. In addition, you need to add in your Hive policies grants on other databases used as inputs in DSS.

If, in addition to Ranger, storage-based metastore security is enabled (which is the default on HDP when enabling Ranger mode), you must go to Administration > Settings > Hadoop and check the “Write ACL in datasets” setting. This will automatically add a write ACL to the Hive user when building datasets and synchronizing permissions. This is required because, since HiveServer2 does not impersonate in this mode, queries to create tables on the metastore are done on behalf of the `hive` user, who must thus have write access to the locations of the created tables.

### Storage-based security (No DSS User Isolation)

In this mode:

  * Storage-based security is enabled in the metastore (ie the metastore checks that a user requesting DDL has rights on the underlying HDFS directories)

  * HiveServer2 impersonation is enabled




Since HiveServer2 impersonation is enabled, the user requesting the metastore is `dssuser`, so no further action is necessary.

Note

This is the default setup for HDP

## Supported file formats

Hive only recognizes some formats, so not all HDFS datasets can be synchronized to Hive or used in a Hive recipe.

The following formats are handled:

  * CSV, only in “Escaping only” or “No escaping nor quoting” modes

  * Parquet. If the dataset has been built by DSS, it should use the “Hive flavor” option of the Parquet parameters.

  * Hive Sequence File

  * Hive RC File

  * Hive ORC File

  * Avro




### Limitations

  * Hadoop does not support at all CSV files with newlines embedded within fields. Trying to parse such files with Hadoop or any Hadoop tool like Hive will fail and generate invalid data




## Internal details

Data Science Studio creates all tables as EXTERNAL tables in the Hive meaning of the term.

---

## [hadoop/impala]

# Impala

Impala is a tool of the Hadoop environment to run interactive analytic SQL queries on large amounts of HDFS data.

Unlike [Hive](<hive.html>), Impala does not use MapReduce nor Tez but a custom Massive Parallel Processing engine, ie. each node of the Hadoop cluster runs the query on its part of the data.

Data Science Studio provides the following integration points with Impala :

  * All HDFS datasets can be made available in the Impala environment, where they can be used by any Impala-capable tool.

  * The [Impala](<../code_recipes/impala.html>) run queries on Impala, while handling the schema of the output dataset.

  * The “Impala notebook” allows you to run Impala queries on any Impala database, whether they have been created by DSS or not.

  * When performing [Charts](<../visualization/index.html>) on a HDFS dataset, you can choose to use Impala as the query execution engine.

  * Many [visual recipes](<../other_recipes/index.html>) can use Impala as their execution engine if the computed query permits it.




## Impala connectivity

Data Science Studio connects to Impala through a JDBC connection to one of the impalad server(s) configured in the “Settings / Hadoop” administration screen.

Hive connectivity is mandatory for Impala use, as Impala connections use the Hive JDBC driver, and Impala table definitions are stored in the global Hive metastore.

## Metastore synchronization

Making HDFS datasets automatically available to Impala is done through the same mechanism as for Hive. See [Hive](<hive.html>) for more info.

## Supported formats and limitations

Impala can only interact with HDFS datasets with the following formats:

  * [CSV](<../connecting/formats/csv.html>)
    
    * only in “Escaping only” or “No escaping nor quoting” modes.

    * only in “NONE” compression

  * [Parquet](<../connecting/formats/parquet.html>)
    
    * If the dataset has been built by DSS, it should use the “Hive flavor” option of the Parquet parameters.

  * Hive Sequence File

  * Hive RC File

  * Avro




Additional limitations apply:

  * Impala cannot handle datasets if they contain any complex type column.




## Configuring connection to Impala servers

The settings for Impala are located in Administration > Settings > Impala.

Impala queries are analyzed and their execution initiated by a `impalad` daemon on one datanode from your Hadoop cluster. Thus, in order for DSS to interact with Impala, DSS must know the hostnames of the impalad hosts (or at least a fraction of them). You need to setup the list of these hostnames in the “Hosts” field.

Should you need a custom port, you can also set it in the “Port” field.

DSS can handle both the regular Hive-provided JDBC driver and the [Cloudera enterprise connector](<https://www.cloudera.com/documentation/other/connectors.html>).

DSS supports the following authentication modes for Impala:

  * No authentication (on non-secure Hadoop clusters)

  * Kerberos (on secure Hadoop clusters)

  * LDAP




### Kerberos authentication (secure clusters)

Since Impala queries are run by the `impalad` daemons under the `impala` user, in a kerberized environment the principal of that `impala` user is required in order to properly connect to the daemons through jdbc, and it can be set in the “Principal” field.

When multiple hostnames have been specified in the “Hosts” field, DSS provides the same placeholder mechanism as Impala itself: the string `_HOST` is swapped with the hostname DSS tries to run the query against.

### LDAP authentication

Just like SQL connections in DSS, credentials must be provided in form of a user/password. These credentials can be GLOBAL and shared by all users of the DSS instance, of defined per-DSS user in their Profile settings.

If Impala has been setup to encrypt connections to client services (see Cloudera’s [documentation](<https://www.cloudera.com/documentation/enterprise/latest/topics/impala_ssl.html>)), then DSS, as a JDBC client of Impala, needs access to the Java truststore holding the necessary security certificates (see the Hive [documentation on JDBC connection](<https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-ConnectionURLWhenSSLIsEnabledinHiveServer2>)).

Please refer to [Adding SSL certificates to the Java truststore](<../installation/custom/advanced-java-customization.html#java-ssl-truststore>) for the procedure to add trusted certificates to the JVM used by DSS.

## Using Impala to write outputs

Even though Impala is traditionally used to perform SELECT queries, it also offers INSERT capabilities, albeit reduced ones.

First, Impala supports less formats for writing than it does for reading. You can check Impala’s support of your format on Cloudera’s [documentation](<http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/impala_file_formats.html>).

Second, Impala doesn’t do impersonation and writes its output using the `impala` user. Since DSS uses EXTERNAL tables (in the meaning Hive gives to it), the user must be particularly attentive to the handling of file permissions, depending on the Hive authorization mode and the DSS security mode.

### No Hive authorization (DSS regular security)

In order for Impala to write to the directories corresponding to the managed datasets, it needs to have write permissions on them. It is also necessary to ensure that after Impala has written a folder, DSS can still manage that.

To achieve this, it is necessary that:

  * Hive must be set to propagate parent permissions onto sub-folders as it creates them, which means the property `hive.warehouse.subdir.inherit.perms` must be set to “true”.

  * The directory holding the managed datasets gives write permission to the `impala` user

  * The directory holding the managed datasets must default to giving write permissions to other users, so that when Hive propagates permissions, DSS still has write permission.




In summary, the recommended setup is:

  * Set `hive.warehouse.subdir.inherit.perms` to true in the global Hive conf

  * Set permission 777 on the root directory of all managed datasets (which is generally `/user/dss_user/dss_managed_datasets`)

  * In DSS, make sure that in Administration > Settings > Impala, the `Pre-create folder for write recipes` setting is not checked. Save DSS settings.




Note that this gives everybody read and write access on all datasets. It is possible to restrict a bit the permissions by restricting permissions on the upper directory (while maintaining an ACL to Impala), or by putting DSS in the group that Impala uses for writing.

### Ranger

See [Hive](<hive.html>)

### Switching from write-through-DSS to write-through-Impala

Warning

Before switching to write-through-Impala, you must clear the dataset. Failure to clear the dataset will lead to permission issues that will require cluster administrator intervention.

---

## [hadoop/index]

# DSS and Hadoop

Note

This feature is not available on Dataiku Cloud.

---

## [hadoop/installation]

# Setting up Hadoop integration

DSS is able to connect to a Hadoop cluster and to:

  * Read and write HDFS datasets

  * Run Hive queries and scripts

  * Run Impala queries

  * Run preparation recipes on Hadoop




In addition, if you [setup Spark integration](<../spark/installation.html>), you can:

  * Run most visual recipes on Spark

  * Run SparkSQL queries

  * Run PySpark, SparkR and Spark Scala scripts

  * Train & use Spark MLLib models

  * Run machine learning scoring recipes on Spark




## Prerequisites

### Supported distributions

DSS supports the following Hadoop distributions:

  * Cloudera’s CDP (see [CDP-specific notes](<distributions/cdp.html>))




Check each distribution-specific page for supported versions, special installation steps or restrictions.

### Non supported distributions

DSS does not provide support for custom-built or other Hadoop distributions.

### Software install

The host running DSS should have client access to the cluster (it can, but it does not need to host any cluster role like a datanode).

Getting client access to the cluster normally involves installing:

  * the Hadoop client libraries (Java jars) matching the Hadoop distribution running on the cluster.

  * the Hadoop configuration files so that client processes (including DSS) can find and connect to the cluster.




Both of the above operations are typically best done through your cluster manager interface, by adding the DSS machine to the set of hosts managed by the cluster manager, and configuring “client” or “gateway” roles for it (also sometimes called “edge node”).

If not possible, installing the client libraries usually consists in installing software packages from your Hadoop distribution, and the configuration files can be typically be downloaded from the cluster manager interface, or simply copied from another server connected to the cluster. See the documentation of your cluster distribution.

The above should be done at least for the HDFS and Yarn/MapReduce subsystems, and optionally for Hive if you plan to use these with DSS.

Warning

Dataiku highly recommends “edge node” managed setup.

Manually installing libraries, binaries and configuration on another machine can be a challenging setup, for which your Hadoop distribution will usually not provide support. Dataiku cannot provide support for this either as this is highly dependent on your setup. Dataiku will require that all of the components are fully functional on your machine before a Dataiku setup can be performed.

### HDFS

You may also need to setup a writable HDFS home directory for DSS (typically “/user/dataiku”) if you plan to store DSS datasets in HDFS,

### Hive

You need to have access to one or several writable Hive metastore database (default “dataiku”) so that DSS can create Hive table definitions for the datasets it creates on HDFS.

You must have a running Hiveserver2 server.

Several Hive security modes are supported. See [Hive](<hive.html>) for more information.

## Testing Hadoop connnectivity prior to installation

First, test that the machine running DSS has proper Hadoop connectivity.

A prerequisite is to have the “hadoop” binary in your PATH. To test it, simply run:
    
    
    hadoop version
    

It should display version information for your Hadoop distribution.

You can check HDFS connectivity by running the following command from the DSS account:
    
    
    hdfs dfs -ls /
    # Or the following alternate form for older installations, and MapR distributions
    hadoop fs -ls /
    

### hive binary

If you want to run Hive recipes using “Hive CLI” mode, you need a properly configured “hive” command line client for the DSS user account (available in the PATH).

You can check Hive connectivity by running the following command from the DSS account:
    
    
    hive -e "show databases"
    

If it succeeds, and lists the databases declared in your global Hive metastore, your Hive installation is correctly set up for DSS to use it.

This is only required if you intend on using the “Hive CLI” mode of Hive recipes. For more information on Hive recipe modes, see [Hive execution engines](<hive.html#hadoop-hive-execution-engines>)

## Setting up DSS Hadoop integration

Warning

If your Hadoop cluster has Kerberos security enabled, please don’t follow these instructions. Head over to [Connecting to secure clusters](<secure-clusters.html>).

If your Hadoop cluster does not have security (Kerberos) enabled, DSS automatically checks for Hadoop connectivity at installation time, and automatically configures Hadoop integration if possible. You don’t need to perform the `dsadmin install-hadoop-integration` step. You still need to perform Hive and Impala configuration, though.

You can configure or reconfigure DSS Hadoop integration at any further time:

  * Go to the DSS data directory



    
    
    cd DATADIR
    

  * Stop DSS:



    
    
    ./bin/dss stop
    

  * Run the setup script



    
    
    ./bin/dssadmin install-hadoop-integration
    

  * Restart DSS



    
    
    ./bin/dss start
    

Warning

You should reconfigure Hadoop integration using the above procedure whenever your cluster installation changes, such as after an upgrade of your cluster software.

### Test HDFS connection

To test HDFS connectivity, try to create an HDFS dataset:

With Hadoop integration disabled

With Hadoop integration enabled

Note

If the Hadoop HDFS button does not appear, Data Science Studio has not properly detected your Hadoop installation.

You can then select the “hdfs_root” connection (which gives access to the whole HDFS hierarchy) and click the Browse button and verify that you can see your HDFS data.

Upon first setup of DSS Hadoop integration, two HDFS connections are defined: “hdfs_root” for read-only access to the entire HDFS filesystem, “hdfs_managed” to store DSS-generated datasets. You can edit these default connections, in particular their HDFS root path and default Hive database name, to match your installation. You can delete them or define additional ones as needed.

For more information, see [Hadoop filesystems connections (HDFS, S3, EMRFS, WASB, ADLS, GS)](<hadoop-fs-connections.html>)

### Standalone Hadoop integration

If you do not have a Hadoop cluster but want to set up a standalone hadoop integration, you can download the provided `dataiku-dss-hadoop-standalone-libs-generic-hadoop3` binary from your usual Dataiku DSS download site. You can then run the standalone hadoop integration:
    
    
    cd DATADIR
    ./bin/dss stop
    ./bin/dssadmin install-hadoop-integration -standalone generic-hadoop3 -standaloneArchive /PATH/TO/dataiku-dss-hadoop3-standalone-libs-generic...tar.gz
    ./bin/dss start
    

### Configure Hive connectivity

For DSS to be able to read and write Hive table definitions, you must setup the host of your HiveServer2.

Go to Administration > Settings > Hive, enter the host name of your HiveServer2, and save settings.

For more information, see [Hive](<hive.html>)

If you want to run Hive recipes using “Hive CLI” mode, you also need a properly configured “hive” command line client for the DSS user account.

### Configure Impala connectivity

If your Hadoop cluster has Impala, you need to configure the impalad hosts.

Go to Administration > Settings > Impala, enable Impala, enter the list of Impala servers (if none is set, then the localhost will be used), and save settings.

For more information, see [Impala](<impala.html>).

## Secure Hadoop connectivity

Connecting to secure Hadoop clusters requires additional configuration steps described in [Connecting to secure clusters](<secure-clusters.html>).

---

## [hadoop/multi-clusters]

# Multiple Hadoop clusters

Warning

**Deprecated** : Support for multiple Hadoop clusters is [Deprecated](<../troubleshooting/support-tiers.html>) and will be removed in a future DSS version

> We strongly advise against using Multiple Hadoop Clusters for “traditional” Hadoop clusters, given the very high associated complexity.

DSS can connect to several “Hadoop clusters”, meaning:

  * Several YARN resource managers

  * Several HiveServer2 servers

  * Several sets of Impala servers




This capability to connect to multiple clusters doesn’t include multiple Hadoop filesystems, which is covered by [Hadoop filesystems connections (HDFS, S3, EMRFS, WASB, ADLS, GS)](<hadoop-fs-connections.html>)

## Concepts

### Builtin cluster

A Hadoop cluster is mainly defined by the client-side configuration, usually found in `/etc/hadoop/conf`, which indicates (among others) the address of the YARN resource manager.

When Hadoop integration is setup in DSS, DSS will use a “system-level” Hadoop configuration, which is put in the classpath of DSS.

In DSS, this is called the “builtin cluster”, whose configuration is accessible in Administration > Settings > Hadoop.

The builtin cluster also has associated Hive, Impala and Spark configurations defined in the respective Administration > Settings screens.

### Additional clusters

In addition to the builtin cluster, you can define additional clusters in the Administration > Cluster screens.

Each additional cluster is defined by:

  * A set of Hadoop configuration keys that indicate how to connect to the YARN of the additional cluster

  * HiveServer2 connection details for the additional cluster

  * Impala connection details for the additional cluster

  * A set of Spark configuration keys specific to the additional cluster




### Managed dynamic clusters

In addition to “static” additional clusters, where you have to define all the connection settings, DSS has a notion of “managed dynamic clusters”. Through a plugin installed in DSS, dynamic clusters can be created by DSS, configured as additional clusters, and shutdown through DSS.

This capability is most often used in cloud deployments, either using the cloud provider’s native Hadoop cluster capability or dynamic Hadoop clusters directly created based on cloud provider’s virtual machines capabilities.

### Use an additional cluster

Each project defines whether recipes/notebooks/… of this project run against the builtin cluster or one of the additional clusters.

#### Per-scenario additional clusters

In addition to project-level definition of which cluster to use, a scenario can:

  * Create a dynamic cluster (for example an EMR cluster)

  * Execute all of its steps on the dynamic cluster

  * Shutdown the dynamic cluster at end




This allows you to have a minimal cluster or no cluster at all for the “design” of the project, and to spawn clusters dynamically for execution of scenarios, leading to a fully elastic resource usage approach. This capability is more often used for automation nodes.

## Restrictions

  * When using multiple Hadoop clusters, all clusters must use the same Hadoop distribution. It is not supported for example to have the builtin cluster running Cloudera, and an additional cluster running Hortonworks

  * All clusters must either be unsecure, or secure using the same Kerberos realms (DSS will only use the principal and keytab of the builtin cluster)

  * User mappings must be similar between clusters

  * Running multiple Spark versions (for example one cluster with Spark 1.6 and one cluster with Spark 2.2) is not supported

  * Multiple MapR clusters is not validated and not supported




## Define an additional static cluster

This assumes that DSS is already properly connected and setup to work with primary cluster.

  * Go to Administration > Clusters and create a new cluster

  * Give an identifier to your new cluster




The configuration of an additional cluster is divided in a number of sections. For each section, you need to choose whether you want to inherit the settings of the builtin cluster, or override them for this particular cluster.

### Hadoop

In this section, you’ll always override the “Hadoop config keys” section. You must enter here the keys used to define the YARN addresses.

These settings will be passed to:

  * Data preparation jobs running on MapReduce engine




Although this varies, you’ll usually need to define the following keys:

  * `fs.defaultFS` usually pointing to the native HDFS of the cluster (used notably for various staging directories), ie something like `hdfs://namenodeaddress:8020/`

  * `yarn.resourcemanager.address` pointing to the host/port of your resource manager, i.e. something like `resourcemanageraddress:8032`




Warning

These Hadoop configuration keys are not passed to Spark jobs. See below.

Other settings are for advanced usage only

### Hive

In this section, you’ll always override “connection settings” to point to the HiveServer2 of your additional cluster. Refer to [Hive](<hive.html>) for more information about configuring this.

If your builtin cluster does not use “HiveServer2” as default recipe engine, override “creating settings” and select HiveServer2

Other settings are for advanced usage only

### Impala

In this section, you’ll always override “connection settings” to point to the impalad nodes of your additional cluster. Refer to [Impala](<impala.html>) for more information about configuring this.

Other settings are for advanced usage only

### Spark

Note

Only the “yarn” master in “client” deployment mode really makes sense here.

In this section, you’ll need to add configuration keys to point Spark to your YARN. Note that the configurations defined in the “Hadoop” section do not apply to Spark as Spark uses different keys.

Choose to override runtime config.

The first section “Config keys added to all configurations” contains configuration keys that will be added to all Spark named configurations defined at the global level. The second section “Configurations” contains configuration keys that are added only to a single Spark named conf.

You cannot add new Spark named conf at the additional cluster level.

You’ll often need to add the following keys (note the `spark.hadoop` prefix used to pass Hadoop configuration keys to Spark):

  * `spark.hadoop.fs.defaultFS` usually pointing to the native HDFS of the cluster (used notably for various staging directories), ie something like `hdfs://namenodeaddress:8020/`

  * `spark.hadoop.yarn.resourcemanager.address` pointing to the host/port of your resource manager, i.e. something like `resourcemanageraddress:8032`

  * `spark.hadoop.yarn.resourcemanager.scheduler.address` pointing to the the host/port of the scheduler part of your resource manager, i.e. something like `resourcemanageraddress:8030`




Other settings are for advanced usage only.

## Use a specific cluster for scenarios

For this, you’ll use the variables expansion mechanism of DSS.

Instead of writing a cluster identifier as the contextual cluster to use at the project level, you can use the syntax `${variable_name}`. At runtime, DSS will use the cluster denoted by the `variable_name` variable.

Your scenario will then use a scenario-scoped variable to define the cluster to use for the scenario.

For example, if you want to use the cluster `regular1` for the “design” of the project, and all non-scenario-related activities, and the `fast2` cluster for a scenario.

Setup your project as such:

  * Cluster: `${clusterForScenario}`

  * Default cluster: `regular1`




With this setup, when the `clusterForScenario` variable is not defined (which will be the case outside of the scenario), DSS will fallback to `regular1`

In your scenario, add an initial step “Define scenario variables”, and use the following JSON definition:
    
    
    {
            "clusterForScenario" : "fast2"
    }
    

The steps of the scenario will execute on the `fast2` cluster

## Permissions

Each cluster has an owner and groups who are granted access levels on the cluster:

  * **Use cluster** to be able to select the cluster and use it in a project

  * **Operate cluster** to be able to modify cluster settings

  * **Manage cluster users** to be able to manage the permissions of the cluster




In addition, each group can be granted global permissions to:

  * Create clusters and manage the clusters they created

  * Manage all clusters, including the ones they are not explicitly granted access to

---

## [hadoop/secure-clusters]

# Connecting to secure clusters

DSS can connect to Hadoop clusters running in secure mode, where cluster users need to be authenticated by Kerberos in order to be authorized to use cluster resources.

When configured to use Hadoop security, Data Science Studio logs in to Kerberos upon startup, using a preconfigured identity (Kerberos principal) and a secret key stored in a local file (Kerberos keytab). Upon success, this initial authentication phase returns Kerberos credentials suitable for use with the Hadoop cluster.

Data Science Studio then uses these credentials whenever it needs to access Hadoop resources. This includes reading and writing HDFS files, running DSS preparation scripts over the cluster, running Hive recipes, accessing the Hive metastore, and using Hive or Impala notebooks.

As the credentials returned by the Kerberos login phase typically have a limited lifetime, Data Science Studio periodically renews them as long as it is running, in order to keep a continuous access to the Hadoop cluster.

Warning

When [User Isolation Framework](<../user-isolation/index.html>) is disabled, DSS uses its own identity to access all Hadoop resources, regardless of the currently logged-in DSS user.

As a consequence, granting Data Science Studio access to a given user indirectly gives this user access to all cluster resources accessible through the DSS Kerberos identity. Make sure this is compatible with your cluster security policy, and to design accordingly the set of Hadoop permissions granted to the Kerberos identity used by DSS.

You can also enable [User Isolation Framework](<../user-isolation/index.html>)

## Setup the DSS Kerberos account

The first steps in configuring Hadoop security support consist in setting up the Kerberos account which DSS will use for accessing cluster resources:

  * Create a Kerberos principal (user or service account) for this DSS instance in your Kerberos account database. You can choose any principal name for this, according to your local account management policy.

Typical values include `dataiku@MY.KERBEROS.REALM` and `dataiku/HOSTNAME@MY.KERBEROS.REALM`, where `dataiku` is the name of the Unix user account used by DSS, `MY.KERBEROS.REALM` is the uppercase name of your Kerberos realm, and `HOSTNAME` is the fully-qualified name of the Unix server hosting DSS.

  * Create a Kerberos keytab for this account, and store it in a file accessible only to DSS

  * Configure your Hadoop cluster to authorize this principal to access the cluster resources required for DSS operation, including:

    * read-write access to the HDFS directories used as managed dataset repositories (typically: `/user/dataiku`)

    * read-only access to any additional HDFS directories containing datasets

    * read-write access to the Hive metastore database used by DSS (typically named `dataiku`)

    * permission to launch map-reduce jobs

  * Install the Kerberos client software and configuration files on the DSS Unix server so that processes running on it can find and contact the Kerberos authorization service. In particular, the `kinit` Unix command must be in the execution PATH of the DSS user account, and must be functional.




You can check the above steps by attempting to access HDFS using the DSS Kerberos credentials, as follows:
    
    
    root@dss# # Open a session on the DSS Unix server using the DSS Unix user account
    root@dss# su - dataiku
    dataiku@dss> # Log in to Kerberos using the DSS principal and keytab
    dataiku@dss> kinit -k -t DSS_KEYTAB_FILE DSS_KERBEROS_PRINCIPAL
    dataiku@dss> # Check the Kerberos credentials obtained above
    dataiku@dss> klist
    dataiku@dss> # Attempt to read DSS's HDFS home directory using the Kerberos credentials
    dataiku@dss> hdfs dfs -ls /user/dataiku
    dataiku@dss> # Log out the Kerberos session
    dataiku@dss> kdestroy
    

## Configure DSS for Hadoop security

To configure Hadoop connectivity in DSS with a secure cluster:

  * Go to the DSS data directory



    
    
    cd DATADIR
    

  * Stop DSS:



    
    
    ./bin/dss stop
    

  * Run the setup script



    
    
    ./bin/dssadmin install-hadoop-integration -keytab ABSOLUTE_PATH_TO_DSS_KEYTAB_FILE -principal DSS_KERBEROS_PRINCIPAL
    

  * Start DSS



    
    
    ./bin/dss start
    

### Test HDFS connection

Test the HDFS connectivity using the steps detailed in [Test HDFS connection](<installation.html#hadoop-installation-test-hdfs-connection>)

### Configure Hive connectivity

For DSS to be able to read and write Hive table definitions, you must setup the host of your HiveServer2.

Go to Administration > Settings > Hive, enter:

  * The host name of your HiveServer2

  * The Kerberos principal of the Hiveserver2. This is generally something like `hive/HOST.FULLY_QUALIFIED_NAME@KERBEROS.REALM`




Warning

The hostname of your HiveServer2 must generally be a fully-qualified name. For secure clusters, even when installing on the master of the cluster, 127.0.0.1 won’t work.

Note

The hostname part of the Hiveserver2 Kerberos principal can be specified as `_HOST`, as in : `hive/_HOST@KERBEROS.REALM`. This placeholder will be dynamically replaced by the hostname of the Hiveserver2 server.

Non-default connection properties (eg HTTP transport, SSL connection, etc) can be added to the standard connection string with optional “Connection properties”.

Alternatively, it is possible to take full control over the JDBC connection URI by checking the “Use advanced URL syntax” checkbox.

Note

The `${database}` variable can be used in this URI to specify the database to which to connect.

With [User Isolation Framework](<../user-isolation/index.html>) enabled for Hadoop access, the `${hadoopUser}` variable can be used in this URI to specify the name of the user to impersonate.

For example, a connection URI using both high-availability through zookeeper discovery and impersonation would be typically configured as: `jdbc:hive2:ZK1:2181,ZK2:2181,ZK3:2181/${database};serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2;hive.server2.proxy.user=${hadoopUser}`

Save the settings.

For more information, see [Hive](<hive.html>)

### Configure Impala connectivity

If your Hadoop cluster has Impala, you need to configure the impalad hosts.

Go to Administration > Settings > Impala, enter:

  * The list of Impala servers

  * The Kerberos principal of your Impala servers. This is generally something like `impala/_HOST@KERBEROS.REALM`




In the Kerberos principal string, the `_HOST` string will be replaced by the hostname of each Impalad server.

Save the settings.

For more information, see [Impala](<impala.html>).

## Modification of principal or keytab

If you need to modify the principal or keytab parameters, go to Administration > Settings > Hadoop.

In the “Hadoop security (Kerberos)” section, fill in

  * Enable: yes

  * Principal: The DSS Kerberos principal

  * Keytab: Absolute path to the Keytab file for the DSS principal.




Save the settings. You then need to restart DSS for this configuration update to be taken into account
    
    
    DATA_DIR/bin/dss restart
    

## Advanced settings (optional)

### Configuring Kerberos credentials periodic renewal

When Data Science Studio logs in to the Kerberos authentication service using its keytab, it typically receives credentials with a limited lifetime. In order to be able to permanently access the Hadoop cluster, Data Science Studio continuously renews these credentials by logging again to the Kerberos service, on a configurable periodic basis.

The default renewal period is one hour, which should be compatible with most Kerberos configurations (where credential lifetimes are typically on the order of one day). It is possible to adjust this behavior however, by way of two more configuration keys to add to the file `DATA_DIR/config/dip.properties`:
    
    
    # Kerberos login period, in seconds - default 1 hour
    hadoop.kerberos.ticketRenewPeriod = 3600
    # Delay after which to retry a failed login, in seconds - default 5 mn
    hadoop.kerberos.ticketRetryPeriod = 300
    

After modifying this file, restart DSS.

---

## [hadoop/spark]

# Spark

For an introduction to the support of Spark in DSS, see [DSS and Spark](<../spark/index.html>)

Dataiku DSS supports the version of Spark 3 provided by supported Hadoop distributions. Support for Spark 2 is deprecated.

  * Go to the Dataiku DSS data directory

  * Stop DSS



    
    
    ./bin/dss stop
    

  * Run the setup



    
    
    # Path may differ
    ./bin/dssadmin install-spark-integration -sparkHome /opt/cloudera/parcels/SPARK3/lib/spark3
    

  * Start DSS



    
    
    ./bin/dss start
    

## Verify the installation

Go to the Administration > Settings section of DSS. The Spark tab must be available.

### Additional topics

## Metastore security

Spark requires a direct access to the Hive metastore, to run jobs using a HiveContext (as opposed to a SQLContext) and to access table definitions in the global metastore from Spark SQL.

Some Hadoop installations restrict access to the Hive metastore to a limited set of Hadoop accounts (typically, ‘hive’, ‘impala’ and ‘hue’). In order for SparkSQL to fully work from DSS, you have to make sure the DSS user account is authorized as well. This is typically done by adding a group which contains the DSS user account to Hadoop key `hadoop.proxyuser.hive.groups`.

Note

On Cloudera Manager, this configuration is accessible through the `Hive Metastore Access Control and Proxy User Groups Override` entry of the Hive configuration.

## Configure Spark logging

Spark has DEBUG logging enabled by default; When reading non-HDFS datasets, this will lead Spark to log the whole datasets by default in the “org.apache.http.wire”.

We strongly recommend that you modify Spark logging configuration to switch the org.apache.http.wire logger to INFO mode. Please refer to Spark documentation for information about how to do this.

---

## [hadoop/tdch]

# Teradata Connector For Hadoop

Teradata Connector for Hadoop (TDCH) can be used in DSS as an additional execution engine which allows scalable parallel data transfers between Teradata and HDFS.

## Installation and configuration

The Teradata Hadoop appliance already embeds TDCH. On the Hadoop side, many Hadoop enterprise vendors embed a TDCH library in their product, otherwise you can install it by:

  * downloading the [Teradata Connector for Hadoop](<https://downloads.teradata.com/download/connectivity/teradata-connector-for-hadoop-command-line-edition>) installation archive (you need a Teradata account)

  * unzipping it somewhere on the machine that runs DSS.




Once you have downloaded (or already know the location of) TDCH you can enable its support in DSS by adding the following properties to configuration file `DATADIR/config/dip.properties`, and restarting DSS (you may have to adjust file version numbers according to your distribution):
    
    
    tdch.enabled = true
    tdch.jar = /PATH/TO/TDCH/LIB/teradata-connector-1.5.1.jar
    tdch.includes = /PATH/TO/TDCH/LIB/tdgssconfig.jar,/PATH/TO/TDCH/LIB/terajdbc4.jar
    

## Usage and Guidelines

For any Sync recipe between a HDFS dataset and a Teradata dataset, the TDCH engine will be available (both directions).

Some settings are available in the “Advanced” tab of the recipe to define the distribution method and number of mappers.

Refer to Teradata documentation for tuning the engine according to your Teradata characteristics and YARN capabilities.

The following distribution methods are available:

  * For Teradata -> HDFS sync:

    * split.by.hash

    * split.by.value

    * split.by.partition

    * split.by.amp

  * For HDFS -> Teradata sync

    * batch.insert

    * internal.fastload




## Limitations

  * Partitioned datasets are not supported

  * Only the CSV format is supported for the HDFS dataset

  * SQL “query” datasets are not supported. Only SQL “table” datasets are supported

  * Properties defined at the HDFS connection level are not taken into account. Therefore, it is generally not possible to sync with cloud storages (S3, GCS, WASB, ADLS) - since these connections generally require properties for credentials

---

## [hadoop/user-isolation]

# Hadoop user isolation

The regular behavior of DSS is to run as a single UNIX account on its host machine (let’s call it `dssuser`). When a DSS end-user executes an Hadoop recipe or notebook, it runs on the cluster as the `dssuser` Hadoop user.

DSS supports an alternate mode of deployment, called _user isolation_. In this mode, DSS will _impersonate_ the end-user and run all user-controlled code under a different identity than the `dssuser` user.

For more information, please see [User Isolation Framework on HAdoop](<../user-isolation/capabilities/hadoop-impersonation.html>)