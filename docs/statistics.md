# Dataiku Docs — statistics

## [statistics/assisted-data-exploration]

# Assisted Data Exploration

It can sometimes be difficult to readily spot patterns and relationships in a dataset, especially if there are many columns or if you don’t already have some notion of where to begin your analysis.

Dataiku provides an assistant to ease the exploration of datasets. When creating a new card, you can choose “Automated Selection”, which helps you discover patterns by suggesting analyses on variables of interest.

The tool gathers metrics about the current sample and makes card suggestions based on the selected variables. Suggestions evolve as you select or unselect variables, and cover all the interactive statistics cards currently supported by Dataiku.

Suggestions can be previewed, selected and then added to the current worksheet.

Note

All calculations made by the assistant are performed on a subset of 1000 points randomly drawn from the sample of the worksheet. As a consequence, suggested card thumbnails may not reflect the actual content of the card and are provided as visual indications only. In order to get reliable results, it is advised to preview the card first, as previews are always computed on the whole sample of the worksheet.

---

## [statistics/bivariate]

# Bivariate Analysis

Bivariate analysis is useful for analyzing two variables to determine any existing relationship between them.

The **Bivariate analysis** card allows you to look into the relationship between pairs of variables, where one variable is the response variable and the other is a factor variable. You can select multiple factors, and Dataiku DSS creates a section in the card for each pair (factor and response). Depending on the types of factor and response variables (continuous or categorical), Dataiku DSS populates each section with the appropriate statistical analysis options.

When you create a card, each section has a general menu (⋮), a deletion button (🗑) as well as a configuration menu (✎).

Clicking the general menu (⋮) provides options to:

  * Treat the variable as categorical or continuous — this affects only the current bivariate analysis.

  * Duplicate the section to a new card

  * View the JSON representation of the section

  * Export the section to a dashboard




Clicking the configuration menu (✎) provides options that are specific to the card.

## Card options

Several statistical options are available when generating a bivariate analysis.

### Histogram

The bivariate histogram shows the distribution of a variable in relation to another. By default, DSS automatically chooses a number of bins, configurable by clicking the histogram configuration menu (✎).

### Box Plot

The box plot is a graphical tool that summarizes the distribution of data by showing quartiles. To create the box plot, at least one of the variables must be numerical.

### Mosaic Plot

The mosaic plot is a visual frequency table, where the area of each rectangle is proportional to the frequency of the variable. By default, DSS automatically chooses a number of bins, configurable by clicking the histogram configuration menu (✎).

### Scatter Plot

The scatter plot uses Cartesian coordinates to display the values of two numerical variables in a dataset. By clicking the scatter plot configuration menu (✎), you can configure:

  * the size of the points in the plot

  * the maximum number of points to display




