# Dataiku Docs — api-node-deployer

## [apinode/api/admin-api]

# API node administration API

The API node can be managed through:

  * The `apinode-admin` command-line tool. See [Using the apinode-admin tool](<../operations/cli-tool.html>)

  * An HTTP REST API.




## The REST API

### Request and response formats

For POST and PUT requests, the request body must be JSON, with the Content-Type header set to application/json.

For almost all requests, the response will be JSON.

Whether a request succeeded is indicated by the HTTP status code. A 2xx status code indicates success, whereas a 4xx or 5xx status code indicates failure. When a request fails, the response body is still JSON and contains additional information about the error.

### Authentication

Authentication on the admin API is done via the use of API keys. API keys can be managed using the `apinode-admin` command-line tool.

The API key must be sent using HTTP Basic Authorization:

  * Use the API key as username

  * The password can remain blank




### Methods reference

The reference documentation of the API is available at <https://doc.dataiku.com/dss/api/14/apinode-admin>

## Admin REST API Python client

Dataiku provides a Python client for the API Node administration API. The client makes it easy to write client programs for the API in Python.

### Installing

  * The API client is already pre-installed in the DSS Python environment

  * From outside of DSS, you can install the Python client by running `pip install dataiku-api-client`




### Reference API doc

_class _dataikuapi.APINodeAdminClient(_uri_ , _api_key_ , _no_check_certificate =False_, _client_certificate =None_, _** kwargs_)
    

Entry point for the DSS APINode admin client

create_service(_service_id_)
    

Creates a new API service

Parameters:
    

**service_id** – id of the created API service

list_services()
    

Lists the currently declared services and their enabled/disabled state

Returns:
    

a dict of services containing their id and state, as a JSON object

Return type:
    

dict

service(_service_id_)
    

Gets a handle to interact with a service

Parameters:
    

**service_id** – id of requested service

Return type:
    

class:
    

dataikuapi.apinode_admin.service.APINodeService

auth()
    

Returns a handle to interact with authentication

Return type:
    

class:
    

dataikuapi.apinode_admin.auth.APINodeAuth

get_metrics()
    

Get the metrics for this API Node

Returns:
    

the metrics, as a JSON object

Return type:
    

dict

import_code_env_in_cache(_file_dir_ , _language_)
    

Import a code env in global cache from an exported code env base folder

Parameters:
    

  * **file_dir** – path of an exported code env base folder

  * **language** – language of the code env (python or R)




register_code_env_in_cache(_exported_env_dir_ , _built_env_dir_ , _language_)
    

Import a code env in global cache from an exported code env base folder

Parameters:
    

  * **exported_env_dir** – path of an exported code env base folder

  * **built_env_dir** – path where the code env was built and is available

  * **language** – language of the code env (python or R)




import_model_archive_in_cache(_model_archive_path_)
    

Import a model in model cache from an exported model archive

Parameters:
    

**model_archive_path** – path of an exported model archive

clear_model_cache()
    

Clear the model cache

clean_unused_services_and_generations()
    

Deletes disabled services, unused generations and unused code environments

clean_code_env_cache()
    

Deletes unused code envs from cache

_class _dataikuapi.apinode_admin.service.APINodeService(_client_ , _service_id_)
    

A handle to interact with the settings of an API node service

delete()
    

Deletes the API node service

list_generations()
    

import_generation_from_archive(_file_path_)
    

preload_generation(_generation_)
    

disable()
    

Disable the service.

enable()
    

set_generations_mapping(_mapping_)
    

Setting a generations mapping automatically enables the service

switch_to_newest()
    

switch_to_single_generation(_generation_)
    

_class _dataikuapi.apinode_admin.auth.APINodeAuth(_client_)
    

A handle to interact with authentication settings on API node

list_keys()
    

Lists the Admin API keys

add_key(_label =None_, _description =None_, _created_by =None_, _expiry =None_)
    

Add an Admin API key. Returns the key details

delete_key(_key_)
    

delete_key_by_id(_id_)

---

## [apinode/api/index]

# APINode APIs reference

---

## [apinode/api/user-api]

# API node user API

Predictions are obtained on the API node by using the User REST API.

## The REST API

### Request and response formats

For POST and PUT requests, the request body must be JSON, with the Content-Type header set to application/json.

For almost all requests, the response will be JSON.

Whether a request succeeded is indicated by the HTTP status code. A 2xx status code indicates success, whereas a 4xx or 5xx status code indicates failure. When a request fails, the response body is still JSON and contains additional information about the error.

### Authentication

Each service declares whether it uses authentication or not. If the service requires authentication, the valid API keys are defined in DSS.

