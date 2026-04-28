# Dataiku Docs — release-notes

## [release_notes/old/10.0]

# DSS 10.0 Release notes

## Migration notes

### Migration paths to DSS 10.0

>   * From DSS 9.0: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 8.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [8.0 -> 9.0](<9.0.html>)
> 
>   * From DSS 7.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [7.0 -> 8.0](<8.0.html>) and [8.0 -> 9.0](<9.0.html>)
> 
>   * From DSS 6.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [6.0 -> 7.0](<7.0.html>), [7.0 -> 8.0](<8.0.html>), [8.0 -> 9.0](<9.0.html>)
> 
>   * From DSS 5.1: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>), [7.0 -> 8.0](<8.0.html>), [8.0 -> 9.0](<9.0.html>)
> 
>   * From DSS 5.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>), [7.0 -> 8.0](<8.0.html>), [8.0 -> 9.0](<9.0.html>)
> 
>   * From DSS 4.3: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>), [7.0 -> 8.0](<8.0.html>), [8.0 -> 9.0](<9.0.html>)
> 
>   * From DSS 4.2: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>), [7.0 -> 8.0](<8.0.html>), [8.0 -> 9.0](<9.0.html>)
> 
>   * From DSS 4.1: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.1 -> 4.2](<4.2.html>), [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>), [7.0 -> 8.0](<8.0.html>), [8.0 -> 9.0](<9.0.html>)
> 
>   * From DSS 4.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<4.1.html>), [4.1 -> 4.2](<4.2.html>), [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>), [7.0 -> 8.0](<8.0.html>), [8.0 -> 9.0](<9.0.html>)
> 
>   * Migration from DSS 3.1 and below is not supported. You must first upgrade to 5.0. See [DSS 5.0 Release notes](<5.0.html>)
> 
> 


### How to upgrade

It is strongly recommended that you perform a full backup of your DSS data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>).

Pay attention to the warnings described in Limitations and warnings.

### Limitations and warnings

Automatic migration from previous versions (see above) is supported. Please pay attention to the following removal and deprecation notices.

### Support removal

Some features that were previously announced are deprecated are now removed or unsupported.

  * Support for Ubuntu 16.04 LTS is now removed

  * Support for Debian 9 is now removed

  * Support for SuSE 12 SP2, SP3 and SP4 is now removed. SuSE 12 SP5 remains supported

  * Support for AmazonLinux 1 is now removed

  * Support for Hortonworks HDP 2 is now removed

  * Support for Cloudera CDH 5 is now removed

  * Support for HDInsight is now removed




### Deprecation notice

DSS 10.0 deprecates support for some features and versions. Support for these will be removed in a later release.

  * The “Build missing datasets” build mode is deprecated and will be removed in a future release. This mode only worked in very specific cases and was never fully operational.

  * Support for MapR is deprecated and will be removed in a future release.

  * Support for training Machine Learning models with H2O Sparkling Water is deprecated and will be removed in a future release.

  * As a reminder from DSS 9.0, support for EMR below 5.30 is deprecated and will be removed in a future release.

  * As a reminder from DSS 9.0, support for Elasticsearch 1.x and 2.x is deprecated and will be removed in a future release.

  * As a reminder from DSS 7.0, support for “Hive CLI” execution modes for Hive is deprecated and will be removed in a future release. We recommend that you switch to HiveServer2. Please note that “Hive CLI” execution modes are already incompatible with User Isolation Framework.

  * As a reminder from DSS 7.0, Support for Microsoft HDInsight is now deprecated and will be removed in a future release. We recommend that users plan a migration toward a Kubernetes-based infrastructure.




## Version 10.0.9 - September 9th, 2022

DSS 10.0.9 is a security release. All users are strongly encouraged to update to this release.

### Security

  * Fixed [Remote code execution in API designer](<../../security/advisories/dsa-2022-011.html>)

  * Fixed [Session credential disclosure](<../../security/advisories/dsa-2022-012.html>)

  * Fixed [Credentials disclosure through path traversal](<../../security/advisories/dsa-2022-016.html>)

  * Fixed [Insufficient access control to project variables](<../../security/advisories/dsa-2022-013.html>)

  * Fixed [Insufficient access control to projects list and information](<../../security/advisories/dsa-2022-014.html>)

  * Fixed [Insufficient access control in troubleshooting tools](<../../security/advisories/dsa-2022-015.html>)

  * Tightened potential path traversal issues that did not lead to a security vulnerability




## Version 10.0.8 - August 24th, 2022

DSS 10.0.8 is a security and bugfix release. All users are strongly encouraged to update to this release.

### Recipes

  * SQL: Fixed execution of multiple SQL recipes at the same time on Redshift when using the Redshift driver (11.0.1)

  * Prepare: Fixed possible internal error with Spark engine (11.0.0)

  * Plugin recipes: Fixed dynamic select in plugin recipes for OBJECT_LIST parameter type (11.0.0)




### Cloud Stacks

  * Fixed upgrade issue for Govern node

  * Fixed issue when using automatically updated license mode (11.0.0)




### Elastic AI

  * Fixed failure creating AKS clusters due to third-party API change




### APIs

  * Fixed “GET user” API with logins containing ‘@’ or ‘.’ (11.0.0)




### Security

  * Fixed [access control issue for managed cluster logs and configuration](<../../security/advisories/dsa-2022-005.html>)

  * Fixed [multiple access control issues leading to low-impact information leaks](<../../security/advisories/dsa-2022-006.html>)

  * Fixed [multiple access control issues leading to low-impact service disruptions](<../../security/advisories/dsa-2022-007.html>)

  * Fixed [stored XSS in dataset settings](<../../security/advisories/dsa-2022-008.html>)

  * Fixed [stored XSS in machine learning results](<../../security/advisories/dsa-2022-009.html>)

  * Fixed [missing access control for export to dataset](<../../security/advisories/dsa-2022-010.html>)




### Misc

  * Fixed possible failure using empty files-based datasets and folders (11.0.0)

  * Fixed DSS upgrade if previous install directory has been removed (11.0.0)




## Version 10.0.7 - May 30th, 2022

DSS 10.0.7 is a security and bugfix release. All users are strongly encouraged to update to this release.

### Cloud Stacks

  * AWS: Fixed per instance custom certificates

  * Azure: Fixed incompatibility when deploying new DSS with previous Fleet Manager version when the SSL certificate key storage mode is SECRETS_MANAGER

  * Fixed issue saving instance settings when root volume type was not properly set




### Misc

  * Fixed issue in the UI when deleting personal API keys from user profile page




## Version 10.0.6 - May 20th, 2022

DSS 10.0.6 is a very significant new release with both new features, performance enhancements and bugfixes.

### Machine Learning

  * **New feature** : Added no-code image classification

  * **New feature** : Added automated data augmentation for object detection and image classification

  * Object detection and image classification: improved display of the loss graph

  * Added “Max delta step” as configurable parameter for XGBoost

  * Added “Column subsample ratio for splits / levels” as configurable parameter for XGBoost

  * LightGBM: Switched to using gain for variable importance

  * Improved the way model views are chosen and activated

  * Fixed explanation text for lift charts

  * Fixed failure scoring with models trained with older DSS, with impact coding and unseen categories

  * Fixed ability to resume a session after some of its models have been deleted

  * Fixed ugly names for hyperparameters for LightGBM in the training details screens

  * Fixed small UI issues for clustering

  * Fixed computation of feature distributions on fully-empty numerical features

  * Added missing algorithm details for partitioned models

  * Fixed a race condition in training of partitioned models

  * Fixed handling of project libraries for custom algorithms

  * Fixed number of retrained layers for Object Detection and Image Classification

  * Object Detection and Image Classification: added ability to select GPU for training recipe

  * Object Detection and Image Classification: fixed display of images feed when using a foreign managed folder

  * Fixed case where both retraining and using a model in the same job led to the old model to be reused




### Elastic AI

  * **New feature** : Brand new monitoring UI for managed clusters, allowing you to view all activity on your managed clusters

  * **New feature** : Cleanup actions to remove all failed and finished items on managed clusters

  * **New feature** : EKS: Added ability to use spot instances

  * **New feature** : EKS: Added ability to automatically install Kubernetes Metric Server

  * EKS: Added ability to tag nodes

  * EKS: Added ability to assume a role to create the cluster

  * Fixed failure to run containerized execution jobs when they need more than 30 minutes to start

  * Added ability for streaming Python recipes to have extraLabels and extraAnnotations

  * Fixed cases where SparkSQL recipe validation could fail and keep failing

  * AKS: fixed support for taints

  * Fixed settings warning staying displayed after switching back to local backend environment for webapps

  * Fixed GPU images on GKE

  * Fixed build of GPU images following NVIDIA repository changes

  * Fixed ability to use custom ingress classes




### Datasets & Managed Folders

  * **New feature** : When uploading multiple files at once, you can now choose between creating a single dataset or one dataset per file

  * **New feature** : Redshift: added ability to read external tables (also known as “Redshift Spectrum”)

  * DynamoDB: Vastly improved write performance(up to 30 times faster)

  * Teradata: Fixed reading of dates prior to 1582

  * Snowflake: Added caching for OAuth tokens in the case of using “Snowflake OAuth” to reduce number of calls to authorization server

  * Managed folders: Fixed actions from the folder view

  * Managed folders: Fixed “move” and “rename” actions on Azure Blob Storage

  * Connection explorer: fixed useless listing of tables when previewing data

  * Fixed numerical filter losing its settings on explore page




### Statistics

  * **New feature** : Added native support for time series in Visual Statistics (stationarity tests, trend tests, ACF, PACF, autocorrelation statistic)

  * Added loading plot support for PCA

  * Improved axis ranges for scatter plots




### Flow

  * Added direct ability to move recipes between flow zones from the contextual menu, and in API

  * Fixed issues with “copy data” when copying filesystem datasets and folders




### Hadoop

  * **New feature** : Added support for Cloudera CDP Private Cloud Base 7.1.7.p1000

  * Cloudera CDP: Fixed sort recipe order by clause in Hive engine on CDP.

  * Cloudera CDP: Fixed join recipe when a date is involved in joining conditions

  * Changed Hive queries to be explicit on null / empty behavior when ordering




### Charts & Dashboards

  * Added “Sampled” badge on filters tile to show that you are only seeing partial values

  * Fixed display error when a date filter has no more available values

  * Fixed issue with dimensions “graying out” when dragging/dropping them in some circumstances




### Formula

  * Fixed silent error in SQL translation of some formulas

  * Fixed mishandling of the PI function




### MLOps

  * **New feature** : Added ability to compute data drift in standalone evaluation recipes

  * Added ability to use plugins and project libraries for MLflow models

  * Added ability to use a saved model as output of a Python recipe, in order to facilitate MLflow models creation

  * Various UI and API enhancements for MLflow models import

  * Added ability to publish metrics from a model evaluation to the dashboard

  * Fixed “compute_schema_updates” on evaluation recipes with model evaluation stores

  * Fixed ability to use variables expansion for partition dependencies in evaluation recipe

  * Fixed possible failure computing metrics for MLflow models when there are not enough different values in test set




### Collaboration

  * Fixed copy of attachments when copying Wiki articles

  * Fixed issue with displaying tag categories on home page




### Visual recipes

  * Prepare: Fixed chained pivot steps in Prepare recipe losing output columns when run with Spark

  * Prepare: added SQL support for “extract from geo column” processor

  * Geo Join: fixed handling of variables expaansion in pre/post filters




### API Node

  * **New feature** : Added ability to authenticate API calls using JWT Bearer Token




### Scenarios

  * Fixed some issues with relocability of scenarios (ability to run in a different project key)

  * Fixed handling of content-type header on webhook reporters

  * Fixed a case where scenario could not appear as aborted when aborting it

  * Fixed ability for read-only users who have “run scenarios” permission to run directly from the scenario page




### API

  * **New feature** : Added last login and last activity (opening DSS) to users API

  * **New feature** : Added an API to get information about dataset last build

  * **New feature** : Added an API to manage personal API keys

  * Added ability for non-admins to use code envs API

  * Added ability to create Kubernetes clusters through the API




### Plugins

  * Added support of dynamic select on the plugin’s settings page

  * Fixed support for dynamic select for OBJECT_LIST type

  * Added ‘triggerParameters’ on getChoicesFromPython to reload only when subset of field are updated

  * Fixed issue setting value for STRINGS parameter

  * Added ability to use “contextual” code env for model views




### Scalability and performance

  * Strong performance enhancements (especially startup times) for jobs leveraging S3, Azure Blob and Google Cloud storage

  * Catalog: strongly improved performance for “External tables” tab

  * Machine Learning performance enhancement for categorical features with vast number of distinct values in train set

  * Added ability to export projects with extremely large .git folders

  * Fixed severe performance degradation when translating to SQL “Find/Replace” processors with vast amounts of empty entries

  * Fixed severe performance degradataion when translating to SQL a vast number of “Formula” processors

  * Fixed possible failure to delete Kubernetes jobs from aborted DSS jobs

  * Fixed performance degardation related to metrics API

  * Fixed potential hang when listing paths of a managed folder that does not respond

  * Fixed potential hang when submitting a SQL query with hundreds of thousands of lines to some databases, leading in issues parsing the resulting error message

  * Fixed potential hang with Webapps on Kubernetes

  * Fixed potential hangs with external hosting of runtime databases under very high load, notably with many active scenario triggers

  * Fixed potential hangs with external hosting of runtime databases under very highl load, when all available connections are used

  * Fixed potential hang related to users API

  * Fixed potential hang related to schema consistency check on non-responding datasets




### Administration

  * **New feature** : Added last login and last activity (opening DSS) to users screen

  * Fixed failure of “per-connection data” screen in the case where some plugins were uninstalled

  * Fixed refresh of data in “per-connection data” when clearing datasets

  * Automatically ignore empty pip / conda options




### Deployer

  * Projects: Fixed ability to save settings of infrastructures when they are managed by Fleet Manager

  * Projects: Fixed issue with setting scenario states from the deployer




### Cloud Stacks

  * Improved display of virtual network details for Azure

  * Fixed system limits that could make it impossible to log in with SSH

  * Fixed reprovisioning on instances with lots of settings, especially when using many containerized execution configurations, or SSO

  * Azure: Added support for certificates coming from Keyvault

  * Fixed issue with deploying instances with some recent licenses

  * Added an instance diagnosis ability to Fleet Manager

  * Fixed starting Kubernetes clusters on DSS nodes reprovisioned by Fleet Manager 10.0.5

  * Fixed support of zipped JDBC drivers




### Security

  * Fixed [insufficient authorization checking on exposed managed folders](<../../security/advisories/dsa-2022-002.html>)

  * Fixed [cross-site-scripting vulnerability on model reports](<../../security/advisories/dsa-2022-003.html>)

  * Fixed [code execution through server-side-template-injection](<../../security/advisories/dsa-2022-004.html>)




### Misc

  * Fixed compatibility issue with the “Reverse Geocoding” plugin

  * Fixed login issue on Safari 15.4

  * Fixed aborted jobs still appearing as running (UI-only issue)

  * Fixed logs in application-as-recipe

  * Fixed default name of notebooks created based on foreign datasets




## Version 10.0.5 - March 10th, 2022

DSS 10.0.5 is a bugfix release

### Recipes

  * Join recipe: fixed “match on nearest date” and “match on date range” options




### Misc

  * Fix an issue causing malfunction with some types of customer licenses




## Version 10.0.4 - March 7th, 2022

DSS 10.0.4 is a very significant new release with both new features, performance enhancements and bugfixes.

### Coding

  * **New feature** : Added support for Python 3.8, Python 3.9 and Python 3.10

  * **New feature** : Added support for Pandas 1.1, Pandas 1.2 and Pandas 1.3

  * **New feature** : When running a coding recipe, the “raw” output of the code can now be displayed in the logs (without Dataiku infrastructure logs)

  * Updated dependency on “requests” for better compatibility with 3rd party libraries that require newer “requests”

  * Managed folders API: added “upload_folder” function

  * Fixed continuous python activities not getting project python libraries

  * Fixed SparkSQL insertable fragments using wrong quoting char

  * API: Python: Added a Python method to clear the remote DSS previously set by set_remote_dss

  * API: Fixed a bug in get_latest_model_evaluation not providing the latest model evaluation id

  * API: Added an API method to add several items to a zone




### Explore

  * **New feature** : Automatically display whether you are seeing the complete data or a sample

  * **New feature** : Added total number of records in the dataset, when sampling is not “first records”

  * **New feature** : Added total number of records in the dataset, when sampling is “first records”, on Snowflake and BigQuery




### Charts

  * **New feature** : Automatically display whether a chart is running on sampled data or whole data

  * **Performance enhancement** : Faster charts rendering on dashboards

  * **Performance enhancement** : Reduced the number of times where chart cache needs to be rebuilt, leading to overall improved performance for charts

  * Binned scatter plot: Do not mistakenly accept geo columns as X or Y

  * Scatter plot: Fixed display of axis margins when enabling log scale

  * Fixed useless scroll bar with Firefox

  * Improved preservation of chart settings when changing the type of chart

  * Fixed failure on animated charts if a bin disappears after chart setting changes

  * Fixed thumbnail generation

  * Prevented user from saving color palettes with invalid colors




### Flow

  * **New feature** : Uploaded Datasets can now be created by directly dragging-and-dropping files on the Flow

  * **Performance enhancement** : Improved performance of panning large flows

  * **Performance enhancement** : Improved performance of hovering and selecting items in large flows

  * Improved behavior when removing partitioning on SQL datasets

  * Mark “missing data only” build mode as deprecated

  * Improved accuracy of rectangular selection (Ctrl+mouse drag)

  * Fixed usage of SQL pipelines when schema/catalog of virtualised datasets contains a variable

  * Fixed Flow disappearing with invalid characters in Flow zone name

  * Fixed external dataset appearing as “not built” if a managed dataset of the same name previously existed and was never built




### Workspaces & Dashboards

  * Slack notifications: Fixed notification text when items are shared to workspaces

  * Fixed collapse of long descriptions on workspaces

  * Prevented the full screen in dashboard from overlapping with the “close error” button




### Snowflake

  * **New feature** : Added native integration with Snowpark Python

  * **New feature** : Added in-Snowflake support for URL Splitter prepare processor (through Java UDF)

  * **New feature** : Added in-Snowflake support for Currency Conversion prepare processor (through Java UDF)

  * **New feature** : Added in-Snowflake support for Normalize measures prepare processor (through Java UDF)

  * Improved in-Snowflake support for regular expression extraction processor (through Java UDF)

  * Added support for proxy for OAuth endpoints

  * Prepare recipe: Fixed string concatenation processor with null values

  * Fixed possible issue on pivot recipe when QUOTED_IDENTIFIERS_IGNORE_CASE is set to TRUE

  * Fixed issues with Cloud-to-Snowflake synchronization with date columns containing null values




### BigQuery

  * Enabled the DSS builtin driver by default for new BigQuery connections

  * DSS builtin driver: Much faster read of large datasets

  * DSS builtin driver: Added support for reading from views




### Datasets

  * GCS: Added support for proxy

  * ElasticSearch: fixed support for authenticated proxy

  * Synapse: Added support for Parquet for fast-sync from Azure Blob Storage

  * S3: Fixed usage of connections with specific interface endpoints

  * Shapefile: Fixed format options when manually selecting Shapefile format

  * Fixed ‘Move To’ folder action being limited to a small number of items

  * Fixed “max length” display in the schema of some datasets




### Formula

  * **New feature** : switch() function for easy switch/case support (SQL pushdown supported)

  * **New feature** : uuid() function generating a UUID

  * Fixed highlighting of unknown fields in formula editor

  * Added SQL support for substring function

  * Added SQL support for now function on BigQuery and PostgreSQL




### Visual Recipes

  * **New feature** : Prepare recipe: New processor: ‘Enrich with last build time’, adding a column containing the recipe run date

  * Prepare recipe: Fixed “clear cells” option in the Analyse modal

  * Prepare recipe: Fixed a bug on DSS engine when using several consecutive pivot steps

  * Prepare recipe: fixed missing refresh when removing a value from the “Find/Replace” replacements list

  * Prepare recipe: report warnings for CRS change and Geometry info extraction processors

  * Prepare recipe: fixed small UI issues in the “merge categorical values” modal

  * Prepare recipe: Fixed plugin processors with Spark engine



  * Filter/Sampling recipe: fixed usage of variables in when sampling is disabled



  * Split recipe: Fixed changing input

  * Split recipe: fixed failure when dropping some percentile of data



  * Stack recipe: Improved support of variables in the pre/post filters



  * Join recipe: Fixed “auto select all columns” with Spark engine

  * Join recipe: fixed join suggestions when columns use non-Latin characters

  * Join recipe: various interface improvements in join conditions modal

  * Join recipe: Made “+0000” timezone usable with DSS Engine



  * Sync recipe: added fast-path support to “files in folder” dataset




### Machine Learning

  * **New feature** Added sentence embedding as a text feature handling option

  * **New feature** : Added a diagnostic that detects if the model predicts the same class more than 99% of the time

  * **Performance enhancement** : Improved performance of opening clustering models

  * Multiple UX enhancements in “Explore neighborhood” (aka counterfactuals)

  * Added a warning when “drop rows when empty” would lead to dropping large number of rows



  * Fixed interactive scoring with date features and ensemble models

  * Fixed Keras models deletion on UIF instances

  * Fixed distributed hyperparameter search failing in case of an unexpected failure on one worker

  * Object Detection: Fixed CPU scoring on a model trained on GPU if there is no GPU available on the instance

  * Fixed creation of scoring recipes with existing datasets as output

  * Fixed possible error while viewing a clustering model

  * Fixed possible error when deploying models trained with old DSS versions

  * Fixed model creation modal images on Firefox

  * Fixed new diagnostics not being displayed in the settings of old analyses

  * Fixed display of number of training rows when the model is trained on the full dataset

  * Fixed possible errors showing a model when traing has been aborted by an unexpected event

  * Fixed “calibration loss” not displayed for multiclass in the “Metrics and assertations” page

  * Fixed unexpected reset of the partitions filtering widget when selecting a partition to train a model

  * Fixed multiclass prediction summary page not showing metric used for training when it was not mAUC

  * Removed irrelevant random state selection from time-based K-Fold (always deterministic)

  * Fixed interactive scoring when training in containers with “skip expensive reports” option

  * Switched to using train set instead of test set to compute features distribution for model explanations

  * Fixed display of cost Matrix Gain in decision chart when some metrics are deselected




### MLOps

  * **New feature** : MLflow import: Added support for containerized execution for evaluation and scoring

  * **New feature** : MLflow import: Added support for input data drift computation

  * MLflow import: Added ability to read features from MLflow model signature

  * MLflow import: Added ability to load MLflow models from DSS managed folders

  * MLflow import: Added support of Evaluation diagnostic

  * MLflow import: Added support for sampling of input dataset for evaluation recipe

  * MLflow import: Added ability to directly input the features list in the API

  * MLflow import: easier to use API for evaluate

  * MLflow import: Fixed the case where the MLFLow model returns NaN for some predictions

  * MLflow import: Improved handling of errors in interactive scoring

  * MLflow import: Fixed possible failure in computing counterfactuals

  * MLflow import: Prevented invalid version ids



  * Evaluation recipe: Added support for sampling of input dataset

  * Evaluation recipe: fixed preselection of test dataset when using a shared dataset



  * Model comparison: Fixed the reduce button of “configure” modal

  * Model comparison: Made model coming from analysis available for drift computation



  * Drift: Improved progress bar when computing drift analysis

  * Drift: Added a warning on new modalities in univariate drift analysis



  * **Performance enhancement** : Model Evaluation Store: Better performance for model evaluation stores UI

  * Model Evaluation Store: made summary sections collapsable

  * Model Evaluation Store: Added tags on the side panel

  * Model Evaluation Store: Allow exposing Model Evaluation Stores between projects

  * Model Evaluation Store: Disabled unwanted scientific notification in some result screens

  * Model Evaluation Store: Removed evaluations that are still being computed from charts



  * Standalone Evaluation recipe: Fixed computation of probabilistic evaluation when target has NaN value

  * Standalone Evaluation Recipe: Add the ability to create it using the public API

  * Standalone Evaluation Recipe: Added evaluation diagnostics when classes are missing

  * Standalone Evaluation Recipe: Fixed wrong “training data” information in result screens



  * Made Model Comparator and Model Evaluation Store searchable in the global finder




### Notebooks

  * **New feature** : SQL notebooks: added ability to execute only the selected part of the query

  * SQL notebooks: Added display of JDBC warnings

  * Jupyter: Install Jupyter Widgets extension by default

  * Jupyter: Predefined notebooks on datasets are now Python 3 compatible

  * Jupyter: Fixed some issues with autocompletion on Jupyter notebooks




### Scenarios

  * Fixed the “define project variables” scenario step not escaping value properly when logging

  * Added missing check when starting a scenario using a “Run scenario” step that could lead to running the same scenario twice in parallel




### Automation

  * Fixed connection remapping failure if a plugin is missing on the automation node

  * Added Wiki attachments in bundles




### Geospatial

  * **New feature** : Added ability to export Geospatial datasets as Shapefiles

  * GeoJSON import: Added support for importing GeoJSON files with missing geometries

  * GeoJSON export: Added stricter handling of types (numericals will now be numericals in the generated GEoSJON)

  * GeoJoin: Fixed issue when joining with the same dataset and using different filters




### Statistics

  * Fixed support of cgroups for statistics computation

  * Fixed broken chart auto-resizing when resizing browser window

  * Fixed possible out of memory with a very specific series of numbers

  * Improved error handling if a failure occurs while computing automated card suggestions




### Managed folders

  * **New feature** : Added ability to have “Filesystem” managed folders on NFS or CIFS, or other locations where managing ACLs is not supported




### Webapps

  * Improved user experience on the “rename webapp” modal

  * Fixed reverting a web app previously exposed on K8S to local run




### Collaboration

  * **Performance enhancement** : Improved performance of home page for fetching projects list

  * **Performance enhancement** : Strongly reduced the cost of notifications (“red bell”)

  * Fixed discussions when their underlying project is watched by deactivated users

  * Fixed setting to disable login/logout notifications

  * Fixed error when duplicating a project from the project folder list

  * Allow explorers to edit wiki




### Governance

  * Multiple UX improvements

  * Fixed sync of object detection models to Govern

  * Fixed various issues with advanced permission criteria

  * Fixed non-editable fields that still appeared as editable

  * Fixed issue with displaying related artifacts in the “Graph” view

  * Fixed various robustness issues with DSS-govern project synchronization in the presence of errors

  * Disabled sync of partitioned models, which are not available in Govern

  * Fixed the “Synchronize DSS Items” button in DSS admin settings not displayed without refreshing the page

  * Fixed the “Test” button of Govern integration not taking the value without saving

  * Added an option to not synchronize in Govern a specific model evaluation in the model evaluation store




### Cloud stacks

  * **New feature** : Added centralized license reporting in Fleet Manager, to get a complete view on license usage across instances

  * **New feature** : Added a “sublicense” mechanism which allows limiting the number of users that can be assigned to an instance (to a subset of your total number of licensed seats)

  * Fixed issues with user names containing @ or too long user names

  * When using self-signed certificates, generate a Subject Alternative Name to improve browser compatibility

  * Automatically mark cookies as secure when deploying DSS over HTTPS

  * Fixed login screen on Fleet Manager appearing before Fleet Manager itself is ready

  * Fixed license check when reprovisioning an instance with a Discover or Business license

  * Added log rotation for agent logs



  * Azure: Fixed issues logging with SSH after 30 days

  * Azure: fixed possible issues with AKS clusters when using user-assigned-managed-identities

  * Azure: added ability to restrict the IPs allowed to connect to Fleet Manager

  * Azure: added ability to use an existing VNET in a different RG in the ARM template

  * Azure: Added ability to specify a resource group for data disks when using blueprints

  * Azure: added ability to choose Internet traffic mode

  * Azure: Improved error message when SSL key stored in Azure KeyVault is not properly set

  * Azure: Fixed creation of initial password with special characters



  * AWS: Added support for gp3 volumes




### Elastic AI and Spark

  * Fixed possible leak of pods when a job is aborted. Pods are now automatically cleaned up, both for containerized execution and Spark execution, when the job finishes, even after an abort

  * Fixed various issues which could cause jobs or notebooks failures when the Kubernetes cluster is overloaded or temporarily unable to reespond

  * When running Spark on Kubernetes jobs, the logs and pods status of Spark executors is now automatically collected and can be viewed in the UI to facilitate troubleshooting

  * When running Spark jobs, some common configuration issues are now more clearly highlighted to facilitate troubleshooting

  * Added ability to automatically Python 3.8, 3.9 and 3.10 in container images

  * **New feature** : EKS clusters: Added support for automatically installing the GPU driver

  * EKS clusters: upgrade to a newer eksctl for better compatibility

  * EKS clusters: Added support for Python 3 for the creation environment

  * Improved support for multiple sets of Azure credentials in a single Spark job

  * Fixed excessive refresh of GCS tokens when using GCS connections with OAuth2 credentials in Spark jobs

  * AKS clusters: fixed issue with “inherit DSS host settings” when deploying the cluster in another resource group

  * Save settings before “push base images” in order to use latest settings

  * Added code env resources support for spark executors

  * Fixed leak of pods when aborting a training or scoring recipe on Kubernetes




### Hadoop

  * Fixed hive validation on CDP 7.1.7 when using “ADD JAR” commands (or other DDL)

  * Fixed search box for Hive database on new Hive dataset screen in Chrome




### Streaming

  * Fixed “save and refresh sample” button on streaming endpoints




### Plugins development

  * Fixed error message not displaying when more than 2 columns are selected in a COLUMNS fields of a plugin recipe

  * Fixed wrongful error message when recreating a plugin that was just deleted

  * Added support for dynamic select in auto config form for custom fields

  * Added ability to get the expanded version of a preset in Python custom UI setup code




### Administration

  * **New feature** : Authorization matrix: added ability to export the authorization matrix to CSV, Excel, dataset, …

  * **New feature** : Added ability to restrict allowed sender domains in SMTP and Amazon SES channels

  * Authorization matrix: Improved UI

  * Authorization matrix: Improved scalability with very large instances

  * Automatically cleanup some very large files in the “jobs” folder to save space

  * Various logs in the “jobs” folder are now automatically compressed to save space

  * When deleting a project, automatically propose to delete job and scenario logs

  * Added encryption of proxy password

  * Fixed issue with projects permission upgrades (for workspaces)




### Other performance & stability enhancements

  * **Performance enhancement** : Strongly reduced cost and impact on other users of starting jobs on highly loaded instances

  * **Performance enhancement** : Strongly reduced cost and impact on other users of changing permissions on large projects

  * **Performance enhancement** : Reduced cost and impact on other users of using scenario reporters with large scenario runs history

  * **Performance enhancement** : Reduced cost and impact on other users of activating saved model versions on partitioned models with large number of partitions

  * **Performance enhancement** : Reduced disruption caused by initial data catalog indexing in the first minutes after DSS startup

  * **Performance enhancement** : Improved scenario UI performance for projects with large number of datasets

  * **Performance enhancement** : Overall performance enhancements for projects with large number of datasets

  * **Stability** : Fixed potential instance hang when dealing with lots of webapps on Kubernetes

  * **Stability** : Fixed potential instance hang when using managed folders Python API




### macOS Launcher

  * Disabled “Check for updates” while DSS is starting up

  * Do not display “Git is not installed” popup anymore

  * Added display of DSS and launcher versions




### Misc

  * Added safety on corrupted params.json project file blocking the whole instance

  * Fixed managed folders not being deleting when used by an App as recipes

  * Fixed DSS stream engine when sorting double columns that contain NaN values




## Version 10.0.3 - January 28th, 2022

DSS 10.0.3 is a bugfix and security release. All users are strongly encouraged to update to this release.

Items marked with (9.0.7) are also present in DSS 9.0.7

### Recipes

  * Prepare recipe: Fixed formula preview (9.0.7)

  * Code recipes: Fixed access to Flow variables (9.0.7)




### Flow

  * Fixed flow graph disappearing from job page at each refresh for large flows (9.0.7)




### Projects

  * Fixed “Code env selection” settings resetting to default when the tab is open. (9.0.7)




### Cloud Stacks

  * Fixed scheduled snapshots not taking changes of snapshot settings into account (9.0.7)




### Performance

  * Fixed instance lockup when copying very large managed folders for Python function endpoints




### Miscellaneous

  * Fixed invalid actions displayed on the home page of the automation node when there are no projects (9.0.7)




### Security

  * Cloud Stacks deployments only: fixed [“Pwnkit” vulnerability](<../../security/advisories/dsa-2022-001.html>) (9.0.7)




## Version 10.0.2 - December 13th, 2021

DSS 10.0.2 is a significant new release with both new features, performance enhancements and bugfixes.

Items marked with (9.0.6) are also present in DSS 9.0.6

### Datasets

  * **New feature** Added per user login for Google Cloud Storage (OAuth) (9.0.6)

  * **New feature** Added per user login for BigQuery (OAuth) (9.0.6)

  * When creating a dataset from file names with Unicode characters (including CJK), an equivalent ASCII dataset name is automatically generated (9.0.6)

  * Fixed possible UI overlapping between different custom exporters (9.0.6)

  * Fixed creation of managed SQL datasets from “New Dataset > Internal > Managed”




### Machine Learning

  * Fixed creation of cluster recipes on foreign datasets (9.0.6)

  * Fixed creation of scoring recipes from MLflow models

  * Fixed import of MLflow models on UIF-enabled DSS




### Hadoop, Spark, Elastic AI

  * **New feature** : Added support for CDP Private Cloud Base 7.1.7 (9.0.6)

  * Added the ability to import EMR-created tables from Glue as S3 datasets when not using EMR with DSS (9.0.6)

  * Fixed failure of Spark recipes when project variables contain Unicodes characters (including CJK) (9.0.6)

  * Fixed SparkSQL recipe validation failure when the code contains Unicode characters (9.0.6)

  * Fixed issue with Kubernetes namespace policies (9.0.6)

  * Fixed direct write to Snowflake from Spark with OAuth authentication and variables (9.0.6)




### Dashsboards

  * Fixed truncation of large dashboard exports (9.0.6)

  * Fixed opening of insights when clicking their title




### Cloud Stacks

  * **New feature** : Azure: Added ability to create a subnet that does not cover the entire vnet (9.0.6)

  * **New feature** : Azure: Support for static private IP for Fleet Manager (9.0.6)

  * **New feature** : Azure: Support for static private IP for DSS instances (9.0.6)

  * **New feature** : Azure: Added ability to create resources in a specific resource group instead of always using the vnet resource group (9.0.6)

  * **New feature** : Azure: Added ability to fully control the name of created resources (machines, disks, network interface, …) (9.0.6)

  * **New feature** : AWS: Added support for Hong Kong, Osaka, Milan and Bahrain regions (9.0.6)




### Flow

  * Fixed Flow filtering with flow zones and exposed objects (9.0.6)




### Recipes

  * Prepare recipe: “Simplify column names” now automatically translates Unicode characters (including CJK) to equivalent ASCII (9.0.6)

  * Prepare recipe: Snowflake: Fixed date parsing with timezone being sensitive to the JDBC session timezone (9.0.6)

  * Code recipes: When creating the recipe with input or output managed folder with Unicode names (including CJK), generate an equivalent ASCII variable name for the starter code (9.0.6)

  * Join recipe: Improved input preview

  * Join recipe: Better warnin at recipe validation when there are unusable characters in column names (9.0.6)

  * SQL recipe: Fixed usage of explicit DKU_END_STATEMENT (9.0.6)

  * Fixed possible failure with Snowflake/Synapse/BigQuery auto-fast-paths with date columns (9.0.6)

  * Fixed failure with Snowflake auto-fast-path and incomplete configuration (9.0.6)




### API

  * Added ability to modify containerization settings of code envs (9.0.6)

  * Fixed creation of prepare recipe with existing outputs from the Python public API (9.0.6)

  * Fixed the direction argument of the SelectQuery.order_by method (9.0.6)

  * Fixed invalid removal of default Flow zone through the API (9.0.6)




### Notebooks and webapps

  * Fixed changing name of a SQL notebooks when created from the side panel (9.0.6)

  * Fixed possible issue when saving standard webapps (9.0.6)

  * Fixed write to Snowflake/Synapse/BigQuery auto-fast-path from Jupyter notebooks and webapps (9.0.6)

  * Fixed failure of webapps when the project variables contain Unicodes characters (including CJK) (9.0.6)




### Performance and scalability

  * Improved performance of flow zones listing (9.0.6)

  * Improved performance on home page with large number of project folders (9.0.6)

  * Fixed leak of Python processes from custom filesystem providers such as Sharepoint (9.0.6)

  * Fixed memory leak in Cloud Stacks for Azure (9.0.6)

  * Fixed failure on dashboards for datasets with large number of charts (9.0.6)

  * Added pagination on users list and UIF rules screens (9.0.6)

  * Improved CPU consumption of eventserver reporting (9.0.6)




### Security

  * Fixed [access control issue on downloading project exports](<../../security/advisories/dsa-2021-003.html>) (9.0.6)

  * Fixed [access control issue with changing datasets connections](<../../security/advisories/dsa-2021-004.html>) (9.0.6)

  * Fixed [access control issue on dashboards listing](<../../security/advisories/dsa-2021-005.html>) (9.0.6)

  * Fixed [access control issue on saving project permissions](<../../security/advisories/dsa-2021-006.html>) (9.0.6)




### Misc

  * Dataiku Applications: Added an option to hide the “Switch to project view” button (9.0.6)

  * Added ability for non-admins to create plugin code envs if they have plugin development rights (9.0.6)

  * Fixed bug when duplicating a plugin component




## Version 10.0.1 - December 1st, 2021

Internal release

## Version 10.0.0 - November 15th, 2021

_This release is dedicated to the memory of our dear colleague Mark Treveil_.

DSS 10.0.0 is a major upgrade to DSS with major new features.

### New features

#### MLOps: Models Comparison and Drift Analysis

[Model evaluations](<../../mlops/model-evaluations/index.html>) now allow you to capture the performance and behavior of a model after it has been trained, in order to analyze the evolution of its behavior in time. This enables [Drift analysis](<../../mlops/drift-analysis/index.html>).

[Visual model comparisons](<../../mlops/model-comparisons/index.html>) allow you to quickly compare models between them or different versions of models. They can be used both during the Machine Learning design phase or to compare behaviors and performance over time.

For more details, please see [MLOps](<../../mlops/index.html>)

#### MLOps: Centralized Models registry

Part of the new [Govern Node](<../../governance/index.html>), the centralized models registry provides a centralized way to see all models (whether developed in Dataiku or externally) in one place, versioned and with performance metrics and project summaries for leaders and project managers. This includes [Drift analysis metrics](<../../mlops/drift-analysis/index.html>)

#### MLOps: Models deployment signoff workflows

Part of the new [Govern Node](<../../governance/index.html>), you can now have mandatory sign-off and approval of models before they can be deployed in production. Models signoff can include multiple and customizable reviewers and approvers.

#### MLOps: MLflow Models import

DSS can now import models from the MLflow Models framework. MLFLow Models imported into DSS benefit from all the capabilities of DSS-trained models, including:

  * Scoring datasets using a [scoring recipe](<../../machine-learning/supervised/explanations.html#explanations-scoring-recipe-label>)

  * Deploying the model for real-time scoring, using the [API node](<../../apinode/index.html>)

  * Managing multiple versions of the models

  * Evaluating the performance of the model on a labeled dataset, including all results screens

  * Comparing multiple models or multiple versions of the model, using [Model Comparisons](<../../mlops/model-comparisons/index.html>)

  * Analyzing performance and evaluating models [on other datasets](<../../mlops/model-evaluations/index.html>)

  * [Analyzing drift](<../../mlops/drift-analysis/index.html>) on the MLflow model

  * Interactive scoring, including counterfactuals and actionable recourse

  * [Governing the MLflow model using the Govern Node](<../../governance/index.html>)




For more details, please see [MLflow Models](<../../mlops/mlflow-models/index.html>)

#### Governance: Projects governance, risk & value assessments

Part of the new [Govern Node](<../../governance/index.html>), the centralized projects governance framework leaders and project managers to keep an eye of all of the AI initiatives lifecycle with clear steps and gates in order to keep proper oversight of your business initiatives.

Risk and value assessment matrices provide a standardized framework to compare initiatives for investment and determine the appropriate oversight level.

For more details, please see [AI Governance](<../../governance/index.html>)

#### Data consumers: Workspaces, a new home for data consumers

Outputs of complex data projects are often scattered across multiple projects and locations, making it challenging for business stakeholders and data consumers to quickly gain access to the needed data.

Workspaces provide dedicated, secure landing pages where data consumers can easily browse Dataiku dashboards, webapps, datasets, applications, wikis, etc. to get direct access to the most relevant insight or to take direct action using applications and webapps.

For more details, please see [Workspaces](<../../workspaces/index.html>)

#### Data consumers: cross-chart filters on dashboards

You can now add cross-charts filters on dashboards. The filter can affect all charts on a slide.

For more details, please see [Dashboard concepts](<../../dashboards/concepts.html>)

#### Geospatial analytics: Geo-join recipe

The new geo-join recipe allow you to visually match and enrich geospatial datasets.

For more details, please see [Geo join: joining datasets based on geospatial features](<../../other_recipes/geojoin.html>)

#### Geospatial analytics: Density chart

The Geo heatmap chart provides a “density”-based analytics in order to quickly visualize the most important locations on a map.

#### Geospatial analytics: preparation tools

New tools in the prepare recipe facilitate Geospatial analytics:

  * New processor and formula function: Create an area around a geopoint

  * Formula function: Simplify a geometry (including SQL support for PostGIS and Snowflake)

  * Formula function: Get the bounding box of a geometry

  * Formula function: Compute distance between geometries

  * Formula function: Check for intersection between geometries

  * The Change CRS processor can now run in SQL (with PostGIS)




#### Machine Learning: Object detection

Object detection is now a top-level task in DSS. You can now easily leverage leading, pre-trained deep learning models for detecting objects, and fine tune them to your specific labeled datasets.

Like all models trained visually in DSS, object detection models provide detailed results screens, builtin scoring ability, versioning and governance.

For more details, please see [Computer vision](<../../machine-learning/computer-vision/index.html>)

#### Machine Learning: Counterfactuals and Actionable Recourse

Counterfactuals and Actionable Recourse analysis enhance [Interactive scoring](<../../machine-learning/supervised/interactive-scoring.html>) with insights about the behavior of the model in the vicinity of a reference example.

Counterfactuals generate various records similar to the reference example and that lead to a different predicted class.

Actionable recourse generates the records with the smallest possible perturbations compared to the reference example that lead to a specific predicted class, different from the one of the reference example. Interactive scoring is a simulator that enables any AI builder or consumer to run “what-if” analyses (i.e., qualitative sensibility analyses)

#### Machine Learning: LightGBM

The fast and powerful LightGBM algorithm joins the family of algorithms that can be trained by the DSS AutoML component

#### Machine Learning: expanded feature encodings

Several new feature encodings are now available in AutoML:

  * Enhanced impact (target) encoding

  * Rank encoding

  * Frequency encoding

  * Cyclical encodings for date/time




For more details, please see [Features handling](<../../machine-learning/features-handling/index.html>)

#### Machine Learning: Queues

While training machine learning models, you can now enqueue several trainings that will all execute without further intervention. This allows you to schedule many experiments at the end of the day, and come back the next day with all your models trained and ready to [be compared in the new Models Comparison](<../../mlops/model-comparisons/index.html>).

#### Statistics: Augmented Exploratory Data Analysis

When performing exploratory data analysis on wide or complex datasets, it can be challenging and overwhelming for users to understand which columns might be most important to their analysis, how the columns relate to each other, and to identify patterns and insights.

Within the Statistics, a new wizard interactively suggests statistical analyses that may be interesting, along with new additional advanced charting capabilities such as 3-D scatter plots and parallel coordinates plots.

### Other notable enhancements

#### Charts: Customizable axis ranges

Ranges on both the X and Y axis of charts can now be customized

#### Charts: Color assignments

It is now easier to manually control color assignments on charts in order to have consistent colors between charts.

#### Charts: numerical formatting

New numerical formatting options are available for charts (for values displayed in the chart and in the tooltips)

#### Git push and pull for libraries

In addition to the existing capability to fetch project libraries from existing Git repositories, it is now possible to push them back to their origin.

For more details, please see [Importing code from Git in project libraries](<../../collaboration/import-code-from-git.html>)

#### Code env resources

When installing some packages in code envs, such as NLTK or Spacy, you frequently need to download additional resources, such as pretrained models. Previously, each user had to download the resource in a specific folder, and sometimes tweak options of the packages in order to point to the downloaded resources.

Code env resources allow you to download resources directly to the code env folder, making them available for all users

For more details, please see [Operations (Python)](<../../code-envs/operations-python.html>)

#### Data preparation: Easy extraction with Grok

You can now leverage the “Grok” pattern extraction mechanism that allows you to easily parse logs using predefined patterns. A visual editor makes it easy to view what your expression matches and to troubleshoot it.

For more details, please see [Extract with grok](<../../preparation/processors/grok.html>)

#### Wiki: quality-of-life enhancements

It is now possible to attach images in the wiki by directly dragging and dropping it.

Adding attachments does not require saving edits first anymore.

### Other enhancements and fixes

#### Visual recipes

  * Prepare: Fixed invalid JSON in “shift+V” on a cell

  * Prepare: Fixed issue with the Nest processor on Spark

  * Grouping: Fixed UI issue with CJK characters in column names

  * Grouping: Improved discoverability of “First/Last”

  * Distinct, Pivot, Grouping: Fixed error on partitioned SQL datasets when the partition column was also used as a key




#### Machine Learning

  * Fixed possible permissions issues with UIF enabled

  * Variables importance and partial dependencies can now be exported (CSV, Excel, Tableau, dataset, …)

  * Fixed failure when copying feature handling between clustering tasks

  * Fixed score discrepancy with partitioned models in SQL mode with “redispatch”

  * Fixed UI issue with mass actions on features handling

  * Fixed clustering recipe failure when a column is fully empty

  * Fixed faulty ability to remove models while they were training

  * Fixed performance issue with distributed hyperparameters search

  * Updated the computation of individual explanations to improve their correctness




#### Snowflake

  * Preparation: URL parser can now be pushed down to Snowflake

  * Preparation: Email parser can now be pushed down to Snowflake




#### Datasets

  * Fixed issues with autodetection of Parquet on S3/Azure/GCS datasets

  * Faster datetime-based partitioning on PostgreSQL




#### Flow

  * The “Schema changes” modal will not display anymore when modifying the last dataset in the Flow. Schema changes are auto-accepted.

  * Added ability to select zone when copying a subflow

  * Added connection information on dataset right panel

  * Better error handling when using invalid values in a Time Range partitioning dependency

  * Fixed various issues with managed folders from foreign projects

  * Fixed navigation bar when using the catalog from a project




#### Charts

  * Fixed color and size on “Binned XY” chart

  * Fixed possible misalignment on date axis for column charts




#### Dashboards

  * Fullscreen mode is now preserved after a redirection to SSO login




#### API

  * Added ability to create evaluation recipes in the API




#### Administration

  * It is now possible to view all usages of a code env

  * Fixed possible hang in airgapped environments

  * Fixed browser window title in administration pages




#### Security

  * Removed plain-text credentials from the Twitter connector




#### Misc

  * Fixed wiki search when using “:” in the searched term

  * Performance enhancements for instances with large number of users

  * Fixed issue with “Test” button for containerized execution config with multiple clusters

---

## [release_notes/old/2.0]

# DSS 2.0 Relase notes

## Version 2.0.4 - August 31th, 2015

Warning

For migration from DSS 1.X, please see the DSS 2.0.0 release notes

DSS 2.0.4 contains bug fixes

### UI

Fix layout of SQL and R recipe editors

### Security

  * Flag login cookies as HTTP-only

  * Fix missing access control on export internal API

  * Fix path traversal in “logs” internal API (accessible only to admin)

  * Fix a few GET/POST mismatches

  * Add new security-related options

>     * Option to force usage of Secure cookies
> 
>     * Option to disable error stacks
> 
>     * Option to disable version strings




## Version 2.0.3 - August 20th, 2015

Warning

For migration from DSS 1.X, please see the DSS 2.0.0 release notes

DSS 2.0.3 contains both bug fixes and new features

### New Features

  * DSS can now read and perform advanced extraction on XML files. Please see [XML](<../../connecting/formats/xml.html>) for more information.

  * DSS is now compatible with MongoDB 3.0




### Bug Fixes

#### Datasets

  * It is now possible to read and write from S3 buckets without the permission to list the buckets on the account.

  * Small UI fixes




#### Recipes

  * Preparation recipe: fixed some corner cases with cross-project recipes

  * Outer join is not possible with the “DSS internal” engine and is therefore not suggested anymore

  * Fixed some issues with Oracle on visual recipes

  * Fixed mass actions in Grouping recipe

  * Several fixes with the filter editor

  * Fixed some small UI issues

  * Since Oracle identifiers are limited to 30 characters, DSS will now try to limit the size of column names it generates in visual recipes

  * Fixed a display bug in “Stack” recipe




#### Hadoop

  * Fixed Hive recipes when “TextFile” is not the default Hive storage format




#### Machine learning

  * Fixed regression with H2O models

  * Fixed an issue with computation of RMSLE measure which could break models

  * Fixed the “Keep my settings” button

  * Fixed the filters on the “Predicted data” view

  * Fixed failure of scoring recipes in some cases with date columns

  * Fixed important issue with boolean variables that could be wrongly handled, leading to invalid results

  * Fixed issue with large number of clusters (>100)

  * Fixed regression on random forest with manually-entered multiple number of trees




#### Administration

  * Fixed UI issues in scheduler

  * Fixed saving of allowed groups in connections




## Version 2.0.2 - June 23rd, 2015

Warning

For migrations from DSS 1.X, please see the DSS 2.0.0 release notes

DSS 2.0.2 contains both bug fixes and new features

### New Features

  * New “Fold multiple columns by prefix” processor. See [Reshaping](<../../preparation/reshaping.html>) for more information

  * You can now “redeploy” a training recipe and a saved model from an analysis. This allows you to change the settings of the model without having to “replug” the Flow to a new saved model.

  * The “Geo-Join” processor can now output distance as miles

  * Minor UX improvements




### Important change: MySQL column names

The behaviour of MySQL datasets has been changed. The MySQL connector will now automatically use column names specified by “AS” aliases in SQL queries.

So for example, “SELECT a AS b FROM table” will now yield a dataset with a column named “b”, while it was previously named “a”.

To revert to the old behaviour, go to the settings of the MySQL connection, and add the property: “useOldAliasMetadataBehavior” = “false”.

This change only affects versions 5.1 and above of the MySQL JDBC driver. For more information, please see: <http://dev.mysql.com/doc/connector-j/en/connector-j-installing-upgrading-5-1.html>

### Bug fixes

#### Datasets

  * Empty Zip files are now properly handled

  * Fixed an issue with multi-file JSON datasets




#### Recipes

  * Fixed some data parsing issues in the Grouping recipe

  * Fixed handling of booleans in the Grouping recipe on PostgreSQL

  * Fixed SQL recipes on custom JDBC connections




#### Hadoop

  * Improved the behavior of the Hive integration with Sentry. Authorizing <file:///> URIs is not required anymore, and integration with the HDFS ACL synchronization now works properly

  * Fixes for exotic Hive options (“fixed-metastore” DataNucleus mode)

  * Fixed validation of some Hive recipes on MapR




#### Misc

  * It’s now possible to disable probability columns in multi-class classification recipes

  * Fixed features hashing

  * Fixed notebook export for Spectral Clustering models

  * Updated URI for the IUS repository

  * Various small UI fixes




## Version 2.0.1 - June 10th, 2015

Warning

For migrations from DSS 1.X, please see the DSS 2.0.0 release notes

DSS 2.0.1 is a bugfix release

### Recipes and Flow

  * Fixed bad initial settings for partitioned recipes

  * Small UI improvements

  * DSS now includes its own version of the Graphviz tool: fixes Flow layout on CentOS 6




### Datasets

  * Fixed the “Advanced” settings display for filesystem datasets

  * Fixed the “Explore” view for datasets imported from other projects

  * Fixed reading multiple JSON files with root path for elements.




### Machine Learning

  * Text handling: fixed display of the vocabulary for the Count and TF/IDF vectorizers

  * Avoid doing grid search when not needed in various alogrihtms

  * Fixed custom scoring function for regression problems

  * Fixed error when trying several number of trees in Random Forest

  * Fixed wrong results in scoring recipes when “drop rows” is selected for missing values handling




### Dashboard and insights

  * Fixed loading of nvd3.js

  * Fixed issues with settings of the insights miniatures

  * Fixed an issue with the hexagonal binning parameter (was not saved)




## Version 2.0.0 - May 19th, 2015

DSS 2.0.0 is a major upgrade that brings new exciting features and a redesigned user experience.

### Migration notes

Warning

Migration to DSS 2.0 from a previous DSS 1.X instance requires some attention.

To migrate to DSS 2.0, you must first upgrade your instance to the latest 1.4 version. See [DSS 1.4 Relase notes](<1.4.html>)

Automatic migration from Data Science Studio 1.4.X is supported, with the following restrictions and warnings:

  * Previously trained machine learning models must be retrained

  * As a consequence, machine learning models deployed directly in Flow without a retraining recipe won’t be usable anymore for scoring. You will need to retrain the model in an Analysis, redeploy it to Flow, and replug a scoring recipe.

  * If you use cross-projects recipes, you need to perform some adjustements detailed below




#### How to update ML models in Flow

If you have ML models in Flow, you need to retrain them before they are usable again.

#### How to update cross-projects recipes

In DSS 1.X, if you had access to projects A and B, then all datasets from project A could be directly used in project B. However, you had to create the recipe “manually”.

In DSS 2.X, the default behaviour has changed: only datasets from project A that are explicitly “exposed to project B” can be used, and they directly appear on the Flow of project B.

You can either:

  * Go to the project settings of project A and “expose” the required datasets to project B

  * Go to Administration > Settings > Misc and change the “Cross-projects access to datasets” behaviour.




Furthermore, by default, recursive builds now “stop” at project boundaries. You can change this behaviour on a per-dataset basis, and you can also change the default global behaviour in Administration > Settings > Misc.

#### Preparation and machine learning

On upgrade, all previous preparation scripts and machine learning model benches will be converted to the new Analysis component

#### How to upgrade

It is **strongly recommended** that you perform a full backup of your Data Science Studio data directory prior to starting the upgrade procedure.

#### Hadoop support

This release removes support for CDH 4

### External libraries upgrades

Several external libraries bundled with DSS have been bumped to major revisions. Some of these libraries (most notably Pandas include some _backwards-incompatible_ changes). You might need to upgrade your code.

Notable upgrades:

  * Pandas 0.14 -> 0.16. Breaking changes notably around categoricals. See <http://pandas.pydata.org/pandas-docs/stable/release.html>

  * Scikit-learn 0.14 -> 0.16




### New features

#### User experience

The user experience of DSS has been redesigned based on the feedbacks from our users.

  * Thanks to the organization in universes, you’ll always find what you need at your fingertips.

  * The new sidebar gives you immediate access to all actions in context.

  * A redesigned search that gives you immediate access to your recent items and contextually-relevant objects

  * The streamlined Flow lets you focus on what matters most and reduces visual clutter

  * Use checklists to organize your collaborative work in projects




#### Analysis and data preparation

The new “Analysis” module is where you’ll perform all visual analysis on a dataset. It combines the power of visual data preparation, drag-and-drop visualizations and guided machine learning.

You can now create new features using visual data preparation and immediately use them in machine learning models.

Data preparation now features a “Column-oriented view” for immediate glances on your dataset and easy mass actions.

New processor: currency converter (supports 40 currencies with historical data)

#### Machine learning

The machine learning component has been completely rehauled. It now features:

  * Advanced cross-validation policies:

    * K-Fold cross validation

    * Explicit train and test sets

  * Completely redesigned model assessment pages, with much deeper insight into the performance your models

  * Parallel grid search for semi-automatic optimization of models

  * New feature generation options

  * Text processing options: count, TF-IDF and hashing vectorizers, with support for stop words and n-grams

  * Binarization and quantization of numerical variables

  * Models in Flow are now versioned and you can choose how to switch to new versions

  * Built-in data preparation without prior materialization of the prepared datasets




#### Visual recipes

Several new visual recipes let you do more and more advanced data manipulation without writing a single line of code:

  * “Join” recipe (with multi-dataset, multi-key joins, fuzzy joins, case-insensitive joins, …)

  * “Split” recipe

  * “Union” recipe to concatenate datasets

  * Redesigned “Grouping” recipe




#### Easter eggs

Will you find all our new easter eggs ?

---

## [release_notes/old/2.1]

# DSS 2.1 Relase notes

## Migration notes

Warning

Migration to DSS 2.1 from DSS 1.X is not officially supported. You should first migrate to the latest 2.0.X version. See [DSS 2.0 Relase notes](<2.0.html>)

Automatic migration from Data Science Studio 2.0.X is supported, with the following restrictions and warnings:

  * The “Auto Mirrors” feature, which was deprecated since DSS 1.3 has been removed

  * In the Webapp builder, the deprecated API `dataiku_load_dataset` and `dataiku_dataset_object` have been removed

  * If you had any webapps that did not authorize any dataset, the API key associated to this webapp is not usable anymore. You will need to create a new webapp if you want to authorize datasets.

  * If you previously used Impala (in notebooks or charts), you will need to reconfigure Impala connectivity. See [Impala](<../../hadoop/impala.html>)

  * Following an upgrade of the IPython notebook, graphing features must be enabled manually in older Python notebooks.

  * After upgrade, you will need to follow again the procedure to [Install R integration](<../../installation/custom/r.html>)




### Getting charts in migrated Python notebooks

In DSS 1.X and 2.0, DSS used an older version of the IPython notebook that had graphing features “magically enabled”. DSS 2.1 includes a more recent version of the Jupyter notebook. This new version requires manual activation of the graphing features in the notebook.

Notebooks created directly in DSS 2.1 come with a snippet that automatically enables them.

To enable them on migrated notebooks, simply add a cell at the top of your notebook containing:
    
    
    %pylab inline
    

## Version 2.1.4 - October 29th 2015

DSS 2.1.4 is a bugfix release.

### Datasets

  * Fix UI for partitioned ElasticSearch datasets

  * Fix possible issue in writing to partitioned ElasticSearch datasets




### UI

  * Fix small issues in the “Run” button of recipes




### Flow

  * Improve handling of datasets being written while being used: Now, if a dataset is being written while being used as input of a recipe, DSS will properly remember the status of the source dataset at the beginning of the recipe, and will thus properly retrigger build if the dataset was modified during the previous recipe execution




### Recipes

  * Fix UI for the “Time range” dependency when the output is not partitioned

  * Improve the results of partitioning tests




### Charts

  * Fix approximate computation of quantiles in boxplots

  * Fix case sensitivity issue in Vertica live-processing charts




## Version 2.1.3 - October 20th 2015

DSS 2.1.3 is a bugfix release.

### Installation

  * Add support for Amazon Linux 2016.x and Ubuntu 15.10

  * Improve installation R on Redhat / CentOS

  * Make installation of R integration on Mac OS X more robust

  * Fix publication of Jupyter notebooks to dashboard




### Spark

  * Fix loading of non-Filesystem datasets (like SQL tables)

  * Fix loading of Parquet files with complex types (arrays, maps, structs)

  * Fix scoring recipes with Random Forest algorithm




### Charts

  * Fix processing of charts on HDFS when Impala is not installed

  * Fix aggregation on filtered grid geo charts

  * Fix display of records on grid geo charts

  * Fix handling of “No value” on grid geo charts

  * Fix display of filtered record count on scatter plots




### R

  * Fix handling of CSV files with multi-line fields

  * General cleanup




### UI

  * Fix UI glitch in lists editor

  * Fix display of preparation recipe on Chrome 46.

  * Fix schema update modal when a very large number were modified




## Version 2.1.2 - October 6th 2015

DSS 2.1.2 is a bugfix release.

### Installation

  * Fix migration from 2.0.X for webapps that had 0 dataset enabled.




### Flow and recipes

  * Code recipes can now have a partitioned dataset as input and a folder as output

  * Fix handling of column types in the Split recipe > “Dispatch values of a column”




### Datasets

  * Elastic Search

>     * fix failure reading indices with very large number of shards
> 
>     * fix handling of sampling.
> 
>     * close scroll handles on the server as soon as possible, avoids excessive resource consumption on the server




### Spark

  * Fix support for Spark 1.5.1




### Machine learning

  * Fix optimization of regression models based on RSME score




## Version 2.1.1 - October 2nd 2015

DSS 2.1.1 is a bugfix release.

Warning

For migration from previous versions, please see the DSS 2.1.0 release notes

### Installation

  * Fix support for Debian 7 in deps checker

  * Add support for Amazon Linux 2015.09

  * Fix migration of Webapp API keys in some cases

  * Fix migration of ColumnRenamer processor on analysis

  * Fix R automatic installation support for Debian 8




### Visual preparation

  * Fix numerical filters




### Spark

  * Drop rows where target is null

  * Drop missing now also handles Infinity




### Hadoop

  * Fix occasional failure of prepare recipes on Hadoop when starting many preparation recipes at once.




### UI

  * Fix scrolling in filesystem dataset schema

  * Fix aspect ratio of User pictures

  * Fix “Add checklist” button on project pages




## Version 2.1.0 - September 29th 2015

DSS 2.1.0 is a major upgrade that brings a wealth of new features and improvements.

For a summary of the major new features, see: <https://learn.dataiku.com/whatsnew>

### New features

#### Spark integration

DSS now features full integration with Apache Spark, the next-generation distributed analytic framework.

The integration of Spark in DSS 2.1 is pervasive and extends to all of the following features, which are now Spark-enabled:

  * Visual data preparation

  * “VisualSQL” recipes (Grouping, Joining, Stacking)

  * Guided machine learning in analysis

  * Training and prediction in Flow

  * PySpark recipe

  * SparkR recipe

  * SparkSQL recipe

  * PySpark-enabled notebook

  * SparkR-enabled notebook




All DSS data sources can be handled using Spark. As always in DSS, you can mix technologies freely, both Spark-enabled and traditional

For more information about Spark integration, see [DSS and Spark](<../../spark/index.html>)

#### Plugins

Plugins let you extend the features of DSS. You can add new kinds of datasets, recipes, visual preparation processors, custom formula functions, and more.

Plugins can be downloaded from the official Dataiku community site, or created by you and shared with your team.

#### Public API

DSS now includes a REST API to programmatically manage DSS from any HTTP-capable language.

To learn more about this API, see [Public REST API](<../../publicapi/index.html>)

#### Enhanced charts

The charts module of DSS has been vastly enhanced:

  * New chart types

>     * Scatterplots
> 
>     * Horizontal bar charts
> 
>     * Pie and donut charts
> 
>     * Boxplots
> 
>     * Pivot table (text view) and colored pivot table
> 
>     * Geographic scatter map
> 
>     * “Grid” map (fixed-width aggregation grid)
> 
>     * (Experimental) 2D distribution plot

  * Brand new user experience. It is now much easier to understand what’s going in your chart, and to switch dimensions and measures.

  * Improved presentation of date axis

  * All charts can now have semi-transparency

  * New computation mode for aggregated charts: “Percentage scale” (% of the total)

  * Tooltips now provide the ability to drill-down and exclude values




#### New R integration and Jupyter notebook

The bundled IPython notebook has been upgraded. DSS now includes Jupyter 4.0

This is a major new release of IPython/Jupyter, with lots of improvements, and the support for multiple languages.

The bundled Jupyter now comes builtin with a brand new R kernel, with vastly improved features over the previous R integration:

  * Syntax highlighting

  * Auto-completion (just hit Tab)

  * Much improved error handling




In addition, DSS features a new R API. See [R API](<../../R-api/index.html>) for more details.

#### Editable datasets

Editable datasets are a new kind of dataset in DSS, which you can directly create and modify in the DSS UI, ala Excel or Google Spreadsheets.

They can be used for example to create referentials, configuration datasets, …

Editable datasets can be imported from any file, or another dataset.

#### “Managed folders”

DSS comes with a large number of supported formats, machine learning engines, … But sometimes you want to do more.

DSS code recipes (Python and R) can now read and write from “Managed Folders”, handles on filesystem-hosted folders, where you can store any kind of data.

DSS will not try to read or write structured data from managed folders, but they appear in Flow and can be used for dependencies computation. Furthermore, you can upload and download files from the managed folder using the DSS API.

Here are some example use cases:

  * You have some files that DSS cannot read, but you have a Python library which can read them: upload the files to a manged folder, and use your Python library in a Python recipe to create a regular dataset

  * You want to use Vowpal Wabbit to create a model. DSS does not have full-fledged integration in VW. Make a first Python recipe that has a managed folder as output, and write the saved VW model in it. Write another recipe that reads from the same managed folder to make a prediction recipe

  * Anything else you might think of. Thanks to managed folders, DSS can help you even when it does not know about your data.




#### Impala recipe

Previously, DSS could use Impala:

  * For charts creation

  * In the Impala notebook




You can now also use Impala in a new Impala recipe to benefit from the speed of this engine for aggregations on HDFS.

Impala is also available as an engine for “VisualSQL” (Grouping, Join, Stack) recipes

#### Shell recipe

There are times when you just need to:

  * Run a shell command

  * Stream a dataset through a shell command (stdin/stdout)




The shell recipe lets you do just that.

#### Code snippets

In all modules of DSS where you can write code, you now have the ability to insert code snippets. DSS comes builtin with lots of useful snippets, and you can also write your own and share them with your team.

#### Elasticsearch dataset

DSS now has full read-write support for ElasticSearch datasets

#### Easter eggs

Will you find all our new easter eggs ?

### Other major enhancements

#### Multiple SQL statements support

Every module of DSS where you can write SQL code now support multiple statements.

For example, in the SQL Query recipe, you can now add statements before the main “SELECT” statement. This can allow you to issue some SET statements to tune the optimizer, or to create stored procedures.

In other words, you can now declare and call a stored procedure in a SQL Query recipe.

This also applies for the pre-write and post-write statements. For example, you can now create multiple indexes.

#### Running SQL, Hive and Impala from Python and R recipes

SQL is the most pervasive way to make data analysis queries. However, doing advanced logic, like loops, conditions, … is often difficult in SQL. There are some options like stored queries, but they require learning new languages.

DSS now lets you run SQL queries directly from a Python recipe. This lets you:

  * sequence several SQL queries

  * dynamically generate some new SQL queries to execute in the database

  * use SQL to obtain some aggregated data for further numerical processing in Python

  * …




To learn more, see [Performing SQL, Hive and Impala queries](<https://developer.dataiku.com/latest/api-reference/python/sql.html> "\(in Developer Guide\)")

#### “Repartitioning” mode

Thanks to “repartitioning” mode, you can now:

  * start with a non-partitioned files-based dataset where a column could act as a partitioning column

  * create a “repartitioning-enabled” sync or prepare recipe to transform it to a partitioned dataset

  * Build in a single pass all partitions of the target dataset




#### “Append” mode

Several recipes and datasets now support “Append” instead of “Overwrite” in target datasets.

While we do not recommend to use this for general-purpose datasets, it can be useful in some cases, like for example create a “history” dataset as output of a recipe, writing a new line each time the recipe is run.

#### HDP 2.3 support

DSS is now compatible with Hadoop HDP 2.3.0

#### Misc

  * Visual preparation

>     * Added detection of US states in Preparation recipes
> 
>     * New processor to concatenate arrays
> 
>     * The column renamer processor can now perform multiple renames
> 
>     * New mass actions to lowercase/uppercase/simplify many column names
> 
>     * Find/Replace processor can now work on all columns at once

  * Machine learning

>     * Analysis: Machine Learning training does not start automatically anymore, giving you an opportunity to review the settings prior to initial training.

  * Custom formula: new random() function

  * Automatic R integration installation, no more manual steps

  * UX

>     * All recipes now share a more common and more consistent layout, with the Run button always present on the most important tab.
> 
>     * When creating managed datasets, you now have more options to preconfigure the dataset based on common formats, or using known partitioning schemes
> 
>     * Better build dataset modal, with more clear explanation of the build modes




### Notable bug fixes

#### UI

  * Fixed various scrolling and drag-and-drop issues

  * Fix renaming of datasets when the name was already used

  * Fix project home display for readers

  * Fixed job preview when training a model

  * It’s now possible to choose a different SQL port

  * Improved behavior of exports

  * Fixed tagging of analysis

  * Fixed DSS disconnection when very long log lines are transferred




#### Charts

  * Fixed an issue with date range filters

  * Fixed a bug that could happen with numerical axis and small values

  * Fixed issue in geo chart when the value of the aggregation is 0

  * Fixed various issues in legend, especially with “Mixed columns/lines” charts




#### Hadoop

  * [HDP only] Fixed Hive recipes on readonly HDFS datasets

  * Fixed/Added support for native Snappy and LZO datasets

  * Fixed EXPLAIN statements in notebook for Hive

  * The command-line tool to import Hive databases now supports partitioning




#### SQL and VisualSQL recipes

  * Added ability to disable the “LIMIT” in statements for some operations that don’t support it (e.g. tuple mover operations on Vertica)

  * Fixed cases where the “limit” statement could get disabled

  * Fixed issues with Join recipe on Oracle

  * Grouping recipe: fixed issue with “LAST” aggregations function

  * Fixed typing of MIN/MAX on non-string columns

  * Grouping recipe can now use faster stream engine when computing COUNT




#### Machine learning

  * Fixed Gradient Boostring Tree in kfold mode with multiple losses

  * Fixed Lasso regression in AutoCV mode

  * SGD classification can now use sparse matrixes

  * Fixed error when imputation was disabled for all numerical features

  * Fixed error when using feature hashing on a numerical feature

  * Fixed broken models when RSMLE can’t be computed

  * Fixed some errors in notebook export




#### Reliability

  * Using “Compute number of records” on large datasets does not lock the studio anymore

  * Fixed a deadlock leading to the whole notification system ceasing to work

  * Fixed the infamous “error during execution of add command” issue with the internal Git repository

  * Fixed several cases where long operations could be performed while holding a lock on the DSS configuration (like Hive validation or aborting Impala queries)

  * DSS diagnosis now includes more useful information




#### Datasets

  * Fixed detection of Excel dates

  * Fixed detection of UTF-8 BOMs




#### Misc

  * Shapefiles that require Vecmath now display a proper informative message

  * We now display proper warning messages when using non-Hive-compatible HDFS dataset names

---

## [release_notes/old/2.2]

# DSS 2.2 Relase notes

## Migration notes

Warning

Migration to DSS 2.2 from DSS 1.X is not supported. You should first migrate to the latest 2.0.X version. See [DSS 2.0 Relase notes](<2.0.html>)

  * Automatic migration from Data Science Studio 2.1.X is fully supported.

  * Automatic migration from Data Science Studio 2.0.X is supported, subject to the notes and limitations outlined in [DSS 2.1 Relase notes](<2.1.html>)




For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)

## Version 2.2.5 - February 10th, 2015

DSS 2.2.5 is a bugfix version. For a summary of the major new features in the 2.2 series, see: <https://www.dataiku.com/learn/whatsnew>

### Datasets

  * Add support for reading database tables containing blobs (blobs are still skipped)




### Misc

  * Fix a deadlock leading to DSS freezing




## Version 2.2.4 - January 29th 2015

DSS 2.2.4 is a bugfix version. For a summary of the major new features in the 2.2 series, see: <https://www.dataiku.com/learn/whatsnew>

### Hadoop

Add support for HortonWorks HDP 2.3.4

## Version 2.2.3 - January 22nd 2015

DSS 2.2.3 is a bugfix version. For a summary of the major new features in the 2.2 series, see: <https://www.dataiku.com/learn/whatsnew>

### General

  * Fix a leak of threads that lead to an excessive resource consumption




### Hadoop

  * Fix handling of timezones in Impala recipes (when running in “stream” mode) by workarounding a JDBC driver bug




### Datasets

  * Add support for new S3 signature algorithms, enabling support of newest AWS regions

  * Remove excessive debugging in ElasticSearch datasets




### Recipes

  * Fix unclickable Create recipe button with foreign datasets

  * Fix ability to use Unicode column names in Python recipes




### Machine learning

  * Fix filters UI in “explicit extract from two datasets” mode in machine learning

  * Fix some cases where auto-setting model parameters doesn’t work

  * Fix refresh of data samples for clustering




## Version 2.2.2 - December 10th 2015

DSS 2.2.2 contains both bug fixes and new features. For a summary of the major new features in the 2.2 series, see: <https://learn.dataiku.com/whatsnew>

### New features

#### Experimental Spark-on-S3 and EMR support

DSS 2.2.2 contains an _experimental-only_ support for running Spark on S3 datasets, and for running on Amazon EMR.

#### Experimental SFTP support

You can now create datasets over SFTP connections. These datasets are available through the “RemoteFiles” (i.e. with local cache) mode.

#### Misc

  * S3 dataset can now target a custom endpoint




### Bugfixes

#### Spark

  * Fixed several issues handling complex types, especially on Avro datasets

  * Fixed case-sensitivity issues on Parquet datasets.




#### Hadoop

  * Fixed support for timestamp columns in Impala notebooks and recipes

  * Fixed issue with Kerberos connectivity




#### Datasets

  * Fix mappings not correctly propagated in ElasticSearch

  * S3 now properly ignores hidden and special files

  * Fixed S3 support for single-file datasets

  * Fixed partitioned SQL query datasets




#### Machine learning

  * Fixed computation of output probability centiles when working with K-Fold cross-test




#### Recipes

  * Fixed ability to remove input datasets in the Join recipe

  * The “Run” button in the R recipe editor has been fixed

  * Fixed “Push to editable” recipes always having the same name

  * Fixed ability to create recipes on foreign datasets

  * Fixed “Save” button badly behaving on SQL recipes

  * Grouping recipe:

>     * Do not display unavailable mass actions
> 
>     * Fixed MAX aggregation
> 
>     * Fixed storage types for custom aggregations

  * Window recipe: Fixed time-range bounding on Vertica




#### Visual data preparation

  * Fixed columns sometimes badly displaying when using mass removal




#### API node

  * Fixed issue with numerical columns used as categorical




#### Misc

  * Fixed a few issues on Safari

  * Fixed “Add description” button on home page




## Version 2.2.1 - November 17th 2015

DSS 2.2.1 is a bugfix release. For a summary of the new features in the 2.2.0, see: <https://learn.dataiku.com/whatsnew>

### Plugins

  * Introduced more support for partitioning and fix some related bugs

  * Fix bugs around boolean values in plugins configuration

  * Allow expansion of variables in plugin configuration

  * Make sure that new plugins are immediately recognized




### Editable datasets

  * Fix failure to save data when all columns had been previously removed




## Version 2.2.0 - November 11th 2015

DSS 2.2.0 is a significant upgrade, that brings major new features to DSS.

For a summary of the major new features, see: <https://learn.dataiku.com/whatsnew>

### New features

#### Prediction API server

DSS now comes with a full-featured API server, called DSS API Node, for real-time prediction of records.

By using DSS only, you can compute predictions for all records of an unlabeled datasets. Using the REST API of the DSS API node, you can request predictions for new previously-unseen records in real time.

The DSS API node provides high availability and scalability for scoring of records.

For more information about the API node, see [API Node & API Deployer: Real-time APIs](<../../apinode/index.html>)

#### Window function recipe

DSS now has a new visual recipe to compute SQL-99 style analytic functions (also called window functions).

This visual recipe makes it incredibly easy to create moving averages, ranks, quantiles, …

It provides the full power of your engine’s analytic support, with multiple windows, unlimited sort and partitioning, …

This recipe is available on all engines supporting it:

  * Most SQL databases

  * Hive

  * Spark

  * Cloudera Impala




### Other major enhancements

#### Plugins

The user response to our plugins feature has been overwhelming. In DSS 2.2, we have heard your feedback and made a ton of enhancements to the plugins system.

##### Core system

  * Activate plugins development tools directly within DSS.

  * Edit all plugin files directly within DSS. No command-line nor vi required!

  * Plugins can now retrieve a lot of DSS configuration details: know whether Spark or Impala are enabled, get proxy settings, …

  * Plugin-level configuration, retrievable by all datasets and recipes of the plugin. Great for storing access credentials for example.




##### Custom Datasets

  * Support for partitioned datasets. See our [Tutorial](<https://learn.dataiku.com/howto/other/partitioning/partitioning-redispatch.html>) for more information

  * View the logs directly in DSS UI




##### Custom recipes

  * The recipe UIs will now properly obey the role definitions

  * The new APIs make it much easier to write recipes that automatically dispatch to one of several engines, depending on the dataset configuration and which features are enabled.

  * Recipes can now read much more info about datasets (paths, files, DB details, …). This makes it easy to submit connection details directly to a third-party execution engine instead of having the data go through the DSS engine.




#### Long-running tasks infrastructure

DSS now has a new multi-process infrastructure for handling long-running tasks.

The key benefits are:

  * DSS is now more resilient against various data issues that could previously cause crashes

  * Aborting some long-running tasks, like computing a random sample on a SQL database is now faster and rock-solid

  * Each user can now list and abort all his own tasks from a centralized screen. Administrators can do the same with all tasks




#### SQL: dates without timezone

DSS now has full support for dates without timezone columns in all SQL databases. Previously, support and handling differed depending on the database engine.

For all databases, dates-without-timezone can now be handled as string, server-local dates or as a user-specified timezone.

#### Public API

The public API now includes a set of methods to interact with managed folders

#### Internal Python API

  * `dataiku.get_dss_settings()` (see paragraph about plugins)

  * `Dataset.get_location_info()` and `Dataset.get_files_info()` for new kinds of interaction with your datasets. (For example: submit connection details directly to a third-party execution engine instead of having the data go through the DSS engine)

  * `Dataset.get_formatted_data()` to retrieve a dataset as a stream of bytes with a specific format.




#### Multi-connection SQL recipes

SQL query recipes can now use (optionally) datasets from multiple connections (of the same type) as input. This lets you create a recipe that uses two databases on the same database server, for example.

It is still your responsibility to write the proper SQL to actually do the cross-database lookups.

### Notable bug fixes

#### Visual recipes

  * Fixes around partitioned VisualSQL recipes

  * Fix for vstack recipe on Oracle

  * Fix for grouping recipe on DSS engine with custom aggregations




#### Datasets

  * Default format of S3 datasets is now compatible with Redshift

  * Properly update the Hive metastore when the dataset schema changes




#### Recipes

  * Fixed SQL script on PostgreSQL with non-standard port

  * Fixed Hive error reporting (line numbers were not propagated properly)




#### Charts

  * Fixed hidden tooltips on published charts

  * Fixed saving of “one tick per bin” option




#### Machine learning

  * Fixed error in clustering when empty columns




#### UI

  * Fixed error when trying to upload a plugin without selecting a file.




#### Data preparation

  * Fixed wrongful detection as “Decimal french format”

  * Fixed display of custom date formats on Firefox

---

## [release_notes/old/2.3]

# DSS 2.3 Relase notes

## Migration notes

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)

Warning

Migration to DSS 2.3 from DSS 1.X is not supported. You should first migrate to the latest 2.0.X version. See [DSS 2.0 Relase notes](<2.0.html>)

  * Automatic migration from Data Science Studio 2.2.X and 2.1.X is supported, with the following restrictions and warnings:

>     * The usual limitations on retraining models and regenerating API node packages apply (see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>) for more information)

  * Automatic migration from Data Science Studio 2.0.X is supported, with the previous restrictions and warnings, and, in addition, the ones outlined in [DSS 2.1 Relase notes](<2.1.html>)




## Version 2.3.5 - May 23rd, 2016

DSS 2.3.5 is a bugfix and minor enhancements release. For a summary of new features in DSS 2.3.0, see below.

### Hadoop & Spark

  * Preserve the “hive.query.string” Hadoop configuration key in Hive notebook

  * Clear error message when trying to use Geometry columns in Spark




### Machine learning

  * Fix wrongly computed multiclass metrics

  * Much faster multiclass scoring for MLLib

  * Fix multiclass AUC when only 2 classes appear in test set

  * Fix tooltip issues in the clustering scatter plot




### API Node

  * Fix typo in custom HTTP header that could lead to inability to parse the response

  * Fix the INSEE enrichment processor

  * Fix excessive verbosity




### Data preparation

  * Fix DateParser in multi-columns mode when some of the columns are empty

  * Modifying a step comment now properly unlocks the “Save” button




### Visual recipes

  * Fix split recipe on “exotic” boolean values (Yes, No, 1, 0, …)




### Charts

  * Add percentage mode on pie/donut chart




### Misc

  * Enforce hierarchy of files to prevent possible out-of-datadir reads

  * Fix support for nginx >= 1.10




## Version 2.3.4 - April 28th, 2016

DSS 2.3.4 is a bugfix and minor enhancements release. For a summary of new features in DSS 2.3.0, see below.

### Hadoop

  * Add support for CDH 5.7 and Hive-on-Spark




### Data preparation

  * Fix “flag” processorso perating on “columns pattern” mode

  * Fix a UI issue with date facets

  * Add a few missing country names

  * Fix modulo operator on large numericals (> 2^31)




### Recipes

  * Window recipe: fix typing of custom aggregations




### Flow

  * Fix an issue that could lead to Abort not working properly on jobs




## Version 2.3.3 - April 7th, 2016

DSS 2.3.3 is a bugfix release. For a summary of new features in DSS 2.3.0, see below.

### Spark & Hadoop

  * Fixed support for Hive in MapR-ecosystem versions 1601 and above

  * Added support for Spark 1.6

  * Fixed ```select now()`` in Impala notebook




### Data preparation

  * Fixed misinterpretation of numbers like “017” as octal in the “Nest” processor

  * The variables will now be interpreted in the context of the current preparation, not the context of the input dataset

  * Fixed UI flickering

  * Fixed wrong “dirty” (i.e. not saved) state in the UI when there is a group in the recipe

  * Fixed bad state for the “prefix” option of the Unnest processor




### Recipes

  * SQL recipe: Fixed conversion from SQL notebook

  * Window recipe: Fixed data types for cumulative distribution

  * Stack recipe: Fixed custom schema definition in Stack recipe

  * Stack recipe: Fixed postfiler on filesystem-based datasets

  * Join recipe: Fixed “join on string contains” on Greenplum

  * Join recipe: Fixed computed date columns on Oracle

  * Join recipe: Fixed possible issue with cross-project joins on Hive

  * Filter recipe: Fixed boolean conditions on filesystem-based datasets

  * Group recipe: Fixed grouping in stream engine with empty values in integer columns

  * Group recipe: Fixed grouping on custom key in stream engine

  * Group recipe: Fixed UI issue when removing all grouping keys

  * All visual recipes: Fixed filters in multi-word column names

  * Sync recipe: Fixed partitioned to non-partitioned dataset creation

  * All recipes: Fixed UI for the time-range partitions dependency




### APIs

  * Python: fixed ``iter_tuples(columns=)`` which did not take columns into account




### Machine Learning

  * Fixed mishandling of accentuated values, leading them to appear as “Others” in dummy-encoded columns

  * Fixed clustering scoring recipe if no name was given to any cluster

  * Fixed wrong description of the metric used for classification threshold optimization

  * Fixed possible migration / settings issue in Ridge regression




### Misc

  * Fixed tags flow view in projects with foreign datasets

  * Fixed export of dataframe from Jupyter noteboook

  * Fixed user/group dialogs in LDAP mode

  * Fixed an occasional deadlock




## Version 2.3.2 - March 1st, 2016

DSS 2.3.2 is a bugfix release. For a summary of new features in DSS 2.3.0, see below.

### Machine Learning

  * Spark engine: Add support for probabilities in Random forest

  * Spark engine: Improve stability of results for models

  * Spark engine: Fix casting of output integers to doubles

  * Python engine: Fix a code error in Jupyter notebook export




### Data preparation

  * Fix fuzzy join hanging in rare conditions

  * Fix custom Python steps when there are custom variables with quotes

  * Fix deploying analysis on other dataset




### Recipes

  * Split: Fix support for adding custom variables to output dataset

  * Split: Fix UI reloading that could lead to broken recipe

  * Stack: Fix on Spark engine




### Visualization

  * Fix occasional issue with “Publish” button on Firefox




### Webapps

  * Fix support for filterExpression in JS API




### Misc

  * Fix export of non-partitioned dataset after export of partitioned dataset with explicit partitions list

  * Small UI fixes




## Version 2.3.1 - February 16th, 2016

DSS 2.3.1 is a bugfix release. For a summary of new features in DSS 2.3.0, see below.

### Installation

  * Disable IPv6 listening (introduced in 2.3.0) by default




### Datasets

  * Fix RemoteFiles dataset




### Data Wrangling

  * Fix running on Hadoop and Spark with “Remove rows on bad meaning” processor

  * Fix a case where the data quality bars were not properly updated

  * Fix formatting issue in latitude/longitude for GeoIP processor

  * Add a few missing countries to the Countries detector




### Spark

  * Default to repartitioning non-HDFS datasets in fewer partitions to avoid consuming too many file handles




### Data Catalog

  * Fix some prefix search cases with uppercase identifiers




### Machine Learning

  * Fixed filtering of features in settings screens

  * Don’t show “Export notebook” option for MLLib models




### Charts

  * Hide useless size parameter for filled admin maps




### Misc

  * Show tabs explicitly in code editors

  * Add code samples for webapps




## Version 2.3.0 - Feburary 11th 2016

DSS 2.3.0 is a major upgrade to DSS with exciting improvements.

For a summary of the major new features, see: <https://www.dataiku.com/learn/whatsnew>

### New features

#### Visual data preparation, reloaded

Our visual data preparation component is a major focus of DSS 2.3, with numerous large improvements:

  * You can now group, color and comment all script steps

  * It is now possible to color the cells of the data table by their values, to easily locate co-occurences, or columns changing together.

  * The Python and Formula editors are now much easier to use.

  * The Formula language has been strongly enriched, making it a very powerful, but still very easy to use tool. See [Formula language](<../../formula/index.html>) and our new Howto for more information.

  * The Quick Column View provides an immediate overview of all columns, and allows you to navigate very simply across columns.

  * The header at the top of the table now always precisely tells you what you are seing and the impact of your preparation on your data.

  * Many processors are now multi-column able, including the ability to select all columns, or all columns matching a pattern.

  * It is now possible to temporarily hide some columns

  * Hit Shift+V to view “long” values in a data table cell, including JSON formatting and folding

  * The redesigned UI makes it much clearer to navigate your preparation steps and data table.




#### Schemas edition and user-defined meanings

If it now possible to edit the schemas of datasets directly in the Exploration screen.

You can now define your own meanings, either declaratively, through values lists or through patterns. User-defined meanings are available everywhere you need them, bringing easy documentation to your data projects. For more informations, see [Schemas, storage types and meanings](<../../schemas/index.html>)

#### Data Catalog

Since the very first versions, DSS let you search within your project. Thanks to the new Data Catalog, you now have an extremely powerful instance-wide search. Even if you have dozens of projects, you’ll be able to find easily all DSS objects, with deep search (search a dataset by column name, a recipe by comments in the code, …).

The Data Catalog provides a faceted search and fully respects applicative security.

#### Flow tools and views

The new Flow views system is an advanced productivity tool, especially designed for large projects. It provides additional “layers” onto the Flow:

  * Color by tag name and easily propagate tags

  * Recursively check and propagate schema changes across a Flow

  * Check the consistency of datasets and recipes across a project.




#### New SQL / Hive / Impala notebook

The SQL / Hive / Impala notebook now features a “multi-cells” mechanism that lets you work on several queries at once, without having to juggle several notebooks or search endlessly in the history.

You can also now add comments and descriptions, to transform your SQL notebooks into real data stories.

#### Contextual help

  * DSS now includes helper tooltips to guide you through the UI

  * The Help menu now features a contextual search in our documentation




### Other notable enhancements

#### Plugins

You can now automatically install the plugin dependencies. Plugin authors can also declare custom installation scripts, if the installation of your plugin is not a simple matter of installing Python or R packages.

#### Data preparation

  * New processor for converting “french decimals” (1 234,23) or “US decimals” (1,234.23) to “regular decimals” (1234.23)

  * New processors to clear cells on number range or with a value

  * New processors to flag records on number range or with a value

  * New processor to count occurences of a string or pattern within a cell

  * Added support of full names in “US State” meaning

  * Added more mass actions




#### Hadoop

  * (Hortonworks only) Tez sessions are now reused in the SQL notebook




#### Machine learning

  * Coefficients are now displayed in Ordinary Least Squares regression




#### Datasets

  * Support for ElasticSearch 2.X

  * Experimental support for append mode on Elasticsearch




#### Recipes

  * Shell: now supports variables

  * Split: can now split on the result of a formula

  * Can now define custom additional configuration and statements in “Visual recipes on SQL / Hive / Impala”




#### API

  * The public API now includes a set of methods to interact with user-defined meanings.

  * R API: now automatically handles lists in resulting dataframes




#### Infrastructure / Packaging

  * Environment ulimit is now checked when starting

  * DSS now checks whether server ports are busy at startup




### Notable bug fixes

#### Datasets

  * Counting records on SQL query datasets is now possible

  * MongoDB: dates support has been fixed

  * MySQL: fixed handling of null dates

  * MongoDB empty columns are now properly shown




#### Data preparation

  * Currency converter now works properly with input date columns

  * “Step preview” doesn’t change output dataset schema anymore

  * Copying a preparation recipe with a Join step now generates proper Flow

  * Formula dates support has been improved

  * Fixed sort by cardinality in columns view

  * Hidden clustering buttons in explore view




#### Charts

  * Exporting “Grouped XY” charts to Excel has been fixed

  * Fixed issues on charts created by a “Deploy script”




#### Hadoop

  * The hproxy process now starts properly if the Hive metastore is unreachable

  * After a metastore failure, the hproxy now recovers properly

  * Partitioned recipes on Impala engine have been fixed




#### Machine learning

  * Fixed an UI bug on confusion matrix




#### Recipes

  * Managed Folders properly appear in search results

  * Grouping: drag and drop when 0 keys has been fixed

  * Stack: “schema union” mode now works properly on Vertica

  * Window: fixed lead/lag on dates in Vertica

  * Don’t accept to run a failing join recipe on filesystem datasets with quotes in columns




#### Notebooks

  * Fixed various bugs related to Abort in SQL notebooks

  * Fixed code samples in SQL notebooks

  * Upgraded Jupyter




#### API

  * Project admin permission now properly grants all other project permissions

  * R API: now displays a proper error when trying to write non-existent dataset

  * R API: fixed writing of data.table object




#### Infrastructure / Packaging

  * Java startup options are now properly set on all processes

  * DSS now works properly when you have an http_proxy environment variable

---

## [release_notes/old/3.0]

# DSS 3.0 Relase notes

## Migration notes

Warning

Migration to DSS 3.0 from a previous DSS 2.X instance requires some attention.

To migrate from DSS 1.X, you must first upgrade to 2.0. See [DSS 2.0 Relase notes](<2.0.html>)

Automatic migration from Data Science Studio 2.3.X is supported, with the following restrictions and warnings:

  * DSS 3.0 features an improved security model. The migration aims at preserving as much as possible the previously defined permissions, but we strongly encourage you to review the permissions of users and groups after migration.

  * DSS 3.0 now enforces the “Reader” / “Data Analyst” / “Data Scientist” roles in the DSS licensing model. You might need to adjust the roles for your users after upgrade.

  * DSS now includes the XGBoost library in the visual machine learning interface. If you had previously installed older versions of the XGBoost Python library (using pip), the XGBoost algorithm in the visual machine learning interface might not work

  * The usual limitations on retraining models and regenerating API node packages apply (see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>) for more information)

  * After migration, all previously scheduled jobs are disabled, to ease the “2.X and 3.X in parallel” deployment models. You’ll need to go to the scenarios pages in your projects to re-enable your previously scheduled jobs.




Automatic migration from Data Science Studio 2.0.X, 2.1.X and 2.2.X is supported, with the previous restrictions and warnings, and, in addition, the ones outlined in [DSS 2.1 Relase notes](<2.1.html>), [DSS 2.2 Relase notes](<2.2.html>), [DSS 2.3 Relase notes](<2.3.html>)

### How to upgrade

It is strongly recommended that you perform a full backup of your Data Science Studio data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)

### External libraries upgrades

Several external libraries bundled with DSS have been bumped to major revisions. Some of these libraries include some _backwards-incompatible_ changes. You might need to upgrade your code.

Notable upgrades:

  * Pandas 0.16-> 0.17

  * Scikit-learn 0.16 -> 0.17




### From scheduled jobs to scenarios

The 3.0 version introduces Scenarios, which replace Scheduled jobs.

Each scheduled job you had in 2.X, enabled or not, is transformed during the migration process into a simple scenario replicating the functionalities of that scheduled job:

  * the scenario contains a single build step to build the datasets that the scheduled job was building

  * the scenario contains a single time-based trigger with the same setup as the scheduled job, so that the trigger activates exactly with the same frequency and time point as the scheduled job




If the scheduled job was enabled, the time-based trigger of the corresponding scenario is enabled, and conversely. The scenarios themselves are set to inactive, so that after the migration none will run. You need to activate the scenarios (for example from the scenarios’ list), or take the opportunity to rearrange the work that the scheduled jobs were performing into a smaller number of scenarios; a single scenario can indeed launch multiple builds, waiting for a build to finish before launching the next one.

Since a scenario will execute the build corresponding to a scheduled job only when its trigger is active and the scenario itself is active, the quickest route to get the same scheduled builds as before is to activate all scenarios.

## Version 3.0.5 - June 24th, 2016

This release fixes a critical bug related to Spark, plus several smaller bug fixes.

### Spark

  * Fix MLLib and Data preparation on Spark




### Datasets

  * Fix exception in JSON extractor with some specific cases of nested arrays




### Machine learning

  * Fix XGboost regression models when evaluation metrics is MAE, MAPE, EVS or MSE

  * Display grid search scores in regression reports




### API node

  * Fix various issues with data enrichment in “mapped” mode




### Webapps

  * Fix loading data from local/static




### Recipes

  * Fix validation of custom expressions in sample recipe




### Automation

  * Fix migration of scenarios from DSS 2.3 with partitions

  * Better explanations as to why some scenarios are aborted

  * Fix layout issues in scenario screens




### Misc

  * Fix mass tagging on Hive and Impala notebooks

  * Fixs on graph for job preview




## Version 3.0.4 - June 16th, 2016

This release brings a lot of bug fixes and minor features for plugins.

### Plugins

  * Add ability to introduce visual separators in settings screen

  * Add ability to hide parameters in settings screen

  * Add ability to huse custom forms in settings screen




### Production

  * Add a metric for count of non null values

  * Add more metrics in the “data validity” probe

  * Expand capabilities for custom SQL aggregations

  * Add the ability to have custom checks in plugins

  * Use proxy settings for HTTP-based reporters

  * Fix and improve settings of the “append to dataset” reporter




### SQL Notebook

  * Make the spinner appear immediately after submitting the query

  * Fix error reporting issues

  * Fix reloading of results in multi-cells mode

  * Add support for variables expansion




### Recipes

  * Fix visual recipes running on Hive with multiple Hive DBs

  * Fix reloading of split and filtering recipe with custom variables




### Machine learning

  * Fix display of preparation step groups in model reports

  * Fix simple Shuffle-based cross-validation on regression models

  * Fix train-test split based on extract from two datasets with filter on test

  * Fix deploying “clustering” recipe on connections other than Filesystem

  * Add ability to disable XGBoost early stopping on regression




### Datasets

  * Fix renaming of datasets in the UI

  * Fix the Twitter dataset

  * Fix “Import data” modal in editable dataset

  * Fix reloading of schema for Redshift and other DBs




### Data preparation

  * Improved display of filters for small numerical values

  * Fix mass change meaning action

  * Add ability to mass revert to default meaning

  * Unselect the steps when unselecting a group

  * Fix UI issue on Firefox




### Charts

  * Add ability to have “external” legend on more charts

  * Fix several small bugs

  * Fix scale on charts with 2 Y-axis




### Misc

  * Fix issue with R installation on Redhat 6

  * Fix missing information in diagnostic tool

  * Fix import of projects with SQL notebooks from 2.X

  * Fix saving of summary info for web apps

  * Add dataset listing and schema fetching in web apps API




## Version 3.0.3 - May 30th, 2016

DSS 3.0.3 is a bugfix release. For a summary of new features in DSS 3.0, see below.

### Recipes

  * Fix bug leading to unusable join recipe in some specific cases

  * Fix performance issue in code recipes with large number of columns




### Metrics & Scenarios

  * Fix history charts for points with no value

  * Fix possible race condition leading to considering some jobs as failed




### Misc

  * Fix various UI issues in read-only mode

  * Fix critical login bug

  * Fix “Disconnected” overlay on Monitoring page




## Version 3.0.2 - May 25th, 2016

DSS 3.0.2 is a bugfix and minor enhancements release. For a summary of new features in DSS 3.0, see below.

### Hadoop & Spark

  * Preserve the “hive.query.string” Hadoop configuration key in Hive notebook

  * Clear error message when trying to use Geometry columns in Spark

  * Fix S3 support in Spark




### Metrics & Checks

  * Better performance for partitions list

  * Simplify and rework the way metrics are enabled and configured




### Automation node & scenarios

  * Add deletion of bundles

  * Remap connections in SQL notebooks

  * Fix scenario run URL in mails




### Machine learning

  * Fix wrongly computed multiclass metrics

  * Much faster multiclass scoring for MLLib

  * Fix multiclass AUC when only 2 classes appear in test set

  * Fix tooltip issues in the clustering scatter plot




### API Node

  * Fix typo in custom HTTP header that could lead to inability to parse the response

  * Fix the INSEE enrichment processor

  * Fix excessive verbosity




### Data preparation

  * Add a new processor to compute distance between geo points

  * Fix DateParser in multi-columns mode when some of the columns are empty

  * Modifying a step comment now properly unlocks the “Save” button




### Visual recipes

  * Fix split recipe on “exotic” boolean values (Yes, No, 1, 0, …)




### Charts

  * Add percentage mode on pie/donut chart




### Misc

  * Add new error reporting tools

  * Enforce hierarchy of files to prevent possible out-of-datadir reads

  * Fix support for nginx >= 1.10

  * Fix the ability to remove a group permission on a project




### Webapps

  * Automatically enable/disable the Save button

  * Warn if leaving with unsaved changes

  * Add history and explicit commit mode




## Version 3.0.1 - May 11th 2016

DSS 3.0.1 is a bugfix release. For a summary of the major new features in DSS 3.0, see: <https://www.dataiku.com/learn/whatsnew>

### Installation

  * Added support for nginx >= 1.10




### Connectivity

  * Fixed “Other SQL databases” connections




### Metrics & Checks

  * Fixed ordering of partitions table

  * Default probes and metrics will now be enabled on migration from 2.X




### Scenarios

  * Improved description of triggers




### Machine Learning

  * Removed unapplicable parameter for MLLib

  * Improve explanations about target remapping in Jupyter export




### Data preparation

  * Fixed migration on groups

  * Multiple ColumnRenamer processors will automatically be merged




### Misc

  * Fixed display of Git diffs which could break

  * Fixed display of logs on Safari

  * Fixed tasks lists on projects

  * Added user-customized themes

  * “Read-only Analysts” can now fully view visual analysis screens

  * Added “project-import” and “project-export” commands to dsscli




## Version 3.0.0 - May 1st 2016

DSS 3.0.0 is a major upgrade to DSS with exciting new features.

For a summary of the major new features, see: <https://www.dataiku.com/learn/whatsnew>

### New features

#### Automation deployment (“bundles”)

Dataiku DSS now comes in three flavors, called node types:

  * The Design node (the “classical” DSS), where you mainly design your workflows

  * The Automation node, where you run and automate your workflows

  * The API node (introduced in DSS 2.2), where you score new records in real-time using a REST API




After designing your data workflow in the design node, you can package it in a consistent artefact, called a “bundle”, which can the be deployed to the automation node.

On the automation node, you can activate, rollback and manage all versions of your bundles.

This new architecture makes it very easy to implement complex deployment use cases, with development, acceptance, preproduction and production environments.

For more information, please see our product page: <http://www.dataiku.com/dss/features/deployment/>

#### Scenarios

DSS has always been about rebuilding entire dataflows at once, thanks to its smart incremental reconstruction engine.

With the introduction of automation scenarios, you can now automate more complex use cases:

  * Building a part of the flow before another one (for partitioning purposes for example)

  * Automatically retraining models if they have diverged too much.




Scenarios are made up of:

  * Triggers, that decide when the scenario runs

  * Steps, the building blocks of your scenarios

  * Reporters, to notify the outside world.




You’ll find a lot of information in [Automation scenarios](<../../scenarios/index.html>)

#### Metrics and checks

You can now track various advanced metrics about datasets, recipes, models and managed folders. For example:

  * The size of a dataset

  * The average of a column in a dataset

  * The number of invalid rows for a given meaning in a column

  * All performance metrics of a saved model

  * The number of files in a managed folder




In addition to these built-in metrics, you can define custom metrics using Python or SQL. Metrics are historized for deep insights into the evolution of your data flow and can be fully accessed through the DSS APIs.

Then, you can define automatic data checks based on these metrics, that act as automatic sanity tests of your data pipeline. For example, automatically fail a job if the average value of a column has drifted by more than 10% since the previous week.

#### Advanced version control

Git-based version control is now integrated much more tightly in DSS.

  * View the history of your project, recipes, scenarios, … from the UI

  * Write your own commit messages

  * Choose between automatic commit at each edit or manual commit (either by component or by project)




In addition, you can now choose between having a global Git repository or a Git repository per project

When viewing the history, you can get the diff of each commit, or compare two commits.

#### Team activity dashboards

Monitor the activity of each project thanks to our team activity dashboards.

#### Administrator monitoring dashboards

We’ve added a lot of monitoring dashboards for administrators, especially for large instances with lots of projects:

  * Global usage summary

  * Data size per connection

  * Tasks running on the Hadoop and Spark clusters and per database

  * Tasks running in the background on DSS

  * Authorization matrix for an overview of all effective authorizations




### Other notable enhancements

#### Project import/export

When exporting a project, you can now export all datasets from all connections (except partitioned datasets), saved models and managed folders. When importing the project in another DSS design node, the data is automatically reloaded.

This allows to export complete projects, including data.

When importing projects, you can also _remap_ connections, removing the need to define connections with exactly the same name as on the source DSS instance.

#### Maintenance tasks

DSS now performs automatically several maintenance and cleanup tasks in the background.

#### Improved security model

We’ve added several new permissions for more fine-grained control. The following permissions can now be granted to each group, independently of the admin permissions:

  * Create projects and tutorials

  * Write “unsafe” code (that might be used to circumvent the permissions system)

  * Manage user-defined meanings




In addition, users can now create personal connections without admin intervention.

The administration UI now includes an authorization matrix for an overview of all effective authorizations

#### API

  * The public API includes new methods to interact with scenarios and metrics

  * The public API includes new methods for exporting projects




#### Data preparation

  * It’s now possible to delete columns based on a name pattern




### Other changes

  * DSS does not automatically grant Analyst access to the “first analysts group” when creating a project. After the creation of a project, only its creator (and the DSS administrators) can access it by default.

---

## [release_notes/old/3.1]

# DSS 3.1 Release notes

## Migration notes

### Migration paths to DSS 3.1

>   * From DSS 3.0: Automatic migration is supported, with the following restrictions and warnings
> 
>   * From DSS 2.X: In addition to the following restrictions and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions: see [2.0 -> 2.1](<2.1.html>) [2.1 -> 2.2](<2.2.html>) [2.2 -> 2.3](<2.3.html>) [2.3 -> 3.0](<3.0.html>)
> 
>   * Migration from DSS 1.X is not supported. You must first upgrade to 2.0. See [DSS 2.0 Relase notes](<2.0.html>)
> 
> 


### Limitations and warnings

  * The usual limitations on retraining models and regenerating API node packages apply (see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>) for more information). Note that DSS 3.1 includes a vast overhaul of the machine learning part, so machine learning models trained with previous DSS will not work in DSS 3.1




### How to upgrade

It is strongly recommended that you perform a full backup of your Data Science Studio data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)

### External libraries upgrades

Several external libraries bundled with DSS have been bumped to major revisions. Some of these libraries include some _backwards-incompatible_ changes. You might need to upgrade your code.

Notable upgrades:

  * ggplot 0.6 -> 0.9

  * pandas 0.17 -> 0.18

  * numpy 1.9 -> 1.10

  * requests 2.9 -> 2.10




## Version 3.1.5 - November 21st 2016

### Data preparation

  * Fix selection of partial column content

  * Fix removal of a value in a “Delete matching rows” step

  * Improve explanations for “Filter on invalid meaning” processor

  * Fix error when removing a column which was used for coloring cells

  * Fix unsaved changes to design sample in preparation recipes

  * Add [reference of all processors](<../../preparation/processors/index.html>) in documentation




### Flow & Recipes

  * Fix timezone issues on group and join recipes on Filesystem datasets

  * Fix disabling of pre-filter in visual recipes




### Charts

  * Fix flickering and reset of zoom in map charts

  * Fix disappearing smallest bubble in scatter plot

  * Display an error message when trying to plot 100% stacked columns with negative values




### Datasets

  * Uploaded files don’t disappear anymore when going back to the “Connection” tab

  * Fix writing dates to “CSV (Hive Compatible)” format from a Python recipe




### Misc

  * Fix ability to abort a project export

  * Don’t fail project imports containing data for a SQL query dataset

  * Fix UI bug in messaging channels

  * Fix R install on Mac OS X

  * Fix export to GeoJSON




## Version 3.1.4 - October 3rd 2016

### Hadoop & Spark

  * Add support for HDP 2.5

  * Add support for EMR 4.7 and 4.8

  * Spark writing: Faster write for Parquet by using native Spark code

  * Spark writing: don’t fail on invalid dates

  * Pig: Fix PigStorage (for CSV files) on Pig 0.14+

  * Fix possible hang when aborting Hive+Tez queries

  * Improve logging inside the hproxy process




### Datasets

  * Fix Redshift support (bug introduced in 3.1.3)

  * Add ability to load AWS credentials from environment

  * Fix “COUNT” metric on Oracle

  * Make fetch size configurable for all SQL datasets

  * Several fixes for Teradata support




### Machine learning

  * Fix MROC AUC computation on Jupyter export of multiclass model

  * H2O: bump version and fix support out-of-the-box on CDH’s Spark




### Misc

  * Fix dataset export from dashboard

  * Add support for Markdown on custom “Homepage” messages

  * SQL notebook: show aborted status immediately when aborting a query

  * Add API to read metrics on managed folders

  * Create the underlying folder of a managed folder upon addition

  * Fix scrolling on API keys page

  * Add ability to use case-insensitive logins on LDAP

  * LDAP users will now be imported as readers by default




## Version 3.1.3 - September 19th 2016

DSS 3.1.3 is a bugfix release. For more information about 3.1.X, see the release notes for 3.1.0.

### Hadoop & Spark

  * Add support for MapR 5.2

  * Add partial support for Hive 2.1

  * Add ability to pass arbitrary arguments to Spark, useful for –packages




### Datasets

  * Fix some kinds of formulas in Excel reader




### Data preparation

  * Fix random failure occuring in the “Holidays computer” processor

  * Fix output data of the JSONPath extractor processor

  * Fix date diff (reversed order)




### Visual recipes

  * Fix date filtering




### Data viualization

  * Add ability to use shapes in scatter plot

  * Minor improvements in tooltip handling




### Machine Learning

  * Fix “Impute with Median” in MLlib on CDH 5.7/5.8

  * Fix possible failure in clustering results

  * Fix error in clustering recipe when filtering columns

  * Add configurability of max features in random forest algorithms




### Lab

  * Fix encoding issues in PCA notebook




### Misc

  * Metrics & Checks: Fix multiple SQL probes on the same datasets

  * Performance improvements for custom exporters

  * Performance improvements for Data Catalog

  * Performance improvements on home page

  * Small UI fixes in themes

  * Small UI improvements here and there

  * Update PostgreSQL driver (fixes result sets with more than 2B results)




## Version 3.1.2 - August 22nd 2016

DSS 3.1.2 is a bugfix release. For more information about 3.1.X, see the release notes for 3.1.0.

### ML

  * Fixed “red/green” indicator for MAPE

  * Improved visualization of decision trees

  * Warn when trying to use numerical features for Naive Bayes

  * Make GBT regression exportable to notebook

  * Fixed clustering scoring recipes migrated from 3.0

  * Add Impute with median on MLLib

  * Don’t fail when rejected features are not present in the scoring recipe input




### Datasets

  * Configurable batch size for writing to ElasticSearch

  * Fixed edition of columns on editable dataset




### Automation

  * Fix attachment of a dataset in the “Send message” step

  * Fix intermittent failures with “Make API node package” step

  * Add ability to directly use `get_custom_variables` in a custom check




### Installation & Admin

  * Fixed R integration, following changes in IRKernel

  * Fixed “radial” layout on home page

  * Optional reporting on internal metrics to Graphite

  * Fixed “Cluster tasks” and “Per-connection data” views on Hadoop




### Misc

  * Major performance improvements in various areas, especially with large number of projects, datasets, or users

  * Improved copy/paste of code from diff viewer

  * Tighten permissions on managed folders

  * Fixes for custom Scala recipe in plugin development environment

  * Fixed `get_config` call on Python API

  * Don’t fail on homepage with broken Jupyter notebooks

  * Fixed small UI issue on custom aggregations in grouping recipe

  * Fixed extension of export filenames

  * Fixed small UI issues with Chrome 52

  * Don’t allow the custom formula processor’s edition form to overflow




## Version 3.1.1 - August 10th 2016

DSS 3.1.1 is a bugfix release. For more information about 3.1.X, see the release notes for 3.1.0.

### ML

  * Fixed various errors in models status

  * Fixed deployment of Vertica ML models when the target is not in the dataset to score

  * Improved the autocomputed schema as output of scoring recipes

  * Fixed bug when a custom evaluation function is partially defined

  * Improved resiliency and error messages for custom evaluation functions




### Spark

  * Fixed Spark recipes on CDH

  * Fixed Scala recipes on CDH

  * Fixed SparkR recipe

  * Added the ability ot have Unicode characters in Scala recipe source




### Misc

  * Added Jupyter logs to diagnostic reports

  * Fixed visibility of “Clear filters” link on some themes




## Version 3.1.0 - July 27th 2016

DSS 3.1.0 is a major upgrade to DSS with exciting new features.

For a summary of the major new features, see: <https://www.dataiku.com/learn/whatsnew>

### New features

#### Scala recipe and notebook

You can now interact with Spark using Scala, the most native language for Spark processing.

This release brings to DSS:

  * Spark-Scala recipes

  * Spark-Scala notebooks

  * Custom recipes (plugins) written in Scala




For more information, please see [Spark-Scala recipes](<../../code_recipes/scala.html>)

#### H2O integration (through Sparkling-Water)

[H2O](<http://h2o.ai>) is a distributed machine-learning library, with a wide range of algorithms and methods.

DSS now includes full support for H2O (in its “Sparkling Water” variant) in its visual machine learning interface.

Advanced users can also leverage H2O through all Spark-based recipes and notebooks of DSS.

#### New DSS home page & workflow

The DSS home page now features:

  * The ability to set a customizable “status” to projects, in order to materialize your workflow (draft, production, archived, …) in DSS

  * The ability to filter projects by tags, status, owner, …

  * The ability to sort projects

  * A new “list” view with advanced details (contents of the project, activity monitoring, …)

  * A new “flow” view to study the dependencies between projects

  * Useful “Tips and Tricks”




#### Navigator

Boost your productivity ! You can now very quickly navigate from a DSS object to another (from recipe to dataset to another recipe to model to analysis …).

Hit Shift+A on any screen to enter the navigator.

#### Prebuilt notebooks

You can now use prebuilt templates for notebooks when creating a notebook from a dataset. This allows for reusable interactive analysis

DSS 3.1 comes with 4 prebuilt notebooks for analyzing datasets:

  * PCA

  * Correlations between variables

  * Time series visualization and analytics

  * Time series forecasting




#### New data sources

DSS can now connect to the following SQL databases

  * [IBM Netezza](<../../connecting/sql/netezza.html>)

  * [SAP HANA](<../../connecting/sql/saphana.html>)

  * [Google BigQuery](<../../connecting/bigquery.html>) (Read only)

  * [Microsoft Azure DWH](<../../connecting/sql/sqlserver.html>)




#### Machine learning visualizations

DSS now includes the following new visualizations in Machine Learning

  * Decision tree(s) visualization for Decision Tree, Random Forests and Gradient Boosting

  * Partial dependency plots for Gradient Boosting




#### More custom algorithms support

Custom algorithms are now supported in:

  * Python Clustering (Python)

  * Spark MLLib Prediction (Scala)

  * Spark MLLib Clustering (Scala)




#### Custom Formats and Export

A brand new export mechanism has been introduced. It provides easier configuration and expands what can be supported.

It is now possible to write custom format extractors and exporters, either in Python or Java. See our plugins library for examples.

This notably provides a much improved support for export to Tableau (TDE files or Tableau Server): open any data from DSS in Tableau in just 2 clicks!

### Other notable enhancements

#### Data preparation

  * New processor: date filter

  * New processor: compute distance between geopoints




#### Machine learning

  * Handling of data types has been strongly overhauled, resulting in better reliability in machine learning

  * Additional algorithms have been added in Spark MLLib

  * DSS now supports clustering in the Spark MLLib implementation

  * You can now export variables importance and coefficients data directly from the machine learning UI

  * When doing dummy-encoding, DSS can now remove the last dummy to avoid collinearity (especially useful for regression models). DSS by default automatically uses the proper behavior according to the algorithm.

  * When doing dummy-encoding, DSS has more options for handling features with large cardinalities (clip above a number of dummies, clip after a cumulative distribution, clip below a threshold in number of records)

  * Much faster scoring in MLLib multiclass

  * In scoring recipe, it is now possible to select the input columns to retain in output

  * In scoring recipe, it is now possible to “unplug” the output schema from the input. This is especially useful in corner cases where the data type is incorrect

  * Added support for in-database machine learning on Vertica, through Vertica 7 Advanced Analytics package

  * Added links to original analysis from training recipe & saved models




#### Visual recipes

  * The join recipe now has support for more join types: Inner, Left, Right, Outer, Cross, Natural and Advanced (left with optional dedup)

  * The join recipe now has support for various kinds of inequality joins




#### Datasets & formats

  * Very large Excel files can now be opened with small memory overhead

  * New option for CSV and SQL: normalize doubles (ie: always add .0 to doubles). This makes operation between doubles and integers generally more reliable

  * Add support for newer AWS S3 regions (like eu-central-1)




#### Automation (scenarios, bundles, metrics, checks)

  * Counting records on small datasets will not use Hive anymore

  * Custom checks (in a plugin) can now be used




#### Hadoop & Spark

  * It is now possible to import Hive tables as HDFS datasets from the DSS UI

  * You can now validate SparkSQL recipes without having to run them




#### Installation and setup

  * The most standard Java options can now be set directly from the install.ini file. See [Advanced Java runtime configuration](<../../installation/custom/advanced-java-customization.html>)

  * DSS can now use Conda for managing its internal Python environment instead of virtualenv/pip

  * Enhanced the content of DSS diagnosis reports




#### Misc

  * You can now expose a folder or a file in a folder on the Dashboard

  * Error handling has been improved in numerous places. DSS will now more prominently display the actual errors, especially when using code recipes

  * DSS now includes a public API for interacting with recipes

  * New interaction features in plugins

  * The schema of a dataset can be exported (to any supported formatter) from the settings screen

  * Access to datasets from Python and R is much faster, especially for small datasets

  * SQL connectors can now use custom JDBC URLs for advanced customization

  * Custom variables are now available in Webapps

  * New default pictures for users

  * Lots of performance improvements, both in the backend and frontend




### Notable bug fixes

  * Very large Excel files can now be opened with small memory overhead

  * Machine Learning: Imputation with Unicode values has been fixed

  * Visual preparation: much faster drag & drop with Firefox

  * Fixed a bunch of JS errors

  * Visual recipes running on Hive or Impala will properly take into account the case-insensitivity of these DBs and not generate case-mismatched Parquet files anymore

  * Fixed possible job failures in Kerberos-secured clusters

  * Add multi-schema support to S3 -> Redshift syncing

  * Don’t forget to clear a dataset before doing a redispatch-sync

  * Switched to CartoDB tiles for maps

---

## [release_notes/old/4.0]

# DSS 4.0 Release notes

## Migration notes

### Migration paths to DSS 4.0

>   * From DSS 3.1: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 3.0: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to DSS 3.0. See [3.0 -> 3.1](<3.1.html>)
> 
>   * From DSS 2.X: In addition to the following restrictions and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions: see [2.0 -> 2.1](<2.1.html>) [2.1 -> 2.2](<2.2.html>) [2.2 -> 2.3](<2.3.html>) [2.3 -> 3.0](<3.0.html>) and [3.0 -> 3.1](<3.1.html>)
> 
>   * Migration from DSS 1.X is not supported. You must first upgrade to 2.0. See [DSS 2.0 Relase notes](<2.0.html>)
> 
> 


### How to upgrade

It is strongly recommended that you perform a full backup of your Data Science Studio data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>).

Pay attention to the warnings described in Limitations and warnings.

### Limitations and warnings

DSS 4.0 is a major release, which changes some underlying workings of DSS. Automatic migration from previous versions is supported, but there are a few points that need manual attention.

#### HiveServer2

In Hadoop settings, previous versions of DSS didn’t use the HiveServer2 component. DSS now uses and requires HiveServer2 for all interaction with Hive. HiveServer2 is included by default in all Hadoop distributions. See [Hive](<../../hadoop/hive.html>) for more information.

When migrating from previous versions, you need to setup the hostname of your HiveServer2 instance in Administration > Settings > Hadoop.

#### Charts on SQL or Impala

The way charts engine is configured has been redesigned. You now first select the desired engine and DSS will show you errors if the engine is not compatible. While most of the charts that used to run on SQL (or Impala) will remain so, we recommend that you check all charts thata were supposed to run on SQL, and more generally all charts that use “full” sampling on datasets.

#### Permissions

The permissions system has been overhauled and new permission definitions have been introduced. DSS automatically migrates permissions to the new system. We recommend that you check all permissions, both for users and API keys.

#### Dashboard

The new dashboard uses a new layout system, with a responsive grid instead of a fixed-size one. You might need to tweak the layout of your existing dashboards.

#### R

After upgrading to DSS 4, you’ll need to re-run `./bin/dssadmin install-R-integration` for R to work properly.

#### Webapps

Since the addition of the new dashboard, [Webapps](<../../webapps/index.html>) have been moved to their own section in the UI. You’ll find the usual webapp editor in the “Notebooks” section of the project (“Web Apps” subtab)

For webapps that have a Python backend, make sure that the python backend file does not contain [encoding magic comment](<https://www.python.org/dev/peps/pep-0263/>), such as:
    
    
    # -*- coding: <encoding name> -*-
    

or:
    
    
    # coding=utf-8
    

The old deprecated “/datasets/getcontent” API used by webapps prior to DSS 1.0 has been removed. Very old webapps still using `dataiku_load_dataset()` or `dataiku_dataset_object` need to be migrated to new Webapps API.

#### Other

  * Models trained with prior versions of DSS must be retrained when upgrading to 4.0 (usual limitations on retraining models and regenerating API node packages - see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)). This includes models deployed to the flow (re-run the training recipe), models in analysis (retrain them before deploying) and API package models (retrain the flow saved model and build a new package)

  * After installation of the new version, R setup must be replayed

  * We now recommend using mainly personal API keys for external applications controlling DSS, rather than project or global keys. Some operations, like creating datasets or recipes, are not always possible using non-personal API keys.




### External libraries upgrades

Several external libraries bundled with DSS have been bumped to major revisions. Some of these libraries include some _backwards-incompatible_ changes. You might need to upgrade your code.

Notable upgrades:

  * scikit-learn 0.17 -> 0.18

  * matplotlib 1.5 -> 2.0




As usual, remember that you should not change the version of Python libraries bundled with DSS.

## Version 4.0.9 - October, 3rd 2017

### Datasets

  * **New feature** : ElasticSearch: Add SSL support

  * Fix charts on ElasticSearch dataset




### Recipes

  * Fix ‘contains’ and ‘startsWith’ operators if the expression has special characters in it.




### Migrations

  * Fix migrations if there is a space in the java path




### Machine Learning

  * Fix usage of “Class rebalanced” sampling with “Explicit extract from the dataset” mode




### Misc

  * Small fixes in scenario API

  * **New feature** : Add support for Debian 9

  * SAML SSO: allow unsigned assertions in the IdP response if the response itself is signed

  * Fix dependencies installation on Red Hat 6

  * Fix download charts on Chrome >= 60




## Version 4.0.8 - September, 6th 2017

### Tutorials

  * Brand new “starter” tutorials (Basics, Lab & Flow, Machine Learning)

  * New tutorials on automation, deployment and SQL




### Hadoop & Spark

  * Add support for Spark 2.2

  * Add support for Cloudera CDH 5.12




### Flow

  * You can now specify multiple ranges of dates for partitions in the “Build” dialog




### Datasets

  * ElasticSearch: Fix counting of shards in case index has less shards than cluster

  * ElasticSearch: add warning if index/type not found, or if some documents were rejected




### Misc

  * Security: Disable Jupyter terminals in Multi-User security mode as they are not impersonated

  * Fix “Project Activity” page that could fail to display due to timezone issues

  * Make sure the Python notebook cannot be disrupted by pre-installed Jupyter on the machine




## Version 4.0.7 - August, 24th 2017

### Data preparation

  * The Data preparation UI will now warn when trying to use a column that does not exist in a preparation step.




### Datasets

  * Oracle: Fixed issue with the Oracle “undetermined” number type returned when doing “CASE WHEN”

  * S3: Fixed clearing of single-file datasets

  * Internal stats: fixed the “scenarios runs” view while a scenario is running




### Machine Learning

  * Fixed Least Absolute Deviation and Huber loss functions for GBT regression




### Hadoop/Spark

  * Make custom variables usable in Scala recipes used in a Spark pipeline




### Misc

  * Fixed possible crash when aborting SQL queries from a notebook

  * Fixed ability to tune log rotation settings

  * Fixed erratic display of Flow on Firefox 55

  * Fixed the “Clean internal databases” macro

  * Improved Java GC behavior under certain kinds of memory pressure

  * Added missing system dependency for installing Sparklyr support




## Version 4.0.6 - July, 19th 2017

DSS 4.0.6 contains bugfixes. For the details of what’s new in 4.0, see below.

### Data preparation

  * Added new “coalesce()” function to formula language




### Datasets

  * Fixed error in some specific cases of using GCS connector

  * Fixed possible job failure when building large number of partitions on a HDFS dataset




### Machine learning

  * Improved display of “count vectorization” and “TF/IDF vectorization” in decision trees




### Recipes

  * Fixed possible error in scoring recipe with large schemas

  * Fixed various issues with capturing of “NULL” in split recipe




### Dashboards

  * Added “download” button to charts insight view




### Security

  * Fixed a few wrong comments in multi-user-security setup

  * Fixed some edge cases with SPNEGO authentication




### Migration

  * Fixed potential migration bug where migration from version 3.1.3 and below could fail in some specific use cases of metrics usage with “Integer out of range” errors.

  * Fixed potential migration bug where migration could fail with “timeNanos out of range” error.




## Version 4.0.5 - June, 22nd 2017

DSS 4.0.5 contains both bugfixes and major new features. For the details of what’s new in 4.0, see below.

### Hadoop and Spark

  * **New feature** : HDFS connections can now reference any kind of HDFS URL, not only paths on the default FS. [This makes it possible to read s3://, s3a://, wasb://, adl:// and others through HDFS connections](<../../hadoop/hadoop-fs-connections.html>). Credentials are passed through additional per-connection properties (_Limitation: using S3 as a HDFS filesystem is not supported on MapR_)

  * **New feature** : Add support for LDAP authentication and SSL on Impala, add more options for custom Impala URLs

  * Fix reading S3 datasets in Spark in multi-user-security mode

  * Make sure that we properly use the S3 fast path, even in single-user-security mode

  * Fixed support for s3a:// URLs on EMR 5.5

  * Add support for custom HiveServer2 URLs

  * Fixed creation of Hive tables when complex types have nested names with special characters

  * Added warnings when trying to use invalid Hive database and table names

  * Don’t print useless warnings when reading Spark-generated Parquet files

  * Fixed Spark pipelines on EMR 5.4 and above

  * Fixed Spark pipelines with partitioned datasets in Spark 2.X

  * Fixed reading of foreign datasets in function mode in Scala recipe with Spark 2.X

  * Fixed rare issue with reading datasets in PySpark

  * Added ability to set default value for “write datasets using Impala” in Impala and visual recipes

  * Impala: LEADDIFF / LAGDIFF on an “int” column now properly generate a “bigint” column

  * Fixed processing of multi-dimension partitioned datasets with Spark




### Machine Learning

  * **New feature** : Isolation Forest, for anomaly detection

  * **New feature** : Feature selection (filter, LASSO-based or tree-based) and reduction (PCA)

  * Updated H2O version, add support for H2O on Spark 2.1

  * Add support for H2O on CDH 5.9 and above

  * Clustering: fix wrong results when “Drop rows” is used for handling missing values

  * Fixed non-optimized scoring with multiple feature interactions on the same columns

  * Fixed optimized scoring with numerical derivatives

  * Fixed optimized scoring of partitioned datasets (was scoring the whole dataset)

  * Fixed SQL scoring with multiclass and impact coding

  * Fixed categorical feature interactions with non-ASCII column names

  * Properly disallow SQL scoring if there is a preparation script

  * API node: fixed enrichment with Oracle and SQLServer

  * Fixed “max features” selection in Random Forests and Extra Trees algorithms

  * Properly display actual number of trained estimators in XGBoost in case of early stopping

  * Preprocessed feature names are now displayed

  * Properly warn when export to Python notebook is not supported

  * Fix Python notebook export of XGBoost, SVM, SGD, and custom models

  * Fixed icon of the evaluation recipe

  * Fixed UI issue on tol and validation params for ANN algorithm




### Datasets

  * **New feature** : Add support for authentication on Elasticsearch datasets

  * **New feature** : Beta support for Exasol

  * ElasticSearch: fixed failure with uppercase type names and type names with special characters

  * Fixed silent failures when uploading files that are rejected by a proxy

  * Dont’ try to use Impala for metrics when a dataset has complex types (unsupported by Impala)

  * Fixed percentage display issues in analyze

  * Show computation errors when refreshing count of records from the dataset’s right contextual bar

  * Teradata: Fixed reading of SQL “DATE” fields

  * Let user choose whether SQL dates should be parsed as DSS dates

  * Fixed writing datasets with Excel format

  * Fixed handling of multiple “post-write” statements, when run from SQL recipes




### Recipes

  * **New feature** : Standard deviation in grouping and window recipes

  * Add automatic translation to SQL of “and” and “or” in filter formulas

  * Grouping and Window recipes: Fix postfilter with output column name overrides

  * Invalid computed columns will not break engine selection anymore

  * Fixed copy of SparkSQL recipes

  * Fixed bad handling of NULL values in Filter and Split recipes in SQL mode (NULL values were not taken into account in “other values”)

  * Join recipe: don’t lose complex type definition on retrieved columns

  * Fixed refresh of “OK / NOK” indicator on pre and post filters on several recipes

  * Proper warning in join recipe when trying to join on a non-existing column

  * Sync from S3 to Redshift: add ability to use IAM role instead of explicit credentials

  * Fixed postfilter on window recipe on DSS engine

  * Don’t fail if invalid engines are added to the list of preferred engines

  * Make sure that the default query in Impala recipes is always working out of the box, even with multiple databases

  * Impala recipe: show substitution variables even if query fails

  * SQL, Hive, Impala recipes: add variables for “database/schema”

  * Don’t use forbidden engines, even when there are only forbidden engines

  * Fixed partitioning in split recipe with SQL engine

  * Fixed UI issues in stack recipe when the same dataset is used several times

  * Fixed Hive->Impala recipe conversion

  * Fixed UI issues in “Custom Python” dependencies




### Automation

  * Fix Python API to send messages from custom Python scenarios/steps

  * Fixed code editor sizing on custom Python and SQL steps

  * Add minute resolution on time-based triggers

  * A broken scenario (because its run-as user does not exist) does not impact other scenarios anymore




### Notebooks

  * Added support for project variables in Scala notebooks




### Data preparation

  * Show more matching column names in typeahead suggestions




### Security

  * **New feature** : Added support for SAML SSO

  * **New feature** : Added support for SPNEGO SSO

  * **New feature** : Added ability to have expiring sessions

  * **New feature** : Added ability to enforce a single session per user

  * **New feature** : Added ability to restrict visibility of users and groups (to only the users in your groups)

  * **New feature** : Added ability to customize X-Frame-Options, Content-Security-Policy, X-XSS-Protection and X-Content-Type-Options headers

  * Fixed: only moderators may save non-owned dashboards

  * Fixed LDAP groups that were not available in connections security screen

  * Multi-user-security: fixed the case when UNIX user name is not the same as the Hadoop short user name

  * Multi-user-security: fixed Pyspark notebooks in some combination of Hadoop umasks and group memberships




### Misc

  * Performance improvements in internal databases

  * Homepage listing does not impact other users’ performance anymore

  * Add ability to select a subset of columns in Python’s `iter_rows` method

  * Various UI fixes

  * Added check for Pandas version, to warn against unsupported Pandas upgrades

  * install-R-integration: added ability to override CRAN mirror

  * Fixed possible “URI too long” issue in dataset “Share” window

  * Fixed possible “URI too long” issue in plugins with “fully custom forms”

  * Check for SELinux when installing

  * Add ability to clear internal databases with a time limit

  * Webapps: add ability to disable the Python backend

  * Fixed very rare possibility of data loss when the filesystem is having issues

  * Fixed wrongfully mandatory fields in SQL connection screens

  * Fixed possible nginx crash when webapps failed to initialize

  * Fixed default todo list on new projects




## Version 4.0.4 - April, 27th 2017

DSS 4.0.4 is a bugfix release. For the details of what’s new in 4.0, see below.

### Datasets

  * **New** : Add compatibility with ElasticSearch 5.2 and 5.3

  * **New** : Add support for reading DATE columns in ORC files

  * **New** : BETA support for Snowflake database

  * **New** : Add support for Amazon S3 Server-Side Encryption

  * Fix failure in Azure Blob connector

  * Fix SQL splitting in PostgreSQL that could cause “No match found” error in SQL recipes

  * SQL datasets: Fix quoting of partitioning column names




### Hadoop and Spark

  * **New** : Add support for MapR 5.2 with MEP 3.0

  * **New** : Add support for HDP 2.6

  * **New** : Add support for CDH 5.11

  * Fix a bug in direct Spark-S3 interface when using EMRFS mode with implicit credentials

  * Fix null/empty mismatch in non-HDFS datasets on Spark




### Machine learning

  * **New** : Ability to see either rescaled or raw coefficients in regression

  * **New** : Add support for Vertica 8.0 AdvancedAnalytics

  * UI improvements in Lasso path analysis

  * Fix failures in grid search on regression models




### Automation

  * **New** : Add a new view of all triggers across instance

  * Performance improvements on instance scenario views

  * Fix sort of bundles list

  * Show conflicts indicator on scenarios




### Flow and recipes

  * Fix Spark pipelines when Pyspark or SparkR recipes are present (not pipelineable)

  * Truncate too long pipeline names that can make Spark pipeline jobs fail

  * Fix naming issues in sync recipe that caused issues when an input column was named “count”

  * Fix SQL recipe failure on some databases if the query ends with a comment




### Data preparation

  * Fixed ability to insert a custom projection system definition in coordinate system processor

  * Fix broken handling of “Others” columns in Pivot processor




### Notebooks and webapps

  * Fixed bad redirect after creation of a webapp with a _ in the name

  * Fixed custom JDBC notebooks in Impala mode (not recommended)




### Dashboard

  * Fix error when reading information of an insight whose source was deleted

  * Fix permission issue on charts for explorers

  * Fix mismatches when copying a slide




### Misc

  * **New** : Add support for Amazon Linux 2017.03 and Ubuntu 17.04

  * Small UI fixes

  * Add ability to restore macro settings to default

  * Performance improvements on data catalog

  * More ability to tune data catalog indexing

  * Fix too strict permission check for managing exposed elements

  * Fix error on home page when projects end with _

  * Various performance improvements and observability

  * Fix load of Intercom widget on very slow networks

  * Fix dataiku.Dataset.get_config() Python API




## Version 4.0.3 - March, 27th 2017

DSS 4.0.3 is a bugfix release with several new features. For the details of what’s new in 4.0, see below.

### Machine learning

  * **New feature** : Lasso-LARS regression for automatic selection of a given number of features in a linear model

  * **New feature** : Ability to generate new “interaction” features by combining two existing features.

  * **New feature** : Partial dependency plots are now available for Random Forest and Decision Tree models (regression only)

  * Better scoring performance for models with large number of columns

  * Fix scikit-learn multiclass logistic regression in multinomial mode

  * Fix scoring of probability-aware custom models

  * Fix support of unlimited-depth tree models




### Datasets

  * Fix: don’t fail when the explore sampling had partitions selected and dataset was unpartitioned

  * Azure: fix support for files with double extension (like .csv.gz)

  * Azure: fix prepare recipe when target is another filesystem

  * Fix support for Tableau export plugin

  * Always allow the “files in folder” dataset, regardless of license

  * Fix live charts on Vertica and SQL server

  * Fix computation of statistics on whole data when there are empties

  * Allow non-standard ports for SSH connections




### Webapps

  * Fix ability to edit API key settings




### Recipes

  * Split recipe: Fix ability to add a new dataset from the recipe settings

  * Group and Window recipes: fix edition of aggregations

  * Join recipe: fix ability to replace inputs

  * Prepare recipe: fix display of Hadoop options for MapReduce engine




### Data preparation

  * Fix JSONPath extractor in “single result” mode




### Automation

  * Fix SQL probes executed on Hive

  * Strong performance improvement on saving metric values with very large DSS installs

  * Fix dsscli on the automation node

  * Fix “Run notebook” step in scenarios

  * Fix “add checks” link

  * Don’t lock DSS while computing metrics from the public API

  * Fix SQL probe plugins




### Administration and security

  * **New feature** : public API to list and unload Jupyter notebooks

  * **New feature** : Project leads can now allow arbitrary users to access the dashboards

  * Project administrators may now export datasets without explicit permission

  * Don’t fail if empty values are added for preferred and forbidden engines

  * Fix scenario link in background tasks monitoring

  * Show task owner in background tasks monitoring

  * Fix saving of Hive execution config keys

  * Fix display of connected users

  * Prefer using Hive or Impala for counting number of records




### Performance

These fixes mostly concern responsiveness of DSS UI for very large installations (in number of users, projects, datasets, …)

  * Strong performance improvements for home page display

  * Performance improvements for flow page, datasets list, dataset page, recipe creation, analysis page

  * Improved performance for Hive metastore synchronization, especially for large Hive databases




### Misc

  * Performance improvements for metastore synchronization

  * Make more things configurable for Data Catalog index

  * Fix dashboard save failure

  * Force Python not to try to connect to Internet during installation

  * Fix memory leak in scenarios that could lead to DSS crash after several days when a large number of scenarios are active

  * Improve capabilities of “Search” in objects lists

  * Fix typos and small UI issues

  * Fix possible hang while listing Jupyter notebooks




## Version 4.0.2 - March, 1st 2017

DSS 4.0.2 is a bugfix release with minor new features. For the details of what’s new in 4.0, see below.

### Data preparation

  * **New feature** : it is now possible to re-edit date parsers with Smart date.

  * Smart date: new formats are detected and guessed

  * Smart date: ignore some very unlikely formats

  * Smart date: UI improvements

  * Fixed invalid reset of filters

  * Fixed display of column popup on prepare recipe

  * Sort on non-existing column does not create empty columns anymore




### Datasets

  * Fix miscounting of rows for Parquet and ORC file formats (could lead to smaller than expected samples)

  * Add mean and stddev to full-data-analysis of date columns

  * Show count and percentage of top values in full-data-analysis (numerical tab)

  * Fixed drop down to select meaning in column view

  * Various UI improvements on columns view

  * Performance improvements for metrics computation with many partitions

  * Make it possible to select port on FTP connections




### Machine learning

  * Partial dependencies: fix display when feature name contains ‘:’

  * Partial dependencies: Add a text filter for features

  * Fixed number of estimators for Extra Trees

  * Add missing “partitions selection” menu in Explicit extract policies

  * Fixed computation of cluster size on MLLib




### Dashboards

  * Add ability to export dataset in “dataset table” insight




### Recipes

  * Add ability to change Inputs / Outputs on Sync recipe

  * Fix display of pre-filters in join recipe

  * Bugfix on join recipe creation

  * Fix partition dependencies tester with multiple partitioned datasets

  * Fixed selection of grouping keys in grouping recipe




### Hadoop & Spark

  * Warn when trying to use Spark engines on HDFS datasets that are not compatible with Spark fast path

  * Faster Hive metastore synchronization for partitioned datasets with lots of partitions

  * Fix pipelining of split recipes (not pipelineable)

  * Added ability to customize HiveServer2 URL




### Administration & Monitoring

  * **New feature** : Add a view on scenario runs in the internal stats dataset

  * Fix possible hang when reporting to a non-responding Graphite server

  * Don’t let users create connections with no name




### Setup and migration

  * Migration from 3.X: Don’t force DSS engine when output is Redshift

  * Fixed ability to select LDAP as authentication source




### API

  * **New feature** : Ability to set CORS headers on public API.

  * Fixed datasets set_metadata call

  * Fixed recipe get_recipe_and_payload in Python wrapper




### Misc

  * **New feature** : Project consistency check is now available as a scenario step

  * **New feature** : Add ability to export macros results (to CSV, Excel, dataset, …)

  * New design for “Mass actions” button

  * Fix “last modified” date on analysis list

  * Work-around a Websocket deadlock in Jetty (<https://github.com/eclipse/jetty.project/issues/272>) that could hang DSS

  * Various performance improvements




## Version 4.0.1 - February, 16th 2017

DSS 4.0.1 is a bugfix release. For the details of what’s new in 4.0, see below.

### Setup

  * Fixed migration from 3.X when recipe names or dataset names contain accented characters

  * Fixed migration of 3.X instances where no action had been performed

  * Fixed incorrect exit status for failed migrations

  * Added more information to diagnosis reports




### Datasets

  * Fixed BigQuery datasets




### Explore

  * Added ability to do analysis on full data for date types




### R

  * Implemented append mode in R recipes and notebooks




### Hadoop

  * Fixed writing of map and object fields to Parquet files

  * Fixed Hive icon in Flow




### Spark

  * Implement filtering of datasets in Spark (Python, R, Scala) API

  * Fixed ability to use foreign datasets in Spark recipes




### UI

  * Added “last modified” information to visual analysis

  * Better warnings when trying to use invalid dataset names

  * No more messages when building charts when you only have read access on a project

  * Fixed creation of recipes in recipe copy




### Dashboards

  * Fixed too strict permissions in Jupyter insights

  * Fixed too strict permissions in scenario run insights




### Misc

  * Performance enhancements in data catalog

  * Fixed notifications on project edition

  * Verify foreign dataset permissions when building jobs and training models

  * Better error reporting for empty jobs

  * Improve code snippets here and there

  * Better audit logging for job events

  * Fix download of files bigger than 2GB from folders




## Version 4.0.0 - February, 13th 2017

DSS 4.0.0 is a major upgrade to DSS with a lot of new features and major architectural changes. For a summary of the major new features, see: <https://www.dataiku.com/learn/whatsnew>

### New features

#### New dashboard

DSS 4 features a completely redesigned dashboard with far expanded capabilities.

  * The dashboard now uses a 12-cells responsive grid and a new layout engine that makes it much easier to move content around. The dashboard UX has been strongly overhauled.

  * You can now have multiple dashboard per project. Dashboard can either be personal or public. Each dashboard can have multiple slides. The dashboard can be put in fullscreen mode

  * Dashboard-only users, who don’t have access to the full project content can now create their own dashboards. A new authorization system lets data analysts choose what part of the project are available to dashboard-only users.

  * A new publication system

  * Many features have been added on published charts (show/hide axis, tooltips, legends, filters, ability for readers to set their own filters, …)

  * Many features have been added on published datasets (show/hide headers, select columns, show colorization, ability for readers to set their own filters, …)

  * Jupyter notebooks published on the dashboard can now have multiple versions, even concurrently.

  * New kind of publishable insights have been added: report of a saved model, DSS metrics, project activity info, object activity feed.

  * You can now add rich text, images, URLs and web pages directly on the dashboard.




For more information, see [Dashboards](<../../dashboards/index.html>).

#### Multi-user security

The regular behavior of DSS is to run as a single UNIX account on its host machine. When a DSS end-user executes a code recipe, it runs as this single UNIX user. Similarly, when a DSS end-user executes an Hadoop recipe or notebook, it runs on the cluster as the Hadoop user of the DSS server.

DSS now supports an alternate mode of deployment, called _multi-user security_. In this mode, DSS will _impersonate_ the end-user and run all user-controlled code under its own identity.

For more information, see [User Isolation](<../../user-isolation/index.html>)

#### Spark 2

DSS is now compatible with Spark 2.0. In addition, an experimental support for Spark 2.1 is provided (preview only).

For more information, see [DSS and Spark](<../../spark/index.html>)

#### Spark pipelines

When several consecutive steps in a DSS Flow (including with branches or splits) use the Spark engine, DSS now has the ability to automatically merge all of these recipes and run them as a single Spark job. This strongly boosts performance by avoiding needless writes and reads of intermediate datasets, and also alleviates Spark startup overheads.

The behavior of intermediate datasets can be configured by the user: write them or not (only the final datasets are written in that case).

For more information, see [Spark pipelines](<../../spark/pipelines.html>)

#### Sparklyr

DSS now supports integration with sparklyr, an alternative API for using Spark from R code. The sparklyr integration cohabits with the SparkR integration. Both APIs are usable in recipes and notebooks.

For more information, see [Usage of Spark in DSS](<../../spark/usage.html>)

#### Interactive hierarchical clustering

DSS now features a hierarchical clustering model. It has the unique feature of being “interactive”: rather than setting a fixed number of clusters, you can edit the hierarchy of clusters after training.

For example, if DSS has chosen to keep two clusters, but by studying them, you notice that the difference is not relevant to your problem, you can merge them. Oppositely, if a cluster contains two subpopulations that have relevant differences, you can split them to make deeper clusters.

#### Quick models

DSS now includes a set of pre-configured “model templates”. When you create a new model, you can now choose what kind of models you want:

  * Very explainable models (based on simple decision trees or linear formulas)

  * Most performant models, with highly cross-validated algorithms and wide search for optimal parameters

  * Models leading to finding most insights in your datasets (by fitting different kinds of algorithms)




You can still set all settings of all kinds of algorithms, but quick models allow you to get started faster with common business requirements.

#### Distributed and in-database scoring

For most models created in DSS visual machine learning (with Python or MLLib backends), you can now run scoring recipes:

  * In distributed mode, on Spark

  * In SQL databases, without data movement




This new feature strongly improves scalability of machine learning model application.

#### Notifications & Integrations

The notifications system in DSS has been greatly overhauled to adapt better to larger teams.

  * You can now “watch” every kind of object in DSS (dataset, recipe, analysis, whole project, …) and get notified when updates are available (someone modified the recipe, a new comment has been posted, …). In your profile, you can edit which objects you watch.

  * A brand new “personal” drawer (click on your user image) which shows all of your notifications, your profile, …

  * In addition to receiving your notifications in your personal drawer, each user can also choose to receive “offline” summaries (what happened on your watched objects while you were away from DSS) or daily digests (each morning, get a summary of what happened on your watched objects).

  * DSS can push notifications to third party systems. Slack and Hipchat integrations are provided and more will follow. You can also connect DSS with Github so that commit messages in DSS can close Github issues.

  * A new “activity” drawer shows all your running activities (jobs, scenarios, notebooks, webapp backends, macros, and other long tasks).




#### New prebuilt notebooks

DSS now comes with 4 new prebuilt notebooks for analyzing datasets:

  * Distribution analysis and statistical tests on a single numerical population

  * Distribution analysis and statistical tests on multiple population groups

  * High-dimensionality data visualization using t-SNE

  * Topics modeling using NMF and LDA




#### Sort in explore

The explore view (also data preparation view in analysis and prepare recipe) can now be sorted, according to a single or multiple criterions.

This sort is only visual and on the sample. The original data is not sorted.

#### Analyze on whole dataset in explore

The “Analyze” view in Explore can now be based on the whole dataset (in addition to the exploration sample). This is available on all dataset types and will automatically run in database, Hive or Impala depending on the type of dataset and available engines. See [Analyze](<../../explore/analyze.html>) for more information.

#### New data sources

DSS can now connect to:

  * Google Cloud Storage (read and write)

  * Azure Blob Storage (read and write)




#### Audit trail

DSS now includes a full applicative audit trail of all activities performed by all users. With appropriate configuration, this audit trail is non repudiable: even if a user manages to compromise DSS, traces leading up to the compromise will not be alterable.

#### Macros

Macros are predefined actions that allow you to automate a variety of tasks, like:

  * Maintenance and diagnostic tasks

  * Specific connectivity tasks for import of data

  * Generation of various reports, either about your data or DSS




Macros can either run either manually or from a scenario. Some macros are provided as part of DSS, and they can also be in a plugin or developed by you.

For example, the following macros are provided as part of DSS:

  * Generate an audit report of which connections are used

  * List and mass-delete datasets by tag filters

  * Clear internal DSS databases

  * Clear old DSS job logs




More information is available at [DSS Macros](<../../operations/macros.html>)

#### Sample and prepare memory limits

The DSS administrator can now set maximum memory size for the design samples and the memory size occupied by memory representation of intermediate steps in a visual preparation recipe or analysis. This strongly incrases the stability and resilience of DSS, especially when users try to create huge design samples.

Limits are configured in Administration > Settings > Limits

### Other notable enhancements

#### Machine learning

  * A new faster scoring engine has been implemented. Scoring recipes and API node will be much faster. They can also run on Spark or in-database.

  * The API node can now run models trained with Spark MLLib

  * A new “evaluation” recipe allows you to evaluate the performance of a model (getting all performance metrics) on any labeled dataset, independently from the training process.

  * New algorithm: Artificial Neural networks (multi-layer perceptron) for Python backend

  * New algorithm: KNN (K-Nearest-Neightbors) for Python backend

  * New algorithm: Extra Trees for Python backend

  * Impact coding preprocessing is now available for MLLib models

  * Clustering result screens: you can now edit cluster details from all screens

  * Clustering result screens: the heatmap can now display categorical variables, provides more sorting options, and provides multiple export formats for further analysis of significant clustering variables

  * The random seed can now be fixed for clustering models

  * Many more parameters can be grid-searched

  * Custom models without probabilites are now supported

  * Improved snippet auto description of models




#### Sampling

New sampling modes have been introduced:

  * Exact “random count of records”: get exactly the count you asked for

  * “Last records”

  * Stratified sampling versus a target column




Note that some of these sampling methods are only available for explore, analyze and prepare recipes, not in the sampling recipe.

In addition:

  * “Random count of records” sampling is now up to 2 times faster.

  * It is now possible to define a filter within the sampling.

  * It is now possible to use “last N partitions” as a partition selection method in sampling




For more information, see:

  * [Sampling in explore and visual data prep](<../../explore/sampling.html>)

  * [Sampling in other parts of DSS](<../../sampling/index.html>)




#### Charts

  * Charts engine selection has been overhauled to be more predictible: you now first choose your charts engine, and then can choose compatible sampling and charts.

  * It is now possible to set the line width for line charts




#### Coding recipes

  * Advanced options and statements splitting capabilities have been added to the SQL Query recipe. See [SQL recipes](<../../code_recipes/sql.html>) for more information. This makes it easier to do advanced things like stored procedures or CTEs in SQL recipes.

  * SQL script recipes can now automatically infer output schema, like SQL query recipes. See [SQL recipes](<../../code_recipes/sql.html>) for more information

  * SparkSQL recipes can now use the global Hive metastore, alternatively to using only the local datasets. See [SparkSQL recipes](<../../code_recipes/sparksql.html>) for more information

  * You can now disable validation of code prior to running recipes. This is useful for some kinds of recipes where validation can be very slow.




#### Visual recipes

  * The Sync, Filter/Sample and Split recipes can now run on Spark, Hive, SQL and Impala

  * The window recipe can now work on any kind of dataset, even if you don’t have Spark.

  * Administrators can now set preferred engines, blacklisted engines

  * The Join recipe can now be configured to automatically select all columns of some datasets, even when their schema changes.

  * The join and stack recipes can now automatically downcast columns to match types




#### Security

  * In addition to multi-user security and audit-trail, the permissions system has been overhauled and new permission definitions have been introduced. You can now define thinner-grained group permissions at the project level. See [Main project permissions](<../../security/permissions.html>).

  * More options are available for sharing items between projects, and authorizing objects on dashboards. See [Shared objects](<../../security/shared-objects.html>).

  * User profiles can now be set directly from LDAP groups.

  * The details of connections can now be made available to some groups, who can then use them in recipes

  * Connection passwords are now encrypted on disk using a reversible encryption scheme




#### Datasets

  * Administrator can now set preferred connections and file formats when creating new managed datasets.

  * It is now possible to import SQL tables as SQL datasets from the DSS UI, without being an administrator. Go to New dataset > Import from connection. This is also possible for Hive tables.

  * When a HDFS dataset has been imported from an existing Hive table, it is possible to “update” the definition of the dataset from the associated Hive table definition in the Hive metastore

  * The filtering infrastructure (used in filter recipe, for filtering in sample, in APIs, …) now more directly translates user-defined filters to SQL. This provides more efficient filtering in SQL and less timezone-related issues.

  * Support for ElasticSearch 5 has been added

  * It is now possible to define a dataset based on the files in a DSS managed folder.

  * The “internal stats” dataset now includes ability to view jobs information and build informatino

  * Teradata connections can now be put in “autocommit” mode, which makes it much easier to write DDL statements, use stored procedures, write stored procedures or use third-party plugins.

  * In-database charts are now available for Teradata.

  * Teradata datasets will more often avoid going over the Teradata max row size limitations

  * Sorting, searching, and mass actions have been added to the schema editor




#### Library editor and per project library

You can now write / add your own Python modules or packages in per-project library paths in addition to the global “lib/python” one. In addition, you can edit both the global and per-project “lib/python” folders directly from the DSS UI.

You can also edit a new “lib/R” folder, which can be used to import R source files.

#### Hadoop & Spark

  * It is now possible to import Hive tables as HDFS datasets from the DSS UI, without being an administrator. Go to New dataset > Import from connection.

  * The Spark-Scala recipe now features a new “function” mode which allows the recipe to be part of a Spark pipeline

  * You can now run SparkSQL recipes against the global Hive metastore. Note that this disables automatic validation.

  * You can now manage multiple named Hive configurations, used to pass additional Hive parameters on recipes and notebooks




#### Data preparation

  * The “Round” processor can now round to a fixed number of decimal places

  * The “Pivot” processor can now keep repeated values

  * New meaning: “Currency amount” (i.e. a currency symbol and a numeric amount), with an associated processor to split currency and amount. This is particularly useful in conjunction with the existing currency converter processor

  * Holidays database have been updated and improved

  * User agents parsing has been updated and improved




#### Flow

  * The “Consistency check” Flow tool has been greatly enhanced. It can now check many more kinds of recipes, and perform more structural checks

  * A new “engines” flow view let you see easily on which engine (DSS, SQL, Hadoop, Hive, Spark, …) each of your recipes run.

  * You can now copy recipes

  * You can now change the input / output datasets of all recipes




#### Version control

DSS now features the ability to rollback configuration changes from the UI. We advise great care when rolling back changes.

You can also manage “Git remotes” directly from the DSS UI, including pushing to remotes. The public API features a new method to push to remotes.

#### API

In addition to the previously existing project-specific and global API keys, DSS now features “personal” API keys. Personal API keys have the same rights has their owner. In some setups, creating datasets and recipes can only be done using Admin or Personal API keys.

The internal API (`dataiku` package) can now automatically call the public API. To obtain an API client, use `dataiku.api_client()`.

The public API now includes methods for:

  * Getting and setting general DSS settings

  * Managing installed plugins

  * Monitoring and aborting “futures” (long-running tasks)

  * Getting metrics




For more information, see [Public REST API](<../../publicapi/index.html>)

#### Plugins

Plugins can provide Python modules that can be imported into Python code with a dedicated API.

#### Webapps

Webapps now live as new top-level objects, besides code notebooks.

Python backends have been strongly overhauled with:

  * Ability to start automatically with DSS

  * Impersonation ability

  * Automatic restart in case of crash

  * Centralized monitoring screen (Administration > Monitoring > Webapp backends)




#### Monitoring

Administrators now have better overviews of all what’s running in a DSS instance, with more information to relate to processes (pid, Jupyter kernel id, …)

#### Installation and setup

  * Added support for Ubuntu 16.10

  * Removed support for Ubuntu 12.04




#### Misc

  * New options are available for making datasets “relocatable”, easing copying and reimporting projects, while avoiding conflicts between projects. See [Making relocatable managed datasets](<../../connecting/relocation.html>).

  * Mass actions are now available in many more locations in DSS (objects list, features screen, prepare column view, schema editor, …)

  * A lot of general performance improvements, especially for large number of users

  * Project export/import will now preserve timelines

  * Added rotation of nginx access logs




### Notable bug fixes

#### Performance and stability

  * DSS could become unresponsive while deleting a dataset or a project if the remote data source was unreachable, or the Hive metastore server hanged. This has been fixed.

  * Browsing HDFS connections was very slow and could make DSS unresponsive. This has been fixed.

  * Performance of various UI parts with wide datasets (1000+ columns) has been strongly improved

  * With large number of users, notifications system could strongly slow down DSS. This has been fixed.

  * DSS could become unresponsive while testing a dataset if the remote data source was not answering. This has been fixed.

  * Fixed excessive logging in various parts of DSS




#### Datasets

  * It is now possible to set the MongoDB port in the UI

  * Re-added ability to append on HDFS datasets (depending on the recipe)

  * Don’t fail when a partitioned SQL dataset contains null values in partitioning column




#### Data preparation

  * Removing a column used for coloring output table will not cause an error anymore

  * Currency converter does not throw errors in “fixed currency” mode

  * Added val() method to handle columns with dots in formulas

  * Fixed various caching issues that led to not good enough performance in some cases




#### Recipes

  * Creating a visual recipe from a partitioned dataset will now properly respect the “Non partitioned” setting (when creating the modal)

  * Changing name of partition columns, or partitioning or unpartitionig datasets is now much better handled.

  * Various issues around cases where partitioning columns must or must not be in the schemas have been fixed. This notably fixes redispatching of partitions when writing to a HDFS dataset.

  * Scoring recipe with preparation steps using additional datasets has been fixed

  * Filtering on dates has been fixed for several databases (Oracle, Teradata, …)

  * Join recipe with contains / ignore case has been fixed for Redshift and Impala

  * Fixed “Rename columns” feature in grouping recipe

  * Fixed various issues in sampling recipe

  * Fixed “distinct” pre and post filters in Window recipe on Impala and Hive engines




#### Charts

  * Fixed taking into account of meaning for charts. Setting a meaning in the explore view will now be properly taken into account for charts.

  * Fixed display of hexabgonal binning charts on dashboard tiles

  * Added tooltips on pivot table charts




#### Automation

  * A too long trigger will not cause other scenarios to hang

  * Fixed failures in custom Python step when too much data is returned




#### Hadoop & Spark

  * Using reserved Hive names like “date” as partitioning column name in HDFS datasets will not cause issues anymore




#### Flow

  * Fixed “propagate schema from Flow” on SQL datasets (string length issues)

  * Fixed type mismatch issues (strings instead of int) when propagating schema on some recipes




#### Machine learning

  * It is now possible to rename the “outliers” cluster

  * Fixed text features with MLLib when there are null values in the text column

  * Fixed updating of “Cost matrix” in ML model reports

  * Many fixes around training and scoring with “foreign” datasets (datasets from other projects)




#### API

  * Fixed issues in API around creation and edition of users




#### Misc

  * Deleting a project now properly removes activity / timelines information for it

  * Fixed display of Python backend logs in webapps

---

## [release_notes/old/4.1]

# DSS 4.1 Release notes

## Migration notes

### Migration paths to DSS 4.1

>   * From DSS 4.0: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 3.1: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [3.1 -> 4.0](<4.0.html>)
> 
>   * From DSS 3.0: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying your previous versions. See [3.0 -> 3.1](<3.1.html>) and [3.1 -> 4.0](<4.0.html>)
> 
>   * From DSS 2.X: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions: see [2.0 -> 2.1](<2.1.html>) [2.1 -> 2.2](<2.2.html>) [2.2 -> 2.3](<2.3.html>), [2.3 -> 3.0](<3.0.html>), [3.0 -> 3.1](<3.1.html>) and [3.1 -> 4.0](<4.0.html>)
> 
>   * Migration from DSS 1.X is not supported. You must first upgrade to 2.0. See [DSS 2.0 Relase notes](<2.0.html>)
> 
> 


### How to upgrade

It is strongly recommended that you perform a full backup of your DSS data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>).

Pay attention to the warnings described in Limitations and warnings.

### Limitations and warnings

DSS 4.1 is a major release, which changes some underlying workings of DSS. Automatic migration from previous versions is supported, but there are a few points that need manual attention.

#### SSH datasets

If a SSH dataset had an absolute path, the migrated download recipe may fail to locate files. You will need to adjust the path in the connection versus the path in the dataset.

#### API node

If you had custom pooling configuration, please contact Dataiku Support for update instructions

#### Other

  * Models trained with prior versions of DSS must be retrained when upgrading to 4.1 (usual limitations on retraining models and regenerating API node packages - see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)). This includes models deployed to the flow (re-run the training recipe), models in analysis (retrain them before deploying) and API package models (retrain the flow saved model and build a new package)

  * After installation of the new version, R setup must be replayed

  * We now recommend using mainly personal API keys for external applications controlling DSS, rather than project or global keys. Some operations, like creating datasets or recipes, are not always possible using non-personal API keys.

  * DSS 4.1 is compatible with Anaconda/Miniconda version 4.3.27 or later only. If your existing DSS instance is integrated with Anaconda Python, you should check your current conda version with `conda -V`, and if necessary upgrade your conda installation with `conda update conda`.




### External libraries upgrades

Several external libraries bundled with DSS have been bumped to major revisions. Some of these libraries include some _backwards-incompatible_ changes. You might need to upgrade your code.

Notable upgrades:

  * pandas 0.18 -> 0.20

  * scikit-learn 0.18 -> 0.19




As usual, remember that you should not change the version of Python libraries bundled with DSS. Instead, use [Code environments](<../../code-envs/index.html>)

## Version 4.1.5 - February, 13th 2018

DSS 4.1.5 is a bugfix release.

### Notebooks

  * Fixed notebooks when a python/lib is defined at the project level




### Misc

  * Fixed impersonation failure of YARN jobs in multi-user-security mode with resourcemanager failover




## Version 4.1.4 - February, 8th 2018

DSS 4.1.4 is a bugfix release.

### Datasets

  * Fixed copy action of Vertica dataset

  * Fixed metric computation on MongoDB dataset

  * Fixed build failure on exposed HDFS datasets if target project does not exist in multi-user-security mode




### Web apps

  * Fixed export/import of published webapps created after DSS 4.1




### Recipes

  * Fixed special characters management on ‘contains’ and ‘like’ operators on SQLServer and Oracle

  * Fixed window and group recipe schema overriding when a post filter is defined

  * Fixed split recipe from partitioned filesystem dataset to partitioned SQL dataset

  * Fixed insert table helper on SQL script recipe.




### Machine learning

  * Fixed UI of clustering scoring recipe

  * Custom variable and current project key are now accessible from custom python model

  * Fixed small differences between mllib and scikit-learn metrics




### Notebooks

  * Fixed PySpark notebooks on YARN using virtual environments

  * Fixed usage of project level lib/python in notebooks in multi-user-security mode




### Misc

  * **New feature** : Support conda 4.4

  * **New feature** : Added ability to disable exports. See [Advanced security options](<../../security/advanced-options.html>)

  * Macro admin parameters are now settable in the scenario UI

  * Fixed possible issue with loading webapp insights

  * Fixed custom python trigger in multi-users-securit mode

  * Fixed display issue when RMarkdown reports are slow to generate

  * Fixed ‘add to scenario’ action of managed folders

  * Fixed folder scroll on large managed folders




## Version 4.1.3 - January, 8th 2018

DSS 4.1.3 is a bugfix release.

### Datasets

  * Fixed SQL Query dataset on Teradata when the query contains unaliased expressions

  * Fixed GCS and Azure Blob Storage datasets when a bucket is forced in connection

  * Fixed dates reading bug in Parquet, whereby reading dates in year 0 would cause subsequent dates to appear as negative

  * Fixed metrics on Twitter dataset




### Machine Learning

  * Fixed failure of Python ensembles, that could not be used for scoring before having retrained them

  * Fixed training and evaluation failure of Python ensembles when target contained missing values

  * Fixed incorrect “raw” coefficients in linear models

  * Fixed wrongful binary classification metrics in evaluation recipe

  * Fixed failure in feature reduction by correlation to target when there are categorical variables with imputation of missing values

  * Fixed failure writing date columns in clustering recipe

  * Fixed computation issue in “difference to parent” in interactive clustering

  * Fixed sort by “difference to parent” in interactive clustering

  * Added more details about algorithms in results pages

  * Added warning when number of selected models can lead to ties for voting classifier ensembles.

  * Made `dataiku.current_project_key()` API usable in custom models

  * Updated Sparkling Water to 2.0.21 / 2.1.20 / 2.2.6




### Data preparation

  * Added ability to remove outliers on dates

  * Added Column completion in “Compute distance” processor

  * Improved documentation links for reshaping processors

  * Open processors documentation in a new tab

  * Misc small UI improvements




### Recipes

  * Don’t allow Spark and MR engines for partition redispatch

  * Fixed UI of postfilter with incorrect formula

  * Fixed custom aggregates in Pivot recipe

  * Window recipe on DSS engine: fixed non-dense rank within group

  * Window recipe on DSS engine: fixed negative window limits

  * Misc small UI improvements

  * Fixed occasional failure while retrieving Spark failure




### Coding

  * Fixed “write_metadata” and “create_meaning” Python APIs

  * Fixed failure to create some templates in plugins




### Web apps

  * Don’t lose Python backend code when disabling backend.

  * Fixed issues with Shiny apps when DSS is behind a HTTPS reverse proxy




### Automation

  * Fixed display issue in “Dataset modified” trigger

  * Fixed deadlock when aborting a scenario when aborted build step was run from a python step

  * Don’t complain when no partition is selected in “Compute Metrics” step (means all partitions)




### Misc

  * All modals now have a “temporarily hide” button to view the Flow underneath

  * Fixed support link in error messages

  * Fixed failure saving very long project variables

  * Fixed migration issue for code envs in multi-user-security mode




## Version 4.1.2 - December, 12th 2017

DSS 4.1.2 contains both bug fixes and new features. For the list of new features in the 4.1 branch, see release notes for 4.1.0 below

### Machine learning

  * **New feature** : Support for numerical vectors as input feature in Visual Machine Learning

  * Percentage display in confusion matrix

  * New performance-oriented options for MLLib

  * Fixed display of cross-validation chart for regresison models when K-fold cross test is enabled




### Data preparation

  * **New feature** : Stop words and stemming for German, Spanish, Portuguese, Italian and Dutch languages




### API node

  * **New feature** : New UI to define test queries and data enrichments for API node.

  * Fixed intermittent failures of R function and R prediction endpoints when left idle

  * Fixed dataset lookup endpoint mode hanging after several queries




### Flow

  * **New feature** : Ability to define maximum parallelism per recipe, recipe type, user, … (See [Limiting Concurrent Executions](<../../flow/limits.html>))

  * Fixed rectangular selection and dragging on Safari

  * Fixed copy of parts of Flow with “All available” partition dependency

  * Fixed “New recipe” menu when more than ~30 plugins are installed




### Automation

  * Fixed wrongful display of some jobs as being “initiated by a scenario” whereas they were not. This could also cause leakage of backend log lines in scenario logs.




### Dashboard

  * Fix issue whereby sometimes, users couldn’t view web apps they were allowed to

  * Fixed display of static insights with spaces in names




### Visual recipes

  * Fixed split recipe in “Fully random dispatch” mode on Hive and Spark

  * Fixed UI for “equals to a date” filtering

  * Fixed support on Greenplum

  * Fix array contains operator on DSS engine




### Coding

  * Fixed “clear” API on managed folders

  * Fixed partitioned Pig recipe

  * Fixed creation of notebook templates in plugin developer




### Hadoop & Spark

  * Allow Kerberos+SSL when using the Cloudera driver for Impala

  * Fixed support for Hadoop without any kind of Hive support




### Misc

  * **New feature** : Support for per-user-credentials together with LDAP authentication on Teradata

  * Performance improvements for large deployments

  * Don’t let users enter empty project names

  * Fixed hang of custom datasets “Test & Get Schema”

  * Faster explore of partitioned SQL datasets

  * Allow pre- and post- queries in SQL query dataset

  * Fixed possible interface unresponsiveness when validating a coding recipe with “all available” partitioning, and unresponsive data source

  * Allow Markdown in plugins description

  * Various error display improvements

  * Fix usage of templates in plugins




## Version 4.1.1 - November, 20th 2017

DSS 4.1.1 is a bugfix release. For the list of new features in the 4.1 branch, see release notes for 4.1.0 below

### Datasets

  * Fixed errors when using HTTP datasets as inputs of some visual recipes

  * Fixed spurious warning when creating an editable dataset

  * Improved error handling when creating new managed datasets

  * Added experimental support for “autocommit” execution on Microsoft SQL Server

  * Fixed write support in custom Python datasets




### Recipes

  * Fixed handling of partitioned inputs in pivot recipe

  * Fixed handling of partitioned outputs in split recipe with Hive engine




### Hadoop & Spark

  * Fixed reading of partitioned Parquet HDFS datasets in Spark notebook

  * Fixed validation of partitioned SparkSQL recipe with Parquet HDFS inputs

  * Fixed failure to synchronize Hive metastore after manual clear of dataset

  * Fixed some buggy cases in Spark pipelines building

  * Added default setting for better out-of-the-box experience on MUS with Spark 2.2




### Data preparation

  * Better formatting of dates in analyze histogram




### Machine learning

  * Fixed computation of score for multiclass when not all classes are in test set

  * Fixed selectability of models in saved model versions list

  * Fix evaluate recipe in multiclass when evaluating rows with target not seen at training.




### Flow and jobs

  * Fixed schema propagation across Hive recipes in HiveServer2 execution mode

  * Performance enhancements in job details page




### Dashboards

  * Fix read dashboard only permission




### Misc

  * Fixed migration of scenarios with attached datasets in reporters

  * Fixed UI issues in tags edition on Firefox

  * Fixed color scale for binned XY charts

  * Exclude non-writable plugin datasets from project exports

  * Fixed memory and socket leak in jobs building




## Version 4.1.0 - November, 13th 2017

DSS 4.1.0 is a major upgrade to DSS with a lot of new features. For a summary of the major new features, see: <https://www.dataiku.com/learn/whatsnew>

### New features

#### For coders: Multiple code environments for Python and R

DSS now allows you to create an arbitrary number of code environments. A code environment is a standalone and self-contained environment to run Python or R code.

Each code environment has its own set of packages. Environments are independent: you can install different packages or different versions of packages in different environments without interaction between them. In the case of Python environments, each environment may also use its own version of Python. You can for example have one environment running Python 2.7 and one running Python 3.6

See [Code environments](<../../code-envs/index.html>) for more information.

#### For coders: Python 3 support

As a consequence of the multiple code environments support, you can now run Python 3 (3.4 to 3.6) for all your DSS code.

#### For coders: Shiny and Bokeh

You can now write [web applications](<../../webapps/index.html>) in DSS using the Shiny and Bokeh libraries that are fully natively integrated.

A [Shiny web app](<../../webapps/shiny.html>) uses the Shiny <https://shiny.rstudio.com/> R library. You write R code, both for the “server” part and “frontend” part. Using Shiny, it is easy to create interactive web apps that react to user input, without having to write any CSS or Javascript.

You write your Shiny code as you would outside of DSS, and DSS takes care of hosting your webapp and making it available to users with access to your data project.

A [Bokeh web app](<../../webapps/bokeh.html>) uses the Bokeh <http://bokeh.pydata.org/en/latest/> Python library. You write Python code, both for the “server” part and “frontend” part. Using Bokeh, it is easy to create interactive web apps that react to user input, without having to write any CSS or Javascript (Bokeh is the Python counterpart to Shiny).

You write your Bokeh code as you would outside of DSS, and DSS takes care of hosting your webapp and making it available to users with access to your data project.

#### Mass actions and view on the Flow

The UI capabilities of the [DSS Flow](<../../flow/index.html>) have been strongly boosted.

You can now:

  * Select multiple items (using Shift+Click, or using rectangular selections)

  * Apply a large number of mass actions on multiple items , like: * Delete * Clear * Build * Add to a scenario * Change engines * Change Spark configurations * Change tags * Change dataset types and connections * …

  * View items in the Flow using a variety of inspection layers, like: * By connection * By recipe engine * By partitioning scheme * By creation/modification date or author * By Spark configuration * …

  * Copy entire parts of the Flow, either within a project or between projects




#### Filtering on the Flow

In addition to the above mentioned mass actions capabilities, you can now filter the flow view by tags, users, types and modification dates. This allows you to focus on your part of the Flow while not being distracted by the rest of the Flow, and is particularly useful for large projects.

#### For coders: RMarkdown

Code reports allow you to write code that will be rendered as beautiful reports that you can download, attach by mail or render on the dashboard. R Markdown reports can be used to generate documents based on your project’s data.

[R Markdown](<http://rmarkdown.rstudio.com/>) is an extension of the [markdown](<https://en.wikipedia.org/wiki/Markdown>) language that enable you to easily mix formatted text with code written in several languages (in particular R or Python).

When editing your R Markdown report in DSS, you can “build” it to generate the output document. This document can be displayed, published into the dashboard, downloaded in various document formats, or attached to emails.

See [R Markdown reports](<../../R/rmarkdown.html>) for more information.

#### For coders: custom charts on the dashboard

Through the new “static insights” mechanism, it is now possible to easily display on the DSS dashboard charts or other arbitrary files produced using Python or R code directly on the DSS dashboard.

See [static insights in Python](<https://developer.dataiku.com/latest/api-reference/python/static-insights.html> "\(in Developer Guide\)") and [static insights in R](<../../R-api/static_insights.html>)

This notably includes charts created with:

  * [Plot.ly](<../../python/plotly.html>)

  * [Matplotlib](<../../python/matplotlib.html>)

  * [Bokeh](<../../python/bokeh.html>)

  * [Ggplot](<../../python/ggplot.html>)




#### For data scientists: Auto-ML features

The capabilities of DSS to automatically optimize machine learning models have been greatly improved:

  * Real-time models comparison charts to see the progress of your grid search optimization

  * Support for random search

  * Time-boundable search

  * Interruptible and resumable search

  * Plot the impact of any hyperparameter on the model’s performance and training time




Many more parameters can now be optimized in all algorithms.

More support has been added for custom cross-validation strategies. Code samples are available for one-click setup of LeaveOneOut / LeavePOut strategies.

The UI has been overhauled to make it clearer how to try more parameters, and to better document various options.

#### For data scientists: Grid search in MLLib models

DSS previously had support for hyperparameters optimization for Python (in-memory) models. This capability has been extended to MLLib models.

#### For data scientists: Ensemble models

You can now select multiple models and create an ensemble model out of them.

Ensembling can be done using:

  * Linear stacking (for regression models) or logistic stacking (for classification problems)

  * Prediction averaging or median (for regression problems)

  * Majority voting (for classification problems)




#### For analysts: Pivot recipe

The pivot recipe lets you build pivot tables, with advanced control over the rows, columns and aggregations. It supports execution of the pivot on external systems, like SQL databases, Spark, Hive or Impala.

The pivot recipe supports advanced features like limiting the number of pivoted columns, multi-key pivot, …

See [Pivot recipe](<../../other_recipes/pivot.html>) for more information.

#### For analysts: Sort recipe

#### For analysts: New “Split” recipe

#### For analysts: Distinct recipe

#### For analysts: “Top N” recipe

The “Top N” recipe allows you to retrieve the first and last N rows of subsets with the same grouping keys values. The rows within a subset are ordered by the columns you specify. It can be performed on any dataset in DSS, whether it’s a SQL dataset or not.

See [Top N: retrieve first N rows](<../../other_recipes/topn.html>) for more information

#### R models in API node

You can now write custom model predictions in R and expose them on the DSS API node. DSS will automatically handle deployment, distribution, high availability and scalability of your R model, written using any R package

See [Exposing a R prediction model](<../../apinode/endpoint-r-prediction.html>) for more information

#### Arbitrary Python or R functions in the API node

In addition to custom prediction models in Python or R, you can now expose arbitrary functions in the DSS API node. DSS will automatically handle deployment, distribution, high availability and scalability of your functions.

See [Exposing a Python function](<../../apinode/endpoint-python-function.html>) and [Exposing a R function](<../../apinode/endpoint-r-function.html>) for more information

#### SQL queries in the API node

You can expose a parametrized SQL query as a DSS API node endpoint. Calling the endpoint with a set of parameters will execute the SQL query with these parameters.

The DSS API node automatically handles pooling connections to the database, high availability and scalability for execution of your query.

See [Exposing a SQL query](<../../apinode/endpoint-sql-query.html>) for more information

#### Datasets lookup in the API node

The “dataset(s) lookup” endpoint offers an API for searching records in a DSS dataset by looking it up using lookup keys.

For example, if you have a “customers” dataset in DSS, you can expose a “dataset lookup” endpoint where you can pass in the email address and retrieve other columns from the matching customer.

See [Exposing a lookup in a dataset](<../../apinode/endpoint-dataset-lookup.html>) for more information

#### Index external tables in DSS catalog

It is now possible to scan and index DSS connections. The DSS catalog will then contain items for every table in the remote connection. You can search tables by connection, schema, name, columns, descriptions, … You can preview tables, see if they are already imported as DSS datasets, and import them easily.

#### Folders and uploads everywhere

Managed folders and uploaded datasets can now be stored on any “files-aware” location supported by DSS (local filesystem, HDFS, S3, GCS, Azure Blob, FTP, SFTP).

#### New HTTP / FTP / SCP / SFTP support

The support for these protocols has been completely overhauled:

  * The old cache can now be completely bypassed.

  * You can now use the [Download recipe](<../../other_recipes/download.html>) to cache files from a remote location to another location (which can be local or remote)

  * SFTP datasets are now writable




#### New chart features

DSS 4.1 comes with several major improvements to the data visualization features:

  * Ability to create animated charts, animated by another dimension

  * Ability to create “sub-charts”, broken down by another dimension

  * More control on legend position, legend for continuous colors

  * Support for displaying geometry directly on maps

  * Customizable color palettes

  * Diverging color palettes

  * Customizable map backgrounds

  * Compute charts using Hive




#### Attach more things to scenario emails

In [DSS scenarios](<../../scenarios/index.html>) you can send email reports at the end of a scenario.

You can now attach to these email reports multiple items:

  * The data of a dataset, in any format supported by DSS format exporters

  * A file from a managed folder

  * The full content of a managed folder

  * An export of a [RMarkdown report](<../../R/rmarkdown.html>)

  * An export of a [Jupyter noteboook](<../../notebooks/index.html>)

  * The log file of the scenario




A mail can have multiple attachments.

### Other notable enhancements

#### Edit recipes in notebook

You can now easily edit a Python or R recipe (regular or Spark) in a Jupyter notebook, and go back to the recipe from the notebook/

#### Code editor enhancements

In all places where you can edit code in DSS, you can now:

  * Customize the theme of the code editor (go to your user profile)

  * Customize font and font size

  * Customize some key mappings




In addition, code editors now support many more features:

  * Code folding

  * Auto close of brackets and tags

  * Multiple cursors




#### Managed folder browser

The browser for managed folder has been strongly enhanced and now allows you full control and modificability of the folder content.

You can also directly unzip Zip files in a managed folder

#### Plugin and libraries editor

The plugin and libraries editor is now much more powerful, feature multi-files edition, direct creation of all component types, move/rename capabilities.

#### Plugin edition for non-administrators

It is now possible for administrators to delegate to non-administrators the right to create plugins and edit code libraries

#### Spark 2.2

DSS now includes support for Spark 2.2

#### SQL code formatter

#### “Concat” aggregates in grouping and window recipes

You can now aggregate string columns by creating a concatenation of all values (or all distinct values) in the grouping and window recipes.

#### Better support for empty datasets

Until now, an empty SQL dataset (table exists but has 0 rows, or SQL query returns 0 rows) was considered
    

as “not ready” and could not be used in the Flow. This is now a configurable dataset.

#### Native TDCH support

DSS includes TDCH support in the sync recipe for fast transfers:

  * Teradata to HDFS

  * HDFS to Teradata




This includes interaction with other Hadoop Filesystems, as HDFS datasets (S3, …)

#### Plugins

  * Plugins can now contain “FS providers” to define new kinds of “file-aware” datasets and managed folders

  * Plugins can now contain templates for webapps and code reports

  * Plugins can now contain custom palettes and map backgrounds for charts




#### Misc (datasets)

  * DSS has beta support for IBM DB2.

  * DSS has beta support for Exasol

  * You can now check schema consistency on all files in a dataset

  * [Relocation settings](<../../connecting/relocation.html>) are now available for many more types of datasets

  * Checking if a SQL query dataset is ready is now much faster

  * Uploaded datasets can now be partitioned

  * Improved error and status reporting in datasets screens




#### Misc (webapps)

Improvements in the webapps mechanism make it more robust to copy a project containing a webapp within a DSS instance

#### Misc (recipes)

  * You won’t get prompted to update the schema anymore of an output dataset when it’s empty (happens automatically)




#### Misc (charts)

  * Added support for filter by date in SQL Server

  * Ability to reorder charts

  * Option not to replace missing values by 0 (notably in line charts)




#### Misc (data preparation)

  * Columns of integers containing 0-leading values will now be considered as Text

  * When both integer and decimal are possible, but some values are not valid integers, DSS will now properly choose decimal

  * Forced meanings are better preserved across preparation recipes, fixing some invalid “switch to numeric” behaviors




#### Misc (administration)

  * Connections are not tested automatically anymore, avoiding cases where you could get locked out for using a wrong password

  * The DSS temporary directories have been cleaned up to make it easier to understand what takes some space




### Notable bug fixes

#### Datasets

  * You can now download multiple files in a HTTP dataset

  * HTTP dataset now supports SSL SNI

  * Other stability fixes for HTTP datasets

  * Fixed intermittent “Address already in use” issue with custom Python datasets




#### Recipes

  * Preferred engine is now taken into account for split, filter and sync recipe




#### Automation

  * Fixed setting global variables from a custom scenario Python step

  * Fixed Scenario.get_definition() in Python API client

---

## [release_notes/old/4.2]

# DSS 4.2 Release notes

## Migration notes

### Migration paths to DSS 4.2

>   * From DSS 4.1: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
>
>>     * From DSS 4.0: In addition to the restrictions and warnings described in [Limitations and warnings](<4.1.html#releases-notes-4-1-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<4.1.html>)
>> 
>>     * From DSS 3.1: In addition to the restrictions and warnings described in [Limitations and warnings](<4.1.html#releases-notes-4-1-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [3.1 -> 4.0](<4.0.html>) and [4.0 -> 4.1](<4.1.html>)
>> 
>>     * From DSS 3.0: In addition to the restrictions and warnings described in [Limitations and warnings](<4.1.html#releases-notes-4-1-limitations>), you need to pay attention to the restrictions and warnings applying your previous versions. See [3.0 -> 3.1](<3.1.html>), [3.1 -> 4.0](<4.0.html>) and [4.0 -> 4.1](<4.1.html>)
>> 
>>     * From DSS 2.X: In addition to the restrictions and warnings described in [Limitations and warnings](<4.1.html#releases-notes-4-1-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions: see [2.0 -> 2.1](<2.1.html>) [2.1 -> 2.2](<2.2.html>) [2.2 -> 2.3](<2.3.html>), [2.3 -> 3.0](<3.0.html>), [3.0 -> 3.1](<3.1.html>), [3.1 -> 4.0](<4.0.html>) and [4.0 -> 4.1](<4.1.html>)
>> 
>>     * Migration from DSS 1.X is not supported. You must first upgrade to 2.0. See [DSS 2.0 Relase notes](<2.0.html>)
> 
> 


### How to upgrade

It is strongly recommended that you perform a full backup of your DSS data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>).

Pay attention to the warnings described in Limitations and warnings.

### Limitations and warnings

DSS 4.2 is a major release, which changes some underlying workings of DSS. Automatic migration from previous versions is supported, but there are a few points that need manual attention.

#### Retrain of machine-learning models

  * Models trained with prior versions of DSS should be retrained when upgrading to 4.2 (usual limitations on retraining models and regenerating API node packages - see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)). This includes models deployed to the flow (re-run the training recipe), models in analysis (retrain them before deploying) and API package models (retrain the flow saved model and build a new package)

  * After installation of the new version, R setup must be replayed




#### External libraries upgrades

Several external libraries bundled with DSS have been bumped to major revisions. Some of these libraries include some changes that may require adaptation of your code.

As usual, remember that you should not change the version of Python libraries bundled with DSS. Instead, use [Code environments](<../../code-envs/index.html>).

## Version 4.2.5 - May, 31th 2018

### Machine learning

  * Fixed retraining of LASSO-LARS models




### Datasets

  * BigQuery: added support for latest JDBC (en majuscules) drivers version (>= 1.1.6)

  * Fixed error when browsing path of Google Cloud Storage datasets

  * Fixed explore of DB2 datasets when the compatibility mode is not MySQL




### Flow

  * Fixed ‘Rebuild behaviour’ option on managed folders




### Misc

  * Fixed display of ‘Edit metadata for’ modal on the connection screen.

  * Fixed memory leak in HDFS connections on Multi-user-security instances




## Version 4.2.4 -

Internal release

## Version 4.2.3 - May, 9th 2018

### Machine learning

  * **New feature** : Added ability to revert the design of a prediction task to a previously trained model

  * Fixed issues with outliers detection in MLLib clustering

  * Fixed failure training multiple MLLib clustering models at once

  * Fixed failure deploying custom MLLib clustering models

  * Fixed excessive memory consumption on linear models

  * Fixed display of interactive clustering hierarchy with high number of clusters.

  * Fixed API node version activation when using Lasso-LARS algorithm

  * Added proper error message when trying to ensemble K-fold-cross-tested models (not supported)




### Spark

  * Strong performance improvement on processing of ORC files




### Flow

  * Fixed issue with recipes building both partitioned and non-partitioned datasets




### API

  * Allowed changing the path of a managed folder through the public API




### Misc

  * **New feature** : Integration with collectd for system monitoring

  * Added support for Java 10

  * Fixed reset of HDFS connection settings when upgrading multi-user-security-enabled instances




### Security

  * Restricted profile pictures visibility to avoid possible information leak

  * Fixed stored XSS vulnerability

  * Fixed directory traversal vulnerability




## Version 4.2.2 - April, 17th 2018

### Datasets

  * Fixed external Elasticsearch 6 datasets

  * Fixed testing of ElasticSearch datasets with “Trust any SSL certificate” option




### Security

  * Fixed missing authorization in Jupyter that could allow users to shutdown and delete unauthorized notebooks

  * Fixed missing enforcing of “Freely usable by” connection permission on SQL queries written from R scripts (using dkuSQLQueryToData)




### Flow

  * Fixed copy of Python recipes with a managed folder as output

  * Fixed other edge cases in copy of recipes




### Machine learning

  * Fixed lift curve with sample weights




### Misc

  * Performance improvements for formulas

  * Made it easier to write into managed folders in Multi-user-security-enabled DSS instances

  * Fixed automation node not taking into account the “Install Jupyter Support” flag for code environments

  * Fixed Python code environments on Mac (TLS issue in pip)

  * Fixed “Clean internal DBs” macro that could prevent running jobs from finishing

  * Worked-around Conda bug preventing installation of Jupyter on conda environments

  * Improved support for PingFederate SSO IdP (compatibility with default behavior)

  * Fixed Notebooks list in “Lab”




## Version 4.2.1 - April, 3rd 2018

### Datasets

  * S3: Faster files enumeration on large directories

  * Teradata-Hadoop sync: add support for multi-user-security

  * Teradata-Hadoop sync: fixed distribution modes and added parallelism settings to all modes




### Machine learning

  * Fixed Jupyter notebooks export of models

  * Fixed “Redetect settings” button




### Flow

  * Large performance improvements in “Check Consistency” for large flows




### Visual recipes

  * Pivot recipe: added support for Teradata

  * Prepare recipe: fixed possible NPE on remove column processing with pattern mode.




### API node

  * Do not fail on startup if the model need to be retrained. Instead, display an informative message




### Misc

  * Various performance improvements

  * Fix sample fetching from the catalog on Teradata tables

  * Preliminary support for Ubuntu 18.04

  * Fix Multi-User-Security mode on SuSE 12

  * Security: Add “noopener norefer” to all links from DSS to <https://dataiku.com>

  * Security: Add directives to disable password autocompletion in various forms




## Version 4.2.0 - March, 21st 2018

DSS 4.2.0 is a major upgrade to DSS with significant new features. For a summary of the major new features, see: <https://www.dataiku.com/learn/whatsnew>

### New features

#### Support for sample weights in visual machine learning

You can now define a column to be used as the sample weights column when training a machine-learning model.

When a sample weights column is enabled:

  * Most algorithms take it into account for training

  * All performance metrics become weighted metrics for better evaluation of your model’s performance




#### “Hive” dataset (views and decimal support)

In addition to the traditional “HDFS” dataset, DSS now supports a native “Hive” dataset.

When reading a “Hive” dataset, DSS uses HiveServer2 to access its data (compared to the direct access to the underlying HDFS files, with the traditional HDFS dataset).

This gives access to some Hive-native features that were not possible with the HDFS dataset:

  * Support for Hive views (including if you don’t have filesystem access to the underlying tables)

  * Support for ACID Hive tables

  * Better support for “decimal” and “date” data types




The Hive dataset can be used in all visual recipes in addition to the coding Hive recipe.

When importing tables from the Hive metastore, you can now select whether to import it as a HDFS or Hive dataset.

#### Impersonation on SQL databases

When running DSS in multi-user-security mode (see [User Isolation](<../../user-isolation/index.html>)), you can now use impersonation features of some enterprise databases.

This gives per-user impersonation when logging into the database (i.e. connections to the database are made as the final user, not as the DSS service account), without requiring users to individually enter and store their connection credentials.

This feature is available for:

  * [Microsoft SQL Server](<../../connecting/sql/sqlserver.html>) (also added: Kerberos authentication support)

  * [Oracle](<../../connecting/sql/oracle.html>) (also added: Kerberos authentication support)




#### Full support for BigQuery

DSS now supports both read and write for Google BigQuery

#### Dedicated automation homepage

Automation nodes now get a dedicated home page that shows the state of all of your scenarios.

#### API for managing and training machine-learning models

All machine learning models operations can now be performed using the API, and we provide a Python client for this:

  * Creating models

  * Modifying their settings

  * Training them

  * Retrieving details of trained models

  * Deploying trained models to DSS Flow

  * Creating scoring recipes




See [Python](<https://developer.dataiku.com/latest/api-reference/python/index.html> "\(in Developer Guide\)")

### Other notable enhancements

#### UI and collaboration

  * Improved ability to edit metadata of items, which can no be edited directly from the Flow or objects lists

  * Improved tags management UI

  * Added ability to rename a tag

  * You can now select from more cropping and stretching mode for your project homes




#### Hadoop

  * DSS now supports EMR 5.8 to 5.11




#### Spark

  * Spark pipelines now handle more kinds and cases of Flows

  * Prediction scoring recipes in Spark mode can now be part of a Spark pipeline




#### Datasets

  * SQL datasets can now be partitioned by multiple dimensions and not a single one anymore

  * DSS can now read CSV files with duplicate column names

  * It is now possible to ignore “unterminated quoted field” error in CSV, and keep parsing the next files

  * It is now possible to ignore broken compressed files errors in CSV, and keep parsing the next files

  * Added support for ElasticSearch 6

  * Forbid creating datasets at the root of a connection (which is very likely an error, and could lead to dropping all connection data)

  * Automatically disable Hive and Impala metrics engine if the dataset does not have associated metastore information




#### Visual recipes

  * Exporting visual recipes to SQL query now takes aliases into account

  * Added ability to compare dates in DSS Formulas




#### Machine Learning

  * Display Isolation Forest anomaly score in the ML UI




#### Scenarios

  * It is now possible to disable steps

  * It is now possible to have steps that execute even if previous steps failed




#### Plugins

  * It is now possible to import a plugin in DSS by cloning an existing Git repository

  * A plugin installed in DSS can now be converted to a “plugin in development” so it can be modified directly in the plugin editor




#### Jupyter Notebook

  * The Jupyter Notebook (providing Python, R and Scala notebooks) has been upgraded to version 5.4

  * This provides fixes for:
    
    * Saving plotly charts

    * Displaying Bokeh charts

  * You do not need to restart DSS anymore to take into account new Spark settings for the Jupyter notebook




#### Machine Learning

  * Custom scoring functions can now receive the `X` input dataframe in addition to the `y_pred` and `y_true` series

  * SGD and SVM algorithms have been added for regression (they were already available for classification)

  * “For Display Only” variables are now usable in more kinds of clustering report screens

  * It is now possible to configure how many algorithms are trained in parallel (was previously always 2)




#### Java runtime

  * DSS now supports Java 9

  * It is now possible to customize the GC algorithm

  * DSS now automatically configures the Java heap with a value depending on the size of the machine

  * DSS now automatically uses G1 GC on Java 8 and higher




#### API

  * New API to create new files in development plugins

  * New API to download a development plugin as a Zip file

  * Added ability to force types in `query_to_df` API




#### Administration

  * JSON output for `apinode-admin` tool

  * Added more ability to automatically clear various temporary data




#### Misc

  * Added ability to use time after the current time in the “Time Range” partition dependency function

  * Various performance improvements

  * DSS now supports verifying client-side TLS/SSL certificates

  * It is now possible to configure network interfaces on which DSS listens




### Notable bug fixes

#### Data preparation

  * Fixed parsing of “year + week number” kind of dates

  * Fixed merge of clusters in value clustering with overlapping clusters

  * Fixed error when computing full sample analysis on a column which was not in the schema




#### Machine Learning

  * Fixed models on foreign (from another project) datasets

  * Fixed invalid rescaled coefficients statistics for linear models

  * Fixed Evaluate recipe when some rows are dropped by the “Drop rows” imputation method

  * Fixed “Drop rows” imputation method on the API node when using optimized scoring engine




#### Datasets

  * SQL datasets: Multiple issues with “date” columns in SQL have been fixed

  * SQL datasets: Add ability to read Oracle CLOB fields

  * Avro: fix reading of some Avro files with type references

  * S3: Fixed reading of some Gzip files that failed

  * Elasticsearch: on managed Elasticsearch datasets, partitioning columns for value dimensions are now typed as `keyword` on ES 5+, rather than `string`, which is deprecated in ES 5 and not supported by ES 6.




#### Visual recipes

  * Show column renamings in the “View SQL query” section of visual recipes

  * Fixed partitioning sync from SQL to HDFS using Spark engine

  * Fixed “Concat Distinct” aggregation

  * Prevent failing join with DSS engine if columns have leading or trailing whitespaces

  * Fixed “null ordering” with DSS engine

  * Fixed window on range using DSS engine with nulls in ordering column

  * Fixed export recipe on partitioned datasets (was exporting the whole dataset)

  * Copying a prepare recipe now properly initializes schema on the copied dataset

  * Fixed Grouping recipe with Spark when renaming column and using post-filtering on renamed column




#### Multi-user-security

  * Fixed various issues with HDFS managed folders in MUS mode




#### Coding

  * Fix Hive recipe validation failure if the input dataset doesn’t have an associated Hive table

  * Fixed export of Jupyter dataframe when it contains non-ascii column names

  * Fixed failure to write managed folder files when files are very small

  * Fixed “output piping” in the Shell recipe




#### Flow

  * Added ability to process dates after the current date in the “Time Range” dependnecy function

  * Fixed building both Filesystem and SQL partitioned datasets at the same time




#### Code reports

  * Fixed some cases where exports of RMarkdown reports would not display all kinds of charts.




#### Metrics

  * Don’t try to use Hive or Impala for metrics if the dataset doesn’t have an associated Hive table




#### Automation

  * Fixed loss of “Additional dashboard users” and Project Status when deploying on automation node

  * Fixed issues with migration of webapps on Automation node




#### Charts

  * Fixed some cases of charts not working on Hive with Tez execution engine




#### API

  * Fixed building of managed folder using internal Python API for scenarios




#### Plugins

  * Display columns in correct order when previewing the result of a custom dataset

---

## [release_notes/old/4.3]

# DSS 4.3 Release notes

## Migration notes

### Migration paths to DSS 4.3

>   * From DSS 4.2: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 4.1: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<4.1.html>) and [4.1 -> 4.2](<4.2.html>)
> 
>   * From DSS 4.0: In addition to the restrictions and warnings described in [Limitations and warnings](<4.1.html#releases-notes-4-1-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<4.1.html>) and [4.1 -> 4.2](<4.2.html>)
> 
>   * From DSS 3.1: In addition to the restrictions and warnings described in [Limitations and warnings](<4.1.html#releases-notes-4-1-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [3.1 -> 4.0](<4.0.html>) and [4.0 -> 4.1](<4.1.html>) and [4.1 -> 4.2](<4.2.html>)
> 
>   * From DSS 3.0: In addition to the restrictions and warnings described in [Limitations and warnings](<4.1.html#releases-notes-4-1-limitations>), you need to pay attention to the restrictions and warnings applying your previous versions. See [3.0 -> 3.1](<3.1.html>), [3.1 -> 4.0](<4.0.html>) and [4.0 -> 4.1](<4.1.html>) and [4.1 -> 4.2](<4.2.html>)
> 
>   * From DSS 2.X: In addition to the restrictions and warnings described in [Limitations and warnings](<4.1.html#releases-notes-4-1-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions: see [2.0 -> 2.1](<2.1.html>) [2.1 -> 2.2](<2.2.html>) [2.2 -> 2.3](<2.3.html>), [2.3 -> 3.0](<3.0.html>), [3.0 -> 3.1](<3.1.html>), [3.1 -> 4.0](<4.0.html>) and [4.0 -> 4.1](<4.1.html>) and [4.1 -> 4.2](<4.2.html>)
> 
>   * Migration from DSS 1.X is not supported. You must first upgrade to 2.0. See [DSS 2.0 Relase notes](<2.0.html>)
> 
> 


### Deprecation notice

DSS 4.3 deprecates support for some OS and Hadoop distributions. Support for these will be removed in a later release.

Support for the following OS versions are deprecated and will be removed in a later release:

  * Redhat/Centos/Oracle Linux 6 versions strictly below 6.8

  * Redhat/Centos/Oracle Linux 7 versions strictly below 7.3

  * Ubuntu 14.04

  * Debian 7




Support for the following Java versions is deprecated and will be removed in a later release:

  * Java 7




Support for the following R versions is deprecated and will be removed in a later release:

  * R versions strictly below 3.4




Support for the following Hadoop distribution versions are deprecated and will be removed in a later release:

  * Cloudera distribution for Hadoop versions strictly below 5.9

  * HDP versions strictly below 2.5

  * EMR versions strictly below 5.7




### How to upgrade

It is strongly recommended that you perform a full backup of your DSS data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>).

Pay attention to the warnings described in Limitations and warnings.

### Limitations and warnings

Automatic migration from previous versions is supported, but there are a few points that need manual attention.

#### Retrain of machine-learning models

  * Models trained with prior versions of DSS should be retrained when upgrading to 4.3 (usual limitations on retraining models and regenerating API node packages - see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)). This includes models deployed to the flow (re-run the training recipe), models in analysis (retrain them before deploying) and API package models (retrain the flow saved model and build a new package)

  * After installation of the new version, R setup must be replayed




## Version 4.3.4 - August 13th, 2018

DSS 4.3.4 is a bugfix release

### Recipes

  * Sync: Fixed Azure Blob Storage to Azure Data Warehouse fast path if ‘container’ field is empty in Blob storage connection

  * Sync: Fixed Redshift-to-S3 fast path with non equals partitioning dependencies.




### RMarkdown

  * Fixed truncated display in RMarkdown reports view

  * Fixed ‘Create RMarkdown export step’ scenario step when the view format is the same that the download format

  * Fixed RMarkdown attachments in scenario mails that could send stale versions of reports

  * Multi-user-security: add ability for regular users (i.e. without “Write unsafe code”) to write RMarkdown reports

  * Multi-user-security: Fixed RMarkdown reports snapshots

  * Fixed ‘New snapshot’ button on RMarkdown insight




### Hadoop

  * Fixed Hadoop installation script on Redhat 6

  * Fixed usage of advanced properties in Impala connections




### Misc

  * Allowed regular users (i.e. without “Write unsafe code”) to edit project-level Python libraries

  * Allowed passing the desired type of output to the ‘dkuManagedFolderDownloadPath’ R API function

  * Prevent possible memory overflow when computing metrics




## Version 4.3.3 - July 18th, 2018

DSS 4.3.3 is a bugfix release

### Datasets

  * Fixed recipes which have an external Cassandra dataset as input.




### Charts

  * Fixed bad ordering labels on scatterplot charts




### Flow

  * Fixed issue with highlighting on the first view of a Flow




### Machine learning

  * Fixed error when using feature selection by correlation to target together with classification problems and categorical variables with missing values imputation




### Recipes

  * Suggest joins with the first dataset in join recipes

  * Fixed display of Pig recipes validation errors

  * Fixed support of Pig recipes with multiple outputs




### Security

  * Fixed insufficient privilege validation for file uploads

  * Fixed non-impersonated code escalation through API Node dev server.




### Misc

  * Fixed error when reverting changes using “Revert this change only” mode.

  * Fixed possible deadlock when using Impala




## Version 4.3.2 - June 26th, 2018

DSS 4.3.2 is a bugfix release

### Datasets

  * **New feature** : added ability to forbid uploads into the DSS data directory

  * **New feature** : added to set the default target connection for upload datasets

  * **New feature** : added ability to configure uploads prefix on HDFS

  * Fixed upload datasets on HDFS connections in Multi User Security mode.

  * Added support for MySQL driver >= 8




### Machine Learning

  * Fixed possible disappearance of metrics on the model page.




### Recipes

  * Support for reading datasets above 2GB in R recipes.




### Misc

  * Added scenario actions to start and stop a cluster

  * Fixed creation of conda R code environments with conda >= 4.3.27

  * Improved flow filters when filtering on machine learning elements




## Version 4.3.1 - June 11th, 2018

DSS 4.3.1 is a bugfix release.

### Hadoop & Spark

  * Better error display for some Hive errors




### Flow

  * Fixed wrongful project boundary crossing when building recursive cross-projects Flows

  * Fixed UI issue creating Jobs database dataset




### Clusters

  * Make metrics computation use the proper cluster when running in a scenario-specific cluster

  * Added some protection against invalid values in the “default cluster” field




### Notebooks

  * Fixed UI issue with SQL autocompletion




### Machine Learning

  * Fixed link in “Train complete” notification

  * Fixed issues with migration from 4.1 of GBT models that were deployed in “no-reoptimize” mode

  * Fixed small UI issues




### Misc

  * Fixed Java 9 and Java 10 support issues




## Version 4.3.0 - June 4th, 2018

DSS 4.3.0 is a major upgrade to DSS with significant new features. For a summary of the major new features, see: <https://www.dataiku.com/learn/whatsnew>

### New features

#### API Deployer

The API Deployer empowers Data Scientists to self-manage model deployments and rollbacks, from dev to production, on premises or in the cloud.

The API Deployer is the centralized UI through which you can:

  * Manage your fleet of API nodes

  * Deploy new API services to your API nodes

  * Monitor the health and status of your API nodes

  * Manage the lifecycle of your APIs from development to production.




The API Deployer can control an arbitray number of API nodes, and can dynamically deploy new API Nodes as containers through the use of Kubernetes (which allows you to deploy either on-premises, or on a serverless stack on the cloud).

Please see [API Node & API Deployer: Real-time APIs](<../../apinode/index.html>) for more information.

#### Dynamic EMR clusters

This feature is based on the “multiple Hadoop clusters” feature, and is provided by an experimental plugin.

Through the use of this plugin, DSS can now create, destroy, and scale up and down EMR clusters. It is possible to assign different EMR clusters to various projects, and you can also build setups where you create volatile EMR clusters for running a scenario for full elastic usage approaches.

Please see [Dynamic AWS EMR clusters](<../../hadoop/dynamic-emr.html>) for more information.

#### Reorder columns in data preparation

As part of a “Prepare” recipe, you can now reorder column by dragging and dropping them. Columns reordering can also be performed in bulk and in the “columns” view of the Prepare recipe.

#### Fast load from Azure Blob Storage to Azure Datawarehouse

DSS now has an optimized engine for the “Sync” recipe to load data in Azure Datawarehouse from Azure Blob Storage.

#### Fast unload from Redshift to S3

DSS now has an optimized engine for the “Sync” recipe to unload data from Amazon Redshift to Amazon S3.

#### Macro roles

The “Macros” system that allows you to use and define custom actions in a plugin has been enhanced and can now display contextual actions. For example a “import schema” macro can now be displayed in the “Actions” menu of the dataset.

#### Support for multiple Hadoop clusters

A single DSS instance can now connect to multiple Hadoop clusters and submit jobs to them.

Please see [Multiple Hadoop clusters](<../../hadoop/multi-clusters.html>) for more information.

### Other notable enhancements

#### Keep zoom and position in Flow

The Flow view now remembers your position and zoom level when going back to the Flow for easier navigation in large flows.

#### Fast scoring for XGBoost models

XGBoost models are now using DSS optimized scoring engine. The effect is especially important for the API node, where using a XGBoost model can now be dozens of times faster.

#### More options for XGBoost models

The booster type, objective function, and tree building methods are now customizable. Booster and objective function can be grid-searched.

#### API endpoints calling other API endpoints

A common use-case is to have an API Service with several endpoints (for example several prediction models), and to have an additional “dispatcher” code endpoint that orchestrates the other endpoints.

Users only directly query the dispatcher endpoint, and this dispatcher endpoint in turns needs to query the other endpoints of the same API Service.

DSS now has new Python APIs to facilitate this kind of use cases. Please see [API Node & API Deployer: Real-time APIs](<../../apinode/index.html>) for more information.

#### Enhanced support for large number of plugins

The “New dataset” and “New recipe” menu have been overhauled to better display on instances with a very large number of plugins installed.

#### Performance

  * Large Flows will now display faster

  * Data exports can now run in external processes so as not to put load on the main DSS backend server.




#### Spark

  * Added support for Spark 2.3




#### Misc

  * Added support for vector features in the API node

  * Export of charts to images now use high resolution images




### Notable bug fixes

#### Machine learning

  * Fixed failures when using a date column as a categorical feature

  * Fixed failures scoring models on Spark with boolean columns




#### Flow

  * Fixed an issue when the input of a Flow is an empty managed folder

  * Fixed various issues related to recipes that output both partitioned and unpartitioned datasets

  * Fixed links to foreign saved models in the recipes Input/Output tab




#### API Node

  * It is now possible to run test queries in the API Node development server even if your service has authentication enabled.

---

## [release_notes/old/5.0]

# DSS 5.0 Release notes

## Migration notes

### Migration paths to DSS 5.0

>   * From DSS 4.3: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 4.2: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<4.3.html>)
> 
>   * From DSS 4.1: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.1 -> 4.2](<4.2.html>) and [4.2 -> 4.3](<4.3.html>)
> 
>   * From DSS 4.0: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<4.1.html>), [4.1 -> 4.2](<4.2.html>) and [4.2 -> 4.3](<4.3.html>)
> 
>   * From DSS 3.1: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [3.1 -> 4.0](<4.0.html>) and [4.0 -> 4.1](<4.1.html>) and [4.1 -> 4.2](<4.2.html>) and [4.2 -> 4.3](<4.3.html>)
> 
>   * From DSS 3.0: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying your previous versions. See [3.0 -> 3.1](<3.1.html>), [3.1 -> 4.0](<4.0.html>) and [4.0 -> 4.1](<4.1.html>) and [4.1 -> 4.2](<4.2.html>) and [4.2 -> 4.3](<4.3.html>)
> 
>   * From DSS 2.X: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions: see [2.0 -> 2.1](<2.1.html>) [2.1 -> 2.2](<2.2.html>) [2.2 -> 2.3](<2.3.html>), [2.3 -> 3.0](<3.0.html>), [3.0 -> 3.1](<3.1.html>), [3.1 -> 4.0](<4.0.html>) and [4.0 -> 4.1](<4.1.html>) and [4.1 -> 4.2](<4.2.html>) and [4.2 -> 4.3](<4.3.html>)
> 
>   * Migration from DSS 1.X is not supported. You must first upgrade to 2.0. See [DSS 2.0 Relase notes](<2.0.html>)
> 
> 


### OS and Hadoop deprecations

As previously announced, DSS 5.0 removes support for some OS and Hadoop distributions.

Support for the following OS versions is now removed:

  * Redhat/Centos/Oracle Linux 6 versions strictly below 6.8

  * Redhat/Centos/Oracle Linux 7 versions strictly below 7.3

  * Ubuntu 14.04

  * Debian 7

  * Amazon Linux versions strictly below 2017.03




Support for the following Hadoop distribution versions is now removed:

  * Cloudera distribution for Hadoop versions strictly below 5.9

  * HDP versions strictly below 2.5

  * EMR versions strictly below 5.7




### R deprecation

As previously announced, support for the following R versions is now removed:

  * R versions strictly below 3.4




### Java 7 deprecation notice and features restrictions

As previously announced, support for Java 7 is now deprecated and will be removed in a later release.

As of DSS 5.0, some features are not available anymore when running Java 7:

  * Reading of GeoJSON files

  * Reading of Shapefiles

  * Geographic charts (all types)




### How to upgrade

It is strongly recommended that you perform a full backup of your DSS data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>).

Pay attention to the warnings described in [Limitations and warnings](<4.3.html#releases-notes-4-3-limitations>).

### Limitations and warnings

Automatic migration from previous versions is supported, but there are a few points that need manual attention.

#### Java 7 restrictions

Please see above

#### Retrain of machine-learning models

  * Models trained with prior versions of DSS should be retrained when upgrading to 5.0 (usual limitations on retraining models and regenerating API node packages - see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)). This includes models deployed to the flow (re-run the training recipe), models in analysis (retrain them before deploying) and API package models (retrain the flow saved model and build a new package)




## Version 5.0.5 - January 10th, 2019

DSS 5.0.5 is a bugfix release

### Visual recipes

  * Window recipe: Fixed support of negative “limit preceding rows” with DSS engine

  * Grouping recipe: Fixed lead/lag diff on dates on Snowflake

  * Join recipe: Fixed “shifting” of computed columns when removing or switching datasets

  * Sync: Fixed support for S3-to-Redshift fast-path when the S3 bucket mandates server-side encryption

  * Sync: Added support for S3-to-Snowflake fast-path when the S3 bucket uses server-side encryption

  * Added ability to disable computation of execution plan when browsing visual recipes on SQL engine

  * Export: Fixed saving of credentials for Tableau export

  * Sync: Fixed failure creating the recipe when trying to sync from SFTP to GCS




### Docker/Kubernetes

  * Fixed intermittent failures when building many partitions in parallel on Kubernetes




### Machine learning

  * Deep learning: Display missing sampling options in “Train/Test”




### Data preparation

  * Fixed the ability to use the result of the `arrayDedup` function for the `arraySort` function




### Flow / Collaboration

  * Fixed disappearance of project image when renaming project

  * Added more verbose information if checking the readiness of a SQL dataset fails

  * Fixed display issue in the date picker for partitions selection




### Hadoop and Spark

  * Fixed support for building charts with Hive engine based on Hive views

  * Fixed installation of Spark integration when the default Python is Python3




### Coding

  * Fixed duplication of files and folders in the library editor

  * Fixed reference to XGBoost packages in conda “suggested packages”




### Security

  * Fixed support of Hive in some specific configurations of multi-user-security




### Setup

  * Added support for Amazon Linux 2




## Version 5.0.4 - November 30th, 2018

DSS 5.0.4 is a release containing both bug fixes and new features

### Hadoop

  * **New Feature** : Added support for EMR 5.19

  * Fixed Spark jobs when using cgroups on a Multi User Security instance




### Recipes

  * R API: fixed `dkuManagedFolderUploadPath` function in Multi User Security mode

  * Fixed schema inference in SQL Script recipes when using non-default database schema.

  * Fixed remembering of partition(s) to build in the recipe editor

  * Fixed possible ambiguous column names in join recipes when using advanced join conditions




### Machine learning

  * Fixed issue with non-selectable engine when using expert mode in the model creation modal.

  * Fixed possible display issue with the confusion matrix on unbalanced datasets with multiclass prediction.




### Datasets

  * Better formatting of large numbers in the status tab of datasets

  * Added native fast-path for sync from S3 to Snowflake




### Security

  * Improved protection against third-party website rediction on login

  * Fixed protection of Jupyter session identifiers for non-admin users

  * Fixed information leak in “metrics” datasets for non-admin users

  * Fixed missing impersonation of “notebook export” scenario step




### Misc

  * Dashboard: fixed copy of a machine learning model report tile

  * Prevent long modals from being under the navigation bar

  * Fixed Azure Blob Storage to Azure Data Warehouse fast path with date columns

  * Improved instance diagnosis reports




## Version 5.0.3 - November 7th, 2018

DSS 5.0.3 is a release containing both bug fixes and new features

### Datasets

  * Added a Snowflake dataset

  * Support for ElasticSearch 6.2 / 6.4

  * Strong performance improvements for SFTP write

  * Fixed bug when exploring “Latest available partition” with “Auto-refresh sample” enabled

  * Fixed in some cases ability to edit column headers in dataset preview

  * Fixed error in Excel parser if sheet name changed

  * Fixed Teradata per-user-credentials when logging in with LDAP mode on Teradata

  * Fixed decompression of archives when the extension is uppercase (.ZIP for example)




### Data visualization

  * Improved performance in some cases by avoiding cache recomputations




### Data preparation

  * **New feature** : Ability to add a processor to an existing group

  * Holidays flagging processor: added more dates for 2018 and 2019

  * Fixed error when reverting meaning to “Autodetect” mode

  * Various small UI improvements




### Visual recipes

  * **New feature** : Ability to remap columns between datasets in the Stack recipe




### Containers

  * Fixed `dataiku.api_client()` in container-run Python recipes




### Wikis

  * Fixed display of wikis on home page if an empty wiki was promoted

  * Fixed display bug on Safari




### Machine learning

  * Fixed description error in XGboost results

  * Fixed bug with % in column names




### Hadoop & Spark

  * Fixed support of WASB on HDP3




### Code recipes

  * Fixed pickling of top-level objects in Python recipe

  * Fixed ``if __name__ == "__main__"` in Python recipe




### API node

  * Fixed support for conditional outputs and proba percentiles

  * Added ability to have 0-arguments functions in Python endpoint

  * Added ability to add test queries from a foreign dataset




### API

  * Fixed SQL Execution in R API for statements returning no results

  * Added ability to delete analysis and mltasks in the ML API




### Dashboards

  * **New feature** : Ability to publish multiple charts at the same time from a dataset




### Security

  * Added ability to perform session expiration without losing Jupyter notebooks

  * Fixed XML entity injection vulnerability

  * Fixed possible matching error causing impersonation to fail (depending on user remapping rules)




### Misc

  * Python 3 compatibility fixes in notebooks exported from models*

  * New screens to get help about DSS

  * New screen to submit feedback about DSS




## Version 5.0.2 - October 1st, 2018

DSS 5.0.2 is a release containing both bug fixes and new features

### Hadoop

  * **New feature** : Experimental support for HDP3 (See [Cloudera (ex-Hortonworks) HDP](<../../hadoop/distributions/hdp.html>))

  * **New feature** : Support for CDH 5.15

  * Fixed Spark fast-path for Hive datasets in notebooks and recipes




### Datasets & Connections

  * **New Feature** Support of dataset exports using unicode separator

  * **New Feature** : per user credentials for generic JDBC connections

  * Fixed export of datasets for non-CSV formats

  * Fixed “download all” button for managed folders with no name

  * Fixed managed folders when a file name is in uppercase

  * Improved support for multi-sheet Excel files

  * Added support for Zip files with uppercase extension in filename (.ZIP)




### Data preparation

  * **New feature** : Fold multiple columns: added option to remove folded column




### Collaboration

  * Added new nicer default images for projects

  * Added “loading” status on homepage

  * Added search for Wiki articles in quick-go

  * Discussions are now included when exporting and importing a project




### Flow

  * Fixed multi selection on Flow on Windows

  * Fixed navigator on foreign datasets

  * Added support for containers (Docker and Kubernetes) on the “Recipe engines” Flow view




### Charts

  * Scalability improvements




### Machine learning

  * Fixed the deploy button in the ‘predicted data’ tab of a model in an analysis

  * Fixed ineffective early stopping for XGBoost regression and classification

  * Experimental Python 3 support for custom models in visual machine learning

  * Fixed error when saving an evaluate recipe without a metrics dataset




### Recipes

  * **New feature** : Support for non-equijoins on Impala

  * **New feature** : Best-effort support for window recipes on MySQL 8.

  * **New feature** : Capabilities to retrieve authentication info for plugin recipes

  * Filter recipe: don’t lose operator when changing column

  * Improved autocompletion for Python and R recipe code editors

  * Fixed PySpark recipes when using inline UDF




### APIs and plugins

  * **New feature** : New APIs to retrieve authentication information about the current user. This can be used by plugins to identify which user is running them, and by webapps to perform user authentication and authorization.

  * **New feature** : Added ability to retrieve credentials for a connection directly (if allowed) and improved “location info” on datasets

  * **New feature** : New mechanism for “per-user secrets” that can be used in plugins




### Misc

  * Fixed possible leak of FEK processes leading to their accumulation

  * Added ability to test retrieval of user information for LDAP configuration

  * Fixed creation of insights on foreign datasets

  * Fixed possible memory excursion when reading full datasets in webapps

  * Fixed ability to pass multiple arguments for code envs (Fixes ability to use several Conda channels)

  * Improved error message when DSS fails to start because of an internal database corruption

  * Fixed LDAP login failure when encountering a referral (referrals are now ignored)

  * Various performance improvements




### Security

  * Prevented ability for login page to redirect outside DSS

  * Fixed information disclosure throug timing attack that could reveal whether a username was valid

  * Added CSRF protection to DSS notifications websocket

  * Fixed missing code permission check for code steps, triggers and custom variables in scenarios

  * Redacted possibly sensitive information in job and scenario diagnosis when downloaded by non-admin users

  * Added support for AES-256 for passwords encryption




## Version 5.0.1 - August 27th, 2018

DSS 5.0.1 is a bugfix release

### Datasets

  * **New feature** : added support of “SQL Query” datasets when using Redshift-to-S3 fast path

  * Do not try to save the sampling settings in explore view if user is not allowed to

  * Fixed table import from Hive stored in CSV format with no escaping character

  * Fixed occasional failure reading Redshift datasets

  * Fixed creation of plugin datasets when schema is not explicitly set by the plugin

  * Fixed HDFS connection selection in mass import screen




### Recipes

  * Prepare: Added more available time zones to the date processors

  * Prepare: Fixed stemming processors on Spark engine

  * Sync: Fixed Azure Blob Storage to Azure Data Warehouse fast path if ‘container’ field is empty in Blob storage connection

  * Sync: Fixed Redshift-to-S3 fast path with non equals partitioning dependencies.




### Discussions

  * Fixed import of a project’s discussions when importing a project created with a previous DSS version

  * Fixed broken link when mentioning a user with a ‘.’ in his name

  * Preserved comment dates when migrating to discussions

  * Fixed inbox when number of watched objects is above 1024

  * After migration, a project level discussion is now markable as read




### Wikis

  * Improved search results with non-ascii keywords




### Hadoop & Spark

  * Enabled direct Parquet reading and writing in Spark when the Parquet files have the “spark_schema” type

  * Fixed Hadoop installation script on Redhat 6

  * Fixed usage of advanced properties in Impala connection




### Flow

  * In the “tags” flow view, show colors for nodes that have multiple tags but only one of the selected ones

  * Properly highlight managed folders in the “Connections” flow view




### Machine learning

  * Fixed model resuming when using gridsearching and maximum number of iterations

  * Restore grid search parameters when reverting the design to a specific model

  * Fixed ‘View origin analysis’ link of saved models after importing a project with a different project key

  * Fixed error in documentation of custom prediction API endpoints




### Charts

  * Added automatic update of the detected type when changing the processing engine

  * Fixed color palette in scatter chart when using logarithmic scale and diverging mode

  * Fixed total record counts display on 2D distribution and boxplot charts filters

  * Fixed quantiles mode in 2D distribution charts




### Webapps

  * **New feature** : “Edit in safe mode” does not load the webapp frontend or backend, in order to be able to fix crashing issues




### RMarkdown

  * Fixed truncated display in RMarkdown reports view

  * Fixed ‘Create RMarkdown export step’ scenario step when the view format is the same that the download format

  * Fixed RMarkdown attachments in scenario mails that could send stale versions of reports

  * Multi-user-security: add ability for regular users (i.e. without “Write unsafe code”) to write RMarkdown reports

  * Multi-user-security: Fixed RMarkdown reports snapshots

  * Fixed ‘New snapshot’ button on RMarkdown insight




### Dashboards

  * Fixed scrolling issue in dashboards

  * Preserve tile size when copying a tile to another slide




### Administration

  * Sort groups of a user in the user edition page

  * Fixed SMTP channel authentication when the SMTP server configuration does not allow login and password to be provided




### Misc

  * Fixed broken ‘Advanced search’ link in the search side panel

  * Fixed ‘list_articles’ method of public api python wrapper when using it on an empty wiki

  * Fixed dataset types filtering in catalog

  * Fixed long description editing of notebooks metadata

  * Fixed various display issues of items lists

  * Fixed built-in links to the DSS documentation

  * Fixed support for Dutch and Portuguese stop words in Analyze box

  * Allowed regular users (i.e. without “Write unsafe code”) to edit project-level Python libraries

  * Allowed passing the desired type of output to the ‘dkuManagedFolderDownloadPath’ R API function

  * Prevent possible memory overflow when computing metrics




## Version 5.0.0 - July 25th, 2018

DSS 5.0.0 is a very major upgrade to DSS with major new features. For a summary of the major new features, see: <https://www.dataiku.com/learn/whatsnew>

### New features

#### Deep learning

DSS now fully integrates deep learning capabilities to build powerful deep-learning models within the DSS visual machine learning component.

Deep learning in DSS is “semi-visual”:

  * You write the code that defines the architecture of your deep learning model

  * DSS handles all the rest (preprocessing data, feeding model, training, showing charts, integrating Tensorboard, …)




DSS Deep Learning is based on the Keras + TensorFlow couple. You will mostly write Keras code to define your deep learning models.

DSS Deep Learning supports training on CPU and GPU, including multiple GPUs. Through container deployment capabilities, you can train and deploy models on cloud-enabled dynamic GPUs clusters.

Please see [Deep Learning](<../../machine-learning/deep-learning/index.html>) for more information

#### Containerized execution on Docker and Kubernetes

You can now run parts of the processing tasks of the DSS design and automation nodes on one or several hosts, powered by Docker or Kubernetes:

  * Python and R recipes

  * Plugin recipes

  * In-memory machine-learning




This is fully compatible with cloud managed serverless Kubernetes stacks

Please see [Elastic AI computation](<../../containers/index.html>) for more information.

#### Wiki

Each DSS project now contains a Wiki. You can use the Wiki for documentation, organization, sharing, … purposes.

The DSS wiki is based on the well-known [Markdown](<../../collaboration/markdown.html>) language.

In addition to writing Wiki pages, the DSS wiki features powerful capabilities like attachments and hierarchical taxonomy.

Please see [Wikis](<../../collaboration/wiki.html>) for more information.

#### Discussions

You can now have full discussions on any DSS object (dataset, recipe, …). Discussions feature rich editing capabilities, notifications, integrations, …

Discussions replace the old “comments” feature.

Please see [Discussions](<../../collaboration/discussions.html>) for more information.

#### New homepage and navigation

The homepage of DSS has been revamped in order to show to each user the most relevant items.

The homepage will show recently used and favorite items first. It shows projects, dashboards and wikis, but also individual items (recipes, datasets, …) for quick deep links.

In addition, the global navigation of DSS has been overhauled, with menus, and better organization.

#### Grouping projects into folders

You can now organize projects on the projects list into hierarchical folders.

#### Dashboards exports

Dashboards can now be exported to PDF or image files in order to propagate information inside your organization more easily.

Dashboard exports can be:

  * Created and downloaded manually from the dashboard interface

  * Created automatically and sent by mail using the “mail reporters” mechanism in a scenario

  * Created automatically and stored in a managed folder using a dedicated scenario step




See [Exporting dashboards to PDF or images](<../../dashboards/exports.html>) for more information

#### Resource control

DSS now features full integration with the Linux cgroups functionality in order to restrict resource usages per project, user, category, … and protect DSS against memory overruns.

See [Using cgroups for resource control](<../../operations/cgroups.html>) for more information

### Other notable enhancements

#### Support for culling of idle Jupyter notebooks

Administrators can use the Macro “Kill Jupyter sessions” to automatically stop Jupyter notebooks that have been running or been idle for too long, in order to conserve resources.

#### Support for XGBoost on GPU

With an additional setup step, it is now possible for models trained with XGBoost to use GPUs for faster training.

---

## [release_notes/old/5.1]

# DSS 5.1 Release notes

## Migration notes

### Migration paths to DSS 5.1

>   * From DSS 5.0: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 4.3: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<4.3.html>) and [4.3 -> 5.0](<5.0.html>)
> 
>   * From DSS 4.2: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<4.3.html>) and [4.3 -> 5.0](<5.0.html>)
> 
>   * From DSS 4.1: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.1 -> 4.2](<4.2.html>) and [4.2 -> 4.3](<4.3.html>) and [4.3 -> 5.0](<5.0.html>)
> 
>   * From DSS 4.0: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<4.1.html>), [4.1 -> 4.2](<4.2.html>) and [4.2 -> 4.3](<4.3.html>) and [4.3 -> 5.0](<5.0.html>)
> 
>   * Migration from DSS 3.1 and below is not supported. You must first upgrade to 5.0. See [DSS 5.0 Release notes](<5.0.html>)
> 
> 


### How to upgrade

It is strongly recommended that you perform a full backup of your DSS data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>).

Pay attention to the warnings described in Limitations and warnings.

### Limitations and warnings

Automatic migration from previous versions (see above) is supported, but there are a few points that need manual attention.

#### Upgrade of Python packages

The following Python packages have been upgraded in the builtin environment:

  * pandas (0.20 -> 0.23)

  * numpy (1.13 -> 1.15)

  * scikit-learn (0.19 -> 0.20)

  * xgboost (0.72 -> 0.80)




The pandas dependency is also upgraded in code environments.

Importantly, the `dataiku` Python package is not compatible with pandas 0.20 anymore. You must upgrade to pandas 0.23.

#### Rebuild of code environments

Due to the upgraded dependency on pandas, it is necessary to update all previous Python code environments.

In most cases, you simply need, for each code environment, to go to the code environment page and click on the “Update” button (since the pandas 0.23 requirement is part of the base packages).

#### Retraining of machine-learning models

  * XGBoost models trained with prior versions of DSS must be retrained when upgrading to 5.1. This includes models deployed to the flow (re-run the training recipe), models in analysis (retrain them before deploying) and API package models (retrain the flow saved model and build a new package)

  * “Isolation forests” models trained with prior versions of DSS and using “In-memory” engine must be retrained when upgrading to 5.1. This includes models deployed to the flow (re-run the training recipe), models in analysis (retrain them before deploying) and API package models (retrain the flow saved model and build a new package)




#### Multi-user-security configuration file move

For improved security, the security module configuration file for Multi-User-Security has been moved from `DATADIR/security/security-config.ini` to `/etc/dataiku-security/INSTALL_ID/security-config.ini`.

DSS will automatically move the file upon upgrade, so you don’t need to perform any operation. However, any further update must be done on the `/etc/dataiku-security/INSTALL_ID/security-config.ini`. For more information, and details about INSTALL_ID, see the [MUS setup documentation](<../../user-isolation/initial-setup.html>).

#### Dashboard exports

Like with any upgrade, the Dashboards export feature must be reinstalled after upgrade. For more details, on how to reinstall this feature please see [Setting up DSS item exports to PDF or images](<../../installation/custom/graphics-export.html>)

### Support removal notice

DSS 5.1 removes support for Python 3.4. This constraint is caused by external libraries (notably pandas) that have removed the support for Python 3.4. Python 3.4 is also out of support upstream.

It is not possible to switch the version of Python used by code environments. If you have code environments using Python 3.4, you’ll need to (for each Python 3.4 code env):

  * Install Python 3.6

  * Delete the Python 3.4 code env

  * Create a Python 3.6 code env with the same name and same packages




### Deprecation notice

DSS 5.1 deprecates support for some features and versions. Support for these will be removed in a later release.

  * The prepare recipe running on the Hadoop Mapreduce engine is deprecated. We strongly advise you to use the Spark engine instead.




## Version 5.1.7 - October 30th, 2019

### Notebooks

  * Fixed usage of dataiku api when executing notebook in containers




### Performance

  * Fixed possible deadlock when using in memory login sessions




### Misc

  * Fixed suggested jupyter package version when using conda code environment in Multi User Security




## Version 5.1.6 - September 16th, 2019

### Datasets

  * Explore: Performance improvement for analyze on SQL datasets

  * Fixed various errors on S3 related to charset detection

  * Fixed wrongful inference of column length for DATE columns on Oracle




### Recipes

  * Data preparation: Fixed binning processor with decimal bins

  * Data preparation: Fixed SQL engine with step groups

  * Fixed error when translating wrongful formulas to SQL or Hive

  * Fixed setting of a column to a user-defined meaning in schema screen




### Machine learning

  * Fixed red middle line on regression error scatter plot

  * Fixed display issue when retraining models with KFold cross-test

  * Fixed display update when changing prediction type

  * Improved error handling when a saved model has no active version

  * Fixed dropping of rows in API node (non-optimized scoring)

  * Update subpopulation analysis result when binary classification threshold is modified

  * Fixed training with recalibration

  * Added ability to modify KFold cross-test option in training recipe

  * Fixed feature hashing for clustering

  * Fixed seed handling in KFold cross-test




### Hadoop & Spark

  * Added support for CDH 6.2

  * Added support for H2O Sparkling Water on Spark 2.4




### Notebooks

  * Fixed loading of libraries on notebooks running in containers




### Administration

  * Fixed erasure of LDAP groups when editing local groups of a user




### Automation

  * Fixed SQL probe with datasets with very large number of columns

  * Properly catch errors in SQL script steps

  * Added mass action on scenario steps

  * Fixed deletion of triggers

  * Added ability to set custom java.mail options on the mail reporter

  * Fixed dsscli scenario-runs-list with empty trigger names

  * Fixed default code for Python scenarios




### Performance and scalability

  * Fixed potentially blocking call when changing a storage type from “Explore” view

  * Fixed external runtime databases with very large job definitions

  * Increased maximum number of connections on nginx (fixed potential “network errors”)

  * Added automatic redirect to home article when going to wiki URL




### Misc

  * Fixed flow display in corner case

  * Fixed support for Java 11

  * Fixed 404 on meanings page




## Version 5.1.5 - July 4th, 2019

DSS 5.1.5 is a minor release. For a summary of major changes in 5.1, see below.

### Datasets

  * Fixed type detection with values like ” 12345”

  * Added safeties and warnings against deleting everything in a connection by clearing an exteranl dataset

  * Fixed rare condition where scrolling in a dataset in explore view could cause an error

  * Made Excel export more resilient to temporary files deletion

  * Fixed listing of partitions on partitioned Teradata datasets




### Hadoop & Spark

  * Added support for custom UDF in Scala recipes when used in a Spark pipeline

  * Added support for EMR 5.23

  * Fixed ability to import a project containing HDFS-uploaded data on MUS-enabled DSS

  * Fixed selection of cluster when listing fields in Hive notebooks

  * Fixed selection of cluster when creating a new Hive dataset




### Coding

  * Added the ability to write datasets from Shiny webapps and R notebooks when MUS is in use

  * Added `dkuManagedFolderPathDetails` in R API.




### API designer & deployer

  * Implemented ECR pre-push hook for easy publication of API services on EKS

  * Fixed API designer when importing foreign libraries from other projects




### Charts

  * Fixed specification of custom values in custom palettes




### Machine learning

  * Fixed deletion of model from the model page




### Data preparation

  * Fixed documentation for pseudonymization processor




### Security

  * Added encryption of LDAP password in configuration

  * Added encryption of Azure shared keys in configuration

  * Fixed XSS in the projects graph view

  * Fixed nginx configuration injection




### Misc

  * Performance and responsiveness improvements during initial data catalog indexing

  * Fixed ability to click on project name on authorization matrix

  * Fixed potential import error




## Version 5.1.4 - June 3rd, 2019

DSS 5.1.4 is a minor release. For a summary of major changes in 5.1, see below.

### Flow

  * **New feature** : Automatic mode for schema propagation tool

  * Fixed display of activity times when aborting a job




### Machine learning

  * **New feature** : Ability to duplicate a machine learning task

  * Fixed potential training failure in containerized execution mode

  * Allow setting containerized execution mode in all modes of the training recipe

  * Fixed UI in enrichments section of API designer

  * Fixed UI in “filter with formula” of the Train/Test split

  * Added partition filter when doing SQL scoring of partitioned dataset

  * Fixed scoring of ensembles if all submodels of the ensemble ignore a record

  * Features generation: Fixed interaction of Text and Categorical feature

  * Added constraint on scipy version to fix incompatibility with new versions




### Data preparation

  * **New feature** : Pseudonymization processor

  * Fixed renaming to existing column in “optimized Spark” engine

  * Fixed handling of numerical columns with empty strings in PostgreSQL engine

  * Fixed severe performance degradation with “Find/Replace” processor in “Complete value” mode with lots of replacements in SQL engine

  * Fixed display of formula errors




### Recipes

  * Sync: Properly disabled fast path from BigQuery to GCS if the BigQuery dataset is in “query” mode (instead of failing)

  * Grouping: fixed display issues when adding computed columns




### Datasets

  * Fixed ability to update schema when changing the settings of a newly-created dataset

  * Clearer error when failing to delete a Snowflake table if the schema is incorrect

  * Properly allow managed datasets on SSH/SFTP connections

  * Fixed removal of data for uploaded datasets




### Notebooks

  * Fixed 404 after copy of a notebook

  * Fixed ability to use notebooks after a project duplication

  * Fixed display of code samples when using a code environment




### Hadoop & Spark

  * Fixed user credentials for Impala

  * Fixed performance issues with Spark pipelines in some edge cases

  * Added ability to blacklist some properties when using multiple clusters and Hive (could prevent using Hive over non-HDFS filesystems)




### Automation

  * **New feature** : Ability to duplicate a scenario




### API

  * Fixed “clusters” public API

  * Fixed refresh of impersonation rules through the General settings API

  * Prevent usage of too recent requests versions that are not compatible with Dataiku API client

  * Send a proper HTTP 201 code when creating a user, group or code env




### Administration

  * Fixed sort of log files in Maintenance section

  * Fixed list of user profiles in LDAP profile mapping




### Performance and stability

  * Strong performance improvements of permissions update with large number of projects and users

  * Performance improvements for home page

  * Further performance improvements for home page in “external metadata” mode

  * Strong performance improvements for job status page for jobs with thousands of activities

  * Fixed potential instance lockup when testing partition dependencies on a non-responding dataset




### Miscellaneous

  * **New feature** : Redirect to original URL after SSO login

  * Fixed scrolling in article history

  * Wait enough time before performing dashboard export to prevent empty charts

  * Fixed moving file to a new subfolder in a managed folder

  * Improved error reporting for project duplication

  * Fixed import of bundle on automation node as non-admin if the original user didn’t exist on automation node

  * Index column descriptions in the data catalog




## Version 5.1.3 - April 11th, 2019

DSS 5.1.3 is a minor release. For a summary of major changes in 5.1, see below

### Machine learning

  * **New feature** : Subpopulation analysis - Try it in the results screen of prediction models

  * **New feature** : Ability to retain settings when changing the target variable or prediction type

  * **New feature** : Ability to copy feature handling settings across ML tasks

  * Significant performance improvements for scoring of deep learning models

  * Fixed support of recent Keras versions

  * Fixed race conditions that could cause issues with large grids

  * Fixed wrongful train and test set record counts in presence of multiline records

  * Fixed display of best hyperparameters for logistic regression

  * Fixed scoring of XGBoost models with multiclass classification

  * Fixed ability to disable a custom model

  * Fixed possible training failure when using PCA on very small datasets

  * Added support for Python 3 for tensorboard

  * Added the ability to use custom Keras objects in deep learning models

  * Faster random forest training when “skip expensive reports” is enabled

  * Fixed scoring discrepancies in XGBoost regression when using Optimized engine




### Hadoop & Spark

  * **New feature** : Added compatibility with Hortonworks HDP 3.1

  * **New feature** : Experimental support for ADLS gen2

  * **New feature** : Experimental support for Spark-on-Kubernetes with multi-user-security

  * Fixed ability to use Spark-over-S3 with a S3 dataset when the S3 connection specifies a mandatory bucket

  * Added ability to perform variable expansion in Spark configurations

  * Fixed support of ORC files with dates on Hortonworks HDP 3

  * Fixed missing “Additional JARs” field in Spark configuration UI




### Flow

  * Fixed several bugs in the “Propagate schema” tool

  * Made the “Propagate schema” tool more efficient using mass actions

  * Fixed “Check consistency” tools in presence of visual recipes running on SQL engine

  * Fixed “new webapp” dialog from the Flow

  * Fixed “Spark pipelines” Flow view with Split recipes




### Data preparation

  * Fixed “concatenate” step when ujsing prepeare-on-SQL with PostgreSQL

  * Fixed timestamp-related issues when using prepare-on-SQL with Vertica

  * Fixed failure with “String transformation” processor when using native Spark implementation

  * Fixed “cell content” popup sticking around

  * Fixed Geographical join processor when the joined dataset has missing values




### Visual recipes

  * **New feature** : Snowflake to S3 fast sync

  * Fixed issue with Pivot recipe and scientific notation

  * Fixed display of generated SQL query for split recipe

  * Fixed display issues with custom aggregations in grouping and window recipes

  * Fixed issue when removing filters in split recipe

  * Fixed HTTP/HTTPS URL at domain root in Download recipe




### Datasets & Connections

  * **New feature** : Added ability to detect charset of text files (notably UTF-16)

  * Fixed simultaneous computation of quantile and min/max metrics on Vertica

  * Fixed display of some “Column statistics” metrics

  * Improved feedback when clearing a dataset

  * Fixed “substring” filter reverting to “full string” mode




### SQL Notebooks

  * Improved auto-save to make it faster and more resilient to various operations

  * Fixed bug in error tracking across cells

  * Added more information about previous runs in cell history and cell display

  * Fixed reloading of previous run metadata when coming back to a notebook




### Coding and APIs

  * Fixed various bugs with RStudio integration

  * Fixed bug that could cause conda to destroy the Jupyter notebook server

  * Fixed warning when using Python 3.6.6 or higher

  * Fixed listing of external Git branches for Git references mistakenly requiring admin privileges

  * Added the ability to get and set the “short description” in a project’s metadata through the API

  * Added an API to create a managed dataset

  * Fixed `get_status` on `DSSCluster` in Python API client

  * Fixed ability to create conda-powered R code environments without Jupyter support




### Automation

  * Fixed attaching folder contents to a scenario email




### Security

  * Fixed CSRF issue in image and attachment uploads

  * Fixed reflected XSS issue in image upload




### API designer & API deployer

  * Fixed duplicate data when using “bundled” enrichment or lookup and multiple enrichments on the same dataset

  * Improved performance of enrichments and lookups when the project contains many datasets with many columns




### Misc

  * Improved webapp creation user experience

  * Fixed deep-linking in Wiki articles

  * Fixed saving of “Palette type” in charts

  * Added sort of groups list when granting access to a project

  * Added sort of connections list in “Run SQL” scenario step

  * Fixed detection of OpenJDK 11

  * Fixed full-screen mode on dashboard exports

  * Improved performance and scalability when deleting datasets

  * Improved performance for notebooks listing with many notebooks

  * Don’t make the navigation bar disappear when the license is expired

  * Fixed error message when entering an invalid license




## Version 5.1.2 - March 1st, 2019

DSS 5.1.2 is a minor release. For a summary of major changes in 5.1, see below

### Machine Learning

  * **New feature** : Partial dependency plots are now available for all algorithms, computable on test set

  * **New feature** : Partial dependency plots for categorical variables showing all categories at once

  * **New feature** : Ability to view distribution on partial dependency plots

  * Numerous other improvements on partial dependency plots

  * Fixed machine learning in projects importing libraries from other projects

  * Fixed edge cases leading to scoring discrepancies between engines with doubles as categories

  * Fixed display of L1/L2 regularization controls on multiclass logistic regression

  * Fixed UI bug in sample weight controls

  * Fixed UI bug in endpoints tuning controls

  * Isolation forest: added ability to set contamination parameter at a finer-grained level

  * Fixed optimized scoring of XGBoost models with gamma objective function

  * Fixed wrong grid search scores display with class weights




### Collaboration

  * **New feature** : Added ability to always go back to the last home screen (home, all projects, all dashboards, …)

  * Improved error reporting when reading datasets with wrong cross-project permissions

  * Added delay before sending Wiki notifications to Slack/… to avoid sending too many notifications

  * Fixed registration of Enterprise trial

  * Fixed “list branches” button for non-admins




### Coding

  * Fixed various issues with new “using Python API outside of DSS” capabilities




### Spark & Hadoop

  * Fixed cross-project Spark pipelines

  * Fixed class loading issue on CDH 6.0.1




### Flow

  * Strongly improved “computing dependencies” performance for forced recursive build of complex flows




### Data visualization

  * Added remembering of zoom level in map charts




### Scenarios

  * Fixed computation issue in temporal triggers that could cause scenarios to stop triggering

  * Added a warning when leaving a scenario page with unsaved changes




### Datasets

  * Added support for Greenplum 5.0

  * Fixed percentile metrics with SparkSQL engine




### Recipes

  * Fixed failures in prepare recipe in some specific formula cases

  * Fixed issue with external Teradata datasets containing dates in visual recipes

  * Added support for single-file inputs in S3-to-Snowflake fast path




### Containers

  * Fixed containerized Python kernels on Python 3 code environments

  * Fixed containerized Python recipe execution when code contains non-ASCII string literals

  * Fixed interrupt of containerized Jupyter kernels

  * Fixed support for EKS ingress for API node deployments with load balancer




### Security

  * Added protection against filesystem access through SQLite or H2 connections

  * Fixed possible leak of dataset data in frontend log files

  * Fixed possible code execution through malicious project imports




## Version 5.1.1 - February 13th, 2019

DSS 5.1.1 is a minor release. For a summary of major changes in 5.1, see below

### Machine learning

  * Fixed error in Isolation forest when no anomaly was found

  * Fixed support for calibration in K-Fold cross-test mode

  * Fixed training recipes in “train on 100% of the data” mode

  * Fixed possible error when training on containers




### Datasets

  * Fixed a display issue in metrics

  * A metrics dataset showing checks will now be named “_checks”

  * Fixed computation of percentile metrics on Spark




### Webapps

  * Improved the default code sample for standard webapps

  * Fixed Shiny plugin webapps

  * Fixed permissions when copying a webapp




### Hadoop & Spark

  * **New feature** : Added support for CDH 6.1

  * **New feature** : Added experimental support for Spark 2.4

  * Added special option to handle cases where the Hive staging dir is in a non-standard location




### Wiki

  * **New feature** : Added automatic generation of a table of contents to Wiki articles

  * Fixed contributor tooltips

  * Improved Git commit messages for Wiki actions

  * Improved notifications for article renamings

  * Added ability to remove attachments in folder view

  * Added automatic scroll in the taxonomy when opening a Wiki page

  * Fixed update of the timeline after a save

  * Fixed links to items when changing the key of a project (through export/import)




### API node

  * Fixed issue with enrichments in custom R prediction endpoints




### Code

  * Fixed container execution that could fail depending on the number of cores of the machine / number of recipes being run

  * Fixed container execution of recipes when running on a code environment without Jupyter support

  * Fixed container execution with code environments on automation node

  * Fixed warnings when reading datasets in R

  * Fixed notebooks when importing libraries from other projects

  * Improved default package sets for conda, no more requiring external repositories

  * Added missing exported functions in the R package




### Collaboration

  * Added default template to the Slack reporter

  * Fixed error appearing after pushing a project to Git remotes

  * Improved highlighting in the new Jobs UI

  * Fixed timer in Jobs UI




### Security

  * Enforced connections permissions on “Execute SQL” scenario steps

  * Fixed XSS vulnerabilities

  * Fixed possible file tampering through visual recipes

  * Fixed SQL injection in Metrics datasets

  * Fixed vulnerability in license registration workflow




### Misc

  * Improved auto-generated titles on some charts

  * Fixed version number on login page

  * Fixed dead documentation links




## Version 5.1.0 - January 29th, 2019

DSS 5.1.0 is a very major upgrade to DSS with major new features.

### New features

#### Git integration for plugins editor

The plugin editor now features full Git integration, allowing you to view the history of a plugin, revert changes, and to push and pull changes from a remote Git repository.

For more details, please see our [tutorial](<https://knowledge.dataiku.com/latest/plugins/development/tutorial-version-management-git.html>) and [reference](<../../plugins/reference/git-editor.html>).

#### Import code libraries from Git

In the library editor of each project, you can now import code from external Git repositories. For example, if you have code that has been developed outside of DSS and is available in a Git repository (for example, a library created by another team), you can import this repository (or a part of it) in the project libraries, and use it in any code capability of DSS (recipes, notebooks, web apps, …).

This code can then be updated from the external Git repository, either manually or automatically.

For more details, please see our [tutorial](<https://knowledge.dataiku.com/latest/code/shared/tutorial-git-repo-clone.html>) and [reference](<../../collaboration/import-code-from-git.html>).

#### More code reuse capabilities

Combined with the ability to import code libraries from Git, new features for code reuse have been added:

  * R code can now use per-project libraries, just like Python code.

  * For both Python and R code, you can now have multiple libraries folders per project

  * For both Python and R code, you can now use the libraries of one project in another project




For more details, please see [reusing Python code](<../../python/reusing-code.html>) and [reusing R code](<../../R/reusing-code.html>)

#### Prepare recipe in-database (SQL)

A subset of preparation processors can now be translated to SQL queries. When a prepare recipe contains translatable processors, it can be executed fully in-database, which can provide speed-ups up to hundreds of times.

For more details, please see [Execution engines](<../../preparation/engines.html>).

#### Lightning-fast prepare recipe on Spark

DSS now includes a new engine for data preparation on Spark that can provide significant performance boosts.

A subset of preparation processors are compatible with the optimized Spark engine, which will be used automatically whenever possible. When non-compatible processors are present, DSS automatically falls back to the previous engine.

For more details, please see [Execution engines](<../../preparation/engines.html>).

#### Containerized execution of notebooks

Notebooks (Python and R) can now be run in Docker and Kubernetes

For more details, please see [Containerized notebooks](<../../notebooks/containerized-notebooks.html>).

#### GDPR capabilities

A new plugin allows you to enforce a number of GDPR-related rules on projects:

  * Track which datasets and projects contain personal data

  * Enforce rules on how datasets containing personal data can be used (exported, used for machine learning, shared, …)

  * Propagate “personal data” flags when creating new datasets

  * Track purpose and consent for datasets




For more details, please see our [tutorial](<https://knowledge.dataiku.com/latest/use-cases/plugins/gdpr/tutorial-index.html>) and [the plugin page](<https://www.dataiku.com/dss/plugins/info/gdpr.html>).

#### Databricks

DSS now features an experimental and limited integration with Databricks to leverage Databricks as a Spark execution engine. Please contact your Dataiku Account Executive for more details.

#### Web apps as plugins

Web apps can now be turned into plugins. This allows you to have reusable and instantiable web apps.

Some use cases notably include making custom visualizations for datasets.

For more details, please see our [tutorial](<https://knowledge.dataiku.com/latest/plugins/example-components/tutorial-example-webapp.html>) and [reference](<../../plugins/reference/webapps.html>).

#### Use Dataiku libs and develop code outside of DSS

You can now use the Dataiku Python and R libraries outside of DSS in order to develop code for DSS (recipes, webapps, …) outside of DSS and in your favorite IDE.

For more details, please see [using Python API outside of DSS](<https://developer.dataiku.com/latest/tutorials/devtools/python-client/index.html> "\(in Developer Guide\)") and [using R API outside of DSS](<../../R-api/outside-usage.html>)

#### Folding the Flow view

You can now [hide parts of the Flow](<../../flow/folding.html>) in order to improve the readability of very large flows. You can easily hide all parts of a flow upstream/downstream of a single node.

#### External hosting of runtime databases

DSS maintains a number of databases, called the “runtime databases” that store some additional information, which is mostly “non-primary” information (i.e. which can be rebuilt), like history of jobs, metrics, state of datasets, timelines, discussions, …

By default, the runtime databases are hosted internally by DSS, using an embedded database engine (called H2). You can also move the runtime databases to an external PostgreSQL server. Moving the runtime databases to an external PostgreSQL server improves resilience, scalability and backup capabilities.

For more details, please see [The runtime databases](<../../operations/runtime-databases.html>).

#### Exporting the Flow as an image

You can now export the Flow of a project as an image or a PDF.

For more details, please see [Exporting the Flow to PDF or images](<../../flow/graphics-export.html>).

#### Probability calibration

When training a classification model, you can now choose to apply a calibration of the predicted probabilities.

The purpose of calibrating probabilities is to bring the actual frequency of classes occurrence as close as possible to the predicted probability of such occurrence.

For more details, please see [Prediction settings](<../../machine-learning/supervised/settings.html>).

#### Models export as PMML and POJO

You can now export a trained model as a PMML file for scoring with any PMML-compatible scorer.

You can also export trained models as a set of Java classes for extremely efficient scoring in any JVM application.

For more details, please see [Exporting models](<../../machine-learning/models-export.html>).

#### Duplicate projects

You can now easily [duplicate a DSS project](<../../concepts/projects/duplicate.html>), optionally duplicating the content of some datasets.

#### RStudio integration

In addition to the ability to [use the DSS R API outside of DSS](<../../R-api/outside-usage.html>), DSS now features several integration points with RStudio:

  * Ability to develop code for DSS (recipes, …) directly in RStudio

  * RStudio Desktop/Server addins for easy connection to DSS and download/upload of recipes

  * Embedding of the RStudio Server UI in DSS

  * Easy configuration of RStudio Server for connection with DSS




For more details, please see our [how-to](<https://knowledge.dataiku.com/latest/code/work-environment/how-to-rstudio.html>) and [reference](<../../R/rstudio.html>).

### Other notable enhancements

#### Copy-paste preparation steps

You can now [copy and paste preparation steps](<../../preparation/copy-steps.html>), either within a single preparation recipe or across preparation recipes, or even across DSS instances.

#### Copy-paste scenario steps

You can now [copy and paste scenario steps](<../../scenarios/copy-steps.html>), either within a single scenario or across scenarios, or even across DSS instances.

#### Support for CDH 6

DSS now supports CDH 6.0 and 6.1

For more details, please see [Cloudera CDH](<../../hadoop/distributions/cdh.html>)

#### New capabilities for Snowflake

DSS now supports a fast-path to sync from S3 to Snowflake.

For more details, please see [Snowflake](<../../connecting/snowflake.html>).

#### Setting distribution / primary index on Teradata, Redshift and Greenplum

Additional options are now available for these databases:

  * Ability to control the [primary index for Teradata datasets](<../../connecting/sql/teradata.html>)

  * Ability to control the [distribution keys for Greenplum datasets](<../../connecting/sql/greenplum.html>)

  * Ability to control the [distribution and sort keys for Redshift datasets](<../../connecting/redshift.html>)




#### Support for impersonation on Teradata

You can now use the “proxyuser” mechanism of Teradata to impersonate end-users for all database access.

For more details, please see [Teradata](<../../connecting/sql/teradata.html>)

#### Support for custom query banding on Teradata

In order to provide for better audit, it can be interesting to add in the Query band of your Teradata queries information about the queries that are being performed.

DSS now lets you easily do that and track which users and jobs, … perform Teradata queries.

For more details, please see [Teradata](<../../connecting/sql/teradata.html>).

#### More ability to use remote Git repositories

In addition to the ability to [use Git for plugin development](<../../plugins/reference/git-editor.html>) and to [import code libraries from Git](<../../collaboration/import-code-from-git.html>), including ability to use remotes, using remotes for [project version control](<../../collaboration/version-control.html>) will now work in all cases where the regular Git command line works.

#### More graceful handling of wide SQL tables

When reading external SQL tables, DSS will now fetch the exact size of string fields and propagate them to the table definition, in order to make for smaller downstream datasets.

With some databases like MySQL or Teradata that limit the total size of the row, DSS will now more gracefully warn you of possible incompatibilities instead of preventing some recipes creations.

#### Per-project libraries for R

Support for per-project libraries has been added for R (just like for Python).

#### New Jobs UI

The Jobs UI has been redesigned and now includes a greatly enhanced Flow view to help you understand at a glance what a job is doing and how that interacts with other jobs.

#### New APIs

New APIs (REST and Python) have been introduced to:

  * [Query the status and engines of recipes](<https://developer.dataiku.com/latest/api-reference/python/recipes.html> "\(in Developer Guide\)")

  * [Import Hive and SQL tables from connections to DSS datasets](<https://developer.dataiku.com/latest/api-reference/python/tables-import.html> "\(in Developer Guide\)").




#### Java 11

DSS now supports Java 11.

### Other enhancements and fixes

#### Visual recipes

  * The join recipe now supports < and > operators (in addition to <= and >=)




#### Datasets

  * A potential memory overrun when listing too many partitions has been fixed

  * GCS: Fixed issue with datasets whose size was a multiple of 4MB

  * “Cell value” metric now works properly even in the presence of other metrics

  * Reduced the number of “getBucketLocation” AWS API calls

  * Added support for XLSM files




#### Code

  * It is now possible to use datasets in a Python or R recipe, even if they are not declared as inputs or outputs. For example:



    
    
    dataset = dataiku.Dataset("mydataset_that_is_not_in_input", ignore_flow=True)
    df = dataset.get_dataframe()
    

  * Various bugs on SQL code formatter have been fixed




#### Data preparation

  * CJK characters can now be used as literals in the Python processor




#### Dashboards

  * It is now possible to export dashboards on a machine without outgoing Internet connection (after initial setup)




#### Machine learning

  * Don’t try to use Optimized scoring when a custom text preprocessing is in effect

  * It is now possible to tune the scoring batch size when using the Local (Python) engine for scoring




#### Misc

  * Clear job logs macro now removes the job folders instead of just emptying them

  * It is now possible to run a DSS UI that does zero connections to the outside world

---

## [release_notes/old/6.0]

# DSS 6.0 Release notes

## Migration notes

### Migration paths to DSS 6.0

>   * From DSS 5.1: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 5.0: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.0 -> 5.1](<5.1.html>)
> 
>   * From DSS 4.3: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.3 -> 5.0](<5.0.html>) and [5.0 -> 5.1](<5.1.html>)
> 
>   * From DSS 4.2: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>) and [5.0 -> 5.1](<5.1.html>)
> 
>   * From DSS 4.1: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.1 -> 4.2](<4.2.html>), [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>) and [5.0 -> 5.1](<5.1.html>)
> 
>   * From DSS 4.0: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<4.1.html>), [4.1 -> 4.2](<4.2.html>), [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>) and [5.0 -> 5.1](<5.1.html>)
> 
>   * Migration from DSS 3.1 and below is not supported. You must first upgrade to 5.0. See [DSS 5.0 Release notes](<5.0.html>)
> 
> 


### How to upgrade

It is strongly recommended that you perform a full backup of your DSS data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>).

Pay attention to the warnings described in Limitations and warnings.

### Limitations and warnings

Automatic migration from previous versions (see above) is supported, but there are a few points that need manual attention.

#### Graphics exports

Like with any upgrade, the graphics export feature (exporting Flow or dashboards) must be reinstalled after upgrade. For more details, on how to reinstall this feature please see [Setting up DSS item exports to PDF or images](<../../installation/custom/graphics-export.html>)

#### Models grid search behavior change

DSS 6.0 introduces a minor upgrade to scikit-learn which fixes a bug in the model selection feature. In some rare cases, this can cause grid searching to select a different hyperparameter value when retraining a model on the same data. For more details, please see <https://scikit-learn.org/stable/whats_new/v0.20.html#sklearn-model-selection>

### Support removal notice

As previously announced, DSS 6.0 removes support for the prepare recipe running on the Hadoop Mapreduce engine. We strongly advise you to use the Spark engine instead.

### Deprecation notice

DSS 6.0 deprecates support for some features and versions. Support for these will be removed in a later release.

  * Pig support is deprecated. We strongly advise you to migrate to Spark.

  * Support for Spark 1 (1.6) is deprecated. We strongly advise you to migrate to Spark 2. All Hadoop distributions can use Spark 2.

  * Conditional outputs on binary classification models are deprecated.




## Version 6.0.5 - February 25th, 2020

DSS 6.0.5 is a bugfix release. For a summary of major changes in 6.0, see below

### Automation

  * Fixed “Triggers” view




### Collaboration

  * Fixed display of object types in catalog




### Security

  * Fixed [CVE-2020-8817](<../../security/advisories/cve-2020-8817.html>): Ability to tamper with creation and ownership metadata

  * Fixed [CVE-2020-9378](<../../security/advisories/cve-2020-9378.html>): Directory traversal vulnerability in Shapefile parser




## Version 6.0.4 - February 4th, 2020

DSS 6.0.4 is a minor release. For a summary of major changes in 6.0, see below

### Datasets

  * Fixed metrics computation on SQL query datasets




## Version 6.0.3 - January 21th, 2020

DSS 6.0.3 is a minor release. For a summary of major changes in 6.0, see below

### Datasets

  * **New Feature** Support for creating natively partitioned BigQuery datasets

  * Better support of uploaded dataset with very large number of files

  * Fixed browsing of exposed managed folders (Now properly redirects to the target project)

  * Fixed unpartitioning of Elasticsearch datasets

  * Fixed bad meaning detection of very low numbers (wrongfully detected as “Longitude”)

  * Added support for STS credentials for S3 connections with EMRFS interface




### Recipes

  * Fixed possible error on window recipe when using date range and DSS engine on datasets with empty cells

  * Removed DSS engine on prepare recipe when input and output are on BigQuery

  * Fixed DSS formula “modulo” function on BigQuery engine

  * Made dataiku.get_connection() API usable in Python recipes

  * Fixed find and replace shortcut on code editors




### Plugins

  * **New feature** Improved support of python-code based ‘SELECT’ plugin parameter

  * Fixed progress reporting of macros provided by plugins

  * Fixed auto-generated plugin description file when converting a code recipe to a plugin

  * Fixed ‘MANAGED_FOLDER’ and ‘SAVED_MODEL’ plugins parameter types

  * Fixed plugin store URL in the ‘New recipe’ drop down

  * Add possibility for plugin recipes targeting folder to be visible in the right panel

  * Fixed search in the plugin store page




### ML

  * Fixed possible race condition when running scoring recipes inside containers

  * Fixed usage of ensemble model on the automation node

  * Fixed migration of train recipes that made the underlying model unusable by evaluate recipes

  * Fixed partitioned models when all targets in the test set are equal to 0

  * Clarified some help messages on calibration and time ordering

  * SQL pipeline can now be used for partitioned models scoring

  * Fixed Javascript error when opening a train recipe that has been run before 6.0

  * Improved variable choice UI for time-based ordering in visual ML




### Collaboration

  * **New Feature** Added a Microsoft Teams integration for project events

  * **New Feature** Add mathematical formula support in the wiki (using Mathjax)

  * Fixed possibility to reference DSS object in To do lists




### Performance

  * Improved catalog performance and fixed possible instance hang for certain “killer queries”

  * Fixed race condition when using sync recipe on uploaded datasets with underlying cloud-based storage




### Code environment and container execution

  * Fixed creation of R code environments with Jupyter when using Python 3 for builtin env

  * Fixed build of Docker base image

  * Fixed “Remove old container images” macro when builtin env uses Python 3




### Flow

  * Smarter display in the right panel of available plugin recipes when datasets are selected




### Cluster

  * Fixed possible error when setting default cluster for a project

  * Administrator can now add/attach clusters from administration settings on a remote API Deployer




### SSO

  * **New Feature** Added possibility to redirect to a custom page after logout

  * Added support for IdP metadata with multiple signing certificate




### Misc

  * **New Feature** Contextual right panel is now available on most DSS components

  * Fixed “safe mode” edition of webapps

  * Fixed drag-and-drop reordering of dashboard slides

  * S3 and HDFS managed folder are now usable on scenario reporter attachments




## Version 6.0.2 - December 5th, 2019

DSS 6.0.2 is a minor release. For a summary of major changes in 6.0, see below

### Kubernetes

  * **New feature** Added support of managed Kubernetes clusters for use with Model API Deployer




### Charts

  * Fixed usage of ‘day of week’ when using SparkSQL chart engine on old Spark versions (<2.3)




### Dataset

  * Fixed wrong display of the tooltip for the “count of records” metric

  * Fixed a bug on MongoDB and Cassandra datasets that could not be easily unpartitioned after being partitioned

  * Fixed “Files from folder” datasets when the underlying folder targets a cloud-based connection (Azure Blob, S3, GCS)

  * Fixed dataset mass import when hadoop standalone integration has been run




### Security

  * Make the SSL ciphers recommended option available on the API node




### Flow

  * Improved update of flow after mass importing datasets




### Administration

  * Fixed displayed value of maximum mail attachments size in SMTP messaging channel settings




### Coding recipes

  * Fixed issue on python recipe when using docker execution and libraries importing the ‘code’ python builtin module




### Visual recipes

  * Fixed split recipe random subsets mode when using splitting proportions below 10%

  * Improved timezone management when using date formatter preparation step on SQLServer




### Dashboards

  * Fixed migration of wiki tiles in dashboards

  * Fixed display issue of metric tooltips on Firefox

  * Fixed current displayed label on animated charts




### Machine learning

  * Improved reproducibility of results using feature reduction preprocessing with python 3

  * Improved reproducibility of results of DBSCAN and Isolation Forest clustering algorithms

  * Improved feature handling copy capabilities when working on a copied analysis

  * Fixed possible non display of grid search curves

  * Fixed non java compatible models deployment when model partitioning is enabled

  * Fixed metric computation on partitioned models when the ‘pearson’ metric is not available for one of the trained models

  * Fixed creation of non-partitioned datasets when creating scoring recipes based on partitioned input datasets

  * Fixed scoring recipe when the dataset to score only contains 1 row




### Plugins

  * **New feature** make ‘DATASET_COLUMN’ and ‘DATASET_COLUMNS’ plugin parameter types available for checks and metrics

  * Fixed possible error when uploading an update for a plugin which does not exist




### Web apps

  * Put back the ‘run as user’ settings on non User Isolation Framework (previously MUS) installations




## Version 6.0.1 - November 6th, 2019

DSS 6.0.1 is a minor release. For a summary of major changes in 6.0, see below

### Collaboration

  * Fixed non visible discussions on articles after migration




### Visual recipes

  * Add ability to rename columns when using SQL pipelines

  * Fixed S3 to Redshift fast path on S3 partitioned datasets

  * Improved support of customized metastore table name of non HDFS datasets when using Spark engine




### Coding

  * Make the dkuManagedFolderCopyToLocal R function recursive

  * Fixed dkuManagedFolderCopyFromLocal R function which ignored beginning of each copied file




### Webapps

  * Fixed Bokeh webapps that always reused the same port




### Misc

  * Fixed possible issue when accessing a non existing table using the DSS internal metastore




### Plugins

  * Fixed plugin recipes using dynamically-filled dropdowns




## Version 6.0.0 - October, 24th, 2019

DSS 6.0.0 is a major upgrade to DSS with major new features.

### New features

#### Managed Kubernetes clusters

DSS can automatically start, stop and manage for you multiple clusters running on the major cloud providers. This makes it very seamless to deploy Kubernetes clusters with very low setup and administration work.

DSS provides managed Kubernetes capabilities on:

  * Amazon Web Services through [EKS](<../../containers/eks/index.html>)

  * Azure through [AKS](<../../containers/aks/index.html>)

  * Google Cloud Platform through [GKE](<../../containers/gke/index.html>)




For more details, please see [Managed Kubernetes clusters](<../../containers/managed-k8s-clusters.html>) and [DSS in the cloud](<../../cloud/index.html>)

#### Managed Spark on Kubernetes

DSS can now automatically manage deployment of Spark jobs on Kubernetes. This includes automatically setting up connectivity to cloud storages, building container images, handling multiple code environments, providing security and isolation.

Thanks to this feature, you can now deploy Spark jobs on a unified Kubernetes infrastructure, handling both Spark and non-Spark jobs. Multiple Kubernetes clusters are supported.

For more details, please see [DSS and Spark](<../../spark/index.html>) and [DSS in the cloud](<../../cloud/index.html>)

#### Partitioned models

DSS can now build partitioned models, that is, train a separate model for each partition of an input dataset. Training separate models (also sometimes referred to as “stratified models”) is useful when you expect data to be significantly different between partitions, or when you need incrementality. For example, you may want to train one model per country, per business unit, per factory, …

Once trained, partitioned models can be used to score other partitioned data, or unpartitioned data containing partition identifiers. For more information, see [Partitioned Models](<../../machine-learning/partitioned.html>).

#### Time series visualization

DSS now includes a dynamically zoomable line chart for time series.

For more details, please see [Time Series](<../../time-series/index.html>)

#### New plugins experience

The plugins store has a brand new look, allowing you to find plugins much more easily.

We have also strongly improved the plugin installation experience, with guided steps to install plugins, code envs and other dependencies.

The plugin development experience has been overhauled for better productivity.

Plugins now feature a predefined parameters system, which allows you to reuse parameters between plugins, and to have sensitive information for plugins managed by the administrator.

For more details, please see [Plugins](<../../plugins/index.html>)

#### Support for AWS Athena and Glue metastore

DSS now supports experimental connection with AWS Athena. This connection provides the following capabilities:

  * Running interactive SQL notebooks on Athena based on previously-built S3 datasets

  * Using Athena as charts engine for S3 datasets

  * Running SQL queries on Athena based on previously-built S3 datasets (execution and data read through Athena, write through DSS)




DSS also adds support for leveraging AWS Glue as a metastore catalog.

For more details, please see [DSS in AWS](<../../cloud/aws/index.html>) (overview, reference architecture), [AWS Athena](<../../connecting/sql/athena.html>) and [Glue metastore](<../../metastore/glue-metastore.html>) (details).

#### SQL pipelines

DSS provides pipeline functionality for a flow that uses a SQL engine and consists of consecutive recipes sharing the same connection. SQL pipelines can minimize or avoid unnecessary writes and reads of intermediate datasets in a flow, thereby boosting workflow performance.

For more details, please see [SQL pipelines in DSS](<../../sql/pipelines/index.html>).

#### Global search toolbar

A new unified contextual search toolbar has been added to the DSS navigation bar. Use it for contextual search in project objects, wikis, help topics, and much more

#### Pluggable algorithms

You can now add custom algorithms for the in-memory Visual ML component as plugins, making them available without any code.

For more details, please see [Component: Prediction algorithm](<../../plugins/reference/prediction-algorithms.html>).

#### Pluggable webapps

Webapps can now be packaged as plugins, shared and reused.

For more details, please see [Component: Web Apps](<../../plugins/reference/webapps.html>).

#### Pluggable chart types

New chart types can now be packages as plugins, shared and reused.

#### Pluggable custom view for folders and models

Managed folders and models now support a concept of pluggable custom views. Use cases can include:

  * A custom view representing the content of a folder (for example, a neural network visualizer)

  * A custom view on the results of a saved model (for example, to display interpretability results)




#### Time series preparation

DSS provides a preparation plugin that includes visual recipes for performing the following operations on time series data:

  * Resampling into equispaced time intervals

  * Performing analytics functions over a moving window

  * Extracting aggregations around a global extremum

  * Extracting intervals where values lie within an acceptable range




This plugin is fully supported by Dataiku. For more details, please see [Time series preparation](<../../time-series/time-series-preparation/index.html>).

#### Native Python processor in preparation

The Python processor in data preparation can now use a real Python process, which allows usage of Python 3 and of any additional package through the usage of the DSS code environments feature.

The Python processor now supports vectorized operation using Pandas for fast operation.

For more details, please see [Python function](<../../preparation/processors/python-custom.html>)

#### Scenario reporting to Microsoft Teams

Scenarios can now report on completion and custom events to Microsoft Teams.

### Other notable enhancements

#### Improved project folders

The project folders feature has been strongly enhanced with the following capabilities:

  * Drag & drop to add folders in projects on the “projects list” page

  * Ability to view project folders on the personalized home page

  * Security on project folders

  * Ability to have empty project folders

  * Per-folder view of the graph of projects




#### Time-aware cross-validation and evaluation

When running prediction tasks on time-oriented datasets (for example, a daily sales dataset), it is useful to use time-aware cross-validation for optimizing and evaluating your model. This allows you to ensure that by only looking at past data, your model is able to adequately predict future data.

For more details, please see [Advanced models optimization](<../../machine-learning/advanced-optimization.html>).

#### Enhanced Snowflake integration

Thanks to the new native Spark integration, you can now directly access Snowflake datasets in any Spark-powered recipe (either visual or code). This leverages the native Spark Snowflake connector for optimal performance.

In addition, the Sync recipe can now perform fast synchronization between Azure Blob and Snowflake datasets.

For more details, please see [Snowflake](<../../connecting/snowflake.html>)

#### ADLS gen2 support in Azure dataset

The Azure dataset now supports access to data using ADLS gen2

#### Python 3 support for base env

It is now possible to use Python 3 as the builtin environment of DSS.

Note that we do not currently recommend migrating existing instances to this mode due to the need to ensure that all user code using the builtin environment is compatible with Python 3.

#### New field types for plugins

Plugin components can now declare string lists, dates, and many other new kinds of fields.

For more details, please see [Parameters](<../../plugins/reference/params.html>)

#### Redesigned contextual right panel

The right column panel available in Flow, objects lists and object actions has been redesigned to provide faster and more efficient access to the most common actions and information.

#### Support for HANA Calculation views

The HANA support can now list and read calculation views. The connection explorer can automatically filter by HANA package.

#### Managed standalone Hadoop libraries

Dataiku now provides fully-managed standalone Hadoop and Spark libraries, allowing full support for Parquet, ORC, S3, ADLS gen1 and gen2, GS, … without any cluster or 3rd party integration required

#### More native support for Amazon ECR

DSS now natively handles ability to push images to Amazon ECR, removing need for a custom script

### Other enhancements and fixes

#### Hadoop & Spark

  * Added ability to access shared datasets in Pyspark notebooks

  * Added ability to select Hive runtime configuration for exploration and direct read through DSS




#### Datasets & file formats

  * Added support for ElasticSearch 7

  * Added ability to support ElasticSearch mapping type _doc

  * Added ability to rename columns when importing an Excel file

  * Fixed Snowflake synchronization failure with special characters

  * Fixed Excel export when running on Java 11

  * Fixed reading of booleans in Excel files

  * Fixed “click to configure” button on “Analyze on full data”




#### Data preparation

  * Added SQL compatibility for the “Round” processor




#### Flow

  * Added support for Spark engine on SQL input datasets




#### Visual recipes

  * Split recipe: fixed “drop data” in random dispatch mode on Spark engine

  * Sort recipe: fixed on MS SQL Server

  * Sync recipe: improved S3 to Redshift fast-path on partitioned datasets




#### Notebooks

  * Automatically install by default Jupyter kernels for containerized execution when updating a code env




#### Machine learning

  * Fixed UI of prediction and clustering recipes when running on HDFS datasets

  * Better variables ordering for Partial Dependencies Plot

  * Added subsampling on Partial Dependencies Plot and Subpopulation Analysis for faster results

  * Improved performance of Deep Learning training

  * Added support for Partial dependencies and subpopulation analysis on containers

  * Fixed possible non-stability across trainings when using Python 3

  * Added error percentage as a metric that can be output as part of the evaluation recipe




#### Webapps

  * Fixed issues when exporting/importing projects containing webapps




#### Automation

  * Added support for variables expansion in SQL triggers

  * Added ability to execute or not, and to create new exports or not when attaching Jupyter notebooks to mails




#### Collaboration

  * Fixed sending of Slack notifications on job builds

  * Added back “description icon” on Flow




#### Reliability & Scalability

  * Improved Oracle insertion performance in presence of NULL values

  * Fixed potential issues while reading enormous log files




#### Security

  * Fixed and clarified issues with code env permissions




#### API

  * Added ability to terminate a cluster through Python API

  * Fixed ability to update R code environments through API

---

## [release_notes/old/7.0]

# DSS 7.0 Release notes

## Migration notes

### Migration paths to DSS 7.0

>   * From DSS 6.0: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 5.1: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>)
> 
>   * From DSS 5.0: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>)
> 
>   * From DSS 4.3: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>)
> 
>   * From DSS 4.2: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>)
> 
>   * From DSS 4.1: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.1 -> 4.2](<4.2.html>), [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>)
> 
>   * From DSS 4.0: In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<4.1.html>), [4.1 -> 4.2](<4.2.html>), [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>)
> 
>   * Migration from DSS 3.1 and below is not supported. You must first upgrade to 5.0. See [DSS 5.0 Release notes](<5.0.html>)
> 
> 


### How to upgrade

It is strongly recommended that you perform a full backup of your DSS data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>).

Pay attention to the warnings described in Limitations and warnings.

### Limitations and warnings

Automatic migration from previous versions (see above) is supported, but there are a few points that need manual attention.

#### Fix for typed variables in Python

In DSS 5.1 and 6.0, a regression affected dataiku.get_custom_variables(typed=True). This regression was fixed in DSS 7.0, so variables typing will be restored. This may affect workarounds that you may have setup in order to work around the regression.

#### “origin” as remote name

DSS 7.0 introduces a new Git integration for projects, with vastly enhanced features like multiple branches and pulling from Git remotes.

In order to introduce this, DSS 7.0 also introduces a unified name for Git remotes. DSS will now only consider the remote named “origin” (the “standard” Git naming). As a result, if you had already added Git remotes with a different name, you may need to re-add it to your projects, following the instructions in [Version control of projects](<../../collaboration/version-control.html>).

### Deprecation notice

DSS 7.0 deprecates support for some features and versions. Support for these will be removed in a later release.

  * Support for “Hive CLI” execution modes for Hive is deprecated and will be removed in a future release. We recommend that you switch to HiveServer2. Please note that “Hive CLI” execution modes are already incompatible with User Isolation Framework.

  * Support for Microsoft HDInsight is now deprecated and will be removed in a future release. We recommend that users plan a migration toward a Kubernetes-based infrastructure.

  * Support for Machine Learning through Vertica Advanced Analytics is now deprecated and will be removed in a future release. We recommend that you switch to In-memory based machine learning models. In-database scoring of in-memory-trained machine learnings will remain available.

  * Support for Hive SequenceFile and RCFile formats is deprecated and will be removed in a future release.

  * As a reminder from 6.0, support for Spark 1 (1.6) is deprecated. We strongly advise you to migrate to Spark 2. All Hadoop distributions can use Spark 2. Support for Spark 1 will be removed in DSS 8

  * As a reminder from 6.0, support for Pig is deprecated. We strongly advise you to migrate to Spark.




## Version 7.0.3 - July, 15th, 2020

DSS 7.0.3 is a bug fix release. For a summary of major changes in 7.0, see below

### Elastic AI

  * AWS: Fixed support of push to ECR when using AWS CLI version 2

  * Fixed “Use Hadoop delegation tokens” checkbox

  * Fixed race conditions with Kubernetes when creating large amounts of pods or on highly loaded clusters




### Data preparation and ETL

  * Fixed issues with SQL translation of “Find and replace” and other steps

  * Fixed inconsistent display of the Analyze box action buttons

  * Fixed sort recipe on Teradata




### Automation

  * Fixed deleted recipes still sometimes appearing in Flow after bundle switch

  * Fixed Python porobes on managed folders

  * Fixed export table button on metrics column view




### Statistics

  * Improved UX for the PCA card




### Collaboration and Flow

  * Fixed error sending notifications when a user is mentioned in a discussion

  * Fixed right-column display of plugin recipes when selecting multiple items in the Flow

  * Fixed building of multiple datasets from datasets list

  * Fixed zoom issues on Flow




### Coders experience

  * Fixed code samples UI for Jupyter

  * Fixed editor height for RMarkdown




### Machine Learning

  * Fixed inconsistent behavior of the “Publish” button

  * Fixed blank partial dependencies plots with special characters in column names

  * Fixed listing of columns for time-aware split if a column was removed by the preparation script

  * Fixed retraining of ensemble models with some specific processing such as feature reduction

  * Fixed creation of evaluation recipes based on datasets with per-user credentials

  * Fixed deep learning with Python 3

  * Fixed display of hyperparameter table




### Data Visualization and dashboards

  * Fixed line charts being cropped or disappearing in dashboards

  * Fixed exporting of dashboards on macOS

  * Fixed broken format on dashboard export (abnormal margins and page splits)




### Datasets

  * Fixed creation of partitioned external datasets on ElasticSearch

  * Improved errors for Spark on Snowflake datasets with bad parameters




### Security

  * Fixed passwords visible in logs when using presets in “manually defined” mode




### Misc

  * Fixed inconsistent author names in `dss_commits` internal dataset

  * Fixed `dsscli project-import` with a Python 3.6 base env

  * Added ability to select plugin recipes directly from a saved model

  * Fixed deletion of saved model from the Flow with drop data enabled

  * Added a sanity check for proper install dir permissions with UIF




## Version 7.0.2 - April, 22nd, 2020

DSS 7.0.2 is a bug fix release. For a summary of major changes in 7.0, see below

### Datasets

  * **New feature** Added support for BigQuery clustered tables and native partitioning

  * In column analysis, the top values count is now parameterizable

  * In column analysis, added display of distinct values in when using the ‘whole data’ mode

  * Added support for Azure Blob Storage containers with files and folders having the same name

  * Fixed the “Internal stats” dataset if previously-stored scenarios used Hipchat reporters




### ML

  * **New feature** : More efficient performance presets for Visual Machine Learning. Get better result faster.

  * Made the number of bins for “hashing” categorical feature preprocessing configurable

  * Added a configurable range limit for correlation mode of feature reduction

  * Improved compatibility of row level interpretability in ICE mode with Python 3 (now take most important variables)

  * Fixed MAPE aggregated results on partitioned models

  * Fixed scroll down in XGBoost algorithm page

  * Fixed error handling for XGBoost when trained on Python 3

  * Fixed retraining of partitioned models on automation node or upon project import, if the original model data had not been exported

  * Fixed scoring recipes with row level interpretability on small datasets

  * Fixed scoring and evaluation recipes with “proba percentiles” enabled when run on Python 3




### Coding

  * Improved behavior of project duplication for branching projects, now defaults to only copying uploaded datasets

  * `model.get_predictor()` is now usable on partitioned models

  * SQLExecutor2 is now usable in Python recipes on BigQuery datasets

  * Made `dataiku.sql` compatible with Python 3

  * Fixed stop of Jupyter kernels with Python 3 base environment in UIF mode

  * Added an API to delete an API deployer infra




### Visual recipes

  * Fixed resource leaks when using the “Python function” preparation step

  * Fixed the TopN recipe on a date field on BigQuery

  * Fixed formula step on BigQuery when column contains uppercase letters

  * Fixed join recipe on BigQuery when one of the datasets does not have project key as prefix

  * Improved consistency of unbounded window behavior between stream engine and SQL engines

  * Fixed per-user-credentials for Spark-Snowflake fast path

  * Relaxed some restrictions on the computed column names when run with SQL engine




### Scenarios

  * Fixed sending of Slack or Teams messages from Python scenarios

  * Added protection against memory overruns in case of SQL triggers returning large result sets




### Kubernetes

  * Fixed a rare case where jobs could fail on highly-loaded Kubernetes clusters

  * Fixed Jupyter notebooks on Kubernetes when the cluster needs to auto-scale because no resources are available




### Flow

  * Fixed “explicit-only” rebuild mode with Spark and SQL pipelines

  * Added statistics worksheets information in the flow




### Statistics

  * Fixed conclusions based on the p-value interpretation

  * Better display of the statistics tab on non built datasets




### Hadoop

  * Added support of EMR 5.29

  * Fixed support of SparkSQL validation on CDH 6.3 and Java 9+

  * Fixed Hive recipes validation in some specific Hive configuration setups, notably when used with IBM BIGSQL




### Plugins

  * Restored “Update from Git” for plugins in “installed” mode (in addition to dev mode)

  * Fixed plugin algorithms on UIF installation mode

  * Improved code recipe to plugin conversion

  * Made python based custom field compatible with MULTISELECT field type




### Webapps

  * Added support for multi-process Bokeh webapps




### Misc

  * Better handling of cases where projects are deleted on disk instead of through DSS

  * Fixed failure while copying subflow with HDFS datasets in a new project

  * Fixed mail attachment limit size widget in ressource control screen

  * Displayed all tags and users in the projects list instead of the ones defined in the current project folder

  * Fixed possibility to use variables in ‘webhookUrl’ field of the Microsoft Team scenario reporter




## Version 7.0.1 - March, 13th, 2020

DSS 7.0.1 is a bugfix release. For a summary of major changes in 7.0, see below

### Datasets

  * Fixed ‘Export Table’ option of dataset metrics in ‘column view’ display mode

  * Fixed column width resizing in dataset explore tab




### Recipes

  * Fixed the translation of the ‘log’ DSS formula when run on SQL databases

  * Fixed the dkuReadDataset R function that could, in case of error, hide the real error message

  * Fixed support for S3 to Redshift fast-path with S3 connections having restrictions on writable paths




### Statistics

  * Fixed statistics computation on Kubernetes

  * Fixed UI issues with statistics on migrated DSS instances




### Kubernetes

  * Better validation of cluster name when creating a Kubernetes cluster from plugin




### Machine learning

  * Added computation of the aggregated score on partitioned models when a custom score is used

  * Added computation of the aggregated score on multiclass partitioned models when the ‘Log loss’ metric is used

  * Fixed usage of the native Python processor when defined in the script section of an analysis

  * Fixed display of the starting time when training partitioned models




### Flow

  * Improved display of unbuilt datasets when using flow filters

  * Improved display of partitioned models when using flow views

  * Improved display of plugin names in the right panel

  * Fixed preview of folder content in the right panel




### Misc

  * Fixed DSS objects link creation in DSS objects descriptions on Firefox

  * Various fixes around multi selection of list items

  * Fixed issue when moving project to folder by drag and drop

  * Fixed the ‘send report’ scenario step when targeting a dataset

  * Fixed abort of SQL notebook query when using the ‘regular statement’ option




### Plugins

  * Fixed language selection when creating a plugin component

  * Make chart filters available for custom charts




## Version 7.0.0 - March, 2nd, 2020

DSS 7.0.0 is a major upgrade to DSS with major new features.

### New features

#### Interactive statistics

Dataiku DSS now features a dedicated interface for performing exploratory data analysis (EDA) on datasets. EDA is useful for analyzing datasets and summarizing their main characteristics. Common tasks in EDA include visual data exploration, statistical testing, detecting correlations, and dimensionality reduction.

Some of the features of interactive statistics in Dataiku DSS are:

  * Univariate analysis (descriptive statistics, histograms, boxplots, quantile tables, frequency tables, cross-filter, …)

  * Bivariate analysis (scatter plots, correlation analysis, bivariate frequency tables, …)

  * Statistical tests (mean tests, distribution tests, two-sample tests, Anova, Chi-Square, …)

  * Distribution fitting (normal, beta, exponential, mixtures, …)

  * Kernel Density Estimations

  * Curves fitting

  * Multi-variables correlation matrix

  * Principal component analysis

  * Arbitrary grouping and filtering




For more details, please see [Interactive statistics](<../../statistics/index.html>)

#### Row-level interpretability

Dataiku DSS now includes row-level interpretability for Machine Learning models. This allows you to get a detailed explanation of why a Dataiku model made a given prediction, even when said model is a “black-box” model.

Dataiku DSS features two computation methods for row-level intepretability:

  * ICE (individual conditional explanations)

  * Shapley values




In the model results screen, you can directly view explanations for the “most extreme” predictions on the test set. You can also compute explanations on a complete dataset in the scoring recipe.

For more details, please see [Individual prediction explanations](<../../machine-learning/supervised/explanations.html>)

#### Git integration of projects: pulling and branching

The per-project Git integration now features several key additional features:

  * Pulling changes from a remote repository

  * Creating branches and switching branches

  * Creating new branches as new projects to work on multiple branches simultaneously




For more details, please see [Version control of projects](<../../collaboration/version-control.html>)

#### Fetch path and partition information in prepare recipe

The prepare recipe now includes a new processor “Enrich with context information” that can be used to add, for each row, information about the source file and source partition.

This processor is especially useful when using partitioned-by-files datasets where the file path may contain important semantic information, that was previously not retrievable.

This processor only works in the “DSS” engine for prepare (i.e. it cannot be used with Spark).

For more details, please see [Enrich with record context](<../../preparation/processors/enrich-with-record-context.html>)

#### Project creation macros

Many administrators wish to have more control on how projects are created. Examples of use cases include forcing a default code env, container runtime config, automatically creating a new code env, setting up authorizations, setting up UIF settings, creating a Hive database, …

This led many administrators to deny project creation to users, leading to higher administrative burden for administrators.

With project creation macros, administrators can delegate the creation of projects to users, but the project will be created using administrator-controlled code, in order to perform additional actions or setup.

For more details, please see [Creating projects through macros](<../../concepts/projects/creating-through-macros.html>)

### Other notable enhancements

#### Resize columns

It is now possible to resize columns in the Explore and Prepare views.

#### Retry in scenarios

It is now possible to confiure each scenario step to retry a given number of times, with a configurable delay between retries.

#### Signing of SAML requests

Dataiku DSS now supports signing SAML requests, for the cases where the SAML IdP requires it.

#### OAuth flow and credentials for plugins

Plugins can now leverage a new infrastructure that allows their users to store per-user credentials, and to perform OAuth flows.

This is particularly useful for plugins that need to connect to OAuth-protected data sources. With this new infrastructure, your plugin can allow each user to access his own data after performing the OAuth authentication flow through DSS.

For more details, please see [Parameters](<../../plugins/reference/params.html>)

#### Merge folders recipe

A new visual recipe to merge the content of multiple managed folders into one “stacked” managed folder

#### Reload button on notebooks

The Jupyter notebook UI now features a “Force reload” button that performs the full-unload-and-reload of the notebook that is needed:

  * If the project libraries were modified and need to be reloaded

  * If the DSS backend had restarted and the notebook can’t authenticate anymore

  * If the Hadoop delegation tokens had expired




#### Scalable webapps on Kubernetes

Webapps can now be deployed on Kubernetes. This allows having multiple backends serving a webapp.

#### Advanced Kubernetes exposition

Exposing API services and webapps on Kubernetes now support more advanced exposition options and custom YAML for expositions, allowing for more flexibility in advanced Kubernetes deployments.

### Other enhancements and fixes

#### Hadoop, Spark, Kubernetes

  * Fixed “inherit from host” network on AKS

  * Added ability to set Kubernetes version on EKS

  * Fixed potential generation of too long Kubernetes namespaces

  * Automatically set spark.master when using Managed-Spark-on-Kubernetes on a non-managed Kubernetes cluster

  * Added support for Hortonworks HDP 3.1.4

  * Fixed potential infinite loop when building Spark pipelines

  * Automatically cleanup pods generated when using interactive SparkSQL on Kubernetes

  * Added variables expansion in Spark configuration

  * Test of container execution configuration now properly uses the active cluster




#### Datasets

  * BigQuery: Added support for “append”

  * GCS: Fixed slow read

  * GCS: Added proxy support

  * PostgreSQL: Fixed ability to use custom JDBC URL

  * FTP: Fixed file format detection

  * MySQL: Fixed duplicate column names in SQL notebook table list




#### Webapps

  * Flask webapp backend can now be multithreaded and multiprocessed. This allows greatly increasing the concurrency when the webapp performs blocking API calls but does not consume CPU (for example, if the webapp is waiting for a scenario to complete running)

  * Fixed History tab

  * Fixed restart of Bokeh webapps in dashboards




#### Data preparation

  * Fixed possible wrongful detection of “bigint” storage type instead of “string”, even in the presence of 0-leading values

  * Fixed SQL translation for column renamer when doing renames like A->B, B->C




#### Visual recipes

  * Sync recipe: GCS to BigQuery fast-path: added support for data stored in mono-regional locations

  * Sync recipe: Redshift to S3 fast-path: fixed support for @ in column names




#### Coding recipes

  * Fixed Hive->Impala and Impala->Hive conversion actions




#### Machine learning

  * Fixed strict conformance of generated PMML models

  * Fixed impact coding when “impute missing” is set to “drop rows”

  * Fixed ability to run Evaluation recipe with Keras Deep Learning models on Kubernetes

  * Added “revert design to this session” for clustering models

  * Fixed XGBoost early stopping when the best iteration is the first one

  * Fixed support for Tensorboard with Tensorflow >= 1.10




#### Python API

  * Fixed regression on dataiku.get_custom_variables(typed=True) \- type will now be preserved

  * Added dataiku.Project().get_variables and dataiku.Project().set_variables to get/set project variables in a recipe in a way that will be directly reflected

  * Fixed insights.save_plotly, insights.save_bokeh, … in Python 3

  * Added API to obtain credentials for a connection directly in Python code (if authorized)

  * Added API to delete a scenario

  * Added API to delete a file from a managed folder

  * Made it possible to work on developing plugin recipes and clusters outside of DSS




#### R API

  * Added dkuGetProjectVariables and dkuSetProjectVariables to get/set project variables in a recipe in a way that will be directly reflected

  * Added API to delete a file from a managed folder




#### API node & API deployer

  * Fixed adding test queries from a dataset on a custom prediction endpoint




#### Cloud

  * Fixed generation of role-assumed STS tokens with too long login names or from APIs




#### Performance & Scalability

  * Various performance enhancements, especially for instances with high concurrency of users




#### Automation

  * Fixed wrongful date displayed in report mail when aborting a scenario

  * Fixed ability to clear old job logs from the UI




#### Administration

  * Added mass actions on the Users screen




#### Misc

  * Fixed issues where data would not be reloaded after installing a new plugin

  * Fixed adding insight from content of a managed folder

  * Enabled “drop data” by default when deleting datasets

---

## [release_notes/old/8.0]

# DSS 8.0 Release notes

## Migration notes

### Migration paths to DSS 8.0

>   * From DSS 7.0: Automatic migration is supported, with the restrictions and warnings described in [Limitations and warnings](<7.0.html#releases-notes-7-0-limitations>)
> 
>   * From DSS 6.0: Automatic migration is supported. In addition to the restrictions and warnings described in [Limitations and warnings](<7.0.html#releases-notes-7-0-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [6.0 -> 7.0](<7.0.html>)
> 
>   * From DSS 5.1: Automatic migration is supported. In addition to the restrictions and warnings described in [Limitations and warnings](<7.0.html#releases-notes-7-0-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>)
> 
>   * From DSS 5.0: Automatic migration is supported. In addition to the restrictions and warnings described in [Limitations and warnings](<7.0.html#releases-notes-7-0-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>)
> 
>   * From DSS 4.3: Automatic migration is supported. In addition to the restrictions and warnings described in [Limitations and warnings](<7.0.html#releases-notes-7-0-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>)
> 
>   * From DSS 4.2: Automatic migration is supported. In addition to the restrictions and warnings described in [Limitations and warnings](<7.0.html#releases-notes-7-0-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>)
> 
>   * From DSS 4.1: Automatic migration is supported. In addition to the restrictions and warnings described in [Limitations and warnings](<7.0.html#releases-notes-7-0-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.1 -> 4.2](<4.2.html>), [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>)
> 
>   * From DSS 4.0: Automatic migration is supported. In addition to the restrictions and warnings described in [Limitations and warnings](<7.0.html#releases-notes-7-0-limitations>), you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<4.1.html>), [4.1 -> 4.2](<4.2.html>), [4.2 -> 4.3](<4.3.html>), [4.3 -> 5.0](<5.0.html>), [5.0 -> 5.1](<5.1.html>), [5.1 -> 6.0](<6.0.html>), [6.0 -> 7.0](<7.0.html>)
> 
>   * Migration from DSS 3.1 and below is not supported. You must first upgrade to 5.0. See [DSS 5.0 Release notes](<5.0.html>)
> 
> 


### How to upgrade

It is strongly recommended that you perform a full backup of your DSS data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../../installation/custom/upgrade.html>).

Pay attention to the warnings described in Limitations and warnings.

### Limitations and warnings

Automatic migration from previous versions (see above) is supported, but there are a few points that need manual attention.

  * The commands to build base images for container execution and API deployer have changed. All base images are now built using options of `./bin/dssadmin build-base-image`

  * The legacy “Hadoop 2” standalone packages for Hadoop and Spark integration have been removed. Please use the universal `generic-hadoop3` package.




### Support removal

Some features that were previously deprecated are now removed or unsupported.

  * Support for Spark 1 (1.6) is removed. We strongly advise you to migrate to Spark 2. All Hadoop distributions can use Spark 2.




### Deprecation notice

DSS 8.0 deprecates support for some features and versions. Support for these will be removed in a later release.

  * As a reminder from DSS 7.0, support for “Hive CLI” execution modes for Hive is deprecated and will be removed in a future release. We recommend that you switch to HiveServer2. Please note that “Hive CLI” execution modes are already incompatible with User Isolation Framework.

  * As a reminder from DSS 7.0, Support for Microsoft HDInsight is now deprecated and will be removed in a future release. We recommend that users plan a migration toward a Kubernetes-based infrastructure.

  * As a reminder from DSS 7.0, Support for Machine Learning through Vertica Advanced Analytics is now deprecated and will be removed in a future release. We recommend that you switch to In-memory based machine learning models. In-database scoring of in-memory-trained machine learnings will remain available.

  * As a reminder from DSS 7.0, Support for Hive SequenceFile and RCFile formats is deprecated and will be removed in a future release.

  * As a reminder from DSS 6.0, support for Pig is deprecated. We strongly advise you to migrate to Spark.




## Version 8.0.7 - March 22nd, 2021

### Datasets and connections

  * Fixed variable expansions on the “catalog”/”database” field of SQL datasets

  * Fixed table lookup when the “catalog”/”databasse” field is empty

  * Improved robustness of the driver/database version detection when the driver returns an error




### Dashboards

  * Fixed possible hang when exporting a dashboard to PDF when there are charts that can’t be rendered




### ML

  * In a ML task design, fixed display of the L1 ratio setting for SGD models




### Webapps

  * Fixed Shiny webapps with Shiny 1.6.0




### Security

  * Fixed [stored XSS in objects titles](<../../security/advisories/dsa-2021-001.html>)

  * Prevent display of invalid API keys in error messages




### Misc

  * Fixed broken link in notification emails related to discussions

  * Avoid leaking temporary files when using custom FS providers with UIF enabled

  * Performance enhancements for reading non-Parquet datasets on S3 with large numbers of files




## Version 8.0.6 - February 24th, 2021

### Scenarios

  * Fixed handling of failed jobs in “Build items” scenario step that appeared with an internal error




### Performance

  * Improved performance of the “get project metadata” API call, especially when called large number of times

  * Improved performance for rendering of flow with flow zones

  * Improved caching of flow rendering, leading to improved overall flow visualization experience

  * Strongly improved performance for “scenario edition” and “scenario last runs” pages in the case of scenarios that ran a very large number of times




### Security

  * Fixed [invalid access control in Jupyter notebooks](<../../security/advisories/cve-2021-27225.html>)




## Version 8.0.5 - January 11th, 2021

### Visual recipes

  * Stack recipe: Fixed “Replace input” button in

  * Pivot recipe: Fixed race condition which could drop aggregations on DSS engine when a filter is set

  * Prepare recipe: Fixed a bug with Python step in “real Python process” mode when running high-concurrency jobs on Spark

  * Prepare recipe: Added some missing methods on the row object in Python step




### Coding

  * Python API: Fixed set_code_env recipe method

  * Python API: Fixed run of training recipes

  * Python API: Added catalog and schema support in query builder API

  * In SQL Notebook, refresh table button is now displayed by default




### Scenarios

  * Fixed attachments in scenario reports

  * Fixed monthly trigger that stopped working after the first month

  * Fixed export of notebooks from scenario when project libs are involved

  * Fixed possible failure in “Build” step caused by a race condition




### Flow

  * Fixed the assigned Flow zone of a dataset created from the split recipe

  * Fixed schema consistency errors not showing when using Flow zones

  * Fixed “building” indicator that did not properly refresh when using Flow zones




### Plugins

  * Fixed ability to create plugin datasets when using a free license

  * Improved dynamic select implementation in Project Creation Macro for usage by users with restricted permissions




### Misc

  * Fixed error message not displayed when performing an unauthorized action

  * Fixed performance issue caused by daily maintenance tasks

  * Fixed required permissions to delete empty project folders that were not top-level folders

  * API node: Fixed possible failure of R function endpoints due to bad type in “timing”

  * Make the “BigQuery Project Id” field at dataset level optional

  * Pinned the pip version in docker base images to keep Python 2.7 compatibility




## Version 8.0.4 - December 4th, 2020

**Note:** DSS 8.0.4 has a known issue regarding dss objects attachment in scenario reports. Contact Dataiku support if you need the available hotfix.

### Datasets

  * Fixed Cassandra dataset

  * Fixed handling of SQL, Hive, Impala and SparkSQL notebooks in datasets’ ‘Lab’ tab

  * Allow to specify a default catalog at the connection level for Snowflake and BigQuery connections

  * Fixed Snowflake/Spark native integration when schema is not specified as a Snowflake connection property

  * When importing a new dataset, add it to the currently open zone instead of the default zone




### Flow & Recipes

  * Join recipe: Fixed prefilter with DSS engine when joining with the same dataset

  * Use ‘days’ as default unit when using the date ‘diff’ formula function

  * Reduced excezsive logging when using ‘variables.<variable_name>’ to access variables in a formula step

  * Sync recipe: Fixed Azure Blob / Synapse sync for tables in non-default schemas

  * Improved reliability for Kubernetes usage with extreme partitioning concurrency on a single coding recipe




### Hadoop

  * Fixed Spark support on Cloudera CDH 5




### Notebooks

  * Fixed listing of Hive and Impala tables in notebooks

  * In UIF mode, fixed Jupyter notebook export if you have never previously visited the “Library Editor” of the project




### API

  * Fixed schema propagation in python API

  * Fixed issue in Wiki API when getting article by its name

  * Fixed HiveExecutor/ImpalaExecutor when used in a project with specific user impersonation rules

  * Fixed plugin credentials settings API




### Machine learning

  * Fixed Model Document Generation ‘design.train_set.image’ placeholder when the train set has a filter defined

  * Fixed the “Write your own estimator” link when creating a model

  * Fixed threshold setting after a training recipe run on a partitioned binary classification model

  * Fixed PMML export when both impact coding and impute of missing with a constant are used while there is no missing value

  * Allowed display of linear coefficients for custom linear classification algorithms

  * Fixed scoring of clustering models trained with very old versions of DSS (4 and below)




### API Deployer

  * Fixed prediction not shown in API Deployer test query for services with several endpoints

  * Fixed display of complex result types in API Deployer




### Scenarios

  * Fixed email reporting when a job fails without an error message

  * Added support for checking GDPR export flags when bundling a project

  * Fixed errors when switching between modes on “Set scenario variables” step

  * Added ability to bypass proxy for webhook reporter




### Plugins

  * Fixed custom multi-select type when removing a previously set option

  * Fixed dynamic choices field when used in cluster action macros

  * Fixed display of adminParams section in actions modal for cluster action macros




### Security

  * Don’t send digest emails to users who have been removed from a project

  * Fixed bogus ability to write custom cross-validation in hyperparameter searches while not allowed to write code




### Misc

  * Added support for macOS 11.0 (Big Sur)

  * Fixed Kubernetes support for plugin webapps

  * Added Proxy support for OAuth2 plugin credential requests

  * Added export size in audit log

  * Added ability to customize hsts-max-age in SSL server configuration




## Version 8.0.3 - November 4th, 2020

### Snowflake

  * **New feature** : Support for cross-database operations. This covers importing from catalog, datasets, visual recipes and SQL recipes

  * **New feature** : Added ability to dynamically switch Warehouse and Role, at the project and recipe level (using variables expansion)

  * **New feature** : Added fast load from Parquet files on S3 to Snowflake

  * **New feature** : Added support of concat in window & group recipes

  * **New feature** : Added support for ignoring null values in ‘first value’ and ‘last value’ retrievals in window recipe

  * Managed Snowflake tables are now created upper-case by default

  * The ‘Assumed time zone’ option is now usable on DATETIME and TIMESTAMP_NTZ Snowflake types

  * Made all connection parameters optional, since they can be inherited from user default

  * Fixed “list table fields” in SQL notebook in case catalog is not set in the connection

  * Added ability to read Snowflake streams




### BigQuery

  * **New feature** : Support for cross-project operations. This covers importing from catalog, datasets, visual recipes and SQL recipes




### Webapps

  * **New feature** : Added support for Bokeh 2

  * For Kubernetes based webapps, the start backend now waits for the webapp backend to be fully started

  * Fixed vanity URL option of public webapps for plugin webapps




### Datasets

  * **New feature** : Added ability to expand JDBC connection variables using per-project and per-recipe variables

  * Fixed sampling ordering on SQL partitioned datasets when used with filtering

  * Restored the delete icon of items in the “sort order” list of the sampling panel

  * Fixed wrongful “you have unsaved changes” in Teradata dataset settings




### Coding

  * Fixed `set_python_code_env()` and `set_r_code_env()` Python API methods




### Collaboration

  * Fixed dashboard tiles display on personal home page

  * Fixed issues with display of dashboards on home page

  * Prevented saving of empty global tags

  * Fixed reassignment of a global tags when deleting it

  * Fixed the catalog search for the project owner

  * PDF exports of Flow and Dashboard: fixed display of license expiration warnings




### Visual recipes

  * Redshift/S3 fast sync: Allowed different spelling for UTF8 charset (utf8, utf-8, UTF8 …)

  * Fixed display of “Merge folders” recipe icon

  * Fixed possible UI misalignment of the error message in join recipe

  * Prevent immediate error message from being shown in prepare recipe while setting date format in the date parser processor

  * Fixed toString(format) formula function when working on DateTime

  * Fixed job status in case of input reading error when using DSS engine on group, topn, distinct, pivot or split recipe




### Jobs and Flow

  * **New feature** : Variables expansion is now supported for the “Explicit values” partition dependency function

  * Fixed the ability to cancel a job preview

  * Improved error message when automatic schema propagation fails

  * Fixed smart rebuild option on editable datasets

  * Improved dataset contextual menu UI to be consistent with the user’s authorization

  * Relaxed required access rights to move a shared item to a flow zone

  * Fixed update of flow zones after a dataset renaming

  * Improved flow zone user experience by coloring them even when not selected

  * Tags can now be added to a flow zone

  * Fixed reset of job list filter when a new job notification popup appears




### API node

  * Fixed display of complex types results of test queries in API designer

  * Fixed explanation computation on Python 2 when the features contain non-ASCII characters




### Projects

  * **New feature** Project creation macros now have access to the current project folder

  * Project creations macros can now use a Python-based choices field




### Notebooks

  * Fixed display of multi lines data in query results of SQL notebooks

  * Fixed dataframe export to dataset from a Jupyter notebook when a column contains non-ASCII characters

  * Fixed insight creation from a shared Jupyter notebook

  * Creating recipe from notebook now removes spaces in the recipe name for safety purpose

  * Fixed display of error message details on notebook upload




### Plugins development

  * **New feature** Added PKCE support for OAuth2 credential requests

  * Improved switching from list to raw edition for the MAP parameter

  * Fixed detection of outdated plugin settings when using a MAP parameter

  * Fixed getChoicesFromPython parameter on webapp plugin component with a DATASET role

  * Fixed column completion not showing for DATASET_COLUMNS parameter

  * Fixed truncated read of custom Python filesystem provider




### Scenarios

  * **New feature** : “Dataset change” trigger can now trigger only when multiple datasets have changed

  * Fixed possibility to share scenario across projects

  * Added an additional check in the UI to make URL mandatory on Webhook notifications




### Elastic AI

  * **New feature** : Added support for Cloudera HDP 3.1.5

  * Fixed rescaling cluster macro on EKS

  * Added support for Spark jobs from ADLS gen2 to ADLS gen2 with different input and output accounts




### Visual ML

  * Various improvements in the model list filtering

  * Prevent raw level interpretation from failing when there is lot of rejected features

  * Model document generation: prevented license expiration warning from appearing in the screenshots

  * Model document generation: Prevented possible loading spinner from appearing in screenshots

  * Fix clustering rescoring on saved model

  * Fixed harmless migration failure message of tree visualisations




### Misc

  * In time series charts, prevent automatic date axis mode from generating non drawable charts

  * Fixed appearance in logs of manually-defined passwords on plugin datasets




## Version 8.0.2 - September 23rd, 2020

DSS 8.0.2 is a bugfix release. For a summary of major changes in 8.0, see below

### Visual recipes

  * Fixed the “Pattern” column selection mode of prepare recipe processors

  * Fixed pivot recipe on Redshift when column names contain uppercase letters

  * Added support of timezone in DatePart formula function

  * Improved support of unfold prepare recipe processor when run on Hive 3

  * Fixed window visual recipe on Spark and Hive when a column renaming is set and concat operation is used

  * Added ability to globally disable some prepare recipe processors




### Machine Learning

  * Updated cross validation strategy samples when using custom code

  * Fixed custom cross validation on Python 3

  * Fixed custom evaluation metric on binary prediction using probabilities

  * Better warning display in the train modal in case of code environment incompatibility

  * Prevent creating an evaluation recipe on a saved model with weights if the dataset does not have the weights column

  * Fixed random-search when a plugin algorithm is enabled

  * Fixed multiple partitioned models training when trained in the same job

  * Fixed the displayed number of models in summary of stratified models

  * Fixed wrongful deployment of failed partitions to Saved Models




### Coding

  * Fixed creation of SparkSQL recipe from a SparkSQL notebook cell

  * Fixed `write_json` on managed folders with Python 3

  * Added ability to download a plugin using the API

  * Exposed forceRebuildEnv option in code environments API

  * Prevented creation of plugin recipe with required input or input if they are not provided

  * Fixed `get_items_in_traversal_order` Python method when Flow contains saved models or managed folders




### Collaboration

  * Added support for global tags with a semicolon in their names

  * Improved tags UI in “Search DSS” screen

  * Fixed autocompletion for tag creation from the project summary on Chrome

  * Fixed error at project import if one of the default code environments of the imported project is not remapped




### Datasets

  * Fixed DynamoDB connection when secret key has been encrypted

  * Added ability to configure STS token duration for S3 connections when using ‘STS with AssumeRole’




### Statistics

  * Added UI improvements for better readability in correlation matrix




### Charts

  * Fixed in-database charts on Impala when using the Cloudera-provided Impala JDBC driver




### API Node and deployer

  * Improved default settings when row level interpretation is asked at query time

  * Improved error in API Node when scoring images with base64 encoding

  * API Deployer: Fixed ability to disable K8S deployments on non-builtin cluster




### Applications

  * Fixed possible error when using custom ui field in application tiles

  * Fixed the download dataset tile when using a custom exporter




### Elastic AI

  * Fixed ‘–dockerfile-append’ and ‘–dockerfile-prepend’ image building options

  * Improved usability of ‘–docker-build-opt’ image building option

  * Fixed Cuda 10.1 docker image build

  * Fixed ability for “numerical-only” DSS user names to use Kubernetes




### Flow

  * Fixed ‘Add to scenario’ dataset action which created non relocatable scenarios

  * Fixed missing refresh of list of flow zones just after creation of a new flow zone




### Hadoop

  * Fixed Hive recipe validation error on Mapr 6

  * Fixed support for Parquet on Mapr 6




### Scenarios

  * Fixed saving of scenario using “stop cluster” step

  * Fixed “Run scenario” button in dashboard when targeting a foreign scenario

  * Fixed wrong permission checks for shared scenario tiles




### Webapps

  * Improved behavior of the “Restart backend” button when run on Kubernetes

  * Fixed resource leak when running webapps on Kubernetes with “port-forwarding” exposition

  * Fixed “port-forwarding” exposition when number of pods is greater than 1

  * Fixed Bokeh webapps on macOS




### Extensibility

  * Fixed plugin uninstall when a Dataiku Application has been deleted

  * Added a filter and a search field in the macro list screen




### Security

  * Disabled ability for users that have no rights to create active WebContent from uploading notebooks

  * Fixed [CVE-2020-25822](<../../security/advisories/cve-2020-25822.html>): Incorrect access control allows users to edit discussions




### Misc

  * Fixed OAuth2 preset saving if no client secret is provided

  * Prevent dynamic clusters to be started twice in case of quick double clicking

  * Fixed display of original IP in audit log when going through multiple proxies




## Version 8.0.1 - July, 31th, 2020

DSS 8.0.1 is a bugfix release. For a summary of major changes in 8.0, see below

### API Node

  * Fixed individual explanations when the model contains a date feature




### Recipes

  * Prepare recipe: Fixed autocomplete of column name when using “multiple columns” step mode

  * Prepare recipe: Improved error handling of the “Rename columns” processor when the step has just been created




### Flow

  * Fixed display of “File in folder” dataset when using Flow zones

  * Fixed display of “Metrics” dataset when using Flow zones




### Notebooks

  * Fixed possible Jupyter hang when User Isolation Framework is enabled




### Machine Learning

  * Fixed behaviour of the “Create prediction model” inside an analysis.

  * Fixed display of the AutoML dialog images on chrome

  * Fixed the “View original analysis” button of saved models when the analysis has been deleted

  * Prevent silent failure when clicking on the ‘Lab’ button while user does not have the right user profile




### Projects

  * Fixed creation of the DSS Core Designer tutorials

  * Fixed remapping of code environments when importing projects




### Charts

  * Fixed quick cropping of line charts on dashboard when data is loading




### Webapps

  * Fixed issue on macOS and old versions of Centos




### Misc

  * Fixed display of scenario run trigger settings in scenario list

  * Fixed display of managed folder view tab

  * Hide project settings menu for people that are already not allowed to view settings




## Version 8.0.0 - July, 15th, 2020

DSS 8.0.0 is a major upgrade to DSS with major new features.

### New features

#### Dataiku Applications

Dataiku Applications allow Dataiku designers to make their projects reusable and consumable by business users. Once a designer has made a project available as an application, business users can create their own instances of the application, set parameters, upload data, run the applications, and directly obtain results.

For more details, please see [Dataiku Applications](<../../applications/index.html>).

#### Model Document Generation

In regulated industries, data-scientists have to document ML models, at creation and after every change for traceability. This is often tedious. DSS now features the ability to automatically generate a DOCX document from a machine learning model.

Designers can upload their own DOCX template with placeholders that will be automatically be replaced by information, explanations and charts from the ML model. Model Document Generation has an extensive coverage of the advanced result screens of DSS Visual ML, allowing creation of rich documents.

For more details, please see [Model Document Generator](<../../machine-learning/model-document-generator.html>).

#### Flow Zones

Data Science projects tend to quickly become complex, with large number of recipes and datasets in the Flow. This can make the Flow complex to read and navigate.

Flow Zones are a completely new way to organize bigger flows into more manageable sub-parts, called zones.

You can now define your zones in the Flow, and assign each dataset,recipe, … to a zone. The zones are automatically laid out in a graph, like super-sized nodes. You can work within a single zone or the whole flow, and collapse zones to create a simplified view of the flow.

For more details, please see [Flow zones](<../../flow/zones.html>).

#### Advanced hyperparameter searching

In addition to the already-existing grid searching for hyperparameters, DSS can now perform Random search and Bayesian search for faster and more thorough search for the best set of hyperparameters.

For more details, please see [Advanced models optimization](<../../machine-learning/advanced-optimization.html>).

#### Programmatic usage of Row-level-interpretability

DSS 7.0 added support for row-level interpretability for Machine Learning models. This allows you to get a detailed explanation of why a Dataiku model made a given prediction, even when said model is a “black-box” model.

In DSS 7.0, Row-level interpretations were available in the UI, and as the output of the scoring recipe.

DSS 8.0 adds the ability to programmatically obtain explanations through the API node, and also through the Saved Model Python API.

For more details, please see [Exposing a Python prediction model](<../../apinode/endpoint-python-prediction.html>).

#### Application-as-recipes

In addition to their “Visual re-use by business users” usage, Dataiku Applications can also be used to reuse an entire flow as if it was a single recipe. This allows designers to quickly design complex flows while making usage of “building blocks” built by other designers, without having to maintain the complexity of the underlying reused flow.

For more details, please see [Application-as-recipe](<../../applications/application-as-recipe.html>)

#### Support for Pandas 1.0

Dataiku now supports Pandas 1.0 (in addition to maintained support for the legacy 0.23 version).

Support for Pandas 1.0 is only available when using a [code env](<../../code-envs/index.html>). Pandas 1.0 is only compatible with Python >= 3.6.1, so only code envs using Python 3.6.1 (and above) will get the ability to use Pandas 1.0

#### Centralization of audit trail

There are multiple use cases for _centralizing_ audit logs from multiple DSS nodes in a single system.

Some of these use cases include:

  * Customers with multiple instances want a centralized audit log in order to grab information like “when did each user last do something”.

  * Customers with multiple instances want a centralized audit log in order to have a global view on the usage of their different audit nodes, and compliance with license

  * Compute Resource Usage reporting capabilities use the audit trail, and make more sense if fully centralized. You may want to cross that information with HR resources, department assignments, …

  * Most MLOps use case require centralized analysis of API node audit logs




DSS now features a complete routing _dispatch_ mechanism for these use cases, with the ability to centralize audit log from multiple machines to a central location, and enhanced capabilities for analyzing audit logs within DSS.

For more details, please see [Audit trail](<../../operations/audit-trail/index.html>).

#### Centralization of API node query logs

Building on audit log centralization, you can now also centralize API node query logs. This allows you to setup a feedback loop for your ML Ops strategy, in order to analyze the predictions made by the API node, either to detect input data drift or model performance drift.

For more details, please see [Configuration for API nodes](<../../operations/audit-trail/apinode.html>).

#### Compute resource usage reporting

DSS acts as the central orchestrator of many computation resources, from SQL databases to Kubernetes. Through DSS, users can leverage these elastic computation resources and consume them. It is thus very important to be able to monitor and report on the usage of computation resources, for total governance and cost control of your Elastic AI stack.

DSS now includes a complete stack for reporting and tagging compute resources. For more details, please see [Compute resource usage reporting](<../../operations/compute-resource-usage-reporting.html>).

#### Plugin uninstall

It is now possible to uninstall plugins, both from the UI and API. Trying to uninstall a plugin will automatically warn you if the plugin is still in use.

#### Public webapps and impersonation in webapps

Two new features reinforce the ability to serve webapps to large number of users:

  * Webapps can now be shared to users who are not DSS users and do not have a DSS account. This allows you to share webapps widely to the whole company. For more details, please see [Public webapps](<../../webapps/public.html>)

  * Webapp backend code can now perform API calls to the Dataiku API on behalf of the end-user viewing the webapp, with full traceability of the end-user identity. This allows better governance and tracability of actions performed on behalf of users. For more details, please see [Webapps and security](<../../webapps/security.html>).




#### Tag categories

Administrators can now define tag categories. Tag categories allow you to create custom “fields” in the form of tags, and have predefined set of values.

Categorized tags can then be set easily by the end user with validation on the values.

For example, you could create a tag category for the responsible team, one for the department, one for the brand that you’re working on, …

Tag categories can be created and managed by the administrator from Administration > Settings > Tag categories.

### Other notable enhancements

#### Improved Visual ML experience

The Visual ML user experienced has been enhanced to streamline the creation of models and understanding of the Dataiku Lab:

  * Find the Lab associated to each dataset directly from the dataset’s right panel

  * Faster creation of ML models, with streamlined workflow. You can now create a ML model in 3 clicks from a dataset

  * Ability to create ML models directly from a column in the dataset’s Explore view

  * Better explanations in-product for the various [cross-validation strategies](<../../machine-learning/advanced-optimization.html>)




#### New users and authentication management APIs

The API for users and authentication management have been greatly enhanced with:

  * Ability to set user secrets through API, either for end users or admins

  * Ability to set per-user-credentials through API, either for end users or admins

  * Ability to impersonate end-users using admin credentials

  * Ability to manipulate user and admin properties through API




For more details, please see [Users and groups](<https://developer.dataiku.com/latest/api-reference/python/users-groups.html> "\(in Developer Guide\)") and [Authentication information and impersonation](<https://developer.dataiku.com/latest/api-reference/python/authinfo.html> "\(in Developer Guide\)").

#### Enhanced programmatic flow building APIs

Many APIs have seen vast improvements, especially regarding the ability to entirely build and control Flows via the API:

  * Ability to detect dataset settings (See [Datasets (other operations)](<https://developer.dataiku.com/latest/concepts-and-examples/datasets/datasets-other.html> "\(in Developer Guide\)"))

  * Much easier ability to create recipes (See [Flow creation and management](<https://developer.dataiku.com/latest/api-reference/python/flow.html> "\(in Developer Guide\)"))

  * Ability to traverse the Flow graph (See [Flow creation and management](<https://developer.dataiku.com/latest/api-reference/python/flow.html> "\(in Developer Guide\)"))

  * Ability to compute and set output schema for recipes (See [Recipes](<https://developer.dataiku.com/latest/api-reference/python/recipes.html> "\(in Developer Guide\)"))

  * Ability to propagate schema across entire flows (See [Flow creation and management](<https://developer.dataiku.com/latest/api-reference/python/flow.html> "\(in Developer Guide\)"))

  * Ability to manage Flow zones (See [Flow creation and management](<https://developer.dataiku.com/latest/api-reference/python/flow.html> "\(in Developer Guide\)"))




And many other, please see [Python](<https://developer.dataiku.com/latest/api-reference/python/index.html> "\(in Developer Guide\)") for a complete index of the Python API.

#### Enhanced support for container images

All three kinds of container images (containerized execution, Spark-on-Kubernetes and API deployer) are now built on a single CentOS 7 base.

This release brings the following enhancement:

  * Support for CUDA 10.0 and 10.1 in containers

  * Full support for Python-3-only containers

  * Far enhanced customization capabilities, including ability to use a proxy

  * Ability to use prebuilt images for faster images build




For more details, please see [Elastic AI computation](<../../containers/index.html>) and [Customization of base images](<../../containers/custom-base-images.html>).

#### Experimental support for Openshift

DSS 8.0 adds experimental for Openshift as a Kubernetes runtime

For more details, please see [Using Openshift](<../../containers/openshift/index.html>).

#### Managed Kubernetes namespaces and quotas

DSS can now automatically create Kubernetes namespaces for both containerized execution and Spark-on-Kubernetes. Namespaces can be defined using variable expansion, in order to create namespaces per user/team/project/…

DSS can automatically apply policies to the dynamic namespaces, notably resource quotas (in order to limit the total amount of computation/memory available to a namespace/user/team/project/…) and limit ranges (in order to set default resource control for computations running in the dynamic namespace).

For more details, please see [Dynamic namespace management](<../../containers/namespaces.html>).

#### Pod tolerations, affinity and node selectors

You can now add custom Kubernetes tolerations, affinity statements or node selectors in order to control more precisely the placement of your pods on Kubernetes.

For more details, please see [Dynamic namespace management](<../../containers/namespaces.html>).

#### Import notebooks

You can now directly import `.ipynb` files from DSS UI.

#### Enhanced API node audit logging

API node audit logging now includes project key / saved model id / saved model version for prediction endpoints.

In addition, you can ask DSS to dump and/or audit the post-enrich data, when using queries enrichments.

For more details, please see [Exposing a Python prediction model](<../../apinode/endpoint-python-prediction.html>).

#### Disabling users

It is now possible to disable users instead of outright deleting them. Disabled users cannot login, cannot run scenarios, and don’t consume licenses.

Disabling/enabling users can be done through the UI and API.

#### Instance-wide default code env

You can now select a default code env which will be applied by default across all projects.

#### Instance-wide default containerized execution config

You can now select a default containerized execution config which will be applied by default across all projects.

#### Improved “Performance” ML heuristics

The “Performance” template for Visual ML now includes updated defaults and heuristics, that will generally result in obtaining better models faster.

### Other enhancements and fixes

#### Flow

  * Fixed wrong value in partitioning “Test dependencies” function

  * Fixed navigation issue with cross-project datasets leading to loss of flow centering

  * Fixed issue when copying a subflow containing HDFS datasets to a new project

  * Fixed icons display issues for plugin recipes

  * Fixed wrongful attempt to write BigQuery datasets when importing a project

  * Project duplication will now only duplicate uploaded datasets by default




#### Charts

  * Geo scatter plot: Fixed points with no size nor color that were mistakenly going to (0,0)




#### Plugins

  * Fixed dynamic select widget for custom exporters

  * Python plugin recipes can now accept BigQuery datasets as outputs




#### Data preparation

  * Fixed issue when removing values from a “Remove rows on value” processor

  * Extract Date components processor: Extracting minutes,seconds and milliseconds can now run in SQL databases




#### Datasets

  * Fixed SQL dataset sample retrieval with both partitioning and filtering




#### Elastic AI

  * Fixed support for Kubernetes > 1.16

  * Spark install can now setup better defaults tuned for Kubernetes




#### Machine Learning

  * Cost matrix gain was added to the list of metrics displayed in the all metrics screen

  * “Max feature proportion” on tree ensemble algorithms is now hyperparameter-searchable

  * PMML export now outputs probabilities and can now use the model-specified threshold

  * API node: Fixed wrongful scoring of rows that were removed by the preparation script

  * Add more parameters to the Isolation Forest algorithm

  * Fixed issues with empty columns with unicode column names

  * Fixed clustering scoring when outliers detection is enabled and dataset to score is very small

  * Code of custom models is now displayed in results




#### Jupyter notebooks

  * Fixed issue when DSS is installed with base Python 3.6 environment

  * Properly show the Python version in the notebooks list




#### API deployer

  * Fixed logging settings at the infrastructure level




#### Collaboration

  * Added ability to duplicate wiki articles

  * Improved Slack integration with Slack Blocks




#### Scenarios

  * Improved the consistency check step to report more errors




#### API

  * Enhanced API for project folders - see [Project folders](<https://developer.dataiku.com/latest/api-reference/python/project-folders.html> "\(in Developer Guide\)")

  * Fixed API for pushing container base images




#### Security

  * Added additional capabilities to restrict data exports. For more details, please see [Advanced security options](<../../security/advanced-options.html>)

  * Added ability to prevent users from writing active Web content (webapps, Jupyter notebooks, RMarkdown reports). For more details, please see [Main project permissions](<../../security/permissions.html>)




#### Misc

  * Enhanced consistency of all widgets to edit lists of values or list of key/values

  * The Dataiku chat window is now back to appearing only on the homepage by default