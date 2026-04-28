# Dataiku Docs — user-isolation

## [user-isolation/advanced/hdfs-datasets]

# HDFS datasets data structure

Note

This only applies for HDFS datasets for which ACL synchronization is used.

When user isolation for Hadoop is disabled, datasets location is specified by a path in a connection.

When user isolation for Hadoop is enabled, DSS uses a different files pattern for managed datasets: if the dataset’s configured location is `/user/dataiku/datasets/MYPROJECT/mydataset`, then the actual data is written in `/user/dataiku/datasets/MYPROJECT/mydataset/data`.

The “data” folder belongs to the last user who wrote the dataset (this might be “hive” or “impala”). The “mydataset” folder always belongs to the `dssuser` user.

ACLs preventing access are on the `mydataset` folder. Within that folder, it is normal for data files to have world-readable permissions. The restrictive “gateway” ACLs on `mydataset` prevent unauthorized users from accessing them.

This behavior is configured in the settings of the HDFS connection, in the “Write ACL synchronization mode” setting.

---

## [user-isolation/advanced/index]

# Advanced topics

---

## [user-isolation/advanced/local-security]

# Configuration of the local security

## What are the sudo authorizations?

When you install impersonation, DSS adds a sudoers rule in `/etc/sudoers.d/dataiku-dss-THE_DSS_USER-RANDOM_STRING`

Note

If DSS could not install this sudoers rule, the impersonation setup asks you to do it manually

This rule allows DSS to run, as root, a small wrapper which is used:

  * To execute user-submitted code as the end-user UNIX accounts

  * To change permissions and ownerships on various files required by user-submitted code




No user-submitted code runs as root. The wrapper (also called the security module) has a specific configuration to limit which users it may run as.

## Configuration of the local security module

When DSS runs a command on behalf of an end-user, it consults the security module configuration in `/etc/dataiku-security/INSTALL_ID/security/security-config.ini`.

This ini file contains two important information:

  * Which user groups it may change identity to. This is configured in `[users]`, in the `allowed_user_groups` settings.

  * Where DSS is located. DSS will not change any file permissions outside of this directory, unless explicitly allowed as stated below.




### Splitted DSS datadirs

In some configurations, you might have “splitted” your DSS datadir, by using symbolic links.

To allow the security module to change file permissions in the additional locations, fill in the `additional_allowed_file_dirs` in the `dirs` section.

---

## [user-isolation/capabilities/hadoop-impersonation]

# Hadoop Impersonation (HDFS, YARN, Hive, Impala)

The core of traditional Hadoop Distributions like Cloudera is based on:

  * A HDFS cluster (NameNode + DataNodes)

  * A YARN cluster (ResourceManager + NodeManagers), primarily running Spark and Hive workflows

  * A HiveServer and HiveMetastore

  * Impala servers




All of these support the Hadoop _proxyuser_ mechanism that DSS can leverage as part of the User Isolation Framework.

## Interaction with HDFS

When UIF for Hadoop is enabled, access to HDFS is impersonated, i.e. performed with an end-user identity rather than the `dssuser` identity.

Data created by DSS needs to have specific permissions applied to it in order to both permit access by all authorized users (impersonated) and deny access by other users.

UIF interacts with HDFS permissions through Ranger. Ranger will manage all authorizations on HDFS data, both at the raw HDFS level and Hive/Impala level. You need to manage the permissions through the native mechanism of Ranger.

There is a legacy DSS-managed ACL synchronization”, where DSS will automatically place HDFS ACLs on the managed datasets that it builds. Note that you will also need to leverage Ranger ACLs for Hive/Impala level.

**We recommend that you use Ranger preferably to DSS-managed ACLs**.

