# Dataiku Docs — ai-assistants

## [ai-assistants/ai-explain]

# AI Explain

AI Explain can generate explanations of project Flows and Code Recipes.

## Generating project Flow explanations

  * On the Flow screen open the **Flow Actions** menu

  * Select **Explain Flow**




### Generating Flow zone explanations

  * On the Flow screen select a zone

  * Select the **Actions** tab in the right-hand side panel

  * Click **Explain**




Note

You can generate explanations of project Flows which do not use zones or you can generate explanations of Flow zones. It is currently not possible to generate explanations of Flows with zones.

### Explanation options

It is possible to adjust the generated explanations using these options:

  * Language: the natural language of the explanation

  * Purpose: the intended audience of the explanation

  * Length: the verbosity of the explanation




If editing a project or a Flow zone long description you can also choose to let the AI Explain feature generate it and then save it.

Note

The explanations are AI-generated and as such are subject to errors.

## Generating code explanations

  * Select the **Explain** tab in the left-hand side pane on the code recipe screen

  * Click **Explain**




You can choose to generate an explanation of a code selection only by making a code selection first.

### Explanation options

After clicking **Settings** it is possible to adjust the generated explanations using these options:

  * Language: the natural language of the explanation

  * Purpose: the intended audience of the explanation

  * Length: the verbosity of the explanation




Note

The explanations are AI-generated and as such are subject to errors.

---

## [ai-assistants/ai-search]

# AI Search

AI Search allows you to discover relevant datasets and indexed tables across the Data Catalog using natural language queries.

## Accessing AI Search

You can access the AI Search interface from two main entry points:

  * **From the Homepage** : Navigate to **Data Catalog** > **AI Search**.

  * **Within a Project** : Navigate to **Data Catalog** > **AI Search**.




## Searching for datasets & indexed tables

To begin a search, enter a natural language query describing the data you are looking for (e.g., “Find datasets related to financial records”).

The AI Search engine will:

  * Generate a **global explanation** of why the identified datasets and indexed tables are meaningful in the context of your query.

  * Display a list of up to **5 relevant datasets/indexed tables** associated with your request.




### Refining a search

You can refine your results by submitting follow-up questions or instructions. This allows you to keep the context of the previous questions without starting a new search (e.g., “Only show results as part of project X”, “Filter for datasets with the tag ‘finance’”).

The engine will then regenerate the global explanation and update the list of datasets to match your refined criteria.

## Interacting with results

For each dataset and indexed table returned in the search results, you can open the **right-hand panel** to perform direct actions or use the buttons from the result tile:

  * **Preview** : View a sample of the dataset’s data.

  * **Request share** : Request access to the dataset if you do not already have the necessary permission.

  * **Use** : Use the dataset directly within a project.




Note

The explanations are AI-generated and, as such, are subject to errors.

---

## [ai-assistants/claude-code]

# Claude Code coding agent

Claude Code is a coding agent based on a TUI (Terminal UI) and also features a Visual Studio Code integration.

The integration of Claude Code in Dataiku is done through Code Studios. It can fully integrate with the LLM Mesh, so that all queries performed by Claude Code can go through the LLM Mesh for full control and cost tracing.

## Setup (admin)

The capability is provided by the “Claude Code for Code Studios” plugin that you need to install.

Then, you need to define a Code Studio template, adding the “Claude Code” block.

The Claude Code block can either:

  * Route queries through the Dataiku LLM Mesh, allowing you to select which LLM to use.

  * Use your existing Claude subscription to connect directly to Anthropic and pay for usage through your Claude subscription

  * Use the credentials of an Anthropic connection or enter an Anthropic API key.




## Usage

Once you have started your Code Studio, you can either:

  * If using VS Code, click the Claude icon in the left bar or the top nav bar

  * In all Code Studios, simply open a terminal and run “claude”




In LLM Mesh mode, you can immediately start working with the Agent

If you use your own Claude subscription, you will need to login first

## Recommendations

  * Claude Code requires a tools-aware LLM

  * Claude Code will work much better with frontier models such as Anthropic Claude 4.5 or OpenAI GPT 5. Local models usually offer significantly reduced performance

---

## [ai-assistants/code-assistant]

# Dataiku AI Code Assistant

Dataiku AI Code Assistant provides enhancements to the coding experience in Jupyter Notebooks and Visual Studio Code ([in Code Studio](<../code-studios/code-studio-ides/vs-code.html>)).

## Setup

In order to start using the AI Code Assistant, the feature needs to be enabled by an admin. It also requires a connection to an LLM.

  * Go to Administration > Settings > AI Assistants

  * Make sure **Enable AI Code Assistant** is checked

  * Select which LLM connection to use as default

  * Click **Save**




