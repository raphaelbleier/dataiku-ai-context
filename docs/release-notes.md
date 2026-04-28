# Dataiku Docs — release-notes

## [release_notes/11]

# DSS 11 Release notes

## Migration notes

### Migration paths to DSS 11

>   * From DSS 10.0: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 9.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [9.0 -> 10.0](<old/10.0.html>)
> 
>   * From DSS 8.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>)
> 
>   * From DSS 7.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>)
> 
>   * From DSS 6.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>)
> 
>   * From DSS 5.1: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>)
> 
>   * From DSS 5.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>)
> 
>   * From DSS 4.3: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>)
> 
>   * From DSS 4.2: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>)
> 
>   * From DSS 4.1: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.1 -> 4.2](<old/4.2.html>), [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>)
> 
>   * From DSS 4.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<old/4.1.html>), [4.1 -> 4.2](<old/4.2.html>), [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>)
> 
>   * Migration from DSS 3.1 and below is not supported. You must first upgrade to 5.0. See [DSS 5.0 Release notes](<old/5.0.html>)
> 
> 


### How to upgrade

It is strongly recommended that you perform a full backup of your DSS data directory prior to starting the upgrade procedure.

For automatic upgrade information, see [Upgrading a DSS instance](<../installation/custom/upgrade.html>).

Pay attention to the warnings described in Limitations and warnings.

### Limitations and warnings

Automatic migration from previous versions (see above) is supported. Please pay attention to the following removal and deprecation notices.

### Support removal

Some features that were previously announced as deprecated are now removed or unsupported.

  * Support for MapR

  * Support for ElasticSearch 1.x and 2.x




### Deprecation notice

DSS 11 deprecates support for some features and versions. Support for these will be removed in a later release.

  * Support for SuSE 15 and SuSE 15 SP1 is deprecated

  * Support for CentOS 7.3 to 7.8, RedHat 7.3 to 7.8 and Oracle Linux 7.3 to 7.8 is deprecated

  * As a reminder from DSS 10.0, the “Build missing datasets” build mode is deprecated and will be removed in a future release. This mode only worked in very specific cases and was never fully operational.

  * As a reminder from DSS 10.0, support for training Machine Learning models with H2O Sparkling Water is deprecated and will be removed in a future release.

  * As a reminder from DSS 9.0, support for EMR below 5.30 is deprecated and will be removed in a future release.

  * As a reminder from DSS 7.0, support for “Hive CLI” execution modes for Hive is deprecated and will be removed in a future release. We recommend that you switch to HiveServer2. Please note that “Hive CLI” execution modes are already incompatible with User Isolation Framework.




## Version 11.4.5 - December 21st, 2023

DSS 11.4.5 is a security release. It contains a critical security fix. We strongly encourage all customers still running DSS 11 to upgrade to this version.

### Security

  * Fixed [LDAP Authentication Bypass](<../security/advisories/dsa-2023-010.html>)




## Version 11.4.4 - June 21th, 2023

DSS 11.4.4 is a bugfix release

### Datasets

  * BigQuery: Fixed date issues on Pivot, Sort and Split recipes




### Performance

  * Improved performance and responsiveness when DSS data dir IO is slow

  * Fixed run comparison charts of experiment tracking when there are > 100k steps




### API

  * Allowed read-only user to retrieve through the REST API, the metadata of a project they have access




### Security

  * Fixed [Aborting scenarios with read-only permission on the project](<../security/advisories/dsa-2023-026.html>)




## Version 11.4.3 - May 12th, 2023

DSS 11.4.3 is a bugfix release

### Coding

  * Fixed Python 3.7 and above code environments due to backwards-incompatible change in urllib3

  * Fixed visual ML preset packages for Python 2.7

  * API: Fixed ‘JoinRecipeSettings.add_condition_to_join’ method




### Code Studios

  * Fixed building of Streamlit block due to third-party dependency change




## Version 11.4.2 - April 26th, 2023

DSS 11.4.2 is a bugfix release

### Recipes

  * Join: Fixed inability to save recipe with pre-join computed columns

  * Join: Fixed issue with pre-join computed columns with BigQuery datasets

  * Window: Fixed issues with dates in Window recipe with BigQuery datasets




### Govern

  * Fixed inability to request final approval when there is no feedback group




### Notebooks

  * Added ability to import Jupyter notebooks created by Databricks

  * Added ability to import Jupyter notebooks that do not have “kernel information”

  * Fixed drag-and-drop of queries in SQL notebook




### Spark

  * Added performance warning when trying to use a connection that uses proxy in Spark

  * Added ability to run Spark jobs even if some connections have broken password encryption due to being copied from other instances




### Performance & Scalability

  * Fixed possible instance hang when OAuth2 token endpoints used in plugins (such as Sharepoint) are unresponsive

  * Improved performance when changing permissions for users or groups impacting many projects

  * Reduced log verbosity in some locations in order to improve performance on IO-starved instances

  * Reduced IO cost in several locations in order to improve performance on IO-starved instances




### Miscellaneous

  * Removed excessive logging about SSL from Python recipes

  * Removed experimental flag frop auto-fast-write for Snowflake, Databricks, BigQuery, Redshift, Synapse

  * Fixed possible job identifier conflicts leading to failures of recipes running on Kubernetes

  * Added support for some wrongfully-formed Snowflake connections with Snowpark, when the specified Snowflake host is not a valid host name.




## Version 11.4.1 - April 6th, 2023

DSS 11.4.1 is a security and bugfix release

### Coding & Notebooks

  * Python API: Brought back compatibility with legacy dropAndCreate parameter of the write_with_schema method

  * Fixed unrecoverable notebook after kernel crash when using UIF and Python 3.7 builtin env




### MLOps

  * Removed dependency on pandas & six packages for Python export of models




### Dashboard

  * Fixed downloading of chart as Excel from insights




### Performance and scalability

  * Added cgroups support to Python scenarios steps and triggers, Python metrics and Python checks

  * Fixed possible hang of Jupyter subsystem

  * Fixed possible slowdown of code studios due to missing cleanup of Git history




### Security

  * Implemented stricter permissions on ML related files in the datadir

  * Disabled usage of Git hooks by default




### Misc

  * Fixed possible authentication rate limiting issue between Okta and Snowflake




## Version 11.4.0 - March 17th, 2023

DSS 11.4.0 is a significant new release with both new features, performance enhancements and bugfixes.

### Major new features and enhancements

#### Python 3.11

Dataiku DSS now supports Python 3.11 for use in code environments

#### Group K-Fold

Dataiku DSS now has support for group k-fold for both cross-validation and cross-test of AutoML prediction models

### Other enhancements and fixes

#### Visual Machine Learning

  * Improved logs when distributed hyperparameter search failed, in order to ease troubleshooting

  * Improved error message when scoring & evaluation recipes fail

  * Improved display of hyperparameter search report table

  * Added the list of preprocessed features to the Features tab of Model Evaluations

  * Fixed custom metrics

  * Fixed “open logs” button on clustering models

  * Fixed failure of scoring recipe when input is empty

  * Fixed computation of row-level explanation for multiclass prediction models

  * Fixed scoring on SQL engine with preprocessing options that drop rows

  * Fixed scoring with explanations on a model trained with sample weights when using the input as explanation background and said input lack sample weights

  * Fixed scatter charts and model views of model reports on dashboards

  * Fixed deprecated “conditional outputs”

  * Fixed API node endpoint using integer features (int64 dtype) with pandas 1.3 to 1.5

  * Fixed display of Stopping tolerance & Max iterations in reports of SGD models

  * Fixed a rare display issue on the scatter plot of clustering model reports

  * Plugin models: fixed loss of parameter values when switching between plugin models




#### Visual Time Series forecasting

  * Added a protection against far too high number of time series

  * Added the `maxiter` parameter for the AutoARIMA model




#### Charts & Dashboards

  * Added limit to 10’000 values for alphanumeric filters

  * Added warning when alphanumeric filter limit is reached

  * Boxplots: Fixed wrongful “too many objects to draw” limit

  * Boxplots: Fixed “Automatic” mode on date breakdown

  * Scatter plots: Fixed thumbnails

  * Removed wrongful “max memory” setting

  * Increased display limit, notably for line charts with many lines

  * Improved default selection of “Include others” versus “Exclude others” mode for filters

  * Dashboard export to PDF and image can now take filters into account

  * Fixed error with dataset insight with filters




#### Govern

  * Added a view selector in the blueprint and custom page designers

  * In role and permissions blueprint-specific settings, added an indicator of the role assignment rules defined for each role

  * Fixed issues with the configuration of views for reference fields

  * Fixed lists so that moving items doesn’t create empty placeholders

  * Added “No value” in filters where relevant




#### MLOps

  * Fixed evaluation recipe failures while computing the drift analysis sample

  * Fixed evaluation recipe not outputting the evaluation columns in the output dataset for Keras modes

  * Made sure that the execution of the evaluation recipe will not change the output dataset schema

  * Fixed filtering of test queries in the API designer while using the search box

  * Fixed the “Clear model versions” failing with MLflow imported models

  * Fixed issue with boolean types for MLflow imported models




#### Feature Store

  * Fixed display of count of feature groups

  * Various display improvements




#### Datasets

  * Azure Blob: Fixed ability to remove proxy on Azure after it has been used once

  * S3: Fixed renaming of files when SSE-KMS mode is used

  * BigQuery: Fixed major bugs with handling of input tables containing DATE or DATETIME columns

  * BigQuery: Fixed tables listing not taking into account all projects

  * BigQuery: Much faster listing of tables

  * BigQuery: Added ability to use SQL Script on connections that do not have an associated GCS connection

  * BigQuery: Added ability to read tables containing JSON, INTERVAL, TIME, BYTES and GEOGRAPHY types

  * BigQuery: Added ability to write into a BigQuery partitioned by a DATE

  * ElasticSearch: Fixed various issues in the Search tab

  * Improved detection heuristic for ORC and Parquet files

  * Improved error reporting for Delta Lake file format

  * Fixed error when no partition exists in a files-in-folder dataset




#### Recipes

  * SQL query: Added execution plan even when output dataset is not SQL

  * Prepare: Fixed an error when clicking very quickly in columns selectors for processors

  * SQL engine: Added support for now() formula on SQLServer

  * SQL engine: Added support for inc() formula on SQLServer

  * Fixed display issue in recipe creation modal when “override schema” is allowed on the connection




#### Flow

  * Automatically retry with alternate flow layout algorithm if the regular algorithm fails

  * Fixed bug with flow copy that could wrongfully fail

  * Flow Document Generator: fixed error with window recipe

  * Flow Document Generator: fixed error with plugin recipes




#### Metrics and checks

  * Added more logging of checks outputs in order to ease troubleshooting

  * Fixed Python probe with duplicate name not getting computed




#### Hadoop

  * Added support for Cloudera CDP Private Cloud Base 7.1.7 SP2 (aka 7.1.7.p2000)

  * Fixed issues with case-sensitivity in Hive partitioning detection

  * Fixed Hive tables hidden by default in connections explorer

  * Fixed default settings generated for Spark 3 on Cloudera CDP




#### Elastic AI

  * Added automatic detection of “low on ephemeral storage” error when running Spark jobs

  * Added more logging of state of pods for containerized execution, in order to ease troubleshooting

  * Added warning when trying to use a non-fully-built code env for PySpark recipe

  * Added more logs to the various cloud Kubernetes support

  * Google Compute Engine: Fixed support for Tensorflow and Torch not working out of the box




#### Cloud Stacks

  * Google Compute Engine: Added support for GKE 1.26

  * Azure: Fixed failure when a wrong DNS zone id is given




#### Webapps

  * Added ability to retrieve complete logs of a webapp backend

  * Fixed failure saving plugin webapps from Edit tab




#### Code Studios

  * Added a scenario step to stop Code Studios

  * Fixed CLI build of code envs used in Code Studios on Automation node

  * Added protection against empty names for Code Studio templates

  * Enhanced the experience of editing files directly in Code Studios




#### Deployer

  * Fixed missing detection of pandas version change when updating a bundle on Automation node

  * Added ability to fetch more logs from API deployments on Kubernetes




#### Scenarios

  * Added timeout to email reporter to avoid hang with unresponsive email servers

  * Removed unusable options when using the “Webhook” option for Slack reporter

  * Added ability so specify dashboard filters in the “Export dashboard” scenario step




#### Administration

  * Fixed “assign users to groups” mass action on Users list page

  * Added timestamp to audit log events sent to Kafka

  * Added encryption of password in Kafka connection




#### Performance and Scalability

  * Performance enhancement for code studio startup that could lead to global slowdown

  * Performance enhancement for updating very large code libraries coming from Git

  * Fixed memory leak when using API for visual statistics

  * Fixed memory leak upon uploading files to managed folders

  * Fixed small leaks

  * Fixed possible hang when creating a managed folder on a non-responsive data source

  * Fixed possible crash when fiddling with max memory settings on charts

  * Added safety against memory overruns when computing thousands of metrics with DSS engine

  * Reduced amount of metadata copied to each job for enhanced performance




#### Sanity checks

  * Added check for unsupported filesystem type for DSS datadir

  * Added check for “noexec” flag on /tmp

  * Added check for legacy Python 2.7 in use

  * Added check for removal of default audit log

  * Added check for incompletely configured event server

  * Added check for manual installation of packages in the builtin environment




#### Miscellaneous

  * Fixed R failures not detected while building containerized execution base image

  * Added ability to duplicate projects even when a connection is missing

  * Added better explanation for “decryption failed” errors when wrongfully using encrypted passwords

  * Fixed issues with sorting of tags

  * Fixed UI display issue in application designer

  * Made DSS start and stop timeout configurable for larger instances that may need more time

  * Added experimental support for running DSS on RedHat 8 with FIPS-140-2 mode enabled

  * Added support for storing the passwords encryption key in AWS Secrets Manager




## Version 11.3.2 - February 24th, 2023

DSS 11.3.2 is a bugfix release

### Hadoop and Spark

  * Add support of Spark 3.3 on CDP 7.1.8




### Elastic AI

  * Fixed containerized notebooks failing to stop when using the Python 3.7 built-in environment




### Visual ML

  * Fixed missing charts in subpopulation analysis of binary classification models

  * Fixed incorrect display of What-If analysis in the overall view of partitioned regression models




### API Node

  * Added authentication on time series forecast API endpoints




### Charts

  * Fixed possible issue on pie and donut charts when browser zoom level is set above 100%




### Workspaces and dashboards

  * Fixed browser navigation history in Workspaces > See all

  * Fixed layout issue near the slides selector of a dashboard when viewed from a workspace

  * Fixed dashboard export failing when an export hook is defined

  * Fixed numerical filter slider incorrectly updating boundaries on dashboard




### Connections

  * Fixed global variables in connection options incorrectly resolved at dataset creation time




### Misc

  * Fixed keyboard navigation in searchable dropdowns

  * Fixed possible instance hanging when a lot of job activities are running concurrently




### Security

  * Fixed [Directory traversal via download action of file editor](<../security/advisories/dsa-2023-001.html>)

  * Fixed [Directory traversal through git symlink support abuse](<../security/advisories/dsa-2023-002.html>)




## Version 11.3.1 - January 26th, 2023

DSS 11.3.1 is a bugfix release

### Visual recipes

  * Fixed the run button from GeoJoin and FuzzyJoin recipe screens




## Version 11.3.0 - January 25th, 2023

DSS 11.3.0 is a significant new release with both new features, performance enhancements and bugfixes.

### Major new features and enhancements

#### “Unmatched” outputs for Join recipe

It is now possible in the Join recipe to define additional outputs (additional output datasets) that contain the rows of the joined datasets that did not match the join conditions

#### Improved chart and dashboard filters

Filters on charts and dashboards now offer the ability to select whether they operate in “only include selected values” or “only exclude unselected values” mode.

In addition, it is now possible to share the URL to a dashboard preconfigured with filters, which also allows to embed such a configured dashboard

#### Image feed view in Dataset explore

An “images feed” view is now available in Explore for datasets containing images. If the dataset contains image annotations, they are also displayed

#### Image and Geo preview in Dataset explore

Using “Shift+V” on dataset explore on cells containing images or Geographic data will now show a preview of the image or a map with the geographic data

#### Contextual recommendations in Help center

The Help center now displays - in a new Recommendations section - some help articles that are relevant given the current context.

#### New Deep Neural Network algorithm

A new Deep Neural Network based algorithm has been added for prediction of tabular data, for both regression and classification, with hyperparameters serach and GPU support.

#### Multiple forecast horizons on Visual Time Series Forecasting

Visual Time Series Forecasting can now evaluate performance on multiple time horizons

#### Export filtered view of a Dataset

Added ability to apply the interactive filters when exporting a dataset in a project, in a workspace or in an insight.

#### Per-feature view in Feature Store

In addition to the per-feature-group view, the Feature Store can now display on a per-feature basis

### Fixes and smaller enhancements

#### Charts

  * Pie & Donut: Better handling of labels positions

  * Formatting: Added a “None” option for Multipliers to allow users to specify they don’t want any multiplier.

  * Various performance and scalability enhancements

  * Removed additional scrollbar added to the page when a Bubble map chart is displayed.

  * Fixed issue that caused Time Series chart brush to be missing on insights views.

  * Fixed unwanted color change when adding a second dimension to a Treemap

  * Fixed deletion of charts that are not the currently selected one




#### Dashboards

  * Fixed issue in dashboards filters where a NaN item was added instead in place of a “No value” item

  * Fixed issue where a dashboard filter of type range could be missing the “clear all” button

  * Fixed issue where values in a dashboard filter would be considered as numerical even when a text meaning has been enforced

  * Fixed dashboard insights removing rows with empty cells even when configured to keep them.

  * Fixed deactivated filters sometimes not taken into account

  * Fixed issue in chart filters where all values would be checked while clicking to check only one

  * Fixed missing reset of selection when switching between date filter types

  * Fixed switching from “As text” view to the range view in numerical filter facets

  * Fixed missing refresh of insights when clearing filters

  * Fixed broken edition of numerical filters with in-database engine




#### Workspaces

  * The list of workspaces can now be expanded and filtered

  * Applications shared to a workspace now display their own images in the grid view

  * Added ability to create new workspaces directly from the home page

  * Fixed access to attached images in Wikis

  * Fixed “Go to Source webapp” button




#### Datasets

  * Fixed display of cell preview in Explore near the bottom of the screen.

  * Fixed timeshift that appeared when a dataset containing dates was exported to an Excel file

  * BigQuery: Fixed issue preventing users that are not administrators to create a BigQuery connection using the built-in driver.

  * GCS: Fixed error reporting when failing to write

  * ElasticSearch: Added exact hit count in Search view




#### Recipes

  * Prepare: Updated French and Indian holidays for 2023 & 2024

  * Prepare: Slightly improved the user interface of the Formula editor

  * Prepare: Fixed issue where the Fill empty cells processors would not fill some empty cells

  * Prepare: Fixed UI issue with too many conditions in the “If, Then, Else” step

  * Grouping & Window: Fixed cut off of some options, preventing selecting the last columns

  * Stack: Fixed failure when post-filter conditions reference a column that is not present in all input datasets

  * Join: Fixed issue where removing all inputs would leave the recipe in a broken state.




#### Flow

  * When clicking on an item in the flow, the upstream and downstream paths are now highlighted across flow zones.




#### Webapps

  * Fixed access to public webapps when user is logged in but has no permission on the project




#### Notebooks

  * Notebook outputs are now saved into a different folder than the notebooks themselves. This avoids storing large files or sensitive data into version control systems.

  * Fixed ability to interrupt cells in notebooks running on Kubernetes




#### Code Studios

  * Added an indicator when a Code Studio is running with an old version of a template

  * When updating a code env, added a suggestion to automatically rebuild the Code Studio templates using it

  * Added a richer out-of-the-box sample when creating a Streamlit webapp

  * Fixed failing fetch of code env resources from a Code Studio




#### Coding & API

  * Fixed issue where files from Projects libraries deleted in the remote git would not be correctly deleted when pulling changes.

  * Fixed `DSSSavedModel#get_object_discussions()` Python API

  * Added ability to import Snowflake tables from a specified database via the python API

  * Added ability to import BigQuery tables from a specified BigQuery project via python API

  * Improved documentation (docstrings) of Python APIs

  * Added logging of memory usage in Python recipes running in containers to ease troubleshooting of memory issues

  * Fixed display of the error when uploading a code env resource fails

  * Fixed scrolling of code samples

  * Fixed API to retrieve instance logs in subfolders

  * Fixed ``dkuspark.get_dataframe`` when using a Spark session with Spark 3.3




#### Visual Time Series Forecasting

  * Improved tooltips and legibility of forecast charts

  * Added support for orders parameters of AutoARIMA model to be 0

  * Fixed the Quarterly frequency

  * Fixed the end date of extrapolated data when it falls on the exact end of the model’s period

  * Fixed failing training of AutoARIMA model when hyperparameter search is disabled and `d` or `D` parameter is set




#### Computer Vision

  * Fixed a failure when using both augmented and non-augmented features in a single Visual Deep Learning model

  * Fixed Algorithm information of Image Classification models

  * Fixed Computer Vision model training when images are missing in the train set

  * Fixed Computer Vision code environment setup that could cause failure of Object Detection model training




#### Visual Machine Learning

  * Added ability to export Lab models’ Predicted data

  * Improved handling of NaN values when aggregating or optimizing metrics over multiple folds

  * Sped up interactive model scoring (What-If)

  * Sped up listing of partitioned models

  * Added clarifications when comparing models with different values for parametric metrics (cost matrix gain, lift)

  * Fixed training of custom linear models that do not expose `predict_proba` for binary classification tasks

  * Fixed blank Algorithm information section for clustering algorithms in dashboards

  * Fixed export of Partial Dependence Plot data when a column name contains special characters

  * Fixed notebook export of some Visual ML models when using sample weights

  * Fixed reproducibility of Visual ML models using Text features with Hash+SVD handling

  * Fixed the Metrics output of Evaluation recipes running in containers, which would end up empty when it is the only output

  * Fixed duplicate metrics in Model Document Generator




#### Labeling

  * Fixed wrongful bounding boxes when they are very small




#### MLOps

  * Added an option in the evaluation recipe to directly process raw API node audit log

  * Added the computation of prediction drift even when there is no ground truth.

  * Added an option in the scoring recipe to output model metadata in the resulting dataset

  * In the scoring recipe, removed the ability to use ‘Try to restructure the MLflow model outputs’ options when the imported model has a prediction type ‘Other’, to avoid failing the execution of the recipe

  * Fixed several issues with subpopulation analysis in model evaluations

  * Added the possibility to deploy an Experiment Tracking run as a Saved Model Version through the public API (with lineage)




#### Deployer

  * Fixed variable expansion within bundled connection settings when used from API Designer test queries

  * Added a warning discouraging the removal of a kubernetes deployment that was not previously disabled

  * Smarter plugin check for bundle deployment and project import




#### Collaboration

  * Mailto links are now properly rendered in wikis

  * Fixed ability to open a project in a new tab from the projects list and from the home page.

  * Added user profile setting to enable/disable notifications for jobs and scenarios running under user’s account

  * Improved filtering of projects on the home page. Projects perfectly matching the typed characters now appear first.

  * Reference documentation and Knowledge base articles now open directly in the help center.




#### Scenarios

  * Reduced the “maximum lateness” of weekly triggers




#### Govern

  * Allowed more HTML elements in the content of view components’ documentation fields (incl. iframes).

  * Aligned governance status icons between the Govern node and the Designer.

  * Fixed blank home page in the case of SAML misconfiguration.

  * Improved the display of links to projects when a govern project is used for multiple Dataiku projects.

  * Fixed highlighting of current item in the main menu.

  * Added ability to expand multiple nodes in hierarchical lists (Model & Bundle registries, Governable Items).

  * Prevent artifacts from being automatically governed with the standard blueprint version when there are custom ones available.




#### Plugins

  * Fixed issues with Python libraries in plugins installed from Git




#### Performance & Scalability

  * Reduced memory requirement for the DSS backend through compression

  * Reduced memory requirement for the DSS backend when having Jupyter notebooks with very large results

  * Performance improvements when running jobs in projects with many past job runs

  * Fixed UI performance issue in code env “resources” screen

  * Fixed possible sampling failure in explore due to memory limit not being enforced for some sampling methods

  * Fixed possible hang related to audit messages

  * Fixed rare failure when running prepare recipes with Python steps on Spark with multiple cores per executor

  * Added automatic workaround for excessive memory consumption of the Redshift JDBC driver




#### Cloud Stacks

  * Added ability to mass-delete snapshots

  * AWS: Fixed ability to reference a secret in another region

  * AWS: Added missing regions in secret manager region selection

  * Azure: Fixed deletion of disks without name

  * Azure: Fixed error when using different startup and runtime managed identities

  * Better license management page in Fleet Manager

  * Prevent DSS startup in case of wrongful event server configuration

  * Fixed possible error on the fetch license usage action in Fleet Manager when different license formats are used




#### Elastic AI

  * Removed default backend from default Ingress configuration

  * Fixed SparkR on Elastic AI




#### Hadoop & Spark

  * Added support for Spark 3.2 on CDP 7.1.7




#### Miscellaneous

  * Added instance sanity check for missing or wrongful cluster selection

  * Added instance sanity check for wrongful addition of “pyspark” in a code env

  * Fixed possible failure of code env usage in presence of broken ML models

  * Fixed possible failure of API designer in presence of broken ML models

  * Event Server: Added automatic refresh of Azure OAuth token, making these connections usable for Event Server




## Version 11.2.1 - January 11th, 2023

DSS 11.2.1 is a bugfix release

### Coding

  * **New feature** Added API for Govern




### Machine Learning

  * Fixed update and retrain of very old DSS models

  * Fixed data drift computation in evaluation recipe with containerized execution




### Charts

  * Fixed chart switching that sometimes did not refresh the chart

  * Fixed date range slider widget when selecting the same day




