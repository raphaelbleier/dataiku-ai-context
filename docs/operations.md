# Dataiku Docs — operations

## [operations/audit-trail/apinode]

# Configuration for API nodes

A major use case for audit centralization is to centralize logs of API node queries in order to perform ML Ops activities on these logs (analyzing predictions, performing input data drift, or model performance drift).

## Automatic configuration through API deployer

The API deployer can automatically configure the audit dispatcher in the API nodes (both static and K8S infrastructures). This allows automatically configuring the API nodes so that they centralize their audit to a central DSS location.

### Automatic send to event server

At the infrastructure or deployment level, you define the URL of the event server, and its authentication key At the deployment level, you define a routing key for this deployment.

The API node will then dispatch all `apinode-query` audit events with this routing key to this event server, which will in turn by default write it into a folder-per-routing key, hence reaching our goal of having clean access to the logs of this API node only.

## Sample setup: easy case

This sample setup shows you the easiest way to perform centralization of API node logs. Use this for as-simple-as-possible setup, when you don’t need strong security around the logs of a service (i.e. it is not a problem if the engineers of Service1 can see the logs of Service2).

The main advantage of this setup is that no admin intervention is required when new API services are created and deployed. Admin intervention is only required once at install time.

### Setup once (as admin)

>   * Install a design node, enable the EventServer on it
> 
>   * Add a “files in connection” target on the event server
>     
>     * Set topics filtering to `apinode-query`
> 
>     * Set routing keys filtering to `All`
> 
>     * Enable creation of subfolders
> 
>     * Select any compatible file-like connection like S3
> 
>   * In the API deployer infrastructure, enable “auto-configure reporting to event server”, enter just the URL of the event server
> 
> 


### For each service (as user)

>   * Write your service, publish it to the API deployer
> 
>   * In the API deployer deployment, fill in the “routing key”. Just the deployment id is an appropriate routing key. It just needs to be unique.
> 
>   * Start sending queries
> 
>   * In your MLOps project, create a new dataset on the connection that has been selected by the admin, browse to the `path/apinode-query/your-routing-key`
> 
>   * Enable partitioning on this dataset
> 
>   * Voila, you have the partitioned logs of just this service, across all API node instances
> 
> 


### Behind the scenes

  * The API node emits audit events with `apinode-query` topic and with the routing key specified in the deployment settings

  * The audit log of each API node is configured to send apinode-query/this-routing-key to the eventserver

  * The eventserver receives them, dispatches on the “files in connection” target which creates subfolders per topic and routing key




## Sample setup: high-security API node centralization

Use this when you need to have differentiated security for accessing the nodes of individual API services. It also ensures that people who don’t have access to the deployment cannot send “fake” events for this deployment

### Setup once (as admin)

>   * Install a design node, enable the EventServer on it
> 
>   * Require authentication on events in the EventServer settings
> 
> 


### For each service (as admin)

>   * Generate a new authentication key (random string)
> 
>   * Add a “files in connection” target on the event server
>     
>     * Set topics filtering to `apinode-query`
> 
>     * Set routing keys filtering to only accept the routing key of the service
> 
>     * Enable creation of subfolders
> 
>     * Select any compatible file-like connection like S3
> 
>     * Add your authentication key to the list of valid authentication key for the events endpoint, and add it as the “required Auth key” for this event server destination
> 
>   * Give this service-specific authentication key to the developer of the service
> 
> 


### For each service (as user)

>   * Write your service, publish it to the API deployer
> 
>   * In the API deployer deployment settings, enable “override infrastructure settings” and enable “auto-configure reporting to event server”, enter the URL of the event server and the auth key
> 
>   * In the API deployer deployment, fill in the “routing key”. Just the deployment id is an appropriate routing key. It just needs to be unique.
> 
>   * Start sending queries
> 
>   * In your MLOps project, create a new dataset on the connection that has been selected by the admin, browse to the `path/apinode-query/your-routing-key` (you should not be able to browse other folders of course, this should be handled by connection security)
> 
>   * Enable partitioning on this dataset
> 
>   * Voila, you have the partitioned logs of just this service, across all API node instances
> 
> 


## Manual usage

Audit settings can be configured manually in the config/server.json file of the API node.

Here is a sample configuration:
    
    
    "auditLog": {
        "settings": {
            "targets": [
                {
                  "type": "EVENT_SERVER",
                  "url": "http://my-event-server:9999",
                  "routingKeyMode": "FROM_MESSAGE",
                  "topicsFiltering": "SELECTED",
                  "topics": [
                    "apinode-query"
                  ],
                  "routingKeysFiltering": "ALL",
                  "routingKeys": [
                    "rk-clvs-1"
                  ]
                }
            ]
        }
    }

---

## [operations/audit-trail/centralization-and-dispatch]

# Audit centralization and dispatch

In order to provide non-repudiation characteristics, it is important that the audit events are sent outside of the DSS machine, on a remote system that cannot be accessed and tampered with from the DSS machine.

Furthermore, there are multiple use cases for _centralizing_ audit logs from multiple DSS nodes in a single system.

Some of these use cases include:

  * Customers with multiple instances want a centralized audit log in order to grab information like “when did each user last do something”.

  * Customers with multiple instances want a centralized audit log in order to have a global view on the usage of their different audit nodes, and compliance with license

  * Compute Resource Usage reporting capabilities use the audit trail, and make more sense if fully centralized. You may want to cross that information with HR resources, department assignments, …

  * Most MLOps use case require centralized analysis of API node audit logs




DSS features a complete routing _dispatch_ mechanism for these use cases.

## Audit dispatching

Each message sent through the audit system carries a mandatory “topic” and an optional “routing key”.

The topic is given by the DSS code and cannot be controlled by the user. It is akin to a “category”. At the moment, the following topics exist:

>   * generic: Applicative audit of most events in DSS
> 
>   * generic-failure: Applicative audit of most failures in DSS
> 
>   * authfail: All authentication and authorization failure events
> 
>   * apinode-query: Applicative audit of API node queries and replies
> 
>   * compute-resource-usage: Audit of usage of compute resources
> 
>   * apicalls: Raw logging of API calls on private and public API (for debugging purposes mostly)
> 
> 


The routing key is optional, and allows more advanced dispatching. The routing key is also written in the audit message, for processing at destination. The main use case for routing keys is for apinode-query messages. Each apinode-query audit message is optionally emitted with a routing key specified in the service’s configuration. This allows differentiating and/or routing differently the apinode-query audit messages of each API node service.

Each time a DSS node creates an audit message, the message goes through the audit dispatcher to be sent to _audit targets_

Each target defines:

>   * What topics it accepts (or all)
> 
>   * What routing keys it accepts (or all)
> 
>   * Where it sends the events.
> 
> 


## Log4J target

This target sends data using the log4j library. By default, this library is preconfigured to generate the files mentioned in [Default storage of audit trail](<default-storage.html>).

Note

Dataiku DSS has been confirmed to be not vulnerable to the family of vulnerabilities regarding Log4J. No mitigation action nor upgrade is required. Dataiku does not use any affected version of Log4J, and keeps monitoring the security situation on all of its dependencies.

However, all log4j appenders can be used to get audit out of the DSS machine. Configuring log4j is done by editing the `resources/logging/dku-log4j.properties` file. (See [Logging in DSS](<../logging.html>) for more information)

## EventServer target

Most use cases of centralizing audit logs from multiple machines can be handled using the DSS Event Server.

For more details on how to install and configure the event server can be found in [The DSS Event Server](<eventserver.html>)

## Kafka target

Warning

**Tier 2 support** : Kafka target is experimental and covered by [Tier 2 support](<../../troubleshooting/support-tiers.html>)

If you have a Kafka connection defined in your node, you can configure a Kafka target.

---

## [operations/audit-trail/data]

# Audit data

Each audit event is a JSON message. You can parse DSS audit events using the “JSON” file format in DSS. We recommend setting a “max depth” of 2, 1 for the envelope and 1 for the actual data fields

## Events envelopes

Each audit event is a JSON message. Depending on how it was written, its form can be a bit different, as it can be wrapped in a different envelope.

### In standard audit log files

In standard audit log files (produced through log4j), events look like:
    
    
    {
        "severity": "INFO",
        "logger": "dku.audit.generic",
        "message": { "... The actual JSON message ..."},
        "mdc": {
            "apiCall": "/api/projects/get-summary",
            "user": "admin"
        },
        "callTime": 9,
        "timestamp": "2020-02-19T16:05:02.441+0100"
    }
    

  * severity can be ignored

  * logger will indicate the topic

  * mdc contains additional context information that will usually be repeated in the message

  * callTime indicates, for events sent during processing of a query, how long the current query had been running

  * timestamp is the ISO-8601-formatted timestamp at which it was processed




### In Event Server data files

Event Server data files are formulated like:
    
    
    {
        "clientEvent": { "... The actual JSON message ..."},
        "origAddress": "127.0.0.1",
        "serverTimestamp": "2020-03-17T19:15:30.609+0100"
    }
    

  * origAddress is the IP of the DSS node that sent the event to the Event Server

  * serverTimestamp is the ISO-8601-formatted timestamp at which it was received on the Event Server




## Event data

Each event is a single JSON object and will always contain at least a `msgType` indicating the precise message type. Additional fields depend on the msgType.

Most audit events will contain a `authUser` field indicating the user who performed the request

Some of the most important msgTypes are:

### For “generic” topic

>   * application-open: DSS was open in a browser tab
> 
>   * login/logout: self-explanatory
> 
>   * dataset-read-data-sample: A dataset’s Explore was open
> 
>   * dataset-read-data: Data was read for a dataset
> 
>   * flow-job-start / flow-job-done: A job was started/completed
> 
>   * flow-object-build-start / flow-object-build-failed / flow-object-build-success: Within a job, a dataset was built
> 
>   * scenario-run: A scenario was run manually
> 
>   * scenario-fire-trigger: A scenario was run automatically
> 
>   * project-export-download: A project was exported
> 
>   * dataset-export: A dataset was exported
> 
> 


### For “apinode-query” topic

>   * “prediction-query”: a prediction endpoint was run
> 
>   * “sql-query”: a SQL query endpoint was run
> 
>   * “dataset-lookup-query”: a dataset lookup endpoint was run
> 
>   * “function-query”: a function endpoint was run
> 
> 


### For “compute-resource-usage” topic

>   * “compute-resource-usage-start”: a compute resource usage was started
> 
>   * “compute-resource-usage-update”: a compute resource usage was updated
> 
>   * “compute-resource-usage-complete”: a compute resource usage was completed
> 
>   * “compute-resource-usage-start”: a compute resource usage was started
> 
>   * “kubernetes-cluster-usage-status”: periodic report on the status and usage of a Kubernetes cluster
> 
>

---

## [operations/audit-trail/dataikucloud]

# Audit trail on Dataiku Cloud

On Dataiku Cloud, audit logs will be automatically served through connections installed on your DSS, so you can leverage them directly in your instance.

## Access API node queries

An Amazon S3 connection named “customer-audit-log” hosting your API Nodes logs queries is automatically added to your instance when you activate the API nodes. No further action is required.

To import your logs as a dataset in your Dataiku’s instance:

  1. Add a Dataset > Cloud storages & Social > Amazon S3

  2. Select the corresponding S3 connection and the path in bucket




  4. In the “Format / Preview” tab, select “One record per line” as Type and “utf8” as Charset




  5. In the “Partitioning” tab, activate the partitioning: add a time dimension corresponding to the period you want to partition on, in the example below we partition per day




  6. Create the Dataset and access it in the Flow




## Access instances’ audit logs

This feature is only available for customers.

Activate the extension “dku-audit-log” in your Launchpad to add an Amazon S3 connection named “dku-audit-log” hosting your audit trail accessible from your Dataiku instance.

By default only space-administrators can access this connection, you can edit this behavior in the Launchpad’s connections tab.

Once the connection is available, to import the logs as a dataset in your Dataiku’s instance:

  1. Add a Dataset > Cloud storages & Social > Amazon S3

  2. Select the corresponding S3 connection and the path in bucket




  4. In the “Format / Preview” tab, select “One record per line” as Type and “utf8” as Charset




5\. In the “Partitioning” tab, activate the partitioning: add a discreet dimension called “node_type”, and add a time dimension corresponding to the period you want to partition on, in the example below we partition per day

  6. Create the Dataset and access it in the Flow

---

## [operations/audit-trail/default-storage]

# Default storage of audit trail

By default, the audit trail is logged in the `run/audit` folder of the DSS data directory.

This folder is made of several log files, rotated automatically. Each file is rotated when it reaches 100 MB, and up to 20 history files are kept

Each audit log files is made of one JSON record per line.

---

## [operations/audit-trail/eventserver]

# The DSS Event Server

The DSS Event Server is a very simple HTTP server that runs alongside a DSS node.

The Event Server receives events as HTTP queries and dispatches them to _targets_.

The primary use case of the Event Server is to receive audit trail messages from multiple DSS nodes and to centralize them. In this kind of setup:

  * You install the event server on a single DSS node

  * You configure an audit target on each DSS node that sends to this single event server

  * The event server on the “auditing node” writes the events it receives to a local target (for example, local files)

  * The managers can then parse these local files to grab centralized audit information




## Installing the event server

The event server is a new process in a design or automation node.

To install the event server:

  * Stop DSS

  * Run `./bin/dssadmin install-event-server`

  * Start DSS




## Configuration of the event server

The Event Server receives events that had been posted by the “EventServer target” of the audit dispatcher.

The Event Server dispatches events to destinations. There can be multiple destinations in an Event Server. The concepts for audit dispatch and Event Server are extremely similar.

Each event server destination defines:

>   * What topics it accepts (or all)
> 
>   * What routing keys it accepts (or all)
> 
>   * Where it sends the events.
> 
> 


The Event Server is configured in Administration > Settings > Event Server

At the moment, the Event Server can only write events as files on a “filesystem-like” connection.

The Filesystem-like destination takes as parameters:

  * a connection (Filesystem, S3, Azure Blob or Google Cloud Storage)

  * a path within that connection.




It creates subfolders of this path like `/topic/routing-key/YYYY/mm/dd/HH` (configurable).

Importantly, it does not create a dataset, you still need to create the dataset targeting this connection

## Security

The Event Server takes optional authentication (and the audit target can set it of course)

## Limitations

The Event Server is not highly-available nor horizontally scalable. It should however adequately serve the needs of most customers, and can handle thousands of events per second.

---

## [operations/audit-trail/index]

# Audit trail

DSS includes an audit trail that logs all actions performed by the users, with details about user id, timestamp, IP address, authentication method, …

---

## [operations/audit-trail/viewing-in-dss]

# Viewing the audit trail in DSS

You can view the latest audit events directly in the DSS UI: Administration > Security > Audit trail.

Note that this live view only includes the last 1000 events logged by DSS, and it is reset each time DSS is restarted. You should use log files or external systems for real auditing purposes.

---

## [operations/backups]

# Backing up

We strongly recommend that you do periodic backups of your DSS data. We also recommend that you backup before upgrading DSS.

Note

  * If you are using a Cloud Stacks setup, backups are managed automatically using Cloud snapshots. This section does not need to apply.

  * This section does not apply to Dataiku Cloud




The [DSS Data Directory (or DATA_DIR)](<datadir.html>) contains your configuration, your projects (graphs, recipes, notebooks, etc.), your connections to databases, the filesystem_managed files, etc.

The `DATA_DIR` does not contains datasets stored outside of the server: SQL servers, cloud storage, hadoop, etc.

Warning

For Govern nodes, you need to make sure to properly backup your PostgreSQL database using the regular PostgreSQL backup procedures. Each time you make a Govern backup, you should also ensure that you have a matching PostgreSQL backup.

## Full Backup

The simplest way to backup your data dir is to do a FULL backup of the whole data directory folder:

Make sure you don’t have any job running, then stop DSS:
    
    
    DATA_DIR/bin/dss stop
    

Compress your data directory:
    
    
    tar -zcvf your_backup.tar.gz /path/to/DATA_DIR/
    

