# Dataiku Docs — troubleshooting

## [troubleshooting/diagnosing]

# Diagnosing and debugging issues

The first step in diagnosing issues with DSS is to identify what kinds of issue you are having:

  * A job fails

  * A scenario fails

  * A machine learning model fails

  * Other issues




## Initial investigation

  * In case of job failure, follow the steps in [A job fails](<problems/job-fails.html>).

  * In case of scenario failure, follow the steps in [A scenario fails](<problems/scenario-fails.html>).

  * In case of machine learning model training failure, follow the steps in [A ML model training fails](<problems/ml-train-fails.html>).




For other steps, if you see an error message in the DSS UI and cannot make sense of it, the first step is to study the log files of DSS.

Log files are stored in the `run` folder of the DSS data directory. For example, if you used `/opt/dataiku/data` as the data directory, the logs will be in `/opt/dataiku/data/run`

You will find there the following files:

  * `backend.log`: Log file for the main backend server

  * `ipython.log`: Log file of the Jupyter notebook server

  * `hproxy.log`: Log file for the Hadoop validation engine (validating Hive recipes)

  * `nginx.log`: Log file for the web server serving the public port of DSS

  * `governserver.log`: (Applicable only to Govern node) Log file of the main Govern server




For design, automation and deployer nodes, the main log file is `backend.log`. Look at this file for errors. You can also view the log files directly from DSS UI: go to Administration > Maintenance > Log files.

For govern nodes, the main log file is `governserver.log`. Look at this file for errors.

## Getting an instance diagnosis

When you encounter “global” issues in DSS (i.e., issues other than a job failure), and can’t find a reason in the error details or log files, Dataiku Support will ask you to provide a _DSS instance diagnosis_

The instance diagnosis is a Zip file that contains a lot of information about the current DSS instance, its log files, configuration information, system information, environment data, …

To generate a diagnosis:

  * Go to Administration > Maintenance > Diagnostic tool.

  * Click on “Run diagnostic tool”

  * Once the tool is done, download the file and send it to Dataiku Support




Note that Dataiku Support does not accept files larger than 15 MB. If your diagnosis Zip is bigger than that, you can use a file transfer service to get the diagnosis to us. We recommend using _WeTransfer_ , but any similar service (or internal service provided by your IT) can work.

### What does the instance diagnosis contain

  * Information about the machine running DSS

  * Log files of DSS

  * (Can be disabled) Configuration of DSS, which includes information about projects, datasets, recipes, connections, …

  * (Can be disabled) Listing of all files in the DSS data directory

  * (Can be disabled) Information about what actions DSS is currently processing

  * If applicable, information about your Hadoop and Spark setup




### What doesn’t the instance diagnosis contain

The instance diagnosis does not contain any of your datasets or managed folders data.

### How to check the content of the instance diagnosis ?

The instance diagnosis is a simple Zip file, which you can open to check the contents before sending to Dataiku.

---

## [troubleshooting/errors/ERR_ACTIVITY_DIRECTORY_SIZE_LIMIT_REACHED]

# ERR_ACTIVITY_DIRECTORY_SIZE_LIMIT_REACHED: Job activity directory size limit reached

The file system directory dedicated to a currently running job activity reached its size limit, so DSS automatically killed the job to avoid consuming too much disk space on the server.

This error can be triggered when running a Join or Group recipe using the internal DSS engine. While executing these recipes, the internal DSS engine will potentially have to spill a large amount of data to the disk, for example, when doing a cross join.

## Remediation

When executing a Join recipe, use the SQL or Spark engine if available. If all input datasets are on the same SQL connection, DSS will automatically select the SQL engine.

A DSS administrator can also change the limit for this error, by setting the value of `dku.recipes.visual.h2based.directorySize.maxMB` in `config/dip.properties` in the data directory. Specify the limit in megabytes, defaults to 20000 (i.e. 20 GB).

---

## [troubleshooting/errors/ERR_BUNDLE_ACTIVATE_BAD_CONNECTION_PERMISSIONS]

# ERR_BUNDLE_ACTIVATE_BAD_CONNECTION_PERMISSIONS: Connection is not freely usable

The project you are trying to import/activate has a dependency on connection(s) that either you are not able to use or have been remapped to connection(s) that you are not able to use.

## Remediation

Use the connection remapping option, and map the connection(s) to ones that you are able to use. The connection remapping is available for both project import (tick the `Display advanced options after upload`) and bundle activation (in the `Activation settings` tab of the bundles management screen).

---

## [troubleshooting/errors/ERR_BUNDLE_ACTIVATE_BAD_CONNECTION_TYPE]

# ERR_BUNDLE_ACTIVATE_BAD_CONNECTION_TYPE: Connection is the wrong type

The project you are trying to import/activate has a dependency on connection(s) that have been mapped to connection(s) of the wrong type on the target DSS instance. For example, this can happen when importing a project that uses a Snowflake connection named `connection1` on a DSS instance that has a MySQL connection named `connection1`.

## Remediation

Use the connection remapping option, and map the connection(s) to ones that have the same type. The connection remapping is available for both project import (tick the `Display advanced options after upload`) and bundle activation (in the `Activation settings` tab of the bundles management screen).

---

## [troubleshooting/errors/ERR_BUNDLE_ACTIVATE_CONNECTION_NOT_WRITABLE]

# ERR_BUNDLE_ACTIVATE_CONNECTION_NOT_WRITABLE: Connection is not writable

The project you are trying to import/duplicate contains dataset(s) located on read only connection(s).

## Remediation

Use the connection remapping option, and map the read only connection(s) to one you have write permission to. The connection remapping is available for both project import (tick the `Display advanced options after upload`) or project duplication (under the `Advanced options` menu).

---

## [troubleshooting/errors/ERR_BUNDLE_ACTIVATE_MISSING_CONNECTION]

# ERR_BUNDLE_ACTIVATE_MISSING_CONNECTION: Connection is missing

The project you are trying to import/activate has a dependency on connection(s) that either do not exist or have been remapped to connection(s) that do not exist on the DSS instance.

## Remediation

Use the connection remapping option, and map the missing connection(s) to ones that exist on the DSS instance. The connection remapping is available for both project import (tick the `Display advanced options after upload`) and bundle activation (in the `Activation settings` tab of the bundles management screen).

---

## [troubleshooting/errors/ERR_CLUSTERS_INVALID_SELECTED]

# ERR_CLUSTERS_INVALID_SELECTED: Selected cluster does not exist

The selected cluster does not exist.

## Remediation

Fix the cluster selection or remove it from your settings.

---

## [troubleshooting/errors/ERR_CODEENV_CONTAINER_IMAGE_FAILED]

# ERR_CODEENV_CONTAINER_IMAGE_FAILED: Could not build container image for this code environment

When creating or updating a code environment, DSS tried to build the corresponding container image(s) for containerized execution configuration(s) but one such build failed.

You can still use the code environment when running on the DSS backend, but won’t be able to use the code environment on containers.

## Remediation

You can find the logs of the `docker build` command either in the code environment creation/update window, or in the code environment logs. If you or your IT administrator cannot resolve the error from the logs, you can send those logs to Dataiku support.

---

## [troubleshooting/errors/ERR_CODEENV_CONTAINER_IMAGE_TAG_NOT_FOUND]

# ERR_CODEENV_CONTAINER_IMAGE_TAG_NOT_FOUND: Container image tag not found for this Code environment

The Docker image tag was not found for the container image corresponding to this code environment.

This message usually means that either the code environment was not made usable with the current container configuration, or that the image has not been rebuilt since updating this code environment or upgrading DSS.

## Remediation

Some one with administrative permission over this code environment can make sure that this code environment is usable with this container configuration and then update the code environment to trigger the build of the corresponding container image.

---

## [troubleshooting/errors/ERR_CODEENV_CREATION_FAILED]

# ERR_CODEENV_CREATION_FAILED: Could not create this code environment

The creation of a code environment failed.

## Remediation

You can find the logs of the creation either in the code environment creation window, or in the code environment logs. If you or your IT administrator cannot resolve the error from the logs, you can send those logs to Dataiku support.

---

## [troubleshooting/errors/ERR_CODEENV_DELETION_FAILED]

# ERR_CODEENV_DELETION_FAILED: Could not delete this code environment

The deletion of a code environment failed.

## Remediation

You can find the logs of the deletion either in the code environment deletion window, or in the code environment logs. If you or your IT administrator cannot resolve the error from the logs, you can send those logs to Dataiku support.

---

## [troubleshooting/errors/ERR_CODEENV_EXISTING_ENV]

# ERR_CODEENV_EXISTING_ENV: Code environment already exists

A code environment for that language and with that name already exists.

## Remediation

This issue can only be fixed by a DSS administrator.

Check the settings of the existing code environments.

---

## [troubleshooting/errors/ERR_CODEENV_INCORRECT_ENV_TYPE]

# ERR_CODEENV_INCORRECT_ENV_TYPE: Wrong type of Code environment

You are trying to use a code environment that is not compatible with this node type (e.g. a Design node Managed code environment on an Automation node).

## Remediation

Check the source of this code environment, or of the package/bundle it comes from.

---

## [troubleshooting/errors/ERR_CODEENV_INVALID_CODE_ENV_ARCHIVE]

# ERR_CODEENV_INVALID_CODE_ENV_ARCHIVE: Invalid code environment archive

The archive you specified does not contain a valid code environment. This can happen when it contains a code environment for another language.

## Remediation

Check the source of this archive.

---

## [troubleshooting/errors/ERR_CODEENV_JUPYTER_SUPPORT_INSTALL_FAILED]

# ERR_CODEENV_JUPYTER_SUPPORT_INSTALL_FAILED: Could not install Jupyter support in this code environment

The installation of Jupyter support in the code environment failed.

You may still be able to use the code environment in code recipes or for Visual ML, but you won’t be able to use it in Jupyter notebooks.

## Remediation

You can find the logs of the installation either in the code environment creation/update window, or in the code environment logs. If you or your IT administrator cannot resolve the error from the logs, you can send those logs to Dataiku support.

---

## [troubleshooting/errors/ERR_CODEENV_JUPYTER_SUPPORT_REMOVAL_FAILED]

# ERR_CODEENV_JUPYTER_SUPPORT_REMOVAL_FAILED: Could not remove Jupyter support from this code environment

The removal of Jupyter support from the code environment failed.

## Remediation

You can find the logs of the removal either in the code environment creation/update window, or in the code environment logs. If you or your IT administrator cannot resolve the error from the logs, you can send those logs to Dataiku support.

---

## [troubleshooting/errors/ERR_CODEENV_MISSING_DEEPHUB_ENV]

# ERR_CODEENV_MISSING_DEEPHUB_ENV: Code environment for deep learning does not exist

The current operation needs an code environment for deep learning with pretrained models that does not exist.

## Remediation

Install the relevant code environment for your use case in _Administration > Code envs > Internal envs setup_.

---

## [troubleshooting/errors/ERR_CODEENV_MISSING_ENV]

# ERR_CODEENV_MISSING_ENV: Code environment does not exists

The current operation needs a code environment that does not exist under that name and for that language.

## Remediation

Double-check the name of the required code environment. Check the settings of the existing code environments. If necessary, check the git history to see if a code environment for that name and language was recently deleted.

---

## [troubleshooting/errors/ERR_CODEENV_MISSING_ENV_VERSION]

# ERR_CODEENV_MISSING_ENV_VERSION: Code environment version does not exists

The current operation needs a specific version of a code environment that was not found under that name and for that language.

## Remediation

Double-check the name and version of the required code environment. Check the settings of the existing code environments. If necessary, check the git history to see if a code environment for that name, language and version was recently deleted.

---

## [troubleshooting/errors/ERR_CODEENV_NOT_USING_LATEST_DEEPHUB_ENV]

# ERR_CODEENV_NOT_USING_LATEST_DEEPHUB_ENV: Not using latest version of code environment for deep learning

The latest version of the code environment for deep learning was not found.

## Remediation

Double-check the name of the used code environment. Check the settings of the existing code environments. Check that the latest code environment version is installed.

---

## [troubleshooting/errors/ERR_CODEENV_NO_CREATION_PERMISSION]

# ERR_CODEENV_NO_CREATION_PERMISSION: User not allowed to create Code environments

The current user does not have permissions to create code environments.

## Remediation

This issue can only be fixed by a DSS administrator.

The administrator needs to give permission to that user to create code environments. This is done at the group level, so that user needs to be put in a group that has that permission set. See also [Main project permissions](<../../security/permissions.html>).

---

## [troubleshooting/errors/ERR_CODEENV_NO_USAGE_PERMISSION]

# ERR_CODEENV_NO_USAGE_PERMISSION: User not allowed to use this Code environment

The current user does not have permissions to use this code environment.

## Remediation

Some one with administrative permission over this code environment can set, in that environment’s settings, which user groups can use this code environment. They can also give that permission to everyone.

---

## [troubleshooting/errors/ERR_CODEENV_UNSUPPORTED_OPERATION_FOR_ENV_TYPE]

# ERR_CODEENV_UNSUPPORTED_OPERATION_FOR_ENV_TYPE: Operation not supported for this type of Code environment

You are trying to use a code environment in a way that is not compatible with its type (e.g. exporting a code environment on an Automation node, or update from DSS an external or unmanaged code environment).

## Remediation

Check the source of this code environment, or of the package/bundle it comes from.

---

## [troubleshooting/errors/ERR_CODEENV_UPDATE_FAILED]

# ERR_CODEENV_UPDATE_FAILED: Could not update this code environment

The update of a code environment failed.

## Remediation

You can find the logs of the update either in the code environment update window, or in the code environment logs. If you or your IT administrator cannot resolve the error from the logs, you can send those logs to Dataiku support.

---

## [troubleshooting/errors/ERR_CONNECTION_ALATION_REGISTRATION_FAILED]

# ERR_CONNECTION_ALATION_REGISTRATION_FAILED: Failed to register Alation integration

An error occurred while establishing a connection with Alation

## Remediation

Check the validity of an Alation URL and API token

---

## [troubleshooting/errors/ERR_CONNECTION_API_BAD_CONFIG]

# ERR_CONNECTION_API_BAD_CONFIG: Bad configuration for connection

You made an API call about a connection with an incorrect configuration for this connection.

## Remediation

Review the API call, especially the configuration of the connection you specified. Try making this connection manually using the DSS UI, then performing a GET request on that connection to check the expected format of the connection parameters.

---

## [troubleshooting/errors/ERR_CONNECTION_AZURE_INVALID_CONFIG]

# ERR_CONNECTION_AZURE_INVALID_CONFIG: Invalid Azure connection configuration

DSS tried to connect to Azure but the configuration seems invalid.

## Remediation

This issue can only be fixed by a DSS administrator.

The first step for solving this issue is to go to the settings screen for the affected connection (Administration > Connections). You can test the connection from there.

  * Refer to the [documentation on Azure Blob Storage](<../../connecting/azure-blob.html>) in order to get additional information

  * Make sure that the connection settings are correct

---

## [troubleshooting/errors/ERR_CONNECTION_DUMP_FAILED]

# ERR_CONNECTION_DUMP_FAILED: Failed to dump connection tables

An error occurred while dumping tables metadata

## Remediation

Inspect the error cause and rerun full connection indexing

---

## [troubleshooting/errors/ERR_CONNECTION_INVALID_CONFIG]

# ERR_CONNECTION_INVALID_CONFIG: Invalid connection configuration

Connection configuration does not include some of the mandatory fields

## Remediation

Check connection configuration fill required fields.

---

## [troubleshooting/errors/ERR_CONNECTION_LIST_HIVE_FAILED]

# ERR_CONNECTION_LIST_HIVE_FAILED: Failed to list indexable Hive connections

An error occurred while listing Hive databases

## Remediation

Check Hive settings in DSS, also verify that Hive server is running

---

## [troubleshooting/errors/ERR_CONNECTION_S3_INVALID_CONFIG]

# ERR_CONNECTION_S3_INVALID_CONFIG: Invalid S3 connection configuration

DSS tried to connect to S3 but the configuration seems invalid.

## Remediation

This issue can only be fixed by a DSS administrator.

The first step for solving this issue is to go to the settings screen for the affected connection (Administration > Connections). You can test the connection from there.

  * Refer to the [documentation on S3](<../../connecting/s3.html>) in order to get additional information

  * Make sure that the connection settings are correct

---

## [troubleshooting/errors/ERR_CONNECTION_SQL_INVALID_CONFIG]

# ERR_CONNECTION_SQL_INVALID_CONFIG: Invalid SQL connection configuration

DSS tried to connect to a SQL database but the configuration seems invalid.

## Remediation

This issue can only be fixed by a DSS administrator

The first step for solving this issue is to go to the settings screen for the affected connection (Administration > Connections). You can test the connection from there.

  * Refer to the [documentation on SQL databases](<../../connecting/sql/index.html>) in order to get additional information on the support of your specific database by DSS.

  * Make sure that the connection settings are correct

---

## [troubleshooting/errors/ERR_CONNECTION_SQS_INVALID_CONFIG]

# ERR_CONNECTION_SQS_INVALID_CONFIG: Invalid SQS connection configuration

DSS tried to connect to SQS but the configuration seems invalid.

## Remediation

This issue can only be fixed by a DSS administrator.

The first step for solving this issue is to go to the settings screen for the affected connection (Administration > Connections). You can test the connection from there.

  * Refer to the [documentation on SQS](<../../streaming/sqs.html>) in order to get additional information

  * Make sure that the connection settings are correct

---

## [troubleshooting/errors/ERR_CONNECTION_SSH_INVALID_CONFIG]

# ERR_CONNECTION_SSH_INVALID_CONFIG: Invalid SSH connection configuration

DSS tried to connect to the SSH server but the configuration seems invalid.

## Remediation

This issue can only be fixed by a DSS administrator.