### Cloud stacks

  * GCP: Fixed Fleet Manager startup when no SSH key is provided




### Code environments

  * Fixed broken build of code environments due to publication of newer numpy




### Flow

  * Fixed possible instance slowdown when copying part of a Flow




### Projects

  * Fixed folder browsing in projects list

  * Fixed issues with revert of single commits in project versioning which could lead to broken project in case of conflict




## Version 11.2.0 - December 13th, 2022

DSS 11.2.0 is a very significant new release with both new features, performance enhancements and bugfixes.

### Compatibility note

DSS 11.2.0 now requires version 3.13.20 or higher of the Snowflake JDBC driver. For most users, no action is necessary as the proper driver is builtin in DSS. Action is only required if you had customized the JDBC driver.

### Major new features and enhancements

#### Rename datasets

Renaming datasets is now a supported operation, available directly from the right panel of datasets.

DSS automatically updates impacted recipes, shares, …

#### Databricks connection

It is now possible to directly connect to Databricks SQL endpoints and to manage Databricks tables in DSS. This includes writing.

A fast-path load/unload between Databricks and cloud storages is also available, with automatic fast-write from any recipe.

The Databricks connection supports the Unity catalog and push-down of computation to Databricks.

#### New help center

The help center has been overhauled to offer a single interface gathering all resources available to users to help them during their data journey.

This feature requires users to have Internet access and is not enabled by default. It must be enabled by DSS administrators.

#### Search in ElasticSearch datasets

ElasticSearch datasets now have a new “Search” tab in order to directly search within datasets.

Search queries can be saved

The “Filter/Sampling” recipe now also has the ability to filter ElasticSearch datasets using a search query, and can be created directly from the Search view.

#### Image View

Datasets now have an “Image” view, which can show datasets containing references to images stored in a managed as an “image gallery” view.

Image view can also display labeling annotations.

Image view is automatically enabled on outputs of labeling tasks, and can be manually enabled for any dataset containing paths to images.

### Fixes and smaller enhancements

#### Recipes

  * **New feature** : Prepare: Added “is any of” and “is none of” operators in “if, then, else” processor

  * Prepare: Fixed “if, then, else” processor in presence of invalid formulas

  * Prepare: Fixed an error with “if, then, else” processor in SQL mode

  * Prepare: Fixed an error with “if, then, else” processor in Visual Analysis

  * Prepare: Fixed the ability to delete the first statement in the “if, then, else” processor

  * Prepare: Fixed minor UI issues on Firefox

  * Prepare: Fixed “Click to configure sample” link

  * Prepare: Fixed some cases where formula validation would write an error whereas the formula was valid

  * Prepare: Added inline documentation for formula functions in the Formula Editor

  * Join: Fixed “replace input dataset” with a foreign dataset

  * SQL: SQL recipes can now have a SQL query dataset as input

  * Hive: Fixed missing variables in the “Variables” left panel

  * Fixed issues with visual recipes with regards to dates on source SQL datasets




#### Visual Statistics

  * Time Series capabilities in Visual Statistics are now multiple-time-series capable.




#### Image Labeling

  * Review now shows score for each labeler

  * Clarified status of images when reviewing or annotating

  * Other minor fixes in the Annotate and Review tabs




#### Visual ML

  * **New feature** : Added ability to export the train/test sets of a Lab model to a dataset

  * **New feature** : Time Series: Visual ML API now supports creating, training and using time-series models

  * Time Series: Added support for CUDA 11.0 and 11.2 in GPU-enabled Visual time series forecasting, see [Runtime and GPU support](<../machine-learning/time-series-forecasting/runtime-gpu.html>)

  * Time Series: Time series identifier columns can now be used as features of multi-time-series models

  * Time Series: Scoring & evaluation recipes now display the required number of past values

  * Time Series: Improved performance of result screens for multi-time-series models with many time series

  * Time Series: Improved default values for hyperparameters

  * Time Series: Added support for distributed hyperparamer search in the train recipe

  * Time Series: Fixed the “target encoding” numerical feature handling

  * Time Series: Fixed multi-time-series forecasting endpoint scoring on an API node

  * Time Series: Fixed requirements for training forecasting models in containers with GPU

  * Time Series: Clearer error when some series lack enough data to forecast when using a multi-time-series models

  * Sped up “Tokenize, hash and apply SVD” handling for text columns

  * Updated suggested list of packages for Visual ML

  * Improved handling of errors in custom metrics in the evaluation recipe

  * What If: added filter, search and sorting of input features in the comparator

  * Added compression for clustering models’ data splits, to save disk space

  * Added support of sample weights when computing the probability density function of regression models

  * Fixed a condition where a failed or aborted train of Computer vision model would not clear temporary files

  * Fixed usage of Outlier Detection with Isolation forest models

  * Fixed row-level prediction explanations in Scoring recipe for custom & plugin models

  * Fixed shuffling in Visual Deep Learning when using Tensorflow 2

  * Fixed incorrect parallel coordinates plot in What If outcome optimization results

  * Removed potentially large logging of the serialized XGBoost trees in multiclass prediction

  * Fixed threshold slider not shown in a model partition

  * Fixed notebook export of XGBoost model when using sklearn 1.0+

  * Added the fold ID of each row in a Lab model’s Predicted data

  * Added support for CUDA 11.1-compatible GPUs for Computer Vision model training




#### Datasets

  * Settings: Fixed spurious prompt for saving changes when no changes have been made

  * Explore: Fixed right-click menu when columns coloring is active

  * Explore: Fixed issues enabling/disabling columns coloring

  * Uploaded datasets: Fixed ability to upload to local filesystem connections that are on a different filesystem as DSS

  * S3: Fixed per-bucket AWS credentials on the non-default managed bucket

  * SQL datasets: Add ability to define default value for “Assumed time zone” at the connection level.

  * Catalog: Fixed error about duplicated column names when importing an indexed table that was present in multiple catalogs

  * ElasticSearch: Fixed ability to delete projects containing datasets pointing to deleted ElasticSearch connections

  * ElasticSearch: Added the ability to import indices-based partitioned ElasticSearch datasets

  * Azure Blob: fixed browsing of Azure Blob containers containing unnamed folders

  * Fixed issues with browsing managed folders on S3, Azure Blob and GCS




#### Coding

  * Code Recipes: In the recipe editor, it is now possible to only show the Python or R messages when a code recipe fails

  * Code Studios: Added ability for administrators to change the owner of a Code Studio

  * Code Studios: Made it easier to use code envs in Visual Studio Code

  * Code Studios: Added ability to open just the Code Studio in another tab

  * Snowpark: Fixed connection error with Snowpark if a dataset has an empty schema

  * Snowpark: Run post-connection statements defined in the connections when connecting to Snowpark

  * Fixed case where failure to write to SQL datasets from Python or R could go undetected, leading to empty output and wrongful “success” of the job




#### MLOps

  * Drift: Added more capabilities for selecting reference for data drift in the standalone evaluation recipe.

  * MLflow import: Added the ability to override the default threshold (0,5) when importing a MLflow model with the public API or through experiment tracking

  * MLflow import: fixed Model Evaluation display issue when the corresponding Saved Model has been deleted.

  * Python export: Fixed an issue with the handling of missing columns in python exported models.

  * Fixed an issue with the Evaluation Recipe when using the weighting strategy “sample weights”

  * Fixed inconsistent color assignment in a model evaluation’s drift tab.

  * Fixed missing model evaluation store when used as input of a python recipe.




#### Charts

  * Boxplots: Added ability to customize Y axis range on boxplot charts

  * Lines: Lines are now thicker by default

  * Treemap: Removed spurious action on click

  * Changed compute along wording when using an aggregation function: now displays the actual dimension name instead of First or Second

  * Legend now displays a tooltip when labels are too long

  * Fixed error that appears when clearing all filters in a Pivot table

  * Fixed invalid filtering applied when adding a tooltip to a Scatter Geometry Map

  * Fixed thumbnail size in model charts

  * Fixed prompting user to save chart insight even though no changes have been made

  * Fixed overflowing controls in the left panel of charts screen with Firefox

  * Fixed incorrect dates displayed in Scatter plot charts as they were interpreted using the local timezone instead of UTC

  * Fixed tooltips disappearing after trying to pin a tooltip

  * Fixed availability of filters on plugin-provided chart types




#### Flow

  * Improved naming of copied recipes to avoid recipes ending up called like recipe_1_1_1_1_1_1_1

  * Fixed impossibility to add tags on saved models from the Flow view

  * Fixed “Schema changed” warning not appearing on final datasets in append mode




#### Workspaces

  * Fixed adding multiple times the same dataset to a workspace




#### Scenarios

  * Added ability to not propagate the warning state of a job to the scenario that started it

  * Fixed renaming of scenario which was deleting all steps under some circumstances

  * Fixed issue with scenario API when scenario name contains spaces

  * Fixed target dataset of build steps in scenario not being built when they are virtualized as part of a SQL pipeline




#### Govern

  * New tabs have been added to the right panel

  * The “Governable Items”, “Model Registry” and “Bundle Registry” pages are now organized hierarchically per project.

  * The artifact page has been reviewed, and the workflow steps are now in a menu on the left.

  * Standardized date formats.

  * Lots of UI adjustments (icons, links appearance, etc)

  * Added link to Dataiku Design or Automation next to corresponding governed object’s names.

  * Added warnings on fields for artifact invalid states (ex: wrong cardinality for a list).

  * Added full sync on design project’s git event (checkout, pull).

  * Added more logs for sync progress.

  * Improved the creation of Blueprint Versions.

  * Fixed hard to read heatmap legend in dark mode.

  * Put the name of the saved model version instead of its identifier in the governance status inside the deployer.

  * Fixed bad display of the Global API keys table when the names or descriptions of keys are too long.




#### Deployer, API and automation nodes

  * Removed empty log in “run and test” of API service of the deployer.

  * Unlocked Ingress exposition mode at deployment level for non-admin users.

  * Fixed issue with Wiki taxonomy on automation node after activating a new bundle

  * API node: added audit logs for failures

  * Fixed dsscli code-env-rebuild-images on automation nodes




#### Cloud Stacks

  * Added ability to override the automatic tuning of the DSS memory sizing

  * Added ability to restart the instances even if they are not responsive

  * Added ability to disable/enable setup actions

  * Added a description on instances

  * Added ability to duplicate an instance settings template

  * Added ability for Fleet Manager to use a proxy to retrieve updated instance images and DSS licenses

  * Added management of Git SSH keys as a setup action

  * Fixed truncated user name in the navigation bar

  * API: Fixed wrongful error when requesting a non-existing virtual network

  * Azure: Added ability to create all Fleet Manager resources created by the ARM template

  * Azure: Updated the default instance type for the Fleet Manager instance

  * Azure: Switched to incremental snapshots

  * Azure: Added ability to stop and start instances

  * Azure: Fixed reprovisioning from snapshot when data volume has an explicit name

  * GCP: Fixed ability to SSH into long-running instances




#### Elastic AI

  * Upgraded to Spark 3.3

  * Added ability to configure the deployment timeout for API deployments on K8S

  * Improved performance of job startup when using managed namespaces

  * Added a clear error message if a custom Kubernetes request or limit is set but without a value

  * Improved error logging for troubleshooting issues creating managed clusters

  * Fixed broken warning for non-distributed Spark read on SQL datasets

  * Reduced the load on Kubernetes and DSS host generated by webapps hosted on Kubernetes

  * EKS: Added native support (without YAML) for fully-private clusters

  * AKS: Added ability to create fully-custom clusters with JSON configuration

  * AKS: Fixed ability to run and benefit from GPU instances out of the box




#### Hadoop & Spark

  * Added support for CDP 7.1.8




#### Performance & Scalability

  * Performance improvements in browser notifications

  * Sped up listing of numerous Hive databases when creating new notebooks

  * Sped up listings of connections in presence of numerous Hive databases in the Connections explorer

  * Fixed slow preloading of bundles when there are a large number of previous versions

  * Fixed a possible instance hang when uploading new files in an uploaded files dataset




#### Security

  * Fixed blank usernames for disabled or deleted users on project security page

  * Added ability to retrieve the creation date of users

  * Hid the Impala truststore password value from the UI

  * Added an API to retrieve the authorization matrix of DSS




#### Plugins

  * Fixed pluginParams wrongfully visible to non-admin users




#### Misc

  * **New feature** : API: Added an API to list webapps and start and stop them

  * **New feature** : Sanity check: quickly check for various possible configuration issues in your DSS instance

  * Added ability to return PDF from a managed folder

  * Fixed possible failure of Spark recipes when there are non-readable plugins

  * Fixed a rare race condition that could make Visual Statistics or Explore fail when the dataset is used in multiple times at once

  * Fixed failure of “Code Env usages” page when a model was broken by incorrect configuration or API calls

  * Prevented hard-to-investigate failures when installing standalone Hadoop integration with a wrongful software archive

  * Fixed options for code env rebuild not working in automation node

  * Made webapps startup timeout configurable instead of hardcoded to 30 seconds

  * Fixed “trust” capability for Code-Studios-powered webapps




## Version 11.1.4 - December 9th, 2022

DSS 11.1.4 is a security and bugfix release

### Code studio

  * Fixed running R recipe from RStudio




### Security

  * Fixed [Race condition on UIF can lead to account takeover](<../security/advisories/dsa-2022-023.html>)




### API Designer

  * Migrate API designer endpoints when importing project from older versions of DSS




## Version 11.1.3 - November 29th, 2022

DSS 11.1.3 is a bugfix release

### Cloud Stacks

  * Added the ability to have more than 255 characters of cloud-level tags

  * Fixed instances creation for which label is not set




### Datasets

  * S3: Automatically disable “switch to bucket region” when a custom S3 endpoint is specified, since it will not work in that case




### Visual recipes

  * Join recipe: Fixed an issue in the UI post-join computed columns

  * Prepare recipe: Fixed ‘Remove rows on empty’ processor not filtering out empty strings coming from SQL datasets with DSS engine




### Scenarios

  * Fixed error when running a scenario with a user who has “Read project content” & “Run scenario” when there is at least one workspace on the instance




### Dashboards

  * Removed unnecessary vertical scrollbar on charts insights




### Spark and Kubernetes

  * Fixed spark-on-K8S for kube version >= 1.24 if the target namespace is not the default namespace




### API Node

  * Fixed migration of very old API nodes




## Version 11.1.2 - November 15th, 2022

DSS 11.1.2 is a bugfix and security release

### Visual recipes

  * Prepare: Fixed various issues in French vacation flagging




### Charts

  * Made the chart switcher suggestions more consistent

  * Fixed loading of KPI chart on dashboard

  * Fixed numerical formatting options not being saved




### Elastic AI

  * Fixed notebooks on Kubernetes not starting with Elastic AI clusters




### Cloud Stacks

  * Fixed reprovisioning of instances on GCP after many previous reprovisionings




### Models export

  * Fixed numpy warnings when scoring

  * Removed dependency on old version of numpy




### Performance and scalability

  * Fixed missing protection against memory overrun for boxplot charts

  * Fixed possible instance hang related to Hive support




### Security

  * Fixed [missing authentication on internal API call](<../security/advisories/dsa-2022-021.html>)

  * Fixed [XSS issue in notebooks](<../security/advisories/dsa-2022-022.html>)




### Misc

  * Added support for macOS Ventura in the macOS application




## Version 11.1.1 - October 25th, 2022

DSS 11.1.1 is a bugfix release

### Cloud Stacks

  * Fixed instances provisioning failing after upgrade in some circumstances




## Version 11.1.0 - October 21st, 2022

DSS 11.1.0 is a very significant new release with both new features, performance enhancements and bugfixes.

### Compatibility note

The version of one of the libraries used by Visual Time Series Forecasting, gluonts, has been upgraded. Time Series Forecasting models may need to be retrained.

### Major new features and enhancements

#### New chart types

  * Added a Treemap chart, ideal for representing data where dimensions form a hierarchy

  * Added a KPI chart, to display individual aggregated features as single numbers (such as global sum of sales)




#### Python export of models

It is now possible to directly export DSS models to Python code, for usage in any Python code outside of DSS. This comes in addition to the pre-existing Java export, for usage in any Java code outside of DSS, and PMML for usage in any PMML-compatible scoring system.

For more details, please see [Exporting models](<../machine-learning/models-export.html>)

#### MLflow export of models

It is now possible to directly export DSS models to MLflow, for usage in any MLflow-compatible scoring engine that is compatible with the “python_function” flavor of MLflow.

For more details, please see [Exporting models](<../machine-learning/models-export.html>)

#### Enhancement of Excel exports

  * Exporting to Excel now properly respects string fields with leading zeros, and does not remove leading zeros anymore (more generally speaking, Exporting to Excel now properly respects storage types)

  * Exporting to Excel now also shows dates as valid dates in Excel




#### Deployment of clustering models to API node

It is now possible to deploy clustering models to the API node, for direct attribution of clusters to previously-unseen records.

#### Model explainability for MLflow models

Imported MLflow models can now benefit from a large panel of model explainability capabilities, just like DSS-trained models.

#### Support for R 4

DSS can now use R 4. In order to use R 4, you need to run the R integration procedure with “R” in the PATH pointing to R 4. All code environments then need to be rebuilt.

Cloud Stacks setups are still on R 3.6, and will switch to R 4 in DSS 12.

#### Performance & Scalability

  * Much faster (up to thousands of times faster) computation of dependencies for extremely complex flow graphs (notably flows with multiple successive “branch-out / branch-in” patterns)

  * Global performance enhancement for all visual recipes running on DSS engine (up to 50% faster for sync and prepare recipes)

  * Significantly reduced overall memory consumption of the DSS backend with very large instances (many projects, datasets, ….)




#### Charts

  * New more efficient and clearer chart type switcher




#### Datasets

  * **New feature** : Support for Google AlloyDB

  * **New feature** : ElasticSearch: Added support for ElasticSearch 8

  * **New feature** : ElasticSearch: Added ability to list and import ElasticSearch indices from the connection explorer

  * **New feature** : S3: Added Ability to set bucket owner ACL when uploading to S3

  * ElasticSearch: Adding list of matching indices when importing an dataset with an index pattern

  * ElasticSearch: DSS now relies on ElasticSearch mapping for better schema inference

  * Clearer view of when you are viewing a sample versus the whole dataset




#### Machine Learning

  * **New feature** : Computer vision: Added interactive scoring for Image classification and Object detection

  * **New feature** : Time series: Added Hyperparameter search for time series models

  * **New feature** : Time series: Added support for comparing time series models

  * **New feature** : Stratified sampling for Machine Learning models




#### Elastic AI

  * **New feature** : Ability to view internal details of Spark-based recipes execution (through managed Spark History Server)

  * **New feature** : GKE: added support for regional clusters

  * **New feature** : Added support for Kubernetes 1.24

  * **New feature** : Added support for custom image pull secrets (primarily for non-cloud Kubernetes setups)




#### Scenarios, metrics, checks

  * **New feature** : Added variable expansion in SQL probes




#### Code envs

  * **New feature** : Added ability to use conda for code envs with Python 3.8 and Python 3.9




### Fixes

#### Datasets

##### ElasticSearch

  * ElasticSearch: Fixed support of non-managed datasets with an non lower-case mapping type

  * ElasticSearch: Fixed “empty” dataset error when creating a non-managed Elastic Search dataset without testing the index

  * ElasticSearch: Improved ElasticSearch dataset partitioning UI

  * ElasticSearch: Improved detection of OpenSearch

  * ElasticSearch: Fixed usage of global proxy

  * ElasticSearch: Fixed clearing of datasets on ElasticSearch 6 and above

  * ElasticSearch: Added support for variable expansion for external ElasticSearch datasets

  * ElasticSearch: Fixed schema consistency check when settings contain variables

  * ElasticSearch: Fixed schema consistency on managed datasets when first rows have empty values

  * ElasticSearch: Fixed hourly partition redispatch

  * ElasticSearch: automatically suggest an appropriate dataset name




##### Snowflake

  * Snowflake: Added ability to fetch table descriptions in connections explorer

  * Snowflake: Fixed auto-fast-write with append mode




##### Google Cloud

  * BigQuery: Fixed reading of BigQuery views with DSS built-in driver

  * BigQuery: Fixed hang in case of permission failure on the “Storage API” when using the built-in driver

  * BigQuery: Fixed failure of long jobs (> 1 hour)

  * BigQuery: Added ability to fetch table descriptions in connections explorer

  * Google Cloud Storage: Added ability to use Application Default Credentials (ADC) to access Google Cloud Storage

  * Google Cloud Storage: Fixed display issue in dataste Browse




##### Azure

  * Synapse and Azure SQLServer: Added per-user OAuth login using Authorization Code flow in addition to the previous Device Code flow

  * Azure Blob: Added ability to use non-standard Azure Blob endpoints for Azure Government compatibility

  * Azure Blob: Fixed issue with creation of managed folders when based on a gen2 storage account with hierarchical namespaces

  * Azure Blob: Fix magic markers not being properly cleaned up, which could lead Spark jobs to fail

  * SQLServer: Added support for multiple catalogs in the SQLServer connection




##### Other

  * Teradata: Fixed wrong parsing of type DATE in Teradata if the time zone session is different from GMT

  * Oracle: Fixed listing of partitions on Oracle tables with more than 500 000 rows

  * S3: Fixed display of the bucket name in the settings tab of dataset

  * SQL: Added support for multiple catalogs for “Other databases (JDBC)” datasets

  * Improved user experience and fixed several issues with moving and renaming files for cloud storages

  * Fixed error when overwriting manually a file in a managed folder by uploading it again

  * Fixed variables[“xxx”] syntax in dataset sampling settings

  * Fixed “Allow managed folder” flag on Filesystem based connections not properly enforced

  * Fixed last partition actions not being accessible in dataset metrics screen

  * Fixed UI layout overflow when using nested filters in dataset status tab

  * Added a warning message when trying to delete a dataset that is shared and used in other projects

  * Fixed “Change tracking” file not saved in the UI

  * Added dataset column meanings and descriptions in catalog

  * Added option in Explore’s “Display” menu to increase the range of decimal numbers that get displayed in natural form instead of scientific notation




#### Machine learning

  * Performance improvement for computation of performance metrics and evaluation recipes on binary classification models

  * Performance improvement for fetching result pages for saved models

  * Fixed issue switching from one sample weight variable to another

  * Fixed rare case of failure computing individual explanations

  * Fixed display issue in the hyperparameter optimization chart

  * Fixed training of Lasso-Lars models with K-Fold cross-test

  * Fixed possible failure computing lift curve with K-fold cross-test

  * Fixed evaluation of models with target encoding & feature selection enabled

  * Fixed cases where a code env that was not suitable for bayesian search could be detected as suitable

  * Fixed an issue where a single broken model could cause unability to compute drift in all related models

  * Don’t suggest the “Explore Neighborhood” or “Optimize outcome” when the required train-time computations have been disabled by the user

  * Added display of the Python version used to trained a python based model

  * Removed the ‘No hyperparameter search’ uninformative message when Search space limit is changed

  * Fixed the threshold bar on confusion matrix and assertions when the optimal threshold is 0

  * Fixed hyperparameter widget for integer field not ignoring wrong values

  * Hyperparameter search on Kubernetes: Improve the heuristic to determine the number of available CPU

  * Prevented exporting a model to Snowflake function if it is not supported

  * Fixed a frontend error on partial dependence plot when selecting a variable with special character

  * Dropped infinite values in target for regression algos to prevent training from failing

  * Fixed wrongful ability to enable pairwise feature interactions with rejected features that led to failure

  * Added What-If analysis capability on dashboards

  * Fixed Optimized scoring for multiclass partitioned models when some partitions are missing some classes

  * Fixed display of plugin provided algorithms when duplicating a ML task

  * Fixed training and scoring with python engine when date columns have values beyond year 2200

  * Fixed display of calibration curve tab for non probabilistic models

  * Fixed not-yet-scored item unexpectedly showing up in What-If comparator

  * Fixed confusion matrix for multiclass partitioned models

  * Fixed missing data in model evaluation stores when evaluating models trained with K-Fold cross-test

  * Fixed UI glitch on custom metric in model evaluation store

  * Model comparator: Fixed display of the champion icon when there is no data

  * Model comparator: Fixed display of count and TF/IDF vectorization when comparing feature processing

  * Fixed UI issue with nested filters in ML assertions

  * Fixed renaming of model evaluations

  * Fixed various small UI issues with model evaluation store

  * Fixed evaluation on models with a custom metric when “don’t compute perf” is enabled




##### Computer vision

  * Computer vision: Added diagnostics on computer vision models when training on multiple GPUs

  * Computer vision: Fixed errors handling in computer vision interactive scoring

  * Computer vision: Fixed performance issue with Python 2.7 (deprecated)

  * Computer vision: Fixed clicking on the “Edit” button for hyperparameters

  * Computer vision: Fixed deployment of computer vision models with a managed folder coming from another project

  * Computer vision: Fixed support for Python 3.7 code envs

  * Computer vision: Improved confusion matrix for low number of classes




##### Clustering

  * Clustering: Fixed column mismatch in clustering heatmap export

  * Clustering: Fixed changing clusters in interactive clustering




##### Code-based deep learning

  * Code-based deep learning: Added support for ML diagnostics

  * Code-based deep learning: Removed irrelevant display of hyperparameters edit button




##### Time series

  * Time series: Fixed evaluation recipe that could fail, mentioning not enough observations

  * Time series: Fixed possible error in commputation of MASE and MSIS metrics

  * Time series: Improved user experience when changing settings

  * Time series: Added gaps between the folds in the forecast graph




#### Visual recipes

