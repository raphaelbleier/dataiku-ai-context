# Dataiku Docs — machine-learning

## [machine-learning/advanced-optimization]

# Advanced models optimization

Each machine learning algorithm has some settings, called hyperparameters.

For each algorithm that you select in DSS, you can ask DSS to explore several values for each hyperparameter. For example, for a regression algorithm, you can try several values of the regularization parameter. If you ask DSS to explore several values for hyperparameters, all the combination of values will be assessed in a “hyperparameter optimization” phase.

Instead of searching for specific discrete values, like “1, 3, 10, 30”, DSS can also search for hyperparameters in continuous ranges like “between 1 and 30”.

DSS will automatically train a model for each combination of hyperparameters and keep the one that maximizes the metric chosen in the [Metric](<supervised/settings.html#settings-metrics>) section. To do so, DSS splits the train set and extracts a hold-out set (or cross-validation set). Each combination of hyperparameters is then evaluated by training a model on the train set minus the hold-out set and evaluating it on the hold-out set. When the evaluation is performed on a partition of the train set in k subsets of equal size, each acting successively as the hold-out, this method is called K-Fold cross-validation.

Note

During this optimization of hyperparameters, DSS never uses the test set (see [Train / Test](<supervised/settings.html#settings-train-test>)), which must remain “pristine” for the final evaluation of the model quality.

Hyperparameter points that yield undefined metric values (NaN or infinity) are ignored during the search.

DSS gives you a lot of settings to tune how the search for the best hyperparameters is performed.

## Search strategies

### Grid search

The most classical strategy for optimizing search parameters is called “Grid search”. For each hyperparameter, you specify either a list of values to test, or a range specification like “5 values equally spaced between 30 and 80” or “8 values logarithmically spaced between 1 and 1000”.

DSS tries all combinations of all hyperparameters as discrete “grid points”.

The grid can either be explored in order or in a shuffled order. Shuffling the grid tends to find better points earlier on average, which is preferable if you want to interrupt search.

### Random search

Instead of exploring discrete points on a grid, random searching considers hyperparameters as a continuous spaces and tests randomly-chosen points in the hyperparameters space.

For each hyperparameter, you specify a range to test. DSS will then pick random points in the space defined by all parameters and test them.

A Random search is by nature infinite, so it is mandatory to select a maximum number of iterations and/or maximum time before stopping the search.

### Bayesian search

Bayesian search starts like a Random search, but as new points in the hyperparameters space are tried, a predictive model is trained in order to model the search space. This predictive model is used to refine the search in order to focus on the most promising parts of the hyperparameters search, in order to reach a good set of hyperparameters faster.

DSS bayesian search leverages a dedicated python package, scikit-optimize, and therefore requires to run on a code-env, with the appropriate packages installed. To do so, you need to:

  * Create a new [code environment](<../code-envs/index.html>)

  * Go to the “Packages to install” tab of this code-env and click on “Add sets of packages”

  * Select one of the package presets containing scikit-optimize (e.g. “Visual Machine Learning and Visual Time series forecasting (CPU)”) and click “Add”

  * Update your code-env




You can now select the code-env in the “Runtime environment” tab of the Design part of the Lab, and train your experiments leveraging bayesian search.

## Cross-validation

There are several strategies for selecting the cross-validation set.

### Simple split cross-validation

With this method, the training set is split into a “real training” and a “cross-validation” set. The split is performed either randomly, or according to a time variable if “Time-based ordering” is activated in the “Train/test split” section. For each value of each hyperparameter, DSS trains the model and computes the evaluation metric, keeping the value of the hyperparameter that provides the best evaluation metric.

The obvious drawback of this method is that restricts further the size of the data on which DSS truly trains. Also, this method comes with some uncertainty, linked to the characteristics of the random split.

### K-Fold cross-validation

With this method, by default the training set is randomly split into **K** equally sized portions, known as folds.

For each combination of hyperparameter and each fold, DSS trains the model on K-1 folds and computes the evaluation metric on the last one. For each combination, DSS then computes the average metric across all folds. DSS keeps the hyperparameter combination that maximizes this average evaluation metric across folds and then retrains the model with this hyperparameter combination on the whole training set.

Note that if “Time-based ordering” is activated in the “Train/test split” section, the training set is split into **K** equally sized portions sorted according to the time variable, and the training splits are assembled in order to ignore samples posterior to each evaluation split so as to emulate a forecasting situation (see e.g. <https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.TimeSeriesSplit.html>)

This method increases the training time (roughly by **K**) but allows to train on the whole training set (and also decreases the uncertainty since it provides several values for the metric).

Note

The methodology for K-Fold cross-validation is the same as [K-Fold cross-test](<supervised/settings.html#settings-train-test-k-fold>) but they serve different goals. K-Fold cross-validation aims at finding the best hyperparameter combination. K-Fold cross-test aims at evaluating error margins on the final scores by using the test set.

#### Using K-Fold for both cross-test and cross-validation

When using K-fold strategy both for hyperparameter search (cross-validation) and for testing (cross-test), the following steps are applied for all algorithms:

  1. **Hyperparameter search:** The dataset is split into **K_val** folds. For each combination of hyperparameter, a model is trained **K_val** times to find the best combination. Finally, the model with the best combination is retrained on the entire dataset. _This will be the model used for deployment._

  2. **Test:** The dataset is split again into **K_test** folds, independently from the previous step. The model with the best hyperparameter combination of Step 1 is trained and evaluated on the new test folds. The performance metric is reported as the average across test folds, with min-max values for estimating uncertainty.




The two steps are done independently, but are shared for all algorithms. Hence one algorithm is compared to another using the same folds.

The number of model trainings needed for a given algorithm to go through the two steps is:

\\[N_{trainings} = K_{test} + (N_{hyperparameters} * K_{val} + 1)\\]

#### Stratified & Grouped K-Fold

Folds can be **stratified** with respect to the prediction target, so that the percentage of samples for each class is preserved in each fold. This is applicable only for classification tasks.

Folds can also be **grouped**. The training set is then split according to the values of the selected “group column”. This means that all rows from the same group go into the same fold (but if K is less than the number of groups, multiple groups can share the same fold). You cannot have fewer groups than folds.

**Stratified group** k-fold is possible, in which case the stratification is best-effort: the folds are stratified as far as possible, while always maintaining the groups.

Note

For stratified group k-fold, the split is not shuffled and ignores the random seed parameter, to avoid [a bug in scikit-learn](<https://github.com/scikit-learn/scikit-learn/issues/24656>) leading to incorrect stratification when shuffled.

The main difference between grouped + stratified and grouped-only k-fold is:

  * Group k-fold attempts to balance the folds by keeping the number of distinct groups approximately the same in each fold.

  * Stratified group k-fold attempts to balance the folds by keeping the target distribution approximately the same in each fold.




### Custom

Note

This only applies to the “Python in-memory” training engine

If you are using scikit-learn, LightGBM or XGBoost, you can provide a custom cross-validation object. This object must follow the protocol for cross-validation objects of scikit-Learn.

See: <http://scikit-learn.org/stable/modules/cross_validation.html>

#### Retrieving column names in the custom cross validator

In order to have access to the column names of the preprocessed dataset, a method called `set_column_labels(self, column_labels)` can be implemented in the CV object. If this method exists, DSS will automatically call it and provide the list of the column names as argument.

Warning

The column labels passed to the function `set_column_labels` are the labels of the prepared and preprocessed columns resulting from the preparation script followed by features handling. Hence, their name may not correspond to the original columns of the dataset. For instance, if automatic pairwise linear combinations were enabled, some columns may take the form: `pw_linear:<A>+<B>`. To find the exact name of the columns, it is advisable to print the column labels received in `set_column_labels`.

##### Example

Warning

Classes cannot be declared directly in the Models > Design tab. They should be packaged in a [library](<../python/reusing-code.html>) and imported, as demonstrated in the examples below.

  * In the “Custom Cross-validation strategy” code editor, you should create the `cv` variable.

> from my_custom_cv import MyCustomCV
>         
>         cv = MyCustomCV()
>         

  * In a [library](<../python/reusing-code.html>) file called `my_custom_cv.py`:

> class MyCustomCV(object):
>         
>             def set_column_labels(self, column_labels):
>                 self.column_labels = column_labels
>         
>             def _extract_important_column(self, X):
>                 # The two following instructions show how to retrieve a specific
>                 # column given its name
>         
>                 # 1. Retrieve the index of the column called "important_column"
>                 column_index = self.column_labels.index("important_column")
>         
>                 # 2. Retrieve the corresponding data column
>                 return X[:, column_index]
>         
>             def split(self, X, y, groups=None):
>                 important_column = self._extract_important_column(X)
>         
>                 # Finish the implementation of the split function
>                 ...
>         
>             def get_n_splits(self, X, y, groups=None):
>                 important_column = self._extract_important_column(X)
>         
>                 # Finish the implementation of the get_n_splits function
>                 ...
>         




## Execution parameters

Each algorithm is trained in isolation from the other algorithms but they all use the same execution parameters for their own hyperparameter search.

You can select the maximum number of algorithms trained concurrently in the **Advanced > Runtime environment** design screen (“Max concurrency” setting).

### Limits

You can specify two types of limits to the hyperparameter search execution:

  * _hyperparameter space_ : each algorithm will explore at most the specified number of hyperparameter combinations

  * _search time_ : for each algorithm, the search will stop when the time limit is reached.




For grid-search, the hyperparameter space is naturally limited so specifying any limit is optional.

For random or Bayesian search, the hyperparameter space is usually unlimited so specifying at least one of these limitations is mandatory.

Note that when both space and time limits are set, the one to be enforced is the first to be reached.

### Distribution and multi-threading

_Distribution_ : since version 9.0, you can leverage a Kubernetes cluster to distribute and speed up the hyperparameter search. You can specify a number of containers where the preprocessed train data will be sent to, and where the training and evaluation of the model for all splits and hyperparameters combinations will be performed. As a result, the search can be sped up by a factor of up to the number of containers.

Note that the “Containerized execution configuration” setting in **Advanced > Runtime environment** needs to be specified with a configuration using a Kubernetes engine for this option to be available.

_Number of threads_ : Dataiku can also speed up the search by using multi-threading in the exploration of the different combinations of data splits and hyperparameters. More specifically, each thread will be used to explore sequentially the different splits and hyperparameters combinations. When containerized execution is used, this setting controls the number of threads in each container. Note that using many threads may increases memory usage. Note also that significant speedups can only be expected for algorithms releasing the Python GIL during training, such as e.g. tree-based scikit-learn algorithms.

### Randomization

The order in which hyperparameters are drawn can be controlled through the “Random state” setting. It guarantees reproducibility of the hyperparameter search, provided that all other randomness factors are kept identical.

For grid-search, you can specify whether or not the grid is explored in the natural order. Shuffling can speed up the search by removing priority between hyperparameters, avoiding thorough explorations of hyperparameters with low impact on the result.

## Interrupting and resuming hyperparameter search

If you select a large number of hyperparameters to optimize and hyperparameter values, training can become very slow.

### Interrupting

At any time while DSS is searching, you can choose to interrupt the optimization. DSS will finish the current point it is evaluating, and will train and evaluate the model on the “best hyperparameters found so far”.

If you are using Grid search strategy, we recommend that you enable “Randomize grid search” if you plan on interrupting your grid search.

### Time-bounding or iteration-bounding

Alternatively, before starting the search, you can select a maximum time or number of points to evaluate. DSS will automatically interrupt the search when one of these criteria is reached.

### Resuming

An interrupted hyperparameter search can be resumed later on. DSS will only try the hyperparameter values that it hadn’t tried yet.

## Visualization of hyperparameter search results

If you have selected several hyperparameters for DSS to test, during training, DSS will show a graph of the evolution of the best **cross-validation scores** found so far. DSS only shows the best score found so far, so the graph will show “ever-improving” results, even though the latest evaluated model might not be good. If you hover over one of the points, you’ll see the evolution of hyperparameter values that yielded an improvement.

In the right part of the charts, you see final **test scores** for completed models (models for which the hyperparameter-search phase is done)

The timing that you see as X axis represents time spent training this particular algorithm. DSS does not train all algorithms at once, but each algorithm will have a 0-starting X axis.

Note

The scores that you are seeing in the left part of the chart are **cross-validation** scores on the cross-validation set. They cannot be directly compared to the **test scores** that you see in the right part.

  * They are not computed on the same data set

  * They are not computed with the same model (after hyperparameter-search, DSS retrains the model on the whole train set)




In this example:

  * Even though XGBoost was better than Random Forest in the cross-validation set, ultimately on the test set (once trained on the whole dataset), Random forest won (this might indicate that the RF didn’t have enough data once the cross-validation set was out)

  * The ANN scored 0.83 on the cross-validation set, but its final score on the test set was slightly lower at 0.812




### In a model

Once a model is done training, you can also view the impact of each individual hyperparameter value on the final score and training time. This information is displayed both as a graph and a data table that you can export.

---

## [machine-learning/algorithms/in-memory-python]

# In-memory Python

Most algorithms (except time series forecasting) are based on the [Scikit Learn](<http://scikit-learn.org/>), the [LightGBM](<https://github.com/microsoft/LightGBM>) or the [XGBoost](<https://github.com/dmlc/xgboost>) machine learning libraries.

This engine provides in-memory processing. The train and test sets must fit in memory. Use the sampling settings if needed.

## Prediction algorithms

Prediction with this engine supports the following algorithms.

### (Regression) Ordinary Least Squares

Ordinary Least Squares or Linear Least Squares is the simplest algorithm for linear regression. The target variable is computed as the sum of weighted input variables. OLS finds the appropriate weights by minimizing the cost function (ie, how ‘wrong’ the algorithm is).

OLS is very simple and provides a very “explainable” model, but:

  * it cannot automatically fit data for which the target variable is not the result of a linear combination of input features

  * it is highly sensitive to errors in the input dataset and prone to overfitting




Parameters:

  * **Parallelism:** Number of cores used for parallel training. Using more cores leads to faster training but at the expense of more memory consumption, especially for large training datasets. (-1 means ‘all cores’)




### (Regression) Ridge Regression

Ridge Regression addresses some problems of Ordinary Least Squares by imposing a penalty (or regularization term) to the weights. Ridge regression uses a L2 regularization. L2 regularization reduces the size of the coefficients in the model.

Parameters:

  * **Regularization term (auto-optimized or specific values)** : Auto-optimization is generally faster than trying multiple values, but it does not support sparse features (like text hashing)

  * **Alpha** : The regularization term. This parameter can be optimized.




### (Regression) Lasso Regression

Lasso Regression is another linear model, using a different regularization term (L1 regularization). L1 regularization reduces the number of features included in the final model.

Parameters:

  * **Regularization term (auto-optimized or specific values)** : Auto-optimization is generally faster than trying multiple values, but it does not support sparse features (like text hashing)

  * **Alpha** : The regularization term. This parameter can be optimized.




### (Classification) Logistic regression

Despite its name, Logistic Regression is a classification algorithm using a linear model (ie, it computes the target feature as a linear combination of input features). Logistic Regression minimizes a specific cost function (called logit or sigmoid function), which makes it appropriate for classification. A simple Logistic regression algorithm is prone to overfitting and sensitive to errors in the input dataset. To address these issues, it is possible to use a penalty (or regularization term ) to the weights.

Logistic regression has two parameters:

  * **Regularization (L1 or L2 regularization)** : L1 regularization reduces the number of features that are used in the model. L2 regularization reduces the size of the coefficient for each feature.

  * **C** : Penalty parameter C of the error term. A low value of C will generate a smoother decision boundary (higher bias) while a high value aims at correctly classifying all training examples, at the risk of overfitting (high variance). (C corresponds to the inverse of a regularization parameter). You can try several values of C by using a comma-separated list.




### (Classification) TabICL

TabICL is a pre-trained Tabular Foundation Model for In-Context Learning, built on a transformer architecture. It delivers strong performance on classification tasks with minimal configuration. However, TabICL exhibits high memory consumption that scales with the size of the datasets. TabICL support is experimental and its use is not recommended for datasets with more than 50,000 samples and 150 features. For more details on this model, please refer to the TabICL paper: <https://arxiv.org/pdf/2502.05564>

Parameters:

  * **Number of estimators** : Controls how many different “views” of the dataset are created. Each view is a transformed version of the original data (e.g., normalization, feature permutation, label shifting) to give TabICL diverse perspectives and improve performance. Higher values usually increase robustness but also computation time.

  * **Parallelism** : The number of CPU threads allocated to run the model. Set to -1 to use all available CPU cores.

  * **Normalization methods** : Defines how input features are scaled or transformed before modeling. Applied during view generation (linked to the “Number of estimators” above), each method helps create diverse feature representations to enhance robustness and performance. These methods are fixed and not tuned via grid search.

  * **Outlier threshold** : Controls the z-score threshold for outlier detection and clipping.

  * **Class shift** : Indicates whether to apply cyclic shifts to class labels across dataset “views”, helping prevent overfitting to specific class index patterns.

  * **Softmax temperature** : Temperature value for the softmax function. Lower values make predictions more confident, higher values make them more conservative.

  * **Batch size** : Number of dataset “views” processed simultaneously during inference. A smaller batch size reduces memory usage but may increase inference time, while a larger batch size can speed up processing at the cost of higher memory consumption.

  * **Random state** : Used for reproducibility of ensemble generation, affecting feature shuffling and other randomized operations.




### (Regression & Classification) Random Forests

_Decision tree classification_ is a simple algorithm which builds a decision tree. Each node of the decision tree includes a condition on one of the input features.

A _Random Forest_ regressor is made of many decision trees. When predicting a new record, it is predicted by each tree, and each tree “votes” for the final answer of the forest. The forest then averages the individual trees answers. When “growing” (ie, training) the forest:

  * for each tree, a random sample of the training set is used;

  * for each decision point in the tree, a random subset of the input features is considered.




Random Forests generally provide good results, at the expense of “explainability” of the model.

Parameters:

  * **Number of trees** : Number of trees in the forest. Increasing the number of trees in a random forest does not result in overfitting. This parameter can be optimized.

  * **Feature sampling strategy:** Adjusts the number of features to sample at each split.

    * Automatic will select 30% of the features.

    * Square root and Logarithm will select the square root or base 2 logarithm of the number of features respectively

    * Fixed number will select the given number of features

    * Fixed proportion will select the given proportion of features

  * **Maximum depth of tree** : Maximum depth of each tree in the forest. Higher values generally increase the quality of the prediction, but can lead to overfitting. High values also increase the training and prediction time. Use 0 for unlimited depth (ie, keep splitting the tree until each node contains a single target value)

  * **Minimum samples per leaf** : Minimum number of samples required in a single tree node to split this node. Lower values increase the quality of the prediction (by splitting the tree mode), but can lead to overfitting and increased training and prediction time.

  * **Parallelism:** Number of cores used for parallel training. Using more cores leads to faster training but at the expense of more memory consumption, especially for large training datasets.

  * **Allow sparse matrices:** Whether to allow DSS to use sparse matrices for training. Internally, DSS will use a heuristic on whether to train on sparse matrices, which may help reduce CPU and RAM usage. This can be particularly useful when using either Dummy Encoding categorical feature handling, or hashing-based text feature handling.




### (Regression & Classification) Gradient Boosted Trees

Gradient boosted trees are another ensemble method based on decision trees. Trees are added to the model sequentially, and each tree attempts to improve the performance of the ensemble as a whole. The advantages of GBRT are:

  * Natural handling of data of mixed type (= heterogeneous features)

  * Predictive power

  * Robustness to outliers in output space (via robust loss functions)




Please note that you may face scalability issues, due to the sequential nature of boosting it can hardly be parallelized.

The gradient boosted tree algorithm has four parameters:

  * **Number of boosting stages** : The number of boosting stages to perform. Gradient boosting is fairly robust to over-fitting so a large number usually results in better performance. This parameter can be optimized.

  * **Learning rate** : Multiplier applied to all base learners. Lower values slow down convergence and can make the model more robust. Typical values: 0.01 - 0.3. This parameter can be optimized.

  * **Loss:** The available loss functions depend upon whether this is a classification or regression problem.

>     * **Classification:** Deviance refers to deviance (equivalent to logistic regression) for classification with probabilistic outputs. For exponential loss, gradient boosting recovers the AdaBoost algorithm.
> 
>     * **Regression:** Choose from least squares, least absolution deviation, or Huber. Huber is a combination of Least Square and Least Absolute Deviation.

  * **Maximum depth of tree:** Maximum depth of each tree. High values can increase the quality of the prediction, but can also lead to over-fitting. Typical values: 3 - 10. This parameter can be optimized.

  * **Allow sparse matrices:** Whether to allow DSS to use sparse matrices for training. Internally, DSS will use a heuristic on whether to train on sparse matrices, which may help reduce CPU and RAM usage. This can be particularly useful when using either Dummy Encoding categorical feature handling, or hashing-based text feature handling.

  * **Minimum samples per leaf** : Minimum number of samples required in a single tree node to split this node. Lower values increase the quality of the prediction (by splitting the tree mode), but can lead to overfitting and increased training and prediction time.




This algorithm also provides the ability to visualize partial dependency plots of your features.

### (Regression & Classification) LightGBM

[LightGBM uses a specific library](<https://lightgbm.readthedocs.io>) instead of scikit-learn.

LightGBM is a tree-based gradient boosting library designed to be distributed and efficient. It provides fast training speed, low memory usage, good accuracy and is capable of handling large scale data.

Parameters:

  * **Maximum number of trees:** LightGBM has an early stopping mechanism so the exact number of trees will be optimized. High number of actual trees will increase the training and prediction time. Typical values: 50 - 200. This parameter can be optimized.

  * **Maximum depth of tree:** Maximum depth of each tree. High values can increase the quality of the prediction, but can also lead to over-fitting. Typical values: 3 - 10.

  * **Number of leaves:** Maximum tree leaves for base learners. Typical values range between 20 and 500. This parameter can be optimized.

  * **Learning rate:** Multiplier applied to all base learners. Lower values slow down convergence and can make the model more robust. Typical values: 0.01 - 0.3. This parameter can be optimized.

  * **Minimum split gain:** Minimum loss reduction required to make a further partition on a leaf node of the tree. This parameter can be optimized.

  * **Minimum child weight:** Minimum sum of instance weight (hessian) needed in a child (leaf). High values can prevent over-fitting by learning highly specific cases. Smaller values allow leaf nodes to match a small set of rows, which can be relevant for highly imbalanced datasets. This parameter can be optimized.

  * **Minimum leaf samples:** Minimum number of data samples needed in a leaf. This parameter can be optimized.

  * **Colsample by tree:** Fraction of the features to be used in each tree. Typical values: 0.5 - 1. This parameter can be optimized.

  * **L1 regularization:** L1 regularization coefficient applied to the weight of potential splits for their evaluation during tree-building. Aims at reducing over-fitting and the complexity of trees. This parameter can be optimized.

  * **L2 regularization:** L2 regularization coefficient applied to the weight of potential splits for their evaluation during tree-building. Aims at reducing over-fitting and the complexity of trees. This parameter can be optimized.

  * **Use Bagging:** Bagging can be used to speed up training and/or prevent over-fitting but can also make specific cases harder to learn. Enabling bagging allows to configure the “Subsample” parameters.

  * **Subsample ratio:** Subsample ratio for the data to be used in each tree. Low values can prevent over-fitting but can make specific cases harder to learn. Typical values: 0.5 - 1. Note that 1. will de facto disable bagging.

  * **Subsample frequency:** Frequency (in number of iterations) at which bagging must be performed. Setting a value of k means “perform bagging every k iterations”. Note that 0 will de facto disable bagging.

  * **Early stopping:** Use the LightGBM’s built-in early stopping mechanism so the exact number of trees will be optimized (up to the specified maximum number of trees). The cross-validation scheme defined in the **Train & validation** tab will be used. This parameter will always be optimized during the hyperparameter search step. The model training fitting step won’t re-optimize it.

  * **Early stopping rounds:** The optimizer stops if the loss never decreases for this consecutive number of iterations. Typical values: 4 - 10.

  * **Parallelism:** Number of cores used for parallel training (-1 means “all cores”). Using more cores leads to faster training but at the expense of more memory consumption, especially for large training datasets.

  * **Allow sparse matrices:** Whether to allow DSS to use sparse matrices for training. Internally, DSS will use a heuristic on whether to train on sparse matrices, which may help reduce CPU and RAM usage. This can be particularly useful when using either Dummy Encoding categorical feature handling, or hashing-based text feature handling.




### (Regression & Classification) XGBoost

[XGBoost uses a specific library](<https://xgboost.readthedocs.io>) instead of scikit-learn.

XGBoost is an advanced gradient boosted tree algorithm. It has support for parallel processing, regularization, early stopping which makes it a very fast, scalable and accurate algorithm.

Parameters:

  * **Maximum number of trees:** XGBoost has an early stopping mechanism so the exact number of trees will be optimized. High number of actual trees will increase the training and prediction time. Typical values: 50 - 200. This parameter can be optimized.

  * **Early stopping:** Use the XGBoost’s built-in early stopping mechanism so the exact number of trees will be optimized (up to the specified maximum number of trees). The cross-validation scheme defined in the **Train & validation** tab will be used. This parameter will always be optimized during the hyperparameter search step. The model training fitting step won’t re-optimize it.

  * **Early stopping rounds:** The optimizer stops if the loss never decreases for this consecutive number of iterations. Typical values: 4 - 10.

  * **Maximum depth of tree:** Maximum depth of each tree. High values can increase the quality of the prediction, but can also lead to over-fitting. Typical values: 3 - 10. This parameter can be optimized.

  * **Learning rate:** Multiplier applied to all base learners. Lower values slow down convergence and can make the model more robust. Typical values: 0.01 - 0.3. This parameter can be optimized.

  * **L2 regularization:** L2 regularization coefficient applied to the weight of potential splits for their evaluation during tree-building. Aims at reducing over-fitting and the complexity of trees. This parameter can be optimized.

  * **L1 regularization:** L1 regularization coefficient applied to the weight of potential splits for their evaluation during tree-building. Aims at reducing over-fitting and the complexity of trees. This parameter can be optimized.

  * **Gamma:** Minimum loss reduction required to make a further partition on a leaf node of the tree. This parameter can be optimized.

  * **Minimum child weight:** Minimum sum of instance weight (hessian) needed in a child (leaf). High values can prevent over-fitting by learning highly specific cases. Smaller values allow leaf nodes to match a small set of rows, which can be relevant for highly imbalanced datasets. This parameter can be optimized.

  * **Subsample:** Subsample ratio for the data to be used in each tree. Low values can prevent over-fitting but can make specific cases harder to learn. Typical values: 0.5 - 1. This parameter can be optimized.

  * **Colsample by tree:** Fraction of the features to be used in each tree. Typical values: 0.5 - 1. This parameter can be optimized.

  * **Parallelism:** Number of cores used for parallel training (-1 means “all cores”). Using more cores leads to faster training but at the expense of more memory consumption, especially for large training datasets.

  * **Allow sparse matrices:** Whether to allow DSS to use sparse matrices for training. Internally, DSS will use a heuristic on whether to train on sparse matrices, which may help reduce CPU and RAM usage. This can be particularly useful when using either Dummy Encoding categorical feature handling, or hashing-based text feature handling. If enabled, the output model will not be exportable to SQL or PMML.

  * **Custom missing value:** Allows choosing a specific value to treat as missing, instead of the default of np.nan. Beware that this value is compared after preprocessing, which can include averaging and value imputing. This setting has no effect with sparse matrices.




### (Regression & Classification) Decision Tree

Decision Trees (DTs) are a non-parametric supervised learning method used for classification and regression. The goal is to create a model that predicts the value of a target variable by learning simple decision rules inferred from the data features.

Parameters:

  * **Maximum depth** : The maximum depth of the tree. This parameter can be optimized.

  * **Criterion (Gini or Entropy)** : The function to measure the quality of a split. Supported criteria are “gini” for the Gini impurity and “entropy” for the information gain. This applies only to classification problems.

  * **Minimum samples per leaf** : Minimum number of samples required to be at a leaf node. This parameter can be optimized.

  * **Split strategy (Best or random)**. The strategy used to choose the split at each node. Supported strategies are “best” to choose the best split and “random” to choose the best random split.




### (Regression & Classification) Support Vector Machine

Support Vector Machine is a powerful ‘black-box’ algorithm for classification. Through the use of kernel functions, it can learn complex non-linear decision boundaries (ie, when it is not possible to compute the target as a linear combination of input features). SVM is effective with large number of features. However, this algorithm is generally slower than others.

Parameters:

  * **Kernel (linear, RBF, polynomial, sigmoid)** : The kernel function used for computing the similarity of samples. Try several to see which works the best.

  * **C** : Penalty parameter C of the error term. A low value of C will generate a smoother decision boundary (higher bias) while a high value aims at correctly classifying all training examples, at the risk of overfitting (high variance). (C corresponds to the inverse of a regularization parameter). This parameter can be optimized.

  * **Gamma** : Kernel coefficient for RBF, polynomial and sigmoid kernels. Gamma defines the ‘influence’ of each training example in the features space. A low value of gamma means that each example has ‘far-reaching influence’, while a high value means that each example only has close-range influence. If no value is specified (or 0.0), then 1/nb_features is used. This parameter can be optimized.

  * **Tolerance** : Tolerance for stopping criterion.

  * **Maximum number of iterations** : Number of iterations when fitting the model. -1 can be used to specific no limit.




### (Regression & Classification) Stochastic Gradient Descent

SGD is a family of algorithms that reuse concepts from Support Vector Machines and Logistic Regression. SGD uses an optimized method to minimize the cost (or loss ) function, making it particularly suitable for large datasets (or datasets with large number of features).

Parameters:

  * **Loss function (logit or modified Huber)** : Selecting ‘logit’ loss will make the SGD behave like a Logistic Regression. Enabling ‘modified huber’ loss will make the SGD behave quite like a Support Vector Machine.

  * **Iterations** : number of iterations on the data

  * **Penalty (L1, L2 or elastic net)** : L1 and L2 regularization are similar to those for linear and logistic regression. Elastic net regularization is a combination of L1 and L2 regularization.

  * **Alpha** : Regularization parameter. A high value of alpha (ie, more regularization) will generate a smoother decision boundary (higher bias) while a lower value (less regularization) aims at correctly classifying all training examples, at the risk of overfitting (high variance). This parameter can be optimized.

  * **L1 ratio** : ElasticNet regularization mixes both L1 and L2 regularization. This ratio controls the proportion of L2 in the mix. (i.e. 0 corresponds to L2-only, 1 corresponds to L1-only). Defaults to 0.15 (85% L2, 15% L1).

  * **Parallelism** : Number of cores used for parallel training. Using more cores leads to faster training but at the expense of more memory consumption, especially for large training datasets.




### (Regression & Classification) K Nearest Neighbors

K Nearest Neighbor classification makes predictions for a sample by finding the k nearest samples and assigning the most represented class among them.

_Warning:_ this algorithm requires storing the entire training data into the model. This will lead to a very large model if the data is larger than a few hundred lines. Predictions may also be slow.

Parameters:

  * **K:** The number of neighbors to examine for each sample. This parameter can be optimized.

  * **Distance weighting:** If enabled, voting across neighbors will be weighed by the inverse distance from the sample to the neighbor.

  * **Neighbor finding algorithm:** The method used to find the nearest neighbors to each point. Has no impact on predictive performance, but will have a high impact on training and prediction speed.

    * Automatic: a method will be selected empirically depending on the data.

    * KD & Ball Tree : stores the data points into a partitioned data structure for efficient lookup.

    * Brute force: will examine every training sample for every prediction. Usually inefficient.

  * **p:** The exponent of the Minkowski metric used to search neighbors. For p = 2, this gives Euclidean distance, for p = 1, Manhattan distance. Greater values lead to the Lp distances.




### (Regression & Classification) Extra Random Trees

Extra trees, just like Random Forests, are an ensemble model. In addition to sampling features at each stage of splitting the tree, it also samples random threshold at which to make the splits. The additional randomness may improve generalization of the model.

Parameters:

  * **Numbers of trees:** Number of trees in the forest. This parameter can be optimized.

  * **Feature sampling strategy:** Adjusts the number of features to sample at each split.

    * Automatic will select 30% of the features.

    * Square root and Logarithm will select the square root or base 2 logarithm of the number of features respectively

    * Fixed number will select the given number of features

    * Fixed proportion will select the given proportion of features

  * **Maximum depth of tree:** Maximum depth of each tree in the forest. Higher values generally increase the quality of the prediction, but can lead to overfitting. High values also increase the training and prediction time. Use 0 for unlimited depth (ie, keep splitting the tree until each node contains a single target value). This parameter can be optimized.

  * **Minimum samples per leaf:** Minimum number of samples required in a single tree node to split this node. Lower values increase the quality of the prediction (by splitting the tree mode), but can lead to overfitting and increased training and prediction time. This parameter can be optimized.

  * **Parallelism:** Number of cores used for parallel training. Using more cores leads to faster training but at the expense of more memory consumption, especially for large training datasets.




### (Regression & Classification) Artificial Neural Network

Neural Networks are a class of parametric models which are inspired by the functioning of neurons. They consist of several “hidden” layers of neurons, which receive inputs and transmit them to the next layer, mixing the inputs and applying non-linearities, allowing for a complex decision function.

Parameters:

  * **Hidden layer sizes:** Number of neurons on each hidden layer. Separate by commas to add additional layers.

  * **Activation:** The activation function for the neurons in the network.

  * **Alpha:** L2 regularization parameter. Higher values lead to smaller neuron weights and a more generalizable, although less sharp model.

  * **Max iterations:** Maximum iterations for learning. Higher values lead to better convergence, but take more time.

  * **Convergence tolerance:** If the loss does not improve by this ratio over two iterations, training stops.

  * **Early stopping:** Whether the model should use validation and stop early.

  * **Solver:** The solver to use for optimization. LBFGS is a batch algorithm and is not suited for larger datasets.

  * **Shuffle data:** Whether the data should be shuffled between epochs (recommended, unless the data is already in random order).

  * **Initial Learning Rate:** The initial learning rate for gradient descent.

  * **Automatic batching:** Whether batches should be created automatically (will use 200, or the whole dataset if there are less samples). Uncheck to select batch size.

  * **beta_1:** beta_1 parameter for ADAM solver.

  * **beta_2:** beta_2 parameter for ADAM solver.

  * **epsilon:** epsilon parameter for ADAM solver.




### (Regression & Classification) Lasso Path

The Lasso Path is a method which computes the LASSO path (ie. for all values of the regularization parameter). This is performed using LARS regression. It requires a number of passes on the data equal to the number of features. If this number is large, computation may be slow. This computation allows to select a given number of non-zero coefficients, ie. to select a given number of features. After training, you will be able to visualize the LASSO path and select a new number of features.

Parameters:

  * **Maximum features:** The number of kept features. Input 0 to have all features enabled (no regularization). Has no impact on training time.




### (Regression & Classification) Deep Neural Network

Deep Neural Networks are a class of fully-connected feedforward artificial neural networks, composed of one or several “hidden” layers of nodes, or computational units, called neurons. Each neuron from a hidden layer gets information from all nodes of the previous layer and feeds its output to all nodes of the subsequent layer. Given a set of features and a target, Deep Neural Networks can learn and approximate complex nonlinear functions for both regression and classification, in a supervised fashion using the backpropagation technique.

Note

  * The number of parameters of Deep Neural Networks make them prone to overfitting when trained on small amounts of data. Using the Early stopping parameter can help generalise better.

  * The reproducibility of results across multiple trainings is not guaranteed.




Parameters:

  * **Hidden layers** : Number of hidden layers in the network.

  * **Units per layer** : Number of neurons in each hidden layer. All layers will have the same number of units.

  * **Learning Rate** : Learning rate for gradient descent.

  * **Early stopping** : Use built-in early stopping mechanism to optimize the number of epochs The cross-validation scheme defined in the “Hyperparameters” tab will be used.

  * **Early stopping patience** : Number of epochs to wait for improvement of the monitor value until the training process is stopped.

  * **Early stopping threshold** : Ignore score improvements smaller than threshold.

  * **Batch size** : Number of training samples processed before the internal model parameters are updated.

  * **Dropout** : Regularization that randomly zeros elements of the hidden layers input. The dropout value is the probability of an element to be zeroed.

  * **L2 regularization** : L2 regularization adds penalty to high-valued weights and biases in the network by forcing them to be small.

  * **L1 regularization** : L1 regularization adds penalty to weights in the network by shrinking them towards 0. It can lead to ignoring some neurons.




### (Regression) Generalized Linear Models

Generalized Linear Models (GLMs) are a generalization of the Ordinary Linear Regression where:

  * The distribution of the response variable can be chosen from any exponential distribution (not only a gaussian distribution).

  * The relationship between the linear model and the response variable can be chosen from any link function (not only the identity function).




These models allow flexibility on the dependency between the regressors and the response and are widely used in the Insurance industry to answer specific modelization needs. The GLM implementation comes from glum package. Regression Splines rely on patsy.

For GLM, DSS also supports custom views and recipes.

This capability is provided by the “GLM” plugin, which you need to install. Please see [Installing plugins](<../../plugins/installing.html>). This plugin is [Not supported](<../../troubleshooting/support-tiers.html>).

Please see our [GLM plugin page](<https://www.dataiku.com/product/plugins/glm/>) for detailed documentation.

### (Regression & Classification) Custom Models

You can make custom models using Python. Your custom models should be scikit-learn compatible:

  * They must implement the methods `fit` and `predict`.

  * They must subclass `sklearn.base.BaseEstimator`.

  * They must receive the parameters of the `__init__` function as explicit keyword arguments




Warning

Classes cannot be declared directly in the Models > Design tab. They must be packaged in a [library](<../../python/reusing-code.html>) and imported, as demonstrated in the examples below.

For more details and advanced examples, please refer to Advanced Custom Models.

#### Regression

##### Example

  * On the Models > Design > Algorithms tab, in the “Custom python model” code editor, you should create the `clf` variable.

> from custom_python_model import MyRandomRegressor
>         
>         clf = MyRandomRegressor()
>         

  * In `custom_python_model.py`:

> from sklearn.base import BaseEstimator
>         import numpy as np
>         import pandas as pd
>         
>         class MyRandomRegressor(BaseEstimator):
>             """This model predicts random values between the mininimum and the maximum of y"""
>         
>             def fit(self, X, y):
>                 self.y_range = [np.min(y), np.max(y)]
>         
>             def predict(self, X):
>                 return np.random.uniform(self.y_range[0], self.y_range[1], size=X.shape[0])
>         




#### Classification

In addition to `fit` and `predict`, a classifier must also have a `classes_` attribute, and it can implement a `predict_proba` method.

##### Example

  * On the Models > Design > Algorithms tab, in the “Custom python model” code editor, you should create the `clf` variable.

> from custom_python_model import MyRandomClassifier
>         
>         clf = MyRandomClassifier()
>         

  * In `custom_python_model.py`:

> from sklearn.base import BaseEstimator
>         import numpy as np
>         import pandas as pd
>         
>         class MyRandomClassifier(BaseEstimator):
>             """This model predicts classes randomly"""
>         
>             def fit(self, X, y):
>                 self.classes_ = list(set(y))
>         
>             def predict(self, X):
>                 return np.random.choice(self.classes_, size=X.shape[0])
>         
>             def predict_proba(self,X):
>                 return np.random.rand(X.shape[0], len(self.classes_))
>         




Note

For linear binary classification models, it is possible to display the fitted regression coefficients in the “Regression coefficients” tab of the model report. To do so, you need to specify them using the scikit-learn approach, i.e. the custom classifier must satisfy the following conditions:

  * The classifier has attributes `coef_` and `intercept_`.

  * These attributes are either of type `numpy.ndarray` or `list`.

  * These attributes only have one row (i.e. `coef_.shape[0] == 1`, or `len(coef_) == 1` if of type `list`, and same thing for `intercept_`).

  * `len(clf.coef_[0])` is equal to the number of preprocessed features (i.e. the number of columns in the train dataframe).




### (Regression & Classification) Plugin Models

You can also build and use plugin models using Python.

See [Component: Prediction algorithm](<../../plugins/reference/prediction-algorithms.html>) for more details.

## Time series forecasting algorithms

Time series forecasting algorithms rely on the [GluonTS](<https://ts.gluon.ai/>), [pmdarima](<https://alkaline-ml.com/pmdarima/>), [statsmodels](<https://www.statsmodels.org>), [statsforecast](<https://nixtlaverse.nixtla.io/statsforecast/index.html>), [neuralforecast](<https://nixtlaverse.nixtla.io/neuralforecast/index.html>) and [prophet](<https://facebook.github.io/prophet/>) libraries.

Note

Classical ML algorithms can also be used for time series forecasting when combined with **time-aware feature generation**. The following regression algorithms support this capability:

  * Random Forest Regression

  * XGBoost Regression

  * LightGBM Regression

  * Ridge Regression




These algorithms require external features with configured shifts and/or rolling windows. See the [feature generation settings](<https://doc.dataiku.com/dss/latest/machine-learning/time-series-forecasting/settings.html#settings-feature-generation>) documentation for details on configuring time-aware feature generation, which creates lagged features and rolling window aggregates that allow machine learning models to capture temporal patterns.

### Trivial identity

Trivial identity uses the last values in the forecasting horizon to predict the future.

### Seasonal naive

Seasonal naive uses the values from previous season to predict the future.

Parameters:

  * **Season length:** Number of time steps in each season. Higher values increase training time.




### AutoARIMA

AutoARIMA automatically finds the optimal ARIMA (AutoRegressive Integrated Moving Average) model according to an information criterion. It performs a search over the model orders within given constraints, and selects the set of parameters that optimizes the provided information criterion. Note that AutoARIMA may be slow for multiple time series, because it trains as many models as there are time series.

Parameters:

  * **Stationary time series:** If checked, specifies that the time series is known to be stationary; otherwise not known _a priori_ , so the model should auto-detect stationarity.

  * **p:** p is the order (number of time lags) of the auto-regressive (AR) model.

  * **First-differencing order (d):** Degree of differencing. ARIMA models that include differencing (i.e. when d is positive) assume that the data becomes stationary after differencing. If no value is provided, the value will automatically be selected based on the results of the unit root test; the runtime might be significantly longer.

>     * **Maximum value of d**

  * **Unit root test:** Type of test to use to detect stationarity. (Kwiatkowski–Phillips–Schmidt–Shin, Augmented Dickey Fuller, Phillips-Perron)

  * **q:** q is the order (number of time lags) of the moving-average (MA) model.

  * **Season length (m):** Number of time steps in each season. Season length can greatly impact the outcome. For higher values training time is increased; the model might not even converge.

  * **P:** P is the order of the auto-regressive (AR) part of the seasonal model.

  * **Seasonal differencing term (D):** If no value is provided, the value will automatically be selected based on the results of the seasonal unit root test.

>     * **Maximum value of D**

  * **Seasonal unit root test:** Type of test to use to detect seasonality. (Osborn-Chui-Smith-Birchenhall, Canova-Hansen)

  * **Q:** Q is the order of the moving-average (MA) part of the seasonal model.

  * **Upper bound for orders:** Allows to limit the search space: ARIMA models where p + q + P + Q is greater than the given value will not be fitted. Must be strictly greater than the sum of the starting values of each order.

  * **Maximum iterations:** Maximum number of function evaluations during the search of the best ARIMA model orders.

  * **Information criterion:** Information criterion minimized to find the best ARIMA model. (Akaike, Corrected Akaike, Bayes, Hannan-Quinn, “Out-of-bag” score)

  * **Solver method:** Determines which solver from scipy.optimize is used: Newton-Raphson, Nelder-Mead, Broyden-Fletcher-Goldfarb-Shanno, Limited-memory BFGS, Powell, Conjugate gradient, Newton conjugate gradient, or Global basin-hopping.




### ARIMA

ARIMA (AutoRegressive Integrated Moving Average) is a statistical model used for time series forecasting. It combines autoregression (AR), differencing to achieve stationarity (I), and a moving average component (MA) to capture dependencies in data over time. Additionally, it supports seasonal components (S) to model seasonal patterns and exogenous variables (X) to incorporate external factors that influence the forecast.

Parameters:

  * **p:** p is the order (number of time lags) of the auto-regressive (AR) model.

  * **d:** Degree of differencing. ARIMA models that include differencing (i.e. when d is positive) assume that the data becomes stationary after differencing.

  * **q:** q is the order (number of time lags) of the moving-average (MA) model.

  * **P:** P is the order of the auto-regressive (AR) part of the seasonal model.

  * **D:** Degree of seasonal differencing. Seasonal ARIMA models that include differencing (i.e. when D is positive) assume that the data becomes stationary after differencing.

  * **Q:** Q is the order of the moving-average (MA) part of the seasonal model.

  * **s:** s is the season length of the model.

  * **Trend:** Deterministic trend of the model.

  * **Enforce stationarity:** Require the autoregressive parameters to match a stationary process.

  * **Enforce invertibility:** Require the moving average parameters to match an invertible process.

  * **Concentrate scale:** Whether or not to concentrate the variance of the error term out of the likelihood.




### Croston

The Croston method is designed for forecasting intermittent demand time series with frequent zeros or sporadic observations. It produces a constant forecast value repeated across the entire forecasting horizon.

Croston works by separately estimating the demand size and the time between demand occurrences, making it particularly suitable for inventory management and supply chain forecasting scenarios with irregular demand patterns.

Parameters:

  * **Variant:** The Croston variant to use. Multiple variants can be selected for hyperparameter optimization:

    * **Classic:** The original Croston method without bias correction

    * **SBA (Syntetos-Boylan Approximation):** Applies bias correction to address Croston’s tendency to over-forecast

    * **TSB (Teunter-Syntetos-Babai):** An alternative formulation with separate smoothing parameters

  * **Alpha_d:** Smoothing parameter for demand (only for TSB variant). Controls how quickly the model adapts to changes in demand size. Values range from 0 to 1, with higher values giving more weight to recent observations.

  * **Alpha_p:** Smoothing parameter for probability (only for TSB variant). Controls how quickly the model adapts to changes in demand occurrence probability. Values range from 0 to 1.




### Seasonal trend

Seasonal trend first subtracts the data seasonality estimated with STL (Seasonal and Trend decomposition using Loess). It then forecasts the deseasonalized data using an Exponential Smoothing model adjusted for trends.

Parameters:

  * **Season length:** Number of time steps in each season, must be strictly greater than 1. Season length can greatly impact the outcome. Higher values increase training time.

  * **Seasonal smoother length:** Must be an odd integer. Recommended value should be greater or equal to 7.

  * **Trend smoother length:** Must be an odd integer, strictly greater than the season length.

>     * **Use default trend smoother length:** If enabled, use the smallest odd integer greater than (1.5 * season length) / (1 - 1.5 / seasonal smoother length).

  * **Low pass filter length:** Must be an odd integer.

>     * **Use default low pass filter length:** If enabled, use the smallest odd integer strictly greater than the season length.

  * **Degree of seasonal LOESS:** Degree of the LOESS smoothing polynomial for the seasonal component: constant or linear (i.e. constant and trend).

  * **Degree of trend LOESS:** Degree of the LOESS smoothing polynomial for the trend component: constant or linear (i.e. constant and trend).

  * **Degree of low pass LOESS:** Degree of the LOESS smoothing polynomial for the low pass component: constant or linear (i.e. constant and trend).

  * **Seasonal jump:** Seasonal linear interpolation step. LOESS smoothing is used every _seasonal_jump_ steps and values between two steps are linearly interpolated. Higher values reduce estimation time.

  * **Trend jump:** Trend linear interpolation step. LOESS smoothing is used every _trend_jump_ steps and values between two steps are linearly interpolated. Higher values reduce estimation time.

  * **Low pass filter jump:** Low pass filter linear interpolation step. LOESS smoothing is used every _low_pass_jump_ steps and values between two steps are linearly interpolated. Higher values reduce estimation time.




### ETS

ETS (Error, Trend, Seasonality) is a forecasting model that decomposes a time series into error, trend, and seasonal components.

Parameters:

  * **Error:** Options are Multiplicative (M) and Additive (A).

  * **Trend:** Options are Multiplicative (M), Additive (A) and None (N).

  * **Damped trend:** Whether to try regular trend, or damped trend (d).

  * **Seasonality:** Options are Multiplicative (M), Additive (A) and None (N).

  * **Season length:** Number of time steps in a season.

  * **Random state:** Using a fixed random seed allows for reproducible result.

  * **Unstable models:** Several parameter combinations are known to be unstable (AMN, AMA, AMdN, AMdA, AMM, AMdM, MMA, MMdA, ANM, AAM, AAdM) and are excluded by default from the hyperparameter search. This allows them to be included.




### Prophet

Prophet is a procedure for forecasting time series data based on an additive model where non-linear trends are fit with yearly, weekly, and daily seasonality. It works best with time series that have strong seasonal effects and several seasons of historical data.

Parameters:

  * **Changepoint prior scale:** Parameter modulating the flexibility of the automatic changepoint selection. Large values will allow many changepoints, small values will allow few changepoints.

  * **Growth:** Specify a linear, logistic or flat trend.

  * **Seasonality prior scale:** Parameter modulating the strength of the seasonality model. Larger values allow the model to fit larger seasonal fluctuations, smaller values dampen the seasonality.

  * **Seasonality mode:** _Additive_ or _Multiplicative_.

  * **Yearly seasonality:** _Auto_ , _Always_ or _Never_. Use a Fourier decomposition to fit the yearly seasonality (_Auto_ means only when input data is longer than 2 years).

  * **Weekly seasonality:** _Auto_ , _Always_ or _Never_. Use a Fourier decomposition to fit the weekly seasonality (_Auto_ means only when input data is longer than 2 weeks).

  * **Daily seasonality:** _Auto_ , _Always_ or _Never_. Use a Fourier decomposition to fit the daily seasonality (_Auto_ means only when input data is longer than 2 days).

  * **External features prior scale:** Parameter modulating the strength of the external features components model (only used when external features are selected).

  * **Changepoint range:** Proportion of history in which trend changepoints will be estimated.

  * **Number of changepoints:** Potential changepoints are selected uniformly from the first _Changepoint range_ proportion of the history.

  * **Random state:** Using a fixed random seed allows for reproducible result.




Note

Prophet is only available for python 3.7+ code environments.

### Non-Parametric Time Series

The Non-Parametric Time Series predictor predicts future values by sampling from past observations. The sampling weights can follow either a uniform or exponentially decreasing distribution, and optionally take into account the seasonality of the time series.

For a **non-seasonal** NPTS model, past observations can be sampled using a uniform distribution, or an exponential distribution whose probability decreases with the time distance to the observation (recent observations thus have a higher probability to be sampled than distant past ones).

For a **seasonal** NPTS model, time features based on the frequency of the time series are computed. Past observations can either be sampled using a uniform distribution amongst observations with the same values for the computed time features, or using an exponential distribution whose probability decreases with both the time distance to the past observation and the distance w.r.t. computed time features. External features can also be used along with, or instead of, the computed time features.

Parameters:

  * **Context length:** Number of considered time steps before making predictions.

>     * **Use default context length:** If enabled, use the model’s default context length (1100).

  * **Kernel type:** Exponential or Uniform.

  * **Exponential kernel weight:** Single weight for the features to use in the exponential kernel.

  * **Use a seasonal model:** If enabled, time features determined based on the frequency of the time series are added to the default feature map.

>     * **Use default time features:** Provide extra time features computed based on the frequency of the time series (minute of hour for minutely, hour of day for hourly…). For a seasonal model, the default time features are always used when no external features have been provided.
> 
>     * **Feature scale:** Multiplicative scale to apply on time features (custom and/or default). This allows to sample past seasons with higher probability.




### Simple Feed Forward

Simple Feed Forward is a simple neural network that forecasts probability distributions for the next forecasting horizon values, given the preceding context length values.

Training parameters:

  * **Learning rate:** Initial learning rate (decays during training).

  * **Batch size:** The size of the batches to be used for training and prediction.

  * **Epochs:** Number of epochs to be trained.

  * **Number of batches per epoch**

>     * **Use default nb. of batches per epoch:** If enabled, use the number for which each time step appears in one sample per epoch on average.




Model parameters:

  * **Context length:** Number of considered time steps before making predictions.

>     * **Use default context length:** If enabled, use the model’s default value (equal to the forecasting horizon).

  * **Output distribution:** Distribution to fit. (Student’s t-distribution, Gaussian distribution, Negative binomial distribution)

  * **Batch normalization:** Normalize the layers’ inputs by re-centering and re-scaling. This can make deep neural networks faster and more stable.

  * **Mean scaling:** Scale the network input by the data mean and the network output by its inverse.

  * **Hidden layer sizes:** Number of nodes in each hidden layer. Specify one value per layer.

  * **Number of parallel samples:** Number of evaluation samples per time series to increase parallelism during inference.




### DeepAR

DeepAR is an autoregressive recurrent neural network that forecasts probability distributions for the next forecasting _horizon values_ given the preceding _context length_ values. It also uses lagged values and time features, automatically computed based on the selected time frequency.

Training parameters:

  * **Learning rate:** Initial learning rate (decays during training).

  * **Batch size** , for training and prediction.

  * **Epochs:** Number of epochs to be trained.

  * **Number of batches per epoch**

>     * **Use default nb. of batches per epoch:** If enabled, use the number for which each time step appears in one sample per epoch on average.




Model parameters:

  * **Context length:** Number of considered time steps before making predictions.

>     * **Use default context length:** If enabled, use the model’s default value (equal to the forecasting horizon).

  * **Output distribution:** Distribution to fit. (Student’s t, Gaussian, Negative binomial)

  * **Encode identifiers:** Encode time series identifiers and use them as external features (_feat_static_cat_ in GluonTS).

  * **Number of RNN layers**

  * **Number of cells per layer**

  * **Cell type:** Long short-term memory (LSTM) or Gated recurrent unit (GRU).

  * **Dropout cell type:** ZoneoutCell, RNNZoneoutCell, VariationalDropoutCell, or VariationalZoneoutCell.

  * **Dropout regularization parameter**

  * **Alpha:** Scaling coef. of activation regularization.

  * **Beta:** Scaling coef. of temporal activation regularization.

  * **Scale target values:** For each time series, rescale the target by its average absolute value.

  * **Minimum scale:** Default scale (used if the time series has only zeros).

  * **Number of parallel samples:** Number of evaluation samples per time series, to increase parallelism during inference.




### Transformer

Transformer estimator is a transformer neural network that forecasts probability distributions for the next _forecasting horizon_ values, given the preceding _context length_ values. It also uses lagged values and time features, automatically computed based on the selected time frequency.

Training parameters:

  * **Learning rate:** Initial learning rate (decays during training).

  * **Batch size** , for training and prediction.

  * **Epochs:** Number of epochs to be trained.

  * **Number of batches per epoch**

>     * **Use default nb. of batches per epoch:** If enabled, use the number for which each time step appears in one sample per epoch on average.




Model parameters:

  * **Context length:** Number of considered time steps before making predictions.

>     * **Use default context length:** if enabled, use the model’s default value (equal to the forecasting horizon).

  * **Output distribution:** Distribution to fit. (Student’s t, Gaussian, Negative binomial)

  * **Encode identifiers:** Encode time series identifiers and use them as external features (_feat_static_cat_ in GluonTS).

  * **Transformer network dimension:** Embedding dimension of the input.

  * **Dimension scale of hidden layer:** Dimension scale of the inner hidden layer of the transformer’s feedforward network.

  * **Number of heads in the multi-head attention**

  * **Dropout regularization parameter**

  * **Number of parallel samples:** Number of evaluation samples per time series, to increase parallelism during inference.




### Multi-horizon Quantile - Convolutional Neural Network (MQ-CNN)

MQ-CNN (Multi-horizon Quantile - Convolutional Neural Network) is a convolutional neural network that uses a quantile decoder to make predictions for the next _forecasting horizon_ values given the preceding _context length_ values. It also uses time features, automatically computed based on the selected time frequency. The model forecasts the same quantiles as the ones selected for the evaluation metrics.

Training parameters:

  * **Learning rate:** Initial learning rate (decays during training).

  * **Batch size** , for training and prediction.

  * **Epochs:** Number of epochs to be trained.

  * **Number of batches per epoch**

>     * **Use default nb. of batches per epoch:** If enabled, use the number for which each time step appears in one sample per epoch on average.




Model parameters:

  * **Context length:** Number of considered time steps before making predictions.

>     * **Use default context length:** If enabled, use the model’s default value (equal to the forecasting horizon).

  * **Encode identifiers:** Encode time series identifiers and use them as external features (_feat_static_cat_ in GluonTS).

  * **MLP layer sizes:** Dimensions of the Multi Layer Perceptron layers of the decoder. Use one value per layer.

  * **Number of channels:** Number of channels for each layer of the encoder (which is a stack of dilated convolutions). Specify one value per layer. More channels usually means better performance and larger network size.

  * **Convolution dilations:** Dilation of the convolutions in each layer of the encoder. Specify one value per layer. Should be of same length as the number of channels. Greater numbers correspond to a greater receptive field of the network, which is usually better with longer context lengths.

  * **Kernel sizes:** Kernel sizes (i.e. window sizes) of the convolutions in each layer of the encoder. Specify one value per layer. Should be of same length as the number of channels.

  * **Scale target values:** For each time series, rescale the target by its average absolute value.




### N-HiTS

N-HiTS (Neural Hierarchical Interpolation For Time Series) is a neural network architecture designed for efficient and accurate time series forecasting. It uses hierarchical interpolation and multi-rate sampling to capture patterns at multiple temporal scales, making it effective for both short and long-term forecasting.

N-HiTS supports external features and can leverage both past-only and known in advance external features.

Training parameters:

  * **Learning rate:** Initial learning rate for gradient descent optimization. Lower values lead to more stable but slower training. Typical values: 0.0001 - 0.01. This parameter can be optimized.

  * **Patience:** Number of validation iterations to wait for improvement before early stopping. Set to -1 for no early stopping (train for max_steps iterations).

  * **Max steps:** Maximum number of training iterations. Training will stop early if patience criterion is met.

  * **Batch size:** Number of time series samples processed simultaneously during training and prediction. Larger values speed up training but require more memory.

  * **Random state:** Seed value for reproducibility of results.




Model parameters:

  * **Context length:** Number of historical time steps used to make predictions. Longer context allows the model to capture longer-term patterns but increases computational cost. This parameter can be optimized.




### TFT (Temporal Fusion Transformer)

TFT (Temporal Fusion Transformer) is a deep learning architecture that combines LSTM layers for sequential processing with multi-head attention mechanisms to capture complex temporal dependencies. It excels at multi-horizon forecasting and provides interpretable predictions by identifying important time steps and features.

TFT supports external features and can leverage both past-only and known in advance external features, making it suitable for scenarios where some covariates are known in advance (e.g., planned promotions, holidays).

Training parameters:

  * **Learning rate:** Initial learning rate for gradient descent optimization. Lower values lead to more stable but slower training. Typical values: 0.0001 - 0.01. This parameter can be optimized.

  * **Patience:** Number of validation iterations to wait for improvement before early stopping. Set to -1 for no early stopping (train for max_steps iterations).

  * **Max steps:** Maximum number of training iterations. Training will stop early if patience criterion is met.

  * **Batch size:** Number of time series samples processed simultaneously during training and prediction. Larger values speed up training but require more memory.

  * **Random state:** Seed value for reproducibility of results.




Model parameters:

  * **Context length:** Number of historical time steps used to make predictions. This parameter can be optimized.

  * **Number of RNN (LSTM) layers:** Number of stacked LSTM layers for temporal processing. More layers can capture more complex patterns but increase training time and risk of overfitting. This parameter can be optimized.

  * **Number of attention heads:** Number of parallel attention mechanisms. More heads allow the model to focus on different aspects of the input simultaneously. This parameter can be optimized.

  * **Hidden size factor:** Multiplier applied to the number of attention heads to compute the hidden layer size. The actual hidden size equals n_head × hidden_size_factor. This parameter can be optimized.

  * **Limit hidden size value:** Whether to skip hyperparameter search points that would result in hidden sizes above a threshold, to avoid memory issues.

  * **Maximum hidden size value:** The threshold for hidden size when limiting is enabled.




## Clustering algorithms

### K-means

The k-means algorithm clusters data by trying to separate samples in _n_ groups, minimizing a criterion known as the ‘inertia’ of the groups.

Parameters:

  * **Number of clusters:** This parameter can be optimized.

  * **Seed:** Used to generate reproducible results. 0 or no value means that no known seed is used (results will not be fully reproducible)

  * **Parallelism:** Number of cores used for parallel training. Using more cores leads to faster training but at the expense of more memory consumption. If -1 all CPUs are used. For values below -1, (n_cpus + 1 + value) are used: ie for -2, all CPUs but one are used.




### Gaussian Mixture

The Gaussian Mixture Model models the distribution of the data as a “mixture” of several populations, each of which can be described by a single multivariate normal distribution.

An example of such a distribution is that of sizes among adults, which is described by the mixture of two distributions: the sizes of men, and those of women, each of which is approximately described by a normal distribution.

Parameters:

  * **Number of mixture components:** Number of populations. This parameter can be optimized.

  * **Max Iterations:** The maximum number of iterations to learn the model. The Gaussian Mixture model uses the Expectation-Maximization algorithm, which is iterative, each iteration running on all of the data. A higher value of this parameter will lead to a longer running time, but a more precise clustering. A value between 10 and 100 is recommended.

  * **Seed:** Used to generate reproducible results. 0 or no value means that no known seed is used (results will not be fully reproducible)




### Mini-batch K-means

The Mini-Batch k-means is a variant of the k-means algorithm which uses mini-batches to reduce the computation time, while still attempting to optimise the same objective function.

Parameters:

  * **Numbers of clusters:** This parameter can be optimized.

  * **Seed:** Used to generate reproducible results. 0 or no value means that no known seed is used (results will not be fully reproducible)




### Agglomerative Clustering

Hierarchical clustering is a general family of clustering algorithms that build nested clusters by merging them successively. This hierarchy of clusters represented as a tree (or [dendrogram](<http://en.wikipedia.org/wiki/Dendrogram>)). The root of the tree is the unique cluster that gathers all the samples, the leaves being the clusters with only one sample.

Parameters:

  * **Numbers of clusters:** This parameter can be optimized.




### Spectral Clustering

Spectral clustering algorithm uses the graph distance in the nearest neighbor graph. It does a low-dimension embedding of the affinity matrix between samples, followed by a k-means in the low dimensional space.

Parameters:

  * **Numbers of clusters:** This parameter can be optimized.

  * **Affinity measure:** The method to computing the distance between samples. Possible options are nearest neighbors, RBF kernel and polynomial kernel.

  * **Gamma:** Kernel coefficient for RBF and polynomial kernels. Gamma defines the ‘influence’ of each training example in the features space. A low value of gamma means that each example has ‘far-reaching influence’, while a high value means that each example only has close-range influence. If no value is specified (or 0.0), then 1/nb_features is used.

  * **Coef0:** Independent term for ‘polynomial’ or ‘sigmoid’ kernel function.

  * **Seed:** Used to generate reproducible results. 0 or no value means that no known seed is used (results will not be fully reproducible)




### DBSCAN

The DBSCAN algorithm views clusters as areas of high density separated by areas of low density. Due to this rather generic view, clusters found by DBSCAN can be any shape, as opposed to k-means which assumes that clusters are convex shaped. Numerical features should use standard rescaling.

There are two parameters that you can modify in DBSCAN:

  * **Epsilon:** Maximum distance to consider two samples in the same neighborhood. You can try several values by using a comma-separated list

  * **Min. Sample ratio:** Minimum ratio of records in its neighborhood for a point to be considered as a core point. This includes the point itself. If set to a higher value, DBSCAN will find denser clusters, whereas if it is set to a lower value, the found clusters will be more sparse.




### HDBSCAN

HDBSCAN is an algorithm built on top of DBSCAN, by exploring values of its main hyperparameter (max distance for points to be considered neighbors). Hence, HDBSCAN builds clusters as areas of high density separated by areas of low density. Due to this rather generic view, clusters found by HDBSCAN can be any shape, as opposed to k-means which assumes that clusters are convex shaped. Numerical features should use standard rescaling.

There is one parameter that you can modify in HDBSCAN:

  * **Min. cluster ratio:** Minimum ratio of records to form a cluster. Groupings smaller than this size will be left as noise. You can try several values




### Interactive Clustering (Two-step clustering)

Interactive clustering is based on a two-step clustering algorithm. This two-staged algorithm first agglomerates data points into small clusters using K-Means clustering. Then, it applies agglomerative hierarchical clustering in order to further cluster the data, while also building a hierarchy between the smaller clusters, which can then be interpreted. It therefore allows to extract hierarchical information from datasets larger than a few hundred lines, which cannot be achieved through standard methods. The clustering can then be manually adjusted in DSS’s interface.

Parameters:

  * **Number of Pre-clusters:** The number of clusters for KMeans preclustering. It is recommended that this number be lower than a couple hundred for readability.

  * **Number of clusters:** The number of clusters in the hierarchy. The full hierarchy will be built and displayed, but these clusters will be used for scoring.

  * **Max Iterations:** The maximum number of iterations for preclustering. KMeans is an iterative algorithm. A higher value of this parameter will lead to a longer running time, but a more precise pre-clustering. A value between 10 and 100 is recommended.

  * **Seed:** Used to generate reproducible results. 0 or no value means that no known seed is used (results will not be fully reproducible)




### Isolation Forest (Anomaly Detection)

Isolation forest is an anomaly detection algorithm. It isolates observations by creating a Random Forest of trees, each splitting samples in different partitions. Anomalies tend to have much shorter paths from the root of the tree. Thus, the mean distance from the root provides a good measure of non-normality.

Parameters:

  * **Number of trees:** Number of trees in the forest.

  * **Contamination:** Expected proportion of anomalies in the data.

  * **Anomalies to display:** Maximum number of anomalies to display in the model report. Too high a number may cause memory and UI problems.




### Custom Clustering Models

You can make custom models using Python. Your custom models should be scikit-learn compatible:

  * They must implement the methods `fit` and `predict`.

  * They must subclass `sklearn.base.BaseEstimator`.

  * They must receive the parameters of the `__init__` function as explicit keyword arguments

  * `predict` must return a ndarray of cluster ids >= 0




For clustering tasks, the number of clusters can be passed to the model through the interface.

Moreover, the model should implement the method `fit_predict(self, X)`, in addition to `fit(self, X)` and `predict(self, X)`.

Warning

Classes cannot be declared directly in the Models > Design tab. They must be packaged in a [library](<../../python/reusing-code.html>) and imported, as demonstrated in the examples below.

For more details and advanced examples, please refer to Advanced Custom Models.

#### Example

  * On the Models > Design > Algorithms tab, in the “Custom python model” code editor, you should create the `clf` variable.

> from custom_python_model import MyRandomClusteringModel
>         
>         clf = MyRandomClusteringModel()
>         

  * In `custom_python_model.py`:

> from sklearn.base import BaseEstimator
>         import numpy as np
>         import pandas as pd
>         
>         class MyRandomClusteringModel(BaseEstimator):
>             """This model assigns clusters randomly"""
>         
>             def fit(self, X):
>                 pass
>         
>             def predict(self, X):
>                 return np.random.choice([0, 1, 2], size=X.shape[0])
>         
>             def fit_predict(self, X):
>                 return np.random.choice([0, 1, 2], size=X.shape[0])
>         




## Advanced Custom Models

This section shows advanced concepts for building custom models.

For simple use cases, please refer to:

  * Custom models for regression

  * Custom models for classification

  * Custom models for clustering




### Handling parameters

The estimator must be clonable by `sklearn.base.clone()` which only clones attributes that have constructor arguments with the same name.

Therefore, when using parameters at the class level, custom models should always:

  * receive the parameters of the `__init__` function as explicit keyword arguments

  * implement `get_params(deep=True)` and `set_params(**params)`




These methods can either be implemented manually or by having the class extend `sklearn.base.BaseEstimator`.

### Retrieving column names in the custom model

In order to have access to the column names of the preprocessed dataset (i.e. `X` in the functions `fit` and `predict`), a method `set_column_labels(self, column_labels)` can be implemented in the model. If this method exists, DSS will automatically call it and provide the list of the column names as argument.

Warning

The column labels passed to the function `set_column_labels` are the labels of the prepared and preprocessed columns resulting from the preparation script followed by features handling. Hence, their name may not correspond to the original columns of the dataset. For instance, if automatic pairwise linear combinations were enabled, some columns may take the form: `pw_linear:<A>+<B>`. To find the exact name of the columns, it is advisable to print the column labels received in `set_column_labels`.

#### Example

  * On the Models > Design > Algorithms tab, in the “Custom python model” code editor, you should create the `clf` variable.

> from custom_python_model import MyCustomRegressor
>         
>         important_column_name = ...
>         clf = MyCustomRegressor(important_column_name)
>         

  * In `custom_python_model.py`:

> from sklearn.base import BaseEstimator
>         
>         class MyCustomRegressor(BaseEstimator):
>         
>             def __init__(self, important_column=None, column_labels=None):
>                 self.important_column = important_column
>                 self.column_labels = column_labels
>         
>             def set_column_labels(self, column_labels):
>                 # in order to preserve the attribute `column_labels` when cloning
>                 # the estimator, we have declared it as a keyword argument in the
>                 # `__init__` and set it there
>                 self.column_labels = column_labels
>         
>             def fit(self, X, y):
>                 if self.important_column is not None:
>                     # Retrieve the index of the important column
>                     column_index = self.column_labels.index(self.important_column)
>         
>                     # Retrieve the corresponding data column
>                     column = X[:, column_index]
>         
>                 # Finish the implementation of the fit function
>                 ...
>         
>             def predict(self, X):
>                 # Implement the predict function
>                 ...
>         




#### Advanced example: Setting monotonicity constraints

The following example uses XGBoost and shows how to set monotonicity constraints on specific columns given their name.

  * On the Models > Design > Algorithms tab, in the “Custom python model” code editor, you should create the `clf` variable.

> from constrained_python_model import MyConstrainedRegressor
>         
>         clf = MyConstrainedRegressor(["important_column"])
>         

  * In `constrained_python_model.py`:

> from xgboost import XGBRegressor
>         from sklearn.base import BaseEstimator
>         import numpy as np
>         
>         class MyConstrainedRegressor(BaseEstimator):
>         
>             def __init__(self, monotone_column_labels=None, column_labels=None, xgb_regressor=None):
>                 if monotone_column_labels is None:
>                     self.monotone_column_labels = []
>                 else:
>                     self.monotone_column_labels = monotone_column_labels
>                 self.column_labels = column_labels
>                 if xgb_regressor is None:
>                     self.xgb_regressor = XGBRegressor()
>                 else:
>                     self.xgb_regressor = xgb_regressor
>         
>             def set_column_labels(self, column_labels):
>                 # in order to preserve the attribute `column_labels` when cloning
>                 # the estimator, we have declared it as a keyword argument in the
>                 # `__init__` and set it there
>                 self.column_labels = column_labels
>         
>             def fit(self, X, y):
>                 # Init the constraints array
>                 monotone_constraints = np.zeros(X.shape[1], int)
>         
>                 for monotone_column_label in self.monotone_column_labels:
>                     # Retrieve the index of the column that should be monotonic
>                     # NB: the corresponding data would then be X[:, monotone_column_index]
>                     monotone_column_index = self.column_labels.index(monotone_column_label)
>         
>                     # Set the increasing monotonic constraint for the corresponding column
>                     monotone_constraints[monotone_column_index] = 1
>         
>                 # Convert the list into a XGBoost-compatible parameter
>                 stringified_monotone_constraints = "(" + ",".join(map(str, monotone_constraints)) + ")"
>         
>                 # Instantiate and fit the XGBoost model
>                 self.xgb_regressor.set_params(monotone_constraints=stringified_monotone_constraints)
>                 self.xgb_regressor.fit(X, y)
>         
>             def predict(self, X):
>                 return self.xgb_regressor.predict(X)
>         




### Creating a custom clustering model using the isolation forest algorithm

To create a custom clustering model using the isolation forest algorithm, make sure to map values from -1, 1 to 0, 1.

> 
>     from sklearn.ensemble import IsolationForest
>     
>     class CustomIsolationForest(IsolationForest):
>     
>         def get_cluster_labels(self):
>             return["regular", "anomalies"]
>     
>         def predict(self, X):
>             scored = super(CustomIsolationForest, self).predict(X)
>             scored[scored == 1] = 0  # "regular" cluster
>             scored[scored == -1] = 1  # "anomalies" cluster
>             return scored
>     
>     clf = CustomIsolationForest(n_estimators=100, random_state=0)
>     

## XGBoost models upgrade macros

[In Dataiku 13](<../../release_notes/13.html#releases-notes-13-limitations-xgboost>), XGBoost versions 1.5, 1.6, and 1.7 are now supported.

When upgrading, Dataiku automatically updates its base environment to use the most recent supported version available for its base Python version.

This upgrade is breaking for XGBoost models in:

  * evaluate recipes

  * scoring recipes without [Optimized scoring](<../scoring-engines.html>)

  * row-level explanations

  * plugin-provided model views




In order to work around all possible issues, we provide [macros (through a plugin)](<https://www.dataiku.com/product/plugins/xgboost-version-bump/>) to upgrade saved models to a format compatible with all our supported XGBoost versions. This plugin is safe to run on all models on your instances, whether or not the backing code environment of your model has changed.

---

## [machine-learning/algorithms/index]

# Algorithms reference

DSS’s visual machine learning comes with support for 2 different Machine Learning engines:

Each time you create a new machine learning model in DSS, you can select the corresponding training engine. The models will be trained with this engine.

Once trained, models can be applied to new records to make predictions. This is called scoring, and is handled by various [scoring engines](<../scoring-engines.html>)

---

## [machine-learning/algorithms/mllib]

# MLLib (Spark) engine - Deprecated

[MLLib](<http://spark.apache.org/mllib/>) is Spark’s machine learning library. DSS can use it to train prediction or clustering models on your large datasets that don’t fit into memory.

Warning

The MLLib support is deprecated and will soon be removed.

Warning

Spark’s overhead is non-negligible and its support is limited (see Limitations).   
If your data fits into memory, you should use regular in-memory ML instead for faster learning and more extensive options and algorithms.

## Usage

When you create a new machine learning in an Analysis, you can select the backend. By default it’s Python in memory, but if you have [Spark correctly set up](<../../hadoop/spark.html#spark-setup>), you can also see Spark MLLib. Select it and your model will be trained on Spark, using algorithms available in MLLib or your custom MLLib-compatible models.

You can then fine-tune your model, deploy it in the Flow as a retrainable model and apply it in a scoring recipe to perform prediction on unlabelled datasets. Clustering models may also be retrained on new datasets through the cluster recipe.

In the model’s settings and the training, scoring and cluster recipes, there is an additional Spark config section, in which you can:

  * Change the base Spark configuration

  * Add / override Spark configuration options

  * Select the storage level of the dataset for caching once the data is loaded and prepared

  * Select the number of Spark RDD partitions to split non-HDFS input datasets




See [DSS and Spark](<../../spark/index.html>) for more information about Spark in Data Science Studio.

## Prediction Algorithms

DSS 14 supports the following algorithms on MLLib:

>   * Logistic Regression (classification)
> 
>   * Linear Regression (regression)
> 
>   * Decision Trees (classification & regression)
> 
>   * Random Forest (classification & regression)
> 
>   * Gradient Boosted Trees (binary classification & regression)
> 
>   * Naive Bayes (multiclass classification)
> 
>   * Custom models
> 
> 


## Clustering algorithms

DSS 14 supports the following algorithms on MLLib:

>   * KMeans (clustering)
> 
>   * Gaussian Mixtures (clustering)
> 
>   * Custom models
> 
> 


## Custom Models

Models using custom code may be trained with the MLLib backend. To train such a model,

  * Implement classes extending the `Estimator` and `Model` classes of the `org.apache.spark.ml` package. These will be the classes used to train your model: DSS will call the `fit(DataFrame)` method of your `Estimator` and the `transform(DataFrame)` method of your `Model`.

  * Package your classes and all necessary classes in a jar, and place it in the `lib/java` folder of your data directory.

  * In DSS, open your MLLib model settings and add a new custom algorithm in the algorithm list.

  * Place the initialization (scala) code for your `Estimator` into the code editor, together with any necessary `import` statements. The initialization statement should be the last to be called. Note that declaring classes (including anonymous classes) in the editor is not recommended, as it may cause serialization errors. They should therefore be compiled and put in the jar.




## Limitations

On top of the general [Spark limitations in DSS](<../../spark/limitations.html>), MLLib has specific limitations:

  * Gradient Boosted Trees in MLLib does not output per-class probabilities, so there is no threshold to set, and some metrics (AUC, Log loss, Lift) are not available, as are some report sections (variable importance, decision & lift charts, ROC curve).

  * Some feature preprocessing options are not available (although most can be achieved by other means):

    * Feature combinations

    * Numerical handling other than regular

    * Categorical handling other than dummy encoding

    * Text handling other than Tokenize, hash & count

    * Dimensionality-reduction for clustering

  * If test dataset is larger than 1 million rows, it will be subsampled to ~1M rows for performance and memory consumption reasons, since some scoring operations require sorting and collecting the whole data.

  * K-fold cross-test and hyperparameter optimization (grid search) are not supported.

  * Build partitioned models with MLLib backend is not supported

  * Post training computations like partial dependence plot and subpopulation analysis are not supported

  * Individual explanations are not supported

  * Containerized execution is not supported

  * Debugging capabilities such as Assertions and Diagnostics are not supported

  * Interactive scoring is not available

---

## [machine-learning/auto-ml]

# Automated machine learning

DSS contains a powerful automated machine learning engine that allows you to get highly optimized models with minimal intervention.

At your choice, in DSS, you can select between:

  * Having the full control over all [training settings](<supervised/settings.html>), [algorithm settings](<algorithms/index.html>) and [optimization process](<advanced-optimization.html>), including writing your own [custom models](<custom-models.html>) and using advanced [deep learning models](<deep-learning/index.html>)

  * Using DSS powerful automatic machine learning engine in order to effortlessly get models




The Automated Machine Learning engine of DSS will analyze your dataset, and depending on your preferences, select the best [features handling](<features-handling/index.html>), [algorithms](<algorithms/index.html>) and hyper parameters.

In addition to algorithms selection and optimization, the automated machine learning performs:

  * Automatic [features handling](<features-handling/index.html>), including handling of categorical and text variables, handling of missing values, scaling, …

  * Semi-automatic massive features generation

  * Optional features selection




## Creating an Automated Machine Learning model

  * Go to the Flow for your project

  * Click on the dataset you want to use

  * Select the _Lab_

  * Select _AutoML Prediction_

  * Choose your target variable (which column you want to predict)

  * Select one of the AutoML prediction styles, such as _Quick Prototypes_




### Prediction styles

The Automated Machine Learning engine allows you to choose between three main prediction styles.

#### Quick Prototypes

When selecting this prediction style, DSS will select a variety of models, prioritizing variety and speed over pure performance. The main goal of this is to quickly give you first results. It will help you decide whether you need to go further with more advanced models, or if you should first do some more feature engineering.

#### Interpretable Models

This prediction style is focused on giving “white-box” models for which it is easier to understand the predictions and the driving factors.

DSS will choose both decision trees and linear models.

Training is generally quick.

#### High Performance

When selecting this prediction style, DSS will select a variety of tree-based models with a very deep hyper-parameter optimization search. This will generally give the best possible prediction performance, at the expense of interpretability.

Training time will be strongly increased when choosing this prediction style

### Customizing an automated machine learning model

Whereas you selected “Automated machine learning” or “Expert mode”, you always keep full control over all of the [settings of your prediction model](<supervised/settings.html>), including [algorithms](<algorithms/index.html>) and [feature handling](<features-handling/index.html>)

## Feature generation

DSS can compute interactions between variables, such as linear and polynomial combinations. These generated features allow for linear methods, such as linear regression, to detect non-linear relationship between the variables and the target. These generated features may improve model performance in these cases.

See [Prediction settings](<supervised/settings.html>) for more information.

---

## [machine-learning/causal-prediction/causal-prediction-algorithms]

# Causal Prediction Algorithms

Dataiku offers two different methodologies for estimating causal effects:

## Meta-learning

Meta-learning leverages machine learning algorithms to learn the causal effect of the treatment (Conditional Average Treatment Effect or CATE). These ML models are called _base learners_. The specific way they are trained and combined is referred to as the _meta-learner_. Dataiku supports three meta-learners:

  * **S-learner** : a single model is trained with the treatment variable as an input feature. The predicted CATE is the difference between the prediction with the treatment variable set as `treated` and the prediction with the treatment variable set as `control`.

  * **T-learner** : two models are trained, one on the `treated` group, the other on the `control` group. The predicted CATE is the difference between the predictions from the two models.

  * **X-learner** :

    * Two models are trained, one on the `treated` group, the other on the `control` group (same as T-learner).

    * They are used to individually predict the counterfactual outcome (i.e. control for treated group and treated for control group), which is combined with the observed outcome to estimate the individual treatment effect.

    * Then, two other models (again, one for `treated` group and one for `control` group) are trained on the individual effects previously predicted. The CATE prediction is the average prediction of these last two models weighted by a predicted propensity (individual predicted probability of getting the treatment).




You can combine any meta-learner with any available [Python-based ML algorithm](<../algorithms/in-memory-python.html>) as a base learner.

## Causal forest

Causal Forests are tree-based ensemble models similar to [Random Forests](<../algorithms/in-memory-python.html#random-forest>). The main differences are:

  * the **value** of nodes and leaves are based on both the treatment and the outcome variables - they are an estimation of the Conditional Average Treatment Effect (CATE)

  * the **splitting criterion** is also based on both the treatment and the outcome variables

  * the **honest** framework (whenever enabled) allows using two separate subsets of the train set to compute the optimal split and the value of a node.




Parameters:

  * **Number of trees** : Number of trees in the causal forest. Increasing the number of trees in a causal forest does not result in overfitting. This parameter can be optimized.

  * **Feature sampling strategy:** Adjusts the number of features to sample at each split.

    * Automatic will select 30% of the features.

    * Square root and Logarithm will select the square root or base 2 logarithm of the number of features respectively

    * Fixed number will select the given number of features

    * Fixed proportion will select the given proportion of features

  * **Maximum depth of tree** : Maximum depth of each tree in the causal forest. Higher values generally increase the quality of the prediction but can lead to overfitting. Higher values also increase the training and prediction time. Use 0 for unlimited depth (i.e., keep splitting the tree until each node contains the minimum number of samples per leaf),

  * **Minimum samples per leaf** : Minimum number of samples required in a single tree node to split this node. Lower values increase the quality of the prediction (by splitting the tree mode), but can lead to overfitting and increased training and prediction time.

  * **Honest** : Whether or not the honest framework is used to build trees. If set to true, the learning algorithm will use two separate subsets of the train set to compute the optimal split and the value of a node.

  * **Parallelism:** Number of cores used for parallel training. Using more cores leads to faster training but at the expense of more memory consumption, especially for large training datasets.

---

## [machine-learning/causal-prediction/evaluation]

# Evaluation recipe

Warning

_Model Evaluation Stores_ (MES) are not supported for causal prediction models.

## Input dataset

The input dataset for the evaluation recipe must contain at least:

  * The outcome column

  * The treatment column.




## Output datasets

### Output dataset

The evaluation recipe computes the evaluation dataset by computing the predicted effect based on the input data and the saved causal model. For multi-valued treatment variables, the recipe outputs as many treatment effects as there are treatment values (excluding the control value).

If a propensity model was trained by enabling the [Treatment Analysis](<settings.html#treatment-analysis>) setting in the Lab Analysis, it is possible to use it to predict the propensity (probability of receiving the treatment) and in turn compute prediction performance metrics on the propensity model (log loss, ROC-AUC and calibration loss).

### Metrics dataset

The output metrics dataset contains the computed metrics. Causal performance metrics and treatment prediction metrics of the propensity model (if enabled in [Treatment Analysis](<settings.html#treatment-analysis>)) can be computed.

For multi-valued treatments, the values displayed are the aggregates across treatments, weighted by the relative size of each treatment group.

---

## [machine-learning/causal-prediction/index]

# Causal Prediction

---

## [machine-learning/causal-prediction/introduction]

# Introduction

[Causal prediction](<https://knowledge.dataiku.com/latest/ml/causal-prediction/concept-causal-prediction.html>) should be used when you want to estimate the effect of a **treatment** variable onto an **outcome** variable. For instance, you may want to predict:

  * the effect of a drug on a patient, given their individual characteristics

  * the effect of a discount on a customer, given their customer data.




Unlike the AutoML prediction task, the Causal Prediction modeling task focuses on predicting the **treatment effect** i.e. the difference between the outcomes with and without treatment, all else equal.

Note that at the individual level this difference is based on one observed outcome, and one unobserved outcome, referred to as the **counterfactual outcome** , for instance:

  * the health outcome of a patient, would they have received the other possible drug/placebo treatment

  * the sales outcome of a customer, would they have received the other discount/no-discount treatment.




This predicted difference is often referred to as the **Conditional Average Treatment Effect (CATE)**.

This CATE prediction can help identify rows of the dataset where the highest effects from the treatment are expected, and in turn optimize the treatment allocation.

## Prerequisites and limitations

Training & running a causal prediction model requires a compatible [code environment](<../../code-envs/index.html>). Supported Python versions are 3.8 to 3.13.

Select the “Visual Causal Machine Learning” package preset in a code env’s Packages to install > Add sets of packages, and update your code-env.

Warning

Causal prediction is incompatible with the following:

  * MLflow models

  * Models ensembling

  * Model export

  * Model Evaluation Stores

  * Model Document Generator




Both **binary treatments** , i.e. with a control group and a single treatment group, and **multi-valued treatments** are supported. Binary treatments are either:

  * treatments with exactly two values (control and treated)

  * treatments with more than two values, when the multi-valued treatment option is disabled: the treatment values will be binarized as either equal to the selected control value (control group), or different from it (treated group).




When the treatment variable contains more than two values and by enabling the multi-valued treatment option, as many models as there are treatment values (excluding the control value) are trained on the relevant subset of the train data.

For classification tasks, only binary outcome variables are supported.

## Train a causal prediction model

From your dataset, in the _Lab_ sidebar, select _Causal Prediction_. Specify the columns to use as outcome variable and treatment variable.

Note

To get a concrete use case, see the [Tutorial | Causal prediction](<https://knowledge.dataiku.com/latest/ml/causal-prediction/tutorial-causal-prediction.html>).

### Treatment variable

Your dataset must contain a treatment variable.

If the treatment variable contains exactly two values (control and treated), the treatment is automatically considered binary.

If the treatment variable contains several values in addition of the control value, it is considered multi-valued by default. As many causal models as there are treatment values (excluding the control value) are trained on the relevant subset of the train data. However, the treatment variable can also be binarized based on the **control value** setting, by opting out of the multi-valued option. The treatment is then considered binary, as either:

  * equal to the control value (non treated), or

  * different from it (treated).




### Outcome variable

Outcome can be either:

  * numerical (causal regressions), or

  * categorical (causal classifications): in this case, only binary outcome variables are supported.




For binary outcome variables, you need to select the **preferred class**. The predicted probabilities used to compute the predicted effects are the probabilities of the outcome variable being equal to the preferred class.

---

## [machine-learning/causal-prediction/results]

# Causal Prediction Results

When a model finishes training, click on the model to see the results.

## Feature importance

For all causal models with a binary treatment variable, “feature importances” are based on a surrogate tree-based model learning the predicted effects. They are computed as the (normalized) total reduction of the splitting criterion brought by that feature (also called Gini importance).

Importance is an intrinsic measure of how much each feature weighs in the trained model and thus is always positive and always sum up to one, regardless of the accuracy of the model. Importance reflects both how often the feature is selected for splitting, and how much the prediction changes when the feature does. Note that such a definition of feature importance tends to _overemphasize numerical features_ with many different values.

All parameters displayed in these screens are computed from the data collected during the training, so they are entirely based on the _train set_.

### Causal Performance

Dataiku provides insights on the causal model, to help assess how well the model performed at predicting the effects of the treatment on the outcome.

Note

When the multi-valued treatment option is enabled, causal performance is computed for each treatment value `t`, using the model trained on the relevant subset of the train data, and the relevant subset of the test data. Relevant data refers to treatment values equal to either `control` or `t`. The Overall Metrics table displays metrics that are aggregated across treatments, weighted by the relative size of each treatment group.

## Uplift and Qini curves

Causal performance metrics are different from purely predictive performance metrics, because there is no ground truth to which the predicted effect can be compared.

To emulate this counterfactual effect, treatment effects are estimated on subsets of the data by the empirical treatment effect: average outcome of the treated group minus average outcome of the control group (average outcome is meant as frequency of the preferred class for classifications).

More precisely, to compute the **uplift curve** :

  * the test observations are sorted by decreasing predicted individual treatment effects (from the causal model).

  * the treatment effect of each subsets of observations is estimated empirically from the treated and control groups

  * a normalization is performed so that at the limit of the x-axis (100% of the population treated) the y-axis represents 1 (i.e. the full treatment effect on the total test set).




The formulas for the uplift and Qini curves at ratio `x` are:

  * **uplift curve** : `[Y_treated(tau > tau(x)) - Y_control(tau > tau(x))] * x / N / abs(ATE)`

  * **Qini curve** : `[Y_treated(tau > tau(x)) - Y_control(tau > tau(x))] * N_treated(tau > tau(x)) / N_treated / abs(ATE)`




where:

  * `x` denotes a ratio of the test set

  * `Y_treated(tau > tau(x))` (resp. `Y_control(tau > tau(x))`) denotes the average outcome of individuals in the treated group (resp. control group) with predicted effects in the top `x` share of the population

  * `N_treated(tau > tau(x))` denotes the number of individuals in the treated group with predicted effects in the top x share of the population

  * `abs(ATE)` denotes the absolute value of the Average Treatment Effect, i.e. `abs(Y_treated - Y_control)` on the whole population.




## Distribution of the predicted effect

This histogram approximates the distribution of the predicted effect across the test set. This can provide a picture of:

  * subpopulations reacting differently to the treatment, e.g. some positively and some negatively

  * the main range of the predicted effects

  * existence of extreme cases (outliers).




### Treatment Analysis

If the treatment analysis was enabled in the settings, results based on the propensity model will be available.

Note

When the multi-valued treatment option is enabled, treatment analysis is performed for each treatment value `t`, on the relevant subset of the data, i.e. with treatment values being either `control` or `t` (excluding all other treatment values).

## Treatment Randomization

If the treatment was randomized across the whole population, the results of causal predictions can more easily be trusted, because all assumptions underlying causal predictions are automatically satisfied. However, even if the data is the result of an experiment where the treatment was perfectly randomly allocated, a number of steps in the data preparation process (data selection, enrichment, feature engineering) can still alter this favorable state. Hence, Dataiku provide a quick test to check if the randomization hypothesis is obviously broken.

The test is built upon the propensity model (model predicting the treatment variable). If this model can actually predict the treatment with a significant accuracy, based on the other covariates, this implies that the treatment was not randomized. Thus, the null hypothesis is that the accuracy of propensity model is below the accuracy of a dummy model always predicting the majority class. A binomial test is performed on the predicted treatments and a p-value is computed for this test. If the p-value is lower than 0.05, the test concludes that the null hypothesis should be rejected with 95% confidence.

## Positivity Analysis

In the cases where the treatment was not perfectly randomized, results of causal predictions can still be valid under the **positivity hypothesis**. This hypothesis states that both treatment values, treated and control, are likely (with non-zero probability), for all relevant combinations of other variables.

Two charts help assess the positivity hypothesis:

  * a stacked histogram with the distribution of the predicted probability of treatment: violation of the positivity hypothesis can be detected by strongly imbalanced bins e.g. a large number of treated and almost zero control (usually for larger values of predicted probability of treatment)

  * a calibration curve of the predicted probability of treatment: violation of the positivity hypothesis can be detected by extreme values (very close to 0 or 1) of frequencies of treatment among any bin of predicted probability of treatment.

---

## [machine-learning/causal-prediction/scoring]

# Scoring recipe

## Causal scoring

The purpose of this recipe is to build a scored dataset by computing the predicted treatment effect based on the input data and the saved causal model. For multi-valued treatment variables, the recipe outputs as many treatment effects as there are treatment values (excluding the control value).

By design, neither the outcome, nor the treatment variable are required as input.

For binary treatment variables, the treatment recommendation option allows you to select rows with the largest predicted effects, based on:

  * an explicit CATE value: all rows with a predicted effect above the threshold will be recommended for treatment.

  * an exact ratio of the population to be scored: the dataset is scored to predict all the treatment effects, then sorted by predicted effects (requires holding the full dataset in memory) and the rows with the largest values will be recommended for treatment.

  * an approximate ratio of the population to be scored: same as the previous option except that small fluctuations of the input ratio are tolerated in order to compute the top values without holding all the data in memory (recommended for larger datasets).




## Propensity scoring

If a propensity model was trained by enabling the [Treatment Analysis](<settings.html#treatment-analysis>) setting in the Lab Analysis, the recipe additionally computes the predicted propensity, i.e. probability of receiving the treatment on each row. For multi-valued treatment variables, it outputs as many propensities as there are treatment values (including the control value).

---

## [machine-learning/causal-prediction/settings]

# Causal Prediction Settings

The “Settings” tab allows you to configure important aspects of your Causal Prediction task.

## Settings: Outcome & Treatment

Set the base settings for causal prediction:

  * outcome variable

  * preferred class if the outcome variable is a binary category

  * treatment variable

  * control value, i.e. the value of the treatment variable representing the control group

  * option for multi-valued treatment, if the treatment variable has more than one value that in addition of the control value.




Note

When the multi-valued treatment option is enabled, each treatment value `t` (except the control value) yields a causal model:
    

  * based on a binary treatment value (`control` and `t`)

  * trained on the relevant data: treatment variable equal `control` or `t`.




DSS displays an estimation of the average treatment effect (ATE) on the sample dataset to help set these parameters (ATE is usually expected to be positive).

## Settings: Train / Test set

When training a model, it is important to test the performance of the model on a “test set”. During the training phase, DSS “holds out” on the test set, and the model is only trained on the train set.

Once the model is trained, DSS evaluates its performance on the test set. This ensures that the evaluation is done on data that the model has “never seen before”.

### Splitting the dataset

DSS splits the input dataset into a train and a test set.

Warning

Causal prediction does not support K-Fold cross-test.

#### Subsampling

DSS defaults to using the first 100’000 rows of the dataset, but other options are available.

For more details, see the documentation on [Sampling](<../../explore/sampling.html>).

## Settings: Metrics

As with all machine learning tasks, performance metrics will be used both for hyperparameter search (metrics computed on the evaluation folds and averaged) and the final performance result (metrics computed on the test set).

Several metrics are available, all based on the [Uplift Qini curves](<results.html#uplift-curve>):

  * the **Area under the uplift curve (AUUC)**.

  * the **Qini coefficient** : the area under the Qini curve.

  * the **Net uplift** at specified point: the value of the uplift curve at a fixed ratio of the population to be treated (defaults to 50%).




If Treatment Analysis is enabled, the weighting method option offers the possibility to compute the causal metrics (Uplift and Qini curves and their derivatives) using [inverse probability weighting](<https://en.wikipedia.org/wiki/Inverse_probability_weighting>) . Such weighted metrics offer a level of mitigation against misleading metrics in the case of non-random or imbalanced treatments.

## Settings: Algorithms

Dataiku supports several algorithms to train causal prediction models. We recommend trying several different algorithms before deciding on one particular modeling method.

See [Causal prediction algorithms](<causal-prediction-algorithms.html>) for details.

## Settings: Hyperparameters optimization

Except for the use of specific causal performance metrics, hyperparameter search is identical to machine learning prediction tasks, see [models optimization](<../advanced-optimization.html>) for details.

## Settings: Treatment Analysis

The treatment variable plays a crucial role in causal predictions, and all causal prediction methodologies make implicit assumptions on the treatment variable:

  * **Unconfoundedness** : for each example in the dataset, the joint outcome under control and outcome under treatment (one of which is always a counterfactual i.e. unobserved) does not depend on the treatment assignment (control or treatment). This hypothesis cannot be tested statistically.

  * **Randomization** : the treatment variable is perfectly randomized, i.e. all examples have the exact same probability of belonging to the treatment and control groups, e.g. from the assignment of an A/B test.

  * **Positivity** (a weaker alternative to Randomization): this hypothesis states that both treatment values, treated and control, are likely (with non-zero probability), for all relevant combinations of other variables.




The **propensity model** predicts the treatment variable. Enabling it helps assess whether or not the _Randomization_ and _Positivity_ assumptions are violated.

On top the the propensity model, you can opt in to use a calibration model to make the predicted probabilities as well calibrated as possible. This is recommended for a more robust [positivity analysis](<results.html#positivity>).

---

## [machine-learning/computer-vision/architecture]

# Model architectures & training parameters

You can train a computer vision model without any code; tailor the training regime to your needs in the “Design >> training” tab of the analysis, or accept the default configuration.

## Pre-trained models available

  * Object detection uses a [Faster R-CNN model](<https://arxiv.org/abs/1506.01497>) with a ResNet-50-FPN backbone. See [PyTorch tutorial](<https://pytorch.org/tutorials/intermediate/torchvision_tutorial.html>) for more details on how Faster R-CNN model is implemented in PyTorch.

  * For Image classification you can choose between several [EfficientNet models (B0, B4 and B7)](<https://arxiv.org/abs/1905.11946>). B0 is the smallest model (fewest parameters, size on disk), while B7 is the largest. Smaller models will yield faster training times, whilst larger models may result in better performance. B4 is a good balance between the two other models, it is selected by default.




## Training parameters

The **number of retrained layers** : this indicates how many backbone layers will be finetuned on your images while the other layers are frozen. Increasing the number of finetuned layers can lead to overfitting if the training dataset is insufficiently large.

An **optimizer** is used during training to update the weights of the network based on the loss. You can choose one of the following optimizers: ADAM, SGD, RMSprop, Adamax, Adagrad and Adadelta. A **learning rate schedule** is used to adapt the learning rate at the end of each epoch. Available methods are: On plateau, step and exponential methods. See [Pytorch documentation](<https://pytorch.org/docs/stable/optim.html>) for more details on the optimizers and learning rate schedules. Note that in addition to the learning rate schedules applied at the end of each epochs, we use a **warmup learning rate schedule** during the first epoch to start with a smaller learning rate and increase its value quickly to match the initial learning rate value specified by the end of the first epoch.

You may specify the upper limit for training with the **number of epochs** parameter, and optionally an **early stopping** configuration to conclude training early if the performance metric on the test set does not improve by at least the **early stopping delta** , within the number of epochs set as **early stopping patience**.

The **batch size** defines the number of images used in each training step. It is defined per device meaning that if you train on 2 GPUs, each will receive batch size images per training-step. Increasing the batch size will accelerate training, however it will be limited by the available GPU/CPU memory of your infrastructure.

---

## [machine-learning/computer-vision/data-augmentation]

# Data augmentation

Data augmentation adds additional diversity to your training dataset by applying distortions to your images that could be expected in the real world, thereby assisting the model to generalize.

## Data augmentations settings

Categories of augmentations can be enabled or not. They are independent from one to another (one can be applied when another is not). When activated, they are applied with a given probability for each image independently, at each epoch.

  * **Color transformations** : Activating the color augmentation will alter the hue, contrast and brightness of your images.

  * **Affine transformations** : Activating horizontal or vertical flip will invert your images. Activating the rotation will apply a rotation chosen randomly in the range [-maximum rotation, +maximum rotation] where maximum rotation is a parameter you can change.

  * **Crop transformations** : When activated, a random portion of the images will be used for training, which is at least the size defined by the parameter “Min. kept ratio”. By default it is set to 0.75, ensuring that between 75% - 100% of the image area is preserved. The kept area will have the same aspect ratio as the original image, and the crop is performed randomly (i.e. not always central).




## N.b. Object detection

For object detection, the bounding box annotations are updated to reflect the transformations applied to each image.

Crop and rotation can crop out of the image an annotated object. In this case the corresponding annotations for this object are removed. If the object is only partially cropped, annotations are kept but updated to fit the new image dimensions. In any case, DSS ensures that at least one bounding box remains after the augmentation is applied.

---

## [machine-learning/computer-vision/evaluation-metrics]

# Evaluation Metrics

For Object detection, the model will maximize the F1 score by default, which is a weighted average of the precision and recall. Depending on your use case, you may want to optimize for either recall or precision:

>   * Maximizing the recall will train the model to predict marginally likely objects, which is useful in cases where your classes of interest are under-represented in your training data.
> 
>   * Maximizing the precision will predict only the most likely objects, which is useful in cases where your classes of interest are well-represented in your training data.
> 
> 


For Image classification the model will maximize the ROC AUC score by default but other multiclass metrics are available: Precision, Recall, F1 score, Accuracy, Log Loss and Average Precision.

---

## [machine-learning/computer-vision/first-model]

# Your first Computer vision model

Here is how you can quickly train an **Object detection** or **Image classification** model:

## Install the required packages

First, you need the appropriate packages to be able to run the model. Luckily there is one code environment (see [Code environments](<../../code-envs/index.html>)) containing all the appropriate packages already built for you, that you just need to install:

Go to the “Administration > Code envs > Internal envs setup” tab. In the section “Computer vision code environment”, you can create either an Object detection or an Image classification code environment by selecting your Python interpreter and clicking on create the environment. It will install all the required packages for the corresponding task.

## Create the analysis

Make sure to have the correct [Computer vision analysis inputs](<inputs.html>) before continuing.

Then create the analysis: select the Dataset then click on “Action panel > Lab > Object detection” (or Image classification depending on your need). Choose your target column and the image folder. Then click “Create” and you’re done !

## Review the design of your model (optional)

If you want to train a model with the default parameters you can simply proceed by clicking the “Train” button. You will be asked whether or not you want to select GPUs for training.

If you prefer reviewing the design of the model first, here are some tips on what you can configure:

  * The **Target tab** displays a sample of your data with the class labels or bounding boxes previewed on the images. If the boxes or labels do not correspond with your image as you expect, you may have an issue with the format of your targets. See [Computer vision analysis inputs](<inputs.html>) for the expected format.

  * The **Training tab** allows you to change the default training parameters according to your data. See [Model architectures & training parameters](<architecture.html>) for the complete list of parameters available.

  * The **Train / Test tab** allows you to change the ratio of test samples compared to the training samples. See [Settings: Train / Test set](<../supervised/settings.html#settings-train-test>) for more information.

  * The **Metrics tab** allows you to choose which metric will be optimized during training. See [Evaluation Metrics](<evaluation-metrics.html>).

  * The **Data augmentation tab** allows you to introduce some diversity in your training dataset, and visualize dynamically some examples of those augmentations on your images. See [Data augmentation](<data-augmentation.html>) for more information.

  * You shouldn’t need to change anything in the **Runtime Environment tab** for now.




Once you’re ready, Click on “Train”, select your GPU settings (see [GPU support](<runtime-gpu.html>)) then click “Train” again. This will prepare your model then start the training loop.

## Monitor the performance of your model during training

The chart displays the performance of your model at the end of each epoch, against your chosen metric. Once training completes, you can assess the performance of your model (see [Performance assessment](<performance-assessment.html>)), then deploy, retrain and score it, like any other Visual Machine Learning model in DSS.

---

## [machine-learning/computer-vision/index]

# Computer vision

---

## [machine-learning/computer-vision/inputs]

# Computer vision analysis inputs

The following inputs are required to create a computer vision analysis (either an Object detection or Image classification one): a [Managed folders](<../../connecting/managed_folders.html>) containing the images you want to learn from and a dataset where each row corresponds to an image of your folder, with two columns:

>   * A **target** column containing, for each image, annotations or a category (depending on whether you are doing an Object Detection or Image classification analysis).
> 
>   * An **image path** column specifying the image paths from your folder’s root.
> 
> 


This dataset can be created from the managed folder using the [List Folder Contents](<../../other_recipes/list-folder-contents.html>) recipe.

## Target column format for Object detection

The target column for Object detection must have, for each image, a json of the following format:
    
    
    [{
        "bbox": [xmin_bbox, ymin_bbox, width_bbox, height_bbox]
        "category": "cat"
     }, {
        "bbox": [xmin_bbox, ymin_bbox, width_bbox, height_bbox]
        "category": "dog"
    }]
    

The top left of the image having coordinates (0, 0).

If you downloaded your dataset in Pascal or VOC format you can use the plugin [Image annotations to Dataset](<https://www.dataiku.com/product/plugins/image-annotations-to-dataset>) to reformat your annotations and create a Dataset with the right format for computer vision.

If you annotated your images using the plugin [ML Assisted Labeling](<https://www.dataiku.com/product/plugins/ml-assisted-labeling>), use the “Reformat image annotations” recipe to create a dataset for Computer vision.

Rows having a bad format or without annotations will be dropped during training.

## Target column format for Image classification

The target column for Image classification must be a string or integer for each image (representing its category):
    
    
    "category 1"
    

If you have a managed-folder with images being organized in different sub-folders named according to the categories of your dataset, note that you can use the built-in “List Contents” recipe to create the input dataset.

Rows having a bad format or empty rows will be dropped during training.

## Image path column

This column contains the relative path of each image from the folder root. Corrupted or missing images are ignored during training.

## Supported images formats

Supported image formats for computer vision in DSS are: jpg, jpeg, and png.

There is no image size requirement for using computer vision in DSS. However they should be able to fit into memory (see batch size in [Model architectures & training parameters](<architecture.html>)).

---

## [machine-learning/computer-vision/introduction]

# Introduction

Computer vision in DSS is “fully-visual”: You don’t need to write code, you can configure training using the interface. It includes for both Object detection and Image classification :

>   * Preparing the requisite environment
> 
>   * Visually configuring the training task (including interactive data augmentation)
> 
>   * Handling the training process (with or without GPU) with early stopping capabilities
> 
>   * Interactive results & performance visualisation
> 
>   * Ability to deploy and score images in batch or realtime
> 
> 


Checkout this [Sample project](<https://www.dataiku.com/learn/samples/object-detection/>) to get an overview of the object detection native capabilities or start creating your own using the next sections.

DSS Computer vision is based on PyTorch. Through container deployment capabilities, you can train and deploy models on cloud-enabled dynamic GPUs clusters.

Note

To create a model from scratch with a custom architecture and full parametrization, you can write your model in Keras using our [Deep Learning](<../deep-learning/index.html>) feature instead.

---

## [machine-learning/computer-vision/performance-assessment]

# Performance assessment

## Object detection

### Confusion matrix and image feed

Once the training is finished, results are available via a confusion matrix and the corresponding image feed.

The **confusion matrix** shows the ground truth (rows) vs what the model predicted (columns). For every cell, the number of detections is displayed and permits filtering the image feed to show the corresponding images. You can then easily check if an object has been detected, and assigned the correct class label.

  * The “Not detected” column shows ground truth objects that weren’t detected during prediction

  * The “Not an object” row shows predicted objects that have no corresponding ground truth. Some objects may have not been labeled but were still detected by the model.




Moving the IOU (Intersection Over Union) slider will filter predictions, only showing those that have a higher IOU than the threshold. Increasing the confidence score threshold will filter out predictions that the model was less sure about. This confidence score threshold will also be applied when scoring the model using recipes or via the API node. The “back to optimal” button reset the confidence score to its optimal value.

Selecting a cell in the matrix, or modifying the IOU or Confidence Score sliders, updates the **image feed** according to those filters. You can also visualize all the predictions of the model for a given image by clicking on it. It displays objects that were correctly predicted with respect to their ground truths.

### Metrics

The **Metrics** tab displays the table of the Average Precision for different IOU values, for all classes as well as individual classes. The higher the value, the better the prediction.

### Precision-Recall curve

The Precision-Recall curve shows individual metrics for each detection (sampled). Moving the IOU slider modifies the displayed curve because only the bounding boxes with a higher proportion of intersection are included with a higher threshold, with the remaining boxes considered as erroneous detections (false positives). The confidence score is chosen to maximize the metric that was specified in the design.

### What if : Scoring new images on the go

The “What if” tab allows you to score images on the go using the newly trained model, and to visualize the bounding boxes of the detected objects on the images. Drag & drop (or browse your files) to select one or many images to score.

Once inference is complete, the detections will appear on the right of the screen, along with their confidence score.

Only the detections with scores above the confidence threshold will appear on the image. This threshold can be changed dynamically to visualize the impact it has on the detected objects. Hovering the detections in the list will highlight the corresponding box on the image, regardless of whether their score meets the threshold.

If the model did not recognize any objects in your image, you will see a “Model did not detect any objects for this image” message instead of a list of detections.

## Image classification

### Confusion matrix and image feed

Once the training is finished, results are available via a confusion matrix and the corresponding image feed.

The **confusion matrix** shows the ground truth (rows) vs what the model predicted (columns). For every cell, the number of corresponding images is displayed. Selecting a cell in the matrix updates the **image feed** according to this filter. This way you can easily check which images have been assigned the correct (or incorrect) class labels.

You can also visualize the detail of the predicted probabilities for a given image by clicking on it. It displays the predicted probability of each class and indicates for the top class whether it was correctly predicted with respect to the ground truth of this image.

### Metrics

The **Metrics** tab displays the main multi-classes metrics. You can hover over the metrics for more details on how each metric is computed.

### Calibration curve, ROC curve & density charts

These graphs are computed for all the 1-versus-all subproblems as binary subproblems.

### What if : Scoring new images on the go

Similarly to object detection, the “What if” tab for image classification allows you to score images on the go using the newly trained model. The predicted classes and their probabilities will appear on the right of the screen.

---

## [machine-learning/computer-vision/runtime-gpu]

# GPU support

## Selection of GPU

Even if training is possible on CPUs, we recommend that you use GPUs to train your model, as it will significantly reduce the training time. If the DSS instance has access to GPU(s), locally or on your infrastructure (via containers) you can choose to use them to train the model when clicking on “Train”.

When you deploy a model to the flow you can use the training recipe, to update the preferred infrastructure for retraining. You can also choose to score with a GPU using the scoring recipe.

If a model trained on a GPU is deployed as a service endpoint on an API node, it is recommended, but not mandatory, that the endpoint also has access to a GPU. GPU resources will automatically be used if available.

## Using multi-GPU training

If multiple GPUs are available, and you choose to use more that one during training, one model will be trained by GPU, each GPU receiving batch_size images to compute the gradient across all models. Then, it will gather the results to update the model and send the new weights to each GPU, and so on.

See [Pytorch DistributedDataParallel module](<https://pytorch.org/docs/stable/generated/torch.nn.parallel.DistributedDataParallel.html>) documentation for more details.

## Requirements

To train or score using GPU(s), DSS needs:

  * At least one CUDA compatible NVIDIA GPU.

  * The GPU drivers installed, with CUDA v10.2 (or later minor versions of v10) or v11.3 (or later minor versions of v11).

---

## [machine-learning/custom-models]

# Writing custom models

DSS does not restrict you to the algorithms that are part of its visual ML capabilities, but allows you to code your own model, either in Python or in Scala.

  * For more information on creating custom models, see [Custom Models](<algorithms/in-memory-python.html#custom-models>).

  * To make a plugin out of a custom model, see [Component: Prediction algorithm](<../plugins/reference/prediction-algorithms.html>).

  * To create a custom model to train with the MLlib backend, see [MLLib (Spark) engine - Deprecated](<algorithms/mllib.html>). (Deprecated)

  * To create a custom model using MLflow Model, see [MLflow Models](<../mlops/mlflow-models/index.html>).

---

## [machine-learning/deep-learning/advanced]

# Advanced topics

## Start with weights from a previously trained model

You can initialize a model training with weights from another model for transfer learning & fine-tuning.

To do so, Keras provides the [load_model and load_weights](<https://www.tensorflow.org/api_docs/python/tf/keras/Model#load_weights>) methods to retrieve previously saved models or weights.

DSS provides functions to retrieve the location of models, either from a ML task or a saved model:
    
    
    # in dataiku.doctor.deep_learning.load_model
    get_keras_model_from_trained_model(session_id=None, analysis_id=None, mltask_id=None)
    get_keras_model_location_from_trained_model(session_id=None, analysis_id=None, mltask_id=None)
    get_keras_model_from_saved_model(saved_model_id)
    get_keras_model_location_from_saved_model(saved_model_id)
    

## How is the model trained?

Whether you use Standard or Advanced mode, DSS trains the model using [Sequence](<https://www.tensorflow.org/api_docs/python/tf/keras/utils/Sequence>) objects and the [fit](<https://www.tensorflow.org/api_docs/python/tf/keras/Model#fit>) method.

This preprocesses the data in batches and not all at once to prevent using too much memory, in particular for texts and images, which are memory-intensive.

DSS will preprocess data and produce those sequences: train and validation (what we usually call test is called validation in Keras terminology), depending on the size of each batch, and call fit_generator. You can customize how the process is done.

## Advanced training mode

The Advanced mode for training (accessible by clicking on the top right of the analysis) allows you to modify the data, preprocessed by DSS that will be sent to the model, and to customize the parameters of the call to fit_generator. In particular, the two main use cases of using the Advanced mode are:

  * data augmentation

  * using custom Callbacks




You need to fill two methods

### Build sequence

The method build_sequence should return the sequences that will be used to train the model. To do so, you have access to helpers build_train_sequence_with_batch_size and build_validation_sequence_with_batch_size, which are functions that return sequences depending on a batch_size.

Then you can modify at will these sequences before training. In particular, you may want to perform some data augmentation. DSS provides a helper to do so, which looks like:
    
    
    from dataiku.doctor.deep_learning.sequences import DataAugmentationSequence
    from tensorflow.keras.preprocessing.image import ImageDataGenerator
    
    original_batch_size = 8
    train_sequence = build_train_sequence_with_batch_size(original_batch_size)
    augmentator = ImageDataGenerator(
        zoom_range=0.2,
        shear_range=0.5,
        rotation_range=20,
        width_shift_range=0.2,
        height_shift_range=0.2,
        horizontal_flip=True
    )
    augmented_sequence = DataAugmentationSequence(train_sequence, "image_name_preprocessed", augmentator, n_augmentation=3)
    

where:

  * image_name_preprocessed is the name of the input to augment

  * n_augmentation is the number of time the sequence is augmented




[ImageDataGenerator](<https://www.tensorflow.org/api_docs/python/tf/keras/preprocessing/image/ImageDataGenerator>) is a helper provided by Keras to perform data augmentation on images.

For custom augmentation, you can provide your own instance of a class implementing a random_transform method with the following signature:
    
    
    def random_transform(x, seed=None):
      # returns a numpy array with the same shape as x
    

When you use data augmentation, you need to be aware that the actual batch size of its augmented sequence will be original_batch_size * n_augmentation, therefore you may want to provide a smaller original_batch_size.

### Fit model

The method fit_model allows you to define custom Keras [callbacks](<https://www.tensorflow.org/api_docs/python/tf/keras/callbacks/Callback>).

As per Keras documentation,

> A callback is a set of functions to be applied at given stages of the training procedure. You can use callbacks to get a view on internal states and statistics of the model during training

DSS builds a list of base_callbacks (to compute metrics, interrupt model if requested in the UI …) that must be added in the call to fit_generator. Then, you are free to add any custom callback to this list.

#### Usage of metrics in Callbacks

Many built-in (or custom) Callbacks from Keras require a metric to monitor. Their behavior will depend on the value of this metric. For example, the [Early Stopping](<https://www.tensorflow.org/api_docs/python/tf/keras/callbacks/EarlyStopping>) callback will stop the model training prior to completing all planned epochs if the tracked metric is no longer improving.

Usually, you define the metrics you want to track in the metrics parameter of the compile function. Then you can retrieve them via the callbacks. DSS also computes its own metrics through a base callback depending on the prediction type:

  1. Regression:




>   * ‘EVS’
> 
>   * ‘MAPE’
> 
>   * ‘MAE’
> 
>   * ‘MSE’
> 
>   * ‘RMSE’
> 
>   * ‘RMSLE’
> 
>   * ‘R2 Score’
> 
>   * ‘Custom Score’
> 
> 


  2. Binary Classification




>   * ‘Accuracy’
> 
>   * ‘Precision’
> 
>   * ‘Recall’
> 
>   * ‘F1 Score’
> 
>   * ‘Cost Matrix Gain’
> 
>   * ‘Log Loss’
> 
>   * ‘Cumulative Lift’
> 
>   * ‘ROC AUC’
> 
>   * ‘Average Precision’
> 
>   * ‘Custom score’
> 
> 


  3. Multiclass Classification




>   * ‘Accuracy’
> 
>   * ‘Precision’
> 
>   * ‘Recall’
> 
>   * ‘F1 Score’
> 
>   * ‘Log Loss’
> 
>   * ‘ROC AUC’
> 
>   * ‘Average Precision’
> 
>   * ‘Custom score’
> 
> 


As DSS tracks metrics on the ‘Test’ set, you need to prepend ‘Test ‘ to the name of the metric to have the proper name.

Warning

As they are computed in a base callback, if you want to use them, you need to put your custom callback after the list of base_callbacks provided by DSS, in the list that you will pass to fit_generator.

For example, in a binary classification problem, if you want to introduce an early stopping callback monitoring ROC AUC, you can add the following callback to its list
    
    
    from tensorflow.keras.callbacks import EarlyStopping
    early_stopping_callback = EarlyStopping(monitor="Test ROC AUC",
                                    mode="max",
                                    min_delta=0,
                                    patience=2)
    

DSS also provides a helper to retrieve in the code the name of metric that is used for the optimization of the model, along with the info on whether it is a loss (and lower is better) or a score (greater is better). You can access those variables with
    
    
    from dataiku.doctor.deep_learning.shared_variables import get_variable
    metric_to_monitor = get_variable("DKU_MODEL_METRIC")
    greater_is_better = get_variable("DKU_MODEL_METRIC_GREATER_IS_BETTER")
    

and the previous early stopping callback becomes
    
    
    from dataiku.doctor.deep_learning.shared_variables import get_variable
    from tensorflow.keras.callbacks import EarlyStopping
    
    metric_to_monitor = get_variable("DKU_MODEL_METRIC")
    greater_is_better = get_variable("DKU_MODEL_METRIC_GREATER_IS_BETTER")
    early_stopping_callback = EarlyStopping(monitor=metric_to_monitor,
                                            mode="max" if greater_is_better else "min",
                                            min_delta=0,
                                            patience=2)

---

## [machine-learning/deep-learning/architecture]

# Model architecture

When creating a Deep Learning model, you need to write the Architecture of the Neural Network. To do so, you must fill two Python functions defined in the “Architecture” tab of the settings.

## Build Keras model

The `build_model` function needs to return an instance of the [Model](<https://www.tensorflow.org/api_docs/python/tf/keras/Model>) class.

This function takes two parameters:

  * `input_shapes` \- a dictionary of the shapes of the input tensors

  * `n_classes` \- the number of classes to predict (for classification models only)




### input_shapes

Advanced models can have multiple inputs (see [Multiple inputs](<inputs.html>) for more information). Each input has a name.

The `input_shapes` variable is a dictionary indexed by input name. In most cases, the shape of the inputs is unknown prior to preprocessing, which will create a variable number of columns (e.g. dummification, vectorization …). Thus, they are provided to you to assist when building your model. If you haven’t used multi-input features, you only have a `main` input. Thus, to know the shape of your input tensor, simply use `input_shapes["main"]`

For example,
    
    
    input_main = Input(shape=input_shapes["main"])
    x = Dense(64, activation="relu")(input_main)
    ...
    

### n_classes

`n_classes` \- the number of target classes when performing multiclass classification

### Layer dimensions

You need to be careful with the dimensions of the last layer of your network:

  * For regression, the last layer needs to have a dimension equal to 1, and it should generally not have any activation.

  * For binary classification, the last layer should be either: dimension equal to 1 and sigmoid activation, or dimension equal to 2 and softmax activation.

  * For multiclass classification, the last layer should have a dimension equal to the number of target classes, and a softmax activation.




If this is not respected, training will either fail (mismatch in dimension) or give inconsistent results (when using an incorrect activation the result may not be a probability distribution).

## Compile the model

The `compile_model` function takes the previously created model as input and calls its [compile](<https://www.tensorflow.org/api_docs/python/tf/keras/Model#compile>) method. It is separated from the `build_model` function, as DSS may need to manipulate the model between creation and compilation, in particular for multi-GPU training.

The `compile` function also optionally accepts a list of metrics to track during training. DSS also always computes some metrics (see [Advanced topics](<advanced.html>) for the list) that will be available in TensorBoard afterwards.

The two arguments that need to be carefully provided are:

  * [optimizer](<https://www.tensorflow.org/api_docs/python/tf/keras/optimizers>), which is the method used to optimize the model

  * [loss](<https://www.tensorflow.org/api_docs/python/tf/keras/losses>) function, which is the function optimized during training. Loss functions are specific to the prediction type (Regression/Classification). By default DSS selects a suitable one based on the prediction type guessed in the analysis.

---

## [machine-learning/deep-learning/first-model]

# Your first deep learning model

Here is how you can quickly build a Deep Learning model and train it on CPU.

## Create a code environment with the required packages

First, you need the appropriate packages to be able to run the model. To do so, you need to:

  * Create a new [code environment](<../../code-envs/index.html>). Supported Python versions are 3.8 to 3.13.

  * Go to the “Packages to install” tab of this code-env and click “Add sets of packages”

  * Select “Visual Deep Learning: Tensorflow” and click “Add”

  * Update your code-env.




You are now ready to build your Deep Learning model (See [Runtime and GPU support](<runtime-gpu.html>) for more information on how code environments are used for Deep Learning).

## Create a Deep Learning analysis to solve a Prediction problem

Select a dataset for which you have a **target** column that you want to predict depending on the values of the other columns of the dataset. Then:

  * Select the Lab

  * Select Quick model then Prediction

  * Choose your target variable (one of the columns) and Expert Mode

  * Choose Deep Learning and click Create




## Review the architecture of you Deep Learning model

DSS then creates a Multi Layer Perceptron architecture that you can modify to any Deep Learning architecture. It is written in the build_model function of the “Architecture” tab and should look like:
    
    
    def build_model(input_shapes, n_classes=None):
    
        # This input will receive all the preprocessed features
        # sent to 'main'
        input_main = Input(shape=input_shapes["main"], name="main")
    
        x = Dense(64, activation='relu')(input_main)
        x = Dense(64, activation='relu')(x)
    
        predictions = Dense(1)(x)
    
        # The 'inputs' parameter of your model must contain the
        # full list of inputs used in the architecture
        model = Model(inputs=[input_main], outputs=predictions)
    
        return model
    

The precise architecture may vary if you have a dataset with particular data types, such as text, because DSS adapts the default architecture depending on data types.

The model is written using the Keras API, and defines an Input, that will receive the preprocessed features from your dataset, then three fully connected Dense layers.

Click on Train.

## Monitor the performance of your model during the training

You will then see charts that track the performance of the model and the progress in the training.

Once the training is completed, you can assess its performance, then deploy it, score it, retrain it like any other Visual Machine Learning model in DSS.

For a more detailed walkthrough, see an [Introduction to Deep Learning with Code](<https://knowledge.dataiku.com/latest/ml/deep-learning/code-within-visual-ml/tutorial-index.html>).

---

## [machine-learning/deep-learning/images]

# Using image features

It is possible to handle images using DSS deep learning. To do so, you must store your images in a managed folder (See [Managed folders](<../../connecting/managed_folders.html>)).

Then, you need to indicate in the dataset that will be used for running the analysis the location of your images. Create a new column containing the relative path of each image inside the managed folder. Then, in the “Features handling” tab of the analysis, select “Image” as type for this column.

You need to precise the managed folder where the images are stored in Image location, and to do a Custom preprocessing that looks like:
    
    
    from tensorflow.keras.applications.imagenet_utils import preprocess_input
    from dataiku.doctor.deep_learning.keras_utils import load_img
    
    # This will give you an input shape of (197, 197, 3)
    def preprocess_image(image_file):
        # resized_dims - an optional resizing step
        # channels     -  'L', 'RGB' or 'CMYK'
        # data_format  - 'channels_last' or 'channels_first'
        array = load_img(image_file, resized_dims=(197, 197), channels='RGB', data_format='channels_last')
        # You can use your own preprocessing, here for example we use tensorflow's out of the box one
        array = preprocess_input(array, mode='tf')
        return array
    

where we see that the output for an image has a (197, 197, 3) shape. Then, this output is sent to a image_path_preprocessed input (if the name of the original column was image_path), so the corresponding input in the model should look like:
    
    
    input_img = Input(shape=(197, 197, 3), name="image_path_preprocessed")
    

See [Deep learning for image classification](<https://knowledge.dataiku.com/latest/ml/complex-data/images/classification-code/tutorial-index.html>) for a step-by-step example of this in practice.

## Scoring images

When using a saved model that has image feature(s) for scoring, you can provide in the corresponding column(s):

  * the relative path to the image, which must be stored in the **same** managed folder that was used for training

  * a string that is the [Base64](<https://en.wikipedia.org/wiki/Base64>) representation of the image file.

---

## [machine-learning/deep-learning/index]

# Deep Learning

---

## [machine-learning/deep-learning/inputs]

# Multiple inputs

It is possible for a deep learning model architecture to have more than one input.

For example, when working with Tweets, you may want to analyse the text of the tweet, but also its metadata (when was the tweet emitted, how many retweets did it generate, how many followers its author has, …). However, it is not possible to directly compare text and numerical data. Therefore you need to first “transform” the text into numerical data with a recurrent network, then “connect” it to the metadata. The architecture may look like:

DSS can handle these architectures, and you can define which preprocessed feature goes to which deep learning input.

By default, all the input features of your model are preprocessed, which gives a numerical array. This numerical array is sent to a main deep learning input.

You can add two kinds of deep learning model inputs:

  * “Regular multi-feature inputs” which receive the preprocessed numerical array from the “regular” preprocessing of one or multiple input features.

  * “Custom-processed single-feature inputs” where a custom preprocessor creates a tensor from a single input feature. The tensor may have arbitrary shape.




To create a new input, go in the _Model inputs_ section of the “Architecture” tab (accessible by clicking on “Display Inputs” button on the top left).

Each input has a name, and you then configure your features to send data to inputs.

In the architecture code, you receive all inputs as a dictionary. There is a helper to insert inputs in the right way in the Input section.

## Regular multi-feature inputs

Most preprocessing done in the DSS [Features handling](<../features-handling/index.html>) pipeline conceptually takes one column from the input dataset and converts it into one or more columns in the resulting data frame.

Multiple input features, once preprocessed, thus generate a wider data frame which can then become a 2-dimensional tensor `(batch_size, number_of_preprocessed_output_columns)`

To create a new deep learning regular multi-feature input, go in the _Model inputs_ section of the “Architecture” tab (accessible by clicking on “Display Inputs” button on the top left).

Then, to populate it, go to the “Feature handling” tab, where you can select which deep learning input you want to send each input. To be faster, you can use the mass action functionality.

To use this input in your architecture, you use:
    
    
    input_main = Input(shape=input_shapes["main"], name="main")
    

For this kind of input, the input_shape is provided by DSS (as part of the `input_shapes` dict), because the user does not know a priori how many columns were generated through the preprocessing (with dummification, vectorization…).

## Custom-processed single-feature inputs

Most preprocessings take one column and convert it into one or more columns. It is then simple to concatenate all the resulting columns to build an array that will be sent to the model. However, for deep learning, some preprocessings might return exotic shapes. In particular, for text and images, the output of the preprocessing might have 3 or more dimensions. Thus, they cannot be processed using regular preprocessing.

These cases are handled through custom-processed single-feature inputs. These deep learning inputs are automatically created by DSS and not editable when you select “Custom processing” for a text or image feature.

Custom-processed single-feature inputs hold the output of a single preprocessing for which we consider that it is special, i.e. that can be an array of any shape. For the time being, preprocessings that create this kind of inputs are:

  * Custom processing for Text feature

  * Custom processing for Image feature




When using these preprocessing, the output is sent to a newly created `featureName_preprocessed` deep learning input. You cannot modify this behaviour.

Besides, to prevent from using too much memory, custom text preprocessings are only fitted before running the model, not transformed. This means that DSS does not know the actual shape of the output of the preprocessing, and it is up to the user to fill the input_shape of the corresponding input in the model.

Note that there is no `fit` capability for custom image preprocessing.

See [Using image features](<images.html>) and [Using text features](<text.html>) for more information and examples of custom-processed single-feature inputs.

---

## [machine-learning/deep-learning/introduction]

# Introduction

You can build powerful deep learning models within the DSS visual machine learning component.

Note

Step-by-step instructions for [defining Deep Learning architectures with Keras and Tensorflow in Dataiku DSS](<https://knowledge.dataiku.com/latest/ml/deep-learning/code-within-visual-ml/tutorial-index.html>) are available in this How-To.

Deep learning in DSS is “semi-visual”:

  * You write the code that defines the architecture of your deep learning model

  * DSS handles all the rest:

    * Preprocessing your data (Handling missing values, categorical data, rescaling, …)

    * Feeding the model

    * Handling the training process, including epochs, generators, early stopping

    * Showing per-epoch training charts and giving early stopping capabilities

    * Integrating with Tensorboard

    * Building all results metrics and charts

    * Giving ability to score

    * Deploying deep learning models to API nodes for production deployments




DSS Deep Learning is based on the Keras + TensorFlow couple. You will mostly write Keras code to define your deep learning models.

DSS Deep Learning supports training on CPU and GPU, including multiple GPUs. Through container deployment capabilities, you can train and deploy models on cloud-enabled dynamic GPUs clusters.

Note

To create a model using a “fully-visual” task, check out [Computer vision](<../computer-vision/index.html>) feature instead.

---

## [machine-learning/deep-learning/runtime-gpu]

# Runtime and GPU support

The training/scoring of Keras models can be run on either a CPU, or one or more GPUs. Training on GPUs is usually much faster, especially when images are involved.

## Code environment

Deep Learning in DSS uses specific Python libraries (such as Keras and TensorFlow) that are not shipped with the DSS built-in Python environment.

Therefore, before training your first deep learning model, you must create a code environment with the required packages. See [Code environments](<../../code-envs/index.html>) for more information about code environments.

To help you, you can simply click “Add additional packages” in the “Packages to install” section of the code environment.

There you can select the “Visual Deep Learning: Tensorflow. CPU, and GPU with CUDA11.2 + cuDNN 8.1” package preset.

Once the proper environment is set-up, you can create a Deep Learning model. DSS will look for an environment that has the required packages and select it by default. You can select a different code environment at your own risk.

## Selection of GPU

If your DSS instance has access to any GPU resource(s), you can opt to train the model on a selection of these when you click ‘TRAIN’.

When you deploy a scoring or evaluation recipe, you can also choose to score or evaluate using GPU(s), configured in the recipe settings.

If a model trained on a GPU code environment is deployed as a service endpoint on an API node, the endpoint will require access to a GPU on the API node, and will automatically use GPU resources.

We enforce ‘allow growth’ on deep learning models ran on API nodes to ensure they only allocate the required memory (see TensorFlow [documentation](<https://www.tensorflow.org/guide/gpu#limiting_gpu_memory_growth>)).

## Using multiple GPUs for training

If you have access to GPU(s) on your DSS instance server or on any available containers, you can use them to speed up training. You will not need to change your model architecture to allow you to use GPUs, as DSS will manage this.

DSS will replicate the model on each GPU, then split each batch equally between GPUs. During the backwards pass, gradients computed on each GPU are summed. This is made possible thanks to TensorFlow’s [MirroredStrategy](<https://www.tensorflow.org/api_docs/python/tf/distribute/MirroredStrategy>).

This means that on each GPU, the actual batch_size will be batch_size / n_gpus. Therefore you should use a batch_size that is a multiple of the number of GPUs.

Note: To compare the speed of two trainings, you should always compare trainings with the same per GPU batch_size, i.e. if the first training is run on one GPU with a batch_size of 32, and the second on two GPUs, the batch_size should be 64.

---

## [machine-learning/deep-learning/text]

# Using text features

DSS provides several builtin ways to handle text features, such as Counts vectorization (See [Text variables](<../features-handling/text.html>) for more details).

However, for Deep Learning algorithms, you may want to use a Custom preprocessing to build 2-D or 3-D vectors . In that case, you need to write your own processor (See [Custom Preprocessing](<../features-handling/custom.html>)). You can use the TokenizerProcessor provided by DSS:
    
    
    from dataiku.doctor.deep_learning.preprocessing import TokenizerProcessor
    
    # Defines a processor that tokenizes a text. It computes a vocabulary on all the corpus.
    # Then, each text is converted to a vector representing the sequence of words, where each
    # element represents the index of the corresponding word in the vocabulary. The result is
    # padded with 0 up to the `max_len` in order for all the vectors to have the same length.
    
    #   num_words  - maximum number of words in the vocabulary
    #   max_len    - length of each sequence. If the text is longer,
    #                it will be truncated, and if it is shorter, it will be padded
    #                with 0.
    processor = TokenizerProcessor(num_words=10000, max_len=32)
    

With this example, the output for each text will have a (32) shape. Then, this output is sent to a textFeature_preprocessed input, so the corresponding input in the model should look like:
    
    
    input_text = Input(shape=(32), name="textFeature_preprocessed")
    

See [Deep learning for sentiment (text) analysis](<https://knowledge.dataiku.com/latest/ml-analytics/nlp/deep-learning-sentiment-analysis/tutorial-index.html>) for a step-by-step example of this in practice.

---

## [machine-learning/deep-learning/training]

# Training

The Training tab of the settings contains a set of parameters which indicates how the model will be trained.

To further customize the training of the model, you can switch to [Advanced training mode](<advanced.html>)

---

## [machine-learning/deep-learning/troubleshooting]

# Troubleshooting

Here is a list of known issues and limitations of the Visual Deep Learning.

## Using pre-trained models from Keras

Keras provides [“applications”](<https://www.tensorflow.org/api_docs/python/tf/keras/applications/>), which are state-of-the-art architectures trained on millions of data points that can be reused, for example, to do transfer learning.

For example, you can use [ResNet 50](<https://www.tensorflow.org/api_docs/python/tf/keras/applications/resnet50/ResNet50/>) as follows:
    
    
    from tensorflow.keras.applications import ResNet50
    model = ResNet50(weights="imagenet")
    

where weights can be “imagenet” (or None), and it means that they are weights on the architecture trained on [Imagenet](<https://fr.wikipedia.org/wiki/ImageNet>). It is the most interesting use case because these applications are big networks that require a lot of training data. In that case, it needs to download the weights of the model, which is only possible if you have access to the internet.

If you don’t have access to the internet, the code throws Exception: URL fetch failure.

To work around this issue, you need to have the file containing the weights of your model available locally on the server.

Each application has the possibility to load the model with a top (i.e. last fully connected layers for the classification and the corresponding weights) or without these last layers. It corresponds to the include_top parameter for each application. It means that for each application, there are two possible sets of weights: one for architecture with top and one without.

All weights files are available [here](<https://github.com/fchollet/deep-learning-models/releases>)

Once you have downloaded the appropriate files, you have two options:

  * manually put them at ~/.keras/models/. In that case, be sure to respect Keras naming for files.

  * put them inside a managed folder and then load them in the model with code like:

> import dataiku
>         import os
>         from tensorflow.keras.applications import ResNet50
>         
>         model = ResNet50(weights=None)
>         
>         weights_mf_path = dataiku.Folder("folder_containing_weights").get_path()
>         weights_path = os.path.join(weights_mf_path, "resnet_weights.h5")
>         
>         model.load_weights(weights_path)
>         




## Code environment lineage

The code environment used to train a model is attached to every action performed with that model afterwards.

If the model is trained in a GPU-aware code environment, all the following operations will have access to GPU(s):

  * the Retrain recipe - which will reuse training options

  * the Scoring/Evaluation recipes - you can choose in the recipe settings whether to use a GPU to run the recipe

  * on the API node, the DSS server needs to have access to a GPU, otherwise the code environment will fail to install. Then, for scoring, the model will be loaded on GPU (not possible to run it on CPU).




If you’re using TensorFlow 1.X and training a model in a code environment without GPU (not using the tensorflow-gpu package), it will not be possible to use a GPU for those operations.

Code environments using TensorFlow 2.0 or later are always GPU-aware and can run on CPU or GPU.

## TensorFlow session

TensorFlow provides [sessions](<https://www.tensorflow.org/api_docs/python/tf/compat/v1/Session>) to manage the environment on which the operations are performed. In particular, when we use GPU(s), we can define in these Sessions how we want to handle the computation and split into our different devices (CPU, GPU #0, GPU #1, …).

In the context of Visual Deep Learning, it is DSS that handles the session, so you should not use it inside its architecture. Otherwise, it could result in unwanted behaviors.

You can “modify” the session in the UI, when selecting the GPU(s). If you modify the “Memory allocation rate per GPU”, it will impact the config.gpu_options.per_process_gpu_memory_fraction of the session.

We also set the allow_soft_placement parameter to True. As per TensorFlow [documentation](<https://www.tensorflow.org/guide/gpu>):

> If you would like TensorFlow to automatically choose an existing and supported device to run the operations in case the specified one doesn’t exist, you can call tf.config.set_soft_device_placement(True).

In DSS this is useful when training on multiple GPUs.

## ML API

DSS provides an [Machine learning](<https://developer.dataiku.com/latest/api-reference/python/ml.html> "\(in Developer Guide\)") API to interact with models created in the visual machine learning part of the software. However, it is currently not available for Deep Learning.

## Number of outputs in the model

Keras allows you to build multi output architectures. For example, to perform object detection inside images or videos, you want to be able to predict the type of object and its position in the image.

Currently, the Deep Learning is only available in the _Prediction_ part of the Visual Machine Learning, which can treat various problems: Regression, Binary Classification and Multiclass Classification. All those types of problems require one output. Therefore it is currently not possible to have several outputs in an architecture.

## Enforced code environment for Project

DSS allows you to select a preferred code environment for a Project, and even allows you to enforce this code environment to be used in every code recipe/Visual ML. However, it currently conflicts with the process of pre-selecting a code environment when creating a new Deep Learning analysis, that will always override this behaviour by selecting a code environment with the appropriate packages.

If you want to enforce the usage of a code environment in your project, you would need to install the appropriate packages on it for being able to run deep-learning (see [Runtime and GPU support](<runtime-gpu.html>)). Then, when creating a new analysis, you should go to the _Python Environment_ tab, and select _Inherit project default_ (and ignore the warning that is displayed).

---

## [machine-learning/diagnostics]

# ML Diagnostics

ML Diagnostics are designed to identify and help troubleshoot potential problems and suggest possible improvements at different stages of training and building machine learning models.

Some checks are based on the characteristics of the datasets and serve as warnings to avoid common pitfalls when interpreting the evaluation metrics.

Other checks run additional tests after training to identify overfitting or potential data leakage, allowing you to fix these issues before deployment.

Use of Diagnostics can be disabled in Analysis > Design > Debugging.

## Dataset Sanity Checks

When evaluating a machine learning model it is important that the dataset used for evaluation is representative of both the training data and future scoring data. This is often referred to as the [i.i.d assumption](<https://en.wikipedia.org/wiki/Independent_and_identically_distributed_random_variables>).

**Test set might be too small for reliable performance estimation**

> If the test dataset is too small, the performance measurement may not be reliable. If possible provide a larger test set. If the test set is split from the training set, either use a larger percentage for the testing (default being 20%) or use [five fold cross-validation](<advanced-optimization.html#k-fold-cross-validation>).

**Target variable distribution in test data does not match the training data distribution, metrics could be misleading**

> If the test dataset’s target is drawn from a different distribution to that of the training dataset, the model may not be able to generalize and may perform poorly. For example if there is a difference in time between when the training and testing data were collected there may be changes in the data that it is important to address.
> 
> Statistical tests are performed to assess if the target distribution for the test set is drawn from the same distribution as that of the training set. For classification tasks a Chi-squared test is used and for regression tasks a Kolmogorov-Smirnov is used. A p-value of less than 0.05 means that the difference was considered statistically significant.
> 
> [Interactive statistics](<../statistics/index.html>) can be used to examine and better understand the distributions of these two datasets targets.

**Training set might be too small for robust training**

> For training a ML model, the training dataset should be large and diverse enough to capture all the needed patterns in order to make reliable predictions. While this is task dependent, a good rule of thumb is to try to gather more than 1000 observations in the dataset.

**The dataset is imbalanced, metrics can be misleading**

> When training a classification model one factor that can negatively impact the model is the balance between different classes. If one class is strongly underrepresented in the training data this may make it difficult for the model to make accurate predictions for this class. While Dataiku uses class weighting to aid in training models in the presence of imbalanced data, it is always better to gather more data for the underrepresented classes if at all possible.
> 
> During evaluation it is also important to be mindful of the impact this imbalance has on the metrics. For example in a binary classification task, if 94% of the target values are 1, then the accuracy would be 94% if the model always predicted 1. In this case it is best to use metrics that balance precision and recall, such as AUC or F1-score. The confusion matrix can also help to identify this type of failure.

**Only a subset of all time series charts are displayed**

> When training a time series forecasting model with too many time series (typically more than several thousands), then only a subset of them will be displayed in the model report forecast charts. Note that models are nevertheless trained on all time series and that evaluation metrics are available for all of them.

**Too many zero target values for the MAPE metric**

> The computation of the MAPE involves dividing by the target values. When training a time series forecasting model, if a time series contains too many zeros, then there is a high chance that all target values within an evaluation set are zero, resulting in an undefined MAPE metric.

**The treatment variable is imbalanced**

> One of the treatment groups (including control) is severely underrepresented. This can cause issues such as: training or scoring failures (especially during hyperparameter search), biased predictions (CATEs), misleading causal metrics.

**The combination of treatment and outcome variables is imbalanced**

> One of the (treatment, outcome) variables combinations is severely underrepresented. Similarly to severe imbalance in the treatment variable, this can cause issues such as: training or scoring failures (especially during hyperparameter search), biased predictions (CATEs), misleading causal metrics.

## Modeling Parameters

Some modeling parameters need to be adapted to the characteristics of the data, otherwise they could lead to slower training time, possible data leakage, overfitting or creation of a model learnt on an inaccurate data representation.

**Outlier detection: The mini-cluster size threshold may be too high with respect to the training dataset size. Training might fail. Consider using a smaller value.**

> When performing outlier detection for a clustering ML task with a mini-cluster size threshold that is too high, all rows are likely to be dropped before training. If this happens, the training will fail. To avoid this, consider reducing the mini-cluster size threshold to less than ~10% of the training set size.

**Feature handling configuration on columns X, Y and Z is causing N% of the test/train/input dataset rows to be dropped during preprocessing**

> Feature Handling can be configured so that rows with no value on a certain column are dropped. When enabled, this diagnostic is displayed if more than 50% of the dataset is dropped during preprocessing. If this occurs, consider modifying the Feature Handling configuration.
> 
> The columns named in the diagnostic message are sorted by the number of rows dropped. Dataiku performs each preprocessing step sequentially, dropping rows with null values one column at a time. These steps in which rows are dropped by column are ordered arbitrarily. This means that the per-column total dropped row counts are not completely accurate, as any given row could contain multiple null values across a number of columns and will be dropped in whichever column dropping step occurs first. In practice, disabling ‘drop rows where missing values are null’ for any single column mentioned in the error message may not lead to a reduction in the total percentage of rows dropped across the entire dataset.
> 
> The ‘input’ designation is used when K-fold cross-testing is enabled.

**Calculation of X failed**

> The custom metric with name X has failed to calculate. Check the logs of the performed action for detailed information about the failure.

## Training Speed

Training speed might not be optimal due to runtime environment bottlenecks, hyperparameter search strategy or other factors.

**N remote workers failed**

> In distributed hyperparameter search mode, some of the remote workers may fail, without interrupting the whole search. The search thus runs slower because of a reduced number of running workers. This might be due to a failure to start a kubernetes pod, or some other issue on the cluster.

**N remote workers taking a long time to start**

> When performing a distributed hyperparameter search, some remote workers are taking more than 2 minutes to start. This might be due to a bottleneck in the kubernetes cluster, _e.g._ the maximum number of running pods is reached.

**N remote workers took more than T to start**

> In distributed hyperparameter search mode, some remote workers started successfully but took more than 2 minutes to start (T is the minimum time for a remote worker to start). This might be due to a bottleneck in the kubernetes cluster, or a slow starting process in the container.

**Requested GPU but no device is available, using CPU**

> For certain machine learning tasks, training will be significantly slower if performed on a CPU. This diagnostic is raised when a GPU was selected before training, but Dataiku was unable to detect one when executing the process. If this happens, please contact your system administrator to verify your environment is correctly configured.

## Overfitting Detection

Training a machine learning model is a delicate balance between bias and variance. If the model does not capture enough information from the data, it is under-fit. It will have a high bias and will be unable to make accurate predictions. On the other hand if the model is overfit, it has fit the data in the training set too closely, learning the noise specific to this training set and it will fail to generalize to new unseen data, it has too high variance.

**The algorithm seems to have overfit the train set, all the leaves in the model are pure**

> For tree-based algorithms, another way to identify likely overfitting is to examine the leaves in the trees. For a classification task if the model has been able to partition the data fully, unless the task is relatively simple, then it has probably overfit and the model size needs to be restricted. This can be detected if all the leaves in the model are pure.

**Number of tree leaves is too large with respect to dataset size**

> For regression tasks, the number of the leaves in a tree can hint at overfitting. If the number of leaves in a tree is greater than 50 percent of the number of samples then it could be indicative that this tree has overfit this data sample. For tree ensembles such as Random Forest, if more than 10 percent of the trees in the model are overfit, it may be worth checking the parameters of the model.

The best way to avoid overfitting is always to add more data if possible as well as adding regularization. This can be addressed by constraining the model further, by changing the hyperparameters of the algorithm. Use additional regularization or decrease the values of the hyperparameters that control the size of the model.

## Leakage Detection

Data Leakage occurs when information that will not be available at test/scoring time accidentally appears in the training dataset, this allows the model to achieve unrealistically high performance during training, though it will fail to reproduce this performance once deployed. A good example of data leakage would be for a sales prediction task, if windowing features capturing all sales for the previous week are used, but that window includes the day to be predicted, the model will have information about the sales on the day it is trying to predict.

**Too good to be true?**

> One indicator that data leakage might have occurred is an extremely high performance metric such as > 98% AUC.

**Feature has suspiciously high importance which could be indicative of data leakage or overfitting**

> If data leakage has occurred, the feature importances can offer insights into which features contain leaked data as the model will attribute very high importances to these features. Dataiku will warn you if it identifies that a single feature accounts for more than 80% of the feature importance.

## Model Checks

When evaluating machine learning models, it is helpful to have a baseline model to compare with in order to establish that the model is performing better than an extremely simple rule. A good baseline is a dummy model which simply predicts the most common value. Especially in the presence of imbalanced data, this can give a more accurate picture of how much value this model is really able to bring.

**The model does not perform better than a random classifier**

> Dataiku calculates the performance a dummy classifier would achieve on this dataset and performs a statistical test to ensure that the trained model performs better. If the trained model does not outperform the dummy classifier it could be indicative of problems in the data preparation or a lack of data for underrepresented classes.

**R2 score is suspiciously low - the model is marginally better than a naive model which always predicts the mean** / **This model performed worse than a naive model which always predicts the mean**

> For a regression model, if the R2 metric is too low it means that the model is unable to perform better than a naive model which always predicts the mean. It could be beneficial to add more features or data to the model.

## Training Reproducibility

**Hyperparameter search might not be reproducible when training time series forecasting models with multiple threads**

> For time series forecasting models, hyperparameter search might not be reproducible if the select number of threads is not 1.

## Scoring Dataset Sanity Checks

**Ignoring time series not seen during training**

> When running a scoring recipe for a statistical time series forecasting model, time series that were not seen during training are ignored.

**Ignoring time series with not enough past values**

> Time series forecasting models require input time series to have a minimum length. When running a scoring recipe, time series that are too short are ignored.

**Ignoring time series with not enough future values of external features**

> Time series forecasting models trained with external features require one horizon of future values of these external features to make forecasts. When running a scoring recipe, time series that don’t have enough future values of external features are ignored.

## Evaluation Dataset Sanity Checks

**Ignoring time series not seen during training**

> When running an evaluation recipe for a statistical time series forecasting model, time series that were not seen during training are ignored.

**Ignoring time series with not enough past values**

> Time series forecasting models require input time series to have a minimum length. When running an evaluation recipe, time series that are too short are ignored.

## Time Series Resampling Checks

**Ignoring time series with less than 2 valid time steps**

> Only time series with at least 2 valid time steps (i.e. with valid target value) can be resampled. Time series with less than 2 time steps are ignored in the scoring and evaluation recipes.

## Causal Prediction Treatment Checks

**The treatment variable is not randomly distributed**

> Standard metrics could be misleading. To mitigate this, try enabling inverse propensity weighting. This is not necessarily an issue for the reliability of predictions (CATEs).

**Treatment values probability distributions have non-overlapping supports (positivity failure)**

> Predictions (CATEs) could be biased due to missing data to model counterfactuals (see the main documentation on [causal predictions](<causal-prediction/introduction.html>) for definitions). To mitigate this issue, the study should be restricted to a subpopulation where the [positivity assumption](<causal-prediction/results.html#positivity>) holds. The treatment allocation process should also be investigated and modified to guarantee that all individuals are exposed to all treatments (including the control).

## Causal Prediction Propensity Model Checks

**The propensity model is not well calibrated**

> If not well calibrated, propensity predictions can be biased, and inverse propensity weighted metrics (if enabled) can be misleading. To mitigate this, try enabling calibration for the propensity model or increasing the ratio of the calibration data.

## ML assertions

[ML assertions](<supervised/ml-assertions.html>) provide a way to streamline and accelerate the model evaluation process, by automatically checking that predictions for specified subpopulations meet certain conditions.

Dataiku raises diagnostics to warn you when assertions could not be computed or fail.

**X assertion(s) failed**

> Dataiku computes each assertion and warns you if any fail.

**X assertion(s) got 0 matching rows**

> After applying the filter on the test set, a diagnostic is raised if the subsample is empty i.e. none of the rows met the criteria.

**X assertion(s) got matching rows but all rows were dropped by the model’s preprocessing**

> After applying the model’s preprocessing to the subsample a diagnostic is raised if the preprocessed subsample is empty, i.e. all rows that matched the criteria were dropped during the preprocessing. Rows may have been dropped because of the feature handling chosen, or because targets were not defined for those rows.

In the 3 diagnostic examples above, X is an integer less than or equal to the total number of assertion defined for the ml task.

## Abnormal Predictions Detection

An imbalanced dataset or inadequate training parameters can lead to models that almost always predict the same class.

**The model predicts almost always the same class**

> A diagnostic is raised if a model predicted the same class for almost all the samples. It could be indicative of an imbalanced dataset.

---

## [machine-learning/ensembles]

# Models ensembling

You can ensemble prediction models in DSS using various ensembling methods.

In the analysis results page, select several models, and click Actions > Create ensemble model.

## Limitations

  * Only models trained with the same preprocessing settings can be ensembled.

  * It is not possible to ensemble models with different time ordering or weight parameters.

  * It is not possible to ensemble models trained using K-Fold cross-test.

  * It is not possible to ensemble models trained with vector or image features.

  * It is not possible to ensemble partitioned models.

  * It is not possible to ensemble computer vision models.

  * After deployment as a saved model, it is not possible to retrain an ensemble model on the automation node.

  * After deployment as a saved model, it is not possible to retrain an ensemble model if the original models have been removed from the analysis screen.

---

## [machine-learning/features-handling/categorical]

# Categorical variables

The **Category handling** and **Missing values** methods, and their related controls, specify how a categorical variable is handled.

## Category handling

  * **Dummy-encoding (vectorization)** creates a vector of 0/1 flags of length equal to the number of categories in the categorical variable. You can choose to drop one of the dummies so that they are not linearly dependent, or let Dataiku decide (in which case the least frequently occurring category is dropped). There is a limit on the number of dummies, which can be based on a maximum number of categories, the cumulative proportion of rows accounted for by the most popular rows, or a minimum number of samples per category.

  * **Replace by 0/1 flag indicating presence**

  * **Feature hashing (for high cardinality)**

  * Target encoding

  * Ordinal encoding

  * Frequency encoding




### Target encoding

Target encoding replaces each category by a numerical value computed based on the target values. The following encoding methods are available:

  * Impact coding (M-estimator)

  * GLMM encoding (experimental support)




The options for target encoding are:

  * **K-fold (boolean)** : enables K-fold, mainly to avoid leaking the target variable into the encoded features.

  * **Number of folds (integer)** to be used for K-fold (default: 5).

  * **Random seed (integer)** for the K-fold shuffling.

  * **Rescaling** method for the resulting numerical feature(s) (see [Rescaling](<numerical.html#rescaling>)).




Note

For a multiclass classification task with \\(N\\) classes, the encoded variable is converted into \\(N-1\\) encoding columns (one per class except the least occurring class) by applying the one-vs-all strategy.

#### Impact coding

Impact coding (a.k.a M-Estimate encoding) replaces each category by the mean of the target variable for this category. More precisely the computed mean is given by:

\\[\frac{n \cdot \bar{Y}_{cat} + m \cdot \bar{Y}}{n + m}\\]

where:

  * \\(\bar{Y}_{cat}\\) is the mean of the target variable for the category.

  * \\(\bar{Y}\\) is the global mean of the target variable.

  * \\(n\\) is the number of rows in the category.

  * \\(m\\) controls how much the global mean is taken into account when computing the target encoding (additive smoothing, especially useful when there are categories with only a few samples). If \\(m \ll n\\) then impact coding will mostly be defined by the mean of the target for the category. If \\(m \gg n\\) then it will mostly be defined by the global mean.




#### GLMM encoding

Warning

Support for GLMM encoding is experimental.

This encoding relies on the [Generalized Linear Mixed Models](<https://en.wikipedia.org/wiki/Generalized_linear_mixed_model>) statistical theory to compute the encodings. The general form of the model is:

\\[\mathbb{E}\left[Y \mid U, V\right] = g^{-1}\left(U \alpha + V \beta \right)\\]

where:

  * \\(Y\\) is the outcome variable (the target).

  * \\(U\\) is the fixed-effects matrix.

  * \\(\alpha\\) is the fixed-effects regression coefficients.

  * \\(V\\) is the random-effects matrix.

  * \\(\beta\\) the random-effects regression coefficients.

  * \\(g\\) is the link function (identity for a regression task, logistic function for classification). It allows to fit targets which are not distributed according to a gaussian.




After fitting the model, the encodings are extracted from \\(\beta\\), as the variability of the target within a category is modeled as a random effect.

### Ordinal encoding

Ordinal encoding assigns a unique integer value to each category, according to an order defined by:

  * **Count** : The number of occurrences of each category.

  * **Lexicographic** : The lexicographic order of the categories.




The order can be descending or ascending, and unknown categories can be replaced either by the **Highest value (maximum + 1)** , the **Median value** , or an **Explicit value**.

### Frequency encoding

Frequency encoding replaces the categories by their number of occurrences, normalized or not by the total number of occurrences. If the number of occurrences is not normalized, it can be rescaled using the same methods as standard numerical features (see [Rescaling](<numerical.html#rescaling>)).

## Missing values

There are a few choices for handling missing values in categorical features.

  * **Treat as a regular value** treats missing values as a distinct category. This should be used for **structurally missing** data that are impossible to measure, e.g. the US state for an address in Canada.

  * **Impute…** replaces missing values with the specified value. This should be used for **randomly missing** data that are missing due to random noise.

  * **Drop rows** discards rows with missing values from the model building. _Avoid discarding rows, unless missing data is extremely rare_.

---

## [machine-learning/features-handling/custom]

# Custom Preprocessing

DSS allows to define custom python preprocessings, in order to plug user-generated code which will process a feature.

## Implementing a custom processor

“Custom preprocessing” must be selected in the feature handling options.

The custom processor should be a class with at least two methods:
    
    
    def fit(self, series):
    def transform(self, series):
    

Here, series is a pandas Series object representing the feature column. The fit method does not need to return anything, but must modify the object in-place if fitting is necessary. The transform method must return either a pandas DataFrame or a 2-D numpy array or scipy.sparse.csr_matrix containing the preprocessed result. Note that a single processor may output several numerical features, corresponding several columns of the output.

To use your processor in the visual ML UI, you must import it and instantiate it in the code editor, by assigning the processor to the `processor` variable.

Warning

Classes cannot be declared directly in the Models > Design tab. They must be packaged in a [library](<../../python/reusing-code.html>) and imported, as demonstrated in the examples below.

### Example

  * On the Models > Design > Feature handling tab, in the “Custom preprocessing” code editor, you should create the `processor` variable.

> from my_custom_processor import MyProcessor
>         
>         processor = MyProcessor()
>         

  * Make sure that the option “Proc. wants matrix” is disabled. (When this option is enabled, custom processors receive a single-column `DataFrame` instead of a `Series`).

  * In `my_custom_processor.py`:

> import pandas as pd
>         
>         class MyProcessor:
>             """This processor adds a new `clipped_column` column which
>             clips the `original_column` at its 10th highest value"""
>         
>             def __init__(self):
>                 self.max_value = None
>         
>             def fit(self, series):
>                 # compute the 10th highest value
>                 self.max_value = series.nlargest(10).iloc[-1]
>         
>             def transform(self, series):
>                 df = pd.DataFrame(series.values, columns=["original_column"])
>                 df["clipped_column"] = df["original_column"].clip(upper=self.max_value)
>                 return df
>         




## Naming output columns

When generating features, it is important to give them a meaningful name in order to interpret the resulting model. For instance, it is convenient when analyzing the variables importance or the regression coefficients for linear models.

If you return a `pandas.DataFrame`, the name of the columns will be the name of the output features.

If you prefer to return a numpy array or a scipy.sparse.csr_matrix, then the processor should be also have a `names` attribute, containing the list of the output feature names.

### Example

  * On the Models > Design > Feature handling tab, in the “Custom preprocessing” code editor, you should create the `processor` variable.

> from my_custom_processor import MyProcessor
>         
>         processor = MyProcessor()
>         

  * Make sure that the option “Proc. wants matrix” is disabled. (When this option is enabled, custom processors receive a single-column `DataFrame` instead of a `Series`).

  * In `my_custom_processor.py`:

> import numpy as np
>         
>         class MyProcessor:
>             """This processor adds a new `clipped_column` column which
>             clips the `original_column` at its 10th highest value"""
>         
>             def __init__(self):
>                 self.names = ["original_column", "clipped_column"]
>                 self.max_value = None
>         
>             def fit(self, series):
>                 # compute the 10th highest value
>                 self.max_value = series.nlargest(10).iloc[-1]
>         
>             def transform(self, series):
>                 # computed the clipped series
>                 clipped_series = series.clip(upper=self.max_value)
>                 # return a numpy array with both series
>                 return np.array([
>                     series.values,
>                     clipped_series.values
>                 ]).T
>

---

## [machine-learning/features-handling/genetic-algorithm-for-feature-engineering]

# Genetic Algorithm for Feature Generation and Selection

This capability provides recipes to create and select features with a genetic algorithm based on the DEAP framework. It is provided by the “Feature generation and selection with genetic algorithms” plugin, which you need to install. Please see [Installing plugins](<../../plugins/installing.html>).

## Overview

Genetic Algorithms are inspired by the concepts of evolution through natural selection. They are often used in high dimensional spaces where grid / random search would be prohibitive.

Genetic Algorithms encode the space to explore with genes and proceed by generations. For each generation: \- individuals forming the current population are evaluated (fitness) \- the best individuals are chosen to mix their genes together (crossover) \- independent random changes are performed (mutation).

This plugin deals with feature creation and selection, powered by genetic algorithms. Starting from a dataset with features and a target, it will automatically select among features both from the dataset and their combinations (product, sum and differences). In this setting, an individual is represented by a boolean array with a value for every feature (originals and combinations) indicating whether it is selected or not as an input for the model to train.

## Usage - Fit Transform Recipe

### Parameters

  * Target is the target of the machine learning prediction task.

  * Population is the number of individuals considered at the first generation.

  * Crossover probability is the probability that a random exchange of genes will happen for two individuals selected to form the next generation.

  * Mutation probability is the probability that a random flip occurs for each feature of an individual (from active to inactive or vice versa).

  * Number of generations is the number of iterations of the evolutionary process (fitness, crossover and mutation) over the whole population.




### Input

  * A dataset of features from which we want to select and create new features. Features should be numerical, and contain no missing values.




### Outputs

  * A dataset of selected and created features.

  * A folder containing the json of information




## Usage - Transform Recipe

### Input

  * A dataset of features for which we want to apply the selection/creation pipeline.

  * A folder output of a previous fit-transform recipe that contains the information json.




### Outputs

  * A dataset of selected and created features.

---

## [machine-learning/features-handling/images]

# Image variables

Image variables are supported for training a tabular model in Visual ML with the Python backend. In order to leverage images, make sure they are stored in a [Managed Folder](<../../connecting/managed_folders.html>). Your training dataset should contain a column that indicates the path of each image within that managed folder.

Image variables are also usable for deep learning models. See [deep learning image features](<../deep-learning/images.html>) for more information.

## Image handling

### Image embedding

Image embedding creates semantically meaningful vector representation of images.

In DSS, this image handling method makes use of image embedding models from the [LLM Mesh](<../../generative-ai/index.html>). Each image is passed to the selected model, the outputs are then pooled to an embedding vector with a fixed size (specific to the model).

The supported models are:

  * timm models using the [timm](<https://huggingface.co/timm/>) library. To select a timm model you need access to a [Local HuggingFace connection](<../../generative-ai/huggingface-models.html>) with image embeddings models enabled.   
The configuration of the connection exposing the model is applied (caching, auditing, …).

  * Google Vertex AI multimodal embedding. You need access to a Vertex Generative AI connection with a multimodal model enabled.

  * AWS Titan Embeddings G1 - Multimodal. You need access to a Bedrock connection with a multimodal model enabled.




Warning

Image embedding feature handling using local (Hugging Face) image embedding models is not supported on the API node.

## Missing values

Options for handling missing values in an image feature:

  * **Drop rows** discards rows with missing values from the model building. This means dropping them from the training, and not predicting these rows when scoring. _Avoid discarding rows, unless missing data is extremely rare_.

  * **Fail if missing values found** fails training (and scoring) when the image paths is either missing or does not correspond to an image file in the managed folder.

  * **Impute** replaces missing values with empty embeddings (zeros). This should be used for _randomly missing_ data due to random noise or incomplete data. You can also use this if the trained model should support scoring rows without any image.

---

## [machine-learning/features-handling/imbalanced-data]

# Imbalanced Data

Imbalanced data occurs when one target class is much less frequent than another, which can bias models toward the majority class and reduce recall on rare but important outcomes. One common mitigation is oversampling, where additional minority-class examples are generated to rebalance training data; see [Classification Oversampling Concept](<../../connecting/synthetic-data-generation.html#classification-oversampling-concept>) for multiple synthetic oversampling approaches (CVAE, SMOTENC, ADASYN).

---

## [machine-learning/features-handling/index]

# Features handling

Note

You can change the settings for feature processing under Models > Settings > Features tab

Most [machine learning engines](<../algorithms/index.html>) in DSS visual machine learning can only process numerical features, with no missing values.

DSS allows users to specify pre-processing of variables before model training.

---

## [machine-learning/features-handling/numerical]

# Numerical variables

The **Numerical handling** and **Missing values** methods, and their related controls, specify how a numerical variable is handled.

## Numerical handling

  * **Keep as a regular numerical feature** simply takes the numerical input as is, with optional Rescaling. In addition, post-rescaling, you can request that derived features such as sqrt(x), x^2, … be generated and considered in the model.

  * Datetime cyclical encoding (Python training backend only).

  * **Replace by 0/1 flag indicating presence**.

  * **Binarize based on a threshold** replaces the feature values with a 0/1 flag that indicates whether the value is above or below the specified threshold.

  * **Quantize** replaces the feature values with their quantiles in the feature’s empirical distribution. More precisely if we set the number of quantiles to \\(n\\), the numerical feature will be split into \\(n\\) intervals (quantiles), each containing one \\(nth\\) of the feature values. Finally each numerical value is replaced by the index (from \\(0\\) to \\(n - 1\\)) of the interval it belongs to.




All numerical handlings (except 0/1 presence flag) offer the possibility to keep the original numerical feature as an extra feature that can in turn be rescaled.

### Datetime cyclical encoding

Datetime cyclical encoding transforms datetime features (timestamps) into numerical features, while preserving the cyclical significance of date and time periods.

More specifically for every selected time period \\(T\\) (either minute, hour, day, week, month, quarter or year), the datetime cyclical encoding converts the timestamp or date to a number of seconds \\(t\\) and then encodes \\(t\\) into two numerical features using the following formulas:

\\[\begin{split}\begin{cases} \sin\left(\dfrac{2\pi \cdot t}{T}\right) \\\ \\\ \cos\left(\dfrac{2\pi \cdot t}{T}\right) \end{cases}\end{split}\\]

In order to take into account leap seconds and leap years, the timestamp is first converted to a number of seconds for each selected period. By way of example, we’ll detail the computation for the 2021-09-27T02:17:35 reference timestamp.

  * **minute** : \\(t\\) is defined as the number of seconds since the beginning of the same minute (i.e. 35 seconds in our example).

  * **hour** : \\(t\\) is defined as the number of seconds since the beginning of the same hour (i.e. 17*60 + 35 seconds in our example).

  * **day** : \\(t\\) is defined as the number of seconds since the beginning of the same day, at 00:00:00 (i.e. 2*3600 + 17*60 + 35 seconds in our example).

  * **week** : \\(t\\) is defined as the number of seconds since Monday of the same week, at 00:00:00 (i.e. since 2021-09-21T00:00:00 in our example).

  * **month** : \\(t\\) is defined as the number of seconds since the first day of the same month, at 00:00:00 (i.e. since 2021-09-01T00:00:00 in our example).

  * **quarter** : \\(t\\) is defined as the number of seconds since the first day of the same quarter,at 00:00:00 (i.e. since 2021-07-01T00:00:00 in our example).

  * **year** : \\(t\\) is defined as the number of seconds since the first day of the same year, at 00:00:00 (i.e. since 2021-01-01T00:00:00 in our example).




The reference period durations are:

  * \\(T = 60\ s\\) for **minute** ,

  * 60 minutes (\\(T = 3600\ s\\)) for **hour** ,

  * 24 hours (\\(T = 86400\ s\\)) for **day** ,

  * 7 days (\\(T = 604800\ s\\)) for **week** ,

  * 31 days (\\(T = 2678400\ s\\)) for **month** ,

  * 92 days (\\(T = 7948800\ s\\)) for **quarter** ,

  * 366 days (\\(T = 31622400\ s\\)) for **year**.




## Rescaling

Rescaling can be performed prior to training, which can improve model performance in some instances. We advise to rescale numeric variables in the following cases:

  * Algorithms that are not based on decision trees (rescaling has no effect on decision trees) are selected.

  * There are large differences in the absolute values of the features.




There are two implementations of rescaling.

>   * **Standard rescaling** scales the feature to a standard deviation of one and a mean of zero (default setting).
> 
>   * **Min-max rescaling** sets the minimum value of the feature to zero and the max to one.
> 
> 


## Missing values

There are a few choices for handling missing values in numerical features.

  * **Impute…** replaces missing values with the specified value. This should be used for **randomly missing** data that are missing due to random noise.

  * **Drop rows** discards rows with missing values from the model building. _Avoid discarding rows, unless missing data is extremely rare_.

---

## [machine-learning/features-handling/plugin-preprocessors]

# Plugin Preprocessors

Visual ML feature handling can be extended with plugin-based preprocessors for numerical and categorical features.

In the **Features** tab, these preprocessors appear as the **Plugin preprocessing** option for compatible features. They let plugin authors provide custom preprocessing logic and parameters, while keeping the configuration in the standard Visual ML interface.

For the full component reference, compatibility and limitations, see [Component: Feature preprocessor](<../../plugins/reference/ml-preprocessors.html>).

---

## [machine-learning/features-handling/roles-and-types]

# Features roles and types

## Roles

A feature’s role determines how it’s used during machine learning.

  * **Reject** means that the feature is not used

  * **Input** means that the feature is used to build a model, either as a potential [predictor for a target](<../supervised/index.html>) or for [clustering](<../unsupervised/index.html>). For time-series forecasting, **Input** means that the feature is used as an [external variable](<../time-series-forecasting/settings.html#forecasting-external-features>) (handled by some time-series forecasting models). External variables can be either known-in-advance or past-only (the latter is supported by machine-learning-based forecasting).

  * **Use for display only** means that the feature is not used to build a model, but is used to label model output. This role is currently only used by cluster models.




## Variable type

A feature’s variable type determines the feature handling options during machine learning.

  * **Categorical** variables take one of an enumerated list values. The goal of categorical feature handling is to encode the values of a categorical variable so that they can be treated as numeric.

  * **Numerical** variables take values that can be added, subtracted, multiplied, and so on. There are times when it may be useful to treat a numerical variable with a limited number of values as categorical.

  * **Text** variables are arbitrary blocks of text. If a text variable takes a limited number of values, it may be useful to treat it as categorical.

  * **Vector** variables are arrays of numerical values, of the same length.

  * **Image** variables are available for Deep learning. See [Using image features](<../deep-learning/images.html>) for more information.




Note

For MLflow Models, string and boolean features will be considered **Categorical**.

---

## [machine-learning/features-handling/self-supervised-tabular-embeddings]

# Self-Supervised Tabular Embeddings

This capability provides recipes to automatically learn and generate dense feature representations (embeddings) from tabular data using a self-supervised deep learning approach. It is provided by the **Tabular Self-Supervised Learning** plugin, which you need to install. Please see [Installing plugins](<../../plugins/installing.html>).

## Overview

Self-supervised learning (SSL) helps discover complex patterns and relationships in your data without requiring target labels. This is achieved by training a **Masked-Feature Autoencoder** —a neural network designed to reconstruct its own input.

During training, the system intentionally hides (masks) a percentage of features in each row. The model is forced to predict these missing values by learning the underlying functional dependencies between all variables in the dataset. This process produces an **encoder** capable of translating raw, sparse data into a dense vector of “latent” features that capture the semantic essence of the record.

## Tabular Embedding Pretraining recipe

This recipe trains the autoencoder on a representative dataset to learn the feature interactions.

### Input

  * A training dataset (no labels required).




### Outputs

  * A managed folder containing the trained model weights and preprocessing metadata

  * A metrics dataset to monitor training convergence




### Parameters

  * Columns to ignore: Features to exclude from the learning process, such as potential future target variables.

  * Embedding dimension: The size of the final latent vector; smaller dimensions force higher compression.

  * Mask ratio: The fraction of input features hidden during each training step (e.g., 0.3).

  * Training process: Standard hyperparameters including Epochs, Batch size, and Learning rate.

  * Cross-validation: Optional K-Fold validation to ensure the model generalizes to unseen data.




## Tabular Embedding Inference recipe

This recipe uses a pretrained encoder to transform datasets into dense feature sets.

### Input

  * The dataset to transform

  * A Managed Folder containing the model to use for inference.




### Outputs

  * The original dataset with an additional column containing the learned vector representation.




### Parameters

  * Embedding column name: The name for the new vector column (defaults to `embedding`).

  * Batch size: The number of rows processed simultaneously during inference.




## Feature Handling

The recipes include a built-in preprocessing layer to ensure data is compatible with deep learning:

  * Scaling & Encoding: Numerical values are mean-scaled, and categorical values are one-hot encoded.

  * Missing Values: Handled via “missing” tokens for categories and mean-imputation for numerical columns.

  * Concept-Aware Masking: The masking logic hides entire one-hot encoded groups together, forcing the model to learn the high-level semantic concept of a category.




## Use Cases

  * **Augmenting Small Labeled Datasets** : Pretrain the autoencoder on a large unlabeled dataset to provide supervised models with “pre-learned” domain knowledge.

  * **Automated Feature Engineering** : Capture high-order, non-linear interactions between dozens of variables without manual intervention.

  * **Dimensionality Reduction** : Compress high-cardinality or sparse datasets into a dense, lower-dimensional space while preserving structural information.

---

## [machine-learning/features-handling/text]

# Text variables

The **Text handling** and **Missing values** methods, and their related controls, specify how a text variable is handled.

## Text handling

  * **Count vectorization**

  * **TF/IDF vectorization**

  * **Hashing trick** (producing sparse matrices)

  * **Hashing trick + Truncated SVD** (producing smaller dense matrices for algorithms that do not support sparse matrices)

  * Text embedding (Python training backend only)
    
    * From the code environment resources

    * From the LLM Mesh




For the specific case of deep learning, see [text features in deep-learning models](<../deep-learning/text.html>)

### Text embedding

Text embedding creates semantically meaningful dense matrix representations of text. In DSS, this text handling method makes use of API-based models through the [LLM Mesh](<../../generative-ai/llm-connections.html>) or local transformer models using the [transformers](<https://huggingface.co/transformers/>) and [sentence-transformers](<https://www.sbert.net/>) libraries. Each text sample is passed through the selected model. The outputs are then pooled to an embedding with a model-specific fixed size. For local transformer models, the computations can be configured to use a GPU. You can either choose models downloaded to the code environment resources or models from the [LLM Mesh](<../../generative-ai/index.html>).

### Using models from the code environment resources

When using text embedding in Visual ML, the selected environment in the runtime environment requires the `sentence-transformers` python package to be installed. You can install all necessary packages by adding the “Visual Machine Learning with Sentence Embedding” package set, in the code-environment “Packages to install” tab.

Text embedding also requires models to be downloaded. This can be done via the [managed code environment resources directory](<../../code-envs/operations-python.html#code-env-resources-directory>).

See below for an example code environment resources initialization script.
    
    
    ######################## Base imports #################################
    import logging
    import os
    import shutil
    
    from dataiku.code_env_resources import clear_all_env_vars
    from dataiku.code_env_resources import grant_permissions
    from dataiku.code_env_resources import set_env_path
    from dataiku.code_env_resources import set_env_var
    from dataiku.code_env_resources import update_models_meta
    
    # Set-up logging
    logging.basicConfig()
    logger = logging.getLogger("code_env_resources")
    logger.setLevel(logging.INFO)
    
    # Clear all environment variables defined by a previously run script
    clear_all_env_vars()
    
    ######################## Sentence Transformers #################################
    # Set sentence_transformers cache directory
    set_env_path("SENTENCE_TRANSFORMERS_HOME", "sentence_transformers")
    
    import sentence_transformers
    
    # Download pretrained models
    MODELS_REPO_AND_REVISION = [
        ("DataikuNLP/average_word_embeddings_glove.6B.300d", "52d892b217016f53b6c717839bf62c746a658933"),
        ("DataikuNLP/TinyBERT_General_4L_312D", "33ec5b27fcd40369ff402c779baffe219f5360fe"),
        ("DataikuNLP/paraphrase-multilingual-MiniLM-L12-v2", "4f806dbc260d6ce3d6aed0cbf875f668cc1b5480"),
        # Add other models you wish to download and make available as shown below (removing the # to uncomment):
        # ("bert-base-uncased", "b96743c503420c0858ad23fca994e670844c6c05"),
    ]
    
    sentence_transformers_cache_dir = os.getenv("SENTENCE_TRANSFORMERS_HOME")
    for (model_repo, revision) in MODELS_REPO_AND_REVISION:
        logger.info("Loading pretrained SentenceTransformer model: {}".format(model_repo))
        model_path = os.path.join(sentence_transformers_cache_dir, model_repo.replace("/", "_"))
    
        # Uncomment below to overwrite (force re-download of) all existing models
        # if os.path.exists(model_path):
        #     logger.warning("Removing model: {}".format(model_path))
        #     shutil.rmtree(model_path)
    
        # This also skips same models with a different revision
        if not os.path.exists(model_path):
            model_path_tmp = sentence_transformers.util.snapshot_download(
                repo_id=model_repo,
                revision=revision,
                cache_dir=sentence_transformers_cache_dir,
                library_name="sentence-transformers",
                library_version=sentence_transformers.__version__,
                ignore_files=["flax_model.msgpack", "rust_model.ot", "tf_model.h5",],
            )
            os.rename(model_path_tmp, model_path)
        else:
            logger.info("Model already downloaded, skipping")
    # Add text embedding models to the code-envs models meta-data
    # (ensure that they are properly displayed in the feature handling)
    update_models_meta()
    # Grant everyone read access to pretrained models in sentence_transformers/ folder
    # (by default, sentence transformers makes them only readable by the owner)
    grant_permissions(sentence_transformers_cache_dir)
    

### Using models from the LLM Mesh

You can also select text embeddings extraction models enabled from the [LLM connections](<../../generative-ai/knowledge/initial-setup.html#embedding-llms>).

When selecting models from the LLM Mesh, the configuration of the connection exposing the model is applied (caching, auditing, …).

Warning

Models from the LLM Mesh are not supported on the API node.

## Missing values

For text features except Text embedding, DSS supports treating missing values as empty strings. Missing values for Text embedding handling are imputed with empty embeddings (zeros).

---

## [machine-learning/features-handling/vectors]

# Vector variables

The **Vector handling** and **Missing values** methods, and their related controls, specify how a vector variable is handled.

  * **Unfold (create one column per element)** creates one column per element in the vector values. The vectors in the column should only contain numerical values and all be of the same length, otherwise the handling will fail.




## Missing values

There are a few choices for handling missing values in vector features.

  * **Impute…** replaces missing values with the specified value. This should be used for **randomly missing** data that are missing due to random noise.

  * **Drop rows** discards rows with missing values from the model building. _Avoid discarding rows, unless missing data is extremely rare_.

  * **Fail if missing values found**

---

## [machine-learning/generalized-linear-models/binary-classification]

# Binary Classification

When the user selects binary classification, the Generalized Linear Model is also added. It contains the same parametrization as the regression. The only choice for GLM Binary Classification Distribution is the Binomial distribution. When combined with the logit function, it is called logistic regression.

  * Elastic Net Penalty: constant that multiplies the elastic net penalty terms. For unregularized fitting, set the value to 0.

  * L1 ratio: specify what ratio to assign to an L1 vs L2 penalty.

  * Distribution: For binary classification, the only available distribution is Binomial.

  * Link Function: The function linking the linear regression to the response. The available functions depend on the distribution choice. Some of these functions require additional parametrization that will appear on the screen if needed.

  * Mode: The user can either choose not to add offsets or exposures, or to add some. To add exposures columns, the link function must be the log function.

  * Training Dataset: When selecting to add offsets or exposures, the user must input the training dataset, which should be associated with the analysis.

  * Offset Columns: The names of the offset columns. The offset variables are added to the linear regression (which consists of adding variables with fixed coefficients with value 1).

  * Exposure Columns: The names of the exposure columns. The exposure variables are treated exactly like the offset variables but the log function is applied. This is only available when selecting a log function.




Note

By default, categorical variables are Dummy encoded and no Dummy is dropped. To avoid collinearity between variables, the user should select **Drop Dummy > Drop one Dummy**.

By default, standard rescaling is applied to numerical variables. To make sure variables are not modified in the preprocessing, the user should select **Rescaling > No rescaling**. This is particularly important when using variables as offsets or exposures (in the case of exposure, as the log of variable is computed, an error may be raised because of negative values).

---

## [machine-learning/generalized-linear-models/index]

# Generalized Linear Models

---

## [machine-learning/generalized-linear-models/introduction]

# Introduction

Generalized Linear Models (GLMs) are a generalization of Ordinary Linear Regression. GLMs allow:

  * The response variable to be chosen from any exponential distribution (not only Gaussian).

  * The relationship between the linear model and the response variable to be defined by any link function (not only the identity function).




These models provide flexibility in modeling dependencies between regressors and the response variable. GLMs are widely used in the Insurance industry to address specific modeling needs. The GLM implementation uses the glum package. Regression Splines rely on patsy.

## Prerequisites and limitations

The GLM plugin is available through the plugin store and requires Dataiku V14+. When downloading the plugin, you will be prompted to create a code environment using Python 3.10, 3.11, or 3.12.

To use Generalized Linear Model Regression and Classification algorithms in visual ML, a specific code environment must be selected in the runtime environment. An exception is raised if not. This code environment must include the required visual ML packages and the plugin requirements.

Note

If you use the integrated visual GLM interface, you do not need to set up a specific code environment, it will be enforced as the plugin code environment.

### How to set up

  1. Create a Python 3.10, 3.11 or 3.12 code environment in **Administration > Code Envs > New Env**.

  2. Go to **Packages to install**.

  3. Click on **Add set of packages**.

  4. Add the Visual Machine Learning packages.

  5. Add the package glum==3.1.2.

  6. Click on **Save and Update**.

  7. Go back to the **Runtime Environment**.

  8. Select the environment that has been created.




Once set up, the plugin components listed on the plugin page can be used in your Dataiku projects.

---

## [machine-learning/generalized-linear-models/regression-splines]

# Regression Splines

Regression splines is a feature engineering technique that allows for defining the relationship between a feature and the response. The recipe computes the spline basis variables that can then be used as features of the model. Regression splines basis variables can be computed through a recipe or as a Prepare step in a Prepare recipe.

## Custom Recipe

In the Regression Splines custom recipe, you need to specify:

  * The column name on which the splines be computed, it should be a numerical column.

  * The eventual knots of the splines, these are the points at which parts of the splines intersect.

  * The degree of the polynomial that is used to build the spline.

  * The prefix of the new columns that will be created. There will be as many new columns as the sum of number of knots and degrees.




## Prepare Step

In the Regression Splines Prepare step, you need to specify:

  * The column name on which the splines be computed, it should be a numerical column.

  * The degree of the polynomial that is used to build the spline.

  * The minimum and maximum values of the column. You must set the lower and upper bounds of the spline. The processing fails if data points fall under the lower bound or over the upper bound.

  * The eventual knots of the splines, these are the points at which parts of the splines intersect.




The new columns that will be created have the following format: <column_name>_Spline_<i> where <column_name> is the input column name you set and <i> is the index of the spline basis variable.

---

## [machine-learning/generalized-linear-models/regression]

# Regression

In the visual ML, when selecting a Prediction type, Generalized Linear Models become available in algorithms. The user needs to activate the algorithm and then configure it by inputting the parameters:

  * Elastic Net Penalty: constant that multiplies the elastic net penalty terms. For unregularized fitting, set the value to 0.

  * L1 ratio: specify what ratio to assign to an L1 vs L2 penalty.

  * Distribution: The distribution of the response variable, to be chosen from the list of available distributions (Binomial, Gamma, Gaussian, Inverse Gaussian, Poisson, Negative Binomial, Tweedie). Some of these distributions require additional parametrization that will appear on the screen if needed.

  * Link Function: The function linking the linear regression to the response. The available functions depend on the distribution choice. Some of these functions require additional parametrization that will appear on the screen if needed.

  * Mode: The user can either choose not to add offsets or exposures, or to add some. To add exposures columns, the link function must be the log function.

  * Training Dataset: When selecting to add offsets or exposures, the user must input the training dataset, which should be associated with the analysis.

  * Offset Columns: The names of the offset columns. The offset variables are added to the linear regression (which consists of adding variables with fixed coefficients with value 1).

  * Exposure Columns: The names of the exposure columns. The exposure variables are treated exactly like the offset variables but the log function is applied. This is only available when selecting a log function.




Interactions: The user can choose to add interactions between variables. The interaction terms are added to the linear regression. The user can define interactions between two variables. Each variable can be either numerical or categorical. The interaction between two categorical variables is implemented as a one-hot encoding of the cross-product of the two variables. The interaction between a numerical and a categorical variable is implemented as a multiplication of the numerical variable by the one-hot encoding of the categorical variable. The interaction between two numerical variables is implemented as a multiplication of the two variables.

Note

By default, categorical variables are Dummy encoded and no Dummy is dropped. To avoid collinearity between variables, the user should select **Drop Dummy > Drop one Dummy**.

By default, standard rescaling is applied to numerical variables. To make sure variables are not modified in the preprocessing, the user should select **Rescaling > No rescaling**. This is particularly important when using variables as offsets or exposures (in the case of exposure, as the log of variable is computed, an error may be raised because of negative values).

---

## [machine-learning/generalized-linear-models/visual-glm]

# Visual GLM

The Visual GLM (Generalized Linear Model) is an interface that allows users to build and visualize GLM models easily. It provides a user-friendly way to configure analyses, then define model parameters, select variables, visualize the results, and deploy models.

## Visual GLM: Webapp Setup

Once the GLM plugin is installed, a new webapp named **Visual GLM** is available in the list of Visual Webapps. To use it, the user must create a new webapp instance, name it and start it. No additional configuration is needed at this stage.

## Visual GLM: Analysis Setup

**Get started** by following this [tutorial](<https://knowledge.dataiku.com/latest/ml/glm/tutorial-glm.html>).

In the Analysis Setup screen, select an existing analysis or create a new one specifying the needed parameters.

The created analysis can also be found in the list of visual analyses in the project. Only analyses that are Visual GLM compatible are shown in the list.

## Visual GLM: Model Variable Configuration

Once the analysis is selected, navigate to the **Model/Variable Configuration** tab to configure the model parameters and select the variables to include in the model.

In the model configuration screen, you can setup your model and name it for training. The available link functions depend on the selected distribution. Some distributions also require additional parameters that appear directly in the form, such as Theta, Power, or Variance Power.

The model configuration section also allows you to select optional sample weight and offset columns. Exposure columns can also be selected when the link function is Log.

The variable configuration section allows you to select the variables to include in the model, and how to preprocess them.

For categorical variables, you can define categorical groups to merge several modalities together. This is useful when some levels should be modeled jointly, either for business reasons or to reduce fragmentation across sparse categories.

To create categorical groups, open the configuration of a categorical variable and create one or more groups. Then, for each group, select the modalities that should be merged together. A group must contain at least two modalities, and a modality can only belong to one group. Once the groups are defined, the grouped modalities are handled together during training.

For numerical variables, you can define spline features directly in the Visual GLM interface. This allows you to model non-linear effects for a variable without preparing additional spline columns in advance.

To define splines, first select a base level for the variable. Then create one or more spline features. Each spline feature is defined as a sequence of contiguous segments, and each segment has a minimum value, a maximum value, and a polynomial degree. Additional segments can be created by adding knots. Up to three spline features can be defined for a variable, and each spline feature can contain up to five knots.

This configuration is intended for variables where a single linear effect is not flexible enough. The spline features are then used directly in model training.

Invalid configurations are highlighted in the interface and prevent model training until they are fixed.

Interactions can be defined between pairs of variables that are included in the model. Interactions can be between:

  * Two categorical variables. the interaction is implemented as a one-hot encoding of the cross-product of the two variables.

  * A numerical and a categorical variable. the interaction is implemented as a multiplication of the numerical variable by the one-hot encoding of the categorical variable.

  * Two numerical variables. the interaction is implemented as a multiplication of the two variables.




Select interaction pairs through the dropdowns and click on **Add Interaction** to add additional interactions.

Once all the configurations are set, you can train the model by clicking on the **Train Model** button. This will trigger a model training session in the analysis session.

## Visual GLM: Observed vs. Predicted

Trained models can be evaluated in the **Observed vs. Predicted** tab. In this tab, you can analyze for each model and variable how the predicted values compare to the observed values. For variables that are included in the model, you can also check relativities. In addition, a few global fit metrics are provided.

**Get started** by following this [tutorial](<https://knowledge.dataiku.com/latest/ml/glm/tutorial-glm.html>).

### Chart Setup

Aside from selecting the model and the variable, some more options are available to customize the chart:

  * Level order (Natural order, Ascending predicted, Descending predicted, Ascending observed, Descending observed)

  * Chart distribution (Raw data, Binning). Works for both numerical and categorical variables. For numerical variables, the bins are uniformly distributed. For categorical variables, the top categories in terms of exposure are kept and the others are regrouped in an other category.

  * Number of bins (only when binning is selected).

  * Chart rescaling (None, Base Level, Ratio). Base level rescaling means that the values are rescaled so that the base level has value 1. Ratio rescaling means that the predicted values are divided by the observed values.




Then you have the option to display only variables included in the model or also suspect variables. Finally, you select if you want to display the chart for the training set or for the test set.

You also can select a second model to be compared with the first one. This will show the goodness of fit metrics, the predicted and base prediction lines in the chart and the relativities (if included) for both models.

In the top right corner you can press the Deploy button to deploy the main selected model.

### Metrics

The following metrics are provided for each model:

  * AIC: Akaike Information Criterion, a measure of the relative quality of a statistical model for a given set of data.

  * BIC: Bayesian Information Criterion, a criterion for model selection among a finite set of models

  * Deviance: A measure of goodness of fit of a model. It is a generalization of the residual sum of squares in linear regression.




### Observed vs. Predicted chart

The main chart shows the predicted and observed values for each level of the selected variable. If a second model is selected, the predicted values for this model are also shown.

Three colors are used in the chart:

  * Purple: observed values, weighted by exposure.

  * Dark green: predicted values, weighted by exposure.

  * Light green: base prediction values, weighted by exposure. The base prediction is the prediction obtained by setting all other variables to their base level.




When a second model is selected, the predicted and base prediction values for this model are shown in dashed lines. The background grey bars represent the sum of exposure per level.

The left y-axis is used for the predicted and observed values, while the right y-axis is used for the exposure. Lines can be removed from the chart by clicking on the corresponding label in the legend.

### Relativities

A table on the right of the chart shows the relativities for the selected variable, if it is included in the model. The relativities are computed as the ratio between the predicted value for each level and the predicted value for the base level.

When a second model is selected, the relativities for this model are also shown in a second column.

## Visual GLM: Variable Level Statistics

This tab provides detailed statistics for each variable included in the model. First select a model, then for each variable, you can see:

  * The variable: base indicates the intercept. For categorical variables, the variable is repeated for each level.

  * The value: for categorical variables, this is the category level. For numerical variables, the base level is indicated.

  * The relativity: computed as the ratio between the predicted value for each level and the predicted value for the base level.

  * The coefficient: the coefficient of the variable in the linear predictor.

  * The p-value: the p-value associated with the coefficient. It is highlighted in yellow when above 0.05.

  * The standard error: the standard error of the coefficient.

  * The standard error %: the standard error divided by the absolute value of the coefficient, expressed in percentage. It is highlighted in yellow when above 100%.

  * The weight: the sum of exposure or sample weight for each level, depending on the model configuration.

  * The weight %: the weight for each level divided by the total weight, expressed in percentage.




On the top right corner, you can export the table as a CSV file. You can also deploy the model by clicking on the Deploy button.

## Visual GLM: Lift Chart

The lift chart shows the weighted predicted values against the weighted observed values, sorted by predicted values.

In the left side menu, select the model to evaluate, the number of bins to use, and whether to display the chart for the training or test set. Then create the chart using the **Create Chart** button.

In the chart, the purple line represents the observed values and the green line represents the predicted values. The predicted values are always going to be ascending, as the chart is built by sorting the data by predicted values. This chart allows to check if the observed values follow the same trend as the predicted values and if there are ranges of predicted values where the model is not performing well. The background grey bars represent the sum of weight per bin.

On the top right corner, you can export the data as a CSV file. You can also deploy the model by clicking on the Deploy button.

## Visual GLM: Model Management

This tab provides a way to manage the models in the analysis. For each model, you can find:

  * The model name. Which is also a link to the model in the Dataiku Visual Analysis interface.

  * The model id.

  * The creation date.

  * A button to deploy the model in the flow.

  * A button to export the model in a csv format.

  * A button to delete the model from the analysis.

---

## [machine-learning/index]

# Machine learning

For an overview of machine learning with DSS, please see the [machine learning quick start](<https://knowledge.dataiku.com/latest/getting-started/tasks/ml/quick-start-index.html>).

This reference documentation contains additional details on the algorithms and methods used by DSS.

---

## [machine-learning/labeling]

# Labeling

The idea of labeling is for one or more humans to specify the ground truth associated with a given entry such as an image, a text or a row from a dataset.   
The annotated dataset is then typically used to train a supervised machine learning model, but labeling can also be used for humans reviews in other situations, e.g. of a model’s predictions.

## Use cases

Dataiku DSS supports several collaborative labeling use cases:

### Record labeling

Also known as tabular data labeling, the input is a dataset with arbitrary columns. Record labeling supports 2 modes:

>   * Free-text (one free-form text per row, the annotator can write anything)
> 
>   * Text classification (one class per row, the annotator must choose among a given set of classes)
> 
> 


### Image labeling

The expected input is a dataset with a column of image paths, i.e. for each row, this column contains the path to an image file in the associated managed folder.

Image labeling supports two modes:

>   * Image classification (one class per image)
> 
>   * Object detection (multiple bounding boxes per image, each with a class)
> 
> 


Image labeling can be used to then [train a supervised computer vision model](<computer-vision/index.html>).

### Text labeling

The expected input is a dataset with a text column. Text labeling supports two modes:

>   * Text classification (one class per text)
> 
>   * Text annotations (multiple selections per text, each with a class)
> 
> 


## Usage

To label your data you need to create a Labeling Visual Recipe.   
From the Flow, select the dataset to annotate then pick Labeling in the right-side panel’s “Other recipes” section, and choose the type of labeling task.

### Setting up a Labeling Task

The first thing to do is for the labeling project manager to: * specify the input data to be labeled, * define the classes/characteristics to be identified, * add general instructions to help annotators, * and manage profiles & permissions.

All of this is done in the Settings tab.

### Annotating images/records/text

The interface varies depending on the labeling type, but it always features: * the item (image/text/record) currently being labeled * the classes to choose from * the actual annotations * the comment area (if enabled)

### Reviewing annotations

Multiple users (Annotators) can work on the same Labeling task and annotate data. To limit errors in annotations, you can ask for a minimum number of annotators to label the same image. During the review process, a Reviewer can validate that the annotations are correct and arbitrate on conflicting annotations.

Conflicts happen when several Annotators label the same record differently. For instance:

  * in a classification task, two Annotators selected different classes for the same record

  * in object detection, two bounding boxes from two Annotators don’t overlap enough, or don’t have the same class

  * in text annotation, annotators did not assign the same class to a span of text

  * in text annotation, the spans of text annotated with a given label are not the same length




To solve a conflict, the reviewer can pick one correct annotation (discarding the others), or discard all and provide an authoritative annotation directly (which is then considered as already validated).

To speed up the review process, a Reviewer can “Auto Validate” all the records with enough annotations and that don’t have any conflict.

### Status & Performance overview

For all labeling types, the Overview tab allows you to follow the progress with simple indicators

### Output: Labels Dataset

The Labels Dataset is the output of a Labeling Task. You can choose between two modes:

  * only validated annotations (default): the dataset only shows the annotations that have been verified by a reviewer

  * all annotations: the dataset shows all annotations




This Dataset is a view of the annotations, it does not need to be (re)built.

## Advanced

### Permissions

There are different access levels on a Labeling Task:

  * View: a user or group can access the basic information in the labeling task

  * Annotate: View + can annotate data

  * Review: Annotate + can review annotations

  * Read configuration: View + read all the information in the labeling task

  * Manage: Read + Review + can edit the settings of the labeling task




Users and groups with `Write project content` access to a Project are implicitly granted Manage access on all labeling tasks in that project. Likewise, users and groups with `Read project content` access to a project are implicitly granted Read configuration access on all labeling tasks in that project. Ownership of the task confers Manage access.

Additional Annotate or Review permissions can be granted on each specific task (in its Settings > Permissions tab). Note that users will need to be granted at least `Read dashboards` permission on the parent Project to be able to access the Labeling task (e.g. as Annotator or Reviewer).

### Contextual columns

In the labeling task’s Settings, select columns from the input to be used as contextual information to help annotate & review documents. These columns then appear in a foldable section at the top of the Annotate & Review screens.

### Import existing labels

If you already have pre-existing labels, e.g. from a previous labeling effort or a model, in your input data, specify in the settings the column (of the input dataset) with those labels. They will directly appear in the Annotate view, and annotators can manipulate them like any other annotations.

### Comments

Because a label or annotations may not be enough, enable comments in the settings to allow annotators to also leave comments on each annotated record. Example uses include leaving a message for reviewers, raising a suggestion, writing an alternative label, explaining an annotation, adding useful information for downstream tasks…   
In the Review tab, all comments for the same item are concatenated by default (and shown in the output dataset), but reviewers can keep only one or overwrite with their own.

---

## [machine-learning/model-document-generator]

# Model Document Generator

You can use the Model Document Generator to create documentation associated with any trained model. It will generate a Microsoft Word™ .docx file that provide information regarding:

  * What the model does

  * How the model was built (algorithms, features, processing, …)

  * How the model was tuned

  * What are the model’s performances




It allows you to prove that you followed industry best practices to build your model.

## Generate a model document

Note

To use this feature, the [graphical export library](<https://doc.dataiku.com/dss/latest/installation/custom/graphics-export.html>) must be activated on your DSS instance. Please check with your administrator.

Once a model has been trained, you can generate a document from it with the following steps:

  * Go to the trained model you wish to document (either a model trained in a Visual Analysis of the Lab or a version of a saved model deployed in the Flow)

  * Click the `Actions` button on the top-right corner

  * Select `Export model documentation`

  * On the modal dialog, select the default template or upload your own template, and click `Export` to generate the document

  * After the document is generated, you will be able to download your generated model document using the `Download` link




Warning

Any placeholders starting with the keyword `design` will be linked to the current status of your visual analysis. If you change parameters in your model, DSS will consider that placeholder values are outdated and will replace these placeholders with blanks in the generated documentation. If you delete your visual analysis and then generate a document from a saved model, any placeholders starting with the keyword `design` will not provide any result.

## Custom templates

If you want the document generator to use your own template, you need to use Microsoft Word™ to create a `.docx` file.

You can create your base document as you would create a normal Word document, and add placeholders when you want to retrieve information from your model.

### Sample templates

Instead of starting from scratch, you can modify the default templates:

  * [`Download the default template for regression here`](<../_downloads/dc276a55f4d3cd452b8bda2c16bfbee4/regression.docx>)

  * [`Download the default template for binary classification here`](<../_downloads/ec38abb3522e8fb47d89a3eace78aaa5/binary_classification.docx>)

  * [`Download the default template for multiclass classification here`](<../_downloads/2308772bf6b66b5236a1e87411de529e/multiclass_classification.docx>)

  * [`Download the default template for clustering here`](<../_downloads/3e3f8417f7420176a9b86757290878e9/clustering.docx>)

  * [`Download the default template for time series forecasting here`](<../_downloads/5d82c2d109c1d357425630b0a18a14bc/timeseries_forecast.docx>)




### Placeholders

A placeholder is defined by a placeholder name inside two brackets, like `{{design.prediction_type.name}}`. The generator will read the placeholder and replace it with the value retrieved from the model.

There are multiples types of placeholders, which can produce text, an image, or a table.

You can format the style of a table placeholder by using a block placeholder and placing an empty table inside it.

### Conditional placeholders

If you want to build a single template able to handle several kinds of models, you may need to display information only when they are relevant. For example, you may want to describe what is a binary classification, but this description should only appear on your binary classification models. This can be achieved with a conditional placeholder.

A conditional placeholder contains three elements, each of them needs to be on a separate line:

  * a condition

  * a text to display if the condition is valid

  * a closing element




Example:
    
    
    {{if design.prediction_type.name == Binary classification}}
    
    The model {{design.prediction_type.name}} is a binary classification.
    
    {{endif design.prediction_type.name}}
    
    
    
    {{if design.prediction_type.name != Binary classification}}
    
    The model {{design.prediction_type.name}} is a not binary classification.
    
    {{endif design.prediction_type.name}}
    

The condition itself is composed of three parts:

  * a text placeholder

  * an operator (`==` or `!=`)

  * a reference value




Example:
    
    
    {{if my.placeholder == myReferenceValue }}
    

During document generation, the placeholder is replaced by its value and compared to the reference value. If the condition is correct, the text is displayed, otherwise nothing will appear on the final document.

### Parametrized result placeholders

In some advanced situations, you might want to include only certain parts of a component visible in the trained model report. To do so, you can use the format `{{result.your_component.plot/your_variable}}` to select part of a component based on a specific dropdown. Make sure that `your_variable` is spelled correctly and matches an item from the dropdown.

For example, to export the feature dependence chart for a chosen feature, you can provide the placeholder `{{result.feature_dependence.plot/Embarked}}`, which will export the chart for the feature “Embarked”.

If a placeholder expects a parameter, it is specified in the “Description” column in the tables below.

Warning

Special characters (e.g. * # $ / “) are accepted in the parameter name. However, **curly brackets** may interfere with the closing placeholder markers `}}` if it:

  * contains two or more consecutive closing brackets, like `your}}variable`

  * contains two or more consecutive opening brackets, like `{{your_variable`

  * contains one or more trailing closing brackets, like `your_variable}`




Therefore, please rename your columns in these cases.

### List of placeholders

Placeholders related to the dataset:

Name | Compatibility | Description  
---|---|---  
dataset.prepare_steps.table | All | Preparation steps used on the dataset  
dataset.prepare_steps.status | All | Tell if preparation steps are used on the dataset  
  
Placeholders related to the design phase of a model:

Name | Compatibility | Description  
---|---|---  
design.mltask.name | All | Name of the modeling task  
design.visual_analysis.name | All | Name of the visual analysis  
design.algorithm.name | All | Name of the algorithm used to compute the model  
design.target.name | Prediction | Name of the target variable  
design.features_count.value | All | Number of columns in the train set  
design.model_type.name | All | Type of model (Prediction or Clustering)  
design.prediction_type.name | Prediction | Type of prediction (Regression, Binary classification or Multi-class classification)  
design.target_proportion.plot | Classification | Proportions of classes in the guess sample  
design.training_and_testing_strategy.table | Prediction | Strategy used to train and test the model  
design.training_and_testing_strategy.policy.value | Prediction | Name of the policy used to train and test the model  
design.sampling_method.value | Prediction | Sampling method named used to train and test the model  
design.k_fold_cross_testing.value | Prediction | Tell if the K-fold strategy was used to train and test the model  
design.sampling_and_splitting.image | Prediction | Sampling and splitting strategy used to train and test the model  
design.sampling.image | Time series forecasting | Sampling strategy used to train and test the model  
design.splitting.image | Time series forecasting | Splitting strategy used to train and test the model  
design.train_set.image | Prediction | Explicit train set strategy  
design.test_set.image | Prediction | Explicit test set strategy  
design.test_metrics.name | Prediction | Metric used to optimize model hyperparameters  
design.input_feature.table | All | Summary of input features  
design.feature_generation_pairwise_linear.value | Prediction | Display if pairwise linear combinations are used in the feature generation  
design.feature_generation_pairwise_polynomial.value | Prediction | Display if pairwise polynomial combinations are used in the feature generation  
design.feature_generation_explicit_pairwise.status | Prediction | Display if the model contains explicit pairwise interactions used in the feature generation  
design.feature_generation_explicit_pairwise.table | Prediction | Display explicit pairwise interactions used in the feature generation  
design.feature_reduction.image | Prediction | Reduction method applied to the model  
design.feature_reduction.name | Prediction | Name of the feature reduction applied to the model  
design.chosen_algorithm_search_strategy.table | All | List the parameters used to configure the chosen algorithm  
design.chosen_algorithm_search_strategy.text | All | Description of the chosen algorithm  
design.other_algorithms_search_strategy.table | All | Parameters and description of the other computed algorithms  
design.hyperparameter_search_strategy.image | Prediction | Hyperparameter search strategy used to compute the model  
design.hyperparameter_search_strategy.table | Prediction | Summary of the hyperparameter search strategy  
design.cross_validation_strategy.value | Prediction | Name of cross-validation strategy used on hyperparameters  
design.dimensionality_reduction.table | Clustering | Dimensionality reduction used to compute the model  
design.dimensionality_reduction.status | Clustering | Tell if a dimensionality reduction was used to compute the model  
design.outliers_detection.table | Clustering | Outliers detection strategy used to compute the model  
design.outliers_detection.status | Clustering | Tell if an outliers detection strategy was used to compute the model  
design.weighting_strategy.method.name | Prediction | Name of the weighting strategy  
design.weighting_strategy.variable.name | Prediction | Name of the weighting strategy associated variable  
design.weighting_strategy.text | Prediction | Description of a weighting strategy  
design.calibration_strategy.name | Classification | Name of the probability calibration method  
design.calibration_strategy.text | Classification | Description of a probability calibration strategy  
design.backend.name | All | Name of the backend engine  
design.partitioned_model.status | All | Tell if the current model is a partitioned model  
design.time_variable.name | Time series forecasting | Name of the time variable  
design.num_timeseries.value | Time series forecasting | Number of time series to forecast  
design.timeseries_identifiers.value | Time series forecasting | List of columns containing time series identifier values  
design.has_multiple_timeseries.value | Time series forecasting | Whether the model has multiple time series  
design.time_step.value | Time series forecasting | Time step including its unit  
design.forecast_horizon.in_units.value | Time series forecasting | Forecast horizon including its unit  
design.forecast_horizon.time_steps.value | Time series forecasting | Number of time steps in one forecast horizon  
design.timeseries_num_external_features.value | Time series forecasting | Number of external features provided to the model  
design.timeseries_external_features.value | Time series forecasting | List of external features columns  
design.timeseries_scoring_data_length.value | Time series forecasting | How much past data must be provided for scoring  
design.timeseries_algorithm_can_score_new_series.value | Time series forecasting | Whether the current model can score time series unseen during training  
design.timeseries_general_settings.table | Time series forecasting | List the general time series specific settings used to configure the model  
design.timeseries_forecasting.table | Time series forecasting | List the settings used to configure the forecast horizon  
design.forecasting_parameters.image | Time series forecasting | Forecasting parameters shown visually in a diagram  
  
Placeholders related to the result of a model computation:

Name | Compatibility | Description  
---|---|---  
result.chosen_algorithm.name | All | Name of the algorithm selected for the mode used in the current document generation  
result.train_set.sample_rows_count.value | All | Number of rows in the train set  
result.test_metrics.value | Prediction | Value of the test metrics  
result.target_value.positive_class.value | Binary classification | Name of the target value representing the positive class  
result.target_value.negative_class.value | Binary classification | Name of the target value representing the negative class  
result.threshold_metric.name | Binary classification | Name of the threshold (cut off) metric  
result.classification_threshold.current.value | Binary classification | Current value of the threshold metric  
result.classification_threshold.optimal.value | Binary classification | Optimal value of the threshold metric  
result.chosen_algorithm_details.image | All but partitioned models | Summary of the prediction computation  
result.chosen_algorithm_details.table | All but partitioned models | Summary of the current model selected hyperparameters  
result.cluster_summary.image | Clustering | Summary of the clustering computation  
result.cluster_description.image | Clustering | Description of each category of the clustering  
result.partitioned.summary.image | Prediction | Summary of the partitioned model execution  
result.decision_trees.image | Prediction | Random forest decision tree visualisation  
result.decision_trees.status | All | Tell if the model is compatible with a decision tree visualisation  
result.regression_coefficients.image | Regression and binary classification | Regression coefficient chart  
result.regression_coefficients.status | All | Tell if the model has a regression coefficient chart  
result.feature_importance.plot | Prediction | Feature importance chart  
result.feature_importance.status | All | Does the model have feature importance charts  
result.absolute_importance.plot | Prediction | Absolute importance chart  
result.absolute_importance.status | All | Does the model have an absolute importance chart  
result.feature_effects.plot | Prediction | Feature effects chart  
result.feature_dependence.plot/your_feature | Prediction | Parametrized placeholder. Feature dependence chart for your selected feature.  
result.individual_explanations.image | Prediction | Individual explanation chart  
result.individual_explanations.text | Prediction | Description of the individual explanation chart  
result.individual_explanations.status | All | Tell if the model contains an individual explanation chart  
result.hyperparameter_search.plot | Prediction | Hyperparameter search results as a chart  
result.hyperparameter_search.table | Prediction | Displays data associated to the hyperparameter search as an table  
result.hyperparameter_search.status | All | Tell if the model had a hyperparameter search results chart  
result.confusion_matrix.image | Classification | Confusion matrix results as a table  
result.confusion_matrix_table.text | Binary classification | Description of the confusion matrix  
result.confusion_matrix_metrics.plot | Classification | Metrics associated to the confusion matrix  
result.confusion_matrix_metrics.text | Classification | Description of the different metrics  
result.cost_matrix.image | Binary classification | Cost matrix as a table  
result.cost_matrix.image | Binary classification | Cost matrix as a table  
result.cost_matrix.text | Binary classification | Description of the cost matrix  
result.decision_chart.plot | Binary classification | Decision chart  
result.decision_chart.text | Binary classification | Description of the decision chart  
result.lift_curve.plot | Binary classification | Lift curve charts  
result.lift_curve.text | Binary classification | Description of the lift curve charts  
result.calibration.plot | Classification | Calibration curve chart  
result.calibration.text | Classification | Description of the calibration curve chart  
result.roc_curve.plot | Classification | ROC curve chart  
result.roc_curve.text | Classification | Description of the ROC curve chart  
result.pr_curve.plot | Classification | PR curve chart  
result.pr_curve.text | Classification | Description of the PR curve chart  
result.density_chart.plot | Classification | Density chart  
result.density_chart.text | Classification | Description of the density chart  
result.hierarchy.plot | Clustering | Hierarchy of the interactive clustering model  
result.anomalies.plot | Clustering | Anomalies detected displayed as a heatmap  
result.cluster_heat_map.plot | Clustering | Features heatmap  
result.scatter.plot | Regression and clustering | Scatter plot chart  
result.error_distribution.table | Regression | Error distribution as a table  
result.error_distribution.plot | Regression | Error distribution as a chart  
result.error_distribution.text | Regression | Description of the error distribution  
result.detailed_metrics.table | All | Detailed summary of the model computation  
result.ml_assertions.table | Prediction | Assertions definitions and metrics  
result.ml_overrides.definition.table | Prediction | Model overrides definitions  
result.ml_overrides.metrics.table | Prediction | Model overrides metrics  
result.timings.table | All | Time of the different execution steps  
result.diagnostics.table | All | All Diagnostics for the current model  
result.diagnostics.table.dataset_sanity_checks | All | Diagnostics of type dataset sanity checks for the current model  
result.diagnostics.table.modeling_parameters | All | Diagnostics of type modeling parameters for the current model  
result.diagnostics.table.runtime | All | Diagnostics of type runtime that check the model training speed  
result.diagnostics.table.training_overfit | All | Diagnostics of type training overfit for the current model  
result.diagnostics.table.leakage_detection | All | Diagnostics of type leakage detection for the current model  
result.diagnostics.table.model_check | All | Diagnostics of type model check for the current model  
result.diagnostics.table.reproduciblity | All | Diagnostics of type training reproducibility for the current model  
result.diagnostics.table.ml_assertions | All | Diagnostics of type ML assertions for the current model  
result.diagnostics.table.abnormal_predictions_detection | All | Diagnostics of type abnormal predictions detection for the current model  
result.diagnostics.table.timeseries_resampling_checks | Time series forecasting | Diagnostics of type resampling checks for the current model  
result.full_log.link | All | URL to download the model’s logs  
result.training_date.name | All | Date of the training  
result.leaderboard.image | All | Image of the default leaderboard of the computed models  
result.leaderboard.accuracy.image | Classification | Image of the leaderboard of the computed models for the metric accuracy  
result.leaderboard.precision.image | Classification | Image of the leaderboard of the computed models for the metric precision  
result.leaderboard.recall.image | Classification | Image of the leaderboard of the computed models for the metric recall  
result.leaderboard.f1.image | Classification | Image of the leaderboard of the computed models for the metric F1 score  
result.leaderboard.cost_matrix.image | Classification | Image of the leaderboard of the computed models for the metric cost matrix gain  
result.leaderboard.log_loss.image | Classification | Image of the leaderboard of the computed models for the metric log loss  
result.leaderboard.roc_auc.image | Classification | Image of the leaderboard of the computed models for the metric ROC AUC  
result.leaderboard.average_precision.image | Classification | Image of the leaderboard of the computed models for the metric Average Precision score  
result.leaderboard.calibration_loss.image | Binary classification | Image of the leaderboard of the computed models for the metric calibration loss  
result.leaderboard.lift.image | Binary classification | Image of the leaderboard of the computed models for the metric lift  
result.leaderboard.evs.image | Regression | Image of the leaderboard of the computed models for the metric EVS  
result.leaderboard.mape.image | Regression and time series forecasting | Image of the leaderboard of the computed models for the metric MAPE  
result.leaderboard.mae.image | Regression and time series forecasting | Image of the leaderboard of the computed models for the metric MAE  
result.leaderboard.mse.image | Regression and time series forecasting | Image of the leaderboard of the computed models for the metric MSE  
result.leaderboard.rmse.image | Regression and time series forecasting | Image of the leaderboard of the computed models for the metric RMSE  
result.leaderboard.rmsle.image | Regression | Image of the leaderboard of the computed models for the metric RMSLE  
result.leaderboard.r2.image | Regression | Image of the leaderboard of the computed models for the metric R2 score  
result.leaderboard.correlation.image | Regression | Image of the leaderboard of the computed models for the metric correlation  
result.leaderboard.mase.image | Time series forecasting | Image of the leaderboard of the computed models for the metric MASE  
result.leaderboard.smape.image | Time series forecasting | Image of the leaderboard of the computed models for the metric SMAPE  
result.leaderboard.mean_absolute_quantile_loss.image | Time series forecasting | Image of the leaderboard of the computed models for the metric Mean absolute quantile loss  
result.leaderboard.mean_weighted_quantile_loss.image | Time series forecasting | Image of the leaderboard of the computed models for the metric Mean weighted quantile loss  
result.leaderboard.msis.image | Time series forecasting | Image of the leaderboard of the computed models for the metric MSIS  
result.leaderboard.nd.image | Time series forecasting | Image of the leaderboard of the computed models for the metric ND  
result.leaderboard.silhouette.image | Clustering | Image of the leaderboard of the computed models for the metric silhouette  
result.leaderboard.inertia.image | Clustering | Image of the leaderboard of the computed models for the metric inertia  
result.leaderboard.clusters.image | Clustering | Image of the leaderboard of the computed models for the metric clusters number  
result.has_multiple_timeseries.value | Time series forecasting | Whether the model has multiple time series  
result.has_information_criteria.value | Time series forecasting | Whether the model exposes information criteria values (e.g AIC)  
result.has_model_coefficients.value | Time series forecasting | Whether the model exposes model coefficients (e.g regression coefficients)  
result.is_statistical_timeseries_model.value | Time series forecasting | Whether the model uses a statistical algorithm (e.g. AutoARIMA)  
result.timeseries_resampling.table | Time series forecasting | Parameters defining how the time series is resampled  
result.per_timeseries_metrics.table | Time series forecasting | For a multi time series model, the metrics for each time series  
result.autoarima_orders_single.table | Time series forecasting | For a single time series model trained with the AutoARIMA algorithm, the ARIMA orders  
result.autoarima_orders_multi.table | Time series forecasting | For a multi time series model trained with the AutoARIMA algorithm, the ARIMA orders for each time series  
result.timeseries_coefficients_single.table | Time series forecasting | For a single time series statistical model, the values of model coefficients  
result.timeseries_coefficients_multi.table | Time series forecasting | For a multi time series statistical model, the values of model coefficients for each time series  
result.information_criteria_single.table | Time series forecasting | For a single time series AutoARIMA or STL model, the values of information criteria  
result.information_criteria_multi.table | Time series forecasting | For a multi time series AutoARIMA or STL model, the values of information criteria for each time series  
result.timeseries_single_forecast.plot | Time series forecasting | For a single time series model, the forecast chart  
result.timeseries_multi_forecast.plot | Time series forecasting | For a multi time series model, the first five forecast charts  
  
Placeholders related to the DSS configuration:

Name | Compatibility | Description  
---|---|---  
config.author.name | All | Name of the user that launched the generation  
config.author.email | All | E-mail of the user that launched the generation  
config.environment.name | All | Name of the DSS environment  
config.dss.version | All | Current version of DSS  
config.is_saved_model.value | All | Yes when documenting a model exported into the Flow, No otherwise  
config.generation_date.name | All | Generation date of the output document  
config.project.link | All | URL to access the project  
config.output_file.name | All | Name of the generated file  
  
### List of conditional placeholders

Placeholders that can be used as conditional placeholders:

  * dataset.prepare_steps.status

  * design.mltask.name

  * design.visual_analysis.name

  * design.algorithm.name

  * design.target.name

  * design.features_count.value

  * design.model_type.name

  * design.prediction_type.name

  * design.training_and_validation_strategy.policy.value

  * design.sampling_method.value

  * design.k_fold_cross_testing.value

  * design.feature_generation_pairwise_linear.value

  * design.feature_generation_pairwise_polynomial.value

  * design.feature_generation_explicit_pairwise.status

  * design.feature_reduction.name

  * design.chosen_algorithm_search_strategy.text

  * design.cross_validation_strategy.value

  * design.dimensionality_reduction.status

  * design.outliers_detection.status

  * design.weighting_strategy.method.name

  * design.weighting_strategy.variable.name

  * design.calibration_strategy.name

  * design.backend.name

  * design.partitioned_model.status

  * design.has_multiple_timeseries.value

  * design.timeseries_algorithm_can_score_new_series.value

  * result.chosen_algorithm.name

  * result.train_set.sample_rows_count.value

  * result.target_value.positive_class.value

  * result.target_value.negative_class.value

  * result.threshold_metric.name

  * result.classification_threshold.current.value

  * result.classification_threshold.optimal.value

  * result.decision_trees.status

  * result.regression_coefficients.status

  * result.feature_importance.status

  * result.individual_explanations.status

  * result.hyperparameter_search.status

  * result.training_date.name

  * config.author.name

  * config.author.email

  * config.environment.name

  * config.dss.version

  * config.is_saved_model.value

  * config.generation_date.name

  * config.output_file.name




### Deprecated placeholders

Name | Compatibility | Description | Replaced by  
---|---|---|---  
result.detailed_metrics.image | All | Detailed summary of the model computation | result.detailed_metrics.table  
design.other_algorithms_search_strategy.image | All | Image of the parameters and description of the other computed algorithms | design.other_algorithms_search_strategy.table  
design.chosen_algorithm_search_strategy.image | All | Image of the parameters used to configure the chosen algorithm | design.chosen_algorithm_search_strategy.table  
  
## Limitations

  * You need to upgrade the table of contents manually after a document generation

  * The Model Document Generator is currently not compatible with ensemble models

  * The Model Document Generator is currently not compatible with Keras nor computer vision models

  * The Model Document Generator is currently not compatible with models imported from MLflow

  * The Model Document Generator is not compatible with plugin algorithms

  * When generating a document from a visual analysis, the model document generator will not display outdated design information. To fix this issue, you can either run a new analysis or revert the design to match the analysis

  * When generating a document from a saved model version, some information may be extracted from the original Visual Analysis Design settings. As a result, any placeholders starting with `design` will be empty when the Visual Analysis was modified or erased

  * Each part of a conditional placeholder must necessarily be in a new line

  * Table and conditional placeholders are not supported on headers and footers

---

## [machine-learning/models-export]

# Exporting models

DSS provides multiple capabilities for exporting models.

## Deploy the model on Dataiku API nodes for real-time scoring

See [API Node & API Deployer: Real-time APIs](<../apinode/index.html>), and its subsections [Exposing a Visual Model](<../apinode/endpoint-std.html>) and [Exposing a MLflow model](<../apinode/endpoint-mlflow.html>).

## Export to Python

For use cases where the API node may not be feasible (such as edge deployment, or very-low-latency deployment), it is possible to export the model to a zip file that can then be used to score the model in any Python code, fully outside of DSS.

This scoring uses the dataiku-scoring open source Python package.

Note that this feature is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager.

  * Go to the trained model you wish to export (either a model trained in the Lab or a version of a saved model deployed in the Flow)

  * Click the Actions button on the top-right corner and select Export model as …

  * Select Python to download the export file




### Requirements

The model needs to be compatible with either [Local (Optimized) scoring](<scoring-engines.html>) or be an [MLflow imported model](<../mlops/mlflow-models/importing.html>) to be compatible with Python export.

The dataiku-scoring package is available on Pypi. It is compatible with Python 3.6 and above, and depends on NumPy.

To ensure to install the correct version, you can unzip the exported model file and run:
    
    
    pip install -r requirements.txt
    

You can optionally use Pandas for easier interaction with the model. All Pandas versions above 0.23 are supported.

### Usage

The package exposes the `load_model` function, which allows you to load the model’s zip file as a python object. The loaded model will have a `predict` method and a `predict_proba` method for classification problems. Here are the signatures of these methods:
    
    
    predict(
      data: [pandas.DataFrame, numpy.ndarray, List[Dict | List]]
    ) -> numpy.array
    
    # Only exists for classification problems
    predict_proba(
      data: [pandas.DataFrame, numpy.ndarray, List[Dict | List]]
    ) -> numpy.darray
    

### Example

We train a model in DSS on the [iris dataset](<https://scikit-learn.org/stable/auto_examples/datasets/plot_iris_dataset.html>) and download it using Python export. The iris dataset is a multiclass classification problem where the output classes are “Setosa,” “Virginica,” and “Versicolor.” Here is an example of using the downloaded zip file together with dataiku-scoring to score the first two rows of the iris dataset.
    
    
    import dataikuscoring
    
    model = dataikuscoring.load_model("path/to/model.zip")
    
    data = [
        {'sepal.length': 5.1, 'sepal.width': 3.5, 'petal.length': 1.4, 'petal.width': 0.2},
        {'sepal.length': 4.9, 'sepal.width': 3.0, 'petal.length': 1.4, 'petal.width': 0.2}
    ]
    
    model.predict(data)  # returns array(['Setosa', 'Setosa'], dtype=object)
    

Provided you have pandas in your environment, you can also directly use a pandas.DataFrame:
    
    
    import pandas as pd
    
    df = pd.DataFrame(data)
    model.predict(df)
    

Or a List of List / NumPy array:
    
    
    data = [[5.1, 3.5, 1.4, 0.2], [4.9, 3.0, 1.4, 0.2]]
    model.predict(data)
    
    import numpy as np
    model.predict(np.array(data))
    

Note

A warning is displayed when you use a List of List or a NumPy array as input to the `model.predict` method. In these cases, the column names are not provided, so features are implicitly assumed to be in the same order as in the training dataset in DSS.

Since the iris dataset is a classification problem, we can also output probabilities:
    
    
    model.predict_proba(data)
    

will output:
    
    
    {'Virginica' : array([0.15511770783800324, 0.1360890057639774], dtype=object),
     'Versicolor': array([0.06850569755129679, 0.13872351067755467], dtype=object),
     'Setosa' : array([0.7763765946107, 0.725187483558468]}, dtype=object)}
    

### Limitations

The Python export feature does not support preparation scripts. In your Lab analysis where you trained your model, if the Script tab has steps, those steps are not included in the exported model. If your model has a preparation script, you must prepare the data yourself before scoring with the loaded python model. The expected input of the model is the output of your preparation script.

## Export as a MLflow model

MLflow is an open-source platform to manage machine learning models lifecycle. If your machine learning deployment pipelines already uses MLflow, you may want to use the MLflow export to benefit of DSS Visual ML tool.

You can export a zip file containing a MLflow model representing the trained in the DSS Visual ML tool. This can be used in any MLflow-compatible scoring system that supports the “python_function” flavor of MLflow

Note that this feature is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager.

Warning

You will need to install the dataiku-scoring python package (see Requirements) in any python environment where you want to load and use the MLflow export of your model.

Note

The dataiku-scoring package defines a specific dss flavor for MLflow that enables using a model designed and exported with DSS with MLflow. You can find the documentation [here](<https://www.mlflow.org/docs/2.17.2/models.html#storage-format>) if you are unfamiliar with MLflow flavors.

Warning

**Tier 2 support** : MLflow export is covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

  * Go to the model you wish to export (either a model trained in the Lab or a version of a saved model deployed in the Flow)

  * Click the Actions button on the top-right corner and select Export model as …

  * Select MLFlow to download the zip file

  * Unzip the zip file to use it with MLflow




Alternatively, you can export using the [API](<https://developer.dataiku.com/latest/api-reference/python/ml.html> "\(in Developer Guide\)") with the following method [`dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_scoring_mlflow()`](<https://developer.dataiku.com/latest/api-reference/python/ml.html#dataikuapi.dss.ml.DSSTrainedPredictionModelDetails.get_scoring_mlflow> "\(in Developer Guide\)").

### Requirements

The model needs to be compatible with either [Local (Optimized) scoring](<scoring-engines.html>) or be an [MLflow imported model](<../mlops/mlflow-models/importing.html>) to be compatible with Python export.

Like all MLflow models, the Dataiku-exported MLflow model contains its requirements.

You will need MLflow in version 2.17.2 at least.

### Usage

To load and use your model you can use the generic MLflow python_function flavor following:
    
    
    import mlflow
    
    model = mlflow.pyfunc.load_model("path/to/model_unzipped")
    
    model.predict(input_data)
    

The model accepts the same input data as the one described in the Python export in Usage.

For a more extensive description on how to use an MLflow model you can refer to the official MLflow [documentation](<https://www.mlflow.org/docs/2.17.2/models.html#how-to-load-and-score-python-function-models>).

If your model is a classification model, you can access the probabilities using `model._model_impl.dss_model.predict_proba`

### “dss” MLflow flavor

[MLflow flavors](<https://www.mlflow.org/docs/2.17.2/models.html#built-in-model-flavors>) are adapters designed for using various machine learning frameworks with a unified API.

In addition to the python_function flavor, MLflow models exported from Dataiku contain a dss flavor which is a simple wrapper on top of the dataiku-scoring package described in Export to Python, which allows you to use the dataiku-scoring API more directly.

The following describes the DSS flavor in the same way as other flavors in the official MLflow documentation.

The `dataikuscoring.mlflow` module defines the DSS flavor for MLflow. The dss model flavor enables logging DSS models in MLflow format via the `dataikuscoring.mlflow.save_model()` and `dataikuscoring.mlflow.log_model()` methods. These methods also add the standard MLflow python_function flavor to the MLflow Models that they produce, allowing the models to be interpreted as generic Python function for inference via `mlflow.pyfunc.load_model()`. This loaded PyFunc model can only score DataFrame input. You can also use the `dataikuscoring.mlflow.load_model()` method to load MLflow Models with the DSS Default format. You obtain a model similar to what is described in Export to Python.

Note

When exporting a Model using the MLflow format in DSS, the resulting zip file contains a zipped version of the output of the `dataikuscoring.mlflow.save_model()` method.

You can load your model using the dss flavor by doing `model = dataikuscoring.mlflow.load_model("path/to/model_unzipped")`. The loaded model is equivalent to the one loaded with the default Python export format and described in Usage.

### Logging the model to an MLflow backend

The model exported in MLflow format can later be imported into an [MLflow Model registry backend](<https://www.mlflow.org/docs/2.17.2/model-registry.html>) or an [MLflow Tracking backend](<https://www.mlflow.org/docs/2.17.2/tracking.html>).

The following example demonstrates how to import a model in a local MLflow backend using a local SQLite database and a DSS model exported in MLflow format:
    
    
    import dataikuscoring.mlflow
    import mlflow
    
    model = mlflow.pyfunc.load_model("path/to/model_unzipped")
    # alternatively:
    # model = dataikuscoring.mlflow.load_model("path/to/model_unzipped")
    
    mlflow.set_tracking_uri("sqlite:///mlflow.db")
    mlflow.set_registry_uri("sqlite:///mlflow.db")
    with mlflow.start_run() as run:
        dataikuscoring.mlflow.log_model(model, artifact_path)
    

You can then run `mlflow ui --port 5001 --backend-store-uri sqlite:///mlflow.db` in a shell to access the run and the model it contains, and deploy it to the model registry.

The model was loaded using MLflow, but its original flavor is the dss flavor. Therefore, we need to use the original dss flavor when logging the model to the backend.

### Limitations

The MLflow export feature does not support preparation scripts. In your Lab analysis, where you trained your model, if the Script tab has steps, those steps are not included in the exported model. If your model has a preparation script, you must prepare the data yourself before scoring with the loaded python model. The expected input of the model is the output of your preparation script.

## Export to a Databricks Registry

This export feature takes the MLflow export a step further, by pushing the model to a Databricks Registry. Both the legacy Workspace Model Registry and the Unity Catalog are supported.

It requires a valid connection to your Databricks workspace. This is done by an administrator in the Administration > Connections, by creating a connection of type “Databricks Model Depl.”.

Note that this feature is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager.

Warning

**Tier 2 support** : Export to a Databricks Registry is covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

  * Go to the model you wish to export (either a model trained in the Lab or a version of a saved model deployed in the Flow)

  * Click the Actions button on the top-right corner and select Export model as …

  * Select Databricks

  * Select a _Databricks Model Deployment Infrastructure_ connection

  * Check Use Unity Catalog to export to this registry. Else, the model will be pushed to the Workspace Model Registry.

  * Enter an Experiment Name or click on Get Experiments and pick an existing one.

  * Enter the name of the Registered Model to which a the exported model will be added as a version, on click on Get Models and pick an existing one.




Note

Like all MLflow models, the Dataiku-exported MLflow model contains its requirements.

  * In the case of a model **trained in Dataiku** , those requirements will most noticeably include the dataiku-scoring library.

  * In the case of a model **imported from an MLflow model** , the original model will be exported. **The requirements from the imported model will be used** , not the requirements of the code env




### Requirements

The model needs to be compatible with either [Local (Optimized) scoring](<scoring-engines.html>) or be an [MLflow imported model](<../mlops/mlflow-models/importing.html>).

### Limitations

The MLflow export feature does not support preparation scripts. In your Lab analysis, where you trained your model, if the Script tab has steps, those steps are not included in the exported model. If your model has a preparation script, you must prepare the data yourself before scoring with the loaded python model. The expected input of the model is the output of your preparation script.

## Export a Java class/JAR for a model

Note

Starting with DSS 13, JAR export requires Java 11 or newer.

For use cases where the API node may not be feasible (such as edge deployment, or very-low-latency deployment), it is possible to export the model to a JAR file that can then be used to score the model in any Java code, fully outside of DSS.

Note that this feature is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager.

The model needs to be compatible with [Local (Optimized) scoring](<scoring-engines.html>) to be compatible with Java export.

  * Go to the trained model you wish to export (either a model trained in the Lab or a version of a saved model deployed in the Flow)

  * Click the Actions button on the top-right corner and select Export model as …

  * Select Java, indicate the full-qualified class name you want for your model




Add that JAR to the classpath of your Java application.

If you have several models you wish to use on the same JVM, you can export the “thin” JAR for each model, which only contains the class and resources for the model, and not the scoring libraries. In that case, you also need to download the scoring libraries (from the same dropdown menu) and add both JARs to the classpath.

### Usage

If you specified the name `com.mycompany.myproject.MyModel` at export time, you can use it like this once you’ve added the JAR to the classpath:
    
    
    import com.mycompany.myproject.MyModel;
    import com.dataiku.scoring.*;
    
    // ...
    MyModel model = new MyModel();
    Observation.Builder obsBuilder = model.observationBuilder();
    Observation obs = obsBuilder
        .with("myCategoricalFeature", "Some string value")
        .with("myNumericFeature", 42.0d)
        // other .with("featureName", <string or double value>)
        .build();
    if (obs.hasError()) {
        System.err.println("Can't build observation: " + obs.getErrorMessage());
        // maybe throw here
    }
    
    // For a classification model
    Try<ClassificationResult> prediction = model.predict(obs);
    if (prediction.isError()) {
        System.err.println("Can't make a prediction: " + prediction.getMessage());
        // maybe throw here
    } else {
        ClassificationResult result = prediction.get();
        // predictedClass is one of model.getClassLabels()
        String predictedClass = result.getPrediction();
         // probabilities has the same indices as model.getClassLabels()
         // i.e. 0 to (model.getNumClasses() - 1)
        double[] probabilities = result.getProbabilities();
        // Use result here
    }
    
    // For a regression model
    Try<RegressionResult> prediction = model.predict(obs);
    if (prediction.isError()) {
        System.err.println("Can't make a prediction: " + prediction.getMessage());
        // maybe throw here
    } else {
        RegressionResult result = prediction.get();
        double predictedValue = result.getPrediction();
        // Use result here
    }
    

You can find the javadoc for the `com.dataiku.scoring` package here: <https://doc.dataiku.com/dss/api/14/scoring>.

If you want to debug your model, you can run the “fat” jar version with `-jar`:
    
    
    java -jar /path/to/dataiku-model-my-model-assembly.jar
    

… or the “thin” jar version, specifying you model class as the Main class to run:
    
    
    java -cp /path/to/dataiku-model-my-model.jar:/path/to/dataiku-scoring-libs_DSS_VERSION.jar \
        com.mycompany.myproject.MyModel
    

This command will take JSON objects with feature values on standard input (one per line), and return predictions as JSON objects on standard output (one per line as well). For instance with a classification model trained on the classical Titanic dataset:
    
    
    $ echo '{"Sex": "male", "Pclass": 3}' >titanic.txt
    $ echo '{"Sex": "female", "Pclass": 1}' >>titanic.txt
    $ java -jar dataiku-model-survived-on-titanic-assembly.jar <titanic.txt >out.txt
    Nov 26, 2018 3:03:39 PM com.dataiku.scoring.pipelines.Normalization <init>
    INFO: Normalize columns
    Nov 26, 2018 3:03:39 PM com.dataiku.scoring.builders.Build binaryProbabilisticPipeline
    INFO: Loaded model:
    Nov 26, 2018 3:03:39 PM com.dataiku.scoring.builders.Build binaryProbabilisticPipeline
    INFO: com.dataiku.scoring.models.ForestClassifier@3cd1f1c8
    Nov 26, 2018 3:03:39 PM com.dataiku.scoring.builders.Build preprocessingPipeline
    INFO: Loaded preprocessing pipeline:
    Nov 26, 2018 3:03:39 PM com.dataiku.scoring.builders.Build preprocessingPipeline
    INFO: PreprocessingPipeline(
        ImputeWithValue(Pclass -> 2.3099579242636747 ; Parch -> 0.364656381486676 ; SibSp -> 0.5105189340813464 ; Age -> 29.78608695652174 ; Fare -> 32.91587110799433 ; )
        Dummifier(Sex in [female, male, ] ; Embarked in [Q, S, C, ])
        Rescaler(Fare (shift, inv_scale)=(32.91587110799433, 0.01887857758669009) ; Age (shift, inv_scale)=(29.78608695652174, 0.07038582694206309) ; Parch (shift, inv_scale)=(0.364656381486676, 1.2618109015803536) ; Pclass (shift, inv_scale)=(2.3099579242636747, 1.2048162082648861) ; SibSp (shift, inv_scale)=(0.5105189340813464, 0.9172989588087348))
    )
    
    $cat out.txt
    {"value":{"probabilities":{"died":0.6874695011372898,"survived":0.3125304988627102},"prediction":"died"},"isError":false}
    {"value":{"probabilities":{"died":0.062296226501392105,"survived":0.9377037734986079},"prediction":"survived"},"isError":false}
    

`com.dataiku.scoring` uses `java.util.logging` for logging. If you wish to forward it to log4j or logback, you can use a [SLF4J bridge](<https://www.slf4j.org>).

### Binary classifier threshold

By default, the threshold used is the model’s threshold (as set automatically or manually before the model was exported). However, the threshold can easily be overridden:

  * From Java code:



    
    
    MyModel model = new MyModel(0.42);  // forces threshold to 0.42
    

  * From model JAR command line:



    
    
    java -jar /path/to/dataiku-model-my-model-assembly.jar --threshold 0.42
    

### Limitations

The Java export feature does not support preparation scripts. In your Lab analysis where you trained your model, if the Script tab has steps then those steps are not included in the exported model. If your model has a preparation script, you will need to prepare the data yourself before scoring with the JAR. The expected input of the model (the features you add in an `ObservationBuilder` to build an `Observation`) is the output of your preparation script.

## Export a PMML file for a model

PMML is a XML-based language to define models, and score them using any PMML-compatible scoring system.

You can export a PMML file containing a Dataiku model, which can then be used in any PMML-compatible scoring system.

Note that this feature is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager.

Warning

**Tier 2 support** : PMML export is covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

If your model is compatible with PMML export (see Limitations below):

  * Go to the trained model you wish to export (either a model trained in the Lab or a version of a saved model deployed in the Flow)

  * Click the Actions button on the top-right corner and select Export model as …

  * Select PMML




### Limitations

The following preprocessing options are compatible with PMML export:

  * Numeric features with regular handling

  * Categorical features with impact-coding or Dummy-encoding handling

  * “Impute with” and “Treat as regular” options when handling missing values. (“Drop rows” option is not compatible)

  * No Vector, Image, Binary or Text features

  * No feature generation (numerical derivatives, combination…)

  * No dimensionality reduction




The following algorithms are compatible with PMML export:

  * Logistic Regression

  * Extra trees

  * Linear Regression

  * Decision Tree

  * Random Forest

  * Gradient tree boosting, excluding XGBoost




The PMML export feature does not support preparation scripts. In your Lab analysis where you trained your model, if the Script tab has steps then those steps are not included in the exported model. If your model has a preparation script, you will need to prepare the data yourself before scoring. The expected input of the model is the output of your preparation script.

The PMML export outputs probabilities and will use the optimized threshold for binary classification.

The PMML export feature does not support probability calibration.

Computer vision models are not compatible with PMML export.

## Export to Jupyter notebook

Note

This only applies to models trained using the “In-memory (Python)” engine, both for prediction and clustering. Not all algorithms are supported by this feature.

Once a model has been trained, you can export it as a Jupyter notebook.

DSS will automatically generate a Jupyter (Python) notebook with code to reproduce a model _similar_ to the model that you trained.

To generate a Jupyter notebook:

  * Go to the trained model you wish to export

  * Click the dropdown icon next to the “Deploy” button

  * Select “Export to Jupyter notebook”




Warning

This generated notebook is for educational and explanatory purposes only. In particular, this notebook does not reproduce all preprocessing capabilities of DSS, and is only a best-effort approximation of the model trained in DSS.

To use the exact model trained by DSS, deploy it to the Flow and use the API node, scoring recipes, or any of the export methods described above

## Export as a Snowflake function

Dataiku supports exporting models to Snowflake by leveraging Java User-Defined Functions (Java UDF).

Note that this feature is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager.

The model needs to be compatible with [Local (Optimized) scoring](<scoring-engines.html>) to be compatible with Snowflake export.

  * Go to the saved model version you wish to export (saved model deployed in the Flow)

  * Click the Actions button on the top-right corner and select Export model as …

  * Select Snowflake:

    * Select the Snowflake connection where the function will be created.

    * Indicate the name of the Snowflake function (must be unique within connection’s schema).




### Usage

If you named the function `mymodel_predict` at export time, you can use it like this:

  * By constructing an object containing the features:



    
    
    SELECT MYMODEL_PREDICT( OBJECT_CONSTRUCT('Embarked', 1, 'Pclass', 1, 'Sex', 'female','Age', 32)) as OUTPUT;
    
    
    
    +----------------------------+
    | OUTPUT                     |
    |----------------------------|
    | {                          |
    |   "isError": false,        |
    |   "value": {               |
    |     "prediction": "1",     |
    |     "probabilities": [     |
    |       0.24289949134462374, |
    |       0.7571005086553763   |
    |     ]                      |
    |   }                        |
    | }                          |
    +----------------------------+
    

  * Or by scoring a full table:



    
    
    SELECT
        "PassengerId",
        -- features:
        "Embarked",
        "Pclass",
        "Sex",
        "Age",
        -- output:
        "proba_0",
        "proba_1",
        "prediction"
    FROM (
        SELECT
            *,
            RESULT:value:prediction AS "prediction",
            RESULT:value:probabilities[0] AS "proba_0",
            RESULT:value:probabilities[1] AS "proba_1"
        FROM (
            SELECT
                *,
            MYMODEL_PREDICT( OBJECT_CONSTRUCT('Embarked', "Embarked", 'Pclass', "Pclass", 'Sex', "Sex", 'Age', "Age") ) AS "RESULT"
            FROM "KAGGLE_TITANIC_TEST" "data"
        ) "__object"
    );
    
    
    
    +-------------+----------+--------+--------+------+---------------------+---------------------+------------+
    | PassengerId | Embarked | Pclass | Sex    | Age  | proba_0             | proba_1             | prediction |
    |-------------+----------+--------+--------+------+---------------------+---------------------+------------|
    | 1           | S        | 200    | male   | 22   | 0.6443216459989076  | 0.35567835400109243 | "0"        |
    | 891         | Q        | 3      | male   | 32   | 0.6059553812552487  | 0.39404461874475133 | "0"        |
    | 890         | C        | 1      | male   | 26   | 0.5074257883223362  | 0.4925742116776638  | "1"        |
    | 889         | S        | 3      | female | NULL | 0.40013285410010047 | 0.5998671458998995  | "1"        |
    +-------------+----------+--------+--------+------+---------------------+---------------------+------------+
    

### Limitations

Since the Snowflake export is built upon the Java export feature, Java export limitations also apply to Snowflake exports, see Limitations.

---

## [machine-learning/models-lifecycle]

# Models lifecycle

Using machine learning in DSS is a process in two steps:

  * The models are designed, trained, explored and selected in the **Lab**

  * Once you are satisfied with your model, you **Deploy** it from the lab to the Flow, where it appears as a **Saved model**




A Saved model is deployed together with a **Training recipe** that allows you to retrain the saved models, with the same model settings, but possibly with new training data.

A Saved Model on the Flow can be used:

  * For real-time APIs, using the [API node](<../apinode/index.html>)

  * By a **Scoring recipe** , in order to perform prediction (or clustering) on a non-labelled dataset

---

## [machine-learning/partitioned]

# Partitioned Models

When working with a partitioned dataset (that is, different subgroups of your data which share the same schema), you may be interested in training a specific type of prediction model on each data partition. Doing this creates a partitioned model (or _stratified model_).

Partitioned models can sometimes lead to better predictions when relevant predictors for a target variable are different across subgroups (or partitions) of the dataset. For example, customers in different data subgroups may have different purchasing patterns that contribute to how much they spend.

For more on partitioning datasets, see [Working with partitions](<../partitions/index.html>).

## Usage

### Training

When you create a visual machine learning (prediction) model on a partitioned dataset, you have the option to create partitioned models.

  * Navigate to the **Design** page of the modeling analysis session

  * In the **Target** panel, enable the **Partitioning** option

  * Select which partitions of the dataset to use when training in the Analysis. For example, the following screenshot shows three selected partitions.




  * **Train** the models. The following results show partitioned models:




Note that when you select algorithms to use for training, Dataiku DSS trains a partitioned model for each algorithm. Each partitioned model consists of one sub model (or model partition) per data partition. For example, the previous screenshot shows two partitioned models (**Logistic Regression - Partitioned** and **Decision Tree - Partitioned**). Each of these models has three model partitions, one for each partition that was trained.

#### Parameters and Settings

For all model partitions in a partitioned model, settings such as: algorithms, feature handling, … are the same. However, some parameters have different values. These parameters include:

  * Trained model parameters (for example, the coefficients of a linear regression model)

  * Hyperparameters (for example, the depth or number of trees for a Random Forest model). If grid search is implemented to find hyperparameter values, then each model partition searches for, and selects the best hyperparameter values for its partition.

  * Probability threshold (cut-off) for binary classification models

  * Probability calibration of trained parameters, when applicable




#### Training Summary and Results

Opening a partitioned model displays a **Summary** page where you can compare results for the **Partitions** with the **Overall** results. Some overall details (aggregated or common to all partitions) are also available.

Note

Metrics for the **Overall** model are aggregated. When an exact computation is not possible, then DSS determines the value as a weighted average, where the weights are determined by the size of each partition (using sample weights, if applicable).

Details about the model summary for **All partitions** and the sub models (or model partitions) are visible when you expand the rows. You can further explore model partitions by clicking the name of the partition, or by switching to the **Partitions** tab and selecting the partition of interest.

### Deploying and Redeploying to the Flow

You can **Deploy** a partitioned model to the flow (see [Models lifecycle](<models-lifecycle.html>)), where it appears as a saved model. The icon for a partitioned model is layered (similar to a partitioned dataset), to differentiate it from an unpartitioned model.

From the flow, you can train additional model partitions. You can also re-train an existing partitioned model by specifying which partition(s) to train. This is similar to the process of rebuilding a partitioned dataset.

You can also update a saved partitioned model and training recipe by redeploying the partitioned model to the flow. The updated model version uses only the model partitions that were trained in the modeling analysis.

### Scoring and Evaluating

There are two ways to score a dataset using a partitioned model:

  1. **Partitioned** : This applies if the output of the scoring recipe is a partitioned dataset, and the partition dependency is such that a single model partition can be used to score each output partition. For example, if the input dataset, the output dataset, and the partitioned model for the recipe all share the same partitioning scheme, with the partition dependencies set to “equal”; in this case, the input dataset has no particular constraint (besides the schema expected by the model).

  2. **Partition dispatch** : This applies if the output of the scoring recipe is an unpartitioned dataset, or if the output is a partitioned dataset, but the partition dependency requires the use of multiple model partitions to build a single output partition. _Partition dispatch_ typically applies when scoring an unpartitioned dataset. Here, the input dataset to the scoring recipe must include the partitioning columns in the data, so that the model can select the right model partition to use on each row.




The same guidelines apply for the evaluation recipe.

Warning

The SQL engine does not support the _Partition dispatch_ mode.

### API Node

You can deploy a version of a saved partitioned model to the API node. The process is the same as for any saved model. See [Exposing a Visual Model](<../apinode/endpoint-std.html>) for more information.

When scoring new records, you must pass the partitioning columns as features, so that the model can select the correct model partition to use.

## Limitations

Use of partitioned models has the following limitations:

  * Only Visual Machine Learning with Python backend is supported. Deep Learning and computer vision models are not supported.

  * Only prediction models are supported. Clustering models are not supported.

  * All partitions must have enough data samples to properly train a model. For example, in the case of a multiclass classification problem, all target classes must be represented in each partition.

  * A saved model cannot have a mix of partitioned and unpartitioned versions.

  * The SQL engine does not support the _Partition dispatch_ mode of the scoring recipe.

  * Only top-level (overall model) metrics and checks are available.




The following options are not supported for partitioned models:

  * Custom threshold for binary classification

  * Train/test split policies other than “Split the dataset”

  * The calibration loss metric

  * Models ensembling

  * PMML export




## Advanced

### Partitioned source version

The training recipe of a saved partitioned model has a _Partitioned source version_ setting. Here, you can select the “Version” of the saved model to use for training new partitions and/or re-training existing partitions.

For example, if you have a saved partitioned model that has two existing versions:

  * _Version 1_ : The _Active version_ , consisting of partitions `A` and `B`

  * _Version 2_ : A newer but not active version, and has added partition `C` over _Version 1_.




Say you train partitions `A` and `D` of your dataset to create a new version (_Version 3_) of the partitioned model, the outcome of this version would depend on the “source version” as follows:

Source version | Will train from | _Version 3_ has partitions  
---|---|---  
Active | Version 1 | Re-trained `A`, Re-used `B`, Newly-trained `D`  
Latest | Version 2 | Re-trained `A`, Re-used `B`, Re-used `C`, Newly-trained `D`  
Explicit | Manually specified | Re-trained `A`, Re-used source partition(s), Newly-trained `D`  
None | None | Newly-trained `A`, Newly-trained `D`  
  
Warning

Retraining from a version with different design parameters (algorithm, feature handling,…) is not supported nor recommended, and may lead to unexpected behavior.

---

## [machine-learning/recommendation-system]

# Recommendation systems

You can build a recommendation system using collaborative filtering and machine learning.

Recommendation systems support in Dataiku is composed of:

  * A set of recipes to compute collaborative filtering and generate negative samples:

>     * Auto collaborative filtering: Compute collaborative filtering scores from a dataset of user-item samples
> 
>     * Custom collaborative filtering: Compute affinity scores from a dataset of user-item samples and a dataset of similarity scores (i.e similarity between pairs of users or items)
> 
>     * Sampling: Generate negative samples from user-item implicit feedbacks (that necessary includes only positive samples)

  * A pre-packaged recommendation system workflow in a Dataiku Application, so you can create your first recommendation system in a few clicks.




## Set up

This capability is provided by the “Recommendation systems” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>)

The recommendation system recipes run on SQL databases. Both the input and outputs datasets of the recipes must be in the same SQL connection.

Supported SQL connections: PostgreSQL, Snowflake, Google BigQuery, Microsoft SQL Server, Azure Synapse.

## Recipes

There are 3 recipes that can be used together to build a complete recommendation flow in DSS.

### Auto collaborative filtering

Use this recipe to compute collaborative filtering scores from a dataset of user-item samples. Optionally, you can provide explicit feedbacks (a rating is associated to each interaction between a user and an item) that will be taken into account to compute affinity scores.

In this recipe, some user-item samples are first filtered based on some pre-processing parameters (users or items with not enough interactions and old interactions are filtered).

Then, depending on whether you chose user-based or item-based collaborative filtering, similarity scores between users (or items) are computed.

  * For user-based, the similarity between user 1 and user 2 is based on the number of same items user 1 and user 2 have interacted with

  * For item-based, the similarity between item 1 and item 2 is based of the number of users that interacted both with item 1 and item 2




Finally, using the similarity matrix generated before, we compute the affinity score between a user and an item using the user’s top N most similar users that have interacted with the item.

Note

  * In case of explicit feedbacks (if a rating column is provided): \- The similarity between users is computed using the Pearson correlation. \- The affinity score between a user _u_ and an item _i_ is computed by taking the weighted average of the ratings of the top N users that are most similar to user _u_ who rated item _i_.

  * All of the above is for user-based collaborative filtering, the item-based approach is symmetrical.




#### Settings

It takes as input samples dataset with user-item pairs (one column for the items, another column for the users) and optionally a timestamp column and a numerical explicit feedback column.

It outputs:

  * Scored samples dataset of new user-item pairs (not in the input dataset) with affinity scores.

  * (Optional) Similarity scores dataset of either users or items similarity scores used to compute the affinity scores.




**Input parameters**

  * _Users column:_ Column with users id

  * _Items column:_ Column with items id

  * (_Optional) Ratings column_ : Column with numerical explicit feedbacks (such as ratings)
    
    * If not specified, the recipe will use implicit feedbacks.

    * In explicit feedbacks, the Pearson correlation is used to compute similarity between either users or items.




**Pre-processing parameters**

  * _Minimum visits per user_ : Users that have interacted with less items are removed

  * _Minimum visits per item_ : Items that have interacted with less users are removed

  * _Normalisation method:_ Choose between
    
    * _L1 normalisation_ : To normalise user-item visits using the L1 norm

    * _L2 normalisation_ : To normalise user-item visits using the L2 norm

  * _Use timestamp filtering_ : Whether to filter interactions based on a timestamp column

  * _Timestamp column_ : Column used to order interactions (can be dates or numerical, higher values means more recent)

  * _Nb. of items to keep per user_ : Only the N most recent items seen per user are kept based on the timestamp column




**Collaborative filtering parameters**

  * _Collaborative filtering method:_ Choose between
    
    * _User-based_ : Compute user-based collaborative filtering scores

    * _Item-based_ : Compute item-based collaborative filtering scores

  * _Nb. of most similar users/items_ : Compute user-item affinity scores using the N most similar users (in case of user-based) or items (in case of item-based)




#### Performance notes

During the score computation, the longest task is to compute the similarity matrix between users or user-based (resp. items for item-based).

To do so, it computes a table of size:

> _number of users_ X _average number of visit per user_ X _average number of visit per item_
> 
> (resp. _number of items_ X _average number of visit per user_ X _average number of visit per item_)

Reducing these metrics will decrease the memory usage and running time.

### Custom collaborative filtering

Use this recipe to compute collaborative filtering scores from a dataset of user-item samples and your own similarity scores between users or items.

This recipe uses the same formula as the _Auto collaborative filtering_ recipe except that it doesn’t compute the similarity scores between users (or items). Instead, you provide these similarity scores yourself. You may have obtained them using some content-based approach.

#### Settings

This recipe takes as input:

  * Samples dataset with user-item pairs and optionally a timestamp column and a numerical explicit feedback column.

  * Similarity scores dataset of user-user or item-item similarity scores (two columns for the items/users and one column containing scores).




It outputs:

  * Scored samples dataset of new user-item pairs with collaborative filtering scores.




All parameters are the same as in the Auto collaborative filtering recipe except for the Similarity input section.

**Similarity input**

  * _Similarity scores type_ : Choose between
    
    * _User similarity_ : If the input **Similarity scores dataset** contains users similarity

    * _Item similarity_ : If the input **Similarity scores dataset** contains items similarity

  * _Users/items column 1:_ First column with users/items id

  * _Users/items column 2:_ Second column with users/items id

  * _Similarity column_ : Column with the similarity scores between the users or items




### Sampling

Use this recipe to create positive and negative samples from positive user-item samples and scored user-item samples.

In the case of implicit feedbacks, you only have positive samples (positive interactions between users and items).

In order to build a model that uses the affinity scores (computed using the previous recipes) as features and predicts if a user is likely to interact with an item or not, you need negative samples (user-item pairs that didn’t interact).

This recipe generates negative samples that have affinity scores but are not positive samples.

#### Settings

This recipe takes as input:

  * Scored samples dataset of user-item samples with one or more affinity scores.

  * Training samples dataset of user-item positive samples.

  * (Optional) Historical samples dataset of historical user-item samples used to compute the affinity scores.




It outputs:

  * Positive and negative scored samples dataset of user-item positive and negative samples with affinity scores.




**Scored samples input**

  * _Users column:_ Column with users id

  * _Items column:_ Column with items id

  * _Columns with affinity scores_ : Columns with scores obtained from the collaborative filtering recipes




**Training samples input**

  * _Users column:_ Column with users id

  * _Items column:_ Column with items id




**Historical samples input**

  * _Use historical samples_ : Whether to use the historical samples to remove them from the negative samples

  * _Users column:_ Column with users id

  * _Items column:_ Column with items id




**Parameters**

  * _Sampling method:_ Choose between
    
    * _No sampling_ : Generate all possible negative samples (all user-item pairs not in the training samples dataset)

    * _Negative samples percentage_ : Generate negative samples to obtain a fixed ratio of positive/negative samples per users

  * _Negative samples percentage_ : Percentage of negative samples per users to generate




## Pre-packaged Recommendation System workflow

### Summary

Alongside the recipes, a Dataiku application is provided. This application can be used to create a first basic recommendation workflow in SQL using the recipes. Once the flow is instantiated through the application, it becomes easier to customize it by adding more features, algorithms and affinity scores.

The complete flow can be integrated into a production project that evaluates the recommendations.

It accepts as input a dataset of dated interactions between users and items (with users, items and timestamp columns).

The system will base its recommendations on implicit feedbacks (no ratings are used).

Once the recommendation model is trained, an additional dataset of users (with a users column) can be provided and a dataset of the top items to recommend to each user will be built.

The input datasets must be stored in a PostgreSQL or Snowflake connection and all computation will be done in the selected connection.

To get a better understanding of the workflow generated by the Dataiku Application, you can look at the project wiki.

### Settings

**Input table**

  * Connection settings: Select settings of the SQL connection to be used in the flow
    
    * _Connection name:_ Name of the SQL connection to use (SQL connections must be set by an admin user of DSS)

    * _Connection type:_ Type of the SQL connection (the application supports PostgreSQL and Snowflake)

    * _(Optional) Connection schema_ : Schema of the selected SQL database to use (can be left empty)

  * _Apply connection settings_ : Run this scenario to change all datasets connection in the flow to the selected connection

  * _Fetch input samples table_ : This links redirects to the settings of the input dataset of the flow (see next image). There you can fetch your input table by first clicking on the _Get tables list_ button. Once the SQL table is selected, you can test it (with the _Test table_ button) and save it (the blue _Save_ button) before going back to the application parameters page.




**Recommendation parameters**

  * _Columns_ : Select required columns from the fetched input table
    
    * _Users column:_ Column with users id

    * _Items column:_ Column with items id

    * _Timestamp column:_ Column with timestamps (or dates)

  * _Build complete flow_ : Run this scenario to build all datasets of the complete recommendation flow




**Recommend to new users**

  * _Fetch users list table_ : Like for the input samples tables, use this links to fetch a SQL table containing a column of users id to make recommendations

  * _Users columns_ :
    
    * _Users column:_ Column with users id

    * _Nb. items to recommend per user_ : How many items to recommend to each of the input users. Some users may not have any items recommendations.

  * _Recommend to users_ : Run this scenario to compute a new dataset containing the selected users top recommendations

  * _Users with top recommendation_ : This links redirects to a dashboard showing the dataset containing the top items recommendation per user




## Example of a recommendation flow

In this section, we explain how the 3 recipes can be used to build a complete recommendation flow. The same flow is used in the Dataiku application.

### Intro

Before going into details, let’s first take an overview of what a recommendation system could look like in DSS. The goal of the workflow is to predict whether a user is likely to interact with an item, based on a set of historical interactions. The predictions can be computed using the Dataiku Machine Learning capabilities, but you’ll still need to build predictive features. For that we will use the collaborative filtering recipe to compute a set of affinity scores. These different affinity scores will be joined in a single dataset and serve as the input features of the machine learning model.

### Time-based split

First we split the _all_samples_ dataset of user-item interactions based on the timestamp to get 2 datasets of old and recent interactions:

  * _samples_for_cf_scores_ : old interactions used to compute scores between users and items

  * _samples_to_train_ml_ : recent interactions used to get positive samples to train a ML model on the affinity scores




_It’s important to train the ML model with more recent interactions than the ones used to compute the affinity scores to prevent data leakage. In production, all interactions are used to compute affinity scores and new samples are scored by the model._

### Collaborative filtering scores

Then we compute multiple affinity scores using the _samples_for_cf_scores_ dataset of interactions and the collaborative filtering recipes.

We can also provide our own users (or items) similarity datasets as input of the Custom collaborative filtering recipe (here the _custom_users_similarity_ dataset).

The multiple scores are joined together into the _all_scores_samples_ dataset (first a _stack_ recipe with distinct rows to retrieve all user-items pairs then a _full join recipe_ to get the multiple scores).

### Sampling

We have computed affinity scores for user-item pairs. Some of these pairs are interactions present in the _samples_to_train_ml_ , they are positive samples, others did not interact together and are negative samples (not present in the _samples_to_train_ml_ or _samples_for_cf_scores_ datasets).

The Sampling recipe takes as inputs the _samples_for_cf_scores_ , _samples_to_train_ml_ and _all_scores_samples_ datasets and outputs the scored pairs with a _target_ column indicating whether they are positive or negative samples (the ratio of positive and negative samples per users can be fixed with a recipe parameter).

The _samples_with_target_ output dataset can finally be used to train a Machine Learning model to predict the _target_ column using the score columns as features.

### Duplicated flow for scoring

Once the ML model is trained, it can be used in production to predict samples with affinity scores obtained from all past interactions (before the time-based split used to train the model).

To compute the affinity scores used to train a model, only a subset of the interactions was used. Some interactions were left aside to have positive samples in the training.

In production, all past interactions are used to compute the samples affinity scores. The trained model then predicts these scored samples and the predictions are used to make recommendations.

To compute affinity scores using all past interactions, we need to duplicate the collaborative filtering recipes (with the same parameters), make them use the _all_samples_ dataset as input and again join all the computed scores to get the _all_scores_samples_duplicate_ dataset.

Finally, we can predict all samples that have affinity scores by scoring the _all_scores_samples_duplicate_ dataset with the trained model.

### Dataiku application

To help users build a recommendation system faster, the complete flow explained above is packaged into a Dataiku application.

---

## [machine-learning/reinforcement-learning]

# Reinforcement Learning

This capability provides recipes to train and evaluate reinforcement learning (RL) agents. It is provided by the **Reinforcement Learning** plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

## Overview

Reinforcement learning is a good fit when a problem involves sequential decisions, delayed rewards, and an objective focused on long-term outcomes.

The plugin supports two agent families:

  * **Q-learning** for smaller, fully discrete state/action spaces.

  * **Deep Q-learning (DQN)** for richer observations where tabular policies are not practical.




## Training recipe

Use the **Train** recipe to learn a policy by repeatedly interacting with an environment.

### Outputs

  * A managed folder containing model artifacts and training metadata.




### Parameters

  * Agent: Q-Learning or Deep Q-learning (DQN).

  * Environment source: built-in environment list or custom environment ID.

  * Environment kwargs (JSON object, optional): runtime parameters passed to the environment.

  * Q-learning settings: Discount factor, Learning rate, exploration (Epsilon, Decay rate), and episode/step limits.

  * DQN settings: Policy, Total training timesteps, Buffer size, Batch size, exploration settings, and target network update frequency.

  * Training profiles mode (DQN): optionally train multiple profiles from a JSON array.




## Testing recipe

Use the **Test** recipe to evaluate a trained model without additional learning.

### Inputs

  * A managed folder containing trained model artifacts.




### Outputs

  * A managed folder with testing JSON files (scores, metadata, and replay information).




### Parameters

  * What to test: manual model selection or manifest-based batch testing.

  * Agent: the agent family to evaluate.

  * Environment fields (Environment source, Environment or Custom Environment ID, Module to import, optional Environment kwargs).




## Using custom environments

For most business use cases, you will define a custom Gym/Gymnasium environment.

  1. Add your environment Python module to the Dataiku project library.

  2. Ensure importing the module registers an environment ID.

  3. In Train/Test recipes, set:

     * Environment source = Custom environment ID

     * Custom Environment ID = <registered_id>

     * Module to import = <module_name>

     * optional Environment kwargs (JSON object)




## Visualizing testing results

To compare evaluation runs, create a visual webapp with the **RL Agent Testing Results** webapp template.

Configure:

  * Replay Folder: output folder from the Test recipe.

  * Training Models Folder (optional): output folder from Train recipe to enable manifest/profile helpers.

---

## [machine-learning/scoring-engines]

# Scoring engines

DSS allows you to select various engines in order to perform scoring of your models. This allows for faster execution in some cases.

Note

Scoring engines are only used to actually predict rows. While they are strongly related to [training engines](<algorithms/index.html>), some models trained with one engine can be scored with another.

## Engines for the scoring recipe

The following scoring engines are available:

  * Local (DSS server only) scoring. This engine has two variants:

    * the **Python** engine provides wider compatibility but lower performance. Allows to compute [Individual prediction explanations](<supervised/explanations.html>).

    * the **Optimized** scorer provides better performance and is automatically used whenever possible.

  * Spark: the scoring is performed in a distributed fashion on a Spark cluster

  * SQL (Regular): the model is converted to a SQL query and executed within a SQL database.

  * SQL (Snowflake with Java UDF): the model uses Snowflake extended push-down. This provides much faster execution within Snowflake, and extended compatibility. Please see [Snowflake](<../connecting/snowflake.html>) for details




The selected engine can be adjusted in the scoring recipe editor. Only engines that are compatible with the selected model and input dataset will be available.

The default settings the following:

  * If the model was trained with Spark MLLib, it will be scored with the Spark engine

  * Else it will be scored with the Local engine. The optimized engine will be used if available.




If you do not wish to score your model with the “optimized” engine for some reason, you may select “Force original backend” in the scoring recipe editor to revert to the original backend.

Choosing SQL (regular) engine (if your scored dataset is stored in an SQL database and your model is compatible) will generate a request to score the dataset. Note that this may create very large requests for complex models.

## Engines for the API node

To score rows using the API node, the “Local” engine is used. This engine has two variants:

  * the **Python** engine provides wider compatibility but lower performance.

  * the **Optimized** scorer provides better performance and is automatically used whenever possible.




The Optimized engine is enabled if you check the “Use Java” option in the endpoint settings.

In other words, only models for which one of “Local (Python)” or “Local (Optimized)” is available can be scored in the API node.

## Compatibility matrix

The compatibility matrix for all DSS models is the following.

Local (Python) and Local (Optimized) engines are available both in scoring recipes and API node. Spark and SQL engines are only available for the scoring recipes.

Note

  * For models trained with Python, the Optimized Local and Spark engines are only available if preprocessing is also compatible.

  * The SQL engine is only available if preprocessing is also compatible.




### Algorithms

Warning

The MLLib support is deprecated and will soon be removed.

Training engine | Algorithm | Local (Optimized) | Local (Python) | Spark | SQL (Snowflake with Java UDF) | SQL (Regular)  
---|---|---|---|---|---|---  
Python in-memory | Random forest | Yes | Yes | Yes | Yes | Yes (except for multiclass)  
MLLib | Random forest | Yes | No | Yes | Yes | Yes (except for multiclass)  
Python in-memory | Gradient Boosting | Yes | Yes | Yes | Yes | Yes (except for multiclass)  
MLLib | Gradient Boosting (no multiclass) | Yes | No | Yes | Yes | Yes (except for multiclass)  
Python in-memory | LightGBM | Yes | Yes | Yes | Yes | Yes (except for multiclass)  
Python in-memory | XGBoost | Yes | Yes | Yes | Yes | Yes (except for multiclass)  
Python in-memory | Extra Trees (Scikit) | Yes | Yes | Yes | Yes | Yes (except for multiclass)  
Python in-memory | Decision Trees | Yes | Yes | Yes | Yes | Yes (no probas for multiclass)  
MLLib | Decision Trees | Yes | No | Yes | Yes | Yes (no probas for multiclass)  
Python in-memory | OLS, Lasso (non LARS), Ridge | Yes | Yes | Yes | Yes | Yes  
Python in-memory | SGD | Yes | Yes | Yes | Yes | Yes  
MLLib | Linear Regression | Yes | No | Yes | Yes | Yes  
Python in-memory | Logistic Regression | Yes | Yes | Yes | Yes | Yes  
MLLib | Logistic Regression | Yes | No | Yes | Yes | Yes  
Python in-memory | Neural Networks | Yes | Yes | Yes | Yes | Yes  
Python in-memory | Deep Neural Network | No | Yes | No | No | No  
Python in-memory | Naive Bayes | No | Yes | No | No | No  
MLLib | Naive Bayes | No | No | Yes | No | No  
Python in-memory | K-nearest-neighbors | No | Yes | No | No | No  
Python in-memory | SVM | No | Yes | No | No | No  
Python in-memory | Custom models | No | Yes | No | No | No  
MLLib | Custom models | No | No | Yes | No | No  
| Ensemble model | No | Yes | No | No | No  
  
### Preprocessing

#### Local (Optimized)

The following preprocessing options are available for Local(Optimized)

  * Numerical

    * No rescaling

    * Rescaling

    * Binning

    * Derivative features

    * Flag presence

    * Imputation

    * Drop row

    * Datetime cyclical encoding

  * Categorical

    * Dummification

    * Target encoding (impact and GLMM)

    * Ordinal

    * Frequency

    * Flag presence

    * Hashing (MLLib only)

    * Impute

    * Drop row

  * Text

    * Count vectorization

    * TF/IDF vectorization

    * Hashing (MLLib)




#### SQL (Snowflake with Java UDF)

The following preprocessing options are available for SQL (Snowflake with Java UDF) scoring :

  * Numerical

    * No rescaling

    * Rescaling

    * Binning

    * Derivative features

    * Flag presence

    * Imputation

    * Drop row

    * Datetime cyclical encoding

  * Categorical

    * Dummification

    * Target encoding (impact and GLMM)

    * Ordinal

    * Frequency

    * Flag presence

    * Hashing (MLLib only)

    * Impute

    * Drop row

  * Text

    * Count vectorization

    * TF/IDF vectorization

    * Hashing (MLLib)




#### SQL (Regular)

The following preprocessing options are available for SQL (regular) scoring :

  * Numerical

    * No rescaling

    * Rescaling

    * Binning

    * Flag presence

    * Imputation

    * Drop row

  * Categorical

    * Dummification

    * Impact coding

    * Ordinal

    * Frequency

    * Flag presence

    * Impute

    * Drop row




Text is not supported

## Limitations

### SQL (regular) engine

The following limitations exist with SQL (regular) scoring:

  * Some algorithms may not generate probabilities with SQL scoring (see table above)

  * Conditional output columns are not generated with SQL scoring

  * Preparation scripts are not compatible with SQL scoring

  * Multiclass logistic regression and neural networks require the SQL dialect to support the GREATEST function.

---

## [machine-learning/supervised/explanations]

# Individual prediction explanations

Dataiku DSS provides the capability to compute individual explanations of predictions for all Visual ML models that are trained using the Python backend (this includes custom models and algorithms from plugins, but not Keras/Tensorflow models).

The explanations are useful for understanding the prediction of an individual row and how certain features impact it. A proportion of the difference between the row’s prediction and the average prediction can be attributed to a given feature, using its explanation value. In other words, you can think of an individual explanation as a set of feature importance values that are specific to a given prediction.

DSS provides two modes for using the individual prediction explanations feature:

>   * In the model results page, to visualize the explanations.
> 
>   * With the scoring recipe, to return the explanation values along with the predictions.
> 
> 


## In the model results

The **Individual explanations** tab in the results page of a model is an interactive interface for providing a better understanding of the model.

As an example, consider the case where the global feature importance values for a black-box model may not be enough to understand its internal workings. In such a situation, you can use this mode to compute the explanations for extreme predictions (i.e. for records that output low and high predictions) and to display the contributions of the most influential features. You can then decide whether these features are useful from a business perspective.

For speed, DSS uses different samples of the dataset to compute explanations, depending on the splitting mechanism that was used during the model design phase.

>   * If the model was built on training data (using a train/test split), DSS computes the explanations on a sample of the test set.
> 
>   * If cross-validation was used during the model design phase, then DSS computes the explanations on a sample of the whole dataset.
> 
> 


You can modify settings for the sample by clicking the gear icon in the top right of the individual explanations page. The interactive interface also allows you to specify values for other parameters, such as:

>   * The number of highly influential features to explain (or desired number of explanations).
> 
>   * The method to use for computing explanations.
> 
>   * An approximate number of records of interest at the low and high ends of the predicted probabilities.
> 
>   * A column to use for identifying the explanations of each record.
> 
> 


The result of the computation is a list of cards, one card per prediction. The cards on the left side of the page are for the records that give low predictions, while those on the right side of the page are for high predictions. Within the cards, bars appear next to the most influential features to reflect the explanation values. Green bars oriented to the right reflect positive impacts on the prediction, while red bars oriented to the left reflect negative impacts.

Note

If the model was trained in a container, then this computation will be implemented in a container. Otherwise, the computation will be implemented on the DSS server. The same is true for other post-training computations like [partial dependence plots](<results.html#prediction-results-pdp-label>) and [subpopulation analysis](<results.html#prediction-results-subpopulation-label>).

## With the scoring recipe

The individual prediction explanations feature is also available within a scoring recipe (after [deploying a model to the flow](<../models-lifecycle.html>)).

If your model is compatible, i.e. a Visual ML model that is trained using the Python backend (this includes custom models and algorithms from plugins, but not Keras/Tensorflow models), then the option for **Output explanations** is available during scoring. Activating this option allows you to specify the number of highly influential features to explain, and to select the computation method. It also forces the scoring to use the original Python backend.

Note

By default, the scoring recipe is performed in memory. However, you can choose to perform the execution in a container.

Running the scoring recipe outputs the predictions and an _explanations_ column. The _explanations_ column contains a JSON object with features as keys and computed influences as values, and can easily be unnested in a subsequent preparation recipe.

## Computation methods

To compute the individual prediction explanations, DSS provides two methods based on:

  * The Shapley values

  * The Individual Conditional Expectation (ICE)




### Method 1: Based on the Shapley values

This method estimates the average impact on the prediction of switching a feature value from the value it takes in a random sample to the value it takes in the sample to be explained, while a random number of feature values have already been switched in the same way.

To understand how the method based on Shapley values works, consider that you have a data sample \\(X\\), and you want to explain the impact of one of its features \\(i\\) on the output prediction \\(y\\). This method implements these main steps:

  1. Create a data sample \\(X^\prime\\) by selecting a random sample from your dataset and switching a random selection of its features (excluding the feature of interest \\(i\\)) to their corresponding values in \\(X\\). Then compute the prediction \\(y^\prime\\) for \\(X^\prime\\).

  2. Switch the value of the feature \\(i\\) in \\(X^\prime\\) to the corresponding value in \\(X\\), to create the modified sample \\(X^{\prime\prime}\\). Then compute its prediction \\(y^{\prime\prime}\\).

  3. Repeat the previous steps multiple times, and average the predictions \\(y^{\prime\prime}\\), to determine an average prediction.

  4. Finally, compute the difference between the average prediction and \\(y^\prime\\) to obtain the impact that feature \\(i\\) has on the prediction of \\(X\\).




The number of random samples used in the implementation depends on the expected precision and the non-linearity of the model. As a guideline, multiplying the number of samples by four improves the precision by a factor of two. Also, a highly non-linear model may require 10 times more samples to achieve the same precision of a linear model. Because of these factors, the required number of random samples may range from 25 to 1000.

Finally, the overall computation time is proportional to the number of highly influential features to be explained and the number of random samples to be scored.

### Method 2: Based on ICE

This method explains the impact of a feature on an output prediction by computing the difference between the prediction and the average of predictions obtained from switching the feature value randomly. This method is a simplification of the Shapley-value-based method.

To understand how the method based on ICE works, consider that you have a data sample \\(X\\), and you want to explain the impact of one of its features \\(i\\) on the output prediction \\(y\\). This method implements these main steps:

  1. Switch the value of the feature \\(i\\) in \\(X\\) to a value chosen randomly. Then compute its prediction \\(y^\prime\\).

  2. Repeat the previous step multiple times, and average the predictions \\(y^\prime\\), to determine an average prediction.

  3. Finally, compute the difference between the average prediction and \\(y\\) to obtain the impact that the feature \\(i\\) has on the prediction of \\(X\\).




For binary classification, DSS computes the explanations on the logit of the probability (not on the probability itself), while for multiclass classification, the explanations are computed for the class with the highest prediction probability.

### More about the computation methods

  1. The ICE-based method is faster to implement than the Shapley-based method. When ICE is used with scoring, the computation time (about 20 to 50 times longer than with simple scoring) is faster than that for the method based on Shapley values.

  2. A major drawback of using the ICE-based method is that the sum of explanations over all the feature values is not equal to the difference between the prediction and the average prediction. This discrepancy can result in a distortion of the explanations for models that are non-linear.

  3. The performance of the ICE-based method is model-dependent. Therefore, when choosing a computation method, consider comparing the explanations from both methods on the test dataset. You can then use the ICE-based method (for speed) if you are satisfied with its approximation.




For more details on the implementation of these methods in DSS, see [`this document`](<../../_downloads/f7b380e6d003253efce5dc2f8e1d25f2/individual-explanations-methods.pdf>).

## Limitations

  * The computation for individual prediction explanations can be time-consuming. For example, to compute explanations for the five most influential features, expect a computation time multiplied by a factor of 10 to 1000, compared to simple scoring. This factor also depends on the characteristics of the features and of the computation method used.

  * For a given prediction, individual explanations approximate the contribution of each feature to the difference between the prediction and the average prediction. When that difference is small, the computation must be done with more random samples, to account for random noise and to return meaningful explanations.

  * When the number of highly influential features to be explained is fewer than the number of features in the dataset, it is possible to miss an important feature’s explanation. This can happen if the feature has a low global feature importance, that is, the feature may be important only for a small fraction of the samples in the dataset.

  * Individual prediction explanations are available only for Visual ML models that are trained using the Python backend (this includes custom models and algorithms from plugins, but not Keras/Tensorflow or computer vision models).

  * Using the Scoring Recipe with individual explanations can be very memory consuming. You can tweak the Scoring Recipe parameters to decrease the memory footprint. However, this will slow down the ​run. In particular:

>     * If you are using “Shapley” method, the “Sub chunk size” and “Number of Monte Carlo steps”. Decreasing “Sub chunk size” should have the biggest impact
> 
>     * In “Advanced” tab, the “Python batch size”

---

## [machine-learning/supervised/index]

# Prediction (Supervised ML)

Prediction (aka supervised machine learning) is used when you have a **target** variable that you want to predict. For instance, you may want to predict the price of apartments in New York City using the size of the apartments, their location and amenities in the building. In this case, the price of the apartments is the **target** , while the size of the apartments, their location and the amenities are the **features** used for prediction.

Note

Our [Machine Learning Basics tutorial](<https://knowledge.dataiku.com/latest/ml/model-design/ml-basics/tutorial-index.html>) provides a step-by-step explanation of how to create your first prediction model and deploy it for scoring of new records.

The rest of this document assumes that you have followed this tutorial.

Use the following steps to quickly start your first prediction model in DSS:

  * Go to the Flow for your project

  * Click on the dataset you want to use

  * Select the _Lab_

  * Select _Quick model_ then _Prediction_

  * Choose your target variable (one of the columns) and _Automated Machine Learning_

  * Choose _Quick Prototypes_ and click _Create_

  * Click _Train_

---

## [machine-learning/supervised/interactive-scoring]

# Interactive scoring

Interactive scoring is a simulator that enables any AI builder or consumer to run “what-if” analyses (i.e., qualitative sensibility analyses) to get a better understanding of what impact changing a given feature value has on the prediction by displaying in real time the resulting prediction and the individual prediction explanations. For instance in a fraud detection use case, this feature would allow you to see how changing the amount of a transaction affects the predicted probability that it is a fraud.

Access the interactive simulator on the **Interactive scoring** tab in the results page of a model. It offers two views:
    

  * **the compute view** allows you to tweak the input features of your model and see in real time its prediction and the associated explanations.

  * **the comparator view** allows you to compare side-by-side several predictions & explanations




## Edit feature values

On the compute view there is a form to edit the feature values.

The default pre-set values are:

  * the **medians** in the train set for **numerical** features

  * the **modes** in the train set for **categorical** features




For each, you can select between several edit modes (known domain or raw) or choose to ignore the feature, in which case it is not fed to the model. Feature settings for a given model are saved in your browser for the next time you come back to this page. If your model has a preparation script, you can choose to define the features as they would be after or before they go through the preparation steps.

From the `…` menu, you can copy/paste feature values from other models. Feature values can also be copied from a dataset’s explore view by right clicking on a row and choosing “Copy as JSON object”.

## Comparator

You can add the current feature values and computed results to the comparator. After adding multiple results, open the comparator view to see the predictions and explanations. The content of the comparator is saved in your browser.

Note that, if you change the explanation parameters, all the comparator items’ explanations will be recomputed with the new parameters.

You can copy the content of the comparator and paste it in another model’s comparator to quickly compare those models’ behaviors for these specific cases.

The comparator’s content can be exported to a Dataset or downloaded as a file.

## Publishing on a dashboard

The interactive scoring interface can be published in a saved model report. In the tile options, the order of the features can be defined under **Advanced options**. Remove some less relevant feature to collapse them at the end under a Details group. Dashboard view will show the features in the specified order.

## Limitations

  * Interactive scoring is available only for Visual ML models that are trained using the Python or Keras backends.

  * Explanations are not supported on Keras or computer vision models.

  * Sorting feature by importance is not available for ensembling models, models with custom pre-processing, nor models trained before DSS 8.

---

## [machine-learning/supervised/ml-assertions]

# ML Assertions

ML assertions provide a way to streamline and accelerate the model evaluation process, by automatically checking that predictions for specified subpopulations meet certain conditions.

With ML assertions, you can programmatically compare the predictions you expect with the model’s output. You define expected predictions on segments of your test data, and DSS will check that the model’s predictions are aligned with your judgment.

By defining assertions, you are checking that the model has picked up the patterns that are most important for your prediction task.

ML assertions checks can be automated by using DSS [checks system](<../../metrics-check-data-quality/checks.html>). This will enable you to be warned if new versions of your model do not behave as expected.

ML assertions are defined in Analysis > Design > Debugging.

ML assertions results are available:

  * in the model page under the Metrics & Assertions tab.

  * in deployed saved models under the Metrics & Status tab as metrics to display.

  * in deployed saved models under the Settings > Status checks tab for defining checks that can be run in scenarios.

  * in the output of an evaluation recipe in the metrics dataset.

  * through the performance metrics API




* * *

## Defining assertions

To define assertions DSS provides a filter-recipe-like interface with multiple _where_ criteria to define the subsample and the condition that should be met by the model’s predictions.

The _where_ criteria will define a filter that DSS applies on the test set to extract the subsample on which assertion should be computed. To define the assertion condition you will need to provide the following inputs:

  * For classification you will be prompted to select one of the target classes and a minimum ratio of rows (Valid ratio) that should be predicted as this class for your assertion to pass.

  * For regression you will be prompted to select a range of predicted values and a minimum ratio of rows (Valid ratio) that should fall within this range for your assertion to pass.




At the end of training, the assertions are tested against the test set. If the **effective** valid ratio is strictly less than the **expected** valid ratio the assertion is considered to fail, and a [diagnostic](<../diagnostics.html>) will be raised.

## Assertion’s result

For each assertion the computation will yield assertion metrics which are composed of:

  * a name: the name of the assertion

  * a result: whether the assertion passed

  * a number of matching rows: number of rows that matched the assertion filter

  * a number of rows dropped: number of rows that matched the assertion filter and were dropped by the model’s preprocessing

  * a valid ratio: percentage of rows that satisfy the assertion condition




At the ml task level a **passing assertions ratio** is also computed. It is the ratio of passing assertions over the total number of assertions which were able to be calculated.

## No matching row

If no row matches the assertion filter (e.g. typo in one of the criteria), or all rows matching the filter are dropped by the model’s preprocessing, part of the assertion result cannot be computed. The valid ratio and assertion result will not be defined. They will show as “-” in the UI and as `null` in the assertions metrics (in the evaluation recipe, metrics & checks…).

If all the assertions of the ML task yield null results, the passing assertions ratio is also undefined (“-” in the UI and `null` in assertions metrics).

When no row matches the filter or all rows are dropped, a specific [diagnostic](<../diagnostics.html>) will be raised.

## Assertions’ metrics & Checks

After deploying a model, in the Metrics & Status tab of the saved model you can add assertion metrics to the table by clicking on the X/Y metrics button and by selecting some of the following metrics:

  * Dropped rows: ANY_AVAILABLE_ASSERTION_NAME

  * Rows matching criteria: ANY_AVAILABLE_ASSERTION_NAME

  * Valid ratio: ANY_AVAILABLE_ASSERTION_NAME

  * Passing assertions ratio




The same metrics are available in the Settings > Status checks tab for defining [checks](<../../metrics-check-data-quality/checks.html>). These checks can be used in scenarios to automate model validation.

## Evaluation recipe

When running an evaluation recipe, DSS provides a checkbox to decide whether you want to compute assertions. If checked you will have two additional columns in the metrics dataset:

  * passingAssertionsRatio is the ratio of assertions that pass

  * assertionsMetrics is a map. Keys are assertion names and values are maps representing an assertion’s result. These maps are composed of one key/value pair per attribute of assertion result. The list of attributes are defined in the assertion’s result section above.




## Limitations

ML assertions are **not** available for:

  * Clustering tasks

  * Backends other than in-memory python backend

  * Ensemble models

---

## [machine-learning/supervised/model-error-analysis]

# Model error analysis

After training a machine learning model, data scientists often investigate the model’s failures to build intuition around which subpopulations the model performed most poorly on. This analysis is essential in the iterative process of model design and feature engineering, and is usually performed manually.

Model error analysis provides the user with automatic tools to help break down the model’s errors into meaningful groups, which are easier to analyze, and highlight the most frequent types of errors, as well as the characteristics correlated with the failures.

## Principle

Model error analysis streamlines the analysis of the samples mostly contributing to the model’s mistakes. We call the model under investigation the primary model.

This approach relies on an Error Tree, a secondary model trained to predict whether the primary model prediction is correct or wrong, i.e. a success or a failure. More precisely, the Error Tree is a binary DecisionTree classifier predicting whether the primary model will yield a Correct Prediction or an Incorrect Prediction.

The Error Tree can be trained on any DSS dataset meant to evaluate the primary model’s performance, i.e. containing ground truth labels. By default, the Error Tree is trained on the primary model’s original test set.

In classification tasks a model failure is an incorrectly predicted class, whereas in the case of regression tasks, a failure is defined as a large deviation of the predicted value from the true one. In the latter case, when the absolute difference between the predicted and the true value is higher than a threshold ε, the model outcome is considered as a Wrong Prediction. The threshold ε is computed as the knee point of the Regression Error Characteristic ([REC](<http://homepages.rpi.edu/~bennek/papers/rec.pdf>)) curve, ensuring the absolute error of primary predictions to be within tolerable limits.

The nodes of the Error Tree decision tree break down the test dataset into smaller segments with similar features and similar model performances. Analyzing the subpopulation in the error nodes, and comparison with the global population, provides insights around critical features correlated with the model failures.

The Model Error Analysis plugin automatically highlights any information relevant to the model’s errors, helping the user to focus on what are the problematic features, and what are the typical values of these features for the mispredicted samples. This information can later be exploited to support the strategy selected by the user :

  * Improve model design: removing a problematic feature, removing samples likely to be mislabeled, ensemble with a model trained on a problematic subpopulation;

  * Enhance data collection: gather more data regarding the most erroneous or under-represented populations;

  * Select critical samples for manual inspection thanks to the Error Tree, and avoid primary predictions on them using [model assertions](<ml-assertions.html>).




## Setup

Model error analysis is provided as a plugin, which you need to install first.

**Tier 2 support** : This capability is covered by [Tier 2 support](<../../troubleshooting/support-tiers.html>)

## Using model error analysis

After training a model, go to the model’s page and click on “Views”, then select the “Model error analysis” view.

### Error Tree

The Error Tree for the analyzed model is shown in the main window. This is a Decision Tree which breaks down all the errors constituting the original model’s mistakes into interpretable subgroups.

The top panel highlights the main metrics:

  * Original model error rate: proportion of samples in the test set the original model predicted incorrectly.

  * Fraction of total error: incorrect predictions present in a selected node over the total number of incorrect predictions in the whole population.

  * Local error: incorrect predictions in a selected node over the number of samples in the node.




The fraction of total error is represented in the width of the tree branches, and draws a path towards the nodes containing the majority of mistakes.

The local error is represented with the level of red in a node, and is the error rate within the node’s subpopulation.

The interesting nodes are the ones containing the majority of errors (thickest branches), and possibly with the highest local error rates (highest red levels, especially higher than the original model error rate).

### Nodes and Charts

When clicking on a node, a panel appears on the left with local information regarding the population in that node. In particular the decision rule section allows the user to know at a glance the segment of data represented by the node, while the univariate histograms show the features most correlated with the errors.

For each feature, we can compare its distribution in the node to its distribution in the whole test set (by enabling ‘in all samples’). Looking at the discrepancy between the two distributions helps you to interrogate which feature values characterize the majority of the model errors.

### Template Notebook

For coders who want to go further in their analysis, a python library is also provided with the plugin. Inside a notebook or a python recipe, users can use Model error analysis to investigate a visual DSS model, as described in the template notebook released with the plugin.

---

## [machine-learning/supervised/model-exploration]

# Model exploration

Model exploration intelligently generates samples in the feature space which yield interesting predictions.

Exploring the model’s decision function may serve different purposes:

  * Having a better grasp of the model’s decision making

  * **Building confidence** in the model’s robustness

  * Finding the inputs necessary to **obtain better outcomes**




From the “What-If?” page (_aka. Interactive scoring_), users can select a reference example and start the exploration by clicking on the blue button in the top right corner.

## Counterfactual explanations (for classifiers)

### Introduction

The starting record / “what-if” values at the start of the exploration, are visualised as the reference example.

Counterfactual explanations are synthetic records **similar to the reference example** , that would result in a **different predicted class**.

These findings can be helpful in explaining what would need to change, for an alternate outcome.

For implementation details, see [`this document`](<../../_downloads/7b037ee3e40cf3f9b10a4a1722c70370/model-exploration-implementation.pdf>).

### What makes good counterfactual explanations?

To evaluate counterfactual explanations, three criteria emerge:

  * **Proximity** : “ _How close are the counterfactual examples to the reference?_ ”

  * **Plausibility** : “ _How_ ordinary _are the counterfactual examples compared to the points of the train set?_ ”

  * **Diversity** : “ _How different are the counterfactual explanations from each other?_ ”




### Setting a target

The “reference” is the point that was selected on the main “What if?” page.

Note

If the model almost always predicts the same class for plausible inputs, searching for counterfactual explanation will usually not yield any result.

#### Binary classification

For binary classifiers, the target is always the opposing class to the one predicted for the reference example.

#### Multiclass classification

For multiclass classifiers, the target can either be:

  * **Any class but reference’s.** In which case, any point is a counterfactual explanation as long as its predicted class is not the reference prediction.

  * **A specific class.** In which case, all the counterfactual explanations returned by the algorithm will be points for which the model predicts the specified class.




Example

On the following screenshot, the “reference prediction” is ‘**robin** ’:

  * The target cannot be set to ‘**robin** ’ because it is the reference prediction already.

  * If the target is set to ‘**dove** ’, the counterfactual explanations will necessarily be points for which the prediction is ‘**dove** ’.

  * If the target is set to “Any class except ‘**robin** ’”, the counterfactual explanations will either predict ‘**partridge** ’ or ‘**dove** ’.




## Outcome optimization (for regression models)

### Introduction

For regression models, the outcome optimization algorithm generates **diverse** synthetic records, striving to match the **training dataset distribution** , that would result in either a **minimal** , **maximal** , or **specific** prediction.

For implementation details, see [`this document`](<../../_downloads/7b037ee3e40cf3f9b10a4a1722c70370/model-exploration-implementation.pdf>).

### Setting a target

When performing outcome optimization, there are three options:

  * **Maximize** : the algorithm will be looking for **plausible** feature values for which the model’s predictions are as **high** as possible.

  * **Minimize** : the algorithm will be looking for **plausible** feature values for which the model’s predictions are as **low** as possible.

  * **Specific value** : the algorithm will be looking for **plausible** feature values for which the model’s predictions are **nearest** to the specified value.




Example

On the following screenshot, we’re trying to find plausible inputs for which the model would predict approximately ‘**162** ’.

## Setting constraints

There are three ways to constrain the exploration:

  * For categorical features, some **categories can be excluded** from the search space.

In which case, the results will not contain any of the excluded categories.

  * For numerical features, a **range can be set** to limit the search space.

In which case, the results will not contain any value outside of the range.

  * Freezing either a numerical or a categorical feature **completely prevents the algorithm from trying different values** for this feature.

In other words, if a given feature is frozen, the corresponding column in the results will be filled with this feature’s reference value. (i.e. the value that was selected on the main “What If?” page)




Example

On the following screenshot:

  * The results should not have `Supplier == Charlie`.

  * The results should not have `Temperature < 8` or `Temperature > 11`.

  * Two features are frozen; All results should have `Volume == 5.1` and `pH == 3.2`.




## Interpreting results

The interesting points found by the algorithm are displayed and can be exported to a dataset.

Example

In this production quality prediction example, we are trying to find the inputs for which the model’s prediction will be maximum.

On the following screenshot:

  * The reference values are:

    * `Temperature == 10.4`

    * `Workers_nb == 3`

    * `Supplier == 'Bob'`

    * `Volume == 5.1`

    * `pH = 3.2`

  * The model’s prediction for the reference point is ‘**144** ’.

  * To maximize the model’s prediction:

    * the ideal number of workers seems to be ‘**5** ’

    * the ideal supplier seems to be ‘**Alice** ’ or ‘**David** ’

    * the ideal temperature seems to be around ‘**9.7** ’

  * Despite leading to slightly inferior predictions, results which have `Supplier == 'Bob'` seem to be very plausible.




### Plausibility

**Plausibility is a measure of how ordinary points are.** It ranges between 0% and 100%.

For a given dataset and a given point in the dataset space:

  * A point with a low plausibility is extraordinary in regards to the distribution of the train set.

  * A point with a high plausibility looks like it could belong in the train set.




_For instance, if the plausibility score of a given point is 30%, it means that 30% of the points of the train set are more likely to be outliers than this point._

For implementation details, see [`this document`](<../../_downloads/7b037ee3e40cf3f9b10a4a1722c70370/model-exploration-implementation.pdf>).

## Limitations

Model exploration is not available:

  * for models trained before DSS 10

  * for Keras or computer vision models

  * for ensemble models

  * for timeseries

  * for partitioned models (although it is available on an individual partition)

  * if “Skip expensive reports” was selected before training the model (_Design > Advanced > Runtime environment > Performance tuning_).

  * if “Apply preparation script” is enabled (_Report > What If?_).

---

## [machine-learning/supervised/model-fairness-report]

# Model fairness report

Evaluating the fairness of machine learning models has been a topic of both academic and business interest in recent years. However, before prescribing any resolution to the problem of model bias, it is crucial to learn more about how biased a model is, by measuring some fairness metrics. Model fairness reports is intended to help you with this measurement task.

Depending on the context and domain, different metrics of fairness can be applied. No model will be perfect toward all the metrics, thus the choice of metric is crucial. The report shows in a most transparent way several metrics and the difference between them, and from there you can choose the one that best evaluates the fairness of the situation at hand.

## Setup

Model fairness report is provided by a plugin, which you need to install. You will then need to build the code-env for the plugin.

For more details, please see [the plugin page](<https://www.dataiku.com/product/plugins/model-fairness-report/>) .

**Tier 2 support** : This capability is covered by [Tier 2 support](<../../troubleshooting/support-tiers.html>)

## Using model fairness report

After training a model, go to the model’s page and click on “Views”, then select the “Model Fairness Report” view.

### Inputs

  * Sensitive column: the column contains sensitive group based on which we want to compute fairness metric.

  * Sensitive group: the reference group from which we will compute the metric discrepancies.

  * Positive outcome: the target value that is advantageous.




### Metrics and Charts

Four different metrics will be computed. Here for illustration purposes we suppose that we are in a loan assessment use case:

  * Demographic Parity: people across groups have the same chance of getting the loan.

  * Equalized Odds:
    
    * Among people who will not default, they have the same chance of getting the loan.

    * Among people who will default, they have the same chance of being rejected.

  * Equality of Opportunity: among all people who will not default, they have the same chance of getting the loan.

  * Predictive Rate Parity: among all people who are given the loan, across groups there is the same portion of people who will not default (equal chance of success given acceptance).

---

## [machine-learning/supervised/prediction-intervals]

# Prediction Intervals

## Introduction

Prediction intervals for regression tasks provide a range within which the actual outcome is expected to fall with a given probability. They add a layer of transparency and confidence to model predictions by indicating the uncertainty associated with these predictions.

Prediction intervals are defined in **Analysis > Basic > Metrics > Uncertainty**.

They can also be used as input for [prediction overrides](<prediction-overrides.html>)

## How does it work

To generate prediction intervals, we employ a helper model alongside the primary predictive model. This helper model is trained to estimate the bounds of the prediction interval, by fitting the residuals (i.e. the differences between observed and predicted values) from the primary model while taking into account the coverage level that you specified.

### Coverage level

The default coverage level is set at 95%, meaning that the prediction intervals generated is estimated to contain the actual outcome 95% of the time, under the model’s assumptions. You can adjust this level based on your requirements for intervals with a higher probability of containing the actual outcome (resulting in wider intervals) or with a lower probability of containing the actual outcome (resulting in narrower intervals).

---

## [machine-learning/supervised/prediction-overrides]

# Prediction Overrides

## Introduction

ML models today can achieve very high levels of performance and reliability but unfortunately this is not the general case, and often, they cannot be fully trusted for critical processes. There are many known reasons for this, including overfitting, incomplete training data, outdated models, differences between testing environment and real world…

Model overrides allow you to add an extra layer of human control over the models’ predictions, to ensure that they:

  * don’t predict outlandish values on critical systems,

  * comply with regulations,

  * enforce ethical boundaries.




By defining Overrides, you ensure that the model behaves in an expected manner under specific conditions.

Overrides are defined in **Analysis > Modeling**.

Overrides impact the predictions of the model. This notably affects:

  * the metrics of the model, computed after taking into account the defined overrides,

  * the predicted data, What-If analysis, individual prediction explanations, etc., and

  * all the data scored using a model with defined overrides, including via:

>     * the [Score](<../scoring-engines.html>) and [Evaluation](<../../mlops/model-evaluations/dss-models.html>) recipes,
> 
>     * the [API node](<../../apinode/index.html>),
> 
>     * an [exported model](<../models-export.html>).




Please note, however, that [Hyperparameter Search](<../advanced-optimization.html>) is performed before the overrides are applied, so it does not take overrides into consideration.

## Defining overrides

You can define multiple overrides on a given model. Each override consists of two parts:

  * a **rule** (_if/when this happens_), and

  * an **outcome** (_then enforce this prediction_).




### The rule

The rule specifies the conditions to match against each row scored by the model. It can be defined by using either:

  * [Rules based filters](<../../other_recipes/sampling.html#rules-based-filters>),

  * or the Dataiku [Formula Language](<../../formula/index.html>).




And the predicate can include both original dataset features and computed features like the prediction itself, the [prediction intervals](<prediction-intervals.html>) for regression models or the prediction uncertainty for classification tasks.

Warning

Overrides that use the Dataiku formula language are not compatible with [Models Export](<../models-export.html>).

### The outcome

The outcome states how the prediction is overridden when the rule matches.

  * For classification tasks, the outcome is the class to predict when the rule matches.

  * For regression tasks, the outcome is a range of boundaries in which to clip the predicted value.




Note

When multiple overrides match a single row, only the **first** matching override applies.

## Override Metrics

Information about overrides are available in the model’s results > **Overrides**.

It shows which rows matched with which override, alongside showing when the predictions were actually changed.

Note

A rule might match a row, but the model’s prediction may already be the same as it would be under the enforced outcome. In this case, the override is said to have _applied_ but not _changed the prediction_.

For probabilistic classification models, note that the reported probabilities do change even when the prediction doesn’t.

## Overrides Extra Info Column

When scoring with overrides, a column is added to the scored dataset with override information that shows the impact (or lack thereof) of overrides on each of the predictions. It is structured like so:
    
    
    "override": {
      "ruleMatched": true|false,        # When false, this is the only field
      "appliedRule": "Override 1"|null, # Name of the override that applied
      "rawResult" : {                   # Original result before the override is applied
        "prediction": "no",             # Original prediction value
        "probabilities": {              # Original probabilities, only for classification models
          "no": 0.95,
          "yes": 0.05
        }
      },
      "predictionChanged": true|false   # True when the new prediction is different from the original
    }
    

This column is added to:

  * the **Predicted data** tab in the model results,

  * the scored dataset, output of the scoring & evaluation recipes, and

  * the prediction response of [Prediction Endpoint](<../../apinode/endpoint-std.html>) on the API node.




## Limitations

Overrides are **not** available for:

  * tasks other than AutoML Prediction tasks (Deep learning, Clustering, Time series forecasting…),

  * backends other than the in-memory python backend (such as MLlib or H2O),

  * ensemble models, or

  * partitioned models.




Other limitations of Overrides:

  * Some [Prediction Results](<results.html>) such as Gini-based feature importance for tree models or regression coefficients, don’t consider overrides. [Shapley feature importance](<results.html#shapley-feature-importance-ref>) and [Individual prediction explanations](<explanations.html>) do consider overrides.

  * Variables are not supported when defining override conditions (both visually or using formulas).

  * When using overrides, models can only be exported as Java, and only if they use visual rules.

  * For binary classification, the prediction cannot be used in the rule (match condition).

  * Python scoring on an API node is not supported when the model is using overrides, see [Scoring engines](<../scoring-engines.html>).

---

## [machine-learning/supervised/results]

# Prediction Results

When a model finishes training, click on the model to see the results.

## Decision tree analysis

For tree-based scikit-learn models, Dataiku can display the decision trees underlying the model. This can be useful to inspect a tree-based model and better understand how its predictions are computed.

For classification trees, the “target classes proportions” describe the raw distribution of classes at each node of the decision tree, whereas the “probability” represents what would be predicted if the node were a leaf. There will be a difference when the “class weights” weighting strategy is chosen (which is the case by default): the classifier will predict the _weighted_ proportion of classes, so “probabilities” with class weights are always based on a balanced reweighting of the data. Whereas “target classes proportions” are simply the raw proportion of classes and will be just as unbalanced as the training data.

For gradient boosted trees, note that the decision trees are inherently hard to interpret, especially for classifications:

  * by construction, each tree is built as to correct the sum of the trees built before, and is thus hard to interpret in isolation

  * classification models are actually composed of _regression trees_ , over the gradient of the loss of a _binary_ classification (even for multiclass where one vs. all strategy is used)

  * for classifications, each tree prediction is homogenous to a log-odds and _not a probability_ and thus can take arbitrary numerical values outside of the (0, 1) range.




All parameters displayed in this screen are computed from the data collected during the training of the decision trees, so they are entirely based on the _train set_.

## Feature importance

### Shapley feature importance

Shapley feature importance is a universal method to compute individual explanations of features for a model. It is based on approximated Shapley values that can be computed on every type of model.

For models trained using the Python backend (e.g. [Visual Machine Learning](<../auto-ml.html>), [MLFlow](<../../mlops/mlflow-models/index.html>) or [custom models](<../custom-models.html>)), Dataiku can compute and display Shapley feature importance. These plots help to explain the impact of features on the predictions of the model.

For most models, they are automatically computed during training. This is sometimes skipped by default and can be manually skipped by checking “Skip expensive reports” before training the model (_Design > Advanced > Runtime environment > Performance tuning_).

The bar chart ranks the features by their absolute importance for model predictions, showing those that overall weigh more heavily or more often in the model’s prediction.

The feature effects chart displays importances computed for individual samples drawn from the test set, showing in more details the distribution of contributions for each feature.

The feature dependence chart drills further into one feature, plotting the impact of its different values on the prediction. It gives a sample-level perspective on Partial dependence

#### Limitations

Important

Shapley values are not supported for [Visual Deep Learning](<../deep-learning/introduction.html>) models using the Tensorflow/Keras backend.

The Shapley feature importance is computed automatically for models where the computation is expected to have reasonable computational cost / speed. This cost is presumed high for example in the following cases:
    

  * one of the input feature uses [text embedding](<../features-handling/text.html#text-embedding>).

  * the model algorithm is kNN or Support Vector Machine (computationally intensive inference)

  * there are over 50 features and DSS is not able to infer the top 20 automatically




In these cases, Shapley feature importance remains available as a post-train computation but may be very slow.

### Gini feature importance

For tree-based scikit-learn, LightGBM and XGBoost models, Gini feature importances are computed as the (normalized) total reduction of the splitting criterion brought by that feature.

Gini feature importance is an intrinsic measure of how much each feature weighs in the trained model and thus is always positive and always sums up to one, regardless of the accuracy of the model. Importance reflects both how often the feature is selected for splitting, and how much the prediction changes when the feature does. Note that such a definition of feature importance tends to _overemphasize numerical features_ with many different values.

## Regression coefficients

For linear models, Dataiku provides the coefficient of each feature.

Note that for numerical features, it is recommended to consider the coefficients of _rescaled variables_ (i.e. preprocessed features with null mean and unit variance) before comparing these coefficients with each other.

All parameters displayed in these screens are computed from the data collected during the training, so they are entirely based on the _train set_.

## Partial dependence

For all models trained in Python (e.g., scikit-learn, keras, custom models), Dataiku can compute and display partial dependence plots. These plots can help you to understand the relationship between a feature and the target.

Partial dependence plots are a post-hoc analysis that can be computed after a model is built. Since they can be expensive to produce when there are many features, you need to explicitly request these plots on the **Partial dependence** page of the output.

Partial dependence is defined as the average predicted value obtained by fixing the considered feature at a given value and maintaining all other features values unchanged in the data, minus the average predicted value. The plot shows the dependence of the target on a single selected feature. The x axis represents the value of the feature, while the y axis displays the partial dependence.

A positive (respectively negative) partial dependence means that forcing the data to take the given value on this feature while leaving all others as is will yield to a predicted value that is above (respectively below) the average prediction. Another way to interpret partial dependence plots for numerical variables is to consider the local monotonicity of the relationship: when the plot is locally increasing (respectively decreasing), the predicted values tend to increase (respectively decrease) on average with the value of the considered feature.

For example, in the figure below, all else held equal, _age_first_order_ under 40 will yield predictions below the average prediction. The relationship appears to be roughly parabolic with a minimum somewhere between ages 25 and 30. After age 40, the relationship is slowly increasing, until a precipitous dropoff in late age.

Note that for classifications, the predictions used to plot partial dependence are not the _predicted probabilities_ of the class, but their _log-odds_ defined as `log(p / (1 - p))`.

The plot also displays the distribution of the feature, so that you can determine whether there is sufficient data to interpret the relationship between the feature and target.

## Subpopulation analysis

For regression and binary classification models trained in Python (e.g., scikit-learn, keras, custom models), Dataiku can compute and display subpopulation analyses. These can help you to assess if your model behaves identically across subpopulations; for example, for a bias or fairness study.

Subpopulation analyses are a post-hoc analysis that can be computed after a model is built. Since they can be expensive to produce when there are many features, you need to explicitly request these plots on the **Subpopulation analysis** page of the output.

The primary analysis is a table of various statistics that you can compare across subpopulations, as defined by the values of the selected column. You need to establish, for your use case, what constitutes “fair”.

For example, the table below shows a subpopulation analysis for the column _gender_. The model-predicted probabilities for male and female are close, but not quite identical. Depending upon the use case, we may decide that this difference is not significant enough to warrant further investigation.

By clicking on a row in the table, we can display more detailed statistics related to the subpopulation represented by that row.

For example, the figure below shows the expanded display for rows whose value of _gender_ is missing. The number of rows that are **Actually True** is lower for this subpopulation than for males or females. By comparing the **% of actual classes** view for this subpopulation versus the overall population, it looks like the model does a significantly better job of predicting actually true rows with missing _gender_ than otherwise.

The density chart suggests this may be because the **class True** density curve for missing _gender_ has a single mode around 0.75 probability. By contrast, the density curve for the overall population has a second mode just below 0.5 probability.

What’s not clear, and would require further investigation, is whether this is a “real” difference, or an artifact of the relatively small subpopulation of missing _gender_.

## Individual explanations of predictions

Please see [Individual prediction explanations](<explanations.html>).

## Metrics and assertions

### Learning Curves

Learning Curves allow you to see how varying the size of the training dataset impacts the train and test performances of your model.

This analysis helps you understand if your model has reached a plateau, requires more data for improved performance, is overfitting or underfitting, and if similar performance can be achieved with less data, potentially leading to gains in training time.

For each metric, Learning Curves show the train and test performance curves for multiple training dataset sizes.

All models are trained using the hyperparameters of the initial model; no hyperparameter search is performed.

Metrics on the curves are computed with overrides and weighted strategies, considering any defined configurations from the initial training.

### Assertions

Please see [ML Assertions](<ml-assertions.html>).