The first step for solving this issue is to go to the settings screen for the affected connection (Administration > Connections). You can test the connection from there.

  * Refer to the [documentation on SCP / SFTP (aka SSH)](<../../connecting/scp-sftp.html>) in order to get additional information

  * Make sure that the connection settings are correct

---

## [troubleshooting/errors/ERR_CONTAINER_CONF_NOT_FOUND]

# ERR_CONTAINER_CONF_NOT_FOUND: The selected container configuration was not found

The recipe or visual ML task was configured on a containerized execution configuration that does not exist anymore. It may also be the case that it is configured to inherit the containerized execution configuration from the project, and that the project settings refer this non-existing configuration.

## Remediation

Either re-create (or ask your DSS administrator to recreate) a containerized execution configuration with the same name, or select another containerized execution configuration. If the configuration is selected at the project level, you may need the DSS administrator or the project owner to do this.

---

## [troubleshooting/errors/ERR_CONTAINER_CONF_NO_USAGE_PERMISSION]

# ERR_CONTAINER_CONF_NO_USAGE_PERMISSION: User not allowed to use this containerized execution configuration

The current user does not have permissions to use this containerized execution configuration.

## Remediation

The DSS administrator can set, in that containerized execution configuration’s settings, which user groups can use it. They can also give that permission to everyone.

---

## [troubleshooting/errors/ERR_CONTAINER_IMAGE_PUSH_FAILED]

# ERR_CONTAINER_IMAGE_PUSH_FAILED: Container image push failed

When creating or updating a code environment, DSS tried to push the corresponding container image(s) for containerized execution configuration(s) but one such push failed.

Most frequent causes are:

  * The repository URL is incorrect

  * The authentication mechanisms have not been properly setup (the `docker push` command must be already be fully functional for this repository)

  * TLS security is required but has not been properly setup on that containerized execution configuration

  * When using Amazon AWS EKS / ECR, the pre-push script is incorrect or not working




You can still use the code environment when running on the DSS backend and on containerized execution configurations that do not need to pull the image from the registry (typically local Docker), but won’t be able to use the code environment on containerized execution configurations that need to pull this image.

## Remediation

You can find the logs of the `docker push` command either in the code environment creation/update window, or in the code environment logs. Also try (or ask your IT administrator to try) manually pushing a dummy image to the same repository directly from the command line. If you or your IT administrator cannot resolve the error from the logs, you can send those logs to Dataiku support.

---

## [troubleshooting/errors/ERR_DASHBOARD_EXPORT_SAND_BOXING_ERROR]

# ERR_DASHBOARD_EXPORT_SAND_BOXING_ERROR: Chrome cannot start in the “sandbox” mode

The embedded Chrome browser used for PDF generation could not start in the secure “sandbox” mode

## Remediation

This issue can only be fixed by a DSS administrator.

The administrator either needs to enable user namespaces or disable sandbox. Check on how to apply these options in the bottom of the [installation article](<../../installation/custom/graphics-export.html>).

---

## [troubleshooting/errors/ERR_DATASET_ACTION_NOT_SUPPORTED]

# ERR_DATASET_ACTION_NOT_SUPPORTED: Action not supported for this kind of dataset

You are trying to perform an action that is not possible or not supported on this kind of dataset. For example, you cannot write on a SQL Query dataset.

---

## [troubleshooting/errors/ERR_DATASET_CSV_ROW_TOO_LARGE]

# ERR_DATASET_CSV_ROW_TOO_LARGE: Error in CSV file: Dataset row is too long to be processed

Considering the dataset’s CSV format configuration, a row cannot exceed a certain length.

## Remediation

This error appears when the dataset contains a row that is unexpectedly long.

Make sure the quoting style, as well as the quote and escape characters, are well chosen. It’s very likely that the error comes from there. You’ll find those settings in the dataset tab “Settings > Format/Preview”. For more details about CSV quoting styles, please see [Delimiter-separated values (CSV / TSV)](<../../connecting/formats/csv.html>).

If the long row is not due to the format configuration but inherent to the dataset, you can increase the limit `Maximum characters per row` in the same tab. You can set them to 0 if you simply do not want any limit. Beware that you may encounter out of memory errors.

---

## [troubleshooting/errors/ERR_DATASET_CSV_UNTERMINATED_QUOTE]

# ERR_DATASET_CSV_UNTERMINATED_QUOTE: Error in CSV file: Unterminated quote

While parsing a CSV file, DSS encountered the start of a quoted field, but not the end. This prevents DSS from successfully parsing the CSV file.

While this can sometimes indicate a broken CSV file, in the vast majority of cases, this issue is caused by a wrong _CSV Quoting style_. For more details about CSV quoting styles, please see [Delimiter-separated values (CSV / TSV)](<../../connecting/formats/csv.html>).

Generally speaking, it means you have used “Excel” quoting style (the default) but your file is actually Unix or Escaping-only

## Remediation

  * Go to the dataset settings

  * Go to the “Format/Preview” tab

  * In the “Style” section, select “Unix”

  * Save the settings and try again

  * If you still encounter an issue, try again with “Escaping only”

---

## [troubleshooting/errors/ERR_DATASET_HIVE_INCOMPATIBLE_SCHEMA]

# ERR_DATASET_HIVE_INCOMPATIBLE_SCHEMA: Dataset schema not compatible with Hive

This error can occur when trying to synchronize an HDFS dataset to the Hive metastore. Hive does not support all schemas, and has some limitations on column names, notably:

  * It does not preserve case, so some columns names can conflict

  * It does not support some characters, like `,`




## Remediation

Try changing the schema of the dataset in the upstream recipe, so that it is compatible with Hive. When using Hadoop, a cautious practice can be to only use lowercase and no `,` nor `.`.

---

## [troubleshooting/errors/ERR_DATASET_INVALID_CONFIG]

# ERR_DATASET_INVALID_CONFIG: Invalid dataset configuration

The configuration of the current dataset seems invalid.

## Remediation

The first step for solving this issue is to go to the settings screen for the affected dataset. For most datasets types, you can test the settings from there.

  * Refer to the [documentation on Connecting to data](<../../connecting/index.html>) in order to get additional information for your dataset type

  * Make sure that the dataset’s settings are correct

---

## [troubleshooting/errors/ERR_DATASET_INVALID_FORMAT_CONFIG]

# ERR_DATASET_INVALID_FORMAT_CONFIG: Invalid format configuration for this dataset

The format configuration of the current dataset seems invalid.

## Remediation

The first step for solving this issue is to go to the settings screen for the affected dataset. For most datasets types, you can test the settings from there, and tweak the format settings.

  * Refer to the [documentation on Connecting to data](<../../connecting/index.html>) in order to get additional information for your dataset type

  * Make sure that the dataset’s format settings are correct

---

## [troubleshooting/errors/ERR_DATASET_INVALID_METRIC_IDENTIFIER]

# ERR_DATASET_INVALID_METRIC_IDENTIFIER: Invalid metric identifier

The metric identifier is incorrect for the current probe type.

## Remediation

  * If this happens when performing an API call or in custom code, double-check the metric identifier against the probe type.

  * If this happens when using a plugin, contact the plugin developer.

  * If this happens in the DSS GUI on non-custom code, contact Dataiku Support.

---

## [troubleshooting/errors/ERR_DATASET_INVALID_PARTITIONING_CONFIG]

# ERR_DATASET_INVALID_PARTITIONING_CONFIG: Invalid dataset partitioning configuration

The partitioning configuration of the current dataset seems invalid.

## Remediation

The first step for solving this issue is to go to the settings screen for the affected dataset, in the partitioning section. For most datasets types, you can test the settings from there.

  * Refer to the [documentation on Connecting to data](<../../connecting/index.html>) in order to get additional information for your dataset type

  * Make sure that the dataset’s partitioning settings are correct

---

## [troubleshooting/errors/ERR_DATASET_PARTITION_EMPTY]

# ERR_DATASET_PARTITION_EMPTY: Input partition is empty

An input partition (or unpartitioned dataset) is empty. This partition or dataset may not have been built yet. The error message should contain the particular dataset and partition ID.

This error can happen:

  * When exploring a dataset

  * When running a recipe

  * When otherwise using a dataset




Some common reasons for a partition to be empty are:

  * The partition or dataset was never built

  * The partition or dataset was cleared

  * A third-party system or person erased the partition or dataset

  * The dataset’s settings are incorrect (wrong path, wrong table name…)




## Remediation

  * Try rebuilding the partition or dataset

  * If the dataset is external, check the dataset’s settings and check the source of that dataset, exploring that dataset from outside DSS.

  * Make sure that the dataset’s partitioning settings are correct

---

## [troubleshooting/errors/ERR_DATASET_TRUNCATED_COMPRESSED_DATA]

# ERR_DATASET_TRUNCATED_COMPRESSED_DATA: Error in compressed file: Unexpected end of file

The compressed file ends unexpectedly. This error is typically caused by a problem in your data (i.e. data is invalid). If this data was created by DSS, you may need to rebuild it. This error can also be ignored, allowing you to process the available data.

## Remediation

  * In the dataset, select “Settings” and “Format / Preview” tab

  * In the “File read failure behaviour”, choose “Emit a warning and continue with the next file (if any)”

  * Rerun the recipe

---

## [troubleshooting/errors/ERR_ENDPOINT_INVALID_CONFIG]

# ERR_ENDPOINT_INVALID_CONFIG: Invalid configuration for API Endpoint

The configuration of the current API endpoint seems invalid.

## Remediation

The first step for solving this issue is to go to the settings screen for the affected endpoint. You can run test queries from there do validate the endpoint’s configuration.

  * Refer to the [documentation on the API Node Endpoints](<../../apinode/concepts.html>) in order to get additional information for your endpoint type

  * Make sure that the endpoints settings are correct

  * Make sure that the verion of the Design/Automation node producing the package and the API node receiving it is the same

---

## [troubleshooting/errors/ERR_EXPORT_OUTPUT_TOO_LARGE]

# ERR_EXPORT_OUTPUT_TOO_LARGE: Export file size limit reached

The export reached its max allowed size, so DSS automatically stopped the export to avoid consuming too much disk space on the server.

This error can be triggered when the export process requires a temporary file. Project duplication is also impacted.

## Remediation

A DSS administrator can increase the max allowed size by modifying a configuration key in `config/dip.properties` in the data directory:

  * For dataset exports: `dku.exports.file.maxSizeMB`

  * For bundle exports: `dku.exports.projectBundle.maxSizeMB`

  * For project exports or duplication: `dku.exports.project.maxSizeMB`

  * For API service packages: `dku.apiService.package.maxSizeMB`




Specify the limit in megabytes.

---

## [troubleshooting/errors/ERR_FOLDER_INVALID_CONFIG]

# ERR_FOLDER_INVALID_CONFIG: Invalid managed folder configuration

The configuration of the current managed folder seems invalid.

## Remediation

The first step for solving this issue is to go to the settings screen for the affected managed folder.

  * Refer to the [documentation on Managed folders](<../../connecting/managed_folders.html>) in order to get additional information on managed folders

  * Make sure that the folder’s settings are correct

---

## [troubleshooting/errors/ERR_FOLDER_INVALID_PARTITIONING_CONFIG]

# ERR_FOLDER_INVALID_PARTITIONING_CONFIG: Invalid folder partitioning configuration

The partitioning configuration of the current managed folder seems invalid.

## Remediation

The first step for solving this issue is to go to the settings screen for the affected managed folder, in the partitioning section.

  * Refer to the [documentation on Managed folders](<../../connecting/managed_folders.html>) in order to get additional information on managed folders

  * Make sure that the folder’s partitioning settings are correct

---

## [troubleshooting/errors/ERR_FORMAT_BOUNDING_BOXES]

# ERR_FORMAT_BOUNDING_BOXES: Invalid format of column representing bounding boxes

The column selected to represent Object Detection bounding boxes has the wrong format.

## Remediation