##### Prepare

  * **New feature** : Prepare: Added a “case insensitive contains” operator

  * Prepare: Improved boolean type detection when column only contains a single value

  * Prepare: Fixed SQL engine when applying 7 or more IF blocks on the same column in a if-then-else processor

  * Prepare: Prevented selection of SQL engine when a formula cannot be translated

  * Prepare: Improved formula validation consistency and enhanced validation performance

  * Prepare: Fixed issue on Spark engine when adding then removing “cast output” option on a formula processor

  * Prepare: Highlight invalid steps in red when they are part of a group

  * Prepare: Fixed issue with the “enrich with context information” processor with Parquet datasets

  * Prepare: Fixed possible issue with “Impute missing values” processor on SQL engine




##### Other

  * Window & Group: Fixed display of settings of aggregation types near the bottom of the screen

  * Window: Fixed silent switching from SQL to DSS when removing an unused column from the input and not forcing a save

  * Join: fixed messed-up “outer join” icon

  * Sync: Fixed SQL engine wrongly claiming to be unable to append

  * Stack: Fixed filter containing variables

  * Fuzzy join: Fixed output when joining joining PostgreSQL datasets

  * Fuzzy Join: Fixed possible failure

  * Push to editable: Fixed layout of nested filters

  * App-as-recipe: Fixed “Add” button of input/output page in app-as-recipe when the recipe has many inputs

  * Fixed link to recipe input when it is a shared managed folder

  * Fixed UI of conditions with geopoint type on filters

  * Redispatch partitioning: Fixed some memory errors when redispatching with a very large number of partitions

  * Fixed issue with date types coming from BigQuery

  * Fixed permissions issues when running Merge Folder and List Folder content recipes on foreign folders

  * Fixed support of SQL pipelines on Athena-based SQL recipes targeting a S3 connection with Athena configured

  * Fixed issue trying to use Snowflake UDF on JDBC connections using Snowflake dialect




#### Flow

  * Fixed copy of managed folders using a custom Filesystem provider




#### Charts, Dashboards & Workspaces

  * Added various sampling panel UX/UI enhancements in dataset explore and insights

  * Added animation dropdown to charts when viewed from the insight

  * Fixed a non blocking error when adding a filter tile

  * Fixed display of filter in the insight creation modal

  * Fixed positioning issue with “force axes to use the same scale” on scatter plot

  * Fixed issue with filters refresh

  * Fixed ability to select engine for filter tile in dashboard

  * Fixed AVG aggregation in DSS engine when there are missing values in the column

  * Fixed “Continue without saving” action on chart insight

  * Improved legend display to limit overlapping

  * Fixed issue in workspace dataset viewer when using “highlight whitespaces” option

  * Fixed computation of dataset-level metrics from a workspace

  * Fixed display of foreign datasets in dashboards when used in workspaces




#### Coding and API

  * Added support for Snowflake connections using OAuth authentication for Snowpark

  * Improved polling in Python client, which will now detect job completion faster

  * SQL notebook: Fixed refresh of SQL notebook cells when modified by another user (in another browser)

  * Fixed error handling when reading datasets, which will now correctly cause the read call to fail in all situations

  * Added support for time series models in ML API

  * Added project libs management in python client

  * Fixed error when calling the DSSUserActivity properties

  * Fixed Python and SQL code recipe editor on a shared dataset if you have no permission on the source project

  * Fixed SQL query recipe if selecting column name containing a question mark ‘?’

  * Added ability to import indices from ElasticSearch in the dataset import API

  * Fixed various issues with plugin installation API




#### Code Studios

  * Fixed Code Studios behind a Apache reverse proxy

  * Upgraded node.js in VSCode code studios

  * Added sync of files when publishing a Code Studio as a webapp

  * Added public webapp support for Code-Studio-based webapps

  * Added Code-Studio-based webapps in the “Usage” tab of Code Studio templates

  * Fixed Code Studios in projects with numeric-only project key




#### Desktop IDE integrations

  * Pycharm: Added support for editing project libraries

  * VS Code: Added support for editing project libraries




#### Deployer & MLOps

##### Deployer

  * API Deployer: Display more information about the original project and model in the API Deployer

  * API Deployer: Fixed wrong python sample code when booleans are used

  * Project Deployer: Added a warning in the deployer if a bundle is using a shared objects that does not exist on the target infrastructure

  * Project Deployer: Automatically add permissions to new projects published to the project deployer

  * Project Deployer: Fixed failure with webapps deployed on automation node




##### MLflow

  * MLflow import: Changed default value for container_exec_config_name parameter of import_mlflow_version_from_path

  * MLflow import: import_mlflow_version_from_path and import_mlflow_version_from_managed_folder methods now activate by default the imported model

  * MLflow import: Fixed failure while importing a MLFlow model from a managed folder if the path of the managed folder starts with a ‘/’

  * MLflow import: Fixed import of model versions on automation node

  * MLflow import: Fixed issue with passing a dataiku.Folder object to the setup_mlflow method

  * MLflow import: Fixed failure of evaluation recipe when no model evaluation store was used




##### Other

  * Drift: Fixed data drift computation not performed by evaluation recipes for MLflow models with containerized execution

  * Automation node: added progress bar for manual bundle import

  * Fixed search for Model Evaluation Store in Flow when a project filter is defined




#### Interactive statistics

  * Added resampling capability for timeseries

  * Improved support of “TopN time” with missing timestamps




#### Labeling

  * Labeling: Used a dedicated set for validation

  * Added an option to autovalidate answers done by reviewers




#### Experiment tracking

  * Fixed UI display when some metrics had NaN or Infinity values

  * Fixed usage of custom step values in log_batch

  * Added ability to select the threshold when deploying a model from a run




#### Feature store

  * Fixed case-sensitivity issues in search

  * Added the ability to add a feature group to a project through the “+ DATASET” menu of the flow

  * Added the ability to send sharing requests from the feature store




#### Govern

  * Added ability to send mails through TLS-enabled SMTP servers

  * Fixed issue with signoff workflows

  * Fixed governance of projects from automation node

  * Fixed various issues with sorting fields

  * When errors happen when syncing from DSS to Govern, report on the encountered errors

  * Fixed the logic of custom hooks, so that they can run independently from the user profile of the user performing changes

  * Fixed various UI issues




#### Formula

  * **New feature** : Added the geoMakeValid function to formula language




#### Collaboration

  * Added ability to request sharing on objects that are themselves shared from another project

  * Avoid creating an empty dashboard authorization rule when sharing an object

  * Allowed to import Dataiku application with custom UI without needing the development plugin permissions

  * Fixed error when moving a project from the “Home > Projects” screen

  * Allowed users to remove/unshare shared objects from their project

  * Fixed ‘Change image’ on imported projects

  * Fixed global wiki screen search in list mode

  * Fixed possible failure of the “graph” view of projects




#### Performance & Scalability

  * Fixed a performance problem for the creation of bundles on projects with extremely large Git histories

  * Fixed a memory leak when reading a vast number of Parquet files from notebooks or webapps

  * Fixed a memory leak with large number of Kubernetes-hosted webapps that could ultimately lead to a crash

  * Fixed a possible failure causing jobs to hang and datasets to become unbuildable until a restart

  * Load-time performance enhancements for charts

  * Various UI-side performance enhancements




#### Cloud Stacks

  * **New feature** : Python 3.7, 3.8, 3.9, 3.10 are now fully usable out of the box

  * **New feature** : Added a setup action for setting environment variables

  * **New feature** : AWS: Added m6i, m6a, c6i, c6a, r6i, r6a instances type

  * **New feature** : GCP: Allowed configuration of static private IP for FM and DSS instances

  * Highlight in DSS the settings which are automatically managed through Fleet Manager

  * Added a warning in Fleet Manager to prevent downgrading DSS versions

  * Provided an external URL option for Govern node and remote Deployer node

  * All links to various nodes can now use the external URL

  * Prevented duplicated label/node ids for instances

  * Fixed loss of SSO settings on Fleet Manager when rebooting Fleet Manager instance (Major)

  * Fixed error when trying to display agent logs after instance reprovisioning

  * Don’t show disabled users in licensing summary

  * AWS: Ask for SSH key name at fleet creation time

  * Azure: Fixed handling of tags with empty value

  * Don’t incorrectly suggest default password, since passwords are automatically generated in Cloud Stacks

  * Fixed upgrade procedure of Govern nodes

  * Fixed UI issue saving virtual networks with inline SSL certificate

  * Fixed issue resetting user password with special characters




#### Elastic AI

  * Automatically retry more errors from Kubernetes (notably “tls: internal error”)

  * Fixed pod monitoring misreading certain cpuRequest/cpuLimit values

  * Fixed environment variables set in code environments not exposed correctly in notebooks executed in Kubernetes

  * Fixed occasional Spark on Kubernetes failure when clusters are under heavy load

  * GKE: Fixed error on “Add node pool” action

  * GKE: Fixed the default value for “inherit from DSS host” setting

  * EKS: Fixed bad error reporting under some eksctl failure conditions

  * Fixed some failures with special characters in custom labels and annotations

  * Fixed potential failure of SparkSQL recipes validation system

  * Fixed non fast path read/write when using Spark in Notebooks

  * Fixed cases where configuration error in a single S3 connection could cause all Spark jobs to fail

  * Added ability to use multiple S3 credentials (for multiple buckets) in a single Spark job

  * Fixed possible failure of webapps on Kubernetes due to Python dependencies

  * Fixed possible failure of Kubernetes workloads when the node id contains spaces




#### Hadoop & Spark

  * Added support for CDP 7.1.7.p1XXX above p1000 (tested specifically on p1029 and p1035)

  * Fixed Spark recipes with Java 11 when the metastore is managed by DSS

  * Fixed Hive validation on CDH 6.3 and 7 when “hive.aux.jars.path” is not empty

  * Avoided failure if fallback db is unset and synchronization is disabled

  * Fixed ACLs not being set for impersonated notebooks if the “Configuration for PySpark/SparkR/Scala notebook” is missing in spark settings




#### Setup and administration

  * Prevented failure of monitoring summary in cases of broken recipes

  * Fixed SPNEGO authentication

  * Disabled license expiration warnings for non-admin users

  * Added a filter by type of connection in the connection list screen

  * Added in a setting to globally disable code env resources feature

  * Fixed ability to use project-level presets in plugin recipes

  * More clearly marked Python 2.7 as deprecated in the UI

  * (Custom install) Added support for Graphics exports on most recent supported OSes (such as Ubuntu 20.04 LTS)

  * (Custom install) Do not accept installing a new DSS with Python 2.7 as the base env anymore

  * (Custom install) Display a warning when upgrading a DSS that still has Python 2.7 as the base env




#### Plugins

  * Added the ability for custom datasets to use more of the Dataiku API (notably, accessing user secrets)

  * Set Python 3.6 and Pandas 1.0 as default when adding a code env to a plugin

  * Fixed bug when there are multiple scenario step plugins using a multiselect field

  * Added an error message if a plugin recipe cannot be retrieved anymore

  * Prevented uploading/updating development-mode plugins

  * Convert to plugin recipe modal: displayed clear indications when the submit button is disabled

  * Custom model views: added a ‘backendTypes’ property in webapp.json to define supported ml backends

  * Custom model views: Fixed custom views for models trained with Python 3.7

  * Fixed History tab in plugins editor not listing all plugins

  * Fixed JSON_OBJECT type for custom macros




#### Security

  * Fixed [cross-site-scripting issue through custom metric names](<../security/advisories/dsa-2022-017.html>)

  * Fixed [cross-site-scripting issue through imported Jupyter notebooks](<../security/advisories/dsa-2022-018.html>)

  * Fixed [HTTP host blacklist bypass](<../security/advisories/dsa-2022-019.html>)

  * Fixed [Takeover of Jupyter notebooks](<../security/advisories/dsa-2022-020.html>)

  * Added hiding of API key secret by default

  * Added encryption of passwords in the API node

  * OpenID Connect: Don’t log the access token when the IDToken is invalid




#### Misc

  * Dataiku Apps: Fixed variable display tile not automatically refreshed with the latest value of the variables




## Version 11.0.3 - September 9th, 2022

DSS 11.0.3 is a security release. All users are strongly encouraged to update to this release.

### Security

  * Fixed [Remote code execution in API designer](<../security/advisories/dsa-2022-011.html>)

  * Fixed [Session credential disclosure](<../security/advisories/dsa-2022-012.html>)

  * Fixed [Credentials disclosure through path traversal](<../security/advisories/dsa-2022-016.html>)

  * Fixed [Insufficient access control to project variables](<../security/advisories/dsa-2022-013.html>)

  * Fixed [Insufficient access control to projects list and information](<../security/advisories/dsa-2022-014.html>)

  * Fixed [Insufficient access control in troubleshooting tools](<../security/advisories/dsa-2022-015.html>)

  * Tightened potential path traversal issues that did not lead to a security vulnerability




## Version 11.0.2 - August 25th, 2022

DSS 11.0.2 is a security and bugfix release. All users are strongly encouraged to update to this release.

### Snowflake

  * Fixed type mapping for Snowpark Python




### Cloud Stacks

  * Fixed upgrade issue for Govern node




### Security

  * Fixed [access control issue for managed cluster logs and configuration](<../security/advisories/dsa-2022-005.html>)

  * Fixed [multiple access control issues leading to low-impact information leaks](<../security/advisories/dsa-2022-006.html>)

  * Fixed [multiple access control issues leading to low-impact service disruptions](<../security/advisories/dsa-2022-007.html>)

  * Fixed [stored XSS in dataset settings](<../security/advisories/dsa-2022-008.html>)

  * Fixed [stored XSS in machine learning results](<../security/advisories/dsa-2022-009.html>)

  * Fixed [missing access control for export to dataset](<../security/advisories/dsa-2022-010.html>)




## Version 11.0.1 - August 3rd, 2022

DSS 11.0.1 is a bugfix release

### Recipes

  * Fixed “IsEmpty” on a geometry column on existing visual filters

  * Fixed invalid selection when opening the “smart pattern extractor” from selected text in explore table

  * Prepare recipe: fixed the position of the column generated by the visual if processor

  * Fixed a concurrency issue with SQL recipes using the Redshift driver




### Spark

  * Fixed Avro support with standalone Spark 3.2

  * Upgraded the Snowflake driver and Spark driver for standalone Spark




### Machine Learning

  * Fixed display of trained models for partitioned time series models

  * Image labeling: Fixed possible metadata table name collision when using externally hosted runtime databases and long project keys

  * Image labeling: Fixed support of externally hosted runtime databases with a non-default schema or prefix




### MLOps

  * Fixed drift computation for MLflow regression models

  * Handled drift computation of categorical features when chi2 test fails

  * Evaluation Recipe: Fixed “Don’t compute perf” option for a MLflow imported model with no ground truth in the evaluation dataset




### Dataiku Applications

  * Improved display of scenario with a WARNING/FAILURE outcome in Dataiku application instances

  * Fixed plugin-provided Dataiku Applications

  * Fixed WARNING icon not displayed when scenario finishes with warning status




### Code Studios

  * Fixed project libraries not added in PYTHONPATH when code studio is started on a blank project




### Administration

  * Govern: Fixed display of LDAP default profile and user group/profile mapping

  * Fixed DSS not starting when using externally hosted runtime databases with non-default schema

  * Fixed DSS not starting if two instances are using the same externally hosted runtime database with different schemas




### Misc

  * Feature store: Fixed display of a feature group that has been shared to a now-deleted project




## Version 11.0.0 - July 12th, 2022

DSS 11.0.0 is a major upgrade to DSS with major new features.

### Major new features

#### Visual Time Series Forecasting

Time Series Forecasting is now natively available in DSS Visual ML. Visual Time Series Forecasting features many capabilities:

  * Single or multiple series

  * Multiple horizon forecasting

  * Multiple algorithms, including deep learning algorithms




Time Series Forecasting are fully deployable and governable like other DSS Visual Models.

For more details, please see [Time Series Forecasting](<../machine-learning/time-series-forecasting/index.html>)

#### Code Studios, including Visual Studio Code, JupyterLab and RStudio

Code Studios allow DSS users to harness the power and versatility of many Web-based IDEs and web application building frameworks.

Code Studios allow you, for example, to:

  * Edit and debug Python, R, SQL, … recipes and libraries in Visual Studio Code

  * Edit and debug Python or R recipes, notebooks, libraries, … in JupyterLab

  * Edit and debug R recipes and libraries in RStudio Server




For more details, please see [Code Studios](<../code-studios/index.html>)

#### Image Labeling

In order to create and fine-tune image models (classification and object detection), you first need labeled images. Labeling is often a tedious task.

DSS now features a native Image Labeling capability, with the following features:

  * Support for image classification and object detection use cases

  * Ability to invite annotators (people who label the images)

  * Efficient interface for annotators with keyboard shortcuts

  * Ability to request annotations from multiple annotatorss

  * Annotations review process with management of conflicts between annotators




This new capability allows you to perform even more of the entire Machine Learning cycle for computer vision in DSS.

#### MLOps: Experiment Tracking

DSS now includes an experiment tracker for logging parameters, performance metrics, models, and other metadata when running your machine learning code, and for visualizing results of such experiments.

The DSS Experiment Tracker leverages the well-known MLflow Tracking API, which allows you to seamlessly port existing or 3rd party experiment tracking code and get all DSS benefits.

For more details, please see [Experiment Tracking](<../mlops/experiment-tracking/index.html>)

#### MLOps: Feature Store

A Feature Store helps Data Scientists, build, find and use relevant data for models in order to build efficient models faster.

Most key components of a Feature Store are native capabilities of DSS:

  * Feature Storage is handled by Dataiku extensive [Connections Library](<../connecting/connections.html>)

  * Data Ingestion and Curation is performed using [Recipes in the Flow](<../flow/index.html>)

  * Offline serving for batch processing is done using [Join Recipes](<../other_recipes/join.html>) in [projects deployed on an Automation node](<../deployment/index.html>)

  * Online serving for realtime processing is done using [Dataset Lookups](<../apinode/endpoint-dataset-lookup.html>) in API services

  * Data monitoring is implemented using [Metrics & Checks](<../scenarios/index.html>)

  * Automated building and maintenance is managed by [Scenarios and Triggers](<../scenarios/index.html>)




DSS 11 adds a new _Feature Store_ section, which acts as the central registry of all _Feature Groups_ , a _Feature Group_ being a curated and promoted Dataset containing valuable _Features_.

For more details, please see [Feature Store](<../mlops/feature-store/index.html>)

#### Data Visualization: New Pivot Table

The Pivot Table has been strongly overhauled. It now supports:

  * Multiple dimensions on rows and columns, with subtotal support

  * Excel Export of multiple dimensions and multiple measures




For more details, please see [Charts](<../visualization/index.html>)

#### Quick Sharing

Project administrators can now enable “Quick Sharing”, which allows any user who has read access to the project to share a dataset to his own project, without having to ask the project administrator first.

Quick Sharing can be globally disabled by instance administrators.

For more details, please see [Shared objects](<../security/shared-objects.html>)

#### Access & Sharing requests

Project administrators can now choose to make their project “discoverable”, which allows users who don’t have access to the project to still discover its existence and basic information about it (name, description, …), and then to request access to it.

Project administrators receive notifications about access requests, and can manage them, grant them or reject them.

Similarly, users who have access to a project can now request that datasets be shared with their own projects, and project administrators can manage these sharing requests (if they don’t have Quick Sharing enabled).

These mechanisms can be globally disabled by instance administrators.

For more details, please see [Requests](<../collaboration/requests.html>)

#### Create if, then, else processor

This new visual data preparation processor performs actions or calculations based on conditional statements defined using an “if, then else” syntax.

It can be used notably to create new columns based on conditions on the values of other columns. While this was previously feasible using formulas or the [Switch case](<../preparation/processors/switch-case.html>) processor, the new [Create if, then, else statements](<../preparation/processors/create-if-then-else.html>) processor can provide much more flexibility, without having to write complex formulas.

For more details, please see [Create if, then, else statements](<../preparation/processors/create-if-then-else.html>)

#### Flow Document Generator

In regulated industries, it is often required to document flows, at creation and after every change for traceability. This is often tedious. DSS now features the ability to automatically generate a DOCX document from a Flow, which documents the whole flow, including datasets and recipes details.

For more details, please see [Flow Document Generator](<../flow/flow-document-generator.html>).

#### Govern: Projects and bundles governance

The [Govern Node](<../governance/index.html>) now supports managing, governing, and controlling deployment of Project Bundles in the Deployer

#### Dataiku Cloud Stacks on GCP

Dataiku Cloud Stacks is now available on GCP.

For more details, please see [Dataiku Cloud Stacks for GCP](<../installation/cloudstacks-gcp/index.html>)

### Other notable enhancements and features

#### Outcome Optimization for regression

The “What-If” feature now supports Outcome Optimization for regression problems. Outcome Optimization allows you to start from a given record, and to explore the neighborhood of this record to find the changes to input features that would lead to changes in the predicted value, towards either the largest, smallest, or a specific value. You can select which features can be modified and which can’t.

#### Nested filters

In locations where visual filters can be used, it is now possible to nest complex boolean conditions, such as:

  * If col1 is 2

  * AND
    
    * col2 is 3

    * OR col3 is 4




This applies to:

  * The Filter visual recipe

  * The “Create-if-then-else” prepare processor

  * The “Pre/Post filters” of all visual recipes

  * Filters in Explore and Charts sampling

  * Filters in Visual ML




#### OIDC authentication

In addition to SAMLv2, OIDC can now be used as SSO protocol for logging in to DSS

For more details, please see [Single Sign-On](<../security/sso.html>)

#### SSO support for Fleet Manager

It is now possible to log in through SSO on Fleet Manager

For more details, please see [Installing and setting up](<../installation/index.html>)

#### “List folder content” recipe

This new visual recipe takes a managed folder as input, a dataset as output, and writes in the dataset the listing of files in the managed folder.

This recipe is especially useful for image labeling and computer vision use cases.

For more details, please see [List Folder Contents](<../other_recipes/list-folder-contents.html>)

#### Workspace discussions

Discussions are now available on workspaces

#### Data Visualization: Count Distinct and Count Not Null aggregations

All aggregated charts (columns, bars, pies, lines, areas, pivot table, …) now support the “Count Distinct” and “Count Not Null” aggregation functions for measures.

This also now makes it possible to have non-numerical measures

For more details, please see [Charts](<../visualization/index.html>)

#### Data Visualization: multiple layers on Geo Map

It is now possible to draw multiple layers with different geometries on the Geo Map chart

For more details, please see [Geographic data](<../geographic/index.html>)

#### Data Visualization: additional customization options

The following can now be customized:

  * Ability to change the name of a measure in the legend and tooltip

  * Ability to change the name of a dimension in the legend and tooltip

  * Ability to reformat numbers on axis and in cells of the pivot table




For more details, please see [Charts](<../visualization/index.html>)

#### Georouting and Isochrones

DSS now has capabilities for computing itineraries between geopoints and isochrones around geopoints.

For more details, please see [Geographic data](<../geographic/index.html>)

#### Machine Learning: multiple custom metrics

You can now define multiple custom metrics for a single Visual ML model.

#### Streamlit webapps through Code Studios

Through the Code Studios mechanism, you can now create and run Streamlit applications in DSS.

For more details, please see [Code Studios](<../code-studios/index.html>)

#### Govern: new permissions experience

A new editor for permissions for Govern was introduced

#### Govern: History

You can now view the history and timeline of individual govern objects

#### Govern: Sign off editor

Sign-off processes for Govern can now be edited for more sign-off flexibility

### Other enhancements and fixes

#### Elastic AI

  * Spark version has been upgraded to 3.2.1




#### Machine Learning

  * Added Traditional Chinese stop words

  * Code-based Deep Learning: Tensorflow 2 can now be used

  * Fixed display on some screens when sample weights are used

  * Fixed display of the “customize code” box for text features

  * Fixed potential model display failure for models trained with K-fold-cross-test and sample weights

  * Fixed bad behavior when trying to use custom metrics without code writing permissions

  * Fixed display issue for axis legend on the partial dependence distribution chart

  * Fixed training failure with MLLib engine when “cumulative lift” metric is used

  * Properly ask users to rebuild train/test set if number of folds changed

  * Various small UI fixes

  * Code-based Deep Learning: made unused columns optional in scoring recipe

  * Fixed display issues with blue information boxes in result screens

  * Removed display of sample weights options when unsupported

  * Fixed “Needs probabilities” checkbox for custom metrics

  * Fixed estimated number of estimators to train when using time ordering

  * Computer Vision: Fixed training failures when number of epochs is 2

  * Fixed evaluation of ensemble models with text features

  * Code-based Deep Learning: added ability to use a custom text preprocessor returning a tensor with more than 3 dimensions




#### MLOps

  * Added support for partitioning in model evaluations

  * Prevented non-functional usage of a foreign model evaluation store in evaluation recipe

  * Added ability to use a foreign model for an evaluation recipe

  * Small UI fixes




#### Govern

  * Fixed various issues in DSS/Govern sync

  * Fixed redirect to URL after login

  * Fixed various UI issues

  * Fixed filtering by project on model registry

  * Fixed display of archived artifacts




#### Visual Statistics

  * Fixed display issue for dataset selector in “duplicate worksheet” modal

  * Univariate card: Added placeholder instead of empty chart when the histogram is empty

  * Small UI fixes




#### Explore & Datasets

  * Fixed flickering error that could appear on Explore screen

  * Fixed inability to explore when a bad regular expression was entered in a filter

  * Fixed multiple issues in listing of buckets and containers for S3, Azure Blob and Google Blob datasets

  * BigQuery: Added ability to read external tables and materialized views with the native driver

  * BigQuery: Enabled fast read of tables by default with the native driver

  * BigQuery: Fixed flooding of logs with Simba driver 1.2.22.1026 and above

  * Snowflake to cloud: disabled broken ability to use fast path when input is a SQL query dataset

  * Fixed ability to resize columns in foreign dataset explore




#### Dataiku Applications

  * New user experience for the “Edit SQL datasets” action, with ability to browse very large databases

  * Added ability to restrict connection type in the CONNECTION parameter type