## Usage in Jupyter notebooks

There is only one step needed to enable AI Code Assistant in Jupyter notebooks:

  * Copy the following code in a cell and execute it:
        
        %load_ext ai_code_assistant
        




Once the extension is loaded, several magic commands are available to interact with the assistant.

### Ask for help

Use `%aiask` or `%%aiask` to ask a question. The response is displayed in the output of the cell.
    
    
    %%aiask
    How do I filter a pandas dataframe?
    

Use `%aiwrite` or `%%aiwrite` to ask for code generation. The assistant generates a new cell with the requested code.
    
    
    %%aiwrite
    Load the dataset.csv file and display the first 5 rows
    

**Options for** `aiask` **and** `aiwrite`:

  * `-c`, `--continue`: Continue the previous conversation.

  * `-np`, `--no-previous`: Do not pass the last run cell as context.

  * `-df`, `--dataframes`: Make the assistant aware of existing Pandas Dataframes (names and columns).

  * `--override-llm ID`: Override the LLM connection ID (advanced).

  * `--temperature FLOAT`: Set the LLM temperature (advanced).

  * `--max-tokens INT`: Set the LLM max output tokens (advanced).




### Explain code

Use `%aiexplain` or `%%aiexplain` to ask the assistant to explain the code in the cell.
    
    
    %%aiexplain
    df = df[df['value'] > 10]
    

**Options for** `aiexplain`:

  * `-t`, `--terse`: Make the explanation shorter.

  * `-v`, `--verbose`: Make the explanation more detailed.

  * `--override-llm ID`: Override the LLM connection ID (advanced).

  * `--temperature FLOAT`: Set the LLM temperature (advanced).

  * `--max-tokens INT`: Set the LLM max output tokens (advanced).




## Usage in Visual Studio Code

Note

Dataiku AI Code Assistant has very simple capabilities. In Code Studios, you will get more AI-assisted coding through the integration with:

  * [OpenAI Codex](<codex.html>)

  * [OpenCode](<opencode.html>)

  * [GitHub Copilot](<github-copilot.html>)




The AI Code Assistant extension requires a secured context (HTTPS) to be functional. Using a self-signed certificate may prevent the feature from being fully functional on all browsers.

To use AI Code Assistant in Visual Studio Code, an admin must enable it in the [Code Studio Template](<../code-studios/code-studio-templates.html>):

  * Ensure the **Install AI Code Assistant** option is enabled in the Visual Code Studio block (it is enabled by default)

  * Rebuild the template and restart the Code Studio to apply changes




### Features

You will find a new side panel in VSCode to chat with the assistant.

You will also have some new actions in the right-click menu when launched from inside a file (some are only available once you have made a selection in the file).

### Settings

The extension settings can be configured in VSCode (File > Preferences > Settings, search for “Code Assistant”):

  * **CodeAssistant.llmId** : The LLM connection ID to use. Leave empty to use the instance default.

  * **CodeAssistant.temperature** : The temperature for the LLM (between 0 and 1). Default is 0.3.

  * **CodeAssistant.maxTokens** : The maximum number of tokens returned by each request. Default is 800.

---

## [ai-assistants/codex]

# OpenAI Codex AI coding agent

Codex is a coding agent based on a TUI (Terminal UI) and also features a Visual Studio Code integration.

The integration of Codex in Dataiku is done through Code Studios. It can fully integrate with the LLM Mesh, so that all queries performed by Codex can go through the LLM Mesh for full control and cost tracing.

## Setup (admin)

The capability is provided by the “Codex for Code Studios” plugin that you need to install.

Then, you need to define a Code Studio template, adding the “Codex” block

You will need to configure which LLM to use. You can also choose “External authentication” to let users use their own ChatGPT subscription instead. Note that in that mode, only device authentication is supported. Your ChatGPT workspace admin needs to enable it.

## Usage

Once you have started your Code Studio, you can either:

  * If using VS Code, click the Codex icon in the left bar

  * If using VS Code, click the Codex icon in the top nav bar

  * In all Code Studios, simply open a terminal and run “codex”




In LLM Mesh mode, you can immediately start working with the Agent

If you use your own ChatGPT subscription, you need to first login:

  * Open a terminal

  * Run codex login –device-auth

  * Follow the instructions




## Limitations

  * LLM Mesh mode cannot use Codex versions above 0.79.0

  * In External authentication mode, only device authentication is supported. Your ChatGPT workspace admin needs to enable it.

---

## [ai-assistants/flow-assistant]

# Flow Assistant

