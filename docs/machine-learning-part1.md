# Dataiku Docs — machine-learning

## [machine-learning/supervised/settings]

# Prediction settings

The “Settings” tab allows you to fully customize all aspects of your prediction.

## Target settings

### Prediction type

Dataiku DSS supports three different types of prediction for three different types of targets.

  * **Regression** is used when the target is numeric (e.g. price of the apartment).

  * **Two-class classification** is used when the target can be one of two categories (e.g. presence or absence of a doorman).

  * **Multi-class classification** is used when targets can be one of many categories (e.g. neighborhood of the apartment).




DSS can build predictive models for each of these kinds of learning tasks. Available options, algorithms and result screens will vary depending on the kind of learning task.

### Multiclass classification

DSS cannot handle large number of classes. We recommend that you do not try to use machine learning with more than about 50 classes.

You must ensure that all classes are detected while creating the machine learning task. Detection of possible classes is done on the analysis’s script sample. Make sure that this sample includes at least one row for each possible class. If some classes are not detected on this sample but found when fitting the algorithm, training will fail.

Furthermore, you need to ensure that all classes are present both in the train and the test set. You might need to adjust the split settings for that assertion to hold true.

Note that these constraints are more complex to handle with large number of classes and very rare classes.

### Partitioned Models

Enabling this setting allows you to train partitioned prediction models on partitioned datasets. When training with this setting, DSS creates one sub model (or model partition) per partition of your dataset.

For more information, see [Partitioned Models](<../partitioned.html>)

## Settings: Train / Test set

When training a model, it is important to test the performance of the model on a “test set”. During the training phase, DSS “holds out” on the test set, and the model is only trained on the train set.

Once the model is trained, DSS evaluates its performance on the test set. This ensures that the evaluation is done on data that the model has “never seen before”.

DSS provides two main strategies for conducting this separation between a training and test set: splitting the dataset and explicit extracts.

### Splitting the dataset

By default, DSS randomly splits the input dataset into a training and a test set. The default ratio is 80% for training and 20% for testing. 80% is a standard fraction of data to use for training.

#### Subsampling

[Depending on the engine](<../algorithms/index.html>) DSS can perform the split, random or sorted, from a subsample of the dataset. This is especially important for in-memory engines, like scikit-learn. DSS defaults to using the first 100,000 rows of the dataset, but other options are available, namely “Random sampling (fixed number of records)”, “Random sampling (approximate ratio)”, “Column values subset”, “Class rebalancing (approximate number of records)” and “Class rebalancing (approximate ratio)”, for more details, see the documentation on [Sampling](<../../explore/sampling.html>).

Note

For classification tasks, the “Class rebalancing” subsampling options can be effective strategies to handle imbalances in the target class. However, be aware that imbalance issues can also be addressed by the “Class weights” weighting strategy, which is recommended for smaller datasets and selected by default. “Class rebalancing” is recommended for larger datasets, i.e. when preprocessed data don’t fit in memory.

#### Splitting

DSS allows the user to specify a split based on a time variable or on a K-fold cross-test.

##### Time ordering

DSS can split the dataset based on a time variable (or any variable with an absolute order). By enabling the “Time ordering” option you will ensure that this split is done according to the order induced by a variable to specify, instead of randomly.

##### K-fold cross-test

DSS allows the user to specify a K-fold cross-test instead of the default simple train/test split.

With K-fold cross-test, the dataset is split into **K** equally sized portions, known as folds. Each fold is independently used as a separate testing set, with the remaining **K-1** folds used as a training set. This method strongly increases training time (roughly speaking, it multiplies it by **K**). However, it allows for two interesting features:

>   * It provides a more accurate estimation of model performance, by averaging over K estimations (one per split) and by providing “error margins” on the performance metrics, computed as twice the standard deviation over the K estimations. When K-fold cross-test is enabled, all performance metrics will have tolerance information. Folds with undefined metrics (NaNs) are ignored in the metrics aggregation.
> 
>   * Once the scores have been computed on each fold, DSS can retrain the model on 100% of the dataset’s data. This is useful if you don’t have much training data.
> 
> 