#### Flow & Jobs

  * Improved wrapping of long dataset names

  * Fixed display of “Python only” logs for containerized recipes

  * The “Tags” flow view now shows tags from foreign datasets

  * Added link to parent recipes on managed folders




#### Visual recipes

  * Fixed autocompletion of formula with non-ASCII column names

  * Fixed storage of date filters when day is the 31st

  * Fixed “Increment date” processor in SQL mode when using the “Increment by: value in column” mode

  * Added automatic regrouping of multiple “clear cells with this value” steps from the Analyze box

  * Fixed handling of variables in formula editor

  * Prepare recipe: Improved searching for processors

  * Fixed ability to use variables in computed columns with DSS engine

  * Prepare recipe: fixed “filter rows on date” processor on Oracle

  * Prepare recipe: fixed “concat columns” step failure on Spark 3




#### Data Visualization

  * Pivot Table: Excel export now exports multiple measures

  * Pivot Table: Excel export now respects coloring

  * Fixed issues when reordering charts via drag & drop

  * Fixed “one tick per bin” wrongfully applying to hexagon charts

  * Fixed log scale on binned scatter plots

  * Fixed UI issue on manual axis range edition




#### Dashboards

  * Improved UI for filter tiles with filter summary and ability to reset filters

  * Fixed search for existing insights

  * Added ability to change the dataset of a filters tile

  * Fixed various issues with filter tiles




#### API

  * Fixed ability to write chunks of more of 2 Gigabytes when using ManagedFolderWriter.write()

  * Fixed inability to edit some code env parameters through API




#### Scenarios

  * Propagate warnings from steps to the outcome of the scenario

  * Added missing timezones in the temporal trigger timezone selector




#### Collaboration

  * Fixed sending of “you have been granted access to project” when your grant does not actually give you access to the project

  * Fixed download of .ipynb attached files in Wiki




#### Cloud Stacks

  * Upgraded kubectl version in order to deploy latest Kubernetes verions

  * Fixed renaming of automation node breaking the deployer

  * Added display of DSS URL directly in Fleet Manager




#### Plugins & Extensibility

  * Allowed custom model views to be restricted to some prediction types

  * Forbidden presets are now hidden




#### Performance & Scalability

  * Fixed API node memory overconsumption when passing huge payloads as inputs or outputs of API services

  * Made project deletion much faster, especially with large number of datasets

  * Improved performance of home page with many projects




#### Security

  * Added encryption for SAML keystore password




#### Misc

  * Added better categorization for admin settings page

  * Fixed wrong navigation bar when going to the Deployer

  * Direct webapp access will properly redirect back to the webapp after login

  * Fixed Streaming Scala recipes with Avro on Kafka

  * Added API key id in the API node audit log

  * Improved Industry Solutions creation modal

  * Fixed ability to modify or delete empty todo list

  * Fixed custom requests and limits in containerized execution

  * Fixed “Certification” link on home page with Safari

  * Fixed missing cleanup of Kubernetes objects for containerized continuous Python recipes




### Known issues

  * When using Elastic AI / “standalone” mode for Spark, writing Avro files does not work. We advise you to use Parquet or ORC. Please get in touch with Dataiku Support for workarounds.

---

## [release_notes/12]

# DSS 12 Release notes

## Migration notes

### How to upgrade

  * For Dataiku Cloud users, your DSS will be upgraded automatically to DSS 12 within pre-announced timeframes

  * For Dataiku Cloud Stacks users, please see upgrade documentation

>     * [For Cloud Stacks AWS users](<../installation/cloudstacks-aws/dss-upgrade.html>)
> 
>     * [For Cloud Stacks Azure users](<../installation/cloudstacks-azure/dss-upgrade.html>)
> 
>     * [For Cloud Stacks GCP users](<../installation/cloudstacks-gcp/dss-upgrade.html>)

  * For Dataiku Custom users, please see upgrade documentation: [Upgrading a DSS instance](<../installation/custom/upgrade.html>).




Pay attention to the warnings described in Limitations and warnings.

### Migration paths to DSS 12

>   * From DSS 11: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 10.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [10.0 -> 11](<11.html>)
> 
>   * From DSS 9.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>)
> 
>   * From DSS 8.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>)
> 
>   * From DSS 7.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>)
> 
>   * From DSS 6.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>)
> 
>   * From DSS 5.1: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>)
> 
>   * From DSS 5.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>)
> 
>   * From DSS 4.3: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>)
> 
>   * From DSS 4.2: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>)
> 
>   * From DSS 4.1: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.1 -> 4.2](<old/4.2.html>), [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>)
> 
>   * From DSS 4.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<old/4.1.html>), [4.1 -> 4.2](<old/4.2.html>), [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>)
> 
>   * Migration from DSS 3.1 and below is not supported. You must first upgrade to 5.0. See [DSS 5.0 Release notes](<old/5.0.html>)
> 
> 


### Limitations and warnings

Automatic migration from previous versions is supported (see above). Please pay attention to the following cautions, removal and deprecation notices.

### Cautions

  * The SQL engine can now be automatically selected on prepare recipes. In case of issues on prepare recipes that were working prior to the upgrade, you can revert to the DSS engine by clicking on the “Engine: In database” button in the prepare recipe settings.

  * Similarly, the Spark engine can now be automatically selected more eagerly when the storage and formats are compatible with fast Spark execution. In case of issues on recipes that were working prior to the upgrade, you can revert to the DSS engine by clicking on the “Engine: Spark” button in the recipe settings.

  * The Bokeh package has been removed from the builtin Python environment. If you have Bokeh webapps, please make sure to use a code environment. The Bokeh package in the builtin Python environment was using a very old version of Bokeh.

  * The Seaborn package has been removed from the builtin Python environment. If you use this package, please make sure to use a code environment.

  * For Cloud Stacks setups, the OS for the DSS nodes has been updated from CentOS 7 to AlmaLinux 8 (which is a RedHat-compatible distribution similar to CentOS). Custom setup actions may require some updates.

  * For Cloud Stacks setups, R has been upgraded from R 3 to R 4. You will need to rebuild all R code envs. Some updates to packages may be required

  * For Cloud Stacks, the builtin Python environment has been upgraded from Python 3.6 to Python 3.9

  * The version of some packages in the builtin Python environment have been upgraded and your code may require some updates if you are not using your own code environment. The most notable updates are:

    * Pandas 0.23 to 1.3

    * Numpy 1.15 to 1.21

    * Scikit-learn 0.20 to 1.0

    * Matplotlib 2.2 to 3.6

  * The python packages used by Visual Machine Learning have changed, in the built-in code environment and in suggested packages. Notably, if you have KNN or SVM models trained using the built-in code environment, you will need to retrain these models to be able to use them for scoring.




### Support removal

Some features that were previously announced as deprecated are now removed or unsupported.

  * Support for H2O Sparkling Water as a backend for Visual Machine Learning has been removed




### Deprecation notices

DSS 12 deprecates support for some features and versions. Support for these will be removed in a later release.

  * Hadoop

    * Support for Cloudera CDH 6

    * Support for Cloudera HDP 3

    * Support for Amazon EMR 5

    * Support for Google Cloud Dataproc

    * Support for Spark 2

  * Support for Java 8

  * Support for CentOS 8




## Version 12.6.7 - October 3rd, 2024

DSS 12.6.7 is a bugfix release

### Performance

  * Worked around Chrome 129 bug that can cause failure opening DSS (“Aw, Snap!”) (also in 13.2.0)




### ML

  * Fixed failure to compute partial dependence plots on models with sample weights when the sample size is less than the test set size (also in 13.1.3)




## Version 12.6.6 - September 9th, 2024

DSS 12.6.6 is a bugfix and feature release

### Charts

  * Fixed missing meaning-based chart palette in chart color customization (also in 13.1.0)




### Misc

  * Introduced AI Consumer user profile (also in 13.1.1)




## Version 12.6.5 - July 11th, 2024

DSS 12.6.5 is a bugfix and security release

### Recipes

  * Join: Fixed loss of pre and post filter when replacing dataset in join

  * Join: Fixed issue when doing a self-join with computed columns

  * Prepare: Fixed help for “Flag rows with formula”

  * Prepare: Fixed failing saving recipe when it contains certain types of invalid processors

  * Stack: Fixed addition of datasets in manual remapping mode that caused issues with columns selection




### Charts & Dashboards

  * Re-added ability to view page titles in dashboards view mode

  * Fixed filtering in dashboard on charts with zoom capability

  * Fixed possible migration issue with date filters

  * Fixed migration issue with alphanum filters filtering on “No value”

  * Fixed filtering on “No value” with SQL engine

  * Restore larger font size for metric tiles

  * Fixed display of Jupyter notebooks in dashboards

  * Added safety limit on number of different values returned for numerical filters treated as alphanumerical




### Scenarios and automation

  * Added support for Microsoft teams Workflows webhooks (Power Automate)




### Performance

  * Fixed performance issue with most activities in projects containing a very large number of managed folders (thousands)

  * Improved short bursts of backend CPU consumption when dealing with large jobs database

  * Fixed possible unbounded CPU consumption when renaming a dataset and a code recipe contains extremely long lines (megabytes)

  * Visual ML: Clustering: Fixed very slow computation of silhouette when there are too many clusters




### Security

  * Fixed [Insufficient permission checks in code envs API](<../security/advisories/dsa-2024-005.html>)




### Misc

  * Fixed sometimes-irrelevant data quality warning when renaming a dataset

  * Fixed EKS plugin with Python 2.7

  * Fixed wrongful typing of data when exporting SQL notebook results to Excel file




## Version 12.6.4 - June 11th, 2024

DSS 12.6.4 is a bugfix release

### Machine Learning

  * Fixed the detailed metrics table layout in exported model documentation

  * Fixed very slow computation of model reports in rare cases




### Flow and Visual Recipes

  * Fixed issue where literal numbers smaller than 0.0001 are not correctly interpreted by filter operators




### Datasets and connections

  * S3: Fixed issue when refreshing expired credentials, when STS token duration is left blank in connection settings

  * GCS: Fixed issue when reading data using Spark with OAuth2 authentication

  * Fixed connection indexing failing when a dataset is shared to a deleted project

  * Fixed plugin presets defined at the project level triggering an error during authentication

  * Fixed possible performance issue with heavy usage of datasets using Entra ID OAuth (Azure Blob, Synapse, …)




### Charts and Dashboards

  * Fixed a possible chart issue when using the `countd` function in user defined aggregation functions

  * Fixed possible failure of Excel export




### Deployer

  * Fixed API service deployment compatibility issue with Openshift clusters




### Governance

  * Fixed timeline filtering on API keys




### Scenarios and automation

  * Fixed notification parameter for excluding scenario runs from other users incorrectly filtering also current user’s runs




## Version 12.6.3 - May 31st, 2024

DSS 12.6.3 is a new feature, security, performance and bugfix release

### LLM Mesh

  * Added support of tokens streaming for Claude 3 models on AWS Bedrock

  * Fixed RAG usage of augmented Claude 3 models on AWS Bedrock

  * Fixed error handling in Langchain wrappers, when the underlying model yields an error

  * Fixed a possible missing audit trail log in some cases of failing LLM Mesh API calls




### Machine Learning

  * Improved disk usage of partitioned models with many partitions

  * Fixed deletion of a partitioned Saved Model when some of its versions are in a broken state

  * Fixed export of variable importances on clustering models




### AI Assistants

  * Fixed –max-tokens argument in ‘aiwrite’ command of AI Code Assistant




### Containerized execution

  * Fixed “Compute resource usage” type for containerized DSS engine processes

  * Fixed a rare race condition when aborting a job

  * Fixed base image building in AlmaLinux mode

  * Fixed base image building on Centos 7 mode

  * Deleted associated tagged image on registry when deleting a code environment




### Datasets

  * BigQuery: Fixed fast write in BigQuery from GCS when a BigQuery job returns “PENDING”

  * BigQuery: Implemented a retry mechanism to mitigate a race condition bug using BigQuery storage Write API




### Chart and Dashboards

  * Fixed Excel export of charts with reference lines

  * Fixed display of “Others” bins in Excel export

  * Fixed null values filtering on date and alphanum columns using SQL engine

  * Fixed loading of dashboard filters created from a shared dataset

  * Fixed adding new tile when dashboard contains a tile containing a deleted (or unshared) insight

  * Fixed visibility of tile filter warnings after pasting a URL

  * Fixed sharing of empty date filters




### Visual recipes

  * Fixed double display of “Engine” in Advanced tab of most recipes

  * Fixed refresh of script when an invalid prepare recipe step is disabled

  * Fixed “Date difference” processor in SQL engine when the output column already exists




### Jobs & Scenarios

  * Fixed “select partitions” link in scenario editor

  * Fixed possible notification delay when a user starts a job




### Cloud Stacks

  * Fixed Fleet Manager upgrade when running in a proxied environment




### Administration

  * Improved external catalog error management when a connection has been deleted




### Performance

  * Improved performance of dataset listing and flow graph computation




### Misc

  * Fixed migration failure if a recipe file is corrupted

  * Added support for RockyLinux 8.10 and AlmaLinux 8.10

  * Fixed possible missing CORS headers in some cases of failing public API calls




### Security

  * Fixed [Missing project permissions check when accessing LLM through API](<../security/advisories/dsa-2024-003.html>)

  * Fixed [Missing authentication on get-global-tags-info endpoint](<../security/advisories/dsa-2024-004.html>)




## Version 12.6.2 - May 16th, 2024

DSS 12.6.2 is a new feature and bugfix release.

### LLM Mesh

  * **New feature** : Added support for Mistral AI La Plateforme, supporting Mistral Small, Large, Mistral Embed, Mistral 7B and Mixtral 8x7B

  * **New feature** : Added support for Snowflake Cortex LLMs, including Snowflake Arctic

  * **New feature** : Added support for Llama3 local LLM

  * **New feature** : Added support for OpenAI GPT-4o

  * **New feature** : Added support for Claude 3 on AWS Bedrock

  * **New feature** : Added support for DBRX-Instruct on Databrick Mosaic AI

  * **New feature** : Added support for token streaming on Azure OpenAI, Mistral AI, and custom LLM connections (when supported by the plugin).

  * Added support for Mistral 78 v0.2 local LLM

  * Added support for the non-preview GPT-4-Turbo LLMs on OpenAI connections

  * Added support for the Organization field in OpenAI connections

  * Improved connection remapping when importing projects that use LLM connections and were exported from DSS older than 12.6.0

  * Improved resiliency when calls to LLM service providers fail

  * Improved surfacing of error details when failing to download models from huggingface

  * Sped up of single-completion API calls

  * Updated LLM pricing information

  * Fixed RAG usage of some augmented models

  * Fixed PII detection failure when a message is made of purely non-alphabetic characters

  * Fixed an error where some Anthropic connections lack a “anthropic-version” header

  * Fixed an issue with `DKULLM` / `DKUChatLLM` when using stop sequences with some regex-significant characters




### Machine learning

  * Added ability to hold a configurable part of the train set to fit probability calibration, instead of fitting it on the test set.

  * Added support for custom metrics in learning curves

  * Improved consistency of Java scoring engine for XGBoost models

  * Improved memory usage and performance when deleting some partitioned models with a lot of partitions

  * Improved display of calibration curve

  * Added support for scipy 1.10




### Charts and Dashboards

  * Fixed an issue with imported dashboards, charts or datasets that contain a date filter, preventing them to load

  * Fixed editing of tile default title

  * Fixed repeated first page when exporting long dashboards to PDF

  * Fixed dashboard filters not working with shared datasets

  * Fixed an issue happening when moving from a chart with the “generate one bin per tick” enabled on a dimension to a chart which is not compatible with this option (ex: scatter plot)

  * Fixed rectangle zoom selection on chart to actually set the zoom to the window defined by the user (rather than trying to keep the aspect ratio)

  * Fixed truncated chart when downloading as an image when the height is too small compared to the width

  * Made dashboard filters keep active user selection when switching pages

  * Fixed date range filter summary to actually reflect user selection

  * Decreased default point size for scatter multi-pair

  * Fixed numeric and date-part filters not clearable when in “multiple values” mode with lots of possible values

  * Fixed the “Generate one tick per bin” generating an empty chart

  * Fixed drag and drop of columns not opening tabs in left panel

  * Fixed reading shared datasets in dashboards without read permission on the source project




### Code Studios

  * Fixed Gradio block failing

  * Disabled copying of non-needed expensive folders (‘CachedExtensions’ and ‘CachedExtensionVSIX’)

  * Added ability to select a specific user to run backend of webapps

  * Fixed template export failing when using ${template.resources}




### Datasets and connections

  * Databricks: Added OAuth support on AWS

  * Databricks: Fixed issues with recipes failing when the input dataset is using Parquet format with logical types such as Date or Decimal

  * Snowflake: Fixed issues with recipes failing when the input dataset is using Parquet format with logical types such as Date or Decimal

  * GCS: Fixed authentication failure when using p12 credential files with Parquet

  * BigQuery: Added ability to specify a Customer-managed encryption key (CMEK) to encrypt/decrypt data in the built-in driver

  * Excel: Added ability to create multiple datasets when uploading files containing multiple sheets

  * Added progress dialog when downloading/exporting managed folders

  * Fixed issue where a dataset created from a managed folder stored on S3 could not be deleted

  * Fixed failing managed folder download when folder name is less than 3 characters long




### Data Quality

  * Fixed column statistics metrics failing on partitioned datasets

  * Fixed computation of “unique value count” metric and rule




### Visual recipes

  * Prepare: Fixed recipe failing to run on SQL engine if the same column is added twice or more in a “Keep columns” step

  * Prepare: Fixed “User Agent Classifier” step failing when running on Snowflake with UDF

  * Prepare: Fixed slowness in the user interface when a “Keep/remove column” step contains a large number of columns

  * Prepare: Fixed recipe failing to run on SQL if a “Find/Replace” step is misconfigured

  * Prepare: Added support for XML, JSON and “one record per line” formats in the “Enrich with record context” step

  * Sync: Fixed issue when running recipe where BigQuery input dataset contains a column of type boolean containing Yes/No values

  * Stack: Added ability to insert Stack recipes between 2 existing datasets

  * Fixed issue preventing to use project libraries in Python/R continuous recipes

  * Plugin recipes are now displayed in alphabetical order in right panels

  * Fixed missing warning status on some jobs running in containers using the DSS engine




### Scenarios and automation

  * Fixed copy of Python-based scenario that did not copy the script

  * Fixed creation of build steps that wrongfully displayed datasets from previous steps




### Webapps

  * Added ability to load static resources for webapps from project-level libraries in addition to global ones




### Deployer

  * Optimized the deployment of API services by avoiding multiple builds of the same code environments when used in multiple API endpoints

  * Fixed API deployer infrastructure extra options for building code environments not taken into account when deploying an API service

  * Fixed code environment resources initialization script not being executed when building API node image

  * Fixed failing deployments when infrastructure monitoring uses the “auto push” mode and deployer URL is empty (may happen with broken nodes directory).




### Coding

  * Fixed issue with flow traversal APIs when there is a Knowledge Bank in the flow

  * Fixed calling read-data from R code running in parallel in containers causing failure

  * Added Dataset.to_html method to export a dataset as HTML with conditional formatting applied

  * Added as_type parameter to DSSLibraryFile.read method to allow read files in binary format

  * Fixed DSSProjectGit.add_library, set_library and remove_library methods failing when called outside DSS

  * Fixed no_check_certificate not being taken into account when calling dataiku.set_remote_dss




### Security

  * Added support for OAuth refresh tokens rotation

  * Removed ability for users to grant permission to “All users” built-in group when visibility of groups and users is restricted




### Cloud Stacks

  * Fixed dss_group ansible module




### Misc

  * Added ability to access logs of a Python macro even when the code doesn’t fail

  * Fixed inapplicable warning when installing an API node

  * Fixed compute resource information that could include wrongful context information

  * Automatically delete old images from repository when rebuilding code envs, or containerized execution images

  * Added explanation messages in the Jobs user interface when a job is waiting for external resources

  * Fixed API node status reporting failing when it is exposed through a load balancer

  * Fixed cases of stuck Python recipe appearing as wrongly successful when running in a container

  * Added ability for administrators to display a custom message for users who request to upgrade their profiles

  * Fixed failures with plugins with presents when enabling containerization for DSS engine

  * Fixed writing dataframe using Spark failing if dataframe is empty




## Version 12.6.1 - April 26th, 2024

DSS 12.6.1 is a security, performance and bugfix release

### Datasets and connections

  * Snowflake: Fixed per-user credentials in user/password mode




### Charts

  * Fixed PDF export of scatter multi-pair chart




### LLM Mesh

  * Fixed tokens streaming on AWS Bedrock




### Jobs

  * Restored proper error message when job resolution fails

  * Fixed jobs hanging after aborting pending jobs




### Cloud Stacks

  * Fixed GPU support on EKS and AKS




### Security

  * Fixed [Improper preservation of “Run as” settings](<../security/advisories/dsa-2024-001.html>)

  * Fixed [Improper logging of cleartext credentials](<../security/advisories/dsa-2024-002.html>)




### Misc

  * Fixed instance crash when a library file name contains emojis characters

  * Fixed Spark SQL validation when encrypted RPC is enabled




## Version 12.6.0 - April 3rd, 2024

DSS 12.6.0 is a new feature and bugfix release.

### New feature: Data Quality

Data Quality offers pre-built dashboards for monitoring datasets quality within a single project or across an entire Dataiku instance. Users now have the option to select from a range of rules to evaluate the quality of data in datasets.

Data Quality replaces Checks for Datasets. Existing checks on datasets are seamlessly migrated to Data Quality rules.

### New feature: Filter panel in Dashboards

It is now possible to display filters outside of the page’s grid with the flexibility to position them on top, right, or left. It is also still possible to put filters directly within the grid, as previously.

Filters layout has been optimized for both horizontal and vertical display.

It’s also now possible to define the order of filters by drag-and-drop

### LLM Mesh

  * **New feature** : Added support for Claude 3 (Opus, Sonnet, Haiku) models in the Anthropic connection.

  * **New feature** : Added support for Mixtral-8x7B on HuggingFace local connection

  * Improved performance of local HuggingFace inference, as well as improved stability in low memory situations

  * Added ability to remap LLM connections and Knowledge Bank code environments when exporting/importing a project.

  * Added contextual menu to Knowledge Banks in the Flow.

  * Added support for stop sequences in the completion API, for API-based LLMs that support it.

  * Fixed RAG compatibility with langchain_community 0.0.27

  * Fixed rebuild of a ChromaDB or Qdrant local Knowledge Bank that could cause duplicate content or metadata.

  * Added proxy support to the Databricks Mosaic AI connection.

  * Removed support for MosaicML connections (MosaicML Inference was retired on February 29, 2024), you should now use Databricks Mosaic AI connections instead.




### Charts & Dashboards

  * **New feature** : Added Min and Max aggregations for alphanumeric columns

  * Added more predefined options to relative date filters

  * Added options to persist zoom and to display timeline when publishing a line chart on a dashboard

  * Fixed an issue with dashboard’s title edition not being applied

  * Fixed an issue with pivot tables and tree map when not using the “Group extra values as ‘others’” option with SQL engine

  * Fixed an issue when switching from 2D distribution to box plot, then to pie chart

  * Fixed a few issues downloading charts as images

  * Fixed an issue on line chart when Y axis has a manual range set

  * Fixed an issue with zoom not being well preserved on scatter plots when reloading the chart

  * Fixed a few issues with zooming on scatter multi-pair plot

  * Fixed an issue with zoom brush not being updated on line charts when using the mouse wheel

  * Fixed an issue with keyboard shortcuts for rectangle zoom selection on windows (now using Alt+Shift)

  * Fixed an issue with axis ticks configuration on scatter multi-pair plot

  * Fixed an issue with the axis scale not being updated on scatter plot when zooming in.

  * Fixed the scatter plot to disable axis padding when a manual range is set

  * Fixed scatter plot to not display “chart saved” after zooming when “preserve zoom” option is not used

  * Fixed an issue with the “revert to DSS engine” button




### Machine learning

  * **New feature** : regression models can now output prediction intervals, and those intervals are also usable in ML Overrides and java model export.

  * Added override information to java export of overridden models.

  * Added a Predicted data preview in saved models, similar to that of the analysis Lab.

  * Added support for Poisson and Tweedie objectives for XGBoost regression models.

  * Added support for scikit-learn 1.3 in Visual Machine Learning.

  * Added ability to use sparse matrices with Random Forest and Gradient Boosting models, that can help train faster and with less memory.

  * Added support for Python export and SQL scoring for XGBoost models trained with sparse matrices.

  * Added configurable GPU settings on scoring and evaluation recipes using DNN, XGBoost and some time series forecasting models.

  * Time series: Added ability to cross-test time series forecasting model on folds of equal duration.

  * Time series: Added ability to select time series forecast alignment month within a quarter or year.

  * Improved automated selection of features when computing feature importance of models using PCA feature reduction in preprocessing.

  * Improved compatibility for `y_valid` in custom metrics between evaluation and optimization.

  * Improved training speed of some time series forecasting models.

  * Fixed class switching on Feature Importance charts for multiclass classification models.

  * Fixed possible race condition causing the retraining of multiple partitions of a partitioned saved model to fail.

  * Fixed failing java scoring, in partition dispatch mode, of a retrained partitioned saved model.

  * Fixed failing computation of learning curves in Lab models for some preprocessing configurations.

  * Fixed display of only the first tree on the Decisions Trees reports of MLlib models that use multiple trees.

  * Fixed incorrect early stopping info in XGBoost Training Information report.

  * Improved memory efficiency of impact coding

  * Fixed impact coding with SQL scoring




