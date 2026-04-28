# Dataiku Docs — semantic-models

## [semantic-models/create-and-manage]

# Creating and managing Semantic Models

The Semantic Model editor is provided by the Semantic Models Lab plugin, which must be installed from the plugin store by an administrator

## Creating a Semantic Model

Semantic Models are created within any Dataiku project in the `Generative AI` tab > `Semantic Models`.

It is a best practice to build semantic models on top of golden datasets.

Semantic models have a name and versions (one of which is active).

### Entities

Entities are tables linked to business concepts and filters.

They are characterized by:

  * A dataset from a specific project

  * A name and a description

  * A primary key

  * Attributes

>     * These are mapped to columns from the dataset, come with a SQL expression (usually the column name), a type and a description
> 
>     * Writing custom SQL expressions for attributes is useful when the raw data in your database isn’t in the exact format you need for your semantic model.
> 
>     * Attributes can be resolvable and have sample values
>
>>       * Resolvable attributes are used in a term resolution step, where the user query terms are matched to values from these attributes to account for typo corrections or schema errors
>> 
>>       * For each attribute, you can add a number of sample values (either by automatically fetching them or adding them manually)




  * Metrics

>     * Business metrics are aggregations of attributes that can come from various entities
> 
>     * They come with a name, a formal SQL expression, a description and LLM instructions.




  * Filters

>     * They can be used to define filters applied to columns
> 
>     * They come with a name, a formal SQL expression, a description and LLM instructions.




Entities can either be added manually or automatically generated using an LLM.

When using an LLM to automatically generate entities, you can specify instructions (e.g. to provide the number of entities to create from the dataset selected, how to group attributes, information on filters/metrics to create or relationships between these entities).

Automatically generating an entity takes you 80% of the way, you still need to verify and test the entity before exposing it to end-users.

### Relationships

Relationships between entities define which keys to use to join two entities. These can both be simple and complex joins.

### Glossary

The glossary is a collection of business specific terms. Each term comes with a name, a description and synonyms. These terms can be added manually, or extracted from business documents (i.e. PDFs, PPTs, DOCX). Once terms have been added to the glossary, the `Used` tab is used to define which terms are used in the semantic model and out of these which should be linked to entities / attributes / metrics / filters.

### Golden Queries

Golden Queries are pre-recorded user questions and expected SQL outcomes. Providing Golden queries improves the quality of the [Semantic Model Query Tool](<semantic-model-query-tool.html>)’s output.

Golden queries have names, the user question and expected SQL outcome.

These can be used for frequently asked questions or to provide guidance for complex queries.

These can be added from the Golden Queries tab or directly from the Playground.

### Instructions

Instructions can be added, to help guide the LLM in generating the SQL - e.g. to provide specific instructions on how to deal with date attributes.

## Playground

While creating and refining your semantic model, you can test it out in the Playground. The Playground allows you to see how your Semantic Model responds to business questions.

The Playground uses the [Semantic Model Query Tool](<semantic-model-query-tool.html>) to generate and execute the SQL.

The Playground shows the LLM answer, the SQL queries executed, the records retrieved by the execution of the queries. It also shows value corrections that have been performed, as well as usage of glossary terms.

The main value of the Playground is testing out questions you are expecting end-users to ask, and using the output of the tool to refine the semantic model.

## Other settings

The **Indexing** tab is where you configure and run the process that allows Dataiku to perform terms resolution and fetch sample values.

You need to specify an **Embedding LLM** to select the specific embedding model used for semantic resolution of attributes.

Once your settings are configured, you must manually trigger the indexing process to update the semantic model’s knowledge of your data.

## Security and Permissions

  * **Project Access** : Users must have Read project content permissions on the project containing the Semantic Model to use it.

  * **Data Security** : Semantic Models respect underlying Dataiku dataset permissions. If a user does not have access to the underlying connection or dataset, the Semantic Search tool will fail for that user.




## YAML Specification

