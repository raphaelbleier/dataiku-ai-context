# Dataiku Docs — dev-api-reference

## [api-reference/python/streaming-endpoints]

# Streaming endpoints

_class _dataiku.StreamingEndpoint(_id_ , _project_key =None_)
    

This is a handle to obtain readers and writers on a dataiku streaming endpoint.

get_location_info(_sensitive_info =False_)
    

Get details on the stream underlying the streaming endpoint.

Parameters:
    

**sensitive_info** (_boolean_) – whether to get the details of the connection this endpoint uses.

Returns:
    

a dict of the information. The top-level has an info field containing

  * **projectKey** and **id** : identifiers for the streaming endpoint

  * **type** : type of streaming endpoint (Kafka, SQS, …)

  * **connection** : name of the connection that the endpoint uses

  * additional fields depending on the connection type. For example kafka endpoints have a **topic** field

  * **connectionParams** : if sensitive info was requested and the user has access to the details of the connection, this field is a dict of the connection params and credentials




Return type:
    

dict

get_schema(_raise_if_empty =True_)
    

Get the schema of this streaming endpoint.

Returns:
    

an array of columns. Each column is a dict with fields:

  * **name** : the column name

  * **type** : the column type (smallint, int, bigint, float, double, boolean, date, string)

  * **length** : the string length

  * **comment** : the column name




Return type:
    