There are several limitations to the “DSS-managed ACL synchronization” mode:

  * HDFS has a strong and non-workaroundable limitation to 32 ACL entries per file. The DSS-managed ACLs require a larger number of ACLs per path, which can overflow the limit to 32 ACLs per path in HDFs. This can lead to situations where it is not possible to have more than 32 groups in a DSS instance.

  * Appending in a HDFS dataset can only be done by a single user. If another user tries to append, he will get permission issues. The dataset must be cleared before another can write.

  * In some circumstances with partitioned datasets, occasional failures can happen and require retries.

  * HDFS ACLs are not supported for [Per-project single user permissions](<../../security/permissions.html#per-project-single-user-permissions>).




Ranger have integration points in the NameNode and have more pervasive and flexible access, implying fewer limitations than DSS-managed ACLs. The three main advantages of using Sentry / Ranger mode are:

  * Centralized authorization in Sentry / Ranger rather than requiring managing Sentry rules in addition to the HDFS ACLs.

  * For some customer deployments, working around limitations in number of HDFS ACLs.

  * Appending to HDFS datasets using multiple users becomes possible.




## Interaction with Hive

When UIF is enabled, all interactions between DSS and Hive happen through HiveServer2.

HiveServer2 itself uses Ranger to authorize access to Hive databases and tables.

DSS does not push authorization rules to Ranger nor does it pull authorization rules from these systems.

Thus, you need to declare authorization rules both in the DSS projects, and in Ranger.

For more information about the supported Hive security modes, see [Hive](<../../hadoop/hive.html>).

## Interaction with Impala

Details of security interaction between DSS and Impala are detailed in [Impala](<../../hadoop/impala.html>).

## Interaction with Spark on YARN

### Architecture

When running a Spark job as user `A` in DSS:

  * DSS acquires Hadoop delegation tokens on behalf of `A`

  * DSS starts the Spark driver using the sudo mechanism, as `A` user, passing the Hadoop delegation tokens

  * The Spark driver can then start its executors as `A`, using its Yarn delegation tokens.




Thus, DSS only supports the `yarn-client` deployment of YARN. Running a standalone master or local mode is not recommended, because it is the YARN application manager who is responsible for renewing the delegation tokens.

DSS does not support the `yarn-cluster` mode.

### Hive Metastore

On Hadoop, it is possible to restrict the access to the Hive metastore server so that only HiveServer2 can talk to the metastore server.

In a “regular” setup, any user can authenticate (using Kerberos) to the metastore server and issue DDL commands. If the metastore is secured, only Hiveserver2 may do so.

Spark does not use Hiveserver2 and when you create a `HiveContext` in Spark, it always talks directly to the Hive metastore. Thus, when the Hive metastore is configured for restricted access, Spark access to the metastore will fail. This has the following consequences:

  * Using a HiveContext in Spark code recipes fails (SQLContext remains available)

  * Using table definitions from the Hive metastore in Spark code recipes is not possible (including SparkSQL)

  * Running some visual recipes on Spark (since they require HiveContext-only features) will fail




Authorizing access to the Hive metastore is typically done through the `hadoop.proxyuser.hive.groups` and `hadoop.proxyuser.hive.hosts` configuration keys. You should make sure that the former authorizes all DSS users, and the latter authorizes the DSS host.

Note

On Cloudera Manager, this configuration is accessible through the `Hive Metastore Access Control and Proxy User Groups Override` entry of the Hive configuration.

---

## [user-isolation/capabilities/index]

# Details of UIF capabilities

The User Isolation Framework is made of a number of components and capabilities that are more or less independent. These pages present details on operation and technical details of each component.

We recommend that you start by reading the appropriate [Reference architectures](<../reference-architectures/index.html>) for your needs.

---

## [user-isolation/capabilities/kubernetes]

# Workload isolation on Kubernetes

## Running regular workloads

When you run non-Spark workloads on Kubernetes, the Kubernetes job is always started by the `dssuser`. The `dssuser` requires the ability to connect and create pods and secrets on your Kubernetes cluster.

However, once the user’s code has been started, a fundamental property of Kubernetes is that each container is independent and cannot access others. Thus, code running in one container is _isolated_ from code running in another container without a specific need for impersonation.

No further setup is thus required for running regular workloads securely on Kubernetes.

## Running Spark workloads

When you run Spark workloads on Kubernetes, DSS uses the _sudo_ mechanism of the local code isolation capability to start the `spark-submit` process running the Spark driver under the identity of the end-user. This driver process then sends control orders to Kubernetes in order to start pods for the Spark executor.

In other words, the Spark driver requires access to the Kubernetes API but runs untrusted code. This requires that each impersonated end-user has credentials to access Kubernetes. While this deployment is completely possible, it is not typically the case (each user needs to have a `~/.kube/config` file with proper credentials for the Kubernetes cluster).

To make it easier to run Spark on Kubernetes with UIF, DSS features a “managed Spark on Kubernetes” mode. In that mode, DSS can automatically generate temporary service accounts for each job, pass these temporary credentials to the Spark job, and delete the temporary service account after the job is complete.

In Kubernetes, the granularity of security is the namespace: if a service account has the right to create pods in a namespace, it is theoretically possible for it to gain all privileges on that namespace. Therefore, it is recommended to use one namespace per user (or one namespace per team). The “managed Spark on Kubernetes” mode can automatically create dynamic namespaces, and associate service accounts to namespaces. This requires that the account running DSS has credentials on the Kubernetes cluster that allow it to create namespaces.

---

## [user-isolation/capabilities/local-code]

# Local code isolation

Local code isolation is the fundamental component of User Isolation Framework.

Each time a user submits code to be executed by DSS, DSS will use _sudo_ to execute the code as this end-user. Standard UNIX permissions and isolation guarantee that the user cannot access any forbidden information in the DSS data dir.

---

## [user-isolation/capabilities/oracle]

# Impersonation on Oracle

It is possible to configure the Oracle DSS connection to authenticate to the database using one Oracle account, and perform all data manipulation and SQL queries using another. This typically allows DSS to impersonate its end-users when accessing the database.

See [Oracle](<../../connecting/sql/oracle.html>) for more details.

---

## [user-isolation/capabilities-summary]

# Capabilities of User Isolation Framework

Feature | Without UIF | With UIF  
---|---|---  
Access control on projects | Yes | Yes  
Access control on connections | Yes | Yes  
Enforcement of permissions to execute code | Yes | Yes  
Per-user credentials on SQL connections. | No | Yes  
Impersonation on Oracle. | No | Yes  
Impersonation on Microsoft SQL Server | No | Yes  
Execution of “regular” code (Python, R) locally | Not isolated | Isolated  
Execution of “regular” code (Python, R) on Kubernetes | Isolated | Isolated  
Execution of Spark code (Python, R, Scala) on YARN | Not isolated | Isolated  
Execution of Spark code (Python, R, Scala) on Kubernetes | Not isolated | Isolated  
Connecting to secure Hadoop clusters (Kerberos). | Yes | Yes  
HDFS ACLs to enforce permissions even against code execution | No | Yes  
Authentication against LDAP directory | Yes | Yes  
Authentication with Single-Sign-On | Yes | Yes  
Traceability of all actions, including code execution | Yes | Yes  
Non-repudiable audit log | No | Yes  
Hadoop-level traceability of individual actions. (Cloudera Navigator, Atlas, …) | No | Yes  
  
See the [comparison of Dataiku DSS editions](<https://www.dataiku.com/dss/editions/>) to determine what levels of security apply to your installation.

---

## [user-isolation/concepts]

# Concepts

## The fundamental layer

The User Isolation Framework is made of a number of isolation capabilities that depend on the context. For example, if you have a “traditional” Hadoop cluster (like Cloudera or Hortonworks), you’ll want to leverage the Hadoop (HDFS, YARN, Hive, Impala) impersonation capability.

However, whatever the context, it is mandatory to deploy at least the “local code isolation” capability of the UIF. Without this fundamental layer in place, any user who has the permission to run code locally could take over the `dssuser` and bypass the various other isolation capabilities.

The local code isolation capability of the UIF requires the ability for the `dssuser` user to “become” other users. This is done by leveraging _sudo_.

## Means of isolation

In many cases, UIF requires the ability for the `dssuser` user to “become” other users. This is called _impersonation_ , and is done by leveraging multiple mechanisms:

  * For local code isolation (Python, R, Shell) which executes on the DSS host, DSS uses the _sudo_ mechanism

  * For Hadoop and Spark code, executing on YARN cluster, and access to HDFS data, DSS uses a feature of Hadoop called _proxy user_ which allows an authenticated `dssuser` to submit work to the cluster on behalf of another user.

  * For some SQL databases, UIF leverages native impersonation capabilities of the database




In some other cases, isolation does not require impersonation. For example, when executing code using Docker, a fundamental property of Docker is that each container is independent and cannot access other containers. This ensures that the code running in one container is _isolated_ from code running in another container without a specific need for _impersonation_.

## Identity mapping

One of the main challenges of the User Isolation Framework is the ability to collaborate. In a too simple UIF setup, when a dataset D is built by user A, another user B wouldn’t be able to override it since the files belong to A.

When UIF is enabled, DSS goes to great lengths to ensure that collaboration abilities are preserved. It makes “full” impersonation possible, meaning that each end-user connecting to DSS is impersonated to its corresponding underlying Hadoop / UNIX user.

DSS also supports more complex mappings of “DSS end-user” to “UNIX/Hadoop user”. For example, you could declare:

  * When working on project A, all users (who have access to project A in DSS) will see their jobs executed as user “projectA” on UNIX/Hadoop

  * When working on project B, all users (who have access to project B in DSS) will see their jobs executed as user “projectB” on UNIX/Hadoop

  * In all other cases, users are impersonated on a 1-to-1 basis.




There are several use cases for this kind of advanced mapping:

  * If not all your end-users have UNIX accounts (since this is required for them to run jobs)

  * In some cases, to strengthen security. For example, in a case where users U1 and U2 must collaborate on a project, U1 being very privileged and U2 having low privileges. Since both users collaborate on a project, U2 can write code that U1 will later execute. If U1 is not careful and does not check the code written by U2, this code will run with its higher privileges. In the case where U2 is hostile, this leaves more burden on U1 to verify the code written by U2. By mapping both users to a per-project user and restricting the “project” user to project-specific resources, you can eliminate this risk.

---

## [user-isolation/index]

# User Isolation

Note

User Isolation Framework was previously called Multi-User-Security.

Note

If using [Dataiku Cloud Stacks](<../installation/index.html>) installation, User Isolation is automatically managed for you, and you do not need to follow these instructions

Note

If using [Dataiku Cloud](<../installation/index.html>), User Isolation is automatically managed for you, and you do not need to follow these instructions

On an out-of-the-box installation of DSS, every action performed by DSS is performed as a single account on the host machine. This account which runs the DSS service is called the `dssuser`. For example, when a DSS end-user executes a code recipe, it runs as the UNIX `dssuser`

Similarly:

  * Every action performed on a Hadoop cluster is performed by the `dssuser` service account. When a DSS end-user executes an Hadoop/Spark recipe or notebook on a Hadoop cluster, it runs on the cluster as the Hadoop `dssuser`.

  * Every action performed on Kubernetes is initialized through the `dssuser` service account

  * Actions performed on external databases use the credentials configured in the database connection.




This default behavior has several limitations:

  * There is a lack of traceability on the Hadoop clusters to identify which user performed which action.

  * If the DSS end-user is hostile and has the permission to execute “unsafe” code, he can run arbitrary code as UNIX `dssuser` and modify the DSS configuration




DSS features a set of mechanisms to isolate code which can be controlled by the user, so as to guarantee both traceability and inability for a hostile user to attack the `dssuser`. Together, these mechanisms form the _User Isolation Framework_.

The User Isolation Framework is not a single technology but a set of capabilities that permit isolation depending on the context. Most of the components of the User Isolation Framework imply that DSS _impersonates_ the end-user and runs all user-controlled code under different identities than `dssuser`.

This documentation includes a number of reference architectures showing common deployments of the various UIF components.

Note

The User Isolation Framework may require specific editions of DSS. Please contact your Account Executive for any further information

---

## [user-isolation/initial-setup]

# Initial Setup

Warning

This document only covers the initial setup of the local code isolation capability of the User Isolation Framework. Additional components will generally be required. Please refer to the adequate reference deployments and capabilities details.

In the rest of this document:

  * `dssuser` means the UNIX user which runs the DSS software

  * `DATADIR` means the directory in which DSS is running




## Prerequisites and required information

Please read carefully the [Prerequisites and limitations](<prerequisites-limitations.html>) documentation and check that you have all required information.

The most important parts here are:

  * Having a keytab for the `dssuser`

  * Having administrator access to the Hadoop cluster

  * Having root access to the local machine

  * Having an initial list of end-user groups allowed to use the impersonation mechanisms.




## Perform a regular DSS installation

  * Perform a regular DSS installation. See [Installing a new DSS instance](<../installation/custom/initial-install.html>).

  * If needed, setup integration with your secure Hadoop cluster. See [Setting up Hadoop integration](<../hadoop/installation.html>) and [Connecting to secure clusters](<../hadoop/secure-clusters.html>).

  * If needed, setup integration with Spark. See [Setting up Spark integration](<../spark/installation.html>).




Note

It is possible to setup Spark integration after setting up UIF, but this require more manual work so we strongly recommend that you start by setting up Spark integration.

## Initialize UIF

  * As `dssuser`, stop DSS



    
    
    % cd DATADIR
    % ./bin/dss stop
    

  * As `root`, run, from `DATADIR`



    
    
    ./bin/dssadmin install-impersonation dssuser
    

Please pay attention to the messages emitted by this procedure. In particular, you might need to manually add a snippet to your `sudoers` configuration.

As `root`, edit the `/etc/dataiku-security/INSTALL_ID/security-config.ini` file. In the `[users]` section, fill in the `allowed_user_groups` settings with the list of UNIX groups that your end users belong to. Only users belonging to these groups will be allowed to use the local code impersonation mechanism.

INSTALL_ID is a long string of random characters. One INSTALL_ID is created for each installation of DSS, so if you have several installations of DSS on the machine, you may have several folders in `/etc/dataiku-security`. To find out the INSTALL_ID of your DSS instance, look into the `DATADIR/install.ini` file. You’ll find a `installid` line which is your INSTALL_ID.

### Additional setup for local filesystem access

The `/etc/dataiku-security/INSTALL_ID/security-config.ini` contains configuration keys in section `[dirs]` to ensure that only those subdirectories of the local host which pertain to the DSS installation can be modified by the DSS subprocesses which run with elevated privileges:

  * `dss_datadir` : should contain the absolute path to the DSS data directory. This key is automatically set by the install-impersonation step.

  * `additional_allowed_file_dirs` : this key is initially empty. It should be set to the list of local subdirectories which DSS is allowed to access _outside_ the DSS data directory, including:

    * any local subdirectory configured as a local filesystem connection

    * any cgroup subdirectory configured for DSS resource control management (see [Using cgroups for resource control](<../operations/cgroups.html>)).




## Configure filesystem access on the DSS folders

You need to ensure that all end-user groups have read-only access to:

  * The DSS datadir (including all parent folders)

  * The DSS installation directory (including all parent folders)




`dssadmin install-impersonation` automatically sets up 711 permission on the DSS datadir, but you might need to ensure proper access to parent folders.

## Configure identity mapping

  * As `dssuser`, start DSS.

  * Log in as a DSS administrator, and go to Administration > Settings > Security & Audit > Other security settings.

  * DSS has been preconfigured with simple identity mapping rules (one-to-one both on users and groups).

  * You can choose to configure this with different rule types:

    * One-to-one mapping

    * Single user mapping

    * Pattern mapping

The matching pattern is a standard search-and-replace Java regular expression. `(...)` can be used to capture a substring in the DSS username, and `$1`, `$2`… mark the place where to insert these captured substrings in the UNIX username.

For example, configuring the following rule:

>       * Matching pattern: `([^@]*)@mydomain.com`
> 
>       * Replacement (UNIX): `$1`

would map the DSS user `first.last@mydomain.com` to the UNIX user `first.last`.

For more information, see [Concepts](<concepts.html>).

  * Save settings if needed.

---

## [user-isolation/prerequisites-limitations]

# Prerequisites and limitations

Note

This document only lists basic requirements for deploying the User Isolation Framework. Individual components may have additional requirements. Please refer to the detailed capabilities and reference architectures sections for more details.

## Prerequisites

### Local machine

This setup is mandatory for all deployments of UIF.

  * ACL support must be enabled on the filesystem which hosts the DSS data directory

  * You need root access to setup the User Isolation Framework




For each UNIX user which will be impersonated by the DSS end-user (see [Concepts](<concepts.html>) for more details), the following requirements must be met:

  * The user must have a valid UNIX account.

  * The user must have a valid shell (ie, must be able to perform shell actions).

  * The user must have a writable home directory on HDFS.




Each group of users in DSS should have a matching UNIX group of users locally.

### Hadoop

Isolation framework capabilities are available on Cloudera CDP

The following configuration is required on your Hadoop cluster:

  * Kerberos security must be enabled.

  * You need a keytab for the `dssuser`, as described in [Connecting to secure clusters](<../hadoop/secure-clusters.html>)

  * You need administrator access to your Hadoop cluster to setup user isolation (to setup the DSS impersonation authorization)




If you want to leverage Hive:

  * You must have Ranger enabled

  * HiveServer2 impersonation must be disabled (this is the default setting)




DSS can work with a restricted-access Hive metastore (ie, when only HiveServer2 can talk to the Metastore server), but due to limitations in Spark, a restricted-access metastore will disable the following features:

  * Using a HiveContext in Spark code recipes (SQLContext remains available)

  * Using table definitions from the Hive metastore in Spark code recipes (including SparkSQL)

  * Running some visual recipes on Spark (since they require HiveContext-only features)




See [Impala](<../hadoop/impala.html>), [DSS and Spark](<../spark/index.html>) and [Hive](<../hadoop/hive.html>) for more information.

For each Hadoop which will be impersonated by the DSS end-user (see [Concepts](<concepts.html>) for more details), the following requirements must be met:

  * The user must have a writable home directory on HDFS




Each group of users in DSS should have a matching group of users on Hadoop.

### LDAP

While manual configuration of all user accounts is fully possible, we recommend that you use a LDAP directory to have a unique source of truth for all users and group mappings, in DSS, on UNIX, and on Hadoop.

### DSS

Migrating a DSS instance which was previously running without UIF is highly not recommended. We highly recommend starting with an empty DSS instance when setting up UIF.

“Downgrading” a DSS instance by disabling UIF is not supported.

### Required information

In addition to the above prerequisites, you need to gather some information.

You will need to obtain an initial list of UNIX groups that your end users belong to. Only users belonging to these groups will be allowed to use the impersonation mechanisms.

## Limitations

### Unsafe features

When UIF is enabled, the following features are not available for end-users unless they have the “Write unsafe code” permission:

  * Write custom partition dependency functions

  * Write Python UDF in data preparation




For more information about the “Write unsafe code” permission, see [Write unisolated code: details](<../security/permissions.html#security-permissions-write-unsafe-code>)

### HDFS datasets

Write in “append” mode in a HDFS dataset can only be done if you always use the same end-user. Append by multiple Hadoop end-users is not supported.

---

## [user-isolation/reference-architectures/cloudera]

# Setup with Cloudera

This reference architecture will guide you through deploying on your DSS connected to your Cloudera:

  * The fundamental local isolation code layer

  * Impersonation for accessing HDFS datasets

  * Impersonation for running Spark code over Yarn

  * Impersonation for accessing Hive and Impala




In the rest of this document:

  * `dssuser` means the UNIX user which runs the DSS software

  * `DATADIR` means the directory in which DSS is running




## The two modes

There are two major ways to deploy UIF on Cloudera. The difference lies in how authorization is propagated on HDFS datasets

  * Using Ranger. In this mode, Ranger will manage all authorization on HDFS data, both at the raw HDFS level and Hive/Impala level

  * Using “DSS-managed ACL synchronization”. DSS will place HDFS ACLs on the managed datasets that it builds. Note that you will also need to leverage Ranger ACLs for Hive/Impala level.




**We recommend that you use Ranger preferably to DSS-managed ACLs**. Ranger lives in the NameNode and has more pervasive and flexible access, implying fewer limitations than DSS-managed ACLs. The three main advantages of using Ranger mode are:

  * Centralized authorization in Ranger rather than requiring managing Ranger rules in addition to the HDFS ACLs.

  * For some customer deployments, working around limitations in number of HDFS ACLs (the default DSS-managed ACLs require a larger number of ACLs per path, which can overflow the limit to 32 ACLs per path in HDFS)

  * Appending in HDFS datasets using multiple users becomes possible.




## Prerequisites and required information

Please read carefully the [Prerequisites and limitations](<../prerequisites-limitations.html>) documentation and check that you have all required information.

The most important parts here are:

  * Having a keytab for the `dssuser`

  * Having administrator access to the Cloudera cluster

  * Having root access to the local machine

  * Having an initial list of end-user groups allowed to use the impersonation mechanisms.




## Common setup

Initialize UIF (including local code isolation), see [Initial Setup](<../initial-setup.html>)

## Ranger-mode

### Assumptions

In this model (as in the default DSS-managed-ACLs one btw) the security boundary is that of the Hive database. There should be at least one Hive database per security tenant (ie set of different authorization rules). Within a given Hive database, all tables (and thus all DSS datasets) have by default the same authorization rules as the database itself.

In this model, each Hive database maps to a base directory of the HDFS filesystem. All datasets within this database are stored into a subdirectory of this base directory.

Authorization rules are defined in Ranger (Hive) at the database level and in Ranger (HDFS) at the folder level.

DSS HDFS connections can be set up to map DSS projects to these security tenants in several ways, depending on the application constraints, in particular:

  * one DSS connection per tenant

  * several tenants per connection, multiple projects per security tenant




### Configure your Cloudera cluster

Note

This part must be performed by the Hadoop administrator. A restart of your Cloudera cluster may be required.

You now need to allow the `dssuser` user to impersonate all end-user groups that you have previously identified.

This is done by adding `hadoop.proxyuser.dssuser.groups` and `hadoop.proxyuser.dssuser.hosts` configuration keys to your Hadoop configuration (core-site.xml). These respectively specify the list of groups of users which DSS is allowed to impersonate, and the list of hosts from which DSS is allowed to impersonate these users.

The `hadoop.proxyuser.dssuser.groups` parameter should be set to a comma-separated list containing:

  * A list of end-user groups which collectively contain all DSS users

  * The group with which the `hive` user creates its files (generally: `hive` on Cloudera, `hadoop` on HDP)

  * In addition, on Cloudera, the group with which the `impala` user creates its files (generally: `impala`)




Alternatively, this parameter can be set to `*` to allow DSS to impersonate all cluster users (effectively disabling this extra security check).

The `hadoop.proxyuser.dssuser.hosts` parameter should be set to the fully-qualified host name of the server on which DSS is running. Alternatively, this parameter can be set to `*` to allow all hosts (effectively disabling this extra security check).

Make sure Hadoop configuration is properly propagated to all cluster hosts and to the host running DSS. Make sure that all relevant Hadoop services are properly restarted.

#### Do it with Cloudera Manager

(NB: This information is given for information purpose only. Please refer to the official Cloudera documentation for your Cloudera version)

  * In Cloudera Manager, navigate to HDFS > Configuration and search for “proxyuser”

  * Add two new keys in the “Cluster-wide Advanced Configuration Snippet (Safety Valve) for core-site.xml” section.

    * Name: `hadoop.proxyuser.dssuser.groups`

    * Value: comma-separated list of Hadoop groups of your end users, plus hive, impala

    * Name: `hadoop.proxyuser.dssuser.hosts`

    * Value: fully-qualified DSS host name, or `*`

  * Save changes

  * At the top of the HDFS page, click on the “Stale configuration: restart needed” icon and click on “Restart Stale Services” then “Restart now”




#### Setup Ranger

  * Create one or several root directories for DSS output directories.

  * For each security tenant which you want DSS to use:

>     * create the database in HiveServer2
>
>> beeline> CREATE DATABASE <db_name> LOCATION 'hdfs://<namenode>/<path_to_dir>';
>>           
> 
>     * grant access to the database in Ranger (Hive)
> 
>     * grant access to the folder in Ranger (HDFS)




#### Additional setup for Impala

If you plan on using Impala, you must perform an additional setup because Impala does not use the regular proxyuser mechanism.

  * In Cloudera Manager, go to Impala > Configuration

  * In the Impala Daemon Command Line Argument Advanced Configuration Snippet (Safety Valve) setting, add: `authorized_proxy_user_config=dssuser=enduser_1,enduser_2,...`, where `enduser_xx` is the Hadoop name of a DSS user, or `*` for all




Note

Contrary to the rest of Hadoop, the Impala impersonation authorization list is user-based, not group-based, which means that in many cases the only practical configuration is to use `*` and allow DSS to impersonate all Impala users.

#### Additional setup for encrypted HDFS filesystems

If DSS should access encrypted HDFS filesystems on behalf of users, you need to add specific Hadoop configuration keys to authorize impersonated access to the associated key management system (KMS):

  * `hadoop.kms.proxyuser.dssuser.groups` : comma-separated list of Hadoop groups of your end users

  * `hadoop.kms.proxyuser.dssuser.hosts` : fully-qualified DSS host name, or `*`




### Setup driver for Impala

If you want to use Impala, you need to install the Cloudera Impala JDBC Driver.

Download the driver from Cloudera Downloads website. You should obtain a Zip file `impala_jdbc_VERSION.zip`, containing two more Zip files. Unzip the “JDBC 4.1” version of the driver (the “JDBC 4” version will not work).

Copy the `ImpalaJDBC41.jar` file to the `lib/jdbc` folder of DSS. Beware, you must not copy other JARs. Restart DSS.

### Setup HDFS connections in DSS

Configure DSS managed HDFS connection(s) so that:

>   * Hive database for datasets map to one of the databases defined above
> 
>   * HDFS paths for datasets map to the matching location for this database
> 
>   * Management of HDFS ACLs by DSS is turned off (ACL synchronization mode: None)
> 
> 


### Configure identity mapping

If needed, go to Administration > Settings > Security and. update identity mapping.

Note

Due to various issues notably related to Spark, we strongly recommend that your DSS users and Hadoop users have the same name.

### Setup Hive and Impala access

  * Go to Administration > Settings > Hive

  * Fill in the HiveServer2 host and principal if needed, as described in [Connecting to secure clusters](<../../hadoop/secure-clusters.html>)

  * Fill in the “Hive user” setting with the name of the user running HiveServer2 (generally: `hive`)

  * Switch “Default execution engine” to “HiveServer2”




If you plan to use Impala:

  * Go to Administration > Settings > Impala

  * Fill in the Impala hosts and principal if needed, as described in [Connecting to secure clusters](<../../hadoop/secure-clusters.html>)

  * Fill in the “Impala user” setting with the name of the user running impalad (generally: `impala`)

  * Check the “Use Cloudera Driver” setting




### Authorization models

There are several possible deployments of the above model, depending on the desired authorization and management model:

#### One DSS connection per database

  * directly configure the database name in “Hive database”

  * add the DSS project key to the table names, as in : “Hive table name prefix” = `${projectKey}_`

  * root path URI : path to database directory

  * Path prefix: `${projectKey}/`

  * optionally, you can restrict access to this DSS connection to its authorized DSS users, so the other ones do not see it at all




#### One database per DSS project, multiple databases per DSS connection

  * Embed the DSS project key the Hive database name, as in: “Hive database” = `dataiku_${projectKey}`

  * Hive table name prefix can then be empty

  * Root path URI must be a common parent to all database directories

  * Embed the DSS project key in the HDFS path prefix, as in: “Path prefix” = `${projectKey}/`

  * You need to create each database using the above command sequence from an admin account when creating a DSS project




#### More complex setups

More complex setups are possible using per-project variables, typically representing the security tenant to use for a given project, and expanding these variables in the database name or path prefix

## DSS-ACL-synchronization-mode

Note

In most cases, we recommend that you preferably use Ranger mode as detailed above

Warning

HDFS ACLs are not supported for [Per-project single user permissions](<../../security/permissions.html#per-project-single-user-permissions>).

### Configure your Cloudera cluster

Note

This part must be performed by the Cloudera administrator. A restart of your Cloudera cluster may be required.

You now need to allow the `dssuser` user to impersonate all end-user groups that you have previously identified.

This is done by adding `hadoop.proxyuser.dssuser.groups` and `hadoop.proxyuser.dssuser.hosts` configuration keys to your Hadoop configuration (core-site.xml). These respectively specify the list of groups of users which DSS is allowed to impersonate, and the list of hosts from which DSS is allowed to impersonate these users.

The `hadoop.proxyuser.dssuser.groups` parameter should be set to a comma-separated list containing:

  * A list of end-user groups which collectively contain all DSS users

  * The group with which the `hive` user creates its files (generally: `hive` on Cloudera, `hadoop` on HDP)

  * In addition, on Cloudera, the group with which the `impala` user creates its files (generally: `impala`)




Alternatively, this parameter can be set to `*` to allow DSS to impersonate all cluster users (effectively disabling this extra security check).

The `hadoop.proxyuser.dssuser.hosts` parameter should be set to the fully-qualified host name of the server on which DSS is running. Alternatively, this parameter can be set to `*` to allow all hosts (effectively disabling this extra security check).

Make sure Hadoop configuration is properly propagated to all cluster hosts and to the host running DSS. Make sure that all relevant Hadoop services are properly restarted.

#### Do it with Cloudera Manager

(NB: This information is given for information purpose only. Please refer to the official Cloudera documentation for your Cloudera version)

  * In Cloudera Manager, navigate to HDFS > Configuration and search for “proxyuser”

  * Add two new keys in the “Cluster-wide Advanced Configuration Snippet (Safety Valve) for core-site.xml” section.

    * Name: `hadoop.proxyuser.dssuser.groups`

    * Value: comma-separated list of Hadoop groups of your end users, plus hive, impala

    * Name: `hadoop.proxyuser.dssuser.hosts`

    * Value: fully-qualified DSS host name, or `*`

  * Save changes

  * At the top of the HDFS page, click on the “Stale configuration: restart needed” icon and click on “Restart Stale Services” then “Restart now”




#### Additional setup for Impala

If you plan on using Impala, you must perform an additional setup because Impala does not use the regular proxyuser mechanism.

  * In Cloudera Manager, go to Impala > Configuration

  * In the Impala Daemon Command Line Argument Advanced Configuration Snippet (Safety Valve) setting, add: `authorized_proxy_user_config=dssuser=enduser_1,enduser_2,...`, where `enduser_xx` is the Hadoop name of a DSS user, or `*` for all




Note

Contrary to the rest of Hadoop, the Impala impersonation authorization list is user-based, not group-based, which means that in many cases the only practical configuration is to use `*` and allow DSS to impersonate all Impala users.

#### Additional setup for encrypted HDFS filesystems

If DSS should access encrypted HDFS filesystems on behalf of users, you need to add specific Hadoop configuration keys to authorize impersonated access to the associated key management system (Hadoop KMS or Ranger KMS):

  * `hadoop.kms.proxyuser.dssuser.groups` : comma-separated list of Hadoop groups of your end users

  * `hadoop.kms.proxyuser.dssuser.hosts` : fully-qualified DSS host name, or `*`




### Setup driver for Impala

If you want to use Impala, you need to install the Cloudera Impala JDBC Driver.

Download the driver from Cloudera Downloads website. You should obtain a Zip file `impala_jdbc_VERSION.zip`, containing two more Zip files. Unzip the “JDBC 4.1” version of the driver (the “JDBC 4” version will not work).

Copy the `ImpalaJDBC41.jar` file to the `lib/jdbc` folder of DSS. Beware, you must not copy other JARs. Restart DSS.

### Configure identity mapping

If needed, go to Administration > Settings > Security and update identity mapping.

Note

Due to various issues notably related to Spark, we strongly recommend that your DSS users and Hadoop users have the same name.

### Setup Hive and Impala access

  * Go to Administration > Settings > Hive

  * Fill in the HiveServer2 host and principal if needed, as described in [Connecting to secure clusters](<../../hadoop/secure-clusters.html>)

  * Fill in the “Hive user” setting with the name of the user running HiveServer2 (generally: `hive`)

  * Switch “Default execution engine” to “HiveServer2”




If you plan to use Impala:

  * Go to Administration > Settings > Impala

  * Fill in the Impala hosts and principal if needed, as described in [Connecting to secure clusters](<../../hadoop/secure-clusters.html>)

  * Fill in the “Impala user” setting with the name of the user running impalad (generally: `impala`)

  * Check the “Use Cloudera Driver” setting




### Initialize ACLs on HDFS connections

Go to the settings of the `hdfs_managed` connection. Click on `Resync Root permissions`

If you have other HDFS connections, do the same thing for them.

## Validate behavior

  * Grant to at least one of your user groups the right to create projects

  * Log in as an end user

  * Create a project with key `PROJECTKEY`

  * As a Hive administrator, create a database named `dataiku_PROJECTKEY` and use Sentry to grant to the end-user group the right to use this database. Details on how to do that are in the “Setup Sentry” section above

  * As the end user in DSS, check that you can:
    
    * Create external HDFS datasets

    * Create prepare recipes writing to HDFS datasets

    * Synchronize datasets to the Hive metastore

    * Create Hive recipes to write new HDFS datasets

    * Use Hive notebooks

    * Create Python recipes

    * Use Python notebooks

    * Create Spark recipes

    * If you have Impala, create Impala recipes

    * If you have Impala, use Impala notebooks

    * Create visual recipes and use all available execution engines




## Operations (Ranger mode)

When you follow these setup instructions and use Ranger mode, DSS starts with a configuration that enables a per-project security policy with minimal administrator intervention.

### Overview

  * The HDFS connections are declared as usable by all users.

  * Each project writes to a different HDFS folder.

  * Each project writes to a different Hive database.

  * Ranger rules grant permissions on the folder and database




The separation of folders and Hive database for each project are ensured by the naming rules defined in the HDFS connection.

Note

This default configuration should be usable by all, we recommend that you keep it.

### Adding a project

In that setting, adding a project requires adding a Hive database and granting permissions to the project’s groups on the database.

  * Create the project in DSS

  * Add the groups who must have access to the project




By default, the new database is called `dataiku_PROJECTKEY` where `PROJECTKEY` is the key of the newly created project. You can configure this in the settings of each HDFS connection.

As Hive administrator:

  * As Hive administrator, using beeline or another Hive client, create the database

  * As the Ranger administrator, perform the grants at both Hive and HDFS level




### Adding/Removing a user in a group

Grants are group-level, so no intervention is required when a user is added to a group.

### Adding / Removing access to a group

When you add project access to a group, you need to:

  * Do the permission change on the DSS project

  * Do the permission changes in Ranger




### Interaction with externally-managed data

In the Ranger setup, DSS does not manage any ACLs. It is the administrator’s responsibility to ensure that read ACLs on these datasets are properly set.

#### Existing Hive table

If externally-managed data has an existing Hive table, and no synchronization to the Hive metastore, you need to ensure that Hive-level permissions (Ranger) allow access to all relevant groups.

#### Synchronized Hive table

Even on read-only external data, you can ask DSS to synchronize the definition to the Hive metastore. In that case, you need to ensure that the HDFS-level permissions allow the Hive (and maybe Impala) users to access the folder.

## Operations (ACL synchronization mode)

We recommend that you favor Ranger mode.

---

## [user-isolation/reference-architectures/index]

# Reference architectures

Obtaining a complete working and secure deployment of the different components of the User Isolation Framework adapted to your particular setup can be a complex task.

These reference architectures are meant to provide you with end-to-end ready-to-use deployment instructions for the most common setups. In some cases, it may be needed to combine several them if you use several of the technologies described thereafter.

Your Dataiku Sales Engineer or Customer Success Manager is ready to help for any specific deployment questions.

---

## [user-isolation/reference-architectures/kubernetes]

# Setup with Kubernetes

This reference architecture will guide you through deploying on your DSS running some workloads on Kubernetes.

This applies both to “static” Kubernetes clusters and “dynamic / managed by DSS” Kubernetes clusters.

This document covers:

  * The fundamental local isolation code layer

  * Security for running “regular” workloads on Kubernetes (Python, R, Machine Learning)

  * Security for running Spark workloads on Kubernetes




In the rest of this document:

  * `dssuser` means the UNIX user which runs the DSS software

  * `DATADIR` means the directory in which DSS is running




## Initial setup

Please read carefully the [Prerequisites and limitations](<../prerequisites-limitations.html>) documentation and check that you have all required information.

## Common setup

Initialize UIF (including local code isolation), see [Initial Setup](<../initial-setup.html>)

## Running regular workloads

When you run non-Spark workloads on Kubernetes, the Kubernetes job is always started by the `dssuser`. The `dssuser` requires the ability to connect and create pods and secrets on your Kubernetes cluster.

However, once the user’s code has been started, a fundamental property of Kubernetes is that each container is independent and cannot access others. Thus, code running in one container is _isolated_ from code running in another container without a specific need for impersonation.

No further setup is thus required for running regular workloads securely on Kubernetes.

## Running Spark workloads

When you run Spark workloads on Kubernetes, DSS uses the _sudo_ mechanism of the local code isolation capability to start the `spark-submit` process running the Spark driver under the identity of the end-user. This driver process then sends control orders to Kubernetes in order to start pods for the Spark executor.

In other words, the Spark driver requires access to the Kubernetes API but runs untrusted code. This requires that each impersonated end-user has credentials to access Kubernetes. While this deployment is completely possible, it is not typically the case (each user needs to have a `~/.kube/config` file with proper credentials for the Kubernetes cluster).

To make it easier to run Spark on Kubernetes with UIF, DSS features a “managed Spark on Kubernetes” mode. In that mode, DSS can automatically generate temporary service accounts for each job, pass these temporary credentials to the Spark job, and delete the temporary service account after the job is complete.

In Kubernetes, the granularity of security is the namespace: if a service account has the right to create pods in a namespace, it is theoretically possible for it to gain all privileges on that namespace. Therefore, it is recommended to use one namespace per user (or one namespace per team). The “managed Spark on Kubernetes” mode can automatically create dynamic namespaces, and associate service accounts to namespaces. This requires that the account running DSS has credentials on the Kubernetes cluster that allow it to create namespaces.

### One-namespace-per-user setup

  * In the Spark configuration, enable the “Managed K8S configuration” checkbox

  * In “Target namespace”, enter something like `dss-ns-${dssUserLogin}`

  * Enable “Auto-create namespace”

  * Set Authentication mode to “Create service accounts dynamically”




Each time a user U starts a Job that uses this particular Spark configuration, DSS will:

  * Create if needed the `dss-ns-U` namespace

  * Create a service account, and grant it rights limited to `dss-ns-U`

  * Get the secret of this service account and pass it to the Spark driver

  * The Spark driver will use this secret to create and manage pods in the `dss-ns-U` namespace (but does not have access to any other namespace)

  * At the end of the job, destroy the service account




### One-namespace-per-team setup

  * In the Spark configuration, enable the “Managed K8S configuration” checkbox

  * In “Target namespace”, enter something like `${adminProperty:k8sNS}`

  * Set Authentication mode to “Create service accounts dynamically”




Then, for each user, you need to set an “admin property” named `k8sNS`, with the name of the team namespace to use for this user. This can be automated through the API. See above for how this will work.

With this setup, there may be a fixed number of namespaces so you don’t need to auto-create namespaces. The account running Dataiku only needs full access to these namespaces in order to create service accounts in them. This can be useful if you don’t have the ability to create namespaces. However, this leaves the possibility that skilled hostile users can try to attack other Spark jobs running in the same namespace.

---

## [user-isolation/reference-architectures/local-code-only]

# Local-code only

Use this reference architecture if you don’t need any kind of cluster security (Hadoop, Spark, Kubernetes).

---

## [user-isolation/troubleshooting]

# Troubleshooting

## sudo failed (exit code 1) when UIF is enabled and devtoolset-8 is installed

If devtoolset-8 is installed on your instance and you are using UIF, devtoolset-8 will include a non-compatible sudo in the default PATH. Note that if you recently installed [prophet](<../R/prophet.html>) you may encounter this error due to upgrading to devtoolset-8 in order to install the package. If you are using UIF and devtoolset-8 and receive a sudo error, you can force the use of the default sudo with the following steps:

Stop DSS:
    
    
    ./DATADIR/bin/dss stop
    

Edit your `DATADIR/install.ini` file and add the entry:
    
    
    [mus]
    custom_root_sudo = ["/usr/bin/sudo"]
    

Start DSS:
    
    
    ./DATADIR/bin/dss start