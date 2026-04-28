# Dataiku Docs — dev-tutorials

## [tutorials/plugins/macros/project-creation/index]

# Writing a macro for project creation

## Prerequisites

  * Dataiku >= 12.0

  * Access to a dataiku instance with the “Develop plugins” permissions

  * Access to an existing project with the following permissions:
    
    * “Read project content”

    * “Write project content”




Note

We recommend reading [this tutorial](<../generality/index.html>). We will assume that you already have a plugin created.

## Introduction

This tutorial will show you how to create a macro dedicated to project creation.

The purpose of this macro is to make the project creation process more efficient and streamlined. Once created, the macro will be accessible under the **+New project** button on the Dataiku home page, as shown in Fig 1. This tutorial will provide step-by-step instructions on completing this macro to save time and effort when creating new projects.

Figure 1: Project creation macro.

To create a project creation macro, go to the plugin editor, click the **+New component** button, and choose the macro component. This will create a subfolder named `python-runnables` in your plugin directory. Within this subfolder, a subfolder with the name of your macro will be created. You will find two files in this subfolder: `runnable.json` and `runnable.py`. The JSON file is a placeholder for your macro’s configuration, including the parameters. The Python file, on the other hand, defines how the macro is executed

To ensure a successful implementation, it’s essential first to define the requirements of the macro. In this case, the macro is designed to assist users in setting up a new project. The macro will prompt the user to provide a name for their project and select a dedicated code environment and default cluster. Additionally, users can apply tags to their projects and create a starter wiki to get their projects off the ground.

## Macro configuration

Fill in the `meta` section as usual. If you need help, you will find dedicated information in [this documentation](<../generality/index.html>). For the `macroRoles` field, enter the `PROJECT_CREATOR` and `JSON_OBJECT` for the `resultType` field, as shown in Code 1.

Important

If you want the user to be redirected to the newly created project, you must set the `resultType` to `"JSON_OBJECT"`, in Code 1 and return the `projectKey` into a JSON object in the `run` function (Code 3):
    
    
    return json.dumps({"projectKey": self.project_key})
    

Code 1: Macro’s global configuration
    
    
      "meta": {
        "label": "Create and set up a project",
        "description": "Project creation (from macro)",
        "icon": "icon-thumbs-up"
      },
      "permissions": [
        "ADMIN"
      ],
      "resultType": "JSON_OBJECT",
      "macroRoles": [
        {
          "type": "PROJECT_CREATOR"
        }
      ],
      "impersonate": false,
    

To create a macro, it is crucial to define its parameters carefully. As this macro’s scope has been restricted, the parameters required are straightforward and relatively easy to determine.

The first parameter is the project name (`project_name`), which should be a concise but descriptive label for the project. The second parameter is the code environment (`code_envs`), which should be specified to ensure the project’s compatibility with the project’s coding standards and requirements.

The third parameter is the cluster name (`default_cluster`), which should be defined based on the infrastructure used for the project.

The fourth parameter (`tags`) is a list of strings representing the tags for the project. These tags help to categorize the project, making it easier to search for and identify relevant content.

Finally, the fifth parameter is the wiki content (`wiki_content`). If the user wishes to add a wiki, this parameter is necessary. Additionally, it is essential to include a parameter (`additional_wiki`) that allows the user to indicate whether or not they want to create a wiki.

Defining all these parameters leads to the code shown in Code 2.

Code 2: Macro’s parameters configuration
    
    
      "impersonate": false,
      "params": [
        {
          "name": "project_name",
          "label": "Project name",
          "type": "STRING",
          "description": "Name of the project",
          "mandatory": true
        },
        {
          "name": "code_envs",
          "label": "Select a code env",
          "description": "Default code env for the project",
          "type": "CODE_ENV"
        },
        {
          "name": "default_cluster",
          "label": "Select a default container",
          "type": "CLUSTER"
        },
        {
          "name": "tags",
          "label": "Additional tags",
          "type": "STRINGS"
        },
        {
          "name": "additional_wiki",
          "label": "Do you want to add a wiki page?",
          "type": "BOOLEAN"
        },
        {
          "name": "wiki_content",
          "label": "Wiki page",
          "type": "TEXTAREA",
          "visibilityCondition": "model.additional_wiki"
        }
      ]
    }
    

## Macro execution

For more information about the initial generated code, you can refer to [this documentation](<../generality/index.html>).

The Code 3 presents the whole code of the macro. Comments help you to understand how it works. The complete processing procedure is executed within the `run` function. We have defined a helper function named `create_checklist` for generating a checklist item from a list of strings. This function could/should be in a separate file (for example, in a library), but for presentation purposes, it is included in the Python file.

As part of the processing:

  * We first create a client for interacting with Dataiku and gather information about the connected user.

  * Then, we generate a unique project key which is used to identify the project throughout the system.

  * After that, we create the project and set the default code environment and cluster, essential components for any project. Additionally, we create a checklist for the project and add tags to it.

  * Finally, if the user desires, we make a wiki for the project, which can be used to document the project’s progress and guide team members.




If you want to impose a particular configuration, you can add these steps to the procedure without requesting the user’s input.

## Wrapping up

Congratulations! You have completed this tutorial and built your first macro for project creation. Understanding all these basic concepts allows you to create more complex macros.

For example, you can import some datasets from the feature store, define other settings for your newly created project, or set specific permission for users/groups.

Here is the complete version of the code presented in this tutorial:

runnable.json
    
    
    {
      "meta": {
        "label": "Create and set up a project",
        "description": "Project creation (from macro)",
        "icon": "icon-thumbs-up"
      },
      "permissions": [
        "ADMIN"
      ],
      "resultType": "JSON_OBJECT",
      "macroRoles": [
        {
          "type": "PROJECT_CREATOR"
        }
      ],
      "impersonate": false,
      "params": [
        {
          "name": "project_name",
          "label": "Project name",
          "type": "STRING",
          "description": "Name of the project",
          "mandatory": true
        },
        {
          "name": "code_envs",
          "label": "Select a code env",
          "description": "Default code env for the project",
          "type": "CODE_ENV"
        },
        {
          "name": "default_cluster",
          "label": "Select a default container",
          "type": "CLUSTER"
        },
        {
          "name": "tags",
          "label": "Additional tags",
          "type": "STRINGS"
        },
        {
          "name": "additional_wiki",
          "label": "Do you want to add a wiki page?",
          "type": "BOOLEAN"
        },
        {
          "name": "wiki_content",
          "label": "Wiki page",
          "type": "TEXTAREA",
          "visibilityCondition": "model.additional_wiki"
        }
      ]
    }
    

runnable.py

Code 3: Macro’s processing
    
    
    # This file is the actual code for the Python runnable project-creation
    import random
    import string
    from datetime import datetime
    import dataiku
    import json
    from dataiku.runnables import Runnable
    
    
    class MyRunnable(Runnable):
        """The base interface for a Python runnable"""
    
        def __init__(self, project_key, config, plugin_config):
            """
            :param project_key: the project in which the runnable executes
            :param config: the dict of the configuration of the object
            :param plugin_config: contains the plugin settings
            """
            self.config = config
            self.plugin_config = plugin_config
            self.project_name = self.config.get('project_name')
            # project_key should not contain any space
            self.project_key = ''.join([char.upper() for char in self.project_name if char.isalpha()])
            self.code_envs = self.config.get('code_envs')
            self.default_cluster = self.config.get('default_cluster')
            self.tags = self.config.get('tags')
            self.additional_wiki = self.config.get('additional_wiki')
            self.wiki_content = self.config.get('wiki_content')
    
        def get_progress_target(self):
            """
            If the runnable will return some progress info, have this function return a tuple of
            (target, unit) where unit is one of: SIZE, FILES, RECORDS, NONE
            """
            return None
    
        def create_checklist(self, author, items):
            """
            Generate a checklist from a list of items
    
            :param author: Author of the checklist
            :param items: list of items
            :return: the checklist
            """
            checklist = {
                "title": "To-do list",
                "createdOn": 0,
                "items": []
            }
            for item in items:
                checklist["items"].append({
                    "createdBy": author,
                    "createdOn": int(datetime.now().timestamp()),
                    "done": False,
                    "stateChangedOn": 0,
                    "text": item
                })
            return checklist
    
        def run(self, progress_callback):
            """
            Do stuff here. Can return a string or raise an exception.
            The progress_callback is a function expecting 1 value: current progress
            """
    
            # Create a (Dataiku) client for interacting with Dataiku and collect the connected user.
            user_client = dataiku.api_client()
            user_auth_info = user_client.get_auth_info()
    
            # Generate a unique project_key
            while self.project_key in user_client.list_project_keys():
                self.project_key = self.project_name.upper() + '_' + ''.join(random.choices(string.ascii_uppercase, k=10))
    
            # Create the project
            new_project = user_client.create_project(self.project_key, self.project_name,
                                                     user_auth_info.get('authIdentifier'))
    
            # Set the default code env and cluster
            settings = new_project.get_settings()
            settings.set_python_code_env(self.code_envs)
            settings.set_k8s_cluster(self.default_cluster)
            settings.save()
    
            # Add tags to the project settings
            tags = new_project.get_tags()
            tags["tags"] = {t: {} for t in self.tags}
            new_project.set_tags(tags)
    
            # Create the checklist and add tags to the projects
            to_dos = ["Import some datasets",
                      "Create your first recipe/notebook",
                      "Enjoy coding"]
            metadata = new_project.get_metadata()
            metadata["checklists"]["checklists"].append(self.create_checklist(user_auth_info.get('authIdentifier'),
                                                                              items=to_dos))
            metadata['tags'] = [t for t in self.tags]
            new_project.set_metadata(metadata)
    
            # Create the wiki if the user wants it.
            if self.additional_wiki:
                wiki = new_project.get_wiki()
                article = wiki.create_article("Home page",
                                              content=self.wiki_content)
                settings = wiki.get_settings()
                settings.set_home_article_id(article.article_id)
                settings.save()
            
            return json.dumps({"projectKey": self.project_key})

---

## [tutorials/plugins/macros/test-regression-macro/index]

# Writing a macro for managing regression tests

## Context

When a project is modified, the changes may impact the final result. While some impacts are desired, others may result in defects. In software development, testing aims to verify these modifications automatically. There are many types of testing, but they can be classified into three categories: functional testing, performance testing, and maintenance testing. Maintenance testing verifies that the changes introduced have no impact on the rest of the project.

Software testing could be applied to a Dataiku Project. In this tutorial, the focus is on maintenance testing. When a Project is modified, we want to ensure the final result does not change. This is called regression testing, and you could apply it in various ways. Whenever a Flow change is made to a Project, there is a risk of defects. In this case, we may want to test these changes.