Restart DSS:
    
    
    DATA_DIR/bin/dss start
    

## Other Backup Methods

The above mentioned method using tar is very simple but always performs full backups, which might not be practical with large data dirs.

There are many other backup methods, and listing them all is outside of the scope of this document, but we can mention:

  * Using rsync for incremental backups (either on the same machine or another machine)

  * The duply / duplicity couple

  * FS-level backup tools (XFS dump for instance)




Warning

The full consistency of the backup is only guaranteed if DSS is not running or if the volume is snapshotted **atomically**. LVM and most cloud managed block devices provide atomic snapshotting capabilities. In that case, the proper procedure would be:

>   * Create the snapshot
> 
>   * Mount the snapshot as read-only
> 
>   * Execute an incremental backup tool on the mounted snapshot
> 
>   * Unmount the snapshot
> 
>   * Destroy the snapshot
> 
> 


Alternatively, on cloud hosted volumes, the created snapshot can be kept as it is.

Note

All critical files of DSS are text files, which are written atomically, so partially-consistent backups (made while DSS was running) might be recoverable with the help of manual intervention.

## Restoring A Backup

To restore a backup, you need to restore the files that you backed up to their original location.

### “Pristine restore”

A pristine restore means a restoration of the backed up DSS data:

  * on the same machine as the original one

  * at the original location on the machine

  * on the same DSS version




For this kind of restoration, you simply need to replace the content of DATA_DIR with the content of the archive:

  * If applicable, stop the currently running DSS, and move away the current content of the DATA_DIR

  * Restore the backup



    
    
    cd DATA_DIR; tar -zxvpf your_backup.tar.gz
    

  * Restart DSS




### Restore on another machine, another location, or another DSS version

Warning

You can only restore a backup on a newer DSS version, not on an older one.

Restoration procedure:

  * If restoring on another machine, download and uncompress the DSS software on the new machine

  * Restore the backup files



    
    
    mkdir new_datadir_location; tar -zxvpf your_backup.tar.gz
    

  * Replay the installer in “upgrade” mode: this will “reattach” the restored datadir to the installation directory. It will also, if needed, migrate to the newer DSS version:



    
    
    INSTALL_DIR/installer.sh -d DATA_DIR -u
    

If you installed the data dir on a different machine or in a different location, you need to rebuild the Python environment. See [the “Migrating the data directory section” of our documentation on migrations](<../installation/custom/migrations.html>)

  * Replay the various “integration” setup scripts:

>     * [R integration](<../installation/custom/r.html>)
> 
>     * [Hadoop integration](<../hadoop/installation.html>)
> 
>     * [Spark integration](<../spark/installation.html>)




## Running An Automatic Backup

Here is an example shell script that you can run periodically within a cron task.
    
    
    #!/bin/bash
    #Purpose = Backup of DATA_DIR directory
    #START
    
    /path/to/DATA_DIR/bin/dss stop
    
    export GZIP=-9
    TIME=`date +"%Y-%m-%d"`
    SRCDIR="/path/to/DATA_DIR"
    DESDIR="/home/backups"
    tar -cpzf $DESDIR/backup-dss-data-$TIME.tar.gz $SRCDIR
    
    /path/to/DATA_DIR/bin/dss start
    
    #Optionally remove old backups
    OLD=`date -d "4 days ago" +"%Y-%m-%d"`
    rm -f $DESDIR/backup-dss-data-$OLD.tar.gz
    
    #END
    

Save this script in a file “backupscript.sh” and set a cron task like the following one (running from Monday to Friday at 6:15am):
    
    
    15 6 * * 1-5 /path/to/backupscript.sh
    

## What Can Be Excluded From The Backup

### Temporary / Cache data

The data directory contains some folders which can safely be excluded from the backup because they only contain temporary data which can be rebuilt:

  * tmp

  * caches

  * data-catalog




### Logs

In addition, the following folders only contain log data, which you might want to exclude from backup:

  * run

  * jobs

  * scenarios

  * diagnosis




### Other ignorable data

The following folders contain data which you might consider excluding:

  * exports (contains the data exports made by users)

  * prepared_bundles (contains automation bundles already exported)

  * apinode-packages (contains apinode packages already exported)




### Data

The following folders contain data built by DSS. This data can generally be rebuilt, but caution should be exercised when choosing whether to backup these folders:

  * managed_datasets

  * analysis_data

  * saved_models




Datasets stored outside of DATA_DIR aren’t affected by a DSS upgrade: they will still be available after the upgrade.

## Govern database

Most of the Govern configuration and all items managed by Govern are stored in a dedicated PostgreSQL database. This includes, but is not limited to:

  * governable items: business initiatives, projects, models, model versions and any other custom item.

  * blueprints

  * permissions

  * custom pages

  * relationships

  * user profiles




In addition to the DATA_DIR, for Govern nodes, you must backup the database.

---

## [operations/business-applications]

# Installing and configuring Business Applications

## Business Applications

Business Applications are packaged applications designed to support specific business tasks for users who rely on operational or organizational data, but who are not traditional Dataiku DSS users. They reduce the effort required to apply business expertise to data-driven capabilities and help organizations maximize the value of their data.

Business Applications provide rich, task-focused user interfaces and are tightly integrated with Dataiku DSS data, automation, and governance capabilities. As native DSS components, they benefit from built-in data integration, security, distribution, and lifecycle management.

Business Applications are distributed through the DSS Business Application Store and can be interacted with in two ways:

  * **End users** access Business Applications through dedicated, interactive application interfaces focused on completing specific tasks. These interfaces are available from the DSS sidebar after logging in.

  * **Administrators** manage Business Applications through dedicated administration features in DSS, which allow them to install, configure, and manage applications. In addition, each Business Application includes an embedded administration interface for application-specific settings.




A Business Application can support multiple instances in order to serve different teams or use cases.

Note

Business Applications are available starting with DSS 14.4 as part of the Dataiku Enterprise edition or an Enterprise AI Package.

Users must have one of the following license types: Data Designer, Advanced Analytics Designer, or Full Designer to use them.

## Installing a Business Application

Installing Business Applications is restricted to administrators.

Business Applications can be installed from the Business Application Store, accessible via ⋮⋮⋮ > Business Applications

Each Business Application requires a dedicated code environment to run. This code environment is created and built as part of the installation process.

## Configuring a Business Application

Configuration is performed by administrators and typically includes the following steps:

  * **Environment mapping**

Define how the connections required by the Business Application are mapped to the connections available on the DSS instance, and specify where the Business Application backend runs (locally or using a containerized execution configuration).

  * **Permissions**

    * Define which user groups can **view** and access the Business Application, and which groups are allowed to **create** new instances.

    * Define under which user account the backend of Business Application instances runs. This can be:

      * A single, fixed account for all instances

      * The account of the user creating the instance, without the possibility to change it

      * Configurable by the user at instance creation time




Note

Permissions defined at the Business Application level control visibility and instance creation, while permissions defined at the instance level control access to individual instances.

## Creating Business Application instances

Once a Business Application has been installed and configured, it must be instantiated before it can be used. Multiple instances can be created to support different teams or use cases.

  * Administrators can create instances from the Business Application configuration page (⋮⋮⋮ > Business Applications > Instances)

  * Non-administrator users with **Create** permission can create instances directly from the Business Application page, accessible from the DSS sidebar.




When creating an instance, users must provide:

  * A name

  * A project key to uniquely identify the instance

  * An optional description




If the Business Application has been configured to allow runtime account overrides, users can also select the account under which the instance backend runs.

After creation, instance-level permissions must be configured to define which users or groups can access the instance. To update these permissions, navigate to the instance, open … > Settings and configure the instance like a classic DSS project.

Note

Instance permissions are independent from Business Application permissions and must be explicitly configured for each instance.

To use a Business Application instance, users must have both **View** permission on the Application and **Read** permission on the instance.

Once instance-level permissions are configured, remaining instance-specific configuration can be done in the main screen of the application instance.

## Upgrading a Business Application

Upgrading Business Applications is restricted to administrators and is performed from the Business Application Store.

During an upgrade, the Business Application is updated to a new version. A new dedicated code environment may be required and must be built.

Instances created after the upgrade use the new version, but existing instances are **not upgraded automatically**. Existing instances continue to run on the previous version until they are explicitly upgraded. Instance can be manually upgraded from Business Application configuration page (⋮⋮⋮ > Business Applications > Instances). A Python API is available to assist with upgrading multiple instances programmatically.

The code environment from the previous version is not automatically deleted. It can be safely removed manually once all instances have been either migrated to the new version or deleted.

---

## [operations/cgroups]

# Using cgroups for resource control

Note

If using [Dataiku Cloud Stacks](<../installation/index.html>) installation, cgroups are automatically managed for you, and you do not need to follow these instructions.

These instructions do not apply to Dataiku Cloud

DSS can automatically classify a large number of its local subprocesses in Linux cgroups for resource control and limitation.

Using this feature, you can restrict usage of memory, CPU (+ other resources) by most processes. The cgroups integration in DSS is very flexible and allows you to devise multiple resource allocation strategies:

  * Limiting resources for all processes from all users

  * Limiting resources by process type (i.e. a resource limit for notebooks, another one for webapps, …)

  * Limiting resources by user

  * Limiting resources by project key




Warning

This requires some understanding of the Linux cgroups mechanism

Warning

cgroups support is only available for Linux and is not available for macOS.

## Prerequisites

  * You need to have a Linux machine with cgroups enabled (this is the default on all recent DSS-supported distributions)

  * DSS supports version 1 and version 2 of the Linux cgroups subsystem. However these two versions have quite different configuration mechanisms, constraints and settings. You will need to know which version is currently active on your system.

  * The DSS service account needs to have write access to one or several cgroups in which you want the DSS processes to be placed. This requires some privileged actions to be performed at system boot before DSS startup, and can be handled by the DSS-provided service startup script.

  * On cgroups v2 systems, cgroup management by DSS is only possible when the [User Isolation Framework](<../user-isolation/index.html>) is enabled, due to the new “Delegation Containment” rules.




## Recommended configuration (cgroups v2)

Note

Use this recommended configuration on OS that use cgroups v2, such as:

>   * RedHat Enterprise Linux 9
> 
>   * AlmaLinux 9
> 
>   * Rocky Linux 9
> 
>   * Oracle Linux 9
> 
> 


### Initial system configuration

First of all, you need (system administrator task) to make sure that the user running DSS (`dataiku` by default) can write to `/sys/fs/cgroup/DSS`.

You will also need to enable controllers at levels `/sys/fs/cgroup` and `/sys/fs/cgroup/DSS` by writing in the `cgroup.subtree_control` file.

Then, the cgroup hierarchies which are under control of DSS must be added to the `additional_allowed_file_dirs` configuration key under section `[dirs]` of the `/etc/dataiku-security/INSTALL_ID/security-config.ini` configuration file (you can find the `INSTALL_ID` in `DATADIR/install.ini`).
    
    
    [dirs]
    dss_datadir = /data/dataiku/dss_datadir
    additional_allowed_file_dirs = /sys/fs/cgroup/DSS
    

### Configuration in DSS

  * Go to Admin > Settings > Resource control

  * Check _Enable cgroups support_

  * Select _Cgroups version_ `V2`

  * Configure _Controllers to enable_ to `cpu,memory`

  * Configure _Hierarchies mount root_ to `/sys/fs/cgroup`




Under _cgroups placements_ , configure the following: for every entry (In-memory machine learning, Python and R recipes, …) _except “Job execution kernels”_ , choose an identifier for the process type and provide a target path.

As an example, for _In-memory machine learning_ , set the following target path: `DSS/workloads/${user}/mlKernels`.

Under _cgroup limits_ , add a limit:

  * Path template: `DSS/workloads`

  * Then click “Add limit”:

    * Key: `memory.max`

    * Value: recommended memory limit




The recommended memory limit is as follows:

  * For a VM with 32 GB of memory, set 10g

  * For a VM with 64 GB of memory, set 38g

  * For a VM with 96 GB of memory, set 60g

  * For a VM with 128 GB of memory or more, set 70% of the physical memory. For example, if you have 256 GB of RAM, set 180g




### Making the settings persistent at reboot

You will first need to make sure that you have been delegated a subdirectory of this hierarchy (e.g. `/sys/fs/cgroup/DSS`), and that the `memory` and `cpu` cgroup controllers have been enabled in it. This would require that the boot-time service configuration file for DSS contains:

  * `DSS_CGROUPS="DSS"`

  * `DSS_CGROUP_CONTROLLERS="cpu memory"`




## Recommended configuration (cgroups v1)

Note

Use this recommended configuration on OS that use cgroups v1, such as:

>   * RedHat Enterprise Linux 8
> 
>   * AlmaLinux 8
> 
>   * Rocky Linux 8
> 
>   * Oracle Linux 8
> 
> 


### Initial system configuration

First of all, you need (system administrator task) to make sure that the user running DSS (`dataiku` by default) can write to `/sys/fs/cgroup/cpu/DSS` and `/sys/fs/cgroup/memory/DSS`.

Then, the cgroup hierarchies which are under control of DSS must be added to the `additional_allowed_file_dirs` configuration key under section `[dirs]` of the `/etc/dataiku-security/INSTALL_ID/security-config.ini` configuration file (you can find the `INSTALL_ID` in `DATADIR/install.ini`).
    
    
    [dirs]
    dss_datadir = /data/dataiku/dss_datadir
    additional_allowed_file_dirs = /sys/fs/cgroup/
    

### Configuration in DSS

  * Go to Admin > Settings > Resource control

  * Check _Enable cgroups support_

  * Select _Cgroups version_ `V1`




Under _cgroups placements_ , configure the following: for every entry (In-memory machine learning, Python and R recipes, …) _except “Job execution kernels”_ , choose an identifier for the process type and provide a target path.

As an example, for _In-memory machine learning_ , set the following target path: `memory/DSS/${user}/mlKernels`.

Under _cgroup limits_ , add a limit:

  * Path template: `memory/DSS`

  * Then click “Add limit”:

    * Key: `memory.limit_in_bytes`

    * Value: recommended memory limit




The recommended memory limit is as follows:

  * For a VM with 32 GB of memory, set 10g

  * For a VM with 64 GB of memory, set 38g

  * For a VM with 96 GB of memory, set 60g

  * For a VM with 128 GB of memory or more, set 70% of the physical memory. For example, if you have 256 GB of RAM, set 180g




### Making the settings persistent at reboot

You will first need to make sure that you have been delegated a subdirectory of this hierarchy (e.g. `/sys/fs/cgroup/memory/DSS` and `/sys/fs/cgroup/cpu/DSS`). This would require that the boot-time service configuration file for DSS contains:

  * `DSS_CGROUPS="memory/DSS:cpu/DSS"`




## Additional details and examples

This section contains further details if you want to go further than the recommended configuration above

### Applicability

cgroups restriction applies to:

  * Python and R recipes

  * PySpark, SparkR and sparklyr recipes (only applies to the driver part, executors are covered by the cluster manager and Spark-level configuration keys)

  * Python and R recipes from plugins

  * Python, R and Scala notebooks (not differentiated, same limits for all 3 types)

  * In-memory visual machine learning and deep learning (for scikit-learn, computer vision and Keras backends. For MLlib backend, this is covered by the cluster manager and Spark-level configuration keys)

  * Webapps (Shiny, Bokeh, Dash and Python backend of HTML webapps, not differentiated, same limits for all 4 types)

  * Interactive statistics

  * Statistics recipes (for univariate analysis, PCA and statistical test recipes)

  * Custom Python steps and triggers in scenarios

  * Project Standards checks

  * Jobs using the DSS engine (prepare recipe and others) via the Job Execution Kernels. However, for memory tuning of the JEK, prefer [Tuning and controlling memory usage](<memory.html>) since cgroups will cause jobs to die.

  * Stories processes




cgroups restrictions do not apply to:

  * The DSS backend itself. For memory tuning of the backend, see [Tuning and controlling memory usage](<memory.html>)

  * The DSS public API, which runs as part of the backend