The syntax of a semantic model YAML specification is:
    
    
        {
    // Top-level semantic model metadata
    "id": "<string>",                 // Unique identifier for the semantic model
    "projectKey": "<string>",         // Dataiku project key
    "name": "<string>",               // Name of the semantic model
    "activeVersionId": "<string>",    // The ID of the currently active version (e.g., "v1")
    
    // Array containing the versions of the semantic model
    "versions": [
        {
        "id": "<string>",             // Version ID
        "description": "<string>",
        "created": {
            "on": "<timestamp string>",
            "by": "<string>"
        },
    
        "entities": [
            {
            "name": "<string>",             // Logical name of entity
            "description": "<string>",      // Description of the entity
            "tags": [ "<string>" ],
            "type": "<string>",             // Usually "DATASET"
            "datasetRef": "<string>",       // Reference to the Dataiku dataset
    
            // Dimension columns in the logical table
            "attributes": [
                {
                "name": "<string>",         // Logical name of the column
                "description": "<string>",  // Optional: Column description
                "dssType": "<string>",      // Data type (e.g., "string", "double")
                "type": "<string>",         // Usually "COLUMN"
                "column": "<string>",       // The physical column name in the base dataset
                "distinctValuesHandlingMode": "<MANUAL | NONE | AUTO_INDEX>",
                "manualValues": [ "<string>" ], // List of values if handled manually
                "indexDistinctValues": "<boolean>",
                "resolveInUserRequests": "<boolean>",
                "sqlGenerationConfig": {
                    "autoValuesLimit": "<integer>" // Optional: limit for auto-indexed values
                }
                }
                // ... more attributes
            ],
    
            // Metrics scoped to the logical table
            "metrics": [
                {
                "name": "<string>",
                "description": "<string>",
                "pseudoSQLExpression": "<SQL expression>", // e.g., "COUNT(customer_id)"
                "llmInstructions": "<string>",             // Optional: Custom instructions for the LLM
                "created": {}
                }
                // ... more metrics
            ],
    
            // Commonly used filters over the logical table
            "filters": [
                {
                "name": "<string>",
                "description": "<string>",
                "pseudoSQLExpression": "<SQL expression>",
                "llmInstructions": "<string>",             // Optional: Custom instructions for the LLM
                "created": {}
                }
                // ... more filters
            ],
    
            // Primary key definition for the entity
            "primaryKey": {
                "attributes": [ "<string>" ]  // Array of attribute names that make up the PK
            },
            "foreignKeys": [ "<object>" ]   // Array of foreign key definitions, if any
            }
            // ... more entities
        ],
    
        // View-level concepts: Relationships between logical tables
        "relationships": [
            {
            "firstEntity": "<string>",      // Left table
            "secondEntity": "<string>",     // Right table
            "pseudoSQLExpression": "<SQL join expression>" // e.g., "table_a.id = table_b.a_id"
            }
        ],
    
        // Additional context concepts: Verified queries and example questions
        "goldenQueries": [
            {
            "name": "<string>",           // Descriptive name of the query
            "question": "<string>",       // The natural language question
            "generatedSql": "<string>",   // The verified SQL query answering the question
            "created": {
                "on": "<timestamp string>"
            }
            }
        ],
    
        // Business glossary for LLM context mapping
        "glossaryTerms": [
            {
            "id": "<string>",             // UUID for the term
            "term": "<string>",           // The business term itself
            "description": "<string>",    // Definition or business logic
            "source": "<MANUAL | EXTRACTED>",
            "userModified": "<boolean>",
            "created": {
                "on": "<timestamp string>",
                "by": "<string>"            // Optional
            },
            "modified": {                 // Optional
                "on": "<timestamp string>"
            },
            "synonyms": [ "<string>" ],   // Alternative names for the term
            "privateEditorData": {}
            }
        ],
    
        // Links tying glossary terms to specific entities or attributes
        "glossaryBindings": [
            {
            "termId": "<string>",               // References glossaryTerms.id
            "targetEntityClass": "<string>",    // Target entity name
            "targetName": "<string>",           // Target attribute name (Only if targetType is ATTRIBUTE)
            "targetType": "<ATTRIBUTE | ENTITY_CLASS>"
            }
        ],
    
        // Global indexing settings for the LLM search service
        "indexingSettings": {
            "maxDistinctValuesPerAttribute": "<integer>",
            "maxScannedRowsForSQLDatasets": "<integer>",
            "maxScannedRowsForNonSQLDatasets": "<integer>"
        },
    
        "privateEditorData": {
            "lastSavedAt": "<timestamp string>"
        },
    
        // Global instructions for LLM SQL generation
        "sqlGenerationConfig": {
            "instructions": "<string>",          // General prompt instructions for the model
            "vocabularyTermIds": [ "<string>" ]  // Relevant glossary term IDs to inject globally
        }
        }
    ],
    
    // Dataiku administrative metadata
    "versionTag": {
        "versionNumber": "<integer>",
        "lastModifiedBy": {
        "login": "<string>"
        },
        "lastModifiedOn": "<timestamp integer>"
    },
    "creationTag": {
        "versionNumber": "<integer>",
        "lastModifiedBy": {
        "login": "<string>"
        },
        "lastModifiedOn": "<timestamp integer>"
    },
    "tags": [ "<string>" ],
    "customFields": {},
    "checklists": {
        "checklists": [ "<object>" ]
    }
    }