### Datasets

  * Fixed the sampling user interface when a dataset is displayed within a Workplace

  * Added ability to write BigQuery datasets without going through GCS (via Storage API)

  * Added thousands-separators on numbers in Analyze view to improve readability

  * Editable dataset: Added right-click menu on headers

  * SQL: Added ability to write DSS dates (i.e. date+timestamp) into existing SQL tables with a SQL date (i.e. date only) type

  * Delta Lake: Fixed reading of Decimal data type on Delta Lake files written by Pyspark




### Recipes

  * Filter/Sampling: Changed defaults for newly created recipes to use no sampling

  * Prepare: Fixed Create If/then rules not detecting that some conditions cannot be translated to SQL, leading to wrong engine selection.

  * Prepare: Fixed filtering on NUMERIC SQL data types

  * Prepare: Fixed filtering on boolean SQL data types on SQLServer

  * Prepare: Fixed computation error with date difference processor on PostgreSQL

  * Fixed some inconsistencies in partitioning testing




### AI Assistants

  * Added ability to explain a project & automatically generate its description even when its Flow contains zones

  * Fixed Code assistant in Code Studios when encrypted RPC is enabled




### Coding & API

  * Added Python API to send emails via the channels defined by administrators

  * Added Python API for git capabilities of project libraries

  * Fixed `DSSWiki.get_export_stream` and `DSSWikiArticle.get_export_stream` to correctly take into account the `export_attachment` parameter when it’s set to True.

  * Fixed REST API listing projects with a single value for the optional `tag` parameter

  * Fixed Python API `DSSScenarioRun.duration` property raising an error when invoked




### Code studios

  * Added impersonation support to streamlit webapps

  * Fixed RStudio preferences not correctly synchronized back to DSS

  * Fixed deployment of webapps with code envs on automation node




### Governance

  * **New feature** : added the ability to specify custom filters on Business Initiatives, Governed Projects and custom pages

  * **New feature** : Added a link on Dataiku projects to materialize the relationship between Dataiku Applications and their instances

  * Added indicators for bundles making use of external AI services or local LLMs

  * Added blueprint version migrations in exported blueprint versions

  * Improved the robustness of the full synchronization of a design node by not failing the whole process when one item fails to sync

  * Fixed deletion of empty elements in lists




### Statistics

  * **New feature** : Univariate Analysis recipe. Export a univariate analysis card from the Statistics tab into its own recipe, for more automation and flexibility. Create Statistics recipes (Univariate Analysis, Statistical tests, PCA) from the flow, by selecting a dataset and going to the right side menu, or by clicking the `+Recipe` button (in Visual > Generate Statistics).

  * Added support for missing value in custom binning Split.

  * Expose the ANOVA degrees of freedom, in both card and recipe output.

  * Fixed configuration UI of Bivariate analysis cards, options were not always immediately reflecting changes in column selection.

  * Fixed refresh of Statistics Dashboard insights when changing filter settings.

  * Fixed possible out of bound error in time series cards on large datasets.

  * Fixed possible statistics computation slowness when using more recent versions of pandas.




### Labeling

  * Added ability to use empty annotations for Object Detection and Text Span Annotation tasks, i.e. it’s possible to label an image where there are none of the objects in scope.




### MLOps & API Deployer

  * Fixed build of API deployer image with python 3.10 built-in environment

  * Fixed usage of inherited code environment in API test queries

  * Fixed an issue with updating SageMaker deployments when no change happened in the deployment configuration

  * Allow ‘/’ in images prefix setting on Deploy Anywhere infrastructures

  * Added the ability to edit existing external monitoring scopes in Unified Monitoring settings

  * Added an option to clean generated files when deleting a scope in Unified Monitoring settings (true by default).

  * Added an option in monitoring infrastructure settings to automate the connection to the event server

  * Fixed an issue with monitoring wizard when “path within connection” is empty in the event server connection settings

  * Fixed the display of “run as” user in Unified Monitoring when scenario is set to run as last author




### Cloud Stacks

  * Fleet manager images now run AlmaLinux 8

  * Added session expiration option on Fleet Manager

  * Azure: Allow data disk resize (while instance is deprovisioned)

  * AWS / GCP: Added ability to specify tags that will be added to resources deployed by a Fleet manager template.

  * Fixed rare startup failure




### Performance & Scalability

  * **New feature** : The DSS engine can now run containerized for most visual recipes, which alleviates load on the DSS machine and permits more scalability even with the DSS engine

  * **New feature** : Tableau and PowerBI exports can now run containerized

  * Added a maximum number of concurrently running jobs (not only job activities). Excess jobs are automatically queued

  * Improved responsiveness when starting a job

  * Improved memory efficiency of Prepare recipe previews with many deleted columns.

  * Improved performance for computing code env usage

  * Performance improvements in various API calls

  * Fixed possible instance hang when using extremely nested formulas in computed columns

  * Improved performance of starting up Spark jobs with large number of connections




### Hadoop

  * Added support for CDP 7.1.9

  * Added timeout for validation of Hive queries to avoid blocking further validations




### Security

  * Added ability to force LDAP (as well as Azure AD and custom suppliers) group synchronization before starting a scenario on behalf of another user

  * Fixed issues with login groups restriction for groups containing commas in their names.

  * Sessions of users that become disabled due to an LDAP group synchronization are now immediately invalidated

  * User names from 1 to 241 characters are now accepted (was previously 3 to 80).

  * Added ability to disable signature checks for self signed certificates on API nodes with OAuth2




### Elastic AI

  * Added support for configurable shared memory (`/dev/shm`) size in container execution configuration. This is useful notably for multi-GPU scenarios

  * Automatically gather pod CPU usage while running jobs

  * Fixed case where terminated pods for failed containerized notebooks could remain registered in the cluster




### Miscellaneous

  * Added ability for administrators to display a custom message on login screen, for example to explain how to get granted access, or to reset a password, etc.




## Version 12.5.2 - February 26th, 2024

DSS 12.5.2 is a new feature and bugfix release.

### LLM Mesh

  * **New feature** : Added support for Databricks Mosaic AI LLMs (completion + embedding)

  * **New feature** : Added support for AWS Sagemaker JumpStart LLMs

  * OpenAI: Added text-embedding-3-small and text-embedding-3-large embedding models

  * Azure OpenAI: Added ability to customize cost

  * Bedrock: Added support for embedding models

  * Bedrock: Added support for custom models

  * Bedrock: Added configurable timeout

  * HuggingFace: Added support for multi-GPUs for LLM inference in container execution

  * HuggingFace: Added support for batching for HuggingFace completion

  * HuggingFace: Fixed download of Distillbert SST 2 when using model cache

  * Vertex: Fixed Vertex AI LLM connection’s network settings

  * Fixed display of icons for Knowledge Banks & Prompt Studios in Wikis




### Machine learning

  * Fixed minor issues in model overrides

  * Fixed subpopulation analysis for MLFlow models and containerized execution

  * Fixed training of LightGBM algorithm with bayesian search and kfold enabled when an explicit number of leaves is set

  * Added “Minimum sampled per leaf” option in LightGBM algorithm settings

  * Added support for MLFlow and External models to the “get_predictor” method

  * Fixed too strict workspace name validation for AzureML External Models

  * Fixed “Test” action of Databricks model deployment connection at creation time




### MLOps

  * Improved UI performance when a single store contains thousands of evaluations

  * Fixed subpopulation computation on Model Evaluation from standalone evaluate recipe when run in a container




### Charts

  * **New feature** Added zoom on scatter and scatter multi-pair charts by drawing a rectangle

  * Improved performance of scatter multi-pair charts with large number of points

  * Fixed wrong safety on X-axis when there are more than 10k points to be drawn

  * Fixed possible overlap between chart values and axis with negative values

  * Fixed Sankey chart if curvature parameter had been previously set to 0

  * Fixed scatter charts with reference line display

  * Various small bugs fixes on reference lines, scatter multi-pair and Geo Map charts




### Dashboards

  * Fixed dashboard filters in dashboard exports




### AI Assistants

  * Fixed missing scrollbars when using AI Explain on a highlighted segment of code




### Governance

  * Fixed item edition when opened from a table row




### Code Studios

  * Fixed possible error when a Code Studio template does not have a label defined

  * Fixed Dataiku API initialization in RStudio when encrypted RPC is enabled




### Datasets and connections

  * Elasticsearch: added typing for nested object fields

  * Elasticsearch: Fixed filters on time dimensions for field-based partitioning

  * Elasticsearch: Fixed export to recipe does not include Elasticsearch query string anymore

  * Snowflake: Fixed project-level override of connection variables with Snowpark

  * Databricks: Fixed project-level override of connection variables

  * Files in folder: Fixed the “Test & Get schema” button on existing datasets

  * GCS: Fixed access token refresh

  * Added ability to define extra Hadoop configuration keys on cloud storage connections




### Visual recipes

  * Prepare: Prevented “Date Part” mode settings of the “Keep rows” processor to be reset when opening the recipe

  * Prepare: Fixed disabled run button after running “remove column” step with error

  * Prepare: Fixed find and replace step on PostgreSQL if replacement values is not the same type than input column

  * Sync: Fixed sync from BigQuery to GCS when source is a BigQuery view

  * Improved the display of dataset with long names in dataset selection fields

  * Improved valiation error when some connections have been deleted




### Scenarios and automation

  * Fixed UI issue when adding several non saved steps of the same type

  * Fixed “Include only required saved model versions” option when the bundle contains a clustering model

  * Fixed API service package generation from the automation node




### Deployer

  * Fixed code env variables access from API endpoint when running on Kubernetes




### Coding

  * Added Python API to setup SSO, LDAP and AzureAD settings

  * Added Python API to setup FM keyvault

  * Added helper to manage code env presets

  * Added safety to prevent creation of DSS_INTERNAL code environment




### Cloud Stacks

  * Fixed “re-provision from snapshot” action in Fleet Manager if existing disk cannot be saved

  * GCP: default to “eu” image for region outside of us/eu/asia

  * GCP: avoid NTP drift if “restrict metadata access” option is checked

  * Upgraded kubectl version in DSS images. Old managed Kubernetes clusters may need to be recreated.




### Elastic AI

  * Added a mechanism to retry instead of fail in case a ResourceQuota error is raised




### Misc

  * Fixed Requests database not copied when migrating internal database from H2 engine to PostgreSQL

  * Fixed “Add remote” in project version control when setting a custom ssh command

  * Fixed a potential issue saving a deeply nested file




## Version 12.5.1 - January 31st, 2024

DSS 12.5.1 is a performance and bugfix release.

### Code studios

  * Fixed existing Code Studios not starting




### Deployer

  * Fixed error when saving project deployment settings




### Kubernetes

  * Fixed an issue leading to Kubernetes pods leak when aborting a job




### Code environments

  * Fixed possible issue when listing code environments if there is a corrupted code environment definition




## Version 12.5.0 - January 23th, 2024

DSS 12.5.0 is a significant new release with both new features, performance enhancements and bugfixes.

### New feature: Unified Monitoring

Unified Monitoring provides out-of-the-box dashboards to monitor the health and status of both Dataiku projects and API deployments.

Unified Monitoring is part of the Dataiku Deployer.

Monitoring of API deployments includes both DSS-managed endpoints and other endpoints not managed in DSS (referred to as _External Endpoints_).

### New feature: LLM Mesh General Availability

The [LLM Mesh](<../generative-ai/index.html>) is now Generally Available

### New feature: AI Code Assistant

The new Dataiku AI Code Assistant for Python helps you write, explain, or debug code, comment and document your work, create unit tests, and more.

The Dataiku AI Code Assistant is available:

  * In Visual Studio Code (in newly created Code Studios)

  * In Jupyter notebooks. Run %load_ext ai_code_assistant to start using




AI Code Assistant must first be enabled by the administrator in Admin > Settings > AI Services. It requires a connection to the LLM through the LLM Mesh

### New feature: AI Prepare

In the prepare recipe, AI Prepare allows you to describe the transformation you want to apply. The AI assistant generates the necessary data preparation steps.

AI Prepare must first be enabled by the administrator in Admin > Settings > AI Services, and requires agreeing to Dataiku AI Services Terms of Service.

### New feature: AI Explain Flow

In the flow, AI Explain can automatically generate descriptions of what the whole Flow, or individual Flow zones do.

AI Explain Flow must first be enabled by the administrator in Admin > Settings > AI Services, and requires agreeing to Dataiku AI Services Terms of Service.

### New feature: AI Explain Code

In Python code recipes, this feature can automatically generate descriptions of what the code does.

AI Explain Code must first be enabled by the administrator in Admin > Settings > AI Services, and requires agreeing to Dataiku AI Services Terms of Service.

### New feature: OpenAPI generation

In the API designer, you can now define and publish OpenAPI specifications for APIs endpoints. OpenAPI, formerly known as Swagger, is a standard specification for APIs. OpenAPI support helps makes Dataiku API endpoints accessible and usable by standard API portals. It also helps organizing and advertising to end users how to use these endpoints.

### New feature: conditional formatting

You can now color cells of a Dataset containing values that satisfy particular conditions or criteria.

Conditional formatting is available in Explore, in Excel exports, and in Excel attachments in scenarios

### New feature: text and record labeling

In addition to image classes, object bounding boxes and text spans, Dataiku managed labeling can now label records (dataset rows) and text.

### LLM Mesh

  * Added ability to use custom HuggingFace models. Only fully-checkpointed models are supported (adapter models are not) and must belong to the family of a supported built-in model. This allows the use of LLMs based on Mistral, Llama2, Falcon… as well as embedding, text classification or text summarization models.

  * Knowledge Banks can be included in project exports and automation bundles

  * Knowledge Banks can be built in scenarios

  * Prompt Studio: Added Chain-of-Thought prompt sample

  * Prompt Studio: Improved experience for prompt creation

  * Added ability to customize the contextual insertion message for RAG

  * Fixed broken toxicity detection and forbidden terms filtering in recipes

  * Fixed prompt formatting for Mosaic MPT model




### Charts & Dashboards

  * Formatting of charts is now centralized in a new “Format” panel

  * In dashboards, added the ability to create Exclude cross-filters for charts and datasets

  * Filters applied on Explore are now kept when publishing a dataset to a dashboard

  * Added the ability to format both left and right axes in the following charts: vertical bars, lines and mix charts.

  * Added the possibility to show reference lines on Scatter multi-pair charts

  * Added the ability for the user to disable tooltips

  * Fixed records count display in scatter multi-pair

  * Fixed an issue in pivot tables when dealing with large numbers

  * Fixed an issue with the copy of charts with large amount of settings (reference lines, filters, …)

  * Added the ability to set thumbnails and descriptions for workspaces

  * Fixed issue with refresh of workspace permissions when losing access to a workspace




### Flow

  * Added a new Flow view, “Column usage”, to see where some given columns appear




### Recipes

  * Prepare & Sample/Filter: Added “is between” and “is not between” operators

  * Prepare: Added SQL support for date parsing patterns with 2-digit years




### Datasets

  * Filters in Explore view now display up to 500 values (up from 50)

  * Metrics: Fixed display of history of metrics of type “Most frequent values > Mode”

  * BigQuery: Fixed error when listing the partitions of a table partitioned in BigQuery with BigQuery option “partition filter required”

  * New view in dataset to display one or multiple large values from a single line

  * Databricks: Fixed error when performing fast write to DataBricks on partitioned datasets with an empty partition




### Visual Machine Learning

  * **New feature** : Clustering models now feature a chart plotting the model’s performance against the number of clusters. This helps to visually check the optimal number of clusters (elbow chart)

  * **New feature** : Prediction Overrides can now use Uncertainty (for binary or multiclass classification tasks) as criteria for matching. This enables rules such as “if the uncertainty of the model is above 30%, decline to make a prediction”.

  * Added support for sparse matrices with XGBoost and LightGBM, allowing for faster and more memory-efficient training

  * Added support for scikit-learn 1.2

  * Added support for Python 3.11 (except for Visual Deep Learning and Causal ML)

  * Added support for pmdarima 2.0.x and prophet 1.1.x for Time series forecasting

  * Removed upper limit on L1 and L2 regularization for XGBoost

  * Fixed display of value distribution for text features in Design settings

  * Fixed incorrect reuse of older dataset extracts for training following reversal of design settings to a previous session

  * Fixed failing download of training diagnostic in some partitioned training cases

  * Fixed clustering & scoring recipes using Isolation Forest with Outlier Detection enabled

  * Fixed clustering training recipe on automation node when no version was bundled in the Saved Model

  * Fixed possible permission issue in Model Error Analysis when a model was trained by another user




### Govern

  * **New feature** : Artifact timeline: Enriched the timeline view in artifacts with details about the changes made to the artifact, and with filtering capabilities

  * Added indicators for projects making use of external AI services or local LLMs

  * Added indicators for projects that are either a Dataiku application template or and application instance

  * Added support for AWS SES in email settings

  * Fixed blueprint version list issue when deleting a blueprint version that was forked to create other blueprint versions

  * Fixed an issue preventing to save again a blueprint version when a first save was rejected because of validation errors




### Webapps

  * Fixed an issue accessing webapps with a vanity URL on Cloud Stacks

  * Fixed accessing Dash, Shiny & Bokeh Webapps with an URL that does not end with a slash




### Code Studios

  * **New feature** : Added ability to create and deploy Gradio webapps

  * **New feature** : Added ability to create and deploy Voila webapps

  * Added ability to disable the container cache when building templates




### MLOps

  * In the Evaluation recipe for AWS Sagemaker external models, the data drift column handling now relies on the model’s schema rather than on the dataset’s columns

  * Added support for Sagemaker log format in the Evaluation recipe for models deployed through the Deployer

  * Fixed an issue in the Evaluation recipe when the evaluation dataset contains columns with a name that looks like a probability column

  * Fixed a compatibility issue for model import from Databricks




### Labeling

  * Added support for comments on Labeling tasks. When enabled on a Labeling task, Annotators and Reviewers can add a comment along with their annotations. Comments show up in Review, and are included in the output dataset.




### APIs and coding experience

  * Added support for Pandas 1.4 and 1.5 in code environments

  * Added support for using Conda for Python 3.10 code environments

  * Added the ability to edit SQL recipes in SQL notebooks

  * Added APIs to rename datasets and recipes

  * Code Studios: Added an option in the API to rebuild dependent templates when updating a Code env

  * Added DSSCodeStudioObject.change_owner method to change the owner of a Code studio

  * Fixed an issue with R recipes sometimes reporting a successful run whereas code failed




### Elastic AI

  * Fixed an issue preventing Jobs from starting when executed on Pods with init containers

  * Added ability to use Spark on Kubernetes with GCS connections where the private key is passed as a file path




### Streaming

  * Improved latency of StreamingEndpointStream.get_message_iterator()

  * Fixed scala streaming recipe from a DSS Dataset to a streaming endpoint




### Plugins

  * More icons: Plugin developers can now choose their icons among all icons available in Font Awesome 5.15.4




### Performance & Scalability

  * Reduced IO cost of starting a job

  * Reduced perceived latency of starting a job in many cases

  * Improved startup performance for containerized execution, when large data exists in project libraries

  * Improved startup performance for containerized execution, when scoring large models

  * Added the ability to control resource consumption (through cgroup) for plugin data-related components (custom datasets, custom formats, custom exporters, custom FS providers)

  * Performance enhancement upon modifying permissions, for DSS instances with large number of both projects and users

  * Fixed possible hangs related to dataset using custom FS provider from plugins

  * Added ability to “pre-heat” job execution processes to lower the job start latency

  * Added protection against too large API service package exports (20GB max)

  * Added protection against hang due to too large number of AzureAD groups




### Cloud Stacks

  * Allow provisioning DSS instances with a temporary self-signed certificate (while waiting for the actual certificate to be installed)

  * Fixed an issue when trying to create several setup actions of same type (only affects DSS 12.4)

  * Added ability to automatically set up a Visual Machine Learning code env




### Miscellaneous

  * Added ability to use Python 3.10 for the builtin environment

  * Added new built-in macro to clear assets from expired trial users

  * Added ability to filter datasets by data steward in Data Catalog

  * Added ability to quickly search for scenario steps in the UI

  * Fixed an error happening when users that do not have access to any connection try to create a managed folder

  * Version control: When creating a new branch and duplicating the project, the newly created project now keeps the same name, description, permissions as the original project

  * Fixed a possible R setup issue

  * Fixed inconsistencies in accessing DSS login page, depending on the presence of a trailing slash




## Version 12.4.2 - January 12th, 2024

DSS 12.4.2 is a security, performance and bugfix release.

### LLM Mesh

  * Added support for Google Vertex Gemini Pro model

  * Added support for custom models in OpenAI connection

  * Added support for embedding and multiple models in plugin LLMs

  * Added ability to enter a base URL instead of resource name in Azure OpenAI connections

  * HuggingFace: Fixed Mistral model when DSS-managed model cache is in use

  * HuggingFace: DSS-managed model cache now abides by proxy settings

  * RAG: Added ability to build Knowledge Banks from scenarios

  * RAG: Added display of estimated cost for Augmented LLMs

  * RAG: Added support for local Qdrant as the vector store for a Knowledge Bank

  * RAG: Improved Knowledge Bank display in flow zones, flow views and project timeline

  * RAG: Fixed support for ChromaDB on Cloud Stacks and RHEL 8 OS

  * API: Added cost support to DKULLM and DKUChatLLM

  * API: Add batching support to DSSLLM and DKULLM

  * API: Fixed KnowledgeBank usage from code recipes




### Datasets and connections

  * BigQuery: Fixed issue with native BigQuery partition on ‘DATE’ column when require_partition_filter is activated

  * Databricks: Fixed connection issue when using Databricks with S3 Fastpath

  * ElasticSearch: Fixed error handling when testing connections

  * SQLServer: Fixed all-catalogs table listing when credentials do not allow to access some databases

  * Plugin datasets (such as Sharepoint): Fixed process and resource leaks in case of error during initialization

  * Fixed object authorization when sharing multiple object from the side panel




### Charts and Dashboards

  * Dashboards: Fixed the “Clear all filters” action leading to wrong results until page reload

  * Geo charts: Fixed log scale for colors

  * Fixed an issue with the isNumeric function for null values in User Defined Aggregation Functions definition




### Visual recipes

  * Prepare: Added additional safety when converting DSS formula to SQL to prevent possible hangs

  * Prepare: Fixed “Create If… Then” rule on Snowflake when the expression involves a GeoPoint column with literals

  * Prepare: Fixed “is any of the strings” filter condition when run with Spark engine

  * Prepare: Fixed Python step when run on Spark with local config

  * Fixed issue on SQL Server when the database user does not have “SHOWPLAN” permission




### Machine learning

  * Fixed “What If” analysis on Object detection and Image classification models in containers

  * Fixed Lasso path model training when using bayesian hyper parameter search

  * Fixed failure on evaluate recipe on MLFlow model when the target column has missing values

  * Fixed error when a user browses a visual ML task without “manage-all code envs” privilege

  * Fixed displayed models in sentence embedding preprocessing with “inherit” or “builtin code-env” settings

  * Fixed output of probabilities in scoring recipe

  * Fixed evaluation and scoring of MLFlow binary classification models when the prediction is a boolean




### API Deployer

  * Fixed deployment on Kubernetes of endpoints with a code env with resources

  * Deploy Anywhere now features the deployment of an API service on an endpoint provisioning GPU(s)

  * Improved deployment health check computation for VertexAI, Azure ML and SageMaker model

  * SageMaker: Fixed deletion of cloud resources when deleting SageMaker deployments

  * Databricks: Fixed not persisted OAuth token settings on Databricks model deployment connections




### Automation

  * Fixed missing Git tag creation when a bundle is created from a scenario or from the API

  * Fixed error when manually creating an analysis on automation (not recommended)




### Coding

  * Added API to manipulate project level git capabilities

  * Fixed the user profile returned by the public api when user is involved in a trial




### Code Studios

  * Fixed download action from the “Resources” tab




### Elastic AI

  * Fixed image building for conda-based code environments




### Cloud Stacks

  * Fixed “Install system packages” setup action

  * Fixed safety limits that could hinder SSH login




### Security

  * Prevented users without “freely use” privilege from writing custom SQL filters




### Performance & Scalability

  * Improved dataset column statistics computation scalability

  * Fixed possible hang when reconfiguring auditing settings while the event server is unresponsive

  * Fixed performance degradation when adding a vast number of files at once in an existing upload dataset




## Version 12.4.1 - December 21st, 2023

DSS 12.4.1 is a security and bugfix release. It contains a critical security fix. We strongly encourage all customers to upgrade to this version.

### LLM Mesh

  * Fixed failure accessing private HuggingFace models when using DSS-managed model cache

  * Fixed support for Mistral when using DSS-managed model cache




### Recipes

  * Prepared: Fixed failure of “if-then-else” processor running on SQL databases when setting date columns




### Collaboration

  * Fixed broken styling of Wiki PDF export




### Webapps

  * Fixed redirection to login page when accessing a public webapp URL




### Code Studios

  * Fixed Code Studios with R Code Envs on automation node




### Cloud Stacks

  * Azure: Added the ability to provision instances with data disks above 4 TB




### Upgrade

  * Fixed possible upgrade failure to DSS 12.4




### Security

  * Fixed [LDAP Authentication Bypass](<../security/advisories/dsa-2023-010.html>)

  * Removed plaintext HuggingFace tokens from logs




## Version 12.4.0 - December 6th, 2023

DSS 12.4.0 is a significant new release with both new features, performance enhancements and bugfixes.

### New feature: Deploy models to AWS Sagemaker, Azure Machine Learning and Google Vertex

Dataiku can now deploy API services designed in Dataiku to other platforms, besides Dataiku API nodes.

This capability is available for AWS Sagemaker, Azure Machine Learning and Google Vertex

### New feature: connect to external models hosted in Databricks Serving

It is now possible to create External Models from Databricks Serving endpoints

### New feature: import models from Databricks MLflow registry

It is now posible to import MLflow models directly from a Databricks-hosted MLflow registry

### New feature: Dashboard Cross-filters

