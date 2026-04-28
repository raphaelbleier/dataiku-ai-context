# Dataiku Docs — public-rest-api

## [publicapi/features]

# Features

The DSS public API allows you to perform the following operations in DSS:

  * Projects

>     * Create, list and delete projects
> 
>     * Manage project permissions
> 
>     * Manage project metadata

  * Datasets

>     * Create, list and delete datasets
> 
>     * Manage datasets metadata and schema
> 
>     * Read datasets data
> 
>     * Manage datasets partitions
> 
>     * Clear datasets

  * Jobs

>     * Start jobs / build datasets
> 
>     * List jobs
> 
>     * Check jobs status
> 
>     * Abort jobs

  * Administration

>     * Manage users and groups
> 
>     * Manage global variables
> 
>     * Manage API keys

---

## [publicapi/index]

# Public REST API

The DSS public API allows you to interact with DSS from any external system. It allows you to perform a large variety of administration and maintenance operations, in addition to access to datasets and other data managed by DSS.

The DSS public API is available:

>   * As a [Python API client](<https://developer.dataiku.com/latest/api-reference/python/index.html> "\(in Developer Guide\)"). This allows you to easily send commands to the public API from a Python program. This is the recommended way to interact with the API.
> 
>   * As an [HTTP REST API](<rest.html>). This lets you interact with DSS from any program that can send an HTTP request. This requires more work.
> 
> 


The Python API client can be used both from inside DSS and from the outside world. Using the Python API client from inside DSS lets you do advanced automation and introspection tasks. Example usage of the Python client can be found at [Python](<https://developer.dataiku.com/latest/api-reference/python/index.html> "\(in Developer Guide\)")

---

## [publicapi/keys]

# Public API Keys

All calls to the DSS public API, either performed using [The REST API](<rest.html>) or [Python](<https://developer.dataiku.com/latest/api-reference/python/index.html> "\(in Developer Guide\)") must be authenticated using API keys.

There are three kinds of API keys for the DSS REST API:

  * Project-level API keys

  * Global API keys

  * Personal API keys




Note

When using the API through the Python client from within DSS, you don’t need an API key. You can obtain a Python client with `dataiku.api_client()`. This client will automatically inherit all your personal access rights. In essence, it will behave as is you had used a personal API key, but without needing to actually create one.

## Personal API keys

Personal API keys are created by each user independently in Profile & Settings > API keys. They can be listed and deleted by admin, but can only be created by the end user.

A personal API key gives exactly the same permissions as the user who created it. For all purposes, a personal API key impersonates the user, and calls made using this personal API key behave as if they had been performed by the user. In timelines, Git log and audit log, calls performed using a personal API key will appear as having been performed by the user.

Some features in DSS are based on group-level security, and can thus only be performed by a personal API key, or a globally admin key (see below). This includes:

  * Creating datasets on connections that have restrictive access

  * Performing SQL queries on connections that have restrictive access




## Project-level keys

These keys give privileges on the content of the project only. They cannot give access to anything which is not in their project. Project-level keys are exported when you export a project.

Project-level keys are configured in the project settings (Project Home > Security > API Keys). When you create a new API Key, the permissions JSON objects are prefilled with sample data.

A project-level key actually provides two kinds of privileges:

  * Project-wide privileges

  * Per-dataset privileges




### Project-wide permissions

The following project-wide permissions types can be set on a project-level key. Each of these permissions mirror the project-level permissions defined in [Main project permissions](<../security/permissions.html>). The relations between these permissions are also mirror of the project-level permissions (things like: Write conf implies Read conf).

  * READ_CONF: Read the whole configuration of the objects in the project (but NOT the project itself)

  * WRITE_CONF: Write the whole configuration of the objects in the project

  * EXPORT_DATASETS_DATA

  * SHARE_TO_WORKSPACE

  * READ_DASHBOARDS

  * WRITE_DASHBOARDS

  * MODERATE_DASHBOARDS

  * RUN_SCENARIOS

  * MANAGE_DASHBOARD_AUTHORIZATIONS

  * MANAGE_EXPOSED_ELEMENTS

  * ADMIN: manage the whole project (get/set permissions and project metadata)




### Dataset-specific permissions

In addition, on a project-level key, you can define some permissions that only apply to a set of datasets. This allows you to create very limited API keys that can only be used to read a small number of “published” datasets.

Note

The Webapp builder in DSS and its Javascript API use project-level API keys with dataset-specific permissions

The following permissions can be granted on a set of datasets:

  * READ_DATA

  * WRITE_DATA

  * READ_METADATA

  * WRITE_METADATA

  * READ_SCHEMA

  * WRITE_SCHEMA




### Associated user

Unlike personal API keys, project-level API keys are not equivalent to a DSS user. API keys have their own access rights, and calls performed by a project-level API key will appear as having been performed by this key.

For the sole purpose of [User Isolation Framework](<../user-isolation/index.html>), it is possible to define an “associated user for impersonation” in the configuration of the API key. The identity of this user will be used to compute the impersonation rules for access to HDFS datasets. However, the key still needs to have proper permissions for the action to be granted.

## Global API keys

Global API keys can encompass several projects. Global API keys can only be created and modified by DSS administrators.

Global API keys are defined in Administration > Security > Global API keys

Global API keys are not bound to a project and are not exported.

### Permissions

By default, global API keys use the same group-based permissions model as users. See [Main project permissions](<../security/permissions.html>) for more details.

Administrators can also create global API keys - using either the Public API or the command line - that define permissions directly on the key itself, similar to project-level API keys. In this case, permissions are configured on the key rather than by assigning the key to groups. The following two sub-sections refer to these types of global API keys.

#### Project-level permissions

A global API key can define project-level permissions on any project in DSS. This way, you can for example create a key that has READ_CONF permissions on one project and READ_CONF + WRITE_CONF on another project.

#### Global admin

This special permission gives global admin rights to this key. A global admin key has all permissions and all projects. It can also perform global DSS administration tasks:

  * Manage users

  * Manage log files

  * Manage global variables




### Associated user

Unlike personal API keys, global API keys are not equivalent to a DSS user. API keys have their own access rights, and calls performed by a global API key will appear as having been performed by this key.

For the sole purpose of [User Isolation Framework](<../user-isolation/index.html>), it is possible to define an “associated user for impersonation” in the configuration of the API key. The identity of this user will be used to compute the impersonation rules for access to HDFS datasets. However, the key still needs to have proper permissions for the action to be granted.

---

## [publicapi/rest]

# The REST API

At its core, the DSS public API is a REST HTTP API. The reference HTTP documentation of the DSS REST API can be found here: <https://doc.dataiku.com/dss/api/14/rest>.

The API base URL is: <http://dss_host:dss_port/public/api/>

## Request and response formats

For POST and PUT requests, the request body must be JSON, with the Content-Type header set to application/json.

For almost all requests, the response will be JSON.

Whether a request succeeded is indicated by the HTTP status code. A 2xx status code indicates success, whereas a 4xx or 5xx status code indicates failure. When a request fails, the response body is still JSON and contains additional information about the error.

## Authentication

Authentication on the REST API is done via the use of [API keys](<keys.html>). API keys can be managed through the DSS administration UI.

The API key can be sent using either HTTP Bearer Token Authentication or Basic Authentication:

  * When using Bearer Token Authentication, use the API key as the token

  * When using Basic Authentication, leave the username blank and use the API key as the password




## Authorization

Each API key has access rights and scopes. DSS has a simple UI to edit API key permissions, as JSON objects.

There are two kinds of API keys for the DSS REST API.

For more information about API keys, see [Public API Keys](<keys.html>)

## Methods reference

The reference documentation of the API is available at <https://doc.dataiku.com/dss/api/14/rest>

The API base URL is: <http://dss_host:dss_port/public/api/>