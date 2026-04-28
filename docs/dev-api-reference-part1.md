# Dataiku Docs — dev-api-reference

## [api-reference/python/flow]

# Flow creation and management

For usage information and examples, see [Flow creation and management](<../../concepts-and-examples/flow.html>)

_class _dataikuapi.dss.flow.DSSProjectFlow(_client_ , _project_)
    

get_graph()
    

Get the flow graph.

Returns:
    

A handle to use the flow graph

Return type:
    

`DSSProjectFlowGraph`

create_zone(_name_ , _color ='#2ab1ac'_)
    

Creates a new flow zone.

Parameters:
    

  * **name** (_str_) – new flow zone name

  * **color** (_str_) – new flow zone color, in hexadecimal format #RRGGBB (defaults to **#2ab1ac**)



Returns:
    

the newly created zone

Return type:
    

`DSSFlowZone`

get_zone(_id_)
    

Gets a single Flow zone by id.

Parameters:
    

**id** (_str_) – flow zone id

Returns:
    

A flow zone

Return type:
    

`DSSFlowZone`

get_default_zone()
    

Returns the default zone of the Flow.

Returns:
    

A flow zone

Return type:
    

`DSSFlowZone`

list_zones()
    

Lists all zones in the Flow.

Returns:
    

A list of flow zones

Return type:
    

list of `DSSFlowZone`

get_zone_of_object(_obj_)
    

Finds the zone to which this object belongs.

If the object is not found in any specific zone, it belongs to the default zone, and the default zone is returned.

Parameters:
    

**obj** ([`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), [`DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe") [`DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore") or [`DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")) – An object to search

Returns:
    

The flow zone containing the object

Return type:
    

`DSSFlowZone`

replace_input_computable(_current_ref_ , _new_ref_ , _type ='DATASET'_)
    

This method replaces all references to a “computable” (Dataset, Managed Folder or Saved Model) as input of recipes in the whole Flow by a reference to another computable.

No specific checks are performed. It is your responsibility to ensure that the schema of the new dataset will be compatible with the previous one (in the case of datasets).

If new_ref references an object in a foreign project, this method will automatically ensure that new_ref is exposed to the current project.

Parameters:
    

  * **current_ref** (_str_) – Either a “simple” object id (dataset name or model/folder/model evaluation store/streaming endpoint id) or a foreign object reference in the form “FOREIGN_PROJECT_KEY.local_id”

  * **new_ref** (_str_) – Either a “simple” object id (dataset name or model/folder/model evaluation store/streaming endpoint id) or a foreign object reference in the form “FOREIGN_PROJECT_KEY.local_id”

  * **type** (_str_) – The type of object being replaced (DATASET, SAVED_MODEL, MANAGED_FOLDER, MODEL_EVALUATION_STORE, STREAMING_ENDPOINT) (defaults to **DATASET**)




generate_documentation(_folder_id =None_, _path =None_)
    

Start the flow document generation from a template docx file in a managed folder, or from the default template if no folder id and path are specified.

Parameters:
    

  * **folder_id** (_str_) – the id of the managed folder (defaults to **None**)

  * **path** (_str_) – the path to the file from the root of the folder (defaults to **None**)



Returns:
    

The flow document generation future

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

generate_documentation_from_custom_template(_fp_)
    

Start the flow document generation from a docx template (as a file object).

Parameters:
    

**fp** (_object_) – A file-like object pointing to a template docx file

Returns:
    

The flow document generation future

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

download_documentation_stream(_export_id_)
    

Download a flow documentation, as a binary stream.

Warning

You need to close the stream after download. Failure to do so will result in the DSSClient becoming unusable.

Parameters:
    

**export_id** (_str_) – the id of the generated flow documentation returned as the result of the future

Returns:
    

the generated flow documentation file as a stream

Return type:
    

`requests.Response`

download_documentation_to_file(_export_id_ , _path_)
    

Download a flow documentation into the given output file.

Parameters:
    

  * **export_id** (_str_) – the id of the generated flow documentation returned as the result of the future

  * **path** (_str_) – the path where to download the flow documentation




start_tool(_type_ , _data ={}_)
    

Caution

Deprecated, this method will no longer be available for views (starting with DSS 13.4): TAGS, CUSTOM_FIELDS, CONNECTIONS, COUNT_OF_RECORDS, FILESIZE, FILEFORMATS, RECIPES_ENGINES, RECIPES_CODE_ENVS, IMPALA_WRITE_MODE, HIVE_MODE, SPARK_CONFIG, SPARK_PIPELINES, SQL_PIPELINES, PARTITIONING, PARTITIONS, SCENARIOS, CREATION, LAST_MODIFICATION, LAST_BUILD, RECENT_ACTIVITY, WATCH. It will be maintained for flow actions.

Start a tool in the flow.

Parameters:
    

  * **type** (_str_) – one of {COPY, CHECK_CONSISTENCY, PROPAGATE_SCHEMA}

  * **data** (_dict_) – initial data for the tool (defaults to **{}**)



Returns:
    

A handle to interact with the newly-created tool or view

Return type:
    

`DSSFlowTool`

new_schema_propagation(_dataset_name_)
    

Start an automatic schema propagation from a dataset.

Parameters:
    

**dataset_name** (_str_) – name of a dataset to start propagating from

Returns:
    

A handle to set options and start the propagation

Return type:
    

`DSSSchemaPropagationRunBuilder`

_class _dataikuapi.dss.flow.DSSProjectFlowGraph(_flow_ , _data_)
    

get_source_computables(_as_type ='dict'_)
    

Parameters:
    

**as_type** (_str_) – How to return the source computables. Possible values are “dict” and “object” (defaults to **dict**)

Returns:
    

The list of source computables

Return type:
    

If as_type=dict, each computable is returned as a dict containing at least “ref” and “type”. If as_type=object, each computable is returned as a [`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), [`DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore") or [`DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")

get_source_recipes(_as_type ='dict'_)
    

Parameters:
    

**as_type** (_str_) – How to return the source recipes. Possible values are “dict” and “object” (defaults to **dict**)

Returns:
    

The list of source recipes

Return type:
    

If as_type=dict, each recipe is returned as a dict containing at least “ref” and “type”. If as_type=object, each recipe is returned as a [`DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe").

get_source_datasets()
    

Returns:
    

The list of source datasets for this project

Return type:
    

List of [`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

get_successor_recipes(_node_ , _as_type ='dict'_)
    

Parameters:
    

  * **node** (str or [`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")) – Either a name or a dataset object

  * **as_type** (_str_) – How to return the successor recipes. Possible values are “dict” and “object” (defaults to **dict**)



Returns:
    

A list of recipes that are a successor of the given graph node

Return type:
    

If as_type=dict, each recipe is returned as a dict containing at least “ref” and “type”. If as_type=object, each recipe is returned as a [`DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe").

get_successor_computables(_node_ , _as_type ='dict'_)
    

Parameters:
    

  * **node** (str or [`DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe")) – Either a name or a recipe object

  * **as_type** (_str_) – How to return the successor computables. Possible values are “dict” and “object” (defaults to **dict**).



Returns:
    

A list of computables that are a successor of a given graph node

Return type:
    

If as_type=dict, each computable is returned as a dict containing at least “ref” and “type”. If as_type=object, each computable is returned as a [`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"). [`DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore") or [`DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")

get_items_in_traversal_order(_as_type ='dict'_)
    

Get the list of nodes in left to right order.

Parameters:
    

**as_type** (_str_) – How to return the nodes. Possible values are “dict” and “object” (defaults to **dict**).

Returns:
    

A list of nodes

Return type:
    

If as_type=dict, each item is returned as a dict containing at least “ref” and “type”. If as_type=object, each item is returned as a [`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"). [`DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore"), [`DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint") or [`DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe")

_class _dataikuapi.dss.flow.DSSFlowZone(_flow_ , _data_)
    

A zone in the Flow.

Important

Do not create this object manually, use `DSSProjectFlow.get_zone()` or `DSSProjectFlow.list_zones()`

_property _id
    

_property _name
    

_property _color
    

get_settings()
    

Gets the settings of this zone in order to modify them.

Returns:
    

The settings of the flow zone

Return type:
    

`DSSFlowZoneSettings`

add_item(_obj_)
    

Adds an item to this zone.

The item will automatically be moved from its existing zone. Additional items may be moved to this zone as a result of the operation (notably the recipe generating obj).

Parameters:
    

**obj** ([`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), [`DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe"), [`DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore") or [`DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")) – object to add to the zone

add_items(_items_)
    

Adds items to this zone.

The items will automatically be moved from their existing zones. Additional items may be moved to this zone as a result of the operations (notably the recipe generating the items).

Parameters:
    

**items** (list of [`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), [`DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe"), [`DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore") or [`DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")) – A list of objects to add to the zone

_property _items
    

The list of items explicitly belonging to this zone.

This list is read-only. To add an object, use `add_item()`. It will remove it from its current zone, if any. To remove an object from a zone without placing in another specific zone, add it to the default zone: `flow.get_zone('default').add_item(item)`

Note

The “default” zone content is defined as all items that are not explicitly in another zone.

Returns:
    

the items in the zone

Return type:
    

list of [`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), [`DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe"), [`DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore") or [`DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")

add_shared(_obj_)
    

Share an item to this zone.

The item will not be automatically unshared from its existing zone.

Parameters:
    

**obj** ([`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), [`DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe"), [`DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore") or [`DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")) – object to share to the zone

remove_shared(_obj_)
    

Remove a shared item from this zone.

Parameters:
    

**obj** ([`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), [`DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore") or [`DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")) – object to remove from the zone

_property _shared
    

The list of items that have been explicitly pre-shared to this zone.

This list is read-only, to modify it, use `add_shared()` and `remove_shared()`

Returns:
    

the items shared to this zone

Return type:
    

list of [`DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), [`DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder"), [`DSSSavedModel`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel> "dataikuapi.dss.savedmodel.DSSSavedModel"), [`DSSModelEvaluationStore`](<model-evaluation-stores.html#dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore> "dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore") or [`DSSStreamingEndpoint`](<streaming-endpoints.html#dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint> "dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint")

get_graph()
    

Get the flow graph.

Returns:
    

A handle to use the flow graph

Return type:
    

`DSSProjectFlowGraph`

delete()
    

Delete the zone, all items will be moved to the default zone.

generate_ai_description(_language ='english'_, _purpose ='generic'_, _length ='medium'_, _save_description =False_)
    

Generates an AI-powered description for this flow zone.

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

_class _dataikuapi.dss.flow.DSSFlowZoneSettings(_zone_)
    

The settings of a flow zone.

Important

Do not create this directly, use `DSSFlowZone.get_settings()`.

get_raw()
    

Gets the raw settings of the zone.

Note

You cannot modify the items and shared elements through this class. Instead, use `DSSFlowZone.add_item()` and others

_property _name
    

_property _color
    

save()
    

Saves the settings of the zone

_class _dataikuapi.dss.flow.DSSSchemaPropagationRunBuilder(_project_ , _client_ , _dataset_name_)
    

Important

Do not create this directly, use `DSSProjectFlow.new_schema_propagation()`.

set_auto_rebuild(_auto_rebuild_)
    

Sets whether to automatically rebuild datasets if needed while propagating.

Parameters:
    

**auto_rebuild** (_bool_) – whether to automatically rebuild datasets if needed (defaults to **True**)

set_default_partitioning_value(_dimension_ , _value_)
    

In the case of partitioned flows, sets the default partition value to use when rebuilding, for a specific dimension name.

Parameters:
    

  * **dimension** (_str_) – a partitioning dimension name

  * **value** (_str_) – a partitioning dimension value




set_partition_for_computable(_full_id_ , _partition_)
    

In the case of partitioned flows, sets the partition id to use when building a particular computable. Overrides the default partitioning value per dimension.

Parameters:
    

  * **full_id** (_str_) – Full name of the computable, in the form PROJECTKEY.id

  * **partition** (_str_) – a full partition id (all dimensions)




stop_at(_recipe_name_)
    

Sets the given recipe as a schema propagation stop mark.

Parameters:
    

**recipe_name** (_str_) – the name of the recipe

mark_recipe_as_ok(_name_)
    

Marks a recipe as always considered as OK during propagation.

Parameters:
    

**name** (_str_) – recipe to mark as ok

set_grouping_update_options(_recipe =None_, _remove_missing_aggregates =True_, _remove_missing_keys =True_, _new_aggregates ={}_)
    

Sets update options for grouping recipes.

Parameters:
    

  * **recipe** (_str_) – if None, applies to all grouping recipes. Else, applies only to this name (defaults to **None**)

  * **remove_missing_aggregates** (_bool_) – whether to remove missing aggregates (defaults to **True**)

  * **remove_missing_keys** (_bool_) – whether to remove missing keys (defaults to **True**)

  * **new_aggregates** (_dict_) – new aggregates (defaults to **{}**)




set_window_update_options(_recipe =None_, _remove_missing_aggregates =True_, _remove_missing_in_window =True_, _new_aggregates ={}_)
    

Sets update options for window recipes.

Parameters:
    

  * **recipe** (_str_) – if None, applies to all window recipes. Else, applies only to this name (defaults to **None**)

  * **remove_missing_aggregates** (_bool_) – whether to remove missing aggregates (defaults to **True**)

  * **remove_missing_in_window** (_bool_) – whether to remove missing keys in windows (defaults to **True**)

  * **new_aggregates** (_dict_) – new aggregates (defaults to **{}**)




set_join_update_options(_recipe =None_, _remove_missing_join_conditions =True_, _remove_missing_join_values =True_, _new_selected_columns ={}_)
    

Sets update options for join recipes.

Parameters:
    

  * **recipe** (_str_) – if None, applies to all join recipes. Else, applies only to this name (defaults to **None**)

  * **remove_missing_join_conditions** (_bool_) – whether to remove missing join conditions (defaults to **True**)

  * **remove_missing_join_values** (_bool_) – whether to remove missing join values (defaults to **True**)

  * **new_selected_columns** (_dict_) – new selected columns (defaults to **{}**)




start()
    

Starts the actual propagation. Returns a future to wait for completion.

Returns:
    

A future representing the schema propagation job

Return type:
    

[`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

---

## [api-reference/python/footprint]

# Datadir footprint

_class _dataikuapi.dss.data_directories_footprint.DSSDataDirectoriesFootprint(_client_)
    

Handle to analyze the footprint of data directories

Warning

Do not create this class directly, use [`dataikuapi.DSSClient.get_data_directories_footprint()`](<client.html#dataikuapi.DSSClient.get_data_directories_footprint> "dataikuapi.DSSClient.get_data_directories_footprint")

compute_global_only_footprint(_wait =True_)
    

Compute the global data directories footprints, returning directories size in bytes. Global directories are instance-wide directories like code envs, plugins, libs.

Parameters:
    

**wait** (_bool_) – a flag to wait for the computations to complete (defaults to **True**)

Returns:
    

If wait is False, a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the listing process. If wait is True, a `dataikuapi.dss.data_directories_footprint.Footprint`

compute_project_footprint(_project_key_ , _wait =True_)
    

Lists data directories footprints for the given project, returning directories size in bytes. Project directories are owned by a single project like managed datasets or managed folders, code studios, scenarios.

Parameters:
    

  * **project_key** (_string_) – the project key

  * **wait** (_bool_) – a flag to wait for the computations to complete (defaults to **True**)



Returns:
    

If wait is False, a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the listing process. If wait is True, a `dataikuapi.dss.data_directories_footprint.Footprint`

compute_all_dss_footprint(_wait =True_)
    

Lists all the DSS data directories footprints, returning directories size in bytes. This includes all the projects.

Parameters:
    

**wait** (_bool_) – a flag to wait for the computations to complete (defaults to **True**)

Returns:
    

If wait is False, a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the listing process. If wait is True, a `dataikuapi.dss.data_directories_footprint.Footprint`

compute_unknown_footprint(_show_summary_only =True_, _wait =True_)
    

Lists the unknown data directories footprints, returning directories size in bytes Unknown directories are any directory that does not belong to DSS

Parameters:
    

  * **show_summary_only** (_bool_) – only show the aggregate per location found (defaults to **False**)

  * **wait** (_bool_) – a flag to wait for the computations to complete (defaults to **True**)



Returns:
    

If wait is False, a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the listing process. If wait is True, a `dataikuapi.dss.data_directories_footprint.Footprint`

_class _dataikuapi.dss.data_directories_footprint.Footprint(_data_)
    

Helper class to access values of the data directories footprint

_property _size
    

Get the size of this footprint item in bytes

_property _human_readable_size
    

Get a printable size of this footprint item

get_size(_unit =None_)
    

Get the size of this footprint item

Parameters:
    

**unit** – desired unit in which the size should be expressed. Can be ‘B’, ‘KB’, ‘MB’, ‘GB’. If not set, a unit is chosen automatically

Returns:
    

if _unit_ is specified, a number; else, a string.

_property _nb_files
    

Get the number of files in this footprint item

_property _nb_folders
    

Get the number of folders in this footprint item

_property _nb_errors
    

Get the number of errors in this footprint item.

Errors happen when a file or folder inside the footprint item is not accessible, for example in case of permission issues.

_property _details
    

Drill down into this data directories footprint

Returns:
    

a dict of footprints

---

## [api-reference/python/govern]

# Govern

For usage information and examples, see [Dataiku Govern](<../../concepts-and-examples/govern/index.html>)

_class _dataikuapi.govern_client.GovernClient(_host_ , _api_key =None_, _internal_ticket =None_, _extra_headers =None_, _no_check_certificate =False_, _client_certificate =None_, _** kwargs_)
    

Entry point for the Dataiku Govern API client

list_futures(_as_objects =False_, _all_users =False_)
    

List the currently-running long tasks (a.k.a futures)

Parameters:
    

  * **as_objects** (_boolean_) – if True, each returned item will be a `dataikuapi.govern.future.GovernFuture`

  * **all_users** (_boolean_) – if True, returns futures for all users (requires admin privileges). Else, only returns futures for the user associated with the current authentication context (if any)



Returns:
    

list of futures. if as_objects is True, each future in the list is a `dataikuapi.govern.future.GovernFuture`. Else, each future in the list is a dict. Each dict contains at least a ‘jobId’ field

Return type:
    

list of `dataikuapi.govern.future.GovernFuture` or list of dict

get_future(_job_id_)
    

Get a handle to interact with a specific long task (a.k.a future). This notably allows aborting this future.

Parameters:
    

**job_id** (_str_) – the identifier of the desired future (which can be returned by `list_futures()`)

Returns:
    

A handle to interact the future

Return type:
    

`dataikuapi.govern.future.GovernFuture`

list_users_info()
    

Gets basic information about users on the Dataiku Govern instance.

You do not need to be admin to call this

Returns:
    

A list of users, as a list of `dataikuapi.govern.admin.GovernUserInfo`

list_groups_info()
    

Gets basic information about groups on the Dataiku Govern instance.

You do not need to be admin to call this

Returns:
    

A list of groups, as a list of `dataikuapi.govern.admin.GovernGroupInfo`

list_users(_as_objects =False_, _include_settings =False_)
    

List all users setup on the Dataiku Govern instance

Note: this call requires an API key with admin rights

Parameters:
    

  * **as_objects** (_bool_) – Return a list of `dataikuapi.govern.admin.GovernUser` instead of dictionaries. Defaults to False.

  * **include_settings** (_bool_) – Include detailed user settings in the response. Only useful if as_objects is False, as `dataikuapi.govern.admin.GovernUser` already includes settings by default. Defaults to False.



Returns:
    

A list of users, as a list of `dataikuapi.govern.admin.GovernUser` if as_objects is True, else as a list of dicts

Return type:
    

list of `dataikuapi.govern.admin.GovernUser` or list of dicts

get_user(_login_)
    

Get a handle to interact with a specific user

Parameters:
    

**login** (_str_) – the login of the desired user

Returns:
    

A `dataikuapi.govern.admin.GovernUser` user handle

create_user(_login_ , _password_ , _display_name =''_, _source_type ='LOCAL'_, _groups =None_, _profile ='DATA_SCIENTIST'_, _email =None_)
    

Create a user, and return a handle to interact with it

Note: this call requires an API key with admin rights

Note: this call is not available to Dataiku Cloud users

Parameters:
    

  * **login** (_str_) – the login of the new user

  * **password** (_str_) – the password of the new user

  * **display_name** (_str_) – the displayed name for the new user

  * **source_type** (_str_) – the type of new user. Admissible values are ‘LOCAL’ or ‘LDAP’

  * **groups** (_list_) – the names of the groups the new user belongs to (defaults to [])

  * **profile** (_str_) – The profile for the new user. Typical values (depend on your license): FULL_DESIGNER, DATA_DESIGNER, AI_CONSUMER, …

  * **email** (_str_) – The email for the new user.



Returns:
    

A `dataikuapi.govern.admin.GovernUser` user handle

create_users(_users_)
    

Create multiple users, and return a list of creation status

Note: this call requires an API key with admin rights

Note: this call is not available to Dataiku Cloud users

Parameters:
    

**users** (_list_) – 

a list of dictionaries where each dictionary contains the parameters for user creation. It should contain the following keys:

  * ’login’ (str): the login of the new user

  * ’password’ (str): the password of the new user

  * ’displayName’ (str): the displayed name for the new user

  * ’sourceType’ (str): the type of new user. Admissible values are ‘LOCAL’ or ‘LDAP’. Defaults to ‘LOCAL’

  * ’groups’ (list): the names of the groups the new user belongs to

  * ’userProfile’ (str): The profile for the new user. Typical values (depend on your license): FULL_DESIGNER, DATA_DESIGNER, AI_CONSUMER, … Defaults to ‘DATA_SCIENTIST’

  * ’email’ (str): The email for the new user. Defaults to None




Return type:
    

list[dict]

Returns:
    

A list of dictionaries, where each dictionary represents the creation status of a user. It should contain the following keys:

  * ’login’ (str): the login of the created user

  * ’status’ (str): the creation status of the user. Can be ‘SUCCESS’ or ‘FAILURE’

  * ’error’ (str): the error that occurred during that user’s creation. Empty if status is not ‘FAILURE’.




edit_users(_user_changes_)
    

Edits multiple users in a single bulk operation. This method is very permissive and is intended for mass operations. If you are modifying a small number of users, it is advised to get a handle from the get_user method and interact directly with a GovernUser object.

A valid workflow is to get the full users dictionaries from list_users(include_settings=True), modify them and use this method to apply the modifications.

Note: This call requires an API key with admin rights.

Note: this call is not available to Dataiku Cloud users

Parameters:
    

**user_changes** (_list_ _[__dict_ _]_) – 

A list of dictionaries, where each dictionary defines the changes for a single user. Each dictionary **must** contain the ‘login’ key to identify the user. Other keys can be included to modify the user’s properties, matching the structure of a user settings object (see the output of list_users(include_settings=True)). Available keys include:

  * ’login’ (str): The login of the user to modify (mandatory). Cannot be modified.

  * ’displayName’ (str): The user’s display name.

  * ’email’ (str): The user’s email address.

  * ’groups’ (list[str]): The list of groups for the user.

  * ’userProfile’ (str): The user’s profile (e.g., ‘FULL_DESIGNER’).

  * ’enabled’ (bool): Whether the user is enabled.

  * ’sourceType’: User provisioning source type. Admissible values are ‘LOCAL’ or ‘LDAP’.

  * ’adminProperties’ (dict): Custom admin properties for the user.

  * ’userProperties’ (dict): Custom user properties for the user.




Return type:
    

list[dict]

Returns:
    

A list of dictionaries, one for each attempted modification, indicating the status. Each dictionary contains the following keys:

  * ’login’ (str): The login of the user that was modified.

  * ’status’ (str): The result of the operation, either ‘SUCCESS’ or ‘FAILURE’.

  * ’error’ (str): The error message if the status is ‘FAILURE’, otherwise empty.




delete_users(_user_logins_ , _allow_self_deletion =False_)
    

Bulk deletes multiple users.

Note: This call requires an API key with admin rights.

Note: this call is not available to Dataiku Cloud users

Parameters:
    

  * **user_logins** (_list_ _[__str_ _]_) – A list of logins for the users to be deleted.

  * **allow_self_deletion** (_bool_) – Allow the use of this function to delete your own user. Warning: this is very dangerous and used recklessly could lead to the deletion of all users/admins.



Return type:
    

list[dict]

Returns:
    

A list of dictionaries, one for each attempted deletion, indicating the status. Each dictionary contains the following keys:

  * ’login’ (str): The login of the user that was deleted.

  * ’status’ (str): The result of the deletion, either ‘SUCCESS’ or ‘FAILURE’.

  * ’error’ (str): The error message if the status is ‘FAILURE’, otherwise empty.




get_own_user()
    

Get a handle to interact with the current user

Returns:
    

A `dataikuapi.govern.admin.GovernOwnUser` user handle

list_users_activity(_enabled_users_only =False_)
    

List all users activity

Note: this call requires an API key with admin rights

Returns:
    

A list of user activity logs, as a list of `dataikuapi.govern.admin.GovernUserActivity` if as_objects is True, else as a list of dict

Return type:
    

list of `dataikuapi.govern.admin.GovernUserActivity` or a list of dict

get_authorization_matrix()
    

Get the authorization matrix for all enabled users and groups

Note: this call requires an API key with admin rights

Returns:
    

The authorization matrix

Return type:
    

A `dataikuapi.govern.admin.GovernAuthorizationMatrix` authorization matrix handle

start_resync_users_from_supplier(_logins_)
    

Starts a resync of multiple users from an external supplier (LDAP, Azure AD or custom auth)

Parameters:
    

**logins** (_list_) – list of logins to resync

Returns:
    

a `dataikuapi.govern.future.GovernFuture` representing the sync process

Return type:
    

`dataikuapi.govern.future.GovernFuture`

start_resync_all_users_from_supplier()
    

Starts a resync of all users from an external supplier (LDAP, Azure AD or custom auth)

Returns:
    

a `dataikuapi.govern.future.GovernFuture` representing the sync process

Return type:
    

`dataikuapi.govern.future.GovernFuture`

start_fetch_external_groups(_user_source_type_)
    

Fetch groups from external source

Parameters:
    

**user_source_type** – ‘LDAP’, ‘AZURE_AD’ or ‘CUSTOM’

Return type:
    

`dataikuapi.govern.future.GovernFuture`

Returns:
    

a GovernFuture containing a list of group names

start_fetch_external_users(_user_source_type_ , _login =None_, _email =None_, _group_name =None_)
    

Fetch users from external source filtered by login or group name:
    

  * if login or email is provided, will search for a user with an exact match in the external source (e.g. before login remapping)

  * else,
    
    * if group_name is provided, will search for members of the group in the external source

    * else will search for all users




Parameters:
    

  * **user_source_type** – ‘LDAP’, ‘AZURE_AD’ or ‘CUSTOM’

  * **login** – optional - the login of the user in the external source

  * **email** – optional - the email of the user in the external source

  * **group_name** – optional - the group name of the group in the external source



Return type:
    

`dataikuapi.govern.future.GovernFuture`

Returns:
    

a GovernFuture containing a list of ExternalUser

start_provision_users(_user_source_type_ , _users_)
    

Provision users of given source type

Parameters:
    

  * **user_source_type** (_string_) – ‘LDAP’, ‘AZURE_AD’ or ‘CUSTOM’

  * **users** (_list_) – list of user attributes coming form the external source



Return type:
    

`dataikuapi.govern.future.GovernFuture`

list_groups()
    

List all groups setup on the Dataiku Govern instance

Note: this call requires an API key with admin rights

Returns:
    

A list of groups, as an list of dicts

Return type:
    

list of dicts

get_group(_name_)
    

Get a handle to interact with a specific group

Parameters:
    

**name** (_str_) – the name of the desired group

Returns:
    

A `dataikuapi.govern.admin.GovernGroup` group handle

create_group(_name_ , _description =None_, _source_type ='LOCAL'_)
    

Create a group, and return a handle to interact with it

Note: this call requires an API key with admin rights

Parameters:
    

  * **name** (_str_) – the name of the new group

  * **description** (_str_) – (optional) a description of the new group

  * **source_type** – the type of the new group. Admissible values are ‘LOCAL’ and ‘LDAP’



Returns:
    

A `dataikuapi.govern.admin.GovernGroup` group handle

list_global_api_keys(_as_type ='listitems'_)
    

List all global API keys set up on the Dataiku Govern instance

Note

This call requires an API key with admin rights

Note

If the secure API keys feature is enabled, the secret key of the listed API keys will not be present in the returned objects

Parameters:
    

**as_type** (_str_) – How to return the global API keys. Possible values are “listitems” and “objects”

Returns:
    

if as_type=listitems, each key as a `dataikuapi.govern.admin.GovernGlobalApiKeyListItem`. if as_type=objects, each key is returned as a `dataikuapi.govern.admin.GovernGlobalApiKey`.

get_global_api_key(_key_)
    

Get a handle to interact with a specific Global API key

Deprecated since version 13.0.0: Use `GovernClient.get_global_api_key_by_id()`. Calling this method with an invalid secret key will now result in an immediate error.

Parameters:
    

**key** (_str_) – the secret key of the API key

Returns:
    

A `dataikuapi.govern.admin.GovernGlobalApiKey` API key handle

get_global_api_key_by_id(_id__)
    

Get a handle to interact with a specific Global API key

Parameters:
    

**id** (_str_) – the id the API key

Returns:
    

A `dataikuapi.govern.admin.GovernGlobalApiKey` API key handle

create_global_api_key(_label =None_, _description =None_, _admin =False_)
    

Create a Global API key, and return a handle to interact with it

Use `GovernClient.create_global_api_key_with_groups()` to create global API keys that use groups to manage their permissions.

Note

This call requires an API key with admin rights

Note

The secret key of the created API key will always be present in the returned object, even if the secure API keys feature is enabled

Parameters:
    

  * **label** (_str_) – the label of the new API key

  * **description** (_str_) – the description of the new API key

  * **admin** (_boolean_) – has the new API key admin rights (True or False)



Returns:
    

A `dataikuapi.govern.admin.GovernGlobalApiKey` API key handle

create_global_api_key_with_groups(_label =None_, _description =None_, _groups =None_)
    

Create a Global API key, and return a handle to interact with it.

Note

This call requires an API key with admin rights

Note

The secret key of the created API key will always be present in the returned object, even if the secure API keys feature is enabled

Parameters:
    

  * **label** (_str_) – the label of the new API key

  * **description** (_str_) – the description of the new API key

  * **groups** (_list_) – the groups the new API key belongs to



Returns:
    

A `dataikuapi.govern.admin.GovernGlobalApiKey` API key handle

list_logs()
    

List all available log files on the Dataiku Govern instance This call requires an API key with admin rights

Returns:
    

A list of log file names

get_log(_name_)
    

Get the contents of a specific log file This call requires an API key with admin rights

Parameters:
    

**name** (_str_) – the name of the desired log file (obtained with `list_logs()`)

Returns:
    

The full content of the log file, as a string

log_custom_audit(_custom_type_ , _custom_params =None_)
    

Log a custom entry to the audit trail

Parameters:
    

  * **custom_type** (_str_) – value for customMsgType in audit trail item

  * **custom_params** (_dict_) – value for customMsgParams in audit trail item (defaults to {})




get_global_usage_summary()
    

Gets a summary of the global usage of this Dataiku Govern instance :returns: a summary object

get_general_settings()
    

Gets a handle to interact with the general settings.

This call requires an API key with admin rights

Returns:
    

a `dataikuapi.govern.admin.GovernGeneralSettings` handle

get_auth_info()
    

Returns various information about the user currently authenticated using this instance of the API client.

This method returns a dict that may contain the following keys (may also contain others):

  * authIdentifier: login for a user, id for an API key

  * groups: list of group names (if context is an user)




Returns:
    

a dict

Return type:
    

dict

get_instance_info()
    

Get global information about the Dataiku Govern instance

Returns:
    

a `GovernInstanceInfo`

get_licensing_status()
    

Returns a dictionary with information about licensing status of this Dataiku Govern instance

Return type:
    

dict

set_license(_license_)
    

Sets a new licence for Dataiku Govern

Parameters:
    

**license** – license (content of license file)

Returns:
    

None

get_sso_settings()
    

Get the Single Sign-On (SSO) settings

Returns:
    

SSO settings

Return type:
    

`dataikuapi.iam.settings.SSOSettings`

get_ldap_settings()
    

Get the LDAP settings

Returns:
    

LDAP settings

Return type:
    

`dataikuapi.iam.settings.LDAPSettings`

get_azure_ad_settings()
    

Get the Azure Active Directory (aka Microsoft Entra ID) settings

Returns:
    

Azure AD settings

Return type:
    

`dataikuapi.iam.settings.AzureADSettings`

get_blueprint_designer()
    

Return a handle to interact with the blueprint designer Note: this call requires an API key with Govern architect rights

Return type:
    

A `GovernAdminBlueprintDesigner`

get_roles_permissions_handler()
    

Return a handler to manage the roles and permissions of the Dataiku Govern instance Note: this call requires an API key with Govern architect rights

Return type:
    

A `GovernAdminRolesPermissionsHandler`

get_custom_pages_handler()
    

Return a handler to manage custom pages Note: this call requires an API key with Govern architect rights

Return type:
    

A `GovernAdminCustomPagesHandler`

list_blueprints()
    

List all the blueprints

Returns:
    

a list of blueprints

Return type:
    

list of `GovernBlueprintListItem`

get_blueprint(_blueprint_id_)
    

Get a handle to interact with a blueprint. If you want to edit it or one of its versions, use instead: `get_blueprint()`

Parameters:
    

**blueprint_id** (_str_) – id of the blueprint to retrieve

Returns:
    

The handle of the blueprint

Return type:
    

`GovernBlueprint`

get_artifact(_artifact_id_)
    

Return a handle to interact with an artifact.

Parameters:
    

**artifact_id** (_str_) – id of the artifact to retrieve

Returns:
    

the corresponding `GovernArtifact`

create_artifact(_artifact_)
    

Create an artifact

Parameters:
    

**artifact** (_dict_) – the definition of the artifact as a dict

Returns:
    

the created `GovernArtifact`

new_artifact_search_request(_artifact_search_query_)
    

Create a new artifact search request and return the object that will be used to launch the requests.

Parameters:
    

**artifact_search_query** (`GovernArtifactSearchQuery`) – The query that will be addressed during the search.

Returns:
    

The created artifact search request object

Return type:
    

`GovernArtifactSearchRequest`

get_custom_page(_custom_page_id_)
    

Retrieve a custom page. To edit a custom page use instead the custom page editor `get_custom_page()`

Parameters:
    

**custom_page_id** (_str_) – id of the custom page to retrieve

Returns:
    

the corresponding custom page object

Return type:
    

a `GovernCustomPage`

list_custom_pages()
    

List custom pages.

Returns:
    

a list of custom pages

Return type:
    

list of `GovernCustomPageListItem`

create_time_series(_datapoints =None_)
    

Create a new time series and push a list of values inside it.

Parameters:
    

**datapoints** (_list_) – (Optional) a list of Python dict - The list of datapoints as Python dict containing the following keys “timestamp” (an epoch in milliseconds), and “value” (an object)

Returns:
    

the created time-series object

Return type:
    

a `GovernTimeSeries`

get_time_series(_time_series_id_)
    

Return a handle to interact with the time series

Parameters:
    

**time_series_id** (_str_) – ID of the time series

Returns:
    

the corresponding time series object

Return type:
    

a `GovernTimeSeries`

get_uploaded_file(_uploaded_file_id_)
    

Return a handle to interact with an uploaded file

Parameters:
    

**uploaded_file_id** (_str_) – ID of the uploaded file

Returns:
    

the corresponding uploaded file object

Return type:
    

a `GovernUploadedFile`

upload_file(_file_name_ , _file_)
    

Upload a file on Dataiku Govern. Return a handle to interact with this new uploaded file.

Parameters:
    

  * **file_name** (_str_) – Name of the file

  * **file** (_stream_) – file contents, as a stream - file-like object



Returns:
    

the newly uploaded file object

Return type:
    

a `GovernUploadedFile`

_class _dataikuapi.govern.blueprint.GovernBlueprintListItem(_client_ , _data_)
    

An item in a list of blueprints. Do not create this directly, use `list_blueprints()`

get_raw()
    

Get the raw content of the blueprint list item

Returns:
    

the raw content of the blueprint list item as a dict

Return type:
    

dict

to_blueprint()
    

Gets the `GovernBlueprint` corresponding to this blueprint object

Returns:
    

the blueprint object

Return type:
    

a `GovernBlueprint`

_class _dataikuapi.govern.blueprint.GovernBlueprint(_client_ , _blueprint_id_)
    

A handle to read a blueprint on the Govern instance. If you wish to edit blueprints or the blueprint versions, use the blueprint designer object `GovernAdminBlueprintDesigner`. Do not create this directly, use `get_blueprint()`

get_definition()
    

Return the definition of the blueprint as an object.

Returns:
    

The blueprint definition as an object.

Return type:
    

`GovernBlueprintDefinition`

list_versions()
    

List versions of this blueprint.

Returns:
    

the list of blueprint versions

Return type:
    

list of `GovernBlueprintVersionListItem`

get_version(_version_id_)
    

Return a handle to interact with a blueprint version

Parameters:
    

**version_id** (_str_) – ID of the version

Return type:
    

`GovernBlueprintVersion`

_class _dataikuapi.govern.blueprint.GovernBlueprintDefinition(_client_ , _blueprint_id_ , _definition_)
    

The definition of a blueprint. Do not create this class directly, instead use `get_definition()`

get_raw()
    

Get raw definition of a blueprint

Returns:
    

The raw definition of blueprint, as a dict.

Return type:
    

dict

_class _dataikuapi.govern.blueprint.GovernBlueprintVersionListItem(_client_ , _blueprint_id_ , _data_)
    

An item in a list of blueprint versions. Do not create this directly, use `list_versions()`

get_raw()
    

Get the raw content of the blueprint version list item

Returns:
    

the raw content of the blueprint version list item as a dict

Return type:
    

dict

to_blueprint_version()
    

Gets the `GovernBlueprintVersion` corresponding to this blueprint version object

Returns:
    

the blueprint object

Return type:
    

a `GovernBlueprintVersion`

_class _dataikuapi.govern.blueprint.GovernBlueprintVersion(_client_ , _blueprint_id_ , _version_id_)
    

A handle to interact with a blueprint version on the Govern instance. Do not create this directly, use `get_version()`

get_blueprint()
    

Retrieve the blueprint handle of this blueprint version.

Returns:
    

the corresponding blueprint handle

Return type:
    

`GovernBlueprint`

get_trace()
    

Get the trace of this blueprint version (info about its status and origin blueprint version lineage).

Returns:
    

The trace of this blueprint version.

Return type:
    

`GovernBlueprintVersionTrace`

get_definition()
    

Get the definition of this blueprint version.

Returns:
    

The definition of the blueprint version as an object.

Return type:
    

`GovernBlueprintVersionDefinition`

_class _dataikuapi.govern.blueprint.GovernBlueprintVersionTrace(_client_ , _blueprint_id_ , _version_id_ , _trace_)
    

The trace of a blueprint version containing information about its lineage and its status. Do not create this directly, use `get_trace()`

get_raw()
    

Get raw trace of the blueprint version.

Returns:
    

The raw trace of blueprint version, as a dict.

Return type:
    

dict

_property _status
    

Get the status of the blueprint version among (DRAFT, ACTIVE, or ARCHIVED)

Return type:
    

str

_property _origin_version_id
    

Get the origin version ID of this blueprint version

Return type:
    

str

_class _dataikuapi.govern.blueprint.GovernBlueprintVersionDefinition(_client_ , _blueprint_id_ , _version_id_ , _definition_)
    

The definition of a blueprint version. Do not create this directly, use `get_definition()`

get_raw()
    

Get raw definition of the blueprint version.

Returns:
    

The raw definition of blueprint version, as a dict.

Return type:
    

dict

_class _dataikuapi.govern.artifact.GovernArtifact(_client_ , _artifact_id_)
    

A handle to interact with an artifact on the Govern instance. Do not create this directly, use `get_artifact()`

get_definition()
    

Retrieve the artifact definition and return it as an object.

Returns:
    

the corresponding artifact definition object

Return type:
    

`GovernArtifactDefinition`

list_signoffs()
    

List all the sign-offs from the different steps of the workflow for this current artifact.

Returns:
    

the list of sign-offs

Return type:
    

list of `GovernArtifactSignoffListItem`

get_signoff(_step_id_)
    

Get the sign-off for a specific step of the workflow for this current artifact.

Parameters:
    

**step_id** (_str_) – id of the step to retrieve the sign-off from

Returns:
    

the corresponding `GovernArtifactSignoff`

delete()
    

Delete the artifact

Returns:
    

None

create_signoff(_step_id_)
    

Create a sign-off for the given stepId. The step must be ongoing and must not hold an existing sign-off. Note: the sign-offs of all steps are created automatically when the artifact is created based on the blueprint version sign-off configurations; thus this call is useful when the configuration has been added after the creation of the artifact.

Returns:
    

the created `GovernArtifactSignoff`

_class _dataikuapi.govern.artifact.GovernArtifactDefinition(_client_ , _artifact_id_ , _definition_)
    

The definition of an artifact. Do not create this class directly, instead use `get_definition()`

get_blueprint_version()
    

Retrieve the blueprint version handle of this artifact

Returns:
    

the blueprint version handle

Return type:
    

`GovernBlueprintVersion`

get_raw()
    

Get the raw content of the artifact. This returns a reference to the artifact so changes made to the returned object will be reflected when saving.

Return type:
    

dict

save()
    

Save this settings back to the artifact.

_class _dataikuapi.govern.artifact.GovernArtifactSignoffListItem(_client_ , _artifact_id_ , _data_)
    

An item in a list of sign-offs. Do not create this directly, use `list_signoffs()`

get_raw()
    

Get the raw content of the sign-off list item

Returns:
    

the raw content of the sign-off list item as a dict

Return type:
    

dict

to_signoff()
    

Gets the `GovernArtifactSignoff` corresponding to this sign-off object

Returns:
    

the sign-off object

Return type:
    

a `GovernArtifactSignoff`

_class _dataikuapi.govern.artifact.GovernArtifactSignoff(_client_ , _artifact_id_ , _step_id_)
    

Handle to interact with the sign-off of a specific workflow step. Do not create this directly, use `get_signoff()`

get_definition()
    

Get the definition of the sign-off for this specific workflow step.

Returns:
    

the sign-off definition

Return type:
    

`GovernArtifactSignoffDefinition`

get_recurrence_configuration()
    

Get the recurrence configuration of the sign-off for this specific workflow step.

Returns:
    

the sign-off recurrence configuration

Return type:
    

`GovernArtifactSignoffRecurrenceConfiguration`

get_details()
    

Get the sign-off details for this specific workflow step. This contains a list of computed users included in feedback groups and in the approval.

Returns:
    

sign-off details

Return type:
    

`GovernArtifactSignoffDetails`

update_status(_signoff_status_ , _users_to_notify =None_, _reload_conf_for_reset =False_)
    

Change the status of the sign-off, takes as input the target status, optionally a list of users to notify and a boolean to indicate if the sign-off configuration should be updated from the blueprint version. Only the users included in the groups of feedback and approval are able to give feedback or approval and can be notified, the complete list is available using: `get_details()`. For the feedback, the users will be notified as part of a chosen group of feedback and the group must be specified.

Parameters:
    

  * **signoff_status** (_str_) – target feedback status to be chosen from: NOT_STARTED, WAITING_FOR_FEEDBACK, WAITING_FOR_APPROVAL, APPROVED, REJECTED, ABANDONED

  * **users_to_notify** (_list_ _of_ _dict_) – (Optional) List of the user to notify as part of the status change (WAITING_FOR_FEEDBACK will involve the feedback groups, WAITING_FOR_APPROVAL will involve the final approval). The list should be a list of dict containing two keys “userLogin” and “groupId” for each user to notify. The “groupId” key is mandatory for feedback notification and forbidden for the final approval notification. All users that are not in the sign-off configuration will be ignored.

  * **reload_conf_for_reset** (_boolean_) – (Optional, defaults to **False**) Usefull only when the target status is NOT_STARTED. If True the current sign-off configuration will be overwritten by the one coming from the blueprint version, all delegated users will be reset. If False the current sign-off configuration will remain the same, allowing all delegated users to be retained but any changes to the sign-off configuration in the blueprint version will not be reflected.



Returns:
    

None

list_feedbacks()
    

List all the feedbacks of this current sign-off.

Returns:
    

the list of feedbacks

Return type:
    

list of `GovernArtifactSignoffFeedbackListItem`

get_feedback(_feedback_id_)
    

Get a specific feedback review of this sign-off.

Parameters:
    

**feedback_id** (_str_) – ID of the feedback review to retrieve from the sign-off

Returns:
    

the corresponding `GovernArtifactSignoffFeedback`

add_feedback(_group_id_ , _feedback_status_ , _comment =None_)
    

Add a feedback review for a specific feedback group of the sign-off. Takes as input a group_id (the feedback group id), a feedback status and an optional comment.

Parameters:
    

  * **group_id** (_str_) – ID of the feedback group

  * **feedback_status** (_str_) – feedback status to be chosen from: APPROVED, MINOR_ISSUE, MAJOR_ISSUE

  * **comment** (_str_) – (Optional) feedback comment



Return type:
    

a `GovernArtifactSignoffFeedback`

delegate_feedback(_group_id_ , _users_container_)
    

Delegate the feedback to specific users for the sign-off. Takes as input a group_id (the feedback group that should have done the feedback originally), and an users container definition to delegate to.

Parameters:
    

  * **group_id** (_str_) – ID of the feedback group

  * **users_container** (_dict_) – a dict representing the users to delegate to. Use `build()` to build a users container definition for a single user.



Returns:
    

None

get_approval()
    

Get the current approval of this sign-off.

Returns:
    

the corresponding `GovernArtifactSignoffApproval`

add_approval(_approval_status_ , _comment =None_)
    

Add the final approval of the sign-off. Takes as input an approval status and an optional comment.

Parameters:
    

  * **approval_status** (_str_) – approval status to be chosen from: APPROVED, REJECTED, ABANDONED

  * **comment** (_str_) – (Optional) approval comment



Return type:
    

a `GovernArtifactSignoffApproval`

delegate_approval(_users_container_)
    

Delegate the approval to specific users of the sign-off. Takes as input an users container definition to delegate to.

Parameters:
    

**users_container** (_str_) – a dict representing the users to delegate to. Use `build()` to build a users container definition for a single user.

Returns:
    

None

_class _dataikuapi.govern.artifact.GovernArtifactSignoffDefinition(_client_ , _artifact_id_ , _step_id_ , _definition_)
    

The definition of a sign-off. Do not create this class directly, instead use `get_definition()`

get_raw()
    

Get the raw content of the sign-off definition.

Return type:
    

dict

_class _dataikuapi.govern.artifact.GovernArtifactSignoffRecurrenceConfiguration(_client_ , _artifact_id_ , _step_id_ , _recurrence_configuration_)
    

The recurrence configuration of a sign-off. Do not create this class directly, instead use `get_recurrence_configuration()`

get_raw()
    

Get the raw content of the sign-off recurrence configuration. This returns a reference that can be modified to be saved later. The returned dict can be empty if the recurrence configuration was not already configured.

Return type:
    

dict

save()
    

Save the recurrence configuration back to the sign-off. The recurrence configuration must have the following properties:

  * `activated` (boolean)

  * `days` (int)

  * `weeks` (int)

  * `months` (int)

  * `years` (int)

  * `reloadConf` (boolean)




Returns:
    

None

_class _dataikuapi.govern.artifact.GovernArtifactSignoffDetails(_client_ , _artifact_id_ , _step_id_ , _details_)
    

The details of a sign-off. Do not create this class directly, instead use `get_details()`

get_raw()
    

Get the raw content of the sign-off details.

Return type:
    

dict

_class _dataikuapi.govern.artifact.GovernArtifactSignoffFeedbackListItem(_client_ , _artifact_id_ , _step_id_ , _feedback_id_ , _data_)
    

An item in a list of feedback reviews. Do not create this directly, use `list_feedbacks()`

get_raw()
    

Get the raw content of the feedback review.

Return type:
    

dict

to_feedback()
    

Gets the `GovernArtifactSignoffFeedback` corresponding to this feedback object

Returns:
    

the feedback object

Return type:
    

a `GovernArtifactSignoffFeedback`

_class _dataikuapi.govern.artifact.GovernArtifactSignoffFeedback(_client_ , _artifact_id_ , _step_id_ , _feedback_id_)
    

Handle to interact with a feedback. Do not create this directly, use `get_feedback()`

get_definition()
    

Get the feedback definition.

Returns:
    

the feedback definition object

Return type:
    

a `GovernArtifactSignoffFeedbackDefinition`

delete()
    

Delete this feedback review

Returns:
    

None

_class _dataikuapi.govern.artifact.GovernArtifactSignoffFeedbackDefinition(_client_ , _artifact_id_ , _step_id_ , _feedback_id_ , _definition_)
    

The definition of a feedback review. Do not create this directly, use `get_definition()`

get_raw()
    

Get the raw content of the feedback definition. This returns a reference to the feedback so changes made to the status and comment properties will be reflected when saving.

Return type:
    

dict

save()
    

Save this feedback review back to the sign-off

Returns:
    

None

_class _dataikuapi.govern.artifact.GovernArtifactSignoffApproval(_client_ , _artifact_id_ , _step_id_)
    

Handle to interact with an approval. Do not create this directly, use `get_approval()`

get_definition()
    

Get the approval definition.

Returns:
    

the approval definition object

Return type:
    

a `GovernArtifactSignoffApprovalDefinition`

delete()
    

Delete this approval.

Returns:
    

None

_class _dataikuapi.govern.artifact.GovernArtifactSignoffApprovalDefinition(_client_ , _artifact_id_ , _step_id_ , _definition_)
    

The definition of an approval. Do not create this directly, use `get_definition()`

get_raw()
    

Get the raw content of the approval. This returns a reference to the approval so changes made to the status and comment properties will be reflected when saving.

Return type:
    

dict

save()
    

Save this approval back to the sign-off

Returns:
    

None

_class _dataikuapi.govern.uploaded_file.GovernUploadedFile(_client_ , _uploaded_file_id_)
    

A handle to interact with an uploaded file Do not create this directly, use `get_uploaded_file()`

get_description()
    

Get the description of the uploaded file.

Returns:
    

The description of the file as a python dict

Return type:
    

dict

download()
    

Download the uploaded file

Returns:
    

the uploaded file contents, as a stream - file-like object

Return type:
    

a stream - file-like object

delete()
    

Delete the file

Returns:
    

None

_class _dataikuapi.govern.time_series.GovernTimeSeries(_client_ , _time_series_id_)
    

A handle to interact with a time series. Do not create this directly, use `get_time_series()`

get_values(_min_timestamp =None_, _max_timestamp =None_)
    

Get the values of the time series. Use the parameters min_timestamp and max_timestamp to define a time window. Only values within this window will be returned

Parameters:
    

  * **min_timestamp** (_int_) – (Optional) The minimum timestamp of the time window as an epoch in milliseconds

  * **max_timestamp** (_int_) – (Optional) The maximum timestamp of the time window as an epoch in milliseconds



Returns:
    

a list data points of the time series as Python dict

Return type:
    

list of dict

push_values(_datapoints_ , _upsert =True_)
    

Push a list of values inside the time series.

Parameters:
    

  * **datapoints** (_list_) – a list of Python dict - The list of datapoints as Python dict containing the following keys “timestamp” (an epoch in milliseconds), and “value” (an object)

  * **upsert** (_boolean_) – (Optional) If set to false, values for existing timestamps will not be overridden. Default value is True.



Returns:
    

None

delete(_min_timestamp =None_, _max_timestamp =None_)
    

Delete the values of the time series. Use the parameters min_timestamp and max_timestamp to define a time window. Only values within this window will be deleted.

Parameters:
    

  * **min_timestamp** (_int_) – (Optional) The minimum timestamp of the time window as an epoch in milliseconds

  * **max_timestamp** (_int_) – (Optional) The maximum timestamp of the time window as an epoch in milliseconds



Returns:
    

None

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchRequest(_client_ , _artifact_search_query_)
    

A search request object. Do not create this directly, use `new_artifact_search_request()` and then run the query using `fetch_next_batch()`

fetch_next_batch(_page_size =20_)
    

Run the search request fetching the next batch of results. Use page_size to specify the size of the result page.

Parameters:
    

**page_size** (_int_) – (Optional) size of the result page, default value is set to 20.

Returns:
    

The response of a single fetch of the search request

Return type:
    

a `GovernArtifactSearchResponse`

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchResponse(_client_ , _response_)
    

A search request response for a single batch. Do not create this directly, use `fetch_next_batch()`.

get_raw()
    

Get the raw content of the search response

Returns:
    

the raw content of the search response as a dict

Return type:
    

dict

get_response_hits()
    

Get the search response hits (artifacts)

Returns:
    

list of the search response hits (artifacts)

Return type:
    

list of `GovernArtifactSearchResponseHit`

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchResponseHit(_client_ , _hit_)
    

A search request response. Do not create this directly, use `get_response_hits()`.

get_raw()
    

Get the raw content of the search response hit

Returns:
    

the raw content of the search response hit as a dict

Return type:
    

dict

to_artifact()
    

Gets the `GovernArtifact` corresponding to this search response hit

Returns:
    

the custom page object

Return type:
    

a `GovernArtifact`

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchQuery(_artifact_search_source =None_, _artifact_filters =None_, _artifact_search_sort =None_)
    

A definition of an artifact query. Instantiate and interact with this object to customize the query.

Parameters:
    

  * **artifact_search_source** (`GovernArtifactSearchSource`) – (Optional) The search source to target a subset of artifacts. For now, by default, the search will be executed on all artifacts using the `GovernArtifactSearchSourceAll` search source.

  * **artifact_filters** (list of `GovernArtifactFilter`) – A list of filters to apply on the query.

  * **artifact_search_sort** (`GovernArtifactSearchSort`) – The sort configuration to apply on the query




set_artifact_search_source(_artifact_search_source_)
    

Set a search source for this query

Parameters:
    

**artifact_search_source** (`GovernArtifactSearchSource`) – (Optional) The search source to target a subset of artifacts. For now, by default, the search will be executed on all artifacts using the `GovernArtifactSearchSourceAll` search source.

Returns:
    

None

clear_artifact_filters()
    

Remove the filters set for this query

Returns:
    

None

add_artifact_filter(_artifact_filter_)
    

Add a new artifact filter to the filter list of the query.

Parameters:
    

**artifact_filter** (`GovernArtifactFilter`) – A filter to add to the filter list.

Returns:
    

None

clear_artifact_search_sort()
    

Remove the sort configuration of this query.

Returns:
    

None

set_artifact_search_sort(_artifact_search_sort_)
    

Set a new search sort configuration for this request.

Parameters:
    

**artifact_search_sort** (`GovernArtifactSearchSort`) – The sort configuration to apply on the query

Returns:
    

None

build()
    

Returns:
    

the search query definition

Return type:
    

(dict, dict)

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchSource(_search_source_type_)
    

An abstract class to represent the different search source. Do not instantiate this class but one of its subclasses.

build()
    

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchSourceAll
    

A generic search source definition.

build()
    

Returns:
    

the search source definition as a dict

Return type:
    

dict

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchSort(_artifact_search_sort_type_ , _direction_)
    

An abstract class to represent the different search sort. Do not instantiate this class but one of its subclasses.

build()
    

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchSortName(_direction ='ASC'_)
    

An artifact sort definition based on their names.

Parameters:
    

**direction** (_str_) – (Optional) The direction on which the artifacts will be sorted. Can be either “ASC” or “DESC”

build()
    

Returns:
    

the search sort definition as a dict

Return type:
    

dict

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchSortWorkflow(_direction ='ASC'_)
    

An artifact sort defintion based on their workflow.

Parameters:
    

**direction** (_str_) – (Optional) The direction on which the artifacts will be sorted. Can be either “ASC” or “DESC”

build()
    

Returns:
    

the search sort definition as a dict

Return type:
    

dict

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchSortField(_fields =None_, _direction ='ASC'_)
    

An artifact sort definition based on a list of fields.

Parameters:
    

  * **fields** (_list_ _of_ _dict_) – (Optional) A list of fields on which the artifacts will be sorted. Use `build()` to build a field based sort definition.

  * **direction** (_str_) – (Optional) The direction on which the artifacts will be sorted. Can be either “ASC” or “DESC”




build()
    

Returns:
    

the search sort definition as a dict

Return type:
    

dict

_class _dataikuapi.govern.artifact_search.GovernArtifactSearchSortFieldDefinition(_blueprint_id_ , _field_id_)
    

A field sort definition builder to use in a search query in order to sort on a field of a blueprint.

Parameters:
    

  * **blueprint_id** (_str_) – the Blueprint ID

  * **field_id** (_str_) – the field ID




build()
    

Returns:
    

the field search sort definition

Return type:
    

dict

_class _dataikuapi.govern.artifact_search.GovernArtifactFilter(_filter_type_)
    

An abstract class to represent artifact filters. Do not instance this class but one of its subclasses.

build()
    

_class _dataikuapi.govern.artifact_search.GovernArtifactFilterBlueprints(_blueprint_ids =None_)
    

An artifact filter definition based on a list of specific blueprints.

Parameters:
    

  * **blueprint_ids** – (Optional) the list of blueprint IDs to use to filter the artifacts

  * **blueprint_ids** – lsit of str




build()
    

Returns:
    

the artifact filter definition as a dict

Return type:
    

dict

_class _dataikuapi.govern.artifact_search.GovernArtifactFilterBlueprintVersions(_blueprint_version_ids =None_)
    

An artifact filter definition based on a list of specific blueprint versions.

Parameters:
    

**blueprint_version_ids** (_list_ _of_ _dict_) – (Optional) the list of blueprint version IDs to use to filter the artifacts. A blueprint version ID definition is a dict composed of the blueprint ID and the version ID like the following dict: {“blueprintId”: “bp.my_blueprint”, “versionId”: “bv.my_version”}. You can use `build()` to build a blueprint version ID definition directly. At the end, the blueprint_version_ids parameter expects a value looking like this: [{“blueprintId”: “bp.my_blueprint”, “versionId”: “bv.my_version”}, {“blueprintId”: “bp.my_blueprint”, “versionId”: “bv.my_version2”}.

build()
    

Returns:
    

the artifact filter definition as a dict

Return type:
    

dict

_class _dataikuapi.govern.artifact_search.GovernArtifactFilterArtifacts(_artifact_ids =None_)
    

An artifact filter definition based on a list of specific artifacts.

Parameters:
    

**artifact_ids** (_list_ _of_ _str_) – (Optional) the list of artifacts IDs to use to filter the artifacts.

build()
    

Returns:
    

the artifact filter definition as a dict

Return type:
    

dict

_class _dataikuapi.govern.artifact_search.GovernArtifactFilterFieldValue(_condition_type_ , _condition =None_, _field_id =None_, _negate_condition =None_, _case_sensitive =None_)
    

An artifact filter definition based on specific fields value.

Parameters:
    

  * **condition_type** (_str_) – the condition type of the filter. Has to be chosen from EQUALS, CONTAINS, START_WITH, END_WITH.

  * **condition** (_str_) – (Optional) The value on which the condition will be applied.

  * **field_id** (_str_) – (Optional) The ID of the field on which the condition will be applied. If not specified the filter will apply on the name.

  * **negate_condition** (_boolean_) – (Optional) A boolean to negate the condition. By default, the condition is not negated.

  * **case_sensitive** (_str_) – (Optional) Can be used to activate case-sensitive filtering. By default, filters will not be case-sensitive.




build()
    

Returns:
    

the artifact filter definition as a dict

Return type:
    

dict

_class _dataikuapi.govern.artifact_search.GovernArtifactFilterArchivedStatus(_is_archived_)
    

An artifact filter definition based on the archived status.

Parameters:
    

**is_archived** (_boolean_) – the value for filtering. If is_archived is set to True, all artifacts including archived ones will be part of the search result

build()
    

Returns:
    

the artifact filter definition as a dict

Return type:
    

dict

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintDesigner(_client_)
    

Handle to interact with the blueprint designer Do not create this directly, use `get_blueprint_designer()`

list_blueprints()
    

List blueprints

Returns:
    

the list of blueprints

Return type:
    

list of `GovernAdminBlueprintListItem`

get_blueprint(_blueprint_id_)
    

Get a specific blueprint.

Parameters:
    

**blueprint_id** (_str_) – the ID of the blueprint

Returns:
    

a blueprint object

Return type:
    

`GovernAdminBlueprint`

create_blueprint(_new_identifier_ , _blueprint_)
    

Create a new blueprint and returns a handle to interact with it.

Parameters:
    

  * **new_identifier** (_str_) – the new identifier for the blueprint. Allowed characters are letters, digits, hyphen, and underscore.

  * **blueprint** (_dict_) – the blueprint definition



Returns:
    

The handle for the newly created blueprint

Return type:
    

`GovernAdminBlueprint`

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintListItem(_client_ , _data_)
    

An item in a list of blueprints. Do not create this directly, use `list_blueprints()`

get_raw()
    

Get the raw content of the blueprint list item

Returns:
    

the raw content of the blueprint list item as a dict

Return type:
    

dict

to_blueprint()
    

Gets the `GovernAdminBlueprint` corresponding to this blueprint object

Returns:
    

the blueprint object

Return type:
    

a `GovernAdminBlueprint`

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprint(_client_ , _blueprint_id_)
    

A handle to interact with a blueprint as an admin on the Govern instance. Do not create this directly, use `get_blueprint()`

get_definition()
    

Get the definition of the blueprint as an object. To modify the definition, call `save()` on the returned object.

Returns:
    

The blueprint definition as an object.

Return type:
    

`GovernAdminBlueprintDefinition`

list_versions()
    

List versions of this blueprint.

Returns:
    

The list of the versions of the blueprint

Return type:
    

list of `GovernAdminBlueprintVersionListItem`

create_version(_new_identifier_ , _name =None_, _origin_version_id =None_)
    

Create a new blueprint version and returns a handle to interact with it.

Parameters:
    

  * **new_identifier** (_str_) – The new identifier of the blueprint version. Allowed characters are letters, digits, hyphen, and underscore.

  * **name** (_str_) – (Optional) The name of the blueprint version.

  * **origin_version_id** (_str_) – (Optional) The blueprint version ID of the origin version ID if there is one.



Returns:
    

The handle of the newly created blueprint

Return type:
    

`GovernAdminBlueprintVersion`

get_version(_version_id_)
    

Get a blueprint version and return a handle to interact with it.

Parameters:
    

**version_id** (_str_) – ID of the version

Return type:
    

`GovernAdminBlueprintVersion`

delete()
    

Delete the blueprint. To delete a blueprint, all related blueprint versions and artifacts must be deleted beforehand.

Returns:
    

None

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintDefinition(_client_ , _blueprint_id_ , _definition_)
    

The definition of a blueprint. Do not create this class directly, instead use `get_definition()`

get_raw()
    

Get raw definition of the blueprint

Returns:
    

the raw definition of blueprint, as a dict. Modifications made to the returned object are reflected when saving

Return type:
    

dict

save()
    

Save this settings back to the blueprint.

Returns:
    

None

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionListItem(_client_ , _blueprint_id_ , _data_)
    

An item in a list of blueprint versions. Do not create this directly, use `list_versions()`

get_raw()
    

Get the raw content of the blueprint version list item

Returns:
    

the raw content of the blueprint version list item as a dict

Return type:
    

dict

to_blueprint_version()
    

Gets the `GovernAdminBlueprintVersion` corresponding to this blueprint version object

Returns:
    

the blueprint object

Return type:
    

a `GovernAdminBlueprintVersion`

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersion(_client_ , _blueprint_id_ , _version_id_)
    

A handle to interact with a blueprint version. Do not create this directly, use `get_version()`

get_definition()
    

Get the definition of this blueprint version. To modify the definition, call `save()` on the returned object.

Returns:
    

The definition of the blueprint version as an object.

Return type:
    

`GovernAdminBlueprintVersionDefinition`.

get_trace()
    

Get a handle of the blueprint version trace containing information about its lineage and its status.

Returns:
    

the trace of the blueprint version.

Return type:
    

`GovernAdminBlueprintVersionTrace`.

list_signoff_configurations()
    

Get the blueprint sign-off configurations of this blueprint version.

Returns:
    

The list of sign-off configurations

Return type:
    

list of `GovernAdminSignoffConfigurationListItem`

get_signoff_configuration(_step_id_)
    

Get the sign-off configurations for a specific step

Parameters:
    

**step_id** (_str_) – The step ID of the sign-off

Returns:
    

The sign-off configuration as an object

Return type:
    

a `GovernAdminSignoffConfiguration`

create_signoff_configuration(_step_id_ , _signoff_configuration_)
    

Create a new sign-off for a specific step of the workflow and return a handle to interact with it.

Parameters:
    

  * **step_id** (_str_) – The step ID of the workflow on which the sign-off will be added.

  * **signoff_configuration** (_dict_) – The configuration of the sign-off



Returns:
    

The newly created sign-off configuration as an object

Return type:
    

`GovernAdminSignoffConfiguration`

delete()
    

Delete the blueprint version. To delete a blueprint, all related artifacts must be deleted beforehand.

Returns:
    

None

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionDefinition(_client_ , _blueprint_id_ , _version_id_ , _definition_)
    

The blueprint version definition. Do not create this directly, use `get_definition()`

get_raw()
    

Get raw definition of the blueprint version.

Returns:
    

the raw definition of blueprint version, as a dict. Modifications made to the returned object are reflected when saving

Return type:
    

dict

save(_danger_zone_accepted =None_)
    

Save this definition back to the blueprint version definition.

Parameters:
    

**danger_zone_accepted** (_boolean_) – ignore the warning about existing artifacts. If there are existing artifacts using this blueprint version, modifying it may break them (ie. removing artifact field values). By default, the save call will fail in this case. If this parameter is set to true, the call will ignore the warning and be run anyway.

Returns:
    

None

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminBlueprintVersionTrace(_client_ , _blueprint_id_ , _version_id_ , _trace_)
    

The trace of a blueprint version containing information about its lineage and its status. Do not create this directly, use `get_trace()`

get_raw()
    

Get raw trace of the blueprint version.

Returns:
    

The raw trace of blueprint version, as a dict.

Return type:
    

dict

_property _status
    

Get the status of the blueprint version among (DRAFT, ACTIVE, or ARCHIVED)

Return type:
    

str

_property _origin_version_id
    

Get the origin version ID of this blueprint version

Return type:
    

str

set_status(_status_)
    

Directly update the status of the blueprint version.

Parameters:
    

**status** (_str_) – DRAFT, ACTIVE, or ARCHIVED

Returns:
    

None

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfigurationListItem(_client_ , _blueprint_id_ , _version_id_ , _data_)
    

An item in a list of sign-off configurations. Do not create this directly, use `list_signoff_configurations()`

get_raw()
    

Get the raw content of the sign-off configuration list item

Returns:
    

the raw content of the sign-off configuration list item as a dict

Return type:
    

dict

to_signoff_configuration()
    

Gets the `GovernAdminSignoffConfiguration` corresponding to this sign-off configuration object

Returns:
    

the sign-off configuration object

Return type:
    

a `GovernAdminSignoffConfiguration`

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfiguration(_client_ , _blueprint_id_ , _version_id_ , _step_id_)
    

A handle to interact with the sign-off configuration of a specific step of a workflow. Do not create this directly, use `get_signoff_configuration()`

get_definition()
    

Get the definition of the configuration, to modify the configuration call `save()` on the returned object.

Returns:
    

The blueprint definition as an object.

Return type:
    

`GovernAdminSignoffConfigurationDefinition`

delete()
    

Delete the sign-off configuration.

Returns:
    

None

_class _dataikuapi.govern.admin_blueprint_designer.GovernAdminSignoffConfigurationDefinition(_client_ , _blueprint_id_ , _version_id_ , _step_id_ , _definition_)
    

The definition of sign-off configuration. Do not create this class directly, instead use `get_definition()`

get_raw()
    

Get raw definition of the sign-off configuration

Returns:
    

the raw configuration of the sign-off, as a dict. Modifications made to the returned object are reflected when saving

Return type:
    

dict

save()
    

Save this settings back to the sign-off configuration.

Returns:
    

None

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRolesPermissionsHandler(_client_)
    

Handle to edit the roles and permissions Do not create this directly, use `get_roles_permissions_handler()`

list_roles()
    

List roles

Returns:
    

a list of roles

Return type:
    

list of `GovernAdminRoleListItem`

get_role(_role_id_)
    

Return a specific role on the Govern instance

Parameters:
    

**role_id** (_str_) – Identifier of the role

Return type:
    

`GovernAdminRole`

create_role(_new_identifier_ , _role_)
    

Create a new role and returns the handle to interact with it.

Parameters:
    

  * **new_identifier** (_str_) – Identifier of the new role. Allowed characters are letters, digits, hyphen, and underscore.

  * **role** (_dict_) – The definition of the role.



Return type:
    

`GovernAdminRole`

list_role_assignments()
    

List the blueprint role assignments

Returns:
    

A list of role assignments for each blueprint

Return type:
    

list of `GovernAdminBlueprintRoleAssignmentsListItem`

get_role_assignments(_blueprint_id_)
    

Get the role assignments for a specific blueprint. Returns a handle to interact with it.

Parameters:
    

**blueprint_id** (_str_) – id of the blueprint

Returns:
    

A object representing the role assignments for this blueprint

Return type:
    

`GovernAdminBlueprintRoleAssignments`

create_role_assignments(_role_assignments_)
    

Create a role assignments on the Govern instance and returns the handle to interact with it.

Parameters:
    

**role_assignment** (_dict_) – Blueprint permission as a dict

Returns:
    

The newly created role assignment.

Return type:
    

`GovernAdminBlueprintRoleAssignments`

get_default_permissions_definition()
    

Get the default permissions definition.

Returns:
    

A permissions object

Return type:
    

`GovernAdminDefaultPermissionsDefinition`

list_blueprint_permissions()
    

List blueprint permissions

Returns:
    

A list of blueprint permissions

Return type:
    

list of `GovernAdminBlueprintPermissionsListItem`

get_blueprint_permissions(_blueprint_id_)
    

Get the permissions for a specific blueprint. Returns a handle to interact with the permissions

Parameters:
    

**blueprint_id** (_str_) – id of the blueprint for which you need the permissions

Returns:
    

A permissions object for the specific blueprint

Return type:
    

`GovernAdminBlueprintPermissions`

create_blueprint_permissions(_blueprint_permission_)
    

Create blueprint permissions and returns the handle to interact with it.

Parameters:
    

**blueprint_permission** (_dict_) – Blueprint permission as a dict

Returns:
    

the newly created permissions object

Return type:
    

`GovernAdminBlueprintPermissions`

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRoleListItem(_client_ , _data_)
    

An item in a list of roles. Do not create this directly, use `list_roles()`

get_raw()
    

Get the raw content of the role list item

Returns:
    

the raw content of the role list item as a dict

Return type:
    

dict

to_role()
    

Gets the `GovernAdminRole` corresponding to this role object

Returns:
    

the role object

Return type:
    

a `GovernAdminRole`

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRole(_client_ , _role_id_)
    

A handle to interact with the roles of the instance as an admin. Do not create this directly, use `get_role()`

get_definition()
    

Return the information of the role as an object

Returns:
    

the information of the role.

Return type:
    

`GovernAdminRoleDefinition`

delete()
    

Delete the role

Returns:
    

None

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminRoleDefinition(_client_ , _role_id_ , _definition_)
    

The definition of a specific role. Do not create this directly, use `get_definition()`

get_raw()
    

Get raw information of the role.

Returns:
    

the raw definition of role, as a dict. Modifications made to the returned object are reflected when saving

Return type:
    

dict

save()
    

Save this information back to the role

Returns:
    

None

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignmentsListItem(_client_ , _data_)
    

An item in a list of blueprint role assignments. Do not create this directly, use `list_role_assignments()`

get_raw()
    

Get the raw content of the blueprint role assignments list item

Returns:
    

the raw content of the blueprint role assignments list item as a dict

Return type:
    

dict

to_blueprint_role_assignments()
    

Gets the `GovernAdminBlueprintRoleAssignments` corresponding to this blueprint role assignments object

Returns:
    

the blueprint role assignments object

Return type:
    

a `GovernAdminBlueprintRoleAssignments`

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignments(_client_ , _blueprint_id_)
    

A handle to interact with the blueprint role assignments for a specific blueprint Do not create this directly, use `get_role_assignments()`

get_definition()
    

Get the role assignments definition. Returns a handle to interact with it.

Returns:
    

The role assignments for a specific blueprint.

Return type:
    

`GovernAdminBlueprintRoleAssignments`

delete()
    

Delete the role assignments for a specific blueprint.

Returns:
    

None

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintRoleAssignmentsDefinition(_client_ , _blueprint_id_ , _definition_)
    

The role assignments for a specific blueprint. Do not create this class directly, instead use `get_definition()`

get_raw()
    

Get the raw content definition of the assignments for this blueprint. This returns a reference to the raw assignments, not a copy, so changes made to the returned object will be reflected when saving.

Return type:
    

dict

save()
    

Save this role assignments.

Returns:
    

None

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissionsListItem(_client_ , _data_)
    

An item in a list of blueprint permissions. Do not create this directly, use `list_blueprint_permissions()`

get_raw()
    

Get the raw content of the blueprint permissions list item

Returns:
    

the raw content of the blueprint permissions list item as a dict

Return type:
    

dict

to_blueprint_permissions()
    

Gets the `GovernAdminBlueprintPermissions` corresponding to this blueprint permissions object

Returns:
    

the blueprint permissions object

Return type:
    

a `GovernAdminBlueprintPermissions`

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissions(_client_ , _blueprint_id_)
    

A handle to interact with blueprint permissions for a specific blueprint Do not create this directly, use `get_blueprint_permissions()`

get_definition()
    

Get the blueprint permissions definition. Returns a handle to interact with it.

Returns:
    

The permissions definition for a specific blueprint.

Return type:
    

`GovernAdminBlueprintPermissionsDefinition`

delete()
    

Delete the permissions for this blueprint and use default permissions instead.

Returns:
    

None

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminBlueprintPermissionsDefinition(_client_ , _blueprint_id_ , _definition_)
    

The permissions for a specific blueprint. Do not create this class directly, instead use `get_definition()`

get_raw()
    

Get the raw content of the permissions for this blueprint. This returns a reference to the raw permissions, not a copy, so changes made to the returned object will be reflected when saving.

Return type:
    

dict

save()
    

Save this permission back to the blueprint permission definition.

Returns:
    

None

_class _dataikuapi.govern.admin_roles_permissions_handler.GovernAdminDefaultPermissionsDefinition(_client_ , _definition_)
    

The default permissions of the instance Do not create this directly, use `get_default_permissions_definition()`

get_raw()
    

Get the raw content of the default permissions. This returns a reference to the raw permissions, not a copy, so changes made to the returned object will be reflected when saving.

Return type:
    

dict

save()
    

Save the default permissions

Returns:
    

None

_class _dataikuapi.govern.admin.GovernUser(_client_ , _login_)
    

A handle for a user on the Dataiku Govern instance.

Important

Do not instantiate directly, use `dataikuapi.GovernClient.get_user()` instead.

delete(_allow_self_deletion =False_)
    

Deletes the user

:param bool allow_self_deletionAllow the use of this function to delete your own user.
    

Warning: this is very dangerous and used in a loop could lead to the deletion of all users/admins.

get_settings()
    

Get the settings of the user. You must be admin to call this method.

You must use `save()` on the returned object to make your changes effective on the user.

Usage example
    
    
    # disable some user
    user = client.get_user('the_user_login')
    settings = user.get_settings()
    settings.enabled = False
    settings.save()
    

Returns:
    

the settings of the user

Return type:
    

`GovernUserSettings`

get_activity()
    

Gets the activity of the user. You must be admin to call this method.

Returns:
    

the user’s activity

Return type:
    

`GovernUserActivity`

get_info()
    

Gets basic information about the user. You do not need to be admin to call this method

Return type:
    

`GovernUserInfo`

start_resync_from_supplier()
    

Starts a resync of the user from an external supplier (LDAP, Azure AD or custom auth)

Returns:
    

a `dataikuapi.govern.future.GovernFuture` representing the sync process

Return type:
    

`dataikuapi.govern.future.GovernFuture`

get_definition()
    

Get the definition of the user

Caution

Deprecated, use `get_settings()` instead

Returns:
    

the user’s definition, as a dict. Notable fields are

  * **login** : identifier of the user, can’t be modified

  * **enabled** : whether the user can log into Dataiku Govern

  * **groups** : list of group names this user belongs to




Return type:
    

dict

set_definition(_definition_)
    

Set the user’s definition.

Caution

Deprecated, use `dataikuapi.govern.admin.GovernUserSettings.save()` instead

Important

You should only use `set_definition()` with an object that you obtained through `get_definition()`, not create a new dict.

Note

This call requires an API key with admin rights

The fields that may be changed in a user definition are:

>   * email
> 
>   * displayName
> 
>   * enabled
> 
>   * groups
> 
>   * userProfile
> 
>   * password (not returned by `get_definition()` but can be set)
> 
>   * userProperties
> 
>   * adminProperties
> 
> 


Parameters:
    

**definition** (_dict_) – the definition for the user, as a dict

get_client_as()
    

Get an API client that has the permissions of this user.

This allows administrators to impersonate actions on behalf of other users, in order to perform actions on their behalf.

Returns:
    

a client through which calls will be run as the user

Return type:
    

`dataikuapi.GovernClient`

_class _dataikuapi.govern.admin.GovernUserSettings(_client_ , _login_ , _settings_)
    

Settings for a Dataiku Govern user.

Important

Do not instantiate directly, use `GovernUser.get_settings()` instead.

_property _admin_properties
    

Get the admin properties for this user.

Important

Do not set this property, modify the dict in place

Admin properties can be seen and modified only by administrators, not by the user themselves.

Return type:
    

dict

_property _enabled
    

Whether this user is enabled.

Return type:
    

boolean

_property _creation_date
    

Get the timestamp of when the user was created

Returns:
    

the creation date

Return type:
    

`datetime.datetime` or None

save()
    

Saves the settings

Note: this call is not available to Dataiku Cloud users

get_raw()
    

Get the raw settings of the user.

Modifications made to the returned object are reflected when saving.

Returns:
    

the dict of the settings (not a copy). Notable fields are:

  * **login** : identifier of the user, can’t be modified

  * **enabled** : whether the user can log into Dataiku Govern

  * **groups** : list of group names this user belongs to




Return type:
    

dict

_property _user_properties
    

Get the user properties for this user.

Important

Do not set this property, modify the dict in place

User properties can be seen and modified by the user themselves. A contrario admin properties are for administrators’ eyes only.

Return type:
    

dict

_class _dataikuapi.govern.admin.GovernOwnUser(_client_)
    

A handle to interact with your own user

Important

Do not instantiate directly, use `dataikuapi.GovernClient.get_own_user()` instead.

get_settings()
    

Get your own settings

You must use `save()` on the returned object to make your changes effective on the user.

Return type:
    

`GovernOwnUserSettings`

_class _dataikuapi.govern.admin.GovernOwnUserSettings(_client_ , _settings_)
    

Settings for the current Dataiku Govern user.

Important

Do not instantiate directly, use `GovernOwnUser.get_settings()` instead.

save()
    

Saves the settings

get_raw()
    

Get the raw settings of the user.

Modifications made to the returned object are reflected when saving.

Returns:
    

the dict of the settings (not a copy). Notable fields are:

  * **login** : identifier of the user, can’t be modified

  * **enabled** : whether the user can log into Dataiku Govern

  * **groups** : list of group names this user belongs to




Return type:
    

dict

_property _user_properties
    

Get the user properties for this user.

Important

Do not set this property, modify the dict in place

User properties can be seen and modified by the user themselves. A contrario admin properties are for administrators’ eyes only.

Return type:
    

dict

_class _dataikuapi.govern.admin.GovernGroup(_client_ , _name_)
    

A group on the Dataiku Govern instance.

Important

Do not instantiate directly, use `dataikuapi.GovernClient.get_group()` instead.

delete()
    

Deletes the group

get_definition()
    

Get the group’s definition (name, description, admin abilities, type, ldap name mapping)

Returns:
    

the group’s definition. Top-level fields are:

  * **name** : name of the group

  * **sourceType** : type of group. Possible values: LOCAL, LDAP




Return type:
    

dict

set_definition(_definition_)
    

Set the group’s definition.

Important

You should only use `set_definition()` with an object that you obtained through `get_definition()`, not create a new dict.

Parameters:
    

**definition** (_dict_) – the definition for the group, as a dict

_class _dataikuapi.govern.admin.GovernGeneralSettings(_client_)
    

The general settings of the Dataiku Govern instance.

Important

Do not instantiate directly, use `dataikuapi.GovernClient.get_general_settings()` instead.

save()
    

Save the changes that were made to the settings on the Dataiku Govern instance

Note

This call requires an API key with admin rights

get_raw()
    

Get the settings as a dictionary

Returns:
    

the settings

Return type:
    

dict

_class _dataikuapi.govern.admin.GovernGlobalApiKey(_client_ , _key_ , _id__)
    

A global API key on the Dataiku Govern instance

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
    

:class:GovernGlobalApiKeyDefinition

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

_class _dataikuapi.govern.custom_page.GovernCustomPageListItem(_client_ , _data_)
    

An item in a list of custom pages. Do not create this directly, use `list_custom_pages()`

get_raw()
    

Get the raw content of the custom page list item

Returns:
    

the raw content of the custom page list item as a dict

Return type:
    

dict

to_custom_page()
    

Gets the `GovernCustomPage` corresponding to this custom page object

Returns:
    

the custom page object

Return type:
    

a `GovernCustomPage`

_class _dataikuapi.govern.custom_page.GovernCustomPage(_client_ , _custom_page_id_)
    

A handle to interact with a custom page. Do not create this directly, use `get_custom_page()`

get_definition()
    

Get the definition of the custom page.

Returns:
    

the corresponding custom page definition object

Return type:
    

a `GovernCustomPageDefinition`

_class _dataikuapi.govern.custom_page.GovernCustomPageDefinition(_client_ , _custom_page_id_ , _definition_)
    

The definition of a custom page. Do not create this directly, use `get_definition()`

get_raw()
    

Returns:
    

the raw content of the custom page as a dict

Return type:
    

dict

_class _dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPagesHandler(_client_)
    

Handle to edit the custom pages Do not create this directly, use `get_custom_pages_handler()`

list_custom_pages()
    

List custom pages

Returns:
    

A list of custom pages

Return type:
    

list of `GovernAdminCustomPageListItem`

get_custom_page(_custom_page_id_)
    

Get a custom page

Parameters:
    

**custom_page_id** (_str_) – ID of the custom page to retrieve

Returns:
    

A custom page as an object

Return type:
    

`GovernAdminCustomPage`

create_custom_page(_new_identifier_ , _custom_page_)
    

Create a custom page

Parameters:
    

  * **new_identifier** (_str_) – the new identifier for this custom page. Allowed characters are letters, digits, hyphen, and underscore.

  * **custom_page** (_dict_) – the custom page definition.



Returns:
    

the handle of the created custom page

Return type:
    

`GovernAdminCustomPage`

get_custom_pages_order()
    

Retrieves the order of display of the custom pages by their id

Returns:
    

the order of the pages

Return type:
    

list[string]

save_custom_pages_order(_custom_pages_order_)
    

Update the order of display of the custom pages.

Parameters:
    

**custom_pages_order** – list[string] new custom pages order. Must contain ids of all the custom pages

Returns:
    

updated custom pages order

Return type:
    

list[string]

_class _dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPageListItem(_client_ , _data_)
    

An item in a list of custom pages. Do not create this directly, use `list_custom_pages()`

get_raw()
    

Get the raw content of the custom page list item

Returns:
    

the raw content of the custom page list item as a dict

Return type:
    

dict

to_custom_page()
    

Gets the `GovernAdminCustomPage` corresponding to this custom page object

Returns:
    

the custom page object

Return type:
    

a `GovernAdminCustomPage`

_class _dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPage(_client_ , _custom_page_id_)
    

A handle to interact with a custom page as an administrator. Do not create this directly, use `get_custom_page()`

get_definition()
    

Get the definition of the custom page, to modify the definition call `save()` on the returned object.

Returns:
    

A custom page definition as an object

Return type:
    

`GovernAdminCustomPageDefinition`

delete()
    

Delete the custom page

Returns:
    

None

_class _dataikuapi.govern.admin_custom_pages_handler.GovernAdminCustomPageDefinition(_client_ , _custom_page_id_ , _definition_)
    

The definition of a custom page. Do not create this directly, use `get_definition()`

get_raw()
    

Get the raw content of the custom page. This returns a reference to the custom page so changes made to the returned object will be reflected when saving.

Return type:
    

dict

save()
    

Save this settings back to the custom page.

Returns:
    

None

_class _dataikuapi.govern.blueprint.GovernBlueprintVersionId(_blueprint_id_ , _version_id_)
    

A Blueprint Version ID builder

Parameters:
    

  * **blueprint_id** (_str_) – the Blueprint ID

  * **version_id** (_str_) – the Version ID




build()
    

Returns:
    

the built blueprint version ID definition

Return type:
    

dict

_class _dataikuapi.govern.users_container.GovernUsersContainer(_type_)
    

An abstract class to represent a users container definition. Do not instance this class but one of its subclasses.

build()
    

_class _dataikuapi.govern.users_container.GovernUserUsersContainer(_user_login_)
    

A users container representing a single user

Parameters:
    

**user_login** (_str_) – the user login

build()
    

Returns:
    

the users container definition as a dict

Return type:
    

dict

---

## [api-reference/python/index]

# Python

This section contains the index of classes in the public API Python client of Dataiku and serves as its reference documentation.

---

## [api-reference/python/insights]

# Insights

_class _dataikuapi.dss.insight.DSSInsight(_client_ , _project_key_ , _insight_id_)
    

A handle to interact with an insight on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.dss.project.DSSProject.get_insight()`](<projects.html#dataikuapi.dss.project.DSSProject.get_insight> "dataikuapi.dss.project.DSSProject.get_insight") instead

delete()
    

Delete the insight

get_settings()
    

Get the insight’s definition

Returns:
    

a handle to inspect the insight definition

Return type:
    

`dataikuapi.dss.insight.DSSInsightSettings`

_class _dataikuapi.dss.insight.DSSInsightSettings(_client_ , _settings_)
    

Settings for an insight

Important

Do not instantiate directly, use `dataikuapi.dss.insight.DSSInsight.get_settings()` instead

get_raw()
    

Gets all settings as a raw dictionary.

Returns:
    

the settings, as a dict. Fields are:

  * **projectKey** and **id** : identify the insight

  * **name** : name (label) of the insight

  * **owner** : login of the owner of the insight

  * **versionTag** , **creationTag** , **checklists** , **tags** , **customFields** : common fields on DSS objects




Return type:
    

dict

save()
    

Save the settings to the insight

_property _id
    

Get the identifier of the insight

Note

The id is generated by DSS upon creation and random.

Return type:
    

string

_property _name
    

Get the name of the insight

Note

The name is user-provided and not necessarily unique.

Return type:
    

str

_property _type
    

Get the type of the insight (ex: “chart”)

Return type:
    

str

_property _listed
    

Get the boolean indicating whether the insight is private or public (i.e. promoted)

Return type:
    

bool

_property _owner
    

Get the login of the owner of the insight

Return type:
    

str

_class _dataikuapi.dss.insight.DSSInsightListItem(_client_ , _data_)
    

An item in a list of insights.

Important

Do not instantiate this class, use [`dataikuapi.dss.project.DSSProject.list_insights()`](<projects.html#dataikuapi.dss.project.DSSProject.list_insights> "dataikuapi.dss.project.DSSProject.list_insights")

_property _id
    

Get the identifier of the insight

Note

The id is generated by DSS upon creation and random.

Return type:
    

string

_property _name
    

Get the name of the insight

Note

The name is user-provided and not necessarily unique.

Return type:
    

str

_property _type
    

Get the type of the insight (ex: “chart”)

Return type:
    

str

_property _listed
    

Get the boolean indicating whether the insight is private or public (i.e. promoted)

Return type:
    

bool

_property _owner
    

Get the login of the owner of the insight

Return type:
    

str

to_insight()
    

Get a handle to interact with this insight

Returns:
    

a handle on the insight

Return type:
    

`dataikuapi.dss.insight.DSSInsight`

---

## [api-reference/python/jobs]

# Jobs

For usage information and examples, see [Jobs](<../../concepts-and-examples/jobs.html>)

_class _dataikuapi.dss.project.JobDefinitionBuilder(_project_ , _job_type ='NON_RECURSIVE_FORCED_BUILD'_)
    

Helper to run a job. Do not create this class directly, use [`DSSProject.new_job()`](<projects.html#dataikuapi.dss.project.DSSProject.new_job> "dataikuapi.dss.project.DSSProject.new_job")

with_type(_job_type_)
    

Sets the build type

Parameters:
    

**job_type** – the build type for the job RECURSIVE_BUILD, NON_RECURSIVE_FORCED_BUILD, RECURSIVE_FORCED_BUILD, RECURSIVE_MISSING_ONLY_BUILD

with_refresh_metastore(_refresh_metastore_)
    

Sets whether the hive tables built by the job should have their definitions refreshed after the corresponding dataset is built

Parameters:
    

**refresh_metastore** (_bool_) – 

with_output(_name_ , _object_type =None_, _object_project_key =None_, _partition =None_)
    

Adds an item to build in this job

Parameters:
    

  * **name** – name of the output object

  * **object_type** – type of object to build from: DATASET, MANAGED_FOLDER, SAVED_MODEL, STREAMING_ENDPOINT, KNOWLEDGE_BANK (defaults to **None**)

  * **object_project_key** – PROJECT_KEY for the project that contains the object to build (defaults to **None**)

  * **partition** – specify partition to build (defaults to **None**)




with_auto_update_schema_before_each_recipe_run(_auto_update_schema_before_each_recipe_run_)
    

Sets whether the schema should be auto updated before each recipe run

Parameters:
    

**auto_update_schema_before_each_recipe_run** (_bool_) – 

get_definition()
    

Gets the internal definition for this job

start()
    

Starts the job, and return a `dataikuapi.dss.job.DSSJob` handle to interact with it.

You need to wait for the returned job to complete

Returns:
    

a job handle

Return type:
    

`dataikuapi.dss.job.DSSJob`

start_and_wait(_no_fail =False_)
    

Starts the job, waits for it to complete and returns a `dataikuapi.dss.job.DSSJob` handle to interact with it

Raises if the job failed.

Parameters:
    

**no_fail** – if True, does not raise if the job failed (defaults to **False**).

Returns:
    

A job handle

Return type:
    

`dataikuapi.dss.job.DSSJob`

_class _dataikuapi.dss.job.DSSJob(_client_ , _project_key_ , _id_)
    

A job on the DSS instance.

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.get_job()`](<projects.html#dataikuapi.dss.project.DSSProject.get_job> "dataikuapi.dss.project.DSSProject.get_job") or [`dataikuapi.dss.project.DSSProject.start_job()`](<projects.html#dataikuapi.dss.project.DSSProject.start_job> "dataikuapi.dss.project.DSSProject.start_job").

abort()
    

Aborts the job.

Returns:
    

a confirmation message for the request

Return type:
    

dict

get_status()
    

Gets the current status of the job.

Returns:
    

the state of the job

Return type:
    

dict

get_log(_activity =None_)
    

Gets the logs of the job. If an activity is passed in the parameters the logs will be scoped to that activity.

Parameters:
    

**activity** (_string_) – (optional) the name of the activity in the job whose log is requested (defaults to **None**)

Returns:
    

the job logs

Return type:
    

string

_class _dataikuapi.dss.job.DSSJobWaiter(_job_)
    

Creates a helper to wait for the completion of a job.

Parameters:
    

**job** (`dataikuapi.dss.job.DSSJob`) – The job to wait for

wait(_no_fail =False_)
    

Waits for the job to finish. If the job fails or is aborted, an exception is raised unless the no_fail parameter is set to True.

Parameters:
    

**no_fail** (_boolean_) – (optional) should an error be raised if the job finished with another status than DONE (defaults to **False**)

Raises:
    

**DataikuException** – when the job does not complete successfully

Returns:
    

the job state

Return type:
    

dict

---

## [api-reference/python/llm-mesh]

# LLM Mesh

For usage information and examples, please see [LLM Mesh](<../../concepts-and-examples/llm-mesh.html>)

_class _dataikuapi.dss.llm.DSSLLM(_client_ , _project_key_ , _llm_id_)
    

A handle to interact with a DSS-managed LLM.

Important

Do not create this class directly, use [`dataikuapi.dss.project.DSSProject.get_llm()`](<projects.html#dataikuapi.dss.project.DSSProject.get_llm> "dataikuapi.dss.project.DSSProject.get_llm") instead.

new_completion()
    

Create a new completion query.

Returns:
    

A handle on the generated completion query.

Return type:
    

`DSSLLMCompletionQuery`

new_completions()
    

Create a new multi-completion query.

Returns:
    

A handle on the generated multi-completion query.

Return type:
    

`DSSLLMCompletionsQuery`

new_embeddings(_text_overflow_mode ='FAIL'_)
    

Create a new embedding query.

Parameters:
    

**text_overflow_mode** (_str_) – How to handle longer texts than what the model supports. Either ‘TRUNCATE’ or ‘FAIL’.

Returns:
    

A handle on the generated embeddings query.

Return type:
    

`DSSLLMEmbeddingsQuery`

new_images_generation()
    

new_reranking()
    

Create a new reranking query.

Returns:
    

A handle on the generated reranking query.

Return type:
    

`DSSLLMRerankingQuery`

as_langchain_llm(_** data_)
    

Create a langchain-compatible LLM object for this LLM.

Returns:
    

A langchain-compatible LLM object.

Return type:
    

`dataikuapi.dss.langchain.llm.DKULLM`

as_langchain_chat_model(_** data_)
    

Create a langchain-compatible chat LLM object for this LLM.

Returns:
    

A langchain-compatible LLM object.

Return type:
    

`dataikuapi.dss.langchain.llm.DKUChatModel`

as_langchain_embeddings(_** data_)
    

Create a langchain-compatible embeddings object for this LLM.

Returns:
    

A langchain-compatible embeddings object.

Return type:
    

`dataikuapi.dss.langchain.embeddings.DKUEmbeddings`

_class _dataikuapi.dss.llm.DSSLLMListItem(_client_ , _project_key_ , _data_)
    

An item in a list of llms

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.list_llms()`](<projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms").

to_llm()
    

Convert the current item.

Returns:
    

A handle for the llm.

Return type:
    

`dataikuapi.dss.llm.DSSLLM`

_property _id
    

Returns:
    

The id of the llm.

Return type:
    

string

_property _type
    

Returns:
    

The type of the LLM

Return type:
    

string

_property _description
    

Returns:
    

The description of the LLM

Return type:
    

string

_class _dataikuapi.dss.llm.DSSLLMCompletionsQuery(_llm_)
    

A handle to interact with a multi-completion query. Completion queries allow you to send a prompt to a DSS-managed LLM and retrieve its response.

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLM.new_completion()` instead.

_property _settings
    

Returns:
    

The completion query settings.

Return type:
    

dict

new_completion()
    

new_guardrail(_type_)
    

Start adding a guardrail to the request. You need to configure the returned object, and call add() to actually add it

execute()
    

Run the completions query and retrieve the LLM response.

Returns:
    

The LLM response.

Return type:
    

`DSSLLMCompletionsResponse`

with_json_output(_schema =None_, _strict =None_, _compatible =None_)
    

Request the model to generate a valid JSON response, for models that support it.

Note that some models may require you to also explicitly request this in the user or system prompt to use this.

Caution

JSON output support is experimental for locally-running Hugging Face models.

Parameters:
    

  * **schema** (_dict_) – (optional) If specified, request the model to produce a JSON response that adheres to the provided schema. Support varies across models/providers.

  * **strict** (_bool_) – (optional) If a schema is provided, whether to strictly enforce it. Support varies across models/providers.

  * **compatible** (_bool_) – (optional) Allow DSS to modify the schema in order to increase compatibility, depending on known limitations of the model/provider. Defaults to automatic.




with_structured_output(_model_type_ , _strict =None_, _compatible =None_)
    

Instruct the model to generate a response as an instance of a specified Pydantic model.

This functionality depends on with_json_output and necessitates that the model supports JSON output with a schema.

Caution

Structured output support is experimental for locally-running Hugging Face models.

Parameters:
    

  * **model_type** (_pydantic.BaseModel_) – A Pydantic model class used for structuring the response.

  * **strict** (_bool_) – (optional) see `with_json_output()`

  * **compatible** (_bool_) – (optional) see `with_json_output()`




_class _dataikuapi.dss.llm.DSSLLMCompletionsQuerySingleQuery
    

new_multipart_message(_role ='user'_)
    

Start adding a multipart-message to the completion query.

Use this to add image parts to the message.

Parameters:
    

**role** (_str_) – The message role. Use `system` to set the LLM behavior, `assistant` to store predefined responses, `user` to provide requests or comments for the LLM to answer to. Defaults to `user`.

Return type:
    

`DSSLLMCompletionQueryMultipartMessage`

with_message(_message_ , _role ='user'_)
    

Add a message to the completion query.

Parameters:
    

  * **message** (_str_) – The message text.

  * **role** (_str_) – The message role. Use `system` to set the LLM behavior, `assistant` to store predefined responses, `user` to provide requests or comments for the LLM to answer to. Defaults to `user`.




with_memory_fragment(_memory_fragment_)
    

Add a memory fragment to the completion query.

Parameters:
    

**memory_fragment** (_dict_) – The memory fragment returned by the model on the previous turn.

with_tool_calls(_tool_calls_ , _role ='assistant'_)
    

Add tool calls to the completion query.

Caution

Tool calls support is experimental for locally-running Hugging Face models.

Parameters:
    

  * **tool_calls** (_list_ _[__dict_ _]_) – Calls to tools that the LLM requested to use.

  * **role** (_str_) – The message role. Defaults to `assistant`.




with_tool_validation_requests(_tool_validation_requests_)
    

Add tool validation requests to the completion query.

Parameters:
    

**tool_validation_requests** (_list_ _[__dict_ _]_) – Validation requests for tools that the agent requested to use.

with_tool_validation_response(_validation_request_id_ , _validated =True_, _arguments =None_)
    

Add a tool validation response to the completion query.

Parameters:
    

  * **validation_request_id** (_str_) – The validation request id, as provided by the agent in the conversation messages.

  * **validated** (_bool_) – Whether to validate or reject the tool call.

  * **arguments** (_str_) – Arguments to use for the tool call (if different from the validation request).




new_multipart_tool_output(_tool_call_id_ , _role ='tool'_, _output =''_)
    

Start adding a multipart tool output to the completion query.

Parameters:
    

  * **tool_call_id** (_str_) – The tool call id, as provided by the LLM in the conversation messages.

  * **role** (_str_) – The message role. Defaults to `tool`.

  * **output** (_str_) – The tool’s output. Defaults to an empty string.



Return type:
    

`DSSLLMCompletionQueryMultipartToolOutput`

with_tool_output(_tool_output_ , _tool_call_id_ , _role ='tool'_)
    

Add a tool message to the completion query.

Parameters:
    

  * **tool_output** (_str_) – The tool output, as a string.

  * **tool_call_id** (_str_) – The tool call id, as provided by the LLM in the conversation messages.

  * **role** (_str_) – The message role. Defaults to `tool`.




with_context(_context_)
    

_class _dataikuapi.dss.llm.DSSLLMCompletionsResponse(_raw_resp_ , _response_parser =None_)
    

A handle to interact with a multi-completion response.

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLMCompletionsQuery.execute()` instead.

_property _responses
    

The array of responses

_class _dataikuapi.dss.llm.DSSLLMRerankingQuery(_llm_)
    

A handle to interact with a reranking query. Reranking queries allow you to send a text query and a list of documents to a DSS-managed ranking model and retrieve the documents ranked according to their relevance to the query.

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLM.new_reranking()` instead.

with_query(_text_)
    

Sets the reranking text query.

Parameters:
    

**text** (_str_) – The reranking text query.

with_document(_text_)
    

Adds a text document to the list of documents to be reranked.

Parameters:
    

**text** (_str_) – The text document to be reranked.

execute()
    

Run the reranking query and retrieve the LLM response.

Returns:
    

The LLM response.

Return type:
    

`DSSLLMRerankingResponse`

_class _dataikuapi.dss.llm.DSSLLMRerankingResponse(_raw_resp_)
    

A handle to interact with a ranking query result.

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLMRerankingQuery.execute()` instead.

_property _success
    

Returns:
    

The outcome of the reranking query.

Return type:
    

bool

_property _error_message
    

Returns:
    

The error message if the reranking query failed, None otherwise.

Return type:
    

Union[str, None]

_property _documents
    

Returns:
    

The array of reranked documents.

Return type:
    

list of `DSSLLMRerankingResponse.RankedDocument`

_property _trace
    

Returns:
    

The trace of the reranking query if available, None otherwise.

Return type:
    

Union[dict, None]

_class _RankedDocument(_raw_doc_)
    

_property _index
    

Returns:
    

The index of the document in the original request.

Return type:
    

int

_property _relevance_score
    

Returns:
    

The relevance score assigned to the document by the ranking model.

Return type:
    

float

_class _dataikuapi.dss.llm.DSSLLMCompletionQuery(_llm_)
    

A handle to interact with a completion query. Completion queries allow you to send a prompt to a DSS-managed LLM and retrieve its response.

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLM.new_completion()` instead.

_property _settings
    

Returns:
    

The completion query settings.

Return type:
    

dict

new_guardrail(_type_)
    

Start adding a guardrail to the request. You need to configure the returned object, and call add() to actually add it

execute()
    

Run the completion query and retrieve the LLM response.

Returns:
    

The LLM response.

Return type:
    

`DSSLLMCompletionResponse`

execute_streamed(_collect_response =False_)
    

Run the completion query and retrieve the LLM response as streamed chunks.

Parameters:
    

**collect_response** (_bool_) – If True, the streamed chunks are also aggregated into a consolidated `DSSLLMCompletionResponse` by the returned iterator.

Returns:
    

An iterator over the LLM response chunks

Return type:
    

`DSSLLMStreamedCompletionChunks`

new_multipart_message(_role ='user'_)
    

Start adding a multipart-message to the completion query.

Use this to add image parts to the message.

Parameters:
    

**role** (_str_) – The message role. Use `system` to set the LLM behavior, `assistant` to store predefined responses, `user` to provide requests or comments for the LLM to answer to. Defaults to `user`.

Return type:
    

`DSSLLMCompletionQueryMultipartMessage`

new_multipart_tool_output(_tool_call_id_ , _role ='tool'_, _output =''_)
    

Start adding a multipart tool output to the completion query.

Parameters:
    

  * **tool_call_id** (_str_) – The tool call id, as provided by the LLM in the conversation messages.

  * **role** (_str_) – The message role. Defaults to `tool`.

  * **output** (_str_) – The tool’s output. Defaults to an empty string.



Return type:
    

`DSSLLMCompletionQueryMultipartToolOutput`

with_context(_context_)
    

with_json_output(_schema =None_, _strict =None_, _compatible =None_)
    

Request the model to generate a valid JSON response, for models that support it.

Note that some models may require you to also explicitly request this in the user or system prompt to use this.

Caution

JSON output support is experimental for locally-running Hugging Face models.

Parameters:
    

  * **schema** (_dict_) – (optional) If specified, request the model to produce a JSON response that adheres to the provided schema. Support varies across models/providers.

  * **strict** (_bool_) – (optional) If a schema is provided, whether to strictly enforce it. Support varies across models/providers.

  * **compatible** (_bool_) – (optional) Allow DSS to modify the schema in order to increase compatibility, depending on known limitations of the model/provider. Defaults to automatic.




with_memory_fragment(_memory_fragment_)
    

Add a memory fragment to the completion query.

Parameters:
    

**memory_fragment** (_dict_) – The memory fragment returned by the model on the previous turn.

with_message(_message_ , _role ='user'_)
    

Add a message to the completion query.

Parameters:
    

  * **message** (_str_) – The message text.

  * **role** (_str_) – The message role. Use `system` to set the LLM behavior, `assistant` to store predefined responses, `user` to provide requests or comments for the LLM to answer to. Defaults to `user`.




with_structured_output(_model_type_ , _strict =None_, _compatible =None_)
    

Instruct the model to generate a response as an instance of a specified Pydantic model.

This functionality depends on with_json_output and necessitates that the model supports JSON output with a schema.

Caution

Structured output support is experimental for locally-running Hugging Face models.

Parameters:
    

  * **model_type** (_pydantic.BaseModel_) – A Pydantic model class used for structuring the response.

  * **strict** (_bool_) – (optional) see `with_json_output()`

  * **compatible** (_bool_) – (optional) see `with_json_output()`




with_tool_calls(_tool_calls_ , _role ='assistant'_)
    

Add tool calls to the completion query.

Caution

Tool calls support is experimental for locally-running Hugging Face models.

Parameters:
    

  * **tool_calls** (_list_ _[__dict_ _]_) – Calls to tools that the LLM requested to use.

  * **role** (_str_) – The message role. Defaults to `assistant`.




with_tool_output(_tool_output_ , _tool_call_id_ , _role ='tool'_)
    

Add a tool message to the completion query.

Parameters:
    

  * **tool_output** (_str_) – The tool output, as a string.

  * **tool_call_id** (_str_) – The tool call id, as provided by the LLM in the conversation messages.

  * **role** (_str_) – The message role. Defaults to `tool`.




with_tool_validation_requests(_tool_validation_requests_)
    

Add tool validation requests to the completion query.

Parameters:
    

**tool_validation_requests** (_list_ _[__dict_ _]_) – Validation requests for tools that the agent requested to use.

with_tool_validation_response(_validation_request_id_ , _validated =True_, _arguments =None_)
    

Add a tool validation response to the completion query.

Parameters:
    

  * **validation_request_id** (_str_) – The validation request id, as provided by the agent in the conversation messages.

  * **validated** (_bool_) – Whether to validate or reject the tool call.

  * **arguments** (_str_) – Arguments to use for the tool call (if different from the validation request).




_class _dataikuapi.dss.llm.DSSLLMCompletionQueryMultipartMessage(_q_ , _role_)
    

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLMCompletionQuery.new_multipart_message()` or `dataikuapi.dss.llm.DSSLLMCompletionsQuerySingleQuery.new_multipart_message()`.

add()
    

Add this message to the completion query

_class _dataikuapi.dss.llm.DSSLLMCompletionQueryMultipartToolOutput(_q_ , _tool_call_id_ , _role_ , _output_)
    

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLMCompletionQuery.new_multipart_tool_output()` or `dataikuapi.dss.llm.DSSLLMCompletionsQuerySingleQuery.new_multipart_tool_output()`.

add()
    

Add this tool output to the completion query

_class _dataikuapi.dss.llm.DSSLLMCompletionResponse(_raw_resp =None_, _text =None_, _finish_reason =None_, _response_parser =None_, _trace =None_, _query =None_)
    

Response to a completion

_property _json
    

Returns:
    

LLM response parsed as a JSON object

_property _parsed
    

_property _success
    

Returns:
    

The outcome of the completion query.

Return type:
    

bool

_property _text
    

Returns:
    

The raw text of the LLM response.

Return type:
    

Union[str, None]

_property _tool_calls
    

Returns:
    

The tool calls of the LLM response.

Return type:
    

Union[list, None]

_property _tool_validation_requests
    

Returns:
    

The tool validation requests of the agent response.

Return type:
    

Union[list, None]

_property _memory_fragment
    

Returns:
    

Data generated by the model that must be passed back in the next query.

Return type:
    

Union[dict, None]

_property _log_probs
    

Returns:
    

The log probs of the LLM response.

Return type:
    

Union[list, None]

_property _context_upsert
    

Returns:
    

The context upsert of the response (only for agents).

Return type:
    

Union[dict, None]

_property _trace
    

_property _total_usage
    

prepare_followup()
    

Prepare a new completion query to follow up on this response, pre-filled with the relevant data from the response.

Returns:
    

The prepared follow-up completion query.

Return type:
    

`DSSLLMCompletionQuery`

_class _dataikuapi.dss.llm.DSSLLMStreamedCompletionChunks(_query_ , _collect_response =False_)
    

An iterator over the chunks generated by the execution of a streamed completion query. The streamed chunks are of type `DSSLLMStreamedCompletionChunk` and `DSSLLMStreamedCompletionFooter`. When collect_response=True, the streamed chunks are aggregated into a consolidated `DSSLLMCompletionResponse`.

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLMCompletionQuery.execute_streamed()` instead.

iter_chunks()
    

Returns:
    

An iterator over the LLM response chunks.

Return type:
    

Iterator[Union[`DSSLLMStreamedCompletionChunk`, `DSSLLMStreamedCompletionFooter`]]

_property _response
    

Returns:
    

The consolidated LLM response obtained by the aggregation of all streamed chunks, if collect_response=True. Available only after all chunks have been collected.

Return type:
    

`DSSLLMCompletionResponse`

prepare_followup()
    

Prepare a followup completion query from the consolidated response, pre-filled with the relevant data from the response. Available only when collect_response=True, after all chunks have been collected.

Returns:
    

The prepared follow-up completion query.

Return type:
    

`DSSLLMCompletionQuery`

_class _dataikuapi.dss.llm.DSSLLMEmbeddingsQuery(_llm_ , _text_overflow_mode_)
    

A handle to interact with an embedding query. Embedding queries allow you to transform text into embedding vectors using a DSS-managed model.

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLM.new_embeddings()` instead.

add_text(_text_)
    

Add text to the embedding query.

Parameters:
    

**text** (_str_) – Text to add to the query.

add_image(_image_ , _text =None_)
    

Add an image to the embedding query.

Parameters:
    

  * **image** – Image content as bytes or str (base64)

  * **text** – Optional text (requires a multimodal model)




new_guardrail(_type_)
    

Start adding a guardrail to the request. You need to configure the returned object, and call add() to actually add it

execute()
    

Run the embedding query.

Returns:
    

The results of the embedding query.

Return type:
    

`DSSLLMEmbeddingsResponse`

_class _dataikuapi.dss.llm.DSSLLMEmbeddingsResponse(_raw_resp_)
    

A handle to interact with an embedding query result.

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLMEmbeddingsQuery.execute()` instead.

get_embeddings()
    

Retrieve vectors resulting from the embeddings query.

Returns:
    

A list of lists containing all embedding vectors.

Return type:
    

list

_class _dataikuapi.dss.llm.DSSLLMImageGenerationQuery(_llm_)
    

A handle to interact with an image generation query.

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLM.new_images_generation()` instead.

with_prompt(_prompt_ , _weight =None_)
    

Add a prompt to the image generation query.

Parameters:
    

  * **prompt** (_str_) – The prompt text.

  * **weight** (_float_) – Optional weight between 0 and 1 for the prompt.




with_negative_prompt(_prompt_ , _weight =None_)
    

Add a negative prompt to the image generation query.

Parameters:
    

  * **prompt** (_str_) – The prompt text.

  * **weight** (_float_) – Optional weight between 0 and 1 for the negative prompt.




with_original_image(_image_ , _mode =None_, _weight =None_)
    

Add an image to the generation query.

To edit specific pixels of the original image. A mask can be applied by calling with_mask():
    
    
    >>> query.with_original_image(image, mode="INPAINTING") # replace the pixels using a mask
    

To edit an image:
    
    
    >>> query.with_original_image(image, mode="MASK_FREE") # edit the original image according to the prompt
    
    
    
    >>> query.with_original_image(image, mode="VARY") # generates a variation of the original image
    

Parameters:
    

  * **image** (_Union_ _[__str_ _,__bytes_ _]_) – The original image as str in base 64 or bytes.

  * **mode** (_str_) – The edition mode. Modes support varies across models/providers.

  * **weight** (_float_) – The original image weight between 0 and 1.




with_mask(_mode_ , _image =None_)
    

Add a mask for edition to the generation query. Call this method alongside with_original_image().

To edit parts of the image using a black mask (replace the black pixels):
    
    
    >>> query.with_mask("MASK_IMAGE_BLACK", image=black_mask)
    

To edit parts of the image that are transparent (replace the transparent pixels):
    
    
    >>> query.with_mask("ORIGINAL_IMAGE_ALPHA")
    

Parameters:
    

  * **mode** (_str_) – The mask mode. Modes support varies across models/providers.

  * **image** (_Union_ _[__str_ _,__bytes_ _]_) – The mask image to apply to the image edition. As str in base 64 or bytes.




new_guardrail(_type_)
    

Start adding a guardrail to the request. You need to configure the returned object, and call add() to actually add it

_property _height
    

Returns:
    

The generated image height in pixels.

Return type:
    

Optional[int]

_property _width
    

Returns:
    

The generated image width in pixels.

Return type:
    

Optional[int]

_property _fidelity
    

Returns:
    

From 0.0 to 1.0, how strongly to adhere to prompt.

Return type:
    

Optional[float]

_property _quality
    

Returns:
    

Quality of the image to generate. Valid values depend on the targeted model.

Return type:
    

Optional[str]

_property _seed
    

Returns:
    

Seed of the image to generate, gives deterministic results when set.

Return type:
    

Optional[int]

_property _style
    

Returns:
    

Style of the image to generate. Valid values depend on the targeted model.

Return type:
    

Optional[str]

_property _images_to_generate
    

Returns:
    

Number of images to generate per query. Valid values depend on the targeted model.

Return type:
    

Optional[int]

_property _aspect_ratio
    

Returns:
    

The width/height aspect ratio or None if either is not set.

Return type:
    

Optional[float]

execute()
    

Executes the image generation

Return type:
    

`DSSLLMImageGenerationResponse`

_class _dataikuapi.dss.llm.DSSLLMImageGenerationResponse(_raw_resp_)
    

A handle to interact with an image generation response.

Important

Do not create this class directly, use `dataikuapi.dss.llm.DSSLLMImageGenerationQuery.execute()` instead.

_property _success
    

Returns:
    

The outcome of the image generation query.

Return type:
    

bool

first_image(_as_type ='bytes'_)
    

Parameters:
    

**as_type** (_str_) – The type of image to return, ‘bytes’ for bytes otherwise ‘str’ for base 64 str.

Returns:
    

The first generated image as bytes or str depending on the as_type parameter.

Return type:
    

Union[bytes,str]

get_images(_as_type ='bytes'_)
    

Parameters:
    

**as_type** (_str_) – The type of images to return, ‘bytes’ for bytes otherwise ‘str’ for base 64 str.

Returns:
    

The generated images as bytes or str depending on the as_type parameter.

Return type:
    

Union[List[bytes], List[str]]

_property _images
    

Returns:
    

The generated images in bytes format.

Return type:
    

List[bytes]

_property _trace
    

_property _total_usage
    

_class _dataikuapi.dss.knowledgebank.DSSKnowledgeBankListItem(_client_ , _data_)
    

An item in a list of knowledge banks

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.list_knowledge_banks()`](<projects.html#dataikuapi.dss.project.DSSProject.list_knowledge_banks> "dataikuapi.dss.project.DSSProject.list_knowledge_banks").

to_knowledge_bank()
    

Convert the current item.

Returns:
    

A handle for the knowledge_bank.

Return type:
    

`dataikuapi.dss.knowledgebank.DSSKnowledgeBank`

as_core_knowledge_bank()
    

Get the `dataiku.KnowledgeBank` object corresponding to this knowledge bank

Return type:
    

`dataiku.KnowledgeBank`

_property _project_key
    

Returns:
    

The project key

Return type:
    

string

_property _id
    

Returns:
    

The id of the knowledge bank.

Return type:
    

string

_property _name
    

Returns:
    

The name of the knowledge bank.

Return type:
    

string

_class _dataikuapi.dss.knowledgebank.DSSKnowledgeBank(_client_ , _project_key_ , _id_)
    

A handle to interact with a DSS-managed knowledge bank.

Important

Do not create this class directly, use [`dataikuapi.dss.project.DSSProject.get_knowledge_bank()`](<projects.html#dataikuapi.dss.project.DSSProject.get_knowledge_bank> "dataikuapi.dss.project.DSSProject.get_knowledge_bank") instead.

_property _id
    

as_core_knowledge_bank()
    

Get the `dataiku.KnowledgeBank` object corresponding to this knowledge bank

Return type:
    

`dataiku.KnowledgeBank`

as_langchain_retriever(_** data_)
    

Get the current version of this knowledge bank as a Langchain Retriever object.

Parameters:
    

**data** (_dict_) – keyword arguments to pass to the `dataikuapi.dss.knowledgebank.DSSKnowledgeBank.search()` function

Returns:
    

a langchain-compatible retriever

Return type:
    

`dataikuapi.dss.langchain.knowledge_bank.DKUKnowledgeBankRetriever`

get_settings()
    

Get the knowledge bank’s definition

Returns:
    

a handle on the knowledge bank definition

Return type:
    

`dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings`

delete()
    

Delete the knowledge bank

build(_job_type ='NON_RECURSIVE_FORCED_BUILD'_, _wait =True_)
    

Start a new job to build this knowledge bank and wait for it to complete. Raises if the job failed.
    
    
    job = knowledge_bank.build()
    print("Job %s done" % job.id)
    

Parameters:
    

  * **job_type** – the job type. One of RECURSIVE_BUILD, NON_RECURSIVE_FORCED_BUILD or RECURSIVE_FORCED_BUILD

  * **wait** (_bool_) – whether to wait for the job completion before returning the job handle, defaults to True



Returns:
    

the [`dataikuapi.dss.job.DSSJob`](<jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob") job handle corresponding to the built job

Return type:
    

[`dataikuapi.dss.job.DSSJob`](<jobs.html#dataikuapi.dss.job.DSSJob> "dataikuapi.dss.job.DSSJob")

search(_query_ , _max_documents =10_, _search_type ='SIMILARITY'_, _similarity_threshold =0.5_, _mmr_documents_count =20_, _mmr_factor =0.25_, _hybrid_use_advanced_reranking =False_, _hybrid_rrf_rank_constant =60_, _hybrid_rrf_rank_window_size =4_, _filter =None_)
    

Search for documents in a knowledge bank

MMR and HYBRID search types are not supported by every vector stores.

Parameters:
    

  * **query** (_str_) – what to search for

  * **max_documents** (_int_) – the maximum number of documents to return, default to 10

  * **search_type** (_str_) – the search algorithm to use. One of SIMILARITY, SIMILARITY_THRESHOLD, MMR or HYBRID. Defaults to SIMILARITY

  * **similarity_threshold** (_float_) – only return documents with a similarity score above this threshold, typically between 0 and 1, only applied with search_type=SIMILARITY_THRESHOLD, defaults to 0.5

  * **mmr_documents_count** (_int_) – number of documents to consider before selecting the documents to retrieve, only applied with search_type=MMR, defaults to 20

  * **mmr_factor** (_float_) – weight of diversity vs relevancy, between 0 and 1, where 0 favors maximum diversity and 1 favors maximum relevancy, only applied with search_type=MMR, defaults to 0.25

  * **hybrid_use_advanced_reranking** (_bool_) – whether to use proprietary rerankers, valid for Azure AI and ElasticSearch vector stores, defaults to False

  * **hybrid_rrf_rank_constant** (_int_) – higher values give more weight to lower-ranked documents, valid for ElasticSearch vector stores, defaults to 60

  * **hybrid_rrf_rank_window_size** (_int_) – number of documents to consider from each search type, valid for ElasticSearch vector stores, defaults to 4

  * **filter** (Union[[`DSSSimpleFilter`](<utils.html#dataikuapi.dss.utils.DSSSimpleFilter> "dataikuapi.dss.utils.DSSSimpleFilter"), dict], optional) – optional metadata filter as a [`DSSSimpleFilter`](<utils.html#dataikuapi.dss.utils.DSSSimpleFilter> "dataikuapi.dss.utils.DSSSimpleFilter") or a simple filter dictionary



Returns:
    

a result object with a list of documents that matched the query

Return type:
    

`dataikuapi.dss.knowledgebank.DSSKnowledgeBankSearchResult`

_class _dataikuapi.dss.knowledgebank.DSSKnowledgeBankSettings(_client_ , _project_key_ , _settings_)
    

Settings for a knowledge bank

Important

Do not instantiate directly, use `dataikuapi.dss.knowledgebank.DSSKnowledgeBank.get_settings()` instead

_property _project_key
    

Returns the project key of the knowledge bank

Return type:
    

str

_property _id
    

Returns the identifier of the knowledge bank

Return type:
    

str

_property _vector_store_type
    

Returns the type of storage backing the vector store (could be CHROMA, PINECONE, ELASTICSEARCH, AZURE_AI_SEARCH, VERTEX_AI_GCS_BASED, FAISS, QDRANT_LOCAL)

Return type:
    

str

set_metadata_schema(_schema_)
    

Sets the schema for metadata fields.

Parameters:
    

**schema** (_Dict_ _[__str_ _,__str_ _]_) – the schema, as a mapping metadata_field -> type

set_images_folder(_managed_folder_id_ , _project_key =None_)
    

Sets the images folder to use with this knowledge bank.

Parameters:
    

  * **managed_folder_id** (_str_) – The (managed) images folder id.

  * **project_key** (_Optional_ _[__str_ _]_) – The image folder project key, if different from this knowledge bank project key. Default to None.




get_images_folder()
    

Returns the images folder of the knowledge bank, if any.

Returns:
    

the managed folder or None

Return type:
    

[DSSManagedFolder](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder") | None

get_raw()
    

Returns the raw settings of the knowledge bank

Returns:
    

the raw settings of the knowledge bank

Return type:
    

dict

save()
    

Saves the settings on the knowledge bank

_class _dataikuapi.dss.knowledgebank.DSSKnowledgeBankSearchResult(_kb_ , _documents_)
    

The result of a search in a knowledge bank, contains documents that matched the query

Each document is a `dataikuapi.dss.knowledgebank.DSSKnowledgeBankSearchResultDocument`

_property _documents
    

Returns a list of documents that matched a search query

Returns:
    

a list of result documents

Return type:
    

list[DSSKnowledgeBankSearchResultDocument]

_property _managed_folder_id
    

_class _dataikuapi.dss.knowledgebank.DSSKnowledgeBankSearchResultDocument(_result_ , _text_ , _score_ , _metadata_)
    

A document found by searching a knowledge bank with `dataikuapi.dss.knowledgebank.DSSKnowledgeBank.search()`

_property _text
    

Returns the text from the knowledge bank for this document

Returns:
    

the text for this document

Return type:
    

str

_property _score
    

Returns the match score for this document

Returns:
    

the score for this document

Return type:
    

float

_property _metadata
    

Returns metadata from the knowledge bank for this document

Returns:
    

metadata for this document

Return type:
    

dict

_property _images
    

Returns images for this document

Returns:
    

a list of images references or None

Return type:
    

list[ManagedFolderImageRef] | None

_property _file_ref
    

Returns the file reference for this document

Returns:
    

a file reference or None

Return type:
    

ManagedFolderDocumentRef | None

_class _dataiku.KnowledgeBank(_id_ , _project_key =None_, _context_project_key =None_)
    

This is a handle to interact with a Dataiku Knowledge Bank flow object

set_context_project_key(_context_project_key_)
    

Set the context project key to use to report calls to the embedding LLM associated with this knowledge bank.

Parameters:
    

**context_project_key** (_str_) – the context project key

get_current_version(_trusted_object : TrustedObject | None = None_)
    

Gets the current version for this knowledge bank.

Parameters:
    

**trusted_object** (_Optional_ _[__"TrustedObject"__]_) – the optional trusted object using the kb

Return type:
    

str

get_writer()
    

Gets a writer on the latest vector store files on disk. For local vector stores, downloads metadata files as well as data files. For remote vector stores, only downloads metadata files.

The vector store files are automatically uploaded when the context manager is closed.

Note

Each call creates an isolated writer which works on its own folder.

Returns:
    

`dataiku.core.vector_stores.data.writer.VectorStoreWriter`

as_langchain_retriever(_search_type ='similarity'_, _search_kwargs =None_, _vectorstore_kwargs =None_, _** retriever_kwargs_)
    

Get the current version of this knowledge bank as a Langchain Retriever object.

Return type:
    

`langchain_core.vectorstores.VectorStoreRetriever`

as_langchain_vectorstore(_** vectorstore_kwargs_)
    

Get the current version of this knowledge bank as a Langchain Vectorstore object.

Return type:
    

`langchain_core.vectorstores.VectorStore`

get_multipart_context(_docs_)
    

Convert retrieved documents from the vector store to a multipart context. The multipart context contains the parts that can be added to a completion query

Parameters:
    

**docs** (_List_ _[__Document_ _]_) – A list of retrieved documents from the langchain retriever

Raises:
    

**Exception** – If the knowledge bank does not contain multimodal content

Returns:
    

A multipart context object composed by a list of parts containing text or images

Return type:
    

`MultipartContext`

_class _dataikuapi.dss.langchain.knowledge_bank.DKUKnowledgeBankRetriever(_* args: Any_, _** kwargs: Any_)
    

Langchain-compatible retriever for a knowledge bank

Important

Do not instantiate directly, use `dataikuapi.dss.knowledgebank.DSSKnowledgeBank.as_langchain_retriever()` instead

SEARCH_PARAMETERS_NAMES _: ClassVar_ _ = ['max_documents', 'search_type', 'similarity_threshold', 'mmr_documents_count', 'mmr_factor', 'hybrid_use_advanced_reranking', 'hybrid_rrf_rank_constant', 'hybrid_rrf_rank_window_size', 'filter']_
    

Valid parameter names for the search method

_class _dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLMListItem(_client_ , _data_)
    

An item in a list of retrieval-augmented LLMs

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.list_retrieval_augmented_llms()`](<projects.html#dataikuapi.dss.project.DSSProject.list_retrieval_augmented_llms> "dataikuapi.dss.project.DSSProject.list_retrieval_augmented_llms").

_property _project_key
    

Returns:
    

The project

Return type:
    

string

_property _id
    

Returns:
    

The id of the retrieval-augmented LLM.

Return type:
    

string

_property _name
    

Returns:
    

The name of the retrieval-augmented LLM.

Return type:
    

string

as_llm()
    

Returns this retrieval-augmented LLM as a usable `dataikuapi.dss.llm.DSSLLM` for querying

_class _dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM(_client_ , _project_key_ , _id_)
    

A handle to interact with a DSS-managed retrieval-augmented LLM.

Important

Do not create this class directly, use [`dataikuapi.dss.project.DSSProject.get_retrieval_augmented_llm()`](<projects.html#dataikuapi.dss.project.DSSProject.get_retrieval_augmented_llm> "dataikuapi.dss.project.DSSProject.get_retrieval_augmented_llm") instead.

_property _id
    

as_llm()
    

Returns this retrieval-augmented LLM as a usable `dataikuapi.dss.llm.DSSLLM` for querying

get_settings()
    

Get the retrieval-augmented LLM’s definition

Returns:
    

a handle on the retrieval-augmented LLM definition

Return type:
    

`dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLMSettings`

delete()
    

Delete the retrieval-augmented LLM

_class _dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLMSettings(_client_ , _settings_)
    

Settings for a retrieval-augmented LLM

Important

Do not instantiate directly, use `dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLM.get_settings()` instead

get_version_ids()
    

_property _active_version
    

Returns the active version of this retrieval-augmented LLM. May return None if no version is declared as active

get_version_settings(_version_id_)
    

get_raw()
    

Returns the raw settings of the retrieval-augmented LLM

Returns:
    

the raw settings of the retrieval-augmented LLM

Return type:
    

dict

save()
    

Saves the settings on the retrieval-augmented LLM

_class _dataikuapi.dss.retrieval_augmented_llm.DSSRetrievalAugmentedLLMVersionSettings(_version_settings_)
    

get_raw()
    

_property _llm_id
    

Get or set the name of the Data Collection

Return type:
    

`str`

_class _dataiku.core.knowledge_bank.MultipartContext
    

A reference to a list of text or images parts that can be added to a completion query

append(_part_)
    

Parameters:
    

**part** (`MultipartContent`) – Part of a completion query

add_to_completion_query(_completion_ , _role ='user'_)
    

Add the accumulated parts as a new multipart-message to the completion query

Parameters:
    

  * **completion** (`DSSLLMCompletionsQuerySingleQuery`) – the completion query to be edited

  * **role** (_str_) – The message role. Use `system` to set the LLM behavior, `assistant` to store predefined responses, `user` to provide requests or comments for the LLM to answer to. Defaults to `user`.




is_text_only()
    

Returns:
    

True if all the accumulated parts are text parts, False otherwise

Return type:
    

bool

to_text()
    

Returns:
    

the concatenation of accumulated text parts (other parts are skipped)

Return type:
    

str

_class _dataiku.core.vector_stores.data.writer.VectorStoreWriter(_project_key : str_, _kb_full_id : str_, _isolated_folder : VectorStoreIsolatedFolder_)
    

A helper class to write vector store data to the underlying knowledge bank folder.

Important

Do not create this class directly, use `dataiku.KnowledgeBank.get_writer()`

_property _folder_path _: str_
    

The path to the underlying folder on the filesystem.

clear()
    

Clears the vector store data stored in the underlying folder.

save()
    

Saves the content of the underlying folder as a new knowledge bank version.

Returns:
    

the created version

Return type:
    

str

as_langchain_vectorstore(_** vectorstore_kwargs_) → VectorStore
    

Gets this writer as a Langchain Vectorstore object

Return type:
    

`langchain_core.vectorstores.VectorStore`

get_metadata_formatter() → DocumentMetadataFormatter
    

Gets the metadata formatter to help writing documents to this vector store.

Return type:
    

`DocumentMetadataFormatter`

_class _dataiku.core.vector_stores.data.metadata.DocumentMetadataFormatter(_project_key : str_, _vector_store_implementation_)
    

Helper class to format vector store documents metadata for usage within Dataiku.

Important

Do not create this class directly, use `VectorStoreWriter.get_metadata_formatter()` instead.

with_security_tokens(_security_tokens : List[str]_)
    

Adds the security tokens in the metadata.

Parameters:
    

**security_tokens** – The security tokens.

with_original_document(_folder_id : str_, _path : str_, _project_key : str | None = None_)
    

Adds the original document information in the metadata.

Parameters:
    

  * **folder_id** – The id of the managed folder that contains the original document.

  * **path** – The original document path in the managed folder.

  * **project_key** – The managed folder project key. Defaults to the project key of the knowledge bank.




with_original_document_ref(_document_ref : ManagedFolderDocumentRef_, _project_key : str | None = None_)
    

Adds the original document information in the metadata.

Parameters:
    

  * **document_ref** – The reference to the original document.

  * **project_key** – The managed folder project key. Defaults to the project key of the knowledge bank.




with_original_document_page_range(_page_start : int_, _page_end : int_)
    

Adds the page range in the original document. This metadata is intended to start at index 1.

Parameters:
    

  * **page_start** – The original document page where the extract started. Must be positive, and lower or equal to page_end.

  * **page_end** – The original document page where the extract ended. Must be positive, and greater or equal to page_start.




with_original_document_section_outline(_section_outline : List[str]_)
    

Adds a section outline in the metadata. Section outlines can be derived from the document extracted content. For example, it may contain the titles of the sections that contains this part of the original document, from top level headers to lower level headers.

Parameters:
    

**section_outline** – The section outline.

_static _make_captioned_images(_caption : str_, _image_paths : List[str]_) → Dict[str, str | List[str]]
    

Construct a captioned images dictionary from the text and image.

Parameters:
    

  * **caption** – The caption .

  * **image_paths** – The paths to the images, relative to the managed folder that is configured in the knowledge bank.




with_retrieval_content(_text : str | None = None_, _image_paths : List[str] | None = None_, _captioned_images : Dict[str, str | List[str]] | None = None_)
    

Adds the retrieval content in the metadata. Accepts either
    

  * text content

  * image paths relative to the knowledge bank images folder.

  * captioned images




Parameters:
    

  * **text** – The text content.

  * **image_paths** – The paths to the images, relative to the managed folder that is configured in the knowledge bank.

  * **captioned_images** – Captioned images constructed using the constructed using `make_captioned_images()`.




format_metadata(_document : Document_) → Document
    

Formats the metadata in the provided document, so that it can be used for retrieval in Dataiku.

Parameters:
    

**document** – The Langchain document which metadata must be formatted.

Returns:
    

The document with updated metadata.

_class _dataikuapi.dss.langchain.DKULLM(_* args: Any_, _** kwargs: Any_)
    

Langchain-compatible wrapper around Dataiku-mediated LLMs

Note

Direct instantiation of this class is possible from within DSS, though it’s recommended to instead use `dataikuapi.dss.llm.DSSLLM.as_langchain_llm()`.

Example:
    
    
    llm = dkullm.as_langchain_llm()
    
    # single prompt
    print(llm.invoke("tell me a joke"))
    
    # multiple prompts with batching
    for response in llm.batch(["tell me a joke in English", "tell me a joke in French"]):
        print(response)
    
    # streaming, with stop sequence
    for chunk in llm.stream("Explain photosynthesis in a few words in English then French", stop=["dioxyde de"]):
        print(chunk, end="", flush=True)
    

llm_id _: str_
    

LLM identifier to use

max_tokens _: int_ _ = None_
    

Denotes the number of tokens to predict per generation. Deprecated: use key “maxOutputTokens” in field “completion_settings”.

temperature _: float_ _ = None_
    

A non-negative float that tunes the degree of randomness in generation. Deprecated: use key “temperature” in field “completion_settings”.

top_k _: int_ _ = None_
    

Number of tokens to pick from when sampling. Deprecated: use key “topK” in field “completion_settings”.

top_p _: float_ _ = None_
    

Sample from the top tokens whose probabilities add up to p. Deprecated: use key “topP” in field “completion_settings”.

completion_settings _: dict_ _ = {}_
    

Settings applied to completion queries, all keys are optional and can include: maxOutputTokens, temperature, topK, topP, frequencyPenalty, presencePenalty, logitBias, logProbs and topLogProbs.

_class _dataikuapi.dss.langchain.DKUChatModel(_* args: Any_, _** kwargs: Any_)
    

Langchain-compatible wrapper around Dataiku-mediated chat LLMs

Note

Direct instantiation of this class is possible from within DSS, though it’s recommended to instead use `dataikuapi.dss.llm.DSSLLM.as_langchain_chat_model()`.

Example:
    
    
    from langchain_core.prompts import ChatPromptTemplate
    
    llm = dkullm.as_langchain_chat_model()
    prompt = ChatPromptTemplate.from_template("tell me a joke about {topic}")
    chain = prompt | llm
    for chunk in chain.stream({"topic": "parrot"}):
        print(chunk.content, end="", flush=True)
    

llm_id _: str_
    

LLM identifier to use

max_tokens _: int_ _ = None_
    

Denotes the number of tokens to predict per generation. Deprecated: use key “maxOutputTokens” in field “completion_settings”.

temperature _: float_ _ = None_
    

A non-negative float that tunes the degree of randomness in generation. Deprecated: use key “temperature” in field “completion_settings”.

top_k _: int_ _ = None_
    

Number of tokens to pick from when sampling. Deprecated: use key “topK” in field “completion_settings”.

top_p _: float_ _ = None_
    

Sample from the top tokens whose probabilities add up to p. Deprecated: use key “topP” in field “completion_settings”.

completion_settings _: dict_ _ = {}_
    

Settings applied to completion queries, all keys are optional and can include: maxOutputTokens, temperature, topK, topP, frequencyPenalty, presencePenalty, logitBias, logProbs and topLogProbs.

bind_tools(_tools : Sequence[Dict[str, Any] | Type[pydantic.BaseModel] | Callable | langchain_core.tools.BaseTool]_, _tool_choice : dict | str | Literal['auto', 'none', 'required', 'any'] | bool | None = None_, _strict : bool | None = None_, _compatible : bool | None = None_, _** kwargs: Any_)
    

Bind tool-like objects to this chat model.

Args:
    

tools: A list of tool definitions to bind to this chat model.
    

Can be a dictionary, pydantic model, callable, or BaseTool. Pydantic models, callables, and BaseTools will be automatically converted to their schema dictionary representation.

tool_choice: Which tool to request the model to call.
    

Options are:
    

  * name of the tool (str): call the corresponding tool;

  * “auto”: automatically select a tool (or no tool);

  * “none”: do not call a tool;

  * “any” or “required”: force at least one tool call;

  * True: call the one given tool (requires tools to be of length 1);

  * a dict of the form: {“type”: “tool_name”, “name”: “<<tool_name>>”}, or {“type”: “required”}, or {“type”: “any”} or {“type”: “none”}, or {“type”: “auto”};




strict: If specified, request the model to produce a JSON tool call that adheres to the provided schema. Support varies across models/providers. compatible: Allow DSS to modify the schema in order to increase compatibility, depending on known limitations of the model/provider. Defaults to automatic.

kwargs: Any additional parameters to bind.

_class _dataikuapi.dss.langchain.DKUEmbeddings(_* args: Any_, _** kwargs: Any_)
    

Langchain-compatible wrapper around Dataiku-mediated embedding LLMs

Note

Direct instantiation of this class is possible from within DSS, though it’s recommended to instead use `dataikuapi.dss.llm.DSSLLM.as_langchain_embeddings()`.

llm_id _: str_
    

LLM identifier to use

embed_documents(_texts : List[str]_) → List[List[float]]
    

Call out to Dataiku-mediated LLM

Args:
    

texts: The list of texts to embed.

Returns:
    

List of embeddings, one for each text.

_async _aembed_documents(_texts : List[str]_) → List[List[float]]
    

embed_query(_text : str_) → List[float]
    

_async _aembed_query(_text : str_) → List[float]
    

_class _dataikuapi.dss.document_extractor.DocumentExtractor(_client_ , _project_key_)
    

A handle to interact with a DSS-managed Document Extractor.

vlm_extract(_images_ , _llm_id_ , _llm_prompt =None_, _window_size =1_, _window_overlap =0_)
    

Extract text content from images using a vision LLM: for each group of ‘window_size’ consecutive images, prompt the given vision LLM to summarize in plain text.

Parameters:
    

  * **images** (iterable(`InlineImageRef`) | iterable(`ManagedFolderImageRef`)) – iterable over the images to be described by the vision LLM

  * **llm_id** (_str_) – the identifier of a vision LLM

  * **llm_prompt** (_str_) – Custom prompt to extract text from the images

  * **window_size** (_int_) – Number of consecutive images to represent in a single output. Use -1 for all images.

  * **window_overlap** (_int_) – Number of overlapping images between two windows of images. Must be less than window_size.



Returns:
    

Extracted text content per group of images

Return type:
    

`VlmExtractorResponse`

structured_extract(_document_ , _max_section_depth =6_, _image_handling_mode ='IGNORE'_, _ocr_engine ='AUTO'_, _languages ='en'_, _llm_id =None_, _llm_prompt =None_, _output_managed_folder =None_, _image_validation =True_)
    

Splits a document (txt, md, pdf, docx, pptx, html, png, jpg, jpeg) into a structured hierarchy of sections and texts

Parameters:
    

  * **document** (`DocumentRef`) – document to split

  * **max_section_depth** (_int_) – Maximum depth of sections to extract - consider deeper sections as plain text. If set to 0, extract the whole document as one single section.

  * **image_handling_mode** (_str_) – How to handle images in the document. Can be one of: ‘IGNORE’, ‘OCR’, ‘VLM_ANNOTATE’.

  * **ocr_engine** (_str_) – Engine to perform the OCR, either ‘AUTO’, ‘EASYOCR’ or ‘TESSERACT’. Auto uses tesseract if available, otherwise easyOCR.

  * **languages** (_str_ _|__list_) – OCR languages to use for recognition. List (either a comma-separated string, or list of strings) of ISO639 languages codes.

  * **llm_id** (_str_) – ID of the (vision-capable) LLM to use for annotating images when image_handling_mode is ‘VLM_ANNOTATE’

  * **llm_prompt** (_str_) – Custom prompt to extract text from the images

  * **output_managed_folder** (_str_) – id of a managed folder to store the image in the document. When unspecified, return inline images in the response.

  * **image_validation** (_boolean_) – Whether to validate images before processing. If True, images classified as barcodes, icons, logos, QR codes, signatures, or stamps are skipped.



Returns:
    

Structured content of the document

Return type:
    

`StructuredExtractorResponse`

text_extract(_document_ , _image_handling_mode ='IGNORE'_, _ocr_engine ='AUTO'_, _languages ='en'_)
    

Extract raw text from a document (txt, md, pdf, docx, pptx, html, png, jpg, jpeg).

Some documents like PDF or PowerPoint have an inherent structure (page, bookmarks or slides); for those documents, the returned results contain this structure. Otherwise, the document’s structure is not inferred, resulting in one or more text item(s).

PDF files are converted to images and processed using OCR if image_handling_mode is set to ‘OCR’, recommended for scanned PDFs. Otherwise, their text content is extracted.

Parameters:
    

  * **document** (`DocumentRef`) – document to split

  * **image_handling_mode** (_str_) – How to handle images in the document, either ‘IGNORE’ or ‘OCR’.

  * **ocr_engine** (_str_) – Engine to perform the OCR, either ‘AUTO’, ‘EASYOCR’ or ‘TESSERACT’. Auto uses tesseract if available, otherwise easyOCR.

  * **languages** (_str_ _|__list_) – OCR languages to use for recognition. List (either a comma-separated string, or list of strings) of ISO639 languages codes.



Returns:
    

Text content of the document

Return type:
    

`TextExtractorResponse`

generate_pages_screenshots(_document_ , _output_managed_folder =None_, _offset =0_, _fetch_size =10_, _keep_fetched =True_)
    

Generate per-page screenshots of a document, returning an iterable over the screenshots.

Usage example:
    
    
    doc_extractor = DocumentExtractor(client, "project_key")
    document_ref = ManagedFolderDocumentRef('path_in_folder/document.pdf', folder_id)
    
    fetch_size = 10
    response = doc_extractor.generate_pages_screenshots(document_ref, fetch_size=fetch_size)
    # The first 10 screenshots (fetch_size) are computed & retrieved immediately within the response.
    
    first_screenshot = response.fetch_screenshot(0)  # InlineImageRef or ManagedFolderImageRef
    
    # Iterating through the first 10 items is instantaneous as they are already fetched.
    # Iterating from the 11th item triggers new backend requests (processing pages 11-20, fetch screenshots).
    for idx, screenshot in enumerate(response):
        if (idx % fetch_size == 0) and idx != 0:
            print(f"Computing the next {fetch_size} screenshots")
        print(f"Screenshot #{idx}: {screenshot.as_dict()}")
    
    # Alternatively, response being an iterable, you can compute & fetch all screenshots at once:
    response = doc_extractor.generate_pages_screenshots(document_ref)
    screenshots = list(response)  # list of InlineImageRef or ManagedFolderImageRef objects
    

Parameters:
    

  * **document** (`DocumentRef`) – input document (txt | pdf | docx | doc | odt | pptx | ppt | odp | xlsx | xls | xlsm | xlsb | ods | png | jpg | jpeg).

  * **output_managed_folder** (_str_) – id of a managed folder to store the generated screenshots as png. When unspecified, return inline images in the response.

  * **offset** (_int_) – start extraction from offset screenshots.

  * **fetch_size** (_int_) – number of screenshots to fetch in each request, iterating on the next result automatically sends a new request for another fetch_size screenshots

  * **keep_fetched** (_boolean_) – whether to keep previous screenshots requests within this response object when fetching next ones.



Returns:
    

An iterable over the result screenshots

Return type:
    

`ScreenshotterResponse`

convert_to_pdf(_document_ , _output_managed_folder =None_, _path_in_output_folder =None_)
    

Convert a document to PDF format.

Parameters:
    

  * **document** (`DocumentRef`) – input document (docx | doc | odt | pptx | ppt | odp | xlsx | xls | xlsm | xlsb | ods | png | jpg | jpeg).

  * **output_managed_folder** (_str_) – id of an optional managed folder to store the generated PDF document. If unspecified, the document is not stored and should be downloaded from the returned `PDFConversionResponse`

  * **path_in_output_folder** (_str_) – optional path of the generated PDF document in the output managed folder. If unspecified and the input document is in a managed folder, defaults to the input document path (with a .pdf extension).



Returns:
    

A `PDFConversionResponse`, to reference & download the resulting PDF.

Return type:
    

`PDFConversionResponse`

_class _dataikuapi.dss.document_extractor.PDFConversionResponse(_client_ , _project_key_ , _document_ , _output_managed_folder_ , _path_in_output_folder =None_)
    

A handle to interact with a document PDF conversion result.

Important

Do not create this class directly, use `convert_to_pdf()` instead.

get_raw()
    

stream()
    

Download the converted PDF as a binary stream.

Returns:
    

The converted PDF file as a binary stream.

Return type:
    

`requests.Response`

download_to_file(_path_)
    

Download the converted PDF to a local file.

Parameters:
    

**path** (_str_) – the path where to download the PDF file

Returns:
    

None

_property _document
    

Returns:
    

The reference to the stored PDF if applicable, otherwise None

Return type:
    

`ManagedFolderDocumentRef`

_property _success
    

Returns:
    

The outcome of the PDF conversion request.

Return type:
    

bool

_class _dataikuapi.dss.document_extractor.ScreenshotterResponse(_client_ , _project_key_ , _screenshotter_request_ , _keep_fetched_)
    

A handle to interact with a screenshotter result. Iterable over the `ImageRef` screenshots.

Important

Do not create this class directly, use `generate_pages_screenshots()` instead.

get_raw()
    

fetch_screenshot(_screenshot_index_)
    

_property _success
    

Returns:
    

The outcome of the extractor request / latest fetch.

Return type:
    

bool

_property _has_next
    

Returns:
    

Whether there are more screenshots to extract after this response

Return type:
    

bool

_property _total_count
    

Returns:
    

Total number of screenshots that can be extracted from the document. In most cases corresponds to the number of pages of the document.

Return type:
    

int

_property _document
    

Returns:
    

The reference to the screenshotted document.

Return type:
    

`DocumentRef`

_class _dataikuapi.dss.document_extractor.TextExtractorResponse(_data_)
    

A handle to interact with a document text extractor result.

Important

Do not create this class directly, use `text_extract()` instead.

get_raw()
    

_property _success
    

Returns:
    

The outcome of the text extraction request.

Return type:
    

bool

_property _content
    

The content of the document as extracted by `text_extract()` can contain some structure inherent to the document. For instance, PDF documents are extracted page by page, and PowerPoint documents slide by slide. Some PDF documents contain bookmarks that can be used to separate them into sections. For other documents, a single section with one or more text item(s).

This property returns a dict that represents this structure.

Returns:
    

The structure of the document as a dictionary

Return type:
    

dict

_property _text_content
    

Returns:
    

The textual content of the document as a string.

Return type:
    

str

_class _dataikuapi.dss.document_extractor.StructuredExtractorResponse(_data_)
    

A handle to interact with a document structured extractor result.

Important

Do not create this class directly, use `structured_extract()` instead.

get_raw()
    

_property _success
    

Returns:
    

The outcome of the structured extractor request.

Return type:
    

bool

_property _content
    

Returns:
    

The structure of the document as a dictionary

Return type:
    

dict

_property _text_chunks
    

Returns:
    

A flattened text-only view of the documents, along with their outline.

Return type:
    

list[dict]

_class _dataikuapi.dss.document_extractor.VlmExtractorResponse(_data_)
    

A handle to interact with a VLM extractor result.

Important

Do not create this class directly, use `vlm_extract()`

get_raw()
    

_property _success
    

Returns:
    

The outcome of the extractor request.

Return type:
    

bool

_property _chunks
    

Content extracted from the original document, split into chunks

Returns:
    

extracted text content per chunk.

Return type:
    

list[str]

_class _dataikuapi.dss.document_extractor.DocumentRef(_mime_type =None_)
    

A reference to a document file.

Important

Do not create this class directly, use one of its implementations:
    

  * `LocalFileDocumentRef` for a local file to be uploaded

  * `ManagedFolderDocumentRef` for a file inside a DSS-managed folder




as_dict()
    

_class _dataikuapi.dss.document_extractor.LocalFileDocumentRef(_fp_ , _mime_type =None_)
    

A reference to a client-local file.

Usage example:
    
    
    with open("/Users/mdupont/document.pdf", "rb") as f:
        file_ref = LocalFileDocumentRef(f)
    
        # upload the document & generate images of the document's pages:
        images = list(doc_ex.generate_pages_screenshots(file_ref))
    

as_json()
    

Get a dictionary representation.

Caution

Deprecated, use `as_dict()` instead

Return type:
    

dict

as_dict()
    

_class _dataikuapi.dss.document_extractor.ManagedFolderDocumentRef(_file_path_ , _managed_folder_id_ , _mime_type =None_)
    

A reference to a file in a DSS-managed folder.

Usage example:
    
    
    file_ref = ManagedFolderDocumentRef('path_in_folder/document.pdf', folder_id)
    
    # generate images of the document's pages:
    resp = doc_ex.generate_pages_screenshots(file_ref)
    

_property _managed_folder_id
    

as_json()
    

Get a dictionary representation.

Caution

Deprecated, use `as_dict()` instead

Return type:
    

dict

as_dict()
    

Get a dictionary representation.

Return type:
    

dict

_class _dataikuapi.dss.document_extractor.ImageRef
    

A reference to a single image

Important

Do not create this class directly, use one of its implementations:
    

  * `InlineImageRef` for an inline (bytes / base64 string) image

  * `ManagedFolderImageRef` for an image stored in a DSS-managed folder




as_dict()
    

_class _dataikuapi.dss.document_extractor.InlineImageRef(_image_ , _mime_type =None_)
    

A reference to an inline image.

Usage example:
    
    
    with open("/Users/mdupont/image.jpg", "rb") as f:
        image_ref = InlineImageRef(f.read())
    
    # Extract a text summary from the image using a vision LLM:
    resp = doc_ex.vlm_extract([image_ref], 'llm_id')
    

as_json()
    

Get a dictionary representation.

Caution

Deprecated, use `as_dict()` instead

Return type:
    

dict

as_dict()
    

Get a dictionary representation.

Return type:
    

dict

_class _dataikuapi.dss.document_extractor.ManagedFolderImageRef(_managed_folder_ref_ , _image_path_)
    

A reference to an image stored in a DSS-managed folder.

Usage example:
    
    
    managed_img = ManagedFolderImageRef('managed_folder_ref', 'path_in_folder/image.png')
    
    # Extract a text summary from the image using a vision LLM:
    resp = doc_ex.vlm_extract([managed_img], 'llm_id')
    

_property _managed_folder_id
    

as_json()
    

Get a dictionary representation.

Caution

Deprecated, use `as_dict()` instead

Return type:
    

dict

as_dict()
    

Get a dictionary representation.

Return type:
    

dict

_class _dataikuapi.dss.local_model.DSSLocalModel(_client_ , _connection_name_ , _model_id_)
    

A local model defined in a DSS connection.

Important

Do not instantiate this class directly, use [`dataikuapi.dss.admin.DSSConnection.get_local_model()`](<connections.html#dataikuapi.dss.admin.DSSConnection.get_local_model> "dataikuapi.dss.admin.DSSConnection.get_local_model") instead.

_property _model_id
    

get_status()
    

Fetch the current model status.

Returns:
    

Model status wrapper.

Return type:
    

DSSLocalModelStatus

wake_up()
    

Request wakeup of a model kernel.

shutdown(_force =False_)
    

Request shutdown of model kernels.

Parameters:
    

**force** (_boolean_) – If True, force shutdown.

as_llm(_project_key =None_)
    

Return this model as a DSS LLM handle.

Parameters:
    

**project_key** (_string_) – Project key to bind the LLM handle to. If None, uses the client’s default project.

Returns:
    

DSS LLM Handle for this local model.

Return type:
    

DSSLLM

get_settings()
    

Fetch the model settings from the connection definition.

Returns:
    

Model settings wrapper.

Return type:
    

DSSHFModelSettings

_class _dataikuapi.dss.local_model.DSSLocalModelStatus(_client_ , _connection_name_ , _data_)
    

Status of a local model.

Important

Do not instantiate this class directly, use `dataikuapi.dss.local_model.DSSLocalModel.get_status()` instead.

_property _model_id
    

_property _kernels
    

Per-kernel statuses for this model.

Returns:
    

List of kernel statuses.

Return type:
    

list[DSSLocalModelKernel]

_property _state
    

Aggregated model state.

Returns:
    

one of READY, STARTING, STOPPING, ERROR, STOPPED

Return type:
    

string

get_raw()
    

Get the raw API payload for this model status.

Returns:
    

Raw model status dictionary.

Return type:
    

dict

_class _dataikuapi.dss.local_model.DSSLocalModelKernel(_client_ , _connection_name_ , _data_)
    

Status of a single local model kernel.

Important

Do not instantiate this class directly, use `dataikuapi.dss.local_model.DSSLocalModelStatus.kernels` instead.

_property _kernel_id
    

_property _model_id
    

_property _state
    

Current state of the kernel.

Returns:
    

one of READY, STARTING, STOPPING, ERROR, STOPPED

Return type:
    

string

_property _metrics
    

Returns:
    

Kernel metrics if available (if kernel state is READY)

Return type:
    

dict | None

get_log()
    

Fetch logs for this specific model kernel.

Returns:
    

Log payload

Return type:
    

dict

get_raw()
    

Get the raw API payload for this kernel status.

Returns:
    

Raw kernel status dictionary.

Return type:
    

dict

_class _dataikuapi.dss.local_model.DSSHFModelSettings(_client_ , _connection_name_ , _data_)
    

Settings of a HuggingFace local model.

Important

Do not instantiate this class directly, use `dataikuapi.dss.local_model.DSSLocalModel.get_settings()` instead.

_property _model_id
    

get_raw()
    

Get the raw model settings payload.

Returns:
    

Raw model settings dictionary.

Return type:
    

dict

---

## [api-reference/python/macros]

# Macros

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
    

a run identifier to use with [`abort()`](<plugins.html#dataikuapi.dss.macro.DSSMacro.abort> "dataikuapi.dss.macro.DSSMacro.abort"), [`get_status()`](<plugins.html#dataikuapi.dss.macro.DSSMacro.get_status> "dataikuapi.dss.macro.DSSMacro.get_status") and [`get_result()`](<plugins.html#dataikuapi.dss.macro.DSSMacro.get_result> "dataikuapi.dss.macro.DSSMacro.get_result")

Return type:
    

string

abort(_run_id_)
    

Abort a run of the macro.

Parameters:
    

**run_id** (_string_) – a run identifier, as returned by [`run()`](<plugins.html#dataikuapi.dss.macro.DSSMacro.run> "dataikuapi.dss.macro.DSSMacro.run")

get_status(_run_id_)
    

Poll the status of a run of the macro.

Note

Once the run is done, when [`get_result()`](<plugins.html#dataikuapi.dss.macro.DSSMacro.get_result> "dataikuapi.dss.macro.DSSMacro.get_result") is called, the run ceases to exist. Afterwards [`get_status()`](<plugins.html#dataikuapi.dss.macro.DSSMacro.get_status> "dataikuapi.dss.macro.DSSMacro.get_status") will answer that the run doesn’t exist.

Parameters:
    

**run_id** (_string_) – a run identifier, as returned by [`run()`](<plugins.html#dataikuapi.dss.macro.DSSMacro.run> "dataikuapi.dss.macro.DSSMacro.run")

Returns:
    

the status, as a dict. Whether the run is still ongoing can be assessed with the **running** field.

Return type:
    

dict

get_result(_run_id_ , _as_type =None_)
    

Retrieve the result of a run of the macro.

Note

If the macro is still running, an Exception is raised.

The type of the contents of the result to expect can be checked using [`get_definition()`](<plugins.html#dataikuapi.dss.macro.DSSMacro.get_definition> "dataikuapi.dss.macro.DSSMacro.get_definition"), in particular the “resultType” field.

Parameters:
    

  * **run_id** (_string_) – a run identifier, as returned by [`run()`](<plugins.html#dataikuapi.dss.macro.DSSMacro.run> "dataikuapi.dss.macro.DSSMacro.run") method

  * **as_type** (_string_) – if not None, one of ‘string’ or ‘json’. Use ‘json’ when the type of result advertised by the macro is RESULT_TABLE or JSON_OBJECT.



Returns:
    

the contents of the result of the macro run, as a file-like is **as_type** is None; as a str if **as_type** is “string”; as an object if **as_type** is “json”.

Return type:
    

file-like, or string

---

## [api-reference/python/managed-folders]

# Managed folders

Note

There are two main classes related to managed folder handling in Dataiku’s Python APIs:

  * `dataiku.Folder` in the dataiku package. It was initially designed for usage within DSS in recipes and Jupyter notebooks.

  * `dataikuapi.dss.managedfolder.DSSManagedFolder` in the dataikuapi package. It was initially designed for usage outside of DSS.




Both classes have fairly similar capabilities, but we recommend using dataiku.Folder within DSS.

For usage information and examples, see [Managed folders](<../../concepts-and-examples/managed-folders.html>)

## dataiku package

_class _dataiku.Folder(_lookup_ , _project_key =None_, _ignore_flow =False_)
    

Handle to interact with a folder.

Note

This class is also available as `dataiku.Folder`

get_info(_sensitive_info =False_)
    

Get information about the location and settings of this managed folder

Usage sample:
    
    
    # construct the URL to a S3 object
    folder = dataiku.Folder("my_folder_name")
    folder_info = folder.get_info()
    access_info = folder_info["accessInfo"]
    folder_base_url = 's3://%s%s' % (access_info['bucket'], access_info['root'])
    target_url = '%s/some/path/to/a/file' % folder_base_url
    

Parameters:
    

**sensitive_info** (_boolean_) – if True, the credentials of the connection of the managed folder are returned, if they’re accessible to the user. (default: False)

Returns:
    

information about the folder. Fields are:

  * **id** : identifier of the folder

  * **projectKey** : project of the folder

  * **name** : name of the folder

  * **type** : type of the folder (S3 / HDFS / GCS / …)

  * **directoryBasedPartitioning** : whether the partitioning schema of the folder (if any) maps partitions to sub-folders

  * **path** : path of the folder of the filesystem, for folder on the local filesystem

  * **accessInfo** : extra information about the filesystem underlying the folder. The exact fields depend on the folder type. Typically contains the connection root and the parts needed to build a full URI, like bucket and storage account name. If the **sensitive_info** parameter is True, then credentials of the connection will be added (if accessible to the user)




Return type:
    

dict

get_partition_info(_partition_)
    

Get information about a partition of this managed folder

Parameters:
    

**partition** (_string_) – partition identifier

Returns:
    

information about the partition. Fields are:

  * **id** : identifier of the folder

  * **projectKey** : project of the folder

  * **name** : name of the folder

  * **folder** : if the partitioning scheme maps partitions to a subfolder, the path of the subfolder within the managed folder

  * **paths** : paths of the files in the partition, relative to the managed folder




Return type:
    

dict

get_path()
    

Get the filesystem path of this managed folder.

Important

This method can only be called for managed folders that are stored on the local filesystem of the DSS server. For non-filesystem managed folders (HDFS, S3, …), you need to use the various read/download and write/upload APIs.

Usage example:
    
    
    # read a model off a local managed folder
    folder = dataiku.Folder("folder_where_models_are_stored")
    with open(os.path.join(f.get_path(), "path/to/model.pkl"), 'rb') as fd:
        model = pickle.load(fd)
    

Returns:
    

a path on the local filesystem that the python process can read from and write to

Return type:
    

string

is_partitioning_directory_based()
    

Whether the partitioning of the folder maps partitions to sub-directories.

Return type:
    

boolean

list_paths_in_partition(_partition =''_)
    

Gets the paths of the files for the given partition.

Parameters:
    

**partition** (_string_) – identifier of the partition. Use ‘’ to get the paths of all the files in the folder, regardless of the partition

Returns:
    

a list of paths within the folder

Return type:
    

list[string]

list_partitions()
    

Get the partitions in the folder.

Returns:
    

a list of partition identifiers

Return type:
    

list[string]

get_partition_folder(_partition_)
    

Get the filesystem path of the directory corresponding to the partition (if the partitioning is directory-based).

Parameters:
    

**partition** (_string_) – identifier of the partition

Returns:
    

sub-path inside the folder that corresponds to the partition. None if the partitioning scheme doesn’t map partitions to sub-folders

Return type:
    

string

get_id()
    

Get the identifier of the folder.

Return type:
    

string

get_name()
    

Get the name of the folder.

Return type:
    

string

file_path(_filename_)
    

Get the filesystem path for a given file within the folder.

Important

This method can only be called for managed folders that are stored on the local filesystem of the DSS server. For non-filesystem managed folders (HDFS, S3, …), you need to use the various read/download and write/upload APIs.

Parameters:
    

**filename** (_string_) – path of the file within the folder

Returns:
    

the full path of the file on the local filesystem

Return type:
    

string

read_json(_filename_)
    

Read a JSON file within the folder and return its parsed content.

Usage example:
    
    
    folder = dataiku.Folder("my_folder_id")
    # write a JSON-serializable object
    folder.write_json("/some/path/in/folder", my_object)
    
    # read back the object
    my_object_again = folder.read_json("/some/path/in/folder")            
    

Parameters:
    

**filename** (_string_) – path of the file within the folder

Returns:
    

the content of the file

Return type:
    

list or dict, depending on the content of the file

write_json(_filename_ , _obj_)
    

Write a JSON-serializable object as JSON to a file within the folder.

Parameters:
    

  * **filename** (_string_) – Path of the target file within the folder

  * **obj** (_object_) – JSON-serializable object to write (generally dict or list)




clear()
    

Remove all files from the folder.

clear_partition(_partition_)
    

Remove all files from a specific partition of the folder.

Parameters:
    

**partition** (_string_) – identifier of the partition to clear

clear_path(_path_)
    

Remove a file or directory from the managed folder.

Caution

Deprecated. use `delete_path()` instead

Parameters:
    

**path** (_string_) – path inside the folder to the file or directory to delete

delete_path(_path_)
    

Remove a file or directory from the managed folder.

Parameters:
    

**path** (_string_) – path inside the folder to the file or directory to delete

get_path_details(_path ='/'_)
    

Get details about a specific path (file or directory) in the folder.

Parameters:
    

**path** (_string_) – path inside the folder to the file or directory

Returns:
    

information about the file or folder at path, as a dict. Fields are:

  * **exists** : whether there is a file or folder at path

  * **directory** : True if path denotes a directory in the managed folder, False if it’s a file

  * **fullPath** : path inside the folder

  * **size** : if a file, the size in bytes of the file

  * **lastModified** : last modification time of the file or directory at path, in milliseconds since epoch

  * **mimeType** : for files, the detected MIME type

  * **children** : for directories, a list of the contents of the directory, each element having the present structure (not recursive)




Return type:
    

dict

get_download_stream(_path_)
    

Get a file-like object that allows you to read a single file from this folder.

Usage example:
    
    
    with folder.get_download_stream("myfile") as stream:
        data = stream.readline()
        print("First line of myfile is: {}".format(data))
    

Note

The file-like returned by this method is not seekable.

Parameters:
    

**path** (_string_) – path inside the managed folder

Returns:
    

the data of the file at path inside the managed folder

Return type:
    

file-like

upload_stream(_path_ , _f_)
    

Upload the content of a file-like object to a specific path in the managed folder.

If the file already exists, it will be replaced.
    
    
    # This copies a local file to the managed folder
    with open("local_file_to_upload") as f:
        folder.upload_stream("name_of_file_in_folder", f)
    

Parameters:
    

  * **path** (_string_) – Target path of the file to write in the managed folder

  * **f** (_stream_) – file-like object open for reading




upload_file(_path_ , _file_path_)
    

Upload a local file to a specific path in the managed folder.

If the file already exists, it will be replaced.

Parameters:
    

  * **path** (_string_) – Target path of the file to write in the managed folder

  * **file_path** (_string_) – Absolute path to a local file




upload_data(_path_ , _data_)
    

Upload binary data to a specific path in the managed folder.

If the file already exists, it will be replaced.

Parameters:
    

  * **path** (_string_) – Target path of the file to write in the managed folder

  * **data** (_bytes_) – str or unicode data to upload




get_writer(_path_)
    

Get a writer object to write incrementally to a specific path in the managed folder.

If the file already exists, it will be replaced.

Parameters:
    

**path** (_string_) – Target path of the file to write in the managed folder

Return type:
    

`dataiku.core.managed_folder.ManagedFolderWriter`

get_last_metric_values(_partition =''_)
    

Get the set of last values of the metrics on this folder.

Parameters:
    

**partition** (_string_) – (optional) a partition identifier to get metrics for. If not set, returns the metrics of a non-partitioned folder, and the metrics of the whole managed folder for a partitioned managed folder

Return type:
    

[`dataiku.core.metrics.ComputedMetrics`](<metrics.html#dataiku.core.metrics.ComputedMetrics> "dataiku.core.metrics.ComputedMetrics")

get_metric_history(_metric_lookup_ , _partition =''_)
    

Get the set of all values a given metric took on this folder.

Parameters:
    

  * **metric_lookup** (_string_) – metric name or unique identifier

  * **partition** (_string_) – (optional) a partition identifier to get metrics for. If not set, returns the metrics of a non-partitioned folder, and the metrics of the whole managed folder for a partitioned managed folder



Returns:
    

an object containing the values of the metric_lookup metric, cast to the appropriate type (double, boolean, …). Top-level fields are:

>   * **metricId** : identifier of the metric
> 
>   * **metric** : dict of the metric’s definition
> 
>   * **valueType** : type of the metric values in the values array
> 
>   * **lastValue** : most recent value, as a dict of:
> 
>     * **time** : timestamp of the value computation
> 
>     * **value** : value of the metric at time
> 
>   * **values** : list of values, each one a dict of the same structure as **lastValue**
> 
> 


Return type:
    

dict

save_external_metric_values(_values_dict_ , _partition =''_)
    

Save metrics on this folder. The metrics are saved with the type “external”.

Parameters:
    

  * **values_dict** (_dict_) – the values to save, as a dict. The keys of the dict are used as metric names

  * **partition** (_string_) – (optional), the partition for which to fetch the values. On partitioned folders, the partition value to use for accessing metrics on the whole dataset (ie. all partitions) is ALL




get_last_check_values(_partition =''_)
    

Get the set of last values of the checks on this folder, as a [`dataiku.core.metrics.ComputedChecks`](<metrics.html#dataiku.core.metrics.ComputedChecks> "dataiku.core.metrics.ComputedChecks") object

Parameters:
    

**partition** (_string_) – (optional), the partition for which to fetch the values. On partitioned folders, the partition value to use for accessing metrics on the whole dataset (ie. all partitions) is ALL

Return type:
    

[`dataiku.core.metrics.ComputedChecks`](<metrics.html#dataiku.core.metrics.ComputedChecks> "dataiku.core.metrics.ComputedChecks")

save_external_check_values(_values_dict_ , _partition =''_)
    

Save checks on this folder. The checks are saved with the type “external”.

Parameters:
    

  * **values_dict** (_dict_) – the values to save, as a dict. The keys of the dict are used as check names

  * **partition** (_string_) – (optional), the partition for which to fetch the values. On partitioned folders, the partition value to use for accessing metrics on the whole dataset (ie. all partitions) is ALL




## dataikuapi package

Use this class preferably outside of DSS

_class _dataikuapi.dss.managedfolder.DSSManagedFolder(_client_ , _project_key_ , _odb_id_)
    

A handle to interact with a managed folder on the DSS instance.

Important

Do not create this class directly, instead use `dataikuapi.dss.project.get_managed_folder()`

_property _id
    

Returns the internal identifier of the managed folder, which is a 8-character random string, not to be confused with the managed folder’s name.

Return type:
    

string

delete()
    

Delete the managed folder from the flow, and objects using it (recipes or labeling tasks)

Attention

This call doesn’t delete the managed folder’s contents

rename(_new_name_)
    

Rename the managed folder

Parameters:
    

**new_name** (_str_) – the new name of the managed folder

Note

The new name cannot be made of whitespaces only.

get_definition()
    

Get the definition of this managed folder. The definition contains name, description checklists, tags, connection and path parameters, metrics and checks setup.

Caution

Deprecated. Please use `get_settings()`

Returns:
    

the managed folder definition.

Return type:
    

dict

set_definition(_definition_)
    

Set the definition of this managed folder.

Caution

Deprecated. Please use `get_settings()` then `save()`

Note

the fields id and projectKey can’t be modified

Usage example:
    
    
    folder_definition = folder.get_definition()
    folder_definition['tags'] = ['tag1','tag2']
    folder.set_definition(folder_definition)
    

Parameters:
    

**definition** (_dict_) – the new state of the definition for the folder. You should only set a definition object that has been retrieved using the `get_definition()` call

Returns:
    

a message upon successful completion of the definition update. Only contains one msg field

Return type:
    

dict

get_settings()
    

Returns the settings of this managed folder as a `DSSManagedFolderSettings`.

You must use `save()` on the returned object to make your changes effective on the managed folder.
    
    
    # Example: activating discrete partitioning
    folder = project.get_managed_folder("my_folder_id")
    settings = folder.get_settings()
    settings.add_discrete_partitioning_dimension("country")
    settings.save()
    

Returns:
    

the settings of the managed folder

Return type:
    

`DSSManagedFolderSettings`

list_contents()
    

Get the list of files in the managed folder

Usage example:
    
    
    for content in folder.list_contents()['items']:
        last_modified_seconds = content["lastModified"] / 1000
        last_modified_str = datetime.fromtimestamp(last_modified_seconds).strftime("%Y-%m-%d %H:%m:%S")
        print("size=%s mtime=%s %s" % (content["size"], last_modified_str, content["path"]))
    

Returns:
    

the list of files, in the items field. Each item has fields:

  * **path** : path of the file inside the folder

  * **size** : size of the file in bytes

  * **lastModified** : last modification time, in milliseconds since epoch




Return type:
    

dict

get_file(_path_)
    

Get a file from the managed folder

Usage example:
    
    
    with folder.get_file("/kaggle_titanic_train.csv") as fd:
        df = pandas.read_csv(fd.raw)
    

Parameters:
    

**path** (_string_) – the path of the file to read within the folder

Returns:
    

the HTTP request to stream the data from

Return type:
    

`requests.models.Response`

delete_file(_path_)
    

Delete a file from the managed folder

Parameters:
    

**path** (_string_) – the path of the file to read within the folder

Note

No error is raised if the file doesn’t exist

put_file(_path_ , _f_)
    

Upload the file to the managed folder. If the file already exists in the folder, it is overwritten.

Usage example:
    
    
    with open("./some_local.csv") as fd:
        uploaded = folder.put_file("/target.csv", fd).json()
        print("Uploaded %s bytes" % uploaded["size"])
    

Parameters:
    

  * **path** (_string_) – the path of the file to write within the folder

  * **f** (_file_) – a file-like




Note

if using a string for the f parameter, the string itself is taken as the file content to upload

Returns:
    

information on the file uploaded to the folder, as a dict of:

  * **path** : path of the file inside the folder

  * **size** : size of the file in bytes

  * **lastModified** : last modification time, in milliseconds since epoch




Return type:
    

dict

upload_folder(_path_ , _folder_)
    

Upload the content of a folder to a managed folder.

Note

upload_folder(“/some/target”, “./a/source/”) will result in “target” containing the contents of “source”, but not the “source” folder being a child of “target”

Parameters:
    

  * **path** (_str_) – the destination path of the folder in the managed folder

  * **folder** (_str_) – local path (absolute or relative) of the source folder to upload




compute_metrics(_metric_ids =None_, _probes =None_)
    

Compute metrics on this managed folder.

Usage example:
    
    
    future_resp = folder.compute_metrics()
    future = DSSFuture(client, future_resp.get("jobId", None), future_resp)
    metrics = future.wait_for_result()
    print("Computed in %s ms" % (metrics["endTime"] - metrics["startTime"]))
    for computed in metrics["computed"]:
        print("Metric %s = %s" % (computed["metricId"], computed["value"]))
    

Parameters:
    

  * **metric_ids** (_list_ _[__string_ _]_) – (optional) identifiers of metrics to compute, among the metrics defined on the folder

  * **probes** (_dict_) – (optional) definition of metrics probes to use, in place of the ones defined on the folder. The current set of probes on the folder is the probes field in the dict returned by `get_definition()`



Returns:
    

a future as dict representing the task of computing the probes

Return type:
    

dict

get_last_metric_values()
    

Get the last values of the metrics on this managed folder.

Returns:
    

a handle on the values of the metrics

Return type:
    

[`dataikuapi.dss.metrics.ComputedMetrics`](<metrics.html#dataikuapi.dss.metrics.ComputedMetrics> "dataikuapi.dss.metrics.ComputedMetrics")

get_metric_history(_metric_)
    

Get the history of the values of a metric on this managed folder.

Usage example:
    
    
    history = folder.get_metric_history("basic:COUNT_FILES")
    for value in history["values"]:
        time_str = datetime.fromtimestamp(value["time"] / 1000).strftime("%Y-%m-%d %H:%m:%S")
        print("%s : %s" % (time_str, value["value"]))
    

Parameters:
    

**metric** (_string_) – identifier of the metric to get values of

Returns:
    

an object containing the values of the metric, cast to the appropriate type (double, boolean,…). The identifier of the metric is in a **metricId** field.

Return type:
    

dict

get_zone()
    

Get the flow zone of this managed folder.

Returns:
    

a flow zone

Return type:
    

[`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone")

move_to_zone(_zone_)
    

Move this object to a flow zone.

Parameters:
    

**zone** (_object_) – a [`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone") where to move the object, or its identifier

share_to_zone(_zone_)
    

Share this object to a flow zone.

Parameters:
    

**zone** (_object_) – a [`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone") where to share the object, or its identifier

unshare_from_zone(_zone_)
    

Unshare this object from a flow zone.

Parameters:
    

**zone** (_object_) – a [`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone") from where to unshare the object, or its identifier

get_usages()
    

Get the recipes referencing this folder.

Usage example:
    
    
    for usage in folder.get_usages():
        if usage["type"] == 'RECIPE_INPUT':
            print("Used as input of %s" % usage["objectId"])
    

Returns:
    

a list of usages, each one a dict of:

  * **type** : the type of usage, either “RECIPE_INPUT” or “RECIPE_OUTPUT”

  * **objectId** : name of the recipe

  * **objectProjectKey** : project of the recipe




Return type:
    

list[dict]

get_object_discussions()
    

Get a handle to manage discussions on the managed folder.

Returns:
    

the handle to manage discussions

Return type:
    

[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")

copy_to(_target_ , _write_mode ='OVERWRITE'_)
    

Copy the data of this folder to another folder.

Parameters:
    

**target** (_object_) – a `dataikuapi.dss.managedfolder.DSSManagedFolder` representing the target location of this copy

Returns:
    

a DSSFuture representing the operation

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

create_dataset_from_files(_dataset_name_)
    

Create a new dataset of type ‘FilesInFolder’, taking its files from this managed folder, and return a handle to interact with it.

The created dataset does not have its format and schema initialized, it is recommended to use [`autodetect_settings()`](<datasets.html#dataikuapi.dss.dataset.DSSDataset.autodetect_settings> "dataikuapi.dss.dataset.DSSDataset.autodetect_settings") on the returned object

Parameters:
    

**dataset_name** (_str_) – the name of the dataset to create. Must not already exist

Returns:
    

A dataset handle

Return type:
    

[`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset")

_class _dataikuapi.dss.managedfolder.DSSManagedFolderSettings(_folder_ , _settings_)
    

Base settings class for a DSS managed folder. Do not instantiate this class directly, use `DSSManagedFolder.get_settings()`

Use `save()` to save your changes

get_raw()
    

Get the managed folder settings.

Returns:
    

the settings, as a dict. The definition of the actual location of the files in the managed folder is a **params** sub-dict.

Return type:
    

dict

get_raw_params()
    

Get the type-specific (S3/ filesystem/ HDFS/ …) params as a dict.

Returns:
    

the type-specific patams. Each type defines a set of fields; commonly found fields are :

  * **connection** : name of the connection used by the managed folder

  * **path** : root of the managed folder within the connection

  * **bucket** or **container** : the bucket/container name on cloud storages




Return type:
    

dict

_property _type
    

Get the type of filesystem that the managed folder uses.

Return type:
    

string

save()
    

Save the changes to the settings on the managed folder.

Usage example:
    
    
    folder = project.get_managed_folder("my_folder_id")
    settings = folder.get_settings()
    settings.set_connection_and_path("some_S3_connection", None)
    settings.get_raw_params()["bucket"] = "some_S3_bucket"
    settings.save()
    

remove_partitioning()
    

Make the managed folder non-partitioned.

add_discrete_partitioning_dimension(_dim_name_)
    

Add a discrete partitioning dimension.

Parameters:
    

**dim_name** (_string_) – name of the partitioning dimension

add_time_partitioning_dimension(_dim_name_ , _period ='DAY'_)
    

Add a time partitioning dimension.

Parameters:
    

  * **dim_name** (_string_) – name of the partitioning dimension

  * **period** (_string_) – granularity of the partitioning dimension (YEAR, MONTH, DAY (default), HOUR)




set_partitioning_file_pattern(_pattern_)
    

Set the partitioning pattern of the folder. The pattern indicates which paths inside the folder belong to which partition. Partition dimensions are written with:

>   * %{dim_name} for discrete dimensions
> 
>   * %Y (=year), %M (=month), %D (=day) and %H (=hour) for time dimensions
> 
> 


Besides the %… variables for injecting the partition dimensions, the pattern is a regular expression.

Usage example:
    
    
    # partition a managed folder by month
    folder = project.get_managed_folder("my_folder_id")
    settings = folder.get_settings()
    settings.add_time_partitioning_dimension("my_date", "MONTH")
    settings.set_partitioning_file_pattern("/year=%Y/month=%M/.*")
    settings.save()
    

Parameters:
    

**pattern** (_string_) – the partitioning pattern

set_connection_and_path(_connection_ , _path_)
    

Change the managed folder connection and/or path.

Note

When changing the connection or path, the folder’s files aren’t moved or copied to the new location

Attention

When changing the connection for a connection with a different type, for example going from a S3 connection to an Azure Blob Storage connection, only the managed folder type is changed. Type-specific fields are not converted. In the example of a S3 to Azure conversion, the S3 bucket isn’t converted to a storage account container.

Parameters:
    

  * **connection** (_string_) – the name of a file-based connection. If None, the connection of the managed folder is left unchanged

  * **path** (_string_) – a path relative to the connection root. If None, the path of the managed folder is left unchanged

---

## [api-reference/python/meanings]

# Meanings

For usage information and examples, see [Meanings](<../../concepts-and-examples/meanings.html>)

_class _dataikuapi.dss.meaning.DSSMeaning(_client_ , _id_)
    

A user-defined meaning on the DSS instance

get_definition()
    

Get the meaning’s definition.

Returns:
    

the meaning definition. The precise structure of the dict depends on the meaning type and is not documented.

Return type:
    

dict

set_definition(_definition_)
    

Set the meaning’s definition.

Attention

This call requires an API key with admin rights

Parameters:
    

**definition** (_dict_) – the definition for the meaning, as a dict. You should only `set_definition` on a modified version of a dict you retrieved via `get_definition()`

---

## [api-reference/python/messaging-channels]

# Messaging channels

_class _dataikuapi.dss.messaging_channel.DSSMessagingChannelListItem(_client_ , _data_)
    

A generic messaging channel in DSS.

Important

Do not instantiate this class, use [`dataikuapi.DSSClient.list_messaging_channels()`](<client.html#dataikuapi.DSSClient.list_messaging_channels> "dataikuapi.DSSClient.list_messaging_channels")

_property _id
    

ID of the messaging channel

Type:
    

str

_property _type
    

Type of the messaging channel

Type:
    

str

_property _family
    

Family of the messaging channel where relevant - e.g. “mail”

Type:
    

str

get_raw()
    

Returns:
    

Gets the raw representation of this `DSSMessagingChannelListItem`, any edit is reflected in the object.

Return type:
    

dict

get_as_messaging_channel()
    

Returns:
    

The same messaging channel but as the appropriate object type

Return type:
    

DSSMessagingChannel

_class _dataikuapi.dss.messaging_channel.DSSMessagingChannelSettings(_channel_ , _settings_)
    

Settings class for a DSS messaging channel.

Important

Do not instantiate this class directly, use `DSSMessagingChannel.get_settings()`.

Use `save()` to save your changes.

get_raw()
    

Get the messaging channel settings. Requires admin privileges.

Returns:
    

the settings (ie configuration), as a dict.

Return type:
    

dict

save()
    

Save the changes to the settings on the messaging channel. Requires admin privileges.

Usage example:
    
    
    channel = client.get_messaging_channel("my_channel_id")
    channel_settings = channel.get_settings()
    channel_settings.get_raw()["webhookUrl"] = "https://www.example.org/"
    channel_settings.save()
    

_class _dataikuapi.dss.messaging_channel.DSSMessagingChannel(_client_ , _data =None_)
    

A handle to interact with a messaging channel on the DSS instance.

Important

Do not instantiate this class directly, use [`dataikuapi.DSSClient.get_messaging_channel()`](<client.html#dataikuapi.DSSClient.get_messaging_channel> "dataikuapi.DSSClient.get_messaging_channel")

_property _id
    

ID of the messaging channel

Return type:
    

str

_property _type
    

Type of the messaging channel

Return type:
    

str

_property _family
    

Family of the messaging channel where relevant - e.g. “mail”

Type:
    

str

get_settings()
    

Returns the settings of this messaging channel as a `DSSMessagingChannelSettings`.

You must use `save()` on the returned object to make your changes effective on the messaging channel.
    
    
    # Example: change sender
    channel = client.get_messaging_channel("my_channel_id")
    channel_settings = channel.get_settings()
    channel_settings.get_raw()["sender"] = "[[email protected]](</cdn-cgi/l/email-protection>)"
    channel_settings.save()
    

Returns:
    

the settings of the messaging channel

Return type:
    

`DSSMessagingChannelSettings`

get_permissions()
    

Get the permissions attached to this channel

Returns:
    

A list of permission items, each containing the group name or user login it applies to and whether the item allows the group/user to use the channel
    
    
    [
        { "group": "some_group_name", canUse: True },
        { "user": "user1_login", canUse: True },
    ]
    

Return type:
    

list[dict]

set_permissions(_permissions_)
    

Sets the permissions on this channel

Usage example:
    
    
    channel_permissions = channel.get_permissions()
    channel_permissions.append({ 'group':'data_scientists', 'canUse': True })
    channel.set_permissions(channel_permissions)
    

Parameters:
    

**permissions** (_dict_) – a permissions list with the same structure as the one returned by `get_permissions()` call

delete()
    

Deletes this messaging channel. Requires admin privileges.
    
    
    channel = client.get_messaging_channel("my_channel_id")
    channel.delete()
    

_class _dataikuapi.dss.messaging_channel.DSSMailMessagingChannel(_client_ , _data_)
    

A handle to interact with an email messaging channel on the DSS instance - a subclass of `DSSMessagingChannel`

Important

Do not instantiate this class directly, use [`dataikuapi.DSSClient.get_messaging_channel()`](<client.html#dataikuapi.DSSClient.get_messaging_channel> "dataikuapi.DSSClient.get_messaging_channel")

_property _sender
    

Sender for the messaging channel, if present

Return type:
    

str

_property _use_current_user_as_sender
    

Indicates whether the messaging channel will use the address of the current user as sender. If True and the current user has no associated email address, the sender property is used instead.

Return type:
    

bool

send(_project_key_ , _to_ , _subject_ , _body_ , _attachments =None_, _plain_text =False_, _sender =None_, _cc =None_, _bcc =None_)
    

Send an email with or without attachments to a list of recipients
    
    
    channel = client.get_messaging_channel("mail-channel-id")
    channel.send("PROJECT_KEY", ["[[email protected]](</cdn-cgi/l/email-protection>)", "[[email protected]](</cdn-cgi/l/email-protection>)"], "Hello there!", "<html><body>Some HTML body</body></html>")
    
    channel = client.get_messaging_channel("other-mail-channel-id")
    for file in paths:
    with open(file) as f:
        # Optionally include file type ("text/csv")
        attachments.append(file, f.read(), "text/csv")
    channel.send("PROJECT_KEY", ["[[email protected]](</cdn-cgi/l/email-protection>)"], "Subject", "Body in plain text",  attachments=attachments, False)
    

Parameters:
    

  * **project_key** (_str_) – project issuing the email. The user must have “Write content” permission on the specified project.

  * **to** (_list_ _[__str_ _]_) – email addresses of recipients

  * **subject** (_str_) – email subject

  * **body** (_str_) – email body (in plain text or HTML format)

  * **attachments** (_list_ _[__BufferedReader_ _]_) – files to be attached to the mail, defaults to None

  * **plain_text** (_bool_) – True to send email as plain text, False to send it as HTML. Defaults to False.

  * **sender** (_str_) – sender email address. Use None to use the sender defined at the channel level.

  * **cc** (_list_ _[__str_ _]_) – email addresses of recipients in carbon copy

  * **bcc** (_list_ _[__str_ _]_) – email addresses of recipients in blind carbon copy




_class _dataikuapi.dss.messaging_channel.DSSMessagingChannelCreator(_channel_type_ , _client_)
    

Helper to create new messaging channels.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_id(_channel_id_)
    

Add an ID to the messaging-channel-to-be-created.

Parameters:
    

**channel_id** (_string_) – unique ID

create()
    

Creates the new messaging channel, and return a handle to interact with it. Requires admin privileges.

Return type:
    

`DSSMessagingChannel`

Returns:
    

The created messaging channel object, such as `DSSMessagingChannel`, or a `DSSMessagingChannel` for a mail channel

with_permissions(_authorized_groups_ , _authorized_users_)
    

Replace the permission configuration for this channel. By default, a channel is usable by anyone, but if this method is used, the channel will be restricted to the specified users and groups

Parameters:
    

  * **authorized_groups** (_List_ _[__string_ _]_) – group ids to authorize

  * **authorized_users** (_List_ _[__string_ _]_) – user logins to authorize



Returns:
    

the current DSSMessagingChannelCreator

_class _dataikuapi.dss.messaging_channel.MailMessagingChannelCreator(_channel_type_ , _client_)
    

Helper to create new mail messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_current_user_as_sender(_use_current_user_as_sender_)
    

Add a “use current user as sender” option to the messaging-channel-to-be-created.

Parameters:
    

**use_current_user_as_sender** (_bool_) – True to use the email of the user triggering the action as sender, False otherwise. Has precedence over ‘sender’ property.

with_sender(_sender_)
    

Add a sender to the messaging-channel-to-be-created.

Parameters:
    

**sender** (_string_) – sender email, use an adhoc provided email if not provided.

with_authorized_domains(_authorized_domains_)
    

Add authorized domains to the messaging-channel-to-be-created.

Parameters:
    

**authorized_domains** (_list_ _[__str_ _]_) – comma-separated list of authorized domains for “To” addresses.

_class _dataikuapi.dss.messaging_channel.SMTPMessagingChannelCreator(_client_)
    

Helper to create new SMTP messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_host(_host_)
    

Add a host to the messaging-channel-to-be-created.

Parameters:
    

**host** (_string_) – host to connect to.

with_port(_port_)
    

Add a port to the messaging-channel-to-be-created.

Parameters:
    

**port** (_long_) – port to connect to.

with_ssl(_use_ssl_)
    

Add SSL option to the messaging-channel-to-be-created.

Parameters:
    

**use_ssl** (_bool_) – True to use SSL, False otherwise.

with_tls(_use_tls_)
    

Add TLS option to the messaging-channel-to-be-created.

Parameters:
    

**use_tls** (_bool_) – True to use TLS, False otherwise.

with_session_properties(_session_properties_)
    

Add session properties to the messaging-channel-to-be-created.

Parameters:
    

**session_properties** (_list_ _[__dict_ _]_) – Array of dictionaries with “key” and “value” keys set for session extra properties.

with_login(_login_)
    

Add a login to the messaging-channel-to-be-created.

Parameters:
    

**login** (_string_) – user login.

with_password(_password_)
    

Add a password to the messaging-channel-to-be-created.

Parameters:
    

**password** (_string_) – user password.

_class _dataikuapi.dss.messaging_channel.AWSSESMailMessagingChannelCreator(_client_)
    

Helper to create new AWS SES mail messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_access_key(_access_key_)
    

Add an access key to the messaging-channel-to-be-created.

Parameters:
    

**access_key** (_string_) – AWS access key.

with_secret_key(_secret_key_)
    

Add a secret key to the messaging-channel-to-be-created.

Parameters:
    

**secret_key** (_string_) – AWS secret key.

with_region_or_endpoint(_region_or_endpoint_)
    

Add a region or an endpoint to the messaging-channel-to-be-created.

Parameters:
    

**region_or_endpoint** (_string_) – AWS region or custom endpoint.

_class _dataikuapi.dss.messaging_channel.MicrosoftGraphMailMessagingChannelCreator(_client_)
    

Helper to create new Microsoft Graph mail messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_client_id(_client_id_)
    

Add a client ID to the messaging-channel-to-be-created.

Parameters:
    

**client_id** (_string_) – Microsoft application ID.

with_tenant_id(_tenant_id_)
    

Add a tenant ID to the messaging-channel-to-be-created.

Parameters:
    

**tenant_id** (_string_) – Microsoft directory ID.

with_client_secret(_client_secret_)
    

Add a client secret to the messaging-channel-to-be-created.

Parameters:
    

**client_secret** (_string_) – Account used to sent mails with this channel. Must be a User Principal Name with a valid Microsoft 365 license.

_class _dataikuapi.dss.messaging_channel.ProxyableMessagingChannelCreator(_channel_type_ , _client_)
    

Helper to create new proxyable messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_proxy(_use_proxy_)
    

Add a proxy to the messaging-channel-to-be-created.

Parameters:
    

**use_proxy** (_bool_) – True to use DSS’s proxy settings to connect, False otherwise.

_class _dataikuapi.dss.messaging_channel.WebhookMessagingChannelCreator(_channel_type_ , _client_)
    

Helper to create new webhook-using messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_webhook_url(_webhook_url_)
    

Add a webhook url to the messaging-channel-to-be-created.

Parameters:
    

**webhook_url** (_string_) – webhook URL for “WEBHOOK” mode.

_class _dataikuapi.dss.messaging_channel.SlackMessagingChannelCreator(_client_)
    

Helper to create new Slack messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_mode(_mode_)
    

Add a mode to the messaging-channel-to-be-created.

Parameters:
    

**mode** (_string_) – connection mode. Can be “WEBHOOK” or “API”.

with_authorization_token(_authorization_token_)
    

Add an authorization token to the messaging-channel-to-be-created.

Parameters:
    

**authorization_token** (_string_) – authorization token for “API” mode.

with_channel(_channel_id_)
    

Add a Slack channel ID to the messaging-channel-to-be-created.

Parameters:
    

**channel_id** (_string_) – Slack channel ID.

_class _dataikuapi.dss.messaging_channel.MSTeamsMessagingChannelCreator(_client_)
    

Helper to create new Microsoft Teams messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_webhook_type(_webhook_type_)
    

Add a webhook type to the messaging-channel-to-be-created.

Parameters:
    

**webhook_type** (_string_) – type of webhook to use. Can be “WORKFLOWS” or “OFFICE365” (legacy).

_class _dataikuapi.dss.messaging_channel.GoogleChatMessagingChannelCreator(_client_)
    

Helper to create new Google Chat messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_webhook_key(_webhook_key_)
    

Add a webhook key to the messaging-channel-to-be-created.

Parameters:
    

**webhook_key** (_string_) – key parameter for the webhook URL (mandatory if not included in the URL).

with_webhook_token(_webhook_token_)
    

Add a webhook token to the messaging-channel-to-be-created.

Parameters:
    

**webhook_token** (_string_) – token parameter for the webhook URL (mandatory if not included in the URL).

_class _dataikuapi.dss.messaging_channel.TwilioMessagingChannelCreator(_client_)
    

Helper to create new Twilio messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_account_sid(_account_sid_)
    

Add an account SID to the messaging-channel-to-be-created.

Parameters:
    

**account_sid** (_string_) – Twilio account SID.

with_auth_token(_auth_token_)
    

Add an authorization token to the messaging-channel-to-be-created.

Parameters:
    

**auth_token** (_string_) – authorization token.

with_from_number(_from_number_)
    

Add a “from number” option to the messaging-channel-to-be-created.

Parameters:
    

**from_number** (_long_) – Twilio from number.

_class _dataikuapi.dss.messaging_channel.ShellMessagingChannelCreator(_client_)
    

Helper to create new shell messaging channels

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.new_messaging_channel()`](<client.html#dataikuapi.DSSClient.new_messaging_channel> "dataikuapi.DSSClient.new_messaging_channel") instead.

with_type(_execution_type_)
    

Add an execution type to the messaging-channel-to-be-created.

Parameters:
    

**execution_type** (_string_) – Type of shell execution. Can be “COMMAND” or “FILE”.

with_command(_command_)
    

Add a command to the messaging-channel-to-be-created.

Parameters:
    

**command** (_string_) – command to execute. In “FILE” mode this string will be passed to the -c switch.

with_script(_script_)
    

Add a script to the messaging-channel-to-be-created.

Parameters:
    

**script** (_string_) – script content to execute for mode “FILE”.

---

## [api-reference/python/metrics]

# Metrics and checks

Note

There are two main parts related to handling of metrics and checks in Dataiku’s Python APIs:

  * `dataiku.core.metrics.ComputedMetrics` in the dataiku package. It was initially designed for usage within DSS

  * `dataikuapi.dss.metrics.ComputedMetrics` in the dataikuapi package. It was initially designed for usage outside of DSS.




Both classes have fairly similar capabilities

For usage information and examples, see [Metrics and checks](<../../concepts-and-examples/metrics.html>)

## dataiku package API

_class _dataiku.core.metrics.ComputedMetrics(_raw_)
    

Handle to the metrics of a DSS object and their last computed value

Important

Do not create this class directly, instead use [`dataiku.Dataset.get_last_metric_values()`](<datasets.html#dataiku.Dataset.get_last_metric_values> "dataiku.Dataset.get_last_metric_values"), [`dataiku.Folder.get_last_metric_values()`](<managed-folders.html#dataiku.Folder.get_last_metric_values> "dataiku.Folder.get_last_metric_values"), [`dataiku.ModelEvaluationStore.get_last_metric_values()`](<model-evaluation-stores.html#dataiku.ModelEvaluationStore.get_last_metric_values> "dataiku.ModelEvaluationStore.get_last_metric_values") or [`dataiku.Project.get_last_metric_values()`](<projects.html#dataiku.Project.get_last_metric_values> "dataiku.Project.get_last_metric_values")

get_metric_by_id(_metric_id_)
    

Retrieve the info for a given metric

Usage example
    
    
    dataset = dataiku.Dataset("my_dataset")
    metrics = dataset.get_last_metric_values()
    count_files_metric = metrics.get_metric_by_id("basic:COUNT_FILES")
    for value in count_files_metric['lastValues']:
        print("partition=%s -> count of files=%s" % (value['partition'], value['value']))        
    

Parameters:
    

**metric_id** (_string_) – identifier of the metric

Returns:
    

information about the metric and its values. Top-level fields are

  * **metric** : definition of the metric

  * **meta** : display metadata, as a dict of **name** and **fullName**

  * **computingProbe** : name of the probe that computes the metric

  * **displayedAsMetric** : whether the metric is among the metrics displayed on the “Status” tab of the object

  * **notExistingViews** : list of the possible types of metrics datasets not yet created on the object

  * **partitionsWithValue** : list of the partition identifiers for which some value of the metric exists

  * **lastValues** : list of the last computed value, per partition. Each list element has

>     * **partition** : the partition identifier, as a string.
> 
>     * **value** : the metric value, as a string
> 
>     * **dataType** : expected type of **value** (one of BIGINT, DOUBLE, STRING, BOOLEAN)
> 
>     * **computed** : timestamp of computation, in milliseconds since epoch




Return type:
    

dict

get_global_data(_metric_id_)
    

Get the global value point of a given metric, or throws.

For a partitioned dataset, the global value is the value of the metric computed on the whole dataset (coded as partition ‘ALL’).

Parameters:
    

**metric_id** (_string_) – identifier of the metric

Returns:
    

the metric data, as a dict. Fields are

  * **partition** : the partition identifier, as a string.

  * **value** : the metric value, as a string

  * **dataType** : expected type of **value** (one of BIGINT, DOUBLE, STRING, BOOLEAN)

  * **computed** : timestamp of computation, in milliseconds since epoch




Return type:
    

dict

get_global_value(_metric_id_)
    

Get the global value of a given metric, or throws.

For a partitioned dataset, the global value is the value of the metric computed on the whole dataset (coded as partition ‘ALL’).

Usage example
    
    
    dataset = dataiku.Dataset("my_dataset")
    metrics = dataset.get_last_metric_values()
    print("record count = %s" % metrics.get_global_value('records:COUNT_RECORDS'))
    

Parameters:
    

**metric_id** (_string_) – identifier of the metric

Returns:
    

the value of the metric for the partition

Return type:
    

str, int or float

get_partition_data(_metric_id_ , _partition_)
    

Get the value point of a given metric for a given partition, or throws.

Parameters:
    

  * **metric_id** (_string_) – identifier of the metric

  * **partition** (_string_) – partition identifier



Returns:
    

the metric data, as a dict. Fields are

  * **partition** : the partition identifier, as a string.

  * **value** : the metric value, as a string

  * **dataType** : expected type of **value** (one of BIGINT, DOUBLE, STRING, BOOLEAN)

  * **computed** : timestamp of computation, in milliseconds since epoch




Return type:
    

dict

get_partition_value(_metric_id_ , _partition_)
    

Get the value of a given metric for a given partition, or throws.

Parameters:
    

  * **metric_id** (_string_) – identifier of the metric

  * **partition** (_string_) – partition identifier



Returns:
    

the value of the metric for the partition

Return type:
    

str, int or float

get_first_partition_data(_metric_id_)
    

Get a value point of a given metric, or throws. The first value encountered is returned.

Parameters:
    

**metric_id** (_string_) – identifier of the metric

Returns:
    

the metric data, as a dict. Fields are

  * **partition** : the partition identifier, as a string.

  * **value** : the metric value, as a string

  * **dataType** : expected type of **value** (one of BIGINT, DOUBLE, STRING, BOOLEAN)

  * **computed** : timestamp of computation, in milliseconds since epoch




Return type:
    

dict

get_partition_data_for_version(_metric_id_ , _version_id_)
    

Get the metric of the first partition matching version_id, for saved models

Parameters:
    

  * **metric_id** (_string_) – identifier of the metric

  * **version_id** (_string_) – identifier of the version



Returns:
    

the metric data, as a dict. Fields are

  * **partition** : the partition identifier, as a string.

  * **value** : the metric value, as a string

  * **dataType** : expected type of **value** (one of BIGINT, DOUBLE, STRING, BOOLEAN)

  * **computed** : timestamp of computation, in milliseconds since epoch




Return type:
    

dict

get_all_ids()
    

Get the identifiers of all metrics defined in this object

Returns:
    

list of metric identifiers

Return type:
    

list[string]

_static _get_value_from_data(_data_)
    

Retrieves the value from a metric point, cast in the appropriate type (str, int or float).

For other types, the value is not cast and left as a string.

Parameters:
    

**data** (_dict_) – a value point for a metric, retrieved with `get_global_data()` or `get_partition_data()`

Returns:
    

the value, cast to the appropriate Python type

Return type:
    

str, int or float

_class _dataiku.core.metrics.MetricDataPoint(_raw_)
    

A value of a metric, on a partition

Note

Instances of this class are only created by Python checks

get_metric()
    

Get the definition of the metric

Returns:
    

a dict defining the metric. Fields are

  * **id** : the metric full identifier

  * **type** : type of the probe computing the metric

  * **metricType** : type of the metric for the probe

  * **dataType** : type of the value computed (of BIGINT, DOUBLE, STRING, BOOLEAN)

  * **column** : (optional) name of the column the metric is computed for




Return type:
    

dict

get_metric_id()
    

Get the metric’s full identifier.

Return type:
    

string

get_partition()
    

Get the identifier of the partition on which the value was computed.

Return type:
    

string

get_value()
    

Get the raw value of the metric.

Usage example:
    
    
    # the code for a Python check that errors if there are more 
    # than 10k records in the dataset.
    # the parameters of process() are filled by DSS:
    # - last_values is a dict of metric name to MetricDataPoint
    # - dataset is a handle on the dataset
    # - partition_id is the partition for which the check is run
    def process(last_values, dataset, partition_id):
        # get the MetricDataPoint
        last_known_record_count = last_values.get('records:COUNT_RECORDS')
        if last_known_record_count is None:
            return 'EMPTY', 'Record count not yet computed'
        record_count = int(last_known_record_count.get_value())
        if record_count < 10000:    
            return 'OK'
        else:
            return 'ERROR', 'Too many records'        
    

Return type:
    

string

get_compute_time()
    

Get the time at which the value was computed.

Return type:
    

`datetime.datetime`

get_type()
    

Get the type of the value.

Returns:
    

a type, of BIGINT, DOUBLE, BOOLEAN, STRING

Return type:
    

string

_class _dataiku.core.metrics.ComputedChecks(_raw_)
    

Handle to the checks of a DSS object and their last computed value

Important

Do not create this class directly, instead use [`dataiku.Project.get_last_check_values()`](<projects.html#dataiku.Project.get_last_check_values> "dataiku.Project.get_last_check_values")

get_check_by_name(_check_name_)
    

Retrive the info for a given check

Parameters:
    

**check_name** (_string_) – identifier of the check

get_global_data(_check_name_)
    

Get the global value point of a given check, or throws.

For a partitioned dataset, the global value is the value of the check computed on the whole dataset (coded as partition ‘ALL’).

Parameters:
    

**check_name** (_string_) – identifier of the check

Returns:
    

the check data, as a dict. Fields are

  * **partition** : the partition identifier, as a string.

  * **outcome** : one of OK, ERROR, WARNING, EMPTY

  * **message** : (optional) message of the check

  * **computed** : timestamp of computation, in milliseconds since epoch




Return type:
    

dict

get_global_value(_check_name_)
    

Get the global value of a given check, or throws.

For a partitioned dataset, the global value is the value of the check computed on the whole dataset (coded as partition ‘ALL’).

Parameters:
    

**check_name** (_string_) – identifier of the check

Returns:
    

outcome of the check (OK, ERROR, WARNING or EMPTY)

Return type:
    

string

get_partition_data(_check_name_ , _partition_)
    

Get the value point of a given check for a given partition, or throws.

Parameters:
    

  * **check_name** (_string_) – identifier of the check

  * **partition** (_string_) – partition identifier



Returns:
    

the check data, as a dict. Fields are

  * **partition** : the partition identifier, as a string.

  * **outcome** : one of OK, ERROR, WARNING, EMPTY

  * **message** : (optional) message of the check

  * **computed** : timestamp of computation, in milliseconds since epoch




Return type:
    

dict

get_partition_value(_check_name_ , _partition_)
    

Get the value of a given check for a given partition, or throws.

Parameters:
    

  * **check_name** (_string_) – identifier of the check

  * **partition** (_string_) – partition identifier



Returns:
    

outcome of the check for this partition (OK, ERROR, WARNING or EMPTY)

Return type:
    

string

get_first_partition_data(_check_name_)
    

Get a value point of a given check, or throws. The first value encountered is returned.

Parameters:
    

**check_name** (_string_) – identifier of the check

Returns:
    

the check data, as a dict. Fields are

  * **partition** : the partition identifier, as a string.

  * **outcome** : one of OK, ERROR, WARNING, EMPTY

  * **message** : (optional) message of the check

  * **computed** : timestamp of computation, in milliseconds since epoch




Return type:
    

dict

get_partition_data_for_version(_check_name_ , _version_id_)
    

Get the check of the first partition matching version_id, for saved models

Parameters:
    

  * **check_name** (_string_) – identifier of the check

  * **version_id** (_string_) – identifier of the version



Returns:
    

the check data, as a dict. Fields are

  * **partition** : the partition identifier, as a string.

  * **outcome** : one of OK, ERROR, WARNING, EMPTY

  * **message** : (optional) message of the check

  * **computed** : timestamp of computation, in milliseconds since epoch




Return type:
    

dict

get_all_names()
    

Get the identifiers of all checks defined in this object

Returns:
    

list of check identifiers

Return type:
    

list[string]

_static _get_outcome_from_data(_data_)
    

Retrieves the value from a check data point

Parameters:
    

**data** (_dict_) – a value point for a check, retrieved with `get_global_data()` or `get_partition_data()`

Returns:
    

a check result (OK, ERROR, WARNING or EMPTY)

Return type:
    

string

_class _dataiku.core.metrics.CheckDataPoint(_raw_)
    

A value of a check, on a partition

Note

Instances of this class are only created by Python checks

get_check()
    

Returns the definition of the check

Returns:
    

a dict of the check definition. Notable fields are

  * **type** : the type of check

  * **meta** : the display metadata, as a dict of **name** and **label**




Return type:
    

dict

get_partition()
    

Returns the partition on which the value was computed

Returns:
    

a partition identifier

Return type:
    

string

get_value()
    

Returns the value of the check, as a string

Returns:
    

one of OK, ERROR, WARNING, EMPTY (means “no data, check can’t be computed”)

Return type:
    

string

get_compute_time()
    

Returns the time at which the value was computed

Return type:
    

`datetime.datetime`

## dataikuapi package API

_class _dataikuapi.dss.metrics.ComputedMetrics(_raw_)
    

Handle to the metrics of a DSS object and their last computed value

Important

Do not create this class directly, instead use [`DSSDataset.get_last_metric_values()`](<datasets.html#dataikuapi.dss.dataset.DSSDataset.get_last_metric_values> "dataikuapi.dss.dataset.DSSDataset.get_last_metric_values"), [`DSSSavedModel.get_metric_values()`](<ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.get_metric_values> "dataikuapi.dss.savedmodel.DSSSavedModel.get_metric_values"), [`DSSManagedFolder.get_last_metric_values()`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder.get_last_metric_values> "dataikuapi.dss.managedfolder.DSSManagedFolder.get_last_metric_values").

get_metric_by_id(_id_)
    

Retrieve the info for a given metric

Usage example
    
    
    dataset = project.get_ataset("my_dataset")
    metrics = dataset.get_last_metric_values()
    count_files_metric = metrics.get_metric_by_id("basic:COUNT_FILES")
    for value in count_files_metric['lastValues']:
        print("partition=%s -> count of files=%s" % (value['partition'], value['value']))        
    

Parameters:
    

**metric_id** (_string_) – identifier of the metric

Returns:
    

information about the metric and its values. Since the last value of the metric depends on the partition considered, the last values of the metric are given in a sub-list of the dict.

Return type:
    

dict

get_global_data(_metric_id_)
    

Get the global value point of a given metric, or throws.

For a partitioned dataset, the global value is the value of the metric computed on the whole dataset (coded as partition ‘ALL’).

Parameters:
    

**metric_id** (_string_) – identifier of the metric

Returns:
    

the metric data, as a dict. The value itself is a **value** string field.

Return type:
    

dict

get_global_value(_metric_id_)
    

Get the global value of a given metric, or throws.

For a partitioned dataset, the global value is the value of the metric computed on the whole dataset (coded as partition ‘ALL’).

Usage example
    
    
    dataset = project.get_ataset("my_dataset")
    metrics = dataset.get_last_metric_values()
    print("record count = %s" % metrics.get_global_value('records:COUNT_RECORDS'))
    

Parameters:
    

**metric_id** (_string_) – identifier of the metric

Returns:
    

the value of the metric for the partition

Return type:
    

str, int or float

get_partition_data(_metric_id_ , _partition_)
    

Get the value point of a given metric for a given partition, or throws.

Parameters:
    

  * **metric_id** (_string_) – identifier of the metric

  * **partition** (_string_) – partition identifier



Returns:
    

the metric data, as a dict. The value itself is a **value** string field.

Return type:
    

dict

get_partition_value(_metric_id_ , _partition_)
    

Get the value of a given metric for a given partition, or throws.

Parameters:
    

  * **metric_id** (_string_) – identifier of the metric

  * **partition** (_string_) – partition identifier



Returns:
    

the value of the metric for the partition

Return type:
    

str, int or float

get_first_partition_data(_metric_id_)
    

Get a value point of a given metric, or throws. The first value encountered is returned.

Parameters:
    

**metric_id** (_string_) – identifier of the metric

Returns:
    

the metric data, as a dict. The value itself is a **value** string field.

Return type:
    

dict

get_all_ids()
    

Get the identifiers of all metrics defined in this object

Returns:
    

list of metric identifiers

Return type:
    

list[string]

_static _get_value_from_data(_data_)
    

Retrieves the value from a metric point, cast in the appropriate type (str, int or float).

For other types, the value is not cast and left as a string.

Parameters:
    

**data** (_dict_) – a value point for a metric, retrieved with `get_global_data()`, `get_partition_data()` or `get_first_partition_data()`

Returns:
    

the value, cast to the appropriate Python type

Return type:
    

str, int or float

---

## [api-reference/python/ml]

# Machine learning

For usage information and examples, see [Visual Machine learning](<../../concepts-and-examples/ml.html>)

## API Reference

### Interaction with a ML Task

_class _dataikuapi.dss.ml.DSSMLTask(_client_ , _project_key_ , _analysis_id_ , _mltask_id_)
    

A handle to interact with a ML Task for prediction or clustering in a DSS visual analysis.

Important

To create a new ML Task, use one of the following methods: [`dataikuapi.dss.project.DSSProject.create_prediction_ml_task()`](<projects.html#dataikuapi.dss.project.DSSProject.create_prediction_ml_task> "dataikuapi.dss.project.DSSProject.create_prediction_ml_task"), [`dataikuapi.dss.project.DSSProject.create_clustering_ml_task()`](<projects.html#dataikuapi.dss.project.DSSProject.create_clustering_ml_task> "dataikuapi.dss.project.DSSProject.create_clustering_ml_task") or [`dataikuapi.dss.project.DSSProject.create_timeseries_forecasting_ml_task()`](<projects.html#dataikuapi.dss.project.DSSProject.create_timeseries_forecasting_ml_task> "dataikuapi.dss.project.DSSProject.create_timeseries_forecasting_ml_task").

_static _from_full_model_id(_client_ , _fmi_ , _project_key =None_)
    

Static method returning a DSSMLTask object representing a pre-existing ML Task

Parameters:
    

  * **client** ([`DSSClient`](<client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient")) – An instantiated DSSClient

  * **fmi** (_str_) – The Full Model ID of the ML Task

  * **project_key** (_str_ _,__optional_) – The project key of the project containing the ML Task (defaults to **None**)



Returns:
    

The DSSMLTask

Return type:
    

`DSSMLTask`

delete()
    

Deletes the ML task

wait_guess_complete()
    

Waits for the ML Task guessing to be complete.

This should be called immediately after the creation of a new ML Task if the ML Task was created with `wait_guess_complete = False`, before calling `get_settings()` or `train()`.

get_status()
    

Gets the status of this ML Task

Returns:
    

A dictionary containing the ML Task status

Return type:
    

dict

get_settings()
    

Gets the settings of this ML Task.

This should be used whenever you need to modify the settings of an existing ML Task.

Returns:
    

A DSSMLTaskSettings object.

Return type:
    

`dataikuapi.dss.ml.DSSMLTaskSettings`

train(_session_name =None_, _session_description =None_, _run_queue =False_)
    

Trains models for this ML Task.

This method waits for training to complete. If you instead want to train asynchronously, use `start_train()` and `wait_train_complete()`.

This method returns a list of trained model identifiers. These refer to models that have been trained during this specific training session, rather than all of the trained models available on this ML task. To get all identifiers for all models trained across all training sessions, use `get_trained_models_ids()`.

These identifiers can be used for `get_trained_model_snippet()`, `get_trained_model_details()` and `deploy_to_flow()`.

Parameters:
    

  * **session_name** (_str_ _,__optional_) – Optional name for the session (defaults to **None**)

  * **session_description** (_str_ _,__optional_) – Optional description for the session (defaults to **None**)

  * **run_queue** (_bool_) – Whether to run any queued sessions after the training completes (defaults to **False**)



Returns:
    

A list of model identifiers

Return type:
    

list[str]

ensemble(_model_ids_ , _method_)
    

Creates an ensemble model from a set of models.

This method waits for the ensemble training to complete. If you want to train asynchronously, use `start_ensembling()` and `wait_train_complete()`.

This method returns the identifier of the trained ensemble. To get all identifiers for all models trained across all training sessions, use `get_trained_models_ids()`.

This returned identifier can be used for `get_trained_model_snippet()`, `get_trained_model_details()` and `deploy_to_flow()`.

Parameters:
    

  * **model_ids** (_list_ _[__str_ _]_) – A list of model identifiers to ensemble (must not be empty)

  * **method** (_str_) – The ensembling method. Must be one of: AVERAGE, PROBA_AVERAGE, MEDIAN, VOTE, LINEAR_MODEL, LOGISTIC_MODEL



Returns:
    

The model identifier of the resulting ensemble model

Return type:
    

str

start_train(_session_name =None_, _session_description =None_, _run_queue =False_)
    

Starts asynchronously a new training session for this ML Task.

This returns immediately, before training is complete. To wait for training to complete, use `wait_train_complete()`.

Parameters:
    

  * **session_name** (_str_ _,__optional_) – Optional name for the session (defaults to **None**)

  * **session_description** (_str_ _,__optional_) – Optional description for the session (defaults to **None**)

  * **run_queue** (_bool_) – Whether to run any queued sessions after the training completes (defaults to **False**)




start_ensembling(_model_ids_ , _method_)
    

Creates asynchronously an ensemble model from a set of models

This returns immediately, before training is complete. To wait for training to complete, use `wait_train_complete()`

Parameters:
    

  * **model_ids** (_list_ _[__str_ _]_) – A list of model identifiers to ensemble (must not be empty)

  * **method** (_str_) – The ensembling method. Must be one of: AVERAGE, PROBA_AVERAGE, MEDIAN, VOTE, LINEAR_MODEL, LOGISTIC_MODEL



Returns:
    

The model identifier of the ensemble

Return type:
    

str

wait_train_complete()
    

Waits for training to be completed

To be used following any asynchronous training started with `start_train()` or `start_ensembling()`

get_trained_models_ids(_session_id =None_, _algorithm =None_)
    

Gets the list of trained model identifiers for this ML task.

These identifiers can be used for `get_trained_model_snippet()` and `deploy_to_flow()`.

The two optional filter params can be used together.

Parameters:
    

  * **session_id** (_str_ _,__optional_) – Optional filter to return only IDs of models from a specific session.

  * **algorithm** (_str_ _,__optional_) – Optional filter to return only IDs of models with a specific algorithm.



Returns:
    

A list of model identifiers

Return type:
    

list[str]

get_trained_model_snippet(_id =None_, _ids =None_)
    

Gets a quick summary of a trained model, as a dict.

This method can either be given a single model id, via the id param, or a list of model ids, via the ids param.

For complete model information and a structured object, use `get_trained_model_details()`.

Parameters:
    

  * **id** (_str_ _,__optional_) – A model id (defaults to **None**)

  * **ids** (_list_ _[__str_ _]_) – A list of model ids (defaults to **None**)



Returns:
    

Either a quick summary of one trained model as a dict, or a list of model summary dicts

Return type:
    

Union[dict, list[dict]]

get_trained_model_details(_id_)
    

Gets details for a trained model.

Parameters:
    

**id** (_str_) – Identifier of the trained model, as returned by `get_trained_models_ids()`

Returns:
    

A `DSSTrainedPredictionModelDetails` or `DSSTrainedClusteringModelDetails` representing the details of this trained model.

Return type:
    

Union[`DSSTrainedPredictionModelDetails`, `DSSTrainedClusteringModelDetails`, `DSSTrainedTimeseriesForecastingModelDetails`]

delete_trained_model(_model_id_)
    

Deletes a trained model

Parameters:
    

**model_id** (_str_) – Model identifier, as returned by `get_trained_models_ids()`.

train_queue()
    

Trains each session in this ML Task’s queue, or until the queue is paused.

Returns:
    

A dict including the next sessionID to be trained in the queue

Return type:
    

dict

deploy_to_flow(_model_id_ , _model_name_ , _train_dataset_ , _test_dataset =None_, _redo_optimization =True_)
    

Deploys a trained model from this ML Task to the flow.

Creates a new saved model and its parent training recipe in the Flow.

Parameters:
    

  * **model_id** (_str_) – Model identifier, as returned by `get_trained_models_ids()`

  * **model_name** (_str_) – Name of the saved model when deployed to the Flow

  * **train_dataset** (_str_) – Name of the dataset to use as train set. May either be a short name or a PROJECT.name long name (when using a shared dataset)

  * **test_dataset** (_str_ _,__optional_) – Name of the dataset to use as test set. If None (default), the train/test split will be applied over the train set. Only for PREDICTION tasks. May either be a short name or a PROJECT.name long name (when using a shared dataset).

  * **redo_optimization** (_bool_) – Whether to redo the hyperparameter optimization phase (defaults to **True**). Only for PREDICTION tasks.



Returns:
    

A dict containing: “savedModelId” and “trainRecipeName” - Both can be used to obtain further handles

Return type:
    

dict

redeploy_to_flow(_model_id_ , _recipe_name =None_, _saved_model_id =None_, _activate =True_, _redo_optimization =False_, _redo_threshold_optimization =True_, _fixed_threshold =None_)
    

Redeploys a trained model from this ML Task to an existing saved model and training recipe in the flow.

Either the training recipe recipe_name or the saved_model_id needs to be specified.

Parameters:
    

  * **model_id** (_str_) – Model identifier, as returned by `get_trained_models_ids()`

  * **recipe_name** (_str_ _,__optional_) – Name of the training recipe to update (defaults to **None**)

  * **saved_model_id** (_str_ _,__optional_) – Name of the saved model to update (defaults to **None**)

  * **activate** (_bool_) – If True (default), make the newly deployed model version become the active version

  * **redo_optimization** (_bool_) – Whether to re-run the model optimization (hyperparameter search) on every train

  * **redo_threshold_optimization** (_bool_) – Whether to redo the model threshold Optimization on every train (for binary classification models)

  * **fixed_threshold** (_float_ _,__optional_) – Value to use as fixed threshold. Must be set if redoThresholdOptimization is False (for binary classification models)



Returns:
    

A dict containing: “impactsDownstream” - whether the active saved mode version changed and downstream recipes are impacted

Return type:
    

dict

remove_unused_splits()
    

Deletes all stored split data that is no longer in use for this ML Task.

You should generally not need to call this method.

remove_all_splits()
    

Deletes all stored split data for this ML Task.

This operation saves disk space.

After performing this operation, it will not be possible anymore to:

  * Ensemble already trained models

  * View the “predicted data” or “charts” for already trained models

  * Resume training of models for which optimization had been previously interrupted




Training new models remains possible

guess(_prediction_type =None_, _reguess_level =None_, _target_variable =None_, _timeseries_identifiers =None_, _time_variable =None_, _full_reguess =None_)
    

Reguess the settings of the ML Task.

When no optional parameters are given, this will reguess all the settings of the ML Task.

For prediction ML tasks only, a new target variable or prediction type can be passed, and this will subsequently reguess the impacted settings.

Parameters:
    

  * **prediction_type** (_str_ _,__optional_) – The desired prediction type. Only valid for prediction tasks of either BINARY_CLASSIFICATION, MULTICLASS or REGRESSION type, ignored otherwise. Cannot be set if either target_variable, time_variable, or timeseries_identifiers is also specified. (defaults to **None**)

  * **target_variable** (_str_ _,__optional_) – The desired target variable. Only valid for prediction tasks, ignored for clustering. Cannot be set if either prediction_type, time_variable, or timeseries_identifiers is also specified. (defaults to **None**)

  * **timeseries_identifiers** (_list_ _[__str_ _]__,__optional_) – Only valid for time series forecasting tasks. List of columns to be used as time series identifiers. Cannot be set if either prediction_type, target_variable, or time_variable is also specified. (defaults to **None**)

  * **time_variable** (_str_ _,__optional_) – The desired time variable column. Only valid for time series forecasting tasks. Cannot be set if either prediction_type, target_variable, or timeseries_identifiers is also specified. (defaults to **None**)

  * **full_reguess** (_bool_ _,__optional_) – Scope of the reguess process: whether it should reguess all the settings after changing a core parameter, or only reguess impacted settings (e.g. target remapping when changing the target, metrics when changing the prediction type…). Ignored if no core parameter is given. Only valid for prediction tasks and therefore also ignored for clustering. (defaults to **True**)

  * **reguess_level** (_str_ _,__optional_) – 

Deprecated, use full_reguess instead. Only valid for prediction tasks. Can be one of the following values:

    * TARGET_CHANGE: Change the target if target_variable is specified, reguess the target remapping, and clear the model’s assertions if any. Equivalent to `full_reguess=False` (recommended usage)

    * FULL_REGUESS: All the settings of the ML task are reguessed. Equivalent to `full_reguess=True` (recommended usage)




### Manipulation of settings

_class _dataikuapi.dss.ml.HyperparameterSearchSettings(_raw_settings_)
    

Object to read and modify hyperparameter search settings.

This is available for all non-clustering ML Tasks.

Important

Do not create this class directly, use `AbstractTabularPredictionMLTaskSettings.get_hyperparameter_search_settings()`

_property _strategy
    

Returns:
    

The hyperparameter search strategy. Will be one of “GRID” | “RANDOM” | “BAYESIAN”.

Return type:
    

str

set_grid_search(_shuffle =True_, _seed =1337_)
    

Sets the search strategy to “GRID”, to perform a grid-search over the hyperparameters.

Parameters:
    

  * **shuffle** (_bool_) – if True (default), iterate over a shuffled grid as opposed to lexicographical iteration over the cartesian product of the hyperparameters

  * **seed** (_int_) – Seed value used to ensure reproducible results (defaults to **1337**)




set_random_search(_seed =1337_)
    

Sets the search strategy to “RANDOM”, to perform a random search over the hyperparameters.

Parameters:
    

**seed** (_int_) – Seed value used to ensure reproducible results (defaults to **1337**)

set_bayesian_search(_seed =1337_)
    

Sets the search strategy to “BAYESIAN”, to perform a Bayesian search over the hyperparameters.

Parameters:
    

**seed** (_int_) – Seed value used to ensure reproducible results (defaults to **1337**)

_property _validation_mode
    

Returns:
    

The cross-validation strategy. Will be one of “KFOLD” | “SHUFFLE” | “TIME_SERIES_KFOLD” | “TIME_SERIES_SINGLE_SPLIT” | “CUSTOM”.

Return type:
    

str

_property _fold_offset
    

Returns:
    

Whether there is an offset between validation sets, to avoid overlap between cross-test sets (model evaluation) and cross-validation sets (hyperparameter search), if both are using k-fold. Only relevant for time series forecasting

Return type:
    

bool

_property _equal_duration_folds
    

Returns:
    

Whether every fold in cross-test and cross-validation should be of equal duration when using k-fold. Only relevant for time series forecasting.

Return type:
    

bool

_property _cv_seed
    

Returns:
    

cross-validation seed for splitting the data during hyperparameter search

Return type:
    

int

set_kfold_validation(_n_folds =5_, _stratified =True_, _cv_seed =1337_)
    

Sets the validation mode to k-fold cross-validation.

The mode will be set to either “KFOLD” or “TIME_SERIES_KFOLD”, depending on whether time-based ordering is enabled.

Parameters:
    

  * **n_folds** (_int_) – The number of folds used for the hyperparameter search (defaults to **5**)

  * **stratified** (_bool_) – If True, keep the same proportion of each target classes in all folds (defaults to **True**)

  * **cv_seed** (_int_) – Seed for cross-validation (defaults to **1337**)




set_single_split_validation(_split_ratio =0.8_, _stratified =True_, _cv_seed =1337_)
    

Sets the validation mode to single split.

The mode will be set to either “SHUFFLE” or “TIME_SERIES_SINGLE_SPLIT”, depending on whether time-based ordering is enabled.

Parameters:
    

  * **split_ratio** (_float_) – The ratio of the data used for training during hyperparameter search (defaults to **0.8**)

  * **stratified** (_bool_) – If True, keep the same proportion of each target classes in both splits (defaults to **True**)

  * **cv_seed** (_int_) – Seed for cross-validation (defaults to **1337**)




set_custom_validation(_code =None_)
    

Sets the validation mode to “CUSTOM”, and sets the custom validation code.

Your code must create a ‘cv’ variable. This ‘cv’ must be compatible with the scikit-learn ‘CV splitter class family.

Example splitter classes can be found here: <https://scikit-learn.org/stable/modules/classes.html#splitter-classes>

See also: <https://scikit-learn.org/stable/glossary.html#term-CV-splitter>

This example code uses the ‘repeated K-fold’ splitter of scikit-learn:
    
    
    from sklearn.model_selection import RepeatedKFold
    cv = RepeatedKFold(n_splits=3, n_repeats=5)
    

Parameters:
    

**code** (_str_) – definition of the validation

set_search_distribution(_distributed =False_, _n_containers =4_)
    

Sets the distribution parameters for the hyperparameter search execution.

Parameters:
    

  * **distributed** (_bool_) – if True, distribute search in the Kubernetes cluster selected in the runtime environment’s containerized execution configuration (defaults to **False**)

  * **n_containers** (_int_) – number of containers to use for the distributed search (defaults to **4**)




_property _distributed
    

Returns:
    

Whether the search is set to distributed

Return type:
    

bool

_property _timeout
    

Returns:
    

The search timeout

Return type:
    

int

_property _n_iter
    

Returns:
    

The number of search iterations

Return type:
    

int

_property _parallelism
    

Returns:
    

The number of threads used for the search

Return type:
    

int

_class _dataikuapi.dss.ml.DSSMLTaskSettings(_client_ , _project_key_ , _analysis_id_ , _mltask_id_ , _mltask_settings_)
    

Object to read and modify the settings of an existing ML task.

Important

Do not create this class directly, use `DSSMLTask.get_settings()` instead

Usage example:
    
    
    project_key = 'DKU_CHURN'
    fmi = 'A-DKU_CHURN-RADgquHe-5nJtl88L-s1-pp1-m1'
    
    client = dataiku.api_client()
    task = dataikuapi.dss.ml.DSSMLTask.from_full_model_id(client, fmi, project_key)
    task_settings = task.get_settings()
    task_settings.set_diagnostics_enabled(False)
    task_settings.save()
    

get_raw()
    

Gets the raw settings of this ML Task.

This returns a reference to the raw settings, rather than a copy, so any changes made to the returned object will be reflected when saving.

Returns:
    

The raw settings of this ML Task

Return type:
    

dict

get_feature_preprocessing(_feature_name_)
    

Gets the feature preprocessing parameters for a particular feature.

This returns a reference to the selected features’ settings, rather than a copy,
    

so any changes made to the returned object will be reflected when saving.

Parameters:
    

**feature_name** (_str_) – Name of the feature whose parameters will be returned

Returns:
    

A dict of the preprocessing settings for a feature

Return type:
    

dict

foreach_feature(_fn_ , _only_of_type =None_)
    

Applies a function to all features, including REJECTED features, except for the target feature

Parameters:
    

  * **fn** (_function_) – Function handle of the form `fn(feature_name, feature_params) -> dict`, where feature_name is the feature name as a str, and feature_params is a dict containing the specific feature params. The function should return a dict of edited parameters for the feature.

  * **only_of_type** (_Union_ _[__str_ _,__None_ _]__,__optional_) – If set, only applies the function to features matching the given type. Must be one of `CATEGORY`, `NUMERIC`, `TEXT` or `VECTOR`.




reject_feature(_feature_name_)
    

Marks a feature as ‘rejected’, disabling it from being used as an input when training. This reverses the effect of the `use_feature()` method.

Parameters:
    

**feature_name** (_str_) – Name of the feature to reject

use_feature(_feature_name_)
    

Marks a feature to be used (enabled) as an input when training. This reverses the effect of the `reject_feature()` method.

Parameters:
    

**feature_name** (_str_) – Name of the feature to use/enable

get_algorithm_settings(_algorithm_name_)
    

Caution

Not Implemented, throws NotImplementedError

get_diagnostics_settings()
    

Gets the ML Tasks diagnostics’ settings.

This returns a reference to the diagnostics’ settings, rather than a copy, so changes made to the returned object will be reflected when saving.

This method returns a dictionary of the settings with:

  * **enabled** (boolean): Indicates if the diagnostics are enabled globally, if False, all diagnostics will be disabled

  * **settings** (List[dict]): A list of dicts.
    

Each dict will contain the following:

    * **type** (str): The diagnostic type name, in uppercase

    * **enabled** (boolean): Indicates if the diagnostic type is enabled. If False, all diagnostics of that type will be disabled




Please refer to the documentation for details on available diagnostics.

Returns:
    

A dict of diagnostics settings

Return type:
    

dict

set_diagnostics_enabled(_enabled_)
    

Globally enables or disables the calculation of all diagnostics

Parameters:
    

**enabled** (_bool_) – True if the diagnostics should be enabled, False otherwise

set_diagnostic_type_enabled(_diagnostic_type_ , _enabled_)
    

Enables or disables the calculation of a set of diagnostics given their type.

Attention

This is overridden by whether diagnostics are enabled globally; If diagnostics are disabled globally, nothing will be calculated.

Diagnostics can be enabled/disabled globally via the `set_diagnostics_enabled()` method.

Usage example:
    
    
    mltask_settings = task.get_settings()
    mltask_settings.set_diagnostics_enabled(True)
    mltask_settings.set_diagnostic_type_enabled("ML_DIAGNOSTICS_DATASET_SANITY_CHECKS", False)
    mltask_settings.set_diagnostic_type_enabled("ML_DIAGNOSTICS_LEAKAGE_DETECTION", False)
    mltask_settings.save()
    

Please refer to the documentation for details on available diagnostics.

Parameters:
    

  * **diagnostic_type** (_str_) – Name of the diagnostic type, in uppercase.

  * **enabled** (_bool_) – True if the diagnostic should be enabled, False otherwise




set_algorithm_enabled(_algorithm_name_ , _enabled_)
    

Enables or disables an algorithm given its name.

Exact algorithm names can be found using the `get_all_possible_algorithm_names()` method.

Please refer to the documentation for further information on available algorithms.

Parameters:
    

  * **algorithm_name** (_str_) – Name of the algorithm, in uppercase.

  * **enabled** (_bool_) – True if the algorithm should be enabled, False otherwise




disable_all_algorithms()
    

Disables all algorithms

get_all_possible_algorithm_names()
    

Gets the list of possible algorithm names

This can be used to find the list of valid identifiers for the `set_algorithm_enabled()` and `get_algorithm_settings()` methods.

This includes all possible algorithms, regardless of the prediction kind (regression/classification etc) or engine, so some algorithms may be irrelevant to the current task.

Returns:
    

The list of algorithm names as a list of strings

Return type:
    

list[str]

get_enabled_algorithm_names()
    

Gets the list of enabled algorithm names

Returns:
    

The list of enabled algorithm names

Return type:
    

list[str]

get_enabled_algorithm_settings()
    

Gets the settings for each enabled algorithm

Returns a dictionary where:

  * Each key is the name of an enabled algorithm

  * Each value is the result of calling `get_algorithm_settings()` with the key as the parameter




Returns:
    

The dict of enabled algorithm names with their settings

Return type:
    

dict

set_metric(_metric =None_, _custom_metric =None_, _custom_metric_greater_is_better =True_, _custom_metric_use_probas =False_, _custom_metric_name =None_)
    

Sets the score metric to optimize for a prediction ML Task

When using a custom optimisation metric, the metric parameter must be kept as None, and a string containing the metric code should be passed to the custom_metric parameter.

Parameters:
    

  * **metric** (_str_ _,__optional_) – Name of the metric to use. Must be left empty to use a custom metric (defaults to **None**).

  * **custom_metric** (_str_ _,__optional_) – Code for the custom optimisation metric (defaults to **None**)

  * **custom_metric_greater_is_better** (_bool_ _,__optional_) – Whether the custom metric function returns a score (True, default) or a loss (False). Score functions return higher values as the model improves, whereas loss functions return lower values.

  * **custom_metric_use_probas** (_bool_ _,__optional_) – If True, will use the classes’ probas or the predicted value (for classification) (defaults to **False**)

  * **custom_metric_name** (_str_ _,__optional_) – Name of your custom metric. If not set, it will generate one.




add_custom_python_model(_name ='Custom Python Model'_, _code =''_)
    

Adds a new custom python model and enables it.

Your code must create a ‘clf’ variable. This clf must be a scikit-learn compatible estimator, ie, it should:

  1. have at least fit(X,y) and predict(X) methods

  2. inherit sklearn.base.BaseEstimator

  3. handle the attributes in the __init__ function

  4. have a classes_ attribute (for classification tasks)

  5. have a predict_proba method (optional)




Example:
    
    
    mltask_settings = task.get_settings()
    code = """
    from sklearn.ensemble import AdaBoostClassifier
    clf = AdaBoostClassifier(n_estimators=20)
    """
    mltask_settings.add_custom_python_model(name="sklearn adaboost custom", code=code)
    mltask_settings.save()
    

See: <https://doc.dataiku.com/dss/latest/machine-learning/custom-models.html>

Parameters:
    

  * **name** (_str_) – The name of the custom model (defaults to **“Custom Python Model”**)

  * **code** (_str_) – The code for the custom model (defaults to **“”**)




add_custom_mllib_model(_name ='Custom MLlib Model'_, _code =''_)
    

Adds a new custom MLlib model and enables it

This example has sample code that uses a standard MLlib algorithm, the RandomForestClassifier:
    
    
    mltask_settings = task.get_settings()
    
    code = """
    // import the Estimator from spark.ml
    import org.apache.spark.ml.classification.RandomForestClassifier
    
    // instantiate the Estimator
    new RandomForestClassifier()
      .setLabelCol("Survived")  // Must be the target column
      .setFeaturesCol("__dku_features")  // Must always be __dku_features
      .setPredictionCol("prediction")    // Must always be prediction
      .setNumTrees(50)
      .setMaxDepth(8)
    """
    mltask_settings.add_custom_mllib_model(name="spark random forest custom", code=code)
    mltask_settings.save()
    

Parameters:
    

  * **name** (_str_) – The name of the custom model (defaults to **“Custom MLlib Model”**)

  * **code** (_str_) – The code for the custom model (defaults to **“”**)




save()
    

Saves the settings back to the ML Task

_class _dataikuapi.dss.ml.DSSPredictionMLTaskSettings(_client_ , _project_key_ , _analysis_id_ , _mltask_id_ , _mltask_settings_)
    

_class _PredictionTypes
    

Possible prediction types

BINARY _ = 'BINARY_CLASSIFICATION'_
    

REGRESSION _ = 'REGRESSION'_
    

MULTICLASS _ = 'MULTICLASS'_
    

OTHER _ = 'OTHER'_
    

get_all_possible_algorithm_names()
    

Returns the list of possible algorithm names.

This includes the names of algorithms from installed plugins.

This can be used as the list of valid identifiers for `set_algorithm_enabled()` and `get_algorithm_settings()`.

This includes all possible algorithms, regardless of the prediction kind (regression/classification) or the engine, so some algorithms may be irrelevant to the current task.

Returns:
    

The list of algorithm names

Return type:
    

list[str]

get_enabled_algorithm_names()
    

Gets the list of enabled algorithm names

Returns:
    

The list of enabled algorithm names

Return type:
    

list[str]

get_algorithm_settings(_algorithm_name_)
    

Gets the training settings for a particular algorithm. This returns a reference to the algorithm’s settings, not a copy, so changes made to the returned object will be reflected when saving.

This method returns the settings for this algorithm as an PredictionAlgorithmSettings (extended dict). All algorithm dicts have at least an “enabled” property/key in the settings. The “enabled” property/key indicates whether this algorithm will be trained.

Other settings are algorithm-dependent and are the various hyperparameters of the algorithm. The precise properties/keys for each algorithm are not all documented. You can print the returned AlgorithmSettings to learn more about the settings of each particular algorithm.

Please refer to the documentation for details on available algorithms.

Parameters:
    

**algorithm_name** (_str_) – Name of the algorithm, in uppercase.

Returns:
    

A PredictionAlgorithmSettings (extended dict) for one of the built-in prediction algorithms

Return type:
    

PredictionAlgorithmSettings

split_ordered_by(_feature_name_ , _ascending =True_)
    

Deprecated. Use split_params.set_time_ordering()

remove_ordered_split()
    

Deprecated. Use split_params.unset_time_ordering()

use_sample_weighting(_feature_name_)
    

Deprecated. use set_weighting()

set_weighting(_method_ , _feature_name =None_)
    

Sets the method for weighting samples.

If there was a WEIGHT feature declared previously, it will be set back as an INPUT feature first.

Parameters:
    

  * **method** (_str_) – Weighting nethod to use. One of NO_WEIGHTING, SAMPLE_WEIGHT (requires a feature name), CLASS_WEIGHT or CLASS_AND_SAMPLE_WEIGHT (requires a feature name)

  * **feature_name** (_str_ _,__optional_) – Name of the feature to use as sample weight




remove_sample_weighting()
    

Deprecated. Use set_weighting(method=”NO_WEIGHTING”) instead

get_assertions_params()
    

Retrieves the ML Task assertion parameters

Returns:
    

The assertions parameters for this ML task

Return type:
    

`DSSMLAssertionsParams`

get_hyperparameter_search_settings()
    

Gets the hyperparameter search parameters of the current DSSPredictionMLTaskSettings instance as a HyperparameterSearchSettings object. This object can be used to both get and set properties relevant to hyperparameter search, such as search strategy, cross-validation method, execution limits and parallelism.

Returns:
    

A HyperparameterSearchSettings

Return type:
    

`HyperparameterSearchSettings`

get_prediction_type()
    

get_split_params()
    

Gets a handle to modify train/test splitting params.

Return type:
    

`PredictionSplitParamsHandler`

_property _split_params
    

Deprecated. Use get_split_params()

_class _dataikuapi.dss.ml.DSSClusteringMLTaskSettings(_client_ , _project_key_ , _analysis_id_ , _mltask_id_ , _mltask_settings_)
    

get_algorithm_settings(_algorithm_name_)
    

Gets the training settings of a particular algorithm.

This returns a reference to the algorithm’s settings, rather than a copy, so any changes made to the returned object will be reflected when saving.

This method returns a dictionary of the settings for this algorithm. All algorithm dicts contain an “enabled” key, which indicates whether this algorithm will be trained

Other settings are algorithm-dependent and include the various hyperparameters of the algorithm. The precise keys for each algorithm are not all documented. You can print the returned dictionary to learn more about the settings of each particular algorithm.

Please refer to the documentation for details on available algorithms.

Parameters:
    

**algorithm_name** (_str_) – Name of the algorithm, in uppercase.

Returns:
    

A dict containing the settings for the algorithm

Return type:
    

dict

_class _dataikuapi.dss.ml.DSSTimeseriesForecastingMLTaskSettings(_client_ , _project_key_ , _analysis_id_ , _mltask_id_ , _mltask_settings_)
    

_class _PredictionTypes
    

Possible prediction types

TIMESERIES_FORECAST _ = 'TIMESERIES_FORECAST'_
    

get_time_step_params()
    

Gets the time step parameters for the time series forecasting task.

This returns a reference to the time step parameters, rather than a copy, so any changes made to the returned object will be reflected when saving.

Returns:
    

A dict of the time step parameters

Return type:
    

dict

set_time_step(_time_unit =None_, _n_time_units =None_, _end_of_week_day =None_, _reguess =True_, _update_algorithm_settings =True_, _unit_alignment =None_, _monthly_alignment =None_)
    

Sets the time step parameters for the time series forecasting task.

Parameters:
    

  * **time_unit** (_str_ _,__optional_) – time unit for forecasting step. Valid values are: MILLISECOND, SECOND, MINUTE, HOUR, DAY, BUSINESS_DAY, WEEK, MONTH, QUARTER, HALF_YEAR, YEAR (defaults to **None** , i.e. don’t change)

  * **n_time_units** (_int_ _,__optional_) – number of time units within a time step (defaults to **None** , i.e. don’t change)

  * **end_of_week_day** (_int_ _,__optional_) – only useful for the WEEK time unit. Valid values are: 1 (Sunday), 2 (Monday), …, 7 (Saturday) (defaults to **None** , i.e. don’t change)

  * **reguess** (_bool_) – Whether to reguess the ML task settings after changing the time step params (defaults to **True**)

  * **update_algorithm_settings** (_bool_) – Whether the algorithm settings should also be reguessed if reguessing the ML Task (defaults to **True**)

  * **unit_alignment** (_int_ _,__optional_) – for each step, month index (between 1 and 3) when time_unit is QUARTER, month index (between 1 and 6) when time_unit is HALF_YEAR, month number (between 1 and 12) when time_unit is YEAR (defaults to **None** , i.e. don’t change)

  * **monthly_alignment** (_int_ _,__optional_) – for each step, day of the month (between 1 and 31) when time_unit is MONTH, QUARTER, HALF_YEAR or YEAR (defaults to **None** , i.e. don’t change)




get_resampling_params()
    

Gets the time series resampling parameters for the time series forecasting task.

This returns a reference to the time series resampling parameters, rather than a copy, so any changes made to the returned object will be reflected when saving.

Returns:
    

A dict of the resampling parameters

Return type:
    

dict

set_numerical_interpolation(_method =None_, _constant =None_)
    

Sets the time series resampling numerical interpolation parameters

Parameters:
    

  * **method** (_str_ _,__optional_) – Interpolation method. Valid values are: NEAREST, PREVIOUS, NEXT, LINEAR, QUADRATIC, CUBIC, CONSTANT, STAIRCASE (defaults to **None** , i.e. don’t change)

  * **constant** (_float_ _,__optional_) – Value for the CONSTANT interpolation method (defaults to **None** , i.e. don’t change)




set_numerical_extrapolation(_method =None_, _constant =None_)
    

Sets the time series resampling numerical extrapolation parameters

Parameters:
    

  * **method** (_str_ _,__optional_) – Extrapolation method. Valid values are: PREVIOUS_NEXT, NO_EXTRAPOLATION, CONSTANT, LINEAR, QUADRATIC, CUBIC (defaults to **None** , i.e. don’t change)

  * **constant** (_float_ _,__optional_) – Value for the CONSTANT extrapolation method (defaults to **None**)




set_resampling_dates(_start_date_mode ='AUTO'_, _custom_start_date =None_, _end_date_mode ='AUTO'_, _custom_end_date =None_)
    

Sets dates to use for resampling the time series

Parameters:
    

  * **start_date_mode** (_string_ _,__optional_) – either “AUTO” to use the oldest known timestamp or “CUSTOM” to use the date set with _custom_start_date_ (defaults to **AUTO**)

  * **custom_start_date** (_datetime.date_ _,__optional_) – start date to use for resampling (defaults to **None**)

  * **end_date_mode** (_string_ _,__optional_) – either “AUTO” to use the newest known timestamp or “CUSTOM” to use the date set with _custom_end_date_ (defaults to **AUTO**)

  * **custom_end_date** (_datetime.date_ _,__optional_) – end date to use for resampling (defaults to **None**)




set_categorical_imputation(_method =None_, _constant =None_)
    

Sets the time series resampling categorical imputation parameters

Parameters:
    

  * **method** (_str_ _,__optional_) – Imputation method. Valid values are: MOST_COMMON, NULL, CONSTANT, PREVIOUS_NEXT, PREVIOUS, NEXT (defaults to **None** , i.e. don’t change)

  * **constant** (_str_ _,__optional_) – Value for the CONSTANT imputation method (defaults to **None** , i.e. don’t change)




set_duplicate_timestamp_handling(_method_)
    

Sets the time series duplicate timestamp handling method

Parameters:
    

**method** (_str_) – Duplicate timestamp handling method. Valid values are: FAIL_IF_CONFLICTING, DROP_IF_CONFLICTING, MEAN_MODE.

_property _forecast_horizon
    

Returns:
    

Number of time steps to be forecast

Return type:
    

int

set_forecast_horizon(_forecast_horizon_ , _reguess =True_, _update_algorithm_settings =True_, _validation_horizons =None_)
    

Sets the time series forecast horizon

Parameters:
    

  * **forecast_horizon** (_int_) – Number of time steps to be forecast

  * **reguess** (_bool_) – Whether to reguess the ML task settings after changing the forecast horizon (defaults to **True**)

  * **update_algorithm_settings** (_bool_) – Whether the algorithm settings should be reguessed after the forecast horizon (defaults to **True**)

  * **validation_horizons** (_int_ _|__None_) – The number of validation horizons to be set. If omitted, retains the previous ratio.




_property _evaluation_gap
    

Returns:
    

Number of skipped time steps for evaluation

Return type:
    

int

_property _time_variable
    

Returns:
    

Feature used as time variable (read-only)

Return type:
    

str

_property _timeseries_identifiers
    

Returns:
    

Features used as time series identifiers (read-only copy)

Return type:
    

list

_property _quantiles_to_forecast
    

Returns:
    

List of quantiles to forecast

Return type:
    

list

_property _skip_too_short_timeseries_for_training
    

Returns:
    

Whether we skip too short and constant time series during training, or fail the whole training when only one time series is too short.

Return type:
    

bool

get_algorithm_settings(_algorithm_name_)
    

Gets the training settings for a particular algorithm. This returns a reference to the algorithm’s settings, not a copy, so changes made to the returned object will be reflected when saving.

This method returns the settings for this algorithm as an PredictionAlgorithmSettings (extended dict). All algorithm dicts have at least an “enabled” property/key in the settings. The “enabled” property/key indicates whether this algorithm will be trained.

Other settings are algorithm-dependent and are the various hyperparameters of the algorithm. The precise properties/keys for each algorithm are not all documented. You can print the returned AlgorithmSettings to learn more about the settings of each particular algorithm.

Please refer to the documentation for details on available algorithms.

Parameters:
    

**algorithm_name** (_str_) – Name of the algorithm, in uppercase.

Returns:
    

A PredictionAlgorithmSettings (extended dict) for one of the built-in prediction algorithms

Return type:
    

PredictionAlgorithmSettings

get_assertions_params()
    

Retrieves the assertions parameters for this ml task

Return type:
    

`DSSMLAssertionsParams`

get_hyperparameter_search_settings()
    

Gets the hyperparameter search parameters of the current DSSPredictionMLTaskSettings instance as a HyperparameterSearchSettings object. This object can be used to both get and set properties relevant to hyperparameter search, such as search strategy, cross-validation method, execution limits and parallelism.

Returns:
    

A HyperparameterSearchSettings

Return type:
    

`HyperparameterSearchSettings`

get_prediction_type()
    

get_split_params()
    

Gets a handle to modify train/test splitting params.

Return type:
    

`PredictionSplitParamsHandler`

_property _split_params
    

Deprecated. Use get_split_params()

_class _dataikuapi.dss.ml.PredictionSplitParamsHandler(_mltask_settings_)
    

Object to modify the train/test dataset splitting params.

Important

Do not create this class directly, use `DSSMLTaskSettings.get_split_params()`

SPLIT_PARAMS_KEY _ = 'splitParams'_
    

get_raw()
    

Gets the raw settings of the prediction split configuration.

This returns a reference to the raw settings, rather than a copy, so any changes made to the returned object will be reflected when saving.

Returns:
    

The raw prediction split parameter settings

Return type:
    

dict

set_split_random(_train_ratio =0.8_, _selection =None_, _dataset_name =None_)
    

Sets the train/test split mode to random splitting over an extract from a single dataset

Parameters:
    

  * **train_ratio** (_float_) – Ratio of rows to use for the train set. Must be between 0 and 1 (defaults to **0.8**)

  * **selection** (Union[[`dataikuapi.dss.utils.DSSDatasetSelectionBuilder`](<utils.html#dataikuapi.dss.utils.DSSDatasetSelectionBuilder> "dataikuapi.dss.utils.DSSDatasetSelectionBuilder"), dict], optional) – Optional builder or dict defining the settings of the extract from the dataset (defaults to **None**). A dict with the appropriate schema can be generated via [`dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build()`](<utils.html#dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build> "dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build")

  * **dataset_name** (_str_ _,__optional_) – Name of the dataset to split on. If None (default), uses the main dataset used to create the visual analysis




set_split_kfold(_n_folds =5_, _selection =None_, _dataset_name =None_)
    

Sets the train/test split mode to k-fold splitting over an extract from a single dataset

Parameters:
    

  * **n_folds** (_int_) – number of folds. Must be greater than 0 (defaults to **5**)

  * **selection** (Union[[`DSSDatasetSelectionBuilder`](<utils.html#dataikuapi.dss.utils.DSSDatasetSelectionBuilder> "dataikuapi.dss.utils.DSSDatasetSelectionBuilder"), dict], optional) – Optional builder or dict defining the settings of the extract from the dataset (defaults to **None**) A dict with the appropriate schema can be generated via [`dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build()`](<utils.html#dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build> "dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build")

  * **dataset_name** (_str_ _,__optional_) – Name of the dataset to split on. If None (default), uses the main dataset used to create the visual analysis




set_split_explicit(_train_selection_ , _test_selection_ , _dataset_name =None_, _test_dataset_name =None_, _train_filter =None_, _test_filter =None_)
    

Sets the train/test split to an explicit extract from one or two dataset(s)

Parameters:
    

  * **train_selection** (Union[[`DSSDatasetSelectionBuilder`](<utils.html#dataikuapi.dss.utils.DSSDatasetSelectionBuilder> "dataikuapi.dss.utils.DSSDatasetSelectionBuilder"), dict]) – Builder or dict defining the settings of the extract for the train dataset. May be None (won’t be changed). A dict with the appropriate schema can be generated via [`dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build()`](<utils.html#dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build> "dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build")

  * **test_selection** (Union[[`DSSDatasetSelectionBuilder`](<utils.html#dataikuapi.dss.utils.DSSDatasetSelectionBuilder> "dataikuapi.dss.utils.DSSDatasetSelectionBuilder"), dict]) – Builder or dict defining the settings of the extract for the test dataset. May be None (won’t be changed). A dict with the appropriate schema can be generated via [`dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build()`](<utils.html#dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build> "dataikuapi.dss.utils.DSSDatasetSelectionBuilder.build")

  * **dataset_name** (_str_ _,__optional_) – Name of the dataset to split on. If None (default), uses the main dataset used to create the visual analysis

  * **test_dataset_name** (_str_ _,__optional_) – Optional name of a second dataset to use for the test data extract. If None (default), both extracts are done from dataset_name

  * **train_filter** (Union[[`DSSFilterBuilder`](<utils.html#dataikuapi.dss.utils.DSSFilterBuilder> "dataikuapi.dss.utils.DSSFilterBuilder"), dict], optional) – Builder or dict defining the settings of the filter for the train dataset. Defaults to None (won’t be changed). A dict with the appropriate schema can be generated via [`dataikuapi.dss.utils.DSSFilterBuilder.build()`](<utils.html#dataikuapi.dss.utils.DSSFilterBuilder.build> "dataikuapi.dss.utils.DSSFilterBuilder.build")

  * **test_filter** (Union[[`DSSFilterBuilder`](<utils.html#dataikuapi.dss.utils.DSSFilterBuilder> "dataikuapi.dss.utils.DSSFilterBuilder"), dict], optional) – Builder or dict defining the settings of the filter for the test dataset. Defaults to None (won’t be changed). A dict with the appropriate schema can be generated via [`dataikuapi.dss.utils.DSSFilterBuilder.build()`](<utils.html#dataikuapi.dss.utils.DSSFilterBuilder.build> "dataikuapi.dss.utils.DSSFilterBuilder.build")




set_time_ordering(_feature_name_ , _ascending =True_)
    

Enables time based ordering and sets the feature upon which to sort the train/test split and hyperparameter optimization data by time.

Parameters:
    

  * **feature_name** (_str_) – The name of the feature column to use. This feature must be present in the output of the preparation steps of the analysis. When there are no preparation steps, it means this feature must be present in the analyzed dataset.

  * **ascending** (_bool_) – True (default) means the test set is expected to have larger time values than the train set




unset_time_ordering()
    

Disables time-based ordering for train/test split and hyperparameter optimization

has_time_ordering()
    

Returns:
    

True if the split uses time-based ordering

Return type:
    

bool

get_time_ordering_variable()
    

Returns:
    

If enabled, the name of the ordering variable for time based ordering (the feature name). Returns None if time based ordering is not enabled.

Return type:
    

Union[str, None]

is_time_ordering_ascending()
    

Returns:
    

True if the time-ordering is set to sort in ascending order. Returns None if time based ordering is not enabled.

Return type:
    

Union[bool, None]

_class _dataikuapi.dss.ml.DSSCoefficientPaths(_paths_)
    

get_raw()
    

Gets the raw paths data structure

get_feature_names()
    

Get the feature names (after dummification)

get_coefficient_path(_feature_ , _class_index =0_)
    

Get the path of the feature

_class _dataikuapi.dss.ml.DSSTree(_tree_ , _feature_names_ , _prediction_type_ , _classes_)
    

get_raw()
    

Gets the raw tree data structure

get_classes()
    

get_root()
    

Gets a `dataikuapi.dss.ml.DSSTreeNode` representing the root of the tree

_class _dataikuapi.dss.ml.DSSTreeSet(_trees_ , _prediction_type_)
    

get_raw()
    

Gets the raw trees data structure

get_feature_names()
    

Gets the list of feature names (after dummification)

get_classes()
    

get_trees()
    

Gets the list of trees as `dataikuapi.dss.ml.DSSTree`

_class _dataikuapi.dss.ml.DSSTreeNode(_tree_ , _i_)
    

get_left_child()
    

Gets a `dataikuapi.dss.ml.DSSTreeNode` representing the left side of the tree node (or None)

get_right_child()
    

Gets a `dataikuapi.dss.ml.DSSTreeNode` representing the right side of the tree node (or None)

get_split_info()
    

Gets the information on the split, as a dict

_class _dataikuapi.dss.ml.DSSSubpopulationAnalyses(_data_ , _prediction_type_)
    

Object to read details of subpopulation analyses of a trained model

Important

Do not create this object directly, use `DSSTrainedPredictionModelDetails.get_subpopulation_analyses()` instead

get_raw()
    

Gets the raw dictionary of subpopulation analyses

Return type:
    

dict

get_global()
    

Retrieves information and performance on the full dataset used to compute the subpopulation analyses

list_analyses()
    

Lists all features on which subpopulation analyses have been computed

get_analysis(_feature_)
    

Retrieves the subpopulation analysis for a particular feature

_class _dataikuapi.dss.ml.DSSPartialDependencies(_data_)
    

Object to read details of partial dependencies of a trained model

Important

Do not create this object directly, use `DSSTrainedPredictionModelDetails.get_partial_dependencies()` instead

get_raw()
    

Gets the raw dictionary of partial dependencies

Return type:
    

dict

list_features()
    

Lists all features on which partial dependencies have been computed

get_partial_dependence(_feature_)
    

Retrieves the partial dependencies for a particular feature

_class _dataikuapi.dss.ml.DSSClustersFacts(_clusters_facts_)
    

get_raw()
    

Gets the raws facts data structure

get_cluster_size(_cluster_index_)
    

Gets the size of a cluster identified by its index

get_facts_for_cluster(_cluster_index_)
    

Gets all facts for a cluster identified by its index. Returns a list of dicts

Return type:
    

list

get_facts_for_cluster_and_feature(_cluster_index_ , _feature_name_)
    

Gets all facts for a cluster identified by its index, limited to a feature name. Returns a list of dicts

Return type:
    

list

_class _dataikuapi.dss.ml.DSSMLAssertionsParams(_data_)
    

Object that represents parameters for all assertions of a ml task

Important

Do not create this object directly, use `DSSPredictionMLTaskSettings.get_assertions_params()` instead

get_raw()
    

Gets the raw dictionary of the assertions parameters

Return type:
    

dict

get_assertion(_assertion_name_)
    

Gets a `DSSMLAssertionParams` representing the parameters of the assertion with the provided name (or None if no assertion has that name)

Parameters:
    

**assertion_name** (_str_) – Name of the assertion

Return type:
    

`DSSMLAssertionParams` or None if no assertion has that name

get_assertions_names()
    

Gets the list of all assertions’ names

Returns:
    

A list of all assertions’ names

Return type:
    

list

add_assertion(_assertion_params_)
    

Adds parameters of an assertion to the assertions parameters of the ml task.

Parameters:
    

**assertion_params** (_object_) – A `DSSMLAssertionParams` representing parameters of the assertion

delete_assertion(_assertion_name_)
    

Deletes the assertion parameters of the assertion with the provided name from the assertions parameters of the ml task. Raises a ValueError if no assertion with the provided name was found

Parameters:
    

**assertion_name** (_str_) – Name of the assertion

_class _dataikuapi.dss.ml.DSSMLAssertionsMetrics(_data_)
    

Object that represents the assertions metrics for all assertions on a trained model .. important:
    
    
    Do not create this object directly, use :meth:`DSSTrainedPredictionModelDetails.get_assertions_metrics` instead
    

get_raw()
    

Gets the raw dictionary of the assertions metrics

Return type:
    

dict

get_metrics(_assertion_name_)
    

Retrieves the metrics computed for this trained model for the assertion with the provided name (or None if no assertion with that name exists)

Parameters:
    

**assertion_name** (_str_) – Name of the assertion

Returns:
    

an object representing assertion metrics or None if no assertion with that name exists

Return type:
    

`DSSMLAssertionMetrics`

_property _passing_assertions_ratio
    

Returns the ratio of passing assertions

Return type:
    

float

_class _dataikuapi.dss.ml.DSSMLDiagnostic(_data_)
    

Object that represents a computed Diagnostic on a trained model

Important

Do not create this object directly, use `DSSTrainedModelDetails.get_diagnostics()` instead

get_raw()
    

Gets the raw dictionary of the diagnostic

Return type:
    

dict

get_type()
    

Returns the base Diagnostic type

Return type:
    

str

get_type_pretty()
    

Returns the Diagnostic type as displayed in the UI

Return type:
    

str

get_message()
    

Returns the message as displayed in the UI

Return type:
    

str

_class _dataikuapi.dss.ml.PredictionAlgorithmSettings(_raw_settings_ , _hyperparameter_search_params_)
    

Object to read and modify the settings of a prediction ML algorithm.

Important

Do not create this object directly, use `DSSMLTask.get_algorithm_settings()` instead

_property _enabled
    

Return type:
    

bool

_property _strategy
    

_class _dataikuapi.dss.ml.DSSTrainedModelDetails(_details_ , _snippet_ , _saved_model =None_, _saved_model_version =None_, _mltask =None_, _mltask_model_id =None_)
    

get_raw()
    

Gets the raw dictionary of trained model details

_property _full_id
    

get_raw_snippet()
    

Gets the raw dictionary of trained model snippet. The snippet is a lighter version than the details.

get_train_info()
    

Returns various information about the training process (size of the train set, quick description, timing information)

Return type:
    

dict

get_user_meta()
    

Gets the user-accessible metadata (name, description, cluster labels, classification threshold) Returns the original object, not a copy. Changes to the returned object are persisted to DSS by calling `save_user_meta()`

save_user_meta()
    

get_origin_analysis_trained_model()
    

Fetch details about the model in an analysis, this model has been exported from. Returns None if the deployed trained model does not have an origin analysis trained model.

Return type:
    

DSSTrainedModelDetails | None

get_diagnostics()
    

Retrieves diagnostics computed for this trained model

Returns:
    

list of diagnostics

Return type:
    

list of type dataikuapi.dss.ml.DSSMLDiagnostic

generate_documentation(_folder_id =None_, _path =None_)
    

Start the model document generation from a template docx file in a managed folder, or from the default template if no folder id and path are specified.

Parameters:
    

  * **folder_id** – (optional) the id of the managed folder

  * **path** – (optional) the path to the file from the root of the folder



Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the model document generation process

generate_documentation_from_custom_template(_fp_)
    

Start the model document generation from a docx template (as a file object).

Parameters:
    

**fp** (_object_) – A file-like object pointing to a template docx file

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the model document generation process

download_documentation_stream(_export_id_)
    

Download a model documentation, as a binary stream.

Warning: this stream will monopolize the DSSClient until closed.

Parameters:
    

**export_id** – the id of the generated model documentation returned as the result of the future

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the model document generation process

download_documentation_to_file(_export_id_ , _path_)
    

Download a model documentation into the given output file.

Parameters:
    

  * **export_id** – the id of the generated model documentation returned as the result of the future

  * **path** – the path where to download the model documentation



Returns:
    

None

_class _dataikuapi.dss.ml.DSSScatterPlots(_scatters_)
    

get_raw()
    

Gets the raw scatters data structure

get_feature_names()
    

Get the feature names (after dummification)

get_scatter_plot(_feature_x_ , _feature_y_)
    

Get the scatter plot between feature_x and feature_y

### Exploration of results

_class _dataikuapi.dss.ml.DSSTrainedPredictionModelDetails(_details_ , _snippet_ , _saved_model =None_, _saved_model_version =None_, _mltask =None_, _mltask_model_id =None_)
    

Object to read details of a trained prediction model

Important

Do not create this object directly, use `DSSMLTask.get_trained_model_details()` instead

get_roc_curve_data()
    

Gets the data used to plot the ROC curve for the model, if it exists.

Returns:
    

A dictionary containing ROC curve data

get_performance_metrics()
    

Returns all performance metrics for this model.

For binary classification model, this includes both “threshold-independent” metrics like AUC and “threshold-dependent” metrics like precision. Threshold-dependent metrics are returned at the threshold value that was found to be optimal during training.

To get access to the per-threshold values, use the following:
    
    
    # Returns a list of tested threshold values
    details.get_performance()["perCutData"]["cut"]
    # Returns a list of F1 scores at the tested threshold values
    details.get_performance()["perCutData"]["f1"]
    # Both lists have the same length
    

If K-Fold cross-test was used, most metrics will have a “std” variant, which is the standard deviation accross the K cross-tested folds. For example, “auc” will be accompanied with “aucstd”

Returns:
    

a dict of performance metrics values

Return type:
    

dict

get_assertions_metrics()
    

Retrieves assertions metrics computed for this trained model

Returns:
    

an object representing assertion metrics

Return type:
    

`DSSMLAssertionsMetrics`

get_hyperparameter_search_points()
    

Gets the list of points in the hyperparameter search space that have been tested.

Returns a list of dict. Each entry in the list represents a point.

For each point, the dict contains at least:
    

  * “score”: the average value of the optimization metric over all the folds at this point

  * “params”: a dict of the parameters at this point. This dict has the same structure as the params of the best parameters




get_preprocessing_settings()
    

Gets the preprocessing settings that were used to train this model

Return type:
    

dict

get_modeling_settings()
    

Gets the modeling (algorithms) settings that were used to train this model.

Note

The structure of this dict is not the same as the modeling params on the ML Task (which may contain several algorithms).

Return type:
    

dict

get_actual_modeling_params()
    

Gets the actual / resolved parameters that were used to train this model, post hyperparameter optimization.

Returns:
    

A dictionary, which contains at least a “resolved” key, which is a dict containing the post-optimization parameters

Return type:
    

dict

get_trees()
    

Gets the trees in the model (for tree-based models)

Returns:
    

a DSSTreeSet object to interact with the trees

Return type:
    

`dataikuapi.dss.ml.DSSTreeSet`

get_coefficient_paths()
    

Gets the coefficient paths for Lasso models

Returns:
    

a DSSCoefficientPaths object to interact with the coefficient paths

Return type:
    

`dataikuapi.dss.ml.DSSCoefficientPaths`

get_scoring_jar_stream(_model_class ='model.Model'_, _include_libs =False_)
    

Returns a stream of a scoring jar for this trained model.

This works provided that you have the license to do so and that the model is compatible with optimized scoring. You need to close the stream after download. Failure to do so will result in the DSSClient becoming unusable.

Parameters:
    

  * **model_class** (_str_) – fully-qualified class name, e.g. “com.company.project.Model”

  * **include_libs** (_bool_) – if True, also packs the required dependencies; if False, runtime will require the scoring libs given by `DSSClient.scoring_libs()`



Returns:
    

a jar file, as a stream

Return type:
    

file-like

get_scoring_pmml_stream()
    

Returns a stream of a scoring PMML for this trained model.

This works provided that you have the license to do so and that the model is compatible with PMML scoring. You need to close the stream after download. Failure to do so will result in the DSSClient becoming unusable.

Returns:
    

a PMML file, as a stream

Return type:
    

file-like

get_scoring_python_stream()
    

Returns a stream of a zip file containing the required data to use this trained model in external python code.

See: <https://doc.dataiku.com/dss/latest/python-api/ml.html>

This works provided that you have the license to do so and that the model is compatible with Python scoring. You need to close the stream after download. Failure to do so will result in the DSSClient becoming unusable.

Returns:
    

an archive file, as a stream

Return type:
    

file-like

get_scoring_python(_filename_)
    

Downloads a zip file containing the required data to use this trained model in external python code.

See: <https://doc.dataiku.com/dss/latest/python-api/ml.html>

This works provided that you have the license to do so and that the model is compatible with Python scoring.

Parameters:
    

**filename** (_str_) – filename of the resulting downloaded file

get_scoring_mlflow_stream(_use_original_model =False_)
    

Returns a stream of a zip containing this trained model using the MLflow Model format.

This works provided that you have the license to do so and that the model is compatible with MLflow scoring. You need to close the stream after download. Failure to do so will result in the DSSClient becoming unusable.

Parameters:
    

**use_original_model** (_bool_ _,__optional_) – Works only if the model was originally imported from MLflow. Set to True if you want to get the original MLflow model and to False if you want DSS to regenerate a new MLflow model. Defaults to False.

Returns:
    

an archive file, as a stream

Return type:
    

file-like

get_scoring_mlflow(_filename_ , _use_original_model =False_)
    

Downloads a zip containing data for this trained model, using the MLflow Model format.

This works provided that you have the license to do so and that the model is compatible with MLflow scoring.

Parameters:
    

  * **filename** (_str_) – filename to the resulting MLflow Model zip

  * **use_original_model** (_bool_ _,__optional_) – Works only if the model was originally imported from MLflow. Set to True if you want to get the original MLflow model and to False if you want DSS to regenerate a new MLflow model. Defaults to False.




export_to_snowflake_function(_connection_name_ , _function_name_ , _wait =True_)
    

Exports the model to a Snowflake function. Only works for Saved Model Versions. :param connection_name: Snowflake connection to use :param function_name: Name of the function to create :param wait: a flag to wait for the operation to complete (defaults to **True**) :return: None if wait is True, else a future

export_to_databricks_registry(_connection_name_ , _use_unity_catalog_ , _model_name_ , _experiment_name_ , _wait =True_)
    

Exports the model as a version of a Registered Model of a Databricks Registry. To do so, the model is exported to the MLflow format, then logged
    

in a run of an experiment, and finally registered in the selected registry.

Parameters:
    

  * **connection_name** – Databricks Model Deployment Infrastructure connection to use

  * **use_unity_catalog** – exports to a model in the Databricks Workspace registry or in the Databricks Unity Catalog

  * **model_name** – name of the model to add a version to. Restrictions apply on possible name ; please refer to Databricks documentation. The model will be created if needed.

  * **experiment_name** – name of the experiment to use. The experiment will be created if needed.

  * **wait** – a flag to wait for the operation to complete (defaults to **True**)



Returns:
    

dict if wait is True, else a future

compute_shapley_feature_importance()
    

Launches computation of Shapley feature importance for this trained model

Returns:
    

A future for the computation task

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

compute_subpopulation_analyses(_split_by_ , _wait =True_, _sample_size =1000_, _random_state =1337_, _n_jobs =1_, _debug_mode =False_)
    

Launch computation of Subpopulation analyses for this trained model.

Parameters:
    

  * **split_by** (_list_ _|__str_) – column(s) on which subpopulation analyses are to be computed (one analysis per column)

  * **wait** (_bool_) – if True, the call blocks until the computation is finished and returns the results directly

  * **sample_size** (_int_) – number of records of the dataset to use for the computation

  * **random_state** (_int_) – random state to use to build sample, for reproducibility

  * **n_jobs** (_int_) – number of cores used for parallel training.

  * **debug_mode** (_bool_) – if True, output all logs (slower)



Returns:
    

if wait is True, an object containing the Subpopulation analyses, else a future to wait on the result

Return type:
    

Union[`dataikuapi.dss.ml.DSSSubpopulationAnalyses`, [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")]

get_subpopulation_analyses()
    

Retrieve all subpopulation analyses computed for this trained model

Returns:
    

The subpopulation analyses

Return type:
    

`dataikuapi.dss.ml.DSSSubpopulationAnalyses`

compute_partial_dependencies(_features_ , _wait =True_, _sample_size =1000_, _random_state =1337_, _n_jobs =1_, _debug_mode =False_)
    

Launch computation of Partial dependencies for this trained model.

Parameters:
    

  * **features** (_list_ _|__str_) – feature(s) on which partial dependencies are to be computed

  * **wait** (_bool_) – if True, the call blocks until the computation is finished and returns the results directly

  * **sample_size** (_int_) – number of records of the dataset to use for the computation

  * **random_state** (_int_) – random state to use to build sample, for reproducibility

  * **n_jobs** (_int_) – number of cores used for parallel training.

  * **debug_mode** (_bool_) – if True, output all logs (slower)



Returns:
    

if wait is True, an object containing the Partial dependencies, else a future to wait on the result

Return type:
    

Union[`dataikuapi.dss.ml.DSSPartialDependencies`, [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")]

get_partial_dependencies()
    

Retrieve all partial dependencies computed for this trained model

Returns:
    

The partial dependencies

Return type:
    

`dataikuapi.dss.ml.DSSPartialDependencies`

download_documentation_stream(_export_id_)
    

Download a model documentation, as a binary stream.

Warning: this stream will monopolize the DSSClient until closed.

Parameters:
    

**export_id** – the id of the generated model documentation returned as the result of the future

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the model document generation process

download_documentation_to_file(_export_id_ , _path_)
    

Download a model documentation into the given output file.

Parameters:
    

  * **export_id** – the id of the generated model documentation returned as the result of the future

  * **path** – the path where to download the model documentation



Returns:
    

None

_property _full_id
    

generate_documentation(_folder_id =None_, _path =None_)
    

Start the model document generation from a template docx file in a managed folder, or from the default template if no folder id and path are specified.

Parameters:
    

  * **folder_id** – (optional) the id of the managed folder

  * **path** – (optional) the path to the file from the root of the folder



Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the model document generation process

generate_documentation_from_custom_template(_fp_)
    

Start the model document generation from a docx template (as a file object).

Parameters:
    

**fp** (_object_) – A file-like object pointing to a template docx file

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the model document generation process

get_diagnostics()
    

Retrieves diagnostics computed for this trained model

Returns:
    

list of diagnostics

Return type:
    

list of type dataikuapi.dss.ml.DSSMLDiagnostic

get_origin_analysis_trained_model()
    

Fetch details about the model in an analysis, this model has been exported from. Returns None if the deployed trained model does not have an origin analysis trained model.

Return type:
    

DSSTrainedModelDetails | None

get_raw()
    

Gets the raw dictionary of trained model details

get_raw_snippet()
    

Gets the raw dictionary of trained model snippet. The snippet is a lighter version than the details.

get_train_info()
    

Returns various information about the training process (size of the train set, quick description, timing information)

Return type:
    

dict

get_user_meta()
    

Gets the user-accessible metadata (name, description, cluster labels, classification threshold) Returns the original object, not a copy. Changes to the returned object are persisted to DSS by calling `save_user_meta()`

save_user_meta()
    

_class _dataikuapi.dss.ml.DSSTrainedClusteringModelDetails(_details_ , _snippet_ , _saved_model =None_, _saved_model_version =None_, _mltask =None_, _mltask_model_id =None_)
    

Object to read details of a trained clustering model

Important

Do not create this class directly, use `DSSMLTask.get_trained_model_details()`

get_raw()
    

Gets the raw dictionary of trained model details

Returns:
    

A dictionary containing the trained model details

Return type:
    

dict

get_train_info()
    

Gets various information about the training process.

This includes information such as the size of the train set, the quick description and timing information etc.

Returns:
    

A dictionary containing the models training information

Return type:
    

dict

get_facts()
    

Gets the ‘cluster facts’ data.

The cluster facts data is the structure behind the screen “for cluster X, average of Y is Z times higher than average”.

Returns:
    

The clustering facts data

Return type:
    

`DSSClustersFacts`

get_performance_metrics()
    

Returns all performance metrics for this clustering model.

Returns:
    

A dict of performance metrics values

Return type:
    

dict

download_documentation_stream(_export_id_)
    

Download a model documentation, as a binary stream.

Warning: this stream will monopolize the DSSClient until closed.

Parameters:
    

**export_id** – the id of the generated model documentation returned as the result of the future

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the model document generation process

download_documentation_to_file(_export_id_ , _path_)
    

Download a model documentation into the given output file.

Parameters:
    

  * **export_id** – the id of the generated model documentation returned as the result of the future

  * **path** – the path where to download the model documentation



Returns:
    

None

_property _full_id
    

generate_documentation(_folder_id =None_, _path =None_)
    

Start the model document generation from a template docx file in a managed folder, or from the default template if no folder id and path are specified.

Parameters:
    

  * **folder_id** – (optional) the id of the managed folder

  * **path** – (optional) the path to the file from the root of the folder



Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the model document generation process

generate_documentation_from_custom_template(_fp_)
    

Start the model document generation from a docx template (as a file object).

Parameters:
    

**fp** (_object_) – A file-like object pointing to a template docx file

Returns:
    

A [`DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the model document generation process

get_diagnostics()
    

Retrieves diagnostics computed for this trained model

Returns:
    

list of diagnostics

Return type:
    

list of type dataikuapi.dss.ml.DSSMLDiagnostic

get_origin_analysis_trained_model()
    

Fetch details about the model in an analysis, this model has been exported from. Returns None if the deployed trained model does not have an origin analysis trained model.

Return type:
    

DSSTrainedModelDetails | None

get_preprocessing_settings()
    

Gets the preprocessing settings that were used to train this model

Returns:
    

The model preprocessing settings

Return type:
    

dict

get_raw_snippet()
    

Gets the raw dictionary of trained model snippet. The snippet is a lighter version than the details.

get_user_meta()
    

Gets the user-accessible metadata (name, description, cluster labels, classification threshold) Returns the original object, not a copy. Changes to the returned object are persisted to DSS by calling `save_user_meta()`

save_user_meta()
    

get_modeling_settings()
    

Gets the modeling (algorithms) settings that were used to train this model.

Note

The structure of this dict is not the same as the modeling params on the ML Task (which may contain several algorithms).

Returns:
    

The model modeling settings

Return type:
    

dict

get_actual_modeling_params()
    

Gets the actual / resolved parameters that were used to train this model.

Returns:
    

A dictionary, which contains at least a “resolved” key

Return type:
    

dict

get_scatter_plots()
    

Gets the cluster scatter plot data

Returns:
    

a DSSScatterPlots object to interact with the scatter plots

Return type:
    

`dataikuapi.dss.ml.DSSScatterPlots`

_class _dataikuapi.dss.ml.DSSTrainedTimeseriesForecastingModelDetails(_details_ , _snippet_ , _saved_model =None_, _saved_model_version =None_, _mltask =None_, _mltask_model_id =None_)
    

Object to read details of a timeseries forecasting model, for instance the per time series metrics

Important

Do not create this object directly, use `DSSMLTask.get_trained_model_details()` instead

compute_residuals(_wait =True_)
    

Launch computation of residuals for this trained timeseries model.

Parameters:
    

**wait** – a flag to wait for the operation to complete (defaults to **True**)

Returns:
    

if wait is True, a dictionary containing the residuals per-timeseries, else a future to wait on the result

Return type:
    

Union[`dict`, [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")]

get_residuals()
    

Retrieve a list of residuals for this trained time-series models

Returns:
    

A dictionary, which contains a residuals object per-timeseries

Return type:
    

dict

compute_permutation_importance(_wait =True_, _n_iterations =None_, _per_identifier =None_)
    

Launch computation of permutation importance for this trained timeseries model.

Parameters:
    

**wait** – a flag to wait for the operation to complete (defaults to **True**)

Returns:
    

if wait is True, a dictionary, else a future to wait on the result

Return type:
    

Union[`dict`, [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")]

get_permutation_importance()
    

Retrieve the permutation importance for this trained time-series models

Returns:
    

A dictionary

Return type:
    

dict

get_per_timeseries_metrics()
    

Returns per timeseries performance metrics for this model.

Returns:
    

a dict of performance metrics values

Return type:
    

dict

get_per_timeseries_evaluation_forecasts()
    

Returns per timeseries evaluation forecasts for this model.

Returns:
    

a dict of evaluation forecasts per timeseries identifier

Return type:
    

dict

### Saved models

_class _dataikuapi.dss.savedmodel.DSSSavedModel(_client_ , _project_key_ , _sm_id_)
    

Handle to interact with a saved model on the DSS instance.

Important

Do not create this class directly, instead use `dataikuapi.dss.DSSProject.get_saved_model()`

Parameters:
    

  * **client** ([`dataikuapi.dssclient.DSSClient`](<client.html#dataikuapi.DSSClient> "dataikuapi.dssclient.DSSClient")) – an api client to connect to the DSS backend

  * **project_key** (_str_) – identifier of the project containing the model

  * **sm_id** (_str_) – identifier of the saved model




_property _id
    

Returns the identifier of the saved model

Return type:
    

str

get_settings()
    

Returns the settings of this saved model.

Returns:
    

settings of this saved model

Return type:
    

`dataikuapi.dss.savedmodel.DSSSavedModelSettings`

list_versions()
    

Gets the versions of this saved model.

This returns each version as a dict of object. Each object contains at least an “id” parameter, which can be passed to `get_metric_values()`, `get_version_details()` and `set_active_version()`.

Returns:
    

The list of the versions

Return type:
    

list[dict]

get_active_version()
    

Gets the active version of this saved model.

The returned dict contains at least an “id” parameter, which can be passed to `get_metric_values()`, `get_version_details()` and `set_active_version()`.

Returns:
    

A dict representing the active version or None if no version is active.

Return type:
    

Union[dict, None]

get_version_details(_version_id_)
    

Gets details for a version of a saved model

Parameters:
    

**version_id** (_str_) – identifier of the version, as returned by `list_versions()`

Returns:
    

details of this trained model

Return type:
    

`dataikuapi.dss.ml.DSSTrainedPredictionModelDetails`

set_active_version(_version_id_)
    

Sets a particular version of the saved model as the active one.

Parameters:
    

**version_id** (_str_) – Identifier of the version, as returned by `list_versions()`

delete_versions(_versions_ , _remove_intermediate =True_)
    

Deletes version(s) of the saved model.

Parameters:
    

  * **versions** (_list_ _[__str_ _]_) – list of versions to delete

  * **remove_intermediate** (_bool_) – If True, also removes intermediate versions. In the case of a partitioned model, an intermediate version is created every time a partition has finished training. (defaults to **True**)




get_origin_ml_task()
    

Fetches the last ML task that has been exported to this saved model.

Returns:
    

origin ML task or None if the saved model does not have an origin ml task

Return type:
    

Union[`dataikuapi.dss.ml.DSSMLTask`, None]

import_mlflow_version_from_path(_version_id_ , _path_ , _code_env_name ='LOCAL-CODE-ENV'_, _container_exec_config_name ='LOCAL-CONFIG'_, _set_active =True_, _binary_classification_threshold =0.5_)
    

Creates a new version for this saved model from a path containing a MLFlow model.

Important

Requires the saved model to have been created using [`dataikuapi.dss.project.DSSProject.create_mlflow_pyfunc_model()`](<projects.html#dataikuapi.dss.project.DSSProject.create_mlflow_pyfunc_model> "dataikuapi.dss.project.DSSProject.create_mlflow_pyfunc_model").

Parameters:
    

  * **version_id** (_str_) – identifier of the version, as returned by `list_versions()`

  * **path** (_str_) – absolute path on the local filesystem - must be a folder, and must contain a MLFlow model

  * **code_env_name** (_str_) – 

Name of the code env to use for this model version. The code env must contain at least mlflow and the package(s) corresponding to the used MLFlow-compatible frameworks. * If value is “LOCAL-CODE-ENV”, the active code env will be used. If no env is found, fallback to “INHERIT”. * If value is “INHERIT”, the default active code env of the project will be used.

(defaults to **LOCAL-CODE-ENV**)

  * **container_exec_config_name** (_str_) – 

Name of the containerized execution configuration to use for reading the metadata of the model * If value is “LOCAL-CONFIG”, set the variable to the active containerized configuration name. If running locally, set it to “NONE”. If the config name can’t be determined, fallback to “INHERIT”. * If value is “INHERIT”, the container execution configuration of the project will be used. * If value is “NONE”, local execution will be used (no container)

(defaults to **LOCAL-CONFIG**)

  * **set_active** (_bool_) – sets this new version as the active version of the saved model (defaults to **True**)

  * **binary_classification_threshold** (_float_) – for binary classification, defines the actual threshold for the imported version (defaults to **0.5**)



Returns:
    

external model version handler in order to interact with the new MLFlow model version

Return type:
    

`dataikuapi.dss.savedmodel.ExternalModelVersionHandler`

import_mlflow_version_from_managed_folder(_version_id_ , _managed_folder_ , _path_ , _code_env_name ='LOCAL-CODE-ENV'_, _container_exec_config_name ='LOCAL-CONFIG'_, _set_active =True_, _binary_classification_threshold =0.5_)
    

Creates a new version for this saved model from a managed folder.

Important

Requires the saved model to have been created using [`dataikuapi.dss.project.DSSProject.create_mlflow_pyfunc_model()`](<projects.html#dataikuapi.dss.project.DSSProject.create_mlflow_pyfunc_model> "dataikuapi.dss.project.DSSProject.create_mlflow_pyfunc_model").

Parameters:
    

  * **version_id** (_str_) – identifier of the version, as returned by `list_versions()`

  * **managed_folder** ([`dataikuapi.dss.managedfolder.DSSManagedFolder`](<managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder> "dataikuapi.dss.managedfolder.DSSManagedFolder") or str) – managed folder, or identifier of the managed folder

  * **path** (_str_) – path of the MLflow folder in the managed folder

  * **code_env_name** (_str_) – 

Name of the code env to use for this model version. The code env must contain at least mlflow and the package(s) corresponding to the used MLFlow-compatible frameworks. * If value is “LOCAL-CODE-ENV”, the active code env will be used. If no env is found, fallback to “INHERIT”. * If value is “INHERIT”, the default active code env of the project will be used.

(defaults to **LOCAL-CODE-ENV**)

  * **container_exec_config_name** (_str_) – 

Name of the containerized execution configuration to use for reading the metadata of the model * If value is “LOCAL-CONFIG”, set the variable to the active containerized configuration name. If running locally, set it to “NONE”. If the config name can’t be determined, fallback to “INHERIT”. * If value is “INHERIT”, the container execution configuration of the project will be used. * If value is “NONE”, local execution will be used (no container)

(defaults to **LOCAL-CONFIG**)

  * **set_active** (_bool_) – sets this new version as the active version of the saved model (defaults to **True**)

  * **binary_classification_threshold** (_float_) – for binary classification, defines the actual threshold for the imported version (defaults to **0.5**)



Returns:
    

external model version handler in order to interact with the new MLFlow model version

Return type:
    

`dataikuapi.dss.savedmodel.ExternalModelVersionHandler`

import_mlflow_version_from_databricks(_version_id_ , _connection_name_ , _use_unity_catalog_ , _model_name_ , _model_version_ , _code_env_name ='LOCAL-CODE-ENV'_, _container_exec_config_name ='LOCAL-CONFIG'_, _set_active =True_, _binary_classification_threshold =0.5_)
    

create_external_model_version(_version_id_ , _configuration_ , _target_column_name =None_, _class_labels =None_, _set_active =True_, _binary_classification_threshold =0.5_, _input_dataset =None_, _selection =None_, _use_optimal_threshold =True_, _skip_expensive_reports =True_, _features_list =None_, _container_exec_config_name ='LOCAL-CONFIG'_, _input_format ='GUESS'_, _output_format ='GUESS'_, _evaluate =True_)
    

Creates a new version of an external model.

Important

Requires the saved model to have been created using [`dataikuapi.dss.project.DSSProject.create_external_model()`](<projects.html#dataikuapi.dss.project.DSSProject.create_external_model> "dataikuapi.dss.project.DSSProject.create_external_model").

Parameters:
    

  * **version_id** (_str_) – Identifier of the version, as returned by `list_versions()`

  * **configuration** (_dict_) – 

A dictionary containing the desired saved model version configuration.

    * For SageMaker, syntax is:
          
          configuration = {
              "protocol": "sagemaker",
              "endpoint_name": "<endpoint-name>"
          }
          

    * For AzureML, syntax is:
          
          configuration = {
              "protocol": "azure-ml",
              "endpoint_name": "<endpoint-name>"
          }
          

    * For Vertex AI, syntax is:
          
          configuration = {
              "protocol": "vertex-ai",
              "endpoint_id": "<endpoint-id>"
          }
          

    * For Databricks, syntax is:
          
          configuration = {
              "protocol": "databricks",
              "endpointName": "<endpoint-id>"
          }
          

  * **target_column_name** (_str_) – Name of the target column. Mandatory if model performance will be evaluated

  * **class_labels** (_list_ _or_ _None_) – List of strings, ordered class labels. Mandatory for evaluation of classification models

  * **set_active** (_bool_) – (optional) Sets this new version as the active version of the saved model (defaults to **True**)

  * **binary_classification_threshold** (_float_) – (optional) For binary classification, defines the actual threshold for the imported version (defaults to **0.5**). Overwritten during evaluation if an evaluation dataset is specified and use_optimal_threshold is True

  * **input_dataset** (str or [`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset") or [`dataiku.Dataset`](<datasets.html#dataiku.Dataset> "dataiku.Dataset")) – (mandatory if either evaluate=True, input_format=GUESS, output_format=GUESS, features_list is None) Dataset to use to infer the features names and types (if features_list is not set), evaluate the model, populate interpretation tabs, and guess input/output formats (if input_format=GUESS or output_format=GUESS).

  * **selection** (dict or `DSSDatasetSelectionBuilder` or None) – 

(optional) Sampling parameter for input_dataset during evaluation.

    * Example 1: head 100 lines `DSSDatasetSelectionBuilder().with_head_sampling(100)`

    * Example 2: random 500 lines `DSSDatasetSelectionBuilder().with_random_fixed_nb_sampling(500)`

    * Example 3: head 100 lines `{"samplingMethod": "HEAD_SEQUENTIAL", "maxRecords": 100}`

Defaults to head 100 lines

  * **use_optimal_threshold** (_bool_) – (optional) Set as threshold for this model version the threshold that has been computed during evaluation according to the metric set on the saved model setting (i.e. `prediction_metrics_settings['thresholdOptimizationMetric']`)

  * **skip_expensive_reports** (_bool_) – (optional) Skip computation of expensive/slow reports (e.g. feature importance).

  * **features_list** (list of `{"name": "feature_name", "type": "feature_type"}` or None) – (optional) List of features, in JSON. Used if input_dataset is not defined

  * **container_exec_config_name** (_str_) – (optional) name of the containerized execution configuration to use for running the evaluation process. * If value is “LOCAL-CONFIG”, set the variable to the active containerized configuration name. If running locally, set it to “NONE”. If the config name can’t be determined, fallback to “INHERIT”. * If value is “INHERIT”, the container execution configuration of the project will be used. * If value is “NONE”, local execution will be used (no container) (defaults to **LOCAL-CONFIG**)

  * **input_format** (_str_) – 

(optional) Input format to use when querying the underlying endpoint. For the ‘azure-ml’ and ‘sagemaker’ protocols, this option must be set if input_dataset is not set. Supported values are:

    * For all protocols:
    
      * GUESS (default): Guess the input format by cycling through supported input formats and making requests using data from input_dataset.

    * For Amazon SageMaker:
    
      * INPUT_SAGEMAKER_CSV

      * INPUT_SAGEMAKER_JSON

      * INPUT_SAGEMAKER_JSON_EXTENDED

      * INPUT_SAGEMAKER_JSONLINES

      * INPUT_DEPLOY_ANYWHERE_ROW_ORIENTED_JSON

    * For Vertex AI:
    
      * INPUT_VERTEX_DEFAULT

    * For Azure Machine Learning:
    
      * INPUT_AZUREML_JSON_INPUTDATA

      * INPUT_AZUREML_JSON_WRITER

      * INPUT_AZUREML_JSON_INPUTDATA_DATA

      * INPUT_DEPLOY_ANYWHERE_ROW_ORIENTED_JSON

    * For Databricks:
    
      * INPUT_RECORD_ORIENTED_JSON

      * INPUT_SPLIT_ORIENTED_JSON

      * INPUT_TF_INPUTS_JSON

      * INPUT_TF_INSTANCES_JSON

      * INPUT_DATABRICKS_CSV

  * **output_format** (_str_) – 

(optional) Output format to use to parse the underlying endpoint’s response. For the ‘azure-ml’ and ‘sagemaker’ protocols, this option must be set if input_dataset is not set. Supported values are:

    * For all protocols:
    
      * GUESS (default): Guess the output format by cycling through supported output formats and making requests using data from input_dataset.

    * For Amazon SageMaker:
    
      * OUTPUT_SAGEMAKER_CSV

      * OUTPUT_SAGEMAKER_ARRAY_AS_STRING

      * OUTPUT_SAGEMAKER_JSON

      * OUTPUT_DEPLOY_ANYWHERE_JSON

    * For Vertex AI:
    
      * OUTPUT_VERTEX_DEFAULT

    * For Azure Machine Learning:
    
      * OUTPUT_AZUREML_JSON_OBJECT

      * OUTPUT_AZUREML_JSON_ARRAY

      * OUTPUT_DEPLOY_ANYWHERE_JSON

    * For Databricks:
    
      * OUTPUT_DATABRICKS_JSON

  * **evaluate** (_bool_) – (optional) True (default) if this model should be evaluated using input_dataset, False to disable evaluation.




  * Example: create a SageMaker Saved Model and add an endpoint as a version, evaluated on a dataset:
        
        import dataiku
        client = dataiku.api_client()
        project = client.get_default_project()
        # create a SageMaker saved model, whose endpoints are hosted in region eu-west-1
        sm = project.create_external_model("SaveMaker External Model", "BINARY_CLASSIFICATION", {"protocol": "sagemaker", "region": "eu-west-1"})
        
        # configuration to add endpoint
        configuration = {
          "protocol": "sagemaker",
          "endpoint_name": "titanic-survived-endpoint"
        }
        smv = sm.create_external_model_version("v0",
                                          configuration,
                                          target_column_name="Survived",
                                          class_labels=["0", "1"],
                                          input_dataset="evaluation_dataset")
        

A dataset named “evaluation_dataset” must exist in the current project. Its schema and content should match the endpoint expectations. Depending on the way the model deployed on the endpoint was created, it may require a certain schema and not accept extra columns, it may not deal with missing features, etc.

  * Example: create a Vertex AI Saved Model and add an endpoint as a version, without evaluating it:
        
        import dataiku
        client = dataiku.api_client()
        project = client.get_default_project()
        # create a VertexAI saved model, whose endpoints are hosted in region europe-west-1
        sm = project.create_external_model("Vertex AI Proxy Model", "BINARY_CLASSIFICATION", {"protocol":"vertex-ai", "region":"europe-west1"})
        configuration = {
            "protocol":"vertex-ai",
            "project_id": "my-project",
            "endpoint_id": "123456789012345678"
        }
        
        smv = sm.create_external_model_version("v1",
                                            configuration,
                                            target_column_name="Survived",
                                            class_labels=["0", "1"],
                                            input_dataset="titanic")
        

A dataset named “my_dataset” must exist in the current project. It will be used to infer the schema of the data to submit to the endpoint. As there is no evaluation dataset specified, the interpretation tabs of this model version will be for the most empty. But the model still can be used to score datasets. It can also be evaluated on a dataset by an Evaluation Recipe.

  * Example: create an AzureML Saved Model
        
        import dataiku
        client = dataiku.api_client()
        project = client.get_default_project()
        # create an Azure ML saved model. No region specified, as this notion does not exist for Azure ML
        sm = project.create_external_model("Azure ML Proxy Model", "BINARY_CLASSIFICATION", {"protocol": "azure-ml"})
        configuration = {
            "protocol": "azure-ml",
            "subscription_id": "<subscription-id>>",
            "resource_group": "<your.resource.group-rg>",
            "workspace": "<your-workspace>",
            "endpoint_name": "<endpoint-name>"
        }
        
        features_list = [{'name': 'Pclass', 'type': 'bigint'},
                         {'name': 'Age', 'type': 'double'},
                         {'name': 'SibSp', 'type': 'bigint'},
                         {'name': 'Parch', 'type': 'bigint'},
                         {'name': 'Fare', 'type': 'double'}]
        
        
        smv = sm.create_external_model_version("20230324-in-prod",
                                            configuration,
                                            target_column_name="Survived",
                                            class_labels=["0", "1"],
                                            features_list=features_list)
        

  * Example: minimalistic creation of a VertexAI model binary classification model
        
        import dataiku
        client = dataiku.api_client()
        project = client.get_default_project()
        
        sm = project.create_external_model("Raw Vertex AI Proxy Model", "BINARY_CLASSIFICATION", {"protocol": "vertex-ai", "region": "europe-west1"})
        configuration = {
            "protocol": "vertex-ai",
            "project_id": "my-project",
            "endpoint_id": "123456789012345678"
        }
        
        smv = sm.create_external_model_version("legacy-model",
                                            configuration,
                                            class_labels=["0", "1"])
        

This model will have empty interpretation tabs and can not be evaluated later by an Evaluation Recipe, as its target is not defined, but it can be scored.

  * Example: create a Databricks Saved Model
        
        import dataiku
        client = dataiku.api_client()
        project = client.get_default_project()
        
        sm = project.create_external_model("Databricks External Model", "BINARY_CLASSIFICATION", {"protocol": "databricks","connection": "db"})
        
        smv = sm.create_external_model_version("vX",
                          {"protocol": "databricks", "endpointName": "<endpoint-name>"},
                          target_column_name="Survived",
                          class_labels=["0", "1"],
                          input_dataset="train_titanic_prepared")
        




get_external_model_version_handler(_version_id_)
    

Returns a handler to interact with an external model version (MLflow or Proxy model)

Parameters:
    

**version_id** (_str_) – identifier of the version, as returned by `list_versions()`

Returns:
    

external model version handler

Return type:
    

`dataikuapi.dss.savedmodel.ExternalModelVersionHandler`

get_metric_values(_version_id_)
    

Gets the values of the metrics on the specified version of this saved model

Parameters:
    

**version_id** (_str_) – identifier of the version, as returned by `list_versions()`

Returns:
    

a list of metric objects and their value

Return type:
    

list

get_zone()
    

Gets the flow zone of this saved model

Returns:
    

the saved model’s flow zone

Return type:
    

[`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone")

move_to_zone(_zone_)
    

Moves this object to a flow zone

Parameters:
    

**zone** ([`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone")) – flow zone where the object should be moved

share_to_zone(_zone_)
    

Shares this object to a flow zone

Parameters:
    

**zone** ([`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone")) – flow zone where the object should be shared

unshare_from_zone(_zone_)
    

Unshares this object from a flow zone

Parameters:
    

**zone** ([`dataikuapi.dss.flow.DSSFlowZone`](<flow.html#dataikuapi.dss.flow.DSSFlowZone> "dataikuapi.dss.flow.DSSFlowZone")) – flow zone from which the object shouldn’t be shared

get_usages()
    

Gets the recipes referencing this model

Returns:
    

a list of usages

Return type:
    

list

get_object_discussions()
    

Gets a handle to manage discussions on the saved model

Returns:
    

the handle to manage discussions

Return type:
    

[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")

delete()
    

Deletes the saved model

_class _dataikuapi.dss.savedmodel.DSSSavedModelSettings(_saved_model_ , _settings_)
    

Handle on the settings of a saved model.

Important

Do not create this class directly, instead use `dataikuapi.dss.DSSSavedModel.get_settings()`

Parameters:
    

  * **saved_model** (`dataikuapi.dss.savedmodel.DSSSavedModel`) – the saved model object

  * **settings** (_dict_) – the settings of the saved model




get_raw()
    

Returns the raw settings of the saved model

Returns:
    

the raw settings of the saved model

Return type:
    

dict

_property _prediction_metrics_settings
    

Returns the metrics-related settings

Return type:
    

dict

_property _prediction_type
    

Returns the type of prediction-related settings

Return type:
    

str

save()
    

Saves the settings of this saved model

_class _dataiku.core.saved_model.SavedModelVersionMetrics(_metrics_ , _version_id_)
    

Handle to the metrics of a version of a saved model

get_performance_values()
    

Retrieve the metrics as a dict.

Return type:
    

dict

get_computed()
    

Get the underlying metrics object.

Return type:
    

[`dataiku.core.metrics.ComputedMetrics`](<metrics.html#dataiku.core.metrics.ComputedMetrics> "dataiku.core.metrics.ComputedMetrics")

_class _dataiku.Model(_lookup_ , _project_key =None_, _ignore_flow =False_)
    

Handle to interact with a saved model.

Note

This class is also available as `dataiku.Model`

Parameters:
    

  * **lookup** (_string_) – name or identifier of the saved model

  * **project_key** (_string_) – project key of the saved model, if it is not in the current project. (defaults to **None** , i.e. current project)

  * **ignore_flow** (_boolean_) – if True, create the handle regardless of whether the saved model is an input or output of the recipe (defaults to **False**)




_static _list_models(_project_key =None_)
    

Retrieves the list of saved models of the given project.

Parameters:
    

**project_key** (_str_) – key of the project from which to list models. (defaults to **None** , i.e. current project)

Returns:
    

a list of the saved models of the project, as dict. Each dict contains at least the following fields:

  * **id** : identifier of the saved model

  * **name** : name of the saved model

  * **type** : type of saved model (CLUSTERING / PREDICTION)

  * **backendType** : backend type of the saved model (PY_MEMORY / KERAS / MLLIB / H2O / DEEP_HUB)

  * **versionsCount** : number of versions in the saved model




Return type:
    

list[dict]

get_info()
    

Gets the model information.

Returns:
    

the model information. Fields are:

  * **id** : identifier of the saved model

  * **projectKey** : project key of the saved model

  * **name** : name of the saved model

  * **type** : type of saved model (CLUSTERING / PREDICTION)




Return type:
    

dict

get_id()
    

Gets the identifier of the model.

Return type:
    

str

get_name()
    

Gets the name of the model

Return type:
    

str

get_type()
    

Gets the type of the model.

Returns:
    

the model type (PREDICTION / CLUSTERING)

Return type:
    

str

get_definition()
    

Gets the model definition.

Return type:
    

dict

list_versions()
    

Lists the model versions.

Note

The `versionId` field can be used to call the `activate_version()` method.

Returns:
    

Information about versions of the saved model, as a list of dict. Fields are:

  * **versionId** : identifier of the model version

  * **active** : whether this version is active or not

  * **snippet** : detailed dict containing version information




Return type:
    

list[dict]

activate_version(_version_id_)
    

Activates the given version of the model.

Parameters:
    

**version_id** (_str_) – the identifier of the version to activate

get_version_metrics(_version_id_)
    

Gets the training metrics of a given version of the model.

Parameters:
    

**version_id** (_str_) – the identifier of the version from which to retrieve metrics

Return type:
    

`dataiku.core.saved_model.SavedModelVersionMetrics`

get_version_checks(_version_id_)
    

Gets the training checks of the given version of the model.

Parameters:
    

**version_id** (_str_) – the identifier of the version from which to retrieve checks

Return type:
    

[`dataiku.core.metrics.ComputedChecks`](<metrics.html#dataiku.core.metrics.ComputedChecks> "dataiku.core.metrics.ComputedChecks")

save_external_check_values(_values_dict_ , _version_id_)
    

Saves checks on the model, the checks are saved with the type “external”.

Parameters:
    

  * **values_dict** (_dict_) – the values to save, as a dict. The keys of the dict are used as check names

  * **version_id** (_str_) – the identifier of the version for which checks should be saved



Return type:
    

dict

get_predictor(_version_id =None_, _optimize ='BATCH'_)
    

Returns a `Predictor` for the given version of the model.

Note

This predictor can then be used to preprocess and make predictions on a dataframe.

Parameters:
    

  * **optimize** – If set to `LATENCY`, attempts (if the model is compatible) to build a predictor optimized for latency (leveraging the `dataikuscoring` package). In this case, beware that the returned `Predictor` only supports the `predictor.predict(df, with_input_cols=False, with_prediction=True, with_probas=False)` method, with no other arguments passed.

  * **version_id** (_str_) – the identifier of the version from which to build the predictor (defaults to **None** , current active version)



Returns:
    

The predictor built from the given version of this model

Return type:
    

Union[`dataiku.core.saved_model.BasePredictor`, `dataiku.core.saved_model.DkuScoringPredictor`]

create_finetuned_llm_version(_connection_name_ , _quantization =None_, _set_active =True_)
    

Creates a new fine-tuned LLM version, using a context manager (experimental)

Upon exit of the context manager, the new model version is made available with the content of the working directory. The model weights must use the safetensors format. This model will be loaded at inference time with trust_remote_code=False.

Simple usage:
    
    
    with saved_model.create_finetuned_llm_version("MyLocalHuggingfaceConnection") as finetuned_llm_version:
        # write model files to finetuned_llm_version.working_directory
    # the new version is now available
    

Parameters:
    

  * **connection_name** (_str_) – name of the connection to link this version

  * **quantization** (_str_) – quantization mode, must be one of [None, “Q_4BIT”, “Q_8BIT”] (default: None)

  * **set_active** (_bool_) – if True, set the new version as active for this saved model (default: True)



Returns:
    

yields a `FinetunedLLMVersionTrainingParameters` object

_class _dataiku.core.saved_model.BasePredictor(_params_ , _clf_)
    

Object allowing to preprocess and make predictions on a dataframe.

get_classes()
    

Returns the classes from which this model will predict if a classifier, None if a regressor

get_proba_columns()
    

Returns the names of the probability columns if a classifier, None if a regressor

get_conditional_output_names()
    

Returns the name of all conditional outputs defined for this model (note: limited to binary classifiers)

ready_explainer()
    

Preload the necessary components to compute explanations :param df: data from which the random sample have to be drawn :type df: pd.DataFrame

_class _dataiku.core.saved_model.DkuScoringPredictor(_export_id_)
    

predict(_df_ , _with_input_cols =False_, _with_prediction =True_, _with_probas =False_, _** kwargs_)
    

Predict a dataframe. The results are returned as a dataframe with columns corresponding to the various prediction information.

Parameters:
    

  * **df** – list, or array or DataFrame containing the rows to predict

  * **with_input_cols** – whether the input columns should also be present in the output

  * **with_prediction** – whether the prediction column should be present

  * **with_probas** – whether the probability columns should be present




No other argument is supported for this latency-optimized predictor.

### MLflow models

_class _dataikuapi.dss.savedmodel.ExternalModelVersionHandler(_saved_model_ , _version_id_)
    

Handler to interact with an External model version (MLflow import of Proxy model).

Important

Do not create this class directly, instead use `dataikuapi.dss.savedmodel.DSSSavedModel.get_external_model_version_handler()`

Parameters:
    

  * **saved_model** (`dataikuapi.dss.savedmodel.DSSSavedModel`) – the saved model object

  * **version_id** (_str_) – identifier of the version, as returned by `dataikuapi.dss.savedmodel.DSSSavedModel.list_versions()`




get_settings()
    

Returns the settings of the MLFlow model version

Returns:
    

settings of the MLFlow model version

Return type:
    

`dataikuapi.dss.savedmodel.MLFlowVersionSettings`

set_core_metadata(_target_column_name_ , _class_labels =None_, _get_features_from_dataset =None_, _features_list =None_, _container_exec_config_name ='LOCAL-CONFIG'_, _get_features_from_dataset_sampling =None_)
    

Sets metadata for this MLFlow model version

In addition to `target_column_name`, one of `get_features_from_dataset` or `features_list` must be passed in order to be able to evaluate performance

Parameters:
    

  * **target_column_name** (_str_) – name of the target column. Mandatory in order to be able to evaluate performance

  * **class_labels** (_list_ _or_ _None_) – List of strings, ordered class labels. Mandatory in order to be able to evaluate performance on classification models

  * **get_features_from_dataset** (_str_ _or_ _None_) – name of a dataset to get feature names from

  * **features_list** (_list_ _or_ _None_) – list of `{"name": "feature_name", "type": "feature_type"}`

  * **container_exec_config_name** (_str_) – 

name of the containerized execution configuration to use for running the evaluation process. * If value is “LOCAL-CONFIG”, set the variable to the active containerized configuration name. If running locally, set it to “NONE”. If the config name can’t be determined, fallback to “INHERIT”. * If value is “INHERIT”, the container execution configuration of the project will be used. * If value is “NONE”, local execution will be used (no container)

(defaults to **LOCAL-CONFIG**)

  * **get_features_from_dataset_sampling** (_dict_ _,__optional_) – sampling method for get_features_from_dataset, see [`dataiku.core.dataset.create_sampling_argument()`](<datasets.html#dataiku.core.dataset.create_sampling_argument> "dataiku.core.dataset.create_sampling_argument"). If None, a default sampling with method: ‘head’, limit: 500 will be used (first 500 rows)




evaluate(_dataset_ref_ , _container_exec_config_name ='LOCAL-CONFIG'_, _selection =None_, _use_optimal_threshold =True_, _skip_expensive_reports =True_)
    

Evaluates the performance of this model version on a particular dataset. After calling this, the “result screens” of the MLFlow model version will be available (confusion matrix, error distribution, performance metrics, …) and more information will be available when calling: `dataikuapi.dss.savedmodel.DSSSavedModel.get_version_details()`

Evaluation is available only for models having BINARY_CLASSIFICATION, MULTICLASS or REGRESSION as prediction type. See `DSSProject.create_mlflow_pyfunc_model()`.

Important

`set_core_metadata()` must be called before you can evaluate a dataset

Parameters:
    

  * **dataset_ref** (str or [`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset") or [`dataiku.Dataset`](<datasets.html#dataiku.Dataset> "dataiku.Dataset")) – Evaluation dataset to use

  * **container_exec_config_name** (_str_) – 

Name of the containerized execution configuration to use for running the evaluation process. * If value is “LOCAL-CONFIG”, set the variable to the active containerized configuration name. If running locally, set it to “NONE”. If the config name can’t be determined, fallback to “INHERIT”. * If value is “INHERIT”, the container execution configuration of the project will be used. * If value is “NONE”, local execution will be used (no container)

(defaults to **LOCAL-CONFIG**)

  * **selection** (dict or `DSSDatasetSelectionBuilder` or None) – 

Sampling parameter for the evaluation.

    * Example 1: `DSSDatasetSelectionBuilder().with_head_sampling(100)`

    * Example 2: `{"samplingMethod": "HEAD_SEQUENTIAL", "maxRecords": 100}`

(defaults to **None**)

  * **use_optimal_threshold** (_bool_) – Choose between optimized or actual threshold. Optimized threshold has been computed according to the metric set on the saved model setting (i.e. `prediction_metrics_settings['thresholdOptimizationMetric']`) (defaults to **True**)

  * **skip_expensive_reports** (_boolean_) – Skip expensive/slow reports (e.g. feature importance).




_class _dataikuapi.dss.savedmodel.MLFlowVersionSettings(_version_handler_ , _data_)
    

Handle for the settings of an imported MLFlow model version.

Important

Do not create this class directly, instead use `dataikuapi.dss.savedmodel.ExternalModelVersionHandler.get_settings()`

Parameters:
    

  * **version_handler** (`dataikuapi.dss.savedmodel.ExternalModelVersionHandler`) – handler to interact with an external model version

  * **data** (_dict_) – raw settings of the imported MLFlow model version




_property _raw
    

Returns:
    

The raw settings of the imported MLFlow model version

Return type:
    

dict

save()
    

Saves the settings of this MLFlow model version

### dataiku.Model

_class _dataiku.Model(_lookup_ , _project_key =None_, _ignore_flow =False_)
    

Handle to interact with a saved model.

Note

This class is also available as `dataiku.Model`

Parameters:
    

  * **lookup** (_string_) – name or identifier of the saved model

  * **project_key** (_string_) – project key of the saved model, if it is not in the current project. (defaults to **None** , i.e. current project)

  * **ignore_flow** (_boolean_) – if True, create the handle regardless of whether the saved model is an input or output of the recipe (defaults to **False**)




_static _list_models(_project_key =None_)
    

Retrieves the list of saved models of the given project.

Parameters:
    

**project_key** (_str_) – key of the project from which to list models. (defaults to **None** , i.e. current project)

Returns:
    

a list of the saved models of the project, as dict. Each dict contains at least the following fields:

  * **id** : identifier of the saved model

  * **name** : name of the saved model

  * **type** : type of saved model (CLUSTERING / PREDICTION)

  * **backendType** : backend type of the saved model (PY_MEMORY / KERAS / MLLIB / H2O / DEEP_HUB)

  * **versionsCount** : number of versions in the saved model




Return type:
    

list[dict]

get_info()
    

Gets the model information.

Returns:
    

the model information. Fields are:

  * **id** : identifier of the saved model

  * **projectKey** : project key of the saved model

  * **name** : name of the saved model

  * **type** : type of saved model (CLUSTERING / PREDICTION)




Return type:
    

dict

get_id()
    

Gets the identifier of the model.

Return type:
    

str

get_name()
    

Gets the name of the model

Return type:
    

str

get_type()
    

Gets the type of the model.

Returns:
    

the model type (PREDICTION / CLUSTERING)

Return type:
    

str

get_definition()
    

Gets the model definition.

Return type:
    

dict

list_versions()
    

Lists the model versions.

Note

The `versionId` field can be used to call the `activate_version()` method.

Returns:
    

Information about versions of the saved model, as a list of dict. Fields are:

  * **versionId** : identifier of the model version

  * **active** : whether this version is active or not

  * **snippet** : detailed dict containing version information




Return type:
    

list[dict]

activate_version(_version_id_)
    

Activates the given version of the model.

Parameters:
    

**version_id** (_str_) – the identifier of the version to activate

get_version_metrics(_version_id_)
    

Gets the training metrics of a given version of the model.

Parameters:
    

**version_id** (_str_) – the identifier of the version from which to retrieve metrics

Return type:
    

`dataiku.core.saved_model.SavedModelVersionMetrics`

get_version_checks(_version_id_)
    

Gets the training checks of the given version of the model.

Parameters:
    

**version_id** (_str_) – the identifier of the version from which to retrieve checks

Return type:
    

[`dataiku.core.metrics.ComputedChecks`](<metrics.html#dataiku.core.metrics.ComputedChecks> "dataiku.core.metrics.ComputedChecks")

save_external_check_values(_values_dict_ , _version_id_)
    

Saves checks on the model, the checks are saved with the type “external”.

Parameters:
    

  * **values_dict** (_dict_) – the values to save, as a dict. The keys of the dict are used as check names

  * **version_id** (_str_) – the identifier of the version for which checks should be saved



Return type:
    

dict

get_predictor(_version_id =None_, _optimize ='BATCH'_)
    

Returns a `Predictor` for the given version of the model.

Note

This predictor can then be used to preprocess and make predictions on a dataframe.

Parameters:
    

  * **optimize** – If set to `LATENCY`, attempts (if the model is compatible) to build a predictor optimized for latency (leveraging the `dataikuscoring` package). In this case, beware that the returned `Predictor` only supports the `predictor.predict(df, with_input_cols=False, with_prediction=True, with_probas=False)` method, with no other arguments passed.

  * **version_id** (_str_) – the identifier of the version from which to build the predictor (defaults to **None** , current active version)



Returns:
    

The predictor built from the given version of this model

Return type:
    

Union[`dataiku.core.saved_model.BasePredictor`, `dataiku.core.saved_model.DkuScoringPredictor`]

create_finetuned_llm_version(_connection_name_ , _quantization =None_, _set_active =True_)
    

Creates a new fine-tuned LLM version, using a context manager (experimental)

Upon exit of the context manager, the new model version is made available with the content of the working directory. The model weights must use the safetensors format. This model will be loaded at inference time with trust_remote_code=False.

Simple usage:
    
    
    with saved_model.create_finetuned_llm_version("MyLocalHuggingfaceConnection") as finetuned_llm_version:
        # write model files to finetuned_llm_version.working_directory
    # the new version is now available
    

Parameters:
    

  * **connection_name** (_str_) – name of the connection to link this version

  * **quantization** (_str_) – quantization mode, must be one of [None, “Q_4BIT”, “Q_8BIT”] (default: None)

  * **set_active** (_bool_) – if True, set the new version as active for this saved model (default: True)



Returns:
    

yields a `FinetunedLLMVersionTrainingParameters` object

_class _dataiku.core.saved_model.Predictor(_params_ , _preprocessing_ , _features_ , _clf_)
    

Object allowing to preprocess and make predictions on a dataframe.

get_features()
    

Returns the feature names generated by this predictor’s preprocessing

predict(_df_ , _with_input_cols =False_, _with_prediction =True_, _with_probas =True_, _with_conditional_outputs =False_, _with_proba_percentile =False_, _with_explanations =False_, _explanation_method ='ICE'_, _n_explanations =3_, _n_explanations_mc_steps =100_, _** kwargs_)
    

Predict a dataframe. The results are returned as a dataframe with columns corresponding to the various prediction information.

Parameters:
    

  * **with_input_cols** – whether the input columns should also be present in the output

  * **with_prediction** – whether the prediction column should be present

  * **with_probas** – whether the probability columns should be present

  * **with_conditional_outputs** – whether the conditional outputs for this model should be present (binary classif)

  * **with_proba_percentile** – whether the percentile of the probability should be present (binary classif)

  * **with_explanations** – whether explanations should be computed for each prediction

  * **explanation_method** – method to compute the explanations

  * **n_explanations** – number of explanations to output for each prediction

  * **n_explanations_mc_steps** – number of Monte Carlo steps for SHAPLEY method (higher means more precise but slower)




preformat(_df_)
    

Formats data originating from json (api node, interactive scoring) so that it’s compatible with preprocess

preprocess(_df_)
    

Preprocess a dataframe. The results are returned as a numpy 2-dimensional matrix (which may be sparse). The columns of this matrix correspond to the generated features, which can be listed by the get_features property of this Predictor.

get_preprocessing()
    

## Algorithm details

This section documents which algorithms are available, and some of the settings for them.

These algorithm names can be used for `dataikuapi.dss.ml.DSSMLTaskSettings.get_algorithm_settings()` and `dataikuapi.dss.ml.DSSMLTaskSettings.set_algorithm_enabled()`

Note

This documentation does not cover all settings of all algorithms. To know which settings are available for an algorithm, use `mltask_settings.get_algorithm_settings('ALGORITHM_NAME')` and print the returned dictionary.

Generally speaking, most algorithm settings which are arrays means that this parameter can be grid-searched. All values will be tested as part of the hyperparameter optimization.

For more documentation of settings, please refer to the UI of the visual machine learning, which contains detailed documentation for all algorithm parameters

### LOGISTIC_REGRESSION

  * Type: Prediction (binary or multiclass)

  * Available on backend: PY_MEMORY

  * Main parameters:



    
    
    {
        "multi_class": SingleCategoryHyperparameterSettings, # accepted valued: ['multinomial', 'ovr']
        "penalty": CategoricalHyperparameterSettings, # possible values: ["l1", "l2"]
        "C": NumericalHyperparameterSettings, # scaling: "LOGARITHMIC"
        "n_jobs": 2
    }
    

### RANDOM_FOREST_CLASSIFICATION

  * Type: Prediction (binary or multiclass)

  * Available on backend: PY_MEMORY

  * Main parameters:



    
    
    {
        "n_estimators": NumericalHyperparameterSettings, # scaling: "LINEAR"
        "min_samples_leaf": NumericalHyperparameterSettings, # scaling: "LINEAR"
        "max_tree_depth": NumericalHyperparameterSettings, # scaling: "LINEAR"
        "max_feature_prop": NumericalHyperparameterSettings, # scaling: "LINEAR"
        "max_features": NumericalHyperparameterSettings, # scaling: "LINEAR"
        "selection_mode": SingleCategoryHyperparameterSettings, # accepted_values=['auto', 'sqrt', 'log2', 'number', 'prop']
        "n_jobs": 4
    }
    

### RANDOM_FOREST_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY

  * Main parameters: same as RANDOM_FOREST_CLASSIFICATION




### EXTRA_TREES

  * Type: Prediction (all kinds)

  * Available on backend: PY_MEMORY




### RIDGE_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY




### LASSO_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY




### LEASTSQUARE_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY




### SVC_CLASSIFICATION

  * Type: Prediction (binary or multiclass)

  * Available on backend: PY_MEMORY




### SVM_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY




### SGD_CLASSIFICATION

  * Type: Prediction (binary or multiclass)

  * Available on backend: PY_MEMORY




### SGD_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY




### GBT_CLASSIFICATION

  * Type: Prediction (binary or multiclass)

  * Available on backend: PY_MEMORY




### GBT_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY




### DECISION_TREE_CLASSIFICATION

  * Type: Prediction (binary or multiclass)

  * Available on backend: PY_MEMORY




### DECISION_TREE_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY




### LIGHTGBM_CLASSIFICATION

  * Type: Prediction (binary or multiclass)

  * Available on backend: PY_MEMORY




### LIGHTGBM_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY




### XGBOOST_CLASSIFICATION

  * Type: Prediction (binary or multiclass)

  * Available on backend: PY_MEMORY




### XGBOOST_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY




### NEURAL_NETWORK

  * Type: Prediction (all kinds)

  * Available on backend: PY_MEMORY




### TABICL_CLASSIFICATION

  * Type: Prediction (binary or multiclass)

  * Available on backend: PY_MEMORY




### MULTI_LAYER_PERCEPTRON_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: PY_MEMORY




### MULTI_LAYER_PERCEPTRON_CLASSIFICATION

  * Type: Prediction (binary or multiclass)

  * Available on backend: PY_MEMORY




### KNN

  * Type: Prediction (all kinds)

  * Available on backend: PY_MEMORY




### LARS

  * Type: Prediction (all kinds)

  * Available on backend: PY_MEMORY




### MLLIB_LOGISTIC_REGRESSION

  * Type: Prediction (binary or multiclass)

  * Available on backend: MLLIB




### MLLIB_DECISION_TREE

  * Type: Prediction (all kinds)

  * Available on backend: MLLIB




### MLLIB_RANDOM_FOREST

  * Type: Prediction (all kinds)

  * Available on backend: MLLIB




### MLLIB_GBT

  * Type: Prediction (all kinds)

  * Available on backend: MLLIB




### MLLIB_LINEAR_REGRESSION

  * Type: Prediction (regression)

  * Available on backend: MLLIB




### MLLIB_NAIVE_BAYES

  * Type: Prediction (all kinds)

  * Available on backend: MLLIB




### Other

  * SCIKIT_MODEL

  * MLLIB_CUSTOM

---

## [api-reference/python/model-evaluation-stores]

# Model Evaluation Stores

For usage information and examples, see [Model Evaluation Stores](<../../concepts-and-examples/model-evaluation-stores.html>)

There are two main parts related to the handling of model evaluation stores in Dataiku’s Python APIs:

  * `dataiku.core.model_evaluation_store.ModelEvaluationStore` and `dataiku.core.model_evaluation_store.ModelEvaluation` in the dataiku package. They were initially designed for usage within DSS.

  * `dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore` and `dataikuapi.dss.modelevaluationstore.DSSModelEvaluation` in the dataikuapi package. They were initially designed for usage outside of DSS.




Both set of classes have fairly similar capabilities.

## dataiku package API

_class _dataiku.ModelEvaluationStore(_lookup_ , _project_key =None_, _ignore_flow =False_)
    

This is a handle to interact with a model evaluation store.

Note: this class is also available as `dataiku.core.model_evaluation_store.ModelEvaluationStore`

get_info(_sensitive_info =False_)
    

Gets information about the location and settings of this model evaluation store.

Parameters:
    

**sensitive_info** (_bool_) – flag for sensitive information such as the Model Evaluation Store absolute path (defaults to **False**)

Return type:
    

dict

get_path()
    

Gets the filesystem path of this model evaluation store.

Return type:
    

str

get_id()
    

Gets the id of this model evaluation store.

Return type:
    

str

get_name()
    

Gets the name of this model evaluation store.

Return type:
    

str

list_runs()
    

Gets the list of runs of this model evaluation store.

Return type:
    

list of `dataiku.core.model_evaluation_store.ModelEvaluation`

get_evaluation(_evaluation_id_)
    

Gets a model evaluation from the store based on its id.

Parameters:
    

**evaluation_id** (_str_) – the id of the model evaluation to retrieve

Returns:
    

a `dataiku.core.model_evaluation_store.ModelEvaluation` handle on the model evaluation

get_last_metric_values()
    

Gets the set of last values of the metrics on this folder.

Returns:
    

a `dataiku.core.ComputedMetrics` object

get_metric_history(_metric_lookup_)
    

Gets the set of all values a given metric took on this folder.

Parameters:
    

**metric_lookup** – metric name or unique identifier

Return type:
    

dict

_class _dataiku.core.model_evaluation_store.ModelEvaluation(_store_ , _evaluation_id_)
    

This is a handle to interact with a model evaluation from a model evaluation store.

set_preparation_steps(_steps_ , _requested_output_schema_ , _context_project_key =None_)
    

Sets the preparation steps of the input dataset in a model evaluation.

Parameters:
    

  * **steps** (_dict_) – the steps of the preparation

  * **requested_output_schema** (_dict_) – the schema of the prepared input dataset as a list of objects like this one: `{ 'type': 'string', 'name': 'foo', 'maxLength': 1000 }`

  * **context_project_key** (_str_) – a different project key to use instead of the current project key, because the preparation steps can live in a different project than the dataset (defaults to **None**)




get_schema()
    

Gets the schema of the sample used for this model evaluation. There is more information for the map, array and object types.

Return type:
    

list of dict

Returns:
    

a schema as a list of objects like this one: `{ 'type': 'string', 'name': 'foo', 'maxLength': 1000 }`

get_dataframe(_columns =None_, _infer_with_pandas =True_, _parse_dates =True_, _bool_as_str =False_, _float_precision =None_)
    

Reads the sample in the run as a Pandas dataframe.

Pandas dataframes are fully in-memory, so you need to make sure that your dataset will fit in RAM before using this.

Inconsistent sampling parameter raise ValueError.

Note about encoding:

  * Column labels are “unicode” objects

  * When a column is of string type, the content is made of utf-8 encoded “str” objects




Parameters:
    

  * **columns** (_list_ _of_ _dict_) – the columns with information on type, names, etc. e.g. `{ 'type': 'string', 'name': 'foo', 'maxLength': 1000 }` (defaults to **None**)

  * **infer_with_pandas** (_bool_) – uses the types detected by pandas rather than the types from the dataset schema as detected in DSS (defaults to **True**)

  * **parse_dates** (_bool_) – parses date columns in DSS’s dataset schema (defaults to **True**)

  * **bool_as_str** (_bool_) – leaves boolean values as strings (defaults to **False**)

  * **float_precision** (_str_) – float precision for pandas read_table (defaults to **None**)



Returns:
    

a `pandas.Dataframe` representing the sample used in the evaluation

iter_dataframes_forced_types(_names_ , _dtypes_ , _parse_date_columns_ , _sampling =None_, _chunksize =10000_, _float_precision =None_)
    

Reads the model evaluation sample as Pandas dataframes by chunks of fixed size with forced types.

Returns a generator over pandas dataframes.

Useful is the sample doesn’t fit in RAM.

Parameters:
    

  * **names** (_list_ _of_ _str_) – names of the columns of the dataset

  * **dtypes** (_list_ _of_ _str_ _or_ _object_) – data types of the columns

  * **parse_date_columns** (_bool_) – parses date columns in DSS’s dataset schema

  * **sampling** – ignored at the moment (defaults to **None**)

  * **chunksize** (_int_) – the size of the dataframes yielded by the iterator (defaults to **10000**)

  * **float_precision** (_str_) – float precision for pandas read_table (defaults to **None**)



Returns:
    

a generator of `pandas.Dataframe`

iter_dataframes(_chunksize =10000_, _infer_with_pandas =True_, _parse_dates =True_, _columns =None_, _bool_as_str =False_, _float_precision =None_)
    

Read the model evaluation sample to Pandas dataframes by chunks of fixed size.

Returns a generator over pandas dataframes.

Useful is the sample doesn’t fit in RAM.

Parameters:
    

  * **chunksize** (_int_) – the size of the dataframes yielded by the iterator (defaults to **10000**)

  * **infer_with_pandas** (_bool_) – uses the types detected by pandas rather than the dataset schema as detected in DSS (defaults to **True**)

  * **parse_dates** (_bool_) – parses date columns in DSS’s dataset schema (defaults to **True**)

  * **columns** (_list_ _of_ _dict_) – columns of the dataset as dict with names and dtypes (defaults to **None**)

  * **bool_as_str** (_bool_) – leaves boolean values as strings (defaults to **False**)

  * **float_precision** (_str_) – float precision for pandas read_table. For more information on this parameter, please check pandas documentation: <https://pandas.pydata.org/docs/reference/api/pandas.read_table.html> (defaults to **None**)



Returns:
    

a generator of `pandas.Dataframe`

## dataikuapi package API

_class _dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore(_client_ , _project_key_ , _mes_id_)
    

A handle to interact with a model evaluation store on the DSS instance.

Warning

Do not create this directly, use [`dataikuapi.dss.project.DSSProject.get_model_evaluation_store()`](<projects.html#dataikuapi.dss.project.DSSProject.get_model_evaluation_store> "dataikuapi.dss.project.DSSProject.get_model_evaluation_store")

_property _mes_id
    

get_settings()
    

Returns the settings of this model evaluation store.

Return type:
    

DSSModelEvaluationStoreSettings

list_model_evaluations()
    

List the model evaluations in this model evaluation store. The list is sorted by ME creation date.

Returns:
    

The list of the model evaluations

Return type:
    

list of `dataikuapi.dss.modelevaluationstore.DSSModelEvaluation`

get_model_evaluation(_evaluation_id_)
    

Get a handle to interact with a specific model evaluation

Parameters:
    

**evaluation_id** (_string_) – the id of the desired model evaluation

Returns:
    

A `dataikuapi.dss.modelevaluationstore.DSSModelEvaluation` model evaluation handle

get_latest_model_evaluation()
    

Get a handle to interact with the latest model evaluation computed

Returns:
    

A `dataikuapi.dss.modelevaluationstore.DSSModelEvaluation` model evaluation handle if the store is not empty, else None

delete_model_evaluations(_evaluations_)
    

_class _MetricDefinition(_code_ , _value_ , _name =None_, _description =None_)
    

_class _LabelDefinition(_key_ , _value_)
    

add_custom_model_evaluation(_metrics_ , _evaluation_id =None_, _name =None_, _labels =None_, _model =None_)
    

Adds a model evaluation with custom metrics to the model evaluation store.

Parameters:
    

  * **metrics** (_list_ _[__DSSModelEvaluationStore.MetricDefinition_ _]_) – the metrics to add.

  * **evaluation_id** (_str_) – the id of the evaluation (optional)

  * **name** (_str_) – the human-readable name of the evaluation (optional)

  * **labels** (_list_ _[__DSSModelEvaluationStore.LabelDefinition_ _]_) – labels to set on the model evaluation (optionam). See below.

  * **model** (_Union_ _[__str_ _,_[_DSSTrainedPredictionModelDetails_](<ml.html#dataikuapi.dss.ml.DSSTrainedPredictionModelDetails> "dataikuapi.dss.ml.DSSTrainedPredictionModelDetails") _]_) – saved model version (full ID or DSSTrainedPredictionModelDetails) of the evaluated model (optional)




Code sample:
    
    
    import dataiku
    from dataikuapi.dss.modelevaluationstore import DSSModelEvaluationStore
    
    client=dataiku.api_client()
    project=client.get_default_project()
    mes=project.get_model_evaluation_store("7vFZWNck")
    
    accuracy = DSSModelEvaluationStore.MetricDefinition("accuracy", 0.95, "Accuracy")
    other = DSSModelEvaluationStore.MetricDefinition("other", 42, "Other", "Other metric desc")
    label = DSSModelEvaluationStore.LabelDefinition("custom:myLabel", "myValue")
    
    mes.add_custom_model_evaluation([accuracy, other], labels=[label])
    mes.run_checks()
    

_class _dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStoreSettings(_model_evaluation_store_ , _settings_)
    

A handle on the settings of a model evaluation store

Warning

Do not create this class directly, instead use `dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore.get_settings()`

_property _model_evaluation_store
    

_class _dataikuapi.dss.modelevaluationstore.DSSModelEvaluation(_model_evaluation_store_ , _evaluation_id_)
    

A handle on a model evaluation

Warning

Do not create this class directly, instead use `dataikuapi.dss.modelevaluationstore.DSSModelEvaluationStore.get_model_evaluation()`

_property _mes_id
    

get_full_info()
    

Retrieve the model evaluation with its performance data

Returns:
    

the model evaluation full info, as a `dataikuapi.dss.modelevaluationstore.DSSModelEvaluationFullInfo`

_class _dataikuapi.dss.modelevaluationstore.DSSModelEvaluationFullInfo(_model_evaluation_ , _full_info_)
    

A handle on the full information on a model evaluation.

Includes information such as the full id of the evaluated model, the evaluation params, the performance and drift metrics, if any, etc.

Warning

Do not create this class directly, instead use `dataikuapi.dss.modelevaluationstore.DSSModelEvaluation.get_full_info()`

_property _model_evaluation