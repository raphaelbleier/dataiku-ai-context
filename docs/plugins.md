# Dataiku Docs — plugins

## [plugins/index]

# Plugins

You can extend the scope of Dataiku DSS features by packaging reusable components into **plugins** and sharing them with others.

A single plugin contains one or more related **components**. Each component is a GUI wrapper around some custom code that exposes a single type of Dataiku element, such as a recipe, dataset, or web app.

For example, the following can be added through plugins:

  * Datasets

  * Recipes

  * Processors

  * Custom formula functions

  * Visual Machine Learning algorithms

  * and so much more




A plugin can only be installed by a user with administrative privileges. Any user with normal privileges can view the plugin store and the list of installed plugins, and use any plugins installed on the Dataiku DSS instance. Users with the [Develop plugins permission](<../security/permissions.html>) can contribute to the development of plugins.

---

## [plugins/installed]

# Managing installed plugins

From the **Installed** tab you can browse or search all installed or development plugins.

Click on the name of a plugin to see its details.

  * The **Summary** tab displays information about the plugin pulled from the descriptor file, whether it requires a dedicated code environment (and the ability to set that code environment), and a list of components in the plugin.

  * The **Settings** tab allows you to specify pre-set parameters for the plugin, if they are used by the plugin.

  * The **Usages** tab allows you find all projects that use the plugin, to help you determine whether it’s safe to remove a plugin.




Note

Plugins cannot be uninstalled without altering the data directory. If you must uninstall a plugin, be sure that the plugin is no longer being used on the instance, then delete the `DATA_DIR/plugins/installed/name-of-a-plugin` directory.