## Create a flow

Flow Assistant is accessible from both the flow view and the explore view of a dataset. To use it, select one or multiple datasets from the flow view, right click to open the contextual menu, and then click on “Add to Flow Assistant context”. You can also find a link to the assistant labeled “Flow Assistant” from the right-hand panel when a dataset is selected.

In the chat that opens, you can describe how you want to process or enrich the selected dataset(s).

Note

You can manage the context sent to the AI model by adding or removing datasets from it so that it knows which datasets it must operate on.

## Supported recipes

The Flow Assistant can only generate Visual recipes. The supported recipes are:

  * Distinct

  * Group

  * Join

  * Pivot

  * Prepare

  * Sample/Filter

  * Sort

  * Split

  * Stack

  * Top N

  * Windows

---

## [ai-assistants/generate-metadata]

# Generate Metadata

Generate Metadata is an assistant that allows you to quickly understand a dataset’s content. The assistant automatically generates for your dataset:

  * A short description

  * A long description

  * A description for each column




## Usage

When selecting a dataset, the feature is accessible from the right hand panel. Use the button “Generate Metadata” from the details or the schema tab.

By default, the assistant generates a short description, a long description, and a description for each column in english.

You can also choose another language from the top left dropdown menu. Available languages are the following:

  * English

  * Dutch

  * French

  * German

  * Japanese

  * Portuguese

  * Spanish




For each description, you can approve or edit the generated descriptions. At the end clicking “Approve and use as description” will save the descriptions that you have approved.

---

## [ai-assistants/generate-steps]

# Generate Steps

Generate Steps is an assistant that allows you to directly ask in natural language what you want to do in a Prepare recipe. The assistant then automatically generates your prepare steps.

See also

