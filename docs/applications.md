# Dataiku Docs — applications

## [applications/application-as-recipe]

# Application-as-recipe

## Introduction

You can design and package a Dataiku flow into a reusable recipe for other projects.

## Using an Application-as-recipe

To create a recipe from an existing **Application-as-recipe** , click on the **New recipe** button from the **Flow**. **Application-as-recipes** are grouped by category in this menu.

**Application-as-recipes** can only be run by users that:

  1. are allowed to instantiate the corresponding **Application-as-recipe** (see [Using a Dataiku application](<index.html>))

  2. have the [Write project content](<../security/permissions.html>) permission on the project using the **Application-as-recipe**




## Developing an Application-as-recipe

Users with [Write project content](<../security/permissions.html>) permission can edit an Application-as-recipe. However, only users with [Admin](<../security/permissions.html>) permission on the project can convert it into an Application-as-recipe or change its type. Users with the **Develop plugins** permission are allowed to configure project variables through the recipe settings with custom code.

To convert a project into an **Application-as-recipe** , click on **Application designer** from the project menu. A project can be converted either into a **Dataiku application** or into an **Application-as-recipe**. Once the project is converted, the project menu will open the **Application designer** directly.

### Application header

The **Application header** panel allows configuring:

  * the recipe name and description;

  * which user can instantiate the application.




### Included content

The **Included content** panel allows configuring the additional data — from the original project containing the application — to include into the application instances.

### Recipe definition

#### Icon