We can test the Flow modifications, by replacing the input Datasets, with “well-known” Datasets, running the Flow, verifying that the defined Metrics/Checks are still good, and reusing previously used Datasets. This task is repetitive, could be very long and fastidious, and error-prone. In that case, a Macro (for more information about Macros, see [DSS Macros](<https://doc.dataiku.com/dss/latest/operations/macros.html> "\(in Dataiku DSS v14\)")) could be written to automate this workflow with the following steps:

  * Replace the inputs of the Flow with “well-known Datasets” (aka trusted Datasets)

  * Build the Flow

  * Read the outputs and compares them with the trusted outputs, and issue a report with the results

  * Restore the original inputs of the Flow




Writing a Macro will also provide a way to be automatically run when the Flow is modified, by using a scenario (for more information, please see [Automation scenarios](<https://doc.dataiku.com/dss/latest/scenarios/index.html> "\(in Dataiku DSS v14\)")). This tutorial is spread into four parts, readers that know how a macro is created and configured can easily skip the first two parts:

  * Macro creation: How to create a new Macro component.

  * Macro configuration: How to configure the Macro component.

  * Analysis and inputs: Analysis of the context of the Macro to define the Macro parameters.

  * Coding the macro: How to code the Macro.




Tip

Starting from version 13.3.0, Dataiku has a powerful native feature for non-regression testing. [The reference documentation](<https://doc.dataiku.com/dss/latest/scenarios/steps.html#flow-test-step> "\(in Dataiku DSS v14\)") and [the knowledge base](<https://knowledge.dataiku.com/latest/automate-tasks/scenarios/tutorial-test-scenarios.html> "\(in Dataiku Academy v14.0\)") provide comprehensive information about this feature.

## Macro creation

### Creation by the user interface

We can create a Macro from the plugin component interface (for more information on Plugin development, please see [Developing plugins](<https://doc.dataiku.com/dss/latest/plugins/reference/index.html> "\(in Dataiku DSS v14\)")) and choose “new component” (Fig. 1).

Figure 1: New component.

and then choose Macro (Fig. 2)

Figure 2: Plugin – New Macro component.

and fill the form to create a Macro, by choosing a name for the Macro (here `regression-test`), as shown on Fig. 3.

Figure 3: Plugin – Form for new Macro component.

### Creation by code

Alternatively, we can create a Macro component directly inside the Plugin code directory, by making the following directory (Fig. 4). We can choose a different name for the directory `regression-test`, but the other names can not be changed. So we have to keep `python-runnables` (the directory where goes the Macros), and also have to keep `runnable.json` and `runnable.py` (to be able to run the Macro). As explained in [Component: Macros](<https://doc.dataiku.com/dss/latest/plugins/reference/macros.html> "\(in Dataiku DSS v14\)"), this is because a macro is essentially a function wrapped in a class.

Figure 4: Plugin – Directory of a Macro component named `regression-test`.

## Macro configuration

### Description

The configuration of the Macro is done in the `runnable.json` file. Each component plugin begins with a `meta` section that contains the name of the component (`label`), the description of the component (`description`) and an icon to represent the component (`icon`). For this Macro, we could have written:

Code 1: Macro description.
    
    
    "meta": {
        "label": "Regression tests",
        "description": "This macro aims to do some regression tests, by substituting original datasets with some trusted datasets. Then builds the flow, reads the output, produces a report, and brings back the flow to its original state.",
        "icon": "icon-check"
    },
    

This description is on the plugin page as shown in Fig. 5, and Fig. 7.

Figure 5: Plugin – Macro description.

### Global Configuration

Then we will need to configure the Macro. Does this Macro run with UNIX user identity, or with the identity of the final user (this is relevant if only UIF is enabled). Unless having a clear understanding of all UIF implications, we should set it to `true` (`"impersonate": true`). We will also need to set the permission that a user needs to see/run the Macro. Here, as we change the Flow, the user needs `"WRITE_CONF"`. Then, we must specify what the Macro returns among:

  * `NONE`: no result

  * `HTML`: a string that is an HTML (utf8 encoded)

  * `FOLDEF_FILE`: a (`folderId`, `path`) pair to a file in a folder of this project (_json-encoded_)

  * `FILE`: raw data (as a python string) that will be stored in a temp file by Dataiku

  * `URL` : an URL




We have chosen to return an HTML string. And finally, we should also define where this Macro will appear in the Dataiku. We can target Dataiku objects (`DATASET`, `DATASETS`, `API_SERVICE`, `API_SERVICE_VERSION`, `BUNDLE`, `VISUAL_ANALYSIS`, `SAVED_MODEL`, `MANAGED_FOLDER`) or the project itself. If we target Dataiku objects, then the Macro can prefill some of its parameters, and will contextually appear in the GUI when it is relevant, for example in the “Other actions” section in the right panel (see Fig. 6).

Figure 6: Plugin – Contextual action.

If we target the Project itself, the Macro will appear in the “Macros” submenu in the project settings, as shown in Fig. 7. In both cases, we can see that the icon we previously define (in the description section) is used.

Figure 7: Plugin – Macro integration inside the Macros submenu.

This leads to the code shown in Code 2.

Code 2: Global configuration of the Macro plugin.
    
    
    "impersonate": true,
    "permissions": ["WRITE_CONF"],
    "resultType": "HTML",
    "resultLabel": "Regression tests results",
    "macroRoles": [
        {
            "type": "DATASETS",
            "targetParamsKey": "original-dataset",
            "applicableToForeign": true
        },
        {
            "type": "PROJECT_MACROS"
        }
    ]
    

## Analysis and inputs

Note

Several assumptions help simplify the code for the macro. For example, it doesn’t use every input for the Project, only the specified Datasets. This tutorial provides a starting point that could be adapted to specific needs.

### Input datasets

While we can get all the inputs to a Flow, knowing which inputs we should replace with which trusted outputs can be challenging. In addition, some of the input Datasets may not be relevant to change because they do not impact the result or are not part of the Flow we want to test. So we need to ask the user which input Datasets are concerned by this test.

### “Well-known Datasets”

Since trusted Datasets are not part of the initial Flow we want to test, we need to know which Datasets are “well-known”. We also need to know which trusted Dataset will replace which input Dataset, as it may be difficult to replace one Dataset with another one.

### Metrics

The purpose of the macro is to ensure changes to the Flow do NOT impact outcomes by checking relevant Metrics of the output Datasets against an expected result. We can assume that the relevant Metrics are those of the Datasets at the end of the Flow. But other Datasets may also contain relevant Metrics. So we want the user to specify the Datasets that contain the Metrics that this macro will observe.

### Summary

To summarize, this Macro requires as input:

  * the Datasets to be substituted

  * the trusted Datasets

  * a mapping from input Datasets to trusted Datasets

  * a list of Datasets that the macro will use for testing Checks and Metrics




### Macro parameters definition

In the previous section, we decided that to realize this Macro, we need 4 parameters (for more information about types and usages of Macro parameter, see [Parameters](<https://doc.dataiku.com/dss/latest/plugins/reference/params.html> "\(in Dataiku DSS v14\)")) (Datasets to substitute, trusted datasets, a mapping, Datasets that have the metrics to test). So we need to define these parameters in the `runnable.json` file too (see Code 3). For each parameter, we have:

  * `name`: used when we want to access the value of this parameter when coding the plugin.

  * `label`: used when Dataiku displays the graphical user interface to enter the values for the parameter.

  * `type`: indicates which values are accepted for this parameter.

  * `mandatory`: indicates if the parameter needs to be entered or not.




We can also have some other optional fields. Here we have used `description` (to display inline help), `canSelectForeign` (to allow the foreign object to be entered). Using those parameters’ definitions, Dataiku will display the input screen as shown in Fig. 8.

Code 3: Plugin – Parameters definition.
    
    
    "params": [
        {
          "name": "original-dataset",
          "label": "Dataset to substitute",
          "type": "DATASETS",
          "mandatory": true
        },
        {
          "name": "trusted-dataset",
          "label": "Trusted Dataset",
          "type": "DATASETS",
          "description": "Select the datasets",
          "mandatory": true,
          "canSelectForeign": true
        },
        {
          "name": "mapping",
          "label": "Indicate which dataset will be used as a substitute (original -> substitute)",
          "type": "MAP",
          "mandatory": true
        },
        {
          "name": "dataset-to-build",
          "label": "Dataset to check for metrics",
          "type": "DATASETS",
          "description": "Select the datasets where you want the metrics to be tested",
          "mandatory": true,
          "canSelectForeign": true
        }
    ],
    

Figure 8: Plugin – Visual parameters input interface.

Code 4 show the whole code for `runnable.json`.

Code 4: Macro configuration file.
    
    
    {
        "meta": {
            "label": "Regression tests",
            "description": "This macro aims to do some regression tests, by substituting the original dataset with some trusted dataset. Then builds the flow, reads the output, produces a report, and brings back the flow to its original state.",
            "icon": "icon-check"
        },
        "params": [
            {
                "name": "original-dataset",
                "label": "Dataset to substitute",
                "type": "DATASETS",
                "mandatory": true
            },
            {
                "name": "trusted-dataset",
                "label": "Trusted Dataset",
                "type": "DATASETS",
                "description": "Select the datasets",
                "mandatory": true,
                "canSelectForeign": true
            },
            {
                "name": "mapping",
                "label": "Indicate which dataset will be used as a substitute (original -> substitute)",
                "type": "MAP",
                "mandatory": true
            },
            {
                "name": "dataset-to-build",
                "label": "Dataset to check for metrics",
                "type": "DATASETS",
                "description": "Select the datasets where you want the metrics to be tested",
                "mandatory": true,
                "canSelectForeign": true
            }
        ],
        "impersonate": true,
        "permissions": ["WRITE_CONF"],
        "resultType": "HTML",
        "resultLabel": "Regression tests results",
        "macroRoles": [
            {
                "type": "DATASETS",
                "targetParamsKey": "original-dataset",
                "applicableToForeign": true
            },
            {
                "type": "PROJECT_MACROS"
            }
        ]
    }
    

## Coding the macro

Now we have entirely configured the Macro, we can code it. If we have created the Macro from the visual interface, the `runnable.py` comes with the default skeleton just shown in Code 5. The `__init__` (line 7) function is the place to retrieve the values of the parameters. The highlighted function, line 24 (`def run(self, progress_callback):`), is where the processing starts.

Code 5: Macro default code file.
    
    
     1# This file is the actual code for the Python runnable to-be-deleted
     2from dataiku.runnables import Runnable
     3
     4class MyRunnable(Runnable):
     5    """The base interface for a Python runnable"""
     6
     7    def __init__(self, project_key, config, plugin_config):
     8        """
     9        :param project_key: the project in which the runnable executes
    10        :param config: the dict of the configuration of the object
    11        :param plugin_config: contains the plugin settings
    12        """
    13        self.project_key = project_key
    14        self.config = config
    15        self.plugin_config = plugin_config
    16
    17    def get_progress_target(self):
    18        """
    19        If the runnable will return some progress info, have this function return a tuple of
    20        (target, unit) where unit is one of: SIZE, FILES, RECORDS, NONE
    21        """
    22        return None
    23
    24    def run(self, progress_callback):
    25        """
    26        Do stuff here. Can return a string or raise an exception.
    27        The progress_callback is a function expecting 1 value: current progress
    28        """
    29        raise Exception("unimplemented")
    

### Initialization

The initialization is straightforward. We just have to retrieve the parameters. For implementation purposes, that will be discussed later. We also need to sort the Datasets where the Metrics are and build the inverted map from tested Datasets to trusted Datasets.

Code 6: Initialization code of the Macro.
    
    
     1def __init__(self, project_key, config, plugin_config):
     2    """
     3    :param project_key: the project in which the runnable executes
     4    :param config: the dict of the configuration of the object
     5    :param plugin_config: contains the plugin settings
     6    """
     7    self.project_key = project_key
     8    self.config = config
     9    self.plugin_config = plugin_config
    10    self.original_dataset = config.get("original-dataset", [])
    11    self.trusted_dataset = config.get("trusted-dataset", [])
    12    self.mapping = config.get("mapping", {})
    13    self.dataset_to_build = config.get("dataset-to-build", [])
    14    self.dataset_to_build.sort()
    15    self.inv_mapping = {v: k for k, v in self.mapping.items()}
    

The highlighted lines retrieve the values of the parameters filled in the window when running the macro. We have 3 lists of dataset name (`"original-dataset"`, `"trusted-dataset"`, `"dataset-to-build"`), and one dict (`"mapping"`) for the mapping as explained in this section. The different names come from the `runnable.json` (`"name"` field of each parameter).

### The `run` function

Before running the Dataset substitution, we need to check if all provided Datasets exist. So we define the function is_all_datasets_exist for this purpose. We test all the provided Datasets, as if one is missing, it may leave the project in an unstable state.

Code 7: Test if all Datasets exist in the context of a project.
    
    
    def is_all_datasets_exist(project, datasets):
        """
        Test if all datasets exist
        :param project: current project
        :param datasets: list of dataset names
        :return: true if all datasets exist
        """
        exist = True
        for d in datasets:
            exist &= project.get_dataset(d).exists()
        return exist
    
    .../...
    
    client: Union[DSSClient, TicketProxyingDSSClient] = dataiku.api_client()
    project: DSSProject = client.get_project(self.project_key)
    # Checking if the all datasets are defined
    if not is_all_datasets_exist(project, self.original_dataset):
        raise Exception("All original datasets do not exist")
    if not is_all_datasets_exist(project, self.trusted_dataset):
        raise Exception("All trusted datasets do not exists")
    if not is_all_datasets_exist(project, self.dataset_to_build):
        raise Exception("Can not find all datasets for metric checks.")
    

We could also have checked if the mapping is correct, by looking if the keys are defined in the `original-dataset`, and if all values of the mapping are in the `trusted_dataset`. This is left to the reader. Once we are sure that we will have no trouble when running the Macro, we have to retrieve and store the existing Metrics and Checks to be able to compare them with the trusted Dataset Metrics.

Code 8: Retrieve and store the existing Metrics.
    
    
    def is_used_metrics(metric):
        """
        Test if a metric is used
        :param metric: the metric to test
        :return: true if it is used
        """
        return metric['displayedAsMetric']
    
    
    def get_checks_used(settings):
        """
        Get the list of all used checks for a dataset
        :param settings: the settings of the dataset
        :return: the list of all checks used for this dataset
        """
        return list(map((lambda check: 'check:CHECK:'+check), settings['metricsChecks']['displayedState']['checks']))
    
    
    def extract_metrics_and_checks_used(dataset: DSSDataset) -> list:
        """
        Get all metrics and checks used for the dataset
        :param dataset: the dataset to extract information
        :return: a list containing all metrics and checks used for the dataset
        """
        last_metrics = dataset.get_last_metric_values().get_raw()
        return_list = list()
        id_metrics = list(map((lambda metric: metric['metric']['id']), filter(is_used_metrics, last_metrics['metrics'])))
        return_list.extend(id_metrics)
        id_checks = get_checks_used(dataset.get_settings().get_raw())
        return_list.extend(id_checks)
        return_list.sort()
    
        return return_list
    
    .../...
    # Previous metrics
    for d in self.dataset_to_build:
        dataset = project.get_dataset(d)
        last_metrics = dataset.get_last_metric_values()
        metrics_and_check_used = extract_metrics_and_checks_used(dataset)
        for metric in metrics_and_check_used:
            metric_value = last_metrics.get_metric_by_id(metric)
            if metric_value and metric_value['lastValues']:
                result[metric] = {
                    'initialValue': metric_value['lastValues'][0]['value']
                }
    

Then we replace the existing dataset with the trusted ones:

Code 9: Replacing existing Datasets with trusted Datasets.
    
    
    flow: DSSProjectFlow = project.get_flow()
    for d in self.original_dataset:
        flow.replace_input_computable(d, self.mapping[d])
    

We build the Flow, and run Checks/Metrics:

Code 10: Running the flow to build the wanted Dataset.
    
    
    definition = {
        "type": "RECURSIVE_FORCED_BUILD",
        "outputs": [{
            "id": "%s" % output_name,
        } for output_name in self.dataset_to_build]
    }
    job = project.start_job(definition)
    state = ''
    while state != 'DONE' and state != 'FAILED' and state != 'ABORTED':
        time.sleep(1)
        state = job.get_status()['baseStatus']['state']
    

After this step, we have to retrieve the resulting Metrics and Checks using the same process as here, compare them and put back the Flow by doing the inverse substitution that we have done here. Don’t forget to compute the Metrics, and run the Checks before retrieving them!

## Conclusion

What is left to the reader? As we choose to produce an HTML report, the reader should produce this report. The reader can change the Macro result type, for this purpose this documentation ([Component: Macros](<https://doc.dataiku.com/dss/latest/plugins/reference/macros.html> "\(in Dataiku DSS v14\)")) will be of interest.

In this tutorial, we learn to implement a regression test by using a Macro to test a Flow change. This kind of test helps the data scientists to test their modifications before putting them into production. This Macro aims to change datasets by trusted datasets, but you could also use it to test the impact of changing the connection type of Datasets. Defining a Macro is an elegant solution for many repetitive tasks. Macros can be run as a step in a scenario, leading to more automatization.

---

## [tutorials/plugins/prediction-algorithm/index]

# Prediction algorithm  
  
This section contains several learning materials about the plugin component: Prediction algorithm.

---

## [tutorials/plugins/prediction-algorithm/ml-algo/index]

# Creating a plugin Prediction Algorithm component

Creating a prediction algorithm component in a plugin allows you to extend the list of algorithms available in Dataiku’s Visual ML tool.

In this tutorial, you will create a Linear Discriminant Analysis as a plugin component.

## Creating the plugin component

  1. From the Application menu, select **Plugins**.

  2. Select **Add Plugin > Write your own**.

  3. Give the new plugin a name like `discriminant-analysis` and click **Create**.

  4. Click **+Create Your First Component** and select **Prediction Algorithm**.

  5. Give the new component an identifier and click **Add**.




The ML Alogorithm plugin component is composed of two files: a configuration file (`algo.json`) and a code file (`algo.py`).

### Editing `algo.json`

First, let’s have a look at the `algo.json` file. Like every plugin, the first element of the JSON file is the `"meta"`, in which you can detail all the metadata of your plugin. Making changes here helps to make the algorithm more straightforward to identify in the Visual ML tool.
    
    
    1"meta" : {
    2
    3    "label": "Linear Discriminant Analysis",
    4
    5    "description": "A classifier with a linear decision boundary, generated by fitting class conditional densities to the data and using Bayes' rule.",
    6
    7    "icon": "fas fa-puzzle-piece"
    8},
    

The `"predictionTypes"` element must be changed according to the type of your problem. Discriminant analysis is the example here and can be used for classification problems. Hence, we choose the parameters as follows:
    
    
    "predictionTypes": ["BINARY_CLASSIFICATION", "MULTICLASS"],
    

Dataiku uses the Grid Search to select hyperparameters. With the `"gridSearchMode"`, you can select it to be either managed by Dataiku or set a custom searching strategy.
    
    
    "gridSearchMode": "MANAGED",
    

The last important section of the JSON is the `"params"`. For example, here are the parameters for the [scikit-learn implementation of discriminant analysis](<https://scikit-learn.org/stable/modules/generated/sklearn.discriminant_analysis.LinearDiscriminantAnalysis.html>). We can make these available in the JSON as follows.
    
    
     1"params": [
     2    {
     3        "name": "solver",
     4        "label": "Solver",
     5        "description": "Solver to use.",
     6        "type": "MULTISELECT",
     7        "defaultValue": ["svd"],
     8        "selectChoices": [
     9            {
    10                "value":"svd",
    11                "label":"Singular value decomposition"
    12            },
    13            {
    14                "value":"lsqr",
    15                "label":"Least squares"
    16            },
    17            {
    18                "value":"eigen",
    19                "label": "Eigenvalue decomposition"
    20            }
    21        ],
    22        "gridParam": true
    23    },
    24    {
    25        "name": "n_components",
    26        "label": "Number of components",
    27        "description":"Number of components (<= min(n_classes - 1, n_features)) for dimensionality reduction. If None, will be set to min(n_classes - 1, n_features).",
    28        "type": "DOUBLES",
    29        "defaultValue": [1],
    30        "allowDuplicates": false,
    31        "gridParam": true
    32    },
    33    {
    34        "name": "tol",
    35        "label": "Tolerance",
    36        "description": "Threshold for rank estimation in SVD solver.",
    37        "type": "DOUBLES",
    38        "defaultValue": [0.0001],
    39        "allowDuplicates": false,
    40        "gridParam": true
    41    }
    42]
    

These parameters can be managed when creating a new model based on this plugin.

### Editing `algo.py`

Now, let’s edit `algo.py`. The default contents include an example of code for the AdaBoostRegressor algorithm. The code is a Python class composed of an _init_ and _get_ functions.

Remember to import the wanted algorithm and build it in the `__init__()` function to make it appropriate. For a linear discriminant analysis, you can do as follows:
    
    
     1from dataiku.doctor.plugins.custom_prediction_algorithm import BaseCustomPredictionAlgorithm
     2from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
     3
     4class CustomPredictionAlgorithm(BaseCustomPredictionAlgorithm):
     5    def __init__(self, prediction_type=None, params=None):
     6        self.clf = LinearDiscriminantAnalysis()
     7        super(CustomPredictionAlgorithm, self).__init__(prediction_type, params)
     8
     9    def get_clf(self):
    10        return self.clf
    

## Using the component in a project

  1. Open a project and select a dataset.

  2. Open a new Lab on the right panel and click on **AutoML Prediction** for a predictive model.

  3. Select the feature you want to predict.

  4. In the **Algorithms** panel of the Design of the predictive model, turn your plugin algorithm on.

  5. Specify the settings and parameters you want, then click **Train**.




You can explore and deploy the resulting model in the same way you would any other model produced through the Visual ML tool.

## Wrapping Up

You can now create an ML learning algorithm and use it as a plugin in the Visual ML Tool in Dataiku.

The complete code can be found as follows:

algo.json
    
    
    /* This file is the descriptor for the Custom Python Prediction algorithm ml-algo-test_linear-test */
    {
        "meta" : {
    
            "label": "Linear Discriminant Analysis",
    
            "description": "A classifier with a linear decision boundary, generated by fitting class conditional densities to the data and using Bayes' rule.",
    
            "icon": "fas fa-puzzle-piece"
        },
        
        // List of types of prediction for which the algorithm will be available.
        // Possibles values are: ["BINARY_CLASSIFICATION", "MULTICLASS", "REGRESSION"]
        "predictionTypes": ["BINARY_CLASSIFICATION", "MULTICLASS"],
    
        // Depending on the mode you select, Dataiku will handle or not the building of the grid from the params
        // Possible values are ["NONE", "MANAGED", "CUSTOM"]
        "gridSearchMode": "MANAGED",
    
        // Whether the model supports or not sample weights for training. 
        // If yes, the clf from `algo.py` must have a `fit(X, y, sample_weights=None)` method
        // If not, sample weights are not applied on this algorithm, but if they are selected
        // for training, they will be applied on scoring metrics and charts.
        "supportsSampleWeights": true,
    
        // Whether the model supports sparse matrice for fitting and predicting, 
        // i.e. if the `clf` provided in `algo.py` accepts a sparse matrix as argument
        // for its `fit` and `predict` methods
        "acceptsSparseMatrix": false,
    
        /* params:
        Dataiku will generate a formular from this list of requested parameters.
        Your component code can then access the value provided by users using the "name" field of each parameter.
    
        Available parameter types include:
        STRING, INT, DOUBLE, BOOLEAN, DATE, SELECT, TEXTAREA, PRESET and others.
    
        Besides, if the parameters are to be used to build the grid search, you must add a `gridParam` field and set it to true.
    
        For the full list and for more details, see the documentation: https://doc.dataiku.com/dss/latest/plugins/reference/params.html
    
        Below is an example of parameters for an AdaBoost regressor from scikit learn.
        */
        "params": [
            {
                "name": "solver",
                "label": "Solver",
                "description": "Solver to use.",
                "type": "MULTISELECT",
                "defaultValue": ["svd"],
                "selectChoices": [
                    {
                        "value":"svd",
                        "label":"Singular value decomposition"
                    },
                    {
                        "value":"lsqr",
                        "label":"Least squares"
                    },
                    {
                        "value":"eigen",
                        "label": "Eigenvalue decomposition"
                    }
                ],
                "gridParam": true
            },
            {
                "name": "n_components",
                "label": "Number of components",
                "description":"Number of components (<= min(n_classes - 1, n_features)) for dimensionality reduction. If None, will be set to min(n_classes - 1, n_features).",
                "type": "DOUBLES",
                "defaultValue": [1],
                "allowDuplicates": false,
                "gridParam": true
            },
            {
                "name": "tol",
                "label": "Tolerance",
                "description": "Threshold for rank estimation in SVD solver.",
                "type": "DOUBLES",
                "defaultValue": [0.0001],
                "allowDuplicates": false,
                "gridParam": true
            }
        ]
    }
    

algo.py
    
    
    # This file is the actual code for the custom Python algorithm ml-algo-test_linear-test
    from dataiku.doctor.plugins.custom_prediction_algorithm import BaseCustomPredictionAlgorithm
    from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
    
    class CustomPredictionAlgorithm(BaseCustomPredictionAlgorithm):    
        """
            Class defining the behaviour of `ml-algo-test_linear-test` algorithm:
            - how it handles parameters passed to it
            - how the estimator works
    
            Example here defines an Adaboost Regressor from Scikit Learn that would work for regression
            (see https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.AdaBoostRegressor.html)
    
            You need to at least define a `get_clf` method that must return a scikit-learn compatible model
    
            Args:
                prediction_type (str): type of prediction for which the algorithm is used. Is relevant when 
                                       algorithm works for more than one type of prediction.
                                       Possible values are: "BINARY_CLASSIFICATION", "MULTICLASS", "REGRESSION"
                params (dict): dictionary of params set by the user in the UI.
        """
        
        def __init__(self, prediction_type=None, params=None):        
            self.clf = LinearDiscriminantAnalysis()
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

---

## [tutorials/plugins/processor/generality/index]

# Creating a plugin Processor component

In this tutorial, you will learn how to create your own plugins by developing a preparation processor (or Prepare recipe step) that hides certain words in a dataset’s column.

## Prerequisites

This lesson assumes that you have a:

  * A basic understanding of coding in Dataiku.

  * A Dataiku version 12.0 or above (the [free edition](<https://www.dataiku.com/product/plans-and-features/>) is compatible.)

  * A Python code environment that includes the `matplotlib` package.

Note

This tutorial was tested using a **Python 3.10** code environment, other Python versions may be compatible.




## Creating a plugin preparation processor component

A preparation processor provides a visual user interface for implementing a Python function as a _Prepare_ recipe step. The processor will hide certain words that appear in a dataset’s column.

Tip

Preparation processors work on rows independently; therefore, only Python functions that perform row implementations are valid. If your Python function performs column aggregates, for example, it won’t be a proper preparation processor.

Also, preparation in Dataiku should be interactive. Thus, the code that is executed should be fast.

To create a plugin preparation processor component:

  1. From the Application menu, select **Plugins**.

  2. Select **Add Plugin > Write your own**.

  3. Give the new plugin a name like `hiding-words-processor` and click **Create**.

  4. Click **+Create Your First Component** and select **Preparation Processor**.

  5. Give the new component an identifier and click **Add**.




The preparation processor plugin component comprises two files: a configuration file (`processor.json`) and a code file (`processor.py`). They are composed of code samples that need to be modified.

### Editing the JSON descriptor

The JSON file contains the metadata (`"meta"`) and the parameters (`"params"`) to be described by the user for the plugin. For our example, the JSON can be modified as follows:

`processor.json`
    
    
    /* This file is the descriptor for the Custom Python step: Hide Text */
    {
        
        "meta" : {
            // label: name of the data prep step as displayed, should be short
            "label": "Hide text",
    
            // description: longer string to help end users understand what this data prep step does
            "description": "Hides words that appear in text.",
    
            // icon: must be one of the FontAwesome 3.2.1 icons, complete list here at https://fontawesome.com/v3.2.1/icons/
            "icon": "icon-asterisk"
        },
    
        /*
         * the processor mode, dictating what output is expected:
         * - CELL : the code outputs a value
         * - ROW : the code outputs a row
         * - ROWS : the code outputs an array of rows
         */
        "mode": "CELL",
    
        /* params:
        Dataiku will generate a formular from this list of requested parameters.
        Your component code can then access the value provided by users using the "name" field of each parameter.
    
        Available parameter types include:
        STRING, INT, DOUBLE, BOOLEAN, DATE, SELECT, TEXTAREA, MAP, PRESET and others.
    
        For the full list and for more details, see the documentation: https://doc.dataiku.com/dss/latest/plugins/reference/params.html
        */
        "params": [
            {
                "name": "input_column",
                "label": "Input column",
                "type": "COLUMN",
                "description": "Column containing the text to be processed.",
                "columnRole": "main",
                "mandatory": true
            },
            {
                "name": "input_list_hide",
                "label": "Words to hide",
                "type": "STRING",
                "description": "List of words to hide separated by commas",
                "defaultValue": "dodge, ford",
                "mandatory": true
            }
        ],
        
        "useKernel" : true
        }
    

The highlighted lines define a parameter that holds the list of words hidden by the plugin action.

For more information on the customizations in the JSON file, see [Component: Preparation Processor](<https://doc.dataiku.com/dss/latest/plugins/reference/preparation.html> "\(in Dataiku DSS v14\)") in the reference documentation.

### Editing the Python code

We want the processor to hide certain words that appear in our dataset in a case-insensitive manner. To do that, we can use a python functions that take each rows of the dataset as a parameter and returns the modified row.

`processor.py`
    
    
    # Note: this processor hides specific words appearing in text in a case-insensitive manner.
    # You can fill the text_to_hide lists with the words you want to hide. 
    
    def process(row):
        # Retrieve the user-defined input column
        text_column = params["input_column"]
    
        # List of words to hide (ensure case-insensitive)
        text_to_hide = params["input_list_hide"]
    
        # Hide words from list
        text_list = row[text_column].split(" ")
        text_list_hide = [w if w.casefold() not in text_to_hide else "****" for w in text_list]
        
        return " ".join(text_list_hide)
    

The highlighted lines show how to retrieve the source column name and the list of words that the plugin will hide.

### Testing the preparation processor

First, prepare your dataset and the recipe:

  1. Create the `cars` dataset by uploading this [CSV file](<https://cdn.downloads.dataiku.com/public/website-additional-assets/data/cars.csv>).

  2. In the Flow, select the `cars` dataset, and click the **Actions** icon (+) in the right panel to open the **Actions** tab.

  3. Under the **Visual Recipes** section, click on **Prepare**. The New data preparation recipe window opens.

  4. Keep `cars` as the input dataset.

  5. Name the output dataset `cars_prepared`.

  6. Click **Create Recipe**.




Then, you can test the processor component from the Prepare recipe in the Flow.

  1. In the Prepare recipe, click **+Add a New Step**.

  2. Begin to search for `Hide text` and select **Hide text**.

  3. Configure the processor as follows:

     * **Output column** : `name_with_hidden_words`

     * **Input column** : `name`

     * **Words to hide** : `dodge, ford, chevrolet`

  4. Scroll across the Preview page to view the output column _Hidden_Text_Column_ with text hidden (that is, replaced with “****”).

  5. **Run** the Prepare recipe.




## What’s next?

In this lesson, you have learned how to create a custom preparation for recipes. You can check other [tutorials on plugins](<../../index.html>) to see how you can mutualize more components.

processor.json
    
    
    /* This file is the descriptor for the Custom Python step: Hide Text */
    {
        
        "meta" : {
            // label: name of the data prep step as displayed, should be short
            "label": "Hide text",
    
            // description: longer string to help end users understand what this data prep step does
            "description": "Hides words that appear in text.",
    
            // icon: must be one of the FontAwesome 3.2.1 icons, complete list here at https://fontawesome.com/v3.2.1/icons/
            "icon": "icon-asterisk"
        },
    
        /*
         * the processor mode, dictating what output is expected:
         * - CELL : the code outputs a value
         * - ROW : the code outputs a row
         * - ROWS : the code outputs an array of rows
         */
        "mode": "CELL",
    
        /* params:
        Dataiku will generate a formular from this list of requested parameters.
        Your component code can then access the value provided by users using the "name" field of each parameter.
    
        Available parameter types include:
        STRING, INT, DOUBLE, BOOLEAN, DATE, SELECT, TEXTAREA, MAP, PRESET and others.
    
        For the full list and for more details, see the documentation: https://doc.dataiku.com/dss/latest/plugins/reference/params.html
        */
        "params": [
            {
                "name": "input_column",
                "label": "Input column",
                "type": "COLUMN",
                "description": "Column containing the text to be processed.",
                "columnRole": "main",
                "mandatory": true
            },
            {
                "name": "input_list_hide",
                "label": "Words to hide",
                "type": "STRING",
                "description": "List of words to hide separated by commas",
                "defaultValue": "dodge, ford",
                "mandatory": true
            }
        ],
        
        "useKernel" : true
        }
    

processor.py
    
    
    # Note: this processor hides specific words appearing in text in a case-insensitive manner.
    # You can fill the text_to_hide lists with the words you want to hide. 
    
    def process(row):
        # Retrieve the user-defined input column
        text_column = params["input_column"]
    
        # List of words to hide (ensure case-insensitive)
        text_to_hide = params["input_list_hide"]
    
        # Hide words from list
        text_list = row[text_column].split(" ")
        text_list_hide = [w if w.casefold() not in text_to_hide else "****" for w in text_list]
        
        return " ".join(text_list_hide)

---

## [tutorials/plugins/processor/index]

# Processor plugin component

This section contains learning materials about the plugin component: Preparation Processor.

---

## [tutorials/plugins/project-standards/flow-zone-check]

# Creating a Project Standards Check component

Project Standards Checks are plugin components that allow you to perform custom quality checks from the Project Standards tab. These checks verify that a project meets specified criteria before deployment and during operation. Use this component when you need custom checks beyond those provided by Dataiku.

This tutorial demonstrates how to create a custom check, using an example that counts objects within a flow zone.

## Prerequisite

  * Dataiku >= 14.2

  * Develop plugin permission

  * Python >= 3.9




## Introduction

To develop a Project Standard Check (abbreviated by Check in this tutorial), you must first create a plugin (or use an existing one). Go to the main menu, click the **Plugins** menu, and select **Write your own** from the **Add plugin** button. Then choose a meaningful name. Once the plugin is created, click the **Create a code environment** button and select **Python** as the default language. Once you have saved the modification, go to the **Summary** tab to build the plugin code environment. The check will use this code environment when it is used.

Click the **\+ New component** button, and choose the **Project Standards Check Spec** component in the provided list, as show in Fig. 1. Then, complete the form by choosing a meaningful **Identifier** and clicking the **Add** button.

Figure 1: New Project Standards Check Spec component.

Alternatively, you can select the **Edit** tab and, under the plugin directory, create a folder named `python-project-standards-check-specs`. This directory is where you will find and create your custom check. Under this directory, create a directory with a meaningful name representing your **Project Standards Check** component.

## Creating the Project Standards Check

A Check is created by creating two files: `project_standards_check_spec.json` and `project_standards_check_spec.py`. The JSON file contains the configuration file, and the Python file is where you will code the behavior of your Check.

### Configuring the Check

Code 1 displays the global structure of the configuration file; the highlighted lines are specific to the check component. In this tutorial, you will create a simple Check that checks if there are no empty flow zones (or if a flow zone contains enough objects) and if a flow zone does not contain too many objects.

So you just need to define two parameters:

  * `min_objects_by_zone`: to define the minimum number of objects a flow zone should contain.

  * `max_objects_by_zone`: to define the maximum number of objects a flow zone should contain.




Code 1 – Configuration file
    
    
    /* This file is the descriptor for the Custom python Project Standards Check spec flow-zone-check */
    {
      "meta": {
        "label": "Flow zone size",
        "description": "A tutorial on how to create a project standard",
        "icon": "fas fa-code"
      },
      /* optional list of tags.
      */
      "tags": [],
      /* params:
      DSS will generate a formular from this list of requested parameters.
      Your component code can then access the value provided by users using the "name" field of each parameter.
    
      Available parameter types include:
      STRING, INT, DOUBLE, BOOLEAN, DATE, SELECT, TEXTAREA, PRESET and others.
    
      For the full list and for more details, see the documentation: https://doc.dataiku.com/dss/latest/plugins/reference/params.html
      */
      "params": [
        {
          "name": "min_objects_by_zone",
          "label": "Minimum number of objects in a flow zone.",
          "type": "INT",
          "defaultValue": 1,
          "mandatory": true
        },
        {
          "name": "max_objects_by_zone",
          "label": "Maximum number of objects in a flow zone",
          "type": "INT",
          "defaultValue": 10,
          "mandatory": true
        }
      ]
    }
    

### Coding the Check

To code a Check, you must create a class derived from the `ProjectStandardsCheckSpec` class. In this new class, the only mandatory function is the `run` function. This is where you will code your Check.

You can access the component configuration by using the `config` object. For example, if you need to retrieve the _Minimum number of objects_ in a flow zone previously configured, you should use: `self.config.get('min_objects_by_zone')`.

The `run` function should return one of the following:

  * `success(message)`: when the Check succeeded.

  * `failure(severity, message)`: if you consider the Check is failing. You can use severity from 0 to 5

    * If you use severity 0, it will be considered a success. In that case, you should use the success method.

    * 1 is the weakest failure and 5 is for a critical failure. Numbers in between are gradually increasing.

  * `not_applicable(message)`: if the check is not applicable to the project.

  * `error(message)`: if you want to mark the check as an error. You can also raise an Exception.




With an understanding of these situations, proceed to code the check, as shown in Code 2.

Code 2 – Code to check the number of obects in a flow zone
    
    
        def run(self):
            project = self.project
            min_objects = self.config.get('min_objects_by_zone')
            max_objects = self.config.get('max_objects_by_zone')
            flow = project.get_flow()
            zones = flow.list_zones()
            counts = [(zone.name, len(zone.items)) for zone in zones]
            under = [count for count in counts if count[1] < min_objects]
            over = [count for count in counts if count[1] > max_objects]
            if not (under) and not (over):
                return ProjectStandardsCheckRunResult.success("Everything is Ok.")
            else:
                return ProjectStandardsCheckRunResult.failure(3,
                                                              f"{len(under) + len(over)} flow zones do not match the criteria defined in the Project Standards Check.")
    

## Using the Project Standards Check

Once you have coded your Check, you need to declare it in the **Project Standards > Check library**, then add it to a **Scope** , as mentioned in the [official documentation](<https://doc.dataiku.com/dss/latest/mlops/project-standards/settings.html> "\(in Dataiku DSS v14\)")

To add your Check to the **Project standards > Check library**, go to the **Main** menu, select the **Administration** option, and then select the **Project standards** tab. Click the **\+ Add checks** , fill the form by selecting your plugin as a **source** , and your Check as a **Checks** , as shown in Fig. 2.

Figure 2 – Adding a Check to Project Standards.

Once you have added your Check, you need to add it to a scope (or create a new one if you don’t have one). Select the **Scopes** tab on the left panel, click the **\+ Add scope** , fill the form, and the click the **Save** button. Fig. 3 shows the result of adding a new scope to a project.

If your project does not belong to a scope, you won’t be able to run a **Project Standards** action.

There are three different ways of selecting a project:

  * By using the _project key_ , you will then select all projects on which you want to apply the scope.

  * By using a _folder_ , all projects within it will inherit the scope.

  * By using the _tag_ selector, all projects that are tagged by one of the tags you have selected will inherit the scope.




Figure 3 – Defining a new scope.

Now that you have defined the scope of the Check, you can test it in the project. Select the project that the Check is associated with, go to the **Flow** , select the **Projects Standards** action, and click the **Run** button. This will generate a report for your project, based on your Check (and all other checks associated with your project).

Note

The **Projects Standards** action will not be available if you have selected something in the **Flow**.

Figure 4: Running a check.

## Conclusion

You have now learned the essentials of creating a Project Standards Check and can define verification requirements for your project.

Here is the complete code of the **Project Standards Check component** :

project-standards-check.json
    
    
    /* This file is the descriptor for the Custom python Project Standards Check spec flow-zone-check */
    {
      "meta": {
        "label": "Flow zone size",
        "description": "A tutorial on how to create a project standard",
        "icon": "fas fa-code"
      },
      /* optional list of tags.
      */
      "tags": [],
      /* params:
      DSS will generate a formular from this list of requested parameters.
      Your component code can then access the value provided by users using the "name" field of each parameter.
    
      Available parameter types include:
      STRING, INT, DOUBLE, BOOLEAN, DATE, SELECT, TEXTAREA, PRESET and others.
    
      For the full list and for more details, see the documentation: https://doc.dataiku.com/dss/latest/plugins/reference/params.html
      */
      "params": [
        {
          "name": "min_objects_by_zone",
          "label": "Minimum number of objects in a flow zone.",
          "type": "INT",
          "defaultValue": 1,
          "mandatory": true
        },
        {
          "name": "max_objects_by_zone",
          "label": "Maximum number of objects in a flow zone",
          "type": "INT",
          "defaultValue": 10,
          "mandatory": true
        }
      ]
    }
    

project-standards-check.py
    
    
    from dataiku.project_standards import (
        ProjectStandardsCheckRunResult,
        ProjectStandardsCheckSpec,
    )
    
    
    class MyProjectStandardsCheckSpec(ProjectStandardsCheckSpec):
    
        def run(self):
            project = self.project
            min_objects = self.config.get('min_objects_by_zone')
            max_objects = self.config.get('max_objects_by_zone')
            flow = project.get_flow()
            zones = flow.list_zones()
            counts = [(zone.name, len(zone.items)) for zone in zones]
            under = [count for count in counts if count[1] < min_objects]
            over = [count for count in counts if count[1] > max_objects]
            if not (under) and not (over):
                return ProjectStandardsCheckRunResult.success("Everything is Ok.")
            else:
                return ProjectStandardsCheckRunResult.failure(3,
                                                              f"{len(under) + len(over)} flow zones do not match the criteria defined in the Project Standards Check.")
    

## Reference documentation

### Classes

[`dataikuapi.dss.project.DSSProject`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
---|---  
[`dataikuapi.dss.project_standards.DSSProjectStandardsCheck`](<../../../api-reference/python/project-standards.html#dataikuapi.dss.project_standards.DSSProjectStandardsCheck> "dataikuapi.dss.project_standards.DSSProjectStandardsCheck")(...) | A check for Project Standards  
[`dataikuapi.dss.project_standards.DSSProjectStandardsCheckRunResult`](<../../../api-reference/python/project-standards.html#dataikuapi.dss.project_standards.DSSProjectStandardsCheckRunResult> "dataikuapi.dss.project_standards.DSSProjectStandardsCheckRunResult")(data) | The result of the check run  
  
### Functions

[`get_flow`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_flow> "dataikuapi.dss.project.DSSProject.get_flow")() | 

returns:
    A Flow handle  
---|---  
[`list_zones`](<../../../api-reference/python/flow.html#dataikuapi.dss.flow.DSSProjectFlow.list_zones> "dataikuapi.dss.flow.DSSProjectFlow.list_zones")() | Lists all zones in the Flow.

---

## [tutorials/plugins/project-standards/index]

# Project Standards Check component

This section contains learning materials about the plugin component: Project Standards Check.

---

## [tutorials/plugins/recipes/generality/index]

# Creating a plugin Recipe component

## Prerequisites

  * Dataiku >= 12.0

  * Access to a dataiku instance with the “Develop plugins” permissions

  * Access to an existing project with the following permissions:
    
    * “Read project content”

    * “Write project content”




## Introduction

Creating a custom recipe component is an easy way to add a new recipe to Dataiku via plugins. Doing so will make your recipe easily accessible alongside standard ones in the Plugin recipes section.

All recipes in Dataiku share the same essential function of taking data as input and producing new data as output. Recipes can operate with three types of data: datasets, managed folders or saved models. A recipe can even handle multiple types of data at once. Beyond this, recipes can be further customized to suit specific needs by requesting user input before running the recipe. Plugins are divided into a code file and configuration file.

## Recipe creation

You will create a recipe for this tutorial and convert it to a plugin component. As this tutorial focuses only on recipe creation, let’s re-use the default code provided by Dataiku when you create a Python recipe.

  1. Create the `cars` dataset by uploading this [CSV file](<https://cdn.downloads.dataiku.com/public/website-additional-assets/data/cars.csv>) (or you can use any existing dataset).

  2. Select the **Python recipe** from the **Code recipes** action panel.

  3. Create a new output dataset named `cars_copy`.

  4. Then click on the **Create Recipe** button.




Let’s create a plugin from this new recipe:

  1. Still in the recipe code editor, from the **Actions** panel, click **Convert to plugin**.

  2. Choose the most suitable option for you (either **New plugin** or **Existing dev plugin**),

  3. Enter `plugin-datasets-copy` in the **Plugin id** field.

  4. Enter `datasets-copy` in the **New plugin recipe id** field.

Note

Several recipes can be nested in one plugin. Choose the name so it can be clearly identified amongst other recipes.

  5. Click on the **Convert** button.




## Configuration File: `recipe.json`

Code 1 is the default configuration file for the custom recipe generated by Dataiku. This file is divided into four sections: `meta`, `inputRoles`, `outputRoles`, and `params`.

  * The `meta` represents the global description of the recipe.

  * The `inputRoles` describes which input the recipe takes as parameters.

  * The `outputRoles` describes which output the recipe produces.

  * The `params` defines which parameters the recipe takes into consideration.


Code 1: `recipe.json`

Code 1: `recipe.json`
    
    
    // This file is the descriptor for the Custom code recipe datasets-copy
    {
      // Meta data for display purposes
      "meta": {
        // label: name of the recipe as displayed, should be short
        "label": "Datasets copy",
        // description: longer string to help end users understand what this recipe does
        "description": "",
        // icon: must be one of the FontAwesome 3.2.1 icons, complete list here at https://fontawesome.com/v3.2.1/icons/
        "icon": "icon-puzzle-piece"
      },
      "kind": "PYTHON",
      // Inputs and outputs are defined by roles. In the recipe's I/O tab, the user can associate one
      // or more dataset to each input and output role.
    
      // The "arity" field indicates whether the user can associate several datasets to the role ('NARY')
      // or at most one ('UNARY'). The "required" field indicates whether the user is allowed to
      // associate no dataset with the role.
    
      "inputRoles": [
        {
          "name": "input_A_role",
          "label": "input A displayed name",
          "description": "what input A means",
          "arity": "UNARY",
          "required": true,
          "acceptsDataset": true
        },
        {
          "name": "input_B_role",
          "label": "input B displayed name",
          "description": "what input B means",
          "arity": "NARY",
          "required": false,
          "acceptsDataset": true
          // ,'mustBeSQL': true
          // ,'mustBeStrictlyType':'HDFS'
        }
        // ...
      ],
      "outputRoles": [
        {
          "name": "main_output",
          "label": "main output displayed name",
          "description": "what main output means",
          "arity": "UNARY",
          "required": false,
          "acceptsDataset": true
        },
        {
          "name": "errors_output",
          "label": "errors output displayed name",
          "description": "what errors output means",
          "arity": "UNARY",
          "required": false,
          "acceptsDataset": true
        }
        // ...
      ],
      /* The field "params" holds a list of all the params
         for wich the user will be prompted for values in the Settings tab of the recipe.
    
         The available parameter types include:
         STRING, STRINGS, INT, DOUBLE, BOOLEAN, SELECT, MULTISELECT, MAP, TEXTAREA, PRESET, COLUMN, COLUMNS
    
         For the full list and for more details, see the documentation: https://doc.dataiku.com/dss/latest/plugins/reference/params.html
      */
    
      "params": [
        {
          "name": "parameter1",
          "label": "User-readable label",
          "type": "STRING",
          "description": "Some documentation for parameter1",
          "mandatory": true
        },
        {
          "name": "parameter2",
          "type": "INT",
          "defaultValue": 42
          /* Note that standard json parsing will return it as a double in Python (instead of an int), so you need to write
             int(get_recipe_config()['parameter2'])
          */
        },
        // A "SELECT" parameter is a multi-choice selector. Choices are specified using the selectChoice field
        {
          "name": "parameter3",
          "type": "SELECT",
          "selectChoices": [
            {
              "value": "val_x",
              "label": "display name for val_x"
            },
            {
              "value": "val_y",
              "label": "display name for val_y"
            }
          ]
        },
        // A 'COLUMN' parameter is a string, whose value is a column name from an input schema.
        // To specify the input schema whose column names are used, use the "columnRole" field like below.
        // The column names will come from the schema of the first dataset associated to that role.
        {
          "name": "parameter4",
          "type": "COLUMN",
          "columnRole": "input_B_role"
        }
    
        // The 'COLUMNS' type works in the same way, except that it is a list of strings.
      ],
      // The field "resourceKeys" holds a list of keys that allows to limit the number
      // of concurrent executions and activities triggered by this recipe.
      //
      // Administrators can configure the limit per resource key in the Administration > Settings > Flow build
      // screen.
    
      "resourceKeys": []
    }
    

### Meta configuration

In the `"meta"` section, you will define the following:

  * `"description"`: the recipe’s purpose.

  * `"icon"`: the icon to represent it.

  * `"label"`: the name of the recipe




Using the definition shown in Code 2,

Code 2: `recipe.json`, `"meta"` section.
    
    
        "meta": {
            "label": "Datasets copy",
            "description": "Duplicate a dataset",
            "icon": "icon-copy"
        },
    

### Input and ouput configuration

Each recipe can take some input. The `"inputRoles"` section is the place where you will define those inputs. As a recipe can take more than one input, `"inputRoles"` is an array representing those inputs. Each object in this array will represent one input.

For each object, you have to define the following:

  * `"name"`: the name of the variable in the associated code.

  * `"label"`: title for the input in the UI.

  * `"description"`: description of what this input is for (displayed in the UI when the user requires it or in the “Run” screen).

  * `"arity"`: choice between two values: `"UNARY"` or `"NARY"`, meaning that this input is composed of one or multiple inputs.

  * `"required"`: whether this input is required or not.

  * `"acceptsDataset"`: whether this input takes a dataset as an input (optional, `true` by default).

  * `"acceptsManagedFolder"`: whether this input takes a managed folder as an input (optional, `false` by default).

  * `"acceptsSavedModel"`: whether a saved model can be used for this input (optional, `false` by default).




For example, if you need only one input, which is the case in our case, you should define your input like in Code 3.

Code 3: `recipe.json`, `"inputRoles""` section.
    
    
        "inputRoles": [
            {
                "name": "dataset_to_copy",
                "label": "Dataset to copy",
                "description": "Which dataset you want to copy",
                "arity": "UNARY",
                "required": true,
                "acceptsDataset": true
            }
        ],
    

The `"outputRoles"` section serves the same purpose as the `"inputRoles"` section, except it is dedicated to defining the recipe outputs.

### Params configuration

In this section, you will define all the needed parameters for your recipe to run. [Refer to this tutorial](<../recipes-clipping-dataset/index.html#tutorial-plugin-recipes-automatic-clipping-parameters-definition>) which provides more information on the _params_ section.

### Complete code

Code 4 shows the complete code of the configuration file for the recipe.

Code 4: `recipe.json`, `"inputRoles""` section.
    
    
    {
        "meta": {
            "label": "Datasets copy",
            "description": "Duplicate a dataset",
            "icon": "icon-copy"
        },
        "inputRoles": [
            {
                "name": "dataset_to_copy",
                "label": "Dataset to copy",
                "description": "Which dataset you want to copy",
                "arity": "UNARY",
                "required": true,
                "acceptsDataset": true
            }
        ],
        "selectableFromDataset": "dataset_to_copy",
        "outputRoles": [
            {
                "name": "copied_dataset",
                "label": "Result dataset",
                "description": "This is where the dataset is copied.",
                "arity": "UNARY",
                "required": true,
                "acceptsDataset": true
            }
        ],
        "kind": "PYTHON",
        "params": [
        ],
        "resourceKeys": []
    
    }
    

The highlighted `"selectableFromDataset"` parameter allows the recipe to appear in the plugin list, in the action panel, when selecting a dataset.

Warning

If you omit it, the user has to go into the **+Recipe** button menu to find your plugin, select it, and then select the custom recipe.

If you want your recipe to appear when selecting a managed folder, an ML saved model or a GenAI model/agent, you should use `"selectableFromFolder"`, `"selectableFromMLModel"` or `"selectableFromPromptableModel"`, respectively.

Note

You may change the `"acceptsDataset": true` parameter into the corresponding type of input in the `"inputRoles"` section.

## Code File: `recipe.py`

If you look at the generated code (Code 5), you will see two blocs. One is the starter code generated by Dataiku, and the other bloc is your original recipe (the highlighted lines). You need to adapt your code to fit into the custom recipe pattern.

Code 5: Generated python sample `recipe.py`

Code 5: generated Python code
    
    
    # Code for custom code recipe datasets-copy (imported from a Python recipe)
    
    # To finish creating your custom recipe from your original PySpark recipe, you need to:
    #  - Declare the input and output roles in recipe.json
    #  - Replace the dataset names by roles access in your code
    #  - Declare, if any, the params of your custom recipe in recipe.json
    #  - Replace the hardcoded params values by acccess to the configuration map
    
    # See sample code below for how to do that.
    # The code of your original recipe is included afterwards for convenience.
    # Please also see the "recipe.json" file for more information.
    
    # import the classes for accessing Dataiku objects from the recipe
    import dataiku
    # Import the helpers for custom recipes
    from dataiku.customrecipe import get_input_names_for_role
    from dataiku.customrecipe import get_output_names_for_role
    from dataiku.customrecipe import get_recipe_config
    
    # Inputs and outputs are defined by roles. In the recipe's I/O tab, the user can associate one
    # or more dataset to each input and output role.
    # Roles need to be defined in recipe.json, in the inputRoles and outputRoles fields.
    
    # To  retrieve the datasets of an input role named 'input_A' as an array of dataset names:
    input_A_names = get_input_names_for_role('input_A_role')
    # The dataset objects themselves can then be created like this:
    input_A_datasets = [dataiku.Dataset(name) for name in input_A_names]
    
    # For outputs, the process is the same:
    output_A_names = get_output_names_for_role('main_output')
    output_A_datasets = [dataiku.Dataset(name) for name in output_A_names]
    
    # The configuration consists of the parameters set up by the user in the recipe Settings tab.
    
    # Parameters must be added to the recipe.json file so that Dataiku can prompt the user for values in
    # the Settings tab of the recipe. The field "params" holds a list of all the params for wich the
    # user will be prompted for values.
    
    # The configuration is simply a map of parameters, and retrieving the value of one of them is simply:
    my_variable = get_recipe_config()['parameter_name']
    
    # For optional parameters, you should provide a default value in case the parameter is not present:
    my_variable = get_recipe_config().get('parameter_name', None)
    
    # Note about typing:
    # The configuration of the recipe is passed through a JSON object
    # As such, INT parameters of the recipe are received in the get_recipe_config() dict as a Python float.
    # If you absolutely require a Python int, use int(get_recipe_config()["my_int_param"])
    
    
    #############################
    # Your original recipe
    #############################
    
    # -*- coding: utf-8 -*-
    import dataiku
    import pandas as pd, numpy as np
    from dataiku import pandasutils as pdu
    
    # Read recipe inputs
    cars = dataiku.Dataset("cars")
    cars_df = cars.get_dataframe()
    
    # Compute recipe outputs from inputs
    # TODO: Replace this part by your actual code that computes the output, as a Pandas dataframe
    # NB: Dataiku also supports other kinds of APIs for reading and writing data. Please see doc.
    
    cars_copy_df = cars_df  # For this sample code, simply copy input to output
    
    # Write recipe outputs
    cars_copy = dataiku.Dataset("cars_copy")
    cars_copy.write_with_schema(cars_copy_df)
    

The first thing you need to do is change your recipe’s input and output. Previously, your recipe acted on a known dataset. As you turn it into a custom recipe, you should get the user input defined in the `"inputRoles"` section of the `recipe.json` file.

In this file, you have defined `dataset_to_copy` as the name of the `"inputRoles"`, so you should now extract the name of the dataset by using the code shown in Code 6.

Code 6: How to access to the dataset specified by the user.
    
    
    # To retrieve the datasets of an input role named 'dataset_to_copy' as an array of dataset names:
    datasets_to_copy = get_input_names_for_role('dataset_to_copy')
    # The two lines below show two different ways to access to the wanted dataset
    # dataset_to_copy = [dataiku.Dataset(name) for name in datasets_to_copy][0]
    dataset_to_copy = dataiku.Dataset(datasets_to_copy[0])
    

The function [`dataiku.customrecipe.get_input_names_for_role()`](<../../../../api-reference/python/plugin-components/custom_recipes.html#dataiku.customrecipe.get_input_names_for_role> "dataiku.customrecipe.get_input_names_for_role") returns an array (because the `inputRole` object can be defined as `"NARY"`) of names defined by the user when filling the form (L. 2). As your inputRoles (`dataset_to_copy`) is `"UNARY"`, you can assume that there will be only one name in the function [`dataiku.customrecipe.get_input_names_for_role()`](<../../../../api-reference/python/plugin-components/custom_recipes.html#dataiku.customrecipe.get_input_names_for_role> "dataiku.customrecipe.get_input_names_for_role") response (L. 5). So you can easily access to the dataset.

The same process can be applied to the “outputRoles”.

Once you have your two datasets (input and output), you must adapt your original code, as shown in Code 7.

Code 7: Complete code of the custom recipe.
    
    
    # import the classes for accessing Dataiku objects from the recipe
    import dataiku
    # Import the helpers for custom recipes
    from dataiku.customrecipe import get_input_names_for_role
    from dataiku.customrecipe import get_output_names_for_role
    from dataiku.customrecipe import get_recipe_config
    
    # To retrieve the datasets of an input role named 'dataset_to_copy' as an array of dataset names:
    datasets_to_copy = get_input_names_for_role('dataset_to_copy')
    # The two lines below show two different ways to access to the wanted dataset
    # dataset_to_copy = [dataiku.Dataset(name) for name in datasets_to_copy][0]
    dataset_to_copy = dataiku.Dataset(datasets_to_copy[0])
    
    # For outputs, the process is the same:
    copied_datasets = get_output_names_for_role('copied_dataset')
    copied_dataset = [dataiku.Dataset(name) for name in copied_datasets][0]
    
    # Using the input dataset
    dataset_to_copy_df = dataset_to_copy.get_dataframe()
    
    # Your algorithm
    copied_dataset_df = dataset_to_copy_df
    
    # Using the output dataset
    copied_dataset.write_with_schema(copied_dataset_df)
    

## Wrapping up

You have completed this tutorial and built your first custom recipe. Understanding all these basic concepts allows you to create more complex custom recipes.

You can add a parameter to your recipe to only copy a subset of the initial dataset. [This tutorial](<../recipes-clipping-dataset/index.html>) could provide helpful ideas and show a more complex custom recipe dealing with parameters and a valuable algorithm.

Here is the complete version of the code presented in this tutorial:

recipe.json
    
    
    {
        "meta": {
            "label": "Datasets copy",
            "description": "Duplicate a dataset",
            "icon": "icon-copy"
        },
        "inputRoles": [
            {
                "name": "dataset_to_copy",
                "label": "Dataset to copy",
                "description": "Which dataset you want to copy",
                "arity": "UNARY",
                "required": true,
                "acceptsDataset": true
            }
        ],
        "selectableFromDataset": "dataset_to_copy",
        "outputRoles": [
            {
                "name": "copied_dataset",
                "label": "Result dataset",
                "description": "This is where the dataset is copied.",
                "arity": "UNARY",
                "required": true,
                "acceptsDataset": true
            }
        ],
        "kind": "PYTHON",
        "params": [
        ],
        "resourceKeys": []
    
    }
    

recipe.py
    
    
    # import the classes for accessing Dataiku objects from the recipe
    import dataiku
    # Import the helpers for custom recipes
    from dataiku.customrecipe import get_input_names_for_role
    from dataiku.customrecipe import get_output_names_for_role
    from dataiku.customrecipe import get_recipe_config
    
    # To retrieve the datasets of an input role named 'dataset_to_copy' as an array of dataset names:
    datasets_to_copy = get_input_names_for_role('dataset_to_copy')
    # The two lines below show two different ways to access to the wanted dataset
    # dataset_to_copy = [dataiku.Dataset(name) for name in datasets_to_copy][0]
    dataset_to_copy = dataiku.Dataset(datasets_to_copy[0])
    
    # For outputs, the process is the same:
    copied_datasets = get_output_names_for_role('copied_dataset')
    copied_dataset = [dataiku.Dataset(name) for name in copied_datasets][0]
    
    # Using the input dataset
    dataset_to_copy_df = dataset_to_copy.get_dataframe()
    
    # Your algorithm
    copied_dataset_df = dataset_to_copy_df
    
    # Using the output dataset
    copied_dataset.write_with_schema(copied_dataset_df)

---

## [tutorials/plugins/recipes/index]

# Recipes

This section contains several learning materials about the plugin component: Recipes.

---

## [tutorials/plugins/recipes/recipes-clipping-dataset/index]

# Writing a custom recipe to remove outliers from a dataset

## Prerequisites

  * Dataiku >= 11.0

  * “Develop plugins” permission

  * A Python code environment with `scikit-learn` packages installed (see the [documentation](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html> "\(in Dataiku DSS v14\)") for more details) if you want to be able to load the dataset from the code.




This tutorial was written with Python 3.9 and with the package `scikit-learn==1.2.2`.

## Context

A dataset can sometimes be polluted by a fraction of irrelevant values called _outliers_. These outliers may wrongly skew the dataset’s statistical distribution and lead to false interpretations, so they must be addressed. One solution is to _clip_ them by capping their value to the boundaries of a user-defined interval. For example, if an interval of [0, 1] is defined, any value lower than 0 becomes 0, and any value greater than 1 becomes 1. As there is no visual recipe in Dataiku to do this processing, this tutorial aims at packaging the relevant code into a custom recipe plugin component to be made available to non-coder users of the instance.

The [iris dataset](<https://scikit-learn.org/stable/auto_examples/datasets/plot_iris_dataset.html>) consists of 3 types of irises’ (Setosa, Versicolour, and Virginica) petal and sepal length, stored in a 150x4 numpy.ndarray. A quick analysis of this dataset, with a boxplot, produces the plot shown in Fig. 1.

Figure 1: Analysis of the iris dataset.

This plot shows that some values can be considered outliers for the “Sepal width” feature so we will clip them. Code 1 is an example of how we can clip values.

Code 1: Clipping the Iris dataset
    
    
    import dataiku
    from dataiku import pandasutils as pdu
    import pandas as pd
    import warnings
    from sklearn import datasets
    warnings.filterwarnings("ignore")
    
    iris = datasets.load_iris()
    df = pd.DataFrame(data= np.c_[iris['data']],
                         columns= iris['feature_names'])
    
    # Column where to clip
    column_name = "sepal width (cm)"
    
    # Compute the quantile and IQR
    Q1 = df[column_name].quantile(0.25)
    Q3 = df[column_name].quantile(0.75)
    IQR = 1.5 * (Q3 - Q1)
    lower = Q1 - IQR
    upper = Q3 + IQR
    
    # Clip values
    df[column_name] = df[column_name].clip(lower=lower, upper=upper)
    

Running Code 1 will produce a clipped dataset, as shown in Fig. 2. In Code 1, we used the interquartile range (IQR) method to measure the dispersion of the data and use a coefficient to detect outliers. For example, applied to the iris dataset, values greater than 4.05 have been replaced by 4.05, affecting three rows where values were 4.4, 4.1, and 4.2. We also replace the value 2.0 with the value 2.05. Depending on the use case, we could clip or remove the outliers.

Figure 2: Visualization of the result of the clipping method.

## Generalization

Code 1 clips values for the iris dataset. To distribute this code, let’s transform it into a code recipe. The input is the Iris dataset, and the output will be a dataset (named `iris_clipped`). Code 2 shows the code recipe from this generalization.

Code 2: Code recipe for clipping values
    
    
    # -*- coding: utf-8 -*-
    import dataiku
    from dataiku import pandasutils as pdu
    import pandas as pd
    import numpy as np
    
    def clip_value(dataset, column_name):
        """
        Clip values from a dataframe.
    
        :param dataset: dataframe to process
        :param columns_name: column where values are clipped
    
        :return: a "clipped" dataset.
        """
        Q1 = dataset[column_name].quantile(0.25)
        Q3 = dataset[column_name].quantile(0.75)
        IQR = 1.5 * (Q3 - Q1)
        lower = Q1 - IQR
        upper = Q3 + IQR
        dataset[column_name] = dataset[column_name].clip(lower=lower, upper=upper)
        return dataset
    
    
    # Read recipe inputs
    iris = dataiku.Dataset("iris")
    iris_df = iris.get_dataframe()
    column_name = "sepal.width"
    
    iris_clipped_df = clip_value(iris_df, column_name)
    
    # Write recipe outputs
    iris_clipped = dataiku.Dataset("iris_clipped")
    iris_clipped.write_with_schema(iris_clipped_df)
    

This code recipe is a way to distribute the code to other people or to apply it to another dataset. Still, the code recipe only partially covers our needs: each time a user wants to leverage it, they have to manually adapt the code to their specific needs. It is not a complicated task, but not the best pattern in terms of usability. Instead, we will create a custom plugin recipe.

## Create a custom plugin recipe

A custom plugin recipe should be created using the “Convert to plugin” button in the action panel. To be able to do that:

  * Edit the **Code recipe**

  * Click the **Actions** button

  * Click the **Convert to plugin** button

  * Select either **New plugin** or **Existing dev plugin**

  * Choose the appropriate **Plugin id**

  * Choose a correct id for the **New plugin recipe id**

  * Click **Convert**




Figure 3: Convert a code recipe to a plugin recipe

Once this is done, Dataiku generates the custom recipe files and opens the editor to allow to modify of the newly created plugin recipe. Fig. 4 shows a directory structure example of a custom plugin recipe named `automatic-clipping`. This plugin recipe is embedded into a plugin called `demonstration`.

Figure 4: Directory structure of a plugin recipe

## Recipe configuration

### Description and configuration

The recipe configuration is done in the `recipe.json` file, which describes the content in more detail in [Component: Recipes](<https://doc.dataiku.com/dss/latest/plugins/reference/recipes.html> "\(in Dataiku DSS v14\)").

## Analysis and inputs

The structure of this recipe is simple: its input dataset contains the raw data, its output dataset is the result of the clipping operation.

This coefficient could be adjusted to better adapt the cleaning of the outliers. It should be a parameter of our recipes.

Datasets rarely contain only numbers, and clipping will work only on numbers. So we need a way to select which columns the clipping function will run. This could also be a parameter.

### Recipe parameters definition

The previous analysis leads to the parameter definition shown in Code 4.

Code 4: Parameter definitions
    
    
    "params": [
        {
            "type": "SEPARATOR",
            "description": "<h3>IQR value</h3>"
        },
        {
            "name": "IQR_coeff",
            "type": "DOUBLE",
            "defaultValue": 1.5,
            "label": "IQR coefficient",
            "mandatory": true
        },
        {
            "type": "SEPARATOR",
            "description": "<h3>Column selection</h3>"
        },
        {
            "name": "columns_to_clip",
            "label": "Columns to clip",
            "type": "COLUMNS",
            "columnRole": "dataset_name"
        }
    ],
    

This parameter definition will produce the user interface shown in Fig. 5.

Figure 5: User interface for the parameter entry

### Input and output Datasets

Input and output Datasets are not handled by the parameter definition but by the `inputRoles` and `outputRoles` of the recipe definition, as shown in Code 5.

Code 5: Input and output Datasets definition
    
    
    "selectableFromDataset": "dataset_name",
    "inputRoles": [
        {
            "name": "dataset_name",
            "label": "Datasets to clip",
            "description": "Automatically remove outliers from a dataset, by clipping the values",
            "arity": "UNARY",
            "required": true,
            "acceptsDataset": true
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
    

The full `recipe.json` is shown in Code 6. When saving, Dataiku may warn that the parameter `null` has no label. This is expected, as we do not define a name or a label for the `SEPARATOR` parameter type.

Code 6: `recipe.json`
    
    
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
                "type": "SEPARATOR",
                "description": "<h3>IQR value</h3>"
            },
            {
                "name": "IQR_coeff",
                "type": "DOUBLE",
                "defaultValue": 1.5,
                "label": "IQR coefficient",
                "mandatory": true
            },
            {
                "type": "SEPARATOR",
                "description": "<h3>Column selection</h3>"
            },
            {
                "name": "columns_to_clip",
                "label": "Columns to clip",
                "type": "COLUMNS",
                "columnRole": "dataset_name"
            }
        ],
        "selectableFromDataset": "dataset_name",
        "resourceKeys": []
    }
    

## Coding the Recipe

Once the recipe is properly defined, we can now dive into the code. First, we should load the data provided by the user, as shown in Code 7.

Code 7: Loading data from the UI
    
    
    import dataiku
    from dataiku.customrecipe import *
    from dataiku import Dataset
    
    from pandas import DataFrame, Series
    
    def load_config():
        """
        Retrieve all parameters entered by the user
    
        :return: dataset input name,
                 dataset output name,
                 IQR coefficient,
                 columns to clip
        """
        # To retrieve the datasets of an input role named 'input_A' as an array of dataset names:
        input_name = dataiku.customrecipe.get_input_names_for_role('dataset_name')[0]
    
        # For output, the process is the same:
        output_name = dataiku.customrecipe.get_output_names_for_role('dataset_clipped')[0]
    
        # IQR value
        IQR_value = dataiku.customrecipe.get_recipe_config().get('IQR_coeff', 1.5)
    
        # columns_to_clip
        columns_to_clip = dataiku.customrecipe.get_recipe_config().get('columns_to_clip', [])
    
        return input_name, output_name, IQR_value, columns_to_clip
    

Then we need to do the clipping (Code 9) and finish by running the whole process: loading, clipping, and saving (Code 10).

Code 9: Clip the selected columns
    
    
    def clip_values(input_dataframe, columns_to_clip, IQR_value):
        """
        Clip values from a dataset.
    
        :param input_dataframe: dataframe to process
        :param columns_to_clip: column where values are clipped
        :param IQR_value: coefficient for clipping
    
        :return: a "clipped" dataset.
        """
        Q1 = input_dataframe[columns_to_clip].quantile(0.25)
        Q3 = input_dataframe[columns_to_clip].quantile(0.75)
        IQR = IQR_value * (Q3 - Q1)
        lower = Q1 - IQR
        upper = Q3 + IQR
        input_dataframe[columns_to_clip] = input_dataframe[columns_to_clip].clip(lower=lower, upper=upper, axis=1)
        return input_dataframe
    

Code 10: Save the result
    
    
    def process():
        """
        Do the global processing.
        Load data, process them, clip dataset and save the dataset.
        """
        input_name, output_name, IQR_value, columns_to_clip = load_config()
        input_dataset = dataiku.Dataset(input_name)
        df = input_dataset.get_dataframe()
        clipped_dataset = clip_values(df, columns_to_clip, IQR_value)
        output = dataiku.Dataset(output_name)
        output.write_with_schema(clipped_dataset)
    
    
    if __name__ == "__main__":
        process()
    

By turning the code recipe into a custom recipe plugin, we now have a generic recipe that can be applied to any dataset. For example, if we load the `california_housing` dataset from scikit learn (`datasets.fetch_california_housing()`), drop the columns: `Population`, `Latitude`, and `Longitude`, the boxplot looks like Fig. 6.

Figure 6: Boxplot for the California housing dataset.

Fig. 7 shows the parameters used to clip the dataset, clipping only `AveOccup` and `AveRooms` columns.

Figure 7: Parameter for clipping the California housing dataset.

And the resulting dataset looks like in Fig. 8.

Figure 8: Result of the clipping.

## Conclusion

In this tutorial, we built a simple custom recipe plugin component that allows non-coder users to clip a dataset. Of course, the processing steps presented here are simple. Still, the true goal of this tutorial is to bootstrap your work as a plugin developer to transform your code into an operational custom visual recipe.

From there, you can look into more elaborate aspects, like:

  * making your code more robust with exception handling and logging

  * adding more input parameters to make the outlier detection more flexible

  * adding a parameter to allow clipping, removing, or keeping the outliers

---

## [tutorials/plugins/sample-dataset/generality/index]

# Creating a sample dataset

When starting a new project, users might struggle to find or use datasets relevant to your company. To overcome these difficulties, Dataiku introduced a new plugin component, Sample Dataset, in version 14. This component lets you provide datasets to quickly start a project.

Once a sample dataset has been created, every user can find it easily either on an empty flow by clicking the “Browse sample data” (Fig. 1) or in the flow view when clicking the **+Add item** button and choosing the sample option in the flow (Fig. 2).

Figure 1: Browse sample dataset.

Figure 2: Add dataset samples.

Whatever your choice, you will end up with a modal that lets the user select a sample dataset (Fig. 3). If you need to provide your users with a new sample dataset, you must develop a sample dataset component in an existing plugin (or a new one).

Figure 3: Browse the provided sample dataset.

This tutorial highlights the different actions needed to develop this component.

## Prerequisites

You have followed the [Creating and configuring a plugin](<../../creation-configuration/index.html>) tutorial or already know how to develop a plugin.

  * Dataiku >= 14.0

  * “Develop plugins” permissions




## Creating the plugin environment

To create a sample dataset, you must first create a plugin. This documentation helps create and configure a plugin. Once the plugin is created, click the **New component** button and choose the **Sample dataset** component (Fig. 4).

Figure 4: New sample dataset component.

Fill in the form by providing a unique identifier, `pro-customer`, for example, and click the **Add** button. This will redirect you to the plugin development environment within a folder containing the `dataset.json` (Code 1) global configuration file folder (`data_v1`) containing a `sample.csv` file, and a file `config_v1.json`, which is the dataset configuration file.

Code 1: default configuration file – `dataset.json`
    
    
    // This file is the descriptor for the sample dataset template tutorials
    {
        "meta": {
            // label: name of the app template as displayed, should be short
            "label": "pro-customer",
    
            // description: longer string to help end users understand what this sample is
            "description": "",
    
            // icon: must be one of the FontAwesome 5.15.4 icons, complete list here at https://fontawesome.com/v5/docs/
            "icon": "fas fa-flask",
    
            // logo: optional displayed logo when selecting your sample
            // The logo should be located in the root of the plugin folder, inside a "resource" directory
            // For example: my-plugin/resource/my_logo.png
            // The logo image should be 280x200 pixels
            // The logo filename must only contain letters (a-z, A-Z), digits (0-9), dots (.), underscores (_), hyphens (-), and spaces ( )
            // The logo filename extension must be one of the following: ".apng", ".png", ".avif", ".gif", ".jpg", ".jpeg", ".jfif", ".svg", ".webp", ".bmp", ".ico", ".cur"
            // "logo": "my_logo.png",
    
            // versions: Available versions of your sample
            // Used to update your sample without impacting the existing projects in your instance (for instance because of a dataset change that would break some recipes)
            // For every version, a config file (config.json) and a "data" directory should be present, each suffixed with _<your version>
            // For instance, for version "v1", you should have a config file "config_v1.json", and a data directory "data_v1"
            // versions must only contain letters (a-z, A-Z), digits (0-9) and hyphens (-)
            "versions": ["v1"],
    
            // activeVersion: version of your sample to install if several versions are available
            "activeVersion": "v1",
    
            // displayOrderRank: number used to sort the various samples by descending order
            "displayOrderRank": 1
        }
    
        // For every version, your data should be placed in a "data_<your version>" directory where you can include your CSV files (e.g., "sample.csv") encoded in utf-8.
        // Your cells have to be separated by commas (,).
        // You can use double quotes (") as a quoting character to enclose cells containing the separator, and use backslash (\) as an escape character.
        // Additionally, you can use compressed files with the ".gz" extension for Gzip-compressed files (e.g., "sample.csv.gz")
        // You can also include multiple files or use zipped CSV files for convenience.
    
        // You can add additional info, like the schema of your sample dataset, in its corresponding config file.
    }
    

## Configuring the sample dataset

The configuration of a dataset sample is done in two separate steps. The first step is to modify the global configuration file of the dataset sample in the `dataset.json` file. The second step is to configure the sample of your dataset. To configure your sample dataset, modify the `meta` section of the `dataset.json` file.

In the `meta` section, you will find the usual fields (`label`, `description`, `icon`) and four specific optional fields (`versions`, `activeVersion`, `logo`, and `displayOrderRank`).

`logo`, `label`, and `description` are used to display information about your sample dataset when creating it, as shown in Fig. 5. If you want to provide a logo, you will need to create a `resource` folder at the root of your plugin and upload your image to that folder. Your logo should ideally be an image of 280x200 pixels, and use one of the following format: `apng`, `png`, `avif`, `gif`, `jpg`, `jpeg`, `jfif`, `svg`, `webp`, `bmp`, `ico`, `cur`.

Figure 5: Displaying information of your sample dataset.

The `displayOrderRank` determines which position your sample dataset will be presented to the user.

`versions` is an array of the different versions of your sample dataset. Having multiple versions of the same sample dataset helps you to provide corporate data, which can evolve with the time without breaking previous project that where using “old” version of your sample dataset. The `activeVersion` just specifies which version of your plugin is being served.

Finally, the `icon` value is used when the dataset is visible in the flow (Fig. 6). If you don’t provide an icon, the plugin icon will be used.

Figure 6: New sample dataset in the flow.

You may also add a `columns` array in the global configuration file to describe the schema of your sample dataset. It works as the `columns` array used in the versioned configuration file (more information in the next section).

## Providing a sample dataset data

A sample dataset comes with a versioning system. By default, the `activeVersion` is `v1`. For each version, you must have a dedicated folder (`data_<YOUR_VERSION>`) which contains the data you want to provide.

You may also have a `config_<YOUR_VERSION>.json` file in the sample dataset component folder to describe the data. If you don’t have this file, Dataiku will use the description you may have entered in the global configuration file. You must have at least one description of your data.

To describe your data, you have to create a `columns` array. This array describes the columns of your data, in the same order as the ones in your CSV file. Each column should have a `name` and a `type`. Optionally, you can provide a `comment` and a `meaning`, as shown in the code below.

For the list of column types, please refer to [Storage types](<https://doc.dataiku.com/dss/latest/schemas/definitions.html#storage-types> "\(in Dataiku DSS v14\)"). For the list of available meanings, please refer to the [List of recognized meanings](<https://doc.dataiku.com/dss/latest/schemas/meanings-list.html> "\(in Dataiku DSS v14\)").

Code 2: configuration file.
    
    
    {
      "rowCount": 5,
      "columns": [
        {
          "name": "id",
          "type": "string",
          "comment": "Unique identifier"
        },
        {
          "name": "name",
          "type": "string",
          "comment": "Name of the person"
        },
        {
          "name": "job",
          "type": "string",
          "comment": "Position of the person"
        },
        {
          "name": "company",
          "type": "string",
          "comment": "Company "
        }
      ]
    }
    

If you have filled in the `rowCount` field, it will also be used when the user glimpses the sample dataset (Fig. 7).

Figure 7: Glimpsing a sample dataset.

In the `data_v1` folder of your sample dataset component, you can provide several CSV files, respecting the format you have described in the `columns` section. Each file will be used to provide data to the user. Dataiku will concatenate those files to build a unique dataset. You should not give a header line in your CSV file, as the data is already described.

Dataiku will use the unique identifier you provided while creating the sample dataset component to name the dataset. For example, if you put the content shown in Code 3 as `sample.csv`, you will end up with a dataset that could be used as a starting point for the different tutorials on Agent ([Building and using an agent with Dataiku’s LLM Mesh and Langchain](<../../../genai/agents-and-tools/agent/index.html>), [LLM Mesh agentic applications](<../../../genai/agents-and-tools/llm-agentic/index.html>) ).

Code 3: sample of data.
    
    
    tcook,Tim Cook,CEO,Apple
    snadella,Satya Nadella,CEO,Microsoft
    jbezos,Jeff Bezos,CEO,Amazon
    fdouetteau,Florian Douetteau,CEO,Dataiku
    wcoyote,Wile E. Coyote,Business Developer,ACME
    

## Wrapping up

Creating a sample dataset in Dataiku is an easy process that improves the user experience for new projects. Following this tutorial’s steps, you will build a sample dataset component tailored to your organization’s specific requirements. This allows quick access to relevant data, empowering users with the necessary resources to begin their analyses.

Here is the complete code of this tutorial:

[`dataset.json`](<../../../../_downloads/afb972c4aee189a61d0cb58bc55f4c6b/dataset.json>)
    
    
    {
      "meta": {
        "label": "Developer advocacy Dataset sample",
        "description": "This dataset, provided by the Developer advocates, will help you to run the GenAI tutorials.",
        "icon": "far fa-lemon",
      },
      "columns": [
        {
          "name": "id",
          "type": "string",
          "comment": "Unique identifier"
        },
        {
          "name": "name",
          "type": "string",
          "comment": "Name of the person"
        },
        {
          "name": "job",
          "type": "string",
          "comment": "Position of the person"
        },
        {
          "name": "company",
          "type": "string",
          "comment": "Company "
        }
      ]
    }
    

[`config_v1.json`](<../../../../_downloads/90a01e90047158eb8a3dd47485b39c59/config_v1.json>)
    
    
    {
      "rowCount": 5,
      "columns": [
        {
          "name": "id",
          "type": "string",
          "comment": "Unique identifier"
        },
        {
          "name": "name",
          "type": "string",
          "comment": "Name of the person"
        },
        {
          "name": "job",
          "type": "string",
          "comment": "Position of the person"
        },
        {
          "name": "company",
          "type": "string",
          "comment": "Company "
        }
      ]
    }
    

[`sample.csv`](<../../../../_downloads/829490d0596ebdb996a4f09351b22bee/sample.csv>)
    
    
    tcook,Tim Cook,CEO,Apple
    snadella,Satya Nadella,CEO,Microsoft
    jbezos,Jeff Bezos,CEO,Amazon
    fdouetteau,Florian Douetteau,CEO,Dataiku
    wcoyote,Wile E. Coyote,Business Developer,ACME

---

## [tutorials/plugins/sample-dataset/index]

# Sample dataset

This section contains several learning materials about the plugin component: Sample dataset

---

## [tutorials/plugins/setup-a-dev-env/index]

# Setting up a dedicated instance for developing plugins

This tutorial helps you to set a development environment for developing Dataiku plugins. From a very minimal setup to a complete setup, this tutorial will help you understand the requirements and the best practices we recommend to develop a plugin for Dataiku.

## Prerequisites

The minimal prerequisites are:

  * “Manage all code-envs” permission.

  * “Develop plugins” permission.

  * Dataiku.




It would be best to have:

  * A dedicated Dataiku instance with admin rights (you can rely on the [community Dataiku instance](<https://www.dataiku.com/product/get-started/>)).

  * Git access.

  * Pycharm or Visual Code studio.




## Best practices

We recommend reading **this introduction first** ([Foreword](<../foreword.html>)).

Developing a plugin is an important task that requires careful consideration. It is highly recommended to have a dedicated instance when developing a plugin. This will ensure that your plugin development does not interfere with other projects.

You can install one of the many plugins already published in the Plugin Store to gain inspiration or see how certain functionalities were implemented. By opening it in dev mode and examining the source code, you can learn how to implement similar features in your plugin. You can also inspect the source code on GitHub for publicly published plugins.

When developing your plugin, paying attention to naming your variables and functions is essential. Ensure that they are meaningful and descriptive. This will make it easier for other developers to understand your code. Using comprehensive wording in your code and user interface is also important. The component/plugin naming should never contain the word plugin or custom. It would be best if you had consistent wording throughout your company.

Before running any processing, it’s essential to validate all input parameters. If possible, read them and validate output parameters. Implementing error handling at any point can help prevent issues and make your plugin more reliable and safe to use.

To ensure the reliability and security of your code, it is advised to use the `my_dict.get('smth', default_value)` method instead of `my_dict['smth']`. This is because the former method allows you to provide a default value if the key `smth` is not present in the dictionary, thus preventing potential errors.

It is also crucial to sanitize user inputs before usage, especially regarding strings. Untrusted or malicious inputs could cause security vulnerabilities and lead to data breaches in the project where the plugin is used. Furthermore, dates and time zones must be handled with particular care. Incorrect time zone conversions or date calculations can result in serious issues.

Separating the logic of your component in plugin libraries is a good practice. Doing so lets you keep the code in the plugin libraries independent of dataiku. Avoid importing `dataiku`, as this will simplify testing the plugin logic outside of Dataiku.

## Preparing your development environment

Before developing a plugin, you must prepare your development environment. You can use your preferred Integrated Development Environment (IDE), such as PyCharm or VSCode. If you use VSCode, you can install the VSCode extension by following [these instructions](<../../devtools/vscode-extension/index.html>). Similarly, if you choose to use PyCharm, you can install the PyCharm plugin by following [these instructions](<../../devtools/pycharm-plugin/index.html>).

## Interacting with Git

As a developer, you can use Git to synchronize your plugin between your Dataiku instance and IDE. To enable Git communication between your instance and repository, make sure they can communicate with each other.

To connect your Dataiku instance to an external Git repository, copy your Dataiku user’s public SSH key and add it to the list of accepted SSH keys in your GitHub account. This means that you must have access to the public key of your Dataiku users.

If you need to generate SSH keys, use the command `ssh-keygen` and follow the corresponding prompts.

For further help, you can refer to GitHub’s documentation. Suppose you face difficulty establishing communication between your Dataiku instance and your GitHub account. In that case, you can try running the command `ssh -vT git@github.com` from your Dataiku instance’s shell command line. This command provides a detailed description of the various connection steps used to connect to your GitHub account.

Always ensure no components with the same name are present in the existing instance when synchronizing. If any such components exist, your plugin will be loaded only after you fix this error.

## Wrapping up

Congratulations! Setting up a developer environment for plugin development is a significant milestone. It means you have taken the first crucial step towards easily creating plugins. By adhering to best practices, you will develop plugins confidently and quickly, knowing you are following proven methods that produce high-quality results.

---

## [tutorials/plugins/webapps/generality/index]

# Turning an existing webapp into a webapp plugin component

In this tutorial, we’ll start from the webapp created in the [Bokeh webapp tutorial](<../../../webapps/bokeh/basics/index.html>) to create a webapp plugin. The aim is to have a ready-to-use bar chart webapp in an order context with a boolean validating or not the presence of the category.

## Converting to a webapp plugin

  1. Click the **Actions** button on your web app to open the right panel.

  2. Click **Plugin** to convert it to a plugin webapp.

  3. Choose either your existing dev plugin or create a new one as the target plugin.

  4. Give the webapp an identifier like `custom-orders-barchart`.

  5. Click **Convert**.

  6. Confirm the overwrite of existing sources, if necessary.




### Editing the definitions in `webapp.json`

First, let’s examine the _webapp.json_ file. This file describes the parameters that the user must specify when using the plugin webapp.

Note that unlike the _recipe.json_ file of a plugin recipe (see [that tutorial](<../../recipes/generality/index.html>)), there are no `input_roles` or `output_roles` sections, and we can focus on editing the `"params"` section, which comprises the **input** dataset, the **category** column, the **boolean** column, and the **total amount of orders** column defined as follow:

Thinking about the parameters to specify, there’s:

  * the input dataset

  * the category column

  * the boolean column

  * the total amount of orders column




... which can be specified in the JSON as follows.
    
    
    "params": [
        {
            "name": "input_dataset",
            "type": "DATASET",
            "label": "Dataset",
            "description": "The dataset used to populate the webapp",
            "mandatory": true,
            "canSelectForeign": true
        },
        {
            "name": "category",
            "type": "DATASET_COLUMN",
            "datasetParamName": "input_dataset",
            "label": "Category Column",
            "description": "",
            "mandatory": true
        },
        {
            "name": "boolean",
            "type": "DATASET_COLUMN",
            "datasetParamName": "input_dataset",
            "label": "Boolean Column",
            "description": "",
            "mandatory": true
        },
        {
            "name": "total_amount",
            "type": "DATASET_COLUMN",
            "datasetParamName": "input_dataset",
            "label": "Total Amount Column",
            "description": "",
            "mandatory": true
        }
    ],
    

After doing that, uncomment the roles section.
    
    
    "roles": [
        {"type": "DATASET", "targetParamsKey": "input_dataset"}
    ]
    

### Editing the code in `backend.py`

Now, let’s edit _backend.py_. The default contents include the code from your Python Bokeh webapp. You can retrieve the parameter’s value from the map of parameters previously defined with the `get_webapp_config()` function, such as:
    
    
    input_dataset = get_webapp_config()['input_dataset']
    category = get_webapp_config()['category']
    campaign = get_webapp_config()['boolean']
    total_amount = get_webapp_config()['total_amount']
    

Then, use them as variables inside your code if needed.

For example, in the application function code block:
    
    
    def application():
    """
    Create the application.
    """
    
    # RETRIEVE VALUES
    input_dataset = get_webapp_config()['input_dataset']
    boolean = get_webapp_config()['boolean']
    
    # READ DATASET
    dataset = dataiku.Dataset(input_dataset)
    df = dataset.get_dataframe()
    # Only keep data where the campaign has been launched
    df = df[df[boolean]]
    

Once you have finished updating the code, don’t forget to save your change.

Note

A webapp plugin allows you to use a single code for several use cases if the data is similar for each context. However, titles and other labels will remain hard-coded, which limits generalization to a more advanced and detailed webapp.

### Provisioning the plugin with a code environment

You’ll need to [configure](<../../creation-configuration/index.html>) your plugin and specify the code environment with Bokeh directly in the plugin and not in the webapp. To do so:

  1. Navigate to the **Summary** tab.

  2. Click **\+ Create a new code environment** and choose **Python**.

  3. Back in the **Edit** tab, select the **requirements.txt** file under **code-env > python > spec**

  4. Enter `bokeh`.

  5. Click **Save All**

  6. Navigate back to the **Summary** tab and click **Build New Environment**.




## Using your custom webapp in a project

Let’s access the input Dataiku dataset as a pandas dataframe and extract the relevant columns from the pandas dataframe to define the source data for the visualization.

Note

After editing _webapp.json_ for a plugin webapp, you must do the following:

  1. On the top right corner, click **Actions > Reload this plugin**.

  2. Reload the Dataiku page in your browser (`Ctrl+r`/ `Cmd+r`).




When modifying the _backend.py_ file, you don’t need to reload anything. Restart the webapp backend.

  1. Go to the Flow and select a dataset, such as _Orders_by_Country_sorted_.

  2. From the **Actions** sidebar, select your plugin webapp.

  3. Give the new webapp a name (or accept the default) and click **Create**.

  4. In the **Edit** tab, make the desired selections for displaying the webapp.

  5. Click **Save and View Webapp**.




The webapp displays the selected settings and provides interactivity to change the plot title, the time period to display, and the category of the categorical column.

To change the dataset and columns the webapp uses, go to the **Edit** tab, make the new selections, and click **View webapp**.

## Wrapping Up

You have leveraged the power of a webapp into a reusable plugin for further use. Here is the complete version of code used during this tutorial.

backend.py
    
    
    from dataiku.customwebapp import *
    
    # Access the parameters that end-users filled in using webapp config
    # For example, for a parameter called "input_dataset"
    # input_dataset = get_webapp_config()["input_dataset"]
    
    import dataiku
    from bokeh.io import curdoc
    from bokeh.models import Div, MultiSelect, ColumnDataSource, FactorRange
    from bokeh.plotting import figure
    from functools import partial
    from bokeh.layouts import layout
    
    
    def add_title():
        """
        Create the title for the application.
        :return: The title object.
        """
        title = Div(text="""<h1>Total Sales by Country</h1>""",
                    style={'backgroundColor': '#5473FF',
                           'color': '#FFFFFF',
                           'width': '98vw',
                           'margin': 'auto',
                           'textAlign': 'center'})
        return title
    
    
    def add_text():
        """
        Create a description of the application.
        :return: The text object.
        """
        text = Div(text="This graph allows you to compare the total sales amount and campaign influence by country.",
                   sizing_mode="stretch_width",
                   align="center")
        return text
    
    def add_plot(df, source):
        """
        Create a plot for rendering the selection
        :param df: The dataframe to use.
        :param source: The columnSource to use.
        :return: The plot object.
        """
        category = get_webapp_config()['category']
    
        plot = figure(plot_width=600, plot_height=300,
                      x_axis_label='Country',
                      y_axis_label='Total Amount',
                      title='Total amount per campaign',
                      x_range=FactorRange(factors=list(df[category])),
                      sizing_mode='stretch_width'
                      )
        plot.left[0].formatter.use_scientific = False
        plot.xaxis.major_label_orientation = "vertical"
        plot.vbar(source=source, x='x', top='y', bottom=0, width=0.3)
    
        return plot
    
    def add_select(df, source, plot):
        """
        Create a Multi-select for the country selection.
        :param df: The dataframe to use.
        :param source: The columnSource to use.
        :param plot: The plot to update.
        :return: The multi-select object.
        """
        category = get_webapp_config()['category']
        
        select = MultiSelect(title="Select countries:",
                             options=[i for i in sorted(df[category].unique())],
                             value=['United States', 'China', 'Japan', 'Germany', 'France', 'United Kingdom'],
                             size=10,
                             sizing_mode='stretch_width'
                             )
        select.on_change("value", partial(update_fig, df=df, source=source, plot=plot))
        return select
    
    def update_fig(_attr, _old, new, df, source, plot):
        """
        Callback for updating the plot with the new values.
        :param _attr: Unused: the attribute that is changed.
        :param _old: Unused: the old value.
        :param new: The new value.
        :param df: The dataframe to use.
        :param source: The columnSource to use.
        :param plot: The plot to update.
        """
        
        category = get_webapp_config()['category']
        total_amount = get_webapp_config()['total_amount']
    
        data = df[df[category].isin(new)]
        source.data = dict(
            x=data[category],
            y=data[total_amount]
        )
        plot.x_range.factors = list(source.data['x'])
    
    
    def application():
        """
        Create the application.
        """
        
        # RETRIEVE VALUES
        input_dataset = get_webapp_config()['input_dataset']
        boolean = get_webapp_config()['boolean']
        
        # READ DATASET
        dataset = dataiku.Dataset(input_dataset)
        df = dataset.get_dataframe()
        # Only keep data where the campaign has been launched
        df = df[df[boolean]]
    
        source = ColumnDataSource(dict(x=[], y=[]))
    
        title = add_title()
        text = add_text()
        plot = add_plot(df, source)
        select = add_select(df, source, plot)
    
        update_fig("", "", select.value, df, source, plot)
    
        app = layout([title, text, select, plot])
        curdoc().add_root(app)
        
    application()
    

webapp.json
    
    
    // This file is the descriptor for webapp custom-orders-barchart
    {
        "meta": {
            // label: name of the webapp as displayed, should be short
            "label": "Custom orders barchart",
            // description: longer string to help end users understand what this webapp does
            "description": "",
            // icon: must be one of the FontAwesome 3.2.1 icons, complete list here at https://fontawesome.com/v3.2.1/icons/
            "icon": "icon-puzzle-piece"
        },
    
        "baseType": "BOKEH", // WARNING: do not change
        "hasBackend": "true",
        "noJSSecurity": "true",
        "standardWebAppLibraries": null,
    
        /* The field "params" holds a list of all the params
           for wich the user will be prompted for values in the Settings tab of the webapp.
    
           The available parameter types include:
           STRING, STRINGS, INT, DOUBLE, BOOLEAN, SELECT, MULTISELECT, MAP, TEXTAREA, PRESET, DATASET, DATASET_COLUMN, MANAGED_FOLDER
    
           For the full list and for more details, see the documentation: https://doc.dataiku.com/dss/latest/plugins/reference/params.html
        */
           "params": [
            {
                "name": "input_dataset",
                "type": "DATASET",
                "label": "Dataset",
                "description": "The dataset used to populate the webapp",
                "mandatory": true,
                "canSelectForeign": true
            },
            {
                "name": "category",
                "type": "DATASET_COLUMN",
                "datasetParamName": "input_dataset",
                "label": "Category Column",
                "description": "",
                "mandatory": true
            },
            {
                "name": "boolean",
                "type": "DATASET_COLUMN",
                "datasetParamName": "input_dataset",
                "label": "Boolean Column",
                "description": "",
                "mandatory": true
            },
            {
                "name": "total_amount",
                "type": "DATASET_COLUMN",
                "datasetParamName": "input_dataset",
                "label": "Total Amount Column",
                "description": "",
                "mandatory": true
            }
        ],
    
        "roles": [
            {"type": "DATASET", "targetParamsKey": "input_dataset"}
        ]
    }

---

## [tutorials/plugins/webapps/index]

# Webapps

This section contains learning materials about the plugin component: Webapp.

---

## [tutorials/webapps/bokeh/basics/index]

# Bokeh: Your first webapp

## Prerequisites

  * Dataiku >= 11.0 (You can also use Dataiku cloud)

  * Some familiarity with python




[Bokeh](<https://bokeh.org/>) is a Python library for creating interactive visualizations for modern web browsers. This tutorial will create a simple Bokeh webapp in Dataiku. We will use sample sales data from the fictional Haiku T-shirt company, similar to the data used in the Basics tutorials. The webapp will display the total amount sold for each selected country. Each time the user changes the input, the plot is updated.

Note

We have tested this tutorial using a Python 3.9 code environment with `bokeh==2.4.3`. Other Python versions may be compatible, Bokeh version before 2.4.0 may be incompatible. Check the webapp logs for potential incompatibilities.

## Data preparation

Start by downloading the source data following [this link](<https://cdn.downloads.dataiku.com/public/website-additional-assets/data/Orders_by_Country_sorted.csv>) and make it available in your Dataiku project, for example, by uploading the _.csv_ file. Name the resulting Dataiku dataset `Orders_by_Country_sorted`.

## Creating the webapp

First, you need to create a Bokeh webapp. You will use the empty Bokeh template and generate a Bokeh webapp named: `Your first webapp`, as shown in Fig. 1 and 2.

Fig. 1: Creation of a webapp.

Fig. 2: Naming the newly created webapp.

Once the webapp is created, you will land on an empty webapp. To be able to edit code, you have to select the “Settings” tab. This window comprises two parts. Usually, the left part is where we enter the code, and the right part is dedicated to the preview of the webapp, as shown in Fig. 3.

Fig. 3: Edition of the Bokeh webapp.

On the right side, there are four tabs, allowing you to switch to:

  * Preview mode: default opened tab.

  * Python editor: to have two different views of your code.

  * Log: helpful in debugging when something goes wrong. If you do not see your logs, click on the “Refresh log” button to update the log window.

  * Settings: to configure the webapp, like the code environment used for the webapp.




## Sketching the webapp

The webapp will consist of a title, a text (to explain the purpose of the webapp), a multi-select object (for selecting the countries), and a plot. This tutorial will also focus on good practices, like [single responsibility](<https://en.wikipedia.org/wiki/Single-responsibility_principle>), forbidding the usage of global variables, and so on.

### Import package and set up the application

First, you will need some data, so you have to use the `dataiku` package. All along this tutorial, you will need some other packages/components, and you will include them all at once. After importing the libraries, you will create a function to render the application’s title. You will also make a description of the application. And finally, you will define a function for the application creation and call it to render the webapp, as shown in Code 1. The emphasized line is the place to write code for reading data. You will do it just after.

Code 1: Import packages and create the first step for the application.
    
    
    import dataiku
    from bokeh.io import curdoc
    from bokeh.models import Div, MultiSelect, ColumnDataSource, FactorRange
    from bokeh.plotting import figure
    from functools import partial
    from bokeh.layouts import layout
    
    
    def add_title():
        """
        Create the title for the application.
        :return: The title object.
        """
        title = Div(text="""<h1>Total Sales by Country</h1>""",
                    style={'backgroundColor': '#5473FF',
                           'color': '#FFFFFF',
                           'width': '98vw',
                           'margin': 'auto',
                           'textAlign': 'center'})
        return title
    
    
    def add_text():
        """
        Create a description of the application.
        :return: The text object.
        """
        text = Div(text="This graph allows you to compare the total sales amount and campaign influence by country.",
                   sizing_mode="stretch_width",
                   align="center")
        return text
    
    
    def application():
        """
        Create the application.
        """
    
        title = add_title()
        text = add_text()
    
        app = layout([title, text])
        curdoc().add_root(app)
    
    
    application()
    

### Providing data

To use the dataset, you must read `Orders_by_Country_sorted` with the `dataiku` package, as shown in Code 2. Reading the dataset will slightly modify the function `application()` (Code 2 replaces the emphasized line in Code 1).

Code 2: Reading the data.
    
    
    # READ DATASET
    dataset = dataiku.Dataset("Orders_by_Country_sorted")
    df = dataset.get_dataframe()
    # Only keep data where the campaign has been launched
    df = df[df['campaign']]
    
    source = ColumnDataSource(dict(x=[], y=[]))
    

### Plotting the data

Once the data is read, you will create a Plot. You could plot the data directly, but you will face problems when you want to update the plot (Bokeh won’t let you quickly update it). So you will first create a plot with empty data, and later on, you will update this plot with the selected country. Code 3 shows how to create an empty plot, ready to be updated when needed. The highlighted lines show the tweaks you have to do to plot data dynamically.

Code 3: Plot creation.
    
    
    def add_plot(df, source):
        """
        Create a plot for rendering the selection
        :param df: The dataframe to use.
        :param source: The columnSource to use.
        :return: The plot object.
        """
        plot = figure(plot_width=600, plot_height=300,
                      x_axis_label='Country',
                      y_axis_label='Total Amount',
                      title='Total amount per campaign',
                      x_range=FactorRange(factors=list(df.country)),
                      sizing_mode='stretch_width'
                      )
        plot.left[0].formatter.use_scientific = False
        plot.xaxis.major_label_orientation = "vertical"
        plot.vbar(source=source, x='x', top='y', bottom=0, width=0.3)
    
        return plot
    

Of course, you will have to modify your application function to reflect the changes, as shown in Code 4 (highlighted lines).

Code 4: Application modification to integrate the plot.
    
    
    def application():
        """
        Create the application.
        """
        # READ DATASET
        dataset = dataiku.Dataset("Orders_by_Country_sorted")
        df = dataset.get_dataframe()
        # Only keep data where the campaign has been launched
        df = df[df['campaign']]
    
        source = ColumnDataSource(dict(x=[], y=[]))
    
        title = add_title()
        text = add_text()
        plot = add_plot(df, source)
    
        app = layout([title, text, plot])
        curdoc().add_root(app)
    

### User selection and updating the plot

In the same way, you have created the plot, and you will create a function for the multi-select object ( Code 5). The highlighted line allows Bokeh to run a function (`update_fig`) when the user changes the object’s value. Usually, the library imposes the prototype of this function. But as you need some additional data to be passed to this function, you will use the `partial` function to provide other data to the `update_fig` function. Code 6 shows the implementation of the function.

Code 5: Multi-select object creation.
    
    
    def add_select(df, source, plot):
        """
        Create a Multi-select for the country selection.
        :param df: The dataframe to use.
        :param source: The columnSource to use.
        :param plot: The plot to update.
        :return: The multi-select object.
        """
        select = MultiSelect(title="Select countries:",
                             options=[i for i in sorted(df.country.unique())],
                             value=['United States', 'China', 'Japan', 'Germany', 'France', 'United Kingdom'],
                             size=10,
                             sizing_mode='stretch_width'
                             )
        select.on_change("value", partial(update_fig, df=df, source=source, plot=plot))
        return select
    

Code 6: Callback function for updating the plot.
    
    
    def update_fig(_attr, _old, new, df, source, plot):
        """
        Callback for updating the plot with the new values.
        :param _attr: Unused: the attribute that is changed.
        :param _old: Unused: the old value.
        :param new: The new value.
        :param df: The dataframe to use.
        :param source: The columnSource to use.
        :param plot: The plot to update.
        """
    
        data = df[df['country'].isin(new)]
        source.data = dict(
            x=data.country,
            y=data.total_amount
        )
        plot.x_range.factors = list(source.data['x'])
    

And, of course, you will need to update the application to reflect these changes. As you plot an empty figure, you should update it with some default values (provided in the multi-select object), so the highlighted lines in Code 7 show how to do this.

Code 7: Final version of the application code.
    
    
    def application():
        """
        Create the application.
        """
        # READ DATASET
        dataset = dataiku.Dataset("Orders_by_Country_sorted")
        df = dataset.get_dataframe()
        # Only keep data where the campaign has been launched
        df = df[df['campaign']]
    
        source = ColumnDataSource(dict(x=[], y=[]))
    
        title = add_title()
        text = add_text()
        plot = add_plot(df, source)
        select = add_select(df, source, plot)
    
        update_fig("", "", select.value, df, source, plot)
    
        app = layout([title, text, select, plot])
        curdoc().add_root(app)
    

## Going further

If everything goes well, you should go to a webapp that looks like Fig. 4.

Fig. 4: Final state of the webapp.

You learned how to read and use a dataset with Dataiku and Bokeh. You also know how to plot a histogram based on this dataset. Using the same principles, you can draw another chart, explore other datasets, add interactivity, etc.

Here is the complete code of the web application:

[`app.py`](<../../../../_downloads/b7cc950281e0c68fa0304f9f2da0e501/bokeh.py>)
    
    
    import dataiku
    from bokeh.io import curdoc
    from bokeh.models import Div, MultiSelect, ColumnDataSource, FactorRange
    from bokeh.plotting import figure
    from functools import partial
    from bokeh.layouts import layout
    
    
    def add_title():
        """
        Create the title for the application.
        :return: The title object.
        """
        title = Div(text="""<h1>Total Sales by Country</h1>""",
                    style={'backgroundColor': '#5473FF',
                           'color': '#FFFFFF',
                           'width': '98vw',
                           'margin': 'auto',
                           'textAlign': 'center'})
        return title
    
    
    def add_text():
        """
        Create a description of the application.
        :return: The text object.
        """
        text = Div(text="This graph allows you to compare the total sales amount and campaign influence by country.",
                   sizing_mode="stretch_width",
                   align="center")
        return text
    
    
    def update_fig(_attr, _old, new, df, source, plot):
        """
        Callback for updating the plot with the new values.
        :param _attr: Unused: the attribute that is changed.
        :param _old: Unused: the old value.
        :param new: The new value.
        :param df: The dataframe to use.
        :param source: The columnSource to use.
        :param plot: The plot to update.
        """
    
        data = df[df['country'].isin(new)]
        source.data = dict(
            x=data.country,
            y=data.total_amount
        )
        plot.x_range.factors = list(source.data['x'])
    
    
    def add_select(df, source, plot):
        """
        Create a Multi-select for the country selection.
        :param df: The dataframe to use.
        :param source: The columnSource to use.
        :param plot: The plot to update.
        :return: The multi-select object.
        """
        select = MultiSelect(title="Select countries:",
                             options=[i for i in sorted(df.country.unique())],
                             value=['United States', 'China', 'Japan', 'Germany', 'France', 'United Kingdom'],
                             size=10,
                             sizing_mode='stretch_width'
                             )
        select.on_change("value", partial(update_fig, df=df, source=source, plot=plot))
        return select
    
    
    def application():
        """
        Create the application.
        """
        # READ DATASET
        dataset = dataiku.Dataset("Orders_by_Country_sorted")
        df = dataset.get_dataframe()
        # Only keep data where the campaign has been launched
        df = df[df['campaign']]
    
        source = ColumnDataSource(dict(x=[], y=[]))
    
        title = add_title()
        text = add_text()
        plot = add_plot(df, source)
        select = add_select(df, source, plot)
    
        update_fig("", "", select.value, df, source, plot)
    
        app = layout([title, text, select, plot])
        curdoc().add_root(app)
    
    
    def add_plot(df, source):
        """
        Create a plot for rendering the selection
        :param df: The dataframe to use.
        :param source: The columnSource to use.
        :return: The plot object.
        """
        plot = figure(plot_width=600, plot_height=300,
                      x_axis_label='Country',
                      y_axis_label='Total Amount',
                      title='Total amount per campaign',
                      x_range=FactorRange(factors=list(df.country)),
                      sizing_mode='stretch_width'
                      )
        plot.left[0].formatter.use_scientific = False
        plot.xaxis.major_label_orientation = "vertical"
        plot.vbar(source=source, x='x', top='y', bottom=0, width=0.3)
    
        return plot
    
    
    application()

---

## [tutorials/webapps/bokeh/index]

# Bokeh

  * [Bokeh: your first webapp](<basics/index.html>)

---

## [tutorials/webapps/code-studio/code-starters/index]

# Basic setup: Quickstart with Angular & Vue Templates

## Prerequisites

  * Basic understanding of HTML, JavaScript, and Angular or Vue for frontend development.

  * Some experience with Python for backend operations.

  * [Code Studio Template](<../template/index.html>) is already configured on your Dataiku instance.




This tutorial teaches how to rapidly initiate a web application using pre-configured templates. These templates streamline your workflow by auto-configuring a Node server to host your Code Studio browser path while also routing API requests to the exposed Flask backend.

These templates are also designed for smooth [deployment](<../deployment/index.html>) as a standard Dataiku web application.

## Quick Project Setup with Cookiecutter

Note

  * Cookiecutter serves as a command-line tool for swift project generation from templates. The Cookiecutter Python code environment will be employed in this scenario, as defined in the Code Studio template.

  * All web application projects should be initiated inside the `project-lib-versioned/webapps` directory. Doing so enables seamless synchronization of your source code and build files with the Dataiku project library, thereby simplifying the deployment process.




### Activating the Cookiecutter Environment

To activate your Cookiecutter environment in the Visual Studio Code (VS Code) UI panel, run the command below:
    
    
    source /opt/dataiku/python-code-envs/cookiecutter/bin/activate
    

Note

  * The default path for code environments specified in the Code Studio template is `/opt/dataiku/python-code-envs/`. If you’ve customized this location in the template settings, update the path in the command accordingly.




### Generating a New Web Application

In this section, we will guide you through the process of creating a new web application using Cookiecutter. You have the option to choose between two templates, VueJS or Angular, for your web application project.

  * Navigate to the following directory:
        
        mkdir ~/workspace/project-lib-versioned/webapps && cd ~/workspace/project-lib-versioned/webapps
        

  * Execute the following command to instantiate a new project template with Cookiecutter:
        
        cookiecutter gh:dataiku/solutions-contrib
        

Note

Cookiecutter is a command-line utility that expedites the creation of project structures using templates. In this context, we utilize it with the `gh:dataiku/solutions-contrib` repository, a public GitHub repository storing templates for Vue and Angular web applications. These templates are specifically designed to streamline the setup of web applications in Dataiku’s Code Studio and facilitate smooth deployment to standard Dataiku web apps, ensuring a straightforward and consistent development process for developers.

  * Cookiecutter will then prompt you to select a template:
        
        [1/1] Select template
          1 - Vue (./bs-templates/vue)
          2 - Angular (./bs-templates/angular)
          Choose from [1/2] (1):
        

    * Select the desired template by entering the corresponding number (1 for Vue and 2 for Angular).

  * After template selection, you’ll be prompted to enter specific project parameters:
        
        [1/6] Choose your (Angular / Vue) project name (Angular Project): tutorial
        [2/6] version (0.0.1):
        [3/6] Choose your client serve port (default 4200) (4200):
        [4/6] Choose your flask backend port (default 5000) (5000):
        [5/6] dss_instance (default):
        [6/6] dku_project ():
        

    * “Project Name”: your Angular or Vue project name. Though the example uses `tutorial`, you can choose any name.

    * “Version”: the project’s version.

    * “Client serve port”: port on which your frontend (e.g., Angular) will run. The default is 4200.

    * “Flask backend port”: port your Flask backend will operate on. The default is 5000.

    * “DSS Instance and DKU Project”: these fields are generally optional while operating within Dataiku Code Studio. You can safely leave them blank unless you’re configuring an external development environment that necessitates their input.

  * After entering these details, a new project folder will be generated in the `project-lib-versioned/webapps` directory.




Following these steps, you’ll successfully set up a new web application, ready for further development and deployment.

### Launching the Frontend and Backend

Once you’ve generated your web application using Cookiecutter, you can proceed to launch the frontend and backend. The process is the same for both Angular and Vue templates.

#### Launching the Frontend

  * Navigate to your project’s directory by replacing **`__PROJECT_NAME__`** with your project folder’s name:
        
        cd ~/workspace/project-lib-versioned/webapps/__PROJECT_NAME__
        

  * Install the required dependencies:
        
        yarn install
        

The Code Studio template comes pre-configured with `npm`, `yarn`, and `pnpm`. You can use any of these package managers to install dependencies. For instance, you can replace `yarn install` with `npm install` or `pnpm install` based on your preference.

  * Run the frontend server
        
        ng serve --host 127.0.0.1
        

  * You can now preview the web application in the **Dev** panel of the Code Studio.




#### Launching the Backend

  * Activate your backend code environment
        
        source /opt/dataiku/python-code-envs/infra37/bin/activate
        

Note

If you’ve imported the Code Studio template, an **infra37** code environment with the essential requirements for launching the included Flask server will be available. This environment necessitates **python >= 3.9** or higher and incorporates the following packages:
        
        Flask>=0.9
        git+https://github.com/dataiku/solutions-contrib.git@main#egg=webaiku&subdirectory=bs-infra
        python-dotenv>=0.19.0
        dataiku-api-client
        

  * Navigate back to your project directory (again, replace **`__PROJECT_NAME__`** with your specific folder name):
        
        cd ~/workspace/project-lib-versioned/webapps/__PROJECT_NAME__
        

  * Execute the following command to launch the backend:
        
        python -m backend.wsgi
        




By following these steps, you’ll successfully initiate both the frontend and backend of your web application within Dataiku’s Code Studio environment.

Remember that you can choose between Angular and Vue templates for your project, and the instructions for launching the frontend and backend are the same regardless of your choice.

---

## [tutorials/webapps/code-studio/configuring-code-studio/index]

# Advanced setup: Code Studio template creation

This tutorial guides users on creating and configuring a Code Studio template to utilize a preferred web framework. It covers the necessary steps to set up a development environment, install required packages, and start the backend server. The template can be applied during both development and production phases.

## Prerequisites

For building the code studio template:

  * Admin permission

  * Container images based on Almalinux

  * A code env with Flask (or another Python web server)




## Context

This tutorial will teach you how to create and configure a Code Studio template to use your preferred web framework. It uses the Angular web framework as an example, but could be adapted to any other web framework. Most modern web frameworks are based on the same principle: they rely on separating the frontend and the backend.

The backend is where processing is done and serves the requested data through routes (API). Dataiku encourages using Python to interact, so a frequent choice is to implement the backend using Flask. FastAPI is supported too, but the following examples will focus on a Flask implementation.

The front part has two ways of working, depending on whether you are developing your application or if it is ready for production. Usually, when developing an application, it uses “dynamic” files, while a built application serves “static” files.

The Code Studio template in this tutorial can be used during the development and production phases. If you need, you can split the template into two different templates based on your process.

## Building the Code Studio template

Go to the **Code Studios** tab in the **Administration** menu, click the **“+Create code studio template”** button, choose an appropriate name for the template, and click on the **Definition** tab.

### Adding an editor to the template

Click the **“+Add a block”** button and choose the **“Visual Studio Code”** block type. This block allows you to edit the code in Visual Studio Code. The [documentation](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-ides/vs-code.html> "\(in Dataiku DSS v14\)") provides more information. As shown in Figure 1, there is no specific need to configure this block. You don’t need to tick the **“Launch for webapps”** box. Ticking this box indicates to Dataiku that this block should be run when you publish our webapps. When a webapp is published, you don’t need a running Visual Studio Code. The Code Studio will run Visual Code Studio only when you run it in edition. This block won’t start when deploying the web application (see [Publishing your angular application](<../web-application-creation/index.html#webapps-code-studio-web-application-creation-publishing>)).

Figure 1: Configuring Visual Studio Code.

### Installing the web framework

Click the **“+Add a block”** button and choose the **“Append to Dockerfile”** block type. This block allows you to add specific programs to Code Studio; more information is in [the documentation](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#block-append-to-dockerfile> "\(in Dataiku DSS v14\)").

As Angular uses _NodeJS_ , you have to install it, and then you need to install _Angular_. So, in the **“Dockerfile”** block, you have to enter the following:

Code 1: Dockerfile block
    
    
    USER root
    RUN yum -y update && \
        yum -y install curl && \
        yum -y module install nodejs:20
    
    RUN yum install -y npm && \
        mkdir -p /usr/local/lib/node_modules && \
        chown dataiku:dataiku -R /usr/local/lib/node_modules && \
        npm install npm@10 -g && \
        npm install pnpm -g && \
        npm install yarn -g && \
        npm install @angular/cli -g
    
    RUN cd /opt/dataiku/code-server/lib/vscode/extensions && \
        npm init -y && \
        npm i typescript
    

Figure 2: Append to Dockerfile block.

Figure 2 shows the **“Append to Dockerfile”** block correctly configured. This template uses `npm` in version 10; if you want to use another version or framework (such as React, for example), you must adapt this template to reflect the correct installation of your framework.

### Installing and using the backend

#### Selecting a code environment

Click the **“+Add a block”** button and choose the **“Add Code Environment”** block type. This block allows you to add a specific code environment that is usable in the Code Studio. For the **“Code environment”** block, choose the code-env with Flask, as shown in Figure 3. You can find more information on this block in [the documentation](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#block-code-studio-code-env> "\(in Dataiku DSS v14\)").

Figure 3: Add Code Environment for the backend.

#### Creating a helper function

You will rely on a helper function to start the backend. In the resources tab, click **\+ Add** , select **Create file…** , and choose a relevant filename, such as `run_the_backend.sh` (for example).

The command can take various forms depending on the Python package you choose for your server. Suppose you use Flask (as the tutorial does), and your backend is stored in the `project-lib-versioned/my-app` directory. You could also store your backend in another location, like `code_studio-versioned`, for example. Then the command to enter could be the following (if you choose to use Flask):
    
    
    #!/bin/sh
    
    source /opt/dataiku/python-code-envs/flask/bin/activate
    cd /home/dataiku/workspace/project-lib-versioned/my-app/
    flask run
    

This script contains three parts:

  * The first line of this command activates the code-env you previously defined. You must reuse the exact name you used for the backend code environment.

  * The second line positions the shell in the directory where your backend is.

  * The third line runs Flask to provide the backend.




Figure 4 represents this stage.

Figure 4: Helper function for starting the backend.

#### Creating an entry point to run the backend

Back to the **Definition** tab, click the **“+Add a block”** button, and choose the **“Add an Entrypoint”** block type. The purpose of this block is to serve the backend, meaning start a flask server and expose the port of the Flask server to allow communication with the frontend.

  1. Tick **“Launch for Webapps”** and **“Expose port.”**

     * The backend is required when the web app is either in development or production, so you must tick the **“Launch for Webapps”** box.

     * **“Expose port”** exposes the port specified in **“Exposed port”** to Dataiku.

  2. It would help if you also chose a meaningful name (`backend`, for example) for the **“Expose port label”** field.

  3. The **“Expose HTML service”** box remains unchecked. If you check this box, a new tab named `backend` (if you previously chose this name) will appear in the running Code Studio. As the purpose of this block is to serve backend stuff, there is no need to have an HTML tab in the Code Studio.

  4. Then, choose an appropriate **“Exposed port”** and **“Proxied subpath,”** which will be used afterward.




Finally, you have to use the previously defined helper function by copying it into the code studio block (“Scripts” part) and activating it (“Entrypoint” part).

Figure 5 shows a recap of all those steps.

Figure 5: Configured entrypoint block for the backend.

### Creating and using the frontend

Click the **“+Add a block”** button and choose the **“Add an Entrypoint”** block type. The purpose of this block is to run the frontend in development mode.

  1. So you need to see the result of your development –> tick the **“Expose HTML service.”**

  2. You need to have a tab in the running Code Studio –> tick the **“Expose port** ” and choose a valid name for the **“Exposed port label.”**

  3. You need to know which port the web framework will be launched on. In the case of Angular, the default port is 4200 –> enter `4200` in the **“Exposed port.”**

  4. You need to use a proxied subpath; for development, your code will run in the Code Studio, and your file will be served inside this container –> Enter `/$request_uri` in **“Proxied subpath.”**




Figure 6: Configured Entrypoint block for the frontend.

### Preparing the Code Studio template to be published as a standalone web application

Most web frameworks allow users to build their applications after the development phase is finished. In Angular, the command `ng build` creates a `dist` directory containing the compiled version of the frontend. Running the compiled frontend code is nothing more than serving this directory. You have to decide where your web application will be stored. This tutorial assumes the frontend will be stored in the `code_studio-resources` directory. You will also need a particular path to serve the backend. This tutorial assumes that this path is `server`, which will be used in [Code 3: Calling the backend from the frontend.](<../web-application-creation/index.html#webapps-code-studio-web-application-creation-backend-call-from-front>), in the following tutorial.

Click the **“+Add a block”** button and choose the **“NGINX”** block type to create a web server that serves the `dist` directory. If you need assistance configuring an NGINX server, please refer to [the nginx documentation.](<https://nginx.org/en/docs/>) As the web application consists of two parts (the backend and the frontend), we need to configure two locations, one for each part. The first location will serve the backend, and the second location will serve the `dist` directory, but only the `index.html` file (Angular will handle the routes correctly; see [the angular documentation](<https://v17.angular.io/guide/deployment#basic-deployment-to-a-remote-server>)). The first location is just a proxy to redirect each request to the server to the backend. The second location uses the **“Custom settings”** mode in the configuration with the following settings:
    
    
    alias /home/dataiku/workspace/code_studio-resources/my_app/dist/;
    try_files $uri $uri/ /index.html;
    

In this code block, `my_app` refers to the Angular application, which will be created in the following tutorial ([Creating your Angular application](<../web-application-creation/index.html#webapps-code-studio-web-application-creation-creating-your-angular-application>)).

Figure 7 reflects how an NGINX block should be configured to serve a `dist` directory.

Figure 7: Configured NGINX block.

## Wrapping up

Congratulations! You have configured a code studio template to use your framework. A quick summary of the choices you’ve made:

  * In the step Installing and using the backend, you have chosen to use a code environment named `flask`. You also store your backend code in the `backend` subdirectory in the `project-lib-versioned` directory. The name of the code environment is used when you want to run the backend to activate the Python environment. The location of your backend code is used when you need to run the backend. Finally, you use port 5000 to serve the backend API.

  * In the step Creating and using the frontend, you choose the port used by the frontend (4200 in this tutorial).

  * In the step Preparing the Code Studio template to be published as a standalone web application, you have stored your built front in the `code_studio-resources` directory.




Now that everything is correctly configured, you will create your web application using the [following tutorial](<../web-application-creation/index.html>). Keep in mind all the choices you have made.

You can also add two action blocks to help you while developing your web application:

  * One for knowing if the backend is running

  * One is for restarting the backend (in debug mode) if you made some changes in the backend that have yet to be considered.




Click the **“+ Add a block”** button and choose the **“Add Custom Action”** block type. This block allows running dedicated commands. Fill out the form:

  * **“Name”** field: “restart the backend”

  * **“Icon”** field: “fas fa-pastafarianism”

  * **“Description”** field: “Restart the backend in debug mode”

  * **“Behavior”** : “Run and don’t wait”

  * **“Command line to execute”** :



    
    
    source /opt/dataiku/python-code-envs/flask/bin/activate && pkill flask &&  cd /home/dataiku/workspace/project-lib-versioned/my-app/ &&  flask --debug  run"
    

Once this block is created, it will appear in the Action tab of the Code Studio, allowing the user to restart the backend in debug mode. Using the same principle, you can create an action to see if the backend is running by using the command line:
    
    
    pgrep flask >/dev/null && echo "Flask backend is running" || echo "Flask backend is not running"
    

Figure 8 shows the integration of those two blocks.

Figure 8: Custom actions.

---

## [tutorials/webapps/code-studio/deployment/index]

# Basic setup: Deploy your web application

This tutorial guides you through deploying a web application created within the Code Studio, transforming and deploying it as a standard Dataiku web application.

Tip

#### Updating an Existing Deployment

If you’ve previously deployed a web application and wish to update it, you can simply Build the webapp, Synchronize the files, and restart your web application backend.

## Step 1: Building the application

  * Open your terminal and navigate to the project folder. Replace **`__PROJECT_NAME__`** with the actual name of your project directory:
        
        cd ~/workspace/project-lib-versioned/webapps/__PROJECT_NAME__
        

  * Execute the appropriate build command based on your choice of package manager:
        
        yarn run build
        

Note

`npm`, `yarn`, and `pnpm` are pre-installed in the Code Studio template. Feel free to switch out `yarn run build` with `npm run build` or `pnpm run build`, depending on your preferred package manager.

  * Upon successful compilation, the built files will be located in the `dist` folder under the directory path `/workspace/project-lib-versioned/webapps/__PROJECT_NAME__/dist`




## Step 2: Synchronize Files with the Dataiku instance

  * To ensure that your web application files are accessible within the Dataiku environment, you’ll need to synchronize the contents of your `<workspace>/project-lib-versioned` folder with Dataiku.




## Step 3: Include Webapps Folder in Project Python Path

Incorporating the **webapps** folder into your project’s Python path enables the import of your custom Flask blueprints or FastAPI routers, and Python modules.

  * Edit the `external-libraries.json` file to include `webapps` in the “pythonPath”:
        
        {
            "gitReferences": {},
            "pythonPath": [
                "python",
                "webapps"
            ],
            "rsrcPath": [
                "R"
            ],
            "importLibrariesFromProjects": []
        }
        




This makes it possible to seamlessly integrate your custom Flask or FastAPI functionalities and Python modules into your Dataiku project. In the following, we will be using Flask with the WEBAIKU module.

## Step 4: Initialize a New Standard Dataiku Web Application

  * Navigate to **< /> -> Webapps** through the top menu bar.

  * Click on **\+ New Webapp** button at the screen’s top right corner, then choose **Code Webapp > Standard**.




  * Clear out the default code in your web application’s **CSS** , **HTML** , **JS** , and **Python** tabs.




## Step 5: Configuring the Python Backend

  * Open the Settings panel in the web application you’ve just created. Here, select the appropriate code environment for your backend development.

Note

    * Ensure that the Python version in your code environment is **> =3.9** .

    * The code environment should, at minimum, meet the following requirements, in addition to any specific needs your backend might have:
          
          Flask>=0.9
          git+https://github.com/dataiku/solutions-contrib.git@main#egg=webaiku&subdirectory=bs-infra
          dataiku-api-client
          

  * Populate the Python backend tab of your standard web application with the following code snippet. Make sure to replace {**__YOUR_WEBAPPLICATION_FOLDER__**} with your actual web application folder name:
        
        from flask import Flask
        from webaiku.extension import WEBAIKU
        from {__YOUR_WEBAPPLICATION_FOLDER__}.backend.fetch_api import fetch_api
        
        
        WEBAIKU(app, "webapps/{__YOUR_WEBAPPLICATION_FOLDER__}/dist")
        WEBAIKU.extend(app, [fetch_api])
        

Note

    * The example code imports _fetch_api_ , which is the default blueprint in the starter template. Feel free to import any other blueprints or packages you’ve added during development.

    * WEBAIKU s a wrapper around the Flask app. It extends the Flask app to serve your static files from the Flask server’s backend address.




## Step 6: Initialize JavaScript

  * In the JavaScript tab of your web application, paste the following code:
        
        const backendURL = dataiku.getWebAppBackendUrl('fetch/bs_init?URL='+getWebAppBackendUrl(''));
        window.onload = function() {
            var ifrm = document.createElement("iframe");
            ifrm.setAttribute("src", backendURL);
            ifrm.setAttribute("style", "position:fixed; top:0; left:0; bottom:0; right:0; width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;");
            document.body.appendChild(ifrm);
        }
        
        

Note

This JavaScript code dynamically generates a full-screen iframe upon the web page’s complete loading. The iframe fetches its content from the Flask server backend using the URL specified in _backendURL_.




After inserting the provided Python and JavaScript code snippets, your web application is ready for viewing.

This concludes the JavaScript initialization step, and you should now have a fully functioning web application developed using your preferred framework and deployed within Dataiku.

## Next steps

With your web application fully deployed, the next action you may take is to publish it on a [Dataiku Dashboard](<https://doc.dataiku.com/dss/latest/dashboards/index.html>).

Below are the complete versions of the code snippets used throughout this tutorial for easy reference:

[JS Code](<../../../../_downloads/f7adb12adc4ded6bb2e7774d25a0c10e/code.js>)
    
    
    const backendURL = dataiku.getWebAppBackendUrl(
      "fetch/bs_init?URL=" + getWebAppBackendUrl("")
    );
    window.onload = function () {
      var ifrm = document.createElement("iframe");
      ifrm.setAttribute("src", backendURL);
      ifrm.setAttribute(
        "style",
        "position:fixed; top:0; left:0; bottom:0; right:0; width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;"
      );
      document.body.appendChild(ifrm);
    };
    

[Python Code](<../../../../_downloads/bc3ad336ebac37cc24d18cd15c8e366c/code.py>)
    
    
    from flask import Flask
    from webaiku.extension import WEBAIKU
    from {__YOUR_WEBAPPLICATION_FOLDER__}.backend.fetch_api import fetch_api
    
    
    WEBAIKU(app, "webapps/{__YOUR_WEBAPPLICATION_FOLDER__}/dist")
    WEBAIKU.extend(app, [fetch_api])

---

## [tutorials/webapps/code-studio/index]

# Use your own framework.

This section uses the Code Studio feature to explore Web Application Development in Dataiku. Utilize Visual Code directly within Dataiku to develop web applications using your preferred Javascript frameworks and libraries. This section offers insights into practices and development techniques using prominent frameworks. **Two separate ways** of doing this are proposed: a basic setup based on a predefined template and an advanced setup where you will learn how to integrate your framework.

## Basic setup

Based on an already defined code studio template and helpers to start quickly. This example highlights VueJs(v3) and angular (v16) usage. This is the easiest way, but it may not be suitable depending on your use case and requirements. The tutorials in this section:

  * [Basic setup: Code Studio template setup](<template/index.html>)

  * [Basic setup: Web Applications code starters](<code-starters/index.html>)

  * [Basic setup: Deployment](<deployment/index.html>)




## Advanced setup

The entire creation of the whole stack to be able to use your framework is proposed, and a focus is done on the angular framework. This is a more advanced usage of Code Studio and requires the users to understand the framework they want to use. Still, it provides the complete customization of Dataiku to adapt to your framework. The tutorials in this section:

  * [Advanced setup: Code Studio template creation](<configuring-code-studio/index.html>)

  * [Advanced setup: Web application creation and publication](<web-application-creation/index.html>)

---

## [tutorials/webapps/code-studio/template/index]

# Basic setup: Code studio template

This section walks you through the setup process of a Code Studio template specifically designed for web application development using leading frontend frameworks. Currently, we support [Vue](<https://vuejs.org/>) and [Angular](<https://angular.io/>).

Note

_Set up the configuration only once. Once established, the template is available for all Dataiku projects requiring web application development._

In the next sections, you’ll find two methods to set up your Code Studio template. You can choose the one that suits your needs best:

  * If you prefer a quick and straightforward setup, follow the Importing the template into Dataiku steps below.

  * For a more detailed and manual configuration, you can opt for the Manual setup instructions provided afterward.




## Prerequisites

Before you begin, ensure you meet the following requirements:

  * Container based image: Almalinux

  * Knowledge of [Dataiku Code Studios](<https://doc.dataiku.com/dss/latest/code-studios/index.html>).

  * Admin permissions to configure Code Studio templates.

  * Python 3.9+ with [Cookiecutter 2.3.1+](<https://pypi.org/project/cookiecutter/>) installed.

  * For Flask backend, Python 3.9+ and the following packages:
        
        Flask>=0.9
        git+https://github.com/dataiku/solutions-contrib.git@main#egg=webaiku&subdirectory=bs-infra
        python-dotenv>=0.19.0
        dataiku-api-client
        




## Importing the template into Dataiku

Follow these steps to import the template:

  * Download the [Code Studio template](<https://github.com/dataiku/solutions-contrib/raw/main/code-studio/dss_code_studio_template_infra.zip>).

  * In the **Application** menu, under **Administration** , navigate to the **Code Studios** panel and select the **Upload a Code Studio Template** option.

  * Import the template you’ve just downloaded.




  * If you encounter code environment related errors, you can remap `cookiecutter` and `infra37` to code environments existing in your Dataiku instance.




  * After importing the template, click on **Build** to prepare an image ready to be deployed for the Code Studio.




With these steps, your Code Studio template is ready for use. This enables you to swiftly initiate web application development in Dataiku projects, leveraging frameworks like Vue and Angular.

## Manual setup

This section explains how to create and configure a Code Studio template manually. You’ll learn how to add and modify the essential building blocks within a template.

### Template creation

To create a template:

  * Go to the **Application** menu.

  * Click **Administration**.

  * Select the **Code Studio** panel.

  * Click on the **\+ Create Code Studio Template** button.

  * Give a name to your new template.

  * Click on the **Create** button.

  * Finally, go to the **Definition** panel.




### Managing block definitions

  * **[File synchronization](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#file-synchronization>)** : This block synchronizes the file system between Code Studio and Dataiku. In this block, you can define some directories or files you want to exclude from synchronization. In the **Excluded files** section, enter the patterns: `node_modules/`, `.angular/`, `pycache`.

  * **[Kubernetes Parameters](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#kubernetes-parameters>)** : Configure Kubernetes settings, if applicable.

  * **[Visual Studio Code](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#visual-studio-code>)** : Add a Visual Studio Code block. Typically, no settings need to be changed here.

  * **[Append to Dockerfile](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#append-to-dockerfile>)** : Insert this block and include the following Dockerfile content:
        
        USER root
        RUN yum -y module install nodejs:18
        
        RUN node -v
        
        RUN yum install -y npm && \
        mkdir -p /usr/local/lib/node_modules && \
        chown dataiku:dataiku -R /usr/local/lib/node_modules && \
        npm install npm -g && \
        npm install pnpm -g && \
        npm install yarn -g && \
        npm install @angular/cli -g
        
        RUN yum -y remove git && \
        yum -y remove git-\* && \
        yum -y install https://packages.endpointdev.com/rhel/8/main/x86_64/endpoint-repo.noarch.rpm && \
        yum -y install git
        
        RUN cd /opt/dataiku/code-server/lib/vscode/extensions && \
        npm init -y && \
        npm i typescript
        




Note

This Dockerfile block does the following:

  * Install `npm`, `yarn`, `pnpm`, and the _Angular CLI_ globally.

  * Update `git` to the latest version.

  * Installs TypeScript for enhanced linting and IntelliSense in VS Code.




  * **[Add an Entrypoint](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#add-an-entry-point>)** : Expose the HTML service to make the frontend accessible from the Code Studio UI when launching your web application client server. Use `/$request_uri` for the proxied subpath.




  * **[Add an Entrypoint](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#add-an-entry-point>)** Add another entry point for your Flask backend. Use `/$request_uri` for the proxied subpath here as well.




Note

_You don’t need to expose the HTML service for this entry point._

  * **[Add Code environments](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#add-a-code-environment>)** : Finally, include the previously configured code environments for Cookiecutter.

  * **[Add Code environments](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html#add-a-code-environment>)** : Finally, include the previously configured code environments for Flask.

  * **Build** the template to prepare an image that is ready to be deployed for the Code Studio.




## Using the Configured Template

Once the template is set up, using it is straightforward:

  * Navigate to **< /> -> Code Studios** in the top navigation bar.

  * Click on **\+ New Code Studio** in the upper right and choose your configured template.

  * Start the code studio.

---

## [tutorials/webapps/code-studio/web-application-creation/index]

# Advanced setup: Web application creation and publication

This tutorial outlines the process of creating and publishing a web application using Code Studio. It specifically focuses on setting up a backend using Flask or FastAPI and creating an Angular frontend. It covers the necessary prerequisites, such as coding the backend and configuring the Angular application to work seamlessly with the backend. Additionally, it provides guidance on managing project files and running the application locally.

## Prerequisites

You need a Code Studio template, as defined in [the previous tutorial](<../configuring-code-studio/index.html>).

## Creating your backend

If you choose to code your backend in a location other than the project libraries, you will have to do so in the Code Studio. You may also have to run your backend manually. Coding the backend in the project libraries allows you to share its development with different users. The following shows how to create the backend in the project library, which you may want to adapt for your specific needs. If you don’t, Code Studio won’t be able to start the backend correctly.

Go to the project libraries (**< /> > Libraries**), and in the library editor under the `lib` folder, create a folder named “my-app “(if you choose `my-app` as a name for your backend server in [this section](<../configuring-code-studio/index.html#webapps-code-studio-configuring-code-studio-installing-the-backend>)).

In this folder, create a file named `api.py`. This file is responsible for defining the API that your backend will use. Code 1 shows a basic example of an interaction between the backend and Dataiku. The highlighted line defines a Flask blueprint (for more information, see the [Flask documentation](<https://flask.palletsprojects.com/en/3.0.x/blueprints/>)). You can define as many files as you need. These files will be attached to a specific route when creating the backend. You can use the FastAPI framework instead of Flask if you prefer.

Code 1: Basic example of interaction between Flask backend and Dataiku.
    
    
    from flask import Blueprint, jsonify
    import dataiku
    
    api = Blueprint("api", __name__)
    
    @api.route("/")
    def get_projects_name_from_instance():
        client = dataiku.api_client()
        projects = client.list_projects()
    
        return [p.get('name') for p in projects]
    

Still in the folder named `my-app`, create a file named `wsgi.py`. This file is responsible for creating and configuring the Flask backend server. In this file, you will link all the files previously defined. Code 2 shows an example of a correctly defined backend using the file `api.py` previously created.

Code 2: Creation of the backend server
    
    
    from flask import Flask
    from api import api
    
    app = Flask(__name__)
    
    app.register_blueprint(api)
    
    if __name__ == "__main__":
        app.run(host="127.0.0.1", port=5000)
    

You don’t need a fully functional server to start your Code Studio. However, if you need to add new files, restart the Code Studio for those files to be considered. Or, if you choose to add **“Custom actions”** in the template, you can click on the action button to restart the backend.

Once the backend is ready, you can create the Angular application.

## Creating your Angular application

### Creating the Code Studio

Go to **< /> -> Code studios**, click the **\+ New code studio** , choose the template created in this tutorial, select a name for your web application edition, and click the **Create** button. Once the Code Studio is created, click the **Start code studio** button. After a little wait, the Code Studio should be started, as shown in Figure 1. In this figure, you will find five different zones:

  1. This is the place where you will code your application.

  2. This is where you will visualize your application under development (`ng serve`). You will see only the frontend part, as the back end is not exposed to users but only to the front.

  3. This tab is for visualizing the compiled version of your application(`ng build`).

  4. This folder is where your application will live.

  5. This folder contains the code of your backend.




Figure 1: Starting Code Studio for the first time.

Currently, neither the “Front” tab nor the “NGINX” tab shows meaningful content. In Visual Code, open a new terminal and enter the following commands:
    
    
    cd code_studio-resources
    ng new --skip-git my_app
    

These commands will create a new Angular application in the folder `code_studio-resources/my_app`. The previous tutorial uses this name in the “[Preparing the Code Studio template to be published as a standalone web application](<../configuring-code-studio/index.html#webapps-code-studio-configuring-code-studio-preparing-code-studio>)” section.

If you don’t want to skip the git part, you should first configure your _git id_ (`user.name` and `user.email`). You should not enable the server-side rendering.

Once your Angular application is created, go to your application directory and save the permissions of the `node_modules` directory:
    
    
    cd my_app
    getfacl -R node_modules > saved_permissions
    

Each restart of the Code Studio will modify those permissions. To restore the initial permissions, enter the following command:
    
    
    setfacl --restore=saved_permissions
    

Still in the terminal, note the result of:
    
    
    echo $DKU_CODE_STUDIO_BROWSER_PATH_4200
    

If you choose another port for your frontend, you should change 4200 to the one you previously selected. Edit the `code_studio-resources/my-app/angular.json` file and change the `projects/my-app/architect/build/options/outputPath` field with the following content:
    
    
    "outputPath": {
          "base": "dist",
          "browser": ""
    },
    "baseHref": "<RESULT_OF_THE_PREVIOUS_COMMAND_YOU_SHOULD_REPLACE_THIS>/",
    "deployUrl": "",
    

`baseHref` and `deployUrl` should also be added/updated. Now, you are ready to go. Pay attention to the trailing slash for the `baseHref` field. To view the result of this Angular application in the terminal, enter the command:
    
    
    ng serve --host 127.0.0.1
    

If everything goes well, you should have something similar to Figure 2.

Figure 2: Starting the Angular application for the first time.

### Accessing the backend

Now that you have a running application, you may need to connect it to the backend. To do this, you need to use an `HttpClient`.

For example, to populate your welcome page with a list of all existing (and accessible) projects, you will first create the backend function to retrieve those names (shown in Code 1).

In `app.config.ts`, located in `my_app/src/app`, add the `HttpClientModule` as a provider:
    
    
    import { ApplicationConfig, importProvidersFrom } from '@angular/core';
    import { provideRouter } from '@angular/router';
    
    import { routes } from './app.routes';
    import { HttpClientModule } from '@angular/common/http';
    
    export const appConfig: ApplicationConfig = {
      providers: [
        provideRouter(routes),
        importProvidersFrom(HttpClientModule)
      ]
    };
    

Then, connect this provider with your root component (in `code-studio-resources/my_app/src/app.component.ts`), as shown in Code 3.

This code snippet creates a new property (`projects`) that you may use in the associated template. For example, you can put `{{ projects }}` just after the line containing `<div class="content">`, in the file `my_app/src/app/app.component.html`. By doing so, you will obtain something similar to Figure 3.

Code 3: Calling the backend from the frontend.
    
    
    import { Component, OnInit, isDevMode } from '@angular/core';
    import { RouterOutlet } from '@angular/router';
    import { HttpClient } from '@angular/common/http';
    
    @Component({
      selector: 'app-root',
      standalone: true,
      imports: [RouterOutlet],
      templateUrl: './app.component.html',
      styleUrl: './app.component.css'
    })
    export class AppComponent implements OnInit {
      title: String = "my-app";
      projects: String = "";
      backendUrl: string ='';
    
      constructor (private http:HttpClient){}
    
      ngOnInit() {
        this.backendUrl = isDevMode() ? '../5000/' : 'server/';
    
        this.http.get<String>(this.backendUrl+'projects', { responseType: 'text' as 'json'})
        .subscribe((resp:any) => {
          this.projects = resp
        });
      }
    }
    

Figure 3: Angular application with backend running.

## Publishing your angular application

Once you are happy with your application, you can publish it. As the **NGINX** block serves the `dist` folder when you start the web application, you need to build it. So that the `dist` directory contains an up-to-date version of your application. To build the Angular application, in the terminal, enter the following command:
    
    
    ng build --base-href __DKU_RUNTIME_BASE_PATH__/
    

Once the build is completed, go to the action panel and click the **Publish** button. Then, fill out the form, selecting the `NGINX` **Entrypoint to show** , as shown in Figure 4. Your web application is live! If the publication is the last step of your journey, you should remove (and update from the template) the `--debug` parameter used in [Installing and using the backend](<../configuring-code-studio/index.html#webapps-code-studio-configuring-code-studio-installing-the-backend>). You should not publicly publish a web application with a backend in debug mode.

Figure 4: Publishing an Angular application.

## Wrapping up

Congratulations! You have created and published an Angular application. You can add an image to the `assets` of your Angular application and use it in the HTML template. Replacing the content of the `app.component.html` with Code 4 will produce something equivalent to Figure 5.

Code 4: Simple template with an image.
    
    
    <style>
      .center {
        text-align: center;
      }
    </style>
    <main class="main">
      <div class="content center">
        <div>
          <img src="assets/img.jpg" alt="images" style="width:20%;" />
        </div>
        <h1>Projects</h1>
        <p>{{ projects }}</p>
      </div>
    </main>
    
    <router-outlet />
    

Figure 5: Simple template with an image.

You can now add new routes to your backend or develop new components for your Angular application. The development process for the Angular application follows the same rules as that for classical Angular application development.

---

## [tutorials/webapps/common/api/index]

# Creating an API endpoint from webapps

In this tutorial, you will learn how to build an API from a web application’s backend (called headless API) and how to use it from code. You will use an `SQLExecutor` to fetch information from a dataset, filtering them if needed.

You can use a headless web application to create an API endpoint for a particular purpose that doesn’t fit well in the API Node. For example, you may encounter this need if you want to use an SQLExecutor, access datasets, etc. The API node is still the recommended deployment for real-time inference and all use cases for which API-Node had been designed (see [this documentation](<https://doc.dataiku.com/dss/latest/apinode/concepts.html> "\(in Dataiku DSS v14\)") for more information about API-Node)

## Prerequisites

Standard - FlaskStandard - FastAPIDash

  * Dataiku >= 13.1

  * A code environment with `flask`.

  * You must download [`this dataset`](<../../../../_downloads/c89bf52ffb117f8e593903d6ee94813a/pro_customers.csv>) and create an **SQL** dataset named `pro_customers_sql`.




  * Dataiku >= 14.2

  * A code environment with `fastapi` and `uvicorn-worker`.

  * You must download [`this dataset`](<../../../../_downloads/c89bf52ffb117f8e593903d6ee94813a/pro_customers.csv>) and create an **SQL** dataset named `pro_customers_sql`.




  * Dataiku >= 13.1

  * A code environment with `dash`.

  * You must download [`this dataset`](<../../../../_downloads/c89bf52ffb117f8e593903d6ee94813a/pro_customers.csv>) and create an **SQL** dataset named `pro_customers_sql`.




## Defining the routes

The first step is to define the routes you want your API to handle. A single route is responsible for a (simple) process. Dataiku provides an easy way to describe those routes. Relying on a python server using either Flask or FastAPI framework helps you return the desired resource types. Check the **API access** in the web apps’ settings to use this functionality, as shown in Figure 1.

Figure 1: Enabling API access.

This tutorial relies on a single route handling some parameters to filter the data. The `get_customer_info` will provide all data stored in the `pro_customers_sql` as raw text. Filtering is done by adding an `id` parameter to this route. The answer will be in a JSON format.

For example, a query on `get_customer_info` will return the data stored in the dataset, shown in Table 1.

Table 1: customer ID id | name | job | company  
---|---|---|---  
tcook | Tim Cook | CEO | Apple  
snadella | Satya Nadella | CEO | Microsoft  
jbezos | Jeff Bezos | CEO | Amazon  
fdouetteau | Florian Douetteau | CEO | Dataiku  
wcoyote | Wile E. Coyote | Business Developer | ACME  
  
If you query `get_customer_info?id=fdouetteau`, the API should return only the information about the customer with the `id == fdouetteau`.

Note

You can still use the backend to create a classical web application. Turning a web application into a headless one does not prevent developing a web application.

Attention

The SQL query might be written differently depending on your SQL Engine.

Standard - FlaskStandard - FastAPIDash

You must enable the Python backend with Flask Framework and define the route when using a standard web application, as shown in Code 1.

Code 1: Python backend
    
    
    import dataiku
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    from flask import request, make_response
    import logging
    
    logger = logging.getLogger(__name__)
    
    DATASET_NAME = 'pro_customers_sql'
    
    
    @app.route('/get_customer_info')
    def get_customer_info():
        dataset = dataiku.Dataset(DATASET_NAME)
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
    
        id = request.args.get('id', None)
        if id:
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id"={escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                result = {"name": name, "job": job, "company": company}
            response = make_response(json.dumps(result))
            response.headers['Content-type'] = 'application/json'
            return response
        else:
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name}""")
            result = ""
            for (name, job, company) in query_reader.iter_tuples():
                result += f"""{name}, {job}, {company}
    """
    
            response = make_response(result)
            response.headers['Content-type'] = 'text/plain'
            return response
    

You must enable the Python backend with FastAPI Framework and define the route when using a standard web application, as shown in Code 1.

Code 1: Python backend
    
    
    import dataiku
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    from fastapi import Query
    from fastapi.responses import JSONResponse, PlainTextResponse
    import logging
    from typing import Optional
    
    logger = logging.getLogger(__name__)
    
    DATASET_NAME = 'pro_customers_sql'
    
    
    @app.get("/get_customer_info")
    async def get_customer_info(id: Optional[str] = Query(default=None)):
        dataset = dataiku.Dataset(DATASET_NAME)
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
    
        if id:
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id"={escaped_cid}"""
            )
            result = None
            for (name, job, company) in query_reader.iter_tuples():
                result = {"name": name, "job": job, "company": company}
            
            if result:
                return JSONResponse(content=result)
            else:
                return JSONResponse(content={"error": "Customer not found"}, status_code=404)
        
        else:
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name}"""
            )
            result = ""
            for (name, job, company) in query_reader.iter_tuples():
                result += f"""{name}, {job}, {company}\n"""
            
            return PlainTextResponse(content=result)
    

Once you have set the code env in the settings panel, you will define the route, as shown in Code 1.

Code 1: Python code of the Dash application
    
    
    import dash_html_components as html
    
    import dataiku
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    from flask import request, make_response
    
    DATASET_NAME = 'pro_customers_sql'
    
    
    @app.server.route('/get_customer_info')
    def get_customer_info():
        dataset = dataiku.Dataset(DATASET_NAME)
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
    
        id = request.args.get('id', None)
        if id:
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id"={escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                result = {"name": name, "job": job, "company": company}
            response = make_response(json.dumps(result))
            response.headers['Content-type'] = 'application/json'
            return response
        else:
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} """)
            result = ""
            for (name, job, company) in query_reader.iter_tuples():
                result += f"""{name}, {job}, {company}
    """
    
            response = make_response(result)
            response.headers['Content-type'] = 'text/plain'
            return response
    
    
    # We need to have a layout (even if we don't use it)
    # In case we don't set a layout dash application won't start
    app.layout = html.Div()
    

When using Dash as a web application framework, you can access the defined routes directly without enabling API Access. Every web application is accessible via the URL `https://<DATAIKU_ADDRESS>:<DATAIKU_PORT>/public-webapps/<PROJECT_KEY>/<WEBAPP_ID>/`. You will find more information on extracting those parameters in the cUrl section. It does not mean that the web application is public; it means that the application is also exposed on this route. You can also use Vanity URL if you want.

## Interacting with the newly defined API

To access the headless API, you must be logged on to the instance or have an API key that identifies you. If you need help setting up an API key, please read [this tutorial](<https://doc.dataiku.com/dss/latest/publicapi/keys.html> "\(in Dataiku DSS v14\)"). Then, there are several different ways to interact with a headless API.

cUrlPython

Using cUrl requires an API key to access the headless API or an equivalent way of authenticating, depending on the authentication method set on the Dataiku instance. Once you have this API key, you can access the API endpoint with the following command. The `WEBAPP_ID` is the first eight characters (before the underscore) in the webapp URL. For example, if the webapp URL in Dataiku is `/projects/HEADLESS/webapps/kUDF1mQ_api/view`, the `WEBAPP_ID` is `kUDF1mQ` and the `PROJECT_KEY` is `HEADLESS`.

Code 2: `cUrl` command to fetch data
    
    
    curl -X GET --header 'Authorization: Bearer <USE_YOUR_API_KEY>' \
        'http://<DATAIKU_ADDRESS>:<DATAIKU_PORT>/web-apps-backends/<PROJECT_KEY>/<WEBAPP_ID>/get_customer_info'
    

You can access the headless API using the Python API. Depending on whether you are inside Dataiku or outside, you will use the `dataikuapi` or the `dataiku` package, respectively, as shown in Code 3.

Code 3: Fetching data from the Python client
    
    
    import dataiku, dataikuapi
    
    API_KEY=""
    DATAIKU_LOCATION = "" #http(s)://DATAIKU_HOST:DATAIKU_PORT
    PROJECT_KEY = ""
    WEBAPP_ID = ""
    
    
    # Depending on your case, use one of the following
    
    #client = dataikuapi.DSSClient(DATAIKU_LOCATION, API_KEY)
    client = dataiku.api_client()
    
    
    project = client.get_project(PROJECT_KEY)
    webapp = project.get_webapp(WEBAPP_ID)
    backend = webapp.get_backend_client()
    
    # To retrieve all users
    print(backend.session.get(backend.base_url + '/get_customer_info').text)
    
    # To filter on one user
    print(backend.session.get(backend.base_url + '/get_customer_info?id=fdouetteau').text)
    

## Wrapping up

If you need to give access to unauthenticated users, you can turn your web application into a public one, as [this documentation](<https://doc.dataiku.com/dss/latest/webapps/public.html> "\(in Dataiku DSS v14\)") suggests. Now that you understand how to turn a web application into a headless one, you can create an agent-headless API.

---

## [tutorials/webapps/common/api-llm/index]

# Querying the LLM from an headless API

In this tutorial, you will learn how to build an API from a web application’s backend (called headless API) and how to use it from code. You will use the LLM Mesh to query an LLM and serving the response.

You can use a headless web application to create an API endpoint for a particular purpose that doesn’t fit well in the API Node. For example, you may encounter this need if you want to use an SQLExecutor, access datasets, etc. The API node is still the recommended deployment for real-time inference and all use cases for which API-Node had been designed (see [this documentation](<https://doc.dataiku.com/dss/latest/apinode/concepts.html> "\(in Dataiku DSS v14\)") for more information about API-Node)

## Prerequisites

Standard - FlaskStandard - FastAPIDash

  * Dataiku >= 13.1




  * Dataiku >= 14.1




  * Dataiku >= 13.1

  * A code environment with `dash`.




## Building the server

The first step is to define the routes you want your API to handle. A single route is responsible for a (simple) process. Dataiku provides an easy way to describe those routes. Relying on a Flask or FastAPI server helps you return the desired resource types. Check the **API access** in the web apps’ settings to use this functionality, as shown in Figure 1.

Figure 1: Enabling API access.

This tutorial relies on a single route (`query`) to query an LLM. As the message sent to the LLM could be very long, you can not consider passing the message in the URL. So, you will have to send the message in the body of the request. For this, `GET` method is not the recommended way, as it is not suppose to have a body. You will use the `POST` method to send the message in a JSON body associated to the request. Once the query comes to the server, the server will extract the message, send it to the LLM and return the response to the user.

Before accessing to the body, you have to check if the `Content-type` is well defined. Then, you must extract the message from the body. Send the message to the LLM, and if querying the LLM is successful return the response to the user. Highlighted lines in Code1 show how to do. The remaining lines show how to set up the whole application.

Standard - FlaskStandard - FastAPIDash

Code 1: LLM Headless API
    
    
    import dataiku
    from flask import request, make_response
    
    LLM_ID = "openai:openai:gpt-3.5-turbo"
    llm = dataiku.api_client().get_default_project().get_llm(LLM_ID)
    
    
    @app.route('/query', methods=['POST'])
    def query():
        content_type = request.headers.get('Content-Type')
        if content_type == 'application/json':
            json = request.json
            user_message = json.get('message', None)
            if user_message:
                completion = llm.new_completion()
                completion.with_message(user_message)
                resp = completion.execute()
    
                if resp.success:
                    msg = resp.text
                else:
                    msg = "Something went wrong"
            else:
                msg = "No message was found"
    
            response = make_response(msg)
            response.headers['Content-type'] = 'application/json'
            return response
        else:
            return 'Content-Type is not supported!'
    

Code 1: LLM Headless API
    
    
    import dataiku
    from fastapi import Request, Response
    from fastapi.responses import JSONResponse
    
    LLM_ID = "openai:openai:gpt-3.5-turbo"
    llm = dataiku.api_client().get_default_project().get_llm(LLM_ID)
    
    
    @app.post("/query")
    async def query(request: Request):
        content_type = request.headers.get("content-type")
        
        if content_type == "application/json":
            json_data = await request.json()
            user_message = json_data.get("message")
    
            if user_message:
                completion = llm.new_completion()
                completion.with_message(user_message)
                resp = completion.execute()
    
                msg = resp.text if resp.success else "Something went wrong"
            else:
                msg = "No message was found"
    
            return JSONResponse(content={"message": msg})
        else:
            return Response(content="Content-Type is not supported!", media_type="text/plain")
    

Code 1: LLM Headless API
    
    
    from dash import html
    
    import dataiku
    from flask import request, make_response
    
    LLM_ID = "openai:openai:gpt-3.5-turbo"
    llm = dataiku.api_client().get_default_project().get_llm(LLM_ID)
    
    
    @app.server.route('/query', methods=['POST'])
    def query():
        content_type = request.headers.get('Content-Type')
        if content_type == 'application/json':
            json = request.json
            user_message = json.get('message', None)
            if user_message:
                completion = llm.new_completion()
                completion.with_message(user_message)
                resp = completion.execute()
    
                if resp.success:
                    msg = resp.text
                else:
                    msg = "Something went wrong"
            else:
                msg = "No message was found"
    
            response = make_response(msg)
            response.headers['Content-type'] = 'application/json'
            return response
        else:
            return 'Content-Type is not supported!'
    
    
    # We need to have a layout (even if we don't use it)
    # In case we don't set a layout dash application won't start
    app.layout = html.Div("HeadLess WebAPP. No Interface")
    

## Querying the API

To access the headless API, you must be logged on to the instance or have an API key that identifies you. If you need help setting up an API key, please read [this tutorial](<https://doc.dataiku.com/dss/latest/publicapi/keys.html> "\(in Dataiku DSS v14\)"). Then, there are several different ways to interact with a headless API.

cUrlPython

Using cUrl requires an API key to access the headless API or an equivalent way of authenticating, depending on the authentication method set on the Dataiku instance. Once you have this API key, you can access the API endpoint with the following command. The `WEBAPP_ID` is the first eight characters (before the underscore) in the webapp URL. For example, if the webapp URL in Dataiku is `/projects/HEADLESS/webapps/kUDF1mQ_api/view`, the `WEBAPP_ID` is `kUDF1mQ` and the `PROJECT_KEY` is `HEADLESS`.

Code 2: `cUrl` command to fetch data
    
    
    curl -X POST --header 'Authorization: Bearer <USE_YOUR_API_KEY>' \
     'http://<DATAIKU_ADDRESS>:<DATAIKU_PORT>/web-apps-backends/<PROJECT_KEY>/<WEBAPP_ID>/query' \
     --header 'Content-Type: application/json' \
     --data '{
         "message": "Write an haiku on boardgames"
     }'
    

You can access the headless API using the Python API. Use the `dataikuapi` or the `dataiku` package, to create a [`dataikuapi.DSSClient`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient"), as shown in [Code 3](<../api/index.html#tutorial-webapps-common-api-python>).

Code 3: Fetching data from the Python client
    
    
    import dataiku, dataikuapi
    
    API_KEY=""
    DATAIKU_LOCATION = "" #http(s)://DATAIKU_HOST:DATAIKU_PORT
    PROJECT_KEY = ""
    WEBAPP_ID = ""
    
    
    # Depending on your case, use one of the following
    
    #client = dataikuapi.DSSClient(DATAIKU_LOCATION, API_KEY)
    client = dataiku.api_client()
    
    
    project = client.get_project(PROJECT_KEY)
    webapp = project.get_webapp(WEBAPP_ID)
    backend = webapp.get_backend_client()
    
    
    backend.session.headers['Content-Type'] = 'application/json'
    
    # Query the LLM
    print(backend.session.post(backend.base_url + '/query', json={'message':'Coucou'}).text)
    

## Wrapping up

If you need to give access to unauthenticated users, you can turn your web application into a public one, as [this documentation](<https://doc.dataiku.com/dss/latest/webapps/public.html> "\(in Dataiku DSS v14\)") suggests. Now that you understand how to turn a web application into a headless one, you can create an agent-headless API.

---

## [tutorials/webapps/common/impersonation/index]

# Impersonation with webapps

By default, webapps require users to be authenticated. For more details and options, please see [Public webapps](<https://doc.dataiku.com/dss/latest/webapps/public.html> "\(in Dataiku DSS v14\)").

It is essential to consider the security and permission aspects of impersonation while using webapps. You can refer to [this documentation](<https://doc.dataiku.com/dss/latest/webapps/security.html> "\(in Dataiku DSS v14\)") to learn more about these aspects.

Each time a user uses a webapp, the code is executed on behalf of a user, defined by the “Run backend as” parameter configured in the webapp settings, as illustrated in Figure 1. Therefore, the actions performed by the user are attributed to the user mentioned in the “Run backend as” parameter.

Figure 1: Backend configuration.

For example, if user U1 runs a webapp with the “Run backend as” parameter set to A1, the actions taken by U1 will be identified as actions taken by the user A1. If you need the actions being identified as actions taken by user U1, you must make an impersonation call.

Webapps can be accessed by any user with the necessary permissions, such as “Read dashboards” or “Read project content” after successfully logging in. You can refer to the [Public webapps](<https://doc.dataiku.com/dss/latest/webapps/public.html> "\(in Dataiku DSS v14\)") page if you require further information.

## Impersonation usage

Impersonation calls work on any web framework so that you can use your preferred web framework. Creating a simple webapp allows you to test, evaluate, and understand how impersonation works. When a job starts, Dataiku logs it. Then, you can observe impersonation by examining a Dataiku project’s interface and jobs section.

To test impersonation, you will create a web application that builds a dataset (i.e., starts a job). You can observe impersonation by examining a Dataiku project’s interface or the jobs section. To carry out this task, you will use the Dataiku TShirts project. To do so:

  1. On the top left corner, click **\+ New project > Learning projects > Dataiku TShirts**.

  2. On the top navigation bar, navigate to the **< /> > Webapp** section.

  3. Click on **\+ New Webapp** and select **Code Webapp**.

  4. Select the library with which you want to build your webapp. For standard webapps, you can choose either Flask or FastAPI as backend framework. Examples are provided for both.




The webapp aims to build a dataset present in the project; for example, you will build the `web_history_prepared` dataset.

## Implementation

The code presented demonstrates how to access user information and retrieve their name. The button action will launch a build of a Dataset, using impersonation so that the Dataset build is done as the end-user.

Standard - FlaskStandard - FastAPIDashBokehStreamlit

HTML Code
    
    
    1<h1>Impersonation Demo</h1>
    2
    3<h2>Welcome: <span id="identified_user"></span></h2>
    4
    5<div class="build_dataset">
    6    <form id="form-dataset" novalidate>
    7        <button type="button" class="main-blue-button" id="build-button">Build the dataset</button>
    8    </form>
    9</div>
    

Javascript code
    
    
     1/*
     2 * For more information, refer to the "Javascript API" documentation:
     3 * https://doc.dataiku.com/dss/latest/api/js/index.html
     4 */
     5
     6let buildButton = document.getElementById('build-button');
     7let identifiedUser = document.getElementById('identified_user')
     8
     9buildButton.addEventListener('click', function (event) {
    10    datasetToBuild = "web_history_prepared"
    11    $.get(getWebAppBackendUrl("/build_dataset"), {datasetToBuild: datasetToBuild});
    12});
    13
    14// When loading, get the user information
    15$.getJSON(getWebAppBackendUrl('/get_user_name'), function (data) {
    16    identifiedUser.textContent = data;
    17});
    

Backend code
    
    
     1import dataiku
     2from flask import request, jsonify
     3
     4import logging
     5
     6logger = logging.getLogger(__name__)
     7
     8
     9# Example:
    10# As the Python webapp backend is a Flask app, refer to the Flask
    11# documentation for more information about how to adapt this
    12# example to your needs.
    13# From JavaScript, you can access the defined endpoints using
    14# getWebAppBackendUrl('get_user_name')
    15
    16@app.route('/get_user_name')
    17def get_user_name():
    18    logger.info("In it")
    19    logger.info(request)
    20    # Get user information from the request
    21    headers = dict(request.headers)
    22    auth_info = dataiku.api_client().get_auth_info_from_browser_headers(headers)
    23    return (json.dumps(auth_info.get("associatedDSSUser")))
    24
    25@app.route('/build_dataset')
    26def build_dataset():
    27    dataset = request.args.get('datasetToBuild')
    28    logger.info("Impersonation begins...")
    29    # Launch the build of a Dataset using impersonation.
    30    # This Dataset build will be done as the end-user.
    31    with dataiku.WebappImpersonationContext() as context:
    32        # Each time you need to do impersonation, you need to obtain a client.
    33        local_client = dataiku.api_client()
    34        project = local_client.get_default_project()
    35        outdataset = project.get_dataset(dataset)
    36        outdataset.build()
    37
    38    logger.info("Impersonation ends...")
    39    resp = jsonify(success=True)
    40    return resp
    

HTML Code
    
    
    1<h1>Impersonation Demo</h1>
    2
    3<h2>Welcome: <span id="identified_user"></span></h2>
    4
    5<div class="build_dataset">
    6    <form id="form-dataset" novalidate>
    7        <button type="button" class="main-blue-button" id="build-button">Build the dataset</button>
    8    </form>
    9</div>
    

Javascript code
    
    
     1/*
     2 * For more information, refer to the "Javascript API" documentation:
     3 * https://doc.dataiku.com/dss/latest/api/js/index.html
     4 */
     5
     6let buildButton = document.getElementById('build-button');
     7let identifiedUser = document.getElementById('identified_user')
     8
     9buildButton.addEventListener('click', function (event) {
    10    datasetToBuild = "web_history_prepared"
    11    $.get(getWebAppBackendUrl("/build_dataset"), {datasetToBuild: datasetToBuild});
    12});
    13
    14// When loading, get the user information
    15$.getJSON(getWebAppBackendUrl('/get_user_name'), function (data) {
    16    identifiedUser.textContent = data;
    17});
    

Backend code
    
    
     1import dataiku
     2from fastapi import Request
     3from fastapi.responses import JSONResponse
     4
     5import logging
     6
     7logger = logging.getLogger(__name__)
     8
     9
    10# Example:
    11# As the Python webapp backend is a FastAPI app, refer to the FastAPI
    12# documentation for more information about how to adapt this
    13# example to your needs.
    14# From JavaScript, you can access the defined endpoints using
    15# getWebAppBackendUrl('get_user_name')
    16
    17@app.get("/get_user_name")
    18async def get_user_name(request: Request):
    19    logger.info("In it")
    20    logger.info(request)
    21    # Get user information from the request (can be done with impersonation)
    22    headers = dict(request.headers)
    23    auth_info = dataiku.api_client().get_auth_info_from_browser_headers(headers)
    24    return JSONResponse(content=auth_info.get("associatedDSSUser"))
    25
    26@app.get("/build_dataset")
    27async def build_dataset(datasetToBuild: str):
    28    logger.info("Impersonation begins...")
    29    # Launch the build of a Dataset using impersonation.
    30    # This Dataset build will be done as the end-user.
    31    with dataiku.WebappImpersonationContext() as context:
    32        # Each time you need to do impersonation, you need to obtain a client.
    33        local_client = dataiku.api_client()
    34        project = local_client.get_default_project()
    35        outdataset = project.get_dataset(datasetToBuild)
    36        outdataset.build()
    37
    38    logger.info("Impersonation ends...")
    39    return JSONResponse(content={"success": True})
    

Dash code
    
    
     1from dash import html, Input, Output
     2from dash.exceptions import PreventUpdate
     3from flask import request
     4import logging
     5import dataiku
     6
     7logger = logging.getLogger(__name__)
     8
     9dataset_to_build = "web_history_prepared"
    10
    11# build your Dash app
    12app.layout = html.Div([
    13    html.H1("Impersonation Demo", style={'text-align': 'center'}),
    14    html.H3([
    15        html.Span("Welcome: "),
    16        html.Span(id="identified_user")
    17    ]),
    18    html.Button('Build the dataset', id='submit-val', n_clicks=0)
    19])
    20
    21
    22@app.callback(
    23    Output('identified_user', 'children'),
    24    Input('identified_user', 'children')
    25)
    26def load_user_credentials(children):
    27    if children:
    28        raise PreventUpdate
    29    else:
    30        # Get user info from request (can be done with impersonation)
    31        request_headers = dict(request.headers)
    32        auth_info = dataiku.api_client().get_auth_info_from_browser_headers(request_headers)
    33        return auth_info.get("associatedDSSUser")
    34
    35@app.callback(
    36    Output('submit-val', 'n_clicks'),
    37    Input('submit-val', 'n_clicks'),
    38    prevent_initial_call=True
    39)
    40def update_output(n_clicks):
    41    logger.info("Impersonation begins...")
    42    # Launch the build of a Dataset using impersonation.
    43    # This Dataset build will be done as the end-user.
    44    with dataiku.WebappImpersonationContext() as context:
    45        # Each time your need to do impersonation, you need to obtain a client.
    46        local_client = dataiku.api_client()
    47        project = local_client.get_default_project()
    48        outdataset = project.get_dataset(dataset_to_build)
    49        outdataset.build()
    50
    51    logger.info("Impersonation ends...")
    52    raise PreventUpdate
    

Bokeh code
    
    
     1import dataiku
     2
     3from functools import partial
     4
     5from bokeh.io import curdoc
     6from bokeh.models import Div, Button
     7from bokeh.layouts import layout
     8from dataiku.webapps.run_bokeh import get_session_headers
     9
    10import logging
    11
    12logger = logging.getLogger(__name__)
    13
    14dataset_to_build = "web_history_prepared"
    15
    16
    17def build_dataset(dataset):
    18    logger.info('impersonation')
    19    with dataiku.WebappImpersonationContext() as ctx:
    20        local_client = dataiku.api_client()
    21        project = local_client.get_default_project()
    22        outdataset = project.get_dataset(dataset)
    23        outdataset.build()
    24
    25
    26def application():
    27    title = Div(text="""<h1>Impersonation Demo</h1>""")
    28
    29    # Get user form http request (can be done with user impersonation)
    30    headers = get_session_headers(curdoc().session_context.id)
    31    auth_info = dataiku.api_client().get_auth_info_from_browser_headers(headers)
    32    user = auth_info.get('associatedDSSUser')
    33    subtitle = Div(text=f"""<h2>Welcome: <span id="identified_user">{user}</span></h2>""")
    34
    35    button = Button(label="Build the dataset")
    36    button.on_event('button_click', partial(build_dataset, dataset=dataset_to_build))
    37
    38    app = layout([title, subtitle, button])
    39    curdoc().add_root(app)
    40
    41    curdoc().title = "Impersonation"
    42
    43
    44application()
    

Streamlit code
    
    
     1# tested with Streamlit 1.50.0
     2import streamlit as st
     3
     4import dataiku
     5import logging
     6
     7logger = logging.getLogger(__name__)
     8
     9dataset_to_build = "web_history_prepared"
    10
    11
    12def build_dataset(dataset):
    13    # Launch the build of a Dataset using impersonation.
    14    # This Dataset build will be done as the end-user.
    15    with dataiku.WebappImpersonationContext() as context:
    16        local_client = dataiku.api_client()
    17        project = local_client.get_default_project()
    18        outdataset = project.get_dataset(dataset_to_build)
    19        outdataset.build()
    20
    21st.title('Impersonation Demo')
    22request_headers = dict(st.context.headers)
    23auth_info = dataiku.api_client().get_auth_info_from_browser_headers(request_headers)
    24st.subheader(f"Welcome: {auth_info.get('authIdentifier')}")
    25
    26st.button("Build the dataset", on_click=build_dataset, args=[dataset_to_build])
    

## Wrapping Up

Congratulations! You know how to use and implement impersonation for web applications. Permissions and impersonation are critical points for web application security.

---

## [tutorials/webapps/common/index]

# Common subjects on webapps

  * [Creating an API endpoint from webapps](<api/index.html>)

  * [Querying the LLM from an headless API](<api-llm/index.html>)

  * [Impersonation with webapps](<impersonation/index.html>)

  * [Accessing and understanding logs for WebApps](<logs/index.html>)

  * [Accessible resources from webapps](<resources/index.html>)

---

## [tutorials/webapps/common/logs/index]

# Accessing and understanding logs for WebApps

In this tutorial, we’ll demonstrate how you can leverage logs in your Dataiku Web Applications.

## Prerequisites

  * Dataiku 14.4 or higher

  * Optional: Kubernetes cluster




## Create a Web Application

For this tutorial, we’ll be looking at the logs of a Web Application built in Dataiku. But in order to do this, you’ll need to create a Web Application first.

Head over to your project, and on the top menu, under the code (`</>`) menu item, click on **Webapps**. Then click on the **New Webapp** button on the top-right, and choose **Code Webapp**.

Choose **Standard** , then choose **Simple web app to get started** , enter a name at the bottom of the dialog and then click the **Create** button on the bottom-right of the dialog.

You’ll now be presented with the code of your newly created Web Application. Click on the **Settings** tab at the top of the screen and choose **Enable Backend**. Under “Scalability & Deployment”, make sure the **Container** section is selected as **None**. Then click the **Save** button on the top right.

## Check the logs

After the saving of your settings is completed, your backend should’ve launched as well. To confirm this, head over to the **Logs** tab at the top of the screen, which should now look something like this.

As you can see, you have 4 tabs for logs:

  * WEBAPP

  * BACKEND

  * SETUP

  * EXPOSITION




The **Backend** tab logs contain all the logs of your Python backend, and the **Webapp** tab contains all the logs of your application itself. Of course any logs from your JavaScript code will show up in the browser console under the development tools and not in the logs.

You’ll also note the **Setup** and **Expositon** are both empty.

### Checking logs in Code Studios

In Code Studios it is also possible to see split logs. For this, head over to your code studio, click the **Logs** tab at the top of the screen, and there you will find the logs in a similar way as you see them in Web Application. However, in Code Studios you will only find the following tabs available to you:

  * BACKEND

  * SETUP

  * EXPOSITION




Because Code Studios have “running on cluster” as a prerequisite, all three log tabs will be available from the start.

If you want to know how to create a Code Studio, follow this tutorial: [Basic setup: Code studio template](<../../code-studio/template/index.html>)

## Enabling containers

To get logs in the **Setup** and **Exposition** tabs, you’ll have to enable “containers”.

Head over to the **Settings** tab at the top of the screen, and under “Scalability & Deployment”, there’s a **Container** setting. Choose either **Inherit** or **Select a container configuration** to enable running the Web Application on Kubernetes. If you chose “Select a container configuration”, make sure you then actually select a configuration in the dropdown that shows up after you’ve made that selection.

Once your settings are correct, click **Save** on the top-right of your screen. After the Webapp is done saving, head over to the **Logs** tab once more, and check if both the **Setup** and **Exposition** tabs now have logs defined.

## Log History

Now that you have explored all the log options, it is good to know you can also see the logs of previous runs. As you have been redeploying and re-running the application several times during this tutorial, you should now see several historical runs in your **Logs** tab. This should look something like this.

If you click the **Show run…** dropdown and you return to your first run, you should see the initial run of your Web Application again with both the **Setup** and **Exposition** tabs empty again.

This way, you can always explore all the logs of the different runs, and also understand what went wrong in previous runs if you had any errors, this can be especially useful if auto-start has been enabled for a Web Application and you run into errors at that stage.

## Conclusion

Now you know how logs work and behave with Dataiku Webapps. And you know the 4 different logs, as well as the history of previous logs, and how to explore these.

---

## [tutorials/webapps/common/resources/index]

# Accessible resources from webapps

Web applications need access to various resources to function correctly. These resources can be internal (stored in Dataiku) or external (stored outside of Dataiku).

To access these resources, there are several strategies that developers can use depending on the specific use case. For example, the developer can use a JavaScript function to fetch the necessary data or assets if the resource is required during an event, such as when a button is clicked. Alternatively, the developer can use server-side code to retrieve the necessary information if the resource is needed when the web app is being built, for example. This tutorial will outline some of the most essential best practices for accessing resources in web apps.

At the end of the tutorial the complete code is provided for each framework. Each code highlights all different use cases for one dedicated framework. The Standard webapp framework examples use Flask for the backend, you can also use FastAPI instead if you prefer. You will have to adapt the routes yourself in that case.

## External resources

When creating a web application in Dataiku that requires accessing external resources, the process is similar to traditional web application development. In other words, you can use the standard HTML tags to access a resource on a specific URL. For instance, Code 1 below illustrates how to display an image using an external URL.

StandardDashStreamlitStreamlit (Code Studio)

Code 1: How to use external resources
    
    
    <img src="https://picsum.photos/200/300" alt="Random picture from the internet"></img>
    

Or you can use Javascript to retrieve data.

Code 1.1: How to use external resources in Javasript
    
    
    /* Javascript function for external URL */
    let externalImageJs = document.getElementById('externalImageJs')
    
    fetch("https://picsum.photos/200/300")
        .then(response => response.blob())
        .then(image => externalImageJs.src = URL.createObjectURL(image))
    

Code 1: How to use external resources
    
    
    html.Div([html.Div(["You can use images coming from an URL by using the classical ",
                        html.Code('html.Img(src="URL_TO_USE", alt="Alternate text")')]),
              html.Img(src="https://picsum.photos/200/300", alt="Image to display")])),
    

Code 1: display an image from an external web site
    
    
    import streamlit as st
    
    with st.container():
        st.write("### Display an image")
        st.image("https://picsum.photos/200", caption="From https://picsum.photos/")
    

Code 1: How to use external resources
    
    
    with st.container():
        st.write("### Display an image")
        st.image("https://source.unsplash.com/random/1920x1080/?cat=")
    

## Internal resources

Web applications in Dataiku can use resources stored in Dataiku. There are various places where resources can be stored.

  * The section Internal resources stored in a managed folder explains how to use resources stored in a managed folder. Storing data in a managed folder is outside the scope of this tutorial, as there is nothing more than creating a managed folder and putting your data in it. These resources are tied to a project when storing resources in a managed folder. If you need to store resources for multiple project, consider storing them in the **Global shared code** or sharing the managed folder across projects.

  * The section Using resources stored in resources in project library explains how to use resources stored in the resources project library. These resources are tied to a project library. So you should consider this option, if your data are local to a project, do not want those data to appear in the flow, and you need the user to have a minimal set of permissions (defined by the project) to access or edit those data.

  * The section Internal resources stored in the global shared code explains how to store user resources stored in the **Static web resources** , defined in the **Global shared code** in the application menu. Suppose your resources are not dedicated to a project and are not sensitive data, or your web application is intended to be a public web app. In that case you should store these resources in the **Static web resources**.

  * The section Using resources stored in the Code Studios focuses on Code Studios and its usage when storing resources inside. You should store your resources in Code Studio. If you want your resources been between multiple projects within Code Studio templates, use the “Append to Dockerfile” block; see [Preparing Code Studio templates](<https://doc.dataiku.com/dss/latest/code-studios/code-studio-templates.html> "\(in Dataiku DSS v14\)").




The tutorial explains how to handle three different file types in each section. Depending on the framework, file usage can change depending on the file type. We have highlighted the most frequent usage of images, files, and CSS. Even though those resources are handled in the same way, the purpose of their usage changes.

### Internal resources stored in a managed folder

#### Displaying an image

StandardDashStreamlitStreamlit (Code Studio)

There are three steps to follow to load and use an image in a Dataiku web application:

  * Use the `img` tag in your HTML with the `src` attribute set to `""` (Code 2.1).

  * In the Python backend, create a route to retrieve and serve the image file (Code 2.2).

  * In the JavaScript tab, dynamically set the image source to the route created in Code 2.2 (Code 2.3)




Code 2.1: Use the `img` tag
    
    
    <img id="getImageFromManageFolderImg" alt="image" class="container"></img>
    

Code 2.2: Backend route for serving an image
    
    
    import dataiku
    import pandas as pd
    from flask import request
    
    # Definition of the various resources (This can be done programmatically)
    # ## Name of the managed folder
    folder = "Resources"
    # ## Path name of the files
    image = "/image.png"
    pdf = "/document.pdf"
    css = "/my-css.css"
    
    
    def get_file_from_managed_folder(folder_name, file_name):
        """
        Retrieve the file from the managed folder
        Args:
            folder_name: name of the managed folder
            file_name: name of the file
    
        Returns:
            the file
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return (f.read())
    
    @app.route('/get_image_from_managed_folder')
    def get_image_from_managed_folder():
        return get_file_from_managed_folder(folder, image)
    

Code 2.3: Javascript for dynamically load the image
    
    
    let getImageFromManageFolderImg  = document.getElementById('getImageFromManageFolderImg')
    
    
    getImageFromManageFolderImg.src  = getWebAppBackendUrl('/get_image_from_managed_folder')
    

Code 2.1: Defining an helper function
    
    
    import dash
    from dash import html
    from dash import dcc
    from dash.dependencies import Input
    from dash.dependencies import Output
    import dataiku
    import base64
    
    import logging
    
    logger = logging.getLogger(__name__)
    
    folder_name = "Resources"
    image_name = "/image.png"
    pdf_name = "/document.pdf"
    css_name = "/my-css.css"
    
    def get_image_from_managed_folder():
        """ Read a Png image and return the encoded version
    
        Returns:
            a base64 encoded image
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(image_name) as f:
            image = f.read()
        return 'data:image/png;base64,' + base64.b64encode(image).decode('utf-8')
    

Code 2.2: Use the `html.Img` element
    
    
    html.Div([html.Div([
        "You can use images coming from a managed folder by using the classical, in conjunction with a python funtion ",
        html.Code(
            'html.Img(src=function_that_returns_the_image, alt="Alternate text")')]),
        html.Img(src=get_image_from_managed_folder(), alt="Image to display",
                 className="container")])),
    

Code 2.1: display an image from a managed folder
    
    
    import streamlit as st
    import dataiku
    
    
    def get_file_content_from_managed_folder(folder_name, file_name):
        """
        Retrieves the content of a file from a managed folder, as bytes
    
        Args:
            folder_name: name of the folder to retrieve the file from
            file_name: name of the file to retrieve
    
        Returns:
            the file content, as bytes
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return f.read()
    
    
    folder = "Resources"
    
    st.write("### Display an image")
    st.image(get_file_content_from_managed_folder(folder, "image.jpg"))
    

Code 2.1: defining an helper function
    
    
    import streamlit as st
    import dataiku
    import io
    import logging
    
    logger = logging.getLogger(__name__)
    
    host = "http://<dataikuURL>:<port>/"
    folder = "Resources"
    image = "/image.jpg"
    pdf = "/file.pdf"
    css = "/my-css.css"
    
    
    def get_file_from_managed_folder(folder_name, file_name):
        """
        Retrieves a file from a managed folder
    
        :param folder_name: name of the folder to retrieve the file from
        :param file_name: name of the file to retrieve
        Returns:
            the file.
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return (f.read())
    

Code 2.2: Use the st.image element
    
    
    with st.container():
        st.write("### Display an image")
        st.image(get_file_from_managed_folder(folder, image))
    

#### Serving a file

Serving a file for an end-user relies on the same principle. Except you don’t display it.

StandardDashStreamlitStreamlit (Code Studio)

Code 3.1: Serving a file (HTML part)
    
    
    <p>The image is loaded within the javascript code</p>
    <a id="getPDFFromManagedFolderA" href="" download="file.pdf">
        <span id="getPDFFromManagedFolder" onclick="" class="btn btn-primary">Get PDF file</span>
    </a>
    

Code 3.2: Serving a file (Javascript part)
    
    
    let getPDFFromManagedFolder      = document.getElementById('getPDFFromManagedFolder')
    let getPDFFromManagedFolderA     = document.getElementById('getPDFFromManagedFolderA')
    
    
    getPDFFromManagedFolderA.href    = getWebAppBackendUrl('/get_pdf_from_managed_folder')
    getPDFFromManagedFolder.addEventListener('click', () => {
        getWebAppBackendUrl('/get_pdf_from_managed_folder')
    });
    

Code 3.3: Serving a file (Backend)
    
    
    def get_file_from_managed_folder(folder_name, file_name):
        """
        Retrieve the file from the managed folder
        Args:
            folder_name: name of the managed folder
            file_name: name of the file
    
        Returns:
            the file
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return (f.read())
    
    
    @app.route('/get_pdf_from_managed_folder')
    def get_pdf_from_managed_folder():
        return get_file_from_managed_folder(folder, pdf)
    

Code 3.1: Serving a file – Helper function
    
    
    import dash
    from dash import html
    from dash import dcc
    from dash.dependencies import Input
    from dash.dependencies import Output
    import dataiku
    import base64
    
    import logging
    
    logger = logging.getLogger(__name__)
    
    folder_name = "Resources"
    image_name = "/image.png"
    pdf_name = "/document.pdf"
    css_name = "/my-css.css"
    
    # use the style of examples on the Plotly documentation
    @app.callback(
        Output("downloadManagedFolder", "data"),
        Input("btnImageManagedFolder", "n_clicks"),
        prevent_initial_call=True,
    )
    def download_file(_):
        """Serve a file
    
        Args:
            _ : not use
    
        Returns:
            the file
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(pdf_name) as f:
            file = f.read()
        return dcc.send_bytes(file, pdf_name[1:])
    

Code 3.2: Serving a file
    
    
    html.Div([html.P([
        "For downloading a file, you should use the html.Download, and a button to activate the download"]),
        html.Button("Get the file", className="btn btn-primary",
                    id="btnImageManagedFolder"),
        dcc.Download(id="downloadManagedFolder")])),
    

Code 3.1: Serve a file from a managed folder
    
    
    import streamlit as st
    import dataiku
    
    
    def get_file_content_from_managed_folder(folder_name, file_name):
        """
        Retrieves the content of a file from a managed folder, as bytes
    
        Args:
            folder_name: name of the folder to retrieve the file from
            file_name: name of the file to retrieve
    
        Returns:
            the file content, as bytes
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return f.read()
    
    
    folder = "Resources"
    
    st.write("### Serve a file")
    st.download_button(
        "Get the PDF from managed folder", 
        data=get_file_content_from_managed_folder(folder, "file.pdf"),
        file_name="file.pdf"
    )
    

Code 3.1: Serving a file – Helper function
    
    
    import streamlit as st
    import dataiku
    import io
    import logging
    
    logger = logging.getLogger(__name__)
    
    host = "http://<dataikuURL>:<port>/"
    folder = "Resources"
    image = "/image.jpg"
    pdf = "/file.pdf"
    css = "/my-css.css"
    
    
    def get_file_from_managed_folder(folder_name, file_name):
        """
        Retrieves a file from a managed folder
    
        :param folder_name: name of the folder to retrieve the file from
        :param file_name: name of the file to retrieve
        Returns:
            the file.
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return (f.read())
    
    

Code 3.2: Serving a file
    
    
    with st.container():
        st.write("### Serving a file")
        st.download_button("Get the PDF", data=get_file_from_managed_folder(folder, pdf), file_name=pdf)
    

#### Using your own CSS

If you need to use your own CSS, apply the same principle as in Serving a file.

StandardDashStreamlitStreamlit (Code Studio)

Code 4.1 (part a): Declare your intention to use a personal CSS (HTML part)
    
    
    <link href="" rel="stylesheet" id="getCSSFromManagedFolder">
    

Code 4.1 (part b): Use your personal CSS (HTML part)
    
    
    <p>The image <span class="devadvocate-alert">is loaded</span> within the javascript code</p>
    

Code 4.2: Using your own CSS (Javascript part)
    
    
    let getCSSFromManagedFolder      = document.getElementById('getCSSFromManagedFolder')
    
    
    getCSSFromManagedFolder.href     = getWebAppBackendUrl('/get_css_from_managed_folder')
    

Code 4.3: Using your own CSS (Backend)
    
    
    def get_file_from_managed_folder(folder_name, file_name):
        """
        Retrieve the file from the managed folder
        Args:
            folder_name: name of the managed folder
            file_name: name of the file
    
        Returns:
            the file
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return (f.read())
    
    @app.route('/get_css_from_managed_folder')
    def get_css_from_managed_folder():
        return get_file_from_managed_folder(folder, css)
    

You can’t use a defined CSS in a managed folder in a Dash web application. If you want to use your own CSS, configure the `app.config.external_stylesheets`.

Streamlit’s recommended approach to styling and theming is to use the application configuration, which contains rich theme definitions. However, if you want to use your own CSS, you can inject it using the `st.markdown` function.

Code 4.5: Use CSS from a managed folder
    
    
    import streamlit as st
    import dataiku
    
    
    def get_file_content_from_managed_folder(folder_name, file_name):
        """
        Retrieves the content of a file from a managed folder, as bytes
    
        Args:
            folder_name: name of the folder to retrieve the file from
            file_name: name of the file to retrieve
    
        Returns:
            the file content, as bytes
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return f.read()
    
    
    folder = "Resources"
    
    st.write("### Display an image")
    st.image(get_file_content_from_managed_folder(folder, "image.jpg"))
    st.write("### Use your own CSS")
    # this assumes that you have created "my-css.css" in your managed folder 
    # defining a style for .stMarkdown p.my-stylish-text
    css = get_file_content_from_managed_folder(folder, "my-css.css").decode("utf-8")
    st.markdown(f"<style>{css}</style>", unsafe_allow_html=True)
    st.markdown(
        '<p class="my-stylish-text">Style this text!</p>',
        unsafe_allow_html=True
    )
    

You can’t use a defined CSS in a managed folder in a Streamlit (Code Studio) web application.

Streamlit’s recommended approach to styling and theming is to use the application configuration, which contains rich theme definitions. If you want to use your own CSS, you can include it in the `body` passed to `st.markdown`.

### Using resources stored in resources in project library

If you want to store resources specific to a project, need the user to be authenticated and do not want to create a managed folder, you can rely on resources stored in the project library. Go to **< /> > Libraries** and click on the **Resources** tab. Then create a `static` directory. Once the directory has been created, upload your files in this folder. All files in this folder will be accessible, by authenticated user, via the URL: `http[s]://host:port/local/projects/PROJECT_KEY/resources/`.

Alternatively, if you want to store project-related resources that are meant to be accessible to any unauthenticated user, you can create a `local-static` directory and upload your files in it. The files in this folder will be publicly accessible via the URL: `http[s]://host:port/local/projects/PROJECT_KEY/public-resources/`

#### Displaying an image

StandardDashStreamlitStreamlit (Code Studio)

Code 4.1: Use the `img` tag
    
    
    <img id="getImageFromProjectLibImg" alt="image" class="container"></img>
    

Code 4.2: Javascript for dynamically load the image
    
    
    let getImageFromProjectLibImg    = document.getElementById('getImageFromProjectLibImg')
    
    
    getImageFromProjectLibImg.src  = `/local/projects/${dataiku.defaultProjectKey}/resources/image.jpg`
    

Code 4.1: Use the `html.Img` element
    
    
    html.Div([html.Div(
        ["You use images coming from resources in the project library by using the classical:",
         html.Code("""html.Img(src="URLOfTheResources", alt="Alternate text)""")]),
        html.Img(
            src=f"/local/projects/{dataiku.default_project_key()}/resources/image.jpg"),
    ])
    

Code 4.1: display an image from project resources
    
    
    import streamlit as st
    import dataiku
    import requests
    
    
    def get_project_resource_url(file, host=None):
        """
        Returns the url of a file stored in project resources
    
        Args:
            file: relative path from the root of project resources
            host: the base URL to use. If None, the current HTTP Origin is used.
    
        Returns:
            URL to the specified project resource file
        """
        if host is None:
            host = st.context.headers.get("Origin", "")
        return f"{host}/local/projects/{dataiku.default_project_key()}/resources/{file}"
    
    
    st.write("### Display an image")
    image_url = get_project_resource_url("image.jpg")
    image_bytes = requests.get(image_url, cookies=st.context.cookies).content
    st.image(image_bytes, caption=image_url, output_format="JPEG")
    

Code 4.1: Use the st.image element
    
    
    with st.container():
        st.write("### Display an image (using URL)")
        st.image(f"{host}/local/projects/{dataiku.api_client().get_default_project().project_key}/resources/image.jpg")
    

#### Serving a file

Serving a file for an end-user relies on the same principle. Except you don’t display it.

StandardDashStreamlitStreamlit (Code Studio)

Code 5.1: Serving a file (HTML part)
    
    
    <p>The pdf link is updated within the javascript code</p>
    <a id="getPDFFromProjectLibA" href="" download="file.pdf">
        <span id="getPDFFromProjectLib" onclick="" class="btn btn-primary">Get PDF file</span>
    </a>
    

Code 5.2: Serving a file (Javascript part)
    
    
    let getPDFFromProjectLibA        = document.getElementById('getPDFFromProjectLibA')
    
    
    getPDFFromProjectLibA.href     = `/local/projects/${dataiku.defaultProjectKey}/resources/file.pdf`
    

Code 5.1: Serving a file
    
    
    html.Div([html.P(
        "To be able to use the resources folder in project library, you need to fallback to the usage of the A tag. "),
        html.A(children=[
            html.Span("Get the PDF", className="btn btn-primary")
        ], href=f"/local/projects/{dataiku.default_project_key()}/resources/file.pdf",
            download="file.pdf")])),
    

Code 5.1: Serve a file from project resources
    
    
    import streamlit as st
    import dataiku
    import requests
    
    
    def get_project_resource_url(file, host=None):
        """
        Returns the url of a file stored in project resources
    
        Args:
            file: relative path from the root of project resources
            host: the base URL to use. If None, the current HTTP Origin is used.
    
        Returns:
            URL to the specified project resource file
        """
        if host is None:
            host = st.context.headers.get("Origin", "")
        return f"{host}/local/projects/{dataiku.default_project_key()}/resources/{file}"
    
    
    st.write("### Serve a file")
    file_url = get_project_resource_url("file.pdf")
    st.download_button(
        "Get the PDF from project resources", 
        data=requests.get(file_url, cookies=st.context.cookies).content, 
        file_name="file.pdf"
    )
    

Code 5.1: Serving a file
    
    
    with st.container():
        st.write("### Serving a file")
        with open('../../project-lib-resources/static/file.pdf', 'rb') as f:
            st.download_button("Get the PDF", data=io.BytesIO(f.read()), file_name="file.pdf", key="download_button")
    

#### Using your own CSS

If you need to use your own CSS, apply the same principle as in Serving a file.

StandardDashStreamlitStreamlit (Code Studio)

Code 6.1 (part a): Declare your intention to use a personal CSS (HTML part)
    
    
    <link href="" rel="stylesheet" id="getCSSFromProjectLib">
    

Code 6.1 (part b): Use your personal CSS (HTML part)
    
    
    <p>The image <span class="devadvocate-alert">is loaded</span> within the javascript code</p>
    

Code 6.2: Using your own CSS (Javascript part)
    
    
    let getCSSFromProjectLib         = document.getElementById('getCSSFromProjectLib')
    
    
    getCSSFromProjectLib.href      = `/local/projects/${dataiku.defaultProjectKey}/resources/my-css.css`
    

You simply need to adapt the `app.config.external_stylesheets` to your needs.

Code 6.1: Using you own CSS
    
    
    app.config.external_stylesheets = ["https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/css/bootstrap.min.css",
                                       "/local/static/my-css.css",
                                       f"/local/projects/{dataiku.default_project_key()}/resources/my-css.css"
                                       ]
    

Streamlit’s recommended approach to styling and theming is to use the application configuration, which contains rich theme definitions. However, if you want to use your own CSS, you can inject it using `st.markdown` function. Note that in order to access protected project assets via a URL, The request needs to be authenticated. This can be done by reusing cookies from the current request via `st.context.headers`.

Code 6.1: Use CSS from project resources
    
    
    import streamlit as st
    import dataiku
    import requests
    
    
    def get_project_resource_url(file, host=None):
        """
        Returns the url of a file stored in project resources
    
        Args:
            file: relative path from the root of project resources
            host: the base URL to use. If None, the current HTTP Origin is used.
    
        Returns:
            URL to the specified project resource file
        """
        if host is None:
            host = st.context.headers.get("Origin", "")
        return f"{host}/local/projects/{dataiku.default_project_key()}/resources/{file}"
    
    
    st.write("### Use your own CSS")
    css_url = get_project_resource_url("my-css.css")
    css = requests.get(css_url, cookies=st.context.cookies).text
    st.markdown(f'<style>{css}</style>', unsafe_allow_html=True)
    st.markdown(
        '<p class="my-stylish-text-project-resources">Style this text!</p>',
        unsafe_allow_html=True
    )
    

You can’t use a defined CSS in the project library.

Streamlit’s recommended approach to styling and theming is to use the application configuration, which contains rich theme definitions. If you want to use your own CSS, you can include it in the `body` passed to `st.markdown`.

### Internal resources stored in the global shared code

If you want to store resources instance-wide and use them in a web app, consider storing them in the Global shared code. To store files in the Global shared code, click on **Application menu > Global shared code > Static web resources**. Save your files in the `local-static` folder, as shown in Figure 1. Once your files are uploaded to this folder, they will be accessible using the URL: `{HOSTNAME}:{PORT}/local/static/...`. So, all the codes using these resources are straightforward.

Important

The primary purpose of **Static web resources** is to serve files for public web applications, but they can also be used to store files for authenticated web applications. However, all files stored in this storage will be accessible without authentication.

Figure 1: Adding files to the Static Web Resources

#### Displaying an image

StandardDashStreamlitStreamlit (Code Studio)

Code 7.1: Use the `img` tag
    
    
    <img alt="image" src="/local/static/image.jpg" class="container"></img>
    

Code 7.1: Use the `html.Img` element
    
    
    html.Div([html.Div([
        "You can use images coming from the Global shared Code by using the classical path ('/local/static/...') ",
        html.Code('html.Img(src="URL_TO_USE", alt="Alternate text")')]),
        html.Img(src="/local/static/image.jpg", alt="Image to display",
                 className="container")])),
    

Code 7.1: display a global shared image
    
    
    import streamlit as st
    import requests
    import urllib.request
    import io
    
    def get_global_shared_file_url(file, host=None):
        """
        Returns the url of a file stored in global shared code.
    
        Args:
            file: relative path from the root of global shared code
            host: base URL to use. If None, the current HTTP Origin is used.
    
        Returns:
            URL to the global shared file
        """
        if host is None:
            host = st.context.headers.get("Origin", "")
        return f"{host}/local/static/{file}"
    
    
    st.write("### Display an image")
    image_url = get_global_shared_file_url("image.jpg")
    st.image(image_url, caption=image_url)
    

Code 7.1: Access to the static web resources – Helper function
    
    
    def get_global_shared_file_url(file):
        """
        Retrieves a file from the static web resources
        Args:
            file: the file to retrieve.
    
        Returns:
            the URL to the static web resources file
        """
        return host + '/local/static/' + file
    

Code 7.2: Access to the static web resources
    
    
    with st.container():
        st.write("### Display an image")
        st.image(get_global_shared_file_url(image))
    

#### Serving a file

If you need the user to be able to download the image, you can rely on the `download` attribute of the `a` tag.

StandardDashStreamlitStreamlit (Code Studio)

Code 8.1: Serving a file
    
    
    <a href="/local/static/image.jpg" download="image.jpg">
        <img src="/local/static/image.jpg" alt="image" class="container"></img>
    </a>
    

Code 8.1 : Serving a file
    
    
    html.Div([html.P(
        "To be able to use the global shared code folder, you need to fallback to the usage of the A tag. "),
        html.A(children=[
            html.Span("Get the PDF", className="btn btn-primary")
        ], href="/static/local/file.pdf", download="file.pdf")])),
    

Code 8.1: Serve a file from global shared code
    
    
    import streamlit as st
    import requests
    import urllib.request
    import io
    
    def get_global_shared_file_url(file, host=None):
        """
        Returns the url of a file stored in global shared code.
    
        Args:
            file: relative path from the root of global shared code
            host: base URL to use. If None, the current HTTP Origin is used.
    
        Returns:
            URL to the global shared file
        """
        if host is None:
            host = st.context.headers.get("Origin", "")
        return f"{host}/local/static/{file}"
    
    
    st.write("### Serve a file")
    with urllib.request.urlopen(get_global_shared_file_url("file.pdf")) as f:
        st.download_button(
            "Download from global shared code", 
            data=io.BytesIO(f.read()), 
            file_name="file.pdf"
        )
    

Code 8.1: Serving a file – Helper function
    
    
    def get_global_shared_file_url(file):
        """
        Retrieves a file from the static web resources
        Args:
            file: the file to retrieve.
    
        Returns:
            the URL to the static web resources file
        """
        return host + '/local/static/' + file
    

Code 8.2: Serving a file
    
    
    with st.container():
        st.write("### Serving a file")
        st.download_button("Get the PDF", data=get_global_shared_file_url(pdf), file_name=pdf)
    

#### Using your own CSS

If you need to use your own CSS, apply the same principle as in Serving a file.

StandardDashStreamlitStreamlit (Code Studio)

Code 9.1: Using your own CSS
    
    
    <link href="/local/static/my-css.css" rel="stylesheet">
    <p>The image <span class="devadvocate-alert">is loaded</span> within the javascript code</p>
    

You simply need to adapt the `app.config.external_stylesheets` to your needs.

Code 9.1: Using you own CSS
    
    
    app.config.external_stylesheets = ["https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/css/bootstrap.min.css",
                                       "/local/static/my-css.css",
                                       f"/local/projects/{dataiku.default_project_key()}/resources/my-css.css"
                                       ]
    

Streamlit’s recommended approach to styling and theming is to use the application configuration, which contains rich theme definitions. However, if you want to use your own CSS, you can inject it using the `st.markdown` function.

Code 9.1: Use CSS from global shared code
    
    
    import streamlit as st
    import requests
    import urllib.request
    import io
    
    def get_global_shared_file_url(file, host=None):
        """
        Returns the url of a file stored in global shared code.
    
        Args:
            file: relative path from the root of global shared code
            host: base URL to use. If None, the current HTTP Origin is used.
    
        Returns:
            URL to the global shared file
        """
        if host is None:
            host = st.context.headers.get("Origin", "")
        return f"{host}/local/static/{file}"
    
    
    st.write("### Use your own CSS")
    # this assumes that you have created "my-css.css" in global shared code
    # defining a style for .stMarkdown p.my-stylish-text
    css_url = get_global_shared_file_url("my-css.css")
    css = requests.get(css_url).text
    st.markdown(f'<style>{css}</style>', unsafe_allow_html=True)
    st.markdown(
        '<p class="my-stylish-text">Style this text!</p>',
        unsafe_allow_html=True
    )
    

You can’t use a defined CSS in a global shared code in a Streamlit web application.

### Using resources stored in the Code Studios

Code Studios does not allow editing Standard, Dash, and Bokeh web applications. Code Studios resources are stored inside the container, so to access a file in the resources, you need to fall back to classical file system operation. Depending on where the user stores its files, they will appear in different directories in Code Studio. Accessing to those files will remain the same regardless of the directory.

#### Displaying an image

StandardDashStreamlit

Not available

Not available

Code 10: Using an image
    
    
    with st.container():
        st.write("### Display an image")
        with open('../../code_studio-resources/image.jpg', 'rb') as f:
            st.image(image=io.BytesIO(f.read()))
    

#### Serving a file

Serving a file for an end-user relies on the same principle. Except you don’t display it.

StandardDashStreamlit

Not available

Not available

Code 11: Serving a file
    
    
    with st.container():
        st.write("### Serving a file")
        with open('../../code_studio-resources/file.pdf', 'rb') as f:
            st.download_button("Get the PDF", data=io.BytesIO(f.read()), file_name="file.pdf")
    

#### Using your own CSS

If you need to use your own CSS, apply the same principle as in Serving a file.

StandardDashStreamlit

Not available

Not available

Not available

## Complete code and conclusion

Code 12 shows the complete code for using resources when developing web applications. This tutorial presents best practices for data storage according to your use case.

StandardDashStreamlitStreamlit (Code Studio)

You will find the complete code for standard web application

Code 12: Code for standard web application (HTML part)
    
    
    <script src="https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
            crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="" rel="stylesheet" id="getCSSFromManagedFolder">
    <link href="" rel="stylesheet" id="getCSSFromProjectLib">
    
    <h1 class="display-1">Using resources in a web application</h1>
    <p>Some code samples to demonstrate how we can use resources in web applications</p>
    <div class="container">
        <h2 class="" dispaly-2>From external URL</h2>
        <div class="accordion" id="externalURL">
            <div class="accordion-item">
                <h2 class="accordion-header" id="headingExternalURL">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseExternalURL"
                            aria-expanded="false" aria-controls="collapseExternalURL">
                        Image
                    </button>
                </h2>
                <div id="collapseExternalURL" class="accordion-collapse collapse" aria-labelledby="headingExternalURL"
                     data-bs-parent="#externalURL">
                    <div class="accordion-body">
                        <p>You can use images comming from an URL by using the classical
                            <code>&lt;img scr="URL_TO_USE" alt="Description"/&gt;</code>
                        </p>
                        <img src="https://picsum.photos/200/300" alt="Random picture from the internet"></img>
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion" id="externalURLJs">
            <div class="accordion-item">
                <h2 class="accordion-header" id="headingExternalURLJs">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseExternalURLJs"
                            aria-expanded="false" aria-controls="collapseExternalURLJs">
                        Fetching resources from javascript
                    </button>
                </h2>
                <div id="collapseExternalURLJs" class="accordion-collapse collapse" aria-labelledby="headingExternalURLJs"
                     data-bs-parent="#externalURLJs">
                    <div class="accordion-body">
                        <p>Or you can use Javascript to fetch resources.</p>
                        <img src="" alt="Random picture from the internet" id="externalImageJs"></img>
                    </div>
                </div>
            </div>
        </div>
    
    
        <h2>From managed folders</h2>
    
        <div class="accordion" id="accordion-managed-folder">
            <div class="accordion-item">
                <h2 class="accordion-header" id="displayInline">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapsedisplayInline"
                            aria-expanded="false" aria-controls="collapsedisplayInline">
                        Display an image
                    </button>
                </h2>
                <div id="collapsedisplayInline" class="accordion-collapse collapse" aria-labelledby="displayInline"
                     data-bs-parent="#accordion-managed-folder">
                    <div class="accordion-body">
                        <p>The image is loaded within the javascript code</p>
                        <img id="getImageFromManageFolderImg" alt="image" class="container"></img>
                    </div>
                </div>
            </div>
    
            <div class="accordion-item">
                <h2 class="accordion-header" id="displayAndDownloadInline">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapsedisplayAndDownloadInline" aria-expanded="false"
                            aria-controls="collapsedisplayAndDownloadInline">
                        Display an image and allow this image to be downloaded by clicking on it
                    </button>
                </h2>
                <div id="collapsedisplayAndDownloadInline" class="accordion-collapse collapse"
                     aria-labelledby="displayAndDownloadInline" data-bs-parent="#accordion-managed-folder">
                    <div class="accordion-body">
                        <p>The image is loaded within the javascript code</p>
                        <a id="getImageFromManageFolderA" href="" download="image.png">
                            <img id="getImageFromManageFolderAImg" alt="image" class="container"></img>
                        </a>
                    </div>
                </div>
            </div>
    
            <div class="accordion-item">
                <h2 class="accordion-header" id="DownloadPdfInline">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseDownloadPdfInline" aria-expanded="false"
                            aria-controls="collapseDownloadPdfInline">
                        PDF
                    </button>
                </h2>
                <div id="collapseDownloadPdfInline" class="accordion-collapse collapse" aria-labelledby="DownloadPdfInline"
                     data-bs-parent="#accordion-managed-folder">
                    <div class="accordion-body">
                        <p>The image is loaded within the javascript code</p>
                        <a id="getPDFFromManagedFolderA" href="" download="file.pdf">
                            <span id="getPDFFromManagedFolder" onclick="" class="btn btn-primary">Get PDF file</span>
                        </a>
                    </div>
                </div>
            </div>
    
            <div class="accordion-item">
                <h2 class="accordion-header" id="DownloadCSSInline">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseDownloadCSSInline" aria-expanded="false"
                            aria-controls="collapseDownloadCSSInline">
                        Local CSS
                    </button>
                </h2>
                <div id="collapseDownloadCSSInline" class="accordion-collapse collapse" aria-labelledby="DownloadCSSInline"
                     data-bs-parent="#accordion-managed-folder">
                    <div class="accordion-body">
                        <p>The image <span class="devadvocate-alert">is loaded</span> within the javascript code</p>
                    </div>
                </div>
            </div>
        </div>
    
        <h2>From resources in project library </h2>
    
        <div class="accordion" id="accordion-project-lib">
            <div class="accordion-item">
                <h2 class="accordion-header" id="displayInlineProjectLib">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapsedisplayInlineProjectLib"
                            aria-expanded="false" aria-controls="collapsedisplayInlineProjectLib">
                        Display an image
                    </button>
                </h2>
                <div id="collapsedisplayInlineProjectLib" class="accordion-collapse collapse" aria-labelledby="displayInlineProjectLib"
                     data-bs-parent="#accordion-project-lib">
                    <div class="accordion-body">
                        <p>The image is loaded within the javascript code</p>
                        <img id="getImageFromProjectLibImg" alt="image" class="container"></img>
                    </div>
                </div>
            </div>
    
            <div class="accordion-item">
                <h2 class="accordion-header" id="displayAndDownloadInlineProjectLib">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapsedisplayAndDownloadInlineProjectLib" aria-expanded="false"
                            aria-controls="collapsedisplayAndDownloadInlineProjectLib">
                        Display an image and allow this image to be downloaded by clicking on it
                    </button>
                </h2>
                <div id="collapsedisplayAndDownloadInlineProjectLib" class="accordion-collapse collapse"
                     aria-labelledby="displayAndDownloadInline" data-bs-parent="#accordion-project-lib">
                    <div class="accordion-body">
                        <p>The image is loaded within the javascript code</p>
                        <a id="getImageFromProjectLibA" href="" download="image.png">
                            <img id="getImageFromProjectLibAImg" alt="image" class="container"></img>
                        </a>
                    </div>
                </div>
            </div>
    
            <div class="accordion-item">
                <h2 class="accordion-header" id="DownloadPdfInlineProjectLib">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseDownloadPdfInlineProjectLib" aria-expanded="false"
                            aria-controls="collapseDownloadPdfInlineProjectLib">
                        PDF
                    </button>
                </h2>
                <div id="collapseDownloadPdfInlineProjectLib" class="accordion-collapse collapse" aria-labelledby="DownloadPdfInline"
                     data-bs-parent="#accordion-project-lib">
                    <div class="accordion-body">
                        <p>The pdf link is updated within the javascript code</p>
                        <a id="getPDFFromProjectLibA" href="" download="file.pdf">
                            <span id="getPDFFromProjectLib" onclick="" class="btn btn-primary">Get PDF file</span>
                        </a>
                    </div>
                </div>
            </div>
    
            <div class="accordion-item">
                <h2 class="accordion-header" id="DownloadCSSInlineProjectLib">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseDownloadCSSInlineProjectLib" aria-expanded="false"
                            aria-controls="collapseDownloadCSSInlineProjectLib">
                        Local CSS
                    </button>
                </h2>
                <div id="collapseDownloadCSSInlineProjectLib" class="accordion-collapse collapse" aria-labelledby="DownloadCSSInline"
                     data-bs-parent="#accordion-project-lib">
                    <div class="accordion-body">
                        <p>The image <span class="devadvocate-alert2">is loaded</span> within the javascript code</p>
                    </div>
                </div>
            </div>
        </div>
    
        <h2>Global shared Code (Static Web resources)</h2>
        <div class="accordion" id="accordion-global-share-code">
            <div class="accordion-item">
                <h2 class="accordion-header" id="globalDisplayInline">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseglobalDisplayInline" aria-expanded="false"
                            aria-controls="collapseglobalDisplayInline">
                        Display an image
                    </button>
                </h2>
                <div id="collapseglobalDisplayInline" class="accordion-collapse collapse"
                     aria-labelledby="globalDisplayInline"
                     data-bs-parent="#accordion-global-share-code">
                    <div class="accordion-body">
                        <img alt="image" src="/local/static/image.jpg" class="container"></img>
                    </div>
                </div>
            </div>
    
            <div class="accordion-item">
                <h2 class="accordion-header" id="globalDisplayAndDownloadInline">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#globalDollapsedisplayAndDownloadInline" aria-expanded="false"
                            aria-controls="globalDollapsedisplayAndDownloadInline">
                        Display an image and allow this image to be downloaded by clicking on it
                    </button>
                </h2>
                <div id="globalDollapsedisplayAndDownloadInline" class="accordion-collapse collapse"
                     aria-labelledby="globalDisplayAndDownloadInline" data-bs-parent="#accordion-global-share-code">
                    <div class="accordion-body">
                        <a href="/local/static/image.jpg" download="image.jpg">
                            <img src="/local/static/image.jpg" alt="image" class="container"></img>
                        </a>
                    </div>
                </div>
            </div>
    
    
            <div class="accordion-item">
                <h2 class="accordion-header" id="globalDownloadPdfInline">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseglobalDownloadPdfInline" aria-expanded="false"
                            aria-controls="collapseglobalDownloadPdfInline">
                        PDF
                    </button>
                </h2>
                <div id="collapseglobalDownloadPdfInline" class="accordion-collapse collapse"
                     aria-labelledby="globalDownloadPdfInline" data-bs-parent="#accordion-global-share-code">
                    <div class="accordion-body">
                        <a href="/local/static/file.pdf" download="file.pdf">
                            <span class="btn btn-primary">Get PDF file</span>
                        </a>
                    </div>
                </div>
            </div>
    
            <div class="accordion-item">
                <h2 class="accordion-header" id="globalDownloadCSSInline">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapseglobalDownloadCSSInline" aria-expanded="false"
                            aria-controls="collapseglobalDownloadCSSInline">
                        Local CSS
                    </button>
                </h2>
                <div id="collapseglobalDownloadCSSInline" class="accordion-collapse collapse"
                     aria-labelledby="globalDownloadCSSInline" data-bs-parent="#accordion-global-share-code">
                    <div class="accordion-body">
                        <link href="/local/static/my-css.css" rel="stylesheet">
                        <p>The image <span class="devadvocate-alert">is loaded</span> within the javascript code</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    

Code 12.1: Code for standard web application (Javascript part)
    
    
    let getImageFromManageFolderA    = document.getElementById('getImageFromManageFolderA')
    let getImageFromManageFolderImg  = document.getElementById('getImageFromManageFolderImg')
    let getImageFromManageFolderAImg = document.getElementById('getImageFromManageFolderAImg')
    let getPDFFromManagedFolder      = document.getElementById('getPDFFromManagedFolder')
    let getPDFFromManagedFolderA     = document.getElementById('getPDFFromManagedFolderA')
    let getCSSFromManagedFolder      = document.getElementById('getCSSFromManagedFolder')
    
    let getImageFromProjectLibImg    = document.getElementById('getImageFromProjectLibImg')
    let getImageFromProjectLibA      = document.getElementById('getImageFromProjectLibA')
    let getImageFromProjectLibAImg   = document.getElementById('getImageFromProjectLibAImg')
    let getPDFFromProjectLibA        = document.getElementById('getPDFFromProjectLibA')
    let getCSSFromProjectLib         = document.getElementById('getCSSFromProjectLib')
    
    // Dynamic setting of the various element
    getCSSFromManagedFolder.href     = getWebAppBackendUrl('/get_css_from_managed_folder')
    getImageFromManageFolderA.href   = getWebAppBackendUrl('/get_image_from_managed_folder')
    getImageFromManageFolderImg.src  = getWebAppBackendUrl('/get_image_from_managed_folder')
    getImageFromManageFolderAImg.src = getWebAppBackendUrl('/get_image_from_managed_folder')
    getPDFFromManagedFolderA.href    = getWebAppBackendUrl('/get_pdf_from_managed_folder')
    
    getImageFromProjectLibImg.src  = `/local/projects/${dataiku.defaultProjectKey}/resources/image.jpg`
    getImageFromProjectLibA.href   = `/local/projects/${dataiku.defaultProjectKey}/resources/image.jpg`
    getImageFromProjectLibAImg.src = `/local/projects/${dataiku.defaultProjectKey}/resources/image.jpg`
    getPDFFromProjectLibA.href     = `/local/projects/${dataiku.defaultProjectKey}/resources/file.pdf`
    getCSSFromProjectLib.href      = `/local/projects/${dataiku.defaultProjectKey}/resources/my-css.css`
    
    
    //
    getPDFFromManagedFolder.addEventListener('click', () => {
        getWebAppBackendUrl('/get_pdf_from_managed_folder')
    });
    
    /* Javascript function for external URL */
    let externalImageJs = document.getElementById('externalImageJs')
    
    fetch("https://picsum.photos/200/300")
        .then(response => response.blob())
        .then(image => externalImageJs.src = URL.createObjectURL(image))
    

Code 12.2: Code for standard web application (Python part)
    
    
    import dataiku
    import pandas as pd
    from flask import request
    
    # Definition of the various resources (This can be done programmatically)
    # ## Name of the managed folder
    folder = "Resources"
    # ## Path name of the files
    image = "/image.png"
    pdf = "/document.pdf"
    css = "/my-css.css"
    
    
    def get_file_from_managed_folder(folder_name, file_name):
        """
        Retrieve the file from the managed folder
        Args:
            folder_name: name of the managed folder
            file_name: name of the file
    
        Returns:
            the file
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return (f.read())
    
    @app.route('/get_image_from_managed_folder')
    def get_image_from_managed_folder():
        return get_file_from_managed_folder(folder, image)
    
    @app.route('/get_pdf_from_managed_folder')
    def get_pdf_from_managed_folder():
        return get_file_from_managed_folder(folder, pdf)
    
    @app.route('/get_css_from_managed_folder')
    def get_css_from_managed_folder():
        return get_file_from_managed_folder(folder, css)
    
    

Code 12: Code for Dash web application
    
    
    import dash
    from dash import html
    from dash import dcc
    from dash.dependencies import Input
    from dash.dependencies import Output
    import dataiku
    import base64
    
    import logging
    
    logger = logging.getLogger(__name__)
    
    folder_name = "Resources"
    image_name = "/image.png"
    pdf_name = "/document.pdf"
    css_name = "/my-css.css"
    
    # use the style of examples on the Plotly documentation
    app.config.external_scripts = ["https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/js/bootstrap.bundle.min.js"]
    app.config.external_stylesheets = ["https://cdn.jsdelivr.net/npm/[[email protected]](</cdn-cgi/l/email-protection>)/dist/css/bootstrap.min.css",
                                       "/local/static/my-css.css",
                                       f"/local/projects/{dataiku.default_project_key()}/resources/my-css.css"
                                       ]
    
    
    def make_accordion_item(parent_name, name, title, content):
        """ Helper to make an accordion object
    
        Args:
            parent_name (str): id of the accordion parent
            name (str): name of the accordion (must be unique)
            title (str): title for the accordion item
            content (object): the content of the accordion
    
        Returns:
            an html.Div containing the accordion item
        """
        return html.Div([
            html.H2([html.Button([title],
                                 className="accordion-button", type="button",
                                 **{"data-bs-toggle": "collapse", "data-bs-target": f"#collapse{name}",
                                    "aria-expanded": "false", "aria-controls": f"collapse{name}"}
                                 )], className="accordion-header", id=f"{name}"),
            html.Div([html.Div([content], className="accordion-body")],
                     id=f"collapse{name}", className="accordion-collapse collapse",
                     **{"aria-labelledby": f"{name}", "data-bs-parent": f"#{parent_name}"}
                     )], className="accordion-item")
    
    
    def get_image_from_managed_folder():
        """ Read a Png image and return the encoded version
    
        Returns:
            a base64 encoded image
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(image_name) as f:
            image = f.read()
        return 'data:image/png;base64,' + base64.b64encode(image).decode('utf-8')
    
    
    @app.callback(
        Output("downloadManagedFolder", "data"),
        Input("btnImageManagedFolder", "n_clicks"),
        prevent_initial_call=True,
    )
    def download_file(_):
        """Serve a file
    
        Args:
            _ : not use
    
        Returns:
            the file
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(pdf_name) as f:
            file = f.read()
        return dcc.send_bytes(file, pdf_name[1:])
    
    
    # build your Dash app
    app.layout = html.Div(children=[
        html.H2("From external resources", className="display-2"),
        html.Div([
            make_accordion_item('externalURL', 'displayImage', "Display an image",
                                html.Div([html.Div(["You can use images coming from an URL by using the classical ",
                                                    html.Code('html.Img(src="URL_TO_USE", alt="Alternate text")')]),
                                          html.Img(src="https://picsum.photos/200/300", alt="Image to display")])),
        ], className="accordion", id="externalURL"),
    
        html.H2("From managed folders", className="display-2"),
        html.Div([
            make_accordion_item('managedFolder', 'displayImageManagedFolder', "Display an image",
                                html.Div([html.Div([
                                    "You can use images coming from a managed folder by using the classical, in conjunction with a python funtion ",
                                    html.Code(
                                        'html.Img(src=function_that_returns_the_image, alt="Alternate text")')]),
                                    html.Img(src=get_image_from_managed_folder(), alt="Image to display",
                                             className="container")])),
            make_accordion_item('managedFolder', 'downloadFileManagedFolder', "Download a file",
                                html.Div([html.P([
                                    "For downloading a file, you should use the html.Download, and a button to activate the download"]),
                                    html.Button("Get the file", className="btn btn-primary",
                                                id="btnImageManagedFolder"),
                                    dcc.Download(id="downloadManagedFolder")])),
            make_accordion_item('managedFolder', 'cssFromManagedFolder', "Use your own CSS",
                                html.Div([html.P(["You can not use a CSS file defined in a managed folder"]),
                                          ])),
        ], className="accordion", id="managedFolder"),
    
        html.H2("From resources in project library ", className="display-2"),
        html.Div([
            make_accordion_item('projectLib', 'displayImageProjectLib', 'Display an image',
                                html.Div([html.Div(
                                    ["You use images coming from resources in the project library by using the classical:",
                                     html.Code("""html.Img(src="URLOfTheResources", alt="Alternate text)""")]),
                                    html.Img(
                                        src=f"/local/projects/{dataiku.default_project_key()}/resources/image.jpg"),
                                ])
                                ),
            make_accordion_item('projectLib', 'downloadFileProjectLib', 'Download a file',
                                html.Div([html.P(
                                    "To be able to use the resources folder in project library, you need to fallback to the usage of the A tag. "),
                                    html.A(children=[
                                        html.Span("Get the PDF", className="btn btn-primary")
                                    ], href=f"/local/projects/{dataiku.default_project_key()}/resources/file.pdf",
                                        download="file.pdf")])),
            make_accordion_item('projectLib', 'cssFromProjectLib', "Use your own CSS",
                                html.Div([html.P(
                                    ["You just need to adapt the app.config.external_stylesheets to your needs"],
                                    className="devadvocate-alert2"),
                                ])),
        ], className="accordion", id="projectLib"),
    
        html.H2("Global shared Code", className="display-2"),
        html.Div([
            make_accordion_item('managedFolder', 'displayImageGlobalSharedCode', "Display an image",
                                html.Div([html.Div([
                                    "You can use images coming from the Global shared Code by using the classical path ('/local/static/...') ",
                                    html.Code('html.Img(src="URL_TO_USE", alt="Alternate text")')]),
                                    html.Img(src="/local/static/image.jpg", alt="Image to display",
                                             className="container")])),
            make_accordion_item('managedFolder', 'downloadFileGlobalSharedCode', "Download a file",
                                html.Div([html.P(
                                    "To be able to use the global shared code folder, you need to fallback to the usage of the A tag. "),
                                    html.A(children=[
                                        html.Span("Get the PDF", className="btn btn-primary")
                                    ], href="/static/local/file.pdf", download="file.pdf")])),
            make_accordion_item('managedFolder', 'cssFromGlobalSharedCode', "Use your own CSS",
                                html.Div([html.P(
                                    ["You just need to adapt the app.config.external_stylesheets to your needs"],
                                    className="devadvocate-alert"),
                                ])),
        ], className="accordion", id="globalSharedCode")
    
    ], className="container")
    

Code 12.1: Code for Streamlit web application using an external URL
    
    
    import streamlit as st
    
    with st.container():
        st.write("### Display an image")
        st.image("https://picsum.photos/200", caption="From https://picsum.photos/")
    
    

Code 12.2: Code for Streamlit web application using managed folder assets
    
    
    import streamlit as st
    import dataiku
    
    
    def get_file_content_from_managed_folder(folder_name, file_name):
        """
        Retrieves the content of a file from a managed folder, as bytes
    
        Args:
            folder_name: name of the folder to retrieve the file from
            file_name: name of the file to retrieve
    
        Returns:
            the file content, as bytes
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return f.read()
    
    
    folder = "Resources"
    
    st.write("### Display an image")
    st.image(get_file_content_from_managed_folder(folder, "image.jpg"))
    
    st.write("### Serve a file")
    st.download_button(
        "Get the PDF from managed folder", 
        data=get_file_content_from_managed_folder(folder, "file.pdf"),
        file_name="file.pdf"
    )
    
    st.write("### Use your own CSS")
    # this assumes that you have created "my-css.css" in your managed folder 
    # defining a style for .stMarkdown p.my-stylish-text
    css = get_file_content_from_managed_folder(folder, "my-css.css").decode("utf-8")
    st.markdown(f"<style>{css}</style>", unsafe_allow_html=True)
    st.markdown(
        '<p class="my-stylish-text">Style this text!</p>',
        unsafe_allow_html=True
    )
    
        
    

Code 12.3: Code for Streamlit web application using project resources
    
    
    import streamlit as st
    import dataiku
    import requests
    
    
    def get_project_resource_url(file, host=None):
        """
        Returns the url of a file stored in project resources
    
        Args:
            file: relative path from the root of project resources
            host: the base URL to use. If None, the current HTTP Origin is used.
    
        Returns:
            URL to the specified project resource file
        """
        if host is None:
            host = st.context.headers.get("Origin", "")
        return f"{host}/local/projects/{dataiku.default_project_key()}/resources/{file}"
    
    
    st.write("### Display an image")
    image_url = get_project_resource_url("image.jpg")
    image_bytes = requests.get(image_url, cookies=st.context.cookies).content
    st.image(image_bytes, caption=image_url, output_format="JPEG")
    
    st.write("### Serve a file")
    file_url = get_project_resource_url("file.pdf")
    st.download_button(
        "Get the PDF from project resources", 
        data=requests.get(file_url, cookies=st.context.cookies).content, 
        file_name="file.pdf"
    )
    
    st.write("### Use your own CSS")
    css_url = get_project_resource_url("my-css.css")
    css = requests.get(css_url, cookies=st.context.cookies).text
    st.markdown(f'<style>{css}</style>', unsafe_allow_html=True)
    st.markdown(
        '<p class="my-stylish-text-project-resources">Style this text!</p>',
        unsafe_allow_html=True
    )
    

Code 12.4: Code for Streamlit web application using global shared code
    
    
    import streamlit as st
    import requests
    import urllib.request
    import io
    
    def get_global_shared_file_url(file, host=None):
        """
        Returns the url of a file stored in global shared code.
    
        Args:
            file: relative path from the root of global shared code
            host: base URL to use. If None, the current HTTP Origin is used.
    
        Returns:
            URL to the global shared file
        """
        if host is None:
            host = st.context.headers.get("Origin", "")
        return f"{host}/local/static/{file}"
    
    
    st.write("### Display an image")
    image_url = get_global_shared_file_url("image.jpg")
    st.image(image_url, caption=image_url)
    
    st.write("### Serve a file")
    with urllib.request.urlopen(get_global_shared_file_url("file.pdf")) as f:
        st.download_button(
            "Download from global shared code", 
            data=io.BytesIO(f.read()), 
            file_name="file.pdf"
        )
    
    st.write("### Use your own CSS")
    # this assumes that you have created "my-css.css" in global shared code
    # defining a style for .stMarkdown p.my-stylish-text
    css_url = get_global_shared_file_url("my-css.css")
    css = requests.get(css_url).text
    st.markdown(f'<style>{css}</style>', unsafe_allow_html=True)
    st.markdown(
        '<p class="my-stylish-text">Style this text!</p>',
        unsafe_allow_html=True
    )
    

Code 12: Code for Streamlit web application
    
    
    import streamlit as st
    import dataiku
    import io
    import logging
    
    logger = logging.getLogger(__name__)
    
    host = "http://<dataikuURL>:<port>/"
    folder = "Resources"
    image = "/image.jpg"
    pdf = "/file.pdf"
    css = "/my-css.css"
    
    
    def get_file_from_managed_folder(folder_name, file_name):
        """
        Retrieves a file from a managed folder
    
        :param folder_name: name of the folder to retrieve the file from
        :param file_name: name of the file to retrieve
        Returns:
            the file.
        """
        folder = dataiku.Folder(folder_name)
    
        with folder.get_download_stream(file_name) as f:
            return (f.read())
    
    
    def get_global_shared_file_url(file):
        """
        Retrieves a file from the static web resources
        Args:
            file: the file to retrieve.
    
        Returns:
            the URL to the static web resources file
        """
        return host + '/local/static/' + file
    
    
    st.title('Uses resources')
    st.markdown("""## From external URL""")
    with st.container():
        st.write("### Display an image")
        st.image("https://source.unsplash.com/random/1920x1080/?cat=")
    
    st.markdown("""## From managed folder""")
    with st.container():
        st.write("### Display an image")
        st.image(get_file_from_managed_folder(folder, image))
    
    with st.container():
        st.write("### Serving a file")
        st.download_button("Get the PDF", data=get_file_from_managed_folder(folder, pdf), file_name=pdf)
    
    with st.container():
        st.write("### Use your own CSS")
        st.write("At the moment, there's no easy way to add an id/class to a streamlit element. However, if you want to use CSS, simply load it like any other file.")
    
    st.markdown("""## From Global shared code""")
    
    with st.container():
        st.write("### Display an image")
        st.image(get_global_shared_file_url(image))
    
    with st.container():
        st.write("### Serving a file")
        st.download_button("Get the PDF", data=get_global_shared_file_url(pdf), file_name=pdf)
    
    with st.container():
        st.write("### Use your own CSS")
        st.write("At the moment, there's no easy way to add an id/class to a streamlit element. However, if you want to use CSS, simply load it like any other file.")
    
    st.markdown("""## From Code studios resources""")
    
    with st.container():
        st.write("### Display an image")
        with open('../../code_studio-resources/image.jpg', 'rb') as f:
            st.image(image=io.BytesIO(f.read()))
    
    with st.container():
        st.write("### Serving a file")
        with open('../../code_studio-resources/file.pdf', 'rb') as f:
            st.download_button("Get the PDF", data=io.BytesIO(f.read()), file_name="file.pdf")
    
    with st.container():
        st.write("### Use your own CSS")
        st.write("At the moment, there's no easy way to add an id/class to a streamlit element. However, if you want to use CSS, simply load it like any other file.")
    
    st.markdown("## From project resources")
    
    with st.container():
        st.write("### Display an image (using URL)")
        st.image(f"{host}/local/projects/{dataiku.api_client().get_default_project().project_key}/resources/image.jpg")
    
        st.write("### Display an image (using the Code studio location)")
        with open('../../project-lib-resources/static/image.jpg', 'rb') as f:
            st.image(image=io.BytesIO(f.read()))
    
    
    with st.container():
        st.write("### Serving a file")
        with open('../../project-lib-resources/static/file.pdf', 'rb') as f:
            st.download_button("Get the PDF", data=io.BytesIO(f.read()), file_name="file.pdf", key="download_button")
    
    with st.container():
        st.write("### Use your own CSS")
        st.write("At the moment, there's no easy way to add an id/class to a streamlit element. However, if you want to use CSS, simply load it like any other file.")

---

## [tutorials/webapps/dash/admin-dashboard/index]

# Create a simple admin project dashboard using Dash.

## Prerequisites

  * Some familiarity with HTML, CSS, and Dash for the front-end

  * Some familiarity with Python for the backend

  * An existing Dataiku Project in which you have the “Project admin” permissions

  * A Python code environment with `dash` and `dash-bootstrap-components` packages installed (see the [documentation](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html> "\(in Dataiku DSS v14\)") for more details)




Note

This tutorial has been written using `python==3.9`, `dash==2.7.0` and `dash-bootstrap-components==1.2.1` but other versions could work.

## Introduction

In this tutorial, you will create a Dataiku webapp using Dash to showcase an administration dashboard of your Dataiku instance. The webapp backend will collect the data using the Dataiku public API.

Before digging into the details, be sure that you meet the prerequisites.

### Create the Webapp

From the project home page:

  * In the top navigation bar, go to **< /> > Webapps**.

  * Click on **\+ New Webapp** on the top right, then select **Code Webapp > Dash**.

  * Select the **An empty Dash app** template and give a name to your newly created Webapp.




Fig. 1: Creation of a new Dash webapp.

Fig. 2: New empty Dash Webapp.

After a while, the Webapp should start. Whether your project environment contains Dash packages or not, you may either have a fail or success status message. If it fails, the project environment does not include the dash packages, so we must specify the Code Env the Webapp should use. Go to **Settings** , then **Settings** , change the value of “Code Env” (1) to “Select an environment,” and change the value of the “Environment” to the Code Env (2) with the prerequisite packages, shown in Fig. 3. Then click the **Save** button, and the Webapp should start. If it fails, you may have to change the settings in the **Container** field.

Fig. 3: Setting the default Code Env.

## Start with an empty template.

In the “Python” tab, replace the existing code with Code 1. After clicking the **Save** button, you should have something similar to Fig. 4.

Code 1: First code
    
    
    import dash
    import dash_bootstrap_components as dbc
    from dash import html
    
    app.config.external_stylesheets = [dbc.themes.DARKLY]
    
    app.layout = html.Div(className = 'document', children=[
        html.H1(children = "Dash Webapp: Admin dashboard tutorial")
    ])
    

Fig. 4: First template rendering.

## Setting the dashboard layout

In this part, we will set up the global layout of our dashboard to look like Fig. 5.

Fig. 5: First layout of the dashboard.

We will start by focusing on the design, then load data.

We will split the layout into several zones:

  * Zone 1 (Code 2) contains the navigation bar, with the title of our dashboard and a dropdown menu that we will populate later.

  * Zone 2 (Code 3) contains the description of our project.

  * Zone 3 will be the placeholder for the various visualizations we will add.




These three zones make the global layout as described in (Code 4).

Code 2: Navigation bar layout
    
    
    navbar = dbc.NavbarSimple(
        children=[
            dbc.DropdownMenu(
                children=[
                          ],
                nav=True,
                in_navbar=True,
                label="Get Details of Projects",
            ),
        ],
        brand="Admin dashboard tutorial",
        brand_href="#",
        color="dark",
        dark=True,
    )
    

Code 3: Description layout
    
    
    # For the description layout, we will use classical HTML tags
    description = html.Div([
        html.H1(children="Dash Webapp: Admin dashboard tutorial", className="text-center p-3", style={'color': '#EFE9E7'}),
        html.H2(children="Tutorial for creating a simple dashboard webapp, with Dash",
                className="text-center p-2 text-light "),
        html.Hr(),
    ])
    

Code 4: Application global layout
    
    
    app.layout = html.Div(className = 'document',
                      children=[
                          navbar,
                          description,
                      ])
    # content is not present for now
    

## Getting the data

In this section we will gather the necessary data to be displayed inside the Webapp.

### List of projects

We want to start by collecting data on the projects living in the instance. To do so, we need to import the `dataiku` package, retrieve a client and get the list of projects. Once we have the projects list, we can display the information (just to be sure that the list is not empty), and populate the navigation bar’s dropdown list. The code underneath retrieves the list of (accessible) projects. We will come back later on this to add interactivity.
    
    
    import dataiku
    
    client = dataiku.api_client()
    projects = client.list_projects()
    

To populate the dropdown list, we should replace the following line:
    
    
    children=[],
    

in the navigation bar layout template with:
    
    
    children=[dbc.DropdownMenuItem(p['name'], href=p['projectKey']) for p in projects],
    

Once we have the project list, we can display their number on a card. As displaying this information is common, we will create a function for (Code 5). Once this function has been created, we can add the card to our layout. We will create a content layout (Code 6), which will be useful in the next steps.

Code 5: Card creation for displaying information (V1)
    
    
    def create_card(result, title):
        card = dbc.Card(
            dbc.CardBody([
                html.P(title),
                html.H3(len(result), style={'text-align':'right','margin-right':'8px'})
            ],),
            style={'border-width':'0px', 'height':'100%'}
        )
    
        return card
    

Code 6: Content layout (V1)
    
    
    content = html.Div([
        create_card(projects, "Accessible projects")
    ])
    

Add the `content` to the `app.layout` after the `description`. The Webapp looks like the screenshot in Fig. 6, and the value should change if you change the Webapp settings to run the backend as another user in the “Settings” tab.

Fig. 6: Display the number of accessible projects.

### Global statistics of the instance

We can count more items on the instance, such as scenarios, used plugins, code environments, or connections. Not all these items are accessible without elevated privileges, so we must consider situations where the user doesn’t have sufficient permissions to access a particular resource. To do so, we create the function `get_value_if_no_execption` (See Code 7).

Code 7: Generic function to catch an exception if it occurs
    
    
    def get_value_if_no_exception(fun: object) -> object:
        """
        Try to run a function. If the function raises an exception, catch it and return an empty array.
    
        :param fun: the function to execute.
    
        :return: Return ("success", result of the function) or ("danger", []) if the function fails.
    
        Usage example:
            .. code-block:: python
    
            projects = get_value_if_no_exception(client.list_projects)
    
        """
        try:
            return "success", fun()
        except Exception as _:
            return "danger", []
    

Now we can correctly handle “errors” if they occur, as shown in Code 8.

Code 8: Collect data from the instance
    
    
    projects = get_value_if_no_exception(client.list_projects)
    clusters = get_value_if_no_exception(client.list_clusters)
    code_envs = get_value_if_no_exception(client.list_code_envs)
    connections = get_value_if_no_exception(client.list_connections)
    # Personal meanings definitions
    meanings = get_value_if_no_exception(client.list_meanings)
    plugins = get_value_if_no_exception(client.list_plugins)
    running_notebooks = get_value_if_no_exception(client.list_running_notebooks)
    running_scenarios = get_value_if_no_exception(client.list_running_scenarios)
    

As we changed the value of the variable `projects`, we should update the `DropdownMenu` accordingly. So we should replace the following line:
    
    
    children=[dbc.DropdownMenuItem(p['name'], href=p['projectKey']) for p in projects],
    

in the navigation bar layout template with:
    
    
    children=[dbc.DropdownMenuItem(p['name'], href=p['projectKey']) for p in projects[1]],
    

### Getting fancy: adding color borders

We need to slightly tweak the card generation by changing the `create_card` function to use these data. Code 9 shows the modifications. As the function `get_value_if_no_exception` return also the state of the execution, we will use it to drop a color border to the card, as shown in Fig. 7.

Code 9: Using the function `get_value_if_no_exception`
    
    
    def create_card(result, title):
        card = dbc.Card(
            dbc.CardBody([
                html.P(title),
                html.H3(len(result[1]), style={'text-align':'right','margin-right':'8px'})
            ],
            className="border-start border-{} border-5".format(result[0])),
            style={'border-width':'0px', 'height':'100%'}
        )
    
        return card
    
    
    .../...
    
    content = html.Div([
        dbc.Row([
            dbc.Col(
                create_card(projects, "Accessible Projects"), width=2
            ),
            dbc.Col(
                create_card(clusters, "Defined Clusters"), width=2
            ),
            dbc.Col(
                create_card(code_envs, "Code Envs"), width=2
            ),
            dbc.Col(
                create_card(connections, "Defined Connections"), width=2
            ),
            dbc.Col(
                create_card(plugins, "Used Plugins"), width=2
            ),
            dbc.Col(
                create_card(meanings, "Defined Meanings"), width=2
            ),
        ]),
        dbc.Row([
            dbc.Col(
                create_card(running_notebooks, "Running Notebooks"), width=6
            ),
            dbc.Col(
                create_card(running_scenarios, "Running Scenarios"), width=6
            ),
        ],
        style={'padding-top':'1ex'})
    ], style={'padding-right': '1em', 'padding-left':'1em'})
    .../...
    

Fig. 7: All cards are created from collected data on the instance (admin view).

Fig. 8: All cards are created from collected data on the instance (user view).

### “Making cards interactive.”

For now, the dashboard looks nice, but it lacks interactivity. We will add a button to each card and bind the click to a function. Before digging into the code, let’s analyze our needs. To create a card, we need a title and data. This data comes from the `get_value_if_no_exception` function, which returns a tuple. It is made of the status of the request and the result of it. We need an id to react to the click event because we want to include a button in the card and add interactivity. We will also have an icon to make the button nicer.

The click event will pop up a window, showing some information. This leads to Code 10. Of course, we have to adapt this code to our specific needs. To run this, you will need to import the following missing dependencies:
    
    
    import dash
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input, Output, State
    from dash import html
    import dataiku
    
    app.config.external_stylesheets = [dbc.themes.DARKLY, dbc.icons.FONT_AWESOME]
    

Code 10: Adding interactivity to the cards
    
    
    def create_card(result, title, icon="", id="", key=""):
        content = ""
        if key:
            content = [html.P(r[key]) for r in result[1]]
        else:
            content = str(result[1])
    
        card = dbc.Card([
            dbc.CardBody([
                dbc.Button([
                    html.I(className="fa-solid {} me-2".format(icon)),title],
                    className="card-title",
                    id=id if id else "",
                    n_clicks=0
                ),
                html.H3(len(result[1]), style={'text-align':'right','margin-right':'8px'})
            ],
            className="border-start border-{} border-5".format(result[0])),
            dbc.Modal(
                [
                    dbc.ModalHeader(dbc.ModalTitle(title)),
                    dbc.ModalBody(
                        content
                    ),
                    dbc.ModalFooter(
                        dbc.Button(
                            "Close", id="close-{}".format(id), className="ms-auto", n_clicks=0
                        )
                    ),
                ],
                id="modal-{}".format(id),
                is_open=False,
            )
        ],style={'border-width':'0px', 'height':'100%'})
    
        if id:
            @app.callback(
                Output("modal-{}".format(id), "is_open"),
                [Input(id, "n_clicks"), Input("close-{}".format(id), "n_clicks")],
                [State("modal-{}".format(id), "is_open")],)
            def toggle_modal(n1, n2, is_open):
                if n1 or n2:
                    return not is_open
                return is_open
    
    
        return card
    

We also have to replace the card creation with Code 11.

Code 11: Updated version of the card creation.
    
    
    content = html.Div([
        dbc.Row([
            dbc.Col(
                create_card(projects, "Accessible Projects", "fa-diagram-project", "id-project", "name"), width=2
            ),
            dbc.Col(
                create_card(clusters, "Defined Clusters", "fa-circle-nodes", "id-cluster", "name"), width=2
            ),
            dbc.Col(
                create_card(code_envs, "Code Envs", "fa-toolbox", "id-code-env", "envName"), width=2
            ),
            dbc.Col(
                create_card(connections, "Defined Connections", "fa-ethernet", "id-connection"), width=2
            ),
            dbc.Col(
                create_card(plugins, "Used Plugins", "fa-plug", "id-plugin", "id"), width=2
            ),
            dbc.Col(
                create_card(meanings, "Defined Meanings", "fa-comment", "id-meaning"), width=2
            ),
        ]),
        dbc.Row([
            dbc.Col(
                create_card(running_notebooks, "Running Notebooks", "fa-book", "id-notebook"), width=6
            ),
            dbc.Col(
                create_card(running_scenarios, "Running Scenarios", "fa-list-ol", "id-scenario"), width=6
            ),
        ],
        style={'padding-top':'1ex'})
    ], style={'padding-right': '1em', 'padding-left':'1em'})
    

## Final code review

Here is the complete code file present on this page.
    
    
    import dash
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input, Output, State
    from dash import html
    import dataiku
    
    client = dataiku.api_client()
    projects = client.list_projects()
    
    def get_value_if_no_exception(fun: object) -> object:
        """
        Try to run a function. If the function raises an exception, catch it and return an empty array.
    
        :param fun: the function to execute.
    
        :return: Return ("success", result of the function) or ("danger", []) if the function fails.
    
        Usage example:
            .. code-block:: python
    
            projects = get_value_if_no_exception(client.list_projects)
    
        """
        try:
            return "success", fun()
        except Exception as _:
            return "danger", []
    
    
    def create_card(result, title, icon="", id="", key=""):
        content = ""
        if key:
            content = [html.P(r[key]) for r in result[1]]
        else:
            content = str(result[1])
    
        card = dbc.Card([
            dbc.CardBody([
                dbc.Button([
                    html.I(className="fa-solid {} me-2".format(icon)),title],
                    className="card-title",
                    id=id if id else "",
                    n_clicks=0
                ),
                html.H3(len(result[1]), style={'text-align':'right','margin-right':'8px'})
            ],
            className="border-start border-{} border-5".format(result[0])),
            dbc.Modal(
                [
                    dbc.ModalHeader(dbc.ModalTitle(title)),
                    dbc.ModalBody(
                        content
                    ),
                    dbc.ModalFooter(
                        dbc.Button(
                            "Close", id="close-{}".format(id), className="ms-auto", n_clicks=0
                        )
                    ),
                ],
                id="modal-{}".format(id),
                is_open=False,
            )
        ],style={'border-width':'0px', 'height':'100%'})
    
        if id:
            @app.callback(
                Output("modal-{}".format(id), "is_open"),
                [Input(id, "n_clicks"), Input("close-{}".format(id), "n_clicks")],
                [State("modal-{}".format(id), "is_open")],)
            def toggle_modal(n1, n2, is_open):
                if n1 or n2:
                    return not is_open
                return is_open
    
    
        return card
    
    
    app.config.external_stylesheets = [dbc.themes.DARKLY, dbc.icons.FONT_AWESOME]
    
    projects = get_value_if_no_exception(client.list_projects)
    clusters = get_value_if_no_exception(client.list_clusters)
    code_envs = get_value_if_no_exception(client.list_code_envs)
    connections = get_value_if_no_exception(client.list_connections)
    # Personnal meanings definitions
    meanings = get_value_if_no_exception(client.list_meanings)
    plugins = get_value_if_no_exception(client.list_plugins)
    running_notebooks = get_value_if_no_exception(client.list_running_notebooks)
    running_scenarios = get_value_if_no_exception(client.list_running_scenarios)
    
    
    navbar = dbc.NavbarSimple(
        children=[
            dbc.DropdownMenu(
                children=[dbc.DropdownMenuItem(p['name'], href=p['projectKey']) for p in projects[1]
                          ],
                nav=True,
                in_navbar=True,
                label="Get Details of Projects",
            ),
        ],
        brand="Admin dashboard tutorial",
        brand_href="#",
        color="dark",
        dark=True,
    )
    
    description = html.Div([
        html.H1(children="Dash Webapp: Admin dashboard tutorial", className="text-center p-3", style={'color': '#EFE9E7'}),
        html.H2(children="Tutorial for creating a simple dashboard webapp, with Dash",
                className="text-center p-2 text-light "),
        html.Hr(),
    ])
    
    content = html.Div([
        dbc.Row([
            dbc.Col(
                create_card(projects, "Accessible Projects", "fa-diagram-project", "id-project", "name"), width=2
            ),
            dbc.Col(
                create_card(clusters, "Defined Clusters", "fa-circle-nodes", "id-cluster", "name"), width=2
            ),
            dbc.Col(
                create_card(code_envs, "Code Envs", "fa-toolbox", "id-code-env", "envName"), width=2
            ),
            dbc.Col(
                create_card(connections, "Defined Connections", "fa-ethernet", "id-connection"), width=2
            ),
            dbc.Col(
                create_card(plugins, "Used Plugins", "fa-plug", "id-plugin", "id"), width=2
            ),
            dbc.Col(
                create_card(meanings, "Defined Meanings", "fa-comment", "id-meaning"), width=2
            ),
        ]),
        dbc.Row([
            dbc.Col(
                create_card(running_notebooks, "Running Notebooks", "fa-book", "id-notebook"), width=6
            ),
            dbc.Col(
                create_card(running_scenarios, "Running Scenarios", "fa-list-ol", "id-scenario"), width=6
            ),
        ],
        style={'padding-top':'1ex'})
    ], style={'padding-right': '1em', 'padding-left':'1em'})
    
    app.layout = html.Div(className = 'document',
                          children=[
                              navbar,
                              description,
                              content,
                          ])
    

## Conclusion

In this tutorial, we have built a simple administration dashboard using Dash. We have collected some data from the `dataiku` package. We could also have retrieved some data from datasets using the same package. We should also have added some interactivity to the dropdown menu item. The easiest way is to create a function that produces a dropdown menu item for a given `projectKey` and pops up a modal with the data we want to display, as we did for the card button. Many other improvements could have been done, but this wouldn’t have been relevant for this tutorial.

As the web application code grows, putting the whole code into a single file will be inconvenient. We can split the code into several parts using the library and importing it into the webapp. If your code needs to access the app to add interactivity, remember to pass the `app` as a parameter of your function.

---

## [tutorials/webapps/dash/api-agent/index]

# Creating an API endpoint for using an LLM-Based agent

Deprecated

This tutorial is deprecated as of the introduction of the Agent API: [Creating a custom agent](<../../../plugins/agent/generality/index.html>).

In this tutorial, you will learn how to create an API endpoint using a headless API webapp for an LLM-based agent. This tutorial is based on two tutorials: [Building and using an agent with Dataiku’s LLM Mesh and Langchain](<../../../genai/agents-and-tools/agent/index.html>) and [Creating an API endpoint from webapps](<../../common/api/index.html>). You will use Dash as the applicative framework, but you can quickly adapt this tutorial to your preferred framework. You can directly jump to this section if you already have a working LLM-based agent.

## Prerequisites

  * Dataiku >= 13.1

  * You must download [`this dataset`](<../../../../_downloads/b71a9dc535c885cb862bf612d762f4ed/pro_customers.csv>) and create an **SQL** dataset named `pro_customers_sql`.

  * A code environment with the following packages:
        
        dash
        langchain==0.2.0
        duckduckgo_search==6.1.0
        




## Tools’ definition

You will define the external tools your LLM agent will use, as you defined in the previous tutorial. In our case, these tools include:

  * **Dataset lookup tool** : used to execute SQL queries on the `pro_customers_sql` dataset to retrieve customer information (name, role, company), given a customer ID. Code 1 shows an implementation of this tool.

  * **Internet search tool** : used to perform internet searches to fetch more detailed information about the customer’s company. Code 2 shows an implementation of this tool.




Code 1: Dataset lookup tool
    
    
    from langchain.tools import BaseTool
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    from langchain.pydantic_v1 import BaseModel, Field
    from typing import Type
    
    class CustomerInfo(BaseModel):
        """Parameter for GetCustomerInfo"""
        id: str = Field(description="customer ID")
    
    
    class GetCustomerInfo(BaseTool):
        """Gathering customer information"""
    
        name: str = "GetCustomerInfo"
        description: str = "Provide a name, job title and company of a customer, given the customer's ID"
        args_schema: Type[BaseModel] = CustomerInfo
    
        def _run(self, id: str):
            dataset = dataiku.Dataset("pro_customers_sql")
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            return f"No information can be found about the customer {id}"
    
        def _arun(self, name: str):
            raise NotImplementedError("This tool does not support async")
    

Code 2: Internet search tool
    
    
    from duckduckgo_search import DDGS
    
    
    class CompanyInfo(BaseModel):
        """Parameter for the GetCompanyInfo"""
        name: str = Field(description="Company's name")
    
    
    class GetCompanyInfo(BaseTool):
        """Class for gathering in the company information"""
    
        name: str = "GetCompanyInfo"
        description: str = "Provide general information about a company, given the company's name."
        args_schema: Type[BaseModel] = CompanyInfo
    
        def _run(self, name: str):
            results = DDGS().text(name + " (company)", max_results=1)
            result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                if len(results) > 0 and "body" in results[0] \
                else None
            if not result:
                results = DDGS().text(name, max_results=1)
                result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                    if len(results) > 0 and "body" in results[0] \
                    else "No information can be found about the company " + name
            return result
    
        def _arun(self, name: str):
            raise NotImplementedError("This tool does not support async")
    

## LLM agent creation

With the tools defined, the next step is to create an agent that can effectively utilize these tools. This tutorial uses the [ReAct](<https://react-lm.github.io/>) logic, which combines the LLM’s ability for reasoning (e.g., chain-of-thought prompting, etc.) and acting (e.g., interfacing with external software, etc.) through a purposely crafted prompt.

Code 3: LLM agent creation
    
    
    import dataiku
    from dataiku.langchain.dku_llm import DKUChatModel
    from langchain_core.prompts import ChatPromptTemplate
    from langchain.agents import AgentExecutor, create_react_agent
    
    LLM_ID = "<A valid LLM ID>"  # Replace with a valid LLM id
    
    llm = DKUChatModel(llm_id=LLM_ID, temperature=0)
    
    # Initializes the agent
    # Link the tools
    tools = [GetCustomerInfo(), GetCompanyInfo()]
    tool_names = [tool.name for tool in tools]
    
    prompt = ChatPromptTemplate.from_template(
        """Answer the following questions as best you can. You have only access to the following tools:
    
    {tools}
    
    Use the following format:
    
    Question: the input question you must answer
    Thought: you should always think about what to do
    Action: the action to take, should be one of [{tool_names}]
    Action Input: the input to the action
    Observation: the result of the action
    ... (this Thought/Action/Action Input/Observation can repeat N times)
    Thought: I now know the final answer
    Final Answer: the final answer to the original input question
    
    Begin!
    
    Question: {input}
    Thought:{agent_scratchpad}""")
    
    agent = create_react_agent(llm, tools, prompt)
    agent_executor = AgentExecutor(agent=agent, tools=tools,
                                   verbose=True, return_intermediate_steps=True, handle_parsing_errors=True)
    

## Defining the routes

The first step is to define the routes you want your API to handle. A single route is responsible for a (simple) process. Dataiku provides an easy way to describe those routes. Relying on a Flask server helps you return the desired resource types. Check the API access in the web apps’ settings to use this functionality, as shown in Figure 1.

Figure 1: Enabling API access.

This tutorial relies on a single route parametrized by the customer’s ID to query the LLM and give the user the appropriate answer. Once you have set the code env in the settings panel, you will define the route, as shown in Code 4.

Code 4: Route handling
    
    
    @app.server.route("/get_customer_info/<customer_id>")
    def get_customer_info(customer_id):
        """
        Ask the agent to retrieve information about the customer
    
        Args:
            customer_id: the customer ID
    
        Returns:
            Information about the customer
        """
        return agent_executor.invoke(
            {
                "input": f"""Give all the professional information you can about the customer with ID: {customer_id}. Also include information about the company if you can.""",
                "tools": tools,
                "tool_names": tool_names
            })["output"]
    
    

## Testing the API

Once you have set up everything, you may test your API. Testing the API can be done in different ways. They are all required to know the `WEBAPP_ID` and the `PROJECT_KEY`. The `WEBAPP_ID` is the first eight characters (before the underscore) in the webapp URL. For example, if the webapp URL in Dataiku is `/projects/HEADLESS/webapps/kUDF1mQ_api/view`, the `WEBAPP_ID` is `kUDF1mQ`, and the `PROJECT_KEY` is `HEADLESS`. Additionally, you may need an API key to test the API, depending on the way you want to access your API. Please read [this documentation](<https://doc.dataiku.com/dss/latest/publicapi/keys.html> "\(in Dataiku DSS v14\)") if you need help setting up an API key.

### Via browser

In a browser, enter the URL:
    
    
    http://<DATAIKU_ADDRESS>:<DATAIKU_PORT>/web-apps-backends/<PROJECT_KEY>/<WEBAPP_ID>/get_customer_info/<customer_ID>
    

This will require the user to be logged to access to this resource.

### Via command line

Using `cUrl` requires an API key to access the headless API or an equivalent way of authenticating, depending on the authentication method set on the Dataiku instance.
    
    
    curl -X GET --header 'Authorization: Bearer <USE_YOUR_API_KEY>' \
        'http://<DATAIKU_ADDRESS>:<DATAIKU_PORT>/web-apps-backends/<PROJECT_KEY>/<WEBAPP_ID>/get_customer_info/<customer_ID>'
    

### Via Python

You can access the headless API using the Python API. Depending on whether you are inside Dataiku or outside, you will use the `dataikuapi` or the `dataiku` package, respectively, as shown in Code 5.

Code 5: Testing the API from Python
    
    
    import dataiku, dataikuapi
    
    API_KEY=""
    DATAIKU_LOCATION = "" #http(s)://DATAIKU_HOST:DATAIKU_PORT
    PROJECT_KEY = ""
    WEBAPP_ID = ""
    
    
    # If you are outside Dataiku use this function call
    client = dataikuapi.DSSClient(DATAIKU_LOCATION, API_KEY)
    
    # If you are inside Dataiku you can use this function call
    client = dataiku.api_client()
    
    
    project = client.get_project(PROJECT_KEY)
    webapp = project.get_webapp(WEBAPP_ID)
    backend = webapp.get_backend_client()
    
    # To filter on one user
    print(backend.session.get(backend.base_url + '/get_customer_info/fdouetteau').text)
    

## Wrapping up

Congratulations! You have completed this tutorial and have a working API serving an agent. You can try to tweak the agent or integrate this API into a more complex process.

Here is the complete code of the headless web application:

[`app.py`](<../../../../_downloads/3e54a3583cebb060f8f0125624a6a219/app.py>)
    
    
    from dash import html
    
    import dataiku
    from dataiku.langchain.dku_llm import DKUChatModel
    
    from langchain.tools import BaseTool
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    from langchain.pydantic_v1 import BaseModel, Field
    from typing import Type
    from duckduckgo_search import DDGS
    
    from langchain_core.prompts import ChatPromptTemplate
    from langchain.agents import AgentExecutor, create_react_agent
    
    LLM_ID = "<A valid LLM ID>"  # Replace with a valid LLM id
    
    llm = DKUChatModel(llm_id=LLM_ID, temperature=0)
    
    
    class CustomerInfo(BaseModel):
        """Parameter for GetCustomerInfo"""
        id: str = Field(description="customer ID")
    
    
    class GetCustomerInfo(BaseTool):
        """Gathering customer information"""
    
        name: str = "GetCustomerInfo"
        description: str = "Provide a name, job title and company of a customer, given the customer's ID"
        args_schema: Type[BaseModel] = CustomerInfo
    
        def _run(self, id: str):
            dataset = dataiku.Dataset("pro_customers_sql")
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            return f"No information can be found about the customer {id}"
    
        def _arun(self, name: str):
            raise NotImplementedError("This tool does not support async")
    
    
    class CompanyInfo(BaseModel):
        """Parameter for the GetCompanyInfo"""
        name: str = Field(description="Company's name")
    
    
    class GetCompanyInfo(BaseTool):
        """Class for gathering in the company information"""
    
        name: str = "GetCompanyInfo"
        description: str = "Provide general information about a company, given the company's name."
        args_schema: Type[BaseModel] = CompanyInfo
    
        def _run(self, name: str):
            results = DDGS().text(name + " (company)", max_results=1)
            result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                if len(results) > 0 and "body" in results[0] \
                else None
            if not result:
                results = DDGS().text(name, max_results=1)
                result = "Information found about " + name + ": " + results[0]["body"] + "\n" \
                    if len(results) > 0 and "body" in results[0] \
                    else "No information can be found about the company " + name
            return result
    
        def _arun(self, name: str):
            raise NotImplementedError("This tool does not support async")
    
    
    # Initializes the agent
    # Link the tools
    tools = [GetCustomerInfo(), GetCompanyInfo()]
    tool_names = [tool.name for tool in tools]
    
    prompt = ChatPromptTemplate.from_template(
        """Answer the following questions as best you can. You have only access to the following tools:
    
    {tools}
    
    Use the following format:
    
    Question: the input question you must answer
    Thought: you should always think about what to do
    Action: the action to take, should be one of [{tool_names}]
    Action Input: the input to the action
    Observation: the result of the action
    ... (this Thought/Action/Action Input/Observation can repeat N times)
    Thought: I now know the final answer
    Final Answer: the final answer to the original input question
    
    Begin!
    
    Question: {input}
    Thought:{agent_scratchpad}""")
    
    agent = create_react_agent(llm, tools, prompt)
    agent_executor = AgentExecutor(agent=agent, tools=tools,
                                   verbose=True, return_intermediate_steps=True, handle_parsing_errors=True)
    
    
    @app.server.route("/get_customer_info/<customer_id>")
    def get_customer_info(customer_id):
        """
        Ask the agent to retrieve information about the customer
    
        Args:
            customer_id: the customer ID
    
        Returns:
            Information about the customer
        """
        return agent_executor.invoke(
            {
                "input": f"""Give all the professional information you can about the customer with ID: {customer_id}. Also include information about the company if you can.""",
                "tools": tools,
                "tool_names": tool_names
            })["output"]
    
    
    # build your Dash app
    app.layout = html.Div()

---

## [tutorials/webapps/dash/basics/index]

# Dash: your first webapp

The aim of this guide is to help you understand how Dash works by setting up a simple web application. You will create a web application that allows the user to select a dataset from the project’s context and display it.

Dash is an open-source library that enables you to create reactive web-based applications. The code for Dash apps is declarative and reactive. To build complex applications, you need to have a clear understanding of the underlying concepts.

Declarative programming is a way of expressing the logic of a process without describing the control flow. This means that you focus on what the program should do rather than how it should be done. To achieve this, you should try to minimize side effects.

Declarative programming is often opposed to imperative programming. Imperative programming focuses on how to do the process, as shown in Code 1. Declarative programming focuses on the result, and the underlying process is not expressed, as shown in Code 2.

Code 1: Display the sum of a list (imperative style)
    
    
    # Calculate the sum of a list
    sum = 0
    myList = [1,2,3,4,5]
    
    # Create a for loop to add numbers in the list to the sum
    for x in myList:
        total += x
    print(total)
    

Code 2: Display the sum of a list (declarative style)
    
    
    myList = [1,2,3,4,5]
    
    # display the sum of numbers in mylist
    print(sum(myList))
    

Side effects occur when a program or function modifies something outside of its scope, which can disrupt the smooth operation of a multi-user application. Such modifications can make it difficult to predict the global state of the application, making it unreliable. In web applications, this can lead to unexpected behavior. To mitigate such issues, one can use reactive programming, a declarative programming paradigm where changes are automatically propagated.

These concepts will become clearer as you progress through this guide.

## Creating the WebApp

First, you need to create a Dash webapp. You will use the Dash empty template and create a Dash webapp named: Dataset Display, as shown in Fig. 1 and Fig. 2. You will replace the whole provided code later.

Fig. 1: Creating an empty Dash webapp.

Fig. 2: Naming the newly created webapp.

Important

Once this is done, you have to be sure that the used code environment contains `dash`. In the settings tabs, you can select a specific code environment to be used by default when the webapp is run. For more information on creating a code environment, refer to [Code environments](<https://doc.dataiku.com/dss/latest/code-envs/index.html> "\(in Dataiku DSS v14\)").

## Sketching the webapp

The webapp will consist of a dropdown menu to be able to select a Dataset and an area where the dataset will be displayed. The application will also contain a title, so the global design of the webapp will be:

[](<../../../../_images/dash-tmp-mermaid-1.png>)

Sketch of the webapp.

First, you will focus on the design of the webapp (the declarative part). You will create the title and the dropdown menu using the `H1` and the `Dropdown` components. You will also use the `DataTable` component to display the selected dataset. Finally, all these Dash components should be nested inside a `Div` component to tie them together. The resulting code is shown in Code 3.

Code 3: Initial implementation.
    
    
    from dash import Dash, dcc, html, dash_table
    
    # build your Dash app
    app.layout = html.Div([
        html.H1("How to display a dataset"),
        dcc.Dropdown(placeholder="Choose a dataset to display."),
        dash_table.DataTable()
    ])
    

## Populating the dropdown

### Getting dataset names from the project

To populate the dropdown, you need to retrieve the name of all existing datasets in the project. To achieve this, you can import the `dataiku` package to get a handle on your local project. You can then use this handle to generate a list of metadata for all datasets in your project. See Code 4.

Code 4: How to get the existing datasets.
    
    
    import dataiku
    
    project = dataiku.api_client().get_default_project()
    datasets = project.list_datasets()
    

Note that the `datasets` variable points neither to a list of datasets nor to a list of dataset names. It contains a list of dicts which, among other things, include each dataset name. To check what the `datasets` variable looks like, you can log it.

### Logging

Sometimes, it’s necessary to track the execution process or to log information for either debugging or for providing post-execution data. The logs of the Dash webapp can be accessed in the Log tab. The `Log` button will display the full log. To access to the logger, Code 5 shows the easiest way to do it.

Code 5: Accessing the WebApp default logger.
    
    
    import logging
    
    logger = logging.getLogger(__name__)
    
    # .../...
    logger.info(datasets)
    

### All together

The list of datasets, visible in the log, contains more than just the names. To populate the dropdown menu, you must extract each dataset name (`datasets_name`) as shown in Code 6. When designing the webapp, you have only declared the elements it should include. Nevertheless, here you have introduced some variable that could be a potential problem (if you were to do some multi-tasking, for example) and a departure from the declarative paradigm. This problem can be resolved by using some advanced techniques that go beyond the scope of this “basic” tutorial.

Code 6: Dropdown filled with the datasets name
    
    
    from dash import Dash, dcc, html, dash_table, Input, Output
    import logging
    import dataiku
    
    logger = logging.getLogger(__name__)
    
    project = dataiku.api_client().get_default_project()
    datasets_name = list(map((lambda x: x.get("name","")), project.list_datasets()))
    
    
    # build your Dash app
    app.layout = html.Div([
        html.H1("How to display a dataset"),
        dcc.Dropdown(datasets_name, placeholder="Choose a dataset to display.", id='dropdown'),
        dash_table.DataTable(id='table')
    ])
    

## Displaying the dataset

To be able to display the dataset, you need to pass to the `DataTable` the data.

You cannot pre-compute those data as you don’t know the user’s choice. As such, you need a way to dynamically populate the `DataTable` depending on the user choice. Once the user selects a dataset in the dropdown, the webapp should react to this change, and update the corresponding `DataTable`.

To be able to react to a change:

  * You need to provide an id for the objects involved in the change (the `Dropdown` for the input, and the `DataTable` for the output).

  * You need to define a function (called callback) that will be called when the user changes the input (`Dropdown` have a new value).


[](<../../../../_images/dash-tmp-mermaid-2.png>)

Concept of callback

The callback is pretty simple as it retrieves the name of the Dataset, and then updates the `DataTable` with the updated values, like shown in Code 7. To update the `DataTable` you need to update two fields (`data` and `columns`), so the callback should have two outputs.

You need to update both fields as the selected dataset could not have the same column as the previously selected dataset. You also need to check if there is a value coming from the input as this value could be `None` (particularly when the webapp starts).

When developing a Dash webapp, it is good practice to put all the callbacks in the same part of the application. So Code 7 should be put at the end of your application.

Code 7: How to react on the user change.
    
    
    @app.callback(
        Output('table', 'data'),
        Output('table', 'columns'),
        Input('dropdown', 'value')
    )
    def update(value):
        # If there is no value, do nothing (this is the case when the webapp is launched)
        if value is None:
            raise PreventUpdate
        # Take only the 100 first rows
        dataset = dataiku.Dataset(value).get_dataframe(limit=100)
        return dataset.to_dict('records'), [{"name": i, "id": i} for i in dataset.columns]
    

## Going further

At this point, you have created a functional webapp that allows users to select and display datasets using the Dash library and framework in the context of Dataiku. You have learned how to construct interfaces declaratively that respond to user actions, as well as the purpose and implementation of callbacks in Dash.

Although functional, this webapp is not completely satisfactory. For example, when trying to load a huge dataset, the webapp may seem to be freezing. This can be caused by the time it takes for the `DataTable` component to render, or by heavy data computation. In a reactive context, it is best to avoid these issues or at least inform the user that their action has been received and that processing is running. Dash offers a specific mechanism for “long” callbacks, but in any case, providing feedback to the user is important. For that purpose, you can use the Dash `Loading` component. A message can also be displayed when no dataset is selected. This can be done either by returning a specific value in the callback or by adding a new callback (and a new component) that displays/hides the corresponding component, depending on the dropdown’s value.

Here are the complete versions of the code presented in this tutorial:

Python Code
    
    
    from dash import Dash, dcc, html, dash_table, Input, Output
    from dash.exceptions import PreventUpdate
    import logging
    import dataiku
    
    logger = logging.getLogger(__name__)
    
    project = dataiku.api_client().get_default_project()
    datasets_name = list(map((lambda x: x.get("name", "")), project.list_datasets()))
    
    # build your Dash app
    app.layout = html.Div([
        html.H1("How to display a dataset"),
        dcc.Dropdown(datasets_name, placeholder="Choose a dataset to display.", id='dropdown'),
        dash_table.DataTable(id='table')
    ])
    
    
    @app.callback(
        Output('table', 'data'),
        Output('table', 'columns'),
        Input('dropdown', 'value')
    )
    def update(value):
        # If there is no value, do nothing (this is the case when the webapp is launched)
        if value is None:
            raise PreventUpdate
        # Take only the 100 first rows
        dataset = dataiku.Dataset(value).get_dataframe(limit=100)
        return dataset.to_dict('records'), [{"name": i, "id": i} for i in dataset.columns]

---

## [tutorials/webapps/dash/chatGPT-web-assistant/index]

# Using Dash and LLM Mesh to build a GPT-powered web app assistant

## Prerequisites

  * Dataiku >= 13.0

  * “Use” permission on a code environment using Python >= 3.9 with the following packages:
    
    * `dash` (tested with version `2.10.2`)

    * `dash-bootstrap-components` (tested with version `1.4.1`)

  * Access to an existing project with the following permissions:
    
    * “Read project content”

    * “Write project content”




## Introduction

In this tutorial, you will learn to call a GPT model into a Dataiku web app for a simple question-answering task.

### LLM initialization and library import

To begin with, you need to set up a development environment by importing some necessary libraries and initializing the chat LLM you want to use. The tutorial relies on the LLM Mesh for this.

Tip

The [documentation](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>) provides instructions on obtaining an `LLM ID`. The following code snippet will print you an exhaustive list of all the models your project has access to.

Code 1: List accessible LLM
    
    
    import dataiku
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms()
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    

### Using the prompt through the LLM Mesh

To check if everything is working as expected, you can run Code 2 in a notebook.

Code 2: Code for testing if all requirements are met.
    
    
    LLM_ID = "" # Replace with a valid LLM id
    
    # Get a text generation model
    llm = project.get_llm(LLM_ID)
    
    # Create and run a completion query
    completion = llm.new_completion()
    completion.with_message("Write a haiku on GPT models")
    resp = completion.execute()
    
    # Display the LLM output
    if resp.success:
       print(resp.text)
    

## Building the web app

### CSS file

Before sketching the web app, you must create an accessible CSS file. Go to the **Application menu > Global Shared Code > Static web resources**. Create a file named `loading-state.css` inside the `local-static` directory, with the content shown in Code 3. As shown in the next section, this code will help display an indicator when you query the model.

Code 3: CSS code for indication of a loading state
    
    
    *[data-dash-is-loading="true"]{
        visibility: hidden;
    }
    *[data-dash-is-loading="true"]::before{
        content: "Thinking...";
        display: inline-block;
        visibility: visible;
    }
    

### Sketching the Webapp

First, you need to create an empty Dash webapp. If you don’t know how to create one, please refer to this [mini-tutorial](<../common-parts/create-the-webapp-empty-template.html>).

Then, import all the required libraries and configure the webapp to use the CSS file you created. Code 4 shows how to do this.

Code 4: Import packages
    
    
    import dash
    from dash import html
    from dash import dcc
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash.exceptions import PreventUpdate
    import dataiku
    import base64
    import pandas as pd
    
    # use the style of examples on the Plotly documentation
    app.config.external_stylesheets = [dbc.themes.BOOTSTRAP, "/local/static/loading-state.css"]
    
    

Now, you can design the application. You will need a user input and a chatGPT output for this application. As the webapp focuses on a question-answering bot, you should keep some context (the previously asked questions and answers). You must limit the context size to avoid long queries and reduce costs. There are various ways to do that, but the most understandable is restricting the messages kept by a certain amount. Usually, OpenAI uses a token counter to do that, but it is not a human-readable metric. You also may need a button to reset the conversation if the user needs it.

To sum up, we need the following:

  * a number input (for the size of the kept messages)

  * a button to reset the conversation

  * a text input (for the user input)

  * a text to display the response.




Code 5 implements this application. The highlighted line is where the application will display a processing spinner when the user sends its request. This line works in conjunction with the CSS defined earlier.

Code 5: Design of the application.
    
    
    search_text_layout = html.Div([
        dcc.Store(id='messages', data=[
            {"role": "system", "content": "You are a helpful assistant"}]),
        dbc.Row([
            dbc.Label("Max messages", html_for="max_messages", width=2),
            dbc.Col(dbc.Input(id="max_messages", value="5", type="number", min=1, max=10), width=2),
            dbc.Col(width=6),
            dbc.Col(dbc.Button("Reset conversation", id="flush_messages", n_clicks=0, class_name="btn-danger"), width=2,
                    class_name="d-grid col-2 gap-2")
        ], class_name="mb-3", ),
        dbc.Row([
            dbc.Label("Ask your question", html_for="search_input", width=2),
            dbc.Col(html.Div(children=[
                dbc.Input(id="search_input", placeholder="What can I do for you?"),
                dcc.Loading(id="ls-loading-1", children=[html.Div(id="ls-loading-output-1")], type="default")]), width=10),
        ], className="mb-3", ),
    ])
    
    # build your Dash app
    app.layout = html.Div([
        search_text_layout,
        dbc.Row([
            dbc.Col(width=2),
            dbc.Col(dbc.Textarea(id="text_output", style={"height": "200px"}), width=10)], class_name="mb-3"),
    ], className="container-fluid mt-3")
    
    

Now that you have designed the application, you only have to connect the components and call the associated functions. The first highlighted line in Code 6 is the callback associated with the Q&A processing. The second one resets the current conversation.

Code 6: Callbacks of the webapp
    
    
    @app.callback(
        [Output("ls-loading-output-1", "children"),
         Output("text_output", "value"),
         Output("messages", "data")],
        Input("search_input", "n_submit"),
        State("search_input", "value"),
        State("max_messages", "value"),
        State("messages", "data"),
        running=[
            (Output("search_button", "disabled"), True, False),
        ],
        prevent_initial_call=True
    )
    def get_answer(_, question, max_messages, messages):
        """
        Ask a question to Chat GPT (with some context), and give back the response
        Args:
            _: number of enter pressed in the input text (not used)
            question: the question (with the context)
            max_messages: number of context messages to keep
            messages: the context
    
        Returns:
            the response, and an updated version of the context
        """
        if not (question) or not (max_messages) or not (messages):
            raise PreventUpdate
    
        while len(messages) > int(max_messages):
            messages.pop(1)
    
        messages.append({"role": "user", "content": question})
        try:
            completion = llm.new_completion()
            for message in messages:
                completion.with_message(message.get('content'), role=message.get('role'))
            answer = completion.execute()
    
            if answer.success:
                messages.append({"role": "assistant", "content": answer.text})
                return ["", answer.text, messages]
            else:
                return ["", "Something went wrong", messages]
        except:
            return ["", "Something went wrong", messages]
    
    
    @app.callback(
        Output("messages", "data", allow_duplicate=True),
        Input("flush_messages", "n_clicks"),
        prevent_initial_call=True
    )
    def reset_conversation(_clicks):
        """
        Reset the conversation
        Args:
            _clicks: number of clicks on the flush button (unused)
    
        Returns:
            a new context for the conversation
        """
        return [{"role": "system", "content": "You are a helpful assistant"}]
    
    

## Saving the response into a dataset

Requesting GPT assistance might be costly, so you could create your cache and save the question that has already been answered and its response. So, before requesting an answer from the GPT assistant, check if the question has been asked. If so, reply with the previous response or ask the GTP assistant if the question has yet to be asked. Depending on the dataset type, adding data to an existing dataset could be done in various ways. Let’s consider two kinds of datasets:

  * For an SQL-like dataset, you can then use the [`dataiku.SQLExecutor2`](<../../../../api-reference/python/sql.html#dataiku.SQLExecutor2> "dataiku.SQLExecutor2") to insert data into a dataset.

  * For a CSV-like dataset, you can then load the data as a dataframe, add data and save back the dataframe. This method requires loading the whole dataset into memory and may be inappropriate for big datasets.




You first need to create one to save the answers in a dataset. This dataset must have been defined before, with two columns named `question` and `answer`.

### Adding a button to save the data

Before digging into the details, you should add a button to the webapp allowing the user to save the question and the answer into a dataset. This is done in two steps:

  * First, add a save button to the layout:
    

Code 7: Adding a button for saving the Q&A
        
        dbc.Row([dbc.Col(dbc.Button("Save this answer",
                                    id="save_answer",
                                    n_clicks=0,
                                    class_name="btn-primary",
                                    size="lg"))],
                justify="end",
                className="d-grid gap-2 col-12 mx-auto", )
        

  * Then connect this button to a callback in charge of saving the Q&A:
    

Code 8: Connecting the button to a callback
        
        @app.callback(
            Output("save_answer", "n_clicks"),
            Input("save_answer", "n_clicks"),
            State("search_input", "value"),
            State("text_output", "value"),
            prevent_initial_call = True
        )
        def save_answer(_, question, answer):
        




Depending on the dataset kind, the implementation of the callback will change.

### Using the SQLExecutor

Considering you already have an SQL dataset, you can use the SQLExecutor to insert a row into a dataset, letting the dataset engine optimize for you. To insert a new row, you will need to use an INSERT statement, like `sql = f"""INSERT INTO "{table_name}" (question, answer) VALUES {values_string}"""`. You may face trouble using this kind of statement if the answer contains some specific characters (like ‘, “, …). As you have no control of the response (and fine-tuning the prompt might be tough to prevent the assistant from generating an appropriate answer), you must encode the response before inserting it into the dataset into a proper format.

Code 10 shows how to encode the question and the response before inserting the data using the SQL statement and the [`dataiku.SQLExecutor2`](<../../../../api-reference/python/sql.html#dataiku.SQLExecutor2> "dataiku.SQLExecutor2").

Code 9: Saving the data into a SQL-Like dataset
    
    
    def write_question_answer_sql(client, dataset_name, connection, connection_type, project_key, question, answer):
        dataset = dataiku.Dataset(dataset_name)
        table_name = dataset.get_location_info().get('info', {}).get('table')
        value_string = (f"('{base64.b64encode(question.encode('utf-8')).decode('utf-8')}', "
                        f"'{base64.b64encode(answer.encode('utf-8')).decode('utf-8')}')")
        sql = f"""INSERT INTO "{table_name}" (question, answer) VALUES {value_string}"""
        client.sql_query(sql, connection=connection, type=connection_type, project_key=dataset.project_key,
                         post_queries=['COMMIT'])
    

### Using dataframe

If your dataset fits into memory, you can rely on the dataframe to append the data to an existing CSV-like dataset. The principle is straightforward:

  * Read the dataset as a dataframe.

  * Create the data.

  * Append them to the dataframe.

  * Save back the dataframe.




Code 10 shows how to do this.

Code 10: Saving the data into a CSV-Like dataset
    
    
    def write_question_answer_csv(dataset_name, question, answer):
        dataset = dataiku.Dataset(dataset_name)
        row = {
            "question": [f"""{question}"""],
            "answer": [f"""{answer}"""]
        }
        df = dataset.get_dataframe()
        df = pd.concat([df, pd.DataFrame(row)])
        with dataset.get_writer() as writer:
            writer.write_dataframe(df)
    

Note

Dataiku offers an optional response cache in the LLM Mesh connections, but it keeps data for 24 hours, with a 1GB limit.

## Wrapping up

Congratulations! You have completed this tutorial and built a Dash web application that enables ChatGPT integration inside a Dataiku webapp. Understanding all these basic concepts allows you to create more complex applications.

You can add a field to this web application to tweak the way Chat GPT answers or try to reduce the number of tokens used in a query. If you save the data into a dataset, you can look for the question before requesting the ChatGPT assistant.

In this web application, you keep a fixed number of messages. When this number is reached, you remove the first message. Keeping only a specified number of messages in the conversation is not the best idea. You should rather implement a mechanism that sums up the conversation and keep this summary as the content of the first message. An LLM can do this for you.

Here is the complete code for your application:

[`webapp.py`](<../../../../_downloads/c1ffb1a752350e665b61f18e1903567c/webapp.py>)
    
    
    import dash
    from dash import html
    from dash import dcc
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash.exceptions import PreventUpdate
    import dataiku
    import base64
    import pandas as pd
    
    
    def write_question_answer_sql(client, dataset_name, connection, connection_type, project_key, question, answer):
        """
        Save data into a SQL like dataset
        Args:
            client: the dataiku client
            dataset_name: name of the SQL dataset
            connection: name of the SQL connection used for saving
            connection_type: type of connection
            project_key: project key
            question: the question
            answer: the answer
        """
        dataset = dataiku.Dataset(dataset_name)
        table_name = dataset.get_location_info().get('info', {}).get('table')
        value_string = f"('{base64.b64encode(question.encode('utf-8')).decode('utf-8')}', '{base64.b64encode(answer.encode('utf-8')).decode('utf-8')}')"
        sql = f"""INSERT INTO "{table_name}" (question, answer) VALUES {value_string}"""
        client.sql_query(sql, connection=connection, type=connection_type, project_key=dataset.project_key,
                         post_queries=['COMMIT'])
    
    
    def write_question_answer_csv(dataset_name, question, answer):
        """
        Save data into a CSV like dataset
        Args:
            dataset_name: the CSV dataset
            question: the question
            answer: the answer
        """
        dataset = dataiku.Dataset(dataset_name)
        row = {
            "question": [f"""{question}"""],
            "answer": [f"""{answer}"""]
        }
        df = dataset.get_dataframe()
        df = pd.concat([df, pd.DataFrame(row)])
        with dataset.get_writer() as writer:
            writer.write_dataframe(df)
    
    
    # use the style of examples on the Plotly documentation
    app.config.external_stylesheets = [dbc.themes.BOOTSTRAP, "/local/static/loading-state.css"]
    
    search_text_layout = html.Div([
        dcc.Store(id='messages', data=[
            {"role": "system", "content": "You are a helpful assistant"}]),
        dbc.Row([
            dbc.Label("Max messages", html_for="max_messages", width=2),
            dbc.Col(dbc.Input(id="max_messages", value="5", type="number", min=1, max=10), width=2),
            dbc.Col(width=6),
            dbc.Col(dbc.Button("Reset conversation", id="flush_messages", n_clicks=0, class_name="btn-danger"), width=2,
                    class_name="d-grid col-2 gap-2")
        ], class_name="mb-3", ),
        dbc.Row([
            dbc.Label("Ask your question", html_for="search_input", width=2),
            dbc.Col(html.Div(children=[
                dbc.Input(id="search_input", placeholder="What can I do for you?"),
                dcc.Loading(id="ls-loading-1", children=[html.Div(id="ls-loading-output-1")], type="default")]), width=10),
        ], className="mb-3", ),
    ])
    
    # build your Dash app
    app.layout = html.Div([
        search_text_layout,
        dbc.Row([
            dbc.Col(width=2),
            dbc.Col(dbc.Textarea(id="text_output", style={"height": "200px"}), width=10)], class_name="mb-3"),
        dbc.Row(
            [dbc.Col(dbc.Button("Save this answer", id="save_answer", n_clicks=0, class_name="btn-primary", size="lg"))],
            justify="end", className="d-grid gap-2 col-12 mx-auto", )
    ], className="container-fluid mt-3")
    
    LLM_ID = "openai:toto:gpt-3.5-turbo"
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID)
    
    
    @app.callback(
        [Output("ls-loading-output-1", "children"),
         Output("text_output", "value"),
         Output("messages", "data")],
        Input("search_input", "n_submit"),
        State("search_input", "value"),
        State("max_messages", "value"),
        State("messages", "data"),
        running=[
            (Output("search_button", "disabled"), True, False),
        ],
        prevent_initial_call=True
    )
    def get_answer(_, question, max_messages, messages):
        """
        Ask a question to Chat GPT (with some context), and give back the response
        Args:
            _: number of enter pressed in the input text (not used)
            question: the question (with the context)
            max_messages: number of context messages to keep
            messages: the context
    
        Returns:
            the response, and an updated version of the context
        """
        if not (question) or not (max_messages) or not (messages):
            raise PreventUpdate
    
        while len(messages) > int(max_messages):
            messages.pop(1)
    
        messages.append({"role": "user", "content": question})
        try:
            completion = llm.new_completion()
            for message in messages:
                completion.with_message(message.get('content'), role=message.get('role'))
            answer = completion.execute()
    
            if answer.success:
                messages.append({"role": "assistant", "content": answer.text})
                return ["", answer.text, messages]
            else:
                return ["", "Something went wrong", messages]
        except:
            return ["", "Something went wrong", messages]
    
    
    @app.callback(
        Output("messages", "data", allow_duplicate=True),
        Input("flush_messages", "n_clicks"),
        prevent_initial_call=True
    )
    def reset_conversation(_clicks):
        """
        Reset the conversation
        Args:
            _clicks: number of clicks on the flush button (unused)
    
        Returns:
            a new context for the conversation
        """
        return [{"role": "system", "content": "You are a helpful assistant"}]
    
    
    @app.callback(
        Output("save_answer", "n_clicks"),
        Input("save_answer", "n_clicks"),
        State("search_input", "value"),
        State("text_output", "value"),
        prevent_initial_call=True
    )
    def save_answer(_clicks, question, answer):
        """
        Save the answer
        Args:
            _clicks: number of clicks on the flush button (unused)
            question: the question
            answer: the answer
    
        Returns:
    
        """
        ## Uncomment these lines if you need to save into an SQL dataset
    
        #    client =  dataiku.api_client()
        #dataset_name = "History_SQL"
        #connection = "PostgreSQL"
        #connection_type = "sql"
        #project_key = client.get_default_project()
    
        #write_question_answer_sql(client, dataset_name, connection, connection_type, project_key, question, answer)
    
        ## Saving into a CSV dataset
    
        dataset_name = "History"
        write_question_answer_csv(dataset_name, question, answer)
    

[`loading-state.css`](<../../../../_downloads/330ef7c3c22386f7b360a4bf67dd6a99/loading-state.css>)
    
    
    *[data-dash-is-loading="true"]{
        visibility: hidden;
    }
    *[data-dash-is-loading="true"]::before{
        content: "Thinking...";
        display: inline-block;
        visibility: visible;
    }

---

## [tutorials/webapps/dash/common-parts/create-the-webapp-empty-template]

# Create an empty dash webapp

From the project home page:

  * In the top navigation bar, go to **< /> > Webapps**.

  * Click on **\+ New webapp** on the top right, then select **Code webapp > Dash**.

  * Select the **An empty Dash app** template and give a name to your newly created webapp.




Fig. 1: Creation of a new Dash webapp.

Fig. 2: New empty Dash webapp.

After a while, the webapp should start. Whether your project environment contains Dash packages, you may have a fail or success status message. If it fails, the project environment does not include the dash packages, so we must specify the code env the webapp should use. Go to **Settings** , then **Settings** , change the value of “Code env” (1) to “Select an environment,” and change the value of the “Environment” to the code env (2) with the prerequisite packages, shown in Fig. 3. Then click the **Save** button, and the webapp should start. If it fails, you may have to change the settings in the **Container** field.

Fig. 3: Setting the default code env.

---

## [tutorials/webapps/dash/delete-projects/index]

# Listing and deleting a selection of projects

## Prerequisites

  * Dataiku >= 13.4

  * A Python code environment with dash package installed (see the [documentation](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html> "\(in Dataiku DSS v14\)") for more details)




Note

The code in this tutorial has been tested with two configurations:

  * `python==3.9` with `dash==2.7.0`

  * `python==3.11` with `dash==3.1.1`




but other versions could work.

## Introduction

Occasionally, you should clean up and remove unused projects on a development instance. This tutorial will show you how to build a Dash application that lists all the projects in a Data Table. This list will be selectable, and we will add a button to delete the selected projects.

## Building the webapp

### Creating the webapp

Please start with an empty Dash web app. For instructions on creating an empty Dash web app, refer to this [tutorial](<../common-parts/create-the-webapp-empty-template.html>).

### Creating the Data Table

Let’s start with the following Code 1

Code 1: Create the Data Table
    
    
    from dash import html, dash_table
    import dataiku
    import pandas as pd
    import logging
    
    logger = logging.getLogger(__name__)
    logger.info('start webapp')
    
    client = dataiku.api_client()
    
    
    def get_projects():
        """
        Returns a pandas dataframe containing the key, name, and short description for each project
        """
        projects = client.list_projects()
        keys = [proj['projectKey'] for proj in projects]
        names = [proj['name'] for proj in projects]
        desc = [proj.get('shortDesc', 'No description found.') for proj in projects]
        data = {
            "key": keys,
            "name": names,
            "description": desc
        }
    
        return pd.DataFrame(data)
    
    
    projects_table = dash_table.DataTable(
        id='projects_table',
        columns=[{"name": i, "id": i, "selectable": True} for i in get_projects().columns],
        data=get_projects().to_dict('records'),
        row_selectable='multi',
        selected_rows=[],
        editable=True
    )
    
    # build your Dash app
    app.layout = html.Div([
        html.H1("List of projects"),
        projects_table
    ])
    

We start retrieving the project list using the [`list_projects()`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient.list_projects> "dataikuapi.DSSClient.list_projects") method from the [`dataikuapi.DSSClient`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient") class. That’s the purpose of the [`get_project()`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project") function.

The creation of the [DataTable from Dash](<https://dash.plotly.com/datatable/reference>) uses two important parameters.

  * `row_selectable='multi'` will add a checkbox on each row to enable the multi-selection of projects.

  * `editable=True` will allow the update of the project list after each delete action.




### Adding a delete mechanism

At that point, we need a button to trigger the delete action of the selected projects. To be sure the user is aware of the action, we will encapsulate the button in a Dash component called [ConfirmDialogProvider](<https://dash.plotly.com/dash-core-components/confirmdialogprovider>)
    
    
    app.layout = html.Div([
        html.H1("List of projects"),
        projects_table,
        dcc.ConfirmDialogProvider(
            children=html.Button('Delete', id='delete-button', n_clicks=0),
            id='warning-delete',
            message='Are you sure you want to delete the selected project(s)?'
        )
    ])
    

Note

In this section, you will need new import instructions. If you need help on this topic, have a look at the complete code.

The user’s confirmation will then trigger a Dash Callback that will handle the selection deletion and the update of the DataTable.
    
    
    @callback(
        Output('projects_table', 'data'),
        Output('projects_table', 'selected_rows'),
        Input('warning-delete', 'submit_n_clicks'),
        State('projects_table', 'selected_rows'),
        prevent_initial_call=True
    )
    def delete_projects(submit_n_clicks, selected_rows):
        """
        Callback triggered when the user click on the delete button
        This will delete all the selected projects.
        Returns the updated list of projects and reset the selection
        """
        projects = get_projects()
        for key in projects.iloc[selected_rows]['key'].to_list():
            project = client.get_project(key)
            project.delete(clear_managed_datasets=True, clear_output_managed_folders=True, clear_job_and_scenario_logs=True)
            logger.info(f"project {key} deleted")
        updated_projects = projects.loc[~projects.index.isin(selected_rows)].to_dict('records')
    
        return updated_projects, []
    

The callback is triggered when the user clicks on the delete button. The Input parameter defines the element change that will trigger the callback. Note the use of Dash [State](<https://dash.plotly.com/reference#dash.state>). This State parameter will allow access to the list of selected rows without triggering the callback, as it would have been with an Input parameter. The callback will return the updated list of projects, defined by the first Output parameter, and reset the selection as defined by the second Output parameter.

## Wrapping up

Congratulations! You now have a web application that will help you to clean an instance by removing a selection of projects. You can improve it with a refresh button that will update the list of projects.

Here is the complete code of the web application:

Cleanup webapp complete code
    
    
    from dash import html, dash_table, Input, Output, State, callback, dcc
    import dataiku
    import pandas as pd
    import logging
    
    logger = logging.getLogger(__name__)
    logger.info('start webapp')
    
    client = dataiku.api_client()
    
    
    def get_projects():
        """
        Returns a pandas dataframe containing the projects key, name and short description
        """
        projects = client.list_projects()
        keys = [proj['projectKey'] for proj in projects]
        names = [proj['name'] for proj in projects]
        desc = [proj['shortDesc'] for proj in projects]
        data = {
            "key": keys,
            "name": names,
            "description": desc
        }
    
        return pd.DataFrame(data)
    
    
    projects_table = dash_table.DataTable(
        id='projects_table',
        columns=[{"name": i, "id": i, "selectable": True} for i in get_projects().columns],
        data=get_projects().to_dict('records'),
        row_selectable='multi',
        selected_rows=[],
        editable=True
    )
    
    # build your Dash app
    app.layout = html.Div([
        html.H1("List of projects"),
        projects_table,
        dcc.ConfirmDialogProvider(
            children=html.Button('Delete', id='delete-button', n_clicks=0),
            id='warning-delete',
            message='Are you sure you want to delete the selected project(s)?'
        )
    ])
    
    
    @callback(
        Output('projects_table', 'data'),
        Output('projects_table', 'selected_rows'),
        Input('warning-delete', 'submit_n_clicks'),
        State('projects_table', 'selected_rows'),
        prevent_initial_call=True
    )
    def delete_projects(submit_n_clicks, selected_rows):
        """
        Callback triggered when the user clicks on the delete button.
        This will delete all the selected projects.
        Returns the updated list of projects and resets the selection.
        """
        projects = get_projects()
        for key in projects.iloc[selected_rows]['key'].to_list():
            project = client.get_project(key)
            project.delete(clear_managed_datasets=True, clear_output_managed_folders=True, clear_job_and_scenario_logs=True)
            logger.info(f"project {key} deleted")
        updated_projects = projects.loc[~projects.index.isin(selected_rows)].to_dict('records')
    
        return updated_projects, []
    

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.project.DSSProject`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
  
### Functions

[`delete`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.delete> "dataikuapi.dss.project.DSSProject.delete")([clear_managed_datasets, ...]) | Delete the project  
---|---  
[`get_project`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient.get_project> "dataikuapi.DSSClient.get_project")(project_key) | Get a handle to interact with a specific project.  
[`list_projects`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient.list_projects> "dataikuapi.DSSClient.list_projects")([include_location]) | List the projects

---

## [tutorials/webapps/dash/display-charts/index]

# Display a Bar chart using Dash

This tutorial will introduce the development of a Dash application for extracting sales data from Dataiku. You can select countries from a dropdown menu, and the bar plot will dynamically update to display the total sales for the chosen countries.

You should know how to create an empty Dash web application. If you don’t, please refer to [this tutorial](<../common-parts/create-the-webapp-empty-template.html>).

## Prerequisites

  * Dataiku >= 12.0

  * A code environment with `dash` and `plotly`




Note

We have tested this tutorial using a Python 3.9 code environment with `dash==2.18.0` and `plotly==5.13.1`. Other Python versions may be compatible. Check the webapp logs for potential incompatibilities.

## Data preparation

Start by downloading the source data following [this link](<https://cdn.downloads.dataiku.com/public/website-additional-assets/data/Orders_by_Country_sorted.csv>) and make it available in your Dataiku project, for example, by uploading the _.csv_ file. Name the resulting Dataiku dataset `Orders_by_Country_sorted`.

## Creating the webapp

The webapp will consist of a title, a text (to explain the purpose of the webapp), a multi-select object (for selecting the countries), and a plot.

### Importing the libraries

First, you need to create an empty Dash web application and import the required libraries, as shown in Code 1.

Code 1: Importing the required libraries.
    
    
    from dash import dcc, html
    from dash.dependencies import Input, Output
    import plotly.express as px
    import dataiku
    
    

### Providing data

To use the dataset, you must read `Orders_by_Country_sorted` with the `dataiku` package, as shown in Code 2.

Code 2: Reading the data.
    
    
    # READ DATASET
    dataset = dataiku.Dataset("Orders_by_Country_sorted")
    df = dataset.get_dataframe()
    df = df[df['campaign']]
    
    

### Creating the layout

Code 3 defines the web application’s layout, as defined at the beginning of this section. You must plug a callback to update the bar chart, so you don’t need to create it in the layout. The callback will be called when the application will start.

Code 3: Creating the layout.
    
    
    # Create the layout of the app
    app.layout = html.Div([
        html.Div([
            html.H1("Total Sales by Country", style={'backgroundColor': '#5473FF', 'color': '#FFFFFF', 'width': '98vw', 'margin': 'auto', 'textAlign': 'center'}),
            html.P("This graph allows you to compare the total sales amount and campaign influence by country.", style={'textAlign': 'center'}),
            dcc.Dropdown(
                id='country-select',
                options=[{'label': country, 'value': country} for country in sorted(df['country'].unique())],
                value=['United States', 'China', 'Japan', 'Germany', 'France', 'United Kingdom'],
                multi=True,
                style={'width': '50%', 'margin': 'auto'}
            ),
            dcc.Graph(id='sales-graph')
        ])
    ])
    
    

### Updating the bar chart

Code 4 is responsible for creating/updating the bar chart whenever the user changes the selected countries. For the Dash application, if you don’t use `prevent_initial_call=True` in the parameter of a callback, the callback is called when the application starts. So, we can use the same callback to create or update the bar chart.

Code 4: Updating the bar chart.
    
    
    # Define the callback to update the graph
    @app.callback(
        Output('sales-graph', 'figure'),
        [Input('country-select', 'value')]
    )
    def update_figure(selected_countries):
        """
        Update the bar chart whenever the user selects one country.
        Args:
            selected_countries: all selected countries
    
        Returns:
            the new bar chart
        """
        filtered_df = df[df['country'].isin(selected_countries)]
        fig = px.bar(filtered_df, x='country', y='total_amount', title='Total amount per campaign')
        fig.update_layout(xaxis_title='Country', yaxis_title='Total Amount')
        return fig
    
    

## Going further

You can test different charts, change the column used to display the information and adapt this tutorial to your needs.

Here are the complete versions of the code presented in this tutorial:

[`app.py`](<../../../../_downloads/9c5cadb91dcee89bcb4d3ba18d8ecd3b/dash.py>)
    
    
    from dash import dcc, html
    from dash.dependencies import Input, Output
    import plotly.express as px
    import dataiku
    
    # READ DATASET
    dataset = dataiku.Dataset("Orders_by_Country_sorted")
    df = dataset.get_dataframe()
    df = df[df['campaign']]
    
    # Create the layout of the app
    app.layout = html.Div([
        html.Div([
            html.H1("Total Sales by Country", style={'backgroundColor': '#5473FF', 'color': '#FFFFFF', 'width': '98vw', 'margin': 'auto', 'textAlign': 'center'}),
            html.P("This graph allows you to compare the total sales amount and campaign influence by country.", style={'textAlign': 'center'}),
            dcc.Dropdown(
                id='country-select',
                options=[{'label': country, 'value': country} for country in sorted(df['country'].unique())],
                value=['United States', 'China', 'Japan', 'Germany', 'France', 'United Kingdom'],
                multi=True,
                style={'width': '50%', 'margin': 'auto'}
            ),
            dcc.Graph(id='sales-graph')
        ])
    ])
    
    # Define the callback to update the graph
    @app.callback(
        Output('sales-graph', 'figure'),
        [Input('country-select', 'value')]
    )
    def update_figure(selected_countries):
        """
        Update the bar chart whenever the user selects one country.
        Args:
            selected_countries: all selected countries
    
        Returns:
            the new bar chart
        """
        filtered_df = df[df['country'].isin(selected_countries)]
        fig = px.bar(filtered_df, x='country', y='total_amount', title='Total amount per campaign')
        fig.update_layout(xaxis_title='Country', yaxis_title='Total Amount')
        return fig