For more information, see also [Generating steps with AI](<https://knowledge.dataiku.com/latest/prepare-transform-data/prepare/concept-prepare-recipe.html#generating-steps-with-ai>) in the Knowledge Base.

Note: Generate Steps was previously called AI Prepare

---

## [ai-assistants/github-copilot]

# Github Copilot

GitHub Copilot is available in Code Studios, in Visual Studio Code.

Github Copilot uses your existing Github subscription.

The integration of Github Copilot in Code Studios uses the “native” integration of Copilot within Visual Studio Code. As of early 2026, this “native” integration is still being refined, and there are still many limitations.

## Setup (admin)

In order to allow users to use Github Copilot, the Github Copilot option needs to be enabled in the “Visual Studio Code” block of the Code Studio template

## Setup (user)

To enable Copilot, click this icon:

You will be prompted to authenticate to your Github subscription. Follow the steps.

You may see some errors about “inability to enable chat”. Ignore them.

The Chat panel becomes available in the right side of your Code Studio and you can start chatting with the agent, which can work with the whole Code Studio.

## Limitations

As of early 2026, inline suggestions (tab-autocomplete) are not available in the “native” integration of Copilot within Visual Studio Code. The “Configure inline suggestions” button of the Copilot menu does nothing.

---

## [ai-assistants/index]

# AI Assistants

Dataiku includes multiple AI Assistants designed to improve users productivity and help them discover the capabilities of the platform

Note

AI Assistants should not be confused with the [LLM Mesh](<../generative-ai/index.html>)

  * The LLM Mesh is about empowering Dataiku users to leverage Generative AI for their use cases

  * AI Assistants are AI capabilities embedded within Dataiku itself to improve user productivity

---

## [ai-assistants/opencode]

# OpenCode AI coding agent

OpenCode is an open-source coding agent based on a TUI (Terminal UI) and also features a Visual Studio Code integration. It is a competitor to OpenAI Codex and Anthropic Claude Code, while letting you choose between multiple LLMs.

The integration of OpenCode in Dataiku is done through Code Studios. It fully integrates with the LLM Mesh, so that all queries performed by OpenCode can go through the LLM Mesh for full control and cost tracing.

## Setup (admin)

The capability is provided by the “OpenCode for Code Studios” plugin that you need to install.

Then, you need to define a Code Studio template, adding the “OpenCode block”.

You will need to configure which LLM to use. You can allow a single LLM, multiple LLMs, all LLMs of a connection, or all LLM of a connection type.

You can also configure OpenCode to not use the LLM Mesh and instead rely on users authenticating directly to 3rd party LLM providers.

## Usage

Once you have started your Code Studio, simply open a terminal and run “opencode”. You can immediately start working with the Agent.

For more usage instructions, refer to the developer guide tutorial: [Using a Code Assistant in VS Code with the OpenCode block](<https://developer.dataiku.com/latest/tutorials/devtools/code-studio/using-code-assistant-opencode/index.html>)

---

## [ai-assistants/setup]

# Overview and setup

Dataiku provides multiple AI Assistants to help users with various tasks across the Dataiku platform.

Some are entirely under customer control. They leverage LLM connections that you configure and control through LLM Mesh. Your code and metadata are not sent to Dataiku, but may be sent to third-party services according to the LLM you select.

Other assistants require an AI Server: either Dataiku’s cloud-based AI Services (automatically available), or your own AI Server hosted in DSS using your LLM connections through LLM Mesh.

## Assistants using an AI Server

  * [Flow Assistant](<flow-assistant.html>) allows users to use natural language to build data pipelines in the Flow.

  * [SQL Assistant](<sql-assistant.html>) is a versatile SQL companion that allows you to generate, refine, and troubleshoot your SQL queries in SQL notebooks.

  * [AI Search](<ai-search.html>) allows you to find and discover relevant data in the Data Catalog.

  * [Generate Metadata](<generate-metadata.html>) automatically generates descriptions for your datasets and their columns. Since these descriptions are primarily based on sample values, we recommend enabling sample values to improve the accuracy and usefulness of the feature.

  * [Stories AI](<stories-ai.html>) allows you to generate presentations, slides, charts, and images inside Dataiku Stories.

  * [AI Explain](<ai-explain.html>) provides explanations for what your Flow or code does, allowing you to better understand and document your data pipelines and codebases.

  * [Generate Steps](<generate-steps.html>) allows users to use natural language to build steps in a Prepare recipe.




### Using Dataiku’s AI Services

By default, these assistants use Dataiku’s own AI Server, hosted and managed by Dataiku.

They require that the Dataiku DSS server be connected to Internet, in order to talk to our AI Services.

Using the Dataiku AI Services is subject to acceptance of our Dataiku AI Services Terms of Use, which are linked from the “AI Assistants” page in **Admin** > **Settings**.

Once you have accepted the Terms of Use, you can turn on AI Services

### Running your own locally-running AI Server, hosted by DSS

If you cannot use Dataiku’s AI Services, you also have the option of running your self the AI Server, hosted in your own DSS, and using your own LLM Mesh connections.

Please get in touch with your Dataiku Customer Representative to discuss access to this capability.

## Assistants always under customer control

These assistants never go through Dataiku’s AI Services. They may either go through the LLM Mesh, or directly connect to 3rd-party services with whom you have agreements.

  * [OpenAI Codex](<codex.html>) is a high-end coding agent, integrated in Code Studios

  * [OpenCode](<opencode.html>) is a full-featured open-source coding agent, integrated in Code Studios

  * [GitHub Copilot](<github-copilot.html>) is a powerful coding agent, integrated in Visual Studio Code in Code Studios

  * [AI Code Assistant](<code-assistant.html>) provides simple Python code generation and explanations in Jupyter Notebooks and in Visual Studio Code in Code Studios

---

## [ai-assistants/sql-assistant]

# SQL Assistant

The SQL Assistant helps users with SQL writing in both SQL recipes and SQL notebooks.

The SQL Assistant has awareness of the tables in your database and database type in order to generate accurate SQL code across all databases.

Powered by a Large Language Model (LLM), this tool analyzes dataset schemas to craft queries tailored to your needs. Each query is accompanied by a detailed reasoning section explaining how queries are constructed.

## Usage in recipes

To use this feature, you must have access to the input datasets SQL connection, and WRITE permissions to the Dataiku project where the SQL recipe resides. You can then use AI to generate SQL queries, review the generated query, and import it to your code editor, where you can modify or execute it as needed.

SQL Assistant is only supported on “regular” SQL recipes, not on Impala, Hive or Spark SparkSQL

## Usage in notebooks

To use this feature, you must have WRITE permissions on the project where the SQL notebook resides. You can ask the SQL Assistant about general SQL questions but also generate queries from specified tables, refine or debug existing queries, request explanations, add comments… You can give assistant access to the tables by adding them into the context tables list. Once you add the table to the context tables, the assistant then has access to the table schema. After you’re satisfied with the generated query, you can copy the SQL, add it to the end of a query in the editor, or replace your current query in the editor and run it.

Each query has its independent chat. Each user has its own chat history.

---

## [ai-assistants/stories-ai]

# Stories AI

[Dataiku Stories](<../stories/index.html>) includes multiple AI Assistants to help you build the best stories from your data, helping users get to grips with the tool by using text and prompts ranging from the simplest to the most specific ones.

## Usage

See [Introduction to Dataiku Stories](<../stories/introduction.html>)