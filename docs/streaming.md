# Dataiku Docs — streaming

## [streaming/concepts]

# Concepts

## Streaming endpoints

A streaming endpoint is a message source or sink. It can be

  * a topic in a Kafka cluster

  * a queue in SQS

  * a HTTP SSE endpoint (read only)




## Continuous recipe

Recipes taking streaming endpoints as input are continuous recipes.

The distinction between regular and continuous recipes comes from the fact that runs of regular recipes are finite: their input data consists of datasets and the recipe is done when all the input data is read. However, streaming endpoints can provide data indefinitely, so continuous recipes can work without ever stopping on their own.

## Continuous activity

A continuous activity is a controller that oversees one continuous recipe and ensures it runs well, potentially restarting it if it fails.

---

## [streaming/cpython]

# Continuous Python

Just like a regular Python recipe, a continuous Python recipe runs user-provided Python code. The difference is that it accepts streaming endpoints as inputs and outputs, and when running, will restart if needed and requested. The Python code has to loop or wait indefinitely, in order to continuously handle the input and produce output.

## Reading from streaming endpoints

It is advised to read from streaming endpoints using native access, ie to have the Python process connect directly to the message source and handle the messages and offsets directly.

Alternatively, a simpler method to read from a streaming endpoint is to have DSS read the messages and forward them to the Python process.
    
    
    endpoint = dataiku.StreamingEndpoint("wikipedia")
    
    message_iterator = endpoint.get_message_iterator()
    for msg in message_iterator:
            # use the message ... (msg is a json-encoded object)
            state = message_iterator.get_state() # a string
            # if/when needed, do something with state
    

### Reading from Kafka endpoints

