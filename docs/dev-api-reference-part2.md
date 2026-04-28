# Dataiku Docs — dev-api-reference

## [api-reference/python/other-administration]

# Other administration tasks

_class _dataikuapi.dss.admin.DSSGeneralSettings(_client_)
    

The general settings of the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_general_settings()`](<client.html#dataikuapi.DSSClient.get_general_settings> "dataikuapi.DSSClient.get_general_settings") instead.

save()
    

Save the changes that were made to the settings on the DSS instance

Note

This call requires an API key with admin rights

get_raw()
    

Get the settings as a dictionary

Returns:
    

the settings

Return type:
    

dict

add_impersonation_rule(_rule_ , _is_user_rule =True_)
    

Add a rule to the impersonation settings

Parameters:
    

  * **rule** (_object_) – an impersonation rule, either a `dataikuapi.dss.admin.DSSUserImpersonationRule` or a `dataikuapi.dss.admin.DSSGroupImpersonationRule`, or a plain dict

  * **is_user_rule** (_boolean_) – when the rule parameter is a dict, whether the rule is for users or groups




get_impersonation_rules(_dss_user =None_, _dss_group =None_, _unix_user =None_, _hadoop_user =None_, _project_key =None_, _scope =None_, _rule_type =None_, _is_user =None_, _rule_from =None_)
    

Retrieve the user or group impersonation rules that match the parameters

Parameters:
    

  * **dss_user** (_string_) – a DSS user name

  * **dss_group** (_string_) – a DSS group name

  * **rule_from** (_string_) – a regex (which will be applied to user or group names)

  * **unix_user** (_string_) – a name to match the target UNIX user

  * **hadoop_user** (_string_) – a name to match the target Hadoop user

  * **project_key** (_string_) – a project key

  * **scope** (_string_) – project-scoped (‘PROJECT’) or global (‘GLOBAL’)

  * **type** (_string_) – the rule user or group matching method (‘IDENTITY’, ‘SINGLE_MAPPING’, ‘REGEXP_RULE’)

  * **is_user** (_boolean_) – True if only user-level rules should be considered, False for only group-level rules, None to consider both




remove_impersonation_rules(_dss_user =None_, _dss_group =None_, _unix_user =None_, _hadoop_user =None_, _project_key =None_, _scope =None_, _rule_type =None_, _is_user =None_, _rule_from =None_)
    

Remove the user or group impersonation rules that matches the parameters from the settings

Parameters:
    

  * **dss_user** (_string_) – a DSS user name

  * **dss_group** (_string_) – a DSS group name

  * **rule_from** (_string_) – a regex (which will be applied to user or group names)

  * **unix_user** (_string_) – a name to match the target UNIX user

  * **hadoop_user** (_string_) – a name to match the target Hadoop user

  * **project_key** (_string_) – a project key

  * **scope** (_string_) – project-scoped (‘PROJECT’) or global (‘GLOBAL’)

  * **type** (_string_) – the rule user or group matching method (‘IDENTITY’, ‘SINGLE_MAPPING’, ‘REGEXP_RULE’)

  * **is_user** (_boolean_) – True if only user-level rules should be considered, False for only group-level rules, None to consider both




push_container_exec_base_images()
    

Push the container exec base images to their repository

_class _dataikuapi.dss.admin.DSSUserImpersonationRule(_raw =None_)
    

An user-level rule items for the impersonation settings

scope_global()
    

Make the rule apply to all projects

scope_project(_project_key_)
    

Make the rule apply to a given project

Parameters:
    

**project_key** (_string_) – the project this rule applies to

user_identity()
    

Make the rule map each DSS user to a UNIX user of the same name

user_single(_dss_user_ , _unix_user_ , _hadoop_user =None_)
    

Make the rule map a given DSS user to a given UNIX user

Parameters:
    

  * **dss_user** (_string_) – a DSS user

  * **unix_user** (_string_) – a UNIX user

  * **hadoop_user** (_string_) – a hadoop user (optional, defaults to unix_user)




user_regexp(_regexp_ , _unix_user_ , _hadoop_user =None_)
    

Make the rule map a DSS users matching a given regular expression to a given UNIX user

Parameters:
    

  * **regexp** (_string_) – a regular expression to match DSS user names

  * **unix_user** (_string_) – a UNIX user

  * **hadoop_user** (_string_) – a hadoop user (optional, defaults to unix_user)




_class _dataikuapi.dss.admin.DSSGroupImpersonationRule(_raw =None_)
    

A group-level rule items for the impersonation settings

group_identity()
    

Make the rule map each DSS user to a UNIX user of the same name

group_single(_dss_group_ , _unix_user_ , _hadoop_user =None_)
    

Make the rule map a given DSS user to a given UNIX user

Parameters:
    

  * **dss_group** (_string_) – a DSS group

  * **unix_user** (_string_) – a UNIX user

  * **hadoop_user** (_string_) – a hadoop user (optional, defaults to unix_user)




group_regexp(_regexp_ , _unix_user_ , _hadoop_user =None_)
    

Make the rule map a DSS users matching a given regular expression to a given UNIX user

Parameters:
    

  * **regexp** (_string_) – a regular expression to match DSS groups

  * **unix_user** (_string_) – a UNIX user

  * **hadoop_user** (_string_) – a hadoop user (optional, defaults to unix_user)




_class _dataikuapi.dss.admin.DSSInstanceVariables(_client_ , _variables_)
    

Dict containing the instance variables.

The variables can be modified directly in the dict and persisted using its `save()` method.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_global_variables()`](<client.html#dataikuapi.DSSClient.get_global_variables> "dataikuapi.DSSClient.get_global_variables") instead.

save()
    

Save the changes made to the instance variables.

Note

This call requires an API key with admin rights.

_class _dataikuapi.dss.future.DSSFuture(_client_ , _job_id_ , _state=None_ , _result_wrapper= <function DSSFuture.<lambda>>_)
    

A future represents a long-running task on a DSS instance. It allows you to track the state of the task, retrieve its result when it is ready or abort it.

Usage example:
    
    
    # In this example, 'folder' is a DSSManagedFolder
    future = folder.compute_metrics()
    
    # Waits until the metrics are computed
    metrics = future.wait_for_result()
    

Note

This class does not need to be instantiated directly. A `dataikuapi.dss.future.DSSFuture` is usually returned by the API calls that are initiating long running-tasks.

_static _from_resp(_client_ , _resp_ , _result_wrapper= <function DSSFuture.<lambda>>_)
    

Creates a `dataikuapi.dss.future.DSSFuture` from the response of an endpoint that initiated a long-running task.

Parameters:
    

  * **client** ([`dataikuapi.dssclient.DSSClient`](<client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient")) – An api client to connect to the DSS backend

  * **resp** (_dict_) – The response of the API call that initiated a long-running task.

  * **result_wrapper** (_callable_) – (optional) a function to apply to the result of the future, before it is returned by get_result or wait_for_result methods.



Returns:
    

`dataikuapi.dss.future.DSSFuture`

abort()
    

Aborts the long-running task.

get_state()
    

Queries the state of the future, and fetches the result if it’s ready.

Returns:
    

the state of the future, including the result if it is ready.

Return type:
    

dict

peek_state()
    

Queries the state of the future, without fetching the result.

Returns:
    

the state of the future

Return type:
    

dict

get_result()
    

Returns the future’s result if it’s ready.

Note

if a custom result_wrapper was provided, it will be applied on the result that will be returned.

Returns:
    

the result of the future

Return type:
    

object

Raises:
    

**Exception** – if the result is not ready (i.e. the task is still running, or it has failed)

has_result()
    

Checks whether the task is completed successfully and has a result.

Returns:
    

True if the task has successfully returned a result, False otherwise

Return type:
    

bool

wait_for_result()
    

Waits for the completion of the long-running task, and returns its result.

Note

if a custom result_wrapper was provided, it will be applied on the result that will be returned.

Returns:
    

the result of the future

Return type:
    

object

Raises:
    

**Exception** – if the task failed

_class _dataikuapi.dss.future.DSSFutureWithHistory(_client_ , _name_ , _result_wrapper= <function DSSFutureWithHistory.<lambda>>_)
    

A future with history item represents a long-running task on a DSS instance that can be tracked by several clients. It allows you to track the state of the task, retrieve its result when it is ready or abort it.

Usage example:
    
    
    # In this example, 'agent_review' is a DSSAgentReview
    future_with_history = agent_review.perform_run()
    
    # Waits until the computation of the run is finished
    run_result = future.wait_for_result()
    

Note

This class does not need to be instantiated directly. A `dataikuapi.dss.future.DSSFutureWithHistory` is returned by some API calls that are initiating long running-tasks and allow access to the result to multiple requested

abort()
    

Aborts the long-running task.

get_state()
    

Queries the state of the future with history.

Returns:
    

the state of the future with history.

Return type:
    

dict

has_result()
    

Checks whether the task is completed successfully and has a result.

Returns:
    

True if the task has successfully returned a result, False otherwise

Return type:
    

bool

wait_for_result()
    

Waits for the completion of the long-running task, and returns its result.

Note

if a custom result_wrapper was provided, it will be applied on the result that will be returned.

Returns:
    

the result of the future

Return type:
    

object

Raises:
    

**Exception** – if the task failed or was not found

_class _dataikuapi.dss.jupyternotebook.DSSJupyterNotebook(_client_ , _project_key_ , _notebook_name_)
    

A handle on a Python/R/scala notebook.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.get_jupyter_notebook()`](<projects.html#dataikuapi.dss.project.DSSProject.get_jupyter_notebook> "dataikuapi.dss.project.DSSProject.get_jupyter_notebook") or [`dataikuapi.dss.project.DSSProject.create_jupyter_notebook()`](<projects.html#dataikuapi.dss.project.DSSProject.create_jupyter_notebook> "dataikuapi.dss.project.DSSProject.create_jupyter_notebook").

unload(_session_id =None_)
    

Stop this Jupyter notebook and release its resources.

get_sessions(_as_objects =False_)
    

Get the list of running sessions of this Jupyter notebook.

Usage example:
    
    
    # list the running notebooks in a project
    for notebook in project.list_jupyter_notebooks(as_type="object"):
        if len(notebook.get_sessions()) > 0:
            print("Notebook %s is running" % notebook.notebook_name)
    

Parameters:
    

**as_objects** (_boolean_) – if True, each returned item will be a `dataikuapi.dss.jupyternotebook.DSSNotebookSession`

Returns:
    

a list of `dataikuapi.dss.jupyternotebook.DSSNotebookSession` if **as_objects** is True, a list of dict otherwise. The dict holds information about the kernels currently running the notebook, notably a **sessionId** for the Jupyter session id, and a **kernelId** for the Jupyter kernel id.

Return type:
    

list

get_content()
    

Get the full contents of this Jupyter notebook.

The content comprises metadata, cells, notebook format info.

Usage example:
    
    
    # collect all the source code of a notebook
    lines = []
    for cell in notebook.get_content().get_cells():
        if cell["cell_type"] != 'code':
            continue
        lines = lines + cell["source"]
    print('\n'.join(lines))
    

Return type:
    

`dataikuapi.dss.jupyternotebook.DSSNotebookContent`

delete()
    

Delete this Jupyter notebook and stop all of its active sessions.

clear_outputs()
    

Clear this Jupyter notebook’s outputs.

get_object_discussions()
    

Get a handle to manage discussions on the notebook.

Returns:
    

the handle to manage discussions

Return type:
    

[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")

_class _dataikuapi.dss.jupyternotebook.DSSJupyterNotebookListItem(_client_ , _data_)
    

An item in a list of Jupyter notebooks.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.list_jupyter_notebooks()`](<projects.html#dataikuapi.dss.project.DSSProject.list_jupyter_notebooks> "dataikuapi.dss.project.DSSProject.list_jupyter_notebooks")

to_notebook()
    

Get a handle on the corresponding notebook

Return type:
    

`DSSJupyterNotebook`

_property _name
    

Get the name of the notebook.

Used as identifier.

_property _language
    

Get the language of the notebook.

Possible values are ‘python’, ‘R’, ‘toree’ (scala)

Return type:
    

string

_property _kernel_spec
    

Get the raw kernel spec of the notebook.

The kernel spec is internal data for Jupyter, that identifies the kernel.

Returns:
    

the Jupyter spec of a Jupyter kernel. Top-level fields are:

  * **name** : identifier of the kernel in Jupyter, for example ‘python2’ or ‘python3’

  * **display_name** : name of the kernel as shown in the Jupyter UI

  * **language** : language of the notebook (informative field)




Return type:
    

dict

_class _dataikuapi.dss.jupyternotebook.DSSNotebookSession(_client_ , _session_)
    

Metadata associated to the session of a Jupyter Notebook.

Important

Do not instantiate directly, use `dataikuapi.dss.jupyternotebook.DSSJupyterNotebook.get_sessions()`

unload()
    

Stop this Jupyter notebook and release its resources.

_class _dataikuapi.dss.jupyternotebook.DSSNotebookContent(_client_ , _project_key_ , _notebook_name_ , _content_)
    

The content of a Jupyter Notebook.

This is the actual notebook data, see the [nbformat doc](<https://nbformat.readthedocs.io/en/latest/>) .

Important

Do not instantiate directly, use `dataikuapi.dss.jupyternotebook.DSSJupyterNotebook.get_content()`

get_raw()
    

Get the raw content of this Jupyter notebook.

The content comprises metadata, cells, notebook format info.

Returns:
    

a dict containing the full content of a notebook. Notable fields are:

  * **metadata** : the metadata of the notebook, as a dict (see `get_metadata()`)

  * **nbformat** and **nbformat_minor** : the version of the notebook format

  * **cells** : list of cells, each one a dict (see `get_cells()`)




Return type:
    

dict

get_metadata()
    

Get the metadata associated to this Jupyter notebook.

Returns:
    

the Jupyter metadata of the notebook, with fields:

  * **kernelspec** : identification of the kernel used to run the notebook

  * **creator** : name of the user that created the notebook

  * **createdOn** : timestamp of creation, in milliseconds

  * **modifiedBy** : name of last modifier

  * **language_info** : information on the language of the notebook




Return type:
    

dict

get_cells()
    

Get the cells of this Jupyter notebook.

Returns:
    

a list of cells, as defined by Jupyter. Each cell is a dict, with notable fields:

  * **cell_type** : type of cell, for example ‘code’

  * **metadata** : notebook metadata in the cell

  * **executionCount** : index of the last run of this cell

  * **source** : content of the cell, as a list of string

  * **output** : list of outputs of the last run of the cell, as a list of dict with fields **output_type** , **name** and **text**. Exact contents and meaning depend on the cell type.




Return type:
    

list[dict]

save()
    

Save the content of this Jupyter notebook.

_class _dataikuapi.dss.sqlnotebook.DSSSQLNotebook(_client_ , _project_key_ , _notebook_id_)
    

A handle on a SQL notebook

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.get_sql_notebook()`](<projects.html#dataikuapi.dss.project.DSSProject.get_sql_notebook> "dataikuapi.dss.project.DSSProject.get_sql_notebook") or [`dataikuapi.dss.project.DSSProject.create_sql_notebook()`](<projects.html#dataikuapi.dss.project.DSSProject.create_sql_notebook> "dataikuapi.dss.project.DSSProject.create_sql_notebook")

get_content()
    

Get the full content of this SQL notebook

The content comprises cells

Usage example:
    
    
    # collect all the SQL source code of a notebook
    lines = []
    for cell in notebook.get_content().cells:
        lines = lines + cell["code"]
    print('\n'.join(lines))
    

Return type:
    

`dataikuapi.dss.sqlnotebook.DSSNotebookContent`

get_history()
    

Get the history of this SQL notebook

Return type:
    

`dataikuapi.dss.sqlnotebook.DSSNotebookHistory`

clear_history(_cell_id =None_, _num_runs_to_retain =0_)
    

Clear the history of this SQL notebook

Parameters:
    

  * **cell_id** (_string_) – The cell id for which to clear the history. Leave unspecified to clear the history for all cells of this notebook

  * **num_runs_to_retain** (_int_) – The number of the most recent runs to retain for each cell (defaults to **0**)




delete()
    

Delete this SQL notebook

get_object_discussions()
    

Get a handle to manage discussions on the notebook

Returns:
    

The handle to manage discussions

Return type:
    

[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")

_class _dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem(_client_ , _data_)
    

An item in a list of SQL notebooks

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.list_sql_notebooks()`](<projects.html#dataikuapi.dss.project.DSSProject.list_sql_notebooks> "dataikuapi.dss.project.DSSProject.list_sql_notebooks")

to_notebook()
    

Get a handle on the corresponding notebook

Return type:
    

`DSSSQLNotebook`

_property _id
    

Get the id of the notebook

Used as identifier

_property _language
    

Get the language of the notebook

Possible values are ‘SQL’, ‘HIVE’, ‘IMPALA’, ‘SPARKSQL’

Return type:
    

string

_property _connection
    

Get the connection of the notebook

Return type:
    

string

_class _dataikuapi.dss.sqlnotebook.DSSNotebookContent(_client_ , _project_key_ , _notebook_id_ , _content_)
    

The content of a SQL notebook

Important

Do not instantiate directly, use `dataikuapi.dss.sqlnotebook.DSSSQLNotebook.get_content()`

get_raw()
    

Get the raw content of this SQL notebook

The content comprises cells

Returns:
    

A dict containing the full content of a notebook. Notable fields are:

  * **cells** : list of cells, each one is a dict (see `cells`)




Return type:
    

dict

_property _connection
    

Get the connection of this SQL notebook

Return type:
    

string

_property _cells
    

Get the cells of this SQL notebook

Returns:
    

A list of cells. Each cell is a dict, with notable fields:

  * **id** : id of the cell

  * **type** : deprecated, type of the cell. Only “QUERY” is supported.

  * **name** : name of the cell

  * **code** : content of the cell




Return type:
    

list[dict]

save()
    

Save the content of this SQL notebook

_class _dataikuapi.dss.sqlnotebook.DSSNotebookHistory(_client_ , _project_key_ , _notebook_id_ , _history_)
    

The history of a SQL notebook

Important

Do not instantiate directly, use `dataikuapi.dss.sqlnotebook.DSSSQLNotebook.get_history()`

get_query_runs(_cell_id_ , _as_type ='listitems'_)
    

Get the query runs of a cell in this SQL notebook

Usage example:
    
    
    # delete query runs which failed
    for query_run in notebook_history.get_query_runs(cell_id):
        if query_run.get_raw()["state"] == "FAILED":
            query_run.delete()
    notebook_history.save()
    

Parameters:
    

  * **cell_id** (_string_) – The cell id for which to retrieve the query runs

  * **as_type** (_string_) – How to return the list. Currently the only supported (and default) value is “listitems”



Returns:
    

The list of query runs

Return type:
    

List of `DSSNotebookQueryRunListItem`

save()
    

Save the history of this SQL notebook

_class _dataikuapi.dss.sqlnotebook.DSSNotebookQueryRunListItem(_query_runs_ , _query_run_)
    

An item in a list of query runs of a SQL notebook

Important

Do not instantiate directly, use `dataikuapi.dss.sqlnotebook.DSSNotebookHistory.get_query_runs()`

get_raw()
    

Get the raw query run list item

Returns:
    

A dict containing the query run list item data. Notable fields are:

  * **runOn** : timestamp of the query run

  * **runBy** : user login of the query run

  * **state** : state of the query run, for example “DONE” or “FAILED”

  * **sql** : SQL code of the query run, with variables unexpanded

  * **expandedSql** : SQL code of the query run, with variables expanded




Return type:
    

dict

delete()
    

Delete the query run

Note

The history must be then saved using `dataikuapi.dss.sqlnotebook.DSSNotebookHistory.save()`

_class _dataikuapi.dss.notebook.DSSNotebook(_client_ , _project_key_ , _notebook_name_ , _state =None_)
    

A Python/R/Scala notebook on the DSS instance.

Attention

Deprecated. Use `dataikuapi.dss.jupyternotebook.DSSJupyterNotebook`

unload(_session_id =None_)
    

Stop this Jupyter notebook and release its resources.

Attention

Deprecated. Use `dataikuapi.dss.jupyternotebook.DSSJupyterNotebook`

get_state()
    

Get the metadata associated to this Jupyter notebook.

Attention

Deprecated. Use `dataikuapi.dss.jupyternotebook.DSSJupyterNotebook`

get_sessions()
    

Get the list of running sessions of this Jupyter notebook.

Attention

Deprecated. Use `dataikuapi.dss.jupyternotebook.DSSJupyterNotebook`

get_object_discussions()
    

Get a handle to manage discussions on the notebook.

Attention

Deprecated. Use `dataikuapi.dss.jupyternotebook.DSSJupyterNotebook`

Returns:
    

the handle to manage discussions

Return type:
    

[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")

_class _dataikuapi.dss.admin.DSSGlobalApiKey(_client_ , _key_ , _id__)
    

A global API key on the DSS instance

delete()
    

Delete the api key

Note

This call requires an API key with admin rights

get_definition()
    

Get the API key’s definition

Note

This call requires an API key with admin rights

Note

If the secure API keys feature is enabled, the secret key of this API key will not be present in the returned dict

Returns:
    

the API key definition

Return type:
    

:class:DSSGlobalApiKeyDefinition

set_definition(_definition_)
    

Set the API key’s definition

Note

This call requires an API key with admin rights

Important

You should only `set_definition()` using a dict that you obtained through `get_definition()`, not create a new dict. You may not use this method to update the ‘key’ field.

Usage example
    
    
    # add a group to an API key
    key = client.get_global_api_key_by_id("my_api_key_id")
    definition = key.get_definition()
    definition["groups"].append("new_group_name")
    key.set_definition(definition)
    

Parameters:
    

**definition** (_dict_) – the definition for the API key

_class _dataikuapi.dss.admin.DSSGlobalApiKeyListItem(_client_ , _data_)
    

An item in a list of global API keys.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.list_global_api_keys()`](<client.html#dataikuapi.DSSClient.list_global_api_keys> "dataikuapi.DSSClient.list_global_api_keys") instead.

to_global_api_key()
    

Gets a handle corresponding to this item

Return type:
    

`DSSGlobalApiKey`

_property _id
    

Get the identifier of the API key

Return type:
    

string

_property _user_for_impersonation
    

Get the user associated to the API key

Return type:
    

string

_property _key
    

Get the API key

If the secure API keys feature is enabled, this key field will not be available

Return type:
    

string

_property _label
    

Get the label of the API key

Return type:
    

string

_property _description
    

Get the description of the API key

Return type:
    

string

_property _created_on
    

Get the timestamp of when the API key was created

Return type:
    

`datetime.datetime`

_property _created_by
    

Get the login of the user who created the API key

Return type:
    

string

_property _groups
    

Get the groups this API key belongs to

Return type:
    

list or None if this key is not using group-based permissions

_class _dataikuapi.dss.admin.DSSGlobalUsageSummary(_data_)
    

The summary of the usage of the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_global_usage_summary()`](<client.html#dataikuapi.DSSClient.get_global_usage_summary> "dataikuapi.DSSClient.get_global_usage_summary") instead.

_property _raw
    

Get the usage summary structure

The summary report has top-level fields per object type, like **projectSummaries** or **datasets** , each containing counts, usually a **all** global count, then several **XXXXByType** dict with counts by object sub-type (for example, for datasets the sub-type would be the type of the connection they’re using)

Return type:
    

dict

_property _projects_count
    

Get the number of projects on the instance

Return type:
    

int

_property _total_datasets_count
    

Get the number of datasets on the instance

Return type:
    

int

_property _total_recipes_count
    

Get the number of recipes on the instance

Return type:
    

int

_property _total_jupyter_notebooks_count
    

Get the number of code nobteooks on the instance

Return type:
    

int

_property _total_sql_notebooks_count
    

Get the number of sql notebooks on the instance

Return type:
    

int

_property _total_scenarios_count
    

Get the number of scenarios on the instance

Return type:
    

int

_property _total_active_with_trigger_scenarios_count
    

Get the number of active scenarios on the instance

Return type:
    

int

_class _dataikuapi.dss.admin.DSSPersonalApiKey(_client_ , _key_ , _id__)
    

A personal API key on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_personal_api_key()`](<client.html#dataikuapi.DSSClient.get_personal_api_key> "dataikuapi.DSSClient.get_personal_api_key") instead.

get_definition()
    

Get the API key’s definition

Returns:
    

the personal API key definition, as a dict. The login of the user of this personal key is in a **user** field.

Return type:
    

dict

set_definition(_definition_)
    

Set the API key’s definition

Note

Only the label and description of the key can be updated.

Important

You should only `set_definition()` using an object that you obtained through `get_definition()`, not create a new dict. You may not use this method to update the ‘key’ field.

Usage example
    
    
    # update an API key label
    key = client.get_personal_api_key('my_api_key_id')
    definition = key.get_definition()
    definition["label"] = "My New Label"
    key.set_definition(definition)
    

Parameters:
    

**definition** (_dict_) – the definition for the API key

delete()
    

Delete the API key

_class _dataikuapi.dss.admin.DSSPersonalApiKeyListItem(_client_ , _data_)
    

An item in a list of personal API key.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.list_personal_api_keys()`](<client.html#dataikuapi.DSSClient.list_personal_api_keys> "dataikuapi.DSSClient.list_personal_api_keys") or [`dataikuapi.DSSClient.list_all_personal_api_keys()`](<client.html#dataikuapi.DSSClient.list_all_personal_api_keys> "dataikuapi.DSSClient.list_all_personal_api_keys") instead.

to_personal_api_key()
    

Gets a handle corresponding to this item

Return type:
    

`DSSPersonalApiKey`

_property _id
    

Get the identifier of the API key

Return type:
    

string

_property _user
    

Get the user associated to the API key

Return type:
    

string

_property _key
    

Get the API key

If the secure API keys feature is enabled, this key field will not be available

Return type:
    

string

_property _label
    

Get the label of the API key

Return type:
    

string

_property _description
    

Get the description of the API key

Return type:
    

string

_property _created_on
    

Get the timestamp of when the API key was created

Return type:
    

`datetime.datetime`

_property _created_by
    

Get the login of the user who created the API key

Return type:
    

string

---

## [api-reference/python/plugin-components/custom_datasets]

# API for plugin datasets

_class _dataiku.connector.Connector(_config_ , _plugin_config =None_)
    

The base interface for a Custom Python connector

get_read_schema()
    

Returns the schema that this connector generates when returning rows.

The returned schema may be None if the schema is not known in advance. In that case, the dataset schema will be infered from the first rows.

Additional columns returned by the generate_rows are discarded if and only if connector.json contains “strictSchema”:true

The schema must be a dict, with a single key: “columns”, containing an array of `{'name':name, 'type' : type}`.

Example:
    

return {“columns” : [ {“name”: “col1”, “type” : “string”}, {“name” :”col2”, “type” : “float”}]}

Supported types are: string, int, bigint, float, double, date, boolean

generate_rows(_dataset_schema =None_, _dataset_partitioning =None_, _partition_id =None_, _records_limit =-1_)
    

The main reading method.

Returns a generator over the rows of the dataset (or partition) Each yielded row must be a dictionary, indexed by column name.

The dataset schema and partitioning are given for information purpose.

Example:
    
    
    from apiLibrary import apiClient
    # Connect to API service.
    client = apiClient()
    # Get a list of JSON objects, where each element corresponds to row in dataset.
    data = client.get_data()
    
    for datum in data:
        yield {
            "col1" : datum["api_json_key1"],
            "col2" : datum["api_json_key2"]
        }
    

get_writer(_dataset_schema =None_, _dataset_partitioning =None_, _partition_id =None_, _write_mode ='OVERWRITE'_)
    

Returns a write object to write in the dataset (or in a partition)

The dataset_schema given here will match the the rows passed in to the writer.

write_mode can either be OVERWRITE or APPEND. It will not be APPEND unless the plugin specifically supports append mode. See flag supportAppend in connector metadata.

Note

the writer is responsible for clearing the partition, if relevant

get_partitioning()
    

Return the partitioning schema that the connector defines.

Example:
    
    
     return {
        "dimensions": [{
                "name" : "date",  # Name of column to partition on.
                "type" : "time",
                "params" : {"period" : "DAY"}
        }]
    }
    

list_partitions(_partitioning_)
    

Return the list of partitions for the partitioning scheme passed as parameter

partition_exists(_partitioning_ , _partition_id_)
    

Return whether the partition passed as parameter exists

Implementation is only required if the corresponding flag is set to True in the connector definition

get_records_count(_partitioning =None_, _partition_id =None_)
    

Returns the count of records for the dataset (or a partition).

Implementation is only required if the corresponding flag is set to True in the connector definition

get_connector_resource()
    

You may create a folder DATA_DIR/plugins/dev/<plugin id>/resource/ to hold resources useful fo your plugin, e.g. data files; this method returns the path of this folder.

This resource folder is meant to be read-only, and included in the .zip release of your plugin. Do not put resources next to the connector.py or recipe.py.

_class _dataiku.connector.CustomDatasetWriter
    

write_row(_row_)
    

Row is a tuple with N + 1 elements matching the schema passed to get_writer. The last element is a dict of columns not found in the schema

close()

---

## [api-reference/python/plugin-components/custom_formats]

# API for plugin formats

_class _dataiku.customformat.Formatter(_config_ , _plugin_config_)
    

Custom formatter

get_output_formatter(_stream_ , _schema_)
    

Return a OutputFormatter for this format

Parameters:
    

  * **stream** – the stream to write the formatted data to

  * **schema** – the schema of the rows that will be formatted (never None)




get_format_extractor(_stream_ , _schema =None_)
    

Return a FormatExtractor for this format

Parameters:
    

  * **stream** – the stream to read the formatted data from

  * **schema** – the schema of the rows that will be extracted. None when the extractor is used to detect the format.




_class _dataiku.customformat.OutputFormatter(_stream_)
    

Writes a stream of rows to a stream in a format. The calls will be:

  * write_header()

  * write_row(row_1) …

  * write_row(row_N)

  * write_footer()




write_header()
    

Write the header of the format (if any)

write_row(_row_)
    

Write a row in the format

Parameters:
    

**row** – array of strings, with one value per column in the schema

write_footer()
    

Write the footer of the format (if any)

_class _dataiku.customformat.FormatExtractor(_stream_)
    

Reads a stream in a format to a stream of rows

read_schema()
    

Get the schema of the data in the stream, if the schema can be known upfront.

Returns:
    

the list of columns as [{‘name’:’col1’, ‘type’:’col1type’},…]

read_row()
    

Read one row from the formatted stream

Returns:
    

a dict of the data (name, value), or None if reading is finished

---

## [api-reference/python/plugin-components/custom_fsproviders]

# API for plugin FS providers

_class _dataiku.fsprovider.FSProvider(_root_ , _config_ , _plugin_config_)
    

The base interface for a Custom FS provider

Parameters:
    

  * **root** – the root path for this provider

  * **config** – the dict of the configuration of the object

  * **plugin_config** – contains the plugin settings




close()
    

Perform any necessary cleanup

stat(_path_)
    

Get the info about the object at the given path

Parameters:
    

**path** – where the object to inspect is located

Returns:
    

a dict with the fields:

>   * ’path’ : the location of the object (relative to the root this instance was created with)
> 
>   * ’isDirectory’ : True if the object is a folder
> 
>   * ’size’ : size of the object in bytes, 0 for folders
> 
>   * ’lastModified’ : modification time in ms since epoch, -1 if not defined
> 
> 


If there is no object at the given location, return None

set_last_modified(_path_ , _last_modified_)
    

Change the modification time of an object.

Parameters:
    

  * **path** – where the object to modify is located.

  * **last_modidied** – timestamp as ms since epoch



Returns:
    

True if the change was done, False if not or if the operation is not supported

browse(_path_)
    

Enumerate files non-recursively from a path

Parameters:
    

**path** – what to enumerate

Returns:
    

a dict with the fields:

>   * ’fullPath’ : the path from the root this instance was created with
> 
>   * ’exists’ : True if there is something at path
> 
>   * ’directory’ : True if the path denotes a folder
> 
>   * ’size’ : the size of the file at path; 0 if it’s a folder
> 
> 


If the object at path is a folder, then there should be a ‘children’ attribute which is a list of dicts with the same fields (without a ‘children’ field for subfolders)

enumerate(_prefix_ , _first_non_empty_)
    

Enumerate files recursively from a path.

Parameters:
    

  * **prefix** – where to start the enumeration

  * **first_non_empty** – if first_non_empty, stop at the first non-empty file.



Returns:
    

a list of dicts corresponding to the enumerated files (not folders). Each dict is expected to contain these fields:

>   * ’path’ : the path relative to the root this instance was created with,
> 
>   * ’size’ : size in bytes
> 
>   * ’lastModified’ : modification time in ms since epoch (-1 if not defined)
> 
> 


If there is nothing at the prefix, not even empty folders, return None

delete_recursive(_path_)
    

> Delete recursively

Parameters:
    

**path** – path to the folder or file to remove

move(_from_path_ , _to_path_)
    

Move (rename) an object

Parameters:
    

  * **from_path** – where the data to move is located (relative to the root this instance was created with)

  * **to_path** – the target path for the data




read(_path_ , _stream_ , _limit_)
    

Read data

Parameters:
    

  * **path** – where to read the data (relative to the root this instance was created with)

  * **stream** – a file-like to write the data into

  * **limit** – if not -1, max number of bytes needed. Any more bytes will be discarded by the backend




write(_path_ , _stream_)
    

Write data

Parameters:
    

  * **path** – where to write the data (relative to the root this instance was created with)

  * **stream** – a file-like to read the data from

---

## [api-reference/python/plugin-components/custom_recipes]

# API for plugin recipes

dataiku.customrecipe.get_input_names(_full =True_)
    

dataiku.customrecipe.get_output_names(_full =True_)
    

dataiku.customrecipe.get_input_names_for_role(_role_ , _full =True_)
    

dataiku.customrecipe.get_output_names_for_role(_role_ , _full =True_)
    

dataiku.customrecipe.get_recipe_config()
    

Returns a map of the recipe parameters. Parameters are defined in recipe.json (see inline doc in this file) and set by the user in the recipe page in DSS’ GUI

dataiku.customrecipe.get_plugin_config()
    

Returns the global settings of the plugin

dataiku.customrecipe.get_recipe_resource()
    

See get_connector_resource() in the custom dataset API.

---

## [api-reference/python/plugin-components/index]

# API for plugin components  
  
These are the APIs that must be implemented or used by your custom plugin components

---

## [api-reference/python/plugins]

# Plugins

_class _dataikuapi.dss.plugin.DSSPlugin(_client_ , _plugin_id_)
    

A plugin on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_plugin()`](<client.html#dataikuapi.DSSClient.get_plugin> "dataikuapi.DSSClient.get_plugin")

get_settings()
    

Get the plugin-level settings.

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Returns:
    

a handle on the settings

Return type:
    

`DSSPluginSettings`

get_project_settings(_project_key_)
    

Get the project-level settings.

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Returns:
    

a handle on the project-level settings

Return type:
    

`DSSPluginProjectSettings`

create_code_env(_python_interpreter =None_, _conda =False_)
    

Start the creation of the code env of the plugin.

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


If not passing any value to **python_interpreter** , the default defined by the plugin will be used.

Usage example:
    
    
    # create a default code env for the plugin
    plugin = client.get_plugin('the-plugin-id')
    future = plugin.create_code_env()
    creation = future.wait_for_result()
    # take the name of the new code env
    env_name = creation["envName"]
    # set it as the current plugin code env
    settings = plugin.get_settings()
    settings.set_code_env(env_name)
    settings.save()
    

Parameters:
    

  * **python_interpreter** (_string_) – which version of python to use. Possible values: PYTHON27, PYTHON34, PYTHON35, PYTHON36, PYTHON37, PYTHON38, PYTHON39, PYTHON310, PYTHON311, PYTHON312, PYTHON313, PYTHON314 (experimental)

  * **conda** (_boolean_) – if True use conda to create the code env, if False use virtualenv and pip.



Returns:
    

a handle on the operation

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

update_code_env()
    

Start an update of the code env of the plugin.

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Usage example:
    
    
    # update the plugin code env after updating the plugin
    plugin = client.get_plugin('the-plugin-id')
    future = plugin.update_code_env()
    future.wait_for_result()
    

Returns:
    

a handle on the operation

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

update_from_zip(_fp_)
    

Update the plugin from a plugin archive (as a file object).

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Parameters:
    

**fp** (_file-like_) – A file-like object pointing to a plugin archive zip

start_update_from_zip(_fp_)
    

Update the plugin from a plugin archive (as a file object). Returns immediately with a future representing the process done asynchronously

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Parameters:
    

**fp** (_file-like_) – A file-like object pointing to a plugin archive zip

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the update process

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

update_from_store()
    

Update the plugin from the Dataiku plugin store.

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Usage example:
    
    
    # update a plugin that was installed from the store
    plugin = client.get_plugin("my-plugin-id")
    future = plugin.update_from_store()
    future.wait_for_result()
    

Returns:
    

a handle on the operation

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

update_from_git(_repository_url_ , _checkout ='master'_, _subpath =None_)
    

Updates the plugin from a Git repository.

Note

DSS must be setup to allow access to the repository.

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Usage example:
    
    
    # update a plugin that was installed from git
    plugin = client.get_plugin("my-plugin-id") 
    future = plugin.update_from_git("[[email protected]](</cdn-cgi/l/email-protection>):myorg/myrepo")
    future.wait_for_result()
    

Parameters:
    

  * **repository_url** (_string_) – URL of a Git remote

  * **checkout** (_string_) – branch/tag/SHA1 to commit. For example “master”

  * **subpath** (_string_) – Optional, path within the repository to use as plugin. Should contain a ‘plugin.json’ file



Returns:
    

a handle on the operation

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

list_usages(_project_key =None_)
    

Get the list of usages of the plugin.

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Parameters:
    

**project_key** (_string_) – optional key of project where to look for usages. Default is None and looking in all projects.

Return type:
    

`DSSPluginUsages`

delete(_force =False_)
    

Delete a plugin.

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Parameters:
    

**force** (_boolean_) – if True, plugin will be deleted even if usages are found or errors occurred during usages analysis. Default: False.

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

list_files()
    

Get the hierarchy of files in the plugin.

Note

Dev plugins only

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Returns:
    

list of files or directories, each one a dict. Directories have a **children** field for recursion. Each dict has fields **name** and **path** (the path from the root of the plugin files)

Return type:
    

dict

get_file(_path_)
    

Get a file from the plugin folder.

Note

Dev plugins only

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Usage example:
    
    
    # read the code env desc of a plugin
    plugin = client.get_plugin("my-plugin-name")
    with plugin.get_file('code-env/python/desc.json') as fp:
        desc = json.load(fp)
    

Parameters:
    

**path** (_string_) – the path of the file, relative to the root of the plugin

Returns:
    

the file’s content

Return type:
    

file-like

put_file(_path_ , _f_)
    

Update a file in the plugin folder.

Note

Dev plugins only

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Parameters:
    

  * **f** (_file-like_) – the file contents, as a file-like object

  * **path** (_string_) – the path of the file, relative ot the root of the plugin




rename_file(_path_ , _new_name_)
    

Rename a file/folder in the plugin.

Note

Dev plugins only

Parameters:
    

  * **path** (_string_) – the path of the file/folder, relative ot the root of the plugin

  * **new_name** (_string_) – the new name of the file/folder




move_file(_path_ , _new_path_)
    

Move a file/folder in the plugin.

Note

Dev plugins only

Note

This call requires an API key with either:

>   * DSS admin permissions
> 
>   * permission to develop plugins
> 
>   * tied to a user with admin privileges on the plugin
> 
> 


Parameters:
    

  * **path** (_string_) – the path of the file/folder, relative ot the root of the plugin

  * **new_path** (_string_) – the new path relative at the root of the plugin




_class _dataikuapi.dss.plugin.DSSPluginSettings(_client_ , _plugin_id_ , _settings_)
    

The settings of a plugin.

Important

Do not instantiate directly, use `DSSPlugin.get_settings()`.

set_code_env(_code_env_name_)
    

Set the name of the code env to use for this plugin.

Parameters:
    

**code_env_name** (_string_) – name of a code env

list_parameter_sets()
    

List the parameter sets defined in this plugin.

Return type:
    

list[`DSSPluginParameterSet`]

get_parameter_set(_parameter_set_name_)
    

Get a parameter set in this plugin.

Parameters:
    

**parameter_set_name** (_string_) – name of the parameter set

Returns:
    

a handle on the parameter set

Return type:
    

`DSSPluginParameterSet`

get_raw()
    

Get the raw settings object.

Note

This method returns a reference to the settings, not a copy. Changing values in the reference then calling `save()` results in these changes being saved.

Returns:
    

the settings as a dict. The instance-level settings consist of the plugin code env’s name, the presets and the permissions to use the plugin components. The project-level settings consist of the presets and the parameter set descriptions.

Return type:
    

dict

list_parameter_set_names()
    

List the names of the parameter sets defined in this plugin.

Return type:
    

list[string]

save()
    

Save the settings to DSS.

_class _dataikuapi.dss.plugin.DSSPluginProjectSettings(_client_ , _plugin_id_ , _settings_ , _project_key_)
    

The project-level settings of a plugin.

Important

Do not instantiate directly, use `DSSPlugin.get_project_settings()`.

start_save()
    

Save the settings to DSS. Returns with a future representing the post actions done asynchronously (e.g. rebuild cde image for visual recipes)

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the save post process

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

list_parameter_sets()
    

List the parameter sets defined in this plugin.

Return type:
    

list[`DSSPluginProjectParameterSet`]

get_parameter_set(_parameter_set_name_)
    

Get a parameter set in this plugin.

Parameters:
    

**parameter_set_name** (_string_) – name of the parameter set

Returns:
    

a handle on the parameter set

Return type:
    

`DSSPluginProjectParameterSet`

get_raw()
    

Get the raw settings object.

Note

This method returns a reference to the settings, not a copy. Changing values in the reference then calling `save()` results in these changes being saved.

Returns:
    

the settings as a dict. The instance-level settings consist of the plugin code env’s name, the presets and the permissions to use the plugin components. The project-level settings consist of the presets and the parameter set descriptions.

Return type:
    

dict

list_parameter_set_names()
    

List the names of the parameter sets defined in this plugin.

Return type:
    

list[string]

save()
    

Save the settings to DSS.

_class _dataikuapi.dss.plugin.DSSPluginParameterSet(_plugin_settings_ , _desc_ , _settings_ , _presets_)
    

A parameter set in a plugin.

Important

Do not instantiate directly, use `DSSPluginSettings.get_parameter_set()` or `DSSPluginSettings.list_parameter_sets()`.

The values in this class can be modified directly, and changes will be taken into account when calling `DSSPluginSettings.save()`

_property _definable_inline
    

Whether presets for this parameter set can be defined directly in the form of the datasets, recipes, …

Return type:
    

bool

_property _definable_at_project_level
    

Whether presets for this parameter set can be defined at the project level

Return type:
    

bool

create_preset(_preset_name_ , _with_defaults =False_)
    

Create a new preset of this parameter set in the plugin settings.

Parameters:
    

  * **preset_name** (_string_) – name for the preset to create

  * **with_defaults** (_bool_) – if True, fill the new preset with the default value for each parameter



Returns:
    

a preset definition, as a `DSSPluginPreset` (see `get_preset()`)

Return type:
    

dict

delete_preset(_preset_name_)
    

Remove a preset from this plugin’s settings

Parameters:
    

**preset_name** (_string_) – name for the preset to remove

_property _desc
    

Get the raw definition of the parameter set.

Returns:
    

a parameter set definition, as a dict. The parameter set’s contents is a **desc** sub-dict. See [the doc](<https://doc.dataiku.com/dss/latest/plugins/reference/params.html#preset-parameters>)

Return type:
    

dict

get_preset(_preset_name_)
    

Get a preset of this parameter set.

Parameters:
    

**preset_name** (_string_) – name of a preset

Returns:
    

a handle on the preset definition, or None if the preset doesn’t exist

Return type:
    

`DSSPluginPreset`

list_preset_names()
    

List the names of the presets of this parameter set.

Return type:
    

list[string]

list_presets()
    

List the presets of this parameter set.

Return type:
    

list[`DSSPluginPreset`]

save()
    

Save the settings to DSS.

_property _settings
    

Get the settings of the parameter set.

These settings control the behavior of the parameter set, and comprise notably the permissions, but not the presets of this parameter set.

Returns:
    

the settings of the parameter set, as a dict. The parameter set’s settings consist of the permissions controlling whether the presets of the parameter set can be created inline or at the project level.

Return type:
    

dict

_class _dataikuapi.dss.plugin.DSSPluginProjectParameterSet(_plugin_settings_ , _desc_ , _settings_ , _presets_)
    

A parameter set in a plugin.

Important

Do not instantiate directly, use `DSSPluginProjectSettings.get_parameter_set()` or `DSSPluginProjectSettings.list_parameter_sets()`

The values in this class can be modified directly, and changes will be taken into account when calling or `DSSPluginProjectSettings.save()`

create_preset(_preset_name_ , _with_defaults =False_)
    

Create a new preset of this parameter set in the plugin settings.

Parameters:
    

  * **preset_name** (_string_) – name for the preset to create

  * **with_defaults** (_bool_) – if True, fill the new preset with the default value for each parameter



Returns:
    

a preset definition, as a `DSSPluginPreset` (see `get_preset()`)

Return type:
    

dict

delete_preset(_preset_name_)
    

Remove a preset from this plugin’s settings

Parameters:
    

**preset_name** (_string_) – name for the preset to remove

_property _desc
    

Get the raw definition of the parameter set.

Returns:
    

a parameter set definition, as a dict. The parameter set’s contents is a **desc** sub-dict. See [the doc](<https://doc.dataiku.com/dss/latest/plugins/reference/params.html#preset-parameters>)

Return type:
    

dict

get_preset(_preset_name_)
    

Get a preset of this parameter set.

Parameters:
    

**preset_name** (_string_) – name of a preset

Returns:
    

a handle on the preset definition, or None if the preset doesn’t exist

Return type:
    

`DSSPluginPreset`

list_preset_names()
    

List the names of the presets of this parameter set.

Return type:
    

list[string]

list_presets()
    

List the presets of this parameter set.

Return type:
    

list[`DSSPluginPreset`]

save()
    

Save the settings to DSS.

_property _settings
    

Get the settings of the parameter set.

These settings control the behavior of the parameter set, and comprise notably the permissions, but not the presets of this parameter set.

Returns:
    

the settings of the parameter set, as a dict. The parameter set’s settings consist of the permissions controlling whether the presets of the parameter set can be created inline or at the project level.

Return type:
    

dict

_class _dataikuapi.dss.plugin.DSSPluginPreset(_plugin_settings_ , _settings_ , _parameter_set_desc_)
    

A preset of a parameter set in a plugin.

Important

Do not instantiate directly, use `DSSPluginParameterSet.get_preset()` , `DSSPluginParameterSet.list_presets()` or `DSSPluginParameterSet.create_preset()`. For project-level presets, use `DSSPluginProjectParameterSet.get_preset()` , `DSSPluginProjectParameterSet.list_presets()` or `DSSPluginProjectParameterSet.create_preset()`

The values in this class can be modified directly, and changes will be taken into account when calling `DSSPluginSettings.save()`.

get_raw()
    

Get the raw settings of the preset object.

Note

This method returns a reference to the preset, not a copy. Changing values in the reference then calling `save()` results in these changes being saved.

Returns:
    

the preset’s complete settings

Return type:
    

dict

_property _name
    

Get the name of the preset.

Returns:
    

the name of the preset

Return type:
    

string

_property _config
    

Get the raw config of the preset object.

Note

This method returns a reference to the preset, not a copy. Changing values in the reference then calling `save()` results in these changes being saved.

Returns:
    

the preset’s config as a dict. Each parameter of the parameter set is a field in the dict.

Return type:
    

dict

_property _plugin_config
    

Get the raw admin-level config of the preset object. Admin-level config parameters are not shown in the UI to non-admin users.

Note

This method returns a reference to the preset, not a copy. Changing values in the reference then calling `save()` results in these changes being saved.

Returns:
    

the preset’s admin config as a dict. Each parameter of the parameter set is a field in the dict.

Return type:
    

dict

_property _owner
    

The DSS user that owns this preset

Return type:
    

string

_property _usable_by_all
    

Whether the preset is usable by any DSS user

Return type:
    

bool

get_permission_item(_group_)
    

Get permissions on the preset for a given group

Parameters:
    

**group** (_string_) – the name of the DSS group you want to check permissions for.

Returns:
    

the permissions as a dict

Return type:
    

dict

is_usable_by(_group_)
    

Get whether the preset is usable by DSS users in a group

Parameters:
    

**group** (_string_) – the name of the DSS group you want to check permissions for.

Returns:
    

True if the preset can be used by DSS users belonging to _group_. If _group_ is None then returns True if the preset can be used by any DSS user (like `usable_by_all()`)

Return type:
    

bool

set_usable_by(_group_ , _use_)
    

Set whether the preset is usable by DSS users in a group

Parameters:
    

  * **group** (_string_) – the name of the DSS group you want to change permissions for.

  * **use** (_bool_) – whether the group should be allowed to use the preset or not




save()
    

Save the settings to DSS.

_class _dataikuapi.dss.plugin.DSSPluginUsage(_data_)
    

Information on a usage of an element of a plugin.

Important

Do no instantiate directly, use `dataikuapi.dss.plugin.DSSPlugin.list_usages()`

_property _element_kind
    

Get the type of the plugin component.

Returns:
    

a kind of plugin component, like ‘python-clusters’, ‘python-connectors’, ‘python-fs-providers’, ‘webapps’, …

Return type:
    

string

_property _element_type
    

Get the identifier of the plugin component.

Return type:
    

string

_property _object_id
    

Get the identifier of the object using the plugin component.

Return type:
    

string

_property _object_type
    

Get the type of the object using the plugin component.

Returns:
    

a type of DSS object, like ‘CLUSTER’, ‘DATASET’, ‘RECIPE’, …

Return type:
    

string

_property _project_key
    

Get the project key of the object using the plugin component.

Return type:
    

string

_class _dataikuapi.dss.plugin.DSSMissingType(_data_)
    

Information on a type not found while analyzing usages of a plugin.

Missing types can occur when plugins stop defining a given component, for example during development, and DSS object still use the now-removed component.

Important

Do no instantiate directly, use `dataikuapi.dss.plugin.DSSPlugin.list_usages()`

_property _missing_type
    

Get the type of the plugin component.

Return type:
    

string

_property _object_id
    

Get the identifier of the object using the plugin component.

Return type:
    

string

_property _object_type
    

Get the type of the object using the plugin component.

Returns:
    

a type of DSS object, like ‘CLUSTER’, ‘DATASET’, ‘RECIPE’, …

Return type:
    

string

_property _project_key
    

Get the project key of the object using the plugin component

Return type:
    

string

_class _dataikuapi.dss.plugin.DSSPluginUsages(_data_)
    

Information on the usages of a plugin.

Important

Do no instantiate directly, use `dataikuapi.dss.plugin.DSSPlugin.list_usages()`

Some custom types may not be found during usage analysis, typically when a plugin was removed but is still used. This prevents some detailed analysis and may hide some uses. This information is provided in `missing_types()`.

get_raw()
    

Get the raw plugin usages.

Returns:
    

a summary of the usages, as a dict with fields **usages** and **missingTypes**.

Return type:
    

dict

_property _usages
    

Get the list of usages of components of the plugin.

Returns:
    

list of usages, each a `DSSPluginUsage`

Return type:
    

list

_property _missing_types
    

Get the list of usages of missing components of the plugin.

Returns:
    

list of missing component types, each a `DSSMissingType`

Return type:
    

list

maybe_used()
    

Whether the plugin maybe in use.

Returns:
    

True if usages were found, False if errors were encountered during analysis

Return type:
    

boolean

_class _dataikuapi.dss.macro.DSSMacro(_client_ , _project_key_ , _runnable_type_ , _definition =None_)
    

A macro on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.get_macro()`](<projects.html#dataikuapi.dss.project.DSSProject.get_macro> "dataikuapi.dss.project.DSSProject.get_macro")

get_definition()
    

Get the macro definition.

Note

The **adminParams** field is empty unless the authentication of the API client covers admin rights.

Returns:
    

the definition (read-only), as a dict. The fields mimic the contents of the runnable.json file of the macro.

Return type:
    

dict

run(_params =None_, _admin_params =None_, _wait =True_)
    

Run the macro from the project

Note

If the authentication of the api client does not have admin rights, admin params are ignored.

Usage example:
    
    
    # list all datasets on a connection.            
    connection_name = 'filesystem_managed'
    macro = project.get_macro('pyrunnable_builtin-macros_list-datasets-using-connection')
    run_id = macro.run(params={'connection': connection_name}, wait=True)
    # the result of this builtin macro is of type RESULT_TABLE
    result = macro.get_result(run_id, as_type="json")
    for record in result["records"]:
        print("Used by %s" % record[0])
    

Parameters:
    

  * **params** (_dict_) – parameters to the macro run (defaults to {})

  * **admin_params** (_dict_) – admin parameters to the macro run (defaults to {})

  * **wait** (_boolean_) – if True, the call blocks until the run is finished



Returns:
    

a run identifier to use with `abort()`, `get_status()` and `get_result()`

Return type:
    

string

abort(_run_id_)
    

Abort a run of the macro.

Parameters:
    

**run_id** (_string_) – a run identifier, as returned by `run()`

get_status(_run_id_)
    

Poll the status of a run of the macro.

Note

Once the run is done, when `get_result()` is called, the run ceases to exist. Afterwards `get_status()` will answer that the run doesn’t exist.

Parameters:
    

**run_id** (_string_) – a run identifier, as returned by `run()`

Returns:
    

the status, as a dict. Whether the run is still ongoing can be assessed with the **running** field.

Return type:
    

dict

get_result(_run_id_ , _as_type =None_)
    

Retrieve the result of a run of the macro.

Note

If the macro is still running, an Exception is raised.

The type of the contents of the result to expect can be checked using `get_definition()`, in particular the “resultType” field.

Parameters:
    

  * **run_id** (_string_) – a run identifier, as returned by `run()` method

  * **as_type** (_string_) – if not None, one of ‘string’ or ‘json’. Use ‘json’ when the type of result advertised by the macro is RESULT_TABLE or JSON_OBJECT.



Returns:
    

the contents of the result of the macro run, as a file-like is **as_type** is None; as a str if **as_type** is “string”; as an object if **as_type** is “json”.

Return type:
    

file-like, or string

---

## [api-reference/python/project-deployer]

# Project Deployer

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployer(_client_)
    

Handle to interact with the Project Deployer.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_projectdeployer()`](<client.html#dataikuapi.DSSClient.get_projectdeployer> "dataikuapi.DSSClient.get_projectdeployer")

list_deployments(_as_objects =True_)
    

List deployments on the Project Deployer.

Usage example:
    
    
    # list all deployments with their current state
    for deployment in deployer.list_deployments():
        status = deployment.get_status()
        print("Deployment %s is %s" % (deployment.id, status.get_health()))
    

Parameters:
    

**as_objects** (_boolean_) – if True, returns a list of `DSSProjectDeployerDeployment`, else returns a list of dict.

Returns:
    

list of deployments, either as `DSSProjectDeployerDeployment` or as dict (with fields as in `DSSProjectDeployerDeploymentStatus.get_light()`)

Return type:
    

list

get_deployment(_deployment_id_)
    

Get a handle to interact with a deployment.

Parameters:
    

**deployment_id** (_string_) – identifier of a deployment

Return type:
    

`DSSProjectDeployerDeployment`

create_deployment(_deployment_id_ , _project_key_ , _infra_id_ , _bundle_id_ , _deployed_project_key =None_, _project_folder_id =None_, _ignore_warnings =False_)
    

Create a deployment and return the handle to interact with it.

The returned deployment is not yet started and you need to call `start_update()`

Usage example:
    
    
    # create and deploy a bundle
    project = 'my-project'
    infra = 'my-infra'
    bundle = 'my-bundle'
    deployment_id = '%s-%s-on-%s' % (project, bundle, infra)
    deployment = deployer.create_deployment(deployment_id, project, infra, bundle)
    update = deployment.start_update()
    update.wait_for_result()
    

Parameters:
    

  * **deployment_id** (_string_) – identifier of the deployment to create

  * **project_key** (_string_) – key of the published project

  * **bundle_id** (_string_) – identifier of the bundle to deploy

  * **infra_id** (_string_) – identifier of the infrastructure to use

  * **deployed_project_key** (_string_) – The project key to use when deploying this project to the automation node. If not set, the project will be created with the same project key as the published project

  * **project_folder_id** (_string_) – The automation node project folder id to deploy this project into. If not set, the project will be created in the root folder

  * **ignore_warnings** (_boolean_) – ignore warnings concerning the governance status of the bundle to deploy



Returns:
    

a new deployment

Return type:
    

`DSSProjectDeployerDeployment`

list_stages()
    

List the possible stages for infrastructures.

Returns:
    

list of stages. Each stage is returned as a dict with fields:

  * **id** : identifier of the stage

  * **desc** : description of the stage




Return type:
    

list[dict]

list_infras(_as_objects =True_)
    

List the infrastructures on the Project Deployer.

Usage example:
    
    
    # list infrastructures that the user can deploy to
    for infrastructure in deployer.list_infras(as_objects=False):
        if infrastructure.get("canDeploy", False):
            print("User can deploy to %s" % infrastructure["infraBasicInfo"]["id"])
    

Parameters:
    

**as_objects** (_boolean_) – if True, returns a list of `DSSProjectDeployerInfra`, else returns a list of dict.

Returns:
    

list of infrastructures, either as `DSSProjectDeployerInfra` or as dict (with fields as in `DSSProjectDeployerInfraStatus.get_raw()`)

Return type:
    

list

create_infra(_infra_id_ , _stage_ , _govern_check_policy ='NO_CHECK'_)
    

Create a new infrastructure and returns the handle to interact with it.

Parameters:
    

  * **infra_id** (_string_) – unique identifier of the infrastructure to create

  * **stage** (_string_) – stage of the infrastructure to create

  * **govern_check_policy** (_string_) – what actions with Govern the deployer will take whe bundles are deployed on this infrastructure. Possible values: PREVENT, WARN, or NO_CHECK



Returns:
    

a new infrastructure

Return type:
    

`DSSProjectDeployerInfra`

get_infra(_infra_id_)
    

Get a handle to interact with an infrastructure.

Parameters:
    

**infra_id** (_string_) – identifier of the infrastructure to get

Return type:
    

`DSSProjectDeployerInfra`

list_projects(_as_objects =True_)
    

List published projects on the Project Deployer.

Usage example:
    
    
    # list project that the user can deploy bundles from
    for project in deployer.list_projects(as_objects=False):
        if project.get("canDeploy", False):
            print("User can deploy to %s" % project["projectBasicInfo"]["id"])
    

Parameters:
    

**as_objects** (_boolean_) – if True, returns a list of `DSSProjectDeployerProject`, else returns a list of dict.

Returns:
    

list of published projects, either as `DSSProjectDeployerProject` or as dict (with fields as in `DSSProjectDeployerProjectStatus.get_raw()`)

Return type:
    

list

create_project(_project_key_)
    

Create a new published project on the Project Deployer and return the handle to interact with it.

Parameters:
    

**project_key** (_string_) – key of the project to create

Return type:
    

`DSSProjectDeployerProject`

get_project(_project_key_)
    

Get a handle to interact with a published project.

Parameters:
    

**project_key** (_string_) – key of the project to get

Return type:
    

`DSSProjectDeployerProject`

upload_bundle(_fp_ , _project_key =None_)
    

Upload a bundle archive for a project.

Parameters:
    

  * **fp** (_file-like_) – a bundle archive (should be a zip)

  * **project_key** (_string_) – key of the published project where the bundle will be uploaded. If the project does not exist, it is created. If not set, the key of the bundle’s source project is used.




## Infrastructures

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerInfra(_client_ , _infra_id_)
    

An Automation infrastructure on the Project Deployer.

Important

Do not instantiate directly, use `DSSProjectDeployer.get_infra()`.

_property _id
    

Get the unique identifier of the infrastructure.

Return type:
    

string

get_status()
    

Get status information about this infrastructure.

Returns:
    

the current status

Return type:
    

`DSSProjectDeployerInfraStatus`

get_settings()
    

Get the settings of this infrastructure.

Return type:
    

`DSSProjectDeployerInfraSettings`

delete()
    

Delete this infra.

Note

You may only delete an infra if there are no deployments using it.

generate_personal_api_key(_label_ , _description_ , _for_user =None_)
    

Generate a personal api key on all the nodes of the infrastructure. Only available for multi automation node infrastructures.

Parameters:
    

  * **label** (_string_) – label of the key to create

  * **description** (_string_) – description of the key to create

  * **for_user** (_string_) – (Optional) the user for whom the key will be created. If not set, the key will be created for the current user. Requires admin permission on the automation nodes to create a key for another user.



Returns:
    

the key creation result, as a `DSSPersonalAPIKeyCreationResult`

Return type:
    

`DSSPersonalAPIKeyCreationResult`

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerInfraSettings(_client_ , _infra_id_ , _settings_)
    

The settings of an Automation infrastructure.

Important

Do not instantiate directly, use `DSSProjectDeployerInfra.get_settings()`

To modify the settings, modify them in the dict returned by `get_raw()` then call `save()`.

get_raw()
    

Get the raw settings of this infrastructure.

This returns a reference to the raw settings, not a copy, so changes made to the returned object will be reflected when saving.

Returns:
    

the settings, as a dict.

Return type:
    

dict

save()
    

Save back these settings to the infrastracture.

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerInfraStatus(_client_ , _infra_id_ , _light_status_)
    

The status of an Automation infrastructure.

Important

Do not instantiage directly, use `DSSProjectDeployerInfra.get_status()`

get_deployments()
    

Get the deployments that are deployed on this infrastructure.

Returns:
    

a list of deployments

Return type:
    

list of `DSSProjectDeployerDeployment`

get_raw()
    

Get the raw status information.

Returns:
    

the status, as a dict. The dict contains a list of the bundles currently deployed on the infrastructure as a **deployments** field.

Return type:
    

dict

## Published projects

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerProject(_client_ , _project_key_)
    

A published project on the Project Deployer.

Important

Do not instantiate directly, use `DSSProjectDeployer.get_project()`

_property _id
    

Get the key of the published project.

Return type:
    

string

get_status()
    

Get status information about this published project.

This is used mostly to get information about which versions are available and which deployments are exposing this project

Return type:
    

`DSSProjectDeployerProjectStatus`

get_settings()
    

Get the settings of this published project.

The main things that can be modified in a project settings are permissions

Return type:
    

`DSSProjectDeployerProjectSettings`

delete_bundle(_bundle_id_)
    

Delete a bundle from this published project.

Parameters:
    

**bundle_id** (_string_) – identifier of the bundle to delete

get_bundle_stream(_bundle_id_)
    

Download a bundle from this published project, as a binary stream.

Warning

The stream must be closed after use. Use a **with** statement to handle closing the stream at the end of the block by default. For example:
    
    
    with project_deployer_project.get_bundle_stream('v1') as fp:
        # use fp
    
    # or explicitly close the stream after use
    fp = project_deployer_project.get_bundle_stream('v1')
    # use fp, then close
    fp.close()
    

Parameters:
    

**bundle_id** (_str_) – the identifier of the bundle

download_bundle_to_file(_bundle_id_ , _path_)
    

Download a bundle from this published project into the given output file.

Parameters:
    

  * **bundle_id** (_str_) – the identifier of the bundle

  * **path** (_str_) – if “-”, will write to /dev/stdout




get_project_standards_report(_bundle_id_ , _as_type ='object'_)
    

Get the Project Standards report for a bundle in the project.

Parameters:
    

  * **bundle_id** (_str_) – identifier of the bundle

  * **as_type** (_str_ _,__optional_) – How to return the report. Supported values are “dict” and “object” (defaults to **object**)



Returns:
    

The report, if any If as_type=dict, report is returned as a dict. If as_type=object, report is returned as a [`dataikuapi.dss.project_standards.DSSProjectStandardsRunReport`](<project-standards.html#dataikuapi.dss.project_standards.DSSProjectStandardsRunReport> "dataikuapi.dss.project_standards.DSSProjectStandardsRunReport").

Return type:
    

([DSSProjectStandardsRunReport](<project-standards.html#dataikuapi.dss.project_standards.DSSProjectStandardsRunReport> "dataikuapi.dss.project_standards.DSSProjectStandardsRunReport") | dict | None)

delete()
    

Delete this published project.

Note

You may only delete a published project if there are no deployments using it.

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerProjectSettings(_client_ , _project_key_ , _settings_)
    

The settings of a published project.

Important

Do not instantiate directly, use `DSSProjectDeployerProject.get_settings()`

To modify the settings, modify them in the dict returned by `get_raw()` then call `save()`.

get_raw()
    

Get the raw settings of this published project.

This returns a reference to the raw settings, not a copy, so changes made to the returned object will be reflected when saving.

Returns:
    

the settings, as a dict.

Return type:
    

dict

save()
    

Save back these settings to the published project.

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerProjectStatus(_client_ , _project_key_ , _light_status_)
    

The status of a published project.

Important

Do not instantiate directly, use `DSSProjectDeployerProject.get_status()`

get_deployments(_infra_id =None_)
    

Get the deployments that have been created from this published project.

Parameters:
    

**infra_id** (_string_) – (optional) identifier of an infrastructure. When set, only get the deployments deployed on this infrastructure. When not set, the list contains all the deployments using this published project, across every infrastructure of the Project Deployer.

Returns:
    

a list of deployments, each a `DSSProjectDeployerDeployment`

Return type:
    

list

get_bundles()
    

Get the bundles that have been published on this project.

Each bundle is a dict that contains at least a “id” field, which is the version identifier

Returns:
    

a list of bundles, each one a dict. Each bundle has an **id** field holding its identifier.

Return type:
    

list[dict]

get_infras()
    

Get the infrastructures that deployments of this project use.

Returns:
    

list of summaries of infrastructures, each a dict.

Return type:
    

list[dict]

get_raw()
    

Gets the raw status information.

Returns:
    

the status, as a dict. A **deployments** sub-field contains a list of the deployments of bundles of this projects.

Return type:
    

dict

## Deployments

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerDeployment(_client_ , _deployment_id_)
    

A deployment on the Project Deployer.

Important

Do not instantiate directly, use `DSSProjectDeployer.get_deployment()`

_property _id
    

Get the identifier of the deployment.

Return type:
    

string

get_status()
    

Get status information about this deployment.

Return type:
    

dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus

get_governance_status(_bundle_id =''_)
    

Get the governance status about this deployment.

The infrastructure on which this deployment is running needs to have a Govern check policy of PREVENT or WARN.

Parameters:
    

**bundle_id** (_string_) – (Optional) The ID of a specific bundle of the published project to get status from. If empty, the bundle currently used in the deployment.

Returns:
    

messages about the governance status, as a dict with a **messages** field, itself a list of meassage information, each one a dict of:

>   * **severity** : severity of the error in the message. Possible values are SUCCESS, INFO, WARNING, ERROR
> 
>   * **isFatal** : for ERROR **severity** , whether the error is considered fatal to the operation
> 
>   * **code** : a string with a well-known code documented in [DSS doc](<https://doc.dataiku.com/dss/latest/troubleshooting/errors/index.html>)
> 
>   * **title** : short message
> 
>   * **message** : the error message
> 
>   * **details** : a more detailed error description
> 
> 


Return type:
    

dict

get_settings()
    

Get the settings of this deployment.

Return type:
    

`DSSProjectDeployerDeploymentSettings`

start_update()
    

Start an asynchronous update of this deployment.

After the update, the deployment should be matching the actual state to the current settings.

Returns:
    

a handle on the update operation

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

delete()
    

Deletes this deployment

Note

You may only delete a deployment if it is disabled and has been updated after disabling it.

get_testing_status(_bundle_id =None_, _automation_node_id =None_)
    

Get the testing status of a project deployment.

Parameters:
    

  * **bundle_id** (_(__optional_ _)__string_) – filters the scenario runs done on a specific bundle

  * **automation_node_id** (_(__optional_ _)_) – for multi-node deployments only, you need to specify the automation node id on which you want to retrieve the testing status



Returns:
    

A [`dataikuapi.dss.scenario.DSSTestingStatus`](<scenarios.html#dataikuapi.dss.scenario.DSSTestingStatus> "dataikuapi.dss.scenario.DSSTestingStatus") object handle

run_test_scenarios(_automation_node_id =None_)
    

Run all the test scenarios on a project deployment

Parameters:
    

**automation_node_id** (_(__optional_ _)_) – for multi-node deployments only, you need to specify the automation node id on which you want to run test scenarios

Returns:
    

A [`dataikuapi.dss.scenario.DSSTestingStatus`](<scenarios.html#dataikuapi.dss.scenario.DSSTestingStatus> "dataikuapi.dss.scenario.DSSTestingStatus") object handle

list_updates()
    

Retrieves a list of available deployment updates. Each element contains start timestamp, type and status fields

Returns:
    

a list of deployment updates

Return type:
    

list of dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentUpdateListItem

get_update(_timestamp =None_)
    

Retrieves a specific deployment update by timestamp, or the most recent update if no timestamp is provided

Parameters:
    

**timestamp** (_(__optional_ _)__string_) – The The timestamp that uniquely identifies the update to retrieve

Return type:
    

dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentUpdate

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentSettings(_client_ , _deployment_id_ , _settings_)
    

The settings of a Project Deployer deployment.

Important

Do not instantiate directly, use `DSSProjectDeployerDeployment.get_settings()`

To modify the settings, modify them in the dict returned by `get_raw()`, or change the value of `bundle_id()`, then call `save()`.

get_raw()
    

Get the raw settings of this deployment.

This returns a reference to the raw settings, not a copy, so changes made to the returned object will be reflected when saving.

Returns:
    

the settings, as a dict. Notable fields are:

  * **id** : identifier of the deployment

  * **infraId** : identifier of the infrastructure on which the deployment is done

  * **bundleId** : identifier of the bundle of the published project being deployed




Return type:
    

dict

_property _bundle_id
    

Get or set the identifier of the bundle currently used by this deployment.

If setting the value, you need to call `save()` afterward for the change to be effective.

_property _published_project_key
    

Get the published project key from which the deployed bundle originates. You can’t change this value.

Returns:
    

The published project key

Return type:
    

string

save(_ignore_warnings =False_)
    

Save back these settings to the deployment.

Parameters:
    

**ignore_warnings** (_boolean_) – whether to ignore warnings concerning the governance status of the bundle to deploy

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentStatus(_client_ , _deployment_id_ , _light_status_ , _heavy_status_)
    

The status of a deployment on the Project Deployer.

Important

Do not instantiate directly, use `DSSProjectDeployerDeployment.get_status()`

get_light()
    

Get the ‘light’ (summary) status.

This returns a dictionary with various information about the deployment, but not the actual health of the deployment

Returns:
    

a summary, as a dict, with summary information on the deployment, the project from which the deployed bundle originates, and the infrastructure on which it’s deployed.

Return type:
    

dict

get_heavy()
    

Get the ‘heavy’ (full) status.

This returns various information about the deployment, notably its health.

Returns:
    

a status, as a dict. The overall status of the deployment is in a **health** field (possible values: UNKNOWN, ERROR, WARNING, HEALTHY, UNHEALTHY, OUT_OF_SYNC).

Return type:
    

dict

get_health()
    

Get the health of this deployment.

Returns:
    

possible values are UNKNOWN, ERROR, WARNING, HEALTHY, UNHEALTHY, OUT_OF_SYNC

Return type:
    

string

get_health_messages()
    

Get messages about the health of this deployment

Returns:
    

a dict with a **messages** field, which is a list of meassage information, each one a dict of:

  * **severity** : severity of the error in the message. Possible values are SUCCESS, INFO, WARNING, ERROR

  * **isFatal** : for ERROR **severity** , whether the error is considered fatal to the operation

  * **code** : a string with a well-known code documented in [DSS doc](<https://doc.dataiku.com/dss/latest/troubleshooting/errors/index.html>)

  * **title** : short message

  * **message** : the error message

  * **details** : a more detailed error description




Return type:
    

dict

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentUpdate(_update_)
    

Represents a Project Deployer’s deployment update.

This class should not be instantiated directly. Use `get_update()` to obtain instances of this class

_property _start_time
    

_property _end_time
    

_property _requester
    

_property _status
    

_property _logs
    

Returns the logs for this update, formatted as a list of lines:
    

  * Each line represents a single log entry

  * The list preserves the original order of the log output




Returns:
    

List of log lines, or None if no logs are available

Return type:
    

list[str] or None

get_raw()
    

Returns the raw data of this deployment update as a dictionary

Returns:
    

a deployment update, as a dict

Return type:
    

dict

_class _dataikuapi.dss.projectdeployer.DSSProjectDeployerDeploymentUpdateListItem(_client_ , _deployment_id_ , _data_)
    

Represents a single item in a list of Project Deployer’s deployment updates.

This class should not be instantiated directly. Instead, use `list_updates()` to retrieve instances of this class.

_property _start_time
    

_property _type
    

_property _status
    

get_raw()
    

Returns the raw dictionary representation of this deployment update list item

Returns:
    

a deployment update list item, as a dict

Return type:
    

dict

get_full_update()
    

Returns the full deployment update corresponding to this list item, as a `DSSProjectDeployerDeploymentUpdate`

Returns:
    

a fully detailed deployment update

Return type:
    

`DSSProjectDeployerDeploymentUpdate`

---

## [api-reference/python/project-folders]

# Project folders

For more details and samples, please see [Project folders](<../../concepts-and-examples/project-folders.html>)

_class _dataikuapi.dss.projectfolder.DSSProjectFolder(_client_ , _data_)
    

A handle for a project folder on the DSS instance.

Important

Do not instantiate this class directly, instead use [`dataikuapi.DSSClient.get_project_folder()`](<client.html#dataikuapi.DSSClient.get_project_folder> "dataikuapi.DSSClient.get_project_folder") or [`dataikuapi.DSSClient.get_root_project_folder()`](<client.html#dataikuapi.DSSClient.get_root_project_folder> "dataikuapi.DSSClient.get_root_project_folder").

_property _id
    

Returns:
    

The project folder id.

Return type:
    

string

_property _project_folder_id
    

Caution

Deprecated. Please use `dataikuapi.dss.projectfolder.DSSProjectFolder.id`.

_property _name
    

Returns:
    

The project folder name or `None` for the root project folder.

Return type:
    

string

get_name()
    

See `dataikuapi.dss.projectfolder.DSSProjectFolder.name`.

Returns:
    

The project folder name or `None` for the root project folder.

Return type:
    

string

get_path()
    

Returns:
    

The project folder path from the root project folder (e.g. `'/'` or `'/foo/bar'`).

Return type:
    

string

get_parent()
    

Returns:
    

A handle for the parent folder or `None` for the root project folder.

Return type:
    

`dataikuapi.dss.projectfolder.DSSProjectFolder`

list_child_folders()
    

Returns:
    

Handles for every child project folder.

Return type:
    

list of `dataikuapi.dss.projectfolder.DSSProjectFolder`

list_project_keys()
    

Returns:
    

The project keys of all projects stored in this project folder.

Return type:
    

list of string

list_projects()
    

Returns:
    

Handles for every project stored in this project folder.

Return type:
    

list of [`dataikuapi.dss.project.DSSProject`](<projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")

delete()
    

Delete this project folder.

Important

This project folder must be empty, i.e. contain no project or subfolder. You must move or remove all this project folder content prior to deleting it.

Attention

This call requires an API key with admin rights.

get_settings()
    

Returns:
    

A handle for this project folder settings.

Return type:
    

`dataikuapi.dss.projectfolder.DSSProjectFolderSettings`

create_sub_folder(_name_)
    

Create a project subfolder inside this project folder.

Parameters:
    

**name** (_str_) – The name of the project subfolder to create.

Returns:
    

A handle for the created project subfolder.

Return type:
    

`dataikuapi.dss.projectfolder.DSSProjectFolder`

create_project(_project_key_ , _name_ , _owner_ , _description =None_, _settings =None_)
    

Create a new project within this project folder. Return a handle for the created project.

Important

The provided identifier for the new project must be globally unique.

Attention

This call requires an API key with admin rights or the right to create a project.

Parameters:
    

  * **project_key** (_str_) – The identifier for the new project. Must be globally unique.

  * **name** (_str_) – The displayed name for the new project.

  * **owner** (_str_) – The login of the new project owner.

  * **description** (_str_) – The description for the new project.

  * **settings** (_dict_) – The initial settings for the new project. The settings can be modified later. The exact possible settings are not documented.



Returns:
    

A handle for the created project.

Return type:
    

[`dataikuapi.dss.project.DSSProject`](<projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")

get_default_folder_for_project_creation()
    

Get a handle to interact with the default folder used to create projects for the current user in this folder.

Returns:
    

A `dataikuapi.dss.projectfolder.DSSProjectFolder` to interact with this project folder

move_to(_destination_)
    

Move this project folder into another project folder.

Parameters:
    

**destination** (`dataikuapi.dss.projectfolder.DSSProjectFolder`) – The new parent project folder of this project folder.

move_project_to(_project_key_ , _destination_)
    

Move a project from this project folder into another project folder.

Parameters:
    

  * **project_key** (_str_) – The identifier of the project to move.

  * **destination** (`dataikuapi.dss.projectfolder.DSSProjectFolder`) – The new parent project folder of the project.




_class _dataikuapi.dss.projectfolder.DSSProjectFolderSettings(_client_ , _project_folder_id_ , _settings_)
    

A handle for a project folder settings.

Important

Do not instantiate this class directly, instead use `dataikuapi.dss.projectfolder.DSSProjectFolder.get_settings()`.

get_raw()
    

Get the settings of the project folder as a python dict.

Important

Returns a reference to the raw settings in opposition to a copy. Changes through the reference will be effective upon saving.

Returns:
    

The settings of the project folder as a python dict containing the keys:

  * **name** : the name of the project folder,

  * **owner** : the login of the project folder owner,

  * **permissions** : the list of the project folder permissions.




Return type:
    

python dict

get_name()
    

Returns:
    

The name of the project folder.

Return type:
    

string

set_name(_name_)
    

Set the name of the project folder.

Parameters:
    

**name** (_str_) – The new name of the project folder.

get_owner()
    

Returns:
    

The login of the project folder owner.

Return type:
    

string

set_owner(_owner_)
    

Set the owner of the project folder.

Parameters:
    

**owner** (_str_) – The login of the new project folder owner.

get_permissions()
    

Get the permissions of the project folder.

Important

Returns a reference to the permissions in opposition to a copy. Changes through the reference will be effective upon saving.

Returns:
    

The permissions of the project folder.

Return type:
    

list of string

save()
    

Save back the settings to the project folder.

---

## [api-reference/python/project-libraries]

# Project libraries

_class _dataikuapi.dss.projectlibrary.DSSLibrary(_client_ , _project_key_)
    

A handle to manage the library of a project It saves locally a copy of taxonomy to help navigate in the library All modifications done through this object and related library items are done locally and on remote.

Note

Taxonomy modifications done outside this library are not reflected locally. You should reload the library in this case.

list(_folder_path ='/'_)
    

Lists the contents in the given library folder or on the root if no folder is given.

Parameters:
    

**folder_path** (_str_) – the folder path (optional). If no path is given, it is defaulted to the root path.

Returns:
    

the list of contents in the library folder

Return type:
    

list of `dataikuapi.dss.projectlibrary.DSSLibraryItem`

get_file(_path_)
    

Retrieves a file in the library

Parameters:
    

**path** (_str_) – the file path

Returns:
    

the file in the given path

Return type:
    

`dataikuapi.dss.projectlibrary.DSSLibraryFile`

get_folder(_path_)
    

Retrieves a folder in the library

Parameters:
    

**path** (_str_) – the folder path

Returns:
    

the folder in the given path

Return type:
    

`dataikuapi.dss.projectlibrary.DSSLibraryFolder`

add_file(_file_name_)
    

Create a file in the library root folder

Parameters:
    

**file_name** (_str_) – the file name

Returns:
    

the new file

Return type:
    

`dataikuapi.dss.projectlibrary.DSSLibraryFile`

add_folder(_folder_name_)
    

Create a folder in the library root folder

Parameters:
    

**folder_name** (_str_) – the folder name

Returns:
    

the new folder

Return type:
    

`dataikuapi.dss.projectlibrary.DSSLibraryFolder`

_class _dataikuapi.dss.projectlibrary.DSSLibraryItem(_client_ , _project_key_ , _name_ , _parent_ , _children_)
    

A handle to manage a library item

_property _path
    

is_root()
    

delete()
    

Deletes this item from library

rename(_new_name_)
    

Rename the folder

Parameters:
    

**new_name** (_str_) – the new name of the item

move_to(_destination_folder_)
    

Move a library item to another folder

Parameters:
    

**destination_folder** (`dataikuapi.dss.projectlibrary.DSSLibraryFolder`) – the folder where we want to move the current item

_class _dataikuapi.dss.projectlibrary.DSSLibraryFolder(_client_ , _project_key_ , _name_ , _parent_ , _children_)
    

A handle to manage a library folder

Warning

Do not call directly, use `dataikuapi.dss.projectlibrary.DSSLibrary.get_folder`

get_child(_name_)
    

Retrieve the sub item by its name

Parameters:
    

**name** (_str_) – the name of the sub item

Returns:
    

the sub item

Return type:
    

`dataikuapi.dss.projectlibrary.DSSLibraryItem`

add_file(_file_name_)
    

Create a new file in the library folder

Parameters:
    

**file_name** (_str_) – the file name

Returns:
    

the new file

Return type:
    

`dataikuapi.dss.projectlibrary.DSSLibraryFile`

add_folder(_folder_name_)
    

Create a folder in the library

Parameters:
    

**folder_name** (_str_) – the name of the folder to add

Returns:
    

the new folder

Return type:
    

`dataikuapi.dss.projectlibrary.DSSLibraryFolder`

list()
    

Gets the contents of this folder sorted by name

Returns:
    

a sorted list of items

Return type:
    

list of `dataikuapi.dss.projectlibrary.DSSLibraryItem`

get_file(_path_)
    

Retrieves a file in the library

Parameters:
    

**path** (_str_) – the file path

Returns:
    

the file in the given path

Return type:
    

`dataikuapi.dss.projectlibrary.DSSLibraryFile`

get_folder(_path_)
    

Retrieves a folder in the library

Parameters:
    

**path** (_str_) – the folder path

Returns:
    

the folder in the given path

Return type:
    

`dataikuapi.dss.projectlibrary.DSSLibraryFolder`

_class _dataikuapi.dss.projectlibrary.DSSLibraryFile(_client_ , _project_key_ , _name_ , _parent_)
    

A handle to manage a library file

Warning

Do not call directly, use `dataikuapi.dss.projectlibrary.DSSLibrary.get_file()`

read(_as_type ='str'_)
    

Get the file contents from DSS

Parameters:
    

**as_type** (_str_) – specify whether you want to read the file in text mode (as_type=’str’) or in binary mode (as_type=’bytes’). Defaults to text mode.

Returns:
    

the contents of the file as a string

write(_data_)
    

Updates the contents of the file with the given data

---

## [api-reference/python/project-standards]

# Project Standards

_class _dataikuapi.dss.project_standards.DSSProjectStandards(_client_)
    

Handle to interact with Project Standards

Important

Do not create this class directly, use [`dataikuapi.DSSClient.get_project_standards()`](<client.html#dataikuapi.DSSClient.get_project_standards> "dataikuapi.DSSClient.get_project_standards")

list_check_specs(_as_type ='listitems'_)
    

Get the list of the check specs available in the DSS instance.

Parameters:
    

**as_type** (_str_ _,__optional_) – How to return the check specs. Supported values are “listitems” and “objects” (defaults to **objects**)

Returns:
    

A list of check specs. If as_type=listitems, each check spec is returned as a dict. If as_type=objects, each check spec is returned as a `DSSProjectStandardsCheckSpecInfo`.

Return type:
    

List[DSSProjectStandardsCheckSpecInfo | dict]

create_checks(_check_specs_element_types_ , _as_type ='listitems'_)
    

Create new checks from check specs.

Parameters:
    

  * **check_specs_element_types** (_List_ _[__str_ _]_) – list of check spec element types to import

  * **as_type** (_str_ _,__optional_) – How to return the checks. Supported values are “listitems” and “objects” (defaults to **listitems**)



Returns:
    

A list of checks. If as_type=listitems, each check is returned as a `DSSProjectStandardsCheckListItem`. If as_type=objects, each check is returned as a `DSSProjectStandardsCheck`.

Return type:
    

List[DSSProjectStandardsCheck | DSSProjectStandardsCheckListItem]

get_check(_check_id_ , _as_type ='object'_)
    

Get the check details

Parameters:
    

  * **check_id** (_str_) – id of the check

  * **as_type** (_str_ _,__optional_) – How to return the check. Supported values are “dict” and “object” (defaults to **object**)



Returns:
    

The check. If as_type=dict, check is returned as a dict. If as_type=object, check is returned as a `DSSProjectStandardsCheck`.

Return type:
    

(DSSProjectStandardsCheck | dict)

list_checks(_as_type ='listitems'_)
    

Get the list of the checks configured in the DSS instance.

Parameters:
    

**as_type** (_str_ _,__optional_) – How to return the checks. Supported values are “listitems” and “objects” (defaults to **listitems**)

Returns:
    

A list of checks. If as_type=listitems, each check is returned as a `DSSProjectStandardsCheckListItem`. If as_type=objects, each check is returned as a `DSSProjectStandardsCheck`.

Return type:
    

List[DSSProjectStandardsCheck | DSSProjectStandardsCheckListItem]

get_scope(_scope_name_ , _as_type ='object'_)
    

Get the scope details

Parameters:
    

  * **scope_name** (_str_) – name of the scope

  * **as_type** (_str_ _,__optional_) – How to return the scope. Supported values are “dict” and “object” (defaults to **object**)



Returns:
    

The scope. If as_type=dict, scope is returned as a dict. If as_type=object, scope is returned as a `DSSProjectStandardsScope`.

Return type:
    

(DSSProjectStandardsScope | dict)

create_scope(_name_ , _description =''_, _checks =[]_, _selection_method ='BY_PROJECT'_, _items =[]_)
    

Create a new scope

Parameters:
    

  * **name** (_str_) – name of the scope, it cannot be changed later

  * **description** (_str_ _,__optional_) – description of the scope

  * **checks** (_List_ _[__str_ _]__,__optional_) – list of checks associated to the scope

  * **selection_method** (_str_ _,__optional_) – the kind of objects the scope will select. Supported values are “BY_PROJECT”, “BY_FOLDER”, and “BY_TAG” (defaults to “BY_PROJECT”)

  * **items** (_List_ _[__str_ _]__,__optional_) – list of object ids selected by the scope. The kind of the objects depends on selection_method. BY_PROJECT -> project keys. BY_FOLDER -> folder ids. BY_TAG -> tags.



Returns:
    

The new scope returned by the backend

Return type:
    

DSSProjectStandardsScope

list_scopes(_as_type ='listitems'_)
    

Get the list of the scopes configured in the DSS instance.

Parameters:
    

**as_type** (_str_ _,__optional_) – How to return the scopes. Supported values are “listitems” and “objects” (defaults to **listitems**)

Returns:
    

A list of scopes. If as_type=listitems, each check is returned as a dict. If as_type=objects, each check is returned as a `DSSProjectStandardsScope`.

Return type:
    

List[DSSProjectStandardsScope | dict]

get_default_scope(_as_type ='object'_)
    

Get the default scope. If no existing scope is associated with one project, the default scope will be used.

Parameters:
    

**as_type** (_str_ _,__optional_) – How to return the default scope. Supported values are “dict” and “object” (defaults to **object**)

Returns:
    

The default scope. If as_type=dict,it is returned as a dict. If as_type=object, it is returned as a `DSSProjectStandardsScope`.

Return type:
    

(DSSProjectStandardsScope | dict)

_class _dataikuapi.dss.project_standards.DSSProjectStandardsCheckSpecInfo(_data_)
    

Info about a Project Standards check spec. Project Standards check specs can be created or imported using DSS plugin components.

_property _element_type
    

Element type can be considered as a unique identifier for a check spec. It’s a concatenation of the plugin id and the plugin component id.

Returns:
    

The element type of the check spec

Return type:
    

str

_property _label
    

_property _description
    

_property _owner_plugin_id
    

_class _dataikuapi.dss.project_standards.DSSProjectStandardsCheck(_client_ , _data_)
    

A check for Project Standards

Important

Do not create this class directly, use `get_check()`

_property _id
    

_property _name
    

_property _description
    

_property _check_element_type
    

_property _check_params
    

_property _tags
    

get_raw()
    

Get the raw check

Return type:
    

dict

save()
    

Save the check

Returns:
    

The updated check returned by the backend

Return type:
    

DSSProjectStandardsCheck

delete()
    

Delete the check

_class _dataikuapi.dss.project_standards.DSSProjectStandardsCheckListItem(_client_ , _data_)
    

An item in a list of checks.

Important

Do not instantiate directly, use `list_checks()`

to_check()
    

Gets a handle corresponding to this check.

Return type:
    

`DSSProjectStandardsCheck`

_property _id
    

_property _name
    

_property _description
    

_property _check_element_type
    

_property _check_params
    

_class _dataikuapi.dss.project_standards.DSSProjectStandardsScope(_client_ , _data_)
    

A scope for Project Standards. Use scopes to select which checks a project should run.

Important

Do not create this class directly, use `get_scope()` or `get_default_scope()`

_property _is_default
    

_property _id
    

_property _name
    

_property _description
    

_property _selection_method
    

Returns:
    

The selection method.

Return type:
    

str

_property _selected_projects
    

_property _selected_folders
    

_property _selected_tags
    

_property _checks
    

get_raw()
    

Get the raw scope

Return type:
    

dict

reorder(_index_)
    

Move the scope to a new index. The index should be specified on a list that does not include the scope.

Ex: you want to move the scope ‘foo’ at the end of the list of scopes [‘foo’, ‘bar’]. The list without ‘foo’ is [‘bar’] so the new index should be 1 (and not 2)

Note

Default scope will always be the last scope, you can’t move it or put another scope after it.

Parameters:
    

**index** (_int_) – the new index of the scope.

save()
    

Update the scope.

Note

Description of the default scope cannot be changed.

Returns:
    

The updated scope returned by the backend

Return type:
    

DSSProjectStandardsScope

delete()
    

Delete the scope

_class _dataikuapi.dss.project_standards.DSSProjectStandardsRunReport(_client_ , _data_)
    

Report containing the result of all the checks run in the project

_property _checks_run_info
    

Returns:
    

A dict with the info of each run. The key is the check id.

Return type:
    

Dict[str, DSSProjectStandardsCheckRunInfo]

_class _dataikuapi.dss.project_standards.DSSProjectStandardsCheckRunInfo(_client_ , _data_)
    

Contains info about the run of one check

_property _check
    

Returns:
    

the original check configuration

Return type:
    

DSSProjectStandardsCheckListItem | None

_property _result
    

Returns:
    

the result of the run

Return type:
    

DSSProjectStandardsCheckRunResult | None

_property _duration_ms
    

Returns:
    

the duration of the check run

Return type:
    

int

_property _expanded_check_params
    

Returns:
    

the parameters that have been used when running the check

Return type:
    

dict

_class _dataikuapi.dss.project_standards.DSSProjectStandardsCheckRunResult(_data_)
    

The result of the check run

_property _status
    

The status of the run

Returns:
    

Possible values: RUN_SUCCESS, RUN_ERROR or NOT_APPLICABLE

Return type:
    

str

_property _severity
    

Severity of a potential issue.

Returns:
    

the severity, between 0 and 5. 0 means no issue, 5 means critical issue. None if the run is not a success.

Return type:
    

int | None

_property _severity_category
    

String representation of the severity. None if there is no detected issue or if the run is not a success.

Returns:
    

the severity name. Possible values: LOWEST, LOW, MEDIUM, HIGH, CRITICAL. None if the severity is not between 1 and 5.

Return type:
    

str | None

_property _success
    

Whether the run was successful and no issue was found.

Returns:
    

True if the run was successful and no issue was found, False otherwise.

Return type:
    

bool

_property _message
    

Returns:
    

A message related to the run result.

Return type:
    

str

_property _details
    

Returns:
    

Additional metadata about the run

Return type:
    

dict

---

## [api-reference/python/projects]

# Projects

For usage information and examples, please see [Projects](<../../concepts-and-examples/projects.html>).

_class _dataikuapi.dss.project.DSSProject(_client_ , _project_key_)
    

A handle to interact with a project on the DSS instance.

Important

Do not create this class directly, instead use [`dataikuapi.DSSClient.get_project()`](<client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")

get_summary()
    

Returns a summary of the project. The summary is a read-only view of some of the state of the project. You cannot edit the resulting dict and use it to update the project state on DSS, you must use the other more specific methods of this `dataikuapi.dss.project.DSSProject` object

Returns:
    

a dict containing a summary of the project. Each dict contains at least a **projectKey** field

Return type:
    

dict

get_project_folder()
    

Get the folder containing this project

Return type:
    

[`dataikuapi.dss.projectfolder.DSSProjectFolder`](<project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder> "dataikuapi.dss.projectfolder.DSSProjectFolder")

move_to_folder(_folder_)
    

Moves this project to a project folder

Parameters:
    

**folder** ([`dataikuapi.dss.projectfolder.DSSProjectFolder`](<project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder> "dataikuapi.dss.projectfolder.DSSProjectFolder")) – destination folder

delete(_clear_managed_datasets =False_, _clear_output_managed_folders =False_, _clear_job_and_scenario_logs =True_, _** kwargs_)
    

Delete the project

Attention

This call requires an API key with admin rights

Parameters:
    

  * **clear_managed_datasets** (_bool_) – Should the data of managed datasets be cleared (defaults to **False**)

  * **clear_output_managed_folders** (_bool_) – Should the data of managed folders used as outputs of recipes be cleared (defaults to **False**)

  * **clear_job_and_scenario_logs** (_bool_) – Should the job and scenario logs be cleared (defaults to **True**)

  * **wait** (_bool_) – Whether to wait for the deletion to complete (defaults to **True**)



Returns:
    

if wait is True, a dict containing messages about the deletion if errors arose. If wait is False, a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") tracking the progress of the deletion. Call [`wait_for_result()`](<other-administration.html#dataikuapi.dss.future.DSSFuture.wait_for_result> "dataikuapi.dss.future.DSSFuture.wait_for_result") on the returned object to wait for completion (or failure).

Return type:
    

dict or [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

get_export_stream(_options =None_)
    

Return a stream of the exported project

Warning

You need to close the stream after download. Failure to do so will result in the DSSClient becoming unusable.

Parameters:
    

**options** (_dict_) – 

Dictionary of export options (defaults to **{}**). The following options are available:

  * **exportUploads** (boolean): Exports the data of Uploaded datasets (default to **False**)

  * **exportManagedFS** (boolean): Exports the data of managed Filesystem datasets (default to **False**)

  * **exportAnalysisModels** (boolean): Exports the models trained in analysis (default to **False**)

  * **exportSavedModels** (boolean): Exports the models trained in saved models (default to **False**)

  * **exportManagedFolders** (boolean): Exports the data of managed folders (default to **False**)

  * **exportAllInputDatasets** (boolean): Exports the data of all input datasets (default to **False**)

  * **exportAllDatasets** (boolean): Exports the data of all datasets (default to **False**)

  * **exportAllInputManagedFolders** (boolean): Exports the data of all input managed folders (default to **False**)

  * **exportGitRepository** (boolean): Exports the Git repository history (you must be project admin if a git remote with credentials is configured, defaults to **False**)

  * **exportInsightsData** (boolean): Exports the data of static insights (default to **False**)




Returns:
    

a stream of the export archive

Return type:
    

file-like object

export_to_file(_path_ , _options =None_)
    

Export the project to a file

Parameters:
    

  * **path** (_str_) – the path of the file in which the exported project should be saved

  * **options** (_dict_) – 

Dictionary of export options (defaults to **{}**). The following options are available:

    * **exportUploads** (boolean): Exports the data of Uploaded datasets (default to **False**)

    * **exportManagedFS** (boolean): Exports the data of managed Filesystem datasets (default to **False**)

    * **exportAnalysisModels** (boolean): Exports the models trained in analysis (default to **False**)

    * **exportSavedModels** (boolean): Exports the models trained in saved models (default to **False**)

    * **exportModelEvaluationStores** (boolean): Exports the evaluation stores (default to **False**)

    * **exportManagedFolders** (boolean): Exports the data of managed folders (default to **False**)

    * **exportAllInputDatasets** (boolean): Exports the data of all input datasets (default to **False**)

    * **exportAllDatasets** (boolean): Exports the data of all datasets (default to **False**)

    * **exportAllInputManagedFolders** (boolean): Exports the data of all input managed folders (default to **False**)

    * **exportGitRepository** (boolean): Exports the Git repository history (you must be project admin if git contains a remote with credentials, defaults to **False**)

    * **exportInsightsData** (boolean): Exports the data of static insights (default to **False**)

    * **exportPromptStudioHistories** (boolean): Exports the prompt studio execution histories (default to **False**)




duplicate(_target_project_key_ , _target_project_name_ , _duplication_mode ='MINIMAL'_, _export_analysis_models =True_, _export_saved_models =True_, _export_git_repository =None_, _export_insights_data =True_, _remapping =None_, _target_project_folder =None_)
    

Duplicate the project

Parameters:
    

  * **target_project_key** (_str_) – The key of the new project

  * **target_project_name** (_str_) – The name of the new project

  * **duplication_mode** (_str_) – can be one of the following values: MINIMAL, SHARING, FULL, NONE (defaults to **MINIMAL**)

  * **export_analysis_models** (_bool_) – (defaults to **True**)

  * **export_saved_models** (_bool_) – (defaults to **True**)

  * **export_git_repository** (_bool_) – (you must be project admin if git contains a remote with credentials, defaults to **True** if authorized)

  * **export_insights_data** (_bool_) – (defaults to **True**)

  * **remapping** (_dict_) – dict of connections to be remapped for the new project (defaults to **{}**)

  * **target_project_folder** (A [`dataikuapi.dss.projectfolder.DSSProjectFolder`](<project-folders.html#dataikuapi.dss.projectfolder.DSSProjectFolder> "dataikuapi.dss.projectfolder.DSSProjectFolder")) – the project folder where to put the duplicated project (defaults to **None**)



Returns:
    

A dict containing the original and duplicated project’s keys

Return type:
    

dict

get_metadata()
    

Get the metadata attached to this project. The metadata contains label, description checklists, tags and custom metadata of the project.

Note

For more information on available metadata, please see <https://doc.dataiku.com/dss/api/latest/rest/>

Returns:
    

the project metadata.

Return type:
    

dict

set_metadata(_metadata_)
    

Set the metadata on this project.

Usage example:
    
    
    project_metadata = project.get_metadata()
    project_metadata['tags'] = ['tag1','tag2']
    project.set_metadata(project_metadata)
    

Parameters:
    

**metadata** (_dict_) – the new state of the metadata for the project. You should only set a metadata object that has been retrieved using the `get_metadata()` call.

get_settings()
    

Gets the settings of this project. This does not contain permissions. See `get_permissions()`

Returns:
    

a handle to read, modify and save the settings

Return type:
    

`dataikuapi.dss.project.DSSProjectSettings`

get_permissions()
    

Get the permissions attached to this project

Returns:
    

A dict containing the owner and the permissions, as a list of pairs of group name and permission type

Return type:
    

dict

set_permissions(_permissions_)
    

Sets the permissions on this project

Usage example:
    
    
    project_permissions = project.get_permissions()
    project_permissions['permissions'].append({'group':'data_scientists',
                                                'readProjectContent': True,
                                                'readDashboards': True})
    project.set_permissions(project_permissions)
    

Parameters:
    

**permissions** (_dict_) – a permissions object with the same structure as the one returned by `get_permissions()` call

get_interest()
    

Get the interest of this project. The interest means the number of watchers and the number of stars.

Returns:
    

a dict object containing the interest of the project with two fields:

  * **starCount** : number of stars for this project

  * **watchCount** : number of users watching this project




Return type:
    

dict

get_timeline(_item_count =100_)
    

Get the timeline of this project. The timeline consists of information about the creation of this project (by whom, and when), the last modification of this project (by whom and when), a list of contributors, and a list of modifications. This list of modifications contains a maximum of **item_count** elements (default to 100). If **item_count** is greater than the real number of modification, **item_count** is adjusted.

Parameters:
    

**item_count** (_int_) – maximum number of modifications to retrieve in the items list

Returns:
    

a timeline where the top-level fields are :

  * **allContributors** : all contributors who have been involved in this project

  * **items** : a history of the modifications of the project

  * **createdBy** : who created this project

  * **createdOn** : when the project was created

  * **lastModifiedBy** : who modified this project for the last time

  * **lastModifiedOn** : when this modification took place




Return type:
    

dict

generate_ai_description(_language ='english'_, _purpose ='generic'_, _length ='medium'_, _save_description =False_)
    

Generates an AI-powered description for this project.

This function operates with a two-tier rate limit per license:
    

  1. Up to 1000 requests per day.

  2. **Throttled Mode:** After the daily limit, the API’s response time is slowed.
    

Each subsequent call will take approximately 60 seconds to process and return a response.




Note: The “Generate Metadata” option must be enabled in the AI Services admin settings.

Parameters:
    

  * **language** (_str_) – The language of the generated description. Supported languages are “dutch”, “english”, “french”, “german”, “portuguese”, and “spanish” (defaults to **english**).

  * **purpose** (_str_) – The purpose of the generated description. Supported purposes are “generic”, “technical”, “business_oriented”, and “executive” (defaults to **generic**).

  * **length** (_str_) – The length of the generated description. Supported lengths are “low”, “medium”, and “high” (defaults to **medium**).

  * **save_description** (_bool_) – To save the generated description to this project (defaults to **False**).



Returns:
    

a message upon successful completion of the generated AI description. Only contains one msg field. For example, {‘msg’: ‘An example description generated by AI’}

Return type:
    

dict

list_datasets(_as_type ='listitems'_, _include_shared =False_, _tags =None_)
    

List the datasets in this project.

Parameters:
    

  * **as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**).

  * **include_shared** (_boolean_) – If **True** , also lists the datasets from other projects that are shared in this project (defaults to **False**).

  * **tags** (_list_ _[__str_ _]_) – List of tags. The query will only return datasets having one of these tags, but no filter by tags will be applied if tags is set to **None** or to **[]** (defaults to **None**).



Returns:
    

The list of the datasets. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.dataset.DSSDatasetListItem`](<datasets.html#dataikuapi.dss.dataset.DSSDatasetListItem> "dataikuapi.dss.dataset.DSSDatasetListItem"). If “as_type” is “objects”, each one as a [`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

Return type:
    

list

get_dataset(_dataset_name_)
    

Get a handle to interact with a specific dataset

Parameters:
    

**dataset_name** (_str_) – the name of the desired dataset

Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

create_dataset(_dataset_name_ , _type_ , _params =None_, _formatType =None_, _formatParams =None_)
    

Create a new dataset in the project, and return a handle to interact with it.

The precise structure of **params** and **formatParams** depends on the specific dataset type and dataset format type. To know which fields exist for a given dataset type and format type, create a dataset from the UI, and use `get_dataset()` to retrieve the configuration of the dataset and inspect it. Then reproduce a similar structure in the `create_dataset()` call.

Not all settings of a dataset can be set at creation time (for example partitioning). After creation, you’ll have the ability to modify the dataset

Parameters:
    

  * **dataset_name** (_str_) – the name of the dataset to create. Must not already exist

  * **type** (_str_) – the type of the dataset

  * **params** (_dict_) – the parameters for the type, as a python dict (defaults to **{}**)

  * **formatType** (_str_) – an optional format to create the dataset with (only for file-oriented datasets)

  * **formatParams** (_dict_) – the parameters to the format, as a python dict (only for file-oriented datasets, default to **{}**)



Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

create_upload_dataset(_dataset_name_ , _connection =None_)
    

Create a new dataset of type ‘UploadedFiles’ in the project, and return a handle to interact with it.

Parameters:
    

  * **dataset_name** (_str_) – the name of the dataset to create. Must not already exist

  * **connection** (_str_) – the name of the upload connection (defaults to **None**)



Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

create_sample_dataset(_dataset_name_ , _plugin_ , _sample_ , _version =None_)
    

Create a new dataset of type ‘Sample’ in the project, and return a handle to interact with it.

Parameters:
    

  * **dataset_name** (_str_) – the name of the dataset to create. Must not already exist

  * **plugin** (_str_) – the name of the plugin used as a reference. Must exist

  * **sample** (_str_) – the name of the sample component inside the plugin. Must exist

  * **version** (_str_) – the version of the sample component inside the plugin, if unset, the preferred version of the sample will be created. Optional.



Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

create_filesystem_dataset(_dataset_name_ , _connection_ , _path_in_connection_)
    

Create a new filesystem dataset in the project, and return a handle to interact with it.

Parameters:
    

  * **dataset_name** (_str_) – the name of the dataset to create. Must not already exist

  * **connection** (_str_) – the name of the connection

  * **path_in_connection** (_str_) – the path of the dataset in the connection



Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

create_s3_dataset(_dataset_name_ , _connection_ , _path_in_connection_ , _bucket =None_)
    

Creates a new external S3 dataset in the project and returns a [`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset") to interact with it.

The created dataset does not have its format and schema initialized, it is recommended to use [`autodetect_settings()`](<datasets.html#dataikuapi.dss.dataset.DSSDataset.autodetect_settings> "dataikuapi.dss.dataset.DSSDataset.autodetect_settings") on the returned object

Parameters:
    

  * **dataset_name** (_str_) – the name of the dataset to create. Must not already exist

  * **connection** (_str_) – the name of the connection

  * **path_in_connection** (_str_) – the path of the dataset in the connection

  * **bucket** (_str_) – the name of the s3 bucket (defaults to **None**)



Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

create_gcs_dataset(_dataset_name_ , _connection_ , _path_in_connection_ , _bucket =None_)
    

Creates a new external GCS dataset in the project and returns a [`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset") to interact with it.

The created dataset does not have its format and schema initialized, it is recommended to use [`autodetect_settings()`](<datasets.html#dataikuapi.dss.dataset.DSSDataset.autodetect_settings> "dataikuapi.dss.dataset.DSSDataset.autodetect_settings") on the returned object

Parameters:
    

  * **dataset_name** (_str_) – the name of the dataset to create. Must not already exist

  * **connection** (_str_) – the name of the connection

  * **path_in_connection** (_str_) – the path of the dataset in the connection

  * **bucket** (_str_) – the name of the GCS bucket (defaults to **None**)



Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

create_azure_blob_dataset(_dataset_name_ , _connection_ , _path_in_connection_ , _container =None_)
    

Creates a new external Azure dataset in the project and returns a [`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset") to interact with it.

The created dataset does not have its format and schema initialized, it is recommended to use [`autodetect_settings()`](<datasets.html#dataikuapi.dss.dataset.DSSDataset.autodetect_settings> "dataikuapi.dss.dataset.DSSDataset.autodetect_settings") on the returned object

Parameters:
    

  * **dataset_name** (_str_) – the name of the dataset to create. Must not already exist

  * **connection** (_str_) – the name of the connection

  * **path_in_connection** (_str_) – the path of the dataset in the connection

  * **container** (_str_) – the name of the storage account container (defaults to **None**)



Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

create_fslike_dataset(_dataset_name_ , _dataset_type_ , _connection_ , _path_in_connection_ , _extra_params =None_)
    

Create a new file-based dataset in the project, and return a handle to interact with it.

Parameters:
    

  * **dataset_name** (_str_) – the name of the dataset to create. Must not already exist

  * **dataset_type** (_str_) – the type of the dataset

  * **connection** (_str_) – the name of the connection

  * **path_in_connection** (_str_) – the path of the dataset in the connection

  * **extra_params** (_dict_) – a python dict of extra parameters (defaults to **None**)



Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

create_sql_table_dataset(_dataset_name_ , _type_ , _connection_ , _table_ , _schema_ , _catalog =None_)
    

Create a new SQL table dataset in the project, and return a handle to interact with it.

Parameters:
    

  * **dataset_name** (_str_) – the name of the dataset to create. Must not already exist

  * **type** (_str_) – the type of the dataset

  * **connection** (_str_) – the name of the connection

  * **table** (_str_) – the name of the table in the connection

  * **schema** (_str_) – the schema of the table

  * **catalog** (_str_) – [optional] the catalog of the table



Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

new_managed_dataset_creation_helper(_dataset_name_)
    

Caution

Deprecated. Please use `new_managed_dataset()`

new_managed_dataset(_dataset_name_)
    

Initializes the creation of a new managed dataset. Returns a [`dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper`](<datasets.html#dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper> "dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper") or one of its subclasses to complete the creation of the managed dataset.

Usage example:
    
    
    builder = project.new_managed_dataset("my_dataset")
    builder.with_store_into("target_connection")
    dataset = builder.create()
    

Parameters:
    

**dataset_name** (_str_) – Name of the dataset to create

Returns:
    

An object to create the managed dataset

Return type:
    

[`dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper`](<datasets.html#dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper> "dataikuapi.dss.dataset.DSSManagedDatasetCreationHelper")

get_labeling_task(_labeling_task_id_)
    

Get a handle to interact with a specific labeling task

Parameters:
    

**labeling_task_id** (_str_) – the id of the desired labeling task

Returns:
    

A labeling task handle

Return type:
    

`dataikuapi.dss.labeling_task.DSSLabelingTask`

list_streaming_endpoints(_as_type ='listitems'_)
    

List the streaming endpoints in this project.

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**).

Returns:
    

The list of the streaming endpoints. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.streaming_endpoint.DSSStreamingEndpointListItem`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpointListItem> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpointListItem"). If “as_type” is “objects”, each one as a [`dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")

Return type:
    

list

get_streaming_endpoint(_streaming_endpoint_name_)
    

Get a handle to interact with a specific streaming endpoint

Parameters:
    

**streaming_endpoint_name** (_str_) – the name of the desired streaming endpoint

Returns:
    

A streaming endpoint handle

Return type:
    

[`dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")

create_streaming_endpoint(_streaming_endpoint_name_ , _type_ , _params =None_)
    

Create a new streaming endpoint in the project, and return a handle to interact with it.

The precise structure of **params** depends on the specific streaming endpoint type. To know which fields exist for a given streaming endpoint type, create a streaming endpoint from the UI, and use `get_streaming_endpoint()` to retrieve the configuration of the streaming endpoint and inspect it. Then reproduce a similar structure in the `create_streaming_endpoint()` call.

Not all settings of a streaming endpoint can be set at creation time (for example partitioning). After creation, you’ll have the ability to modify the streaming endpoint.

Parameters:
    

  * **streaming_endpoint_name** (_str_) – the name for the new streaming endpoint

  * **type** (_str_) – the type of the streaming endpoint

  * **params** (_dict_) – the parameters for the type, as a python dict (defaults to **{}**)



Returns:
    

A streaming endpoint handle

Return type:
    

[`dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")

create_kafka_streaming_endpoint(_streaming_endpoint_name_ , _connection =None_, _topic =None_)
    

Create a new kafka streaming endpoint in the project, and return a handle to interact with it.

Parameters:
    

  * **streaming_endpoint_name** (_str_) – the name for the new streaming endpoint

  * **connection** (_str_) – the name of the kafka connection (defaults to **None**)

  * **topic** (_str_) – the name of the kafka topic (defaults to **None**)



Returns:
    

A streaming endpoint handle

Return type:
    

[`dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")

create_httpsse_streaming_endpoint(_streaming_endpoint_name_ , _url =None_)
    

Create a new https streaming endpoint in the project, and return a handle to interact with it.

Parameters:
    

  * **streaming_endpoint_name** (_str_) – the name for the new streaming endpoint

  * **url** (_str_) – the url of the endpoint (defaults to **None**)



Returns:
    

A streaming endpoint handle

Return type:
    

[`dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")

new_managed_streaming_endpoint(_streaming_endpoint_name_ , _streaming_endpoint_type =None_)
    

Initializes the creation of a new streaming endpoint. Returns a [`dataikuapi.dss.streaming_endpoint.DSSManagedStreamingEndpointCreationHelper`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSManagedStreamingEndpointCreationHelper> "dataikuapi.dss.streaming_endpoint.DSSManagedStreamingEndpointCreationHelper") to complete the creation of the streaming endpoint

Parameters:
    

  * **streaming_endpoint_name** (_str_) – Name of the new streaming endpoint - must be unique in the project

  * **streaming_endpoint_type** (_str_) – Type of the new streaming endpoint (optional if it can be inferred from a connection type)



Returns:
    

An object to create the streaming endpoint

Return type:
    

[`DSSManagedStreamingEndpointCreationHelper`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSManagedStreamingEndpointCreationHelper> "dataikuapi.dss.streaming_endpoint.DSSManagedStreamingEndpointCreationHelper")

create_prediction_ml_task(_input_dataset_ , _target_variable_ , _ml_backend_type ='PY_MEMORY'_, _guess_policy ='DEFAULT'_, _prediction_type =None_, _wait_guess_complete =True_)
    

Creates a new prediction task in a new visual analysis lab for a dataset.

Parameters:
    

  * **input_dataset** (_str_) – the dataset to use for training/testing the model

  * **target_variable** (_str_) – the variable to predict

  * **ml_backend_type** (_str_) – ML backend to use, one of PY_MEMORY, MLLIB or H2O (defaults to **PY_MEMORY**)

  * **guess_policy** (_str_) – Policy to use for setting the default parameters. Valid values are: DEFAULT, SIMPLE_FORMULA, DECISION_TREE, EXPLANATORY and PERFORMANCE (defaults to **DEFAULT**)

  * **prediction_type** (_str_) – The type of prediction problem this is. If not provided the prediction type will be guessed. Valid values are: BINARY_CLASSIFICATION, REGRESSION, MULTICLASS (defaults to **None**)

  * **wait_guess_complete** (_boolean_) – if False, the returned ML task will be in ‘guessing’ state, i.e. analyzing the input dataset to determine feature handling and algorithms (defaults to **True**). You should wait for the guessing to be completed by calling **wait_guess_complete** on the returned object before doing anything else (in particular calling **train** or **get_settings**)



Returns:
    

A ML task handle of type ‘PREDICTION’

Return type:
    

[`dataikuapi.dss.ml.DSSMLTask`](<ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask")

create_clustering_ml_task(_input_dataset_ , _ml_backend_type ='PY_MEMORY'_, _guess_policy ='KMEANS'_, _wait_guess_complete =True_)
    

Creates a new clustering task in a new visual analysis lab for a dataset.

The returned ML task will be in ‘guessing’ state, i.e. analyzing the input dataset to determine feature handling and algorithms.

You should wait for the guessing to be completed by calling **wait_guess_complete** on the returned object before doing anything else (in particular calling **train** or **get_settings**)

Parameters:
    

  * **ml_backend_type** (_str_) – ML backend to use, one of PY_MEMORY, MLLIB or H2O (defaults to **PY_MEMORY**)

  * **guess_policy** (_str_) – Policy to use for setting the default parameters. Valid values are: KMEANS and ANOMALY_DETECTION (defaults to **KMEANS**)

  * **wait_guess_complete** (_boolean_) – if False, the returned ML task will be in ‘guessing’ state, i.e. analyzing the input dataset to determine feature handling and algorithms (defaults to **True**). You should wait for the guessing to be completed by calling **wait_guess_complete** on the returned object before doing anything else (in particular calling **train** or **get_settings**)



Returns:
    

A ML task handle of type ‘CLUSTERING’

Return type:
    

[`dataikuapi.dss.ml.DSSMLTask`](<ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask")

create_timeseries_forecasting_ml_task(_input_dataset_ , _target_variable_ , _time_variable_ , _timeseries_identifiers =None_, _guess_policy ='TIMESERIES_DEFAULT'_, _wait_guess_complete =True_)
    

Creates a new time series forecasting task in a new visual analysis lab for a dataset.

Parameters:
    

  * **input_dataset** (_string_) – The dataset to use for training/testing the model

  * **target_variable** (_string_) – The variable to forecast

  * **time_variable** (_string_) – Column to be used as time variable. Should be a Date (parsed) column.

  * **timeseries_identifiers** (_list_) – List of columns to be used as time series identifiers (when the dataset has multiple series)

  * **guess_policy** (_string_) – Policy to use for setting the default parameters. Valid values are: TIMESERIES_DEFAULT, TIMESERIES_STATISTICAL, and TIMESERIES_DEEP_LEARNING

  * **wait_guess_complete** (_boolean_) – If False, the returned ML task will be in ‘guessing’ state, i.e. analyzing the input dataset to determine feature handling and algorithms. You should wait for the guessing to be completed by calling `wait_guess_complete` on the returned object before doing anything else (in particular calling `train` or `get_settings`)



Returns:
    

`dataiku.dss.ml.DSSMLTask`

create_causal_prediction_ml_task(_input_dataset_ , _outcome_variable_ , _treatment_variable_ , _prediction_type =None_, _wait_guess_complete =True_)
    

Creates a new causal prediction task in a new visual analysis lab for a dataset.

Parameters:
    

  * **input_dataset** (_string_) – The dataset to use for training/testing the model

  * **outcome_variable** (_string_) – The outcome to predict.

  * **treatment_variable** (_string_) – Column to be used as treatment variable.

  * **prediction_type** (_string_ _or_ _None_) – Valid values are: “CAUSAL_BINARY_CLASSIFICATION”, “CAUSAL_REGRESSION” or None (in this case prediction_type will be set by the Guesser)

  * **wait_guess_complete** (_boolean_) – If False, the returned ML task will be in ‘guessing’ state, i.e. analyzing the input dataset to determine feature handling and algorithms. You should wait for the guessing to be completed by calling `wait_guess_complete` on the returned object before doing anything else (in particular calling `train` or `get_settings`)



Returns:
    

`dataiku.dss.ml.DSSMLTask`

list_ml_tasks()
    

List the ML tasks in this project

Returns:
    

the list of the ML tasks summaries, each one as a python dict

Return type:
    

list

get_ml_task(_analysis_id_ , _mltask_id_)
    

Get a handle to interact with a specific ML task

Parameters:
    

  * **analysis_id** (_str_) – the identifier of the visual analysis containing the desired ML task

  * **mltask_id** (_str_) – the identifier of the desired ML task



Returns:
    

A ML task handle

Return type:
    

[`dataikuapi.dss.ml.DSSMLTask`](<ml.html#dataikuapi.dss.ml.DSSMLTask> "dataikuapi.dss.ml.DSSMLTask")

list_mltask_queues()
    

List non-empty ML task queues in this project

Returns:
    

an iterable listing of MLTask queues (each a dict)

Return type:
    

`dataikuapi.dss.ml.DSSMLTaskQueues`

create_analysis(_input_dataset_)
    

Creates a new visual analysis lab for a dataset.

Parameters:
    

**input_dataset** (_str_) – the dataset to use for the analysis

Returns:
    

A visual analysis handle

Return type:
    

`dataikuapi.dss.analysis.DSSAnalysis`

list_analyses()
    

List the visual analyses in this project

Returns:
    

the list of the visual analyses summaries, each one as a python dict

Return type:
    

list

get_analysis(_analysis_id_)
    

Get a handle to interact with a specific visual analysis

Parameters:
    

**analysis_id** (_str_) – the identifier of the desired visual analysis

Returns:
    

A visual analysis handle

Return type:
    

`dataikuapi.dss.analysis.DSSAnalysis`

list_saved_models()
    

List the saved models in this project

Returns:
    

the list of the saved models, each one as a python dict

Return type:
    

list[[DSSSavedModel](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel")]

get_saved_model(_sm_id_)
    

Get a handle to interact with a specific saved model

Parameters:
    

**sm_id** (_str_) – the identifier of the desired saved model

Returns:
    

A saved model handle

Return type:
    

[`dataikuapi.dss.savedmodel.DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel")

create_mlflow_pyfunc_model(_name_ , _prediction_type =None_)
    

Creates a new external saved model for storing and managing MLFlow models

Parameters:
    

  * **name** (_str_) – Human readable name for the new saved model in the flow

  * **prediction_type** (_str_) – Optional (but needed for most operations). One of BINARY_CLASSIFICATION, MULTICLASS, REGRESSION or None. Defaults to None, standing for other prediction types. If the Saved Model has a None prediction type, scoring, inclusion in a bundle or in an API service will be possible, but features related to performance analysis and explainability will not be available.



Returns:
    

The created saved model handle

Return type:
    

[`dataikuapi.dss.savedmodel.DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel")

create_finetuned_llm_saved_model(_name_)
    

Creates a new finetuned LLM Saved Model for finetuning using Python code

Parameters:
    

**name** (_str_) – Human-readable name for the new saved model in the flow

Returns:
    

The created saved model handle

Return type:
    

[`dataikuapi.dss.savedmodel.DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel")

create_external_model(_name_ , _prediction_type_ , _configuration_)
    

Creates a new Saved model that can contain external remote endpoints as versions.

Parameters:
    

  * **name** (_string_) – Human-readable name for the new saved model in the flow

  * **prediction_type** (_string_) – One of BINARY_CLASSIFICATION, MULTICLASS or REGRESSION

  * **configuration** (_dict_) – 

A dictionary containing the desired external saved model configuration.

    * For SageMaker, the syntax is:
          
          configuration = {
              "protocol": "sagemaker",
              "region": "<region-name>"
              "connection": "<connection-name>"
          }
          

Where the parameters have the following meaning:

      * `region`: The AWS region of the endpoint, e.g. `eu-west-1`

      * `connection`: (optional) The DSS SageMaker connection to use for authentication. If not defined, credentials will be derived from environment. See the reference documentation for details.

    * For Databricks, the syntax is:
          
          configuration = {
              "protocol": "databricks",
              "connection": "<connection-name>"
          }
          

    * For AzureML, syntax is:
          
          configuration = {
              "protocol": "azure-ml",
              "connection": "<connection-name>",
              "subscription_id": "<id>",
              "resource_group": "<rg>",
              "workspace": "<workspace>"
          }
          

Where the parameters have the following meaning:

      * `connection`: (optional) The DSS Azure ML connection to use for authentication. If not defined, credentials will be derived from environment. See the reference documentation for details.

      * `subscription_id`: The Azure subscription ID

      * `resource_group`: The Azure resource group

      * `workspace`: The Azure ML workspace

    * For Vertex AI, syntax is:
          
          configuration = {
              "protocol": "vertex-ai",
              "region": "<region-name>"
              "connection": "<connection-name>",
              "project_id": "<name> or <id>"
          }
          

Where the parameters have the following meaning:

      * `region`: The GCP region of the endpoint, e.g. `europe-west-1`

      * `connection`: (optional) The DSS Vertex AI connection to use for authentication. If not defined, credentials will be derived from environment. See the reference documentation for details.

      * `project_id`: The ID or name of the GCP project




  * Example: create a saved model for SageMaker endpoints serving binary classification models in region eu-west-1
        
        import dataiku
        client = dataiku.api_client()
        project = client.get_default_project()
        configuration = {
            "protocol": "sagemaker",
            "region": "eu-west-1"
        }
        sm = project.create_external_model("SaveMaker Proxy Model", "BINARY_CLASSIFICATION", configuration)
        

  * Example: create a saved model for Vertex AI endpoints serving regression models in region eu-west-1, on project “my-project”, performing authentication using DSS connection “vertex_conn” of type “Vertex AI”.
        
        import dataiku
        client = dataiku.api_client()
        project = client.get_default_project()
        configuration = {
            "protocol": "vertex-ai",
            "region": "europe-west1",
            "connection": "vertex_conn"
            "project_id": "my-project"
        }
        sm = project.create_external_model("Vertex AI Proxy Model", "BINARY_CLASSIFICATION", configuration)
        




list_managed_folders()
    

List the managed folders in this project

Returns:
    

the list of the managed folders, each one as a python dict

Return type:
    

list

get_managed_folder(_odb_id_)
    

Get a handle to interact with a specific managed folder

Parameters:
    

**odb_id** (_str_) – the identifier of the desired managed folder

Returns:
    

A managed folder handle

Return type:
    

[`dataikuapi.dss.managedfolder.DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder")

create_managed_folder(_name_ , _folder_type =None_, _connection_name ='filesystem_folders'_)
    

Create a new managed folder in the project, and return a handle to interact with it

Parameters:
    

  * **name** (_str_) – the name of the managed folder

  * **folder_type** (_str_) – type of storage (defaults to **None**)

  * **connection_name** (_str_) – the connection name (defaults to **filesystem_folders**)



Returns:
    

A managed folder handle

Return type:
    

[`dataikuapi.dss.managedfolder.DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder")

list_model_evaluation_stores()
    

List the model evaluation stores in this project.

Returns:
    

The list of the model evaluation stores

Return type:
    

list of [`dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore")

list_evaluation_stores(_flavor =None_)
    

List the evaluation stores in this project.

Parameters:
    

**flavor** (_str_) – either “TABULAR”, “LLM” or “AGENT” (optional). If specified, will only return evaluation stores of that flavor. If not, will return evaluation stores of flavors “TABULAR” and “LLM”

Returns:
    

The list of the model evaluation stores

Return type:
    

list of `dataikuapi.dss.evaluationstore.DSSEvaluationStore`

get_model_evaluation_store(_mes_id_)
    

Get a handle to interact with a specific model evaluation store

Parameters:
    

**mes_id** (_str_) – the id of the desired model evaluation store

Returns:
    

A model evaluation store handle

Return type:
    

[`dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore")

get_evaluation_store(_evaluation_store_id_)
    

Get a handle to interact with a specific evaluation store

Parameters:
    

**evaluation_store_id** (_str_) – the id of the desired evaluation store

Returns:
    

A model evaluation store handle

Return type:
    

`dataikuapi.dss.evaluationstore.DSSEvaluationStore`

create_model_evaluation_store(_name_)
    

Create a new model evaluation store in the project, and return a handle to interact with it.

Parameters:
    

**name** (_str_) – the name for the new model evaluation store

Returns:
    

A model evaluation store handle

Return type:
    

[`dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore")

create_evaluation_store(_name_ , _flavor_)
    

Create a new evaluation store in the project, and return a handle to interact with it.

Parameters:
    

  * **name** (_str_) – the name for the new model evaluation store

  * **flavor** (_str_) – the flavor of evaluation store that should be created. Either “TABULAR”, “AGENT”, or “LLM”



Returns:
    

An evaluation store handle

Return type:
    

`dataikuapi.dss.evaluationstore.DSSEvaluationStore`

list_model_comparisons()
    

List the model comparisons in this project.

Returns:
    

The list of the model comparisons

Return type:
    

list

list_evaluation_comparisons(_model_task_types =None_)
    

List the evaluation comparisons in this project.

Parameters:
    

**model_task_types** (_list_ _[__str_ _]_) – (optional) a list comprised of one or more of the following: “BINARY_CLASSIFICATION”, “REGRESSION”, “MULTICLASS”, “TIMESERIES_FORECASTING”, “CAUSAL_BINARY_CLASSIFICATION”, “CAUSAL_REGRESSION”, “LLM”, “AGENT”. If specified, will only return evaluation comparisons of the given types. If not, will return comparisons of types “BINARY_CLASSIFICATION”, “REGRESSION”, “MULTICLASS”, “TIMESERIES_FORECASTING”, “CAUSAL_BINARY_CLASSIFICATION”, “CAUSAL_REGRESSION” and “LLM”

Returns:
    

The list of the evaluation comparisons

Return type:
    

list

get_model_comparison(_mec_id_)
    

Get a handle to interact with a specific model comparison

Parameters:
    

**mec_id** (_str_) – the id of the desired model comparison

Returns:
    

A model comparison handle

Return type:
    

`dataikuapi.dss.modelcomparison.DSSModelComparison`

get_evaluation_comparison(_comparison_id_)
    

Get a handle to interact with a specific evaluation comparison

Parameters:
    

**comparison_id** (_str_) – the id of the desired evaluation comparison

Returns:
    

A model comparison handle

Return type:
    

`dataikuapi.dss.evaluationcomparison.DSSEvaluationComparison`

create_model_comparison(_name_ , _prediction_type_)
    

Create a new model comparison in the project, and return a handle to interact with it.

Parameters:
    

  * **name** (_str_) – the name for the new model comparison

  * **prediction_type** (_str_) – one of BINARY_CLASSIFICATION, REGRESSION, MULTICLASS, TIMESERIES_FORECAST, CAUSAL_BINARY_CLASSIFICATION, CAUSAL_REGRESSION



Returns:
    

A new model comparison handle

Return type:
    

`dataikuapi.dss.modelcomparison.DSSModelComparison`

create_evaluation_comparison(_name_ , _model_task_type_)
    

Create a new evaluation comparison in the project, and return a handle to interact with it.

Parameters:
    

  * **name** (_str_) – the name for the new model comparison

  * **model_task_type** (_str_) – one of BINARY_CLASSIFICATION, REGRESSION, MULTICLASS, TIMESERIES_FORECAST, CAUSAL_BINARY_CLASSIFICATION, CAUSAL_REGRESSION, LLM, AGENT



Returns:
    

A new evaluation comparison handle

Return type:
    

`dataikuapi.dss.evaluation.DSSEvaluationComparison`

list_jobs()
    

List the jobs in this project

Returns:
    

a list of the jobs, each one as a python dict, containing both the definition and the state

Return type:
    

list

get_job(_id_)
    

Get a handler to interact with a specific job

Parameters:
    

**id** (_str_) – the id of the desired job

Returns:
    

A job handle

Return type:
    

[`dataikuapi.dss.job.DSSJob`](<jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob")

start_job(_definition_)
    

Create a new job, and return a handle to interact with it

Parameters:
    

**definition** (_dict_) – 

The definition should contain:

  * the type of job (RECURSIVE_BUILD, NON_RECURSIVE_FORCED_BUILD, RECURSIVE_FORCED_BUILD, RECURSIVE_MISSING_ONLY_BUILD)

  * a list of outputs to build from the available types: (DATASET, MANAGED_FOLDER, SAVED_MODEL, STREAMING_ENDPOINT, KNOWLEDGE_BANK)

  * (Optional) a refreshHiveMetastore field (True or False) to specify whether to re-synchronize the Hive metastore for recomputed HDFS datasets.

  * (Optional) a autoUpdateSchemaBeforeEachRecipeRun field (True or False) to specify whether to auto update the schema before each recipe run.




Returns:
    

A job handle

Return type:
    

[`dataikuapi.dss.job.DSSJob`](<jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob")

start_job_and_wait(_definition_ , _no_fail =False_)
    

Starts a new job and waits for it to complete.

Parameters:
    

  * **definition** (_dict_) – 

The definition should contain:

    * the type of job (RECURSIVE_BUILD, NON_RECURSIVE_FORCED_BUILD, RECURSIVE_FORCED_BUILD, RECURSIVE_MISSING_ONLY_BUILD)

    * a list of outputs to build from the available types: (DATASET, MANAGED_FOLDER, SAVED_MODEL, STREAMING_ENDPOINT, KNOWLEDGE_BANK)

    * (Optional) a refreshHiveMetastore field (True or False) to specify whether to re-synchronize the Hive metastore for recomputed HDFS datasets.

    * (Optional) a autoUpdateSchemaBeforeEachRecipeRun field (True or False) to specify whether to auto update the schema before each recipe run.

  * **no_fail** (_bool_) – if true, the function won’t fail even if the job fails or aborts (defaults to **False**)



Returns:
    

the final status of the job

Return type:
    

str

new_job(_job_type ='NON_RECURSIVE_FORCED_BUILD'_)
    

Create a job to be run. You need to add outputs to the job (i.e. what you want to build) before running it.
    
    
    job_builder = project.new_job()
    job_builder.with_output("mydataset")
    complete_job = job_builder.start_and_wait()
    print("Job %s done" % complete_job.id)
    

Parameters:
    

**job_type** (_str_) – the type of job (RECURSIVE_BUILD, NON_RECURSIVE_FORCED_BUILD, RECURSIVE_FORCED_BUILD, RECURSIVE_MISSING_ONLY_BUILD) (defaults to NON_RECURSIVE_FORCED_BUILD)

Returns:
    

A job handle

Return type:
    

[`dataikuapi.dss.project.JobDefinitionBuilder`](<jobs.html#dataikuapi.dss.project.JobDefinitionBuilder> "dataikuapi.dss.project.JobDefinitionBuilder")

new_job_definition_builder(_job_type ='NON_RECURSIVE_FORCED_BUILD'_)
    

Caution

Deprecated. Please use `new_job()`

list_jupyter_notebooks(_active =False_, _as_type ='object'_)
    

List the jupyter notebooks of a project.

Parameters:
    

  * **active** (_bool_) – if True, only return currently running jupyter notebooks (defaults to **active**).

  * **as_type** (_string_) – How to return the list. Supported values are “listitems” and “object” (defaults to **object**).



Returns:
    

The list of the notebooks. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.jupyternotebook.DSSJupyterNotebookListItem`](<other-administration.html#dataikuapi.dss.jupyternotebook.DSSJupyterNotebookListItem> "dataikuapi.dss.jupyternotebook.DSSJupyterNotebookListItem"), if “as_type” is “objects”, each one as a [`dataikuapi.dss.jupyternotebook.DSSJupyterNotebook`](<other-administration.html#dataikuapi.dss.jupyternotebook.DSSJupyterNotebook> "dataikuapi.dss.jupyternotebook.DSSJupyterNotebook")

Return type:
    

list of [`dataikuapi.dss.jupyternotebook.DSSJupyterNotebookListItem`](<other-administration.html#dataikuapi.dss.jupyternotebook.DSSJupyterNotebookListItem> "dataikuapi.dss.jupyternotebook.DSSJupyterNotebookListItem") or list of [`dataikuapi.dss.jupyternotebook.DSSJupyterNotebook`](<other-administration.html#dataikuapi.dss.jupyternotebook.DSSJupyterNotebook> "dataikuapi.dss.jupyternotebook.DSSJupyterNotebook")

get_jupyter_notebook(_notebook_name_)
    

Get a handle to interact with a specific jupyter notebook

Parameters:
    

**notebook_name** (_str_) – The name of the jupyter notebook to retrieve

Returns:
    

A handle to interact with this jupyter notebook

Return type:
    

[`dataikuapi.dss.jupyternotebook.DSSJupyterNotebook`](<other-administration.html#dataikuapi.dss.jupyternotebook.DSSJupyterNotebook> "dataikuapi.dss.jupyternotebook.DSSJupyterNotebook") jupyter notebook handle

create_jupyter_notebook(_notebook_name_ , _notebook_content_)
    

Create a new jupyter notebook and get a handle to interact with it

Parameters:
    

  * **notebook_name** (_str_) – the name of the notebook to create

  * **notebook_content** (_dict_) – the data of the notebook to create, as a dict. The data will be converted to a JSON string internally. Use `DSSJupyterNotebook.get_content()` on a similar existing **DSSJupyterNotebook** object in order to get a sample definition object.



Returns:
    

A handle to interact with the newly created jupyter notebook

Return type:
    

[dataikuapi.dss.jupyternotebook.DSSJupyterNotebook](<other-administration.html#dataikuapi.dss.jupyternotebook.DSSJupyterNotebook> "dataikuapi.dss.jupyternotebook.DSSJupyterNotebook")

list_sql_notebooks(_as_type ='listitems'_)
    

List the SQL notebooks of a project

Parameters:
    

**as_type** (_string_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**)

Returns:
    

The list of the notebooks. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem> "dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem"), if “as_type” is “objects”, each one as a [`dataikuapi.dss.sqlnotebook.DSSSQLNotebook`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSSQLNotebook> "dataikuapi.dss.sqlnotebook.DSSSQLNotebook")

Return type:
    

List of [`dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem> "dataikuapi.dss.sqlnotebook.DSSSQLNotebookListItem") or list of [`dataikuapi.dss.sqlnotebook.DSSSQLNotebook`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSSQLNotebook> "dataikuapi.dss.sqlnotebook.DSSSQLNotebook")

get_sql_notebook(_notebook_id_)
    

Get a handle to interact with a specific SQL notebook

Parameters:
    

**notebook_id** (_string_) – The id of the SQL notebook to retrieve

Returns:
    

A handle to interact with this SQL notebook

Return type:
    

[`dataikuapi.dss.sqlnotebook.DSSSQLNotebook`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSSQLNotebook> "dataikuapi.dss.sqlnotebook.DSSSQLNotebook") SQL notebook handle

create_sql_notebook(_notebook_content_)
    

Create a new SQL notebook and get a handle to interact with it

Parameters:
    

**notebook_content** (_dict_) – The data of the notebook to create, as a dict. The data will be converted to a JSON string internally. Use `DSSSQLNotebook.get_content()` on a similar existing **DSSSQLNotebook** object in order to get a sample definition object

Returns:
    

A handle to interact with the newly created SQL notebook

Return type:
    

[`dataikuapi.dss.sqlnotebook.DSSSQLNotebook`](<other-administration.html#dataikuapi.dss.sqlnotebook.DSSSQLNotebook> "dataikuapi.dss.sqlnotebook.DSSSQLNotebook") SQL notebook handle

list_continuous_activities(_as_objects =True_)
    

List the continuous activities in this project

Parameters:
    

**as_objects** (_bool_) – if True, returns a list of [`dataikuapi.dss.continuousactivity.DSSContinuousActivity`](<streaming-endpoints.html#dataikuapi.dss.continuousactivity.DSSContinuousActivity> "dataikuapi.dss.continuousactivity.DSSContinuousActivity") objects, else returns a list of python dicts (defaults to **True**)

Returns:
    

a list of the continuous activities, each one as a python dict, containing both the definition and the state

Return type:
    

list

get_continuous_activity(_recipe_id_)
    

Get a handler to interact with a specific continuous activities

Parameters:
    

**recipe_id** (_str_) – the identifier of the recipe controlled by the continuous activity

Returns:
    

A job handle

Return type:
    

[`dataikuapi.dss.continuousactivity.DSSContinuousActivity`](<streaming-endpoints.html#dataikuapi.dss.continuousactivity.DSSContinuousActivity> "dataikuapi.dss.continuousactivity.DSSContinuousActivity")

get_variables()
    

Gets the variables of this project.

Returns:
    

a dictionary containing two dictionaries : “standard” and “local”. “standard” are regular variables, exported with bundles. “local” variables are not part of the bundles for this project

Return type:
    

dict

set_variables(_obj_)
    

Sets the variables of this project.

Warning

If executed from a python recipe, the changes made by set_variables will not be “seen” in that recipe. Use the internal API dataiku.get_custom_variables() instead if this behavior is needed

Parameters:
    

**obj** (_dict_) – must be a modified version of the object returned by get_variables

update_variables(_variables_ , _type ='standard'_)
    

Updates a set of variables for this project

Parameters:
    

  * **dict** (_variables_) – a dict of variable name -> value to set. Keys of the dict must be strings. Values in the dict can be strings, numbers, booleans, lists or dicts

  * **str** (_type_) – Can be “standard” to update regular variables or “local” to update local-only variables that are not part of bundles for this project (defaults to **standard**)




_property _document_extractor
    

Returns:
    

A handle to interact with a DSS-managed Document Extractor

Return type:
    

[`dataikuapi.dss.document_extractor.DocumentExtractor`](<llm-mesh.html#dataikuapi.dss.document_extractor.DocumentExtractor> "dataikuapi.dss.document_extractor.DocumentExtractor")

render_document_template(_template_type_ , _data_ , _template_str =None_, _template_bytes =None_, _template_ref =None_, _output_format =None_, _output_ref =None_)
    

Render a document template

Parameters:
    

  * **template_type** (_str_) – One of “CEL_EXPANSION”, “JINJA”, “DOCX_JINJA”.

  * **data** (_dict_) – Variables to substitute in the template.

  * **template_str** (_str_) – Template content as string, supported by CEL_EXPANSION and JINJA.

  * **template_bytes** (_bytes_) – Template as bytes, supported by DOCX_JINJA.

  * **template_ref** ([_DocumentRef_](<llm-mesh.html#dataikuapi.dss.document_extractor.DocumentRef> "dataikuapi.dss.document_extractor.DocumentRef")) – Input template document, a managed folder file or inline content.

  * **output_format** (_str_) – Output format, one of “PDF”, “DOCX”, “TEXT”.

  * **output_ref** ([_DocumentRef_](<llm-mesh.html#dataikuapi.dss.document_extractor.DocumentRef> "dataikuapi.dss.document_extractor.DocumentRef")) – Output document to write to, e.g. a managed folder file. When unspecified, return output inline.



Returns:
    

The rendered document

Return type:
    

`dataikuapi.dss.project.DocumentTemplateRenderingResponse`

list_api_services(_as_type ='listitems'_)
    

List the API services in this project

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**).

Returns:
    

The list of the datasets. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.apiservice.DSSAPIServiceListItem`](<api-designer.html#dataikuapi.dss.apiservice.DSSAPIServiceListItem> "dataikuapi.dss.apiservice.DSSAPIServiceListItem"). If “as_type” is “objects”, each one as a [`dataikuapi.dss.apiservice.DSSAPIService`](<api-designer.html#dataikuapi.dss.apiservice.DSSAPIService> "dataikuapi.dss.apiservice.DSSAPIService")

Return type:
    

list

create_api_service(_service_id_)
    

Create a new API service, and returns a handle to interact with it. The newly-created service does not have any endpoint.

Parameters:
    

**service_id** (_str_) – the ID of the API service to create

Returns:
    

A API Service handle

Return type:
    

[`dataikuapi.dss.apiservice.DSSAPIService`](<api-designer.html#dataikuapi.dss.apiservice.DSSAPIService> "dataikuapi.dss.apiservice.DSSAPIService")

get_api_service(_service_id_)
    

Get a handle to interact with a specific API Service from the API Designer

Parameters:
    

**service_id** (_str_) – The identifier of the API Designer API Service to retrieve

Returns:
    

A handle to interact with this API Service

Return type:
    

[`dataikuapi.dss.apiservice.DSSAPIService`](<api-designer.html#dataikuapi.dss.apiservice.DSSAPIService> "dataikuapi.dss.apiservice.DSSAPIService")

list_exported_bundles()
    

List all the bundles created in this project on the Design Node.

Returns:
    

A dictionary of all bundles for a project on the Design node.

Return type:
    

dict

export_bundle(_bundle_id_ , _release_notes =None_, _evaluate_project_standards_checks =True_)
    

Creates a new project bundle on the Design node

Parameters:
    

  * **bundle_id** (_str_) – bundle id tag

  * **release_notes** (_str_) – important changes introduced in the bundle

  * **evaluate_project_standards_checks** – indicates whether the Project Standards Checks applyting to this project should be run




delete_exported_bundle(_bundle_id_)
    

Deletes a project bundle from the Design node :param str bundle_id: bundle id tag

get_exported_bundle_archive_stream(_bundle_id_)
    

Download a bundle archive that can be deployed in a DSS automation Node, as a binary stream.

Warning

The stream must be closed after use. Use a **with** statement to handle closing the stream at the end of the block by default. For example:
    
    
    with project.get_exported_bundle_archive_stream('v1') as fp:
        # use fp
    
    # or explicitly close the stream after use
    fp = project.get_exported_bundle_archive_stream('v1')
    # use fp, then close
    fp.close()
    

Parameters:
    

**bundle_id** (_str_) – the identifier of the bundle

download_exported_bundle_archive_to_file(_bundle_id_ , _path_)
    

Download a bundle archive that can be deployed in a DSS automation Node into the given output file.

Parameters:
    

  * **bundle_id** (_str_) – the identifier of the bundle

  * **path** (_str_) – if “-”, will write to /dev/stdout




publish_bundle(_bundle_id_ , _published_project_key =None_)
    

Publish a bundle on the Project Deployer.

Parameters:
    

  * **bundle_id** (_str_) – The identifier of the bundle

  * **published_project_key** (_str_) – The key of the project on the Project Deployer where the bundle will be published.A new published project will be created if none matches the key. If the parameter is not set, the key from the current `DSSProject` is used.



Returns:
    

a dict with info on the bundle state once published. It contains the keys “publishedOn” for the publish date, “publishedBy” for the user who published the bundle, and “publishedProjectKey” for the key of the Project Deployer project used.

Return type:
    

dict

list_imported_bundles()
    

List all the bundles imported for this project, on the Automation node.

Returns:
    

a dict containing bundle imports for a project, on the Automation node.

Return type:
    

dict

import_bundle_from_archive(_archive_path_)
    

Imports a bundle from a zip archive path on the Automation node.

Parameters:
    

**archive_path** (_str_) – A full path to a zip archive, for example /home/dataiku/my-bundle-v1.zip

import_bundle_from_stream(_fp_)
    

Imports a bundle from a file stream, on the Automation node.

Usage example:
    
    
    project = client.get_project('MY_PROJECT')
    with open('/home/dataiku/my-bundle-v1.zip', 'rb') as f:
        project.import_bundle_from_stream(f)
    

Parameters:
    

**fp** (_file-like_) – file handler.

activate_bundle(_bundle_id_ , _scenarios_to_enable =None_)
    

Activates a bundle in this project.

Parameters:
    

  * **bundle_id** (_str_) – The ID of the bundle to activate

  * **scenarios_to_enable** (_dict_) – An optional dict of scenarios to enable or disable upon bundle activation. The format of the dict should be scenario IDs as keys with values of True or False (defaults to **{}**).



Returns:
    

A report containing any error or warning messages that occurred during bundle activation

Return type:
    

dict

preload_bundle(_bundle_id_)
    

Preloads a bundle that has been imported on the Automation node

Parameters:
    

**bundle_id** (_str_) – the bundle_id for an existing imported bundle

delete_imported_bundle(_bundle_id_)
    

Deletes a bundle that has been imported on the Automation node

Parameters:
    

**bundle_id** (_str_) – The identifier of the bundle

get_last_test_scenario_runs_report(_bundle_id =None_)
    

Download a report describing the outcome of the latest test scenario runs performed in this project. On an Automation node, you can specify a bundle id, otherwise the report concerns the active bundle.

Usage example:
    
    
    project = client.get_project('MY_PROJECT')
    with open('/tmp/report.xml', 'wb') as f:
        f.write(project.get_last_test_scenario_runs_report().content)
    

Parameters:
    

**bundle_id** (_str_ _(__optional_ _)_) – bundle id tag

Returns:
    

the HTTP response to read the report content from, in a JUnit XML format

Return type:
    

`requests.models.Response`

get_last_test_scenario_runs_html_report(_bundle_id =None_)
    

Download a report describing the outcome of the latest test scenario runs performed in this project. On an Automation node, you can specify a bundle id, otherwise the report concerns the active bundle.

Parameters:
    

**bundle_id** (_str_ _(__optional_ _)_) – bundle id tag

Usage example:
    
    
    project = client.get_project('MY_PROJECT')
    with open('/tmp/report.html', 'wb') as f:
        f.write(project.get_last_test_scenario_runs_html_report().content)
    

Returns:
    

the HTTP response to read the report content from, in an HTML format

Return type:
    

`requests.models.Response`

list_scenarios(_as_type ='listitems'_)
    

List the scenarios in this project.

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**).

Returns:
    

The list of the datasets. If “rtype” is “listitems”, each one as a [`dataikuapi.dss.scenario.DSSScenarioListItem`](<scenarios.html#dataikuapi.dss.scenario.DSSScenarioListItem> "dataikuapi.dss.scenario.DSSScenarioListItem"). If “rtype” is “objects”, each one as a [`dataikuapi.dss.scenario.DSSScenario`](<scenarios.html#dataikuapi.dss.scenario.DSSScenario> "dataikuapi.dss.scenario.DSSScenario")

Return type:
    

list

get_scenario(_scenario_id_)
    

Get a handle to interact with a specific scenario

Parameters:
    

**str** – scenario_id: the ID of the desired scenario

Returns:
    

A scenario handle

Return type:
    

[`dataikuapi.dss.scenario.DSSScenario`](<scenarios.html#dataikuapi.dss.scenario.DSSScenario> "dataikuapi.dss.scenario.DSSScenario")

create_scenario(_scenario_name_ , _type_ , _definition =None_)
    

Create a new scenario in the project, and return a handle to interact with it

Parameters:
    

  * **scenario_name** (_str_) – The name for the new scenario. This does not need to be unique (although this is strongly recommended)

  * **type** (_str_) – The type of the scenario. MUst be one of ‘step_based’ or ‘custom_python’

  * **definition** (_dict_) – the JSON definition of the scenario. Use **get_definition(with_status=False)** on an existing **DSSScenario** object in order to get a sample definition object (defaults to **{‘params’: {}}**)



Returns:
    

a [`dataikuapi.dss.scenario.DSSScenario`](<scenarios.html#dataikuapi.dss.scenario.DSSScenario> "dataikuapi.dss.scenario.DSSScenario") handle to interact with the newly-created scenario

list_recipes(_as_type ='listitems'_)
    

List the recipes in this project

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**).

Returns:
    

The list of the recipes. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.recipe.DSSRecipeListItem`](<recipes.html#dataikuapi.dss.recipe.DSSRecipeListItem> "dataikuapi.dss.recipe.DSSRecipeListItem"). If “as_type” is “objects”, each one as a [`dataikuapi.dss.recipe.DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe")

Return type:
    

list

get_recipe(_recipe_name_)
    

Gets a [`dataikuapi.dss.recipe.DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe") handle to interact with a recipe

Parameters:
    

**recipe_name** (_str_) – The name of the recipe

Returns:
    

A recipe handle

Return type:
    

[`dataikuapi.dss.recipe.DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe")

create_recipe(_recipe_proto_ , _creation_settings_)
    

Create a new recipe in the project, and return a handle to interact with it. We strongly recommend that you use the creator helpers instead of calling this directly.

Some recipe types require additional parameters in creation_settings:

  * ‘grouping’ : a ‘groupKey’ column name

  * ‘python’, ‘sql_query’, ‘hive’, ‘impala’ : the code of the recipe as a ‘payload’ string




Parameters:
    

  * **recipe_proto** (_dict_) – a prototype for the recipe object. Must contain at least ‘type’ and ‘name’

  * **creation_settings** (_dict_) – recipe-specific creation settings



Returns:
    

A recipe handle

Return type:
    

[`dataikuapi.dss.recipe.DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe")

new_recipe(_type_ , _name =None_)
    

Initializes the creation of a new recipe. Returns a [`dataikuapi.dss.recipe.DSSRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.DSSRecipeCreator> "dataikuapi.dss.recipe.DSSRecipeCreator") or one of its subclasses to complete the creation of the recipe.

Warning

Only works with native recipes, use create_recipe for custom recipes.

Usage example:
    
    
    grouping_recipe_builder = project.new_recipe("grouping")
    grouping_recipe_builder.with_input("dataset_to_group_on")
    # Create a new managed dataset for the output in the "filesystem_managed" connection
    grouping_recipe_builder.with_new_output("grouped_dataset", "filesystem_managed")
    grouping_recipe_builder.with_group_key("column")
    recipe = grouping_recipe_builder.build()
    
    # After the recipe is created, you can edit its settings
    recipe_settings = recipe.get_settings()
    recipe_settings.set_column_aggregations("value", sum=True)
    recipe_settings.save()
    
    # And you may need to apply new schemas to the outputs
    recipe.compute_schema_updates().apply()
    

Parameters:
    

  * **type** (_str_) – Type of the recipe

  * **name** (_str_) – Optional, base name for the new recipe.



Returns:
    

A new DSS Recipe Creator handle

Return type:
    

[`dataikuapi.dss.recipe.DSSRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.DSSRecipeCreator> "dataikuapi.dss.recipe.DSSRecipeCreator")

get_flow()
    

Returns:
    

A Flow handle

Return type:
    

A [`dataikuapi.dss.flow.DSSProjectFlow`](<flow.html#dataikuapi.dss.flow.DSSProjectFlow> "dataikuapi.dss.flow.DSSProjectFlow")

sync_datasets_acls()
    

Resync permissions on HDFS datasets in this project

Attention

This call requires an API key with admin rights

Returns:
    

a handle to the task of resynchronizing the permissions

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

list_running_notebooks(_as_objects =True_)
    

Caution

Deprecated. Use `DSSProject.list_jupyter_notebooks()`

List the currently-running notebooks

Returns:
    

list of notebooks. Each object contains at least a ‘name’ field

Return type:
    

list

get_tags()
    

List the tags of this project.

Returns:
    

a dictionary containing the tags with a color

Return type:
    

dict

set_tags(_tags =None_)
    

Set the tags of this project. :param dict tags: must be a modified version of the object returned by list_tags (defaults to **{}**)

list_macros(_as_objects =False_)
    

List the macros accessible in this project

Parameters:
    

**as_objects** – if True, return the macros as [`dataikuapi.dss.macro.DSSMacro`](<plugins.html#dataikuapi.dss.macro.DSSMacro> "dataikuapi.dss.macro.DSSMacro") macro handles instead of a list of python dicts (defaults to **False**)

Returns:
    

the list of the macros

Return type:
    

list

get_macro(_runnable_type_)
    

Get a handle to interact with a specific macro

Parameters:
    

**runnable_type** (_str_) – the identifier of a macro

Returns:
    

A macro handle

Return type:
    

[`dataikuapi.dss.macro.DSSMacro`](<plugins.html#dataikuapi.dss.macro.DSSMacro> "dataikuapi.dss.macro.DSSMacro")

get_wiki()
    

Get the wiki

Returns:
    

the wiki associated to the project

Return type:
    

[`dataikuapi.dss.wiki.DSSWiki`](<wiki.html#dataikuapi.dss.wiki.DSSWiki> "dataikuapi.dss.wiki.DSSWiki")

get_object_discussions()
    

Get a handle to manage discussions on the project

Returns:
    

the handle to manage discussions

Return type:
    

[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")

init_tables_import()
    

Start an operation to import Hive or SQL tables as datasets into this project

Returns:
    

a [`dataikuapi.dss.project.TablesImportDefinition`](<tables-import.html#dataikuapi.dss.project.TablesImportDefinition> "dataikuapi.dss.project.TablesImportDefinition") to add tables to import

Return type:
    

[`dataikuapi.dss.project.TablesImportDefinition`](<tables-import.html#dataikuapi.dss.project.TablesImportDefinition> "dataikuapi.dss.project.TablesImportDefinition")

list_sql_schemas(_connection_name_)
    

Lists schemas from which tables can be imported in a SQL connection

Parameters:
    

**connection_name** (_str_) – name of the SQL connection

Returns:
    

an array of schemas names

Return type:
    

list

list_iceberg_namespaces(_connection_name_)
    

Lists namespaces from which tables can be imported in a Iceberg connection

Parameters:
    

**connection_name** (_str_) – name of the Iceberg connection

Returns:
    

an array of namespaces

Return type:
    

list

list_hive_databases()
    

Lists Hive databases from which tables can be imported

Returns:
    

an array of databases names

Return type:
    

list

list_sql_tables(_connection_name_ , _schema_name =None_)
    

Lists tables to import in a SQL connection

Parameters:
    

  * **connection_name** (_str_) – name of the SQL connection

  * **schema_name** (_str_) – Optional, name of the schema in the SQL connection in which to list tables.



Returns:
    

an array of tables

Return type:
    

list

list_iceberg_tables(_connection_name_ , _namespace =None_)
    

Lists tables to import in a Iceberg connection

Parameters:
    

  * **connection_name** (_str_) – name of the Iceberg connection

  * **namespace** (_str_) – Optional, namespace in the Iceberg connection to list tables from.



Returns:
    

an array of tables

Return type:
    

list

list_hive_tables(_hive_database_)
    

Lists tables to import in a Hive database

Parameters:
    

**hive_database** (_str_) – name of the Hive database

Returns:
    

an array of tables

Return type:
    

list

list_elasticsearch_indices_or_aliases(_connection_name_)
    

get_app_manifest()
    

Gets the manifest of the application if the project is an app template or an app instance, fails otherwise.

Returns:
    

the manifest of the application associated to the project

Return type:
    

[`dataikuapi.dss.app.DSSAppManifest`](<dataiku-applications.html#dataikuapi.dss.app.DSSAppManifest> "dataikuapi.dss.app.DSSAppManifest")

setup_mlflow(_managed_folder_ , _host =None_)
    

Set up the dss-plugin for MLflow

Parameters:
    

  * **managed_folder** (_object_) – the managed folder where MLflow artifacts should be stored. Can be either a managed folder id as a string, a [`dataikuapi.dss.managedfolder.DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), or a [`dataiku.Folder`](<managed-folders.html#dataiku.Folder> "dataiku.Folder")

  * **host** (_str_) – set up a custom host if the backend used is not DSS (defaults to **None**).




get_mlflow_extension()
    

Get a handle to interact with the extension of MLflow provided by DSS

Returns:
    

A Mlflow Extension handle

Return type:
    

[`dataikuapi.dss.mlflow.DSSMLflowExtension`](<experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension> "dataikuapi.dss.mlflow.DSSMLflowExtension")

list_code_studios(_as_type ='listitems'_)
    

List the code studio objects in this project

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**).

Returns:
    

the list of the code studio objects, each one as a python dict

Return type:
    

list

get_code_studio(_code_studio_id_)
    

Get a handle to interact with a specific code studio object

Parameters:
    

**code_studio_id** (_str_) – the identifier of the desired code studio object

Returns:
    

A code studio object handle

Return type:
    

[`dataikuapi.dss.codestudio.DSSCodeStudioObject`](<code-studios.html#dataikuapi.dss.codestudio.DSSCodeStudioObject> "dataikuapi.dss.codestudio.DSSCodeStudioObject")

create_code_studio(_name_ , _template_id_)
    

Create a new code studio object in the project, and return a handle to interact with it

Parameters:
    

  * **name** (_str_) – the name of the code studio object

  * **template_id** (_str_) – the identifier of a code studio template



Returns:
    

A code studio object handle

Return type:
    

[`dataikuapi.dss.codestudio.DSSCodeStudioObject`](<code-studios.html#dataikuapi.dss.codestudio.DSSCodeStudioObject> "dataikuapi.dss.codestudio.DSSCodeStudioObject")

get_library()
    

Get a handle to manage the project library

Returns:
    

A [`dataikuapi.dss.projectlibrary.DSSLibrary`](<project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibrary> "dataikuapi.dss.projectlibrary.DSSLibrary") handle

Return type:
    

[`dataikuapi.dss.projectlibrary.DSSLibrary`](<project-libraries.html#dataikuapi.dss.projectlibrary.DSSLibrary> "dataikuapi.dss.projectlibrary.DSSLibrary")

list_llms(_purpose ='GENERIC_COMPLETION'_, _as_type ='listitems'_)
    

List the LLM usable in this project

Parameters:
    

  * **purpose** (_str_) – Usage purpose of the LLM. Main values are GENERIC_COMPLETION, TEXT_EMBEDDING_EXTRACTION, IMAGE_EMBEDDING_EXTRACTION, RERANKING and IMAGE_GENERATION

  * **as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects”.



Returns:
    

The list of LLMs. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.llm.DSSLLMListItem`](<llm-mesh.html#dataikuapi.dss.llm.DSSLLMListItem> "dataikuapi.dss.llm.DSSLLMListItem"). If “as_type” is “objects”, each one as a [`dataikuapi.dss.llm.DSSLLM`](<llm-mesh.html#dataikuapi.dss.llm.DSSLLM> "dataikuapi.dss.llm.DSSLLM")

Return type:
    

list

get_llm(_llm_id_)
    

Get a handle to interact with a specific LLM

Parameters:
    

**id** – the identifier of an LLM

Returns:
    

A [`dataikuapi.dss.llm.DSSLLM`](<llm-mesh.html#dataikuapi.dss.llm.DSSLLM> "dataikuapi.dss.llm.DSSLLM") LLM handle

list_knowledge_banks(_as_type ='listitems'_)
    

List the knowledge banks of this project

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects”.

Returns:
    

The list of knowledge banks. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.knowledgebank.DSSKnowledgeBankListItem`](<llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBankListItem> "dataikuapi.dss.knowledgebank.DSSKnowledgeBankListItem"). If “as_type” is “objects”, each one as a [`dataikuapi.dss.knowledgebank.DSSKnowledgeBank`](<llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBank> "dataikuapi.dss.knowledgebank.DSSKnowledgeBank")

Return type:
    

list[[DSSKnowledgeBank](<llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBank> "dataikuapi.dss.knowledgebank.DSSKnowledgeBank")]

get_knowledge_bank(_id_)
    

Get a handle to interact with a specific knowledge bank

Parameters:
    

**id** – the identifier of a knowledge bank

Returns:
    

A [`dataikuapi.dss.knowledgebank.DSSKnowledgeBank`](<llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBank> "dataikuapi.dss.knowledgebank.DSSKnowledgeBank") knowledge bank handle

create_knowledge_bank(_name_ , _vector_store_type_ , _embedding_llm_id_ , _settings =None_)
    

Create a new knowledge bank in the project, and return a handle to interact with it

Parameters:
    

  * **name** (_str_) – The name for the new knowledge bank. This does not need to be unique

  * **vector_store_type** (_str_) – 

The vector store type to use for this knowledge bank. Valid values are:

    * CHROMA

    * PINECONE

    * ELASTICSEARCH

    * AZURE_AI_SEARCH

    * VERTEX_AI_GCS_BASED

    * FAISS _(not recommended)_

    * QDRANT_LOCAL _(not recommended)_

    * MILVUS_LOCAL

    * MILVUS_REMOTE

  * **embedding_llm_id** (_str_) – The id of the embedding LLM. It has to have the TEXT_EMBEDDING_EXTRACTION purpose.

  * **settings** (_Optional_ _[__dict_ _]_) – 

Additional settings for the knowledge bank, including:

    * ”connection” (str) the connection name, for remote vector stores

    * ”indexName” (str) the index name, for remote vector stores (except Pinecone)

    * ”pineconeIndexName” (str) the index name, for Pinecone vector stores

    * ”managedFolderId” (str) the id of the managed folder containing the extracted images.
    

The images may be referenced by their path in the knowledge bank, and stored in this folder.



Returns:
    

a [`dataikuapi.dss.knowledgebank.DSSKnowledgeBank`](<llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBank> "dataikuapi.dss.knowledgebank.DSSKnowledgeBank") handle to interact with the newly-created knowledge bank

list_retrieval_augmented_llms(_as_type ='listitems'_)
    

List the knowledge banks of this project

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects”.

Returns:
    

The list of retrieval-augmented LLMs. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLMListItem`](<llm-mesh.html#dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLMListItem> "dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLMListItem"). If “as_type” is “objects”, each one as a [`dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM`](<llm-mesh.html#dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM> "dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM")

Return type:
    

list[[DSSRetrievalAugmentedLLM](<llm-mesh.html#dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM> "dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM")]

get_retrieval_augmented_llm(_id_)
    

Get a handle to interact with a specific retrieval-augmented LLM

Parameters:
    

**id** – the identifier of a retrieval-augmented LLM

Returns:
    

A [`dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM`](<llm-mesh.html#dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM> "dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM") retrieval-augmented LLM handle

create_retrieval_augmented_llm(_name_ , _knowledge_bank_ref_ , _llm_id_)
    

Create a new retrieval-augmented LLM in the project, and return a handle to interact with it

Parameters:
    

  * **name** (_str_) – The name for the new retrieval-augmented LLM. This does not need to be unique

  * **knowledge_bank_ref** (_str_) – Identifier of the Knowledge bank to use

  * **llm_id** (_str_) – Identifier of the LLM to use for the RAG process



Returns:
    

a [`dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM`](<llm-mesh.html#dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM> "dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM") handle to interact with the newly-created retrieval-augmented-llm

list_semantic_models(_as_type ='listitems'_)
    

List semantic models in this project.

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects”.

Returns:
    

The list of semantic models. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.semantic_model.DSSSemanticModelListItem`](<semantic-models.html#dataikuapi.dss.semantic_model.DSSSemanticModelListItem> "dataikuapi.dss.semantic_model.DSSSemanticModelListItem"). If “as_type” is “objects”, each one as a [`dataikuapi.dss.semantic_model.DSSSemanticModel`](<semantic-models.html#dataikuapi.dss.semantic_model.DSSSemanticModel> "dataikuapi.dss.semantic_model.DSSSemanticModel")

Return type:
    

list

get_semantic_model(_semantic_model_id_)
    

Get a handle to interact with a specific semantic model.

Parameters:
    

**semantic_model_id** (_str_) – identifier of a semantic model

Returns:
    

A [`dataikuapi.dss.semantic_model.DSSSemanticModel`](<semantic-models.html#dataikuapi.dss.semantic_model.DSSSemanticModel> "dataikuapi.dss.semantic_model.DSSSemanticModel") handle

create_semantic_model(_name_)
    

Create a new semantic model in the project, and return a handle to interact with it.

Parameters:
    

**name** (_str_) – The name for the new semantic model

Returns:
    

a [`dataikuapi.dss.semantic_model.DSSSemanticModel`](<semantic-models.html#dataikuapi.dss.semantic_model.DSSSemanticModel> "dataikuapi.dss.semantic_model.DSSSemanticModel") handle

list_agents(_as_type ='listitems'_)
    

List the agents of this project

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects”.

Returns:
    

The list of agents. If “as_type” is “listitems”, each one as a [`dataikuapi.dss.agent.DSSAgentListItem`](<agents.html#dataikuapi.dss.agent.DSSAgentListItem> "dataikuapi.dss.agent.DSSAgentListItem"). If “as_type” is “objects”, each one as a [`dataikuapi.dss.agent.DSSAgent`](<agents.html#dataikuapi.dss.agent.DSSAgent> "dataikuapi.dss.agent.DSSAgent")

Return type:
    

list[[DSSAgent](<agents.html#dataikuapi.dss.agent.DSSAgent> "dataikuapi.dss.agent.DSSAgent")]

get_agent(_id_)
    

Get a handle to interact with a specific agent

Parameters:
    

**id** – the identifier of a agent

Returns:
    

A [`dataikuapi.dss.agent.DSSAgent`](<agents.html#dataikuapi.dss.agent.DSSAgent> "dataikuapi.dss.agent.DSSAgent") agent handle

create_agent(_name_ , _type_ , _plugin_agent_type =None_)
    

Create a new agent in the project, and return a handle to interact with it

Parameters:
    

  * **name** (_str_) – The name for the new agent. This does not need to be unique

  * **type** (_str_) – one of PYTHON_AGENT, PLUGIN_AGENT, TOOLS_USING_AGENT or STRUCTURED_AGENT (Visual Agent)

  * **plugin_agent_type** (_str_) – only if type=PLUGIN_AGENT, the id of the custom plugin component



Returns:
    

a [`dataikuapi.dss.agent.DSSAgent`](<agents.html#dataikuapi.dss.agent.DSSAgent> "dataikuapi.dss.agent.DSSAgent") handle to interact with the newly-created agent

create_agent_interaction_logging_dataset(_dataset_name_ , _connection_id_ , _time_partitioning =None_)
    

Create a new agent interaction logging dataset.

Parameters:
    

  * **dataset_name** (_str_) – Identifier for the dataset to create.

  * **connection_id** (_str_) – Identifier of the connection to use (SQL or filesystem-like).

  * **time_partitioning** (_str_ _|__None_) – Time period of the partitioning. Can be one of “HOUR”, “DAY”, “MONTH”. Set to None for no partitioning.




new_agent_tool(_type_ , _name =None_, _id =None_)
    

Initiates the creation of an agent tool. Returns a [`dataikuapi.dss.agent_tool.DSSAgentToolCreator`](<agents.html#dataikuapi.dss.agent_tool.DSSAgentToolCreator> "dataikuapi.dss.agent_tool.DSSAgentToolCreator") or one of its subclasses to complete the creation of the agent_tool

Usage example:
    
    
    vector_search_tool_creator = project.new_agent_tool("VectorStoreSearch")
    vector_search_tool_creator.with_knowledge_bank("kb_id")
    vector_search_tool = vector_search_tool_creator.create()
    
    # After the tool is created, you can edit its settings
    tool_settings = vector_search_tool.get_settings()
    
    tool_settings.save()
    

Parameters:
    

  * **type** (_str_) – Type of the agent tool to create

  * **name** (_str_) – Optional, name of the new tool. Defaults to type if not specified

  * **id** (_str_) – Optional, identifier of the new tool (must be unique). An id will be automatically assigned if not specified



Return type:
    

[`dataikuapi.dss.agent_tool.DSSAgentToolCreator`](<agents.html#dataikuapi.dss.agent_tool.DSSAgentToolCreator> "dataikuapi.dss.agent_tool.DSSAgentToolCreator")

list_agent_tools(_as_type ='listitems'_, _include_shared =False_)
    

Parameters:
    

  * **as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects” (defaults to **listitems**).

  * **include_shared** (_boolean_) – If **True** , also lists the agent tools from other projects that are shared in this project (defaults to **False**).



Returns:
    

The list of the agent tools. If “as_type” is “listitems”, each one as a `dataikuapi.dss.dataset.DSSAgentToolListItem`. If “as_type” is “objects”, each one as a `dataikuapi.dss.dataset.DSSAgentTool`

Return type:
    

list

get_agent_tool(_tool_id_)
    

Get a handle to interact with a specific tool

list_webapps(_as_type ='listitems'_)
    

List the webapp heads of this project

Parameters:
    

**as_type** (_str_) – How to return the list. Supported values are “listitems” and “objects”.

Returns:
    

The list of the webapps. If “as_type” is “listitems”, each one as a `scenario.DSSWebAppListItem`. If “as_type” is “objects”, each one as a `scenario.DSSWebApp`

Return type:
    

list

get_webapp(_webapp_id_)
    

Get a handle to interact with a specific webapp

Parameters:
    

**webapp_id** – the identifier of a webapp

Returns:
    

A [`dataikuapi.dss.webapp.DSSWebApp`](<webapps.html#dataikuapi.dss.webapp.DSSWebApp> "dataikuapi.dss.webapp.DSSWebApp") webapp handle

list_dashboards(_as_type ='listitems'_)
    

List the Dashboards in this project.

Returns:
    

The list of the dashboards.

Return type:
    

list

get_dashboard(_dashboard_id_)
    

Get a handle to interact with a specific dashboard object

Parameters:
    

**dashboard_id** (_str_) – the identifier of the desired dashboard object

Returns:
    

A [`dataikuapi.dss.dashboard.DSSDashboard`](<dashboards.html#dataikuapi.dss.dashboard.DSSDashboard> "dataikuapi.dss.dashboard.DSSDashboard") dashboard object handle

create_dashboard(_dashboard_name_ , _settings =None_)
    

Create a new dashboard in the project, and return a handle to interact with it

Parameters:
    

  * **dashboard_name** (_str_) – The name for the new dashboard. This does not need to be unique (although this is strongly recommended)

  * **settings** (_dict_) – the JSON definition of the dashboard. Use `get_settings()` on an existing `DSSDashboard` object in order to get a sample settings object (defaults to {‘pages’: []})



Returns:
    

a [`dashboard.DSSDashboard`](<dashboards.html#dataikuapi.dss.dashboard.DSSDashboard> "dataikuapi.dss.dashboard.DSSDashboard") handle to interact with the newly-created dashboard

list_insights(_as_type ='listitems'_)
    

List the Insights in this project.

Returns:
    

The list of the insights.

Return type:
    

list

get_insight(_insight_id_)
    

Get a handle to interact with a specific insight object

Parameters:
    

**insight_id** (_str_) – the identifier of the desired insight object

Returns:
    

A [`dataikuapi.dss.insight.DSSInsight`](<insights.html#dataikuapi.dss.insight.DSSInsight> "dataikuapi.dss.insight.DSSInsight") insight object handle

create_insight(_creation_info_)
    

Create a new insight in the project, and return a handle to interact with it

Parameters:
    

**creation_info** (_dict_) – the JSON definition of the insight creation. Use `get_settings()` on an existing `DSSInsight` object in order to get a sample settings object

Returns:
    

a [`insight.DSSInsight`](<insights.html#dataikuapi.dss.insight.DSSInsight> "dataikuapi.dss.insight.DSSInsight") handle to interact with the newly-created insight

get_project_git()
    

Gets an handle to perform operations on the project’s git repository.

Returns:
    

a handle to perform git operations on project.

Return type:
    

`dataikuapi.dss.project.DSSProjectGit`

get_data_quality_status(_only_monitored =True_)
    

Get the aggregated quality status of a project with the list of the datasets and their associated status

Parameters:
    

**only_monitored** – boolean to retrieve only monitored dataset, default to True.

Returns:
    

The dict of data quality dataset statuses.

Return type:
    

dict with DATASET_NAME as key

get_data_quality_timeline(_min_timestamp =None_, _max_timestamp =None_)
    

Get the list of quality status aggregated per day during the timeframe [min_timestamp, max_timestamp]. It includes the current & worst outcome for each days and the details of the datasets runs within the period, also includes previous deleted monitored datasets with the mention “(deleted)” at the end of their id. Default parameters include the timeframe for the last 14 days.

Parameters:
    

  * **min_timestamp** (_int_) – timestamp representing the beginning of the timeframe

  * **max_timestamp** (_int_) – timestamp representing the end of the timeframe



Returns:
    

list of datasets per day in the timeline

Return type:
    

list of dict

list_test_scenarios()
    

Lists all the test scenarios of a DSS Project :return: list all test scenarios of a project :rtype: list of `DSSScenario`

get_testing_status(_bundle_id =None_)
    

Get the testing status of a DSS Project. It combines the last run outcomes of all the test scenarios defined on the project, considering the worst outcome as a final result. :param (optional) string bundle_id : if the project is on automation node, you can specify a bundle_id to filter only on the last scenario runs when this bundle was active :returns: A [`dataikuapi.dss.scenario.DSSTestingStatus`](<scenarios.html#dataikuapi.dss.scenario.DSSTestingStatus> "dataikuapi.dss.scenario.DSSTestingStatus") object handle

start_run_project_standards_checks(_check_ids =None_)
    

Run the Project Standards checks associated to the project.

If check_ids is None, the scope associated to the project (see `get_project_standards_scope()`) will be used to fetch the check ids. The saved report associated with the project, accessible with `get_project_standards_last_report()`, is updated only if check_ids and bundle_id are None.

Parameters:
    

**check_ids** (_(__List_ _[__str_ _]__|__None_ _)_) – List of explicit checks to run. If None, the scope associated to the project will be used to fetch the check ids.

Returns:
    

a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") tracking the progress of the checks. Call [`wait_for_result()`](<other-administration.html#dataikuapi.dss.future.DSSFuture.wait_for_result> "dataikuapi.dss.future.DSSFuture.wait_for_result") on the returned object to wait for completion (or failure). The completed object will be an instance of [`DSSProjectStandardsRunReport`](<project-standards.html#dataikuapi.dss.project_standards.DSSProjectStandardsRunReport> "dataikuapi.dss.project_standards.DSSProjectStandardsRunReport")

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

get_project_standards_last_report()
    

Get the latest Project Standards report of the project.

The report is updated each time Project Standards is run on the project (not a bundle) using the associated scope. See `start_run_project_standards_checks()`.

Returns:
    

The last report if it exists, None if checks have never been run on this project

Return type:
    

([DSSProjectStandardsRunReport](<project-standards.html#dataikuapi.dss.project_standards.DSSProjectStandardsRunReport> "dataikuapi.dss.project_standards.DSSProjectStandardsRunReport") | None)

get_project_standards_scope()
    

Get the name of the scope associated to the project.

Returns:
    

The scope name.

Return type:
    

str

list_plugins_usages()
    

Get the list of usages of each plugin used in this project.

Note

This call requires an API key with either:

  * DSS admin permissions

  * tied to a user with admin privileges on the project




Returns:
    

A list of `DSSPluginUsagesListItem` objects

Return type:
    

list

list_agent_reviews(_as_type ='listitems'_)
    

List all agent reviews defined in this project.

Parameters:
    

**as_type** (_str_) – Type of objects to return. Can be ‘listitems’ (default) or ‘objects’.

Returns:
    

The list of agent reviews. Each one is a handle to interact with the review.

Return type:
    

if as_type=listitems, each review as a [`dataikuapi.dss.agent_review.DSSAgentReviewListItem`](<agent-review.html#dataikuapi.dss.agent_review.DSSAgentReviewListItem> "dataikuapi.dss.agent_review.DSSAgentReviewListItem"). if as_type=objects, each review is returned as a [`dataikuapi.dss.agent_review.DSSAgentReview`](<agent-review.html#dataikuapi.dss.agent_review.DSSAgentReview> "dataikuapi.dss.agent_review.DSSAgentReview").

get_agent_review(_agent_review_id_)
    

Get a handle to interact with a specific agent review.

Parameters:
    

**agent_review_id** (_str_) – The unique identifier of the agent review.

Returns:
    

A handle to interact with the specified agent review.

Return type:
    

`dataikuapi.dss.agent.DSSAgentReview`

create_agent_review(_review_name_)
    

Create a new agent review in this project.

Parameters:
    

**review_name** (_str_) – The name for the new agent review. This does not need to be unique.

Returns:
    

A handle to interact with the newly created agent review.

Return type:
    

`dataikuapi.dss.agent.DSSAgentReview`

_class _dataikuapi.dss.project.DSSProjectGit(_client_ , _project_key_)
    

Handle to manage the git repository of a DSS project (fetch, push, pull, …)

get_status()
    

Get the current state of the project’s git repository.

Returns:
    

A dict containing the following keys: \- **currentBranch** (_str_): The currently checked-out Git branch. \- **remotes** (_list_): A list of configured remotes, each being a dict with:

>   * **name** (_str_): The remote name (e.g. “origin”).
> 
>   * **url** (_str_): The remote repository URL.
> 
> 


  * **trackingCount** (_dict_): The number of commits the local branch is ahead/behind its tracked remote branch.

  * **clean** (_bool_): Whether the working directory is clean (no changes).

  * **hasUncommittedChanges** (_bool_): Whether there are uncommitted changes.

  * **added** (_list_): Files staged as newly added.

  * **changed** (_list_): Files staged as modified.

  * **removed** (_list_): Files staged as removed.

  * **missing** (_list_): Files missing from disk but still tracked.

  * **modified** (_list_): Files modified but not staged.

  * **conflicting** (_list_): Files with merge conflicts.

  * **untracked** (_list_): Untracked files.

  * **untrackedFolders** (_list_): Untracked folders.

  * **originProjectKey** (_str_): The key of the origin project from which this project was duplicated from.

  * **trackingCountWithOriginProject** (_dict_): The number of commits ahead/behind relative to the origin project repository, with keys:
    
    * **ahead** (_int_): Number of commits ahead of the origin project.

    * **behind** (_int_): Number of commits behind the origin project.




Return type:
    

dict

get_remote(_name ='origin'_)
    

Get the URL of the remote repository.

Param:
    

str name: The name of the remote. Defaults to “origin”.

Returns:
    

The URL of the remote origin if set, None otherwise.

Return type:
    

str or None

set_remote(_url_ , _name ='origin'_)
    

Set the URL of the remote repository.

Param:
    

str name: The name of the remote to set. Defaults to “origin”.

Parameters:
    

**url** (_str_) – The URL of the remote repository ([git@github.com](</cdn-cgi/l/email-protection#77101e03515444404c515442454c5154434f4c101e031f0215515443414c14181a>):user/repo.git).

remove_remote(_name ='origin'_)
    

Remove the remote origin of the project’s git repository.

Param:
    

str name: The name of the remote to remove. Defaults to “origin”.

list_branches(_remote =False_)
    

List all branches (local only or local & remote) of the project’s git repository.

Parameters:
    

**remote** (_bool_) – Whether to include remote branches.

Returns:
    

A list of branch names.

Return type:
    

list

create_branch(_branch_name_ , _commit =None_, _duplicate_project =False_, _target_project_key =None_, _target_project_folder_id =None_)
    

Create a new local branch on the project’s git repository and switches to it.

Parameters:
    

  * **branch_name** (_str_) – The name of the branch to create.

  * **commit** (_str_) – Optional. Hash of a commit to create the branch from.

  * **duplicate_project** (_bool_) – Optional. If True (recommended), a new project is created as a duplicate with the new branch. Defaults to False.

  * **target_project_key** (_str_) – Optional. Key of the target project where the branch should be created. If not provided and duplicate_project is True, the new project key will default to the current project key appended with the branch name.

  * **target_project_folder_id** (_str_) – Optional. The target project folder id to create the project into



Returns:
    

A dict containing keys ‘success’ and ‘output’ with information about the command execution.

Return type:
    

dict

delete_branch(_branch_name_ , _force_delete =False_, _remote =False_, _delete_remotely =False_)
    

Delete a local or remote branch on the project’s git repository.

Parameters:
    

  * **branch_name** (_str_) – The name of the branch to delete.

  * **remote** (_bool_) – True if the branch to delete is a remote branch; False if it’s a local branch.

  * **delete_remotely** (_bool_) – True to delete a remote branch both locally and remotely; False to delete the remote branch on the local repository only.

  * **force_delete** (_bool_) – True to force the deletion even if some commits have not been pushed; False to fail in case some commits have not been pushed.




get_current_branch()
    

Get the name of the current branch

Returns:
    

The name of the current branch

Return type:
    

str

list_tags()
    

Lists all existing tags.

Returns:
    

A list of dict objects, each one containing the following keys: ‘name’, ‘shortName’, ‘commit’ (hash of the commit associated with the tag), ‘annotations’ and ‘readOnly’.

Return type:
    

list

create_tag(_name_ , _reference ='HEAD'_, _message =''_)
    

Create a tag for the specified or current reference.

Parameters:
    

  * **name** (_str_) – The name of the tag to create.

  * **reference** (_str_) – ID of a commit to tag. Defaults to HEAD.




delete_tag(_name_)
    

Remove a tag from the local repository

Parameters:
    

**name** (_str_) – The name of the tag to delete.

switch(_branch_name_)
    

Switch the current repository to the specified branch.

Parameters:
    

**branch_name** (_str_) – The name of the branch to switch to.

Returns:
    

A dict containing keys ‘success’, ‘messages’, ‘output’ with information about the command execution.

Return type:
    

dict

checkout(_branch_name_)
    

Switch the current repository to the specified branch (identical to`switch`)

Parameters:
    

**branch_name** (_str_) – The name of the branch to checkout.

Returns:
    

A dict containing keys ‘success’, ‘messages’, ‘output’ with information about the command execution.

Return type:
    

dict

fetch()
    

Fetch branches and/or tags (collectively, “refs”) from the remote repository to the project’s git repository.

Returns:
    

A dict containing keys ‘success’, ‘logs’, ‘output’ with information about the command execution.

Return type:
    

dict

pull(_branch_name =None_)
    

Incorporate changes from a remote repository into the current branch on the project’s git repository.

Parameters:
    

**branch_name** (_str_) – The name of the branch to pull. If None, pull from the current branch.

Returns:
    

A dict containing keys ‘success’, ‘logs’, ‘output’ with information about the command execution.

Return type:
    

dict

push(_branch_name =None_)
    

Update the remote repository with the project’s local commits.

Parameters:
    

**branch_name** (_str_) – The name of the branch to push. If None, push commits from the current branch.

Returns:
    

A dict containing keys ‘success’, ‘logs’, ‘output’ with information about the command execution.

Return type:
    

dict

log(_path =None_, _start_commit =None_, _count =1000_)
    

List commits in the project’s git repository.

Parameters:
    

  * **path** (_str_) – Path to filter the logs (optional). If specified, only commits impacting files located in the provided path are returned.

  * **start_commit** (_str_) – ID of the first commit to list. Use the value found in the nextCommit field from a previous response (optional).

  * **count** (_int_) – Maximum number of commits to return (20 by default).



Returns:
    

A dict containing a key entries and optionally a second key nextCommit if there are more commits.

Return type:
    

dict

diff(_commit_from =None_, _commit_to =None_)
    

Show changes between the working copy and the last commit (commit_from=None, commit_to=None), between two commits (commit_from=SOME_ID, commit_to=SOME_ID), or made in a given commit (commit_from=SOME_ID, commit_to=None).

Parameters:
    

  * **commit_from** (_str_) – ID of the first commit or None

  * **commit_to** (_str_) – ID of the second commit or None



Returns:
    

A containing containing the following keys: ‘commitFrom’ (dict), ‘commitTo’ (dict), ‘addedLines’ (int), ‘removedLines’ (int), ‘changedFiles’ (int), ‘entries’ (array of dict)

Return type:
    

dict

commit(_message_)
    

Commit pending changes in the project’s git repository with the given message.

Note: Untracked tracked are automatically added before committing.

Parameters:
    

**message** (_str_) – The commit message.

revert_to_revision(_commit_)
    

Revert the project content to the supplied revision.

Parameters:
    

**commit** (_str_) – Hash of a valid commit as returned by the log method.

Returns:
    

A dict containing a key ‘success’ and optionally a second key ‘logs’ with information about the command execution.

Return type:
    

dict

revert_commit(_commit_)
    

Revert the changes that the specified commit introduces

Parameters:
    

**commit** (_str_) – ID of a valid commit as returned by the log method.

Returns:
    

A dict containing the following keys: ‘success’ and optionally ‘logs’ with information about the command execution.

Return type:
    

dict

reset_to_head()
    

Drop uncommitted changes in the project’s git repository (hard reset to HEAD).

reset_to_upstream()
    

Drop local changes in the project’s git repository and hard reset to the upstream branch.

drop_and_rebuild(_i_know_what_i_am_doing =False_)
    

Fully drop the current git repositoty and rebuild from scratch a new one. CAUTION: ALL HISTORY WILL BE LOST. ONLY CALL THIS METHOD IF YOU KNOW WHAT YOU ARE DOING.

Parameters:
    

**i_know_what_i_m_doing** (_bool_) – True if you really want to wipe out all git history for this project.

list_libraries()
    

Get the list of all external libraries for this project

Returns:
    

A list of external libraries.

Return type:
    

list

add_library(_repository_ , _local_target_path_ , _checkout_ , _path_in_git_repository =''_, _add_to_python_path =True_, _login =None_, _password =None_, _as_type ='dict'_)
    

Add a new external library to the project and pull it.

Parameters:
    

  * **repository** (_str_) – The remote repository.

  * **local_target_path** (_str_) – The local target path (relative to root of libraries).

  * **checkout** (_str_) – The branch, commit, or tag to check out.

  * **path_in_git_repository** (_str_) – The path in the git repository.

  * **add_to_python_path** (_bool_) – Whether to add the reference to the Python path.

  * **login** (_str_) – The remote repository login, for HTTPS repository (defaults to **None**).

  * **password** (_str_) – The remote repository password, for HTTPS repository (defaults to **None**).

  * **as_type** (_str_) – The type of return. It can be ‘dict’ (default) or ‘object’.



Returns:
    

A handle on the operation representing the pull process

Return type:
    

if as_type = ‘object’, it returns [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture"). if as_type = ‘dict’, it returns a dict with a ‘jobId’ key.

set_library(_git_reference_path_ , _remote_ , _remotePath_ , _checkout_ , _login =None_, _password =None_)
    

Set an existing external library.

Parameters:
    

  * **git_reference_path** (_str_) – The path of the external library.

  * **remote** (_str_) – The remote repository.

  * **remotePath** (_str_) – The path in the git repository.

  * **checkout** (_str_) – The branch, commit, or tag to check out.

  * **login** (_str_) – The remote repository login, for HTTPS repository (defaults to **None**).

  * **password** (_str_) – The remote repository password, for HTTPS repository (defaults to **None**).



Returns:
    

The path of the external library.

Return type:
    

str

remove_library(_git_reference_path_ , _delete_directory_)
    

Remove an external library from the project.

Parameters:
    

  * **git_reference_path** (_str_) – The path of the external library.

  * **delete_directory** (_bool_) – Whether to delete the local directory associated with the reference.




reset_library(_git_reference_path_)
    

Reset the contents of the external library to match the specified Git reference (typically a branch or tag). It discards any local modifications.

Internally it pulls the latest changes from the remote reference and override any local changes in the external library.

Parameters:
    

**git_reference_path** (_str_) – The path of the external library to reset.

Returns:
    

a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the reset process

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

push_library(_git_reference_path_ , _commit_message_)
    

Push changes to the external library

Parameters:
    

  * **git_reference_path** (_str_) – The path of the external library.

  * **commit_message** (_str_) – The commit message for the push.



Returns:
    

a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the push process

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

push_all_libraries(_commit_message_)
    

Push changes for all libraries in the project.

Parameters:
    

**commit_message** (_str_) – The commit message for the push.

Returns:
    

a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the push process

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

reset_all_libraries()
    

Reset changes for all libraries in the project. :return: a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the reset process :rtype: [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

_class _dataikuapi.dss.project.DSSProjectSettings(_client_ , _project_key_ , _settings_)
    

Settings of a DSS project

get_raw()
    

Gets all settings as a raw dictionary. This returns a reference to the raw settings, not a copy, so changes made to the returned object will be reflected when saving.

Return type:
    

dict

set_python_code_env(_code_env_name_)
    

Sets the default Python code env used by this project

Parameters:
    

**code_env_name** (_str_) – Identifier of the code env to use. If None, sets the project to use the builtin Python env

set_r_code_env(_code_env_name_)
    

Sets the default R code env used by this project

Parameters:
    

**code_env_name** (_str_) – Identifier of the code env to use. If None, sets the project to use the builtin R env

set_container_exec_config(_config_name_)
    

Sets the default containerized execution config used by this project

Parameters:
    

**config_name** (_str_) – Identifier of the containerized execution config to use. If None, sets the project to use local execution

set_k8s_cluster(_cluster_ , _fallback_cluster =None_)
    

Sets the Kubernetes cluster used by this project

Parameters:
    

  * **cluster** (_str_) – Identifier of the cluster to use. May use variables expansion. If None, sets the project to use the globally-defined cluster

  * **fallback_cluster** (_str_) – Identifier of the cluster to use if the variable used for “cluster” does not exist (defaults to **None**)




set_cluster(_cluster_ , _fallback_cluster =None_)
    

Sets the Hadoop/Spark cluster used by this project

Parameters:
    

  * **cluster** (_str_) – Identifier of the cluster to use. May use variables expansion. If None, sets the project to use the globally-defined cluster

  * **fallback_cluster** (_str_) – Identifier of the cluster to use if the variable used for “cluster” does not exist (defaults to **None**)




add_exposed_object(_object_type_ , _object_id_ , _target_project_)
    

Exposes an object from this project to another project. Does nothing if the object was already exposed to the target project

Parameters:
    

  * **object_type** (_str_) – type of the object to expose

  * **object_id** (_str_) – id of the object to expose

  * **target_project** (_str_) – id of the project in which to expose the object




save()
    

Saves back the settings to the project

_class _dataiku.Project(_project_key =None_)
    

This is a handle to interact with the current project

Note

This class is also available as `dataiku.Project`

get_last_metric_values()
    

Get the set of last values of the metrics on this project.

Return type:
    

[`dataiku.core.metrics.ComputedMetrics`](<metrics.html#dataiku.core.metrics.ComputedMetrics> "dataiku.core.metrics.ComputedMetrics")

get_metric_history(_metric_lookup_)
    

Get the set of all values a given metric took on this project.

Parameters:
    

**metric_lookup** (_string_) – metric name or unique identifier

Return type:
    

dict

save_external_metric_values(_values_dict_)
    

Save metrics on this project.

The metrics are saved with the type “external”

Parameters:
    

**values_dict** (_dict_) – the values to save, as a dict. The keys of the dict are used as metric names

get_last_check_values()
    

Get the set of last values of the checks on this project.

Return type:
    

[`dataiku.core.metrics.ComputedChecks`](<metrics.html#dataiku.core.metrics.ComputedChecks> "dataiku.core.metrics.ComputedChecks")

get_check_history(_check_lookup_)
    

Get the set of all values a given check took on this project.

Parameters:
    

**check_lookup** (_string_) – check name or unique identifier

Return type:
    

dict

set_variables(_variables_)
    

Set all variables of the current project

Parameters:
    

**variables** (_dict_) – must be a modified version of the object returned by get_variables

get_variables()
    

Get project variables :param bool typed: typed true to try to cast the variable into its original type (eg. int rather than string)

Returns:
    

A dictionary containing two dictionaries : “standard” and “local”. “standard” are regular variables, exported with bundles. “local” variables are not part of the bundles for this project

save_external_check_values(_values_dict_)
    

Save checks on this project.

The checks are saved with the type “external”.

Parameters:
    

**values_dict** (_dict_) – the values to save, as a dict. The keys of the dict are used as check names

---

## [api-reference/python/pyspark]

# Interaction with Pyspark

dataiku.spark.reduceNotebookLogs(_sql_context_ , _log_level ='WARN'_)
    

dataiku.spark.start_spark_context_and_setup_sql_context(_load_defaults =True_, _hive_db ='dataiku'_, _conf ={}_)
    

Helper to start a Spark Context and a SQL Context “like DSS recipes do”. This helper is mainly for information purpose and not used by default.

dataiku.spark.setup_sql_context(_sc_ , _hive_db ='dataiku'_, _conf ={}_)
    

Helper to start a SQL Context “like DSS recipes do”. This helper is mainly for information purpose and not used by default.

dataiku.spark.distribute_py_libs(_sc_)
    

dataiku.spark.get_dataframe(_sqlContext_ , _dataset_)
    

Opens a DSS dataset as a SparkSQL dataframe. The ‘dataset’ argument must be a dataiku.Dataset object

dataiku.spark.write_schema_from_dataframe(_dataset_ , _dataframe_)
    

Sets the schema on an existing dataset to be write-compatible with given SparkSQL dataframe

dataiku.spark.write_dataframe(_dataset_ , _dataframe_ , _delete_first =True_)
    

Saves a SparkSQL dataframe into an existing DSS dataset

dataiku.spark.write_with_schema(_dataset_ , _dataframe_ , _delete_first =True_)
    

Writes a SparkSQL dataframe into an existing DSS dataset. This first overrides the schema of the dataset to match the schema of the dataframe

dataiku.spark.apply_prepare_recipe(_df_ , _recipe_name_ , _project_key =None_)

---

## [api-reference/python/recipes]

# Recipes

For usage information and examples, see [Recipes](<../../concepts-and-examples/recipes.html>)

_class _dataikuapi.dss.recipe.DSSRecipe(_client_ , _project_key_ , _recipe_name_)
    

A handle to an existing recipe on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.get_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.get_recipe> "dataikuapi.dss.project.DSSProject.get_recipe")

_property _id
    

Get the identifier of the recipe.

For recipes, the name is the identifier.

Return type:
    

string

_property _name
    

Get the name of the recipe.

Return type:
    

string

compute_schema_updates()
    

Computes which updates are required to the outputs of this recipe.

This method only computes which changes would be needed to make the schema of the outputs of the recipe match the actual schema that the recipe will produce. To effectively apply these changes to the outputs, you can use the `apply()` on the returned object.

Note

Not all recipe types can compute automatically the schema of their outputs. Code recipes like Python recipes, notably can’t. This method raises an exception in these cases.

Usage example:
    
    
    required_updates = recipe.compute_schema_updates()
    if required_updates.any_action_required():
        print("Some schemas will be updated")
    
    # Note that you can call apply even if no changes are required. This will be noop
    required_updates.apply()
    

Returns:
    

an object containing the required updates

Return type:
    

`RequiredSchemaUpdates`

run(_job_type ='NON_RECURSIVE_FORCED_BUILD'_, _partitions =None_, _wait =True_, _no_fail =False_)
    

Starts a new job to run this recipe and wait for it to complete.

Raises if the job failed.
    
    
    job = recipe.run()
    print("Job %s done" % job.id)
    

Parameters:
    

  * **job_type** (_string_) – job type. One of RECURSIVE_BUILD, NON_RECURSIVE_FORCED_BUILD or RECURSIVE_FORCED_BUILD

  * **partitions** (_string_) – if the outputs are partitioned, a partition spec. A spec is a comma-separated list of partition identifiers, and a partition identifier is a pipe-separated list of values for the partitioning dimensions

  * **no_fail** (_boolean_) – if True, does not raise if the job failed

  * **wait** (_boolean_) – if True, the method waits for the job completion. If False, the method returns immediately



Returns:
    

a job handle corresponding to the recipe run

Return type:
    

[`dataikuapi.dss.job.DSSJob`](<jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob")

delete()
    

Delete the recipe.

rename(_new_name_)
    

Rename the recipe with the new specified name

Parameters:
    

**new_name** (_str_) – the new name of the recipe

get_settings()
    

Get the settings of the recipe, as a `DSSRecipeSettings` or one of its subclasses.

Some recipes have a dedicated class for the settings, with additional helpers to read and modify the settings

Once you are done modifying the returned settings object, you can call `save()` on it in order to save the modifications to the DSS recipe.

Return type:
    

`DSSRecipeSettings` or a subclass

get_definition_and_payload()
    

Get the definition of the recipe.

Attention

Deprecated. Use `get_settings()`

Returns:
    

an object holding both the raw definition of the recipe (the type, which inputs and outputs, engine settings…) and the payload (SQL script, Python code, join definition,… depending on type)

Return type:
    

`DSSRecipeDefinitionAndPayload`

set_definition_and_payload(_definition_)
    

Set the definition of the recipe.

Attention

Deprecated. Use `get_settings()` then `DSSRecipeSettings.save()`

Important

The **definition** parameter should come from a call to `get_definition()`

Parameters:
    

**definition** (_object_) – a recipe definition, as returned by `get_definition()`

get_status()
    

Gets the status of this recipe.

The status of a recipe is made of messages from checks performed by DSS on the recipe, of messages related to engines availability for the recipe, of messages about testing the recipe on the engine, …

Returns:
    

an object to interact with the status

Return type:
    

`dataikuapi.dss.recipe.DSSRecipeStatus`

get_metadata()
    

Get the metadata attached to this recipe.

The metadata contains label, description checklists, tags and custom metadata of the recipe

Returns:
    

the metadata as a dict, with fields:

  * **label** : label of the object (not defined for recipes)

  * **description** : description of the object (not defined for recipes)

  * **checklists** : checklists of the object, as a dict with a **checklists** field, which is a list of checklists, each a dict.

  * **tags** : list of tags, each a string

  * **custom** : custom metadata, as a dict with a **kv** field, which is a dict with any contents the user wishes

  * **customFields** : dict of custom field info (not defined for recipes)




Return type:
    

dict

set_metadata(_metadata_)
    

Set the metadata on this recipe.

Important

You should only set a **metadata** object that has been retrieved using `get_metadata()`.

Params dict metadata:
    

the new state of the metadata for the recipe.

get_object_discussions()
    

Get a handle to manage discussions on the recipe.

Returns:
    

the handle to manage discussions

Return type:
    

[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")

get_continuous_activity()
    

Get a handle on the associated continuous activity.

Note

Should only be used on continuous recipes.

Return type:
    

[`dataikuapi.dss.continuousactivity.DSSContinuousActivity`](<streaming-endpoints.html#dataikuapi.dss.continuousactivity.DSSContinuousActivity> "dataikuapi.dss.continuousactivity.DSSContinuousActivity")

move_to_zone(_zone_)
    

Move this object to a flow zone.

Parameters:
    

**zone** (_object_) – a [`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone") where to move the object

_class _dataikuapi.dss.recipe.DSSRecipeListItem(_client_ , _data_)
    

An item in a list of recipes.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.list_recipes()`](<projects.html#dataikuapi.dss.project.DSSProject.list_recipes> "dataikuapi.dss.project.DSSProject.list_recipes")

to_recipe()
    

Gets a handle corresponding to this recipe.

Return type:
    

`DSSRecipe`

_property _name
    

Get the name of the recipe.

Return type:
    

string

_property _id
    

Get the identifier of the recipe.

For recipes, the name is the identifier.

Return type:
    

string

_property _type
    

Get the type of the recipe.

Returns:
    

a recipe type, for example ‘sync’ or ‘join’

Return type:
    

string

_property _tags
    

_class _dataikuapi.dss.recipe.DSSRecipeStatus(_client_ , _data_)
    

Status of a recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_status()`

get_selected_engine_details()
    

Get the selected engine for this recipe.

This method will raise if there is no selected engine, whether it’s because the present recipe type has no notion of engine, or because DSS couldn’t find any viable engine for running the recipe.

Returns:
    

a dict of the details of the selected engine. The type of engine is in a **type** field. Depending on the type, additional field will give more details, like whether some aggregations are possible.

Return type:
    

dict

get_engines_details()
    

Get details about all possible engines for this recipe.

This method will raise if there is no engine, whether it’s because the present recipe type has no notion of engine, or because DSS couldn’t find any viable engine for running the recipe.

Returns:
    

a list of dict of the details of each possible engine. See `get_selected_engine_details()` for the fields of each dict.

Return type:
    

list[dict]

get_status_severity()
    

Get the overall status of the recipe.

This is the final result of checking the different parts of the recipe, and depends on the recipe type. Examples of checks done include:

  * checking the validity of the formulas in computed columns or filters

  * checking if some of the input columns retrieved by joins overlap

  * checking against the SQL database if the generated SQL is valid




Returns:
    

SUCCESS, WARNING, ERROR or INFO. None if the status has no message at all.

Return type:
    

string

get_status_messages(_as_objects =False_)
    

Returns status messages for this recipe.

Parameters:
    

**as_objects** (_boolean_) – if True, return a list of [`dataikuapi.dss.utils.DSSInfoMessage`](<utils.html#dataikuapi.dss.utils.DSSInfoMessage> "dataikuapi.dss.utils.DSSInfoMessage"). If False, as a list of raw dicts.

Returns:
    

if **as_objects** is True, a list of [`dataikuapi.dss.utils.DSSInfoMessage`](<utils.html#dataikuapi.dss.utils.DSSInfoMessage> "dataikuapi.dss.utils.DSSInfoMessage"), otherwise a list of message information, each one a dict of:

>   * **severity** : severity of the error in the message. Possible values are SUCCESS, INFO, WARNING, ERROR
> 
>   * **isFatal** : for ERROR **severity** , whether the error is considered fatal to the operation
> 
>   * **code** : a string with a well-known code documented in [DSS doc](<https://doc.dataiku.com/dss/latest/troubleshooting/errors/index.html>)
> 
>   * **title** : short message
> 
>   * **message** : the error message
> 
>   * **details** : a more detailed error description
> 
> 


Return type:
    

list

_class _dataikuapi.dss.recipe.RequiredSchemaUpdates(_recipe_ , _data_)
    

Handle on a set of required updates to the schema of the outputs of a recipe.

Important

Do not instantiate directly, use `DSSRecipe.compute_schema_updates()`

For example, changes can be new columns in the output of a Group recipe when new aggregates are activated in the recipe’s settings.

any_action_required()
    

Whether there are changes at all.

Return type:
    

boolean

apply()
    

Apply the changes.

All the updates found to be required are applied, for each of the recipe’s outputs.

## Settings

_class _dataikuapi.dss.recipe.DSSRecipeSettings(_recipe_ , _data_)
    

Settings of a recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

save()
    

Save back the recipe in DSS.

_property _type
    

Get the type of the recipe.

Returns:
    

a type, like ‘sync’, ‘python’ or ‘join’

Return type:
    

string

_property _str_payload
    

The raw “payload” of the recipe.

This is exactly the data persisted on disk.

Returns:
    

for code recipes, the payload will be the script of the recipe. For visual recipes, the payload is a JSON of settings that are specific to the recipe type, like the definitions of the aggregations for a grouping recipe.

Return type:
    

string

_property _obj_payload
    

The “payload” of the recipe, parsed from JSON.

Note

Do not use on code recipes, their payload isn’t JSON-encoded.

Returns:
    

settings that are specific to the recipe type, like the definitions of the aggregations for a grouping recipe.

Return type:
    

dict

_property _raw_params
    

The non-payload settings of the recipe.

Returns:
    

recipe type-specific settings that aren’t stored in the payload. Typically this comprises engine settings.

Return type:
    

dict

get_recipe_raw_definition()
    

Get the recipe definition.

Returns:
    

the part of the recipe’s settings that aren’t stored in the payload, as a dict. Notable fields are:

  * **name** and **projectKey** : identifiers of the recipe

  * **type** : type of the recipe

  * **params** : type-specific parameters of the recipe (on top of what is in the payload)

  * **inputs** : input roles to the recipe, as a dict of role name to role, where a role is a dict with an **items** field consisting of a list of one dict per input object. Each individual input has fields:

>     * **ref** : a dataset name or a managed folder id or a saved model id. Should be prefixed by the project key for exposed items, like in “PROJECT_KEY.dataset_name”
> 
>     * **deps** : for partitioned inputs, a list of partition dependencies mapping output dimensions to dimensions in this input. Each partition dependency is a dict.

  * **outputs** : output roles to the recipe, as a dict of role name to role, where a role is a dict with a **items** field consisting of a list of one dict per output object. Each individual output has fields:

>     * **ref** : a dataset name or a managed folder id or a saved model id. Should be prefixed by the project key for exposed items, like in “PROJECT_KEY.dataset_name”
> 
>     * **appendMode** : if True, the recipe should append into the output; if False, the recipe should overwrite the output when running




Return type:
    

dict

get_recipe_inputs()
    

Get the inputs to this recipe.

Return type:
    

dict

get_recipe_outputs()
    

Get the outputs of this recipe.

Return type:
    

dict

get_recipe_params()
    

The non-payload settings of the recipe.

Returns:
    

recipe type-specific settings that aren’t stored in the payload. Typically this comprises engine settings.

Return type:
    

dict

get_payload()
    

The raw “payload” of the recipe.

This is exactly the data persisted on disk.

Returns:
    

for code recipes, the payload will be the script of the recipe. For visual recipes, the payload is a JSON of settings that are specific to the recipe type, like the definitions of the aggregations for a grouping recipe.

Return type:
    

string

get_json_payload()
    

The “payload” of the recipe, parsed from JSON.

Note

Do not use on code recipes, their payload isn’t JSON-encoded.

Returns:
    

settings that are specific to the recipe type, like the definitions of the aggregations for a grouping recipe.

Return type:
    

dict

set_payload(_payload_)
    

Set the payload of this recipe.

Parameters:
    

**payload** (_string_) – the payload, as a string

set_json_payload(_payload_)
    

Set the payload of this recipe.

Parameters:
    

**payload** (_dict_) – the payload, as a dict. Will be converted to JSON internally.

has_input(_input_ref_)
    

Whether a ref is part of the recipe’s inputs.

Parameters:
    

**input_ref** (_string_) – a ref to an object in DSS, i.e. a dataset name or a managed folder id or a saved model id. Should be prefixed by the project key for exposed items, like in “PROJECT_KEY.dataset_name”

Return type:
    

boolean

has_output(_output_ref_)
    

Whether a ref is part of the recipe’s outputs.

Parameters:
    

**output_ref** (_string_) – a ref to an object in DSS, i.e. a dataset name or a managed folder id or a saved model id. Should be prefixed by the project key for exposed items, like in “PROJECT_KEY.dataset_name”

Return type:
    

boolean

replace_input(_current_input_ref_ , _new_input_ref_)
    

Replaces an input of this recipe by another.

If the **current_input_ref** isn’t part of the recipe’s inputs, this method has no effect.

Parameters:
    

  * **current_input_ref** (_string_) – a ref to an object in DSS, i.e. a dataset name or a managed folder id or a saved model id, that is currently input to the recipe

  * **new_input_ref** (_string_) – a ref to an object in DSS, i.e. a dataset name or a managed folder id or a saved model id, that **current_input_ref** should be replaced with.




replace_output(_current_output_ref_ , _new_output_ref_)
    

Replaces an output of this recipe by another.

If the **current_output_ref** isn’t part of the recipe’s outputs, this method has no effect.

Parameters:
    

  * **current_output_ref** (_string_) – a ref to an object in DSS, i.e. a dataset name or a managed folder id or a saved model id, that is currently output to the recipe

  * **new_output_ref** (_string_) – a ref to an object in DSS, i.e. a dataset name or a managed folder id or a saved model id, that **current_output_ref** should be replaced with.




add_input(_role_ , _ref_ , _partition_deps =None_)
    

Add an input to the recipe.

For most recipes, there is only one role, named “main”. Some few recipes have additional roles, like scoring recipes which have a “model” role. Check the roles known to the recipe with `get_recipe_inputs()`.

Parameters:
    

  * **role** (_string_) – name of the role of the recipe in which to add **ref** as input

  * **ref** (_string_) – a ref to an object in DSS, i.e. a dataset name or a managed folder id or a saved model id

  * **partition_deps** (_list_) – if **ref** points to a partitioned object, a list of partition dependencies, one per dimension in the partitioning scheme




add_output(_role_ , _ref_ , _append_mode =False_)
    

Add an output to the recipe.

For most recipes, there is only one role, named “main”. Some few recipes have additional roles, like evaluation recipes which have a “metrics” role. Check the roles known to the recipe with `get_recipe_outputs()`.

Parameters:
    

  * **role** (_string_) – name of the role of the recipe in which to add **ref** as input

  * **ref** (_string_) – a ref to an object in DSS, i.e. a dataset name or a managed folder id or a saved model id

  * **partition_deps** (_list_) – if **ref** points to a partitioned object, a list of partition dependencies, one per dimension in the partitioning scheme




get_flat_input_refs()
    

List all input refs of this recipe, regardless of the input role.

Returns:
    

a list of refs, i.e. of dataset names or managed folder ids or saved model ids

Return type:
    

list[string]

get_flat_output_refs()
    

List all output refs of this recipe, regardless of the input role.

Returns:
    

a list of refs, i.e. of dataset names or managed folder ids or saved model ids

Return type:
    

list[string]

_property _custom_fields
    

The custom fields of the object as a dict. Returns None if there are no custom fields

_property _description
    

The description of the object as a string

_property _short_description
    

The short description of the object as a string

_property _tags
    

The tags of the object, as a list of strings

_class _dataikuapi.dss.recipe.DSSRecipeDefinitionAndPayload(_recipe_ , _data_)
    

Settings of a recipe.

Note

Deprecated. Alias to `DSSRecipeSettings`, use `DSSRecipe.get_settings()` instead.

_class _dataikuapi.dss.recipe.CodeRecipeSettings(_recipe_ , _data_)
    

Settings of a code recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

get_code()
    

Get the code of the recipe.

Return type:
    

string

set_code(_code_)
    

Update the code of the recipe.

Parameters:
    

**code** (_string_) – the new code

get_code_env_settings()
    

Get the code env settings for this recipe.

Returns:
    

settings to select the code env used by the recipe, as a dict of:

  * **envMode** : one of USE_BUILTIN_MODE, INHERIT (inherit from project settings and/or instance settings), EXPLICIT_ENV

  * **envName** : if **envMode** is EXPLICIT_ENV, the name of the code env to use




Return type:
    

dict

set_code_env(_code_env =None_, _inherit =False_, _use_builtin =False_)
    

Set which code env this recipe uses.

Exactly one of code_env, inherit or use_builtin must be passed.

Parameters:
    

  * **code_env** (_string_) – name of a code env

  * **inherit** (_boolean_) – if True, use the project’s default code env

  * **use_builtin** (_boolean_) – if true, use the builtin code env




_class _dataikuapi.dss.recipe.SyncRecipeSettings(_recipe_ , _data_)
    

Settings of a Sync recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_class _dataikuapi.dss.recipe.PrepareRecipeSettings(_recipe_ , _data_)
    

Settings of a Prepare recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_property _raw_steps
    

Get the list of the steps of this prepare recipe.

This method returns a reference to the list of steps, not a copy. Modifying the list then calling `DSSRecipeSettings.save()` commits the changes.

Returns:
    

list of steps, each step as a dict. The precise settings for each step are not documented, but each dict has at least fields:

>   * **metaType** : one of PROCESSOR or GROUP. If GROUP, there there is a field **steps** with a sub-list of steps.
> 
>   * **type** : type of the step, for example FillEmptyWithValue or ColumnRenamer (there are many types of steps)
> 
>   * **params** : dict of the step’s own parameters. Each step type has its own parameters.
> 
>   * **disabled** : whether the step is disabled
> 
>   * **name** : label of the step
> 
> 


Return type:
    

list[dict]

add_processor_step(_type_ , _params_)
    

Add a step in the script.

Parameters:
    

  * **type** (_string_) – type of the step, for example FillEmptyWithValue or ColumnRenamer (there are many types of steps)

  * **params** (_dict_) – dict of the step’s own parameters. Each step type has its own parameters.




_class _dataikuapi.dss.recipe.SamplingRecipeSettings(_recipe_ , _data_)
    

Settings of a sampling recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_class _dataikuapi.dss.recipe.GroupingRecipeSettings(_recipe_ , _data_)
    

Settings of a grouping recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

clear_grouping_keys()
    

Clear all grouping keys.

add_grouping_key(_column_)
    

Adds grouping on a column.

Parameters:
    

**column** (_string_) – column to group on

set_global_count_enabled(_enabled_)
    

Activate computing the count of records per group.

Parameters:
    

**enabled** (_boolean_) – True if the global count should be activated

get_or_create_column_settings(_column_)
    

Get a dict representing the aggregations to perform on a column.

If the column has no aggregation on it yet, the dict is created and added to the settings.

Parameters:
    

**column** (_string_) – name of the column to aggregate on

Returns:
    

the settings of the aggregations on a particular column, as a dict. The name of the column to perform aggregates on is in a **column** field, and the aggregates are toggled on or off with boolean fields.

Return type:
    

dict

set_column_aggregations(_column_ , _type =None_, _min =False_, _max =False_, _count =False_, _count_distinct =False_, _sum =False_, _concat =False_, _stddev =False_, _avg =False_)
    

Set the basic aggregations on a column.

Note

Not all aggregations may be possible. For example string-typed columns don’t have a mean or standard deviation, and some SQL databases can’t compute the exact standard deviation.

The method returns a reference to the settings of the column, not a copy. Modifying the dict returned by the method, then calling `DSSRecipeSettings.save()` will commit the changes.

Usage example:
    
    
    # activate the concat aggregate on a column, and set optional parameters
    # pertaining to concatenation
    settings = recipe.get_settings()
    column_settings = settings.set_column_aggregations("my_column_name", concat=True)
    column_settings["concatDistinct"] = True
    column_settings["concatSeparator"] = ', '
    settings.save()
    

Parameters:
    

  * **column** (_string_) – The column name

  * **type** (_string_) – The type of the column (as a DSS schema type name)

  * **min** (_boolean_) – whether the min aggregate is computed

  * **max** (_boolean_) – whether the max aggregate is computed

  * **count** (_boolean_) – whether the count aggregate is computed

  * **count_distinct** (_boolean_) – whether the count distinct aggregate is computed

  * **sum** (_boolean_) – whether the sum aggregate is computed

  * **concat** (_boolean_) – whether the concat aggregate is computed

  * **avg** (_boolean_) – whether the mean aggregate is computed

  * **stddev** (_boolean_) – whether the standard deviation aggregate is computed



Returns:
    

the settings of the aggregations on a the column, as a dict. The name of the column is in a **column** field.

Return type:
    

dict

_class _dataikuapi.dss.recipe.SortRecipeSettings(_recipe_ , _data_)
    

Settings of a Sort recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_property _row_number_column_enabled
    

Get or set whether to add a row number column.

  * **Getter** : Returns True if the row number column is enabled, False otherwise.

  * **Setter** : Sets whether to add the row number column.




Returns:
    

whether the row number column is enabled

Return type:
    

bool

_property _rank_column_enabled
    

Get or set whether to add a rank column.

  * **Getter** : Returns True if the rank column is enabled, False otherwise.

  * **Setter** : Sets whether to add the rank column.




Returns:
    

whether the rank column is enabled

Return type:
    

bool

_property _dense_rank_column_enabled
    

Get or set whether to add a dense rank column.

  * **Getter** : Returns True if the dense rank column is enabled, False otherwise.

  * **Setter** : Sets whether to add the dense rank column.




Returns:
    

whether the dense rank column is enabled

Return type:
    

bool

clear_sorting_keys()
    

Removes all sorting keys from the recipe settings.

add_sorting_key(_column_ , _ascending =True_)
    

Adds a column to the sorting keys.

Parameters:
    

  * **column** (_str_) – Name of the column to sort by.

  * **ascending** (_bool_) – Whether to sort in ascending order. Defaults to True.




_class _dataikuapi.dss.recipe.TopNRecipeSettings(_recipe_ , _data_)
    

Settings of a TopN recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_class _dataikuapi.dss.recipe.DistinctRecipeSettings(_recipe_ , _data_)
    

Settings of a Distinct recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_class _dataikuapi.dss.recipe.PivotRecipeSettings(_recipe_ , _data_)
    

Settings of a Pivot recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_class _dataikuapi.dss.recipe.WindowRecipeSettings(_recipe_ , _data_)
    

Settings of a Window recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_class _dataikuapi.dss.recipe.JoinRecipeSettings(_recipe_ , _data_)
    

Settings of a join recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

In order to enable self-joins, join recipes are based on a concept of “virtual inputs”. Every join, computed pre-join column, pre-join filter, … is based on one virtual input, and each virtual input references an input of the recipe, by index

For example, if a recipe has inputs A and B and declares two joins:

>   * A->B
> 
>   * A->A (based on a computed column)
> 
> 


There are 3 virtual inputs:

>   * 0: points to recipe input 0 (i.e. dataset A)
> 
>   * 1: points to recipe input 1 (i.e. dataset B)
> 
>   * 2: points to recipe input 0 (i.e. dataset A) and includes the computed column
> 
> 


  * The first join is between virtual inputs 0 and 1

  * The second join is between virtual inputs 0 and 2




_property _raw_virtual_inputs
    

Get the list of virtual inputs.

This method returns a reference to the list of inputs, not a copy. Modifying the list then calling `DSSRecipeSettings.save()` commits the changes.

Returns:
    

a list of virtual inputs, each one a dict. The field **index** holds the index of the dataset of this virtual input in the recipe’s list of inputs. Pre-filter, computed columns and column selection properties (if applicable) are defined in each virtual input.

Return type:
    

list[dict]

_property _raw_joins
    

Get raw list of joins.

This method returns a reference to the list of joins, not a copy. Modifying the list then calling `DSSRecipeSettings.save()` commits the changes.

Returns:
    

list of the join definitions, each as a dict. The **table1** and **table2** fields give the indices of the virtual inputs on the left side and right side respectively.

Return type:
    

list[dict]

add_virtual_input(_input_dataset_index_)
    

Add a virtual input pointing to the specified input dataset of the recipe.

Parameters:
    

**input_dataset_index** (_int_) – index of the dataset in the list of input_dataset_index

add_pre_join_computed_column(_virtual_input_index_ , _computed_column_)
    

Add a computed column to a virtual input.

You can use `dataikuapi.dss.utils.DSSComputedColumn.formula()` to build the computed_column object.

Parameters:
    

  * **input_dataset_index** (_int_) – index of the dataset in the list of input_dataset_index

  * **computed_column** (_dict_) – 

a computed column definition, as a dict of:

    * **mode** : type of expression used to define the computations. One of GREL or SQL.

    * **name** : name of the column generated

    * **type** : name of a DSS type for the computed column

    * **expr** : if **mode** is CUSTOM, a formula in DSS [formula language](<https://doc.dataiku.com/dss/latest/formula/index.html>) . If **mode** is SQL, a SQL expression.




add_join(_join_type ='LEFT'_, _input1 =0_, _input2 =1_)
    

Add a join between two virtual inputs.

The join is initialized with no condition.

Use `add_condition_to_join()` on the return value to add a join condition (for example column equality) to the join.

Returns:
    

the newly added join as a dict (see `raw_joins()`)

Return type:
    

dict

_static _add_condition_to_join(_join_ , _type ='EQ'_, _column1 =None_, _column2 =None_)
    

Add a condition to a join.

Parameters:
    

  * **join** (_dict_) – definition of a join

  * **type** (_string_) – type of join condition. Possible values are EQ, LTE, LT, GTE, GT, NE, WITHIN_RANGE, K_NEAREST, K_NEAREST_INFERIOR, CONTAINS, STARTS_WITH

  * **column1** (_string_) – name of left-side column

  * **column2** (_string_) – name of right-side column




add_post_join_computed_column(_computed_column_)
    

Add a post-join computed column.

Use `dataikuapi.dss.utils.DSSComputedColumn` to build the computed_column object.

Note

The columns accessible to the expression of the computed column are those selected in the different joins, in their “output” form. For example if a virtual inputs 0 and 1 are joined, and column “bar” of the first input is selected with a prefix of “foo”, then the computed column can use “foobar” but not “bar”.

Parameters:
    

**computed_column** (_dict_) – 

a computed column definition, as a dict of:

  * **mode** : type of expression used to define the computations. One of GREL or SQL.

  * **name** : name of the column generated

  * **type** : name of a DSS type for the computed column

  * **expr** : if **mode** is CUSTOM, a formula in DSS [formula language](<https://doc.dataiku.com/dss/latest/formula/index.html>) . If **mode** is SQL, a SQL expression.




set_post_filter(_postfilter_)
    

Add a post filter on the join.

Use the methods on `dataikuapi.dss.utils.DSSFilter` to build filter definition.

Parameters:
    

**postfilter** (_dict_) – 

definition of a filter, as a dict of:

  * **distinct** : whether the records in the output should be deduplicated

  * **enabled** : whether filtering is enabled

  * **uiData** : settings of the filter, if **enabled** is True, as a dict of:

>     * **mode** : type of filter. Possible values: CUSTOM, SQL, ‘&&’ (boolean AND of conditions) and ‘||’ (boolean OR of conditions)
> 
>     * **conditions** : if mode is ‘&&’ or ‘||’, then a list of the actual filter conditions, each one a dict

  * **expression** : if **uiData.mode** is CUSTOM, a formula in DSS [formula language](<https://doc.dataiku.com/dss/latest/formula/index.html>) . If **uiData.mode** is SQL, a SQL expression.




set_unmatched_output(_ref_ , _side ='right'_, _append_mode =False_)
    

Adds an unmatched join output

Parameters:
    

  * **ref** (_str_) – name of the dataset

  * **side** (_str_) – side of the unmatched output, ‘right’ or ‘left’.

  * **append_mode** (_bool_) – whether the recipe should append or overwrite the output when running




_class _dataikuapi.dss.recipe.DownloadRecipeSettings(_recipe_ , _data_)
    

Settings of a download recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_class _dataikuapi.dss.recipe.SplitRecipeSettings(_recipe_ , _data_ , _project_)
    

Settings of a split recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_property _split_mode
    

Gets the current split mode.

Mode can either be VALUES | RANGE | RANDOM | RANDOM_COLUMNS | FILTER | CENTILE.

Returns:
    

The current split mode.

Return type:
    

str

set_split_on_single_column_values(_column_name_ , _splits_ , _default_output_index =None_, _default_output =None_)
    

Sets the split mode to ‘VALUES’.

In this mode, records are mapped to a given output dataset based on the value of the column column_name

Parameters:
    

  * **column_name** (_str_) – name of the column used as reference to split records

  * **splits** (_list_) – 

list of datasets data are mapped to when conditions are fulfilled. Each split is a dict with the following keys :

    * **output** : dict that dictates the behavior of this split with the following values :

>       * **mode** : str that can only be equal to ‘drop’, ‘dataset’ or ‘index’.
>
>>         * if set to ‘drop’, all the data that matches the conditions of this split are dropped
>> 
>>         * if set to ‘dataset’, all the data that matches the conditions of this split are sent to the dataset with the name of **value**
>> 
>>         * if set to ‘index’, all the data that matches the conditions of this split are dispatched to the dataset at the index of **value**
> 
>       * **value** : bool|str|None depending on the value of **mode**

    * **value** : condition to map the record to the given output dataset, which is if the record’s **column_name** value is the same as **value**

  * **default_output_index** (_integer_) – All remaining rows that are put in the Dataset corresponding to the default_output_index. If both default_output_index and default_output are unset, the data is dropped.

  * **default_output** (_str_) – All remaining rows that are put in the Dataset whose name corresponds to the default_output. If set but no dataset name matches, raises an Exception. If both default_output_index and default_output are unset, the data is dropped.




set_split_on_single_column_ranges(_column_name_ , _column_type_ , _splits_ , _default_output_index =None_, _default_output =None_)
    

Sets the split mode to ‘RANGE’.

In this mode, records are mapped to a given output dataset based on the value of the input column_name according to range conditions set in **splits**

Parameters:
    

  * **column_name** (_str_) – name of the column used as reference to split records

  * **column_type** (_str_) – type of the column used as reference to split records, can only be date, datetime or num

  * **splits** (_list_) – 

list of datasets data are mapped to when conditions are fulfilled. Each split is a dict with the following keys :

    * **output** : dict that dictates the behavior of this split with the following values :

>       * **mode** : str that can only be equal to ‘drop’, ‘dataset’ or ‘index’.
>
>>         * if set to ‘drop’, all the data that matches the conditions of this split are dropped
>> 
>>         * if set to ‘dataset’, all the data that matches the conditions of this split are sent to the dataset with the name of **value**
>> 
>>         * if set to ‘index’, all the data that matches the conditions of this split are dispatched to the dataset at the index of **value**
> 
>       * **value** : bool|str|None depending on the value of **mode**

    * **min** : lower bound of the range split, can be a number, a date, a datetime or a string with format %Y-%m-%d %H:%M or %Y-%m-%d, and must correspond to the type set in column_type

    * **max** : upper bound of the range split, can be a number, a date, a datetime or a string with format %Y-%m-%d %H:%M or %Y-%m-%d, and must correspond to the type set in column_type

    * **include_min** (optional) : if true, the lower bound value is included in the range split, true by default

    * **include_max** (optional) : if true, the upper bound value is included in the range split, true by default

  * **default_output_index** (_integer_) – All remaining rows that are put in the Dataset corresponding to the default_output_index. If both default_output_index and default_output are unset, the data is dropped.

  * **default_output** (_str_) – All remaining rows that are put in the Dataset whose name corresponds to the default_output. If set but no dataset name matches, raises an Exception. If both default_output_index and default_output are unset, the data is dropped.




set_split_on_random_ratio(_splits_ , _seed =1337_, _default_output_index =None_, _default_output =None_)
    

Sets the split mode to ‘RANDOM’.

In this mode, records are mapped randomly to a given output dataset based on a ratio of data to be dispatched

Parameters:
    

  * **splits** (_list_) – 

list of datasets data are mapped to when conditions are fulfilled.

Each split is a dict with the following keys :

    * **output** : dict that dictates the behavior of this split with the following values :

>       * **mode** : str that can only be equal to ‘drop’, ‘dataset’ or ‘index’.
>
>>         * if set to ‘drop’, all the data that matches the conditions of this split are dropped
>> 
>>         * if set to ‘dataset’, all the data that matches the conditions of this split are sent to the dataset with the name of **value**
>> 
>>         * if set to ‘index’, all the data that matches the conditions of this split are dispatched to the dataset at the index of **value**
> 
>       * **value** : bool|str|None depending on the value of **mode**

    * **share** : float between 0 and 100 that describes the ratio of records to be mapped to this dataset

  * **seed** (_integer_) – Seed used to initialize the random number generator.

  * **default_output_index** (_integer_) – All remaining rows that are put in the Dataset corresponding to the default_output_index. If both default_output_index and default_output are unset, the data is dropped.

  * **default_output** (_str_) – All remaining rows that are put in the Dataset whose name corresponds to the default_output. If set but no dataset name matches, raises an Exception. If both default_output_index and default_output are unset, the data is dropped.




set_split_on_random_columns(_random_columns_ , _splits_ , _seed =1337_, _default_output_index =None_, _default_output =None_)
    

Sets the split mode to ‘RANDOM_COLUMNS’.

In this mode, records are grouped based on one or multiple columns set in random_columns, and the data is randomly split according to given ratios. This mode ensures all records of a single group to end up in the same output dataset. As an example, you can use this mode to create train and test sets containing distinct clients. This would enable training a machine learning model and testing it on previously unseen clients. Group rows with the same values for columns and randomly dispatch on outputs Grouping keys must take sufficiently diverse values, otherwise the split cannot be fair.

Parameters:
    

  * **random_columns** (_list_) – list of string corresponding to the list of input columns to group on.

  * **splits** (_list_) – 

list of datasets data are mapped to when conditions are fulfilled. Each split is a dict with the following keys :

    * **output** : dict that dictates the behavior of this split with the following values :

>       * **mode** : str that can only be equal to ‘drop’, ‘dataset’ or ‘index’.
>
>>         * if set to ‘drop’, all the data that matches the conditions of this split are dropped
>> 
>>         * if set to ‘dataset’, all the data that matches the conditions of this split are sent to the dataset with the name of **value**
>> 
>>         * if set to ‘index’, all the data that matches the conditions of this split are dispatched to the dataset at the index of **value**
> 
>       * **value** : bool|str|None depending on the value of **mode**

    * **share** : float between 0 and 100 that describes the ratio of records to be mapped to this dataset

  * **seed** (_integer_) – Seed used to initialize the random number generator.

  * **default_output_index** (_integer_) – All remaining rows that are put in the Dataset corresponding to the default_output_index. If both default_output_index and default_output are unset, the data is dropped.

  * **default_output** (_str_) – All remaining rows that are put in the Dataset whose name corresponds to the default_output. If set but no dataset name matches, raises an Exception. If both default_output_index and default_output are unset, the data is dropped.




set_split_on_filters(_splits_ , _default_output_index =None_, _default_output =None_)
    

Sets the split mode to ‘FILTER’.

In this mode, records are mapped to a given output dataset based on input filters containing conditions to be satisfied

Use the methods on `dataikuapi.dss.utils.DSSFilter` to build filter definition.

Parameters:
    

  * **splits** (_list_) – 

list of datasets data are mapped to when conditions are fulfilled. Each split is a dict with the following keys :

    * **output** : dict that dictates the behavior of this split with the following values :

>       * **mode** : str that can only be equal to ‘drop’, ‘dataset’ or ‘index’.
>
>>         * if set to ‘drop’, all the data that matches the conditions of this split are dropped
>> 
>>         * if set to ‘dataset’, all the data that matches the conditions of this split are sent to the dataset with the name of **value**
>> 
>>         * if set to ‘index’, all the data that matches the conditions of this split are dispatched to the dataset at the index of **value**
> 
>       * **value** : bool|str|None depending on the value of **mode**

    * **filter** : DSSFilter filter object to be constructed from the static methods in the helper class dataikuapi.dss.utils.DSSFilter

  * **default_output_index** (_integer_) – All remaining rows that are put in the Dataset corresponding to the default_output_index. If both default_output_index and default_output are unset, the data is dropped.

  * **default_output** (_str_) – All remaining rows that are put in the Dataset whose name corresponds to the default_output. If set but no dataset name matches, raises an Exception. If both default_output_index and default_output are unset, the data is dropped.




set_split_on_centiles(_centile_orders_ , _splits_ , _default_output_index =None_, _default_output =None_)
    

Sets the split mode to ‘CENTILE’.

In this mode, records are ordered based on the column name and order listed in centile_orders, then mapped to a given output dataset based on a ratio of data to be dispatched

Parameters:
    

  * **centile_orders** (_list_) – 

list of columns data are ordered by before being dispatched to output datasets.

Each centile_order is a dict with the following keys :

    * **column** : name of the column used as reference to order records

    * **desc** : if true, the data is ordered in descending order, otherwise in ascending order

  * **splits** (_list_) – 

list of datasets data are mapped to when conditions are fulfilled. Each split is a dict with the following keys :

    * **output** : dict that dictates the behavior of this split with the following values :

>       * **mode** : str that can only be equal to ‘drop’, ‘dataset’ or ‘index’.
>
>>         * if set to ‘drop’, all the data that matches the conditions of this split are dropped
>> 
>>         * if set to ‘dataset’, all the data that matches the conditions of this split are sent to the dataset with the name of **value**
>> 
>>         * if set to ‘index’, all the data that matches the conditions of this split are dispatched to the dataset at the index of **value**
> 
>       * **value** : bool|str|None depending on the value of **mode**

    * **share** : float between 0 and 100 that describes the ratio of records to be mapped to this dataset

  * **default_output_index** (_integer_) – All remaining rows that are put in the Dataset corresponding to the default_output_index. If set to None, the data is dropped.

  * **default_output** (_str_) – All remaining rows that are put in the Dataset whose name corresponds to the default_output. If set but no dataset name matches, raises an Exception. If both default_output_index and default_output are unset, the data is dropped.




_class _FieldName
    

MIN _ = 'min'_
    

MAX _ = 'max'_
    

_class _dataikuapi.dss.recipe.StackRecipeSettings(_recipe_ , _data_)
    

Settings of a stack recipe.

Important

Do not instantiate directly, use `DSSRecipe.get_settings()`

_property _raw_virtual_inputs
    

Get the list of virtual inputs.

This method returns a reference to the list of inputs, not a copy. Modifying the list then calling `DSSRecipeSettings.save()` commits the changes.

Returns:
    

a list of virtual inputs, each one a dict. The field **index** holds the index of the dataset of this virtual input in the recipe’s list of inputs. Pre-filter, computed columns and column selection properties (if applicable) are defined in each virtual input.

Return type:
    

list[dict]

_property _columns_selection_mode
    

Gets the current column selection mode.

Mode can either be UNION | INTERSECT | FROM_DATASET | REMAP | CUSTOM | FROM_INDEX.

Returns:
    

The current selection mode.

Return type:
    

str

set_union_input_schema_mode()
    

Sets the schema mode to ‘UNION’.

In this mode, the output schema is the union of all columns from all input datasets.

set_intersection_input_schema_mode()
    

Sets the schema mode to ‘INTERSECT’.

In this mode, the output schema is the intersection of columns present in all input datasets.

set_from_dataset_input_schema_mode(_dataset_name_)
    

Sets the schema mode to ‘FROM_DATASET’.

In this mode, the output schema is copied from a specific input dataset.

Parameters:
    

**dataset_name** (_str_) – The name of the input dataset to copy the schema from.

set_custom_remapping_mode(_columns_mapping_)
    

Sets the schema mode to ‘REMAP’ for custom column mapping.

This mode allows you to define a specific output schema and map columns from various input datasets to the new output columns.

The columns_mapping dictionary defines the output columns as keys. The value for each key is another dictionary mapping the _index_ of a virtual input (as an integer) to the specific column name from that input dataset.

Example:
    
    
    {
        "output_col_1": {
            0: "source_col_a", # maps "source_col_a" from virtual input 0
            1: "source_col_b"  # maps "source_col_b" from virtual input 1
        },
        "output_col_2": {
            2: "other_col",    # maps "other_col" from virtual input 2
            1: "another_col" # maps "another_col" from virtual input 1
        }
    }
    

Parameters:
    

**columns_mapping** (_dict_) – A dictionary defining the output columns and their corresponding input dataset index-to-column-name mappings.

add_origin_column(_column_name_ , _dataset_origin_mapping_)
    

Adds an ‘origin’ column to the output, indicating which input dataset each row came from.

By default, if an input dataset’s index is not in the map, its original name will be used as the value.

Example dataset_origin_mapping:
    
    
    {
        0: "dataset_origin_test", # Rows from input 0 get "dataset_origin_test"
        2: "dataset_origin_validation" # Rows from input 2 get "dataset_origin_validation"
    }
    

Parameters:
    

  * **column_name** (_str_) – The name for the new origin column.

  * **dataset_origin_mapping** (_dict_) – A dictionary mapping the virtual input index (int) to the string value to use in the origin column.




remove_origin_column()
    

Remove the ‘addOriginColumn’ setting.

This prevents the origin column from being added to the output dataset.

## Creation

_class _dataikuapi.dss.recipe.DSSRecipeCreator(_type_ , _name_ , _project_)
    

Helper to create new recipes.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

set_name(_name_)
    

Set the name of the recipe-to-be-created.

Parameters:
    

**name** (_string_) – a recipe name. Should only use alphanum letters and underscores. Cannot contain dots.

with_input(_input_id_ , _project_key =None_, _role ='main'_)
    

Add an existing object as input to the recipe-to-be-created.

Parameters:
    

  * **input_id** (_string_) – name of the dataset, or identifier of the managed folder or identifier of the saved model

  * **project_key** (_string_) – project containing the object, if different from the one where the recipe is created

  * **role** (_string_) – the role of the recipe in which the input should be added. Most recipes only have one role named “main”.




with_output(_output_id_ , _append =False_, _role ='main'_)
    

Add an existing object as output to the recipe-to-be-created.

The output dataset must already exist.

Parameters:
    

  * **output_id** (_string_) – name of the dataset, or identifier of the managed folder or identifier of the saved model

  * **append** (_boolean_) – whether the recipe should append or overwrite the output when running (note: not available for all dataset types)

  * **role** (_string_) – the role of the recipe in which the input should be added. Most recipes only have one role named “main”.




build()
    

Create the recipe.

Note

Deprecated. Alias to `create()`

create()
    

Creates the new recipe in the project, and return a handle to interact with it.

Return type:
    

`dataikuapi.dss.recipe.DSSRecipe`

set_raw_mode()
    

Activate raw creation mode.

Caution

For advanced uses only.

In this mode, the field “recipe_proto” of this recipe creator is used as-is to create the recipe, and if it exists, the value of creation_settings[“rawPayload”] is used as the payload of the created recipe. No checks of existence or validity of the inputs or outputs are done, and no output is auto-created.

_class _dataikuapi.dss.recipe.SingleOutputRecipeCreator(_type_ , _name_ , _project_)
    

Create a recipe that has a single output.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

with_existing_output(_output_id_ , _append =False_)
    

Add an existing object as output to the recipe-to-be-created.

The output dataset must already exist.

Parameters:
    

  * **output_id** (_string_) – name of the dataset, or identifier of the managed folder or identifier of the saved model

  * **append** (_boolean_) – whether the recipe should append or overwrite the output when running (note: not available for all dataset types)




with_new_output(_name_ , _connection_ , _type =None_, _format =None_, _override_sql_schema =None_, _partitioning_option_id =None_, _append =False_, _object_type ='DATASET'_, _overwrite =False_, _** kwargs_)
    

Create a new dataset or managed folder as output to the recipe-to-be-created.

The dataset or managed folder is not created immediately, but when the recipe is created (ie in the create() method). Whether a dataset is created or a managed folder is created, depends on the recipe type.

Parameters:
    

  * **name** (_string_) – name of the dataset or identifier of the managed folder

  * **connection** (_string_) – name of the connection to create the dataset or managed folder on

  * **type** (_string_) – sub-type of dataset or managed folder, for connections where the type could be ambiguous. Typically applies to SSH connections, where sub-types can be SCP or SFTP

  * **format** (_string_) – name of a format preset relevant for the dataset type. Possible values are: CSV_ESCAPING_NOGZIP_FORHIVE, CSV_UNIX_GZIP, CSV_EXCEL_GZIP, CSV_EXCEL_GZIP_BIGQUERY, CSV_NOQUOTING_NOGZIP_FORPIG, PARQUET_HIVE, AVRO, ORC

  * **override_sql_schema** (_boolean_) – schema to force dataset, for SQL dataset. If left empty, will be autodetected

  * **partitioning_option_id** (_string_) – to copy the partitioning schema of an existing dataset ‘foo’, pass a value of ‘copy:dataset:foo’. If unset, then the output will be non-partitioned

  * **append** (_boolean_) – whether the recipe should append or overwrite the output when running (note: not available for all dataset types)

  * **object_type** (_string_) – DATASET or MANAGED_FOLDER

  * **overwrite** (_boolean_) – If the dataset being created already exists, overwrite it (and delete data)




with_output(_output_id_ , _append =False_)
    

Add an existing object as output to the recipe-to-be-created.

Note

Alias of `with_existing_output()`

_class _dataikuapi.dss.recipe.VirtualInputsSingleOutputRecipeCreator(_type_ , _name_ , _project_)
    

Create a recipe that has a single output and several inputs.

with_input(_input_id_ , _project_key =None_)
    

Add an existing object as input to the recipe-to-be-created.

Parameters:
    

  * **input_id** (_string_) – name of the dataset

  * **project_key** (_string_) – project containing the object, if different from the one where the recipe is created




_class _dataikuapi.dss.recipe.CodeRecipeCreator(_name_ , _type_ , _project_)
    

Create a recipe running a script.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe")

with_script(_script_)
    

Set the code of the recipe-to-be-created.

Parameters:
    

**script** (_string_) – code of the recipe

with_new_output_dataset(_name_ , _connection_ , _type =None_, _format =None_, _copy_partitioning_from ='FIRST_INPUT'_, _append =False_, _overwrite =False_, _** kwargs_)
    

Create a new managed dataset as output to the recipe-to-be-created.

The dataset is created immediately.

Parameters:
    

  * **name** (_string_) – name of the dataset

  * **connection** (_string_) – name of the connection to create the dataset on

  * **type** (_string_) – sub-type of dataset or managed folder, for connections where the type could be ambiguous. Typically applies to SSH connections, where sub-types can be SCP or SFTP

  * **format** (_string_) – name of a format preset relevant for the dataset type. Possible values are: CSV_ESCAPING_NOGZIP_FORHIVE, CSV_UNIX_GZIP, CSV_EXCEL_GZIP, CSV_EXCEL_GZIP_BIGQUERY, CSV_NOQUOTING_NOGZIP_FORPIG, PARQUET_HIVE, AVRO, ORC

  * **partitioning_option_id** (_string_) – to copy the partitioning schema of an existing dataset ‘foo’, pass a value of ‘copy:dataset:foo’. If unset, then the output will be non-partitioned

  * **append** (_boolean_) – whether the recipe should append or overwrite the output when running (note: not available for all dataset types)

  * **overwrite** (_boolean_) – If the dataset being created already exists, overwrite it (and delete data)




with_new_output_streaming_endpoint(_name_ , _connection_ , _format =None_, _overwrite =False_, _** kwargs_)
    

Create a new managed streaming endpoint as output to the recipe-to-be-created.

The streaming endpoint is created immediately.

Parameters:
    

  * **name** (_str_) – name of the streaming endpoint to create

  * **connection** (_str_) – name of the connection to create the streaming endpoint on

  * **format** (_str_) – name of a format preset relevant for the streaming endpoint type. Possible values are: json, avro, single (kafka endpoints) or json, string (SQS endpoints). If None, uses the default

  * **overwrite** – If the streaming endpoint being created already exists, overwrite it




_class _dataikuapi.dss.recipe.PythonRecipeCreator(_name_ , _project_)
    

Create a Python recipe.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

A Python recipe can be defined either by its complete code, like a normal Python recipe, or by a function signature.

with_function_name(_module_name_ , _function_name_ , _custom_template =None_, _** function_args_)
    

Define this recipe as being a functional recipe calling a function.

With the default template, the function must take as arguments:

>   * A list of dataframes corresponding to the dataframes of the input datasets. If there is only one input, then a single dataframe
> 
>   * Optional named arguments corresponding to arguments passed to the creator as kwargs
> 
> 


The function should then return a list of dataframes, one per recipe output. If there is a single output, it is possible to return a single dataframe rather than a list.

Parameters:
    

  * **module_name** (_string_) – name of the module where the function is defined

  * **function_name** (_string_) – name of the function

  * **function_args** (_kwargs_) – additional parameters to the function.

  * **custom_template** (_string_) – template to use to create the code of the recipe. The template is formatted with ‘{fname}’ (function name), ‘{module_name}’ (module name) and ‘{params_json}’ (JSON representation of **function_args**)




with_function(_fn_ , _custom_template =None_, _** function_args_)
    

Define this recipe as being a functional recipe calling a function.

With the default template, the function must take as arguments:

>   * A list of dataframes corresponding to the dataframes of the input datasets. If there is only one input, then a single dataframe
> 
>   * Optional named arguments corresponding to arguments passed to the creator as kwargs
> 
> 


The function should then return a list of dataframes, one per recipe output. If there is a single output, it is possible to return a single dataframe rather than a list.

Parameters:
    

  * **fn** (_string_) – function to call

  * **function_args** (_kwargs_) – additional parameters to the function.

  * **custom_template** (_string_) – template to use to create the code of the recipe. The template is formatted with ‘{fname}’ (function name), ‘{module_name}’ (module name) and ‘{params_json}’ (JSON representation of **function_args**)




_class _dataikuapi.dss.recipe.SQLQueryRecipeCreator(_name_ , _project_)
    

Create a SQL query recipe.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.PrepareRecipeCreator(_name_ , _project_)
    

Create a Prepare recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.SyncRecipeCreator(_name_ , _project_)
    

Create a Sync recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.SamplingRecipeCreator(_name_ , _project_)
    

Create a Sample/Filter recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.DistinctRecipeCreator(_name_ , _project_)
    

Create a Distinct recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.GroupingRecipeCreator(_name_ , _project_)
    

Create a Group recipe.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

with_group_key(_group_key_)
    

Set a column as the first grouping key.

Only a single grouping key may be set at recipe creation time. To add more grouping keys, get the recipe settings and use `GroupingRecipeSettings.add_grouping_key()`. To have no grouping keys at all, get the recipe settings and use `GroupingRecipeSettings.clear_grouping_keys()`.

Parameters:
    

**group_key** (_string_) – name of a column in the input dataset

Returns:
    

self

Return type:
    

`GroupingRecipeCreator`

_class _dataikuapi.dss.recipe.PivotRecipeCreator(_name_ , _project_)
    

Create a Pivot recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.SortRecipeCreator(_name_ , _project_)
    

Create a Sort recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.TopNRecipeCreator(_name_ , _project_)
    

Create a TopN recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.WindowRecipeCreator(_name_ , _project_)
    

Create a Window recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.JoinRecipeCreator(_name_ , _project_)
    

Create a Join recipe.

The recipe is created with default joins guessed by matching column names in the inputs.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.FuzzyJoinRecipeCreator(_name_ , _project_)
    

Create a FuzzyJoin recipe

The recipe is created with default joins guessed by matching column names in the inputs.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.GeoJoinRecipeCreator(_name_ , _project_)
    

Create a GeoJoin recipe

The recipe is created with default joins guessed by matching column names in the inputs.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.SplitRecipeCreator(_name_ , _project_)
    

Create a Split recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.StackRecipeCreator(_name_ , _project_)
    

Create a Stack recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.DownloadRecipeCreator(_name_ , _project_)
    

Create a Download recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

_class _dataikuapi.dss.recipe.PredictionScoringRecipeCreator(_name_ , _project_)
    

Create a new Prediction scoring recipe.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

Usage example:
    
    
    # Create a new prediction scoring recipe outputing to a new dataset
    
    project = client.get_project("MYPROJECT")
    builder = project.new_recipe("prediction_scoring", "my_scoring_recipe")
    builder.with_input_model("saved_model_id")
    builder.with_input("dataset_to_score")
    builder.with_new_output("my_output_dataset", "myconnection")
    
    # Or for a filesystem output connection
    # builder.with_new_output("my_output_dataset, "filesystem_managed", format="CSV_EXCEL_GZIP")
    
    new_recipe = builder.build()
    

with_input_model(_model_id_)
    

Set the input model.

Parameters:
    

**model_id** (_string_) – identifier of a saved model

_class _dataikuapi.dss.recipe.ClusteringScoringRecipeCreator(_name_ , _project_)
    

Create a new Clustering scoring recipe,.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

Usage example:
    
    
    # Create a new prediction scoring recipe outputing to a new dataset
    
    project = client.get_project("MYPROJECT")
    builder = project.new_recipe("clustering_scoring", "my_scoring_recipe")
    builder.with_input_model("saved_model_id")
    builder.with_input("dataset_to_score")
    builder.with_new_output("my_output_dataset", "myconnection")
    
    # Or for a filesystem output connection
    # builder.with_new_output("my_output_dataset, "filesystem_managed", format="CSV_EXCEL_GZIP")
    
    new_recipe = builder.build()
    

with_input_model(_model_id_)
    

Set the input model.

Parameters:
    

**model_id** (_string_) – identifier of a saved model

_class _dataikuapi.dss.recipe.EvaluationRecipeCreator(_name_ , _project_)
    

Create a new Evaluate recipe.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

Usage example:
    
    
    # Create a new evaluation recipe outputing to a new dataset, to a metrics dataset and/or to a model evaluation store
    
    project = client.get_project("MYPROJECT")
    builder = project.new_recipe("evaluation")
    builder.with_input_model(saved_model_id)
    builder.with_input("dataset_to_evaluate")
    
    builder.with_output("output_scored")
    builder.with_output_metrics("output_metrics")
    builder.with_output_evaluation_store(evaluation_store_id)
    
    new_recipe = builder.build()
    
    # Access the settings
    
    er_settings = new_recipe.get_settings()
    payload = er_settings.obj_payload
    
    # Change the settings
    
    payload['dontComputePerformance'] = True
    payload['outputProbabilities'] = False
    payload['metrics'] = ["precision", "recall", "auc", "f1", "costMatrixGain"]
    
    # Manage evaluation labels
    
    payload['labels'] = [dict(key="label_1", value="value_1"), dict(key="label_2", value="value_2")]
    
    # Save the settings and run the recipe
    
    er_settings.save()
    
    new_recipe.run()
    

Outputs must exist. They can be created using the following:
    
    
    builder = project.new_managed_dataset("output_scored")
    builder.with_store_into(connection)
    dataset = builder.create()
    
    builder = project.new_managed_dataset("output_scored")
    builder.with_store_into(connection)
    dataset = builder.create()
    
    evaluation_store_id = project.create_model_evaluation_store("output_model_evaluation").mes_id
    

with_input_model(_model_id_)
    

Set the input model.

Parameters:
    

**model_id** (_string_) – identifier of a saved model

with_output(_output_id_)
    

Set the output dataset containing the scored input.

Parameters:
    

**output_id** (_string_) – name of the dataset, or identifier of the managed folder or identifier of the saved model

with_output_metrics(_name_)
    

Set the output dataset containing the metrics.

Parameters:
    

**name** (_string_) – name of an existing dataset

with_output_evaluation_store(_mes_id_)
    

Set the output model evaluation store.

Parameters:
    

**mes_id** (_string_) – identifier of a model evaluation store

_class _dataikuapi.dss.recipe.StandaloneEvaluationRecipeCreator(_name_ , _project_)
    

Create a new Standalone Evaluate recipe.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

Usage example:
    
    
    # Create a new standalone evaluation of a scored dataset
    
    project = client.get_project("MYPROJECT")
    builder = project.new_recipe("standalone_evaluation")
    builder.with_input("scored_dataset_to_evaluate")
    builder.with_output_evaluation_store(evaluation_store_id)
    
    # Add a reference dataset (optional) to compute data drift
    
    builder.with_reference_dataset("reference_dataset")
    
    # Finish creation of the recipe
    
    new_recipe = builder.create()
    
    # Modify the model parameters in the SER settings
    
    ser_settings = new_recipe.get_settings()
    payload = ser_settings.obj_payload
    
    payload['predictionType'] = "BINARY_CLASSIFICATION"
    payload['targetVariable'] = "Survived"
    payload['predictionVariable'] = "prediction"
    payload['isProbaAware'] = True
    payload['dontComputePerformance'] = False
    
    # For a classification model with probabilities, the 'probas' section can be filled with the mapping of the class and the probability column
    # e.g. for a binary classification model with 2 columns: proba_0 and proba_1
    
    class_0 = dict(key=0, value="proba_0")
    class_1 = dict(key=1, value="proba_1")
    payload['probas'] = [class_0, class_1]
    
    # Change the 'features' settings for this standalone evaluation
    # e.g. reject the features that you do not want to use in the evaluation
    
    feature_passengerid = dict(name="Passenger_Id", role="REJECT", type="TEXT")
    feature_ticket = dict(name="Ticket", role="REJECT", type="TEXT")
    feature_cabin = dict(name="Cabin", role="REJECT", type="TEXT")
    
    payload['features'] = [feature_passengerid, feature_ticket, feature_cabin]
    
    # To set the cost matrix properly, access the 'metricParams' section of the payload and set the cost matrix weights:
    
    payload['metricParams'] = dict(costMatrixWeights=dict(tpGain=0.4, fpGain=-1.0, tnGain=0.2, fnGain=-0.5))
    
    # Save the recipe and run the recipe
    # Note that with this method, all the settings that were not explicitly set are instead set to their default value.
    
    ser_settings.save()
    
    new_recipe.run()
    

Output model evaluation store must exist. It can be created using the following:
    
    
    evaluation_store_id = project.create_model_evaluation_store("output_model_evaluation").mes_id
    

with_output_evaluation_store(_mes_id_)
    

Set the output model evaluation store.

Parameters:
    

**mes_id** (_string_) – identifier of a model evaluation store

with_reference_dataset(_dataset_name_)
    

Set the dataset to use as a reference in data drift computation.

Parameters:
    

**dataset_name** (_string_) – name of a dataset

_class _dataikuapi.dss.recipe.LLMEvaluationRecipeCreator(_name_ , _project_)
    

Create a new LLM Evaluate recipe.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

Usage example:
    
    
    # Create a new evaluation recipe outputing to a new dataset, to a metrics dataset and/or to an LLM evaluation store
    
    project = client.get_project("MYPROJECT")
    builder = project.new_recipe("nlp_llm_evaluation", "myrecipe")
    builder.with_input("dataset_to_evaluate")
    
    builder.with_output("output_scored")
    builder.with_output_metrics("output_metrics")
    builder.with_output_evaluation_store(<llm_evaluation_store_id>)
    
    new_recipe = builder.build()
    
    # Access the settings
    
    recipe_settings = new_recipe.get_settings()
    payload = recipe_settings.obj_payload
    
    # Change the settings
    
    payload["taskType"] = "QUESTION_ANSWERING"
    payload["inputColumnName"] = "question"
    payload["outputColumnName"] = "answer"
    payload["groundTruthColumnName"] = "ground_truth"
    payload["contextColumnName"] = "context"
    
    payload["completionLLMId"] = <your_llm_id>
    payload["embeddingLLMId"] = <your_llm_id>
    
    recipe_settings.get_recipe_params()["envSelection"] = {
        "envMode": "EXPLICIT_ENV",
        "envName": <code_env_name>,
    }
    
    payload["metrics"] = ["answerRelevancy", "faithfulness"]
    
    
    # Manage evaluation labels
    
    payload["labels"] = [dict(key="label_1", value="value_1"), dict(key="label_2", value="value_2")]
    
    # Save the settings, update the schema and run the recipe
    
    recipe_settings.save()
    new_recipe.compute_schema_updates().apply()
    
    new_recipe.run()
    

Outputs must exist. They can be created using the following:
    
    
    builder = project.new_managed_dataset("output")
    builder.with_store_into(connection)
    dataset = builder.create()
    
    builder = project.new_managed_dataset("metrics")
    builder.with_store_into(connection)
    dataset = builder.create()
    
    llm_evaluation_store_id = project.create_evaluation_store(<llm_evaluation_store_name>, "LLM").id
    

with_output(_output_id_ , _append =False_, _role ='main'_)
    

Set the output dataset containing the evaluation dataset scored row by row

Parameters:
    

  * **output_id** (_string_) – name of an existing dataset

  * **append** (_boolean_) – whether the recipe should append or overwrite the output when running. Defaults to False.




with_output_metrics(_metrics_dataset_name_ , _append =True_)
    

Set the output dataset containing the metrics

Parameters:
    

  * **metrics_dataset_name** (_string_) – name of an existing dataset

  * **append** (_boolean_) – whether the recipe should append or overwrite the output when running. Defaults to True.




with_output_evaluation_store(_evaluation_store_id_)
    

Set the output evaluation store

Parameters:
    

**evaluation_store_id** (_string_) – identifier of an LLM evaluation store

_class _dataikuapi.dss.recipe.AgentEvaluationRecipeCreator(_name_ , _project_)
    

Create a new Agent Evaluation recipe.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

Usage example:
    
    
    # Create a new agent evaluation recipe outputing to a new dataset, to a metrics dataset and/or to an agent evaluation store
    
    project = client.get_project(<project_key>)
    builder = (
        project.new_recipe("nlp_agent_evaluation", <recipe_name>)
        .with_input(<input_dataset_name>)
        .with_output(<output_dataset_name>)
        .with_output_metrics(<metrics_dataset_name>)
        .with_output_evaluation_store(<agent_evaluation_store_id>)
    )
    new_recipe = builder.create()
    
    # Access the settings
    
    recipe_settings = new_recipe.get_settings()
    payload = recipe_settings.obj_payload
    
    # Change the settings
    
    payload["inputFormat"] = "PROMPT_RECIPE"
    payload["groundTruthColumnName"] = <ground_truth_column_name>
    payload["referenceToolCallsColumnName"] = <reference_tool_calls_column_name>
    
    payload["completionLLMId"] = <your_llm_id>
    payload["embeddingLLMId"] = <your_llm_id>
    
    recipe_settings.get_recipe_params()["envSelection"] = {
        "envMode": "EXPLICIT_ENV",
        "envName": <code_env_name>,
    }
    
    payload["metrics"] = ["toolCallExactMatch", "toolCallPartialMatch", "toolCallPrecisionRecallF1", "agentGoalAccuracyWithoutReference"]
    
    # Manage evaluation labels
    
    payload["labels"] = [dict(key="label_1", value="value_1"), dict(key="label_2", value="value_2")]
    
    # Save the settings, update the schema and run the recipe
    
    recipe_settings.save()
    new_recipe.compute_schema_updates().apply()
    
    new_recipe.run()
    

Outputs must exist. They can be created using the following:
    
    
    builder = project.new_managed_dataset(<output_dataset_name>)
    builder.with_store_into(<connection_name>)
    dataset = builder.create()
    
    builder = project.new_managed_dataset(<metrics_dataset_name>)
    builder.with_store_into(<connection_name>)
    dataset = builder.create()
    
    agent_evaluation_store_id = project.create_evaluation_store(<agent_evaluation_store_name>, "AGENT").id
    

with_output(_output_id_ , _append =False_, _role ='main'_)
    

Set the output dataset containing the evaluation dataset scored row by row

Parameters:
    

  * **output_id** (_string_) – name of an existing dataset

  * **append** (_boolean_) – whether the recipe should append or overwrite the output when running. Defaults to False.




with_output_metrics(_metrics_dataset_name_ , _append =True_)
    

Set the output dataset containing the metrics

Parameters:
    

  * **metrics_dataset_name** (_string_) – name of an existing dataset

  * **append** (_boolean_) – whether the recipe should append or overwrite the output when running. Defaults to True.




with_output_evaluation_store(_evaluation_store_id_)
    

Set the output evaluation store

Parameters:
    

**evaluation_store_id** (_string_) – identifier of an agent evaluation store

_class _dataikuapi.dss.recipe.ContinuousSyncRecipeCreator(_name_ , _project_)
    

Create a continuous Sync recipe

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe") instead.

## Utilities

_class _dataikuapi.dss.utils.DSSComputedColumn
    

_static _formula(_name_ , _formula_ , _type ='double'_)
    

Create a computed column with a formula.

Parameters:
    

  * **name** (_string_) – a name for the computed column

  * **formula** (_string_) – formula to compute values, using the [GREL language](<https://doc.dataiku.com/dss/latest/formula/index.html>)

  * **type** (_string_) – name of a DSS type for the values of the column



Returns:
    

a computed column as a dict

Return type:
    

dict

_class _dataikuapi.dss.utils.DSSFilter
    

Helper class to build filter objects for use in visual recipes.

_static _of_single_condition(_column_ , _operator_ , _string =None_, _num =None_, _date =None_, _time =None_, _date2 =None_, _time2 =None_, _unit =None_)
    

Create a simple filter on a column.

Which of the ‘string’, ‘num’, ‘date’, ‘time’, ‘date2’ and ‘time2’ parameter holds the literal to filter against depends on the filter operator.

Parameters:
    

  * **column** (_string_) – name of a column to filter (left operand)

  * **operator** (_string_) – type of filter applied to the column, one of the values in the `DSSFilterOperator` enum

  * **string** (_string_) – string literal for the right operand

  * **num** (_string_) – numeric literal for the right operand

  * **date** (_string_) – date part literal for the right operand

  * **time** (_string_) – time part literal for the right operand

  * **date2** (_string_) – date part literal for the right operand of BETWEEN_DATE

  * **time2** (_string_) – time part literal for the right operand of BETWEEN_DATE

  * **unit** (_string_) – date/time rounding for date operations. Possible values are YEAR, MONTH, WEEK, DAY, HOUR, MINUTE, SECOND




_static _of_and_conditions(_conditions_)
    

Create a filter as an intersection of conditions.

The resulting filter keeps rows that match all the conditions in the list. Conditions are for example the output of `condition()`.

Parameters:
    

**conditions** (_list_) – a list of conditions

Returns:
    

a filter, as a dict

Return type:
    

dict

_static _of_or_conditions(_conditions_)
    

Create a filter as an union of conditions.

The resulting filter keeps rows that match any of the conditions in the list. Conditions are for example the output of `condition()`.

Parameters:
    

**conditions** (_list_) – a list of conditions

Returns:
    

a filter, as a dict

Return type:
    

dict

_static _of_formula(_formula_)
    

Create a filter that applies a GREL formula.

The resulting filter evaluates the formula and keeps rows for which the formula returns a True value.

Parameters:
    

**formula** (_string_) – a [GREL formula](<https://doc.dataiku.com/dss/latest/formula/index.html>)

Returns:
    

a filter, as a dict

Return type:
    

dict

_static _of_sql_expression(_sql_expression_)
    

Create a filter that applies a SQL expression.

The resulting filter evaluates the sql expression and keeps rows for which the sql expression returns a True value.

Parameters:
    

**sql_expression** (_string_) – a SQL expression

Returns:
    

a filter, as a dict

Return type:
    

dict

_static _from_simple_filter(_simple_filter_)
    

Create a filter from a [`DSSSimpleFilter`](<utils.html#dataikuapi.dss.utils.DSSSimpleFilter> "dataikuapi.dss.utils.DSSSimpleFilter") object.

Parameters:
    

**simple_filter** ([_DSSSimpleFilter_](<utils.html#dataikuapi.dss.utils.DSSSimpleFilter> "dataikuapi.dss.utils.DSSSimpleFilter")) – a simple filter object

Returns:
    

a filter, as a dict

Return type:
    

dict

_static _condition(_column_ , _operator_ , _string =None_, _num =None_, _date =None_, _time =None_, _date2 =None_, _time2 =None_, _unit =None_)
    

Create a condition on a column for a filter.

Which of the ‘string’, ‘num’, ‘date’, ‘time’, ‘date2’ and ‘time2’ parameter holds the literal to filter against depends on the filter operator.

Parameters:
    

  * **column** (_string_) – name of a column to filter (left operand)

  * **operator** (_string_) – type of filter applied to the column, one of the values in the `DSSFilterOperator` enum

  * **string** (_string_) – string literal for the right operand

  * **num** (_string_) – numeric literal for the right operand

  * **date** (_string_) – date part literal for the right operand

  * **time** (_string_) – time part literal for the right operand

  * **date2** (_string_) – date part literal for the right operand of BETWEEN_DATE

  * **time2** (_string_) – time part literal for the right operand of BETWEEN_DATE

  * **unit** (_string_) – date/time rounding for date operations. Possible values are YEAR, MONTH, WEEK, DAY, HOUR, MINUTE, SECOND




_class _dataikuapi.dss.utils.DSSFilterOperator(_value_)
    

An enumeration.

EMPTY_ARRAY _ = 'empty array'_
    

Test if an array is empty.

NOT_EMPTY_ARRAY _ = 'not empty array'_
    

Test if an array is not empty.

CONTAINS_ARRAY _ = 'array contains'_
    

Test if an array contains a value.

NOT_EMPTY _ = 'not empty'_
    

Test if a value is not empty and not null.

EMPTY _ = 'is empty'_
    

Test if a value is empty or null.

NOT_EMPTY_STRING _ = 'not empty string'_
    

Test if a string is not empty.

EMPTY_STRING _ = 'empty string'_
    

Test if a string is empty.

IS_TRUE _ = 'true'_
    

Test if a boolean is true.

IS_FALSE _ = 'false'_
    

Test if a boolean is false.

EQUALS_STRING _ = '== [string]'_
    

Test if a string is equal to a given value.

EQUALS_CASE_INSENSITIVE_STRING _ = '== [string]i'_
    

Test if a string is equal to a given value, ignoring case.

NOT_EQUALS_STRING _ = '!= [string]'_
    

Test if a string is not equal to a given value.

SAME _ = '== [NaNcolumn]'_
    

Test if two columns have the same value when formatted to string.

DIFFERENT _ = '!= [NaNcolumn]'_
    

Test if two columns have different values when formatted to string.

EQUALS_NUMBER _ = '== [number]'_
    

Test if a number is equal to a given value.

NOT_EQUALS_NUMBER _ = '!= [number]'_
    

Test if a number is not equal to a given value.

GREATER_NUMBER _ = '> [number]'_
    

Test if a number is greater than a given value.

LESS_NUMBER _ = '< [number]'_
    

Test if a number is less than a given value.

GREATER_OR_EQUAL_NUMBER _ = '>= [number]'_
    

Test if a number is greater or equal to a given value.

LESS_OR_EQUAL_NUMBER _ = '<= [number]'_
    

Test if a number is less or equal to a given value.

EQUALS_DATE _ = '== [date]'_
    

Test if a date/time is equal to a given date/time (rounded).

GREATER_DATE _ = '> [date]'_
    

Test if a date/time is greater than a given date/time.

GREATER_OR_EQUAL_DATE _ = '>= [date]'_
    

Test if a date/time is greater or equal than a given date/time.

LESS_DATE _ = '< [date]'_
    

Test if a date/time is less than a given date/time.

LESS_OR_EQUAL_DATE _ = '<= [date]'_
    

Test if a date/time is less or equal than a given date/time.

BETWEEN_DATE _ = '>< [date]'_
    

Test if a date/time is between two given date/times.

EQUALS_COL _ = '== [column]'_
    

Test if two columns have the same (typed) value.

NOT_EQUALS_COL _ = '!= [column]'_
    

Test if two columns have different (typed) values.

GREATER_COL _ = '> [column]'_
    

Test if one column is greater than another.

LESS_COL _ = '< [column]'_
    

Test if one column is less than another.

GREATER_OR_EQUAL_COL _ = '>= [column]'_
    

Test if one column is greater or equal than another.

LESS_OR_EQUAL_COL _ = '<= [column]'_
    

Test if one column is less or equal than another.

CONTAINS_STRING _ = 'contains'_
    

Test if a column contains a given string.

REGEX _ = 'regex'_
    

Test if a column matches a regular expression.

IN_ANY_OF_STRING _ = 'in [string]'_
    

Test if a string is in list of values.

IN_NONE_OF_STRING _ = 'not in [string]'_
    

Test if a string is not in list of values.

IN_ANY_OF_NUMBER _ = 'in [number]'_
    

Test if a number is in list of values.

IN_NONE_OF_NUMBER _ = 'not in [number]'_
    

Test if a number is not in list of values.

---

## [api-reference/python/scenarios-inside]

# Scenarios (in a scenario)

This is the documentation of the API for use _within_ scenarios.

Warning

This API can only be used within a scenario in order to run steps and report on progress of the current scenario.

If you want to control scenarios, please see [Scenarios](<scenarios.html>)

For usage information and examples, see [Scenarios (in a scenario)](<../../concepts-and-examples/scenarios-inside.html>)

_class _dataiku.scenario.Scenario
    

Handle to the current (running) scenario.

add_report_item(_object_ref_ , _partition_ , _report_item_)
    

When used in the code of a custom step, adds a report item to the current step run

get_message_sender(_channel_id_ , _type =None_)
    

Gets a sender for reporting messages, using one of DSS’s Messaging channels

get_build_state()
    

Gets a handle to query previous builds

get_trigger_type()
    

Returns the type of the trigger that launched this scenario run

get_trigger_name()
    

Returns the name (if defined) of the trigger that launched this scenario run

get_trigger_params()
    

Returns a dictionary of the params set by the trigger that launched this scenario run

set_scenario_variables(_** kwargs_)
    

Define additional variables in this scenario run

get_previous_steps_outputs()
    

Returns the results of the steps previously executed in this scenario run. For example, if a SQL step ran before in the scenario, and its name is ‘the_sql’, then the list returned by this function will be like:
    
    
    [
        ...
        {
            'stepName': 'the_sql',
            'result': {
                'success': True,
                'hasResultset': True,
                'columns': [ {'type': 'int8', 'name': 'a'}, {'type': 'varchar', 'name': 'b'} ],
                'totalRows': 2,
                'rows': [
                            ['1000', 'min'],
                            ['2500', 'max']
                        ],
                'log': '',
                'endedOn': 0,
                'totalRowsClipped': False
            }
        },
        ...
    ]
    

Important note: the exact structure of each type of step run output is not precisely defined, and may vary from a DSS release to another

get_all_variables()
    

Returns a dictionary of all variables (including the scenario-specific values)

run_step(_step_ , _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Run a step in this scenario.

Parameters:
    

  * **step** (_BuildFlowItemsStepDefHelper_) – Must be a step definition returned by `dataiku.scenario.BuildFlowItemsStepDefHelper.get_step()`. (See code sample below)

  * **asynchronous** (_bool_) – If True, the function launches a step run and returns immediately a `dataiku.scenario.step.StepHandle` object, on which the user will need to call `dataiku.scenario.step.StepHandle.is_done()` or `dataiku.scenario.step.StepHandle.wait_for_completion()`. Otherwise the function waits until the step has finished running and returns the result of the step.

  * **fail_fatal** (_bool_) – If True, returns an Exception if the step fails.




Code sample:
    
    
    # Code sample to build several datasets in a scenario step
    from dataiku.scenario import Scenario
    from dataiku.scenario import BuildFlowItemsStepDefHelper
    
    # The Scenario object is the main handle from which you initiate steps
    scenario = Scenario()
    
    # Create a 'Build Flow Items' step.
    step = BuildFlowItemsStepDefHelper("build_datasets_step")
    
    # Add each dataset / folder / model to build
    step.add_dataset("dataset_name_1", "project_key")
    step.add_dataset("dataset_name_2", "project_key")
    step.add_dataset("dataset_name_3", "project_key")
    
    # Run the scenario step. The dependencies engine will parallelize what can be parallelized.
    scenario.run_step(step.get_step())
    

new_build_flowitems_step(_step_name =None_, _build_mode ='RECURSIVE_BUILD'_)
    

Creates and returns a helper to prepare a multi-item “build” step.

Returns:
    

a `BuildFlowItemsStepDefHelper` object

build_dataset(_dataset_name_ , _project_key =None_, _build_mode ='RECURSIVE_BUILD'_, _partitions =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Executes the build of a dataset

Parameters:
    

  * **dataset_name** – name of the dataset to build

  * **project_key** – optional, project key of the project in which the dataset is built

  * **build_mode** – one of “RECURSIVE_BUILD” (default), “NON_RECURSIVE_FORCED_BUILD”, “RECURSIVE_FORCED_BUILD”, “RECURSIVE_MISSING_ONLY_BUILD”

  * **partitions** – can be given as a partitions spec, variables expansion is supported




build_folder(_folder_id_ , _project_key =None_, _build_mode ='RECURSIVE_BUILD'_, _partitions =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Executes the build of a folder

Parameters:
    

  * **folder_id** – the identifier of the folder (!= its name)

  * **partitions** – Can be given as a partitions spec. Variables expansion is supported




train_model(_model_id_ , _project_key =None_, _build_mode ='RECURSIVE_BUILD'_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Executes the train of a saved model

Parameters:
    

**model_id** – the identifier of the model (!= its name)

build_evaluation_store(_evaluation_store_id_ , _project_key =None_, _build_mode ='RECURSIVE_BUILD'_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_)
    

Executes the build of a model evaluation store, to produce a model evalution

Parameters:
    

**evaluation_store_id** – the identifier of the model evaluation store (!= its name)

invalidate_dataset_cache(_dataset_name_ , _project_key =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Invalidate the caches of a dataset

clear_dataset(_dataset_name_ , _project_key =None_, _partitions =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Executes a ‘clear’ operation on a dataset

Parameters:
    

**partitions** – Can be given as a partitions spec. Variables expansion is supported

clear_folder(_folder_id_ , _project_key =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Executes a ‘clear’ operation on a managed folder

run_dataset_checks(_dataset_name_ , _project_key =None_, _partitions =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Runs the checks defined on a dataset

Parameters:
    

**partitions** – Can be given as a partitions spec. Variables expansion is supported

compute_dataset_metrics(_dataset_name_ , _project_key =None_, _partitions =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Computes the metrics defined on a dataset

Parameters:
    

**partitions** – Can be given as a partitions spec. Variables expansion is supported

synchronize_hive_metastore(_dataset_name_ , _project_key =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Synchronizes the Hive metastore from the dataset definition for a single dataset (all partitions).

update_from_hive_metastore(_dataset_name_ , _project_key =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Update a single dataset definition (all partitions) from its table in the Hive metastore .

execute_sql(_connection_ , _sql_ , _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Executes a sql query

Parameters:
    

  * **connection** – name of the DSS connection to run the query one

  * **sql** – the query to run




set_project_variables(_project_key =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Sets variables on the project. The variables are passed as named parameters to this function. For example:

s.set_project_variables(‘PROJ’, var1=’value1’, var2=True)

will add 2 variables var1 and var2 in the project’s variables, with values ‘value1’ and True respectively

set_global_variables(_step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Sets variables on the DSS instance. The variables are passed as named parameters to this function. For example:

s.set_global_variables(var1=’value1’, var2=True)

will add 2 variables var1 and var2 in the instance’s variables, with values ‘value1’ and True respectively

run_global_variables_update(_update_code =None_, _step_name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Run the code for updating the DSS instance’s variable defined in the global settings.

Parameters:
    

**update_code** – custom code to run instead of the one defined in the global settings

run_scenario(_scenario_id_ , _project_key =None_, _name =None_, _asynchronous =False_, _fail_fatal =True_, _** kwargs_)
    

Runs a scenario

Parameters:
    

  * **scenario_id** – identifier of the scenario (can be different from its name)

  * **project_key** – optional project key of the project where the scenario is defined (defaults to current project)

  * **name** – optional name of the step

  * **asynchronous** (_bool_) – If True, waits for result, else immediately returns a future. See `dataiku.scenario.run_step()` for details.

  * **fail_fatal** (_bool_) – If True, returns an Exception if the step fails.. See `dataiku.scenario.run_step()` for details.




Code sample:
    
    
    # Code sample to run another scenario asynchronously without failing
    from dataiku.scenario import Scenario
    
    result = scenario.run_scenario("ANOTHER_SCENARIO", asynchronous=False, fail_fatal=False)
    print(result.get_outcome())
    

create_jupyter_export(_notebook_id_ , _execute_notebook =False_, _name =None_, _asynchronous =False_, _** kwargs_)
    

Create a new export from a jupyter notebook

Parameters:
    

  * **notebook_id** – identifier of the notebook

  * **execute_notebook** – should the notebook be executed prior to the export




package_api_service(_service_id_ , _package_id_ , _transmogrify =False_, _name =None_, _asynchronous =False_, _** kwargs_)
    

Make a package for an API service.

Parameters:
    

  * **service_id** – identifier of the API service

  * **package_id** – identifier for the created package

  * **transmogrify** – if True, make the package_id unique by appending a number (if not unique already)




_class _dataiku.scenario.BuildFlowItemsStepDefHelper(_scenario_ , _step_name =None_, _build_mode ='RECURSIVE_BUILD'_)
    

Helper to build the definition of a ‘Build Flow Items’ step. Multiple items can be added

add_dataset(_dataset_name_ , _project_key =None_, _partitions =None_)
    

Add a dataset to build

Parameters:
    

  * **dataset_name** – name of the dataset

  * **partitions** – partition spec




add_folder(_folder_id_ , _project_key =None_, _partitions =None_)
    

Add a folder to build

Parameters:
    

**folder_id** – identifier of a folder (!= its name)

add_model(_model_id_ , _project_key =None_)
    

Add a saved model to build

Parameters:
    

**model_id** – identifier of a saved model (!= its name)

add_evaluation_store(_evaluation_store_id_ , _project_key =None_)
    

Add a model evaluation store to build

Parameters:
    

**evaluation_store_id** – identifier of a model evaluation store (!= its name)

get_step()
    

Get the step definition

---

## [api-reference/python/scenarios]

# Scenarios

For usage information and examples, see [Scenarios](<../../concepts-and-examples/scenarios.html>)

_class _dataikuapi.dss.scenario.DSSScenario(_client_ , _project_key_ , _id_)
    

A handle to interact with a scenario on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.get_scenario()`](<projects.html#dataikuapi.dss.project.DSSProject.get_scenario> "dataikuapi.dss.project.DSSProject.get_scenario")

abort()
    

Abort the scenario.

This method does nothing if the scenario is not currently running.

run_and_wait(_params =None_, _no_fail =False_)
    

Request a run of the scenario and wait the end of the run to complete.

The method requests a new run, which will start after a few seconds.

Parameters:
    

  * **params** (_dict_) – additional parameters that will be passed to the scenario through trigger params (defaults to {})

  * **no_fail** (_boolean_) – if False, raises if the run doesn’t end with a SUCCESS outcome



Returns:
    

a handle on the run

Return type:
    

`DSSScenarioRun`

run(_params =None_)
    

Request a run of the scenario.

The method requests a new run, which will start after a few seconds.

Note

This method returns a trigger fire, NOT a Scenario run object. The trigger fire may ultimately result in a run or not.

Usage example:
    
    
    scenario = project.get_scenario("myscenario")
    trigger_fire = scenario.run()
    
    # When you call `run` a scenario, the scenario is not immediately
    # started. Instead a "manual trigger" fires.
    #
    # This trigger fire can be cancelled if the scenario was already running,
    # or if another trigger fires. Thus, the scenario run is not available
    # immediately, and we must "wait" for it
    scenario_run = trigger_fire.wait_for_scenario_run()
    
    # Now the scenario is running. We can wait for it synchronously with
    # scenario_run.wait_for_completion(), but if we want to do other stuff
    # at the same time, we can use refresh
    while True:
        scenario_run.refresh()
        if scenario_run.running:
            print("Scenario is still running ...")
        else:
            print("Scenario is not running anymore")
            break
    
        time.sleep(5)
    

Params dict params:
    

additional parameters that will be passed to the scenario through trigger params (defaults to {})

Returns:
    

a request for a run, as a trigger fire object

Return type:
    

`DSSTriggerFire`

get_last_runs(_limit =10_, _only_finished_runs =False_)
    

Get the list of the last runs of the scenario.

Parameters:
    

  * **limit** (_int_) – maximum number of last runs to retrieve

  * **only_finished_runs** (_boolean_) – if True, currently running runs are not returned.



Returns:
    

a list of `DSSScenarioRun`

Return type:
    

list

get_runs_by_date(_from_date_ , _to_date =datetime.datetime(2026, 4, 24, 8, 10, 27, 861402)_)
    

Get the list of the runs of the scenario in a given date range.

Parameters:
    

  * **from_date** (_datetime_) – start of the date range to retrieve runs for, inclusive

  * **to_date** (_datetime_) – end of the date range to retrieve runs for, exclusive



Returns:
    

a list of `DSSScenarioRun`

Return type:
    

list

get_last_finished_run()
    

Get the last run that completed.

The run may be successful or failed, or even aborted.

Return type:
    

`DSSScenarioRun`

get_last_successful_run()
    

Get the last run that completed successfully.

Return type:
    

`DSSScenarioRun`

get_current_run()
    

Get the current run of the scenario.

If the scenario is not running at the moment, returns None.

Return type:
    

`DSSScenarioRun`

get_run(_run_id_)
    

Get a handle to a run of the scenario.

Parameters:
    

**run_id** (_string_) – identifier of the run.

Return type:
    

`DSSScenarioRun`

get_status()
    

Get the status of this scenario.

Return type:
    

`DSSScenarioStatus`

get_settings()
    

Get the settings of this scenario.

Returns:
    

a `StepBasedScenarioSettings` for step-based scenarios, or a `PythonScriptBasedScenarioSettings` for scenarios defined by a python script.

Return type:
    

`DSSScenarioSettings`

get_average_duration(_limit =3_)
    

Get the average duration of the last runs of this scenario.

The duration is computed on successful runs only, that is, on runs that ended with SUCCESS or WARNING satus.

If there are not enough runs to perform the average, returns None

Parameters:
    

**limit** (_int_) – number of last runs to average on

Returns:
    

the average duration of the last runs, in seconds

Return type:
    

float

delete()
    

Delete this scenario.

get_object_discussions()
    

Get a handle to manage discussions on the scenario.

Returns:
    

the handle to manage discussions

Return type:
    

[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")

get_trigger_fire(_trigger_id_ , _trigger_run_id_)
    

Get a trigger fire object.

Caution

Advanced usages only (see `run()`)

Parameters:
    

  * **trigger_id** (_string_) – identifier of the trigger, in the scenario’s settings

  * **trigger_run_id** (_string_) – identifier of the run of the trigger



Return type:
    

`DSSTriggerFire`

get_definition(_with_status =True_)
    

Get the definition of the scenario.

Attention

Deprecated, use `get_settings()` and `get_status()`

Parameters:
    

**with_status** (_bool_) – if True, get only the run status of the scenario. If False, get the raw definition of the scenario.

Returns:
    

if **with_status** is False, the scenario’s definition as returned by `DSSScenarioSettings.get_raw()`. If **with_status** is True, a summary of the scenario as returned by `DSSScenarioStatus.get_raw()`

Return type:
    

dict

set_definition(_definition_ , _with_status =True_)
    

Update the definition of this scenario.

Attention

Deprecated, use `get_settings()` and `DSSScenarioSettings.save()`

Parameters:
    

  * **definition** (_dict_) – a scenario definition obtained by calling `get_definition()`, then modified

  * **with_status** (_bool_) – should be the same as the value passed to `get_definition()`. If True, the only fields that can be modified are active, checklists, description, shortDesc and tags




get_payload(_extension ='py'_)
    

Get the payload of the scenario.

Attention

Deprecated, use `get_settings()` and `get_status()`

Parameters:
    

**extension** (_string_) – the type of script. Default is ‘py’ for python

set_payload(_script_ , _extension ='py'_)
    

Update the payload of this scenario.

Attention

Deprecated, use `get_settings()` and `DSSScenarioSettings.save()`

Parameters:
    

  * **script** (_string_) – the new value of the script

  * **extension** (_string_) – the type of script. Default is ‘py’ for python




_class _dataikuapi.dss.scenario.DSSScenarioStatus(_scenario_ , _data_)
    

Status of a scenario.

Important

Do not instantiate directly, use `DSSScenario.get_status()`

get_raw()
    

Get the raw status data.

Returns:
    

the status, as a dict. Notable fields are:

  * **active** : whether the scenario runs its automatic triggers

  * **running** : whether the scenario is currently running

  * **start** : if the scenario is running, the timestamp of the beginning of the run




Return type:
    

dict

_property _running
    

Whether the scenario is currently running

Return type:
    

boolean

_property _next_run
    

Time at which the scenario is expected to run next.

This expected time is computed based on the only triggers for which forecasts are possible, that is, the active time-based triggers. May be None if there is no such trigger.

This is an approximate indication as scenario run may be delayed, especially in the case of multiple triggers or high load.

Return type:
    

`datetime.datetime`

_class _dataikuapi.dss.scenario.DSSScenarioSettings(_client_ , _scenario_ , _data_)
    

Settings of a scenario.

Important

Do not instantiate directly, use `DSSScenario.get_settings()`

get_raw()
    

Get the raw definition of the scenario.

This method returns a reference to the settings, not a copy. Modifying the settings then calling `save()` saves the changes made.

Returns:
    

the scenario, as a dict. The type-specific parameters of the scenario are in a **params** sub-dict. For step-based scenarios, the **params** will contain the definitions of the steps as a **steps** list of dict.

Return type:
    

dict

_property _active
    

Whether this scenario is currently active, i.e. its auto-triggers are executing.

Return type:
    

boolean

_property _run_as
    

Get the login of the user the scenario runs as.

None means that the scenario runs as the last user who modified the scenario. Only administrators may set a non-None value.

Return type:
    

string

_property _effective_run_as
    

Get the effective ‘run as’ of the scenario.

If the value returned by `run_as()` is not None, then that value. Otherwise, this will be the login of the last user who modified the scenario.

Note

If this method returns None, it means that it was not possible to identify who this scenario should run as. This scenario is probably not currently functioning.

Return type:
    

string

_property _raw_triggers
    

Get the list of automatic triggers.

This method returns a reference to the settings, not a copy. Modifying the settings then calling `save()` saves the changes made.

Returns:
    

list of the automatic triggers, each one a dict. An **active** boolean field indicates whether the trigger is running automatically.

Return type:
    

list[dict]

_property _raw_reporters
    

Get the list of reporters.

This method returns a reference to the settings, not a copy. Modifying the settings then calling `save()` saves the changes made.

Returns:
    

list of reporters on the scenario, each one a dict.

Return type:
    

list[dict]

add_periodic_trigger(_every_minutes =5_)
    

Add a trigger that runs the scenario every X minutes.

Parameters:
    

**every_minutes** (_int_) – interval between activations of the trigger, in minutes

add_hourly_trigger(_minute_of_hour =0_, _year =None_, _month =None_, _day =None_, _starting_hour =0_, _repeat_every =1_, _timezone ='SERVER'_)
    

Add a trigger that runs the scenario every X hours.

Parameters:
    

  * **repeat_every** (_int_) – interval between activations of the trigger, in hours

  * **minute_of_hour** (_int_) – minute in the hour when the trigger should run

  * **year** (_int_) – year part of the date/time before which the trigger won’t run

  * **month** (_int_) – month part of the date/time before which the trigger won’t run

  * **day** (_int_) – day part of the date/time before which the trigger won’t run

  * **starting_hour** (_int_) – hour part of the date/time before which the trigger won’t run

  * **timezone** (_string_) – timezone in which the start date/time is expressed. Can be a time zone name like “Europe/Paris” or “SERVER” for the time zone of the DSS server




add_daily_trigger(_hour =2_, _minute =0_, _days =None_, _year =None_, _month =None_, _day =None_, _repeat_every =1_, _timezone ='SERVER'_)
    

Add a trigger that runs the scenario every X days.

Parameters:
    

  * **repeat_every** (_int_) – interval between activations of the trigger, in days

  * **days** (_list_) – if None, the trigger runs every **repeat_every** other day. If set to a list of day names, the trigger runs every **repeat_every** other week, on the designated days. The day names are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday

  * **hour** (_int_) – hour in the day when the trigger should run

  * **minute** (_int_) – minute in the hour when the trigger should run

  * **year** (_int_) – year part of the date/time before which the trigger won’t run

  * **month** (_int_) – month part of the date/time before which the trigger won’t run

  * **day** (_int_) – day part of the date/time before which the trigger won’t run

  * **timezone** (_string_) – timezone in which the start date/time is expressed. Can be a time zone name like “Europe/Paris” or “SERVER” for the time zone of the DSS server




add_monthly_trigger(_day =1_, _hour =2_, _minute =0_, _year =None_, _month =None_, _run_on ='ON_THE_DAY'_, _repeat_every =1_, _timezone ='SERVER'_)
    

Add a trigger that runs the scenario every X months.

Parameters:
    

  * **repeat_every** (_int_) – interval between activations of the trigger, in months

  * **day** (_int_) – day in the day when the trigger should run, when **run_on** is ON_THE_DAY or None

  * **hour** (_int_) – hour in the day when the trigger should run, when **run_on** is ON_THE_DAY or None

  * **minute** (_int_) – minute in the hour when the trigger should run, when **run_on** is ON_THE_DAY or None

  * **minute_of_hour** (_int_) – position in the hour of the firing of the trigger

  * **year** (_int_) – year part of the date/time before which the trigger won’t run

  * **month** (_int_) – month part of the date/time before which the trigger won’t run

  * **timezone** (_string_) – timezone in which the start date/time is expressed. Can be a time zone name like “Europe/Paris” or “SERVER” for the time zone of the DSS server



Parma string run_on:
    

when in the month the trigger should run. Possible values are ON_THE_DAY, LAST_DAY_OF_THE_MONTH, FIRST_WEEK, SECOND_WEEK, THIRD_WEEK, FOURTH_WEEK, LAST_WEEK.

save()
    

Saves the settings to the scenario

_class _dataikuapi.dss.scenario.StepBasedScenarioSettings(_client_ , _scenario_ , _data_)
    

Settings of a step-based scenario.

Important

Do not instantiate directly, use `DSSScenario.get_settings()`.

_property _raw_steps
    

Returns raw definition of steps.

This method returns a reference to the settings, not a copy. Modifying the settings then calling `save()` saves the changes made.

Returns:
    

a list of scenario steps, each one a dict. Notable fields are:

  * **id** : identifier of the step (unique in the scenario)

  * **name** : label of the step

  * **type** : type of the step. There are many types, commonly used ones are build_flowitem, custom_python or exec_sql

  * **params** : type-specific parameters for the step, as a dict




Return type:
    

list[dict]

_class _dataikuapi.dss.scenario.PythonScriptBasedScenarioSettings(_client_ , _scenario_ , _data_ , _script_)
    

Settings of a scenario defined by a Python script.

Important

Do not instantiate directly, use `DSSScenario.get_settings()`.

_property _code
    

Get the Python script of the scenario

Return type:
    

string

save()
    

Saves the settings to the scenario.

_class _dataikuapi.dss.scenario.DSSScenarioRun(_client_ , _run_)
    

A handle containing basic info about a past run of a scenario.

Important

Do not instantiate directly, use `DSSScenario.get_run()`, `DSSScenario.get_current_run()` or `DSSScenario.get_last_runs()`

This handle can also be used to fetch additional information about the run.

_property _id
    

Get the identifier of this run.

Return type:
    

string

refresh()
    

Refresh the details of the run.

For ongoing scenario runs, this updates the set of outcomes of the steps and their results.

Note

This method performs another API call

wait_for_completion(_no_fail =False_)
    

Wait for the scenario run to complete.

If the scenario run is already finished, this method returns immediately.

Parameters:
    

**no_fail** (_boolean_) – if False, raises an exception if scenario fails

_property _running
    

Whether this scenario run is currently running.

Return type:
    

boolean

_property _outcome
    

The outcome of this scenario run, if available.

Returns:
    

one of SUCCESS, WARNING, FAILED, or ABORTED

Return type:
    

string

_property _trigger
    

Get the trigger that triggered this scenario run.

Returns:
    

the definition of a trigger, as in the `DSSScenarioSettings.raw_triggers()` list

Return type:
    

dict

get_info()
    

Get the raw information of the scenario run.

Returns:
    

the scenario run, as a dict. The identifier of the run is a **runId** field. If the scenario run is finished, the detailed outcome of the run is a **result** sub-dict, with notably an **outcome** field (SUCCESS, WARNING, FAILED, or ABORTED)

Return type:
    

dict

get_details()
    

Get the full details of the scenario run.

This includes notably the individual step runs inside the scenario run.

Note

This method performs another API call

Returns:
    

full details on a scenario run, as a dict with fields:

  * **scenarioRun** : the run definition and base status, as a dict (see `get_info()`)

  * **stepRuns** : details about each step that has executed so far, as a list of dicts (see `DSSScenarioRunDetails.steps()`)




Return type:
    

dict

get_start_time()
    

Get the start time of the scenario run.

Return type:
    

`datetime.datetime`

_property _start_time
    

Get the start time of the scenario run.

Return type:
    

`datetime.datetime`

get_end_time()
    

Get the end time of the scenario run, if it completed, else raises.

Return type:
    

`datetime.datetime`

_property _end_time
    

Get the end time of the scenario run, if it completed, else raises.

Return type:
    

`datetime.datetime`

get_duration()
    

Get the duration of this run (in fractional seconds).

If the run is still running, get the duration since it started.

Return type:
    

float

_property _duration
    

Get the duration of this run (in fractional seconds).

If the run is still running, get the duration since it started.

Return type:
    

float

get_report()
    

Download a report describing the outcome of a test scenario run, in JUnit XML format.

Returns:
    

the scenario run report, in JUnit XML format

Return type:
    

file-like

get_step_run_report(_step_id_)
    

Download a report describing the outcome of a test scenario step run, in JUnit XML format.

Parameters:
    

**step_id** (_string_) – identifier of the step

Returns:
    

the step run report, in JUnit XML format

Return type:
    

file-like

get_log(_step_id =None_)
    

Gets the logs of the scenario run. If a step_id is passed in the parameters the logs will be scoped to that step.

Parameters:
    

**step_id** (_string_) – (optional) the id of the step in the run whose log is requested (defaults to **None**)

Returns:
    

the scenario run logs

Return type:
    

string

_class _dataikuapi.dss.scenario.DSSScenarioRunDetails(_data_)
    

Details of a scenario run, notably the outcome of its steps.

Important

Do not instantiate directly, see `DSSScenarioRun.get_details()`

_property _steps
    

Get the list of runs of the steps.

Only completed or ongoing steps are included.

Note

When the instance of `DSSScenarioRunDetails` was obtained via `DSSScenarioRun.get_details()`, then the returned list is made of instances of `DSSStepRunDetails`.

Returns:
    

a list of step runs, each as a dict. The **runId** in the dict is the identifier of the step run, not of the overall scenario run. A **result** sub-dict contains the outcome of the step.

Return type:
    

list[dict]

_property _last_step
    

Get the last step run.

Returns:
    

a step run, as a dict. See `steps()`.

Return type:
    

dict

_property _first_error_details
    

Get the details of the first error if this run failed.

This will not always be able to find the error details (it returns None in that case)

Returns:
    

a serialized exception, as in `DSSStepRunDetails.first_error_details()`

Return type:
    

dict

_class _dataikuapi.dss.scenario.DSSStepRunDetails(_data_)
    

Details of a run of a step in a scenario run.

Important

Do not instantiate directly, see `DSSScenarioRunDetails.steps()` on an instance of `DSSScenarioRunDetails` obtained via `DSSScenarioRun.get_details()`

_property _outcome
    

Get the outcome of the step run/

Returns:
    

one of SUCCESS, WARNING, FAILED, or ABORTED

Return type:
    

string

_property _job_ids
    

Get the list of DSS job ids that were run as part of this step.

Returns:
    

a list of job ids, each one a string

Return type:
    

list[string]

_property _first_error_details
    

Try to get the details of the first error if this step failed. This will not always be able to find the error details (it returns None in that case)

Returns:
    

a serialized exception, as a with fields:

  * **clazz** : class name of the exception

  * **title** : short message of the exception

  * **message** : message of the exception

  * **stack** : stacktrace of the exception, as a single string

  * **code** : well-known error code, as listed in [the doc](<https://doc.dataiku.com/dss/latest/troubleshooting/errors/index.html>)

  * **fixability** : type of action to take in order to remediate the issue, if possible. For example USER_CONFIG_DATASET, ADMIN_SETTINGS_SECURITY, …




Return type:
    

dict

_class _dataikuapi.dss.scenario.DSSScenarioRunWaiter(_scenario_run_ , _trigger_fire_)
    

Helper to wait for a scenario to run to complete.

wait(_no_fail =False_)
    

Wait for the scenario run completion.

Parameters:
    

**no_fail** (_boolean_) – if False, raises if the run doesn’t end with a SUCCESS outcome

Returns:
    

the final state of the scenario run (see `DSSScenarioRun.get_info()`)

Return type:
    

dict

_class _dataikuapi.dss.scenario.DSSTriggerFire(_scenario_ , _trigger_fire_)
    

A handle representing the firing of a trigger on a scenario.

Important

Do not instantiate directly, use `DSSScenario.run()`

get_raw()
    

Get the definition of the trigger fire event.

Returns:
    

the trigger fire, as a dict. The **runId** field in the dict is not an identifier of a scenario run, but of a run of the trigger.

Return type:
    

dict

wait_for_scenario_run(_no_fail =False_)
    

Poll for the run of the scenario that the trigger fire should initiate.

This methos waits for the run of the sceanrio that this trigger activation launched to be available, or for the trigger fire to be cancelled (possibly cancelled by another trigger firing).

Parameters:
    

**no_fail** (_boolean_) – if True, return None if the trigger fire is cancelled, else raise

Returns:
    

a handle on a scenario run, or None

Return type:
    

`DSSScenarioRun`

get_scenario_run()
    

Get the run of the scenario that this trigger fire launched.

May return None if the scenario run started from this trigger has not yet been created.

Returns:
    

a handle on a scenario run, or None

Return type:
    

`DSSScenarioRun`

is_cancelled(_refresh =False_)
    

Whether the trigger fire has been cancelled

Parameters:
    

**refresh** – get the state of the trigger from the backend

_class _dataikuapi.dss.scenario.DSSScenarioListItem(_client_ , _data_)
    

An item in a list of scenarios.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.list_scenarios()`](<projects.html#dataikuapi.dss.project.DSSProject.list_scenarios> "dataikuapi.dss.project.DSSProject.list_scenarios")

to_scenario()
    

Get a handle corresponding to this scenario.

Return type:
    

`DSSScenario`

_property _id
    

Get the identifier of the scenario.

Return type:
    

string

_property _running
    

Whether the scenario is currently running.

Return type:
    

boolean

_property _start_time
    

Get the start time of the scenario run.

Returns:
    

timestap of the scenario run start, or None if it’s not running at the moment.

Return type:
    

`datetime.datetime`

_class _dataikuapi.dss.scenario.DSSTestingStatus(_raw_)
    

The testing status of a project

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.get_testing_status()`](<projects.html#dataikuapi.dss.project.DSSProject.get_testing_status> "dataikuapi.dss.project.DSSProject.get_testing_status"), `dataikuapi.dss.project.DSSProjectDeployer.get_testing_status()` or dataikuapi.dss.project.DSSProjectDeployer.run_test_scenarios()

_property _nb_total_ran_scenarios
    

The total number of ran scenarios

Return type:
    

int

_property _nb_scenarios_per_outcome
    

The number of ran scenarios per scenario outcome

Return type:
    

dict[string, int]

get_raw()
    

Gets the raw testing status information.

Return type:
    

dict

---

## [api-reference/python/semantic-models]

# Semantic models

_class _dataikuapi.dss.semantic_model.DSSSemanticModel(_client_ , _project_key_ , _semantic_model_id_)
    

A handle to interact with a semantic model.

Important

Do not create this class directly, use [`dataikuapi.dss.project.DSSProject.get_semantic_model()`](<projects.html#dataikuapi.dss.project.DSSProject.get_semantic_model> "dataikuapi.dss.project.DSSProject.get_semantic_model") instead.

_property _id
    

get_active_version_id()
    

Get the active version of this semantic model.

Returns:
    

semantic model version handle

Return type:
    

`dataikuapi.dss.semantic_model.DSSSemanticModelVersion`

set_active_version_id(_version_id_)
    

Set the active version of this semantic model.

Parameters:
    

**version_id** (_str_) – identifier of the version to set as active

delete()
    

Delete the semantic model.

list_versions_ids()
    

List versions of this semantic model.

Returns:
    

list of versions

Return type:
    

list[str]

get_version(_version_id_)
    

Get a handle to a specific version of this semantic model.

Parameters:
    

**version_id** (_str_) – identifier of the version

Returns:
    

semantic model version handle

Return type:
    

`dataikuapi.dss.semantic_model.DSSSemanticModelVersion`

new_version(_version_id_ , _duplicate_of =None_)
    

Create settings for a new version of this semantic model.

The returned settings must be saved using `DSSSemanticModelVersionSettings.save()`.
    
    
    # Example usage of creating a new version
    
    sm = project.get_semantic_model("my_semantic_model")
    version_settings = sm.new_version("v2")
    version_settings.save()
    
    # Example usage of creating a new version as a duplicate of an existing version
    
    sm = project.get_semantic_model("my_semantic_model")
    version_settings = sm.new_version("v2", duplicate_of="v1")
    version_settings.save()
    

Parameters:
    

  * **version_id** (_str_) – identifier for the new version

  * **duplicate_of** (_str_) – optional version id to duplicate settings from



Returns:
    

semantic model version settings

Return type:
    

`dataikuapi.dss.semantic_model.DSSSemanticModelVersionSettings`

_class _dataikuapi.dss.semantic_model.DSSSemanticModelVersion(_semantic_model_ , _version_id_)
    

A handle to a semantic model version.

Important

Do not create this class directly, use `dataikuapi.dss.semantic_model.DSSSemanticModel.get_version()` instead.

_property _version_id
    

get_settings()
    

Get the settings of this semantic model version.

Returns:
    

semantic model version settings

Return type:
    

`dataikuapi.dss.semantic_model.DSSSemanticModelVersionSettings`

get_basic_distinct_values_for_attribute(_entity_ , _attribute_ , _max_values =1000_)
    

Get distinct values for an attribute of this semantic model version.

Parameters:
    

  * **entity** (_str_) – entity name

  * **attribute** (_str_) – attribute name

  * **max_values** (_int_) – maximum number of values to return



Returns:
    

distinct values for the attribute

Return type:
    

dict

get_basic_distinct_values_for_model(_max_values =1000_)
    

Get distinct values for all attributes of this semantic model version.

Parameters:
    

**max_values** (_int_) – maximum number of values per attribute

Returns:
    

distinct values for the semantic model

Return type:
    

dict

start_update_distinct_values()
    

Start updating the distinct values index for this semantic model version.

Returns:
    

a future tracking the update

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

_class _dataikuapi.dss.semantic_model.DSSSemanticModelVersionSettings(_client_ , _project_key_ , _semantic_model_id_ , _version_id_ , _settings_)
    

Settings of a semantic model version

Important

Do not create this class directly, use `dataikuapi.dss.semanticmodel.DSSSemanticModelVersion.get_settings()` instead.

_static _new_settings(_version_id_)
    

_property _id
    

get_raw()
    

Returns the raw settings of the semantic model version.

Returns:
    

raw settings

Return type:
    

dict

save()
    

Save the semantic model version settings.

_class _dataikuapi.dss.semantic_model.DSSSemanticModelListItem(_client_ , _data_)
    

An item in a list of semantic models

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.list_semantic_models()`](<projects.html#dataikuapi.dss.project.DSSProject.list_semantic_models> "dataikuapi.dss.project.DSSProject.list_semantic_models").

to_semantic_model()
    

Convert the current item to a semantic model handle.

Returns:
    

A handle for the semantic model.

Return type:
    

`dataikuapi.dss.semantic_model.DSSSemanticModel`

_property _project_key
    

Returns:
    

The project key

Return type:
    

string

_property _id
    

Returns:
    

The id of the semantic model.

Return type:
    

string

_property _name
    

Returns:
    

The name of the semantic model.

Return type:
    

string

---

## [api-reference/python/snowpark]

# Snowpark

For usage information and examples, see [Snowpark](<../../concepts-and-examples/snowpark.html>)

_class _dataiku.snowpark.DkuSnowpark
    

Handle to create Snowpark sessions from DSS datasets or connections

create_session(_connection_name_ , _project_key =None_)
    

Creates a new session configured to read on the supplied DSS connection.

get_dataframe(_dataset_ , _session =None_)
    

Return a DataFrame configured to read the table that is underlying the specified dataset.

get_session(_connection_name_ , _project_key =None_)
    

Return session configured to read on the supplied DSS connection.

write_dataframe(_dataset_ , _df_ , _infer_schema =False_, _force_direct_write =False_, _dropAndCreate =False_)
    

Writes this dataset (or its target partition, if applicable) from a single dataframe.

This variant only edit the schema if infer_schema is True, otherwise you must take care to only write dataframes that have a compatible schema. Also see “write_with_schema”.

Parameters:
    

  * **df** – input dataframe.

  * **dataset** – Output dataset to write.

  * **infer_schema** – infer the schema from the dataframe.

  * **force_direct_write** – Force writing the dataframe using the direct API into the dataset even if they don’t come from the same DSS connection.

  * **dropAndCreate** – if infer_schema and this parameter are both set to True, clear and recreate the dataset structure.




write_with_schema(_dataset_ , _df_ , _force_direct_write =False_, _dropAndCreate =False_)
    

Writes this dataset (or its target partition, if applicable) from a single dataframe.

This variant replaces the schema of the output dataset with the schema of the dataframe.

Parameters:
    

  * **df** – input dataframe.

  * **dataset** – Output dataset to write.

  * **force_direct_write** – Force writing the dataframe using the direct API into the dataset even if they don’t come from the same DSS connection.

  * **dropAndCreate** – drop and recreate the dataset.

---

## [api-reference/python/sql]

# Performing SQL, Hive and Impala queries

For usage information and examples, see [Performing SQL, Hive and Impala queries](<../../concepts-and-examples/sql.html>)

_class _dataiku.SQLExecutor2(_connection =None_, _dataset =None_)
    

This is a handle to execute SQL statements on a given SQL connection.

The connection is derived from either the connection parameter or the dataset parameter.

Parameters:
    

  * **connection** (_string_) – name of the SQL connection

  * **dataset** – name of a dataset or a [`dataiku.Dataset`](<datasets.html#dataiku.Dataset> "dataiku.Dataset") object.




_static _exec_recipe_fragment(_output_dataset_ , _query_ , _pre_queries =[]_, _post_queries =[]_, _overwrite_output_schema =True_, _drop_partitioned_on_schema_mismatch =False_)
    

Executes a SQL query and store the results to the output_dataset after dropping its underlying table.

Parameters:
    

  * **output_dataset** (_object_) – [`dataiku.Dataset`](<datasets.html#dataiku.Dataset> "dataiku.Dataset") output dataset where to write the result of the query.

  * **query** (_str_) – SQL main query

  * **pre_queries** (_list_) – list of queries to be executed before the main query

  * **post_queries** (_list_) – list of queries to be executed after the main query

  * **overwrite_output_schema** (_bool_) – if True, generates the output schema from the query results. If False, maintains the existing output schema

  * **drop_partitioned_on_schema_mismatch** (_bool_) – for partitioned output datasets. If True, drops all partitions whose schema is inconsistent with that of the dataset. Only relevant when overwrite_output_schema=True



Returns:
    

None

query_to_df(_query_ , _pre_queries =None_, _post_queries =None_, _extra_conf ={}_, _infer_from_schema =False_, _parse_dates =True_, _bool_as_str =False_, _dtypes =None_, _script_steps =None_, _script_input_schema =None_, _script_output_schema =None_, _** kwargs_)
    

This function returns the result of the main query as a pandas dataframe.

Parameters:
    

  * **query** (_str_) – SQL main query

  * **pre_queries** (_list_) – list of queries to be executed before the main query

  * **post_queries** (_list_) – list of queries to be executed after the main query

  * **extra_conf** – do not use

  * **infer_from_schema** (_bool_) – if True, the resulting pandas dataframe types are set per the SQL query datatypes rather than being inferred by pandas

  * **parse_dates** (_bool_) – if True, SQL datetime columns are set as datetime dtypes in the resulting pandas dataframe. The infer_from_schema must be True for this param to be relevant

  * **bool_as_str** (_bool_) – whether to cast boolean values as string

  * **dtypes** (_dict_) – with key= column name and value=`numpy.dtype()`

  * **script_steps** – do not use

  * **script_input_schema** – do not use

  * **script_output_schema** – do not use



Returns:
    

a pandas dataframe with the result of the query.

query_to_iter(_query_ , _pre_queries =None_, _post_queries =None_, _extra_conf ={}_, _script_steps =None_, _script_input_schema =None_, _script_output_schema =None_, _** kwargs_)
    

This function returns a `QueryReader` to iterate on the rows.

Parameters:
    

  * **query** (_str_) – the main query

  * **pre_queries** (_list_) – list of queries to be executed before the main query

  * **post_queries** (_list_) – list of queries to be executed after the main query

  * **script_steps** – do not use

  * **script_input_schema** – do not use

  * **script_output_schema** – do not use



Returns:
    

a `QueryReader` to iterate on the rows.

_class _dataiku.HiveExecutor(_dataset =None_, _database =None_, _connection =None_)
    

_static _exec_recipe_fragment(_query_ , _pre_queries =[]_, _post_queries =[]_, _overwrite_output_schema =True_, _drop_partitioned_on_schema_mismatch =False_, _metastore_handling =None_, _extra_conf ={}_, _add_dku_udf =False_)
    

query_to_df(_query_ , _pre_queries =None_, _post_queries =None_, _extra_conf ={}_, _infer_from_schema =False_, _parse_dates =True_, _bool_as_str =False_, _dtypes =None_, _script_steps =None_, _script_input_schema =None_, _script_output_schema =None_, _** kwargs_)
    

query_to_iter(_query_ , _pre_queries =None_, _post_queries =None_, _extra_conf ={}_, _script_steps =None_, _script_input_schema =None_, _script_output_schema =None_, _** kwargs_)
    

_class _dataiku.ImpalaExecutor(_dataset =None_, _database =None_, _connection =None_)
    

_static _exec_recipe_fragment(_output_dataset_ , _query_ , _pre_queries =[]_, _post_queries =[]_, _overwrite_output_schema =True_, _use_stream_mode =True_)
    

query_to_df(_query_ , _pre_queries =None_, _post_queries =None_, _connection =None_, _extra_conf ={}_, _infer_from_schema =False_, _parse_dates =True_, _bool_as_str =False_, _dtypes =None_, _script_steps =None_, _script_input_schema =None_, _script_output_schema =None_, _** kwargs_)
    

query_to_iter(_query_ , _pre_queries =None_, _post_queries =None_, _connection =None_, _extra_conf ={}_, _script_steps =None_, _script_input_schema =None_, _script_output_schema =None_, _** kwargs_)
    

_class _dataikuapi.dss.sqlquery.DSSSQLQuery(_client_ , _query_ , _connection_ , _database_ , _dataset_full_name_ , _pre_queries_ , _post_queries_ , _type_ , _extra_conf_ , _script_steps_ , _script_input_schema_ , _script_output_schema_ , _script_report_location_ , _read_timestamp_without_timezone_as_string_ , _read_date_as_string_ , _datetimenotz_read_mode_ , _dateonly_read_mode_ , _project_key_)
    

A connection to a database or database-like on which queries can be run through DSS.

Important

Do not create this class directly, instead use [`dataikuapi.DSSClient.sql_query()`](<client.html#dataikuapi.DSSClient.sql_query> "dataikuapi.DSSClient.sql_query")

Usage example:
    
    
    # run some query on a connection
    query = client.sql_query('select * from "public"."SOME_TABLE"', connection='some_postgres_connection')
    n = 0
    for row in query.iter_rows():
        n += 1
        if n < 10:
            print("row %s : %s" % (n, row))
    query.verify()
    print("Returned %s rows" % n)
    

get_schema()
    

Get the query’s result set’s schema.

The schema made of DSS column types, and built from mapping database types to DSS types. The actual type in the database can be found in the originalType field (originalSQLType in BigQuery)

Returns:
    

a schema, as a dict with a columns array, in which each element is a column, itself as a dict of

  * **name** : the column name

  * **type** : the column type (smallint, int, bigint, float, double, boolean, date, string)

  * **length** : the string length

  * **comment** : the column name

  * **originalType** : type of the column in the database




Return type:
    

dict

iter_rows()
    

Get an iterator on the query’s results.

Returns:
    

an iterator over the rows, each row being a tuple of values. The order of values in the tuples is the same as the order of columns in the schema returned by [`get_schema()`](<sqlquery.html#dataikuapi.dss.sqlquery.DSSSQLQuery.get_schema> "dataikuapi.dss.sqlquery.DSSSQLQuery.get_schema"). The values are cast to python types according to the types in [`get_schema()`](<sqlquery.html#dataikuapi.dss.sqlquery.DSSSQLQuery.get_schema> "dataikuapi.dss.sqlquery.DSSSQLQuery.get_schema")

Return type:
    

iterator[list]

verify()
    

Verify that reading results completed successfully.

When using the [`iter_rows()`](<sqlquery.html#dataikuapi.dss.sqlquery.DSSSQLQuery.iter_rows> "dataikuapi.dss.sqlquery.DSSSQLQuery.iter_rows") method, and the iterator stops returning rows, there is no way to tell whether there are no more rows because the query didn’t return more rows, or because an error in the query, or in the fetching of its results, happened. You should thus call [`verify()`](<sqlquery.html#dataikuapi.dss.sqlquery.DSSSQLQuery.verify> "dataikuapi.dss.sqlquery.DSSSQLQuery.verify") after the iterator is done, because it will raise an Exception if an error happened.

Raises:
    

Exception

---

## [api-reference/python/sqlquery]

# SQL Query

_class _dataikuapi.dss.sqlquery.DSSSQLQuery(_client_ , _query_ , _connection_ , _database_ , _dataset_full_name_ , _pre_queries_ , _post_queries_ , _type_ , _extra_conf_ , _script_steps_ , _script_input_schema_ , _script_output_schema_ , _script_report_location_ , _read_timestamp_without_timezone_as_string_ , _read_date_as_string_ , _datetimenotz_read_mode_ , _dateonly_read_mode_ , _project_key_)
    

A connection to a database or database-like on which queries can be run through DSS.

Important

Do not create this class directly, instead use [`dataikuapi.DSSClient.sql_query()`](<client.html#dataikuapi.DSSClient.sql_query> "dataikuapi.DSSClient.sql_query")

Usage example:
    
    
    # run some query on a connection
    query = client.sql_query('select * from "public"."SOME_TABLE"', connection='some_postgres_connection')
    n = 0
    for row in query.iter_rows():
        n += 1
        if n < 10:
            print("row %s : %s" % (n, row))
    query.verify()
    print("Returned %s rows" % n)
    

get_schema()
    

Get the query’s result set’s schema.

The schema made of DSS column types, and built from mapping database types to DSS types. The actual type in the database can be found in the originalType field (originalSQLType in BigQuery)

Returns:
    

a schema, as a dict with a columns array, in which each element is a column, itself as a dict of

  * **name** : the column name

  * **type** : the column type (smallint, int, bigint, float, double, boolean, date, string)

  * **length** : the string length

  * **comment** : the column name

  * **originalType** : type of the column in the database




Return type:
    

dict

iter_rows()
    

Get an iterator on the query’s results.

Returns:
    

an iterator over the rows, each row being a tuple of values. The order of values in the tuples is the same as the order of columns in the schema returned by `get_schema()`. The values are cast to python types according to the types in `get_schema()`

Return type:
    

iterator[list]

verify()
    

Verify that reading results completed successfully.

When using the `iter_rows()` method, and the iterator stops returning rows, there is no way to tell whether there are no more rows because the query didn’t return more rows, or because an error in the query, or in the fetching of its results, happened. You should thus call `verify()` after the iterator is done, because it will raise an Exception if an error happened.

Raises:
    

Exception

---

## [api-reference/python/static-insights]

# Static insights

In DSS code recipes and notebooks, you can create static insights: data files that are created by code and that can be rendered on the dashboard.

For usage information and examples, see [Static insights](<../../concepts-and-examples/static-insights.html>)

dataiku.insights.save_data(_id_ , _payload_ , _content_type_ , _label =None_, _project_key =None_, _encoding =None_)
    

Saves data as a DSS static insight that can be exposed on the dashboard

Parameters:
    

  * **id** (_str_) – Unique identifier of the insight within the project. If an insight with the same identifier already exists, it will be replaced

  * **payload** – bytes-oriented data, or Base64 string

  * **content_type** – the MIME type of the data in payload (example: text/html or image/png)

  * **label** (_str_) – Optional display label for the insight. If None, the id will be used as label

  * **project_key** (_str_) – Project key in which the insight must be saved. If None, the contextual (current) project is used

  * **encoding** (_str_) – If the payload was a Base64 string, this must be “base64”. Else, this must be None




dataiku.insights.save_figure(_id_ , _figure =None_, _label =None_, _project_key =None_)
    

Saves a matplotlib or seaborn figure as a DSS static insight that can be exposed on the dashboard

Parameters:
    

  * **id** (_str_) – Unique identifier of the insight within the project. If an insight with the same identifier already exists, it will be replaced

  * **figure** – a matplotlib or seaborn figure object. If None, the latest processed figure will be used

  * **label** (_str_) – Optional display label for the insight. If None, the id will be used as label

  * **project_key** (_str_) – Project key in which the insight must be saved. If None, the contextual (current) project is used




dataiku.insights.save_bokeh(_id_ , _bokeh_obj_ , _label =None_, _project_key =None_)
    

Saves a Bokeh object as a DSS static insight that can be exposed on the dashboard A static HTML export of the provided Bokeh object is done

Parameters:
    

  * **id** (_str_) – Unique identifier of the insight within the project. If an insight with the same identifier already exists, it will be replaced

  * **bokeh_obj** – a Bokeh object

  * **label** (_str_) – Optional display label for the insight. If None, the id will be used as label

  * **project_key** (_str_) – Project key in which the insight must be saved. If None, the contextual (current) project is used




dataiku.insights.save_plotly(_id_ , _figure_ , _label =None_, _project_key =None_)
    

Saves a Plot.ly figure as a DSS static insight that can be exposed on the dashboard A static HTML export of the provided Plot.ly object is done

Parameters:
    

  * **id** (_str_) – Unique identifier of the insight within the project. If an insight with the same identifier already exists, it will be replaced

  * **figure** – a Plot.ly figure

  * **label** (_str_) – Optional display label for the insight. If None, the id will be used as label

  * **project_key** (_str_) – Project key in which the insight must be saved. If None, the contextual (current) project is used




dataiku.insights.save_ggplot(_id_ , _gg_ , _label =None_, _width =None_, _height =None_, _dpi =None_, _project_key =None_)
    

Saves a ggplot object as a DSS static insight that can be exposed on the dashboard

Parameters:
    

  * **id** (_str_) – Unique identifier of the insight within the project. If an insight with the same identifier already exists, it will be replaced

  * **gg** – a ggplot object

  * **label** (_str_) – Optional display label for the insight. If None, the id will be used as label

  * **width** (_int_) – Width of the image export

  * **height** (_int_) – Height of the image export

  * **dpi** (_int_) – Resolution in dots per inch of the image export

  * **project_key** (_str_) – Project key in which the insight must be saved. If None, the contextual (current) project is used

---

## [api-reference/python/statistics]

# Statistics worksheets

For usage information and examples, see [Statistics worksheets](<../../concepts-and-examples/statistics.html>)

_class _dataikuapi.dss.statistics.DSSStatisticsWorksheet(_client_ , _project_key_ , _dataset_name_ , _worksheet_id_)
    

A handle to interact with a worksheet.

Important

Do not create this class directly, instead use [`dataikuapi.dss.dataset.DSSDataset.get_statistics_worksheet()`](<datasets.html#dataikuapi.dss.dataset.DSSDataset.get_statistics_worksheet> "dataikuapi.dss.dataset.DSSDataset.get_statistics_worksheet")

delete()
    

Deletes the worksheet.

get_settings()
    

Gets the worksheet settings.

Returns:
    

a handle for the worksheet settings

Return type:
    

`DSSStatisticsWorksheetSettings`

run_worksheet(_wait =True_)
    

Computes the result of the whole worksheet.

When wait is True, the method waits for the computation to complete and returns the corresponding result, otherwise it returns immediately a handle for a [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") result.

Parameters:
    

**wait** (_bool_) – a flag to wait for the computation to complete (defaults to **True**)

Returns:
    

the corresponding card result or a handle for the future result

Return type:
    

`DSSStatisticsCardResult` or [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

run_card(_card_ , _wait =True_)
    

Computes the result of a card in the context of the worksheet.

When wait is True, the method waits for the computation to complete and returns the corresponding result, otherwise it returns immediately a handle for a [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") result.

Note

The card does not need to belong to the worksheet.

Parameters:
    

  * **card** (`DSSStatisticsCardSettings` or dict obtained from `DSSStatisticsCardSettings.get_raw()`) – the card to compute

  * **wait** (_bool_) – a flag to wait for the computations to complete (defaults to **True**)



Returns:
    

the corresponding card result or a handle for the future result

Return type:
    

`DSSStatisticsCardResult` or [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

run_computation(_computation_ , _wait =True_)
    

Runs a computation in the context of the worksheet.

When wait is True, the method waits for the computation to complete and returns the corresponding result, otherwise it returns immediately a handle for a [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") result.

Parameters:
    

  * **computation** (`DSSStatisticsComputationSettings` or dict obtained from `DSSStatisticsComputationSettings.get_raw()`) – the computation to perform

  * **wait** (_bool_) – a flag to wait for the computations to complete (defaults to **True**)



Returns:
    

the corresponding computation result or a handle for the future result

Returns:
    

`DSSStatisticsComputationResult` or [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

_class _dataikuapi.dss.statistics.DSSStatisticsWorksheetSettings(_client_ , _project_key_ , _dataset_name_ , _worksheet_id_ , _worksheet_definition_)
    

A handle to interact with the worksheet settings.

Important

Do not create this class directly, instead use `DSSStatisticsWorksheet.get_settings()`

add_card(_card_)
    

Adds a new card to the worksheet.

Parameters:
    

**card** (`DSSStatisticsCardSettings` or dict obtained from `DSSStatisticsCardSettings.get_raw()`) – the card to add

list_cards()
    

Lists the cards for the worksheet.

Returns:
    

a list of card handles

Return type:
    

list of `DSSStatisticsCardSettings`

get_raw()
    

Gets a reference to the raw representation of the worksheet settings.

Returns:
    

the worksheet settings

Return type:
    

dict

set_sampling_settings(_selection_)
    

Sets the worksheet sampling settings.

Parameters:
    

**selection** ([`DSSDatasetSelectionBuilder`](<utils.html#dataikuapi.dss.utils.DSSDatasetSelectionBuilder> "dataikuapi.dss.utils.DSSDatasetSelectionBuilder") or dict obtained from `get_raw_sampling_settings()`) – the sampling settings

get_raw_sampling_settings()
    

Gets a reference to the raw representation of the worksheet sampling settings.

Returns:
    

the sampling settings

Return type:
    

dict

save()
    

Saves the settings of the worksheet.

_class _dataikuapi.dss.statistics.DSSStatisticsCardSettings(_client_ , _card_definition_)
    

A handle to interact with the card settings.

get_raw()
    

Gets a reference to the raw representation of the card settings.

Returns:
    

the card settings

Return type:
    

dict

compile()
    

Gets the computation used to compute the card result.

Returns:
    

the computation settings

Return type:
    

`DSSStatisticsComputationSettings`

_class _dataikuapi.dss.statistics.DSSStatisticsCardResult(_card_result_)
    

A handle to interact with the computed result of a `DSSStatisticsCardSettings`.

get_raw()
    

Gets a reference to the raw representation of the card result.

Returns:
    

the card result

Return type:
    

dict

_class _dataikuapi.dss.statistics.DSSStatisticsComputationSettings(_computation_definition_)
    

A handle to interact with the computation settings.

get_raw()
    

Gets a reference to the raw representation of the computation settings.

Returns:
    

the computation settings

Return type:
    

dict

_class _dataikuapi.dss.statistics.DSSStatisticsComputationResult(_computation_result_)
    

A handle to interact with the computed result of a `DSSStatisticsComputationSettings`.

get_raw()
    

Gets a reference to the raw representation of the computation result.

Returns:
    

the computation result

Return type:
    

dict