# Dataiku Docs — mlops

## [mlops/ai-types/ai-types-synchronization]

# AI Types Synchronization

## Synchronization with Govern

When a project or bundle is synchronized with Govern, its AI Types are automatically included in the synchronization data. If an AI Type is later updated on the DSS instance, the new value is automatically pushed to Govern.

## Manual Refresh

AI Types can be manually refreshed. In the Project Settings’ AI Types tab, users with write permissions on the project can independently recompute all the AI Types of the project and of its API Services.

---

## [mlops/ai-types/api-services-ai-types]

# API Service AI Types

## Endpoint AI Types

### Automatic Assignment

The **ML** AI Type is automatically assigned to prediction and clustering endpoints.

### Manual Tagging

It is also possible to manually assign an AI Type to an endpoint by applying the corresponding tag.

The endpoint will automatically receive the AI Type associated with the tag.

Tag to Add | Resulting AI Type  
---|---  
`type-ml` | **ML**  
`type-llm` | **LLM**  
`type-agent` | **Agent**  
  
Please see [Tags](<../../collaboration/tags.html>) for more details on objects tagging.

## API Service AI Types

The AI types of an API service are determined by the aggregation of the AI types of its individual endpoints.

---

## [mlops/ai-types/index]

# AI Types

AI Types help organizations quickly identify contents of a project or a service. They simplify management and governance, allowing for the creation of more specific filters, Unified Monitoring alerts (see [Unified Monitoring Alerting](<../unified-monitoring/unified-monitoring-alerting.html>) doc) and Deployers Hooks (see [Deployment infrastructures](<../../deployment/project-deployment-infrastructures.html>) doc).

They are automatically assigned based on a set of rules and can also be manually granted.

---

## [mlops/ai-types/project-ai-types]

# Project AI Types

## Automatic Assignment

Project AI Types are automatically computed based on project contents following the logic:

  * **ML** : The project contains one or more machine learning features:

>     * A saved model in the Flow

  * **LLM** : The project contains one ore more LLM features:

>     * A pink object in the Flow
> 
>     * An Answers, Agent Connect or Agent Hub webapp

  * **Agent** : The project contains one or more agent features:

>     * A visual agent
> 
>     * A code agent
> 
>     * A plugin agent
> 
>     * An Agent Connect or Agent Hub webapp




Note

Shared Objects are also considered in the calculation of AI Types.

## Manual Tagging

It is also possible to manually assign an AI Type to a project by applying a dedicated tag to certain of its items.

The project will automatically receive the AI Type associated with the tag.

Tag to Add | Resulting AI Type  
---|---  
`type-ml` | **ML**  
`type-llm` | **LLM**  
`type-agent` | **Agent**  
  
Please see [Tags](<../../collaboration/tags.html>) for more details on objects tagging.

---

## [mlops/drift-analysis/index]

# Drift analysis

When models are deployed and used in production, over time, the conditions in real life may drift compared to what was the reality at train time and thus have a possibly negative impact on how the model behaves. This is known as Model Drift.

There can be data drift, i.e. change in the statistic distribution of features, or concept drift, which is due to a modification of the relationship between features and the target.

To monitor model drift, it is necessary to gather new data from the production environments and possibly have ground truth associated with it. See [Automating model evaluations and drift analysis](<../model-evaluations/automating.html>) for more details.

When you are viewing a [Model Evaluation in a Model Evaluation Store](<../model-evaluations/analyzing-evaluations.html>), in addition to the normal result screens, you have access to a “Drift” section, allowing you to perform three kind of drift analysis:

Drift analysis is always about comparing data on the current Model Evaluation compared to a _reference_.

---

## [mlops/drift-analysis/input-data-drift]

# Input Data Drift

Input Data Drift analyzes the distribution of features in the evaluated data. If the distribution of features changes significantly, this likely indicates that the underlying data has significantly changed, which could signal a concept drift.

You do not need to have the ground truth / labels to compute Input Data Drift.

## Generating Input Data Drift

Input Data drift is computed and stored in a Model Evaluation within a Model Evaluation Store. In order to create this Model Evaluation, there are 2 options: using an Evaluate recipe or using a Standalone Evaluate recipe. The Evaluate recipe takes two inputs: a dataset containing the most recent data (also called Evaluation Dataset) and a Saved Model. The Standalone Evaluation recipe takes two datasets: an evaluation dataset, as the Evaluate recipe, and a Reference dataset. The Evaluate recipe is the most commonly used for model monitoring. The Standalone Evaluate recipe is used to compute pure data drift, without model involved, or to perform drift analysis of models unknown to Dataiku.

In the case of the Evaluate Recipe, the drift is computed between the Evaluation dataset and the test set of the Saved Model Version indicated in the recipe configuration. In the case of the Standalone Evaluate Recipe, the drift is computed between the Evaluation dataset and the Reference dataset.

You can learn more on the applicable sampling strategies in [Sampling strategies for drift analysis](<sampling.html>).

## Global Drift Score

Global drift score features the same drift model used to compute the “data drift” metric displayed in the “Evaluations” tab of an Evaluation store. In addition to the accuracy of the drift model are also available:

  * a lower and upper bound

  * a binomial test on drift detection




The drift model is trained on the concatenation of the samples from the related model version training and from the evaluated dataset. Those samples may be truncated to match the size of the other sample to obtain 50% of data from each dataset. The drift model predicts whether a row belongs to one or another sample. The higher the accuracy is, the better the drift model can recognize where a row comes from, and so the more likely has the data.

## Univariate Data Drift

Univariate data drift performs this operation per feature. Several standard feature drifting metrics are computed by Dataiku and added to the Model Evaluation Store metrics. Additionally, the Model Evaluation will show you the graphical distribution of data and help you spot the features that are subject to drifting.

When running, the recipe will automatically detect the type of drift to use. Dataiku natively supports three handlings: numerical, categorical or textual.

If you want to force a specific handling for a column, this can be done in the recipe configuration, in the ‘Advanced’ tab. In this tab, you can force a type or exclude a specific feature from the drift computation.

## Feature Drift Importance

The Feature drift importance scatter plot shows feature importance for the original model versus feature importance for the (data classifying) drift model.

## Note on Unstructured Data Drift

The recipe processes text and image columns separately from standard features. Their computation requires explicit activation in the recipe configuration. They need an Embedding Model. The recipe excludes these columns from the global drift score.

### Embedding Drift Metrics