The points to display are randomly drawn from the sample of the worksheet. See [worksheet elements](<interface.html#worksheet-elements>) for more information about sampling.

### Summary Stats

Summary statistics in a bivariate analysis card compute the correlation between a pair of variables using correlation coefficients (Spearman, Pearson, Kendall tau, etc). You can specify which statistics to display by clicking the summary configuration menu (✎).

### Frequency Table

The bivariate frequency table shows the distribution of one variable across the categories of another variable. DSS sorts the values in increasing order of the categories (first by the factor, then by response). You can configure the number of displayed values by clicking the frequency table configuration menu (✎).

---

## [statistics/conjoint-analysis]

# Conjoint Analysis

Conjoint Analysis estimates preference utilities from survey choices and helps quantify trade-offs between attribute levels (for example: price, brand, speed, service). It is provided by the Conjoint Analysis plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

Instead of asking respondents to rate each feature in isolation, conjoint analysis uses realistic alternatives and infers:

  * Part-worth utilities for each attribute level.

  * Relative attribute importance.

  * Expected preference behavior across offer designs.




This is commonly used for:

  * Pricing and willingness-to-pay decisions.

  * Product/package design and feature prioritization.

  * Offer and portfolio optimization.

  * Marketing and sales positioning based on quantified drivers.




## Inputs

  * **Conjoint Choice Dataset** : A long-format dataset with one row per alternative in each answer/task.

    * A task identifier (optional in UI if recoverable from standard column names).

    * An alternative identifier (optional; alternatives can be auto-generated within each task).

    * A target column (binary, rating/grade, or ranking).

    * Conjoint attribute columns (optional in UI; can be inferred).




## Output

  * **Main Conjoint Output** : A dataset combining part-worth utilities and attribute-importance information.

    * `attribute`: Attribute name.

    * `level`: Attribute level.

    * `utility` / `utility_centered`: Estimated utility metrics.

    * `importance_raw` / `importance_pct` / `importance_rank`: Importance indicators.

  * **Debug / Validation Output (optional)** : Diagnostic dataset with model summary, warnings, and chart payloads.

  * **Reports & Visuals Folder (optional)**: Managed folder containing an HTML report with model/mode explanations, legends, and interactive charts.




## Parameters

The recipe behavior can be configured with the following parameters.

### Dataset mapping

  * **Answer ID Column** : Task/answer identifier.

  * **Alternative ID Column** : Alternative identifier within each task.

  * **Conjoint Attribute Columns** : Attribute columns used to estimate utilities. If omitted, attributes are inferred.




### Target mapping

  * **Target Column** : Unified target input for binary, rating/grade, and ranking surveys.

  * **Target Type** :

    * `auto`: Detects target mode from data.

    * `binary`: Expects a chosen flag (0/1).

    * `rating`: Uses highest value as preferred alternative.

    * `ranking`: Uses ranking values to derive one preferred alternative.

  * **Ranking Preference** (when `target_type = ranking`):

    * `lowest_is_best`: Rank 1 is best.

    * `highest_is_best`: Highest rank is best.




### Modeling settings

  * **Modeling Strategy** :

    * `auto`: tries `pylogit` first and falls back if needed.

    * `pylogit`: multinomial-logit-oriented estimation.

    * `choicelearn`: integration path for choice-learn workflows (current plugin behavior may use fallback).

    * `sklearn-proxy`: robust baseline fallback estimator.




### Advanced parameters

Visible when **Show Advanced Parameters** is enabled.

  * **Enable Debug Output Dataset** : If disabled, the debug/validation dataset is written empty.

  * **Random Seed** : Reproducibility seed.

  * **Max Iterations** : Optimization iterations for frequentist fitting.

  * **Regularization Strength (C)** : Inverse regularization used by the fallback logistic estimator.

  * **Generate Business Charts** : Enables visualization outputs.

  * **Top Attributes in Chart** : Limits attribute count in importance chart.

  * **Write HTML Report to Managed Folder** : Exports report to managed folder output.




## Modeling strategies

  * `auto`: tries [pylogit](<https://github.com/timothyb0912/pylogit>), then falls back.

  * `pylogit` ([homepage](<https://github.com/timothyb0912/pylogit>)): closest to classical discrete-choice conjoint interpretation.

  * `choicelearn` ([homepage](<https://artefactory.github.io/choice-learn/>)): integration-oriented strategy for richer choice-learning setups.

  * `sklearn-proxy` ([scikit-learn](<https://scikit-learn.org/stable/>)): deterministic and robust baseline/fallback.




## Detailed modeling differences

  * `pylogit`:

    * Best aligned with standard conjoint/discrete-choice estimation.

    * Most sensitive to strict task structure and data quality.

    * Recommended for primary conjoint interpretation when data is well-formed.

  * `choicelearn`:

    * Extension path toward richer choice-learning modelization.

    * Useful when teams plan to deepen native choice-learn integration.

    * In this plugin version, fallback behavior may apply for compatibility.

  * `sklearn-proxy`:

    * Most robust option when data is imperfect.

    * Useful for baseline benchmarking, sanity checks, and reliable fallback runs.

    * Less canonical than dedicated discrete-choice estimators.




## How to read results

  * **Part-worth utilities** :

    * Higher utility indicates stronger relative preference.

    * Utility is comparative (not an absolute KPI).

  * **Attribute importance** :

    * Shows contribution of each attribute to preference variation.

    * Supports prioritization across product, pricing, and messaging.

  * **Model quality metrics** :

    * Provide confidence signals for business communication and governance.

---

## [statistics/fit]

# Fit curves and distributions

The **Fit curves & distributions** cards model the distributions or relationships of numerical variables. To create a card, you must select from the following options:

  * Fit Distribution

  * 2D Fit Distribution

  * Fit curve




## Fit Distribution

The **Fit Distribution** card estimates the parameters of probability distributions for a specified variable in your dataset. The supported distributions are:

  * Beta

  * Exponential

  * Laplace

  * Log-normal

  * Normal

  * Normal mixture

  * Pareto

  * Triangular

  * Weibull




You can select multiple distributions in the card, and Dataiku DSS displays the probability density function, [Q-Q plot](<https://en.wikipedia.org/wiki/Q-Q_plot>), goodness of fit metrics, and estimated parameters for each distribution.

## 2D Fit Distribution

The **2D Fit Distribution** card visualizes the density of bivariate distributions by plotting the [kernel density estimate (KDE)](<https://en.wikipedia.org/wiki/Multivariate_kernel_density_estimation>) or the joint normal (Gaussian) distribution. To create the card:

  * Specify values for the X and Y variables

  * Select either “2D KDE” plot or the “Joint Normal” plot

  * If you select the “2D KDE” plot, DSS provides two additional parameters: “X relative bandwidth” and “Y relative bandwidth” (in percentages) with default values. However, you can modify these values to control the smoothness of the KDE plot. Larger values produce smoother plots.

Note that the “X relative bandwidth” value scales the horizontal KDE bandwidth as a percentage of the standard deviation of variable X. Likewise, the “Y relative bandwidth” scales the vertical KDE bandwidth as a percentage of the standard deviation of variable Y.




## Fit curve

The **Fit Curve** card models the relationship between two variables by creating one or more fit curves. To create the card:

  * Specify values for the X and Y variables

  * Specify the “Curve Type” as **Polynomial** or **Isotonic**

  * If you select a **Polynomial** curve, then you must provide an integer value for an additional parameter, “Degree”, which specifies the degree of the polynomial.

---

## [statistics/index]

# Interactive statistics

An interactive statistics worksheet in Dataiku DSS provides a dedicated interface for performing exploratory data analysis (EDA) on datasets. Using this feature, you can:

  * Summarize or describe data samples, e.g. using univariate analysis, bivariate analysis, distribution & curve fitting, and correlation matrices. This falls under the area of [descriptive statistics](<https://en.wikipedia.org/wiki/Descriptive_statistics>).

  * Draw conclusions from a sample dataset about an underlying population, e.g. using hypothesis testing. This falls under the area of [inferential statistics](<https://en.wikipedia.org/wiki/Statistical_inference>).

  * Visualize the structure of the dataset in a reduced number of dimensions, using principal component analysis. This falls under the area of [dimensionality reduction](<https://en.wikipedia.org/wiki/Dimensionality_reduction>).




This section of the reference documentation covers the DSS **Worksheet** and performing EDA tasks in DSS.

---

## [statistics/interface]

# The Worksheet Interface

The **Worksheet** is a visual summary of exploratory data analysis (EDA) tasks, and Dataiku DSS allows you to create multiple worksheets for a given dataset. To access the worksheets, click the **Statistics** tab of a dataset.

## Elements of a worksheet

A worksheet header consists of elements described as follows.

  * The **Worksheet** menu allows you to create a new worksheet, or rename, duplicate, delete, and switch from one worksheet to another in the current dataset.

  * The **New Card** button creates a new card and adds it to the current worksheet. You can create multiple cards within a worksheet, with each card performing a specific EDA task. Cards in a worksheet appear below the worksheet header. See Elements of a card for more details.

  * The **Sampling & filtering** menu allows you to configure the sample on which to perform EDA tasks in cards. You can also choose to compute cards on the whole data (no sampling). The specified sample is used to compute all the cards in a worksheet.

  * The **Confidence level** menu allows you to define the global confidence level of statistical tests in the worksheet. Certain statistical tasks use this value to produce [confidence intervals](<http://www.stat.yale.edu/Courses/1997-98/101/confint.htm>) or to highlight _p_ -values according to the significance level.

  * The **Selection** button represents the active data selection (corresponding to a subset of the data). A stripe pattern is used to highlight this selection across all charts in the worksheet. You can remove the active selection at any time by clicking the **Selection** button.

> Note
> 
> This button does not appear by default in the worksheet header. To display it, define the active data selection by clicking on a bar of a histogram plot or a cell of a mosaic plot.

  * The gear icon  provides the option of running the worksheet in a container, for instance, to compute the results on a bigger sample that the DSS server cannot accommodate in memory. See [Running in containers](<../containers/concepts.html>) for more information.




The different types of cards in a worksheet depend on the particular EDA task that you choose to perform. Cards consist of elements that are described as follows.

## Elements of a card

  * The **configuration menu** (✎) allows you to edit the settings of a card.

  * The **deletion button** (🗑) allows you to delete a card.

  * The **general menu** (⋮) allows you to publish a card, duplicate a card or view its JSON representation.

  * The **Split by** menu allows you to select a variable to use for splitting the data into subsets. The card then performs statistical computations on each subset. This feature is useful for comparing the same statistics across multiple groups.

  * The section below the card header contains the results of the EDA task.




### Types of cards

  * [Univariate analysis](<univariate.html>)

  * [Bivariate analysis](<bivariate.html>)

  * [Fit curves and distributions](<fit.html>)

  * [Statistical tests](<tests.html>)

  * [Multivariate analysis](<multivariate.html>)

---

## [statistics/monte-carlo]

# Exploratory Bayesian Analysis

Exploratory Bayesian analysis with MCMC simulations can be done in DSS using a Jupyter notebook template.

This capability is provided by the “Exploratory Bayesian Analysis” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

## How To Use

The notebook template is available by selecting a dataset, go to “Lab”, and in the notebooks section, choosing the appropriate pre-defined template.

The notebook content is mostly self-explanatory, but it should not be executed in one single run of all the cells, it was designed so that the user is guided to build his own probabilistic model that will vary depending on the use-case and the data itself.

---

## [statistics/multivariate]

# Multivariate Analysis

The **Multivariate analysis** cards provide tools to model the distribution of numerical variables across multiple dimensions. To create a card, you must select from the following options:

  * Principal Component Analysis (PCA)

  * Correlation matrix

  * Scatter plot 3D

  * Parallel Coordinates Plot




## Principal Component Analysis (PCA)

Principal component analysis is a popular tool for performing dimensionality reduction in a dataset. PCA performs a linear transformation of a dataset (having possibly correlated variables) to a dimension of linearly uncorrelated variables (called principal components). This transformation aims to maximize the variance of the data. In practice, you would select a subset of the principal components to represent your dataset in a reduced dimension.

The **Principal Component Analysis** card provides a visual representation of a dataset in a reduced dimension.

The PCA card displays a scree plot of eigenvalues for each principal component and the cumulative explained variance (in percentage). The card also displays a scatter plot of the data projected onto the first two principal components and a heatmap that shows the composition of all the principal components.

You can use the PCA configuration menu (✎) to configure the visualization of the heatmap by toggling the values and colors on and off or choosing to show absolute values.

You can also use the PCA general menu (⋮) to export the PCA card as a recipe in the flow. The created recipe must have at least one of the following output datasets:

  * the **projections** dataset contains the projection of the input variables on the principal components

  * the **eigenvectors** dataset contains the principal components

  * the **eigenvalues** dataset contains the amount of variance in the input variables which is explained by each principal component




When creating a PCA recipe from a worksheet card, its settings are copied from the worksheet and the card, such as the sampling or the container configuration for instance. All the recipe settings are independent from the worksheet settings and can be subsequently modified from the recipe settings page.

## Correlation matrix

A correlation matrix is useful for showing the correlation coefficients (or degree of relationship) between variables. The correlation matrix is symmetric, as the correlation between a variable V1 and variable V2 is the same as the correlation between V2 and variable V1. Also, the values on the diagonal are always equal to one, because a variable is always perfectly correlated with itself.

The **Correlation matrix** card allows you to view a visual table of the pairwise correlations for multiple variables in your dataset. By default, Dataiku DSS computes the [Spearman’s rank](<https://en.wikipedia.org/wiki/Spearman%27s_rank_correlation_coefficient>) correlation coefficient, but you can select to compute the [Pearson](<https://en.wikipedia.org/wiki/Pearson_correlation_coefficient>) correlation coefficient instead. Note that you can only use numerical variables to compute the correlation matrix.

The default setting of the correlation matrix displays signed (positive and negative) correlation values within colored cells, with the colors corresponding to the values. However, you can use the correlation matrix configuration menu (✎) to configure the visualization of the correlation matrix. The menu provides options to:

  * Toggle the values and colors on and off

  * Convert correlation values to absolute values

  * Set a threshold so that the matrix only displays a correlation value if its magnitude (or absolute value) is greater than the threshold value.




## Scatter plot 3D

The scatter plot 3D uses Cartesian coordinates to display the values of three numerical variables in a dataset.

By clicking the scatter plot 3D configuration menu (✎) you can configure:

  * the size of the points in the plot

  * the maximum number of points to display




The points to display are randomly drawn from the sample of the worksheet. See [worksheet elements](<interface.html#worksheet-elements>) for more information about sampling.

## Parallel Coordinates Plot

The parallel coordinates plot provides a graphical way to visualize a dataset across a high number of dimensions. The backdrop is made of several parallel axes, each representing a column in the dataset. Each point in the dataset corresponds to a multiline which joins all of the parallel axes at the values taken by the data point.

You can use the parallel coordinates plot configuration menu (✎) to configure the maximum number of data points to display.

The points to display are randomly drawn from the sample of the worksheet. See [worksheet elements](<interface.html#worksheet-elements>) for more information about sampling.

---

## [statistics/simulation]

# Simulation

Risk analysis workflows often require generating realistic scenarios, stress-testing assumptions, and understanding feature dependencies before decisions are made.

The **Risk Analysis** capability provides three complementary recipes for simulation-focused analysis in Dataiku:

  * **Generate Simulated Data** : Simulate tabular data using configurable univariate distributions, with optional copula-based dependency modeling across columns.

  * **Generate Category-Conditioned Simulated Data** : Simulate columns conditionally by category values, with explicit per-slice configuration and fallback behavior for non-configured slices.

  * **Output Correlation Matrix** : Compute and materialize a correlation matrix from selected features using Pearson, Spearman, or Kendall coefficients.




These recipes are built on standard scientific Python tooling (NumPy, SciPy, scikit-learn, statsmodels) and are designed for practical Monte Carlo-style data generation inside Dataiku Flows.

These simulation capabilities are provided through the **Risk Analysis** plugin, instructions to install it can be found by following [Installing plugins](<../plugins/installing.html>).

## Generate Simulated Data

This recipe simulates new rows from an input dataset using one or more simulation configurations.

### Core Capabilities

  * Per-column univariate simulation with configurable distributions.

  * Optional joint simulation over multiple columns using Gaussian or Student-T copula.

  * Optional lower and upper simulation bounds.

  * Handling of non-configured columns via:

    * value replication

    * Gaussian KDE simulation

  * Optional retention of original rows in the output.




### Key Parameters

  * **Number of Iterations Per Simulation** : Number of synthetic rows to generate per simulation block.

  * **Retain Existing Data?** : Keep original rows and append simulated rows.

  * **Simulate Joint Distribution Over Columns Via Copula** :

    * If enabled, choose copula type (Gaussian or Student-T).

    * Choose covariance source:

      * use input correlation matrix dataset

      * fit from sample data

  * **Marginal Distribution Configuration** :

    * Select column and distribution.

    * Optionally fit parameters via MLE.

    * Or provide distribution parameters directly.

  * **Simulation Bounds** :

    * optional lower bound

    * optional upper bound

  * **Method for Non-Configured Columns** :

    * replicate values

    * simulate with KDE




### Output

  * Output dataset with simulated rows.

  * Optional **Marginal Distribution Fit Report** dataset.

  * If retaining existing data, output includes a boolean marker column named `is_simulated`.




## Generate Category-Conditioned Simulated Data

This recipe simulates data conditioned on a chosen categorical feature. It is useful when distributional behavior differs by segment (for example, region, product line, or customer tier).

### Core Capabilities

  * Select one categorical conditioner column.

  * Configure distribution behavior per `(column_to_simulate, conditioning_value)` pair.

  * Apply fallback behavior to non-configured segments and columns.

  * Optionally pool remaining non-configured categories for KDE fitting.

  * Optional retention of original rows with simulation marker.




### Key Parameters

  * **Categorical Variable to Condition On**

  * **Simulation Configurations** :

    * column to simulate

    * conditioning categorical value

    * distribution selection and parameters

    * optional bounds

  * **Method for Non-Configured Columns** :

    * replicate values

    * simulate with KDE

  * **When Using KDE, Handle Remaining Non-Configured Categories** :

    * `per_category`: fit and simulate each remaining category separately

    * `pool_remaining_categories_for_kde`: fit one pooled KDE across all remaining categories

  * **Retain Existing Data?**




### Output Behavior

  * Produces simulated rows for each category value of the conditioner.

  * Row-count behavior:

    * Without retention: approximately `(#categories) x (iterations per simulation)`.

    * With retention: original rows plus simulated rows per category.

  * Adds `is_simulated` marker column when retention is enabled.




### Notes

  * Null values must be removed before running simulation.

  * KDE can fail on degenerate samples (for example, near-constant values that create singular covariance).




## Output Correlation Matrix

This recipe computes a correlation matrix over selected features and writes it back to the Flow. This correlation matrix can be used as input to the copula-based simulation.

### Key Parameters

  * **Choose features to include in correlation matrix**

  * **Correlation type** :

    * Pearson

    * Spearman

    * Kendall

  * **Push resulting correlation matrix to an editable dataset?**




### Output

  * Correlation matrix dataset with an `index` column and one column per selected feature.

  * Optional creation of an additional editable dataset named `<output_name>_editable` when enabled.




## Practical Guidance

  * Prefer parametric distributions when domain knowledge is strong and stable.

  * Use KDE for flexible non-parametric simulation, but verify sample quality and variance.

  * Use copulas when preserving dependency structure is more important than independent feature realism.

  * In conditioned simulation, configure critical slices explicitly and use fallback logic for long-tail slices.

---

## [statistics/tests]

# Statistical Tests

The **Statistical tests** cards allow you to make quantitative decisions by testing statistical hypotheses. Each card displays the outcome of a specific statistical test, and you can see more information about the test (e.g. what the test does, underlying assumptions, etc) by clicking the question icon  in the card header.

You can also use the card general menu (⋮) to export a statistical test card as a recipe in the flow. When creating a statistical test recipe from a worksheet card, its settings are copied from the worksheet and the card, such as the sampling or the container configuration for instance. All the recipe settings are independent from the worksheet settings and can be subsequently modified from the recipe settings page.

The statistical tests cards are grouped into:

  * One-sample tests




>   * Student t-test / Z-test (one-sample)
> 
>   * Sign test (one-sample)
> 
>   * Shapiro-Wilk test
> 
> 


  * Two-sample tests




>   * Student/Welch t-test (two-sample)
> 
>   * Median Mood test (two-sample)
> 
>   * Levene test (two-sample)
> 
>   * Kolmogorov-Smirnov test (two-sample)
> 
> 


  * N-sample tests




>   * One-way ANOVA
> 
>   * Median Mood test (N-sample)
> 
>   * Levene test (N-sample)
> 
>   * Pairwise Student/Welch t-test
> 
>   * Pairwise median Mood test
> 
>   * Pairwise Levene test
> 
> 


  * Categorical test




>   * Chi-square independence test
> 
> 


## One-sample tests

These types of tests allow you to compare the location parameters of a population to a hypothesized constant, or to compare the distribution of a population to a hypothesized one.

### Student _t_ -test / Z-test (one-sample)

A one-sample test to determine if the mean of a variable in a population is a specific value.

To create this card, select a numerical (continuous) variable as the test variable, specify a value for the hypothesized mean, and select the alternative hypothesis to perform a two-sided or one-sided test.

Note

It is also possible to set the standard deviation of the tested population when it is known prior to the test. In this case a **Z-test** will be performed, rather than a Student t-test.

The tested hypothesis is that the mean of the test variable in the tested population is equal to the hypothesized mean.

The output of the one-sample **Student t-test / Z-test** contains:

  * A summary of the test variable

  * The tested and alternative hypotheses

  * The results of the test

  * A figure that displays the distribution of the test statistic.

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive)




### Sign test (one-sample)

A one-sample test to determine if the median of a variable in a population is a specified value.

To create this card, select a numerical (continuous) variable as the test variable, and specify a value for the hypothesized median.

The tested hypothesis is that the median of the test variable in the tested population is equal to the hypothesized median.

The output of the one-sample **Sign test** contains:

  * A summary of the test variable

  * The tested hypothesis

  * The results of the test

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive)




### Shapiro-Wilk test

A one-sample test to determine if a variable is normally distributed in a population.

To create this card, select a numerical (continuous) variable as the test variable.

The tested hypothesis is that the sample comes from a normal (Gaussian) distribution.

The output of the **Shapiro-Wilk test** contains:

  * A figure of a normal distribution fit to the data

  * The summary of the data

  * The tested hypothesis

  * The results of the test

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive).




## Two-sample tests

These types of tests allow you to compare the location parameters of two populations, or to compare the distributions of two populations.

### Student/Welch _t_ -test (two-sample)

A two-sample test to determine if the mean of a variable is the same between two populations.

To create this card:

  * Select a numerical (continuous) variable as the “Test variable”

  * Select whether to assume that the variance is equal between the two populations

  * Select a categorical variable to define the populations by its values

  * Add values from the categorical variable to create two different populations “Population 1” and “Population 2”

  * Select the alternative hypothesis to perform a two-sided or one-sided test




The tested hypothesis is that the mean of the test variable is identical in the two populations.

The output of the two-sample **Student/Welch t-test** contains:

  * A summary of the population samples

  * The tested and alternative hypotheses

  * The results of the test

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive).




### Median Mood test (two-sample)

A two-sample test to determine if the median of a variable is the same between two populations.

To create this card:

  * Select a numerical (continuous) variable as the “Test variable”

  * Select a categorical variable to define the populations by its values

  * Add values from the categorical variable to create two different populations “Population 1” and “Population 2”




The tested hypothesis is that the median of the test variable is identical in the two populations.

The output of the two-sample **Median Mood test** contains:

  * A summary of the population samples

  * The tested hypothesis

  * The results of the test

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive).




### Levene test (two-sample)

A two-sample test to determine if the variance of a variable is the same between two populations.

To create this card:

  * Select a numerical (continuous) variable as the “Test variable”

  * Select the statistics used for centering observations within each population

  * Select a categorical variable to define the populations by its values

  * Add values from the categorical variable to create two different populations “Population 1” and “Population 2”




The tested hypothesis is that the variance of the test variable is identical in the two populations.

The output of the two-sample **Levene test** contains:

  * A summary of the population samples

  * The tested hypothesis

  * The results of the test

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive).




### Kolmogorov-Smirnov test (two-sample)

A two-sample test to determine if a variable is similarly distributed between two populations.

To create this card:

  * Select a numerical variable as the “Test variable”

  * Select a categorical variable to define the populations by its values

  * Add values from the categorical variable to create two different populations “Population 1” and “Population 2”




The tested hypothesis is that the probability distribution is the same in the two populations.

The output of the two-sample **Kolmogorov-Smirnov test** contains:

  * A figure showing the empirical Cumulative Distribution Functions (CDFs) of the two populations

  * A summary of the population samples

  * The tested hypothesis

  * The results of the test

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive).




## N-sample tests

These types of tests allow you to compare the location parameters of multiple populations.

### One-way ANOVA

An n-sample test to determine if the mean of a variable is the same in multiple populations.

To create this card:

  * Select a numerical variable as the “Test variable”

  * Select a categorical variable to define the populations by its values

  * Select either:




>   * “Build the populations from the most frequent values” of your categorical variable and then specify a value for the “Maximum number of populations”, or
> 
>   * “Define the populations manually” and then enter the values of your categorical variable to form the populations.
> 
> 


The tested hypothesis is that the mean of the test variable is identical in all populations.

The output of the **One-way ANOVA test** contains:

  * A summary of the population samples in all the groups

  * The tested hypothesis

  * The results of the test

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive).




### Median Mood test (N-sample)

An n-sample test to determine if the median of a variable is the same in multiple populations.

To create this card:

  * Select a numerical variable as the “Test variable”

  * Select a categorical variable to define the populations by its values

  * Select either:




>   * “Build the populations from the most frequent values” of your categorical variable and then specify a value for the “Maximum number of populations”, or
> 
>   * “Define the populations manually” and then enter the values of your categorical variable to form the populations.
> 
> 


The tested hypothesis is that the median of the test variable is identical in all populations.

The output of the **N-sample Median Mood test** contains:

  * A summary of the population samples in all the groups

  * The tested hypothesis

  * The results of the test

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive).




### Levene test (N-sample)

An n-sample test to determine if the variance of a variable is the same in multiple populations.

To create this card:

  * Select a numerical variable as the “Test variable”

  * Select the statistics used for centering observations within each population

  * Select a categorical variable to define the populations by its values

  * Select either:




>   * “Build the populations from the most frequent values” of your categorical variable and then specify a value for the “Maximum number of populations”, or
> 
>   * “Define the populations manually” and then enter the values of your categorical variable to form the populations.
> 
> 


The tested hypothesis is that the variance of the test variable is identical in all populations.

The output of the **N-sample Levene test** contains:

  * A summary of the population samples in all the groups

  * The tested hypothesis

  * The results of the test

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive).




### Pairwise Student/Welch _t_ -test

An n-sample test to determine if the mean of a variable is the same within pairs of populations.

To create this card:

  * Select a numerical variable as the “Test variable”

  * Select whether to assume that the variance is equal across all the tested populations

  * Select a categorical variable to define the populations by its values

  * Select either:




>   * “Build the populations from the most frequent values” of your categorical variable and then specify a value for the “Maximum number of populations”, or
> 
>   * “Define the populations manually” and then enter the values of your categorical variable to form the populations.
> 
> 


  * Select either:




>   * “Compare all pairs” to test all the pairs that can be formed from the selected populations, or
> 
>   * “Compare against reference population” and enter the value of the categorical variable corresponding to a single reference population.
> 
> 


  * Select the alternative hypothesis to perform a two-sided or one-sided test for each pair

  * Select a value for the “Adjustment Method” from the options: **None** , **Bonferroni** , **Holm-Bonferroni** or **FDR Benjamini-Hochberg**




The tested hypothesis is that the mean of the test variable is identical in the two populations within each pair of populations.

The output of the **Pairwise t-test** contains:

  * The tested and alternative hypotheses

  * A table of pairwise _p_ -values. Holding the cursor over any given _p_ -value tells you whether the tested hypothesis is rejected, or if the test is inconclusive.




### Pairwise median Mood test

An n-sample test to determine if the median of a variable is the same within pairs of populations.

To create this card:

  * Select a numerical variable as the “Test variable”

  * Select a categorical variable to define the populations by its values

  * Select either:




>   * “Build the populations from the most frequent values” of your categorical variable and then specify a value for the “Maximum number of populations”, or
> 
>   * “Define the populations manually” and then enter the values of your categorical variable to form the populations.
> 
> 


  * Select either:




>   * “Compare all pairs” to test all the pairs that can be formed from the selected populations, or
> 
>   * “Compare against reference population” and enter the value of the categorical variable corresponding to a single reference population.
> 
> 


  * Select a value for the “Adjustment Method” from the options: **None** , **Bonferroni** , **Holm-Bonferroni** or **FDR Benjamini-Hochberg**




The tested hypothesis is that the median of the test variable is identical in the two populations within each pair of populations.

The output of the **Pairwise median Mood test** contains:

  * The tested hypothesis

  * A table of pairwise _p_ -values. Holding the cursor over any given _p_ -value tells you whether the tested hypothesis is rejected, or if the test is inconclusive.




### Pairwise Levene test

An n-sample test to determine if the variance of a variable is the same within pairs of populations.

To create this card:

  * Select a numerical variable as the “Test variable”

  * Select the statistics used for centering observations within each population

  * Select a categorical variable to define the populations by its values

  * Select either:




>   * “Build the populations from the most frequent values” of your categorical variable and then specify a value for the “Maximum number of populations”, or
> 
>   * “Define the populations manually” and then enter the values of your categorical variable to form the populations.
> 
> 


  * Select either:




>   * “Compare all pairs” to test all the pairs that can be formed from the selected populations, or
> 
>   * “Compare against reference population” and enter the value of the categorical variable corresponding to a single reference population.
> 
> 


  * Select a value for the “Adjustment Method” from the options: **None** , **Bonferroni** , **Holm-Bonferroni** or **FDR Benjamini-Hochberg**




The tested hypothesis is that the variance of the test variable is identical in the two populations within each pair of populations.

The output of the **Pairwise Levene test** contains:

  * The tested hypothesis

  * A table of pairwise _p_ -values. Holding the cursor over any given _p_ -value tells you whether the tested hypothesis is rejected, or if the test is inconclusive.




## Categorical test

This type of test determines whether there is a significant relationship between two categorical variables in a sample or if the two variables are independent.

### Chi-square independence test

A test to determine if two categorical variables are independent.

To create this card:

  * Select categorical variables for “Variable 1” and “Variable 2”

  * Specify numerical values for the “Maximum X Values to Display” and the “Maximum Y Values to Display”




The tested hypothesis is that the two variables are independent.

The output of the **Chi-square independence test** contains:

  * The tested hypothesis

  * The results of the test

  * A conclusion about the test (whether the tested hypothesis is rejected, or if the test is inconclusive)

  * A table of the actual versus expected number of observations for each row and column combination in the table count of values for each cell

---

## [statistics/time-series]

# Time Series Analysis

Time series analysis is useful for exploring a dataset which contains one or more time series. This kind of analysis allows you to perform statistical tests on time series, as well as to inspect some of its properties like the auto-correlation function.

All of these cards share common configuration options. In order to create or configure a time series analysis, you have to select a numerical (continuous) variable which holds the series values. You also have to select a time variable which holds the timestamps formatted according to the ISO8601 format.

If the dataset uses the [long format](<../time-series/data-formatting.html#ts-long-format-label>) to store the time series, it is possible to specify the time series identifiers by checking the corresponding checkbox. In this case, the variable name as well as the value used to discriminate the time series must be provided.

All time series card outputs include a summary for the time series, as well as the detected time step for the series.

Warning

Most of the time series computations require that the time series is evenly distributed with a constant time step. Resampling of a time series using a constant time step can be achieved by using the [time series preparation](<../time-series/time-series-preparation/resampling.html>) plugin

The analysis cards are grouped into:

  * Stationarity and unit root tests

    * Augmented Dickey-Fuller (ADF) test

    * Zivot-Andrews test

    * Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test

  * Trend

    * Mann-Kendall trend test

  * Auto-correlation

    * Auto-correlation function plot

    * Partial auto-correlation function plot

    * Durbin-Watson statistic




## Stationarity and unit root tests

This kind of test allow you to assess whether a time series is stationary or has a unit root. A stationary series is a series which statistical properties do not change over time. Also, the presence of a unit root in a time series suggests that the series is not stationary.

By default, the number of lags that will be used by the test is automatically computed but you can choose to manually set this value if it suits your use case better.

The conclusion of a unit root test indicates whether the test rejects the hypothesis at the given significance level, or whether it is inconclusive.

### Augmented Dickey-Fuller (ADF) test

The Augmented Dickey-Fuller test tests the hypothesis that there exists a unit root in the time series.

The configuration options allow to specify the regression model that is used by the test.

### Zivot-Andrews test

The Zivot-Andrews test tests the hypothesis that there exists a unit root with one structural break in the time series.

The configuration options allow to specify the regression model that is used by the test.

### Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test

The KPSS test tests the hypothesis that the time series is stationary.

The configuration options allow to specify the regression model that is used by the test.

## Trend

This kind of analysis allows to inspect the trend of a time series.

### STL decomposition plot

The STL decomposition plot is used to visualize the trend and seasonality of a series.

You can also enable the compact view to display the original series and its components (trend, seasonality and residuals) on a uniform scale. This not only makes comparing series with similar scales easier (usually the original series and the trend series), but also helps identifying differences in scale among the series.

The configuration options give control over the type of decomposition that you want (additive or multiplicative) and over the STL decomposition algorithm parameters.

Note

The parameters of the STL decomposition algorithm are the ones from the statsmodels library. For more information visit [the statsmodels documentation](<https://www.statsmodels.org/v0.12.2/generated/statsmodels.tsa.seasonal.STL.html>).

### Mann-Kendall trend test

The Mann-Kendall trend Test is used to analyze series data for consistently increasing or decreasing trends (monotonic trends). It tests the hypothesis that there is no monotonic trend in the time series.

The conclusion of the **Mann-Kendall trend test** indicates whether the test rejects the hypothesis at the given significance level, or whether it is inconclusive.

## Auto-correlation

The auto-correlation analyses allow to inspect the degree of correlation of a time series with lagged versions of itself (with a given number of lags).

### Auto-correlation function plot

The auto-correlation function plot allows to visually inspect the auto-correlation function of a time series. For each lag and coefficient, the confidence interval is displayed in the background.

The configuration options give control on whether the coefficients must be adjusted to account for the loss of data.

By default, the number of lags that will be used to compute the coefficients is automatically computed but you can choose to manually set this value if it suits your use case better.

Note

The configuration options allows to quickly jump between auto-correlation and auto-correlation functions.

### Partial auto-correlation function plot

The partial auto-correlation function plot allows to visually inspect the partial auto-correlation function of a time series. For each lag and coefficient, the confidence interval is displayed in the background.

The configuration options allow to specify the method to use for computing the coefficients.

By default, the number of lags that will be used to compute the coefficients is automatically computed but you can choose to manually set this value if it suits your use case better.

Note

The configuration options allows to quickly jump between auto-correlation and auto-correlation functions.

### Durbin-Watson statistic

The Durbin-Watson statistic gives a measurement for the first order auto-correlation of a time series (with a lag value of 1). The statistical test associated to this statistic tests the hypothesis that there is no first order auto-correlation in the time series.

The conclusion of the **Durbin-Watson statistic** analysis tells whether the statistic shows evidence of positive or negative auto-correlation.

---

## [statistics/univariate]

# Univariate Analysis

Univariate analysis is useful for exploring a dataset one variable at a time. This kind of analysis does not consider relationships between two or more variables in your dataset. Rather, the goal here is to describe and summarize the dataset using a single variable.

The **Univariate analysis** card allows you to select multiple variables from your dataset so that you can see the individual distributions for the variables side-by-side. Dataiku DSS creates a section in the card for each variable and, depending on the type of variable (continuous or categorical), populates each section with the appropriate statistical analysis options.

When you create a card, each section has a general menu (⋮), a deletion button (🗑) as well as a configuration menu (✎).

Clicking the general menu (⋮) provides options to:

  * Treat the variable as categorical or continuous — this affects only the current univariate analysis.

  * Duplicate the section to a new card

  * View the JSON representation of the section

  * Export the section to a dashboard




Clicking the configuration menu (✎) provides options that are specific to the card.

You can also use the top-level univariate analysis card general menu (⋮) to export the univariate analysis as a recipe in the flow. When creating a univariate analysis recipe from a worksheet card, its settings are copied from the worksheet and the card, such as the sampling or the container configuration for instance. All the recipe settings are independent from the worksheet settings and can be subsequently modified from the recipe settings page.

## Card options

Several statistical options are available when generating a univariate analysis.

### Histogram

#### Numerical histogram

The numerical histogram shows the distribution of a continuous variable. By default, DSS automatically chooses a number of bins, configurable by clicking the histogram configuration menu (✎). When you select the box plot along with the histogram, both plots are placed in the histogram chart.

#### Categorical histogram

The categorical histogram (also known as a bar chart) shows the distribution of a categorical variable. DSS sorts the bins by the count of records in descending order. However, you can configure the bins by clicking the histogram configuration menu (✎).

### Box Plot

The box plot is a graphical tool that summarizes the distribution of numerical data by showing quartiles. When both the histogram and the box plot are active, the box plot is placed in the histogram chart.

### Summary Stats

Summary statistics are scalar values that highlight key information about the values in your dataset (continuous or categorical). Examples are min, max, mean, and median. By default, DSS displays only a selection of summary statistics, based on whether the variable is continuous or categorical. However, it is possible to add more statistics by clicking the summary configuration menu (✎).

### Quantile Table

Computes the [quantiles](<https://en.wikipedia.org/wiki/Quantile>) of a continuous variable. You can use the default quantiles or define custom quantiles by clicking the Quantile table configuration menu (✎).

### Frequency Table

The frequency table shows categorical data in a compact form by displaying the count of records and percentage frequency in descending order. You can configure the number of displayed values by clicking the frequency table configuration (✎).

### Cumulative Distribution Function

The cumulative distribution function provides a graphical way to visualize the distribution of any continuous variable. It shows, for any value x living in the range of the variable, the probability that a random sample of the variable gives a value being less or equal than x.