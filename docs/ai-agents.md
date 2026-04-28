# Dataiku Docs — ai-agents

## [agents/a2a]

# A2A Integration

Dataiku DSS can expose agents to A2A clients through a dedicated A2A endpoint.

## Endpoint

All agents are exposed at:

`http://dss_host:dss_port/dip/publicapi/projects/PROJECT_KEY/agents/AGENT_ID/a2a`

Where `PROJECT_KEY` and `AGENT_ID` identify the agent location in DSS.

## Authentication

Authentication is required and is done via API keys. Use HTTP Bearer Token Authentication and pass the API key as the token. API key permissions determine which agents can be accessed.

## Protocol and discovery

The DSS A2A server supports JSON-RPC and HTTP-SSE modes, and supports streaming responses. DSS implements the [Well-Known URI strategy](<https://a2a-protocol.org/latest/topics/agent-discovery/#1-well-known-uri>) for agent discovery.

---

## [agents/additional-request-context]

# Additional Request Context

In the Dataiku LLM Mesh, completion requests can pass extra information alongside the main query via the `context` key.

This feature allows developers to pass additional data—such as user identifiers, security tokens, or application states—through the chain of Agents and Tools.

Important

Do not confuse this **Additional request context** with the **LLM context window**.

  * **LLM context window:** The actual text (prompt + history) visible to the model, limited by token count.

  * **Additional request context:** Arbitrary JSON metadata passed to the **code** executing the tools or retrieval systems. This data is **invisible to the LLM itself** unless a specific Tool is programmed to read it.




## Standard Keys

The `context` is an arbitrary JSON object. However, Dataiku reserves specific keys to standardize security and state management across the LLM Mesh.

conversationId
    

This field is an opaque string used to identify a conversation session. While generally handled automatically (e.g., by Visual Agents), Code Agents should explicitly retrieve and use this key to enable session continuity if needed.

callerSecurityTokens
    

This field is dedicated to the mechanics of [Document-Level Security](<../generative-ai/knowledge/document-level-security.html>), which applies particularly in cases of Retrieval Augmented Generation. It can be used with both a [Knowledge Bank Search tool](<tools/knowledge-bank-search.html>) or a [Retrieval-Augmented LLM](<../generative-ai/knowledge/index.html>).
    
    
    { "callerSecurityTokens": ["group_marketing", "dss_group:admin", "dss_user:jdoe"] }
    

callerFilters
    

Used to programmatically force filters on tools and specifically the [Knowledge Bank Search tool](<tools/knowledge-bank-search.html>). This prevents end users from overriding constraints via the prompt.
    
    
      {
        "callerFilters": [
        {
           "filter": {
               "operator": "AND",
               "clauses": [
                  { "column": "Category", "operator": "EQUALS", "value": "Economy"},
                  { "column": "Year", "operator": "GREATER_THAN", "value": 2012},
                  { "column": "Month", "operator": "IN_ANY_OF", "value": ["January", "February", "March"]}
              ]
           },
           "toolRef": "optional tool ref"
        }
    ]
      }
    

## Usage

When using an **Agent** or a **Retrieval-Augmented LLM** , the context is passed to the underlying tools or retrieval systems to enforce logic that the user cannot manipulate via the prompt.

**Example**

In the example API request below, the context serves two purposes simultaneously: it enforces document security (via the standard security tokens key) and provides custom metadata that a tool might use to format the response.
    
    
    {
       "query": "What is the status of my ticket?",
       "context": {
           "callerSecurityTokens": ["dss_user:admin", "group:support_team"],
           "application_source": "mobile_app",
           "user_id": "u-59201"
       }
    }
    

How this metadata reaches the underlying tools depends on the type of Agent you are building:

  * **Visual Agents:** The agent automatically passes the entire context it receives to all tools it calls.

  * **Code Agents:** Can make use of context variables in their code. It is the responsibility of the code agent implementation to pass the context to any called tools.

---

## [agents/agent-chat]

# Agent Chat

## Overview

Agent Chat allows builders to spin up a conversational interface on top of on top of a single agent, retrieval-augmented mode, or LLM, with little admin involvement.

**Key Features**

  * **Single-agent conversational UI** : OOB interface dedicated to one agent / Augmented LLM / RA model.

  * **Self-service** : Builders can easily create and share the interface with their team.

  * **Governance and Control** : Configure which generative AI assistant is exposed to the end-user, ensuring control over usage.

  * **Response Transparency** : View detailed sources, activities, and downloads for each agent response to understand how an answer was generated.




Note

Agent Chat is delivered through the Agent Hub plugin as a Visual Webapp.

## Getting Access

To use Agent Chat, a Dataiku instance administrator must first install the **Agent Hub plugin** from the plugin store. The administrator also needs to set up the associated code environment.

Once installed, Agent Chat becomes available as a **Visual Webapp** that can be created within any Dataiku project.

## Configuration

### Requirements

To successfully set up and use an Agent Chat, the following prerequisites are necessary:

  * **Dataiku Version** : `Dataiku 14.5` or later.

  * **Agent Hub plugin** : `v1.3` or above. The latest plugin versions are always the best choice to leverage the plugin’s full capabilities.

  * **User Profile** :
    
    * To create and configure Agent Chat: you must have at least `Write` access to the project containing the Agent Chat webapp.

    * To use Agent Chat: users need access to the webapp and a DSS license.

  * **Connections** : A connection to at least one [LLM](<../generative-ai/llm-connections.html>).




### Initial Setup

Agent Chat is created as a visual webapp within a Dataiku project.

  1. From your project, navigate to the **Code** menu and select **Webapps**.

  2. Click `+ New Webapp` and choose `Visual webapp`.

  3. Select the `Agent Chat` template from the list.




### Backend Settings

Once the webapp has been created, you can select the backend settings from the `Edit` tab.

  * `Auto-start backend`: Check this box to ensure the Hub is running automatically.

  * `Number of processes`: 0

  * `Container`: Choose between using backend to execute or containers.

  * `Data storage` : Choose between a local or external database to store Agent Chat data.




### Webapp Settings

Once the backend settings have been selected, all of the webapp settings are directly configured in the webapp (click on `View`).

#### Core Settings

Agent Chat has one mandatory LLM connection required to function.

  * `Conversational Agent or LLM` (Mandatory): Select the Agent or LLM with whom users will interact.

  * `Optional Instructions`: You can optionally add a system prompt that will be used by the Agent/LLM.

  * `Title generation LLM`: Pick the LLM used to generate titles.

  * `Document guardrails`: Screen documents title and body in-chat against a customizable list of prohibited keywords or regular expressions.

  * `Include DSS caller ticket in the agent context`: Toggle to include the DSS caller ticket in the context sent to the agent, to execute tools with end-user identity.

  * `Permanently delete messages`: Toggle so that when users delete messages in the conversation, they are also deleted from the database.

  * `Advanced settings`: Options to include network and client metadata for gateway reporting.




#### Charts Generation

Agent Chat can directly generate charts from agent responses that use tools returning records.

  * `Charts Generation Mode`:
    
    * Select `None - Disable charts generation` if this functionality is not needed. Else, charts will be generated using SQL artefacts of agents.

    * Select `On Demand - Let end users generate charts`, lets users decide when to generate charts and what type.

    * Select `Auto - Generate charts automatically`, automatically generates charts whenever the agent’s response includes SQL artefacts. The text completion model automatically chooses the type of graph based on the user query.

  * `LLM`: Choose an LLM to power chart generation.




#### Upload in Conversation

When the option `Enable Document Upload` is enabled by the admin, users can upload documents (txt, pdf, docx, png, jpg, jpeg, pptx, md) in chat to enrich conversation context. This requires setting up a managed folder where uploaded files will be stored.

There are two extraction modes admins choose from:

  1. Using pages as screenshots




Pages of PDF, PPTX and DOCX files are screenshotted and passed as is to the multimodal LLM (the selected LLM needs to support multimodal inputs). In this mode, a maximum number of images that can be uploaded per conversation must be defined. If this maximum is reached, images (png, jpg, jpeg) are passed on to the multimodal LLM but only text is extracted from documents (PDF, PPTX and DOCX files).

  2. Extracting text




In this mode, text is extracted from PDF, PPTX, DOCX files. Inline images in these documents can be processed with:

  * OCR:
    
    * This identifies the characters in the inline image and converts it to text

    * Best for documents that don’t hold significant visual information (i.e. receipts)

  * VLM:
    
    * Can “understand” visual elements, output is a textual description of the image. When queried, the LLM only uses the textual description generated, not the actual screenshot as in the first mode.

    * Best for photos, complex diagrams, charts, or screenshots of user interfaces where context/visual understanding matters.

    * It’s important to note that each and every image (including icons, logos, etc.) within the uploaded document are processed by the VLM, which can be very resource-intensive.

    * This requires DSS 14.3+

  * **Not processed** : This may result in information loss




#### User Experience

In the `User Experience` tab, the admin can configure conversation starters, which are suggested prompts in the homepagethat users can click on to start the conversation.

#### Look and feel customization

Customize the interface look match your company’s brand guidelines or preferences. This applies to all users of the webapp. * Select a managed folder where assets will be stored. * Choose a default main color, home page title and logos for the interface.

### Setting up integration with Traces Explorer

On top of in-app traces of tool/agent calls, the comprehensive trace can be viewed using the integration with [Trace Explorer](<tracing.html>). To use this integration, you must:

  1. Ensure that the `Traces Explorer` plugin is installed on your Dataiku instance.

  2. Create a Trace Explorer webapp in a project and give read access to relevant user groups.

  3. In Administration > Settings > LLM Mesh, set the default Trace Explorer webapp to the one you just created.




The button to navigate to Trace Explorer will then appear in See details > Activities.

### Building tools that integrate with Agent Chat

Please refer to the [Agent Hub documentation](<agent-hub.html>) which has the same requirements and specifications.

## Using Agent Chat

### Conversations

Users can start a conversation from the homepage or click on `Start new conversation`.

The user query is directly passed to the agent/LLM defined in the admin settings, with the conversation history.

All conversations are saved in the left panel, where you can rename, delete, or revisit them.

### Understanding Responses

Agent Chat allows you to inspect how an agent generated its response. Click the `See details` button below any response to open a panel with three tabs:

  * **Sources** : References to the documents, datasets, or other knowledge sources used by the agent.

  * **Activities** : A log of which agents and tools were called and what actions were performed.

  * **Downloads** : Download any files generated by the agent.




## Security and Permissions

When setting up Agent Chat, you have control over who has access to the webapp and what they can do with them. This is managed through a combination of DSS [project permissions](<../security/permissions.html>), DSS user groups and webapp settings.

### Webapp permissions

First you want to define who can access the Agent Chat webapp. There are multiple ways to do this:
    

  * Give end-users or their user groups read access to the project hosting the Agent Chat application.

  * or Share the Agent Chat webapp within a [workspace](<../workspaces/index.html>) that the end-users have access to.

  * or Add the Agent Chat webapp to the list of [authorized objects](<../security/authorized-objects.html>) in the `Project security` settings and grant `Read dashboards` permission to end-users to the project hosting the webapp.




End-users that have write access to the project hosting the webapp will have access to the webapp’s settings.

Given there’s only one agent/LLM that can be connected to Agent Chat, controlling access to the webapp is the main way to control who can use the agent (i.e. users who have access to the webapp will be able to use the agent/LLM).

### Document-level security

[Document-Level Security](<../generative-ai/knowledge/document-level-security.html>) enables granular access control over documents within a knowledge bank. It ensures that when a user performs a search or query, the results only include documents that user is authorized to view.

User security tokens are passed on to the agent in Agent Chat. These tokens aren’t used for authentication but rather filtering of the knowledge bank.

The caller security tokens include `dss_group`, `dss_login` and `dss_email`.

For instance, here are the tokens passed on for a user named Alex (login: alex), who belongs to readers and editors groups:
    
    
    {
    "callerSecurityTokens": [
       "readers",
       "editors",
       "dss_group:readers",
       "dss_group:editors",
       "dss_user_login:alex",
       "dss_user_emailaddress:[[email protected]](</cdn-cgi/l/email-protection>)"
    ],
    "dku_user_email": "[[email protected]](</cdn-cgi/l/email-protection>)",
    "dku_user_login": "alex",
    "dku_user_display_name": "Alex"
    }
    

In this case, Alex will only see documents that are accessible to the `readers` group or the `editors` group.

### Role-based access control

Rather than calling tools with the backend identity, you can choose to use end-user identity for tool calls.

This is useful for row-level security on datasets and can be used when building custom tools making API calls in DSS.

This has to be configured at the tool level, and works natively with the [SQL Query Tool](<tools/sql-question-answering.html>) and the [Dataset Lookup Tool](<tools/dataset-lookup.html>).

In the tool configuration, under the “Security” section, select “Access datasets as” and choose “End-user caller”.

This is done by obtaining the API ticket from the user’s browser headers, which is passed by the agent through the agent as `dkuCallerTicket`.

Note

Make sure that agents pass on the context. This requires ticking `Forward context` in the `Query another agent or an LLM` tool.

---

## [agents/agent-hub]

# Agent Hub

## Overview

**Agent Hub** is the central portal for organizations to distribute enterprise-level agents, manage access, and empower users to build their own custom agents.

Agent Hub is a Dataiku plugin providing: a visual webapp, an export recipe and a custom dataset.

It allows users to access a library of AI agents and leverage a single agent or orchestrate multiple agents simultaneously through a unified chat interface.

**Key Features**

  * **Centralized Agent Library** : Access from your browser a curated list of purpose-built agents built and selected by your AI experts and SMEs.

  * **Multi-Agent Orchestration** : Chat with multiple agents in a single conversation. The Hub intelligently routes queries to the most relevant agent(s).

  * **User-Built Agents** : Empower end-users to quickly create their own “My Agents” for personal productivity.

  * **Governance and Control** : Configure which enterprise agents, LLMs, and tools are available within a Hub, ensuring control over usage.

  * **Response Transparency** : View detailed sources, activities, and downloads for each agent response to understand how an answer was generated.




For more information, see also the following article in the [Knowledge Base.](<https://knowledge.dataiku.com/latest/genai/agents/concept-agent-hub.html>)

## Getting Access

To use Agent Hub, a Dataiku **instance administrator** must first install the **Agent Hub plugin** from the plugin store. The administrator also needs to set up the associated code environment.

Once installed, Agent Hub becomes available as a **Visual Webapp** that can be created within any Dataiku project.

## Configuration

### Requirements

To successfully set up and use an Agent Hub, the following prerequisites are necessary:

  * **Dataiku Version** : `Dataiku 14.2` or later. The Last Dataiku version is always the best choice to leverage the latest capabilities.

  * User Access Profiles:
    
    * To create the webapp: You must be part of a group that has write isolated code execution permission.

    * To run the backend:
    
      * You must have a profile that is allowed to create and manage projects contents and impersonate users groups that are going to use Agent Hub.

      * For users in the cloud, identity running the backend must be part of the admin space.

    * To have access to the Agent Hub **webapp admin** settings: You must have `Write` access to the project containing the Agent Hub webapp.

    * To use Agent Hub: Users with `AI Consumer` or `AI Access` profiles can use a Hub they have read access to. AI Access users can use, but not build agents and AI Consumers can both build and use agents.

  * **Connections** : A connection to at least one [LLM](<../generative-ai/llm-connections.html>) AI model that supports **tool calling** and one that supports [embedding](<../generative-ai/knowledge/initial-setup.html>).




Note

Permissions for impersonation in webapps are setup in Administration > Security > Group > Impersonation in webapps.

Allowed groups should include all groups of users that will access the Agent Hub. Typing .* will allow impersonation of all groups.

### Initial Setup

Agent Hub is created as a visual webapp within a Dataiku project.

  1. From your project, navigate to the **Code** menu and select **Webapps**.

  2. Click `+ New Webapp` and choose `Visual webapp`.

  3. Select the `Agent Hub` template from the list.




Note

While you can create Agent Hub webapp in the same project as your agents, it is recommended to create it in a dedicated project. This simplifies access management and oversight.

### Backend Settings

Once the webapp has been created, you can select the execution settings from the `Edit` tab.

  * `Auto-start backend`: Check this box to ensure the Hub is running automatically.

  * `Number of processes`: 0

  * `Container`: Choose between using the backend to execute or containers.

  * `Data storage` (for v1.2+): Choose between a local or external database to store Agent Hub data.




### Webapp Settings

Once execution settings have been selected, all of the webapp settings are directly configured by the **webapp admin** (for v1.1+).

#### Core Settings

Agent Hub has one mandatory LLM connection required to function.

  * `Agent Hub LLM` (Mandatory): Select an LLM that will be used across Agent Hub, particularly to orchestrate agents i.e. decide which agent to call in a multi-agent conversation. It is recommended to use a model that supports tool calling.

  * `Optional Instructions`: You can optionally add a system prompt that will be used by the LLM when orchestrating agents.

  * `Agent Orchestration Mode`: Choose between two modes:
    
    * `Tools`: The LLM need to support tool calling. Active agents in the conversation are used as callable tools by the orchestrating LLM, which means they can be called multiple times and that the output of one can be used as the input of another.

    * `Manual`: Use this mode when the LLM does not support tool calling. Agent Hub selects the relevant agents, can call each one once in parallel, and combines their outputs into a single response.

  * `Document guardrails` (v1.2+): Screen documents title and body (in-chat or in My agents) against a customizable list of prohibited keywords or regular expressions.

  * `Include DSS caller ticket in the agent context`: Toggle to include the DSS caller ticket in the context sent to the agent, to execute tools on behalf of the end-user identity.

  * `Permanently delete messages`: Toggle so that when users delete messages in the conversation, they are also deleted from the database.

  * `Advanced settings`: Options to include network and client metadata for gateway reporting




#### Enterprise Agents

This section allows you to add pre-built, governed agents to the Hub.

  1. Click on `Add Agent(s)` and under `Select project`, search for and select the Dataiku project(s) containing the agents you want to include.

  2. Amongst the list displayed, choose the specific agents/augmented LLMs to add.

  3. For each agent, you can configure the following:
    
     * `Name`: A user-friendly display name.

     * `Description (Mandatory)`: A detailed description of the agent’s capabilities and purpose. This is used by Agent Hub’s orchestrating LLM to understand when to call this agent. It is displayed to the end user in the Agent Library to describe the capabilities of the agent.

     * `Example questions`: Sample questions that demonstrate how to use the agent.

     * `Additional instructions`: Instructions that will be added to the Enterprise Agent’s system prompt.




Note

Enterprise Agents can be re-ordered by drag and dropping them. This impacts how they are displayed in the Agent Library.

#### My Agents

Configure the settings for user-created agents.

  * `Enable My Agents`: Toggle this option to allow users to create their own agents within the Hub.

  * `LLMs`: Select at least one model that users can leverage when creating their own “My Agents”.

  * `Embedding Model`: Select at least one model for embedding documents uploaded by users for their “My Agents”.

  * `File System Connection`: Choose a connection where documents uploaded by users will be stored. This connection must allow the creation of managed folders.

  * `Folder where My Agents will be created`: Optionally specify a managed folder where user agents will be stored.

  * `Number of documents to retrieve`: Maximum number of document chunks to retrieve for context.

  * `Managed Tools`: Select tools that users can pick for their agents. These can both be shared tools from other projects or tools instanciated in the project.

  * `Enable datasets` (v1.3+): Toggle this option to allow users to query SQL datasets in their My Agents.
    
    * If enabled, pick between two modes:
    
      * `Simple` (recommended by default): all context is sent to the tool to generate the SQL query. Fast and efficient with datasets with a small number of columns.

      * `Agentic` (recommended for large datasets): the tool dynamically calls context - this makes it slower but allows to work with datasets with a large number of columns, by only sending relevant columns in the context.

    * `From Workspaces` and `From Data Catalog`: select where the datasets accessible to users for their My Agents can come from. These can come from `Workspaces` and/or the `Data Catalog`.

    * `LLM For SQL generation` (optional): Select the LLM that will generate the SQL queries.




Note

This is only available when the version of the semantic-models-lab plugin is 2.0 or higher.

Generating SQL requires is a complex task. We suggest using a top-tier model to ensure query precision.

  * `Enable groups restriction for sharing`: Limit sharing of My Agents to DSS groups to which the user belongs. Additionally, the **webapp admin** can choose to exclude specific groups from sharing.




Note

**My Agent sharing** : Assuming three users and their groups.

If user A belongs to groups 1 and 2, user B belongs to groups 2 and 3, and user C belongs to group 4.

  * If this setting is disabled [Default]: A can share its My Agents with users B and C.

  * If this setting is enabled:

>     * A can only share them with user B.
> 
>     * If, in addition, group 2 is added to the `List of groups that users may not share with`, A can no longer share agents with users B and C.




#### Prompt Library

Configure the prompts that are available to build My Agents. Prompts are managed in collections in the Enterprise asset library (14.4+) or in Agent Hub (14.2).

Once the Prompt Library is enabled, the **webapp admin** can choose collections of prompts to be made available to users, in My Agent creation.

#### Charts Generation

Agent Hub can directly generate charts from agent responses that use tools returning records.

  * `Charts Generation Mode`:
    
    * Select `None - Disable charts generation` if this functionality is not needed. Else, charts will be generated using SQL artefacts of agents.

    * Select `On Demand - Let end users generate charts`, lets users decide when to generate charts and what type.

    * Select `Auto - Generate charts automatically`, automatically generates charts whenever the agent’s response includes SQL artefacts. The text completion model automatically chooses the type of graph based on the user query.

  * `Text Completion Model`: Choose an LLM connection to power chart generation if it is enabled.




#### Upload in Conversation

When the option `Enable Document Upload` is enabled by the **webapp admin** , users can upload documents (txt, pdf, docx, png, jpg, jpeg, pptx, md) in chat to enrich conversation context. This requires setting up a managed folder where uploaded files will be stored.

There are two extraction modes the **webapp admin** can choose from:

  1. Using pages as screenshots




Pages of PDF, PPTX and DOCX files are screenshotted and passed as is to the orchestrator or agents. This means that they need to support multimodal inputs (both text and images). In this mode, a maximum number of images that can be uploaded per conversation must be defined. If this maximum is reached, images (png, jpg, jpeg) are passed on to the multimodal LLM but only text is extracted from documents (PDF, PPTX and DOCX files).

  2. Extracting text




In this mode, text is extracted from PDF, PPTX, DOCX files. Inline images in these documents can be processed with:

  * OCR:
    
    * This identifies the characters in the inline image and converts it to text

    * Best for documents that don’t hold significant visual information (i.e. receipts)

  * VLM:
    
    * Can “understand” visual elements, output is a textual description of the image. When queried, the LLM only uses the textual description generated, not the actual screenshot as in the first mode.

    * Best for photos, complex diagrams, charts, or screenshots of user interfaces where context/visual understanding matters.

    * It’s important to note that each and every image (including icons, logos, etc.) within the uploaded document are processed by the VLM, which can be very resource-intensive.

    * This requires DSS 14.3+

  * **Not processed** : This may result in information loss




#### User Experience

In the `User Experience` tab, the **webapp admin** can configure end-user interface settings.

  * Interface Settings:
    
    * `Smart mode`: Enable auto-fill of My Agent’s description.

    * `Allow users to disable agents`: Enabling this setting allows users to directly engage with an LLM. In this mode, their query is directly passed on to the head LLM and no agents are involved in generating the answer. The answer relies 100% on the LLM’s capabilities.

  * **Conversation Starters** : define queries and selection of linked agent(s) displayed on homepage.




#### Look and feel customization

Customize the interface look match your company’s brand guidelines or preferences. This applies to all users of the webapp. * Select a managed folder where assets will be stored. * Choose a default main color, home page title and logos for the interface.

### User Settings

In the left sidebar of the chat interface, users can configure the language of the webapp (English, French or Japanese) and access a monitoring dashboard.

### Setting up integrations with Stories and Traces Explorer

#### Traces explorer

On top of in-app traces of tool/agent calls, comprehensive trace can be viewed using the integration with [Trace Explorer](<tracing.html>). To use this integration, you must:

  1. Ensure that the `Traces Explorer` plugin is installed on your Dataiku instance.

  2. Create a Trace Explorer webapp in a project and give read access to relevant user groups.

  3. In Administration > Settings > LLM Mesh, set the default Trace Explorer webapp to the one you just created.




The button to navigate to Trace Explorer will then appear in See details > Activities.

#### Stories

When looking to generate quick visualizations from data, users can leverage in-chat chart generation. For more complex data storytelling, users can navigate to [Stories](<../stories/index.html>) for analyses in visual slides that support quality decision-making. To enable this, you must:

  1. Ensure that you have a [Workspace](<../workspaces/index.html>) correctly set up with the datasets you want to use.

  2. In Admin Settings > Enterprise Agents, toggle `Allow users to create Insights in Dataiku Stories` and select the workspace where the stories will be created.




Navigating to Stories will automatically be available in the chat interface when the agent response includes SQL artefacts.

Note

Dataiku Stories is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager

### Building tools that integrate with Agent Hub

You can build [custom tools](<tools/custom-tools.html>) that can be used by agents within Agent Hub.

#### Display Sources

If you want your agent data sources or references to be displayed in the “Sources” tab, you must provide this information into the `additionalInformation` field of their tool calls.
    
    
    {
       "toolCallDescription": "Revenue Analysis",
       "items": [
          {
          "type": "INFO",
          "textSnippet": "Analyzing sales data for Q3..."
          },
          {
          "type": "GENERATED_SQL_QUERY",
          "performedQuery": "SELECT date, revenue FROM sales WHERE quarter = 'Q3'"
          },
          {
          "type": "RECORDS",
          "records": {
             "columns": ["date", "revenue"],
             "data": [
                ["2023-07-01", 100],
                ["2023-07-02", 120]
                    ]
             }
          }
       ]
    }
    

Then you will need to tag each type of item used.

Tag to Use | Display Text in “Sources” Tab  
---|---  
`FILE_BASED_DOCUMENT` | **Document**  
`SIMPLE_DOCUMENT` | **Document**  
`RECORDS` | **Records**  
`GENERATED_SQL_QUERY` | **Generated SQL Query**  
`CODE_SNIPPET` | **Code Snippet**  
`IMAGE` | **Image**  
`INFO` | **Info**  
  
Note

If you send a custom string (e.g., API_RESPONSE), the UI will display the raw string “API_RESPONSE” instead of a polished label.

#### Generate graphs

If you want your tool to return data that can be used to generate charts in the chat interface, you must return an artifact of type `RECORDS`.
    
    
    {
       def _create_record_payload(df):
       return {
          "type": "RECORDS",  # Critical: tells UI to treat this as chartable data
          "records": {
                "columns": df.columns.to_list(),  # List of string headers
                "data": df.values.tolist()        # List of lists (rows)
          }
       }
    }
    

#### Downloadable Files

To make files generated by your tool downloadable in-chat and include them in the Downloads tab, you can return artifacts in your tool’s output payload.

Two methods are supported for generating downloadable files: Tabular Records and Inline Data.

  1. **Tabular Records**




If your tool returns an artifact of type `RECORDS`.

  * If a single table is returned, the UI will automatically generate and provide a `.csv` file for download.

  * If multiple tables are returned, they will be automatically zipped into a single `.zip` file.



  2. **Inline Data**




For any other file types (such as PDFs, XLS, DOCX, PPTX…) you can return an artifact containing a `DATA_INLINE` part.

When returning a `DATA_INLINE` artifact, the following fields are populated in the Downloads tab:

  * `name`: Title displayed on the download card. It’s recommended to include the file extension in the name.

  * `mimeType`: File format displayed and associated subtext label.

  * `dataBase64`: The actual base64-encoded string of the file’s binary content.




Example Artifact Payload:
    
    
    "artifacts": [
       {
          "name": "Q3_Financial_Summary.pdf",
          "parts": [
                {
                   "type": "DATA_INLINE",
                   "mimeType": "application/pdf",
                   "dataBase64": "JVBERi0xLjQKMSAw..."
                }
          ]
       }
    ]
    

#### Human in the Loop

All native and custom tools in DSS can enforce user validation before being executed. This is defined in the tool `Settings` > `Human approval`.

When this is set up, users will receive in-chat a prompt to approve or reject the tool call, and optionally edit its parameters.

## Agent Hub Ops

It’s recommended to use a single project to host the Agent Hub webapp, separate from the project hosting the Enterprise agents.

Testing should occur on a Design instance. When ready, the project containing Agent Hub should be bundled and pushed to production, along with projects containing agents intended for exposure within Agent Hub. After deployment, the WebApp will have to be reconfigured, i.e. the **webapp admin** will have to choose connections that are on the automation node and add relevant enterprise agents that are on the automation node.

Once on the automation node, the dependencies of Agent Hub can be updated without touching the Agent Hub project. This means that Enterprise Agents follow the classic CI/CD process. Once deployed, the Agent Hub project isn’t meant to be modified in the design node or re-deployed - that would replace the parameters with those from design.

## Using Agent Hub

### Agent Library

The Agent Hub interface organizes all available agents into four categories:

  * **Enterprise Agents** : Governed agents distributed by designers for wide use.

  * **My Agents** : Agents you have created for your own productivity tasks.

  * **Agents Shared with Me** : “My Agents” that other users have shared with you.

  * **Favorite Agents** : Any agent you have marked with a star for quick access.




### Conversations with Agents

Users can start a conversation from the homepage or by selecting an agent. They can manually add or remove agents during the conversation.

The orchestrating LLM manages the conversation based on the number of agents selected.

  * **Single agent** : The query is directly passed to the selected agent, with the conversation history.

  * **Multiple agents** :
    
    * For each question, the LLM filters the multiple agents selected and only keeps the relevant onees, using the descriptions of agents.

    * Depending on the filtering, there can be no agent left and the default LLM answers the question, one agent left and we fallback to the single agent mode, or 2+ agents left.

    * If 2+ agents are left, they are called as tools (if the orchestration mode is set to `Tools`) or else in parallel, as described in the backend settings.

  * **No agent selected** : Same as previous but with all agents available to the end user.

  * **Agents disabled** : If the end-users have disabled agents in conversation, their query is directly passed on to the head LLM and no agents are involved in generating the answer.




All conversations are saved in the left panel, where you can rename, delete, or revisit them.

### Building “My Agents”

Users with at least an `AI Consumer` profile can create their own agents directly within the Hub.

  1. Click `Create new agent`.

  2. Provide detailed `Agent instructions` in the prompt window or use a template from the `Prompt library`.

  3. Under `Agent Capabilities`:

     * Upload `Documents` to provide the agent with specific knowledge. Dataiku automatically embeds these documents.

     * Add a `Dataset` to let the agent query its data so that users can analyze and visualize it.

     * Add `Tools` to let the agent perform actions or access external services.

  4. Manually fill or use the `Autofill` button to generate an `Agent Overview`, to provide an agent description and optionally some example queries.

  5. Test your agent in the chat window and click `Publish` when you are satisfied with its performance.




### Understanding Responses

Agent Hub allows you to inspect how an agent generated its response. Click the `See details` button below any response to open a panel with three tabs:

  * **Sources** : References to the documents, datasets, or other knowledge sources used by the agent.

  * **Activities** : A log of which agents and tools were called by the Hub and what actions they performed.

  * **Downloads** : Download any files generated by the agent.




## Monitoring and Quality checks

### Extracting Agent Hub’s logs

Once Agent Hub is set up and in production, you can extract Agent Hub’s logs to monitor usage and evaluate Enterprise Agents.

To do that, you can either use a recipe that extracts Agent Hub’s raw database or create a virtual dataset on the relevant database tables.

The user running this recipe must also be used as the backend identity of Agent Hub.

  1. **The recipe to export data from AH to datasets**




In the flow, click on `Add item` > `Recipe` > `Generative AI` > `Agent Hub`. In the recipe, you can choose the project, the Agent Hub webapp instance, and the tables he wants to export. These are mapped out to the output datasets. Given the potentially important size of artifacts, you can choose to keep them compressed. A scenario can be run regularly to sync the data.

  2. **Creating a virtual dataset**




A second option is to create a virtual dataset: `Add item` > `Connect or Create` > `Generative AI` > `Agent Hub`.

This reads a single table from an Agent Hub Webapp internal database, effectively creating a virtual dataset that can then be synced in the flow, and used just like the previous extracted datasets. Virtual datasets make requests to the Agent Hub’s internal database each time it is accessed - this can potentially be expensive.

### Monitoring

Once the database is extracted, a dashboard can then be easily created atop these datasets to monitor Agent Hub activity more deeply. Furthermore, a monitoring dashboard is provided out-of-the-box in Agent Hub, including usage activity and user feedback, broken down by agents.

### Quality checks

The extracted datasets include conversations and traces, can be used to perform custom quality checks of the agents exposed through Agent Hub.

## Security and Permissions

When setting up Agent Hub, you have control over who has access to the webapp, which agents they can see and use, and what they can do with them. This is managed through a combination of DSS [project permissions](<../security/permissions.html>), DSS user groups and webapp settings.

### Webapp permissions

First you want to define who can access the Agent Hub webapp. There are multiple ways to do this:
    

  * Give end-users or their user groups read access to the project hosting the Agent Hub application.

  * Share the Agent Hub webapp within a [workspace](<../workspaces/index.html>) that the end-users have access to.

  * Add the Agent Hub webapp to the list of [authorized objects](<../security/authorized-objects.html>) in the `Project security` settings and grant `Read dashboards` permission to end-users to the project hosting the webapp.




End-users that have write access to the project hosting the webapp will have access to the webapp’s settings.

### Enterprise agents permissions

Once you’ve defined who can access the Agent Hub webapp, you can control which Enterprise agents they can see and use within the Hub. Users will only see the agents they have read access to in their Agent Library .

There are different ways to do this:
    

  * Give end-users or their user groups `Read project content` permissions on the Dataiku project(s) that contain the Enterprise Agents.

  * Add the agent to the list of [authorized objects](<../security/authorized-objects.html>) in the `Project security` settings and grant `Read dashboards` permission to end-users or their user group to the project hosting the agent.




Note

Calls to the agent and tools are made by default using the identity of the user running the backend. This allows for giving minimum permissions to end-users. If you want to use end-user identity for calls, to authenticate or have role-based access control, refer to the following section.

### User Access Profiles

A user’s access level and capabilities within Agent Hub are determined by their Dataiku profile.

  * **AI Access** : Can use agents but cannot build them.

  * **AI Consumers** : Can use, build and share My Agents.

  * **Full Designer** : All previous capabilities, plus can build, configure, and manage Agent Hubs.

  * **Technical accounts** : Can be used to run the backend of Agent Hub.




### Identity Forwarding and Data Security

#### Objects sent as part of agent context

When an agent is called in Agent Hub, the system automatically forwards a set of metadata and security tokens to the agents and tools.

Here’s a generic example of what’s sent as part of the context:
    
    
    "context": {
      # List of groups and identifiers used to filter Knowledge Bank results (Document Level Security)
      "callerSecurityTokens": [
        "readers",
        "dss_group:readers",
        "dss_user_login:alex",
        "dss_user_emailaddress:[[email protected]](</cdn-cgi/l/email-protection>)"
      ],
    
      # Unique UUID for the current chat session tracking
      "conversationId": "63d54d50-64ca-4761-b7a6-342a9da3d5ab",
    
      # Sensitive API ticket allowing tools to act as the end-user (RBAC)
      "dkuCallerTicket": "REDACTED",
    
      # Identity tracking for 'Run as' or 'End-user caller' scenarios
      "dkuOnBehalfOf": "alex",
      "dkuOnBehalfOfDisplayName": "Alex User",
      "dkuOnBehalfOfEmailAddress": "[[email protected]](</cdn-cgi/l/email-protection>)",
    
      # Network and Client metadata for gateway reporting and custom LLM headers
      "dkuOnBehalfOfClientIP": "127.0.0.1",
      "dkuOnBehalfOfUserAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)...",
    
      # Standard user profile information
      "dku_user_login": "alex",
      "dku_user_email": "[[email protected]](</cdn-cgi/l/email-protection>)",
      "dku_user_display_name": "Alex"
        }
    

#### Document-level security

[Document-Level Security](<../generative-ai/knowledge/document-level-security.html>) enables granular access control over documents within a knowledge bank. It ensures that when a user performs a search or query, the results only include documents that user is authorized to view.

User security tokens are passed on to agents called within Agent Hub. These tokens aren’t used for authentication but rather filtering of the knowledge bank.

The caller security tokens include `dss_group`, `dss_login` and `dss_email`.

For instance, here are the tokens passed on for a user named Alex (login: alex), who belongs to readers and editors groups:
    
    
    "callerSecurityTokens": [
       "readers",
       "editors",
       "dss_group:readers",
       "dss_group:editors",
       "dss_user_login:alex",
       "dss_user_emailaddress:[[email protected]](</cdn-cgi/l/email-protection>)"
    ],
    

In this case, Alex will only see documents that are accessible to the `readers` group or the `editors` group.

#### Role-based access control

Requires DSS 14.3.2+ Rather than calling tools with the backend identity, you can choose to use end-user identity for tool calls.

This is useful for row-level security on datasets and can be used when building custom tools making API calls in DSS.

This has to be configured at the tool level, and works natively with the [SQL Query Tool](<tools/sql-question-answering.html>) and the [Dataset Lookup Tool](<tools/dataset-lookup.html>).

In the tool configuration, under the “Security” section, select “Access datasets as” and choose “End-user caller”.

This is done by obtaining the API ticket from the user’s browser headers, which is passed by the agent through the agent as `dkuCallerTicket`. This requires Agent Hub to trust all the agents and tools in the chain, because it will now be passing sensitive / secret information to them

Note

Make sure that agents pass on the context. This requires ticking `Forward context` in the `Query another agent or an LLM` tool.

---

## [agents/agent-review]

# Agent Review

## Overview

Agent Review is a collaborative framework designed to validate agent performance. It enables Agent Builders and Subject Matter Experts (SMEs) to define test cases, execute them against specific agent versions, and perform a detailed audit of the agent’s logic, tool usage, and output quality through both automated LLM-as-a-judge “traits” and human feedback.

Note

The “Agent Review” feature is available to customers with the _Advanced LLM Mesh add-on_.

## Tests

### Adding tests

There are two methods to add tests in the Agent Review:

  * **Manual:** Manually define individual test cases. Each case consists of a Query (the user prompt), an optional Reference Answer (the “golden” response), and optional Expectations (specific behavioral guidance or constraints the agent should follow).

  * **Import from dataset:** Import an existing dataset and map columns to Query, Reference Answer, and Expectations fields.




### Quick Test

Available in the side panel, this lightweight mode allows for rapid iteration. It’s useful for refining and automatically populating Reference Answer and Expectations fields before finalizing a test case.

### Running tests

Select tests to start a new run. The tests will be executed as many times as configured in the settings. Execution results can be reviewed and annotated in the **Results** tab. Detailed logs for each run are available in the **Logs** tab.

## Traits

For automated evaluation, Builders can set up **traits** based on LLM-as-a-judge. A trait can use data from the agent’s answer, reference answer, and expectations from a test to compute a **PASS/FAIL** outcome. Traits can be configured in settings.

## Review run results

The **Results** tab is the central hub for performance analysis and human evaluation. It allows Builders and Reviewers to audit agent behavior through a combination of traits and manual validation.

### Analyze results

Click on each individual test to get more details about how the agent performed, including the agent’s answer and the trajectory for each execution of the test.

### Test Annotation & Feedback

Note

To be able to review run results, the user must have write permission on a project.

There are two types of interactions:

  1. Reviewers can provide a binary rating (PASS/FAIL) and add a comment to a test.

  2. Reviewers can manually override a trait outcome with a binary rating (PASS/FAIL).




Warning

Human feedback always overrides LLM-as-judge evaluation.

### Test status

Test status aggregates trait outcomes and feedback from team reviews. Human feedback **always** overrides LLM-as-judge evaluation.

Test Status | Condition (If)  
---|---  
**Pass** | All traits passed OR Team review overrides: “Passed”  
**Fail** | One trait failed OR Team review overrides: “Failed”  
**Conflict** | At least two team members reviews are different  
**Empty** | Test completed but no trait or human review  
**Skipped** | Test did not complete (encountered an error)  
  
### Trait status

Trait status aggregates the trait outcome in the different executions of the test as well as the team reviewers’ overrides. Human feedback **always** overrides LLM-as-judge evaluation.

Trait Status | Condition (If)  
---|---  
**Pass** | All trait outcomes passed OR All team review overrides: “Passed”  
**Fail** | One trait outcome failed OR At least one team review override: “Failed”  
**Skipped** | Trait computation did not complete (encountered an error)  
  
## Compare runs

The **Compare View** is designed for benchmarking agent performance across different versions or configurations. It provides a side-by-side analysis to help users:

  * Track progress and identify regressions.

  * Add reviews or override traits directly while comparing runs.




## Settings

### Multiple execution of a test

Since Agents are **non-deterministic** , tests can be configured to run multiple times for variance analysis.

### Trait setup

Each trait represents criteria evaluated by an LLM. Traits can be added, edited, or deleted. The instance’s default GenAI Evaluation LLM is used unless otherwise specified.

### Permissions

There are different access levels on an Agent Review:

**View**
    

Users with `Read project content` can fully access the information of an agent review.

**Perform action**
    

To perform actions (create tests, start a run, perform a review, etc.), the user needs both the `Write project content` permission and to have a profile that allows him to review agents.

_Example:_ Users with an `AI Consumer` profile and `Write project content` permission will be able to perform actions on a review. However, users with a `Reader` profile and `Write project content` will not be able to.

**Manage configuration**
    

To manage configuration (change agent, modify traits, etc.), the user needs both the `Write project content` permission and to have a profile that allows him to modify the project configuration.

_Example:_ A user with a `Designer` profile and `Write project content` permission will be able to manage the agent review configuration. However, a user with `AI Consumer` profile with `Write project content` permission will not be able to.

---

## [agents/code-agents]

# Code Agents

Code Agents allow to build an agent in a controllable and customizable manner.

As the builder of a Code Agent, you need to write the code containing your Agent’s logic.

Dataiku handles the plumbing and management of your agent:

  * Spinning your code up and down

  * Handling multiple parallel requests and scaling up and down

  * Auditing and securing calls to the agents

  * Running your agent in containers

  * …




Your code can leverage our extensive LangChain integration and, of course, all [Dataiku Managed Tools](<tools/index.html>) to increase productivity of writing the agent.

You can find [code samples](<https://developer.dataiku.com/latest/concepts-and-examples/agents.html> "\(in Developer Guide\)") and [tutorials](<https://developer.dataiku.com/latest/tutorials/genai/agents-and-tools/index.html> "\(in Developer Guide\)") in the developer guide.

Dataiku also provides an interactive test environment for your Agent.

To create a Code Agent, from the Flow, click “+Other > Generative AI > Code Agent”. Several code samples are provided to help you quickly start.

## Requirements

In order to write your Code Agent, you need a Python 3.10 or above code env. Create the code env, and make sure it’s selected in the Advanced Settings of the agent.

While no packages are strictly required, you’ll often want to use LangChain and/or LangGraph, and should add them to the code env if needed.

## What does the Code do

When writing a Code Agent, your task is to implement a class like this:
    
    
    import dataiku
    from dataiku.llm.python import BaseLLM
    
    class MyLLM(BaseLLM):
    
        def process(self, query, settings, trace):
    
            # Query is a Dataiku LLM Mesh completion query. It contains "messages", with "content".
            # For example, to get the last message's content:
            prompt = query["messages"][-1]["content"]
    
            # The agent must then build a response, which notably contains "text"
    
            resp_text = "I am a starter agent, and you wrote: %s. How are you?" % prompt
            return {"text": resp_text}
    

Of course, most agents will actually leverage LLMs, through the LLM Mesh. For example:
    
    
    # This is an example, replace by your own
    LLM_ID="vertex:myvertexconnection:gemini-1.5-pro"
    
    llm = dataiku.api_client().get_default_project().get_llm(LLM_ID)
    llm_resp = llm.new_completion() \
                .with_message("The user wrote this. What do you think about this question, without answering it?", "system") \
                .with_message(prompt) \
                .execute()
    
    resp_text = "The LLM thinks this about your question: %s" % (llm_resp.text)
    return {"text": resp_text}
    

## Using tools

Your code may choose to use Dataiku-managed tools, using their API

## Streaming

Streaming responses is an important part of providing better experience to users, especially when the Agent is meant to be used in a Chat UI. The code samples when creating a Code Agent show how to stream answers, either directly, or through the LangChain / LangGraph integration.

---

## [agents/evaluation]

# Agent Evaluation

Agents are designed to execute precise workflows to generate domain-specific answers, which makes the challenge of measuring agent performance significantly more complex than traditional evaluation techniques. Evaluating an agent requires a multidimensional assessment of its decision-making, taking into account both the agent’s answer and the path the agent took to create that answer.

Dataiku offers an “Evaluate Agent” recipe for transactional agents: single-turn agents that process one request at a time. The recipe evaluates both the agent’s answer and its trajectory (tool calls and encountered guardrails) to generate various outputs, the most pivotal of which is an agent evaluation stored in an [evaluation store](<../mlops/model-evaluations/analyzing-evaluations.html>). From this evaluation store, you can then complete your GenAIOps actions with alerting or automated actions.

Note

The “Evaluate Agent” recipe is available to customers with the _Advanced LLM Mesh_ add-on.

## Overview

Much like the [Evaluate LLM](<../generative-ai/evaluation.html>) recipe, the Evaluate Agent recipe does not take a model as a direct input, but a single dataset — the output of your pipeline containing all the required columns: input, output, tool calls, ground truth, etc…

When run, the recipe computes a set of metrics based on the content of the input dataset and create a single agent evaluation.

Note

Our [agent evaluation tutorial](<https://knowledge.dataiku.com/latest/deploy/genai-monitoring/tutorial-agent-evaluation.html>) provides a step-by-step explanation of how to create your first agent evaluation Flow. Do not hesitate to do it as a first experience.

There are some pre-requisites for a working recipe. Those requirements are to be done once, but may require the assistance of your instance administrator.

  * You need to have a [code environment](<../code-envs/index.html>) with the required preset installed (using Python 3.9+). Look for the preset called “Agent and LLM Evaluation”.

  * For most metrics, you will need an LLM to compute embeddings and an LLM for generic completion queries. These LLMs are to be selected from [Dataiku’s LLM Mesh](<../generative-ai/llm-connections.html>).




## Recipe configuration

You can create an “Evaluate Agent” recipe from any dataset.

### Input dataset

The input dataset must contain a record of all the interactions with the agent. Ground truth might also be needed by some metrics. If the input dataset was created by a Prompt recipe, you can set the Input Dataset Format to “Prompt Recipe”, and only have to fill the Ground truth and Reference tool calls fields. If the input dataset is an [agent interaction logging dataset](<interaction-logging.html>), you can set the Input Dataset Format to “Agent Interaction Logs”, and only have to fill the Ground truth and Reference tool calls fields. Otherwise, you can set the Input Dataset Format to “Custom”, and reference all the columns from the Input Dataset:

  * Input column: The column containing the input sent to the agent. Usually, a question or request from the user.

  * Output column: The textual answer sent back by the agent.

  * Actual tool calls column: The list of tools used by the agent. Must be an array of tool names as strings.

  * Ground truth column: The reference textual answer that was expected. Will be compared against the Output column.

  * Reference tool calls column: The reference list of used tools that was expected. Must be an array of tool names as strings. Will be compared against the Actual tool calls column.




### Outputs

The outputs of the recipe are settable from the Input/Output tab. Like the Standalone Evaluation Recipe and the Evaluate LLM recipe, the Evaluate Agent recipe can output:

  * An Output Dataset: Will contain a copy of the Input Dataset, with one additional column for each of the metrics computed. The metric values are hence “row-by-row”: Each value is specific to that row.

  * A Metrics Dataset: Will contain one row for each run of the recipe, and one column for each of the metric computed. Each metric value is hence an aggregation of the values of this metric over all the rows. The aggregation is usually an average, but this can depend from one metric to another.

  * A GenAI Evaluation Store: Will contain a collection of agent evaluations (one for each run), each agent evaluation containing all of the above information: values from the input dataset, row-by-row metrics, aggregated metrics.




Some of the agent evaluation settings can be set from the recipe, to help you name and label each run.

### Metrics

The metrics section contains a list of built-in metrics that you can select to evaluate the behavior of your agent. These metrics should cover basic needs:

  * Fine-grained deterministic checks on the tools used by the agent (In order and Out of order tool calls metrics).

  * LLM-as-a-judge metrics, based on the [RAGAS framework](<https://docs.ragas.io/en/latest/concepts/metrics/index.html>).

  * Or deterministic BERTScore metric, which uses embeddings to compare outputs.




### Custom Metrics

As agent evaluation is a quickly evolving topic, the recipe allows you to write your own metric in Python. This is done using a standard “evaluate” function and should return at least one float representing the metric.

Additionally, you can return an array of floats, each entry being the metric value for a single row. This will be used in the row-by-row analysis.

Code samples are available, which can make your first experience with custom metrics easier, or allow you to define your own samples to be reused later.

### Custom Traits

In addition to writing custom metrics with code, you can also define custom LLM-as-a-judge metrics without code in the form of traits.

You define a trait by providing a list of pass/fail assertions, which will be applied to individual rows in your input dataset. For each row, the LLM defined in “Completion LLM” will run each assertion over its values. If all assertions for that row are correct, the value of the trait for that row will be “True”.

Each trait is a list of assertions, which are sent along with each row of your input dataset, to the LLM defined in “Completion LLM”. Each assertion is made on the values of the row. For each row, if all the assertions are correct, the LLM is expected to set the value of the trait to “True”. The aggregated value of the trait over all the rows is the fraction of rows having returned True.

As for custom metrics, trait samples are available, which can allow you to set and reuse traits.

## Agent Evaluations

Each run of the “Evaluate agent” recipe will create one agent evaluation. This agent evaluation will be visible in the output evaluation store.

In the main view of an agent evaluation, you see plotted metric graphics at the top and the list of agent evaluations at the bottom, including metadata, labels, and metrics in a table.

When you open an agent evaluation, the first section contains: run info, the recipe configuration at the time of the run, and all metrics. You also see the labels that were added during the execution of the recipe. You can add, update or delete labels if you want.

The second section of an agent evaluation is a row-by-row detail. This aims at helping you understand specific values of metrics, by giving you the context (row values) that precluded the value of each metric. Moreover, from each row, you can access the trajectory explorer, which gives an overview of the actions of the agent.

If you have defined custom metrics or custom traits, they will be shown in the agent evaluation summary along other metrics. If your custom metric returned the array with detailed values, you will also see it in the row-by-row analysis.

## Trajectory explorer

The trajectory explorer displays an overview of what the agent did in chronological order, for each row in the input dataset.

The left panel contain a list of all the actions the agent took, as nodes. They can be of four types:

  * Initial input: The request sent to the agent.

  * Tool call: Any tool call the orchestrator requested, that was subsequently executed by DSS. Each tool call stores its input parameters and outputs (or eventual error).

  * Guardrail trigger: If guardrails are defined at the agent or orchestrator LLM level, they might not interrupt the agent. Nevertheless, any hit guardrail is presented here, as it can have altered (e.g by redacting) the input or output. Each guardrail stores its input (what was checked), and output (why the guardrail triggered).

  * Final output: The answer sent back by the agent.




You can click on each action to display its properties on the right panel. This includes, in addition to the input/output mentioned above, metadata such as timing information, or descriptions.

## Comparisons

This row-by-row view is very practical to analyze specific cases in a run. However, when building a complex GenAI pipeline, you will probably experiment with different agent, different prompts, different pre- or post- processing. In such a case, the goal is not to analyze, but to compare runs using potentially very different pipelines.

Comparing runs is using [model comparisons](<../mlops/model-comparisons/index.html>). As a specific addition to the standard model comparison, the agent Comparison has a section allowing you to perform side-by-side view for each row.

In this screen, you can select a row, and you will see outputs of each run. This allows you, for example, to spot a line where the agent goal accuracy is vastly different between two runs and analyze it in depth to make an informed decision about which version of your pipeline is best.

---

## [agents/external-agents/aws-bedrock-agents]

# AWS Bedrock Agents

AWS Bedrock Agents allow you to make both Bedrock Agents and Bedrock AgentCore Agents available as a standard **Dataiku Agent** (represented by a pink diamond in the Dataiku Flow). Once configured, it can be leveraged anywhere a Dataiku Agent is supported, including:

  * The Dataiku Flow (notably Prompt Recipes)

  * Chat UIs such as [Agent Hub](<../agent-hub.html>)

  * The LLM Mesh API

  * [Prompt Studios](<../../generative-ai/prompt-studio.html>)

  * [Agent Review](<../agent-review.html>)

  * [Agent Evaluation](<../evaluation.html>)




## Key Features

  * Real-time streaming of agent responses to provide an interactive user experience is supported

  * DSS automatically extracts and displays citations from Bedrock Knowledge Banks and information from Action Group (tool) invocations.

  * Authentication to AWS Bedrock is fully managed through the use of an existing S3 connection




## Prerequisites

AWS Bedrock Agents support is provided by the “AWS Bedrock Agents” plugin, which you need to install

### AWS Requirements

  * Bedrock Agent

    * An existing agent must be created and configured in the AWS Console.

    * You must have the Bedrock Agent ID and Alias ID (not to be confused with Agent Name and Alias Name. The ID are numeric)

    * The identity configured in the linked S3 connection must have the `bedrock:InvokeAgent` permission.

  * Bedrock AgentCore

    * An existing agent must be created and configured in the AWS Console.

    * You must have the Bedrock AgentCore runtime ARN, and optionally, qualifier

    * The identity configured in the linked S3 connection must have the `bedrock:InvokeAgent` permission.




## Usage (Bedrock Agent)

  1. Navigate to your Dataiku project.

  2. Go to Agents & GenAI Models > \+ New Agent.

  3. Select Bedrock Agent.

  4. Select the AWS region and S3 connection to use for authentication

  5. Enter the specific identifiers for your Bedrock agent.




You can then use the built-in chat interface within the Agent configuration page to test your agent.

## Usage (Bedrock AgentCore)

  1. Navigate to your Dataiku project.

  2. Go to Agents & GenAI Models > \+ New Agent.

  3. Select Bedrock Agent.

  4. Select the AWS region and S3 connection to use for authentication

  5. Enter the runtime ARN for your AgentCore agent




You can then use the built-in chat interface within the Agent configuration page to test your agent.

## Cautions

  * In order to properly support multi-turn conversation, when using the LLM Mesh API, you need to pass a stable `conversationId` in the request context. Note that when using the built-in chat, or Agent Hub, this is autoamtically handled

  * Bedrock Agents using Action Groups that require user confirmation (returning control to the user) are not supported.

  * Only text-only interactions are supported. Image inputs are not supported

---

## [agents/external-agents/databricks-agents]

# Databricks Agents

Databricks External Agents allow you to make a Databricks Agent available as a standard **Dataiku Agent**

Once configured, it can be leveraged anywhere a Dataiku Agent is supported, including:

  * The Dataiku Flow (notably Prompt Recipes)

  * Chat UIs such as [Agent Hub](<../agent-hub.html>)

  * The LLM Mesh API

  * [Prompt Studios](<../../generative-ai/prompt-studio.html>)

  * [Agent Review](<../agent-review.html>)

  * [Agent Evaluation](<../evaluation.html>)




It features streaming responses and agent discovery (automatically fetching and listing available agents from your Databricks workspace)

## Prerequisites

The Databricks External Agent is provided by the “Databrick AI” plugin, which you need to install.

You need:

  * A Databricks Workspace with Model Serving enabled.

  * A Dataiku Connection to Databricks configured with either a Personal Access Token or OAuth2 credentials.

  * An active Serving Endpoint deployed in Databricks (must have the `agent/` prefix task type).




## Usage

  1. Navigate to your Dataiku project.

  2. Go to **Agents & GenAI Models** > **\+ New Agent**.

  3. Select **Databricks Agent** and provide a name.

  4. Configure the Databricks connection

  5. Choose the Databricks serving endpoint from the dropdown.




You can then use the built-in chat interface within the Agent configuration page to test your agent.

## Limitations

Image inputs are not supported

---

## [agents/external-agents/google-vertex-ai-agents]

# Google Vertex AI Agents

Vertex AI External Agents allow you to make a Vertex AI Agent available as a standard **Dataiku Agent**

Once configured, it can be leveraged anywhere a Dataiku Agent is supported, including:

  * The Dataiku Flow (notably Prompt Recipes)

  * Chat UIs such as [Agent Hub](<../agent-hub.html>)

  * The LLM Mesh API

  * [Prompt Studios](<../../generative-ai/prompt-studio.html>)

  * [Agent Review](<../agent-review.html>)

  * [Agent Evaluation](<../evaluation.html>)




It supports streaming responses, and is compatible with agents built using both **Langchain** and **Google ADK** frameworks in Vertex

## Prerequisites

Vertex AI support is provided by the “Google Vertex AI Agents” plugin, which you need to install

You need a Vertex AI LLM Connection configured, and an existing Vertex AI Agent deployed using either the Langchain or ADK framework.

## Usage

  * Navigate to your Dataiku project.

  * Go to **Agents & GenAI Models** > **\+ New Agent**.

  * Select **Vertex AI - Agents** and provide a unique name.

  * **Connection:** Select your pre-configured **Vertex AI LLM Connection**.

  * **Agent Framework:** Choose **Langchain** or **Google ADK**.

  * **Agent Name:** Select your agent from the dropdown list.




You can then use the built-in chat interface within the Agent configuration page to test your agent.

## Cautions

  * In order to properly support multi-turn conversation, when using the LLM Mesh API, and in ADK mode, you need to pass a stable `conversationId` in the request context. Note that when using the built-in chat, or Agent Hub, this is automatically handled

  * Only text-only interactions are supported. Image inputs are not supported

---

## [agents/external-agents/index]

# External Agents

External agents allow you to connect and interact with agents built in third-party platforms directly in Dataiku as managed agents.

Once configured, an external agent can be leveraged anywhere a Dataiku Agent is supported, including:

  * The Dataiku Flow (notably Prompt Recipes)

  * Chat UIs such as [Agent Hub](<../agent-hub.html>)

  * The LLM Mesh API

  * [Prompt Studios](<../../generative-ai/prompt-studio.html>)

  * [Agent Review](<../agent-review.html>)

  * [Agent Evaluation](<../evaluation.html>)




External Agents have several benefits:

  * They allow you to convert an external agent into a tool to compose larger multi-agent systems. For example, you can write a Dataiku agent that composes a Databricks agent with additional Dataiku logic.

  * They allow you to perform unified governance, by centralizing oversight via the GenAI Registry and Dataiku Govern.

  * They allow you to perform Agent Review and Agent Evaluation on agents, even if they have not been built on the Dataiku Platform

  * They allow you to automate pipelines, for example by leveraging Prompt Recipes in the Flow

  * They allow you to deploy and distribute third party agents via the LLM Mesh API or Dataiku Agent Hub

---

## [agents/external-agents/snowflake-cortex-agents]

# Snowflake Cortex Agents

Snowflake Cortex Agents External Agents allow you to make a Cortex Agent available as a standard **Dataiku Agent**

Once configured, it can be leveraged anywhere a Dataiku Agent is supported, including:

  * The Dataiku Flow (notably Prompt Recipes)

  * Chat UIs such as [Agent Hub](<../agent-hub.html>)

  * The LLM Mesh API

  * [Prompt Studios](<../../generative-ai/prompt-studio.html>)

  * [Agent Review](<../agent-review.html>)

  * [Agent Evaluation](<../evaluation.html>)




## Prerequisites

The Cortex Agent External Agent is provided by the “Snowflake Cortex AI” plugin, which you need to install.

You need a Snowflake connection setup with OAuth 2, Keypair, or Programmatic Access Token authentication. Login/Password is not supported.

The default role of the user of the Snowflake connection needs to have access to the Cortex Agent and to the underlying data

## Usage

  1. Navigate to **Agents & GenAI Models** > **\+ New Agent**.

  2. Select **Snowflake Cortex Agent**.

  3. Define the **Database & Schema** location and select the agent from the dropdown.




You can then use the built-in chat interface within the Agent configuration page to test your agent.

---

## [agents/index]

# AI Agents

Dataiku provides a full environment for building, troubleshooting, evaluating, deploying, monitoring, and exposing at scale AI Agents for the enterprise.

---

## [agents/interaction-logging]

# Agent Interaction Logging

## Overview

Agent interaction logging consists of storing each interaction with an agent as a record in a dataset. These records can then be reused for oversight, analytics, debugging, and evaluation.

A logged interaction includes:

  * The user input sent to the agent

  * The final answer returned by the agent

  * The list of tool calls performed by the agent

  * Metadata about the interaction, such as timestamps, user, or the selected agent id

  * Additional technical payloads, such as traces and trajectories




## Using interaction logs for Agent Evaluation

The [Evaluate Agent recipe](<evaluation.html>) expects a dataset containing records of agent interactions. An interaction logging dataset is therefore a common upstream input for agent evaluation.

To compute additional metrics, you can enrich the logged interactions with evaluation-specific reference data, for example:

  * A ground truth answer

  * A reference list of expected tool calls




## How to set up interaction logging

Interaction logging can be configured in the settings of an agent version. You can edit these settings either from the browser or through the Python public API, using [`dataikuapi.dss.agent.DSSAgentVersionSettings.interaction_logging_selection`](<https://developer.dataiku.com/latest/api-reference/python/agents.html#dataikuapi.dss.agent.DSSAgentVersionSettings.interaction_logging_selection> "\(in Developer Guide\)"). If you want to reuse the same interaction logging settings for all agents in a project, you can define common interaction logging settings at the project level. Then, select the **Inherit** mode in the agent version settings to reuse the project-level configuration.

The following options are available.

### Agent logging mode

Three modes are available:

  * **Disable interaction logs storage** : No interaction logs are stored.

  * **Inherit configuration** : Reuses the logging configuration inherited from the project settings.

  * **Define custom configuration** : Lets you define an explicit logging dataset and storage behavior.




### Output dataset

The **Output dataset** is the dataset where interaction logs are written. It is mandatory. You can create a new dataset or reuse an existing one. The dataset schema and partitioning must be compatible with interaction logging.

### Flushing

To avoid performance issues, interaction logs are not written synchronously to the dataset. Instead, data is buffered and written periodically according to:

  * the **Flush interval** , in seconds

  * the **Flush size** , in bytes




### Content mode

Controls how much technical payload is stored in the logs.

**Full**
    

Writes the full raw LLM response JSON in the corresponding column.

**No logs**
    

Writes the raw LLM response JSON in the corresponding column, excluding the `log` field.

**No trace and no logs**
    

Writes the raw LLM response JSON in the corresponding column, excluding both the `log` and `trace` fields. In this mode, the `dku_trace` column is also empty.

---

## [agents/introduction]

# Introduction to Agents in Dataiku

While the primary task of LLMs is to generate text, this ability to generate text, including structured output (JSON), can be used for building much more advanced applications. In these applications, the LLMs are used in order to achieve tasks beyond “answering based on knowledge”, but leveraging data, and even performing actions.

In these applications, the LLM usually acts as a central “brain” that leverages “tools” to do its work. This kind of AI-based application is often called an Agent.

## Tools

While not mandatory, usually, agents revolve around the concept of Tools. A tool can perform a task, and can describe what kind of input it expects to achieve this task.

Dataiku includes a complete system for managing tools. Dataiku provides many kinds of tools that are built into the platform, and provides extensibility for users to add their own kinds of tools.

The tools managed by Dataiku include security, audit, and most can be configured visually, allowing you to focus on building your Generative AI Application rather than the plumbing of tools.

For more details, see [Managed tools](<tools/index.html>)

Examples of tools include:

  * [Retrieving documents from Knowledge Banks](<tools/knowledge-bank-search.html>)

  * [Searching records in datasets](<tools/dataset-lookup.html>)

  * [Performing Web searches](<tools/google-search.html>)




## Types of agents

### Simple Visual Agents

With Simple Visual Agents, users can create their own Agent, based on Dataiku-managed Tools, with no coding involved.

A Simple Visual Agent simply defines which tools it uses and optional instructions. The Agent is then fully autonomous to respond to user queries: it chooses on its own which tools to leverage based on the description of the available tools, automatically calls them, and synthesizes the responses.

For more details, see [Simple Visual Agents](<visual-agents.html>)

### Structured Visual Agents

Structured Visual Agents are an advanced type of visual agent, comprised of a sequence of blocks, with support for deterministic logic.

For more details, see [Structured Visual Agents](<structured-visual-agents/index.html>)

### Code Agents

Code Agents are fully controllable and customizable. As the builder of a Code Agent, you simply need to write the code containing the logic of your Agent.

Your code can leverage our extensive LangChain integration, and of course, leverage all [Dataiku Managed Tools](<tools/index.html>) in order to increase productivity of writing the agent.

For more details, see [Code Agents](<code-agents.html>)

### Other agent types

In addition to the builtin Visual and Code agents, it is possible to leverage Dataiku’s extensibility system to define your own kind of agents. A coder can write a plugin to create a new type of agent that can then be leveraged visually by non-coding users.

For example, see [LLM Council](<llm-council.html>)

## Using agents

Once you have defined your agent, it’s time to use it.

In Dataiku, every Agent becomes itself a “Virtual LLM” in the LLM Mesh. This means that everywhere you can use the LLM Mesh, you can use an Agent!

This includes:

  * In the [Prompt Studio](<../generative-ai/prompt-studio.html>), for quick interaction with the Agent

  * In the Prompt Recipe, for massively applying the Agent to many tasks/cases

  * Through Dataiku’s Chat UIs, [Answers and Agent Connect](<../generative-ai/chat-ui/index.html>)

  * Through the [LLM Mesh API](<../generative-ai/api.html>)




The Agents system is thus fully integrated and unified with the rest of the LLM Mesh. This includes auditing, security and [Guardrails](<../generative-ai/guardrails/index.html>)

---

## [agents/llm-council]

# LLM Council

An **LLM Council** agent is provided by the “Agentic LLM Council” plugin, which must be installed from the plugin store by an administrator

An **LLM Council** agent queries multiple language models or agents in parallel to generate, critique, and refine a response. Using structured disagreement and synthesis provides a more balanced result than a single model alone.

To configure an LLM-council, you need to create an agent of type “**Custom agent llm-council-provider** ”. You can then assign any models from the LLM Mesh to two roles: Members and a Chairman.

The workflow proceeds as follows:

  * **Answering** : Members generate independent answers.

  * **Review** : Members critique peer answers.

  * **Arbitration** : The Chairman synthesizes the final response from all answers and reviews.




This agent can typically be used in the [LLM Evaluate](<../generative-ai/evaluation.html>) or [Agent Evaluate](<evaluation.html>) recipes to apply council-based consensus to evaluations.

---

## [agents/slack]

# Slack Integration

## Overview

The Slack Integration serves as a bridge between your internal messaging platform and Dataiku’s Generative AI capabilities. It allows users to interact with Dataiku Agents and LLMs directly within their Slack workspace, enabling seamless access to data insights and automated responses in both direct messages and channels.

**Key Features**

  * **Interactive Bot:** Chat directly with Agents configured in Dataiku.

  * **Socket Mode:** Secure connection without exposing public endpoints.

  * **Multi-channel Support:** Works in DMs and public/private channels (dependent on slack app permissions).




## Setup

### Pre-requisites

The Slack Integration is provided by the “Agents on Slack” plugin, which you must install. Please see [Installing plugins](<../plugins/installing.html>).

You will need administrative access to a Slack Workspace alongside write permission in a Dataiku Project and code execution permission to configure the integration.

The Slack Integration uses a webapp in DSS, with the backend connecting to Slack and relaying messages back & forth between Slack and the Agent. The backend must be running to process events. Enable `auto-start backend` in the `edit` tab to ensure it runs automatically.

DSS needs to have outbound network access to `api.slack.com` and `wss://wss-primary.slack.com`.

This section details the setup of the Slack App, the generation of necessary tokens, and the configuration of the Dataiku Webapp backend to establish the connection.

### Create a Slack App

Navigate to <https://api.slack.com/apps> and create a new app. This is the app that you will later install into your Slack workspace to interact with the Dataiku Agent or LLM.

You can configure the app yourself or use our pre-configured defaults using a manifest.

#### Option 1: Quick Start (Manifest)

Use this manifest to create a pre-configured app. You can change the display names and descriptions to match your use case in the JSON, or configure that after the app creation.

Slack JSON manifest
    
    
    {
        "display_information": {
            "name": "Dataiku Agent App",
            "description": "App to interact with a Dataiku Agent through a bot.",
            "background_color": "#1c2a38",
            "long_description": "I'm a bot to interact with a Dataiku Agent. You can talk to me in direct messages or mention me in a channel I'm part of. I will reply in the same thread or start one and consider the thread as part of our conversation."
        },
        "features": {
            "app_home": {
                "home_tab_enabled": true,
                "messages_tab_enabled": true,
                "messages_tab_read_only_enabled": false
            },
            "bot_user": {
                "display_name": "Dataiku Agent",
                "always_online": true
            },
            "assistant_view": {
                "assistant_description": "I'm a Dataiku Agent!",
                "suggested_prompts": []
            }
        },
        "oauth_config": {
            "scopes": {
                "bot": [
                    "app_mentions:read",
                    "channels:history",
                    "chat:write",
                    "files:read",
                    "files:write",
                    "im:history",
                    "incoming-webhook",
                    "mpim:history",
                    "reactions:write",
                    "users:read"
                ]
            }
        },
        "settings": {
            "event_subscriptions": {
                "bot_events": [
                    "app_home_opened",
                    "app_mention",
                    "assistant_thread_started",
                    "message.im"
                ]
            },
            "interactivity": {
                "is_enabled": true
            },
            "org_deploy_enabled": false,
            "socket_mode_enabled": true,
            "token_rotation_enabled": false
        }
    }
    

#### Option 2: Standard Setup (From Scratch)

To configure your app manually, these are the settings required for the integration to function correctly:

**1\. Enable Socket Mode**

  1. In the left sidebar, select **Socket Mode**.

  2. Toggle **Enable Socket Mode** to ON if not enabled.




**2\. Configure Event Subscriptions**

  1. In the left sidebar, select **Event Subscriptions**.

  2. Under **Subscribe to bot events** , select **Add Bot User Event** and add the following events:


Event Name | Description | Required Scope  
---|---|---  
`app_home_opened` | User opened the App Home on Slack | none  
`app_mention` | Subscribe to only the message events that mention your app or bot | `app_mentions:read`  
`message.im` | A message was posted in a direct message channel | `im:history`  
  
### Generate an App Level Token

You need to generate an app-level token to enable socket mode.

  1. Go to [api.slack.com/apps](<https://api.slack.com/apps>), find your Slack app for this integration.

  2. In the left sidebar select “Basic Information”.

  3. Navigate to App-Level Tokens and select “Generate Token and Scopes”.

  4. Enter a name for the token and add the `connections:write` scope.

  5. Copy the App-Level Token (starts with `xapp-`) to configure in the Dataiku Slack Webapp later.




Thanks to Socket Mode, you do NOT need to configure the Events API URL nor expose your Dataiku instance.

Important

Each app-level token can only be used by one Dataiku WebApp on one Dataiku node. Sharing a token across multiple instances causes missing messages, as Slack randomly distributes events among connections.

### Install the Slack App to your Slack Workspace

  1. After configuring the bot and permissions, select “Install App”.

  2. Select “Install to (Workspace)” to add your app to your Slack workspace.

  3. Authorize the requested permissions when prompted.

  4. Copy the Bot-User OAuth Token (starts with `xoxb-`) to configure in the Dataiku Slack Webapp later.




Note

Since this installation uses socket mode, it is for internal workspace use only, the Slack app cannot be publicly distributed.

### Create and Configure the Visual Webapp in Dataiku

In the webapp edit tab, configure the following:

  * **Bot User OAuth Token** : (From the Slack App Install App or OAuth & Permissions Menu)

  * **App-Level Token** : (From the Slack App Socket Mode Menu)

  * Select the Dataiku Agent/LLM to use for generating responses.

  * Select “Save” to apply your configurations.




When you save the webapp, the backend should automatically start. You’ll see a notification indicating the backend is starting.

If the backend doesn’t start automatically:

  1. Go to the “Actions” panel on the right side of the screen.

  2. Select “Start backend” to manually start it.




Test the integration in Slack, as per the Usage section below.

## Usage

In Slack:

  1. Send a Direct Message to your bot.

  2. @mention your bot in a channel it has joined.




In both cases, the bot should respond with a message from your configured Agent/LLM.

### Adding Bots to Channels

After installation, your bot does not automatically have access to all channels.

  * You must explicitly invite your bot to channels, e.g. using `/invite @your_bot_name`.

  * For the bot to be usable in private channels, your app needs the `groups:history` and `groups:read` permissions.

  * Unless added to a channel, the bot won’t see messages or be able to respond in that channel.

---

## [agents/structured-visual-agents/blocks/agentic-loop]

# Agentic Loop

The Agentic Loop block implements the core “ReAct-style” loop, where the LLM plans, calls tools, and observes.

It is best suited for open-ended queries where the path to the solution isn’t fixed and needs to choose between several tools.

A Agentic Loop block is primarily defined by its LLM, its instructions, and its tools.

A Simple Visual Agent is conceptually the same thing as a Structured Visual Agent with a single Agentic Loop block.

## Exit Conditions

Most block types have a single “next block” field that specifies which block the control flow moves to when the block has finished executing. This connects multiple blocks into a graph.

The Agentic Loop block has more complex “exit conditions”.

The Agentic Loop block normally terminates when the underlying LLM decides that it does not need to call tools anymore. It will then usually output some text, which is its “answer”. If there is a “Default next block” defined on the Agentic Loop block, the control flow moves to this block. Else, control flow remains on the Agentic Loop block and it will usually resume at the next turn of the conversation.

It is also possible to make the Agentic Loop block terminate early and move to a different block with Exit conditions.

If exit conditions are defined, these are checked in order at the end of each react loop (after tools have been called).

If any exit condition evaluates to true, the control flow passes to the next block defined on that exit condition.

Four different types of exit conditions can be defined:

  * State has keys - True if the state contains all keys in a given list

  * Scratchpad has keys - True if the scratchpad contains all keys in a given list

  * Tools called - True if all the tools in a given list have been called

  * Expression - True if a given CEL expression is true




### Example use case

A key use case for Exit Conditions is the following: imagine an agent that is used by a Business Development Representative to prepare emails to send to prospects.

A first need is to identify precisely the prospect. For that, the Agent has a tool to query a prospect database. However, there are several similarly-named prospects. Thus, several iterations may be required to uniquely identify the prospect.

You would typically implement this with two Agentic Loop blocks and an exit condition:

  * The goal of the first Agentic Loop block is to uniquely identify the prospect, possibly over several turns

  * The first Agentic Loop block has no “default next block”, so it remains active over turns

  * Once ambiguities have been resolved, the first Agentic Loop block uses the “Set state” virtual tool to set the `prospect_id` state key

  * The first Agentic Loop block has a single exit condition: `State has key: prospect_id`

  * Thus, the first Agentic Loop block passes control to the second Agentic Loop block, which is tasked with actually working on the properly identified customer




## State and scratchpad virtual tools

In addition to the [explicitly defined tools](<../../tools/index.html>), you can enable virtual tools that make the LLM able to read and write the state and/or scratchpad.

The use case documented above uses this capability

## Forcing tool call arguments

Normally, all arguments of a tool call are defined by the LLM. However, there can be cases where you want to force the value of a given argument, in order to ensure that the LLM does not perform unwanted tool calls.

In the definition of each tool, you can use [CEL expressions](<../expressions.html>) to explicitly force the values of tool call arguments

## Using Agents as tools

In addition to the explicitly defined tools, you can also use any Agent, whether visual or code-based, as a tool, taking a question and returning a response. Simply select “Use a Sub-Agent” as the tool.

## History passing

Typically, the Agentic Loop block receives and uses the whole history of the conversation, so that it has context.

When the Agentic Loop block is used as a “helper” block, for a specific task, or within a Parallel or For Each block, it can make sense to disable history, and only prompt through [CEL templating](<../expressions.html>). In that case, you can disable history passing.

---

## [agents/structured-visual-agents/blocks/context-compression]

# Context Compression

The Context Compression block uses an LLM to summarize older messages, keeping the context window manageable.

You can configure a character threshold that triggers compression. When the conversation history exceeds this size, older messages are summarized. The “active buffer” setting controls how many recent messages are always kept as-is, uncompressed.

---

## [agents/structured-visual-agents/blocks/delegate]

# Delegate to Another Agent

This Block calls a preexisting Structured Visual Agent, Simple Visual Agent, Code Agent, or Plugin Agent.

---

## [agents/structured-visual-agents/blocks/foreach]

# For Each

The For Each block executes a single block sequence several times.

Each iteration of the sub-sequence gets its own independent scratchpad.

The sub-sequence can be made of several blocks. The same block transition logic occurs within the sub-sequence as within the “main” sequence. The sub-sequence can even be nested.

The For Each block takes a CEL expression as input, that must resolve to either a list or a dictionary.

  * **List** : Each value in the list is copied into a new CEL variable, which can be accessed by the sub-sequence blocks.

  * **Dictionary** : Each key/value pair is copied into a new CEL variable, which can be accessed by the sub-sequence blocks. This variable is itself a dictionary, with the following format: `{"key": input_dict_key, "value": input_dict_value}`.




## Example use case

Imagine an agent that needs to fetch news articles and summarize them. You want the summary to run for each article.

A first block in the Agent flow will fetch the news articles, and store in the state a list of the URLs. So for example you will have, in the state, the variable `urls`, containing `["url1", "url2", "url3"]`

You then use a for-each block, with expression `state.urls`, and with target block a Agentic Loop with a web scraping tool.

The expression resolves to a list of three items, so the Agentic Loop block will be called three times.

You configure the For Each block with `the_url` as the “Input variable name”. This means that for each iteration, there will be a variable `the_url` available for CEL templating, containing the URL for this particular iteration.

You can then, for example, in the Agentic Loop block, use the following settings:

  * Pass History: no

  * Tool: the web scraping tool

  * Instructions: `Fetch and summarize the article at {{the_url}}`




## Output

Once a For Each block completes, the text output of each iteration is written to a key in the state or scratchpad, that will contain the outputs of all the individual iterations. This output will be either a list or a dictionary, matching the type of the input.

  * **List** : Each value in the output list is the text result of the sub-sequence applied to the corresponding value from the input list.

  * **Dictionary** : The output dictionary contains the same keys as the input dictionary. Each value in the output dictionary is the text result of the sub-sequence applied to the corresponding key/value pair from the input dictionary.




## Cautions

Inherently, the For Each block is not interactive. If you are using a Agentic Loop block within a For Each block, it will not be possible to resume from it. When the Agentic Loop block within the For Each block terminates, control will move to the block after For Each.

Be very careful about writing to the state from a For Each block iteration, as several iterations may run in parallel. You should usually only write to the Scratchpad (there is one separate scratchpad per iteration)

---

## [agents/structured-visual-agents/blocks/generate-artifact]

# Generate Artifact

The Generate Artifact block uses an input [template](<../expressions.html>) to generate an artifact.

You can use this block to format results with a pre-determined structure.

There are three possible template types:

  * **CEL expansion** \- Define a CEL expression to generate a text or Markdown output

  * **Jinja template** \- Define a Jinja template to generate a text or Markdown output

  * **DocX Jinja expansion** \- Point to a managed folder containing a docx jinja template. This can generate a DOCX or PDF output.




This block produces an inline artifact, that is streamed to the user.

---

## [agents/structured-visual-agents/blocks/generate-text-output]

# Generate Text Output

Output of the Agent to the user is primarily created by the [Agentic Loop](<agentic-loop.html>) and [LLM Request](<llm-request.html>) blocks. In both of these blocks, the LLM ultimately generates text that can be sent to the user.

However, you may want more control on what exactly the Agent responds to the user. For that, you can use the Generate Text Output block.

The Generate Text Output block contains a CEL or Jinja [template](<../expressions.html>), that is expanded and evaluated using the current state and scratchpad.

This can be used, for example:

  * At the end of the turn to provide an answer with predictable formatting

  * Before a long operation, to indicate to the user that this will take some time.




The output of this block can also be saved to the state, scratchpad, or conversation history, as well as being streamed to the user.

---

## [agents/structured-visual-agents/blocks/index]

# Blocks

Structured Visual Agents use an array of blocks, each serving a distinct purpose.

---

## [agents/structured-visual-agents/blocks/llm-request]

# LLM Request

The LLM Request Block makes a single LLM call with no tools.

This can be used to generate a single LLM response to an input query. For example, translating a query into another language, or summarizing a long input text.

---

## [agents/structured-visual-agents/blocks/long-term-memory]

# Long-Term Memory

In a Structured Visual Agent, the State provides conversation-scoped memory, often called Short-Term Memory.

A common need in Agentic use cases is for the Agent to remember user preferences and information over time, in order to provide better assistance. This is called **Long-Term Memory**.

Structured Visual Agents provide two blocks for managing Long-Term Memory:

  * **Store in Long-Term Memory** \- Typically runs at the end of a turn and detects elements of the conversation that need to be remembered (either because it’s deemed important, or because the user explicitly asked for it)

  * **Retrieve from Long-Term Memory** \- Typically runs at the beginning of a turn, and searches within the user’s Long-Term Memory, to add relevant facts and episodes, in order to help the Agent make better decisions and better respond to the user.




## Setup

These blocks are provided by the “Agent Long-Term Memory” plugin, which you need to install.

These blocks require that the Agent runs in a specific Code Env, which you can configure in the “Settings” tab of the agent. The Code Env needs to contain the “pysqlite3” and “sqliteai-vector” packages.

## Types of memory items

The blocks handle two types of memory items, “facts” and “episodes”:

  * **Facts** \- typically include curated, “factual” information such as “The user prefers the color blue”. The “Retrieve from Long-Term Memory” block retrieves all facts for the user (up to a configurable limit) and then uses an LLM query to filter facts that seem relevant to the current state of the conversation.

  * **Episodes** \- elements from the past that are worth remembering but are not as strong as facts. They are often used when the user says something like “Remember when we talked about that? I want to get back to this”. The “Retrieve from Long-Term Memory” block uses semantic search to retrieve past episodes that may be relevant to the current conversation.




## Memory banks

Both blocks can implement one or several memories per project. Each block references a “memory bank”, which is an identifier.

If you don’t configure an identifier, a default project-level memory bank is used. This allows sharing memory between agents of the same project.

If you do configure an identifier, a specific memory bank is used, if you don’t want memory from other agents to interfere.

Within each memory bank, memories are stored and retrieved separately per-user.

---

## [agents/structured-visual-agents/blocks/manual-mandatory-tool-call]

# Manual and Mandatory Tool Call

These two blocks allow you to perform highly controlled calling of tools and storing of results.

The Mandatory Tool Call block uses a LLM to craft the arguments to pass to a tool, then forces the LLM to call exactly this tool, exactly once.

The Manual Tool Call lets you entirely write the arguments to pass to the tool, using [CEL expressions](<../expressions.html>)

You can then decide what to do with the output of the tool call:

  * Store it into the state

  * Store it into the scratchpad

  * Add it to the conversation history, so that it can be picked up by subsequent Agentic Loop or LLM Request blocks

---

## [agents/structured-visual-agents/blocks/parallel]

# Parallel

The Parallel block executes several block sequences in parallel.

Each sub-sequence gets its own independent scratchpad.

Each sub-sequence can be made of several blocks. The same block transition logic occurs within each sub-sequence as within the “main” sequence. These sub-sequences can even be nested.

The Parallel block terminates when all of the subsequences have terminated.

For example, in the above example, the parallel block targets the “Fetch authorized discount” and “Detect Intent” chains, but each is made of several blocks. The Parallel block will only complete when both:

  * Compute possible discount has terminated

  * Either “Respond to Dispute” or “Respond to incident report” has terminated (based on which way the Routing block sent this subsequence)




The Generate action report block will then execute.

## Output

Once a parallel block completes, it’s possible to grab the text output of each sub-sequence, and to create a key in the state or scratchpad, that will contain a list of the outputs of each individual sub-sequence.

## Cautions

Inherently, the parallel block is not interactive. If you are using a Agentic Loop block within a Parallel block, it will not be possible to resume from it. When the Agentic Loop block within the Parallel block terminates, control will move to the block after Parallel.

Be careful about writing to the state from a sub-sequence of a Parallel block, as you are not guaranteed isolation.

---

## [agents/structured-visual-agents/blocks/python]

# Python Code

The Python Code block lets you execute fully custom logic within a Structured Visual Agent.

The block expects a Python function that can yield one or more output chunks. Each chunk is streamed to the user as soon as it is produced. Chunks can be a plain string, or a dict of the form `{"chunk": {"text": "..."}}`. To control which block runs next, yield a `NextBlock` object.

---

## [agents/structured-visual-agents/blocks/reflection]

# Reflection

The Reflection block uses an LLM-as-a-judge to critique or synthesize outputs of another block (the “generator” block).

There are three modes:

  * **Critique and Improve** \- The generator block runs, and its output is critiqued against an expectations prompt. If the output does not meet expectations, the generator block re-runs with the provided critiques as input. This repeats up to a configurable maximum number of iterations.

  * **Critique or Retry** \- Similar to Critique and Improve, but the critiques are not provided to the generator block. The generator block is retried from scratch if the critique fails.

  * **Synthesize** \- The generator block runs several times in parallel, and an LLM then synthesizes the results into a single, consolidated output.

---

## [agents/structured-visual-agents/blocks/routing]

# Routing

The Routing block is one of the key elements of a complex Structured Visual Agent, allowing you to dispatch to different processing sequences depending on conditions.

The purpose of the routing block is to decide the next node in the control flow.

There are three modes of routing:

  * **If-Then / Else-if Clauses** \- A list of clauses are checked in order, the first one matching determining the next block

  * **LLM Dispatch** \- An LLM is called, with a prompt, to determine the next block

  * **Expression Dispatch** \- A CEL expression is used to compute the next block




The If-Then / Else-if Clauses type has a variety of different clause types that can be used:

  * **State Has Keys** \- True if the state contains all keys in a given list

  * **Scratchpad Has Keys** \- True if the scratchpad contains all keys in a given list

  * **Tools Called In History** \- True if all the tools in a given list have been called in the message history of the current sequence

  * **Expression** \- True if a given CEL expression is true

  * **And (combine clauses)** \- Combine two or more clauses with an AND expression

  * **Or (combine clauses)** \- Combine two or more clauses with an OR expression

  * **LLM based decision** \- True if the given LLM outputs a truthy statement based on the message history and given prompt

---

## [agents/structured-visual-agents/blocks/semantic-feedback]

# Semantic Feedback Management

A common need in Agentic use cases is for the Agent to improve over time, as it gets more feedback about its actions.

Feedback can take two main forms:

  * Explicit feedback: the user clicked a “thumbs-up” / “thumbs-down” control, and optionally gave explicit indication of what was right or wrong. Explicit feedback is then typically stored in a dataset.

  * Implicit feedback: the user stopped interacting, told the Agent it was wrong, or lost their calm




Structured Visual Agents provide two blocks for managing feedback:

The first block typically runs at the end of a conversation turn and detects implicit feedback, which is then stored in a dataset.

In a typical case, there would then be a manual curation phase, where both detected implicit feedback, and user explicit feedback are reviewed, curated, merged, in order to create a unified feedback dataset, with entries such as:

  * Kind of feedback: positive, correction, constraint, warning of a typical failure pattern

  * Content of the feedback




The second block then typically runs at the start of a conversation turn. It then performs a semantic search within the unified feedback dataset, detects which feedback items are relevant to the current conversation, and inject them in the context, so that the LLM underlying the agent can read it and help steer its behavior

## Setup

These blocks are provided by the “Agent Semantic Feedback” plugin, which you need to install.

These blocks require that the Agent runs in a specific Code Environment, which you can configure in the “Settings” tab of the agent.

The Code Environment needs to contain the following packages:

> 
>     pysqlite3
>     sqliteai-vector
>     

The Semantic Feedback blocks require a `Managed Dataset` with the following fields

  * **kind** \- string

  * **content** \- string




The dataset will be automatically filled by using the Semantic Feedback blocks in your agentic flow.

## Usage

The Detect Feedback block writes into a dataset. The Use Feedback block reads from a dataset. While they can be the same, these two datasets are typically separate, due to the mentioned curation, deduplication and unification process, which is handled as part of a regular Dataiku Flow.

---

## [agents/structured-visual-agents/blocks/state-scratchpad]

# Set State and Scratchpad entries

These two blocks allow you to create more entries in the state or scratchpad. Each entry is defined by a [CEL expression](<../expressions.html>)

For more details about state and scratchpad, please see [Key concepts](<../concepts.html>)

---

## [agents/structured-visual-agents/concepts]

# Key concepts

The below key concepts will help you efficiently design Structured Visual Agents.

## Blocks

The basic component of a Structured Visual Agent is the **Block**. The Agent’s control flow moves between blocks, which are linked in a graph.

Most blocks have a single “next block” field, which indicates which block executes after it. Some blocks, such as the “Routing” block, can use conditional logic to branch to multiple outputs.

Other blocks can “nest” sequences of blocks. For example the “Parallel” block executes in parallel several sequences of blocks, until each sub-sequence is completed.

For more details, please see [Blocks](<blocks/index.html>).

## State and Scratchpad

A key feature of Structured Visual Agents is the ability to remember information between blocks, and between turns (i.e. when the conversation goes back to the user).

For that, they use two objects, the **State** and the **Scratchpad** :

  * **State** is a persistent conversation-scope memory. It persists between blocks, but also across turns. For example, an agent acting as a Customer Support Representative will probably lookup information about the Customer as one of its first steps, and then store it in the State, so that it can then refer to it. The State persists across turns, so that the Agent does not need to look it up afterwards

  * **Scratchpad** is a very short term memory. It only remembers information across a single sequence of blocks, and is not kept across turns. It can be used to remember heavy information that is not worth remembering across turns. The Scratchpad is also key when using “nested” blocks. For example, the “for each” block runs a sequence of blocks several times (by iterating on a list of tasks / things to check). The nested block sequence will thus execute several times, possibly in parallel. Thus, if it wrote to the global State, it would overwrite its own work each time. Instead, each iteration of the “for each” loop gets its own scratchpad, and can work directly with it, knowing that there is no risk of conflict with other iterations.




The state and scratchpad are dictionaries of key-values.

The state and the scratchpad can be _written_ either:

  * Through explicit dedicated blocks (“Set state entries” and “Set scratchpad entries”)

  * Through Custom Python blocks

  * Through “virtual tools” that can be given to the Agent, where the LLM will decide to read or write things in the state/scratchpad based on instructions




The state and the scratchpad can be _read_ :

  * In the Set state entries / Set scratchpad entries block

  * Through Custom Python blocks

  * Through “virtual tools” that can be given to the Agent, where the LLM will decide to read or write things in the state/scratchpad based on instructions

  * Through expansion in various prompt / instructions fields (see below)




## Expressions and templating

A key concept that makes Structured Visual Agents powerful is their ability to pass and use structured information between blocks. This is done notably through **Expressions** and **Templating**

For example, if the state has been filled with two keys, customer_lifetime_value and average_discount_rate, you can create a new state key indicating the discounted value using expression `state.customer_lifetime_value * state.average_discount_rate`. This is an expression.

In virtually all locations in Structured Visual Agents where you can enter text, you can use templating to replace parts of the text with references to expressions.

For example, you can write an agent prompt like below, to dynamically inject context into the prompt.
    
    
    You are working for a customer whose first name is {{ state.customer_first_name }}.
    Make sure to address them using their first name.
    

For more details, please see [Expressions and templates](<expressions.html>)

## Starting block and subsequent turn behavior

Each Structured Visual Agent has a single “Starting Block”, which is where a new conversation starts. While executing, control flow moves from block to block, until there is no “next block”. When this happens, the turn finishes.

If the Agent is used in conversational mode (through a Chat UI, for example), the Agent must decide what to do on subsequent turns.

The key options are:

  * Go to the starting block

  * Resume at the last block of the previous turn




Some blocks are inherently “restartable”, i.e. it makes sense to restart the next turn on this block, because it can do something new. This is the case, in particular, of the “Agentic Loop” block, which implements the core Agentic/Tool-Calling loop. When restarted, the conversation with the LLM simply continues.

However, for some blocks, it does not make sense to restart on them. For example, if the last block of a turn was a “Generate Report” block that generated a PDF report of the conversation, trying to restart on this block would simply generate the same report. It means that in that case, you probably don’t want to restart at the last block of the previous turn.

Thus, restarting at the last block only truly makes sense if the previous turn ended on a restartable block.

Restarting at the last block has the advantage of being very easy, but can also create situations where your agent can become “locked in to a topic”. For example, if your Agent uses a Routing block to dispatch based on the detected intent, if the user tries to change topics during a conversation, it can be difficult to “go back”.

On the other hand, restarting from the starting block at each turn means that you need to implement a full logic at the beginning of your sequence to “go-to” the proper block if needed. For example, if your agent starts by fetching customer information, you’ll need to implement as a first block a routing block that checks “do I already have the customer information in the state”, in order to skip the information retrieval on subsequent turns.

To help with this choice, Structured Visual Agents also implement a **Smart mode** for next-turn behavior, which uses a LLM to detect whether it’s better to restart at the beginning or at the last block, notably by detecting if the user’s intent has changed.

## Pre-turn and post-turn blocks

There are many cases where you want to always perform actions at the start of a turn, or at the end of the turn, regardless of the main control flow.

Some examples include:

  * Gather facts from long-term memory at the start of each turn

  * Checking custom permissions at the start of each turn

  * Call Guardrails at the end of each turn

  * Detect if the user gave negative feedback at the end of each turn




Implementing these in the main control flow could become too complex. Thus, Structured Visual Agents implement a “pre-turn” and “post-turn” sequence of blocks, that are guaranteed to always execute.

---

## [agents/structured-visual-agents/expressions]

# Expressions and templates

At various places in the configuration of blocks, you can write expressions. Expressions use a simple variant of the CEL language.

Some fields in the UI accept a CEL expression (e.g. setting state entries, defining exit conditions) whereas other fields accept a string containing CEL templates (e.g. instructions for agentic loop and LLM request blocks)

An expression is a snippet of CEL that will be evaluated, such as `state.x + state.y`

A templated string is a string that can contain placeholders which contain CEL expressions, for example `Always answer the user in {{state.language}}`

## CEL expressions

CEL is a simple expression language that uses a Python-like expression syntax, with some custom functions and variables tailored to Structured Visual Agents.

  * Data types: number, string, list, dictionary (as in Python)

  * Boolean operators: `and`, `or`, `not`

  * Comparison operators: `==`, `!=`, `<`, `<=`, `>`, `>=`

  * Numerical operators: `+`, `-`, `*`, `/`, `mod`, `pow`

  * Regular parentheses for operator precedence

  * String functions: `upper`, `lower`, `trim`, `matches` (regex)

  * Dict and list functions: `len`, `length`

  * List functions: `sum`

  * Conversion functions: `string`, `str`, `int`

  * JSON functions: `to_json` (dict -> str or list -> str), `parse_json` (str -> list or str -> dict)




Within a CEL expression the following variables are available:

  * `state`: a dictionary

  * `scratchpad`: a dictionary

  * `context`: a dictionary

  * `last_output`: a string containing the text output of the last block




Advanced variables:

  * `initial_messages`: messages passed into this turn

  * `generated_messages`: messages generated during this turn

  * `all_messages`: (initial_messages + generated_messages)




## CEL templates

CEL templates contain CEL expressions delimited by `{{ }}`. They are usable in most “Instructions”-type fields

## Jinja

Jinja is an alternative templating language, with more power than CEL.

It is usable in the Generate Text Output block and in the Generate Artifact block.

An example of using Jinja to generate an agent response, using Markdown that can be rendered in the DSS chat interface:
    
    
    <hr>
    
    
    Messages:
    {% for message in all_messages %}
    
    {{ message }}
    
    {% endfor %}
    
    
    <hr>
    
    
    State:
    {% for key, value in state.items() | sort %}
    
    ```
    {{ key }}: {{ value }}
    ```
    
    {% else %}
    
    (empty)
    
    {% endfor %}

---

## [agents/structured-visual-agents/how-to/conversational-disambiguation]

# Conversational Disambiguation: Force an agent to uniquely identify the subject of discussion before moving on

Imagine an agent that is used by a Business Development Representative to prepare emails to send to prospects.

A first need is to identify precisely the prospect. For that, the Agent has a tool to query a prospect database. However, there are several similarly-named prospects. Thus, several iterations may be required to uniquely identify the prospect.

You would typically implement this with two Agentic Loop blocks and an exit condition:

  * The goal of the first Agentic Loop block is to uniquely identify the prospect, possibly over several turns

  * The first Agentic Loop block has no “default next block”, so it remains active over turns

  * Once ambiguities have been resolved, the first Agentic Loop block uses the “Set state” virtual tool to set the `prospect_id` state key

  * The first Agentic Loop block has a single exit condition: `State has key: prospect_id`

  * Thus, the first Agentic Loop block passes control to the second Agentic Loop block, which is tasked with actually working on the properly identified customer

---

## [agents/structured-visual-agents/how-to/index]

# How to …

This section focuses on how you can use Structured Visual Agents to solve some complex Agentic use cases, with no-to-minimal coding.

---

## [agents/structured-visual-agents/index]

# Structured Visual Agents

Structured Visual Agents are an advanced type of visual agent, composed of a sequence of blocks.

Structured Visual Agents can visually implement complex agentic logic, in a fully transparent and controllable manner, with support for deterministic logic.

Recommendation: Before using Structured Visual Agents, familiarize yourself with [Simple Visual Agents](<../visual-agents.html>).

---

## [agents/structured-visual-agents/overview]

# Overview and example use cases

Some use cases for Structured Visual Agents include all cases where your desired Agentic Logic cannot be expressed by a simple “ReAct-style” tool-calling loop.

## Predefined sequence of steps and branches

Imagine an issue analysis agent. An employee enters the description of an issue. The agent then follows a set of predefined steps:

  * Gathering information through multiple knowledge banks and datasets to get identifiers for previous similar incidents

  * Identifying possible root causes

  * If an obvious root cause is identified, skip to synthesis step

  * Else, investigate several possible root causes in parallel, by using several agents, each one searching in different possible data

  * Synthesizing all previous steps to generate a final report for the user




Enforcing this logic would be difficult in a Simple Visual Agent.

## Gathering “mandatory” information at the beginning of the conversation

For example, an agent responding to customer support enquiries may want to gather all information about the customer, their subscriptions, etc… at the beginning of a conversation.

While a Simple Visual Agent can have these tools at its disposal, it’s hard to guarantee that it would call all of them and properly gather all information prior to the run.

---

## [agents/teams]

# Microsoft Teams Integration

## Overview

The Microsoft Teams Integration serves as a bridge between Microsoft Teams and Dataiku’s Generative AI capabilities. It allows users to interact with Dataiku Agents and LLMs directly within Teams, enabling seamless access to data insights and automated responses in both chats and channel conversations.

**Key Features**

  * **Interactive Bot:** Chat directly with Agents configured in Dataiku.

  * **Azure Bot Service Integration:** Use Azure Bot Service to connect Microsoft Teams to your Dataiku webapp backend.

  * **Teams Conversation Support:** Works in chats and in channel conversations where the app has been added.




## Setup

### Pre-requisites

The Microsoft Teams Integration is provided by the “Dataiku Agents on Microsoft Teams” plugin, which you must install. Please see [Installing plugins](<../plugins/installing.html>).

You will need administrative access to Microsoft Azure and Microsoft Teams, alongside write permission in a Dataiku Project and code execution permission to configure the integration.

The Microsoft Teams Integration uses a webapp in DSS, with the backend exposing the messaging endpoint used by Azure Bot Service and relaying messages back & forth between Microsoft Teams and the Agent. The backend must be running to process events. Enable `auto-start backend` in the `Edit` tab to ensure it runs automatically.

DSS must be reachable through a public HTTPS URL so Microsoft Azure can call the messaging endpoint exposed by the webapp. DSS must also have outbound network access.

This section details the setup of the Azure Bot resource, the generation of the necessary credentials, and the configuration of the Dataiku Webapp backend to establish the connection.

### Create the Azure Bot Service

Navigate to <https://portal.azure.com> and create the bot resources. This is the bot that you will later install into Microsoft Teams to interact with the Dataiku Agent or LLM.

During setup, make sure you:

  * Create an **Azure Bot** resource. If you choose **Create new Microsoft App ID** , Azure will also create the related **App Registration**. You can also create the app registration in advance and link it during bot creation.

  * Under **Azure Bot - > Settings -> Configuration**, set **Messaging Endpoint** to your DSS public base URL plus the endpoint displayed in the Dataiku webapp setup page.

  * Under **Azure Bot - > Settings -> Channels**, add the **Microsoft Teams** channel.




Note

The full messaging endpoint must be publicly accessible over HTTPS.

If Microsoft Teams and the Azure Bot resource run in different tenants:

  1. Go to the **App Registration** linked to the **Azure Bot** that you created.

  2. In **Azure Bot - > Settings -> Configuration**, select **Manage Password** next to **Microsoft App ID** to open the corresponding app registration.

  3. Under **Manifest** , make sure the JSON contains the following values:
         
         "accessTokenAcceptedVersion": 2,
         "signInAudience": "AzureADandPersonalMicrosoftAccount"
         

  4. Save the manifest.




### Generate App Credentials

To let Dataiku authenticate with your bot, create the application credentials in Azure:

  1. Go to the **App Registration** linked to the **Azure Bot** that you created.

  2. In **Azure Bot - > Settings -> Configuration**, select **Manage Password** next to **Microsoft App ID** to open the corresponding app registration.

  3. Under **Certificates & secrets**, create a new client secret.

  4. Copy the secret value immediately and store it somewhere safe. Azure will not show it again.

  5. In the **Overview** tab, also copy the **Application (client) ID**.




Important

Treat your client secret like a password. Never share it or commit it to version control. If it is compromised, rotate it immediately in the Azure portal.

### Create and Configure the Visual Webapp in Dataiku

In the webapp `Edit` tab, configure the following:

  * **Azure Tenant ID** : Paste the Microsoft Entra tenant ID where your Azure Bot and app registration are hosted.

  * **Azure Bot Service Microsoft App ID (client ID)** : Paste the application client ID.

  * **Azure Bot Service Microsoft App Password (client secret)** : Paste the bot client secret.

  * **Agent/LLM** : Select the Dataiku Agent or LLM to use for generating responses.




Save to apply your configurations.

When you save the webapp, the backend should automatically start (a notification indicates that the backend is starting).

If the backend does not start automatically:

  1. Go to the **Actions** panel on the right side of the screen.

  2. Select **Start backend** to manually start it.




In the backend configuration:

  * Make sure **Auto-start backend** is enabled.

  * Make sure **Require authentication** is disabled.




Note

For Dataiku Cloud, add the webapp ID to **Administration - > Settings -> Security & Audit -> Other security settings -> Webapps -> Public webapps**.

### Test the Bot in Azure

Before installing the app in Microsoft Teams, run a quick test in Azure to confirm that Microsoft can reach your Dataiku webapp.

  1. In the **Azure Bot** resource, open **Settings - > Test in Web Chat**.

  2. Send a message in the chat window. The Agent or LLM you configured earlier should respond.

  3. Check the DSS webapp **Logs** tab if the bot does not respond.




### Generate the Teams App Manifest

Before you can install the Agent in Teams, you need a **Teams app manifest**. You can create one in the [Teams Developer Portal](<https://dev.teams.microsoft.com>) or with the manifest creator available in the webapp.

  1. Scroll down to the **Manifest creator** card in the webapp.

  2. Enter the Teams app details you want to use, such as the name and icons.

  3. Select **Create manifest zip** to download the manifest.




### Install the App in Teams

Upload the manifest to **Microsoft Teams** or to your organization’s app catalog.

  1. In Teams, open **Apps** in the left sidebar, then select **Manage your apps**.

  2. Select **Upload an app** , then choose the manifest zip file that you created earlier.




Note

You may need administrator approval before you can install the app.

Test the integration in Microsoft Teams, as per the Usage section below.

## Usage

In Microsoft Teams:

  1. Open the bot in a chat, or add the app to a channel where you want to use it.

  2. Send a message in the chat or `@mention` the app in a channel where it has been added.

  3. Check the DSS webapp **Logs** tab if the bot does not respond.

---

## [agents/tools/api-endpoint]

# API Endpoint Tool

This tool allows interaction with any API endpoint deployed via Dataiku.

It requires a single input: an API Endpoint that has been deployed through Dataiku.

To use this tool, the following conditions must be met:

  * Authorization to query via the deployer must be granted within the deployment settings.

  * The endpoint must have an OpenAPI specification that defines the input schema and includes detailed documentation for each parameter. This is required for the underlying LLM to understand how to interact effectively with the endpoint.

---

## [agents/tools/calculator]

# Calculator tool

This tool calculates a formula using the [Formula language](<../../formula/index.html>).

This tool extends the capabilities of the agent with arithmetic operators, arithmetic functions, trigonometry functions, boolean operators, date functions, and geometry functions.

The input to this tool is the formula to calculate as a string. The formula should be correct according to the Formula Language, otherwise, the tool will throw an error.

---

## [agents/tools/custom-tools]

# Writing your own tool

In addition to the prebuilt tools, you can build your own, in two different ways:

  1. Using an inline code tool in DSS

  2. Writing a plugin




## Inline code tool

Custom Tools can be written inline in Python code within DSS. They then become available for users who can leverage these tools without having to write or manage code.

## Plugin tools

Custom Tools can be written in plugins. Like with all plugin components in Dataiku, this allows builders to write the code once and define the parameters. They then become available as code-free interfaces for users who can leverage these tools without having to write or manage code.

We recommend that you look at our sample Google Search tool to get information on how to write a custom tool.

---

## [agents/tools/databricks-genie]

# Databricks Genie Tool

The Databricks Genie tool leverages an existing Databricks Genie space in order to answer questions from a set of Databricks tables connected to the Genie space.

It empowers other agents to query structured data using Databricks Genie (Text-to-SQL).

## Prerequisites

The Genie Tool is provided by the “Databrick AI” plugin, which you need to install.

You need:

  * A Databricks Workspace with Model Serving enabled.

  * A Dataiku Connection to Databricks configured with either a Personal Access Token or OAuth2 credentials.

  * A configured Databricks Genie Space with tables accessible to the default role of the Dataiku Connection




## Usage

The tool only requires a Databricks Connection and the Space ID of your Genie space (which can be found in the Databricks Genie URL)

---

## [agents/tools/databricks-vector-search]

# Databricks Vector Search Tool

The Databricks Vector Search tool leverages an existing Databricks vector search index, and provides semantic document retrieval capabilities.

It empowers other agents to query data stored in a Databricks vector search index.

## Prerequisites

The Databricks Vector Search Tool is provided by the “Databrick AI” plugin, which you need to install.

You need:

  * A Databricks Workspace with Model Serving enabled.

  * A Dataiku Connection to Databricks configured with either a Personal Access Token or OAuth2 credentials.

  * A configured Databricks Vector Search index




## Usage

You need to configure:

  * The Databricks Connection

  * The Vector Search endpoint and index (possible values will be automatically fetched)

  * The list of columns to return

---

## [agents/tools/dataset-append]

# Dataset Append tool

This tool can append records to a dataset.

You configure it with the dataset to write into, as well as the columns to write.

---

## [agents/tools/dataset-lookup]

# Dataset Lookup tool

The Dataset Lookup tool searches for and retrieves records from a Dataiku dataset.

## Configuration

Configure the tool by specifying the dataset to search.

## Usage

To use the tool, provide a filter to specify the search criteria. Construct the filter clause programmatically with the [`DSSSimpleFilter`](<https://developer.dataiku.com/latest/api-reference/python/utils.html#dataikuapi.dss.utils.DSSSimpleFilter> "\(in Developer Guide\)") helper class.

The filter clause supports the following operators:

  * `EQUALS`

  * `NOT_EQUALS`

  * `GREATER_THAN`

  * `LESS_THAN`

  * `DEFINED`

  * `NOT_DEFINED`

  * `CONTAINS`

  * `MATCHES` (for regular expressions)

  * `AND`

  * `OR`




To find the call schema of the tool, use its descriptor. See [Using tools](<using-tools.html>) for more details.

## Limitations

This tool is designed for looking up and returning a small number of records. It does not support aggregations, sorting, or other complex queries. For these use cases, use the [SQL Query tool](<sql-question-answering.html>).

---

## [agents/tools/google-calendar]

# Google Calendar

## Create Google Calendar Event

This tool is provided by the “Google Calendar” plugin, which needs to be installed.

First, login to the Google Developer Workspace, create a project, and enable the Google Calendar API. Then, create a Client in the Google Auth platform and retrieve a Client ID and Client secret. In the plugin Settings -> Google Single Sign On, create a new preset, enter the Client ID and Client secret, and grant access to user groups.

If you are an end user of the tool or a builder wanting to test the tool, go to your personal Profile & Settings -> Credentials -> Plugins -> Google Calendar -> your new preset, then authenticate to Google.

The Create Google Calendar Event tool will create an event in the calendar configured by the user running the agent.

When creating a tool instance in a project, choose an SSO preset from earlier, and optionally enter a calendar ID linked to your Google account (the default is the primary calendar).

The tool can add an event title, location, description, start time, end time, and add other attendees by email.

Test your Create Google Calendar Event tool in the “Quick test” tab:
    
    
    {
        "input": {
            "summary": "Your title",
            "location": "Your location",
            "description": "Longer description",
            "start": "2025-05-06T19:00:00Z",
            "end": "2025-05-06T20:00:00Z",
            "attendees": "[[email protected]](</cdn-cgi/l/email-protection>),[[email protected]](</cdn-cgi/l/email-protection>)"
        },
        "context": {}
    }

---

## [agents/tools/google-search]

# Google Search Tool

This tool is provided by the “Google Search Tool” plugin, which needs to be installed.

This tool uses Google Custom Search JSON API (also known as Programmable Search Engine) to provide the ability to perform web searches. It is a powerful feature that provides your agent with access to real-time information from the internet, significantly expanding its knowledge base beyond its training data.

To configure the tool, you will need to provide:

  * A **Google CustomSearch cx id** : The unique identifier for your Google Programmable Search Engine. This id specifies which engine’s configuration to use when performing a search. For instructions, see Google’s guide on [Creating a Programmable Search Engine](<https://developers.google.com/custom-search/docs/tutorial/creatingcse>)

  * An **API Key** : Your unique API key used to authenticate your application’s requests to the Custom Search JSON API. To obtain a key, please refer to the documentation on [Identifying your application to Google](<https://developers.google.com/custom-search/v1/introduction#identify_your_application_to_google_with_api_key>)




Upon a successful query, the tool returns a structured list of search results directly from Google, including titles, links, and snippets for each source.

Please note that this tool requires the agent to have outgoing Internet access.

Test your Google Search tool in the **Quick test** :
    
    
    {
        "input": {
            "q": "Your google search query"
        },
        "context": {}
    }

---

## [agents/tools/human-approval]

# Human approval

For some tools performing sensitive actions, it may be desirable to enforce that the human user is able to review tool calls before they are actually executed by the agent. This is possible with Dataiku managed tools by enabling human approval in the tool settings.

When human approval is enabled for a given tool, visual agents will pause before making a call to this tool to ask the user for confirmation.

It’s also possible to allow the user to manually edit the inputs of the tool call when reviewing pending tool calls, by enabling this option in the human approval settings of the tool.

Note

Structured Visual agents support human approvals within the main block sequence, but not within sub-sequences. So approvals cannot be used within subsequences of the [For Each](<../structured-visual-agents/blocks/foreach.html>), [Parallel](<../structured-visual-agents/blocks/parallel.html>), or [Reflection](<../structured-visual-agents/blocks/reflection.html>) blocks.

---

## [agents/tools/image-generation]

# Image Generation tool

The Image Generation tool generates one or more images from a text prompt by calling an image generation model from the [LLM Mesh](<../../generative-ai/llm-connections.html>).

## Configuration

Configure the tool by selecting an image generation LLM and adding optional custom instructions. The number of images can be configured, as well as the width and height of the generated images.

You can configure whether generated images are returned:

  * as artifacts

  * as inline image parts sent back to the calling LLM or agent

  * or both




## Limitations

This tool requires an image generation model configured in the LLM Mesh.

Some providers or models may enforce their own limits on the number of generated images or on supported output dimensions.

---

## [agents/tools/index]

# Managed tools

Dataiku includes a complete system for managing tools. Dataiku provides many kinds of tools that are built into the platform, and provides extensibility for users to add their own kinds of tools.

The tools managed by Dataiku include security, audit, and most can be configured visually, allowing you to focus on building your Generative AI Application rather than the plumbing of tools.

Tools are created by clicking on the Generative AI Menu (pink graph) then “Agent Tools”.

---

## [agents/tools/jira]

# Jira

## Create Jira Issue

This tool is provided by the “Jira” plugin, which needs to be installed.

In the plugin Settings -> Jira connection, create a new preset to connect to a Jira instance (cloud or on premise) using a username and API token.

When configuring a tool instance in a project, choose a Jira connection preset and enter the Jira project key where new issues will be added.

The tool can populate an issue summary and description.

Test your Create Jira Issue tool in the “Quick test” tab:
    
    
    {
        "input": {
            "summary": "Your issue summary",
            "description": "Longer description"
        },
        "context": {}
    }

---

## [agents/tools/knowledge-bank-search]

# Knowledge Bank Search tool

This tool searches for relevant documents in a Knowledge Bank.

Importantly, this tool is a search/retrieval tool. It does not perform “Retrieval-Augmented Generation”: it does not “generate an answer” but simply returns matching documents. Generating the answer is the responsibility of the calling agent.

## Core configuration

You configure the Knowledge Bank to use for the tool. For more information on how to build Knowledge Banks, see [documentation about Knowledge bank](<../../generative-ai/knowledge/index.html>).

## Retrieval settings

The tool supports a variety of search options, some depending on the underlying vector store of the Knowledge Bank. The Knowledge Bank Search tool has the same retrieval options as the builtin RAG. See [Search settings](<../../generative-ai/knowledge/kb-search-settings.html>) for details about the retrieval settings.

## Sources

In order for the [Chat UIs](<../../generative-ai/chat-ui/index.html>) or your own application to properly display documents, the tool returns rich source items, that can include a title, text, URL (for building a link to the document, for example in your Sharepoint site) and thumbnail URL (for displaying an image next to the result).

All of these are configured by optionally selecting which meta stored in the Knowledge Bank holds the information. Stored meta are configured in the embedding recipes.

## Filtering

You can apply filters to the Knowledge Bank search tool in several ways

### Static filtering

Define a static filter to permanently restrict the tool to a subset of the documents in the Knowledge Bank. This is useful for creating specialized tools that should only ever search over a specific portion of your data.

### Dynamic filtering

Enable dynamic filtering to allow the calling application to provide filters for each query. Filters are passed in the context using the callerFilters key. You can specify any number of filters in callerFilters. callerFilters takes a filter property.

The filter clause can be constructed programmatically with the [`DSSSimpleFilter`](<https://developer.dataiku.com/latest/api-reference/python/utils.html#dataikuapi.dss.utils.DSSSimpleFilter> "\(in Developer Guide\)") helper class. Additionally, if called from an agent, you can specify a toolRef parameter to only apply the filter to relevant knowledge bank search tools.
    
    
    {
       "input": {
          "searchQuery": "Enter search query here"
       },
       "context": {
          "callerFilters": [
              {
                 "filter": {
                     "operator": "AND",
                     "clauses": [
                        { "column": "Category", "operator": "EQUALS", "value": "Economy"},
                        { "column": "Year", "operator": "GREATER_THAN", "value": 2012},
                        { "column": "Month", "operator": "IN_ANY_OF", "value": ["January", "February", "March"]}
                    ]
                 },
                 "toolRef": "optional tool ref"
              }
          ]
       }
    }
    

### Agent-inferred filtering

Enable agent-inferred filtering to empower the agent to generate filters automatically based on the user’s prompt.

When this is enabled, you must specify which columns the agent is allowed to filter on. You can also provide descriptions for these columns to help guide the agent in generating relevant filters.

## Document-Level Security

[Document-Level Security](<../../generative-ai/knowledge/document-level-security.html>) enables granular access control over documents within a knowledge bank. It ensures that when a user performs a search or query, the results only include documents that user is authorized to view.

To enable document-level security:

  * A security token column must selected in the [Embedding recipe](<../../generative-ai/knowledge/first-rag.html>) settings,

  * In the Knowledge Bank Search Tool, select ‘Enforce document-level security’,

  * Provide the end-user security tokens at query time




Passing security tokens to the tool is done via the “context” parameter, in a key called “callerSecurityTokens”. Dataiku Chat UIs do this automatically along with [Agent Hub](<../agent-hub.html>) and [Agent Connect](<../../generative-ai/chat-ui/agent-connect.html>). Importantly, you must make sure to pass tokens of the “final” end-user, not the technical user simply calling the agent or tool.

---

## [agents/tools/llm-mesh-query]

# Query an LLM/Agent

This tool calls an LLM or Agent in the LLM Mesh. You configure a system prompt and target LLM.

When calling the tool, it gets a prompt as input, and it queries the target LLM with the system prompt + input, and responds with the LLM response.

This can be surprising at first sight: after all, tools are usually called from agents, that are already LLMs. Why call another LLM?

There are several possible use cases for this “agent-inception”:

  * Separation of concerns: An Agent can use this to call another Agent, without having to know all the details. This other Agent can be developed by another team, use another technology, …

  * Keeping the Agent on track: if you have complex tasks to accomplish, having a single agent with many different tools can lead to worse responses. Cutting it into several smaller agents that are orchestrated by an “overarching Agent” that uses Query an LLM/Agent tools can help improve the answers.

  * Performance and Cost Management: Some LLMs are very good at some specific tasks (such as OpenAI o3 for advanced reasoning), but slow and expensive, and it would not be reasonable to use them as the “main” LLM of the Agent. Using a Query an LLM/Agent tool leveraging them allows you to use these specific LLMs only for a subset of tasks: while the task is not too complex, the main LLM handles it, but it can delegate more advanced tasks to the advanced reasoning LLM.

---

## [agents/tools/local-mcp]

# Local MCP

The Local MCP tool allows a Model Context Protocol (MCP) server to be run locally, with its tools selectively made available to agents.

## Prerequisites

Configure a code environment with the following specifications:

  * Python version 3.10 or higher

  * The fastmcp package version 2.0 or higher

  * Containerized execution and AlmaLinux 9 or higher are recommended. The **Agent MCP server** runtime addition installs uvx and npx to help start most MCP servers.




## Configuration

Create a tool with type “Local MCP”. Then the configuration of the tool involves two main steps:

  * Define the **command** , **arguments** , and **environment variables** used by the MCP server process in the tool’s settings.




Note

Most MCP servers provide a JSON configuration file/example. Fill the configuration automatically using the Paste config button.

  * The **Load tools** button loads the list of tools exposed by the MCP server. Each tool can then be disabled individually.




## Usage

Add the Local MCP tool to an agent like any other tool. When running, the agent directly sees and uses each enabled MCP server tool as a regular standalone tool.

## Security

The Local MCP tool runs under the querying user’s identity (see [User Isolation](<../../user-isolation/index.html>)) and therefore with that user’s permissions / accesses.

An administrator may disable the creation/edition of Local MCP Server tools, or restrict it to only administrators in Administration > Settings > LLM Mesh.

Some MCP server runners, such as uvx and npx, download the server’s code every time they start. To control updates, you can pin the version of the MCP server.

---

## [agents/tools/model-predict]

# Model Predict tool

This tool predicts record using a Dataiku Machine Learning prediction model.

This tool allows you to create powerful composition of traditional Machine Learning and Generative AI.

This tool takes a single argument: a Saved Model. For more information, see [Machine learning](<../../machine-learning/index.html>)

This tool requires classical prediction/regression AutoML models that are compatible with “Optimized Scoring”. See [Scoring engines](<../../machine-learning/scoring-engines.html>) for more details.

---

## [agents/tools/optimization]

# Optimization Tool

The Optimization Tool is an agent tool for solving knapsack optimization problems using Linear Programming. It helps maximize value within capacity constraints, making it ideal for resource allocation, budget optimization, and selection problems.

## Setup

This tool is provided by the “Agent Optimization Tool”, which you need to install.

## Usage

  * Create or open a Dataiku project

  * Navigate to the agent tools section

  * Select Knapsack Optimization tool




The Knapsack optimization tool solves the classic problem: given a set of items with weights and values, determine which items to include to maximize total value without exceeding a capacity constraint.

## Inputs

The tool is automatically called by agents, so you don’t usually need to care about its input and output.

The tool takes as input:

  * Items: List of items with their properties

  * Values: Value/benefit of each item

  * Weights: Weight/cost of each item

  * Capacity: Maximum allowed total weight




## How It Works

The tool uses Linear Programming to find the optimal selection of items. You can test it through the tool quick test interface to get immediate results, then integrate it with either a visual agent or code agent like any other tool in Dataiku.

The solver analyzes all possible combinations within the capacity constraint, and calculates the maximum achievable value

## Output

The tool returns the optimal selection of items to include (names and counts)

---

## [agents/tools/remote-mcp]

# Remote MCP

The Remote MCP tool allows using a Model Context Protocol (MCP) server, with its tools selectively made available to agents.

## Prerequisites

Create a Remote MCP connection with the server URL set to the remote MCP server URL.

### Authentication

Most MCP servers require authentication through OAuth. To help configure OAuth, the Remote MCP connection page offers:

  * OAuth configuration discovery: use this to easily setup endpoints, authentication method and scopes

  * OAuth dynamic client registration: use this to register a client, this is especially useful if the OAuth provider doesn’t have an interface to create OAuth clients




Users will have to go through the OAuth authorization flow the first time they use this connection through a Remote MCP tool.

Some OAuth providers return a new refresh token with every new access token. Enable “Rotate refresh tokens” in that case.

## Configuration

Create a tool with type “Remote MCP” and select the Remote MCP connection to use.

All tools are disabled by default. Each tool must be enabled individually to be made available to agents.

## Usage

Add the Remote MCP tool to an agent. When running, the agent sees and uses each enabled MCP server tool as a regular standalone tool.

---

## [agents/tools/salesforce]

# Salesforce

These tools are provided by the “Salesforce” plugin, which needs to be installed.

## Lookup Salesforce Account

This tool looks up a Salesforce account by name.

In the plugin Settings create a new preset to connect to a Salesforce instance with Single Sign-On (SSO) or username/password.

When configuring a tool instance in a project, choose a preset.

The tool can look up the following account attributes: Id, Name, Website, Industry, Phone, Type, BillingCity, BillingCountry.

Test your Lookup Salesforce Account tool in the “Quick test” tab:
    
    
    {
        "input": {
            "Name": "Account Name"
        },
        "context": {}
    }
    

## Create Salesforce Contact

This tool creates a new Salesforce contact.

In the plugin Settings create a new preset to connect to a Salesforce instance with Single Sign-On (SSO) or username/password.

When configuring a tool instance in a project, choose a preset.

The tool can create a contact with a FirstName and LastName, and optionally the following attributes: Salutation, Email, Title, Department, AssistantName, LeadSource, Birthdate, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Phone, MobilePhone, AccountName, Website.

Test your Create Salesforce Contact tool in the “Quick test” tab:
    
    
    {
        "input": {
            "LastName": "ContactLastName",
            "FirstName": "ContactFirstName",
            "Salutation": "Dr.",
            "Email": "[[email protected]](</cdn-cgi/l/email-protection>)",
            "Title": "CTO",
            "Department": "Engineering",
            "AssistantName": "None",
            "LeadSource": "Web",
            "Birthdate": "1990-01-01",
            "MailingStreet": "125 W 25th St",
            "MailingCity": "New York",
            "MailingState": "NY",
            "MailingPostalCode": "12345",
            "MailingCountry": "USA",
            "Phone": "1-800-000-0000",
            "MobilePhone": "1-800-000-0000",
            "AccountName": "Account Name",
            "Website": "company.com"
        },
        "context": {}
    }

---

## [agents/tools/semantic-model-query]

# Semantic Model Query Tool

The Semantic Model Query tool is a tool leveraging a Semantic Model to translate natural language queries into SQL queries, and providing answers based on the execution of the SQL queries.

For more details, please refer to [Semantic Models](<../../semantic-models/index.html>)

The Semantic Model Query tool mostly supersedes the [SQL Question Answering tool](<sql-question-answering.html>).

---

## [agents/tools/send-message]

# Send Message tool

The **Send Message** tool sends a message through a Dataiku Messaging Channel.

The following channel types are supported:

  * [Mail reporter](<../../scenarios/reporters.html#scenario-reporter-mail>)

  * [Slack integration setup](<../../scenarios/reporters.html#scenario-reporter-slack>)

  * [Microsoft Teams integration setup](<../../scenarios/reporters.html#scenario-reporter-teams>)




Messages are defined using a **template**. The template format and available fields depend on the channel.

## Message variables

You can customize the message by defining variables that are applied to the template.

The tool supports the following types of variables:

**Tool input**
    

Variables explicitly defined by the LLM calling the tool. These can be strings or numbers. You must provide a description for each variable so the LLM knows how to fill them.

**Context variable**
    

Variables provided within the `context` of the calling agent. Useful for passing information you do not want to expose to the agent LLM (_e.g._ personally identifiable information).

**DSS variable**
    

Variables available from the DSS environment (see [Custom variables expansion](<../../variables/index.html>)).

**Custom formula**
    

New variables defined using DSS [Formula language](<../../formula/index.html>). You can reuse any variable declared before the formula. Therefore, the order in which variables are defined matters. You can reorder variables by dragging and dropping them in the interface.

Maintaining complex templates can be error-prone. The tool includes a helper that flags:

  * **Unused variables** : defined but never referenced in the template.

  * **Undefined variables** : referenced in the template but never defined.




Note

Depending on the channel type and settings, variables may also be available in additional fields. A help message will indicate when this is the case.

---

## [agents/tools/servicenow]

# ServiceNow

## Create ServiceNow Issue

This tool is provided by the “ServiceNow” plugin, which needs to be installed.

In the plugin Settings -> Service accounts (or User accounts), create a new preset to connect to a ServiceNow instance and enter a single service account credential. In the case of a User account preset, you can require Dataiku users to enter their credentials individually.

When configuring a tool instance in a project, choose a Service account or User account authentication preset.

The tool can create and populate a new issue with a summary and description, and optionally an issue impact (between 1 and 3) and urgency (between 1 and 3).

Test your Create ServiceNow Issue tool in the “Quick test” tab:
    
    
    {
        "input": {
            "summary": "Your issue summary",
            "description": "Longer description",
            "impact": 2,
            "urgency": 3
        },
        "context": {}
    }

---

## [agents/tools/snowflake-cortex-analyst]

# Snowflake Cortex Analyst Tool

The Cortex Analyst tool leverages an existing Cortex Analyst object in your Snowflake subscription in order to answer questions from a Snowflake Semantic View or Semantic Model.

It empowers other agents to query structured data in the Semantic Model / View (Text-to-SQL).

## Prerequisites

The Cortex Analyst Tool is a capability provided by the “Snowflake Cortex AI” plugin, which you need to install.

You need a Snowflake connection setup with OAuth 2, Keypair, or Programmatic Access Token authentication. Login/Password is not supported.

The default role of the user of the Snowflake connection needs to have access to the Cortex Analyst service.

## Usage

  * Create a new Cortex Analyst tool

  * Select between using an existing Semantic View (recommended) or the location of an uploaded YAML file for a Semantic Model (legacy)

---

## [agents/tools/snowflake-cortex-search]

# Snowflake Cortex Search Tool

The Cortex Search Tool allows you to leverage an existing Cortex Search vector search index, and provides semantic document retrieval capabilities.

It empowers other agents to query data stored in a Snowflake Cortex Search index.

## Prerequisites

The Cortex Search Tool is a capability provided by the “Snowflake Cortex AI” plugin, which you need to install.

You need a Snowflake connection setup with OAuth 2, Keypair, or Programmatic Access Token authentication. Login/Password is not supported.

The default role of the user of the Snowflake connection needs to have access to the Cortex Search service.

---

## [agents/tools/sql-question-answering]

# SQL Question Answering Tool

Note

It is recommend to use [Semantic Models](<../../semantic-models/index.html>) instead of the SQL Question Answering Tool, for better quality of answers

## Overview

The Dataiku SQL Question Answering Agent Tool plugin is a plugin that allows users to create agent tool instances capable of taking natural language inputs and generating SQL SELECT queries. A selected LLM can then interpret the query results and provide a natural language explanation of the returned records. Unlike other tools that are simple “information retrieves”, this is a “smart” tool that itself leverages AI. As such, it takes a LLM as configuration option. The tool performs strict validation of the generated SQL queries to ensure that the SQL query can only be a “SELECT”

## Getting Access

Dataiku SQL Question Answering Agent Tool plugin is available on demand through the Dataiku plugin store. After installing the plugin, tool instances can be created within a desired project in the Agents Tools section. These tool instances can then be utilized by various features of Dataiku such as Dataiku Agents or Dataiku Agent Connect.

## Configuration

### Introduction

This guide details the setup of a Dataiku SQL Question Answering Agent Tool. The following sections explain how to set up and configure tool instances to make best use of this plugin.

### Requirements

#### Infrastructure

**SQL Datasets:** All datasets used by instances of Dataiku SQL Question Answering Agent Tool must be SQL datasets stored in one of the following compatible databases:

>   * **PostgreSQL**
> 
>   * **Snowflake**
> 
>   * **MS SQL Server**
> 
>   * **BigQuery**
> 
> 


## Tool Instance: Design

### Basic Settings

**SQL Connection:** Choose the SQL connection containing datasets you would like to use to enrich the LLM responses. You can choose from all the connections used in the current Dataiku Project but only one connection per agent tool instance.

**Datasets to query:** Select the datasets you would like the tool instance to access. You can choose among all the datasets from the connection you have selected previously. This means that all the datasets must be on the same connection.

**LLM:** Select the language model that will:

>   * Decide which tables and columns to use.
> 
>   * Create a SQL query.
> 
>   * Take the returned records and interpret the information (optional).
> 
>   * In the case of error, fix the incorrect SQL query based on the SQL error.
> 
> 


Caution

As the model will be responsible for very demanding tasks which require both structured and unstructured responses, it is strongly advised to use LLMs which are intended for code generation. LLMs whose primary focus is creative writing will perform poorly on this task.

Caution

If you frequently experience JSONDecodeError errors it is very likely that the LLM (1) didn’t format its JSON response properly or (2) ran out of tokens before it could finish the JSON response. For (1), this LLM is not suited to this task. LLMs which are specialized in code generation are preferred. For (2), choose an LLM with a higher number of output tokens.

### Dataset Information & Descriptions

The performance of the tool depends heavily on the description and information that is provided to the models in the chain. This is why it is important to keep in mind the steps in the chain and how to provide the most relevant information to the model at each step in order to craft the best response. The chain executes in the following order:

  * **Graph Generation:** The model is asked whether the user query can be answered with the available data and if so which tables and columns should be used and why?

  * **Query Generation:** Takes the selected columns and tables and justification from the Graph query and uses them to generate an object which is translated into dialect specific SQL query for the selected connection.

  * **Answer Generation:** (Optional) Takes the records retrieved from the SQL query and interprets them based on the information provided.




The two most important places to provide information to the chain are with the Data context information and column and dataset descriptions.

The table below shows which information is provided at each stage of the chain.

| Graph Generation | Query Generation | Answer Generation  
---|---|---|---  
Table & column names | ✅ | ✅ | ✅  
Data context information | ❌ | ✅ | ✅  
Dataset & Column descriptions | ✅ | ✅ | ❌  
Records | ❌ | ❌ | ✅  
User question | ✅ | ✅ | ✅  
  
Warning

The LLM can only generate effective queries if it knows about the data it is querying. You should provide as much detail as possible to clarify what is available.

**Data context information:** Here you can provide additional information to enrich the LLM performing steps in the query chain. The information will be used in combination with dataset and column descriptions at different stages in the chain to provide the most relevant information to the model. This can also be combined with information automatically retrieved from the SQL table via sampling. The sample values section gives more information about this.

**Dataset and column descriptions:** Add a description to the dataset and the columns so the retrieval works effectively (added in each dataset outside of the tool). This can be done in the following way:

  * For the dataset: Select the dataset, click the information icon in the right panel, and click edit. Add the description in either text box.




  * For the columns: Explore the dataset, then click settings and schema. Add a description for each column.




Warning

The LLM will not be able to view the entire dataset before creating the query, so you must describe the contents of the column in detail. For example, if defining a categorical variable, then describe the possible values (“Pass,” “Fail,” “UNKNOWN”) and any acronyms (e.g., “US” is used for the United States).

Warning

Ensure that data types match the those of questions that you expect to ask the LLM. For example, a datetime column should not be stored as a string. Adding the column descriptions here means the descriptions are tied to the data. As a result, changes to the dataset could cause the LLM to provide inaccurate information.

**Providing Examples:** Giving example user questions and their expected SQL queries in the Data context information can be an effective way of improving the performance of tool instance. This is particularly useful if there is a specific way to query the dataset that the LLM should follow. This can include a common way of handling dates, a specific way of joining tables or typical CTE (common table expressions) for example. However, it is important to use the Dataiku dataset name rather than the SQL table location in all examples. In the example below the data is located in SQL storage at `MY_SCHEMA.SALES_product_sold` but it should be referred to as `product_sold` as this is the dataset name exactly as it appears in Dataiku.
    
    
    -- Key: question: 'What is the rolling sum of products sold on Mondays?'
    -- Value: answer:
    WITH parsed_sales AS (
       SELECT
          TO_DATE(sale_date, 'YYYYMMDD') AS sale_date_parsed,
          product_sold
       FROM sales
    ),
    mondays_sales AS (
       SELECT
          sale_date_parsed,
          product_sold
       FROM parsed_sales
       WHERE EXTRACT(DOW FROM sale_date_parsed) = 1  -- 1 = Monday
    )
    SELECT
       sale_date_parsed,
       product_sold,
       SUM(product_sold) OVER (
          ORDER BY sale_date_parsed
          ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
       ) AS rolling_sum
    FROM mondays_sales
    ORDER BY sale_date_parsed;
    

**Hard Limit on SQL Queries:** By default, all queries are limited to 200 rows to avoid excessive data retrieval. However, it may be necessary to adapt this to the type of data being queried.

### Return Values

In this section you can choose what is returned by the tool instance. Your choice can depend a lot on how you intend to use the tool instance.

  * **Let the LLM decide automatically (default):** Gives the LLM the choice to return records and/or a text-based interpretation response.

  * **Return both:** Enforces the return of both the text based interpretation response and the records that are returned from the SQL query.

  * **Return the answer to the question:** The returned value from the user query will only contain a text based interpretation.

  * **Artifact with the raw data needed to answer:** The returned value from the user query will only contain the records returned from the SQL query. No further LLM query will be made to interpret the data.




### Sample Values

The model does not have access to the whole dataset when crafting the query. For this reason it is vital that it is provided with the best possible descriptions. If you choose `Find from data` the model will be provided with all the unique values for the categorical columns in the data. Meaning, for example, if a user asks about the number of positive response to survey questions the model will know to create the condition `WHERE "answer" = 'Y'` instead of `WHERE "answer" = 'Yes'`. You can set the value at which a column is considered categorical by adjusting the `Cardinality cutoff value`.

### Tool Descriptor Settings

The tool descriptor is used by agents to decide whether to use the tool instance. Providing more information can help in this decision process. However, if the tool instance uses a large number of tables with a large number of columns or these columns and datasets have long descriptions then the descriptor can stop being useful.

In this section you can limit the information that is included in the descriptor in order avoid an unnecessarily large amount of information being used. Instead, a more concise description can be provided that can aid the decision process.

---

## [agents/tools/using-tools]

# Using tools

There are two main ways that tools in Dataiku are used:

## Visual Agent

[Simple Visual Agents](<../visual-agents.html>) directly leverage tools for their working. This is a fully no-code usage of tools

## API

Tools come with a complete API that allow you to integrate tools usage in your own code. This can be in a [Code Agent](<../code-agents.html>) or any other kind of code.

### Native API

Dataiku tools can be used directly. Here is an example of calling an instance of the Dataset Lookup tool
    
    
    import dataiku
    tool = dataiku.api_client().get_default_project().get_agent_tool("my-tool-1")
    
    output = tool.run({
        "filter" : {
            "operator": "EQUALS",
            "column": "company_name",
            "value": "Dataiku"
        }
    })
    
    # Matched rows are in
    output["output"]["rows"]
    

### LangChain API

Dataiku tools can be converted into LangChain Structured Tools to be used in any LangChain / LangGraph compatible code:
    
    
    import dataiku
    tool = dataiku.api_client().get_default_project().get_agent_tool("my-tool-1")
    
    lctool = tool.as_langchain_structured_tool()
    
    output = lctool.invoke({
        "filter" : {
            "operator": "EQUALS",
            "column": "company_name",
            "value": "Dataiku"
        }
    })
    
    output["rows"]
    

Importantly, this “lctool” is a fully structured LangChain Tool, including knowing its schema. It can therefore immediately be used with a LangChain tool-aware LLM
    
    
    llm_with_tools = llm.bind_tools([lctool])
    
    # Assuming that the dataset contains revenues of companies
    llm_with_tools.invoke(("user", "What is the revenue of Apple"))
    

### Tool descriptor

A key component of tools is that they are self-describing. You can obtain a “tool descriptor” that lists:

  * Name

  * Description (that can be passed to a LLM)

  * Input schema (as a JSON schema)




For example, a [Dataset lookup tool](<dataset-lookup.html>) has a descriptor like this (when working on the “titanic” dataset):
    
    
    import dataiku
    tool = dataiku.api_client().get_default_project().get_agent_tool("titanic1")
    descriptor = tool.get_descriptor()
    
    {
      "name": "titanic1_KttcvQ",
      "description": "Get records (up to 10) from dataset kaggle_titanic_train\n\nThe columns that are available for you to lookup are:\n\n  * PassengerId (type: STRING)\n  * Name (type: STRING)\n  * Age (type: STRING)\n",
      "inputSchema": {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "$id": "https://dataiku.com/agents/tools/datasets/row-lookup/input",
        "title": "Lookup settings for a row of a dataset",
        "type": "object",
        "properties": {
          "filter": {
            "type": "object",
            "description": "The filter to search for the records",
            "properties": {
              "operator": {
                "type": "string",
                "description": "Filter operator. One of EQUALS, NOT_EQUALS, GREATER_THAN, LESS_THAN, DEFINED, NOT_DEFINED, CONTAINS, MATCHES (regex), AND, OR"
              },
              "column": {
                "type": "string",
                "description": "On which column it applies. Not applicable to AND and OR"
              },
              "value": {
                "type": "string",
                "description": "Value to compare. Not applicable to AND, OR, DEFINED, NOT_DEFINED. Can be a string or a number. Beware, don't put between quotes if you mean a number."
              },
              "clauses": {
                "type": "array",
                "description": "Boolean clauses. Only applies to AND and OR. These sub-clauses are of the same type as the current element",
                "items": {
                  "$ref": "#/properties/filter"
                }
              }
            }
          }
        }
      }
    }
    

### Context

In addition to the “input” and “output” of the tool, a tool takes an input a “context”.

The context is an arbitrary JSON dictionary, that can be used to pass any kind of information you would like. The LLM of the agent is not aware of the context.

A typical usage example is as follows: you are building a customer support agent. This agent has a tool looking up information about a customer. At some point in the conversation with the customer, the agent needs to lookup information about the customer. However, you don’t want the information about “who is the customer” to be part of the tool input, because there is a risk that it could be manipulated by the customer. Therefore, the customer information is passed by your code to the tool, and the tool uses the context rather than what’s in the input to filter on the customer.

When using a Visual Agent, the Visual Agent passes the context that it receives to all tools that it calls.

---

## [agents/tracing]

# Tracing

Agents are fairly complex pieces of software, leveraging multiple components, and often in a way that is not entirely predictable.

As soon as you start writing complex agents, you will often have issues following the flow of what happens.

Dataiku’s Agents systems come with a complete Tracing system, allowing you to record the entire trace of what your Agent does, even through multiple layers of calling LLMs. The Trace is available as a nested JSON object showing processing steps and events.

Dataiku provides the **Trace Explorer** , a web app that allows you to visually explore traces.

Dataiku Tracing is also two-way compatible with LangChain and LangSmith:

  * Dataiku will automatically gather traces from LangChain invocations, even recursively (LangChain->LLM Mesh->LangChain->LLM Mesh, etc…)

  * A Dataiku Trace can be pushed to LangSmith




## Anatomy of a trace

A trace is primarily composed of nested observations: “spans” and “events”.

  * Each observation contains a “name”, optional “inputs” and “outputs”, as well as “attributes” (metadata).

  * Spans have start and end times, and children spans.

  * Events are “points in time” and contain a timestamp.




The nesting of spans represents the lifeline of the query, as it goes through various systems. See below for a simple example.

## Traces built into the LLM Mesh

Every call to the LLM Mesh returns a complete nested trace.

Traces can be seen:

  * In the output of Prompt Recipes (if tracing is enabled in the Advanced settings of the recipe)

  * In the API responses:



    
    
    llm = project.get_llm("openai:myconnection:gpt-4o")
    response = llm.new_completion().with_message("I am asking a question").execute()
    
    print(response.trace)
    

It records:

  * The overall query

  * The Guardrails on the query (“DKU_LLM_MESH_QUERY_ENFORCEMENT”)

  * The actual call to the LLM (“DKU_LLM_MESH_CALL”)

  * The Guardrails on the response (“DKU_LLM_MESH_RESPONSE_ENFORCEMENT”)

  * The usage metadata (tokens and costs)

  * Inputs and outputs

  * The LLM used




For example, here is the trace of a simple LLM Mesh query:

Note: usage metadata is reported only once, at the “DKU_LLM_MESH_CALL” level, i.e. where the cost is “truly incurred”

## Adding your own trace items

When writing a Code Agent, you receive a trace object. You can append your own spans to it. This simple tool-calling agent sample code demonstrates this:
    
    
    def process(self, query, settings, trace):
    
       with trace.subspan("Doing something") as subspan:
          do_something()
    

If you are calling another LLM in your code, you can append the entire span of this other call:
    
    
    with trace.subspan("Calling another LLM") as subspan:
    
       llm = dataiku.api_client().get_default_project().get_llm("some_llm")
       resp = llm.new_completion().with_message("do something").execute()
    
       subspan.append_trace(r.trace)
    

## Trace Explorer

Note

This capability is provided by the **Trace Explorer** plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Supported](<../troubleshooting/support-tiers.html>) by Dataiku Support.

**Trace Explorer** is a Dataiku Visual Web Application to visualize traces stored in a Dataiku dataset. It ingests structured LLM usage logs from a configurable dataset and column, and offers three distinct views (Tree, Timeline, Explorer) for analyzing and debugging usage details.

You can also add traces manually by pasting JSON content directly into the app, or by using the Explore Trace shortcut. Traces imported using either method are referred to as **pasted traces**.

### Creating a Trace Explorer Webapp

  1. **Add a New Webapp** :

     * In your Dataiku project, select **\+ New Webapp**.

     * Choose **Visual Webapp**.

     * From the list of available visual web applications, select **Trace Explorer**.

  2. **Configure** :

     * **Name of the dataset that stores LLM logs** : Pick the dataset containing your Generative AI logs.

     * **Name of the column that contains LLM responses** : Select the JSON column in that dataset that holds your LLM output traces.

     * **Data Storage** : Choose how to store your pasted traces.

>        * **Built in (Workload Folder)** : Pasted traces are stored in the workload folder of the webapp.
> 
>        * **Managed Folder** : Pasted traces are stored in a managed folder.
> 
>        * **No storage** : Pasted traces are not persisted, pasting a new trace will overwrite any existing pasted trace in the webapp.

     * **Project Managed Folder** : If you chose “Managed Folder” in the previous setting, select the managed folder where pasted traces will be stored.

  3. **Save** your settings.




Note

If you don’t have a dataset ready, you can leave the fields empty and still paste traces directly in the webapp.

#### Use with **Prompt Recipe** , **Agent Connect** and **Dataiku Answers**

You will need to set the following parameters during webapp setup:

Component | LLM Raw Responses Dataset | LLM Raw Responses Column  
---|---|---  
**Answers** | answers_conversations_dataset | llm_context  
**Agent Connect** | agent_connect_conversations_dataset | llm_context  
**Prompt Recipe** | prompt_recipe_dataset_generated | llm_raw_responses  
  
Note

Replace the **Dataset** with your own. **Column** should always be the one provided in the table above.

Hint

For **Prompt Recipe** , please be sure to set **Raw response output mode** to **Raw** in the **Advanced** recipe settings in order to have llm_raw_responses column available in the output dataset.

### Using the Trace Explorer

  1. **Open the Webapp** :

     * From your project’s **Webapps** list, locate and **Open** the newly created **Trace Explorer** webapp.

  2. **Explore Dataset Traces** :

     * The application automatically loads and displays traces from the configured dataset/column.

     * Each valid JSON entry appears in a table, including essential metadata (e.g., name, start time, duration).

     * Click on any trace to view its structure and details.

  3. **Paste a JSON Trace** :

     * If you have a single JSON formatted trace not yet stored in the dataset, you can click **Paste a new trace** in the sidebar.

     * Paste the JSON into the text area, then **Import trace** to explore it immediately within the app.

  4. **Views** :

     * **Explorer View** : A tabular, hierarchical breakdown of each node, showing durations, usage metadata, and sub-node details.

     * **Timeline View** : Displays events in chronological order.

     * **Tree View** : A graph-based structure letting you see the trace’s nested events and relationships.

  5. **Trace Details** :

     * When you select a node in the Tree, Timeline, or Explorer, a side panel shows node details, including inputs, outputs, and attributes.

     * There is also a Raw mode view letting you see the full JSON of any node.

     * Multiple copy buttons allow you to easily copy inputs, outputs, attributes, or the entire node content.

  6. **Reload Traces (Optional)** :

     * If your dataset changes, you can reload the traces (when provided in the UI) to refresh the view with the latest records.

  7. **User Settings** :

     * At the bottom of the sidebar, you can set preferences such as the theme (light, dark), the default view (explorer, timeline, tree), and the default format mode.




### Accessing via Explore Trace shortcut

In addition to opening the webapp directly, a shortcut is available from Prompt Studio, Agents and Retrieval-Augmented LLMs.

Note

For this shortcut to be functional, an administrator must first configure a default Project and Trace Explorer instance under **Administration > Settings > LLM Mesh > Configuration > Trace**.

Hint

As a best practice, we recommend creating a dedicated project for this purpose that grants read-only rights to all relevant users or groups (or dashboard-only access, with the webapp added to the Authorized objects).

### Pasted traces management

  * Pasted traces are stored as JSON files.

  * Each JSON file contains one trace with additional enriched metadata (for example, internal node IDs).

  * Because pasted traces are enriched before being saved, you cannot copy raw trace JSON files directly into the storage folder and expect them to appear in the app. To persist a trace correctly, use **Paste a new trace** in the webapp.

  * You can switch freely between all storage modes (**Built in (Workload Folder)** , **Managed Folder** , **No storage**) at any time.




Warning

Switching storage modes does not delete existing traces, but it does not migrate traces between storage locations automatically.

Note

Persisted storage is user-specific: each user sees their own stored pasted traces.

### Troubleshooting & Notes

  * Ensure your chosen column has valid JSON. Rows with invalid JSON are skipped.

  * The “Paste a JSON Trace” feature is helpful for quickly previewing a single trace without requiring a dataset update.

  * The timeline view’s zooming behavior requires holding **Shift** while scrolling with the mouse wheel.




That’s it. By following these steps, you can install, configure, and utilize the **Trace Explorer** webapp to understand your Generative AI usage in Dataiku.

---

## [agents/visual-agents]

# Simple Visual Agents

With Dataiku Simple Visual Agents, users can very easily create their own Agent, based on Dataiku-managed Tools, with no coding involved.

A Simple Visual Agent simply defines which tools it uses and optional instructions. The Simple Visual Agent is then fully autonomous to respond to user queries: it chooses on its own which tools to leverage based on the description of the available tools, automatically calls them, and synthesizes the responses.

To create a Simple Visual Agent, from the Flow, click “+Other > Generative AI > Simple Visual Agent”.

Dataiku also provides an interactive test environment for your Agent.

At the heart of a Simple Visual Agent, there is a LLM that acts as the central coordinator. You need to choose the LLM that you will use for this purpose. This must be a LLM that supports “tool calling”.

The following LLM types in Dataiku support tool calling:

  * Anthropic Claude

  * Azure AI Foundry

  * Azure OpenAI

  * Anthropic Claude via AWS Bedrock

  * Mistral AI (on La Plateforme)

  * OpenAI

  * Vertex Gemini




Once the LLM is chosen, you simply need to choose the tools that the agent will use. Note that you must create the tools before the agent. See [Managed tools](<tools/index.html>) for more details on creating tools.

You can also give additional instructions, for example, to instruct the LLM on what tone to use, what languages to use, what to do when it does not know, etc…

For example, a Customer 360 assistant agent could have several tools:

  * A [Knowledge Bank Search](<tools/knowledge-bank-search.html>) tool to search into past emails with this customer

  * A [Dataset Lookup](<tools/dataset-lookup.html>) tool to search for the latest support tickets from this customer




## Sources

Many tools are able to provide information about “sources”, i.e. providing details of the data and knowledge elements that they used to provide the answer to the agent.

The Simple Visual Agent gathers all the sources used by the tools, and returns them as part of its response. This gives full visibility for end users into how the Simple Visual Agent built its response.

When using the LLM Mesh API, sources are returned in the “sources” field of the completion response. The Dataiku [Chat UIs](<../generative-ai/chat-ui/index.html>) display sources directly to end users.

## Context

To learn more about what Context is and how tools use it, see [Using tools](<tools/using-tools.html>).

Each tool receives a context, and Agents receive a context too. When using a Simple Visual Agent, the Simple Visual Agent passes the entire context it receives to all tools it calls.

When using the LLM Mesh API, the Context is passed as the “context” field of the completion query.