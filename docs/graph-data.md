# Dataiku Docs — graph-data

## [graph/graph-analytics]

# Graph Analytics

With this plugin, you will be able to:

  * Create a projected graph from a bipartite graph dataset.

  * Compute common graph features.

  * Run clustering graph algorithms.

  * Visualize graphs in custom charts.




Note

This capability is provided by the “Graph Analytics” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

## How To Use

We will explain the different plugin components using a dataset of movies and their actors as example.

Using the **Projected graph** recipe, we will first convert this dataset into a graph dataset that contains pairs of actors that played in movies together.

We will use the **Graph clustering** recipe to assign actors to different clusters based on some selected graph clustering algorithms.

Then, the **Graph features** recipe will compute for each actor some common graph features such as pagerank, degree, eigenvector centrality.

Finally, we will be able to visualize the output of these recipes in a **Graph chart** in order to get some insights about the graph.

Here are the first rows of the Movies and Actors dataset:

### Create a projected graph from a bipartite graph

Using this recipe we can convert this dataset into a graph of actors. Two actors are connected if they played in the same movie.

The output of this recipe is a dataset of pairs of actors. Because **Weighted graph** has been selected, the extra column **weight** is the number of movies in which the two actors played together.

### Graph clustering

This recipe uses the iGraph library to compute clustering algorithms from a dataset of relations.

You need to select the **Source** and **Target** columns of your input dataset that are linked together (**Actors_1** and **Actors_2**).

This will create edges between actors in the same row. Here the graph is not directed because the order between Source and Target is irrelevant.

We can select the **weight** column to create a weighted graph.

There are two options for the **Output Type** :

  * **Dataset of edges** to keep the same dataset structure: one row per edge and additional columns with the features of both the source and target nodes.

  * **Dataset of nodes** to only keep information about the nodes (the edges are lost): one row per node and its features.




For each clustering algorithm selected, nodes are assigned their cluster id.

Each row contains the clustering values of both the source and target nodes (_fastgreedy_source *are the cluster values computed by the *fastgreedy_ algorithm corresponding to the source column).

### Graph features

This recipe works exactly like the **Graph clustering** recipe but compute different types of graph features.

### Graph chart

We can visualize the dataset as a graph using the custom chart of the plugin (in **Charts > Other > Graph chart**):

You need to drag and drop the **Source** and **Target** columns and select a maximum number of nodes to be displayed.

You can decide whether you want directed edges (edges with arrows).

You can also use the filters on the left (here we choose to display only edges with a weight higher than one):

You can also zoom in to see more information about the nodes.

By selecting **Show advanced options** you will be able to customise the graph display (node color, node size, edge width).

For example, you can use the graph clustering values to set the nodes colors: nodes with the same values (in the same cluster) will have the same color.

You can also set the nodes sizes by selecting numerical columns: the higher the value, the bigger the node.

When you zoom in, you can see the nodes labels (and if you hover a node or an edge, it will display more information about the attributes used to set the color, size or width).

Finally, double clicking on a node will highlight only its neighbours.

It’s now your turn to customise your graph and share it in a dashboard to other users !

---

## [graph/index]

# Graph

Graph data structure natively represents relationships between data. The two main parts of a graph are:

  * Vertices (or nodes) that represent objects and their properties

  * Edges (or connections) that represent links between two vertices




Some of the key benefits are:

  * **Enhanced Data Relationships & Insights**

    * Unlike traditional tabular data analysis, graph analytics enables users to explore intricate relationships between data points, providing a holistic view of connections and dependencies.

  * **Identify unusual connections**

    * Graph analytics is particularly effective in identifying fraudulent activities by detecting unusual patterns, anomalies, and suspicious connections in financial transactions, cybersecurity, and compliance monitoring.

  * **Faster query processing**

    * Graph analytics fundamentally changes the way relationships are queried and analyzed. By eliminating the need for expensive join operations and enabling high-speed relationship traversal, graph databases significantly outperform relational databases for complex, connected data.




