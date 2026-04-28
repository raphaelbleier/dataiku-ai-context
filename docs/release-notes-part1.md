# Dataiku Docs — release-notes

## [release_notes/13]

# DSS 13 Release notes

## Migration notes

### How to upgrade

  * For Dataiku Cloud users, your DSS will be upgraded automatically to DSS 13 within pre-announced timeframes

  * For Dataiku Cloud Stacks users, please see upgrade documentation

>     * [For Cloud Stacks AWS users](<../installation/cloudstacks-aws/dss-upgrade.html>)
> 
>     * [For Cloud Stacks Azure users](<../installation/cloudstacks-azure/dss-upgrade.html>)
> 
>     * [For Cloud Stacks GCP users](<../installation/cloudstacks-gcp/dss-upgrade.html>)

  * For Dataiku Custom users, please see upgrade documentation: [Upgrading a DSS instance](<../installation/custom/upgrade.html>).




Pay attention to the warnings described in Limitations and warnings.

### Migration paths to DSS 13

>   * From DSS 12: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 11: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 10.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 9.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 8.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 7.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 6.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 5.1: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 5.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 4.3: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 4.2: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 4.1: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.1 -> 4.2](<old/4.2.html>), [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * From DSS 4.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<old/4.1.html>), [4.1 -> 4.2](<old/4.2.html>), [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>)
> 
>   * Migration from DSS 3.1 and below is not supported. You must first upgrade to 5.0. See [DSS 5.0 Release notes](<old/5.0.html>)
> 
> 


### Limitations and warnings

Automatic migration from previous versions is supported (see above). Please pay attention to the following cautions, removal and deprecation notices.

### Cautions

#### XGBoost models migration

(Introduced in 13.0)

DSS 13.0 now uses XGBoost 1.5 in the default VisualML setup.

No action is required on existing models when [Optimized scoring](<../machine-learning/scoring-engines.html>) is used for scoring. (Note that in particular, row-level explanations cannot use Optimized scoring.)