Note

cgroups do not apply to recipes and machine learning that are using [containerized execution](<../containers/index.html>) See containerized execution documentation for more information about processes and controlling memory usage for containers

### Configuration

All configuration for cgroups integration is done by the DSS administrator in _Administration > Settings > Resource control_.

You need to configure:

  * The cgroup subsystem version currently active on your host (V1 or V2).

  * [cgroup v2 only] The list of cgroup controllers used by your setup (comma-separated list, eg `cpu,memory`). These controllers should have been enabled at boot time on the cgroup directories delegated to DSS.

  * The global root (mount point) for the cgroups hierarchy on the host. On most Linux systems this is `/sys/fs/cgroup`, unless customized by the administrator.

  * For each kind of process, the list of cgroup(s) in which you want it placed, relative to this root. Each entry of the list can refer to some variables for dynamic placement.

  * For each cgroup (which can also refer to some variables), the limits to apply. Refer to Linux cgroups documentation for available limits.




Note

  * Under cgroup v2, processes can only be placed in leaf nodes of the cgroup tree, not internal nodes. For instance, it is possible to classify some user processes in “dataiku/${user}/notebooks” and some others in “dataiku/${user}/recipes” (two distinct leaf nodes). However if your setup uses cgroup “dataiku/recipes/python” you cannot assign processes to parent cgroups “dataiku/recipes” nor “dataiku”.

  * Under cgroup v1, a given process can be placed in multiple cgroups, for different cgroup controllers (for instance, one cgroup for CPU control and one for memory control). Cgroup v2 uses a single unified tree for all controllers, so a given process can only be classified in a single cgroup.




### Limitations when choosing a cgroup v2 target path

Your process’ target paths will be conditioned by the types of limits that you would like to implement.

We recommend that you place each process in a path that contains:

  * the user that is running the process, using variable `${user}`

  * a key that identifies the type of process (e.g. `mlKernels` for “In-memory machine learning”)




One option is to place the `${user}` before the process key. As an example, you may place “In-memory machine learning” processes in path `DSS/workloads/${user}/mlKernels`. You should choose target paths following this convention for all process types under section _cgroups placements_. This option allows you to set limits on:

  * the total resource consumption of each user for a specific process type (e.g. by setting a limit on `DSS/workloads/${user}/mlKernels`)

  * each user’s global resource consumption (by setting a limit on `DSS/workloads/${user}`)




However this option does not cover the use case where you would like to set a limit per process type, regardless of the user. In this case, you could place the `${user}` after the process key, e.g. `DSS/workloads/mlKernels/${user}`. This option has the drawback that you may not define limits on users regardless of process types, however it allows you to set limits on:

  * the total resource consumption of each user for a specific process type (e.g. by setting a limit on `DSS/workloads/mlKernels/${user}`)

  * the total resource consumption for a specific process type, aggregated on all users (e.g. by setting a limit on `DSS/workloads/mlKernels`)




Regardless of which option is chosen, creating one cgroup for each process type and each user allows for better accounting: cgroups can be used to implement limitations, but each cgroup also contains accounting files that allows us to know for example how much memory the notebooks of each user are consuming, all while respecting the global limit.

### Example with CPU limits

Similar to memory limits, you can also set CPU limits on processes. As an example, let’s assume that you would like to limit each user’s CPU to 100% (1 core). You should set the following limit:

  * _Path template_ : `DSS/workloads/${user}`

  * _Limits_ :

>     * `cpu.max` : `1000000 1000000`




In the value for `cpu.max`, the first number corresponds to the quota of CPU over a given period. The second number defines the said period (in milliseconds).

### Configuration example (cgroup v1)

To implement the following policy:

  * The memory by notebooks for each user may not exceed 25 GB (to protect other critical resources)




In Linux distributions where cgroup v1 is active, its hierarchy is normally mounted at `/sys/fs/cgroup`.

Edit the service configuration file (at `/etc/dataiku/<INSTANCE_ID>/dataiku-boot.conf`) and set the following variable definitions:

  * `DSS_CGROUPS="cpu/DSS:memory/DSS"`




#### Global cgroups configuration

  * Check _Enable cgroups support_

  * Select _Cgroups version_ `V1`

  * Configure _Hierarchies mount root_ to `/sys/fs/cgroup`




#### Placements configuration

Under _cgroups placements_ , configure the following:

##### Placement of notebooks

Add the following target cgroup to _Jupyter kernels (Python, R, Scala)_ :

  * `memory/DSS/${user}/notebooks`




When user u1 starts a notebook, its process will be placed in `/sys/fs/cgroup/memory/DSS/u1/notebooks`

#### Limits configuration

We have placed processes in cgroups, we now need to implement the desired resource limitations.

Under _cgroups limits_ , configure the following:

##### Per-user notebooks memory restriction

  * _Path template_ : `memory/DSS/${user}/notebooks`

  * _Limits_ :

>     * `memory.limit_in_bytes` : `25G`




When placing a process in a given cgroup, DSS evaluates all limit configuration rules and applies those which match the target cgroup or one of its parents.

### Creating DSS-specific cgroups at boot time

DSS requires write access to those subdirectories of the global cgroup hierarchies for which you have configured placement or resource limitation rules.

As the cgroup hierarchy is only writable by root, you will need to create these subdirectories, and change their permissions accordingly, before DSS can use them. Moreover, these subdirectories do not persist across system reboots, so you would typically configure a boot-time action for this, to be run before DSS startup.

Note

To avoid conflicts with other parts of the system which manage cgroups (eg systemd, docker) it is advised to configure dedicated subdirectories within the cgroup hierarchies for DSS use.

#### Using the DSS-provided service management script (recommended)