Dataiku features [Visual Graph](<visual-graph/index.html>), a set of capabilities to:

  * Build and edit graphs visually from datasets containing nodes and edges

  * Explore the built graphs visually

  * Perform Cypher queries on your graph, with an AI assistant for building the queries

  * Use the graph as a knowledge tool for [AI Agents](<../agents/index.html>)

---

## [graph/visual-graph/agent-tool]

# Graph Search Agent Tool

Once you have published a graph configuration from the [Editor](<editor.html>) webapp, the resulting graph can be leveraged as a dynamic knowledge base for Retrieval-Augmented Generation (RAG) applications using the **Graph Search** Agent Tool.

This tool integrates with Dataiku’s agent framework, enabling an LLM to translate natural language questions into Cypher queries. The queries are executed against your graph, and the results are returned to the agent to provide contextually accurate answers.

## Settings

  * **LLM connection** : Select the language model that will handle the natural language-to-Cypher conversion.

  * **Folder containing the graph database** : Choose the Dataiku Folder containing your published graph database.

  * **Database type** : Select the database type. There should be only one option available: **Built-in** or **Neo4j** depending on the type of graph database present in the folder.

  * **Neo4j connection** : If **Database type** is set to **Neo4j** , select the Neo4j connection to be used by the tool for querying the database.

  * **Cypher query timeout (seconds)** : Set a maximum execution time for queries. This acts as a crucial guardrail to prevent long-running queries from impacting performance.

  * **Tool instructions** : Provide a concise, high-level description of the graph’s content and purpose. This text gives the LLM additional context to improve query generation. You do not need to describe the schema itself, as it is automatically included in the context.

---

## [graph/visual-graph/connections]

# Supported connections

## Built-in