The API key must be sent using [HTTP Basic Authentication](<https://en.wikipedia.org/wiki/Basic_access_authentication>):

  * Use the API key as username

  * The password can remain blank




The valid API keys are defined on the DSS side, not on the API node side. This ensures that all instances of an API node will accept the same set of client keys

### Methods reference

The reference documentation of the API is available at <https://doc.dataiku.com/dss/api/14/apinode-user>

## API Python client

Dataiku provides a Python client for the API Node user API. The client makes it easy to write client programs for the API in Python.

### Installing

  * The API client is already pre-installed in the DSS virtualenv

  * From outside of DSS, you can install the Python client by running `pip install dataiku-api-client`




### Reference API doc

_class _dataikuapi.APINodeClient(_uri_ , _service_id_ , _api_key =None_, _bearer_token =None_, _no_check_certificate =False_, _client_certificate =None_, _** kwargs_)
    

Entry point for the DSS API Node client This is an API client for the user-facing API of DSS API Node server (user facing API)

predict_record(_endpoint_id_ , _features_ , _forced_generation =None_, _dispatch_key =None_, _context =None_, _with_explanations =None_, _explanation_method =None_, _n_explanations =None_, _n_explanations_mc_steps =None_)
    

Predicts a single record on a DSS API node endpoint (standard or custom prediction)

Parameters:
    

  * **endpoint_id** (_str_) – Identifier of the endpoint to query

  * **features** – Python dictionary of features of the record

  * **forced_generation** – See documentation about multi-version prediction

  * **dispatch_key** – See documentation about multi-version prediction

  * **context** – Optional, Python dictionary of additional context information. The context information is logged, but not directly used.

  * **with_explanations** – Optional, whether individual explanations should be computed for each record. The prediction endpoint must be compatible. If None, will use the value configured in the endpoint.

  * **explanation_method** – Optional, method to compute explanations. Valid values are ‘SHAPLEY’ or ‘ICE’. If None, will use the value configured in the endpoint.

  * **n_explanations** – Optional, number of explanations to output per prediction. If None, will use the value configured in the endpoint.

  * **n_explanations_mc_steps** – Optional, precision parameter for SHAPLEY method, higher means more precise but slower (between 25 and 1000). If None, will use the value configured in the endpoint.



Returns:
    

a Python dict of the API answer. The answer contains a “result” key (itself a dict)

predict_records(_endpoint_id_ , _records_ , _forced_generation =None_, _dispatch_key =None_, _with_explanations =None_, _explanation_method =None_, _n_explanations =None_, _n_explanations_mc_steps =None_)
    

Predicts a batch of records on a DSS API node endpoint (standard or custom prediction)

Parameters:
    

  * **endpoint_id** (_str_) – Identifier of the endpoint to query

  * **records** – Python list of records. Each record must be a Python dict. Each record must contain a “features” dict (see predict_record) and optionally a “context” dict.

  * **forced_generation** – See documentation about multi-version prediction

  * **dispatch_key** – See documentation about multi-version prediction

  * **with_explanations** – Optional, whether individual explanations should be computed for each record. The prediction endpoint must be compatible. If None, will use the value configured in the endpoint.

  * **explanation_method** – Optional, method to compute explanations. Valid values are ‘SHAPLEY’ or ‘ICE’. If None, will use the value configured in the endpoint.

  * **n_explanations** – Optional, number of explanations to output per prediction. If None, will use the value configured in the endpoint.

  * **n_explanations_mc_steps** – Optional, precision parameter for SHAPLEY method, higher means more precise but slower (between 25 and 1000). If None, will use the value configured in the endpoint.



Returns:
    

a Python dict of the API answer. The answer contains a “results” key (which is an array of result objects)

forecast(_endpoint_id_ , _records_ , _forced_generation =None_, _dispatch_key =None_)
    

Forecast using a time series forecasting model on a DSS API node endpoint

Parameters:
    

  * **endpoint_id** (_str_) – Identifier of the endpoint to query

  * **records** (_array_) – 

List of time series data records to be used as an input for the time series forecasting model. Each record should be a dict where keys are feature names, and values feature values.

Example:
        
        records = [
                {'date': '2015-01-04T00:00:00.000Z',
                  'timeseries_id': 'A', 'target': 10.0},
                {'date': '2015-01-04T00:00:00.000Z',
                  'timeseries_id': 'B', 'target': 4.5},
                {'date': '2015-01-05T00:00:00.000Z',
                  'timeseries_id': 'A', 'target': 2.0},
                ...
                {'date': '2015-03-20T00:00:00.000Z',
                  'timeseries_id': 'B', 'target': 1.3}
        ]
        

  * **forced_generation** – See documentation about multi-version prediction

  * **dispatch_key** – See documentation about multi-version prediction



Returns:
    

a Python dict of the API answer. The answer contains a “results” key (which is an array of result objects, corresponding to the forecast records) Example:
    
    
    {'results': [
        {'forecast': 12.57, 'ignored': False,
          'quantiles': [0.0001, 0.5, 0.9999],
          'quantilesValues': [3.0, 16.0, 16.0],
          'time': '2015-03-21T00:00:00.000000Z',
          'timeseriesIdentifier': {'timeseries_id': 'A'}},
        {'forecast': 15.57, 'ignored': False,
          'quantiles': [0.0001, 0.5, 0.9999],
          'quantilesValues': [3.0, 18.0, 19.0],
          'time': '2015-03-21T00:00:00.000000Z',
          'timeseriesIdentifier': {'timeseries_id': 'B'}},
      ...],
    ...}
    

predict_effect(_endpoint_id_ , _features_ , _forced_generation =None_, _dispatch_key =None_)
    

Predicts the treatment effect of a single record on a DSS API node endpoint (standard causal prediction)

Parameters:
    

  * **endpoint_id** (_str_) – Identifier of the endpoint to query

  * **features** – Python dictionary of features of the record

  * **forced_generation** – See documentation about multi-version prediction

  * **dispatch_key** – See documentation about multi-version prediction



Returns:
    

a Python dict of the API answer. The answer contains a “result” key (itself a dict)

predict_effects(_endpoint_id_ , _records_ , _forced_generation =None_, _dispatch_key =None_)
    

Predicts the treatment effects on a batch of records on a DSS API node endpoint (standard causal prediction)

Parameters:
    

  * **endpoint_id** (_str_) – Identifier of the endpoint to query

  * **records** – Python list of records. Each record must be a Python dict. Each record must contain a “features” dict (see predict_record) and optionally a “context” dict.

  * **dispatch_key** – See documentation about multi-version prediction



Returns:
    

a Python dict of the API answer. The answer contains a “results” key (which is an array of result objects)

sql_query(_endpoint_id_ , _parameters_)
    

Queries a “SQL query” endpoint on a DSS API node

Parameters:
    

  * **endpoint_id** (_str_) – Identifier of the endpoint to query

  * **parameters** – Python dictionary of the named parameters for the SQL query endpoint



Returns:
    

a Python dict of the API answer. The answer is the a dict with a columns field and a rows field (list of rows as list of strings)

lookup_record(_endpoint_id_ , _record_ , _context =None_)
    

Lookup a single record on a DSS API node endpoint of “dataset lookup” type

Parameters:
    

  * **endpoint_id** (_str_) – Identifier of the endpoint to query

  * **record** – Python dictionary of features of the record

  * **context** – Optional, Python dictionary of additional context information. The context information is logged, but not directly used.



Returns:
    

a Python dict of the API answer. The answer contains a “data” key (itself a dict)

lookup_records(_endpoint_id_ , _records_)
    

Lookups a batch of records on a DSS API node endpoint of “dataset lookup” type

Parameters:
    

  * **endpoint_id** (_str_) – Identifier of the endpoint to query

  * **records** – Python list of records. Each record must be a Python dict, containing at least one entry called “data”: a dict containing the input columns



Returns:
    

a Python dict of the API answer. The answer contains a “results” key, which is an array of result objects. Each result contains a “data” dict which is the output

run_function(_endpoint_id_ , _** kwargs_)
    

Calls a “Run function” endpoint on a DSS API node

Parameters:
    

  * **endpoint_id** (_str_) – Identifier of the endpoint to query

  * **kwargs** – Arguments of the function



Returns:
    

The function result

---

## [apinode/api-deployment-infrastructures]

# Setting up the API Deployer and deployment infrastructures

The API Deployer is part of the Deployer. Follow the [Deployer installation steps](<../deployment/index.html>) to be able to use the API Deployer.

You will then need to create API infrastructures.

## Create your first infrastructure

The API Deployer manages several deployment infrastructures. You need to create at least one in order to be able to deploy API services.

Possible infrastructure types are:

  * A _static_ infrastructure: a set of pre-deployed API nodes that the API Deployer manages.

  * A _kubernetes_ infrastructure: the API Deployer dynamically creates containers in your Kubernetes cluster to run the API Node server.

  * An _external platform_ : The API Deployer can deploy to any of the supported third party platforms (AWS Sagemaker, Azure Machine Learning, Databricks, Google Vertex AI, or Snowflake Snowpark).




### Static infrastructure

  * Install one or several API nodes as described in [Installing API nodes](<installing-apinode.html>).

  * For each API node, generate an admin key from the terminal: go to the API node’s DATA_DIR and use `./bin/apinode-admin admin-key-create`.

  * Write down the key.




On the API Deployer node:

  * From the home page, go to API Deployer > Infrastructures.

  * Create a new infrastructure with “static” type.

  * Go to the “API Nodes” settings page.

  * For each API node, enter its base URL (including protocol and port number) and the API key.




Then, go to the “Permissions” tab and grant to some user groups the right to deploy models to this infrastructure.

Your infrastructure is ready to use, and you can create your first model: [First API (with API Deployer)](<first-service-apideployer.html>).

### Kubernetes infrastructure

Please see [Deploying on Kubernetes](<kubernetes/index.html>).

### External infrastructure

In order to deploy to a third party platform, you first need to setup and store the credentials to be used by API Deployer. This operation is done through a connection of a specific type listed under the section Managed Model Deployment Infrastructures.

Each of the supported types offers various ways to authenticate. You will probably need to be administrator of your external platform and have knowledge of how to setup authentication and permissions to finalize this task.

Once done and working, you can go back to API Deployer and create the infrastructure.

  * Create a new infrastructure with one of the corresponding types: Azure Machine Learning, Amazon Sagemaker, Databricks, Google Vertex AI, or Snowflake Snowpark.

  * Open the “Basic Parameters” section and fill-in the mandatory parameters, mostly on how to authenticate to the external infrastructure and the docker registry (if relevant).

  * Check and activate other optional settings and capabilities, especially the “Auditing and queries logging” if you want to build a monitoring loop.

  * Grant access to this infrastructure in the “Permissions” section.




Your infrastructure is now ready to use.

Note

  * Deploying to an external infrastructure (except Databricks) leverages docker images. To that extent, it requires Dataiku’s “apideployer” docker base images to be built. See [Build the base image](<../containers/setup-k8s.html#rebuild-base-images>) in a custom setup.

  * To deploy on Databricks’ external infrastructure, you will need the “Databricks utils” internal code environment. Indeed, models are exported as MLflow models (see [Export as a MLflow model](<../machine-learning/models-export.html#mlflow-export>)) before being deployed. Internal code environments can be created in Administration > Code envs > Internal envs setup.




Once configured, you can deploy API services to this infrastructure as explained in [Deploying to an external platform](<deploy-anywhere.html>).

### Setting up stages

Each infrastructure belongs to a “lifecycle stage”. This is used in order to show deployments per lifecycle stage. DSS comes pre-configured with the classic “Development”, “Test” and “Production” stages, but you can freely modify these stages in Administration > Settings > Deployer > API deployment stages.

## Configuring an API infrastructure

For details on how to configure a Kubernetes Cluster of API nodes, please refer to [Deploying on Kubernetes](<kubernetes/index.html>).

### Auditing and query logging

This section defines how and where the API infrastructure will log its activity.

If you are using Fleet Manager, you will not be able to do the detailed configuration of Event-Server or Kafka in this screen. This is done in Fleet Manager directly.

A key part of this section is the reporting options: they are used to configure how prediction logs are going to be reported for MLOps monitoring. The standard option provided by Dataiku is called the Event Server. With this solution in place, all predictions made by any deployment on this infrastructure will be sent back to the Event Server to store it on a file-based storage. This will be the main source for building your feedback loop.

You can find more on configuring an Event Server in [The Event Server](<../operations/audit-trail/eventserver.html>).

To understand, configure and automate your monitoring loop, you can refer to [our dedicated Knowledge Base article](<https://knowledge.dataiku.com/latest/deploy/model-monitoring/tutorial-api-endpoint-monitoring-basics.html>).

### Permissions

You can define a group-based security scheme for each infrastructure to match your internal organization and processes.

Each user using Project Deployer has access to different set of actions depending on these permissions:

  * If the user is **not granted any permission** , this infrastructure and all its deployments will not be visible or usable in any way.

  * The **View** permission limits the user’s ability to see deployments and their details in the dashboard.

  * **Deploy** permission grants the user the right to create, update or delete deployments on this infrastructure.

  * The **Admin** permission allows the user to see and edit all infrastructure settings.




Note

The user security is not only defined by infrastructure but also by API service, as defined in the Services tab. This allows for advanced configuration, such as allowing all users to deploy any API service on a DEV infrastructure, but only certain users to deploy it on a PROD infrastructure.

You can also restrict the deployment of API services on a production instance to a technical account used by a CI/CD orchestrator through the Python API, while keeping users the view rights for monitoring.

You can learn more on this type of setup in our [Knowledge Base](<https://knowledge.dataiku.com/latest/deploy/scaling-automation/tutorial-getting-started-ci-cd.html>).

### Deployment hooks

Hooks are custom actions performed before or after deployments. Please refer to the [Automation node](<../deployment/project-deployment-infrastructures.html#deployment-hooks>) for more details.

---

## [apinode/api-documentation]

# Documenting your API endpoints

API endpoints are meant to be integrated in a company ecosystem of applications. They are typically used to add machine learning predictions in other tools. As such, users need to know where and how to query them.

To fulfill this objective, you have the possibility to add a documentation to any API endpoint. This is done at the endpoint level and will produce a standard [OpenAPI JSON file](<https://swagger.io/specification/v2/>) (version 2). Once served, not only can it be accessed by any API user, it can also be inserted into a corporate API registry.

## Add OpenAPI documentation to an API endpoint

Adding documentation is done in [API Designer](<concepts.html>), in the **OpenAPI documentation** section on the left menu.

By default, OpenAPI documentation is disabled on endpoints. Once activated, you will see the actual JSON content on this screen.

For some supported prediction models, Dataiku is able to generate the OpenAPI documentation automatically. For all other cases, you will be provided with a template that needs to be completed.

Once saved, this documentation is embedded in the API service that will be used for deployment.

## Publishing OpenAPI documentation

When deploying on an API node, if the service contains endpoints that have OpenAPI documentation, it will be accessible alongside the model endpoint on the API node using an alternate URL that is indicated in the deployment summary tile, on the top left corner of a deployment:

You can click on the magnifier icon to see the actual JSON being served. Of course, you can query it from outside Dataiku using a command like `curl -X GET http://<deployment uri>/swagger` (e.g. `curl http://10.1.0.101:12000/public/api/v1/dku_service_mlflow/swagger`).

Note

This additional endpoint will follow the security scheme in place for accessing the main endpoint. As such, if you have a key-based authentication to access the prediction endpoint, the same will be required for accessing the OpenAPI endpoint.

Note

This additional URL for the API documentation is directly available only for deployment on static API nodes. If you want to leverage OpenAPI documentation in this context, you may query the API Deployer directly instead; see below. When deploying on a Kubernetes cluster, you may also make the documentation endpoint available through a custom ingress.

## Listing documentation of all API endpoints

In addition to serving the OpenAPI file on a specific URL, Dataiku allows you to query all documentation directly on the node where the API Deployer sits, using standard Python APIs, particularly `DSSAPIDeployerDeployment.get_open_api`.
    
    
    import dataiku
    import pprint
    
    pp = pprint.PrettyPrinter(indent=4)
    client = dataiku.api_client()
    adpl = client.get_apideployer()
    
    open_api_json_list = []
    for dpl in adpl.list_deployments():
        try:
            json = dpl.get_open_api()
            open_api_json_list.append(json.get())
            print(f"Adding OpenAPI documentation for deployment {id(dpl)}")
        except Exception as e:
            print(e)
            continue
    
    print("Number of deployments with OpenAPI documentation enabled : " + str(len(open_api_json_list)))
    pp.pprint(open_api_json_list)

---

## [apinode/concepts]

# Concepts

## API Node

The API Node is the application server that does the actual job of answering HTTP requests. API Nodes are horizontally scalable and highly available. They can be deployed either as a set of servers, or as containers through the use of Kubernetes (which allows you to deploy either on-premises, or on a serverless stack on the cloud).

The API Node can be administratively configured using the command-line or a REST API. The UI for using API nodes is the API Deployer.

## API Deployer

With the API Deployer you can:

  * Define “API infrastructures”, each pointing to either already-installed API node(s) or a Kubernetes cluster

  * Deploy new API services on an infrastructure (i.e. to all API nodes in the infrastructure)

  * Monitor the health and status of your API nodes

  * Manage the lifecycle of your APIs from development to production




The API Deployer can control an arbitrary number of API nodes, and can dynamically deploy new API nodes as containers through the use of Kubernetes (which allows you to deploy either on-premises, or on a serverless stack on the cloud).

The API Deployer is part of the Deployer, which is usually deployed as a dedicated node in your DSS cluster. Please refer to [Production deployments and bundles](<../deployment/index.html>).

Usage of the API Deployer is optional. You can deploy API Services directly to API Nodes using the API Node CLI or API.

## API Designer

The API Designer is a section of each DSS Project that you use for creating, designing, and developing your APIs.

## API Service

An API service is the unit of management and deployment for the API node. Services are declared and prepared in the DSS API Designer and are then deployed on the API Deployer.

A single service can host several _endpoints_. All endpoints of a service are updated and managed at once.

## Endpoint

An endpoint is a single path on the API and is contained within an API Service. Each endpoint fulfills a single function.

The API node supports 7 kinds of endpoints:

  * The [Prediction or Clustering](<endpoint-std.html>) endpoint to predict or cluster using models created with the DSS Visual Machine Learning component.

  * The [Python prediction](<endpoint-python-prediction.html>) endpoint to perform predictions using a custom model developed in Python

  * The [MLflow Prediction](<endpoint-mlflow.html>) endpoint to predict using imported MLflow models

  * The [R prediction](<endpoint-r-prediction.html>) endpoint to perform predictions using a custom model developed in R

  * The [Python function](<endpoint-python-function.html>) endpoint to call specific functions developed in Python

  * The [R function](<endpoint-r-function.html>) endpoint to call specific functions developed in R

  * The [SQL query](<endpoint-sql-query.html>) endpoint to perform parametrized SQL queries

  * The [Dataset lookup](<endpoint-dataset-lookup.html>) endpoint to perform data lookups in one or more DSS datasets




An API service can host several endpoints. All endpoints of an API service are updated and managed at once. Having several endpoints in an API service is useful if you have several predictive models that are not mixable together, but you still want a unique management and access point.

## Version

API Services in DSS are versioned. You create new versions of the API Service using the API Designer in DSS. These versions are then sent to the API Deployer, where they become available to be deployed on the API Nodes.

The version of a single Deployment on the API Deployer can be changed without losing any query. After activating a new version, queries hitting the API node instance use the newer version of all models in the API service.

The API Deployer and API Nodes provide advanced management of version. The basic use case is when you have a single version of a service which is active (the newest, generally). However, you can also have several concurrent active versions. In that case, you define the probability of queries using each generation of the service and dispatch policies. Combined with the powerful logging capabilities, this lets you very easily create A/B testing strategies.

## Deployment Infrastructure

The API Deployer manages several independent pools of API nodes. This allows you for example to have one pool of API nodes for development, one for testing, one for production.

Each deployment infrastructure can either be:

  * A _static_ infrastructure: a set of pre-deployed API nodes that the API Deployer manages

  * A _Kubernetes_ infrastructure: the API Deployer dynamically creates containers in your Kubernetes cluster to run the API Node server.




The infrastructures are organized into _Lifecycle Stages_ (like “Development”, “Preproduction” and “Production”) that organize how your various deployments will be shown.

Each infrastructure has access permissions

## Deployment

In the API Deployer, the main object that you manage is called a _deployment_.

A deployment is made of a version (or set of versions) of a single API Service running on a single Deployment infrastructure.

You can dynamically change which version (or versions) of your API Service is running on each deployment (this version change happens without any service interruption). Each Deployment has one or several service URLs that the API clients need to use to query this deployment.

In essence, a Deployment acts as a scalable and highly-available _instance_ of an API service.

## Package

Packages are the physical representation of different versions of a service. Each time you want to update an API service (for example to use retrained models), you create a new package from the DSS interface.

The package is then transferred to the API node instances, and activated. A package contains all endpoints of a single API Service.

---

## [apinode/deploy-anywhere]

# Deploying to an external platform

This page will present the process to deploy a Dataiku API Service to a non-Dataiku ML platform, which we called ‘Deploy anywhere’.

Note

This section assumes that you already have installed and configured the DSS API Deployer, and already have an external infrastructure configured. Please see [Setting up the API Deployer and deployment infrastructures](<api-deployment-infrastructures.html>) if that’s not yet the case.

It also assumes that you are familiar with API Deployments. Please see [First API (with API Deployer)](<first-service-apideployer.html>) if this is not the case.

## Create the API Service

From any project on your design node, you need to create an API Service containing at least one endpoint. There are some limitations to the API Service in order to be compatible with External Deployments:

  * Only one endpoint will be accessible once deployed. So either you have a single endpoint or you will be requested to select one at deployment time (you can perfectly use the Dispatcher approach in this context, see [Developer Guide](<https://developer.dataiku.com/latest/concepts-and-examples/api-designer/inter-calling.html> "\(in Developer Guide\)"))

  * The following types of endpoints are supported: Standard Prediction, Clustering, Custom Prediction (Python) or Python Function

  * HTTP request metadata is available when using Custom Prediction (Python) or Python Function endpoints. For more information, refer to this [Developer Guide](<https://developer.dataiku.com/latest/concepts-and-examples/api-designer/request-metadata.html> "\(in Developer Guide\)")




Once created, add some test queries so that you can validate your deployment once done.

## Publish and Deploy

Before proceeding with the actual deployment, ensure your infrastructure is properly configured for Model Monitoring. Although optional, this will make the Model Monitoring very easy at the end. Model monitoring is based on the deployed endpoint sending its logs to a Dataiku Event Server. This configuration is done at the Infrastructure level, so you may need the assistance of an administrator. You also need to ensure the deployed endpoint will be allowed to access the event server which, in the case of External Deployments, might require specific network settings on the platform.

Once all is good, go back to your project and create a version of your API Service and publish it to API Deployer. On this version’s page, click on Deploy. You will be asked for the Deployment required information. Among them, If you have multiple endpoints, you will need to select the one to expose.

Once the deployment is actually started, you can follow the progress until all is done on Dataiku’s side and we are waiting for the External provider to finalize the activation of the endpoint (note that this operation may take some time, depending on the provider).

While the endpoint is under creation, it is showed in warning in API deployer, and it is not usable.

> You can click on Refresh until your endpoint is finally able to serve.

> As a final step, you can go to the ‘Run and test’ tab to validate it. And your endpoint is fully operational at this stage.

## Monitor

As a first step of Monitoring, all deployments are checked by Dataiku deployer for proper up status and whether the actual deployment is in sync with the expected setup in API Deployer. If the endpoint is not up, it will be displayed as an error. If the configuration has discrepancies, it will be displayed as a warning - ‘out-of-sync’.

A second step of monitoring is concerned with the model health. With the logging in place, all predictions made by the endpoint will be logged according to your Event Server configuration. You can then build a feedback loop based on this logs using the standard logic, as explained in [the Monitoring Tutorial on the Knowledge Base](<https://knowledge.dataiku.com/latest/deploy/model-monitoring/contexts/tutorial-index.html>).

---

## [apinode/dev-guide]

# Developer Guides

More concepts and examples can be found in these guides:

  * [API Designer](<https://developer.dataiku.com/latest/concepts-and-examples/api-designer/index.html> "\(in Developer Guide\)")

  * [API Deployer](<https://developer.dataiku.com/latest/concepts-and-examples/api-deployer.html> "\(in Developer Guide\)")

---

## [apinode/endpoint-dataset-lookup]

# Exposing a lookup in a dataset

The “dataset(s) lookup” endpoint offers an API for searching records in a DSS dataset by looking it up using lookup keys.

For example, if you have a “customers” dataset in DSS, you can expose a “dataset lookup” endpoint where you can pass in the email address and retrieve other columns from the matching customer.

A “dataset lookup” endpoint can:

  * lookup in multiple datasets at once

  * lookup multiple input records at once

  * lookup based on multiple lookup keys

  * retrieve arbitrary number of columns




However, note that each lookup can not return more than one dataset line for each input lookup records. Multiple results either generate an error or get dropped.

Note

The “dataset lookup” endpoint is very similar to the [feature to enrich prediction queries](<enrich-prediction-queries.html>) before passing them to a prediction model.

In essence the “Dataset lookup” endpoint is only the “Enrich” part of prediction endpoints

## Creating the lookup endpoint

To create a dataset lookup endpoint, start by creating an API service from the API Designer.

  * Go to the project homepage

  * Go to the API Designer and create a new service

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * At this point, the API Service is created but not yet have any endpoint, i.e. it does not yet expose any capability. See [Concepts](<concepts.html>) for what endpoints are.

  * Create a new endpoint of type “Dataset lookup”. Give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)




The URL to query the API will be like `/public/api/v1/<service_id>/<endpoint_id>/lookup`.

Validate, you are taken to the newly created API Service in the API Designer component.

### Configuration and deployment

Configuration, deployment options and specificities are the same as for the [feature to enrich prediction queries](<enrich-prediction-queries.html>) before passing them to a prediction model.

## Performance tuning

Whether you are using directly the API Node or the API Deployer, there are a number of performance tuning settings that can be used to increase the maximum throughput of the API node.

For the Dataset lookup endpoint, you can tune how many concurrent requests your API node can handle.

This configuration allows you to control the number of allocated pipelines. One allocated pipeline means one persistent connection to the database. If you have 2 allocated pipelines, 2 requests can be handled simultaneously, other requests will be queued until one of the pipelines is freed (or the request times out). When the queue is full, additional requests are rejected.

### Without API Deployer

Note

This method is not available on Dataiku Cloud.

You can configure the parallelism parameters for the endpoint by creating a JSON file in the `config/services` folder in the API node’s data directory.
    
    
    mkdir -p config/services/<SERVICE_ID>
    

Then create or edit the `config/services/<SERVICE_ID>/<ENDPOINT_ID>.json` file

This file must have the following structure and be valid JSON:
    
    
    {
        "pool" : {
            "floor" : 1,
            "ceil" : 8,
            "cruise": 2,
            "queue" : 16,
            "timeout" : 10000
        }
    }
    

Those parameters are all positive integers:

  * `floor` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `ceil` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `ceil ≥ floor`

  * `cruise` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `ceil`. But when all pending requests have been completed, the number of pipeline may go down to `cruise`. `floor ≤ cruise ≤ ceil`

  * `queue` (default: 16): The number of requests that will be queued when `ceil` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue wating for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise` around the expected maximal nominal query load.

### With API Deployer

You can configure the parallelism parameters for the endpoint in the Deployment settings, in the “Endpoints tuning” setting.

  * Go to the Deployment Settings > Endpoints tuning

  * Add a tuning block for your endpoint by entering your endpoint id and click Add

  * Configure the parameters




Those parameters are all positive integers:

  * `Pooling min pipelines` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `Pooling max pipelines` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `max pipelines ≥ min pipelines`

  * `Pooling cruise pipelines` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `max pipelines`. But when all pending requests have been completed, the number of pipeline may go down to `cruise pipelines`. `min pipelines ≤ cruise pipelines ≤ ceil pipelines`

  * `Pooling queue length` (default: 16): The number of requests that will be queued when `max pipelines` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `Queue timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue waiting for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise pipelines` around the expected maximal nominal query load.

---

## [apinode/endpoint-mlflow]

# Exposing a MLflow model

Note

See [Exposing a Visual Model](<endpoint-std.html>) to learn about exposing a visual model. Exposing a MLflow model relies on the same basis as a virtual model.

## Deploying the model

A MLflow model can be deployed using the API, as described in [Importing MLflow models](<../mlops/mlflow-models/importing.html>). It can also be deployed from an [Experiment Tracking](<../mlops/experiment-tracking/index.html>) run. See [Deploying MLflow models](<../mlops/experiment-tracking/deploying.html>) for more information.

## Exposing the model

Once deployed, a MLflow model can be exposed nearly like a visual model. Even so, the _MLflow Model output_ is to be set in the endpoint settings. It can be either _raw data_ or _restructured_. The first outputs directly what the MLflow model outputs while the second makes DSS try to restructure it (disable this in case of compatibility issues).

For example, a _SKLearn binary classification_ typically outputs a prediction probability. _Restructure_ enriches it to a prediction and probabilities for both label.

See [Using MLflow models in DSS](<../mlops/mlflow-models/using.html>).

---

## [apinode/endpoint-python-function]

# Exposing a Python function

You can expose any Python function as a endpoint on the API node. Calling the endpoint will call your function with the parameters you specify and return the results of the function.

This might look similar to the [Python prediction endpoint](<endpoint-python-prediction.html>), but there are a few key differences:

  * A Python prediction endpoint has a strict concept of input records, and output prediction. It must output a prediction, and thus can only be used for prediction-like use cases. In contrast, a Python function can do any kind of action and return any form of result (or even no result). For example, you can use a Python function endpoint to store data in a database, a file, …

  * Since there is no concept of input records, you cannot use the [dataset-based enrichment features](<enrich-prediction-queries.html>) in a Python function endpoint




## Creating the Python function endpoint

To create a Python function endpoint, start by creating an API service from the API Designer.

  * Go to the project homepage

  * Go to the API Designer and create a new service

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * At this point, the API Service is created but not yet have any endpoint, i.e. it does not yet expose any capability. See [Concepts](<concepts.html>) for what endpoints are.

  * Create a new endpoint of type “Python function”. Give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)




The URL to query the API will be like `/public/api/v1/<service_id>/<endpoint_id>/run`.

Validate, you are taken to the newly created API Service in the API Designer component.

DSS prefills the Code part with a sample

### Structure of the code

The code of a Python function endpoint must include at least one function, whose name must be entered in the “Settings” tab.

The parameters of the function will be automatically filled from the attributes of the object passed in the endpoint call. The function’s parameters list _need_ to be the same as the object’s attributes list.

For example if the object passed in the endpoint call has the following structure:
    
    
    {
       "age": 35,
       "days": 344,
       "price": 600
    }
    

Then the function’s signature must be the following:
    
    
    def my_api_function(age, days, price):
    

Since this can get quite tedious when the attribute’s list evolves or get too long, you can use the following workaround:
    
    
    def api_py_function(z=0, **data):
    

The result of the function must be JSON-serializable.

### Using managed folders

A Python function endpoint can optionally reference one or several DSS managed folders. When you package your service, the contents of the folders are bundled with the package, and your custom code receives the paths to the managed folder contents.

The paths to the managed folders (in the same order as defined in the UI) is available in a `folders` global variable which is transparently available in your code.

For example, the following code loads a pickle file from the 2nd managed folder at startup, and uses it in the `my_api_function` API function
    
    
    import cPickle as pickle
    import os.path
    
    folder_path = folders[1]
    file_path = os.path.join(folder_path, "mydata.pkl")
    
    with open(file_path) as f:
            data = pickle.load(f)
    
    def my_api_function(myparam):
            return data.do_something(myparam)
    

## Testing your code

Developing a custom function implies testing often. To ease this process, a “Development server” is integrated in the DSS UI.

To test your code, click on the “Deploy to Dev Server” button. The dev server starts and loads your function. You are redirected to the Test tab where you can see whether your function loads.

You can also define _Test queries_ , i.e. JSON objects akin to the ones that you would pass to the [API node user API](<api/user-api.html>). When you click on the “Play test queries” button, the test queries are sent to the dev server, and the result is printed.

## Python packages

We strongly recommend that you use code environments for deploying custom function packages if these packages use any external (not bundled with DSS) library.

### Using a code env (recommended)

Each custom endpoint can run within a given DSS [code environment](<../code-envs/index.html>).

The code environment associated to an endpoint can be configured in the “Settings” tab of the endpoint.

If your endpoint is associated to a code environment, when you package your service, DSS automatically includes the definition of the virtual environment in the package. When the API service is loaded in the API node, DSS automatically installs the code environment according to the required definition.

This allows you to use the libraries that you want for your custom model.

### Using the builtin env (not recommended)

If you use external libraries by installing them in the DSS builtin env, they are _not_ automatically installed in the API Node virtual env. Installing external packages in the API Node virtual env prior to deploying the package is the responsibility of the API node administrator.

Note that this means that:

  * Two endpoints in the same service may not use incompatible third-party libraries or versions of third-party libraries

  * If you need to have two services with incompatible libraries, you should deploy them on separate API node instances




## Performance tuning

Whether you are using directly the API Node or the API Deployer, there are a number of performance tuning settings that can be used to increase the maximum throughput of the API node.

For the Python function endpoint, you can tune how many concurrent requests your API node can handle. This depends mainly on what your function does (its speed and in-memory size) and the available resources on the server(s) running the API node.

One allocated pipeline means one Python process running your code, preloaded with your initialization code, and ready to serve a function request. If you have 2 allocated pipelines (meaning 2 Python processes), 2 requests can be handled simultaneously, other requests will be queued until one of the pipelines is freed (or the request times out). When the queue is full, additional requests are rejected.

Each Python process will only serve a single request at a time.

It is important to set the “Cruise parameter” (detailed below):

  * At a high-enough value to serve your expected reasonable peak traffic. If you set cruise too low, DSS will kill excedental Python processes, and will need to recreate a new one just afterwards.

  * But also at a not-too-high value, because each pipeline implies a running Python process consuming the memory required by the model.




### Without API Deployer

Note

This method is not available on Dataiku Cloud.

You can configure the parallelism parameters for the endpoint by creating a JSON file in the `config/services` folder in the API node’s data directory.
    
    
    mkdir -p config/services/<SERVICE_ID>
    

Then create or edit the `config/services/<SERVICE_ID>/<ENDPOINT_ID>.json` file

This file must have the following structure and be valid JSON:
    
    
    {
        "pool" : {
            "floor" : 1,
            "ceil" : 8,
            "cruise": 2,
            "queue" : 16,
            "timeout" : 10000
        }
    }
    

Those parameters are all positive integers:

  * `floor` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `ceil` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `ceil ≥ floor`

  * `cruise` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `ceil`. But when all pending requests have been completed, the number of pipeline may go down to `cruise`. `floor ≤ cruise ≤ ceil`

  * `queue` (default: 16): The number of requests that will be queued when `ceil` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue wating for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise` around the expected maximal nominal query load.

### With API Deployer

You can configure the parallelism parameters for the endpoint in the Deployment settings, in the “Endpoints tuning” setting.

  * Go to the Deployment Settings > Endpoints tuning

  * Add a tuning block for your endpoint by entering your endpoint id and click Add

  * Configure the parameters




Those parameters are all positive integers:

  * `Pooling min pipelines` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `Pooling max pipelines` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `max pipelines ≥ min pipelines`

  * `Pooling cruise pipelines` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `max pipelines`. But when all pending requests have been completed, the number of pipeline may go down to `cruise pipelines`. `min pipelines ≤ cruise pipelines ≤ ceil pipelines`

  * `Pooling queue length` (default: 16): The number of requests that will be queued when `max pipelines` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `Queue timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue waiting for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise pipelines` around the expected maximal nominal query load.

---

## [apinode/endpoint-python-prediction]

# Exposing a Python prediction model

In addition to standard models trained using the DSS Machine Learning component, the API node can also expose custom models written in Python by the user.

To write a “custom Python prediction” endpoint in an API node service, you must write a Python class that implements a `predict` method.

The custom model can optionally use a DSS managed folder. This managed folder is typically used to store the serialized version of the model. The code for the custom model is written in the “API service” part DSS.

## Creating the Python prediction endpoint

To create a Python Prediction endpoint, start by creating an API service from the API Designer.

  * Go to the project homepage

  * Go to the API Designer and create a new service

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * At this point, the API Service is created but not yet have any endpoint, i.e. it does not yet expose any capability. See [Concepts](<concepts.html>) for what endpoints are.

  * Create a new endpoint of type “Python Prediction”. Give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)




You will need to indicate whether you want to create a Regression (predicting a continuous value) or a Classification (predicting a discrete value) model.

The URL to query the API will be like `/public/api/v1/<service_id>/<endpoint_id>/predict`.

Validate, you are taken to the newly created API Service in the API Designer component.

DSS prefills the Code part with a sample depending on the selected model type.

### Using a managed folder

A custom model can optionally (but most of the time) use a DSS managed folder. When you package your service, the contents of the folder is bundled with the package, and your custom code receives the path to the managed folder content.

A typical usage is when you have a custom train recipe that dumps the serialized model into a folder. Your custom prediction code then uses this managed folder.

### Structure of the code

To create a custom model, you need to write a single Python class. This class must extend `dataiku.apinode.predict.predictor.ClassificationPredictor` or `dataiku.apinode.predict.predictor.RegressionPredictor`. The name of the class does not matter. DSS will automatically find your class.

The constructor of the class receives the path to the managed folder, if any.

#### Regression

A regression predictor must implement a single method: `def predict(self, features_df)`

This method receives a Pandas Dataframe of the input features. It must output one of the following forms:

  * `prediction_series`

  * `(prediction_series, custom_keys_list)`




Answer details:

  * `prediction_series` (mandatory): a Pandas Series of the predicted values. The output series must have the same number of rows as the input dataframe. If the model does not predict a row, it can leave `numpy.nan` in the output series.

  * `custom_keys_list` (optional, may be None): a Python list of dictionaries for each input row. Each list entry contains a dict of the customKeys that will be sent in the output (freely usable.)




The predict method must be able to predict multiple rows.

#### Classification

A classification predictor must implement a single method: `def predict(self, features_df)`

This method receives a Panda Dataframe of the input features.

It must output one of the following forms:

>   * `prediction_series`
> 
>   * `(prediction_series, probas_df)`
> 
>   * `(prediction_series, probas_df, custom_keys_list)`
> 
> 


Answer details:

  * `prediction_series` (mandatory): a Pandas Series of the predicted values. The output series must have the same number of rows as the input dataframe. If the model does not predict a row, it can leave `None` in the output series.

  * `probas_df` (optional, may be None): a Pandas Dataframe of the predicted probas. Must have one column per class, and the same number of rows as the input dataframe. If the model does not predict a row, it must leave `numpy.nan` in the probas dataframe.

  * `custom_keys_list` (optional, may be None): a Python list of dictionaries for each input row. Each list entry contains a dict of the customKeys that will be sent in the output (freely usable.)




The predict method must be able to predict multiple rows.

## Enriching queries features

See [Enriching prediction queries](<enrich-prediction-queries.html>).

## Testing your code

Developing a custom model implies testing often. To ease this process, a “Development server” is integrated in the DSS UI.

To test your code, click on the “Deploy to Dev Server” button. The dev server starts and loads your model. You are redirected to the Test tab where you can see whether your model loads.

You can then define _Test queries_ , i.e. JSON objects akin to the ones that you would pass to the [API node user API](<api/user-api.html>). When you click on the “Play test queries” button, the test queries are sent to the dev server, and the result is printed.

## Python packages and versions

We strongly recommend that you use code environments for deploying custom model packages if these packages use any external (not bundled with DSS) library

### Using a code env (recommended)

Each custom endpoint can run within a given DSS [code environment](<../code-envs/index.html>).

The code environment associated to an endpoint can be configured in the “Settings” tab of the endpoint.

If your endpoint is associated to a code environment, when you package your service, DSS automatically includes the definition of the virtual environment in the package. When the API service is loaded in the API node, DSS automatically installs the code environment according to the required definition.

This allows you to use the libraries and Python versions that you want for your custom model.

### Using the builtin env (not recommended)

If you use external libraries by installing them in the DSS builtin env, they are _not_ automatically installed in the API Node virtual env. Installing external packages in the API Node virtual env prior to deploying the package is the responsibility of the API node administrator.

Note that this means that:

  * Two endpoints in the same service may not use incompatible third-party libraries or versions of third-party libraries

  * If you need to have two services with incompatible libraries, you should deploy them on separate API node instances




### Available APIs in a custom model code

Note that, while the `dataiku.*` libraries are accessible, most of the APIs that you use in [Python recipes](<../code_recipes/python.html>) will not work: the code is not running with the DSS Design node, so datasets cannot be read by this API. If you need to enrich your features with data from your datasets, see [Enriching prediction queries](<enrich-prediction-queries.html>). If you need to access a Folder, see Using a managed folder above.

## Using your own libraries

You will sometimes need to write custom library functions (for example, shared between your custom training recipe and your custom model).

You can place these custom Python files in the project’s “libraries” folder, or globally in the `lib/python` folder of the DSS installation. Both recipes and custom models can import modules defined there.

When you package a service, the whole content of the `lib/python` folders (both project and instance) are bundled in the package. Note that this means that it is possible to have several generations of the service running at the same time, using different versions of the custom code from `lib/python`.

## Performance tuning

Whether you are using directly the API Node or the API Deployer, there are a number of performance tuning settings that can be used to increase the maximum throughput of the API node.

For the Python prediction endpoint, you can tune how many concurrent requests your API node can handle. This depends mainly on your model (its speed and in-memory size) and the available resources on the server(s) running the API node.

One allocated pipeline means one Python process running your code, preloaded with your initialization code, and ready to serve a prediction request. If you have 2 allocated pipelines (meaning 2 Python processes), 2 requests can be handled simultaneously, other requests will be queued until one of the pipelines is freed (or the request times out). When the queue is full, additional requests are rejected.

Each Python process will only serve a single request at a time.

It is important to set the “Cruise parameter” (detailed below):

  * At a high-enough value to serve your expected reasonable peak traffic. If you set cruise too low, DSS will kill excedental Python processes, and will need to recreate a new one just afterwards.

  * But also at a not-too-high value, because each pipeline implies a running Python process consuming the memory required by the model.




### Without API Deployer

Note

This method is not available on Dataiku Cloud.

You can configure the parallelism parameters for the endpoint by creating a JSON file in the `config/services` folder in the API node’s data directory.
    
    
    mkdir -p config/services/<SERVICE_ID>
    

Then create or edit the `config/services/<SERVICE_ID>/<ENDPOINT_ID>.json` file

This file must have the following structure and be valid JSON:
    
    
    {
        "pool" : {
            "floor" : 1,
            "ceil" : 8,
            "cruise": 2,
            "queue" : 16,
            "timeout" : 10000
        }
    }
    

Those parameters are all positive integers:

  * `floor` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `ceil` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `ceil ≥ floor`

  * `cruise` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `ceil`. But when all pending requests have been completed, the number of pipeline may go down to `cruise`. `floor ≤ cruise ≤ ceil`

  * `queue` (default: 16): The number of requests that will be queued when `ceil` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue wating for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise` around the expected maximal nominal query load.

### With API Deployer

You can configure the parallelism parameters for the endpoint in the Deployment settings, in the “Endpoints tuning” setting.

  * Go to the Deployment Settings > Endpoints tuning

  * Add a tuning block for your endpoint by entering your endpoint id and click Add

  * Configure the parameters




Those parameters are all positive integers:

  * `Pooling min pipelines` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `Pooling max pipelines` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `max pipelines ≥ min pipelines`

  * `Pooling cruise pipelines` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `max pipelines`. But when all pending requests have been completed, the number of pipeline may go down to `cruise pipelines`. `min pipelines ≤ cruise pipelines ≤ ceil pipelines`

  * `Pooling queue length` (default: 16): The number of requests that will be queued when `max pipelines` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `Queue timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue waiting for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise pipelines` around the expected maximal nominal query load.

---

## [apinode/endpoint-r-function]

# Exposing a R function

You can expose any R function as a endpoint on the API node. Calling the endpoint will call your function with the parameters you specify and return the results of the function.

This might look similar to the [R prediction endpoint](<endpoint-r-prediction.html>), but there are a few key differences:

  * An R prediction endpoint has a strict concept of input records, and output prediction. It must output a prediction, and thus can only be used for prediction-like use cases. In contrast, a R function can do any kind of action and return any form of result (or even no result). For example, you can use a R function endpoint to store data in a database, a file, …

  * Since there is no concept of input records, you cannot use the [dataset-based enrichment features](<enrich-prediction-queries.html>) in a R function endpoint




## Creating the R function endpoint

To create a R function endpoint, start by creating an API service from the API Designer.

  * Go to the project homepage

  * Go to the API Designer and create a new service

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * At this point, the API Service is created but not yet have any endpoint, i.e. it does not yet expose any capability. See [Concepts](<concepts.html>) for what endpoints are.

  * Create a new endpoint of type “R function”. Give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)




The URL to query the API will be like `/public/api/v1/<service_id>/<endpoint_id>/run`.

Validate, you are taken to the newly created API Service in the API Designer component.

DSS prefills the Code part with a sample.

### Structure of the code

The code of a R function endpoint must include at least one function, whose name must be entered in the “Settings” tab.

The parameters of the function will be automatically filled from the parameters passed in the endpoint call.

The result of the function must be JSON-serializable.

### Using managed folders

A R function endpoint can optionally reference one or several DSS managed folders. When you package your service, the contents of the folders are bundled with the package, and your custom code receives the paths to the managed folder contents.

The paths to the managed folders (in the same order as defined in the UI) is available by calling the `dkuAPINodeGetResourceFolders()` function. This function returns a vector of character vectors, each one being the absolute path to the folder.

## Testing your code

Developing a custom function implies testing often. To ease this process, a “Development server” is integrated in the DSS UI.

To test your code, click on the “Deploy to Dev Server” button. The dev server starts and load your model. You are redirected to the Test tab where you can see whether your model loads.

You can also define _Test queries_ , i.e. JSON objects akin to the ones that you would pass to the [API node user API](<api/user-api.html>). When you click on the “Play test queries” button, the test queries are sent to the dev server, and the result is printed.

## R packages and versions

We strongly recommend that you use code environments for deploying custom endpoints if these packages use any external (not bundled with DSS) library.

### Using a code env (recommended)

Each custom endpoint can run within a given DSS [code environment](<../code-envs/index.html>).

The code environment associated to an endpoint can be configured in the “Settings” tab of the endpoint.

If your endpoint is associated to a code environment, when you package your service, DSS automatically includes the definition of the virtual environment in the package. When the API service is loaded in the API node, DSS automatically installs the code environment according to the required definition.

This allows you to use the libraries and versions that you want for your custom model.

### Using the builtin env (not recommended)

If you use external libraries by installing them in the DSS builtin env, they are _not_ automatically installed in the API Node virtual env. Installing external packages in the API Node virtual env prior to deploying the package is the responsibility of the API node administrator.

Note that this means that:

  * Two endpoints in the same service may not use incompatible third-party libraries or versions of third-party libraries

  * If you need to have two services with incompatible libraries, you should deploy them on separate API node instances




### Available APIs in a custom model code

Note that, while the `dataiku.*` libraries are accessible, most of the APIs that you use in [R recipes](<../code_recipes/r.html>) will not work: the code is not running with the DSS Design node, so datasets cannot be read by this API. If you need to access DSS managed folders, see Using managed folders above.

## Using your own libraries

You will sometimes need to write custom library functions (for example, shared between your custom training recipe and your custom model).

You can place these custom files in the project’s “libraries” folder, or globally in the `lib/R` folder of the DSS installation. Both recipes and custom models can import modules defined there.

When you package a service, the whole content of the `lib/R` folders (both project and instance) are bundled in the package. Note that this means that it is possible to have several generations of the service running at the same time, using different versions of the custom code from `lib/R`.

## Performance tuning

Whether you are using directly the API Node or the API Deployer, there are a number of performance tuning settings that can be used to increase the maximum throughput of the API node.

For the R function endpoint, you can tune how many concurrent requests your API node can handle. This depends mainly on what your function does (its speed and in-memory size) and the available resources on the server(s) running the API node.

One allocated pipeline means one R process running your code, preloaded with your initialization code, and ready to serve a function request. If you have 2 allocated pipelines (meaning 2 R processes), 2 requests can be handled simultaneously, other requests will be queued until one of the pipelines is freed (or the request times out). When the queue is full, additional requests are rejected.

Each R process will only serve a single request at a time.

It is important to set the “Cruise parameter” (detailed below):

  * At a high-enough value to serve your expected reasonable peak traffic. If you set cruise too low, DSS will kill excedental R processes, and will need to recreate a new one just afterwards.

  * But also at a not-too-high value, because each pipeline implies a running R process consuming the memory required by the model.




### Without API Deployer

Note

This method is not available on Dataiku Cloud.

You can configure the parallelism parameters for the endpoint by creating a JSON file in the `config/services` folder in the API node’s data directory.
    
    
    mkdir -p config/services/<SERVICE_ID>
    

Then create or edit the `config/services/<SERVICE_ID>/<ENDPOINT_ID>.json` file

This file must have the following structure and be valid JSON:
    
    
    {
        "pool" : {
            "floor" : 1,
            "ceil" : 8,
            "cruise": 2,
            "queue" : 16,
            "timeout" : 10000
        }
    }
    

Those parameters are all positive integers:

  * `floor` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `ceil` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `ceil ≥ floor`

  * `cruise` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `ceil`. But when all pending requests have been completed, the number of pipeline may go down to `cruise`. `floor ≤ cruise ≤ ceil`

  * `queue` (default: 16): The number of requests that will be queued when `ceil` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue wating for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise` around the expected maximal nominal query load.

### With API Deployer

You can configure the parallelism parameters for the endpoint in the Deployment settings, in the “Endpoints tuning” setting.

  * Go to the Deployment Settings > Endpoints tuning

  * Add a tuning block for your endpoint by entering your endpoint id and click Add

  * Configure the parameters




Those parameters are all positive integers:

  * `Pooling min pipelines` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `Pooling max pipelines` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `max pipelines ≥ min pipelines`

  * `Pooling cruise pipelines` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `max pipelines`. But when all pending requests have been completed, the number of pipeline may go down to `cruise pipelines`. `min pipelines ≤ cruise pipelines ≤ ceil pipelines`

  * `Pooling queue length` (default: 16): The number of requests that will be queued when `max pipelines` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `Queue timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue waiting for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise pipelines` around the expected maximal nominal query load.

---

## [apinode/endpoint-r-prediction]

# Exposing a R prediction model

In addition to standard models trained using the DSS visual Machine Learning component, the API node can also expose custom models written in R by the user.

To write a “custom R prediction” endpoint in an API node service, you must write a R function that takes as input the features of the record to predict and that outputs the prediction.

The custom model can optionally use DSS managed folders. This managed folder is typically used to store the serialized version of the model. The code for the custom model is written in the “API service” part DSS.

## Creating the R prediction endpoint

To create a R Prediction endpoint, start by creating an API service from the API Designer.

  * Go to the project homepage

  * Go to the API Designer and create a new service

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * At this point, the API Service is created but not yet have any endpoint, i.e. it does not yet expose any capability. See [Concepts](<concepts.html>) for what endpoints are.

  * Create a new endpoint of type “Custom Prediction (R)”. Give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)




You will need to indicate whether you want to create a Regression (predicting a continuous value) or a Classification (predicting a discrete value) model.

The URL to query the API will be like `/public/api/v1/<service_id>/<endpoint_id>/predict`.

Validate, you are taken to the newly created API Service in the API Designer component.

DSS prefills the Code part with a sample depending on the selected model type.

### Using a managed folder

A custom model can optionally (but most of the time) use a DSS managed folder. When you package your service, the contents of the folder is bundled with the package, and your custom code receives the path to the managed folder content.

A typical usage is when you have a custom train recipe that dumps the serialized model into a folder. Your custom prediction code then uses this managed folder.

### Structure of the code

To create a custom model, you need to write a single R function. When you create your endpoint, DSS prefills the code with several sample functions that can all work as a R prediction model.

The function takes named arguments that are the features of the model. You may use default values if you expect some features not to be present.

In the “Settings” tab of your endpoint, you must select the name of the function that is your main predictor

In the R code, you can retrieve absolute paths to the resource folders using `dkuAPINodeGetResourceFolders()` (returns a vector of character)

#### Regression

A regression prediction function can return:

  * Either a single numerical representing the predicted class

  * Or a list containing:

>     * (mandatory) `prediction`: a single numerical representing the predicted class
> 
>     * (optional) `customKeys`: a list containing additional response keys that will be sent to the user




#### Classification

A classification prediction function can return:

  * Either a single character vector representing the predicted class

  * Or a list containing:

>     * (mandatory) `prediction`: a single character vector representing the predicted class
> 
>     * (optional) `probas`: a list of class -> probability
> 
>     * (optional) `customKeys`: a list containing additional response keys that will be sent to the user




## Enriching queries features

See [Enriching prediction queries](<enrich-prediction-queries.html>).

## Testing your code

Developing a custom model implies testing often. To ease this process, a “Development server” is integrated in the DSS UI.

To test your code, click on the “Deploy to Dev Server” button. The dev server starts and loads your model. You are redirected to the Test tab where you can see whether your model loads.

You can then define _Test queries_ , i.e. JSON objects akin to the ones that you would pass to the [API node user API](<api/user-api.html>). When you click on the “Play test queries” button, the test queries are sent to the dev server, and the result is printed.

## R packages

We strongly recommend that you use code environments for deploying custom model packages if these packages use any external (not bundled with DSS) library

### Using a code env (recommended)

Each custom endpoint can run within a given DSS [code environment](<../code-envs/index.html>).

The code environment associated to an endpoint can be configured in the “Settings” tab of the endpoint.

If your endpoint is associated to a code environment, when you package your service, DSS automatically includes the definition of the virtual environment in the package. When the API service is loaded in the API node, DSS automatically installs the code environment according to the required definition.

This allows you to use the libraries that you want for your custom model.

### Using the builtin env (not recommended)

If you use external libraries by installing them in the DSS builtin env, they are _not_ automatically installed in the API Node virtual env. Installing external packages in the API Node virtual env prior to deploying the package is the responsibility of the API node administrator.

Note that this means that:

  * Two endpoints in the same service may not use incompatible third-party libraries or versions of third-party libraries

  * If you need to have two services with incompatible libraries, you should deploy them on separate API node instances




## Performance tuning

Whether you are using directly the API Node or the API Deployer, there are a number of performance tuning settings that can be used to increase the maximum throughput of the API node.

For the R prediction endpoint, you can tune how many concurrent requests your API node can handle. This depends mainly on your model (its speed and in-memory size) and the available resources on the server(s) running the API node.

One allocated pipeline means one R process running your code, preloaded with your initialization code, and ready to serve a prediction request. If you have 2 allocated pipelines (meaning 2 R processes), 2 requests can be handled simultaneously, other requests will be queued until one of the pipelines is freed (or the request times out). When the queue is full, additional requests are rejected.

Each R process will only serve a single request at a time.

It is important to set the “Cruise parameter” (detailed below):

  * At a high-enough value to serve your expected reasonable peak traffic. If you set cruise too low, DSS will kill excedental R processes, and will need to recreate a new one just afterwards.

  * But also at a not-too-high value, because each pipeline implies a running R process consuming the memory required by the model.




### Without API Deployer

Note

This method is not available on Dataiku Cloud.

You can configure the parallelism parameters for the endpoint by creating a JSON file in the `config/services` folder in the API node’s data directory.
    
    
    mkdir -p config/services/<SERVICE_ID>
    

Then create or edit the `config/services/<SERVICE_ID>/<ENDPOINT_ID>.json` file

This file must have the following structure and be valid JSON:
    
    
    {
        "pool" : {
            "floor" : 1,
            "ceil" : 8,
            "cruise": 2,
            "queue" : 16,
            "timeout" : 10000
        }
    }
    

Those parameters are all positive integers:

  * `floor` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `ceil` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `ceil ≥ floor`

  * `cruise` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `ceil`. But when all pending requests have been completed, the number of pipeline may go down to `cruise`. `floor ≤ cruise ≤ ceil`

  * `queue` (default: 16): The number of requests that will be queued when `ceil` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue wating for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise` around the expected maximal nominal query load.

### With API Deployer

You can configure the parallelism parameters for the endpoint in the Deployment settings, in the “Endpoints tuning” setting.

  * Go to the Deployment Settings > Endpoints tuning

  * Add a tuning block for your endpoint by entering your endpoint id and click Add

  * Configure the parameters




Those parameters are all positive integers:

  * `Pooling min pipelines` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `Pooling max pipelines` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `max pipelines ≥ min pipelines`

  * `Pooling cruise pipelines` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `max pipelines`. But when all pending requests have been completed, the number of pipeline may go down to `cruise pipelines`. `min pipelines ≤ cruise pipelines ≤ ceil pipelines`

  * `Pooling queue length` (default: 16): The number of requests that will be queued when `max pipelines` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `Queue timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue waiting for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise pipelines` around the expected maximal nominal query load.

---

## [apinode/endpoint-sql-query]

# Exposing a SQL query

You can expose a parametrized SQL query as a DSS API node endpoint. Calling the endpoint with a set of parameters will execute the SQL query with these parameters.

The DSS API node automatically handles pooling connections to the database, high availability and scalability for execution of your query.

Note

Only “regular” SQL connections are possible. Hive and Impala are not supported.

Note

You’ll need to install the JDBC driver on the API node servers. The installation procedure is the same as for regular DSS design and automation nodes.

If you are using API Deployer on a Kubernetes infrastructure, this is handled automatically based on the JDBC drivers present in the API Deployer node

## Creating the SQL query endpoint

To create a SQL Query endpoint, start by creating an API service from the API Designer.

  * Go to the project homepage

  * Go to the API Designer and create a new service

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * At this point, the API Service is created but not yet have any endpoint, i.e. it does not yet expose any capability. See [Concepts](<concepts.html>) for what endpoints are.

  * Create a new endpoint of type “SQL Query”. Give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)




The URL to query the API will be like `/public/api/v1/<service_id>/<endpoint_id>/query`.

Validate, you are taken to the newly created API Service in the API Designer component.

DSS prefills the Code part with a sample In “Settings”, select the connection you want to target

In “Query”:

  * Write your query, using ‘?’ as the placeholder for parameters

  * Add one parameter name for each ? that you inserted in the query.




For example:
    
    
    select * from mytable where email = ?;
    
    Parameter names:
            * target_email
    

When you submit an API query with the “target_email” parameter set to “[test@test.com](</cdn-cgi/l/email-protection#b2c6d7c1c6949181858994918780899491868a89c6d7c1c69491868489d1dddf>)”, it will run the query `select * from mytable where email = 'test@test.com'` and return the results.

You must not surround the `?` markers by quotes, the database engine will handle that itself.

## Non-SELECT statements

It is possible to use non-SELECT statements (for example INSERT or DELETE). In that case, the result will not include columns and rows, but instead a `updatedRows` indicating how many rows were impacted by the query.

### Transaction commit

By default, DSS does not COMMIT the connection in a SQL query endpoint. You can activate the “post-commit” option to have DSS commit the connection after the execution of the query. This is required when using INSERT or DELETE statements.

## Using multiple queries

The code that you enter in the query field can include multiple SQL statements. For example, you could start by creating a temporary table, selecting from it and removing it. DSS automatically splits the query into statements.

However, the following rules apply:

  * Only the last SELECT statement will receive the parameters. It is not possible to “spread” the parameters over multiple statements.

  * If there is no SELECT statement, the last statement will receive the parameters.




Some complex use cases cannot fit these requirements, for example:

>   * Creating a temporary table using the parameters
> 
>   * Selecting from it, possibly using more parameters
> 
> 


For this, you can use multiple queries. Click on the “Add a query” button, and enter the second code and parameter names. Each query can have different parameters, but they can also use the same parameter: if you use the same parameter name in two different queries, both will use the same parameter from the REST API query.

All queries are executed within the same connection so temporary tables will persist. Commit happens after each query if you enable the “post-commit” option.

## Testing your queries

To ease the process of testing your endpoints, a “Development server” is integrated in the DSS UI.

To test your code, click on the “Deploy to Dev Server” button. The dev server starts and load your model. You are redirected to the Test tab where you can see whether your model loads.

You can then define _Test queries_ , i.e. JSON objects akin to the ones that you would pass to the [API node user API](<api/user-api.html>). When you click on the “Play test queries” button, the test queries are sent to the dev server, and the result is printed.

## Defining the connection on the API node

Note

This is not applicable for Kubernetes deployments using the API Deployer

Before you can activate your service on a API node, the API node must have the definition of the connection (with the same name as it was on the design node)

Add the connection in a top-level `remappedConnections` in the API node’s `DATA_DIR/config/server.json`:
    
    
    {
            "remappedConnections": {
                    "MY-CONNECTION": {
                            "type": "PostgreSQL",
                            "params": {
                                    "host": "my-db-host",
                                    "db": "my-db",
                                    "user": "my-user",
                                    "password": "my-password"
                            }
                    },
                    "MY-OTHER-CONNECTION": { "..." }
            },
            "..."
    }
    

The connection parameters to use can be found in the `config/connections.json` file in the DSS design or automation node. The password is encrypted on the design/automation node, you’ll need to retype it in the API node `DATA_DIR/config/server.json` file.

## Performance tuning

It is possible to tune the behavior of SQL query endpoints on the API node side. DSS maintains a pool of persistent connections to the database. These tuning settings are used to tune parameters of the connection pool to the database.

### Without API Deployer

You can configure this by creating a JSON file in the `config/services` folder in the API node’s data directory.
    
    
    mkdir -p config/services/<SERVICE_ID>
    

Then create or edit the `config/services/<SERVICE_ID>/<ENDPOINT_ID>.json` file

This file must have the following structure and be valid JSON (the values shown here are the defaults):
    
    
    {
        "sql" : {
            "connectionsEvictionTimeMS" : 60000,
            "evictionIntervalMS" : 30000,
            "maxPooledConnections": 10
        }
    }
    

Those parameters are all positive integers:

  * `connectionsEvictionTimeMS` (default: 60000): Connections that have not been used for that amount of time are closed

  * `evictionIntervalMS` (default: 30000): How often to check for connections that can be closed

  * `maxPooledConnections` (default: 10): Maximum number of connections that can be opened to the database




### With API Deployer

You can configure the connections pool parameters for the endpoint in the Deployment settings, in the “Endpoints tuning” setting.

  * Go to the Deployment Settings > Endpoints tuning

  * Add a tuning block for your endpoint by entering your endpoint id and click Add

  * Configure the parameters

  * `SQL eviction time` (default: 60000): Connections that have not been used for that amount of time are closed

  * `SQL eviction interval` (default: 30000): How often to check for connections that can be closed

  * `SQL max pool` (default: 10): Maximum number of connections that can be opened to the database

---

## [apinode/endpoint-std]

# Exposing a Visual Model

The primary function of the DSS API Deployer and API Node is to expose as an API a model trained using the [DSS visual machine learning component](<../machine-learning/index.html>).

The steps to expose a model are:

  * Train the model in Analysis

  * Deploy the model to Flow

  * Create a new API service

  * Create an endpoint using the saved model

  * Either:
    
    * Create a package of your API, deploy and activate the package on API nodes

    * Publish your service to the API Deployer, and use API Deployer to deploy your API




This section assumes that you already have a working API node and/or API Deployer setup. Please see [Setting up the API Deployer and deployment infrastructures](<api-deployment-infrastructures.html>) if that’s not yet the case.

## Creating the model

The first step is to create a model and deploy it to the Flow. This is done using the regular Machine Learning component of DSS. Please refer to the Tutorial 103 of DSS and to [Machine learning](<../machine-learning/index.html>) for more information.

## Create the API

There are two ways you can create your API Service

### Create the API directly from the Flow

  * In the Flow, select your model, and click “Create an API”

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * Within this API Service, give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)




The URL to query the API will be like:

  * `/public/api/v1/<service_id>/<endpoint_id>/predict` for prediction models

  * `/public/api/v1/<service_id>/<endpoint_id>/predict-effect` for causal prediction models

  * `/public/api/v1/<service_id>/<endpoint_id>/forecast` for time series forecasting models.




Validate, you are taken to the newly created API Service in the API Designer component.

### Create the API service then the endpoint

  * Go to the API Designer and create a new service

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * Create a new endpoint and give it an identifier. A service can contain multiple endpoints (to manage several models at once, or perform different functions)

  * Select the model to use for this endpoint. This must be a saved model (ie. a model which has been deployed to the Flow).




The URL to query the API will be like:

  * `/public/api/v1/<service_id>/<endpoint_id>/predict` for prediction models

  * `/public/api/v1/<service_id>/<endpoint_id>/predict-effect` for causal prediction models

  * `/public/api/v1/<service_id>/<endpoint_id>/forecast` for time series forecasting models.




Validate, you are taken to the newly created API Service in the API Designer component.

## Enriching queries features

See [Enriching prediction queries](<enrich-prediction-queries.html>).

## Testing your endpoint

It’s a good practice to add a few test queries to check that your endpoint is working as expected.

  * Go to test

  * Select add test queries. You can select a “test” dataset to automatically create test queries from the rows of this dataset

  * Click on “Run test queries”

  * You should see the prediction associated to each test query




Test queries are JSON objects akin to the ones that you would pass to the [API node user API](<api/user-api.html>). When you click on the “Play test queries” button, the test queries are sent to the dev server, and the result is printed.

### Prediction model

Each test query should look like this for a prediction model (both regular and causal):
    
    
    {
            "features" : {
                    "feature1" : "value1",
                    "feature2" : 42
            }
    }
    

For causal predictions, neither the outcome variable nor the treatment variable are expected.

### Time series forecasting model

For a time series forecasting model, you need to provide a list of past data. The model will forecast one horizon of data after the last date of the list.

For a single time series, the test query should look like this:
    
    
    {
            "items" : [
                    {
                            "dateFeature": "2022-01-01T00:00:00.000",
                            "targetFeature" : 10,
                    },
                    {
                            "dateFeature": "2022-01-02T00:00:00.000",
                            "targetFeature" : 12,
                    },
                    {
                            "dateFeature": "2022-01-03T00:00:00.000",
                            "targetFeature" : 11,
                    }
            ]
    }
    

For multiple time series, the test query should look like this:
    
    
    {
            "items" : [
                    {
                            "identifierFeature": "id1",
                            "dateFeature": "2022-01-01T00:00:00.000",
                            "targetFeature" : 10,
                    },
                    {
                            "identifierFeature": "id1",
                            "dateFeature": "2022-01-02T00:00:00.000",
                            "targetFeature" : 12,
                    },
                    {
                            "identifierFeature": "id2",
                            "dateFeature": "2022-01-01T00:00:00.000",
                            "targetFeature" : 1,
                    },
                    {
                            "identifierFeature": "id2",
                            "dateFeature": "2022-01-02T00:00:00.000",
                            "targetFeature" : 2,
                    }
            ]
    }
    

If your model uses external features, the test query must also contain their future values for one forecast horizon. For instance with a single time series it should look like this:
    
    
    {
            "items" : [
                    {
                            "dateFeature": "2022-01-01T00:00:00.000",
                            "targetFeature" : 10,
                            "externalFeature1" : "value1",
                            "externalFeature2" : 0
                    },
                    {
                            "dateFeature": "2022-01-02T00:00:00.000",
                            "targetFeature" : 12,
                            "externalFeature1" : "value2",
                            "externalFeature2" : 1
                    },
                    {
                            "dateFeature": "2022-01-03T00:00:00.000",
                            "targetFeature" : 11,
                            "externalFeature1" : "value2",
                            "externalFeature2" : 0
                    },
                    {
                            "dateFeature": "2022-01-04T00:00:00.000",
                            "externalFeature1" : "value1",
                            "externalFeature2" : 1
                    },
                    {
                            "dateFeature": "2022-01-05T00:00:00.000",
                            "externalFeature1" : "value2",
                            "externalFeature2" : 0
                    }
            ]
    }
    

## Deploying your service

Please see:

  * [First API (without API Deployer)](<first-service-manual.html>) (if you are not using API Deployer)

  * [First API (with API Deployer)](<first-service-apideployer.html>) (if you are using API Deployer)




## Optimized scoring

If your model is java-compatible (See: [Scoring engines](<../machine-learning/scoring-engines.html>)), you may select “Java scoring.” This will make the deployed model use java to score new records, resulting in extremely improved performance and throughput for your endpoint.

## Row-level explanations

The API node can provide per-row explanations of your models, using the ICE or Shapley methods. For more details about row-level explanations in Dataiku, please see [Individual prediction explanations](<../machine-learning/supervised/explanations.html>)

Explanations are not compatible with Optimized scoring.

You can either enable explanations by default for all predictions in the API designer, or request explanations on a per-query basis.

To request explanations, add this to your API request:
    
    
    {
            "features" : {
                    "feature1" : "value1",
                    "feature2" : 42
            },
            "explanations": {
                    "enabled": true,
                    "method": "SHAPLEY",
                    "nMonteCarloSteps": 100,
                    "nExplanations": 5
            }
    }
    

Explanations can also be requested through the Python client ([API node user API](<api/user-api.html>))

## Getting post-enrichment information

When using queries enrichment (see [Enriching prediction queries](<enrich-prediction-queries.html>)), it can be useful to view the complete set of features after enrichment.

You can ask DSS to:

  * Dump the post-enrichment information in the prediction response

  * Dump the post-enrichment information in the audit log




Both behaviors can be configured from the “Advanced” tab in the API designer

## Performance tuning

Whether you are using directly the API Node or the API Deployer, there are a number of performance tuning settings that can be used to increase the maximum throughput of the API node.

It is possible to tune the behavior of prediction endpoints on the API node side.

For the prediction endpoint, you can tune how many concurrent requests your API node can handle. This depends mainly on your model (its speed and in-memory size) and the available resources on the server(s) running the API node.

This configuration allows you to control the number of allocated pipelines. One allocated pipeline means one model loaded in memory that can handle a prediction request. If you have 2 allocated pipelines, 2 requests can be handled simultaneously, other requests will be queued until one of the pipelines is freed (or the request times out). When the queue is full, additional requests are rejected.

### Without API Deployer

Note

This method is not available on Dataiku Cloud.

You can configure the parallelism parameters for the endpoint by creating a JSON file in the `config/services` folder in the API node’s data directory.
    
    
    mkdir -p config/services/<SERVICE_ID>
    

Then create or edit the `config/services/<SERVICE_ID>/<ENDPOINT_ID>.json` file

This file must have the following structure and be valid JSON:
    
    
    {
        "pool" : {
            "floor" : 1,
            "ceil" : 8,
            "cruise": 2,
            "queue" : 16,
            "timeout" : 10000
        }
    }
    

Those parameters are all positive integers:

  * `floor` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `ceil` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `ceil ≥ floor`

  * `cruise` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `ceil`. But when all pending requests have been completed, the number of pipeline may go down to `cruise`. `floor ≤ cruise ≤ ceil`

  * `queue` (default: 16): The number of requests that will be queued when `ceil` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue wating for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise` around the expected maximal nominal query load.

### With API Deployer

You can configure the parallelism parameters for the endpoint in the Deployment settings, in the “Endpoints tuning” setting.

  * Go to the Deployment Settings > Endpoints tuning

  * Add a tuning block for your endpoint by entering your endpoint id and click Add

  * Configure the parameters




Those parameters are all positive integers:

  * `Pooling min pipelines` (default: 1): Minimum number of pipelines. Those are allocated as soon as the endpoint is loaded.

  * `Pooling max pipelines` (default: 8): Maximum number of allocated pipelines at any given time. Additional requests will be queued. `max pipelines ≥ min pipelines`

  * `Pooling cruise pipelines` (default: 2): The “nominal” number of allocated pipelines. When more requests come in, more pipelines may be allocated up to `max pipelines`. But when all pending requests have been completed, the number of pipeline may go down to `cruise pipelines`. `min pipelines ≤ cruise pipelines ≤ ceil pipelines`

  * `Pooling queue length` (default: 16): The number of requests that will be queued when `max pipelines` pipelines are already allocated and busy. The queue is fair: first received request will be handled first.

  * `Queue timeout` (default: 10000): Time, in milliseconds, that a request may spend in queue waiting for a free pipeline before being rejected.




Creating a new pipeline is an expensive operation, so you should aim `cruise pipelines` around the expected maximal nominal query load.

---

## [apinode/endpoints]

# Types of Endpoints

The API node supports several kinds of endpoints.

---

## [apinode/enrich-prediction-queries]

# Enriching prediction queries

The basic use case for the API node is fairly simple: send the features of a record, receive the prediction for this record.

However, there are many situations in which all features of an input record are not easily known by the API user. DSS API node includes a _data enrichment_ feature that makes these scenarios easy to handle.

## Use case

For example, consider the following case: we are creating a fraud detection engine for an e-commerce website. The model is trained using historical data from the users, orders, and products database, and labeled data from the fraud department.

The final dataset used to train the model contains:

  * Information about the “current” order

  * Information about the “current” payment method

  * Historical aggregated data about the customer: total number of orders, total value, number of payment modes, …

  * Aggregated data about the product in the order: category, number of previously fraudulent order for this product, …




Therefore, to score a new record, we need all this information. However, when the backend of the website (i.e. the caller of the API) wants to obtain the prediction, it only has access to the information about the current order and payment, not the historical aggregates of customer and product.

However:

  * the website backend has the `customer_id` and the `product_id` readily available.

  * the historical data aggregates are available in DSS.




By using the data enrichment feature of DSS API node, you can declare in the configuration of your endpoint an _enrichment_ of the records to predict by the `customer_data` and `product_data` tables.

  * The API caller sends the `customer_id` and the `product_id` values as features of the record

  * DSS API node looks these up in the `customer_data` and `product_data` tables

  * DSS API node replaces the customer_id and product_id by the data from the data tables.

  * The prediction can then happen normally




## Configuration

Note

This information is also valid for the [dataset lookup endpoint](<endpoint-dataset-lookup.html>)

Configuring data enrichments is made in the Endpoint > “Features mapping” section in DSS. Multiple enrichments are possible.

You must configure:

  * Which dataset is used for enrichment

  * How the dataset will be deployed for lookups (See the “Deployment options” section below)

  * How the lookup keys in the features of the records will be mapped to column lookups in the dataset

  * Which columns of the dataset will be retrieved and how they will be mapped to features in the record.




### Lookup mapping

Lookup keys definition is configured by selecting:

  * one or multiple column(s) forming a lookup key in the enrichment dataset

  * for each column of the key, their corresponding name in the query (in the case they must be different).




### Retrieved columns

Retrieval of columns as features in the record is configured by selecting:

  * the appropriate columns from the enrichment dataset

  * for each retrieved column, the name of the corresponding feature as expected by the model (in the case they are different).




### Error handling

You can configure how API node should react in various abnormal situations:

  * Unspecified key: the input record does not contain the lookup key(s)

  * No match: no row in the dataset matches the lookup key(s)

  * Several matches: multiple rows in the dataset match the lookup key(s)




## Deployment options

There are two possible deployment options for data enrichments.

### Bundled data

The “bundled data” mode is the simplest deployment mode and should generally be preferred when the lookup tables are fairly small (up to a few million lines).

In this mode:

  * _each_ DSS API node instance must have a private connection to a supported SQL database, see API Node Configuration below.

  * The contents of the dataset is copied in the package file when you create a new package

  * When you import a package to a DSS API node instance, the contents of the data from the package is copied to the private SQL database

  * The API node automatically uses the SQL database




The private SQL database is not part of the API node instance. You need to install a compatible database. Any SQL database supported by DSS can be used. However, we recommend to use databases that are well suited for random lookups i.e. not an analytics-oriented database.

Note that the database does not need to reside on the same host as the API node instance. It is, however, recommended to have both API node server and database server on the same host. This way, each physical server is fully independent, which reduces the failure mode and makes handling a down server easier.

### Referenced data

In this mode, the data for the lookup tables itself is not managed by the API node. Each API node instance must have in its settings the details for a DSS connection where the lookup data must be available.

This mode is only available for SQL datasets.

When you export a package from DSS, the package does _not_ contain the data. It only contains a _reference_ to the original dataset, ie a connection name and a table name.

Each API node instance has configuration that tells it how to connect to this connection name, see API Node Configuration below.

In almost all cases, the DB server queried by API node instances must not be the one used for preparing the Flow in DSS. You will therefore need to set up some kind of replication from the “original” data in a connection known by DSS to another “prod” database known by the API nodes.

Each API node can have its own definition of “where the database” is, by having different connection parameters. This allows you to actually have several database servers, and each API node querying one of them.

Note

If several (or all) API node servers have the same reference to the production database, it is important that this production database be itself highly available.

### API Node Configuration

Note

This does not apply to Kubernetes deployments using API Deployer

**Bundled data** requires the API node to have a private connection to an SQL database. In the API node’s `DATA_DIR/config/server.json`, add a top-level `bundledConnection` object:
    
    
    {
            "bundledConnection": {
                    "type": "PostgreSQL",
                    "params": {
                            "host": "my-db-host",
                            "db": "my-db",
                            "user": "my-user",
                            "password": "my-password"
                    }
            },
            "..."
    }
    

When testing bundled data in your services with the “Run test queries” button or the “Deploy to dev server” menu, the DSS administrator must first set a DSS SQL connection as the development server’s `bundledConnection` in the Administration > Settings > Deployer under “API Designer: Testing” section. Afterwards, make sure to Save the changes and restart the “Test server” for these changes to take effect on your local Dev server.

For **referenced data** , the API node must have _remapped_ connections whose names match those of the connections with which the package was created. Add these remapped connections in a top-level `remappedConnections` in the API node’s `DATA_DIR/config/server.json`:
    
    
    {
            "remappedConnections": {
                    "MY-SAMPLE-CONNECTION": {
                            "type": "PostgreSQL",
                            "params": {
                                    "host": "my-db-host",
                                    "db": "my-db",
                                    "user": "my-user",
                                    "password": "my-password"
                            }
                    },
                    "MY-OTHER-CONNECTION": { "..." }
            },
            "..."
    }

---

## [apinode/first-service-apideployer]

# First API (with API Deployer)

This page will guide you through the process of creating and deploying your first API service. For this example, we’ll use a [prediction endpoint](<endpoint-std.html>), used to expose a model developed using the [DSS visual machine learning component](<../machine-learning/index.html>) as a REST API service.

The steps to expose a prediction model are:

Warning

This section assumes that you already have installed and configured the DSS API Deployer, and already have an infrastructure connected to it. Please see [Setting up the API Deployer and deployment infrastructures](<api-deployment-infrastructures.html>) if that’s not yet the case.

## Create the model

The first step is to create a model and deploy it to the Flow. This is done using the regular Machine Learning component of DSS. Please refer to the [Machine Learning Basics](<https://knowledge.dataiku.com/latest/ml/model-design/ml-basics/tutorial-index.html>) and to [Machine learning](<../machine-learning/index.html>) for more information.

## Create the API Service

There are two ways you can create your API Service:

### Create the API directly from the Flow

Note

This method can only be used for prediction endpoints, and cannot be used for other kinds of endpoints

  * In the Flow, select your model, and click “Create an API”

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * Within this API Service, give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)




The URL to query the API will be like `/public/api/v1/<service_id>/<endpoint_id>/predict` for prediction models, and `/public/api/v1/<service_id>/<endpoint_id>/forecast` for time series forecasting models.

Click Append, and you are taken to the newly created API Service in the API Designer component.

### Create the API service then the endpoint in API Designer

  * Go to the project homepage

  * Go to the API Designer and create a new service

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * At this point, the API Service is created but not yet have any endpoint, i.e. it does not yet expose any model. See [Concepts](<concepts.html>) for what endpoints are.

  * Create a new endpoint of type “Prediction”. Give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)

  * Select the model to use for this endpoint. This must be a saved model (ie. a model which has been deployed to the Flow).




The URL to query the API will be like `/public/api/v1/<service_id>/<endpoint_id>/predict` for prediction models, and `/public/api/v1/<service_id>/<endpoint_id>/forecast` for time series forecasting models.

Click Append, and you are taken to the newly created API Service in the API Designer component.

For a simple service, that’s it! You don’t need any further configuration.

## (Optional) Add test queries

It’s a good practice to add a few test queries to check that your endpoint is working as expected, both in the API Designer and the API Deployer

  * Go to test queries

  * Select add test queries. You can select a “test” dataset to automatically create test queries from the rows of this dataset

  * Click on “Run test queries”

  * You should see the prediction associated to each test query




## Push a version to the API Deployer

Click on “Push to API Deployer”. This does two things:

  * It creates the first _Version_ (i.e. snapshot) of your API service using the currently active version of the saved model.

  * It pushes this version to the API Deployer, where it will create a new _Published Service_ on the API Deployer.




Click on the link that appears, which takes you to the API Deployer screen.

## Deploy your version

In the API Deployer, you now need to actually deploy your service to your infrastructure.

  * From the left column of the API Deployer, click on the version we just uploaded, and select “Deploy”

  * Select the infrastructure you wish to deploy to

  * Give an identifier to your deployment. This identifier will not appear in the URL

  * Validate




Your deployment is ready. You can either modify its settings, or Start it.

When you click on the “Deploy” (or the “Update”) button, DSS sends your API Service to the API nodes and activates it. When this process completes, you can see:

  * Public URLs from which your applications can query the service

  * Monitoring charts for your service (if enabled)

  * Sample code in various languages demonstrating how to query the service

  * Test queries for verifying the service’s behavior in the live environment

  * Stored update information, available in the **Last Updates** tab of the deployment




That’s it, you’ve now deployed your predictive model as an API!

## Perform real queries

Once you have confirmed that your service endpoint works, you can actually use the API to integrate in your application.

See [API node user API](<api/user-api.html>)

The API Deployer provides prebuilt code samples that you can directly use to query your API nodes.

## Next steps

Head over to the documentation page for each endpoint to get more information about how to use each one of them.

---

## [apinode/first-service-manual]

# First API (without API Deployer)

This page will guide you through the process of creating and deploying your first API service. For this example, we’ll use a [prediction endpoint](<endpoint-std.html>), used to expose as a REST API service a model developed using the [DSS visual machine learning component](<../machine-learning/index.html>).

The steps to expose a prediction model are:

This section assumes that you already have installed and started a DSS API node instance. Please see [Installing API nodes](<installing-apinode.html>) if that’s not yet the case.

## Create the model

The first step is to create a model and deploy it to the Flow. This is done using the regular Machine Learning component of DSS. Please refer to the [Machine Learning Basics](<https://knowledge.dataiku.com/latest/ml/model-design/ml-basics/tutorial-index.html>) and to [Machine learning](<../machine-learning/index.html>) for more information.

## Create the API Service

There are two ways you can create your API Service:

### Create directly from the Flow

Note

This method can only be used for prediction or clustering endpoints, and cannot be used for other kinds of endpoints.

  * In the Flow, select your model, then select “Create API” from the Actions panel

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * Within this API Service, give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)




The URL to query the API will be like `/public/api/v1/<service_id>/<endpoint_id>/predict` for prediction models, and `/public/api/v1/<service_id>/<endpoint_id>/forecast` for time series forecasting models.

Click Append, and you are taken to the newly created API Service in the API Designer component.

### Create the API service then the endpoint in API Designer

  * Go to the project homepage

  * Go to the API Designer and create a new service

  * Give an identifier to your API Service. This identifier will appear in the URL used to query the API

  * At this point, the API Service is created but does not yet have any endpoint; it does not yet expose any model. See [Concepts](<concepts.html>) for what endpoints are.

  * Create a new endpoint of type “Prediction”. Give an identifier to the endpoint. A service can contain multiple endpoints (to manage several models at once, or perform different functions)

  * Select the model to use for this endpoint. This must be a saved model (i.e. a model which has been deployed to the Flow).




The URL to query the API will be like `/public/api/v1/<service_id>/<endpoint_id>/predict` for prediction models, and `/public/api/v1/<service_id>/<endpoint_id>/forecast` for time series forecasting models.

Click Append, and you are taken to the newly created API Service in the API Designer component.

For a simple service, that’s it! You don’t need any further configuration.

## (Optional) Add test queries

It’s a good practice to add a few test queries to check that your endpoint is working as expected.

  * Go to Test queries

  * Select add test queries. You can select a “test” dataset to automatically create test queries from the rows of this dataset

  * Click on “Run test queries”

  * You should see the prediction associated with each test query




## Create a version and transfer the package

Now that your service is properly configured in DSS, the next step is to create a new version (i.e. snapshot), and to download the associated version package (See [Concepts](<concepts.html>)).

  * Click on the “Prepare package” button

  * DSS asks you for a package version number. This version number will be the identifier of this generation for all interactions with the API node. It is recommended that you use a meaningful short name like `v4-new-customer-features`. You want to be able to remember what was new in that generation (think of it as a Git tag)

  * Go to the packages tab.

  * Click on the Download button




The package file (a .zip file) is downloaded to your computer. Upload the zip file to each host running an API node.

## Create the service in the API node

Note

This method is not available on Dataiku Cloud.

We are now going to actually activate the package in the API node.

  * Go to the API node directory

  * Create the service: run the following command



    
    
    ./bin/apinode-admin service-create <SERVICE_ID>
    

  * Then, we need to _import_ the package zip file:



    
    
    ./bin/apinode-admin service-import-generation <SERVICE_ID> <PATH TO ZIP FILE>
    

Now, the API node has unzipped the package in its own folders, and is ready to start using it. At that point, however, the new generation is only _available_ , it’s not _active_. In other words, if we were to perform an API query, it would fail because no generation is currently active.
    
    
    ./bin/apinode-admin service-switch-to-newest <SERVICE_ID>
    

When this command returns, the API node service is now active, running on the latest (currently the only) generation of the package.

## Perform a test query

We can now actually perform a prediction. Query the following URL (using your browser for example):

`http://APINODE_SERVER:APINODE_PORT/public/api/v1/SERVICE_ID/ENDPOINT_ID/predict-simple?feat1=val1&feat2=val2`

where `feat1` and `feat2` are the names of features (columns) in your train set.

You should receive a JSON reply with a `result` section containing your prediction (and probabilities in case of a classification model).

## Perform real queries

Once you have confirmed that your service endpoint works, you can actually use the API to integrate in your application.

See [API node user API](<api/user-api.html>) for more information.

## Next steps

Head over to the documentation page for each type of endpoint to get more information about how to use each one of them.

---

## [apinode/index]

# API Node & API Deployer: Real-time APIs

Production deployments in DSS are managed from a central place: the Deployer. The Deployer is either available as a dedicated node or attached to a Design node. See [how to install the Deployer on your environment](<../deployment/setup.html>). The Deployer location is configured by administrator for the whole instance on each Design node in Administration > Settings > Deployer (this operation is automatically done if your are using Fleet Manager).

The Deployer has two separate but similar components, the Project Deployer and the API Deployer, that handle the deployment of projects and API services respectively. This section focuses on the latter. To know more about the Project Deployer, please refer to [Production deployments and bundles](<../deployment/index.html>).

In DSS Design and Automation nodes, you can create API services and deploy them to one or several API nodes, which are individual servers that do the actual job of answering REST API calls. The API Deployer allows you to:

  * As an administrator, define “API infrastructures”, each pointing to either already-installed API node(s), a Kubernetes cluster or a external ML deployment platform

  * As a user, deploy your API services on an infrastructure

  * For all, monitor the health and status of your deployed APIs

---

## [apinode/installing-apinode]

# Installing API nodes

You need to manually install one or several API Nodes:
    

  * If you want to create a static infrastructure in the API Deployer. See [Concepts](<concepts.html>) for more information.

  * If you don’t plan on using API Deployer




Note

If you plan to use Kubernetes-based infrastructures in the API Deployer, you do not need to install any API node. Installation will be fully managed. You can skip this page

Note

If you are using Dataiku Cloud stacks, installation is fully managed. You can skip this page.

Note

If you are using Dataiku Cloud, installation is fully managed. You only need to activate your API node in the Launchpad > Extension tab. You can skip this page.

Please see [Installing an API node](<../installation/custom/api-node.html>) for installation instructions

---

## [apinode/introduction]

# Introduction

You can define API services in Design and Automation nodes and push these services to the API Deployer. The API Deployer in turn deploys the services to one or several API nodes, which are individual servers that do the actual job of answering REST calls.

The main use case for API services is to expose predictive models through a REST API, but it can also expose other types of capabilities, known as **endpoints**. See the API services [Concepts](<concepts.html>) for more information.

## Exposing predictive models

By using DSS only, you can compute predictions for all records of an unlabeled dataset. Using the REST API of the DSS API deployer, you can request predictions for new previously-unseen records in real time.

The DSS API deployer provides high availability and scalability for scoring of records.

It can expose as API both:

  * “Regular” prediction models, trained using the visual DSS machine learning component

  * “Custom” prediction models, written in Python or R.




Thanks to its advanced features, the DSS API node is at the heart of the feedback and improvement loop of your predictive models:

  * Powerful logging and auditing capabilities

  * A/B testing and multi-version evaluation of models

  * User-aware version dispatch




## Exposing arbitrary Python and R functions

You can expose any Python or R function written in DSS as a endpoint on the API Deployer. Calling the endpoint will call your function with the parameters you specify and return the results of the function.

The DSS API Deployer provides automatic multithreading capabilities, high availability and scalability for execution of your function.

## Exposing SQL queries

You can expose a parametrized SQL query as a DSS API Deployer endpoint. Calling the endpoint with a set of parameters will execute the SQL query with these parameters.

The DSS API Deployer automatically handles pooling connections to the database, high availability and scalability for execution of your query.

## Performing lookups in datasets

The “Dataset lookup” endpoint allows you to fetch records from one or several DSS datasets, through a lookup in a SQL database.

The DSS API Deployer automatically handles pooling connections to the database, high availability and scalability for execution of your lookup.

## Querying the API nodes

The API nodes expose an HTTP REST API. For more information about this API, see [API node user API](<api/user-api.html>)

The API nodes themselves don’t have a UI but the API Deployer acts as a centralized administration and management platform.

## Designing APIs

Creation and preparation of endpoints used by the API Deployer is always done using DSS, in the _API Designer_ section of a project.

## Managing services and API nodes

The API node itself is a server application-only, it does not have an UI. The API deployer acts as the centralized administration server for managing a fleet of API nodes, and deploying new APIs to them. The API Deployer is also fully controllable through an API.

In addition, you can manage the API node directly through a REST API or a command-line tool. See [Using the apinode-admin tool](<operations/cli-tool.html>) and [API node administration API](<api/admin-api.html>). This feature is not available in Dataiku Cloud.

---

## [apinode/kubernetes/aks]

# Deployment on Azure AKS

You can use the API Deployer Kubernetes integration to deploy your API Services on Azure Kubernetes Service (AKS).

## Setup

### Create your ACR registry

Follow the Azure documentation on [how to create your ACR registry](<https://docs.microsoft.com/en-us/azure/container-registry/>). We recommend that you pay extra attention to the pricing plan since it is directly related to the registry storage capacity.

### Create your AKS cluster

Follow Azure’s documentation on [how to create your AKS cluster](<https://docs.microsoft.com/en-us/azure/aks/>). We recommend that you allocate at least 8GB of memory for each cluster node.

Once the cluster is created, you must modify its IAM credentials to [grant it access to ACR](<https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-aks#grant-aks-access-to-acr>) (Kubernetes secret mode is not supported). This is required for the worker nodes to pull images from the registry.

### Prepare your local `az`, `docker` and `kubectl` commands

Follow the Azure documentation to make sure that:

  * Your local (on the DSS machine) `az` command is properly logged in. As of October 2019, this implies running the `az login --service-principal --username client_d --password client_secret --tenant tenant_id` command. You must use a service principal that has sufficient IAM permissions to write to ACR and full control on AKS.

  * Your local (on the DSS machine) `docker` command can successfully push images to the ACR repository. As of October 2019, this implies running the `az acr login --name your-registry-name`.

  * Your local (on the DSS machine) `kubectl` command can interact with the cluster. As of October 2019, this implies running the `az aks get-credentials --resource-group your-rg --name your-cluster-name` command.




Note

Cluster management has been tested with the following versions of Kubernetes:
    

  * 1.23

  * 1.24

  * 1.25

  * 1.26

  * 1.27

  * 1.28

  * 1.29

  * 1.30

  * 1.31

  * 1.32

  * 1.33

  * 1.34

  * 1.35




There is no known issue with other Kubernetes versions.

### Setup the infrastructure

Follow the usual setup steps as indicated in [Setting up](<setup.html>). In particular, to set up the image registry, in the API Deployer go to Infrastructures > your-infrastructure > Settings, and in the “Kubernetes cluster” section, set the “Registry host” field to `your-registry-name.azurecr.io`.

### Deploy

You’re now ready to deploy your API Services to Azure AKS.

## Using GPUs

Azure provides GPU-enabled instances with NVIDIA GPUs. Several steps are required in order to use them for API Deployer deployments.

### Building an image with CUDA support

The base image that is built by default does not have CUDA support and cannot use NVidia GPUs.

CUDA support can be added to an image by:

  * installing CUDA system-wide (in `/usr/local/cuda/`) in the base image (see below)

  * installing CUDA system-wide in the code env image using container runtime additions

  * installing CUDA in the code env (in `/opt/dataiku/code-env/`) by requiring CUDA libraries (including `nvidia-cuda-runtime`)




To enable CUDA system-wide in the base image add the `--with-cuda` option to the command line:
    
    
    ./bin/dssadmin build-base-image --type apideployer --with-cuda

We recommend that you give this image a specific tag using the `--tag` option and keep the default base image “pristine”. We also recommend that you add the DSS version number in the image tag.
    
    
    ./bin/dssadmin build-base-image --type apideployer --with-cuda --tag dataiku-apideployer-base-cuda:X.Y.Z

where X.Y.Z is your DSS version number

Note

  * This image contains CUDA 11.8 and CuDNN 8.7 by default on AlmaLinux 9. You can use `--cuda-version X.Y` to specify another DSS-provided version (9.0, 10.0, 10.1, 10.2, 11.0, 11.2 and 11.8 are available on AlmaLinux 8, 11.8 only on AlmaLinux 9). If you require other CUDA versions, you have to create a custom image.

  * Depending on which CUDA version is installed in the base image you will need to use the [corresponding tensorflow version](<https://www.tensorflow.org/install/source#gpu>).




Warning

After each upgrade of DSS, you must rebuild all base images and [update code envs](<../../containers/code-envs.html>).

If you used a specific tag, go to the infrastructure settings, and in the “Base image tag” field, enter `dataiku-apideployer-base-cuda:X.Y.Z`

### Create a cluster with GPUs

Follow [Azure documentation](<https://docs.microsoft.com/en-us/azure/aks/gpu-cluster>) for how to create a cluster with GPU.

### Add a custom reservation

In order for your API Deployer deployments to be located on nodes with GPU devices, and for AKS to configure the CUDA driver on your containers, the corresponding AKS pods must be created with a custom “limit” (in Kubernetes parlance) to indicate that you need a specific type of resource (standard resource types are CPU and memory).

You can configure this limit either at the infrastructure level (all deployments on this infrastructure will use GPUs) or at the deployment level.

#### At the infrastructure level

  * Go to Infrastructure > Settings

  * Go to “Sizing and Scaling”

  * In the “Custom limits” section, add a new entry with key `nvidia.com/gpu` and value: `1` (to request 1 GPU)

  * Don’t forget to add the new entry, and save settings




#### At the deployment level

  * Go to Deployment > Settings

  * Go to “Sizing and Scaling”

  * Enable override of infrastructure settings in the “Container limits” section

  * In the “Custom limits” section, add a new entry with key `nvidia.com/gpu` and value: `1` (to request 1 GPU)

  * Don’t forget to add the new entry, and save settings




### Deploy

You can now deploy your GPU-requiring deployments.

This applies to:

  * Python functions (your endpoint needs to use a code environment that includes a CUDA-using package like tensorflow-gpu)

  * Python predictions

---

## [apinode/kubernetes/eks]

# Deployment on AWS EKS

You can use the API Deployer Kubernetes integration to deploy your API Services on AWS Elastic Kubernetes Service (EKS).

## Setup

### Create your EKS cluster

To create your Amazon Elastic Kubernetes Service (EKS) cluster, follow the [AWS user guide](<https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html>). We recommend that you allocate at least 7 GB of memory for each cluster node.

### Prepare your local `aws`, `docker`, and `kubectl` commands

Follow the [AWS documentation](<https://docs.aws.amazon.com/index.html?nc2=h_ql_doc_do_v>) to ensure the following on your local machine (where Dataiku DSS is installed):

  * The `aws ecr` command can list and create docker image repositories and authenticate `docker` for image push.

  * The `kubectl` command can create deployments and services on the cluster.

  * The `docker` command can successfully push images to the ECR repository.




Note

Cluster management has been tested with the following versions of Kubernetes:
    

  * 1.23

  * 1.24

  * 1.25

  * 1.26

  * 1.27

  * 1.28

  * 1.29

  * 1.30

  * 1.31

  * 1.32

  * 1.33

  * 1.34

  * 1.35




There is no known issue with other Kubernetes versions.

### Setup the infrastructure

Follow the usual setup steps as indicated in [Setting up](<setup.html>).

  * On EKS, the image registry URL is the one given by `aws ecr describe-repositories`, without the image name. It typically looks like `XXXXXXXXXXXX.dkr.ecr.us-east-1.amazonaws.com/PREFIX`, where `XXXXXXXXXXXX` is your AWS account ID, `us-east-1` is the AWS region for the repository and `PREFIX` is an optional prefix to triage your repositories.

  * Once you have filled the registry URL, the “Image pre-push hook” field becomes visible: set it to “Enable push to ECR”.




### Deploy

You are now ready to deploy your API Services to EKS.

## Using GPUs

AWS provides GPU-enabled instances with NVIDIA GPUs. Several steps are required in order to use them for API Deployer deployments.

### Building an image with CUDA support

The base image that is built by default does not have CUDA support and cannot use NVidia GPUs.

CUDA support can be added to an image by:

  * installing CUDA system-wide (in `/usr/local/cuda/`) in the base image (see below)

  * installing CUDA system-wide in the code env image using container runtime additions

  * installing CUDA in the code env (in `/opt/dataiku/code-env/`) by requiring CUDA libraries (including `nvidia-cuda-runtime`)




To enable CUDA system-wide in the base image add the `--with-cuda` option to the command line:
    
    
    ./bin/dssadmin build-base-image --type apideployer --with-cuda

We recommend that you give this image a specific tag using the `--tag` option and keep the default base image “pristine”. We also recommend that you add the DSS version number in the image tag.
    
    
    ./bin/dssadmin build-base-image --type apideployer --with-cuda --tag dataiku-apideployer-base-cuda:X.Y.Z

where X.Y.Z is your DSS version number

Note

  * This image contains CUDA 11.8 and CuDNN 8.7 by default on AlmaLinux 9. You can use `--cuda-version X.Y` to specify another DSS-provided version (9.0, 10.0, 10.1, 10.2, 11.0, 11.2 and 11.8 are available on AlmaLinux 8, 11.8 only on AlmaLinux 9). If you require other CUDA versions, you have to create a custom image.

  * Depending on which CUDA version is installed in the base image you will need to use the [corresponding tensorflow version](<https://www.tensorflow.org/install/source#gpu>).




Warning

After each upgrade of DSS, you must rebuild all base images and [update code envs](<../../containers/code-envs.html>).

If you used a specific tag, go to the infrastructure settings, and in the “Base image tag” field, enter `dataiku-apideployer-base-cuda:X.Y.Z`

### Create a cluster with GPUs

Follow [AWS documentation](<https://docs.aws.amazon.com/eks/latest/userguide/gpu-ami.html>) for how to create a cluster with GPU.

### Add a custom reservation

In order for your API Deployer deployments to be located on nodes with GPU devices, and for EKS to configure the CUDA driver on your containers, the corresponding EKS pods must be created with a custom “limit” (in Kubernetes parlance) to indicate that you need a specific type of resource (standard resource types are CPU and memory).

You can configure this limit either at the infrastructure level (all deployments on this infrastructure will use GPUs) or at the deployment level.

#### At the infrastructure level

  * Go to Infrastructure > Settings

  * Go to “Sizing and Scaling”

  * In the “Custom limits” section, add a new entry with key `nvidia.com/gpu` and value: `1` (to request 1 GPU)

  * Don’t forget to add the new entry, and save settings




#### At the deployment level

  * Go to Deployment > Settings

  * Go to “Sizing and Scaling”

  * Enable override of infrastructure settings in the “Container limits” section

  * In the “Custom limits” section, add a new entry with key `nvidia.com/gpu` and value: `1` (to request 1 GPU)

  * Don’t forget to add the new entry, and save settings




### Deploy

You can now deploy your GPU-requiring deployments.

This applies to:

  * Python functions (your endpoint needs to use a code environment that includes a CUDA-using package like tensorflow-gpu)

  * Python predictions

---

## [apinode/kubernetes/expositions]

# Service expositions

Once an API service is deployed in the cluster, there are pods running it and ready to serve HTTP requests on their port 12000. By design on Kubernetes, services running inside pods are not accessible from outside, where “outside” means “other pods in the cluster” and “anything outside the cluster”. To make it possible to reach the API service, one needs to setup [Kubernetes services](<https://kubernetes.io/docs/concepts/services-networking/service/>). The object through which you get DSS to create Kubernetes services is a service exposition, of which there are several types.

## Load balancer

A Load balancer exposition creates a service of type [LoadBalancer](<https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer>) in the cluster. Not all clusters offer a native LoadBalancer service, but cloud providers typically have one, where they provision a Load balancer inside their infrastructure and set it up to route requests from outside the cluster all the way to the pods.

## Cluster IP

A Cluster IP exposition creates a service of type [ClusterIP](<https://kubernetes.io/docs/concepts/services-networking/service/#type-clusterip>) in the cluster. The IP created by the Kubernetes service lives in the Kubernetes virtual network and is accessible from within the cluster only. This kind of service is mostly used to make the API service reachable by some other service or pod inside the cluster. In particular, this will not make it possible to query the API service from outside the cluster.

## Node Port

A Node Port exposition creates a service of type [NodePort](<https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport>) in the cluster. This Kubernetes service exposes the API service on a fixed port on the nodes of the cluster. Like Cluster IP, it’s mainly intended to make the API service accessible to other services or pods inside the cluster, not so much for making it available outside the cluster. You can reach it from outside the cluster only if you can reach the cluster nodes themselves.

## Ingress

An Ingress exposition creates a [Kubernetes Ingress](<https://kubernetes.io/docs/concepts/services-networking/ingress/>) in the cluster, and a Node Port service underneath (this is a technicality, as ingresses need a NodePort or ClusterIP service to actually access the pods). Ingresses are the recommended method for exposing services from pods, but they usually require some extra setup:

  * not all clusters have a default ingress controller, you may need to install one

  * some ingress controllers need a Load balancer to be provisioned at the infrastructure level

  * several ingresses can listen on the same load balancer and route to different API services, which requires careful handling of the ingresses’ parameters




DSS offers some variants of the base Ingress exposition when they’re available and DSS was notified of their existence:

  * Ingress (GKE) is available when there is a `cloud.provider -> gke` entry in the custom properties of the container configuration used. It is tailored for [the native ingress in GKE clusters](<https://cloud.google.com/kubernetes-engine/docs/concepts/ingress>).

  * Ingress (NGINX) is available when there is a `nginx-ingress.controller -> true` entry in the custom properties of the container configuration used. It is tailored for the [ingress controller built on top of NGINX](<https://kubernetes.github.io/ingress-nginx/>) which you can install in the clusters of most cloud providers.




The most versatile of the ingress expositions is the Ingress (NGINX) one, and in practice, the only recommended exposition when you wish to deploy several API services on the same IP or hostname.

### Ingress (NGINX)

To expose several API services on the same hostname/IP, assign a Ingress (NGINX) exposition to them, at the API deployment level or at the API infrastructure level. Then fill the **Service Path** field of the exposition with a different path for each API deployment, and tick the **Rewrite Path** checkbox.

Note

While the NGINX ingress controller can handle TLS termination, the recommended setup is to handle the TLS termination at the load balancer layer, so as to have the ingress controller only handle http:// requests.

### Variables

All expositions of the ingress kind can use variables in the **Service Path** field, in the annotations, and in the **Forced URL** field. These variables are used with the `${variable_name}` notation. In addition to the variables defined at the instance level, at the API infrastructure level and at the deployment level, several variables are available for use in API deployments:

  * `k8sDeploymentId` : the name of the Kubernetes deployment of the API deployment

  * `apiDeploymentId` and `k8sFriendlyApiDeploymentId` : the identifier of the API deployment

  * `infraId` and `k8sFriendlyInfraId` : the identifier of the API infrastructure

  * `publishedServiceId` and `k8sFriendlyPublishedServiceId` : the identifier of API service published by the API deployment

  * `deployedServiceId` and `k8sFriendlyDeployedServiceId` : the identifier of the deployed API service (= contents of the **API service id once deployed** field of the API deployment)




The variables that have a `k8sFriendlyXXXX` variant have values that can make them not suitable as Kubernetes labels or annotations or names, because they don’t follow the Kubernetes spec for these values. The `k8sFriendlyXXXX` variants are sanitized versions of the `XXXX` variable, and can be used in all fields of a Kubernetes object.

## Gateway API

The Kubernetes [Gateway API](<https://gateway-api.sigs.k8s.io>) is a close relative and a successor to the Ingress API. Roughly speaking, it splits the ingress resource in 2 parts: the gateway, which will be the entry point of the HTTP calls, and the http route which will wire the incoming HTTP calls to backend services in the cluster. You can use a Gateway API exposition in DSS to create a service, a http route, and optionally a gateway, so that calls reach the deployment.

Note

The Gateway API requires resources and resource types to be deployed in the K8S clusters, and few K8S cluster options have those deployed from the start. You may need to install one of the [implementations](<https://gateway-api.sigs.k8s.io/implementations/>) .

The Gateway API exposition offers 2 modes of operation:

  * when Gateway mode is set to “Create new gateway”, DSS creates a new gateway resource in the cluster, and the controller in the cluster will then create the necessary objects. The Gateway class field is mandatory, and its value depends on the gateway controller you use. When creating a gateway, you can add Listeners for different HTTP protocols and/or hosts.

  * when Gateway mode is set to “Use existing gateway”, DSS references the gateway you point it to in the http route. The referenced gateway can be in a different namespace from the pods of the deployment.




Independently on how the gateway object is found by the exposition, a HTTP route resource is then created, referencing that gateway. The HTTP route can have a **Path** which behaves like the **Service path** of ingress expositions. You can thus create a gateway, and reference it in several Gateway API expositions, provided that you use a different path for each.

Note

Like with ingress controllers, not all implementations of the Gateway API support path rewriting.

## Arbitrary yaml

This is the most versatile type of exposition. It lets you pass a yaml snippet to create objects in the cluster. The snippet can contain variables to aid in reusing the same snippet in several deployments, and the hostname/IP, port and path where DSS should find the deployed API service are defined in the yaml by means of hints in yaml comments.

Note

The objects defined in the arbitrary yaml are created by DSS with the same credentials that it uses to deploy the API service.

### Variables

In addition to the variables defined at the instance level, at the API infrastructure level and at the deployment level, several variables are available for use in the yaml snippet:

  * `executionId` : unique identifier for this run of the API deployment being deployed

  * `apiDeployerDeploymentId` : unique identifier for the API deployment being deployed

  * `namePrefix` : “dku-mad” in API deployments (“dku-webapp” in webapps)

  * `exposedPort` : port inside the container that needs to be exposed

  * `labels` : the DSS-generated K8S labels to associate to the API deployment being deployed (4-space padded)

  * `labelsJsonFields` : the DSS-generated K8S labels as a JSON-encoded map, without the surrounding curly braces

  * `labelsHeader` : use this to prefix the labels section. Empty if there are no K8S labels declared in the API deployment being deployed (2-space padded)

  * `labelsHeaderNoNewline` : if there are DSS-generated K8S labels, then this is a 2-space padded “labels:” string

  * `annotations` : annotations: K8S annotations declared in the API deployment being deployed. (4-space padded)

  * `annotationsJsonFields` : K8S annotations declared in the API deployment as a JSON-encoded map, without the surrounding curly braces

  * `annotationsHeader` : use this to prefix the annotations section. Empty if there are no K8S annotations declared in the API deployment being deployed (2-space padded)

  * `annotationsHeaderNoNewline` : if there are K8S annotations eclared in the API deployment, then this is a 2-space padded “annotations:” string

  * `selector` : K8S selector that will target the K8S deployment underlying the API deployment being deployed (4-space padded)

  * `selectorJsonFields` : K8S selector as a JSON-encoded map, without the surrounding curly braces

  * `selectorHeader` : a 2-spaces padded “selector:” line. Empty if the selector is empty

  * `selectorHeaderNoNewline` : 2-spaces padded “selector:” string. Empty if the selector is empty

  * `deployment:prop_name` : the value of the property prop_name on the API deployment being deployed




Important

The `executionId` or `apiDeployerDeploymentId` being unique identifiers for the API deployment being deployed, they should be used in the `metadata.name` field of the Kuberenetes objects deployed, so as to avoid conflicts.

### Extracting characteristics

Once the K8S objects are created, DSS needs to find them in the cluster in order to gather runtime information about them. A prime example of such information is the IP on which DSS should expect the API service to be exposed. For this to happen, you need to place hints inside the yaml snippet to flag lines where relevant information is located. These hints are put as fixed strings in comments. There are 4 cases:

  1. if the yaml is creating a service to expose the API deployment, add `# __exposed_service_id__` behind the metadata.name field of a K8S service object

  2. if the yaml is creating an ingress to expose the API deployment, add `# __exposed_ingress_id__` behind the metadata.name field of a K8S ingress object

  3. if the yaml is creating a gateway to expose the API deployment, add `# __exposed_gateway_id__` behind the metadata.name field of a K8S gateway object. In case the gateway is not in the same K8S namespace as the deployed service, add `# __exposed_gateway_namespace__` behind the field containing the namespace

  4. if the yaml is creating an http route to expose the API deployment, add `# __exposed_httproute_id__` behind the metadata.name field of a K8S http route object




When using an ingress or gateway, additional values can be passed:

  * the scheme for the URL that DSS should use can be pointed to by means of a `# __exposed_scheme__` hint

  * a path relative to the “scheme://host:port” can be passed with a `# __exposed_service_path__` hint

  * if the “scheme://host:port” that DSS can infer from inspecting the K8S objects at runtime is not expected to be correct, a fixed value can be pointed to with a `# __exposed_forced_url__` hint.




When using a ClusterIP service, normally DSS can’t access the deployment, because the ClusterIP service has an IP that is internal to the K8S cluster. But you can activate two modes of operation in DSS so that it can access the service:

  * to connect over an [endpoint slice](<https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/>) , add a `__use_endpoints__` after the `__exposed_service_id__`

  * open a port forward to the ClusterIP service’s IP, add a `__use_port_forward__` after the `__exposed_service_id__`




Additionally, if you need DSS to add specific HTTP headers when calling the service, you can add lines in the yaml using a `__proxied_header__` hint. For example to have DSS use a store.example.com value for the Host header, you can add:
    
    
    dku/header.Host: store.example.com  # __proxied_header__
    

All those hints apply to lines like:
    
    
    some-field: the-value # __the_hint__
    

If you need to pass a value to a hint, but there is no field in the yaml whose semantic meaning corresponds to the value, you can use a commented line like:
    
    
    # some-field: the-value # __the_hint__
    

### Examples

Exposing the API deployment with a load balancer provisioned by the cluster:
    
    
    apiVersion: v1
    kind: Service
    metadata:
      name: lb-${executionId} # __exposed_service_id__
      labels: { ${labelsJsonFields} }
      # add a load-balancer-type annotation on top of the DSS-computed annotations
      annotations: { ${annotationsJsonFields}, "cloud.google.com/load-balancer-type":"Internal" }
    spec:
      selector: { ${selectorJsonFields} }
      type: LoadBalancer
      ports:
      - port: ${exposedPort}
        targetPort: ${exposedPort}
        protocol: TCP
    

Exposing the API deployment with an ingress from a NGINX-ingress controller and a ClusterIP service (instead of NodePort like the Ingress exposition):
    
    
    apiVersion: v1
    kind: Service
    metadata:
      name: svc-${executionId}
      labels: { ${labelsJsonFields} }
      annotations: { ${annotationsJsonFields} }
    spec:
      selector: { ${selectorJsonFields} }
      type: ClusterIP
      ports:
      - port: 12000
        targetPort: 12000
        protocol: TCP
    
    ---
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: ing-${executionId} # __exposed_ingress_id__
      labels: { ${labelsJsonFields} }
      annotations: { ${annotationsJsonFields}, "kubernetes.io/ingress.class":"nginx", "nginx.ingress.kubernetes.io/rewrite-target":"/$2" }
    spec:
      rules:
      - http:
          paths:
          # use a commented property to pass the service path to DSS
          # service-path: /my-subpath/to/the-service # __exposed_service_path__
          - path: /my-subpath/to/the-service(/|$)(.*)
            backend:
              service:
                name: svc-${executionId}
                port:
                  number: 12000
            pathType: ImplementationSpecific
    

## Port forwarding

This exposition doesn’t create a Kubernetes service at all, and instead creates port forwarding processes from the DSS machine to the pods. The API service is then accessible locally on the the DSS machine (on 127.0.0.1). This exposition isn’t intended to be used to make API services available outside the cluster.

---

## [apinode/kubernetes/gke]

# Deployment on Google Kubernetes Engine

You can use the API Deployer Kubernetes integration to deploy your API Services on Google Kubernetes Engine.

## Setup

### Create your GKE cluster

Follow Google documentation on how to create your cluster. We recommend that you allocate at least 7 GB of memory for each cluster node.

### Prepare your local `docker` and `kubectl` commands

Follow Google documentation to make sure that:

  * Your local (on the DSS machine) `kubectl` command can interact with the cluster. As of July 2018, this implies running `gcloud container clusters get-credentials <cluster_id>`

  * Your local (on the DSS machine) `docker` command can successfully push images to your GAR repository. As of March 2025, this implies running `gcloud auth configure-docker`




Note

Cluster management has been tested with the following versions of Kubernetes:
    

  * 1.23

  * 1.24

  * 1.25

  * 1.26

  * 1.27

  * 1.28

  * 1.29

  * 1.30

  * 1.31

  * 1.32

  * 1.33

  * 1.34

  * 1.35




There is no known issue with other Kubernetes versions.

### Setup the infrastructure

Follow the usual setup steps as indicated in [Setting up](<setup.html>).

Make sure you have Google Artifact Registry (GAR) set up with a repository in your project. We recommend that it be specific to API Deployer. It will be used to prefix your image paths.

For example, if your GCP project is called `my-gke-project` and you have a GAR repository called `my-repository`, all images must be prefixed by `my-gke-project/my-repository/`.

  * Go to the infrastructure settings > Kubernetes cluster

  * In the Registry host field, enter the region’s artifact registry hostname `<region>-docker.pkg.dev`

  * In the images prefix field, enter `my-gke-project/my-repository`




### Deploy

You’re now ready to deploy your API Services to GKE

## Using GPUs

Google Cloud Platform provides GPU-enabled instances with NVidia GPUs. Several steps are required in order to use them for API Deployer deployments

### Building an image with CUDA support

The base image that is built by default does not have CUDA support and cannot use NVidia GPUs.

CUDA support can be added to an image by:

  * installing CUDA system-wide (in `/usr/local/cuda/`) in the base image (see below)

  * installing CUDA system-wide in the code env image using container runtime additions

  * installing CUDA in the code env (in `/opt/dataiku/code-env/`) by requiring CUDA libraries (including `nvidia-cuda-runtime`)




To enable CUDA system-wide in the base image add the `--with-cuda` option to the command line:
    
    
    ./bin/dssadmin build-base-image --type apideployer --with-cuda

We recommend that you give this image a specific tag using the `--tag` option and keep the default base image “pristine”. We also recommend that you add the DSS version number in the image tag.
    
    
    ./bin/dssadmin build-base-image --type apideployer --with-cuda --tag dataiku-apideployer-base-cuda:X.Y.Z

where X.Y.Z is your DSS version number

Note

  * This image contains CUDA 11.8 and CuDNN 8.7 by default on AlmaLinux 9. You can use `--cuda-version X.Y` to specify another DSS-provided version (9.0, 10.0, 10.1, 10.2, 11.0, 11.2 and 11.8 are available on AlmaLinux 8, 11.8 only on AlmaLinux 9). If you require other CUDA versions, you have to create a custom image.

  * Depending on which CUDA version is installed in the base image you will need to use the [corresponding tensorflow version](<https://www.tensorflow.org/install/source#gpu>).




Warning

After each upgrade of DSS, you must rebuild all base images and [update code envs](<../../containers/code-envs.html>).

If you used a specific tag, go to the infrastructure settings, and in the “Base image tag” field, enter `dataiku-apideployer-base-cuda:X.Y.Z`

### Create a cluster with GPUs

Follow GCP’s documentation for how to create a cluster with GPU accelerators (Note: you can also create a GPU-enabled node group in an existing cluster)

Don’t forget to run the “daemonset” installation procedure. This procedure needs several minutes to complete.

### Add a custom reservation

In order for your API Deployer deployments to be located on nodes with GPU accelerators, and for GKE to configure the CUDA driver on your containers, the corresponding GKE pods must be created with a custom “limit” (in Kubernetes parlance) to indicate that you need a specific type of resource (standard resource types are CPU and memory)

You can configure this limit either at the infrastructure level (all deployments on this infrastructure will use GPUs) or at the deployment level.

#### At the infrastructure level

  * Go to Infrastructure > Settings

  * Go to “Sizing and Scaling”

  * In the “Custom limits” section, add a new entry with key: `nvidia.com/gpu` and value: `1` (to request 1 GPU)

  * Don’t forget to add the new entry, save settings




#### At the deployment level

  * Go to Deployment > Settings

  * Go to “Sizing and Scaling”

  * Enable override of infrastructure settings in the “Container limits” section

  * In the “Custom limits” section, add a new entry with key: `nvidia.com/gpu` and value: `1` (to request 1 GPU)

  * Don’t forget to add the new entry, and save settings




### Deploy

You can now deploy your GPU-requiring deployments

This applies to:

  * Python functions (your endpoint needs to use a code environment that includes a CUDA-using package like tensorflow-gpu)

  * Python predictions (ditto)

---

## [apinode/kubernetes/index]

# Deploying on Kubernetes

Using the API Deployer, you can deploy your API services to a Kubernetes cluster.

Each API Service Deployment (see [Concepts](<../concepts.html>)) is setup on Kubernetes as:

  * A _Kubernetes deployment_ made of several _replicas_ of a single pod

  * A _Kubernetes service_ to expose a publicly available URL which applications can use to query your API

---

## [apinode/kubernetes/minikube]

# Deployment on Minikube

Warning

Minikube provides a “toy” Kubernetes cluster that is not suitable for anything beyond simple experimentation.

**Not supported** : Minikube is a [Not supported](<../../troubleshooting/support-tiers.html>) feature

You can use the API Deployer Kubernetes integration to deploy your API Services on Minikube clusters.

A minikube cluster doesn’t have an image repository. Instead, we’ll use the Docker daemon running within the minikube VM directly, and completely skip the “push to image repository” phase.

## Setup

### Create the base image

In order to create the base image directly in the Docker daemon running within the minikube VM, you need to run the following command in the same shell that will build your base image:
    
    
    eval `minikube docker-env`
    

Your session should look like:
    
    
    eval `minikube docker-env`
    ./bin/dssadmin build-base-image --type apideployer
    

### Start DSS with proper env

In order to use the Docker daemon running within the minikube VM, you need to start DSS after running:
    
    
    eval `minikube docker-env`
    

You can do that at the command line:
    
    
    eval `minikube docker-env`
    ./bin/dss start
    

Alternatively, you can add the following line to `bin/env-site.sh` (you must restart DSS after)

Follow Google documentation on how to create your cluster. We recommend that you allocate at least 7 GB of memory for each cluster node.

## Configure infrastructure

The default “LoadBalancer” mode for service exposition is not usable for minikube. Instead, you need to use “ClusterIP”

  * Go to Infrastructure > Settings

  * Go to Service Exposition

  * Set ClusterIP as the exposition mode

---

## [apinode/kubernetes/setup]

# Setting up

## Prerequisites

Warning

API Deployer is not responsible for starting and managing your Kubernetes cluster, which must already exist.

The prerequisites for deploying API services on Kubernetes are:

  * You need to have an existing Kubernetes cluster. The “kubectl” command on the API Deployer node must be fully functional and usable by the user running DSS.

  * The local “docker” command must be usable by the user running DSS. That includes the permission to build images, and thus access to a Docker socket

  * You need to have an image registry, accessible by your Kubernetes cluster

  * The local “docker” command must have permission to push images to your image registry




## Limitations

  * The MacOS installation of DSS does not support Kubernetes

  * API services using conda-based code environments are not supported

  * Your DSS machine must have direct outgoing Internet access in order to install packages

  * Your containers must have direct outgoing Internet access in order to install packages




## Build the base image

Before you can deploy to Kubernetes, a “base image” must be constructed. Each API Deployer deployment will then create a final Docker image made of:

  * The base image

  * An additional layer containing the API Service data and settings




Each Deployment infrastructure on the API Deployer can use a different base image. If you don’t configure anything specific, all infrastructures will use a default base image.

Warning

After each upgrade of DSS, you must rebuild all base images

From the DSS Datadir, run
    
    
    ./bin/dssadmin build-base-image --type api-deployer
    

For more details on building base images and customizing base images, please see [Initial setup](<../../containers/setup-k8s.html>) and [Customization of base images](<../../containers/custom-base-images.html>).

## Create the Kubernetes infrastructure in DSS

  * Go to API Deployer > Infrastructures

  * Create a new infra with type Kubernetes

  * Go to Settings > Kubernetes cluster




The elements you may need to customize are:

  * Kubectl context: if your kubectl configuration file has several contexts, you need to indicate which one DSS will target - this allows you to target multiple Kubernetes cluster from a single API Deployer by using several kubectl contexts

  * Kubernetes namespace: all elements created by DSS in your Kubernetes cluster will be created in that namespace

  * Registry host

---

## [apinode/kubernetes/sql-connections]

# Managing SQL connections

In order to use a Kubernetes deployment with:

  * SQL query endpoints

  * Dataset lookup endpoints

  * Query enrichments in prediction endpoints




You need to setup the SQL connections that these endpoints will use. You need to declare the connection settings _as seen from the Kubernetes cluster_. You may need to pay special attention to firewall and authorization rules

## Configuring the connection used for storage of bundled data

NB: this is not applicable to SQL Query endpoints

Please see [Enriching prediction queries](<../enrich-prediction-queries.html>) for more information

  * Go to Infrastructure > Settings > Connections

  * Fill in the “Connection for bundled” field with a DSS connection definition.

  * In this UI, you can select an existing connection (defined on the API Deployer node). This will copy the definition to clipboard, which you can then paste into the definition field




Note

You must replace encrypted passwords by a decrypted version. Password encryption is not supported in Kubernetes deployments at the moment. It is not currently possible to hide the passwords in this screen

## Configuring the “referenced” connections

Please see [Enriching prediction queries](<../enrich-prediction-queries.html>) for more information

  * Go to Infrastructure > Settings > Connections

  * Enter the name of the connection as it is defined in the API Designer

  * Add and fill the definition field with a DSS connection definition.

  * In this UI, you can select an existing connection (defined on the API Deployer node). This will copy the definition to clipboard, which you can then paste into the definition field




Note

You must replace encrypted passwords by a decrypted version. Password encryption is not supported in Kubernetes deployments at the moment. It is not currently possible to hide the passwords in this screen

---

## [apinode/managing_versions]

# Managing versions of your endpoint

## Updating and activating endpoint versions

The page [First API (without API Deployer)](<first-service-manual.html>) explains how to import a package containing an updated version of your endpoint.

To activate the latest version of your endpoint, use the command:
    
    
    ./bin/apinode-admin service-switch-to-newest <SERVICE_ID>
    

## Running multiple versions at once

Endpoints can serve multiple versions simultaneously, you just need to specify the probability each version has to be used for scoring a query.

Note

This feature can be used to run some A/B testing of your machine learning models.

The API node log of queries will store which version of your endpoint was used, see [Logging in DSS](<../operations/logging.html>) for more information about logging.

The mapping of versions/probabilities is defined by a JSON containing entries with `generations` and `proba` properties.
    
    
    {"entries":
            [
                    {"generation": "v1",
                     "proba": 0.5
                    },
                    {"generation": "v2",
                     "proba": 0.5
                    }
            ]
    }
    

Note

Probabilities must sum to 1.

The mapping is read from std_in by the command `service-set-mapping`, example usage:
    
    
    echo '{"entries":
            [
                    {"generation": "v1",
                     "proba": 0.5
                    },
                    {"generation": "v2",
                     "proba": 0.5
                    }
            ]
    }' | ./bin/apinode-admin service-set-mapping <SERVICE_ID>
    

## Monitoring version activation

In order to know which versions of an endpoint are currently served by the API and their associated probabilities, you can use the command:
    
    
    ./bin/apinode-admin service-list-generations <SERVICE_ID>

---

## [apinode/operations/cli-tool]

# Using the apinode-admin tool

A DSS API node deployment includes a command-line tool to manage the API node: `./bin/apinode-admin`

Almost all administration operations can be performed using this command-line tool running locally on the DSS API node server.

Note

This method is not available on Dataiku Cloud.

Note

API node administration can also be performed (including remotely) through the REST Admin API or its Python client. See [API node administration API](<../api/admin-api.html>) for more information.

The general syntax is:
    
    
    ./bin/apinode-admin COMMAND COMMAND_ARGS
    

  * Running `./bin/apinode-admin -h` lists the available commands

  * Running `./bin/apinode-admin COMMAND -h` prints the help for COMMAND




The main commands of the apinode-admin tool are:

## Commands to manage the list of services

  * `services-list`

  * `service-create`

  * `service-delete`




## Commands to manage the on-disk generations of a service

  * `service-import-generation`

  * `service-list-generations`




## Commands to manage the activation of generations

  * `service-switch-to-newest`

  * `service-switch-to-generation`

  * `service-set-mapping` (Command to set a multi-version service. See [Managing versions of your endpoint](<../managing_versions.html>))

  * `service-enable`

  * `service-disable`




## Commands for administration API keys management

  * `admin-keys-list`

  * `admin-key-create`

  * `admin-key-delete`




## Other commands

  * `metrics-get`

  * `predict`

---

## [apinode/operations/ha-deployment]

# High availability and scalability

DSS API node is natively highly available and scalable. Both high availability and scalability are achieved by deploying multiple instances of the API node.

Each DSS API Node instance is fully independent. A client of the API can query any API node instance.

It is recommended that you read how services are created and deployed first: [Introduction](<../introduction.html>)

## HA deployment

A standard deployment of high availability for API node includes:

  * Deploying several instances of the API node software on separate machines

  * Transfering new packages on all API node servers

  * Activating new versions of the packages on all API node servers

  * Using a client-side high availability mechanism




Two main mechanisms exist for client-side HA handling:

  * Using a load balancer

  * Using client-side dispatch / retry / fallback




### Load balancer

With a load balancer (either hardware, like F5, software like HAProxy, or cloud like AWS ELB), you add a layer in front of all your API node instances. The load balancer (which is itself highly available) receives the queries, dispatches them to all API node instances that are currently available.

The load balancer continuously monitors the API node instances to know which ones are healthy and which ones are not. To know more about the monitoring probe built-in in the API node, see [Health monitoring](<health-monitoring.html>).

You’ll need to refer to the documentation of your load balancer to know how to configure it to provide high availability for API node.

### Client-side dispatch

The load balancer solution has the main advantage that it is transparent from the clients. The client simply queries the load balancer URL and automatically gets a highly available and scalable service.

There are drawbacks, though. A truly HA load balancer solution is fairly costly and complex to deploy.

Since API node queries are “side-effect-free”, it is also possible to have the client perform the dispatching, and retry of queries. This makes for a slightly more complex client code. Furthermore, the client needs to know all URLs of all API node instances, which can make it more cumbersome to deploy additional API node instances (to provide for an increase in traffic).

## Zero-downtime generation update

Activating a new generation of a service on an API node does not create any loss of queries. Existing queries will continue being served using the old generation, and all new queries go to the new generation, as soon as it is ready.

## Handling software updates

The API node software allows you to perform software updates without losing queries.

Note

Deploying new major or minor versions of the API node software generally requires creating a new version of the package first, as the on-disk format of packages may change.

A rolling software update involves executing the following steps on each API node software, in turn:

  * Taking the node out of the high availability, generally by forcing the isAlive probe to return false (See [Health monitoring](<health-monitoring.html>))

  * Stopping the node

  * Upgrading the node

  * Restarting the node

  * Uploading the new version of the package on the node

  * Getting the node back into the high availability pool

---

## [apinode/operations/health-monitoring]

# Health monitoring

## Global isAlive probe

The API node features a global “isAlive” probe that can be used by a load balancer to query the status of the server.

The global isAlive probe does not actually perform validation that the individual services on the API node are properly running.

### isAlive API

The isAlive probe is available on the `/isAlive/` HTTP mount point. This URI returns:

  * An HTTP success code (2xx) if the probe considers the node as alive

  * An HTTP server error code (5xx) if the probe considers the node as not alive




### Forcing the node as not alive

You can force the isAlive probe to indicate that the node is not alive, without actually interrupting the traffic. This will lead the load balancer to redirect the traffic to other nodes, and is generally used for rolling upgrades scenarii.

To force the node as not alive:

  * Create a file called `apinode-not-alive.txt` in the API node data directory




To get back to normal:

  * Remove the file `apinode-not-alive.txt` from the API node data directory




## Monitoring the status of services

To monitor the precise status of service, we recommend that you perform a regular prediction query, which will actually exercice the whole chain.

---

## [apinode/operations/index]

# Operations reference

---

## [apinode/operations/logging-audit]

# Logging and auditing

The API node outputs three kinds of logs:

  * Regular runtime logs (in the `run/apimain.log` file)

  * Audit logs for the administration API

  * Logs of queries




Logging of queries is especially important if you plan on implementing a feedback loop. Knowing what has been predicted for what records is important. You’ll also need to have a way to retrieve “what finally happened” for each record that the API node predicted (did this customer convert? churn? was it a fraud? did the sensor fail? …)

By default:

  * Administration API audit logs are written to the same `run/apimain.log` file

  * Queries are logged in the `run/audit` folder




## How to configure audit and query logging

Audit and query logging is done through the standard Java Log4J logging mechanism.

Note

Dataiku DSS has been confirmed to be not vulnerable to the family of vulnerabilities regarding Log4J. No mitigation action nor upgrade is required. Dataiku does not use any affected version of Log4J, and keeps monitoring the security situation on all of its dependencies.

You can set the destination of these loggers by modifying the Log4J appenders in the `bin/log4j.properties` file

The loggers used for audit logging are:

  * dku.apinode.audit.queries:

>     * Logs all queries to prediction endpoints, in a JSON format. The log message includes the input features, the prediction results, and timing information

  * dku.apinode.audit.auth

>     * Logs authentication failures, both on Admin and User APIs

  * dku.apinode.audit.admin

>     * Logs all modifications done through the admin API. The log message includes details about the API key used to perform the call

  * dku.apinode.audit.allcalls

>     * Logs basic information for all API calls, both Admin and User APIs. It is generally not recommended to enable this logger




## How to turn on query logging

In your API_DATA_DIRECTORY, create a directory and subdirectory called `resources/logging`.

In the logging directory, add a file called `dku-log4j.properties`.

Copy the following content into `dku-log4j.properties`
    
    
    # By default, send audit logging to a specific file in run
    # For an inalterable audit log, this should be sent to an external system,
    # not controlled by the DSS user
    log4j.appender.AUDITFILE=org.apache.log4j.RollingFileAppender
    log4j.appender.AUDITFILE.File=${DIP_HOME}/run/audit/audit.log
    log4j.appender.AUDITFILE.MaxFileSize=100MB
    log4j.appender.AUDITFILE.MaxBackupIndex=20
    log4j.appender.AUDITFILE.layout=com.dataiku.dip.logging.JSONAuditLayout
    
    # Queries logging: use rolling files.
    log4j.appender.QUERIES_AUDIT_FILE=org.apache.log4j.RollingFileAppender
    log4j.appender.QUERIES_AUDIT_FILE.File=${DIP_HOME}/run/api-queries/queries.log
    log4j.appender.QUERIES_AUDIT_FILE.MaxFileSize=10MB
    log4j.appender.QUERIES_AUDIT_FILE.MaxBackupIndex=10
    log4j.appender.QUERIES_AUDIT_FILE.layout=org.apache.log4j.PatternLayout
    log4j.appender.QUERIES_AUDIT_FILE.layout.ConversionPattern={"timestamp" : "%d{yyyy/MM/dd-HH:mm:ss.SSS}Z", "logger": "%c", "severity" : "%p", "message" : %m}%n
    
    # Remove audit logs from regular CONSOLE logger
    log4j.additivity.dku.audit=false
    log4j.logger.dku.audit= INFO, AUDITFILE
    
    
    # And enable it
    log4j.additivity.dku.audit.generic=false
    log4j.logger.dku.audit.generic= INFO, QUERIES_AUDIT_FILE
    

Then, restart your API node (./bin/dss restart).

You should now see queries logged in the `run/audit` folder.

## Logging queries to Kafka

Apache Kafka is a distributed message queue, which can be used to get query logs out of the API node.

To enable logging queries to Kafka:

  * Add all jars from the Kafka distribution to the `lib/java` folder

  * Replace the “Queries logging” part of `bin/log4j.properties` by the following snippet:



    
    
    log4j.appender.QUERIES_KAFKA=org.apache.kafka.log4jappender.KafkaLog4jAppender
    log4j.appender.QUERIES_KAFKA.BrokerList=kafka1:9092,kafk2:9092,kafka:9093
    log4j.appender.QUERIES_KAFKA.Topic=dku-apinode-audit
    log4j.appender.QUERIES_KAFKA.layout=com.dataiku.dip.logging.JSONAuditLayout
    
    log4j.additivity.dku.apinode.audit.queries=false
    log4j.logger.dku.apinode.audit.queries= INFO, QUERIES_KAFKA
    

Note

You can also send administration and authentication audit logs to Kafka by setting appropriate configuration for the other audit loggers.

---

## [apinode/security]

# Security

## Security for API Node administration API

The API node administration API can only be queried through administrative API keys.

API node administrative API keys are managed by the `./bin/apinode-admin` tool (see [Using the apinode-admin tool](<operations/cli-tool.html>) for more information).
    
    
    ./bin/apinode-admin admin-key-create
    ./bin/apinode-admin admin-keys-list
    ./bin/apinode-admin admin-key-delete KEY
    

Each API key has full administrative permissions; the API node does not have fine-grained administrative privileges.

## Permissions for API Deployer

The API deployer offers per-group permissions on Published API Services and Infrastructures.

There are no permissions on the deployments:

  * You may read details of a deployment if you have “read” permission on both the service and the infrastructure

  * You may create a new deployment if you have “deploy” permission on both the service and the infrastructure




This gives a large amount of flexibility for implementing:

  * A system where some API services are “public” while some are restricted even from viewing

  * A system where data scientists may deploy any API service to development and testing infrastructures, but only a small set of devops may deploy to the production infrastructure




### Infrastructures

Infrastructures may only be initially created by global DSS administrators.

Once an infrastructure is created, an arbitrary number of groups may be granted access with the following privileges:

  * View: view this infrastructure, view associated deployments (if you also have Read permission on the service)

  * Deploy: use this infrastructure to create deployments, update, enable/disable deployments on this infrastructure, manage their settings (if you also have Deploy permission on the service)

  * Admin: manage infrastructure settings, including managing permissions




To manage infrastructure privileges, go to API Deployer > Infrastructure > Settings > Permissions.

### Services

Services may be created by any user who has the global “Create API Service” privilege (this is handled at the Group level, see [Main project permissions](<../security/permissions.html>)).

The user who creates the service is automatically assigned as “Owner” of the service, which grants full access to the service.

The owner, or any group who has “Admin” privilege on the service, can grant access to an arbitrary number of groups with the following privileges:

  * Read: view this service, view associated deployments (if you also have Read permission on the infrastructure) - Note that this gives the ability to see API keys for the service

  * Write: manage versions of this service (upload, delete)

  * Deploy: create new deployments of this service, update, enable/disable deployments of this service, manage their settings (if you also have Deploy permission on the infrastructure)

  * Admin: manage service settings, including managing permissions and deleting service




To manage service privileges, go to API Deployer > API Services > Settings > Permissions.

## Authorization

To protect access to your services deployed on an API node, DSS supports the following authorization methods:

  * Public: (default) No authorization is required to access the service.

  * API keys: Create a set of static API keys, which you can use to access the service afterwards.

  * JWT/OAuth2: Configure the API node to accept Json Web Token (JWT) from a trusted third party. Additionally, if the third party is an OAuth2 provider, the API node can be configured to verify the JWT as an access token as specified in the OAuth2 specification.




### API Keys

An API key is a token that clients must provide when making API calls. You must first define a set of static keys in DSS that are specific to the API. The API node will ensure that only requests using one of these keys are allowed to access the service.

With this method, DSS manages the keys and therefore takes care of the access management. This method is preferable if your organization does not yet have an IAM.

The API keys authorization method offers the following characteristics:

  * You can create an arbitrary number of API keys

  * API keys are per API Service

  * Each API key has full access to the API service (there is no per-endpoint security)

  * Using multiple API keys gives traceability and the ability to revoke a compromised API key

  * No need of an IAM




### JWT/OAuth2

The API node supports authorizing requests accesses using a Json Web Token (JWT). When this JWT is actually an access token issued by an OAuth2 provider, the API node will do some additional security checks, like scopes.

Note

There is no enforcement of using OAuth2 when using this authorization method. If you have an internal system that issues JWTs, you can configure the API node to accept those JWTs using this authorization method.

Using this authorization method, DSS delegates access management to a third party, usually an IAM. Instead of managing access, as with API keys, DSS will only establish a trust relationship with the IAM. It will be the responsibility of the IAM to ensure that the JWTs issued contain the correct permissions. The API node will only verify that the tokens are issued by the IAM and that the claims contained in the tokens are valid for the current service.

This method is preferred if your organization has an IAM in place and/or if you want to manage API access outside of DSS.

The JWT/OAuth2 authorization method offers the following characteristics:

  * DSS delegates access management to a third party

  * You can easily revoke access directly in the third party and this will be reflected in DSS without any manual intervention

  * You can align the authorization method across all your organization APIs

  * OAuth2 is a well-known standard which your API consumers will most likely be used to

  * JWT allows you to leverage strong cryptography, with options like keys rotation.




## Without API Deployer

When not using API Deployer, security is configured at design time, in the DSS Design node:

  * From the Service page, go to the Security > Authorization tab

  * Select the authorization method of your choice.




When you create the package, the authorization settings are packaged with it, and when you activate the deployment in the API Nodes, they are propagated.

## With API Deployer

When using API Deployer, in addition to the method mentioned above (defining the authorization method at design time), you can also set security on a per-deployment basis.

This allows you to have different authorization method settings, like different API keys, for development and production deployments of the same API Service.

  * Go to Deployment > Settings > Authorization

  * Select whether you want to use the security settings defined in the API Designer, or override them for this deployment




When choosing the authorization method API keys, the API Deployer screen and sample code will show the first API Key, but all API keys will work similarly.

Your POST requests will now require an additional user parameter. For example, it will look something like:
    
    
    curl -X POST --header 'Authorization: Bearer 1234APIKEY56789' \
    URL \
    --data '{
    "key": "value"
    }'
    

## How to setup JWT/OAuth2 authorization method

Note

Whether you choose to setup this method in the design node or at the deployer level, the JWT/OAuth2 setting works the same way.

This authorization method delegates the access management to a third party by relying on signed tokens (JWS) to access the API. The JWT settings will allow DSS to only trust JWTs issued by this third party.

### Keys format

The API node only accepts digitally signed JWTs. In order to verify these signed JWTs (JWS), DSS needs to verify the signature. Currently, DSS only support signing using asymmetric keys, meaning DSS will need to obtain the public keys used to sign the JWTs.

DSS is expecting the public keys to be in a JWKs set format, as per the [RFC 7517](<https://datatracker.ietf.org/doc/html/rfc7517#section-5>). The following methods supported to retrieve the public keys:

  * JWKs_URI: provide the public keys in a JWKs set format, behind a URI.

  * static JWKs set: provide some static public keys in a JWKs set format.




Using a JWKs_URI is recommended, it has the advantage of allowing you to:

  * rotate the keys without any manual configuration changes needed in DSS

  * delegate the management of those keys to your third party

  * have a large set of keys

  * use the out of the box JWKs_URI from your IAM, a feature supported by most modern IAMs.




Note

The supported signing algorithms are:

  * RSA

  * Elliptic Curve




### Issuer

Inside the JWT is defined the iss (issuer) claim which identifies the principal that issued the JWT. By only trusting JWTs with a specific iss value, it ensures that the API node only accept tokens issued by this principal.

If you are using an IAM, you may not be aware of which iss it uses. Please contact your IAM admin system to retrieve the issuer. Although, in some case, you can discover this value by:

  * Create an access token and introspect the claims using [jwt.io](<https://jwt.io>) . You will be able to retrieve the issuer value from the iss claim.

  * The IAM may offer a discovery endpoint, which contains the issuer value, as per the [OIDC discovery specification](<https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderMetadata>). The issuer will be part of the response.




### Audience

Note

In most OAuth2 setups, you can leave it blank, as access tokens are not bound to a specific resource server (unless your organization is enforcing [RFC 8707](<https://datatracker.ietf.org/doc/html/rfc8707>)).

You can choose to define the audience if you know that all the JWTs will always have the same aud. This is the case if the JWTs are dedicated to this API and you want to make sure tokens intended for other APIs are rejected.

### Scope

Note

This setting is optional

It is recommended to configure the scope when using OAuth2. Scopes in OAuth2 allow you to perform granular permission checks on your API. If setup, the API node will verify the token contains the specified scope.

This is particularly handy if you got multiple APIs, with dedicated scopes for each of them, and you want to make sure only users or applications with the right privileges are allowed accesses to your API.

### Scope claim key

Note

Only required if you defined a scope.

When scope validation is enabled, the API node needs to know which claim contains the scopes. This claim is usually scope, but there is no standard. This setting allows you to override the claim key.

### Scope claim format

Note

Only required if you defined a scope.

When scope validation is enabled, the API node needs to know the format of the scope claim. The standard convention in OAuth2 is to have the scope as a string, although this is not enforced. Optionally, DSS also supports the array format for compatibility with IAMs which don’t yet respect the OAuth2 convention.

### Client ID claim Key

The access token is issued for an application, referred to as the OAuth2 Client. For audit reason (see [Configuration for API nodes](<../operations/audit-trail/apinode.html>) for more information), you may want to know the OAuth2 client behind a request. The Client ID is usually in a dedicated claim client_id, although this isn’t standardized. This setting allows the API node to retrieve the client ID from a specified claim, whose format is expected to be string retrieve the client ID from the token. The format of this claim is expected to be a String.

## Send requests to an API protected with JWT/OAuth2

Once you have setup the JWT/OAuth2 authorization method, you will need to retrieve a token from the third party.

The token must then be sent to the API node using the Authorization header, as follow:
    
    
    Authorization: Bearer <token>
    

### Using OAuth2

You may have chosen to configure the JWT/OAuth2 settings for an OAuth2 provider. In this scenario, the JWT token is an access token and the API node acts as a resource server. The API node is agnostic about how you retrieve the access token from the OAuth2 provider. It will only check the validity of the token. Therefore you can choose to retrieve the access token using the authorization grant of your choice (see [RFC 6749](<https://datatracker.ietf.org/doc/html/rfc6749#section-1.3>) for more information). If you are unsure, please contact your IAM admin for more details on which grant you should use and how.

Once you have retrieved an access token, it can be sent to the API node using the same Authorization header:
    
    
    Authorization: Bearer <access-token>