As with cross-validation, a K-fold cross-test can be also be grouped and/or stratified. For more details, see [cross-validation](<../advanced-optimization.html#stratified-grouped-k-fold>).

### Explicit extracts

DSS also allows the user to specify explicitly which data to use as the training and testing set. If your data has a known structure, such as apartment prices from two different cities, it may be beneficial to use this structure to specify training and testing sets.

The explicit extracts can either come from a single dataset or from two different datasets. Each extract can be defined using:

  * Filtering rules

  * Sampling rules




Using explicit extracts also allows you to use the output of a [Split recipe](<../../other_recipes/split.html>). The split recipe provides much more control and power on how you can split compared to the builtin random splitting of the Machine Learning component

_In general, use an explicit extract of your dataset if your data is heterogeneous, or if you want to precisely control the train/test split for a forecast_.

Note

In “Explicit extracts” mode, since you are providing pre-existing train and test sets, it is not possible to use K-fold cross-test

## Settings: Metrics

### Model optimization

You can choose the metric that DSS will use to evaluate models. The model is optimized according to the selected metric. This metric is used both for model evaluation on the Train / Test and for hyperparameter search.

This metric will be used to decide which model is the best when doing the hyperparameters optimization.

For display on the test sets, this metric also acts as the main one that will be shown by default, but DSS always computes all metrics, so you can choose another metric to display on the final model (however, if you change the metric, you’re not guaranteed that the hyperparameters are the best one for this new metric)

#### Custom

Note

This only applies to the “Python in-memory” training engine

You can also provide a custom scoring function. This object must follow the protocol for scorer objects of scikit-learn.

See: <http://scikit-learn.org/stable/modules/model_evaluation.html#scoring-parameter>

#### Averaging method for multiclass classification

For multiclass classification tasks, the following metrics have to be computed for each class in a binary fashion (one-vs-all or one-vs-one) and then averaged across classes: precision and average precision, recall, F1-score, ROC-AUC and calibration loss. You can choose between **weighted** and **unweighted** averaging across classes. This setting is displayed in the metrics tab and can be edited in the weighting strategy

#### Multiclass ROC AUC

For details on the computation method of the ROC AUC metric for multiclass classification models, see [`this document`](<../../_downloads/cf297152034aae9c6b1a54069289c435/multiclass-roc-auc.pdf>)

### Threshold optimization

When doing binary classification, most models don’t output a single binary answer, but instead a continuous “score of being positive”. You then need to select a threshold on this score, above which DSS will consider the sample as positive. This threshold for scoring the target class is optimized according to the selected metric.

Optimizing the threshold is always a question of compromise between risking false positive and false negatives. DSS will compute the true-positive, true-negative, false-positive, false-negative (also known as the confusion matrix) for many values of the threshold and will automatically select the threshold based on the selected metric.

You can also manually set the threshold at any time in the result screens.

## Settings: Features handling

See [Features handling](<../features-handling/index.html>)

## Settings: Feature generation

DSS can compute interactions between variables, such as linear and polynomial combinations. These generated features allow for linear methods, such as linear regression, to detect non-linear relationship between the variables and the target. These generated features may improve model performance in these cases.

## Settings: Feature reduction

Feature reduction operates on the preprocessed features. It allows you to reduce the dimension of the feature space in order to regularize your model or make it more interpretable.

  * **Correlation with target:** Only the features most correlated (Pearson) with the target will be selected. A threshold for minimum absolute correlation can be set.

  * **Tree-based:** This will create a Random Forest model to predict the target. Only the top features according to the feature importances computed by the algorithm will be selected.

  * **Principal Component Analysis (PCA):** The feature space dimension will be reduced using Principal Component Analysis. Only the top principal components will be selected. _Note:_ This method will generate non-interpretable feature names as its output. The model may be performant, but will not be interpretable.

  * **Independent Component Analysis (ICA):** It identifies statistically independent sources (not necessarily orthogonal) in the feature space and selects the top independent components. _Note:_ This method generates non interpretable feature names. The resulting model may be performant, but will not be interpretable.

  * **Lasso regression:** This will create a LASSO model to predict the target, using 3-fold cross-validation to select the best value of the regularization term. Only the features with nonzero coefficients will be selected.




## Settings: Algorithms

DSS supports several algorithms that can be used to train predictive models. We recommend trying several different algorithms before deciding on one particular modeling method.

The algorithms depend on each engine. See [Algorithms reference](<../algorithms/index.html>) for details

## Settings: Hyperparameters optimization

Please see our [detailed explanation of models optimization](<../advanced-optimization.html>)

## Setting: Weighting strategy

When training and evaluating a model, you can choose to apply a “sample weight” variable to your task. The purpose of a “sample weight” variable is to specify the relative importance of each row of the dataset, both for the training algorithm and for the different evaluation metrics.

For classification problems, weighting strategies include “class weights” which are meant to correct possible imbalances between classes during the training of the model. Note that unlike the “sample weight” strategy, “class weights” do not impact evaluation metrics, i.e. Dataiku will consider each row as equally weighted in the computation of the metrics. Class weights are enabled by default.

Note

Class weights can be substituted by a “Class rebalancing” sampling strategy settable in Settings: Train / Test set, which is recommended for larger datasets. For smaller datasets, i.e. when preprocessed data fits in memory, choosing the “class weights” weighting strategy is the recommended option.

## Setting: Averaging method for one-vs-all metrics

For multiclass classification tasks, the following metrics have to be computed for each class in a binary fashion (one-vs-all or one-vs-one) and then averaged across classes: precision and average precision, recall, F1-score, ROC-AUC and calibration loss. You can choose between the **weighted** and **unweighted** averaging across classes.

  * **unweighted** class average: all classes have equal weight. Better suited for classes of equal importance.

  * **weighted** class average: classes are weighted by the number of rows for each class, or the sum of their sample weights if sample weights are specified.




Note

For the “class weight” and “class and sample weight” strategies, the **unweighted** class average is often more adequate. Class weights are used to train the model, suggesting equal importance of classes. For the “no weighting” and “sample weight” strategies, the **weighted** class average is often more adequate. The one-vs-all metrics will be the weighted average across classes, suggesting unequal importance of classes.

## Setting: Probability calibration

When training a classification model, you can choose to apply a calibration of the predicted probabilities. The purpose of calibrating probabilities is to bring the observed class frequencies as close as possible to the model-predicted class probabilities.

“Sigmoid” fits a shifted and scaled sigmoid function to the probability space.

“Isotonic” fits a piecewise-constant non-decreasing function. The resulting function might be many-to-one, which can have an impact on the ordering of test examples by probabilities and thus many evaluation metrics. It also runs a larger risk of overfitting (optimistic calibration curve).

## Setting: Monotonic constraints

When training a regression model or a binary classification model, you can impose a monotonic relationship between the prediction of the model and any numerical input variable.

When such a monotonic constraint is specified, predictions of the model will only vary in the specified direction (increasing or decreasing) as the constrained variable increases, all other variables being kept equal.

Monotonic constraints have observable consequences on [partial dependence plots](<results.html#prediction-results-pdp-label>). For each constrained variable, the partial dependence plot follows the monotonic direction of the constraint. The snapshot below shows an example with an increasing constraint:

The compatible algorithms are: Random Forests, Extra Trees, XGBoost, LightGBM, Decision Trees.

This feature requires scikit-learn version 1.4 or higher.

## Misc: GPU support for XGBoost

As of release 0.7, XGBoost supports GPU training and scoring. As of release 4.3, DSS supports this feature. As of release 12.6, DSS’s built-in code environment includes XGBoost 0.82 which supports GPU training and scoring using CUDA.

On a CUDA-enabled machine, XGBoost GPU support can be enabled by toggling on the “Activate GPU” switch in the “Runtime environment” panel.

To support a more custom setup, you can: \- use a [custom Python code environment](<../../code-envs/operations-python.html>) \- compile XGBoost against [CUDA](<http://xgboost.readthedocs.io/en/latest/build.html#building-with-gpu-support>)

---

## [machine-learning/supervised/survival-analysis]

# Survival Analysis

Survival analysis tools in DSS include Kaplan-Meier and Cox Proportional Hazards, available through recipes and custom models.

## Description

[Survival analysis](<https://en.wikipedia.org/wiki/Survival_analysis>) is a branch of statistics for analyzing the expected duration of time until one event occurs, such as death in biological organisms and failure in mechanical systems. Survival analysis can be used [whenever our data is incomplete](<https://www.crosstab.io/articles/survival-analysis-applications/>) and not all events have been observed. Such events are called “censored”, and only a lower bound of the duration is known. Survival analysis models provide methods to deal with this incomplete information.

The available components implement standard survival analysis models such as:

  * Kaplan Meier

  * Weibull

  * Cox Proportional Hazards

  * Random Survival Forest




All of these are implemented with the [lifelines](<https://lifelines.readthedocs.io/en/latest/>) package except for Random Survival Forest, which uses [scikit-survival](<https://scikit-survival.readthedocs.io/en/stable/api/generated/sksurv.ensemble.RandomSurvivalForest.html>).

## Initial setup

This capability is provided by the “Survival Analysis” plugin, which you need to install. Please see [Installing plugins](<../../plugins/installing.html>).

To use the Cox Proportional Hazards and the Random Survival Forest algorithms, a specific code environment needs to be selected in the runtime environment. This code environment needs the required visual ML packages as well as lifelines (for Cox) and scikit-survival (for Random Survival Forest).

To do so, the user must:

  * Create a **Python3.7+** code environment in Administration > Code Envs > New Env.

  * Go to Packages to install.

  * Click on Add set of packages.

  * Add the Visual Machine Learning packages. Remove the scikit-learn and scipy requirements (they will be added according to lifelines and scikit-survival requirements).

  * Add lifelines and scikit-survival:

> lifelines==0.27.8 scikit-survival==0.22.1; python_version >= ‘3.8’ scikit-survival==0.17.2; python_version == ‘3.7’ scikit-learn==1.3.2; python_version >= ‘3.8’ scikit-learn==1.0.2; python_version == ‘3.7’

  * Click on Save and Update.

  * Go back to the Runtime Environment

  * Select the environment that has been created.




## How to use

The plugin contains 5 components.

  * The “Estimate survival probability” recipe allows the user to fit four univariate models: Kaplan Meier, Weibull, Nelson Aalen, and Piecewise Exponential.

  * The “Perform statistical tests” enables the user to see the results of the [logrank test](<https://en.wikipedia.org/wiki/Logrank_test>).

  * The custom chart “Confidence interval chart” is used to display the output of the univariate model recipe and is located in the dropdown menu of the usual charts tab.

  * The Cox Proportional Hazards and Random Survival Forest are algorithms in the Lab (visual ML).




### Estimate survival probability: Custom Recipe

This recipe enables the user to fit 4 univariate models: Kaplan Meier, Weibull, Nelson Aalen, and Piecewise Exponential. The user needs to input:

  * The model that is going to be fitted

  * The type of function to output (the list will depend on the selected model)

  * The confidence interval level

  * The duration column (the duration before the event or the censoring)

  * The event indicator column (**0 means the event is censored and 1 means the event is observed**)

  * The categorical columns to group by. A distinct model will be fitted on each group.




### Perform statistical tests: Custom Recipe

This recipe enables the user to use the [logrank test](<https://en.wikipedia.org/wiki/Logrank_test>) to decide whether the survival curves are statistically different: the null hypothesis is that they are equal. This test relies on the proportional hazards hypothesis to be true. The test will be performed between all possible pairs of groups according to the group by columns specified.

The output dataset also contains the result of the [multivariate logrank test](<https://lifelines.readthedocs.io/en/latest/lifelines.statistics.html#lifelines.statistics.multivariate_logrank_test>) and both the log-likelihood ratio test and chi-squared test associated with a univariate Cox model (one binary covariate indicating what group). These last two tests may be more accurate than a logrank test (see the note on [lifelines](<https://lifelines.readthedocs.io/en/latest/lifelines.statistics.html#lifelines.statistics.logrank_test>) and corresponding discussion on [datamethods](<https://discourse.datamethods.org/t/when-is-log-rank-preferred-over-univariable-cox-regression/2344>)).

### Confidence interval chart: custom chart

This custom chart is implemented as a webapp and can be found in the usual dropdown menu of charts. The user must drag and drop the function he wants to display, the associated confidence intervals, the timeline for the x-axis, and the column that indicates the grouping.

The user can hide confidence intervals and the horizontal black line.

### How to obtain a life table

The user may want to display a life table alongside the curves, particularly for life sciences and the financial industry. The confidence interval chart does not produce such a table immediately, but this can be obtained within DSS by going through the following steps:

  * use a window recipe

  * group in the same way as the chart was built

  * sort by decreasing timeline

  * add a “rank” in the aggregations

  * display the result in a pivot table chart with MAX(rank)




These two charts can be aligned with each other in a Dashboard.

### Cox proportional hazards algorithm: visual ML

The user will find this algorithm in the Lab (visual ML). **The target feature should be the time column** (this is a regression algorithm). The user can configure the algorithm as follows:

  * **Training dataset:** the user must reselect the dataset that is being trained on to retrieve the following event indicator column

  * **Event indicator column:** same format as the univariate models recipe → **0 means the event is censored and 1 means the event is observed**

  * **Alpha penalizer** : constant that multiplies the elastic net penalty terms. For unregularized fitting, set the value to 0.

  * **L1 ratio:** specify what ratio to assign to an L1 vs L2 penalty [see lifelines docs](<https://lifelines.readthedocs.io/en/latest/fitters/regression/CoxPHFitter.html#lifelines.fitters.coxph_fitter.CoxPHFitter>)

  * **A boolean parameter** that allows the user to indicate how long subjects have already lived for.

  * **Duration already lived:** visible if the previous parameter is selected. If the previous boolean parameter is unchecked, these durations are set to 0.

  * **The user must select no rescaling for this column.**

  * This column is used for predictions, particularly for scoring a dataset.

  * However, it must also be present in the training dataset even if it is not used for training (because only one “features handling” can be specified for one model). The user can add a column with fake times for the training dataset as long as the column names for the training/testing/scoring datasets are the same.

  * For the test set, the user should create a column filled with 0s if comparing the predictions with uncensored events

  * For a dataset being scored, an example use case would be to create a column in a Prepare recipe with time differences between now and the date of entry in the study (or last restart time for machines) for all living subjects.

  * **Prediction type:** choose to predict either

  * the average expected time of survival

  * the time of survival with a given level of probability

  * the probability of survival at a given time




The main output of a Cox model is the list of hazard ratios. These ratios can be found in the **regression coefficients** tab.

The user should check the box **Display coefficients for the unscaled variables** and can export this list in a dataset for further analysis.

### Random survival forest algorithm: visual ML

This algorithm is also in the Lab alongside the Cox algorithm.

  * **Training dataset, Event indicator column:** same comments as for the Cox algorithm

  * **Prediction type:** choose to predict either

  * the time of survival with a given level of probability

  * the probability of survival at a given time




The other parameters are the same as for the standard Random Forest algorithm in DSS.

Random survival forest is implemented with [scikit-survival](<https://scikit-survival.readthedocs.io/en/stable/api/generated/sksurv.ensemble.RandomSurvivalForest.html>). As of today, it is not possible in this package to specify how long the subjects have already lived for.

### How to compare Cox and Random Survival forest models

The performance of Cox and Random Survival forest models can be evaluated using standard metrics (R^2 score, etc.). The plugin does not yet support ‘out of the box’ specific metrics for survival analysis, such as the concordance index or log likelihood ratios.

To be able to use standard metrics, the user must choose the method of predicting a time of survival for every individual in the test set. Indeed, these two models are capable of calculating an entire survival probability curve for every individual in the test set. Therefore, the user must decide how to extract a single _time of survival_ from these survival curves.

By default, **the Cox algorithm will predict the mathematical expectancy of survival based on the survival curve**. The user may find it interesting to choose the other method, which predicts the time of survival at which the estimated probability level is equal to a given probability value set by the user. The random survival forest will predict values based on the quantile-based method (the expectancy method is not yet implemented for random survival forests).

Note: the predicted times will be compared to the times of survival/censoring of individuals in the test set to obtain the score. Therefore, scoring is more meaningful on a test set that only has observed events. To obtain such a test set, the user can Split and Stack recipes to divide the dataset accordingly and change the ‘Train/Test set’ parameter in the Design.

## Limitations

  * By default, categorical variables are Dummy encoded, and no Dummy is dropped. To avoid collinearity between variables, the user should select Drop Dummy > Drop one Dummy.

  * By default, standard rescaling is applied to the event indicator column, which will modify the expected format containing only 0s and 1s. The user must select Rescaling > No rescaling for this column.

  * The plugin does not yet support ‘out of the box’ specific metrics for survival analysis, such as the concordance index or log likelihood ratios.

  * It is not yet possible to retrieve the confidence intervals around the Cox hazard ratios. Future improvements of the plugin may include a Model View to be able to do so.

  * Filtering in the confidence interval chart does not yet work as expected.

---

## [machine-learning/task-reuse]

# Model Settings Reusability

Dataiku provides several ways to reuse model settings. This allows you to create custom model settings to use as templates.

## Duplicating a Modeling Task

Within the Visual ML tool, select **Duplicate** from a Modeling Task’s dropdown.

You can duplicate an existing Modeling Task, and create the copy in any project, attached to an analysis on any dataset.

## Retaining Settings When Changing the Target Settings

In the [Target settings](<supervised/settings.html>) of a predictive Modeling Task, you can change the target of the Modeling Task. At that time, you can choose to keep the current model settings. This allows you to immediately reuse model settings between similar targets. By contrast, re-detecting the settings returns all settings to their default values, based upon the type of target.

Note

If you change the **Prediction type** , some model settings must be reset.

## Copying Settings

You can copy algorithms and feature handling settings from one Modeling Task to another.

In the [“Features handling”](<features-handling/index.html>) or [“Algorithms”](<algorithms/index.html>) settings of a Modeling Task, click **Copy To…** to copy the settings from the current Modeling Task to another, and click **Copy From…** to copy the settings from another Modeling Task to the current one.

---

## [machine-learning/time-series-forecasting/evaluation]

# Evaluation Recipe

Similar to classification/regression models, you can use the Evaluation Recipe with Time Series Forecasting models to compute performance metrics on an arbitrary dataset. This allows you to evaluate your model on production data, as soon as you have the ground truth.

For more details, see [Evaluating Dataiku Time Series Forecasting models](<../../mlops/model-evaluations/time-series-models.html>)

---

## [machine-learning/time-series-forecasting/index]

# Time Series Forecasting

---

## [machine-learning/time-series-forecasting/interactive-scoring]

# Interactive scoring

Interactive scoring, or “what-if” analysis, explores how a time series forecasting model behaves under different conditions. Create and compare multiple “scenarios” by modifying external feature values to assess how changes impact the model’s forecasts.

From the model’s result page, view forecasts for different scenarios on a chart and edit the external features for each scenario in a table. The table for editing scenario data is similar to an [editable dataset](<../../connecting/editable-datasets.html>).

To analyze different outcomes, create multiple scenarios. Each new scenario can start from the last test horizon or from any other scorable timestamp in the dataset. To build upon existing data, duplicate and then modify a scenario. Scenarios can be renamed for clarity or deleted when no longer needed.

## Publishing to a dashboard

Publish the interactive scoring interface to a dashboard as part of a saved model report. The published report includes both the forecast chart and the data table for your scenarios.

## Limitations

Interactive scoring is only available for models with [“Known-in-advance” features](<../features-handling/roles-and-types.html>).

---

## [machine-learning/time-series-forecasting/introduction]

# Introduction

Time series forecasting is used when you have a time-dependent **target** variable that you want to forecast. For instance, you may want to forecast future sales to optimize inventory, predict energy consumption to adapt production levels, etc. In theses cases, sales and energy consumption are the **target** variables to forecast.

You can find an example project that leverages Dataiku visual capabilities to build forecasting models [here](<https://www.dataiku.com/learn/samples/time-series-forecasting/>).

## Prerequisites and limitations

Training & running the time series forecasting models requires a compatible [code environment](<../../code-envs/index.html>).

Select one of the “Visual Machine Learning and Timeseries Forecasting” package presets in a code env’s Packages to install > Add sets of packages, depending on your architecture (CPU or GPU) and update your code-env.

Warning

Time series forecasting is incompatible with the following:

  * MLflow models

  * Models ensembling

  * Model export:

    * Java export

    * PMML export

    * SQL export / scoring

    * Notebook export




## Train a time series forecasting model

From your dataset, in the _Lab_ sidebar, select _Time Series Forecasting_. Specify the columns to use as target variable and time variable. If your dataset contains several time series, select the identifier columns.

### Time variable

Your dataset should contain a time variable (with meaning _Datetime with zone_ , _Datetime no zone_ or _Date only_).

Forecasting models require a uniform time step in the dataset. However this is not mandatory for the input dataset, as DSS provides a way to impute missing time steps when setting up the time series forecasting task:

  1. First, [adjust the time step used for time series resampling](<settings.html#forecasting-time-step-parameters>) if necessary (DSS guesses it based on the input dataset)

  2. Then, [choose the imputation method](<settings.html#forecasting-resampling>) for numerical and non-numerical features interpolation (missing time steps in the middle of the time series) and extrapolation (missing time steps before the start, or after the end of the time series).




Warning

Dates are converted to UTC before resampling.

### Time series identifier columns

Some dataset contain multiple stacked time series, each identified by the value of one or more identifier columns.

DSS supports both single and multiple time series datasets. For multiple time series you need to specify which columns should be taken as identifiers to distinguish them.

A typical example of multiple time series dataset is sales per shop, and/or per country. The time series identifier columns in this case are the shop and country identifiers.

---

## [machine-learning/time-series-forecasting/results]

# Time Series Forecasting Results

When a model finishes training, click on the model to see the results.

## Forecast charts

The model report contains a visualization of the time series forecast vs. the ground truth of the target variable. If quantiles were specified, this graph also contains the forecast intervals.

If K-Fold cross-test is used for evaluation, the forecast and forecast intervals are shown for every fold.

For multiple time series datasets, one visualization per time series is provided.

## Explainability: Feature importance

Permutation feature importance measures how much the model prediction error (MASE) increases when the values of a given feature are randomly shuffled.

A positive importance means the feature contributes to model accuracy: when shuffled, prediction error increases.

A negative importance suggests removing the feature could improve accuracy.

For models trained with external features, Dataiku can compute permutation feature importance and rank the top 20 features by their impact on the model prediction error (MASE).

Feature importance is measured on the test set after permuting observations across the full time series. If k-fold cross test is enabled, the most recent test fold is used. For custom train/test intervals, the most recent interval is selected based on the test end.

The computation can be slow for datasets with many features, or many time series identifiers.

Note

By default, feature importance computation is skipped during training and can be computed on-demand from the model report. Uncheck “Skip Feature importance” (_Design > Runtime environment > Performance tuning_) to compute feature importance during training.

### Global feature importance

Global feature importance shows the aggregated impact of features across all time series.

### Per time series feature importance

For datasets with multiple time series, Dataiku can compute feature importance for each individual time series. This helps identify features that work differently across different series.

Warning

Per-identifier computation can be significantly more time-consuming.

Each dot represents the importance of a feature for a specific time series. You can filter the displayed time series using the identifier dropdown menus.

Note

When enabling feature importance during training, you can check “Calculate per-identifier feature importance” to instead compute this more detailed analysis.

Note

When many time series are present, only the first 100 are loaded by default.

### Availability

Feature importance is only available for models using **numerical or categorical external features**.

It is not available in the following cases:

  * Models without external features

  * Models using text features




## Performance

The performance section contains several tabs that provide different views of model evaluation metrics.

When K-fold cross-test is enabled, metrics are computed on each fold and averaged across folds.

### Metrics

Lists the main evaluation metrics. For models trained on multiple time series, metrics are aggregated across series. See Aggregation methods for multi-series models for details on cross-series aggregation.

### Metrics per Fold (single-series models)

Lists metrics computed separately for each validation fold. This is available only when K-fold cross-testing is enabled and is useful to assess model stability across folds.

### Metrics per Time Series (multi-series models)

Lists metrics computed separately for each time series. When K-fold cross-test is enabled, they can also be viewed per fold. This is useful to identify heterogeneous performance across series.

### Metrics per Forecast Distance

Lists metrics computed separately for each forecast distance, they can also be viewed per fold. This is useful to analyze how performance evolves with the forecast distance.

### Aggregation methods for multi-series models

For multi-series models, metrics are aggregated across series according to the following methods.

Time series aggregation methods by metric Metric | Aggregation method  
---|---  
Mean Absolute Scaled Error (MASE) | Average across all time series  
Mean Absolute Percentage Error (MAPE) | Average across all time series  
Symmetric MAPE | Average across all time series  
Mean Absolute Error (MAE) | Average across all time series  
Mean Squared Error (MSE) | Average across all time series  
Mean Scaled Interval Score (MSIS) | Average across all time series  
Mean Absolute Quantile Loss (MAQL) | First compute the mean of each quantile loss across time series then compute the mean across all quantiles  
Mean Weighted Quantile Loss (MWQL) | First compute the mean of each quantile loss across time series then compute the mean across all quantiles. Finally divide by the sum of the absolute target value across all time series  
Root Mean Squared Error (RMSE) | Square-root of the aggregated Mean Squared Error (MSE)  
Normalized Deviation (ND) | Sum of the absolute error across all time series, divided by the sum of the absolute target value across all time series  
Custom Metrics | Average across all time series  
  
## Model Information: Algorithm

For multiple time series datasets, some models train one algorithm per time series under the hood (mainly ARIMA and Seasonal LOESS). The resulting per times series hyperparameters are shown in this tab, if any.

## Model Information: Model Coefficients

Some models, such as ARIMA, ETS, Prophet, etc. have a set of coefficients that can be used to interpret the model. Those coefficients are shown in this tab. When applicable, the p-values and t-values of those coefficients can also be shown.

## Model Information: Residuals

Residuals are differences between observed data points and the values predicted by the model. Analysis of such residuals is useful to assess how a model behaves on the historical data it has been optimized on. In Dataiku, those residuals can be visualized with 4 graphs.

Note

Residuals are computed for every possible value of the historical data. Therefore their computation can take a long time. The computation can be manually skipped by checking “Skip expensive reports” before training the model (_Design > Runtime environment > Performance tuning_).

### Standardized residuals histogram

This graph represents the distribution of standardized residuals. Alongside the histogram is plotted a z-distribution.

### Standardized residuals over time

This plot is a representation of the standardized residuals over time. In simpler terms, this is a standardized representation of the error on the historical data.

### Normal Q-Q Plot

A Q-Q plot is a plot of standardized residuals against what would be a theoretical z-distribution of residuals.

### Correlogram

This is a plot of auto-correlation computed for different lag values (up to 10).

## Model Information: Information criteria

Information criteria, such as the Akaike Information Criterion (AIC), Bayesian Information Criterion (BIC), and Hannan-Quinn Information Criterion (HQIC), are metrics that help in model selection by evaluating the trade-off between a model’s goodness of fit and its complexity.

Use these criteria to compare different models trained on the same dataset. A model with a lower information criterion value is generally preferred, as it indicates a better balance between accuracy and simplicity, which can help prevent overfitting.

Note

These criteria are only available for statistical models (ARIMA, ETS, Seasonal Trend) where a likelihood function can be calculated.

---

## [machine-learning/time-series-forecasting/runtime-gpu]

# Runtime and GPU support

The training/scoring of time series forecasting deep learning models can be run on either a CPU or **one** GPU. Training on a GPU is usually much faster.

## Code environment

Time series forecasting in DSS uses specific Python libraries (such as GluonTS and Torch) that are not shipped with the DSS built-in Python environment.

Therefore, before training your first time series forecasting deep learning model, you must create a code environment with the required packages. See [Code environments](<../../code-envs/index.html>) for more information about code environments.

You can select the “Visual Machine Learning and Timeseries Forecasting (GPU)” package preset in the “Packages to install” section of the code environment settings.

Warning

To train or score a time series forecasting model on GPU, DSS needs:

  * At least one CUDA compatible NVIDIA GPU.

  * The GPU drivers installed, with CUDA 12.2 or more recent.

  * A compatible version of NVIDIA NCCL installed, at least 2.4.2.

  * A compatible version of NVIDIA CuDNN installed, at least 7.5.1.




Note

You might need to set the `LD_LIBRARY_PATH` environment variable in your `DATADIR/bin/env-site.sh` to point towards you CUDA library folder (e.g. `export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH`)

## Selection of GPU

Once the proper environment is set up, you can create a time series forecasting modeling task. DSS will look for an environment that has the required packages and select it by default.

If the DSS instance has access to GPU(s) you can then choose **one** of them to train the model.

For containerized execution you can only select the number of GPUs (at most **one** for time series forecasting).

If a model trained on a GPU code environment is deployed as a service endpoint on an API node, the endpoint will require access to a GPU on the API node, with the same CUDA version, and will automatically use GPU resources.

---

## [machine-learning/time-series-forecasting/scoring]

# Scoring recipe

## Without external features

If the model was not trained with external features, the input dataset for the scoring recipe should contain the past time steps for:

  * The time column

  * The time series identifiers columns (if any)

  * The target column




The scoring recipe will then output one forecasting horizon after the last past time step in the input dataset. By default, it will also output all the past data, equally resampled.

## With external features

If the model was trained with external features, the input dataset for the scoring recipe should contain the past time steps for:

  * The time column

  * The time series identifiers columns (if any)

  * The target column

  * The external features columns




It should also contain enough future time steps (at least one forecast horizon) for:

  * The time column

  * The time series identifiers columns (if any)

  * The external features columns




The future data for the target variable must be empty, as they will be forecasted.

For example, if the forecasting horizon is 3 days, the input dataset must contain 3 extra days with external features and empty target:

date | external_feature | target  
---|---|---  
2022-01-01 | 1 | 4  
2022-01-02 | 0 | 4  
2022-01-03 | 1 | 5  
2022-01-04 | 1 | 4  
2022-01-05 | 0 | 5  
2022-01-06 | 1 | 3  
2022-01-07 | 1 | 2  
2022-01-08 | 0 | 4  
2022-01-09 | 0 |   
2022-01-10 | 1 |   
2022-01-11 | 1 |   
  
The model will use external features from the last 3 time stamps (2022-01-09, 2022-01-10, 2022-01-11) to forecast their target values.

The scoring recipe will then output one forecasting horizon after the last past time step in the input dataset. By default, it will also output all the past data, equally resampled.

## Refitting for statistical models

Statistical models (ARIMA and Seasonal LOESS) can be refit on the input data before scoring. This retrains the model on the scoring dataset, with the same hyperparameters, before forecasting.

Note

Scoring with Seasonal LOESS only works with refitting enabled.

---

## [machine-learning/time-series-forecasting/settings]

# Time Series Forecasting Settings

The “Settings” tab allows you to fully customize all aspects of your time series forecasting task.

## Settings: General settings

Set the base settings for time series forecasting (target variable, time variable, time series identifiers (if multiple time series in the dataset))

### Time step parameters

Define what time step will be used for time series resampling. Indeed, forecasting models require the dataset to be sampled with equally spaced time steps. A default setting is guessed by DSS, based on the input data.

### Forecasting parameters

Specify how many time steps will be forecast by the models (a.k.a forecasting horizon), as well as the number of skipped time steps for model evaluation (a.k.a gap).

You can also choose what quantiles will be forecasted by the models (also used for some evaluation metrics).

### Partitioned Models

Warning

DSS support for partitioned time series forecasting models is experimental

This allows you to train partitioned prediction models on partitioned datasets. In that case, DSS creates one sub model (or model partition) per partition of your dataset.

For more information, see [Partitioned Models](<../partitioned.html>)

## Settings: Train / Test set

When training a model, it is important to test the performance of the model on a “test set”. During the training phase, DSS “holds out” on the test set, and the model is only trained on the train set.

Once the model is trained, DSS evaluates its performance on the test set. This ensures that the evaluation is done on data that the model has “never seen before”.

### Splitting the dataset

By default, DSS splits the input dataset (sorted by time) into a train and a test set. For time series forecasting, the size of the test set is the number of step in the forecasting horizon, minus the number of skipped steps (a.k.a gap).

#### Subsampling

DSS defaults to using the first 100’000 rows of the dataset, but other options are available.

For more details, see the documentation on [Sampling](<../../explore/sampling.html>).

#### K-Fold cross-test

A variant of the single train/test split method is called “K-Fold cross-test”: DSS uses the last forecasting horizon as a test set (while skipping the gap), and all time steps before as a train set. It then shifts the test set backwards by one forecasting horizon, and takes all time steps before as a train set. This is repeated until we have **K** {train, gap, test} sets, or evaluation folds.

This method strongly increases training time (roughly speaking, it multiplies it by **K**). However, it allows for two interesting features:

>   * It provides a more accurate estimation of model performance, by averaging over K estimations (one per split) and by providing “error margins” on the performance metrics, computed as twice the standard deviation over the K estimations. When K-Fold cross-test is enabled, all performance metrics will have tolerance information.
> 
>   * Once the scores have been computed on each fold, DSS can retrain the model on 100% of the dataset’s data. This is useful if you don’t have much training data.
> 
> 


#### Custom train/test splitting

Define your own train and test sets to evaluate model performance on specific, non-contiguous time periods. This is useful for testing a model’s robustness against specific periods such as marketing campaigns, sales periods, or holiday seasons.

### Time series resampling

As mentioned above, forecasting models require the dataset to be sampled with equally spaced time steps.

To do so, DSS needs to impute missing values for missing time steps in the dataset. You can set which method to use for numerical and non-numerical features interpolation (missing time steps in the middle of the time series) and extrapolation (missing time steps before the start, or after the end of the time series).

A few example of imputation methods are: linear, quadratic, cubic, mean, constant value, same as previous/next/nearest, most common (for non-numerical), or no imputation at all.

## Settings: External features

Note

Some models do not support the usage of external features for time series forecasting.

Warning

If external features are selected as known-in-advance, “future” values of those features are required when forecasting.

While time series forecasting model can only work with a time variable and a target variable, having external time-dependent features can improve some models’ performance. You can select those that should be used by the model, along with handling settings for each.

The user can choose between two kinds of external features:

>   * **Known-in-advance features** : features whose future values are known.
> 
>   * **Past-only features** : features whose future values are unknown after the current date.
> 
> 


Note

Past-only external features are only usable by some algorithms.

See [Features handling](<../features-handling/index.html>)

## Settings: Feature Generation

Note

Only time-series forecasting based on classical machine learning algorithms can use the generated features.

Feature generation transforms time-series data into structured features that classical machine learning algorithms can process, while preserving the temporal dependencies and chronological relationships in the data.

### Shifts (lags)

Shifts refer to a transformation that moves the time-index of the data forward or backward in time.

For instance, a shift of -1 (or equivalently a lag of 1) transforms the series `0, 1, 2, 3, ... , t` into the series `-1, 0, 1, 2, ... , t-1`.

date   
|  feature   
|  shifted feature (shift -1)  
---|---|---  
2025-09-01 | 42 |   
2025-09-02 | 15 | 42  
2025-09-03 | 78 | 15  
2025-09-04 | 56 | 78  
2025-09-05 | 33 | 56  
2025-09-06 | 67 | 33  
2025-09-07 | 21 | 67  
  
In the context of multiple horizon forecasting with classical machine learning algorithms, past-only data up to indice `t`, and known-in-advance data up to indice `t+i`, can be used to predict values at `t+i` with `i` ranging in `1, 2, ... , horizon`. In order to build data with shifts, two kinds of reference are available:

>   * **Shifts from forecast origin** : `t` is taken as a reference, regardless of the predicted horizon
> 
>   * **Shifts from forecasted point** : `t+i` is taken as a reference, varying for each `i` to be predicted in `1, 2, ... , horizon`.
> 
> 


Each external feature (known-in-advance and past-only), as well as the target (always considered as past-only), can be used to define shifted features.

Shifts with respect to forecast origin will yield the same shifted data for all forecasted points to be predicted. They are typically used with past-only features.

date   
  
|  target   
  
|  feature   
  
|  target horizon t+1   
|  shifted feature horizon t+1 (shift -2 from forecast origin) |  target horizon t+2   
|  shifted feature horizon t+2 (shift -2 from forecast origin)  
---|---|---|---|---|---|---  
2025-09-01 | 1 | 42 | 2 |  | 3 |   
2025-09-02 | 2 | 15 | 3 |  | 4 |   
2025-09-03 | 3 | 78 | 4 | 42 | 5 | 42  
2025-09-04 | 4 | 56 | 5 | 15 | 6 | 15  
2025-09-05 | 5 | 33 | 6 | 78 | 7 | 78  
2025-09-06 | 6 | 67 | 7 | 56 | 8 | 56  
2025-09-07 | 7 | 21 | 8 | 33 | 9 | 33  
  
Shifts with respect to forecasted point will yield data shifted according to the prediction horizon.

As a consequence the joint values of the target, and features shifted from horizon will stay the same, regardless of the horizon.

date   
  
|  target   
  
|  feature   
  
|  target horizon t+1   
|  shifted feature horizon t+1 (shift -2 from forecasted point) |  target horizon t+2   
|  shifted feature horizon t+2 (shift -2 from forecasted point)  
---|---|---|---|---|---|---  
2025-09-01 | 1 | 42 | 2 |  | 3 | 42  
2025-09-02 | 2 | 15 | 3 | 42 | 4 | 15  
2025-09-03 | 3 | 78 | 4 | 15 | 5 | 78  
2025-09-04 | 4 | 56 | 5 | 78 | 6 | 56  
2025-09-05 | 5 | 33 | 6 | 56 | 7 | 33  
2025-09-06 | 6 | 67 | 7 | 33 | 8 | 67  
2025-09-07 | 7 | 21 | 8 | 67 | 9 | 21  
  
### Automatic shifts selection

Instead of explicitly defining each shift for every feature, DSS can automate the process.

The automatic mode is designed to identify and select the most impactful shifts (or lags) for each feature based on its relevance to the target variable.

Note

The automatic shifts mode is available only for shifts defined from forecasted point.

When the mode is enabled on a specific feature, DSS uses the following user-defined parameters for the search of best shifts:

>   * a maximum number of shifts to be selected
> 
>   * lower and upper bounds for shifts
> 
> 


DSS then evaluates the shifts within the provided ranges and selects the most correlated to the target.

This feature is particularly useful when the optimal shifts are not obvious to the user, in order to accelerate the feature generation process.

The following parameters are available for configuration:

  * **Maximum number of shifts** : This sets an upper limit on how many automatically generated shifts can be selected per feature. For example, if set to 5, DSS will identify and select between 0 and 5 shifts for each feature using the auto mode, and discard the rest. This helps control the total number of generated features in the final model.

  * **Exploration ranges** : These parameters define the range of shifts (minimum and maximum shifts) that DSS will explore to find the most relevant ones. Two distinct ranges can be configured:

    * _Past-only features range_ : The search space used for the target variable and all features considered “past-only”.

    * _Known-in-advance features range_ : A separate search space specifically for features whose future values are known.




Note

Enabling the automatic shifts mode on a large number of features or using large exploration ranges, can significantly increase preprocessing time.

### Windows

Windows are defined by a beginning and an end, taking as reference either:

>   * the forecast origin `t`, or
> 
>   * the forecasted point `t+i` for each step `i` between `t+1` and `t+horizon`.
> 
> 

> 
> For each feature, any subset (including none and all) of the following operators can be selected: `min`, `max`, `mean`, `std` and `median`.

Note

Only numerical variables can be used in windows feature generation.

## Settings: Algorithms

DSS supports several algorithms that can be used to train time series forecasting models. We recommend trying several different algorithms before deciding on one particular modeling method.

See [Time series forecasting algorithms](<../algorithms/in-memory-python.html#timeseries-forecasting-algorithms>) for details.

You can choose among three types of forecasting algorithms:

>   * **Baseline** algorithms (_Trivial identity_ , _Seasonal naive_) and the _NPTS_ algorithm: no parameters are learned, each time series is forecasted based on its past values only.
> 
>   * **Statistical** algorithms (_Seasonal trend_ , _AutoARIMA_ , _Prophet_): one model is trained for each separate time series.
> 
>   * **Deep learning** algorithms (_Simple Feed Forward_ , _DeepAR_ , _Transformer_ , _MQ-CNN_): a single model is trained on all time series simultaneously. The model produces one forecast per input time series.
> 
>   * **Machine Learning** algorithms (_Random Forest_ , _XGBoost_ , _Ridge regression_): one model is trained for each separate time series, for each step of the prediction horizon. In this multiple-horizon forecasting framework, data from indices `1, 2, ... , t-2, t-1, t` is used to predict values at `t+1, t+2, ... , t+horizon`. The use of time-based feature generation (lags and windows) is recommended in order to build informative feature matrices to feed the learning algorithm.
> 
> 


## Additional information

### Minimum required length per time series

#### Training

During training, all time series must be longer than a minimum required length that depends on the session settings and on the algorithm and its hyperparameters.

Models require the input time series to be of a minimum length to be able to train.

Because models are trained separately on each fold during both the hyperparameter search and the final evaluation, what matters is the time series length in the first fold. The first fold is the fold with the shortest train set (see the Splitting and Hyperparameters explanation schemas in the blue info box of the Design page to visually understand the folds).

The minimum required length depends on multiple settings:

>   * **Forecasting horizon** : a longer horizon increases the required length.
> 
>   * **Models hyperparameters** : some hyperparameters like the **context length** of Deep Learning models or the **season length** of Statistical models require the input time series to be longer.
> 
> 


There are multiple ways to make the training session work when encountering the minimum required length error:

>   * Decrease the number of folds of the hyperparameter search (or even don’t do search at all).
> 
>   * Decrease the number of folds of the evaluation.
> 
>   * Decrease the forecast horizon and/or the number of horizons in evaluation.
> 
>   * Decrease the maximum context length or season length set for Deep Learning and Statistical models.
> 
>   * Use extrapolation in the resampling: if some time series are shorter than others, then extrapolation will align all time series to the longest one.
> 
> 


#### Scoring and evaluation

During scoring and evaluation, time series shorter than the minimum required length for scoring are completely ignored (these ignored time series can be found in the logs).

Models require the input time series to be of a minimum length to be able to score (note that this required length is usually shorter than the required length for training).

During evaluation, time series are evaluated on the range of time steps that are after the minimum required length for scoring. This means that some time series may be evaluated on fewer time steps than others. Aggregated metrics over all time series are then weighted on the evaluation length of each time series.

---

## [machine-learning/unsupervised/index]

# Clustering (Unsupervised ML)

Clustering (aka unsupervised machine learning) is used to understand the structure of your data. For instance, you could group customers into clusters based on their payment history, which could be used to guide sales strategies.

Note

Unlike supervised machine learning, you don’t need a **target** to conduct unsupervised machine learning

## Running Unsupervised Machine Learning in DSS

Use the following steps to access unsupervised machine learning in DSS:

  * Go to the Flow for your project

  * Click on the dataset you want to use

  * Select the _Lab_

  * Create a new visual analysis

  * Click on the Models tab

  * Select _Create first model_

  * Select _AutoML Clustering_

---

## [machine-learning/unsupervised/settings]

# Clustering settings

The “Settings” tab allows you to fully customize all aspects of your clustering.

## Sampling

Note

You can access the sampling settings in Models > Settings > Sampling

The available sampling methods depend on the [machine learning engine](<../algorithms/index.html>).

If your dataset does not fit in your RAM, you may want to extract a sample on which clustering will be performed. Data can be sampled from the beginning of a dataset (fastest) or randomly sampled from the entire dataset.

## Features

See [Features handling](<../features-handling/index.html>).

## Dimensionality reduction

Note

You can access the sampling settings in Models > Settings > Dimensionality Reduction

Dimensionality reduction reduces the number of variables by arranging them into ‘principal components’ grouping together all correlated variables. The principal components are computed to carry as much variance as possible from the original dataset.

The main interest of using PCA for clustering is to improve the running time of the algorithms, especially when you have a large number of dimensions.

You can choose to enable it, disable it, or try both options to compare.

## Outliers detection

Note

You can access the parameters for outlier detection in Models > Settings > Outlier detection

When performing clustering, it is generally recommended to detect outliers. Not doing so could generate very skewed clusters, or many small clusters and one cluster containing almost the whole dataset.

DSS detects outliers by performing a pre-clustering with a large number of clusters and considering the smallest “mini-clusters” as outliers, if:

  * their cluster size is less than a specified threshold (ex : 10)

  * their cumulative percentage is less than a specified threshold (ex: 1%)




Once outliers are detected, you can either:

  * Drop: outliers are dropped.

  * Cluster : create a “cluster” from all detected outliers.




## Algorithms

Note

You can change the settings for algorithms under Models > Settings > Algorithms

DSS supports several algorithms that can be used for clustering. You can select multiple algorithms to see which performs best for your dataset.

The algorithms depend on the [machine learning engine](<../algorithms/index.html>).