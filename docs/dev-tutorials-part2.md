# Dataiku Docs — dev-tutorials

## [tutorials/machine-learning/experiment-tracking/keras-nlp/index]

# Experiment Tracking for NLP with Keras/Tensorflow

## Prerequisites

  * Dataiku >= 11.0

  * A Python code environment containing the following libraries (see supported versions [here](<https://doc.dataiku.com/dss/latest/mlops/mlflow-models/limitations.html>)):

    * [mlflow](<https://www.mlflow.org/docs/2.17.2/getting-started/intro-quickstart/index.html>),

    * [tensorflow](<https://www.tensorflow.org/install/pip>)

  * Possibility of dowloading the [Large Movie Review Dataset](<https://ai.stanford.edu/~amaas/data/sentiment/>).

  * Basic knowledge of Tensorflow/Keras.




## Introduction

In this tutorial, you will:

  1. Train multiple Keras text classifiers to predict whether a movie review is either positive or negative.

  2. Log those models in the MLflow format so that they can be compared using the Dataiku [Experiment Tracking interface](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/viewing.html>).




The present tutorial is an adaptation of this [basic text classification tutorial](<https://www.tensorflow.org/tutorials/keras/text_classification>). We recommend that you take a look at that tutorial prior to starting ours, especially if you’re not familiar with Tensorflow and Keras.

Although MLflow provides the [`mlflow.sklearn.log_model`](<https://www.mlflow.org/docs/2.17.2/python_api/mlflow.sklearn.html#mlflow.sklearn.log_model>) function to log models, you will rely on the more general [`mlflow.pyfunc.PythonModel`](<https://www.mlflow.org/docs/2.17.2/python_api/mlflow.pyfunc.html#mlflow.pyfunc.PythonModel>) module to enjoy greater flexibility and to circumvent a current limitation in the deployment of custom Keras pre-processing layers (more on this later). If needed, please consult our [`pyfunc` tutorial](<../xgboost-pyfunc/index.html>) to get familiar with that module.

## Downloading the data

The first step to training text classifiers is to obtain text data.

You will programmatically download the [Large Movie Review Dataset](<https://ai.stanford.edu/~amaas/data/sentiment/>) and decompress it into a **local** [managed folder](<https://doc.dataiku.com/dss/latest/connecting/managed_folders.html#creating-a-managed-folder>) in Dataiku. A [local managed folder](<https://doc.dataiku.com/dss/latest/connecting/managed_folders.html#local-vs-non-local>) is a folder that is hosted on the filesystem on the Dataiku machine, where your code runs.

To do so, create a python recipe:

  1. Leave the input field empty.

  2. Set its output to a new **local** managed folder (name that folder `aclImdb`).

  3. Edit the recipe with the following code (do not forget to change the folder id to that of your output folder).
         
         import dataiku
         from io import BytesIO
         from urllib.request import urlopen
         import tarfile
         
         folder = dataiku.Folder("YOUR_FOLDER_ID") # change to output folder id
         folder_path = folder.get_path()
         
         
         r = urlopen("https://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz")
         with tarfile.open(name=None, fileobj=BytesIO(r.read())) as t:
             t.extractall(folder_path)
         

  4. Run the recipe.




## Preparing the experiment

After downloading and decompressing the movie review archive, prepare the ground for the experiment tracking:

  1. Create a second Python recipe.

  2. Set its input to the managed `aclImdb` folder that contains the data.

  3. Set its output to a new output folder which can either be local or non-local. Name the output folder `experiments`.

  4. Create the recipe and change its code environment to one that satisfies the prerequisites laid out at the beginning of this tutorial.




The following code imports all libraries and defines constant variables, handles and function necessary to the training and tracking of Keras models. Copy and paste it while making sure to change the input folder id to your own input folder id.

For more information regarding experiment tracking in code, refer to our [documentation](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/tracking.html>).
    
    
    import dataiku
    import numpy as np
    from datetime import datetime
    import os
    import shutil
    import tensorflow as tf
    import re
    import string
    from tensorflow.keras import layers, losses
    from sklearn.model_selection import ParameterGrid
    
    # Replace these constants with your own values
    PREDICTION_TYPE = "BINARY_CLASSIFICATION"
    EXPERIMENT_FOLDER_ID = ""         # Replace with your output Managed Folder id (experiments)
    EXPERIMENT_NAME = ""              # Replace with your chosen experiment name
    MLFLOW_CODE_ENV_NAME = ""         # Replace with your code environment name
    SAVED_MODEL_NAME = ""             # Replace with your chosen model name    
    
    # Some utils
    def now_str() -> str:
        return datetime.now().strftime("%Y%m%d%H%M%S")
    
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    
    input_folder = dataiku.Folder('YOUR_FOLDER_ID') # change to input folder id (aclImdb)
    # Retrieve the path to the aclImbd folder. 
    input_folder_path = input_folder.get_path()
    
    # Create a mlflow_extension object to easily collect information for the promotion step
    mlflow_extension = project.get_mlflow_extension()
    
    # Get a handle on a Managed Folder to store the experiments.
    mf = project.get_managed_folder(EXPERIMENT_FOLDER_ID)
    
    # dictionary with path to save intermediary model
    artifacts = {
        SAVED_MODEL_NAME: "./keras_model_cnn.pth"
    }
    
    

In the rest of this tutorial, you will append more code snippets to that second recipe, starting with the creation of a train, an evaluation, and a test dataset. Only run the recipe at the end of the tutorial, after all snippets have been added.

At this stage, your Dataiku flow should look like this: 

## Converting raw text data to Tensorflow Datasets

Before you can start training and evaluating your Keras models, you will have to convert your data to 3 different[Tensorflow Datasets](<https://www.tensorflow.org/api_docs/python/tf/data/Dataset>) (train, evaluation and test).

The [`tf.keras.utils.text_dataset_from_directory()`](<https://www.tensorflow.org/api_docs/python/tf/keras/utils/text_dataset_from_directory>) function will allow to create such datasets from the different subfolders in your newly created `aclImdb` input folder.

Use the [Dataiku Folder API](<../../../../api-reference/python/project-folders.html>) to retrieve the `aclImdb` folder path and pass it to the `tf.keras.utils.text_dataset_from_directory()` functions.
    
    
    dataset_dir = os.path.join(input_folder_path, 'aclImdb')
    train_dir = os.path.join(dataset_dir, 'train')
    
    remove_dir = os.path.join(train_dir, 'unsup')
    if os.path.exists(remove_dir):
        shutil.rmtree(remove_dir)
    
    batch_size = 32
    seed = 42
    
    raw_train_ds = tf.keras.utils.text_dataset_from_directory(
        os.path.join(input_folder_path,'aclImdb/train'),
        batch_size=batch_size, 
        validation_split=0.2, 
        subset='training', 
        seed=seed)
    
    
    raw_val_ds = tf.keras.utils.text_dataset_from_directory(
        os.path.join(input_folder_path, 'aclImdb/train'), 
        batch_size=batch_size, 
        validation_split=0.2, 
        subset='validation', 
        seed=seed)
    
    raw_test_ds = tf.keras.utils.text_dataset_from_directory(
        os.path.join(input_folder_path, 'aclImdb/test'), 
        batch_size=batch_size)
    

## Preprocessing

The reviews were pulled from a website and contain html carriage-return tags (`<br />`). The following `custom_standardization()` function strips those tags, lower-case the reviews and remove any punctuation from them.

That function is then used as a preprocessing step in a vectorization layer.

Append the following code.
    
    
    @tf.keras.utils.register_keras_serializable()
    def custom_standardization(input_data):
        lowercase = tf.strings.lower(input_data)
        stripped_html = tf.strings.regex_replace(lowercase, '<br />', ' ')
        return tf.strings.regex_replace(stripped_html,
                                      '[%s]' % re.escape(string.punctuation),
                                      '')
    
    max_features = 10000
    sequence_length = 250
    
    vectorize_layer = layers.TextVectorization(
        standardize=custom_standardization,
        max_tokens=max_features,
        output_mode='int',
        output_sequence_length=sequence_length)
    
    # Make a text-only dataset (without labels), then call adapt
    train_text = raw_train_ds.map(lambda x, y: x)
    vectorize_layer.adapt(train_text)
    
    
    def vectorize_text(text, label):
        text = tf.expand_dims(text, -1)
        return vectorize_layer(text), label
    
    # vectorize 
    train_ds = raw_train_ds.map(vectorize_text)
    val_ds = raw_val_ds.map(vectorize_text)
    test_ds = raw_test_ds.map(vectorize_text)
    
    AUTOTUNE = tf.data.AUTOTUNE
    
    train_ds = train_ds.cache().prefetch(buffer_size=AUTOTUNE)
    val_ds = val_ds.cache().prefetch(buffer_size=AUTOTUNE)
    test_ds = test_ds.cache().prefetch(buffer_size=AUTOTUNE)
    

The `@tf.keras.utils.register_keras_serializable()` decorator makes that custom function [serializable](<https://www.tensorflow.org/api_docs/python/tf/keras/utils/register_keras_serializable>) which is a needed property to later be able to save that preprocessing layer as part of an MLflow model.

### Model Training and hyperparameter grid

Now define a function–`create_model()`–that will be used to create a [Sequential model](<https://keras.io/guides/sequential_model/>) from two different hyperparameters.

The `embedding_dim` hyperparameter determines the output dimension of the [Embedding layer](<https://keras.io/api/layers/core_layers/embedding/>) while the `dropout` hyperparameter determines the frequency (rate) at which the [Dropout layers](<https://keras.io/api/layers/regularization_layers/dropout/>) randomly set the input units to 0 as a way of mitigating overfitting.

The function makes it easier to test different model architecture and find the best hyperparameter combinations among a [scikit-learn hyperparameter grid](<https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.ParameterGrid.html>). While simple, the function could be improved to allow for more flexibility in the architecture design.

Add the following code to the end of your python recipe.
    
    
    def create_model(embedding_dim, 
                     dropout):
        
        model = tf.keras.Sequential([
          layers.Embedding(max_features + 1, embedding_dim),
          layers.Dropout(dropout),
          layers.GlobalAveragePooling1D(),
          layers.Dropout(dropout),
          layers.Dense(1)
          ])
    
        model.compile(loss=losses.BinaryCrossentropy(from_logits=True),
                  optimizer='adam',
                  metrics=tf.metrics.BinaryAccuracy(threshold=0.0))
        
        return model
    
    param_grid = {
        'embedding_dim':[16],
        'dropout':[0.1,0.2]
    }
    
    grid = ParameterGrid(param_grid)
    

This was the last step needed before you can run the experiment.

### Experiment runs

At last, add the following piece of code to the recipe and run the recipe. After a successful run, you will be able to deploy the model either [visually](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/viewing.html>) or [programmatically](<https://doc.dataiku.com/dss/latest/mlops/mlflow-models/importing.html>).

The following code can be split into the different steps:

  1. Create an `mlflow` context using the `setup_mlflow()` method from the Dataiku API.

  2. Create and experiment and add tags to it

  3. Loop through the list of hyperparameter combinations so that for each combination, you start a run in which you:

     * Create and train a model.

     * Collect trained model metrics on test set.

     * Create a `full_model` by prepending the preprocessing layer to the model.

     * Serialize + save that `full_model`. This is a necessary intermediary step.

     * Wrap that `full_model` in a `KerasWrapper` so that the model can be logged as an MLflow python function model.

     * Log the wrapper along with the collected metrics and other model metadata (hyperparemeters, epochs, code environment…).



    
    
    # 1 create the mlflow context
    with project.setup_mlflow(mf) as mlflow: 
    
        # 2 create experiment and add tags
        experiment_id = mlflow.create_experiment(
            f'{EXPERIMENT_NAME}_{now_str()}')
    
        mlflow.tracking.MlflowClient().set_experiment_tag(
            experiment_id, "library", "Keras")
    
        mlflow.tracking.MlflowClient().set_experiment_tag(
            experiment_id, "predictionType", "BINARY_CLASSIFICATION")
        
        # 3 Loop through combination of hyperparameter in grid
        for hparams in grid:
            with mlflow.start_run(experiment_id=experiment_id) as run:     
                # create model 
                print(f'Starting run {run.info.run_id} ...\n{hparams}')
                model = create_model(**hparams)
                print(model.summary())
    
                # train model 
                history = model.fit(
                    train_ds,
                    validation_data=val_ds,
                    epochs=10)
            
                # collect metrics
                run_metrics = {}
                for k,v in history.history.items():
                    run_metrics[f'mean_{k}'] = np.mean(v)
    
                # Bundle the model with the preprocessing layer
                full_model = tf.keras.Sequential([
                          vectorize_layer,
                          model,
                          layers.Activation('sigmoid')])
                
                full_model.compile(
                    loss=losses.BinaryCrossentropy(
                        from_logits=False), optimizer="adam", metrics=['accuracy'])
            
                # Serialize and save full model   
                full_model.save(artifacts.get(SAVED_MODEL_NAME))
    
                # Wrap the full model using the pyfunc module
                class KerasWrapper(mlflow.pyfunc.PythonModel):
                    def load_context(self, context):
                        import tensorflow as tf
                        @tf.keras.utils.register_keras_serializable()
                        def custom_standardization(input_data):
                            lowercase = tf.strings.lower(input_data)
                            stripped_html = tf.strings.regex_replace(lowercase, '<br />', ' ')
                            return tf.strings.regex_replace(
                                stripped_html,
                                '[%s]' % re.escape(string.punctuation),
                                '')
                        self.model = tf.keras.models.load_model(
                            context.artifacts.get(SAVED_MODEL_NAME))
    
                    def predict(self, context, model_input):
                        model_input = model_input[['Review']]
                        return self.model.predict(model_input)
    
    
                mlflow_pyfunc_model_path = f"{type(full_model).__name__}-{run.info.run_id}"
    
                 # log the wrapper
                mlflow.pyfunc.log_model(
                    artifact_path=mlflow_pyfunc_model_path, python_model=KerasWrapper(),
                    artifacts=artifacts
                )
    
                # log the metrics + model metadata
                mlflow.log_metrics(metrics=run_metrics)
                mlflow.log_params(hparams)
                mlflow.log_param("epochs", 10)
    
                mlflow_extension.set_run_inference_info(run_id=run._info.run_id, 
                                                        prediction_type=PREDICTION_TYPE, 
                                                        classes=['0', '1'],                                       
                                                        code_env_name=MLFLOW_CODE_ENV_NAME)
                print(f'Run {run.info.run_id} done\n{"-"*40}')            
    

You’ll notice that we’re reloading the decorated `custom_standardization()` function in the `load_context()` method of our `KerasWrapper`. The reason is that the `TextVectorization` layer contains a custom step which, despite having been serialized and saved, cannot automatically be restored at load time in a different pyhon program. This limitation prevented us from using the [`mlflow.sklearn.log_model`](<https://www.mlflow.org/docs/2.17.2/python_api/mlflow.sklearn.html#mlflow.sklearn.log_model>) function to log the model.

### Deploying the model for batch scoring

You can now deploy your model either via the [Experiment Tracking interface](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/viewing.html>) or through our [Python API](<https://doc.dataiku.com/dss/latest/mlops/mlflow-models/importing.html>). In either case, you will need an evaluation dataset that contains a `Review`column with the reviews (free text) and a `Label` column for the associated binary sentiment target (1 being positive, 0 being negative).

You can generate this dataset from one batch of the `test` subdirectory located in your **aclImdb** folder:

  * Create a Python recipe that takes that folder as input and a new dataset as output.

  * Create the recipe and change its code environment to the one you used to log the experiment (so you have the `tensorflow` package available).

  * Copy and paste the following code into your recipe. Run the recipe



    
    
    import dataiku
    import pandas as pd
    import os
    import tensorflow as tf
    
    # Read recipe inputs
    aclImdb = dataiku.Folder("YOUR_FOLDER_ID") # change to aclImdb folder id 
    folder_path = aclImdb.get_path()
    
    batch_size = 300
    
    raw_test_ds = tf.keras.utils.text_dataset_from_directory(
        os.path.join(folder_path, 'aclImdb/test'),
        batch_size=batch_size)
    
    np_it = raw_test_ds.as_numpy_iterator()
    records = np_it.next()
    records = [[review, label] for review, label in zip(records[0], records[1])]
    df = pd.DataFrame(records, columns=['Review', 'Label'])
    aclImdb = dataiku.Dataset("YOUR_OUTPUT_DATASET") # change to output dataset
    aclImdb.write_with_schema(df)
    

### Deploying the model as an API endpoint

Once your model is deployed in the flow, you can follow the steps laid out our reference documentation to deploy as an [API endpoint](<https://doc.dataiku.com/dss/latest/apinode/first-service-apideployer.html#create-the-api-service>)

### Conclusion

In this tutorial, you saw how to train multiple Keras models using a custom text vectorization layer and log them in the MLFlow format. You also saw that the [`mlflow.pyfunc.PythonModel`](<https://www.mlflow.org/docs/2.17.2/python_api/mlflow.pyfunc.html#mlflow.pyfunc.PythonModel>) allows for more deployment flexibility.

---

## [tutorials/machine-learning/experiment-tracking/lightgbm/index]

# Experiment tracking with LightGBM

In this tutorial you will train a model using the [LightGBM](<https://lightgbm.readthedocs.io/>) framework and use the experiment tracking capabilities of Dataiku to log training runs (parameters, performance).

## Prerequisites

  * [Dataiku 11.0.0 or higher](<https://doc.dataiku.com/dss/latest/release_notes/11.0.html#mlops-experiment-tracking>)

  * Access to a Project with a Dataset that contains the [UCI Bank Marketing data](<https://archive.ics.uci.edu/static/public/222/bank+marketing.zip>)

  * A code environment containing the `mlflow` and `lightgbm` packages




## Performing the experiment

The following code snippet provides a reusable example to train a simple gradient boosting model with these main steps:

**(1)** Specify the categorical and numeric features and the target variable.

**(2)** Using the categorical and continuous variables spcecified, set up a preprocessing [`Pipeline`](<https://scikit-learn.org/stable/modules/compose.html#pipeline>) with two transformation steps. First, define a transformer to one-hot-encode categorical variables and then impute any missing values in continuous variables and rescale them in the other.

**(3)** Define a dictionary containing the search space for hyperparameter tuning. Then lay out a cross-validation strategy to train a classifier and evaluate the model. Log the parameters and resulting metrics as well as the models using Experiment Tracking feature, while looping over combinations of hyperparameters. The model artifact logged for the run is also a Pipeline called `clf_pipeline` that encapsulates the preprocessing and the model itself.
    
    
    import dataiku
    from lightgbm import LGBMClassifier
    from sklearn.compose import ColumnTransformer
    from sklearn.pipeline import Pipeline
    from sklearn.impute import SimpleImputer
    from sklearn.preprocessing import StandardScaler, OneHotEncoder 
    from sklearn.model_selection import cross_validate, ParameterGrid, StratifiedKFold
    
    # !! - Replace these values by your own - !!
    USER_PROJECT_KEY = ""
    USER_XPTRACKING_FOLDER_ID = ""
    USER_EXPERIMENT_NAME = ""
    USER_TRAINING_DATASET = ""
    USER_MLFLOW_CODE_ENV_NAME = ""
    
    client = dataiku.api_client()
    project = client.get_project(USER_PROJECT_KEY)
    
    ds = dataiku.Dataset(USER_TRAINING_DATASET)
    df = ds.get_dataframe()
    
    # (1)
    cat_features = ["job", "marital", "education", "default",
        "housing","loan", "month", "contact", "poutcome"]
    
    num_features = ["age", "balance", "day", "duration", 
        "campaign", "pdays", "previous"]
    
    target ="y"
    
    X = df.drop(target, axis=1)
    y = df[target]
    
    # (2)
    num_pipeline = Pipeline([
             ("impute", SimpleImputer(strategy="median")),
             ("scale", StandardScaler())
         ])
         
    cat_transformer = OneHotEncoder(handle_unknown="ignore")
    
    preprocessor = ColumnTransformer(
         transformers=[
             ("num", num_pipeline, num_features),
             ("cat", cat_transformer, cat_features),
         ],
         remainder="drop"
     )
    
    
    # (3)
    hparams_dict = {"learning_rate": [1e-3, 1e-4],
        "n_estimators": [250, 500, 1000],
        "seed": [47]
    }
    
    n_folds = 5
    param_grid = ParameterGrid(hparams_dict)
    cv = StratifiedKFold(n_splits=n_folds)
    
    mf = project.get_managed_folder(USER_XPTRACKING_FOLDER_ID)
    mlflow_extension = project.get_mlflow_extension()
    
    with project.setup_mlflow(mf) as mlflow:
        mlflow.set_experiment(USER_EXPERIMENT_NAME)
        for hparams in param_grid:
            with mlflow.start_run() as run:
                run_id = run.info.run_id
                
                clf_pipeline = Pipeline(steps=
                        [("preprocessor", preprocessor), 
                         ("classifier", LGBMClassifier(**hparams))
                        ])
                scores = cross_validate(clf_pipeline, X, y, cv=cv, scoring='roc_auc')
    
                run_metric_mean = scores['test_score'].mean()
                mlflow.log_metric('train_mean_auc', run_metric_mean)
    
                for k,v in hparams.items():
                    mlflow.log_param(k,v)
    
                mlflow.sklearn.log_model(sk_model=clf_pipeline, artifact_path='model')
                
                mlflow_extension.set_run_inference_info(run_id=run_id,
                    prediction_type="BINARY_CLASSIFICATION",
                    classes=['no', 'yes'],
                    code_env_name=USER_MLFLOW_CODE_ENV_NAME,
                    target=target)

---

## [tutorials/machine-learning/experiment-tracking/scikit-learn/index]

# Experiment tracking with scikit-learn

In this tutorial you will train a model using the [scikit-learn](<https://scikit-learn.org/stable/>) framework and use the experiment tracking capabilities of Dataiku to log training runs (parameters, performance).**Solution**

## Prerequisites

  * [Dataiku >= 11.0.0](<https://doc.dataiku.com/dss/latest/release_notes/11.0.html#mlops-experiment-tracking>).

  * Access to a Project with a Dataset that contains the [UCI Bank Marketing data](<https://archive.ics.uci.edu/static/public/222/bank+marketing.zip>).

  * A code environment containing the `mlflow` and `scikit-learn` packages.




## Performing the experiment

The following code snippet provides a reusable example to train a simple random forest classifier with these main steps:

**(1)** Select the feature and target variables.

**(2)** Build the preprocessing pipeline for categorical and numerical features.

**(3)** Define the hyperparameters to run the training on, namely the numbers of decision trees in the random forest, the maximum depth of each tree and the minimum number of samples required to be at a leaf node.

**(4)** Perform the experiment run, log the hyperparameters, performance metrics (here we use the F1 and the ROC AUC) and the trained model.
    
    
    import dataiku
    from datetime import datetime
    from sklearn.impute import SimpleImputer
    from sklearn.preprocessing import OneHotEncoder, StandardScaler
    from sklearn.compose import ColumnTransformer
    from sklearn.model_selection import ParameterGrid
    from sklearn.model_selection import StratifiedKFold
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.pipeline import Pipeline, make_pipeline
    from sklearn.model_selection import cross_validate
    
    def now_str() -> str:
        return datetime.now().strftime("%Y%m%d%H%M%S")
    
     # !! - Replace these values with your own - !!
    USER_PROJECT_KEY = ""
    USER_XPTRACKING_FOLDER_ID = ""
    USER_EXPERIMENT_NAME = ""
    USER_TRAINING_DATASET= ""
    USER_MLFLOW_CODE_ENV_NAME = ""
    
    
    client = dataiku.api_client()
    project = client.get_project(USER_PROJECT_KEY)
    
    ds = dataiku.Dataset(USER_TRAINING_DATASET)
    df = ds.get_dataframe()
    
    # (1)
    num_features = ['age', 'balance', 'duration', 'previous', 'campaign']
    
    cat_features = ['job', 'marital', 'education', 'default',
        'housing', 'loan', 'contact', 'poutcome']
    
    target = "y"
    
    X_train = df.drop(target, axis=1)
    y_train = df[target]
    
    # (2)
    num_pipeline = Pipeline([
        ('imp', SimpleImputer(strategy='median')),
        ('sts', StandardScaler()),
        ])
    
    transformers = [
        ('num', num_pipeline, num_features),
        ('cat', OneHotEncoder(handle_unknown='ignore'), cat_features)
            ]
                                            
    preprocessor = ColumnTransformer(transformers, remainder='drop')                                      
    
    # (3)
    param_space_rf = {
        "n_estimators": [40,80],
        "n_jobs": [-1],
        "max_depth": [6, 14],
        "min_samples_leaf": (10, 20, 40, 100)
    }
    n_cv_folds = 5
    grid = ParameterGrid(param_space_rf)
    cv = StratifiedKFold(n_splits=n_cv_folds)
    
    # (4)
    mf = project.get_managed_folder(USER_XPTRACKING_FOLDER_ID)
    metrics = ["f1_macro", "roc_auc"]
    mlflow_extension = project.get_mlflow_extension()
    
    with project.setup_mlflow(mf) as mlflow:
        experiment_id = mlflow.create_experiment(
            f'{USER_EXPERIMENT_NAME}_{now_str()}')
        mlflow.tracking.MlflowClient().set_experiment_tag(
            experiment_id, "library", "Scikit-learn")
        mlflow.tracking.MlflowClient().set_experiment_tag(
            experiment_id, "predictionType", "BINARY_CLASSIFICATION")
        for hparams in grid:
            with mlflow.start_run(experiment_id=experiment_id) as run:
                print(f'Starting run {run.info.run_id} ...\n{hparams}')
                run_metrics = {}
                clf = RandomForestClassifier(**hparams)
                pipeline = make_pipeline(preprocessor, clf)
                scores = cross_validate(
                    pipeline, X_train, y_train, cv=cv, scoring=metrics)
                
                # --Compute the mean and standard dev of the metrics across held-out folds
                for m in [f"test_{mname}" for mname in metrics]:
                    run_metrics[f"mean_{m}"] = scores[m].mean()
                    run_metrics[f"std_{m}"] = scores[m].std()    
                
                mlflow.log_metrics(metrics=run_metrics)
                
                for k,v in hparams.items():
                    mlflow.log_param(k,v)
                   
                # --Fit the prepocessing steps and the model on the whole train dataset
                pipeline.fit(X_train, y_train)
                
                # --Log the pipeline object 
                artifact_path = f"{type(clf).__name__}-{run.info.run_id}"
                mlflow.sklearn.log_model(sk_model=pipeline, artifact_path=artifact_path)
                
                # --Log useful information for the Dataiku Experiment tracking interface
                mlflow_extension.set_run_inference_info(
                    run_id=run._info.run_id, 
                    prediction_type="BINARY_CLASSIFICATION", 
                    classes=pipeline.classes_.tolist(),                                  
                    code_env_name=USER_MLFLOW_CODE_ENV_NAME, 
                    target=target)
    
                print(f'Run {run.info.run_id} done\n{"-"*40}')
    

After these steps you should have your experiment run’s data available both in the [Dataiku UI](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/viewing.html>) and programmatically via the [`dataikuapi.dss.mlflow.DSSMLflowExtension`](<../../../../api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension> "dataikuapi.dss.mlflow.DSSMLflowExtension") class of the Python API client.

---

## [tutorials/machine-learning/experiment-tracking/xgboost-pyfunc/index]

# Experiment Tracking with the PythonModel module

The MLflow library provides many functions to log/save and load different flavors of ML models. For example, to log a scikit-learn model, you can simply invoke the `mlflow.sklearn.log_model(your_scikit_model)` method.

To log more exotic ML libraries or custom models, MLflow offers the possibility to wrap them in a python class inheriting the [`mlflow.pyfunc.PythonModel`](<https://www.mlflow.org/docs/2.17.2/python_api/mlflow.pyfunc.html#mlflow.pyfunc.PythonModel>) module.

This wrapper is particularly convenient when a model consisting of multiple frameworks needs to be logged as a single MLflow-compliant object. The most common use-case for this is when one needs a given framework to pre-process the data and another one for the ML algorithm itself. In Dataiku, models logged to and subsequently deployed from the [Experiment Tracking interface](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/viewing.html>) need to be single objects capable of handling both the data pre-processing and scoring part.

In this tutorial, you will build an example that wraps an [XGBoost Classifier](<https://xgboost.readthedocs.io/en/stable/python/python_api.html#xgboost.XGBClassifier>) with a [scikit-learn preprocessing](<https://scikit-learn.org/stable/modules/preprocessing.html#preprocessing>) layer and saves them in the MLflow format ready to be visualized in the Experiment Tracking interface and ultimately deployed. This tutorial is based on an [example provided in the MLFlow documentation](<https://www.mlflow.org/docs/2.17.2/models.html#example-saving-an-xgboost-model-in-mlflow-format>).

## Prerequisites

  * A Python code environment containing the following libraries (see supported versions [here](<https://doc.dataiku.com/dss/latest/mlops/mlflow-models/limitations.html>)) :

    * [mlflow](<https://www.mlflow.org/docs/2.17.2/getting-started/intro-quickstart/index.html>))

    * [scikit-learn](<https://scikit-learn.org/stable/install.html#installation-instructions>)

    * [xgboost](<https://xgboost.readthedocs.io/en/stable/install.html#python>)

  * A Dataiku project with a managed folder in it.




## Wrapping an XGBoost classifier alongside a scikit-learn pre-processing layer

The following class inherits the [`mlflow.pyfunc.PythonModel`](<https://www.mlflow.org/docs/2.17.2/python_api/mlflow.pyfunc.html#mlflow.pyfunc.PythonModel>) and contains two crucial methods:
    
    
    class XGBWrapper(mlflow.pyfunc.PythonModel):
        def load_context(self, context):
            from cloudpickle import load
            self.model = load(open(context.artifacts["xgb_model"], 'rb'))
            self.preprocessor = load(open(context.artifacts["preprocessor"], 'rb'))
    
        def predict(self, context, model_input):
            model_input = model_input[['sepal length (cm)', 'sepal width (cm)',
                                       'petal length (cm)', 'petal width (cm)']]
            model_input = self.preprocessor.transform(model_input)
            return self.model.predict_proba(model_input)
    

  1. The `load_context()` method will be run at load time and allows to load all the artifacts needed in the `predict()` method. The `context` parameter is a [`PythonModelContext`](<https://www.mlflow.org/docs/2.17.2/python_api/mlflow.pyfunc.html#mlflow.pyfunc.PythonModelContext>) instance that is created implicitly at model log or save time. This parameter contains an `artifacts` dictionary whose values are paths to the serialized objects. For example:
         
         artifacts = {
             "xgb_model": "path/to/xgb_model.plk", 
             "preprocessor": "path/to/preprocessor.pkl"
         }
         




Where the `xgb_model.plk` and `preprocessor.pkl` would be a fitted XGBoost model and a scikit-learn preprocessor. Those would be serialized using `cloudpickle` and saved to some local directory.

  2. The `predict()` method of the `XGBWrapper` class is used to predict whatever data is passed through the `model_input` parameter. That parameter is expected to be a `pandas.DataFrame`. In the case of a classification problem, we recommend this `predict()` method to return the model’s `predict_proba()` so as to output the different class probabilities along with the class prediction. An added benefit to returning `predict_proba()` is being able to visualize all the classifier insights once the model is deployed in the flow.

Note that the `predict()` method can also take the same `context` parameter as that found in the `load_context()` method. Yet, it is more efficient to load artifacts only once using the `load_context()` method.




## Full example

In this example, you will be using the [Iris dataset](<https://archive.ics.uci.edu/ml/datasets/iris>) available through the scikit-learn datasets module.

### 1\. Preparing the experiment

Start by setting the following variables, handles and function for the experiment:
    
    
    import dataiku 
    from datetime import datetime
    
    # Replace these constants with your own values
    PREDICTION_TYPE = "MULTICLASS"
    EXPERIMENT_FOLDER_ID = ""          # Replace with your Managed Folder id 
    EXPERIMENT_NAME = ""               # Replace with your experiment name
    MLFLOW_CODE_ENV_NAME = ""          # Replace with your code environment name
    
    def now_str():
        return datetime.now().strftime("%Y%m%d%H%M%S")
    
    # Get the current project handle
    client = dataiku.api_client()
    project = client.get_default_project()
    
    # Create a mlflow_extension object to easily log information about our models
    mlflow_extension = project.get_mlflow_extension()
    
    # Get a handle on a Managed Folder to store the experiments.
    mf = project.get_managed_folder(EXPERIMENT_FOLDER_ID)
    

### 2\. Loading the data

In a Dataiku project, create a Python notebook and set its kernel to the code environment listed in the above prerequisites.

Run the following code:
    
    
    import dataiku
    import pandas as pd
    from sklearn import datasets
    from sklearn.model_selection import train_test_split
    
    
    iris = datasets.load_iris()
    
    features = iris.feature_names
    target = 'species'
    df = pd.DataFrame(iris.data, columns=features)
    mapping = {k:v for k,v in enumerate(iris.target_names)}
    df[target] = [mapping.get(val) for val in iris.target]
    
    df_train, df_test = train_test_split(df,test_size=0.2, random_state=42)
    
    X_train = df_train.drop(target, axis=1)
    y_train = df_train[target]
    
    X_test = df_test.drop(target, axis=1)
    y_test = df_test[target]
    

### 3\. Preprocessing the data

In this step:

  * Specify the target and the features.

  * Set up a [scikit-learn Pipeline](<https://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html>) to impute potential missing values and rescale continuous variables.



    
    
    from sklearn.pipeline import Pipeline
    from sklearn.impute import SimpleImputer
    from sklearn.preprocessing import StandardScaler
    from cloudpickle import dump, load
    
    
    preprocessor = Pipeline([
        ('imp', SimpleImputer(strategy='median')),
        ('sts', StandardScaler()),
    ])
    
    X_train = preprocessor.fit_transform(X_train)
    X_test = preprocessor.transform(X_test)
    
    artifacts = {
        "xgb_model": "xgb_model.plk", 
        "preprocessor": "preprocessor.pkl"
    }
    
    # pickle and save the preprocessor
    dump(preprocessor, open(artifacts.get("preprocessor"), 'wb'))
    

### 4\. Training and logging the model

Finally, train the xgboost classifier. Log the hyperparameters, performance metrics and the classifier itself into your Experiment run.
    
    
    import xgboost as xgb
    from sklearn.metrics import precision_score
    
    hparams = {
        "max_depth": 5,
        "n_estimators": 50
    }
    
    with project.setup_mlflow(mf) as mlflow:
        experiment_id = mlflow.create_experiment(f'{EXPERIMENT_NAME}_{now_str()}')
        
        class XGBWrapper(mlflow.pyfunc.PythonModel):
            def load_context(self, context):
                from cloudpickle import load
                self.model = load(open(context.artifacts["xgb_model"], 'rb'))
                self.preprocessor = load(open(context.artifacts["preprocessor"], 'rb'))
    
            def predict(self, context, model_input):
                model_input = model_input[['sepal length (cm)', 'sepal width (cm)',
                                           'petal length (cm)', 'petal width (cm)']]
            
                model_input = self.preprocessor.transform(model_input)
                return self.model.predict_proba(model_input)
    
        with mlflow.start_run(experiment_id=experiment_id) as run:
            print(f'Starting run {run.info.run_id} ...\n{hparams}')
    
            model = xgb.XGBClassifier(**hparams)
            model.fit(X_train, y_train)
    
            # pickle and save the model
            dump(model, open(artifacts.get("xgb_model"), 'wb'))
    
            preds = model.predict(X_test)
            precision = precision_score(y_test, preds, average=None)
    
            run_metrics = {f'precision_{k}':v for k,v in zip(model.classes_, precision)}
    
            # Save the MLflow Model, hyper params and metrics
            mlflow_pyfunc_model_path = f"xgb_mlflow_pyfunc-{run.info.run_id}"
            mlflow.pyfunc.log_model(
                artifact_path=mlflow_pyfunc_model_path, python_model=XGBWrapper(),
                artifacts=artifacts)
    
            mlflow.log_params(hparams)
            mlflow.log_metrics(run_metrics)
    
            mlflow_extension.set_run_inference_info(run_id=run._info.run_id, 
                                                    prediction_type='MULTICLASS',
                                                    classes=list(model.classes_),
                                                    code_env_name=MLFLOW_CODE_ENV_NAME)  
            print(f'Run {run.info.run_id} done\n{"-"*40}')
    

You’re done! You can now go to the [Experiment Tracking interface](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/viewing.html>) to check the performance of your model. You can also either deploy the model from that interface or using the [dataiku API](<https://doc.dataiku.com/dss/latest/mlops/mlflow-models/importing.html#importing-mlflow-models>). For either deployment, you will need an evaluation dataset that has the same schema as that of your training dataset (although the order of the columns is does not matter).

## Conclusion

In this tutorial, you learned how to wrap two frameworks under a single MLFlow-compliant object and log it along with key metadata. Having to use multiple frameworks is frequent in many areas of ML. For example:

  * In Natural Language Processing (NLP) one may want to pre-process the data using a pre-trained embedding layer (say [`spaCy`](<https://spacy.io/>)) before scoring them using a [`PyTorch`](<https://pytorch.org/>) classifier.

  * In the field of Computer Vision, the [`Pillow`](<https://pillow.readthedocs.io/en/stable/>) library can be used to decode image bytes from base64 encoding before being scored using [`Keras`](<https://keras.io/>) or some other library.

---

## [tutorials/machine-learning/index]

# Machine Learning

This tutorial section contains learning material on programmatically training, managing and deploying machine learning models in Dataiku.

## Local Interpretable Model-agnostic Explanations

  * [This tutorial](<models/lime/index.html>) explains using LIME (Local Interpretable Model-agnostic Explanations) to provide human-readable explanations for machine learning model predictions.




## Predictive maintenance

  * [This tutorial](<models/predictive-maintenance/index.html>) explains how can you predict performance before getting the ground truth.




## Reinforcement learning

  * [This tutorial](<others/reinforcement-learning/index.html>) uses reinforcement learning (RL) to tune a random forest classifier’s hyperparameters automatically. The Q-learning algorithm explores and exploits hyperparameter combinations to find the best combination, using validation accuracy as the reward.




## Transfer learning

### Transductive transfer learning

[This tutorial](<others/transfer-learning/transductive-learning.html>) focuses on scenarios where labeled target data is available, the source and target tasks are the same, but the domain changes.

### Unsupervised transfer learning

[This tutorial](<others/transfer-learning/unsupervised-transfer-learning.html>) addresses the challenge of data scarcity. Unsupervised transfer learning techniques are helpful for adapting a model to a new domain when you have a target dataset, but no labels.

## Experiment Tracking

  * [With XGBoost and custom pre-processing](<experiment-tracking/xgboost-pyfunc/index.html>)

  * [With Keras/Tensorflow for sentiment analysis](<experiment-tracking/keras-nlp/index.html>)

  * [With Catboost](<experiment-tracking/catboost/index.html>)

  * [With LightGBM](<experiment-tracking/lightgbm/index.html>)

  * [With scikit-learn](<experiment-tracking/scikit-learn/index.html>)




## Pre-trained Models

  * [Tensorflow](<code-env-resources/tf-resources/index.html>)

  * [PyTorch](<code-env-resources/pytorch-resources/index.html>)

  * [Hugging Face](<code-env-resources/hf-resources/index.html>)

  * [SentenceTransformers](<code-env-resources/sentence-transformers-resources/index.html>)

  * [spaCy](<code-env-resources/spacy-resources/index.html>)

  * [NLTK](<code-env-resources/nltk-resources/index.html>)




## Model Import

  * [Importing serialized scikit-learn pipelines as Saved Models for MLOps](<model-import/scikit-pipeline/index.html>)




## Model Export

  * [Wrapping an exported model in a CLI tool](<model-export/python-export-cli/index.html>)

  * [Deploying a model to an edge device with AWS IoT Greengrass](<model-export/python-export-edge-deployment-aws-greengrass/index.html>)




## Distributed training

  * [Distributed ML Training using Ray](<others/distributed-training/index.html>)




## Vulnerability and Bias Scanning with Protect AI Guardian

This tutorial will guide you through the process of scanning a model for vulnerabilities, biases, and security concerns using Protect AI Guardian’s Python SDK.

---

## [tutorials/machine-learning/model-export/index]

# Model Export

---

## [tutorials/machine-learning/model-export/python-export-cli/index]

# Wrapping an exported model in a CLI tool

## Prerequisites

  * Dataiku >= 11.1.0

  * A Project in which you already deployed a Saved Model version trained on the [Bank Marketing Dataset](<https://archive.ics.uci.edu/ml/datasets/bank+marketing>)




## Introduction

The Python export feature packages a Saved Model version into a reusable artifact requiring only Python when used outside of Dataiku. It covers use-cases where you may not be able to deploy the model as an [API service endpoint](<https://doc.dataiku.com/dss/latest/apinode/introduction.html#exposing-predictive-models>) or if you don’t need the overhead of using HTTP to request predictions.

In this tutorial you will see how an exported model can be packaged into a simple command-line interface (CLI) to score data stored in CSV files.

## Dataset and model

This tutorial is based on a model trained on the [Bank Marketing Dataset](<https://archive.ics.uci.edu/ml/datasets/bank+marketing>) to predict whether a given client will subscribe a term deposit. According to the prerequisites, you should already have it available in your Flow as a Saved Model version.

Following the [steps described in the documentation](<https://doc.dataiku.com/dss/latest/machine-learning/models-export.html#export-to-python>), export the Saved Model version as a Python function. After this step you should have downloaded a zip archive.

Unzip the archive, you should get the following files:

  * `model.zip`: the actual trained model artifact,

  * `sample.py`: a starter code sample with a simple example to score a few data points,

  * `requirements.txt`: a list of packages to install before running the scoring code.




In `sample.py`, the provided code assumes that the input data points are already available as plain list of Python dictionaries, but it would be even more convenient to handle input files directly and execute _batch scoring_. That is precisely what you will implement in the next section.

## Implementing the CLI

In this section you will create an additional script called `score.py` that takes a CSV file and an exported model as inputs and produces an enriched output file with the prediction results. The script will essentially be a CLI tool that shall accept 4 arguments:

  * the path to the input file,

  * the path to the exported model to use for scoring,

  * the desired path for the generated output file,

  * an optional flag to generate the predicted probabilities for each class.




In the rest of the tutorial you will use the export directory as main working directory.

Start by creating a new Python virtual environment and install the dependencies listed in the `requirements.txt` file.
    
    
    python -m venv scoring-env
    source scoring-env/bin/activate
    pip install -r requirements.txt
    

Install additional packages needed to run the script:

  * [_pandas_](<https://pandas.pydata.org/>) to apply the scoring operation on an entire DataFrame

  * [_click_](<https://click.palletsprojects.com/>) to parse arguments passed to the CLI



    
    
    pip install click pandas
    

Once your dependencies are ready, create a new file called `score.py` with the following code:
    
    
    import click
    import pandas as pd
    from dataikuscoring import load_model
    
    @click.command()
    @click.option("-i", 
                  "--input-file", 
                  type=click.Path(exists=True),
                  help="Path to the input file")
    @click.option("-o",
                  "--output-file",
                  type=click.File(mode='w'),
                  help="Path to the generated output file")
    @click.option("-m", 
                  "--model-file", 
                  type=click.Path(exists=True),
                  help="Path to the model to use for predictions")
    @click.option("--proba",
                  is_flag=True,
                  help="Output predicted probability columns for each class")
    def score(input_file, output_file, model_file, proba):
        """
        Scoring CLI: computes predictions from CSV file records using
        a trained model exported from Dataiku.
        """
    
        # Load model:
        model = load_model(model_file)
    
        # Load input file data in a pandas DataFrame
        df = pd.read_csv(input_file, sep=None, engine='python')
        if proba:
            # Compute probabilities for each class
            predictions = model.predict_proba(df)
            for label in predictions.keys():
                proba_col = f"proba_{label}"
                df[proba_col] = predictions[label]
        else:
            # Compute predictions
            df["predictions"] = model.predict(df)
    
        # Write result to output file
        df.to_csv(output_file)
    
    if __name__ == "__main__":
        score()
    

Let’s look closer at this code! First, you can see that the `score()` function is decorated with multiple `@click.option` decorators: this is how the `click` package lists the different options and arguments passed to the command line. Each option has:

  * a name, both in short and long form (e.g. `-i` and `--input-file`) that will serve as identifier when parsing the command sent by the user,

  * a type, essentially to help with error handling: for example, `click.Path(exists=True)` will explicitly tell the user if the target file doesn’t exist on the specified path,

  * a helper text, to provide a concise description of the argument when calling the CLI with the `--help` flag.




Based on the options, the code creates a pandas DataFrame from the input file, either generating a prediction or the class probabilities, and then writes the result on an output file.

Note

Several assumptions have been made to simplify the code, in particular there is no specific handling of CSV parsing options like custom delimiters, quoting or headers. However, using `sep=None` and `engine='python'` in `pd.read_csv()` forces pandas to infer the delimiter and thus prevents the users of having to explicitly declare one.

You can now call your CLI as follows:
    
    
    # Output predictions
    python score.py -i my_input.csv -o my_output.csv -m model.zip 
    
    # Output probabilities
    python score.py -i my_input.csv -o my_output.csv -m model.zip --proba
    

To get help and details about the available options, use the `--help` flag.
    
    
    python score.py --help 
    
    #Usage: scoring.py [OPTIONS]
    #
    #  Scoring CLI: computes predictions from CSV file records using a trained
    #  model exported from Dataiku.
    
    #Options:
    #  -i, --input-file PATH       Path to tne input file
    #  -o, --output-file FILENAME  Path to the generated output file
    #  -m, --model-file PATH       Path to the model to use for predictions
    #  --proba                     Add predicted proba column for each class
    #  --help                      Show this message and exit.
    

## Wrapping up

From this simple starting point you can now swap the Bank Marketing model export with your very own use-case. There are also a few ways to expand the capabilities of your CLI, e.g. by:

  * providing a list of input CSV files or an input folder to score multiple files in one go,

  * implementing an “evaluation mode”: if the input CSV file contains the ground truth, you can use it to evaluate the model’s performance metrics after computing the predictions,

  * leveraging Dataiku’s public API to programmatically export the latest model version before running the prediction.




For more details on the export capabilities of Dataiku, you can read the corresponding section of the [reference documentation](<https://doc.dataiku.com/dss/latest/machine-learning/models-export.html>).

---

## [tutorials/machine-learning/model-export/python-export-edge-deployment-aws-greengrass/index]

# Deploying a model to an edge device with AWS IoT Greengrass

In this tutorial you will see how to set up a Raspberry Pi edge device, connect it to AWS IoT Greengrass, package a Dataiku Saved Model as a python function, then deploy it as an inferencing component to the edge device via Greengrass.

## Prerequisites

  * Dataiku >= 13.1.0

  * A Project in which you already deployed a Saved Model version trained on the [Bank Marketing Dataset](<https://archive.ics.uci.edu/ml/datasets/bank+marketing>)

  * An AWS account and the minimum IAM permissions to provision IoT Greengrass resources (listed [here](<https://docs.aws.amazon.com/greengrass/v2/developerguide/provision-minimal-iam-policy.html>))

  * A Raspberry Pi device with Raspberry Pi OS that you can SSH into




## Introduction

For some use cases, you may want to deploy a model to an edge device for inference rather than as an [API service endpoint](<https://doc.dataiku.com/dss/latest/apinode/introduction.html> "\(in Dataiku DSS v14\)").

With edge deployment often comes device resource constraints, sporadic connectivity, and deployment orchestration challenges.

To solve these challenges, you can use one of the many Dataiku Saved Model export options and then distribute the model using an edge deployment service.

[AWS IoT Greengrass](<https://aws.amazon.com/greengrass/>) is a popular open-source edge runtime and cloud service for building, deploying, and managing device software.

In this tutorial you will see how to set up a Raspberry Pi edge device, connect it to AWS IoT Greengrass, package a Dataiku Saved Model as a Python function, and deploy it as an inferencing component to the edge device via Greengrass. This tutorial contains a no-code plugin approach and a full-code custom Python approach.

## Dataset and model

This tutorial is based on a model trained on the [Bank Marketing Dataset](<https://archive.ics.uci.edu/ml/datasets/bank+marketing>) to predict whether a given client will subscribe to a term deposit (column `y`). You should already have it in your Flow as a Saved Model version.

Figure 1 – Dataiku Flow with Saved Model

## Setting up the Edge Device (Raspberry Pi) as a `Core Device` and `Thing` in AWS IoT Greengrass

Note

These instructions roughly follow the AWS IoT Greengrass Developer Guide, [Version 2](<https://docs.aws.amazon.com/greengrass/v2/developerguide/getting-started.html>). Check that guide for differences in setup (e.g. a Windows edge device instead of Raspberry Pi) and troubleshooting help.

  1. SSH into the edge device (where `username` is your Linux user and `pi-ip-address` is your Raspberry Pi IP address, which you can find with `ping raspberry.local` if connected on the same network).
         
         ssh username@pi-ip-address
         

  2. Install the Java runtime, which AWS IoT Greengrass Core software requires.
         
         sudo apt install default-jdk
         

  3. When the installation is complete, run the following command to verify that Java runs on your Raspberry Pi.
         
         java -version
         

  4. The command prints the version of Java that runs on the device. The output might look similar to the following example.
         
         openjdk version "17.0.13" 2024-10-15
         OpenJDK Runtime Environment (build 17.0.13+11-Debian-2deb12u1)
         OpenJDK 64-Bit Server VM (build 17.0.13+11-Debian-2deb12u1, mixed mode, sharing)
         

  5. Update the Linux kernel parameters by opening this file.
         
         sudo nano /boot/firmware/cmdline.txt
         

  6. Verify that the `/boot/firmware/cmdline.txt` file contains the following kernel parameters. If it doesn’t contain these parameters or it contains these parameters with different values, update the file to contain these parameters and values.
         
         cgroup_enable=memory cgroup_memory=1 systemd.unified_cgroup_hierarchy=0
         

  7. If you updated the `/boot/firmware/cmdline.txt` file, reboot the Raspberry Pi to apply the changes (then SSH back into it).
         
         sudo reboot
         ssh username@pi-ip-address
         

  8. Install the AWS CLI.
         
         sudo apt install awscli
         

  9. Add your AWS credentials to the Raspberry Pi environment. Ensure you have the minimum permissions listed [here](<https://docs.aws.amazon.com/greengrass/v2/developerguide/provision-minimal-iam-policy.html>).
         
         export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
         export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
         export AWS_SESSION_TOKEN=AQoDYXdzEJr1K...o5OytwEXAMPLE=
         export AWS_DEFAULT_REGION=us-east-2
         

  10. Make sure you’re in the user home directory.
         
         cd ~
         

  11. Download the AWS IoT Greengrass Core software.
         
         curl -s https://d2s8p88vqu9w66.cloudfront.net/releases/greengrass-nucleus-latest.zip > greengrass-nucleus-latest.zip
         

  12. Unzip the AWS IoT Greengrass Core software to a folder on your device. In this case, we used `GreengrassInstaller`.
         
         unzip greengrass-nucleus-latest.zip -d GreengrassInstaller && rm greengrass-nucleus-latest.zip
         

  13. Launch the AWS IoT Greengrass Core software installer. We use the Greengrass thing name `DataikuGreengrassRaspberryPi`, the thing group name `DataikuGreengrassRaspberryPiGroup`, and the `us-east-2` region. Feel free to change these.
         
         sudo -E java -Droot="/greengrass/v2" -Dlog.store=FILE \
           -jar ./GreengrassInstaller/lib/Greengrass.jar \
           --aws-region us-east-2 \
           --thing-name DataikuGreengrassRaspberryPi \
           --thing-group-name DataikuGreengrassRaspberryPiGroup \
           --thing-policy-name GreengrassV2IoTThingPolicy \
           --tes-role-name GreengrassV2TokenExchangeRole \
           --tes-role-alias-name GreengrassCoreTokenExchangeRoleAlias \
           --component-default-user ggc_user:ggc_group \
           --provision true \
           --setup-system-service true \
           --deploy-dev-tools true
         

Running this command should print out several messages. Check that the last four lines look like this:
         
         Successfully configured Nucleus with provisioned resource details!
         Creating a deployment for Greengrass first party components to the thing group
         Configured Nucleus to deploy aws.greengrass.Cli component
         Successfully set up Nucleus as a system service
         

  14. Confirm that the Greengrass CLI was installed (it may take a minute).
         
         /greengrass/v2/bin/greengrass-cli help
         

  15. Check the status of your new core device Thing (`DataikuGreengrassRaspberryPi`).
         
         aws greengrassv2 list-effective-deployments --core-device-thing-name DataikuGreengrassRaspberryPi
         

You should see JSON. Look for this key pair to confirm that the deployment succeeded: `"coreDeviceExecutionStatus": "SUCCEEDED"`.

You’ll also see `DataikuGreengrassRaspberryPi` in the AWS Console under Greengrass -> Core devices.

Figure 2 – Greengrass Core Device

  16. In the AWS console, create a new IAM policy (you can call it `DataikuGreengrassComponentArtifactPolicy`), and grant the `s3:GetObject` permission on an S3 bucket that Dataiku has write access to (replace `DKU_S3_BUCKET` with your bucket name).
         
         {
           "Version": "2012-10-17",
           "Statement": [
             {
               "Effect": "Allow",
               "Action": [
                 "s3:GetObject"
               ],
               "Resource": "arn:aws:s3:::DKU_S3_BUCKET/*"
             }
           ]
         }
         

  17. Attach this policy to the IAM Role `GreengrassV2TokenExchangeRole` that you created earlier. This way, your IoT devices can pull down the model component artifacts from S3.

  18. Finally, copy a CSV of sample records to the Raspberry Pi filesystem in the `/dataiku_scoring_data` subdirectory. Make sure to name the file `input_data_for_scoring.csv`. Our model scoring component will look for this specific file name in this particular location on the device. You can, of course, customize this yourself later on.

You can start by exporting the training dataset locally - here, I’m taking just the first 100 records to keep things speedy.

Figure 3 – Dataiku Dataset Export

Figure 4 – Dataiku Dataset Export Sampling

  19. On the Raspberry Pi, create the `/dataiku_scoring_data directory` and open up permissions.
         
         sudo mkdir /dataiku_scoring_data
         sudo chmod -R 777 /dataiku_scoring_data
         

  20. Rename the exported file as `input_data_for_scoring.csv`, then scp it from your local machine to the Raspberry Pi.
         
         scp ~/Downloads/input_data_for_scoring.csv username@pi-ip-address:/dataiku_scoring_data
         




## Deploying a Dataiku Model as a Component to Greengrass Devices

Now that the Raspberry Pi has been set up as a Core Device and Thing in IoT Greengrass, we’ll now take our Dataiku Saved Model, wrap it into a scoring service, turn that scoring service into a Greengrass component, then deploy the component to our device.

The scoring service, called `score_edge.py`, will read a CSV file from a known path on the device (`/dataiku_scoring_data/input_data_for_scoring.csv`), load the trained model, and produce an enriched output file, also on the device (`/dataiku_scoring_data/output_data_with_predictions.csv`), with the prediction results. The script will essentially be a CLI tool that will accept four arguments:

  * the path to the input file,

  * the path to the exported model to use for scoring,

  * the desired path for the generated output file,

  * an optional flag to generate the predicted probabilities for each class.




We’ll now use the Dataiku APIs and AWS Greengrass SDKs to deploy a Dataiku Saved Model to an edge device service.

Deployment by PluginDeployment by Custom Code

Important

Installing the plugin and configuring AWS credentials requires Dataiku Administrator privileges.

  1. Install [this](<https://github.com/dataiku/dss-plugin-aws-greengrass>) plugin. It will prompt you to build a plugin code environment.

  2. Go to the plugin **Settings > AWS configuration presets** and enter the AWS Access Key ID, Secret Access Key, Session Token (if required), and AWS region. These credentials should have `"greengrass:*"` on `"Resource": "*"` permissions to create, delete, modify, and list Greengrass components and deployments.

Figure 5 – Plugin AWS Configuration Presets

  3. Click **\+ Recipe > AWS IoT Greengrass > Deploy to Greengrass Devices**.

Figure 6 – Find Plugin Recipe

Figure 7 – Create Plugin Recipe

  4. Choose your Saved Model as an input, and create a new folder in an S3 connection (this connection should link to the bucket on which your Greengrass device has `S3:GetOject` permission).

Figure 8 – Plugin Recipe Input/Output

  5. Choose your AWS configuration in the plugin recipe settings and enter the ARN for the Greengrass Thing (or Thing Group) just created. You can find this in the AWS console (e.g., `arn:aws:iot:REGION:AWS_ACCOUNT:thing/DataikuGreengrassRaspberryPi`).

You can leave the component name and version as `DataikuScoreEdge` and `1.0.0` or change them.

Figure 9 – Plugin Recipe Settings

The plugin, by default, will create the scoring component we described earlier.

Note

If you’d like to customize the component, check **Fully Custom Component** , write your component recipe JSON directly in the plugin recipe, and upload your `score_edge.py` file to the output S3 folder, specifically in the subdirectory `artifacts/dataiku.greengrass.YOUR_COMPONENT_NAME/YOUR_COMPONENT_VERSION`. The plugin will handle packaging the Dataiku Saved model and uploading it to the S3 directory as `model.zip` and output the `requirements.txt` file.

AWS has [documentation](<https://docs.aws.amazon.com/greengrass/v2/developerguide/component-recipe-reference.html>) and a [tutorial](<https://docs.aws.amazon.com/greengrass/v2/developerguide/create-first-component.html>) on custom Greengrass components.

  6. Run the recipe, and check out the output folder. You should see a file `greengrass_component_deployment_status.txt` with the deployment status details. Look for `"coreDeviceExecutionStatus": "SUCCEEDED"` when deploying to a Thing, and `"deploymentStatus": "ACTIVE"` when deploying to a Thing Group.

Figure 10 – Dataiku Flow with Greengrass Deployment

You should see `model.zip`, `score_edge.py`, and `requirements.txt` in the output folder in the subpath `artifacts/dataiku.greengrass.YOUR_COMPONENT_NAME/YOUR_COMPONENT_VERSION`

Figure 11 – Output Folder with Component Files




  1. Create a Python [code environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html> "\(in Dataiku DSS v14\)") and install the `boto3` package to interact with AWS resources. We’ve tested this with Python 3.9 and Pandas 2.2 core packages; you can feel free to try others.

  2. Import the necessary packages.
         
         import dataiku
         import pandas as pd
         import boto3
         import json
         import zipfile
         import tempfile
         import time
         import re
         

  3. Set variables to point to your Saved Model and S3 folder, and define the new Greengrass component. Then, get your AWS credentials.
         
         saved_model_id = "YOUR_SAVED_MODEL_ID" # Must be a Binary Classification, Multiclass, or Regression model
         s3_folder_name = "YOUR_OUTPUT_S3_FOLDER" # Create this folder in your flow beforehand. Must be S3
         target_device_arn = "arn:aws:iot:REGION:AWS_ACCOUNT:thing/DataikuGreengrassRaspberryPi" # Target Greengrass Thing or Thing Group ARN
         component_name = "dataiku.greengrass.DataikuScoreEdge" # Name of the Greengrass component
         component_version = "1.0.0" # Greengrass component version
         

  4. Set your AWS credentials, then get a boto3 session and GreengrassV2 client.
         
         # AWS credentials (Please fill in with your keys)
         aws_access_key = ""
         aws_secret_access_key = ""
         aws_session_token = ""
         aws_region = "us-east-2"
         
         # Get AWS boto3 session and Greengrass V2 client
         boto_session = boto3.Session(
             aws_access_key_id=aws_access_key_id,
             aws_secret_access_key=aws_secret_access_key,
             aws_session_token=aws_session_token,
             region_name=aws_region
         )
         greengrassv2_client = boto_session.client('greengrassv2')
         

  5. Get a Dataiku API client and project handle.
         
         # Get a Dataiku API client
         client = dataiku.api_client()
         project = client.get_default_project()
         

  6. Get your output S3 folder path and set the path for generated Greengrass component artifacts.
         
         # Get the output S3 folder to hold Greengrass component artifacts
         s3_folder = dataiku.Folder(s3_folder_name)
         s3_folder_info = s3_folder.get_info()
         s3_bucket = s3_folder_info['accessInfo']['bucket']
         
         # Get the output S3 folder root path
         s3_bucket_path_to_component = "s3://" + s3_bucket + s3_folder_info['accessInfo']['root']
         
         # Get the S3 folder path to store Greengrass component artifacts 
         s3_path_artifacts_prefix = f'artifacts/{component_name}/{component_version}/'
         

  7. Package the input Saved Model as a Python function, upload the .zip file to the S3 folder artifact path, and unzip it.
         
         # Get the input saved model active version details
         model = project.get_saved_model(saved_model_id)
         latest_model_version = model.get_active_version()
         model_version_details = model.get_version_details(latest_model_version['id'])
         
         # Get a python export of the active model version as a stream
         with model_version_details.get_scoring_python_stream() as stream:
             
             # Upload the raw .zip python export to the S3 folder
             model_export_full_zip_s3_path = s3_path_artifacts_prefix + 'model_export_full.zip'
             s3_folder.upload_stream(model_export_full_zip_s3_path, stream)
             
             # Then take that raw .zip file from S3 as a stream
             with s3_folder.get_download_stream(model_export_full_zip_s3_path) as stream_2:
                 
                 # Create a temporary file to store the zip contents
                 with tempfile.NamedTemporaryFile(mode='wb', delete=False) as temp:
                     temp.write(stream_2.read())
                     temp.flush()
                     
             # Unzip the raw .zip file
             with zipfile.ZipFile(temp.name) as zip_file:
                 # Upload all extracted files from the .zip to S3
                 for file_name in zip_file.namelist():
                     with zip_file.open(file_name) as extracted_file:
                         file_full_zip_s3_path = s3_path_artifacts_prefix + file_name
                         s3_folder.upload_stream(file_full_zip_s3_path, extracted_file)
         

  8. Delete the initial raw .zip python model export and the generated sample.py script.
         
         s3_folder.delete_path(model_export_full_zip_s3_path)
         sample_py_s3_path = s3_path_artifacts_prefix + 'sample.py'
         s3_folder.delete_path(sample_py_s3_path)
         

  9. Create a new `score_edge.py` script and upload it to the S3 folder artifact path.
         
         # New scoring .py script - works for Classification models
         score_edge_py_class_text = """
         import click
         import pandas as pd
         from dataikuscoring import load_model
         
         @click.command()
         @click.option("-i", 
                       "--input-file", 
                       type=click.Path(exists=True),
                       help="Path to the input file")
         @click.option("-o",
                       "--output-file",
                       type=click.File(mode='w'),
                       help="Path to the generated output file")
         @click.option("-m", 
                       "--model-file", 
                       type=click.Path(exists=True),
                       help="Path to the model to use for predictions")
         @click.option("--proba",
                       is_flag=True,
                       help="Output predicted probability columns for each class")
         def score(input_file, output_file, model_file, proba):
             \"""
             Scoring CLI: computes predictions from CSV file records using
             a trained model exported from Dataiku.
             \"""
         
             # Load model:
             model = load_model(model_file)
         
             # Load input file data in a pandas DataFrame
             df = pd.read_csv(input_file, sep=None, engine='python')
         
             if proba:
                 # Compute probabilities for each class
                 predictions = model.predict_proba(df)
                 for label in predictions.keys():
                     proba_col = f"proba_{label}"
                     df[proba_col] = predictions[label]
             else:
                 # Compute predictions
                 df["predictions"] = model.predict(df)
         
             df_length = len(df.index)
             print(f"Made {df_length} predictions")
             print("First 5 predictions....")
             print(df.head(5))
             print(f"Saving predictions to {output_file}")
             
             # Write result to output file
             df.to_csv(output_file)
         
         if __name__ == "__main__":
             score()
         """
         
         score_edge_py_s3_path = s3_path_artifacts_prefix + 'score_edge.py'
         
         # Write the new score_edge.py script to the S3 folder
         with s3_folder.get_writer(score_edge_py_s3_path) as score_edge_py_writer:
             score_edge_py_writer.write(score_edge_py_class_text.encode('utf8'))
         

  10. Get the paths to the 3 component files in S3 (`score_edge.py`, `requirements.txt`, and `model.zip`).
         
         score_edge_py_full_s3_path = s3_bucket_path_to_component + "/" + score_edge_py_s3_path
         requirements_txt_full_s3_path = s3_bucket_path_to_component + "/" + s3_path_artifacts_prefix + 'requirements.txt'
         model_zip_full_s3_path = s3_bucket_path_to_component + "/" + s3_path_artifacts_prefix + 'model.zip'
         

  11. Create a new Greengrass component defining the component name/version, Python run script, edge device scoring input/output files, and the artifact files you just uploaded to S3.
         
         # Create the Greengrass component recipe JSON
         dataiku_scoring_greengrass_component_recipe_json = {
           "RecipeFormatVersion": "2020-01-25",
           "ComponentName": component_name,
           "ComponentVersion": component_version,
           "ComponentDescription": "An AWS IoT Greengrass component to score a record using an ML model trained in Dataiku and exported as a python function.",
           "ComponentPublisher": "Dataiku",
           "ComponentConfiguration": {
             "DefaultConfiguration": {
               "InputFile": "/dataiku_scoring_data/input_data_for_scoring.csv",
               "OutputFile": "/dataiku_scoring_data/output_data_with_predictions.csv"
             }
           },
           "Manifests": [
             {
               "Platform": {
                 "os": "linux"
               },
               "Lifecycle": {
                 "Install": {
                   "Script": "python3 -m venv dataiku-scoring-env && . dataiku-scoring-env/bin/activate && pip3 install -r {artifacts:path}/    requirements.txt && pip3 install click pandas"
                 },
                 "Run": ". dataiku-scoring-env/bin/activate && python3 -u {artifacts:path}/score_edge.py --input-file {configuration:/    InputFile} --output-file {configuration:/OutputFile} --model-file {artifacts:path}/model.zip --proba"
               },
               "Artifacts": [
                 {
                   "URI": score_edge_py_full_s3_path
                 },
                 { 
                   "URI": requirements_txt_full_s3_path
                 },
                 {
                   "URI": model_zip_full_s3_path
                 }  
               ]
             }
           ]
         }
         
         # Convert JSON to bytes
         dataiku_scoring_greengrass_component_recipe_bytes = json.dumps(dataiku_scoring_greengrass_component_recipe_json).encode('utf-8')
         
         # Create the new Greengrass component version
         create_component_version_response = greengrassv2_client.create_component_version    (inlineRecipe=dataiku_scoring_greengrass_component_recipe_bytes)
         

Note

If this component name and version already exists you’ll need to use a different name or version or delete the component version with `delete_component_version_response = greengrassv2_client.delete_component(arn="YOUR_COMPONENT_VERSION_AWS_ARN")`

  12. Check the component - run this until you see `"componentState": "DEPLOYABLE"`.
         
         # Get the generated component version ARN
         component_arn = create_component_version_response['arn']
         
         # Check the component to see if it is deployable or failed (or still building)
         component_description = greengrassv2_client.describe_component(arn=component_arn)
         

  13. Deploy the component to your edge device.
         
         # Create the Greengrass component deployment json
         dataiku_scoring_greengrass_component_deployment_json = {
             component_name: {
               "componentVersion": component_version
             }
         }
         
         # Convert to bytes
         dataiku_scoring_greengrass_component_deployment_bytes = json.dumps(dataiku_scoring_greengrass_component_deployment_json).encode    ('utf-8')
         
         # Deploy the new Greengrass component to the target Thing or Thing Group ARN 
         create_deployment_response = greengrassv2_client.create_deployment(targetArn=target_device_arn,     components=dataiku_scoring_greengrass_component_deployment_json)
         

  14. Get the status of the deployment - run this until you see `"coreDeviceExecutionStatus": "COMPLETED" or "SUCCEEDED"`.
         
         # 
         target_device_name = re.search('.*thing\/(.*)', target_device_arn).group(1)
         target_device_effective_deployments = greengrassv2_client.list_effective_deployments(coreDeviceThingName=target_device_name)    ['effectiveDeployments']
         




Your model is now deployed to the edge device!

  * If you return to the Raspberry Pi, check out the newly-created `/dataiku_scoring_data/output_data_with_predictions.csv` file. You should see new columnms: `y` , `proba_no`, and `proba_yes`!
        
        head /dataiku_scoring_data/output_data_with_predictions.csv
        
        
        ,age,job,marital,education,default,balance,housing,loan,contact,day,month,duration,campaign,pdays,previous,poutcome,y,proba_no,proba_yes
        0,58,management,married,tertiary,no,2143,yes,no,unknown,5,may,261,1,-1,0,unknown,no,0.7902615833178168,0.20973841668218327
        1,44,technician,single,secondary,no,29,yes,no,unknown,5,may,151,1,-1,0,unknown,no,0.9492253983155636,0.05077460168443629
        2,33,entrepreneur,married,secondary,no,2,yes,yes,unknown,5,may,76,1,-1,0,unknown,no,0.9776448216311145,0.022355178368885495
        3,47,blue-collar,married,unknown,no,1506,yes,no,unknown,5,may,92,1,-1,0,unknown,no,0.9399339872642072,0.0600660127357929
        4,33,unknown,single,unknown,no,1,no,no,unknown,5,may,198,1,-1,0,unknown,no,0.7108691615326147,0.28913083846738563
        5,35,management,married,tertiary,no,231,yes,no,unknown,5,may,139,1,-1,0,unknown,no,0.9303409148558117,0.06965908514418874
        6,28,management,single,tertiary,no,447,yes,yes,unknown,5,may,217,1,-1,0,unknown,no,0.9183141566941998,0.08168584330580009
        7,42,entrepreneur,divorced,tertiary,yes,2,yes,no,unknown,5,may,380,1,-1,0,unknown,no,0.8124177326615576,0.18758226733844252
        8,58,retired,married,primary,no,121,yes,no,unknown,5,may,50,1,-1,0,unknown,no,0.9897293390906106,0.010270660909389544
        

  * You can also check the deployment logs.
        
        sudo tail -f /greengrass/v2/logs/dataiku.greengrass.DataikuScoreEdge.log
        
        
        2025-02-04T14:37:47.470Z [INFO] (Copier) dataiku.greengrass.DataikuScoreEdge: stdout. age           job  marital  education  ... poutcome   y  proba_no proba_yes. {scriptName=services.dataiku.greengrass.DataikuScoreEdge.lifecycle.Run, serviceName=dataiku.greengrass.DataikuScoreEdge, currentState=RUNNING}
        2025-02-04T14:37:47.470Z [INFO] (Copier) dataiku.greengrass.DataikuScoreEdge: stdout. 0   58    management  married   tertiary  ...  unknown  no  0.790262  0.209738. {scriptName=services.dataiku.greengrass.DataikuScoreEdge.lifecycle.Run, serviceName=dataiku.greengrass.DataikuScoreEdge, currentState=RUNNING}
        2025-02-04T14:37:47.471Z [INFO] (Copier) dataiku.greengrass.DataikuScoreEdge: stdout. 1   44    technician   single  secondary  ...  unknown  no  0.949225  0.050775. {scriptName=services.dataiku.greengrass.DataikuScoreEdge.lifecycle.Run, serviceName=dataiku.greengrass.DataikuScoreEdge, currentState=RUNNING}
        2025-02-04T14:37:47.471Z [INFO] (Copier) dataiku.greengrass.DataikuScoreEdge: stdout. 2   33  entrepreneur  married  secondary  ...  unknown  no  0.977645  0.022355. {scriptName=services.dataiku.greengrass.DataikuScoreEdge.lifecycle.Run, serviceName=dataiku.greengrass.DataikuScoreEdge, currentState=RUNNING}
        2025-02-04T14:37:47.472Z [INFO] (Copier) dataiku.greengrass.DataikuScoreEdge: stdout. 3   47   blue-collar  married    unknown  ...  unknown  no  0.939934  0.060066. {scriptName=services.dataiku.greengrass.DataikuScoreEdge.lifecycle.Run, serviceName=dataiku.greengrass.DataikuScoreEdge, currentState=RUNNING}
        2025-02-04T14:37:47.473Z [INFO] (Copier) dataiku.greengrass.DataikuScoreEdge: stdout. 4   33       unknown   single    unknown  ...  unknown  no  0.710869  0.289131. {scriptName=services.dataiku.greengrass.DataikuScoreEdge.lifecycle.Run, serviceName=dataiku.greengrass.DataikuScoreEdge, currentState=RUNNING}
        2025-02-04T14:37:47.473Z [INFO] (Copier) dataiku.greengrass.DataikuScoreEdge: stdout. {scriptName=services.dataiku.greengrass.DataikuScoreEdge.lifecycle.Run, serviceName=dataiku.greengrass.DataikuScoreEdge, currentState=RUNNING}
        2025-02-04T14:37:47.474Z [INFO] (Copier) dataiku.greengrass.DataikuScoreEdge: stdout. [5 rows x 19 columns]. 
        




## Wrapping up

From this starting point, you can swap the Bank Marketing model with your own use case. You can customize the scoring script and Greengrass component recipe to do something different on an edge device.

---

## [tutorials/machine-learning/model-import/index]

# Model Import

  * [Importing serialized scikit-learn pipelines as Saved Models for MLOps](<scikit-pipeline/index.html>)

---

## [tutorials/machine-learning/model-import/scikit-pipeline/index]

# Importing serialized scikit-learn pipelines as Saved Models for MLOps

This tutorial shows how to save a model trained using code into a native Dataiku object for model management. It uses a simple tabular dataset and a scikit-learn pipeline. As long as the intermediate assets are saved, this model development could occur inside or outside Dataiku. Similar pipelines could accommodate other frameworks and data types.

Teams and organizations can have bespoke model pipelines and rules that are not fully integrated with Dataiku. This tutorial shows how to bring models via code into the platform for model lifecycle management as first-class citizens, similar to its [automated machine learning models](<https://doc.dataiku.com/dss/latest/machine-learning/auto-ml.html>). This last-mile integration is a key feature of Dataiku’s MLOps capabilities. It allows for the inspection, evaluation, deployment and governance of models trained using code.

## Prerequisites

  * Dataiku >= 12.0

  * Access to a project with “write project content” permissions

  * A Python code environment with the `scikit-learn`, `mlflow` and `protobuf` (not for Python 3.10+) packages installed




Note

This tutorial was tested using `python==3.9`, `scikit-learn==1.0.2`, `mlflow==2.9.2` and `protobuf==3.16.0` but other versions [could work](<https://doc.dataiku.com/dss/latest/mlops/mlflow-models/limitations.html> "\(in Dataiku DSS v14\)").

## Overview of the steps

This tutorial covers model development in three simplified steps. Each of the scripts focuses on one of the following:

  1. Preparing the data, i.e. all steps _before_ model development

  2. Creating the model object, i.e. the model development

  3. Saving the model as a Dataiku object, i.e. what happens _after_




Here are the steps represented as a Dataiku project flow.

## Step 1: Pre-modeling tasks

To kick off this process, you’ll need two things:

  * the _model artifact_ , a serialized version of the trained model object

  * an _evaluation dataset_ that is needed to monitor model performance and provide other metrics




Pipelines running outside Dataiku could produce this model artifact. Here, you’ll start from scratch with some data and progress towards that model object within the platform. For simplicity and completeness, you’ll generate it from the easily accessible [UCI Bank Marketing dataset](<https://archive.ics.uci.edu/dataset/222/bank+marketing>).

Create a Python recipe to create the initial dataset (`bank`). The script below prepares the data before model development. It defines the [URL](<https://archive.ics.uci.edu/static/public/222/bank+marketing.zip>) to download the data archive and stores the relevant CSV as a `pandas` dataframe. Using that dataframe and the Dataiku APIs, this step saves the schema and the file contents to a Dataiku dataset.

[Python script - Step 1](<../../../../_downloads/1e3a2e249228b51fbcfc8dc7789be290/step1_prep.py>)
    
    
    # Libraries
    import io
    import requests
    import zipfile
    import pandas as pd
    import dataiku
    
    BANK_DATA_URL = 'https://archive.ics.uci.edu/static/public/222/bank+marketing.zip'
    
    with requests.get(BANK_DATA_URL, stream=True) as r:
        archive = zipfile.ZipFile(io.BytesIO(r.content))
        archive.extractall()
    
    bank_zip = [archive.open(name) for name in archive.namelist() \
        if name == 'bank.zip']
    
    with zipfile.ZipFile(bank_zip[0]) as z:
        for filename in z.namelist():
            if filename == 'bank.csv':
                df = pd.read_csv(z.open(filename), sep=';')
    
    DATASET = 'bank'
    ds = dataiku.Dataset(DATASET)
    ds.write_with_schema(df)
    

## Step 2: Model development

Next, you will use some standard scikit-learn code to create a model stored in a serialized format as a pickle. First, copy the following code in your [project libraries](<https://developer.dataiku.com/latest/getting-started/environment-setup/index.html#building-a-shared-code-base>) that you will find at **< /> > Libraries**.

Note

Code libraries also provide a way to integrate with a larger code base from outside Dataiku that might have modules and scripts required for model development. Read more about the ability to pull from an external code base [here](<https://developer.dataiku.com/latest/getting-started/environment-setup/index.html#bringing-an-external-code-base>).

Under `python/`, create a directory named `model_gen` containing two files:

  1. an empty `__init__.py` file

  2. a `sk_pipeliner.py` script with code to train a scikit-learn model and save the test set as an evaluation dataset




Copy this code into the second file, i.e. the non-empty Python script:

[Python function](<../../../../_downloads/330131b99cb1c3a9236c1a8a7671ab2c/sk_pipeliner.py>)
    
    
    import pandas as pd
    from sklearn.model_selection import train_test_split
    from sklearn.pipeline import Pipeline, make_pipeline
    from sklearn.impute import SimpleImputer
    from sklearn.preprocessing import OneHotEncoder, StandardScaler
    from sklearn.compose import ColumnTransformer
    from sklearn.ensemble import RandomForestClassifier
    
    
    def split_and_train_pipeline(df: pd.DataFrame, test_size: float):
        """
        Return a tuple made of:
        - evaluation data in a df
        - sklearn estimator
        """
    
        # Split
        num_features = ["age", "balance", "duration", "previous", "campaign"]
        cat_features = [
            "job",
            "marital",
            "education",
            "default",
            "housing",
            "loan",
            "contact",
            "poutcome",
        ]
        target = "y"
        cols = num_features + cat_features
        cols.append(target)
    
        df_train, df_test = train_test_split(
            df[cols], test_size=test_size, random_state=42, shuffle=True
        )
        X_train = df_train.drop(target, axis=1)
        y_train = df_train[target]
    
        num_pipeline = Pipeline(
            [
                ("imp", SimpleImputer(strategy="median")),
                ("sts", StandardScaler()),
            ]
        )
        transformers = [
            ("num", num_pipeline, num_features),
            ("cat", OneHotEncoder(handle_unknown="ignore"), cat_features),
        ]
        preprocessor = ColumnTransformer(transformers, remainder="drop")
    
        clf = RandomForestClassifier(
            n_estimators=40, n_jobs=-1, max_depth=6, min_samples_leaf=20
        )
        pipeline = make_pipeline(preprocessor, clf)
        pipeline.fit(X_train, y_train)
    
        return pipeline, df_test
    

Back in the project Flow, create a Python recipe with:

  1. a single input: the `bank` dataset created in the last step

  2. two outputs: a new dataset called `bank_test`, which will serve as the evaluation dataset, and a new managed folder (`model_folder`) to host the model artifact. _Take note of the folder id and add it to the code below for this step._




Note

Folder ids are a [property](<https://developer.dataiku.com/latest/api-reference/python/managed-folders.html#dataikuapi.dss.managedfolder.DSSManagedFolder.id>) of a managed folder, uniquely identifying it within a Dataiku project. It can be found on the page URL when the item is opened on the Dataiku UI (`/projects/LLMM_TESTS/managedfolder/[FOLDER_ID]`) and is composed of 8 random characters, e.g. `L3dZ3p1n`.

Replace the initial recipe content with code from this script. In conjunction with the function from the project libraries, this Python recipe creates the machine learning pipeline. It invokes the `split_and_train_pipeline` function from `sk_pipeliner` to train a model on the `df` dataframe obtained from the `bank` dataset. The pipeline object is stored as `pipeline.pkl` within a managed folder, which can be located on the Dataiku server, on cloud object storage or elsewhere. Additionally, the function returns a test dataset (`df_test`), which is saved as the `bank_test` dataset. The workflow also ensures that the evaluation dataset has the same schema as the dataset on which model training occurred.

[Python script - Step 2](<../../../../_downloads/0721151a5f164257d6ac1cc5fbc7be45/step2_pickle.py>)
    
    
    import dataiku
    import pickle
    
    from model_gen.sk_pipeliner import split_and_train_pipeline
    
    df = dataiku.Dataset("bank") \
        .get_dataframe()
    
    pipeline, df_test = split_and_train_pipeline(df, test_size=0.2)
    
    bank_test = dataiku.Dataset("bank_test") \
        .write_with_schema(df_test)
    
    FOLDER_ID = ""  # Enter your managed folder id here
    
    model_folder = dataiku.Folder(FOLDER_ID)
    
    with model_folder.get_writer("/pipeline.pkl") as writer:
        pickle.dump(pipeline, writer)
    

## Step 3: Saving as a Dataiku object

The final step is to convert the model artifact, i.e. the serialized pickle, into a Saved Model, a native Dataiku object. The immediate advantage is that Saved Models possess many post-training features like extensive [model evaluation](<https://knowledge.dataiku.com/latest/ml/model-results/concept-visual-model-summary.html>).

This part will create a new Saved Model on the flow from the scikit-learn pipeline. Saved Models can import models trained using code via one of the [MLflow](<https://doc.dataiku.com/dss/latest/mlops/mlflow-models/index.html>) integrations. So, along the way, you’ll transform the scikit pipeline into an MLflow model via the Dataiku APIs.

A new Saved Model is not allowed as the output of a Python recipe, so it needs to be created programmatically first. As such, the following code needs to be run in a Dataiku Python notebook initially. Go to **< /> > Notebooks > New notebook > Write your own > Python** and create a new notebook _with the code environment specified in the prerequisites_. Execute all lines to create a model flow item, convert the pickle and load its MLflow equivalent into the Dataiku Saved Model.

[Python script - Step 3](<../../../../_downloads/828b91ad08f2438a1b9db7d37405a4b1/step3_savedmodel.py>)
    
    
    import dataiku
    import pickle
    import mlflow
    
    # Fill the models managed folder id below
    MODEL_FOLDER_ID = ""
    # Use name of the code environment from prerequisites
    MLFLOW_CODE_ENV_NAME = ""
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    # Use for Dataiku Cloud
    # client._session.verify = False
    
    # use or create SavedModel
    SAVED_MODEL_NAME = "clf"
    SAVED_MODEL_ID = None
    
    for sm in project.list_saved_models():
        if SAVED_MODEL_NAME != sm["name"]:
            continue
        else:
            SAVED_MODEL_ID = sm["id"]
            print(
                "Found SavedModel {} with id {}".format(
                    SAVED_MODEL_NAME, SAVED_MODEL_ID))
            break
    if SAVED_MODEL_ID:
        sm = project.get_saved_model(SAVED_MODEL_ID)
    else:
        sm = project.create_mlflow_pyfunc_model(
            name=SAVED_MODEL_NAME,
            prediction_type="BINARY_CLASSIFICATION")
        SAVED_MODEL_ID = sm.id
        print(
            "SavedModel not found, created new one with id {}".format(
                SAVED_MODEL_ID))
    
    # Load model from pickle file
    folder = dataiku.Folder(MODEL_FOLDER_ID)
    with folder.get_download_stream("/pipeline.pkl") as f:
        model = pickle.load(f)
    
    # Create MLflow model via a dummy experiment run
    folder_api_handle = project.get_managed_folder(MODEL_FOLDER_ID)
    mlflow_extension = project.get_mlflow_extension()
    with project.setup_mlflow(managed_folder=folder_api_handle) as mf:
        mlflow.set_experiment("dummy_xpt")
        with mlflow.start_run(run_name="dummy_run") as run:
            mlflow.sklearn.log_model(sk_model=model, artifact_path="dummy_model")
            mlflow_extension.set_run_inference_info(
                run_id=run._info.run_id,
                prediction_type='BINARY_CLASSIFICATION',
                classes=list(model.classes_),
                code_env_name=MLFLOW_CODE_ENV_NAME)
    
    # Deploy MLflow model as a saved model version
    mlflow_extension.deploy_run_model(
        run_id=run._info.run_id,
        sm_id=SAVED_MODEL_ID,
        version_id="v01",
        evaluation_dataset="bank_test",
        target_column_name="y")
    

Let’s break down some parts of the script to understand the process.

  * This code block creates an empty model flow item (`clf`). It checks whether such an object already exists, which will be helpful in subsequent runs. It specifies that the Saved Model holds MLflow models (`create_mlflow_pyfunc_model()`) for binary classification prediction.



    
    
    for sm in project.list_saved_models():
        if SAVED_MODEL_NAME != sm["name"]:
            continue
        else:
            SAVED_MODEL_ID = sm["id"]
            print(
                "Found SavedModel {} with id {}".format(
                    SAVED_MODEL_NAME, SAVED_MODEL_ID))
            break
    if SAVED_MODEL_ID:
        sm = project.get_saved_model(SAVED_MODEL_ID)
    else:
        sm = project.create_mlflow_pyfunc_model(
            name=SAVED_MODEL_NAME,
            prediction_type="BINARY_CLASSIFICATION")
    

  * The model is then deserialized from the pickle file (`pipeline.pkl`) located in the managed folder.



    
    
    folder = dataiku.Folder(MODEL_FOLDER_ID)
    with folder.get_download_stream("/pipeline.pkl") as f:
        model = pickle.load(f)
    

  * Then, the deserialized model is logged as an MLflow model via [experiment tracking](<https://developer.dataiku.com/latest/concepts-and-examples/experiment-tracking.html>)–a dummy run functions as a conversion step.



    
    
    with project.setup_mlflow(managed_folder=folder_api_handle) as mf:
        mlflow.set_experiment("dummy_xpt")
        with mlflow.start_run(run_name="dummy_run") as run:
            mlflow.sklearn.log_model(sk_model=model, artifact_path="dummy_model")
            mlflow_extension.set_run_inference_info(
                run_id=run._info.run_id,
                prediction_type='BINARY_CLASSIFICATION',
                classes=list(model.classes_),
                code_env_name=MLFLOW_CODE_ENV_NAME)
    

  * Finally, comparing the model results with the `evaluation_dataset` _bank_test_ , `mlflow_extension.deploy_run_model()` triggers the evaluation features, unlocking the explainability and interpretability visualizations in the Dataiku UI.



    
    
    # Deploy MLflow model as a saved model version
    mlflow_extension.deploy_run_model(
        run_id=run._info.run_id,
        sm_id=SAVED_MODEL_ID,
        version_id="v01",
        evaluation_dataset="bank_test",
        target_column_name="y")
    

## Wrapping up

If you want to add the last script in the flow, use the **Create Recipe** button on the notebook to create a Python recipe with `model_folder` and `bank_test` as inputs and the Dataiku model object (`clf`) as the output. You could use just this step to import pickled models into Dataiku. Of course, there are technical considerations and constraints during such an import. Among others, you’ll have to ensure the evaluation dataset has the same schema as the training dataset and the consistency of the Python packages used.

---

## [tutorials/machine-learning/models/lime/index]

# Using LIME for Model Explainability

## Introduction

As machine learning models like deep neural networks and ensemble methods increase in complexity, understanding why a model makes certain predictions is crucial. As these models often operate as **black boxes** , it becomes challenging to trust their outputs, especially in critical fields like healthcare, finance, and legal systems. This is where model explainability comes into play, and **LIME (Local Interpretable Model-agnostic Explanations)** is one of the most powerful tools in this domain.

LIME provides an intuitive **human-readable explanation** for _individual predictions_ and for a _model as a whole_. Unlike traditional evaluation metrics, which provide a general sense of model performance, LIME focuses on explaining specific outputs, making it particularly valuable for _identifying biases_ , _debugging models_ , or _building trust with stakeholders_.

LIME can be applied to binary, multi-class classification, and regression models. It can take numerical, categorical, text, and image inputs. _For the scope of this tutorial, we will focus on a binary classification model that predicts numerical and categorical features._

Let’s dive in!

## Prerequisites

  * Dataiku >= 12.0

  * Python >=3.9

  * A code environment:

    * with the `Dataiku Visual Machine Learning Packages` package set installed

    * with the following packages:
          
          lime
          matplotlib
          

  * Expected initial state:

    * Know the basic concepts of LIME. See [blog post](<https://www.oreilly.com/content/introduction-to-local-interpretable-model-agnostic-explanations-lime/>)

    * Have a trained Binary Classification Saved Model deployed to the Flow in a Dataiku Project.




Warning

For compatibility reasons, it is recommended that you use the same code environment (version and packages) for this tutorial as the one used for the Model training.

## Step 0: Import requires packages
    
    
    # -*- coding: utf-8 -*-
    import dataiku
    import pandas as pd, numpy as np
    
    import warnings
    import logging
    import sklearn
    import copy
    
    import lime
    from lime import lime_tabular
    from lime import submodular_pick
    

## Step 1: Load the Active SMV
    
    
    ## Replace SAVE_MODEL_ID and TRAIN_DATASET_NAME with valid identifiers taken from your project
    
    model = dataiku.Model("SAVED_MODEL_ID")
    pred = model.get_predictor()
    input_df = dataiku.Dataset("TRAIN_DATASET_NAME").get_dataframe()
    

## Step 2: Prepare an _interpretable representation_ of the data for the LIME Explainer

We first need to fetch the _feature handling_ used in the Active Saved Model Version and extract:

  * All the selected features

  * The target

  * The categorical features

  * The numerical features



    
    
    features = []
    target = None
    cat_features = []
    num_features = []
    feature_prep = pred.params.preprocessing_params.get("per_feature",{})
    for k, v in feature_prep.items():
        if v["role"] == "INPUT":
            features.append(k)
            if v["type"] == "CATEGORY":
                cat_features.append(k)
            elif v["type"] == "NUMERIC":
                num_features.append(k)
            else:
                logging.warning(f"type {v['type']} is not supported")
        elif v["role"] == "TARGET":
            target = k
        elif v["role"] == "REJECT":
            pass
        else:
            logging.warning(f"role {v['role']} is not supported")
    

We can then use the activated `features` to build and store the training features in a numpy 2D Array.
    
    
    training_df = input_df[features]
    data = training_df.to_numpy()
    

The LIME explainer requires all input features to be numerical. We, therefore, need to transform all of the input categorical features to feed them as input to the LIME explainer.
    
    
    categorical_features = [i for i,feature in enumerate(features) if feature in cat_features]
    
    categorical_names = {}
    for feature in categorical_features:
        le = sklearn.preprocessing.LabelEncoder()
        le.fit(data[:, feature])
        data[:, feature] = le.transform(data[:, feature])
        categorical_names[feature] = le.classes_
    

The last step to make our data LIME Explainer compliant is to cast our feature arrays as all floats.
    
    
    data = data.astype(float)
    

## Step 3: Build LIME Explainer

For this example, we will use the `LimeTabularExplainer` explainer, but for other use cases, the `LimeTextExplainer` or `LimeImageExplainer` could be more relevant.
    
    
    explainer = lime_tabular.LimeTabularExplainer(mode = "classification",
                                                training_data = data,
                                                feature_names = features,
                                                class_names = pred.get_classes(),
                                                categorical_features= categorical_features,
                                                categorical_names = categorical_names,
                                                discretize_continuous = False, # To resolve ValueError: Domain error in arguments.
                                                kernel_width=3,
                                                verbose = True)
    

The lime explainer is now ready! We have one last step before running lime explanations on our test instances. We need to define a **predict** function that can take a list of instances in their _interpretable representation_ and run them through our Dataiku **Saved Model** to get a list of **predictions**.
    
    
    def dku_pred_fn(records):
        decoded_records = []
        for x in records: # decode records
            decoded_record = [categorical_names[i][int(x[i])] if i in categorical_features else value for i, value in enumerate(x)]
            decoded_records.append(decoded_record)
        x_pred = pred.predict(pd.DataFrame(data = decoded_records, columns = features))
        return x_pred.to_numpy()[:,1:].astype(float)
    

## Step 4: Run LIME Explainer on a Single Instance

To run the Explainer on a single Instance, we need to feed it in its _human interpretable format_ and encode all categorical features when applicable. For simplicity, here, we will reuse rows from the previously prepared `data`.
    
    
    np.random.seed(1)
    i = 50
    exp = explainer.explain_instance(data_row = data[i], 
                                    predict_fn = dku_pred_fn, 
                                    num_features=5)
    exp.show_in_notebook(show_all=False)
    

Figure 1: Result of LIME Explainer on a Single Instance.

We just computed our first explanation as shown in Figure 1! It is time to generate visualizations and publish them in a Dashboard to share them with the relevant stakeholders. To do so, we will leverage [static insights](<https://knowledge.dataiku.com/latest/visualize-data/static-insights/concept-static-insights.html>), resulting in a plot similar to Figure 2.
    
    
    from dataiku import insights
    # Option 1
    insights.save_data("LIME_single_instance_exp_html",payload = exp.as_html(), content_type = "text/html")
    
    # Option 2
    fig = exp.as_pyplot_figure()
    insights.save_figure("LIME_single_instance_exp_plotly")
    

Figure 2: Insight of the explanation.

## Step 5: Run SP-LIME Explainer for a global representation of the model.

We can go one step further and run SP-LIME. SP-LIME with return `num_exps_desired` explanations on a sample set to provide a non-redundant global decision boundary of the original model. The _resulting explanations_ can be viewed in the same way as the individual explanation visualizations.
    
    
    sp_obj = submodular_pick.SubmodularPick(explainer = explainer, 
                                            data = data,
                                            predict_fn = dku_pred_fn, 
                                            num_features=5,
                                            num_exps_desired=10)
    non_redudant_global_exps = sp_obj.sp_explanations
    

## Wrapping up

In this tutorial, we applied LIME and SP-LIME to a Dataiku Saved Model and published the results on a Dataiku Dashboard. We can now confidently explain the decision mechanisms of any black box model in a human-interpretable way. This allows us to:

  1. Chose between competing models

  2. Detect and improve untrustworthy models

  3. Get insights into the model




As a next step, we could explore the application of LIME to **Text** , **Image-based** Classification models, or Tabular **Regression** models. For more intuition on the inner workings of LIME, we recommend reading [this blog](<https://www.oreilly.com/content/introduction-to-local-interpretable-model-agnostic-explanations-lime/>) or the [research paper behind LIME](<https://arxiv.org/abs/1602.04938>)

---

## [tutorials/machine-learning/models/predictive-maintenance/index]

# Predictive Model Maintenance for Binary Classification

## How can you predict performance before getting the ground truth?

Once a model is trained on labeled data and evaluated on labeled holdout data it is time to deploy it into production.

The next step is to wait for the data on which the model has scored to be labeled so we can assess its performance and decide whether to retrain it.

A risk arises when the time between scoring the data and labeling it with its ground truth is so long that the model performance has already deteriorated.

This is where heuristic model performance metrics without ground truth become crucial. Examples of those would be metrics like prediction or data drift; both are built into the [Model Evaluation Store](<https://knowledge.dataiku.com/latest/deploy/model-monitoring/concept-model-evaluation-stores.html>).

In this tutorial, we will apply [Confidence-based Performance Estimation (CBPE)](<https://nannyml.readthedocs.io/en/v0.4.1/how_it_works/performance_estimation.html>) to a Binary classification to estimate Model Accuracy and AUC from the predicted class probabilities.

CBPE is a concept introduced by Nanny ML. To read more about how it works, please visit the links above.

## Requirements

  * Dataiku > 13.4

  * Python Version >=3.9

  * A code environment:

    * with the visual machine learning package set installed

    * with the following packages:
          
          plotly
          




### Initial state & Assumptions

  * Have a Deployed Binary Classification Model to the Flow

  * The model predicted probabilities should be **well-calibrated**.

  * There is a big enough set of unlabeled observations previously scored by our model.

  * There should not be any concept drift - Data drift is accepted.




Through this tutorial, we will compute and estimate the Accuracy and the AUC of the model on new, unseen, and unlabelled observations.

## Importing the libraries
    
    
    import dataiku
    import pandas as pd, numpy as np
    
    import plotly.express as px
    from dataikuapi.dss.modelevaluationstore import DSSModelEvaluationStore
    from datetime import datetime
    

We start by loading all of our score observations.
    
    
    # Read recipe inputs
    new_records = dataiku.Dataset("TRANSACTIONS_unknown_scored")
    df = new_records.get_dataframe()
    

## Compute the CBPE Model Accuracy

We start by extracting the positive class probabilities and the number of observations from the input dataset,
    
    
    positive_outcome_proba_col = "proba_1"
    proba = df[positive_outcome_proba_col] # Probability of positive class
    n = len(df.index)
    

To convert the positive probabilities to predictions, we need to set a decision threshold. In this tutorial, we set it to 0.5, but it can be changed based on the use case.

Note

The Dataiku Lab automatically computes the Optimal Threshold best for optimizing the selected metric.

Given that the model probabilities are calibrated, we can extract each prediction’s probability to be **True Positive** , **False Positive** , **False Negative** or **True Negative**. We can then add all of these probabilities for each category which gives us the expected TP, FP, FN and TN amounts.

See [this](<https://medium.com/towards-data-science/predict-your-models-performance-without-waiting-for-the-control-group-3f5c9363a7da>) blog post for more insight into how this works.
    
    
    threshold = 0.5
    pred = proba >= threshold
    
    tp = np.sum((pred == 1) * proba)
    fp = np.sum((pred == 1) * (1 - proba))
    fn = np.sum((pred == 0) * proba)
    tn = np.sum((pred == 0) * (1 - proba))
    

With the TP, FP, FN, and TN computed, we can now compute classic performance metrics such as precision, recall, F1 score, average precision, etc.

Here is an example of how we can compute the CBPE Accuracy.
    
    
    # Compute CBPE Accuracy = (True Positive + True Negative) / Number of observations
    cbpe_accuracy = (tp + tn)/n
    print (f"CBPE Accuracy : {cbpe_accuracy}")
    

## Compute the CBPE Model ROC AUC

To compute a metric that is independent of the select threshold, we can compute the ROC AUC.

We need to compute :

  * the **True Positive Rate** also known as **Recall** or **Sensitivity**

  * and the **False Positive Rate** also know as the **“false alarm rate”**.




for a set of thresholds ranging from 0 to 1.
    
    
    # Compute CBPE AUC = Area under the True Positive Rate *
    #                    True Negative Rate Curve for every threshold.
    
    n_thresholds = 100 # Can be changed
    thresholds = [x /n_thresholds  for x in range(1, n_thresholds)]
    
    tprs = []
    fprs = []
    for threshold in thresholds:
        pred = proba >= threshold
        tp = np.sum((pred == 1) * proba)
        fp = np.sum((pred == 1) * (1 - proba))
        fn = np.sum((pred == 0) * proba)
        tn = np.sum((pred == 0) * (1 - proba))
    
        tprs.append(tp/(tp + fn)) # Correctly classified Positive Cases over ALL Positive Cases.
        fprs.append(fp/(fp + tn)) # Wrongly classified Negative Cases over ALL Negative Cases.
    

In order to visualize the generated ROC curve, we plot it using a plotly scatter plot.
    
    
    px.scatter(pd.DataFrame({'fpr': fprs, 'tpr': tprs, "thresholds" : thresholds}),
               x="fpr",
               y="tpr",
               hover_data = "thresholds")
    

We can now compute the Area under the ROC curve. We will use a built-in `sklearn` function to do this.
    
    
    from sklearn.metrics import auc
    
    cbpe_roc_auc = auc(x=fprs, y=tprs)
    print(f"CBPE ROC-AUC : {cbpe_roc_auc}")
    

## Saving the computed metrics to a Dataiku MES

Now that our estimated model performances have been computed based on predictions made on real unlabelled data, the next natural step is to save those metrics as MES Metrics.

In the following steps, we:

  1. Fist need to format our metrics in a Dataiku MES format and add them to a list.

  2. Get a handle on the output MES (That you might have to create if it is not already done)

  3. Add the metrics to the MES.



    
    
    scores = []
    
    scores.append(
        DSSModelEvaluationStore.MetricDefinition(
            code="CBPE_ROC_AUC",
            value=cbpe_roc_auc,
            name="CBPE ROC-AUC",
            description="CBPE_ROC_AUC"
        ))
    scores.append(
        DSSModelEvaluationStore.MetricDefinition(
            code="CBPE Accuracy",
            value=cbpe_accuracy,
            name="CBPE Accuracy",
            description="CBPE Accuracy"
        )
    )
    
    mes = dataiku.api_client().get_default_project().get_model_evaluation_store("D7QrPRxd")
    eval_timestamp = datetime.now().isoformat()
    label = DSSModelEvaluationStore.LabelDefinition("evaluation:date", eval_timestamp)
    mes.add_custom_model_evaluation(scores, labels=[label])
    

## Going further with the MES: Adding a Custom MES Metric

Given that CBPE metrics only require a set of unlabelled evaluation datasets and the model’s predictions, we can go one step further and directly integrate these metrics in an MES and have them computed at every new evaluate recipe run ; the evaluate recipe is already computing metrics like prediction drift and concept drift.

As of Dataiku 13.4, we can now add custom metrics to the MES, via the configuration of the evaluate recipe.

Adding the following code, in the custom metrics of a MES, will allow the metrics to be computed every time it is needed.
    
    
    # Accuracy
    import numpy as np
    
    def score(y_valid, y_pred, eval_df, output_df, ref_sample_df=None, sample_weight=None, **kwargs):
        """
        Compute CBPE Accuracy = (True Positive + True Negative) / Number of observations
        """
        proba = y_pred[:,1]
        threshold = 0.5 #
        n = len(proba)
        pred = proba >= threshold
    
        tp = np.sum((pred == 1) * proba)
        fp = np.sum((pred == 1) * (1 - proba))
        fn = np.sum((pred == 0) * proba)
        tn = np.sum((pred == 0) * (1 - proba))
    
        cbpe_accuracy = (tp + tn)/n
    
        return cbpe_accuracy
    

We also need to pay attention to the custom metric definition, as shown below.

## Automate the retraining process

Once the Metrics are added to an MES, you can [build checks](<https://knowledge.dataiku.com/latest/deploy/model-monitoring/basics/tutorial-index.html#create-a-check-on-a-mes-metric>) that can trigger the run of automatic maintenance tasks, such as notifying an ML Engineer to automatically trigger a retraining on the model through a [Dataiku Scenario](<https://knowledge.dataiku.com/latest/automate-tasks/scenarios/concept-scenarios.html>).

## Wrap Up

In this notebook, we have computed CBPE performance metrics based on prediction probabilities made on new unlabeled data. We then published these metrics to a Dataiku Model Evaluation Store plugged into an automatic notification or a retraining pipeline.

This allows us to have and act upon performance insights much faster than if we had to wait for ground-truth data.

As a next step, we would recommend applying similar techniques to other prediction types:

  * Apply CBPE for [multi-label classification](<https://nannyml.readthedocs.io/en/v0.4.1/how_it_works/performance_estimation.html#multiclass-classification>)

  * Apply DLE for [regression models](<https://nannyml.readthedocs.io/en/v0.12.1/how_it_works/performance_estimation.html#direct-loss-estimation-dle>)

---

## [tutorials/machine-learning/others/distributed-training/index]

# Distributed ML Training using Ray

This notebook provides an example of distributed ML training on [Ray](<https://docs.ray.io/en/latest/cluster/getting-started.html>). Specifically, it illustrates how to:

  1. Deploy a Ray Cluster on a [Dataiku-managed Elastic AI cluster](<https://doc.dataiku.com/dss/latest/containers/managed-k8s-clusters.html> "\(in Dataiku DSS v14\)")

  2. Train a binary classification _xgboost_ model in a distributed fashion on the deployed Ray Cluster.




## Pre-requisites

  * [Dataiku-managed Elastic AI cluster](<https://doc.dataiku.com/dss/latest/containers/managed-k8s-clusters.html> "\(in Dataiku DSS v14\)")

  * A [code environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html> "\(in Dataiku DSS v14\)") with a Python version [supported by Ray](<https://docs.ray.io/en/latest/ray-overview/installation.html#docker-source-images>) (which at the time of writing are 3.9, 3.10 and 3.11) and with the following packages:
        
        ray[default, train, client]
        xgboost
        lightgbm
        pyarrow
        boto3
        tqdm
        mlflow==2.17.2
        scikit-learn==1.0.2
        statsmodels==0.13.5
        




Note

The code environment only needs to be built locally, i.e., [containerized execution support](<https://doc.dataiku.com/dss/latest/containers/code-envs.html> "\(in Dataiku DSS v14\)") is not required.

### Deploying a Dataiku-managed Elastic AI cluster

Before deploying the Ray Cluster, a Dataiku administrator must deploy an [Dataiku-managed Elastic AI cluster](<https://doc.dataiku.com/dss/latest/containers/managed-k8s-clusters.html> "\(in Dataiku DSS v14\)").

A few things to keep in mind about the Elastic AI Cluster:

  * Dataiku recommends creating a dedicated `nodegroup` to host the Ray Cluster; the `nodegroup` can be static or auto-scale.

  * Ray [recommends](<https://docs.ray.io/en/latest/cluster/kubernetes/getting-started/raycluster-quick-start.html#step-3-deploy-a-raycluster-custom-resource>) sizing each Ray Cluster pod to take up an entire Kubernetes node.

  * Dataiku recommends that each cluster node have at least 64 GB RAM for typical ML workloads.




## Deploying a Ray Cluster

The procedure to deploy a Ray Cluster onto a Dataiku-managed Elastic AI cluster is as follows.

By pluginAdvanced setup

Important

Note that this procedure requires Dataiku Administrator privileges.

  1. Install [this](<https://github.com/dataiku/dss-plugin-raycluster>) plugin.

  2. Navigate to the “Macros” section of a Dataiku project, search for the “Ray” macros, and select the “Start Ray Cluster” macro.




Figure 1.1 – Macros for Ray

  3. Fill in the macro fields, keeping in mind the following information:



  * KubeRay version: select the latest version from their [GitHub release](<https://github.com/ray-project/kuberay/releases>) page.

  * Ray image tag: should be a valid tag from [Ray’s DockerHub](<https://hub.docker.com/r/rayproject/ray>) images; the Python version of the image tag should match the Python version of the Dataiku code environment created in the pre-requisites section.

  * Ray version: must match the version on the Ray image tag.

  * The CPU / memory request should be at least 1 CPU / 1GB RAM less than the node’s schedulable amount.

  * The number of Ray Cluster agents (i.e., head + worker replicas) should be equal to (or smaller) than the max size of the default Kubernetes `nodegroup`.




Run the macro.

Figure 1.2 – Start macro

  4. Once the “Start Ray Cluster” is macro complete, run the “Inspect Ray Cluster” macro; this retrieves the Ray Cluster deployment status and provides the Ray Cluster endpoint once the cluster is ready.




Figure 1.3 – Inspect Ray Cluster

  5. Optionally, set up a port forwarding connection to <https://github.com/dataiku/dss-plugin-rayclustere> Ray Dashboard using the “Ray Dashboard Port-Forward” macro.




Figure 1.4 – Ray Dashboard Port-Forward

The Ray Dashboard will then be accessible at `http://\<Dataiku instance domain>:8265` while the macro is running.

Important

Note that this procedure requires SSH access to the Dataiku server.

  1. SSH onto the Dataiku server and switch to the [dssuser](<https://doc.dataiku.com/dss/latest/user-isolation/index.html> "\(in Dataiku DSS v14\)").

  2. Point `kubectl` to the `kubeconfig` of the Elastic AI cluster onto which the Ray Cluster will be deployed:
         
         export KUBECONFIG=/PATH/TO/DATADIR/clusters/<cluster name>/exec/kube_config
         

where `/PATH/TO/DATADIR` is the path to Dataiku’s [data directory](<https://doc.dataiku.com/dss/latest/operations/datadir.html> "\(in Dataiku DSS v14\)"), and `<cluster name>` is the name of the Elastic AI cluster.

  3. Install the Ray Operator on the cluster:
         
         helm repo add kuberay https://ray-project.github.io/kuberay-helm/
         helm repo update
         helm install kuberay-operator kuberay/kuberay-operator --version 1.2.2
         

  4. Deploy the Ray Cluster:
         
         helm install -f ray-values.yaml --version 1.2.2 raycluster kuberay/ray-cluster
         

where `ray-values.yaml` is a file such as:
         
         image:
           tag: 2.40.0.22541c-py310
         
         head:
           rayVersion: 2.40.0
           nodeSelector:
             nodegroupName: rayNodegroup
           resources:
             limits:
               cpu: "7"
               memory: "30G"
             requests:
               cpu: "7"
               memory: "30G"
         
         worker:
           replicas: 2
           nodeSelector:
             nodegroupName: rayNodegroup
           resources:
             limits:
               cpu: "7"
               memory: "30G"
             requests:
               cpu: "7"
               memory: "30G"
         

Attention

     * The `image.tag` should be a valid tag from one of [Ray’s DockerHub](<https://hub.docker.com/r/rayproject/ray>) images.

     * The Python version of the `image.tag` should match the Python version of the Dataiku code environment created in the pre-requisites section.

     * The `head.rayVersion` must match the version on the `image.tag`.

     * The `head.resources.limits` should match the `head.resources.requests` values (and the same for the worker resources and limits) as per [Ray’s documentation](<https://docs.ray.io/en/latest/cluster/kubernetes/user-guides/config.html#resources>).

     * The CPU / memory request should be at least 1 CPU / 1GB RAM less than the node’s schedulable amount.

     * The number of Ray Cluster agents (i.e., head + worker replicas) should be equal to (or smaller) the max size of the Kubernetes `nodegroup` onto which they will be deployed (i.e., the `rayNodegroup`).

For the complete schema of the Ray Cluster values file, see [Ray’s GitHub repo](<https://github.com/ray-project/kuberay-helm/blob/main/helm-chart/ray-cluster/values.yaml>).

  5. Watch the Ray Cluster pods being created:
         
         kubectl get pods -A -w
         



  6. Once the head pod has been successfully created, describe it and determine its IP:
         
         kubect describe pod <ray-cluster-head-pod-name>
         

The Ray Cluster endpoint is `http://<head pod IP>:8265`.

  7. Optionally, setup a port forwarding connection to the Ray Dashboard:
         
         kubectl port-forward service/raycluster-kuberay-head-svc --address 0.0.0.0 8265:8265
         

The Ray Dashboard will be accessible at `http://<Dataiku instance domain>:8265`. Accessing it via a browser may require opening this port at the firewall.




If everything goes well, you should end up with something similar to:

Figure 1: Ray cluster is up and running

For more information on this procedure and how to further customize the deployment of a Ray Cluster on Kubernetes (e.g., creating an auto-scaling Ray Cluster), please refer to the relevant [Ray documentation](<https://docs.ray.io/en/latest/cluster/kubernetes/index.html>).

## Train an XGBoost Model

Now that you have a running Ray Cluster, you can train ML models on it in a distributed fashion. All they need to be provided with is the Ray Cluster endpoint, which was determined in step 6 of the Deploying a Ray Cluster section.

The following procedure illustrates how to train a binary classification _xgboost_ model on a Ray Cluster using a data-parallel paradigm. The example draws inspiration from this [code sample](<https://github.com/ray-project/ray/blob/master/release/train_tests/xgboost_lightgbm/train_batch_inference_benchmark.py>) published in Ray’s documentation.

First, you will need to create a [Project Library](<../../../../concepts-and-examples/project-libraries.html>) called `dku_ray` (under the `python` folder) with two files, `utils.py` and `xgboost_train.py`, with the following content:

[utils.py](<../../../../_downloads/dd17be476b7529311f41bb21e8a97b78/utils.py>)

utils.py
    
    
    import dataiku
    from ray.job_submission import JobStatus
    
    import time
    import os
    
    def s3_path_from_managed_folder(folder_id):
        """
        Retrieves full S3 path (i.e. bucket name + path in bucjet) for managed folder.
        Assumues managed folder is stored on S3 connection.
        
        TODO: actually check this, and don't just fail.
        """
        mf = dataiku.Folder(folder_id)
        mf_path = mf.get_info()["accessInfo"]["bucket"] + mf.get_info()["accessInfo"]["root"]
        
        return mf_path
    
    def s3_credentials_from_managed_folder(folder_id):
        """
        Retireves S3 credentials (access key, secret key, session token) from managed folder.
        Assumues managed folder is stored on S3 connection, with AssumeRole as auth method.
        
        TODO: actually check this, and don't just fail.
        """
        client = dataiku.api_client()
        project = client.get_default_project()
        
        mf = project.get_managed_folder(folder_id) # connection only available through client
        mf_connection_name = mf.get_settings().settings["params"]["connection"]
    
        mf_connection = client.get_connection(mf_connection_name)
        mf_connection_info = mf_connection.get_info()
        access_key = mf_connection_info["resolvedAWSCredential"]["accessKey"]
        secret_key = mf_connection_info["resolvedAWSCredential"]["secretKey"]
        session_token = mf_connection_info["resolvedAWSCredential"]["sessionToken"]
        
        return access_key, secret_key, session_token
    
    def s3_path_from_dataset(dataset_name):
        """
        Retrieves full S3 path (i.e. s3:// + bucket name + path in bucjet) for dataset.
        Assumues dataset is stored on S3 connection.
        
        TODO: actually check this, and don't just fail.
        """
        ds = dataiku.Dataset(dataset_name) # resolved path and connection name via internal API
        ds_path = ds.get_location_info()["info"]["path"]
        
        return ds_path
    
    def s3_credentials_from_dataset(dataset_name):
        """
        Retireves S3 credentials (access key, secret key, session token) from S3 dataset.
        Assumues dataset is stored on S3 connection, with AssumeRole as auth method.
        
        TODO: actually check this, and don't just fail.
        """
        client = dataiku.api_client()
        
        ds = dataiku.Dataset(dataset_name) # resolved path and connection name via internal API
        ds_connection_name = ds.get_config()["params"]["connection"]
    
        ds_connection = client.get_connection(ds_connection_name)
        ds_connection_info = ds_connection.get_info()
        access_key = ds_connection_info["resolvedAWSCredential"]["accessKey"]
        secret_key = ds_connection_info["resolvedAWSCredential"]["secretKey"]
        session_token = ds_connection_info["resolvedAWSCredential"]["sessionToken"]
        
        return access_key, secret_key, session_token
    
    def copy_project_lib_to_tmp(file_dir, file_name, timestamp):
        """
        Makes a copy of a project library file to a temporary location.
        Timestamp ensures file path uniqueness.
        """
        client = dataiku.api_client()
        project = client.get_default_project()
        project_library = project.get_library()
    
        file_path = file_dir + file_name
        file = project_library.get_file(file_path).read()
    
        # Stage train script in /tmp
        tmp_file_dir = f"/tmp/ray-{timestamp}/"
        tmp_file_path = tmp_file_dir + file_name
    
        os.makedirs(os.path.dirname(tmp_file_dir), exist_ok=True)
        with open(tmp_file_path, "w") as f:
            f.write(file)
        
        return tmp_file_dir
        
    def extract_packages_list_from_pyenv(env_name):
        """
        Extracts python package list (requested + mandatory) from an environment.
        Returns a list of python packages.
        """   
        client = dataiku.api_client()
        pyenv = client.get_code_env(env_lang="PYTHON", env_name=env_name)
        pyenv_settings = pyenv.get_settings()
        
        packages = pyenv_settings.settings["specPackageList"] + pyenv_settings.settings["mandatoryPackageList"]
        packages_list = packages.split("\n")
        
        return packages_list
        
    def wait_until_rayjob_completes(ray_client, job_id, timeout_seconds=3600):
        """
        Polls Ray Job for `timeout_seconds` or until a specofoc status is reached:
        - JobStatus.SUCCEEDED: return
        - JobStatus.STOPPED or JobStatus.FAILED: raise exception
        """
        start = time.time()
        
        while time.time() - start <= timeout_seconds:
            status = ray_client.get_job_status(job_id)
            print(f"Ray Job `{job_id}` status: {status}")
            if (status == JobStatus.SUCCEEDED) or (status == JobStatus.STOPPED) or (status == JobStatus.FAILED):
                print("Ray training logs: \n", ray_client.get_job_logs(job_id))
                break
            time.sleep(1)
        
        if (status == JobStatus.SUCCEEDED):
            print("Ray Job {job_id} completed successfully.")
            return
        else:
            raise Exception("Ray Job {job_id} failed, see logs above.")
            
            
        
        
    

[xgboost_train.py](<../../../../_downloads/0dc4262c53b93227852399e50e3e1e83/xgboost_train.py>)

xgboost_train.py
    
    
    # Inspired by from:
    #    https://github.com/ray-project/ray/blob/master/release/train_tests/xgboost_lightgbm/train_batch_inference_benchmark.py
    
    import json
    import numpy as np
    import os
    import pandas as pd
    import time
    from typing import Dict
    
    import xgboost as xgb
    from pyarrow import fs
    
    import ray
    from ray import data
    from ray.train.xgboost.v2 import XGBoostTrainer # https://github.com/ray-project/ray/blob/master/python/ray/train/xgboost/v2.py#L13
    from ray.train.xgboost import RayTrainReportCallback as XGBoostReportCallback
    from ray.train import RunConfig, ScalingConfig
    
    
    def xgboost_train_loop_function(config: Dict):
        # 1. Get the dataset shard for the worker and convert to a `xgboost.DMatrix`
        train_ds_iter = ray.train.get_dataset_shard("train")
        train_df = train_ds_iter.materialize().to_pandas()
    
        label_column, params = config["label_column"], config["params"]
        train_X, train_y = train_df.drop(label_column, axis=1), train_df[label_column]
    
        dtrain = xgb.DMatrix(train_X, label=train_y)
    
        # 2. Do distributed data-parallel training.
        # Ray Train sets up the necessary coordinator processes and
        # environment variables for your workers to communicate with each other.
        report_callback = config["report_callback_cls"]
        xgb.train(
            params,
            dtrain=dtrain,
            num_boost_round=10,
            callbacks=[report_callback()],
        )
    
    
    def train_xgboost(data_path: str,
                      data_filesystem,
                      data_label: str,
                      storage_path: str,
                      storage_filesystem,
                      num_workers: int,
                      cpus_per_worker: int,
                      run_name: str) -> ray.train.Result:
        
        print(storage_path)
        ds = data.read_parquet(data_path, filesystem=data_filesystem)
    
        train_loop_config= {
            "params": {
                "objective": "binary:logistic",
                "eval_metric": ["logloss", "error"]
            },
            "label_column": data_label,
            "report_callback_cls": XGBoostReportCallback
        }
        
        trainer = XGBoostTrainer(
            train_loop_per_worker=xgboost_train_loop_function,
            train_loop_config=train_loop_config,
            scaling_config=ScalingConfig( # https://docs.ray.io/en/latest/train/api/doc/ray.train.ScalingConfig.html
                num_workers=num_workers,
                resources_per_worker={"CPU": cpus_per_worker},
            ),
            datasets={"train": ds},
            run_config=RunConfig( # https://docs.ray.io/en/latest/train/api/doc/ray.train.RunConfig.html
                storage_path=storage_path, 
                storage_filesystem=storage_filesystem,
                name=run_name
            ),
        )
        result = trainer.fit()
        return result
    
    
    def main(args):
        # Build pyarrow filesystems with s3 credentials
        #  https://arrow.apache.org/docs/python/generated/pyarrow.fs.S3FileSystem.html#pyarrow.fs.S3FileSystem
        s3_ds = fs.S3FileSystem(
            access_key=args.data_s3_access_key,
            secret_key=args.data_s3_secret_key,
            session_token=args.data_s3_session_token
        )
        
        s3_mf = fs.S3FileSystem(
            access_key=args.storage_s3_access_key,
            secret_key=args.storage_s3_secret_key,
            session_token=args.storage_s3_session_token
        )
        
        print(f"Running xgboost training benchmark...")
        training_start = time.perf_counter()
        result = train_xgboost(
            args.data_s3_path, 
            s3_ds,
            args.data_label_column,
            args.storage_s3_path,
            s3_mf,
            args.num_workers, 
            args.cpus_per_worker, 
            args.run_name
        )
        training_time = time.perf_counter() - training_start
    
        print("Training result:\n", result)
        print("Training time:", training_time)
    
    
    if __name__ == "__main__":
        import argparse
    
        parser = argparse.ArgumentParser()
        
        # Train dataset arguments
        parser.add_argument("--data-s3-path", type=str)
        parser.add_argument("--data-s3-access-key", type=str)
        parser.add_argument("--data-s3-secret-key", type=str)
        parser.add_argument("--data-s3-session-token", type=str)
        parser.add_argument("--data-label-column", type=str)
        
        # storage folder arguments
        parser.add_argument("--storage-s3-path", type=str)
        parser.add_argument("--storage-s3-access-key", type=str)
        parser.add_argument("--storage-s3-secret-key", type=str)
        parser.add_argument("--storage-s3-session-token", type=str)
        
        # compute arguments
        parser.add_argument("--num-workers", type=int, default=2)
        parser.add_argument("--cpus-per-worker", type=int, default=1)
        parser.add_argument("--run-name", type=str, default="xgboost-train")
        
        args = parser.parse_args()
    
        main(args)
    

Second, you must create a dataset in the Flow to be used as the model’s training dataset. This example (and the code of the `dku_ray` project library) assumes that this dataset is:

  * on S3

  * in the parquet format

  * on a Dataiku S3 connection that uses STS with AssumeRole as its authentication method and that the user running the code has “details readable by” access on the connection




Note

Modifying the code with different connection and/or authentication types should be straightforward.

Third, you must create a managed folder in the Flow, where Ray will store the training process outputs. Similar to the training dataset, this example assumes the managed folder is on an S3 connection with the same properties listed above.

Finally, the following code can be used to train a model on the input dataset. In this case, the “avocado_transactions_train” is a slightly processed version of [this Kaggle dataset](<https://www.kaggle.com/datasets/neuromusic/avocado-prices>).

### Importing the required packages
    
    
    import dataiku
    from dku_ray.utils import (
        s3_path_from_managed_folder,
        s3_credentials_from_managed_folder,
        s3_path_from_dataset, 
        s3_credentials_from_dataset, 
        copy_project_lib_to_tmp,
        extract_packages_list_from_pyenv,
        wait_until_rayjob_completes
    )
    
    import time
    import os
    
    from ray.job_submission import JobSubmissionClient
    

### Setting the default parameters
    
    
    # Dataiku client
    client = dataiku.api_client()
    project = client.get_default_project()
    
    # Script params: YOU NEED TO ADAPT THIS PART
    train_dataset_name = "avocado_transactions_train"
    target_column_name = "type" # includes the 
    managed_folder_id = "CcLoevDh"
    
    ray_cluster_endpoint = "http://10.0.1.190:8265"
    
    
    train_script_filename = "xgboost_train.py" # name of file in Project Library
    train_script_dir = "/python/dku_ray/" # in project libs
    
    ray_env_name = "py310_ray" # dataiku code environment name
    num_ray_workers = 3 # num workers and cpus per worker should be sized approriately, 
                        # based on the size of the Ray Cluster deployed 
    cpus_per_ray_worker = 10
    
    timestamp = int(time.time()*100000) # unix timestamp in seconds
    

### Setting the training script
    
    
    # Train script
    ## Copy train script to temporary location (as impersonated users can't traverse project libs)
    tmp_train_script_dir = copy_project_lib_to_tmp(train_script_dir, train_script_filename, timestamp)
    
    # Inputs & outputs
    ## (a) Retrieve S3 input dataset path and credentials
    ##     Note: connection should be S3 and use AssumeRole; dataset file format should be parquet
    ds_path = s3_path_from_dataset(train_dataset_name)
    ds_access_key, ds_secret_key, ds_session_token = s3_credentials_from_dataset(train_dataset_name)
    
    ## (b) Retrieve output S3 managed folder path and credentials
    ##     Note: connection should be S3 and use AssumeRole
    storage_path = s3_path_from_managed_folder(managed_folder_id)
    storage_access_key, storage_secret_key, storage_session_token = s3_credentials_from_managed_folder(managed_folder_id)
    

### Submitting the job to Ray
    
    
    # Submit to remote cluster
    
    # Useful links:
    #   Ray Jobs SDK: https://docs.ray.io/en/latest/cluster/running-applications/job-submission/sdk.html
    #   Runtime env spec: https://docs.ray.io/en/latest/ray-core/api/runtime-env.html
    ray_client = JobSubmissionClient(ray_cluster_endpoint)
    
    entrypoint = f"python {train_script_filename} --run-name=\"xgboost-train-{timestamp}\" " + \
        f"--data-s3-path=\"{ds_path}\" --data-label-column=\"{target_column_name}\" " + \
        f"--data-s3-access-key={ds_access_key} --data-s3-secret-key={ds_secret_key} --data-s3-session-token={ds_session_token} " + \
        f"--storage-s3-path=\"{storage_path}\" " + \
        f"--storage-s3-access-key={storage_access_key} --storage-s3-secret-key={storage_secret_key} --storage-s3-session-token={storage_session_token} " + \
        f"--num-workers={num_ray_workers} --cpus-per-worker={cpus_per_ray_worker}"
    
    # Extract python package list from env
    python_packages_list = extract_packages_list_from_pyenv(ray_env_name)
        
    job_id = ray_client.submit_job(
        entrypoint=entrypoint,
        runtime_env={
            "working_dir": tmp_train_script_dir,
            "pip": python_packages_list
        }
    )
    
    # Wait until job fails or succeeds
    wait_until_rayjob_completes(ray_client, job_id)
    

Once you’ve submitted the job, you can see it running in the Ray dashboard shown below:

Figure 2 – Ray dashboard showing the running job

Once the job succeeds, you should be able to find the `xgboost` object in the managed folder designated as the “output.”

## Conclusion

You now know how to set up a Ray cluster to achieve distributed learning using the `xgboost` algorithm. Adapting this tutorial to your preferred algorithm and/or cluster should be easy.

Here is the complete code for this tutorial:

[code.py](<../../../../_downloads/9e22ef7f0f670d2e33ad1aa69b9026d1/code.py>)
    
    
    import dataiku
    from dku_ray.utils import (
        s3_path_from_managed_folder,
        s3_credentials_from_managed_folder,
        s3_path_from_dataset, 
        s3_credentials_from_dataset, 
        copy_project_lib_to_tmp,
        extract_packages_list_from_pyenv,
        wait_until_rayjob_completes
    )
    
    import time
    import os
    
    from ray.job_submission import JobSubmissionClient
    
    # Dataiku client
    client = dataiku.api_client()
    project = client.get_default_project()
    
    # Script params: YOU NEED TO ADAPT THIS PART
    train_dataset_name = "avocado_transactions_train"
    target_column_name = "type" # includes the 
    managed_folder_id = "CcLoevDh"
    
    ray_cluster_endpoint = "http://10.0.1.190:8265"
    
    
    train_script_filename = "xgboost_train.py" # name of file in Project Library
    train_script_dir = "/python/dku_ray/" # in project libs
    
    ray_env_name = "py310_ray" # dataiku code environment name
    num_ray_workers = 3 # num workers and cpus per worker should be sized approriately, 
                        # based on the size of the Ray Cluster deployed 
    cpus_per_ray_worker = 10
    
    timestamp = int(time.time()*100000) # unix timestamp in seconds
    
    # Train script
    ## Copy train script to temporary location (as impersonated users can't traverse project libs)
    tmp_train_script_dir = copy_project_lib_to_tmp(train_script_dir, train_script_filename, timestamp)
    
    # Inputs & outputs
    ## (a) Retrieve S3 input dataset path and credentials
    ##     Note: connection should be S3 and use AssumeRole; dataset file format should be parquet
    ds_path = s3_path_from_dataset(train_dataset_name)
    ds_access_key, ds_secret_key, ds_session_token = s3_credentials_from_dataset(train_dataset_name)
    
    ## (b) Retrieve output S3 managed folder path and credentials
    ##     Note: connection should be S3 and use AssumeRole
    storage_path = s3_path_from_managed_folder(managed_folder_id)
    storage_access_key, storage_secret_key, storage_session_token = s3_credentials_from_managed_folder(managed_folder_id)
    
    # Submit to remote cluster
    
    # Useful links:
    #   Ray Jobs SDK: https://docs.ray.io/en/latest/cluster/running-applications/job-submission/sdk.html
    #   Runtime env spec: https://docs.ray.io/en/latest/ray-core/api/runtime-env.html
    ray_client = JobSubmissionClient(ray_cluster_endpoint)
    
    entrypoint = f"python {train_script_filename} --run-name=\"xgboost-train-{timestamp}\" " + \
        f"--data-s3-path=\"{ds_path}\" --data-label-column=\"{target_column_name}\" " + \
        f"--data-s3-access-key={ds_access_key} --data-s3-secret-key={ds_secret_key} --data-s3-session-token={ds_session_token} " + \
        f"--storage-s3-path=\"{storage_path}\" " + \
        f"--storage-s3-access-key={storage_access_key} --storage-s3-secret-key={storage_secret_key} --storage-s3-session-token={storage_session_token} " + \
        f"--num-workers={num_ray_workers} --cpus-per-worker={cpus_per_ray_worker}"
    
    # Extract python package list from env
    python_packages_list = extract_packages_list_from_pyenv(ray_env_name)
        
    job_id = ray_client.submit_job(
        entrypoint=entrypoint,
        runtime_env={
            "working_dir": tmp_train_script_dir,
            "pip": python_packages_list
        }
    )
    
    # Wait until job fails or succeeds
    wait_until_rayjob_completes(ray_client, job_id)

---

## [tutorials/machine-learning/others/protect-ai-guardian/index]

# Scanning Models with Protect AI Guardian Using Python

In today’s rapidly evolving AI landscape, ensuring the security and integrity of machine learning models has become paramount. **Protect AI Guardian** is a comprehensive AI model security platform that helps developers and organizations defend against unseen threats while innovating securely. Guardian offers cutting-edge scanners that can identify deserialization attacks, architectural backdoors, and runtime threats across **35+ different model formats** , including PyTorch, TensorFlow, ONNX, and LLM-specific formats.

This tutorial will guide you through the process of scanning a model for vulnerabilities, biases, and security concerns using Protect AI Guardian’s Python SDK. By the end of this guide, you’ll understand how to:

  * Set up Guardian in your Dataiku Python environment

  * Load a model for scanning

  * Review the results of a model scan




## Prerequisites

Before starting this tutorial, ensure you have:

  * **Protect AI Guardian account** with API credentials

  * Python 3.9 or higher

  * A model ready for scanning (can be a 1st party or 3rd party model)

  * A [code environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html> "\(in Dataiku DSS v14\)") with the following packages:
        
        guardian-client
        




## Step 1: Setting up the environment and session

Let’s start by importing the necessary libraries and configuring our environment:
    
    
    from guardian_client import GuardianAPIClient
    import requests
    import json
    import time
    
    # Initialize Guardian with your credentials
    # Note: Store these securely, preferably as environment variables
    CLIENT_ID = 'your-client-id-here'
    CLIENT_SECRET = 'your-client-secret-here'
    SCANNER_ENDPOINT = 'your-guardian-endpoint-here'
    
    def get_auth_token():
        """
        Obtains an authentication token from the Guardian API.
        """
        print("🔑 Obtaining authentication token...")
        url = f"{SCANNER_ENDPOINT}/v1/auth/client_auth/token"
        payload = {
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "grant_type": "client_credentials",
        }
        headers = {"Content-Type": "application/json"}
        
        try:
            response = requests.post(url, headers=headers, json=payload)
            response.raise_for_status()  # Raises an exception for bad status codes (4xx or 5xx)
            token = response.json().get("access_token")
            if not token:
                raise ValueError("Access token not found in the response.")
            print("✅ Authentication successful.")
            return token
        except (requests.RequestException, ValueError) as e:
            print(f"❌ Failed to obtain authentication token: {e}")
            exit(1)    
    
    auth_token = get_auth_token()
    

## Step 2: Submit the model to scan

Now, we will submit the model to be scanned:
    
    
    scan_url = f"{SCANNER_ENDPOINT}/v1/scans"
    scan_headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "Authorization": f"Bearer {auth_token}"
    }
    scan_data = {
        "scope": "PRIVATE",
        "model_uri": "your-model-location"
    }
    
    try:
        print("🔄 Submitting scan request...")
        scan_response = requests.post(scan_url, headers=scan_headers, json=scan_data, timeout=30)
        scan_response.raise_for_status()
        scan_result = scan_response.json()
        print("Scan submission response:")
        print(json.dumps(scan_result, indent=4))
    
        scan_id = scan_result.get("uuid")
        if not scan_id:
            print("❌ Failed to extract scan ID from submission response.")
            exit(1)    
    
        print(f"✅ Scan submitted successfully with ID: {scan_id}")
    
    except requests.exceptions.RequestException as e:
        print(f"❌ Failed to submit scan request: {e}")
        exit(1)    
    

You can expect a response similar to this:

Figure 1 – Model scan submission response

## Step 3: Poll for status and return the scan results

After you submit the model for scanning, there will be a short delay while the results are processed. We use polling to check for and retrieve the results once they are available:
    
    
    print("⏳ Polling scan status...")
    status_url = f"{scan_url}/{scan_id}"
    final_status_response = {}
    
    while True:
        try:
            status_response = requests.get(status_url, headers=scan_headers, timeout=30)
            status_response.raise_for_status()
            status_data = status_response.json()
            status = status_data.get("aggregate_eval_outcome")
    
            if status and status != "PENDING":
                print(f"🏁 Scan completed with status: {status}")
                final_status_response = status_data
                break
    
            print("Scan Running...")
            time.sleep(5)  # Wait for 5 seconds before the next check
    
        except requests.exceptions.RequestException as e:
            print(f"❌ Failed to get status update: {e}")
            exit(1)
    
    print("\nFinal Scan Results")
    print(json.dumps(final_status_response, indent=4))
    

You can expect results in a similar format. The model we used is flagged as a FAIL because it does not use an approved file format:

Figure 2 – Model scan results

## Conclusion

Based on Guardian’s findings, you will want to implement mitigation strategies (beyond the scope of this tutorial). This tutorial demonstrated how to integrate **Protect AI Guardian** into your ML workflow to scan models for security vulnerabilities, biases, and other concerns. Guardian’s comprehensive scanning capabilities help identify threats across deserialization attacks, architectural backdoors, and runtime vulnerabilities.

---

## [tutorials/machine-learning/others/reinforcement-learning/index]

# Using Reinforcement Learning for Hyperparameter Tuning

## Introduction

In modern machine learning tasks, choosing the best hyperparameters for a model to perform well is essential. In this tutorial, we use a reinforcement learning approach to automatically tune the hyperparameters of a random forest classifier. We simulate a dataset and use a simple Q-learning algorithm to search for the best combination. This approach combines global exploration with local fine-tuning (called “exploitation”) to avoid getting stuck in a local optimum.

## Prerequisites

  * Dataiku 13.3

  * Python 3.9

  * A code environment with the following packages:
        
        numpy
        scikit-learn
        




## Importing the required packages

We first import all the libraries needed for this tutorial.
    
    
    import numpy as np
    from sklearn.datasets import make_classification
    from sklearn.model_selection import train_test_split
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.metrics import accuracy_score
    

## Preparing the dataset

We simulate a dataset for a classification task (binary by default) with 1000 samples and 20 features. The data is then split into training and validation sets.
    
    
    X, y = make_classification(n_samples=1000, n_features=20, random_state=42)
    X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=42)
    

## Defining the hyperparameter space

We define the options for the number of estimators and the maximum tree depth. These arrays represent our search space.
    
    
    n_estimators_options = np.arange(50, 201, 50)
    max_depth_options = np.arange(1, 11)
    

## Initializing the Q table and reinforcement learning parameters

We create a Q table filled with zeros. The table dimensions correspond to the number of options in each hyperparameter. We also set reinforcement learning parameters like epsilon, alpha, gamma, and the number of episodes.
    
    
    q_table = np.zeros((len(n_estimators_options), len(max_depth_options)))
    
    epsilon = 0.1   # probability of exploration (vs. exploitation)
    alpha = 0.1     # learning rate
    gamma = 0.9     # discount factor (importance of future rewards)
    episodes = 50
    

## Run reinforcement learning for hyperparameter Tuning

We run a loop over several episodes and inner steps. In each step, we select a new state by either exploring (choosing random hyperparameters) or exploiting (choosing the best combination seen so far). Then, we train a random forest classifier with the selected hyperparameters and compute its accuracy on the validation set. This accuracy serves as our reward for updating the Q table.

Note

Using both episodes & inner steps is a way to restart the learning process from different initial conditions. Like the exploitation/exploration balance, it allows for global exploration and local fine-tuning and helps avoid getting stuck in local optima.
    
    
    for episode in range(episodes):
        # Choose an initial state with random hyper parameters
        ne_idx = np.random.randint(len(n_estimators_options))
        md_idx = np.random.randint(len(max_depth_options))
    
        for step in range(10):  # Limit the number of steps per episode
            # Epsilon greedy action selection
            if np.random.rand() < epsilon:
                # Explore: choose random hyper parameters
                ne_idx_new = np.random.randint(len(n_estimators_options))
                md_idx_new = np.random.randint(len(max_depth_options))
            else:
                # Exploit: choose the hyper parameters with the highest Q value so far
                ne_idx_new, md_idx_new = np.unravel_index(np.argmax(q_table), q_table.shape)
    
            # Train model with the selected hyper parameters
            model = RandomForestClassifier(
                n_estimators = int(n_estimators_options[ne_idx_new]),
                max_depth = int(max_depth_options[md_idx_new])
            )
            model.fit(X_train, y_train)
    
            # Evaluate model on the validation set
            y_pred = model.predict(X_val)
            accuracy = accuracy_score(y_val, y_pred)
    
            # Update the Q value; here the reward is the accuracy
            q_table[ne_idx, md_idx] = q_table[ne_idx, md_idx] + alpha * (
                accuracy + gamma * np.max(q_table[ne_idx_new, md_idx_new]) - q_table[ne_idx, md_idx]
            )
    
            # Move to the next state
            ne_idx, md_idx = ne_idx_new, md_idx_new
    

## Retrieving the best hyperparameters

After the learning loop, we find the best hyperparameter combination by taking the indexes of the maximum values in our Q-table.
    
    
    best_ne_idx, best_md_idx = np.unravel_index(np.argmax(q_table), q_table.shape)
    best_n_estimators = n_estimators_options[best_ne_idx]
    best_max_depth = max_depth_options[best_md_idx]
    
    print("Best Number of Estimators:", best_n_estimators)
    print("Best Max Depth:", best_max_depth)
    

## Training the final model on the full dataset

We train the random forest classifier on the full dataset using the best hyperparameters obtained from the reinforcement learning process.
    
    
    best_model = RandomForestClassifier(
        n_estimators = int(best_n_estimators),
        max_depth = int(best_max_depth)
    )
    best_model.fit(X, y)
    

## Wrapping up

In this tutorial, we applied a reinforcement learning approach to tuning the hyperparameters of a random forest classifier. The Q learning algorithm helped us explore the hyperparameter space and gradually fine-tune the selection using the validation accuracy as the reward. This method can help avoid the common pitfalls of manual tuning and finding a balanced solution between exploration and exploitation. As a next step, you can follow [this tutorial](<../../model-import/scikit-pipeline/index.html>) to import your trained model into a Dataiku Saved Model.

Here is the complete code of this tutorial:

[`notebook.py`](<../../../../_downloads/4f3af7573d6709ecdf83f9f20817ebc6/notebook.py>)
    
    
    import numpy as np
    from sklearn.datasets import make_classification
    from sklearn.model_selection import train_test_split
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.metrics import accuracy_score
    
    X, y = make_classification(n_samples=1000, n_features=20, random_state=42)
    X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=42)
    
    n_estimators_options = np.arange(50, 201, 50)
    max_depth_options = np.arange(1, 11)
    
    q_table = np.zeros((len(n_estimators_options), len(max_depth_options)))
    
    epsilon = 0.1   # probability of exploration (vs. exploitation)
    alpha = 0.1     # learning rate
    gamma = 0.9     # discount factor (importance of future rewards)
    episodes = 50
    
    for episode in range(episodes):
        # Choose an initial state with random hyper parameters
        ne_idx = np.random.randint(len(n_estimators_options))
        md_idx = np.random.randint(len(max_depth_options))
    
        for step in range(10):  # Limit the number of steps per episode
            # Epsilon greedy action selection
            if np.random.rand() < epsilon:
                # Explore: choose random hyper parameters
                ne_idx_new = np.random.randint(len(n_estimators_options))
                md_idx_new = np.random.randint(len(max_depth_options))
            else:
                # Exploit: choose the hyper parameters with the highest Q value so far
                ne_idx_new, md_idx_new = np.unravel_index(np.argmax(q_table), q_table.shape)
    
            # Train model with the selected hyper parameters
            model = RandomForestClassifier(
                n_estimators = int(n_estimators_options[ne_idx_new]),
                max_depth = int(max_depth_options[md_idx_new])
            )
            model.fit(X_train, y_train)
    
            # Evaluate model on the validation set
            y_pred = model.predict(X_val)
            accuracy = accuracy_score(y_val, y_pred)
    
            # Update the Q value; here the reward is the accuracy
            q_table[ne_idx, md_idx] = q_table[ne_idx, md_idx] + alpha * (
                accuracy + gamma * np.max(q_table[ne_idx_new, md_idx_new]) - q_table[ne_idx, md_idx]
            )
    
            # Move to the next state
            ne_idx, md_idx = ne_idx_new, md_idx_new
    
    best_ne_idx, best_md_idx = np.unravel_index(np.argmax(q_table), q_table.shape)
    best_n_estimators = n_estimators_options[best_ne_idx]
    best_max_depth = max_depth_options[best_md_idx]
    
    print("Best Number of Estimators:", best_n_estimators)
    print("Best Max Depth:", best_max_depth)
    
    best_model = RandomForestClassifier(
        n_estimators = int(best_n_estimators),
        max_depth = int(best_max_depth)
    )
    best_model.fit(X, y)

---

## [tutorials/machine-learning/others/transfer-learning/index]

# Transfer Learning Techniques

Transfer learning encompasses techniques that enable data scientists and engineers to build high-performing deep learning models without the massive computational and data labeling costs typically required when training from scratch.

This section examines two distinct subdomains of transfer learning, depending on the availability of labeled data and the degree of similarity between the source and target tasks.

## Transductive transfer learning

[This tutorial](<transductive-learning.html>) focuses on scenarios where labeled target data is available, the source and target tasks are the same, but the domain changes. For example, a sentiment analysis model trained on survey response data may need to be adapted to understand the nuances of product reviews.

## Unsupervised transfer learning

[This tutorial](<unsupervised-transfer-learning.html>) addresses the challenge of data scarcity. Unsupervised transfer learning techniques are helpful for adapting a model to a new domain when you have a target dataset, but no labels. For example, a model trained to detect anomalies in satellite images may need to be adapted to identify instances of illegal deforestation; however, the target dataset is large enough that hand-labeling the data is a significant challenge.

---

## [tutorials/machine-learning/others/transfer-learning/transductive-learning]

# Transductive Transfer Learning

Deep learning models are high-impact assets for extracting actionable intelligence and maximizing the value of organizational data; however, training these models can be time-consuming and expensive. This challenge is addressed by transfer learning, the general approach where a model trained on one task is “taught” to perform a second task. By repurposing an existing model and adjusting it to apply to a new domain or new task, users can accelerate time to value and reduce comparative cost.

Transductive transfer learning is a subdomain of transfer learning that applies to scenarios where the source and target tasks remain the same, but the domains differ. While the objective of the model is identical pre- and post-transfer, the model must learn to “re-map” its internal understanding of structure to fit the new domain’s patterns but maintain the intuition derived from the source data.

Fine-tuning is a popular transfer learning technique that is similar to transductive transfer learning. In fine-tuning, some or most of the layers within a pre-trained model are retrained on a new dataset in order to drive further performance gains on the source task. Generally, fine-tuning is best used when working with large, labeled target datasets. In contrast, transductive transfer learning is most useful when working with smaller target datasets and to lower overall computational costs.

This tutorial will be focused on implementing transductive transfer learning techniques, specifically adapter tuning. The starter model for this segment of the tutorial is distilBERT fine-tuned for sentiment analysis on financial news headlines. Our objective is to extend this model to classify reviews of fashion items on Amazon as positive, negative, or neutral. One of the challenges of domain adaptation for fine-tuned models is preserving the insights derived during the first fine-tuning exercise while adding pattern recognition for the new domain. Parameter-efficient fine-tuning (PEFT) is a fine-tuning method that updates a small subset of model parameters to fit new data without re-training the whole model. We will explore applications of PEFT within the context of this example.

## Prerequisites

  * Dataiku >= 12.0

  * Python >= 3.11

  * A code environment with the following packages:
        
        transformers
        tokenizers
        datasets
        tensorflow
        torch
        pillow
        peft
        mlflow==2.22.1
        tf-keras
        

  * Expected initial state:
    
    * Base familiarity with neural networks and transformers

    * A pre-trained sentiment analysis classifier




## Transductive Transfer Learning for Sentiment Analysis Across Domains

### Defining a wrapper class for compatibility with MLFlow experiments

To store the fine-tuned distilBERT model as an MLFlow model, we need to write a wrapper class that maps the HuggingFace model’s functionality to MLFlow’s generalized pyfunc deployment format. The `pyfunc` model expects a simple Python class with a defined predict method that accepts standard input (such as a Pandas DataFrame) and returns standard output (such as a list or array). The wrapper handles the necessary preprocessing (tokenization, converting text to PyTorch tensors) and post-processing (converting logits back to a final prediction label) that the raw BERT model requires, thus bridging the gap between the universal MLFlow API and the specialized PyTorch/HuggingFace library workflow.

This class can be defined within the notebook or code recipe where the model is fine-tuned, or it can be stored as a Python file in the project library and imported as needed. We have chosen to implement this class in a project library file, named `bert_model_wrapper.py`. Go to the **Code Menu** and select the **Libraries** option. In the **Library Editor** , under the `python` folder, create a file named: `bert_model_wrapper.py`. Then copy/paste the code below, which is the wrapper explained before.

Code 1 – Wrapper class
    
    
    import mlflow
    import torch
    import pandas as pd
    
    class BertModelWrapper(mlflow.pyfunc.PythonModel):
        def __init__(self, model, tokenizer):
            self.model = model
            self.tokenizer = tokenizer
    
        def load_context(self, context):
            pass
    
        def preprocess(self, input_row):
            tokens = self.tokenizer(input_row['text'], return_tensors='pt', truncation=True, padding=True)
            return tokens
    
        def predict(self, context, model_input: pd.DataFrame):
            text_list = model_input['text'].tolist()
            tokens = self.tokenizer(text_list, return_tensors='pt', truncation=True, padding=True)
    
            with torch.no_grad():
                self.model.eval()
                outputs = self.model(**tokens)
                logits = outputs.logits
                predictions = torch.argmax(logits, dim=1).cpu().numpy()
    
            return predictions.tolist()
    

### Creating the prerequisite objects

Once you have split the `amazon_fashion_reviews` dataset into three parts (`train`, `validation` and `test`), select the `train` and `validation` datasets, then select the managed folder that contains the pre-trained model. Create a **Code Recipe** (Python), which will output two objects: a managed folder (for storing the new artifact), and a saved model to store the result of the transfer learning.

Figure 1: Code recipe creation.

The subsequent steps in this tutorial all describe code to include in the code recipe as defined in the flow. Alternatively, this code can be used for model development solely in a Jupyter notebook.

### Importing the required packages

The first thing you need to do is to import all necessary packages, as shown in the code below:

Code 2 – Import the needed packages
    
    
    # For interacting with the Dataiku API + loading data
    import dataiku
    from dataiku import pandasutils as pdu
    import pandas as pd
    import numpy as np
    # For fine-tuning
    from datasets import Dataset
    from transformers import AutoTokenizer, TrainingArguments, Trainer
    import torch
    import numpy as np
    import pandas as pd
    import logging
    from dataikuapi.dss.ml import DSSPredictionMLTaskSettings
    from sklearn.metrics import accuracy_score
    from mlflow.models import infer_signature
    from peft import LoraConfig, get_peft_model, TaskType
    import pickle
    from sklearn.metrics import accuracy_score
    # Import custom wrapper class and MLFlow for integrating model into flow
    from bert_model_wrapper import BertModelWrapper
    import mlflow
    

### Setting the variables

We start by instantiating a connection with the Dataiku project and defining the configuration details for experiment tracking.

Code 3 – Setting the variables
    
    
    # Instantiate the connection with the project
    client = dataiku.api_client()
    project = client.get_default_project()
    
    # Set model and MLFlow tracking variables
    MLFLOW_CODE_ENV_NAME = "devadv-transfer"
    XP_TRACKING_FOLDER_ID = "oB4iw9q8"
    sm_name = "transfer"
    folder = project.get_managed_folder(odb_id=XP_TRACKING_FOLDER_ID)
    mlflow_handle = project.setup_mlflow(managed_folder=folder)
    mlflow_extension = mlflow_handle.project.get_mlflow_extension()
    

### Loading and preparing the Datasets

The code reads the raw training and validation datasets from Dataiku, converts them into the HuggingFace dataset format, and initializes the tokenizer. The `preprocess_function` applies tokenization, truncation, and padding, transforming the raw text into numerical inputs suitable for the DistilBERT model.

Code 4 – Preparing the data
    
    
    # Read recipe inputs
    reviews_train = dataiku.Dataset("fashion_reviews_train")
    reviews_train_df = reviews_train.get_dataframe()
    reviews_validation = dataiku.Dataset("fashion_reviews_validation")
    reviews_validation_df = reviews_validation.get_dataframe()
    
    # Convert dataframes to HuggingFace datasets
    reviews_train_ds = Dataset.from_pandas(reviews_train_df)
    reviews_validation_ds = Dataset.from_pandas(reviews_validation_df)
    
    # Prepare text data
    tokenizer = AutoTokenizer.from_pretrained("distilbert-base-uncased")
    
    
    def preprocess_function(examples):
        return tokenizer(
            examples["text"],
            truncation=True,
            padding=True
        )
    
    
    tokenized_train = reviews_train_ds.map(
        preprocess_function,
        batched=True,
        batch_size=32
    )
    tokenized_validation = reviews_validation_ds.map(
        preprocess_function,
        batched=True,
        batch_size=32
    )
    

### Loading the pre-trained model

The artifacts for the source model were stored in the managed folder `distilbert_artifacts`, and the model itself is stored as a pickle file that can be loaded.

Code 5 – Loading the pre-trained model
    
    
    with dataiku.Folder("distilbert_artifacts").get_download_stream('best_bert_model/python_model.pkl') as f:
        finbert = pickle.load(f)
    

### Defining the assessment function

The code below defines the assessment function for the model which calculates the classification accuracy during training and evaluation.

Code 6 – Assessment function
    
    
    # Assessment function
    def compute_metrics(eval_pred):
        predictions, labels = eval_pred
        predictions = np.argmax(predictions, axis=1)
        accuracy = accuracy_score(labels, predictions)
        return {'accuracy': accuracy}
    

### Configuring LoRA and fine-tuning the source model

PEFT (Parameter-Efficient Fine-Tuning) is a strategy that lets you adapt models by only updating a tiny fraction of their parameters, keeping the core of the model “frozen.” LoRA (Low-Rank Adaptation) is the most popular way to do this; it works by adding two small, low-rank matrices to each layer that act like a “plugin” to capture new information without changing the original weights.

Inside an MLFlow run, the code configures the LoRA parameters, which are central to the PEFT approach. `get_peft_model` wraps the existing model, making only the small adapter matrices trainable. The `TrainingArguments` and `Trainer` classes are then instantiated for the fine-tuning process.

Once the model is trained, the code saves the best-performing model weights, generates an MLFlow signature for input/output consistency, and logs the model using the custom `BertModelWrapper` to ensure compatibility with MLFlow. Evaluation metrics and run metadata are stored in MLFlow.

Code 7 – Fine-tuning
    
    
    # Begin fine-tuning the financial news sentiment classifier on product review data
    mlflow_experiment = mlflow.set_experiment(experiment_name="finetuning_reviews")
    
    with mlflow.start_run() as run:
        lora_config = LoraConfig(
            r=8,
            lora_alpha=16,
            target_modules=["q_lin", "k_lin", "v_lin", "out_lin"],
            lora_dropout=0.05,
            bias="none",
            task_type=TaskType.SEQ_CLS
        )
        peft_model = get_peft_model(finbert.model, lora_config)
    
        # fine-tuning
        training_args = TrainingArguments(
            output_dir="finbert_adapted_to_reviews",
            learning_rate=0.00005,
            num_train_epochs=1,
            weight_decay=0.01,
            per_device_train_batch_size=16,
            per_device_eval_batch_size=64,
        )
        trainer = Trainer(
            model=peft_model,
            args=training_args,
            train_dataset=tokenized_train,
            eval_dataset=tokenized_validation,
            tokenizer=tokenizer,
            compute_metrics=compute_metrics,
        )
        trainer.train()
    
        # save best performing model
        trainer.save_model()
    
        # set signature
        sample_input = pd.DataFrame({'text': ['Shirt is cheap', 'OK pair of pants', 'Wonderful shawl']})
        sample_prediction = [0, 1, 2]
        signature = infer_signature(sample_input, sample_prediction)
    
        mlflow.pyfunc.log_model(
            artifact_path="best_bert_model",
            python_model=BertModelWrapper(trainer.model, tokenizer),
            signature=signature,
        )
    
        # store evaluation
        eval_results = trainer.evaluate()
        mlflow.log_metrics({f"final_{k}": v for k, v in eval_results.items()})
    
        # store details
        mlflow_extension.set_run_inference_info(
            run_id=run.info.run_id,
            prediction_type=DSSPredictionMLTaskSettings.PredictionTypes.MULTICLASS,
            code_env_name=MLFLOW_CODE_ENV_NAME,
            classes=[0, 1, 2]
        )
        EXPERIMENT_ID = run.info.experiment_id
        RUN_ID = run.info.run_id
    

### Managing version and deploying the model

The final segment handles the MLOps deployment process within Dataiku. It identifies or creates a Saved Model object, determines the next version number, imports the MLflow artifacts into that version, and sets the necessary metadata for deployment and evaluation.

Code 8 – Registering the model
    
    
    # Save model as MLFlow model
    sm_id = None
    for sm_info in project.list_saved_models():
        if sm_name == sm_info["name"]:
            sm_id = sm_info["id"]
            print(f"Found SavedModel {sm_name} with id {sm_id}")
            break
    
    if sm_id:
        sm = project.get_saved_model(sm_id)
    else:
        # Create the Saved Model using the MLflow pyfunc type
        sm = project.create_mlflow_pyfunc_model(
            name=sm_name,
            prediction_type=DSSPredictionMLTaskSettings.PredictionTypes.MULTICLASS
        )
        sm_id = sm.id
        print(f"SavedModel not found, created new one with id {sm_id}")
    
    version_nums = [int(x['id'][1:]) for x in sm.list_versions() if x['id'].startswith('v')]
    version_id = "v" + str(max(version_nums) + 1 if version_nums else 1)
    print(f"Importing as new version: {version_id}")
    
    # Store model training artifacts in managed folder
    MLFLOW_MODEL_PATH = f"{EXPERIMENT_ID}/{RUN_ID}/artifacts/best_bert_model/"  # Use the artifact_path from your log_model call
    
    sm_version = sm.import_mlflow_version_from_managed_folder(
        version_id=version_id,
        managed_folder=folder,
        path=MLFLOW_MODEL_PATH,
        code_env_name=MLFLOW_CODE_ENV_NAME
    )
    
    # Set metadata
    sm_version.set_core_metadata(
        target_column_name="label",
        class_labels=[0, 1, 2]
    )
    
    # Evaluate model on validation dataset, store results in MLFlow object
    sm_version.evaluate(reviews_validation)
    

### Assessing model performance on an evaluation dataset

Using the **Predict** recipe, we can assess the performance of the source model and the domain-adapted model on the evaluation dataset of Amazon fashion product reviews.

From the prediction datasets, we can calculate and compare model accuracy. In this specific example, the target model is twice as accurate as the source model on the evaluation dataset.

## Wrapping Up

In this tutorial, we learned how to perform transductive transfer learning to adapt an existing model to a new domain. This sentiment classifier adaptation tutorial demonstrated a transductive transfer learning application to preserve the expensive, pre-trained linguistic knowledge of the original model while still extending the model to recognize product-review specific grammar and tone.

Beyond the code, we’ve also seen how tools like LoRA and PEFT allow you to experiment and scale quickly by focusing on just a small fraction of the model’s parameters.

To learn more about transfer learning, we recommend [this literature review](<https://www.sciencedirect.com/science/article/pii/S0957417423033092>) and [this textbook chapter](<https://ftp.cs.wisc.edu/machine-learning/shavlik-group/torrey.handbook09.pdf>).

Here is the complete code of this tutorial:

[`Complete code`](<../../../../_downloads/0ade7a91ee12e8a50ecdcf5622efcb47/transductive.py>)
    
    
    # For interacting with the Dataiku API + loading data
    import dataiku
    from dataiku import pandasutils as pdu
    import pandas as pd
    import numpy as np
    # For fine-tuning
    from datasets import Dataset
    from transformers import AutoTokenizer, TrainingArguments, Trainer
    import torch
    import numpy as np
    import pandas as pd
    import logging
    from dataikuapi.dss.ml import DSSPredictionMLTaskSettings
    from sklearn.metrics import accuracy_score
    from mlflow.models import infer_signature
    from peft import LoraConfig, get_peft_model, TaskType
    import pickle
    from sklearn.metrics import accuracy_score
    # Import custom wrapper class and MLFlow for integrating model into flow
    from bert_model_wrapper import BertModelWrapper
    import mlflow
    
    # Instantiate the connection with the project
    client = dataiku.api_client()
    project = client.get_default_project()
    
    # Set model and MLFlow tracking variables
    MLFLOW_CODE_ENV_NAME = "devadv-transfer"
    XP_TRACKING_FOLDER_ID = "oB4iw9q8"
    sm_name = "transfer"
    folder = project.get_managed_folder(odb_id=XP_TRACKING_FOLDER_ID)
    mlflow_handle = project.setup_mlflow(managed_folder=folder)
    mlflow_extension = mlflow_handle.project.get_mlflow_extension()
    
    # Read recipe inputs
    reviews_train = dataiku.Dataset("fashion_reviews_train")
    reviews_train_df = reviews_train.get_dataframe()
    reviews_validation = dataiku.Dataset("fashion_reviews_validation")
    reviews_validation_df = reviews_validation.get_dataframe()
    
    # Convert dataframes to HuggingFace datasets
    reviews_train_ds = Dataset.from_pandas(reviews_train_df)
    reviews_validation_ds = Dataset.from_pandas(reviews_validation_df)
    
    # Prepare text data
    tokenizer = AutoTokenizer.from_pretrained("distilbert-base-uncased")
    
    
    def preprocess_function(examples):
        return tokenizer(
            examples["text"],
            truncation=True,
            padding=True
        )
    
    
    tokenized_train = reviews_train_ds.map(
        preprocess_function,
        batched=True,
        batch_size=32
    )
    tokenized_validation = reviews_validation_ds.map(
        preprocess_function,
        batched=True,
        batch_size=32
    )
    with dataiku.Folder("distilbert_artifacts").get_download_stream('best_bert_model/python_model.pkl') as f:
        finbert = pickle.load(f)
    
    
    # Assessment function
    def compute_metrics(eval_pred):
        predictions, labels = eval_pred
        predictions = np.argmax(predictions, axis=1)
        accuracy = accuracy_score(labels, predictions)
        return {'accuracy': accuracy}
    
    
    # Begin fine-tuning the financial news sentiment classifier on product review data
    mlflow_experiment = mlflow.set_experiment(experiment_name="finetuning_reviews")
    
    with mlflow.start_run() as run:
        lora_config = LoraConfig(
            r=8,
            lora_alpha=16,
            target_modules=["q_lin", "k_lin", "v_lin", "out_lin"],
            lora_dropout=0.05,
            bias="none",
            task_type=TaskType.SEQ_CLS
        )
        peft_model = get_peft_model(finbert.model, lora_config)
    
        # fine-tuning
        training_args = TrainingArguments(
            output_dir="finbert_adapted_to_reviews",
            learning_rate=0.00005,
            num_train_epochs=1,
            weight_decay=0.01,
            per_device_train_batch_size=16,
            per_device_eval_batch_size=64,
        )
        trainer = Trainer(
            model=peft_model,
            args=training_args,
            train_dataset=tokenized_train,
            eval_dataset=tokenized_validation,
            tokenizer=tokenizer,
            compute_metrics=compute_metrics,
        )
        trainer.train()
    
        # save best performing model
        trainer.save_model()
    
        # set signature
        sample_input = pd.DataFrame({'text': ['Shirt is cheap', 'OK pair of pants', 'Wonderful shawl']})
        sample_prediction = [0, 1, 2]
        signature = infer_signature(sample_input, sample_prediction)
    
        mlflow.pyfunc.log_model(
            artifact_path="best_bert_model",
            python_model=BertModelWrapper(trainer.model, tokenizer),
            signature=signature,
        )
    
        # store evaluation
        eval_results = trainer.evaluate()
        mlflow.log_metrics({f"final_{k}": v for k, v in eval_results.items()})
    
        # store details
        mlflow_extension.set_run_inference_info(
            run_id=run.info.run_id,
            prediction_type=DSSPredictionMLTaskSettings.PredictionTypes.MULTICLASS,
            code_env_name=MLFLOW_CODE_ENV_NAME,
            classes=[0, 1, 2]
        )
        EXPERIMENT_ID = run.info.experiment_id
        RUN_ID = run.info.run_id
    
    # Save model as MLFlow model
    sm_id = None
    for sm_info in project.list_saved_models():
        if sm_name == sm_info["name"]:
            sm_id = sm_info["id"]
            print(f"Found SavedModel {sm_name} with id {sm_id}")
            break
    
    if sm_id:
        sm = project.get_saved_model(sm_id)
    else:
        # Create the Saved Model using the MLflow pyfunc type
        sm = project.create_mlflow_pyfunc_model(
            name=sm_name,
            prediction_type=DSSPredictionMLTaskSettings.PredictionTypes.MULTICLASS
        )
        sm_id = sm.id
        print(f"SavedModel not found, created new one with id {sm_id}")
    
    version_nums = [int(x['id'][1:]) for x in sm.list_versions() if x['id'].startswith('v')]
    version_id = "v" + str(max(version_nums) + 1 if version_nums else 1)
    print(f"Importing as new version: {version_id}")
    
    # Store model training artifacts in managed folder
    MLFLOW_MODEL_PATH = f"{EXPERIMENT_ID}/{RUN_ID}/artifacts/best_bert_model/"  # Use the artifact_path from your log_model call
    
    sm_version = sm.import_mlflow_version_from_managed_folder(
        version_id=version_id,
        managed_folder=folder,
        path=MLFLOW_MODEL_PATH,
        code_env_name=MLFLOW_CODE_ENV_NAME
    )
    
    # Set metadata
    sm_version.set_core_metadata(
        target_column_name="label",
        class_labels=[0, 1, 2]
    )
    
    # Evaluate model on validation dataset, store results in MLFlow object
    sm_version.evaluate(reviews_validation)

---

## [tutorials/machine-learning/others/transfer-learning/unsupervised-transfer-learning]

# Unsupervised Transfer Learning

Deep learning models are powerful tools for uncovering insights in data and driving value, however, the cost of data labeling and computation often creates a barrier to entry. Enter: transfer learning. At its core, transfer learning is the process of taking the “knowledge” (features, patterns, or weights) a model has acquired from one task and applying it to a different but related task. By leveraging a pre-trained foundation, users can significantly reduce the time and resources required to reach high performance.

For unsupervised transfer learning, instead of relying on labeled datasets to guide the adaptation, the model extracts underlying structures from a source domain to interpret unlabeled data in a new domain. This allows organizations to adapt a model to a new, target task, even when high-quality labels are scarce or non-existent.

This tutorial will be focused on implementing unsupervised transfer learning techniques. The starter model for this exercise is a convolutional autoencoder (CAE) trained on black and white, handwritten zeroes from the MNIST dataset to identify any non-zero handwritten digits as anomalous. In this example, we will walk through the steps required to teach the starter model how to identify colorful, non-zero handwritten digits from the MNIST-M dataset as anomalous. This exercise of a model learning patterns from an unlabeled dataset is known as self-supervised learning (SSL).

## Prerequisites

  * Dataiku >= 12.0

  * Python >= 3.11

  * A code environment with the following packages:
        
        transformers
        tokenizers
        datasets
        tensorflow
        torch
        pillow
        peft
        mlflow==2.22.1
        tf-keras
        

  * Expected initial state:
    
    * Base familiarity with neural networks and transformers

    * A pre-trained image anomaly detection model




## Unsupervised Transfer Learning for Image Anomaly Detection

### Importing the required packages

The first thing you need to do is to import all necessary packages, as shown in the code below:

Code 1 – Import the needed packages
    
    
    # For interacting with the Dataiku API + loading data
    import dataiku
    from dataiku import pandasutils as pdu
    import pandas as pd
    import numpy as np
    # For training a convolutional autoencoder
    import tensorflow as tf
    from tensorflow.keras.layers import Input, Conv2D, MaxPooling2D, UpSampling2D, Conv2DTranspose, Reshape, Flatten, Dense
    from tensorflow.keras.models import Model, model_from_json
    from tensorflow.keras import backend as K
    # For converting an image into a numpy array
    from PIL import Image
    import io
    import tempfile
    

### Loading the saved model and target transfer dataset

The model loaded for use in this tutorial is a convolutional autoencoder (CAE). CAEs are a type of unsupervised neural network often used for anomalous image detection. These neural networks compress images into a lower dimensional representation via convolutional layers (the encoder), then reconstruct the image from the lower dimensional representation (the decoder). For image anomaly detection, the degree of error is calculated by comparing the input image to its reconstruction, and if the error is above a defined threshold, the input image is considered anomalous.

The architecture and weights of the source model used in this tutorial were stored in a managed folder in the flow. The original model can be reconstructed from these two artifacts.

This tutorial can be executed within a jupyter notebook or as a code recipe in Dataiku. If a code recipe is used, the folder containing the source model as well as the target dataset should be specified as inputs, and the output specified as the folder for the output model.

Note

If the starter model is not in memory, make sure to load the weights from that starter model and load them into the encoder.

Code 2 – Loading the saved model
    
    
    # Load model stored in Dataiku
    folder = dataiku.Folder('1bXPjNsj')
    
    with folder.get_download_stream('/base_model_artifacts/model_architecture.json') as f:
        json_config = f.read().decode('utf-8')
    
    autoencoder = model_from_json(json_config)
    
    with folder.get_download_stream('/base_model_artifacts/cae_mnist_base_model.weights.h5') as f_stream:
        with tempfile.NamedTemporaryFile(suffix='.h5', delete=False) as tmp_file:
            tmp_file.write(f_stream.read())
            temp_file_path = tmp_file.name
    
    autoencoder.load_weights(temp_file_path, by_name=True)
    
    # Load MNIST-M data from HuggingFace
    splits_mnist_m = {'train': 'data/train-00000-of-00001-571b6b1e2c195186.parquet',
                      'test': 'data/test-00000-of-00001-ba3ad971b105ff65.parquet'}
    mnist_m_train = pd.read_parquet("hf://datasets/Mike0307/MNIST-M/" + splits_mnist_m["train"])
    mnistm_test = pd.read_parquet("hf://datasets/Mike0307/MNIST-M/" + splits_mnist_m["test"])
    

### Preparing target dataset for transfer learning

The MNIST-M dataset consists of 60,000 colorful versions of the original MNIST dataset. The first step is to convert the images into numpy representations the same size as the original MNIST images used to train the starter model. Next, we will filter for just the zero images to be our transfer target dataset and prepare a dataset of mixed digits for evaluation in which the majority class is 0 and the anomalous class is all other digits.

Code 3 – Preparing the targeted dataset
    
    
    def bytes_to_numpy(img_bytes):
        """Converts a PNG string back to a normalized (28, 28, x) numpy array."""
        try:
            # Open image from bytes using PIL
            img = Image.open(io.BytesIO(img_bytes))
    
            # Convert to numpy array and normalize
            img_np_array = np.array(img, dtype=np.float32) / 255.0
    
            if (img_np_array.shape[0] == 28) and (img_np_array.shape[1] == 28):
                return img_np_array
            else:
                # Crop image
                cropped_np_array = img_np_array[2:30, 2:30, :]
                return cropped_np_array
        except Exception as e:
            print(f"Error decoding base64 image: {e}")
            return None
    
    
    # Prepare transfer target training dataset
    mnistm_train_filtered = mnist_m_train[mnist_m_train['label'] == 0]
    mnistm_train_filtered['image_np'] = mnistm_train_filtered['image'].apply(
        lambda x: bytes_to_numpy(x['bytes'])
    )
    
    img_np_list = [x for x in mnistm_train_filtered['image_np'] if x is not None]
    x_train_mnistm = np.array(img_np_list)
    y_train_mnistm = np.array(mnistm_train_filtered['label'])
    
    # Prepare evaluation dataset
    mnistm_test_filtered = pd.concat([
        mnistm_test[mnistm_test['label'] == 0],
        mnistm_test[mnistm_test['label'] != 0].sample(110, random_state=42)
    ])
    mnistm_test_filtered['image_np'] = mnistm_test_filtered['image'].apply(
        lambda x: bytes_to_numpy(x['bytes'])
    )
    mnistm_test_img_list = [x for x in mnistm_test_filtered['image_np'] if x is not None]
    x_test_mnistm = np.array(mnistm_test_img_list)
    y_test_mnistm = np.array(mnistm_test_filtered['label'])
    

### Updating input layer to reflect color channel

Since the starter model was trained on black and white images, the input layer currently expects image representations with the dimensions `28 x 28 x 1`, where the values `28 x 28` indicate the pixel size of the image and `1` refers to the color channel. Grayscale images have only one channel for pigment values, because all of the pixels are a shade of gray between black and white. On the other hand, color images require three channels, one for each of the primary colors red, green, and blue.

For our updated model, we will replace the original input layer to reflect the updated input dimensions, and initialize a new convolutional layer to be the new input adapter.

Code 4 – Updating input layer
    
    
    # Update input layer
    TRANSFER_SHAPE = (28, 28, 3)
    transfer_input = Input(shape=TRANSFER_SHAPE, name='transfer_input_28x28_3ch')
    # Input adapter layer
    x = Conv2D(32, (3, 3), activation='relu', padding='same', name='transfer_conv1')(transfer_input)
    

### Loading original encoder and decoder layers

In transfer learning, only the final layer(s) of a model are adjusted according to new data, so we will re-use the original encoder and bottleneck layers from the starter model and mark them as not trainable.

Code 5 - Loading the encoders layer
    
    
    original_encoder = autoencoder.get_layer('encoder')
    # Freeze intermediate layers
    # Layer 1: pool1
    x = original_encoder.get_layer('pool1')(x)
    original_encoder.get_layer('pool1').trainable = False
    
    # Layer 2: conv2
    x = original_encoder.get_layer('conv2')(x)
    original_encoder.get_layer('conv2').trainable = False
    
    # Layer 3: pool2
    x = original_encoder.get_layer('pool2')(x)
    original_encoder.get_layer('pool2').trainable = False
    
    # Bottleneck Transition Layers (Flatten and Dense)
    flat = original_encoder.get_layer('flatten')(x)
    original_encoder.get_layer('flatten').trainable = False
    
    latent = original_encoder.get_layer('latent_bottleneck')(flat)
    original_encoder.get_layer('latent_bottleneck').trainable = False
    
    # Consolidated transfer encoder
    transfer_encoder = Model(transfer_input, latent, name='transfer_encoder')
    # New decoder input layer
    transfer_latent_input = Input(shape=(32,), name='transfer_latent_input')
    

We will similarly load the original decoder layers but expect the weights in these layers to be adjusted during the transfer learning process.

Code 6 – Loading the decoders layer
    
    
    original_decoder = autoencoder.get_layer('decoder')
    # Keep original decoder initial layers
    x = original_decoder.get_layer('decoder_dense_start')(transfer_latent_input)
    x = original_decoder.get_layer('decoder_reshape')(x)
    # Add original decoder layers, these layers will have weights adjusted during transfer learning process
    x = original_decoder.get_layer('deconv1')(x)
    x = original_decoder.get_layer('up_sampling2d')(x)
    x = original_decoder.get_layer('deconv2')(x)
    x = original_decoder.get_layer('up_sampling2d_1')(x)
    # New final output layer to reflect 3 channels, trainable
    transfer_decoded = Conv2D(3, (3, 3), activation='sigmoid', padding='same', name='output_28x28_3ch_final')(x)
    transfer_decoder = Model(transfer_latent_input, transfer_decoded, name='transfer_decoder')
    

### Transfer learning

Consolidate all the layers into an updated CAE model, and train the model on the target dataset.

Code 7 – Transfer learning
    
    
    # Consolidate transfer input, encoder, and decoder layers
    transfer_autoencoder = Model(transfer_input, transfer_decoder(transfer_encoder(transfer_input)),
                                 name='CAE_TRANSFER_MNISTM')
    # Fit model to target MNIST-M data
    transfer_autoencoder.compile(optimizer='adam', loss='mse')
    transfer_autoencoder.fit(
        x_train_mnistm,
        x_train_mnistm,
        epochs=5,
        batch_size=32,
        shuffle=True,
        validation_split=0.1,
        verbose=0
    )
    

### Performance assessment

First, determine the threshold for anomalousness by calculating the 95th percentile of the mean squared error (MSE) of the target train data images minus their reconstructions.

Code 8 – Determining the threshold
    
    
    reconstructions_mnistm = transfer_autoencoder.predict(x_train_mnistm, verbose=0)
    mse_mnistm = np.mean(np.power(x_train_mnistm - reconstructions_mnistm, 2), axis=(1, 2, 3))
    anomaly_threshold_transfer_95th = np.percentile(mse_mnistm, 95)
    # Threshold = 0.058
    

Next, make predictions for the `normal` evaluation data (zeroes) and the `abnormal` evaluation data (non-zeroes). Measure the percentage of images in each category that are considered anomalous.

Code 9 – Making predictions
    
    
    mnistm_normal_test_errors = np.mean(np.power(
        x_test_mnistm[y_test_mnistm == 0] - transfer_autoencoder.predict(x_test_mnistm[y_test_mnistm == 0], verbose=0), 2),
        axis=(1, 2, 3))
    
    mnistm_anomaly_test_errors = np.mean(np.power(
        x_test_mnistm[y_test_mnistm != 0] - transfer_autoencoder.predict(x_test_mnistm[y_test_mnistm != 0], verbose=0), 2),
        axis=(1, 2, 3))
    
    mnistm_normal_test_errors[mnistm_normal_test_errors <= anomaly_threshold_transfer_95th].shape[0] / \
    mnistm_normal_test_errors.shape[0]
    
    mnistm_anomaly_test_errors[mnistm_anomaly_test_errors <= anomaly_threshold_transfer_95th].shape[0] / \
    mnistm_anomaly_test_errors.shape[0]
    

Results:

  * 84.5% of the colorful, abnormal evaluation images were correctly identified as abnormal

  * 93.5% of the colorful, normal evaluation images were correctly identified as normal




### Performance comparison to source model on MNIST-M images

The architecture of the source model makes direct comparison impossible without adjustments to the model itself. However, by converting the evaluation dataset to grayscale, we can still approximate the impact of non uniform background color and texture has on the model’s performance.

Code 10 – Performance comparison
    
    
    # Convert evaluation dataset images to grayscale
    grayscale_weights = np.array([0.2989, 0.5870, 0.1140], dtype=np.float32)
    grayscale_x_test_mnistm = np.dot(x_test_mnistm, grayscale_weights)
    grayscale_x_test_mnistm = np.expand_dims(grayscale_x_test_mnistm, axis=-1)
    
    # Load anomalousness threshold from original trained model
    anomaly_threshold_transfer_95th = 0.01845815759152173
    
    # Measure original CAE accuracy
    baseline_mnistm_normal_test_errors = np.mean(np.power(
        grayscale_x_test_mnistm[y_test_mnistm == 0] - autoencoder.predict(grayscale_x_test_mnistm[y_test_mnistm == 0],
                                                                          verbose=0), 2), axis=(1, 2, 3))
    
    baseline_mnistm_anomaly_test_errors = np.mean(np.power(
        grayscale_x_test_mnistm[y_test_mnistm != 0] - autoencoder.predict(grayscale_x_test_mnistm[y_test_mnistm != 0],
                                                                          verbose=0), 2), axis=(1, 2, 3))
    
    baseline_mnistm_normal_test_errors[baseline_mnistm_normal_test_errors <= anomaly_threshold_transfer_95th].shape[0] / \
    baseline_mnistm_normal_test_errors.shape[0]
    
    baseline_mnistm_anomaly_test_errors[baseline_mnistm_anomaly_test_errors > anomaly_threshold_transfer_95th].shape[0] / \
    baseline_mnistm_anomaly_test_errors.shape[0]
    

The original CAE over-predicted the anomaly rate by a factor of 7, despite abnormal images comprising ~10% of the evaluation set. The CAE fails because its convolutional layers were trained on images with a uniformly black background, whereas the grayscale MNIST-M images have non-uniform texture and noise in their background. This differential in pre and post transfer learning model performance underscores the importance of transfer learning techniques in adapting existing models to new domains.

## Wrapping Up

In this tutorial, we learned how to perform unsupervised transfer learning to adapt an existing model to a new domain. We now have a better understanding of the benefits of unsupervised transfer learning, how to adjust layers within a neural network to new input types, as well as which layers to tune. The image anomaly detection exercise showed that the original CAE was highly transferable, and by only training some of the model’s parameters, we were able to adapt the existing model to a totally new domain without any labeled data.

To learn more about transfer learning, we recommend [this literature review](<https://www.sciencedirect.com/science/article/pii/S0957417423033092>) and [this textbook chapter](<https://ftp.cs.wisc.edu/machine-learning/shavlik-group/torrey.handbook09.pdf>).

Here is the complete code of this tutorial:

[`Complete code`](<../../../../_downloads/d292509ecc6f0759ecdd22d3d39eaff1/unsupervised.py>)
    
    
    # For interacting with the Dataiku API + loading data
    import dataiku
    from dataiku import pandasutils as pdu
    import pandas as pd
    import numpy as np
    # For training a convolutional autoencoder
    import tensorflow as tf
    from tensorflow.keras.layers import Input, Conv2D, MaxPooling2D, UpSampling2D, Conv2DTranspose, Reshape, Flatten, Dense
    from tensorflow.keras.models import Model, model_from_json
    from tensorflow.keras import backend as K
    # For converting an image into a numpy array
    from PIL import Image
    import io
    import tempfile
    
    # Load model stored in Dataiku
    folder = dataiku.Folder('1bXPjNsj')
    
    with folder.get_download_stream('/base_model_artifacts/model_architecture.json') as f:
        json_config = f.read().decode('utf-8')
    
    autoencoder = model_from_json(json_config)
    
    with folder.get_download_stream('/base_model_artifacts/cae_mnist_base_model.weights.h5') as f_stream:
        with tempfile.NamedTemporaryFile(suffix='.h5', delete=False) as tmp_file:
            tmp_file.write(f_stream.read())
            temp_file_path = tmp_file.name
    
    autoencoder.load_weights(temp_file_path, by_name=True)
    
    # Load MNIST-M data from HuggingFace
    splits_mnist_m = {'train': 'data/train-00000-of-00001-571b6b1e2c195186.parquet',
                      'test': 'data/test-00000-of-00001-ba3ad971b105ff65.parquet'}
    mnist_m_train = pd.read_parquet("hf://datasets/Mike0307/MNIST-M/" + splits_mnist_m["train"])
    mnistm_test = pd.read_parquet("hf://datasets/Mike0307/MNIST-M/" + splits_mnist_m["test"])
    
    
    def bytes_to_numpy(img_bytes):
        """Converts a PNG string back to a normalized (28, 28, x) numpy array."""
        try:
            # Open image from bytes using PIL
            img = Image.open(io.BytesIO(img_bytes))
    
            # Convert to numpy array and normalize
            img_np_array = np.array(img, dtype=np.float32) / 255.0
    
            if (img_np_array.shape[0] == 28) and (img_np_array.shape[1] == 28):
                return img_np_array
            else:
                # Crop image
                cropped_np_array = img_np_array[2:30, 2:30, :]
                return cropped_np_array
        except Exception as e:
            print(f"Error decoding base64 image: {e}")
            return None
    
    
    # Prepare transfer target training dataset
    mnistm_train_filtered = mnist_m_train[mnist_m_train['label'] == 0]
    mnistm_train_filtered['image_np'] = mnistm_train_filtered['image'].apply(
        lambda x: bytes_to_numpy(x['bytes'])
    )
    
    img_np_list = [x for x in mnistm_train_filtered['image_np'] if x is not None]
    x_train_mnistm = np.array(img_np_list)
    y_train_mnistm = np.array(mnistm_train_filtered['label'])
    
    # Prepare evaluation dataset
    mnistm_test_filtered = pd.concat([
        mnistm_test[mnistm_test['label'] == 0],
        mnistm_test[mnistm_test['label'] != 0].sample(110, random_state=42)
    ])
    mnistm_test_filtered['image_np'] = mnistm_test_filtered['image'].apply(
        lambda x: bytes_to_numpy(x['bytes'])
    )
    mnistm_test_img_list = [x for x in mnistm_test_filtered['image_np'] if x is not None]
    x_test_mnistm = np.array(mnistm_test_img_list)
    y_test_mnistm = np.array(mnistm_test_filtered['label'])
    
    # Update input layer
    TRANSFER_SHAPE = (28, 28, 3)
    transfer_input = Input(shape=TRANSFER_SHAPE, name='transfer_input_28x28_3ch')
    # Input adapter layer
    x = Conv2D(32, (3, 3), activation='relu', padding='same', name='transfer_conv1')(transfer_input)
    
    original_encoder = autoencoder.get_layer('encoder')
    # Freeze intermediate layers
    # Layer 1: pool1
    x = original_encoder.get_layer('pool1')(x)
    original_encoder.get_layer('pool1').trainable = False
    
    # Layer 2: conv2
    x = original_encoder.get_layer('conv2')(x)
    original_encoder.get_layer('conv2').trainable = False
    
    # Layer 3: pool2
    x = original_encoder.get_layer('pool2')(x)
    original_encoder.get_layer('pool2').trainable = False
    
    # Bottleneck Transition Layers (Flatten and Dense)
    flat = original_encoder.get_layer('flatten')(x)
    original_encoder.get_layer('flatten').trainable = False
    
    latent = original_encoder.get_layer('latent_bottleneck')(flat)
    original_encoder.get_layer('latent_bottleneck').trainable = False
    
    # Consolidated transfer encoder
    transfer_encoder = Model(transfer_input, latent, name='transfer_encoder')
    # New decoder input layer
    transfer_latent_input = Input(shape=(32,), name='transfer_latent_input')
    
    original_decoder = autoencoder.get_layer('decoder')
    # Keep original decoder initial layers
    x = original_decoder.get_layer('decoder_dense_start')(transfer_latent_input)
    x = original_decoder.get_layer('decoder_reshape')(x)
    # Add original decoder layers, these layers will have weights adjusted during transfer learning process
    x = original_decoder.get_layer('deconv1')(x)
    x = original_decoder.get_layer('up_sampling2d')(x)
    x = original_decoder.get_layer('deconv2')(x)
    x = original_decoder.get_layer('up_sampling2d_1')(x)
    # New final output layer to reflect 3 channels, trainable
    transfer_decoded = Conv2D(3, (3, 3), activation='sigmoid', padding='same', name='output_28x28_3ch_final')(x)
    transfer_decoder = Model(transfer_latent_input, transfer_decoded, name='transfer_decoder')
    
    # Consolidate transfer input, encoder, and decoder layers
    transfer_autoencoder = Model(transfer_input, transfer_decoder(transfer_encoder(transfer_input)),
                                 name='CAE_TRANSFER_MNISTM')
    # Fit model to target MNIST-M data
    transfer_autoencoder.compile(optimizer='adam', loss='mse')
    transfer_autoencoder.fit(
        x_train_mnistm,
        x_train_mnistm,
        epochs=5,
        batch_size=32,
        shuffle=True,
        validation_split=0.1,
        verbose=0
    )
    
    reconstructions_mnistm = transfer_autoencoder.predict(x_train_mnistm, verbose=0)
    mse_mnistm = np.mean(np.power(x_train_mnistm - reconstructions_mnistm, 2), axis=(1, 2, 3))
    anomaly_threshold_transfer_95th = np.percentile(mse_mnistm, 95)
    # Threshold = 0.058
    
    mnistm_normal_test_errors = np.mean(np.power(
        x_test_mnistm[y_test_mnistm == 0] - transfer_autoencoder.predict(x_test_mnistm[y_test_mnistm == 0], verbose=0), 2),
        axis=(1, 2, 3))
    
    mnistm_anomaly_test_errors = np.mean(np.power(
        x_test_mnistm[y_test_mnistm != 0] - transfer_autoencoder.predict(x_test_mnistm[y_test_mnistm != 0], verbose=0), 2),
        axis=(1, 2, 3))
    
    mnistm_normal_test_errors[mnistm_normal_test_errors <= anomaly_threshold_transfer_95th].shape[0] / \
    mnistm_normal_test_errors.shape[0]
    
    mnistm_anomaly_test_errors[mnistm_anomaly_test_errors <= anomaly_threshold_transfer_95th].shape[0] / \
    mnistm_anomaly_test_errors.shape[0]
    
    # Convert evaluation dataset images to grayscale
    grayscale_weights = np.array([0.2989, 0.5870, 0.1140], dtype=np.float32)
    grayscale_x_test_mnistm = np.dot(x_test_mnistm, grayscale_weights)
    grayscale_x_test_mnistm = np.expand_dims(grayscale_x_test_mnistm, axis=-1)
    
    # Load anomalousness threshold from original trained model
    anomaly_threshold_transfer_95th = 0.01845815759152173
    
    # Measure original CAE accuracy
    baseline_mnistm_normal_test_errors = np.mean(np.power(
        grayscale_x_test_mnistm[y_test_mnistm == 0] - autoencoder.predict(grayscale_x_test_mnistm[y_test_mnistm == 0],
                                                                          verbose=0), 2), axis=(1, 2, 3))
    
    baseline_mnistm_anomaly_test_errors = np.mean(np.power(
        grayscale_x_test_mnistm[y_test_mnistm != 0] - autoencoder.predict(grayscale_x_test_mnistm[y_test_mnistm != 0],
                                                                          verbose=0), 2), axis=(1, 2, 3))
    
    baseline_mnistm_normal_test_errors[baseline_mnistm_normal_test_errors <= anomaly_threshold_transfer_95th].shape[0] / \
    baseline_mnistm_normal_test_errors.shape[0]
    
    baseline_mnistm_anomaly_test_errors[baseline_mnistm_anomaly_test_errors > anomaly_threshold_transfer_95th].shape[0] / \
    baseline_mnistm_anomaly_test_errors.shape[0]

---

## [tutorials/machine-learning/quickstart-tutorial/index]

# Quickstart Tutorial

In this tutorial, you’ll learn how to build a basic Machine Learning project in Dataiku, from data exploration to model development, using mainly Jupyter Notebooks.

## Prerequisites

  * Have access to a Dataiku 12+ instance.

  * Create a Python>=3.9 code environment named `py_quickstart` with the following required packages:



    
    
    mlflow # tested with 2.17.2
    scikit-learn>=1.0,<1.4
    scipy<1.12.0
    statsmodels
    seaborn
    

Note

In Dataiku, the equivalent of virtual environments is called a “code environment.” The [code environment documentation](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html#create-a-code-environment>) provides more information and instructions for creating a new Python code environment.

## Installation

### Import the project

On the Dataiku homepage, select **\+ NEW PROJECT > Learning projects**. In the _Quick Start_ section, select _Developers Quick Start_.

Alternatively, you can download the project from [this page](<https://cdn.downloads.dataiku.com/public/dss-samples/QS_DEVELOPERS/>) and then upload it to your Dataiku instance: **\+ NEW PROJECT > Import project**.

### Set the code environment

To ensure the code environment is automatically selected for running all the Python scripts in your project, we will change the project settings to use it by default.

  * On the top bar, select **… > Settings > Code env selection**.

  * In the **Default Python code env** :

    * Change **Mode** to `Select an environment`.

    * In the **Environment** parameter, select the code environment you’ve just created.

    * Click the `Save` button or do a `Ctrl+S`




## Set up the project

This tutorial comes with the following:

  * a `README.md` file (stored in the project [Wiki](<https://doc.dataiku.com/dss/latest/collaboration/wiki.html>))

  * an input dataset: the [Heart Failure Prediction Dataset](<https://www.kaggle.com/datasets/fedesoriano/heart-failure-prediction>)

  * three Jupyter Notebooks that you will leverage to build the project

  * a Python repository stored in the [project library](<https://doc.dataiku.com/dss/latest/python-api/project-libraries.html>), with some Python functions that will be used in the different notebooks:


[utils/data_processing.py](<../../../_downloads/75f055ed4bb8721c193a46cb4359b189/data_processing.py>)
    
    
    """data_processing.py
    
    This file contains data preparation functions to process the heart measures dataset.
    """
    
    import pandas as pd
    
    def transform_heart_categorical_measures(df, chest_pain_colname, resting_ecg_colname, 
                                             exercise_induced_angina_colname, st_slope_colname, sex_colname):
        """
        Transforms each category from the given categorical columns into int value, using specific replacement rules for each column.
        
        :param pd.DataFrame df: the input dataset
        :param str chest_pain_colname: the name of the column containing information relative to chest pain type
        :param str resting_ecg_colname: the name of the column containing information relative to the resting electrocardiogram results
        :param str exercise_induced_angina_colname: the name of the column containing information relative to exercise-induced angina
        :param str st_slope_colname: the name of the column containing information relative to the slope of the peak exercise ST segment
        :param str sex_colname: the name of the column containing information relative to the patient gender
        
        :returns: the dataset with transform categorical columns
        :rtype: pd.DataFrame
        """
        df[chest_pain_colname].replace({'TA':1, 'ATA':2, 'NAP': 3, 'ASY': 4}, inplace=True)
        df[resting_ecg_colname].replace({'Normal':0, 'ST':1, 'LVH':2}, inplace=True)
        df[exercise_induced_angina_colname].replace({'N':0, 'Y':1}, inplace=True)
        df[st_slope_colname].replace({'Down':0, 'Flat':1, 'Up':2}, inplace=True)
        df[sex_colname].replace({'M': 0, 'F': 1}, inplace=True)
        return df
    

[utils/model_training.py](<../../../_downloads/3fc97c8a2ce71b1ab6844f4e40dc1212/model_training.py>)
    
    
    """model_training.py
    
    This file contains ML modeling functions to grid search best hyper parameters of a Scikit-Learn model and cross evaluate a model.
    """
    
    import numpy as np
    from sklearn.model_selection import GridSearchCV
    from sklearn.model_selection import cross_validate
    
    def find_best_parameters(X, y, estimator, params, cv=5):
        """
        Performs a grid search on the sklearn estimator over a set of hyper parameters and return the best hyper parameters.
        
        :param pd.DataFrame X: The data to fit
        :param pd.Series y: the target variable to predict
        :param sklearn-estimator estimator: The scikit-learn model used to fit the data
        :param dict params: the set of hyper parameters to search on
        :param int cv: the number of folds to use for cross validation, default is 5
        
        :returns: the best hyper parameters
        :rtype: dict
        """
        grid = GridSearchCV(estimator, params, cv=cv)
        grid.fit(X, y)
        return grid.best_params_
    
    def cross_validate_scores(X, y, estimator, cv=5, scoring=['accuracy']):
        """
        Performs a cross evaluation of the scikit learn model over n folds.
        
        :param pd.DataFrame X: The data to fit
        :param pd.Series y: the target variable to predict
        :param sklearn-estimator estimator: The scikit-learn model used to fit the data
        :param int cv: the number of folds to use for cross validation
        :param list scoring: the list of performance metrics to use to evaluate the model
        
        :returns: the average result for each performance metrics over the n folds
        :rtype: dict
        """
        cross_val = cross_validate(estimator, X, y, cv=cv, scoring=scoring)
        metrics_result = {}
        for metric in scoring:
            metrics_result[metric] = np.mean(cross_val['test_'+metric])
        return metrics_result
    

The project aims to build a binary predictive Machine Learning model to predict the risk of heart failure based on health information. For that, you’ll go through the standard steps of a Machine Learning project: data exploration, data preparation, machine learning modeling using different ML models, and model evaluation.

## Instructions

The project is composed of three notebooks (they can be found in the `Notebooks` section: **< /> > Notebooks**) that you will run one by one. For each notebook:

  1. Ensure you use the code environment specified in the **Prerequisites** (`py_quickstart`). You can change the Python kernel in the Notebook menu under **Kernel > Change Kernel**.

  2. Run the notebook cell by cell.

  3. For notebooks 1 and 3, follow the instructions in the last section of each notebook to build a new step in the project workflow.




You’ll find the details of these notebooks and the associated outputs in the following sections:

---

## [tutorials/machine-learning/quickstart-tutorial/step1_data_preparation]

# Step 1: Prepare the input dataset for ML modeling

The project is based on the [Heart Failure Prediction Dataset](<https://www.kaggle.com/datasets/fedesoriano/heart-failure-prediction>).

This first notebook:

  * Performs a quick exploratory analysis of the input dataset: it looks at the structure of the dataset and the distribution of the values in the different categorical and continuous columns.

  * Uses the functions from the project Python library to clean & prepare the input dataset before Machine Learning modeling. We will first clean categorical and continuous columns, then split the dataset into a train set and a test set.




Finally, we will transform this notebook into a Python recipe in the project Flow that will output the new train and test datasets.

_Tip_ : [Project libraries](<https://doc.dataiku.com/dss/latest/python/reusing-code.html#sharing-python-code-within-a-project>) allow you to build shared code repositories. They can be synchronized with an external Git repository.

## 0\. Import packages

**Make sure you’re using the correct code environment** (see prerequisites)

To be sure, go to **Kernel > Change kernel** and choose `py_quickstart`
    
    
    %pylab inline
    
    
    
    Populating the interactive namespace from numpy and matplotlib
    
    
    
    import dataiku
    from dataiku import pandasutils as pdu
    import pandas as pd
    import matplotlib.pyplot as plt
    import seaborn as sns
    import math
    from utils import data_processing
    from sklearn.preprocessing import RobustScaler
    from sklearn.model_selection import train_test_split
    
    
    
    import warnings
    warnings.filterwarnings('ignore')
    

## 1\. Import the data

Let’s use the Dataiku Python API to import the input dataset. This piece of code allows retrieving data in the same manner, no matter where the dataset is stored (local filesystem, SQL database, Cloud data lakes, etc.)
    
    
    dataset_heart_measures = dataiku.Dataset("heart_measures")
    df = dataset_heart_measures.get_dataframe(limit=100000)
    

## 2\. A quick audit of the dataset

### 2.1 Compute the shape of the dataset
    
    
    print(f'The shape of the dataset is {df.shape}')
    
    
    
    The shape of the dataset is (918, 12)
    

### 2.2 Look at a preview of the first rows of the dataset
    
    
    df.head()
    

Export dataframe 

| Age | Sex | ChestPainType | RestingBP | Cholesterol | FastingBS | RestingECG | MaxHR | ExerciseAngina | Oldpeak | ST_Slope | HeartDisease  
---|---|---|---|---|---|---|---|---|---|---|---|---  
0 | 40 | M | ATA | 140 | 289 | 0 | Normal | 172 | N | 0.0 | Up | 0  
1 | 49 | F | NAP | 160 | 180 | 0 | Normal | 156 | N | 1.0 | Flat | 1  
2 | 37 | M | ATA | 130 | 283 | 0 | ST | 98 | N | 0.0 | Up | 0  
3 | 48 | F | ASY | 138 | 214 | 0 | Normal | 108 | Y | 1.5 | Flat | 1  
4 | 54 | M | NAP | 150 | 195 | 0 | Normal | 122 | N | 0.0 | Up | 0  
  
### 2.3 Inspect missing values & number of distinct values (cardinality) for each column
    
    
    pdu.audit(df)
    

Export dataframe 

| _a_variable | _b_data_type | _c_cardinality | _d_missings | _e_sample_values  
---|---|---|---|---|---  
0 | Age | int64 | 50 | 0 | [40, 49]  
1 | Sex | object | 2 | 0 | [M, F]  
2 | ChestPainType | object | 4 | 0 | [ATA, NAP]  
3 | RestingBP | int64 | 67 | 0 | [140, 160]  
4 | Cholesterol | int64 | 222 | 0 | [289, 180]  
5 | FastingBS | int64 | 2 | 0 | [0, 1]  
6 | RestingECG | object | 3 | 0 | [Normal, ST]  
7 | MaxHR | int64 | 119 | 0 | [172, 156]  
8 | ExerciseAngina | object | 2 | 0 | [N, Y]  
9 | Oldpeak | float64 | 53 | 0 | [0.0, 1.0]  
10 | ST_Slope | object | 3 | 0 | [Up, Flat]  
11 | HeartDisease | int64 | 2 | 0 | [0, 1]  
  
## 3\. Exploratory data analysis

### 3.1 Define categorical & continuous columns
    
    
    categorical_cols = ['Sex','ChestPainType', 'FastingBS', 'RestingECG', 'ExerciseAngina', 'ST_Slope']
    continuous_cols = ['Age', 'RestingBP', 'Cholesterol', 'MaxHR', 'Oldpeak']
    

### 3.2 Look at the distibution of continuous features
    
    
    nb_cols=2
    fig = plt.figure(figsize=(8,6))
    fig.suptitle('Distribution of continuous features', fontsize=11)
    gs = fig.add_gridspec(math.ceil(len(continuous_cols)/nb_cols),nb_cols)
    gs.update(wspace=0.3, hspace=0.4)
    for i, col in enumerate(continuous_cols):
        ax = fig.add_subplot(gs[math.floor(i/nb_cols),i%nb_cols])
        sns.histplot(x=df[col], ax=ax)
    

### 3.3 Look at the distribution of categorical columns
    
    
    nb_cols=2
    fig = plt.figure(figsize=(8,6))
    fig.suptitle('Distribution of categorical features', fontsize=11)
    gs = fig.add_gridspec(math.ceil(len(categorical_cols)/nb_cols),nb_cols)
    gs.update(wspace=0.3, hspace=0.4)
    for i, col in enumerate(categorical_cols):
        ax = fig.add_subplot(gs[math.floor(i/nb_cols),i%nb_cols])
        plot = sns.countplot(x=df[col], palette="colorblind")
    

### 3.4 Look at the distribution of target variable
    
    
    target = "HeartDisease"
    fig = plt.figure(figsize=(4,2.5))
    fig.suptitle('Distribution of heart disease', fontsize=11, y=1.11)
    plot = sns.countplot(x=df[target], palette="colorblind")
    

_Tip:_ To ease collaboration, all the insights you create from Jupyter Notebooks can be shared with other users by publishing them on dashboards. See the [documentation](<https://doc.dataiku.com/dss/latest/dashboards/insights/jupyter-notebook.html>) for more information.

## 4\. Prepare data

### 4.1 Clean categorical columns
    
    
    # Transform string values from categorical columns into int, using the functions from the project libraries
    df_cleaned = data_processing.transform_heart_categorical_measures(df, "ChestPainType", "RestingECG",
                                                                      "ExerciseAngina", "ST_Slope", "Sex")
    
    df_cleaned.head()
    

Export dataframe 

| Age | Sex | ChestPainType | RestingBP | Cholesterol | FastingBS | RestingECG | MaxHR | ExerciseAngina | Oldpeak | ST_Slope | HeartDisease  
---|---|---|---|---|---|---|---|---|---|---|---|---  
0 | 40 | 0 | 2 | 140 | 289 | 0 | 0 | 172 | 0 | 0.0 | 2 | 0  
1 | 49 | 1 | 3 | 160 | 180 | 0 | 0 | 156 | 0 | 1.0 | 1 | 1  
2 | 37 | 0 | 2 | 130 | 283 | 0 | 1 | 98 | 0 | 0.0 | 2 | 0  
3 | 48 | 1 | 4 | 138 | 214 | 0 | 0 | 108 | 1 | 1.5 | 1 | 1  
4 | 54 | 0 | 3 | 150 | 195 | 0 | 0 | 122 | 0 | 0.0 | 2 | 0  
  
### 4.2 Transform categorical columns into dummies
    
    
    df_cleaned = pd.get_dummies(df_cleaned, columns = categorical_cols, drop_first = True)
    
    print("Shape after dummies transformation: " + str(df_cleaned.shape))
    
    
    
    Shape after dummies transformation: (918, 16)
    

### 4.3 Scale continuous columns

Let’s use the Scikit-Learn Robust Scaler to scale continuous features
    
    
    scaler = RobustScaler()
    df_cleaned[continuous_cols] = scaler.fit_transform(df_cleaned[continuous_cols])
    

## 5\. Split the dataset into train and test

Let’s now split the dataset into a train set that will be used for experimenting and training the Machine Learning models and test set that will be used to evaluate the deployed model.
    
    
    heart_measures_train_df, heart_measures_test_df = train_test_split(df_cleaned, test_size=0.2, stratify=df_cleaned.HeartDisease)
    

## 6\. Next: use this notebook to create a new step in the project workflow

Now that our notebook is up and running, we can use it to create the first step of our pipeline in the Flow:

  * Click on the **\+ Create Recipe** button at the top right of the screen.

  * Select the **Python recipe** option.

  * Choose the `heart_measures` dataset as the input dataset and create two output datasets: `heart_measures_train` and `heart_measures_test`.

  * Click on the **Create recipe** button.

  * At the end of the recipe script, replace the last four rows of code with:



    
    
    heart_measures_train = dataiku.Dataset("heart_measures_train")
    heart_measures_train.write_with_schema(heart_measures_train_df)
    heart_measured_test = dataiku.Dataset("heart_measures_test")
    heart_measured_test.write_with_schema(heart_measures_test_df)
    

  * Run the recipe




Great! We can now go on the Flow, we’ll see an orange circle that represents your first step (we call it a **Recipe**) and two output datasets.

The Flow should now look like that:

---

## [tutorials/machine-learning/quickstart-tutorial/step2_ml_experiment]

# Step 2: Test different Machine Learning models for heart failures prediction

In this notebook, we will test different Machine Learning approaches to predict heart failures using [scikit-learn](<https://scikit-learn.org/stable/>) models (logistic regression, SVM, decision tree, and random forest). For each model, we will first perform a grid search to find the best parameters, then train the model on the train set using these best parameters and finally log everything (parameters, performance metrics, and models) to keep track of the results of our different experiments and be able to compare afterward. Our [Experiment Tracking capability](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/index.html>) relies on the [MLflow framework](<https://www.mlflow.org/docs/2.17.2/tracking.html>).

_Tip:_ Experiment Tracking allows you to save all experiment-related information that you care about for every experiment you run. In Dataiku, this can be done when coding using the [MLflow Tracking API](<https://www.mlflow.org/docs/2.17.2/tracking.html>). You can then explore and compare all your experiments in the Experiment Tracking UI.

## 0\. Import packages

**Make sure you’re using the correct code environment** (see prerequisites)

To be sure, go to **Kernel > Change kernel** and choose `py_quickstart`
    
    
    %pylab inline
    
    
    
    Populating the interactive namespace from numpy and matplotlib
    
    
    
    import dataiku
    from dataiku import pandasutils as pdu
    import pandas as pd
    from utils import model_training
    import mlflow
    from sklearn.linear_model import LogisticRegression
    from sklearn.svm import SVC
    from sklearn.tree import DecisionTreeClassifier
    from sklearn.ensemble import RandomForestClassifier
    
    
    
    import warnings
    warnings.filterwarnings('ignore')
    
    
    
    client = dataiku.api_client()
    client._session.verify = False
    

## 1\. Import the train dataset
    
    
    dataset_heart_measures_train = dataiku.Dataset("heart_measures_train")
    df = dataset_heart_measures_train.get_dataframe(limit=100000)
    

## 2\. Set the experiment environment

As we would like to keep track of all the experiment-related information (performance metrics, parameters and models) for our different ML experiments, we must use a Dataiku managed folder to store all this information. This section is about creating (or accessing if it already exists) the required managed folder.

### 2.1 Set the required parameters for creating/accessing the managed folder
    
    
    # Set parameters
    experiment_name = "Binary Heart Disease Classification"
    experiments_managed_folder_name = "Binary classif experiments"
    project = client.get_default_project()
    mlflow_extension = project.get_mlflow_extension()
    

### 2.2 Create/access the managed folder
    
    
    # Create the managed folder if it doesn't exist
    if experiments_managed_folder_name not in [folder['name'] for folder in project.list_managed_folders()]:
        connections = client.list_connections_names('all')
        for connection in connections:
            try:
                project.create_managed_folder(experiments_managed_folder_name, connection_name=connection)
                break
            except Exception:
                continue
    
    # Get the managed folder id
    experiments_managed_folder_id = [folder['id'] for folder in project.list_managed_folders() if folder['name']==experiments_managed_folder_name][0]
    
    # Get the managed folder using the id
    experiments_managed_folder = project.get_managed_folder(experiments_managed_folder_id)
    

### 2.3 Prepare data for training
    
    
    # Prepare data for experiment
    target= ["HeartDisease"]
    X = df.drop(target, axis=1)
    y = df[target[0]]
    

## 3\. Test different modeling approaches

This section will test different models: a Logistic Regression, an SVM, a Decision Tree, and a Random Forest. For each type of model, we will proceed in several steps:

  1. Set the experiment (where to log the results) and start a new run.

  2. Define the set of hyperparameters to test.

  3. Perform a grid search on these hyperparameters using the `find_best_parameters` function from the `model_training.py` file in the project library.

  4. Cross-evaluate the model with the best hyperparameters on 5 folds using the `cross_validate_scores` function from the `model_training.py` file in the project library.

  5. Train the model on the train set using the best hyperparameters.

  6. Log the experiment’s results (parameters, performance metrics, and model).




You can find more information on the tracking APIs in the [MLflow tracking documentation](<https://www.mlflow.org/docs/2.17.2/tracking.html>).

### 3.1 Logistic Regression

We use the [Scikit-Learn Logistic Regression](<https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html>) model.
    
    
    with project.setup_mlflow(managed_folder=experiments_managed_folder) as mlflow:
        mlflow.set_experiment(experiment_name)
    
        with mlflow.start_run(run_name="Linear Regression"):
    
            # Find best hyper parameters using a grid search
            lr = LogisticRegression(random_state = 42)
            cv = 5
            params = {'penalty':['none','l2']}
            scoring = ['accuracy', 'precision', 'recall', 'roc_auc', 'f1']
            print("Searching for best parameters...")
            lr_best_params = model_training.find_best_parameters(X, y, lr, params, cv=cv)
            print(f"Best parameters: {lr_best_params}")
    
            # Set the best hyper parameters
            lr.set_params(**lr_best_params)
    
            # Cross evaluate the model on the best hyper parameters
            lr_metrics_results = model_training.cross_validate_scores(X, y, lr, cv=cv, scoring=scoring)
            print(f'Average values for evaluation metrics after cross validation: {", ".join(f"{key}: {round(value, 2)}" for key, value in lr_metrics_results.items())}')
    
            # Train the model on the whole train set
            lr.fit(X,y)
    
            # Log the experiment results
            mlflow.log_params(lr_best_params)
            mlflow.log_metrics(lr_metrics_results)
            mlflow.sklearn.log_model(lr, artifact_path="model")
            print("Best parameters, cross validation metrics, and the model have been saved to Experiment Tracking")
    
    
    
    2024/06/28 21:09:16 INFO mlflow.tracking.fluent: Experiment with name 'Binary Heart Disease Classification' does not exist. Creating a new experiment.
    
    
    
    Searching for best parameters...
    Best parameters: {'penalty': 'l2'}
    Average values for evaluation metrics after cross validation: accuracy: 0.86, precision: 0.86, recall: 0.89, roc_auc: 0.91, f1: 0.87
    Best parameters, cross validation metrics, and the model have been saved to Experiment Tracking
    

### 3.2 Support Vector Machine:

We use the [Scikit-Learn SVC](<https://scikit-learn.org/stable/modules/generated/sklearn.svm.SVC.html>) model.
    
    
    with project.setup_mlflow(managed_folder=experiments_managed_folder) as mlflow:
        mlflow.set_experiment(experiment_name)
    
        with mlflow.start_run(run_name="SVM"):
    
            # Find best hyper parameters using a grid search
            svm = SVC(random_state = 42)
            cv = 5
            params = {'C': [0.1,1, 10], 'gamma': [1,0.1,0.01,0.001],'kernel': ['rbf', 'poly', 'sigmoid']}
            scoring = ['accuracy', 'precision', 'recall', 'roc_auc', 'f1']
            print("Searching for best parameters...")
            svm_best_params = model_training.find_best_parameters(X, y, svm, params, cv=cv)
            print(f"Best parameters: {svm_best_params}")
    
            # Set the best hyper parameters
            svm.set_params(**svm_best_params)
    
            # Cross evaluate the model on the best hyper parameters
            svm_metrics_results = model_training.cross_validate_scores(X, y, svm, cv=cv, scoring=scoring)
            print(f'Average values for evaluation metrics after cross validation: {", ".join(f"{key}: {round(value, 2)}" for key, value in svm_metrics_results.items())}')
    
            # Train the model on the whole train set
            svm.fit(X,y)
    
            # Log the experiment results
            mlflow.log_params(svm_best_params)
            mlflow.log_metrics(svm_metrics_results)
            mlflow.sklearn.log_model(svm, artifact_path="model")
            print("Best parameters, cross validation metrics, and the model have been saved to Experiment Tracking")
    
    
    
    Searching for best parameters...
    Best parameters: {'C': 10, 'gamma': 0.01, 'kernel': 'rbf'}
    Average values for evaluation metrics after cross validation: accuracy: 0.87, precision: 0.86, recall: 0.91, roc_auc: 0.92, f1: 0.89
    Best parameters, cross validation metrics, and the model have been saved to Experiment Tracking
    

### 3.3 Decision Tree:

We use the [Scikit-Learn Decision Tree](<https://scikit-learn.org/stable/modules/generated/sklearn.tree.DecisionTreeClassifier.html#sklearn.tree.DecisionTreeClassifier>) model.
    
    
    with project.setup_mlflow(managed_folder=experiments_managed_folder) as mlflow:
        mlflow.set_experiment(experiment_name)
    
        with mlflow.start_run(run_name="Decision Tree"):
    
            # Find best hyper parameters using a grid search
            dtc = DecisionTreeClassifier(random_state = 42)
            cv = 5
            params = {'max_depth' : [4,5,6,7,8],
                      'criterion' :['gini', 'entropy']}
            scoring = ['accuracy', 'precision', 'recall', 'roc_auc', 'f1']
            print("Searching for best parameters...")
            dtc_best_params = model_training.find_best_parameters(X, y, dtc, params, cv=cv)
            print(f"Best parameters: {dtc_best_params}")
    
            # Set the best hyper parameters
            dtc.set_params(**dtc_best_params)
    
            # Cross evaluate the model on the best hyper parameters
            dtc_metrics_results = model_training.cross_validate_scores(X, y, dtc, cv=cv, scoring=scoring)
            print(f'Average values for evaluation metrics after cross validation: {", ".join(f"{key}: {round(value, 2)}" for key, value in dtc_metrics_results.items())}')
    
            # Train the model on the whole train set
            dtc.fit(X,y)
    
            # Log the experiment results
            mlflow.log_params(dtc_best_params)
            mlflow.log_metrics(dtc_metrics_results)
            mlflow.sklearn.log_model(dtc, artifact_path="model")
            print("Best parameters, cross validation metrics, and the model have been saved to Experiment Tracking")
    
    
    
    Searching for best parameters...
    Best parameters: {'criterion': 'gini', 'max_depth': 6}
    Average values for evaluation metrics after cross validation: accuracy: 0.82, precision: 0.84, recall: 0.83, roc_auc: 0.83, f1: 0.84
    Best parameters, cross validation metrics, and the model have been saved to Experiment Tracking
    

### 3.4 Random Forest:

We use the [Scikit-Learn Random Forest](<https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html>) model.
    
    
    with project.setup_mlflow(managed_folder=experiments_managed_folder) as mlflow:
        mlflow.set_experiment(experiment_name)
    
        with mlflow.start_run(run_name="Random Forest"):
    
            # Find best parameters and cross evaluate the model on the best parameters
            rfc = RandomForestClassifier(random_state = 42)
            cv = 5
            params = {'n_estimators': [100,200,300],
                      'max_depth' : [5,6,7],
                      'criterion' :['gini', 'entropy']}
            scoring = ['accuracy', 'precision', 'recall', 'roc_auc', 'f1']
            print("Searching for best parameters...")
            rfc_best_params = model_training.find_best_parameters(X, y, rfc, params, cv=cv)
            print(f"Best parameters: {rfc_best_params}")
    
            # Set the best hyper parameters
            rfc.set_params(**rfc_best_params)
    
            # Cross evaluate the model on the best hyper parameters
            rfc_metrics_results = model_training.cross_validate_scores(X, y, rfc, cv=cv, scoring=scoring)
            print(f'Average values for evaluation metrics after cross validation: {", ".join(f"{key}: {round(value, 2)}" for key, value in rfc_metrics_results.items())}')
    
            # Train the model using the best parameters
            rfc.fit(X,y)
    
            # Log the experiment results
            mlflow.log_params(rfc_best_params)
            mlflow.log_metrics(rfc_metrics_results)
            mlflow.sklearn.log_model(rfc, artifact_path="model")
            print("Best parameters, cross validation metrics, and the model have been saved to Experiment Tracking")
    
    
    
    Searching for best parameters...
    Best parameters: {'criterion': 'gini', 'max_depth': 7, 'n_estimators': 200}
    Average values for evaluation metrics after cross validation: accuracy: 0.87, precision: 0.86, recall: 0.91, roc_auc: 0.92, f1: 0.88
    Best parameters, cross validation metrics, and the model have been saved to Experiment Tracking
    

## 4\. Explore the results

All done! We can now look at the results & compare our different models by going to the Experiment Tracking page (on the top bar, hover over the circle icon, and select **Experiment Tracking**.

---

## [tutorials/machine-learning/quickstart-tutorial/step3_ml_deploy_and_eval]

# Step 3: Create a Dataiku Saved Model using the best-performing model

Dataiku offers pre-built capabilities to evaluate, deploy & monitor Machine Learning models. Our Python model needs to be stored as a Dataiku Saved Model to benefit these capabilities. In this notebook, we will collect the best model optimizing the accuracy metric from our previous experiment, and deploy it in the Flow as a Dataiku Saved Model.

_Tip:_ Creating a Dataiku Saved Model will allow you to benefit from a set of pre-built evaluation interfaces along with deployment and monitoring capabilities.

## 0\. Import packages

**Make sure you’re using the correct code environment** (see prerequisites)

To be sure, go to **Kernel > Change kernel** and choose the `py_quickstart`
    
    
    %pylab inline
    
    
    
    Populating the interactive namespace from numpy and matplotlib
    
    
    
    import warnings
    warnings.filterwarnings('ignore')
    
    
    
    import dataiku
    from dataiku import pandasutils as pdu
    import pandas as pd
    import mlflow
    from dataikuapi.dss.ml import DSSPredictionMLTaskSettings
    
    
    
    client = dataiku.api_client()
    client._session.verify = False
    

## 1\. Get access to the ML experiment information

In this section, we use the Dataiku Python API to access to the managed folder where the results of our experiments are stored.
    
    
    # Set parameters
    experiment_name = "Binary Heart Disease Classification"
    experiments_managed_folder_name = "Binary classif experiments"
    
    # Get various handles
    project = client.get_default_project()
    mlflow_extension = project.get_mlflow_extension()
    experiments_managed_folder_id = dataiku.Folder(experiments_managed_folder_name).get_id()
    experiments_managed_folder = project.get_managed_folder(experiments_managed_folder_id)
    

## 2\. Select the experiment with the best accuracy

Now, let’s retrieve the run that generated the best model optimizing the accuracy from our Machine Learning experiments.
    
    
    optimized_metric = "accuracy" # You can switch this parameter to another performance metric
    
    with project.setup_mlflow(managed_folder=experiments_managed_folder) as mlflow:
        experiment = mlflow.set_experiment(experiment_name)
        best_run = mlflow.search_runs(experiment_ids=[experiment.experiment_id],
                                      order_by=[f"metrics.{optimized_metric} DESC"],
                                      max_results=1,
                                      output_format="list")[0]
    
    
    
    invalid escape sequence 'w'

## 3\. Create or get a Dataiku Saved Model using the API

In this section, we use the Dataiku Python API to create (or get if it already exists) the Dataiku Saved Model that will be used to deploy our Python model in the Flow.
    
    
    # Get or create SavedModel
    sm_name = "heart-disease-clf"
    sm_id = None
    for sm in project.list_saved_models():
        if sm_name != sm["name"]:
            continue
        else:
            sm_id = sm["id"]
            print("Found SavedModel {} with id {}".format(sm_name, sm_id))
            break
    if sm_id:
        sm = project.get_saved_model(sm_id)
    else:
        sm = project.create_mlflow_pyfunc_model(name=sm_name,
                                                prediction_type=DSSPredictionMLTaskSettings.PredictionTypes.BINARY)
        sm_id = sm.id
        print("SavedModel not found, created new one with id {}".format(sm_id))
    
    
    
    SavedModel not found, created new one with id 9BZVrx8D
    

## 4\. Import the new mlflow model into a Saved Model version

Finally, let’s import the model from our best run as a new version of the Dataiku Saved Model and make sure it automatically computes performance metrics & charts based on the train set.
    
    
    # Set version ID (a Saved Model can have multiple versions).
    
    if len(sm.list_versions()) == 0:
        version_id = "V1"
    else:
        max_version_num = max([int(v['id'][1:]) for v in sm.list_versions()])
        version_id = f"V{max_version_num+1}"
    
    # Create version in SavedModel
    sm_version = sm.import_mlflow_version_from_managed_folder(version_id=version_id,
                                                             managed_folder=experiments_managed_folder,
                                                             path=best_run.info.artifact_uri.split(experiments_managed_folder_id)[1]+'/model')
    
    # Evaluate the version using the previously created Dataset
    sm_version.set_core_metadata(target_column_name="HeartDisease",
                                 class_labels=[0, 1],
                                 get_features_from_dataset="heart_measures_train")
    
    sm_version.evaluate("heart_measures_train")
    

## 5\. Next: use this notebook to create a new step in the pipeline

### 5.1 Create a new step in the flow

Now that our notebook is up and running, we can use it to create the second step of our pipeline in the Flow:

  * Click on the **\+ Create Recipe** button at the top right of the screen.

  * Select the **Python recipe** option.

  * Add two **inputs** : the `heart_measures_train` dataset and the `Binary classif experiments` folder.

  * Add the `heart-disease-clf` Saved Model as the **output** : **Add** > **Use existing** (option at the bottom).

  * Click on the **Create the recipe** button.

  * Run the recipe.




You can explore all the built-in evaluation metrics & charts of your Python model by clicking on the Saved Model in the Flow.

### 5.2 Evaluate the model on the test dataset

Now that the model has been deployed on the Flow, we can evaluate it on our test dataset:

  * Select the `heart-disease-clf` Saved Model.

  * On the action panel, select the **Evaluate** recipe.

  * On the settings tab, select the `heart_measures_test` as the input dataset.

  * For the output, let’s create the ‘Output dataset’ (let’s call it `heart_measures_test_prediction`), the ‘Metrics’ dataset (let’s call it `evaluation_metrics`) and the ‘Evaluation Store’ (let’s name it `eval_heart_prediction`)

  * Click on the **Create recipe** button.

  * Run the recipe.




Success! Our model is now deployed on the Flow, it can be used for inference on new datasets and be deployed for production.

Your final Flow should look like that:

---

## [tutorials/plugins/agent/generality/index]

# Creating a custom agent

This tutorial provides clear instructions for developing a custom agent in Dataiku. It builds upon the essential knowledge gained from the [Creating and using a Code Agent](<../../../genai/agents-and-tools/code-agent/index.html>) tutorial, enhancing your skills further. By the conclusion of this guide, you will understand how to effectively package a Code Agent into a Custom Agent, enabling its use across multiple projects.

Custom Agents differ significantly from project-specific Code Agents: they function independently and are not linked to specific projects, datasets, or tools. This autonomy allows for more versatile applications but also requires thorough attention to the code environment and its associated dependencies.

## Prerequisites

  * Dataiku >= 13.4

  * Develop plugins permission

  * A connection to an LLM, preferably an OpenAI connection

  * Python >= 3.9




## Introduction

This tutorial starts with the [Creating and using a Code Agent](<../../../genai/agents-and-tools/code-agent/index.html>) tutorial. You will learn how to package this Code Agent into a Custom agent, allowing the user to use it across all projects where you may need this processing. A custom agent is a broader version of a code agent in the sense that this agent is not tied to a project. So, you should create an autonomous agent. It is not tied to a project, so you can not rely on deployed tools; you should embed them if you need some tool. Moreover, you can not rely on a particular **Dataset** (or other Dataiku objects) for the same reason. As it may be executed in a context other than the one used at design time, you should also pay attention to the code env of the plugin.

To develop a custom agent, you must first create a plugin. Go to the main menu, click the **Plugins** menu, and select the **Write your own** from the **Add plugin** button. Then, choose a meaningful name, such as “`toolbox`.” Once the plugin is created, click the **Create a code environment** button and select Python as the default language. In the `requirements.txt` file (located in `toolbox/code-env/python/spec`), add the following requirements:
    
    
    duckduckgo_search
    langchain_core
    langchain
    

Once you have saved the modification, go to the **Summary** tabs to build the plugin code environment. The custom agent plugin will use this code environment when the agent is used.

Click the **\+ New component** button, and choose the **Agent** component in the provided list, as shown in Figure 1. Then, fill out the form by choosing a meaningful **Identifier** , select the “Minimal agent template” as a **Starter code** , and click the **Add** button.

Figure 1: New agent component.

Alternatively, you can select the **Edit** tab and, under the `toolbox` directory, create a folder named `python-agents`. This directory is where you will find and create your custom agent. Under this directory, create a directory with a meaningful name representing your agent’s name.

## Creating the agent

### Analyzing the tools

The tutorial [Creating and using a Code Agent](<../../../genai/agents-and-tools/code-agent/index.html>) uses two tools (**Get Customer Info** and **Get Company Info**) to retrieve information about a user given their ID and a company given its name. The **Get Company Info** uses the DuckDuckGo Python package to search the Internet for information about a company. So, the only requirement for this tool is to have the Python packages in the plugin code env.

The **Get Customer Info** relies on a dataset to find information on a user given her ID. As you cannot know the dataset’s name in advance, you must ask the user its name. This can be done in the **Config** section of an instantiated custom agent, as shown in Figure 2. To ask the user for a particular dataset, specify it in the `agent.json` file, as shown in Code 1 (highlighted lines).

Figure 2: Configuration of an agent.

Code 1: configuration file – `agent.json`
    
    
    {
      "meta": {
        "label": "Custom agent tutorial",
        "description": "DevAdvocacy -- Custom Agent Tutorial",
        "icon": "fas fa-magic"
      },
      "supportsImageInputs": false,
      "params": [
        {
          "name": "dataset_name",
          "label": "Customer SQL Dataset",
          "type": "DATASET",
          "mandatory": true
        }
      ]
    }
    

### Declaring the tools

Once you have analyzed the plugin’s requirements, you can start coding. The easiest thing to do is create the tool **Get Company Info** ; there is nothing more to do than the usual work for creating a tool, as shown in Code 2. Highlighted lines show the classes and variables you should use to be able to run this tutorial.

Code 2: Get Company Info
    
    
    from langchain import hub
    from langchain.agents import AgentExecutor
    from langchain.agents import create_openai_tools_agent
    from langchain.tools import tool
    
    from dataiku.llm.python import BaseLLM
    from dataiku.langchain.dku_llm import DKUChatModel
    from dataiku.langchain import LangchainToDKUTracer
    
    import dataiku
    from dataiku import SQLExecutor2
    from duckduckgo_search import DDGS
    from dataiku.sql import Constant, toSQL, Dialects
    
    OPENAI_CONNECTION_NAME = "REPLACE_WITH_YOUR_CONNECTION_NAME"
    model = DKUChatModel(llm_id=f"openai:{OPENAI_CONNECTION_NAME}:gpt-4o-mini")
    
    @tool
    def search_company_info(company_name: str) -> str:
        """
        Use this tool when you need to retrieve information on a company.
        The input of this tool is the company name.
        The output is either a small recap of the company or "No information …"
        meaning that we couldn't find information # about this company
        """
        with DDGS() as ddgs:
            results = list(ddgs.text(f"{company_name} (company)", max_results=1))
            if results:
                return f"Information found about {company_name}: {results[0]['body']}"
            return f"No information found about {company_name}"
    

Coding a custom agent with a parametrized tool requires minor plumbing. When using a tool, the LLM provides information to the tool by feeding its inputs. If the tool has several parameters, the LLM will provide input for all the parameters. But you do not want the LLM to fill the dataset name. So, this name should not be a parameter of the tool. If you include the tool in the class handling the agent (see next section for more details on this class), you must add the `self` parameter. As previously explained, `self` should not be a parameter for the same reason. Thus, you can not easily embed the tool in the agent’s class. An easy way to overcome these difficulties is to create a function to create the already parametrized tool, as shown in Code 3.

Attention

The SQL query might be written differently depending on your SQL Engine.

Code 3: Get Customer Info
    
    
    def generate_get_customer(dataset_name: str):
        @tool
        def get_customer(customer_id: str) -> str:
            """Get customer name, position and company information from database.
            The input is a customer id (stored as a string).
            The ouput is a string of the form:
                "The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            """
            dataset = dataiku.Dataset(dataset_name)
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(customer_id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            return f"No information can be found about the customer {customer_id}"
        return get_customer
    

### Coding the agent

Once the tools are created, you can focus on using these tools in your custom agent. To create a custom agent, you must create a Python class that inherits from the `BaseLLM` class. You also must define a `set_config` function to deal with the function’s parameter (if you use parameters). Moreover, you will also need a function to make the processing. Code 4 shows the full implementation of the class.

See also

If you need help on coding an agent, you will find some explanations in the [Agent](<../../../../concepts-and-examples/agents.html#ce-agents-creating-your-code-agent>) section in Concepts and examples, or you can follow [this tutorial](<../../../genai/agents-and-tools/code-agent/index.html>).

Code 4: Code of the custom agent
    
    
    tools = [search_company_info]
    
    class MyLLM(BaseLLM):
    
        def __init__(self):
            pass
    
        def set_config(self, config, plugin_config):
            self.config = config
            self.dataset = config.get("dataset_name")
            tools.append(generate_get_customer(dataset_name=self.dataset))
            self.agent = create_openai_tools_agent(model.with_config({"tags": ["agent_llm"]}), tools,
                                                   hub.pull("hwchase17/openai-tools-agent"))
    
        async def aprocess_stream(self, query: SingleCompletionQuery, settings: CompletionSettings,
                                  trace: SpanBuilder) -> CompletionResponse:
            prompt = query["messages"][0]["content"]
    
            tracer = LangchainToDKUTracer(dku_trace=trace)
            agent_executor = AgentExecutor(agent=self.agent, tools=tools)
    
            async for event in agent_executor.astream_events({"input": prompt}, version="v2",
                                                             config={"callbacks": [tracer]}):
                kind = event["event"]
                if kind == "on_chat_model_stream":
                    content = event["data"]["chunk"].content
                    if content:
                        yield {"chunk": {"text": content}}
                elif kind == "on_tool_start":
                    # Event chunks are not part of the answer itself,
                    # but can provide progress information
                    yield {"chunk": {"type": "event", "eventKind": "tool_call",
                                     "eventData": {"name": event["name"]}}}
    

## Using the agent

Once the custom agent has been coded, you can use it like any other agent. For more information, please refer to the [Using agents](<https://doc.dataiku.com/dss/latest/agents/introduction.html#generative-ai-agent-introduction-using-agents> "\(in Dataiku DSS v14\)") documentation. If you want to use your custom agent, you should create a code agent by selecting the custom agent.

To list all agents that have been defined in a project, you can use the [`list_llms()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms") and search for your agent.
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    llm_list = project.list_llms()
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    

Running this code snippet will provide a list of all LLMs defined in the project. You should see your agent in this list:
    
    
    - Agent - test guard (id: agent:2V8SR72P)
    - Agent - useCase4 (id: agent:44pVmkUi)
    - Agent - code (id: agent:4agXpWVO)
    - Agent - useCase5 (id: agent:GYrrlSns)
    - Agent - useCase1 (id: agent:IWX5i2Zh)
    - Agent - Visual (id: agent:Njgq8s9j)
    - Agent - Tutorial (id: agent:QRfIU99Z)
    - Agent - useCase2 (id: agent:aolFEv0W)
    - Agent - useCase3 (id: agent:hMRqhPVk)
    - Agent - Custom Agent tutorial (id: agent:iXqDRS08)
    

Once you know the agent’s ID, you can use it to call the agent, as shown in the code below:
    
    
    CODE_AGENT_ID = "agent:iXqDRS08"
    llm = project.get_llm(CODE_AGENT_ID)
    
    completion = llm.new_completion()
    completion.with_message('Give all the professional information you can about the customer with ID: fdouetteau. Also include information about the company if you can.')
    resp = completion.execute()
    resp.text
    
    
    
    "The customer's name is **Florian Douetteau** , and he holds the position of **CEO**
    at the company named **Dataiku**.\n\n### Company Information:\n
    - **Company Name:** Dataikun- **Overview:** Dataiku is a global software company
    that specializes in machine learning and artificial intelligence. Founded in 2013,
    Dataiku aims to make data science accessible to everyone, helping businesses
    unlock the potential of artificial intelligence.
    Florian Douetteau, as a co-founder and CEO,
    has been instrumental in guiding the company's vision and operations."

## Wrapping up

Congratulations on finishing the tutorial for creating a custom agent in Dataiku. You have effectively learned how to convert a Code Agent into a Custom Agent, a versatile tool for diverse projects. By adhering to the steps in this tutorial, you have acquired the essential skills to develop a plugin, set up the required code environment, and implement the agent’s functionality.

Custom Agents need thoughtful planning to guarantee they operate efficiently in various contexts. With this newfound knowledge, you can enhance your Dataiku projects using adaptable and reusable Custom Agents.

Here is the complete code of the custom agent:

[`agent.json`](<../../../../_downloads/c52a20bc98b49f3dd038d5744c548bca/agent.json>)
    
    
    {
      "meta": {
        "label": "Custom agent tutorial",
        "description": "DevAdvocacy -- Custom Agent Tutorial",
        "icon": "fas fa-magic"
      },
      "supportsImageInputs": false,
      "params": [
        {
          "name": "dataset_name",
          "label": "Customer SQL Dataset",
          "type": "DATASET",
          "mandatory": true
        }
      ]
    }
    

Attention

The SQL query might be written differently depending on your SQL Engine.

[`agent.py`](<../../../../_downloads/09a7a021c17819ec754cfe07a11282c2/agent.py>)
    
    
    from langchain import hub
    from langchain.agents import AgentExecutor
    from langchain.agents import create_openai_tools_agent
    from langchain.tools import tool
    
    from dataiku.llm.python import BaseLLM
    from dataiku.langchain.dku_llm import DKUChatModel
    from dataiku.langchain import LangchainToDKUTracer
    
    import dataiku
    from dataiku import SQLExecutor2
    from duckduckgo_search import DDGS
    from dataiku.sql import Constant, toSQL, Dialects
    
    OPENAI_CONNECTION_NAME = "REPLACE_WITH_YOUR_CONNECTION_NAME"
    model = DKUChatModel(llm_id=f"openai:{OPENAI_CONNECTION_NAME}:gpt-4o-mini")
    
    
    def generate_get_customer(dataset_name: str):
        @tool
        def get_customer(customer_id: str) -> str:
            """Get customer name, position and company information from database.
            The input is a customer id (stored as a string).
            The ouput is a string of the form:
                "The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            """
            dataset = dataiku.Dataset(dataset_name)
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(customer_id))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
            for (name, job, company) in query_reader.iter_tuples():
                return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
            return f"No information can be found about the customer {customer_id}"
        return get_customer
    
    @tool
    def search_company_info(company_name: str) -> str:
        """
        Use this tool when you need to retrieve information on a company.
        The input of this tool is the company name.
        The output is either a small recap of the company or "No information …"
        meaning that we couldn't find information # about this company
        """
        with DDGS() as ddgs:
            results = list(ddgs.text(f"{company_name} (company)", max_results=1))
            if results:
                return f"Information found about {company_name}: {results[0]['body']}"
            return f"No information found about {company_name}"
    
    tools = [search_company_info]
    
    class MyLLM(BaseLLM):
    
        def __init__(self):
            pass
    
        def set_config(self, config, plugin_config):
            self.config = config
            self.dataset = config.get("dataset_name")
            tools.append(generate_get_customer(dataset_name=self.dataset))
            self.agent = create_openai_tools_agent(model.with_config({"tags": ["agent_llm"]}), tools,
                                                   hub.pull("hwchase17/openai-tools-agent"))
    
        async def aprocess_stream(self, query: SingleCompletionQuery, settings: CompletionSettings,
                                  trace: SpanBuilder) -> CompletionResponse:
            prompt = query["messages"][0]["content"]
    
            tracer = LangchainToDKUTracer(dku_trace=trace)
            agent_executor = AgentExecutor(agent=self.agent, tools=tools)
    
            async for event in agent_executor.astream_events({"input": prompt}, version="v2",
                                                             config={"callbacks": [tracer]}):
                kind = event["event"]
                if kind == "on_chat_model_stream":
                    content = event["data"]["chunk"].content
                    if content:
                        yield {"chunk": {"text": content}}
                elif kind == "on_tool_start":
                    # Event chunks are not part of the answer itself,
                    # but can provide progress information
                    yield {"chunk": {"type": "event", "eventKind": "tool_call",
                                     "eventData": {"name": event["name"]}}}

---

## [tutorials/plugins/creation-configuration/index]

# Creating and configuring a plugin

This tutorial explains how to create and configure a plugin and why you should use a separate instance for plugin development.

## Prerequisites

The minimal prerequisites are:

  * “Manage all code-envs” permission.

  * “Develop plugins” permission.

  * Dataiku.




It would be best to have:

  * A dedicated Dataiku instance with admin rights (you can rely on the [community Dataiku instance](<https://www.dataiku.com/product/get-started/>)).




Attention

We highly recommend a separate, dedicated instance for plugin development. That way, you can test and develop the plugin without affecting Dataiku projects or jeopardizing other users’ experience. Attentive readers should **read this introduction first** ([Foreword](<../foreword.html>)).

## Plugin creation

Although creating a plugin outside Dataiku is possible, we recommend not doing it this way. It would be best if you let Dataiku complete the first initialization. To do this, Go to the plugin page, click the **“ADD PLUGIN”** button, and choose the **“Write your own”** option, as shown in Fig. 1.

Figure 1: Plugin creation – first step.

This will create the correct directory structure and let you choose/create the code environment your plugin will use once you have chosen a valid name for your plugin. You can select any name you want, but we recommend following these rules:

  * The plugin names must be in lowercase; the UI enforces this.

  * The words must be separated by a -.

  * The word order must be valid in English.

  * The plugin name must not contain “plugin” or “custom”. As you are developing a plugin, it is evident that this is a plugin for custom actions.




Figure 2: Plugin creation screen.

## Plugin configuration

You will land on the screen shown in Fig. 2. If your plugin requires a specific code environment, click the **\+ Create a code environment** button. Adapt the `desc.json` file to your needs, and if you need particular packages, fill in the `requirements.txt` file, as shown in Fig. 3. Then, in the **Summary** panel, click the **Build new environment** button. n

Figure 3: Dedicated code environment creation for plugin development.

## Plugin documentation

Code 1: Default version of the `plugin.json` configuration file.
    
    
    {
        // Plugin identifiers are globally unique and only contain A-Za-z0-9_-
        "id": "dev-setup-demonstration",
    
        // It is highly recommended to use Semantic Versioning
        "version": "0.0.1",
    
        // Meta data for display purposes:
        "meta": {
            // label: name of the plugin as displayed, should be short
            "label": "Dev setup demonstration",
    
            // description: longer string to help end users understand what this plugin does
            "description": "",
    
            "author": "fdevin",
    
            // icon: must be one of the FontAwesome 3.2.1 icons, complete list here at https://fontawesome.com/v3.2.1/icons/
            "icon": "icon-puzzle-piece",
    
            // recipesCategory: optional, can be one of 'visual', 'code', 'genai' or 'other'
            // defines the category of the plugin in the right panel
            "recipesCategory": "",
    
            // List of tags for filtering the list of plugins
            "tags": [], //for example: ["Machine Learning", "NLP"]
    
            // URL where the user can learn more about the plugin
            "url": "",
    
            "licenseInfo": "Apache Software License"
        }
    }
    

The file `plugin.json`, shown in Code 1, is the configuration file for the plugin. You should not change the `"id"` field and use semantic versioning for the `"version"` field. The `"meta"` object is made of:

  * `"label"` is used when Dataiku displays the plugin’s name. As a plugin can contain many components, the label should not be specific to a particular function but on a global naming representing the plugin.

  * `"description"` is a longer text used by Dataiku when the UI has to display more information than only the plugin’s name.

  * `"author"` is the name of the plugin’s author.

  * `"icon"` is an icon representing your plugin.

  * `"recipesCategory"` defines the category of plugin recipe components in the right panel. Allowed values are `visual`, `code`, `genai` or `other`. If left empty recipes will simply appear in the “Plugin recipes” category.

  * `"tags"` is a list of tags that help filter when searching for a plugin.

  * `"url"` is a link to the plugin’s documentation.

  * `"licenseInfo"` is the license associated to your plugin.




For example, the Fig. 4 is obtained by using the Code 2.

Code 2: `plugin.json` configuration file.
    
    
    {
        "id": "dev-setup-demonstration",
        "version": "0.0.1",
        "meta": {
            "label": "Developer advocacy -- Plugin",
            "description": "This plugin aims to demonstrate how to set up a developer environment. It also shows some simple configuration possibilities.",
            "author": "Dataiku developer advocay team",
            "icon": "icon-lemon",
            "recipesCategory": "visual",
            "tags": ["Developer", "devadvocacy team", "tutorials", "Dev enviroment"], //for example: ["Machine Learning", "NLP"]
            "url": "http://developer.dataiku.com/",
            "licenseInfo": "Apache Software License"
        }
    }
    

Figure 4: Configuring the plugin.

---

## [tutorials/plugins/custom-tools/generality/index]

# Creating a custom tool  
  
This tutorial outlines the creation of a custom tool. By default, Dataiku provides some native generic tools that are usable in [Simple Visual Agents](<https://doc.dataiku.com/dss/latest/agents/visual-agents.html> "\(in Dataiku DSS v14\)") and in [Code Agents](<https://doc.dataiku.com/dss/latest/agents/code-agents.html> "\(in Dataiku DSS v14\)") As tools depend very much on a company’s business, Dataiku could not provide every tool that each company would need. Dataiku provides some general tools and a way to integrate specific tools. This integration is done by using a custom tool.

Custom tools are the way to tailor tools to your company’s business. This tutorial relies on the same use case shown in [Building and using an agent with Dataiku’s LLM Mesh and Langchain](<../../../genai/agents-and-tools/agent/index.html>) and [LLM Mesh agentic applications](<../../../genai/agents-and-tools/llm-agentic/index.html>). The use case involves retrieving customer information based on a provided ID and fetching additional data about the customer’s company utilizing an internet search. By the end of this tutorial, you will know how to create a custom tool and how to use it in a Visual agent.

## Prerequisites

You have followed the [Creating and configuring a plugin](<../../creation-configuration/index.html>) tutorial or already know how to develop a plugin.

  * Dataiku >= 13.4

  * Develop plugins permission

  * An SQL Dataset named `pro_customers_sql`. You can create this file by uploading this [`CSV file`](<../../../../_downloads/bebbdc65d2087c3bb5bc130dbea25663/pro_customers.csv>).




## Creating the plugin environment

To develop a custom tool, you must first create a plugin. Go to the main menu, click the **Plugins** menu, and select the **Write your own** from the **Add plugin** button. Then, choose a meaningful name, such as “toolbox.” Once the plugin is created, click the **Create a code environment** button and select Python as the default language. In the `requirements.txt` file (located in `toolbox/code-env/python/spec`), add the `duckduckgo_search` requirement. Once you have saved the modification, go to the **Summary** tabs to build the plugin code environment. The custom tool plugin will use this code environment when the tool is used.

Under the `toolbox` directory, create a folder named `python-agent-tools`. This directory is where you code custom tools.

Usually, creating a new component is done by clicking the **New component** button and by choosing the **Agent tool** component.

## Creating the first tool – Dataset Lookup

The first tool you will create is the dataset lookup tool. This tool is already provided by default in Dataiku, but for the sake of this tutorial, you will need to re-implement a new one. The default Dataiku tool is named **Look up a record in a dataset**. It is more configurable than the one you will create. However, understanding how to make a tool is the purpose of this tutorial. Once you know, you can adapt the tool to meet your needs.

**Dataset lookup tool** : used to execute SQL queries on the `pro_customers_sql` dataset to retrieve customer information (name, role, company), given a customer ID. Code 2 shows an implementation of this tool.

To create this tool, create a folder named `dataset-lookup` (for example) under the `python-agent-tools` directory. In this folder, create two files: `tool.json` and `tool.py`. The `tool.json` file contains the description of the custom tool, like any other component, and the `tool.py` contains the plugin’s code.

Code 1 shows a possible configuration of this tool, and Code 2 shows how to implement it.

Code 1: Dataset Lookup – `tool.json`
    
    
    {
        "id": "dataset-lookup",
        "meta": {
            "label": "Dataset Lookup",
            "description": "Provide a name, job title and company of a customer, given the customer's ID"
        },
        "params" : [
        ]
    }
    

Attention

The SQL query might be written differently depending on your SQL Engine.

Code 2: Dataset Lookup – `tool.py`
    
    
    from dataiku.llm.agent_tools import BaseAgentTool
    import logging
    import dataiku
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    
    class DatasetLookupTool(BaseAgentTool):
        def set_config (self, config, plugin_config):
            self.logger = logging.getLogger(__name__)
            self.config = config
            self.plugin_config = plugin_config
            
        def get_descriptor(self, tool):
            return {
                "description": """Provide a name, job title and company of a customer, given the customer's ID""",
                "inputSchema": {
                    "title": "Input for a customer id",
                    "type": "object",
                    "properties": {
                        "id": {
                            "type": "string",
                            "description": "The customer Id"
                        }
                    }
                }
    
            }
        
        def invoke(self, input, trace):
            self.logger.setLevel(logging.DEBUG)
            self.logger.debug(input)
    
            args = input["input"]
            customerId = args["id"]
            dataset = dataiku.Dataset("pro_customers_sql")
            table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
            executor = SQLExecutor2(dataset=dataset)
            cid = Constant(str(customerId))
            escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
            query_reader = executor.query_to_iter(
                f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
        
            for (name, job, company) in query_reader.iter_tuples():
                return {"output" : f"""The customer's name is "{name}", holding the position "{job}" at the company named "{company}"."""}
            return {"output" : f"No information can be found about the customer {customerId}"}
    
        def load_sample_query(self, tool):
            return {"id": "fdouetteau"}
    

Once the plugin is saved, you can find the new tool in Dataiku. To find your new tool, go to a project where you planned to use the tool, go to the **GenAI** menu, select **Agent Tools** , and then click the **New agent tool** button. Your tool is on the list, so you should be able to find a tool like the one shown in Figure 1. If your tool is not on the list, you may need to reload Dataiku to force Dataiku to reload the plugin. The title and the description come from the `label` and the `description` highlighted in Code 1.

Fig. 1: Custom tool visible in the list.

At the top of the modal, select a meaningful name for this tool: **Get Customer Info** , choose your custom tool, and click the **Create** button. Your tool is ready for Dataiku to use. However, you should enter an additional description, as shown in Figure 2. For example, you could enter the following description: “Use this tool when you need to retrieve information about a customer ID. The expected output is the name, the job title, and the company.” This helps the LLM to understand in which circumstance this tool should be used.

Fig. 2: Creation of a tool.

If you want to see your tool in action, click the **Quick test** tab, provide the data you want to use, and click the **Run** button. If everything goes well, you should go to something similar to Figure 3. The `inputSchema`, emphasized in Code 2, is mandatory. Dataiku uses it to provide the correct input to the tool. You can find this `inputSchema` in the **Quick test** tab under the **Tool Schema** block, as shown in Figure 3.

Fig. 3: Testing a tool.

### Using the tool with code

After creating your custom tool, you can use it in any context where an LLM is applicable. To list all tools that have been defined in a project, you can use the [`list_agent_tools()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_agent_tools> "dataikuapi.dss.project.DSSProject.list_agent_tools").
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    project.list_agent_tools()
    

Running this code snippet will provide a list of all tools defined in the project. You should see your tool in this list:
    
    
    [{'id': 'REDaiQN',
        'type': 'Custom_agent_tool_toolbox_internet-search',
        'name': 'Get Company Info'},
    {'id': 'SOy7zKq',
        'type': 'Custom_agent_tool_toolbox_dataset-lookup',
        'name': 'Get Customer Info'}]
    

Once you know the tool’s ID, you can use it to call the tool, as shown in the code below:
    
    
    tool = project.get_agent_tool('SOy7zKq')
    tool.run({"id":"fdouetteau"})
    
    
    
    {'output': 'The customer's name is "Florian Douetteau", holding the position "CEO" at the company named "Dataiku".',
     'trace': {'type': 'span',
      'begin': '2025-05-20T13:26:07.797Z',
      'end': '2025-05-20T13:26:07.841Z',
      'duration': 44,
      'name': 'DKU_MANAGED_TOOL_CALL',
      'children': [{'type': 'span',
        'begin': '2025-05-20T13:26:07.802000Z',
        'end': '2025-05-20T13:26:07.839000Z',
        'duration': 37,
        'name': 'PYTHON_AGENT_TOOL_CALL',
        'children': [],
        'attributes': {},
        'inputs': {},
        'outputs': {}}],
      'attributes': {'toolProjectKey': 'PROGRAMMATICRAGWITHDATAIKUSLLMMESHANDLANGCHAIN',
       'toolId': 'SOy7zKq',
       'toolType': 'Custom_agent_tool_devadv-plugin'}},
     'sources': []}

## Wrapping up

Congratulations! You now know how to create a custom tool and declare it usable by Dataiku. You can now create a second tool (for searching over the internet) and follow the [Leveraging a custom tool in a Visual Agent](<../../../genai/agents-and-tools/visual-agent/index.html>) tutorial. Below, you will find a possible implementation of this tool.

### Creating the second tool – Internet search

The second tool you will create is also provided by Dataiku, which uses Google to search for information on the Internet. In this tutorial, you will make a “Get Company Info” tool that uses the DuckDuckGo search engine. The process to create the second tool is the same as the previous one.

Create a folder named `internet-search` (for example) under the `python-agent-tools`, and create also the two files: `tool.json` and `tool.py`. You will find a default implementation in codes 3 and 4, respectively.

Code 3: Internet Search – `tool.json`

Code 3: Internet Search – `tool.json`
    
    
    {
        "id": "internet-search",
        "meta": {
            "label": "Internet search",
            "description": "Provide general information about a company, given the company's name."
        },
        "params" : [
        ]
    }
    

Code 4: Internet Search – `tool.py`

Code 4: Internet Search – `tool.py`
    
    
    from dataiku.llm.agent_tools import BaseAgentTool
    import logging
    import dataiku
    from duckduckgo_search import DDGS
    
    class InternetSearchTool(BaseAgentTool):
        def set_config (self, config, plugin_config):
            self.logger = logging.getLogger(__name__)
            self.config = config
            self.plugin_config = plugin_config
            
        def get_descriptor(self, tool):
            return {
                "description": """Provide general information about a company, given the company's name.""",
                "inputSchema": {
                    "title": "Input for a company",
                    "type": "object",
                    "properties": {
                        "company": {
                            "type": "string",
                            "description": "The company you need info on"
                        }
                    }
                }
            }
        
        def invoke(self, input, trace):
            self.logger.info(input)
            
            args = input["input"]
            company_name = args["company"]
    
            with DDGS() as ddgs:
                results = list(ddgs.text(f"{company_name} (company)", max_results=1))
                if results:
                    return {"output" : f"Information found about {company_name}: {results[0]['body']}"}
                return {"output": f"No information found about {company_name}"}
    
        def load_sample_query(self, tool):
            return {"company": "Dataiku"}

---

## [tutorials/plugins/datasets/generality/index]

# Creating a plugin Dataset component

## Prerequisites

  * Dataiku >= 12.0

  * Access to a dataiku instance with the “Develop plugins” permissions

  * Access to an existing project with the following permissions:
    
    * “Read project content.”

    * “Write project content.”

  * Access to an existing plugin




It would be best to have:

  * A dedicated Dataiku instance with admin rights (you can rely on the [community Dataiku instance](<https://www.dataiku.com/product/get-started/>)).




Attention

We highly recommend a separate, dedicated instance for plugin development. That way, you can test and develop the plugin without affecting Dataiku projects or jeopardizing other users’ experience. Attentive readers should **read this introduction first** ([Foreword](<../../foreword.html>)).

## Introduction

Dataiku’s Plugin Dataset component provides users with a flexible approach to creating and integrating custom datasets into their data projects. It allows users to import and work with data from their specific sources, expanding the range of data and formats they can use in Dataiku. This enables users to integrate their unique data sources and leverage the full power of Dataiku for data preparation, analysis, and modeling.

The plugin Dataset component is particularly useful for working with specialized data sources, APIs, or data generation processes not supported natively in Dataiku. Users can write custom code to fetch data from APIs, databases, or other sources and apply any necessary transformations or preprocessing steps to suit their needs.

Creating custom datasets in Dataiku using the plugin Dataset component has several benefits:

  1. Users have complete control over the data fetching and transformation process, allowing them to customize it according to their requirements.

  2. Custom datasets can seamlessly integrate with other features in Dataiku, such as recipes, visualizations, and models. This allows users to leverage the custom datasets in data pipelines, workflows, and machine learning projects.

  3. Custom datasets can be reused across multiple projects within Dataiku, saving time and effort by eliminating the need to recreate the same data fetching and transformation logic for each project.




Finally, the plugin Dataset component provides:

  * An extensible framework for adding new data sources or formats to Dataiku.

  * Allowing users to contribute or share their plugins with the Dataiku community.

  * Expanding the platform’s capabilities.




Overall, the plugin Dataset component empowers users to work with diverse and unique data sources, customize data processing workflows, and seamlessly integrate custom datasets into their data projects in Dataiku.

## Dataset component creation

To create a plugin Dataset component, go to the plugin editor, click the **\+ New component** button (Fig. 1), and choose the Dataset component (Fig. 2). If you do not already have a plugin created, you can follow this tutorial ([Creating and configuring a plugin](<../../creation-configuration/index.html>)).

Figure 1: New component

Figure 2: New macro component

This will create a subfolder named `python-connectors` in your plugin directory. Within this subfolder, a subfolder with the name of your dataset will be created. You will find two files in this subfolder: `connector.json` and `connector.py`. The `connector.json` file configures your dataset, while the `connector.py` file is used for processing.

## Dataset default configuration

Code 1 shows the default configuration file generated by Dataiku. The file includes standard objects like `"meta"`, `"params"`, and `"permissions"`, which are expected for all components. For more information about these generic objects, please refer to [Plugin Components](<https://doc.dataiku.com/dss/latest/plugins/reference/plugins-components.html> "\(in Dataiku DSS v14\)").

Code 1: Generated dataset configuration
    
    
    /* This file is the descriptor for the Custom python dataset devadvocacy_dataset-simple-example */
    {
      "meta": {
        // label: name of the dataset type as displayed, should be short
        "label": "Custom dataset devadvocacy_dataset-simple-example",
        // description: longer string to help end users understand what this dataset type is
        "description": "",
        // icon: must be one of the FontAwesome 3.2.1 icons, complete list here at https://fontawesome.com/v3.2.1/icons/
        "icon": "icon-puzzle-piece"
      },
      /* Can this connector read data ? */
      "readable": true,
      /* Can this connector write data ? */
      "writable": false,
      /* params:
      Dataiku will generate a formular from this list of requested parameters.
      Your component code can then access the value provided by users using the "name" field of each parameter.
    
      Available parameter types include:
      STRING, INT, DOUBLE, BOOLEAN, DATE, SELECT, TEXTAREA, PRESET and others.
    
      For the full list and for more details, see the documentation: https://doc.dataiku.com/dss/latest/plugins/reference/params.html
      */
      "params": [
        {
          "name": "parameter1",
          "label": "User-readable name",
          "type": "STRING",
          "description": "Some documentation for parameter1",
          "mandatory": true
        },
        {
          "name": "parameter2",
          "type": "INT",
          "defaultValue": 42
          /* Note that standard json parsing will return it as a double in Python (instead of an int), so you need to write
             int(self.config()['parameter2'])
          */
        },
        /* A "SELECT" parameter is a multi-choice selector. Choices are specified using the selectChoice field*/
        {
          "name": "parameter8",
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
        }
      ]
    }
    

## Dataset default code

Code 2 shows the default code generated by Dataiku. This code is spread into two classes: `MyConnector` and `CustomDatasetWriter`. You only have to define the last one if you plan to save data in your custom format (then you should also set `"writable"` to `true` in the configuration file).

Code 2: Generated dataset code
    
    
    # This file is the actual code for the custom Python dataset devadvocacy_dataset-simple-example
    
    # import the base class for the custom dataset
    from six.moves import xrange
    from dataiku.connector import Connector
    
    """
    A custom Python dataset is a subclass of Connector.
    
    The parameters it expects and some flags to control its handling by Dataiku are
    specified in the connector.json file.
    
    Note: the name of the class itself is not relevant.
    """
    class MyConnector(Connector):
    
        def __init__(self, config, plugin_config):
            """
            The configuration parameters set up by the user in the settings tab of the
            dataset are passed as a json object 'config' to the constructor.
            The static configuration parameters set up by the developer in the optional
            file settings.json at the root of the plugin directory are passed as a json
            object 'plugin_config' to the constructor
            """
            Connector.__init__(self, config, plugin_config)  # pass the parameters to the base class
    
            # perform some more initialization
            self.theparam1 = self.config.get("parameter1", "defaultValue")
    
        def get_read_schema(self):
            """
            Returns the schema that this connector generates when returning rows.
    
            The returned schema may be None if the schema is not known in advance.
            In that case, the dataset schema will be infered from the first rows.
    
            If you do provide a schema here, all columns defined in the schema
            will always be present in the output (with None value),
            even if you don't provide a value in generate_rows
    
            The schema must be a dict, with a single key: "columns", containing an array of
            {'name':name, 'type' : type}.
    
            Example:
                return {"columns" : [ {"name": "col1", "type" : "string"}, {"name" :"col2", "type" : "float"}]}
    
            Supported types are: string, int, bigint, float, double, date, boolean
            """
    
            # In this example, we don't specify a schema here, so Dataiku will infer the schema
            # from the columns actually returned by the generate_rows method
            return None
    
        def generate_rows(self, dataset_schema=None, dataset_partitioning=None,
                                partition_id=None, records_limit = -1):
            """
            The main reading method.
    
            Returns a generator over the rows of the dataset (or partition)
            Each yielded row must be a dictionary, indexed by column name.
    
            The dataset schema and partitioning are given for information purpose.
            """
            for i in xrange(1,10):
                yield { "first_col" : str(i), "my_string" : "Yes" }
    
    
        def get_writer(self, dataset_schema=None, dataset_partitioning=None,
                             partition_id=None):
            """
            Returns a writer object to write in the dataset (or in a partition).
    
            The dataset_schema given here will match the the rows given to the writer below.
    
            Note: the writer is responsible for clearing the partition, if relevant.
            """
            raise NotImplementedError
    
    
        def get_partitioning(self):
            """
            Return the partitioning schema that the connector defines.
            """
            raise NotImplementedError
    
    
        def list_partitions(self, partitioning):
            """Return the list of partitions for the partitioning scheme
            passed as parameter"""
            return []
    
    
        def partition_exists(self, partitioning, partition_id):
            """Return whether the partition passed as parameter exists
    
            Implementation is only required if the corresponding flag is set to True
            in the connector definition
            """
            raise NotImplementedError
    
    
        def get_records_count(self, partitioning=None, partition_id=None):
            """
            Returns the count of records for the dataset (or a partition).
    
            Implementation is only required if the corresponding flag is set to True
            in the connector definition
            """
            raise NotImplementedError
    
    
    class CustomDatasetWriter(object):
        def __init__(self):
            pass
    
        def write_row(self, row):
            """
            Row is a tuple with N + 1 elements matching the schema passed to get_writer.
            The last element is a dict of columns not found in the schema
            """
            raise NotImplementedError
    
        def close(self):
            pass
    

The `MyConnector` class is designed to help you to get started quickly. In the comments of this class, you will find the description of all functions.

## Example of processing

As a straightforward example, you will create a Dataiku’s Plugin Dataset component to generate random data. To generate random data, you need:

  * The size of the dataset you want to create.

  * The name of the columns you want to create.

  * For each column, the data type of this column.




Considering this, you will have a configuration equivalent to Code 3.

Code 3: Configuration for generating random data
    
    
    {
      "meta": {
        "label": "Generate random data",
        "description": "Generate random data",
        "icon": "icon-puzzle-piece"
      },
      "readable": true,
      "writable": false,
      "params": [
        {
          "name": "size",
          "label": "Number of records",
          "type": "INT",
          "description": "",
          "minInt": 1,
          "maxInt": 10000,
          "defaultValue": 10,
          "mandatory": true
        },
        {
          "name": "columns",
          "label": "Column names",
          "type": "STRINGS",
          "description": "List of columns that will be generated",
          "mandatory": true
        },
        {
          "name": "column_types",
          "label": "Column types",
          "type": "STRINGS",
          "description": "Type of the columns (in the same order). Only String, number, boolean are possible. Default type: string.",
          "mandatory": false
        }
      ]
    }
    

Once you know which columns you need to create, the code for generating data is simple, with their associated types. The highlighted lines in Code 4 show how to fill in the required types if the user doesn’t provide enough information.

The `generate_random_data` in Code 4 should have been put into a library, but for the simplicity of this tutorial, it has been placed at the beginning of the file.

Code 4: Code
    
    
    import string
    
    from dataiku.connector import Connector
    import random
    
    
    def generate_random_data(param):
        if param == "string":
            chars = string.ascii_letters + string.digits
            return ''.join(random.choice(chars) for i in range(random.randrange(1, 100)))
        if param == "number":
            return random.randrange(0, 100)
        if param == "boolean":
            return random.choice([True, False])
    
    
    class MyConnector(Connector):
        """
        Generate random data
        """
    
        def __init__(self, config, plugin_config):
            """
            Initializes the dataset
            Args:
                config:
                plugin_config:
            """
            Connector.__init__(self, config, plugin_config)  # pass the parameters to the base class
    
            # perform some more initialization
            self.size = self.config.get("size", 100)
            self.columns = self.config.get("columns", ["first_col", "my_string"])
            self.types = [col.lower() for col in self.config.get("column_types", ["string", "string"])]
    
            # If we do not have enough types for the specified columns, complete with "string"
            len_col = len(self.columns)
            len_types = len(self.types)
            if (len_types < len_col):
                self.types.extend(["string"] * (len_col - len_types))
    
        def get_read_schema(self):
            """
            Returns the schema that this dataset generates when returning rows.
            """
    
            types = [{"name": val[0], "type": val[1]} for val in zip(self.columns, self.types)]
            return {"columns": types}
    
        def generate_rows(self, dataset_schema=None, dataset_partitioning=None,
                          partition_id=None, records_limit=-1):
            """
            The main reading method.
    
            Returns a generator over the rows of the dataset (or partition)
            Each yielded row must be a dictionary, indexed by column name.
    
            The dataset schema and partitioning are given for information purpose.
            """
            for i in range(0, self.size):
                data = {}
                for j in zip(self.columns, self.types):
                    data[j[0]] = generate_random_data(j[1])
                yield data
    

## Wrapping up

Congratulations on finishing this tutorial! You now know how to create a Dataiku’s Plugin Dataset component. You can generate a dataset from an external API if you want to go further.

Here are the complete versions of the code presented in this tutorial:

connector.json
    
    
    {
      "meta": {
        "label": "Generate random data",
        "description": "Generate random data",
        "icon": "icon-puzzle-piece"
      },
      "readable": true,
      "writable": false,
      "params": [
        {
          "name": "size",
          "label": "Number of records",
          "type": "INT",
          "description": "",
          "minInt": 1,
          "maxInt": 10000,
          "defaultValue": 10,
          "mandatory": true
        },
        {
          "name": "columns",
          "label": "Column names",
          "type": "STRINGS",
          "description": "List of columns that will be generated",
          "mandatory": true
        },
        {
          "name": "column_types",
          "label": "Column types",
          "type": "STRINGS",
          "description": "Type of the columns (in the same order). Only String, number, boolean are possible. Default type: string.",
          "mandatory": false
        }
      ]
    }
    

connector.py
    
    
    import string
    
    from dataiku.connector import Connector
    import random
    
    
    def generate_random_data(param):
        if param == "string":
            chars = string.ascii_letters + string.digits
            return ''.join(random.choice(chars) for i in range(random.randrange(1, 100)))
        if param == "number":
            return random.randrange(0, 100)
        if param == "boolean":
            return random.choice([True, False])
    
    
    class MyConnector(Connector):
        """
        Generate random data
        """
    
        def __init__(self, config, plugin_config):
            """
            Initializes the dataset
            Args:
                config:
                plugin_config:
            """
            Connector.__init__(self, config, plugin_config)  # pass the parameters to the base class
    
            # perform some more initialization
            self.size = self.config.get("size", 100)
            self.columns = self.config.get("columns", ["first_col", "my_string"])
            self.types = [col.lower() for col in self.config.get("column_types", ["string", "string"])]
    
            # If we do not have enough types for the specified columns, complete with "string"
            len_col = len(self.columns)
            len_types = len(self.types)
            if (len_types < len_col):
                self.types.extend(["string"] * (len_col - len_types))
    
        def get_read_schema(self):
            """
            Returns the schema that this dataset generates when returning rows.
            """
    
            types = [{"name": val[0], "type": val[1]} for val in zip(self.columns, self.types)]
            return {"columns": types}
    
        def generate_rows(self, dataset_schema=None, dataset_partitioning=None,
                          partition_id=None, records_limit=-1):
            """
            The main reading method.
    
            Returns a generator over the rows of the dataset (or partition)
            Each yielded row must be a dictionary, indexed by column name.
    
            The dataset schema and partitioning are given for information purpose.
            """
            for i in range(0, self.size):
                data = {}
                for j in zip(self.columns, self.types):
                    data[j[0]] = generate_random_data(j[1])
                yield data

---

## [tutorials/plugins/datasets/index]

# Datasets

This section contains several learning materials about the plugin component: Dataset

---

## [tutorials/plugins/file-format/ical-import/index]

# Writing a plugin File Format component to allow ICal import in Dataiku

## Prerequisites

  * Dataiku >= 11.0;

  * “Develop plugins” permission on the instance;

  * A Python code environment with the `ics` package installed (either in the plugin requirement or in the associated code env);

  * Some familiarity with the ICal format.




This tutorial was written with Python 3.9 and `ics==0.7.2`.

## Context

The ICal file format is a format that allows users to store (and exchange) scheduling events (and some other things). When we import an ICal file into Dataiku, it is detected as a CSV file. This results in creating a Dataset that does not represent the events in the file. As calendar events are likely dynamics, we do not import files but rather import Dataset via an API that provides the ICal events. This can be done by using the Dataset Plugin Component. However, we can upload a file containing events using this format.

To be able to import that kind of file, we need to create a File Format Plugin Component.

## Create a File Format Component Plugin

Important

As we rely on the `ics` python library, please ensure this library is included in the Plugin Code Environment. Please refer to [this documentation](<https://doc.dataiku.com/dss/latest/plugins/reference/other.html> "\(in Dataiku DSS v14\)") for more information about Plugin Code Environment.

For more information about File Format Plugin Component, please refer to [Component: File format](<https://doc.dataiku.com/dss/latest/plugins/reference/file-format.html> "\(in Dataiku DSS v14\)").

To create a File Format Plugin Component, we have to create it from the Plugin Component interface (for more information on Plugin development, please see [Developing plugins](<https://doc.dataiku.com/dss/latest/plugins/reference/index.html> "\(in Dataiku DSS v14\)")) and choose “new component” (Fig. 1).

Figure 1 : New component.

And then, choose the File Format Component (Fig. 2).

Figure 2: New File Format Component.

And fill out the form to create a File Format by choosing a good name for the File Format (here, `ical-importer`), as shown in Fig. 3.

Figure 3: Form for new File Format Component.

## File Format Configuration

### Description

The configuration of the File Format is done in the `format.json` file. Each component plugin begins with a `meta` section that contains the name of the component (`label`), the description of the component (`description`), and an icon to represent the component (`icon`). For this File Format, we could have written:

Code 1: File Format description.
    
    
    "meta": {
        "label": "ICal Importer",
        "description": "This File Format allows the user to import the events contained in an ICal file",
        "icon": "icon-calendar"
    },
    

Figure 4: File format description.

### Global Configuration

As File Format has specific options, we must specify them in the configuration file. For more information, please see [Component: File format](<https://doc.dataiku.com/dss/latest/plugins/reference/file-format.html> "\(in Dataiku DSS v14\)"). We will build a simple file format plugin to demonstrate how it works. The specific configuration will be as shown in Code 2

Code 2: File Format description.
    
    
    /* whether the format can be selectable as a dataset format */
    "canBeDatasetFormat": true,
    
    /* whether the format can be used to read files. If true, the get_format_extractor() must return an extractor */
    "canRead": true,
    
    /* whether the format can be used to write files. If true, the get_output_formatter() must return a formatter */
    "canWrite": true,
    
    /* whether the format can provide the schema without reading the data. If true, the FormatExtractor must implement read_schema() */
    "canExtractSchema": true,
    
    /* A mime type to use when exporting (if not set: the format is assumed to produce binary data) */
    "mime": {
        /* the mime-type sent to the browser */
        "mimeType": "text/plain",
        /* DSS creates file names by concatenating a unique identifier and this extension */
        "extension": ".ics"
    },
    
    /* to get additional options in the export dialogs, list them here */
    "exportOptions": [
        {
            "id": "option1",
            "label": "ICal export (*.ics)",
            "predefinedConfig": {
                "prodid": "-//Dataiku//Dataiku//EN"
            },
            "compression": "None"
        }
    ]
    

### Using the File Component Plugin

This File Format Component will have the ability to:

  * Read an ICal file (`"canRead": true`). This means that Dataiku can read an ICal file and create a dataset from this file when we upload a dataset (either by dropping it in the flow or by clicking the “+New Dataset” button and choosing the “Upload your files”), as shown in Fig. 5.

Figure 5: Upload files in Dataiku.

Then click the “Configure Format” button, and select the appropriate format, as shown in Fig. 6.

Figure 6: Choosing the file format.

  * To enable writing to an ICal file (“canWrite”: true), it’s important not to confuse it with exporting. Exporting is used for downloading a dataset in a specific format, while writing, in the context of Dataiku, refers to the ability to create an output dataset in a particular file format. We can edit the Dataset settings within the “Preview” tab to set the desired file format for writing.

  * Export a Dataset to ICal format. This feature is meant to be used with the option `"mime"` and `"exportOptions"`.




## Coding the File Format

### Analysis and inputs

ICal file format is pretty simple, and we don’t want to deal with many options, so our File Format Component only requires a few input and output parameters, except for the export feature. An ICal file contains a `PRODID` field that may be configured when exporting. So we will make this field configurable, with a default value.

### Configuration

The full `format.json` is shown in Code 3.

Code 3: `format.json`
    
    
    {
        "meta" : {
            "label": "ICal Format",
            "description": "Import Vcal/ICal into Dataiku",
            "icon": "icon-globe"
        },
        "canBeDatasetFormat": true,
        "canRead": true,
        "canWrite": true,
        "canExtractSchema": true,
        "mime" : {
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
    

### Main class

Now we have correctly defined and configured the File Format Component. We have to code the extractor (to extract the data from the file, aka input) and the output. The File Format Component code defines one main class, which defines the `output_formatter` (to be able to write a dataset in a specific format), and the `format_extractor` (for reading a file and creating a dataset), as shown in Code 4. This is the default code created by Dataiku. Like many Python classes, this code defines an `__init__` function. This is where we can process the File Format parameter if we have some. Then it defines two obvious functions.

Code 4: Main class of the File Format Component
    
    
    import os
    import logging
    import time
    
    import ics
    from ics import Calendar, Event
    
    import dataiku.base.block_link
    # import the base class for the custom format
    from dataiku.customformat import Formatter, OutputFormatter, FormatExtractor
    
    import json, base64, datetime
    
    
    class MyFormatter(Formatter):
    
        def __init__(self, config, plugin_config):
            """
            The configuration parameters set up by the user for the formatter instance
            are passed as a json object 'config' to the constructor.
            The static configuration parameters set up by the developer in the optional
            file settings.json at the root of the plugin directory are passed as a json
            object 'plugin_config' to the constructor
            """
            Formatter.__init__(self, config, plugin_config)  # pass the parameters to the base class
            self.prodid = config.get("prodid", "")
            if not(self.prodid):
                self.prodid = "-//Dataiku//Dataiku//EN"
    
        def get_output_formatter(self, stream, schema):
            """
            Return a OutputFormatter for this format
            :param stream: the stream to write the formatted data to
            :param schema: the schema of the rows that will be formatted (never None)
            """
            return MyOutputFormatter(stream, schema, self.prodid)
    
        def get_format_extractor(self, stream, schema=None):
            """
            Return a FormatExtractor for this format
            :param stream: the stream to read the formatted data from
            :param schema: the schema of the rows that will be extracted. None when the extractor is used to detect the format.
            """
            return MyFormatExtractor(stream, schema)
    

### Reading the input file

ICal file format is composed of one global object: `VCALENDAR`. It can contain more than one calendar object, but this is outside the scope of this plugin component. Inside the calendar object, we can find several components. Each one is defined similarly, with one line per property. As we do not want to write complex code, we will rely on the `ics` python library. Unfortunately, this library does not provide a way to read the input from a stream, and the File Format Component provides a stream as input. So we have to read the stream before processing the events. This is the purpose of the `__init__` function.

Each event has several properties, so we must define which property we want to extract. As a dataset has a fixed schema, we also need to define this fixed schema. We could let Dataiku infer the schema from the read data, but here we will provide a fixed schema (in the `read_schema` function).

Then, we need a function (`read_row`) to provide a new dataset row (one row, one event).

The whole process for reading an ICal file is shown in Code 5.

Code 5: The `format_extractor` class
    
    
    class MyFormatExtractor(FormatExtractor):
        """
        Reads a stream in a format to a stream of rows
        """
    
        def __init__(self, stream, schema):
            """
            Initialize the extractor
            :param stream: the stream to read the formatted data from
            """
            FormatExtractor.__init__(self, stream)
            cal = "\n".join([line.decode('utf-8') for line in stream.readlines()])
            self.calendar = ics.Calendar(cal)
            self.events = [self.event_to_dict(event) for event in list(self.calendar.events)]
            self.count_events = len(self.events)
            self.read = 0
    
        def read_schema(self):
            """
            Get the schema of the data in the stream, if the schema can be known upfront.
            """
            return [{"name": "Title", "type": "STRING"},
                    {"name": "Start", "type": "STRING"}]
    
        def event_to_dict(self, event: Event):
            """
            Transform an event into a dict
            :param event: the event to read
            :return: the dict containing the extracted information.
            """
            start = getattr(event, "begin", "")
            if start:
                start = event.begin.datetime.isoformat()
    
            return {
                "Title": getattr(event, "name", ""),
                "Start": start
            }
    
        def read_row(self):
            """
            Read one row from the formatted stream
            :returns: a dict of the data (name, value), or None if reading is finished
            """
            if self.read < self.count_events:
                event = self.events[self.read]
                self.read = self.read + 1
                return event
    
            return None
    

### Writing to a file

This is an optional feature of the File Format Component, and most of the time, we won’t need to write the `ouput_formatter` class.

Writing to an output file is both simple and challenging. Simple because we only have to produce a file with the same format as the input file. So in our case, we have to write a header with the correct definition of the calendar file. Then we need to produce a `VEVENT` object for each row of the dataset. And finally, write the footer, which is the closing tag for the calendar. This is quite simple.

The challenging part comes when you want to deal with a dataset where we do not know the order of the column’s schema. The output formatter always comes with the dataset’s schema, an array of dicts. Each dict represents a column, with the name and the type of the column. Then for each row, we have the data in the same order. So to make a robust output formatter, we have to analyze the schema and guess which field matches the data we want to write. This is especially true when we allow the File Format Plugin Component to export to ICal format, as the export should be as generic as possible or configurable to deal with many Dataset formats. This goes far beyond the scope of this tutorial. So we won’t deal with that.

As we want to let the user specifies its producer (for the `PRODID` field), we need to retrieve the value from the config and use it in the `OutputFormatter`. The first step of this retrieval has been done in Code 4.

Code 6 shows a straightforward implementation of this feature.

Code 6: The `output_formatter` class
    
    
    class MyOutputFormatter(OutputFormatter):
        """
        Writes a stream of rows to a stream in a format. The calls will be:
    
        * write_header()
        * write_row(row_1)
          ...
        * write_row(row_N)
        * write_footer()
    
        """
    
        # prodid parameter should be initialized in the MyFormatter class
        def __init__(self, stream, schema, prodid):
            """
            Initialize the formatter
            :param stream: the stream to write the formatted data to
            :param prodid: the value of the parameter PRODID
            """
            OutputFormatter.__init__(self, stream)
            self.schema = schema
            self.prodid = prodid
    
        def write_header(self):
            """
            Write the header of the format (if any)
            """
            self.stream.write(u"BEGIN:VCALENDAR\n".encode())
            self.stream.write(u"PRODID:{}\n".format(self.prodid).encode())
            self.stream.write(u"VERSION:2.0\n".encode())
            self.stream.write(u"CALSCALE:GREGORIAN\n".encode())
            self.stream.write(u"METHOD:PUBLISH\n".encode())
            self.stream.write(u"X-WR-CALNAME:Calendar Name\n".encode())
            self.stream.write(u"X-WR-TIMEZONE:Europe/Paris\n".encode())
    
        def write_row(self, row):
            """
            Write a row in the format
            :param row: array of strings, with one value per column in the schema
            """
            self.stream.write(u"BEGIN:VEVENT\n".encode())
            self.stream.write(u"SUMMARY:{}\n".format(row[0]).encode())
            self.stream.write(u"DTSTART:{}\n".format(row[1]).encode())
            self.stream.write(u"END:VEVENT\n".encode())
    
        def write_footer(self):
            """
            Write the footer of the format (if any)
            """
            self.stream.write(u"END:VCALENDAR\n".encode())
    

## Complete code of the plugin component

Code 7 shows the complete code of the plugin.

Code 7: Complete code
    
    
    import os
    import logging
    import time
    
    import ics
    from ics import Calendar, Event
    
    import dataiku.base.block_link
    # import the base class for the custom format
    from dataiku.customformat import Formatter, OutputFormatter, FormatExtractor
    
    import json, base64, datetime
    
    """
    A custom Python format is a subclass of Formatter, with the logic split into
    OutputFormatter for outputting to a format, and FormatExtractor for reading
    from a format
    
    The parameters it expects are specified in the format.json file.
    
    Note: the name of the class itself is not relevant.
    """
    
    
    class MyFormatter(Formatter):
    
        def __init__(self, config, plugin_config):
            """
            The configuration parameters set up by the user for the formatter instance
            are passed as a json object 'config' to the constructor.
            The static configuration parameters set up by the developer in the optional
            file settings.json at the root of the plugin directory are passed as a json
            object 'plugin_config' to the constructor
            """
            Formatter.__init__(self, config, plugin_config)  # pass the parameters to the base class
            self.prodid = config.get("prodid", "")
            if not(self.prodid):
                self.prodid = "-//Dataiku//Dataiku//EN"
    
        def get_output_formatter(self, stream, schema):
            """
            Return a OutputFormatter for this format
            :param stream: the stream to write the formatted data to
            :param schema: the schema of the rows that will be formatted (never None)
            """
            return MyOutputFormatter(stream, schema, self.prodid)
    
        def get_format_extractor(self, stream, schema=None):
            """
            Return a FormatExtractor for this format
            :param stream: the stream to read the formatted data from
            :param schema: the schema of the rows that will be extracted. None when the extractor is used to detect the format.
            """
            return MyFormatExtractor(stream, schema)
    
    
    class MyOutputFormatter(OutputFormatter):
        """
        Writes a stream of rows to a stream in a format. The calls will be:
    
        * write_header()
        * write_row(row_1)
          ...
        * write_row(row_N)
        * write_footer()
    
        """
    
        def __init__(self, stream, schema, prodid):
            """
            Initialize the formatter
            :param stream: the stream to write the formatted data to
            :param prodid: the value of the parameter PRODID
            """
            OutputFormatter.__init__(self, stream)
            self.schema = schema
            self.prodid = prodid
    
        def write_header(self):
            """
            Write the header of the format (if any)
            """
            self.stream.write(u"BEGIN:VCALENDAR\n".encode())
            self.stream.write(u"PRODID:{}\n".format(self.prodid).encode())
            self.stream.write(u"VERSION:2.0\n".encode())
            self.stream.write(u"CALSCALE:GREGORIAN\n".encode())
            self.stream.write(u"METHOD:PUBLISH\n".encode())
            self.stream.write(u"X-WR-CALNAME:Calendar Name\n".encode())
            self.stream.write(u"X-WR-TIMEZONE:Europe/Paris\n".encode())
    
        def write_row(self, row):
            """
            Write a row in the format
            :param row: array of strings, with one value per column in the schema
            """
            self.stream.write(u"BEGIN:VEVENT\n".encode())
            self.stream.write(u"SUMMARY:{}\n".format(row[0]).encode())
            self.stream.write(u"DTSTART:{}\n".format(row[1]).encode())
            self.stream.write(u"END:VEVENT\n".encode())
    
        def write_footer(self):
            """
            Write the footer of the format (if any)
            """
            self.stream.write(u"END:VCALENDAR\n".encode())
    
    
    class MyFormatExtractor(FormatExtractor):
        """
        Reads a stream in a format to a stream of rows
        """
    
        def __init__(self, stream, schema):
            """
            Initialize the extractor
            :param stream: the stream to read the formatted data from
            """
            FormatExtractor.__init__(self, stream)
            # self.columns = [c['name'] for c in schema['columns']] if schema is not None else None
    
            cal = "\n".join([line.decode('utf-8') for line in stream.readlines()])
            self.calendar = ics.Calendar(cal)
            self.events = [self.event_to_dict(event) for event in list(self.calendar.events)]
            self.count_events = len(self.events)
            self.read = 0
    
        def read_schema(self):
            """
            Get the schema of the data in the stream, if the schema can be known upfront.
            """
            return [{"name": "Title", "type": "STRING"},
                    {"name": "Start", "type": "STRING"}]
    
        def event_to_dict(self, event: Event):
            """
            Transform an event into a dict
            :param event: the event to read
            :return: the dict containing the extracted information.
            """
            start = getattr(event, "begin", "")
            if start:
                start = event.begin.datetime.isoformat()
    
            return {
                "Title": getattr(event, "name", ""),
                "Start": start
            }
    
        def read_row(self):
            """
            Read one row from the formatted stream
            :returns: a dict of the data (name, value), or None if reading is finished
            """
            if self.read < self.count_events:
                event = self.events[self.read]
                self.read = self.read + 1
                return event
    
            return None
    

### Testing the plugin

To test this plugin, we need to have the complete code written (either by copying/pasting Code 7 or following the tutorial).

And we need an ICS file, for example, the bank holidays of:

  * [USA](<https://www.officeholidays.com/ics-fed/usa>)

  * [France](<https://www.officeholidays.com/ics-local-name/france>)

  * any [other countries](<https://www.officeholidays.com/countries>)




Once we have an ICS file, we can upload it in Dataiku by following the steps described in Using the File Component Plugin.

We can also test the writing part of the tutorial by selecting the newly created dataset and choosing the “Export” action on the right panel. Then select “Ical export (*.ics)” as “Format” in the “Download” tab, as shown in Fig. 7.

Figure 7: Export a dataset as an ICal file.

## Conclusion

We have written a File Format Plugin Component, which lets users import a specific file format into Dataiku. We could have written a better parser for reading the file using the provided stream directly. But we want to focus on how to write this Plugin Component instead of how to parse a file.

This component also provides a way to write a Dataset in a specific file format. Again, this could have been improved, but we want to highlight how to do it in the simplest way. By the way, File Format Plugin Component does not require the developer to provide this feature.

If we want to import Datasets from an API, we should write a Dataset Plugin Component.

---

## [tutorials/plugins/file-format/index]

# File Format

This section contains several learning materials about the plugin component: File Format.

---

## [tutorials/plugins/foreword]

# Foreword

Developing a plugin can be a complex and time-consuming process. Creating a dedicated instance solely for plugin development is recommended to ensure that your plugin development is smooth and efficient. Doing so allows you to test and refine the plugin without affecting other instances, thus minimizing the risk of negative effects on other users.

When you develop a plugin on an instance, it becomes available to all users immediately. Moreover, having a separate environment for plugin development will enable you to prevent users from accessing an incomplete or in-progress plugin, which can help you avoid any confusion or frustration on their part. Any modifications made to the plugin will be immediately visible to all users on that instance.

In addition to these benefits, having a separate environment for plugin development provides the added advantage of allowing you to test new plugins and customizations without affecting the stability or uptime of your production environment. This means that you can ensure that the plugin works as intended without any unintended consequences or disruptions to your production environment.

In summary, creating a dedicated instance for plugin development is a best practice to help you avoid issues arising from incomplete or untested plugins. Following this practice, you can develop your plugins in a safe and stable environment and ensure they work seamlessly before deploying them to your production environment. We recommend setting up a dedicated instance, and you will find more best practices in [this tutorial](<setup-a-dev-env/index.html>).

## Plugin visibility

Since **Dataiku 14.2** , plugin visibility can be turned on on demand. To do so, go to the Plugins page, select the plugin you want, click on the Settings tab, and then select Permissions, as shown in Fig. 1.

Fig. 1: How to manage plugin visibility.

Note

This is a UI feature that only impacts the visibility of items. It does not prevent users from creating the component using the API.

As this is a UI feature, not all components are affected by this setting. Please refer to [the documentation](<https://doc.dataiku.com/dss/latest/plugins/permissions.html> "\(in Dataiku DSS v14\)") to see which components this setting impacts.

If you remove the **Default** permission, the plugin component will be visible only to you and the administrator. You can also add a group to which the plugin will be visible. Select a group in the dropdown and click the **Grant access to group** button to do so.

Warning

Although this feature can hide a component in development, we still recommend having a dedicated instance.

---

## [tutorials/plugins/git-versioning/generality/index]

# Git integration for plugins

This tutorial explains Dataiku’s Git integration for plugins. We’ll also see how to use Git repositories to share development plugins with others in the plugin development community.

## Git version control tasks available for plugins

Each plugin we create in the plugin editor is associated with a local Git repository, and every change that we make in the plugin editor (e.g., saving a file or adding a new component) is automatically committed to the Git repository.

Note

The Git integration for plugins is separate from the [Git integration for projects](<https://doc.dataiku.com/dss/latest/collaboration/version-control.html> "\(in Dataiku DSS v14\)"), and the [Git in project libraries](<https://doc.dataiku.com/dss/latest/collaboration/import-code-from-git.html> "\(in Dataiku DSS v14\)") should not be confused.

The Plugin-Git integration allows us to perform common version control tasks, such as:

  * Pushing and pulling changes from a remote repository.

  * Using branches.

  * Viewing a plugin’s history.

  * Reverting changes, etc.




We’ll explore some of these tasks.

### Connecting to a remote repository

Dataiku can connect to a remote repository securely by using SSH.

Note

Connecting Dataiku to a remote repository by SSH requires prior setup of SSH credentials. The [Working with remotes](<https://doc.dataiku.com/dss/latest/collaboration/git.html#ref-devguide-working-with-remotes> "\(in Dataiku DSS v14\)") article provides in-depth guidance on how to set up this connection.

To share a development plugin via a remote repository, we connect to the remote Git repository by adding its SSH URL to Dataiku through the “change tracking” indicator. Ideally, the remote repository should be empty, as using a separate repository for each plugin is good practice.

Once connected to the remote repository, we can push the plugin’s code from the `master` branch of the local git repository. In the remote repository, we’ll see that the `master` branch has been successfully pushed.

### Working with branches

Back in Dataiku, we can also create a development branch of the local `master` branch for more development work on the plugin.

By navigating to the **History** tab, we can see the changes made on a branch and revert changes as needed.

Once we’re satisfied with our changes, we can push any new updates back to the remote Git repository.

### Merging branches

Because the ability to merge branches is not directly available in Dataiku, we’ll have to go outside Dataiku (into a Git client such as GitHub) to merge the changes on the development branch into the `master` branch.

Upon returning to Dataiku, we can switch to the local `master` branch and pull in the changes from the remote `master` so that the merged changes are now available at the local `master` branch in Dataiku.

### Importing plugins from Git repositories

Furthermore, we can import plugins developed by others and stored in a remote Git repository into Dataiku for our use or further development.

For example, we can fetch the Geocoder plugin directly from its remote Git repository and clone this remote repository for use on our Dataiku instance.

We can also select the option to clone in “development mode” to make changes to the plugin locally and push our changes to the remote repository, provided that we have write privileges on the remote repository.

When working in development mode, we can also choose whether to clone the entire repository or clone a subfolder if the repository contains multiple plugins.

## Wrapping up

Congratulations! You have completed this tutorial and handled the git integration for plugins. You can now go further by creating your first plugin components like [datasets](<../../datasets/generality/index.html>) or [recipes](<../../recipes/generality/index.html>).

---

## [tutorials/plugins/git-versioning/index]

# Versioning for plugin

This section contains the learning material for plugin version management and the git integration for plugins.

---

## [tutorials/plugins/git-versioning/plugin-versioning/index]

# Plugin version management with Git

After developing a Dataiku plugin on your instance, you can manage versions of the plugin on a remote Git repository (e.g., GitHub). This allows you to share the plugin across multiple Dataiku instances and allow users on those other instances to contribute updates to the plugin.

In this tutorial, you will learn how to:

  * Version your plugins with development branches.

  * Track the history of development.

  * Connect to a remote Git repository.




## Prerequisites

  * Bases on Dataiku plugins.

  * Familiarity with the basics of [Git](<https://en.wikipedia.org/wiki/Git>)

  * Access to a remote Git repository where you can push changes. Ideally, it should be empty.

  * Access to a Dataiku instance [set up to work with that remote Git repository](<https://doc.dataiku.com/dss/latest/collaboration/git.html#working-with-remotes>).




## Connect to a remote Git repository

Open any plugin you want to connect to a remote Git repository to share the development of this plugin with other coders.

  1. Click on the change tracking indicator and select **Add a remote**.

  2. Enter the URL of the remote and click **OK**.

  3. If the `master` branch on the remote Git repo has any commits ahead of the local `master` branch, **Pull** those changes. This will be necessary if the repo you’re connecting to is not empty.

  4. From the change tracking indicator, select **Push**.




In your remote Git repo, you can see that the `master` branch has been successfully pushed.

Note

We recommend using a separate repository for each plugin.

## Git versioning

Now, we’d like to work on changes to the plugin using a development branch so that others can continue using the original plugin.

  1. From the branch indicator, click **Create new branch**.

  2. Name the new branch `release/1.0` and click **Create**.

Note

Just like in the usual git workflow, this creates a new development branch of the plugin from the `master` branch.

  3. Click on the **History** tab to see your changes on this branch. If you switch to the `master` branch, you’ll see that the history only includes the plugin’s original development and none of the changes we’ve made to the branch.

  4. Now you can switch back to the `release/1.0` branch and **Push** the changes.

Note

The `release/1.0` branch has been pushed to your remote Git repo. Merging the changes with the `master` branch is done outside of Dataiku.

  5. To see the merges reflected in Dataiku, first **Fetch** the changes from the remote Git repo and then **Pull** the changes to your local Git.




### Wrapping up

You have completed this tutorial and connected your plugin to a remote repository. You can now produce robust and efficient plugins like [recipes](<../../recipes/generality/index.html>) or [macros](<../../macros/generality/index.html>) while collaborating through versioning.

---

## [tutorials/plugins/guardrail/generality/index]

# Creating a custom guardrail

When using an agent, your company may want to control the LLM. There are various ways to do this. Custom guardrails are plugin components that allow the user to control the LLM. Custom Guardrails can, for example:

  * Rewrite the query before submitting it to the LLM.

  * Rewrite the response after having an answer from the LLM.

  * Ask an LLM to retry or rewrite its answer by providing additional context/instructions.

  * Add information into the trace of the LLM or in the audit log.

  * Act on a query to take action before calling the LLM.




This tutorial presents a simple use case for implementing a custom guardrail but explains how to implement other use cases.

## Prerequisite

  * Dataiku >= 13.4 (13.4.4 if you want to create your guardrail visually)

  * develop plugin permission

  * A connection to an LLM, preferably an OpenAi connection

  * Python >= 3.9




## Introduction

A custom guardrail is a plugin component that provides additional capability to an LLM. Depending on the context, there are four main ways to act, each configurable separately. In this tutorial, you will learn how to create a custom guardrail, configure it to tailor it to fit your needs and code the behavior.

To develop a Custom Guardrail, you must first create a plugin (or use an existing one). Go to the main menu, click the **Plugins** menu, and select the **Write your own** from the **Add plugin** button. Then, choose a meaningful name, such as `toolbox`. Once the plugin is created, click the **Create a code environment** button and select Python as the default language. Once you have saved the modification, go to the **Summary** tabs to build the plugin code environment. The custom guardrail will use this code environment when it is used.

Click the **\+ New component** button, and choose the **LLM Guardrail** component in the provided list, as shown in Figure 1. Then, complete the form by choosing a meaningful **Identifier** and clicking the **Add** button.

Figure 1: New Guardrail component.

Alternatively, you can select the **Edit** tab and, under the `toolbox` directory, create a folder named `python-guardrails`. This directory is where you will find and create your custom guardrail. Under this directory, create a directory with a meaningful name representing your Guardrail component.

## Creating the Guardrail

A Guardrail is created by creating two files: `guardrail.py` and `guardrail.json`. The JSON file contains the configuration file, and the Python file is where you will code the behavior of the Guardrail.

### Configuring the LLM Guardrail

Code 1 shows the global shape of the configuration file; highlighted lines are specific to the Guardrail component.

Code 1: default configuration file – `guardrail.json`
    
    
    /* This file is the descriptor for custom guardrail devadv-tutorial */
    {
      "meta": {
        "label": "Custom guardrail tutorial",
        "description": "This is the description of the custom guardrail devadv-tutorial"
      },
      // Whether this guardrail can operate on LLM queries
      "operatesOnQueries": true,
      // Whether this guardrail can operate on LLM responses
      "operatesOnResponses": true,
      // Whether this guardrail can retry processing of responses after a failure
      "mayRequestRetryOnResponses": false,
      // Whether this guardrail can reply directly to queries, skipping the rest of the guardrail pipeline
      "mayRespondDirectlyToQueries": false,
      /* params:
      Dataiku will generate a form from this list of requested parameters.
      Your component code can then access the value provided by users using the "name" field of each parameter.
    
      Available parameter types include:
      STRING, INT, DOUBLE, BOOLEAN, DATE, SELECT, TEXTAREA, PRESET and others.
    
      For the full list and for more details, see the documentation: https://doc.dataiku.com/dss/latest/plugins/reference/params.html
    
      Below is an example of a parameter field to allow choosing an LLM used to judge responses
      */
      "params": [
      ]
    }
    

All these four parameters are booleans.

Setting the `operatesOnQuery` parameter to `true` will trigger this guardrail on every input query before it is fed to the LLM.

Setting the `operatesOnResponses` parameter to `true` will trigger this guardrail on every response after the LLM inference happens.

Setting the `mayRespondDirectlyToQueries` parameter to `true` will indicate that the guardrail can respond directly to queries, skipping the rest of the pipeline.

Setting the `mayRequestRetryOnResponses` parameter to `true` will indicate that the guardrail can retry the processing of responses after a failure.

These parameters can also be configured via strings with two options `BasedOnParameterName` and `BasedOnParameterValue`. For example, you can set `operatesOnQueriesBasedOnParameterName` and `operatesOnQueriesBasedOnParameterValue`. Possible values for `operatesOnQueriesBasedOnParameterName` come from the `param` section.

In this tutorial, you will create a simple guardrail that can:

  * Add an instruction before calling the LLM.

  * Act on an LLM’s response and rewrite it before sending the response to the user.




Your guardrail will have two dedicated parameters: `instruction` for the first case, `LLM` for rewriting the response, and an `extraFormatting` parameter for the second use case. Code 2 shows the guardrail’s configuration.

Code 2: configuration file – `guardrail.json`
    
    
    /* This file is the descriptor for custom guardrail devadv-tutorial */
    {
      "meta": {
        "label": "Custom guardrail tutorial",
        "description": "This is the description of the custom guardrail devadv-tutorial"
      },
    
      // Whether this guardrail can operate on LLM queries
      "operatesOnQueriesBasedOnParameterName": "usesInstructions",
      "operatesOnQueriesBasedOnParameterValue": "true",
      // Whether this guardrail can operate on LLM responses
      "operatesOnResponsesBasedOnParameterName": "rewriteAnswer",
      "operatesOnResponsesBasedOnParameterValue": "true",
    
      // Whether this guardrail can retry processing of responses after a failure
      "mayRequestRetryOnResponses": false,
      // Whether this guardrail can reply directly to queries, skipping the rest of the guardrail pipeline
      "mayRespondDirectlyToQueries": false,
    
      "params": [
        {
          "name": "usesInstructions",
          "type": "BOOLEAN",
          "label": "Operate on queries",
          "defaultValue": "false"
        },
        {
          "name": "instructions",
          "type": "STRING",
          "label": "Instruction to add to each query",
          "defaultValue": "Please answer in one sentence.",
          "visibilityCondition": "model.usesInstructions"
        },
        {
          "name": "rewriteAnswer",
          "type": "BOOLEAN",
          "label": "Add extra formatting option to the answer",
          "defaultValue": "false"
        },
        {
          "name": "llm",
          "type": "LLM",
          "label": "LLM to use for rewriting",
          "visibilityCondition": "model.rewriteAnswer"
        },
        {
          "name": "extraFormatting",
          "type": "STRING",
          "label": "Additional instructions to format the answer",
          "visibilityCondition": "model.rewriteAnswer"
        }
      ]
    }
    

### Coding the Guardrail

To code a guardrail, you must create a class derived from the `BaseGuardRail` class. In this new class, the only mandatory function is `process`. This is where you will code your guardrail. You can access the plugin’s configuration by creating the `set_config` function. Code 3 shows how to deal with these configuration parameters.

Code 3: Processing the configuration – `guardrail.py`
    
    
        def set_config(self, config, plugin_config):
            self.usesInstructions = config.get('usesInstructions')
            self.instructions = config.get('instructions', '')
            self.rewriteAnswer = config.get('rewriteAnswer')
            self.llm = config.get('llm', 'openai:toto:gpt-4o-mini')
            self.extraFormatting = config.get('extraFormatting', '')
    

Code 4 shows a way to implement a guardrail, considering the configuration. Suppose you want to reduce the cost of an agent; you can activate the **operatesOnQueries** parameter and add “Please answer in one sentence” to each query sent to the LLM, as shown in Figure 2.

Code 4: Guardrail code – `guardrail.py`
    
    
    # This file contains the implementation of the custom guardrail devadv-tutorial
    import logging
    import dataiku
    from dataiku.llm.guardrails import BaseGuardrail
    
    
    class CustomGuardrail(BaseGuardrail):
        def set_config(self, config, plugin_config):
            self.usesInstructions = config.get('usesInstructions')
            self.instructions = config.get('instructions', '')
            self.rewriteAnswer = config.get('rewriteAnswer')
            self.llm = config.get('llm', 'openai:toto:gpt-4o-mini')
            self.extraFormatting = config.get('extraFormatting', '')
    
        def process(self, input, trace):
            logging.info("[------ GUARDRAIL PLUGIN -------------]")
    
            if self.rewriteAnswer and ("completionResponse" in input):
                logging.info("[-------- PLUGIN GUARDRAIL --------]: --> %s" % input["completionResponse"]["text"])
                with trace.subspan("Devadvocate Guardrail Plugin") as sub:
                    logging.info("[-------- PLUGIN GUARDRAIL -------- SUB --------]")
                    llm = dataiku.api_client().get_default_project().get_llm(self.llm)
                    resp = llm.new_completion().with_message("This is the answer: %s --- %s" % (
                        input["completionResponse"]["text"], self.extraFormatting)).execute()
                    sub.append_trace(resp.trace)
                    if resp.success:
                        input["completionResponse"]["text"] = resp.text
            elif self.usesInstructions and ("completionQuery" in input):
                # do any processing and decide on an action here
                question = input["completionQuery"]["messages"]
                question[0]["content"] = "%s %s" % (question[0]["content"], self.instructions)
                input["completionQuery"]["messages"] = question
            return input
    

Figure 2: Option for changing the initial query.

Suppose you want to ensure that your agent will respond using a JSON format; you can configure it, as shown in Figure 3.

Figure 3: Option for formatting the answer.

If you want to see your guardrail in action, you can create a code agent (or a visual one if you prefer) with the code provided in Code 5. Then, add your guardrail in your agent’s **Settings** tab. Using the **Quick test** tab, you will see your guardrail modifying the query and the answer according to your settings.

[`code-agent.py`](<../../../../_downloads/c31e90ab7689d6247f395ed53878f7ad/code-agent.py>)

Code 5: Code agent
    
    
    import dataiku
    from dataiku.llm.python import BaseLLM
    from dataikuapi.dss.llm import DSSLLMStreamedCompletionChunk, DSSLLMStreamedCompletionFooter
    
    OPENAI_CONNECTION_NAME = "toto"
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process_stream(self, query, settings, trace):
            prompt = query["messages"][0]["content"]
    
            llm = dataiku.api_client().get_default_project().get_llm(f"openai:{OPENAI_CONNECTION_NAME}:gpt-4o-mini")
            completion = llm.new_completion().with_message("You are an helpful assitant.", "system") \
                .with_message(prompt)
            completion.settings.update(settings)
    
            for chunk in completion.execute_streamed():
                if isinstance(chunk, DSSLLMStreamedCompletionChunk):
                    yield {"chunk": {"text": chunk.text}}
                elif isinstance(chunk, DSSLLMStreamedCompletionFooter):
                    yield {"footer": chunk.data}
    
        def process(self, query, settings, trace):
            prompt = query["messages"][0]["content"]
    
            resp_text = prompt
    
            llm = dataiku.api_client().get_default_project().get_llm(f"openai:{OPENAI_CONNECTION_NAME}:gpt-4o-mini")
            completion = llm.new_completion().with_message("You are an helpful assitant.", "system") \
                .with_message(prompt)
            completion.settings.update(settings)
            llm_resp = completion.execute()
    
            resp_text = llm_resp.text
            return {"text": resp_text}
    

## Conclusion

Congratulations on finishing the tutorial on creating a custom guardrail in Dataiku. Creating a custom guardrail for a language model (LLM) greatly improves your ability to customize and refine responses based on your unique needs. Start by applying these specific guardrails to enhance your interactions with the LLM. This method ensures your queries remain precise and accurate, leading to responses that meet your expectations. The various configuration options allow for flexibility across different applications, enabling you to instruct the LLM to be brief or to follow particular formatting rules.

Here is the complete code of this tutorial:

[`guardrail.json`](<../../../../_downloads/b9388040ed596084b9a54f986ea39d74/guardrail.json>)
    
    
    /* This file is the descriptor for custom guardrail devadv-tutorial */
    {
      "meta": {
        "label": "Custom guardrail tutorial",
        "description": "This is the description of the custom guardrail devadv-tutorial"
      },
    
      // Whether this guardrail can operate on LLM queries
      "operatesOnQueriesBasedOnParameterName": "usesInstructions",
      "operatesOnQueriesBasedOnParameterValue": "true",
      // Whether this guardrail can operate on LLM responses
      "operatesOnResponsesBasedOnParameterName": "rewriteAnswer",
      "operatesOnResponsesBasedOnParameterValue": "true",
    
      // Whether this guardrail can retry processing of responses after a failure
      "mayRequestRetryOnResponses": false,
      // Whether this guardrail can reply directly to queries, skipping the rest of the guardrail pipeline
      "mayRespondDirectlyToQueries": false,
    
      "params": [
        {
          "name": "usesInstructions",
          "type": "BOOLEAN",
          "label": "Operate on queries",
          "defaultValue": "false"
        },
        {
          "name": "instructions",
          "type": "STRING",
          "label": "Instruction to add to each query",
          "defaultValue": "Please answer in one sentence.",
          "visibilityCondition": "model.usesInstructions"
        },
        {
          "name": "rewriteAnswer",
          "type": "BOOLEAN",
          "label": "Add extra formatting option to the answer",
          "defaultValue": "false"
        },
        {
          "name": "llm",
          "type": "LLM",
          "label": "LLM to use for rewriting",
          "visibilityCondition": "model.rewriteAnswer"
        },
        {
          "name": "extraFormatting",
          "type": "STRING",
          "label": "Additional instructions to format the answer",
          "visibilityCondition": "model.rewriteAnswer"
        }
      ]
    }
    

[`guardrail.py`](<../../../../_downloads/6a1df723c1345a92b0478805bdc264c2/guardrail.py>)
    
    
    # This file contains the implementation of the custom guardrail devadv-tutorial
    import logging
    import dataiku
    from dataiku.llm.guardrails import BaseGuardrail
    
    
    class CustomGuardrail(BaseGuardrail):
        def set_config(self, config, plugin_config):
            self.usesInstructions = config.get('usesInstructions')
            self.instructions = config.get('instructions', '')
            self.rewriteAnswer = config.get('rewriteAnswer')
            self.llm = config.get('llm', 'openai:toto:gpt-4o-mini')
            self.extraFormatting = config.get('extraFormatting', '')
    
        def process(self, input, trace):
            logging.info("[------ GUARDRAIL PLUGIN -------------]")
    
            if self.rewriteAnswer and ("completionResponse" in input):
                logging.info("[-------- PLUGIN GUARDRAIL --------]: --> %s" % input["completionResponse"]["text"])
                with trace.subspan("Devadvocate Guardrail Plugin") as sub:
                    logging.info("[-------- PLUGIN GUARDRAIL -------- SUB --------]")
                    llm = dataiku.api_client().get_default_project().get_llm(self.llm)
                    resp = llm.new_completion().with_message("This is the answer: %s --- %s" % (
                        input["completionResponse"]["text"], self.extraFormatting)).execute()
                    sub.append_trace(resp.trace)
                    if resp.success:
                        input["completionResponse"]["text"] = resp.text
            elif self.usesInstructions and ("completionQuery" in input):
                # do any processing and decide on an action here
                question = input["completionQuery"]["messages"]
                question[0]["content"] = "%s %s" % (question[0]["content"], self.instructions)
                input["completionQuery"]["messages"] = question
            return input

---

## [tutorials/plugins/index]

# Plugins development

This section contains several learning materials about plugin development.

**Introduction**

  * [Foreword](<foreword.html>)

  * [Creating and configuring a plugin](<creation-configuration/index.html>)

  * [Setting up a dedicated instance for developing plugins](<setup-a-dev-env/index.html>)

  * [Versioning for plugin](<git-versioning/index.html>)




**Datasets**

  * [Creating a plugin Dataset component](<datasets/generality/index.html>)




**File Format**

  * [Writing a plugin File Format component to allow ICal import in Dataiku](<file-format/ical-import/index.html>)




**Generative AI – LLM Mesh**

  * [Creating a custom tool](<custom-tools/generality/index.html>)

  * [Creating a custom agent](<agent/generality/index.html>)

  * [Creating a custom guardrail](<guardrail/generality/index.html>)




**Git and Versioning**

  * [Git integration for plugins](<git-versioning/generality/index.html>)

  * [Plugin version management with Git](<git-versioning/plugin-versioning/index.html>)




**Macros**

  * [Creating a plugin Macro component](<macros/generality/index.html>)

  * [Writing a macro for project creation](<macros/project-creation/index.html>)

  * [Writing a macro for managing regression tests](<macros/test-regression-macro/index.html>)




**Prediction Algorithm**

  * [Creating a plugin Prediction Algorithm component](<prediction-algorithm/ml-algo/index.html>)




**Processor**

  * [Creating a plugin Processor component](<processor/generality/index.html>)




**Project standards**

  * [Project Standards Check component](<project-standards/index.html>)




**Recipes**

  * [Creating a plugin Recipe component](<recipes/generality/index.html>)

  * [Writing a custom recipe to remove outliers from a dataset](<recipes/recipes-clipping-dataset/index.html>)




**Sample dataset**

  * [Creating a sample dataset](<sample-dataset/generality/index.html>)




**Webapps**

  * [Turning an existing webapp into a webapp plugin component](<webapps/generality/index.html>)

---

## [tutorials/plugins/llm-connection/generality/index]

# Creating a custom LLM Connection

This tutorial provides a step-by-step guide for creating a **custom LLM connection** in Dataiku. It details the process of setting up a plugin, configuring a parameter set to handle API keys securely, and coding the behavior of the LLM connection. Finally, users learn how to enable and test the connection within the Dataiku environment to ensure proper functionality.

## Prerequisites

  * Dataiku 14.1

  * **Develop plugin** permission

  * Python 3.9




## Introduction

Sometimes, you must use a custom/self-hosted/pre-configured LLM for your project. Dataiku offers many LLM connections, but some may want their personalized LLM Connection. Some configurations can be done in the connection setting, but if you need a specific configuration that is not present in Dataiku, you must use the plugin’s component: LLM Connection. In this tutorial, you will learn how to create a new LLM Connection. This connection will rely on the Python OpenAI SDK. Attentive users may use this tutorial to set up any new connection without too much trouble by relying on an SDK.

To create an LLM Connection, you must first create a plugin (or use an existing one). Go to the main menu, click the **Plugins** menu, and select the **Write your own** from the **Add plugin** button. Then choose a meaningful name, such as `tutorial-llm-connection`. Once the plugin is created, click the **Create a code environment** button and select Python as the default language. If you need specific packages, you should add them in the `requirements.txt` file, located in the `code-env/python/spec` of your plugin.

For this tutorial, you will need the `openai` package. Add it to `requirements.txt`, click the **Save all** button, return to the **Summary** tab, select the container you want to use (or select **All containers**), and click the **Build new environment** button.

Click the **Create your first component** button, and choose the **Custom Python LLM** in the provided list, as shown in Fig. 1. Then, complete the form by giving it a meaningful name, like `custom-chat-plugin`, and selecting the **Text completion** as a starter code.

Figure 1 – New LLM connection component.

Alternatively, you can select the **Edit** tab and, under the `tutorial-llm-connection` directory, create a folder named `python-llms`. This directory is where you will find and create your custom LLM connection. Under this directory, create a directory with a meaningful name (`custom-chat-plugin`, for this tutorial) representing your LLM connection component.

## Creating the Connection

A LLM connection is created by creating two files: `llm.json` and `llm.py`. The JSON file is the configuration file, and the Python file is where you will code the behavior of your LLM connection.

### Configuring the LLM Connection

There is nothing specific to the LLM connection’s configuration. However, as using an LLM may require a personal API key, you might need to configure your plugin to ask for one. You could ask the user for their API key when creating the connection, but if you choose to do this, all users using the connection will also use the API key of the connection’s creator.

Hopefully, Dataiku provides a mechanism to overcome this behavior: **Parameter set**. We highly recommend using a parameter set when sharing confidential information such as API Key, SSH key, …

#### Creating a Parameter set

To create a **Parameter set** , select the **Summary** tab, click the **New component** button, and choose the **Parameter set** from the provided list, as shown in Fig. 2. Then, complete the form by giving it a meaningful name, like `parameter-custom-llm`. Select `parameter-set.json` in the `parameter-sets/parameter-custom-llm` folder. Code 1 shows the configuration of the parameter set.

Figure 2 – New parameter set component.

Code 1 –Parameter set – configuration file
    
    
    {
        "meta" : {
            // label: name of the parameter set as displayed, should be short
            "label": "Parameter set devadv-parameter-custom-llm",
            // description: longer string to help end users understand what these parameter correspond to
            "description": "Long text to see where it is used",
            // icon: must be one of the FontAwesome 5.15.4 icons, complete list here at https://fontawesome.com/v5/docs/
            "icon": "fas fa-puzzle-piece"
        },
    
        /* if users are allowed to fill the values for an instance of this parameter
           set directly in the plugin component using it, as opposed to only be allowed
           to select already defined presets (default value, can be changed in plugin
           settings)
        */
        "defaultDefinableInline": true,
        /* if users are allowed to define presets at the project level in addition
           to the instance level (default value, can be changed in plugin settings) */
        "defaultDefinableAtProjectLevel": true,
    
        "pluginParams": [
        ],
    
        "params": [
            {
                "name": "param_set_api_key",
                "label": "OpenAI API Key",
                "type": "CREDENTIAL_REQUEST",
                "credentialRequestSettings": {
                    "type": "SINGLE_FIELD"
                },
                "description": "The OpenAI api key",
                "mandatory": true
    
            }
        ]
    }
    

Once you have configured your parameter set, you will need to add a new preset. Select the **Settings** tab, select the **Parameter set parameter-custom-llm** on the left panel, and click the **Add preset** button. Choose a name, `OpenAI`, for example, and click the **Create** button. You may want to fill out the form, but it is not mandatory.

As shown in Fig. 3, the user can enter their API key in the “Credentials” tab of their “Profile & Settings” page.

Figure 3 – Where to enter a credential for a parameter set.

#### Using the Parameter set

You can now use this parameter set in the LLM connection configuration file (`python-llms/custom-chat-plugin/llm.json`). Code 2 shows the configuration file’s global shape. The highlighted line shows how we connect the parameter set with the LLM connection.

Code 2 – LLM connection – configuration file
    
    
    /* This file is the descriptor for custom LLM custom-chat-plugin */
    {
      "meta" : {
        // label: name of the LLM as displayed, should be short
        "label": "Custom LLM custom-chat-plugin",
    
        // description: longer string to help end users understand what this LLM does.
        "description": "This is the description of the custom LLM custom-chat-plugin",
    
        // icon: must be one of the FontAwesome 5.15.4 icons, complete list here at https://fontawesome.com/v5/docs/
        "icon": "fas fa-magic"
      },
    
      "params": [
          {
            "name": "model",
            "label": "Model",
            "type": "STRING"
          },
          {
              "type": "PRESET",
              "name": "api_key",
              "label": "Which openai api key to use",
              "parameterSetId": "parameter-custom-llm"
          }
    
      ]
    }
    

### Coding the custom LLM Connection

Coding an LLM Connection follows the same principle as coding an agent.

See also

If you need help on coding an agent, you will find some explanations in the [Agent](<../../../../concepts-and-examples/agents.html#ce-agents-creating-your-code-agent>) section in Concepts and examples, or you can follow [this tutorial](<../../../genai/agents-and-tools/code-agent/index.html>).

To access the configuration entered by the user, you must define the `set_config` function, as shown in Code 3. The highlighted line shows how to retrieve a value from a parameter set. You first need to access the plugin’s parameter (`api_key` in our example), then retrieve the value from the parameter set (`param_set_api_key`).

Code 3 – Custom LLM connection – code
    
    
    # This file is the implementation of custom LLM custom-chat-plugin
    from dataiku.llm.python import BaseLLM
    from openai import OpenAI
    from dataiku.llm.python.types import CompletionSettings, SingleCompletionQuery, CompletionResponse
    from dataikuapi.dss.llm_tracing import SpanBuilder
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def set_config(self, config: dict, plugin_config: dict) -> None:
            self.config = config
            self.model = config.get("model", None)
            self.api_key = config.get('api_key').get('param_set_api_key')
            self.client = OpenAI(api_key=self.api_key)
    
        def process(self, query: SingleCompletionQuery, settings: CompletionSettings,
                    trace: SpanBuilder) -> CompletionResponse :
            messages = query["messages"]
    
            conversation = []
            for message in messages:
                role = message["role"]
                if "content" in message:
                    content = message["content"]
                    conversation.append({"role": role, "content": content})
                else:
                    parts = message.get("parts")
                    if parts:
                        content = []
                        for part in parts:
                            type = part['type']
                            if type == 'TEXT':
                                content.append({ "type": "text", "text": part["text"]})
                            elif type == 'IMAGE_INLINE':
                                image_url = f"data:image/jpeg;base64,{part['inlineImage']}"
                                content.append({ "type": "image_url", "image_url": image_url})
                            elif type == 'IMAGE_URI':
                                content.append({ "type": "image_url", "image_url": part["imageUrl"]})
                        conversation.append({"role": role, "content": content})
    
            response = self.client.responses.create(
                model=self.model,
                input=conversation
            )
    
            return {
                "text": response.output_text,
                "promptTokens": 46, # Optional
                "completionTokens": 10, # Optional
                "estimatedCost": 0.13, # Optional
                "toolCalls": [], # Optional
            }
    

### Enabling the custom LLM Connection

The next step is to create a new Dataiku connection. Go to the **Administration** panel, select the **Connections** tab, and click the **New connection** button. In the LLM Mesh section, you will find **Custom LLM** connection; click on it to create a new connection.

Figure 4 – Custom LLM connection in the connections menu.

Fill out the form by providing a valid connection name, selecting your plugin name, clicking the **Add model** button, and filling out the form as shown in Fig. 5.

Figure 5 – New connection form.

### Testing the connection

You can use the connection now that it has been created (and made available for everyone, except if you changed the security setting in the previous form). You can use Code 4 to test if everything is OK. The `LLM_ID` is built this way: `custom:<connection-name>:<model_id>`. If you need help retrieving a valid `LLM_ID`, you can use [this code sample](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>).

Code 4 – Testing the connection
    
    
    import dataiku
    
    LLM_ID = "" ## Fill with your LLM_ID
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID)
    completion = llm.new_completion()
    completion.with_message("How to code an agent in Dataiku?")
    resp = completion.execute()
    print(resp.text)
    

## Wrapping up

Congratulations on finishing the tutorial for creating a **custom LLM connection**. You now know how to create, configure, and use a **custom LLM connection**. Of course, your **LLM connection** can use a different provider; you just need to adapt the `process` function. It is also possible to process asynchronously, with or without a stream. You will find more information on this subject on this page: [Creating your code agent](<../../../../concepts-and-examples/agents.html#ce-agents-creating-your-code-agent>).

Here is the complete code of the **custom LLM Connection** (and the **parameter set**):

llm.json
    
    
    /* This file is the descriptor for custom LLM custom-chat-plugin */
    {
      "meta" : {
        // label: name of the LLM as displayed, should be short
        "label": "Custom LLM custom-chat-plugin",
    
        // description: longer string to help end users understand what this LLM does.
        "description": "This is the description of the custom LLM custom-chat-plugin",
    
        // icon: must be one of the FontAwesome 5.15.4 icons, complete list here at https://fontawesome.com/v5/docs/
        "icon": "fas fa-magic"
      },
    
      "params": [
          {
            "name": "model",
            "label": "Model",
            "type": "STRING"
          },
          {
              "type": "PRESET",
              "name": "api_key",
              "label": "Which openai api key to use",
              "parameterSetId": "parameter-custom-llm"
          }
    
      ]
    }
    

llm.py
    
    
    # This file is the implementation of custom LLM custom-chat-plugin
    from dataiku.llm.python import BaseLLM
    from openai import OpenAI
    from dataiku.llm.python.types import CompletionSettings, SingleCompletionQuery, CompletionResponse
    from dataikuapi.dss.llm_tracing import SpanBuilder
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def set_config(self, config: dict, plugin_config: dict) -> None:
            self.config = config
            self.model = config.get("model", None)
            self.api_key = config.get('api_key').get('param_set_api_key')
            self.client = OpenAI(api_key=self.api_key)
    
        def process(self, query: SingleCompletionQuery, settings: CompletionSettings,
                    trace: SpanBuilder) -> CompletionResponse :
            messages = query["messages"]
    
            conversation = []
            for message in messages:
                role = message["role"]
                if "content" in message:
                    content = message["content"]
                    conversation.append({"role": role, "content": content})
                else:
                    parts = message.get("parts")
                    if parts:
                        content = []
                        for part in parts:
                            type = part['type']
                            if type == 'TEXT':
                                content.append({ "type": "text", "text": part["text"]})
                            elif type == 'IMAGE_INLINE':
                                image_url = f"data:image/jpeg;base64,{part['inlineImage']}"
                                content.append({ "type": "image_url", "image_url": image_url})
                            elif type == 'IMAGE_URI':
                                content.append({ "type": "image_url", "image_url": part["imageUrl"]})
                        conversation.append({"role": role, "content": content})
    
            response = self.client.responses.create(
                model=self.model,
                input=conversation
            )
    
            return {
                "text": response.output_text,
                "promptTokens": 46, # Optional
                "completionTokens": 10, # Optional
                "estimatedCost": 0.13, # Optional
                "toolCalls": [], # Optional
            }
    

parameter-set.json
    
    
    {
        "meta" : {
            // label: name of the parameter set as displayed, should be short
            "label": "Parameter set devadv-parameter-custom-llm",
            // description: longer string to help end users understand what these parameter correspond to
            "description": "Long text to see where it is used",
            // icon: must be one of the FontAwesome 5.15.4 icons, complete list here at https://fontawesome.com/v5/docs/
            "icon": "fas fa-puzzle-piece"
        },
    
        /* if users are allowed to fill the values for an instance of this parameter
           set directly in the plugin component using it, as opposed to only be allowed
           to select already defined presets (default value, can be changed in plugin
           settings)
        */
        "defaultDefinableInline": true,
        /* if users are allowed to define presets at the project level in addition
           to the instance level (default value, can be changed in plugin settings) */
        "defaultDefinableAtProjectLevel": true,
    
        "pluginParams": [
        ],
    
        "params": [
            {
                "name": "param_set_api_key",
                "label": "OpenAI API Key",
                "type": "CREDENTIAL_REQUEST",
                "credentialRequestSettings": {
                    "type": "SINGLE_FIELD"
                },
                "description": "The OpenAI api key",
                "mandatory": true
    
            }
        ]
    }
    

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.project.DSSProject`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataikuapi.dss.llm.DSSLLM`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM> "dataikuapi.dss.llm.DSSLLM")(client, ...) | A handle to interact with a DSS-managed LLM.  
[`dataikuapi.dss.llm.DSSLLMCompletionQuery`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery> "dataikuapi.dss.llm.DSSLLMCompletionQuery")(llm) | A handle to interact with a completion query.  
  
### Functions

[`execute`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.execute> "dataikuapi.dss.llm.DSSLLMCompletionQuery.execute")() | Run the completion query and retrieve the LLM response.  
---|---  
[`get_default_project`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")() | Get a handle to the current default project, if available (i.e.  
[`get_llm`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.get_llm> "dataikuapi.dss.project.DSSProject.get_llm")(llm_id) | Get a handle to interact with a specific LLM  
[`new_completion`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM.new_completion> "dataikuapi.dss.llm.DSSLLM.new_completion")() | Create a new completion query.  
[`with_message`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLMCompletionQuery.with_message> "dataikuapi.dss.llm.DSSLLMCompletionQuery.with_message")(message[, role]) | Add a message to the completion query.

---

## [tutorials/plugins/llm-mesh]

# LLM Mesh

---

## [tutorials/plugins/macros/generality/index]

# Creating a plugin Macro component

## Prerequisites

  * Dataiku >= 12.0

  * Access to a dataiku instance with the “Develop plugins” permissions

  * Access to an existing project with the following permissions:
    
    * “Read project content.”

    * “Write project content.”




## Introduction

Macros in Dataiku can achieve many different roles, from automating tasks to extending the core product’s capabilities. Usually, macros are found in the **Macro** menu under the **More options menu** , as shown in Fig. 1. If your macro has a specific `macroRoles`, it can appear in other places depending on the role. It’s worth noting that a macro isn’t restricted to a particular role and can have several roles if appropriate.

Figure 1: Creation of a new macro.

A macro can be run in several contexts:

  * Manually, by clicking on the macro’s name in the project’s macros screen (Fig. 1).

  * In a dashboard with pre-configured parameters for dashboard users.

  * In a scenario.




You can find some examples [Macros](<../index.html>). To create a macro, go to the plugin editor, click the **\+ New component** button (Fig. 2), and choose the macro component (Fig. 3).

Figure 2: New component

Figure 3: New macro component

This will create a subfolder named `python-runnables` in your plugin directory. Within this subfolder, a subfolder with the name of your macro will be created. You will find two files in the subfolder: `runnable.json` and `runnablie.py`. The `runnable.json` file is used for configuring your macro, while the `runnable_py` file is used for processing.

## Macro configuration

Code 1 shows the default configuration file generated by Dataiku. The file includes standard objects like `"meta"`, `"params"`, and `"permissions"`, which are expected for all components. For more information about these generic objects, please refer to [Component: Macros](<https://doc.dataiku.com/dss/latest/plugins/reference/macros.html> "\(in Dataiku DSS v14\)").

Code 1: Generated macro’s configuration
    
    
    /* This file is the descriptor for the python runnable set-up-a-project */
    {
        "meta": {
            // label: name of the runnable as displayed, should be short
            "label": "Custom runnable set-up-a-project",
    
            // description: longer string to help end users understand what this runnable does
            "description": "",
    
            // icon: must be one of the FontAwesome 3.2.1 icons, complete list here at https://fontawesome.com/v3.2.1/icons/
            "icon": "icon-puzzle-piece"
        },
    
        /* whether the runnable's code is untrusted */
        "impersonate": false,
    
    
        /* params:
           Dataiku will generate a formular from this list of requested parameters.
           Your component code can then access the value provided by users using the "name" field of each parameter.
    
           Available parameter types include:
           STRING, INT, DOUBLE, BOOLEAN, DATE, SELECT, TEXTAREA, DATASET, DATASET_COLUMN, MANAGED_FOLDER, PRESET and others.
    
           For the full list and for more details, see the documentation: https://doc.dataiku.com/dss/latest/plugins/reference/params.html
        */
        "params": [
            {
                "name": "parameter1",
                "label": "User-readable name",
                "type": "STRING",
                "description": "Some documentation for parameter1",
                "mandatory": true
            },
            {
                "name": "parameter2",
                "label": "parameter2",
                "type": "INT",
                "defaultValue": 42
                /* Note that standard json parsing will return it as a double in Python (instead of an int), so you need to write
                   int(self.config()['parameter2'])
                */
            },
    
            /* A "SELECT" parameter is a multi-choice selector. Choices are specified using the selectChoice field*/
            {
                "name": "parameter8",
                "label": "parameter8",
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
            }
        ],
    
        /* list of required permissions on the project to see/run the runnable */
        "permissions": [],
    
        /* what the code's run() returns:
           - NONE : no result
           - HTML : a string that is a html (utf8 encoded)
           - FOLDER_FILE : a (folderId, path) pair to a file in a folder of this project (json-encoded)
           - FILE : raw data (as a python string) that will be stored in a temp file by Dataiku
           - URL : a url
        */
        "resultType": "HTML",
    
        /* label to use when the runnable's result is not inlined in the UI (ex: for urls) */
        "resultLabel": "my production",
    
        /* for FILE resultType, the extension to use for the temp file */
        "extension": "txt",
    
        /* for FILE resultType, the type of data stored in the temp file */
        "mimeType": "text/plain",
    
        /* Macro roles define where this macro will appear in Dataiku. They are used to pre-fill a macro parameter with context.
    
           Each role consists of:
           - type: where the macro will be shown
           * when selecting Dataiku object(s): DATASET, DATASETS, API_SERVICE, API_SERVICE_VERSION, BUNDLE, VISUAL_ANALYSIS, SAVED_MODEL, MANAGED_FOLDER
           * in the global project list: PROJECT_MACROS
           - targetParamsKey(s): name of the parameter(s) that will be filled with the selected object
        */
        "macroRoles": [
            /* {
               "type": "DATASET",
               "targetParamsKey": "input_dataset"
               } */
        ]
    }
    

The `"macroRoles"` object is where you can specify where you want your macro to appear in Dataiku. For instance, if you opt for “DATASET,” your macro will be visible when you choose a dataset from the flow, as demonstrated in Fig. 4. There are various roles available for macros, such as:

  * DATASET, DATASETS, API_SERVICE, API_SERVICE_VERSION, BUNDLE, VISUAL_ANALYSIS, SAVED_MODEL, MANAGED_FOLDER: for a macro that runs on that particular object (usually as an input of the macro).

  * PROJECT_MACROS: for a global macro that works on the project or Dataiku instance, depending on the processing.

  * PROJECT_CREATOR: for defining a new type of project’s creation, setting up specific permissions, a set of usable datasets, and a dedicated Code environment, etc.




Figure 4: UI integration for a `"macroRoles": DATASET`

Finally, `"resultType"` is the return type of the macro. It can take one of those values:

  * `HTML`: produces an HTML (string) as a report (for example).

  * `FILE`: creates raw data (as a Python string) and will be stored in a temp file.

  * `FOLDER_FILE`: same as FILE, except it will be stored in a project folder.

  * `URL`: produces an URL.

  * `RESULT_TABLE`: produces a tabular result, adequately formatted for display.

  * `NONE`: the macro does not produce output.




We recommend that you use `RESULT_TABLE` rather than `HTML` if the output of your macro is a simple table, as you won’t have to handle styling and formatting.

Associated to `resultType`, `resultLabel`, `extension` and `mimeType` are options to specify which output the macro will produce.

## Macro execution

Code 2 shows the default generated code by Dataiku for the macro’s execution, divided into three distinct parts. These parts are designed to help you get started quickly and include:

  * `__init__`: This is an initialization function where you can parse the parameters entered by the user, read the plugin configuration, and do other tasks that are not directly linked to the processing. This function can help you set up the groundwork for your macro processing.

  * `get_progress_target`: If your macro produces some progress information, you should define the final state in this function. Usually, it returns a simple tuple, where the first parameter is the number of steps, and the second is a unit like SIZE, FILES, RECORDS, or NONE. Depending on your macro, you can use SIZE when uploading a file, FILES when reading different files, RECORDS when processing a list of records, and NONE if you want to return global progress. This function helps you track progress and keep your macro processing running smoothly.

  * `run`: This is where you will write the code for processing your macro. Depending on the macro’s type, the processing could take various forms.




Code 2: Generated macro’s processing
    
    
    # This file is the actual code for the Python runnable set-up-a-project
    from dataiku.runnables import Runnable
    
    class MyRunnable(Runnable):
        """The base interface for a Python runnable"""
    
        def __init__(self, project_key, config, plugin_config):
            """
            :param project_key: the project in which the runnable executes
            :param config: the dict of the configuration of the object
            :param plugin_config: contains the plugin settings
            """
            self.project_key = project_key
            self.config = config
            self.plugin_config = plugin_config
    
        def get_progress_target(self):
            """
            If the runnable will return some progress info, have this function return a tuple of
            (target, unit) where unit is one of: SIZE, FILES, RECORDS, NONE
            """
            return None
    
        def run(self, progress_callback):
            """
            Do stuff here. Can return a string or raise an exception.
            The progress_callback is a function expecting 1 value: current progress
            """
            raise Exception("unimplemented")
    

## Simple example

In this scenario you create a macro that copies a set of datasets, only SQL datasets, and upload datasets. This macro needs to ask the user about the datasets they want to copy and which suffix to add to the copies. The macro also needs to display the result of the copy. So you will choose a “RESULT_TABLE” as “resultType.” That leads to the configuration shown in Code 3.

Code 3: Macro’s configuration
    
    
    {
        "meta": {
            "label": "Copy datasets",
            "description": "Allow to copy multiple datasets in one action. You can copy only SQL and uploaded datasets.",
            "icon": "icon-copy"
        },
        "params": [
            {
                "name": "datasets",
                "label": "User-readable name",
                "type": "DATASETS",
                "description": "Some documentation for parameter1",
                "mandatory": true
            },
            {
                "name": "text",
                "label": "parameter2",
                "type": "STRING",
                "defaultValue": "_copy",
                "mandatory": true
            }
        ],
    
    
        "impersonate": false,
        "permissions": [],
        "resultType": "RESULT_TABLE",
    
        "macroRoles": [
            {
                "type": "DATASETS",
                "targetParamsKey": "datasets"
            }
        ]
    }
    

The process shown in Code 4 is as follows:

  * Get the required information from the user in the `__init__` function.

  * Copy the datasets in the run function.

The highlighted lines in the code indicate the lines responsible for generating the output report of the macro.




Code 4: Macro’s processing
    
    
    # This file is the actual code for the Python runnable set-up-a-project
    from dataiku.runnables import Runnable, ResultTable
    import dataiku
    
    class MyRunnable(Runnable):
        """The base interface for a Python runnable"""
    
        def __init__(self, project_key, config, plugin_config):
            """
            :param project_key: the project in which the runnable executes
            :param config: the dict of the configuration of the object
            :param plugin_config: contains the plugin settings
            """
            self.project_key = project_key
            self.plugin_config = plugin_config
            self.datasets = config.get('datasets',[])
            self.text = config.get('text', '_copy')
            self.client = dataiku.api_client()
            self.project = self.client.get_default_project()
    
        def get_progress_target(self):
            """
            If the runnable will return some progress info, have this function return a tuple of
            (target, unit) where unit is one of: SIZE, FILES, RECORDS, NONE
            """
            return (len(self.datasets), 'NONE')
    
        def run(self, progress_callback):
            """
            Do stuff here. Can return a string or raise an exception.
            The progress_callback is a function expecting 1 value: current progress
            """
            rt = ResultTable()
            rt.add_column("1", "Original name", "STRING")
            rt.add_column("2", "Copied name", "STRING")
    
            for index, name in enumerate(self.datasets):
                record = []
                progress_callback(index+1)
                record.append(name)
    
                try:
                    dataset = self.project.get_dataset(name)
                    settings = dataset.get_settings().get_raw()
                    params = settings.get('params')
                    table = params.get('table','')
                    path = params.get('path')
                    if table:
                        params['table'] = "${projectKey}/" + name + self.text
                    if path:
                        params['path'] = "${projectKey}/" + name + "__copy_from_notebook"
    
                    copy = self.project.create_dataset(name + self.text,
                                                       settings.get('type'),
                                                       params,
                                                       settings.get('formatType'),
                                                       settings.get('formatParams')
                                                       )
                    f = dataset.copy_to(copy, True, 'OVERWRITE')
                    f.wait_for_result()
                    record.append("copied to " + name + self.text)
                    # Need better error handling
                except Exception:
                    record.append("An error occured.")
    
                rt.add_record(record)
    
            return rt
    

## Wrapping up

Congratulations! You have completed this tutorial and built your first macro. Understanding all these basic concepts will allow you to create more complex macros.

To go further, instead of copying datasets you could extract some information (like associated tags) from those datasets and display them in a table or HTML.

Here is the complete version of the code presented in this tutorial:

runnable.json
    
    
    {
        "meta": {
            "label": "Copy datasets",
            "description": "Allow to copy multiple datasets in one action. You can copy only SQL and uploaded datasets.",
            "icon": "icon-copy"
        },
        "params": [
            {
                "name": "datasets",
                "label": "User-readable name",
                "type": "DATASETS",
                "description": "Some documentation for parameter1",
                "mandatory": true
            },
            {
                "name": "text",
                "label": "parameter2",
                "type": "STRING",
                "defaultValue": "_copy",
                "mandatory": true
            }
        ],
    
    
        "impersonate": false,
        "permissions": [],
        "resultType": "RESULT_TABLE",
    
        "macroRoles": [
            {
                "type": "DATASETS",
                "targetParamsKey": "datasets"
            }
        ]
    }
    

runnable.py
    
    
    # This file is the actual code for the Python runnable set-up-a-project
    from dataiku.runnables import Runnable, ResultTable
    import dataiku
    
    class MyRunnable(Runnable):
        """The base interface for a Python runnable"""
    
        def __init__(self, project_key, config, plugin_config):
            """
            :param project_key: the project in which the runnable executes
            :param config: the dict of the configuration of the object
            :param plugin_config: contains the plugin settings
            """
            self.project_key = project_key
            self.plugin_config = plugin_config
            self.datasets = config.get('datasets',[])
            self.text = config.get('text', '_copy')
            self.client = dataiku.api_client()
            self.project = self.client.get_default_project()
    
        def get_progress_target(self):
            """
            If the runnable will return some progress info, have this function return a tuple of
            (target, unit) where unit is one of: SIZE, FILES, RECORDS, NONE
            """
            return (len(self.datasets), 'NONE')
    
        def run(self, progress_callback):
            """
            Do stuff here. Can return a string or raise an exception.
            The progress_callback is a function expecting 1 value: current progress
            """
            rt = ResultTable()
            rt.add_column("1", "Original name", "STRING")
            rt.add_column("2", "Copied name", "STRING")
    
            for index, name in enumerate(self.datasets):
                record = []
                progress_callback(index+1)
                record.append(name)
    
                try:
                    dataset = self.project.get_dataset(name)
                    settings = dataset.get_settings().get_raw()
                    params = settings.get('params')
                    table = params.get('table','')
                    path = params.get('path')
                    if table:
                        params['table'] = "${projectKey}/" + name + self.text
                    if path:
                        params['path'] = "${projectKey}/" + name + "__copy_from_notebook"
    
                    copy = self.project.create_dataset(name + self.text,
                                                       settings.get('type'),
                                                       params,
                                                       settings.get('formatType'),
                                                       settings.get('formatParams')
                                                       )
                    f = dataset.copy_to(copy, True, 'OVERWRITE')
                    f.wait_for_result()
                    record.append("copied to " + name + self.text)
                    # Need better error handling
                except Exception:
                    record.append("An error occured.")
    
                rt.add_record(record)
    
            return rt

---

## [tutorials/plugins/macros/index]

# Macros

This section contains several learning materials about the plugin component: Macros.