Make sure your column follow the [format](<../../machine-learning/computer-vision/inputs.html#deephub-inputs-format-object-detection>) supported by DSS

---

## [troubleshooting/errors/ERR_FORMAT_LINE_TOO_LARGE]

# ERR_FORMAT_LINE_TOO_LARGE: Line is too long to be processed

Considering the current format configuration, a line cannot exceed a certain length.

## Remediation

This error often appears on the dataset formats `One record per line` or `Separated Values (CSV, TSV, ...)` when the dataset contains a line that is unexpectedly long.

You can increase the limit `Maximum characters per line` or `Maximum characters per row` in the dataset tab settings, which can be found under “Settings > Format/Preview”. You can set them to 0 if you simply do not want any limit. Beware that you may encounter out of memory errors.

---

## [troubleshooting/errors/ERR_FORMAT_TYPE_MISSING]

# ERR_FORMAT_TYPE_MISSING: Dataset is missing a format type

The file-system dataset is missing a format type, so it cannot be parsed correctly.

## Remediation

  * In the dataset, select “Settings” and the “Format / Preview” tab

  * In the “Type” dropdown, select the correct file format, and save the settings

---

## [troubleshooting/errors/ERR_FSPROVIDER_CANNOT_CREATE_FOLDER_ON_DIRECTORY_UNAWARE_FS]

# ERR_FSPROVIDER_CANNOT_CREATE_FOLDER_ON_DIRECTORY_UNAWARE_FS: Cannot create a folder on this type of file system

You are trying to create an empty folder on a system that does not support it.

For example, S3 is not an actual file system. It identifies objects with keys, which may or may not look like a path on a file system. You can have a single object with key `a/b/c.txt`, which will be presented by many tools, DSS included, as a folder `a`, containing a folder `b`, containing a file `c.txt`. But them, you cannot have an empty folder `e/f/`, you need an actual file `e/f/g.txt` that will get presented as a folder `e/f`.

---

## [troubleshooting/errors/ERR_FSPROVIDER_DEST_PATH_ALREADY_EXISTS]

# ERR_FSPROVIDER_DEST_PATH_ALREADY_EXISTS: Destination path already exists

You are trying to move, copy or put files on a path that already exists. For example, you are renaming a file or folder, but that name is already taken.

## Remediation

Either remove the existing path (if you want to override its content) or choose another name.

---

## [troubleshooting/errors/ERR_FSPROVIDER_FSLIKE_REACH_OUT_OF_ROOT]

# ERR_FSPROVIDER_FSLIKE_REACH_OUT_OF_ROOT: Illegal attempt to access data out of connection root path

The configuration of a dataset or managed folder illegally tries to reach outside of its assigned root path, by using `..` in its path.

## Remediation

Check the settings of the dataset or managed folder.

In some cases, the configuration issue can be at the connection level, in which case it must be fixed by your administrator.

---

## [troubleshooting/errors/ERR_FSPROVIDER_HTTP_CONNECTION_FAILED]

# ERR_FSPROVIDER_HTTP_CONNECTION_FAILED: HTTP connection failed

DSS tried to connect to a HTTP server but couldn’t establish the connection.

This error can happen:

  * when trying to preview or use HTTP datasets

  * when trying to run a download recipe with HTTP sources




This error indicates that the connection could not be established. The message of the error will contain additional information.

Some common reasons for failure to establish the connection are:

  * The connection settings (host, port, …) to the server are invalid

  * The HTTP server is not running or not accepting connections

  * There is a firewall blocking connection attempts from DSS to the HTTP server

  * The URL is incorrectly labeled as HTTPS instead of HTTP or vice-versa




## Remediation

The first step for solving this issue is to go to the dataset’s or download recipe settings screen.

  * Refer to the [documentation on HTTP dataset](<../../connecting/http.html>) and [documentation on DSS and Hive](<../../other_recipes/download.html>) in order to get additional information on HTTP sources in DSS.

  * Make sure that the URLs are correct

  * Try accessing these URLs in the browser

  * Try accessing these URLs using the `curl` command line from the DSS server

  * Check if a firewall is blocking connections between DSS and the HTTP server(s)

---

## [troubleshooting/errors/ERR_FSPROVIDER_HTTP_INVALID_URI]

# ERR_FSPROVIDER_HTTP_INVALID_URI: Invalid HTTP URI

The provided URL is incorrect.

Please note that:

  * The [HTTP Dataset](<../../connecting/http.html>) only supports `http://` and `https://` URLs

  * The [Download Recipe](<../../other_recipes/download.html>) only supports `http://`, `https://` and `ftp://` URLs, other protocols must have a corresponding Connection




## Remediation

Fix the faulty URL.

---

## [troubleshooting/errors/ERR_FSPROVIDER_HTTP_REQUEST_FAILED]

# ERR_FSPROVIDER_HTTP_REQUEST_FAILED: HTTP request failed

DSS tried to perform an HTTP request which failed.

This error can happen:

  * when trying to preview or use HTTP datasets

  * when trying to run a download recipe with HTTP sources




This error indicates that a connection could be established, but that there was a subsequent issue with the HTTP request. The message of the error will contain additional information.

Some common reasons for a HTTP request failure are:

  * The URL is incorrect

  * There was an error on the HTTP server’s side

  * There is a proxy preventing DSS from fetching that URL

  * The URL is incorrectly labeled as HTTPS instead of HTTP or vice-versa




## Remediation

The first step for solving this issue is to go to the dataset’s or download recipe settings screen.

  * Refer to the [documentation on HTTP dataset](<../../connecting/http.html>) and [documentation on DSS and Hive](<../../other_recipes/download.html>) in order to get additional information on HTTP sources in DSS.

  * Make sure that the URLs are correct

  * Try accessing these URLs in the browser

  * Try accessing these URLs using the `curl` command line from the DSS server

  * Check if a proxy is between DSS and the HTTP server(s), ask your DSS Administrator to review DSS’s proxy settings (in Administration > Settings > Misc).   
On the HTTP dataset’s (or Dowload recipe’s) settings, you can specify whether its URLs should be fetched through DSS’s globally-configured proxy (for external networks / Internet) or not (for internal network).

---

## [troubleshooting/errors/ERR_FSPROVIDER_ILLEGAL_PATH]

# ERR_FSPROVIDER_ILLEGAL_PATH: Illegal path for that file system

The specified path is not supported on that file system.

For example, `.` and `..` are not usable on an S3 file system. S3 is not an actual file system. It identifies objects with keys, which may or may not look like a path on a file system. You can have a single object with key `a/b/c.txt`, which will be presented by many tools, DSS included, as a folder `a`, containing a folder `b`, containing a file `c.txt`. Having a `.` or `..` in a key will not work as on a Unix- or Windows-style file system and is therefore not supported.

## Remediation

Fix the faulty path. If that path was set at the connection level, you will need DSS administrator access to fix it.

---

## [troubleshooting/errors/ERR_FSPROVIDER_INVALID_CONFIG]

# ERR_FSPROVIDER_INVALID_CONFIG: Invalid configuration

The configuration of a “Filesystem provider” is invalid.

Filesystem providers are used as the basis of:
    

  * All “files-based” datasets (Filesystem, HDFS, S3, GCS, Azure, FTP, SFTP, SCP, HTTP)

  * Managed folders




This error can happen:

>   * When viewing or a using one of the above kinds of datasets
> 
>   * When running a job which involves one of the above kinds of datasets
> 
> 


## Remediation

Check the settings of the dataset or managed folder. The error message details what part of the configuration is invalid.

In some cases, the configuration issue can be at the connection level, in which case it must be fixed by your administrator.

---

## [troubleshooting/errors/ERR_FSPROVIDER_INVALID_FILE_NAME]

# ERR_FSPROVIDER_INVALID_FILE_NAME: Invalid file name

The specified file name is invalid file system.

For example, `.`, `..` or filenames containing `/` will cause trouble on a lot of file systems and are therefore not supported.

## Remediation

Rename the offending file.

---

## [troubleshooting/errors/ERR_FSPROVIDER_LOCAL_LIST_FAILED]

# ERR_FSPROVIDER_LOCAL_LIST_FAILED: Could not list local directory

The listing of a directory failed on the local file system.

## Remediation

You will need a DSS and/or system administrator to check the permissions on the connection, dataset or managed folder.

---

## [troubleshooting/errors/ERR_FSPROVIDER_PATH_DOES_NOT_EXIST]

# ERR_FSPROVIDER_PATH_DOES_NOT_EXIST: Path in dataset or folder does not exist

The specified path in the dataset or folder does not exist. This can happen if a partition is required but does not exist.

## Remediation

Check the settings of the dataset or managed folder. The error message details what path was not found.

In some cases, the configuration issue can be at the connection level, in which case it must be fixed by your DSS administrator.

---

## [troubleshooting/errors/ERR_FSPROVIDER_ROOT_PATH_DOES_NOT_EXIST]

# ERR_FSPROVIDER_ROOT_PATH_DOES_NOT_EXIST: Root path of the dataset or folder does not exist

The root path of the dataset or folder does not exist. DSS is trying to access data that is not there.

## Remediation

Check the settings of the dataset or managed folder. The error message details what path was not found in the connection. You may need the assistance of someone with write access to that storage to create the folder for you.

In some cases, the configuration issue can be at the connection level, in which case it must be fixed by your DSS administrator.

---

## [troubleshooting/errors/ERR_FSPROVIDER_SSH_CONNECTION_FAILED]

# ERR_FSPROVIDER_SSH_CONNECTION_FAILED: Failed to establish SSH connection

DSS tried to connect to a SSH server but couldn’t establish the connection.

This error can happen:

  * when trying to create a new connection to a SSH source

  * when trying to read or write a SCP or SFTP dataset




This error indicates that the connection could not be established. The message of the error will contain additional information.

Some common reasons for failure to establish the connection are:

  * The connection settings (host, port, …) to the server are invalid

  * The SSH server is not running or not accepting connections

  * There is a firewall blocking connection attempts from DSS to the SSH server

  * Credentials entered in DSS for the SSH server are invalid




## Remediation

Note

This issue can only be fixed by a DSS administrator

The first step for solving this issue is to go to the settings screen for the affected connection (Administration > Connections). You can test the connection from here.

  * Refer to the [documentation on SCP/SFTP sources](<../../connecting/scp-sftp.html>) in order to get additional information on SSH support by DSS.

  * Make sure that the connection settings are correct

  * If you get “connection refused” or similar errors, check that the SSH server is properly running

  * Check if a firewall is blocking connections between DSS and the SSH server (this can result in either “connection refused” issues, or timeout issues)

---

## [troubleshooting/errors/ERR_FSPROVIDER_TOO_MANY_FILES]

# ERR_FSPROVIDER_TOO_MANY_FILES: Attempted to enumerate too many files

While attempting to enumerate a large number of files in a file system-like connection, DSS reached a safety limit and automatically aborted the operation in order to not disrupt the DSS backend.

Some of the actions that can trigger this error include:

  * trying to read from a dataset that is made up of a very large number of files

  * clicking on the “List files” button before setting the root path of a dataset (listing all the files in a connection)

  * trying to browse a folder that contains a very large number of files




## Remediation

  * Prefer creating a connection with a path restriction, rather than a connection pointing to the root of a bucket. You can use the “Path from” field under the “Path restrictions” section of the connection settings

  * Avoid clicking on the “List files” button when pointing to a location that contains a large number of files, or before you have set a root path location for the dataset

---

## [troubleshooting/errors/ERR_H2_DB_TOO_BIG_TO_BE_CLEANED]

# ERR_H2_DB_TOO_BIG_TO_BE_CLEANED: Very large database

Your instance of Dataiku DSS uses H2 for its runtime databases. When the H2 database files become too large, cleaning the internal database using the Clear internal databases macro can lead Dataiku DSS to become unresponsive for several hours or days.

## Remediation

See [these instructions](<../../operations/runtime-databases.html#runtime-db-external>) to learn how to migrate to PostgreSQL database or contact support. If you accept the consequences of cleaning a very large H2 internal database, you can use the Bypass database size checks parameter of the Clear internal databases macro.

---

## [troubleshooting/errors/ERR_HIVE_HS2_CONNECTION_FAILED]

# ERR_HIVE_HS2_CONNECTION_FAILED: Failed to establish HiveServer2 connection

DSS tried to connect to HiveServer2 but couldn’t establish the connection.

This error can happen:

  * when trying to synchronize the metastore on an HDFS dataset

  * when trying to run Hive recipes, or recipes on Hive engine

  * when trying to run queries on a Hive SQL notebook

  * when trying to import table definitions from the Hive Metastore




This error indicates that the connection could not be established. The message of the error will contain additional information.

Some common reasons for failure to establish the connection are:

  * The connection settings (host, port, …) to the server are invalid

  * The HiveServer2 server is not running or not accepting connections

  * There is a firewall blocking connection attempts from DSS to HiveServer2




## Remediation

Note

This issue can only be fixed by a DSS administrator or a cluster administrator

The first step for solving this issue is to go to the Hive settings screen (Administration > Settings > Hive)

  * Refer to the [documentation on DSS and Hive](<../../hadoop/hive.html>) in order to get additional information on Hive support by DSS.

  * Refer to the [documentation on SCP/SFTP sources](<../../hadoop/installation.html>) in order to get additional information on Hive support by DSS.

  * Make sure that the connection settings are correct

  * If you get “connection refused” or similar errors, check that the Hiveserver2 server is properly running and that the Hive settings in DSS allow for authentication over JDBC.

  * Check if a firewall is blocking connections between DSS and the Hiverserver2 server (this can result in either “connection refused” issues, or timeout issues)

---

## [troubleshooting/errors/ERR_HIVE_LEGACY_UNION_SUPPORT]

# ERR_HIVE_LEGACY_UNION_SUPPORT: Your current Hive version doesn’t support UNION clause but only supports UNION ALL, which does not remove duplicates

The Hive query cannot be executed because it incudes a UNION clause that is not supported by this version of Hive

## Remediation

If you’re running a stack recipe with Distinct rows post-filter there are following possibilities:

  * Use stack recipe without distinct postfilter + create a distinct recipe for a result of a stack recipe

  * Apply distinct recipe on each of the stacked datasets and then stack them

  * Create a Hive recipe with a query that uses UNION ALL and then wrap the whole query with SELECT DISTINCT {your column names} from {select with UNION ALL}

---

## [troubleshooting/errors/ERR_JOB_INPUT_DATASET_NOT_READY_NO_FILES]

# ERR_JOB_INPUT_DATASET_NOT_READY_NO_FILES: Input dataset is not ready (no files found)

The root path of a dataset or folder required to complete the job does not exist or contains no file. DSS is trying to access data that is not there.

## Remediation

Check that the specified dataset has been built and contains data, or build the output datasets using the “Build upstream” method.

---

## [troubleshooting/errors/ERR_LICENSING_TRIAL_INTERNAL_ERROR]

# ERR_LICENSING_TRIAL_INTERNAL_ERROR: Internal error trying to get a trial token

Dataiku failed to grant a trial token.

## Remediation

Please contact Dataiku.

---

## [troubleshooting/errors/ERR_LICENSING_TRIAL_STATUS_ERROR]

# ERR_LICENSING_TRIAL_STATUS_ERROR: Internal error trying to get a trial status

Dataiku failed to fetch the trial status of the instance.

## Remediation

Please contact Dataiku.

---

## [troubleshooting/errors/ERR_METRIC_DATASET_COMPUTATION_FAILED]

# ERR_METRIC_DATASET_COMPUTATION_FAILED: Metrics computation completely failed

DSS tried refresh the basic metrics on a dataset, but failed.

## Remediation

The causes for not being able to compute a metric can be:

  * invalid dataset setup, resulting in unreadable data files or unreadable SQL tables

  * unavailability of the engine selected for the computations (Hiveserver2 or Impala server down, invalid connection parameters for Hadoop or the SQL connection)




The error message should give more context about what part of the metric computations can have failed, and should direct attempts to fix the problem. If the engine seems available, the settings of which engine to use are accessible on the dataset’s Status > Edit tab.

---

## [troubleshooting/errors/ERR_METRIC_ENGINE_RUN_FAILED]

# ERR_METRIC_ENGINE_RUN_FAILED: One of the metrics engine failed to run

DSS failed to compute a metric on an object (dataset or folder).

## Remediation

The causes for not being able to compute a metric can be:

  * generated SQL queries becoming too large for the computation engine. This happens when selecting too many metrics on a large number of columns; many databases have limits on the number of columns and aggregates a single statement can hold

  * invalid dataset setup, resulting in unreadable data files or unreadable SQL tables

  * unavailability of the engine selected for the computations (Hiveserver2 or Impala server down, invalid connection parameters for Hadoop or the SQL connection)




The error message should give more context about what part of the metric computations can have failed, and should direct attempts to fix the problem.

---

## [troubleshooting/errors/ERR_MISC_DISK_FULL]

# ERR_MISC_DISK_FULL: Disk is almost full

The file system mentioned in the error is almost full. This error is triggered when a file system is over 90% full. This threshold can be modified with the dku.sanitycheck.diskusage.threshold dip property. Note that the value must be a percentage (i.e. dku.sanitycheck.diskusage.threshold=85 for 85%).

## Remediation

Various subsystems of DSS consume disk space in the DSS data directory, see [Managing DSS disk usage](<../../operations/disk-usage.html>) for more details.

---

## [troubleshooting/errors/ERR_MISC_EIDB]

# ERR_MISC_EIDB: Missing, locked, unreachable or corrupted internal database

Internal databases are disk-based by default. In the default configuration, hard failures of DSS may corrupt internal database files.

Hard failures of DSS include:

  * Hard crash of DSS

  * Hard reboot of the machine

  * Out of disk space




Note that at this point, you will lose non critical DSS data based on the impacted database (e.g. discussions, jobs, requests).

An alternative and robust configuration consists in running an external PostgreSQL database. Refer to [Externally hosting runtime databases](<../../operations/runtime-databases.html#runtime-db-external>).

## Remediation

This issue can only be fixed by a DSS administrator.

A DSS administrator needs to:

  * Back up internal database files.

  * Restart DSS. DSS will log the name of the corrupted database file.

  * Stop DSS.

  * Remove the corrupted database file.

  * Start DSS.

---

## [troubleshooting/errors/ERR_MISC_ENOSPC]

# ERR_MISC_ENOSPC: Out of disk space

DSS tries to do some operation for which it needs disk space, but the disk is full. You may also see the message `No space left on device`, which carries the same meaning.

## Remediation

This issue can only be fixed by a DSS administrator.

A DSS administrator needs to free up some disk space on the partition where the [DSS data directory](<../../operations/datadir.html>) is located.

Warning

After such an error, you MUST restart DSS. Failure to do so may leave some functionality of DSS non-functional.

---

## [troubleshooting/errors/ERR_MISC_EOPENF]

# ERR_MISC_EOPENF: Too many open files

DSS and its subprocesses hold more open file descriptors than the limit configured for this system/process/user.

## Remediation

This issue can only be fixed by a DSS administrator.

To fix this issue:

  * Stop DSS, and make sure no processes are still running

  * Check the allowed number of open files with `ulimit -n` (as the unix user that runs dss)

  * [Increase that limit](<https://www.cyberciti.biz/faq/linux-increase-the-maximum-number-of-open-files/>), ideally to 64,000

  * Restart DSS




If this does not solve your issue, please report the issue to Dataiku support.

---

## [troubleshooting/errors/ERR_ML_MODEL_DETAILS_OVERFLOW]

# ERR_ML_MODEL_DETAILS_OVERFLOW: Model details exceed size limit

Some details of this model require more memory than allowed, so DSS stopped reading those details to prevent a large memory consumption by the backend.

This happens when the files containing details about the model are bigger than the allowed quota. There are two usual underlying causes to this:

  * This model is computed on a dataset with a very large number of columns

  * This model is tree-based, has a very large number of nodes (numerous and/or very deep trees)




## Remediation

As a user, you can try reducing the size of the model (less columns, less trees, shallower trees).

A DSS administrator can also change the quota for this error, by setting the value of `dku.fileSizeLimit.modelDetailJson` in `config/dip.properties` in the data directory. Specify the quota in bytes, defaults to 52428800 (i.e. 50 MB).

If this does not solve your issue, please report the issue to Dataiku support.

---

## [troubleshooting/errors/ERR_ML_VERTICA_NOT_SUPPORTED]

# ERR_ML_VERTICA_NOT_SUPPORTED: Vertica ML backend is no longer supported

Support for Machine Learning through Vertica Advanced Analytics was dropped as of DSS version 9. You can no longer use nor train Vertica models.

## Remediation

As a user, you train a new model using one of the available [Machine Learning engines](<../../machine-learning/algorithms/index.html>) in DSS.

---

## [troubleshooting/errors/ERR_NOT_USABLE_FOR_USER]

# ERR_NOT_USABLE_FOR_USER: You may not use this connection

You don’t have rights to access this connection

## Remediation

Contact DSS administrator to obtain connection access rights

---

## [troubleshooting/errors/ERR_OBJECT_OPERATION_NOT_AVAILABLE_FOR_TYPE]

# ERR_OBJECT_OPERATION_NOT_AVAILABLE_FOR_TYPE: Operation not supported for this kind of object

You are trying to perform an action that is not possible or not supported on this kind of object. For example, you cannot clear a Saved Model, it has no data.

This error typically happen on incorrect API calls.

---

## [troubleshooting/errors/ERR_PLUGIN_CANNOT_LOAD]

# ERR_PLUGIN_CANNOT_LOAD: Plugin cannot be loaded

A plugin failed to be loaded, because :

  * another one with the same name but of another type already exist




## Remediation

This issue can only be fixed by a DSS administrator.

There is a folder with the same name in plugins/dev and the plugins/installed. Either the plugin in the plugins/dev or the plugins/installed folder needs to be removed.

---

## [troubleshooting/errors/ERR_PLUGIN_COMPONENT_NOT_INSTALLED]

# ERR_PLUGIN_COMPONENT_NOT_INSTALLED: Plugin component not installed or removed

A plugin has been removed, or parts of a development plugin have been removed. This error can be encountered on any object potentially defined in a plugin, such as:

  * datasets

  * recipes

  * macros

  * …




## Remediation

The plugin has been removed so there are 2 cases:

  * the removal is intentional: the browser’s page need to be refreshed

  * the removal is not intentional : this issue can only be fixed by a DSS administrator, either by reinstalling the plugin or by reverting the plugins/dev to a previous state.

---

## [troubleshooting/errors/ERR_PLUGIN_DEV_INVALID_COMPONENT_PARAMETER]

# ERR_PLUGIN_DEV_INVALID_COMPONENT_PARAMETER: Invalid parameter for plugin component creation

The user is trying to add a non-working component to the plugin :

  * adding a code env definition when there is already one

  * adding a java component without specifying a fully qualified class name containing at least one package hierarchy




## Remediation

For duplicate code environment definitions, go to the editor tab and delete the old one. For incorrect class names, add a package to the fully qualified class name.

---

## [troubleshooting/errors/ERR_PLUGIN_DEV_INVALID_DEFINITION]

# ERR_PLUGIN_DEV_INVALID_DEFINITION: The descriptor of the plugin is invalid

The user is attempting to push a change to a dev plugin’s descriptor that would break it:

  * the changes pushed are not in JSON format

  * the changes pushed don’t contain an identifier field for the plugin

---

## [troubleshooting/errors/ERR_PLUGIN_INVALID_DEFINITION]

# ERR_PLUGIN_INVALID_DEFINITION: The plugin’s definition is invalid

The plugin’s definition is inconsistent. The inconsistencies can be:

  * the plugin descriptor doesn’t define an identifier for the plugin

  * several components shipped in the plugin have the same identifier

  * the plugin declares a dependency expressed in a system unknown to DSS




## Remediation

This issue can only be fixed by the author of the plugin, and subsequent re-installation of the plugin.

---

## [troubleshooting/errors/ERR_PLUGIN_MISSING_IN_CONTAINER_IMAGE]

# ERR_PLUGIN_MISSING_IN_CONTAINER_IMAGE: Plugin is missing in container image

DSS is trying to run a recipe in a container, but one of the inputs or outputs or a step in the Prepare recipe’s script is provided by a plugin that has not been installed in the container image.

## Remediation

If the plugin has been removed completely from the DSS instance, the DSS administrator need to re-install it. If the plugin is installed in DSS, then the DSS administrator needs to ensure the plugin is selected to be included in the container image, and rebuild the container image

  * on the plugin page, make sure `Containerized visual recipes` is “Enabled”. If not, use “include in image”

---

## [troubleshooting/errors/ERR_PLUGIN_NOT_INSTALLED]

# ERR_PLUGIN_NOT_INSTALLED: Plugin not installed or removed

A plugin has been removed from the instance

## Remediation

The plugin has been removed so there are 2 cases:

  * the removal is intentional: the browser’s page need to be refreshed

  * the removal is not intentional : this issue can only be fixed by a DSS administrator, either by reinstalling the plugin or by reverting the plugins/dev to a previous state.

---

## [troubleshooting/errors/ERR_PLUGIN_WITHOUT_CODEENV]

# ERR_PLUGIN_WITHOUT_CODEENV: The plugin has no code env specification

The user has requested the update of the code env of a plugin, but no code env is setup for that plugin.

## Remediation

This issue can only be fixed by a DSS administrator.

A code env for the plugin needs to be created first, by going to the Administration > Plugins list and setuping the plugins dependencies.

See also the [documentation on Code environments](<../../code-envs/index.html>).

---

## [troubleshooting/errors/ERR_PLUGIN_WRONG_TYPE]

# ERR_PLUGIN_WRONG_TYPE: Unexpected type of plugin

An operation in the plugin development tools of DSS has targeted a plugin that is not in dev (add file, edit file, …)

## Remediation

This issue can only be fixed by a DSS administrator.

The plugin was probably installed on the instance as a final version, and now exists in the plugins/installed folder of the DSS data directory. If development needs to continue on the plugin, the version in plugins/installed needs to be removed.

---

## [troubleshooting/errors/ERR_PROJECT_INVALID_ARCHIVE]

# ERR_PROJECT_INVALID_ARCHIVE: Invalid project archive

The archive you specified does not contain a valid DSS project export. This can happen when trying to import a DSS project.

## Remediation

Check the source of this archive.

---

## [troubleshooting/errors/ERR_PROJECT_INVALID_PROJECT_KEY]

# ERR_PROJECT_INVALID_PROJECT_KEY: Invalid project key

The specified project key is invalid, either incorrect or already used. The error message will have more details on the exact issue.

This can happen when trying to import a DSS project or bundle.

## Remediation

Check the project key, edit it if necessary (if it was manually specified).

Check the source of this archive. If you want to overwrite a project when importing, first delete the former project, then import the other one.

---

## [troubleshooting/errors/ERR_PROJECT_UNKNOWN_PROJECT_KEY]

# ERR_PROJECT_UNKNOWN_PROJECT_KEY: Unknown project key

The specified project key does not correspond to any existing project. This typically happens when:

  * the specified project has been deleted

  * the current project has been imported from another DSS instance, and the current DSS instance does not contain the specified project




## Remediation

You can remove or edit the item that is referring to the unknown project.

---

## [troubleshooting/errors/ERR_RECIPE_CANNOT_CHANGE_ENGINE]

# ERR_RECIPE_CANNOT_CHANGE_ENGINE: Cannot change engine

You’re trying to change an engine for a recipe that doesn’t support this action.

For example, a Hive recipe always runs on Hive by definition.

## Remediation

Make sure that you’ve selected the right recipe(s).

---

## [troubleshooting/errors/ERR_RECIPE_CANNOT_CHECK_SCHEMA_CONSISTENCY]

# ERR_RECIPE_CANNOT_CHECK_SCHEMA_CONSISTENCY: Cannot check schema consistency

DSS could not check the schema consistency on this recipe. The specific error message should contain more information about why this is the case.

This error can happen when trying to run a schema check or propagate schema changes from a dataset.

## Remediation

Open the recipe and make sure it does not show any error. If the save button is enabled, try saving it and re-performing the schema check. Make sure that the output dataset(s) are correctly set, try to visit their Settings > Schema screen and launch the consistency check from there.

---

## [troubleshooting/errors/ERR_RECIPE_CANNOT_CHECK_SCHEMA_CONSISTENCY_EXPENSIVE]

# ERR_RECIPE_CANNOT_CHECK_SCHEMA_CONSISTENCY_EXPENSIVE: Cannot check schema consistency: expensive checks disabled

DSS has detected that the schema is expensive to compute for the specified dataset(s).

This error can happen when trying to run a schema check or propagate schema changes from a dataset.

## Remediation

The “Check consistency” and “Propagate schema” tools in the flow have a “Perform potentially slow checks” option. Make sure this option is enabled.

---

## [troubleshooting/errors/ERR_RECIPE_CANNOT_CHECK_SCHEMA_CONSISTENCY_NEEDS_BUILD]

# ERR_RECIPE_CANNOT_CHECK_SCHEMA_CONSISTENCY_NEEDS_BUILD: Cannot compute output schema with an empty input dataset. Build the input dataset first.

This error happens when trying to propagate a schema change in a dataset that is not yet built.

Some schema propagation require the dataset to be built, because the schema of the output dataset depends on the data of the input dataset. This is for example the case for some prepare recipes.

## Remediation

Build an input dataset in order to propagate the schema changes or check the schema consistency of downstream datasets.

---

## [troubleshooting/errors/ERR_RECIPE_CANNOT_CHECK_SCHEMA_CONSISTENCY_ON_RECIPE_TYPE]

# ERR_RECIPE_CANNOT_CHECK_SCHEMA_CONSISTENCY_ON_RECIPE_TYPE: Cannot check schema consistency on this kind of recipe

DSS cannot check the schema consistency on this kind recipe, because this recipe contains arbitrary code that can set the output schema at runtime.

This error can happen when trying to run a schema check or propagate schema changes from a dataset.

## Remediation

If you are trying to propagate the changes made on an upstream schema, you should rebuild this recipe’s output dataset (in recursive mode) to get the updated schema for this dataset and continue propagating downstream.

---

## [troubleshooting/errors/ERR_RECIPE_CANNOT_CHECK_SCHEMA_CONSISTENCY_WITH_RECIPE_CONFIG]

# ERR_RECIPE_CANNOT_CHECK_SCHEMA_CONSISTENCY_WITH_RECIPE_CONFIG: Cannot check schema consistency because of recipe configuration

DSS cannot check the schema consistency on this recipe’s output dataset, because this recipe’s configuration prevents the deterministic computation of the schema.

This error can happen when trying to run a schema check or propagate schema changes from a dataset.

The common causes for this error happening are:

  * A Pivot recipe is configured to always recompute output schema

  * The modality list of a Pivot recipe is not up-to-date, e.g. because the input dataset or the recipe settings were change

  * A SparkSQL recipe is using global metastore mode, which disables validation and schema computation

  * A Sync recipe is configured in “free output schema” mode, meaning that you set the schema of the output dataset and the recipe will perform name-based matching to fill the columns from the input dataset.




## Remediation

  * For the Pivot recipe, you can disable the schema re-computation, and run it so that the output dataset is computed and its schema is up-to-date.

  * For the SparkSQL recipe, you can either disable the global metastore if you don;t need it or run the recipe to compute the output dataset.

  * For the Sync recipe, you can switch it to Strict schema mode to update the output schema (this will erase any customization that you made like column reordering), then put it back in free schema mode for customization.




In all cases, you can also manually (or programmatically using the [Public API](<../../publicapi/index.html>)) set the schema on the output dataset.

Learn more about:

  * [Pivot recipe](<../../other_recipes/pivot.html>)

  * [SparkSQL recipes](<../../code_recipes/sparksql.html>)

  * [Sync: copying datasets](<../../other_recipes/sync.html>)

---

## [troubleshooting/errors/ERR_RECIPE_CANNOT_SPARK]

# ERR_RECIPE_CANNOT_CHANGE_ENGINE: Not compatible with Spark

You’re trying retrieve or set recipe’s Spark configuration but this recipe doesn’t support this action.

Not all recipes are compatible with Spark.

## Remediation

Make sure that you’ve selected the right recipe(s).

---

## [troubleshooting/errors/ERR_RECIPE_CANNOT_USE_ENGINE]

# ERR_RECIPE_CANNOT_USE_ENGINE: Cannot use the selected engine for this recipe

The selected execution engine / backend for this recipe cannot be used. The specific error message should contain more details on the precise cause of this error.

The input dataset, model, or other recipe settings are not compatible with the selected engine for this recipe.

Some common examples include:

  * Using the SQL engine with non-SQL input datasets

  * Using SQL computed columns on DSS engine

  * Changing the model (output of a training recipe or input of a scoring recipe) for one with a different backend.

  * Using features not supported by the engine, like text features for ML in SQL.




## Remediation

Make sure that the recipe settings and inputs are compatible with the selected engine. Change the engine if necessary.

If the recipe’s inputs were recently changed, that is probably a good place to start looking.

---

## [troubleshooting/errors/ERR_RECIPE_ENGINE_NOT_DWH]

# ERR_RECIPE_ENGINE_NOT_DWH: Error in recipe engine: SQLServer is not Data Warehouse edition

DSS attempted to use an Azure Data Warehouse engine on a standard SQLServer database.

## Remediation

  * If the Azure database is indeed a Data Warehouse edition, go to its connection settings in the administration section, and check the “Azure Data Warehouse” box.

  * If the Azure database is not a Datawarehouse edition, choose the DSS Recipe engine instead of Azure to SQLServer

---

## [troubleshooting/errors/ERR_RECIPE_INCONSISTENT_I_O]

# ERR_RECIPE_INCONSISTENT_I_O: Inconsistent recipe input or output

There is an issue with that recipe’s inputs or outputs. The specific error message should contain more details on the precise cause of this error.

Some common examples include:

  * The output dataset of a recipe is read-only

  * The output of a recipe is expected to ba a dataset but is not




## Remediation

Make sure that the recipe settings and inputs are correct. Check these datasets’ status.

If the recipe’s inputs were recently changed, that is probably a good place to start looking.

---

## [troubleshooting/errors/ERR_RECIPE_PDEP_UPDATE_REQUIRED]

# ERR_RECIPE_PDEP_UPDATE_REQUIRED: Partition dependency update required

There is an issue with that recipe’s partition dependencies. The specific error message should contain more details on the precise cause of this error.

## Remediation

Make sure that the recipe’s partition dependencies are valid and working as expected (see the test button in the recipe’s Inputs/Outputs screen). Check these datasets’ status.

See [DSS concepts](<../../concepts/index.html>) and [Specifying partition dependencies](<../../partitions/dependencies.html>) for more information about partitions and partition dependencies.

---

## [troubleshooting/errors/ERR_RECIPE_SPLIT_INVALID_COMPUTED_COLUMNS]

# ERR_RECIPE_SPLIT_INVALID_COMPUTED_COLUMNS: Invalid computed column

There is a computed column on that Split recipe that has a name conflict. The split recipe need unique names for all input and computed columns, case-insensitive.

The name conflict can happen:

  * between computed columns

  * between a computed column and an input column

  * between input columns (on a case-sensitive dataset, there might be 2 columns where case is the only difference)




## Remediation

Check the names of the computed columns and input columns, keeping in mind the case-insensitivity.

---

## [troubleshooting/errors/ERR_RECIPE_SYNC_AWS_DIFFERENT_REGIONS]

# ERR_RECIPE_SYNC_AWS_DIFFERENT_REGIONS: Error in recipe engine: Redshift and S3 are in different AWS regions

DSS attempted to sync a Redshift cluster with a S3 dataset from another AWS regions, using “Redshift to S3” or “S3 to Redshift” engine. AWS does not currently allow this operation.

## Remediation

  * Use a S3 bucket in the same AWS region as the Redshift cluster, or

  * Use the DSS engine instead of “Redshift to S3” / “S3 to Redshift”.

---

## [troubleshooting/errors/ERR_SCENARIO_INVALID_STEP_CONFIG]

# ERR_SCENARIO_INVALID_STEP_CONFIG: Invalid scenario step configuration

The configuration of the current scenario step seems invalid. The error message will contain details on what parameter is invalid.

This error can happen when editing or running a scenario step.

## Remediation

The first step for solving this issue is to check the settings of the affected scenario step.

See also the [documentation on Scenario steps](<../../scenarios/steps.html>)

---

## [troubleshooting/errors/ERR_SECURITY_CRUD_INVALID_SETTINGS]

# ERR_SECURITY_CRUD_INVALID_SETTINGS: The user attributes submitted for a change are invalid

The request submitted to modify a user attributes from the administration panel are invalid. On of the following could have happened:

  * The Display name is empty

  * The Login is empty

  * The Login name is too short: it must have at least 3 characters

  * The Login name is too long: it must not exceed 80 characters

  * The Login name contains invalid characters: the allowed characters are letters, numbers, @, ., +, _ and -.

  * The updated user is updated as a LDAP user but is not a LDAP user

  * The Group name added to the user is empty

  * The Group name added to the user is too long: it must not exceed 80 characters

  * The Group name added to the user contains invalid characters: the allowed characters are letters, numbers, @, ., +, _ and -.




## Remediation

Fix the user attributes to match the constraints.

---

## [troubleshooting/errors/ERR_SECURITY_DECRYPTION_FAILED]

# ERR_SECURITY_DECRYPTION_FAILED: Decryption failed due to invalid HMAC

If you receive an error similar to `Decryption Failed, caused by: CodedException: Invalid HMAC` or `Decryption Failed`, this is usually caused by copying over your `connections.json` file from one instance to another. Passwords in `connections.json` are encrypted with an encryption key that is specific to the original instance.

## Remediation

To resolve this, do not copy over your `connections.json` file from one instance to another. If you receive this error, you will need to re-enter the passwords in each connection’s settings page of the instance.

---

## [troubleshooting/errors/ERR_SECURITY_GROUP_EXISTS]

# ERR_SECURITY_GROUP_EXISTS: The new requested group already exists

The new group requested already exists in the database.

## Remediation

Choose another name for the group or use the existing one.

---

## [troubleshooting/errors/ERR_SECURITY_INVALID_NEW_PASSWORD]

# ERR_SECURITY_INVALID_NEW_PASSWORD: The new password is invalid

DSS passwords cannot be empty and must have at least 5 characters.

## Remediation

Use a password with a least 5 characters.

---

## [troubleshooting/errors/ERR_SECURITY_INVALID_PASSWORD]

# ERR_SECURITY_INVALID_PASSWORD: The password hash from the database is invalid

The password hash retrieved from the database is not a valid hash. The user password cannot be verified, the database may have been corrupted.

## Remediation

This issue can only be fixed by a DSS administrator.

If the `DATA_DIR/config/users.json` file has been modified manually, restore the previous version.

Otherwise, use the administrator account to set a new password for the affected user. If the admin account itself is corrupted, the API with may be used to do so.

---

## [troubleshooting/errors/ERR_SECURITY_MUS_USER_UNMATCHED]

# ERR_SECURITY_MUS_USER_UNMATCHED: The DSS user is not configured to be matched onto a system user

When DSS impersonates a user, it must have a rule to determine the system user name which it is supposed to impersonate. This error means no rule has been configured for this user.

## Remediation

This issue can only be fixed by a DSS Administrator.

Select an impersonation matching rule in the administration panel for the faulty user. See [User Isolation Concepts](<../../user-isolation/concepts.html>) for more information about identity mapping.

---

## [troubleshooting/errors/ERR_SECURITY_PATH_ESCAPE]

# ERR_SECURITY_PATH_ESCAPE: The requested file is not within any allowed directory

DSS enables the user with direct access to some files. Such shall stay into the allowed directories. This error can be triggered if:

  * The filename provided in the folder editor is pointing to a file outside said folder

  * A report template file is referred to with a name pointing outside the template directory




## Remediation

Do not use directory change patterns into filenames like `../`. If you do see how you could have triggered this error, please contact the support.

---

## [troubleshooting/errors/ERR_SECURITY_UPLOAD_WITHOUT_CONNECTION]

# ERR_SECURITY_UPLOAD_WITHOUT_CONNECTION: Your site’s policy does not allow you to upload datasets without a valid target connection

This error can be triggered if a user tries to upload a dataset without having a valid connection set up for the target storage.

## Remediation

Specify a valid target connection when uploading a file: you can ask your administrator to grant you access to a valid target connection (Refer to the [documentation about Storage Location](<../../connecting/upload.html#uploading-files-storage-location>)).

---

## [troubleshooting/errors/ERR_SECURITY_USER_EXISTS]

# ERR_SECURITY_USER_EXISTS: The requested user for creation already exists

When creating a user, an occurrence of this error means that this username is already taken.

## Remediation

Choose another username for this user or use the existing user account.

---

## [troubleshooting/errors/ERR_SECURITY_WRONG_PASSWORD]

# ERR_SECURITY_WRONG_PASSWORD: The old password provided for password change is invalid

When changing the user’s password, an occurrence of this error means the old password provided to allow a password change is incorrect.

## Remediation

Double-check your current password or contact a DSS Administrator to request a change of your password.

---

## [troubleshooting/errors/ERR_SPARK_FAILED_DRIVER_OOM]

# ERR_SPARK_FAILED_DRIVER_OOM: Spark failure: out of memory in driver

## Description

This error can happen when running any Spark-enabled recipe

This error indicates that the Spark processing failed because the Spark “driver” (main component) experienced an out of memory situation.

## Remediation

### Specific case of code recipes

If the failure comes from a Spark code recipe (Spark-Scala, Pyspark or SparkR), check your code for large allocations performed in the driver.

### General case

This error generally does not indicate that the DSS machine or the cluster is out of memory, but that the configuration for executing the Spark code is too restrictive.

You generally need to increase the `spark.driver.memory` Spark setting. For more information about how to set Spark settings, please see [Spark configurations](<../../spark/configuration.html>). Note that your administrator may need to perform this change.

If not set, the default value of `spark.driver.memory` is 1 gigabyte (`1g`).

If your Spark is running in `local` master mode, note that the value of `spark.driver.memory` must also include memory for executors.

---

## [troubleshooting/errors/ERR_SPARK_FAILED_TASK_OOM]

# ERR_SPARK_FAILED_TASK_OOM: Spark failure: out of memory in task

## Description

This error can happen when running any Spark-enabled recipe

This error indicates that the Spark processing failed because one of the executors encountered a Java out of memory situation.

## Remediation

### Specific case of code recipes

If the failure comes from a Spark code recipe (Spark-Scala, Pyspark or SparkR), check your code for large allocations performed in the executors.

### General case

This error generally does not indicate that the DSS machine or the cluster is out of memory, but that the configuration for executing the Spark code is too restrictive.

You generally need to increase the `spark.executor.memory` Spark setting. For more information about how to set Spark settings, please see [Spark configurations](<../../spark/configuration.html>). Note that your administrator may need to perform this change.

If not set, the default value of `spark.executor.memory` is 1 gigabyte (`1g`).

If your Spark is running in `local` master mode, note that the value of `spark.executor.memory` is not used. Instead, you must increase `spark.driver.memory` to increase the shared memory allocation to both driver and executor.

---

## [troubleshooting/errors/ERR_SPARK_FAILED_YARN_KILLED_MEMORY]

# ERR_SPARK_FAILED_YARN_KILLED_MEMORY: Spark failure: killed by YARN (excessive memory usage)

## Description

This error can happen when running any Spark-enabled recipe, when Spark is running in “YARN” deployment mode.

This error indicates that YARN (the resource manager) has forcefully killed the Spark components, because they ran above their allocated memory allocation.

When a Spark application starts on YARN, it tells YARN how much memory it will use at maximum. YARN accordingly reserves this amount of memory. If, during runtime, the memory usage (per container) goes above this limit, YARN kills the process for breaching its promise.

## Remediation

When a Spark application runs on YARN, it requests YARN containers with an amount of memory computed as: `spark.executor.memory + spark.yarn.executor.memoryOverhead`

`spark.executor.memory` is the amount of Java memory (Xmx) that Spark executors will get. However, Java processes always consume a bit more memory, which is accounted for by `spark.yarn.executor.memoryOverhead`

By default, the memory overhead is 10% of executor memory (with a minimum of 384 MB). This value is often not enough.

The remediation is to increase the value of `spark.yarn.executor.memoryOverhead` Spark setting. For more information about how to set Spark settings, please see [Spark configurations](<../../spark/configuration.html>). Note that your administrator may need to perform this change.

Beware: unlike `spark.executor.memory` where values like `3g` are permitted, the value for `spark.yarn.executor.memoryOverhead` must always be an integer, in megabytes.

We generally recommend setting a value between `500` and `1000`.

---

## [troubleshooting/errors/ERR_SPARK_PYSPARK_CODE_FAILED_UNSPECIFIED]

# ERR_SPARK_PYSPARK_CODE_FAILED_UNSPECIFIED: Pyspark code failed

## Description

This error can happen when:

  * Running a Pyspark recipe

  * Running a plugin recipe that uses Pyspark




This error indicates that the Pyspark execution failed, and threw a Python exception.

  * The message of the error contains the full error message from Spark

  * Additional details, including the Python stack, are available in the job log




## Remediation

You need to carefully read both the error message, and the logs of the job that failed. Between them, they contain all information which is available to understand why the Pyspark code threw an exception.

---

## [troubleshooting/errors/ERR_SPARK_SQL_LEGACY_UNION_SUPPORT]

# ERR_SPARK_SQL_LEGACY_UNION_SUPPORT: Your current Spark version doesn’t support UNION clause but only supports UNION ALL, which does not remove duplicates

The Spark SQL cannot be executed because it includes a UNION clause that is not supported by this version of Spark

## Remediation

If you’re running a stack recipe with Distinct rows post-filter there are following possibilities:

  * Use stack recipe without distinct postfilter + create a distinct recipe for a result of a stack recipe

  * Apply distinct recipe on each of the stacked datasets and then stack them

  * Create a Spark SQL recipe with a query that uses UNION ALL and then wrap the whole query with SELECT DISTINCT {your column names} from {select with UNION ALL}

---

## [troubleshooting/errors/ERR_SQL_CANNOT_LOAD_DRIVER]

# ERR_SQL_CANNOT_LOAD_DRIVER: Failed to load database driver

To connect to SQL databases, DSS uses a small piece of code called a JDBC driver.

Each database kind (MySQL, PostgreSQL, Oracle, SQLServer, …) needs its own specific JDBC driver. JDBC drivers are provided by your database’s vendor, and must be installed in DSS.

This error can happen:

  * when trying to create a new connection to a SQL database

  * when trying to read or write a SQL dataset

  * when trying to use a SQL notebook




This error indicates that the JDBC driver for this specific type of database is not found or not properly installed.

If the issue is encountered in a containerized job, you might need to rebuild the [containerized dss engine image](<../../containers/containerized-dss-engine.html>).

## Remediation

Note

This issue can only be fixed by a DSS administrator

  * Refer to the [documentation on JDBC drivers](<../../installation/custom/jdbc.html>) in order to know how to install JDBC drivers.

  * Make sure that you restarted DSS after installing the JDBC driver

  * If none of these helps, the error message may contain additional details.

  * Refer to the documentation of your JDBC driver which may contain specific installation instructions

  * Some JDBC drivers need several JAR files, make sure you have installed all of them, as indicated by the documentation of your JDBC driver

---

## [troubleshooting/errors/ERR_SQL_DB_UNREACHABLE]

# ERR_SQL_DB_UNREACHABLE: Failed to reach database

DSS tried to connect to a SQL database but couldn’t establish the connection.

This error can happen:

  * when trying to create a new connection to a SQL database

  * when trying to read or write a SQL dataset

  * when trying to use a SQL notebook




This error indicates that the connection could not be established. The message of the error will contain additional information.

Some common reasons for failure to establish the connection are:

  * The connection settings (host, port, …) to the database are invalid

  * The database server is not running or not accepting connections

  * There is a firewall blocking connection attempts from DSS to the database server

  * Credentials entered in DSS for the database server are invalid




## Remediation

Note

This issue can only be fixed by a DSS administrator

The first step for solving this issue is to go to the settings screen for the affected connection (Administration > Connections). You can test connection from here.

  * Refer to the [documentation on SQL databases](<../../connecting/sql/index.html>) in order to get additional information on the support of your specific database by DSS.

  * Make sure that the connection settings are correct

  * If you get “connection refused” or similar errors, check that the database server is properly running

  * Check if a firewall is blocking connections between DSS and the database server (this can result in either “connection refused” issues, or timeout issues)

---

## [troubleshooting/errors/ERR_SQL_IMPALA_MEMORYLIMIT]

# ERR_SQL_IMPALA_MEMORYLIMIT: Impala memory limit exceeded

## Description

While executing a query, Impala encountered a memory limit exceeded situation.

This error can happen each time DSS interacts with Impala:

  * When running an Impala code recipe

  * When running a visual recipe with Impala engine

  * When computing status of a HDFS dataset

  * When computing charts on a HDFS dataset (including charts on a dashboard)




## Remediation

This error is internal to Impala. Your administrator needs to change the configuration of the Hadoop cluster to increase the memory allocation to Impala.

---

## [troubleshooting/errors/ERR_SQL_POSTGRESQL_TOOMANYSESSIONS]

# ERR_SQL_POSTGRESQL_TOOMANYSESSIONS: too many sessions open concurrently

Your Postgres database has too many active sessions simultaneously accessing it. The database imposes a fixed maximum on the number of simultaneous uses.

This maximum number of simultaneous connections might be too low or you may need to run fewer connections in parallel. Note in particular that building several partitions of a Postgres dataset in DSS will result in the corresponding number of connections to the database.

## Remediation

You can reduce the number of connections used simultaneously by running fewer recipes at the same time. For instance, you may want to schedule recipes at different times of the day rather than starting many computations at the same moment.

Your DSS administrator can limit the number of concurrent activities on that Postgres connection (in Administration > Connection, in the Connection’s “Usage params”) so that additional activities will wait instead of failing with this error.

You can also ask your database administrator to increase the parameter controlling the maximum number of simultaneous sessions. Refer to the [postgres documentation](<https://www.postgresql.org/docs/9.5/static/runtime-config-connection.html>) (choose according to your version) for how to change the maximum number of simultaneous connections.

---

## [troubleshooting/errors/ERR_SQL_TABLE_NOT_FOUND]

# ERR_SQL_TABLE_NOT_FOUND: SQL Table not found

DSS tried to access a table in a SQL database, but the SQL database does not contain the table.

This error can happen:

>   * When trying to view a SQL dataset
> 
> 


## Remediation

  * If this error occurs on a “source” dataset (i.e. a dataset that is at the beginning of the flow), you need to check the settings of the dataset. The table name might be incorrect

  * If this error occurs on a “managed” dataset (i.e. a dataset that is built as part of the Flow), you might need to rebuild this dataset, as it may have been previously cleared.

  * Check that, in addition to the table name, the schema name is also correct

  * Pay attention to case: most SQL databases are case-sensitive, “MYTABLE” is not the same as “mytable”

  * This error can also be caused by permission issues. On some databases, if you don’t have permission to read or write a table, you will get a “table not found” error

---

## [troubleshooting/errors/ERR_SQL_VERTICA_TOOMANYROS]

# ERR_SQL_VERTICA_TOOMANYROS: Error in Vertica: too many ROS

Your Vertica hit it limit of Read Optimized Stores (ROS) containers for a given projection.

Vertica organises data within projections, each of them based on data containers called ROS. Vertica imposes a limit on the number of ROS that can be created for a given projection.

Vertica creates new ROS containers when ingesting data and periodically merges them (an operation called “mergeout”). Inserting many times data before the mergeout happens may lead to reaching the limit.

An important factor is also that DSS partitioning uses native Vertica partitioning and several partitions will necessarily use several ROS. A large number of partitions may lead to reaching the limit.

## Remediation

  * Rerunning the failed recipe may work if the mergeout happened in the meantime

  * You can avoid adding frequently data before the mergeout can happen

  * Your database administrator can manually trigger the mergeout by running the SQL: `SELECT DO_TM_TASK('mergeout');`

  * If your dataset contains many small partitions, you can avoid this issue and improve performance by using less fine-grained partitioning schemes (for example by day rather than hour)

---

## [troubleshooting/errors/ERR_SQL_VERTICA_TOOMANYSESSIONS]

# ERR_SQL_VERTICA_TOOMANYSESSIONS: Error in Vertica: too many sessions open concurrently

Your Vertica database has too many active sessions simultaneously accessing it. The database imposes a fixed maximum on the number of simultaneous uses.

This maximum number of simultaneous connections might be too low or you may need to run fewer connections in parallel. Note in particular that building several partitions of a Vertica dataset in DSS will result in the corresponding number of connections to the database.

## Remediation

You can reduce the number of connections used simultaneously by running fewer recipes at the same time. For instance, you may want to schedule recipes at different times of the day rather than starting many computations at the same moment.

Your DSS administrator can limit the number of concurrent activities on that Vertica connection (in Administration > Connection, in the Connection’s “Usage params”) so that additional activities will wait instead of failing with this error.

You can also ask your database administrator to increase the parameter controlling the maximum number of simultaneous sessions (`MaxClientSessions` in Vertica), it typically defaults to 50. See the Vertica documentation for the steps to follow.

---

## [troubleshooting/errors/ERR_SYNAPSE_CSV_DELIMITER]

# ERR_SYNAPSE_CSV_DELIMITER: Bad delimiter setup

DSS tried to load CSV data from a Azure Blob Storage file to Synapse or SQLServer DataWarehouse, but the delimiter settings on the CSV dataset aren’t working for the actual Azure loader (Polybase or COPY statement)

This error can happen:

>   * when the data contains multiline fields
> 
>   * when the field separator (usually the tab or semi-colon character) is present in the data, but no quoting character is used for the loader. This leads Azure to see more fields on a given row than it expects
> 
>   * when the string delimiter (usually the double quote character) is present in the data and quoting is used for the loader. Polybase can’t handle such situations
> 
> 


## Remediation

  * multiline fields are not handled by the Azure loader at all: disabling the fast-path and using the DSS (stream) engine is the only solution

  * if quoting for the Azure loader is explicitly disabled on the DSS instance (i.e. the `dku.azure_to_synapse.use.quoting=false` line has been added to the `config/dip.properties` file), then you can force using quoting for the recipe by adding a property `azure_to_synapse.use.quoting -> true` on the input dataset in the Settings > Advanced tab, under Custom properties

  * if the quoting character is present in the data, you can try switching the input dataset format to CSV with Unix style, and specify a non-common character as quoting character

---

## [troubleshooting/errors/ERR_TRANSACTION_FAILED_ENOSPC]

# ERR_TRANSACTION_FAILED_ENOSPC: Out of disk space

An error occurred while trying to save changes performed by a user (saving a recipe, a dataset, a notebook, …) because there is no space left on the disk where the DSS data directory is located.

## Remediation

This issue can only be fixed by a DSS administrator.

A DSS administrator needs to free up some disk space on the partition where the [DSS data directory](<../../operations/datadir.html>) is located.

Warning

After such an error, you MUST restart DSS. Failure to do so may leave some functionality of DSS non-functional.

---

## [troubleshooting/errors/ERR_TRANSACTION_GIT_COMMIT_FAILED]

# ERR_TRANSACTION_GIT_COMMMIT_FAILED: Failed committing changes

An internal error occurred while trying to save changes performed by a user (saving a recipe, a dataset, a notebook, …)

## Remediation

A common issue is when the exception contains “Cannot lock /path/to/DSS/……/.git/index”. This error usually means that an offending “index.lock” has remained in the mentioned folder, possibly after another error:

  * Stop DSS, and make sure no processes are still running

  * Make sure that no “git” process is running in the mentioned folder

  * Remove the “index.lock” file

  * Restart DSS




If you are not in this case, the backend log file may contain additional information. Else, please report the issue to Dataiku support.

---

## [troubleshooting/errors/ERR_USER_ACTION_FORBIDDEN_BY_PROFILE]

# ERR_USER_ACTION_FORBIDDEN_BY_PROFILE: Your user profile does not allow you to perform this action

User profiles define the types of actions your are allowed to do from a licensing perspective.

This error usually happens when, as a READER or DATA_ANALYST, you are trying to build a Visual Machine Learning model. For example, if your profile is READER or DATA_ANALYST, this error will happen if you attempt to build a Visual Machine Learning model.

This error may also happen if your DSS administrator updated the DSS license. Your user profile may not exist anymore in the new license.

## Remediation

To solve this issue ask the DSS administrator to update the user profile (note that DESIGNER is the unlimited profile in most licenses).

See also [User profiles](<../../security/user-profiles.html>)

---

## [troubleshooting/errors/INFO_RECIPE_IMPALA_POTENTIAL_FAST_PATH]

# INFO_RECIPE_IMPALA_POTENTIAL_FAST_PATH: Potential Impala fast path configuration

The SQL query results are streamed from an input connection through DSS to the output dataset which may be slow.

## Remediation

If your recipe is not impacted by the known [Impala limitations](<../../hadoop/impala.html#impala-limitations>), go to the `Advanced` settings and uncheck the `Stream mode` option.

---

## [troubleshooting/errors/INFO_RECIPE_POTENTIAL_FAST_PATH]

# INFO_RECIPE_POTENTIAL_FAST_PATH: Potential fast path configuration

The SQL query results are streamed from an input connection through DSS to the output dataset which may be slow. This is due to your recipe using an input connection as the main connection.

## Remediation

If the output dataset connection can access all inputs, then you can configure the recipe to use fast-path: in the `Advanced` settings, check the `Allow SQL across connections` option and select the output dataset as the `Main SQL connection`.

---

## [troubleshooting/errors/WARN_ACTIVITY_WAITING_K8S_CONTAINERSTARTING_CLOUD]

# WARN_ACTIVITY_WAITING_K8S_CONTAINERSTARTING_CLOUD: Execution container is initializing

The container corresponding to your activity is initializing.

## Remediation

If the container is still initializing after 10 minutes, please contact Dataiku Support.

---

## [troubleshooting/errors/WARN_ACTIVITY_WAITING_K8S_POD_PENDING_CLOUD]

# WARN_ACTIVITY_WAITING_K8S_POD_PENDING_CLOUD: Container will start soon

The container corresponding to your activity will start soon.

## Remediation

If the container is still pending after 10 minutes, please contact Dataiku Support.

---

## [troubleshooting/errors/WARN_ACTIVITY_WAITING_K8S_QUOTA_EXCEEDED_CLOUD]

# WARN_ACTIVITY_WAITING_K8S_QUOTA_EXCEEDED_CLOUD: You have exceeded your RAM and CPU quotas

Your space has reached it’s maximum capacity of CPU or RAM. Your activity has been queued and will be executed when enough resources become available.

## Remediation

From your Dataiku Launchpad, a space administrator can view the current resource consumption of your space and abort any activity that is no longer required to free up resources.

---

## [troubleshooting/errors/WARN_ACTIVITY_WAITING_QUEUED_CLOUD]

# WARN_ACTIVITY_WAITING_QUEUED_CLOUD: Your activity is queued

Your space has reached it’s maximum limit of running activities. Your activity has been queued and will be executed once another activity is completed.

## Remediation

From your Dataiku Launchpad, a space administrator can view all running activities can abort any activity that is no longer required to free up resources.

---

## [troubleshooting/errors/WARN_APP_AS_RECIPE_HAS_ORPHAN_INSTANCES]

# WARN_APP_AS_RECIPE_HAS_ORPHAN_INSTANCES: Too many Application-As-Recipe instances

When the Keep Instance option is enabled for a given Application-As-Recipe, everytime the recipe is run, the instance is kept for troubleshooting purposes. This option should only be used temporarily since these instances can add up to a lot of disk usage.

## Remediation

Disable the Keep Instance option and/or delete the instances that are no longer necessary for troubleshooting.

---

## [troubleshooting/errors/WARN_APP_AS_RECIPE_TOO_MANY_INSTANCES]

# WARN_APP_AS_RECIPE_TOO_MANY_INSTANCES: Application-As-Recipe instance has orphan instances

When the Keep Instance option is enabled for a given Application-As-Recipe, everytime the recipe is run, the instance is kept for troubleshooting purposes. These instances are not automatically deleted when the Application-As-Recipe is deleted and use disk space unnecessarily.

## Remediation

Delete the orphan instances mentioned in the warning message. A link for each instance is provided in the warning message to facilitate the deletion.

---

## [troubleshooting/errors/WARN_CLUSTERS_NONE_SELECTED_GLOBAL]

# WARN_CLUSTERS_NONE_SELECTED_GLOBAL: No default cluster selected

Clusters are available in your instance but there is no global default cluster selected. Each project needs to select one explicitly.

## Remediation

Set a global default cluster in your instance’s settings. See [Using the cluster](<../../containers/managed-k8s-clusters.html#managed-clusters-use-cluster>) for more details.

---

## [troubleshooting/errors/WARN_CLUSTERS_NONE_SELECTED_PROJECT]

# WARN_CLUSTERS_NONE_SELECTED_PROJECT: No cluster selected in project

Clusters are available but none is selected in your project. Cluster execution will likely fail.

## Remediation

Either select a cluster in your project’s settings, or set a global default cluster in your instance and use DSS global cluster settings in your project. See [Using the cluster](<../../containers/managed-k8s-clusters.html#managed-clusters-use-cluster>) for more details.

---

## [troubleshooting/errors/WARN_CONNECTION_DATABRICKS_NO_AUTOFASTWRITE]

# WARN_CONNECTION_DATABRICKS_NO_AUTOFASTWRITE: automatic fast-write disabled

The Databricks connection could leverage automatic fast-write given EC2 and Azure cloud storage connections are available.

## Remediation

Add the cloud storage connection as auto fast write connection to the Databricks connection.

---

## [troubleshooting/errors/WARN_CONNECTION_HDFS_ACL_SUBDIRECTORY]

# WARN_CONNECTION_HDFS_ACL_SUBDIRECTORY: subdirectory ACL synchronization mode

ACL synchronization mode is set to ‘subdirectory’ in the connection. It is recommended to use Sentry or Ranger instead.

## Remediation

Use Sentry or Ranger instead. See [Support for Hive authorization modes](<../../hadoop/hive.html#hive-authorization-modes>) for more details.

---

## [troubleshooting/errors/WARN_CONNECTION_NO_HADOOP_INTERFACE]

# WARN_CONNECTION_NO_HADOOP_INTERFACE: no Hadoop interface set

No Hadoop interface is set on the cloud storage connection.

## Remediation

Select a Hadoop interface in the settings of the cloud storage connection.

---

## [troubleshooting/errors/WARN_CONNECTION_SNOWFLAKE_NO_AUTOFASTWRITE]

# WARN_CONNECTION_SNOWFLAKE_NO_AUTOFASTWRITE: automatic fast-write disabled

The Snowflake connection could leverage automatic fast-write given cloud storage connections are available.

## Remediation

Add the cloud storage connection as auto fast write connection to the Snowflake connection. See [Writing data into Snowflake](<../../connecting/snowflake.html#connecting-sql-snowflake-writing>) for more details.

---

## [troubleshooting/errors/WARN_CONNECTION_SPARK_NO_GROUP_WITH_DETAILS_READ_ACCESS]

# WARN_CONNECTION_SPARK_NO_GROUP_WITH_DETAILS_READ_ACCESS: no groups allowed to read connection details

Spark is enabled but no user groups have been granted permission to read the connection’s details. Spark interaction may be slow.

## Remediation

Grant “Details readable by” on the connection to the user groups using Spark. See [Reading details of a connection](<../../security/connections.html#connections-read-details>) for more details.

---

## [troubleshooting/errors/WARN_FOLDER_CONNECTION_TYPE_ERROR]

# WARN_FOLDER_CONNECTION_TYPE_ERROR: Invalid connection linked to a managed folder

The connection linked to a managed folder is invalid. Either it is missing or its type is invalid.

## Remediation

The first step for solving this issue is to go to the settings screen for the affected managed folder.

  * Refer to the [documentation on Managed folders](<../../connecting/managed_folders.html>) in order to get additional information on managed folders

  * Make sure that the folder’s settings are correct

---

## [troubleshooting/errors/WARN_GIT_EXCLUDES_FILE_NOT_SET]

# WARN_GIT_EXCLUDES_FILE_NOT_SET: Projects - Git excludesFile not set correctly

Some Git projects in your Dataiku instance do not have the core.excludesFile option correctly configured in their Git settings. This setting ensures that project-specific directory, such as .dss-meta, are excluded from version control.

## Remediation

To avoid accidental commits of internal files, ensure that each Git repository is configured with the following:
    
    
    [core]
    excludesFile = $DSS_HOME/config/.dku-projects-gitignore
    

This file should also contain .dss-meta as an ignored pattern.

---

## [troubleshooting/errors/WARN_GIT_NO_UNCOMMITTED_CHANGES]

# WARN_GIT_NO_UNCOMMITTED_CHANGES: Projects - Uncommitted Git changes

Some projects in your Dataiku instance have uncommitted changes in their Git repository, even though they are configured in **Auto** commit mode. This situation is not expected and may indicate an internal issue or an edge case during project activity.

These uncommitted changes can lead to inconsistencies when switching branches or during collaborative work.

## Remediation

Open the affected project(s) in Dataiku and go to the **Version Control** page:

  * Click on the **Force Commit** button to review the uncommitted changes.

  * If the changes are valid, commit them using the dialog.




There is currently no way to discard uncommitted changes from the UI.

---

## [troubleshooting/errors/WARN_GIT_PROJECT_NOT_MIGRATED]

# WARN_GIT_PROJECT_NOT_MIGRATED: Projects - Unmigrated Git branches

Some projects in your Dataiku instance contain local Git branches that were last migrated using an older DSS version. These branches may not be compatible with the current version of DSS and could lead to unexpected behavior when switching or working on them.

## Remediation

Review the affected projects and their branches. For each branch listed:

  * Open the project in Dataiku.

  * Go to the **Version Control** page (this is also where you can check out branches).

  * Check out the listed branch.

  * Follow the migration prompt that appears to upgrade the branch to the current DSS version.




If the branch is no longer needed, you can delete it instead to reduce maintenance and avoid confusion.

---

## [troubleshooting/errors/WARN_GIT_VERSION_TOO_OLD]

# WARN_GIT_VERSION_TOO_OLD: Git - Installed Git version is too old

Some Git operations in your Dataiku instance may not work optimally because the installed Git version is older than recommended.

## Remediation

To ensure the best experience when working with Git in DSS, update Git to at least version 2.28 (or a more recent stable release) on your system.

You can check your current Git version by running:
    
    
    git --version

---

## [troubleshooting/errors/WARN_JOBS_MAX_OVER_MAX_ACTIVITIES]

# WARN_JOBS_MAX_OVER_MAX_ACTIVITIES: Jobs - Max jobs is over max activities

The max number of jobs is over the max number of activities and will be limited by the later value.

## Remediation

The maximum number of jobs can be used to limit the number of running JEKs. Each job uses one or more activities. Therefore, to apply, the maximum number of jobs must be lower than the maximum number of activities.

---

## [troubleshooting/errors/WARN_JOBS_MAX_TOO_HIGH]

# WARN_JOBS_MAX_TOO_HIGH: Jobs - Max value too high

The max number of jobs seems too high. This may reduce performance if too many jobs run concurrently and if the instance is not correctly sized.

## Remediation

To improve global performance, size the number of jobs according to how many can run concurrently on the instance (depending on the RAM and CPU available). This may require some testing to have a good value.

---

## [troubleshooting/errors/WARN_JOBS_NO_LIMIT]

# WARN_JOBS_NO_LIMIT: Jobs - No limits set

There is no limit in the number of jobs. This may reduce performance if too many jobs run concurrently and if the instance is not correctly sized.

## Remediation

To improve global performance, size the number of jobs according to how many can run concurrently on the instance (depending on the RAM and CPU available). This may require some testing to have a good value.

---

## [troubleshooting/errors/WARN_JVM_CONFIG_KERNEL_XMX_OVER_THRESHOLD]

# WARN_JVM_CONFIG_KERNEL_XMX_OVER_THRESHOLD: Xmx value for kernel over threshold

If the maximum heap size (Xmx option) value for either kernel (JEK or FEK) is too big, it can lead to potential memory exhaustion on the machine. This is because the allocated memory is multiplied by the number of JEKs and FEKs. Therefore, it is advisable for users to avoid setting an excessively large Xmx value for these kernels to prevent memory-related issues.

## Remediation

Modify the fek.xmx or jek.xmx option in the $DSS_HOME/install.ini file so it doesn’t exceed 4g. See [Tuning and controlling memory usage](<../../operations/memory.html>).

---

## [troubleshooting/errors/WARN_JVM_CONFIG_XMX_IN_RED_ZONE]

# WARN_JVM_CONFIG_XMX_IN_RED_ZONE: Sub optimal Xmx value

When configuring the Java Virtual Machine, it is important to consider the maximum heap size (Xmx option). If the maximum heap size is set to a value between 32g and 48g, there is a potential issue with memory usage. When the maximum heap size exceeds 32g, compressed references, which help reduce memory usage, are disabled. This means that larger references are stored in memory, resulting in less available heap memory. If the additional memory allocated does not absorb the extra space taken by the larger references, it can lead to a situation where there is less overall heap memory available for the application to use. It is worth noting that there is no specific threshold at which this issue stops occurring, as it depends on the usage of the memory, but 48g is generally considered high enough to mitigate this problem.

## Remediation

Modify the xmx option in the $DSS_HOME/install.ini file so it doesn’t lie between 32g and 48g. See [Tuning and controlling memory usage](<../../operations/memory.html>).

---

## [troubleshooting/errors/WARN_MISC_AUDIT_NO_LOG4J_LOCAL_TARGET]

# WARN_MISC_AUDIT_NO_LOG4J_LOCAL_TARGET: No Log4j local target

No Log4J target has been set in the instance’s audit settings. Events won’t be recorded in the instance’s logs.

## Remediation

Add a Log4J target in the instance`s audit settings. See [Log4J target](<../../operations/audit-trail/centralization-and-dispatch.html#audit-trail-log4j-target>) for more details.

---

## [troubleshooting/errors/WARN_MISC_BASE_IMAGE_FROM_OLDER_DSS_IMAGE]

# WARN_MISC_BASE_IMAGE_FROM_OLDER_DSS_IMAGE: Custom Base Image was built with an older DSS Version.

Building of Custom Base Images is a manual process and should be repeated every time DSS is upgraded, otherwise they might not be compatible with the new DSS Version.

## Remediation

Rebuild all Custom Base Images that are being used in the Containerized execution settings, using the Base Image from the new DSS Version.

---

## [troubleshooting/errors/WARN_MISC_BASE_IMAGE_NOT_FOUND]

# WARN_MISC_BASE_IMAGE_NOT_FOUND: Custom Base Image not found

For each Containerized execution that is configured to use a Custom Base Image, the image must be reachable by the configured “repository + tag” or “image id”.

## Remediation

Make sure Custom Base Image is correctly configured and that exists in the local or remote repository.

---

## [troubleshooting/errors/WARN_MISC_CODE_ENV_BUILTIN_MODIFIED]

# WARN_MISC_CODE_ENV_BUILTIN_MODIFIED: Built-in code env modified

Packages have been installed manually in the built-in code environment of DSS. The built-in code environment should not be altered.

## Remediation

Remove the manually installed packages from the built-in code environment or reset the built-in environment, then use a custom code environment instead. See [Create a code environment](<../../code-envs/operations-python.html#code-environment-create-codeenv>) for more details.

The built-in environment can be completely reset in a few steps:

  1. Delete the current built-in environment (`<DSS_HOME>/pyenv`)

  2. run `<INSTALL_DIR>/installer.sh -u -d <DSS_HOME>`

---

## [troubleshooting/errors/WARN_MISC_CODE_ENV_DEPRECATED_INTERPRETER]

# WARN_MISC_CODE_ENV_DEPRECATED_INTERPRETER: Deprecated Python interpreter

The code environment use a deprecated Python interpreter.

## Remediation

Update the Python interpreter used by the code environment in the code environment settings.

As for the built-in environment, it can be updated in a few steps:

  1. Delete the current built-in environment (`<DSS_HOME>/pyenv`)

  2. run `<INSTALL_DIR>/installer.sh -u -d <DSS_HOME> -P <Python interpreter>`

---

## [troubleshooting/errors/WARN_MISC_CODE_ENV_IMAGE_OUT_OF_DATE]

# WARN_MISC_CODE_ENV_IMAGE_OUT_OF_DATE: Code Environment images out of date

Code Environment Images are built when Containerized Execution is enabled for a Code Environment. These Code Environment Images are built on top of Base Images (configured in the Containerized Execution Settings). Because Code Environment Images are not automatically rebuilt when the Base Images are rebuilt, it is necessary to trigger this process manually.

## Remediation

Navigate to the affect Code Environment’s Containerized execution settings and click the Update button. This will rebuild all Code Environment Images using the latest Base Images.

---

## [troubleshooting/errors/WARN_MISC_CODE_ENV_USES_PYSPARK]

# WARN_MISC_CODE_ENV_USES_PYSPARK: pyspark installed in a code environment

The package pyspark has been manually installed in a code environment. It is not recommended to install pyspark manually.

## Remediation

Remove pyspark from the list of required packages of the code env.

Note

Please refer to [the documentation](<../../spark/index.html>) to find out how to install and interact with Spark in the recommended way. Running the Spark integration in DSS automatically adds pyspark to code envs.

---

## [troubleshooting/errors/WARN_MISC_DISK_MOUNT_TYPE]

# WARN_MISC_DISK_MOUNT_TYPE: non recommended filesystem type

The filesystem type is not recommended. We strongly recommend using XFS or ext4.

## Remediation

Please refer to [Requirements](<../../installation/custom/requirements.html>) for more details.

---

## [troubleshooting/errors/WARN_MISC_DISK_NOEXEC_FLAG]

# WARN_MISC_DISK_NOEXEC_FLAG: noexec flag

The noexec flag has been set on the /tmp partition. It may cause issues, especially with code environments.

## Remediation

Please refer to [Compatibility of DSS with CIS Benchmark Level 1 on RHEL / CentOS / AlmaLinux / Rocky Linux / Oracle Linux](<../../security/redhat-cis-level1-compatibility.html>) for more details.

---

## [troubleshooting/errors/WARN_MISC_DISK_ROTATIONAL]

# WARN_MISC_DISK_ROTATIONAL: Rotational hard drives

The hard drive is a rotational hard drive, performance will be impacted. It is highly recommended to run DSS on SSD drives.

Note

Virtualization (such as RAID) may show a rotational hard drive while the underlying drive is a SSD.

## Remediation

Use SSD drives. Please refer to [this page](<../../installation/custom/requirements.html#requirements-disks>) for more details.

---

## [troubleshooting/errors/WARN_MISC_ENVVAR_SPECIAL_CHAR]

# WARN_MISC_ENVVAR_SPECIAL_CHAR: Environment variables with special characters

Some of the environment variables in your DSS instance do not adhere to Kubernetes restrictions and will therefore not be propagated to containerized jobs. For Kubernetes, a valid environment variable name must consist of alphabetic characters, digits, `_`, `-`, or `.`, and must not start with a digit. The regular expression used for validation is `[-._a-zA-Z][-._a-zA-Z0-9]*`.

## Remediation

If you need these environment variables to be propagated to containerized jobs, you must rename them to match the validation pattern used by Kubernetes.

---

## [troubleshooting/errors/WARN_MISC_EVENT_SERVER_NO_TARGET]

# WARN_MISC_EVENT_SERVER_NO_TARGET: No target

The event server is enabled but no destination has been configured. All received events will be dropped.

## Remediation

Add destinations in your event server configuration. See [Configuration of the event server](<../../operations/audit-trail/eventserver.html#event-server-configuration>) for more details.

---

## [troubleshooting/errors/WARN_MISC_JDBC_JARS_CONFLICT]

# WARN_MISC_JDBC_JARS_CONFLICT: JDBC drivers - some JARs are prone to version conflicts

When multiple JDBC drivers are present in the same directory, conflicts can arise due to naming conflicts and version incompatibilities. This can result in unexpected behavior, such as errors or incorrect query results.

## Remediation

To avoid conflicts with these JDBC drivers, it is recommended to isolate them in separate directories. Make sure to edit the JDBC connection settings in Dataiku to point to the correct driver.

---

## [troubleshooting/errors/WARN_MISC_LARGE_INTERNAL_DB]

# WARN_MISC_LARGE_INTERNAL_DB: internal runtime database is too large

The internal runtime database exceeds the recommended size of 5GB. This threshold can be modified with the dku.sanitycheck.runtimedb.internal_db_threshold_gb dip property.

## Remediation

It is recommended to switch to external runtime database by following [these instructions](<../../operations/runtime-databases.html#runtime-db-external>).

---

## [troubleshooting/errors/WARN_PROJECT_LARGE_JOB_HISTORY]

# WARN_PROJECT_LARGE_JOB_HISTORY: Projects - Too old or too many job logs

There are projects in your Dataiku instance that have too many job logs (more than 1000) or that have job logs that are too old (60+ days-old). This can cause performance issues and fills up your disk space.

## Remediation

Manually delete the job logs or run the **Clear job logs** macro.

---

## [troubleshooting/errors/WARN_PROJECT_LARGE_SCENARIO_HISTORY]

# WARN_PROJECT_LARGE_SCENARIO_HISTORY: Projects - Too old or too many scenario run logs

There are projects in your Dataiku instance that have too many scenario runs logs (more than 1000) or that have scenario runs logs that are too old (60+ days-old). This can cause performance issues and fills up your disk space.

## Remediation

Manually delete the scenario runs logs or run the **Clear scenario runs logs** macro.

---

## [troubleshooting/errors/WARN_PROJECT_LARGE_STREAMING_HISTORY]

# WARN_PROJECT_LARGE_STREAMING_HISTORY: Projects - Too old or too many continuous activities logs

There are projects in your Dataiku instance that have too many continuous activities logs (more than 1000) or that have continuous activities logs that are too old (60+ days-old). This can cause performance issues and fills up your disk space.

## Remediation

Manually delete the continuous activities logs or run the **Clear continuous activities logs** macro.

---

## [troubleshooting/errors/WARN_RECIPE_SPARK_INDIRECT_HDFS]

# WARN_RECIPE_SPARK_INDIRECT_HDFS: No direct access to read/write HDFS dataset

You are running a recipe that uses Spark (either a Spark code recipe, or a visual recipe using the Spark engine). This recipe either reads or writes a HDFS dataset.

However, your administrator has not granted you the “Read connection details” permission on the connection in which the HDFS dataset lies.

Without this permission, your Spark job will not be able to read (or write) the HDFS dataset directly, and will indeed need to go through a slow path. This will very strongly degrade the performance of your Spark job.

## Remediation

Your administrator needs to grant the “Details readable by” permission on the HDFS connection to one of the groups you belong to.

More details on this permission can be found in [Connections security](<../../security/connections.html>)

---

## [troubleshooting/errors/WARN_RECIPE_SPARK_INDIRECT_S3]

# WARN_RECIPE_SPARK_INDIRECT_S3: No direct access to read/write S3 dataset

You are running a recipe that uses Spark (either a Spark code recipe, or a visual recipe using the Spark engine). This recipe either reads or writes a S3 dataset.

However, your administrator has not granted you the “Read connection details” permission on the connection in which the S3 dataset lies.

Without this permission, your Spark job will not be able to read (or write) the S3 dataset directly, and will indeed need to go through a slow path. This will very strongly degrade the performance of your Spark job.

## Remediation

Your administrator needs to grant the “Details readable by” permission on the S3 connection to one of the groups you belong to.

More details on this permission can be found in [Connections security](<../../security/connections.html>)

---

## [troubleshooting/errors/WARN_SECURITY_NO_CGROUPS]

# WARN_SECURITY_NO_CGROUPS: cgroups for resource control are not enabled

Your instance does not use cgroups to restrict resource usage to sub processes.

## Remediation

You can enable cgroups support by following [Using cgroups for resource control](<../../operations/cgroups.html>).

---

## [troubleshooting/errors/WARN_SECURITY_UIF_NOT_ENABLED]

# WARN_SECURITY_UIF_NOT_ENABLED: User Isolation Framework is not enabled

It is recommended to enable User Isolation Framework.

## Remediation

Please refer to [User Isolation](<../../user-isolation/index.html>) for more details.

---

## [troubleshooting/errors/WARN_SPARK_K8S_KILLED_EXECUTORS]

# WARN_SPARK_K8S_KILLED_EXECUTORS: Some Kubernetes executors were killed

When Spark runs on K8S, Spark executors are run in pods in the cluster. These pods are created by Spark with memory requests to the K8S cluster, based on the values passed in the properties `spark.executor.memory` and `spark.kubernetes.memoryOverheadFactor`. But the processes running the Spark executor in the pod can end up requesting more memory than expected from the K8S node, in which case the node will forcefully terminate the pod, and along with it, the Spark executor. This happens sometimes when the memory overhead factor is underestimated, or when the executor spawns subprocesses (for example: Python processes to compute UDFs).

## Remediation

  * increase `spark.kubernetes.memoryOverheadFactor`

  * increase `spark.executor.memory`

---

## [troubleshooting/errors/WARN_SPARK_MISSING_DRIVER_TO_EXECUTOR_CONNECTIVITY]

# WARN_SPARK_MISSING_DRIVER_TO_EXECUTOR_CONNECTIVITY: The Spark driver cannot call into the executors

Spark executors run in containers in the cluster, so on different machines than the Spark driver. While most communication between executors and driver happens in the executor-to-driver direction, some few operations make the Spark driver call the executors directly, mostly when it needs to collect back data on the driver side. Typical cases include usage of `collect()` or `toPandas()` in Pyspark, and joins for which Spark decides to use the “broadcast join” method over the usual shuffle join.

When the driver has to contact the executors directly, it can end up being at odds with the networking setup of the VM it’s running on and/or of the cluster: it is indeed not uncommon to not be able to access the IPs of the pods in the cluster, because of firewall rules for example. The Spark job will then fail with exceptions related to network connections.

## Remediation

  * avoid using `collect()` or `toPandas()`, because they load all the data on the DSS VM and won’t parallelize subsequent workloads

  * ensure that the DSS VM can reach the IPs of the pods. Note that depending on the type of Kubernetes cluster, the range of IPs used by the pods can live outside the main range of IPs of the VPC. For example, in GKE, pods use a secondary IP range

  * if the recipe is a join, or is a Pyspark recipe doing a join, then add the Spark property spark.sql.autoBroadcastJoinThreshold -> -1 to the recipe settings

---

## [troubleshooting/errors/WARN_SPARK_NON_DISTRIBUTED_READ]

# WARN_SPARK_NON_DISTRIBUTED_READ: Input dataset is read in a non-distributed way

Spark’s performance hinges on its ability to parallelize workloads, and to achieve parallelization, Spark needs to be able to distribute the data to process into tasks, then dispatched to workers. Parallelization is ideally done all the way up to the reading of the data to process, because reading typically involves I/O or network activity, and conversion of raw data to Spark’s internal representation (fully or partially). When the reading part cannot be handled by Spark directly, DSS is tasked with reading the data, which is then streamed over the network to a single Spark worker. This implies that there is no parallelization of the reads, and that a single worker has to handle all the I/O and conversion.

## Remediation

  * ensure the types of the input datasets are compatible with distributed reads. Use preferably HDFS or cloud storage (S3, Azure, GCS). Snowflake datasets can be used if the DSS connection has the Spark integration activated. Hive datasets can also be used if the recipe is set to “use global metastore” (see the `Advanced` tab of the recipe)

  * check that the user running the recipe can read the details of the connection of the dataset. This means that at least one of the groups of the user should belong to the groups of the `Details readable by` setting of the connection

  * for file-type datasets, ensure the format is compatible with distributed reads. Use preferable Parquet or ORC. CSV can also be used depending on the CSV settings (typically, using CSV with headers precludes distributed reads)

---

## [troubleshooting/errors/WARN_SPARK_NON_DISTRIBUTED_WRITE]

# WARN_SPARK_NON_DISTRIBUTED_WRITE: Output dataset is written in a non-distributed way

Spark’s performance hinges on its ability to parallelize workloads, and to achieve parallelization, Spark needs to be able to distribute the data to process into tasks, then dispatched to workers. Parallelization is ideally done all the way up to the writing of the data produced, because writing typically involves I/O or network activity, and conversion of raw data from Spark’s internal representation. When the writing part cannot be handled by Spark directly, DSS is tasked with writing the data, which is then streamed over the network from a single Spark worker. This implies that there is no parallelization of the writes, and that a single worker has to handle all the I/O and conversion.

## Remediation

  * ensure the types of the output datasets are compatible with distributed writes. Use preferably HDFS or cloud storage (S3, Azure, GCS). Snowflake datasets can be used if the DSS connection has the Spark integration activated. Hive datasets can also be used if the recipe is set to “use global metastore” (see the `Advanced` tab of the recipe)

  * check that the user running the recipe can read the details of the connection of the dataset. This means that at least one of the groups of the user should belong to the groups of the `Details readable by` setting of the connection

  * for file-type datasets, ensure the format is compatible with distributed writes. Use preferable Parquet or ORC. CSV can also be used depending on the CSV settings (typically, using CSV with headers precludes distributed writes)

---

## [troubleshooting/errors/WARN_SPARK_TASK_DISKFULL]

# WARN_SPARK_TASK_DISKFULL: Some Spark tasks encountered disk space issues

Spark executors of Spark-over-Kuberenetes setups run in pods in the clusters, and pods get as `/tmp` a portion of the actual cluster node’s disk, which implies that the size of `/tmp` in the pods is constrained by the node’s disk size, and the usage that other pods of the same node make of their `/tmp`.

Since Spark spills data on disk when data doesn’t fit in memory anymore, and since Spark can run subprocesses that also take disk space, like Python UDFs, this `/tmp` can be overused, and in such cases either the processes in the pod will crash because they cannot get the disk space they need, or the Kubernetes cluster itself will notice the excessive usage of disk space and forcefully terminate the pod, thus killing the task in the Spark job. This is not necessarily a non-recoverable error for Spark, and Spark will attempt a task that failed several times before completely giving up on the job.

## Remediation

  * reduce the number of tasks each executor handles concurrently, by setting `spark.executor.cores` to 1

  * split the workload of Spark executors by increasing parallelism. This can mean for example repartitioning the input data, or increasing `spark.sql.shuffle.partitions`

  * provision nodes with larger disks for the Kubernetes cluster

---

## [troubleshooting/errors/WARN_SPARK_TASK_OOM]

# WARN_SPARK_TASK_OOM: Some Spark tasks encountered out of memory

Spark executors run in containers (in Yarn or Kubernetes), wich impose constraints on the memory of the processes running in them. A task dispatched by Spark to one of its executors can make the executor trip over the limit enforced by the container, in which case the container will be forcefully terminated by its manager, thus killing the task in the Spark job. This is not necessarily a non-recoverable error for Spark, and Spark will attempt a task that failed several times before completely giving up on the job.

## Remediation

  * ensure the memory overhead property for the relevant Spark master is set to a meaningful value. For Yarn this is `spark.executor.memoryOverhead` (value in MB), for K8S this is `spark.kubernetes.memoryOverheadFactor` (value in fraction of `spark.executor.memory`)

  * ensure the `spark.executor.memory` is set to a meaningful value (at least 2g)

  * increase the value for the memory overhead property and/or the memory property

---

## [troubleshooting/errors/WARN_SPARK_UDFS_MAY_BE_BROKEN]

# WARN_SPARK_UDFS_MAY_BE_BROKEN: Python UDFs may fail

Pyspark serializes UDFs (user defined functions) from the Spark driver, typically running locally on the DSS VM in some code env, then transfers them in their serialized form to the Spark executors, where they’re deserialized and run. Use of Python serialization entails that the python process doing the deserialization must have the exact same packages as the one doing the serialization (as well as the same Python version). If the packages of the code environment on the executor side differ, deserialization may fail, or the python code may fail at runtime.

## Remediation

  * go to the code environment used by the recipe in `Administration`

  * ensure that the Spark config used by the recipe is among the Spark configs in the `Containerized execution` tab of the code environment

  * `Update` the code environment to force a rebuild of the images

---

## [troubleshooting/errors/WARN_SPARK_WITH_DATABRICKS_DATASET]

# WARN_SPARK_WITH_DATABRICKS_DATASET: Not leveraging Databricks compute

You have selected a SparkSQL recipe or the Spark engine to execute a job on a Databricks dataset(s). This will not place the workload of the job in the Databricks cluster, but will instead put it wherever the Spark configuration points, for example “locally” on the DSS server or in your Kubernetes cluster.

Since the Databricks connection is a SQL connection, selecting a SQL recipe or the SQL engine will put the workload of the job in the Databricks cluster to leverage your Databricks compute resources.

## Remediation

When available, use a SQL recipe, or the SQL engine if in a visual recipe, when working with Databricks datasets.

---

## [troubleshooting/errors/index]

# Error codes

Below are the error codes that you may encounter while using DSS.

---

## [troubleshooting/errors/undocumented-error]

# Undocumented error

This error does not have a specific documentation.

Please refer to the [troubleshooting documentation](<../index.html>) for next steps

---

## [troubleshooting/index]

# Troubleshooting

---

## [troubleshooting/obtaining-support]

# Obtaining support

If you encounter issues for which you can’t get an explanation by reading through the error documentation and [Diagnosing and debugging issues](<diagnosing.html>), or have a question, you may need to obtain support.

## Academy

The [Dataiku Academy](<https://academy.dataiku.com/>) is the place to go to first learn about DSS concepts.

## Community Answers

We maintain a [public community](<https://community.dataiku.com/>) where you can browse for existing answers, or ask your own question.

## Live chat

Depending on your DSS license, you may have access to our live chat directly in DSS. Live chat is also available on Dataiku website.

## Editor support (for Dataiku Cloud customers specifically)

If you are a [Dataiku Cloud](<https://www.dataiku.com/product/dataiku-as-a-managed-service/>) customer that is using a **hosted** instance, there is a native built-in support window that you can access from your platform directly. For more details, please refer to our [How to obtain support on Dataiku Cloud](<https://knowledge.dataiku.com/latest/cloud-space-management/support/index.html>) Knowledge Base articles.

## Editor support (for all other Dataiku customers)

If you are a Dataiku customer that is using your own infrastructure or currently running an evaluation, you may contact Dataiku support, either by:

  * Going to [the support portal](<http://support.dataiku.com>)

  * Sending a mail to support -at- dataiku -dot- com.




### Guidelines for submitting a support ticket

Describe your issue. Include screenshots if it appears to be a front-end issue.

  1. Where did the issue happen?

  2. If something had previously been working, what did you recently change?

  3. Try to describe the set of steps you took that resulted in the error or issue you now see. Try to be precise!

  4. Let us know what you have already tried to do to fix the problem on your own, following the instructions on [Diagnosing and debugging issues](<diagnosing.html>). Include any job or instance diagnosis files, as appropriate.

  5. Specify the appropriate and correct priority (please refer to the following section).




### Defining the priority of a support ticket

We generally aim to be responsive with all support tickets. However, when opening a support ticket, please use the following criteria to specify the appropriate priority to help ensure that it is classified correctly:

  * **P1/Urgent** \- Reserved for ONLY the most critical “system is down” situations where DSS is **completely inoperative** and/or your production environment is unusable. This can be a condition that is severely and significantly impacting the Design, Automation, and API nodes where no procedural workaround exists.

  * **P2/High** \- Reserved for serious or high-impact business conditions related to DSS that are severely affecting a substantial number of users and where no procedural workaround exists.

  * **P3/Medium** \- A medium to low-impact issue in DSS that can involve partial but non-critical functionality loss. Alternatively, this may also be a minor issue with limited or no loss of functionality or impact in your environment for which a workaround is available. _This should be the default priority selected for most issues and questions._

  * **P4/Low** \- DSS is functional and there is no material impact on the quality, performance, or functionality of your environment. Relates only to proposed feature enhancements, proposed modifications, or other requests (such as documentation, usage help, etc.)

---

## [troubleshooting/problems/cannot-connect-sql]

# Cannot connect to a SQL database

Driver, link..

---

## [troubleshooting/problems/cannot-login]

# Cannot login to DSS

There are different cases when you have trouble logging in to your DSS instance

## You are using the Dataiku Cloud Trial

ie: you didn’t install anything and are connecting to a URL that ends with `.i.cloud.dataiku.com`

You should have received credentials by email. If your credentials don’t work, it can be caused by:

  * You are trying to use IE or Edge to connect. These browsers are not supported by DSS and login will not work. Please use Chrome or Firefox. In case it’s needed, [Portable Firefox](<http://portableapps.com/apps/internet/firefox_portable>) can be run without installation

  * The CapsLock key is enabled

  * A change of keyboard layout (e.g. azerty/qwerty),

  * A spurious space at the beginning or end of the login or password (be extra-careful when copy-pasting the password from the invitation email, or try to type it manually).




If none of this works or you have not received your credentials, please [contact us](<../obtaining-support.html>)

## You are using DSS Free Edition

You are faced with the DSS login screen

This screen prompts you to login to DSS, using your DSS account. By default, the credentials for this account are:

  * login: **admin**

  * password: **admin**




You can change the password in the account settings. You need this account, for instance, each time you clear your cookies, change browser, or restart DSS.

(For the Enterprise Edition of DSS, which allows collaborative features, there are several DSS accounts: one per user.)

If your credentials don’t work, see the section below for suggestions.

## You are using DSS Enterprise Edition

Users of the Enterprise Edition have only one account, created by the DSS administrator. She should provide you with a username and password. If your credentials don’t work, see the section below for suggestions.

## Your credentials don’t work

If your credentials don’t work, it can be caused by:

  * You are trying to use IE or Edge to connect. These browsers are not supported by DSS and login will not work. Please use Chrome or Firefox. In case it’s needed, [Portable Firefox](<http://portableapps.com/apps/internet/firefox_portable>) can be run without installation

  * The CapsLock key is enabled

  * A change of keyboard layout (e.g. azerty/qwerty),

  * A spurious space at the beginning or end of the login or password




If none of this works or you have not received your credentials, your DSS administrator (which may be you) needs to reset the password for this account

## Resetting a forgotten DSS password

Note

This procedure is only valid if you are using a local login. If you are using SSO or LDAP login, you need to reset your SSO or LDAP password.

### If you still have access to DSS

Login as a DSS administrator, then go to Administration > Security > Users. Select the user to edit, enter a new password and save it.

### If you have lost all access to DSS

This can happen if you have the lost the password for the sole admin account (which is the case by default, when you install DSS, there is a single admin account called **admin**).

To reset a DSS local password, you need to have have command-line access to the server, for instance through SSH. DSS must be running.

Reset the password with the following commands:
    
    
    cd DATA_DIR
    ./bin/dsscli user-edit --password NEW_PASSWORD LOGIN
    

Where:

  * `DATA_DIR` is the path to your Dataiku data directory

  * `LOGIN` is the username whose password needs to be reset

  * `NEW_PASSWORD` is the new password.

---

## [troubleshooting/problems/crashes]

# DSS crashes / The “Disconnected” overlay appears

This problem can present the following symptoms:

  * During normal work, the “Disconnected” overlay suddenly appears, and disappears after a few dozens of seconds

  * While DSS was running properly, trying to connect now yields a “Gateway error” issue




This generally indicates that the “backend” process of DSS has crashed. When this happens, the “supervisord” process automatically restarts the backend, and it is back up after 20-60 seconds depending on the size of your instance.

---

## [troubleshooting/problems/does-not-start]

# DSS does not start / Cannot connect

When DSS fails to properly start, the following symptoms can happen:

  * `dss start` fails

  * `dss status` indicates that some processes are not started

  * “Could not connect to DSS server” banner when trying to connect using a browser (HTTP code: 502, type: Gateway error)

  * “Connection refused” error when trying to connect using a browser




Note

If you are using the Dataiku virtual machine, please see [The dedicated documentation](<../../installation/other/vm.html>) for troubleshooting instructions.

## Check processes state

The first step is to check the state of the DSS process:

  * Go to the DSS data directory

  * Run

> ./bin/dss status
>         




If all processes are indicated as RUNNING, proceed to the next step

If a process is not in RUNNING state, first try to restart DSS:
    
    
    ./bin/dss restart
    

If it does not help, and some processes are still failing, see “Diagnose process failures” below.

If all processes are now RUNNING and you still get errors when connecting, proceed to the next step

## Verify local connectivity

From the DSS machine, run
    
    
    curl http://127.0.0.1:DSS_PORT/
    

If you don’t see HTML code, and the `nginx` process is correctly running, you might have a local firewall issue

Then run:
    
    
    curl http://127.0.0.1:DSS_PORT/dip/api/get-configuration
    

If you don’t see a JSON result, check the status and logs of the `backend` process

If both of these tests are successful but you can’t connect from your browser, it indicates a network connectivity issue between DSS and your browser. Check for firewalls and proxies along the way. Try with another browser or another workstation if applicable.

## DSS start (or stop) fails

It can happen that running `./bin/dss start` fails

### Server port already in use

Before starting, DSS checks that all TCP ports required are free. DSS requires up to 10 consecutive TCP ports, starting from the base port set at install time. Check that this whole range is available.

This error can also indicate that some stray DSS processes are still running, but are not controlled anymore by the DSS supervisor. See “Kill all DSS processes” below.

### Server requires authentication

If you receive this message, it generally indicates that you ran the DSS installer or a dssadmin command while DSS was still running. It won’t be possible to stop DSS normally. See “Kill all DSS processes” below.

## Kill all DSS processes

If some stray DSS processes are still running, you’ll need to kill them.

Run `ps -u $USER -f` to identify all processes running as the DSS service account, and use `kill -9 PID` to kill all DSS processes:

  * Java processes

  * Python processes

  * nginx processes




## Diagnose process failures

check which process is failing, and check the `run/PROCESS.log` file, where `PROCESS` is the name of the failing process.

In particular, if the `backend` process is failing, check `run/backend.log` for errors.

Common issues that can prevent DSS from starting include:

  * Out of disk space (“No space left on device”) on the DSS data directory

  * Permissions issues (all files must belong to the DSS service account)




Also see [Diagnosing and debugging issues](<../diagnosing.html>) and [Obtaining support](<../obtaining-support.html>).

---

## [troubleshooting/problems/index]

# Common issues

This section lists some common issues encountered in DSS and associated solutions and tips.

---

## [troubleshooting/problems/job-fails]

# A job fails

When a job fails, go to the page of the failed job. This page gives a lot of information about why jobs did not succeed.

## Source dataset is not ready

If this error appears, it means that one of the source datasets required for running this job was not usable, which can mean:

  * For a database dataset, it was not possible to connect to the database

  * For a SQL dataset, the source SQL table did not exist (or could not be accessed)

  * For a filesystem (or HDFS, S3, Azure Blob, FTP, …) dataset, the input data file or folder did not exist




The error message contains the name of the dataset having issues (as well as the partition, in the case of partitioned dataset). Explore this dataset, and fix the issues with the source data.

## Dataset is already being built

One of the datasets (including intermediate datasets) that needed to be built is already being built by another job which is currently running.

Wait for this other job to complete and retry.

## One of the recipes failed

If you see the two-columns layout, with recipes on the left, and logs on the right, and one of the recipes is in “failed” state, click on it to see the logs of the recipe. Read carefully both the error message and the logs, which generally contain information about the cause of the failure.

In particular, in the case of code recipes, if your code failed, the error message will often be pretty generic like “Code failed, check the logs”. You need to peruse through the log files to find the original failure in your code (it will generally be highlighted red).

## Getting a job diagnosis

When you encounter a job failure and can’t find a reason in the error details or log files, Dataiku Support will ask you to provide a _Job diagnosis_

The job diagnosis is a Zip file that contains a lot of information about the job and some information about the current DSS instance, configuration information, system information, environment data, …

To generate a job diagnosis:

  * Go to the page of the affected job (whether the job failed or not)

  * Click on Actions > Download job diagnosis

  * This will download the job diagnosis to your local machine, that you can then send to Dataiku Support




Note that Dataiku Support does not accept files larger than 15 MB. If your job diagnosis Zip is bigger than that, you can use a file transfer service to get the diagnosis to us. We recommend using _WeTransfer_ , but any similar service (or internal service provided by your IT) can work.

---

## [troubleshooting/problems/ml-train-fails]

# A ML model training fails

When the training of a machine learning fails, go to the page of the failed model. The error message is displayed.

Depending on the cases, the error message itself can contain enough information to understand the issue, or you may need to get the logs, which you can access by clicking the “Read the logs” link.

## MemoryError (In-memory training only)

A common error is the “MemoryError” which indicates that the Python process running the training encountered an out of memory situation, due to exhaustion of the machine’s memory.

For machine learning, a preprocessing is applied to your input dataset, which can strongly increase the memory size required compared to the original size of the data.

For example, with “dummy-encoding” processing, a single categorical column can be transformed to hundreds of numerical columns. To know how many columns were created as part of the preprocessing, you can check in the logs for the “shape” messages in the logs.

To reduce memory requirements, you can:

  * Reduce the dataset sample used for machine learning

  * Reduce the maximum number of columns created by dummy-encoding

  * Switch dummy-encoding to impact-encoding (which creates a single output column)

  * For text features, avoid using “Hashing” if the algorithm doesn’t support sparse inputs (you get a warning in that case)




## Process died (killed - maybe out of memory)

The process that was running the machine learning was killed, either by a system administrator or the kernel. A common cause is that the machine’s memory was exhausted.

When using Python training, please see above for tips on managing memory usage.

---

## [troubleshooting/problems/no-class-def-found]

# Receiving “java.lang.NoClassDefFoundError”

There are a couple of common situations that can result in seeing a `java.lang.NoClassDefFoundError` or `class not initialized` error message in the UI. Here are some common reasons and resolutions.

## Receiving “java.lang.NoClassDefFoundError: org/apache/hadoop/”

If you receive an error that has a reference to `org/apache/hadoop`, this usually means that the Hadoop integration has not been run. Some examples of what this type of error looks like are:

  * `java.lang.NoClassDefFoundError: org/apache/hadoop/conf/Configuration`

  * `java.lang.NoClassDefFoundError: org/apache/hadoop/mapred/JobConf`




### Resolution

If you are receiving an error that falls into this category, you will need to go through the steps listed under [Setting up DSS Hadoop integration](<../../hadoop/installation.html#hadoop-integration>).

Please note that if you use standalone libraries for Hadoop, the integration must be re-run after upgrading DSS. This means that if you ran `DATADIR/bin/dssadmin install-hadoop-integration` in the past, but are receiving an error like this, the integration likely needs to be re-run after upgrading.

If you do not have a Hadoop cluster but are managing Parquet files, you will also need to run the Hadoop integration. In this situation, you can download the `dataiku-dss-hadoop-standalone-libs-generic-hadoop3` binary from your usual Dataiku DSS download site, and then run the standalone hadoop integration:
    
    
    ./DATADIR/bin/dssadmin install-hadoop-integration -standalone generic-hadoop3 -standaloneArchive /PATH/TO/dataiku-dss-hadoop3-standalone-libs-generic...tar.gz
    

## Receiving java.lang.NoClassDefFoundError for operations that previously did not throw an error

If you are receiving a `java.lang.NoClassDefFoundError` while performing normal actions (i.e. exploring datasets) and do not see any reference to hadoop in the error message, you may have inadvertently upgraded Java while DSS was running.

### Resolution

To prevent this, Java should not be updated while DSS is running. If it was, DSS needs to be restarted in order to resolve this error. As the `dssuser`, restart DSS:
    
    
    ./DATADIR/bin/dss restart
    

If you want to point to a specific version of Java, please follow the instructions to [Switching the JVM](<../../installation/custom/advanced-java-customization.html#java-custom-jre>).

---

## [troubleshooting/problems/scenario-fails]

# A scenario fails

When a scenario fails, go to the page of the failed scenario runs. This page gives a lot of information about why scenarios did not succeed.

## One “build” step failed

The most common issue with scenario is that one of the “build” or “train” steps failed. In that case, please see [A job fails](<job-fails.html>).

## Getting a scenario diagnosis

Note

If the scenario failure is caused by the failure of one of the underlying jobs, please be sure to also get a job diagnosis for this particular job.

See [A job fails](<job-fails.html>) for more information on getting job diagnosis.

When you encounter a scenario failure and can’t find a reason in the error details or log files, Dataiku Support will ask you to provide a _Scenario diagnosis_

The scenario diagnosis is a Zip file that contains a lot of information about the scenario and some information about the current DSS instance, configuration information, system information, environment data, …

To generate a scenario diagnosis:

  * Go to the page of the affected scenario run (whether the scenario failed or not)

  * Click on “Download scenario diagnosis”

  * This will download the scenario diagnosis to your local machine, that you can then send to Dataiku Support




Note that Dataiku Support does not accept files larger than 15 MB. If your scenario diagnosis Zip is bigger than that, you can use a file transfer service to get the diagnosis to us. We recommend using _WeTransfer_ , but any similar service (or internal service provided by your IT) can work.

---

## [troubleshooting/problems/tls-error]

# The server selected protocol version TLS10 is not accepted by client preferences [TLS12]

You may encounter this error or a similar error when attempting to connect to a dataset:
    
    
    Connection failed: The driver could not establish a secure connection to SQL Server by using Secure Sockets Layer (SSL) encryption.
    Error: "The server selected protocol version TLS10 is not accepted by client preferences [TLS12]".
    

This error can occur when connecting to a database that does not have TLS 1.2 enabled. As of April 2021, OpenJDK disabled TLS 1.0 and TLS 1.1 by default. If you recently encountered this error, it might be due to a recent Java upgrade on your database server.

Note that TLS 1.0 has been [officially deprecated](<https://datatracker.ietf.org/doc/rfc8996/>) and you can read more about this change and the reasons for it in this [blog post](<https://aws.amazon.com/blogs/opensource/tls-1-0-1-1-changes-in-openjdk-and-amazon-corretto/>).

## Resolution

In order to resolve this, your database administrator should enable TLS 1.2 on your database server host. See more information on TLS 1.2 support for [SQL Server](<https://support.microsoft.com/en-us/topic/kb3135244-tls-1-2-support-for-microsoft-sql-server-e4472ef8-90a9-13c1-e4d8-44aad198cdbe>) and [MySQL](<https://dev.mysql.com/doc/refman/8.0/en/encrypted-connection-protocols-ciphers.html>).

---

## [troubleshooting/problems/user-profile-issues]

# “Your user profile does not allow” issues

Each user in DSS has a single “user profile” assigned to it. This user profile is a licensing-related concept that may restrict what actions the user may do.

In particular, some user profiles may not use coding recipes, notebooks or Visual Machine Learning.

Please see [User profiles](<../../security/user-profiles.html>) for more information about user profiles.

If you get a “Your user profile does not allow …” error, this action has been denied because of your user profile. Your user profile needs to be switched to a higher one.

Generally, the “Data Scientist” user profile has all rights in DSS.

If a user has no profile associated with it, the user will automatically default to a “Reader” profile. This means that the user won’t be able to perform any kind of modification, regardless of user group status. If that’s the case, go through the same steps outlined below to set the desired user profile.

## If you are a DSS administrator

  * Go to Administration > Security > Users

  * Select the user

  * Change the User profile to the desired value

  * Save




After the user profile has been changed, the user (which can be you) must reload the DSS tab in his browser for the change to be taken into account.

## If you are not a DSS administrator

Ask your DSS administrator to change your user profile. Once it has been done, reload the DSS tab in your browser for the change to be taken into account.

---

## [troubleshooting/problems/websockets]

# Websockets problems

## I am seeing the “Could not establish WebSocket connection” message

Data Science Studio uses a web technology called “Websockets” to provide a more dynamic user experience. In some setups, Websockets cannot work and you see this message.

### Causes

The most common cause of Websocket error is when you connect to DSS through a proxy. Websockets is a fairly recent protocol and many enterprise proxies do not support it. The websocket connection will not establish and you will see this message.

Note that using a reverse proxy in front of DSS can also lead to this behaviour. Please refer to our [reverse proxy configuration page](<../../installation/custom/reverse-proxy.html>) for details.

If you are not in any of these cases, please [contact Dataiku support](<http://support.dataiku.com>).

### Consequences

If your setup does not allow Websockets to work, the following features of DSS will not work :

  * The whole Python / R notebook. You will not be able to load, execute, export or convert to recipe any Python / R notebook

  * Dynamic notifications (connections, disconnections, end of job, comments, exports, …)

  * Some lists refresh when new events happen (end of training a model bench, …)

  * Editor’s conflict detection

  * Achievements




### Remedies

If you can, please ensure that your connection to DSS is not done through a proxy. Generally, connections within a company do not require a proxy.

Another possibility is to use DSS on HTTPS. Proxies generally do not filter SSL connections and Websockets will work correctly. Please refer to the [installation guide](<../../installation/custom/advanced-customization.html#config-https>) for help on setting up DSS on HTTPS.

---

## [troubleshooting/support-tiers]

# Support tiers

Various features and capabilities of Dataiku DSS are not covered by the same level of support.

## Supported (default)

Unless mentioned otherwise, Dataiku DSS features and capabilities are covered by Dataiku Editor Support (for Dataiku customers) and are subject to the service level agreements mentioned in your support contract.

Dataiku strives to provide workarounds or fixes for all issues in scope, for features that benefit from full support.

## Experimental

A number of features and capabilities are marked as “Experimental” and do not benefit from full support

Experimental means that Dataiku will make best efforts to solve issues that you may encounter with the feature. However, Dataiku may elect to consider issues as requests for future enhancements with no special priority.

Features or capabilities that are Experimental are explicitly marked as such in the documentation.

Some plugins may benefit from “Experimental” (the default for plugins is “Not supported”).

Dataiku may elect to upgrade a feature from Experimental to fully supported at any time. Dataiku may also elect to deprecate them, with the usual deprecation warning time frames (see below).

## Tier 2 support

A number of features and capabilities do not benefit from full support and instead benefit from “Tier 2” support.

Tier 2 support means that Dataiku will make best efforts to solve issues that you may encounter with the feature. However, Dataiku may elect to consider issues as requests for future enhancements with no special priority.

Features or capabilities that are covered by Tier 2 support are explicitly marked as such in the documentation.

There are several reasons for which Dataiku may choose to mark a particular feature or capability as Tier 2 support:

  * The feature relies heavily on 3rd party solutions on which we do not feel we can adequately provide full support

  * The feature depends on 3rd party infrastructure to which Dataiku does not have appropriate access in order to guarantee the high level of quality we strive to maintain for fully supported features.

  * The feature is highly exotic or sees very little usage




Some plugins may benefit from “Tier 2 support” (the default for plugins is “Not supported”).

Dataiku may elect to upgrade a feature from Tier 2 support to fully supported at any time. Dataiku may also elect to deprecate them, with the usual deprecation warning time frames (see below).

## Not supported

Some features and capabilities are marked as “Not supported”.

This means that Dataiku Support is unfortunately not able to provide support on these particular capabilities.

Features or capabilities that are “Not supported” are explicitly marked as such in the documentation.

All plugins are by default “Not supported”, unless marked otherwise.

Dataiku may elect to upgrade a feature from “Not supported” to a higher tier at any time.

## Public Preview

A number of features and capabilities are marked as “Public Preview” and do not benefit from full support

Public Preview means that Dataiku is still actively working on the feature. We will make best efforts to solve issues that you may encounter with the feature. However, Dataiku may elect to consider issues as requests for future enhancements with no special priority.

Features or capabilities that are Public Preview are explicitly marked as such in the documentation.

Features in Public Preview are usually designed to move to fully supported in the future. Dataiku may elect to upgrade a feature from Public Preview to fully supported at any time. However, it is possible that some Public Preview features will not move to fully supported. The feature may change significantly between Public Preview and fully supported.

## Deprecated

Deprecated features are features that are scheduled for removal in a future Dataiku DSS release.

Deprecated features are still supported to their previous support tier, but we strongly advise you to migrate away from them, as they will stop being maintained in the near future.

Features or capabilities that are “Deprecated” are explicitly marked as such in the documentation.

Deprecations are always announced through our [Release notes](<../release_notes/index.html>).