The Dashboard now features cross-filters. Cross-filters allow users to interactively explore and analyze data from different perspectives simultaneously. By applying filters across multiple visualizations or data sources, users can dynamically drill down into specific data subsets. This interactivity enables users to gain a comprehensive understanding of their data.

### New feature: “Insert recipe”

You can now insert a new recipe after an existing dataset or between an existing dataset and recipe. This makes it easy, for example, to add a prepare recipe in an existing Flow.

### New feature: Learning curves

On a trained prediction model, you can now compute Learning curves to see how metrics evolve on the train and test set when training the model with only a part of the data.

### New feature: Statistical tests recipe

A new Statistical Test recipe allows you to perform many statistical tests via the flow and can be automated from a scenario. Create it from a test card, in a dataset’s Statistics tab.

### Redesigned home page

The home page has been slightly redesigned and now features a panel with recommended content, aimed at improving self-onboarding on DSS.

### LLM Mesh & Prompt Studio

  * **New feature** : Added support for embedding with locally-running models using HuggingFace

  * **New feature** : Added ability to import, export and delete the weights in the DSS model cache for local HuggingFace LLMs

  * **New feature** : Added Cohere and Llama2 models to Bedrock connections

  * **New feature** : Added Mistral and Zephyr models to Huggingface connections

  * Added an option for LLM-based text analysis recipes to show the underlying prompt

  * Added OAuth authentication for Azure OpenAI

  * New Public API to list LLMs and Knowledge Banks

  * Fixed copy of a part of a flow that would fail if it contained a Knowledge bank

  * Fixed Azure OpenAI connection test




### Charts & Dashboards

  * **New feature** : A new chart has been added to the builtin charts: the Sankey diagram

  * **New feature** : Reference lines can now use dynamic aggregation values. For example, on a bar chart showing the average of price per department, you can also have a reference line showing the global average.

  * **New feature** : Scatter plot: Added support for multiple pairs of (X, Y) is scatter plot

  * **New feature** : Added a color dimension to the Boxplot and Mix chart

  * **New feature** : Added ability to automatically refresh tiles on a loaded dashboard when a scenario impacting them is executed

  * Added the ability to copy content from pivot tables

  * Improved reliability of DSS engine when working with datasets containing high-cardinality alphanumeric columns

  * Fixed the pinning of tooltips in Boxplot

  * Fixed grand total not showing in pivot table when either rows or columns are empty

  * Fixed an error happening in Scatter plots when changing the meaning of a column from numeric to alphanumeric

  * Fixed removal of filter tile not taken into account in “edit” mode

  * Fixed behavior difference between DSS and SQL engines when using numerical axis

  * Fixed behavior difference between DSS and SQL engines when filtering on dates

  * Fixed tooltip display on chart miniatures with no thumbnail

  * Fixed “out of memory” error eventually happening when building charts on big datasets




### Datasets

  * Improved user experience when creating datasets from managed folder

  * Added default steward to datasets. In case no steward is explicitly defined, the user who created the dataset is now considered as the default steward

  * Databricks: Automatically refresh access tokens before their expiration to support long running jobs

  * Databricks: Added support for per-user personal access tokens on the Databricks Connect integration

  * Editable dataset: Added back the ability to enable/disable “Keep track of manual changes” setting

  * Editable dataset: Added action to allow a row to be used as column names

  * Editable dataset: Added ability to quickly filter rows using keywords

  * Editable dataset: Added ability to sort rows by column

  * BigQuery: Fixed jobs failure with SQL pipelines and BigQuery datasets with a variable in the schema field

  * Fixed sharing a dataset resetting its object authorizations

  * Faster and more robust read support for Delta format

  * Only drop metastore tables associated with managed datasets upon project deletion if also dropping the managed dataset data




### Recipes

  * Prepare: Added ability to create If … then Rule based on cell values with right-click menu

  * Prepare: Added ability to increment date by hours, minutes or seconds in Date Increment steps

  * Prepare: Deprecated Anonymizer processor in favor of Pseudomyze processor

  * Prepare: Fixed new column cannot be renamed immediately after it has been created by a “split … on” step

  * Prepare: Improved distances precision in the Compute distance processor on DSS engine (we now use an ellipsoidal coordinates reference system instead of the previous spherical one)

  * Prepare: Fixed various casting issue with BigQuery and PostgreSQL inputs datasets

  * Prepare: Fixed SQL pipeline failing with Snowflake inputs datasets when some processors are present in the recipe

  * Prepare: Fixed parsing a date with multiple formats failing with Databricks input datasets and SQL engine

  * Prepare & Sample/Filter: Added “Does not contain” operator

  * Sample/Filter: Fixed possible time-shifts with dates with Snowflake inputs datasets with TIMEZONE_NTZ columns

  * Sync: Added support for Parquet file format when syncing datasets between BigQuery and GCS

  * SparkSQL: Fixed checking consistency failing




### Webapps

  * Fixed missing redirection to actual public webapps URL after a user logs in with SSO

  * Added automatic restart of Webapps when their security settings are modified

  * Added support for Bokeh 3.1.1

  * Fixed issue deploying Streamlit as webapp with Streamlit versions 1.23 and above.




### Machine Learning

  * **New feature** : A Model override outcome can now be set to Decline to predict, allowing you to define explicit cases where the model will refuse to give a prediction.

  * **New feature** : Causal ML: a new Treatment Analysis option lets you use inverse probability weighting for causal metrics, mitigating against misleading metrics in the case of non-random or imbalanced treatments. New ML Diagnostics automatically detect such imbalanced cases.

  * Added support for Python 3.10 on Visual Machine Learning

  * Improved GPU settings on modeling tasks that support GPU acceleration

  * Feature Importance now displays reading tips for the current features

  * Custom scoring for model optimization can now reuse any of the model’s custom metrics used for performance evaluation

  * Sped up computation of feature importance for some preprocessing options

  * Added more public APIs to manage Causal ML models

  * Fixed permission error when using code to access a model trained by a different user

  * Fixed time series forecasting with integer external features used as categorical

  * Fixed scoring failure on the SQL engine of models that use feature selection

  * Fixed scoring using scikit-learn ≥ 0.24 of calibrated or SVM models trained with scikit-learn < 0.24

  * Fixed training failure on some cases of feature reduction and all-numeric features

  * Fixed export of Predicted data when the meaning does not correspond to the data, NaN values were incorrectly inserted

  * Fixed a model documentation generation bug that left it stuck at the “resolving placeholders” stage

  * Fixed a race condition on ML recipes when a partitioned dataset is both being built and used in concurrent activities of a single job

  * Fixed a rare bug where a schema change would cause an evaluation recipe to fail but keep running

  * Added option to not fail model-less evaluation recipe when some metrics compuations fail

  * Added custom metrics for time series forecasting models

  * Added model coefficients to time series forecasting model reports for algorithms that support it

  * Fixed slow time series forecasting training in containers when using ARIMA




### Computer Vision

  * Take into account EXIF rotation information in images (when training and scoring)




### Labeling

  * **New feature** : Labeling tasks can now take into account pre-existing labels, that annotators can edit, remove or validate as their answer. Such pre-labels also help to configure the labeling task automatically.

  * Improved support of right-to-left languages on Text labeling tasks

  * Added ability to quickly delete all annotations when annotating a given entry on Object detection or Text annotation tasks

  * Fix unusable task when an input column is named `state`

  * Fix hung task when source dataset creation fails

  * Fix unusable task when source dataset is on a connection with per-user credentials




### Visual Statistics

  * Added support for confidence interval in 1-sample and 2-sample t-tests as well as ANOVA

  * Added support for one-sided testing on 1-sample, 2-sample and pairwise t-tests

  * Automatically refresh statistics card published as Dashboard Insights




### Govern

  * **New feature** : Blueprint migration (Advanced Govern only): In some cases, you might want to switch a Govern artifact from one template (blueprint version) to another. With the advanced option, it is now possible to create a template migration to preserve, remove, or add information for the migration.

  * **New feature** Custom Page Designer revamping (Advanced Govern only): Advanced Dataiku Govern provides the capability to create custom pages with the Custom Pages Designer. The UI of the Custom Pages Designer has been improved and some functionalities have been added:

    * Ability to show/hide pages (incl. standard pages)

    * Ability to specify the order of the pages in the navigation bar (incl. for standard pages)

    * Possibility to create a page defined by pure HTML code. This allows the embedding of external content such as dashboards or videos for example.

  * Notifications: Added more notification triggers on sign-off events (feedback or final approval submitted / edited, sign-off abandon, cancelation, reset, or scheduled reset)

  * Notifications: improved email content

  * Notifications: added the ability to subscribe/unsubscribe to notifications

  * Improved fields in the standard templates to help better address the Pipeline Management and Value Monitoring use case. Note: The “Business functions” list has been updated. It has been removed from the Govern project standard blueprint version. This list has been enhanced with new values and is now located at the Business Initiative level. As a consequence, existing filled-in values are not available anymore.

  * Added Kanban and Matrix views in the Business Initiatives page

  * Added a default 3-step workflow in the Business Initiatives standard template

  * Added the possibility to create a Governed Project directly from the projects page (not linked to a Dataiku Project)

  * Eased the selection of users by groups in user selectors within artifacts

  * Added the ability to edit values from a row directly from a table view

  * Added a new “Govern manager” permission with all administrator permissions except Users, Groups, LDAP, SSO, and everything in administration settings

  * In Roles & Permissions settings, added the ability to inherit role assignment roles from multiple sources

  * Added more evaluation metrics in the Model Registry

  * Fixed table width inconsistencies among screens

  * Added a general setting to disable the signoff delegation feature for non-admin users

  * Fixed an issue preventing field ids from being displayed in view components in the Blueprint Designer

  * Fixed an issue with PDF export of artifacts in case of line breaks in the fields

  * Fixed migration issue with PostgreSQL server distribution that has a modified maximum length for identifiers (NAMEDATALEN)

  * Fixed the “all day” option removing the entry from list of dates when unchecked

  * Fixed the search in category fields where selecting a category from the search results was unselecting other categories not displayed in the search results

  * Fixed date column overlapping when included in a nested table view




### MLOps

  * Added support of “common” sagemaker inference data formats for External Models

  * Added a check that the classes defined for External Models or MLFlow Models are matching the specified evaluation dataset.

  * Added a public API method for importing Lab Models into Experiment Tracking

  * Fixed some cases where the Evaluation Recipe was failing in drift computation even though “Consider drift computation failures as errors” option was disabled.

  * Fixed monitoring wizard to require only read access to the infrastructure (and not admin as before)

  * Fixed the evaluation of MLflow models imported through mlflow_extension.deploy_run_model()

  * Added the support for column handling in the Evaluation Recipe for External Models




### Deployer

  * Improved performance for bundle preparation

  * Fixed the creation & update of a plugin’s Python code environment via API on an automation node

  * Added support for custom code environment and removed the need for “unsafe code” permission in API test queries

  * Fixed an issue with remapped and bundled connections in API deployments when intermediate build of a code environment image is activated

  * Added automatic rebuild of code environment image if base image is modified

  * Improved the handling of “internal” code environments when deploying to automation (i.e. computer vision and External Models code environments)

  * Fixed remapping of code environment for Continuous Python recipes




### Code Studios

  * Added ability for users to upload files in templates

  * Fixed build of conda code envs for Code Studios on automation node




### API

  * Fixed `DSSDataCollectionItem.get_as_dataset` Python function

  * Added new helper function `DSSManagedFolder.create_dataset_from_files` to create a new dataset of type ‘FilesInFolder’

  * Added new helper functions `DSSProject.create_gcs_dataset` and `DSSProject.create_azure_blob_dataset` to create GCS and Azure Blob storage datasets

  * Added support for catalog in `DSSProject.create_sql_table_dataset`




### Performance & Scalability

  * Improved performance for tag listing on DSS instances with many projects

  * Improved performance for computing code environment usage

  * Improved performance for notifying users when changing access of many project/users




### Cloud Stacks

  * Fixed time zone issues with user’s last activity time on licence management page

  * Fixed issue caused by Java upgrading itself while DSS is running

  * Fixed issue preventing users from downloading files larger than 1GB

  * Added ability to reorder setup actions in Fleet Manager

  * AWS: Added ability to use a static private IP for Fleet Manager

  * Azure: Fixed issue where reprovisioning from a snapshot changed the type of the data disk




### Elastic AI

  * GCP: Fixed ability to attach GKE clusters instantiated in another project than DSS

  * Fixed Spark failing to delete pods due to insufficient permissions

  * Fixed horizontal pod autoscaling with K8S versions 1.26 and above

  * Fixed possible failure of DSS jobs when scheduled on a K8S node that is still starting




### Version control

  * Modified storage of DSS objects to remove the `versionTag` to make them more git-friendly (less “useless changes” generated)

  * Changed the way Git security rules are matched. DSS now considers the first rule for which both the group and repository match instead of the first rule matching the repository. This allows for more fine-grained control of which SSH key is used, for example.




### Plugins

  * Fixed an issue where renaming a file or folder in the plugin editor did not refresh the view

  * Fixed plugin recipes failing when containerized execution is selected

  * Allow DSS admins to overwrite the OAuth token endpoint in the presets




### Miscellaneous

  * Fixed export of Pandas dataframes from Jupyter notebooks when package `requests` is at or newer than version 2.29

  * Fixed Flow zoom level being sometimes incorrectly reset when navigating away from a project

  * Fixed permission issue preventing users with only “Read dashboards” permission on a project from accessing a shared dataset included in a dashboard

  * Fixed permission issue preventing users from viewing whole preview of shared datasets if they did not have the “Read project content” permission on the source project

  * Added a setting for administrators to prevent users from changing their emails

  * Help center is now displayed as a draggable panel on small screens

  * Help center: Added setting for administrators to prevent users from opening Dataiku support tickets

  * Made ability to delete code env dependent on permission to manage it

  * Fixed Event server losing data when the flush interval is higher than 50 minutes

  * Fixed issues with PostgreSQL runtime databases

  * Fixed an issue where an App-as-recipe created without a name/label prevented users from creating new recipes

  * Fixed authentication issue when connecting to strict OAuth2s servers

  * Fixed authentication issue preventing some users from login after ‘enable group support’ has been unchecked

  * Code envs: Fixed issue with “Update all packages” option




## Version 12.3.2 - November 15th, 2023

DSS 12.3.2 is a security, performance and bugfix release

### LLM Mesh & Prompt Studio

  * **New feature:** Added a Convert to prompt recipe button in the classification and summarization

  * OpenAI: Added GPT4-turbo model

  * Azure OpenAI: Added & Fixed embedding support

  * AWS Bedrock: Adapted to new AWS API

  * AWS Bedrock: Added support for topP and topK

  * RAG: Improved error handling in augmented LLMs

  * Prompt studio: Added ability to select a recipe to update from the Save as recipe option

  * Prompt studio: improved UX when switching between Managed & Advanced modes

  * API: Fixed dataiku.KnowledgeBank python API

  * PII: Added possibility to ignore instead of failing if unsupported language is detected

  * PII: Fixed PII detection on embedding queries




### Datasets

  * **New feature** Added an experimental dialect to connect to Sqream (through the “other databases” connection)

  * Editable dataset: Fixed edition after dataset has been cleared

  * Editable dataset: Added an option to handle large copy/paste of data

  * Excel export: Added support for exporting more than 1 million records

  * Improved error handling when trying to analyze a previously removed or renamed column




### Recipes

  * Prepare: Improved mass renaming of columns based on column name pattern (regex)

  * Prepare: Fixed migration of ‘Flag rows on values’ processor

  * Prepare: Fixed creation of “filter on” step by selecting a substring in cell

  * Prepare: Do not select Athena engine by default

  * Join: Fixed icons display when using unmatched row option

  * Pivot: Improved error message when summing non numerical columns




### Notebooks

  * Fixed importing from Git when the notebook’s name contains a dot




### Dashboards

  * Fixed scrolling in dataset insight




### Govern

  * Fixed installation and update of Govern node when the DB schema is not “public”




### Spark

  * Prevented auto-selection of Spark engine when one of the outputs is in append mode

  * Fixed SparkSQL / Scala and SparkSQL notebook on CDH 6 (deprecated)

  * Fixed MLLIB training on old hadoop distributions: HDP 3.1.5 (deprecated), CDH6 (deprecated)




### Machine Learning

  * Fixed display of median and standard deviation in cluster profiles if the value is zero

  * Fixed MLFlow error with ignoring TLS certificate validity check when DSS is configured for HTTPS

  * External models: Added support of non-JSON probat format for SageMaker CSV




### Cloud Stacks

  * AWS: Fixed installation using the fleet-manager-network template




### SSO and LDAP

  * Fixed on demand provisioning on Azure AD




### Security

  * Fixed [Directory Traversal in cluster logs retrieval endpoint](<../security/advisories/dsa-2023-009.html>)

  * Added new HTTP security header to all requests: Permissions-Policy: fullscreen.

  * Added ability to specify additional HTTP security headers: Referrer-Policy, Permissions-Policy, Cross-Origin-Embedder-Policy, Cross-Origin-Opener-Policy and Cross-Origin-Resource-Policy.




## Version 12.3.1 - October 30th, 2023

DSS 12.3.1 is a bugfix release

### LLM Mesh

  * **New feature** : Added support for MosaicML

  * Fixed support for GPT 3.5 Instruct

  * Fixed embedding recipe with Azure Open AI models

  * Fixed embedding recipe when containerized execution is enabled by default

  * Fixed “embedding settings” display in Knowledge Banks

  * Fixed NLP classification recipe when output mode is “All classes”




### Coding

  * Fixed installation of the “dataiku” Python package outside of DSS




### Machine Learning

  * Fixed usage of TF-IDF Text preprocessing in Visual ML when stop words are enabled




### API Designer

  * Fixed set_remote_dss dataiku api function when used in API designer




### Bundle and Automation

  * Fixed revert of bundles on the design node




### Charts

  * Fixed usage of Snowflake engine when the database is set at the session level




### Jobs

  * Fixed the “Re-run this job” action from the job page




### Webapps

  * Fixed login redirection for public webapps created from Code Studios




### Cloud Stacks

  * Fixed loss of LDAP and Azure AD settings when Fleet Manager is restarted




## Version 12.3.0 - October 23rd, 2023

DSS 12.3.0 is a significant new release with both new features, performance enhancements and bugfixes.

### The LLM Mesh

With the recent advances in Generative AI and particularly large language models, new kind of applications are ready to be built, leveraging their power to structure natural language, generate new content, and provide powerful question answering capabilities.

However, there is a lack of oversight, governance, and centralization, which hinders deployment of LLM-based applications.

The LLM Mesh is the common backbone for Enterprise Generative AI Applications.

It provides:

  * Connectivity to a large number of Large Language Models, both as APIs or locally hosted

  * Full permissioning of access to these LLMs, through new kinds of connections

  * Full support for locally-hosted HuggingFace models running on GPU

  * Audit tracing

  * Cost monitoring

  * Personally Identifiable Information (PII) detection and redaction

  * Toxicity detection

  * Caching

  * Native support for Retrieval Augmented Generation pattern, using connections to Vector Stores and Embedding recipe.




The LLM Mesh is available in _Public Preview_ in DSS 12.3.0.

For more details, please see [Generative AI and LLM Mesh](<../generative-ai/index.html>).

### Prompt Studios and LLM-powered recipes

On top of the LLM Mesh, Dataiku now includes a full-featured development environment for Prompt Engineering, the _Prompt Studio_. In the Prompt Studio, you can test and iterate on your prompts, compare prompts, compare various LLMs (either APIs or locally hosted), and, when satisfied, deploy your prompts as Prompt Recipes for large-scale batch generation.

In addition, Dataiku now includes two new recipes that make it very easy to perform two common LLM-powered tasks:

  * Classifying text (either using classes that have been trained into the model, or classes that are provided by the user)

  * Summarizing text




Prompt Studio and LLM-powered recipes are available in _Public Preview_ in DSS 12.3.0.

For more details, please see [Generative AI and LLM Mesh](<../generative-ai/index.html>).

### Datasets

  * Databricks: Added support for global (non-per-user) OAuth login

  * Snowflake: Added support for global (non-per-user) OAuth login

  * Snowflake: Added support for variables in the Scope field for OAuth mode

  * JSON: Fixed Spark engine not properly unnesting JSON fields




### Machine Learning

  * Added support for What-if on partitioned models without the need to go in an individual partition

  * Added support of custom model views when the view backend runs in containerized execution

  * Added ability to use a Visual model’s predictor Python API from code running in containerized execution

  * Fixed computation of feature importance when there are less than 15 rows in the test set

  * Fixed failing training of deep neural network visual model when the only feature is text using sentence embedding

  * Fixed DSSTrainedPredictionModelDetails.compute_shapley_feature_importance Python API that was broken for saved models




### Dashboards

  * Fixed downloading of filtered datasets within dashboard that did not filter

  * Fixed inability to copy chart from insight view to any other chart

  * Fixed error display when a chart hits the limit of displayed points in a dashboard




### Flow

  * Fixed “Generate Flow Documentation” failing on servers with non-English locales




### Recipes

  * Shell: Fixed renaming not taking into account dataset references in pipes

  * Prepare: Fixed “Filter and flag on formula” step causing SQL engine to fail on some databases such as Redshift.

  * Prepare: Fixed “Rename” step causing SQL engine to fail in some situations such as renaming a column twice, or renaming a column with an empty string.




### Deployer

  * Fixed issue with custom base image tag in API Deployer Kubernetes images (custom base images remain discouraged)

  * Added more details in the right panel of API services




### Governance

  * Fixed Kanban views not bucketing projects correctly




### MLOps

  * Fixed incorrect trainDate in the return of the list_versions() API method for MLflow models




### IAM

  * Fixed fetching LDAP users with “Import from external source” not returning usernames if Display name attribute is different from Username attribute

  * Fixed LDAP bind password being wrongfully required, whereas it’s optional




### Cloud Stacks

  * Added setup action to add a custom CA into the trust stores of DSS

  * Added ability to reload security settings without having to restart Fleet Manager




### Code envs

  * Added support for per-code-env Dockerfile additions

  * Added support for per-code-env CUDA support, removing future need for CUDA-specific container images




### Misc

  * Fixed catalog or global search failing when query contained special characters such as @ or ~.

  * Compute Resource Usage: added CPU and memory request and limit to Kubernetes CRU events




## Version 12.2.3 - October 10th, 2023

DSS 12.2.3 is a bugfix release

### Charts

  * Fixed thumbnails display of Boxplot charts




### Recipes

  * Fixed usage of isBlank() formula function in a recipe causing incorrect results when executed with SQL engine




### Misc

  * Fixed error occurring when an event server target is configured with an “Path within connection”

  * Fixed exception being added to the logs each time an API node starts




## Version 12.2.2 - September 25th, 2023

DSS 12.2.2 is a bugfix release

### Machine Learning

  * Fixed the metrics comparison chart for time series forecasting models in the models list

  * Fixed a rare race condition causing training failures with distributed hyperparameter search




### Datasets

  * S3: Reduced memory consumption when writing multiple files on S3 in parallel

  * BigQuery: Fixed memory leak

  * Editable dataset: Fixed pressing “enter” in the “edit column” modal not closing the modal

  * Editable dataset: Fixed redo mechanism when a new row had been added

  * Fixed renaming of partitioned datasets causing downstream recipes to fail at runtime

  * Fixed inability to import Excel files containing Boolean cells computed with formulas




### Recipes

  * Join: Fixed occasional job failures with DSS engine

  * Join: Fixed wrongly detected duplicate column name when 2 columns only differ by their case

  * Prepare: Fixed “Extract Date components” with SQL engine

  * Prepare: Fixed display issue when rearranging steps order

  * Sync: Fixed schema and catalog not taken into account when executing a Sync recipe from a Databricks dataset to an Azure Blob storage dataset.

  * Shell: Fixed quotes incorrectly added around variables

  * Fixed expansion of variables in partitioning when running a recipe from its edition screen




### Deployer

  * API Designer: Fixed inability to run test queries with Python endpoints

  * Improved error message about deployer hooks code

  * Fixed an issue with the selection of core packages for Python 3.8 code environments on deployer and automation nodes

  * Added a “Validate” button in the Deployer Hooks’ code edition screen




### Experiment Tracking

  * Added ability to ignore invalid SSL certificates in experiment tracking

  * Fixed several issues with starting runs (when no end time is specified, or when a name is specified but no tags)




### Governance

  * Fixed workflow step not being displayed at creation time when there is one mandatory field defined (Advanced Govern only)

  * Fixed the filling of the signoff history on step deletion




### Misc

  * ElasticSearch: Fixed invalid projectKey passed in custom headers

  * Charts: Fixed empty legend section displayed in the left pane for charts in Insight view mode

  * Charts: Fixed timeout when exporting a dashboard containing donuts charts that need scrolling to be visible

  * Fixed “Assumed time zone” not displaying the correct default value on existing connections

  * Webapps: Fixed ability to use dkuSourceLibR in Shiny webapps

  * Fixed required permissions to import and export projects using the public API (aligning to UI behavior)




## Version 12.2.1 - September 12th, 2023

DSS 12.2.1 is bugfix release

### Machine Learning

  * Fixed UI issue disabling the creation of AutoML Clustering models




### Cloud Stacks

  * Fixed the reprovisioning of DSS instances from Fleet Manager following a change in PostgreSQL repositories




### Misc

  * Fixed a memory leak enumerating Azure Storage containers with very large number of files




## Version 12.2.0 - September 1st, 2023

DSS 12.2.0 is a significant new release with both new features, performance enhancements and bugfixes.

### New features and enhancements

#### Custom aggregations on charts

UDAF (User Defined Aggregation Functions) allow user create custom aggregation based on a powerful formula language directly from the chart builder.

For example, you can directly create an aggregation of `sum(sell_price - cost)` to compute an aggregated gross margin, without having to first create that column.

#### Radar chart