The DSS service management script described [here](<../installation/custom/initial-install.html#boot-startup>) can optionally create cgroup directories for DSS before starting DSS itself.

To configure this, edit the service configuration file (at `/etc/dataiku/<INSTANCE_ID>/dataiku-boot.conf`) and add the following variable definitions:

  * `DSS_CGROUP_ROOT` [optional] : global hierarchies mount root for your system (default `/sys/fs/cgroup`)

  * `DSS_CGROUPS` : colon-separated list of cgroup directories to create, relative to the global hierarchies mount root

  * `DSS_CGROUP_CONTROLLERS` [cgroups v2 only] : space-separated list of cgroup controllers to enable on these directories




The required cgroups will be initialized by the execution of `sudo systemctl start dataiku`, before DSS startup.

Corresponding log messages and error reporting can be retrieved with `journalctl -u dataiku`.

Examples:
    
    
    # /etc/dataiku/XIgV6TDueYeam0NNIWMlh49X/dataiku-boot.conf
    # Service configuration file for Dataiku DSS instance XIgV6TDueYeam0NNIWMlh49X
    # Cgroups v2 version
    DSS_DATADIR="/data/dataiku/dss_datadir"
    DSS_USER="dataiku"
    
    # Creates DSS-private cgroup on startup: /sys/fs/cgroup/dataiku
    # DSS_CGROUP_ROOT=/sys/fs/cgroup
    DSS_CGROUPS="dataiku"
    DSS_CGROUP_CONTROLLERS="cpu memory"
    
    
    
    # /etc/dataiku/9xC2VPsFcFTdO6gBIVDhRcNN/dataiku-boot.conf
    # Service configuration file for Dataiku DSS instance 9xC2VPsFcFTdO6gBIVDhRcNN
    # Cgroups v1 version
    DSS_DATADIR="/data/dataiku/dss_datadir"
    DSS_USER="dataiku"
    
    # Creates DSS-private cgroups: /sys/fs/cgroup/cpu/DSS and /sys/fs/cgroup/memory/DSS
    # DSS_CGROUP_ROOT=/sys/fs/cgroup
    DSS_CGROUPS="cpu/DSS:memory/DSS"
    

#### Manual setup

You can set up DSS cgroups by other mechanisms if needed. What is required is that the Unix user account used to run DSS has permission to manipulate the cgroups directories in which you need it to put its children processes (ie create subdirectories, set up limits, assign processes). In practice this would amount to the following operations, to be run as root before DSS starts.

On a cgroups v2 system, you also need to ensure that the required cgroup controllers are enabled for cgroup directories used by DSS, by writing into the `cgroup.subtree_control` file for all parent directories, starting from the cgroup root. Assuming that:

  * the global cgroup root on your system is `/sys/fs/cgroup`

  * the DSS service account is `dataiku`

  * you have configured rules placing some processes into subdirectories of `DSS`

  * you have configured rules controlling both CPU and memory usage




you would need to issue the following commands as root:
    
    
    mkdir -p /sys/fs/cgroup/DSS
    echo "+cpu +memory" >/sys/fs/cgroup/cgroup.subtree_control
    echo "+cpu +memory" >/sys/fs/cgroup/DSS/cgroup.subtree_control
    chown dataiku /sys/fs/cgroup/DSS /sys/fs/cgroup/DSS/cgroup.procs
    

On a cgroups v1 system, you need to create the cgroup directories used by DSS and assign them to the DSS account. For instance, assuming that:

  * the global cgroup root on your system is `/sys/fs/cgroup`

  * the DSS service account is `dataiku`

  * you have configured a rule placing some processes into or below `memory/DSS`




you would need to issue the following commands as root:
    
    
    mkdir -p /sys/fs/cgroup/memory/DSS
    chown -Rh dataiku /sys/fs/cgroup/memory/DSS
    

### Additional setup for User Isolation Framework deployments

When DSS is configured with [User Isolation Framework](<../user-isolation/index.html>) enabled, the cgroup hierarchies which are under control of DSS should be added to the `additional_allowed_file_dirs` configuration key under section `[dirs]` of the `/etc/dataiku-security/INSTALL_ID/security-config.ini` configuration file (you can find the `INSTALL_ID` in `DATADIR/install.ini`).

That would result in specifying the set of toplevel directories where DSS will write into: in v1 that is usually one directory per controller, while in v2 all controllers live in the same directory tree.

Example on a cgroups v2 system:
    
    
    [dirs]
    dss_datadir = /data/dataiku/dss_datadir
    additional_allowed_file_dirs = /sys/fs/cgroup/DSS
    

Example on a cgroups v1 system:
    
    
    [dirs]
    dss_datadir = /data/dataiku/dss_datadir
    additional_allowed_file_dirs = /sys/fs/cgroup/cpu/DSS;/sys/fs/cgroup/memory/DSS

---

## [operations/compute-resource-usage-reporting]

# Compute resource usage reporting

DSS acts as the central orchestrator of many computation resources, from SQL databases to Kubernetes. Through DSS, users can leverage these elastic computation resources and consume them. It is thus very important to be able to monitor and report on the usage of computation resources, for total governance and cost control of your Elastic AI stack.

DSS includes a complete stack for reporting and tagging compute resources. The data gathered through this stack is sent through the [audit centralization mechanism](<audit-trail/index.html>) and can be analyzed centrally (across multiple DSS instances) using DSS. Dashboards can be built from there.

DSS makes granular / processable format, so that you can build your own dashboards. Typical requirement for that is you may want to be able to join usage data with an internal HRIS or similar software in order to provide dashboards by “team” / “BU” / “department”.

## Concepts

DSS creates and emits _Compute Resource Usage_ items (CRU). A CRU represents a granular usage of one compute resource within a specific context.

A CRU has:

  * A start/end time

  * A type: what is the resource that we are consuming. CRU types:
    
    * SINGLE_K8S_JOB: Execution of a pod or deployment on a K8S cluster

    * SPARK_K8S_JOB: Execution of a Spark job on K8S

    * LOCAL_PROCESS: a process running locally on the DSS machine

    * SQL_CONNECTION: a connection established to a SQL database

    * SQL_QUERY: a query on a SQL connection

  * A _context_ : what is consuming this resource. Each context has a type and type-specific data. The contexts are:
    
    * Related to jobs
    
      * JOB_MAIN_PROCESS: The main process running a single job

      * JOB_DEPS_COMPUTATION: The phase during which dependencies are computed for the job, before activities start

      * JOB_ACTIVITY: An activity in the job. Type-specific data includes project, job id, activity id, initiator. This notably includes all recipes.

    * Related to Machine Learning
    
      * ANALYSIS_ML_TRAIN: A train of a machine learning in the visual ML

    * Related to notebooks:
    
      * SQL_NOTEBOOK: A query in a SQL notebook

      * JUPYTER_NOTEBOOK_KERNEL: A Jupyter notebook running

    * Related to Webapps
    
      * WEBAPP_BACKEND: The backend for a webapp

    * API deployer
    
      * API_DEPLOYER_DEPLOYMENT: A single deployment of an API service on a Kubernetes infrastructure

    * Other
    
      * EDA: The process that runs Visual Statistics computation

      * POOLED_SPARKSQL_CONNECTION: When using SparkSQL notebooks and charts, connections to the Spark cluster are maintained in a pool

  * Type-specific data. For example, for a local process will have a pid and various information on resources consumption.




CRU are started, updated and completed by DSS. Each of these events on CRUs (start, update, complete) are sent to the DSS [audit log](<audit-trail/index.html>) (and can thus be centralized using audit log centralization).

These CRU events can then be processed using a DSS project in order to produce the dashboards.

CRUs are by design very low-level information that must be aggregated. In particular, in the case of Kubernetes, it must be joined with cluster-level reporting in order to actually provide data.

## Enabling CRU generation and audit

Generation of CRUs and their events and sending them to the audit log is automatic. No action is required.

All CRU events are reported to the audit log with the `compute-resource-usage` topic. You can choose to direct this particular audit topic to a specific location (please see [Audit trail](<audit-trail/index.html>) for more details), or you can filter events from the main audit destination using a filter recipe.

## Cluster-level reporting for Kubernetes jobs

In the case of Kubernetes jobs, just the CRU at the DSS level are not sufficient to know how much resources were actually consumed. This is because DSS does not always know or control which pods are running.

### Labeling of pods

Every pod created directly or indirectly by DSS will carry a number of Kubernetes labels that can be used to trace the source of the resource usage.

The main labels are:

  * `dataiku.com/dku-exec-submitter`: login of the user who submitted the Kubernetes object

  * `dataiku.com/dku-execution-id`: A unique identifier of this particular submission. You’ll find this execution id in the matching CRU object (of type SINGLE_K8S_JOB or SPARK_K8S_JOB)

  * `dataiku.com/dku-install-id`: Installation identifier of the DSS node which made the submission (can be found in install.ini)

  * `dataiku.com/dku-execution-type`: A CRU context type (JOB_ACTIVITY, WEBAPP_BACKEND, …) which identifies the type of execution




These additional labels may or may not be available depending on the execution type:

  * `dataiku.com/dku-project-key`

  * `dataiku.com/dku-analysis-id`

  * `dataiku.com/dku-mltask-id`

  * `dataiku.com/dku-mltask-session-id`

  * `dataiku.com/dku-webapp-id`

  * `dataiku.com/dku-job-id`

  * `dataiku.com/dku-activity-id`

  * `dataiku.com/dku-apideployer-infra-id`

  * `dataiku.com/dku-apideployer-service-id`

  * `dataiku.com/dku-apideployer-deployment-id`




There are then two mechanisms for reporting of compute resource usage on Kubernetes:

### Method 1: builtin reporting

Depending on your cloud provider, your cluster may have builtin capabilities to centrally reporting on usage. For example, on GCP, GKE clusters can output their metrics (including labels) directly to BigQuery.

### Method 2: periodic reporting

If your cluster does not already have reporting of usage per pod, you can enable DSS periodic reporting.

Go to Administration > Settings > Misc and enable periodic reporting. You need to restart DSS for these changes to take effect.

DSS will then periodically query each Kubernetes cluster for list of pods and current resource consumption of each pod, and will emit a dedicated audit message containing the list of pods with their current resource consumption. The report will include the labels for each pod

### Joining data

Whether you use builtin reporting or periodic reporting, you will usually want to join the data of the pods reporting with the data of the CRU.

This can be useful for example, in the case of Spark jobs that will have both `LOCAL_PROCESS` kind of CRU for the Spark driver and `SPARK_K8S_JOB` for the executors on Kubernetes.

The join key is the `executionId` which is present both on the `SPARK_K8S_JOB` CRU and on the pods labels.

## Examples

  * This is the CRU audit message for the completion of a local webapp backend



    
    
    {"msgType":"compute-resource-usage-complete","computeResourceUsage":{"localProcess":{"cmajorFaults":0,"vmHWMMB":89,"userTimeMS":4260,"csystemTimeMS":10,"rssMBSeconds":8186,"rssAnonMB":77,"pid":26171,"cuserTimeMS":0,"commandName":"/home/clement/data-702/bin/python","currentCPUUsage":0,"systemTimeMS":720,"majorFaults":0,"vmPeakMB":734,"vmSizeMB":674,"vmRSSMB":89,"vmDataMB":260},"context":{"projectKey":"DKU_CUSTOMER_LIFETIME_VALUE","type":"WEBAPP_BACKEND","authIdentifier":"admin","webappId":"hbVxkV9"},"startTime":1589188902662,"id":"BHUBDIdlaScYnC0A","endTime":1589188995709,"type":"LOCAL_PROCESS"}}
    

  * This is the CRU audit message for the start of a Bokeh webapp backend on Kubernetes



    
    
    {"msgType":"compute-resource-usage-start","computeResourceUsage":{"singleK8SJob":{"executionId":"bokeh-nko9a5dh","k8sClusterId":"__builtin__"},"context":{"projectKey":"DKU_CUSTOMER_LIFETIME_VALUE","type":"WEBAPP_BACKEND","authIdentifier":"admin","webappId":"hbVxkV9"},"startTime":1589190307086,"id":"gOQVLPfEJzJDTIhC","type":"SINGLE_K8S_JOB"}}
    

  * This is a periodic Kubernetes status report



    
    
    {"podsStatus":{"pods":[{"memoryMB":0,"cpuRequestMillis":1000,"name":"dssvprepcomputekddcuppreparedn-yakrbhk0-exec-1","namespace":"default","memoryLimitMB":3000,"annotations":{},"memoryRequestMB":3000,"cpuMillis":0,"labels":{"spark-exec-id":"1","dataiku.com/dku-job-id":"build_kddcup_prepared_2020-05-12t09-06-23.681","dataiku.com/dku-execution-type":"JOB_ACTIVITY","dataiku.com/dku-install-id":"2NeUCr7zmzBzRfY458M0xXB0","spark-app-selector":"spark-application-1589274392722","dataiku.com/dku-activity-id":"compute_kddcup_prepared_np","spark-role":"executor","dataiku.com/dku-execution-id":"shaker-v58i2ck","dataiku.com/dku-project-key":"kdd","dataiku.com/dku-exec-submitter":"admin"}},{"memoryMB":0,"cpuRequestMillis":1000,"name":"dssvprepcomputekddcuppreparedn-yakrbhk0-exec-2","namespace":"default","memoryLimitMB":3000,"annotations":{},"memoryRequestMB":3000,"cpuMillis":0,"labels":{"spark-exec-id":"2","dataiku.com/dku-job-id":"build_kddcup_prepared_2020-05-12t09-06-23.681","dataiku.com/dku-execution-type":"JOB_ACTIVITY","dataiku.com/dku-install-id":"2NeUCr7zmzBzRfY458M0xXB0","spark-app-selector":"spark-application-1589274392722","dataiku.com/dku-activity-id":"compute_kddcup_prepared_np","spark-role":"executor","dataiku.com/dku-execution-id":"shaker-v58i2ck","dataiku.com/dku-project-key":"kdd","dataiku.com/dku-exec-submitter":"admin"}},{"memoryMB":0,"cpuRequestMillis":100,"name":"dataiku-exec-remote-notebook-ntjtnnhc-z27lw","namespace":"default","annotations":{"kubernetes.io/limit-ranger":"LimitRanger plugin set: cpu request for container c"},"cpuMillis":0,"labels":{"job-name":"dataiku-exec-remote-notebook-ntjtnnhc","dataiku.com/dku-execution-type":"JUPYTER_NOTEBOOK_KERNEL","dataiku.com/dku-install-id":"2NeUCr7zmzBzRfY458M0xXB0","dataiku.com/dku-execution-id":"remote-notebook-ntjtnnhc","dataiku.com/dku-project-key":"dku_customer_lifetime_value","controller-uid":"2334b649-9386-11ea-893a-42010af0006a","jobgroup":"dataiku-exec","dataiku.com/dku-exec-submitter":"admin"}}]},"msgType":"kubernetes-cluster-usage-status","clusterId":"DKU_INSTANCE_DEFAULT"}

---

## [operations/datadir]

# The data directory

The data directory is the unique location on the DSS server where DSS stores all its configuration and data files.

Notably, you will find here:

  * Startup scripts to start and stop DSS

  * Settings and definitions of your datasets, recipes, projects, …

  * The actual data of your machine learning models

  * Some of the data for your datasets (those stored in local connections)

  * Logs

  * Temporary files

  * Caches




## Finding the data directory

The data directory is the directory which you set during the installation of DSS on your server (the -d option).

If you did not install DSS yourself, you can find the path to the data directory by going to Administration > Maintenance > System info (you need to be a DSS administrator for this).

If you use the macOS application, the data directory is automatically set to `~/Library/DataScienceStudio/dss_home`.

## Main folders of the data directory

The data directory is made of the following folders

Note

Depending on the node type, some of these folders may not exist

### R.lib

Include in backups: Yes

This folder contains the R libraries installed by calling `install.packages()` from a R notebook or recipe, as well as the R libraries that DSS installs when running `install-R-integration`.

Note that we recommend using code environments rather than calling `install.packages()` manually. For more information, see [Code environments](<../code-envs/index.html>).

### analysis-data

Include in backups: Yes

This folder contains the data for the models trained in the Lab part of DSS.

The data is organized by project, then by visual analysis, then by ML Task. The data for a ML Task is removed when the ML Task (or its containing visual analysis) is removed in DSS.

Depending on the ML engine used, this folder can contain the train and test splits data, which can become big (in `splits` folders). It is possible to remove these CSV files, but you will lose some of the ability to compare exactly models since they won’t be based on the same splits.

### bin

Include in backups: Yes

This folder contains various programs and scripts to manage DSS.

  * dss: main start/stop script

  * dssadmin: for offline administration tasks

  * [dsscli](<dsscli.html>): for various administration tasks

  * env-default.sh, env-hadoop.sh, env-spark.sh, dku, fek, jek, python: internal usage, not for use by end users

  * env-site.sh for advanced environment customization

  * pip: for management of the builtin Python environment. For more information, see [Code environments](<../code-envs/index.html>).




### caches

Include in backups: Not needed

This folder contains various precomputed information. It is safe to remove elements in this folder, but some operations in DSS will to recompute them (displaying explore samples and charts)

### code-envs

Include in backups: Yes

Note

This folder is called acode-envs on the automation node

This folder contains the definitions of all code environments, as well as the actual packages

### config

Include in backups: Yes

This is the most important folder, where all user configuration and data is stored:

  * All projects, datasets, recipes, notebooks, webapps, ….

  * Users and security settings

  * Connections

  * API keys

  * …




This folder contains several Git repositories

### databases

Include in backups: Yes

This folder contains several internal databases used for operation of DSS:

  * Usage statistics

  * Jobs and scenarios histories

  * Metrics and checks histories

  * Users watches and stars

  * Users notifications




Some of the information in these databases can be accessed from DSS itself using the “Internal stats” and “Metrics” virtual datasets

### data-catalog

Include in backups: Not strictly required

This folder contains the indices and staging data for the DSS data catalog.

### exports

Include in backups: Not strictly required

This folder contains download files for exports made by users.

It is safe to remove old folders in this folder - exports will not be available anymore for download by users

### install-support

Include in backups: Yes

Internal support files

### jobs

Include in backups: As desired, not strictly required

This folder contains the job logs and support files for all flow build jobs in DSS, both running and previous.

It is safe to remove folders of jobs that are not currently running. Logs of these jobs will not be available anymore, but the existence of the job will still be registered in the DSS UI.

### jupyter-run

Include in backups: Yes

This folder contains internal runtime support file for the Jupyter notebook.

The “current working directory” of all notebooks is initialized within this folder. If a user’s notebook code writes files to the current working directory, these files will appear in `jupyter-run`.

### lib

Include in backups: Yes

This folder contains administrator-installed global custom libraries (Python and R), as well as JDBC drivers.

### local

Include in backups: Yes

This folder contains administrator-installed files for serving in web applications

### managed_datasets

Include in backups: Yes

This is the location of the “filesystem_managed” connection which is installed by default in DSS. It contains datasets data written in this connection.

### managed_folders

Include in backups: Yes

This is the location of the “filesystem_folders” connection which is installed by default in DSS. It contains folders data written in this connection.

### notebook_results

Include in backups: Yes

This folder contains the query results for SQL / Hive / Impala notebooks

### plugins

Include in backups: Yes

This folder contains the plugins (both installed in DSS, and developed directly in DSS)

### privtmp

Include in backups: Yes

This folder contains security-sensitive temporary files that should not be modified.

### pyenv

Include in backups: Yes

This folder contains the builtin Python environment of DSS

### run

Include in backups: Not required

This folder contains all core log files of DSS. See [Diagnosing and debugging issues](<../troubleshooting/diagnosing.html>) for more information.

### saved_models

Include in backups: Yes

This folder contains the data for the models trained in the Flow.

The data is organized by project, then by model id.

### scenarios

Include in backups: As desired, not strictly required

It is safe to remove folders of scenarios that are not currently running. Logs of these scenarios will not be available anymore, but the existence of the scenario will still be registered in the DSS UI.

### timelines

Include in backups: Yes

This folder contains databases storing the “timelines” information associated to each kind of DSS object.

### tmp

Include in backups: No

This folder contains temporary files. See below for more information

### uploads

Include in backups: Yes

This folder contains the files that have been uploaded to DSS to use as datasets.

## DSS is using too much space on disk

Please see [Managing DSS disk usage](<disk-usage.html>)

## Managing temporary files

Please see [Managing DSS disk usage](<disk-usage.html>)

---

## [operations/disk-usage]

# Managing DSS disk usage

Various subsystems of DSS consume disk space in the DSS data directory. Some of this disk space is automatically managed and reclaimed by DSS (like temporary files), but some needs some administrator decision and management. For example, job logs are not automatically garbage collected, because a user or administrator may want to access it an arbitrary amount of time later.

## Automating cleanup tasks through DSS macros

For many of the things that can be cleaned up, DSS provides “macros” to semi-automate these. These macros can be run manually, but you can also automate them using a scenario.

A common setup is thus to create a dedicated “Administration project”, accessible only to DSS administrators. In this project, you create scheduled scenarios that call the macros.

Note

Most of these macros can only be run with full DSS Administrator privileges

### Running the cleanup macros manually

  * In your administration project, click on the “Macros” button

  * Select the appropriate macro

  * Select parameters. Most cleanup macros default to running only for the current project, but have an option to run for all projects (which you can only set if you are a DSS administrator)

  * Run the macro




### Running the cleanup macros automatically

  * In your administration project, go to scenarios

  * Create a new scenario

  * Add a “Run a macro” step

  * Select a time-based trigger for the scenario, configure it and activate your scenario




## Job logs

  * Location in data dir: `jobs`

  * Kind of data: historical logs

  * Include in backups: As desired, not strictly required




Each time a job is run in DSS, DSS makes a snapshot of the project configuration/flow/code, runs the job, and keeps various logs and diagnostic information for this job.

This information is extremely useful for understanding job issues, and is not automatically garbage-collected by DSS, in case user wants to investigate what happened with a job at a later point.

For each job, a subfolder is created as `jobs/PROJECT_KEY/JOB_ID`.

It is safe to remove folders of jobs that are not currently running. Logs of these jobs will not be available anymore, but the existence of the job will still be registered in the DSS UI.

### Semi-automatic cleanup (recommended)

  * Use the “Clear job logs” macro.

  * Check “All projects”




### Manual cleanup

Job folders that correspond to not-active-anymore jobs can be removed manually.

## Scenario logs

  * Location in data dir: `scenarios`

  * Kind of data: historical logs

  * Include in backups: As desired, not strictly required




Each time a scenario is run in DSS, DSS makes a snapshot of the project configuration/flow/code, runs the scenario (which, in turn, generally runs one or several jobs), and keeps various logs and diagnostic information for this scenario run.

This information is extremely useful for understanding scenario issues, and is not automatically garbage-collected by DSS, in case user wants to investigate what happened with a job at a later point.

For each scenario run, a subfolder is created as `scenarios/PROJECT_KEY/SCENARIO_ID/SCENARIO_RUN_ID`.

It is safe to remove folders of scenario runs that are not running anymore. Logs of these scenario runs will not be available anymore, but the existence of the scenario run will still be registered in the DSS UI.

### Manual cleanup

Scenario folders that correspond to not-active-anymore scenario runs can be removed manually.

## Saved models

  * Location in data dir: `saved_models`

  * Kind of data: machine learning models

  * Include in backups: Yes




When a machine learning model is deployed from a ML Task onto the Flow of a project, a copy of the data for this saved model is made in the `saved_models` folder.

Each time the saved model is retrained by running it from the Flow, a new version of the saved model is made, and a new copy of the model data is kept.

The size of a saved model version is highly dependent on the algorithm and characteristics of the data, and can range from hundreds of kilobytes to gigabytes.

The saved_models folder on disk is structured as `saved_models/PROJECT_KEY/SAVED_MODEL_ID/versions/VERSION_ID`

DSS never automatically removes old versions of saved models, as the user may elect to revert to a previous version at any time (for example if he notices that the newer version does not perform as expected). Old versions can be removed by the user from the UI of a saved model

### Manual cleanup

It is safe to delete (without going through the DSS UI) the `VERSION_ID` folder of versions that are not currently the active version of the saved model.

Warning

Deleting the `VERSION_ID` folder corresponding to the currently active version would render the saved model unusable.

## Analysis data

  * Location in data dir: `analysis-data`

  * Kind of data: machine learning models and machine learning staging data

  * Include in backups: Yes




When a model is trained in a visual analysis, by creating a ML Task, various kind of information is kept in the `analysis-data` folder.

This folder is structured like:

  * `analysis-data/ANALYSIS_ID/MLTASK_ID/`

    * `sessions`

    * `splits`




### sessions

The `sessions` subfolder contains the actual data of the machine learning models, for each model trained within this ML task. The size of a machine learning model is highly dependent on the algorithm and characteristics of the data, and can range from hundreds of kilobytes to gigabytes.

DSS never automatically removes old models trained in previous sessions, as the user may elect to deploy or compare any of the previous versions at any time.

Most of the data in `sessions` is cleared when the user deletes models or sessions from the DSS UI. In addition, the whole folder of the ML Task (including `sessions`) is removed when the user deletes a MLTask (or its containing visual analysis) from the DSS UI.

### splits

If you use the Python (in-memory) machine learning model, the splits folder contains the train and test splits data, which can become big.

DSS does not automatically remove old splits data, as the user may want to reuse them at a later time by reusing train/test split settings with the same configuration. The whole folder of the ML Task (including `splits`) is removed when the user deletes a MLTask (or its containing visual analysis) from the DSS UI.

It is possible to manually remove old CSV files in each `splits` folder, but you will lose some of the ability to compare exactly models since they won’t be based on the same splits. In addition, you might lose the _Predicted Data_ and _Charts_ screens

## Temporary files

  * Location in data dir: `tmp`

  * Kind of data: temporary data

  * Include in backups: No




The `tmp` folder contains various temporary data. Most of it is automatically cleared as needed. Cleanup is not generally required.

### Manual cleanup

This folder can be cleared (i.e. remove all the files within the folder, but **not the folder itself**) while **DSS is not running**.
    
    
    ./bin/dss stop
    rm -rf tmp/*
    ./bin/dss start
    

Warning

Removing `tmp` or altering its content while DSS is running may render DSS inoperative

## Caches

  * Location in data dir: `caches`

  * Kind of data: cached data

  * Include in backups: No




The `cache` contains precomputed data, used notably for the Explore and Charts features. This folder can be cleared (i.e. remove all the files within the folder, but not the folder itself) while DSS is not running.

### Manual cleanup

Removing data from the caches folder can lead to increased display time for Explore and Charts the first time they are used after the removal.
    
    
    ./bin/dss stop
    rm -rf caches/*
    ./bin/dss start
    

## Exports

  * Location in data dir: `exports`

  * Kind of data: temporary data

  * Include in backups: As desired




The `exports` folder contains download files for exports made by users

There is one subfolder of `exports` per stored export data.

### Manual cleanup

You can remove old subfolders within this folder. Removing them will make the exports not available anymore for download by users

## Pre-migration backups

Prior to upgrading DSS, a pre-migration backup is automatically taken and stored in your data dir with the prefix _pre_migration_backup_YYYYMMDD. If there are no active migrations and you no longer need historical backups, you can remove these files from the root of your data dir.

## On Dataiku Cloud

On Dataiku Cloud, the total disk space of your Dataiku instances is defined in your plan.

The following could be taking up disk space in the Dataiku instance data directory and can be cleared within Dataiku or the Launchpad by any user with permissions on the project or item:

  * Code environments (you can delete unused code environments in the Launchpad or rationalize duplicate ones)

  * Analysis models, ie Visual Analyses, including ML Models (from the UI in the relevant projects, the user with project access can delete Visual analyses no longer needed)

  * Saved Models: When a machine learning model is deployed from an ML Task onto the Flow of a project, a copy of the data for this saved model is made in the data directory. Each time the saved model is retrained by running it from the Flow, a new version of the saved model is made, and a new copy of the model data is kept. The size of a saved model version is highly dependent on the algorithm and characteristics of the data, and can range from hundreds of kilobytes to gigabytes. Dataiku never automatically removes old versions of saved models, as the user may elect to revert to a previous version at any time (for example if he notices that the newer version does not perform as expected). Old versions can be removed by the user from the UI of a saved model.




Note

Note that this 500 GB limit can be lifted upon motivated customer request.

---

## [operations/dsscli]

# dsscli tool

Note

These instructions do not apply to Dataiku Cloud

`dsscli` is a command-line tool that can perform a variety of runtime administration tasks on DSS. It can be used directly by a DSS administrator, or incorporated into automation scripts.

Most dsscli operations are performed through the DSS public API and can thus also be performed using the [DSS public API Python client](<https://developer.dataiku.com/latest/api-reference/python/index.html> "\(in Developer Guide\)"). You can also directly query the [DSS REST API](<../publicapi/index.html>).

## Running dsscli

dsscli is made of a large number of commands. Each command performs a single administration task. Each command takes arguments and options

From the DSS data directory, run `./bin/dsscli <command> <arguments>`

  * Running `./bin/dsscli -h` will list the available commands.

  * Running `./bin/dsscli <command> -h` will show the detailed help of the selected command.




For example, to list jobs history in project MYPROJECT, use `./bin/dsscli jobs-list MYPROJECT`

## dsscli vs dssadmin

Another command-line tool is available in the DSS data directory for performing management tasks on DSS: `./bin/dssadmin`

  * dssadmin is mostly for “installation-kind” of commands (setting up R, Spark or Hadoop integration for example)

  * dsscli is mostly for “day-to-day” routine operations (creating users, running jobs, …)




## Security-related commands

dsscli provides commands to:

  * Create, delete, list and edit users

  * Create, delete, list and edit groups

  * Create, delete, list and edit API keys




### user-create
    
    
    dsscli user-create [-h] [--email EMAIL]
                               [--source-type SOURCE_TYPE]
                               [--display-name DISPLAY_NAME]
                               [--user-profile USER_PROFILE] [--group GROUP]
                               login password
    

  * `SOURCE_TYPE` must be either `LOCAL` to create a regular user (in the DSS users database), `LDAP` to create a user that will authenticate through LDAP or `LOCAL_NO_AUTH` for authentication through SSO. See [Configuring LDAP authentication](<../security/authentication/ldap.html>) and [Single Sign-On](<../security/sso.html>) for more information. Note that even for LDAP and LOCAL_NO_AUTH, dsscli expects a “password” argument. Enter any random string, it will be ignored. The default is `LOCAL`

  * `USER_PROFILE` is one of the possible user profiles defined by your license. For most DSS licenses, it is one of `READER`, `DATA_ANALYST` or `DATA_SCIENTIST`. The default is specified by your configuration

  * The `--group GROUP` argument can be specified multiple times to place the user in multiple groups




### users-list
    
    
    dsscli users-list
    

### user-delete
    
    
    dsscli user-delete [-h] login
    
    positional arguments:
            login       Login to delete
    

### user-edit

Modifies the settings of an existing user.
    
    
    dsscli user-edit [-h] [--password PASSWORD]
                             [--display-name DISPLAY_NAME] [--email EMAIL]
                             [--user-profile USER_PROFILE] [--group GROUP]
                             login
    

Each of password, display name, email, user-profile and groups can be modified independently.

For example, running `dsscli user-edit --email mynewemail@company.com user` will only modify the email address, and leave all other fields unmodified.

All groups are modified at once: thus to modify groups, you need to pass a new list of groups, which will be the new complete list.

It is not possible to modify password for a LDAP or LOCAL_NO_AUTH user

### groups-list

Lists all groups in DSS
    
    
    dsscli groups-list [-h] [--with-permissions] [--output OUTPUT]
                           [--no-header]
    

If `--with-permissions` is specified, additional columns are added to the output with global permissions, as detailed in [Main project permissions](<../security/permissions.html>)

### group-create

Creates a group by name
    
    
    dsscli group-create [-h] [--description DESCRIPTION]
                          [--source-type SOURCETYPE] [--admin ADMIN]
                          [--may-manage-code-envs MAYMANAGECODEENVS]
                          [--may-create-code-envs MAYCREATECODEENVS]
                          [--may-write-unsafe-code MAYWRITEUNSAFECODE]
                          [--may-write-safe-code MAYWRITESAFECODE]
                          [--may-create-projects MAYCREATEPROJECTS]
                          [--may-manage-udm MAYMANAGEUDM]
                          [--may-edit-lib-folders MAYEDITLIBFOLDERS]
                          [--may-develop-plugins MAYDEVELOPPLUGINS]
                          [--may-create-authenticated-connections MAYCREATEAUTHENTICATEDCONNECTIONS]
                          name
    

All of the `--may-xxx` flags take “true” or “false” as argument, and refer to one of the global permissions as detailed in [Main project permissions](<../security/permissions.html>)

SOURCETYPE can be either LDAP or LOCAL. Note that LDAP groups need to declare mappings to LDAP groups to be functional, but this feature is not currently in dsscli. You need to use the DSS API clients.

Adding users in groups is done by editing these users.

### group-edit

Edits the settings of a group by name
    
    
    dsscli group-edit [-h] [--description DESCRIPTION]
                          [--source-type SOURCETYPE] [--admin ADMIN]
                          [--may-manage-code-envs MAYMANAGECODEENVS]
                          [--may-create-code-envs MAYCREATECODEENVS]
                          [--may-write-unsafe-code MAYWRITEUNSAFECODE]
                          [--may-write-safe-code MAYWRITESAFECODE]
                          [--may-create-projects MAYCREATEPROJECTS]
                          [--may-manage-udm MAYMANAGEUDM]
                          [--may-edit-lib-folders MAYEDITLIBFOLDERS]
                          [--may-develop-plugins MAYDEVELOPPLUGINS]
                          [--may-create-authenticated-connections MAYCREATEAUTHENTICATEDCONNECTIONS]
                          name
    

All of the `--may-xxx` flags take “true” or “false” as argument, and refer to one of the global permissions as detailed in [Main project permissions](<../security/permissions.html>)

SOURCETYPE can be either LDAP or LOCAL. Note that LDAP groups need to declare mappings to LDAP groups to be functional, but this feature is not currently in dsscli. You need to use the DSS API clients.

Adding users in groups is done by editing these users.

### api-keys-list

Lists global API keys

### api-key-create

Creates a global API key
    
    
    dsscli api-key-create [-h] [--output OUTPUT] [--no-header]
                              [--description DESCRIPTION] [--label LABEL]
                              [--admin ADMIN]
                              [--may-manage-code-envs MAYMANAGECODEENVS]
                              [--may-create-code-envs MAYCREATECODEENVS]
                              [--may-write-unsafe-code MAYWRITEUNSAFECODE]
                              [--may-write-safe-code MAYWRITESAFECODE]
                              [--may-create-projects MAYCREATEPROJECTS]
                              [--may-manage-udm MAYMANAGEUDM]
                              [--may-edit-lib-folders MAYEDITLIBFOLDERS]
                              [--may-develop-plugins MAYDEVELOPPLUGINS]
                              [--may-create-authenticated-connections MAYCREATEAUTHENTICATEDCONNECTIONS]
    

The `--admin` flag and all of the `--may-xxx` flags take “true” or “false” as argument, and refer to one of the global permissions as detailed in [Main project permissions](<../security/permissions.html>)

### api-key-edit

Edits a global API key
    
    
    dsscli api-key-edit [-h] [--output OUTPUT] [--no-header]
                              [--description DESCRIPTION] [--label LABEL]
                              [--admin ADMIN]
                              [--may-manage-code-envs MAYMANAGECODEENVS]
                              [--may-create-code-envs MAYCREATECODEENVS]
                              [--may-write-unsafe-code MAYWRITEUNSAFECODE]
                              [--may-write-safe-code MAYWRITESAFECODE]
                              [--may-create-projects MAYCREATEPROJECTS]
                              [--may-manage-udm MAYMANAGEUDM]
                              [--may-edit-lib-folders MAYEDITLIBFOLDERS]
                              [--may-develop-plugins MAYDEVELOPPLUGINS]
                              [--may-create-authenticated-connections MAYCREATEAUTHENTICATEDCONNECTIONS]
                              key
    

The `--admin` flag and all of the `--may-xxx` flags take “true” or “false” as argument, and refer to one of the global permissions as detailed in [Main project permissions](<../security/permissions.html>)

### api-key-delete

Deletes a global API key
    
    
    api-key-delete [-h] key
    

## Jobs-related commands

These commands are used to trigger, list and abort jobs and scenarios

### jobs-list

Lists jobs for a given project, both running ones and past ones
    
    
    dsscli jobs-list [-h] [--output OUTPUT] [--no-header] project_key
    

Returns a list like:

Job id | State | From scenario  
---|---|---  
Build_dataset1_2017-10-25T13-05-23.615 | RUNNING |   
Build_dataset1_2017-10-25T13-05-23.615 | FAILED |   
Build_dataset1_2017-10-25T12-45-32.864 | FAILED |   
Build_Other_2017-10-25T12-43-31.463 | DONE |   
  
### build

Runs a DSS job to build one or several datasets, saved models or managed folders
    
    
    build [-h] [--output OUTPUT] [--no-header] [--wait]
                         [--mode MODE] [--dataset DATASET [DATASET ...]]
                         [--folder FOLDER] [--model MODEL]
                         project_key
    

#### Specifying outputs to build

To build “dataset1” and “dataset2” in project “PROJECT1”, run: `dsscli build PROJECT1 --dataset dataset1 --dataset dataset2`

  * For partitioned datasets, use the following syntax: `dsscli build PROJECT1 --dataset dataset1 partition1`

  * For multiple partitions, use the regular partition specification syntax:

>     * `dsscli build PROJECT1 --dataset dataset1 FR,EN`
> 
>     * `dsscli build PROJECT1 --dataset dataset1 2017-01-02/2017-01-14`
> 
>     * `dsscli build PROJECT1 --dataset dataset1 2017-01-02/2017-01-14|FR,2017-01-02/2017-01-30|EN`




#### Build modes

Use –mode to switch between the different build modes of the DSS flow. The argument must be one of:

  * RECURSIVE_BUILD,

  * NON_RECURSIVE_FORCED_BUILD

  * RECURSIVE_FORCED_BUILD

  * RECURSIVE_MISSING_ONLY_BUILD




#### Other

The –wait argument makes dsscli wait for the end of the job (either success or failure) before returning. If the job fails or is aborted, dsscli returns with a non-zero exit code.

If not waiting, dsscli prints the new job id

### job-abort

Aborts a running job
    
    
    dsscli job-abort [-h] project_key job_id
    

The job_id is the first column returned by the `dsscli jobs-list` command

### job-status

Gets the status of a job
    
    
    dsscli job-status [-h] [--output OUTPUT] [--no-header]
                              project_key job_id
    

## Scenarios-related commands

### scenarios-list

Lists scenarios of a project
    
    
    dsscli scenarios-list [-h] [--output OUTPUT] [--no-header]
                                  project_key
    

### scenario-runs-list

Lists previous and current runs of a scenario
    
    
    dsscli scenario-runs-list [-h] [--output OUTPUT] [--no-header]
                                      [--limit LIMIT] [--only-finished-runs]
                                      project_key scenario_id
    

  * `--only-finished-runs` limits output to runs that are finished (either succeeded, failed or was aborted)

  * `--limit` limits the number of returned runs. Default is 10




### scenario-run

Runs a scenario
    
    
    dsscli scenario-run [-h] [--output OUTPUT] [--no-header] [--wait]
                                [--no-fail] [--params RUN_PARAMS]
                                project_key scenario_id
    

If the scenario was already running, the run is cancelled, and a flag is returned in the output

If `--wait` is passed, command waits for the scenario to be complete and fails if the scenario fails, except if `--no-fail` is passed. It also fails if the run is cancelled because the scenario was already running

`--params` is an optional file containing run parameters as a JSON dict. Use ‘-’ for stdin

### scenario-abort
    
    
    dsscli scenario-abort [-h] project_key scenario_id
    

Aborts the current run of a scenario, if any. Does not fail if the scenario was not running

## Projects-related commands

### projects-list

Lists all project keys and names. For example:
    
    
    ./bin/dsscli projects-list
    

Project key | Name  
---|---  
DKU_HAIKU_STARTER | Haiku Starter for Administrator  
  
### project-export

Exports a project as zip archive to the specified path. Set the optional flags to modify export options.
    
    
    project-export [-h] [--uploads] [--no-uploads]
                                  [--managed-fs] [--no-managed-fs]
                                  [--managed-folders] [--no-managed-folders]
                                  [--input-managed-folders]
                                  [--no-input-managed-folders]
                                  [--input-datasets] [--no-input-datasets]
                                  [--all-datasets] [--no-all-datasets]
                                  [--analysis-models] [--no-analysis-models]
                                  [--saved-models] [--no-saved-models]
                                  project_key path
    
    positional arguments:
      project_key           Project key to export
      path                  Target archive path
    

Example:
    
    
    ./bin/dsscli project-export DKU_HAIKU_STARTER DKU_HAIKU_STARTER.zip
    
    Exporting with options: {"exportManagedFolders": false, "exportAllDatasets": false, "exportManagedFS": false, "exportAllInputDatasets": false, "exportUploads": true, "exportAnalysisModels": true, "exportSavedModels": true, "exportAllInputManagedFolders": false}
    

### project-import

Import a project from project zip file.
    
    
    project-import [-h] [--project-key PROJECT_KEY]  [--remap-connection OLD_CONNECTION=NEW_CONNECTION] path
    
        positional arguments:
          path                  Source archive path
    
        optional arguments:
          --project-key PROJECT_KEY
                                Override project key
          --remap-connection OLD_CONNECTION=NEW_CONNECTION
                                Remap a connection
    

In this example my imported project will have the project key `IMPORTED_PROJECT`. Example:
    
    
     ./bin/dsscli project-import --project-key=IMPORTED_PROJECT --remap-connection filesystem-managed=limited-filesystem MY_PROJECT.zip
    Uploading archive ...
    Importing ...
    Import successful
    

### project-delete

Delete a project. Returns nothing on success.
    
    
    project-delete [-h] project_key
    
    positional arguments:
      project_key  Project key of project to delete
    

Example:
    
    
    ./bin/dsscli project-delete DKU_HAIKU_STARTER
    

### bundle-export (Design node only)

Creates a new bundle for the specified project. If the `bundle_id` already exists for the project, you will receive an error.
    
    
    bundle-export [-h] project_key bundle_id
    
    positional arguments:
      project_key  Project key for which to export a bundle
      bundle_id    Identifier of the bundle to create
    
    
    
    ./bin/dsscli bundle-export DKU_HAIKU_STARTER v1
    Start exporting bundle v1 ...
    Export completed
    

### bundles-list-exported (Design node only)

Returns a table of bundle ids for the specified project. If `--with-data` is specified, the full export manifest will be returned in JSON array format.
    
    
    bundles-list-exported [-h] [--with-data] project_key
    
    positional arguments:
      project_key           Project key for which to list bundles
    
    optional arguments:
      --with-data           Retrieve full information for each bundle
    

Example:
    
    
    ./bin/dsscli bundles-list-exported DKU_HAIKU_STARTER
    Bundle id
    -----------
    v1
    v2
    v3
    

### bundle-download-archive (Design node only)

Downloads a bundle as a zip file.
    
    
    bundle-download-archive [-h] project_key bundle_id path
    
    positional arguments:
      project_key  Project key for which to export a bundle
      bundle_id    Identifier of the bundle to create
      path         Target file (- for stdout)
    

Example:
    
    
    ./bin/dsscli bundle-download-archive DKU_HAIKU_STARTER v1 dku_haiku_bundle_v1.zip
    

### project-create-from-bundle (Automation node only)

Creates a project on the Automation node based on a project bundle archive generated from the Design node.
    
    
    project-create-from-bundle archive_path
    
    positional arguments:
      archive_path          Archive path
    

Example:
    
    
    ./bin/dsscli project-create-from-bundle ../DESIGN_DATADIR/dku_haiku_bundle_v1.zip
    
    Project key
    -----------------
    DKU_HAIKU_STARTER
    

### bundles-list-imported (Automation node only)

Lists all bundles per project on the automation node. If `--with-data` is specified, the full export manifest in JSON array format for each bundle is returned.
    
    
    bundles-list-imported [-h] project_key
    
    positional arguments:
      project_key           Project key for which to list bundles
    

Example:
    
    
    ./bin/dsscli bundles-list-imported DKU_HAIKU_STARTER
    
    Bundle id
    -----------
    v1
    

### bundle-import (Automation node only)

Imports a bundle on the automation node from a zip file archive. If project does not already exist, use `project-create-from-bundle`.
    
    
    bundle-import [-h] project_key archive_path
    
    positional arguments:
      project_key           Project key for which to import a bundle
      archive_path          Archive path
    

Example:
    
    
    ./bin/dsscli bundle-import DKU_HAIKU_STARTER ~/DESIGN_DATADIR/dku_haiku_bundle_v1.zip
    
    Project key          Bundle id
    -------------------  -----------
    DKU_HAIKU_STARTER    v1
    

### bundle-activate (Automation node only)

Activates a bundle on the automation node. Connection and code environment re-mappings should happen prior to activation.
    
    
    bundle-activate [-h] project_key bundle_id
    
    positional arguments:
      project_key  Project key for which to activate a bundle
      bundle_id    Identifier of the bundle to activate
    

Example:
    
    
    ./bin/dsscli bundle-activate DKU_HAIKU_STARTER v1
    {
      "aborted": false,
      "unknown": false,
      "alive": false,
      "runningTime": 0,
      "hasResult": true,
      "result": {
        "neededAMigration": false,
        "anyMessage": false,
        "success": false,
        "messages": [],
        "warning": false,
        "error": false,
        "fatal": false
      },
      "startTime": 0
    }
    

## Datasets related commands

### datasets-list

Lists the Project key, Name and Type for all datasets in a specified project.
    
    
    datasets-list [-h] project_key
    
    positional arguments:
      project_key           Project key for which to list datasets
    

Example:
    
    
    ./bin/dsscli datasets-list DKU_HAIKU_STARTER
    

Project key | Name | Type  
---|---|---  
DKU_HAIKU_STARTER | Orders | FilesInFolder  
  
### dataset-schema-dump

Outputs the Name, Type, Meaning and Max. length for all columns in a dataset schema. Meaning and Max. length will only be returned if they were modified from the default.
    
    
    dataset-schema-dump [-h] project_key name
    
    positional arguments:
      project_key           Project key of the dataset
      name                  Dataset for which to dump the schema
    

Example:
    
    
    ./bin/dsscli dataset-schema-dump DKU_HAIKU_STARTER Orders
    

The output would look like:

Name | Type | Meaning | Max. length  
---|---|---|---  
tshirt_quantity | bigint | Integer | 200  
  
### dataset-list-partitions

Lists all partition values for a specified dataset.
    
    
    dataset-list-partitions [-h] project_key name
    
    positional arguments:
      project_key           Project key of the dataset
      name                  Dataset for which to list partitions
    

For example, for a dataset with two partitions `puchase_date` and `merchant_id`, the output would look like:

purchase_date | merchant_id  
---|---  
2020-12-15 | 437  
  
### dataset-clear

Clears the specified dataset and partition, if specified.
    
    
    dataset-clear [-h] [--partitions PARTITIONS] project_key name
    
    positional arguments:
      project_key           Project key of the dataset
      name                  Dataset to clear
    
    optional arguments:
      --partitions PARTITIONS List of partitions to clear
    

Example:
    
    
    ./bin/dsscli dataset-clear DKU_HAIKU_STARTER Orders_enriched
    

### dataset-delete

Deletes the specified dataset.
    
    
    dataset-delete [-h] project_key name
    
    positional arguments:
      project_key  Project key of the dataset
      name         Dataset to delete
    

Example:
    
    
    ./bin/dsscli dataset-delete DKU_HAIKU_STARTER Orders_enriched
    

## Managed folders related commands

### managed-folders-list

Lists all managed folders for the specified project.
    
    
    managed-folders-list [-h] project_key
    
    positional arguments:
      project_key           Project key of the managed folders
    

Example:
    
    
    ./bin/dsscli managed-folders-list DKU_HAIKU_STARTER
    

Name | Type | Id  
---|---|---  
Orders | Filsystem | O2ue6CX3  
  
### managed-folder-list-contents

Lists the contents of a particular managed folder. `managed_folder_id` is the `Id` returned in a call to `managed-folders-list`.
    
    
    managed-folder-list-contents [-h] project_key managed_folder_id
    
    positional arguments:
      project_key           Project key of the managed folders
      managed_folder_id     Managed folder id
    

Example:
    
    
    ./bin/dsscli managed-folder-list-contents DKU_HAIKU_STARTER O2ue6CX3
    

Path | Size | Last Modified  
---|---|---  
/orders_2017-01.csv | 40981 | 2021-01-25T18:49:48+00:00  
  
### managed-folder-get-file

Allows you to download a specified file from a managed folder to your server. If no `--output-file` is specified, the contents of the `file_path` file will be output to the console.
    
    
    managed-folder-get-file [-h] [--output-file OUTPUT_FILE] project_key managed_folder_id file_path
    
    positional arguments:
      project_key           Project key of the managed folders
      managed_folder_id     Managed folder id
      file_path             File path
    
    
    optional arguments:
      --output-file OUTPUT_FILE
                            Path to output file
    

Example:
    
    
    ./bin/dsscli managed-folder-get-file DKU_HAIKU_STARTER O2ue6CX3 orders_2017-01.csv --output-file my_local_orders.csv
    

## Connections-related commands

### connections-list

Lists all connections with their type and flags, like this:
    
    
    ./bin/dsscli connections-list
    

Name | Type | Allow write | Allow managed datasets | Usable by | Credentials mode  
---|---|---|---|---|---  
filesystem_managed | Filsystem | True | True | ALLOWED | GLOBAL  
  
## Code env related commands

### code-envs-list

Lists the Name, Language and Type of all code environments.

Example:
    
    
    ./bin/dsscli code-envs-list
    

Name | Language | Type  
---|---|---  
python36 | PYTHON | DESIGN_MANAGED  
  
### code-env-update

Allows you to perform an “update” for a particular code environment. If the `--force-rebuild-env` flag is included, it will clear the code environment and rebuild it from scratch. Nothing is returned on success.
    
    
    code-env-update [-h] [--force-rebuild-env] lang name
    
    positional arguments:
      lang                 Language of code env to update
      name                 Name of code env to update
    
    optional arguments:
      --force-rebuild-env  Force rebuilding of the code env
    

In this example `PYTHON` is the language and `python36` is the code environment name. Example:
    
    
    ./bin/dsscli code-env-update PYTHON python36 --force-rebuild-env
    

## API services related commands

### api-services-list

Lists all API services per project.
    
    
    api-services-list [-h] project_key
    

Returns a list of service Ids, Endpoints and Public flags. Example:
    
    
    ./bin/dsscli api-services-list DKU_HAIKU_STARTER
    

Id | Public? | Endpoints  
---|---|---  
Tutorial_Deployment | Yes | High_Revenue_Customers (STD_PREDICTION)  
  
### api-service-package-create

Creates a package for an API service based on a project and service_id, which is the same as the `Id` returned from the `api-services-list` call. If no `--name` is specified, the version number will automatically be set to the next package version number available for the service. If no `--path` is specified, the package will be downloaded to your current directory.
    
    
    api-service-package-create [-h] [--name NAME] [--path PATH]  project_key service_id
    
    positional arguments:
      project_key  Project key containing service
      service_id   API service to package
    
    optional arguments:
      --name NAME  Name for the package (default: auto-generated)
      --path PATH  Path to download the package to (default: current directory)
    

Examples:
    
    
    ./bin/dsscli api-service-package-create DKU_HAIKU_STARTER Tutorial_Deployment
    Downloading package to v3.zip
    
    ./bin/dsscli api-service-package-create DKU_HAIKU_STARTER Tutorial_Deployment --name v7 --path /Users/ssinick/Documents/
    Downloading package to /Users/ssinick/Documents/v7.zip
    

## Code studio templates related commands

### code-studio-templates-list

Lists the ids and names of all code studio templates.

Example:
    
    
    ./bin/dsscli code-studio-templates-list
    

Id | Label  
---|---  
streamlit | Streamlit  
  
### code-studio-templates-build

Allows you to re-build images of your code studio templates.
    
    
    code-studio-templates-build [-h] [template_ids ...]
    
    optional argument:
      template_ids  The template ids, separated by a space, that you want to rebuild. By default, all templates are rebuilt.
    

In this example, we want to rebuild the code studio template with the id “streamlit”:
    
    
    ./bin/dsscli code-studio-templates-build streamlit
    > Building 1 code studio templates
    > Building streamlit ..... done
    > 1 successfully built, 0 failed
    

## Controlling dsscli output

All dsscli commands that display results take two additional arguments:

  * `--no-header` removes column headers from display to make them easier to parse (each line of the output directly corresponds to one data item)

  * `--output json` to format output as JSON for machine consumption (the default is `--output fancy`)

---

## [operations/index]

# Operating DSS

This section covers various operations that you may need to perform during day-to-day usage of DSS.

---

## [operations/license]

# DSS license

Dataiku DSS requires an up-to-date license to work.

## Free Edition

If you use the [Free Edition](<https://www.dataiku.com/dss/editions/>), the license is automatically generated when you fill out the form the first time you start the product, and never needs updating.

## Enterprise Edition

If you use the [Enterprise Edition](<https://www.dataiku.com/dss/editions/>), Dataiku provides you with a license file, used to install Dataiku DSS (see: [Installing a new DSS instance](<../installation/custom/initial-install.html>)).

When renewing the license of an existing Dataiku DSS installation, Dataiku provides you with a new file. There are a few ways to update the license with the new file:

  * Copy your new license file into DATA_DIR/config/license.json (needs restart of DSS)

  * Log into Dataiku DSS, click the “Administration” gear, then click “Enter license” and enter the contents of the license file.

---

## [operations/logging]

# Logging in DSS

Note

These instructions do not apply to Dataiku Cloud

## Introduction

DSS processes write their log files to directory `DATADIR/run`:

Log file | Content  
---|---  
backend.log | Logs of the main DSS process (backend). This includes logs for all user operations directly performed in DSS, including through APIs.  
ipython.log | Logs of the Jupyter server, used by Python and R notebooks.  
eventserver.log | Logs of the event server process, when enabled.  
governserver.log | Logs of the Govern server process, on Govern nodes  
nginx.log | General log of the main HTTP server (nginx). This does not include the trace of user activity  
nginx/access.log | Access log of the main HTTP server (nginx)  
supervisord.log | Process control and supervision. This log file contains traces of all processes starts / stops  
frontend.log | Logs of Javascript activity on user’s browsers  
  
## Configuring log file rotation

### Main DSS processes log files

By default, the “main” log files are rotated when they reach a given size, and purged after a given number of rotations. The following installation configuration directives can be used to customize this behavior.

By default, rotation happens every 100 MB and 10 files are kept
    
    
    [logs]
    # Maximum file size, default 100MB.
    # Suffix multipliers "KB", "MB" and "GB" can be used in this value.
    logfiles_maxbytes = SIZE
    # Number of retained files, default 10.
    logfiles_backups = NUMBER_OF_FILES
    

You should then regenerate DSS configuration and restart DSS, as described in [Installation configuration file](<../installation/custom/advanced-customization.html#install-ini>).

This procedure applies to the following log files:

  * backend.log

  * ipython.log

  * nginx.log

  * eventserver.log

  * governserver.log




### frontend.log

This is a low-level log for debug purposes only. It is rotated independently of the others, on a non-configurable schedule.

### nginx/access.log

This file is rotated daily, whatever its size. The rotated file is compressed. Older files are then purged, in order to keep a total max size of logs below 64 MB

In the ini file, you can override this behavior
    
    
    [logs]
    # Set this to false to disable access.log rotation
    rotate_accesslog = true
    
    # Maximum cumulative size to keep (in bytes). Suffix multipliers are not allowed
    accesslog_purge_size = 67108864
    

### Audit logs

See [Audit Trail](<../security/audit-trail.html>).

### Manual log file rotation

The following command forces DSS to close and reopen its log files (main DSS processes log files and nginx access log). Combined with standard tools like `logrotate(8)`, this lets you take full control over the DSS log rotation process, and integrate it in your log file handling framework.
    
    
    # Use standard Unix commands to rename DSS current log files
    ...
    # Force DSS to reopen new log files
    DATADIR/bin/dss reopenlogs
    

## Customizing log levels

Warning

We strongly recommend that you **do not** customize log levels without input from Dataiku Support.

Modifying or lowering the logging levels can potentially reduce the ability of Dataiku Support to investigate / debug certain issues and result in an overall degraded support experience. In these situations, you will likely be asked to revert these logging level changes and reproduce the issue when further investigation is required.

Note

Dataiku DSS has been confirmed to be not vulnerable to the family of vulnerabilities regarding Log4J. No mitigation action nor upgrade is required. Dataiku does not use any affected version of Log4J, and keeps monitoring the security situation on all of its dependencies.

You can configure the log level:

  * By logger (logging category)

  * By process




In a typical DSS log line:
    
    
    [2017/02/13-09:01:01.421] [DefaultQuartzScheduler_Worker-1] [INFO] [dku.projects.stats.git]  - [ct: 365] Analyzing 17 commits
    

The logger is the 4th component: `dku.projects.stats.git`

Log levels are configured by creating, in the DSS data dir, a file named `resources/logging/dku-log4j.properties`
    
    
    # Set, for all processes, the 'dku.recipes.sql' logger to INFO level.
    # Note that this also sets INFO for all subloggers of dku.recipes.sql
    log4j.logger.dku.recipes.sql = INFO
    

Properties set in dku-log4j.properties will apply to all main DSS processes (See [The different Java processes](<../installation/custom/advanced-java-customization.html#java-processes-definition>) for more information).

To set log levels only for a certain type of processes, like jek, create a file named `resources/logging/dku-jek-log4j.properties` and add the same kind of properties.

---

## [operations/macros]

# DSS Macros

Macros are predefined actions that allow you to automate a variety of tasks, like:

  * Maintenance and diagnostic tasks

  * Specific connectivity tasks for import of data

  * Generation of various reports, either about your data or DSS




Macros can either be:

  * Run manually, from a Project’s “Macros” screen.

  * Run automatically from a scenario step

  * Made available for running to dashboard users by adding them on a dashboard.




Macros can be:

  * Provided as part of DSS

  * In a plugin

  * Developed by you




For example, the following macros are provided as part of DSS:

  * Generate an audit report of which connections are used

  * List and mass-delete datasets by tag filters

  * Clear internal DSS databases

  * Clear old DSS job logs

  * Kill Jupyter sessions that have either been running or idle for too long




Macros are designed to make repetitive tasks or tasks that would require to write code each time easier. Other examples could be:

  * Creating a project, adding a set of groups to it and performing various other settings (if you need to create a large number of projects)

  * Importing a folder full of files and creating one dataset for each




Some macros can be used by all DSS users (like data-import-related macros) or only by administrators (like clearing internal databases)

You can write your own macros in Python. For more information, see [Component: Macros](<../plugins/reference/macros.html>)

---

## [operations/memory]

# Tuning and controlling memory usage

Note

It is strongly recommended that you get familiar with the different kind of processes in DSS to understand this section. See [Understanding and tracking DSS processes](<processes.html>) for more information

## The backend

The backend is a Java process that has a fixed memory allocation set by the `backend.xmx` ini parameter.

It is recommended to allocate ample Java memory to the backend. Backend memory requirement scales with:

  * The number of users

  * The number of projects, datasets, recipes, …

  * Overall activity (automatically running scenarios, use of data preparation design)




For large production instances, we recommend allocating 12 to 20 GB of memory for the backend.

If the memory allocation is insufficient, the DSS backend may crash. This will result in the “Disconnected” overlay appearing for all users and running jobs/scenarios to be aborted. The backend restarts automatically after a few seconds.

### Setting the backend Xmx

In this example, we are setting the backend Xmx to 12g

  * Go to the DSS data directory




Note

On macOS, the DATA_DIR is always: `$HOME/Library/DataScienceStudio/dss_home`

  * Stop DSS

> ./bin/dss stop
>         

  * Edit the install.ini file

  * If it does not exist, add a `[javaopts]` section

  * Add a line: `backend.xmx = 12g`

  * Regenerate the runtime config:

> ./bin/dssadmin regenerate-config
>         

  * Start DSS

> ./bin/dss start
>         




For more details on how to tune Java processes settings, see [Advanced Java runtime configuration](<../installation/custom/advanced-java-customization.html>).

### Investigate if a crash is related to memory

If you experience the “Disconnected” overlay and want to know if it’s related to lack of backend memory:

  * Open the `run/backend.log` file (or possibly one of the rotated files `backend.log.X`)

  * Locate the latest “DSS startup: backend version” message

  * Just before this, you’ll see the logs of the crash. If you see `OutOfMemoryError: Java heap space` or `OutOfMemoryError: GC Overhead limit exceeded`, then you need to increase `backend.xmx`




## The JEK

The default Xmx of the JEK is 2g. This is enough for a large majority of jobs. However, some jobs with large number of partitions or large number of files to process may require more. This is configured by the `jek.xmx` ini parameter.

Note that:

  * The `jek.xmx` setting is global, and cannot be set per-job, per-user or per-project

  * This memory allocation will be multiplied by the number of JEK (see [Understanding and tracking DSS processes](<processes.html>) for more details), so don’t put a huge amount for `jek.xmx` as it will also be multiplied.




If you see JEK crashes due to memory errors, we recommend that you increase progressively. For example, first to 3g then to 4g.

Cgroups may also be used to set limits to JEK ressources. See [Using cgroups for resource control](<cgroups.html>) for more details. However, for JEK memory, prefer using Xmx since cgroups will cause jobs to be killed.

### Setting the JEK Xmx

In this example, we are setting the JEK Xmx to 3g

  * Go to the DSS data directory




Note

On macOS, the DATA_DIR is always: $HOME/Library/DataScienceStudio/dss_home

  * Stop DSS

> ./bin/dss stop
>         

  * Edit the install.ini file

  * If it does not exist, add a `[javaopts]` section

  * Add a line: `jek.xmx = 3g`

  * Regenerate the runtime config:

> ./bin/dssadmin regenerate-config
>         

  * Start DSS

> ./bin/dss start
>         




For more details on how to tune Java processes settings, see [Advanced Java runtime configuration](<../installation/custom/advanced-java-customization.html>).

### Investigate if a crash is related to memory

If you experience job crashes without error messages and want to know if it’s related to lack of JEK memory:

  * Open the “Full job log” from the Actions menu of the job page

  * Scroll to the end of the log.

  * You’ll see the logs of the crash. If you see `OutOfMemoryError: Java heap space` or `OutOfMemoryError: GC Overhead limit exceeded`, then you need to increase `jek.xmx`




## The FEKs

The default Xmx of each FEK is 2g. This is enough for a large majority of tasks. There may be some rare cases where you’ll need to allocate more memory (generally at the direction of Dataiku Support). This is configured by the `fek.xmx` ini parameter.

Note that:

  * The `fek.xmx` setting is global, and cannot be set per-user or per-project

  * This memory allocation will be multiplied by the number of FEK (see [Understanding and tracking DSS processes](<processes.html>) for more details), so don’t put a huge amount for `fek.xmx` as it will also be multiplied.




### Setting the FEK Xmx

In this example, we are setting the FEK Xmx to 3g

  * Go to the DSS data directory




Note

On macOS, the DATA_DIR is always: `$HOME/Library/DataScienceStudio/dss_home`

  * Stop DSS

> ./bin/dss stop
>         

  * Edit the install.ini file

  * If it does not exist, add a `[javaopts]` section

  * Add a line: `fek.xmx = 3g`

  * Regenerate the runtime config:

> ./bin/dssadmin regenerate-config
>         

  * Start DSS

> ./bin/dss start
>         




For more details on how to tune Java processes settings, see [Advanced Java runtime configuration](<../installation/custom/advanced-java-customization.html>).

## Jupyter notebook kernels

Memory allocation for Jupyter notebooks can be controlled using the [cgroups integration](<cgroups.html>)

Warning

Please note that Jupyter notebook sessions are not terminated automatically. This means that Jupyter notebooks will continue to consume memory until the Jupyter session is explicitly terminated. As a result, you may observe that jupyter processes are consuming memory for days or weeks.

To view currently active Jupyter notebook sessions from the DSS UI, an administrator can navigate to Administration > Monitoring > Running background tasks > notebooks. You can manually unload notebooks to free up memory usage by following the options listed under [unloading jupyter notebooks](<../notebooks/python.html#unloading>).

To manage memory consumption from Jupyter notebooks on a more regular basis, you may want to consider setting up a scenario to run the “Kill Jupyter Sessions” macro to terminate Jupyter notebook sessions that have been open or idle for a long period of time (e.g. 15 days). Note that a notebook session may be triggering long-running computation, so you will want to ensure that this automation doesn’t interfere with active work and that users are notified of this automation accordingly.

## Python and R recipes

Memory allocation for Python and R recipes can be controlled using the [cgroups integration](<cgroups.html>)

Note

This does not apply if you used [containerized execution](<../containers/index.html>) for this recipe. See containerized execution documentation for more information about processes and controlling memory usage for containers

## SparkSQL and visual recipes with Spark engine

These recipes are made of a large number of processes:

  * The Spark driver, a Java process that runs locally

  * The Spark executors, Java processes that run in your cluster (usually through YARN)




Memory for both can be controlled using the usual Spark properties (`spark.driver.memory` and `spark.executory.memory`) which can be set in [Spark named configurations](<../spark/configuration.html>)

## PySpark, SparkR and sparklyr recipes

The case of these recipes is a bit particular, because they are actually made of several processes:

  * A Python or R process which runs your driver code

  * The Spark driver, a Java process that runs locally

  * The Spark executors, Java processes that run in your cluster (usually through YARN)




Memory for the Spark driver and executors can be controlled using the usual Spark properties (`spark.driver.memory` and `spark.executory.memory`) which can be set in [Spark named configurations](<../spark/configuration.html>)

Memory for the local Python or R process can be controlled using the [cgroups integration](<cgroups.html>)

## In-memory machine learning

Memory allocation for in-memory machine learning processes can be controlled using the [cgroups integration](<cgroups.html>)

Note

This does not apply if you used [containerized execution](<../containers/index.html>) for this recipe. See containerized execution documentation for more information about processes and controlling memory usage for containers

## Webapps

Memory allocation for webapps can be controlled using the [cgroups integration](<cgroups.html>)

## API node

Memory consumption on the API node is generally light, so it’s unlikely that you’ll need to modify the API node memory allocation. If you do need to, memory allocation is set by the `apimain.xmx` property in the API node `install.ini` file. Here are the steps you would take to modify the `apimain.xmx` setting:

  * In the API node DATADIR, add an entry in the `install.ini` file for `apimain.xmx`



    
    
    [javaopts]
    apimain.xmx = 4g
    

  * Regenerate the runtime config:



    
    
    ./bin/dssadmin regenerate-config
    

  * Start DSS



    
    
    ./bin/dss start
    

## Govern node

The Govern node memory allocation is configured by the `governserver.xmx` setting.

In this example, we are setting the Xmx to 4g.

  * Go to the Dataiku Govern data directory

  * Stop Dataiku Govern

> ./bin/dss stop
>         

  * Edit the install.ini file

  * If it does not exist, add a `[javaopts]` section

  * Add a line: `governserver.xmx = 4g`

  * Regenerate the runtime config with the govern-admin cli:

> ./bin/govern-admin regenerate-config
>         

  * Start Dataiku Govern

> ./bin/dss start
>         




For more details on how to tune Java processes settings, see [Advanced Java runtime configuration](<../installation/custom/advanced-java-customization.html>).

---

## [operations/monitoring]

# Monitoring DSS

Monitoring the behaviour and proper function of DSS is essential to production readiness and evaluating sizing.

## Concepts

Monitoring DSS is essentially based on three topics:

  * Raising alerts when some services are not working properly

  * Storing and plotting immediate and historical data of host-level statistics (CPU, memory, IO, disk space, …)

  * Storing and plotting immediate and historical data of application-level statistics (users logged in, number of jobs, number of scenarios, …)




DSS itself does not include a monitoring infrastructure (alerting or historical graphs) but provides many APIs and monitoring points that allow you to plug your own monitoring infrastructure onto it.

Any monitoring software that has the ability to run scripts or call HTTP APIs can be used to monitor DSS.

However, Dataiku provides a **non-supported** open source tool called **dkumonitor** that bundles together the common “Graphite / Grafana” stack for easy setup. Usage of dkumonitor is completely optional, it simply provides you with a quick way to deploy this monitoring stack.

## Historizing metrics

Historizing metrics can be done in two main ways:

  * DSS pushes metrics to an historization system

  * An historization system regularly pulls metrics from DSS




### Install the dkumonitor service (optional)

dkumonitor is useful if you don’t already have a Graphite / Grafana stack

Go to <https://github.com/dataiku/dkumonitor> and follow the instructions

### Configure DSS to push metrics

DSS can be configured to send internal and system metrics about the studio to a metrics server. DSS currently supports Graphite (Carbon) servers.

When the monitoring integration is installed:

  * DSS will automatically install and configure a collectd agent. This agent collects host-level statistics and sends them to the Carbon server

  * The DSS backend will start reporting its own application-level metrics to the same Carbon server




You can install the monitoring integration at any time.

#### Prerequisites

The DSS monitoring integration is only supported on Linux platforms.

#### Case 1: Automatic installation, if your DSS server has Internet access

This procedure installs the required binaries and configures the monitoring integration for DSS.

  * Go to the DSS data dir
        
        cd DATADIR
        

  * Stop DSS
        
        ./bin/dss stop
        

  * Run the installation script
        
        ./bin/dssadmin install-monitoring-integration -graphiteServer GRAPHITE_HOST:GRAPHITE_PORT
        




Note

If you already set up a Graphite server into the DSS Administration panel, this step will not override your current settings. To let the setup change these fields too, empty them beforehand.

Note

If you have installed dkumonitor, you need to enter the “base port” of dkumonitor + 1. If you installed dkumonitor on port 27600, then use 27601 as -graphiteServer option

  * Start DSS
        
        ./bin/dss start
        




Note

A prefix for the metrics is automatically computed. If your host is called host.domain.ext, the prefix will be dss.ext.domain.host.DSS_PORT. You can override this prefix by using the -prefix option when running the integration.

#### Case 2: If your DSS server does not have Internet access

To help with the monitoring installation when the DSS server does not have Internet access (directly nor through a proxy), the DSS installation kit includes a standalone script which may be used to download the required binaries and store them to a directory suitable for offline installation on the DSS server.

  * First, download and unpack DSS on a machine with an internet access, then run the following command.
        
        dataiku-dss-VERSION/scripts/install/download-monitoring-packages.sh
        

  * Transport the directory `dataiku-dss-VERSION/tools/collectd` to the DSS server and drop it in `dataiku-dss-VERSION/tools/`.

  * Run the monitoring integration as in case 1.




## Raising alerts

DSS does not provide any builtin alerting mechanism. Zabbix is a common choice for monitoring DSS and raising alerts.

There are a number of ways to do “immediate monitoring” of DSS to raise alerts as soon as an abnormal condition is detected.

### Monitoring the “get-configuration” API endpoint (without authentication)

Configure your monitoring agent to regularly query the /dip/api/get-configuration endpoint on the DSS server. This endpoint is used to bootstrap the UI and does not require authentication.

If this endpoint returns 200, it gives a first indication that DSS is properly responding

### Monitoring any public API endpoint (with authentication)

You can regularly query any “read-only” public API endpoint. For example /public/api/projects/ which lists the projects. This requires authenticating with an API key.

See [Public REST API](<../publicapi/index.html>) for more information

### Running “canary” jobs

One of the most complete ways to regularly test DSS is to:

  * Create a dedicated monitoring project that has a very small and quick Flow

  * Use the Python API to regularly run a small job and wait for it to complete successfully




## Uninstall monitoring integration

If you installed the monitoring integration and wish to remove the integration, you can do so by removing the `collectd` section of your `install.ini` file through the following process:

> 
>     # Stop DSS
>     DATADIR/bin/dss stop
>     # Edit installation options and remove the "collectd" section
>     vi DATADIR/install.ini
>     # Regenerate DSS configuration according to the new settings
>     DATADIR/bin/dssadmin regenerate-config
>     # Restart DSS
>     DATADIR/bin/dss start
>

---

## [operations/processes]

# Understanding and tracking DSS processes

A DSS instance is made of a number of different processes. Each process plays a specific role, and it’s important to understand these in order to properly monitor and manage DSS

## supervisord

When you run `./bin/dss start`, it starts the supervisord, which is a Python process responsible for starting, restarting and monitoring the top-level DSS processes (nginx, backend, jupyter)

## The backend

The backend is the main process of DSS. It holds all of the configuration and the users, it handles the API and the UI of DSS and handles scheduling the scenarios.

The backend is forked by supervisord. The pid of the backend can be found using `./bin/dss status`

Logs for the backend are in `run/backend.log`

Ample Java memory should be allocated to the backend. See [Tuning and controlling memory usage](<memory.html>) for more information.

## The JEKs

Each job in DSS runs in a separate process called a JEK. If you have 10 jobs running at a given time, there will be 10 running JEKs.

DSS will “pre-start” JEK processes so that jobs can start faster. This can be configured in Administration > Resources control > Job Execution Kernels. Each JEK consumes resources, even when they are not currently running jobs, so increase this value with caution.

JEKs are forked by the backend. They can be identified by the “DSSJobKernelMain” name in their command lines. When a JEK is running a job, its pid will appear in:

  * The job UI

  * The Administration > Monitoring > Background tasks UI

  * The job “get status” API




Logs for the JEKs are segregated by job, and can be found in `jobs/PROJECT/JOB_ID/output.log`

The Java memory of JEKs can be tuned (but doesn’t often need to). See [Tuning and controlling memory usage](<memory.html>) for more information.

## The FEKs

From time to time, the DSS backend will “delegate” part of its work to worker processes called the FEKs. This is done mostly for work that may consume huge amounts of memory. If a memory overrun happens, the FEK gets killed but the backend is unaffected.

FEKs only run a single task at a time. When they are done with a task, the FEKs can be assigned another task. From time to time, DSS kills FEKs that have grown too much in size.

FEKs are forked by the backend. They can be identified by the “DSSFutureKernelName” name in their command lines

Logs for the FEKs appear directly within the backend log.

The Java memory of FEKs can be tuned (but doesn’t often need to). See [Tuning and controlling memory usage](<memory.html>) for more information.

## Jupyter notebook server

All Jupyter (Python, R, Scala) notebooks are managed by a top-level server, the Jupyter server.

The Jupyter server is forked by supervisord. Its pid can be found using `./bin/dss status`

For historical reasons, logs for the Jupyter server are in `run/ipython.log`

This process uses small amounts of memory.

## Jupyter notebook kernels

Each time a user opens a notebook, a specific process is created (a Python process for a Python notebook, a R process for a R notebook, a Java process for a Scala notebook).

This per-notebook process holds the actual computation state of the notebook, and is called a “Jupyter kernel”.

When a user navigates away from the notebook, the **kernel remains alive**. This is a fundamental property of Jupyter notebooks and kernels, which allows you to start a long running computation without having to keep the notebook open, and be able to retrieve the result of the computation at a later time.

An important consequence is that, left unchecked, you will generally, after a few days or weeks, have a huge number of alive Jupyter kernels consuming large amounts of memory.

  * End-users can stop their kernels by going to the notebooks list in DSS, and clicking the “Unload” button

  * End-users can also stop their kernels by going to their Activity indicator (from the Activity button in the title bar) and clicking “Abort”

  * Administrators can list and stop kernels by going to Administration > Monitoring > Background tasks, and aborting individual notebooks

  * Administrators can also automatically kill Jupyter kernels that have been left alive for too long using a dedicated macro.




Memory for notebook kernels can be controlled using [cgroups integration](<cgroups.html>). See [Tuning and controlling memory usage](<memory.html>) for more information

## Python / R recipes processes

When a job runs a Python or R recipe, a corresponding Python or R process is created.

Logs for these processes appear directly in the job logs.

Memory for these processes can be controlled using [cgroups integration](<cgroups.html>). See [Tuning and controlling memory usage](<memory.html>) for more information

Note

This does not apply if you used [containerized execution](<../containers/index.html>) for this recipe. See containerized execution documentation for more information about processes and controlling memory usage for containers

## Spark recipes

When a job runs a Spark recipe (including PySpark, SparkR, sparklyr, SparkSQL, Spark-Scala, and “Spark” engine for visual recipes) or R recipe, a Spark driver process (a Java process) is created. A corresponding Python or R process is also created for PySpark, SparkR and sparklyr recipes.

Logs for these processes appear directly in the job logs.

Memory for these processes can be controlled. See [Tuning and controlling memory usage](<memory.html>) for more information

## In-memory machine learning

For each model being trained using the “In-memory (scikit-learn, LightGBM, XGBoost)” or “Deep Learning” engines, a new Python process is created. This process is stopped at the end of the training session.

In-memory machine learning processes can be identified by the `dataiku.doctor.server` in their command-line. Logs for these processes can be found behind the “Logs” button in the machine learning session itself.

Memory for these processes can be controlled using [cgroups integration](<cgroups.html>). See [Tuning and controlling memory usage](<memory.html>) for more information

Note

This does not apply if you used [containerized execution](<../containers/index.html>) for this machine learning session. See containerized execution documentation for more information about processes and controlling memory usage for containers

## Webapps

For each running webapp backend (Flask, Shiny, Bokeh, Dash, Streamlit), a corresponding Python or R process is created.

Memory for these processes can be controlled using [cgroups integration](<cgroups.html>). See [Tuning and controlling memory usage](<memory.html>) for more information

## The governserver

For Govern nodes, the backend process is replaced by the governserver process.

---

## [operations/proxies]

# HTTP proxies

## When to configure HTTP proxies

You may want to configure your DSS instance to work with HTTP proxies when either of the following scenarios applies:

  * Your users need to go through a (direct) proxy to reach the DSS interface. In this scenario, your proxy **must** support the WebSocket protocol, and allow long-lived WebSocket connections.

  * DSS is installed on a server without direct outgoing Internet access and a proxy is required to reach external resources. For configuration steps, visit Configuring a global proxy to allow DSS to access external resources.




Note

This must not be confused with the ability to deploy DSS behind a reverse proxy. See [Using reverse proxies](<../installation/custom/reverse-proxy.html>) for more details.

## About WebSocket

DSS uses the WebSocket protocol for parts of its user interface. The WebSocket protocol may not be supported by all HTTP proxies.

Ensure any direct or reverse proxy configured between DSS and its users correctly supports WebSocket, and is configured accordingly.

At the time of writing, this includes:

  * nginx version 1.3.13 and above (see [nginx websocket proxying](<http://nginx.org/en/docs/http/websocket.html>))

  * Apache 2.4.5 and above (with [mod_proxy_wstunnel](<http://httpd.apache.org/docs/2.4/mod/mod_proxy_wstunnel.html>))

  * Amazon Web Services [Application Load Balancer](<https://aws.amazon.com/elasticloadbalancing/applicationloadbalancer/>)




See [Websockets problems](<../troubleshooting/problems/websockets.html>) for related details and troubleshooting advice.

## Configuring a global proxy to allow DSS to access external resources

### Routing all requests initiated by the DSS backend through a proxy

To route all requests initiated by the DSS backend through the proxy, you’ll need to configure the HTTP Proxy settings in the Administration menu.

  * Go to the **Administration** menu, select the **Settings** tab, and then open the **Misc.** panel.

  * In **HTTP proxy** , supply the proxy host and port.

  * Optional: If the HTTP proxy requires authentication, supply the username and password.




Adding the proxy settings here will route all requests initiated by the DSS backend through the proxy.

### Configuring a proxy for external HTTP-based or FTP-based network resources (for remote datasets)

If DSS runs inside your private network, you may need to configure an outgoing proxy to allow DSS to access external HTTP- or FTP-based network resources.

This applies in particular to HTTP, HTTPS and FTP remote datasets, and Amazon S3, Google Cloud Storage, Azure Blob, Snowflake, BigQuery and Elasticsearch datasets.

You can define a global proxy configuration for DSS in the **Setting** tab of the Administration page. Choose **Proxy** , fill in the fields, and save your changes.

Every HTTP(S)- and FTP-based connection will now have an additional “Use global proxy” checkbox. Clear the checkbox if the connection should not go through the proxy (e.g., for services that are inside your private network). This also applies to Amazon S3, GCS, Azure Blob, Snowflake, BigQuery, and Elasticsearch connections.

Note

SOCKS proxies are not supported in DSS.

Warning

**A note on FTP through HTTP Proxy**

Connecting to a FTP server through an HTTP proxy requires passive mode, and requires the proxy to allow and support HTTP `CONNECT` method on ports 20, 21 and all unpriviledged ports (1024-65535).

Below is a sample Apache 2.4 configuration for this:
    
    
    Listen 3128
    <VirtualHost *:3128>
      ProxyRequests On
      ProxyVia On
      AllowConnect 20 21 443 1024-65535
      <Proxy *>
        Order deny,allow
        Deny from all
        # IP of internal network
        Allow from 1.2.3.4
      </Proxy>
    </VirtualHost>
    

### Configuring a proxy for Python and R processes

Configuring access to external HTTP-based or FTP-based network resources only applies to native connections made from the Data Science Studio backend.

If you need to go through a proxy for network connections done from Python or R code (from a recipe or a notebook), you should configure the proxy using standard configuration directives for these environments. This includes adding explicit proxy parameters to the network calls, e.g., for Python requests:
    
    
    requests.get(URL, proxies={'http', 'http://MYPROXY:MYPROXYPORT'})
    

and/or globally configuring proxy directives through the standard `http_proxy` (`https_proxy`, `ftp_proxy` …) environment variables, e.g.:
    
    
    # Add the following directive to DATADIR/bin/env-site.sh
    # or to the session initialization file of the DSS Unix user (.profile or equivalent)
    export http_proxy="http://MYPROXY:MYPROXYPORT"
    

Refer to Python or R reference manuals for details.

Note

This also applies to network accesses needed to download and install additional Python or R packages.

### Configuring DSS to trust a certificate authority

DSS may reside in a network that uses a cloud-based proxy as a man in the middle (MITM) proxy. In this case, DSS will need to trust the Certificate Authority of that proxy, as it will sign the communication that comes back to DSS.

The most efficient way to do this is via the system’s global trust store:

  * As root, copy the certificates that need to be trusted to /etc/pki/ca-trust/source/anchors

  * Again as root, run the **update-ca-trust** command

  * Finally, as the user running DSS, restart the application using the **DATA_DIR/bin/dss restart** command




For Python or PIP processes that may need to trust the certificate of a MITM proxy, the REQUESTSCABUNDLE environment variable can be used.
    
    
    # Add the following directive to DATADIR/bin/env-site.sh
    # or to the session initialization file of the DSS Unix user (.profile or equivalent)
    export REQUESTSCABUNDLE=/path/to/CA_to_TRUST

---

## [operations/runtime-databases]

# The runtime databases

Note

If using [Dataiku Cloud Stacks](<../installation/index.html>) installation, the runtime databases are automatically managed for you, and you do not need to follow these instructions.

These instructions do not apply to Dataiku Cloud

DSS stores most of its configuration (including projects, datasets definition, code, notebooks, …) as JSON, Python, R, … files inside the `config/` folder of [the DSS data directory](<datadir.html>).

In addition, DSS maintains a number of databases, called the “runtime databases” that store some additional information, which is mostly “non-primary” information (i.e. which can be rebuilt):

  * The history of run jobs and scenarios

  * The history and latest values of metrics and checks

  * The “state” of the datasets for the Flow’s incremental computation

  * The “human-readable” timelines of things that happened in projects

  * The list of starred and watched objects

  * The contents of discussions

  * The user-entered metadata on external tables (in the data catalog)




By default, the runtime databases are hosted internally by DSS, using an embedded database engine (called H2). You can also move the runtime databases to an external PostgreSQL server. Moving the runtime databases to an external PostgreSQL server improves resilience, scalability and backup capabilities.

## Managing internally-hosted runtime databases

When the runtime databases are hosted internally by DSS, no maintenance is generally required.

### Handling database failures

Please refer to the [dedicated error page](<../troubleshooting/errors/ERR_MISC_EIDB.html>)

### Cleanup

Warning

Do not attempt to use the “Clean Internal Databases” macro when using runtime databases that are hosted internally by DSS

## Externally hosting runtime databases

### Why use external hosting?

Externally hosting runtime databases has several advantages, especially for bigger production DSS instances:

  * The internal H2 engine doesn’t scale and perform as well as an external PostgreSQL server

  * The external PostgreSQL server is more resilient to various failures than the internal H2 engine

  * It’s easier to back up a PostgreSQL server without any downtime




### When to switch

  * Generally speaking, it’s preferable to use externally-hosted runtime databases

  * All Dataiku Cloud Stacks setups already use externally-hosted runtime databases

  * If possible, use externally-hosted runtime databases from the start

  * You should switch usually at the direction of Dataiku Support or a Dataiku Field Engineer. Typically, when databases in the “databases/” folder exceed 1-2 GB.




### Prerequisites and warnings

You need to have a PostgreSQL >= 9.5 server, with write access on a schema (including ability to create tables). There are no known issues with more recent PostgreSQL versions.

You can host the databases for multiple DSS instances in a single PostgreSQL server, including in a single schema, but you need to make sure to set up a table prefix (see below).

Warning

  * You need to make sure that your PostgreSQL server will stay up. Downtime of the PostgreSQL server will completely prevent DSS operation, and may leave some jobs or scenarios in a broken state until DSS is restarted.

  * If you restart the PostgreSQL server, you **must** immediately restart DSS too.




### PostgreSQL setup prerequisites and recommendations

We strongly recommend hosting the PostgreSQL server on the same machine as the DSS server. The databases require very low resources and can live alongside DSS without issue. Having both on the same machine ensure that they “restart together” (see the above warning) and also simplifies consistent backup (see the Backups section).

We advise against using cloud-managed databases such as AWS RDS, as they tend to go down from time to time (see the above warning).

We advise against using proxies such as PGBouncer.

You should configure the `max_connections` setting of your PostgreSQL server to at least 500. High `max_connections` have very low cost on PostgreSQL and there is no significant drawback to high `max_connections`. Too low `max_connections` can fully prevent DSS from working. There is no direct correlation between “instance size”, “what jobs do” and required connection count. 500 is sufficient for almost all instances.

### Setup

  * Stop DSS

  * Edit `config/general-settings.json` and locate the `"internalDatabase"` key at top-level

  * Fill it out as follows:



    
    
    "internalDatabase": {
        "connection": {
            "params": {
                "port": 15432,
                "host": "HOST_OF_YOUR_POSTGRESQL_DATABASE",
                "user": "USER_OF_YOUR_POSTGRESQL_DATABASE",
                "password": "PASSWORD_OF_YOUR_POSTGRESQL_DATABASE",
                "db": "DB_OF_YOUR_POSTGRESQL_DATABASE"
            },
            "type": "PostgreSQL"
        },
    
        "tableNamePrefix" : "optional prefix to prepend to all table names. Don't put this key if you don't want to use this. Should be used if you plan to have multiple DSS pointing to this database/schema",
        "schema" : "Name of the PostgreSQL schema in which DSS will create its tables",
    
        "externalConnectionsMaxIdleTimeMS": 600000,
        "externalConnectionsValidationIntervalMS": 180000,
        "maxPooledExternalConnections": 50,
        "builtinConnectionsMaxIdleTimeMS": 1800000,
        "builtinConnectionsValidationIntervalMS": 600000,
        "maxPooledBuiltinConnectionsPerDatabase": 50
    }
    

  * Save the file

  * Run the following command to copy the current content of your runtime databases to the PostgreSQL server:



    
    
    ./bin/dssadmin copy-databases-to-external
    

  * Start DSS




Your DSS is now using externally-hosted runtime databases.

### Backups

You need to make sure to properly backup your PostgreSQL database using the regular PostgreSQL backup procedures. Each time you make a DSS backup, you should also ensure that you have a matching PostgreSQL backup.

The DSS backup and the PostgreSQL backup don’t need to be perfectly synchronous, small discrepancies in backup times will not cause significant harm in case of a restore.

### Migrations

When upgrading DSS, DSS will automatically upgrade the schema of the externally-hosted databases. Make sure to backup the databases before starting the DSS upgrade procedure in order to be able to roll back the DSS upgrade.

### Advanced settings

The “connection” part of the “internalDatabase” in `config/general-settings.json` is similar to the structure of a PostgreSQL connection in `config/connections.json`. You can thus use advanced capabilities like JDBC-URL-based connection, advanced properties.

We recommend that you setup a PostgreSQL connection using the DSS UI, and then copy the relevant connection block from `config/connections.json` to `config/general-settings.json`.

We highly discourage changing any of the “externalConnections” / “maxPooled…” settings without guidance from Dataiku Support.

### Using an encrypted password

In order to avoid writing a password in cleartext in the configuration file, encrypt it first using:
    
    
    ./bin/dssadmin encrypt-password YOUR-PASSWORD
    

Use the encrypted password string (starting with `e:AES:`) in the “password” field.