---

## [semantic-models/dataset-sql-query-tool]

# Dataset SQL Query Tool

The Dataset SQL Query tool is an [Agent tool](<../agents/tools/index.html>) that translates natural language queries into SQL queries, and provides answers based on the execution of the SQL queries on the underlying datasets.

## Configuration

Once you’ve instantiated a Dataset SQL Query tool, you need to configure the following:

  * **Dataset Selection:** Select the project containing the dataset to query and the SQL dataset.

  * **LLM Configuration:**
    
    * `LLM`:Select the LLM to use for the agent reasoning and SQL generation.

    * `Embedding LLM` (optional): Select the embedding LLM for semantic value matching.

    * `Agent mode`: Enable to use the multi-step agentic workflow. Disable to use the faster linear SQL generation pipeline.

  * **Query Limits:** Set limits on the number of rows returned and the maximum agent loop iterations.

  * **Security:** Define whether the tool should be executed as user calling the tool or the end-user (only relevant if these two are distincts).

  * **Description for LLM (optional):** General instructions for usage of this tool (e.g. a description of the dataset, its attributes, associated metrics…)




## Input and output

The tool takes a natural language query as input, and returns a synthesized answer, artifacts of the SQL record(s) retrieved and the associated SQL query generated and executed.

## Internal details

The Dataset SQL Query tool takes a user’s natural language question and leverages the configured LLM to translate it into a valid SQL query.

When the tool is first instantiated it reads the target dataset to generate a “semantic model spec” (a structured representation of the dataset’s schema, columns, and metadata) and detects the specific SQL dialect of the underlying database.

When the agent mode is disabled, the tool processes user queries in a straight-through pipeline:

  * **Security Context Resolution:** It determines _who_ is executing the query to ensure the query runs with the appropriate data access permissions.

  * **Semantic Value Matching (Optional):** If an `embedding llm` was configured, the tool map terms in the user’s question to the exact categorical values stored in the database (e.g., matching the word “NYC” in the prompt to “New York City” in the dataset).

  * **SQL Generation:** The core LLM uses the natural language question, the semantic model spec, and the identified SQL dialect to generate a SQL query.

  * **Validation & Execution** The generated SQL query is validated and executed.

  * **Payload:** It returns a structured response back to the caller containing:

    1. A synthesized natural language answer explaining the records returned.

    2. The actual SQL query that was generated and executed.

    3. The resulting data records (artifacts) retrieved from the database.

---

## [semantic-models/index]

# Semantic Models

**Semantic Models** provide a foundation of business context between structured datasets and the LLMs that query them. They help in translating natural language queries into precise, executable SQL.

To create a semantic model, you define **Entities** (conceptually mapping to datasets/tables) and **Attributes** (conceptually mapping to columns), how they **relate** to each other, as well as **business metrics** (data aggregations) on them.