The recipe computes embedding drift metrics using feature embeddings (for Text and Image). The metrics use the [Euclidean distance](<https://www.kaggle.com/code/adityasingh3519/distance-measures-for-machine-learning#Euclidean-Distance>), the [Cosine similarity](<https://www.sciencedirect.com/topics/computer-science/cosine-similarity>), and a dedicated Classifier.

### Image Quality Drift Metrics

The image drift analysis compares the distribution of image characteristics (e.g., `Mean Red`) against the reference sample. The analysis provides a Kolmogorov-Smirnov (KS) test score for each characteristic. This metric helps identify characteristics that show significant drift from the reference sample.

### Image Classifier Visualization

The image drift analysis also displays the classifier confidence graph and visual examples of drifted images.

---

## [mlops/drift-analysis/performance-drift]

# Performance Drift

Performance Drift is in a sense the “most straightforward” kind of drift analysis. It analyses whether the actual performance of the model changes.

However, having ground truth / labels is naturally required for Performance Drift, which is not always possible. See [Automating model evaluations and drift analysis](<../model-evaluations/automating.html>) for a discussion on this.

When Ground truth is not available, [Input Data Drift](<input-data-drift.html>) and [Prediction Drift](<prediction-drift.html>) can provide insights into whether you have a concept drift.

---

## [mlops/drift-analysis/prediction-drift]

# Prediction Drift

Prediction Drift analyses the distribution of predictions on the evaluated data. If the distribution of predictions changes significantly, this likely indicates that the underlying data has significantly changed, which could signal a concept drift.

Having ground truth / labels is not required for Prediction Drift.

---

## [mlops/drift-analysis/reference]

# Drift reference

When you are viewing a [Model Evaluation in a Model Evaluation Store](<../model-evaluations/analyzing-evaluations.html>), you have access to the three types of Drift.

Drift is always about comparing the behavior of the current Model Evaluation with regards to a “reference”.

For each type of drift, you need to select the “reference”.

The reference must be an evaluation that is compatible. It may come from:

  * The evaluation that was created automatically when training the Saved Model that was used to compute the current Model Evaluation (default)

  * Another Model Evaluation (either in the same store or in another)

  * The evaluation that was created automatically when training a model in a Visual Analysis (even if it was never deployed)




By default, DSS automatically selects the evaluation that was created automatically when training the Saved Model that was used to compute the current Model Evaluation. This is most frequently what you need.

---

## [mlops/drift-analysis/sampling]

# Sampling strategies for drift analysis

When computing drifts, using relevant data is key and, to that extent, defining the right sampling method is the most important aspect to understand well. Not using sampling is not a recommended approach as it will overload the execution, making it potentially very slow.

When dealing with sampling, a Model Evaluation will actually compare two datasets named ‘Reference’ and ‘Current’.

## Definitions

**Reference data**

The _reference_ dataset for model monitoring refers to the training data of the model. To be precise, we are using the test part of this training dataset. The way this test dataset is computed depends on your model design and can be entirely configured (you can learn more [Settings: Train / Test set](<../../machine-learning/supervised/settings.html>)). This test dataset is defined when the model is trained and cannot be changed afterward. If you are not satisfied with its definition, you need to retrain a new model version with a new definition.

**Current data**

Each run of the Evaluate recipe will create one Model Evaluation containing all your drift metrics. The Current data is the content of the recipe’s input dataset when it runs. Dataiku offers the ability to define sampling rules for this dataset, defined in the Evaluate recipe, in the ‘Sampling’ section.

Note

There is an additional safety net for this sampling that will limit the result to 50k rows or 8Mb of compressed data. This can be removed in the Evaluate recipe advanced settings. It is important to note that this data is saved as part of the Model Evaluation, so removing this limit and using bigger sampling rules will lead to more disk space used, plan accordingly.

## Data drift

Data drift will help you spot significant changes in the data distribution, not considering any specific Machine Learning aspect. In a Model evaluation, this will consider the reference dataset and the current dataset. If you read the section above, you know that reference dataset actually means the test part of your model training data and current means the input dataset content when the Evaluate recipe has been executed.

Note

You can also compute a pure data drift between any two dataset using a Standalone Evaluate Recipe.

Data drift in Dataiku actually computes 2 sets of metric: a global score and feature-by-feature score (also known as univariate drift). You can learn more about those metrics in [Input Data Drift](<input-data-drift.html>).

Different rules are applied to compute those metrics:
    

  * **Global score** : As we want to build a model to differentiate the reference and current datasets, we need to have balanced data, with the same number of rows from those two datasets. To do so, we count the number of rows from the smallest dataset and make a random sampling on the other to reduce it to the same number.




  * **Univariate drift** : Contrary to the global score, we do not care about imbalanced data so we will use as many rows as possible from both datasets




## Prediction drift

Prediction drift is computed similarly to univariate data drift, so there is no sampling or filtering done on the reference or current dataset.

## Performance drift

There is no additional sampling for this computation either: we compute the model performance metrics using all the current dataset rows.

---

## [mlops/experiment-tracking/concepts]

# Concepts

Experiment Tracking in DSS uses the [MLflow Tracking](<https://www.mlflow.org/docs/2.17.2/tracking.html>) API, and shares most of the concepts.

When running code-based experimentations, you organize your work in _Experiments_.

An _Experiment_ contains _Runs_.

A _Run_ often corresponds to the training of a model. A run stores _parameters_ , _metrics_ and _artefacts_. As a user, you store these in a run by calling specific APIs.

For example, you could store the hyperparameters as parameters of the run, resulting performance metrics as metrics of the run, and the resulting model and some generated charts as artefacts of the run.

You may for instance choose to organize your attempts with different algorithms as _Experiments_ and have different hyperparameters selections as _Runs_ , each run storing the resulting model.

Leveraging the integration of MLflow Tracking, you can track your experiments using the standard MLflow Tracking API, with the following DSS specific benefits:

  * All experiments and runs benefit from DSS project-level security

  * Run artefacts are stored in a DSS managed folder and can be directly manipulated from there

  * If you save a MLflow model as an artefact of a run, you can then directly deploy this model using Dataiku’s support for [MLflow Models](<../mlflow-models/index.html>)




DSS experiment tracking makes it easy to manage the security of your experiment data and artefacts. It also allows you to leverage DSS features such as deploying, monitoring and governance.

---

## [mlops/experiment-tracking/deploying]

# Deploying MLflow models

If your experiment tracking run logs a MLflow model (using the log_model function), it can be deployed directly from the UI.

## Deploying a model

A model logged during an experiment tracking run may be deployed through the “Run details” screen, by clicking on the “Deploy” button in the models list.

A regression or classification model deployed through the GUI is always evaluated on a dataset in order to provide a performance analysis. This is the same as models trained in DSS. To deploy a model without evaluating it, either set the prediction type to “Other” or use the API.

Note

The classes must be specified in the same order as learned by the model. If not, for a multi-class model for example, when the model outputs the probabilities, they will be in the wrong order.

The original experiment id and run id are automatically recorded when adding an MLflow model as a new version of a saved model.

## Pre-defining the information for deployment

A lot of information that is not part of the MLflow model is required in order to deploy the MLflow model as a visual model in DSS. However, most of it can be pre-defined when the run is created, using a Dataiku extension to the MLflow API. This is especially handy when the model has many classes.
    
    
    import dataiku
    
    project = dataiku.api_client().get_default_project()
    managed_folder = project.get_managed_folder('A_MANAGED_FOLDER_ID')
    
    mlflow_extension = project.get_mlflow_extension()
    
    with project.setup_mlflow(managed_folder=managed_folder) as mlflow_handle:
        mlflow_handle.set_experiment("my_experiment")
    
        with mlflow_handle.start_run(run_name="my_run") as run:
            # ...your MLflow code...
            # setting information to make the deployment of a model trained in this run easier through the GUI
    
            # The classes must be specified in the same order as learned by the model.
            classes = ['class_a','class_b','class_c']
    
            # Some flavors such as scikit-learn may allow you to build this list from the model itself
            classes = list(map(str, current_clf_model.classes_.tolist()))
    
            mlflow_extension.set_run_inference_info(run._info.run_id, "MULTICLASS", classes,
                                                    "code_environment_name", "target_name")
    

These predefined parameters can be changed and overridden at deployment time except the model type.

## Deploying through the API

A model can be deployed from an experiment tracking run using [`dataikuapi.dss.mlflow.DSSMLflowExtension.deploy_run_model()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.deploy_run_model> "\(in Developer Guide\)"). Depending on the prediction type, the model will be evaluated during the deployment.

Most parameters are optional since [`dataikuapi.dss.mlflow.DSSMLflowExtension.deploy_run_model()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.deploy_run_model> "\(in Developer Guide\)") will use by default what was set with [`dataikuapi.dss.mlflow.DSSMLflowExtension.set_run_inference_info()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.set_run_inference_info> "\(in Developer Guide\)").
    
    
    mlflow_ext.set_run_inference_info(run.id, "BINARY_CLASSIFICATION", list_of_classes, code_env_name, target_column_name)
    mlflow_extension.deploy_run_model(run.id, sm_id, evaluation_dataset)
    

Note

A model logged using the `mlflow.log_model` API is a MLflow model. As such, it can be also be imported using [`dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_path()`](<https://developer.dataiku.com/latest/api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_path> "\(in Developer Guide\)") or [`dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_managed_folder()`](<https://developer.dataiku.com/latest/api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_managed_folder> "\(in Developer Guide\)"). See [Importing MLflow models](<../mlflow-models/importing.html>).

---

## [mlops/experiment-tracking/extensions]

# Extensions

Dataiku’s experiment tracking features _extensions_ to the MLflow Python API.

Some of those extensions are allowing actions that can only be performed through the CLI in standard MLflow.

In order to interact with these extensions, you must first obtain a reference to the [`dataikuapi.dss.mlflow.DSSMLflowExtension`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension> "\(in Developer Guide\)") through [`dataikuapi.dss.project.DSSProject.get_mlflow_extension()`](<https://developer.dataiku.com/latest/api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_mlflow_extension> "\(in Developer Guide\)")
    
    
    import dataiku
    import mlflow
    
    project = dataiku.api_client().get_default_project()
    mlflow_extension = project.get_mlflow_extension()
    

You can then use the following methods:

  * list models and experiments: [`dataikuapi.dss.mlflow.DSSMLflowExtension.list_models()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.list_models> "\(in Developer Guide\)") and [`dataikuapi.dss.mlflow.DSSMLflowExtension.list_experiments()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.list_experiments> "\(in Developer Guide\)")

  * rename experiments: [`dataikuapi.dss.mlflow.DSSMLflowExtension.rename_experiment()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.rename_experiment> "\(in Developer Guide\)")

  * restore experiments and runs: [`dataikuapi.dss.mlflow.DSSMLflowExtension.restore_experiment()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.restore_experiment> "\(in Developer Guide\)") and [`dataikuapi.dss.mlflow.DSSMLflowExtension.restore_run()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.restore_run> "\(in Developer Guide\)")

  * clear experiments marked for deletion (_garbage collect_): [`dataikuapi.dss.mlflow.DSSMLflowExtension.garbage_collect()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.garbage_collect> "\(in Developer Guide\)")




Others are more DSS specific:

  * clean the runtime experiment db for a DSS project: [`dataikuapi.dss.mlflow.DSSMLflowExtension.clean_experiment_tracking_db()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.clean_experiment_tracking_db> "\(in Developer Guide\)")

  * set the inference info of a run (to make scoring or evaluation of a model easier): [`dataikuapi.dss.mlflow.DSSMLflowExtension.set_run_inference_info()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.set_run_inference_info> "\(in Developer Guide\)")

  * create a DSS dataset of the experiment tracking runs of a project: [`dataikuapi.dss.mlflow.DSSMLflowExtension.create_experiment_tracking_dataset()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.create_experiment_tracking_dataset> "\(in Developer Guide\)")

  * deploy a model from a run: [`dataikuapi.dss.mlflow.DSSMLflowExtension.deploy_run_model()`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension.deploy_run_model> "\(in Developer Guide\)")

---

## [mlops/experiment-tracking/index]

# Experiment Tracking

Experiment tracking is the process of saving all experiment-related information that you care about for every experiment you run. This may include parameters, performance metrics, models and any other data relevant to your project.

In Dataiku, this can be done:

  * visually, without coding, in the Lab (see [Prediction (Supervised ML)](<../../machine-learning/supervised/index.html>))

  * when coding, by calling specific APIs to log values of parameters, metrics, … and then being able to view all of your experiments and associated results.




This section focuses on code-based Experiment Tracking. Code-based Experiment Tracking in DSS uses the [MLflow Tracking](<https://www.mlflow.org/docs/2.17.2/tracking.html>) API.

---

## [mlops/experiment-tracking/tracking]

# Tracking experiments in code

## Initial setup

Before you can track experiments, you need to create a [Managed Folder](<../../connecting/managed_folders.html>) in the project. The managed folder will be used to store artefacts. Take note of the managed folder id (8 alphanum characters, visible in the URL).

## Quick start sample
    
    
    import dataiku
    
    project = dataiku.api_client().get_default_project()
    managed_folder = project.get_managed_folder('A_MANAGED_FOLDER_ID')
    
    with project.setup_mlflow(managed_folder=managed_folder) as mlflow_handle:
    
        # Note: if you don't call this (i.e. when no experiment is specified), the default one is used
        mlflow_handle.set_experiment("My first experiment")
    
        with mlflow_handle.start_run(run_name="my_run"):
            # ...your MLflow code...
            mlflow_handle.log_param("a", 1)
            mlflow_handle.log_metric("b", 2)
    
            # This uses the regular MLflow APIs
    

## Tracking API

DSS uses the [MLflow Tracking](<https://www.mlflow.org/docs/2.17.2/tracking.html>) API. Please refer to the MLflow Tracking documentation.

## Autologging

MLflow Tracking comes with a very useful feature: autologging, which automatically logs metrics, parameters, and models for common machine-learning packages without the need for explicit log statements.

Leveraging MLflow autologging requires no additional configuration of the DSS integration. Some machine learning packages, such as PyTorch, may however [require additional packages](<https://www.mlflow.org/docs/2.17.2/python_api/mlflow.pytorch.html>).

In the following sample, we activate MLflow autologging for a SKlearn model. Metrics and artifacts are automatically logged.
    
    
    import dataiku
    import mlflow
    import sklearn.linear_model.ElasticNet
    
    project = dataiku.api_client().get_default_project()
    managed_folder = project.get_managed_folder('A_MANAGED_FOLDER_ID')
    
    with project.setup_mlflow(managed_folder=managed_folder) as mlflow_handle:
        mlflow_handle.set_experiment("Let's autolog")
    
        # activate Mflow autologging
        mlflow_handle.sklearn.autolog()
    
        with mlflow_handle.start_run(run_name="my_run"):
            lr = ElasticNet(alpha=alpha, l1_ratio=l1_ratio, random_state=42)
            lr.fit(train_x, train_y)
    

## Other topics

### Logging into another project

You can log experiments into another project than the current one by using:
    
    
    project = dataiku.api_client().get_project("MYOTHERPROJECT")
    

### Experiment tracking outside DSS

MLflow Tracking integration is configured through the `dataikuapi` package. See [Using Dataiku’s Python packages](<https://developer.dataiku.com/latest/tutorials/devtools/python-client/index.html> "\(in Developer Guide\)") for how to use it from outside of DSS

### Usage without context manager

While the usage of the context manager (“with” statement) is recommended, it is not mandatory. You can use this instead:
    
    
    import dataiku
    import mlflow
    
    project = dataiku.api_client().get_default_project()
    managed_folder = project.get_managed_folder('A_MANAGED_FOLDER_ID')
    
    mlflow_handle = project.setup_mlflow(managed_folder=managed_folder)
    
    mlflow.set_experiment("My first experiment")
    
    with mlflow.start_run(run_name="my_run"):
        # ...your MLflow code...
        mlflow.log_param("a", 1)
        mlflow.log_metric("b", 2)
    
    mlflow_handle.clear()
    

### Cautions

If you do not set up the integration before using the MLflow client, or use the client after clearing the integration, it may fall back to its default mode: writing experiment data as the current user, on the filesystem of the host of the DSS server.

### Supported versions

See [Limitations and supported versions](<../mlflow-models/limitations.html>) for supported MLflow versions.

---

## [mlops/experiment-tracking/viewing]

# Viewing experiments and runs

The Experiment Tracking UI is available in the Machine Learning menu.

## Experiments

The main screen displays active experiments by default. You can choose to show the experiments marked for deletion as well.

You can then either:

  * Click on an experiment to view all of its runs

  * Select multiple experiments to compare runs between experiments




## Runs

The runs list screen displays information on the runs, including which DSS user performed it, metrics, parameters, tags and a link to the path of the DSS managed folder where the artifacts are stored.

In this screen, runs can be deleted (soft delete) or restored.

The metrics of the runs are represented using charts.

### Bar charts

Bar charts display the final performance value of runs. They can be keyed by a parameter or by the run id (default).

### Line charts

Metrics can be logged multiple times in a given MLflow run. They are then available as series. You may optionally provide a step number when logging a metric, as the third parameter of the mlflow.log_metric function.

Line charts display those evolving metrics, supporting two modes: step and relative time.

Note

You may refresh the charts during the training of your models. Toggling autorefresh reloads data for selected experiments every 10 seconds.

Note

Some MLflow autologgers do not correctly log steps.

## Run

The run screen has two tabs to display:

  * The details of the run, including its parameters, tags, metrics and models.

  * The directory of the managed folder where artifacts of the run are stored.




In the details tab, metrics can be displayed as line graphs if more than one value was logged. Logged models can be visually deployed from this screen. See [Deploying MLflow models](<deploying.html>).

## Dataset

It’s possible to create a DSS dataset from the data of the experiment tracking runs of a project.

This lets you perform DSS analysis and compute visualization features on your runs data.

You can create such a dataset:

  * from the flow, in +Dataset > Internal > Experiments

  * from the Experiments screen, by selecting experiments then choose “Create dataset” in the mass actions.




The later method will prefill a set of experiments to retrieve.

The dataset is available in two formats:

  * Long format, with one line per metric, param, tag

  * JSON format, with metrics, params and tags as JSON columns




It also allows you to select runs according to an MLflow search runs expression, following the MLflow search syntax (a simplified versions of the SQL WHERE clause, see <https://www.mlflow.org/docs/2.17.2/search-runs.html>).

Note

search-experiments (<https://www.mlflow.org/docs/2.17.2/search-experiments.html>) is not supported yet.

## Delete/Restore/Clear

Experiments and runs may be _deleted_ and _restored_. Deletions are _soft deletions_ : items are marked for deletion but will not be physically removed from storage until _cleared_.

To permanently delete items marked for deletion for a given project, use the `Clear Deleted Experiments` project macro. This macro is equivalent to the MLflow `gc` command. You may also use the extensions of the python API (see [Extensions](<extensions.html>)).

Note

When clearing experiments and runs marked for deletion, related artefacts, including models, are deleted.

## Cautions

  * Only one experiment with a given name may be active.

---

## [mlops/external-models/index]

# External Models

External Models are a way to surface, evaluate and use in DSS Models that are already deployed on Amazon SageMaker, Azure Machine Learning, Google Vertex AI or Databricks.

Using External Models, you can create a DSS Saved Model from an endpoint deployed on the infrastructures of one of those supported cloud vendors.

This allows you to benefit from the ML management capabilities of DSS on your existing External Models:

  * Scoring datasets using a [scoring recipe](<../../machine-learning/supervised/explanations.html#explanations-scoring-recipe-label>)

  * Managing multiple versions of the models

  * Evaluating the performance of a classification or regression model on a labeled dataset, including all results screens

  * Comparing multiple models or multiple versions of the model, using [Model Comparisons](<../model-comparisons/index.html>)

  * Analyzing performance and evaluating models [on other datasets](<../model-evaluations/index.html>)

  * [Analyzing drift](<../drift-analysis/index.html>) on the External Model




## Creating an External Model

Before creating an External Model, you must create the “External Models” code environment. To do so, as an Administrator, go to “Administration > Code envs > Internal envs setup”, look for “External Models code environment”, and click on “Create code environment”.

You can then create an External Model by going to a project, click on the “Saved Models” link in the navigation bar, and, from the saved models page, click on the “New External Saved Model” button.

You can also create an External Saved Model using the public Python API, with `dataikuapi.dss.DSSProject.create_external_model()` and `dataikuapi.dss.DSSSavedModel.create_external_model_version()`.

Note

Most cloud vendors impose few constraints on models, and endpoints are allowed to behave in arbitrary ways and most noticeably to return any kind of data.

It is thus not possible to guarantee compatibility or unfettered ability to use all features (notably advanced features such as performance evaluation, model comparison or drift analysis) for all models.

See [Input and output formats](<input-output-formats.html>) for more details.

Warning

External Models can not be included in an API package. External Models can not be exported.

---

## [mlops/external-models/input-output-formats]

# Input and output formats  
  
DSS provides support for common input/output formats used by cloud vendors:

Warning

Many input formats do not offer a way to provide column names. For those formats, endpoints rely on the field order. Please be extra careful to ensure that the order of your dataset columns matches what the endpoint expects.

## Amazon SageMaker

### Supported input formats

  * `INPUT_SAGEMAKER_CSV`: SageMaker - CSV
        
        # Sample input dataframe:
        Pclass   Age  SibSp  Parch   Fare
        200     22.0      1      0   7.2500
        200     38.0      1      0   71.2833
        
        # Corresponding request body:
        200,22.0,1,0,7.25
        200,38.0,1,0,71.2833
        

  * `INPUT_SAGEMAKER_JSON`: SageMaker - JSON
        
        # Sample input dataframe:
        col_1  col_2  col_3
         3      49     13
         2      68     30
        
        # Corresponding request body:
        {
          "instances": [
            {
              "features": [
                3,
                49,
                13
              ]
            },
            {
              "features": [
                2,
                68,
                30
              ]
            }
          ]
        }
        

  * `INPUT_SAGEMAKER_JSON_EXTENDED`: SageMaker - JSON (Extended)
        
        # Sample input dataframe:
        col_1  col_2  col_3
         3      49     13
         2      68     30
        
        # Corresponding request body:
        {
          "instances": [
            {
              "data": {
                "features": {
                  "values": [
                    3,
                    49,
                    13
                  ]
                }
              }
            },
            {
              "data": {
                "features": {
                  "values": [
                    2,
                    68,
                    30
                  ]
                }
              }
            }
          ]
        }
        

  * `INPUT_SAGEMAKER_JSONLINES`: SageMaker - JSONLINES
        
        # Sample input dataframe:
        col_1  col_2  col_3
         3      49     13
         2      68     30
        
        # Corresponding request body (one JSON-formatted record per row):
        {"features": [3, 49, 13]}
        {"features": [2, 68, 30]}
        

  * `INPUT_DEPLOY_ANYWHERE_ROW_ORIENTED_JSON`: Deploy Anywhere - Row oriented JSON
        
        # Sample input dataframe:
        col_1  col_2  col_3
         3      49     13
         2      68     30
        
        # Corresponding request body:
        {
          "items": [
            {
              "features": {
                "col_1": 3,
                "col_2": 49,
                "col_3": 13
              }
            },
            {
              "features": {
                "col_1": 2,
                "col_2": 68,
                "col_3": 30
              }
            }
          ]
        }
        




### Supported output formats

  * `OUTPUT_SAGEMAKER_CSV`: SageMaker - CSV
        
        # Sample response, binary prediction, 2 rows:
        0
        1
        
        # Sample response, binary prediction, with probabilities, 2 rows:
        0,"[0.9992051720619202, 0.0007948523852974176]"
        1,"[0.0008897185325622559, 0.9991102814674377]"
        

  * `OUTPUT_SAGEMAKER_ARRAY_AS_STRING`: SageMaker - Array as string
        
        # Sample response, binary prediction, 2 rows:
        [0,1]
        
        # Sample response, binary prediction, no leading square brackets, 2 rows:
        0,1
        

  * `OUTPUT_SAGEMAKER_JSON`: SageMaker - JSON
        
        # Sample response, multiclass prediction (4 classes) with probabilities, 2 rows:
        {
          "predictions": [
            {
              "score": [
                0.2609631419181824,
                0.24818938970565796,
                0.19304637610912323,
                0.29780113697052
              ],
              "predicted_label": 3
            },
            {
              "score": [
                0.29569414258003235,
                0.23015224933624268,
                0.19619841873645782,
                0.27795517444610596
              ],
              "predicted_label": 0
            }
          ]
        }
        

  * `OUTPUT_SAGEMAKER_JSONLINES`: SageMaker - JSONLINES
        
        # Sample response, multiclass prediction (4 classes) with probabilities, 2 rows:
        {"score": [0.2609631419181824, 0.24818938970565796, 0.19304637610912323, 0.29780113697052], "predicted_label": 3}
        {"score": [0.29569414258003235, 0.23015224933624268, 0.19619841873645782, 0.27795517444610596], "predicted_label": 0}
        

  * `OUTPUT_DEPLOY_ANYWHERE_JSON`: Deploy Anywhere - JSON
        
        # Sample response, multiclass prediction (4 classes) with probabilities, 2 rows:
        {
          "results": [
            {
              "probas": {
                "0": 0.2609631419181824,
                "1": 0.24818938970565796,
                "2": 0.19304637610912323,
                "3": 0.29780113697052
              },
              "prediction": "3"
            },
            {
              "probas": {
                "0": 0.29569414258003235,
                "1": 0.23015224933624268,
                "2": 0.19619841873645782,
                "3": 0.27795517444610596
              },
              "prediction": "0"
            }
          ]
        }
        




## Azure Machine Learning

### Supported input formats

  * `INPUT_AZUREML_JSON_INPUTDATA`: Azure ML - JSON (input_data)
        
        # Sample input dataframe:
        Pclass   Age  SibSp  Parch   Fare
        200     22.0      1      0   7.2500
        200     38.0      1      0   71.2833
        
        
        # Corresponding request body:
        {
          "input_data": [
            [
              200,
              22,
              1,
              0,
              7.25
            ],
            [
              200,
              38,
              1,
              0,
              71.2833
            ]
          ]
        }
        

  * `INPUT_AZUREML_JSON_INPUTDATA_DATA`: Azure ML - JSON (input_data with data and columns)
        
        # Sample input dataframe:
        x1_var  x2_var  x3_var
         12      74      19
         15      64      8
        
        # Corresponding request body:
        {
          "input_data": {
            "columns": [
              "x1_var",
              "x2_var",
              "x3_var"
            ],
            "data": [
              [
                12,
                74,
                19
              ],
              [
                15,
                64,
                8
              ]
            ]
          }
        }
        

  * `INPUT_AZUREML_JSON_WRITER`: Azure ML - JSON (Inputs/data)
        
        # Sample input dataframe:
        Pclass   Age  SibSp  Parch   Fare
        200     22.0      1      0   7.2500
        200     38.0      1      0   71.2833
        
        # Corresponding request body:
        {
          "Inputs": {
            "data": [
              {
                "Pclass": 200,
                "Age": 22,
                "SibSp": 1,
                "Parch": 0,
                "Fare": 7.25
              },
              {
                "Pclass": 200,
                "Age": 38,
                "SibSp": 1,
                "Parch": 0,
                "Fare": 71.2833
              }
            ]
          },
          "GlobalParameters": {
            "method": "predict_proba"
          }
        }
        

  * `INPUT_DEPLOY_ANYWHERE_ROW_ORIENTED_JSON`: Deploy Anywhere - Row oriented JSON
        
        # Sample input dataframe:
        col_1  col_2  col_3
         3      49     13
         2      68     30
        
        # Corresponding request body:
        {
          "items": [
            {
              "features": {
                "col_1": 3,
                "col_2": 49,
                "col_3": 13
              }
            },
            {
              "features": {
                "col_1": 2,
                "col_2": 68,
                "col_3": 30
              }
            }
          ]
        }
        




### Supported output formats

  * `OUTPUT_AZUREML_JSON_OBJECT`: Azure ML - JSON (Object)
        
        # Sample response, binary prediction, 2 rows:
        {
          "Results": [
            [
              0.9611595387201834,
              0.03884045978970049
            ],
            [
              0.04262458780881131,
              0.9573754121911887
            ]
          ]
        }
        

  * `OUTPUT_AZUREML_JSON_ARRAY`: Azure ML - JSON (Array)
        
        # Sample response, regression, 2 rows:
        [273.7416544596354, 279.99419962565105]
        

  * `OUTPUT_DEPLOY_ANYWHERE_JSON`: Deploy Anywhere - JSON
        
        # Sample response, multiclass prediction (4 classes) with probabilities, 2 rows:
        {
          "results": [
            {
              "probas": {
                "0": 0.2609631419181824,
                "1": 0.24818938970565796,
                "2": 0.19304637610912323,
                "3": 0.29780113697052
              },
              "prediction": "3"
            },
            {
              "probas": {
                "0": 0.29569414258003235,
                "1": 0.23015224933624268,
                "2": 0.19619841873645782,
                "3": 0.27795517444610596
              },
              "prediction": "0"
            }
          ]
        }
        




## Google Vertex AI

### Supported input formats

  * `INPUT_VERTEX_DEFAULT`: Vertex - default
        
        # Sample input dataframe:
        Pclass   Age  SibSp  Parch   Fare
        200     22.0      1      0   7.2500
        200     38.0      1      0   71.2833
        
        # Corresponding request body:
        {
          "instances": [
            {
              "Pclass": "200",
              "Age": "22.0",
              "SibSp": "1",
              "Parch": "0",
              "Fare": "7.25"
            },
            {
              "Pclass": "200",
              "Age": "22.0",
              "SibSp": "1",
              "Parch": "0",
              "Fare": "7.25"
            }
          ]
        }
        




### Supported output formats

  * `OUTPUT_VERTEX_DEFAULT`: Vertex - default
        
        # Sample response, binary prediction, 2 rows
        [
          {
            "classes": [
              "0",
              "1"
            ],
            "scores": [
              0.8098086714744568,
              0.190191388130188
            ]
          },
          {
            "classes": [
              "0",
              "1"
            ],
            "scores": [
              0.8098086714744568,
              0.190191388130188
            ]
          }
        ]
        




## Databricks

### Supported input formats

  * `INPUT_RECORD_ORIENTED_JSON`: Databricks - Record oriented JSON
        
        # Sample input dataframe:
        Pclass   Age  SibSp  Parch   Fare
        200     22.0      1      0   7.2500
        200     38.0      1      0   71.2833
        
        # Corresponding request body:
        {
            "dataframe_records": [
                {
                    "Pclass": 200,
                    "Age": 22.0,
                    "SibSp": 1,
                    "Parch": 0,
                    "Fare": 7.25
                },
                {
                    "Pclass": 200,
                    "Age": 38.0,
                    "SibSp": 1,
                    "Parch": 0,
                    "Fare": 71.2833
                }
            ]
        }
        

  * `INPUT_SPLIT_ORIENTED_JSON`: Databricks - Split oriented JSON
        
        # Sample input dataframe:
        Pclass   Age  SibSp  Parch   Fare
        200     22.0      1      0   7.2500
        200     38.0      1      0   71.2833
        
        # Corresponding request body:
        {
            "dataframe_split": [{
                "index": [0, 1],
                "columns": ["Pclass", "Age", "SibSp", "Parch", "Fare"],
                "data": [[200, 22.0, 1, 0, 7.25], [200, 38.0, 1, 0, 71.2833]]
            }]
        }
        

  * `INPUT_TF_INPUTS_JSON`: Databricks - TF Inputs JSON
        
        # Sample input dataframe:
        Pclass   Age  SibSp  Parch   Fare
        200     22.0      1      0   7.2500
        200     38.0      1      0   71.2833
        
        # Corresponding request body:
        {
            "inputs": {
                "Pclass": [200, 200],
                "Age": [22.0, 38.0],
                "SibSp": [1, 1],
                "Parch": [0, 0],
                "Fare": [7.25, 71.2833]
            }
        }
        

  * `INPUT_TF_INSTANCES_JSON`: Databricks - TF Instances JSON
        
        # Sample input dataframe:
        Pclass   Age  SibSp  Parch   Fare
        200     22.0      1      0   7.2500
        200     38.0      1      0   71.2833
        
        # Corresponding request body:
        {
            "instances": [
                {
                    "Pclass": 200,
                    "Age": 22.0,
                    "SibSp": 1,
                    "Parch": 0,
                    "Fare": 7.25
                },
                {
                    "Pclass": 200,
                    "Age": 38.0,
                    "SibSp": 1,
                    "Parch": 0,
                    "Fare": 71.2833
                }
            ]
        }
        

  * `INPUT_DATABRICKS_CSV`: Databricks - CSV
        
        # Sample input dataframe:
        Pclass   Age  SibSp  Parch   Fare
        200     22.0      1      0   7.2500
        200     38.0      1      0   71.2833
        
        # Corresponding request body:
        200,22.0,1,0,7.25
        200,38.0,1,0,71.2833
        




### Supported output formats

  * `OUTPUT_DATABRICKS_JSON`: Databricks - JSON
        
        # Sample response, binary prediction without probabilities, 2 rows:
        {
            "predictions": [0, 1]
        }
        
        
        # Sample response, binary prediction with probabilities, 2 rows:
        {
            "predictions": [0, 1],
            "probability": [[0.9611595387201834, 0.03884045978970049], [0.04262458780881131, 0.9573754121911887]]
        }
        
        # or:
        {
            "predictions": [0, 1],
            "probabilities": [[0.9611595387201834, 0.03884045978970049], [0.04262458780881131, 0.9573754121911887]]
        }
        
        # or:
        {
            "predictions": [[0.9611595387201834, 0.03884045978970049], [0.04262458780881131, 0.9573754121911887]]
        }

---

## [mlops/feature-store/index]

# Feature Store

A core expectation of MLOps is to accelerate the deployment of models. A key part of this acceleration is to build efficient models faster. This can be achieved by using the most relevant data without heavy preparation, especially if this preparation is repeated. Helping Data Scientists to build, find and use this relevant data is the core notion of a _Feature Store_.

In order to implement such an approach in DSS, there are many capabilities at hand:

  * Feature Storage is handled by Dataiku extensive [Connections Library](<../../connecting/connections.html>)

  * Data Ingestion and Curation is performed using [Recipes in the Flow](<../../flow/index.html>)

  * Offline serving for batch processing is done using [Join Recipes](<../../other_recipes/join.html>) in [projects deployed on an Automation node](<../../deployment/index.html>)

  * Online serving for realtime processing is done using [Dataset Lookups](<../../apinode/endpoint-dataset-lookup.html>) in API services

  * Data monitoring is implemented using [Metrics & Checks](<../../metrics-check-data-quality/index.html>)

  * Automated building and maintenance is managed by [Scenarios and Triggers](<../../scenarios/index.html>)




In DSS, the _Feature Store_ section is actually the central registry of all _Feature Groups_ , a _Feature Group_ being a curated and promoted Dataset containing valuable _Features_.

Note

If you are interested in building a complete Feature Store solution within Dataiku, you can read [our hands-on article in our Knowledge Base](<https://knowledge.dataiku.com/latest/ml/feature-store/tutorial-building-feature-store.html>).

## Creating a Feature Group

A Feature Group is a curated DSS Dataset that is shared across your entire instance. In order to create Feature Groups:

  * Create a dataset containing the features, either by direct definition or using recipes

  * Set this dataset as a feature group




Note

Defining Feature Groups requires the “Manage Feature Store” permission.

In order to streamline the usage of Feature groups by other teams and projects, it is recommend to have as often as possible the underlying Datasets be either _Quickly Shareable_ or with _Request access_ activated (see [Shared Objects](<../../security/shared-objects.html>)).

## Feature Store

The Feature Store is available through the “nine dots” menu.

From this main screen, you can search and see information on the Feature Groups:

  * The left panel allows to refine the search on various criteria

  * The central panel shows the Feature Groups with the main data

  * When clicking on a line in this central panel, the right panel shows details on the Feature Group such as its description, details on its content and its usage




Note

You may experience a latency of a few seconds before a Feature Group appears in the Feature Store and is usable.

## Using a Feature Group

As a user of the Feature Store, you have a “Use” button in the right panel when the Feature Group is selected. This button allows to add this specific Feature Group into your project.

You will then be invited to select the target project(s) in which the Feature Group should be added as a dataset. As explained above, leveraging the Request Access and Quick Share options makes this easier.

The Feature Group can then be used as any other dataset. It appears in the flow with a medal overlay in the lower right corner.

## Removing a Feature Group

To remove a Feature Group, click on the “Remove” button. This action will not delete the underlying Dataset. Similarly, all existing sharings of the underlying dataset will remain fully working. Removing a Feature Group essentially means that it will not be available in the Feature Store for future users.

---

## [mlops/index]

# MLOps

Dataiku offers numerous capabilities for implementing a complete MLOps practice:

  * [The Flow](<../flow/index.html>) offers full lineage and traceability on the design on models

  * [Deploying projects to production with full CI/CD capabilities](<../deployment/index.html>)

  * [Visual Machine Learning](<../machine-learning/index.html>)

  * [Real-time REST API scoring server with versioning](<../apinode/index.html>)

  * [Exporting models to Python, Java, MLflow and PMML for scoring outside of DSS](<../machine-learning/models-export.html>)

  * [Comparing models, models versions and behavior of models over time](<model-comparisons/index.html>)

  * [Performing advanced drift analysis](<drift-analysis/index.html>)

  * [Test scenarios](<../scenarios/test_scenarios.html>) provide the ability to test parts of a project flow, webapps and run Python unit tests.




This section focuses on the following MLOps-specific capabilities:

  * Curating features in a Feature Store

  * Evaluating and comparing models and model versions

  * Analyzing drift

  * Importing models from external Machine Learning systems

  * Tracking code experiments

  * Monitoring projects, endpoints and models health

  * Checking Project Standards

  * Compute AI Types




Note

To get started with MLOps, you may wish to first try the [MLOps Quick Start](<https://knowledge.dataiku.com/latest/getting-started/tasks/mlops/quick-start-index.html>) and other resources on MLOps and operationalization in the [Knowledge Base](<https://knowledge.dataiku.com/latest/deploy/index.html>).

---

## [mlops/mlflow-models/importing]

# Importing MLflow models

You can import an [MLflow Model](<https://www.mlflow.org/docs/2.17.2/models.html>) into DSS as a Saved Model:

  * through the Python API (see [`dataikuapi.dss.project.DSSProject.create_mlflow_pyfunc_model()`](<https://developer.dataiku.com/latest/api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_mlflow_pyfunc_model> "\(in Developer Guide\)"))

  * using the “Deploy” action available for logged models in Experiment Tracking’s runs (see [Deploying MLflow models](<../experiment-tracking/deploying.html>))

  * import an MLflow model from a Databricks registry ( [Workspace Registry](<https://docs.databricks.com/en/mlflow/model-registry.html>) or [Unity Catalog](<https://docs.databricks.com/en/data-governance/unity-catalog/index.html>) )




## Importing an MLflow model through the Python API

This section focuses on the deployment through the API. It assumes that you already have a MLflow model in a _model_directory_ , i.e. a local folder on the local filesystem, or a _Managed Folder_.

This section also assumes that you already have a [code environment](<../../code-envs/index.html>) including core packages, MLflow, scikit-learn, statsmodels, as well as the Machine Learning package you used to train your model, in the version recommended by MLflow. The Python version of this code environment should be 3.7 or higher. Please refer to [Limitations and supported versions](<limitations.html>) for information on supported versions.

The steps are then:

  1. Create a DSS Saved Model using [`dataikuapi.dss.project.DSSProject.create_mlflow_pyfunc_model()`](<https://developer.dataiku.com/latest/api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_mlflow_pyfunc_model> "\(in Developer Guide\)")

  2. Import the MLflow model into the Saved Model using [`dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_path()`](<https://developer.dataiku.com/latest/api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_path> "\(in Developer Guide\)") or [`dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_managed_folder()`](<https://developer.dataiku.com/latest/api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_managed_folder> "\(in Developer Guide\)")

  3. Use the returned MLflow handler to set metadata and evaluate the DSS Saved Model: `dataikuapi.dss.savedmodel.MLFlowVersionHandler()`




Note

You may specify a code environment when importing a project. If not, the **current** code environment defined for the project will be resolved and used.
    
    
    import dataiku
    
     # if using API from inside DSS
    client = dataiku.api_client()
    
    project = client.get_project("PROJECT_ID")
    
    # 1. Create DSS Saved Model
    saved_model = project.create_mlflow_pyfunc_model(name, prediction_type)
    
    # 2. Load the MLflow Model as a new version of DSS Saved Model
    ## either from DSS host local filesystem:
    mlflow_version = saved_model.import_mlflow_version_from_path('version_id', model_directory, 'code-environment-to-use')
    ## or from a DSS managed folder:
    mlflow_version = saved_model.import_mlflow_version_from_managed_folder('version_id', 'managed_folder_id', path_of_model, 'code-environment-to-use')
    
    # 3. Evaluate the saved model version
    # (Optional, only for regression or classification models with tabular input data, mandatory to have access to the saved model performance tab)
    mlflow_version.set_core_metadata(target_column, classes, evaluation_dataset_name)
    mlflow_version.evaluate(evaluation_dataset_name)
    

Note

You may also use the API to import models trained in experiment runs, as any model stored in a managed folder.

Note

**Features Handling:** For MLflow Models, string and boolean features will be considered **Categorical**.

## Importing an MLflow model from a Databricks registry

Another option to import an MLflow model is to select it directly in your Databricks registry from the Interface and ask Dataiku to import it for you.

Your first step is to ensure you have a valid connection to your Databricks workspace. This is done by an administrator in the Administration > Connections, by creating a connection of type “Databricks Model Depl.”.

Once this connection is created and working, you can go to any project, in the Saved Models section. Click on the button ‘+NEW SAVED MODEL’ and select the option to create a custom model.

Fill in the information and create the Saved Model. At this point, you have an empty shell to add versions to. We are creating a version by importing it from Databricks, but you can mix any of the options mentioned at the top of this article (for example, the first version might be imported from Databricks but the next one might come from Dataiku Experiment Tracking).

Next, from the Saved Model screen, click on the button to create a Saved Model Version from a Databricks registry.

You will be presented with the window to enter information on where to load the MLflow model from:

  * Select the Databricks connection that was created (this will trigger Dataiku to list all the models registered in the configured Databricks account)

  * By default, models are fetched from Databricks Model Registry, check the option if you would rather import from Unity Catalog

  * You can then select the model and the version you want to import




The rest of the creation process is standard to all MLflow import:

  * Enter the details of the Saved Model Version you are going to create. Pay special attention to the Code Env used as it needs to contains all the packages required by your MLflow model

  * The Evaluation section is optional, although we strongly recommend to use it with a relevant dataset to have all the Evaluation and Performances screens




Once validated, Dataiku will perform all the operations for you. At the end, you will have a fully working Dataiku Saved Model Version.

Note

The lineage to actual Databricks model & version imported is stored and displayed in the Summary seciton of a Saved Model Version (this is also true when importing from Experiment Tracking).

Alternatively, you can also make a direct import from Databricks using Dataiku’s Python API. The process is the same as explained at the top of this article except the actual import call is done using the method [`dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_databricks()`](<https://developer.dataiku.com/latest/api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_databricks> "\(in Developer Guide\)"). You still need to have a working Databricks connection beforehand.
    
    
    import dataiku
    
     # if using API from inside DSS
    client = dataiku.api_client()
    
    project = client.get_project("PROJECT_ID")
    
    # 1. Create DSS Saved Model
    saved_model = project.create_mlflow_pyfunc_model(name, prediction_type)
    
    # 2. Load the MLflow Model as a new version of DSS Saved Model from Databricks
    mlflow_version = saved_model.import_mlflow_version_from_databricks('version_id', 'connection_name', 'use_unity_catalog', 'model_name', 'model_version', 'code_env_name')
    
    # 3. Evaluate the saved model version
    # (Optional, only for regression or classification models with tabular input data, mandatory to have access to the saved model performance tab)
    mlflow_version.set_core_metadata(target_column, classes, evaluation_dataset_name)
    mlflow_version.evaluate(evaluation_dataset_name)

---

## [mlops/mlflow-models/index]

# MLflow Models

[MLflow](<https://www.mlflow.org>) is an open-source platform for managing the machine learning lifecycle.

MLflow offers a standard format for packaging trained machine learning models: [MLflow Models](<https://www.mlflow.org/docs/2.17.2/models.html>).

You can import MLflow models in DSS, as DSS saved models. This allows you to benefit from all of the ML management capabilities of DSS on your existing MLflow models:

  * Scoring datasets using a [scoring recipe](<../../machine-learning/supervised/explanations.html#explanations-scoring-recipe-label>)

  * Deploying the model in a bundle on an automation node. See [Production deployments and bundles](<../../deployment/index.html>)

  * Deploying the model for real-time scoring, using the [API node](<../../apinode/index.html>)

  * Managing multiple versions of the models

  * Evaluating the performance of a classification or regression model on a labeled dataset, including all results screens

  * Comparing multiple models or multiple versions of the model, using [Model Comparisons](<../model-comparisons/index.html>)

  * Analyzing performance and evaluating models [on other datasets](<../model-evaluations/index.html>)

  * [Analyzing drift](<../drift-analysis/index.html>) on the MLflow model

  * [Governing the MLflow model using the Govern Node](<../../governance/index.html>)




Note

The MLflow model import feature is supported, and Dataiku tests it with a variety of different MLflow models. Dataiku makes best effort to ensure that the advanced capabilities of its MLflow import support are compatible with the widest possible variety of MLflow models.

However, MLflow imposes extremely few constraints on models, and different MLflow models are allowed to behave in arbitrary non-standard ways and to return completely different kind of data.

It is thus not possible to guarantee unfettered ability to use all features (notably advanced features such as performance evaluation, model comparison or drift analysis) with all types of models.

---

## [mlops/mlflow-models/limitations]

# Limitations and supported versions

Dataiku makes best effort to ensure that the MLflow import capability is compatible with a wide variety of MLflow models.

However, MLflow imposes extremely few constraints on models, and different MLflow models are allowed to behave in arbitrary non-standard ways and to return completely different kind of data.

It is thus not possible to guarantee unfettered ability to use all features (notably advanced features such as performance evaluation, model comparison or drift analysis) with all types of models.

This page lists known compatibilities and incompatibilities

## Import and scoring

The MLflow model import capability and scoring recipes in “direct output” mode are usually compatible with MLflow models supporting the “pyfunc” variant.

As of September 2024, this has been tested with:

  * Python Function

  * H2O

  * Keras

  * Pytorch

  * Scikit-learn

  * TensorFlow 2

  * ONNX

  * MXNet Gluon

  * XGBoost

  * LightGBM

  * Catboost

  * Spacy

  * FastAI 2

  * Statsmodels

  * Prophet




Dataiku does not support R MLflow models nor Spark Mlflow models

The import of MLflow models in DSS was successfully tested with MLflow versions 2.17.2 (Python 3.8) and 2.22.0 (Python 3.10). Later versions may also work, but modifications of implementation details of MLflow may cause bugs. Version 2.17.2 (Python 3.9) should generally be preferred.

Warning

MLflow versions prior to 2.0.0 are no longer supported; versions 3.0 and above are not supported and may lead to compatibility issues.

The following ML packages are supported in the versions specified in the below table. When using one of these packages, you should create a code environment including:

  * dataiku core packages

  * the specified version(s) of the ML package(s)

  * scikit-learn==1.0.2

  * statsmodels==0.13.5

  * numpy<1.27


ML package | ML packages versions | MLflow version _(Python version)_ Recommended / Tested  
---|---|---  
CatBoost | catboost==1.2.5 | 2.17.2 _(3.9)_ / 2.22.0 _(3.10)_  
fast.ai 2 | fastai==2.7.10 | 2.17.2 _(3.9)_ / 2.22.0 _(3.10)_  
LightGBM | lightgbm>=3.0,<3.1 | 2.17.2 _(3.9)_ / 2.22.0 _(3.10)_  
ONNX | onnx==1.12.0 onnxruntime==1.12.0 (compatible ML package) | 2.17.2 _(3.9)_ / 2.22.0 _(3.10)_  
PyTorch | torch==1.13.0 torchvision==0.14 torchmetrics==0.11.0 pytorch-lightning==1.8.2 | 2.17.2 _(3.9)_ / 2.22.0 _(3.10)_  
TensorFlow 2 / Keras 2.13.1 | tensorflow==2.13.1 tensorflow-estimator==2.13.0 keras==2.13.1 | 2.17.2 _(3.9)_ / 2.22.0 _(3.10)_  
XGBoost | xgboost==1.7.6 | 2.17.2 _(3.9)_ / 2.22.0 _(3.10)_  
  
A code env for Pytorch should include, **in addition to dataiku core packages** :
    
    
    mlflow==2.17.2
    scikit-learn==1.0.2
    statsmodels==0.13.5
    torch==1.13.0
    torchvision==0.14
    torchmetrics==0.11.0
    pytorch-lightning==1.8.2
    

A code env for TensorFlow 2 / Keras 2.13.1 should include, **in addition to dataiku core packages** :
    
    
    mlflow==2.17.2
    scikit-learn==1.0.2
    statsmodels==0.13.5
    tensorflow==2.13.1
    tensorflow-estimator==2.13.0
    keras==2.13.1
    

## Evaluation

DSS also features the evaluation of regression or classification models on tabular input data. As of December 2023, this feature has been successfully tested in the following circumstances.

Please note that this is not a guarantee that you would necessarily be able to do the same, due to the high variability of models that can be saved (even within a single framework).

In all cases, the prediction_type should be set when importing the model. Please see below supported prediction types for the supported ML packages:

ML package | binary classification | multiclass classification | regression  
---|---|---|---  
CatBoost | ✓ | ✓ | ✓  
fast.ai 2 | ✗ | ✗ | ✓  
LightGBM | ✓ | ✓ | ✓  
ONNX | ✓ | ✓ | ✓  
PyTorch | ✓ | ✓ | ✓  
scikit-learn 1.0.2 | ✓ | ✓ | ✓  
TensorFlow 2 / Keras 2.13.1 | ✓ | ✓ | ✓  
XGBoost | ✓ | ✓ | ✓

---

## [mlops/mlflow-models/training]

# Training MLflow models

Just like any Python packages, you can use MLflow and the related frameworks in any DSS recipe, notebook, scenario, …

This allows you to train and save a MLflow model directly in DSS, which you can then [import as a saved model](<importing.html>) in order to leverage visual scoring, evaluation, drift analysis, …

Dataiku also features an integration of MLflow Experiment Tracking. When leveraging it, trained models are automatically stored in a configurable managed folder (see [Deploying MLflow models](<../experiment-tracking/deploying.html>)).

## Training a model

You can train the MLflow model either outside of DSS, in a [python recipe](<../../code_recipes/python.html>), in a [python notebook](<../../notebooks/python.html>), or using [Experiment Tracking](<../experiment-tracking/index.html>)…

The list of frameworks supported by MLflow is available in the [MLflow documentation](<https://mlflow.org/docs/2.17.2/models.html#built-in-model-flavors>). These include the most common libraries such as PyTorch, TensorFlow, Scikit-learn, etc.

## Saving the MLflow model

You need to export your model in a standard format, provided by MLflow Models, compatible with DSS.

MLflow provides a _save_model_ function for each supported [machine learning framework](<https://mlflow.org/docs/2.17.2/models.html#built-in-model-flavors>).

For instance, saving a Keras model using MLflow in a _model_directory_ will look like this:
    
    
    ... ommitted Keras model training code
    
    import mlflow
    mlflow.keras.save_model(model, model_directory)
    

You can then [import the exported model in DSS as a Saved Model](<importing.html>)

## Python recipe

The following snippet is a draft of a python recipe:

  * taking a train and an evaluation dataset as inputs

  * training a model

  * saving it in MLflow format

  * adding it as a new version to the saved model defined as output



    
    
    import os
    import shutil
    import dataiku
    
    from dataiku import recipe
    
    client = dataiku.api_client()
    
    project = client.get_project('PROJECT_ID')
    
    # get train dataset
    train_dataset = recipe.get_inputs_as_datasets()[0]
    evaluation_dataset = recipe.get_inputs_as_datasets()[1]
    
    # get output saved model
    sm = project.get_saved_model(recipe.get_output_names()[0])
    
    # get train dataset as a pandas dataframe
    df = train_dataset.get_dataframe()
    
    # get the path of a local managed folder where to temporarily save the trained model
    mf = dataiku.Folder("local_managed_folder")
    path = mf.get_path()
    
    model_subdir = "my_subdir"
    model_dir = os.path.join(path, model_subdir)
    
    if os.path.exists(model_dir):
        shutil.rmtree(model_dir)
    
    try:
        # ...train your model...
    
        # ...save it with package specific MLflow method (here, SKlearn)...
        mlflow.sklearn.save_model(my_model, model_dir)
    
        # import the model, creating a new version
        mlflow_version = sm.import_mlflow_version_from_managed_folder("version_name", "local_managed_folder", model_subdir, "code-env-with-mlflow-name")
    finally:
        shutil.rmtree(model_dir)
    
    # setting metadata (target name, classes,...)
    mlflow_version.set_core_metadata(target_column, ["class0", "class1",...] , get_features_from_dataset=evaluation_dataset.name)
    
    # evaluate the performance of this new version, to populate the performance screens of the saved model version in DSS
    mlflow_version.evaluate(evaluation_dataset.name)
    

Note

[Experiment Tracking](<../experiment-tracking/index.html>) features logging of models in a configurable, and not necessarily local, managed folder.

Note

_local_managed_folder_ should be a filesystem managed folder, on the DSS host, as we use the [`dataiku.Folder.get_path()`](<https://developer.dataiku.com/latest/api-reference/python/managed-folders.html#dataiku.Folder.get_path> "\(in Developer Guide\)") method to retrieve its path on the local filesystem then compute a directory path where the ML package can save the trained model.

Note

As this recipe uses a local managed folder, it should not be executed in a container.

Note

The 4th parameter of the [`dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_managed_folder()`](<https://developer.dataiku.com/latest/api-reference/python/ml.html#dataikuapi.dss.savedmodel.DSSSavedModel.import_mlflow_version_from_managed_folder> "\(in Developer Guide\)") is the name of the code environment to use when scoring the model. If not specified, the code environment of the project will be resolved and used.

This code environment must contain the mlflow package and the packages of the machine learning library of your choice.

Note

A “Run checks” scenario step must be used to run the checks defined for the saved model on the metrics evaluated on the new version.

Warning

Recent versions of MLflow feature an ``mlflow.evaluate`` function. This function is different from `dataikuapi.dss.savedmodel.MLFlowVersionHandler.evaluate()`. Only the later will populate the interpretation screens of a saved model version in DSS.

---

## [mlops/mlflow-models/using]

# Using MLflow models in DSS

## Scoring

[Scoring recipe](<../../machine-learning/supervised/explanations.html#explanations-scoring-recipe-label>) is available for MLflow saved models.

Two modes are available for scoring with an MLflow Saved Model:

  1. Direct output mode where DSS outputs directly what the MLflow model outputs.

  2. Restructure mode where DSS tries to interpret the model output.




## Evaluation

You can evaluate versions of MLflow Saved Models on any valid DSS dataset. Related functionalities are available:

  * Performance analysis

  * [Model Evaluation Store](<../model-evaluations/index.html>)

  * [Model Comparison](<../model-comparisons/index.html>)

---

## [mlops/model-comparisons/index]

# Model Comparisons

When designing a model, it is very common to successively build multiple models with different parameters to try to obtain the best possible model.

To understand if a model is better than another, models must be evaluated on some data for which the ground truth is known, so that one can compare the performance metrics they want to optimize across all the models. Therefore finding the best model requires comparing Model Evaluations.

Then, Models are deployed and used in “production”. Over time, the conditions in real life may drift compared to what was the reality at train time and thus have a possibly negative impact on how the model behaves. This is known as Model Drift.

There can be data drift, i.e. change in the statistic distribution of features, or concept drift, which is due to a modification of the relationship between features and the target.

To monitor model drift, it is necessary to gather new data from the production environments and possibly have ground truth associated with it. See [Automating model evaluations and drift analysis](<../model-evaluations/automating.html>) for more details.

Finally, one needs to dig into a statistical analysis of those production data.

To ease those processes, Data Scientists responsible for building and operating the models must be able to:

  * Compare Model Evaluations with one another to understand which model performs the best on a given dataset and why

  * Understand the settings that led to this model, to refine the training of the next model and continue their attempt to get a better one




Model Comparisons addresses these 2 needs by providing visual tools to compare the performance of several Model Evaluations, along with the initial parameters of their underlying model.

## Creating a comparison

Model Comparisons can compare model evaluations from any of the following three kinds (and can be created directly from there).

A comparison can compare a mix of different items and, at any time, the user can add new items to an existing comparison.

Model Comparisons may also be created empty directly from the menu. In this case, prediction type must be set carefully, because it cannot be changed afterward.

### Visual analysis model

After training different models in a Visual Analysis (please refer to the [Machine Learning Basics](<https://knowledge.dataiku.com/latest/ml/model-design/ml-basics/tutorial-index.html>) and to [Machine learning](<../../machine-learning/index.html>) for more information), it’s possible to select different models to compare across different sessions.

When models are selected, click on “Compare” in the mass action dropdown:

Then choose whether to create a new comparison or to add the selected models to an existing one:

### Saved Model version

Model Comparison can also include Saved Model Versions (i.e: versions from a model that is deployed in the Flow).

For example, this is useful to compare multiple versions of the same saved model, or when challenging a specific version of a saved model (champion) with newly created models in a visual analysis (challengers).

### Evaluations from Evaluation Stores

When you have [Model Evaluations in Evaluation Stores](<../model-evaluations/index.html>), you can add them to a Model Comparison.

This is available both for evaluations coming from DSS models or external models.

## Comparing Model Evaluations

Several screens are provided to compare models along different characteristics.

In the summary page, charts show different performance metrics of the models. More details about each Model Evaluation is shown in the table below: train date, algorithm, train dataset name, evaluation dataset name, …

Besides the summary page, there are two sections available: Performance & Model Information.

### Performance

This section provides additional charts depending on the type of prediction.

For classification models, calibration curve, ROC curve and density chart are available. For regression, a Scatter Plot is provided.

Comparing the calibration curve between 2 Model Evaluations

### Model Information

The model information section enables one to compare the model settings, to help understand how differences in the settings used when training the model can lead to differences in performance.

Comparing the feature handling between 4 models

## Challenging the champion

The Model Comparison provides a tool to facilitate the comparison of a specific model, the “Champion”, against all others, the “Challengers”. The champion may be the model currently deployed in production or simply the best performing at the moment.

From the summary page, one of the Model Evaluations can be configured as the “champion” by clicking on the corresponding button when hovering over it in the table.

Once a champion is defined, it is displayed with a specific icon on the performance charts, so that it can be quickly identified.

On the Model Information screens, instead of highlighting settings that are not the same for all models when there is no champion, the comparator will highlight the settings that differ from the ones used by the champion.

## Customizing the comparison

The display of the comparison may be customized using the “configure” button located at the top right of all comparison screens.

From the configuration modal, one may rename the different items, temporarily hide some, reorder them or change an item’s color.

Note

Changes that are set in this modal will then apply to all the screens of the current comparison.

Warning

Renaming an item will actually rename the underlying item.

## Limitations

All [prediction models](<../../machine-learning/supervised/index.html>) trained in Dataiku may be used in a Model Comparison. This includes binary classification, multi-class classification and regression models.

It’s also possible to:

  * add [MLflow models](<../mlflow-models/index.html>) imported as Saved Model Versions

  * add [External models](<../external-models/index.html>)

  * add Model Evaluations obtained by applying the Standalone Evaluation Recipe to the Evaluation dataset of a model




The following kinds of models are not supported for use in comparisons:

  * [Partitioned models](<../../machine-learning/partitioned.html>)

  * [Ensemble models](<../../machine-learning/ensembles.html>)

  * [Clustering models](<../../machine-learning/unsupervised/index.html>)

  * Computer vision models

  * Deep Learning models

  * MLflow models that are not tabular




Only evaluations from the same prediction type - binary classification, multi-class classification or regression - can be added to the same model comparison.

For evaluations that are the result of a Standalone Evaluation Recipe, the prediction type is specified in the settings of the recipe.

---

## [mlops/model-evaluations/analyzing-evaluations]

# Analyzing evaluation results

## The evaluations comparison

A Model Evaluation Store contains several Model Evaluations. Each Model Evaluation may contain performance metrics and drift analysis.

When you open the Model Evaluation store, you see all Model Evaluations in this store:

  * As a bar graph, when there are only 1 or 2 of them. In this case, you can select the metrics to display in the upper left combobox. You can also enlarge performance graphs by clicking on the opposing arrows at the upper right corner of each of them.




  * As a line graph when there are 3 or more of them. In this case, in addition to the settings available in the bar chart, you can also select which label is used as X in the graph and which combination of labels will be used to group model evaluation in lines (“Color”).




  * And as a table in all cases.




Each line of the table displays the name of the model evaluation, its labels, performance metrics if available and data drift metric if available.

## Model Evaluation details

The details of a Model Evaluation are presented in a similar way to a Version of a Saved Model.

The key difference between the display of a Model Evaluation and the display of a Saved Model Version is that:

  * For a Saved Model Version, performance is computed against the test set

  * For a Model Evaluation, performance is computed against the evaluation dataset




Specific to Model Evaluation is the [Drift Analysis section](<../drift-analysis/index.html>).

## Using evaluation labels

By default, a Model Evaluation has in its Metadata a collection of automatically added labels.

In order to add semantic to your evaluations, you can also add your own labels:

  * on the train and train time test datasets

  * on the evaluation dataset

  * when designing a model in the lab

  * in the train recipe of a model deployed in the flow

  * in the (Standalone) Evaluation Recipe




For a dataset, labels are implemented as tags, with key and value separated by a semicolon.

In the Lab, custom labels may be added in the Metadata section of the “Train / Test Set” tab of the design of a model.

In the Train recipe, custom labels may be added to the Metadata section.

In the (Standalone) Evaluation Recipe, custom labels may also be added to the Metadata section.

Note: the value of all those labels may be parameterized. You may use a project variable as a label value. That project variable will be evaluated:

  * when the model is trained in the lab or in the flow, pulling labels from the train and test datasets with those of the lab model design or of the training recipe

  * when the model is evaluated, pulling labels from the evaluated model version, the evaluation dataset and the (Standalone) Evaluation Recipe.




Leveraging the labeling system, one can obtain ME with custom labels implementing its specific semantic:

In this example, the train and test dataset were the same.

Those labels can then be used in the Evaluation store to customize the graphs. The X axis can, for instance, be the value of a custom label set at evaluation time. Those labels will be interpreted in the MES Evaluations tab:

  * as date and time, if they have the same format as dates in the above examples ;

  * as numerical, if convertible to numbers ;

  * else as text, lexicographically ordered.

---

## [mlops/model-evaluations/automating]

# Automating model evaluations and drift analysis

Interactively evaluating models is useful, but tracking the performance of a production model requires some level of automation.

## Metrics and Checks

The Model Evaluation Stores fully support DSS Metrics and Checks. Performance metrics and data drift metrics are saved as DSS metrics on each ME computation. You can therefore use metrics to, for instance, issue a warning or an error if one of those metrics falls too low (or rise too high in the case of the input data drift). See [Metrics](<../../metrics-check-data-quality/metrics.html>) and [Checks](<../../metrics-check-data-quality/checks.html>) for additional information.

## Scenarios and feedback loop

To monitor the performance of your model over time, you need to evaluate it on a regular basis. This can be done using [Automation scenarios](<../../scenarios/index.html>).

Performing a new evaluation (and writing it to the Evaluation store) is done using the usual “Build/Train” step, selecting the Evaluation Store as the output.

Depending on the output of the build, and whether a warning or an error was raised by a check, you may, for instance, send a message to your team or retrain your model and redeploy your model.

## Feedback loop

In most cases, in order to perform continuous evaluation and [Drift analysis](<../drift-analysis/index.html>), you will need to retrieve logs from API nodes in order to know what records are being scored.

You can use the [Audit Dispatching and Event Server](<../../operations/audit-trail/centralization-and-dispatch.html>) for this. This will give you a dataset containing all records scored on your API nodes, which can then be used as input of an Evaluation Recipe.

These records will not contain the “ground truth”. In some cases, you will be able to “reconcile the ground truth”. For example, if you are evaluating a churn prediction model, you can, after a couple of weeks/months, know whether each customer “ultimately churned”. Reconciling the ground truth with the prediction allows you to compute whether the model was right and to perform [Performance drift analysis](<../drift-analysis/performance-drift.html>).

Retrieving data from your production system and reconciling the ground truth will be specific to your organization but can usually be done through the Flow as a regular data analysis project.

---

## [mlops/model-evaluations/concepts]

# Concepts

## When training

When you train a machine learning model, a portion of the data is held out in order to _evaluate_ the performance of the machine learning model (this “held-out” data is then called the test set).

The result of this evaluation operation is what can be seen in the Results screens of the models:

  * Performance metrics

  * Confusion matrix

  * Decision charts

  * Density charts

  * Lift charts

  * Error deciles

  * Partial dependences

  * Subpopulation analysis

  * …




For more details on all possible result screens, see [Prediction Results](<../../machine-learning/supervised/results.html>)

Each time you train a model in the visual analysis, and each time you retrain a saved model through a training recipe, this produces a new version of the model and its associated evaluation.

## Subsequent evaluations

In addition to the evaluation that is automatically generated when training a model, it can be useful to evaluate a model on a different dataset, at a later time.

This is especially useful to detect [Drift](<../drift-analysis/index.html>), i.e. when a model does not perform as well anymore, usually because the external conditions have changed.

In DSS, creating subsequent evaluations is done using an _Evaluation recipe_. These evaluations are stored in a _Model Evaluation Store_

---

## [mlops/model-evaluations/dss-models]

# Evaluating Dataiku Prediction models

To evaluate a Dataiku Prediction model, you must create an Evaluation Recipe.

An Evaluation Recipe takes as inputs:

  * an evaluation dataset

  * a model




An Evaluation Recipe can have up to three outputs:

  * an Evaluation Store, containing the main Model Evaluation and all associated result screens

  * an output dataset, containing the input features, prediction and correctness of prediction for each record

  * a metrics dataset, containing just the performance metrics for this evaluation (i.e. it’s a subset of the Evaluation Store)




Any combination of those three outputs is valid.

Each time the Evaluation Recipe runs, a new Model Evaluation is added into the Evaluation Store.

Note

This applies both to models trained using [Dataiku visual machine learning](<../../machine-learning/supervised/index.html>) and [imported MLflow models](<../mlflow-models/index.html>)

## Configuration of the Evaluation Recipe

In this screen, you can:

  * Select the model version to evaluate. Default is the active version.

  * Set the human readable name of the evaluation. Defaults to date and time.

  * (Advanced) Override the unique identifier of the new Model Evaluation in the output Evaluation Store. Should only be used if you want to overwrite an evaluation. Default is a random string.




Other items in the Output block relate to the output dataset. The Metrics block controls what is output in the metrics dataset.

### Labels

Both the Evaluation Recipe and Standalone Evaluation Recipe allow the definition of labels that will be added to the computed Model Evaluation. Those labels may be useful to implement your own semantics. See [Analyzing evaluation results](<analyzing-evaluations.html>) for additional information.

### Sampling

Performance metrics are computed using a sample of the evaluation dataset. You can adjust the sampling parameters in the ‘Sampling’ section.

Note that the actual stored sample, used for drift analysis, uses additional sampling rules. See [Sampling strategies for drift analysis](<../drift-analysis/sampling.html>) for additional information.

### Custom Evaluation Metrics

The Evaluation Recipe allows you to write your own metrics in Python.

For each Custom Evaluation Metric, you must define a ‘score’ function that returns a single float representing the metric.

In addition to the ground truth and predictions, if your Evaluation Recipe outputs an Evaluation Store, the ‘score’ function will receive a reference dataframe. This dataframe is a sample from the test set used during the training of the evaluated model. This enables you to define, for instance, custom data drift metrics.

Code samples are available to help you get started with custom metrics more easily.

## Limitations

  * The model must be a non-partitioned Classification, Regression or [Time series Forecasting](<time-series-models.html>) model

  * Non-tabular MLflow inputs are not supported

  * Computer vision models are not supported

  * Deep Learning models are not supported

  * For [Time series Forecasting models](<time-series-models.html>), Input Data Drift, Prediction Drift and Custom Evaluation Metrics are not supported

---

## [mlops/model-evaluations/external-models]

# Evaluating other models

Note

This is a very advanced topic

It can happen that you have models that are completely custom, i.e. they are neither trained using [DSS Visual Machine Learning](<../../machine-learning/supervised/index.html>) nor [imported from MLflow models](<../mlflow-models/index.html>).

You can still benefit from the Model Evaluation framework of DSS for these models, and hence benefit from:

  * Models results screens

  * Drift analysis




Those models must be evaluated using a Standalone Evaluation Recipe (SER).

A SER has one input, the evaluation dataset, and one output, an Evaluation Store.

Each time the evaluation recipe runs, a new Model Evaluation is added into the Evaluation Store.

Since there is no model for a Standalone Evaluation Recipe, the evaluation dataset (input of the SER) must have a column containing the predicted values. In most cases, it also needs to have a column containing the “ground truth” (also known as the labels). However, even if you don’t have the ground truth, you can still use the Standalone Evaluation Recipe. In this case, results screens will not be available (because there is no ground truth to compare to), but input data drift analysis and prediction drift analysis remain possible.

## Configuration of the standalone evaluation recipe

In this screen, you can:

  * Set the human readable name of the evaluation. Defaults to date and time.

  * (Advanced) Override the unique identifier of the new Model Evaluation in the output Evaluation Store. Should only be used if you want to overwrite an evaluation. Default is a random string.




You also have to provide information on the model:

  * prediction type: binary, multiclass or regression

  * name of the column containing the predictions (mandatory)

  * name of the column containing labels (ground truth - not mandatory if “Don’t compute perf” is checked)

  * weights column (optional)




If the model is a classification, you need to specify the list of its classes. If it is also probabilistic, you need to specify the mapping from each class to the column of the evaluation dataset holding the probability for this class.

For binary classification models, you can also adjust the threshold and cost matrix settings.

### Labels

Both the Evaluation Recipe and Standalone Evaluation Recipe allow the definition of labels that will be added to the computed Model Evaluation. Those labels may be useful to implement your own semantics. See [Analyzing evaluation results](<analyzing-evaluations.html>) for additional information.

### Sampling

A Model Evaluation (ME) uses a sample of at most 20000 lines. By default, the 20000 first lines of the evaluation dataset will be used. You can adjust the sampling method, but the sample used by the ME will always have a maximal length of 20000 lines.

---

## [mlops/model-evaluations/index]

# Models evaluations

Evaluating a machine learning model consists of computing its performance and behavior on a set of data called the Evaluation set. Model evaluations are the cornerstone of MLOps capabilities. They permit [Drift analysis](<../drift-analysis/index.html>), [Model Comparisons](<../model-comparisons/index.html>) and [automating retraining of models](<automating.html>)

Evaluation of [LLMs](<../../generative-ai/evaluation.html>) and [Agents](<../../agents/evaluation.html>) uses similar concepts, adapted to the specificities of these use cases.

---

## [mlops/model-evaluations/time-series-models]

# Evaluating Dataiku Time Series Forecasting models

Creating an Evaluation Recipe for [Time series Forecasting models](<../../machine-learning/time-series-forecasting/index.html>) is similar to doing so for Classification and Regression models (see [Evaluating Dataiku Prediction models](<dss-models.html>)). This section highlights the key differences.

## Input dataset

The input dataset for the Evaluation Recipe should contain at least:

  * The time column

  * The time series identifiers columns (if any)

  * The target column

  * The external features columns (if any)




## Outputs

### Output dataset

The Evaluation Recipe computes the evaluation dataset by moving the forecast/evaluation window (of size _forecast horizon_) from the end of the input dataset to the beginning as many times as possible (given the size of the timeseries), or a fixed number of times if the **Max. nb. forecast horizons** is set.

### Metrics dataset

The output metrics dataset contains the computed metrics. If the input dataset contains multiple time series, choose between aggregated metrics (one single row, default) or per time series metrics (one row per series).

### Model Evaluation Store

The Model Evaluation Store and Model Evaluations work similarly to classification or prediction tasks (see [Analyzing evaluation results](<analyzing-evaluations.html>)), but there are a few important differences to be aware of:

  * For models predicting multiple time series, performance metrics at the model evaluation level are aggregated as described in [Explainability: Feature importance](<../../machine-learning/time-series-forecasting/results.html#forecasting-results-performance-metrics>). In addition to that, for metrics aggregated using an average, the Evaluation Recipe records the worst metrics values across all time series. These metrics are prefixed with “WORST” in the Model Evaluation Store screens.

  * Input Data Drift and Prediction Drift are not supported.




## Refitting for statistical models

Statistical models (ARIMA and Seasonal LOESS) can be refit on the input data before evaluation.

Warning

Evaluation with Seasonal LOESS only works with refitting enabled.

---

## [mlops/project-standards/index]

# Project Standards

Project Standards changes how Enterprise customers ensure the quality of their projects in Dataiku. It integrates automated quality control directly into Dataiku’s design, deployment, and Govern flows to reduce the manual back and forth needed to review.

Project Standards help large organizations:

  * **Define organization-wide best practices** : Incorporate predefined checks or create your own customized checks.

  * **Speed up project collaboration** : Strengthen your production environment by enforcing minimum quality thresholds for all deployments, whether through the Deployer or Govern Sign-off process. This significantly reduces manual quality controls, increasing scalability and enabling faster deployment of projects to automation.

  * **Reduce production issues** : Promote and enforce best practices in a controlled, automated environment before project deployment. Designers can address common project issues themselves, without relying on inconsistently applied manual review.

  * **Upskill teams building Dataiku projects** : Provide designers with interactive, in-product guidance that helps them understand and implement necessary changes to meet production-grade quality thresholds.




Note

Project Standards is only available with a Dataiku for Enterprise AI license.

## How it works

Instance administrators define organizational quality best practices using Project Standards checks. These checks are run and surfaced in a report during project design and at the start of the deployment journey (during bundle creation). Each check generates a severity, which communicates how important it is to meet corporate production standards.

Infrastructure administrators can choose to enforce project deployment controls based on Project Standards by defining the maximum acceptable severity level for a bundle to be deployable. They can also use Project Standards in conjunction with the Govern Sign Off process, as Project Standard report is synchronized automatically in Govern.

## How to start

The first thing to do is to import checks and include them in scopes. Admins can manage that in the [settings](<settings.html>).

Then, the checks can be run on projects or bundles and generate [reports](<reports.html>).

---

## [mlops/project-standards/reports]

# Project Standards reports

## Content

The Project Standards report is the summary of the checks run on your project. You can consult the result of each check and some additional information about the check.

They are divided into 4 sections:

  * **To review** : Checks that did not pass, organized by severity

  * **Success** : Checks that passed, requiring no further action

  * **Not applicable** : Checks that contain logic that does not apply to the project

  * **Error** : Checks that failed in execution due to an internal or plugin error




## Consult and (re)run a report

A Project Standard report can be associated with a project or a bundle.

### Project report

You can consult the last report in the flow, using the “Project Standards” buttons. You can also open the Project Standards page using the button “Check Project Standards” in the Bundles page.

In the report, there is a button to run or rerun the Project Standards checks. Once the new report is computed, it will be saved and will replace the old one.

Use this report to see if there are any issues with the project to fix and take action accordingly.

### Bundle report

The report is included in the bundle. If you open the bundle, you will see a tab “Project Standards” containing the report.

If Project Standards is configured, checks will automatically be run, and the report will be added when you create a new bundle. You can’t rerun a report in a bundle. You need to recreate a new bundle if you want to improve the report after fixing the issues.

You can consult the bundle report to see if there are any issues with the project to fix before publishing the bundle.

## Bundle report for deployer

On the project deployer, you can also configure your infrastructure to prevent deployments according to the Project Standards report. The report of the bundle will be analyzed before any deployment, and if the Project Standards policy is not respected, you can choose to:

  * Do nothing

  * Show a warning message

  * Block the deployment




You will find those options in the “Deployment policies” tab of the infrastructure.

---

## [mlops/project-standards/settings]

# Project Standards settings

You can manage your Project Standards settings in the Administration > Project Standards tab. Here, you can configure checks and scopes for Project Standards.

Important

You need to be a member of a group with the Administrator permission to see this page.

## Terminology

### Check specification

A check specification (or check spec) is a Python class that will verify if a project respects a good practice. It takes a project key as an input and returns a severity, a number between 0 and 5. A check specification can have other parameters in its config. If the project respects the standards, a severity of 0 will be returned. If the project has some issues, it will return a severity between 1 and 4, depending on the importance of the issue.

Check specifications are created using DSS [plugins](<../../plugins/index.html>). A check specification is a plugin component of the kind “Project Standards check spec”. You can add more check specifications in your DSS instance by importing or creating plugins containing “Project Standards check spec” components.

### Check

A check is an instantiation of a check specification. It has its own configuration, so you can import the same check specification multiple times and use different configs. In the settings, use the edit button of the check to update its name, description, or config.

## Settings sections

### Checks library

You will find in the checks library all the checks that have been imported into your instance. You can add, edit, or delete checks using the corresponding buttons.

A check can be created by importing a check specification. You will first select the plugin, then the check specification you want to import. You can import several check specifications at the same time. A freshly created check uses a default config. Edit the check if you want to change its config.

### Scopes

Admins can create scopes in Project Standards to organize their quality checks. Scopes are used to determine which set of checks should run for which set of projects. Scopes can be applied to a specific set of projects, or all projects in a specific folder or with a specific tag.

If a project is included in several scopes, the scope located higher has priority, and its checks will be run and included in the Project Standards report.

In all cases, you will have a Default scope. All projects that do not match any custom scope criteria will use this default scope. Note that you can have only this scope in your configuration; this means all projects will have the same setup.

### General parameters

You will find here other parameters related to Project Standards.

---

## [mlops/unified-monitoring/accessing-unified-monitoring]

# Accessing Unified Monitoring

Unified Monitoring is a component that sits along your Deployer. To access it, go to the Deployer (either local or remote depending on your instance configuration) > Monitoring.

## Overview

This page allows you to quickly see what needs your attention.

It displays a summary consisting of 3 panels:

  * The “Overview” panel displays a categorized count of what Unified Monitoring has detected.

  * The “Dataiku Projects” panel lists unhealthy deployed projects.

  * The “API Endpoints” panel lists unhealthy endpoints, either DSS-managed or external (on supported cloud platform).




If your endpoints and projects are all healthy, the “Dataiku Projects” and “API endpoints” panel will simply show a count of all elements.

If you see an unhealthy project or endpoint listed, you can click on it to see details about this project’s or endpoint’s health.

You can also click on “Dataiku Projects” or “API Endpoints” to go to the dedicated projects and endpoints screens, respectively.

---

## [mlops/unified-monitoring/api-endpoints]

# API Endpoints

The _API Endpoints_ screen lists all endpoints that Unified Monitoring can detect.

Unified Monitoring can monitor:

  * **Endpoints of API Services** : API Services deployed to an infrastructure defined in the Deployer, including third-party infrastructures (Amazon SageMaker, Google Vertex AI, Microsoft Azure Machine Learning, Databricks or Snowflake Snowpark Container Services). Also see [First API (with API Deployer)](<../../apinode/first-service-apideployer.html>).

  * **External Endpoints** : Endpoints deployed to third-party infrastructures, not managed by Dataiku. To see these endpoints, you need to declare additional “Monitoring Scopes” (only available to administrators) as detailed in [Unified Monitoring Settings](<unified-monitoring-settings.html>).




Every API Endpoint has a “Global Status” and a “Deployment Status”. It may also have a “Model Status” and a “Governance Status” if Unified Monitoring was able to link the endpoint to a DSS Saved Model.

Unified Monitoring also displays endpoint activity metrics for the last 24 hours, such as “Response time” (P95 response latency), “Volume” (number of calls to the endpoint), and an “Activity” graph of calls. These statistics require the **Activity server** to be correctly configured in the API infrastructure.

## Deployment Status

The Deployment Status of an API Endpoint is the health status of the endpoint, as reported by the underlying infrastructure.

## Model Status

The Model Status of an API Endpoint is the worst model status of all models matched to this API Endpoint.

Please see [Understanding Model Status](<model-status.html>) for more details.

Note

For External Endpoints, the Model Status can be computed only if this endpoint has a corresponding [External Model](<../external-models/index.html>)

## Governance Status

Note

Governance Status is only available if [Dataiku Govern](<../../governance/index.html>) is enabled and available in your license.

The Governance Status of an endpoint is computed based on the validation status of the deployed Saved Model Version in [Dataiku Govern](<../../governance/index.html>) and the “Govern check policy” configured for the infrastructure.

If the model version is **Approved** in Govern, the status is **Healthy**.

If the model version is in any other state (e.g., **In validation** , **Rejected**), the status depends on the “Govern check policy” of the underlying infrastructure:

  * **Warn** : The status is **Warning**.

  * **Prevent** : The status is **Error**.

  * **No check** : The status is **No Status**.




## Global Status

In addition to the three statuses detailed in the previous sections, every API Endpoint has a “Global status”, which is computed by taking the worst of “Deployment Status”, “Model Status”, and “Governance Status”.

## Activity Metrics

For every API Endpoint, Unified Monitoring will display activity metrics, if available.

Note

Activity metrics are retrieved on a best-effort basis, as there are a number of scenarios where DSS might not be able to retrieve anything, including (but not limited to):

  * Permission issues with the monitoring solution of the third-party cloud provider.

  * For Dataiku endpoints, disabling or not correctly configuring the “Monitoring” section of the infrastructure.

  * For External endpoints, disabling or not correctly configuring the monitoring solution of the third-party cloud provider.




## No longer available External Endpoints

If an External Endpoint, once monitored, is no longer detectable by Unified Monitoring (possibly due to its deletion from the cloud provider), it will be displayed in an error state.

To remove such API Endpoints from Unified Monitoring, click on the relevant row and click on the “Remove” button in the modal window that appears (only available to administrators).

---

## [mlops/unified-monitoring/dataiku-projects]

# Dataiku Projects

The _Dataiku Projects_ screen lists all deployed projects, i.e. project bundles that are deployed and active on an automation node.

By default, all project infrastructures are monitored. You can exclude an infrastructure from Unified Monitoring by going to _Settings_ (only available to administrators). Also see [Unified Monitoring Settings](<unified-monitoring-settings.html>)

Every project has a _Deployment Status_ , _Model Status_ , _Execution Status_ , _Data Status_ , _Governance Status_ , and _Global Status_.

## Deployment Status

This is the health status of the deployment, as reported by the Deployer.

## Model Status

The Model Status of a project represents the worst model status aggregated from all models in this project.

Please see [Understanding Model Status](<model-status.html>) for more details.

## Execution Status

The Execution Status of a project represents the worst execution status among all **enabled** scenarios and **auto-started** webapps in this project.

## Data Status

The Data Status of a project provides a condensed view of the most recent **Data Quality** rules execution. It reflects the worst outcome among all **active** rules.

For more details, please refer to the [Data Quality Rules](<../../metrics-check-data-quality/data-quality-rules.html>) documentation.

## Governance Status

Note

Governance Status is only available if [Dataiku Govern](<../../governance/index.html>) is enabled and available in your license.

The Governance Status of a project is computed based on the validation status of the deployed project bundle in [Dataiku Govern](<../../governance/index.html>) and the “Govern check policy” configured for the infrastructure.

If the bundle is **Approved** in Govern, the status is **Healthy**.

If the bundle is in any other state (e.g., **In validation** , **Rejected**), the status depends on the “Govern check policy” of the underlying infrastructure:

  * **Warn** : The status is **Warning**.

  * **Prevent** : The status is **Error**.

  * **No check** : The status is **No Status**.




## Global Status

In addition to the five statuses detailed in the previous sections, every project has a “Global status”, which is computed by taking the worst of “Deployment Status”, “Model Status”, “Execution Status”, “Data Status”, and “Governance Status”.

---

## [mlops/unified-monitoring/index]

# Unified Monitoring

Unified Monitoring provides out-of-the-box dashboards allowing you to monitor the health and status of Dataiku projects, DSS endpoints and other endpoints not managed in DSS (referred to as _External Endpoints_).

---

## [mlops/unified-monitoring/model-status]

# Understanding Model Status

To compute the model status of a given Saved Model, Unified Monitoring looks at all Model Evaluation Stores where this Saved Model serves as the input of an Evaluation Recipe.

Then, it looks at all checks of every Model Evaluation Store found.

For every check, Unified Monitoring only takes into account the latest check computation result.

The resulting aggregated model status is computed by taking the worst computation result of the aforementioned checks.

For more details about the Model Evaluation Store, including Metrics and Checks, please see [Models evaluations](<../model-evaluations/index.html>).

Note

For “Project” model status, Unified Monitoring will query directly the automation node where the project is deployed.

For “API Endpoint” model status, Unified Monitoring will query the design node where the API Package was built. In order for this status to be fetched properly, Unified Monitoring needs to query the node using its API and so needs the URL and an API key. If you are on Dataiku Cloud or using Fleet Manager, this is setup automatically. If you are using Dataiku Custom, an administrator needs to give the details in Administration > Settings > Deployer.

---

## [mlops/unified-monitoring/prometheus-integration]

# Prometheus Integration

Dataiku exposes Unified Monitoring health statuses as a Prometheus-compatible API. This allows you to integrate Unified Monitoring statuses into your existing monitoring infrastructure.

## Configuration

To scrape this data, you need to add a scrape configuration to your Prometheus configuration file (typically named `prometheus.yml`).

For more details, please refer to the [Prometheus official documentation](<https://prometheus.io/docs/prometheus/latest/configuration/configuration/>).

Below is a sample configuration you can reuse and adjust to your environment and needs.
    
    
    global:
      scrape_interval: 15s
      evaluation_interval: 15s
    
    scrape_configs:
      - job_name: 'dataiku-unified-monitoring'
        scheme: https
        metrics_path: '/public/api/unified-monitoring/deployer/metrics-prometheus'
        static_configs:
          - targets: ['<your-dss-host>:<port>'] # e.g., dataiku.example.com:443
    
        # Authentication using a Dataiku API Key
        bearer_token: '<YOUR_DATAIKU_API_KEY>'
    

## Available Statuses

The `/public/api/unified-monitoring/deployer/metrics-prometheus` endpoint exposes data representing the health status of your deployed projects and endpoints. All statuses are exposed as Prometheus metrics (**gauges**) with the following values:

  * `-1`: **NO_STATUS** (Data is not available or not applicable)

  * `0`: **HEALTHY**

  * `1`: **WARNING**

  * `2`: **ERROR**




### Project Statuses

The following statuses are available for **Projects**. For more details, see [Dataiku Projects](<dataiku-projects.html>).

  * `global_status`: The aggregated overall health status.

  * `deployment_status`: The health status of the deployment, as reported by the Deployer.

  * `models_status`: The worst model status aggregated from all models in the project. See [Understanding Model Status](<model-status.html>).

  * `execution_status`: Aggregated status of scenario executions and webapps.

  * `data_status`: Status of [Data Quality](<../../metrics-check-data-quality/index.html>).

  * `governance_status`: Status related to governance policies and sign-offs (requires [Dataiku Govern](<../../governance/index.html>)).




### Endpoint Statuses

The following statuses are available for **Endpoints**. For more details, see [API Endpoints](<api-endpoints.html>).

  * `global_status`: The aggregated overall health status.

  * `deployment_status`: The health status of the endpoint, as reported by the Deployer.

  * `model_status`: The worst model status of all models matched to the API endpoint. See [Understanding Model Status](<model-status.html>).

  * `governance_status`: Status related to governance policies and sign-offs (requires [Dataiku Govern](<../../governance/index.html>)).




### Labels

Statuses are enriched with Prometheus labels to allow for filtering and aggregation. Labels common to all object types include:

  * `type`: For projects, either `MULTI_AUTOMATION_NODE` or `AUTOMATION_NODE`. For endpoints, either `MANAGED_API_ENDPOINT`, or `EXTERNAL_API_ENDPOINT`.

  * `displayName`: The user-friendly name of the project or endpoint.

  * `deploymentId`: The unique identifier of the deployment.

  * `infrastructureId`: The ID of the target infrastructure (or the external endpoint scope name).




Other labels are available depending on the object type (`bundleName`, `deployedProjectKey`, `endpointName`, …)

---

## [mlops/unified-monitoring/synchronization-interval]

# Synchronization interval

Unified Monitoring orchestrates a set of scheduled tasks to gather data from monitored infrastructures and monitoring scopes at fixed interval.

This interval is set to 5 minutes (subject to change).

As a result, it may take some time for any change in status to be reflected on the Unified Monitoring dashboards.

---

## [mlops/unified-monitoring/unified-monitoring-alerting]

# Unified Monitoring Alerting

Note

This screen is only available to administrators

**Unified Monitoring Alerting** allows administrators to create automated alert notifications when a deployed service, project, or endpoint status changes.

You can set up alerts for any item that is monitored by Unified Monitoring: deployed API services, projects, and external endpoints hosted by other cloud providers.

## Alert scope

Alerts are defined at the **infrastructure** level. You can further refine the scope of each alert by filtering based on deployments, endpoints, tags, or other available attributes that define the monitored elements.

## Trigger conditions

Administrators can configure alerts to be triggered based on the following status changes:

  * **Any status change**

  * **When status becomes unhealthy**

  * **When status matches selected values**




## Alert reporter

To receive alerts when trigger conditions are met, you must assign a **reporter** , which defines how the alert is delivered. The following channels are supported:

  * **Email**

  * **Slack**

  * **Microsoft Teams**

  * **Webhook**




Each reporter type comes with a default alert template that highlights status changes for the monitored item.

Note

You can use existing channels configured in the **Global Settings** of Dataiku DSS, or set up new ones.

---

## [mlops/unified-monitoring/unified-monitoring-settings]

# Unified Monitoring Settings

Note

This screen is only available to administrators

The _Settings_ screen allows you to include or exclude project and endpoint infrastructures from monitoring.

When setting the slider to “off”, all monitoring on this infrastructure will stop and activity data will be erased. If you re-activate it in the future, monitoring will start again from scratch.

Additionally, you can configure “Monitoring Scopes” if you would like to monitor External Endpoints from third-party cloud providers.

To monitor External Endpoints, simply click on “New scope” and fill-in the required information for your cloud provider.

You may click on the “Test monitoring scope” button before creation, to get a list of accessible endpoints. Please note that additional permissions to access their activity metrics may be required.