[`dataiku.core.dataset.Schema`](<datasets.html#dataiku.core.dataset.Schema> "dataiku.core.dataset.Schema")

set_schema(_columns_)
    

Set the schema of this streaming endpoint.

Usage example:
    
    
    # copy schema from input to output of recipe
    
        input = dataiku.StreamingEndpoint("input_endpoint_name")
        output = dataiku.StreamingEndpoint("output_endpoint_name")
        output.set_schema(input.get_schema()) 
    

Parameters:
    

**columns** (_list_) – 

an array of columns. Each column is a dict with fields:

  * **name** : the column name

  * **type** : the column type (smallint, int, bigint, float, double, boolean, date, string)

  * **length** : the string length

  * **comment** : the column name




get_writer()
    

Get a stream writer to append to this streaming endpoint as a sink.

Note

The writes are buffered python-side, so the writer must be regularly flushed with calls to `dataiku.core.continuous_write.ContinuousWriterBase.flush()`

Important

The schema of the streaming endpoint MUST be set before using this. If you don’t set the schema of the streaming endpoint, your data will generally not be stored by the output writers

Usage example:
    
    
    # write increasing integers to a stream
    i = 0
    with endpoint.get_writer() as test_writer:
        while True:
            test_writer.write_row_dict({"counter":i})
            test_writer.flush()
            time.sleep(0.1)
            i += 1
    

Returns:
    

a writer to wich records can be sent.

Return type:
    

`dataiku.core.continuous_write.StreamingEndpointContinuousWriter`

get_message_iterator(_previous_state =None_, _columns =[]_)
    

Get the records of the stream underlying the streaming endpoint.

Attention

The effect of the previous state given to this method depends on the underlying streaming system. At the moment it should only be used with systems which can replay messages (for example Kafka).

Usage example:
    
    
    # read 5 first messages
    messages = endpoint.get_message_iterator()
    last_state = None
    for i in range(0, 5):
        print("got: %s" % messages.next())
        last_state = messages.get_state()
    
    # then the rest
    print("last state was %s" % last_state)
    for message in endpoint.get_message_iterator(last_state):
        print("got %s" % message)
    

Parameters:
    

  * **previous_state** (_string_) – string representing a state in the stream. Should be obtained via `dataiku.core.streaming_endpoint.StreamingEndpointStream.get_state()`

  * **columns** (_list_ _[__string_ _]_) – (optional) list of columns to retrieve. Default: retrieve all columns



Returns:
    

a generator of records from the stream

Return type:
    

`dataiku.core.streaming_endpoint.StreamingEndpointStream`

get_native_kafka_topic(_broker_version ='1.0.0'_)
    

Get a pykafka topic for the Kafka topic of this streaming endpoint.

Parameters:
    

**broker_version** (_string_) – The protocol version of the cluster being connected to (see [pykafka doc](<https://pykafka.readthedocs.io/en/latest/index.html>))

Return type:
    

`pykafka.topic.Topic`

get_native_kafka_consumer(_broker_version ='1.0.0'_, _** kwargs_)
    

Get a pykafka consumer for the Kafka topic of this streaming endpoint.

See [pykafka doc](<https://pykafka.readthedocs.io/en/latest/index.html>) for the possible parameters.

Parameters:
    

**broker_version** (_string_) – The protocol version of the cluster being connected to

Return type:
    

`pykafka.simpleconsumer.SimpleConsumer`

get_native_kafka_producer(_broker_version ='1.0.0'_, _** kwargs_)
    

Get a pykafka producer for the Kafka topic of this streaming endpoint.

See [pykafka doc](<https://pykafka.readthedocs.io/en/latest/index.html>) for the possible parameters.

Parameters:
    

**broker_version** (_string_) – The protocol version of the cluster being connected to

Return type:
    

`pykafka.producer.Producer`

get_native_httpsse_consumer()
    

Get a SSEClient for the HTTP SSE url of this streaming endpoint.

Return type:
    

`sseclient.SSEClient`

get_native_sqs_consumer()
    

Get a generator of the messages in a SQS queue, backed by a boto3 client.

Each message is returned as-is, i.e. as a string

Return type:
    

generator[string]

_class _dataiku.core.streaming_endpoint.StreamingEndpointStream(_streaming_endpoint_ , _previous_state_ , _columns_)
    

Handle to read a streaming endpoint.

This class is a Python generator, returning a sequence of records, each one a dict. The fields in each record are named according to the columns in the schema of the streaming endpoint.

Note

Do not instantiate this class directly, use `dataiku.StreamingEndpoint.get_message_iterator()` instead

Usage example:
    
    
    # print stream to standard output
    endpoint = dataiku.StreamingEndpoint("my_endpoint_name")
    for message in e.get_message_iterator():
        print(message)
    

next()
    

Get next record in stream.

Returns:
    

a dict with fields according to the streaming endpoint schema

Return type:
    

dict

get_state()
    

Get the state of the stream.

Returns:
    

an endpoint-type specific string that can be passed as previous_state in `dataiku.StreamingEndpoint.get_message_iterator()`. For a Kafka endpoint, this would be a string representing the offsets of the consumer in the topic

Return type:
    

string

_class _dataiku.core.continuous_write.ContinuousWriterBase
    

Handle to write using the continuous write API to a dataset or streaming endpoint.

Note

Do not instantiate directly, use [`dataiku.Dataset.get_continuous_writer()`](<datasets.html#dataiku.Dataset.get_continuous_writer> "dataiku.Dataset.get_continuous_writer") or `dataiku.StreamingEndpoint.get_writer()` instead

Caution

You MUST close the handle after usage. Failure to do so will result in resource leaks.

write_tuple(_row_)
    

Write a single row from a tuple or list of column values.

Important

The schema of the dataset or streaming endpoint MUST be set before using this.

Note

Strings MUST be given as Unicode object. Giving str objects will fail.

Parameters:
    

**row** (_tuple_ _or_ _list_) – columns values, must be given in the order of the dataset schema.

write_row_array(_row_)
    

Write a single row from an array of column values.

Caution

Deprecated. Use `write_tuple()` instead

Parameters:
    

**row** (_tuple_ _or_ _list_) – columns values, must be given in the order of the dataset schema.

write_row_dict(_row_)
    

Write a single row from a dict of column name -> column value.

Some columns can be omitted, empty values will be inserted instead.

Important

The schema of the dataset or streaming endpoint MUST be set before using this.

Note

Strings MUST be given as Unicode object. Giving str objects will fail.

Parameters:
    

**row** (_dict_) – a dict of column name to column value (the method doesn’t take use kwargs)

write_dataframe(_df_)
    

Append a Pandas dataframe to the dataset being written.

This method can be called multiple times (especially when you have been using iter_dataframes to read from an input dataset)

Note

Strings MUST be given as Unicode object. Giving str objects will fail.

Parameters:
    

**df** (`pandas.core.frame.DataFrame`) – a Pandas dataframe

flush()
    

Send pending writes to the dataset or streaming endpoint.

checkpoint(_state_)
    

Checkpoint the dataset and set its current state.

Upon checkpointing, the dataset will attempt to flush writes atomically and to record the state. The state would then be accessible for reading later on, via `get_state()`.

Whether the flush happens atomically depends on the dataset type, and whether the state is effectively recorded is dependent on the dataset type and settings. At the moment, only file-based datasets are able to do full checkpoints (atomic flush, and state recorded).

Parameters:
    

**state** (_string_) – state associated to the checkpoint

get_state()
    

Retrieve the current state of the dataset being written to.

The state is what was passed as parameter to the last `checkpoint()` call on the dataset.

Return type:
    

string

close(_failed_)
    

Close this dataset or streaming endpoint writer.

Parameters:
    

**failed** (_boolean_) – if true, the last write chunk is not commited

_class _dataiku.core.continuous_write.StreamingEndpointContinuousWriter(_streaming_endpoint_)
    

Handle to write using the continuous write API to a streaming endpoint.

Note

Do not instantiate directly, use `dataiku.StreamingEndpoint.get_writer()` instead

send_init_request()
    

Internal.

get_schema()
    

Get the schema of the streaming endpoint being written to.

Returns:
    

an array of columns definition with their types and names. See [`dataiku.core.dataset.Schema`](<datasets.html#dataiku.core.dataset.Schema> "dataiku.core.dataset.Schema") for more information.

Return type:
    

[`dataiku.core.dataset.Schema`](<datasets.html#dataiku.core.dataset.Schema> "dataiku.core.dataset.Schema")

_class _dataikuapi.dss.streaming_endpoint.DSSStreamingEndpointListItem(_client_ , _data_)
    

An item in a list of streaming endpoints.

Important

Do not instantiate this class, use [`DSSProject.list_streaming_endpoints()`](<projects.html#dataikuapi.dss.project.DSSProject.list_streaming_endpoints> "dataikuapi.dss.project.DSSProject.list_streaming_endpoints") instead

to_streaming_endpoint()
    

Get a handle on the corresponding streaming endpoint.

Return type:
    

`DSSStreamingEndpoint`

_property _name
    

Get the streaming endpoint name.

Return type:
    

string

_property _id
    

Get the streaming endpoint identifier.

Note

For streaming endpoints, the identifier is equal to its name

Return type:
    

string

_property _type
    

Get the streaming endpoint type.

Returns:
    

the type is the same as the type of the connection that the streaming endpoint uses, ie Kafka, SQS, KDBPlus or httpsse

Return type:
    

string

_property _schema
    

Get the schema of the streaming endpoint.

Usage example:
    
    
    # list all endpoints containing columns with a 'PII' in comment
    for endpoint in p.list_streaming_endpoints():
        column_list = endpoint.schema['columns']
        pii_columns = [c for c in column_list if 'PII' in c.get("comment", "")]
        if len(pii_columns) > 0:
            print("Streaming endpoint %s contains %s PII columns" % (endpoint.id, len(pii_columns)))            
    

Returns:
    

a schema, as a dict with a columns array, in which each element is a column, itself as a dict of

  * **name** : the column name

  * **type** : the column type (smallint, int, bigint, float, double, boolean, date, string)

  * **length** : the string length

  * **comment** : user comment about the column




Return type:
    

dict

_property _connection
    

Get the connection on which this streaming endpoint is attached.

Returns:
    

a connection name, or None for HTTP SSE endpoints

Return type:
    

string

get_column(_column_)
    

Get a column in the schema, by its name.

Parameters:
    

**column** (_string_) – name of column to find

Returns:
    

a dict of the column settings or None if column does not exist. Fields are:

  * **name** : the column name

  * **type** : the column type (smallint, int, bigint, float, double, boolean, date, string)

  * **length** : the string length

  * **comment** : user comment about the column




Return type:
    

dict

_class _dataikuapi.dss.streaming_endpoint.DSSStreamingEndpoint(_client_ , _project_key_ , _streaming_endpoint_name_)
    

A streaming endpoint on the DSS instance.

_property _name
    

Get the streaming endpoint name.

Return type:
    

string

_property _id
    

Get the streaming endpoint identifier.

Note

For streaming endpoints, the identifier is equal to its name

Return type:
    

string

delete()
    

Delete the streaming endpoint from the flow, and objects using it (recipes or continuous recipes)

Attention

This call doesn’t delete the underlying streaming data. For example for a Kafka streaming endpoint the topic isn’t deleted

get_settings()
    

Get the settings of this streaming endpoint.

Know subclasses of `DSSStreamingEndpointSettings` include `KafkaStreamingEndpointSettings` and `HTTPSSEStreamingEndpointSettings`

You must use `save()` on the returned object to make your changes effective on the streaming endpoint.
    
    
    # Example: changing the topic on a kafka streaming endpoint
    streaming_endpoint = project.get_streaming_endpoint("my_endpoint")
    settings = streaming_endpoint.get_settings()
    settings.set_connection_and_topic(None, "country")
    settings.save()
    

Returns:
    

an object containing the settings

Return type:
    

`DSSStreamingEndpointSettings` or a subclass

exists()
    

Whether this streaming endpoint exists in DSS.

Return type:
    

boolean

get_schema()
    

Get the schema of the streaming endpoint.

Returns:
    

a schema, as a dict with a columns array, in which each element is a column, itself as a dict of

  * **name** : the column name

  * **type** : the column type (smallint, int, bigint, float, double, boolean, date, string)

  * **comment** : user comment about the column




Return type:
    

dict

set_schema(_schema_)
    

Set the schema of the streaming endpoint.

Usage example:
    
    
    # copy schema of the input of a continuous recipe to its output
    recipe = p.get_recipe('my_recipe_name')
    recipe_settings = recipe.get_settings()
    input_endpoint = p.get_streaming_endpoint(recipe_settings.get_flat_input_refs()[0])
    output_endpoint = p.get_streaming_endpoint(recipe_settings.get_flat_output_refs()[0])
    output_endpoint.set_schema(input_endpoint.get_schema())
    

Parameters:
    

**schema** (_dict_) – 

a schema, as a dict with a columns array, in which each element is a column, itself as a dict of

  * **name** : the column name

  * **type** : the column type (smallint, int, bigint, float, double, boolean, date, string)

  * **comment** : user comment about the column




get_zone()
    

Get the flow zone of this streaming endpoint.

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
    

Get the recipes referencing this streaming endpoint.

Usage example:
    
    
    for usage in streaming_endpoint.get_usages():
        if usage["type"] == 'RECIPE_INPUT':
            print("Used as input of %s" % usage["objectId"])
    

Returns:
    

a list of usages, each one a dict of:

  * **type** : the type of usage, either “RECIPE_INPUT” or “RECIPE_OUTPUT”

  * **objectId** : name of the recipe or continuous recipe

  * **objectProjectKey** : project of the recipe or continuous recipe




Return type:
    

list[dict]

get_object_discussions()
    

Get a handle to manage discussions on the streaming endpoint.

Returns:
    

the handle to manage discussions

Return type:
    

[`dataikuapi.dss.discussion.DSSObjectDiscussions`](<discussions.html#dataikuapi.dss.discussion.DSSObjectDiscussions> "dataikuapi.dss.discussion.DSSObjectDiscussions")

test_and_detect(_infer_storage_types =False_, _limit =10_, _timeout =60_)
    

Used internally by `autodetect_settings()`. It is not usually required to call this method

Attention

Only Kafka and HTTP-SSE streaming endpoints are handled

Note

Schema inferrence is done on the captured rows from the underlying stream. If no record is captured, for example because no message is posted to the stream while the capture is done, then no schema inferrence can take place.

Returns:
    

a future object on the result of the detection. The future’s result is a dict with fields:

  * **table** : the captured rows

  * **schemaDetection** : the result of the schema inference. Notable sub-fields are

    * **detectedSchema** : the inferred schema

    * **detectedButNotInSchema** : list of column names found in the capture, but not yet in the endpoint’s schema

    * **inSchemaButNotDetected** : list of column names present in the endpoint’s schema, but not found in the capture




Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

autodetect_settings(_infer_storage_types =False_, _limit =10_, _timeout =60_)
    

Detect an appropriate schema for this streaming endpoint using Dataiku detection engine.

The detection bases itself on a capture of the stream that this streaming endpoint represents. First a number of messages are captured from the stream, within the bounds passed as parameters, then a detection of the columns and their types is done on the captured messages. If no message is send on the stream during the capture, no column is inferred.

Attention

Only Kafka and HTTP-SSE streaming endpoints are handled

Note

Format-related settings are not automatically inferred. For example the method will not detect whether Kafka messages are JSON-encoded or Avro-encoded

Usage example:
    
    
    # create a kafka endpoint on a json stream and detect its schema
    e = project.create_kafka_streaming_endpoint('test_endpoint', 'kafka_connection', 'kafka-topic')
    s = e.autodetect_settings(infer_storage_types=True)
    s.save()
    

Parameters:
    

  * **infer_storage_types** (_boolean_) – if True, DSS will try to guess types of the columns. If False, all columns will be assumed to be strings (default: False)

  * **limit** (_int_) – max number of rows to use for the autodetection (default: 10)

  * **timeout** (_int_) – max duration in seconds of the stream capture to use for the autodetection (default: 60)



Returns:
    

streaming endpoint settings with an updated schema that you can `DSSStreamingEndpointSettings.save()`.

Return type:
    

`DSSStreamingEndpointSettings` or a subclass

get_as_core_streaming_endpoint()
    

Get the streaming endpoint as a handle for use inside DSS.

Returns:
    

the streaming endpoint

Return type:
    

`dataiku.StreamingEndpoint`

new_code_recipe(_type_ , _code =None_, _recipe_name =None_)
    

Start the creation of a new code recipe taking this streaming endpoint as input.

Usage example:
    
    
    # create a continuous python recipe from an endpoint
    recipe_creator = endpoint.new_code_recipe('cpython', 'some code here', 'compute_something')
    recipe_creator.with_new_output_streaming_endpoint('something', 'my_kafka_connection', 'avro')
    recipe = recipe_creator.create()
    

Parameters:
    

  * **type** (_string_) – type of the recipe. Can be ‘cpython’ or ‘streaming_spark_scala’; the non-continuous type ‘python’ is also possible

  * **code** (_string_) – (optional) The script of the recipe

  * **recipe_name** (_string_) – (optional) base name for the new recipe.



Returns:
    

an object to create a new recipe

Return type:
    

[`dataikuapi.dss.recipe.CodeRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.CodeRecipeCreator> "dataikuapi.dss.recipe.CodeRecipeCreator")

new_recipe(_type_ , _recipe_name =None_)
    

Start the creation of a new recipe taking this streaming endpoint as input.

This method can create non-code recipes like Sync or continuous Sync recipes. For more details, please see [`dataikuapi.dss.project.DSSProject.new_recipe()`](<projects.html#dataikuapi.dss.project.DSSProject.new_recipe> "dataikuapi.dss.project.DSSProject.new_recipe").

Usage example:
    
    
    # create a continuous sync from an endpoint to a dataset
    recipe_creator = endpoint.new_recipe('csync', 'compute_my_dataset_name')
    recipe_creator.with_new_output('my_dataset_name', 'filesystem_managed')
    recipe = recipe_creator.create()
    

Parameters:
    

  * **type** (_string_) – type of the recipe. Possible values are ‘csync’, ‘cpython’, ‘python’, ‘streaming_spark_scala’

  * **recipe_name** (_string_) – (optional) base name for the new recipe.



Returns:
    

A new DSS Recipe Creator handle

Return type:
    

[`dataikuapi.dss.recipe.DSSRecipeCreator`](<recipes.html#dataikuapi.dss.recipe.DSSRecipeCreator> "dataikuapi.dss.recipe.DSSRecipeCreator") or a subclass

_class _dataikuapi.dss.streaming_endpoint.DSSStreamingEndpointSettings(_streaming_endpoint_ , _settings_)
    

Base settings class for a DSS streaming endpoint.

Important

Do not instantiate this class directly, use `DSSStreamingEndpoint.get_settings()`

Use `save()` to save your changes

get_raw()
    

Get the streaming endpoint settings.

Returns:
    

the settings, as a dict. The type-specific parameters, that depend on the connection type, are a **params** sub-dict.

Return type:
    

dict

get_raw_params()
    

Get the type-specific (Kafka/ HTTP-SSE/ Kdb+…) params as a dict.

Returns:
    

the type-specific params. Each type defines a set of fields; commonly found fields are :

  * **connection** : name of the connection used by the streaming endpoint

  * **topic** or **queueName** : name of the Kafka topic or SQS queue corresponding to this streaming endpoint




Return type:
    

dict

_property _type
    

Get the type of streaming system that the streaming endpoint uses.

Returns:
    

a type of streaming system. Possible values: ‘kafka’, ‘SQS’, ‘kdbplustick’, ‘httpsse’

Return type:
    

string

add_raw_schema_column(_column_)
    

Add a column in the schema

Parameters:
    

**column** (_dict_) – a dict defining the column. It should contain a “name” field and a “type” field (with a DSS type, like bigint, double, string, date, boolean, …), optionally a “length” field for string-typed columns and a “comment” field.

save()
    

Save the changes to the settings on the streaming endpoint.

_class _dataikuapi.dss.streaming_endpoint.KafkaStreamingEndpointSettings(_streaming_endpoint_ , _settings_)
    

Settings for a Kafka streaming endpoint.

This class inherits from `DSSStreamingEndpointSettings`.

Important

Do not instantiate this class directly, use `DSSStreamingEndpoint.get_settings()`

Use `save()` to save your changes

set_connection_and_topic(_connection =None_, _topic =None_)
    

Change the connection and topic of an endpoint.

Parameters:
    

  * **connection** (_string_) – (optional) name of a Kafka connection in DSS

  * **topic** (_string_) – (optional) name of a Kafka topic. Can contain DSS variables




_class _dataikuapi.dss.streaming_endpoint.HTTPSSEStreamingEndpointSettings(_streaming_endpoint_ , _settings_)
    

Settings for a HTTP-SSE streaming endpoint.

This class inherits from `DSSStreamingEndpointSettings`.

Important

Do not instantiate this class directly, use `DSSStreamingEndpoint.get_settings()`

Use `save()` to save your changes

set_url(_url_)
    

Change the URL of the endpoint.

Parameters:
    

**url** (_string_) – url to connect to

_class _dataikuapi.dss.streaming_endpoint.DSSManagedStreamingEndpointCreationHelper(_project_ , _streaming_endpoint_name_ , _streaming_endpoint_type_)
    

Utility class to help create a new streaming endpoint.

Note

Do not instantiate directly, use [`DSSProject.new_managed_streaming_endpoint()`](<projects.html#dataikuapi.dss.project.DSSProject.new_managed_streaming_endpoint> "dataikuapi.dss.project.DSSProject.new_managed_streaming_endpoint") instead

Important

Only Kafka and SQS endpoints support managed streaming endpoints

get_creation_settings()
    

Get the settings for the creation of the new managed streaming endpoint.

Note

Modifying the values in the creation settings directly is discouraged, use `with_store_into()` instead.

Returns:
    

the settings as a dict

Return type:
    

dict

with_store_into(_connection_ , _format_option_id =None_)
    

Set the DSS connection underlying the new streaming endpoint.

Parameters:
    

  * **connection** (_string_) – name of the connection to store into

  * **format_option_id** (_string_) – 

(optional) identifier of a serialization format option. For Kafka endpoints, possible values are :

>     * **json** : messages are JSON strings
> 
>     * **single** : messages are handled as a single typed field
> 
>     * **avro** : messages are Kafka-Avro messages (ie an avro message padded with a field indicating the avro schema version in the kafka schema registry)

For SQS endpoints, possible values are

>     * **json** : messages are JSON strings
> 
>     * **string** : messages are raw strings



Returns:
    

self

create(_overwrite =False_)
    

Execute the creation of the streaming endpoint according to the selected options

Parameters:
    

**overwrite** (_boolean_) – If the streaming endpoint being created already exists, delete it first

Returns:
    

an object corresponding to the newly created streaming endpoint

Return type:
    

`DSSStreamingEndpoint`

already_exists()
    

Whether the desired name for the new streaming endpoint is already used by another streaming endpoint

Return type:
    

boolean

_class _dataikuapi.dss.continuousactivity.DSSContinuousActivity(_client_ , _project_key_ , _recipe_id_)
    

A handle to interact with the execution of a continuous recipe on the DSS instance.

Important

Do not create this class directly, instead use [`dataikuapi.dss.project.DSSProject.get_continuous_activity()`](<projects.html#dataikuapi.dss.project.DSSProject.get_continuous_activity> "dataikuapi.dss.project.DSSProject.get_continuous_activity")

start(_loop_params ={}_)
    

Start the continuous activity

Parameters:
    

**loop_params** (_dict_) – 

controls how the recipe is restarted after a failure, and the delay before the restarting. Default is to restart indefinitely without delay. Fields are:

>   * **abortAfterCrashes** : when reaching this number of failures, the recipe isn’t restarted anymore. Use -1 as ‘no limit on number of failures’
> 
>   * **initialRestartDelayMS** : initial delay to wait before restarting after a failure
> 
>   * **restartDelayIncMS** : increase to the delay before restarting upon subsequent failures
> 
>   * **maxRestartDelayMS** : max delay before restarting after failure
> 
> 


stop()
    

Stop the continuous activity.

get_status()
    

Get the current status of the continuous activity.

Usage example:
    
    
    # stop a continuous activity via its future
    from dataikuapi.dss.future import DSSFuture
    activity = project.get_continuous_activity("my_continuous_recipe")
    status = activity.get_status()
    future = DSSFuture(a.client, status["mainLoopState"]['futureId'], status["mainLoopState"]['futureInfo'])  
    future.abort()          
    
    # this is equivalent to simply stop()
    activity.stop()
    

Returns:
    

the state of the continuous activity. The state as requested by the use is stored in a **desiredState** field (values: ‘STARTED’ or ‘STOPPED’), and the current effective state in a **mainLoopState** sub-dict.

Return type:
    

dict

get_recipe()
    

Get a handle on the associated recipe.

Return type:
    

[`dataikuapi.dss.recipe.DSSRecipe`](<recipes.html#dataikuapi.dss.recipe.DSSRecipe> "dataikuapi.dss.recipe.DSSRecipe")

---

## [api-reference/python/tables-import]

# Importing tables as datasets

For usage information and examples, see [Importing tables as datasets](<../../concepts-and-examples/tables-import.html>)

_class _dataikuapi.dss.project.TablesImportDefinition(_client_ , _project_key_)
    

Temporary structure holding the list of tables to import

add_hive_table(_hive_database_ , _hive_table_)
    

Add a Hive table to the list of tables to import

Parameters:
    

  * **hive_database** (_str_) – the name of the Hive database

  * **hive_table** (_str_) – the name of the Hive table




add_sql_table(_connection_ , _schema_ , _table_ , _catalog =None_)
    

Add a SQL table to the list of tables to import

Parameters:
    

  * **connection** (_str_) – the name of the SQL connection

  * **schema** (_str_) – the schema of the table

  * **table** (_str_) – the name of the SQL table

  * **catalog** (_str_) – the database of the SQL table. Leave to None to use the default database associated with the connection




add_iceberg_table(_connection_ , _namespace_ , _table_)
    

Add a Iceberg table to the list of tables to import

Parameters:
    

  * **connection** (_str_) – the name of the Iceberg connection

  * **namespace** (_str_) – the namespace of the table

  * **table** (_str_) – the name of the table




add_elasticsearch_index_or_alias(_connection_ , _index_or_alias_)
    

Add an Elastic Search index or alias to the list of tables to import

prepare()
    

Run the first step of the import process. In this step, DSS will check the tables whose import you have requested and prepare dataset names and target connections

Returns:
    

an object that allows you to finalize the import process

Return type:
    

`TablesPreparedImport`

_class _dataikuapi.dss.project.TablesPreparedImport(_client_ , _project_key_ , _candidates_)
    

Result of preparing a tables import. Import can now be finished

execute()
    

Starts executing the import in background and returns a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") to wait on the result

Returns:
    

a future to wait on the result

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

---

## [api-reference/python/unified-monitoring]

# Unified Monitoring

_class _dataikuapi.dss.unifiedmonitoring.DSSUnifiedMonitoring(_client_)
    

Handle to interact with Unified Monitoring

Warning

Do not create this class directly, use `dataikuapi.dssclient.DSSClient.get_unified_monitoring()`

list_monitored_project_deployments()
    

Lists the monitored project deployments

Returns:
    

The list of monitored projects

Return type:
    

list of `dataikuapi.dss.unifiedmonitoring.MonitoredProjectDeployment`

list_monitored_api_endpoints(_remove_duplicated_external_endpoints =True_)
    

Lists the monitored API endpoints

Parameters:
    

**remove_duplicated_external_endpoints** (_boolean_) – if True, an endpoint that is both in a Deploy Anywhere Infrastructure and in an External endpoint scope will be listed only once, under the Deploy Anywhere Infrastructure. Optional

Returns:
    

The list of monitored API endpoints

Return type:
    

list of Union[`dataikuapi.dss.unifiedmonitoring.MonitoredManagedApiEndpoint`, `dataikuapi.dss.unifiedmonitoring.MonitoredExternalApiEndpoint`]

list_monitored_api_endpoint_with_activity_metrics(_endpoints_to_filter_on =None_, _remove_duplicated_external_endpoints =True_)
    

Lists the monitored API endpoints with their activity metrics

Parameters:
    

  * **endpoints_to_filter_on** (list of Union[`dataikuapi.dss.unifiedmonitoring.DSSApiEndpointMonitoring`, `dataikuapi.dss.unifiedmonitoring.ExternalApiEndpointMonitoring`]. Optional) – endpoints for which monitoring and activity metrics should be retrieved. If None or empty, all endpoints are considered

  * **remove_duplicated_external_endpoints** (_boolean_) – if True, an endpoint that is both in a Deploy Anywhere Infrastructure and in an External Endpoint Scope will be listed only once, under the Deploy Anywhere Infrastructure. Optional



Returns:
    

The list of API endpoint monitorings with their activity metrics

Return type:
    

list of Union[`dataikuapi.dss.unifiedmonitoring.DSSApiEndpointMonitoringWithActivityMetrics`, `dataikuapi.dss.unifiedmonitoring.ExternalApiEndpointMonitoringWithActivityMetrics`]

## Project Monitoring

_class _dataikuapi.dss.unifiedmonitoring.MonitoredProjectDeployment(_data_)
    

A handle on a monitored project deployment

Warning

Do not create this class directly, instead use `dataikuapi.dss.unifiedmonitoring.DSSUnifiedMonitoring.list_monitored_project_deployments()`

deployment_id
    

The deployment id

infrastructure_id
    

The infrastructure id

stage
    

The stage of the deployment

snapshot_timestamp
    

The timestamp of the snapshot

bundle_name
    

The bundle name

deployed_project_key
    

The deployed project key

published_project_key
    

The published project key

get_raw()
    

Get the raw monitored project

Return type:
    

dict

## API Endpoint Monitoring

_class _dataikuapi.dss.unifiedmonitoring.MonitoredManagedApiEndpoint(_client_ , _data_)
    

A handle on a monitored managed API endpoint

Warning

Do not create this class directly, instead use `dataikuapi.dss.unifiedmonitoring.DSSUnifiedMonitoring.list_monitored_api_endpoints()`

deployment_id
    

The deployment id

infrastructure_id
    

The infrastructure id

stage
    

The stage of the deployment

snapshot_timestamp
    

The timestamp of the snapshot

endpoint_id
    

The endpoint id

type
    

‘MANAGED_API_ENDPOINT’

get_activity_metrics()
    

Get the activity metrics of the monitored managed API endpoint

Returns:
    

The activity metrics

Return type:
    

`dataikuapi.dss.unifiedmonitoring.ManagedApiEndpointActivityMetrics`

get_raw()
    

Get the raw monitored managed API endpoint

Return type:
    

dict

_class _dataikuapi.dss.unifiedmonitoring.MonitoredExternalApiEndpoint(_client_ , _data_)
    

A handle on a monitored external API endpoint

Warning

Do not create this class directly, instead use `dataikuapi.dss.unifiedmonitoring.DSSUnifiedMonitoring.list_monitored_api_endpoints()`

external_endpoints_scope
    

The external endpoint scope configuration

stage
    

The stage of the deployment

snapshot_timestamp
    

The timestamp of the snapshot

endpoint_name
    

The endpoint name

type
    

‘EXTERNAL_API_ENDPOINT’

get_activity_metrics()
    

Get the activity metrics of the monitored external API endpoint

Returns:
    

The activity metrics

Return type:
    

`dataikuapi.dss.unifiedmonitoring.ExternalApiEndpointActivityMetrics`

get_raw()
    

Get the raw monitored external API endpoint

Return type:
    

dict

_class _dataikuapi.dss.unifiedmonitoring.ManagedApiEndpointActivityMetrics(_data_)
    

A handle on the activity metrics of a managed API endpoint

Warning

Do not create this class directly, instead use `dataikuapi.dss.unifiedmonitoring.DSSUnifiedMonitoring.list_monitored_api_endpoint_with_activity_metrics()`

deployment_id
    

The deployment id

endpoint_id
    

The endpoint id

period
    

The time period spanned by this `DSSApiEndpointActivityMetrics`

period_all_requests_count
    

The count of all requests in the period

period_error_rate
    

The request error rate in the period

period_response_time_ms
    

The average response time in the period

counts
    

Detailed number of requests per timestamp

get_raw()
    

Get the raw activity metrics of a managed API endpoint

Return type:
    

dict

_class _dataikuapi.dss.unifiedmonitoring.ExternalApiEndpointActivityMetrics(_data_)
    

A handle on the activity metrics of an external API endpoint

Warning

Do not create this class directly, instead use `dataikuapi.dss.unifiedmonitoring.DSSUnifiedMonitoring.list_monitored_api_endpoint_with_activity_metrics()`

external_endpoints_scope_name
    

The name of the external endpoint scope

endpoint_name
    

The endpoint name

period
    

The time period spanned by this `ExternalApiEndpointActivityMetrics`

period_all_requests_count
    

The count of all requests in the period

period_error_rate
    

The request error rate in the period

period_response_time_ms
    

The average response time in the period

counts
    

Detailed number of requests per timestamp

get_raw()
    

Get the raw activity metrics of an external API endpoint

Return type:
    

dict

_class _dataikuapi.dss.unifiedmonitoring.MonitoredManagedApiEndpointWithActivityMetrics(_client_ , _data_)
    

A handle on a monitored managed API endpoint and its activity metrics

Warning

Do not create this class directly, instead use `dataikuapi.dss.unifiedmonitoring.DSSUnifiedMonitoring.list_monitored_api_endpoint_with_activity_metrics()`

endpoint_monitoring
    

The DSS API endpoint monitoring

activity_metrics
    

The DSS API endpoint activity metrics

type
    

‘MANAGED_API_ENDPOINT’

get_raw()
    

Get the raw monitored managed API endpoint with its activity metrics

Return type:
    

dict

_class _dataikuapi.dss.unifiedmonitoring.MonitoredExternalApiEndpointWithActivityMetrics(_client_ , _data_)
    

A handle on a monitored external API endpoint and its activity metrics

Warning

Do not create this class directly, instead use `dataikuapi.dss.unifiedmonitoring.DSSUnifiedMonitoring.list_monitored_api_endpoint_with_activity_metrics()`

endpoint_monitoring
    

The external API endpoint monitoring

activity_metrics
    

The external API endpoint activity metrics

type
    

‘EXTERNAL_API_ENDPOINT’

get_raw()
    

Get the raw monitored external API endpoint with its activity metrics

Return type:
    

dict

---

## [api-reference/python/users-groups]

# Users and groups

For usage information and examples, see [Users and groups](<../../concepts-and-examples/users-groups.html>)

_class _dataikuapi.dss.admin.DSSUser(_client_ , _login_)
    

A handle for a user on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_user()`](<client.html#dataikuapi.DSSClient.get_user> "dataikuapi.DSSClient.get_user") instead.

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
    

`DSSUserSettings`

get_activity()
    

Gets the activity of the user. You must be admin to call this method.

Returns:
    

the user’s activity

Return type:
    

`DSSUserActivity`

get_info()
    

Gets basic information about the user. You do not need to be admin to call this method

Return type:
    

`DSSUserInfo`

start_resync_from_supplier()
    

Starts a resync of the user from an external supplier (LDAP, Azure AD or custom auth)

Returns:
    

a [`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture") representing the sync process

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

get_definition()
    

Get the definition of the user

Caution

Deprecated, use `get_settings()` instead

Returns:
    

the user’s definition, as a dict. Notable fields are

  * **login** : identifier of the user, can’t be modified

  * **enabled** : whether the user can log into DSS

  * **groups** : list of group names this user belongs to




Return type:
    

dict

set_definition(_definition_)
    

Set the user’s definition.

Caution

Deprecated, use `dataikuapi.dss.admin.DSSUserSettings.save()` instead

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
>   * secrets
> 
>   * credentials
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
    

[`dataikuapi.DSSClient`](<client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")

_class _dataikuapi.dss.admin.DSSUserSettings(_client_ , _login_ , _settings_)
    

Settings for a DSS user.

Important

Do not instantiate directly, use `DSSUser.get_settings()` instead.

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

_property _preferences
    

Get the preferences for this user

Returns:
    

user preferences

Return type:
    

`DSSUserPreferences`

save()
    

Saves the settings

Note: this call is not available to Dataiku Cloud users

add_secret(_name_ , _value_)
    

Add a user secret.

If there was already a secret with the same name, it is replaced

Parameters:
    

  * **name** (_string_) – name of the secret

  * **value** (_string_) – name of the value




get_raw()
    

Get the raw settings of the user.

Modifications made to the returned object are reflected when saving.

Returns:
    

the dict of the settings (not a copy). Notable fields are:

  * **login** : identifier of the user, can’t be modified

  * **enabled** : whether the user can log into DSS

  * **groups** : list of group names this user belongs to

  * **trialStatus** : The trial status of the user, with the following keys:
    
    * exists: True if this user is or was on trial

    * expired: True if the trial period has expired

    * valid: True if the trial is valid (for ex, has not expired and the license allows it)

    * expiresOn: Date (ms since epoch) when the trial will expire

    * grantedOn: Date (ms since epoch) when the trial was granted




Return type:
    

dict

remove_connection_credential(_connection_)
    

Remove per-user-credentials for a connection

If no credentials for the givent connection exists, this method does nothing

Parameters:
    

**connection** (_string_) – name of the connection

remove_plugin_credential(_plugin_id_ , _param_set_id_ , _preset_id_ , _param_name_)
    

Remove per-user-credentials for a plugin preset

Parameters:
    

  * **plugin_id** (_string_) – identifier of the plugin

  * **param_set_id** (_string_) – identifier of the parameter set to which the preset belongs

  * **preset_id** (_string_) – identifier of the preset

  * **param_name** (_string_) – name of the credentials parameter in the preset




remove_secret(_name_)
    

Remove a user secret based on its name

If no secret of the given name exists, the method does nothing.

Parameters:
    

**name** (_string_) – name of the secret

set_basic_connection_credential(_connection_ , _login_ , _password_)
    

Set per-user-credentials for a connection that takes a user/password pair.

Parameters:
    

  * **connection** (_string_) – name of the connection

  * **login** (_string_) – login of the credentials

  * **password** (_string_) – password of the credentials




set_basic_plugin_credential(_plugin_id_ , _param_set_id_ , _preset_id_ , _param_name_ , _login_ , _password_)
    

Set per-user-credentials for a plugin preset that takes a user/password pair

Parameters:
    

  * **plugin_id** (_string_) – identifier of the plugin

  * **param_set_id** (_string_) – identifier of the parameter set to which the preset belongs

  * **preset_id** (_string_) – identifier of the preset

  * **param_name** (_string_) – name of the credentials parameter in the preset

  * **login** (_string_) – login of the credentials

  * **password** (_string_) – password of the credentials




set_oauth2_plugin_credential(_plugin_id_ , _param_set_id_ , _preset_id_ , _param_name_ , _refresh_token_)
    

Set per-user-credentials for a plugin preset that takes a OAuth refresh token

Parameters:
    

  * **plugin_id** (_string_) – identifier of the plugin

  * **param_set_id** (_string_) – identifier of the parameter set to which the preset belongs

  * **preset_id** (_string_) – identifier of the preset

  * **param_name** (_string_) – name of the credentials parameter in the preset

  * **refresh_token** (_string_) – value of the refresh token




_property _user_properties
    

Get the user properties for this user.

Important

Do not set this property, modify the dict in place

User properties can be seen and modified by the user themselves. A contrario admin properties are for administrators’ eyes only.

Return type:
    

dict

_class _dataikuapi.dss.admin.DSSUserPreferences(_preferences_)
    

Preferences for a DSS user.

Important

Do not instantiate directly, use `DSSUserSettings.preferences()` instead.

_property _ui_language
    

Get or set the language used in the Web User Interface for this user. Valid values are “en” (English), “ja” (Japanese) and “fr” (French).

Return type:
    

str

_property _mention_emails
    

Get or set whether the user receives email notifications when mentioned in discussions or commit messages

Return type:
    

bool

_property _discussion_emails
    

Get or set whether the user receives email notifications when a user writes in a discussion thread from any item they are watching

Return type:
    

bool

_property _access_request_emails
    

Get or set whether the user receives email notifications when a user requests access to one of their projects or to use an object from one of their projects

Return type:
    

bool

_property _granted_access_emails
    

Get or set whether the user receives email notifications when they are granted access to a project, or when their access or sharing requests are approved

Return type:
    

bool

_property _granted_plugin_request_emails
    

Get or set whether the user receives email notifications when their plugin requests are approved

Return type:
    

bool

_property _plugin_request_emails
    

Get or set whether the user receives email notifications when users request to install a plugin

Return type:
    

bool

_property _instance_access_requests_emails
    

Get or set whether the user receives email notifications when users request access to the instance

Return type:
    

bool

_property _profile_upgrade_requests_emails
    

Get or set whether the user receives email notifications when users request to upgrade their profile

Return type:
    

bool

_property _code_env_creation_request_emails
    

Get or set whether the user receives email notifications when a user requests a code env creation

Return type:
    

bool

_property _granted_code_env_creation_request_emails
    

Get or set whether the user receives email notifications when their code env creation request is granted

Return type:
    

bool

_property _daily_digests_emails
    

Get or set whether the user receives daily emails to sum-up the day activity regardless of whether they logged-in.

Return type:
    

bool

_property _offline_activity_emails
    

Get or set whether the user receives emails periodically that notify them about activity happening while they are offline

Return type:
    

bool

_property _remember_position_flow
    

Get or set whether for the user the flow remembers zoom settings and re-selects the last item viewed

Return type:
    

bool

_property _login_logout_notifications
    

Get or set whether the user receives notifications when other users log in/out

Return type:
    

bool

_property _watched_objects_editions_notifications
    

Get or set whether the user receives notifications when objects they are watching are edited

Return type:
    

bool

_property _object_on_current_project_created_deleted_notifications
    

Get or set whether the user receives notifications when an object is created/deleted on the project they are browsing

Return type:
    

bool

_property _any_object_on_current_project_edited_notifications
    

Get or set whether the user receives notifications when any object is edited on the project they are browsing

Return type:
    

bool

_property _watch_star_on_current_project_notifications
    

Get or set whether the user receives notifications when an object is starred on the project they are browsing

Return type:
    

bool

_property _other_users_jobs_tasks_notifications
    

Get or set whether the user receives notifications when other users run jobs/scenarios/ML tasks

Return type:
    

bool

_property _request_access_notifications
    

Get or set whether the user receives notifications when they receive an access or sharing request, or one of their requests is approved

Return type:
    

bool

_property _scenario_run_notifications
    

Get or set whether the user receives notifications when scenarios are run under their account

Return type:
    

bool

_class _dataikuapi.dss.admin.DSSOwnUser(_client_)
    

A handle to interact with your own user

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_own_user()`](<client.html#dataikuapi.DSSClient.get_own_user> "dataikuapi.DSSClient.get_own_user") instead.

get_settings()
    

Get your own settings

You must use `save()` on the returned object to make your changes effective on the user.

Return type:
    

`DSSOwnUserSettings`

_class _dataikuapi.dss.admin.DSSOwnUserSettings(_client_ , _settings_)
    

Settings for the current DSS user.

Important

Do not instantiate directly, use `DSSOwnUser.get_settings()` instead.

save()
    

Saves the settings

add_secret(_name_ , _value_)
    

Add a user secret.

If there was already a secret with the same name, it is replaced

Parameters:
    

  * **name** (_string_) – name of the secret

  * **value** (_string_) – name of the value




get_raw()
    

Get the raw settings of the user.

Modifications made to the returned object are reflected when saving.

Returns:
    

the dict of the settings (not a copy). Notable fields are:

  * **login** : identifier of the user, can’t be modified

  * **enabled** : whether the user can log into DSS

  * **groups** : list of group names this user belongs to

  * **trialStatus** : The trial status of the user, with the following keys:
    
    * exists: True if this user is or was on trial

    * expired: True if the trial period has expired

    * valid: True if the trial is valid (for ex, has not expired and the license allows it)

    * expiresOn: Date (ms since epoch) when the trial will expire

    * grantedOn: Date (ms since epoch) when the trial was granted




Return type:
    

dict

remove_connection_credential(_connection_)
    

Remove per-user-credentials for a connection

If no credentials for the givent connection exists, this method does nothing

Parameters:
    

**connection** (_string_) – name of the connection

remove_plugin_credential(_plugin_id_ , _param_set_id_ , _preset_id_ , _param_name_)
    

Remove per-user-credentials for a plugin preset

Parameters:
    

  * **plugin_id** (_string_) – identifier of the plugin

  * **param_set_id** (_string_) – identifier of the parameter set to which the preset belongs

  * **preset_id** (_string_) – identifier of the preset

  * **param_name** (_string_) – name of the credentials parameter in the preset




remove_secret(_name_)
    

Remove a user secret based on its name

If no secret of the given name exists, the method does nothing.

Parameters:
    

**name** (_string_) – name of the secret

set_basic_connection_credential(_connection_ , _login_ , _password_)
    

Set per-user-credentials for a connection that takes a user/password pair.

Parameters:
    

  * **connection** (_string_) – name of the connection

  * **login** (_string_) – login of the credentials

  * **password** (_string_) – password of the credentials




set_basic_plugin_credential(_plugin_id_ , _param_set_id_ , _preset_id_ , _param_name_ , _login_ , _password_)
    

Set per-user-credentials for a plugin preset that takes a user/password pair

Parameters:
    

  * **plugin_id** (_string_) – identifier of the plugin

  * **param_set_id** (_string_) – identifier of the parameter set to which the preset belongs

  * **preset_id** (_string_) – identifier of the preset

  * **param_name** (_string_) – name of the credentials parameter in the preset

  * **login** (_string_) – login of the credentials

  * **password** (_string_) – password of the credentials




set_oauth2_plugin_credential(_plugin_id_ , _param_set_id_ , _preset_id_ , _param_name_ , _refresh_token_)
    

Set per-user-credentials for a plugin preset that takes a OAuth refresh token

Parameters:
    

  * **plugin_id** (_string_) – identifier of the plugin

  * **param_set_id** (_string_) – identifier of the parameter set to which the preset belongs

  * **preset_id** (_string_) – identifier of the preset

  * **param_name** (_string_) – name of the credentials parameter in the preset

  * **refresh_token** (_string_) – value of the refresh token




_property _user_properties
    

Get the user properties for this user.

Important

Do not set this property, modify the dict in place

User properties can be seen and modified by the user themselves. A contrario admin properties are for administrators’ eyes only.

Return type:
    

dict

_class _dataikuapi.dss.admin.DSSUserActivity(_client_ , _login_ , _activity_)
    

Activity for a DSS user.

Important

Do not instantiate directly, use `DSSUser.get_activity()` or [`dataikuapi.DSSClient.list_users_activity()`](<client.html#dataikuapi.DSSClient.list_users_activity> "dataikuapi.DSSClient.list_users_activity") instead.

get_raw()
    

Get the raw activity of the user as a dict.

Returns:
    

the raw activity. Fields are

  * **login** : the login of the user for this activity

  * **lastSuccessfulLogin** : timestamp in milliseconds of the last time the user logged into DSS

  * **lastFailedLogin** : timestamp in milliseconds of the last time DSS recorded a login failure for this user

  * **lastSessionActivity** : timestamp in milliseconds of the last time the user opened a tab




Return type:
    

dict

_property _last_successful_login
    

Get the last successful login of the user

Returns None if there was no successful login for this user.

Returns:
    

the last successful login

Return type:
    

`datetime.datetime` or None

_property _last_failed_login
    

Get the last failed login of the user

Returns None if there were no failed login for this user.

Returns:
    

the last failed login

Return type:
    

`datetime.datetime` or None

_property _last_session_activity
    

Get the last session activity of the user

The last session activity is the last time the user opened a new DSS tab or refreshed his session.

Returns None if there is no session activity yet.

Returns:
    

the last session activity

Return type:
    

`datetime.datetime` or None

_class _dataikuapi.dss.admin.DSSGroup(_client_ , _name_)
    

A group on the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_group()`](<client.html#dataikuapi.DSSClient.get_group> "dataikuapi.DSSClient.get_group") instead.

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

_class _dataikuapi.dss.admin.DSSAuthorizationMatrix(_authorization_matrix_)
    

The authorization matrix of all groups and enabled users of the DSS instance.

Important

Do not instantiate directly, use [`dataikuapi.DSSClient.get_authorization_matrix()`](<client.html#dataikuapi.DSSClient.get_authorization_matrix> "dataikuapi.DSSClient.get_authorization_matrix") instead.

_property _raw
    

Get the raw authorization matrix as a dict

Returns:
    

the authorization matrix. There are 2 parts in the matrix, each as a top-level field and with similar structures, **perUser** and **perGroup**.

Return type:
    

dict

---

## [api-reference/python/utils]

# Utilities

These classes are various utilities that are used in various parts of the API.

_class _dataikuapi.dss.utils.DSSDatasetSelectionBuilder
    

Builder for a “dataset selection”. In DSS, a dataset selection is used to select a part of a dataset for processing.

Depending on the location where it is used, a selection can include: * Sampling * Filtering by partitions (for partitioned datasets) * Filtering by an expression * Selection of columns * Ordering

Please see the sampling documentation of DSS for a detailed explanation of the sampling methods.

build()
    

Returns:
    

the built selection dict

Return type:
    

dict

with_head_sampling(_limit_)
    

Sets the sampling to ‘first records’ mode

Parameters:
    

**limit** (_int_) – Maximum number of rows in the sample

with_all_data_sampling()
    

Sets the sampling to ‘no sampling, all data’ mode

with_random_fixed_nb_sampling(_nb_)
    

Sets the sampling to ‘Random sampling, fixed number of records’ mode

Parameters:
    

**nb** (_int_) – Maximum number of rows in the sample

with_selected_partitions(_ids_)
    

Sets partition filtering on the given partition identifiers.

Warning

The dataset to select must be partitioned.

Parameters:
    

**ids** (_list_) – list of selected partitions

_class _dataikuapi.dss.utils.DSSFilterBuilder
    

Builder for a “filter”. In DSS, a filter is used to define a subset of rows for processing.

build()
    

Returns:
    

the built filter

Return type:
    

dict

with_distinct()
    

Sets the filter to deduplicate

with_formula(_expression_)
    

Sets the formula (DSS formula) used to filter rows

Parameters:
    

**expression** (_str_) – the DSS formula

_class _dataikuapi.dss.utils.DSSInfoMessages(_data_)
    

Contains a list of `dataikuapi.dss.utils.DSSInfoMessage`.

Important

Do not instantiate this class.

_property _messages
    

The messages as a list of `dataikuapi.dss.utils.DSSInfoMessage`

_property _has_messages
    

True if there is any message

_property _has_error
    

True if there is any error message

_property _max_severity
    

The max severity of the messages

_property _has_success
    

True if there is any success message

_property _has_warning
    

True if there is any warning message

_class _dataikuapi.dss.utils.DSSInfoMessage(_data_)
    

A message with a code, a title, a severity and a content.

Important

Do not instantiate this class.

_property _severity
    

The severity of the message

_property _code
    

The code of the message

_property _details
    

The details of the message

_property _title
    

The title of the message

_property _message
    

The full message

_class _dataikuapi.dss.utils.DSSSimpleFilter(_operator_ , _column =None_, _value =None_, _clauses =None_)
    

A simplified representation of a DSS filter. It can be built from scratch or from an existing [`DSSFilter`](<recipes.html#dataikuapi.dss.utils.DSSFilter> "dataikuapi.dss.utils.DSSFilter").

A simple filter is a dictionary with the following keys:

  * operator: one of the values of `DSSSimpleFilterOperator`

  * column: the column to apply the filter on (for unary and binary operators)

  * value: the value to compare with (for binary operators)

  * clauses: a list of other simple filters (for AND/OR operators)




to_dss_filter()
    

Converts the simple filter to a DSS filter dictionary.

Returns:
    

A DSS filter dictionary that can be used in visual recipes.

Return type:
    

dict

_static _from_dss_filter(_dss_filter_)
    

Converts a DSS filter dictionary to a simple filter.

Parameters:
    

**dss_filter** (_dict_) – A DSS filter dictionary.

Returns:
    

A simple filter object.

Return type:
    

DSSSimpleFilter

to_dict()
    

Converts the simple filter to a serializable dictionary.

Returns:
    

A dictionary representation of the simple filter.

Return type:
    

dict

_static _and_(_clauses_)
    

_static _or_(_clauses_)
    

_static _eq(_column_ , _value_)
    

_static _neq(_column_ , _value_)
    

_static _gt(_column_ , _value_)
    

_static _gte(_column_ , _value_)
    

_static _lt(_column_ , _value_)
    

_static _lte(_column_ , _value_)
    

_static _empty(_column_)
    

_static _not_empty(_column_)
    

_static _contains(_column_ , _value_)
    

_static _matches(_column_ , _value_)
    

_static _in_any_of(_column_ , _values_)
    

_static _in_none_of(_column_ , _values_)
    

_class _dataikuapi.dss.utils.DSSSimpleFilterOperator(_value_)
    

Operators for the `DSSSimpleFilter`.

EQUALS _ = 'EQUALS'_
    

NOT_EQUALS _ = 'NOT_EQUALS'_
    

GREATER_THAN _ = 'GREATER_THAN'_
    

LESS_THAN _ = 'LESS_THAN'_
    

GREATER_OR_EQUAL _ = 'GREATER_OR_EQUAL'_
    

LESS_OR_EQUAL _ = 'LESS_OR_EQUAL'_
    

DEFINED _ = 'DEFINED'_
    

NOT_DEFINED _ = 'NOT_DEFINED'_
    

CONTAINS _ = 'CONTAINS'_
    

MATCHES _ = 'MATCHES'_
    

IN_ANY_OF _ = 'IN_ANY_OF'_
    

IN_NONE_OF _ = 'IN_NONE_OF'_
    

AND _ = 'AND'_
    

OR _ = 'OR'_

---

## [api-reference/python/webapps]

# Webapps

_class _dataikuapi.dss.webapp.DSSWebApp(_client_ , _project_key_ , _webapp_id_)
    

A handle for the webapp.

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.list_webapps()`](<projects.html#dataikuapi.dss.project.DSSProject.list_webapps> "dataikuapi.dss.project.DSSProject.list_webapps").

get_state()
    

Returns:
    

A wrapper object holding the webapp backend state.

Return type:
    

`dataikuapi.dss.webapp.DSSWebAppBackendState`

stop_backend()
    

Stop the webapp backend.

start_or_restart_backend()
    

Start or restart the webapp backend.

Returns:
    

A future tracking the restart progress.

Return type:
    

[`dataikuapi.dss.future.DSSFuture`](<other-administration.html#dataikuapi.dss.future.DSSFuture> "dataikuapi.dss.future.DSSFuture")

get_settings()
    

Returns:
    

A handle for the webapp settings.

Return type:
    

`dataikuapi.dss.webapp.DSSWebAppSettings`

get_backend_client()
    

_class _dataikuapi.dss.webapp.DSSWebAppBackendClient(_client_ , _webapp_)
    

A client to interact by API with a standard webapp backend

_property _base_url
    

_property _session
    

url_for_path(_path_)
    

_class _dataikuapi.dss.webapp.DSSWebAppBackendState(_webapp_id_ , _state_)
    

A wrapper object holding the webapp backend state.

Important

Do not instantiate this class directly, instead use `dataikuapi.dss.webapp.DSSWebApp.get_state()`.

_property _state
    

Returns:
    

The webapp backend state as a dict containing the keys:

  * **projectKey** : the related project key,

  * **webAppId** : the webapp id,

  * **futureInfo** : the status of the last webapp start or restart job if such job exists (prefer using `dataikuapi.dss.webapp.DSSWebAppBackendState.running`).




Return type:
    

python dict

_property _running
    

Returns:
    

Is the backend of the webapp currently running.

Return type:
    

bool

_class _dataikuapi.dss.webapp.DSSWebAppSettings(_client_ , _webapp_ , _data_)
    

A handle for the webapp settings.

Important

Do not instantiate this class directly, instead use `dataikuapi.dss.webapp.DSSWebApp.get_settings()`.

get_raw()
    

Returns:
    

The webapp settings as a dict containing among other keys:

  * **id** : the webapp id,

  * **name** : the webapp name,

  * **type** : the webapp type (e.g. “STANDARD”),

  * **projectKey** : the related project key,

  * **params** : a dict containing other information depending on the webapp type such as the source code.




Return type:
    

python dict

save()
    

Save the current webapp settings.

_class _dataikuapi.dss.webapp.DSSWebAppListItem(_client_ , _data_)
    

An item in a list of webapps.

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.list_webapps()`](<projects.html#dataikuapi.dss.project.DSSProject.list_webapps> "dataikuapi.dss.project.DSSProject.list_webapps").

to_webapp()
    

Convert the current item.

Returns:
    

A handle for the webapp.

Return type:
    

`dataikuapi.dss.webapp.DSSWebApp`

_property _id
    

Returns:
    

The id of the webapp.

Return type:
    

string

_property _name
    

Returns:
    

The name of the webapp.

Return type:
    

string

---

## [api-reference/python/wiki]

# Wiki

For usage information and examples, see [Wikis](<../../concepts-and-examples/wiki.html>)

_class _dataikuapi.dss.wiki.DSSWiki(_client_ , _project_key_)
    

A handle to manage the wiki of a project

Important

Do not instantiate this class directly, instead use [`dataikuapi.dss.project.DSSProject.get_wiki()`](<projects.html#dataikuapi.dss.project.DSSProject.get_wiki> "dataikuapi.dss.project.DSSProject.get_wiki")

get_settings()
    

Get wiki settings

Returns:
    

a handle to manage the wiki settings (taxonomy, home article)

Return type:
    

`dataikuapi.dss.wiki.DSSWikiSettings`

get_article(_article_id_or_name_)
    

Get a wiki article

Parameters:
    

**article_id_or_name** (_str_) – reference to the article, it can be its ID or its name

Returns:
    

a handle to manage the Article

Return type:
    

`dataikuapi.dss.wiki.DSSWikiArticle`

list_articles()
    

Get a list of all the articles in form of `dataikuapi.dss.wiki.DSSWikiArticle` objects

Returns:
    

list of articles

Return type:
    

list of `dataikuapi.dss.wiki.DSSWikiArticle`

create_article(_article_name_ , _parent_id =None_, _content =None_)
    

Create a wiki article and return a handle to interact with it.

Parameters:
    

  * **article_name** (_str_) – the article name

  * **parent_id** (_str_) – the parent article ID (or None if the article has to be at root level, defaults to **None**)

  * **content** (_str_) – the article content (defaults to **None**)



Returns:
    

the created article

Return type:
    

`dataikuapi.dss.wiki.DSSWikiArticle`

get_export_stream(_paper_size ='A4'_, _export_attachment =False_)
    

Download the whole wiki of the project in PDF format as a binary stream.

> Warning
> 
> You need to close the stream after download. Failure to do so will result in the DSSClient becoming unusable.

Parameters:
    

  * **paper_size** (_str_) – the format of the exported page, can be one of ‘A4’, ‘A3’, ‘US_LETTER’ or ‘LEDGER’ (defaults to **A4**)

  * **export_attachment** (_bool_) – export the attachments of the article(s) in addition to the pdf in a zip file (defaults to **False**)



Returns:
    

the exported pdf or zip file as a stream

export_to_file(_path_ , _paper_size ='A4'_, _export_attachment =False_)
    

Download the whole wiki of the project in PDF format into the given output file.

Parameters:
    

  * **path** (_str_) – the path of the file where the pdf or zip file will be downloaded

  * **paper_size** (_str_) – the format of the exported page, can be one of ‘A4’, ‘A3’, ‘US_LETTER’ or ‘LEDGER’ (defaults to **A4**)

  * **export_attachment** (_bool_) – export the attachments of the article(s) in addition to the pdf in a zip file (defaults to **False**)




_class _dataikuapi.dss.wiki.DSSWikiSettings(_client_ , _project_key_ , _settings_)
    

Global settings for the wiki, including taxonomy. Call save() to save

get_taxonomy()
    

Get the taxonomy. The taxonomy is an array listing at top level the root article IDs and their children in a tree format. Every existing article of the wiki has to be in the taxonomy once and only once. For instance:
    
    
    [
        {
            'id': 'article1',
            'children': []
        },
        {
            'id': 'article2',
            'children': [
                {
                    'id': 'article3',
                    'children': []
                }
            ]
        }
    ]
    

Note

Note that this is a direct reference, not a copy, so modifications to the returned object will be reflected when saving

Returns:
    

The taxonomy

Return type:
    

list

move_article_in_taxonomy(_article_id_ , _parent_article_id =None_)
    

An helper to update the taxonomy by moving an article with its children as a child of another article

Parameters:
    

  * **article_id** (_str_) – the main article ID

  * **parent_article_id** (_str_) – the new parent article ID or None for root level (defaults to **None**)




set_taxonomy(_taxonomy_)
    

Set the taxonomy

Parameters:
    

**taxonomy** (_list_) – the taxonomy

get_home_article_id()
    

Get the home article ID

Returns:
    

The home article ID

Return type:
    

str

set_home_article_id(_home_article_id_)
    

Set the home article ID

Parameters:
    

**home_article_id** (_str_) – the home article ID

save()
    

Save the current settings to the backend

_class _dataikuapi.dss.wiki.DSSWikiArticle(_client_ , _project_key_ , _article_id_or_name_)
    

A handle to manage an article

get_data()
    

Get article data handle

Returns:
    

the article data handle

Return type:
    

`dataikuapi.dss.wiki.DSSWikiArticleData`

upload_attachement(_fp_ , _filename_)
    

Upload and attach a file to the article.

Note

Note that the type of file will be determined by the filename extension

Parameters:
    

  * **fp** (_file_) – A file-like object that represents the upload file

  * **filename** (_str_) – The attachement filename




get_uploaded_file(_upload_id_)
    

Download an attachment of the article

Warning

You need to close the stream after download. Failure to do so will result in the DSSClient becoming unusable.

Parameters:
    

**upload_id** (_str_) – The attachement upload id

Returns:
    

The attachment file as a stream

Return type:
    

`requests.Response`

get_export_stream(_paper_size ='A4'_, _export_children =False_, _export_attachment =False_)
    

Download the article in PDF format as a binary stream.

Warning

You need to close the stream after download. Failure to do so will result in the DSSClient becoming unusable.

Parameters:
    

  * **paper_size** (_str_) – the format of the exported page, can be one of ‘A4’, ‘A3’, ‘US_LETTER’ or ‘LEDGER’ (defaults to **A4**)

  * **export_children** (_bool_) – export the children of the article in the pdf (defaults to **False**)

  * **export_attachment** (_bool_) – export the attachments of the article(s) in addition to the pdf in a zip file (defaults to **False**)



Returns:
    

the exported pdf or zip file as a stream

Return type:
    

`requests.Response`

export_to_file(_path_ , _paper_size ='A4'_, _export_children =False_, _export_attachment =False_)
    

Download the article in PDF format into the given output file.

Parameters:
    

  * **path** (_str_) – the path of the file where the pdf or zip file will be downloaded

  * **paper_size** (_str_) – the format of the exported page, can be one of ‘A4’, ‘A3’, ‘US_LETTER’ or ‘LEDGER’ (defaults to **A4**)

  * **export_children** (_bool_) – export the children of the article in the pdf (defaults to **False**)

  * **export_attachment** (_bool_) – export the attachments of the article(s) in addition to the pdf in a zip file (defaults to **False**)




delete()
    

Delete the article

get_object_discussions()
    

Get a handle to manage discussions on the article

Returns:
    

the handle to manage discussions

Return type:
    

`dataikuapi.dss.wiki.DSSObjectDiscussions`

_class _dataikuapi.dss.wiki.DSSWikiArticleData(_client_ , _project_key_ , _article_id_ , _article_data_)
    

A handle to manage an article

get_body()
    

Get the markdown body as string

Returns:
    

the article body

Return type:
    

str

set_body(_content_)
    

Set the markdown body

Parameters:
    

**content** (_str_) – the article content

get_metadata()
    

Get the article and attachment metadata

Note

Note that this is a direct reference, not a copy, so modifications to the returned object will be reflected when saving

Returns:
    

the article metadata

Return type:
    

dict

set_metadata(_metadata_)
    

Set the article metadata

Parameters:
    

**metadata** (_dict_) – the article metadata

get_name()
    

Get the article name

Returns:
    

the article name

Return type:
    

str

set_name(_name_)
    

Set the article name

Parameters:
    

**name** (_str_) – the article name

save()
    

Save the current article data to the backend.

---

## [api-reference/python/workspaces]

# Workspaces

_class _dataikuapi.dss.workspace.DSSWorkspace(_client_ , _workspace_key_)
    

A handle to interact with a workspace on the DSS instance.

Do not create this class directly, instead use [`dataikuapi.DSSClient.get_workspace()`](<client.html#dataikuapi.DSSClient.get_workspace> "dataikuapi.DSSClient.get_workspace")

get_settings()
    

Gets the settings of this workspace.

Returns:
    

a handle to read, modify and save the settings

Return type:
    

`DSSWorkspaceSettings`

list_objects()
    

List the objects in this workspace

Returns:
    

The list of the objects

Return type:
    

list of `DSSWorkspaceObject`

add_object(_object_)
    

Add an object to this workspace. Object can be of different shapes ([`dataikuapi.dss.dataset.DSSDataset`](<datasets.html#dataikuapi.dss.dataset.DSSDataset> "dataikuapi.dss.dataset.DSSDataset"), [`dataikuapi.dss.dataset.DSSDatasetListItem`](<datasets.html#dataikuapi.dss.dataset.DSSDatasetListItem> "dataikuapi.dss.dataset.DSSDatasetListItem"), [`dataikuapi.dss.wiki.DSSWikiArticle`](<wiki.html#dataikuapi.dss.wiki.DSSWikiArticle> "dataikuapi.dss.wiki.DSSWikiArticle"), [`dataikuapi.dss.app.DSSApp`](<dataiku-applications.html#dataikuapi.dss.app.DSSApp> "dataikuapi.dss.app.DSSApp"), `DSSWorkspaceHtmlLinkObject`, [`dataikuapi.dss.dashboard.DSSDashboard`](<dashboards.html#dataikuapi.dss.dashboard.DSSDashboard> "dataikuapi.dss.dashboard.DSSDashboard"), [`dataikuapi.dss.dashboard.DSSDashboardListItem`](<dashboards.html#dataikuapi.dss.dashboard.DSSDashboardListItem> "dataikuapi.dss.dashboard.DSSDashboardListItem") or a `dict` that contains the raw data)

delete()
    

Delete the workspace

This call requires Administrator rights on the workspace.

_class _dataikuapi.dss.workspace.DSSWorkspaceObject(_workspace_ , _data_)
    

A handle on an object of a workspace

Do not create this class directly, instead use `dataikuapi.dss.DSSWorkspace.list_objects()`

get_raw()
    

remove()
    

Remove this object from the workspace

This call requires Contributor rights on the workspace.

_class _dataikuapi.dss.workspace.DSSWorkspaceSettings(_workspace_ , _settings_)
    

A handle on the settings of a workspace

Do not create this class directly, instead use `dataikuapi.dss.DSSWorkspace.get_settings()`

get_raw()
    

_property _display_name
    

Get or set the name of the workspace

Return type:
    

`str`

_property _color
    

Get or set the background color of the workspace (using #xxxxxx syntax)

Return type:
    

`str`

_property _description
    

Get or set the description of the workspace

Return type:
    

`str`

_property _permissions
    

Get or set the permissions controlling who is a member, contributor or admin of the workspace

If user is not workspace admin, the permissions field is redacted to None.

Return type:
    

list of `dict` or `None`

save()
    

Save the changes made on the settings

This call requires Administrator rights on the workspace.

_class _dataikuapi.dss.workspace.DSSWorkspacePermissionItem
    

_classmethod _admin_group(_group_)
    

_classmethod _contributor_group(_group_)
    

_classmethod _member_group(_group_)
    

_classmethod _admin_user(_user_)
    

_classmethod _contributor_user(_user_)
    

_classmethod _member_user(_user_)