Semantic models add business meaning to physical data, which provides a consistent business view of your data, and enhance decision making, notably for AI Agents.

For more information, see also the following article in the [Knowledge Base.](<https://knowledge.dataiku.com/latest/genai/agents/concept-semantic-models-lab.html>)

**Key benefits of DSS Semantic models include:**

  * **Agnostic Data Connectivity** : Users can create semantic models on top of SQL datasets from various data sources

  * **Structured Business Logic** : Structure your company-specific semantic concepts through the configuration of entities, attributes, metrics, filters, and relationships.

  * **LLM assisted Model Generation** : Accelerate the creation of semantic models through LLM-assisted generation leveraging existing metadata and documentation.

  * **Validation Playground** : Test, refine, and verify semantic models built.

  * **Lifecycle Management** : Semantic models support versioning, allowing teams to maintain and iterate on different versions while designating a specific one as active.

  * **Agentic Tool for Semantic Model Query** : Dataiku Agents can leverage the semantic of semantic models to perform high-quality queries in the underlying data, for highly performant agents

---

## [semantic-models/semantic-model-query-tool]

# Semantic Model Query Tool

The Semantic Model Query tool is an [Agent tool](<../agents/tools/index.html>) leveraging a Semantic Model to translate natural language queries into SQL queries, and providing answers based on the execution of the SQL queries.

## Configuration

Once you’ve instantiated a Semantic Model Query tool, you need to configure the following parameters:

  * Which Semantic Model to use

  * The LLM to use for the agent reasoning and SQL generation

  * Optionally, an embedding LLM for semantic value matching

  * **Semantic Model Selection:** Select the project containing the semantic model to query, the semantic model and its version.

  * **LLM Configuration:**
    
    * `LLM`:Select the LLM to use for the agent reasoning and SQL generation.

    * `Embedding LLM` (optional): Select the embedding LLM for semantic value matching.

    * `Agent mode`: Enable to use the multi-step agentic workflow, recommended for large semantic models. Disable to use the faster linear SQL generation pipeline.

  * **SQL Generation Parameters:** By default uses the parameters defined in your semantic models. If `configure parameters` is selected, set limits on the number of rows returned and the maximum agent loop iterations.

  * **Security:** Define whether the tool should be executed as user calling the tool or the end-user (only relevant if these two are distinct).

  * **Description for LLM (optional):** General instructions for usage of this tool (e.g. a description of the dataset, its attributes, associated metrics…)




## Input and output

The tool takes a natural language query as input, and returns a synthesized answer, artifacts of the SQL record(s) retrieved and the associated SQL query generated and executed.

## Internal details

When using the agent mode, the Semantic Model Query tool is itself an agent, that uses multiple tools under the hood, in order to:

  * Explore the schema of datasets (get the list of entities, their attributes, the relationships)

  * Resolve values (i.e. to match user query terms with resolvable attributes to correct typos and find exact values in the data.)

  * Perform SQL operations (generate, validate and execute SQL). Importantly, it validates that SQL queries only read data (no INSERT/UPDATE/DELETE).




This means that the tool can fetch context dynamically (i.e. all the context in the semantic model isn’t provided in bulk to generate SQL queries, only the minimum context is fetched), making the tool scalable with datasets with a high number of attributes or big semantic models.

The Semantic Model Query Tool follows this general workflow:

  1. **Planning & Metadata Retrieval**: The tool starts by exploring the entities, their attributes and relationships to identify information relevant to the user’s query and ensure entities are joined correctly.

  2. **Value Resolution & Term Extraction**: Maps terms in the user query to the semantic model, to fix typos, ensure values match the database exactly, use business metrics and clarify jargon/acronyms.

  3. **SQL Generation** : Generates SQL candidates based on the metadata gathered, relationships and resolved values.

  4. **Validation & Execution**: SQL queries are checked for syntax and security (read-only) before being executed. If the query execution fails, analyzes the error logs and loops back to refine the SQL (up to five times). Synthesizes the data results back into a concise natural language response for the user.