The Radar chart is now available. Radar Charts are a way of comparing multiple quantitative variables . This makes them useful for seeing which variables have similar values or if there are any outliers amongst each variable .

Radar Charts are also useful for seeing which variables are scoring high or low within a dataset, making them suited for displaying performance.

#### Popular datasets

The Data Catalog home page now lists datasets that have been detected as popular on the DSS instance. Popular datasets are datasets that have been shared to multiple other projects and are actively used as source of new recipes. They are the ideal candidates to bootstrap your first data collections or to be added to existing data collections.

#### Govern Sign-off enhancements

Improvements of the sign-off feature allowing to:

  * Reset a finished sign-off

  * Reload an updated configuration from the Blueprint Designer

  * Create a sign-off on an active step if its configuration has been created afterwards

  * Setup recurrence to automatically reset an approved sign-off

  * Have multiple feedback reviews per users

  * Edit and delete feedback reviews and approvals

  * Change the sign-off status to go back to a previous state

  * Send an email to the reviewers when the final approval is added and deleted

  * Additionally, a new validation option has been added in the sign-off configuration to prevent the workflow from going past an unapproved sign-off step.




It also comes with UI improvements such as:

  * Expand and collapse long feedback reviews

  * Display the sign-off description below the title

  * Show the feedback and approver groups with details info on which users are configured




_Warning_ : Some changes have been made to the API around the sign-off feature, you need to pay attention to your usages of the Public API and, for Advanced Govern instances, the logical hooks around the sign-off feature. Only for Advanced Govern instances, you may currently use logical hooks that are checking the sign-off status (preventing the workflow from going past an unapproved sign-off step) which will not work anymore in 12.2.0 due to the API changes. They can be replaced by the new validation option in the sign-off configuration to prevent going past an unapproved sign-off step. After enabling it, you will need to reset the corresponding sign-offs and reload their configuration.

#### PCA recipe

A new PCA recipe was added. The PCA recipe produces projections, eigenvectors and eigenvalues as three separate datasets.

You can create the PCA recipe from a PCA card in a dataset’s Statistics worksheets.

#### External Models

External Models allow a user to surface within Dataiku a model available as an endpoint on SageMaker, Azure ML or Vertex AI. Those models can be used like others Saved Models and most noticeably be scored and evaluated.

This feature is currently Experimental.

For more details, please see [External Models](<../mlops/external-models/index.html>)

#### Deployer Hooks

Deployer hooks allow administrators of a Project or API Deployment Infrastructure to define pre- and post-deployment hooks written in Python. For instance, a pre-deployment hooks could perform some check and prevent a deployment if it fails ; a post-deployment hook could send a notification.

### Other enhancements and fixes

#### Flow

  * The “Records count” view now displays the exact records count under each dataset in the Flow

  * Added ability to export flow documentation when having read-only acces to the project

  * Added ability to chose the name of the new zone when you copy a Flow zone

  * Added ability to copy a zone directly from the right panel

  * Fixed copying the default zone into a new zone duplicating flow objects into the original zone instead of the new zone

  * Fixed copying a zone not duplicating datasets without inputs

  * Fixed copying a zone to another project creating 2 zones into the destination project

  * Fixed “Recipe Engines” view not listing some engines such as “Snowflake to S3”.

  * Fixed creation of new datasets when creating a new recipe from “+ Recipe” button with no input selected




#### Datasets

  * BigQuery: Added ability to specify labels that will be applied to BigQuery jobs

  * Editable: Automatically add additional rows and columns when pasting data larger than the current table

  * Excel files: When selecting sheets by a pattern, matching sheets are now displayed

  * CSV: Fixed possible issue reading some CSV files

  * Snowflake: Fixed fast-path from cloud storage with date-partitioned datasets but non-date partitioning column

  * Snowflake: Fixed “Parse SQL dates as DSS date” setting not taken into account for Snowflake

  * Snowflake: Fixed issue with sync from non-SQL datasets with Spark engine

  * Prevented renaming datasets with the same name as a streaming endpoint

  * Fixed renaming datasets when only changing the case (from “DS1” to “ds1” for example)




#### Recipes

  * Generate features: Fixed failure when input dataset contains column names longer than what the output database can accept (the limit is 59 characters on PostgreSQL for example).

  * Split: Fixed adding a second input before selecting the output during creation




#### Data Catalog

  * Added ability to add multiple datasets to a Data Collection (either from the Flow or from a Data Collection)




#### Machine Learning

  * **New feature** : Causal Prediction now supports multiple treatments

  * **New feature** : Model comparisons now allow comparing feature importance between models

  * Fixed failure to compute the feature importance of a model would cause the whole training to fail

  * Fixed failure to compute partial dependencies on features with a single value

  * Fixed missing option to use a Custom model in clustering model design settings

  * Fixed scoring of a model with Overrides using the Spark engine

  * Fixed missing dashboard model insight/tile option to show the Hyperparameter optimization report

  * Fixed incorrect aggregate computation of cost-matrix gain when using kfold cross-validation

  * Fixed possible hang of DSS when computing interactive scoring (What-if)

  * Fixed automatic selection of the code environment that could sometimes suggest an incompatible environment when creating a new modeling task




#### MLOps

  * When exporting a model to the MLflow format, add its required packages to the requirements.txt

  * In evaluation recipes, added ability to skip rescoring and use the prediction if provided in the evaluation dataset.

  * When computing univariate drift, better deal with missing categories by showing a very high PSI rather than having an infinite/missing value

  * With the public API, added ability to create custom model evaluation with arbitrary metrics.

  * Scoring recipes can now compute explanations for MLflow models

  * A model can now be deployed with the GUI from an Experiment Tracking run without being evaluated

  * Non classification/regression models can now be deployed with the GUI from an Experiment Tracking run

  * Monitoring wizard: only suggest the deployments that are relevant for the current project




#### Statistics

  * Added support for the FDR Benjamini-Hochberg method for p-values adjustment on the pairwise t-test and pairwise Mood test




#### Charts

  * **New feature** : Added ability to copy charts from one dataset to another

  * **New feature** : Added ability to customize tick marks

  * Scatter: Added ability to configure number of displayed records

  * Scatter: Various zoom and pan improvements

  * Scatter: Zoom and pan can now be persisted

  * Scatter: Fixed issues when there are too many colors

  * Bar charts: Improved color contrast for displayed values

  * Pivot table: Added ability to customize font size and color

  * Pie/Donut: Added option to position “others” group at the end

  * Treemap: Fixed tooltip color indicator

  * Added reset buttons for axis customization options

  * Improved zoom buttons on relevant charts (Treemap/Geometry/Grid/Scatter/Administrative filled/Administrative bubbles/Density Maps)

  * Added digit grouping formatting options

  * Fixed measure formatting update on tooltip

  * Fixed display formula for regression line

  * Increased precision for pivot table and maps tooltips

  * Improved legends display performance with many items

  * Fixed number formatting for reference lines on vertical bar and scatter charts




#### Workspaces and dashboards

  * Improved view/edit navigation on dashboards

  * Improved behavior of date range filter on dashboard

  * Fixed deletion of dashboard filters

  * Fixed dashboard export on air-gapped DSS instances

  * Added ability for users to override the name of workspace objects

  * Improved display of empty workspaces

  * Persist sort during a session on datasets




#### Coding

  * **New feature** : Added the ability to edit Jupyter notebooks in Visual Studio Code or JupyterLab via Code Studios

  * Project libraries: Added History tab to track, compare and revert changes.

  * Code Studios: automatically recover in case of network issues

  * Added ability to use the dataikuscoring library in the Python processor of the prepare recipe

  * Fixed ability to run a Python or R recipe from a SQL query dataset

  * Upgraded the builtin version of Visual Studio Code in Code Studios to 4.13

  * Fixed issues with uploading Jupyter notebooks from Databricks or Jupyter notebooks that do not specify a kernel

  * Code Studios: Fixed issue with Unicode characters in project libraries

  * Code Studios: Fixed ability to us Jupyter support in Visual Studio Code




#### Labeling

  * Input records with invalid or empty identifier / path / text are now ignored




#### Collaboration & Onboarding

  * Home page: Fixed clicking on a project folder - after scrolling - opens the wrong folder

  * Project activity > Contributors: Fixed error occurring on projects with a very large number of contributions

  * Help center: Added tutorials with progress tracking in Help > Educational Content > Onboarding

  * Project Version control: Added ability to create a tag from a commit

  * Project Version control: Added ability to push & pull tags when using a remote git repository

  * Project Version control: Fixed error happening during force commit not displayed




#### API Deployer

  * Pre-build required code environments during image build when deploying on a Kubernetes cluster, to speed up actual deployment

  * Added ability to add a commit and a tag when a bundle is created

  * Added an option to trust all certificates for infrastructures of static API nodes

  * Added support for variables for the specification of “New service id” in the “Create API service version” scenario step

  * Fixed running test queries on multi-endpoint API services




#### Project Deployer & Bundles

  * Added ability to add a commit and a tag when an API Service package is created

  * Better deal with bundle including a Saved Model with no active version: warn on pre-activation and activation and have a clearer exception when using the Saved model

  * Static insights can now be included in bundles




#### Scenarios

  * Do not clear retry settings when disabling/enabling a scenario step

  * Added a new mail channel to send emails using Microsoft365 with OAuth.




#### Govern

  * Added new artifact admin permission that grants all permissions for a specific artifact

  * Added the ability to export an item and its content (workflow state, field values) to CSV or PDF files

  * Governed Project’s Kanban view now also includes projects using custom templates

  * Added the ability to add a project directly from a business initiative page

  * Fixed display issue with very long Blueprint name in the Blueprint Designer

  * Fixed standard deviation display issue on Model version metrics

  * Fixed display issue for field of type number and value 0

  * Improved the performances of some queries




#### Cloud Stacks

  * Fixed display issue of the “Please wait, your Dataiku DSS instance is getting ready” screen

  * Fixed missing display of some errors in Fleet Manager

  * Added warning when trying to set a too small data volume

  * Moved some temporary folders to the data volume to avoid filling the OS volume

  * Fixed default value for IOPS on EBS

  * Fixed issues making the Save button unavailable




#### Elastic AI

  * Fixed ability to create a SparkSQL recipe based on a SQL query dataset (it however remains a very bad idea)

  * Simplified interaction with Kubernetes for containerized execution: Kubernetes Jobs are not used anymore. DSS now creates pods directly

  * Added display of DSS user / project / … to Cluster Monitoring screens

  * GKE: Improved error message when gcloud does not have authentication credentials

  * GKE: Improved handling of pod and service IP ranges

  * GKE: Added support for spot VMs

  * Added support for using a proxy for building the API deployer base image with R enabled




#### Streaming

  * Fixed default code sample for Spark Scala Streaming recipe

  * Fixed default code sample for Python streaming recipe

  * Added ability to perform regular reads of datasets in a Spark Scala Streaming recipe

  * Fixed read of array subfields in Kafka+Avro

  * Fixed issue with using “recursive build downstream” in flow branches containing streaming recipes




#### Performance and scalability

  * Improved performance for listing jobs

  * Improved IO performance for starting up jobs

  * Improved memory usage

  * Fixed possible hang when creating an editable dataset from a large existing dataset




#### Security

  * Fixed credentials appearing in the logs when using Cloud-to-database fast paths

  * OpenID login: added ability to configure the “prompt” parameter of OpenID

  * User provisioning: clarified how group profile mappings are applied

  * Azure AD integration: Fixed support for users having more than 20 groups

  * OAuth2 authentication on API node: added configurable timeout for fetching the JWKs

  * Jupyter notebooks trust system is now on a per-user basis




#### Misc

  * Added settable random seed for pseudo random sampling methods, allowing for reproducible sampling.

  * Fixed display issue with “Use global proxy” setting in connection getting wrongfully reset

  * Analyses: Fixed adding or removing tags from the right panel

  * Improved display of code env usage in code env settings

  * Fixed cases where building a code env could silently fail

  * Fixed possible failure aborting a job

  * Fixed issue with displaying large RMarkdown reports

  * Fixed possible error in Jupyter

  * Fixed possible UNIX user race condition when starting a large number of webapps at once

  * `dataiku.api_client()` is now available from within exporter and fs-provider plugin components




## Version 12.1.3 - August 17th, 2023

DSS 12.1.3 is a security, performance and bugfix release

### Machine Learning

  * Fixed UI issue in model assertions

  * Fixed partial dependencies failure with sample weights

  * Fixed computation of partial dependencies when rows are dropped by processing




### MLOps

  * Fixed possible failure to display model results for imported MLflow models built from recent scikit-learn versions

  * Fixed display of model results for imported MLflow models for which performance was not evaluated

  * Fixed display of API endpoint URL in API deployer

  * Fixed ability to deploy MLflow models that are not tabular classification nor regression

  * Fixed Python requirements for exported MLflow models




### Govern

  * Fixed validation error when custom templates have been deployed and standard ones have been archived




### Dashboards

  * Fixed filter on “no value” when downloading dataset data from dashboards




### Cloud Stacks

  * Fixed issue with authentication when upgrading Fleet Manager directly from 10 to 12.1




### Performance

  * Improved performance for reading records with dates from Snowflake

  * Fixed potential slow query and failure on the “Automation monitoring” page

  * Fixed flooding of logs with bad data in Excel export




### Security

  * Added more sensitive information removal from support diagnostic archives

  * Fixed [Improper link resolution before file access](<../security/advisories/dsa-2023-007.html>)

  * Fixed [Improper privilege enforcement on project import](<../security/advisories/dsa-2023-008.html>)




### Misc

  * Added the ability to embed Dataiku in another website through setting “SameSite=None” for cookies

  * Fixed Databricks sync to Azure/S3 with pass-through credentials when Unity Catalog is disabled

  * Fixed issues with display of list of scenarios in some upgrade situations

  * Fixed minor display issue in Wiki taxonomy tree

  * Fixed display of Flow in jobs page with big flows




## Version 12.1.2 - July 31st, 2023

DSS 12.1.2 is a security, performance and bugfix release

### Datasets

  * Explore: Fixed filtering of Decimal columns with “text facet” filtering mode

  * Editable dataset: increased display density

  * Editable dataset: fixed bad interaction with the Tab key

  * Editable dataset: improved column edition and autosizing experience

  * Editable dataset: fixed bad interaction with keyboard shortcuts while editing a column

  * Snowflake: Strongly improved performance of verifying table existence and importing tables

  * Presto/Trino: Strongly improved performance of verifying table existence and importing tables

  * Databricks: Fixed wrongful cleanup of temporary tables for auto-fast-write




### Recipes

  * Prepare: Fixed a case where the formula parser would wrongfully ignore invalid formula and only execute parts of the formula

  * Prepare: removed a wrongful warning regarding dates with SQL engine

  * Prepare: fixed wrongful data loss when using “if then else” to write into an existing column with SQL engine

  * Prepare: fixed number of steps appearing in the description in the right panel of the recipe

  * Window: Fixed pre-computed columns when “always retrieve all” is selected and Spark engine is used

  * Windows: Fixed display when “always retrieve all” is selected




### Machine Learning

  * Removed ability to export train set if datasets export is disabled

  * Fixed wrongful binary classification threshold in evaluation recipe

  * Fixed wrongful fugacity matrix not taking threshold into account in drift evaluation

  * Fixed precision-recall curve with Python 2.7

  * Fixed what-if when a feature is empty and selected to “drop row if empty”

  * Fixed SQL scoring on BigQuery




### Labeling

  * Object detection: fixed an issue when a single image has more than 5 labels




### Dashboards and workspaces

  * Fixed display of Dataiku applications viewed through a workspace




### Webapps

  * Fixed ability to retrieve headers for Bokeh 2




### Dataiku Govern

  * Fixed improper status computation on the review step when there are unvalidated signoffs in the following steps

  * Fixed display of SSO settings




### Elastic AI

  * Fixed ability to run Spark History Server behind a reverse proxy




### Cloud Stacks

  * Fixed issues saving forms in the Fleet Manager UI

  * Pre-create the “cpu/DSS” cgroup to make it easier to control CPU through cgroups

  * Increased too low system limits on some components




### Performance and scalability

  * Fixed performance issue when renaming datasets on extremely large instances

  * Fixed possible instance crash when using the “compute ngrams” prepare processor with extremely large number of ngrams

  * Improved performance of the “Automation monitoring” page




### Miscellaneous

  * Remove extra whitespaces in logging remapping rules to avoid hard-to-investigate issues




## Version 12.1.1 - July 19th, 2023

DSS 12.1.1 is a security, performance and bugfix release

### Statistics

  * Fixed STL decomposition analysis when resampling is disabled




### Machine Learning

  * Fixed charts on predicted data when a date filter is set




### Performance and Scalability

  * Fixed performance issue when switching from recipe to notebook, when the recipe code contains lot of spaces

  * Fixed issue with notebooks startup when kernel takes too long to start




### Security

  * Fixed [Insufficient access control on active web content via static insights](<../security/advisories/dsa-2023-006.html>)




## Version 12.1.0 - June 29th, 2023

DSS 12.1.0 is a significant new release with both new features, performance enhancements and bugfixes.

### New features and enhancements

#### Dataset preview on the Flow

You can now preview the content of datasets directly from the Flow. Simply click on “Preview”.

#### Databricks Connect

Support for Databricks Connect was added in Python recipes.

It is now possible to push down Pyspark code to Databricks clusters using a Databricks connection.

#### More charts customization and features

Many new capabilities and customization options were added to charts and dashboards

  * Added the ability to set the position of the legend of charts on dashboard

  * Added the ability to customize font size and colors for values, legend items, reference lines, axis labels and axis values

  * Added “relative date range” filters for charts and dashboards (“last week”, “this year”, …)

  * Added ability to force displayed values to overlap

  * Bar charts: Added reference lines (horizontal lines)

  * Scatter plots: Added reference lines (horizontal lines)

  * Scatter plots: Added regression lines

  * Scatter plots: Added zoom and pan




#### New join types

The join recipe now supports 2 new types of joins:

  * Left anti join: keep rows of the left dataset without a match from the right

  * Right anti join: keep rows of the right dataset without a match from the left




#### Text Labeling

In addition to image classes and object bounding boxes, Dataiku managed labeling can now label text spans in text fields.

#### Visual Time series decomposition

Visual Statistics now includes visual STL time series decomposition (trend and seasonality)

#### New editable dataset UI

A new UI for the “editable” dataset adds many new capabilities:

  * Easier resizing of columns

  * Auto-sizing of columns

  * Click-and-drag to fill

  * Ability to add several rows and columns at once

  * Ability to reorder & pin columns with drag-and-drop

  * Fixed various issues with undo/redo

  * Added warning when attempting concurrent edition




#### Excel sheet selection enhancements

Excel files sheet selection was revamped. It is now possible to select sheets manually or via rules based on their names or indexes, or to always select all sheets.

In addition, it is now possible to add a column containing the source sheet name.

#### Enhanced user management capabilities

  * Added the ability to automatically provision users at login time from their SSO identity

  * Added Azure AD integration to provision and sync users

  * Added the ability to explicitly resync users (either from the UI or from the API) from their LDAP or Azure AD identity

  * Added the ability to browse LDAP and Azure AD directories to provision users from their LDAP or Azure AD identity at will (without them having to login first)

  * Added the ability to define and use custom authentication and provisioning mechanisms




### Other enhancements and fixes

#### Machine learning

  * **New feature** : Added a Precision-Recall curve to classification model reports, as well as Average-Precision metric approximating the area under this curve

  * Added support of ML Overrides to Model Documentation Generation

  * Added indicators in What-if when a prediction was overridden

  * Now showing preprocessed features in model reports even when K-fold cross test was enabled on this model

  * Added option to export the data underlying Shapley feature importance

  * Sped up training of partitioned models

  * Added a “model training diagnosis” in Lab model trainings, to download information needed for troubleshooting technical issues

  * Fixed reproducibility of Ridge regression models

  * Fixed the computation of the multiclass ROC AUC metric in the rare case of a validation set with only 2 classes

  * Fixed a possible scoring failure of ensemble models on the API node

  * Fixed overridden threshold of binary classification model when scoring with Spark, Snowflake (with Java UDF) or SQL engines

  * Fixed a failure when an evaluation recipe was run on a spark-based model with either only a metrics output or only a scored output dataset

  * Fixed a failure to score time-based partitioned models using the python (original) backend when the partitioning column is a date or timestamp

  * Fixed a scoring failure when using time-based partitioning on year only

  * Fixed inability to delete an analysis containing a Keras / Tensorflow model

  * Fixed a condition where an erroneous user-defined metric would cause the whole training to fail

  * Fixed training failure caused by incorrect stratification of stratified group k-fold with some datasets

  * Fixed a possible hang of a containerized train when the training data is very large

  * Fixed broken Design page for modeling tasks in some rare cases

  * Fixed MLlib clustering with outlier detections




#### Time series forecasting

  * **New feature** : Added Model Documentation Generation for forecasting models

  * Added experimental support for forecasting models with more than 20000 series

  * Added option to sample the first N records sorted by a given column

  * Added ML diagnostics to the evaluation & scoring recipes, warning instead of failing when a time series is too short to be evaluated or resampled, or when a new series was not * seen at train time by a statistical model

  * Added an option in multi-series forecasting models to ignore time series that are too short

  * Sped up the loading & display of multi-series forecasting models

  * Set the default thread count of forecasting models hyperparameter search to 1, to ensure full reproducibility

  * Fixed distributed hyperparameter search of time series forecasting models

  * Fixed evaluation recipe schema recomputation always using the saved model’s active version even when overridden in the recipe

  * Fixed failure when the time column contains timezone and using recent version of pandas

  * Fixed a training failure when some modalities of a categorical external feature are present in the test set but not in the train set

  * Fixed a failing train of multi-series models when an identifier column contains special characters in its name

  * Fixed a training failure when using Prophet with the growth parameter set to “logistic”




#### Computer Vision

  * Added support for log loss metric in Image Classification tasks

  * Added ability to publish a Computer Vision model’s What-If page to a Dashboard

  * Fixed a possible failure when coming back to the What-If screen of Computer Vision models after visiting another page

  * Fixed a possible training failure when Computer Vision models are trained in containers

  * Fixed incorrect learning rate scheduling on Computer Vision model trainings




#### Charts & Dashboards

  * Fixed dashboard export with filter tile

  * Fixed dashboard, on opening dataset insights appear unfiltered for a short moment

  * Stacked bars chart: Added ability to remove totals when “displaying value”

  * Bars: Fixed Excel export

  * Horizontal bars: Fixed X axis disappearing

  * Line charts: Fixed axis scale update on line charts

  * Pivot table: remove “value” column if only one measure is displayed

  * Scatter plots: Made maximum number of displayed points configurable

  * Maps: Fixed display of legends with “in chart” option

  * Boxplots: Fixed chart display when the minimum is equal to zero

  * Boxplots: Fixed display of min and max as we allow possibility to set manual range

  * Added reference lines in Excel export

  * Fixed excel export for charts with measures

  * Fixed “export insight as image” not displaying legend

  * Fixed tooltip display on each subchart

  * Improve empty state and wording for workspaces

  * Fixed issue with selecting text in chart configuration forms

  * Fixed thumbnail generation when using manual axis

  * Fixed discrepancy in filter behavior between DSS and SQL engines when data contains null values




#### Notebooks

  * Added “Search notebooks” to easily search within ElasticSearch datasets




#### Code Studios

  * Streamlit: Allowed changing the config.toml

  * Streamlit: Allowed to specify a code-env for Streamlit block, allowing to choose a custom Streamlit version

  * JupyterLab: Fixed block building failing on AlmaLinux

  * JupyterLab: Added warning when stopping Code Studio and some files have been written in JupyterLab’s root directory

  * JupyterLab: Fixed renaming folders whose names contain whitespaces in JupyterLab

  * Fixed unexpected visual behavior when clicking on a DSS link inside Code Studio while not authorized

  * Fixed wrongful display of old log messages

  * Fixed “popout the current tab” button not working under some circumstances

  * Set ownership of code-envs created with the “add code environment” block to dataiku user




#### Flow

  * Added “stop at flow zone boundary” option when building multiple datasets at once.

  * Fixed incorrect layout when a metrics dataset or a cycle is present in a flow zone

  * Fixed unbuilt datasets appearing as built after a change in an upstream recipe caused theirs schemas to be updated

  * Fixed zone coloring when doing rectangular selection on the Flow

  * Added support for “metrics” dataset when doing schema propagation

  * Fixed “copy subflow to another project” failing when quick sharing is enabled on the first element

  * Fixed “Drop data” option for “Change connection” action

  * Fixed update of code recipes when renaming a dataset while copying a subflow




#### Datasets

  * Fixed leftover file when deleting an editable dataset without checking drop data

  * Added support for direct read of JSON files from Spark

  * Fixed dataset explore view not behaving correctly if the last column is named “constructor”

  * Added support for “_source” keyword in Custom Query DSL for ElasticSearch datasets

  * Added support for Azure Blob to Synapse fast path when network restriction is enabled on the Azure Blob storage account

  * Do not propose “Append instead of overwrite” for Parquet datasets, as it’s not supported

  * Improved error reporting for various cases of invalidly-configured datasets

  * Fixed BigQuery auto-write fast path with non-string partitioning columns

  * Added support for S3/Redshift fast path when using STS tokens