If Optimized scoring cannot be used, you can either:

  * Run the [XGBoost models upgrade macros](<../machine-learning/algorithms/in-memory-python.html#xgboost-upgrade-macros>) to automatically make the existing models compatible

  * Or, retrain the existing XGBoost models




#### Python 2.7 builtin env removal

(Introduced in 13.0)

Note

If you are using Dataiku Cloud or Dataiku Cloud Stacks, you do not need to pay attention to this

Very few Dataiku Custom customers are affected by this, as this was a very legacy setup.

Python 2.7 support for the builtin env of Dataiku was deprecated years ago and is now fully removed. If your builtin env was still Python 2.7, it will automatically migrate to Python 3. This may affect:

  * Existing code running on the builtin env, that may need adaptations to work in Python 3.

  * Machine Learning models, that will usually need to be retrained




#### Behavior change: handling of schema mismatch on SQL datasets

(Introduced in 13.1)

DSS will now by default refuse to drop SQL tables for managed datasets when the parent recipe is in append mode. In case of schema mismatch, the recipe now fails. This behavior can be reverted in the advanced settings of the output dataset

#### Models retraining

(Introduced in 13.2)

The following models, if trained using DSS’ built-in code environment, will need to be retrained after upgrading to remain usable for scoring:

  * Isolation Forest (AutoML Clustering Anomaly Detection)

  * Spectral clustering

  * KNN




#### Switch to Numpy 2

(Introduced in 13.5)

DSS 13.5 adds compatibility with numpy 2, for code environments that use the Pandas 2.2. For such code envs, updating could mean numpy gets upgraded from version 1.x to version 2. While this usually doesn’t cause issues, if you need to restrict numpy, you may add `numpy<2` to the requirements and update the code environment.

### Support removal

Some features that were previously announced as deprecated are now removed or unsupported

  * Hadoop distributions support

    * Support for Cloudera CDH 6

    * Support for Cloudera HDP 3

    * Support for Amazon EMR

  * OS support

    * Support for Red Hat Enterprise Linux before 7.9

    * Support for CentOS 7 before 7.9

    * Support for Oracle Linux before 7.9

    * Support for SUSE Linux Enterprise Server 15, 15 SP1, 15 SP2

    * Support for CentOS 8

  * Support for Java 8

  * Support for Python 2.7

  * Support for Spark 2




### Deprecation notices

DSS 13 deprecates support for some features and versions. Support for these will be removed in a later release.

  * Support for Python 3.6 and Python 3.7

  * Support for Ubuntu 18.04

  * Support for RedHat 7

  * Support for CentOS 7

  * Support for Oracle Linux 7

  * Support for SuSE Linux 12

  * Support for SuSE Linux 15 SP3

  * Support for Scala notebook for Spark

  * Support for multiple Hadoop clusters

  * Support for R 3.6

  * Support for Java 11




## Version 13.5.7 - August 14th, 2025

DSS 13.5.7 is a release with bug fixes, performance and security fixes

### Visual recipes

  * Fixed SQL parser error on large queries (also in 14.0.2)

  * Fixed infinite loop when listing tables of an empty Fabric schema (also in 14.1.0)

  * Fixed temporal type inference on Redshift when “date only” are disabled in Type system version (also in 14.0.2)




### Agent and tools

  * Fixed possible accumulation of sources from Tools between runs (also in 14.1.0)




### Coding

  * Fixed Knowledge Bank usage via langchain when using the `dataiku` package outside of a DSS instance




### Security

  * Fixed [Hugging Face token printed in logs of an uncontainerized fine-tuning recipe](<../security/advisories/dsa-2025-006.html>) (also in 14.1.0)




## Version 13.5.6 - July 15th, 2025

DSS 13.5.6 is a release with bug fixes

### Dataset and Connections

  * Snowflake: Fixed KeyPair authentication mode when user id contains dots (also in 14.0.0)

  * Fixed reading of numbers on XLSB format when they are stored as integers (also in 14.0.0)

  * Fixed ‘DataFormat’ error when importing a Excel export into Power BI

  * Fixed support for reading some Excel files that could wrongfully trigger anti-DoS protections (also in 14.0.0)

  * Added a connection setting to use default catalog/schema to “auto-resolve” not-fully-qualified datasets when checking table existence




### Charts

  * Fixed filtering from a cell value when using custom coloring rules on pivot table




### Misc

  * Fixed possible error when invoking some LLM custom plugins




## Version 13.5.5 - June 10th, 2025

DSS 13.5.5 is a release with bug fixes and security fixes

### LLM Mesh

  * Fixed code environment for RAG and Agents causing Visual Agent failures

  * LLM Evaluation: fixed “Test this metric” button

  * Fixed fined-tuned HuggingFace models

  * Prompt Recipe: Added an option to remove images from the llm_raw_query output column (keeping them only as reference to the folder)




### Machine Learning

  * Time Series: Fixed support for external features with NPTS

  * Individual explanations: Improved Shapley values computation performance with sparse-matrix-compatible algorithms




### Datasets and connections

  * Added variables support for file selection settings on plugin datasets based on files

  * Fixed incorrect parsing of Japanese Excel files containing kanjis, which could wrongfully include phonetic hints

  * Sharepoint: Added ability to configure timeouts




### API Deployer

  * Endpoint tuning: fixed “cruise” pool setting not properly respected

  * Fixed display of response time in Unified Monitoring




### Visual recipes

  * Prepare: Fixed “Find and Replace” step when applied on a shared dataset

  * Fixed width of display in formula type-ahead modal

  * Fixed formula auto-completion on column name with spaces




### Coding

  * Fixed writing of BigFrames dataframes (on BigQuery) with bigframes > 2.5.0




### Charts and Dashboards

  * Fixed sorting of chart date dimensions

  * Fixed content display of Notebook insights in insight page

  * Fixed Bubble chart export with color dimensions




### Governance

  * Fixed registries Sign-off filter




### Scenario

  * Fixed saving “days of week” time trigger when using a non-English user language




### Code Studios

  * Fixed RStudio not starting




### Cloud Stacks

  * Azure: Fixed provisioning failure due to backwards-incompatible change in azcopy




### Administration

  * Fixed impersonation rules filter

  * Govern: fixed edition of settings on Dataiku Cloud




### Security

  * Fixed [Insufficient permission checks when copying part of a Flow to another project](<../security/advisories/dsa-2025-005.html>)




### Misc

  * Fixed importing projects with LLMs exported before DSS 13.5.0




## Version 13.5.4 - May 22nd, 2025

DSS 13.5.4 is a release with new features, bug fixes and security fixes

### Datasets

  * Fixed plugin datasets parameters being lost after migration or project import




### LLM Mesh

  * **New feature** : Snowflake Cortex: Added streaming and tools support

  * Hugging Face connection: Fixed “Reserved capacity” settings if cluster does not have “Usable by all” permission

  * Added ability to store analyzed and generated images (both input and output) in a folder for audit purposes




### LLM Guard Services

  * Fixed LLM evaluation failure with SQL databases due to array column




### Machine Learning

  * Individual explanations: Improved performance for computation of Shapley values with sparse-matrix-compatible algorithms




### MLOps

  * Fixed import of MLFlow models exported before DSS 13.4




### Charts

  * Fixed conditional formatting based on another non-numerical column

  * Fixed gauge chart “Text area fill” setting

  * Fixed sorting of date axis by aggregation when “one tick per bin” is enabled

  * Fixed scatter plot when one of the axis only has one value

  * Improved geometry display precision

  * Fixed possible error on SQL engine when using a filter on a boolean column




### Webapps

  * Fixed visual webapps with mandatory parameters

  * Fixed renaming of webapps

  * Fixed incorrect HOME environment variable in containerized webapps

  * Stopped bundling JQuery on visual webapps when not explicitly requested




### Recipes

  * Improved performance of stack recipe validation with high number of columns




### Hadoop

  * Fixed Java 17 support on CDP 7.1.9




### Kubernetes

  * Removed excessive Kubernetes annotation values sanitization




### Code Studios

  * Fixed VSCode block if a code environment block is present before




### Cloud Stacks

  * GCP: Fixed reprovisioning failures after Fleet Manager upgrade




### Govern

  * Fixed artifact admin permission not giving read access on system locked artifacts




### Dataiku Applications

  * Fixed “Edit project variables” tiles default values




### Security

  * Fixed [XSS in Sanity Checks](<../security/advisories/dsa-2025-003.html>)

  * Fixed [Unauthenticated Denial of Service](<../security/advisories/dsa-2025-004.html>)




## Version 13.5.3 - May 15th, 2025

DSS 13.5.3 was a release with new features and bug fixes. This release is not available for download. Upgrading to 13.5.4 or later is required to benefit from the changes described below

### Agents & RAG

  * Visual Agents: Added ability to use Vertex AI Gemini models with Visual Agents

  * Visual Agents: Improved Visual Agent usage of Agent Tools configured with a JSON schema

  * Agents: Fixed selection of the active version of an Agent on an Automation node when no version was previously active

  * Agents: Fixed display of errors when creating a new Agent

  * Agents: Fixed possible shadowing of Plugin Agent modules by global/project libraries when not running in a container

  * Tools: Added partial filtering support in “Search Knowledge Bank” tool for FAISS, Qdrant-local, Elasticsearch, Pinecone, and Vertex AI Vector Search

  * Tools: Fixed predictions of the Model Prediction agent tool when records contain decimal values

  * Tools: Fixed API listing of Agent Tools

  * Tools: Fixed addition of DSS metadata on Agent Tools

  * RAG: Improved cleanup of stale files in Knowledge Banks

  * RAG: Fixed possible Upsert failure in Embed Dataset recipe when updating large documents

  * RAG: Fixed indexing of some date types metadata on FAISS, Elasticsearch/Opensearch and Qdrant-local Knowledge Banks

  * RAG: Fixed missing `build` method on `DSSKnowledgeBank`, and ability to run an Embed recipe via API

  * RAG: Fixed page range metadata produced by the Embed Documents recipe

  * RAG: Fixed a possible race condition on retrieval-augmented models configured with retrieval guardrails and used in a prompt recipe




### LLM Guard Services

  * Fixed usage of o1 and o3-mini for the computation of LLM evaluation recipe’s metrics

  * Fixed LLM Evaluation row-by-row analysis when hiding columns




### LLM Mesh

  * OpenAI: Added GPT 4.1 (regular, mini, and nano) to the OpenAI connection

  * Vertex: Added Gemini 2.0 Flash-Lite to the Vertex LLM connection

  * Databricks Mosaic AI: Added Claude 3.7 Sonnet and Llama 4 Maverick to the Databricks Mosaic AI connection

  * Local HuggingFace models: Added support for Gemma 3 on the local Hugging Face connection

  * Local HuggingFace models: Bumped vLLM to v0.8.4

  * Local HuggingFace models: Added support for 4-bit inflight quantized models without fallback to (slower) transformers, as well as BNB models

  * Fixed the Fine-tune recipe when using a Hugging Face LLM with a custom ID

  * Fixed import of `dataikuapi.dss.langchain.DKULLM` done outside of DSS




### Machine Learning

  * Fixed display of “lower is better” custom metrics in hyperparameter search chart

  * Fixed capitalization of ARIMA model coefficient column headers

  * Fixed display of ARIMA model summary while training

  * Fixed “automatic” determination of number of hyperparameter search threads when training on Kubernetes with cgroups v2

  * Fixed retraining of ensemble models not always abiding by sample weights settings

  * MLFlow Import: Added checks for model input declaration consistency against MLflow model signature




### Charts and Dashboards

  * **New feature** : Added color customization option on Density map

  * Fixed percentage scale calculation in SQL engine

  * Fixed red border display when a dashboard tile fails to load

  * Fixed “is not defined” color rule when exporting pivot table chart to Excel

  * The “Back to dashboard” link in insight now returns the user to the original dashboard tab

  * Fixed edition of empty dashboards opened from workspaces

  * Fixed persistence of pivot table headers / subheaders formatting settings when the table only has columns (no rows)

  * Fixed display of reference lines on charts migrated from an older DSS version

  * Fixed display of reference lines on thumbnails for scatters

  * Fixed issue where invalid reference lines caused valid ones to not display

  * Fixed display of tick labels when axis uses a string column with unparsed dates

  * Fixed charts using a user-defined aggregation function when all data is filtered

  * Fixed possible “out of axis” error on dashboard chart using Snowflake with filters




### Dataset and Connections

  * BigQuery: Switched to a single SQL statement when creating tables for managed datasets that have descriptions instead of 2 to prevent rate limiting errors

  * Databricks: Fixed fast-path on recipes where redispatch partitioning is enabled




### Recipes

  * Join: Fixed DSS engine not automatically aborting a recipe when the disk size limit is reached

  * SQL Query: Fixed recipe not correctly raising errors generated by CATCH clauses on SQL Server

  * Push to editable: Upstream changes in a column now propagate correctly when values are overridden

  * Added “Build from” in the right-click menu on Shared datasets. This allows building downstream datasets from a shared dataset




### Governance

  * Fixed action menu on custom pages not clickable after save




### API Deployment

  * Added a dku_http_request_metadata variable to provide access to request’s HTTP headers and URL path in Python function and Python Custom prediction API endpoints

  * Added the ability to customize HTTP response in Python function endpoints




### Coding & API

  * Added an API to programmatically create internal code environments

  * Added an API to programmatically delete Knowledge Banks and update their settings

  * Added an API to programmatically delete imported bundles on the automation node




### Scenarios

  * Project Testing: Added the possibility to specify the expected response type in webapp testing scenario step




### Git

  * A Git commit is now created when migrating projects to a new version of DSS

  * Moved internal DSS project files into the `.dss-meta` subdirectory, which is ignored by Git




### Cloud Stacks

  * AWS: Fixed possible failure deprovisioning a load balancer that was not successfully set up

  * Azure: Fixed Fleet Manager boot when multiple identities are present

  * Fixed possible failure updating custom SSL certificates




### Miscellaneous

  * Allow matching users with their email in Microsoft Entra ID (Azure AD)

  * Newly created webapps are now configured to be multi-threaded by default

  * Fixed exposition mode in webapp advanced settings not correctly taken into account

  * Fixed page tour captions not displaying correctly in Safari

  * Fixed lag when tagging users in discussions

  * Fixed DSS load failure in certain cases of invalid plugin definitions

  * Removed Local Deployer menu when instance is set to use a remote one

  * Fixed system metrics charts to better deal with data fetching frequency




## Version 13.5.2 - May 7th, 2025

DSS 13.5.2 is a bugfix release.

### Spark

  * Fixed PySpark recipes containing a vectorized User-Defined Function




## Version 13.5.1 - May 2nd, 2025

DSS 13.5.1 is a bugfix release.

### Agents & RAG

  * Embed Documents recipe: Fixed a possible memory issue when processing high number of documents, or large txt/md files

  * Fixed compatibility issue with Dataiku Answers >= 2.0.0 and < 2.2.0

  * Fixed project export when a Query Agent tool has missing fields

  * Fixed compatibility with some custom LLM connection plugins




### Recipes

  * Fixed Redshift-to-S3 fast path on columns with special characters




### Automation

  * Fixed the Automation monitoring page




### Dashboards

  * Fixed dashboards containing an insight dataset with a “color by scale” rule on a removed column




### Dataiku Applications

  * Fixed the instantiation of an application through dataikuapi




## Version 13.5.0 - April 17th, 2025

DSS 13.5.0 is a release with significant new features, bug fixes, security fixes, and performance improvements.

### Compatibility notes

DSS 13.5 adds compatibility with numpy 2, for code environments that use the Pandas 2.2. For such code envs, updating could mean numpy gets upgraded from version 1.x to version 2. While this usually doesn’t cause issues, if you need to restrict numpy, you may add `numpy<2` to the requirements and update the code environment.

DKULLM and DKUChatModel’s default `temperature` parameter is now `None`, which means the default of the provider/model, instead of 0 (which is not supported by all models). If you need 0, you can specify it explicitly.

### New feature: Chat in Prompt Studio

Prompt Studio now features a Chat mode. Note that Chat mode cannot become a Prompt recipe. It is primarily targeted at quick tests and tuning of system prompts for chat-oriented use cases.

### New feature: Conditional Governance Workflows

Workflow steps can now be defined to show up only if certain conditions on the artifact are matched, including field values, current workflow state or sign-off statuses.

Workflows are not started by default anymore, meaning the first step is not ongoing at first. Workflows can now be finished, meaning the last step can be set as finished.

As a consequence of this new feature, artifact.status.stepId is now deprecated. While it remains supported for backwards compatibility, some behaviors can be not totally supported anymore. Please use artifact.workflow instead.

### New feature: Recipe to extract rows failing Data Quality rules

When performing Data Quality checks, some rules have a “row-by-row” effect, such as the “All values must be in a given set”. From the Data Quality screen, you can now create a new recipe “Extract failing rows” that, when run, creates a dataset with all rows that failed one or several Data Quality rules, for quick and easy analysis and remediation.

### New feature: Share workspaces by email

Workspace administrators can now grant permissions to access a workspace using an email address. If the email address does not match an existing user, an invitation email is sent and the permission grant is put on hold until their account is created. This capability can be globally disabled by administrators.

### Agents & RAG

  * Search Knowledge Bank tool: Added support for filters on Azure AI Search

  * Added date storage type support on Embed Dataset recipe with Chroma, Azure AI Search, and Pinecone

  * Fixed Embed Document recipe with input files having special characters in their name

  * Fixed connection remapping of Visual Agents & Tools on project import / export / duplication and bundle deployment / activation

  * Fixed plugin code agent using plugin libraries while running in containers

  * Support for multimodal faithfulness and relevancy guardrails in augmented LLMs

  * Added ability to configure the prompt settings (e.g. temperature) of the underlying LLM of a Visual Agent




### LLM Mesh

  * Anthropic: Added support for Claude 3.7 Sonnet

  * HuggingFace: added ability to see the status and logs of locally running models

  * HuggingFace: fixed inference processes failures after 7 days of continuous run

  * Added support for image inputs on Custom LLM connections that implement it

  * Prompt Studio history is now included into project exports

  * Added support for “required” tool choice on Azure OpenAI & Azure LLM

  * Improved storage efficiency when rebuilding Knowledge Banks backed by a local vector store

  * Fixed retry on requests over the rate limit in Bedrock & AWS SageMaker

  * LLM Evaluation: support for multimodal context (multimodal faithfulness and relevancy built-in metrics, and display of context images in the evaluations)




### Machine Learning

  * **New feature** : Time Series forecasting: flexible forecast period (less or more than one horizon) in the Score recipe

  * **New feature** : Time Series forecasting: fixed-order SARIMA models

  * Time Series forecasting: New API to read the metrics of each time series on a multi-series forecasting model

  * Added support for XGBoost 2.1 (on Python 3.8+ code environments)

  * Added compatibility of more operators in ML Overrides with Java model export

  * Fixed ICE prediction explanations in Score recipe

  * Fixed optimized scoring of XGBoost models using a “Logistic Regression” objective

  * Fixed “Redetect Settings” that would remove custom metrics from the current task

  * Fixed a rare mixup of classes in post-train computation on binary classification models

  * Time Series forecasting: Fixed time series forecasting training when one series’ target is constant

  * Fixed optimized (Java) scoring of models using derived numerical features




### Datasets

  * **New feature** : Databricks: Support for Databricks Volumes for managed folders. Databricks Volumes can be used to read and write managed folders

  * **New feature** : Databricks: Support for Databricks Volumes for fast-write. You can now fast-write into Databricks without an external S3/Azure Blob/GCS connection

  * **New feature** : Snowflake: Support for storage integrations for fast-write with Azure Blob and S3

  * **New feature** : Teradata: Random sampling is now executed in database

  * **New feature** : Greenplum: Random sampling is now executed in database

  * **New feature** : Improved conditional formatting in Explore. It’s now easier to add, remove, manage and mix different conditional formatting rules

  * **New feature** : MongoDB: Added support for per-user credentials

  * Excel: Fixed reading of date and multiline string cells

  * Snowflake: Added visual support for authentication using key pairs.

  * Snowflake: Fixed automatic fast-write not always cleaning up files copied to S3 in case of error.

  * Databricks: Fixed issue preventing writing from Delta datasets to CSV datasets

  * BigQuery: Fixed writing partitioned datasets containing columns with spaces to GCS

  * BigQuery: Fixed writing partitioned datasets containing ‘datetime no tz’ columns to GCS

  * Fabric: Fixed automatic fast-write failing when dataset contain dates column using Parquet format

  * Fabric: Fixed table listing failure when another job is writing to the same connection

  * DB2: Fixed handling of ‘datetime no tz’ columns




### Recipes

  * **New feature** : Upsert recipe: This recipe (provided by a plugin) gives the ability to merge datasets by inserting or updating rows based on a primary key, on SQL and file-based datasets.

  * Prepare: Added buttons to quickly create common steps like Formula, Filter on value, and Fill empty cells.

  * Prepare: Column descriptions are now automatically propagated when creating, editing or running a Prepare recipe

  * Prepare: Fixed “Increment date” step with SQL engine when increment is a column created in a previous step

  * Prepare: Added last modified column to “Enrich records with files info” step

  * Prepare: Fixed “Enrich records with files info” step to correctly output the file name instead of the file path on GCS and Azure

  * Prepare: Fixed “Fill empty with value” step failing on Snowflake when the column contains NULL values

  * Filter/Sampling: Added SQL engine support when sampling is enabled for Snowflake, Databricks, BigQuery, Redshift, Teradata and Greenplum

  * Sync: Fixed sync issue between partitioned SQL datasets when the redispatch option is checked

  * Fixed recipe failure on partitioned datasets when both redispatch and automatic fast-write are enabled

  * Fixed incorrect engine detection for GCS causing recipes to fail




### Flow

  * Added activity status indicator on the Flow for Knowledge Banks, Saved Models, Evaluation Stores, and Managed Folders

  * Fixed performance issue when selecting zones via multi-select button




### Coding & API

  * Added support for numpy 2 (in Python 3.9+ code environments)

  * Added API to download a bundle or an API service package from the deployer

  * Added Python methods to create, update, delete messaging channels

  * Added support for creating ‘Export to Folder’ recipes using DSSProject.new_recipe

  * Added ability to add a client certificate when instantiating DSSClient

  * R: Added support per code-env Dockerfile hooks

  * R: Fixed code recipe and Shiny webapps using the scorecard package failing in containerized execution




### Code Studios

  * Fixed missing error message when a non-admin user attempts to change the “Run backend as” user in a Code Studio webapp




### Charts and Dashboards

  * Pivot Table: Conditional formatting: added ability to use scales in coloring rules

  * Pivot Table: Conditional formatting: added ability to base color rules on another column than the one colored

  * KPI: Conditional formatting: added ability to base color rules on another column than the one colored

  * Added the possibility to define “promoted colors” in the DSS instance admin settings. Those colors are then displayed first in all color pickers.

  * Added more customization options for displaying values in charts

  * Improved dashboard cache/sample building process to avoid “EOFException” occurrences

  * Filters: Added input fields on sliders to precisely set the value

  * Filters: Added ability to only show selected values in filters

  * Scatter map: Fixed filtering

  * Scatter map: Fixed point radius update

  * Dashboards: Fixed “None” option for dashboard tile border

  * Dashboards:Fixed dashboard web content tiles cropping their content

  * Fixed placement of values when downloading a chart as image




### Stories

  * Fixed the persistence of column width in tables

  * Fixed average displayed in tables

  * Fixed a race condition when doing zip and pdf export at the same time

  * Fixed copy/paste issue using keyboard shortcuts

  * Fixed slide deletion when the slide contains an image




### Governance

  * **New feature** : Custom pages: Added new customization possibilities through the introduction of custom filters into the custom page designer, allowing to define advanced filters for filtering the content of the page.

  * **New feature** : Added ability to automatically govern projects with a defined template

  * **New feature** : Added ability for users to name and save their custom filters

  * Added Markdown text formatting capabilities to text fields

  * Added support for the sync of DSS plugins’ custom fields (see [Component: Custom Fields](<../plugins/reference/custom-fields.html>))

  * Added a new JSON field type

  * Added ability to cancel file upload

  * Added ability to revert changes made to a custom page definition

  * Simplified navigation menu

  * Uploaded files and time series: added an “owner” field on these items, which is set to the user creating the item. Items created before 13.5.0 have no owner. Read and write permissions for orphan items without an owner are now only granted to the instance admins, govern managers, and if it exists, its owner (the access to those hidden items was previously not restricted)

  * Fixed upload of additional attachments when one is already in progress

  * Fixed custom filters when using a number criterion on a text field value




### Deployer

  * **New feature** : Added remapping for containerized execution configurations

  * Bundles: added an option to specify whether to include notebooks with their outputs, just notebooks definitions, or not to include notebooks at all. Default is now to only include notebooks definitions. Previous behavior was notebooks and outputs

  * Added an option on project deployment to include connection remappings defined at infrastructure level upon deployment update (remappings defined at deployment level take precedence)

  * Fixed API endpoint disappearing from Unified Monitoring when updating the associated deployment

  * Fixed custom prediction Python endpoints deployed on Vertex AI infrastructure when the endpoint does not output probabilities

  * Fixed latency computation for deployments with low activity




### MLOps

  * **New feature** : Added support for custom metrics in the Standalone Evaluation Recipe

  * Added support for 2-dimensional numpy array output in MLflow imported regression models

  * Fixed evaluation recipe failing when there are normalized datetime features whose values are all NaN/NaT




### Elastic AI

  * Fixed missing link to cluster objects in K8S cluster monitoring

  * GKE: Added option to use the DNS endpoint feature when attaching to an existing cluster

  * Fixed error preventing the creation of namespaces when switching to a new cluster

  * Fixed plugin update triggering an image rebuild when “Containerized visual recipe” is disabled and “auto-rebuild image” is enabled




### Cloud Stacks

  * **New feature** : A single Fleet Manager can now create and manage DSS instances in multiple regions and accounts

  * **New feature** : Fleet Manager can now deploy a Load Balancer / Application Gateway in front of each DSS instance for more managed access

  * Azure: All resources created by FleetManager are now tagged with dku:stackName

  * GCP: All resources created by FleetManager are now tagged with dku-stackName

  * Updated location of user home directories. They are now persisted on data disk in /data/home




### Performance & Scalability

  * Fixed possible deadlock in PostgreSQL runtime database when computing metrics

  * Fixed error during user provisioning on very large Azure AD / Entra directories




### Security

  * Fixed Azure AD / Entra user provisioning failing for emails containing a quote character

  * New personal connections are now by default only usable by their creator

  * Fixed [Incorrect type validation in image preview](<../security/advisories/dsa-2025-002.html>)




### Miscellaneous

  * Added interactive tours to guide new users when they first open a Flow, a Dataset, or a Prepare recipe

  * Added step summary to the scenario Info tab in the right panel




## Version 13.4.4 - April 8th, 2025

DSS 13.4.4 is a bugfix release.

### LLM Mesh

  * Fixed templates list in the “Send an email or message” Tool

  * Fixed Embed Documents dependencies installation on Ubuntu 22.04




### Machine Learning

  * Fixed support of millisecond timestamps in MQ-CNN timeseries forecasting




### Scenarios

  * Fixed Query/Response test parameters in the Test Webapp scenario step




### Charts and Dashboards

  * Fixed scatters with millisecond precision time scale




### Datasets

  * Fixed Parquet compression not applied in some cases with Spark

  * Fixed writing of the datetimenotz type in Parquet

  * Fixed suboptimal Parquet write performance when writing Parquet dates (without time) to a datetimetz field




### Flow

  * Fixed “Propagate schema” Flow action wrongfully affecting other projects




### Visual recipes

  * Fixed mishandling of “trunc” formula for dates on Oracle




### Deployer

  * Fixed last deployment attempt status for non-admin users

  * Fixed use of variables in service path field when deploying API Services to Kubernetes




### Webapps

  * Fixed failure using WebappImpersonationContext




### Coding

  * Fixed writing of pandas datetime64[us] series into datetimenotz columns




### Elastic AI

  * Fixed incorrect $HOME environment variable in non-containerized code recipes when UIF is enabled




### Misc

  * Improved performance of the Explore screen




## Version 13.4.3 - March 25th, 2025

DSS 13.4.3 is a feature and bugfix release

### LLM Mesh

  * Hugging Face: Added experimental support for tool calling

  * Hugging Face: Added more inference configuration options

  * Azure OpenAI: Added support for o1-mini, o1, and o3-mini models

  * Bedrock: Added support for Claude 3.7 Sonnet

  * OpenAI: Added support for gpt-4.5

  * Vertex: Updated model version for Gemini 2.0 Flash Thinking Experimental

  * Improved accuracy of the Text Classification recipe when using Mistral models

  * Fixed possible issues with empty metadata values in the Embed Dataset recipe

  * Fixed possible issues with integer and float metadata columns on Azure AI Search KBs

  * Fixed images input with Claude 3 Opus via Bedrock

  * Fixed images input with Gemini models

  * Fixed cropping/scrolling of image (and document page) previews in Prompt Studio

  * Fixed addition of Guardrails on Prompt recipes created prior to DSS 13.4.0

  * Hugging Face: Fixed observance of the `HF_ENDPOINT` environment variable

  * Fixed the Text Classification recipe’s hypothesis template used with MLNI models

  * Fixed LLM Evaluation Recipe failing on “Other” task when not selecting an input or an output column




### Agents & RAG

  * Document embedding: Added support for odt, odp, doc, ppt, jpeg, and png formats

  * Document embedding: Added support for text and Markdown files with non-UTF8 encoding

  * Document embedding: Fixed fallback for pptx files in the Embed Document recipe when LibreOffice fails conversion

  * Fixed dataset status refresh and column restrictions on the “Append Record” Agent Tool

  * Fixed filtering on the “Dataset Lookup” Agent Tool when restricted to another lookup column

  * Fixed collection of Visual Agent code env when preparing a project bundle




### Machine Learning

  * Fixed a rare training failure when retraining on an automation node

  * Fixed probability calibration on LightGBM models using optimized scoring

  * Fixed time series forecasting scoring with “Output model metadata” enabled

  * Fixed time series forecasting scoring with 2 or more “datetime with tz” columns

  * Fixed time series forecasting scoring with a “datetime with tz” column that was rejected at training time

  * Scoring: Fixed handling of columns of type “datetime no tz” containing values without milliseconds

  * Fixed ability to set a constant imputation as fallback of “keep empty values” on numerical features

  * Fixed failing evaluation recipes when using empty labels

  * Fixed possible failure of interpretation screens when using non-imputed numerical inputs




### Charts and Dashboards

  * Fixed exports for slow loading dashboards

  * Fixed dashboard export failing when done from the dashboards list page

  * Fixed “Values in Chart” settings to display “totals” options at the creation of the chart

  * Fixed the display of KPI values for Dashboards created in earlier DSS versions

  * Fixed cross filters creation when filter panel is empty

  * Tableau: fixed export on datasets containing new date types




### Dataset and Connections

  * Databricks: execute CREATE OR REPLACE instead of DROP + CREATE when building datasets

  * Databricks: fixed importing datasets on Databricks clusters without Unity Catalog

  * BigQuery: Fixed reading columns of type DATETIME as strings

  * GCS: Fixed reading of Parquet files using credentials from environment

  * S3: fixed preview doing a full scan with Delta tables

  * S3: fixed Spark engine when using Glue metastore

  * Oracle: added description retrieval when importing tables from Oracle

  * Oracle: fixed creation of tables with strings with maximum length between 2000 and 4000 characters

  * Oracle: fixed reading SYSDATE-like columns as string truncating the time part

  * Oracle: fixed “datetime with tz” columns to use Oracle “timestamp with local time zone” type

  * Azure Blob: fixed reading Parquet files via WASB (legacy API)

  * Fixed reading of partitioned datasets using Spark engine with date-partitioned Delta files by a column of type String

  * Vertica: added OAuth authentication support

  * Fabric: removed option to use Managed Identities in fast-path as it’s not supported by Fabric

  * Trino: fixed connection requiring a database to be filled

  * Excel: added support for reading XLSB files




### Recipes

  * Sync: Fixed issue with ElasticSearch when columns of type “datetime no tz” contains values without milliseconds

  * Prepare: Fixed Parse date and Format date steps when executed using Spark on a cluster setup with a timezone different from UTC

  * Prepare: Fixed Spark execution when a Prepare recipe immediately follows a Pivot recipe

  * Group: Fixed sort with removed columns

  * Stack: Fixed origin column in remap mode

  * Join: Fixed DSS engine wrongly joining dates when they coincide with Daylight Saving Time change

  * Hive: Added schema propagation support on Hive recipes

  * Push To Editable: added schema propagation when running the recipe




### Stories

  * Fixed deletion of Stories from workspaces

  * Fixed PDF and PPTX export when a filter prompt is included in a Story




### Coding & API

  * Fixed DSSUser.get_client_as with encrypted RPC

  * Fixed DSSManagedFolder.list_paths_in_partition not correctly returning an exception when enumeration stops due to “too many files” error

  * Fixed “Date only” columns generated by Python recipes being created as string instead of “Datetime with tz”

  * Fixed SQLExecutor2.exec_recipe_fragment when the recipe has a managed folder output

  * Fixed bad error message returned by scenario_run.wait_for_completion() when the scenario fails

  * Adapted Dash webapp template to be compatible with Dash 3




### Git

  * Added integrity check on project configuration files when resolving a conflict during merge request




### Governance

  * Added an option in emails notification settings to automatically set the sender field of the email as the user who performed the action triggering the notification

  * Added ability to set the profiles of multiple users at the same time

  * Added an option to include a dump of the database in instance diagnostics

  * Improved the template selection when creating an artifact

  * Removed some static filters: Country and Sponsor from Governed project page, and Region, Sponsor and Business function from Business Initiative page. Note that you can still filter on those fields using a custom filter.

  * Fixed sticky right panel when switching between tabs

  * Fixed inconsistent naming of blueprints and blueprint versions for Dataiku items between right panel and artifact page header or minicard.

  * Fixed group edition page title to display the name of the group

  * Fixed custom page edition

  * Fixed Augmented LLMs displayed as governable when they should not because their project is not governed and user doesn’t have the permission to govern the project

  * Fixed text selection in text field within a list




### Elastic AI

  * GKE: Don’t install NVidia drivers when GPU is not requested




### Cloud Stacks

  * Azure: Remove v6 instance types that cannot be used

  * Improved propagation of tags to Cloud resources




### Performance & Stability

  * Fixed possible crash when computing a map chart with enormous geometries

  * Reduced performance impact of indexing in the catalog / DSS items search




### Misc

  * Fixed prediction classes not properly set when deploying a classification model from an experiment tracking run

  * Fixed API Designer test failure when using an Oracle connection for bundled data

  * The plugin “Usages” tab now accounts for Agents, Tools, and LLM Guardrails

  * Fixed possible failures of webapps when using public mode or vanity URLs

  * Fixed issues with webapp duplication




## Version 13.4.2 - March 12th, 2025

DSS 13.4.2 is a bugfix release

### Performance

  * Fixed thread leak when writing Parquet files on S3 via non-regional endpoints




## Version 13.4.1 - February 21st, 2025

DSS 13.4.1 is a bugfix release

### LLM

  * Allow to specify costs for custom AWS Bedrock models with a finer granularity than 0.01$

  * Fixed “Advanced LLM Mesh required” warning modal




### Connections

  * Fixed OAuth2 mode of Azure and Azure OpenAI Connections if token endpoint is specified

  * Fixed propagation of string columns max length on SQLServer and PostgreSQL datasets

  * Fixed MongoDB connection when using username and password fields with non default MongoDB authentication




### API

  * Fixed the drop_and_create option of Dataset#write_schema Python method




### Elastic AI

  * Fixed the “Push base images” button in “Containerized execution” settings page




### Govern

  * Fixed saved model visual agents displayed as fine-tuned saved models




### Deployer

  * Fixed project deployment save button




### Plugins

  * Fixed issue saving the visibility settings of plugins




### Testing

  * Fixed code environment selection dropdown in Pytest scenario step settings




### Git

  * Fixed “Revert project” version warning if several Dataiku upgrades had happened since the commit




### Performance

  * Fixed memory leak when writing Parquet files on S3

  * Fixed possible hang related to refresh token rotation

  * Fixed jobs failing to start on instances with hundreds of Dataiku Applications




## Version 13.4.0 - February 9th, 2025

DSS 13.4.0 is a major new release, with major new features, bug fixes, security fixes, and performance improvements

### New Feature: Dataiku Stories

Dataiku Stories empowers business users to quickly build contextualized, interactive, and up-to-date data presentations so that they can more easily understand and share the stories hidden in their data.

Through drag-and-drop visual interfaces, business users can collaboratively create meaningful presentations with filters, annotations, and interactive elements that are automatically refreshed with new data.

For more details, please see [Stories](<../stories/index.html>)

### New Feature: Dataiku Answers & Agent Connect

Dataiku now includes two fully-featured AI Chatbot user interfaces, allowing you to expose rich chatbots to your users powered by AI. They handle security, tracing, user preferences, history, and are customizable.

  * Answers is a full-featured Chat interface for creating chat bots based on your internal knowledge and data

  * Agent Connect is a more advanced multi-agent Chat interface for unified user access to multiple Generative AI use cases




For more details, please see [Chat UI](<../generative-ai/chat-ui/index.html>)

### New Feature: Visual Agents & Tools

You can now visually define your own Generative AI Agents, that can then be used in all LLM-enabled capabilities of Dataiku (Prompt Studio, Prompt Recipes, Dataiku Answers, Agent Connect, LLM Mesh API).

Visual Agents leverage managed Tools, that give them the power to perform various tasks.

For more details, please see [AI Agents](<../agents/index.html>).

### New Feature: Document embedding

In addition to the traditional embedding of text and storage in Vector Stores, Dataiku can now work directly with unstructured documents.

The “Embed documents” recipe takes a managed folder of documents (PDF, DOCX, PPTX, ….) as input and outputs a Knowledge Bank that can directly be used to query the content of these documents.

For more details, please see [Adding Knowledge to LLMs](<../generative-ai/knowledge/index.html>).

### New Feature: LLM cost blocking & alerting

This feature is part of the Advanced LLM Mesh add-on.

You can now define quotas, matching conditions, alert threshold and block LLM queries that go over defined spending limits. It is possible to define multiple rules, based on models, providers, projects, …

For more details, please see [Cost Control](<../generative-ai/cost-control.html>).

### New feature: Unified LLM Guardrails & Custom Guardrails

LLM Mesh Guardrails can now be used “at usage time” in addition to connection level. This allows customizing validations made depending on the use case.

It is now possible to write custom LLM Guardrails to implement custom validation rules.

For more details, please see [Guardrails](<../generative-ai/guardrails/index.html>)

### New Feature: New handling of dates

A long standing limitation of Dataiku has been the support for only “dates with timestamps”. This type used to represent an absolute point in time, including a date, time, and timezone. However, many systems such as databases also handle dates that aren’t tied to a specific moment, such as a calendar day without a time or a datetime without a timezone.

Dataiku now includes three date handling types:

  * “Datetime with TZ”: represents an absolute point in time (date+time+timezone). For example, 2024-08-26T15:00:00+0200. This is the type, that used to exist and was called “date”

  * “Datetime no TZ”: represents a date with time but without a time zone. For example, 2024-08-26 15:00:00

  * “Date only”: represents a calendar day. For example, 2024-08-26




The old “date” type remains available in code, but is more generally called “Datetime with TZ”

### New Feature: Revamped filtering and search in Flow

A new search, filtering and coloring experience is available in the Flow.

  * Quickly find objects by typing free text or keywords to narrow down your search. Get suggestions while typing

  * Receive relevant suggestions as you type, based on your flow’s objects and views properties




### New Feature: AI SQL Assistant

SQL Assistant enhances Dataiku’s AI Assistant capabilities by leveraging Generative AI to boost productivity within the platform. It enables users of all skill levels to write SQL queries directly from natural language, in SQL notebooks and SQL recipes

For more details, please see [SQL Assistant](<../ai-assistants/sql-assistant.html>).

### New Feature: Data Quality “typical range” rules

New Data Quality rules can to automatically detect when a value (min of column, median of column, …) goes outside of its typical range

### LLM Mesh

  * **New feature** : RAG guardrails (part of the Advanced LLM Mesh add-on). On augmented models, specify minimum faithfulness & relevancy thresholds.

  * **New feature** : Hybrid search for RAG. Knowledge Bank backed by Azure AI search and Elasticsearch vector stores can now use hybrid (semantic + keyword-based) search for retrieval, as well as the improved reranking features offered by those services.

  * **New feature** : For local models (Hugging Face connection), you can now, on each model, specify a minimum and maximum number of running inference processes. Minimum means this model remains loaded and ready to infer immediately, even when not currently serving any request, at the cost of occupying the resources defined in the container execution configuration.

  * **New models** : AWS Bedrock: added support for the Amazon Nova model family

  * **New models** : AWS Bedrock: added support for Llama 3.3 70B

  * **New models** : Databricks Mosaic AI: added support for Llama 3.3 70B

  * **New models** : Local models (Hugging Face): added support for the Phi 4 14B and Mistral Small 3 24B models

  * **New models** : OpenAI: added support for o1 and o3-mini models

  * **New models** : Snowflake Cortex: added support for Llama 3.3 70B

  * **New models** : Stability AI: added support for SD 3 medium model and the SD 3.5 model family

  * Local models: Added ability to customize containerized execution configuration for each local model

  * Local models: Added ability to customize context length for each local model

  * Local models: Fixed logging of vLLM generation statistics

  * AWS Bedrock: added support for inference profiles

  * Code Agents: Added ability for a Code Agent to respond to queries that have image inputs

  * Code Agents: Improved Code Agents code requirements: you can now implement one or more of `process`, `aprocess`, `process_stream` and `aprocess_stream` (blocking/streamed and sync/async), and the other ones are emulated automatically, without the need to choose an “implementation mode”.

  * Code Agents: Fixed saving of Code Agents after a failed run of a test query

  * Guardrails: Improve sturdiness of LLM-as-a-judge prompt injection detection

  * Evaluation: Added Model Evaluation labels for tracking the embedding and completion LLMs used for LLM-as-a-judge metrics

  * Improved error reporting when testing a LLM connection

  * LLM audit logs now include the queried model

  * Fixed inability to add a fine-tuned saved model as input of a Python recipe

  * Fixed inability to use LangChain filters (through code) in a KB on Azure AI Search

  * Fixed retrieval of documents with an empty metadata column on ChromaDB

  * Fixed unneeded `prediction_explanation` empty column in the output dataset of a Classify Text recipe when such explanations were not requested

  * Fixed containerized execution & dev mode settings ignored for plugin agents

  * Fixed wrongful buffering of streaming responses when using the LLM Mesh API from outside Dataiku




### Machine Learning

  * **New feature** : Added support for NaN / missing values for numerical features, for algorithms that can support it

  * Added support for LightGBM 4.5

  * Sped up computation of variable importances on Causal models

  * Sped up model documentation export with large tables

  * Fixed creation of Evaluate recipes when there is a Code or Plugin Agent in the same project

  * Fixed possible incorrect predictions when scoring with optimized (Java) scoring XGboost models trained using `hist` or `approximate` tree methods

  * Fixed possible unnecessary data loading when requesting prediction explanations

  * Fixed programmatic creation of clustering scoring recipes using `with_existing_output`

  * Added a new “optimize” parameter to `get_predictor` to allow the use of a faster lightweight predictor for models that are compatible with python export.




### Time series forecasting

  * **New feature** : residuals analysis (visualization & statistical tests)

  * **New feature** : Added per-fold metrics

  * **New feature** : Added ability to customize the resampling start & end dates, and to resample to any day of the month

  * **New feature** : Added “Information criteria” and model coefficients error & p-values for statistical models (ARIMA, Seasonal Trend, prophet)

  * Fixed training of models with a forecast horizon of 1 using pandas 2




### Charts and Dashboards

  * **New feature** : Added ability to assign another measure as data label

  * **New feature** : Added support for reference line on the X-axis

  * **New feature** : Added support for date reference lines

  * Pivot Table: Added ability to hide row and column headers, to freeze the row headers when scrolling horizontally, and to have different font formatting options for row and column subheaders

  * Pivot Table: Added ability to hide the side bar

  * Added ability to rebuild cached data of selected datasets for associated charts and dashboards in the “Refresh statistics & chart cache” scenario step

  * Filters: Added ability to sort the values of filters

  * Filters: Added ability to rename filters

  * Filters: Added option to include empty values for numerical range, date range and relative date range filters

  * Filters: Fixed an error with alphanumeric filter with no or all values on SQL Databases

  * Added ability to use “Count of records” in displayed aggregations

  * Dashboards: Fixed download of dataset tiles to take into account the “include empty values” option

  * Dashboards: Fixed the generated url to properly take into account when a relative date filter has been cleared

  * Dashboards: Added support for “include empty values” option in the URL for dashboards (using “emptyvalues()” URL parameter)

  * Fixed reference line defined with a source as “displayed aggregation” to rollback to a source as “Constant” when switching to a chart that does not support source as “displayed aggregation”

  * ixed broken dashboard sample filters

  * Fixed unavailable zoom on scatter when at least one axis is zoomable

  * Set default percentile for aggregation to 50

  * Fixed deletion of reference lines not deleting the expected line

  * Added reference lines on the zoom timelin to display reference lines

  * Fixed the refresh of zoom timeline when switching between different date ranges

  * Fixed empty line chart when deleting a reference line after zooming on the timeline

  * Fixed possible leak of temporary tables when aborting a chart computed on Impala




### Collaboration

  * **New feature** : Welcome emails: Added ability for administrators to send a welcome email to newly added users

  * **New feature** : Default project folder: A new project folder named “Sandbox” is now available by default in DSS. When creating a new project, users can now choose in which folder it will be created. The project folder suggested by default is the new Sandbox folder but can be changed by DSS administrators in Administration > Settings > Themes & Customization.

  * Added integration with Google Chat for scenario reporters, send message steps and project notifications




### Dataset and Connections

  * **New feature** : Databricks: Random sampling is now executed in database

  * **New feature** : Redshift: Random sampling is now executed in database

  * **New feature** : The description of SQL dataset descriptions can now be pushed to the underlying SQL databases as tables comments

  * **New feature** : Explore View: Added ability to reorder and quickly hide columns when exploring datasets

  * **New feature** : Added button to quickly schedule the build of a dataset and optionally send it by email

  * SQL datasets: Fixed import of tables with columns containing non-alphabetical characters such as parentheses

  * Snowflake: Fixed SQL pipeline failing when catalog is specified on the connection

  * BigQuery: Fixed columns not being fetched correctly when indexing BigQuery connections

  * Greenplum: Fixed filtering of date-based partitioned datasets

  * Dataset from folder: Fixed explicitly selecting files on newly created “Dataset from folder” datasets

  * Fixed reading Delta dataset stored with columns of type “array” written by PyArrow

  * Job are now marked as “completed with warnings” when creating an SQL table name whose name is truncated by the database (in case database has limits on table names such as Oracle and PostgreSQL)

  * Added button to refresh OAuth token in case it has expired in Explore and Dashboards




### Visual recipes

  * Group: Adding reordering of the grouping columns

  * Prepare: Improved user experience of the Generate Steps AI Assistant

  * Prepare: The Find and Replace step now includes the ability to use another dataset as the source for the strings to find and their corresponding replacements

  * Prepare: Added support for the following currencies in Convert currencies step: United Arab Emirates Dirham (AED), Qatari Riyal (QAR), Israeli New Shekel (ILS), Kuwaiti Dinar (KWD), Saudi Riyal (SAR), Omani Rial (OMR)

  * Formula: Deprecated asDate() method. It has been renamed to asDatetimeTz() to match the new dates naming convention.

  * Formula: Added asDatetimeNoTz() method to convert input to “datetime no tz” type

  * Formula: Added asDateOnly() method to convert input to “datetime no tz” type

  * Formula: Added ord() and char() methods to convert a character into a number and vice-versa




### Statistics

  * Added ability to edit card titles within a worksheet

  * Added a Z-test variant to the one-sample Student t-test, for when the standard deviation is known prior to the test

  * Fixed renaming of a Statistics card Dashboard insight




### Scenarios & Testing

  * **New feature** : Added the ability to specify test queries and expected responses in the “Test webapp” scenario step

  * Added separated “Swap datasets” and “Compare test datasets” tests steps

  * Fixed renaming of datasets to propagate to flow testing tests

  * Added the ability to specify log level in python test steps

  * Automation Monitoring: Allow filtering runs by users

  * Fixed scenario running indefinitely in case a webhook reporter hangs

  * Fixed scenario running indefinitely after aborting if it was computing Spark-based metrics




### MLOps

  * **New feature** : Added support for custom metrics in the Evaluation Recipe

  * Added an option in the Standalone Evaluation Recipe to specify how to interpret empty predictions for multiclass classification

  * Added the possibility to download a MLflow imported model

  * Fixed the Evaluation Recipe failing when no feature handling is defined in the drift metrics settings and there is no suitable input feature for drift computation

  * Fixed the export of MLflow imported models to avoid rewrapping them when exported as MLflow models




### Governance

  * **New Feature** : Added governance of Fine-tuned LLMs, Code Agents and Augmented LLMs

  * **New feature** : Added governance of clustering models

  * **New Feature** : Added governance status in DSS project home

  * Added the ability to hide or unhide multiple items at a time

  * Added a flag to prevent sign-off requester to be able to also approve the same sign-off

  * Fixed export of custom pages to take filters into account

  * Fixed an error appearing when assigning a user for feedback or final approval on signoff without having read permission on the User blueprint




### Data Quality

  * Added ability to convert a rule from one type to another




### Deployer

  * **New Feature** : API Deployer: Added endpoint activity metrics (latency and volume) and health status to the deployment page

  * API Deployer: Added code preview in deployments for custom endpoints

  * API Deployer: Added the propagation of permissions from the project on the design node to the API Service on the deployer node

  * API Deployer: Added model and govern statuses to API deployments

  * API Deployer: Made available OpenAPI content to users with only “Read” permission on the deployment

  * API Deployer: Fixed invisible python logs on Databricks Deployments

  * API Deployer: Fixed lookup endpoint returning a string instead of a double in referenced mode

  * Project Deployer: Added model, data quality, and governance statuses in project deployments

  * Monitoring: Added support for WebApps in Unified Monitoring execution status




### Coding & API

  * **New feature** : Built-in support for BigQuery BigFrames. Read <https://developer.dataiku.com/latest/concepts-and-examples/bigframes.html> for more details

  * SQL notebooks: Added ability to restrict tables listing by catalog/schema to speed it up

  * Added DKU_CODE_ENV_NAME to the environment variables accessible when executing Python code

  * Added DSSManagedFolder.rename to rename managed folders

  * Added JobDefinitionBuilder.with_auto_update_schema_before_each_recipe_run to automatically update schemas before building datasets

  * Added ability to create Spark SQL Query recipes using DSSProject.new_recipe(‘spark_sql_query’)

  * Fixed table dropped when calling SQLExecutor2.exec_recipe_fragment, even when overwrite_output_schema=False and drop_partitioned_on_schema_mismatch=False

  * Added the ability to specify a version identifier for the `update_packages` command (only applicable to versioned code environments on automation nodes)

  * R: Fixed import of jsonlite in R API endpoints




### Cloud Stacks

  * Added display of disk usage for OS disk

  * Added sort of instances by name or status




### Plugins

  * **New feature** : Added ability for administrators to limit the visibility of some plugins in the New dataset and New recipe menus. To do so, go to Plugins > SomePlugin > Settings > Permissions. Note that this only limits visibility, it does not prevent usage.

  * Added Agents in the components list




### Security

  * Fixed [Cross-site-scripting in Prepare recipe](<../security/advisories/dsa-2025-001.html>)




### Miscellaneous

  * Fixed upload button always disabled in CodeEnv resources on Automation node

  * Git merge: Let user delete project and/or branch when doing a successful merge of git branches

  * Elastic AI on EKS: Fixed metrics server that was not working in EKS managed clusters

  * Fixed possible startup failure following a crash while writing configuration

  * Fixed wrongful buffering when using streaming responses in webapps with Server-Sent-Events




## Version 13.3.3 - January 27th, 2025

DSS 13.3.3 is a feature, performance and bugfix release

### ML

  * Fixed external feature coefficients on prophet timeseries model

  * Fixed creation of an Evaluate recipe when there is a Code or Plugin Agent in the same project




### Labeling

  * Fixed labeling tasks using a Snowflake input dataset and PostgreSQL as internal DSS database




### API Node

  * Faster recovery when using JWT authentication and JWK URI is not working




### Datasets

  * Fixed global OAuth mode on Azure dataset and Parquet file format

  * Fixed GCS dataset on Parquet file when using a Private Service Connect endpoint




### Cloud stacks

  * Fixed instance creation from a fresh Fleet Manager instance on Azure




### Charts and Dashboards

  * Fixed line disappearing in chart when refreshing the page while mouse cursor is on it

  * Improved dashboard performances while loading several tiles in parallel




### Macros

  * Fixed “Download(HTML) and “export” results options of the “delete old container images” macro




### Git

  * Fixed tag creation on a specific commit

  * Fixed https remotes with credentials support on notebook import

  * Fixed library display and notebooks list after importing a project with a https git reference configured from another instance




### Coding

  * Fixed possible instance hanging while using the `get_uploaded_file` wiki Public API method to fetch a large article attachment

  * Fixed error when clicking on ‘Edit in Notebook’ button of coding recipes




## Version 13.3.2 - January 15th, 2025

DSS 13.3.2 is a feature, performance and bugfix release

### LLM Mesh

  * **New feature** : added support of Upsert & Smart Sync modes for Azure AI Search in embedding recipe

  * Prompt Studio: added ability to compare prompts without inputs

  * Visual fine tuning (part of the Advanced LLM Mesh add-on): added ability to fine-tune Llama 3.1 8B and 70B instruct models

  * Vertex AI: added support for the experimental Gemini 2.0 Flash & Gemini 2.0 Flash Thinking Mode LLM completion models, including image inputs and, for the former, tool calling.

  * Local Hugging Face: added preset for Llama 3.3 70B

  * Fixed the OpenAI-compatible API usage on RAG-augmented models

  * Fixed inference of LLMs fine-tuned using the visual fine-tuning recipe

  * Fixed containerized execution of Code Agents leveraging project or instance libraries

  * Fixed possible file permission issues when using Qdrant Knowledge Banks previously rebuilt in append mode in Python

  * Fixed a possible race condition when the same user concurrently builds a local Knowledge Bank and uses Dataiku Answers

  * Fixed build of PII detection code environment on Python 3.8




### Machine Learning

  * Disabled XGBoost GPU support in containerized execution base image for a reduced image size (to use GPU support, use a code environment with GPU runtime addition)

  * Fixed ML tasks sometimes broken when the preparation script or underlying dataset is changed

  * Fixed training multi-series forecasting models when some series report a non-computable MAPE or SMAPE

  * Fixed scoring of plugin models using a class defined elsewhere than in the `algo.py` file

  * Fixed diagnostics listed in Lab settings for Causal, Clustering and Time series

  * Fixed abiding by selected diagnostics on Lab training of Causal models

  * Fixed ordering of Saved Models by name in the list




### ML Ops

  * Model comparison: fixed broken model links in column headers

  * Standalone Evaluation recipe for multiclass classification: added choice of weighting or not one-vs-all metrics averages across classes

  * Added possibility to download test report using Public API on a design node project

  * Fixed an error in API Designer when there is an API service associated with a deleted saved model

  * Fixed display of API Service package version details in the right panel

  * Fixed LLM evaluation row-by-row comparison tile in dashboards for dashboard-only users

  * Fixed possible model comparison issues with MLFlow imported models




### Charts and Dashboards

  * Fixed disabling filter panel in dashboards

  * Added memory protection against charts with large number of values on numerical axis with SQL engine

  * Fixed conditional formatting in exported pivot tables

  * Fixed date filters facets on DSS engine when “all values in sample” option is activated

  * Fixed cleared filters being reapplied on dataset tiles when navigating away and back to dashboard page

  * Fixed dashboard cross filters reactivation after having disabled them

  * Fixed numeric-as-alphanumeric filter facets to take into account other filters




### Governance

  * **New feature** : Added a method to retrieve a Govern client from `DSSClient`

  * Fixed display of Dataiku saved model versions metrics in the artifact page

  * Fixed negate operator in custom filters

  * Improved generation of blueprint version ids to avoid duplicates




### Datasets & Connections

  * **New feature** : Elasticsearch & Opensearch connection: added support for AWS OpenSearch serverless (including for Knowledge Banks)

  * Sharepoint: Fixed ability to select a site when the total number of sites is very large

  * Sharepoint: Fixed prepare recipe when input is a Sharepoint list

  * BigQuery: Fixed writing when connection is using global proxy and an automatic fast-write is not set

  * BigQuery: Added ability to use Private Service Connect endpoints

  * GCS: Added ability to use Private Service Connect endpoints




### Data Quality

  * Fixed SQL error when a dataset contains both “values in set” and another statistical rule such as “not empty”

  * Fixed too restrictive permission to compute metrics on folders using public API (Now requires only `Write project content`)




### Recipes

  * Prepare: Fixed possible memory overconsumption in the “Split text into chunks” step

  * Prepare: Fixed schema not being automatically updated when running with Spark engine

  * Join: Fixed error raised when having both a pre-join computed column and ignore-case matching option

  * Stack: Fixed post-filters not working on “origin column”

  * SQL Query: Fixed error when executing queries containing UNION




### Deployer

  * Fixed execution of webapp test steps from post-deployment hooks

  * Fixed auto-start of webapps after deployment

  * Fixed possible unnecessary rebuild of code environment with container runtime additions when deploying and preloading a bundle in an automation node

  * Fixed deployment status modal when deployment is very fast

  * Fixed project deployer links to webapps when the webapp name contains underscores

  * Fixed issues with node ids containing spaces




### Coding

  * **New feature** : Added OAuth support for Databricks Connect

  * **New feature** : Added ability to export a filtered view of a dataset using `Dataset.to_html` and `Dataset.raw_formatted_data`

  * Fixed long execution (more than 10 minutes) of `dkuWriteDataset` R method




### Elastic AI

  * Updated EKS plugin fixing GPU drivers installation




### Git

  * Added support for https remotes with credentials

  * Git merge: fixed failure when a commit contains an empty message




### Security

  * **New feature** : Added ability to limit the types of files that can be uploaded in wiki articles See [doc](<../security/advanced-options.html#advanced-options-restricted-types-wikis>) for more details




### Misc

  * Fixed “Random birds” and “Random cats” themes




### Azure OAuth2 Token Endpoint Update

Since version 13.3.2, any Azure OAuth2 connection configured in **global mode** must use the **v2.0** endpoint of Azure’s token service.

In Dataiku versions **≤ 13.3.1** , a valid token could be retrieved with or without the v2.0 endpoint. From version **≥ 13.3.2** , a valid token is **only** retrieved if v2.0 is included in the URL.

Example of required endpoint format: `` https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/token ``

Please ensure all Azure OAuth2 connections are updated to use the v2.0 endpoint to remain compatible with future Dataiku versions.

## Version 13.3.1 - December 19th, 2024

DSS 13.3.1 is a bugfix release

### Machine Learning

  * Time series forecasting: fixed descriptions for numerical extrapolation settings

  * Fixed bundling of fine-tuned LLM saved models

  * Improved code agent name validation

  * Fixed installation of the RAG code environment on Python 3.8

  * Fixed plugin agents not listed when using `list_llms()` python API




### Visual recipes

  * Fixed possible job error when using user-defined meanings




### Datasets

  * Fixed rebuild condition of SQL datasets




### Charts

  * Fixed In-Database charts when a default schema/catalog naming rule contains variables

  * Fixed `AVG` operator used in a user-defined aggregation function on SQL engines

  * Fixed migration of color groups on KPI charts




### MLOps

  * Fixed deployment of imported MLFlow model with User Isolation enabled

  * Improved temporary folders management for R- and Python-based API node endpoints




## Version 13.3.0 - December 5th, 2024

DSS 13.3.0 is a significant new release, with new features, bug fixes and performance improvements

### New Feature: Manual layout of Flow zones

It is now possible to manually define the layout of Flow Zones using drag-and-drop.

This needs to be enabled in the project settings by a project administrator.

### New Feature: Agents

You can now define your own Generative AI Agents, that can then be used in all LLM-enabled capabilities of Dataiku:

  * Prompt Studio

  * Prompt Recipe

  * Dataiku Answers

  * LLM Mesh API




Agents let you implement advanced logic in your Generative Applications, such as fully-dynamic tool usage, complex chains, corrective RAG, …

Agents can:

  * Be written by customers using Python code

  * Be written by customers using Python code and then packaged as Plugins for easy usage by non-coding users

  * Use plugins developed by Dataiku or third parties




### New Feature: Project Testing

Dataiku now provides facilities for performing easy and repeatable tests of projects.

The following types of tests can be automated:

  * Unit testing of Python code

  * Functional testing of Flow. You can specify reference input datasets, reference outputs, and play your whole Flow on the input to verify that the output matches




Tests are run through new scenario steps.

Tests can typically be run as part of an MLOps process on a QA automation node and test reports can be used as part of a sign-off process (through Deployer hooks or Govern).

### New Feature: Deploy models to Databricks Serving

It is now possible to deploy models trained in Dataiku to Databricks Serving endpoints through the Deployer.

### New Feature: AI Generate Recipe

The new “Generate Recipe” AI assistants allows users to easily create new recipes in the Flow, using natural language, by expressing their need.

### New Feature: AI Image Generation API

The LLM Mesh API now supports image generation.

The following image generation models are supported:

  * AWS Bedrock Titan Image Generator

  * AWS Bedrock Stability AI SDXL 1.0

  * AWS Bedrock Stability AI Stable Image Core & Ultra

  * AWS Bedrock Stability AI Stable Diffusion 3 Large

  * OpenAI DALL-E 3

  * Azure OpenAI DALL-E 3

  * Stability AI Stable Diffusion 3.0 & 3.0 Turbo

  * Stability AI Stable Image Core & Ultra

  * Google Vertex Imagen 3

  * Google Vertex Imagen 3 Fast

  * Locally-running Stable Diffusion 2.1

  * Locally-running Stable Diffusion XL

  * Locally-running Flux 1 Schnell




### New Feature: Governable items page and Governance Modal

In Govern, the governable items table now only displays items that are ready to be either governed or hidden. Those items are now grouped by item types (Projects, Saved Models, Saved Model Versions and Bundles). A new column has been added with the user who created the item, and actions have been grouped together in a single “Actions” column.

The governance modal was improved. Users can now specify how existing and future sub-items of the current one being governed will be governed. Those settings are also now available for edition in a new “Governance settings” tab in each Governed Item page.

### New Feature: Table customizations in Blueprint Designer and Custom Page Designer

NB: requires Advanced Govern

The definition of views in the Blueprint Designer has been simplified by removing the distinction between row views and card views. In the settings of a table it’s now possible to create different columns with custom names and mapping them to different views that may depend on the Blueprint of the item being displayed.

It’s also possible to “freeze” columns on both the left and the right of the table so that those columns remain visible while scrolling through the table horizontally.

It is now possible to include or not both the name and the workflow standard columns. The order of all columns may now be customized.

These customization abilities are found in both custom pages settings and in view components displaying references as tables.

### LLM Mesh

  * **New feature** : Upsert mode for Knowledge Bank. Knowledge Banks can now: append, overwrite, and, if a document identifier column is specified, Upsert or Smart Sync (upsert + remove entries not present in the input). Not supported for Azure AI Search nor Pinecone

  * **New feature** : Structured output; You can specify an expected JSON Schema (structured output) on text completion query in the API. This is compatible models with OpenAI, Azure OpenAI, Vertex Gemini, and experimentally on Hugging Face models

  * **New feature** : Tracing: The API responses and prompt recipe output bear more details on the different steps of completion and embedding calls, with steps, timings, and additional infomration for each step. The system is extensible, especially when using Agents.

  * **New feature** : Added support for Google Vertex Vector Search for Knowledge Banks

  * **New feature** : Experimental JSON mode support on compatible Local Hugging Face models

  * **New feature** : Any generic LLM can now be used for prompt injection detection

  * **New models** : Added support for the Meta Llama 3.2 models in the Local Hugging Face connection

  * **New models** : Added Claude 3.5 Haiku, Claude 3.5 Sonnet V2 and custom models to the Anthropic connection

  * **New models** : Added Claude 3.5 Haiku and Claude 3.5 Sonnet V2 to the AWS Bedrock connection

  * **New models** : Added Meta Llama 3.1, Meta Llama 3.2 3B, Mistral Large 2 and custom models to the Snowflake Cortex connection

  * Added ability to output the RAG sources separately from the LLM’s answer

  * Added ability to set the batch size on Embed recipes

  * Added ability to search for Prompt Studios & Knowledge Banks from the DSS search box

  * Added support for per-user OAuth authentication when using Azure AI Search for Knowledge Banks

  * Added support for tools calling on Vertex AI Gemini models

  * Added support for pydantic 2 when using `knowledge_bank.as_langchain_retriever()`

  * Added more structured details in audit logs when a guardrails error happens

  * Favored the safetensors format for local models over the pytorch format

  * Fine tuning recipe on OpenAI / Azure OpenAI: added full validation loss when available

  * Fine tuning recipe on Azure OpenAI: added choosing of the best checkpoint automatically

  * Removed Claude 1 models from the Anthropic connection (retired by Anthropic)

  * Removed Claude 1 & Meta Llama 2 13b-chat-v1 models from the Bedrock connection (retired by Bedrock)

  * Removed Meta Llama 2 70b, MTP-7B, MPT-30B models from the Databricks connection (retired by Databricks)

  * Fixed absence of RAG augmented models in the LLMs selector when the original model is fine-tuned

  * Fixed embedding recipe failing on empty content with newer versions of pydantic

  * Fixed formatting of the LLM output when using a RAG augmented model with “Do not print sources” option

  * Fixed incorrect token limit for some embedding models on Bedrock, Cohere, Snowflake, Vertex AI

  * Fixed possible partially missing information in resource usage logs when querying RAG augmented LLMs

  * Fixed broken output link to a Knowledge bank in the Flow’s right panel

  * Fixed possible broken Save when changing “Print document sources” on Knowledge Bank augmented model settings




### Machine Learning

  * Time series forecasting: improved interpolation to be more accurate to the specific time of the interpolated step within the interpolation period. The former method remains available as “Staircase” interpolation.

  * Time series forecasting: added support for PyTorch alternatives to MXNet

  * Time series forecasting: fixed seasonal trend training issue when using a Random hyperparameter search with python 3.8+

  * Added support for sparse matrices on K-Means & Mini-batch K-Means Visual AutoML Clustering tasks

  * Added support for Python 3.12 on Visual ML

  * Added support for Keras/Tensorflow Visual Deep Learning models with Python 3.11

  * Multiclass models: added choice of weighting or not one-vs-all metrics averages across classes

  * Fixed feature effect Dashboard tile

  * Fixed code environment incompatibility warning for bayesian search when using scikit-learn 1.5

  * Fixed What-if settings sometimes not opening on first click

  * Fixed What-if comparator display bug of feature importance when switching explanation method

  * Fixed display hyperparameter search optimization when switching between “higher is better” and “lower is better” metrics




### Datasets and Connections

  * **New feature** : Trino dataset

  * **New feature** : Push-down of random sampling to database on Snowflake and BigQueryis now executed in database for Snowflake and BigQuery datasets

  * Snowflake: Execute CREATE OR REPLACE COPY GRANTS instead of DROP + CREATE when building datasets

  * Databricks: Fixed issue where a dataset configured in SQL query mode would generate a schema with columns in uppercase

  * Athena: Added support for Athena JDBC 3.x driver

  * Oracle: Allow administrators to configure the characters limit for identifiers from the connection settings (defaults to 30)

  * S3: Fixed certificate verification issue that sometimes needed switching to path style

  * MongoDB: Added user & password fields when “Use advanced URI syntax” option is checked to prevent having them in clear text

  * Sharepoint: Fixed issue happening when a sharepoint list contains too many items

  * Editable: Added ability to use any row as column names, and not only the first one.

  * Editable: Added button to quickly remove empty rows or empty columns

  * Streaming: Now correctly handle tombstones (null) when reading Kafka streams

  * SQL: Added button to suggest existing schemas when prompting for one

  * SQL: Fixed issues when moving data from a database with high max string length to one with lower max string length




### Recipes

  * **New feature** : Group: Added support for median aggregations (SQL engine only)

  * Join: Fixed issue when using the same dataset as both left and right inputs and using a filter defined as a formula (would trigger an error when running the recipe using DSS engine)

  * SQL Query: Variables are now correctly substituted when displaying execution plan

  * SQL Query: Fixed issue preventing to validate and execute query when partitioning dimensions are not found on the target table due to casing mismatch

  * Download: Fixed variable expansion in the Path field

  * Fixed drop data confirmation modal not appearing when running a recipe in append mode or on a partitioned output dataset

  * Fixed entering of multiple explicit values for a time partition (ex: 2024-03-01,2024-03-02)




### Charts and Dashboards

  * **New Feature** : Conditional formatting on pivot tables

  * **New feature** : Added variance (sample and population) as aggregations for numeric columns

  * Finer Dashboard grid granularity for better control of tiles sizes

  * Added the ability to customize the spacing between tiles

  * Added the ability to lock tiles position in dashboards

  * Added the ability to use the same X for all pairs in Scatter Multi-Pairs

  * Added support for categorical Y axis in Scatter Multi-Pairs

  * Improved responsiveness of KPI tiles in dashboards

  * Improved color picker

  * Refined the ‘Connect the Points’ option for scatter plots to prevent connecting points having differing colors or shapes.

  * Improved overlapping detection for values labels in bar charts

  * Fixed dashboard tile resizing when displaying/hiding the header

  * Fixed responsiveness of dashboard tile headers

  * Fixed color picker in KPI chart conditional formatting

  * Fixed wrongful disabling of color scale logarithmic mode

  * Fixed manual edition of Y axis range option sometimes not appearing

  * Fixed percentile in gauge color ranges

  * Fixed explicit exclude filters not applied in exported dashboards

  * Fixed “Count of records” measure displayed as “NULL” in values formatting

  * Fixed values in charts to be above ref lines

  * Fixed the ability to export only current slide from dashboards




### LLM Evaluation

  * Added native support for prompt recipe output

  * Added “token per row” metrics for input and output

  * Added support for row-by-row LLM evaluation comparison in Dashboards

  * Added a “Test” button for Custom Metrics

  * Fixed bundle creation and project export when no LLM is defined in LLM-as-judge settings of this project’s LLM Evaluation Recipe.

  * Prevent creating LLM evaluation recipe without input dataset




### MLOps

  * Added the ability to export evaluation sample as a dataset from a Model Evaluation




### Statistics

  * Added ability to relax the variance equality assumption on 2-sample and pairwise t-test (Student t-test assumes equal variance, Welch t-test doesn’t)

  * Added ability to limit the comparison to a reference group in N-sample pairwise t-test and N-sample pairwise Mood test




### Scenarios and automation

  * Added ability to add descriptions to scenario steps

  * Added ability to restrict the sender field of mails to be the one of the user accounts running the scenarios.

  * Fixed wrongly successful scenario execution status despite failing project deployment steps




### Deployer

  * Added a view of WebApp statuses on the status page of a project deployment

  * Added support for setting a Service Account Name on K8S infrastructures

  * Added the ability to generate diagnostic for deployments that always failed

  * Added the possibility to reopen an ongoing deployment’s progress modal

  * Unified Monitoring: Added ability to customize Unified Monitoring interval

  * Prevented multiple deployment actions on the same deployment

  * Aborting deployment now actually interrupts the complete process, not just the current phase (pre-deployment hooks, deployment, post-deployment hooks)

  * Fixed post-deployment hook failure wrongfully failing the deployment

  * Fixed incorrect “deployment date” info in bundle and infrastructure pages for deployments that never succeeded

  * Fixed monitoring page on API service when the related Model Evaluation Store is deleted

  * Fixed latency computation on Static and K8S infrastructures when there are no requests




### API

  * Added an API method to clear Jupyter notebook’s outputs

  * Added an API method to read scenario steps logs




### Code Studios

  * Added Dash block to create Dash Webapps using Code Studios




### Webapps

  * Fixed issue where custom code creating files in the current directory would prevent Webapp from restarting correctly




### Git & Version Control

  * Added basic integrity checks on JSON configuration files when merging branches

  * Changed permission required to merge branches: “Write isolated code” permission remains required to merge branches but “Write unisolated code” permission is now only required if the merge would update unisolated code.




### Govern

  * Added custom filters to reference selection

  * Added support for the Embedding Recipe in the computation of “LLM” and “Ext. AI“ tags

  * Added visual indication in the blueprint designer when a condition is configured for a view component visibility

  * Added the ability to customize whether the sign-off widget comes above or below the other fields in a workflow step

  * Added a “Model Metrics” tab to the Governed model version page

  * Added the display of “Last modification date” info from DSS

  * Added a “Sensitive data” field on standard Governed Project

  * Added an “Edit Custom Page” button on Custom Pages to allow admins to go directly to this page’s settings

  * Fixed the refreshing of blueprint designer when deleting a hook

  * Fixed creation date in Govern for some DSS imported projects

  * Fixed the governance of an item sometimes failing when related items were already governed

  * Fixed sticky error panel on item save “cancel” action

  * Fixed sticky upload file error panel




### Jobs

  * Allowed searching jobs by their IDs in Jobs page

  * Added buttons to zoom in/out Flow in Jobs page

  * Fixed job diagnosis with very long job names

  * Fixed issue where admin properties would be being overridden by other variables




### Data Catalog

  * Added ability to search for a dataset or SQL table from the Data Catalog home page

  * Added ability to search for a dataset by its name in Data Collections

  * Fixed issue in Connection Explorer where using DSS as metastore for Hive dataset generates error in case some projects have been deleted




### Security

  * Added a new project security permission named “Edit permissions”. This permission allows users to add new groups/users to projects. Note that users with such a permission can only grant/remove permissions they have.

  * Added support for expiration dates to API Keys




### Elastic AI

  * Improved the “Remove old container images” macro to remove more left-overs

  * Fixed Kubernetes errors during service deployment when DSS username only contains digit characters

  * Reduce disk space usage of code env images

  * Fixed potential race condition when rebuilding code envs that could lead to containerized job failures




### Cloud Stacks

  * AWS: Added tags on EBS root volumes and subnets upon instance creation

  * AWS: Fixed slowness when connecting over SSH to an instance

  * Azure: Added tags on Network interfaces, VPCs, subnets and public IPs upon instance creation

  * GCP: Add tags on boot/OS disks, VPCs and subnets upon instance creation

  * GCP: Added option to encrypt the Fleet Manager disks using custom KMS key

  * Fixed potential race condition on reboot that would not correctly mount the volumes




### Misc

  * Project folders are now sorted by name on the “All Projects” page.

  * Removed Achievements from user profile page

  * Allow searching for managed folders by their name when configuring recipes

  * Wiki: Added button to generate a markdown table




## Version 13.2.4 - November 27th, 2024

DSS 13.2.4 is a bugfix release

### Dataset and connection

  * Fixed error when creating a GCS, BigQuery or Vertex AI connection if no private key file is set (in OAuth/Environment mode)

  * Fixed error when reading BigQuery tables with an ingestion time partitioning

  * Fixed charts on PostgreSQL and BigQuery engines if the underlying connection contains naming rules on the schema

  * Fixed Microsoft OneLake connection not properly closed resulting in possible user session limit error




### Machine Learning

  * Fixed possible training failure on causal regression models when the target distribution is partly concentrated on a single value

  * Fixed failures with local Hugging Face models / augmented LLMs when encrypted RPC is enabled

  * Fixed a possible race condition when a local Hugging Face model is used by multiple concurrent jobs




### Dashboards

  * Fixed dataset tile export when a date filter is set in the dashboard

  * Fixed ‘Load’ insight button when ‘Load insight when dashboard opens’ setting is disabled




### Governance

  * Fixed display of artifact role assignment rules in sign-off widget




## Version 13.2.3 - November 20th, 2024

DSS 13.2.3 is a feature, performance and bugfix release

### Machine Learning

  * Fixed feature handling UI in Clustering

  * Fixed display of some results in dashboards for users only having the “Read Dashboards” permission

  * Model Evaluation: Fixed prediction drift computation on binary classification when the threshold value has been changed




### Dataset and connections

  * GCS: JSON private keys are now encrypted in config

  * BigQuery: JSON private keys are now encrypted in config

  * BigQuery: Improved support for views based on partitioned BigQuery tables

  * Sharepoint: Fixed SharePoint dataset reading when written by DSS

  * Parquet: Fixed parsing of Parquet files containing nested arrays of objects

  * S3/GCS/Azure Blob: Added support for repeating dataset mode




### Visual recipes

  * Fixed recipes not displayed in flow if repeating mode is enabled without a driver dataset selected

  * Prepare: Fixed filters creation by right clicking on date columns

  * Spark: Improved warnings when non-optimal Spark operations take place




### Charts

  * Fixed charts on BigQuery when the dataset is in a project different from the one specified in the connection




### Jobs

  * Fixed “clear search” button in jobs list




### LLM Mesh

  * Increased default caching time for embeddings




### Coding

  * Improved performance when waiting for background tasks to complete (jobs, scenario, Visual ML) in Python API

  * Fixed dataiku-scoring python package when using Numpy > 2




### Governance

  * Fixed sign-off config editing for standard blueprint versions




### Cloud stacks

  * Improved automatic sizing of backend memory allocation when switching to larger instances




### Plugins

  * Fixed support for plugins not specifying explicitly ‘acceptedPythonInterpreters’ in their configuration




### Performance

  * Improved performance for project import / bundle import / app-as-recipe instantiation

  * Improved performance for reading data from Snowflake

  * Improved performance when deleting large amounts of datasets

  * Improved performance and fixed possible memory leak when performing a very large number of failing API calls on the REST API

  * Improved performance and throughput of sending events to the event server, fixing possible loss of events in very high load situations

  * Improved performance and reduced excessive logging for Unified Monitoring on both Deployer and Automation nodes, especially when a large number of deployments are not working




### Misc

  * Upgraded Snowflake JDBC driver to version 3.20

  * Fixed boot script permissions when installed with a restrictive umask

  * Added support for Suse 15 SP6

  * Reduced amount of logging in various places

  * Fixed missing API deployments in Unified Monitoring for API services created before DSS 11




## Version 13.2.2 - November 1st, 2024

DSS 13.2.2 is a feature, performance and bugfix release

### LLM Mesh

  * Added support for multimodal local models (Idefics2, Llava 1.6, Falcon2 11B VLM, Phi3 Vision)

  * Added `o1-mini` model to the OpenAI connection (experimental)

  * Added Gemma 2 2B & 9B local models

  * Added Llama Guard 1B and 8B as local options for Toxicity Detection. This feature is available in Private Preview as part of the Advanced LLM Mesh Early Adopter Program.

  * Added support for AWS OpenSearch Managed Cluster deployed with Compatibility Mode

  * Added support for redirections in a Huggingface model’s repository when using the DSS model cache

  * Fixed PII detection not performed on multipart messages’ text parts

  * Fixed some API/prompt parameters not properly taken into account on a RAG augmented model

  * Fixed an error in the Prompt studio when running a non-reusable prompt on a RAG augmented model

  * Fixed the Pinecone connection’s test button sometimes failing with a 401 error despite correct API key

  * Fixed tools calls failing when the `parameters` argument is explicitly set to `null`

  * Fixed schema propagation passing through a prompt, text classification, or text summarization recipe

  * Fixed query cancellation for local models

  * Fixed fine-tuning recipe on Bedrock when using a validation dataset




### Visual Machine Learning

  * Added the weighting method in prediction models report

  * Added ability to include the feature dependence plot for a given feature when exporting a model’s documentation

  * Added the anomaly score in API response when querying an isolation forest model

  * Fixed possible failing scoring of time series forecasting models trained before 13.2.0 and not retrained since

  * Fixed the redeployment of a partitioned model to the flow via API

  * Fixed the reproducibility of tree-based feature selection, and the possible error when ensembling models using it




### Dataset and Connections

  * Fixed ‘select displayed columns’ and ‘select sort column’ options in dataset explore if it is opened before dataset sampling is loaded

  * Sharepoint: Improved performance with large number of sites and drives

  * MongoDB: Fixed parsing of columns containing arrays of objects

  * Fixed Delta dataset sampling computation when reading through Spark

  * SQL: Fixed usage of project variables in post-connect statements




### Recipes

  * Prepare: Fixed UI of the Python processor when using row/rows mode

  * Prepare: Fixed discrepancy in translation of GeoDistanceProcessor

  * Fixed repeating mode on HTTP datasets

  * Improved error message with dynamic dataset repeat option if no “driver” dataset is selected




### Charts and Dashboards

  * Fixed alphanumerical filters on numerical columns shared via URL parameter when selecting all values and using the “include others” option

  * Fixed filters on numerical columns shared via URL parameter when selecting NO_VALUE and using the “Exclude others” option

  * Fixed filter sometimes wrongly created at the end of the filter list when dragging and dropping a column

  * Fixed dashboard filters on case-insensitive datasets

  * Fixed AVG aggregation on integer column to return a double rather than a truncated integer

  * Fixed custom aggregations on DSS engine when the formula appears to do a division by zero when executed on the dataset

  * Fixed “Comparison method violates its general contract!” error in charts happening in some specific situations.

  * Fixed the creation of dashboards from the “Add insight” modal in the insight edition page

  * Fixed the “Replace empty values by 0 / NA” option on pivot tables

  * Fixed broken Excel export of pivot tables when using a color dimension




### Data Quality

  * Fixed possible Arithmetic overflow when computing dataset metrics on SQLServer

  * Fixed issue when computing metrics on delta datasets with Spark engine




### Scenarios

  * Improved compatibility with custom templates when sending an email with a dataset in HTML format

  * Fixed possible broken scenario logs UI when scenario is using “Refresh statistics & chart cache” step




### MLOps

  * Added support of Python 3.6 code environments for MLflow export

  * Fixed handling of API node logs in the Evaluation Recipe when there are both “message.feature.proba_X” and “message.result.proba_X” (only consider “message.result” in this case)

  * Fixed MLflow authentication when nesting several calls to setup_mlflow




### Deployer

  * Fixed displayed projects names in Unified Monitoring for deployment created through the public API

  * Fixed external model status synchronization in Unified Monitoring after DSS restarts

  * Fixed external model status synchronization in Unified Monitoring when overwriting an existing saved model version

  * Fixed R API functions using code environments on Kubernetes deployments

  * Reduced the size of container image for Kubernetes deployments




### Governance

  * Added a shortcut for Governance Managers to edit the corresponding blueprint version directly from an artifact page

  * Fixed view mapping edition for computed references with no source

  * Fixed the creation of user when there are lots of users already registered




### Collaboration & Git

  * Fixed branch display of imported project previously exported without Git information

  * Fixed default branch after project duplication from the Project Version Control




### Elastic AI

  * Fixed Containerized DSS Engine if a plugin requires a R code environment

  * Fixed Scala notebook on Spark-on-Kubernetes

  * Fixed containerized execution on Conda R code environments

  * Fixed Hadoop HDFS dataset creation if there is a Kubernetes cluster configured on the instance

  * Fixed metastore synchronization in “DSS-as-metastore” mode on datasets containing string columns with a defined maxLength

  * Fixed propagation of user-provided CRAN repos when building the API deployer base image

  * EKS: Added a check against creating a cluster where all nodepools are tainted

  * EKS: Fixed support for Nvidia driver installation when using “advanced config” mode

  * GKE: Added ability to specify release channel

  * GKE: Added ability to add labels and taints on nodes




### Hadoop

  * Fixed possible failures reading all Parquet files




### Cloud Stacks

  * Azure: Fixed availability zone selection in instance creation form




### Performance & Scalability

  * Improved performance and scalability of ArrayFold processor

  * Improved performance for massive recipe creation

  * Improved performance for deleting vast amounts of objects

  * Fixed possible instance crash when validating some particular SQL queries




### Miscellaneous

  * Fixed “Code Studio” tab hidden for users only having the “Can update” template permission

  * Fixed cases of unusable webapps after bundle activation due to removed API keys

  * Fixed the ‘Alert Banner’ appearing in Dashboard and Flow exports

  * Fixed homepage display if one a project has corrupted permissions definition

  * Fixed displayed user profile in case user gets the fallback profile

  * Fixed a race condition when stopping a continuous activity

  * Fixed issues with long-running dataset reads when encrypted RPC is enabled




## Version 13.2.1 - October 16th, 2024

DSS 13.2.1 is a bugfix release

### LLM Mesh

  * Fixed usage of ElasticSearch and Azure AI Search vector stores for non-admin users




### MLOps

  * Fixed error when trying to deploy on an AzureML infrastructure using credentials from environment




### Webapps

  * Fixed webapp failures on imported projects, if their API keys had been deleted




### Coding

  * Fixed date support with infer_with_pandas=False when using code environments with Pandas 2.2

  * Fixed suggested numpy version when creating code environments with Pandas 1.0




### Cloud Stacks

  * AWS: Added support for il-central-1 region




### Misc

  * Fixed graphic exports when DSS is configured with ssl=true in install.ini

  * Fixed “Request new Python env” for Conda based environment




## Version 13.2.0 - October 3rd, 2024

DSS 13.2.0 is a significant new release with both new features, performance enhancements and bugfixes.

### New feature: Column-level Data Lineage

Column-level data lineage offers a new view that allows performing Root cause and Impact analysis on dataset columns:

  * When identifying a data-related issue, investigate the upstream pipeline to find where the data comes from.

  * Before performing any change on a dataset column, discover the potential impact on downstream datasets and projects.




For more details, please see [Data Lineage](<../data-lineage/index.html>)

### New feature: LLM evaluation recipe

Note

This feature is available in Private Preview as part of the Advanced LLM Mesh Early Adopter Program

When building GenAI applications, evaluating the quality of the output is paramount. The LLM evaluation recipe uses specific GenAI & LLM techniques to compute several metrics that are relevant to the specific cases of GenAI.

The metrics can be output to a Model Evaluation Store and compared across runs.

Individual outputs of the LLMs can also be reviewed and compared across runs.

### New feature: Delete & Reconnect recipes

From the Flow, you can now easily delete a recipe and reconnect the subsequent recipe, in order to avoid breaking the Flow.

For more information, please see [Inserting and deleting recipes](<../flow/insert-delete.html>)

### New feature: Microsoft Fabric OneLake SQL Connection

This new connection allows you to access data stored in Microsoft Fabric OneLake through Microsoft Fabric Warehouses.

### New feature: repeating mode for datasets

Some datasets now have the ability to “repeat” themselves based on the rows of a secondary dataset.

This feature allows for example to:

  * Create a files-from-folder dataset using only the files whose names come from a secondary dataset

  * Create a SQL dataset based on multiple tables whose names come from a secondary dataset




### New feature: repeating mode for SQL query recipe

The SQL query recipe can now execute several times, using variables subtitution with variables coming from a secondary dataset, to generate a single concatenated output dataset

### New feature: filtering & repeating mode for export recipe

The export recipe can now filter rows, and can now execute several times, using variables subtitution with variables coming from a secondary dataset.

This can be used to generate multiple export files, each containing a part of the data. For example, you can use this to create one file per year, one file per country, …

### New feature: Share projects by email

Project administrators can now grant permissions to access a project using an email address. If the email address does not match an existing user, an invitation email is sent and the permission grant is put on hold until their account is created.

This capability can be globally disabled by administrators.

### Upgrade notes

The following models, if trained using DSS’ built-in code environment, will need to be retrained after upgrading to remain usable for scoring:

  * Isolation Forest (AutoML Clustering Anomaly Detection)

  * Spectral clustering

  * KNN




### LLM Mesh

  * **New feature** : Support for ElasticSearch and OpenSearch as vector store for Knowledge Banks

  * **New feature** : Support for Azure AI Search as vector store for Knowledge Banks

  * **New feature** : Prompt injection detection with Meta PromptGuard. This feature is available in Private Preview as part of the Advanced LLM Mesh Early Adopter Program.

  * **New feature** : Added support visual fine tuning on AWS Bedrock and Azure OpenAI. This feature is available in Private Preview as part of the Advanced LLM Mesh Early Adopter Program.

  * **New feature** : Added JSON mode, to ask LLMs to output valid JSON. This is supported on OpenAI & Azure OpenAI (gpt-4o, gpt-4o-mini), Mistral AI (7b, small, large), and VertexAI (Gemini)

  * **New feature** : Added an OpenAI-compatible completion API to query any completion model of the LLM Mesh (including non-OpenAI ones) from systems and libraries compatible with custom OpenAI endpoints. It supports tools calling, streaming, image input and JSON output

  * Added ability to select a different column for RAG augmentation than the one that was indexed for retrieval

  * Added simplified code environment creation and update for local LLMs (Huggingface connection), RAG and PII detection

  * Added support for API parameters `presencePenalty`, `frequencyPenalty`, `logitBias`, `logProbs` on local Hugging Face models

  * Vertex AI: Added support for Gemini 1.5 Pro & Flash

  * Vertex AI: Added support for custom Vertex-supported models

  * Vertex AI: Added text & multimodal embedding models

  * Visual fine-tuning now selects the best checkpoint when fine-tuning with OpenAI and the latest checkpoint doesn’t improve on the validation loss

  * Visual fine-tuning can now use models from the model cache

  * Fixed support of LangChain shorthand syntax for tool choice when using the LangChain adapter for LLMs

  * Added variable expansion in Prompt studios & Prompt recipes




### Machine Learning

  * **New feature** : Added ability to specify monotonicity constraints on numerical features when using XGBoost, LightGBM, Random Forest, Decision Tree, or Extra Trees models on binary classification and regression tasks. This requires scikit-learn at least at version 1.4, which requires the use of a dedicated code env

  * `get_predictor` can now be used for visual AutoML models using an algorithm from a plugin

  * Improved performance for training and scoring of Isolation Forest models

  * Added support for the feature effects charts in the documentation export of a multiclass classification model

  * Added support for XGBoost ≥1.6 <2, statsmodel 14, sklearn 1.3, and pandas 2.2 when using python 3.9+

  * Added support for numpy 1.24 (python 3.8) and 1.26 (python 3.9+)

  * Improved display of prediction error for regression models: in the Predicted Data tab, the error is no longer winsorized (for newly trained models), and the Error distribution report page shows more clearly the winsorized chart

  * Fixed a possible display issue when unselecting a metric on the Decision chart for a model using k-fold cross test

  * Fixed a possible display issue of decimal numbers on the y axis of the prediction density when doing a What-If analysis on a regression model

  * Fixed the engine selection of a scoring recipe from the flow when the previously selected engine is not available anymore




### Datasets & Connections

  * **New feature** : ElasticSearch/OpenSearch: Added support for OAuth authentication

  * **New feature** : Excel: Added support for reading encrypted Excel files

  * Sharepoint: Added support for authentication via certificates, or user/password

  * Excel: Added ability to export datasets as encrypted Excel files

  * SCP/SFTP: Added support for SSH keys written in other formats than PEM RSA (notably the OpenSSH format)

  * SQream: Improved support of SQream regarding dates and other aggregation operations

  * S3: Added settings to configure STS endpoints for AssumeRole

  * Fixed issue where an empty user field in connections of type “Other databases (JDBC)” would yield connection failure even though user & password are provided in the JDBC URL or in the advanced properties.

  * Fixed issue where users could create a personal Athena connection using S3 connections whose details are not readable




### Recipes

  * Prepare recipe: Updated INSEE data and added possibility to choose the year of the reference data

  * Prepare recipe: Improved AI Prepare generation when asked to parse dates

  * Sync recipe: Fixed possible date shift issue with Snowflake input datasets when DSS host is not on UTC timezone

  * Download recipe: Added repeating mode to download multiple files using variables coming from a secondary dataset




### Charts and Dashboards

  * **New feature** : Added standard deviation as an aggregation for numeric column in charts

  * Added “display as percentage” number formatting option, i.e. 0.23 → 23%

  * Added “use parentheses” number formatting option for financial reporting, i.e -237 → (237)

  * Added “hide trailing zeros” number formatting option

  * Added support of percentiles aggregation for reference lines

  * Added number formatting options to use “m” instead of “M” as a suffix for Millions and “G” instead of “B” for Billions

  * Added the ability to display values in Lines and Mix charts

  * Fixed issues when dragging and dropping columns on filters (where the “ghost column” would remain visible)

  * Fixed flickering when dragging and dropping columns on filters

  * Fixed chart legend highlights sometimes not working when using number formatting options on axis.

  * Fixed filters in PDF export

  * Fixed tile size sometimes not properly computed when switching between view and edit mode

  * Fixed formatting pane not updating when changing binning mode

  * Fixed “Force inclusion of zero in axis” option in Lines and Mix charts

  * Fixed the ability to display pivot table despite reaching the objects count limit

  * Fixed Scatter multipair not refreshing when removing the X axis from the first pair, when there are more than 2 pairs




### Data Quality

  * New rule: “Column value in set”. This rule checks that a particular column only contains specific values and nothing else.

  * New rule: “Compare values of two metrics”. This rule checks that two metrics defined on this dataset or on another dataset have the same value, or that one value is greater than the other, etc.




### Scenarios

  * Disabling a step does not change its run condition anymore




### MLOps & Deployer

  * Added support for Release Notes in API services

  * Added a deprecation warning for MLflow version below 2.0.0

  * Added support of the Monitoring Wizard for Dataiku Cloud instances

  * Fixed an error when trying to build the API service package of an ensemble model for which one of the source models was deleted and uses a plugin ML algorithm.




### Labeling

  * **New feature** : the label can now be free text when labeling records (tabular data).

  * Fixed missing options when copying a single Labeling task in the Flow




### Coding & API

  * Databricks-Connect: Added support for Databricks serverless clusters




### Git

  * Added ability to choose the default branch name (main, master, …)

  * Added ability to resolve conflicts during a remote branch pull




### Governance

  * Added search for the page dropdown list

  * Added multi-selection to the project filter on main pages

  * Added LLM filter checkbox on Governed Projects page

  * Fixed synchronization of API deployments on external infrastructure

  * Fixed view mapping refresh issue in custom page designer

  * Fixed permissions to edit blueprint migrations




### Dataiku Applications

  * Added a notification on application instances when a new version is available




### Code Studios

  * Added ability to configure pip options for code envs in Code Studio Templates




### Workspaces

  * Fixed broken Dataiku Application link




### Elastic AI

  * EKS: Added ability to add cloud tags to clusters

  * Fixed issue where the test button in Containerized execution configs would not work when using encrypted RPC

  * HOME and USER environment variables are now set properly in containers

  * Fixed pod leak when aborting a containerized notebook whose pod is in pending state




### Cloud stacks

  * Azure: Switched from Basic SKU Public IPs to Standard SKU Public IPs

  * Azure: Added option to choose the Availability Zone when instantiating a DSS node, or creating a template

  * Azure: Added ability to choose in which Resource Group to store snapshots for a given instance

  * Python API: Added methods to start & stop instances from Fleet Manager




### Misc

  * Added ability to connect third party accounts (such as OAuth connections to databases) directly from the dataset page

  * Added ability to see the members of a group in Administration > Security > Groups

  * Added ability to control job processes (JEK) resources consumption using cgroups

  * Plugins: Added ability for plugin recipes to write into an output dataset in append mode

  * Cloudera CDP: Added support for Impala Cloudera driver 4.2

  * Fixed error occurring when copying subflow containing a dataset on a deleted connection

  * Fixed issue that prevents deleting or modifying a user when the configuration file of a project contains invalid JSON

  * Fixed issue where Compute Resource Usages (CRU) when reading SQL data on a connection could be wrongly reported as being done on another connection




### Performance

  * Worked around Chrome 129 bug that can cause failure opening DSS (“Aw, Snap!”)




## Version 13.1.4 - September 19th, 2024

DSS 13.1.4 is a bugfix release

### LLM Mesh

  * Fixed broken display of Azure OpenAI connection page when it has a multimodal chat completion deployment

  * Fixed excessive logging when embedding images




### Snowflake

  * Fixed Snowpark when the Snowflake connection uses private key authentication




### Charts

  * Fixed broken display of scatter plot with some Content Security Policy headers




## Version 13.1.3 - September 16th, 2024

DSS 13.1.3 is a feature, security and bugfix release

### LLM Mesh & Generative AI

  * **New feature** : Added ability to use image inputs in the Prompt Studio & Prompt Recipe

  * Bedrock: Added Mistral Large 2 to the Bedrock connection, including tools call

  * Bedrock: Added Llama 3.1 8B/70B/405B models to the Bedrock connection

  * Anthropic: Added Claude 3.5 Sonnet to the Anthropic connection

  * Databricks: Added Llama 3.1 70B/405B models to the Databricks Mosaic AI connection

  * Bedrock: Added support for image embedding with Amazon Titan Multimodal Embeddings G1

  * Added support of gpt-4o-mini in the Fine-tuning recipe

  * Sped up inference of some LLMs that use LoRA

  * Added count of input & output tokens for local model inference

  * Added support for finish reason in streamed calls, for compatible models/connections

  * Added support for presence penalty and frequency penalty in Prompt Studio & Prompt Recipe

  * Added support for cost reporting on streamed calls (except on Azure OpenAI, which doesn’t support it)

  * Reduced the number of training evaluations when fine-tuning a local model

  * Bedrock: Fixed a UI issue enabling/disabling the Llama3 70B model on a Bedrock connection

  * Fixed possible issues with enforcement on cached responses when calling the LLM Mesh API

  * Fixed possible issue displaying the embedding model on a Knowledge Bank’s settings




### Machine Learning

  * Added configurable “min samples leaf” parameters to he Gradient Tree Boosting algorithm

  * Time Series Forecasting: Improved API to change the forecast horizon on a time series forecasting task

  * Time Series Forecasting: Fixed possible failure of a time series forecasting training when using together “Equal duration folds” and “Skip too short time series” options with multiple time series

  * Time Series Forecasting: Fixed possible failure when using pandas 2.2+ with some algorithm/time steps combinations

  * Causal learning: Fixed possible training failure of causal model when using inverse propensity weighting with a calibrated propensity model

  * Fixed possible failure of a scoring recipe using the Spark engine in a pipeline with a model trained by a different user

  * Fixed display of a categorical feature in the Feature effects chart, when it only have numerical values

  * Fixed possibly broken display of trees on partitioned model details

  * Fixed possible issue with the ROC curve or PR curve plot when exporting a multiclass model’s documentation

  * Fixed possible scoring issue on some calibrated-probability classification models

  * Fixed failure to compute partial dependence plots on models with sample weights when the sample size is less than the test set size

  * Fixed failure to export model documentation when using time ordering and explicit extract from two datasets




### Statistics

  * Fixed failure on the PCA recipe when the input dataset has fewer rows than columns




### MLOps

  * Fixed Standalone Evaluation Recipe failing on classification task when using prediction weights

  * Fixed copy of Standalone Evaluation Recipes




### Charts & Dashboards

  * Added a “Last 180 days” preset to relative date filters

  * Fixed failure when loading static insights with names containing underscore ( _ )

  * Fixed dashboard tile resizing when showing/hiding page titles in view mode

  * Fixed percentile calculation when there are multiple dimensions in a chart

  * Changed the filters mode to be “Include other values” by default

  * Fixed some chart options sometimes being reset on chart reload

  * Fixed date filter selection in charts being lost after engine or sampling change

  * Fixed dashboard wrongly seen as modified when clicking on saved model or model evaluation report tiles

  * Fixed the loading of fonts in gauge charts within dashboards

  * Fixed gauge chart Max/Min with very small values

  * Fixed gauge and scatter charts not loading when there is a relative date filter in combination with either a gauge target or a reference line aggregation




### Governance

  * Added automated generation of step ID from the step name in the configuration of workflows

  * Added support for proxy settings for OIDC authentication

  * Added examples of Python logger usage and field migration to migration scripts

  * Added ability to collapse view containers

  * In the Blueprint Designer, added ability to search for fields by label or by ID when creating view components

  * Fixed upgrade when there are API keys without labels

  * Fixed deletion of reference from tables, to avoid selecting the deleted item in the right panel




### Webapps

  * Added ability to have API access for Code Studio webapps (Streamlit, …)




### Dataset and Connections

  * Fixed issue when building datasets using Database-to-Cloud fast paths with non-trivial partitions dependencies

  * Automatically refresh STS tokens when reading or writing S3 datasets using Spark




### Scenarios and automation

  * Fixed scenario variable `firstFailedJobName` incorrect initialization when a build step fails

  * Added option to prevent DSS from escaping HTML tags in dataset cells when a dataset is rendered as an HTML variable (Starting with DSS 13.1.0, HTML tags are escaped by default)

  * Fixed issue where DSS reads more than the maximum number of rows indicated in SQL scenario steps when the provided SQL query starts with a comment




### Deployer

  * Unified Monitoring: Fixed support for API endpoints deployed from automation nodes

  * Fixed code environment resources folder when deploying API services on Kubernetes infrastructures




### Coding

  * Added button in Jupyter notebook right panel to delete output (useful to clean notebooks containing large outputs without actually loading them)

  * Fixed ability to import the `dataiku` package without `pandas`

  * Added `int_as_float` parameter to `get_dataframe` and `iter_dataframes`

  * Added `pandas_read_kwargs` parameter to `iter_dataframes`




### Git

  * Fixed issue where creating a remote branch does not create a local branch

  * Fixed issue where pulling from a remote would fail if Git has been configured without an author




### Security

  * Fixed issue where DSS version is returned in HTTP response to non-logged users even when flag hideVersionStringsWhenNotLogged is set

  * Fixed credentials appearing in the logs when using Cloud-to-database fast paths between S3 and Redshift




### Cloud stacks

  * Fixed replaying long setup actions displaying an error in the UI, even though it actually completes successfully




### Performance & Scalability

  * Improved performance for `get_auth_info` API call




### Misc

  * Added support for storing encryption key in Google Cloud Secrets Manager

  * Fixed HTML escaping issues in project timeline with names containing ampersand (&) characters




## Version 13.1.2 - August 29th, 2024

DSS 13.1.2 is a bugfix release

### Coding

  * Fixed authentication failure when connecting using python client running inside DSS and connecting to another DSS running 13.0 and below.




### Spark

  * Fixed a failure on Spark jobs that need to retrieve credentials




## Version 13.1.1 - August 26th, 2024

DSS 13.1.1 is a security and bugfix release

### Recipes

  * Prepare recipe: Fixed failure when executing a “Compute difference between dates” step using SQL engine




### Coding and API

  * Fixed `as_langchain_*` methods in a non-containerized kernel on Knowledge Banks built by another user




### Security

  * Fixed authentication used by the Python client to connect to DSS, using Basic authentication instead of Bearer for backward compatibility with DSS versions 13.0 and below.

  * Fixed failure when enabling hashed API keys on upgraded Govern nodes

  * Fixed possible [directory traversal during provisioning of a DSS node by Fleet Manager](<../security/advisories/dsa-2024-006.html>).




## Version 13.1.0 - August 14th, 2024

DSS 13.1.0 is a significant new release with both new features, performance enhancements and bugfixes.

### New feature: Managed LLM fine-tuning

Note

This feature is available in Private Preview as part of the Advanced LLM Mesh Early Adopter Program

LLM Fine-tuning allows you to fine-tune LLMs using your data.

Fine-tuning is available:

  * Using a visual recipe for local models (HuggingFace) and OpenAI models

  * Using Python recipes for local models (HuggingFace)




For more information, please see [Fine-tuning](<../generative-ai/fine-tuning.html>)

### New feature: Gauge chart

The Gauge chart, also known as speedometer, is used to display data along a circular axis to demonstrate performance or progress. This axis can be colored to offer better segmentation and clarity.

### New feature: Chart median and percentile aggregations

Charts (and pivot tables) can now display median, as well as arbitrary percentiles of numerical values

### New feature: enhanced Python dataset read API

The Python API to read datasets has been enhanced with numerous new capabilities and performance improvements.

The new fast-path reading `Dataset.get_fast_path_dataframe` method performs direct read from data sources. This provides massive performance improvements, especially when reading only a few columns out of a wide dataset. Fast-path reading is available for:

  * Parquet files stored in S3

  * Snowflake tables/views




For regular reading, the following have been added:

  * Ability to disable some thorough data checking, yielding performance improvements up to 50%

  * Ability to read some columns as categoricals to reduce memory usage (depending on the data, can be up to 10-100 times lower)

  * Ability to use pandas “nullable integers”, allowing to read integer columns with missing values as integers (rather than floating-point values)

  * Ability to precisely match integer types to reduce memory usage (up to 8x for columns containing only tinyints)

  * Added ability to completely override dtypes when reading




For samples and documentation, please see the [Developer Guide](<https://developer.dataiku.com/latest/concepts-and-examples/datasets/datasets-data.html> "\(in Developer Guide\)")

### New feature: Builtin Git merging

In addition to the existing ability to push projects and branches to remote Git repositories and perform merges there, you can now perform Git merges directly within Dataiku, including the ability to view and resolve merge conflicts

### Behavior change: handling of schema mismatch on SQL datasets

DSS will now by default refuse to drop SQL tables for managed datasets when the parent recipe is in append mode. In case of schema mismatch, the recipe now fails. This behavior can be reverted in the advanced settings of the output dataset

### LLM Mesh

  * **New feature** : Added local models for toxicity detection (This feature is available in Private Preview as part of the Advanced LLM Mesh Early Adopter Program)

  * **New feature** : Added support for Tools calling (sometimes called “function calling”) in LLM API and Langchain wrapper. This is available for OpenAI, Azure OpenAI, Bedrock (for Claude 3 & 3.5), Anthropic, and Mistral AI connections

  * **New feature** : Added support for Gemma, Phi 3, Llama 3.1 8B & 70B, and Mistral NeMo 12B models on local Huggingface connection

  * Pinecone: Added support for Pinecone serverless indices

  * In API, added support for `presencePenalty` and `frequencyPenalty` for OpenAI, Azure OpenAI and Vertex

  * In API, added support for `logProbs` and `topLogProbs` for OpenAI, Azure OpenAI and Vertex (PaLM only)

  * In API, added support for `logitBias` for OpenAI and Azure OpenAI

  * In API, added `finishReason` to LLM responses, for LLMs/providers that support it

  * Added Langchain wrappers for embedding models in the public Python API (was already available in the internal Python API). Using the API client, you can now use the LLM Mesh APIs on embedding models with Langchain from outside Dataiku.

  * Added support for Embedding models in Snowflake Cortex connection

  * Improved API support for stop sequences on local models run with vLLM

  * Fixed issue in complete prompt display for RAG LLMs in Prompt Studio




### Machine Learning

  * Isolation Forest: Made training up to ~4 times faster (using parallelism and sparse inputs)

  * Isolation Forest: Added support for “auto” contamination

  * Model Documentation Export: Added support for “Feature effects” chart from feature importance

  * Added ability to not specify an image input features in What-if

  * Improved performance for training of partitioned models with large number of partitions

  * Improved cleanup of temporary data when retraining partitioned models (reduce disk consumption)

  * Improved pre-training validation of ML Overrides and Assertions

  * Fixed computation of optimal threshold on binary classification models using k-fold cross-test

  * Fixed inability to upload 2 different images as input features in What-if

  * Fixed possible broken forecasting models when a model forecasts NaN values

  * Fixed a possible issue when deleting a partitioned model’s version while it was being retrained

  * Fixed some notebook model exports when using scikit-learn 1.2




### MLOps

  * Added the possibility to do a full update in “Update API deployment” scenario step

  * Added the possibility to include or not editable datasets when creating bundles

  * Improved MLflow import code-environment errors reporting

  * Fixed the sorting on metrics in Model Evaluation Stores

  * Fixed the Monitoring Wizard to take into account deployment level auto logging settings




### Charts and Dashboards

  * Dashboards: Added background opacity settings for chart, text and metrics tiles

  * Dashboards: Added border and title styling options to tiles

  * Dashboards: Added title styling options to dashboard pages

  * Dashboards: Added the ability to hide dashboard pages

  * Dashboards: Improved loading performance

  * Dashboards: Fixed dashboard’s save button wrongly becoming active when selecting a tile

  * Filters: Added support for alphanum filter facets on numerical columns in SQL, and the possibility to include/exclude null values

  * Scatter plots: Improved axis format for dates by displaying time when range is less than a single day

  * Scatter plots: Increased max scale limit when zooming with rectangle selection

  * Pivot tables: Persist column sizes, as well as folded state of rows or columns

  * Line charts: Fixed the “show X axis” option in line charts with a date axis

  * Added support for numeric custom aggregations used in the chart in reference lines displayed aggregations

  * Added an “auto” mode for the “one tick per bin” option, automatically switching to the most appropriate mode depending on the number of bins

  * Fixed locked tick options (interval/number) after switching between charts

  * Fixed the “Add insight (Add to dashboard)” action for chart insights

  * Fixed Y axis title options disappearing in vertical bar charts when there are 2 or more measures

  * Fixed broken X axis when switching to a dimension that doesn’t support log scale from a dimension where it was supported and activated

  * Fixed empty dashboard wrongly considered as modified

  * Fixed dashboard’s insights associated to deleted datasets loading forever




### Governance

  * **New feature** : New Global Timeline: “Instance Timeline” page tracking all the item’s events

  * **New feature** : Custom filters are now available on all pages and various improvements were brought:

>     * Added ability to filter on application template and application instance flags
> 
>     * Added support for search on reference fields
> 
>     * Added ability to filter on node type and node ID
> 
>     * Added ability filter on DSS tags
> 
>     * Added ability to filter Model versions and Bundles on deployment stages
> 
>     * Added text search filter for all types of fields

  * Added execution of hooks on govern action

  * Added ability to copy/paste view components in the Blueprint Designer

  * Added an option in the Blueprint Designer to allow only selection, only creation, or both, on reference fields

  * Added visual indicators of settings validation in the Blueprint Designer

  * Added validation of blueprint versions forked from the standard to detect issues that could break standard govern features

  * Added the synchronization of DSS project’s “short description” field and the ability to search on it

  * Fixed history of deleted signoff

  * Fixed sticky error panel on next user action

  * Fixed artifact create permission to not imply read permission anymore




### Datasets and Connections

  * Fixed jobs writing multiple partitions on an SQL dataset failing when executed in containerized mode

  * Fixed an issue when navigating away from an ElasticSearch dataset before the sample is displayed




### Data Quality

  * Added ability to publish Data Quality status of a dataset or a project to a dashboard

  * Added multi-column support to column validity, aggregation in range/set & unique rules

  * Added ability to create, view and edit Data Quality templates

  * Fixed Metrics computed with spark on HDFS partitioned datasets producing incorrect results




### Flow

  * Added ability to rename a recipe directly from the Flow

  * Added ability to export the Flow documentation (without screenshots) when the graphics-export feature is not installed.

  * Added support for Spanish and Portuguese languages to AI Explain




### Recipes

  * **New feature** : Prepare: `val` / `strval` / `numval` formula functions now support an additional argument to specify an offset. This allows retrieving values from previous rows to compute for example sliding averages or cumulative sums. This feature is only available on the DSS engine.

  * **New feature** : Prepare: The new “Split into chunks” step can split a text into multiple chunks, with one new row for each chunk.

  * Prepare: Added a warning on recipes containing both Filter and Empty values steps, which might lead to unexpected output

  * Prepare: Fixed date difference step returning incorrect results on the Hive engine




### Scenario and automation

  * **New feature** : Ability to send datasets with conditional formating, directly inline in email body

  * Added a “Build flow outputs” option in scenarios

  * Added ability to build a flow zone in scenarios




### Deployer

  * **New feature** : added support for Snowflake Snowpark external endpoints in Unified Monitoring

  * Added governance status in Unified Monitoring

  * Added the possibility to define a specific connection for the monitoring of a managed infrastructure

  * Added the possibility to define an “API monitoring user” to support “per-user” connections in Unified Monitoring

  * Added support for labels and annotations in API deployer K8S infrastructure, optionally overridable in related deployments

  * Fixed the status of endpoints of external scopes in Unified Monitoring when there is an authentication issue

  * Fixed external scopes being monitored even when disabled




### Coding

  * Added methods to interact with SQL notebooks (`DSSProject.list_sql_notebooks`, `DSSProject.get_sql_notebook`, …)




### Code Studios

  * Streamlit: Fixed forwarding of query parameters




### Notebooks

  * Fixed HTML export of Jupyter notebooks with Python 3.7




### Security

  * Added ability to authenticate on the API using a Bearer token (in addition to Basic authentication)

  * Added the ability to store API keys in irreversible hashed form

  * Fixed refresh tokens being requested too often




### Cloud Stacks

  * Fixed HTTP proxy setup action not properly encoding passwords containing special characters

  * HTTP proxy setup action now sets the following environment variables: http_proxy, https_proxy and no_proxy, in addition to their uppercase equivalents

  * AWS: Switched to IMDSv2 to access instance metadata

  * Added ability to change the internal ports for DSS (not recommended, for very specific cases only)




### Misc

  * Reduced the number of notifications enabled by default for new users

  * Fixed AI services when using authenticated proxies

  * Fixed trial seats when using authenticated proxies




## Version 13.0.3 - August 1st, 2024

DSS 13.0.3 is a bugfix release

### Dataiku Applications

  * Fixed the “Download file” tile




### Charts

  * Fixed rectangle zoom when log scale option is enabled




### Spark and Kubernetes

  * Fixed Spark engine on Azure datasets when DSS is installed with Java 17




## Version 13.0.2 - July 25th, 2024

DSS 13.0.2 is a feature and bugfix release

### LLM Mesh

  * **New feature** : AWS Bedrock: Added support for Claude 3.5 Sonnet

  * **New feature** : AWS Bedrock: Added support for Mistral models (Small, 7B, 8x7B, Large)

  * **New feature** : AWS Bedrock: Added support for Llama3 models (8B, 70B)

  * **New feature** : AWS Bedrock: Added support for Cohere Command R & R+

  * **New feature** : AWS Bedrock: Added support for Titan Embedding V2 and Titan Text Premier

  * **New feature** : AWS Bedrock: Added support for image input on Claude 3 and Claude 3.5

  * **New feature** : OpenAI: Added support for GPT-4o mini

  * **New feature** : Added support for generic chat and embedding models on AzureML

  * Added ability to Test custom LLM connections

  * Added ability to clear Knowledge Banks

  * Improved performance of builtin RAG LLMs

  * Improved performance of PII detection

  * HuggingFace: Improved performance of HuggingFace models download

  * HuggingFace: Increase default number of output tokens when using vLLM

  * Gemini: Fixed spaces wrongfully inserted in some LLM responses when using Gemini

  * Snowflake: Fixed Snowflake LLM models listed even when not enabled in the Snowflake Cortex connection

  * Limited ChromaDB version to prevent issues with ChromaDB 0.5.4




### Dataset and Connections

  * **New feature** : Added support for YXDB file format

  * Fixed error message not displayed when previewing an indexed table on which users have no permission

  * Fixed scientific numbers written using the French format (example: “1,23e12”) not properly detected as “Decimal (Comma)” meaning

  * Disabled unimplemented normalization mode for regular expression matching custom column filter

  * Added statistics about length of alphanumerical columns in the Analyze dialog

  * Sharepoint built-in connection: Fixed UnsupportedOperationException returned for some lists

  * BigQuery: Added ability to configure connection timeouts

  * BigQuery: Added ability to include BigQuery datasets when importing/exporting projects or bundles.

  * BigQuery: Fixed error happening when parsing dates with timezone written using the short format (ex: “+0200”)

  * Athena: Fixed wrongful escaping of underscores in table names




### Flow

  * When building downstream, correctly skip Flow datasets or models that are marked as “Explicit build” or “Write protected”




### Recipes

  * Prepare: Improved wording of summary of empty values step when configured with multiple columns

  * Prepare: Fixed casting issue in Synapse/SQLServer when using a Filter by Value step on a Date column with SQL engine

  * Window: Disabled concat aggregation on Redshift as it is not supported by this database




### Charts and Dashboards

  * Fixed Scatter Multi-Pair chart with DSS engine for some combinations of sample size and “Number of points” setting

  * Fixed incorrectly enabled save button in unmodified chart insight

  * Fixed dataset insight creation from the insight page

  * Fixed filtering in dashboard insights from workspace

  * Fixed reference lines sometimes getting doubled on scatter charts




### Machine Learning

  * Multimodal models: Improved image embedding performance

  * Fixed serialization of very big models (>4GB)

  * Fixed possible UI slowness when a partitioned model has many partitions in its versions

  * Fixed possible UI issues when creating a clustering model with a hashed text feature

  * Fixed incorrect median prediction value for classification models with sample weights




### Coding and API

  * Added ability to retrieve the trial status of users with the Python API

  * Fixed DSSDataset.iter_rows() not correctly returning an error in case of underlying failure

  * Fixed x0b and x0c characters in data producing incorrect results when reading datasets using Python API

  * Fixed DeprecationWarning: invalid escape sequence warnings reported by Python 3.7/3.8/3.9 when importing dataiku package




### Code studios

  * Fixed Gradio block as webapp wrongly reported as timed-out after initial start

  * Fixed IDE block failing if python 3.7 is not available in the base image

  * Fixed Streamlit block failing with manual base image with AlmaLinux 8.10 when R is not installed




### MLOps

  * Fixed interactive drift score computation

  * Fixed endpoint listing on Azure ML external models when in “environment” authentication mode

  * Fixed text drift section when using interactive drift computation buttons

  * Lowered the log level for too verbose External Models on AzureML

  * Fixed support for “Trust all certificates” when querying the MLflow artifact repository

  * Fixed code environment remapping for Model Evaluations




### Webapps

  * Unified direct-access URL of webapps to /webapps/




### Deployer & Automation

  * Fixed inability to edit additional code env settings in automation node

  * Fixed failure installing plugins with code env without a requirements.txt file on automation node

  * In Unified Monitoring, added support for new monitoring metrics available on Databricks external scope

  * Fixed API service error when switching from “multiple generation” with hash-based strategy to “single generation”

  * Added output of the logs to apimain.log file for containerized deployments even when using the “redirect logs to stdout” setting

  * Fixed error notification after a successful retry of an API service deployment

  * Fixed API deployer infrastructure creation when there are missing parameters

  * Fixed support for “Trust all certificates” settings in deployer hooks




### Governance

  * Added the ability for an admin to invalidate the configuration cache

  * Prevent creation of items from backreference with blueprints that are not compliant with the backreference

  * Removed the “Open creation page” button for the creation of items from backreferences

  * Prevent the creation of Business Initiatives or Governed projects from inactive blueprint versions

  * Improved performances of table pages, especially when there is a matrix or kanban view

  * Fixed the typing of external deployments

  * Fixed disappearance of artifact table header when toggling edit mode




### Performance & Scalability

  * Fixed possible hang when changing connections on a non-responsive data source

  * Fixed possible failures starting Jupyter notebooks when the Kubernetes cluster has no resources available




### Security

  * Fixed DSS printing in the logs the whole authorization header (which might contains sensitive data) in case of unsupported authorization method

  * Fixed printing of the “token” field when using Snowpark with OAuth authentication




### Miscellaneous

  * Fixed deletion of API keys in the API Designer that could delete the wrong key

  * Added support for CDP 7.1.9 with Java 17




## Version 13.0.1 - July 16th, 2024

DSS 13.0.1 is a bugfix and security update. (12.6.5) denotes fixes that were also released in 12.6.5, which was published after 13.0.0

### LLM Mesh

  * Improved parallelism and performance of locally-running HuggingFace models




### Recipes

  * Join: Fixed loss of pre and post filter when replacing dataset in join (12.6.5)

  * Join: Fixed issue when doing a self-join with computed columns (12.6.5)

  * Prepare: Fixed help for “Flag rows with formula” (12.6.5)

  * Prepare: Fixed failing saving recipe when it contains certain types of invalid processors (12.6.5)

  * Stack: Fixed addition of datasets in manual remapping mode that caused issues with columns selection (12.6.5)




### Charts & Dashboards

  * Re-added ability to view page titles in dashboards view mode (12.6.5)

  * Fixed filtering in dashboard on charts with zoom capability (12.6.5)

  * Fixed possible migration issue with date filters (12.6.5)

  * Fixed migration issue with alphanum filters filtering on “No value” (12.6.5)

  * Fixed filtering on “No value” with SQL engine (12.6.5)

  * Restore larger font size for metric tiles (12.6.5)

  * Fixed display of Jupyter notebooks in dashboards (12.6.5)

  * Added safety limit on number of different values returned for numerical filters treated as alphanumerical (12.6.5)

  * Fixed migration of MIN/MAX aggregation on alphanumerical measures




### Scenarios and automation

  * Added support for Microsoft teams Workflows webhooks (Power Automate) (12.6.5)




### Code Studios

  * Fixed Code Studios with encrypted RPC




### Cloud Stacks

  * Fixed Ansible module dss_group




### Elastic AI

  * Re-add missing Git binary on container images




### Performance

  * Fixed performance issue with most activities in projects containing a very large number of managed folders (thousands) (12.6.5)

  * Improved short bursts of backend CPU consumption when dealing with large jobs database (12.6.5)

  * Fixed possible unbounded CPU consumption when renaming a dataset and a code recipe contains extremely long lines (megabytes) (12.6.5)

  * Visual ML: Clustering: Fixed very slow computation of silhouette when there are too many clusters (12.6.5)




### Security

  * Fixed [Insufficient permission checks in code envs API](<../security/advisories/dsa-2024-005.html>) (12.6.5)




### Misc

  * Fixed Dataset.get_location_info API

  * Fixed sometimes-irrelevant data quality warning when renaming a dataset (12.6.5)

  * Fixed EKS plugin with Python 2.7 (12.6.5)

  * Fixed wrongful typing of data when exporting SQL notebook results to Excel file (12.6.5)




## Version 13.0.0 - June 25th, 2024

DSS 13.0.0 is a major upgrade to DSS with major new features.

### Major new feature: Multimodal embeddings

In Visual ML, features can now leverage the LLM Mesh to use embeddings of images and text features

### Major new feature: Deploy models to Snowflake Snowpark Container Services

In the API deployer, you can now deploy API services to Snowpark Container Services

### Major new feature: Databricks Serving in Unified Monitoring

Databricks Serving endpoints can now be monitored from Dataiku Unified Monitoring

### LLM Mesh

  * **New feature** : Added support for token streaming on local models (when using vLLM inference engine)

  * Added Langchain wrappers in the public Python API (was already available in the internal Python API). Using the API client, you can now use the LLM Mesh APIs from Langchain from outside Dataiku.

  * Added ability to share a Knowledge Bank to another project

  * Added ability to use a custom endpoint URL for OpenAI connections

  * Added ability to deep-link to a prompt inside a prompt studio

  * Added support for embedding models in SageMaker connections

  * Improved error reporting when a call to a RAG-augmented model fails

  * Faster local inference for Llama3 on Huggingface connections

  * Misc improvements to the prompt studio UI

  * Show a job warning when there were errors on some rows of a prompt recipe

  * Fixed erroneous accumulation of metadata when rebuilding a Qdrant Knowledge Bank

  * Fixed Flow propagation when it passes through a Knowledge Bank

  * Fixed RAG failure when using Llama2 on SageMaker

  * Fixed raw prompt display on custom LLM connections




### Machine Learning

  * **New feature** : Added the HDBSCAN clustering algorithm.

  * Improved Feature effects chart (in feature importance) by coloring the top 6 modalities of categorical features.

  * Sped up computation of individual prediction explanations and feature importance.

  * Sped up retrieval of the active version of a Saved Model with many versions.

  * Fixed possible hang when creating an automation bundle including a Saved Model with many versions.

  * Fixed unclear error message in scoring recipe when the input dataset is too small to use as background rows for prediction explanation.

  * Fixed incorrect number of cluster for some AutoML clustering models.

  * Fixed incorrect filtering of time series when a multi-series forecasting model is published to a dashboard.

  * Fixed a rare breakage in feature importances on some models.




### Charts & Dashboards

  * **New feature** : Added MAX and MIN aggregations for dates (as measures in KPI and pivot table charts, in tooltips and in custom aggregations)

  * **New feature** : Added the option to connect the points on scatter plot and multi-pair scatter plot

  * Added grid lines in Excel export

  * Added grid lines for cartesian charts

  * Added ability to configure max number of points in scatter plots

  * Added ability to customize the display of empty values in pivot tables

  * Added ability to set insight name for charts

  * Improved loading performance of charts with date dimensions

  * Fixed update of points size in scatter plots

  * Fixed rendering of charts when collapsing / expanding the help center

  * Fixed dimensions labels on treemaps

  * Fixed cache for COUNT aggregation

  * Fixed “link neighbors” option in line charts with SQL engine

  * Fixed “show y=x” option on scatter plot

  * Fixed dashboard’s filters when added directly after a dataset

  * Fixed “all values” filter option with SQL engine

  * Fixed dashboard filters when using mixed cased columns names on a database which is case insensitive on columns names

  * Fixed excluding cross-filters for numerical dimensions using “Treat as alphanumerical”

  * Fixed link to insight from dashboards included into workspaces

  * Improved Scatter plot performance

  * Fixed filtering on “No value” in alphanunerical filters with in-database engine

  * Fixed dashboard’s filters migration script

  * Fixed intermittent issue on Chrome browser which prevents rendering of Jupyter notebook in dashboards

  * Fixed error when disabling force inclusion of zero option in time series chart




### Datasets

  * **New feature** : Sharepoint Online connector. DSS can now connect to Microsoft Sharepoint Online (lists and files) without requiring an additional plugin

  * Updated MongoDB support to handle versions from 3.6 up to 7.0, including Atlas and CosmosDB

  * Added read support for CSV and Parquet files compressed with Zstandard (zstd)

  * Added experimental support for Yellowbrick in JDBC connection




### Data Quality

  * **New feature** : Added ability to create templates of Data Quality rules to reuse them across multiple datasets




### MLOps

  * **New feature** : Added text input data drift analysis (standalone evaluation recipe only), relying on LLM Mesh embeddings

  * **New feature** : Added model export to Databricks Registry

  * Added the ability to create dashboard insights from the latest Model Evaluation in a Model Evaluation Store

  * Added the possibility to use plugins code environments in MLflow imported models

  * Added support for global proxy settings in Databricks managed model deployment connections

  * Added support for MLflow 2.13

  * Fixed incorrect ‘python_version’ field in MLflow exported models

  * Fixed listing of versions on Databricks registries when the model has a quote in its name

  * Fixed incorrect warnings in Evaluation recipe’s dataset diagnosis




### Flow

  * Added ability to build Flows even if they contains loops




### Recipes

  * Stack: Fixed wrong schema when stacking two datasets both containing a column of type string but with different maximum length




### Deployer

  * API Deployer: Added a ‘run_test_queries’ endpoint in the public API to execute the test queries associated with a deployment.

  * Projects Deployer: Added the ability to define “additional content” also in the default configuration of bundles (not just directly on existing bundles)

  * Unified Monitoring: Added support for Unified Monitoring on automation nodes

  * Unified Monitoring: Added Data Quality status in Unified Monitoring

  * Unified Monitoring: Endpoint latency now displays 95th percentile

  * Unified Monitoring: display projects names rather than keys

  * Unified Monitoring: Fixed possible issue when opening project details

  * API designer: Fixed API designer test queries hanging in case of test server bootstrap failure

  * Added the ability to define environment variables for Kubernetes deployments

  * Added an “External URL” option for Project & API deployer infrastructures.

  * API Node: Added new commands to apinode-admin to clean disabled services (services-clean) and unused code environment (__clean-code-env-cache).




### Governance

  * **New feature** : Added ability to set filters on workflow and sign-off statuses

  * **New feature** : Added ability to use “negate” conditions in filters

  * **New feature** : Added visibility conditions based on a field for views

  * **New feature** : Added ability to add additional role assignment rules at the artifact level

  * Removed the workflow step prefix to use only the step name defined in the blueprint version

  * Improved the display of the Dataiku instance information

  * Added project’s cost rating to the overview

  * Fixed multi-selector search filters

  * Fixed possible deadlock in hooks

  * Fixed artifact creation to be possible with just creation permission

  * Fixed file upload being cancelled on browser tab change

  * Fixed password reset for Cloud Stacks deployments




### Statistics

  * Time series: when using Quarter or Year granularity, added ability to select on which month to align




### Coding

  * Added support for Pandas 2.0, 2.1 and 2.2

  * Added support for conda for Python 3.11 code environments

  * Fixed write_dataframe failing in continuous Python for pandas >= 1.1

  * Upgraded Jupyter notebooks to version 6




### Code studios

  * Improved performance when syncing a large number of files at once

  * Added support for ggplot2 in RStudio running inside Code Studios




### Elastic AI

  * EKS: Added support for defining nodegroup-level taints




### Cloud Stacks

  * Azure: Fixed deploying a new instance from a snapshot if the disk size was different from 50GB

  * Added more information (Ansible Facts) for use in Ansible setup actions




### Dataiku Custom

Note: this only concerns Dataiku Custom customers

  * Added support for the following OS

    * RedHat Enterprise Linux 9

    * AlmaLinux 9

    * Rocky Linux 9

    * Oracle Linux 9

    * Amazon Linux 2, 2023

    * Ubuntu 22.04 LTS

    * Debian 11

    * SUSE Linux Enterprise Server 15 SP5




### Security

  * Disabled HTTP TRACE verb

  * Fixed LDAP synchronization correctly denying access to DSS to a user that is no longer in the required LDAP groups but failing to synchronize the DSS groups for this user.




### Misc

  * Switched default base OS for container images to AlmaLinux 8

  * Fixed a rare failure to restart DSS after a hard restart/crash occurring during a configuration transaction

  * Plugin usage now takes shared datasets into account

  * Added audit message for users dismissing the Alert banner

  * Fixed relative redirect for standard webapps

  * Fixed failure with non-ascii characters in plugin configuration and local UIF execution

---

## [release_notes/14]

# DSS 14 Release notes

## Migration notes

### How to upgrade

  * For Dataiku Cloud users, your DSS will be upgraded automatically to DSS 14 within pre-announced timeframes

  * For Dataiku Cloud Stacks users, please see upgrade documentation

>     * [For Cloud Stacks AWS users](<../installation/cloudstacks-aws/dss-upgrade.html>)
> 
>     * [For Cloud Stacks Azure users](<../installation/cloudstacks-azure/dss-upgrade.html>)
> 
>     * [For Cloud Stacks GCP users](<../installation/cloudstacks-gcp/dss-upgrade.html>)

  * For Dataiku Custom users, please see upgrade documentation: [Upgrading a DSS instance](<../installation/custom/upgrade.html>).




Pay attention to the warnings described in Limitations and warnings.

### Migration paths to DSS 14

>   * From DSS 13: Automatic migration is supported, with the restrictions and warnings described in Limitations and warnings
> 
>   * From DSS 12: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 11: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 10.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 9.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 8.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 7.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 6.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 5.1: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 5.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 4.3: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 4.2: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 4.1: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.1 -> 4.2](<old/4.2.html>), [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * From DSS 4.0: Automatic migration is supported. In addition to the restrictions and warnings described in Limitations and warnings, you need to pay attention to the restrictions and warnings applying to your previous versions. See [4.0 -> 4.1](<old/4.1.html>), [4.1 -> 4.2](<old/4.2.html>), [4.2 -> 4.3](<old/4.3.html>), [4.3 -> 5.0](<old/5.0.html>), [5.0 -> 5.1](<old/5.1.html>), [5.1 -> 6.0](<old/6.0.html>), [6.0 -> 7.0](<old/7.0.html>), [7.0 -> 8.0](<old/8.0.html>), [8.0 -> 9.0](<old/9.0.html>), [9.0 -> 10.0](<old/10.0.html>), [10.0 -> 11](<11.html>), [11 -> 12](<12.html>), [12 -> 13](<13.html>)
> 
>   * Migration from DSS 3.1 and below is not supported. You must first upgrade to 5.0. See [DSS 5.0 Release notes](<old/5.0.html>)
> 
> 


### Limitations and warnings

Automatic migration from previous versions is supported (see above). Please pay attention to the following cautions, removal and deprecation notices.

### Cautions

#### Dataiku Cloud Stacks: OS upgrade

For Cloud Stacks setups, the OS for the DSS nodes has been updated from AlmaLinux 8 to AlmaLinux 9.

Custom setup actions may require some updates

Cgroups have moved from V1 to V2. Most configurations (including the out-of-the-box configuration) are migrated automatically. Some specific configurations may require a manual update.

#### Dataiku Cloud Stacks: Removal of old Python versions

Cloud Stacks setup do not include Python 3.6, Python 3.7 nor Python 3.8 anymore by default. All these Python versions are deprecated, and we advise you to upgrade remaining code still using them.

If you need to maintain support for one of these Python versions, setup actions have been added to reinstall these versions, and can be configured in your Instance Template in Fleet Manager.

#### Container images: OS upgrade

The OS for container images has been updated from AlmaLinux 8 to AlmaLinux 9. Custom Dockerfile additions may require some updates (either if you build customized base images, or when using custom “container additions” in code envs)

#### Prebuilt container images: Removal of old Python versions

The Dataiku prebuilt container images do not include Python 3.6, Python 3.7 nor Python 3.8 anymore by default. All these Python versions are deprecated, and we advise you to upgrade remaining code still using them.

However, at the level of each code env, a “Container runtime addition” has been added to easily re-add, on a per-code-env basis, support for them.

On Dataiku Cloud Stacks, these container runtime additions are automatically added to existing code envs running one of these Python versions.

#### Dataiku Custom: Bump of minimal Java version

Dataiku now requires Java 17.

No action is required on Dataiku Cloud Stacks and Dataiku Cloud. On Dataiku Custom, you may need to install Java 17 prior to upgrading to Dataiku 14.

#### HuggingFace LLM: Minimal required Python version

(Since 14.3.0)

Local Hugging Face connection now requires Python 3.10, 3.11 or 3.12.

#### Removal of Llama 3.2 11B Vision

(Since 14.3.0)

Llama 3.2 11B Vision is not supported anymore, and can be replaced with Qwen-2.5 VL 7B or MiniCPM-o 2.6

#### Dataiku Govern: permission name change

(Since 14.4.0)

The “Govern Manager” global permission is renamed to “Govern Architect” to avoid confusion with “Governance Manager” user profile. The legacy `mayManageGovern` key in the public API is deprecated and will be removed in DSS 15.

#### XGBoost GPU support on the builtin code environment

(Since 14.5.0)

XGBoost ML models that use the builtin code environment in uncontainerized execution cannot use the GPU for training or scoring, and will fallback to CPU, resulting in possibly slower execution. If needed, you can use containerized execution with a GPU, or retrain this model using a code environment compatible with Machine Learning.

#### Removal of instance-wide wikis list

(Since 14.5.0)

The instance-wide wikis list page has been removed. Admins can still promote wiki pages on the home page (Administration > Settings > Home page > Promoted content).

### Support removal

Some features that were previously announced as deprecated are now removed or unsupported.

  * Support for R 3.6

  * Support for MLFlow < 2

  * Support for Python 3.6 and 3.7 for the builtin environment. Builtin environments using these versions will be automatically upgraded. Note that code envs can still use Python 3.6 to 3.8 but these are deprecated

  * Support for Java 11

  * Support for Red Hat Enterprise Linux 7.x

  * Support for CentOS 7.x

  * Support for Oracle Linux 7.x

  * Support for Debian 10.x

  * Support for Ubuntu 18.04

  * Support for SuSE 12

  * Support for SuSE 15 SP4 and below




In addition, the following plugins have been removed and cannot be used anymore with DSS 14:

  * Data Anonymizer. It was superseded long ago by [Column Pseudonymization](<../preparation/processors/column-pseudonymization.html>).

  * Deep Learning on Images. It was superseded long ago by [Computer vision](<../machine-learning/computer-vision/index.html>).

  * Feature Factory / Events Aggregator. It was superseded long ago by [Generate features](<../other_recipes/generate-features.html>).

  * Model drift monitoring. It was superseded long ago by [Drift analysis](<../mlops/drift-analysis/index.html>).

  * NLG Tasks. It was superseded long ago by [Generative AI and LLM Mesh](<../generative-ai/index.html>).

  * OpenAI GPT. It was superseded long ago by [Generative AI and LLM Mesh](<../generative-ai/index.html>).

  * Both Forecast plugins. It was superseded long ago by [Time series forecasting](<../time-series/time-series-forecasting.html>).

  * MeaningCloud NLP (MeaningCloud does not exist anymore). See [Text & Natural Language Processing](<../nlp/index.html>) for alternatives.

  * Crowlingo Services NLP. See [Text & Natural Language Processing](<../nlp/index.html>) for alternatives.

  * Advisor

  * HubSpot

  * Looker Query Connector

  * namR Store

  * Natif Intelligent Document processing

  * Oncrawl




### Deprecation notices

DSS 14 deprecates support for some features and versions. Support for these will be removed in a later release.

  * Support for Python 3.8. As a reminder, Python 3.6 and 3.7 are already deprecated.

  * Govern: Support for PostgreSQL 12, 13 and 14

  * Time Series Forecasting: support for MXNet-based algorithms

  * Support for MLLib

  * Support for AmazonLinux 2

  * KSQL recipes

  * In API deployer infrastructure, “Reporting to Graphite” and “Metrics charting server” settings are now deprecated and will be removed in a future version. They have been replaced by native chart support




In addition, the following plugins are deprecated and will be removed in a later release:

  * List folder Contents. It is superseded by [List Folder Contents](<../other_recipes/list-folder-contents.html>).

  * Azure AD Sync. It is superseded by [Azure AD](<../security/authentication/azure-ad.html>).

  * EMR clusters and Dataproc clusters. The underlying support for these has been removed from DSS.




## Version 14.5.1 - April 22nd, 2026

DSS 14.5.1 includes bug fixes, security fixes and performance enhancements.

### Spark

  * Fixed credential refresh on Spark job targeting cloud storage connections




### Code studio

  * Fixed Bokeh app crashes when debugging in code studio with auto-refresh enabled




### Coding

  * Fixed personal API keys creation for AI Access users

  * Added Python API methods to create blank webapps




### Cloud stacks

  * Fixed broken log display in provisioning modal

  * Prevented possible conflicting letsencrypt configuration when upgrading DSS




### Dataiku Stories

  * Fixed Dataiku Stories themes settings display on automation node




### Security

  * Fixed [Improper flow zone name sanitization](<../security/advisories/dsa-2026-004.html>)




### Misc

  * Fixed Jupyter session logs cleanup macro on active notebooks

  * Fixed personal credential screen for AI Access users




## Version 14.5.0 - April 14th, 2026

DSS 14.5.0 is a major release with new features, bug fixes and performance enhancements.

### New feature: Extract structured fields from documents

The Extract Content recipe now includes an “Extract fields” mode. It allow you to define the structure of data that you’d like to extract from documents in a managed folder.

For instance, you may want to make a dataset from the date, sender, object and recipient of a set of letters. Or, from a set of invoices, a dataset containing both global information about invoices (id, due date, total amount) and per-line information (item, price, quantity, …).

For more details, please see: [Extracting document content](<../other_recipes/extract-document-content.html>).

### New feature: Agent Logging

Agents can now directly write their activity (queries and responses, including traces) to a Dataiku dataset.

This makes it easy for Agent builders and operators to monitor, debug, and audit agent activity across various contexts, including Prompt recipes, Agent Hub, Webapps or LLM Mesh API.

The output dataset is fully compatible with Agent Evaluation, allowing a very easy build of a complete monitoring loop.

### New feature: Claude Code in Code Studios

Claude Code is now directly available in Code Studios, either routing through the LLM Mesh or leveraging an existing Claude subscription.

For more details, please see [Claude Code coding agent](<../ai-assistants/claude-code.html>).

### New feature: Process Mining

Process Mining is a new application that lets you discover, analyze, and optimize your business processes directly from event log data — without manual interpretation. Use it to visualize actual process flows, identify bottlenecks, analyze execution variants, and share findings across your organization.

For more details, please [Process Mining](<../process-mining/index.html>).

### New feature: Python Documentation portal

Dataiku now automatically generates API documentation pages for all of your Python code in project libraries. This makes it easy to discover and reuse Python libraries, by providing a centralized and searchable view.

Documentation is accessible both from a dedicated instance-level view, and directly within Python code recipes and webapps during editing.

### New feature: Leverage existing external Vector Stores

It is now possible to create a Knowledge Bank that leverages an existing index/collection in supported Vector Stores.

This is currently supported in Azure AI Search, Elasticsearch, OpenSearch, Milvus, and Pinecone.

### New feature: Per-user SSH authentication for Git

Users can now create SSH key pairs in DSS or import an existing private SSH key for interaction with remote Git repositories. Existing global keys are still supported.

### Agentic AI & RAG

  * **New feature** : Agent Tools: A new Image Generation tool for your Agents

  * **New feature** : Agent Tools: A new Generate Artifact tool lets your Agent generate documents

  * **New feature** : Added support for multi-turn conversations in Agent Evaluation recipe

  * Agents: Added an Agent setting to control the maximum number of iterations of the agentic loop

  * Agents: Added protection against unbounded cross-agent recursions

  * Agents: Code Agents: Added built-in testing in Code Studios

  * Agent Tools: Model Predict now returns the probabilities (for classification models) or interval (for regression models with uncertainty)

  * Knowledge Banks: added support for project variables in static filtering values

  * Knowledge Banks: the `DSSKnowledgeBank.search` API now accepts a `filter` argument to search with filter conditions

  * Knowledge Banks: added support for non-ASCII characters in column names with Milvus vector stores

  * Knowledge Banks: Azure AI Search, Elasticsearch, Milvus remote, OpenSearch, Vertex AI Search: Added ability to choose the vector similarity search metric

  * Code Agent & Python Code Tool have a new option to declare dependencies

  * Structured Agents: added a PDF output option to the Generate Artifact block

  * Structured Agents: improved reliability of the Routing block in LLM Dispatch mode

  * Structured Agents: improved reporting of errors in a Python block

  * Structured Agents: improved “next block” in Agentic Loop blocks

  * Structured Agents: fixed a display issue when 2 blocks have the same ID

  * Structured Agents: fixed deletion of sub-clauses in an AND clause

  * Structured Agents: fixed possible failures in Agents mixing multiple LLMs

  * Structured Agents: fixed “Set Scratchpad” block when used inside a Parallel block

  * Structured Agents: fixed link of a new block created from another block with a customized name

  * Agent Tools: improved reliability of built-in tools when used by some older / less advanced LLMs

  * Agent Tools: fixed display of tools usage by Structured Agents

  * Agent Tools: fixed an issue on some local MCP tools that take no input

  * Agents: fixed computation of usage tokens in the OpenAI-compatible API

  * Document Extraction: fixed raw text extraction of PDF files containing bookmarks without page information, when OCR is disabled

  * Knowledge Banks: fixed static filtering form with multivalued filters on a column

  * Knowledge Banks: Milvus: fixed RAG code env with Python 3.12

  * Added ability to configure the [Additional Request Context](<../agents/additional-request-context.html>) in a Prompt Recipe

  * Added cost and token usage metrics to the Agent Evaluation recipe




### LLM Mesh

  * Added a new `response.prepare_followup()` Python API to easily prepare the next query for multi-turn work. For a streamed query, use `streamer = query.execute_streamed(collect_response=True)`.

  * Bedrock: added support for structured output (for models that support it in Bedrock)

  * Local models: added support for Qwen 3.5, Qwen 3 Coder, NVIDIA Nemotron

  * Local models: improved inference speed of reranking models, and added support for Qwen3 rerankers, NVIDIA llama-nemotron-rerank-1b-v2, bge-reranker-v2-gemma, mxbai-rerank-large-v2

  * Local models: added ability to configure reasoning effort

  * OpenAI: added support for gpt-5.4 (including mini & nano)

  * Anthropic, Azure Foundry, Bedrock: fixed Anthropic models compatibility with Structured Agents or with some external API clients

  * Snowflake Cortex: improved compatibility of structured output with some complex schemas

  * Improved handling of errors when streaming responses in the API, with an explicit error chunk

  * OpenAI, Azure OpenAI, Azure Foundry, Azure LLM, NVIDIA NIM: added ability to forward elements of the [Additional Request Context](<../agents/additional-request-context.html>) as custom headers

  * Added ability, in API calls, Prompt Studio and an Agent’s or Retrieval-Augmented LLM’s test Chat, to pass client headers to the [Additional Request Context](<../agents/additional-request-context.html>)

  * Fixed handling of legitimately empty LLM responses in Prompt Studio & Agents Chat

  * Bedrock: fixed usage by some external clients via the OpenAI-compatible API

  * Plugin LLM connections: added support for reranking




### Machine Learning

  * **New feature** : Added ability to write custom feature preprocessing as plugins for easy reuse by others

  * Improved default settings for multiclass Logistic Regression

  * Time Series Forecasting: added support for Negative binomial distribution on torch-based DeepAR & Simple Feed-Forward models

  * Time Series Forecasting: fixed computation of feature importance on forecasting models in the Flow

  * Time Series Forecasting: fixed missing per-fold data when exporting metrics

  * Time Series Forecasting: fixed usability of partitioned forecasting models when some partition’s forecast quantiles contain NaN values

  * Fixed optimized (java) scoring of multiclass Logistic Regression models trained with scikit-learn ≥ 1.5 and using one-versus-rest




### AI assistants

  * Flow Assistant now supports continuous conversations, to continue working after the first plan execution




### Charts and Dashboards

  * Charts: Fixed computed number of bins on SQL databases

  * Charts: Fixed the persistency of color scale mode when switching to a chart and back to pivot table

  * SQL notebooks: Added ability to run charts on SQL

  * Fixed chart creation with the In-Database engine on SQL datasets when the user has read-only access to the underlying schema




### MLOps

  * Added support for MLFlow `logged-model` API in Experiment Tracking

  * Fixed empty evaluation stores deletion

  * Added ability to change model evaluation store display parameters using public API




### Code studios

  * **New feature** : Added ability to Run & debug managed webapps directly in Code Studios

  * Avoided __pycache__ folder creation in Code Studio workspace

  * Fixed VSCode blocks installing Copilot by default when upgrading existing templates

  * Fixed synchronization not detecting conflicts on files without extensions




### Governance

  * Added the ability to upload custom logos for Govern blueprints and blueprint versions

  * Added a governcli utility for administration and maintenance tasks (similar to dsscli)

  * Fixed field creation to save automatically when the “enter” key is pressed

  * Fixed conditional display of action buttons outside of a container

  * Fixed action button when an error is raised from the action code

  * Fixed file download and PDF export when using non-ASCII characters in file names

  * Fixed Show More/Less twitching for shrunk texts




### Stories

  * Added ability to adjust font sizes for specific parts of text within a single text box

  * Added ability to create Stories on automation nodes

  * Fixed moving and resizing slide elements

  * Fixed issues with text boxes and z-index on PPT exports

  * Fixed moving multi selection




### Datasets and Connections

  * **New feature** : Databricks Lakebase connection

  * Users can now copy dataset data from the Explore view to the clipboard

  * Snowflake: Fixed custom OAuth2 proxy settings not being applied to the authorization code flow

  * Databricks: Fixed storage path escaping with automatic fast write

  * Databricks: Fixed decimal support with automatic fast write

  * Trino: Added configurable catalog for Trino cloud unload operations

  * Oracle: Fixed excessive cursor creation when writing data with null values

  * Oracle: Fixed some character set mismatch errors in Oracle with CASE statements

  * Kafka: Added Basic authentication support to schema registry connections

  * HTTP: Fixed DSS failing to read HTTP datasets when responses are gzip-compressed.




### Flow

  * **New feature** : Display description of Flow zones in the Flow




### Recipes

  * **New feature** : Containerized DSS engine for visual recipes can now run multiple recipes within a single container, to reduce overheads

  * **New feature** : Automatic fallback from Spark to DSS engine at runtime when processing small datasets, reducing overhead from unnecessary Spark jobs.

  * Prepare: Fixed country code resolution conflicts (ISO-3166-2 versus FIPS 10-4). This fixes zipcode resolution in Switzerland

  * Join: Fixed validation failure when non-join columns contained arrays or maps, even though execution succeeded

  * Fixed SQL engine when input is partitioned and “add origin column” is enabled

  * Fixed building datasets using “Redispatch partition” mode with multiple partition dimensions




### Scenarios

  * Scenario steps can now be color-coded for improved readability and organization

  * Fixed weekly scenario triggers that could run before the configured “Starting From” date

  * Fixed scenario runs that could incorrectly appear as aborted while still initializing

  * Fixed scenario steps triggering another scenario not failing properly when the sub-scenario (custom Python) failed to start




### Deployer

  * Fixed automation node not creating a new code environment version when container execution hooks were modified in a bundle

  * Added an option in project deployment infrastructure to merge project’s “Authorized objects” settings upon deployment update




### Webapps

  * Added support for Server-Sent Events (SSE) on FastAPI webapps

  * Fixed webapp backend failures when disabling users

  * Fixed Shiny webapps not terminating properly upon DSS shutdown

  * Fixed HTTP to HTTPS redirect issue upon first visit after DSS startup

  * Fixed Code Studio webapps when nginx block is used in the template

  * Fixed rare race conditions in preview loading

  * Fixed containerized Webapps unexpectedly shutting down after 24 days

  * Fixed incorrect HTTP 405 responses returned for unauthorized requests to Webapps

  * Removed the limit of 100 concurrently running Streamlit Webapps per DSS instance




### Coding & API

  * Fixed delete_file Python function when folder targets a Databricks volume

  * Improved editable file type detection in code editors




### Git

  * Fixed checking out branches with subpaths in project version control




### Enterprise Asset Library

  * **New feature** : Added ability for all users to store prompts in their own personal collection “My assets”

  * Users can now mark prompts as favorites for easier access and reuse




### Elastic AI

  * Kubernetes executions now default to allowPrivilegeEscalation=false

  * Kubernetes pods now disable automatic service account token mounting by default

  * Kubernetes jobs now support DSS variable expansion in labels and annotations, enabling dynamic configuration

  * Fixed GKE cluster startup failures caused by newer google-auth library versions

  * Fixed Python recipe failures on K8S clusters with readOnlyRootFilesystem policy when containerized execution custom properties are enabled

  * Added support for variable expansion in Gateway API exposition

  * Added a field in API Gateway exposition to force the hostname or IP address to use

  * Fixed API deployment testing not using extra headers defined in API Gateway exposition




### Collaboration

  * Workspaces: Added a view mode (list or tiles) in workspaces

  * Workspaces: Added ability for admins to pin content at the top

  * Workspaces: Added a metadata right panel and tags support




### Dataiku Applications

  * **New feature** : Added dynamic dropdown (dataset based)

  * Added support for markdown and images in application titles

  * Improved visibility condition and made sections collapsible

  * Fixed failures in metastore synchronization that could break Dataiku Application instance upgrades




### Cloud Stacks

  * GCP: Added support for n4 instances with hyperdisk

  * AWS: Fixed incorrect DNS deletion when updating Load Balancer

  * AWS: Use GP3 volumes by default for newly created disks

  * Azure: Fixed DNS lookup failing for overly long domain names

  * Azure: Use Premium SSD for the data disks instead of Standard HDD (deprecated)




### Misc

  * Fixed possible instance slowness on project export and project duplicate

  * Fixed triggerParams plugin component params option when name contains dashes

  * Added macro to clean dku-workdirs folders related to Jupyter notebook runs

  * Fixed race condition causing error in job status polling




## Version 14.4.4 - April 3rd, 2026

DSS 14.4.4 includes bug fixes.

### Flow

  * Fixed display on flow zones involving loops




### Webapps

  * Fixed display of plugin webapps for user with read content permission only




### Datasets and connections

  * Hugging Face: Fixed connection creation from UI on Dataiku Cloud




### Dashboard

  * Dashboards: Fixed display of involved dataset in filter panel




### Misc

  * Fixed R integration script

  * Fixed migration when dip.properties is read only

  * Fixed Containerized DSS Engine with read-only root filesystem on GKE cluster with gatekeeper

  * Fixed possible socket leak when using custom Filesystem providers




## Version 14.4.3 - March 19th, 2026

DSS 14.4.3 includes new capabilities and bug fixes.

### Agentic AI & RAG

  * Structured Agents: The scratchpad is now included in the trace

  * Structured Agents: For Each blocks now support dict input/output

  * Structured Agents: For Each & Parallel blocks now support all output handling modes

  * Structured Agents: Reflection block now supports CEL expansion in expectation/synthesis instructions, and can route differently when critique failed or passed

  * Structured Agents: a Plugin Custom Block is now easy to create within a Development Plugin

  * Structured Agents: Fixed display of the diagram after switching versions

  * Structured Agents: Fixed dependency on another Agent

  * Structured Agents: Fixed duplicated messages in Parallel block

  * Structured Agents: Fixed compatibility of tool call IDs with some older models

  * Structured Agents: Fixed an issue where installing a plugin with custom agent blocks would reset the state of all agents

  * Structured Agents: Fixed display in Agent review setting

  * Extract Content & Embed Document recipes: These recipes can (and by default for text extraction, do) detect whether a PDF is scanned, to perform OCR

  * Extract Content & Embed Document recipes: Fixed possible issue on OCR extraction when using Raw text extraction

  * Milvus (remote): Fixed performance of Hybrid search

  * Milvus (remote): Fixed forwarding of RRF parameters when used by a Retrieval-Augmented LLM

  * Added support for OpenSearch 3.X for vector stores




### LLM Mesh

  * The OpenAI-compatible API endpoints now supports the Responses API

  * Anthropic: Added Claude Opus & Sonnet 4.6

  * Azure Foundry: Added Claude Opus & Sonnet 4.6

  * Azure Foundry: Fixed grok, LLama, DeepSeek and Mistral models

  * Bedrock: Added Claude Opus & Sonnet 4.6

  * Local Hugging Face: Fixed startup of some models without tool-calling capabilities

  * OpenAI: Added GPT 5.1 Codex Mini, 5.1 Codex Max, 5.2 Codex, 5.3 Codex

  * MCP (remote): Added support for global proxy settings

  * MCP (remote): Improved compatibility with some MCP servers using HTTP streaming

  * Prompt Studio: Fixed unbounded size of logged completion response, now truncated

  * Prompt Studio: Fixed possible failure if an agent is updated while a run is ongoing




### Machine Learning

  * Feature importance now includes the target on time series forecasting models with external features

  * Fixed export of a time series forecasting model’s feature importance to a Dashboard




### MLOps

  * Fixed Evaluate recipe tagging

  * Agent review: added a date filter in Agent Review history screen




### Charts and Dashboards

  * Charts: Fixed duplicated sorting option when reusing the same measure in tooltips

  * Dashboards: Fixed pie chart tooltip on dashboard after a drill down

  * Charts: Fixed setting non integer bin size

  * Charts: Added a “Selected only” display option in filter

  * Charts: Avoid instance crash when building charts with lot of dimensions




### AI assistants

  * Fixed “Cmd + Enter” shortcut on notebook when SQL assistant is opened




### Stories

  * Fixed shapes fill colors




### Governance

  * Improved search result loading time

  * Fixed “Show more” / “Show less” button in text field of a custom page




### Dataset and Connections

  * Added ability to remap connection when importing tutorial, business solution or learning project

  * Added option to disable temporary table for Snowflake / BigQuery / Databricks for management of date with “/” in CSV




### Data Quality

  * Fixed computation of unique values rule on SQL partitioned datasets




### Flow and Visual Recipes

  * Fixed default data-steward support in Flow Document Generator




### Deployer

  * Fixed bundle deployment containing API designer endpoint using a shared model




### Dataiku Application

  * Fixed “Run code” tiles when not the first tile




### Webapps

  * Allowed up to 100 streamlit apps running concurrently on one DSS instance with local engine

  * Fixed issue where a user with low permission visiting a webapp makes it unavailable for all




### Coding & API

  * Added support for programmatic creation of Prompt recipes: `project.new_recipe(type="prompt")`




### Elastic AI

  * Allowed creating gateways API exposition in arbitrary namespaces




### Data Catalog

  * Fixed UI not refreshing when removing a data collection




### Cloud stacks

  * Azure: added NVME compatibility flag on image definitions




### Misc

  * Fixed display of “By” column in plugin store

  * Fixed top navigation bar when reaching Global Usage summary from Global Finders

  * Fixed SPNEGO authentication initialization




## Version 14.4.2 - March 4th, 2026

DSS 14.4.2 includes new capabilities and bug fixes.

### Agentic AI & RAG

  * **New feature** : Support for Milvus Server and Zilliz vector stores

  * **New feature** : Chroma, Milvus Local, QDrant, Faiss: Added ability to choose the vector similarity search metric (Cosine, Euclidean, Dot Product)

  * Agent Review: Added a heatmap view in the history tab to track individual test performance across runs

  * Agent Evaluation: Added support for Structured Agents

  * Structured Agents: Fixed possible error when computing the dependencies of a misconfigured Structured Visual Agent

  * Structured Agents: Fixed human approval usage in Core Loop block

  * Structured Agents: Fixed duplicated `DKU_MANAGED_TOOL_CALL` in the trace when using a Mandatory Tool Call block

  * Structured Agents: Fixed block renaming with invalid characters

  * Structured Agents: Fixed slow initial load of Tools with large numbers of tools

  * Structured Agents: Fixed a display issue in Routing block

  * Structured Agents: Fixed subsequent turn “Smart mode”

  * Agents are now a separate object type in wikis

  * Added option to fail a completion query when RAG did not retrieve any document

  * Fixed document extraction using a custom code environment that does not yet have the docling models

  * Fixed a possible display issue when configuring a Plugin Agent

  * Fixed import of projects exported using Plugin Agents or Plugin Tools that are not available on the current instance

  * Fixed Knowledge Bank link in request center

  * Added ability to share AI agents and agent tools to other projects from project security page




### LLM Mesh

  * OpenAI, Azure OpenAI, Azure Foundry: Added customizable default reasoning effort (connection-level setting)

  * Anthropic: Added streaming support

  * Huggingface: Added support for reasoning effort parameter on GPT-OSS models

  * Fixed possible LLM connection remapping issues when importing a project

  * Fixed human approval and management of additional request context in Prompt Studios




### Machine Learning

  * Improved precision of feature importance on multiple-horizon time series forecasting models

  * Fixed training error when enabling early stopping on a time series forecasting model




### Charts & Dashboards

  * Charts: Added the ability to drill up on native chart drill downs

  * Charts: Added support for “keep first” and “keep last” options for unaggregated measure on SQL engine

  * Charts: Fixed error when all data is filtered out on unaggregated charts

  * Charts: Fixed chart sorting options not updating after renaming a measure

  * Charts: Fixed custom sorting settings not updated after sampling changes

  * Charts: Fixed UI in measure widget when displayed in INSIGHT

  * Dashboards: Added support for native drill down

  * Dashboards: Fixed export delay for webapp and web content dashboard tiles

  * Dashboards: Fixed dashboard refresh notifications being sent for disabled scenario steps

  * Dashboards: Fixed exported dashboard filenames when using non-ASCII characters

  * Dashboards: Fixed reload of dataset tiles after scenario-triggered dashboard updates

  * Dashboards: Fixed dragging large tiles in group tiles




### Datasets and Connections

  * **New feature** : added a Duplicate connection option in the connection admin screen

  * Fixed data shift when using Cells selection with Excel file format

  * Fixed error in log when deleting a file in managed folder on Sharepoint

  * Added a manual filter in AI search

  * Fixed the “Total size” refresh button for External datasets

  * Fixed Denodo connection

  * Fixed wrong table name when using a custom JDBC connection with SparkSQL dialect

  * Fixed Parquet on S3 when bucket has an invalid Top-Level Domain




### Dataiku application

  * Fixed required permission to save and execute a “Run Code” tile




### Enterprise Asset Library

  * Added ability to customize import settings when creating a project from company store




### Flow

  * Fixed previous dataset focus when returning to the flow

  * Fixed display of flew views when applied on a zoomed flow zone

  * Fixed isolation of previous flow zone state between browser tabs




### Visual recipes

  * Join: Fixed post filter on DSS engine when using unmatched output

  * Export: Improved error message with failing exporter on containerized DSS Engine




### Stories

  * Improved Stories Assistant adherence to chart type requests

  * Fixed Stories Assistant sometimes creating elements on top of each other

  * Fixed user input dropdown options

  * Fixed inconsistent handling and formatting of empty and null values in charts and filters

  * Fixed “Start from zero” setting in line charts

  * Fixed hierarchy filters




### Collaboration

  * Data Collections: Fixed Data Collection permissions UI

  * Enterprise asset library: Improved prompt edition dialog




### Coding & API

  * Fixed Python recipe initial code when creating from a multi selection in the flow and involving a saved model

  * Fixed saving of non-shared code samples for non-admin users

  * Fixed list of code environment usages when there is an unknown agent tool type in a project




### Code studio

  * Fixed support of case sensitive Kubernetes labels

  * Fixed possible hang when deploying a template on some Kubernetes clusters




### Webapps

  * Fixed web app access through its project url for users with access only to the webapp (and not the entire project)




### Notebooks

  * Improved SQL autocompletion

  * Fixed “Replace SQL and run” button in SQL assistant running all queries




### Elastic AI

  * Improved error message when an OutOfMemory error occurs on containerized execution

  * Prevented saving containerized execution config without name

  * Added support of Gateway API to expose API services

  * Added API endpoints for “(Re)install Jupyter Kernels”, “Remove Jupyter Kernel” admin actions

  * Fixed pod template customization through `spark.kubernetes.executor.podTemplateFile` property




### Cloud stack

  * Added nginx log rotation in FM and DSS images




### Performance & Scalability

  * Fixed possible hang when using a Labeling Task on a very large dataset




### Miscellaneous

  * Improved display of warnings and errors on project import

  * Fixed project export when a SQL notebook references a deleted connection

  * Fixed a caching issue that could show a “DSS version mismatch” dialog multiple times

  * Added support for Suse 15 SP7

  * Added a retry mechanism for network errors when acquiring an OAuth token

  * Fixed possible error when refreshing a plugin settings page

  * Improved LDAP synchronization robustness against non-standard LDAP server behavior to prevent intermittent group-resolution error and incorrect fallback profile




## Version 14.4.1 - February 20th, 2026

DSS 14.4.1 is a maintenance release that includes bug fixes and security improvements.

### Flow

  * Prevented unnecessary SQL dataset rebuild after instance upgrade.




### Datasets and Connections

  * Fixed issue where a temporary SharePoint token could be displayed when an export failed.

  * Fixed the Database Explorer for HDFS connections.




### Hadoop

  * Added support for CDP 7.3.1 SP3.




### Dashboards

  * Fixed the “Continue without saving” option when leaving an unsaved dashboard.

  * Fixed issue where the first row could be incorrectly positioned in existing dashboards with a title.




### Code Studios

  * Fixed issue when building Jupyter blocks using the “Use a code environment from a block in this template” mode.




### Machine Learning

  * Fixed the TensorBoard view when using a Python 3.12 code environment.




### Administration

  * Fixed incorrect cgroup initialization when Dataiku Stories is installed.




### Security

  * Fixed sensitive Webapp information exposed to Webapp read-only users. See [DSA-2026-003](<../security/advisories/dsa-2026-003.html>).




## Version 14.4.0 - February 9th, 2026

DSS 14.4.0 is a major release with major new features

### New Feature: Structured Visual Agents

While the standard Visual Agent provides a quick, autonomous tool-calling loop for simple tasks, Structured Visual Agents introduce a high-precision, block-based environment for complex AI orchestration. This feature allows builders to move away from purely autonomous behaviors toward deterministic, reliable agent flows.

Structured Visual Agents feature:

  * Block-Based Orchestration: Design complex logic using modular blocks for tool calling, routing, and parallelism.

  * Advanced Flow Control: Implement loops, repeat patterns, and conditional logic to strictly define how an agent moves between tasks.

  * Reliability & Reflection: Build in self-reflection steps and validation gates to ensure output quality and reduce hallucinations.

  * Structured memory: Control cross-turn conversation memory for structured interaction

  * Hybrid Flexibility: Extend visual logic with custom Python blocks for advanced processing




For more details, please see [Structured Visual Agents](<../agents/structured-visual-agents/index.html>).

### New Feature: Human-in-the-loop approval for Visual Agents

Visual Agents (both simple visual agents and structured visual agents) can explicitly ask user for confirmation before calling tools that may perform sensitive actions. This feature is controlled on a tool-by-tool basis. End-users are presented with explicit action confirmations that are fully traced and audited.

### New Feature: Agent Review

Agent Review is a dedicated environment for Agent Builders and Subject Matter Experts (SMEs) to collaboratively test, validate, and monitor agent performance. It streamlines the iterative design process by enabling structured testing against business requirements, ensuring agents deliver accurate and reliable outcomes before deployment.

Agent Review features:

  * Collaborative Review: Dedicated interface for Builders and SMEs to review agent runs, rate answers, and annotate results to drive improvements.

  * Structured Testing: Create and manage comprehensive test suites with queries, reference answers, and expected behaviors.

  * Automated Evaluation: Define “LLM-as-a-judge” traits to automatically evaluate agent responses against defined criteria.

  * History & Comparison: Track performance trends over time and compare different runs side-by-side to ensure non-regression.

  * Quick Iterations: Seamlessly transition from ad-hoc “Quick Tests” to structured reviews to accelerate the development cycle.




For more details, please see [Agent Review](<../agents/agent-review.html>).

### New Feature: Leverage 3rd party Agents from Snowflake Cortex, Databricks, AWS Bedrock and Google Vertex AI

External agents allow you to connect and interact with agents built in third-party platforms directly in Dataiku as managed agents.

Once configured, an external agent can be leveraged anywhere a Dataiku Agent is supported, including:

  * The Dataiku Flow (notably Prompt Recipes)

  * Chat UIs such as [Agent Hub](<../agents/agent-hub.html>)

  * The LLM Mesh API

  * [Prompt Studios](<../generative-ai/prompt-studio.html>)

  * [Agent Review](<../agents/agent-review.html>)

  * [Agent Evaluation](<../agents/evaluation.html>)




For more details, please see [External Agents](<../agents/external-agents/index.html>)

### New Feature: Flow Assistant

The new Flow Assistant allows users to design and build their Dataiku Flow faster. It lets users describe intent in natural language and turns it into a concrete workflow of datasets and recipes:

  * Describe what you want to build, the assistant then proposes which recipes to add and how they connect

  * Review the generated plan before anything is created

  * Iterate on the plan and refine the logic until it fits your needs

  * Generate Flow once ready




For more details, please see [Flow Assistant](<../ai-assistants/flow-assistant.html>).

### New Feature: AI Search

The new AI Search capability enables data discovery by allowing users to find relevant datasets and indexed tables across the Data Catalog using natural language queries.

For more details, please see [AI Search](<../ai-assistants/ai-search.html>).

### New Feature: SQL Assistant

The new SQL assistant, available in SQL notebooks and recipes, is a powerful companion for you SQL coding needs. It helps write SQL, refine it, improve it, and fix errors. It is a fully conversational experience for efficient iteration on your SQL needs.

For more details, please see [SQL Assistant](<../ai-assistants/sql-assistant.html>).

### New Feature: OpenAI Codex in Code Studios

You can now directly use OpenAI Codex, the powerful AI coding agent, directly in Code Studios, either through the TUI (Terminal UI) or VSCode extension.

It supports both routing queries through the LLM Mesh, through any supported LLM, or using your own ChatGPT subscription.

For more details, please see [OpenAI Codex AI coding agent](<../ai-assistants/codex.html>).

### New Feature: GitHub Copilot in Code Studios

You can now use GitHub Copilot in Code Studios, using VS Code.

It works using your existing Github Copilot subscription.

For more details, please see [Github Copilot](<../ai-assistants/github-copilot.html>).

### New Feature: Semantic Models

Semantic Models provide a foundation of business context between structured datasets and the LLMs that query them. They add business meaning to physical data, which provides a consistent business view of your data, and enhance decision making, notably for AI Agents. They help in translating natural language queries into precise, executable SQL.

Dataiku now supports the creation of semantic models, including AI-assisted generation, and their use for efficient querying.

For more details, please see [Semantic Models](<../semantic-models/index.html>).

### New Feature: Apache Iceberg support

DSS now supports reading and writing datasets on Apache Iceberg across a variety of catalogs, including Polaris, Nessie, Glue, and Hive.

For more details, please see [Iceberg](<../connecting/iceberg.html>).

### New Feature: Enterprise Asset Library

The Enterprise Asset Library helps organizations centralize trusted company assets and accelerate AI builders productivity.

The Enterprise Asset Library provides a single place to manage and share trusted AI building blocks across the organization:

  * Centralize Projects and Prompts as reusable, enterprise-grade assets.

  * Organize assets into Collections for clear ownership and easier discovery.

  * Control access to ensure assets are available to the right AI builders.

  * Use assets directly from the Design node, right where builders work.




### New Feature: Parameters Analyzer

In manufacturing, production quality is a key element of success. Any product that does not pass the Quality Assurance stage means a direct loss in terms of materials, production effort and opportunity costs, with only limited opportunity to (feasibly) recover part of those costs. The data being emitted in production processes provide a major opportunity to find and understand potential efficiencies.

The new Parameters Analyzer helps Process and Quality Engineers to identify optimized production parameters.

For more details, please see [Parameters Analyzer](<../manufacturing-operations/parameters-analyzer.html>)

### New Feature: Manufacturing Events Tracker

In manufacturing, understanding operational patterns and events is a key element of success. To effectively improve manufacturing operations, an understanding of context and the raw data produced in the process are key inputs.

Manufacturing Event Tracker (MET) is a comprehensive application for granular review of time-series data. It enables users to contextualize, explore, and label multiple time-series data coming from manufacturing execution systems and/or automation systems.

For more details, please see [Manufacturing Event Tracker](<../manufacturing-operations/manufacturing-event-tracker.html>)

### New Feature: Interact with DSS Agents on Slack

The Slack Integration serves as a bridge between your internal messaging platform and Dataiku’s Generative AI capabilities. It allows users to interact with Dataiku Agents and LLMs directly within their Slack workspace, enabling seamless access to data insights and automated responses in both direct messages and channels.

For more details, please see [Slack Integration](<../agents/slack.html>).

### New Feature: Reranking for RAG and Agentic retrieval

Reranking lets you run retrieved knowledge through a specialized model to reorder them against the query and select the most relevant ones to augment the query.

Reranking is available both for RAG models and for the Knowledge Bank Search Tool for agents.

For more details, please see [Search settings](<../generative-ai/knowledge/kb-search-settings.html>)

### New Feature: A2A Server

Dataiku DSS is now an A2A server, in order to expose DSS Agents to third-party A2A Clients.

The DSS A2A servers supports JSON-RPC and HTTP-SSE modes, and supports streaming of responses.

### New Feature: New Machine Learning algorithms (TFT, NHITS, TabICL)

  * For Classification, added support for TabICL, a transformer-based classification algorithm that lets you score small-to-mid-size datasets with near-instant training.

  * For Time Series Forecasting, added support for Temporal Fusion Transformer (TFT), a multi-series forecasting algorithm that can captures complex temporal patterns.

  * For Time Series Forecasting, added support Neural Hierarchical Interpolation for Time Series (NHITS), a forecasting algorithm particularly suited for long-horizon forecasting.




### New feature: Dashboard Format Management

New display and formatting capabilities have been introduced for dashboards, to improve display consistency across screen sizes and export

  * New “Fixed aspect ratio” display mode: A display mode that respects the dashboard’s format ratio by adding margins, ensuring the initial view is consistent regardless of screen size

  * Dashboard Format Settings: Format settings (e.g., A4, US Letter, Custom) are now saved at the dashboard level, serving as a persistent reference for layout and PDF exports

  * Visual Separators: New visual guides in Edit mode show exactly where the visible screen ends and where page breaks will occur during export

  * User Defaults: You can now set your preferred default display mode and page format in your profile settings for all new dashboards




### Agentic AI & RAG

  * Revamped Traces Explorer, with a more productive UX

  * Added support for image inputs on Visual Agents

  * Added support for Smart Sync / Upsert / Append on the Extract Content recipe

  * Added support for Milvus (local) as a no-setup, locally-run vector store for a Knowledge Bank that supports hybrid search

  * Added tools to leverage Snowflake Cortex Search and Snowflake Cortex Analyst

  * Added tools to leverage Databricks Genie and Databricks Vector Search

  * Added a “Raw text” extraction engine on both Embed Documents and Extract Content recipes, for faster extraction when the structure of the documents is less relevant

  * Added ability to configure how long an Agent’s process remains active when unused

  * Added support for multimodal tool outputs, usable with LLMs on Azure Foundry, Azure OpenAI, Bedrock, OpenAI, and Vertex connections

  * Added support for structured MCP tool results

  * Added ability for Agents to retain internal thinking in the conversation history

  * Added support for multiple version of Retrieval-Augmented LLMs, allowing you to edit one version without impacting another

  * Added ability to fallback to image descriptions when image retrieval fails in RAG

  * Improved RAG filtering for “Bag-of-Words” columns, filterable as a set of tags

  * Fixed unbounded size of logged completion response, now truncated

  * Fixed default index name of new Knowledge Banks, possibly causing a copied KB to target the same underlying index

  * Fixed display of Retrieval-Augmented LLM’s retrieval configuration when the KB hasn’t been built

  * Fixed deletion of Knowledge Banks when deleting a project

  * Fixed no-argument tools with Bedrock models

  * Fixed slow initial load of Tools when using an Agent with many tools




### Agent Hub

  * Added support for displaying reasoning

  * Added support for using a PostgreSQL database as Agent Hub underlying storage

  * Added guardrails on uploaded documents (to filter unauthorized metadata and content)




### LLM Mesh

  * Azure Foundry: Added support for Anthropic Claude models

  * Azure Foundry: Fixed OAuth authentication

  * OpenAI: added support for gpt-image-1.5

  * Vertex: added support for the global endpoint

  * Anthropic: added support for image inputs in completion queries

  * Local models: Improved inference performance for local models using RS-LoRa

  * Local models: local inference now uses vLLM version 0.14.1

  * Local models: Fixed possible accuracy issues with Gemma 3

  * Added ability to log the end user of a LLM or Agent call in audit logs, for when it’s different from the querying user e.g. the user running the Agent Hub webapp backend

  * LLM Evaluation: Added BERTScore evaluation support for air-gapped environments by utilizing the internal model cache

  * LLM Evaluation: Fixed multimodal metrics on text contexts




### Machine Learning

  * **New feature** : feature importance for time series forecasting models help you assess the impact of features on your forecasts.

  * **New feature** : Independent Component Analysis (ICA) feature reduction.

  * Added coefficients on Ridge Regression models

  * Added warnings when comparing metrics that are not comparable, or on models that use different weighting methods or averaging methods

  * Improved view of foreign models shared from another project when the user doesn’t have access to said other project

  * Improved speed of What-If interactive scoring on time series forecasting models

  * Improved speed of feature importance computation for models that use sparse matrices

  * Fixed possible slowness when training causal models using Python 3.9+

  * Fixed possible NaN probability when using Optimized Scoring engine and the probability is very close to 1.0




### Dataset and Connections

  * S3/GCS: Improved resilience to connection timeouts with automatic retries. This is particularly useful when working with very slow recipes such as LLM recipes

  * S3/GCS/Azure Blob Storage: Added variable expansion support for default bucket/container/volume in cloud storage connections

  * S3/GCS/Azure Blob Storage: Added expansion of ${dssUserLogin} variable for managed folders

  * Azure Blob Storage: Added SAS token authentication method as an alternative to shared key and OAuth

  * Snowflake: Added variable expansion support for privateKeyFile field in connection settings

  * BigQuery: Now uses CREATE OR REPLACE TABLE instead of DROP+CREATE when rebuilding datasets to preserve table permissions

  * Databricks: Added default schema management for Databricks-to-cloud fast path operations

  * Databricks: Improved table/column comment sync performance by skipping unnecessary ALTER TABLE queries

  * Azure: Enabled fast copy from Azure Storage to Synapse when using Managed Identities

  * Sharepoint: Fixed creating datasets from managed folders when siteID/driveID was not saved in folder settings

  * Sharepoint: Fixed support for site URL in connection default site settings

  * Trino: Fixed synchronization of unmanaged tables with complex types (array, map, row)

  * Kafka: Fixed issue preventing containerized streaming recipes from starting

  * Parquet: Fixed wrongful value written for “date only” columns, when written by DSS engine and the server is not in UTC timezone

  * ORC: Fixed files with datetimeNoTz columns written by Spark not being readable by DSS

  * Spark: Fixed pipelines failing on table names containing dashes

  * Spark: Fixed metrics computation on datasets with geopoint columns

  * Added on-disk-encryption of “secret” custom properties on connections (note: these are Dataiku internal settings, and they are not actually secret)

  * Added ability to download multiple selected objects from managed folders using right-click context menu

  * Improved built-in sample datasets schemas and data to ease onboarding




### Flow and Recipes

  * Prepare: Added coalesce step, returning the first non-null value from a list of columns

  * Prepare: Fixed Find/Replace steps issues with SQL engine

  * Prepare: Updated holidays database including French school holidays and Asia holidays for 2026

  * Pivot: Fixed missing validation errors when aggregation type is incompatible with column type

  * Python: Fixed validation error when using project variables for partition values in Python recipes

  * Export to folder: Added option to prepend exported file names with a timestamp

  * Fixed formula preview incorrectly left-trimming whitespace from results

  * Fixed Flow graph where some recipes could appear outside their zone boundaries

  * Fixed Flow graph where some Model Evaluation Store objects could appear outside their zone boundaries

  * Updated GeoIP database for improved geolocation accuracy




### Charts and Dashboards

  * **New feature** : New chart type: Waterfall

  * **New feature** : Added support for unaggregated measures in bar charts

  * **New feature** : Custom sorting: Added the ability to manually set order of alphanumerical (or numerical treated as such) dimensions

  * Added a “No sorting” option on alphanumerical dimensions

  * Added an “Apply to all measures” button in Data labels numbers formatting settings to quickly format all numerical measure labels at once

  * Added an option to hide axis titles in dashboard chart tiles settings

  * Added the options to hide axis on boxplot dashboard tiles settings

  * Fixed dashboard filter tooltip when multiple filters are set on the same column

  * Fixed tooltip for grouped bubbles charts

  * Fixed drilldown filters when shared via URL

  * Fixed dashboard exports in scenarios to correctly respect the dashboard format and file type settings




### Stories

  * Added the ability to replace a dataset across an entire story

  * Added support for clickable URL links in Story table and list charts

  * Added a “between” operator for numeric filters

  * Improved date selection in dataset and chart filters

  * Fixed PPT and PDF export

  * Fixed binning with 0 as a boundary

  * Fixed style copy for metrics text alignment

  * Fixed sorting on count of rows

  * Fixed copy-pasting plain text

  * Fixed workspace Stories actions




### Visual Graph

  * **New feature** : Added support for Neo4J as backend




### Coding & API

  * **New feature** : Improved autocomplete in SQL notebooks

  * Python API: Added Python APIs to convert documents to PDF

  * Python API: Added Python API helpers to create and edit Split recipes and Extract Content recipes

  * Python API: Added public and Python API support for the Agent Eval recipe

  * Python API: Fixed Python API not using the provided recipe name when creating Prepare recipes

  * Python API: Fixed erroneous results in compute_project_footprint API

  * Python API: Fixed wrongful requirement for “Read project content” permission to run scenarios

  * R API: Fixed dkuWriteDatasetSchema not properly handling R date types

  * Code Envs: Improved code environment resources with rename, move and delete actions, and extended resource upload to internal code environments

  * Code Envs: Fixed display of error when the upload of resources in a code environment fails

  * Added the ability to configure plugins’ custom fields to be displayed in their own tab in the right panel (only for projects, datasets, recipes, scenarios, saved models and notebooks)

  * Reduced Spark log verbosity in Jupyter notebooks




### Webapps

  * Added UI to view webapp run history and retrieve diagnostics per run

  * Added visibility control for webapps exported as plugin components

  * Added ability to configure start timeout for visual webapps

  * Fixed code environment usage reporting for plugin webapps




### Dataiku Apps

  * Added visibility control for Dataiku Apps exported as plugin components

  * Fixed race condition during Dataiku App upgrade




### Code Studios

  * Fixed unpredictable behavior when opening files in VSCode from Code Studio

  * Fixed Code Studio VSCode launch configuration generation to properly set the program field




### Git

  * Added warning when git cloning a repository with oversized files or large total size

  * Fixed CREATE BRANCH button sometimes not appearing in Version Control

  * Fixed ‘Revert this change only’ button in plugin git history




### Scenarios and automation

  * Fixed race condition in scenario abort sequence where a second step could start after abort was triggered

  * Fixed scenario abort handling for the ‘reload schema’ step

  * Fixed scenario outcome appearing as warning after v13 to v14 upgrade

  * Fixed scenario naming for shared objects causing deletion issues

  * Fixed browser crash when using the ‘Trigger after scenario’ dropdown with very large numbers of scenarios

  * Fixed automation monitoring page refreshing prematurely while editing date inputs

  * Fixed notification panel links after scenario builds to correctly redirect to the appropriate object type

  * Fixed incorrect time unit handling for the “Timeout” parameter in scenario webapp test steps




### MLOps

  * Added information in Model Evaluation about the number of rows utilized for the calculation of the performance drift

  * Fixed classifier bias in text drift Classifier Gini score in (Standalone) Evaluation Recipes

  * Fixed text and image drift score calculation to avoid bias when reference and current data is imbalance (consequently, users may observe different drift scores compared to previous versions)




### Deployer & Monitoring

  * Fixed duplicate Unified Monitoring Alerts creation when clicking rapidly

  * Added LLM Badge on project with Agent Connect or Agent Hub

  * Fixed “Get machine types list” button in basic settings of Vertex AI infrastructures




### Governance

  * Added the ability to create custom actions on Govern item pages and custom pages

  * Added the ability to export and import custom pages configurations (JSON format)

  * Added a “Prevent hide” option to table column settings, preventing users from hiding critical fields defined by configurators

  * Added the ability to define specific icons and colors for Blueprints and Blueprint Versions

  * Added synchronization of the status and folder hierarchy of DSS projects

  * Added display of the short and full descriptions of the source item in “Source object” tab

  * Added the user who triggered the event in the execution context of Python hooks

  * Added an overview of applicable auto-governance rules directly on the Governable items page

  * Remember the choice of metric to focus in the Model Registry

  * Removed links to unconfigured nodes




### Elastic AI

  * Fixed Containerized Data Execution (CDE) recipes failing when a securityContext with runAsUser is configured

  * Fixed kubectl port-forward processes becoming orphaned when DSS backend crashes

  * Fixed a regression where setting pod-level security context would skip container-level security context




### Cloud Stacks

  * Fixed issue where the list of instances needing reprovisioning was incomplete

  * Fixed load balancer rules on AWS not updating when Virtual Network DNS strategy changes

  * Added DATAIKU_ANSIBLE_DSS_NODE_TYPE environment variable for ansible playbooks




### Dataiku Cloud

  * Maintenance tab is now available in Administration Settings




### Security

  * Fixed error message when an API key is deleted while still being used

  * Enforce HuggingFace not being allowed as a personal connection




### Performance & Scalability

  * Improved initial UI load time, especially on slow connections

  * Fixed possible slowdown when re-opening a discussion

  * Added support for cgroups settings for Stories




### Misc

  * Data Catalog: Improved Database Explorer to automatically display the last used connection

  * Data Quality: Custom meanings: Added ability to configure whether empty values should be considered valid or invalid

  * Fixed Wiki math block content sanitization that caused blank pages when using ‘<’ character

  * Added user setting option to enable sound notifications when jobs complete

  * Fixed sanity check results to persist and display after DSS instance restart

  * Fixed sanity check report not displaying some details on first load

  * Fixed folder explorer modal appearing on top of the ‘Disconnected’ overlay

  * Fixed incorrect ‘upgrade profile request’ modal appearing when importing a project

  * Fixed inability to delete agent tool logs and other log types

  * Fixed Admin > Monitoring to include managed folders in per-connection data statistics




## Version 14.3.3 - January 29th, 2026

DSS 14.3.3 is a release with bug fixes and performance improvements

### Agentic AI & RAG

  * MCP: improved automated OAuth2 server metadata discovery

  * Extract content recipe: improved default prompt for visual extraction

  * Embed Documents recipe: Fixed relocatability of Knowledge Banks built from Embed Document

  * Fixed possible timeout of containerized document extraction process

  * Fixed possible race condition when deleting outdated records in the Document Extraction & Document Embedding recipes run in modes other than Append

  * Fixed wrongful clear of the Knowledge Bank the first time an Embed Documents recipe runs in Append mode

  * Fixed possible display issue on the retrieval parameters of some Knowledge Banks




### LLM Mesh

  * Fixed Hugging Face models reserved capacity (Min. instances) on container execution configurations only accessible to selected user groups, or when the connection has model cache enabled with restricted access.

  * Fixed application of LLM rate limiting configuration

  * Fixed administrator view of quotas that were not previously edited/saved

  * Fixed excessive logging about unknown model pricing

  * Fixed ability to pick the API mode on Azure Foundry deployments when using the “GPT-5.1 and later” handling mode

  * Fixed proxy support in Snowflake Cortex connection (for models in modern “REST” mode)




### Machine Learning

  * Fixed possible scoring inaccuracies on XGBoost models trained before DSS 13.4.0 using the `hist` tree method




### Dataiku applications

  * Fixed navigation menu on app instance page




### Charts and Dashboards

  * Charts: Fixed possible overlap of tooltip and modals

  * Charts: Fixed Pie “Natural Order” and “No Sorting” dimension sorting modes

  * Charts: Fixed saving of binning mode on date dimensions treated as alphanumeric

  * Charts & Dashboards: Fixed a memory leak occurring when interacting with chart legends or moving chart tiles in dashboards

  * Dashboards: Fixed export of dashboards containing webapps

  * Dashboards: Fixed dashboard filters not applied to tiles on newly created, unsaved pages

  * Dashboards: Fixed dashboard drill up not clearing insight filters




### Dataset and Connections

  * Made dataset test action more resilient for customers with proxies shutting down long queries

  * Fixed dataset renaming in projects containing unconfigured agent tools

  * Fixed spurious warning when building datasets with a description on databases not supporting comment sync




### Flow and Visual Recipes

  * Improved performance of data lineage computation

  * Fixed handling of project variable with unicode characters followed by digits

  * Fixed recipe on BigQuery partitioned dataset and non BigQuery output




### Coding & API

  * Added capability to manage Agent and LLM Evaluation Stores and Evaluations in the Python API

  * Code Envs: Added ability to not wait and to return a DSSFuture in code env managmement APIs (create, delete, update packages, …)

  * Fixed possible Python recipe hanging when writing dataframes




### Scenarios and automation

  * Fixed backward compatibility of “Clear internal database” action through scenario step or public API




### Deployer

  * API Deployer: Added an option to disable namespace presence checks in Kubernetes infrastructures, facilitating integration with clusters with restricted permissions.




### Stories

  * Fixed loss of images in Stories when upgrading instances with a large number of Stories




### Governance

  * Fixed scheduled signoff reset

  * Fixed updating affected artifact IDs in post hook




### Cloud Stacks

  * Fixed DSS start if a DSS API key does not have any label




### Performance

  * Fixed possible leak of runtime database connections on instances with low activity

  * Improved performance of job notifications system

  * Improved performance when working with Code Studios in projects containing very large Jupyter notebooks




## Version 14.3.2 - January 14th, 2026

DSS 14.3.2 is a release with significant new features, bug fixes, security fixes, and performance improvements.

### Agentic AI & RAG

  * Sped up text-first extraction with “Describe images with VLM”, by skipping useless descriptions (e.g. on signatures, decorative images…)

  * Added support for LangChain 1.0 when using Agents & Tools via code using LangChain

  * Added ability to edit the additional context in Agent > Chat / Prompt Studio Chat

  * Improved display of sources & artifacts when they are emitted by tools or sub-agents

  * Improved image resolution when using text-first extraction on PDF files

  * Improved warning when there are errors retrieving files for embedding

  * An Agent’s test Chat is now preserved when switching tabs within this Agent’s version, and no longer resets when changing settings in the Agent (or Retrieval-Augmented LLM)

  * Agents now list their Agent Hub uses in the right-hand side panel

  * Fixed copy of a Knowledge Bank from the Flow

  * Fixed text extraction for some pptx documents

  * Fixed Agent tool dependencies when they contain a dataset that has been renamed

  * Fixed last item in sliding window of pages with overlap when using visual extraction

  * Fixed remapping of code environment for code agents, python tools and MCP tools when importing a project

  * Fixed remapping of containerized execution configuration for agents and tools when importing a project

  * Fixed possible issue with Visual Agent diagrams when tool names have special characters




### LLM Mesh

  * Snowflake Cortex: added support for

    * Anthropic Claude 4.5 Sonnet, 4.5 Haiku, 4 Sonnet

    * OpenAI GPT-5 Chat, GPT-4.1

    * Image inputs (only when using via REST)

    * Model costs (only when using via REST)

  * Databricks Mosaic AI: added support for

    * Open AI GPT 5, 5-mini, 5-nano

    * Google Gemini 2.5 Pro, 2.5 Flash

    * Google Gemma 3 12B

    * Anthropic Claude 4.5 Sonnet, 4.1 Opus, 4 Sonnet

  * Anthropic & AWS Bedrock: added support for Claude Opus 4.5

  * OpenAI, Azure OpenAI & Azure Foundry: added support for GPT 5.1, 5.2

  * Vertex AI: added support for

    * streaming completion responses

    * Imagen 4 models

  * Local Hugging Face: added experimental support for Python 3.13 on the internal HF code environment

  * Local Hugging Face: add support for Kimi-Linear-48B-A3B-Instruct

  * Logging (when enabled) of queries with images now truncates their content, to avoid flooding the logs

  * Local Hugging Face: fixed scale up loop when the number of queried models plus always-instantiated models exceed the global maximum configured

  * Fixed display of LLM rate limits in Administration settings, when set and navigating away before coming back

  * Fixed display issues when the definition of plugin Agents, Agent Tools, and Guardrails are incomplete

  * Fixed display of progress indicator on model chats with simulated reasoning




### Machine Learning

  * Fixed training of torch-based time series forecasting models with Python 3.12 using GPUs

  * Fixed re-detection of context length when changing forecast horizon on torch-based time series forecasting models

  * Fixed TensorBoard on AutoML Deep Learning models when using Python 3.8




### MLOps

  * Agent Evaluation: Added support for simple tools list (raw list of strings)

  * Removed the possibility to execute Project Standard checks on a bundle. Checks can now only be executed on the project and at bundling time. As a consequence, `bundle_id` parameter was removed from the `start_run_project_standards_checks` public API function.

  * Improved performance of the `set_core_metadata` method for imported MLflow models

  * Fixed public API function `DSSModelEvaluationStore.run_checks`

  * Fixed subpopulation computation of model evaluation, for categorial columns with one element

  * Fixed subpopulation computation of model evaluation, for date columns in the Standalone Evaluation Recipe

  * Fixed LLM evaluation recipe when there are multimodal metrics output in a dataset

  * Fixed comparison deletion in GenAI Comparisons

  * Fixed Agent Evaluation recipe when the LLM output is a simple decimal

  * Fixed model or GenAI evaluation store link from the right panel




### Dataset and Connections

  * Fixed JDBC Connection on a SQLite file without the driver jar path specified

  * Sharepoint: Built-in connector now spills large files to disk to avoid memory issues

  * Sharepoint: Fixed issue preventing changes to the site of a Sharepoint native dataset after initial write

  * Databricks: Fixed Volumes with Azure OAuth2 not working with remote credentials fetching

  * Snowflake: Added ability to supply an optional account identifier to access Snowflake Cortex over a private link




### Charts and Dashboards

  * Charts: Fixed radar charts tooltips

  * Charts: Fixed drill up removing matching regular filters

  * Charts: Fixed breadcrumb when drilling down on a dimension without selecting a specific value

  * Charts: Fixed the transformation of grouped bubbles charts into waterfall

  * Charts: Fixed drilling down on date dimension

  * Charts: Fixed switching to tree map

  * Charts: Fixed binned charts and pivot tables when using hierarchies for both axes

  * Dashboards: Fixed tile count for grouped tiles

  * Dashboards: Fixed text tiles in grouped tiles

  * Dashboards: Fixed scrolling issue with grouped tiles

  * Dashboards: Fixed WebGL rendering with many scatters

  * Dashboards: Fixed filter tooltip issues with date filters

  * Dashboards: Fixed export of dashboards with grouped tiles of only text tiles

  * Enhanced SQL charts axis creation performance




### Flow and Visual Recipes

  * Prepare: Added support for more countries (OM, UAE, KSA) in the holidays steps




### Coding & API

  * Fixed possible leak of file descriptors in Jupyter notebooks

  * Fixed recipe creation from SQL Notebook when project contains a SQL Query dataset on the same connection

  * Fixed copying a SQL notebook from the notebook list not copying associated charts

  * Fixed SQL notebook chart layout when resizing the window horizontally

  * Fixed application of SQL notebook chart formatting options

  * Fixed legend display on SQL notebook charts

  * Fixed cells alignment and coloring in SQL notebooks result table




### API Deployer

  * Added the possibility for Topology Spread Constraints to be deployment specific without overriding infrastructure

  * Fixed query logging activation




### Administration

  * Authorization Matrix: clarified “create project rights” when restricted creation is restricted through macro or template




### Elastic AI

  * Added group remapping for containerized execution configurations




### Governance

  * Fixed export of artifacts with JSON fields

  * Fixed history for user’s login action

  * Fixed possible hangs in hooks when user code doesn’t halt

  * Fixed “Headline” formatting button in rich text editor




### Cloud stacks

  * AWS/Azure/GCP: Fixed start of internal PostgreSQL database when some setup actions mount filesystems

  * AWS/Azure/GCP: Fixed “Device has unexpected filesystem” error when restarting Fleet Manager

  * Added Project Standards cgroup placement support




### Security

  * Prevent users without “freely use” privilege on a SQL connection from writing custom SQL filters, even when they have write access to the project

  * Fixed possible file read through a personal connection, see [DSA-2026-001](<../security/advisories/dsa-2026-001.html>)

  * Fixed an issue where the Sharepoint connector was logging JWT tokens, see [DSA-2026-002](<../security/advisories/dsa-2026-002.html>)

  * Fixed IP-bound sessions support for standard webapps




### Miscellaneous

  * Project Standards now always work on the original project rather than creating and deleting a temporary copy




## Version 14.3.1 - December 19th, 2025

DSS 14.3.1 is a bugfix release.

### LLM Mesh

  * Fixed Visual Agents using tools without description

  * Hugging Face Local: Fixed Retrieval-Augmented models when the LLM is Gemma

  * Fixed possible issue when using a shared “Search KB” agent tool in two projects simultaneously




### Agentic AI & RAG

  * Fixed trajectory explorer in agent evaluations when used with a prompt recipe configured with guardrails




### Flow

  * Fixed output flow zone when creating recipes from a Flow item present in multiple zones




### Dataiku Stories

  * Stories AI Assistant: Fixed generation of multiple charts on the same slide




### Misc

  * Fixed invalid warnings when upgrading from an older DSS version

  * Fixed Global API key group selection dropdown not displaying non-local groups

  * Reduced the base image size for Containerized DSS engine and API node




## Version 14.3.0 - December 11th, 2025

DSS 14.3.0 is a release with significant new features, bug fixes, security fixes, and performance improvements.

### New feature: Hierarchical Drill-down in Charts and Dashboards

Dataiku DSS now enables users to create and navigate hierarchical relationships directly within their data visualizations. This powerful feature allows for intuitive, multi-level data exploration without requiring the creation of multiple charts or complex, layer-by-layer filtering.

This capability supports common analytical patterns, such as drilling down from country to state to city, or moving from a high-level category to a specific product, thereby significantly enhancing the data exploration capabilities in your dashboards and charts.

For more details, please see [Hierarchies and drill down](<../visualization/hierarchies-drill-down.html>).

### New feature: Agent Evaluation

Agent Evaluation provides users with quantitative, automated, and scalable insights into the performance of their agents. This feature is designed to help users quickly confirm that their agents are effective, reliable, and valuable, thus accelerating the process of deploying agents from design to production.

Key components of the feature include:

  * New dedicated Evaluation Recipe, separate from the existing LLM Evaluation recipe, to configure and execute agent evaluations

  * Built-in Metrics including tools-based metrics derived from agent tools calls traces such as in order Trajectory Exact Match or out of order Precision, Recall, and F1 score. Users can also easily define their own custom metrics.

  * New Agent Evaluation Store to store and allow exploration of current and historical agent evaluations. This includes row-by-row analysis of interactions, enhanced with a new Trajectory Explorer component for deep-dive debugging of the agent’s step-by-step process.




For more details, please see [Agent Evaluation](<../agents/evaluation.html>).

### New feature: Extract Content recipe

The new Extract Content recipe lets you extract the content of file documents to a dataset.

It supports:

  * Direct text extraction

  * OCR to extract text from images

  * Asking a VLM (Vision/multimodal LLM) to provide a read-out of images




The recipe supports DOCX, PPTX, PDF, TXT, MD, PNG and JPG files.

For more details, please see [Extracting document content](<../other_recipes/extract-document-content.html>)

### New feature: Charts in SQL notebooks

SQL notebooks now include the ability to create charts on the results, with the full range of DSS charting capabilities.

In addition, SQL notebooks results now include extensive filtering and sorting capabilities.

### Agentic AI & RAG

  * **New feature** : Visual Agent now offer a diagram view of tools and dependencies.

  * **New feature** : Support for Remote MCP servers, with the new MCP Server connection.

  * **New feature** : Dynamic filtering lets agents automatically specify filters to perform narrower searches in Knowledge Banks

  * **New feature** : Added ability to use a VLM to annotate images when extracting/embedding documents using text-first extraction

  * **New feature** : Added ability to run an empty search on a Knowledge Bank to get sample entries in the KB

  * **New feature** : Agent tools can now be shared across projects

  * Added dedicated logs to Retrieval-Augmented LLMs and Agent Tools

  * Added ability to declare dependencies in Code Agents and Python Code tools

  * Added ability to configure Guardrails on Retrieval-Augmented LLMs

  * Added more information on a Visual Agent’s version tiles

  * Added ability for the Query LLM Mesh tool to forward the parent Agent `context` to the sub-agent

  * Improved speed of text-first extraction and embedding

  * Fixed build of flow zone when an Agent is a flow zone output

  * Fixed Embed recipes on Opensearch Knowledge Bank using AWS authentication

  * Fixed order of the extracted text from some PPTX documents generated by Google Slides

  * Fixed heading level on DOCX files using text extraction

  * Fixed default code proposed when creating a Python recipe from the Flow with an Agent selected

  * Fixed deletion of Agent versions via API

  * Fixed text extraction of some documents’ table of content




### LLM Mesh

  * **New feature** : Added support for Azure AI Foundry

  * Local inference (Hugging Face): added support for new models
    
    * Meta Llama 4 Scout & Maverick 17B Instruct

    * Qwen 2.5 VL 7B & 72B Instruct

    * MiniCPM-o 2.6

  * Local inference (Hugging Face): Added support for image inputs on Mistral Small 3.2 24B Instruct

  * Local inference (Hugging Face): use accelerated inference (vLLM) for embedding models when possible

  * Local inference (Hugging Face): added reasoning support for compatible models

  * Local inference (Hugging Face): added experimental tool calling support for GPT-OSS 20B/120B

  * Local inference (Hugging Face): Now requires Python 3.10, 3.11 or 3.12.

  * Local inference (HuggingFace): Llama 3.2 11B Vision is not supported anymore, and can be replaced with Qwen-2.5 VL 7B or MiniCPM-o 2.6

  * A reasoning budget can now be specified on OpenAI, Azure OpenAI, Berock and Vertex models that support it

  * Reasoning summaries returned by LLM providers (OpenAI, Azure OpenAI, Berock and Vertex, for supporting models) are now shown (and returned in API calls as Artifacts)

  * Quota visibility can now be optionally extended to users/groups

  * Quotas conditions can now include user groups

  * Added ability to provide a JSON schema for JSON mode in Prompt Studio / Prompt Recipe

  * Fixed deletion of fine-tuned OpenAI models

  * Fixed slow image preview in Prompt Studio

  * Fixed long logs caused by base64 image content, now elided

  * Fixed test of a new Hugging Face local Connection that hasn’t been saved yet




### Machine Learning

  * Score and Evaluate recipes now warn in case of incompatible schema on the output dataset upon re-run

  * Fixed abort of partitioned training when some partitions are still pending

  * Fixed scoring recipe when input model is a MLflow model that has a null prediction type




### Time Series Forecasting

  * **New feature** : Metrics per forecast distance let you inspect forecast performance per time step within the horizon

  * **New feature** : Added support for LightGBM and Croston models for forecasting

  * **New feature** : In What-If, you can now define multiple scenarios to test

  * On time-shifted numerical features, shifts from forecasted points are now guessed automatically by default

  * Categorical features can now be aggregated over a window

  * Aggregated numerical features can now be rescaled

  * Fixed What-If when a feature name contains a dot




### Charts and Dashboards

  * **New feature** : Added support for Project Variables in Dashboards, in text tiles, tile titles or page titles.

  * **New feature** : Added ability to invite users to dashboards by email

  * Revamped menu system to streamline access to measure and dimension configuration

  * Added comprehensive information about filters applied to tiles in the filtered indicator tooltip

  * Removed “Others” tick in multidimensional SQL charts when empty

  * Fixed sorting labels for renamed measures

  * Fixed text tile horizontal alignment

  * Fixed stacked bars with logarithmic scale

  * Fixed facet counts for “numerical as alphanumerical”

  * Fixed PDF export of dashboards with Hangul characters




### Dataiku Stories

  * Added the ability to set row level filters on numeric columns values

  * Improved color palette management in regards to themes

  * Fixed PDF and PPTX exports with filters

  * Fixed user input filter when combined with dataset filters

  * Fixed date filters and virtual dates for SQL datasets

  * Fixed the display of negative values in charts

  * Fixed reference lines




### Datasets and Connections

  * Added ability to add descriptions to connections

  * BigQuery: Added ability to Enable “Require partition filter” flag when creating partitioned tables

  * Azure Synapse / Microsoft Fabric / Microsoft SQL Server: JDBC driver can now be automatically managed by DSS

  * Databricks Volumes: Added support for per-user OAuth authentication

  * Databricks Volumes: Managed folders now store files in the default catalog & schema for new datasets

  * Athena: Added support for driver version 3.6.0 and above

  * Databricks: Fixed fast-path writes not working with partitioning on integer fields

  * Added ability to view shared datasets in Project > Datasets

  * Added option to fix upstream/downstream recipes wrongly using “All Available” dependency when saving partitioned datasets




### Flow

  * Flow now displays a warning banner when a project contains multiple datasets with the same underlying database table

  * Added ability to quickly search Agents and GenAI models in the Flow

  * Fixed copy of part of Flows containing SQL recipes with “Allow SQL across connections” enabled

  * Fixed copy of part of Flows containing a streaming endpoint

  * Fixed issue where a user’s mass dataset deletion prevented other users from displaying the Flow




### Recipes

  * Join: Fixed joining two BigQuery datasets on timestamp columns with a lingering case insensitive option

  * Prepare: Fixed Generate Step when requesting more than one step

  * Prepare: Fixed “date increment” step on Redshift

  * Prepare: Fixed “Filter on value” steps incorrectly casting string literals to “date time no tz”

  * SQL Query: Fixed partition variable substitution during validation

  * SQL query: Fixed validation on partitioned datasets failing when query returns fewer columns than the output dataset

  * Pivot: Fixed inability to update aggregation on an existing pivot output

  * Hive: Fixed validation of Hive recipes failing on datasets containing a large number of columns

  * Fixed partitions redispatch not working after setting and then removing a forced list of partitions

  * Fixed containerized recipe writes to Filesystem connections failing under intermittent network error conditions

  * Formulas: Added support for SQL for avg() and sum() functions




### MLOps

  * **New feature** : Added support for drift analysis on input images in the Evaluation and Standalone Evaluation Recipes

  * Added a limit for the size of parameters that can be logged in Experiment Tracking

  * Fixed Model Comparison from Model Evaluation Stores




### Webapps

  * **New feature** : Streamlit is now available directly as a managed webapp type (in addition to still being able through Code Studios)

  * Fixed bokeh webapp timeouts on Python 3.12

  * Fixed invalid plugin webapps preventing auto-start webapps from starting at DSS startup




### Code & APIs

  * **New feature** : Experimental support for Python 3.14

  * Fixed `DSSProject.get_flow().get_default_zone().items` always returning an empty list

  * Added helper methods to create Stack and Sort recipes

  * Removed admin right restriction to use get_definition() for meanings

  * `DSSProject.get_project_git().get_status()` now returns origin projects and the number of commits ahead/behind the origin project or remote branch

  * Fixed issue with imports of the dataiku-internal-client package outside of DSS




### Collaboration & Version control

  * Added exact commit time in DSS object’s Version control history

  * Fixed comparing Git commits in Merge Requests

  * Fixed reverting the first Git commit causing an exception

  * Fixed daily digests which could be sent even if there was no activity to report




### Data Catalog

  * Added ability to create a new project when using datasets from the Data Catalog

  * Added ability to modify table and column descriptions of indexed tables




### Governance

  * Govern: Remember each user’s columns configurations on table pages, as well as matrix and Kanban states

  * Govern: Improved list edition in markdown editor

  * Govern: Added endpoints in DSS public API to trigger sync actions

  * Govern: Fixed timeline

  * Project Standards: Added detection of outdated Project Standards reports

  * Project Standards: Added the update of project level report when producing a Project Standards report for the creation of a bundle

  * Project Standards: Fixed containerized execution of Project Standards




### Scenarios

  * Added support for unicode characters when creating variables in scenario reporters

  * Fixed “Clear items” steps ignoring deletion errors. Such steps now fails and stops scenario execution when an item cannot be cleared. Check “Ignore failure” on “Clear items” steps that must not stop scenarios on failure.




### Deployer

  * API Deployer: Added port name field to Ingress exposition modes in K8S infrastructure settings

  * API Deployer: Fixed “Entry” endpoints selection in API Service deployments settings

  * API & Project Deployers: Fixed the deployment status for first deployment




### Elastic AI

  * **New feature** : “Remove old container images” macros can now clean remote registries

  * Added support in container configurations for separate push and pull repository URLs

  * Fixed clusters tab not visible in the UI for users with the “Manage All clusters” right

  * Added name of the current Container Exec in Compute Resource Usage items (CRU)




### Cloud Stacks

  * Added Python 3.14

  * Azure: Fixed load balancer not being created in the VNet resource group during resource creation

  * Azure: Fixed Updating a load balancer breaking the other existing load balancers

  * Azure: Fixed changing a load balancer from HTTPS to HTTP causing it to become unusable

  * Azure: Fixed switching from dynamic to static public IP mode not marking load balancers as “Needs Updating”

  * AWS/Azure: Fixed failure when deprovisioning an instance whose load-balancer node mapping had been removed

  * Fixed old snapshot labels not being deleted when provisioning an instance




### Security

  * **New feature** : Global API keys can now be added to groups

  * Fixed SAML redirection preventing the UI from loading correctly under some conditions

  * Session expiration is now configurable from the UI directly

  * Session expiration is now enabled by default on newly-installed Dataiku instances, defaulting to 30 days of inactivity




### Performance & Scalability

  * Govern: Strongly improved performance of some SQL queries, which could previously lead to non-responsive Govern

  * Govern: Increased the default max number of parallel SQL connections (from 10 to 50)

  * Fixed UI responsiveness issue when syncing Code Studios with large files




### Miscellaneous

  * Data Lineage: now automatically highlight the current column in preview

  * Dataiku Applications: Users with “Write content” permission on a project can now access Application Designer and edit the application. Project admin permission is still required to convert a project into a Dataiku Application

  * Added sanity checks to detect Git misconfigurations




## Version 14.2.3 - November 24th, 2025

DSS 14.2.3 is a bugfix, performance and security release

### LLM Mesh

  * Added UI setting for local MCP server timeouts




### Machine Learning

  * Fixed auto-configuration of time series forecasting tasks in the presence of multiple Python 3.13 code environments




### Governance

  * Added a filter option to search only on the current layer




### Dataset and Connections

  * Fixed import of large XLS files (several millions of cells)

  * Fixed disappearance of rows when re-editing an Editable dataset




### Visual Recipes

  * Removed excessive logging in sync recipe with “Redispatch partitioning”

  * Fixed stack recipe UI when using “custom defined schema” mode




### Data Quality

  * Fixed Data Quality rule computation on partitioned dataset with a timestamp-like partition value

  * Fixed mass deletion of Data Quality rules




### Performance & Scalability

  * Fixed browser memory leaks when opening large dashboards

  * Fixed browser memory leak on Pivot charts




### Misc

  * Fixed dismissal of “New DSS version” modal

  * Fixed usage of DSS inside an iframe




### Security

  * Fixed [Improper identity propagation allowing data source impersonation](<../security/advisories/dsa-2025-009.html>)




## Version 14.2.2 - November 13th, 2025

DSS 14.2.2 is a bugfix release.

### Agentic AI & RAG

  * Added ability to retrieve multiple columns for augmentation

  * Added support for PDFs containing JPEG2000 and JBIG2 images in Embed Documents recipe

  * Added cgroup control for documents conversion in Embed Documents recipe

  * Added ability to delete Agent log files

  * Fixed automatic creation of some tools code environment on an Automation Node

  * Fixed possible missing text in Embed Documents recipe when using Text extraction with OCR

  * Fixed default path of a new Embed Documents recipe’s output Managed Folder

  * Fixed build of FAISS Knowledge Banks with Embed Documents recipe

  * Fixed issue displaying source images for multimodal RAG

  * Added ability to specify completion settings in Retrieval-Augmented LLMs

  * Improved performance of document embedding for documents with many pages




### LLM Mesh

  * Anthropic & Bedrock: Added support for Claude Opus 4.1, Sonnet 4.5, Haiku 4.5 models

  * Bedrock: Added support for specifying a native Bedrock guardrail

  * Hugging Face: Added support for Mistral 3.2 & Magistral models

  * Hugging Face: Added ability to use “trust remote code” for embedding models

  * Hugging Face: Added settings for autoscaling

  * Free queries (when the cost is explicitly set at $0) are now allowed even when a quota would otherwise block execution




### Machine Learning

  * Experimental support for `model.get_predictor` called from outside DSS

  * Fixed filtering of time series information criteria

  * Fixed numerical filtering of model coefficients

  * Fixed display of model coefficients when some are missing

  * Fixed possible issue during score/evaluate recipe preprocessing on time series forecasting models using exclusively past-only features

  * Fixed computation of minimum number of data points to score time series forecasting models using classical ML algorithms

  * Fixed possible issue running What-If scenarios on some time series forecasting models

  * Fixed training of time series models when some metrics are selected before training

  * Fixed training of Ridge regression models using auto-optimization of the regularization term

  * Fixed unclear error message when a time series forecasting model is run on multiple folds and some don’t have enough data

  * Fixed scoring of shared models for users without permissions on the source project of the model




### Datasets and Connections

  * Snowflake: Allowed separate proxy configurations for Snowflake and OAuth endpoints

  * Snowflake: Fixed fast path failing if dataset contains columns of type date only with values formatted using slashes (e.g. 2024/12/31 instead of 2024-12-31)

  * Databricks: Added support for Azure Databricks OAuth2 for Databricks volumes in addition to EntraID (aka Azure OAuth2)

  * BigQuery: Cancel jobs on BigQuery side when cancelled on Dataiku side

  * BigQuery: Fixed issue where invalid data in complex type columns could cause enormous amounts of logs

  * BigQuery: Fixed writing datasets containing empty values (null) for array columns

  * S3: Fixed performance issue when accessing custom S3 endpoints from a VM where 169.254.169.254 hangs

  * S3: Fixed performance issue when accessing S3 endpoints without selecting a region, from a VM where 169.254.169.254 hangs

  * S3: Added ability for S3 connection to retrieve credentials from environment in Event server

  * Sharepoint: Improved error messages in case of failure

  * Editable: Fixed issue where pressing Enter incorrectly added the word ‘Enter’ to empty cells

  * Internal stats: Now computes the schema when creating a dataset without requiring manual testing first

  * Filesystem: Added an option in connection’s advanced settings to force at import time the path of datasets exported with data

  * Reinstated the mapping of Oracle DATE to string on dataset for migration when coming before DSS 13.4.0




### Visual Recipes

  * Prepare: Fixed some display issues in the header

  * Prepare: Fixed trimming of null character (u0000)

  * Prepare: Fixed an issue where the Date Difference step did not correctly initialize the new country code and timezone settings

  * Prepare: Fixed parsing dates on Snowflake on columns of type TIMESTAMPNTZ read as strings

  * Join: Fixed issue when a column of type “Date only” is used as join condition and contains values formatted using slashes (e.g. 2024/12/31 instead of 2024-12-31)

  * Join, Group, Window: Fixed computed column with asDateOnly failing with DSS engine

  * Hive: Fixed validation of Hive recipes with Hive tables containing columns of type “date only”.

  * Formula: Fixed toString() method not taking into account format parameter for values of type “date only” and “datetime no tz”




### Flow

  * Fixed issue sharing a dataset to a Flow zone from within a Flow zone

  * Fixed refresh of Flow after a recipe copy failure

  * Fixed some failing case of copying a SQL recipe within a project




### Charts and Dashboards

  * Charts: Fixed possible crash when using date or numerical axes with SQL engine

  * Charts: Fixed issue with “mixed” charts (lines and bars)

  * Dashboards: Fixed grid alignment issues

  * Dashboards: Fixed possible failure of dashboard export with charts

  * Dashboards: Fixed duplication of tiles on page copy for tiles inside a group

  * Dashboards: Fixed filters’ dataset selection from existing tiles for tiles inside a group




### Workspaces

  * Fixed column analysis for datasets opened from a workspace




### Statistics

  * Fixed partial auto-correlation function when using “Regression on lags using bias adjustment”




### Governance

  * Fixed artifact page scrolling to top of the page when editing a field

  * Various UI improvements




### MLOps

  * Fixed issues with using project libs in custom evaluation metrics

  * Fixed support of shared managed folders in the Evaluation Recipe

  * Fixed Model Evaluation drift computation when corresponding Saved Model Version has been deleted




### Scenarios

  * Fixed UI for “Check endpoint of external model endpoint” step

  * Fixed handling of partitioned datasets in the “Compare test datasets” scenario step

  * Fixed Integration test scenario step corrupting flow’s Python script indentation where dataset loading is replaced




### Deployer

  * Fixed git errors not being displayed when creating a bundle

  * Added the ability to define an external URL for remote deployer in Administration Settings

  * API Deployment: Fixed expansion of variables defined as Kubernetes Secrets

  * Fixed Monitoring status when there are Retrieval-Augmented models and Agents

  * Fixed false positive alerts in Monitoring when a scenario is running

  * API node: Fixed error when calling SQL query endpoints with no parameters

  * API node: Fixed exposition mode “ingress (nginx)” value not shown to view only users

  * Fixed govern status in Unified Monitoring

  * Fixed bundle deployment status sometimes inconsistent




### Collaboration

  * Fixed “Sort by Last Opened” on homepage

  * Fixed Star/Watch buttons on project homepage

  * Added ability for admin to remove notification email channel after adding it

  * Fixed missing refresh of Catalog after a Git revert operation in a project

  * Fixed the management of API endpoint tags for tags that were deleted or renamed at project level




### Coding & API

  * Fixed SelectQuery with limit statement producing invalid results on Oracle

  * Fixed `set_remote_dss` failing to connect to a DSS instance configured with a self-signed or non-trusted https certificate if REQUESTS_CA_BUNDLE environment variable is set




### Git

  * Fixed missing deletion of new files when using the “Local & Get Upstream” drop option for projects in explicit commit mode




### Elastic AI

  * EKS: Enabled EBS encryption by default

  * EKS: Fixed possible failure of first cluster startup after boot on Cloud Stacks instances

  * EKS: Removed outdated option “Revoke public access”

  * EKS: Added “custom image registry URL” configuration option for fully private clusters

  * Added Python 3.13 in default images

  * Improved performance of containerized DSS engine when running with readOnlyRootFilesystem

  * Fixed recipe and notebook failing on containerized Conda R code-env




### Cloud Stacks

  * Added Python 3.13




### Performance & Scalability

  * Improved performance of Catalog indexing, especially for projects with many training recipes

  * Improved performance of project homepage when instance has large number of projects and deep project hierarchies

  * Improved performance of Deployer Monitoring background calls

  * Fixed memory leak for plugin components with dynamic “select from Python” selectors

  * Fixed issue where dashboards could load too many charts at once, causing load spikes

  * Fixed severe performance issue on “Automation monitoring” page

  * Fixed severe performance issue when deleting many versions of partitioned models with many partitions




### Security

  * Fixed password temporarily displayed on screen in case of entering an invalid URL as Git remote URL




### Misc

  * Fixed warning appearing in code recipes executed on containers

  * Fixed some French localization issues

  * Debian/Ubuntu: Fixed possible installation dependency check failure if packages are on hold

  * Fixed double reload of the page after SSO login, which could rarely lead to fonts not loading properly

  * Fixed character encoding in variables for improved readability

  * Fixed XLSX files becoming corrupted upon upload in project libs, plugins, webapps




## Version 14.2.1 - October 29th, 2025

DSS 14.2.1 is a bugfix release.

### Agentic AI & RAG

  * Fixed “Network timeout” field in Vertex Generative AI connection

  * Fixed usage of shared agents in Python API, Agent Hub and Agent Connect




### ML

  * Fixed code environment preset for timeseries models training




### Connections

  * Fixed failure of automated refresh of access token for Databricks connection




### Deployer

  * Fixed threads leak when monitoring a VertexAI infrastructure




### Project standards

  * Fixed error when displaying project standards report from a bundle




### Flow

  * Fixed excessive required permission on ROOT project folder when copying a subflow to a new project




## Version 14.2.0 - October 17th, 2025

DSS 14.2.0 is a release with significant new features, bug fixes, security fixes, and performance improvements.

### New feature: Agent Hub

Agent Hub is a new collaborative workspace that allows all organization employees to access Enterprise Agents and create their own quick agents, in a secure and controlled environment.

For more details, please see [our introduction Blog post](<https://blog.dataiku.com/introducing-agent-hub>) and [Agent Hub](<../agents/agent-hub.html>)

### New feature: MCP (Model Context Protocol) support

Dataiku now features a new Agent Tool that leverages the MCP protocol (in “stdio” mode).

This allows you to bring 3rd party MCP servers into Dataiku and run them, and easily equip you your visual and code agents with the available tools.

It includes the ability to filter which of the tools of the MCP server you make available.

For more details, please see [Local MCP](<../agents/tools/local-mcp.html>)

### New feature: AI Portfolio Automated Tagging

Three new automatic “badges” have been added across DSS (in Projects, API Designers, Deployer, Govern and Unified Monitoring) to identify assets using machine learning (ML), Generative AI and Agentic AI.

Please be aware: Badges for existing objects will only appear in Govern after a resync is completed.

### New feature: Classical ML algorithms for Time Series Forecasting

Time Series Forecasting can now use traditional ML algorithms (Random Forest, Ridge Regression and XGBoost).

Dataiku automatically handles feature engineering of lags and windows necessary to use traditional ML algorithms as Time Series Forecasting models, with advanced tuning capabilities.

For more details, please see [Time Series Forecasting Settings](<../machine-learning/time-series-forecasting/settings.html>)

### New feature: What-If for Time Series forecasting

What-If analysis is now available for Time Series Forecasting, to interactively test forecasting scenarios.

### New feature: Visual Generalized Linear Models

Generalized Linear Models (GLMs) are a generalization of Ordinary Linear Regression. They are notably widely used in the Insurance industry to address specific modeling needs.

Dataiku now includes an interface for users to build and visualize GLM models easily. It provides a user-friendly way to create GLM models, define their parameters, select variables, define interactions, train models, visualize the results with GLM-specific visualization, and deploy the trained models.

For more details, please see [Generalized Linear Models](<../machine-learning/generalized-linear-models/index.html>)

### New feature: Visual Graph

Dataiku now includes new capabilities for:

  * Building and editing graphs visually from datasets containing nodes and edges

  * Exploring the built graphs visually

  * Performing Cypher queries on your graph, with an AI assistant for building the queries

  * Using the graph as a knowledge tool for AI Agents




For more details, please see [Visual Graph](<../graph/visual-graph/index.html>)

### New feature: Governance Policies

Expanded governance settings now include the ability to hide items, define custom rules through Python scripting, and make specific governance templates or hiding recommendations, offering more granular control beyond automatic governance.

For more details, please see [Instance Governance settings](<../governance/governance-settings.html>)

### New feature: FastAPI support for webapps

Development of webapps now natively supports FastAPI framework in addition to Flask, Dash, Shiny, Streamlit, Bokeh, Gradio and Voila.

### Agentic AI & RAG

  * **New feature** : New UI to search in Knowledge Banks.

  * **New feature** : API to search in Knowledge Banks, with a new LangChain-compatible retriever that doesn’t require to load the vector store on the client side.

  * **New feature** : when using an Extract Documents recipe with Text-based extraction, added ability to apply OCR on images. Tesseract and EasyOCR are supported as OCR engines

  * **New feature** : quickly test Agents in a Chat session directly from the Agent’s main page.

  * Agents: Tools can now return additional objects, called “artifacts”, on top of their main output, which can be displayed / used / downloaded, depending on their type.

  * Agents: Fixed possible exhaustion of the available pool by a single Agent

  * Agents: Fixed API to add an agent to a Flow Zone

  * Agents: Fixed reporting of errors thrown by Inline Python tools & plugin tools

  * Agents: Fixed usage of `post_dku_traces_to_langchain` from within an Agent

  * RAG & Agents: Added ability to filter an API query of a Retrieval-Agumented LLMs or an Agent with KB Search tools

  * RAG & Agents: Improved display of RAG and Agent sources in Prompt Studio

  * RAG: Improved side panel on Retrieval-Augmented LLMs

  * RAG: Added ability to filter retrieval from the Knowledge Bank by values from the input dataset when using a Retrieval-Augmented LLM in a Prompt recipe

  * RAG: Remote vector store connections can be used for KBs/RAG without needing “details readable by” permissions (since users don’t need the details for that)

  * RAG: Fixed usage of `knowledge_bank.as_langchain_vectorstore` from outside DSS

  * Document Embedding: Fixed possible memory overconsumption by an Embed Documents recipe on some PDF files

  * Document Embedding: Fixed Embed Documents recipe failure in case of an empty row in the metadata input dataset




### LLM Mesh

  * **New feature** : Added NVIDIA NIM support for completion and embedding models, enabling connection via NIMs or through the NVIDIA Integrate API.

  * **New models** : OpenAI & Azure OpenAI: added support for o3-pro

  * **New models** : Vertex: added support for Gemini 2.5 Flash Lite

  * **New models** : Hugging Face local: added support GPT-OSS and Gemma 3n models

  * Added ability to specify a custom cost per token for local Hugging Face models

  * Added ability to specify expert parallelism for local Hugging Face models

  * OpenAI & Azure OpenAI: custom headers can now use user & admin properties in variables

  * Fixed streaming when a guardrail responds directly to a query

  * Fixed cost accounting for streamed queries on Azure OpenAI LLMs

  * Fixed display of completion cost in Prompt Studio




### Machine Learning

  * Added ability to export a trained model’s full Predicted data, no longer capped at 50,000 rows

  * Added support for multiple custom train/test split on time series forecasting AutoML

  * Added experimental support for Python 3.13 for Visual Machine Learning

  * Added support for Deep Neural Network AutoML prediction model with Python 3.12

  * Added support for external features on Torch-based DeepAR time series forecasting models

  * Added support for scikit 1.6 in Visual Machine Learning

  * Fixed custom extrapolation dates in time series forecasting

  * Added support for the “skip scoring” option in the evaluation recipe for time series models




### Charts and Dashboards

  * **New feature** : Dashboards: Added an option to automatically stack tiles by removing vertical gaps. This functionality can also be applied manually via the context menu.

  * **New feature** : Charts: Added the ability to create a pivot table without rows or columns

  * Dashboards: Fixed export of multiple dashboards at once when using “select all”

  * Dashboards: Fixed moving tiles to an unsaved page

  * Dashboards: Fixed inconsistencies in filters when exporting dashboards

  * Dashboards: Fixed links within text tiles

  * Dashboards: Fixed numbered lists in text tiles

  * Dashboards: Fixed page reordering via drag-and-drop

  * Charts: Fixed X & Y Axis format options for Box plots

  * Charts: Fixed adaption of axis to data in grouped bubbles charts

  * Charts: Fixed percentile aggregation for the “Others” bin with DSS Engine

  * Charts: Fixed chart publishing when there is no dashboard in the project

  * Charts: Fixed treemap rendering upon creation




### Stories

  * Added the ability to create a Story by describing it to the AI Assistant

  * Added an option to lock aspect ratio when resizing slide elements

  * Added theme management for Stories to the DSS Administration panel

  * Added options to the thumbnail context menu to move slides to first or last position, to hide or show the slides, or to create new slides

  * Added search to “Add Measure / Dimension”

  * Added style settings for chart data labels

  * Various improvements on user input filters

  * Fixed thumbnails content

  * Fixed addition of filters from the AI Assistant

  * Fixed radar charts with interactive filters

  * Fixed dataset import under low disk space conditions

  * Fixed loading of generated charts

  * Fixed welcome screen discard option

  * Fixed wrong usage of proxy settings in local AI server mode




### Dataset and Connections

  * BigQuery (built-in driver): Explore view now uses cost-free API calls to generate samples on partitioned datasets when a specific partition is selected.

  * BigQuery (built-in driver): Improved performance when listing existing partitions by using the new BigQuery PARTITIONS view.

  * BigQuery (built-in driver): Improved performance when writing datasets with many timestamp or date columns, without “Automatic fast-write” configured on the connection.

  * BigQuery: Added support for native partitioning with HOUR, MONTH, and YEAR granularities

  * BigQuery: Fixed table and column descriptions not being synchronized when building a dataset in append mode

  * BigQuery: Fixed dataset testing for tables with “requires partition filter” enabled

  * BigQuery: Fixed writing natively partitioned datasets when “Automatic fast-write” is not configured on the connection

  * BigQuery: Fixed issue where “Prevent data drop in append mode” was not respected in case of an exception when reading the schema

  * BigQuery: Fixed availability of explain plan in SQL notebooks for `SELECT * FROM <table>` queries

  * Editable: Fixed error appearing after deleting several rows at once

  * Editable: Fixed cells edition after a sort operation saving the value to the wrong cell or duplicating rows

  * Sharepoint: Added ability to preview and upload empty files

  * S3: Fixed connection testing returning an error on a working connection

  * GCS: Fixed 404 errors when deleting a blob in a bucket during concurrent operations

  * Athena: Fixed indexing failures with 3.X driver

  * Fabric: Added ability to select the database when creating datasets or listing tables

  * Explore: Fixed map backgrounds on geospatial data previews




### Flow & Visual Recipes

  * Generate Recipe AI Asisstant: Added support for Sync recipes

  * Prepare: Fixed output column selection in Create If/Then steps when the original output column is no longer present in the schema

  * Prepare: Added an option to preserve empty strings in pseudonymization steps

  * SQL Script: Fixed execution on PostgreSQL databases that do not require a password to connect

  * Sync: Fixed Redshift to S3 using Parquet creating string columns for “Datetime with tz” columns




### Governance

  * Table column control enhancements: added column pinning, resizing, autosizing, and visibility controls

  * Added a button to refresh the results shown on a page without resetting filters




### Code Studios

  * “Missing Code Studio template” warnings now include the template identifier

  * Fixed error when adding a tag to a Code Studio instance




### Coding & APIs

  * Added support for scipy 1.14 to 1.16

  * Added ability to modify more properties of CodeEnvs, including Dockerfile fragments and container runtime additions

  * Added ability to duplicate the project when creating a project branch via API

  * Fixed `DSSClient.create_data_collection`

  * Added support for UNION statements in the `dataiku.sql` package

  * Added ability for recipe plugin components to specify in which section they want to appear in the right panel Action tab (Visual, Code, Gen AI or Other recipes)

  * Fixed Scala notebooks




### Git

  * Fixed dropping changes not deleting new untracked files in explicit commit mode

  * Fixed refresh of existing branches not pruning deleted upstream branches




### Workspaces

  * Fixed broken access to workspace objects when renamed

  * Fixed model report insights in the context of a workspace




### Statistics

  * **New feature** : Levene test to compare the variance of 2 or N populations




### Scenarios

  * Scenarios last runs page now displays duration

  * Added ability to filter Scenarios Monitoring page by tags and status




### Webapps

  * Fixed a redirection issue for public webapps using vanity URLs when accessed via Single Sign-On login

  * Added support for IP-bound-sessions for Code-Studio-as-Webapp

  * Fixed error when stopping a Bokeh webapp backend




### Deployer

  * API Designer: Added support for testing Lookup and SQL Query endpoints when using connections configured with per-user OAuth2 credentials

  * API Designer: Fixed testing of a prediction endpoint whose underlying model is shared from another project

  * Project Deployer: Fixed bundle creation failing when entering a bundle id and hitting “create” while bundle creation page is still loading

  * Project Deployer: Fixed the infrastructures page when an error occurs while retrieving the status of an infrastructure

  * API Deployer: Added the ability to override the K8S service account name at deployment level

  * API Deployer: Added an option to cleanup associated resources on a K8S or Static infrastructure upon DSS deployment deletion

  * API Deployer: Added support for credentials mode (global or per user) in the Databricks model deployment connection

  * API Deployer: Removed the check of nodes statuses from the computation of K8S infrastructure health status




### Cloud stacks

  * **New feature** : Alerting: Fleet manager now includes a configurable alerting system that allows administrators to send alerts by email when a DSS instance is no longer responding, or when the available disk space is low on one of its disks.

  * Removed support of ssh with hmac-sha1 or umac-128/umac-128-etm

  * Added TLS 1.3 for SSL negotiation and removed some older ciphers

  * Increased PostgreSQL sizing to better accomodate larger instances

  * Improved restart time of DSS instances

  * AWS: Fixed possible Fleet Manager errors under heavy load

  * GCP: Removed invalid requirement for an SSH key during deployment

  * GCP: Migrated template from Google Cloud Deployment Manager (which will be retired by Google on March 31st, 2026) to Infrastructure Manager

  * Azure: Fixed failure when creating or provisioning a node with an identifier longer than 60 characters




### Performance & Scalability

  * Fixed possible resource overconsumption from successive formula validation




### Security

  * Added option to lowercase identity claims in OpenID login

  * Fixed [Time-of-Check / Time-of-Use issue in UIF mechanism](<../security/advisories/dsa-2025-008.html>)




### Misc

  * DSS Home page: Added ability for administrators to restrict visibility of some promoted content cards

  * Added ability to sort and filter running background tasks in Administration > Monitoring

  * Fixed dataset builds when project global or local variables have been set to an empty string

  * Fixed `CREDENTIAL_REQUEST` plugin parameter type not honoring `mandatory: false` condition

  * Updated GeoIP database to its latest version

  * Added ability to view usages of plugins in development




## Version 14.1.4 - October 7th, 2025

DSS 14.1.4 is a bugfix release

### Charts

  * Fixed charts with vertical gridlines on dashboard when “Show x-axis” tile option is unchecked




### Connections

  * Fixed random sharepoint connection failure




### Flow

  * Fixed zoom of flow containing zones on Chrome > 141




### LLM Mesh

  * Fixed a display issue on Administration settings for Embed Documents recipes




### MLOps

  * Fixed overly broad permissions required for API deployments on K8S infrastructure




## Version 14.1.3 - September 26th, 2025

DSS 14.1.3 is a bugfix release

### Agentic AI & RAG

  * Fixed agent completion settings display




### LLM Mesh

  * Fixed index not set on Cortex tool calls




### Cloud storage

  * Azure Blob Storage: fix support of project variables in default managed datasets path




### Cloud Stacks

  * Fixed storage of DSS encryption key in AWS Secrets Manager




### Git

  * Fixed transaction error with merge requests involving shared datasets




## Version 14.1.2 - September 12th, 2025

DSS 14.1.2 is a bugfix and feature release

### Agentic AI & RAG

  * Added pre-filled test query templates for most Agent Tools

  * Improved Extract Document speed for PDF files using Text Extraction when a GPU is available

  * Improved side panel on Agents & Agent Tools

  * Added warning when another user is concurrently editing a Retrieval-Augmented LLM

  * Fixed possible hang of a Document Embedding recipe using visual extraction

  * Fixed Cohere embedding models via a SageMaker LLM connection

  * Fixed navigation from the side panel in the list of Agents

  * Fixed documentation links in Agent Tools

  * Fixed log of plugin Agent Tool that may contain credentials

  * Fixed creation of an Embed Documents recipe from a dataset and a foreign managed folder (shared from another project)

  * Fixed additional description for the Calculator Agent Tool

  * Fixed empty build of a knowledge base using a Pinecone index where the default namespace was deleted




### LLM Mesh

  * OpenAI & Azure OpenAI: added support for **gpt-5** model family and **gpt-image-1**

  * Fixed retry of requests to LLM providers that timeout

  * Fixed checkbox de/selection of a Prompt in Prompt Studio

  * Fixed fine-tuning of Llama 3.1 on Bedrock

  * Fixed tracing when using `DKUChatModel`




### Machine Learning

  * Fixed maximum size of performance information when training a regression on large test sets

  * Fixed training of AutoML Clustering models using text embedding with ML diagnostics enabled




### Project Standards

  * Added a setting to select a containerized execution configuration for Project Standards




### Charts and Dashboards

  * Charts: Fixed pivot table export to Excel when using a coloring rule with a 3-digit hexadecimal color code

  * Charts: Fixed date constant reference line definition missing the defined value after reload

  * Charts: Fixed number formatting of chart values being altered when hovering

  * Charts: Fixed display of multiple measures as bars, allowed when no color dimension is set

  * Dashboards: Fixed chart insights not using the defined color palette even with “ignore dashboard theme” option

  * Dashboards: Fixed meaning palette not used when publishing a chart to a dashboard

  * Dashboards: Fixed building of filter facets in dashboards sometimes failing

  * Dashboards: Fixed “Open another insight” for insights in other dashboards

  * Dashboards: Fixed broken search bar on Elasticsearch dataset tiles

  * Dashboards: Fixed page preview not updated when moving tiles between pages

  * Dashboards: Fixed date filter refresh issue for custom range changes on Firefox

  * Dashboards: Fixed application of theme title color on chart tiles




### Governance

  * Fixed migrations failing when upgrading from versions prior to 13.4.0 to versions 13.5.0 or newer




### Dataset and Connections

  * SharePoint: Fixed issues with site ID lookups

  * SharePoint: Added support for private sites

  * S3: Fixed bucket existence check in connection screen

  * S3: Fixed PDF preview on S3-based managed folders

  * Azure Blob Storage: added variable expansion in the “Default container” field

  * Athena: Fixed connection with JDBC 3.x driver when credentials come from an S3 connection

  * Delta: Improved error message when reading a partitioned Delta dataset with Spark where partition dimension name is not a column

  * Filesystem: Fixed permissions applied to new files on custom filesystem connections with a root folder located inside the data directory

  * Explore view: fixed clicking on a URL in a cell displaying an error message

  * Fixed “Set type” mass action in dataset schema screen

  * Fixed recipe in overwrite mode with `useTruncate` on SQL connection and “Prevent data drop in append mode” on target dataset set

  * Added ability to filter the “New Connection” dropdown




### Flow and Visual Recipes

  * Prepare: Fixed converting a relative date filter into a step

  * Prepare: Improved generated SQL query when using the “Keep/Delete columns by name” step

  * Prepare: Fixed “Increment date” step with “date only” and “datetime no tz” types

  * Prepare: Prevented backend crash when validating multiple formulas in “if, then, else statements” steps

  * Stack: Fixed error when adding a manual mapping to a Stack recipe on DSS engine

  * Fixed error message when a variable expression is malformed




### Scenario and Automation

  * Fixed “Refresh statistics & chart cache” step for dashboards containing nothing to refresh

  * Fixed dataset selection in “Refresh statistics & chart cache” step to handle shared datasets with the same names

  * Fixed variables defined in scenario steps containing Unicode characters being escaped

  * Fixed error reporting in the “Check flow consistency” step




### Flow

  * Improved performance of the pipeline Flow view




### Webapps

  * Fixed potential 404 or 502 errors when Webapp backend is deployed on a Kubernetes cluster




### Coding & API

  * Fixed style of exported Jupyter notebooks when using the built-in code environment with Python 3.9

  * Improved display of Jupyter notebook description when the related code environment has been removed

  * Fixed discussion display in Flow when closing/reopening a discussion through the Python API

  * Fixed Databricks SQL query multi-line comments stripping




### Collaboration

  * Cleaned upstream shared object references when deleting a project




### Cloud Stacks

  * Fixed nginx service not restarting correctly after installing or renewing Let’s Encrypt certificates with Route53

  * Fixed Dataiku Cloud Stacks setup on AWS with certificates on Secrets Manager




### Misc

  * Plugin store: fixed erroneous warning of “Advanced LLM Mesh add-on required” on some plugins that do not require it

  * Fixed potential memory leak when building multiple partitions simultaneously in a Prepare recipe containing join steps




## Version 14.1.1 - August 29th, 2025

DSS 14.1.1 is a bugfix, performance and security release

### LLM Mesh

  * Fixed Python custom LLM plugins in LLM recipes

  * Fixed compatibility with Dataiku Answers <= 2.4.1

  * Fixed project import and bundle activation containing agent tools for exports/bundles generated before DSS 13.5.0




### Datasets and connections

  * Fixed S3 connection with VPC endpoints

  * Fixed performance issues with S3 connection with “switch to bucket region” option set

  * Fixed jobs involving S3 cross-region bucket access

  * Fixed performance issues with S3 managed folders




### Data catalog

  * Fixed adding a dataset to a data collection from data catalog




### Visual recipes

  * Fixed error in recipes with BigQuery inputs and non-BigQuery outputs

  * Prepare: fixed issue when switching to “raw edit” mode in the “Switch/Case” “Rename Columns” processors




### Coding

  * Fixed Knowledge Bank usage via Langchain when using the dataiku package outside of a DSS instance




### Govern

  * Fixed email sending through AWS SES




### Security

  * Fixed [Improper display of cleartext API Node API key in API service history tab](<../security/advisories/dsa-2025-007.html>)




### Miscellaneous

  * Fixed access to Project Standards with old Enterprise licenses types




## Version 14.1.0 - August 12th, 2025

DSS 14.1.0 is a release with significant new features, bug fixes, security fixes, and performance improvements.

### New feature: Project Standards

Dataiku’s new Project Standards feature helps you improve project quality and production-readiness by enabling designers to build and deploy robust, production-grade projects. This feature addresses the challenge of ensuring that projects created by citizen data scientists meet organizational best practices and standards, avoiding late-stage rejections and ensuring overall quality.

Key capabilities of Project Standards include: Check Library: Create and manage checks on a Dataiku instance, with customizable descriptions, parameters, and mitigation strategies. Scope Definition: Define which checks are executed in specific projects using project keys, tags, and folders, with support for scope ordering and API package scoping. Check Execution and Reporting: Get a clean and actionable report of check results, accessible from various contexts (e.g., bundles, API packages, flows). The report can be exported, and administrators can define acceptable thresholds for unpassed checks for deployments. Project Standards help ensure that projects are built to production standards from the outset, reducing rework and increasing the reliability of deployed solutions.

### Agentic AI & RAG

  * **New feature** : search input strategy. Specify whether a Retrieval-Augmented LLM always augments its query from exact search (typically for batch or programmatic usage), or if it rewrites the query to optimize search / decide when searching is not necessary (typically for multi-turn chat).

  * **New feature** : a new Calculator tool can leverage DSS formulas to perform mathematical calculations.

  * **New feature** : New tool to call a deployed API Endpoint

  * New History tab for Agents & Agent Tools

  * New Python APIs for writing a Knowledge Bank and edit embedding recipes from a Python notebook or recipe

  * New Python APIs for creating Agents, Agent Tools and Retrieval-Augmented LLMs from a Python notebook or recipe

  * New Python API to obtain a persistent local workload folder, for use with a Code Agent, Agent Tool or Webapp

  * Set a similarity score threshold, on both Retrieval-Augmented LLMs and KB Search tools

  * Define filters on Retrieval-Augmented LLMs

  * Added a Quick Test to Retrieval-Augmented LLMs

  * A new Explore Trace button lets you directly open the trace of a Quick Test

  * Fixed Quick Test on Agents when using large test queries

  * Fixed Embed Documents recipe handling of files with names of less than 3 characters

  * Fixed deletion of agent tools and prompt studios when deleting a project

  * Fixed Send message tool error when called from a Prompt Studio

  * Fixed possible use of incorrect settings when using Retrieval-Augmented LLMs or “Search KB” Agent Tools when the KB is not yet rebuilt with the changed settings

  * Fixed project import remapping of connections used by Knowledge Banks

  * Fixed accumulation of sources across runs in “Search KB” & “Web Search” Agent Tools




### LLM Mesh

  * **New feature** : custom LLM connections can now be written in Python in plugins

  * OpenAI: added support for o3, o4-mini

  * Mistral: added support for mistral medium

  * Set custom headers on OpenAI, Azure OpenAI and Azure LLM connections

  * Local Hugging Face models: ability to set `CUDA_VISIBLE_DEVICES` if running locally without containerization

  * Local Hugging Face models: added support for using vLLM’s pipeline parallelism

  * Fine-Tunbing: added support for fine-tuning gpt-4.1 mini & nano

  * Fine-Tuning: improved display of model loss graph

  * Fine-Tuning: use the best checkpoint rather than the latest when fine-tuning a local Hugging Face model




### Machine Learning

  * Time series forecasting: added an ETS (Error/Trend/Season) algorithm

  * Time series forecasting: added ability to specify start & end dates for train/test sets

  * Time series-forecasting: added support for Torch-based versions of DeepAR & SimpleFeedForward algorithms

  * Improved display of residuals / error distribution of regression models

  * Added APIs to query the value of forecasted time series on trained models

  * Added support for sklearn 1.5 in the built-in code environment

  * Added support for torch 2 on Computer Vision models

  * Fixed display of time series forecasting model reports when residuals can contain NaN values

  * Fixed train of time series forecasting STL models when the model’s error rate is so low that the information criterion goes to infinity




### Statistics

  * Fixed multi-selection (shift-click) on filtered lists in configuration dialog for multivariate analyses




### MLOps

  * Time series forecasting: added ability to run an Evaluation recipe on any number of time steps, not necessarily a multiple of the horizon

  * Added support for text drift analysis in the evaluation recipe

  * Fixed handling of DataFrame input with missing columns in exported models

  * Fixed display of `llm_raw_response` in the row-by-row analysis of an LLM evaluation

  * Fixed display of images metadata in the row-by-row comparison of an LLM evaluation




### Dataset and Connections

  * **New feature** : Denodo connection

  * Added a “generate metadata” button from dataset schema screen

  * Added a “copy column name” button in dataset column header

  * Added support of custom cloud storage using Signature Version AWSS3V4

  * Improved detection of invalid S3 credentials when testing the connection

  * Fixed dataset display setting, kept in workspace if a conditional formatting rule is applied on the source dataset

  * Fixed dataset column custom field, preserved when reloading column description

  * Fixed default max length for BigQuery string columns

  * Fixed column conditional formatting scale rule export with Excel format when an explore filter is set

  * Fixed “Switch to bucket region” S3 connection option

  * Fixed infinite loop when listing tables of an empty Fabric schema

  * Fixed Edit schema link in side panel for Network, Uploaded, and File-in-folder datasets. Removed it on Sample datasets




### Data Quality

  * **New feature** : Added a recipe to extract all rows not matching data quality rules of a dataset

  * **New feature** : Added a dataset schema equality rule

  * **New feature** : Added a “dataset schema contains” rule

  * **New feature** : Added a “All value in a range” rule

  * Added an option to clean a specific partition check history




### Data Catalog

  * Added ability to customize which columns to display in a Data Collection

  * Added ability to put a Data Collection in the promoted content of the home page

  * Added a metadata completeness check to control addition of non-compliant datasets to a Data Collection




### Flow and Visual Recipes

  * Flow: Improved ”move flow zone” usability and performance

  * Flow: Edit schema screen can now be reached from the side pannel

  * Flow: Fixed navigation behavior when opening a dataset shared into a flow zone

  * Flow: Fixed focus when coming from a dataset shared between flow zones

  * Flow: Fixed search result link for shared managed folder

  * Flow: Fixed coloring with “Last build duration” flow view when switching from linear to log scale option

  * Flow: Fixed error when using the “Check consistency” flow action on an empty coding recipe

  * Prepare: ignore disabled steps when computing recipe status

  * Prepare: improved display of formula and Python steps in side panel to show their content

  * Prepare: visual if processor can now, when possible, be converted to DSS formula

  * Prepare: fixed Trim processor with non breaking space character

  * Prepare: fixed preview button after generating preparation steps

  * Prepare: removed daily saving time shift for recent dates in `America/Sao_paulo` or `Brazil/East` time zones

  * Prepare: fixed “Convert Unix timestamp” processor with negative timestamps

  * Prepare: added a default value of String transformation step when added through the column header of the prepare recipe

  * Prepare: deprecated the in-memory join processor in favor of the join recipe

  * Prepare: deprecated the in-memory fuzzy join processor in favor of the fuzzy join recipe

  * Prepare: deprecated the in-memory geo join processor in favor of the geo join recipe

  * Join: Fixed “keep unmatch rows” option when used in a SQL or Spark pipeline

  * Pivot: fixed max modality name length in on “count” aggregation

  * Improved performances of App-as-Recipe run

  * Fixed Snowflake to Cloud storages fast paths when the Snowflake account has PREVENT_UNLOAD_TO_INLINE_URL or respectively PREVENT_LOAD_TO_INLINE_URL set

  * Fixed Azure/Databricks fast path when using OAuth2 on an Azure connection configured with a private app




### Coding & API

  * Added support for Pandas 2.3

  * Added support for numpy 2 in the built-in environment

  * Added `ai_generate_description` public API methods to `DSSProject`, `DSSFlowZone` and `DSSDataset`

  * Added a Python API method to list the plugins used by a project

  * Added ability to include shared datasets when listing dataset of a project with the Python API

  * Added ability to list the datasets of a project matching a given set of tags with the Python API

  * Added a `get_data_steward` method to dataset settings in Python API




### Git

  * Improved navigation between projects when switching branches




### Collaboration & Onboarding

  * **New feature** : Dataiku AI Q&A Assistant in the help center

  * **New feature** : administrators can now personalize the promoted content displayed on the home page

  * Workspace favorites items are now visible from the home page

  * Fixed display of global tags




### Charts

  * Added differentiated URLs for each chart

  * Added an option to hide empty bins

  * Added support for negative values in stacked bars

  * Moved all number formatting settings from measure to the “Format” menu

  * Added ability to customize “Placement mode” and Spacing” of Values in chart for each measure

  * Fixed aggregation sorting when in SQL engine

  * Fixed transition from geometry map to scatter map when using a categorical column for the details

  * Fixed KPI alignment settings getting dropped upon modification of other settings

  * Fixed chart display when using “Generate one tick per bin” with many bins




### Dashboards

  * Added automatic save of Jupyter Notebooks when publishing to dashboards

  * Improved tile placement

  * Added keyboard navigation between pages (see [Dashboard concepts](<../dashboards/concepts.html>))

  * Fixed the moving of tiles from one page to another

  * Fixed indefinite looping of export when there are groups of tiles

  * Fixed scroll of text tiles when their text is cropped




### Stories

  * Added a “Back to workspace” button (top left bird)

  * Added support for GIFs

  * Improved slide navigation

  * Searching a dataset now filters instead of just highlighting

  * Fixed slide thumbnail for videos




### Scenario and automation

  * Fixed “Refresh statistics & chart cache” step sometimes returning success before the chart cache is actually refreshed

  * Fixed Dashboard selection in the “Refresh statistics & chart cache” step when there are multiple dashboards with the same name




### Deployer

  * **New feature** : Deployments now include an update history

  * Added an API on project deployments to execute test scenarios on the target automation node

  * Added a Horizontal Pod Autoscaling RAM limit option for Kubernetes infrastructures

  * Added ability to set an arbitrarily high Unified Monitoring batch frequency

  * Fixed Unified Monitoring’s Project Alerts for multi-node infrastructures




### Governance

  * Added a new widget to the home page displaying all tasks assigned to the logged-in user

  * Added documentation links to the home page

  * Added support for Project Standards reports

  * Added support for Bundles’ release notes

  * Improved the definition of conditions for conditional views

  * Fixed possible scroll issues on permissions settings page when an edited field is temporarily invalid

  * Fixed DSS synchronization to skip temporary application instances




### Cloud stacks

  * Azure: Fixed removal of virtual network secondary subnet value

  * AWS: Fixed provisioning of Load Balancer with name longer than 32 characters

  * Added a Python API to enable/disable a setup action




### Security

  * **New feature** : administrators can now specify permissions on instance-level messaging channels

  * Fixed [Hugging Face token printed in logs of an uncontainerized fine-tuning recipe](<../security/advisories/dsa-2025-006.html>)

  * Improved user experience when transferring project ownership




### Webapps

  * Fixed the Webapp settings’ Refresh button




### Miscellaneous

  * Fixed handling of removed parameters in Development plugins

  * Added support for comments in definition of global and project variables

  * Added a search field to the “New component” dialog of plugin development

  * Fixed project folder when using a project creation macro from a folder’s page




## Version 14.0.2 - July 31st, 2025

DSS 14.0.2 is a bugfix and feature release

### Agentic AI & RAG

  * Fixed Agent Connect on Dataiku Cloud

  * Improved “Send Message” tool with more advanced templating

  * Added ability to set a metadata dataset as input on the Embed Documents recipe, to add metadata to the output Knowledge Bank

  * Added ability to specify a column containing document-level security tokens in the Embed Documents recipe

  * Added support for document-level security tokens when querying Retrieval-Augmented LLMs via API

  * Added warning when another user is concurrently editing an Agent

  * Added ability to install the dependencies required for the Embed Documents recipe’s text-only extraction on RHEL

  * Added support for “Dataset Lookup” tool usage with Vertex Gemini models

  * Fixed recursive build not propagated upstream of Agents

  * Fixed deletion of Retrieval-Augmented LLMs when the source KB is deleted

  * Fixed document extraction when the window size exceeds the number of pages (or ≥ 2 on image files)

  * Fixed possible hangs in the Embed Documents recipe

  * Fixed possible memory overruns in the Embed Documents recipe when processing a very large number of documents

  * Fixed extraction of PDF files with inconsistent ICC profiles




### LLM Mesh

  * Vertex Generative AI: added support for Gemini 2.5 Pro & Flash, Gemini Text Embedding, Text embedding update 005

  * AWS Bedrock: added support for Claude 4 model family

  * Anthropic: added support for Claude 4 model family

  * Fixed JSON mode when streaming completion responses on Local Hugging Face models




### Machine Learning

  * Fixed training of custom models that do not output probabilities, when using K-fold cross test

  * Fixed training of models using custom metrics that need probabilities, when using K-fold cross test

  * Fixed training of calibrated classifiers using sparse matrices

  * Fixed listing of prediction models in API Designer

  * Fixed filtering train/test set with a formula containing a variable




### MLOps

  * Added automatic discovery of code environment and containerized execution settings when using MLflow import APIs from a Dataiku Python notebook

  * Added “number of evaluation windows” as a label in the Model Evaluations for Time Series models

  * Added the display of worst value for custom metrics in the Model Evaluation Store

  * Fixed column selection in the results validation settings of the test scenario step

  * Fixed model export to automatically cast categorical features to strings




### Charts and Dashboards

  * Charts: Fixed handling of percentiles producing no data

  * Charts: Fixed the theme’s default continuous palette not being applied when selecting a theme

  * Charts: Fixed “in-chart titles” theme typography settings wrongly applied to radar axis labels

  * Charts: Fixed resetting of axis labels font wrongly enabling the “Add background” option on some charts

  * Charts: Fixed black and white being added to theme color palette when resetting it

  * Charts: Fixed formatting settings not being updated upon theme modification

  * Charts: Fixed mass selection of alphanumeric filter facets

  * Charts: Fixed KPI disappearing after reverting theme

  * Dashboards: Fixed application of theme’s general typography settings to the different kinds of tiles




### Flow

  * Fixed display of implicit (dotted) flow links between some objects in different zones

  * Fixed display of implicit (dotted) flow links from objects shared from another project




### Dataset and Connections

  * **New feature** : Experimental support for connecting to Dremio

  * Fixed listing of files when creating a new “Files in Folder” dataset

  * Fixed plugin datasets that use date selector settings

  * Fixed column filter in Explore > “Columns quick view”

  * Added ability to choose the name of the worksheet when exporting a dataset to Excel

  * BigQuery: Added an option on connections (overridable at the dataset level) to prevent DSS from writing into a BigQuery table if the dataset is partitioned but the underlying BigQuery table is not

  * Databricks: Fixed a race condition when synchronizing table and column descriptions when building multiple partitions at the same time

  * Databricks: Fixed “timestamp_ntz” columns being ignored during schema detection

  * SQL Server: Fixed errors caused by inserting Infinity values

  * Azure Blob: Fixed potential OAuth2 token expiration in case of long running activities

  * Azure Blob: Fixed creation of external datasets from Parquet files when hierarchical namespace is disabled

  * Sharepoint: Fixed connection becoming unusable when switching from OAuth2 to Private key authentication

  * RedShift, Oracle, PostgreSQL: Added synchronization of column descriptions when creating a database table

  * ElasticSearch: Fix writing in append mode when dataset contains a column of type “Datetime with tz”

  * Descriptions are now truncated when they are longer than the maximum allowed by the database (ex: 2048 characters for MySQL)

  * Fixed writing to Delta datasets partitioned by day generating files using date+time pattern

  * Fixed writing to Delta datasets partitioned by hour generating incorrect results if the server timezone is different from UTC

  * Fixed the Explore view of an empty CSV based dataset created with Spark




### Visual recipes

  * Prepare: Fixed race condition on Snowflake when running a Prepare recipe with steps executed as UDF on a partitioned dataset

  * Prepare: Added SQL support for “Find and Replace” steps using regular expressions

  * Prepare: Added SQL support for the `asDatetimeTz` function in formula steps

  * Prepare: Fixed “Parse Date” step with patterns using SSS (milliseconds) failing to parse values with 0 milliseconds when run under Spark

  * Prepare: Fixed `asDateOnly` function producing incorrect values in formulas when executed on Snowflake with SQL engine

  * Join: Improved error message displayed in case of mismatch between the configuration of the recipe and the input datasets schemas

  * Pivot: Fixed incorrect values that could be produced when running with the DSS engine

  * Distinct: Added a new “on all columns” option to automatically include columns added in upstream recipes in future changes

  * Window: Fixed misalignment of columns and job failures when the upstream schema changes

  * Window: Fixed output column type of average of Date only columns

  * Group: Fixed concat aggregation on string columns when running with the DSS engine

  * Fixed Databricks engine when Spark is not configured on the DSS instance

  * Upsert: Added cross‑connection dataset support using DSS engine

  * Sharepoint: Added “List access” recipe to output per-file authorizations based on DSS user groups and associated Entra groups




### Coding & API

  * Fix possible incorrect URL returned in `webapp.get_backend_client()`

  * Added ability to view project libraries with read-only access to project




### Governance

  * Added missing field types (Files, Times Series, JSON) in the fields selector for custom filters

  * Added ability to define an external URL in the Govern integration settings

  * Improved synchronization performance when objects have been deleted

  * Fixed application of text wrap option for text fields in a table cell

  * Fixed the wrapping of the name column in tables




### Deployer

  * API deployment: Added ability to use Kubernetes `ingressClassName` fields instead of the annotation for API deployer infrastructure

  * API deployment: Added support for setting Kubernetes Topology Spread Constraints both at the infrastructure level and at the deployment level

  * API deployment: Added support for defining environment variable as Kubernetes Secrets in the API Deployer Infrastructure settings

  * API deployment: Added ability to specify “Pod disruption budgets” for API deployments on Kubernetes




### Elastic AI

  * Added libglvnd-glx in the docker base image (which makes it easier to use packages such as OpenCV out of the box)

  * Webapps exposition: Added ability to use Kubernetes `ingressClassName` fields instead of the annotation

  * Webapps exposition: Added support for setting Kubernetes Topology Spread Constraints

  * Webapps exposition: Added ability to specify “Pod disruption budgets” for WebApps on Kubernetes




### Cloud Stacks

  * Fixed Govern Integration settings consistency with nodes directory in case of an invalid govern node id

  * Fixed race condition leading to “Device has unexpected filesystem” when reprovisioning DSS




### Hadoop

  * **New feature** : Added support for Cloudera Base on Premises 7.3.1




### Stability & Performance

  * Fixed potential instance freeze when calling project.get_job().get_log() on a job with massive logs

  * Fixed potential instance freeze when a very large dataset is selected as parameter for Dynamic dataset repeat

  * Added safety limits on SQL notebook and SQL scenario step result size

  * Fixed potential freeze of the Jupyter subsystem




### Misc

  * Dataiku Apps: Fixed refresh of variables in Variable Display tiles after running a job or scenario

  * Webapps: Fixed Code Studio streamlit backend not correctly detected as started when configured with “launch for webapps”

  * Fixed sorting of plugins by Name

  * Fixed inability to select input datasets when creating Python, R, or Spark scala recipes from notebooks

  * Added warning messages in recipes and their input & output datasets screens when a partition dependency is set to “All available” while both input and output datasets are partitioned




## Version 14.0.1 - July 17th, 2025

DSS 14.0.1 is a bugfix release

### LLM Mesh

  * Ensured retrieval-augmented LLMs have an active version when activating a bundle

  * Added containerization support for the text extraction process of Embed Documents recipes




### Dataiku applications

  * Added an option to hide the Generative AI menu on app instances




### Datasets and connections

  * Fixed BigQuery dataset when project id is not set at dataset level

  * Fixed ‘DataFormat’ error when importing a Excel export into Power BI

  * Added a connection setting to use default catalog/schema to “auto-resolve” not-fully-qualified datasets when checking table existence




### Folders

  * Fixed file renaming modal




### Charts

  * Fixed filtering from a cell value when using custom coloring rules on pivot tables




### Flow

  * Fixed dataset creation not taking into account the current flow zone




### Code Studios

  * Fixed Code Assistant in VS Code




### API Node

  * Fixed API nodes deployment when a package contains endpoints using different code environments




### Misc

  * Fixed Event server when using a S3 connection with STS for storage

  * Fixed possible error when invoking some LLM custom plugins




## Version 14.0.0 - June 27th, 2025

DSS 14.0.0 is a major upgrade to DSS with major new features.

### New feature: New home page

A completely new home page for Dataiku has been introduced.

The home page brings together your projects, your recent items, learning content from Dataiku as well as content from your administrator in a refreshed and modern interface.

The projects listing has been upgraded with new capabilities such as easier moving of projects, a table view for quick mass operations on projects, a tree view for better organization of your projects, and better search across projects.

The data catalog is now directly accessible within the home page for more efficient exploration of your data.

### New feature: Dashboards and Charts Theming

The platform now supports the use of reusable themes to enhance the visual presentation of charts and dashboards. These themes facilitate the standardization of colors, fonts, and design elements, thereby ensuring a professional and branded aesthetic. This functionality allows users to establish a consistent visual identity across their visualization assets, effectively reflecting their organization’s branding.

### New feature: Automatic throttling for LLM connections

A new system has been added for automatically throttling requests to [LLM API providers](<../generative-ai/llm-connections.html>). This gives you finer and simpler control over the speed at which requests are issued, to better handle cases where you only have limited quotas on your LLM provider.

For more details, please see [Rate Limiting](<../generative-ai/rate-limiting.html>)

### New feature: Enhanced documents embedding

The Embed Documents recipe can now embed PDF, DOCX, PPTX and more using text-only extraction. This does not use a Vision LLM, and is faster and cheaper when the documents do not need a visual interpretation. Note that this requires using a new internal code env (“Document extraction”), which needs to be set up.

The Embed Documents can now avoid re-processing documents you’ve already processed with the new Smart Sync, Upsert and Append modes.

The Embed Documents recipe is now faster, even when using visual extraction

### New feature: AI-Assisted Metadata & Metadata synchronization

A new (optional) AI Assistant now helps you generate dataset metadata and column descriptions.

On SQL datasets, table and column descriptions can now be automatically synchronized to the underlying SQL table. This is enabled by default on Snowflake, Databricks, BigQuery and MySQL.

### New feature: Deployment Alerts

In Unified Monitoring, administrators can now configure alerts for Project and API Endpoint deployment statuses, with notifications deliverable via various channels

### New feature: Model evaluation for Time Series forecasting

Dataiku now integrates its Model Evaluation capabilities with time series forecasting models. This enhancement allows you to visualize the evolution of key metrics, set custom alert thresholds—including per-identifier thresholds via code—and detect performance drift over time. Delve into detailed comparisons of forecasts versus actuals, pinpoint problematic identifiers, and gain deeper insights into your model’s behavior.

### Agentic AI & RAG

  * **New feature** : Code tool. You can now directly write your own custom tool in Python, allowing other users to leverage it without writing code.

  * Generative AI and Agentic AI now has a dedicated top bar menu

  * Retrieval-augmented models are now shown in your project’s Flow, linked to their parent Knowledge Bank, with configuration of sources for display in Chat UIs

  * Retrieval-augmented models: added support for streaming the response

  * Improved linking of Agents in the Flow with the elements their tools are using, e.g. other Agents

  * Fixed creation of Agents in Flow zone

  * Fixed possible exclusion of Knowledge Banks in recursive rebuilds

  * Fixed failure of Retrieval-Augmented models queries when an image (corresponding to a page from an Embed Documents recipe) is not found

  * Fixed retrieval of such images when the project was imported and the KB not rebuilt

  * Fixed usage of shared Agents in Prompt Studio Chats




### LLM Mesh

  * AWS Bedrock: Added support of Nova models in Fine Tuning and Agents

  * AWS Bedrock: Added DeepSeek R1

  * Local Hugging Face: simplified LLM IDs for usage in API

  * Cortex LLM: Added ability to use per-project role switching when connecting through OAuth2




### Machine Learning

  * Improved auto-detection of time series forecasting settings

  * Fixed image classification model scoring when using `get_predictor` from a container

  * Fixed horizontal axis labels on the Partial Dependence plot

  * Fixed header names in time series forecasting model metrics table

  * Fixed column descriptions edition from the analysis page

  * Fixed disabled classes filter in the Design of an Object Detection task




### MLOps

  * Added a Prometheus compatible public API endpoint for retrieving different deployment metrics (only statuses at the moment)

  * Added the ability to import MLflow models into the Flow without writing code

  * Added the ability to use shared datasets as evaluation datasets when importing MLflow models

  * Added support for partially labelled data in the Evaluation Recipe

  * Fixed Evaluation Recipe on time series asking for metrics dataset schema update while even on newly created recipe

  * Fixed an issue in the Model Evaluation Store where metrics display settings in the status tab were reset by Status checks settings changes




### Dataset and Connections

  * **New feature** : Added ability to set a range of cells when importing Excel files

  * **New feature** : Added a connector to Treasure Data

  * **New feature** : Sample datasets directly integrated in DSS allow you to quickly get started. Admins can define their own sample datasets

  * Added a “Push description” button in the schema table of dataset

  * Reduced Excel export size

  * Databricks: Fixed wrongful request for OAuth2 authorization endpoint when working with application-level OAuth2 (client_credentials grant)

  * Conditional formatting: Added ability to define min and max when exporting a numerical column colored by scale

  * Conditional formatting: Fixed possible race condition when used on large datasets (more than 200 columns)

  * Conditional formatting: Added color interpolation on column coloring

  * Conditional formatting: Added ability to define custom colors in scale mode

  * Conditional formatting: Added support of scale coloring on Excel export and scenario mail reporter dataset attachment

  * Conditional formatting: Included rules in dataset export even if unused in current display mode

  * Managed folders: Fixed unexpected scrollback on long file preview

  * Managed folders: Fixed wrong warning on shared managed folders if the user has only read permission on it

  * Improved error reporting when using geo preview on improperly formatted data

  * BigQuery: Added ability to write columns of type Array and Object using Storage API

  * BigQuery: Fixed failure when reading very large tables

  * Replaced failure by warning when failing to synchronise dataset description in DB

  * Fixed call to action “Connect your account” sometimes not appearing when exploring datasets

  * Athena: Fixed issues with JDBC driver version 3




### Flow

  * A brand new empty Flow page helps you get started quicker, including using sample datasets directly integrated in DSS.

  * Fixed double scroll on Flow view when using Google Chrome on Windows

  * Added ability from the Flow or from the project home page, to view the folder where the project is, and to move the project to another folder

  * Keep column search field value of side panel when clicking on another dataset

  * Improved resilience of Flow Document Generator with unexpected characters




### Visual recipes

  * Join: Fixed post-join computed columns with “anti join” join type

  * Prepare: Fixed “Saved” button not clickable when setting “Error column” in formula step

  * Prepare: Fixed prepare recipe processor recommendations from the column header when column meaning is “Datetime no tz”

  * Prepare: Improved support of negative number in scientific notation with “Convert numeric format” processor

  * Upsert: Fixed upsert with DSS engine on Redshift connection with fast-write enabled

  * Added a keyboard shortcut to run recipes (shift+enter)

  * Fixed some formula functions that silently returned null instead of explicitly failing when called incorrectly




### Charts and Dashboards

  * **New feature** : Manual Binning and Reusable Binned Dimensions: Added the ability to manually define bins for numerical dimensions in charts, along with the ability to create virtual columns from numerical dimensions at the dataset level, that serve as reusable binning configurations.

  * **New feature** : Dashboards tiles groups: Added the ability to group multiple tiles together. Groups can then be formatted, moved, or resized like single tiles.

  * Charts: Fixed pivot table layouts broken by column names with two dots.

  * Charts: Fixed chart size on loading and double legend

  * Charts: Fixed handling of empty bins in color measure

  * Charts: Fixed Sankey chart so that the whole color mapping is not reset when a column is removed

  * Charts: Fixed tooltips in treemaps

  * Charts: Fixed rounding errors in bar charts when not in one-tick-per-bin mode

  * Charts: Fixed Y axis overflow in binned rectangle charts

  * Charts: Fixed cross-filter exclude for “no value“

  * Dashboards: Added the ability to justify and set vertical alignment of text tiles

  * Dashboards: Fixed saving confirmation modal not disappearing when going to view mode after having created multiple new pages

  * Dashboards: Fixed dataset renaming breaking associated filters




### Scenarios and automation

  * Properly surface errors in run conditions

  * Fixed Scenario-level variables not taken into account when running recipes with Containerized DSS engine

  * Fixed “Schedule” side panel button storing current project key in scenario configuration




### Deployer

  * Allowed Unified Monitoring period above 1 hour

  * Fixed issue with API services deployed from the automation node when using legacy non-versioned code envs on the automation node

  * Fixed Unified Monitoring log rotation issue under some race conditions

  * Fixed the fetching of project deployments status for out of sync deployments

  * Fixed the handling of Govern status when Govern integration is disabled

  * Fixed the display layout of unsaved test queries responses

  * Fixed spikes in “Response time” charts




### Governance

  * Govern now requires PostgreSQL 12.5+ (previous versions revealed a bug impacting Govern). Generally speaking, we recommend using an up-to-date minor version of PostgreSQL, which will include the latest fixes.

  * Improved the performance of the syncing of deleted projects, which also improves performance for syncing new or modified projects

  * On Cloud, added a menu to go back to launchpad

  * Fixed Govern modal not loading for users with restrictive permissions on certain fields

  * Fixed table display when user has no access permissions on the underlying blueprint version

  * Fixed the handling of the deletion of agent versions

  * Fixed LLM tag filter for projects with an Answers webapp

  * Updated Govern installation documentation to upgrade database requirements to Postgres 12.5+, as versions 12.0 to 12.4 revealed a bug impacting Govern. Generally speaking, we recommend using an up-to-date minor version of Postgres, which will include the latest fixes.




### Data Catalog

  * Added ability to search for charts

  * Fixed default flow zoom when reaching a dataset from the catalog

  * Fixed “Last build” information in data collection when object has never been built




### Collaboration

  * Added a button in project home page side panel to move it to an another folder

  * Fixed invitation and grant emails not being sent when creating project through the public API

  * Column Lineage: Added ability to see and notify data stewards

  * Fixed workspace item name change not reflected in preview




### Coding & API

  * Added ability to change the Python interpreter of a code environment

  * Added ability for non-admin users with code environment management permission to create & update internal code environments

  * BigFrames integration: Fixed handling of recipes from partitioned BigQuery dataset to partitioned BigQuery dataset




### Stories

  * **New feature** : Stories Themes: Introduced theme selection for stories, allowing users to change the visual style of presentations. These themes are pre-designed, with administrators having the option to add more. Users can also customize the active theme within a presentation by manually editing visual elements.

  * Added an option to “Correct” in the text assistant

  * Fixed “Copy to clipboard” on generated insights

  * Fixed slide assistant when asking for filters on Snowflake datasets




### Git

  * When resolving merge conflicts, it’s now possible to directly accept all changes from either the branch or the base




### Elastic AI

  * Upgraded OS for container images to AlmaLinux 9




### Cloud Stacks

  * Upgraded OS to AlmaLinux 9

  * Added the possibility to activate Dataiku Stories in the instance templates

  * Added stricter anti-DoS setting on SSH server

  * Removed deprecated fm-cli

  * Upgraded Ansible used for setup tasks to Ansible 11




### Misc

  * Regularly remove old Excel export temporary files

  * Python 3.12 is no longer experimental

  * Added support for Debian 12

  * Fixed issues with webapps that handle frontend-side routing (such as Angular) when accessing through the Direct Access URL

  * Fixed horizontal pod autoscaling when deploying webapps from Code Studio

  * Removed the legacy constraint on “urllib<2” in code envs

  * Fixed erroneous reporting of warnings status for jobs with multiple recipes

  * Fixed proper cgroup protection of Visual Statistics processes on OS with CGroups V2

  * Fixed installation of R integration on Debian 11

---

## [release_notes/agent-hub]

# Agent Hub Release notes

## Version 1.3.1 - Apr 20th 2026

### New feature: Agent Chat export recipe

An export recipe has been added to Agent Chat, similar to the Agent hub export recipe.

### My Agents

  * The new ‘My Agents’ projects, will embed documents using a window mode with 5 pages and an overlap of 1 to improve the performances.




### Chat interface

  * Fixed missing title generation issues: Title generation now begins at the start of the streaming process, leveraging only the user’s query.




### Miscellaneous

  * Fixed ‘NotRequired’ import path for Python < 3.11 compatibility.




## Version 1.3.0 - Apr 14th 2026

### New feature: Agent Chat

Agent Chat is a dedicated web app to chat directly with either a model or an agent, offering a quick-to-set-up chat interface.

### New feature: Chat to dataset in My agents

Agents in the ‘My Agents’ section can now be connected to SQL datasets, making it easier for end users to explore and interact with trusted data they already have access to through workspaces and data collections.

Prerequisites:

  * This feature requires the Dataset SQL Query tool, available in Semantic Models Lab plugin version 0.2.0 or later.

  * Only SQL datasets can be connected to agents, and they must belong to a workspace and/or a data collection

  * To activate this capability, webapp administrators must enable Enable datasets in Agent Hub admin settings and allow browsing from workspaces and/or data collections.




### New feature: Localization

Agent Hub is now available in Japanese and French, helping organizations support a broader range of users and improve adoption across international teams. Users can select their preferred language from the left panel in Preferences.

### New feature: Support multimodal outputs from agents

Images and other multimodal outputs generated by agents are now displayed directly in the chat interface and can be downloaded, improving the usability of multimodal workflows and making visual outputs easier to review and share.

### New feature: Agent context configuration settings

A new advanced settings section in the Admin panel gives administrators more control over the context shared with agents, making it easier to balance richer agent behavior with governance and security requirements.

### Bring Your Own Document

  * New feature: Agents now support attachments, making it easier for users to bring their own content into conversations and work with richer business context.




### Human-in-the-loop input edition

  * New feature: When ‘Allow editing’ is enabled for a DSS tool, users can directly edit tool call arguments in the conversation, giving them more control, reducing friction, and making human-in-the-loop workflows more efficient.




### Left panel

  * The left sidebar has been redesigned to improve navigation and make key actions more accessible. Enhancements include:

>     * A refreshed sidebar design for a clearer, more intuitive experience
> 
>     * Replacement of the Favorite section with Quick Access, giving users faster access to favorite agents and the 3 most recently used agents
> 
>     * Direct access to language settings from the sidebar
> 
>     * A virtual tour to help users quickly adapt to the new experience




### Chat interface

  * Code block rendering improvement: In the chat interface, refreshed the code blocks styling and fixed over flow issue

  * Added capability to preview file attachments preview image inside the conversation

  * Fixed single agent issue preventing other agents loading, improving application reliability and reducing the impact of isolated failures.

  * Fixed infinite loop when users opened a conversation on a slow connection and switched to another one before the first had finished loading. This improves stability and delivers a smoother user experience in low-bandwidth or high-latency conditions.

  * Fixed bar charts generation issues.




### Chart generation

  * Added capability for webapp administrators to provide additional instructions to the LLM during chart generation, making it easier to tailor outputs to business-specific needs and improve how charts align with organizational use cases and reporting expectations.




### Logging

  * Improved error logging and set application logging level to DEBUG by default.




## Version 1.2.7 - Mar 26th 2026

Requires DSS >= 14.4.0

### Chat interface

  * Fixed document upload error: missing conv_id or user_id




## Version 1.2.6 - Mar 13th 2026

Requires DSS >= 14.4.0

### Miscellaneous

  * Fixed CVE alert by updating langchain version.




## Version 1.2.5 - Mar 6th 2026

Requires DSS >= 14.4.0

### My Agents Sharing

  * Fixed an issue where missing information on a shared agent could cause the agent to fail while loading.




### Chat interface

  * Fixed conversation title generation on very small LLM models.




### Miscellaneous

Addressed dependency security alerts.

## Version 1.2.4 - Feb 27th 2026

Requires DSS >= 14.4.0

### New feature: Human-in-the-loop support for structured agents

Human-in-the-loop workflows are now supported for structured agents.

### Admin panel

  * Enterprise agent settings have been improved with drag-and-drop reordering.




### Chat interface

  * Fixed an issue that prevented PNG, JPG, and JPEG images from being uploaded in conversations.

  * Fixed an issue where the wrong augmented LLM could be triggered in certain cases.




### Settings

  * Table prefixes in the web app settings now support uppercase letters and are automatically converted to lowercase.




## Version 1.2.3 - Feb 20th 2026

Requires DSS >= 14.4.0

### New feature: Container-based execution

Container-based execution is now supported.

### Startup experience

  * Improved handling when the application fails to start by showing a clearer modal message and automatically redirecting administrators to the Admin settings.




### Guardrails

  * Document guardrails now also evaluate document titles against defined text and REGEX rules, in addition to extracted body content.




### Published agents

  * Fixed an issue where deleting a document from a published agent did not properly remove it from the published knowledge base, ensuring documents stay synchronized after re-publishing.




### Miscellaneous

  * Improved error handling in draft mode by surfacing backend errors directly in the UI instead of leaving the interface hanging.

  * Fixed an issue where the fallback title “New chat” was not persisted when the LLM failed to generate a conversation title.




## Version 1.2.2 - Feb 13th 2026

Requires DSS >= 14.4.0

### New feature: Download structured agent artifacts

Artifacts generated by structured agents are now downloadable, either directly from the chat interface or through the dedicated download panel.

### Export recipe

  * Fixed an empty date field in the export recipe caused by a type mismatch.




### Miscellaneous

  * Improved the design of the “Look & feel customization” tab in the Admin settings.

  * Improved the tool call validation card design.

  * Adjusted markdown rendering for conversation messages.

  * Improved conversation creation so user input is not blocked by title generation, especially when using a reasoning model.




## Version 1.2.1 - Feb 9th 2026

Requires DSS >= 14.4.0

### New feature: Short-term memory

Agents now support short-term memory through memory fragments when enabled at the agent level.

### Chat interface

  * Fixed missing action (including copy and thumbs up/down) buttons below assistant responses.




## Version 1.2.0 - Feb 9th 2026

Requires DSS >= 14.4.0

  * This release includes a schema upgrade. In the event of an upgrade issue, our support team can help resolve it.




### New feature: Human-in-the-loop support

Conversations with agents now include validation steps for tool actions that require explicit user confirmation, giving you more control and clarity.

### New feature: Remote PostgreSQL support

Added support for remote PostgreSQL databases, enabling centralized storage of conversations, Admin settings, and related data.

### New feature: Reasoning model visibility

Improved support for reasoning models by displaying real-time reasoning “chunks” while the agent or LLM is processing a query.

### New feature: Document content guardrails

Administrators can now enable guardrails within “Core Settings” to enforce content policies using forbidden words or regex. Documents that violate these policies are blocked from reaching the LLM provider.

  * For attachments, forbidden documents are automatically filtered out of conversations without being deleted from the system.

  * For Quick Agents, documents are screened during creation and automatically deleted if they violate the configured policies. During conversations, agents containing forbidden documents are filtered out.




### New feature: Third-party agent and tool indicators

Third-party agents and tools, such as Snowflake and Bedrock, are now more clearly identified in the interface.

### New feature: Prompt Library integration

The Prompt Library now sources content directly from collections stored in the Enterprise Asset Library of the DSS instance.

### New feature: Interface customization

Global interface customization is now available for all web app users, including:

  * White labeling: Set a default primary color, homepage title, and logos.

  * Asset management: Choose a managed folder for storing assets.




### Admin panel

  * The Enterprise Agents tab in Admin settings has been redesigned for better usability.

  * Real-time Presence badges have been added to indicate when multiple administrators are viewing the same page.

  * Selection components have been standardized, and search inputs have been added to improve the user experience.




### Agent context

  * More information about the caller is now added to the agent context, including `dkuOnBehalfOfEmailAddress` and `dkuOnBehalfOfDisplayName`.




### My Agents Sharing

  * Fixed an issue where group restrictions were applied even when the setting was disabled. Agents can now be shared with any user in the DSS instance when restrictions are turned off.




### Traces explorer

  * Fixed a bug that caused data to go missing in the Traces Explorer.




### Draft conversations

  * Document uploads are now disabled in draft conversations to prevent system errors.




### Miscellaneous

  * Updated various software packages to address known security vulnerabilities.




## Version 1.1.8 - Feb 20th 2026

### Compatibility

  * Fixed compatibility issues between Flask and Flask-SocketIO by restricting the application to supported versions, preventing unexpected errors.




## Version 1.1.7 - Feb 19th 2026

### SQL tool

  * Fixed an issue where empty responses from the Agent SQL tool could cause conversations to stop unexpectedly.




## Version 1.1.6 - Feb 9th 2026

### Chat interface

  * Restored conversation message actions after renaming a conversation and navigating between conversations. This fixes an issue where copy, thumbs up, thumbs down, and see details buttons could disappear.




## Version 1.1.5 - Feb 9th 2026

### Visibility

  * Fixed an issue in agent visibility filtering that could allow users without permission to see unintended agents. Access control is now correctly enforced.




## Version 1.1.4 - Feb 5th 2026

### Navigation

  * Fixed an issue where clicking on an agent during an ongoing conversation redirected users to the Start New Conversation page and caused the current message to be lost.




## Version 1.1.3 - Jan 16th 2026

### My Agents Sharing

  * Fixed an issue where users could only share agents with users belonging to their DSS groups. By default, agents can now be shared with anyone in the instance, and group restriction is now opt-in (through admin settings).




### Security

  * Agent Hub now includes `dkuCallerTicket` in the agent context, enabling tools to support end-user impersonation when required. This works only with DSS >= 14.3.2.




## Version 1.1.2 - Feb 9th 2026

Requires DSS >= 14.2.0, or DSS >= 14.3.0 if you want to enable VLM annotation option in BYO

### Migrations

  * Fixed an issue where table migrations failed when upgrading from v1.0.4 or earlier to v1.1.1.




### Miscellaneous

  * Resolved a security vulnerability in the Langchain core dependency (CVE-2025-68664).




## Version 1.1.1 - Dec 19th 2025

Requires DSS >= 14.2.0, or DSS >= 14.3.0 if you want to enable VLM annotation option in BYO.

### Conversation Attachments

  * The conversation attachments panel now displays the extraction mode, supporting both Vision and Text modes.

  * Webapp administrators can now choose the VLM model used for image attachments in Admin settings.




### Draft mode

  * Fixed an issue where the conversation was cleared after switching tabs in draft mode.




### Chat interface

  * Fixed a bug where sources were temporarily displayed incorrectly while the agent response was streaming.




### Tracking

  * Fixed WT1 tracking issues in standalone mode and improved WT1 event counting for the number of agents.




### RAG

  * Fixed an issue where RAG LLMs were called with the wrong ID, causing failures.




## Version 1.1.0 - Dec 8th 2025

Requires DSS >= 14.2.0, or DSS >= 14.3.0 if you want to enable VLM annotation option in Bring Your Own Document (BYO).

This release introduces significant improvements to document handling (BYO), a revamped Admin Panel, enhanced sharing capabilities, and numerous UX updates.

### New feature: Bring Your Own Document

If enabled by the webapp administrator, users can upload documents directly into the conversation context. (attachment button + drag & drop). Admin settings now include extraction mode configuration and VLM annotation support, which requires DSS >= 14.3. The document experience in conversations has also been improved.

Note: this works only with LLMs, not agents.

### New feature: Export recipe

An export recipe and custom dataset capability have been added to export the data from the SQLite store into datasets.

### Chat interface

  * New feature: Chat directly with the LLM: If enabled by the webapp administrator, users can choose to chat directly with the LLM instead of using agents.

  * Allow users to disable agents: If enabled by the admin the user can choose to directly chat with the LLM (no agents).

  * Chat input light redesign, moved switches and information inside the Agents button dropdown

  * Note: If “Document Upload in Conversation” is enabled, users will be able to chat with the LLM. If you want to completely disable this behavior, you must disable Document Upload in Conversation




### Admin panel

  * A new Admin Settings panel is available: Centralized and simplified settings directly within the web application and not the Edit tab anymore.

  * Settings are updated dynamically: After admin save, the updated settings are pushed to every user and instantly reloaded.




### Prompt Library

  * Customization options have been added to the Prompt Library in Admin settings.




### My Agents Sharing

  * Agent sharing has been improved with more granular options, allowing agents to be shared with specific groups or users within a user’s groups.

  * An “Exclude group” option has also been added for “My Agents” sharing.




### My Agents

  * My Agents can now use tools that were shared from other projects and made available in the current project (Requires DSS >= v14.3.0).




### Knowledge banks

  * Added support for jsonSnippet knowledge bank responses, including multi-column retrieval.




### Error handling

  * End users now receive an error message when an agent fails to respond or when an error occurs on the server side.




### Chat interface

  * Resolved Japanese input issues.

  * Fixed prompt input focus loss when creating an agent.

  * Fixed screenshot display for non-textual documents in Sources.




### Logging

  * Fixed an issue where the used_agent_ids database column was left empty.




### Miscellaneous

  * Addressed pentesting findings and fixed dependency security alerts.




## Version 1.0.4 - Nov 7th 2025

### Chat interface

  * Fixed duplicate message rendering after editing a message. Previously, when a message was edited, it appeared twice—once before the assistant’s response was received. This duplicate is now properly removed.




### Error handling

  * Enhanced error messages:

>     * If the backend fails to start or another error occurs, a dialog now appears stating:
>
>>       * “The application failed to load. Please make sure the service is running or check the logs for more details.”
>> 
>>       * If the application loads successfully but access is restricted, an Access Denied message is displayed instead.




### LLM prompts

  * Fixed an issue where optional instructions from the global system prompt were not being passed to the LLM.




## Version 1.0.3 - Oct 24th 2025

### Miscellaneous

  * The documentation link in the plugin description now correctly points to the latest Agent Hub guide.




## Version 1.0.2 - Oct 20th 2025

### Augmented LLM

  * Fixed a regression where Augmented LLM settings were no longer being applied.




## Version 1.0.1 - Oct 17th 2025

### Permissions

  * Fixed a crash that occurred when a user tried to access a project they didn’t have permission for (which previously crashed the thread retrieving agents).




### Settings

  * Renamed the tab referenced in the warning message when a mandatory “User Agents” setting is missing.

  * Missing mandatory settings no longer block the save action.




### Miscellaneous

  * Enabled “copy/open trace” functionality for all profiles.




## Version 1.0.0 - Oct 14th 2025

Requires DSS >= 14.2.0

### New feature: Enterprise Agents

Users can seamlessly chat with any agent available within the DSS environment, based on your web app setup. Query examples can also be defined to help users get started more effectively.

### New feature: My Agents

Once enabled by the webapp administrator, users can create, edit, and share their own agents. Once in ‘My Agents’:

  * They can use Prompt library: A comprehensive library to quickly kickstart the creation of your agents.

  * Smart mode can automatically prefill certain fields based on the agent instructions.




### New feature: Agents Library

The Agents Library provides a complete view of available agents, including enterprise, personal, and shared agents, directly inside the web app.

### New feature: Charts generation

Charts can be generated automatically or on demand based on agent response artifacts.

### New feature: Monitoring

A Monitoring dashboard allows you to track agent usage effectively through the Monitoring Dashboard available in the Agent Hub.

### New feature: Dataiku Stories

Users can craft compelling Dataiku Stories directly from your interactions with agents.

### New feature: Feedback

Users can provide feedback on agent responses.

### New feature: Agents as tool & Agents in parallel

Agent Hub can query multiple agents simultaneously, either by using agents as tools or by executing parallel calls, depending on the configuration.

### New feature: Security tokens

Agent Hub sends user information (DSS groups, login, email) as part of the context to agents, safeguarding retrieved data.

### New feature: Sources & activity

  * Users can view the sources used by agents and inspect agent activity to better understand generated responses.

  * Artifacts generated by agents can also be viewed and downloaded.




### New feature: Traces

  * Users can copy traces or open the Traces Explorer directly for deeper analysis.




### New feature: Mobile responsive design

  * The interface is fully responsive, providing a seamless experience across desktop and mobile devices.

---

## [release_notes/index]

# Release notes

---

## [release_notes/old/1.0]

# DSS 1.0 Release Notes

## Version 1.0.3 - May 15th, 2014

### New features

  * MongoDB support




### Bug fixes

  * Fix in Hive datasets synchronization when schema contains map types

  * Fix syncing of partitioned filesystem datasets to Vertica

  * Fix mapping of “int” type in Pig




## Version 1.0.2 - April 10th, 2014

### Bug fixes

  * Fix layout issues in SQL datasets and HTML apps




## Version 1.0.1 - March 18th, 2014

### New features

  * Basic support for Avro files




## Version 1.0.0 - February 6th, 2014

Initial official release of DSS 1.0

### New features

  * Visual analytics

  * Clustering

  * Support for HTTP, FTP and SSH remote files

  * R recipes (basic support)

---

## [release_notes/old/1.1]

# DSS 1.1 Release notes

## Version 1.1.5 - July 14th, 2014

Please see the 1.1.0 release notes for information about Migrations from 1.0.X

### Bug fixes

  * Fixed issue in timestamps system (introduced in 1.1.3) that caused flow to mistakenly consider datasets as out-of-date and needing rebuild.

  * Improve the way timestamps are computed for managed SQL datasets. This avoids possible OutOfMemory errors with complex SQL-based flows, especially with N->1 partition dependencies (like sliding days)




## Version 1.1.4 - July 9th, 2014

Please see the 1.1.0 release notes for information about Migrations from 1.0.X

### New features

  * Support for Apache Cassandra

  * Enhancements

  * Each MapReduce job started from a Pig recipe will now have a proper name (recipe name + output partition)




### Bug fixes

  * Fix various issues with pinlets layout on pinboard

  * Fix encoding issue with Python recipe in “write_tuples” mode

  * Don’t fail ElasticSearch synchronization if a column of type “map” contains bad data (invalid JSON / duplicate keys)

  * Fix custom Unicode characters in CSV separators




## Version 1.1.3 - July 1st, 2014

Please see the 1.1.0 release notes for information about Migrations from 1.0.X

### Enhancements

  * New storage system for Flow states. Recomputation of Flow dependencies is now much faster in presence of a large number of partitions




### Bug fixes

  * Fix publication to pinboard of “web app” insights

  * Excel extractor: Fix formatting of dates in formula-computed cells

  * Fix scroll in various list screens

  * Improve data preparation behaviour on Firefox

  * Fix various interface bugs




## Version 1.1.2 - June 17th, 2014

Please see the 1.1.0 release notes for information about Migrations from 1.0.X

### Bug fixes

  * Python processes for models now automatically select their ports to avoid possible port conflicts

  * Scrollbar in SQL notebook history has been fixed

  * SQL script recipes that contain multi-lines PL/PGSQL stored procedures have been fixed

  * The Redetect button of models now always properly works

  * The Hive recipe validator now properly handles numerical ${hiveconf:} expansions

  * The “Create insight” button in dataset menu has been fixed




## Version 1.1.1 - June 6th, 2014

Please see the 1.1.0 release notes for information about Migrations from 1.0.X

### Bug fixes

  * Fix an issue with the same recipe name in different projects

  * Fix Hive schema detection in SELECT DISTINCT queries

  * Fixes around edition of preparation script titles

  * Fix custom JDBC properties




## Version 1.1.0 - May 23rd, 2014

### Important notes about migration

Automatic migration of data from Data Science Studio 1.0.X is supported, with the exception of the “Models” parts. Models created with Data Science Studio 1.0.X cannot be used with DSS 1.1

The automatic data migration procedure is documented in [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)

After upgrading, the modification dates of datasets and recipes will not be correct until you edit them.

After upgrading, your datasets will be considered as out of date and rebuilds will be required

The “dku build” command now requires a “fully qualified” dataset name, ie PROJECTKEY.datasetName

The following deprecated features have been removed : “simple partition deps” in recipes JSON and “schemaInherits” in datasets JSON

As usual, we strongly recommend that you perform a full backup of your Data Science Studio data directory prior to starting the upgrade procedure.

### New features

#### General

  * A new projects system was introduced to ease working and collaborating on multiple projects within Data Science Studio

  * New collaboration features (tags, descriptions, timelines & activity feeds, notifications and comments) lets you easily collaborate with your team

  * A brand new navigation system provides a smoother user experience and better productivity




#### Insights

  * You can now create “insights” from visual charts, datasets, IPython notebooks and custom HTML visualizations

  * Insights can be published on the “Pinboard”, where collaborators can view them and interact with the data analysts




#### Data preparation

  * A new rendering system makes it much faster to work with datasets with hundreds of columns.

  * Custom formula editor is much simpler to use

  * New UX, documentation for all processors




#### Machine Learning

Our guided machine learning has been completely overhauled. It supports a vast choice of algorithms and parameters. You now have the ability to perform many runs and easily compare them. When you are satisfied with a model that you created, you are just one click away from using it in your Data Flow for semi-automatic prediction or even re-training.

#### Notebooks

SQL notebooks can now use Impala. Impala databases are automatically detected without any configuration. Furthermore, Impala databases are automatically refreshed when a HDFS dataset is built by Data Science Studio

#### Flow and recipes

  * New rebuild modes have been introduced : force-rebuild of all datasets recursively, and “lenient rebuild” : out-of-dates datasets are not recomputed, only non-existing datasets are

  * Much faster Hive metastore synchronization with many partitions: metastore synchronization is now incremental. The synchronization process also detects schema changes and performs a full resync in that case




#### Visual analytics

  * When performing Visualization on a SQL dataset (provided that you don’t use sampling but the whole dataset), visualization will natively use the SQL database for optimized computations.




### Major bugs fixed

  * Several SQL type mapping issues were fixed

---

## [release_notes/old/1.2]

# DSS 1.2 Relase notes

## Version 1.2.4 - September 25th, 2014

### Bug fixes

#### Data preparation

  * Fix filter returning invalid results on first call in some rare cases

  * Added Indian holidays

  * Fix an out of memory condition that could happen after several days of usage

  * Fix overflow with long column names in “Remove columns” processor

  * Fix caching issues for charts with Live Processing




#### Flow

  * Fix scrolling in recipe IO screens

  * Hive recipes and notebooks can now use “pre-init” and “post-init” scripts to deal with authorization issues

  * Fix date blacklist on non-UTC machines

  * Fix failure of Hive recipes whenever an Avro dataset existed

  * Add support for SQL schemas when syncing to Vertica




#### Notebooks

  * Fix scrolling issues

  * Improve handling of logs for Hive




#### Modeling

  * Fix the cutoff selector




## Version 1.2.3 - August 26th, 2014

Please see the 1.2.0 release notes for information about migrations.

### New features

New processor to extract information about bank holidays, school holidays and weekends in several countries

### Enhancements

Improved performance for prediction/scoring/clustering recipes

### Bug fixes

#### Core

  * Fixed installation on CentOS following IUS repository location change

  * Fixed SQL datasets when name contains some reserved keywords

  * Fixed various scrolling issues

  * Fixed Community Edition on OpenVZ machines

  * Improve startup scripts




#### Data preparation and visualization

  * Don’t use Live Processing charts for partitioned datasets

  * Fixed “Analyse” in explore view for numerical columns containing NULL values

  * Fixed Stemming option in Tokenizer processor

  * Fixed Fuzzy matching when used in Recipe




#### Recipes/Flow

  * Fixed compatibility issues with Pig 0.13

  * Fixed “View in Flow” in Chrome

  * Fixed “Run” button in Recipes Actions




#### Machine Learning

  * Fixed “Display outliers” in Clustering results scatter plot




## Version 1.2.2 - August 8th, 2014

Please see the 1.2.0 release notes for information about migrations.

### Enhancements

  * Prediction / Clustering scoring recipe works with datasets of any size.

  * Added write_dataframe in dataset writers.




### Bug fixes

  * Fixed Hive script validator compatibility with Hive 0.13

  * Fixed abnormally high UI memory usage in some cases.

  * Fixed incorrect SQL types mapping (PostgreSQL/Vertica/Redshift).

  * Fixed issue in SQL-backed charts when the Impala JDBC driver cannot be loaded.

  * Fixed a bug preventing file selection in connection’s root folder (S3/HDFS).

  * Fixed “raw values” numerical axis in charts.

  * Unicode characters allowed in target values of prediction models.

  * Worked around Pandas bug when loading large datasets.

  * Fixed the profiling feature functionality in clustering.

  * Scoring recipes append all columns to the output rather than only INPUT columns.




## Version 1.2.1 - July 29th, 2014

Please see the 1.2.0 release notes for information about migrations.

### Bug fixes

  * Fixed various UI issues.

  * Fixed charts in exported project.

  * Fixed various unicode issues in python & models.

  * Cleanup temporary files generated by R recipes.




### Enhancements

  * Switched to FreshDesk.

  * Better support of Hive 0.13.

  * Experimental Oracle and Sybase support.

  * Improved support of MapR and CDH5.

  * Dataiku’s Hive UDF jar is loaded in recipes and SQL notebooks by default.




## Version 1.2.0 - July 21st, 2014

### Important notes about migration

The automatic data migration procedure is documented in [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)

As usual, we **strongly recommend** that you perform a full backup of your Data Science Studio data directory prior to starting the upgrade procedure.

Automatic migration of data from Data Science Studio 1.1.X is supported, with the following restrictions and warnings:

  * Notebooks created from trained models using Impact Coding will not work anymore. Please remove the impact coding section.

  * SQL identifiers are now quoted and case preserving across the studio. This can cause issues with pre-existing mixed-case tables and columns.

> If you have mixed-case managed SQL datasets, it is recommended to lowercase the table name in the dataset configuration to avoid another table being created
> 
> If you have mixed-case column names, you might need to recompute your table




For migrations from Data Science Studio 1.0.X, please also see the release notes of version 1.1.0

### New features

Please also see our Blog Post for more information.

#### General

  * DSS now features a free Community Edition which allows you to use the Studio without any time limit

  * DSS now integrates a Scheduler for automatic builds of datasets. The scheduler leverages the incremental build support in order to just recompute and rebuild predictions on new data or data that has changed.

  * Support for complex types in dataset schemas has been improved. Complex types (including nested maps, nested arrays, nested objects) will properly be represented in Hive, MongoDB, ElasticSearch and JSON

  * Many non-fatal errors that can happen during processing a job are now reported in a “Warnings” tab at the end of a job, for easy verification of warnings




#### Insights

  * A whole new web app editor has been introduced. It features a much improved ergonomy, integrated code templates and snippets, and the ability to write custom Python-based backends for even more interactive webapps.

  * Various improvements have been made on the pinboard visual appearance

  * It is now possible to choose where to display the title of insights, and whether to display insight description




#### Data Preparation

  * The date parser processor now supports multiple formats. Formats are tested in order until a matching format is found

  * New processor : Geocoder, based on MapQuest or Bing API.




#### Machine Learning

  * Multiclass classification has been introduced

  * Some Machine Learning algorithms can take quite a long time to run. Data Science Studio now features integration with H2O, a distributed machine learning framework. This integration brings distributed implementations of a selected set of machine learning algorithms (Random Forest, Deep Learning, Gradient Boosting Methods).




#### Flow and recipes

  * A new “Sampling” recipe lets you create a dataset which is a sample extracted from an input dataset.

  * The Python recipe now comes with a large number of fully documented code samples




#### Datasets and connection

  * New experimental support for Teradata

  * Schemas are now supported in SQL databases. All parts of the Studio that deal with SQL tables are now schema-aware

  * Support for Apache Cassandra datasets (both read and write, partitioned and unpartitioned)




#### Notebooks

The SQL / Hive / Impala notebook has been completely overhauled for better ergonomy

#### Visual analytics

  * Better information and choices to switch between internal DSS engine or native SQL engine for charts

  * When performing Visualization on a HDFS dataset, if you use the whole dataset, and if Impala is installed, Impala will be used to compute the aggregations

  * Charts based on SQL now support Greenplum and Redshift

---

## [release_notes/old/1.3]

# DSS 1.3 Relase notes

## Version 1.3.2 - November 12th, 2014

For information about migration, please see the 1.3.0 release notes.

### Bug fixes

#### Core

  * Support for RH 6.6 and above, CentOS 6.6 and above




#### Datasets

  * Fixed various issues with Cassandra datasets




#### Flow

  * Fixed UI for sliding_days depednency

  * Fixed ‘;’ splitting in Hive recipes

  * Fixed handling of multi-dimension-partitioning in scheduler

  * Fixed “explicit” rebuild of datasets




## Version 1.3.1 - October 27th, 2014

For information about migration, please see the 1.3.0 release notes.

### Bug fixes

#### Datasets

  * Fixed writing to S3 datasets when target data did not already exist

  * Fixed writing CSV datasets with Unicode-encoded separators




#### Machine learning

  * Fixed logistic regression in multiclass mode

  * Fixed a target remapping issue that could lead to incomplete result screens for multiclass models with null values

  * Fixed the ability to switch from regression to multiclass model

  * Fixed the model comparison screen




#### Misc

  * Fixed sizing issue that could lead to unreadable categorical analysis on numerical columns




## Version 1.3.0 - October 23rd, 2014

### Important notes about migration

The automatic data migration procedure is documented in [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)

As usual, we **strongly recommend** that you perform a full backup of your Data Science Studio data directory prior to starting the upgrade procedure.

Automatic migration of data from Data Science Studio 1.2.X is supported, with the following restrictions and warnings:

  * It is strongly recommended to retrain all machine learning models as new features have been added. Non-retrained models might fail to display or to be usable in scoring.

  * JSON datasets now have built-in protections against huge files. You might need to tweak the nested arrays limits in the Dataset settings screen

  * The old job logs are not available anymore in the UI after migrating. They are still available on disk, though.




For migrations from Data Science Studio 1.1.X, please also see the release notes of version 1.2.0

### New features

Please also see our Blog Post for more information.

#### General

  * New R support

>     * R recipe to read and write datasets using our new [R API](<../../code_recipes/r.html>).
> 
>     * R notebook for interactive work

  * Visual editor for complex types




#### Datasets and connection

  * DSS now has support for many new Hadoop-related formats

>     * Parquet
> 
>     * Sequence File
> 
>     * RC File
> 
>     * ORC File
> 
> All these can be used in Hive recipes, notebooks and (for some of them) Pig recipes and Impala notebooks

  * Avro support has been greatly expanded and now supports nested complex types. Avro datasets can now be used for Hive recipes.

  * Complex types are now properly preserved when writing to MongoDB.




#### Machine Learning

  * We have introduced brand new clustering results screen. They will help you understand in much more details and with new visualizations what differenciates your clusters

  * Support for Text features has been added. Text features are processed using the Bag of Words model.

  * Random Forests models will now automatically adapt the number of trees to the optimal number.

  * You can now write your own models in Python and use them in the visual interface

  * Large performance enhancements for scoring recipes.




#### Flow and recipes

  * New “Preview” mode for jobs

>     * You can now see which datasets will be rebuilt and why
> 
>     * You can disable some parts of a job if you want to ignore it

  * You can now see which datasets are being built and have links to latest/current jobs from the Flow screen

  * You can now edit schema and check consistency directly from the recipe screens

  * New [Time Range](<../../partitions/dependencies.html>) dependencies function brings much more flexibility for time partitioned datasets.

  * You can now “write-protect” a dataset so that its already computed partitions are never automatically recomputed. This is especially useful for some slow recipes or when you use partitioning for historization.

  * Python recipe can now read and write datasets of any size. Writing was previously limited by the size of the disk of the DSS host




#### Notebooks

  * New R notebook for interactive work on DSS datasets with R

  * In IPython notebook, you can now request samples of the dataset. Only the sample will be loaded.




#### Insights

  * “Dataset” insights now feature preview of the dataset directly from within the Pinboard.

  * New JS API for Web app insights. You can now request subsamples of the datasets from your Web apps.




### Enhancements

#### Flow

  * Better validation and checks on variable substitutions




### Major bugfixes

  * Under certain circumstances, training recipes produced invalid results

---

## [release_notes/old/1.4]

# DSS 1.4 Relase notes

## Version 1.4.5 - June 23rd, 2015

### Important notes about migration

Please see the release notes for 1.4.0

### New features

  * Added support for Hive 1.1




### Bug fixes

  * Fixed FTP listing for WS_FTPD

  * Fixed Apache log file format

  * Fixed “Last value” in grouping recipe

  * Updated CentOS IUS repository URL




## Version 1.4.4 - March 30th, 2015

### Important notes about migration

Please see the release notes for 1.4.0

### New features and enhancements

  * Official support for Oracle has been added.

  * Amazon Linux 2015.03 is now supported.




### Bug fixes

#### Data preparation

  * Fixed Python processors in recipes over filesystem datasets (happened when no custom variables and no contribs were used)




#### Datasets and formats

  * Fixed ORC files with Hive 0.14+

  * Fixed explore in the Twitter dataset

  * Improved detection of Shapefiles and fixed support for uppercase-named shapefiles

  * Fixes on SAS format parser




## Version 1.4.3 - March 4th, 2015

### Important notes about migration

Please see the release notes for 1.4.0

### Bug fixes

#### Recipes

  * An issue with running grouping recipe on non-SQL datasets has been fixed

  * Running SQL script recipes on PostgreSQL could fail depending on how the “psql” binary is implemented

  * Running SQL script recipes on PostgreSQL could loose the return code and all recipes always appeared to succeed whereas they did not

  * Reading datasets in R when the schema contains comments has been fixed




#### Datasets

  * Initial download of data in HTTP datasets has been fixed




#### Misc

  * The job screen now properly automatically refreshes

  * Fixed an issue with Websockets and very long log messages




## Version 1.4.2 - February 17th, 2015

### Important notes about migration

Please see the release notes for 1.4.0

### New features

  * A new processor has been added: “Generate combinations of numerical variables”

  * New dataset: “FTP (no cache)”, which allows both read and write on FTP and does not cache input data. (see [FTP](<../../connecting/ftp.html>))

  * DSS now supports proxies for outgoing connections (FTP, HTTP, S3, Twitter). See [Using reverse proxies](<../../installation/custom/reverse-proxy.html>))

  * Hadoop: Support for HDP 2.2 has been added




### Bug fixes

  * Python’s write_with_schema could fail on some configurations of SQL output datasets

  * Installation of plugins on Mac OS X without JDK has been fixed

  * An issue has been fixed when running Impala on a Kerberos-enabled Hadoop cluster

  * Exception reporting has been improved in the Machine Learning part

  * Several issues have been fixed in the UI for New Cassandra Dataset.

  * Support for `\r` as End-Of-Line marker has been added for CSV datasets




## Version 1.4.1 - January 29th, 2015

### Important notes about migration

Please see the release notes for 1.4.0

### New features

  * A new reshaping processor has been added: “fold the keys of an array”




### Bug fixes

#### Hadoop support

  * Fixed compatibility with MapR 4.0

  * Support for MapR 2.0 and 3.0 has been removed




#### Machine learning

  * Fix failures in prediction recipes with textual features




#### Python

  * SQL code executed in Python recipes is now be properly streamed, even for very large result sets




#### Flow

  * Various UI bugfixes and improvements on the grouping recipe

  * A bug has been fixed on the TimeRange dependency for MONTH-based partitioning

  * A leak of file handles has been fixed in the backend <-> job communication, which could lead to “too many open files” errors




#### Misc

  * Support for Firefox 35.0 has been improved - However, pan and zoom in Flow on Firefox 35.0 remains slow

  * Some documentation links have been fixed




## Version 1.4.0 - January 13th, 2015

### Important notes about migration

The automatic data migration procedure is documented in [Upgrading a DSS instance](<../../installation/custom/upgrade.html>)

As usual, we **strongly recommend** that you perform a full backup of your Data Science Studio data directory prior to starting the upgrade procedure.

Automatic migration of data from Data Science Studio 1.3.X is supported, with the following restrictions and warnings:

  * The “dip.flow.activities.nthreads” parameter in dip.properties has been removed. Setting the number of activities is now done in the Administration pages (Settings > Build).

  * Referencing a dip.properties entry from a FS dataset path is not possible anymore. Use the variables expansion system.




For migrations from Data Science Studio 1.2.X, please also see the release notes of version 1.3.0

### New features

#### Mac OS X

  * DSS is now available on Mac OS X (10.9 and above).




>   * Note that the OS X version is only available for experimentation and evaluation purpose, it is not supported for production usage
> 
>   * Download and install Mac OS X version from: <http://www.dataiku.com/dss/editions/community-download/>
> 
> 


#### Security

  * You can now connect DSS to your corporate LDAP directory and use your LDAP users and groups to control access to DSS. See [Configuring LDAP authentication](<../../security/authentication/ldap.html>).

  * DSS can now interact with Kerberos-enabled Hadoop clusters See [Connecting to secure clusters](<../../hadoop/secure-clusters.html>).




#### Visual data preparation

  * Transformation recipes created with the visual data preparation tool can now fully run on a Hadoop cluster. See [Execution engines](<../../preparation/engines.html>)

  * BETA feature: geo processing processors (see [Geographic processors](<../../preparation/geographic.html>))




>   * Reverse geocoding (from GPS coordinates to city / region / country)
> 
>   * Zipcode-based geocoding (from zipcode to GPS coordinates)
> 
> 


#### Data Visualization

  * You can now export charts built with DSS as Excel documents for easy embedding

  * Several color palettes are now available for charts. Furthermore, you can add custom color palettes

  * BETA feature: geo charts (see [Map Charts](<../../visualization/charts-maps.html>))




>   * Geo charts allow you to aggregate a dataset based on a column containing geo coordinates.
> 
>   * Aggregation is made by administrative boundaries (city / region / country)
> 
> 


#### New data transformation recipes

  * “Grouping” recipe: new visual tool to perform grouping and aggregations (sum, avg, first, last, …)




>   * Multi-key grouping and multi-aggregations
> 
>   * Integrated filtering
> 
>   * Automatically runs in-database or on-Hadoop when possible.
> 
> 


  * “Split” recipe: split one input dataset into several output datasets based on the value of a column or advanced rules




#### Datasets

  * Support for GeoJSON files

  * Support for ESRI Shapefiles




#### Collaboration

  * DSS now detects and warns when several users are working on the same dataset or recipe at the same time.

  * Edit conflicts are automatically detected and avoided




#### Advanced usage

  * New [Custom variables expansion](<../../variables/index.html>) system that allows you to use some shared and reusable variables in several parts of the Studio.

  * You can now write custom Python code for advanced partition dependencies in Flow. See [Specifying partition dependencies](<../../partitions/dependencies.html>)

  * The number of concurrent running activities (builds of a partition) can now be set:




>   * per-job
> 
>   * per-connection
> 
>   * globally
> 
> 


  * A command-line tool lets you mass-import all (or selected) tables of a Hive database as DSS datasets. See [Hive](<../../hadoop/hive.html>)




### Other enhancements

#### Flow

  * When aborting a job, DSS tries to cancel running SQL queries and running Hadoop jobs

  * Performance improvements for computing partition dependencies on large flows

  * Partitioning variables substitution in code recipes can now either use $DKU_XXX or ${DKU_XXX} syntax




#### Visual data preparation

  * The “column split” processor can now either ignore or keep empty chunks

  * The “regexp extractor” processor can now extract multiple matches

  * New processor to duplicate a column

  * New processors for advanced processing of complex content (JSON arrays and objects)

  * New processor to bin the values of a numerical column

  * “Live processing” charts can now work on a set of partitions




#### Web apps

  * You can now write a filtering formula to select a subset of rows in the JS webapp API

  * Better syntax highlighting in the JS editor

  * Code folding in all code editors




#### Data visualization

  * MIN and MAX are now available as aggregations in charts

  * Legend can now be hidden

  * Smoothing of lines and areas can now be disabled




#### Advanced usage

  * The Jython environment for custom processors now includes the “json” python package




#### Recipes

  * The R API now supports sampling of the input datasets




#### Security

  * The “Administrator” information is now handled by groups instead of being a simple flag on the user.




#### Deployment

  * Added support for RHEL 7 and CentOS 7




### Major bugfixes

#### Visual data preparation

  * Various issues around copy/paste in explore have been fixed

  * “Analyse” will not give invalid data when Infinity appears in the column

  * Parsing dates without any time information (only year/month/day) now properly respects the selected timezone

  * When editing a preparation recipe, the “Custom format” form of the “Smart date” feature has been fixed




#### Data visualization

  * Several issues around “week” and “week of year” handling for timeline axis have been fixed




#### SQL notebook

  * Performance with large tables has been improved

  * Error reporting has been improved




#### Datasets

  * Hidden / Useless files (like Hadoop success markers) are now properly ignored everywhere

  * Counting records now works on MongoDB datasets




#### Machine learning

  * Training recipes now properly work on paritiotned datasets

  * The “heatmap” in clustering results is now properly updated when switching between models




#### Collaboration

  * Cropping of transparent PNG for insights and projects icon now works properly




#### Misc

  * An issue when changing the network of the host while DSS is running has been fixed