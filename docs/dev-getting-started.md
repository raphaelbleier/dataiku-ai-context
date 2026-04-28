# Dataiku Docs — dev-getting-started

## [getting-started/basic-workflow/index]

# Basic workflow

This section will provide you a programmer’s view of how workloads are built and orchestrated in the Dataiku platform. It is inspired by [this documentation page](<https://doc.dataiku.com/dss/latest/concepts/index.html> "\(in Dataiku DSS v14\)") but puts it in the perspective of a coder user.

## Connecting to your data

When working on a data project, the first steps often involve connecting to the data storage platforms hosting your data, like data warehouses or object storage buckets. To do so, you should provide the location of those sources and a set of relevant credentials. Handling this manually in your code can be a cumbersome and repetitive task, so the Dataiku platform provides a simplified framework to speed up the work of data scientists.

In practice, each data source is materialized within Dataiku as a “connection” object, which contains information on how to authenticate and follow a given path to read and write your data. By doing so, Dataiku enforces a clear separation of responsibilities: while platform administrators create and maintain connections, end users can focus on implementing their projects.

Once you have access to the data storage, the next step is to retrieve specific data pieces that will be useful in your project. For that, the concept of “dataset” provided by Dataiku comes in handy. In short, a dataset acts as a _pointer_ to tabular data sources living on a data storage platform for which a connection has been defined. In practice, when you write code in Dataiku, you manipulate dataset objects that rely on the connection properties to authenticate against the data source and read/write data from/to it. Dataset definitions include the underlying data schema, column names, and types.

To further facilitate data manipulation, dataset objects have been designed to give end-users access to data through well-known programmatic interfaces, such as SQL tables and pandas/PySPark DataFrames. This way, the data storage type is abstracted away from the user, who will only have to care about _what_ to do with the data instead of _where_ and _how_ to find it.

In that same spirit, pointers to more generic (i.e., not necessarily tabular) data are also available in Dataiku as “managed folders.” They often handle unstructured data such as images or text documents.

See also

  * Connections [documentation page](<https://doc.dataiku.com/dss/latest/connecting/index.html> "\(in Dataiku DSS v14\)") and [API reference](<../../api-reference/python/connections.html>)

  * Datasets [documentation section](<https://doc.dataiku.com/dss/latest/concepts/index.html> "\(in Dataiku DSS v14\)") and [API reference](<../../api-reference/python/datasets.html>)

  * Managed folders [documentation page](<https://doc.dataiku.com/dss/latest/connecting/managed_folders.html> "\(in Dataiku DSS v14\)") and [API reference](<../../api-reference/python/managed-folders.html>)




## Running code

In your project, your code will likely read data, process it, and then write the results. In other words, your code’s task will work with input items and produce output items. In Dataiku, the reasoning is built so that you don’t run tasks; instead, you build output items. This so-called **data-driven** mindset takes inspiration from all standard build tools in the software engineering ecosystem (e.g., make, Maven, Gradle), where the developers focus on the target they want to build instead of the underlying code.

In practice, to run code in a Dataiku project, you will write its logic into a recipe, and to execute this code, you will build the recipe’s output items. Recipes can be written in Python or R and edited in various environments (see the [Tools for coding](<../getting-started/index.html#getting-started-tool-for-coding>) page).

While datasets are the most common type of _buildable items_ , more items fall into this category, like managed folders or ML models. All in all, the entire logic of your project can be articulated by chaining buildable items and linking them with recipes, forming a direct acyclic graph (DAG) called the Flow.

See also

  * Recipes [documentation page](<https://doc.dataiku.com/dss/latest/code_recipes/index.html> "\(in Dataiku DSS v14\)") and [API reference](<../../api-reference/python/recipes.html>)




## Building a Flow

Dataiku’s Flow unveils the true power of a data-driven workflow: _dependency management_. In a data project, the most critical parts are often materialized by the final elements of the workflow’s DAG. In Dataiku, you will focus on building the final item of your Flow. Every upstream buildable item is then treated as a dependency, meaning it must also be built if it isn’t already. Dataiku’s dependency resolver solves the recursion problem of determining which dependencies need to be built. Then the scheduler takes care of running all tasks required for those builds, enforcing concurrency and parallelism when it’s possible.

The user is free to define the level of granularity in their project, which often translates to the number of intermediary states in a Flow. Dataiku offers additional tooling to segment better the logic of a Flow and flush unnecessary intermediary data when needed so that the flow’s expressiveness is not sacrificed for conciseness.

See also

  * Flow [documentation page](<https://doc.dataiku.com/dss/latest/flow/index.html> "\(in Dataiku DSS v14\)") and [API reference](<../../api-reference/python/flow.html>)

  * [Blog post](<https://blog.dataiku.com/the-flow>) providing more details on data-driven Flows in Dataiku.




## Scheduling and automating a Flow

Once your Flow has been developed, one important step towards its production-readiness is to define how its execution can be scheduled and automated. In Dataiku, the most frequent patterns are:

  * Using the native “scenario” feature to define _steps_ to execute, _triggers_ that will launch the execution, and _reports_ to format the outcome of your runs.

  * Using Dataiku’s public API to connect to a third-party scheduler, which can either enforce its own scheduling rules or remotely start a Dataiku scenario.




See also

  * Scenario [documentation page](<https://doc.dataiku.com/dss/latest/scenarios/index.html> "\(in Dataiku DSS v14\)") and [API reference](<../../api-reference/python/scenarios.html>)

---

## [getting-started/dataiku-python-apis/index]

# The Dataiku Python packages

Code-savvy users of the Dataiku platform can interact with it using a complete set of Python APIs that are split between two packages, respectively called `dataiku` and `dataikuapi`. While they are often used together, their underlying primitives serve distinct purposes:

  * [`dataikuapi`](<https://pypi.org/project/dataiku-api-client/>) is a client for Dataiku’s public REST API, which is helpful in programmatically maintaining the platform or making it interact with other applications or systems.

  * `dataiku` is for **internal operations** , data processing, and machine learning tasks within the platform. It allows low-level interactions with core items such as datasets and saved models.




Both packages can be used from Dataiku out of the box; you can connect to your instance and perform some operations, like:
    
    
    import dataiku
    
    client = dataiku.api_client()
    
    # client is now a DSSClient and can perform all authorized actions.
    # For example, list the project keys for which you have access
    client.list_project_keys()
    

Please refer to the [Dataiku API](<../../tutorials/devtools/api.html>) section for a deeper insight into the Dataiku API usage.

Attention

If you edit code outside the platform (e.g., using the VSCode or PyCharm editor plugins), don’t forget to [install the Dataiku Python APIs locally](<../../tutorials/devtools/python-client/index.html>).

  * If you are a beginner user looking to get more familiar with the basics of Dataiku’s public API, start with the [Dataiku’s Public API: A Comprehensive Guide](<../../tutorials/devtools/public-api-intro/index.html>) tutorial.

  * Check out the [API reference](<../../api-reference/python/index.html>) section for complete documentation of the `dataiku` and `dataikuapi` packages.




In the rest of this Developer Guide, for the sake of simplicity, we won’t distinguish between `dataiku` and `dataikuapi` unless absolutely needed: we will refer to the “Dataiku Python APIs” instead.

---

## [getting-started/getting-started/index]

# Getting started

## Being a coder

As a coder using Dataiku, you can develop more powerful/adaptable data solutions. While Dataiku is designed for users with varying technical expertise, it is also coder-friendly.

### Enhanced Customization and Flexibility

Coders can create custom code recipes using Python, R, and SQL. Custom recipes can offer alternatives to existing data transformations, algorithms, and execution contexts. You’re not limited to Dataiku’s standard offerings. You can build any logic required to meet your needs.

### Advanced usage of Generative AI

Dataiku provides a centralized and secure gateway to a wide range of LLMs. Coders can test different LLMs without changing their code, but only by changing the connection. Coders can define their personalized connection, allowing the usage of tailored or self-hosted LLMs. You can define your code logic embedded into an agent, a tool, or any new emerging concepts of LLM, and easily compare model performance and cost without changing the core logic. Dataiku provides a complete integration for RAG, allowing you to create a dedicated chatbot.

### Advanced Machine Learning

Although Dataiku’s visual machine learning tools are powerful, you can code your own model or use external libraries to build custom machine learning models. You’ll use your model within Dataiku, allowing you to take full advantage of Dataiku’s features. These models will become part of the platform, allowing users to run them in Dataiku.

### Automation and Integration

Programmers can exploit Dataiku’s API to control and automate almost every platform aspect; from datasets to scenarios to Large Language Models, you can easily integrate Dataiku into your CI/CD workflow. Dataiku also offers integrated CI/CD solutions that can be configured via code. These capabilities allow you to envisage a rapid, stable, and automated production launch. For example, you can write a script that automatically re-trains and deploys a model when new data becomes available.

### Extensibility with Plugins

One of the most significant benefits for coders is the ability to develop custom plugins. These plugins can add new functionalities to Dataiku, such as new dataset connectors, custom data preparation steps, or unique visualizations. This allows you to extend the platform to meet your organization’s specific needs and share these new capabilities with other users, both technical and non-technical.

While Dataiku empowers everyone to work with data, coders can push the boundaries of what’s possible, creating more sophisticated, automated, and integrated data science solutions.

This page briefly explains where the code is written and executed when working on a Dataiku instance.

## Tools for coding

### Notebooks

If you are looking for a way to interactively explore your data and experiment with small pieces of code, then **notebooks** are the way to go. They allow you to execute your code by consecutive blocks called _cells_ , and visualize each cell’s output.

Dataiku offers the ability to spawn complete code notebook environments server-side:

  * SQL notebooks to run interactive queries on your SQL databases.

  * Code notebooks to execute Python or R code in a simple yet effective interface based on Jupyter notebooks.




All these solutions are natively embedded in the Dataiku web interface to facilitate navigation and allow you to easily share your work with other users on the same instance. Additionally, Python/R notebook sources (`.ipynb` files) can be synchronized from/to remote Git repositories.

See also

  * [Documentation page on code notebooks](<https://doc.dataiku.com/dss/latest/notebooks/index.html> "\(in Dataiku DSS v14\)").

  * [Concept | Jupyter notebook](<https://knowledge.dataiku.com/latest/code/python/concept-jupyter-notebook.html> "\(in Dataiku Academy v14.0\)").

  * [Concept | SQL notebooks](<https://knowledge.dataiku.com/latest/code/sql/concept-sql-notebooks.html> "\(in Dataiku Academy v14.0\)")




### Code recipe

Once you have tested your code in a notebook or elsewhere, you may want to integrate it into Dataiku. Code recipes provide a way to run code on many different inputs/outputs (among datasets, managed folders, knowledge banks, and agents, for example). This way, your workflow integrates your specific needs. A code recipe can replace a visual recipe if you feel more comfortable using code.

See also

  * [Code recipes](<https://doc.dataiku.com/dss/latest/code_recipes/index.html> "\(in Dataiku DSS v14\)")

  * [Concept | Python recipe](<https://knowledge.dataiku.com/latest/code/python/concept-python-recipe.html> "\(in Dataiku Academy v14.0\)")

  * [Concept | SQL code recipes](<https://knowledge.dataiku.com/latest/code/sql/concept-sql-code-recipes.html> "\(in Dataiku Academy v14.0\)")




### IDE and Code Studio

If you already use an IDE like Visual Studio Code or PyCharm on your client machine, installing the relevant extensions/plugins will allow you to connect it to your Dataiku instance and edit source code directly.

If you prefer editing your source code remotely, Dataiku can embed a Visual Studio Code editor directly in its interface. This option is based on the platform’s “Code Studios” feature and does not require any setup on your client machine since the platform fully manages it.

See also

  * [Code Studios](<https://doc.dataiku.com/dss/latest/code-studios/index.html> "\(in Dataiku DSS v14\)")




**VSCode/IntelliJ extension for Dataiku**

  * The [Visual Studio marketplace page](<https://marketplace.visualstudio.com/items?itemName=dataiku.dataiku-dss>) to install and configure the extension

  * The [tutorial explaining how to use the extension](<../../tutorials/devtools/vscode-extension/index.html>)




**PyCharm plugin for Dataiku**

  * The [JetBrains marketplace page](<https://plugins.jetbrains.com/plugin/12511-dataiku-dss>) to install and configure the plugin

  * The [tutorial explaining how to use the plugin](<../../tutorials/devtools/pycharm-plugin/index.html>)




**Code Studios**

  * [Documentation page on Code Studios](<https://doc.dataiku.com/dss/latest/code-studios/index.html> "\(in Dataiku DSS v14\)")

  * [Using VSCode for Code Studios tutorial](<../../tutorials/devtools/using-vscode-for-code-studios/index.html>)




## Managing dependencies

Writing code often implies working with third-party packages that you must install separately. For example, in the case of Python, you would take advantage of **virtual environments** to create and import your dependencies.

In Dataiku, the equivalent of the virtual environment concept is called the **code environment**. It lets you choose which Python version and custom packages you want to run your code with. Once the code environment is set up, its dependencies can be imported from any code run by Dataiku.

See also

  * [Documentation page on code environments](<https://doc.dataiku.com/dss/latest/code-envs/index.html> "\(in Dataiku DSS v14\)").




### Building a shared code base

When writing code for a project, past a certain size and/or complexity threshold, it is essential to modularize it into classes and functions. By doing so, you also allow other users to import these items directly instead of re-implementing them. This concept of **shared code repository** is materialized in Dataiku in the form of **project libraries**.

Thanks to them, you can decouple your code’s logic (containing business/domain expertise) from the Dataiku-related code that handles workflow orchestration.

See also

  * [Documentation page on project libraries](<https://doc.dataiku.com/dss/latest/python/reusing-code.html> "\(in Dataiku DSS v14\)").

  * [Concept | Shared code](<https://knowledge.dataiku.com/latest/code/shared/concept-shared-code.html> "\(in Dataiku Academy v14.0\)")

  * [Using external libraries for projects](<../../tutorials/devtools/shared-code/index.html>)




### Bringing an external code base

As a new Dataiku user, you have already worked on an existing code base living independently from the instance. You can make the items of this code base directly importable in Dataiku by using a special feature of project libraries called “Git references.” Provided the external code is hosted on a remote Git repository, this feature allows you to pull a specific branch of that repository into Dataiku, which will be materialized into a project library.

By doing so, you can have your Dataiku workflows **operate hand-in-hand with any external code repository**.

See also

  * [Documentation page on Git references](<https://doc.dataiku.com/dss/latest/collaboration/import-code-from-git.html> "\(in Dataiku DSS v14\)").

  * [Git collaboration](<../../tutorials/devtools/git-collaboration/index.html>)




## Git integration

Dataiku natively includes git operations. There are several ways to interact with git, from managing your code to managing your project. The documentation contains several guidelines for using git within Dataiku.

See also

  * [Working with Git](<https://doc.dataiku.com/dss/latest/collaboration/git.html> "\(in Dataiku DSS v14\)")

  * [Git collaboration](<../../tutorials/devtools/git-collaboration/index.html>)

  * [Git basics in Dataiku](<../../tutorials/devtools/git-dss-setup/index.html>)

  * [Using the API to interact with git for project versioning](<../../tutorials/devtools/using-api-with-git-project/index.html>)

---

## [getting-started/index]

# Getting started

This section gives you an overview of the Dataiku platform from the perspective of a new user working primarily with code.

Introduction

[](<intro-value/index.html>)

Development environment

[](<getting-started/index.html>)

Basic workflow

[](<basic-workflow/index.html>)

MLOps lifecycle

[](<mlops-lifecycle/index.html>)

The Dataiku Python APIs

[](<dataiku-python-apis/index.html>)

---

## [getting-started/intro-value/index]

# Introduction

Dataiku is a govern centralized platform for Everyday AI, based on seven key capabilities:

  1. **GenAI & Agents**: Move beyond the lab and safely deliver GenAI & Agents at enterprise scale. Dataiku offers teams a secure large language model (LLM) gateway, no-code to full-code development tools, and AI-powered assistants to help everyone do more with GenAI & Agents.

     * For more information, **non-coders** can follow the [Quick Start | Dataiku for Generative AI](<https://knowledge.dataiku.com/latest/getting-started/tasks/genai/quick-start-index.html> "\(in Dataiku Academy v14.0\)") (in the Knowledge Base).

     * **Coders** will find several tutorials in [Generative AI](<../../tutorials/genai/index.html>) and small examples in [Concepts and examples](<../../concepts-and-examples/index.html>).

  2. **Machine Learning** : From a guided approach with AutoML to cutting-edge techniques and full code, use Dataiku to build and evaluate machine learning (ML) models faster — all with the highest standards of explainability.

     * For more information, **non-coders** can follow the [Quick Start | Dataiku for machine learning](<https://knowledge.dataiku.com/latest/getting-started/tasks/ml/quick-start-index.html> "\(in Dataiku Academy v14.0\)") (in the Knowledge Base).

     * **Coders** will find several tutorials in [Machine Learning](<../../tutorials/machine-learning/index.html>) and small examples in [Concepts and examples](<../../concepts-and-examples/index.html>).

  3. **Analytics & Insights**: Upgrade your business intelligence (BI) and self-service analytics efforts with Dataiku. Enable everyone to make better, faster, everyday decisions built on trusted data via capabilities like visualization, dashboards, GenAI-powered storytelling, and more — all in one unified platform.

     * **Non-coders** can follow [Visualize Data](<https://knowledge.dataiku.com/latest/visualize-data/index.html> "\(in Dataiku Academy v14.0\)") (in the Knowledge Base) for more information.

     * **Coders** will find tutorials about [Webapps](<../../tutorials/webapps/index.html>) and small examples in the [Concepts and examples](<../../concepts-and-examples/index.html>) section.

  4. **Data Prep for AI** : Connect, cleanse, and prepare data 10x faster with Dataiku. From data preparation, effortlessly transition to anything from basic analysis to modeling and even deployment — all within a single environment.

     * For more information, **non-coders** can follow the [Quick Start | Dataiku for data preparation](<https://knowledge.dataiku.com/latest/getting-started/tasks/data-prep/quick-start-index.html> "\(in Dataiku Academy v14.0\)") (in the Knowledge Base).

     * **Coders** will find code samples in [Concepts and examples](<../../concepts-and-examples/index.html>), as well as instructions on how to customize their inputs in [Plugins development](<../../tutorials/plugins/index.html>).

  5. **AI Governance** : Enforce AI governance standards across all data work, all in one place. From data preparation and self-service analytics to machine learning and generative AI applications or projects, maintain visibility and reduce risk as your AI portfolio scales with Dataiku.

**Coders** and **non-coders** will find a lot of information on their respective websites ([the Developer Guide](<../../index.html>) and [the Knowledge Base](<https://knowledge.dataiku.com/latest/index.html> "\(in Dataiku Academy v14.0\)"), respectively).

  6. **AI Engineering Operations** : Manage all dimensions of your AI portfolio operations through a single, unified platform. Whether you’re automating data pipelines to ensure clean, reliable, and timely data or deploying and managing machine learning models and GenAI applications in production, Dataiku brings all your project operations together seamlessly.

**Coders** and **non-coders** will find a lot of information on their respective websites ([the Developer Guide](<../../index.html>) and [the Knowledge Base](<https://knowledge.dataiku.com/latest/index.html> "\(in Dataiku Academy v14.0\)"), respectively).

  7. **AI Ecosystem** : With Dataiku, it’s easy to create analytic dashboards and data products and share them with business users to support day-to-day decision making. Generative AI applications, what-if analysis with outcome optimization, and interactive web apps — developed with or without code — are just a few ways to empower your organization with self-service analytics.

**Coders** and **non-coders** will find a lot of information across their respective websites.

---

## [getting-started/mlops-lifecycle/index]

# MLOps lifecycle

Building and deploying machine learning (ML) models is a cornerstone of most data science projects, and Dataiku provides a comprehensive set of features to ease and speed up these operations. While the platform offers a wide range of visual capabilities, it also exposes numerous programmatic elements for anyone who wants to handle their model’s lifecycle using code.

## Training

The first step of the machine learning process is to fit a model using training data. This is an experimental phase during which you can test various combinations of pre-processing, algorithms, and parameters. Running such trials and logging their results is called **experiment tracking** ; it is implemented natively in Dataiku so that you can use a variety of ML frameworks to train models and log their performance and characteristics.

Note

Under the hood, Dataiku uses [MLflow models](<https://mlflow.org/docs/latest/models.html>) as a standardized format to package models.

See also

  * Experiment tracking [documentation page](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/index.html> "\(in Dataiku DSS v14\)")

  * [Tutorials](<../../tutorials/machine-learning/index.html#machine-learning-tutos-experiment-tracking>) on experiment tracking using different ML frameworks




## Import

In some cases, training a model can require much time and computing resources, so you may prefer to bring in an existing pre-trained model and perform subsequent operations in the Dataiku platform.

Several features can help speed up this process. You can either:

  * Retrieve and cache pre-trained models and embeddings provided by your ML framework of choice using _code environment resources_.

  * Bring in model artifacts inside your Flow and store them in managed folders.




You can fine-tune your models using experiment tracking or continue with evaluation and deployment.

See also

  * [Tutorials](<../../tutorials/machine-learning/index.html#machine-learning-tutos-pretrained-models>) on pre-trained models




## Evaluation

Evaluating a model involves computing a set of metrics to reflect how well it performs against a specific _evaluation dataset_.

In Dataiku, these metrics encompass the model’s _predictive power_ , _explainability_ , and _drift_ indicators. The values of those metrics are computed in a buildable Flow item called the “evaluation store”. They are accessible either in their raw form using the public API or visually through a set of rich visualizations embedded in the Dataiku web interface.

See also

  * Model evaluation stores [the documentation page](<https://doc.dataiku.com/dss/latest/mlops/model-evaluations/index.html> "\(in Dataiku DSS v14\)") and [API reference](<../../api-reference/python/model-evaluation-stores.html>).




## Deployment and scoring

The final step to make a model operational is to _deploy_ it on a production infrastructure where it will be used to _score_ incoming data. Depending on how the input data is expected to reach the model, Dataiku offers several deployment patterns:

  * If the model is meant to be queried via HTTP, Dataiku can package it as a _REST API endpoint_ and take advantage of cloud-native infrastructures such as Kubernetes to ensure scalability and high-availability.

  * For cases where larger _data batches_ are expected to be processed and then scored, Dataiku allows the deployment of entire projects to production-ready instance types called _Automation nodes_.




Dataiku also offers flexible choices to pilot the deployment process, which can be executed using the platform’s native “Deployer” features or delegated to an external Continuous Integration/Delivery (CI/CD).

Note

For specific cases where models need to be exported outside of Dataiku, you can generate standalone Python or Java artifacts. For more information, see the related [documentation page](<https://doc.dataiku.com/dss/latest/machine-learning/models-export.html> "\(in Dataiku DSS v14\)").

See also

  * API services [documentation page](<https://doc.dataiku.com/dss/latest/apinode/introduction.html> "\(in Dataiku DSS v14\)")

  * [Knowledge Base articles](<https://knowledge.dataiku.com/latest/deploy/scaling-automation.html>) on Dataiku and CI/CD pipelines.