The **icon** defines the icon for the **Application-as-recipe**. Available icons can be found in [Font Awesome v3.2.1](<https://fontawesome.com/v3.2.1/icons/>).

#### Category

**Application-as-recipes** with the same **category** are grouped under the same section in the **New recipe** menu.

#### Inputs/Outputs

This panel allows defining the inputs and outputs of the recipe that is to say a mapping between elements of the project using the **Application-as-recipe** and the corresponding elements in the **Application-as-recipe** flow. Each element is made of:

  * a **label** : this label is displayed in the recipe editor to identify the element

  * a **type** : an element can be a **Dataset** , a **Managed folder** or a **Saved model**

  * the corresponding element in the **Application-as-recipe** flow




#### Scenario

It is mandatory to specify the **Scenario** to build the outputs of the recipe. This scenario will be executed when running the **Application-as-recipe**.

#### Settings

This panel allows configuring the form displayed in the recipe settings. See the [Edit project variables > Runtime form](<tiles.html#applications-tiles-runtime-form>) section from the **Dataiku application tiles** for more details.

For example, the following settings form definition combines standard parameters such as **STRING** , **BOOLEAN** , and **SELECT** as well as the **COLUMN_VALUE** selector.
    
    
    [
        {
            "name": "campaignName",
            "label": "Campaign name",
            "type": "STRING"
        },
        {
            "name": "runMode",
            "label": "Run mode",
            "type": "SELECT",
            "defaultValue": "full",
            "selectChoices": [
                { "value": "full", "label": "Full rebuild" },
                { "value": "incremental", "label": "Incremental update" }
            ]
        },
        {
            "name": "sendNotification",
            "label": "Send completion notification",
            "type": "BOOLEAN",
            "defaultValue": true
        },
        {
            "name": "customersDataset",
            "label": "Customers dataset",
            "type": "DATASET",
            "defaultValue": "customers",
            "visibilityCondition": "false"
        },
        {
            "name": "countryCodeColumn",
            "label": "Country code column",
            "type": "DATASET_COLUMN",
            "datasetParamName": "customersDataset",
            "defaultValue": "country_code",
            "visibilityCondition": "false"
        },
        {
            "name": "country",
            "label": "Country",
            "type": "COLUMN_VALUE",
            "valueColumnParamName": "countryCodeColumn"
        },
        {
            "name": "cityCodeColumn",
            "label": "City code column",
            "type": "DATASET_COLUMN",
            "datasetParamName": "customersDataset",
            "defaultValue": "city_code",
            "visibilityCondition": "false"
        },
        {
            "name": "city",
            "label": "City",
            "type": "COLUMN_VALUE",
            "valueColumnParamName": "cityCodeColumn",
            "filteredByColumnValueParamName": "country"
        }
    ]
    

Warning

**COLUMN_VALUE** and **COLUMN_VALUES** are currently only supported in application contexts. They are not supported in:

  * plugin component settings

  * plugin presets edited inline

  * plugin project presets




## Sharing an Application-as-recipe

You can share an **Application-as-recipe** either by [copying this project](<../concepts/projects/duplicate.html>) or by creating a plugin component from your application. To create a plugin component from your application, click on the **Create or update plugin application** action from the **Actions** menu in the **Application designer**.

### Plugin component

From the component descriptor you can configure :

  * the recipe name with the **meta.label** field

  * the recipe description with the **meta.description** field

  * the recipe category with the **meta.category** field

  * the recipe icon with the **meta.icon** field. Available icons can be found in [Font Awesome v3.2.1](<https://fontawesome.com/v3.2.1/icons/>).




## Code recipes in Application-as-recipe

When DSS runs the **Application-as-recipe** , it makes a copy of the project where it is defined and swaps the datasets/managed folders/saved models that where defined as inputs in the **Application designer** for the ones selected by the user in the instance of the **Application-as-recipe** , inside the copy project. For visual recipes like Prepare or Join, this is transparent, and DSS will automatically adjust to the changes in the copy project. But code recipes like Python or SQL are run as is, without any change to their code.

In the case of Python recipes to run, it is advised to have them refer to their input by index in the Input/Output tab (see [Python recipes](<../code_recipes/python.html>)):
    
    
    from dataiku import recipe
    inputA = recipe.get_input(0, object_type="DATASET")
    # even simpler for a recipe with a single dataset as input:
    inputA = recipe.get_input()
    

Another option is to adjust the code of these recipes using a “Execute python code” step in the scenario of the **Application-as-recipe** using the public API.
    
    
    client = dataiku.api_client()
    current_project = client.get_project(dataiku.default_project_key())
    current_recipe = current_project.get_recipe("the_recipe_name")
    recipe_settings = current_recipe.get_settings()
    # get dataset currently used as input
    first_input_dataset_name = recipe_settings.get_recipe_inputs()['main']['items'][0]['ref']
    # adjust code
    code = recipe_settings.get_code()
    # ... modify code
    recipe_settings.set_code(...modified code)
    recipe_settings.save()
    

## Limitations

  * Partitioned inputs and outputs are not supported.

  * Outputs must be writable by DSS (e.g. should not be a BigQuery or Redshift dataset)

---

## [applications/index]

# Dataiku Applications

## Introduction

You can design and package your project as a reusable application with:

  * customizable inputs (datasets, managed folders, project variables, …)

  * pre-defined actions allowing you for example to build the results

  * access to pre-defined results (datasets, file/folder downloads, dashboards, …)




## Using a Dataiku application

A **Dataiku application** can be configured to allow instances to be created by any user. In this case any user will be able to access the application and create a new instance. If the **Dataiku application** is configured to allow instantiation only for users with execute permission the specific [Execute app](<../security/permissions.html>) permission must be configured on the project containing the application.

**Dataiku applications** are listed on the main home page in a dedicated **Dataiku Apps** section or from the applications menu.

From the application home page, you will:

  * see the existing instances;

  * be able to create a new instance;

  * access one of the existing instances by clicking on the corresponding instance tile.




## Developing a Dataiku application

Users with [Write project content](<../security/permissions.html>) permission can edit a Dataiku application. However, only users with [Admin](<../security/permissions.html>) permission on the project can convert it into an application or change its type. Users with the **Develop plugins** permission are allowed to configure project variable tiles with custom code.

To convert a project into a **Dataiku application** , click on **Application designer** from the project menu. A project can be converted either into a **Dataiku application** or into an [Application-as-recipe](<application-as-recipe.html>). Once the project is converted, the project menu will open the **Application designer** directly.

### Application header

The **Application header** panel allows to configure:

  * the application image;

  * the application title and description;

  * the application version;

  * which user can instantiate the application;

  * whether users without the permission to instantiate the application should still be able to discover it;

  * the tags.




The application version is represented as a string that developers update to inform users of created app instances about the availability of a new version, enabling them to update their instance. Typically, changes such as updates in the application flow or the addition of a new tile would prompt an application version update.

### Application features

The **Application features** panel allows toggling the display of some items on the application instances. The impacted sections are:

  * Flow top menu

  * Lab top menu

  * Code top menu

  * Version control top menu

  * “Switch back to project view” button (present on the instance’s home)




Note that these options only apply to instances that are created from now on. If you want to apply any change to an existing instance, you’ll have to delete and re-create the instance.

### Included content

The **Included content** panel allows to configure the additional data — from the original project containing the application — to include into the application instances.

### Application instance home

The **Application instance home** panel allows you to configure the user interface of the application instances. It is possible to add many tiles in many sections.

You can find more information about the available tiles in [Application tiles](<tiles.html>).

### Advanced settings

From the **Advanced** tab in an **Application designer** you can:

  * convert a **Dataiku application** into an **Application-as-recipe** and vice versa

  * map connection and code environment

  * visualize the raw JSON manifest corresponding to the application (for advanced usage)




### Application instance names

When using a **Dataiku application** , the user can choose any name for the instance they create. But since the name is arbitrary, some applications can meet trouble if they use it in places where the name is constrained, such as names of tables in SQL databases, since these often enforce maximum lengths on identifiers. Same with application-as-recipe, because the name of the project created by a run of the recipe is built from the recipe name.

To alleviate this issue, all application instances receive a project variable named projectRandomKey which is a short (8 characters) random string of alphanumerical characters. This can for example be used to build table names for SQL datasets. To use it in your application, first define a projectRandomKey variable in your application, then use it wherever it is needed. This way you can still execute your application flow while building the application content while the variable content will be overwritten when the application is instantiated.

Note that, as projectRandomKey is a random alphanumerical string, it can start with a number: since many SQL databases reject identifiers starting with numbers, it is advised to prefix ${projectRandomKey} with some letters if this variable is used to prefix a table name. E.g. p${projectRandomKey}_table_name.

## Application-as-recipe

You can instead build a reusable recipe: see [Application-as-recipe](<application-as-recipe.html>).

## Sharing a Dataiku application

You can share a **Dataiku application** either by [copying this project](<../concepts/projects/duplicate.html>) or by creating a plugin component from your application. To create a plugin component from your application, click on the **Create or update plugin application** action from the **Actions** menu in the **Application designer**.

### Plugin component

From the component descriptor you can configure :

  * the application name with the **meta.label** field

  * the application description with the **meta.description** field

  * the application image with **appImageFilename** field referring to an image uploaded in the **resource** folder of the plugin (at the root of the plugin)




### Connection and code environment mapping

It is possible to specify connection and code environment mapping.

#### For an application inside a project

Go to the **Advanced** tab in the application designer.

#### For an application inside a plugin

Go to the **Settings** tab of the plugin: for each application, a tab to configure these mappings will be available.

#### For an application inside a bundle

Go to the **Activation settings** tab in the bundles management. See [Production deployments and bundles](<../deployment/index.html>).

## Initiating an application instantiation request

Only users without any permissions on the application will be able to initiate an application instantiation request. They will be able to do so through a modal that will be displayed when landing on the application URL. For example, for discoverable applications, users can discover applications through the interface and request access. In the case of private applications, this will most likely happen if one of the application contributors shares the application URL with another user.

## Managing an application execution request

Application administrators can manage execution requests from within the project’s security section or by handling the request in the requests inbox.

If they manage the request via the requests inbox, they will be able to select which user or group they are granting the Execute App permission.

Note

Automatic updates of the request:

In the requests inbox, the request status can be automatically updated in the following cases:

  * Request is considered approved if the requester is given “Execute App” right via the app’s project security page

  * Request is rejected if the requester is deleted

  * Request is deleted if the project is deleted

---

## [applications/tiles]

# Application tiles

## Introduction

Application tiles are used to build the UI displayed to the users of an application. For a broader introduction on tiles and applications, see the [Dataiku apps tutorial](<https://knowledge.dataiku.com/latest/collaborate/dataiku-apps/basics/tutorial-index.html>).

## Tiles

### Upload file in dataset

The **Upload file in dataset** tile allows modifying the configuration of an **Uploaded files** dataset. The available interactions are:

  * **Go to dataset settings** : the tile gives access to the Settings tab of the selected dataset.

  * **Only upload file** : the tile allows selecting or deleting files.

  * **Upload file and automatically redetect format** : same as the **Only upload file** mode but also automatically detects the format.

  * **Upload file and automatically redetect format and infer schema** : same as the **Upload file and automatically redetect format** mode but also automatically infers the schema.




### Edit dataset

The **Edit dataset** tile allows modifying the configuration of an **Editable** dataset. The tile gives access to the Edit screen of the selected dataset.

### Edit dataset settings

The **Edit dataset settings** tile allows modifying the configuration of a dataset. The tile gives access to the Settings tab of the selected dataset.

### Select dataset files

The **Select dataset files** tile allows modifying the configuration of a **Filesystem** dataset. The available interactions are:

  * **Go to dataset settings** : the tile gives access to the Settings tab of the selected dataset.

  * **Only browse file** : the tile allows browsing and selecting a file.

  * **Browse file and automatically redetect format** : same as the **Only browse file** mode but also automatically detects the format.

  * **Browse file and automatically redetect format and infer schema** : same as the **Browse file and automatically redetect format** mode but also automatically infers the schema.

  * **Modal to browse file and automatically redetect format and infer schema** : same as the **Browse file and automatically redetect format and infer schema** mode but the editor is displayed in a modal.




### Select SQL table

The **Select SQL table** tile allows modifying the configuration of a **SQL table** dataset. The available interactions are:

  * **Go to dataset settings** : the tile gives access to the Settings tab of the selected dataset.

  * **Only browse table** : the tile allows browsing and selecting a file.

  * **Browse table and automatically redetect schema** : same as the **Only browse table** mode but also automatically detects the schema.

  * **Modal to browse table and automatically redetect schema** : same as the **Browse table and automatically redetect schema** mode but the editor is displayed in a modal.




### Upload file in folder

The **Upload file in folder** tile allows modifying the configuration of a **Managed folder**. The available interactions are:

  * **Go to folder** : the tile gives access to the View tab of the selected folder.

  * **Upload file** : the tile allows selecting or deleting files.




### Select folder files

The **Select folder files** tile allows modifying the configuration of a **Managed folder**. The available interactions are:

  * **Go to folder settings** : the tile gives access to the Settings tab of the selected folder.

  * **Browser folder location** : the tile allows browsing and selecting the folder location.

  * **Modal to browse folder location** : same as the **Browser folder location** mode but the editor is displayed in a modal.




### Edit project variables

The **Edit project variables** tile allows modifying the project variables. See [Custom variables expansion](<../variables/index.html>).

#### Runtime interactions

The available interactions are:

  * **Open modal to edit** : the editor is displayed in a modal.

  * **Edit inline with explicit save** : the editor is inlined in the tile but changes are saved upon clicking on the **Save** button.

  * **Edit inline with auto-save** : the editor is inlined in the tile and any change is saved.




#### Runtime form

The runtime form can either be fully generated by DSS or fully custom. Its capabilities, behavior and definition are exactly the same as forms of plugin components.

##### Auto-generated form

Auto-generated forms are made of the same [parameters](<../plugins/reference/params.html>) as auto-generated forms in plugin components:

  * The corresponding **Auto-generated controls** JSON editor in the application designer allows directly editing the **params** field described in [Parameters](<../plugins/reference/params.html>).

  * The corresponding project variable will be named after the **name** field of the parameter.

  * To configure a dynamic select using python:

    1. set **getChoicesFromPython** to **true**

    2. click on **Use custom UI**

    3. create a **do()** method in the **Python helper code** code editor that returns a dict with a key “choices” as described in the section [Dynamic select using python](<../plugins/reference/params.html#refdoc-plugin-parameter-dynamic-select-using-python>) of the **Plugin parameters** page




Example:

  * `Auto-generated controls`



    
    
    [
            {
                    "name": "campaignName",
                    "label": "Campaign name",
                    "type": "STRING"
            },
            {
                    "name": "sendNotification",
                    "label": "Send completion notification",
                    "type": "BOOLEAN",
                    "defaultValue": true
            },
            {
                    "name": "runMode",
                    "label": "Run mode",
                    "type": "SELECT",
                    "defaultValue": "full",
                    "selectChoices": [
                            { "value": "full", "label": "Full rebuild" },
                            { "value": "incremental", "label": "Incremental update" }
                    ]
            },
            {
                    "name": "availableCountry",
                    "label": "Country",
                    "type": "SELECT",
                    "getChoicesFromPython": true
            }
    ]
    

  * `Python helper code`



    
    
    def do(payload, config, plugin_config, inputs):
            run_mode = config.get("runMode", "full")
            if run_mode == "incremental":
                    choices = [
                            {"value": "fr", "label": "France"},
                            {"value": "de", "label": "Germany"}
                    ]
            else:
                    choices = [
                            {"value": "fr", "label": "France"},
                            {"value": "de", "label": "Germany"},
                            {"value": "us", "label": "United States"}
                    ]
            return {"choices": choices}
    

##### Dataset column value selectors

In addition to these standard parameter types, the **Edit project variables** tile also supports **COLUMN_VALUE** and **COLUMN_VALUES** parameters in auto-generated forms. These parameter types let you populate a single-select or multi-select directly from the values present in a dataset column.

These selectors are useful when the application user should pick business values from a dataset rather than raw values, for example a country, city, category, or product reference.

Warning

**COLUMN_VALUE** and **COLUMN_VALUES** are currently only supported in application contexts. They are not supported in:

  * plugin component settings

  * plugin presets edited inline

  * plugin project presets




To configure them, define:

  * a **DATASET** parameter to select the source dataset

  * one or more **DATASET_COLUMN** parameters pointing to the columns that contain the values to expose.

  * a **COLUMN_VALUE** or **COLUMN_VALUES** parameter using:
    
    * **valueColumnParamName** to point to the column from which to fetch the values

    * **labelColumnParamName** to optionally point to a separate column used as the displayed label

    * **filteredByColumnValueParamName** to optionally create a dependency on another **COLUMN_VALUE** or **COLUMN_VALUES** parameter. The available values will then be filtered by the selected values then be filtered within the same dataset only.




You can set a **defaultValue** to pre-select a value and use **visibilityCondition** to hide these parameters from the final user if needed.

DSS retrieves the values for the first 10,000 rows in the dataset. This limit can be modified with the `dku.sample.filtering.maxRecords` dip property.

Example:
    
    
    [
            {
                    "name": "customersDataset",
                    "label": "Customers dataset",
                    "type": "DATASET",
                    "defaultValue": "customers",
                    "visibilityCondition": "false"
            },
            {
                    "name": "countryCodeColumn",
                    "label": "Country code column",
                    "type": "DATASET_COLUMN",
                    "datasetParamName": "customersDataset",
                    "defaultValue": "country_code",
                    "visibilityCondition": "false"
            },
            {
                    "name": "cityCodeColumn",
                    "label": "City code column",
                    "type": "DATASET_COLUMN",
                    "datasetParamName": "customersDataset",
                    "defaultValue": "city_code",
                    "visibilityCondition": "false"
            },
            {
                    "name": "cityLabelColumn",
                    "label": "City label column",
                    "type": "DATASET_COLUMN",
                    "datasetParamName": "customersDataset",
                    "defaultValue": "city_name",
                    "visibilityCondition": "false"
            },
            {
                    "name": "country",
                    "label": "Country",
                    "type": "COLUMN_VALUE",
                    "valueColumnParamName": "countryCodeColumn"
            },
            {
                    "name": "city",
                    "label": "City",
                    "type": "COLUMN_VALUE",
                    "valueColumnParamName": "cityCodeColumn",
                    "labelColumnParamName": "cityLabelColumn",
                    "filteredByColumnValueParamName": "country"
            }
    ]
    

In this example, the dataset and technical column selectors are pre-filled and hidden, so the application user only sees the **Country** and **City** fields.

To allow several values to be selected, use **COLUMN_VALUES** instead of **COLUMN_VALUE**.

##### Custom form

Custom forms offer more control on the actual form presented to the user. They are defined as [html and JS files](<../plugins/reference/other.html#custom-settings-ui>) like in plugin components:

  * The **Python helper code** code editor allows writing the **do()** method as described in [Fetching data for custom forms](<../plugins/reference/other.html#custom-settings-ui-fetching-data>) of the **Custom settings UI** page.

  * The **Custom UI HTML** code editor allows writing the HTML template where the controller is defined in the Javascript code editor.

  * The **Custom UI JS** code editor allows writing the Javascript where the Angular controller is added to the Angular module.

  * The **Angular module** text input allows specifying the Angular module.

  * As described in the documentation [Custom settings UI](<../plugins/reference/other.html#custom-settings-ui>), the parameter values, i.e. the values of the project variables, should be set in the object **config**.




### Run scenario

The **Run scenario** tile allows running a selected **Scenario**.

### Propagate schema

When changing the input datasets of a flow, columns are often changed. Either their type can change, or columns can appear or disappear. This implies that the definition recipes consuming these datasets no longer matches their inputs, and thus that the recipes may fail to run. User action is then needed to adjust the recipes, updating, adding or removing columns from their definitions. This change can be tedious when for example one column has to be added to all downstream recipes and datasets of a changed input dataset. DSS offer the Propagate schema tool on the flow in order to facilitate this chore. The **Propagate schema** tile of an application wraps this tool.

The tile can be set to only initiate a schema propagation, leading the application user to the flow and letting them accept each suggested change manually. The tile can also be run automatically, without user interaction. In the latter mode, the application designer can pre-define some actions to take on the recipes in the **Recipe update options** , and also define recipes to not take action on at all:

  * “Excluded recipes” is a list of names of recipes that the propagation should simply not consider. The propagation will stop at this recipe and not proceed further. For example, model training recipes should generally be excluded.

  * “Recipes marked as OK” is a list of names of recipes that the propagation can consider as fine. Since propagation relies on design-time inspection of the recipes, some recipe types, notably code-based recipes, can’t compute the schema of their outputs without running or potentially expensive computations; for such recipes, the propagation tool, when run interactively, will ask for the user to double-check manually and mark as OK. When marked as OK, the automatic propagation will not seek approval from the user and just continue the propagation

  * “Partition by dimension” (name) and “Partition by computable” (name) offer control on the default values for partition identifiers to use when the propagation needs to rebuild a dataset to compute some schema change downstream, and that dataset is partitioned. This happens for example for Prepare recipes, which need their input to be up-to-date in order to compute a schema.




The **Recipe update options** is a JSON block of the following structure:
    
    
    {
            "byType" : {
                    "grouping" : {
                            // options for all grouping recipes
                    },
                    "window" : {
                            // options for all grouping recipes
                    },
                    "join" : {
                            // options for all join recipes
                    },
                    "generate_features" : {
                            // options for all grouping recipes
                    }
            },
            "byName" : {
                    "compute_some_data_by_key" : {
                            // options for the compute_some_data_by_key recipe
                    },
                    ...
            }
    }
    

#### Update options for Group

The options available are
    
    
    {
            "removeMissingAggregates" : true, // drop aggregates of columns no longer present in the input
            "removeMissingKeys" : true, // drop columns no longer present in the input from the grouping keys
            "newAggregates" : {
                    "DOUBLE" : [
                            {
                                    "column" : "regular expression to filter columns",
                                    // if match found, add the following aggregates
                                    "min" : true,
                                    "avg" : true
                            },
                            ...
                    ],
                    "BIGINT" : [
                            // rules for added columns of type bigint
                    ]
            }
    }
    

#### Update options for Window

Quite similarly to the Group recipe, the options available are
    
    
    {
            "removeMissingAggregates" : true, // drop aggregates of columns no longer present in the input
            "removeMissingInWindow" : true, // drop columns no longer present in the input from the partitioning and sorting keys
            "newAggregates" : {
                    "DOUBLE" : [
                            {
                                    "column" : "regular expression to filter columns",
                                    // if match found, add the following aggregates
                                    "min" : true,
                                    "last" : true
                            },
                            ...
                    ],
                    "BIGINT" : [
                            // rules for added columns of type bigint
                    ]
            }
    }
    

#### Update options for Join

The options available are
    
    
    {
            "removeMissingJoinConditions" : true, // drop join conditions involving columns no longer present in the input
            "removeMissingJoinValues" : true, // drop columns no longer present in the input the list of selected columns
            "newSelectedColumns" : {
                    "DOUBLE" : [
                            {
                                    "table" : 1, // this rule applies to the second input only
                                    "name" : "regular expression to filter columns"
                                    // if match found, select the column
                            },
                            {
                                    "table" : -1, // this rule applies to all inputs
                                    "name" : "regular expression to filter columns",
                                    "alias" : "alias for the added column, with $1, $2 ... replacements from the regex"
                            },
                            ...
                    ],
                    "BIGINT" : [
                            // rules for added columns of type bigint
                    ]
            }
    }
    

For example, the following rule matches columns ending in **_min** and outputs them without the **_min** suffix:
    
    
    {
            "table" : -1,
            "name" : "^(.*)_min$",
            "alias" : "$1"
    }
    

#### Update options to generate features

The options available for the [Generate features](<../other_recipes/generate-features.html>) recipe are
    
    
    {
            "removeMissingRelationships" : true, // drop relationships involving columns no longer present in the input datasets
            "removeMissingSelectedColumns" : true, // drop columns for computation no longer present in the input datasets
            "fixSelectedColumnsVariableTypes" : true // change the selected variable types of the selected columns if it is no longer compatible with the storage type or remove the column if the storage type is irrelevant (i.e. geo types).
    }
    

### View dashboard

The **View dashboard** tile allows viewing a selected **Dashboard**.

### View folder

The **View folder** tile allows accessing the View tab of the selected **Managed Folder**.

### Download dataset

The **Download dataset** tile allows downloading the selected **Dataset**.

### Download report

The **Download report** tile allows downloading the selected **R Markdown report**.

### Download file

The **Download file** tile allows downloading the selected file or folder from the selected **Managed folder**.

### Download dashboard

The **Download dashboard** tile allows downloading the selected **Dashboard**. See [Exporting dashboards to PDF or images](<../dashboards/exports.html>).

### Variable display

The **Variable display** tile allows displaying variable. The display can be customized using HTML tags. As described in [Custom variables expansion](<../variables/index.html>) variables must be referenced with the **${variable_name}** syntax.

### Display Markdown text

The **Display Markdown text** tile allows displaying formatted text using Markdown syntax. As described in [Custom variables expansion](<../variables/index.html>), project variables can be referenced with the **${variable_name}** syntax.

### Display an image

The **Display an image** tile allows displaying an uploaded image in the application. You can optionally configure a caption, an alt text for accessibility and a maximum image height.