If the plugin was installed from the store, and you need to modify it in order add or change some functionality that you need, you can convert it to a development plugin. However, best practice is to [clone a plugin from a Git repository](<https://developer.dataiku.com/latest/tutorials/plugins/git-versioning/generality/index.html> "\(in Developer Guide\)") and share the changes so that the entire plugin developer community can benefit.

## Credential requests

Some plugins require per-user credentials to access a protected resource, for example an external API. If a plugin requires this type of credential, you must add at least one instance of pre-set parameters in the plugin’s Settings tab mentioned above.

Credentials are one of several types:

  * Single-field

  * Basic (username and password)

  * OAuth2




Once a pre-set parameter object has been created, each user will be able to go to their Profile -> Credentials and enter their personal credentials.

### OAuth2 credentials

OAuth2 credentials require more configuration than single-field or basic credentials. In order to access an external resource protected by an OAuth2 authorization server, a new client application will need to be registered on the OAuth2 authorization server. The steps for this will vary depending on your provider, however, there is some necessary information that should be consistent across all OAuth2 authorization servers.

When registering a client application, you will likely be required to register a redirect URL (can also be referred to as the callback or reply URL) for the OAuth2 authorization server to be able to redirect a user back to DSS upon a successful login. The DSS OAuth2 redirect URL is `DSS_BASE_URL/dip/api/oauth2-callback`. For example if DSS is accessed at <https://dss.mycompany.corp/>, the OAuth2 redirect URL is <https://dss.mycompany.corp/dip/api/oauth2-callback>.

You will also need to some information from the OAuth2 authorization server when instantiating a preset for an OAuth2 credential request (located in the plugin’s Settings). These fields should be found where you registered your client application:

  * Client ID

  * Client Secret (may be optional)

---

## [plugins/installing]

# Installing plugins

Users with administrative privileges can install plugins on a Dataiku DSS instance.

## Installing from the Store

You can install published plugins from the store, if your Dataiku DSS instance has HTTPS connectivity to the Internet.

  * From the Dataiku DSS Application menu, choose **Plugins**

  * Select the **Store** tab

  * Browse or Search for the plugin you’re looking for

  * Click **Install**

  * Follow the directions to install the plugin. If necessary, choose to build a code environment for the plugin

  * Only users with [Admin](<../security/permissions.html>) permissions are allowed to install plugins. See [Requests](<../collaboration/requests.html>) for more details on how users without these permissions can request an installation instead.




## Installing from a ZIP file

If your Dataiku DSS instance doesn’t have Internet access, you need first to obtain the ZIP file of the plugin.

For published plugins, obtain the ZIP file from the [plugins gallery](<https://www.dataiku.com/product/plugins/>). Browse or search for the plugin you are looking for and click on the download link in the “Install In DSS” panel on the right side of the plugin’s page.

Once you have the the ZIP file:

  * From the Dataiku DSS Application menu, choose **Plugins**

  * Select **Add plugin > Upload**

  * Click **Choose file** and select the ZIP file containing your plugin

  * Optionally specify whether this is an update for a plugin you have already installed

  * Click **Upload**

  * Follow the restart instructions, if any




## From a Git repository

You can also install a plugin from a Git repository.

When installing a plugin from a Git repository, you can choose between:

  * Cloning an entire repository, which must thus contain a single plugin (you’ll be able to choose the branch)

  * Exporting a subpart of a repository (you’ll be able to choose the branch and path)

  * Installing it in “development” mode in order to modify it (and possibly push your changes back). See [Git integration in the plugin editor](<reference/git-editor.html>) for further details on the git integration with the plugin editor and [Developing plugins](<reference/index.html>) for details on developing plugins




To install a plugin from Git:

  * From the Dataiku DSS Application menu, choose **Plugins**

  * Select **Add plugin > Fetch from Git repository**

  * Enter the URL of the repository; choose whether to use development mode or not; optionally choose which branch to check out, and whether to check out the entire repository or a subdirectory (if the repository contains multiple plugins)




Note

[The code for most publicly available Dataiku plugins](<https://github.com/dataiku/>) is available in Github repositories. Most plugins are in their own `dss-plugin-*` repository and some are in subfolders of the `dataiku-contrib` repository. Also have a look at the [template repository](<https://github.com/dataiku/dss-plugin-template>) with examples of components and Python unit tests.

---

## [plugins/permissions]

# Permissions

Users with administrative privileges can modify plugins permissions on a Dataiku DSS instance.

## View components in creation lists

When checked, the permission named “View components in creation lists” will show all components in the Dataiku DSS UI and when unchecked, certain components will be hidden from creation menus. As this is a UI setting that only impacts the visibility of items, users will still able to create the components through the Dataiku API. The permission to see the plugin components can be given to all users (including those not belonging to any group) using the “All users” permission checkbox. Otherwise, the permission can be given to user groups existing on the Dataiku DSS instance using the dropdown to select the group and then using “+ Grant access to group” button to confirm.

This permission currently impacts the following list of custom plugin components:

  * Recipes

  * Datasets

  * Apps-as-recipes

  * Webapp templates

  * Visual Webapps

  * Sample Datasets

  * Macros:

    * Clusters

    * Projects

    * Execute macro scenario step

    * Flow right side panel

  * Prepare recipe jython processors

  * Scenario triggers

  * Scenario steps

  * Markdown reports

  * Clusters

  * Probes

  * Checks

  * Exporters

  * Formats

  * Dataiku Apps

  * Custom LLMs

  * Agents

  * Agent tools

  * Guardrails

---

## [plugins/reference/charts-elements]

# Components: Custom chart palettes and map backgrounds

Plugins can embed custom elements that personalize charts: color palettes and map backgrounds. In order to add a custom element, you must add the element description in a Javascript file in the plugin content.

## Color palettes

See [Color palettes](<../../visualization/palettes.html>) for general information about color palettes in charts.

Color palettes can provide same graph color patterns across different charts. From the global Javascript object `dkuColorPalettes`, there are three different functions depending on the palette type:

  * Discrete: `dkuColorPalettes.addDiscrete(palette)`

  * Continuous: `dkuColorPalettes.addContinuous(palette)`

  * Diverging (continuous but colors expand to both side from the middle value): `dkuColorPalettes.addDiverging(palette)`




The `palette` object has several properties:

  * `id`: unique ID across all color palettes in DSS

  * `name`: displayed name

  * `category`: category in the list

  * `colors`: array of the ordered colors (can be `#012345` or `rgb(r, g, b)` styles)

  * `values`: array of the ordered values (a value can be `null` for auto matching)



    
    
    dkuColorPalettes.addDiscrete({
            id: 'palette-id',
            name: 'palette-name',
            category: 'palette-category',
            colors: ['#012345', 'rbg(r, g, b)'],
            values: [1, 2]
    });
    

## Map backgrounds

Map backgrounds can be customized in order to improve map style or to enable maps on offline DSS instances. From the global Javascript object `dkuMapBackgrounds`, there are three different function to add a map background:

  * `dkuMapBackgrounds.addMapbox(mapId, displayLabel, accessToken)`: add a [Mapbox](<https://www.mapbox.com/>) background, [see Mapbox documentation](<https://www.mapbox.com/api-documentation/?language=cURL#maps>) Note that a “Mapbox” plugin for DSS already allows you to add Mapbox backgrounds.

>     * `mapId` Mapbox identifier of the background
> 
>     * `displayLabel` How it will appear in DSS
> 
>     * `accessToken` Mapbox API token



    
    
    dkuMapBackgrounds.addMapbox('mapbox.satellite', 'Satellites', 'ABCDE1234');
    

  * `dkuMapBackgrounds.addWMS(id, name, category, wmsURL, layerId)`: add a generic [WMS](<https://en.wikipedia.org/wiki/Web_Map_Service>) layer, [see Leaflet documentation](<https://leafletjs.com/reference.html#tilelayer-wms>)

>     * `id` unique ID across all map backgrounds in DSS
> 
>     * `name` displayed name
> 
>     * `category` category in the list
> 
>     * `wmsURL` WMS service URL
> 
>     * `layerId` layer ID of the WMS service



    
    
    dkuMapBackgrounds.addWMS('mws-map-bg', 'Map background', 'My backgrounds', 'http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi', 'nexrad-n0r-900913');
    

  * `dkuMapBackgrounds.addCustom(background)`: a custom map background

>     * `id` unique ID across all map backgrounds in DSS
> 
>     * `name` displayed name
> 
>     * `category` category in the list
> 
>     * `fadeColor` color of faded map object
> 
>     * `getTileLayer` function that returns a Leaflet TileLayer object, [see Leaflet documentation](<https://leafletjs.com/reference.html#tilelayer>)



    
    
    dkuMapBackgrounds.addCustom({
            id: 'map-bg',
            name: 'Map background 2',
            category: 'Custom map backgrounds',
            fadeColor: '#333',
            getTileLayer: function() {
                    return new L.tileLayer('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
                            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>'
                    });
            }
    });

---

## [plugins/reference/custom-fields]

# Component: Custom Fields

Custom Fields are additional metadata fields that are added to Dataiku DSS objects such as datasets, recipes, etc.

To start adding Custom Fields, we recommend that you use the plugin developer tools (see the tutorial for an introduction). In the Definition tab, click on “+ ADD COMPONENT”, choose ”Custom Fields”, and enter the identifier for your new Custom Fields. You’ll see a new folder `custom-fields` and will have to edit the `custom-fields.json` file.

A basic Custom Fields’s definition looks like
    
    
    {
        "meta" : {
            "label" : "Custom fields test",
            "description" : "Custom Fields",
            "icon" : "icon-puzzle-piece"
        },
        "customFields" : [
            {
                "applyToObjects" : {
                    "mode": "SOME",
                    "includedObjectTypes": ["PROJECT", "DATASET"]
                },
                "field": {
                    "name": "custom_field_1",
                    "type": "SELECT",
                    "defaultValue": "UNSURE",
                    "selectChoices": [
                        {
                            "value": "YES",
                            "label": "Yes"
                        },
                        {
                            "value": "UNSURE",
                            "label": "Not sure"
                        },
                        {
                            "value": "NO",
                            "label": "No"
                        }
                    ]
                }
            }
        ]
    }
    

The “meta” field is similar to all other kinds of DSS components.

## Defining a set of Custom Fields

The “customFields” field is an array listing all the Custom Fields you want to add. The definition of one Custom Fields is composed of two main fields that are mandatory: “applyToObjects” and “field”.

### Objects definition

A Custom Field can be applied to several types of object in Dataiku DSS among:

  * PROJECT

  * DATASET

  * RECIPE (including visual and code recipes)

  * SQL_NOTEBOOK

  * JUPYTER_NOTEBOOK

  * ANALYSIS

  * SAVED_MODEL

  * INSIGHT

  * MANAGED_FOLDER

  * LAMBDA_SERVICE (an API Designer service)

  * SCENARIO

  * DASHBOARD

  * WEB_APP

  * REPORT (a Rmarkdown report)

  * ARTICLE (a wiki article)

  * CONNECTION (a Dataiku DSS connection)

  * COLUMN (a column within a dataset)




There are 3 modes on how to assign a Custom Field to Dataiku DSS object:

  * ALL : include all types of objects

  * SOME : include the types of objects listed in the `includedObjectTypes` field

  * EXCLUDING : include all types of objects except the ones listed in the `excludedObjectTypes` field




For instance:
    
    
    "applyToObjects" : {
        "mode": "ALL"
    }
    
    
    
    "applyToObjects" : {
        "mode": "SOME",
        "includedObjectTypes": ["PROJECT", "DATASET"]
    }
    
    
    
    "applyToObjects" : {
        "mode": "EXCLUDING",
        "excludedObjectTypes": ["PROJECT", "DATASET"]
    }
    

### Custom Field definition

The fields defining a Custom Field are the following:

  * name : the unique name of the field

  * type : the type of the field among:

>     * STRING : a single-line text
> 
>     * INT : an integer number
> 
>     * DOUBLE : a floating-point number
> 
>     * BOOLEAN : a binary (yes/no) choice
> 
>     * PASSWORD : a hidden single-line text
> 
>     * SELECT : a selection between multiple choices
> 
>     * COLUMN : a selection of a column from an input schema (in a recipe context)
> 
>     * COLUMNS : a multiple selection of columns from an input schema (in a recipe context)
> 
>     * MAP : a complex object
> 
>     * KEY_VALUE_LIST : a key/value pair list
> 
>     * TEXTAREA : a multiple-line text
> 
>     * ARRAY : a complex objects list
> 
>     * PROJECT : a selection of a project
> 
>     * DATASET : a selection of a dataset
> 
>     * DATASETS : a multiple selection of datasets
> 
>     * DATASET_COLUMN : a selection of a column from a specific dataset
> 
>     * DATASET_COLUMNS : a multiple selection of columns from a specific dataset
> 
>     * CONNECTIONS : a multiple selection of connections
> 
>     * FOLDER : a selection of a managed folder
> 
>     * MODEL : a selection of a saved model
> 
>     * SCENARIO : a selection of a scenario
> 
>     * API_SERVICE : a selection of an API service
> 
>     * API_SERVICE_VERSION : a selection of a version of a specific API service
> 
>     * BUNDLE : a selection of a bundle
> 
>     * VISUAL_ANALYSIS : a selection of an analysis
> 
>     * CLUSTER : a selection of a cluster
> 
>     * SEPARATOR : an horizontal line that is used to separate a list of fields that has no input value

  * label : a short label of the field

  * description : a longer description of the field

  * defaultValue : the default value of the field

  * mandatory : true or false whether the field should be mandatory

  * canSelectForeign : true of false whether suggested datasets include foreign datasets (for DATASET and DATASETS types)

  * minD : the minimum possible value (for DOUBLE type)

  * maxD : the maximum possible value (for DOUBLE type)

  * minI : the minimum possible value (for INTEGER type)

  * maxI : the maximum possible value (for INTEGER type)

  * columnRole : the input role of a recipe that is used to retrieve the columns of the corresponding input dataset (for COLUMN and COLUMNS types)

  * visibilityCondition : a condition run in the UI that can be used to hide or display the field

  * datasetParamName : the Custom Field name which contains the dataset from which columns are suggested (for DATASET_COLUMN and DATASET_COLUMNS types)

  * apiServiceParamName : the Custom Field name which contains the API service from which API service version are suggested (for API_SERVICE_VERSION type)

  * iconInDatasetPreview : the CSS icon class that is displayed next to the dataset name in the dataset UI (for SELECT type)

  * selectChoices : a list of possible choices composed of the following fields (for SELECT type)

>     * value : the value of the choice
> 
>     * label : a short label of the choice
> 
>     * icon : an icon for the choice
> 
>     * color : a color for the choice
> 
>     * showInColumnPreview : true or false whether to display the field value in the explore UI if the field has this value

  * clusterPermissions : a list of permissions among (USE, UPDATE, MANAGE_USERS) (for CLUSTER type)




For instance:
    
    
    {
        "field" : {
            "name": "number_of_models",
            "type": "INT",
            "label": "Enter the number of models",
            "description": "Enter the number of models",
            "defaultValue": 0,
            "minI": 0,
            "maxI": 10
        }
    }
    
    
    
    {
        "field" : {
            "name": "project_state",
            "type": "SELECT",
            "label": "Project state",
            "description": "Which state in the lifecycle is the project?",
            "defaultValue": "BEGINNING",
            "selectChoices": [
                {
                    "value": "BEGINNING",
                    "label": "Beginning!"
                },
                {
                    "value": "WORK_IN_PROGRESS",
                    "label": "Work in progress..."
                },
                {
                    "value": "FINISHED",
                    "label": "Finished :)"
                }
            ]
        }
    }
    
    
    
    {
        "field" : {
            "name": "main_project",
            "type": "PROJECT",
            "label": "Main project",
            "description": "Which project is the main project of the instance?"
        }
    }

---

## [plugins/reference/file-format]

# Component: File format

## Description

Dataiku DSS can read files in various formats. In case you need to leverage files that are in a format not natively supported by Dataiku DSS, you can develop a file format plugin. When a file format has been developed, it will be available in the “Upload Dataset” screen, in the “Format” tab, as shown in the screenshot below, and everywhere you can configure the file format.

File format integration.

To process dynamic data, for example from an API, consider a dataset plugin instead.

See also

A tutorial on this plugin component is available in the Developer Guide: [File Format](<https://developer.dataiku.com/latest/tutorials/plugins/file-format/index.html> "\(in Developer Guide\)").

## Creation

To be able to develop a new file format plugin, go to a development plugin page, click on “+New Component”, then choose “File Format” from the list of components. Choose a name for your component, and click on “Add”.

Note

Once this is done Dataiku DSS opens the code editor, allowing you to develop the python code. If your python code needs a specific library, do not forget to update your plugin code environment, please see [Managing dependencies](<other.html#plugin-managing-dependencies>).

## Configuration

A file format plugin is configurable in the associated JSON file (automatically created by Dataiku DSS), in the folder `python-format/{<file-format-id>}/format.json`. This JSON configuration file comprises different parts as shown in the code below.

Configuration file of a file format plugin
    
    
    {
        // Metadata section.
        "meta": {
            // Metadata used for display purposes.
        },
    
        // Global configuration about the file format plugin.
        // See below for more information.
        "canRead": true,
        "canWrite": true,
    
    
        // Parameter section
        "params": [
            // Parameters definition
        ]
    }
    

### Generic configuration

For the metadata section, please refer to [Metadata section](<plugins-components.html#plugin-metadata-section>).

For the parameter section, please refer to [Parameters](<params.html>)

### Global configuration

For the global configuration, a file format has to define:

Global configuration of a file format
    
    
    /* whether the format can be selectable as a dataset format */
    "canBeDatasetFormat": true|false,
    
    /* whether the format can be used to read files. If true, the get_format_extractor() must return an extractor */
    "canRead": true|false,
    
    /* whether the format can be used to write files. If true, the get_output_formatter() must return a formatter */
    "canWrite": true|false,
    
    /* whether the format can provide the schema without reading the data. If true, the FormatExtractor must implement read_schema() */
    "canExtractSchema": true|false,
    
    /* to get additional options in the export dialogs, list them here */
    "exportOptions": [
        // options for export see below
    ],
    
    /* A mime type to use when exporting (if not set: the format is assumed to produce binary data) */
    "mime": {
        /* the mime-type sent to the browser */
        "mimeType": "text/plain",
        /* DSS creates file names by concatenating a unique identifier and this extension */
        "extension": ".txt"
    },
    

### Focus on the export options

The `"exportOptions"` field is the place where you can specify if a dataset can be exported by using this file format. It is not about exporting a particular dataset, but about providing a new file format exporter, for all datasets. This obviously requires setting `"canWrite": true`. Each object in this array will produce a new format available for download. A generic definition of an `exportOptions` object is:

object of the `exportOptions`.
    
    
    {
        /* Unique identifier for this option */
        "id": "option1",
        /* the label you want to see in the format section of the export */
        "label": "Raw text (*.txt)",
        "predefinedConfig": {
            /* Default values of the parameter (if needed), will overwrite the defaultValue from the parameter */
            "param_id": "value of the param id"
        },
        "compression": "None"
    }
    

If the `param_id` refers to an existing parameter name, then it will be editable in the “Advanced parameters” of the export window, as shown below. As this export will be available for all existing datasets, the export functions should be very generic.

Exporting a Dataset using a File Format export.

## Complete example

Complete example of the `format.json`
    
    
    /* This file is the descriptor for the Custom python format ICS */
    {
        "meta": {
            "label": "ICS Format",
            "description": "Import Ical File into Dataiku DSS",
            "icon": "icon-calendar"
        },
        "canBeDatasetFormat": true,
        "canRead": true,
        "canWrite": false,
        "canExtractSchema": true
        "mime": {
            "mimeType": "text/plain",
            "extension": ".ics"
        },
        "exportOptions": [
            {
                "id": "option1",
                "label": "ICal export (*.ics)",
                "predefinedConfig": {
                    "prodid": "-//Dataiku//Dataiku//EN"
                },
                "compression": "None"
            }
        ],
        "params": [
            {
              "name": "prodid",
              "type": "STRING",
              "description": "This property specifies the identifier for the product that created the iCalendar object.",
              "label": "PRODID"
            }
        ]
    }

---

## [plugins/reference/fsproviders]

# Component: Filesystem providers

FS providers give DSS a way to interact with external systems by exposing them as filesystem-like. The user can them access the data stored on these systems using the same concepts as other filesystem-based datasets (HDFS, S3,…). “Filesystem-like” means first and foremost that data is stored in objects that are hierarchized, and that the content of these objects can be read and written with a streaming API. More specifically, the capabilities of a FS provider are:

  * define objects by means of a path

  * list objects located at a given path, or contained by a given path

  * read/write the data as a stream of bytes

  * delete objects contained by a given path

  * move objects from a path to another




## Paths

DSS will identify objects accessed through the FS provider by paths. A path is a ‘/’-separated list of object names, and it needs to be unique for each object. Just like for regular filesystems, there is a root denoted by ‘/’ and the path is understood as left-to-right containment, i.e. ‘/a/b/c’ denotes object ‘c’ inside object ‘b’ inside object ‘a’ inside the root ‘/’.

Containment of other objects defines a dichotomy between directories and files:

  * a directory holds no data by itself, only other objects (directories or filed)

  * a file doesn’t contain any object, only data




Note that directories need not actually exist on the external system, as long as the containment rule is enforced (this is the case for blob storages like S3, Azure Blob Storage, or Google Cloud Storage). In this case, the FS provider doesn’t need to bother with the concept of empty directories.

## Creating a custom FS provider

To start creating a FS provider, we recommend that you use the plugin developer tools (see the tutorial for an introduction). In the Definition tab, click on “Add Component”, pick the FS provider type and enter the identifier for your new FS provider. You’ll see a new folder `python-fs-providers` and will have to edit the `fs-provider.py` and `fs-provider.json` files. The starter code is a simple provider which reads/writes from the local filesystem, starting at a path set in the provider’s parameters.

A FS provider is a [`Python class`](<https://developer.dataiku.com/latest/api-reference/python/plugin-components/custom_fsproviders.html#dataiku.fsprovider.FSProvider> "\(in Developer Guide\)"), with methods for each function it needs to handle:

### Instantiation and teardown

The [`constructor`](<https://developer.dataiku.com/latest/api-reference/python/plugin-components/custom_fsproviders.html#dataiku.fsprovider.FSProvider> "\(in Developer Guide\)") is called with the parameters set by the user in the dataset’s form and with a path denoting the dataset’s root. Contrary to other datasets, there is no “connection” concept, so each dataset using the custom FS provider has to (re)define values for the parameters. The instance of the FS provider is expected to handle all path parameters passed to its methods as relative to the dataset root.

The [`close() method`](<https://developer.dataiku.com/latest/api-reference/python/plugin-components/custom_fsproviders.html#dataiku.fsprovider.FSProvider.close> "\(in Developer Guide\)") is called when the instance of the FS provider is not needed anymore, before killing the Python process running its code, to give some time to perform cleanup actions if necessary

### Object inspection and listing

The [`stat() method`](<https://developer.dataiku.com/latest/api-reference/python/plugin-components/custom_fsproviders.html#dataiku.fsprovider.FSProvider.stat> "\(in Developer Guide\)") is expected to return a description of the object located at the given path. The [`browse() method`](<https://developer.dataiku.com/latest/api-reference/python/plugin-components/custom_fsproviders.html#dataiku.fsprovider.FSProvider.browse> "\(in Developer Guide\)") is expected to return the same information as stat(), together with a listing of the objects directly under the object at the given path when it’s a directory. The [`enumerate() method`](<https://developer.dataiku.com/latest/api-reference/python/plugin-components/custom_fsproviders.html#dataiku.fsprovider.FSProvider.enumerate> "\(in Developer Guide\)") is expected to return the list of all files, not directories, contained in a given path (recursively).

### Object modifications

The [`delete_recursive() method`](<https://developer.dataiku.com/latest/api-reference/python/plugin-components/custom_fsproviders.html#dataiku.fsprovider.FSProvider.delete_recursive> "\(in Developer Guide\)") is expected to remove all object at or contained by the given path. The [`set_last_modified() method`](<https://developer.dataiku.com/latest/api-reference/python/plugin-components/custom_fsproviders.html#dataiku.fsprovider.FSProvider.set_last_modified> "\(in Developer Guide\)") should, when possible, change the modification time of the object defined by the given path. If modification times don’t exist, or can’t be changed, the method should simply not do anything. The [`move() method`](<https://developer.dataiku.com/latest/api-reference/python/plugin-components/custom_fsproviders.html#dataiku.fsprovider.FSProvider.move> "\(in Developer Guide\)") is expected to change the identifying path of a given object.

### Data read/write

Data access is done by means of byte streams. The streams are not seekable.

---

## [plugins/reference/git-editor]

# Git integration in the plugin editor

When you create a plugin in the plugin editor, a Git repository is associated to the plugin. Each change you make in the editor (saving a file, adding a new component, …) is automatically committed in the Git repository.

This gives you:

  * Traceability into all actions

  * The ability to view the history

  * The ability to revert changes




For more details on fetching from Git remotes and working with Git remotes in Dataiku, see [Working with Git](<../../collaboration/git.html>).

## Viewing history

On the plugin development page, click on “History”. The plugin’s history browser appears. You can view all commits made on the plugin. Scroll to the bottom to load more commits.

You can click on any commit to view the details and browse the changed files on this commit. By clicking on the “Compare” button, you can compare the state of the plugin between two revisions.

## Reverting

From the plugin’s History, you can revert your plugin to a specific revision. Click on the revision you want to revert to, and click on “Revert to this revision”.

## Working with branches

Click on the branch indicator to create a new branch or switch to an existing branch.

If you have enabled a remote, this will show both local and remote branches.

Merging branches is not available directly in DSS. Instead, use a remote (see below).

A single plugin in a single DSS instance can only have a single branch active at the moment. To work on several branches at the same time, you need to develop in isolated DSS instances.

## Working with a remote

You can optionally associate a Git remote repository to your plugin. This will allow you to pull new updates and branches from the remote, and to push your changes to the remote.

Warning

It is strongly recommended to have a good understanding of the Git model and wording before using this feature.

To associate a remote, click on the change tracking indicator, select “Add a remote”, and enter the URL of the remote. For more details on working with Git remotes, including SSH setup with Git group rules and per-user SSH keys in **Profile > Credentials > SSH**, see [Working with Git](<../../collaboration/git.html>).

Once the remote is associated, new options become available:

  * Fetch fetches the latest changes and branches from the remote (but does not touch the local copy)

  * Push pushes the current active branch to the remote. Push will fail if the remote has been updated first. In that case, start by pulling.

  * Pull does a “pull –rebase” action: it fetches the latest changes from the remote and attempts to rebase your local changes on top of the remote changes. In case of a conflict, pull aborts. It is not possible to edit conflicts directly in DSS. See below for help on handling conflicts

  * Drop changes allows you to drop all commits you made on the local branch, and to move back the local branch to the HEAD of the remote branch




### Handling conflicts

If pull fails because of a conflict, do the following:

  * Create a new local branch

  * Push it

  * In another Git tool (not DSS), merge the original branch into the pushed local branch, resolving conflicts

  * In DSS, switch back to the original branch and drop local changes

  * Pull

  * You will now have your merged changes




### Merging branches

Let’s say you have a plugin on branch “master” and want to develop a new feature.

  * In DSS, switch to a new branch “myfeature”.

  * When you are happy with the new feature, push it

  * In your Git UI (Github, Bitbucket, Gitlab, …), open a pull request from myfeature to master

  * Merge the pull request

  * In DSS, switch back to the “master” branch

  * Pull it, you will now have your merged changes

---

## [plugins/reference/index]

# Developing plugins

This reference guide assumes that you have already worked through the [plugins tutorial](<https://developer.dataiku.com/latest/tutorials/plugins/index.html> "\(in Developer Guide\)").

---

## [plugins/reference/macros]

# Component: Macros

## Description

A macro is a Dataiku component used to automatize tasks or to extend the capability of Dataiku. It can be used in several places in Dataiku DSS, depending on the role of the macro. By default, macros are accessible from the “Macros” menu of each project. In addition, macro can be made accessible in other places, depending on the `macroRoles` field. For example, if the `macroRoles` is:

  * `DATASETS` the macro will be available when selecting on or more Datasets in the Flow.

  * `PROJECT_MACROS` is about running code on the project in order to achieve global processing on a project (it can be used, to automatically kill running processing, like notebooks).

  * `PROJECT_CREATOR` will allow (administrators) to create a project template with some default configurations.




A macro is not limited to only one kind of role, allowing it to appear in several places if it makes sense.

For more information about macros, see [DSS Macros](<../../operations/macros.html>).

See also

Multiple tutorials on this subject are found in the Developer Guide [Macros](<https://developer.dataiku.com/latest/tutorials/plugins/macros/index.html> "\(in Developer Guide\)").

## Creation

To start creating a macro, we recommend that you use the plugin developer tools (see the tutorial for an introduction). In the Definition tab, click on “Add Python macro”, and enter the identifier for your new macro. You’ll see a new folder `python-runnables` and will have to edit the `runnable.py` and `runnable.json` files

A macro is essentially a Python function, wrapped in a class, written in a `runnable.py` file in the macro’s folder.

A basic macro’s code looks like
    
    
    from dataiku.runnables import Runnable
    
    class MyMacro(Runnable):
        def __init__(self, project_key, config, plugin_config):
            self.project_key = project_key
            self.config = config
    
        def get_progress_target(self):
            return None
    
        def run(self, progress_callback):
            # Do some things. You can use the dataiku package here
    
            result = "It worked"
            return result
    

The associated `runnable.json` file looks like:
    
    
    {
        "meta" : {
            "label" : "A great macros",
            "description" : "It does stuff",
            "icon" : "icon-trash"
        },
    
        "impersonate" : false,
        "permissions" : ["READ_CONF"],
        "resultType" : "HTML",
        "resultLabel" : "The output",
    
        "params": [
            {
                "name": "param_name",
                "label" : "The parameter",
                "type": "INT",
                "description":"Delete logs for jobs older than this",
                "mandatory" : true,
                "defaultValue" : 15
            }
        ]
    }
    

The “meta” and “params” fields are similar to all other kinds of DSS components.

## Macro roles

Macro roles define where this macro will appear in DSS GUI. They are used to pre-fill a macro parameter with context.

E.g,: if a macro has a role of type DATASET that points to an `input_dataset` parameter, the dataset’s action menu will show this macro and clicking on it will prefill the `input_dataset` parameter will the selected dataset.

Each role consists of:

  * type: where the macro will be shown

>     * when selecting DSS object(s): DATASET, DATASETS, API_SERVICE, API_SERVICE_VERSION, BUNDLE, VISUAL_ANALYSIS, SAVED_MODEL, MANAGED_FOLDER
> 
>     * in the project list: PROJECT_MACROS

  * targetParamsKey(s): name of the parameter(s) that will be filled with the selected object

  * applicableToForeign (boolean, default false): can this role be applied to foreign elements (such as foreign datasets, folders or models)?




For example, a `runnable.json` file with macro roles could look like that:
    
    
    {
        "meta" : {
            "label" : "A great macros",
            "description" : "It does stuff",
            "icon" : "icon-trash"
        },
    
        "impersonate" : false,
        "permissions" : ["READ_CONF"],
        "resultType" : "HTML",
        "resultLabel" : "The output",
    
        "macroRoles": [
            {
               "type": "DATASET",
               "targetParamsKey": "input_dataset",
               "applicableToForeign": true
            },
            {
               "type": "API_SERVICE_PACKAGE",
               "targetParamsKeys": ["input_api_service", "input_api_service_package"]
            }
        ],
    
        "params": [
            {
                "name": "input_dataset",
                "type": "DATASET",
                "label": "Input dataset"
            },
            {
                "name": "input_api_service",
                "type": "API_SERVICE",
                "label": "API Service"
            },
            {
                "name": "input_api_service_version",
                "type": "API_SERVICE_VERSION",
                "apiServiceParamName": "input_api_service",
                "label": "API Service version package",
                "description": "retrieved from the API Service stated above"
            }
        ]
    }
    

Note

Only the `API_SERVICE_VERSION` type needs an array specified through `targetParamsKeys`, as it has to fill two related parameters: the API service and the API service package.

All the other types only need to specify one `targetParamsKey`.

## Result of a macro

In addition to performing its action, a macro can return a result, which will be displayed by the user. In many cases, the main job of a macro is to output some kind of report. In that case, the result is actually the main function of the macro.

To return a result from your macro, you must first define the `resultType` field in the `runnable.json` file.

Valid result types are defined below

### HTML

In `runnable.json`, set `"resultType" : "HTML"`

Your macro’s `run` function must return a HTML string, which will be displayed inline in the result’s page. Users will have the option to download the HTML. You may use CSS declarations in your HTML code but please make sure to properly scope them so that they cannot interfere with DSS.

### URL

In `runnable.json`, set `"resultType" : "URL"`

Your macro’s `run` function must return an URL as a string. Users will be presented with a link.

### RESULT_TABLE

In `runnable.json`, set `"resultType" : "RESULT_TABLE"`.

This allows you to build a table view which will be properly formatted for display. We recommend that you use RESULT_TABLE rather than HTML if the output of your macro is a simple table, as you won’t have to handle styling and formatting.

In your macro’s run function, create and fill your result table as follows
    
    
    from dataiku.runnables import Runnable, ResultTable
    
    rt = ResultTable()
    
    # First, declare the columns of the output
    # Parameters to add_Column are: id, label, type
    rt.add_column("dataset", "Dataset", "STRING")
    
    rt.add_column("table", "Table", "STRING")
    
    # Then, add records, as lists, in the same order as the columns
    record = []
    record.append("dataset_name")
    record.append("table_name")
    rt.add_record(record)
    
    # Return the result table as the return value of the macro's run function
    return rt
    

Valid types for columns are:

  * STRING: A regular string

  * STRING_LIST: Add a list of strings in the `record` array. It will be formatted comma-separated




## Interacting with DSS in macros

The recommended way to interact with DSS in the code of a macro is either the internal Python API or the public API.

For internal API, for example, this includes `dataiku.Dataset()`. Interaction with the public API is made easy by `dataiku.api_client()` which gives you a public API client handle, automatically configured with the permissions of the user running the macro.

## Progress reporting

You have the possibility to monitor the progress status of your macro during its execution by leveraging the `progress_callback()` function.

The first step is to make the `get_progress_target()` function return a (target, unit) tuple where:

  * target is the “final value” your progress bar will have to reach

  * unit defines which measure of scale the progress bar is assessing (for example SIZE if you are uploading/downloading a file, FILES if you are processing a list of files, RECORDS if you are processing a list of records, NONE if the unit is arbitrary, e.g. using a percentage).



    
    
    def get_progress_target(self):
      return (3, 'NONE')
    

The next step is then to invoke `progress_callback()` within the `run()` function with a “current progress” value to update the status of the progress bar every time it’s necessary.
    
    
    def run(self, progress_callback):
      # Write code for part 1/3 of your macro here
      progress_callback(1)
      # Write code for part 2/3 of your macro here
      progress_callback(2)
      # Write code for part 3/3 of your macro here
      progress_callback(3)
    

## Security of macros

### Impersonation

You need to configure whether this macro will run with UNIX identity of the user running DSS, or with the identity of the final user. Note that this is only relevant for the users of your plugin if [User Isolation Framework](<../../user-isolation/index.html>) is enabled, but since your plugin might be used in both cases, you still need to take care of this.

Generally speaking, we recommend that your macros run with `"impersonate" : true`. This means that they may not access the filesystem outside of their working directory and should only use DSS APIs for their operations.

If your macro runs with `"impersonate": false`, it can access the filesystem, notably the DSS datadir.

### Permissions

A macro always runs in the context of a project (which is passed to the macro’s constructor).

Your macro can define the project permissions that users must have to be able to run the macro. This is done in the `permissions` field of the `runnable.json` file.

Valid permission identifiers are:

  * ADMIN

  * READ_CONF

  * WRITE_CONF




For more information about the meaning of these permissions, see [Main project permissions](<../../security/permissions.html>)

In addition, if the users running the macro need to have global DSS administrator rights, set the `"requiresGlobalAdmin"` field of `runnable.json` to `true`

---

## [plugins/reference/ml-preprocessors]

# Component: Feature preprocessor

This plugin component allows you to extend the [feature handling](<../../machine-learning/features-handling/index.html>) capabilities of Visual Machine Learning with custom preprocessors for numerical and categorical features.

When a feature uses a plugin preprocessor, DSS calls Python code from the plugin during model training and scoring.

## First example

To start adding feature preprocessors, use the plugin developer tools. In the Definition tab, click on `+ NEW COMPONENT`, choose `Feature Preprocessor`, and enter the identifier for your new preprocessor.

This creates a folder under `python-preprocessors` containing:

  * `preprocessor.json` for the component descriptor

  * `preprocessor.py` for the Python implementation




A basic descriptor looks like:
    
    
    {
        "meta": {
            "label": "Custom preprocessor normalize-score",
            "description": "Normalize a numeric feature with a z-score transform",
            "icon": "fas fa-puzzle-piece"
        },
        "featureTypes": ["NUMERIC"],
        "params": []
    }
    

and the corresponding Python code:
    
    
    import pandas as pd
    
    class CustomPreprocessor(object):
        def __init__(self, params, feature_type=None):
            self.params = params
            self.feature_type = feature_type
            self.mean = 0.0
            self.std = 1.0
    
        def fit(self, series):
            self.mean = series.mean()
            self.std = series.std() or 1.0
    
        def transform(self, series):
            values = (series - self.mean) / self.std
            return pd.DataFrame({"zscore": values})
    

Once the plugin component is added, it is available in the **Feature handling** tab for compatible numerical or categorical features through the **Plugin preprocessing** option.

## Descriptor

Each feature preprocessor descriptor has the following structure:

  * `meta`: Description of the component. Similar to other plugin components.

  * `featureTypes`: List of feature types for which the preprocessor is available. Supported values are `"NUMERIC"` and `"CATEGORY"`.

  * `params`: List of plugin [parameters](<params.html>) exposed in the Feature handling UI, using the same parameter definitions as other plugin components.

  * `paramsPythonSetup`: Optional Python file in the plugin `resource` folder, used with the standard plugin parameter mechanism to dynamically populate `SELECT` or `MULTISELECT` parameters if their definition uses `"getChoicesFromPython": true`.




If any parameter uses `"getChoicesFromPython": true`, then `paramsPythonSetup` is mandatory and must point to a Python file. There can be as many files as there are components in a plugin.

When `paramsPythonSetup` is used, the referenced Python file must implement a `do(payload, config, plugin_config, inputs)` function returning a list of `{"value": ..., "label": ...}` dictionaries.

For feature preprocessor parameters, the `payload` passed to `do` includes the standard fields used by dynamic choices:

  * `parameterType`: the parameter type, for example `SELECT` or `MULTISELECT`

  * `parameterName`: the name of the parameter being populated, useful when multiple parameters use `"getChoicesFromPython": true` and thus share the same callback function

  * `customChoices`: boolean flag indicating that the call is requesting dynamic choices

  * `rootModel`: the current parameter model




In addition, feature preprocessors receive extra context in the payload:

  * `dataset`: smart name of the input dataset of the Visual ML task

  * `column`: name of the feature currently being configured




## Python object

The `preprocessor.py` file must define a `CustomPreprocessor` class.

Its constructor receives:

  * `params`: dictionary of parameter values configured by the user in the UI

  * `feature_type`: feature type for which the preprocessor is used. Possible values are `"NUMERIC"` and `"CATEGORY"`




The class must implement:

  * `fit(self, series)`: called on a Pandas series during training

  * `transform(self, series)`: called on a Pandas series during training and scoring




The `transform` method must return one of:

  * a Pandas `DataFrame`

  * a NumPy `ndarray`

  * a SciPy `csr_matrix`




Both single-column and multi-column outputs are supported.

## Execution model

Feature preprocessors are applied to one feature at a time.

At training time, DSS:

  * instantiates `CustomPreprocessor`

  * calls `fit` on the feature’s training series

  * serializes the fitted preprocessor with the model

  * calls `transform` to generate the preprocessed features




At scoring time, DSS reloads (deserializes) the fitted preprocessor and calls `transform` on the incoming series.

The preprocessor receives the feature after application on that feature of the standard missing-value handling selected in Feature handling.

## Output naming

Output feature names follow the pattern `plugin:{plugin_component_id}:{column_name}:{suffix}`, with the suffix depending on the type returned by `transform`:

  * For a NumPy array, SciPy sparse matrix, or unnamed Pandas Series, `unnamed_{0,1,2,...}`.

  * For a Pandas DataFrame, the column names.

  * For a named Pandas Series, the series name.




## Versioning

The model stores the plugin identifier, component identifier, and plugin version used at training time.

If the installed plugin version changes after training, DSS keeps using the component but logs a warning about the version mismatch.

## Compatibility and limitations

Feature preprocessors currently have the following scope and limitations:

  * They apply only to numerical and categorical input features.

  * They are available through the **Plugin preprocessing** option in Visual ML feature handling.

  * They can output dense or sparse features. Sparse features may be densified during training and scoring depending on the compatibility of the selected model and scoring engine.

  * Models using a plugin preprocessor can be deployed on API nodes. The necessary plugin files are bundled into the API service package.

  * Models using a plugin preprocessor are not compatible with Java optimized scoring, SQL scoring, model exports to Python (through the `dataiku-scoring` package), Java, MLflow, PMML, nor Snowflake functions. See [Exporting models](<../../machine-learning/models-export.html>).

  * Ensembling is not supported when any feature uses a plugin preprocessor.




## Usage of a code-env

Feature preprocessors do not use a dedicated plugin code environment, as they run in the same process as the model training/scoring.

If the preprocessor depends on external Python packages, install them in the code environment used to train and score the model. For API node deployments, the API node environment must also contain these dependencies.

---

## [plugins/reference/other]

# Other topics

## Managing dependencies

### Packages

Python and R dependencies (packages) are not managed by DSS: the user must ensure that the DSS Python or R environment has the necessary packages.

DSS can however inform the user about dependencies: to do so, add a `requirements.json` file at the root of the plugin (besides the `plugin.json` file). This file is simply a declaration of the required packages, which is presented to the administrator as soon as he installs the plugin.

A requirements.json file looks like this:
    
    
    {
        "python" : [
            {"name":"pandas", "version":">=0.16.2"},
            {"name":"sqlalchemy", "version":">=0.1"}
        ],
        "R" : [
            {"name":"dplyr", "version":"1.0.0"}
        ]
    }
    

### Code environments

A plugin can contain the definition of a code environment to hold the list of packages it requires for its execution. There is only one such definition in a plugin, either Python or R. For a Python code environment, one should setup the following hierarchy in the plugin (use “Add components” on the Definition tab of your development plugin):
    
    
    plugin root
    +---code-env
        +---python
            |   desc.json
            +---spec
                |   environment.spec  (optional, Conda spec)
                |   requirements.txt
                |   resources_init.py  (optional, code environment resources)
    

  * The `environment.spec` and `requirements.txt` contain the list of desired packages.

  * The resources initialization script `resources_init.py` contains the python code to initialize the code environment resources directory. See [Managed code environment resources directory](<../../code-envs/operations-python.html#code-env-resources-directory>) for more information.

  * The `desc.json` file contains the environment characteristics:



    
    
    {
        "acceptedPythonInterpreters": ["PYTHON27"],
        "installCorePackages": false,
        "installJupyterSupport": false,
        "basePackagesInstallMethod": "PRE_BUILT",
        "conda": false
    }
    

### Shared code

requirements.json work for “standard” packages that are available in repositories. However, you also often want to share some code between multiple datasets and recipes of the same plugin.

For these files, you can create a `python-lib/` folder at the root of the plugin. This folder is automatically added to the PYTHONPATH of all custom recipes and datasets of this plugin. For an example of that, you can have a look at the code of our [Pipedrive connector](<https://github.com/dataiku/dataiku-contrib/tree/master/pipedrive-import>) .

Code from this folder can also be imported from regular python recipes or notebooks using the following functions. This makes it possible to package python module inside plugins.

dataiku.use_plugin_libs(_plugin_id_)
    

Add the lib/ folder of the plugin to PYTHONPATH

dataiku.import_from_plugin(_plugin_id_ , _package_name_)
    

Import a package from the lib/ folder of the plugin and returns the module

### Resource files

You may also create a `resource` folder at the root of your plugin (besides the plugin.json file) to hold resource files of your plugin (for example, data files).

This resource folder is meant to be read-only. To get the path of the resource folder:

  * Python datasets call the [`dataiku.connector.Connector.get_connector_resource()`](<https://developer.dataiku.com/latest/api-reference/python/plugin-components/custom_datasets.html#dataiku.connector.Connector.get_connector_resource> "\(in Developer Guide\)") method on `self`

  * Python recipes call the `dataiku.customrecipe.get_recipe_resource()` function

  * R recipes call the `dataiku.dkuCustomRecipeResource()` function




## Categorizing recipes and datasets

You can group your custom recipes and datasets in categories, so that they appear in folders in the recipe and dataset menus.

Add this category in the meta field of your `plugin.json` file:
    
    
    "meta": {
        "label": "Geocoder - internal API",
        "author": "admin",
        "icon": "icon-globe",
        "licenseInfo": "Apache Software License",
        "category": "Geospatial"
    }
    

## Custom settings UI

By default, DSS will present a form with a field for each parameter defined in the .json of the custom recipe/dataset, but it is possible to have a more elaborate and interactive interface.

### Fully custom forms

The more advanced option is to have a completely custom form by providing 2 parameters in the custom recipe/dataset JSON descriptor :

  * in paramsTemplate : a .html file in the resource/ folder at the plugin root

  * in paramsModule : an optional Angular module, defined in a .js file in the js/ folder at the plugin root (the name of the file doesn’t matter)




The html is loaded with Angular, and the parameter values should be set in the object config.

For example, the form from the previous section could be done in a fully custom way with
    
    
    <div ng-controller="MyCustomFormController" style="margin: 10px 0px;">
        <input name="useToken" type="checkbox" ng-model="config.useToken">Use token</input>
        <label for="login" ng-if="!config.useToken">
            <div style="width: 80px; display: inline-block;">Login</div>
            <input name="login" type="text" ng-model="config.login" style="width: 80px;" />
        </label>
        <label for="password" ng-if="!config.useToken">
            <div style="width: 80px; display: inline-block;">Password</div>
            <input name="password" type="password" ng-model="config.password" style="width: 80px;"/>
        </label>
        <label for="token" ng-if="config.useToken">
            <div style="width: 80px; display: inline-block;">Token</div>
            <input name="token" type="text" ng-model="config.token" style="width: 80px;"/>
        </label>
        <label for="fetchSize" >
            <div style="width: 80px; display: inline-block;">Fetch size</div>
            <input name="fetchSize" type="number" ng-model="config.fetchSize" style="width: 80px;"/>
        </label>
        <div>
            <span>{{checkResult.hasAuthentication == null ? 'Not checked' : (checkResult.hasAuthentication ? 'Form complete' : 'Fill credentials')}}</span>
            <button ng-click="check()" class="btn btn-default">Recheck</button>
        </div>
    </div>
    

and
    
    
    var app = angular.module('myplugin.module', []);
    
    app.controller('MyCustomFormController', function($scope) {
        $scope.checkResult = {};
        $scope.check = function() {
            var hasAuthentication = function(config) {
                return config.useToken ? config.token : (config.login && config.password);
            };
            $scope.checkResult = {
                hasAuthentication : hasAuthentication($scope.config)
            };
        };
        $scope.check();
    });
    

where the setup in the custom dataset JSON is
    
    
    "paramsTemplate" : "form.html",
    "paramsModule" : "myplugin.module",
    

and these parameters can be retrieved in the Python file as usual:
    
    
    recipe_config = get_recipe_config()
    use_token = recipe_config.get('useToken', False)
    login = recipe_config.get('login', None)
    password = recipe_config.get('password', None)
    token = recipe_config.get('token', None)
    fetch_size = recipe_config.get('fetchSize', 0)
    

This produces a form like :

Warning

When using this method, your custom code is loaded in the same frontend namespace as the rest of the DSS UI.

>   * Erroneous code may lead to making the DSS UI unusable, which may require administrator intervention.
> 
>   * Compatibility between DSS versions is not guaranteed as Dataiku regularly updates its libraries.
> 
>   * Importing in your custom code your own versions of some core libraries (AngularJS, jQuery, bootstrap, …) may lead to making the DSS UI unusable, which may require administrator intervention.
> 
> 


#### Including additional files

Additional files from the plugin’s resource folder can be accessed by referencing them with `/plugins/__plugin_name__/resource/__file_to_get__`.

This is useful to load CSS stylesheets, images, or html files to use as Angular templates. Typically, one can add a `<link />` element to load some CSS rules, like :
    
    
    <link href="/plugins/my_plugin/resource/my_form.css" rel="stylesheet" type="text/css">
    

### Fetching data for custom forms

A fully custom form will often need to fetch data to be presented. A simple example would be a way to select one of the values of a given column in the input dataset of a recipe. For this example, code able to read the dataset and compute the list of distinct values is needed.

A custom form can call a `do()` method defined in a python file that will get executed on the backend’s machine, and will thus have access to the project’s data. This `do()` method is called from the javascript running in the browser by using the `callPythonDo()` method on the Angular scope of the form. The Python file containing the code for the `do()` method needs to be in the plugin’s resource folder, and referenced from the .json in a paramsPythonSetup field.

For example, a form asking to choose a column and a value from this column could be done with:
    
    
    <div ng-controller="FoobarController">
        <div class="control-group" >
            <label class="control-label">Column</label>
            <div class="controls" > <!-- basic text field with typeahead for the column selection, as you would get for a COLUMN parameter in a generated form -->
                <input type="text" ng-model="config.filterColumn" ng-required="true" bs-typeahead="columnsPerInputRole['input_role']"/>
                <span class="help-inline">Column to filter on</span>
            </div>
        </div>
        <div class="control-group" >
            <label class="control-label">Value</label>
            <div class="controls" >
                <select dku-bs-select="{liveSearch:true}" ng-model="config.filterValue" ng-options="v for v in choices" />
                <span class="help-inline">Value to keep</span>
            </div>
        </div>
    </div>
    
    
    
    var app = angular.module('foobar', []);
    
    app.controller('FoobarController', function($scope) {
        var updateChoices = function() {
            // the parameter to callPythonDo() is passed to the do() method as the payload
            // the return value of the do() method comes back as the data parameter of the fist function()
            $scope.callPythonDo({}).then(function(data) {
                // success
                $scope.choices = data.choices;
            }, function(data) {
                // failure
                $scope.choices = [];
            });
        };
        updateChoices();
        $scope.$watch('config.filterColumn', updateChoices);
    });
    

and a Python callback
    
    
    from dataiku import Dataset
    from sets import Set
    
    # payload is sent from the javascript's callPythonDo()
    # config and plugin_config are the recipe/dataset and plugin configured values
    # inputs is the list of input roles (in case of a recipe)
    def do(payload, config, plugin_config, inputs):
        role_name = 'input_role'
        # get dataset name then dataset handle
        dataset_full_names = [i['fullName'] for i in inputs if i['role'] == role_name]
        if len(dataset_full_names) == 0:
            return {'choices' : []}
        dataset = Dataset(dataset_full_names[0])
        # get name of column providing the choices
        column_name = config.get('filterColumn', '')
        if len(column_name) == 0:
            return {'choices' : []}
        # check that the column is in the schema
        schema = dataset.read_schema()
        schema_columns = [col for col in schema if col['name'] == column_name]
        if len(schema_columns) != 1:
            return {'choices' : []}
        schema_column = schema_columns[0]
        # get the data and build the set of values
        choices = Set()
        for row in dataset.iter_tuples(sampling='head', limit=10000, columns=[column_name]):
            choices.add(row[0])
        return {'choices' : list(choices)}

---

## [plugins/reference/params]

# Parameters

Many plugin components, including datasets, recipes, macros, and webapps, can be configured through a form. The list of parameters required by a given component must be specified as a JSON array in the `params` field of the JSON configuration file of the component and DSS will generate the corresponding user interface.

Parameters are also used when defining the [Edit project variables](<../../applications/tiles.html#applications-tiles-edit-project-variables>) tile and the [Application-as-recipe settings](<../../applications/application-as-recipe.html#application-as-recipe-settings>).

## Describing parameters

Each parameter is a JSON object with the following fields:

  * `type`: Type of the parameter. The most common types are STRING, INT, DOUBLE, BOOLEAN, SELECT, DATASET and COLUMN. This field is **mandatory**.

  * `name`: Name of the parameter as accessible by your component’s code, in the configuration `dict`. This must be a valid variable name in Python and Javascript. We highly recommend that you_use_slug_like_names. Parameter names must not start with `__` (double underscore), as these names are reserved for internal use by DSS/Dataiku. This field is **mandatory** (except for the type SEPARATOR, see below).

  * `label`: The user-visible name that appears in the form. This field is **mandatory**.

  * `description`: Additional help to describe the parameter. Will appear on the side of the form.

  * `defaultValue`: The pre-filled value of the parameter. The type must match the field type.

  * `mandatory`: true/false. When true, this parameter must be supplied to use the component. When false, the parameter is optional.

  * `visibilityCondition`: Show/hide this parameter depending on a condition. See Conditional parameters for details.




Besides, additional fields may be available for specific types of parameters. See below.

To get the value of a parameter, in Python, we recommend using the form `config.get(param_name, default_value)` to give a default value to each parameter or use the field `defaultValue`.

## Available parameter types

There are many different types of parameters, but they can be grouped into:

  * Basic types: BOOLEAN, DATE, DOUBLE, DOUBLES, INT, PASSWORD, STRING, STRINGS, TEXTAREA.

  * Complex types: ARRAY, KEY_VALUE_LIST, MAP, MULTISELECT, OBJECT_LIST, SELECT.

  * DSS object parameters: API_SERVICE, API_SERVICE_VERSION, BUNDLE, CLUSTER, CODE_ENV, COLUMN, COLUMNS, CONNECTION, CONNECTIONS, DATASET, DATASET_COLUMN, DATASET_COLUMNS, DATASETS, LLM, KNOWLEDGE_BANK, MANAGED_FOLDER, ML_TASK, PROJECT, SAVED_MODEL, SCENARIO, VISUAL_ANALYSIS.

  * Other types: CREDENTIAL_REQUEST, PRESET, PRESETS, SEPARATOR.




Note

In the Python recipes, the value of the parameters are the result of JSON deserialization. As such, you’ll only get the following data types: bool, dict, float, int, list, string.

## Conditional parameters

The `visibilityCondition` field allows displaying a parameter based on the value of other parameters. If the condition is evaluated as `True` then the parameter will be displayed. The values of other parameters are accessible via the `model` object, see below.

For example, the following JSON definition of the parameters :
    
    
    "params": [
      {
        "name": "sep1",
        "label": "Authentication",
        "type": "SEPARATOR"
      },
      {
        "name": "useToken",
        "label": "Authenticate with token",
        "type": "BOOLEAN"
      },
      {
        "name": "username",
        "label": "Login",
        "type": "STRING",
        "visibilityCondition": "!model.useToken"
      },
      {
        "name": "password",
        "label": "Password",
        "type": "PASSWORD",
        "visibilityCondition": "!model.useToken"
      },
      {
        "name": "token",
        "label": "Token",
        "type": "STRING",
        "visibilityCondition": "model.useToken"
      },
      {
        "name": "sep3",
        "label": "Reads",
        "type": "SEPARATOR"
      },
      {
        "name": "fetchSize",
        "label": "Fetch size",
        "type": "INT"
      }
    ]
    

Produces the following form where the fields Token and Login/Password are shown/hidden depending on the state of the Authenticate with token checkbox:

### Using visibilityCondition with a SELECT type

For example, the following JSON definition of the parameters :
    
    
    "params": [
      {
          "name": "prediction_type",
          "label": "Regression or Classification",
          "type": "SELECT",
          "selectChoices" : [
              { "value": "regression", "label": "Regression"},
              { "value": "classification", "label": "Classification"}
          ],
          "mandatory": true
      },
      {
          "name": "target_actual_col",
          "label": "Target Column",
          "type": "COLUMN",
          "columnRole": "input_dataset"
      },
      {
          "name": "prediction_probability_col",
          "label": "Prediction Probabilities Column",
          "type": "COLUMN",
          "columnRole": "input_dataset",
          "visibilityCondition": "model.prediction_type == 'classification'"
      },
      {
          "name": "probability_threshold",
          "label": "Probability Threshold",
          "type": "DOUBLE",
          "defaultValue": .5,
          "visibilityCondition": "model.prediction_type == 'classification'"
      },
      {
          "name": "prediction_col",
          "label": "Predictions Column Name",
          "type": "COLUMN",
          "columnRole": "input_dataset",
          "visibilityCondition": "model.prediction_type == 'regression'"
      }
    ],
    

produces the following form where the fields Prediction Probabilities Column and Probability Threshold are shown if Classification is selected as the prediction type, and Predictions Column Name is shown if Regression is selected:

> ## Basic types

### String parameters

  * **STRING** : A simple string

  * **TEXTAREA** : A string, but the UI shows a multi-line control suitable for entering long text.

  * **PASSWORD** : A string, but the UI shows a password input field.

  * **STRINGS** : A list of strings




**PASSWORDS** (for example, to access an external API) should typically be plugin parameters, **not component parameters** , so that they are set only once and visible only to admins. See Plugin-level configuration for details on plugin parameters.

In the case of **STRINGS** , you may specify:

  * `"allowDuplicates": false`: to prevent duplicate strings in the parameter (case sensitive)




Example:
    
    
    {
      "type": "STRING",
      "name": "favorite_quote",
      "label": "What's your favorite quote from Camus?",
      "defaultValue": "At any street corner the feeling of absurdity can strike any man in the face."
    }
    

### Numerical parameters

  * **INT** : An integer.

  * **DOUBLE** : A decimal.




You can provide `minI`/`maxI` (for INT) and `minD`/`maxD` (for DOUBLE) to force a value interval.

Example:
    
    
    {
      "type": "INT",
      "name": "age",
      "label": "Age of the captain",
      "minI": 0,
      "maxI": 122
    }
    

  * **INTS** : A list of integers.

  * **DOUBLES** : A list of decimals.




You can not provide `minI`/`maxI` (for INTS) and `minD`/`maxD` (for DOUBLES) to force a value interval.

### Boolean parameters

  * **BOOLEAN** : A boolean, displayed as a checkbox.




Example:
    
    
    {
      "type": "BOOLEAN",
      "name": "the_other_boolean_g",
      "label": "I accept",
      "defaultValue": false
    }
    

### Date parameters

  * **DATE** : A simple date, that you will be able to pick from a calendar. This returns a string representing the chosen date, in the Zulu DateTime format.




Example:
    
    
    {
      "type": "DATE",
      "name": "release_date",
      "label": "Release Date"
    }
    

## Complex types

### Multi-choice parameters

  * **SELECT** : Select one value among possible choices.

  * **MULTISELECT** : Select several values among possible choices.




SELECT and MULTISELECT parameters **must have one** of the two fields:

  * `selectChoices`: list of `{value, label}` if the list is static.

  * `getChoicesFromPython`: true if the plugin contains a python function that can generate dynamically the list of `{value, label}`. For details see below in the advanced section.




**SELECT** allows you to offer several choices, and have the user select one (or many, in the case of **MULTISELECT**). Each choice has an identifier (`value`) and a user-visible long string (`label`). It returns a string (or a list of) representing the `value` chosen.

#### Example of a simple select
    
    
    {
      "type": "SELECT",
      "name": "egg_type",
      "label": "Choose your eggs",
      "selectChoices": [
        { "value": "scrambled", "label": "Scrambled"},
        { "value": "sunny_up", "label": "Sunny-side up"}
      ]
    }
    

#### Dynamic select using python

To populate the choices of a select using a python script, you need to:

  * specify a **SELECT** param with `"getChoicesFromPython": true`

  * create a python file under the _resource_ folder of the plugin (ex: `computechoices.py`) and create a `do()` function in it that returns a dict with a key “choices”

  * point to the python file from the component JSON file by specifying `"paramsPythonSetup": "computechoices.py"` (replace with the proper filename)




Example:

  * `webapp.json`:
        
        ...
        "paramsPythonSetup": "compute_available_time_slots.py",
        "params": [
            {
                "type": "SELECT",
                "name": "time_slot",
                "getChoicesFromPython": true
            }
        ],
        ...
        

  * `resource/compute_available_time_slots.py`
        
        def do(payload, config, plugin_config, inputs):
          choices = [
            { "value": "val1", "label": "Value 1"},
            { "value": "val2", "label": "Value 2"}
          ]
          return {"choices": choices}
        




In case you have lot of choices, you can have a grouped display:

  * `resource/compute_available_time_slots.py`
        
        def do(payload, config, plugin_config, inputs):
          choices = [
            { "value": "val1", "label": "Value 1", "group": "group 1"},
            { "value": "val2", "label": "Value 2", "group": "group 1"},
            { "value": "val3", "label": "Value 3", "group": "group 2"},
            { "value": "val4", "label": "Value 4", "group": "group 2"}
          ]
          return {"choices": choices}
        




#### Optional fields

By default, the dynamic select will be triggered each time a parameter changes in the form. You may want to restrict the dynamic select trigger behavior using the following options:

  * `disableAutoReload`: The dynamic select python code will only be triggered at the load of the auto-config form and not each time a parameter changes. Use this option as follow:
        
        ...
        "paramsPythonSetup": "compute_available_time_slots.py",
        "params": [
            {
                "name": "param_A",
                "label": "The param A",
                "type": "DOUBLE",
                "defaultValue": .5
            },
            {
                "name": "param_B",
                "label": "The param B",
                "type": "DOUBLE",
                "defaultValue": .5
            },
            {
                "type": "SELECT",
                "name": "param_C",
                "getChoicesFromPython": true,
                "disableAutoReload": true
            }
        ],
        ...
        

In the above example, the param_C will only be updated when the form is loaded. Further changes on `param_A` or `param_B` won’t call the python script and therefore `field_C` will stay unchanged.

  * `triggerParameters`: Restrict the dynamic select trigger on specific parameter changes. Particularly useful if your dynamic selection only depends on specific parameters. Use this option as follow:
        
        ...
        "paramsPythonSetup": "compute_available_time_slots.py",
        "params": [
            {
                "name": "param_A",
                "label": "The param A",
                "type": "DOUBLE",
                "defaultValue": .5
            },
            {
                "name": "param_B",
                "label": "The param B",
                "type": "DOUBLE",
                "defaultValue": .5
            },
            {
                "type": "SELECT",
                "name": "param_C",
                "getChoicesFromPython": true,
                "triggerParameters": ["param_B"]
            }
        ],
        ...
        

In the above example, the `param_C` will only be updated when the `param_B` changes value.




### Structured parameters

  * **MAP** : A (key -> value) mapping. This will return a `dict` of the form : `{ 'key1' : 'value1', 'key2': 'value2'}`.

  * **KEY_VALUE_LIST** : A list of (key -> value). Similar to MAP but with an order. This will return a `list` of the `[{'from': 'key1', 'to': 'value1'}, {'from': 'key2', 'to': 'value2'}]`.

  * **ARRAY** : Let the user choose its input types, and fill an array with these inputs.

  * **OBJECT_LIST** : a list of complex objects tied together, it requires an additional field: `subParams`. This will return a `list` of `dict`.
        
        {
            "name": "identity",
            "label": "Identities",
            "type": "OBJECT_LIST",
            "subParams": [
                {
                    "type": "SEPARATOR",
                    "label": "Enter your identities"
                },
                {
                    "name": "document_type",
                    "type": "SELECT",
                    "label": "Document type",
                    "selectChoices": [
                        { "value": "id", "label": "Id Card"},
                        { "value": "passport", "label": "Passport"}
                    ]
                },
                {
                    "name": "number",
                    "type": "STRING",
                    "label": "Number of your Id card",
                    "visibilityCondition": "model.document_type == 'id'"
                },
                {
                    "name": "number",
                    "type": "STRING",
                    "label": "Number of your Passport",
                    "visibilityCondition": "model.document_type == 'passport'"
                }
            ]
        }
        




## DSS object parameters

  * **API_SERVICE** : A DSS API service.

  * **API_SERVICE_VERSION** : A version package among a specified API service. This type requires an `apiServiceParamName` to point to another parameter that has the type **API_SERVICE**. See Usage of apiServiceParamName.

  * **BUNDLE** : An automation bundle.

  * **CLUSTER** : A DSS cluster.

  * **CODE_ENV** : A DSS code environment.

  * **CONNECTIONS** : One or more connections.

  * **DATASET** : Select exactly one dataset.

  * **DATASET_COLUMN** : A column from a specified dataset. This type requires a `datasetParamName` to point to another parameter that has the type. See Usage of datasetParamName. (Note that this is probably not what you want for recipes, see the COLUMN type).

  * **DATASET_COLUMNS** : One or more columns from a specified dataset.

  * **DATASETS** : One or more datasets.

  * **KNOWLEDGE_BANK** : A DSS knowledge bank.

  * **LLM** : An LLM, part of the LLM Mesh. Selection can be restricted with `llmUsagePurpose`.

  * **MANAGED_FOLDER** : A DSS managed folder (appears in the flow).

  * **ML_TASK** : A task in a visual analysis. This type requires `visualAnalysisParamName` to point to a **VISUAL_ANALYSIS** parameter. See Usage of visualAnalysisParamName.

  * **PLUGIN** : A DSS plugin.

  * **PROJECT** : A Dataiku DSS project

  * **SAVED_MODEL** : A DSS saved model (deployed version of a model that appears on the flow)

  * **SCENARIO** : A DSS scenario.

  * **VISUAL_ANALYSIS** : A visual analysis.




Specific fields:

  * `datasetParamName`: For **DATASET_COLUMN(S)** only. Parameter name of the related dataset.

  * `apiServiceParamName`: For **API_SERVICE_VERSION** only. Parameter name of the related API Service.

  * `canSelectForeign` (boolean, default false): For **DATASET(S)** , **SAVED_MODEL** and **MANAGED_FOLDER** only. Should this parameter show elements from other projects?

  * `visualAnalysisParamName`: For **ML_TASK** only. Parameter name of the related visual analysis.

  * `llmUsagePurpose`: For **LLM** only. Restrict selection to LLMs that fit a purpose (`GENERIC_COMPLETION` by default, can also be: `TEXT_EMBEDDING_EXTRACTION`, `IMAGE_EMBEDDING_EXTRACTION`, `IMAGE_GENERATION` or `IMAGE_INPUT`).




These objects return either the id or the name to be able to retrieve the information in the associated component code.

### Examples

#### Usage of `datasetParamName`
    
    
    {
      "type": "DATASET",
      "name": "mydataset",
      "label": "Dataset to analyze"
    },
    {
      "type": "DATASET_COLUMN",
      "name": "mycolumn",
      "datasetParamName": "mydataset",
      "label": "Column in the dataset to analyze"
    }
    

#### Usage of `apiServiceParamName`
    
    
    "params": [
        {
            "name": "input_dataset",
            "type": "DATASET",
            "label": "Input dataset"
        },
        {
            "name": "input_api_service",
            "type": "API_SERVICE",
            "label": "API Service"
        },
        {
            "name": "input_api_service_version",
            "type": "API_SERVICE_VERSION",
            "apiServiceParamName": "input_api_service",
            "label": "API Service version package",
            "description": "retrieved from the API Service stated above"
        }
    ]
    

#### Usage of `visualAnalysisParamName`
    
    
    {
      "type": "VISUAL_ANALYSIS",
      "name": "myvisualanalysis",
      "label": "Visual analysis to use"
    },
    {
      "type": "ML_TASK",
      "name": "mymltask",
      "visualAnalysisParamName": "myvisualanalysis",
      "label": "Task of the visual analysis to use"
    }
    

### Selecting columns in plugin recipes

In recipes, it’s common to want to select one or several columns from one of the input datasets. This is done using parameter types:

  * **COLUMN** : Select exactly one column

  * **COLUMNS** : select one or more columns




You will need to give the name of the _role_ from which you want to select a column using `columnRole` field. Note that if the given role is multi-dataset, only the columns from the first dataset will be displayed.

Example:
    
    
    {
      "name": "incol",
      "label": "Input column",
      "type": "COLUMN",
      "columnRole": "input_role_1"
    }
    

Optionally, you can use the field `allowedColumnTypes` to trigger an error message when the user selects a column with an invalid storage type.

For example, the following COLUMN parameter will raise error messages for non-numerical columns:
    
    
    {
      "name": "numerical_column",
      "label": "Numerical column",
      "type": "COLUMN",
      "allowedColumnTypes": [
          "tinyint",
          "smallint",
          "int",
          "bigint",
          "float",
          "double"
      ],
      "columnRole": "input_dataset",
      "mandatory": true
    }
    

You can choose the following storage types : `string`, `date`, `geopoint`, `geometry`, `array`, `map`, `object`, `boolean`, `double`, `float`, `bigint`, `int`, `smallint`, `tinyint`.

Note

  * Custom preparation processors do not support the field `allowedColumnTypes`.




## Other types

### Preset parameters

You can select some pre-defined values with a **PRESET** parameter.

When you develop or use a plugin, you may need to share some settings across different components. For example, a custom recipe or a custom dataset may have some common parameters like user credentials. In this case, we recommend using presets to store and interact with these shared parameters.

It is possible to input the value of a PRESET :

  * **At the instance level:** The admins of the instance input the values of the presets in the settings tab of the plugin.

  * **At the project level:** The administrators of the project input the values in the settings of the project. Settings > Plugins presets.

  * **At the component level:** If the settings of the preset allow it, the user can also input the values of the preset in the settings of the component.




To use a PRESET type, you must :

  1. Create a Parameter Set in your plugin. If you edit the plugin with the plugin developer tools, go to the main page of the plugin > click on **\+ New component > Parameter set**.

  2. Reference the Parameter set when defining the preset using the field :



  * `parameterSetId`: parameter set of which we should see the values listed.




Example
    
    
    {
      "type": "PRESET",
      "name": "aws_account",
      "label": "Choose which account to use",
      "parameterSetId": "aws_accounts"
    }
    

The Amazon comprehend plugin contains preset parameters. See its source code to see how to set up a [preset](<https://github.com/dataiku/dss-plugin-amazon-comprehend-nlp-medical/blob/main/custom-recipes/amazon-comprehend-nlp-medical-entity-recognition/recipe.json>) and a [parameter set](<https://github.com/dataiku/dss-plugin-amazon-comprehend-nlp-medical/blob/main/parameter-sets/api-configuration/parameter-set.json>).

### Credential requests

  * **CREDENTIAL_REQUEST** : This generates a request for a per-user credential. Once a preset of the parameter set is instantiated, each user will then be able to add their credential in Profile > Credentials. This parameter type is only accepted in the `params` section of a parameter set.




A `credentialRequestSettings` object must be added to define the credential request. This object contains:

  * `type`: The type of credential. Must be one of `SINGLE_FIELD`, `BASIC`, or `OAUTH2`




For `OAUTH2`, the following fields must/may be added to the `credentialRequestSettings` object:

  * `authorizationEndpoint`: The authorization endpoint of the OAuth2 authorization server

  * `tokenEndpoint`: The token endpoint of the OAuth2 authorization server

  * `scope`: [Optional] Should be a space-delimited string

  * `resources`: [Optional] Rarely used. Must be a list of strings

  * `refreshTokenRotation`: [Optional] Boolean describing whether to grant a new refresh token at each access token refresh. Default value is false.




Additionally, for `OAUTH2`, once a preset of this parameter set is instantiated, you must enter in the Client ID and Client Secret (if applicable) that is configured for your registered application on the OAuth2 server. See [OAuth2 credentials](<../installed.html#plugins-installed-oauth2-credentials>) for more information.

These credentials will then be available for use by plugin code (see Read the settings of a plugin). For example, for a `BASIC` credential, the username and password will be available in the settings, while for an `OAUTH2` credential, a valid OAuth2 access token will be in the settings.

In Python plugin code, you can use the OAuth helper to access tokens and handle refresh automatically when needed:
    
    
    from dataiku.core import plugin
    
    credentials_example = plugin.OAuthCredentials(config["<preset-name>"]["__credentials"]["<parameter-name>"])
    
    # The property getter checks expiry and refreshes credentials when needed
    credentials_example.access_token
    credentials_example.id_token  # If it exists
    

Warning

Webapps do not currently support refreshing credentials.

Examples:
    
    
    {
      "type": "CREDENTIAL_REQUEST",
      "name": "basic_credentials",
      "label": "Basic credentials",
      "credentialRequestSettings": {
        "type": "BASIC"
      }
    },
    {
      "type": "CREDENTIAL_REQUEST",
      "name": "oauth_credentials",
      "label": "OAuth2 credentials",
      "credentialRequestSettings": {
        "type": "OAUTH2",
        "authorizationEndpoint": "https://authserver.com/oauth2/authorize",
        "tokenEndpoint": "https://authserver.com/oauth2/token",
        "scope": "scope1 user.scope2"
      }
    }
    

### Separators

Finally, there is a special parameter type called SEPARATOR, used just for display purposes to separate the form into sections. The `description` field can be used to display additional information. In this description, you can use HTML tags to format the description.

## Fully custom UI

You can specify fully custom HTML/JavaScript, see [Other topics](<other.html>)

## Plugin-level configuration

Just like each dataset and recipe can accept params, so can a plugin. Plugin-level configuration allows you to have a centralized configuration that is shared by all datasets and all recipe instances of this plugin.

Another characteristic of plugin-level config is that it’s only readable and writable by the Administrator. As such, it can be the right place to store API keys, credentials, connection strings, …

### Add settings to a plugin

To add settings to a plugin, edit the plugin.json file and add a `"params"` array in the JSON top-level object. The structure of this params array is similar to the one of datasets and recipes. As a best practice, avoid parameter names that start with `_` (underscore), since DSS may use this prefix for internal parameters.

### Read the settings of a plugin

  * Datasets receive the plugin config (as a Python dict) in the constructor of their connector class. See the documentation of the Connector class or the automatically generated sample for more information.

  * Python recipes can read the plugin config (as a Python dict) by calling the `dataiku.customrecipe.get_plugin_config()` function

  * R recipes can read the plugin config by calling the `dataiku::dkuPluginConfig()` function

---

## [plugins/reference/plugins-components]

# Plugin Components

## Existing components

A plugin is made of a number of **components**. Each component is a single kind of object in Dataiku DSS, such as a dataset, recipe, or webapp. Each component adds functionality to a plugin. A plugin bundles components together as a single consistent whole.

The (non-exhaustive) list of plugin components includes:

  * Dataset

  * [Recipe](<recipes.html>)

  * [Macros](<macros.html>)

  * [File Format](<file-format.html>)

  * [Sample Dataset](<samples.html>)

  * Format extractors/exporters

  * Format exporters

  * [Filesystem providers](<fsproviders.html>)

  * Metric probes and checks

  * Scenario triggers and steps

  * Preparation processor steps

  * Shared code to import into recipes or notebooks

  * [Webapps](<webapps.html>)

  * [Prediction algorithm](<prediction-algorithms.html>)

  * [Feature preprocessor](<ml-preprocessors.html>)

  * [Custom Fields](<custom-fields.html>)

  * Parameter set

  * Custom Policy Hooks




See also

Multiple tutorials on this subject are found in the Developer Guide [Plugins development](<https://developer.dataiku.com/latest/tutorials/plugins/index.html> "\(in Developer Guide\)").

The most up-to-date list of possible components can be found in the product. In the plugin editor, click **\+ Add > Create component**. The resulting dialog shows the list of possible components. When you add a component, Dataiku DSS automatically makes the appropriate additions to the plugin directory structure and adds some starter code to help you get started.

## Structure of a plugin

The elements of a plugin are contained within a top-level directory that identifies the plugin. When you create a plugin from scratch (called, for example, `myplugin`), that top-level directory contains:

  * A `python-lib` subdirectory with a `myplugin` subdirectory that has an `__init__.py` file that is empty of code. The `python-lib` directory is a good place to put functions that will be reused throughout the plugin.

  * A `plugin.json` file that describes the plugin as a whole.

>     * As a best practice, the `id` element of this JSON file should be the same as the name of the top-level directory.




For example, the `plugin.json` shown below leads to the Fig. 1.
    
    
    {
        // Plugin identifiers are globally unique and only contain A-Za-z0-9_-
        "id": "timeseries-preparation",
    
        // It is highly recommended to use Semantic Versioning
        "version": "2.0.1",
    
        // Meta data for display purposes:
        "meta": {
            // label: name of the plugin as displayed, should be short
            "label": "Time Series Preparation",
            // description: longer string to help end users understand what this plugin does
            "description": "Perform resampling, windowing operations, interval extraction, extrema extraction, and decomposition on time series data (one row per time stamp).",
    
            "author": "Dataiku (Du PHAN and Marine SOBAS)",
    
            // icon: must be one of the FontAwesome 3.2.1 icons, complete list here at https://fontawesome.com/v3.2.1/icons/
            "icon": "icon-time",
    
            "licenseInfo": "Apache Software License",
    
            // URL where the user can learn more about the plugin
            "url": "https://www.dataiku.com/dss/plugins/info/time-series-preparation.html",
    
            // List of tags for filtering the list of plugin
            "tags": [
                "Time Series"
            ]
        }
    }
    

Description of a plugin.

## Generic information about the Components of a plugin

### Components

As you add components to the plugin, this adds to the plugin folder structure. Each type of component has a subdirectory under the top-level directory. Each component has a directory that contains a JSON file that describes the component as a whole, and code files that define what the component does.

### Parameters

Each component generally has some [configuration parameters](<params.html>) and has a metadata section.

### Metadata section

Metadata is used for display purposes. You can configure the name of the component as well as its description and the icon used to represent the component, by filling out the “meta” field as shown below.
    
    
    "meta": {
        // label: name of the component as displayed, should be short
        "label": "Short title",
    
        // description: longer string to help end users understand what this component does
        "description": "A longer description that helps the user understand the purpose of the component",
    
        // icon: must be one of the FontAwesome 3.2.1 icons, complete list here at https://fontawesome.com/v3.2.1/icons/
        "icon": "icon-puzzle-piece"
    },

---

## [plugins/reference/prediction-algorithms]

# Component: Prediction algorithm

Dataiku DSS offers a variety of [algorithms](<../../machine-learning/algorithms/index.html>) to address [prediction](<../../machine-learning/supervised/index.html>) problems.

This plugin component allows to extend the list of available algorithms, in order to help data scientists expose their custom algorithms to other users.

## First example

To start adding prediction algorithms, we recommend that you use the plugin developer tools (see the tutorial for an introduction). In the Definition tab, click on “+ NEW COMPONENT”, choose ”Prediction Algorithms”, and enter the identifier for your new algorithm. You’ll see a new folder `python-prediction-algos` and will have to edit:

  * the `algo.json` file, containing the various parameters of your algo

  * the `algo.py` file, containing the code of your algorithm




A basic prediction algorithm’s description to add the scikit learn [AdaboostRegressor](<https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.AdaBoostRegressor.html>) algorithm looks like this:
    
    
    {
        "meta" : {
            "label": "Custom algo test_my-algo",
            "description": "This is the description of the Custom algo test_my-algo",
            "icon": "icon-puzzle-piece"
        },
    
        "predictionTypes": ["REGRESSION"],
        "gridSearchMode": "MANAGED",
        "supportsSampleWeights": true,
        "acceptsSparseMatrix": false,
    
        "params": [
            {
                "name": "n_estimators",
                "label": "num estimators",
                "description": "The maximum number of estimators",
                "type": "DOUBLES",
                "defaultValue": [50, 100],
                "allowDuplicates": false,
                "gridParam": true
            },
            {
                "name": "loss",
                "label": "loss",
                "description": "Type of loss used.",
                "type": "MULTISELECT",
                "defaultValue": ["linear"],
                "selectChoices": [
                    {
                        "value":"linear",
                        "label":"linear"
                    },
                    {
                        "value":"square",
                        "label":"square"
                    },
                    {
                        "value":"exponential",
                        "label": "exponential"
                    }
                ],
                "gridParam": true
            },
            {
                "name": "random_state",
                "label": "Random state",
                "type": "DOUBLE",
                "defaultValue": 1337
            }
        ]
    }
    

and the corresponding python code:
    
    
    from dataiku.doctor.plugins.custom_prediction_algorithm import BaseCustomPredictionAlgorithm
    from sklearn.ensemble import AdaBoostRegressor
    
    class CustomPredictionAlgorithm(BaseCustomPredictionAlgorithm):
        """
            Args:
                prediction_type (str): type of prediction for which the algorithm is used. Is relevant when
                                    algorithm works for more than one type of prediction.
                params (dict): dictionary of params set by the user in the UI.
        """
    
        def __init__(self, prediction_type=None, params=None):
            self.clf = AdaBoostRegressor(random_state=params.get("random_state", None))
            super(CustomPredictionAlgorithm, self).__init__(prediction_type, params)
    
        def get_clf(self):
            """
            This method must return a scikit-learn compatible model, ie:
            - have a fit(X,y) and predict(X) methods. If sample weights
            are enabled for this algorithm (in algo.json), the fit method
            must have instead the signature fit(X, y, sample_weight=None)
            - have a get_params() and set_params(**params) methods
            """
            return self.clf
    

Once the plugin component is added, it will be available in the visual ML Lab, as any other algorithm.

## Algorithm description

Each algorithm description has the following structure:

  * `predictionTypes`: List of types of prediction for which the algorithm will be available. Possible values are: [“BINARY_CLASSIFICATION”, “MULTICLASS”, “REGRESSION”].

  * `gridSearchMode`: How DSS handles gridsearch. See Grid search.

  * `supportsSampleWeights`: Whether the model supports or not sample weights for training. If yes, the clf from algo.py must have a `fit(X, y, sample_weights=None)` method. If not, sample weights are not applied on this algorithm, but if they are selected for training, they will be applied on scoring metrics and charts.

  * `acceptsSparseMatrix`: Whether the model supports sparse matrices for fitting and predicting, i.e. if the `clf` provided in algo.py accepts a sparse matrix as argument for its `fit` and `predict` methods.

  * `params`: List of plugin [parameters](<params.html>) that can be leveraged by the model, and potentially the grid search (See Grid search).

  * `meta`: Description of the component. Similar to other plugin components.




## Algorithm python object

The `BaseCustomPredictionAlgorithm` defines a `get_clf` method that must return a _scikit-learn compatible_ object. This means that the model must:

  * have `fit(X,y)` and `predict(X)` methods. If sample weights are enabled for this algorithm (in `algo.json`), the fit method must have instead the signature `fit(X, y, sample_weight=None)`.

  * have `get_params()` and `set_params(**params)` methods.




Moreover, the model can implement a function called `set_column_labels(self, column_labels)` if it needs to have access to the column names of the preprocessed dataset.

For further information, please refer to [Custom Models](<../../machine-learning/algorithms/in-memory-python.html#custom-models>).

## Usage of a code-env

DSS allows the user to create and use [code environments](<../../code-envs/index.html>) to be able to leverage external packages.

Plugin algorithms cannot use the [plugin code-env](<other.html>).

If the algorithm code relies on external libraries, a dedicated code-env must be created on the Dataiku DSS instance on which the plugin is installed. This code env must contain both:

  * the packages required for Visual Machine Learning

  * the packages required for your algorithm




This code env must then be _manually_ selected by the end-user running this plugin algorithm.

## Grid search

Plugin models offer the possibility to run grid search, i.e. testing several values for various hyper parameters and taking the ones that yield the best results. To do so, there are two modes of grid search `MANAGED` or `CUSTOM`, which are set by the `gridSearchMode` field.

Under the hood, DSS builds the hyperparameter grid out of the params, and for each grid point, it does `clf.set_params(**grid_point_params)`. Then, DSS handles the optimization using the same [mechanism](<../../machine-learning/advanced-optimization.html>) as for the other visual algorithms.

If you do not want to do grid search, you can set `gridSearchMode: "NONE"`.

### Managed grid search

For the MANAGED mode, the user needs to define grid params in algo.json by setting `"gridParam": true` for each grid param. Those parameters are the parameters over which the grid will be built.

Acceptable grid params are arrays, supported values are STRINGS, MULTISELECT, ARRAY, and DOUBLES.

For example, to re-implement the [Extra Random Trees algorithm](<../../machine-learning/algorithms/in-memory-python.html#regression-classification-extra-random-trees>) with a managed gridsearch plugin algorithm, the description looks like:
    
    
    {
        "meta" : {
            "label": "Custom Extra Random Trees",
            "description": "Reimplementation of Extra Random Trees",
            "icon": "icon-puzzle-piece"
        },
        "predictionTypes": ["BINARY_CLASSIFICATION"],
        "gridSearchMode": "MANAGED",
        "supportsSampleWeights": true,
        "params": [
            {
                "name": "n_estimators",
                "type": "DOUBLES",
                "defaultValue": [30],
                "label": "Numbers of trees",
                "description": "Number of trees in the forest.",
                "gridParam": true
            },
            {
                "name": "max_depth",
                "gridParam": true,
                "type": "DOUBLES",
                "defaultValue": [8],
                "label": "Maximum depth of tree",
                "description": "Maximum depth of each tree in the forest. Higher values generally increase ..."
            },
            {
                "name": "min_samples_leaf",
                "gridParam": true,
                "type": "DOUBLES",
                "defaultValue": [3],
                "label": "Minimum samples per leaf",
                "description": "Minimum number of samples required in a single tree node to split this node. Lower values increase ..."
            },
            {
                "name": "n_jobs",
                "type": "INT",
                "defaultValue": 4,
                "label": "Parallelism",
                "description": "Number of cores used for parallel training. Using more cores leads to faster ..."
            }
        ]
    }
    

In that case, `n_jobs` is not a grid param because it can only take one value.

The `algo.py` looks like this:
    
    
    from sklearn.ensemble import ExtraTreesClassifier
    from dataiku.doctor.plugins.custom_prediction_algorithm import BaseCustomPredictionAlgorithm
    
    class CustomPredictionAlgorithm(BaseCustomPredictionAlgorithm):
    
        def __init__(self, prediction_type=None, params=None):
            # setting non grid-search params
            self.clf = ExtraTreesClassifier(random_state=1337, n_jobs=params["n_jobs"])
            super(CustomPredictionAlgorithm, self).__init__(prediction_type, params)
    
        def get_clf(self):
            return self.clf
    

In this case `ExtraTreesClassifier` is a scikit learn model, so already has all the required attributes and methods.

### Custom grid search (Advanced)

To do a more complex grid search, you can use the `CUSTOM` mode. In that mode, you need to manually build the grid in a `get_grid` function of the `CustomPredictionAlgorithm` class. It must return either:

  1. A dictionary where each key is the name of the param, and each value a **list** of potential values, e.g. `{ "paramA": [a1, a2], "paramB": [b1, b2] }`, which will get expanded by cartesian product into grid `a1+b1`, `a1+b2`, `a2+b1`, `a2+b2`.

  2. A list of dictionaries with such possibilities: `[{"withA": false}, {"withA": true, "paramA": [a1, a2]}]`, which will get expanded into grid `false`, `true,a1`, `true,a2`. This is useful when the grid is not just the cartesian product of the parameter values, because some parameters condition others.




To re-implement the [Logistic regression algorithm](<../../machine-learning/algorithms/in-memory-python.html#classification-logistic-regression>) used for classification, the algorithm description looks like this:
    
    
    {
        "meta" : {
            "label": "Custom Logistic Regression",
            "description": "Reimplementation of Logistic Regression",
            "icon": "icon-puzzle-piece"
        },
    
        "predictionTypes": ["BINARY_CLASSIFICATION"],
        "gridSearchMode": "CUSTOM",
        "supportsSampleWeights": true,
        "params": [
            {
                "name": "l1_regularization",
                "label": "l1_regularization",
                "description": "Try with L1 regularization.",
                "type": "BOOLEAN",
                "defaultValue": true
            },
            {
                "name": "l2_regularization",
                "label": "l2_regularization",
                "description": "Try with L2 regularization.",
                "type": "BOOLEAN",
                "defaultValue": true
            },
            {
                "name": "C",
                "label": "C",
                "description": "Penalty parameter C of the error term.",
                "type": "DOUBLES",
                "defaultValue": [0.01, 0.1, 1]
            }
        ]
    }
    

In this case, parameters are not directly convertible into a grid, so we need to write a `get_grid` method like this:
    
    
    from sklearn.linear_model import LogisticRegression
    from dataiku.doctor.plugins.custom_prediction_algorithm import BaseCustomPredictionAlgorithm
    
    class CustomPredictionAlgorithm(BaseCustomPredictionAlgorithm):
    
        def __init__(self, prediction_type=None, params=None):
            self.clf = LogisticRegression(random_state=1337)
            # saving params for further use
            self.params = params
            super(CustomPredictionAlgorithm, self).__init__(prediction_type, params)
    
        def get_clf(self):
            return self.clf
    
        def get_grid(self):
            # retrieving params and manually building the grid
            if self.params is None or len(self.params) == 0:
                return {}
            grid_params = {}
    
            regularization = []
            if self.params.get("l1_regularization", False):
                regularization.append("l1")
            if self.params.get("l2_regularization", False):
                regularization.append("l2")
            if len(regularization) > 0:
                grid_params["penalty"] = regularization
    
            if "C" in self.params.keys():
                c_params = self.params["C"]
                if isinstance(c_params, list) and len(c_params) > 0:
                    grid_params["C"] = c_params
    
            return grid_params

---

## [plugins/reference/preparation]

# Component: Preparation Processor

Preparation processors are additional steps you can add to a Prepare recipe Script.

To create a new Preparation processor, we recommend that you use the plugin developer tools (see the tutorial for an introduction). In the Definition tab, click on “+ ADD COMPONENT”, choose ”PREPARATION PROCESSOR”, and enter the identifier for your new processor. You’ll see a new folder named after your identifier containing 2 files: `processor.json` and `processor.py`.

A basic processor definition looks like:
    
    
    {
        "meta" : {
            "label" : "Custom processor",
            "description" : "",
            "icon" : "icon-puzzle-piece"
        },
        "mode": "CELL",
        "params" : [
            {
                "name": "param1",
                "label": "Parameter 1",
                "type": "STRING",
                "description": "Some documentation for parameter1",
                "mandatory": true
            }
        ]
    }
    

A basic implementation looks like:
    
    
    def process(row):
        # row is a dict of the row on which the step is applied
        param1_value = params.get('param1')
        return param1_value
    

The “meta” field is similar to all other kinds of DSS components.

## Output single column

When `mode` is set to `CELL` in the descriptor, the preparation processor outputs a single column.

To generate the values for this output column, DSS calls the `process` function of the processor for each rows of the dataset, and stores the returned value in the output column for the associated row.

The following implementation creates a new column containing a salutation message using the `Name` column in the input dataset.
    
    
    def process(row):
        return "Dear " + row['Name']
    

To allow end-users to select an input column, you add a parameter of type COLUMN.
    
    
    {
        "meta" : {
            "label" : "Custom processor (cell)",
            "description" : "",
            "icon" : "icon-puzzle-piece"
        },
        "mode": "CELL",
        "params" : [
            {
                "name": "input_column",
                "label": "Input column",
                "type": "COLUMN",
                "description": "Column containing the name of the person",
                "columnRole": "main",
                "mandatory": true
            }
        ]
    }
    
    
    
    def process(row):
        input_column = params.get('input_column')
        return "Dear " + row[input_column]
    

## Output multiple columns

To output or modify more than one column, `mode` must be set to `ROW` in the descriptor.

The implementation of your `process` function must return a `dict` where each key/value represent a cell in the row. You usually will return the `row` object received as argument after your modifications.

To configure the names of the output columns, you add one parameter per output column.
    
    
    {
        "meta" : {
            "label" : "Custom processor (row)",
            "description" : "",
            "icon" : "icon-puzzle-piece"
        },
        "mode": "ROW",
        "params" : [
            {
                "name": "input_column",
                "label": "Input column",
                "type": "COLUMN",
                "description": "Column containing the name of the person",
                "columnRole": "main",
                "mandatory": true
            },
            {
                "name": "salutation_column",
                "label": "Salutation column",
                "type": "COLUMN",
                "description": "Output for salutation message",
                "columnRole": "output_salutation"
            },
            {
                "name": "greeting_column",
                "label": "Greeting column",
                "type": "COLUMN",
                "description": "Output column for greeting message",
                "columnRole": "output_greeting"
            }
        ]
    }
    

For example, to generate 2 additional columns containing a salutation and a greeting message for each person in the dataset, you would use the above descriptor and this implementation:
    
    
    def process(row):
        input_column = params.get('input_column')
    
        salutation_column = params.get('salutation_column')
        if salutation_column is not None and salutation_column != "":
            row[salutation_column] = "Dear " + row[input_column]
    
        greeting_column = params.get('greeting_column')
        if greeting_column is not None and greeting_column != "":
            row[greeting_column] = "Hello " + row[input_column]
    
        return row
    

## Using code environment for a processor

To use the [code environment](<other.html#other-code-env>) defined for the processor, add an additional parameter “useKernel” within the `processor.json`.

The updated processor definition looks like:
    
    
    {
        "meta" : {
            "label" : "Custom processor",
            "description" : "",
            "icon" : "icon-puzzle-piece"
        },
        "mode": "CELL",
        "params" : [
            {
                "name": "param1",
                "label": "Parameter 1",
                "type": "STRING",
                "description": "Some documentation for parameter1",
                "mandatory": true
            }
        ],
        "useKernel" : true
    }
    

The plugin will need to be reloaded after making the above change.

---

## [plugins/reference/project-creation-macros]

# Component: Project creation macros

Project creation build upon macros. You should thus be familiar with macros. For more information, please see [Component: Macros](<macros.html>)

Please see [Creating projects through macros](<../../concepts/projects/creating-through-macros.html>) for details on why you would use project creation macros. A user needs to be granted the [Create projects using macros](<../../security/permissions.html#projects-creation>) permission to use a project macro.

To start creating a project creation macro, we recommend that you use the plugin developer tools (see the tutorial for an introduction). In the Definition tab, click on “Add Python macro”, and enter the identifier for your new macro. You’ll see a new folder `python-runnables` and will have to edit the `runnable.py` and `runnable.json` files

A project macro is essentially a macro that will run _non-impersonated_ , which allows it to have full control over DSS. It receives the identity of the end-user request Python function, thus allowing to perform logic based on this identity.

The project creation macro is responsible for actually creating the project, and setting up permissions.

In order to perform privileged operations, the project creation macro must obtain a privileged API key as shown in the example below.

Attention

The `resultType` must be set to `JSON_OBJECT` for this specific macro component, and the macro should return a JSON object containing a `projectKey`.

See also

A tutorial on this plugin component is available in the Developer Guide: [Writing a macro for project creation](<https://developer.dataiku.com/latest/tutorials/plugins/macros/project-creation/index.html> "\(in Developer Guide\)").

## Example: Create project with a default code env

The `runnable.json` file looks like:
    
    
    {
        "meta": {
            "label": "New project with code env",
            "description": "Blabla",
            "icon": "icon-puzzle-piece"
        },
    
        "impersonate": false,
    
        "params": [
            {
                "name": "projectName",
                "label": "Project name",
                "type": "STRING",
                "mandatory": true
            },
            {
                "name": "pyCodeEnvName",
                "label": "Python Code env name",
                "type": "STRING",
                "defaultValue": "python3"
            }
        ],
    
        "resultType": "JSON_OBJECT",
    
        "macroRoles": [
            {"type": "PROJECT_CREATOR"}
        ]
    }
    

The two important parts here are:

  * The macroRoles field defines this as a project creation macro

  * The impersonate field makes the macro privileged




The “meta” and “params” fields are similar to all other kinds of DSS components.

The associated Python code is:
    
    
    import dataiku
    from dataiku.runnables import Runnable
    from dataiku.runnables import utils
    import json
    
    class MyRunnable(Runnable):
    
        def __init__(self, unused, config, plugin_config):
            # Note that, as all macros, it receives a first argument
            # which is normally the project key, but which is irrelevant for project creation macros
            self.config = config
    
        def get_progress_target(self):
            return None
    
        def run(self, progress_callback):
            # Get the identity of the end DSS user
            user_client = dataiku.api_client()
            user_auth_info = user_client.get_auth_info()
    
            # Automatically create a privileged API key and obtain a privileged API client
            # that has administrator privileges.
            admin_client = utils.get_admin_dss_client("creation1", user_auth_info)
    
            # The project creation macro must create the project. Therefore, it must first assign
            # a unique project key. This helper makes this easy
            project_key = utils.make_unique_project_key(admin_client, self.config["projectName"])
    
            # The macro must first perform the actual project creation.
            # We pass the end-user identity as the owner of the newly-created project
            print("Creating project")
            admin_client.create_project(project_key, self.config["projectName"], user_auth_info["authIdentifier"])
    
            # Now, this macro sets up the default Python code environment, using the one specified by the user
            print("Configuring project")
            project = user_client.get_project(project_key)
    
            # Move the project to the current project folder, passed in the config as _projectFolderId
            project.move_to_folder(user_client.get_project_folder(self.config['_projectFolderId']))
    
            settings = project.get_settings()
            settings.set_python_code_env(self.config["pyCodeEnvName"])
            settings.save()
    
            # A project creation macro must return a JSON object containing a `projectKey` field with the newly-created
            # project key
            return json.dumps({"projectKey": project_key})

---

## [plugins/reference/recipes]

# Component: Recipes

## Description

Dataiku DSS comes with some existing [Visual recipes](<../../other_recipes/index.html>) allowing the user to perform standard analytic transformations. Visual recipes perform a transformation in the Flow, but they are not the only way to do it.

Coders can use [Code recipes](<../../code_recipes/index.html>) to code additional transformations particularly when Dataiku DSS does not cover their usage. Code recipes are a good way to extend Dataiku DSS’s capabilities. These user-defined code recipes can be converted to plugin recipes, allowing them to be distributed to non-coder users as a visual recipe.

To be able to convert a code recipe to a plugin recipe:

  * Open the code recipe;

  * Click on the “Action” button (or open the right panel);

  * Click on the “Convert to plugin” button;

  * Fill out the form.




There are two different ways to integrate a plugin recipe. You can choose to add the recipe plugin to an existing plugin. Or, you can choose to create a new plugin, and then add the plugin recipe to this new plugin.

A plugin recipe is configurable in the associated JSON file (automatically created by Dataiku DSS during the conversion process), in the folder `custom-recipes/{<plugin-recipe-id>}/recipe.json`. This JSON configuration file comprise different parts as shown in the code below.
    
    
    {
        // Metadata section
        "meta": {
            //metadata used for display purpose
        },
    
        // Kind of the code recipe
        "kind": "PYTHON",
    
        // Input/Output section
        "inputRoles": [
            // DSS objects that can be used as input for the recipe
            // A recipe can have many different input objects
        ],
        "outputRoles": [
            // DSS objects that can be used as output for the recipe
            // A recipe can have many different output objects
        ],
    
        // Parameters section
        "params": [
            // Parameter definition usable for your recipe
        ],
    
        // Advanced configuration section
        // various configuration options.
    
    }
    

Write the plugin recipe code in the file `recipe.py`. It should, at least, read the input parameter and produce the dataset mentioned in the output section, like described below.
    
    
    # To retrieve the datasets of an input role named 'input_A' as an array of dataset names:
    dataset_name = get_input_names_for_role('dataset_input')[0]
    
    # For outputs, the process is the same:
    output_name = get_output_names_for_role('dataset_output')[0]
    
    # Read recipe inputs
    df = dataiku.Dataset(dataset_name).get_dataframe()
    
    # In this example, we just copy the input to the output
    
    # Write recipe outputs
    output_dataset = dataiku.Dataset(output_name)
    output_dataset.write_with_schema(df)
    

## Metadata

Metadata is used for display purposes. You can configure the name of the recipe as well as its description, the icon used to represent the recipe and also the color of this icon, by filling out the `"meta"` field as shown below.

See also

Multiple tutorials on this subject are found in the Developer Guide [Recipes](<https://developer.dataiku.com/latest/tutorials/plugins/recipes/index.html> "\(in Developer Guide\)").

### Example
    
    
    "meta": {
        // label: name of the recipe as displayed, should be short
        "label": "Short title",
    
        // description: longer string to help end users understand what this recipe does
        "description": "A longer description that helps the user understand the purpose of the recipe",
    
        // icon: must be one of the FontAwesome 3.2.1 icons, complete list here at https://fontawesome.com/v3.2.1/icons/
        "icon": "icon-thumbs-up-alt",
    
        // DSS currently supports the following colors: red, pink, purple, blue, green, sky, yellow, orange, brown, and gray.
        "iconColor": "blue"
    },
    

## Input/Output

Each input/output role has the following structure:

  * `name`: Name of the role; this is how the role is referenced elsewhere in the code

  * `label`: A displayed name for this role

  * `description`: A description of what the role means

  * `arity`: UNARY or NARY (can accept one or multiple values?)

  * `required` (boolean, default false): Does this role need to be filled?

  * `acceptsDataset` (boolean, default true): Whether a dataset can be used for this role

  * `acceptsManagedFolder` (boolean, default false): Whether a managed folder can be used for this role

  * `acceptsSavedModel` (boolean, default false): Whether a saved model can be used for this role




Grouping input/output into roles enables the coder (and the user) to group their input/output into semantic groups of data, rather than having all the input/output at the same level.

### Example
    
    
    "inputRoles": [
        {
            "name": "dataset_names",
            "label": "input A displayed name",
            "description": "what input A means",
            "arity": "NARY",
            "required": true,
            "acceptsDataset": true
        },
        {
            "name": "managed_folder_name",
            "label": "input B displayed name",
            "description": "what input B means",
            "arity": "UNARY",
            "required": false,
            "acceptsDataset": false,
            "acceptsManagedFolder": true
        }
    

## Parameters

From a parameter perspective, a plugin code recipe is not different than other plugin components. However, for the plugin code recipe, there are two types of parameters (**COLUMN** and **COLUMNS**). They allow the user to select one (or more) column(s) in a dataset as parameter(s) for the plugin code recipe. For more about parameters, please see [Parameters](<params.html>).

## Advanced configuration

### Select from Flow view

To make a new recipe directly available from the Flow view when selecting:

  * a Dataset, add the field: `"selectableFromDataset"`

  * a Managed Folder, add the field: `"selectableFromFolder"`

  * an ML Saved Model, add the field: `"selectableFromMLModel"`

  * a GenAI Model or Agent, add the field: `"selectableFromPromptableModel"`




Each added field should target an existing inputRole, see below for the usage.

## Complete example
    
    
    {
        "meta": {
            "label": "Clip values",
            "description": "Allow clipping values on different columns",
            "icon": "icon-align-justify",
            "iconColor": "orange"
        },
        "kind": "PYTHON",
        "inputRoles": [
            {
                "name": "dataset_name",
                "label": "Datasets to clip",
                "description": "Automatically remove outliers from a dataset, by clipping the values",
                "arity": "UNARY",
                "required": true,
                "acceptsDataset": true
            },
            {
                "name": "managed_folder_name",
                "label": "dummy input",
                "description": "just here to demonstrate selection from the flow",
                "arity": "UNARY",
                "required": false,
                "acceptsDataset": false,
                "acceptsManagedFolder": true
            }
        ],
        "outputRoles": [
            {
                "name": "dataset_clipped",
                "label": "Clipped dataset",
                "description": "Result of the clipping",
                "arity": "UNARY",
                "required": true,
                "acceptsDataset": true
            }
        ],
        "params": [
            {
                "name": "IQR_coeff",
                "type": "DOUBLE",
                "defaultValue": 1.5,
                "label": "IQR coefficient",
                "mandatory": true
            }
        ],
        "selectableFromDataset": "dataset_name",
        //The next selectable is just for the example
        "selectableFromFolder": "managed_folder_name",
    
        // The field "resourceKeys" holds a list of keys that allows limiting the number
        // of concurrent executions and activities triggered by this recipe.
        //
        // Administrators can configure the limit per resource key in the Administration > Settings > Flow build
        // screen.
        "resourceKeys": []
    }

---

## [plugins/reference/samples]

# Component: Sample Dataset

## Description

Dataiku DSS gives the ability to kickstart a project by adding ready-to-use datasets, called sample datasets.

Some sample datasets are installed by default. In case you need to add your own sample datasets, you can develop a sample dataset plugin.

See also

A tutorial on this plugin component is available in the Developer Guide: [Sample dataset](<https://developer.dataiku.com/latest/tutorials/plugins/sample-dataset/index.html> "\(in Developer Guide\)").

## Creation

To develop a new sample dataset plugin, go to a development plugin page, click on “+New Component”, then choose “Sample Dataset” from the list of components. Choose a name for your component, and click on “Add”.

Note

Once this is done Dataiku DSS opens the code editor, allowing you to update the metadata of your plugin, as well the sample’s content, configuration and resource files.

## Configuration

A sample dataset plugin can be configured via the associated JSON files `dataset.json` and `config_{<version>}.json` (automatically created by Dataiku DSS), in the directory `sample-datasets/{<sample-dataset-id>}`.

Those JSON configuration files comprises different parts as shown in the code below.

Main configuration file of a sample dataset plugin `dataset.json`
    
    
    {
        // Metadata section.
        "meta": {
            // Metadata used for display purposes.
            // See below for more information.
        },
    }
    

Dataset configuration file of a sample dataset plugin `config_{<version>}.json`
    
    
    {
        // Global configuration about the sample data plugin.
        // See below for more information.
        "columns": [...]
    }
    

### Metadata configuration

For the metadata section, the usual configuration applies. Please refer to [Metadata section](<plugins-components.html#plugin-metadata-section>).

There are some additional optional parameters that you may want to fill depending on your needs.

Additional optional metadata parameters of a sample dataset
    
    
    /* Logo used on the Sample Dataset modal to represent your sample */
    "logo": "logo-name.png",
    
    /* Number used to sort the dataset samples by descending order when listed */
    "displayOrderRank": 10,
    
    /* List of available versions in your plugin */
    "versions": ["v1", "v2"],
    
    /* Version of your sample to install by default or when listed in the UI */
    "activeVersion": "v2"
    

#### Logo

If you want to specify a logo for your sample, place the image inside a shared `resource` folder in root of your plugin, and can only contain letters, digits, dots, underscores, hyphens and spaces. Your logo should ideally be an image of 280x200 pixels.

The available extensions for a logo are the following: `.apng`, `.png`, `.avif`, `.gif`, `.jpg`, `.jpeg`, `.jfif`, `.svg`, `.webp`, `.bmp`, `.ico`, `.cur`.

#### Versioning

Use versioning, if you want to update the configuration or content of a sample dataset without impacting the projects or datasets that are currently using them.

To do that, list in the field `versions` the various versions of your dataset, and set in `activeVersion` the default version of the dataset you want to install.

For each version, you must have a dedicated data folder that must be located in `sample-datasets/{<sample-dataset-id>}/data_{<version>}`.

It is also highly recommended that you must have a dedicated configuration file in `sample-datasets/{<sample-dataset-id>}/config_{<version>}.json`. Otherwise, the configuration will be read from the `dataset.json` file.

### Sample data

Your sample data must be comprised of one or several `.csv` file or `.csv.gz` file located here : `sample-datasets/{<sample-dataset-id>}/data_{<version>}/{<sample-file>}`. By default your sample dataset component will be created with a small sample example named `sample.csv`.

Each sample file consists in a CSV file where the separator is a comma `,` and the quote character is a double quote `"`. Ensure that the input CSV files adhere to this format for correct parsing and processing. Each sample file should not contain any header row, as the column names are defined in the JSON configuration file.

You will need at least one sample file to save your plugin.

### Global configuration

For the global configuration, a sample dataset has to define the following in its configuration file `config_{<version>}.json` :

Global configuration of a sample dataset
    
    
    /* The number of rows in your sample, will be displayed when listing the dataset samples */
    "rowCount": 100,
    
    /* Description of the schema of your dataset */
    "columns": [...],
    

#### Schema

The `columns` field is the place where you can specify the schema of your sample dataset, it contains as many columns as your dataset has. Your column should be ordered in the same order than the one in your csv file.

Each column is structured with the following fields :

  * name: unique identifier of the column

  * type: storage type of the column

  * comment (optional): description of the column

  * meaning (optional): “high-level” definition of the column, used to validate the cell. If not set, the meaning will be deduced from the sample content.




For the list of columns types, please refer to [Storage types](<../../schemas/definitions.html#storage-types>)

For the list of available meanings, please refer to [List of recognized meanings](<../../schemas/meanings-list.html>)

Structure of a column
    
    
    {
        /* Unique identifier for your column */
        "name": "columns-name",
        /* Type of the column */
        "type": "double",
        /* Optional description of the column, that will be displayed in the dataset's explore view */
        "comment": "This is the description of my column",
        /* Optional meaning of the column */
        "meaning": "DoubleMeaning"
    }
    

## Complete example

Complete example of the `dataset.json`
    
    
    /* This file is the descriptor for the sample dataset template my-sample-dataset */
    {
        "meta": {
            "label": "Temperature Time Series",
            "description": "This dataset contains daily temperature data over a multi-year period",
            "icon": "fas fa-thermometer",
            "logo": "thermometer-logo.png",
            "displayOrderRank": 100,
            "versions": ["v1"],
            "activeVersion": "v1"
        }
    
    }
    

Complete example of the `config_v1.json`
    
    
    /* This file is the config for the sample dataset template my-sample-dataset version v1 */
    {
        "rowCount": 100,
        "columns": [
            {
                "name": "date",
                "type": "dateonly",
                "comment": "The date of the temperature observation in the format YYYY-MM-DD",
                "meaning": "DateOnly"
            },
            {
                "name": "temperature",
                "type": "float",
                "comment": "The recorded temperature value for the given date"
            },
            {
                "name": "temperature_trend",
                "type": "float",
                "comment": "A calculated trend value representing the smoothed or averaged temperature over a specific period"
            }
        ]
    }

---

## [plugins/reference/webapps]

# Component: Web Apps

Web apps can be turned into plugins. This allows you to have reusable and instantiable web apps, such as custom visualizations for datasets.

To create a web app component, you need to first create a normal web app, and then use Advanced > Convert to plugin web app.

See also

A tutorial on this plugin component is available in the Developer Guide: [Webapps](<https://developer.dataiku.com/latest/tutorials/plugins/webapps/index.html> "\(in Developer Guide\)").

The primary files for a web app component are a _webapp.json_ file that defines the parameters for the web app, and one or more files adapted from the normal web app that define the web app itself.

For an HTML/Javascript web app, there will be _app.js_ , _body.html_ and _style.css_ files that define the Javascript, HTML, and CSS for the web app. Use the `dataiku.getWebAppConfig()` method to extract parameter values the user specifies on the web app Settings tab. For example, the following code snippet pulls the user-specified value of the `dataset` parameter and assigns it to a variable `dataset`.
    
    
    let dataset = dataiku.getWebAppConfig()['dataset'];
    

For a Python Bokeh, Streamlit or Dash web app, there will be a _backend.py_ file. Use the `get_webapp_config()` method to extract parameter values the user specifies on the web app Settings tab. For example, the following code snippet pulls the user-specified value of the `input_dataset` parameter and assigns it to a variable `input_dataset`.
    
    
    input_dataset = get_webapp_config()['input_dataset']
    

For an R Shiny web app, there will be _server.R_ and _ui.R_ files. Use the `dataiku::dkuPluginConfig()` method to extract parameter values the user specifies on the web app Settings tab. For example, the following code snippet pulls the user-specified value of the `input_dataset` parameter and assigns it to a variable `input_dataset`.
    
    
    input_dataset = dkuPluginConfig()['input_dataset']