The StreamingEndpoint class offers a helper to consume from a Kafka topic using the [pykafka](<https://github.com/Parsely/pykafka>) package
    
    
    endpoint = dataiku.StreamingEndpoint("wikipedia_kafka")
    message_iterator = endpoint.get_native_kafka_consumer()
    
    for msg in message_iterator:
        # use the pykafka message object
    

Messages returned by pykafka have the following fields usable in your code:

>   * timestamp is a unix timestamp in milliseconds
> 
>   * offset is the message offset in the topic
> 
>   * partition_key is the key of the message, as a byte array
> 
>   * value is the value of the message, as a byte array
> 
> 


Note

The builtin Python environment does not include the pykafka package. To use the helper methods, you need to use a custom code-env that includes this package.

Note

Only PLAINTEXT Kafka listeners (ie without SSL encryption) are handled by the helper. For SSL support, you need to use pykafka directly and pass the relevant parameters to setup the encryption logic.

Note

The helper returns simple consumers. If you want balanced consumers, you need to use pykafka directly.

### Reading from SQS endpoints

The StreamingEndpoint class offers a helper to consume from a SQS queue using the [boto3](<https://github.com/boto/boto3>) package
    
    
    endpoint = dataiku.StreamingEndpoint("wikipedia_sqs")
    message_iterator = endpoint.get_native_sqs_consumer()
    
    for msg in message_iterator:
        # use the message (it's a string)
    

The messages returned by the iterator are acknowledged one by one on SQS side when they are retrieved from the iterator. To acknowledge messages only after they’ve been processed, use boto3 directly

Note

The builtin Python environment does not include the boto3 package. To use the helper methods, you need to use a custom code-env including this package.

### Reading from HTTP SSE endpoints

The StreamingEndpoint class offers a helper to consume from a HTTP SSE endpoint using the [sseclient](<https://github.com/btubbs/sseclient>) package
    
    
    endpoint = dataiku.StreamingEndpoint("wikipedia")
    message_iterator = endpoint.get_native_httpsse_consumer()
    
    for msg in message_iterator:
        # use the sseclient message object
    

Messages returned by pykafka have these fields:

>   * id is a message identifier (often equivalent to the offset)
> 
>   * event is the event type
> 
>   * data is the message data (can be None depending on the event)
> 
> 


Note

The builtin Python environment does not include the sseclient package. To use the helper methods, you need to use a custom code-env including this package.

## Writing to streaming endpoints

It is advised to write to streaming endpoints using native access, ie to have the Python process connect directly to the message source and handle the messages and offsets directly.

Alternatively, a simpler method to write to a streaming endpoint is to have the Python process send the messages to DSS and let DSS handle the writing.
    
    
    endpoint = dataiku.StreamingEndpoint("wikipedia_kafka")
    # setting a schema is strongly advised before using get_writer()
    endpoint.set_schema([{"name":"data", "type":"string", ...}])
    with endpoint.get_writer() as writer:
        for msg in message_iterator:
            writer.write_row_dict({"data":msg.data, ...})
            writer.flush()
    

The call to flush() ensures the messages are sent to DSS for writing. It is not mandatory after each and every message written, but need to be used regularly nonetheless.

### Writing to Kafka endpoints

The StreamingEndpoint class offers a helper to produce to a Kafka topic using the [pykafka](<https://github.com/Parsely/pykafka>) package
    
    
        endpoint = dataiku.StreamingEndpoint("wikipedia_kafka")
    with endpoint.get_native_kafka_producer(sync=True) as writer:
                for msg in message_iterator:
                writer.produce(msg.data.encode('utf8'), partition_key='my_key'.encode('utf8'), timestamp=datetime.now())
    

The partition_key and timestamp params are optional.

Note

The builtin Python environment doesn’t include the pykafka package. To use the helper methods, the code needs to be run on a code env providing the pykafka package.

Note

Only PLAINTEXT Kafka listeners (ie without SSL encryption) are handled by the helper. For SSL support, you need to use pykafka directly and pass the relevant parameters to setup the encryption logic.

## Writing to datasets

Writing the output dataset is done via a writer object returned by Dataset.get_continuous_writer, using the standard methods write_row_dict, write_dataframe or write_tuple.

Warning

When writing to datasets, it is crucial to regularly checkpoint the data. The reason being that rows written to the dataset are first staged to a temporary file and only become fully part of the dataset when a checkpoint is done.
    
    
    dataset = dataiku.Dataset("wikipedia_dataset")
    dataset.write_schema([{"name":"data", "type":"string"}, ...])
    with dataset.get_continuous_writer() as writer:
        for msg in message_iterator:
            writer.write_row_dict({"data":msg.data, ...})
            writer.checkpoint("this_recipe", "some state")
    

## Offset management

Most streaming sources have a notion of offset, to keep track of where in the message queue the reader is. The recipe is responsible for managing its offsets, and particularly for storing the current offset and retrieving the last offset upon starting.

When writing to datasets with a continuous writer (from a get_continuous_writer() call), and if the dataset is a file-based dataset, the recipe can rely on the last state saved via a call to checkpoint() and retrieve that last state with get_state() on the continuous writer. When writing to streaming endpoints, the recipe has to manage the storage of the offsets.

---

## [streaming/csync]

# Continuous sync

A continuous Sync recipe processes messages from a streaming endpoint and passes them either to another streaming endpoint, or stores them in a dataset. The main use is to capture a stream into a dataset, to perform analyses on it.

A continuous sync recipe offers exactly-once guarantees when the following conditions are met:

  * the input streaming endpoint is replayable

  * the output can be atomically checkpointed




A example of such a case is when the input is a Kafka streaming endpoint and the output a file-based dataset.

## Partitioning

If the output dataset is partitioned with a single time dimension, then the continuous sync recipe writes the messages in a partition corresponding to the time where the message was received from the streaming endpoint. For example, with an hourly partitioning, messages arriving between 2020-07-11 08:00:00 and 2020-07-11 08:59:59 will go into the 2020-07-11-08 partition.

---

## [streaming/httpsse]

# HTTP Server-Sent Events

Server-sent events is a protocol on top of HTTP by which a server can publish streams of events. A HTTP SSE streaming endpoint in DSS is defined by the URL to connect to in order to open the HTTP connection. The message data is then retrieve in a column named data.

---

## [streaming/index]

# Streaming data

Warning

**Experimental** : Support for Streaming is [Experimental](<../troubleshooting/support-tiers.html>) and not fully-supported:

Note

Streaming features are not enabled by default in DSS. You need to manually activate them by going to _Administration > Settings > Misc. > Other_, check the “Enable streaming” box and restart DSS.

---

## [streaming/kafka]

# Kafka

DSS can leverage [Kafka](<https://kafka.apache.org>) topics as streaming endpoints.

## Connection setup

To read or write from Kafka topics, a connection to a Kafka cluster is required. The connection is defined by a list of bootstrap servers, and security settings. DSS supports the PLAINTEXT and SASL protocols for communicating with the brokers, and Kerberos authentication which is a special case of SASL. Since both protocols are not natively encrypted, they usually require to activate SSL. When this is the case, the truststore and keystore holding the certificates are also set in the connection (see the ssl.* properties in [Kafka’s doc](<https://kafka.apache.org/documentation/#consumerconfigs>))

Warning

Using Kerberos and/or SSL precludes using the helper methods to access the streaming endpoints in Python recipes, as the python libraries do not handle Kerberos and/or require the certificates in a form that is not a keystore/truststore

## Message format

Kafka messages comprise a key, a value and a timestamp. Both key and value are treated by the Kafka brokers as binary data, and it is the message producer and consumer’s duty to read and write this binary data.

When converting a message to a row, DSS reads the key first (if a format is set), then the value. Columns present in the key take precedence over columns present in the value. Similarly, the timestamp column (if defined) takes precedence over the columns present in key or value.

Warning

Streaming endpoints have a schema, like datasets, which describes its content as a set of columns with types. When DSS reads from a Kafka topic, the most important part of the schema is the set of column names, while the types are only informative. However, if you are using Spark to process the data, the types have to properly match the types of the data in the Kafka message since Spark is more strict with typing.

### Single-value

This format maps to the base SerDes classes of Kafka. It treats the binary value as the binary representation of a single value: a string or an integer or a long integer or a double or a byte array. DSS reads or writes the value in a given column. If the column name is not specified, nothing is read or written.

### JSON

The binary value is a UTF8 JSON string. DSS parses the entire value or a subset of its fields.

### Avro

The flavor of Avro used in the Kafka world is actually not a pure Avro message, but a composite of a schema identifier and an Avro message. DSS uses the SerDes from Confluent to read Avro messages (see the [SerDes’ doc](<https://docs.confluent.io/current/schema-registry/serdes-develop/serdes-avro.html#>)), which makes it mandatory to define the schema.registry.url property in some way: either on the Kafka connection properties, or in the streaming endpoint properties.

#### Secured Registries

If your Schema Registry requires authentication, DSS supports **Basic Auth**. Add the following properties to either the Kafka connection, or the streaming endpoint properties:

  * `basic.auth.credentials.source`: Defines the source of the credentials (see the [official doc](<https://docs.confluent.io/platform/current/schema-registry/sr-client-configs.html#basic-auth-credentials-source>)).

  * `basic.auth.user.info`: The specific user credentials (see the [official doc](<https://docs.confluent.io/platform/current/schema-registry/sr-client-configs.html#basic-auth-user-info>)).




## Timestamp handling

All messages in a Kafka topic have a timestamp, usually set by the broker when the message is added to the topic. When a timestamp column name is set in the streaming endpoint’s settings, upon reading in DSS, the value of the timestamp is fetched in that column. Conversely, if the provide timestamp checkbox is ticked, upon writing by DSS the value of the timestamp column is used for the message timestamp (if the broker permits setting the timestamp)

---

## [streaming/sqs]

# AWS SQS

## Connection setup

SQS connections offer the same settings as [S3 connections](<../connecting/s3.html>) to define AWS credentials

## Message format

SQS messages are text only. DSS offers to read or write them as simple text or as JSON

### Single-value

Upon reading, the message’s text is put in the row under a column name, and upon writing, the value of the given column is taken from the row and used as message.

### JSON

Upon reading, SQS messages are parsed from JSON to fill a row, and conversely, upon writing the fields of the row are grouped in a JSON object

---

## [streaming/streaming_spark_scala]

# Streaming Spark Scala

DSS uses wrappers around Spark’s [structured streaming](<https://archive.apache.org/dist/spark/docs/2.4.0/structured-streaming-programming-guide.html>) to manipulate streaming endpoints. This implies using a micro-batch approach and manipulating Spark dataframes.

Data from streaming endpoints is accessed via getStream():
    
    
    val dkuContext   = DataikuSparkContext.getContext(sparkContext)
    val df = dkuContext.getStream("wikipedia")
    // manipulate df like a regular dataframe
    

DSS will automatically use Spark’s native Kafka integration, and stream the data via the backend for other endpoint types.

Writing a streaming dataframe to a dataset is:
    
    
    val q = dkuContext.saveStreamingQueryToDataset("dataset", df)
    q.awaitTermination() // waits for the sources to stop
    

Writing to a streaming endpoint is equally simple:
    
    
    val q = dkuContext.saveStreamingQueryToStreamingEndpoint("endpoint", df)
    q.awaitTermination() // waits for the sources to stop
    

The awaitTermination() call is needed, otherwise the recipe will exit right away.