### Version used

  * [Version 0.11.3](<https://kuzudb.github.io/docs/>)




### Configuration

**Visual Graph** provides built-in support for Kùzu graph databases. When using Kùzu databases, **no additional connection configuration is required**.

## Neo4j

### Versions supported

  * [Neo4j Database Enterprise Edition 2025](<https://neo4j.com/developer/kb/neo4j-supported-versions/#_neo4j_database_enterprise_edition_2025>)

  * [Neo4j Database Enterprise Edition 5](<https://neo4j.com/developer/kb/neo4j-supported-versions/#_neo4j_database_enterprise_edition_5>)




### Configuration

To start using **Visual Graph** with Neo4j, you need to set up a Neo4j connection. This is done in the **Settings** tab of the **Visual Graph** plugin. You will need an administrator to configure it.

Neo4j connection settings
    

  * **URI of the Neo4j server**

  * **Username**

  * **Password**

  * **Read-only** : this option can be enabled to protect existing graph databases from modifications. It can be usefull in scenarios where you already have a production Neo4j database and want to explore it without the risk of accidental changes.

---

## [graph/visual-graph/editor]

# Visual Graph Editor

## Overview

Visual Graph **Editor** is a Dataiku webapp designed to streamline the workflow for data scientists working with graph data.

It facilitates the rapid exploration of data relationships and the iterative development of graph schemas to address specific analytical requirements.

Note

We recommend that you **get started** by following this [tutorial](<https://knowledge.dataiku.com/latest/ml/complex-data/graph-analytics/tutorial-visual-graph.html>).

**Key features**

  * **Schema management**

Create and manage node and edge groups.

  * **Visual exploration**

Visualize graphs with different layouts, expand neighbors to explore relationships, color nodes based on their property values…

  * **Interactive querying**

Write and execute Cypher queries with results rendered dynamically as a graph or in a tabular format.

  * **Query generator**

Generate complex queries using an LLM-powered assistant.

  * **Saved queries**

Save and manage frequently used Cypher queries for reuse.

  * **Data sampling**

Adjust the sampling of the source datasets to manage data volume during schema design and testing.

  * **Connection switching**

Test and switch between different graph database technology seamlessly.

  * **Save configuration**

Save graph configurations at key milestones.

  * **Publish Saved configuration**

Publish saved configurations to the project Flow to be used by other components of the plugin.




## Technical considerations

  * **Multi-directed property graph**

**Visual Graph** is designed to efficiently handle **multi-directed property graphs** , a versatile graph model where edges can have multiple directions between the same pair of nodes and carry detailed properties.

This flexibility allows for richer data representation, making it ideal for use cases such as social networks, knowledge graphs, and complex relational data.

Each node and edge in the graph can store key-value properties, enabling expressive queries and advanced analytics.

For a deeper understanding of **property graphs** , refer to the [Property Graph Model](<https://en.wikipedia.org/wiki/Graph_database#Property_graph_model>), and for more on **directed multigraphs** , see [Multigraphs and Directed Graphs](<https://en.wikipedia.org/wiki/Multigraph>).

  * **Data type inference**

**Visual Graph** automatically assigns data types to node and edge properties based on the data types of the corresponding columns in the tabular dataset.

This ensures consistency between the source data and the resulting graph structure.




Note

Ensuring the correct data types is crucial for predictable behavior in analytical operations such as aggregations. Proper type inference guarantees that numerical operations like summation, averaging, and sorting function correctly.

[Dataiku data type](<https://knowledge.dataiku.com/latest/import-data/exploration/concept-dataset-characteristics.html#storage-type>) | [Built-in property types](<https://kuzudb.github.io/docs/cypher/data-types/>) | [Neo4j property types](<https://neo4j.com/docs/cypher-manual/current/values-and-types/property-structural-constructed/>)  
---|---|---  
object | STRING | STRING  
string | STRING | STRING  
boolean | BOOLEAN | BOOLEAN  
date | TIMESTAMP | DATE  
tinyint | INT8 | INTEGER  
smallint | INT16 | INTEGER  
int | INT32 | INTEGER  
bigint | INT64 | INTEGER  
float | FLOAT | FLOAT  
double | DOUBLE | FLOAT  
  
  * **Scalability**

Kùzu is [pushing back the limit of scalability](<https://kuzudb.github.io/docs/#performance-and-scalability>) for embedded graph databases.

It should help you scale to hundreds of millions of nodes with the appropriate RAM resources. Beyond this threshold or if you have extensive graph algorithms workloads, we recommend using Neo4j and leverage their infrastructure and technology.

  * **Multi-user support**

All users with access to the webapp can see all the configured graphs and saved queries, including the ones created by other users. They can also freely update the configuration and saved queries. This will impact all the other users.

The only aspect that is not shared between users is the graph and table views. Users can explore and execute their queries and see the results independently from each other.

In case of concurrent update to the graph configuration, the users will be warned and we will prevent further update to the configuration to prevent loss of work.




## Settings

Note

Not configuring optional settings will simply disable the associated feature.

**Node/Edge sources**
    

  * **Source Datasets for Nodes & Edges (Optional)**: select one or multiple datasets that contain the source data for nodes and edges. The same dataset can be used for both nodes and edges. **If no datasets are selected, all the datasets of the current project will be available as sources when defining node and edge groups.**



**Neo4j connection**
    

  * **Neo4j server configuration (Optional)** : select a Neo4j connection to make it available in the Editor to test your graph configurations.



**AI assistant**
    

  * **LLM connection (Optional)** : select a LLM connection to enable the AI-powered Query generator. It helps users construct complex Cypher queries using natural language.

  * **LLM history dataset (Optional)** : select the dataset storing the history of all questions asked by users in the Query generator. It can be used for auditing or analysis.



**Graph publication**
    

  * **Saved configuration dataset (Optional)** : select or create the dataset that will contain your saved configurations. It is used as the source of saved configurations that can be published.

  * **Connection for publishing graphs (Optional)** : select the connection where the published graph databases will be stored. This connection is used by the Editor to automatically create a Dataiku Folder containing the published graphs.



**Advanced settings**
    

  * **Cypher query timeout (seconds)** : set a maximum execution time for queries run within the Editor. This acts as a guardrail to prevent resource-intensive queries from impacting performance.

  * **Log level** : configure the verbosity of the logs. Select **INFO** for standard operational logging (recommended for production) or **DEBUG** for detailed diagnostic information while troubleshooting issues.

  * **Internal storage dataset (Optional)** : select or create the dataset persisting the internal state of the webapp. Any type of underlying storage (FileSystem, S3, SQL,…) is supported. **If no dataset is selected, the internal state of the webapp will be persisted in the workload folder of the webapp.**




Warning

Using the workload folder of a webapp is only supported for webapps running on Dataiku backend.

## Visual Graph Editor Interface

### Landing Page

It lists all the created graphs. You can also create new graphs from there.

### Graph Page

#### Schema section

The **Schema** section on the left panel allows you to define the structure of your graph by creating node and edge groups.

##### Node group definition

  * **Select dataset** : Select the dataset containing the nodes information.

  * **Filter data** (Optional): If the source dataset contains records for multiple node types, use **Filter data** to specify the conditions for including a record in this specific group.

  * **Select column with unique identifiers** : Select the column that serves as the unique identifier (i.e., primary key) for each node.

  * **Select column with names** : Select the column whose values will be used as the display name for the nodes. You can re-use the identifier column if a dedicated name column is not available.

  * **Node properties** (Optional): Select any additional columns from the source dataset to be included as properties for each node.

  * **\+ Add additional definition** (Optional): If the data for a node group is distributed across multiple datasets, click **\+ Add additional definition**. This allows you to map another data source to the same node group by repeating the configuration process.

  * **Customize** (Optional): Customize the visual representation of nodes within the graph visualization, by setting a color, icon or size.




##### Edge group definition

  * **Select source node group** : Select the source (origin) node group for the edge.

  * **Select target node group** : Select the target (destination) node group for the edge.




Note

A node group can be both the source and target, which is useful for defining edges between nodes of the same type.

  * **Select dataset** : Select the dataset containing the edges information.

  * **Filter data** (Optional): If the source dataset contains records for multiple edge types, use **Filter data** button to specify the conditions for including a record in this specific group.

  * **Select column with source identifiers** : Select the column containing the unique identifiers (i.e., primary key) of the source nodes.

  * **Select column with target identifiers** : Select the column containing the unique identifiers (i.e., primary key) of the target nodes.

  * **Select additional properties** (Optional): Select any additional columns from the source dataset to be included as properties for each edge.

  * **\+ Add additional definition** (Optional): If the data for an edge group is distributed across multiple datasets, click **\+ Add additional definition**. This allows you to map another data source to the same edge group by repeating the configuration process.

  * **Customize** (Optional): Customize the visual representation of edges within the graph visualization, by setting a color or size.




#### Connection & Sampling section

**Connection**
    

  * Select the graph database connection to use. It can be either the built-in or Neo4j connection if you have configured a Neo4j connection in the webapp settings.




**Data sampling**

Note

To manage performance and ensure rapid iteration during schema development, the Editor builds the graph using a sample of your source data by default.

  * Sampling method




**Head** : Builds the graph using the first N rows of each source dataset. This is the default setting. **Random** : Builds the graph using N randomly selected rows from each source dataset.

  * Sample size




Adjust the number of rows (N) to be included from each dataset. Increasing this value provides a more comprehensive view of your data at the cost of longer processing times.

  * Disable sampling




Disable sampling entirely to build the graph using the full contents of your source datasets.

Warning

Disabling sampling is not recommended during the iterative design phase. Processing the entire content of source datasets can be time-consuming and may significantly slow down schema exploration and validation, especially with large data volumes.

#### Saved configurations section

This section allows you to manage different versions of your graph configuration. You can **create** and **publish** current configurations whenever you reach a significant milestone in your design process.

#### Graph exploration

  * **Interactive graph exploration**

Select any node or edge to inspect its details, including its identifier, name, properties and neighbors.

The **Neighbors** tab provides an overview of all directly connected nodes, displaying the total neighbor count and a breakdown by node group.

You can also selectively expand all neighbors or only those belonging to a specific group to explore the graph’s structure interactively.

  * **Graph layouts**

Switch between different layouts to optimize the visualization of your graph based on its structure.

Options include **gravity** (the default layout), **tree** for hierarchical data and **circle or square grid grouping** to cluster nodes per group.




Warning

**Tree** layout is computationally intensive. It is not recommended for large graphs.

  * **Conditional coloring**

Enhance the visual analysis of your graph by coloring nodes based on the values of a selected property.

For numerical values, a gradient color scale is applied. For categorical values, you can assign colors to a specific set of values.

It helps identify patterns, clusters, or outliers within the graph based on specific attributes.

  * **View controls and statistics**

The left panel provides controls for managing the graph visualization.

**Group visibility** : For each node and edge group, you can toggle its visibility on or off to show or hide all elements of that group in the current view.

**Graph statistics** : Key metrics are also displayed.

**View count** : Shows the total number of nodes and edges per group currently displayed as a result of the last executed query.

**Total count** : Shows the total number of nodes and edges in the underlying graph database, based on your sampling configuration.

  * **Cypher query execution**

The bottom panel contains a Cypher query editor with smart autocompletion that adapts to your defined schema.

Executing a query returns results in either a visual graph or a table format.

Aggregation queries results are available in the table format.

Any query you find useful can be saved to the **Saved queries** tab for reuse or sharing with team members.

  * **Query generator**

The **Query generator** tab allows you to ask a question in natural language.

It will generate a corresponding Cypher query designed to answer your question. You can then save the generated query or ask another question.

  * **Saved queries**

Save and manage frequently used Cypher queries for reuse.




## Next topics

**For Business Users** : Configure an [Explorer](<explorer.html>) webapp using this graph for interactive exploration and discovery.

**For Data Scientists** : Perform advanced analytics and feature engineering at scale using the [Execute Cypher](<recipes.html>) and [Compute PageRank](<recipes.html>) recipes.

**For AI applications** : Utilize the graph as a dynamic knowledge source for Retrieval-Augmented Generation (RAG) with the [Graph Search](<agent-tool.html>) Agent Tool.

---

## [graph/visual-graph/explorer]

# Visual Graph Explorer

## Overview

The Visual Graph **Explorer** is a read-only Dataiku webapp designed for business users and analysts to perform in-depth visual exploration of graphs managed in the Dataiku Flow.

Note

**Get started** by following this [Explorer webapp tutorial](<https://knowledge.dataiku.com/latest/ml/complex-data/graph-analytics/tutorial-visual-graph.html#explorer-s-journey-for-non-technical-users>).

**Key features**

  * **Schema overview**

View the graph’s structure, including all node and edge groups.

  * **Visual exploration**

Visualize graphs with different layouts, expand neighbors to explore relationships, color nodes based on their property values…

  * **Saved queries**

Execute a library of saved Cypher queries prepared by data scientists to answer common business questions.

  * **Ad hoc querying**

Write and run custom Cypher queries directly within the interface with schema-aware autocompletion.

  * **Query generator**

Use a built-in LLM assistant to generate Cypher queries from natural language questions.




Note

All schema design, data mapping and visual customization are performed beforehand in the [Visual Graph Editor](<editor.html>) webapp.

## Settings

**Graph databases**
    

  * **Folder(s) containing the graph databases** : select one or multiple Dataiku Folders containing graph databases.

  * **Neo4j connection** : if some selected folders represent a Neo4j graph database, configure the connection to be used by the webapp. Only one Neo4j connection can be used for all selected folders.




Note

To access Neo4j databases available through different connections, you will need to create separate Explorer webapps for each connection.

**AI assistant**
    

  * **LLM connection to use (Optional)** : select a LLM connection to enable the AI-powered Query generator. It helps users construct complex Cypher queries using natural language.

  * **LLM history dataset (Optional)** : select the dataset storing the history of all questions asked by users in the Query generator. It can be used for auditing or analysis.



**Advanced settings**
    

  * **Cypher query timeout (seconds)** : set a maximum execution time for queries run within the Explorer. This acts as a guardrail to prevent resource-intensive queries from impacting performance.

  * **Log level** : configure the verbosity of the logs. Select **INFO** for standard operational logging (recommended for production) or **DEBUG** for detailed diagnostic information while troubleshooting issues.




Note

Not configuring optional settings will simply disable the associated feature.

## Visual Graph Explorer Interface

### Landing Page

The landing page displays a list of all available graphs present in the selected graph database folders. Key information, such as the last build time, is shown for each graph to indicate data freshness.

### Graph Exploration Page

#### Left-side panel

##### Graph information

The top of the panel displays the graph’s name, its last build time, and the comment associated with its published configuration.

##### Groups

All node and edge groups are listed with their respective colors.

##### Graph statistics

For each group, two types of counts are shown:

  * **visible** : The number of nodes/edges currently displayed.

  * **total** : The total number of nodes/edges for that group in the entire graph database.




##### View controls

For each node and edge group, you can toggle its visibility on or off to show or hide all elements of that group in the current view.

#### Bottom panel

##### Saved queries tab

The Saved queries tab contains a list of pre-built queries. They can be executed to see the results rendered as a graph or a table.

Note

These queries are prepared by Data Scientists in the [Editor](<editor.html>) webapp.

##### New query tab

The **New query** tab provides a powerful editor with schema-aware autocompletion to write and execute your own Cypher queries.

##### Query generator tab

For complex queries, the **Query generator** tab allows you to ask a question in natural language. The AI assistant will translate your question into a Cypher query that you can then execute.

#### Central panel

In the **Graph** view, you can click on any node or edge to inspect its details, including its identifier, name, and properties.

When a node is selected, an additional **Neighbors** tab is available. It provides an overview of all directly connected nodes, displaying the total neighbor count and a breakdown by node group.

From here, you can selectively expand all neighbors or only those belonging to a specific group to explore the graph’s structure interactively.

##### Graph layouts

Switch between different layouts to optimize the visualization of your graph based on its structure.

Options include **gravity** (the default layout), **tree** for hierarchical data and **circle or square grid grouping** to cluster nodes per group.

Warning

**Tree** layout is computationally intensive. It is not recommended for large graphs.

##### Conditional coloring

Enhance the visual analysis of your graph by coloring nodes based on the values of a selected property.

For numerical values, a gradient color scale is applied. For categorical values, you can assign colors to a specific set of values.

It helps identify patterns, clusters, or outliers within the graph based on specific attributes.

---

## [graph/visual-graph/index]

# Visual Graph

**Visual Graph** is a complete framework for building graphs from your tabular datasets. It allows you to iteratively design and refine a graph schema, then makes the resulting graph accessible for deep exploration via a dedicated interface, large-scale processing with recipes, and as a knowledge source for AI agents.

Note

We recommend that you **get started** by following this [tutorial](<https://knowledge.dataiku.com/latest/ml/complex-data/graph-analytics/tutorial-visual-graph.html>).

---

## [graph/visual-graph/prerequisites]

# Prerequisites

**Visual Graph** is installed through the plugins interfaces. An administrator is required to install it.

  * This plugin has [Tier 2 support](<../../troubleshooting/support-tiers.html>).

  * It supports Dataiku 14+.

  * Python 3.9, 3.10 and 3.12 are supported.




## Infrastructure

  * The components of the plugin can run directly on DSS or in a container.

  * The datasets containing the graph configurations can be hosted on any type of dataset.

  * The built-in graph databases can be hosted on any type of managed folder.

---

## [graph/visual-graph/recipes]

# Recipes

## Execute Cypher recipe

The **Execute Cypher** recipe allows you to run a query against a graph database represented by a Dataiku Folder and save the tabular results to a dataset. This is useful for feature engineering, generating analytical reports, or exporting subsets of your graph.

### Input / Output

**Input**
    

  * Graph database folder: Dataiku Folder that contains your materialized graph database.



**Output**
    

  * Output dataset: Output dataset to store the results of the executed query.




### Settings

**Database type**

Select the database type. There should be only one option available: **Built-in** or **Neo4j** depending on the type of graph database present in the input folder.

**Neo4j connection**

If **Database type** is set to **Neo4j** , select the Neo4j connection to use for querying the database.

**Cypher query**

Enter the Cypher query to be executed.

## Compute PageRank recipe

The **Compute PageRank** recipe calculates the PageRank centrality for nodes in your graph. [This algorithm](<https://en.wikipedia.org/wiki/PageRank>) is a common technique for identifying the most influential nodes based on the graph’s structure.

To use this recipe, select **Compute PageRank** from the list of recipes under **Visual Graph**.

Warning

This recipe requires the [Graph Data Science library](<https://neo4j.com/docs/graph-data-science/current/>) to be installed on the Neo4j server.

### Input / Output

**Input**
    

  * Graph database folder: Dataiku Folder that contains your materialized graph database.



**Output**
    

  * Output dataset: Output dataset to store the results of PageRank algorithm.




### Settings

**Database type**

Select the database type. There should be only one option available: **Built-in** or **Neo4j** depending on the type of graph database present in the input folder.

**Neo4j connection**

If **Database type** is set to **Neo4j** , select the Neo4j connection to use for querying the database.

**Select node groups to rank**

Choose one or more node groups to include in the PageRank calculation. Only nodes from these groups will be ranked.

**Select edge groups used to rank nodes**

Select the edge groups that define the edges to be considered during the ranking process.

**Algorithm parameters**

>   * **Damping factor** : The probability at each step that a random walker will continue following an outgoing edge. A typical value is 0.85.
> 
>   * **Max iterations** : The maximum number of iterations the algorithm will run.
> 
>   * **Tolerance** : The minimum change in scores between iterations required for the algorithm to be considered converged.
> 
>   * **Normalize initial scores to sum to 1** : If enabled, the initial scores for all nodes will be normalized to sum to 1.
> 
> 


**Advanced parameters**

>   * **Batch Size** : Controls the number of results loaded into memory at a time. Adjust this value to manage memory usage when processing large graphs.
> 
> 


## Collect nodes recipe

**Collect nodes & edges** recipes can prepare your graph data for export to external systems like Neo4j.

Before using this recipe, you must first design your graph and create a Saved configuration within the Visual Graph Editor webapp.

### Input / Output

**Input**
    

  * Saved configurations dataset: Dataset containing the saved graph configuration you wish to use.

  * Datasets used as sources of the node group: Select all the original source datasets that are referenced for the target node group within your saved configuration.




Warning

You must explicitly provide all required source datasets as inputs to the recipe. Due to Dataiku’s security model, the recipe will fail if any source dataset defined in the configuration is not declared as an input.

**Output**
    

  * Output dataset: Dataset to store the collected nodes. The output will contain columns for the node identifier and all properties as defined in the saved configuration.




### Settings

**Select a saved configuration**

From the dropdown list, choose the specific Saved configuration you want to process.

**Select a node group**

Select the node group whose members you want to collect into the output dataset.

## Collect edges recipe

The configuration is similar to the Collect nodes recipe.