#### Recipes

  * **New feature** : Generate features: now supports Spark engine

  * **New feature** : Added recipe summary in right panel for sample/filter, group, join and stack recipes

  * Prepare: Fixed “concat” processor on Synapse

  * Prepare: Fixed preview of Formula editor not showing anything when the formula generates null values for all input values in the sample

  * Prepare: Fixed a possible timeshift with input Snowflake datasets contain columns of type “date”.

  * Prepare: Fixed possible error when moving preparation steps when input dataset is SQL

  * Prepare: Fixed possible incorrect engine selection when input dataset is SQL

  * Prepare: Added SQL engine support for “Concatenate columns” steps on Synapse datasets.

  * Prepare: Fixed wrongful change tracking for changes made on columns that have just been added by a processor

  * Prepare: Fixed wrongful “Save” indicator whereas recipe was already saved

  * Prepare: Disable Spark engine when “Enrich with context information” processor is used

  * Prepare: Fixed saving of output schema with complex types with detailed definition

  * Group and window: Fixed using an aggregation on a column that doesn’t exist in the input of a Group or Window recipe yields an unexpected error.

  * Fuzzy Join: fixed wrongful “metadata” output when using multiple join conditions

  * Window: Added “Retrieve all” checkbox to automatically retrieve all columns in the input dataset. This option is checked by default for all newly created recipes.

  * Sync: Fixed possible timeshift when input Databricks datasets contain columns of type date.

  * Sync: Fixed redispatching partitions with both a discrete and a time-based dimension

  * Sync: Fixed computing of metrics on output dataset with partition redispatch

  * Pivot: Fixed issue with BigQuery geography columns

  * Join: Fixed “match on nearest date” on Synapse




#### Data collections

  * Improved loading time of the various screens

  * Fixed filters being reset when refreshing data collection page




#### Labeling

  * **New feature** : Added ability to specify additional columns to be displayed next to the image or text being annotated

  * **New feature** : Added ability for reviewers to reject an annotated item and send it back for annotation

  * Fixed inability to delete a Labeling Task’s data when its input dataset is shared from another project




#### Jobs

  * **New feature** : Job view now displays Flow with Flow zones

  * Fixed clicking on a Job activity for a dataset that has been deleted

  * Fixed blank flow in Jobs screen on some large flows

  * Fixed Job failure incorrectly reported when building datasets with option “Stop at zone boundary” and a dependency located outside the flow zone is not built.

  * Fixed “there was nothing to do” displayed while job is still computing dependencies




#### Webapps

  * Webapps do not auto-start anymore at creation




#### Scenarios

  * Added “stop at flow zone boundary” option.

  * Fixed unexpected error generated when a scenario “Run checks” step references a non-existing dataset.




#### MLOps

  * Added support for MLflow 2.3

  * Added support for Transformers, LangChain and LLM flavors of MLflow

  * Added support of MLflow model outputs as lists

  * Added a project macro to delete model evaluations.

  * Create metrics and checks datasets in the same flow zone as the object they relate to.

  * Added the ability to define a seed in the evaluation recipes when using random sampling

  * In the standalone evaluation recipe, ease the setup of classes when there are many by allowing to copy / paste them.

  * Fixed Python 2.7 encoding issues in the evaluation recipe when dealing with non-ASCII characters

  * Fixed support of MLflow models returning non-numeric results

  * Ease the setup of the standalone evaluation recipe for pure data drift monitoring (prediction column is now optional)

  * Fixed incorrect handling of forced threshold in a proba-aware, perfless standalone evaluation recipe

  * Fixed the computation of the confusion matrix with Python 3.7

  * Avoid creating a Saved Model when errors occur during the deployment of a model from an experiment tracking run.

  * Fixed the creation of API service endpoint from a MLflow imported model with prediction type “Other”

  * Fixed the import of a new Saved Model Version into an existing Saved model from a model from an experiment tracking run with prediction type “Other”.

  * Fixed an issue preventing the import of new MLflow model versions into an existing Saved Model from a plugin recipe.

  * Fixed import of projects exported with experiment tracking




#### Deployer

  * **New feature** : Added the ability to publish a bundle to the deployer without being project admin

  * Added historization and display of deployments logs in project and API deployers

  * Added autocompletion on connection remappings in deployments and deployer infrastructure settings

  * Added infrastructure status for the API node in API deployer

  * Prevent the creation of two bundles with the same name

  * Fixed the setup of permissions of deployer related folders when installing impersonation

  * Enhanced the ability of deployments to customize parts of the exposition settings of the infrastructure




#### Dataiku Govern

  * **New feature** : Improved the graphical structure of artifact pages and the way fields are displayed within it

  * **New feature** : Added the custom metrics in the Model Registry

  * **New feature** : Added the ability to filter on multiple business initiatives

  * **New feature** : Added the possibility to set a reference from a back reference field

  * Explicitly labeled default governance templates as “Dataiku Standard”

  * Improved the creation of items inside tables (do not propose already selected items, redirect back to the table after item creation).

  * More explicit message for object deletion

  * Simplified breadcrumb on object pages, it’s now only based on object hierarchy and not on navigation history anymore.

  * Fixed an issue with the selection of a Business Initiative at govern time when the govern template doesn’t have a Business Initiative

  * In all custom pages, by default, prevented the display of archived objects and added a checkbox to display them

  * Forbid the usage of an archive blueprint version when governing an object or creating a new one (Note: “auto” governance doesn’t take archived blueprint versions into account anymore either)

  * More explicit button labels for blueprint version activation and archiving

  * Fixed a refresh issue on the object breadcrumb when updating the object’s parent

  * Fixed an issue on deployment update when the govern API key is missing from the deployer’s settings

  * Fixed the application of the node size selected during installation

  * Fixed filters not being taken into account when mass selecting users in the administration menu

  * Various small UI enhancements




#### Elastic AI

  * Clusters monitoring: added CPU and memory usage information on nodes

  * Clusters monitoring: improved sorting

  * AKS: Added support for selecting subscription when using managed identity

  * AKS: Added support for deleting nodegroups

  * EKS: Fixed failures with some specific kubectl binaries

  * EKS: Wait for nodegroup to be deleted before giving back control, when resizing it to 0

  * EKS: Fixed “test network” macro

  * Fixed invalid labels that could be generated with some exotic project keys




#### Cloud Stacks

  * Added ability to resize root disk on Azure

  * Fixed handling of “sshv2” format for SSH keys

  * Added ability to enable assignment of public IP in subnets created with the network template

  * Added ability to retrieve Fleet Manager SSL certificate from Cloud’s secret manager.




#### Performance & Stability

  * Major performance enhancements on handling of datasets with double or date columns, especially when using CSV. Performance for reading datasets in Python recipes and notebooks can be increased by up to 50%

  * Added safety limits to CSV parsing, to avoid cases where broken or misconfigured CSV escaping can cause a job to fail or hang

  * Added safety limit on the number of garbage collection threads to DSS job processes and Spark processes, to limit the risk of runaway garbage collection overconsuming CPU

  * Added safety limit on filesystem and cloud storage enumerations to avoid crashes when enumerating folders containing dozens of millions of files

  * Fixed possible crash when computing extreme number of metrics (such as when performing analysis on all columns on all data with thousands of columns)

  * Performance enhancement when custom policy hooks (such as GDPR or Connections/Projects restrictions) are in use

  * Fixed possible instance hanging when a lot of job activities are running concurrently

  * Fixed possible instance slowdown when a custom filesystem provider / plugin uses partitioning variables

  * The startup phase of a new Jupyter notebook kernel will not cause pauses for other notebooks running at the same time anymore




#### Code envs

  * Made dsscli command to rebuild code envs more robust on automation node

  * Fixed ability to use manually uploaded code env resources without a script




#### Plugins

  * Fixed “run as local process” flag on plugin webapps

  * Fixed code environment of some plugins failing to install when using conda




#### Misc

  * **New feature** : DSS administrators can now display messages to DSS end users in their browser to alert them of some imminent event.

  * Fixed a bug where some deleted project library files would remain loaded after reloading a notebook

  * Fixed RFC822 date parsing with non-US locale

  * Fixed link to managed folders located in a different project from the global search page

  * Renamed “Drop pipeline views” macro to “Drop DSS internal views” macro as it can also be used to drop views created by the Generate features recipe.

  * Added back the ability for users to choose - in their profile page - whether they receive notifications when other run jobs/scenarios/ML tasks.

  * Projects API: New projects are now created with the new permission scheme introduced in DSS 10

  * Fixed deletion of foreign datasets in a project incorrectly warning that recipes associated with the original dataset in the source project would be deleted.

  * Fixed sort of dataset by size/records in datasets list view

  * Fixed listing Jupyter notebooks from git when some .ipynb files are invalid

  * Fixed dataset metrics/checks computed using Python probes considered as valid even in case an exception is raised from the code

  * Improved search for wiki articles with words in camel case (Searching for “MachineLe” would not return articles containing “machine learning”)

  * Formula: Some invalid expressions are no longer accepted and now can yield errors. Some of these invalid expressions were previously incorrectly considered as valid and accepted. An example of such an * expression is “Age * 10 (-#invalid”. It is invalid yet was previously accepted and evaluated as “Age * 10”.

  * Streaming: Fixed various issues with containerized continuous Python recipe

  * Fixed deletion of secrets from connection settings

  * Fixed wrongful caching of Git repositories with experimental caching modes




## Version 12.0.1 - June 23rd, 2023

DSS 12.0.1 is a security, performance and bugfix release

### Datasets

  * Fixed format preview when creating dataset from folder with XML files

  * Fixed error when reading a Snowflake dataset with a DATE column containing nulls




### Streaming

  * Fixed continuous Python recipe in function mode when dataframe is empty




### Machine Learning

  * Fixed scoring recipe when the treatment column is missing in the input dataset

  * Cloudstack: Fixed usage of Snowflake UDF in scoring recipe




### Spark

  * Fixed support of INT type with parquet files in Spark 3




### Notebooks

  * Fixed notebooks export when DSS Python base env is Python 3.7 or Python 3.9




### Performance

  * Fixed run comparison charts of experiment tracking when there are > 100k steps (11.4.4)




### API

  * Allowed read-only user to retrieve through the REST API, the metadata of a project they have access (11.4.4)




### Security

  * Fixed [Aborting scenarios with read-only permission on the project](<../security/advisories/dsa-2023-026.html>) (11.4.4)




## Version 12.0.0 - May 26th, 2023

DSS 12.0.0 is a major upgrade to DSS with major new features.

### Major new features

#### Machine Learning overrides

ML models today can achieve very high levels of performance and reliability but unfortunately this is not the general case, and often, they cannot be fully trusted for critical processes. There are many known reasons for this, including overfitting, incomplete training data, outdated models, differences between testing environment and real world…

Model overrides allow you to add an extra layer of human control over the models’ predictions, to ensure that they:

  * don’t predict outlandish values on critical systems,

  * comply with regulations,

  * enforce ethical boundaries.




By defining Overrides, you ensure that the model behaves in an expected manner under specific conditions.

Please see [Prediction Overrides](<../machine-learning/supervised/prediction-overrides.html>) for more details.

#### Universal Feature Importance

While some models are interpretable by design, many advanced algorithms appear as black boxes to decision-makers or even data scientists themselves. The new model-agnostic global feature importance capabilities helps you:

  * explain models that could not be explained until now

  * explain models in an agnostic, comparable way (rather than only using algorithm specific methods)

  * aggregate importance across categories of a single column

  * assess relative direction (in addition to magnitude of importance)




This new feature extends and enhances the existing feature importance and individual explanation capabilities. It is fully based on Shapley values and enriched with state-of-the-art visualisation

This capability is even available for MLflow models imported into DSS.

#### Causal Prediction

The most common Data Science projects in Machine Learning involve predicting outcomes. However, in many cases, the focus shifts towards optimizing outcomes based on actionable variables rather than just predicting them. For example, you may desire to improve business results by identifying customers who will respond best to certain actions, rather than simply predicting which customers will churn.

Traditional prediction models are built with the assumption that their predictions will remain valid when actionable variables are manipulated. However, this assumption is often false, as there can be various reasons why acting on an actionable variable doesn’t have the expected outcome. For example, acting on one variable may have unforeseen consequences on other variables, or the distribution of the actionable variable may be unevenly distributed in the population, making it difficult to compare individuals with different values of the variable.

To address these challenges, the field of Causal Machine Learning (Causal ML) has emerged, incorporating econometric techniques into the Data Science toolbox. In Causal ML, a Data Scientist selects a treatment variable (such as a discount or an ad) and a control value to tag rows where the treatment was not received. Causal ML then performs additional steps to identify individuals who are likely to benefit the most from the treatment. This information can then be used for treatment allocation optimization, such as determining which customers are expected to respond most positively to a discount.

The Causal Prediction analysis available in the Lab provides a ready-to-use solution for training Causal models and using them to predict the effects of actionable variables, optimize interventions, and improve business outcomes.

Please see [Causal Prediction](<../machine-learning/causal-prediction/index.html>) for more details.

#### Auto feature generation

The new “Generate Features” recipe makes it easy to enrich a dataset with new columns in order to improve the results of machine learning and analytics projects. You can define relationships between datasets in your project.

DSS will then automatically join, transform, and aggregate this data, ultimately creating new features.

Please see [Generate features](<../other_recipes/generate-features.html>) for more details.

#### Data Collections and Data Catalog

Data collections allow you to gather key datasets by team or use case, so that users can easily find and share quality datasets to use in their projects.

Data Collections, Data Sources search and Connections explorer now live together as the new Data Catalog in DSS.

#### Run subsequent recipes and on-the-fly schema propagation

For all intermediate recipes in a flow, when you click “run” from within the recipe, you now have an option to either:

  * Run just that recipe

  * Or run that recipe and all subsequent ones in the Flow, with the effect of making the whole “downstream” branch of the Flow up-to-date.




“Run this recipe and all subsequent ones” also applies schema changes on the fly to the output datasets, until the end of the Flow

It is now also possible, from the Flow, to build “downstream” (from left to right) all datasets that are after a given starting point. This also includes the ability to perform on-the-fly schema propagation

#### Help Center

Dataiku now includes a brand new integrated Help Center that provides comprehensive support, including a searchable database, onboarding materials, and step-by-step tutorials. It offers contextually relevant information based on the page you’re viewing, aiding in feature discovery and keeping you updated with the latest additions.

This Help Center serves as a one-stop solution for all user needs, ensuring a seamless and efficient user experience.

### Other notable enhancements and features

#### Build Flow Zones

It is now possible to build an entire Flow zone. This builds all “final” datasets of this zone, and does not go beyond the boundary of the zone.

#### Deployer permissions management upgrades

When deploying projects from the Deployer, it is now possible to choose the “Run as” user for scenarios and webapps in the deployed project on the automation node. This change can only be performed by the infrastructure administrator on the Deployer.

In addition, the infrastructure administrator on the Deployer can also configure:

  * Under which identity projects are deployed to the automation node

  * Whether to propagate the permissions from the project in the design node to the automation node




#### Engine selection enhancements

Various enhancements were made to engine selection, so that users need to care much less often about which engines to select. In the vast majority of cases, we recommend that auto selection of engine is left to DSS, without manually selecting engines, or without setting prefered or forbidden engines.

The most notable changes are:

  * Automatically select SQL engine for prepare recipes when possible and efficient (i.e. when both input and output are the same database)

  * Do not automatically select Spark engine when it will for sure be inefficient (when the input or output cannot use fast Spark access)




#### Prophet algorithm for Time Series Forecasting

Visual Time Series Forecasting now includes the popular Prophet algorithm.

#### API service monitoring wizard

A new wizard makes it much easier to setup a full API service monitoring loop that gathers the query logs from the API nodes in order to automate drift computation.

#### Govern: Management of deployments

Added the synchronization of deployments and infrastructure information from the deployer node into the govern node, providing more information in the Model and Bundle registries about how and where those objects are used.

#### Govern: Kanban View

A new Kanban view allows you to easily get a view of all your governed projects

#### Charts: Reference lines

It is now possible to define horizontal horizontal lines on Line charts and Mixed charts

#### Request plugin installation

Users who are not admin can now request installation of a plugin from the plugin store. The request is then sent to administrators, and the user is notified when the request is processed.

#### Request code env setup

Users who do not have the permission to create code envs can now request the setup of a code env from the code envs list. The request is then sent to administrators, and the user is notified when the request is processed.

#### Model Document Generation for imported MLflow models

The automatic Model Document Generator now supports MLflow imported models.

### Other enhancements and fixes

#### Datasets

  * Added settings to enable the Image View for a dataset as the default view

  * Added time part in addition to the date in Last modification column in folders content listing

  * Fixed “copy row as JSON” on filtered datasets

  * Explore: Fixed issue when using relative range and alphanum values filters together

  * Fixed “Edit” tab incorrectly displayed on shared editable datasets

  * S3: increased the default max size for S3 created files to 100 GB

  * Snowflake: Added support for custom JDBC properties when using the Spark-Snowflake connector

  * Snowflake: Fixed timezone issues on fields of type DATE when parsed as a DSS date

  * Snowflake: Added support for privatekey in advanced JDBC properties when using Snowpark

  * BigQuery: Fixed internal error happening if user has access to 0 GCP projects

  * BigQuery: Fixed syncing of RECORD and JSON columns containing NULL values

  * BigQuery: Fixed missing error message when table listing is denied by BigQuery

  * BigQuery: Fixed date issues on Pivot, Sort and Split recipes




#### Visual recipes

  * Prepare: Stricter default behavior of column type inference at creation time. The columns types of strongly typed datasets (e.g. SQL, Parquet) are kept. Behavior can be changed in Administration > Settings > Misc.

  * Prepare: Improved summary section in the right panel to quickly assess what the recipe is doing.

  * Join: Added a new mode to automatically select columns if they do not cause name conflicts

  * Join: Fixed second dataset’s columns selection being reset when opening a recipe with a cross-join

  * Join: Fixed ability to define a Join recipe using as output dataset one of its input datasets

  * Pivot: Fixed empty screen for “Other columns” step displayed when switching tabs

  * Group: Fixed concat distinct option being disabled even for SQL databases that support it

  * Formula language: Fixed now() function in formula generating a result that cannot be compared to other dates using >, >=, < or <= operators.




#### Flow

  * Fixed running job icons in Flow not always correctly displayed

  * Fixed Flow zoom incorrectly reset when navigating between projects with and without zones




#### Visual Machine Learning

  * Added support for Python 3.8 and 3.9 to Visual Machine Learning, including Visual Time Series Forecasting and Computer Vision tasks.

  * Added support for Scikit-learn 1.0 and above for Visual Machine Learning. Note that existing models previously trained with scikit-learn below 1.0 and using the following algorithms need to be retrained when switching to scikit-learn 1.0 (which may happen if the DSS builtin env is upgraded to Python 3.7 or Python 3.9): KNN, SVM, Plugin algorithms, Custom Python algorithms

  * Updated the default versions of scikit-learn and scipy in the sets of packages for Visual Machine Learning for code environments

  * Added Sort & Filter to the Predicted Data tab

  * Added the Lift metric to the model results

  * Fixed Distance weighting parameter not taken into account when training KNN models

  * Fixed failure of clustering scoring recipe when the scored dataset lacks some features that were rejected

  * Removed redundant split computation during training

  * Fixed intermittent failures of Model Document Generator on some models

  * Fixed a rare situation where the Cost Matrix Gain metric would not display




#### Visual Time Series Forecasting

  * Added ML Diagnostics to TS Forecasting

  * Added a result page to show ARIMA orders

  * Added a new Mean Absolute Error (MAE) metric

  * Switched to Mean Absolute Scaled Error (MASE) as the default optimization metric. The previous default (MAPE) may lead to training failure when a series has only 0s as target values.

  * Improved display of various results for multiple-series models

  * Improved support of Month time unit, for periods ending on the last day of a month or spanning more than 12 months

  * More & more prominent warnings when a time series does not have enough (finite & well-defined) data points for forecasting

  * Fixed computation (and warning) of minimum required data points for external features in the scoring recipe

  * Fixed a bug where forecasting models trained in earlier DSS versions had their horizon changed to 0 when retrained

  * Fixed default value of low pass filter for Seasonal Trend when enabled and lower than the season length




#### Charts & Dashboards

  * **New feature** : Filters: Added ability to define filters with single selected value

  * **New feature** : Mix chart: Added line smoothing option

  * Line chart: Fixed tooltips not correctly triggered in subcharts other the first one

  * Line chart: Fixed axis minimum wrongly computed when switching to manual range

  * Scatter plot: Fixed axis and canvas not aligned if browser in zoomed mode

  * Scatter plot: Fixed tooltips not showing up for points where y=x

  * Treemap: Fixed treemap not rendered under certain circumstances on Firefox

  * Boxplot: Fixed sorting order

  * Filters: Fixed switching from date part to date range does not reset the date slider.

  * Filters: Fixed numeric slider displayed instead of checkboxes list when pasting an URL containing values for a numerical filter.

  * Filters: Fixed filter values not correctly displayed when using multiple date parts

  * Dashboards: Moved the fullscreen button outside the content area

  * Dashboards: Fixed “Play” button issuing an error on some dashboards

  * Fixed custom color assignations getting lost when changing the measures in the chart




#### Labeling

  * Added Undo/Redo when annotating images in a Labeling Task




#### Notebooks

  * Made Jupyter notebook export timeout configurable




#### Scenarios

  * **New feature** : Added the ability to define Cc and Bcc lists in scenario email reporters

  * Fixed timezone issue in the display of monthly triggers




#### Collaboration

  * Enabled emails toggles in user profile by default for new users

  * Fixed switching branch in a project that would cause the project to become inaccessible in case the git branch was badly initialized

  * Fixed hyperlinks toward DSS objects in wiki exports

  * Dataset sharing: Fixed unable to import a dataset from another project P if quick sharing is disabled on project P

  * Workspaces: Fixed public API disclosing permissions set on workspaces to users and contributors of the workspace.

  * Workspaces: Fixed error message wrongly displayed when a user with Reader profile publishes an object to a workspace

  * Workspaces: Fixed “Go to source dashboard” button incorrectly grayed out under some circumstances




#### Govern

  * Added the ability to customize the axis of the governed projects matrix view

  * Added the ability to configure a sign-off with only final review (no feedback groups)

  * Fixed the display of multiple governed projects at the same location in the matrix view

  * Fixed import/export of blueprints to remove user and group assignment rules in sign-off configuration

  * Fixed unselect action in the selection window for lists displayed as tables

  * Fixed an error happening when reordering attachment files

  * Fixed deduplication of items in list to only apply on reference fields

  * Added the possibility to set data drift as a “metric to focus on” in the model registry

  * Fixed the removal of items from tables

  * Fixed the redirection to home page in case of a custom page not found

  * Fixed governed saved model versions or bundles being created twice when governing directly from the object page




#### MLOps

  * **New feature** : Added an option in the Evaluation and Standalone Evaluation Recipes to disable the sub-sampling for drift computation (sub-sampling is enabled by default)

  * **New feature** : Added data drift p-value as an evaluation metric

  * **New feature** : Added the ability to track Lab models metrics as experiment tracking runs

  * In Deployer, added an option to bundle only the required model versions.

  * Fixed drift computation in evaluation recipe failing when using pandas 1.0+

  * Fixed evaluation of MLflow models on dataset with integer column with missing values

  * Improved the selection of metrics to display in a Model Evaluation Store

  * Added support for MLflow’s search_experiments API method

  * Fixed handling of integer columns in the Standalone Evaluation Recipe for binary classification use cases

  * Fixed some flow-related public API method when there is a model evaluation store in the flow

  * Fixed evaluation of MLflow models when there is a date column

  * Fixed empty versions list for MLflow models migrated from a previous version

  * In the Evaluation Recipe, added the ability to customize the handling of column in data drift computation

  * Enriched Model Evaluations with additional univariate data and prediction drift metrics (can also be retrieved through the API)




#### Coding

  * Improved commit messages generated when creating, editing, deleting files in folder in project libraries

  * Removed some useless empty commits when performing blank edits in project libraries




#### Plugins

  * Fixed several types of plugin components that did not work with Python 3.11




#### Performance & Scalability

  * Improved performance and responsiveness when DSS data dir IO is slow

  * Improved performance of starting jobs in projects involving shared datasets

  * Improved performance of validating very large SQL queries / scripts

  * Improved performance of some API calls returning large objects

  * Improved performance of sampling for Statistics worksheets

  * Improved performance of various other UI locations




#### Administration

  * **New feature** : Added reporting of SQL queries in Compute Resource Usage for several missing locations where DSS performs SQL queries




#### Setup

  * **New feature** : Added support for Python 3.9 for the DSS builtin environment




#### Dataiku Cloud

  * Code Studios: Fixed RStudio on Dataiku Cloud




#### Cloud Stacks

  * Switched OS for DSS instances from CentOS 7 to AlmaLinux 8

  * Switched R version for DSS instances from 3.6 to 4.2

  * Switched Python version for builtin env for DSS instances from 3.6 to 3.9

  * Fixed faulty display of errors while replaying setup actions

  * Fixed various issues with renaming instances

  * Made it easier to install the “tidyverse” R package out of the box

  * GCP: Fixed region for snapshots

  * GCP: Added ability to assign a static public IP for Fleet Manager

  * Fixed issue when declaring a govern node but not creating it

  * Made the “external URL” configurable for instances, for inter-instance links shown in the interface




#### Elastic AI

  * EKS: Fixed support for kubectl 1.26

  * GKE: Added support for Kubernetes 1.26

  * GKE: Fixed issue when creating cluster in a different zone than the DSS instance

  * Made it easier to debug issues with API nodes deployed on Kubernetes infrastructure (API node log now appears in pod logs)




#### Miscellaneous

  * Fixed broken/missing filtering (live search) in some dropdown menus

  * Fixed some Flow-related methods of the public API python client that would fail when used with labeling tasks

  * Fixed broken `DSSDataset#create_analysis` method of the public API python client

  * Removed limitations on size of project variables

  * Fixed failure when UIF invalid rules are defined

  * Fixed renaming of To do lists

  * Fixed possible failures of Jupyter notebooks failing to load

  * Fixed Admin > Monitoring screen failing to load if the instance contains a malformed dataset or chart definition.

  * Fixed issue with Python plugin recipes when installing plugin from Git in development mode

  * Fixed Parquet in Spark falling back to unoptimized path for minor ignorable differences in schema

  * Compute resource usage: added a new indicator that provides a better approximation of CPU usage on quick starting/stopping processes