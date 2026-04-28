# Dataiku Docs — generative-ai-llm

## [generative-ai/api]

# LLM Mesh API

The LLM Mesh features a complete API to build rich generative AI applications.

For more details, please see [LLM Mesh](<https://developer.dataiku.com/latest/concepts-and-examples/llm-mesh.html> "\(in Developer Guide\)")

---

## [generative-ai/chat-ui/agent-connect]

# Agent Connect

Note

Agent Connect is deprecated, and replaced by [Agent Hub](<../../agents/agent-hub.html>)

## Overview

Agent Connect serves as the central hub for managing interactions with instances of Dataiku Answers and Agents within a Dataiku instance. This allows users to interact with multiple Dataiku resources in a single interface.

**Key Features**

  * **Simple and Scalable**




## Getting Access

Agent Connect Plugin is available on demand through the Dataiku plugin store. Once installed it gives you access to a fully built Visual Webapp which can be used within your choice of Dataiku Projects.

## Configuration

### Introduction

This guide details the setup of the Agent Connect,

### Requirements

#### Dataiku DSS version

  * Dataiku 13.4.0 and above. The Last Dataiku version is always the best choice to leverage the latest plugin capabilities fully.

  * Available for Self-Managed

  * **Cloud support** : Available starting from version 1.4.0 by enabling the following settings:

    * `Do not check end-user permissions`

    * `Disable SSL verification`

See the settings documentation for more details.




**Agent Connect and DSS compatibility matrix**

| DSS ≥ 14.0 | DSS ≥ 13.4.0  
---|---|---  
Agent connect >= 1.6.1 | ✅ | ❌  
Agent connect >= 1.0.0 | ❌ | ✅  
  
#### Infrastructure

**Web Application Backend Settings:**
    

  * The number of Processes must always be set to 0

  * Container: None - Use backend to execute




**SQL Datasets:** All datasets used by Agent Connect must be SQL datasets for compatibility with the plugin’s storage mechanisms.

>   * **PostgreSQL**
> 
>   * **Snowflake**
> 
>   * **MS SQL Server**
> 
>   * **BigQuery**
> 
>   * **Databricks**
> 
>   * **Oracle** (>= 12.2.0)
> 
> 


Warning

**About Oracle** : The chat history data to log requires the use of the Oracle `TO_CLOB` function. Oracle >= 12.2 allows for 32k bytes per call of `TO_CLOB` but older versions only supports up to 4k which might be too low. It is then recommended ensure your Oracle version is 12.2.0 or later.

### Mandatory Settings

#### Conversation History Dataset

Create a new or select an existing SQL dataset for logging queries, responses, and associated metadata (LLM used, Knowledge Bank, feedback, filters, etc.).

#### User Profile Dataset

This allows you to configure a list of settings, excluding language, that users can fill out within the web app. You must set up an SQL user profile dataset (mandatory even if no settings are configured).

Note

All the users profiles are initialized with default settings. The user profiles are only saved after users edit and save them directly (_e.g: Editing the language_) or indirectly (_e.g: requesting for an image generation_). It is then possible that your user profile dataset is empty despite the fact several people are using your application.

#### LLM

Connect each instance of Agent Connect to your choice of LLM, powered by Dataiku’s LLM Mesh. Select from the LLMs configured in Dataiku DSS Connections.

#### Answers and Agents Configuration

Agent Connect can interract with the following LLM-Mesh components: \- **Dataiku Answers** web applications. \- **LLM Mesh Agents**. \- **LLM Mesh Augmented-LLMs** ( >= 1.7.0).

For this, you must:

  1. Select the projects that host your ‘Agents’ and/or ‘Answers’ and/or ‘Augmented-LLMs’ .

  2. Choose the specific ‘Agents’ / ‘Answers’ / ‘Augmented-LLMs’ you want to make available in Agent Connect.




Additional settings for the connected components can be found in the **Agents Advanced Configuration** section, available as of version **1.2.1**.

Note

Important: Agent Connect needs descriptions to understand when it needs to use your connected LLM-Mesh components:

>   * For each ‘Dataiku Answers web application’, the description must be provided directly inside the webapps, in the ‘Answers API Configuration’ section.
> 
>   * For each ‘Agent’ and ‘Augmented-LLM’, you must provide the detailed description within the Agent Connect UI.
> 
> 


### Other settings

### Conversations Store Configuration

Agent Connect allows you to store all conversations for oversight and usage analysis. Flexible options allow you to define storage approach and mechanism.

#### Index the chat history dataset

Addition of an index to the conversation history dataset to optimize the performance of the plugin.

Note

Indexing is only beneficial for specific database types. It is recommended to consult the database documentation for more information and only change if you are certain it will improve performance.

#### Conversation Deletion

Toggle ‘Permanent Delete’ to permanently delete conversations or keep them marked as deleted, maintaining a recoverable archive.

#### Feedback Choices

Configure positive and negative feedback options, enabling end-users to interact and rate their experience.

#### Document Folder

Choose a folder to store user-uploaded documents and LLM generated images.

#### Allow User Feedback (>= 1.1.0)

As you roll out chat applications in your organization, you can include a feedback option to improve understanding of feedback, enablement needs, and enhancements.

##### General Feedback Dataset (>= 1.1.0)

In addition to conversation-specific feedback, configure a dataset to capture general feedback from users. This dataset can provide valuable insights into the overall user experience with the plugin.

### LLM Configuration

#### Configure your ‘Main’ LLM

Tailor the prompt that will guide the behavior of the underlying LLM. For example the prompt could instruct the LLM to structure the responses in a clear and chronological order, with bullet points for clarity where possible.

#### Show advanced ‘Main LLM’ settings

Enable this option to see advanced settings for the main model, which include:

##### Configure your Conversation system prompt

For more advanced configuration of the LLM System prompt, you can provide a custom system prompt or override the prompt in charge of guiding the LLM. You need to enable the advanced settings

##### Force Streaming Mode (>= 1.6.1)

When enabled the selected model is treated as being capable of streaming. This is particularly beneficial when working with custom models whose capabilities Dataiku Answers cannot automatically detect.

Note

Enabling this setting on a model that does not support streaming will result in errors.

##### Force Multi Modal Mode (>= 1.6.1)

When enabled the selected model is treated as being able to accept multi-modal queries. This is particularly beneficial when working with custom models whose capabilities Dataiku Answers cannot automatically detect.

Note

Enabling this setting on a model that does not support multi-modal queries will result in errors.

##### Maximum Number of LLM Output Tokens

Set the maximum number of output tokens that the LLM can generate for each query. To set this value correctly, you should consult the documentation of you LLM provider.

Caution

  * Setting this value too low can mean answers are not completed correctly.

  * For paid LLM services, higher token usage increases running costs.




##### LLM Temperature (>= 1.2.0)

Set the temperature of the LLM to control the randomness and creativity of the responses when multiple agents or no agents are called. A lower value makes answers more straightforward, while a higher value encourages more creativity. (recommended) For best accuracy, use a value as close to 0 as possible.

Caution

  * Setting the temperature of the decisions LLM to anything other than 0.0 is not recommended as it can lead to inconsistent decision results.

  * Set a negative value (e.g. -1) to use your LLM-mesh default temperature.

  * Set a positive value only if your LLM-mesh doesn’t support 0.0.

  * Setting temperature is not supported by all models and temperature ranges can vary between models.




#### LLM For Title Generation (>= 1.2.0)

Set alternative LLM to generate the title for each conversation. Leaving it as None will default to using the main LLM. As this task is less demanding, you can use a smaller model to generate the titles.

#### LLM For Decisions Generation (>= 1.2.0)

Set alternative LLM to use to generate decision objects. As this task is more suited to models that are good at generating structured data, you can choose a model specialized for the task. Leaving as None will default to use the main LLM.

Note

It is recommended to use a higher performance model for decisions generation.

When you set an alternative LLM, you’ll be able to access advanced settings to configure the LLM temperature and the maximum number of output tokens, similar to what can be done for the ‘Main’ LLM.

#### Enable Image Generation for Users

This checkbox allows you to activate the image generation feature for users. Once enabled, additional settings will become available. 

Note

Important Requirements:
    

  * An upload folder is necessary for this feature to function, as generated images will be stored there.




**Users can adjust the following settings through the UI**
    

  * Image Height

  * Image Width

  * Image Quality

  * Number of Images to Generate




The user settings will be passed to the image generation model. If the selected model does not support certain settings, the image generation will fail. Any error messages generated by the model will be forwarded to the user in English, as we do not translate the model’s responses.

##### Image Generation Model

The model to use for image generation. This is mandatory when the image generation feature is enabled.

Note

Image generation is available with image generation models supported in Dataiku LLM Mesh; this includes:
    

  1. OpenAI (DALL-E 3)

  2. Azure OpenAI (DALL-E 3)

  3. Google Vertex (Imagen 1 and Imagen 2)

  4. Stability AI (Stable Image Core, Stable Diffusion 3.0, Stable Diffusion 3.0 Turbo)

  5. Bedrock Titan Image Generator

  6. Bedrock Stable Diffusion XL 1




##### Configure the Query Builder Prompt for Image Generation

Image generation begins by the main chat model creating an image generation query based on the user’s input and history. You can include a prompt for guidelines and instructions on building this query. Only modify this if you fully understand the process.

##### Weekly Image Generation Limit Per User

Set the number of images that each user can generate per week.

### Document Upload

#### Overview

You can upload multiple files of different types, enabling you to ask questions about each using the Agent Connect interface. Uploading a file with no question will create a summary of each document uploaded with some example questions. Alternatively, if you ask a question when uploading the LLM will use the document to answer the question.

Agent Connect can process the following types of documents:

  * Images: `.png`, `.jpeg`, `.webp`, `.gif`.

  * Other files: `.pdf`, `.docx`, `.json`, `.py`, `.html`, `.js`, `.md` and `.pptx` ( >= 1.6.0 for `.pptx`).




The two main methods that LLMs can use to understand the documents are:

>   1. **Viewing** as an image (multi-modal). **This method is only available when LLMs have multimodal capabilities**. It can be used for image files PDFs or PPTX. **Visual agents are not compatible with this method**.
> 
>   2. **Reading** the extracted text (no images). This method is supported on all LLMs and files containing plain text.
> 
> 


Consideration needs to be taken with both methods to avoid exceeding the context window of the LLM you are using.

Note

PPTX handling requires Agent Connect >= 1.6.0 .

Warning

Visual agents are not compatible with documents uploaded using ‘document as images’ data extraction method.

Once all the ‘Document upload’ parameters are set, different interactions with documents are possible depending on both the retrieval method you set and the user requests. Document data processing depends on whether you choose to send document data as images _(only for .pdf and .pptx)_ or as extracted text:

  * If you choose to send document pages as images, each image will be passed to the context of a multimodal _Main LLM_ completion.

  * Otherwise, the document text will be extracted and will be passed to the context of a _Main LLM_ completion.




#### Usage

There are two main ways to interact with uploaded documents:

  * Upload documents without a query.

  * Upload documents with a query.




Note

Once uploaded, the document information is part of the conversation context unless users manually delete it.

#### Document upload without query (triggers summarization)

When documents are uploaded without any request, the Dataiku Answers _Main LLM_ will summarize their content. The following diagram shows how this process is handled by the answers backend.

Note

One summary will be generated for each document.

#### Document upload with query

When documents are uploaded with a request that does not trigger the use of your retrieval method, their data is combined with the chat history in a LLM completion context to provide a direct answer to the user. This completion can be from the _Main LLM_ or from the connected Agents/Augmented-LLMs/Dataiku Answers.

#### Document Upload configuration

**Maximum upload file size in MB**

Allows you to set the file size limit for each uploaded file. The default value is 15 MB; however, some service providers may have lower limits.

**Maximum number of files that can be uploaded at once**

This parameter controls the number of documents that the LLM can interact with simultaneously using both methods.

**Send PDF pages as images instead of extracting text**

This parameter allows the LLM to view each page using Method 1. It is most useful when the pages contain visual information such as charts, images, tables, diagrams, etc. This will increase the quality of the answers that the LLM can provide but may lead to higher latency and cost.

**Maximum number of PDF pages or PPTX slides to send as images**

This parameter sets the threshold number of pages to be sent as images. The default value is 5. For example, if 5 concurrent files are allowed and each has a maximum of 5 pages sent as images, then 25 images are sent to the LLM (5 files x 5 pages each = 25 images). If any document exceeds this threshold, the default behavior is to use text extraction alone for that document. Understandably, this increases the cost of each query but can be necessary when asking questions about visual information.

**Scale to resize PDF screenshots ( >= 1.6.0)**

The default PDF images size is (540, 720). This parameter controls the scale of the images to pass to the LLM that will be (540 x scale, 720 x scale) A lower scale leads to a faster LLM response, but with less visual details are provided to the LLM. A higher scale provides more visual details to the LLM but increases the response time.

**Scale to resize PPTX screenshots( >= 1.6.0)** The default PPTX images size is (720, 405). This parameter controls the scale of the images to pass to the LLM that will be (720 x scale, 405 x scale) A lower scale leads to a faster LLM response, but with less visual details are provided to the LLM. A higher scale provides more visual details to the LLM but increases the response time.

### Agents advanced configuration (>= 1.2.1)

**Forward user query to the configured agent ( >= 1.4.0)** Streamline processing by skipping the decision chain when only one ‘Agent’ / ‘Answer’ / ‘Augmented-LLM’ is configured in Agent Connect. In this case, all user queries and history will be sent directly to the configured agent.

Note

If multiple agents are configured, this setting will be ignored. Agent descriptions must still be provided in the _Answers & Agents configuration_ section.

**Do not check end user permissions ( >= 1.4.0)** When enabled, Agent Connect will evaluate access based on the permissions of the user running the backend, rather than filtering agents by the end user’s Dataiku permissions.

Note

This removes the requirement to run the backend as an `Admin`. If enabled, it is your responsibility to ensure that end users are authorized and have access to the agents configured in the web application. This setting also resolves issues when running the application on the Cloud due a difference in the Admin permissions on the Cloud.

**Customize each agent ( >= 1.4.0)** Gain more control over agent behavior. Enable this setting to add custom instructions per agent and disable file upload for agents that do not support document processing.

To get started:

  * Click on `ADD AN OBJECT`

  * Select the agent you want to customize

  * Fill in the instructions and/or disable file upload




**Display Agents Answers** You can control whether each agent’s response is visible in the Sources section for end users. By enabling this, users can see the responses from agents when multiple agents have been called in Agent Connect. This helps to better understand the information Agent Connect used to produce the final response. It is disabled by default

**Display Source Chunks** You can show or hide text chunks or extracts from the sources used by agents in the Sources section. This provides users with more insights into the source material referenced by agents. It is Enabled by default.

**Display SQL Queries Generated by Agents** This setting gives the admin the ability to show or hide SQL queries generated by agents in the Sources section when they are generating queries. Enabling this can be useful for users who need to see the SQL queries for debugging or analysis purposes. It is disabled by default.

### End User Interface Configuration

Adjust the web application to your business objectives and accelerate user value.

#### Titles and Headings

Set the title and subheading for clarity and context in the web application.

#### Displayed Placeholder Text in the ‘Question Input’ Field

Enter a question prompt in the input field to guide users.

#### Example Questions

Provide example questions to illustrate the type of inquiries the chatbot can handle. You can add as many questions as you want

#### Disclaimer Displayed to the End User in the Footer of the Web Application

This option allows you to present a detailed rich text disclaimer to the end user, which will be prominently displayed in the footer of the web application. The disclaimer can include hyperlinks, such as those directing users to the company’s internal policy on responsible AI use.

#### Enable Custom Rebranding

If checked, the web application will apply your custom styling based on the theme name and different image files you specify in your setup. For more details, check the UI Rebranding capability section.

>   * **Theme name** : The theme name you want to apply. Css, images and fonts will be fetched from the folder `agent-connect/YOUR_THEME`
> 
>   * **Logo file name** : The file name of your logo that you added to `agent-connect/YOUR_THEME/images/image_name.extension_name` and you want to choose as the logo in the web application.
> 
>   * **Icon file name** : Same as for the logo file name.
> 
> 


### User Profile Settings

#### User profile Languages

  * The language setting will be available by default for all users, initially set to the web application’s chosen language.

  * The language selected by the user will determine the language in which the LLM responses are provided.

  * You can define the settings using a list, where each setting consists of a key (the name of the setting) and a description (a brief explanation of the setting).




#### Default User Language (>= 1.1.0)

Set the default language for all users to use for LLM interaction. The default language will be used for all users who have not set their language preference. By default, the language is set to English.

#### User Profile Settings

  * Once the user has configured their settings, these will be included in the LLM prompt to provide more personalized responses.

  * All settings will be in the form of strings for the time being.




#### Add Profile Information to LLM Context

User profile information can now be included in the query that the LLM receives. This can mean that the LLM can provide more personalized responses based on the user’s settings.

Note

All the users profiles are initialized with default settings. The user profiles are only saved after users edit and save them directly (_e.g: Editing the language_) or indirectly (_e.g: requesting for an image generation_). It is then possible that your user profile dataset is empty despite the fact several people are using your application.

### WebApplication Configuration

#### Language

You can choose the default language for the web application from the available options (English, French, Spanish, German, Japanese and Korean).

#### HTTP Headers

Define HTTP headers for the application’s HTTP responses to ensure compatibility and security.

#### Disable SSL verification (>= 1.4.0)

Allows you to disable SSL verification when calling agents of type _Answers web application_. This setting addresses specific connectivity issues encountered in Cloud environments.

### UI Rebranding capability

You can rebrand the web application by applying a custom style without changing the code by following these steps:

  * Navigate to **᎒᎒᎒ > Global Shared Code > Static Web Resources**, create a folder named `agent-connect`, and within this folder, create a subfolder corresponding to the theme that the web application settings will reference: This subfolder will be named `YOUR_THEME_NAME` as an example. The structure should be as follows:



    
    
    agent-connect
       └── YOUR_THEME_NAME
           ├── custom.css
           ├── fonts
           │   └── fonts.css
           └── images
               ├── answer-icon.png
               └── logo.png
    

#### CSS Changes

> Add a `custom.css` file inside the `YOUR_THEME_NAME` folder; you can find an example below:
>     
>     
>     :root {
>        /* Colors */
>        --brand: #e8c280; /* Primary color for elements other than action buttons */
>        --bg-examples-brand: rgba(255, 173, 9, 0.1); /* Examples background color (visible on landing page/new chat) */
>        --bg-examples-brand-hover: rgba(255, 173, 9, 0.4); /* Examples background color on hover */
>        --bg-examples-borders: #e8a323; /* Examples border color */
>        --examples-question-marks: rgb(179, 124, 15); /* Color of question marks in the examples */
>        --examples-text: #422a09; /* Color of the text in the examples */
>        --text-brand: #57380c; /* Text color for the question card */
>        --bg-query: rgba(245, 245, 245, 0.7); /* Background color for the question card */
>        --bg-query-avatar: #F28C37; /* Background color for the question card avatar */
>     }
>     
>     .logo-container .logo-img {
>        height: 70%;
>        width: 70%;
>     }
>     

#### Fonts Customization

>   * First, create the `fonts` subfolder inside the folder `YOUR_THEME_NAME`.
> 
>   * Second, add `fonts.css` and define your font like below depending on the format you can provide _(we support base64 or external URL)_ :
>         
>         @font-face {
>            font-family: "YourFontName";
>            src: url(data:application/octet-stream;base64,your_font_base64);
>         }
>         
>         @font-face {
>            font-family: "YourFontName";
>            src: url("yourFontPublicUrl") format("yourFontFormat");
>         }
>         
> 
>   * Finally, declare the font in your `custom.css` file:
>         
>         body,
>         div {
>            font-family: "YourFontName" !important;
>         }
>         
> 
> 


#### Images customization

Create an `images` folder where you can import `logo.*` file to change the logo image inside the landing page, and `answer-icon.*` to change the icon of the AI answer.

#### Examples of Current Customizations

### Final Steps

After configuring the settings, thoroughly review them to ensure they match your operational requirements. Conduct tests to verify that the chat solution operates as intended, documenting any issues or FAQs that arise during this phase.

**Mobile Compatibility**

The web application is designed to be responsive and fully compatible with mobile devices. To target mobile users effectively, configure the application as a Dataiku public web application and distribute the link to the intended users.

## Security and permissions

### About DSS permissions

DSS [project permissions](<../../security/permissions.html>) are handled as follows:

  * DSS uses a groups-based model to allow users to perform actions through it.

  * The basic principle is that users are added to groups, and groups have permissions on each project.




On top of that, it is possible to:

  * Define per-user permissions on projects.

  * Share webapps into [workspaces](<../../workspaces/index.html>) that have their own set of user/group permissions.




### Agent Connect permissions

Agent Connect leverages the Dataiku DSS permissions foundations:

  * Both [Answers instances](<answers.html>), [Agents](<../../agents/index.html>), and Augmented LLMs are components of the projects where they are created.

  * When interacting with Agent Connect, users can only access the project or [workspaces](<../../workspaces/index.html>) resources they have permissions on.




Warning

While it is not mandatory to be an instance administrator to create and configure an Agent Connect application, **checking the users’ permissions before processing their requests requires running the webapp backends as an instance administrator user**. A new setting introduced in version 1.4.0 allows you to remove this constraint. See the **Do not check end-user permissions** setting description for more details.

### Document-level security in Agent Connect (>= 1.3.0)

#### Before Agent Connect

To control access to content indexed into Knowledge Banks, Agent Connect can leverage the [Knowledge Bank search document-level security](<../../agents/tools/knowledge-bank-search.html>) defined in Knowledge Bank Search tools and Augmented LLMs. To enable this feature, follow these steps:

  * In the Advanced section of the Knowledge Bank embedding recipe, specify a `security tokens column` (This column must contain the list of security groups allowed to access each document).

  * Document level security is implemented for both ‘Agents’ and ‘Augmented LLMs’.
    
    * To use it with an Agent: In an Agent’s **Knowledge Bank Search tool settings** , enable the `Enforce document-level security` parameter.

    * To use it with an Augmented LLM: In the **Augmented-LLM settings** , enable the `Enforce document-level security` parameter.




Warning

Document-level security is not currently supported for Dataiku Answers instances through Agent Connect.

#### Agent Connect Document-level security process

The following images highlight how Agent Connect handles the document-level security.

On the left a user that belongs to the groups `["group_A", "group_B"]` sends a query. On the right, some documents `Doc 1`, `Doc 2`, `Doc 3` were embedded in a Knowledge Bank using security tokens:

  * The security tokens for `Doc 1` are `[“group_A”]`.

  * The security tokens for `Doc 2` are `[“group_B”]`.

  * The security tokens for `Doc 3` are `[“group_C”]`.




The Knowledge Bank is used by either an Agent or an Augmented-LLM that is plugged to Agent Connect.

When the user sends a request, it is handled by Agent Connect first.

Agent Connect crafts some security tokens access information according to the user characteristics: in this example, the user groups _(More details on this process will be shared in the next section)_

The Agent or Augmented-LLM then leverages the security tokens access information to filter the content that the user is not allowed to access.

#### Agent Connect security tokens access information

In the Document-level security process, Agent Connect will simply pass security tokens access information to the Agent/Augmented-LLM completions. The following code sample highlights what happens on Agent Connect Backend _(Document-level security was first implemented in 1.3.0 and the information passed to the completion context changed over time)_ :

> 
>     # Agent Connect >= 1.7.0:
>     completion.with_context(
>               {
>                   "callerSecurityTokens": user_groups + [f"dss_group:{group}" for group in user_groups] + user_info, # user_info = [f"dss_user_login:{user}"]
>                   "dku_user_email": email,
>                   "dku_user_login": user,
>                   "dku_user_display_name": display_name,
>                   "dku_conversation_id": conversation_id
>               }
>           )
>     
>     # Agent Connect in [1.5.0; 1.7.0[:
>     completion.with_context(
>               {
>                   "callerSecurityTokens": user_groups + [f"dss_group:{group}" for group in user_groups] + user_info, # user_info = [f"dss_user_login:{user}", "dss_user_emailaddress:{email}"]
>               }
>           )
>     
>     # Agent Connect in [1.3.0; 1.5.0[:
>     completion.with_context(
>               {
>                   "callerSecurityTokens": user_groups
>               }
>           )
>

---

## [generative-ai/chat-ui/answers-versions/latest-answers]

# Configuring Answers >= 2.5.0

This section explains how to configure Answers webapps having a version >= 2.5.0. If your version is prior to 2.5.0, please follow [Configuring Answers prior to 2.5.0](<legacy-answers.html>).

Note

Check the Answers [Requirements](<../answers.html#answers-requirements>).

## LLM and Datasets [Mandatory]

This section allows you to set up the main LLM and the datasets required to run the app.

### Main LLM

The **Main LLM** comes from your LLM Mesh connection. This is the one that is in charge of generating the final answer to the user:

  * Directly using the conversation history if no Retrieval Augmented Generation (RAG) process is involved.

  * Leveraging the conversation history augmented with some retrieved context otherwise.




Note

If you want to the ‘Main LLM’ to use a retrieval method, you should choose a LLM that is neither an Agent, nor an Augmented-LLM.

Warning

If you choose a ‘Main LLM’ that is an Agent or an Augmented-LLM, you might need to choose ‘regular’ LLMs _(native LLM from a LLM-mesh connection)_ for the ‘Title generation’ and ‘Decisions generation’ tasks.

### History dataset

Dataiku Answers allows you to store all conversations for oversight and usage analysis. Create a new or select an existing SQL dataset for logging queries, responses, and associated metadata (LLM used, Knowledge Bank, feedback, filters, etc.).

### User profile dataset

This dataset allows you to save the settings that the user can customize within the application. These can be leveraged by the LLMs to tailor the answers to the user’s specifications. User language choice is included by default.

Warning

  * A user profile dataset and a conversation history dataset are required to use Dataiku Answers.

  * Dataiku Answers can only be used with SQL datasets. To check the supported connections please follow [Infrastructure](<../answers.html#answers-requirements-infrastructure>)




Note

All the users profiles are initialized with default settings. The user profiles are only saved after users edit and save them directly (_e.g: Editing the language_) or indirectly (_e.g: requesting for an image generation_). It is then possible that your user profile dataset is empty despite the fact several people are using your application.

## Retrieval method

This section allows you to configure how information is retrieved and what context is sent to the LLM.

### Select retrieval method

You can choose between three retrieval methods:

  * No Retrieval. LLM Answer Only [Default value]: No external sources of information will be provided to the LLM.

  * Use Knowledge Bank Retrieval (for searches within text): The LLM will be provided with information taken from the Dataiku Knowledge Bank.

  * Use Dataset Retrieval (for specific answers from a table): A SQL query will be crafted to provide information to the LLM.




Note

If you chose a ‘Main LLM’ that is an Agent or an Augmented-LLM, you should choose _No Retrieval_.

#### Knowledge retrieval parameters

If you connect a Knowledge Bank to your Dataiku Answers, the following settings allow you to refine KB usage to optimize results. Currently, Dataiku answers supports the use of:

  * Pinecone

  * ChromaDB

  * Qdrant

  * Azure AI search

  * ElasticSearch




Note

  * Using FAISS is no longer recommended for use with Dataiku Answers but is still supported.

  * Multimodal Knowledge Banks require Answers




##### Knowledge bank

This option allows you to select the Knowledge Bank to connect to Answers.

##### Customize knowledge bank’s Name

This feature enables you to assign a specific name to the Knowledge Bank, which will be displayed to users within the web application whenever the Knowledge Bank is mentioned.

##### Activate the knowledge bank by Default

With this setting, you can determine whether the Knowledge Bank should be enabled (‘Active’) or disabled (‘Not active’) by default.

##### Let ‘Answers’ decide when to use the Knowledge Bank based

Enabled by default, this option allows you to turn on or off the smart use of the knowledge bank. If enabled, the LLM will decide when to use the knowledge bank based on its description and the user’s input. Disabled, the LLM will always use the knowledge bank when one is selected. We recommend keeping this option always enabled for optimal results.

###### Knowledge bank description

Adding a description helps the LLM assess whether accessing the Knowledge Bank is relevant for adding the necessary context to answer the question accurately. For example, in cases when `Let ‘Answers’ decide when to use the Knowledge Bank` is enabled and it is not required, it will not be used. Also, when the LLM is crafting a query it will use the description to determine which query to use based on the description.

##### Provide any instructions to your LLM when knowledge bank is used

This functionality allows you to define a custom prompt that will be utilized when the Knowledge Bank is active. This one must provide context around the available data in addition to the traditional LLM role and guidelines.

##### Configure your retrieval system prompt

You can provide a custom prompt for a more advanced retrieval prompt configuration in a knowledge bank. To do so, you must enable the advanced settings option, as shown below.

##### Number of documents to retrieve

Set how many documents the LLM should reference to generate responses. The value is a maximum but can be less if other settings (e.g. a similarity threshold) reduce the final number of returned documents.

##### Search type

You can choose between one of three prioritization techniques to determine which documents augment the LLM’s knowledge.

Note

Incorrectly setting these values can lead to suboptimal results or no results being returned.

  * **Similarity score only** : provides the top n documents based on their similarity to the user question by the similarity score alone.

  * **Similarity score with threshold** : will only provide documents to the LLM if they meet a predetermined threshold of similarity score [0,1]. It should be cautioned that this can lead to all documents being excluded and no documents given to the LLM.

  * **Improve Diversity of Documents** : enable this to have the LLM pull from a broader range of documents. Specify the ‘**Diversity Selection Documents** ’ number and adjust the ‘**Diversity Factor** ’ to manage the diversity of retrieved documents.

  * **Hybrid search** [Only available for Azure AI search vectorstores]: will combine vector search (similarity between embeddings) with keyword search (lexical matching) in a single query.

  * **Semantic hybrid search** [Only available for Azure AI search vectorstores]: will apply a semantic re-ranking of the documents right after an hybrid search.




##### Filter logged sources

Enable this option to control the number of data chunks (**Number of top sources to log**) recorded in the logging dataset. It is important to note that users can access only as many chunks as are logged.

##### Display source extracts

Display or hide source extracts to the end user when using a knowledge bank. This option is enabled by default. Disable to hide them.

##### Select the metadata to include in the context of the LLM

When enabled the selected metadata will be added to the retrieved context along with document chunks.

##### LLM citations

The checkbox is available when you use a Knowledge Bank for RAG. Enabling this option allows you to get citations in the answers provided by the LLM during the text generation process. These citations will reference the IDs of the linked sources and quote the relevant part from these sources that allowed the text generation.

##### Filters and Metadata

All metadata stem from the configuration in the embed recipe that constructed the Knowledge Bank. Set filters, display options, and identify metadata for source URLs and titles.

**Metadata Filters** : Choose which metadata tags can be used as filters. This feature allows you to run the vector query on a subset of the documents in the Knowledge Bank. Meaning a combination of conditional logic and vector search can be combined in a single query.

>   * Development of this feature is ongoing and so it is only currently available for the following vector databases:
>
>>     * ChromaDB, Qdrant and Pinecone.
>> 
>>     * Metadata filtering is not supported with FAISS.
> 
>   * Auto filtering: Enabling LLM auto filtering means that the LLM will choose if the query would benefit from reducing the documents corpus using a conditional logic based query along with the regular vector based query. If enabled then the LLM will craft the query to create this filter.
> 
> 


**Metadata Display** : Select metadata to display alongside source materials.

**URLs and Titles** : Determine which metadata fields should contain the URLs for source access and the titles for displayed sources.

Note

  * Displaying metadata from multimodal Knowledge Banks require Answers.

  * Filtering custom metadata from multimodal Knowledge Banks require Answers >= 2.6.0




#### Dataset Retrieval Parameters

If you connect a Dataiku dataset to your Dataiku Answers, the following settings allow you to refine how this information is handled.

Caution

It is strongly advised to use LLMs which are intended for code generation. LLMs whose primary focus is creative writing will perform poorly on this task. The specific LLM used for query generation can be specified the LLM For Decisions Generation setting.

Caution

If you frequently experience JSONDecodeError errors it is very likely that the LLM (1) didn’t format its JSON response properly or (2) ran out of tokens before it could finish the JSON response. For (1), this LLM is not suited to this task. LLMs which are specialized in code generation are preferred. For (2), increase the max token size or choose an LLM with more tokens.

##### Choose a connection

Choose the SQL connection containing datasets you would like to use to enrich the LLM responses. You can choose from all the connections used in the current Dataiku Project but only one connection per Dataiku Answers web application.

##### Customize how the connection is displayed

This feature enables you to assign a specific, user-friendly name for the connection. This name is displayed to users within the web application whenever the dataset is mentioned.

##### Choose dataset(s) (SQL)

Select the dataset(s) you would like the web application to access. You can choose among all the datasets from the connection you have selected previously. This means that all the datasets must be on the same connection.

##### [In your flow] Describe the connected data

Add a description to the dataset and their columns so the retrieval works effectively. They will be added to the LLM prompt so that the LLM can understand how to handle your data. Adding the descriptions can be done in the following way:

**For the dataset**

Select the dataset, click the information icon in the right panel, and click edit. Add the description in either text box.

Warning

The LLM can only generate effective queries if it knows about the data it is querying. You should provide as much detail as possible to clarify what is available.

**For the columns**

Explore the dataset, then click settings and schema. Add a description for each column.

Warning

The LLM will not be able to view the entire dataset before creating the query, so you must describe the contents of the column in detail. For example, if defining a categorical variable, then describe the possible values (“Pass,” “Fail,” “UNKNOWN”) and any acronyms (e.g., “US” is used for the United States).

Warning

Ensure that data types match the type of questions that you expect to ask the LLM. For example, a datetime column should not be stored as a string. Adding the column descriptions here means the descriptions are tied to the data. As a result, changes to the dataset could cause the LLM to provide inaccurate information.

##### Define column mappings

Here you can choose to suggest column mappings that the LLM can decide to follow. For example, in the mapping below, the LLM may choose to create a JOIN like this: `LEFT JOIN Store s ON t.store_id = s.store_id`

##### Configure your LLM in the context of the dataset

This functionality allows you to define a custom prompt that will be utilized when the dataset retrieval is active.

Warning

This prompt is not used with the LLM which creates the the SQL query so it is important not not make SQL suggests here as this will only lead to confusion. Instead use the Questions and their expected SQL queries section to add examples. Alternatively, you can give clear descriptions of how to handle the data in the column and dataset descriptions.

##### Configure your retrieval system prompt

You can provide a custom prompt for a more advanced configuration of the retrieval prompt in a dataset. To do so, you must enable the advanced settings option, as shown below.

##### Define questions and their expected SQL queries

When using dataset retrieval, you can provide examples of questions and their expected SQL queries. This will help the LLM understand how to interact with the dataset. The LLM will use these examples to generate SQL queries when the user asks questions about the dataset. This is particularly useful if there is a specific way to query the dataset that the LLM should follow. For example, a common way of handling dates, a specific way of joining tables or typical CTE (common table expressions) that are used.
    
    
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
    

##### Define hard limit on SQL queries

By default, all queries are limited to 100 rows to avoid excessive data retrieval. However, it may be necessary to adapt this to the type of data being queried. Setting it too high may retrieve excessive data, which can exceed the context window and affect performance. Setting it too low may result in missing information, leading to inaccurate answers.

##### Display generated SQL query in sources

Enabing this option will allow to audit the generated SQL query that allowed your Answers assistant to reply.

## LLM Configuration

This section allows you to fine-tune the LLM settings to tailor its behavior or assign specific models to different task types

### Main LLM

#### Provide any instructions to your LLM in case no knowledge bank or dataset retrievals are used

You can here set the prompt that is used by the main LLM when no retrieval is used in the reply process.

#### Tell the system how it should behave during conversations

For more advanced configuration of the LLM prompt, you can provide a custom prompt or override the prompt in charge of guiding the LLM to reply.

#### Force streaming mode

When enabled the selected model is treated as being capable of streaming. This is particularly beneficial when working with custom models whose capabilities Dataiku Answers cannot automatically detect.

Note

Enabling this setting on a model that does not support streaming will result in errors.

#### Force multi modal mode

When enabled the selected model is treated as being able to accept multi-modal queries. This is particularly beneficial when working with custom models whose capabilities Dataiku Answers cannot automatically detect.

Note

Enabling this setting on a model that does not support multi-modal queries will result in errors.

#### Define maximum number of ‘Main LLM’ output tokens

Set the maximum number of output tokens that the LLM can generate for each query. To set this value correctly, you should consult the documentation of you LLM provider.

Caution

  * Setting this value too low can mean answers are not completed correctly or that queries are incomplete in the case of SQL generation.

  * For paid LLM services, higher token usage increases running costs.




#### Define ‘Main LLM’ temperature

Set the temperature of the LLM to control the randomness and creativity of the responses. A lower value makes answers more straightforward, while a higher value encourages more creativity. (recommended) For best accuracy, use a value as close to 0 as possible.

Caution

  * Setting the temperature of the decisions LLM to anything other than 0.0 is not recommended as it can lead to inconsistent decision results. For example, in the case of generating SQL queries, a higher temperature can lead to erroneous table or column names being used.

  * Set a negative value (e.g. -1) to use your LLM-mesh default temperature.

  * Set a positive value only if your LLM-mesh doesn’t support 0.0.

  * Setting temperature is not supported by all models and temperature ranges can vary between models.




### Title Generation

You can set an alternative LLM to generate the title for each conversation.

Leaving it as None will default to using the ‘Main LLM’. As this task is less demanding, you can use a smaller model to generate the titles.

The ‘Title LLM’ maximim number of output token and temperature parameters can be edited in the same way as for the ‘Main LLM’.

Warning

If you chose a ‘Main LLM’ that is an Agent or an Augmented-LLM, you should set a ‘regular’ LLM _(native LLM from a LLM-mesh connection)_ for the title generation.

### Decisions Generation

You can set an alternative LLM to use to generate decision objects. As this task is more suited to models that are good at generating structured data, you can choose a model specialized for the task.

Leaving as None will default to use the ‘Main LLM’.

Note

The task of generating SQL queries is among the most demanding tasks for an LLM. It is recommended to use a higher performance model for decisions generation when performing dataset retrieval

Warning

If you chose a ‘Main LLM’ that is an Agent or an Augmented-LLM, you should set a ‘regular’ LLM _(native LLM from a LLM-mesh connection)_ for the decisions generation.

## Document Upload

This section allows you to manage storage for images and documents uploaded or generated by the user.

Warning

Visual agents are not compatible with documents uploaded using ‘document as images’ data extraction method.

To learn more about the possible interactions with documents, please follow: [Interacting with uploaded documents](<../answers.html#interacting-with-uploaded-documents>).

### Select upload documents folder

You can select here a document upload folder that will store the file data _(uploaded by the user or generated by the LLM)_ involved in the conversations.

Note

This Folder has to be created in your flow prior to be connected to the web application.

### Maximum upload file size in MB

Allows you to set the file size limit for each uploaded file. The default value is 15 MB; however, some service providers may have lower limits.

### Maximum number of files that can be uploaded at once

This parameter controls the number of documents that the LLM can interact with simultaneously using both methods.

### Send PDF or PowerPoint pages as images instead of extracting text

This parameter allows the LLM to view each page using Method 1. It is most useful when the pages contain visual information such as charts, images, tables, diagrams, etc. This will increase the quality of the answers that the LLM can provide but may lead to higher latency and cost.

### Maximum number of PDF pages or PowerPoint slides to send as images

This parameter sets the threshold number of pages to be sent as images. The default value is 5. For example, if 5 concurrent files are allowed and each has a maximum of 5 pages sent as images, then 25 images are sent to the LLM (5 files x 5 pages each = 25 images). If any document exceeds this threshold, the default behavior is to use text extraction alone for that document. Understandably, this increases the cost of each query but can be necessary when asking questions about visual information.

### Resize scale for PDF screenshots

The default PDF images size is (540, 720). This parameter controls the scale of the images to pass to the LLM that will be (540 x scale, 720 x scale) A lower scale leads to a faster LLM response, but with less visual details are provided to the LLM. A higher scale provides more visual details to the LLM but increases the response time.

### Resize scale for PowerPoint screenshots

The default PPTX images size is (720, 405). This parameter controls the scale of the images to pass to the LLM that will be (720 x scale, 405 x scale) A lower scale leads to a faster LLM response, but with less visual details are provided to the LLM. A higher scale provides more visual details to the LLM but increases the response time.

## Image generation

This section allows you to enhance responses with dynamic image generation.

Note

Ensure a document upload folder is configured to allow users to generate images using the LLM

### Enable image generation for users

Toggle this option in order to allow the LLM to generate images when the user requests it.

Once done, **users can adjust the following settings through the UI** \- Image Height \- Image Width \- Image Quality \- Number of Images to Generate

These settings will be passed to the image generation model. If the selected model does not support certain settings, image generation will fail. Any error messages generated by the model will be forwarded to the user in English, as we do not translate the model’s responses.

### Select image generation model

This model is used for image generation. It is mandatory to select it when the image generation feature is enabled.

Note

Image generation is available with image generation models supported in Dataiku LLM Mesh; this includes:
    

  1. OpenAI (DALL-E 3)

  2. Azure OpenAI (DALL-E 3)

  3. Azure AI Foundry (Stable Diffusion 3.5, DALL-E 3, FLUX 2)

  4. Google Vertex (Imagen 1 and Imagen 2)

  5. Stability AI (Stable Image Core, Stable Diffusion 3.0, Stable Diffusion 3.0 Turbo)

  6. Bedrock Titan Image Generator

  7. Bedrock Stable Diffusion XL 1




### Add additional instructions to the model used to generate images

Image generation begins by the main chat model creating an image generation query based on the user’s input and history. You can include a prompt for guidelines and instructions on building this query.

### Define weekly image generation limit per user

Set the number of images that each user can generate per week.

## Conversation Store

This section allows you to customize the conversation history dataset and the types of feedback users can provide.

### Index the chat history dataset

Enabling this option adds an index to the conversation history dataset to optimize the performance of the plugin.

Note

Indexing is only beneficial for specific database types. It is recommended to consult the database documentation for more information and only change if you are certain it will improve performance.

### Permanent delete

While using Dataiku Answers, users have the ability to erase their conversations. Toggle ‘Permanent Delete’ to permanently delete conversations or keep them marked as deleted, maintaining a recoverable archive.

### Feedback

You can here configure positive and negative feedback options, enabling end-users to interact and rate their experience.

## Answers API

This section allows you to manage all settings to use Answers via API endpoints only, without requiring the user interface.

### Select message history dataset (SQL)

Conversations consist of a series of messages. Each message is a user query and the response from the LLM. The messages history dataset is used to store these messages. As with the all Dataiku Answers datasets, this dataset must be an SQL dataset.

### Select conversation history dataset (SQL)

This dataset stores the metadata associated with user messages from their conversations using the /api/ask endpoint. The conversations metadata are logged only if:

  * You decide to create conversations: For this, set the parameter createConversation to True in the request chatSettings.

  * You decide to update logged conversations: For this, pass the value of an existing conversationId in your request.




### Add description

This text description is used by the Agent Connect LLM when deciding whether to this instance of Dataiku Answers to answer a user query in Agent Connect. The description should be a brief summary of the purpose of the Dataiku Answers instance and its capabilities. More details and examples of how to use Agent Connect can be found in [this documentation](<../agent-connect.html>)

Warning

As Agent Connect instances have their own conversations storage management, their requests only enrich the Messages History Dataset of the Dataiku Answers instances they contact.

### Using the API

To use the API, please follow: [Dataiku Answers API (>= 2.0.0)](<../answers.html#answers-api-documentation>) .

## Interface Customization

This section allows you to customize the interface look and feel to match your company’s brand guidelines or preferences.

### Title and subheading

Set the title and subheading for clarity and context in the web application.

### Questions example

Provide example questions to illustrate the type of inquiries the chatbot can handle. You can add as many questions as you want

### Question Field

Enter a question prompt in the input field to guide users.

### Customization

You can customize the web application style by applying a custom style to edit the following components:

  * The web application home page illustration / logo.

  * The chat assistant icon.

  * The page style.

  * The fonts style.




You can here upload specific files to style each editable component.

Behind the scene, the uploaded files are stored into the instance **᎒᎒᎒ > Global Shared Code > Static Web Resources** under a `YOUR_WEBAPP_THEME_FOLDER` that will be a child of an `answers` folder.

You can find below the structure of the answers customization tree in the **Global Shared/Code Static Web Resources** :

> 
>     answers
>       └── YOUR_WEBAPP_THEME_FOLDER
>           ├── custom.css
>           ├── fonts
>           │   └── fonts.css
>           └── images
>               ├── answer-icon.png
>               └── logo.png
>     

Note

  * Each Dataiku Answers instance has its own `WEBAPP_THEME_FOLDER` to upload data, but it is possible to load themes data from other Dataiku Answers instances.

  * To design faster, you can upload several files for each editable component and select the one you decide to use.




Warning

Accessing the **Global Shared Code** requires admin privileges on the DSS instance.

#### Examples of Current Customizations

## User Profile

This section allows you to configure user profile settings to let users customize their experience, such as language preferences and tailored response options

### Languages

The language setting will be available by default for all users, initially set to the web application’s chosen language.

The language selected by the user will determine the language in which the LLM responses are provided.

You can define the settings using a list, where each setting consists of a key (the name of the setting) and a description (a brief explanation of the setting).

### Select a default user language

Set the default language for all users to use for LLM interaction. The default language will be used for all users who have not set their language preference. By default, the language is set to English.

### User Profile Settings

Users can customize their experience by adding extra profile settings.

These settings will be incorporated into LLM prompts to deliver more accurate and personalized responses. Each one includes:

  * A name: the name of the setting.

  * A description: a short description of that setting




### LLM context

User profile information can be included in the query that the LLM receives so that it provides more personalized responses based on all the user’s settings.

Note

All the users profiles are initialized with default settings. The user profiles are only saved after users edit and save them directly (_e.g: Editing the language_) or indirectly (_e.g: requesting for an image generation_). It is then possible that your user profile dataset is empty despite the fact several people are using your application.

## WebApplication

This section allows you to manage app-level configuration, including language preferences, log verbosity, and HTTP headers.

### Select language

You can choose the default language for the web application from the available options (English, French, Spanish, German, Japanese and Korean).

### Select logs level

This parameter controls the verbosity of the backend logs.

  * Choose the option **INFO** to see less logs.

  * Choose the option **DEBUG** to see all logs. This last option is particularly useful when you need to dissect how each user request is processed.




### Add HTTP headers to include in the web application’s HTTP responses

Define HTTP headers for the application’s HTTP responses to ensure compatibility and security.

## General Feedback

This section allows you to configure feedback settings for the entire application, not limited to individual messages.

### Select general feedback dataset

In addition to conversation-specific feedback, configure a dataset to capture general feedback from users. This dataset can provide valuable insights into the overall user experience with Answers.

### Backend

Note

This section is a DSS webapp core setting and thus is not part of the core Dataiku Answers settings.

  * The **number of Processes must always be set to 0**.

  * Container: You must choose the option **None - Use backend to execute**.




### Final Steps

After configuring the settings, thoroughly review them to ensure they match your operational requirements. Conduct tests to verify that the chat solution operates as intended, documenting any issues or FAQs that arise during this phase.

**Mobile Compatibility**

The web application is designed to be responsive and fully compatible with mobile devices. To target mobile users effectively, configure the application as a Dataiku public web application and distribute the link to the intended users.

For additional support, please contact [industry-solutions@dataiku.com](</cdn-cgi/l/email-protection#0d646369787e797f74207e626178796462637e2b2e3e3a362b2e383f362b2e393536696c796c6466782b2e393b366e6260>).

---

## [generative-ai/chat-ui/answers-versions/legacy-answers]

# Configuring Answers < 2.5.0

This section explains how to configure Answers webapps having a version < 2.5.0. If your version is 2.5.0 or later, please follow [Configuring Answers 2.5.0 and later](<latest-answers.html>).

Note

Check the Answers [Requirements](<../answers.html#answers-requirements>).

## Mandatory Settings

### Choose your LLM

**Main LLM:** Connect each instance of Dataiku Answers to your choice of LLM, powered by Dataiku’s LLM Mesh. Select from the LLMs configured in Dataiku DSS Connections.

### Datasets

**Conversation History Dataset:** Dataiku Answers allows you to store all conversations for oversight and usage analysis. Create a new or select an existing SQL dataset for logging queries, responses, and associated metadata (LLM used, Knowledge Bank, feedback, filters, etc.).

**User Profile Dataset ( >= 1.3.0):** This dataset allows you to save the settings that the user can customize within the application. These can be leveraged by the LLMs to tailor the answers to the user’s specifications. User language choice is included by default.

Warning

  * A user profile dataset and a conversation history dataset are required to use Dataiku Answers.

  * Dataiku Answers can only be used with SQL datasets.




Note

All the users profiles are initialized with default settings. The user profiles are only saved after users edit and save them directly (_e.g: Editing the language_) or indirectly (_e.g: requesting for an image generation_). It is then possible that your user profile dataset is empty despite the fact several people are using your application.

## Other Settings

### Conversations Store Configuration

Flexible options allow you to define storage approach and mechanism.

### Index the chat history dataset

Addition of an index to the conversation history dataset to optimize the performance of the plugin.

Note

Indexing is only beneficial for specific database types. It is recommended to consult the database documentation for more information and only change if you are certain it will improve performance.

### Conversation Deletion

While using Dataiku Answers, users have the ability to erase their conversations. Toggle ‘Permanent Delete’ to permanently delete conversations or keep them marked as deleted, maintaining a recoverable archive.

### Feedback Choices

Configure positive and negative feedback options, enabling end-users to interact and rate their experience.

### Document Folder

Choose a folder to store user-uploaded documents and LLM generated media.

### Allow User Feedback

As you roll out chat applications in your organization, you can include a feedback option to improve understanding of feedback, enablement needs, and enhancements.

### General Feedback Dataset

In addition to conversation-specific feedback, configure a dataset to capture general feedback from users. This dataset can provide valuable insights into the overall user experience with the plugin.

## LLM Configuration

### Configure your LLM when no knowledge bank or table retrieval is required

Tailor the prompt that will guide the behavior of the underlying LLM. For example, if the LLM is to function as a life sciences analyst, the prompt could instruct it not to use external knowledge and to structure the responses in a clear and chronological order, with bullet points for clarity where possible. **This prompt is only used when no retrieval is performed**.

#### LLM For Title Generation (>= 1.5.0)

Set alternative LLM to generate the title for each conversation. Leaving it as None will default to using the main LLM. As this task is less demanding, you can use a smaller model to generate the titles.

### Advanced LLM Setting

#### Configure your Conversation system prompt

For more advanced configuration of the LLM prompt, you can provide a custom system prompt or override the prompt in charge of guiding the LLM when generating code. You need to enable the advanced settings option as shown below.

#### Force Streaming Mode (>= 1.5.0)

When enabled the selected model is treated as being capable of streaming. This is particularly beneficial when working with custom models whose capabilities Dataiku Answers cannot automatically detect.

Note

Enabling this setting on a model that does not support streaming will result in errors.

#### Force Multi Modal Mode (>= 1.5.0)

When enabled the selected model is treated as being able to accept multi-modal queries. This is particularly beneficial when working with custom models whose capabilities Dataiku Answers cannot automatically detect.

Note

Enabling this setting on a model that does not support multi-modal queries will result in errors.

#### Maximum Number of LLM Output Tokens (>= 2.1.0)

Set the maximum number of output tokens that the LLM can generate for each query. To set this value correctly, you should consult the documentation of you LLM provider.

Caution

  * Setting this value too low can mean answers are not completed correctly or that queries are incomplete in the case of SQL generation.

  * For paid LLM services, higher token usage increases running costs.




#### LLM Temperature (>= 2.1.0)

Set the temperature of the LLM to control the randomness and creativity of the responses. A lower value makes answers more straightforward, while a higher value encourages more creativity. (recommended) For best accuracy, use a value as close to 0 as possible.

Caution

  * Setting the temperature of the decisions LLM to anything other than 0.0 is not recommended as it can lead to inconsistent decision results. For example, in the case of generating SQL queries, a higher temperature can lead to erroneous table or column names being used.

  * Set a negative value (e.g. -1) to use your LLM-mesh default temperature.

  * Set a positive value only if your LLM-mesh doesn’t support 0.0.

  * Setting temperature is not supported by all models and temperature ranges can vary between models.




#### LLM For Decisions Generation (>= 1.5.0)

Set alternative LLM to use to generate decision objects. As this task is more suited to models that are good at generating structured data, you can choose a model specialized for the task. Leaving as None will default to use the main LLM.

Note

The task of generating SQL queries is among the most demanding tasks for an LLM. It is recommended to use a higher performance model for decisions generation when performing dataset retrieval

#### Enable Image Generation for Users (>= 1.4.0)

This checkbox allows you to activate the image generation feature for users. Once enabled, additional settings will become available. 

Note

Important Requirements:

  * An upload folder is necessary for this feature to function, as generated images will be stored there. This folder has to be created in the flow of the project hosting Answers prior to enabling this feature.

  * This feature works only with DSS version >= 13.0.0




**Users can adjust the following settings through the UI**
    

  * Image Height

  * Image Width

  * Image Quality

  * Number of Images to Generate




The user settings will be passed to the image generation model. If the selected model does not support certain settings, image generation will fail. Any error messages generated by the model will be forwarded to the user in English, as we do not translate the model’s responses.

#### Image Generation Model (>= 1.4.0)

The model used for image generation. This is mandatory when the image generation feature is enabled.

Note

Image generation is available with image generation models supported in Dataiku LLM Mesh; this includes:
    

  1. OpenAI (DALL-E 3)

  2. Azure OpenAI (DALL-E 3)

  3. Azure AI Foundry (Stable Diffusion 3.5, DALL-E 3, FLUX 2)

  4. Google Vertex (Imagen 1 and Imagen 2)

  5. Stability AI (Stable Image Core, Stable Diffusion 3.0, Stable Diffusion 3.0 Turbo)

  6. Bedrock Titan Image Generator

  7. Bedrock Stable Diffusion XL 1




#### Configure the Query Builder Prompt for Image Generation

Image generation begins by the main chat model creating an image generation query based on the user’s input and history. You can include a prompt for guidelines and instructions on building this query.

Caution

Only modify this if you fully understand the process.

#### Weekly Image Generation Limit Per User (>= 1.4.1)

Set the number of images that each user can generate per week.

### Document Upload (>= 1.4.0)

You can upload multiple files of different types, enabling you to ask questions about each using the answers interface.

Warning

Visual agents are not compatible with document uploadeds using ‘document as images’ data extraction method.

To learn more about the possible interactions with documents, please follow: [Interacting with uploaded documents](<../answers.html#interacting-with-uploaded-documents>).

**Maximum upload file size in MB** (>= 1.4.0)

Allows you to set the file size limit for each uploaded file. The default value is 15 MB; however, some service providers may have lower limits.

**Maximum number of files that can be uploaded at once** (>= 1.4.0)

This parameter controls the number of documents that the LLM can interact with simultaneously using both methods.

**Send PDF pages as images instead of extracting text** (>= 1.4.0)

This parameter allows the LLM to view each page using Method 1. It is most useful when the pages contain visual information such as charts, images, tables, diagrams, etc. This will increase the quality of the answers that the LLM can provide but may lead to higher latency and cost.

**Maximum number of PDF pages or PPTX slides to send as images** (>= 1.4.0)

This parameter sets the threshold number of pages to be sent as images. The default value is 5. For example, if 5 concurrent files are allowed and each has a maximum of 5 pages sent as images, then 25 images are sent to the LLM (5 files x 5 pages each = 25 images). If any document exceeds this threshold, the default behavior is to use text extraction alone for that document. Understandably, this increases the cost of each query but can be necessary when asking questions about visual information.

**Scale to resize PDF screenshots ( >= 2.4.0)**

The default PDF images size is (540, 720). This parameter controls the scale of the images to pass to the LLM that will be (540 x scale, 720 x scale) A lower scale leads to a faster LLM response, but with less visual details are provided to the LLM. A higher scale provides more visual details to the LLM but increases the response time.

**Scale to resize PPTX screenshots( >= 2.4.0)** The default PPTX images size is (720, 405). This parameter controls the scale of the images to pass to the LLM that will be (720 x scale, 405 x scale) A lower scale leads to a faster LLM response, but with less visual details are provided to the LLM. A higher scale provides more visual details to the LLM but increases the response time.

## Retrieval Method

In this section, you can decide how you will augment the LLM’s current knowledge with your external sources of information.

**No Retrieval. LLM Answer Only** : No external sources of information will be provided to the LLM. **(Default value).**

Use Knowledge Bank Retrieval (for searches within text): The LLM will be provided with information taken from the Dataiku Knowledge Bank.

Use Dataset Retrieval (for specific answers from a table): A SQL query will be crafted to provide information to the LLM.

### Knowledge Bank Configuration

If you connect a Knowledge Bank to your Dataiku Answers, the following settings allow you to refine KB usage to optimize results. Currently, Dataiku answers supports the use of

>   * Pinecone
> 
>   * ChromaDB
> 
>   * Qdrant
> 
>   * Azure AI search
> 
>   * ElasticSearch
> 
> 


Note

  * Using FAISS is no longer recommended for use with Dataiku Answers but is still supported.

  * Multimodal Knowledge Banks require Answers >= 2.0.0




#### Customize Knowledge Bank’s Name

This feature enables you to assign a specific name to the Knowledge Bank, which will be displayed to users within the web application whenever the Knowledge Bank is mentioned.

#### Activate the Knowledge Bank By Default

With this setting, you can determine whether the Knowledge Bank should be enabled (‘Active’) or disabled (‘Not active’) by default.

#### Let ‘Answers’ Decide When to use the Knowledge Bank-based (>= 1.2.4)

Enabled by default, this option allows you to turn on or off the smart use of the knowledge bank. If enabled, the LLM will decide when to use the knowledge bank based on its description and the user’s input. Disabled, the LLM will always use the knowledge bank when one is selected. We recommend keeping this option always enabled for optimal results.

#### Knowledge Bank Description

Adding a description helps the LLM assess whether accessing the Knowledge Bank is relevant for adding the necessary context to answer the question accurately. For example, in cases when `Let ‘Answers’ decide when to use the Knowledge Bank` is enabled and it is not required, it will not be used. Also, when the LLM is crafting a query it will use the description to determine which query to use based on the description.

#### Configure your LLM in the Context of a Knowledge Bank

This functionality allows you to define a custom prompt that will be utilized when the Knowledge Bank is active.

#### Configure your Retrieval System Prompt

You can provide a custom system prompt for a more advanced retrieval prompt configuration in a knowledge bank. To do so, you must enable the advanced settings option, as shown below.

#### Number of Documents to Retrieve

Set how many documents the LLM should reference to generate responses. The value is a maximum but can be less if other settings (e.g. a similarity threshold) reduce the final number of returned documents.

#### Search Type

You can choose between one of three prioritization techniques to determine which documents augment the LLM’s knowledge.

Note

Incorrectly setting these values can lead to suboptimal results or no results being returned.

  * **Similarity score only** : provides the top n documents based on their similarity to the user question by the similarity score alone.

  * **Similarity score with threshold** : will only provide documents to the LLM if they meet a predetermined threshold of similarity score [0,1]. It should be cautioned that this can lead to all documents being excluded and no documents given to the LLM.

  * **Improve Diversity of Documents** : enable this to have the LLM pull from a broader range of documents. Specify the ‘**Diversity Selection Documents** ’ number and adjust the ‘**Diversity Factor** ’ to manage the diversity of retrieved documents.

  * **Hybrid search ( >= 2.4.1)** [Only available for Azure AI search vectorstores]: will combine vector search (similarity between embeddings) with keyword search (lexical matching) in a single query.

  * **Semantic hybrid search ( >= 2.4.1)** [Only available for Azure AI search vectorstores]: will apply a semantic re-ranking of the documents right after an hybrid search.




#### Filter Logged Sources

Enable this option to control the number of data chunks recorded in the logging dataset. It is important to note that users can access only as many chunks as are logged.

#### Display Source Extracts

Display or hide source extracts to the end user when using a knowledge bank. This option is enabled by default. Disable to hide them.

#### Select Metadata to Include in the Context (>= 1.2.3)

When enabled the selected metadata will be added to the retrieved context along with document chunks.

#### Enable LLM citations (>= 1.2.0)

The checkbox is available when you use a Knowledge Bank for RAG. Enabling this option allows you to get citations in the answers provided by the LLM during the text generation process. These citations will reference the IDs of the linked sources and quote the relevant part from these sources that allowed the text generation.

#### Filters and Metadata Parameters

All metadata stem from the configuration in the embed recipe that constructed the Knowledge Bank. Set filters, display options, and identify metadata for source URLs and titles.

**Metadata Filters** : Choose which metadata tags can be used as filters. This feature allows you to run the vector query on a subset of the documents in the Knowledge Bank. Meaning a combination of conditional logic and vector search can be combined in a single query.

>   * Development of this feature is ongoing and so it is only currently available for the following vector databases:
>
>>     * ChromaDB, Qdrant and Pinecone.
>> 
>>     * Metadata filtering is not supported with FAISS.
> 
>   * Auto filtering (>= 1.2.2): Enabling LLM auto filtering means that the LLM will choose if the query would benefit from reducing the documents corpus using a conditional logic based query along with the regular vector based query. If enabled then the LLM will craft the query to create this filter.
> 
> 


**Metadata Display** : Select metadata to display alongside source materials.

**URLs and Titles** : Determine which metadata fields should contain the URLs for source access and the titles for displayed sources.

Note

  * Displaying metadata from multimodal Knowledge Banks require Answers >= 2.2.0

  * Filtering custom metadata from multimodal Knowledge Banks require Answers >= 2.6.0 (see [Configuring Answers 2.5.0 and later](<latest-answers.html>)).




### Dataset Retrieval Parameters (>= 1.2.5)

If you connect a Dataiku dataset to your Dataiku Answers, the following settings allow you to refine how this information is handled.

Caution

It is strongly advised to use LLMs which are intended for code generation. LLMs whose primary focus is creative writing will perform poorly on this task. The specific LLM used for query generation can be specified the LLM For Decisions Generation setting.

Caution

If you frequently experience JSONDecodeError errors it is very likely that the LLM (1) didn’t format its JSON response properly or (2) ran out of tokens before it could finish the JSON response. For (1), this LLM is not suited to this task. LLMs which are specialized in code generation are preferred. For (2), increase the max token size or choose an LLM with more tokens.

#### Choose Connection

Choose the SQL connection containing datasets you would like to use to enrich the LLM responses. You can choose from all the connections used in the current Dataiku Project but only one connection per Dataiku Answers web application.

#### Customize How the Connection is Displayed

This feature enables you to assign a specific, user-friendly name for the connection. This name is displayed to users within the web application whenever the dataset is mentioned.

#### Choose Dataset(s)

Select the datasets you would like the web application to access. You can choose among all the datasets from the connection you have selected previously. This means that all the datasets must be on the same connection.

#### [In your flow] Describe the connected data

Add a description to the dataset and the columns so the retrieval works effectively. This can be done in the following way:

**For the dataset**

Select the dataset, click the information icon in the right panel, and click edit. Add the description in either text box.

Warning

The LLM can only generate effective queries if it knows about the data it is querying. You should provide as much detail as possible to clarify what is available.

**For the columns**

Explore the dataset, then click settings and schema. Add a description for each column.

Warning

The LLM will not be able to view the entire dataset before creating the query, so you must describe the contents of the column in detail. For example, if defining a categorical variable, then describe the possible values (“Pass,” “Fail,” “UNKNOWN”) and any acronyms (e.g., “US” is used for the United States).

Warning

Ensure that data types match the type of questions that you expect to ask the LLM. For example, a datetime column should not be stored as a string. Adding the column descriptions here means the descriptions are tied to the data. As a result, changes to the dataset could cause the LLM to provide inaccurate information.

#### Define Column Mappings

Here you can choose to suggest column mappings that the LLM can decide to follow. For example, in the mapping below, the LLM may choose to create a JOIN like this: `LEFT JOIN Orders o ON o.EmployeeID = e.EmployeeID`

#### Configure your LLM in the context of the dataset

This functionality allows you to define a custom prompt that will be utilized when the dataset retrieval is active.

Warning

This prompt is not used with the LLM which creates the the SQL query so it is important not not make SQL suggests here as this will only lead to confusion. Instead use the Questions and their expected SQL queries section to add examples. Alternatively, you can give clear descriptions of how to handle the data in the column and dataset descriptions.

#### Configure your Retrieval System Prompt

You can provide a custom system prompt for a more advanced configuration of the retrieval prompt in a dataset. To do so, you must enable the advanced settings option, as shown below.

#### Questions and their Expected SQL Queries (>= 1.4.1)

When using dataset retrieval, you can provide examples of questions and their expected SQL queries. This will help the LLM understand how to interact with the dataset. The LLM will use these examples to generate SQL queries when the user asks questions about the dataset. This is particularly useful if there is a specific way to query the dataset that the LLM should follow. For example, a common way of handling dates, a specific way of joining tables or typical CTE (common table expressions) that are used.
    
    
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
    

#### Hard Limit on SQL Queries

By default, all queries are limited to 100 rows to avoid excessive data retrieval. However, it may be necessary to adapt this to the type of data being queried.

#### Display SQL in Sources

Selecting this checkbox will add the SQL query to the source information displayed below the LLM’s answers.

### Answers API Configuration

The Dataiku Answers API allows instance of Agent Connect and other sources to make requests to a Dataiku Answers web application without using the Dataiku Answers UI. More information about how to to make requests to the Dataiku Answers API can be found in the dataiku answers API section of this documentation.

### Messages History Dataset (>= 2.0.0)

Conversations consist of a series of messages. Each message is a user query and the response from the LLM. The messages history dataset is used to store these messages. As with the all Dataiku Answers datasets, this dataset must be an SQL dataset.

### Conversation Dataset (>= 2.3.0)

This dataset stores the metadata associated with user messages from their conversations using the /api/ask endpoint. The conversations metadata are logged only if:

  * You decide to create conversations: For this, set the parameter createConversation to True in the request chatSettings.

  * You decide to update logged conversations: For this, pass the value of an existing conversationId in your request.




### Description

This text description is used by the Agent Connect LLM when deciding whether to this instance of Dataiku Answers to answer a user query in Agent Connect. The description should be a brief summary of the purpose of the Dataiku Answers instance and its capabilities. More details and examples of how to use Agent Connect can be found in [this documentation](<../agent-connect.html>)

Warning

As Agent Connect instances have their own conversations storage management, their requests only enrich the Messages History Dataset of the Dataiku Answers instances they contact.

### Using the API

To use the API, please follow: [Dataiku Answers API (>= 2.0.0)](<../answers.html#answers-api-documentation>) .

## End User Interface Configuration

Adjust the web app to your business objectives and accelerate user value.

### Titles and Headings

Set the title and subheading for clarity and context in the web application.

### Displayed Placeholder Text in the ‘Question Input’ Field

Enter a question prompt in the input field to guide users.

### Example Questions

Provide example questions to illustrate the type of inquiries the chatbot can handle. You can add as many questions as you want

### Disclaimer Displayed to the End User in the Footer of the Web Application

This option allows you to present a detailed rich text disclaimer to the end user, which will be prominently displayed in the footer of the web application. The disclaimer can include hyperlinks, such as those directing users to the company’s internal policy on responsible AI use.

### Enable Custom Rebranding (>= 1.2.3)

If checked, the web application will apply your custom styling based on the theme name and different image files you specify in your setup. For more details, check the UI Rebranding capability section.

>   * **Theme name** : The theme name you want to apply. Css, images and fonts will be fetched from the folder `answers/YOUR_THEME`
> 
>   * **Logo file name** : The file name of your logo that you added to `answers/YOUR_THEME/images/image_name.extension_name` and you want to choose as the logo in the web application.
> 
>   * **Icon file name** : Same as for the logo file name.
> 
> 


## User Profile Settings (>= 1.3.0)

### User profile Languages

  * The language setting will be available by default for all users, initially set to the web application’s chosen language.

  * The language selected by the user will determine the language in which the LLM responses are provided.

  * You can define the settings using a list, where each setting consists of a key (the name of the setting) and a description (a brief explanation of the setting).




### Default User Language

Set the default language for all users to use for LLM interaction. The default language will be used for all users who have not set their language preference. By default, the language is set to English.

### User Profile Settings

  * Once the user has configured their settings, these will be included in the LLM prompt to provide more personalized responses.

  * All settings will be in the form of strings for the time being.




### Add Profile Information to LLM Context

User profile information can now be included in the query that the LLM receives. This can mean that the LLM can provide more personalized responses based on the user’s settings.

Note

All the users profiles are initialized with default settings. The user profiles are only saved after users edit and save them directly (_e.g: Editing the language_) or indirectly (_e.g: requesting for an image generation_). It is then possible that your user profile dataset is empty despite the fact several people are using your application.

## Web Application Configuration

### Language

You can choose the default language for the web application from the available options (English, French, Spanish, German, Japanese and Korean).

### HTTP Headers

Define HTTP headers for the application’s HTTP responses to ensure compatibility and security.

## UI Rebranding capability

You can rebrand the web application by applying a custom style without changing the code by following these steps:

  1. Navigate to **᎒᎒᎒ > Global Shared Code > Static Web Resources**

  2. Create a folder named `answers`

  3. Within the `answers` folder, create a subfolder corresponding to the theme that the web application settings will reference: This subfolder will be named `YOUR_THEME_NAME` as an example. The structure should be as follows:




> 
>     answers
>       └── YOUR_THEME_NAME
>           ├── custom.css
>           ├── fonts
>           │   └── fonts.css
>           └── images
>               ├── answer-icon.png
>               └── logo.png
>     

Warning

Accessing the **Global Shared Code** requires admin privileges on the DSS instance.

### CSS Changes

Add a `custom.css` file inside the `YOUR_THEME_NAME` folder; you can find an example below:
    
    
    :root {
        /* Colors */
        --brand: #e8c280; /* Primary color for elements other than action buttons */
        --bg-examples-brand: rgba(255, 173, 9, 0.1); /* Examples background color (visible on landing page/new chat) */
        --bg-examples-brand-hover: rgba(255, 173, 9, 0.4); /* Examples background color on hover */
        --bg-examples-borders: #e8a323; /* Examples border color */
        --examples-question-marks: rgb(179, 124, 15); /* Color of question marks in the examples */
        --examples-text: #422a09; /* Color of the text in the examples */
        --text-brand: #57380c; /* Text color for the question card */
        --bg-query: rgba(245, 245, 245, 0.7); /* Background color for the question card */
        --bg-query-avatar: #F28C37; /* Background color for the question card avatar */
    }
    
    .logo-container .logo-img {
        height: 70%;
        width: 70%;
    }
    

### Fonts Customization

  * First, create the `fonts` subfolder inside the folder `YOUR_THEME_NAME`.

  * Second, add `fonts.css` and define your font like below depending on the format you can provide _(we support base64 or external URL)_ :




> 
>     @font-face {
>       font-family: "YourFontName";
>       src: url(data:application/octet-stream;base64,your_font_base64);
>     }
>     
>     @font-face {
>       font-family: "YourFontName";
>       src: url("yourFontPublicUrl") format("yourFontFormat");
>     }
>     

  * Finally, declare the font in your `custom.css` file:




> 
>     body,
>     div {
>       font-family: "YourFontName" !important;
>     }
>     

### Images customization

Create an `images` folder where you can import `logo.*` file to change the logo image inside the landing page, and `answer-icon.*` to change the icon of the AI answer.

### Examples of Current Customizations

## Final Steps

After configuring the settings, thoroughly review them to ensure they match your operational requirements. Conduct tests to verify that the chat solution operates as intended, documenting any issues or FAQs that arise during this phase.

**Mobile Compatibility**

The web application is designed to be responsive and fully compatible with mobile devices. To target mobile users effectively, configure the application as a Dataiku public web application and distribute the link to the intended users.

For additional support, please contact [industry-solutions@dataiku.com](</cdn-cgi/l/email-protection#acc5c2c8d9dfd8ded581dfc3c0d9d8c5c3c2df8a8f9f9b978a8f999e978a8f989497c8cdd8cdc5c7d98a8f989a97cfc3c1>).

---

## [generative-ai/chat-ui/answers]

# Answers

Note

Answers is mostly replaced by [Agent Hub](<../../agents/agent-hub.html>)

## Overview

Dataiku Answers is a packaged, scalable web application that enables enterprise-ready Large Language Model (LLM) chat and Retrieval Augmented Generation (RAG) to be deployed at scale across business processes and teams.

**Key Features**

  * **Simple and Scalable**

Connect Dataiku Answers to your choice of LLM, Knowledge Bank, or Dataset in a few clicks, and start sharing.

  * **Customizable**

Set parameters and filters specific to your needs. Additionally, you can customize the visual web application.

  * **Governed**

Monitor conversations and user feedback to control and optimize LLM impact in your organization.

  * **Mobile-Responsive** The visual web application is fully responsive, ensuring optimal usability on mobile devices. For seamless operation, it must be [directly accessed](<../../webapps/direct-access.html>)




Whether you need to develop an Enterprise LLM Chat in minutes or deploy RAG at scale, Dataiku Answers is a powerful value accelerator with broad customization options to embed LLM chat usage fully across business processes.

## Getting access

Dataiku Answers plugin is available on demand through the dataiku plugin store. Once installed it gives you access to a fully built Visual Webapp which can be used within your chosen Dataiku Projects. Dataiku Answers versions prior to 2.0.0 can be provided by your Dataiku counterparts (please contact your Dataiku Customer Success Manager or Sales Engineer).

## Requirements

### Dataiku DSS version

  * Dataiku Answers is available for both Dataiku Cloud and Self-Managed.

  * The latest Dataiku version is always the best choice to fully leverage the latest plugin capabilities.




**Dataiku Answers and DSS compatibility matrix**

| DSS ≥ 14.2 | DSS ≥ 13.5.5 | DSS ≥ 13.5.3 < 13.5.5 | DSS 13.5.0–13.5.2 | DSS 13.4.0–13.4.x | DSS 12.4.1–13.3.x (min. rec. 12.5)  
---|---|---|---|---|---|---  
Answers ≥ 2.6.1 | ✅ | ❌ | ❌ | ❌ | ❌ | ❌  
Answers ≥ 2.4.4 | ❌ | ✅ | ❌ | ❌ | ❌ | ❌  
Answers >= 2.4.1 < 2.4.4 | ❌ | ❌ | ✅ | ❌ | ❌ | ❌  
Answers 2.2.0–2.4.0 | ❌ | ❌ | ❌ | ✅ | ✅ | ❌  
Answers 2.0.0–2.1.x | ❌ | ❌ | ❌ | ❌ | ✅ | ❌  
Answers < 2.0.0 | ❌ | ❌ | ❌ | ❌ | ❌ | ✅  
  
### Infrastructure

**Web Application Backend Settings:**
    

  * The number of Processes must always be set to 0

  * Container: None - Use backend to execute




**SQL Datasets:** All datasets used by Dataiku Answers must be SQL datasets for compatibility with the plugin’s storage mechanisms.

>   * **PostgreSQL**
> 
>   * **Snowflake**
> 
>   * **MS SQL Server**
> 
>   * **BigQuery**
> 
>   * **Databricks**
> 
>   * **Oracle** (>= 12.2.0)
> 
> 


Warning

**About Oracle** : The chat history data to log requires the use of the Oracle `TO_CLOB` function. Oracle >= 12.2 allows for 32k bytes per call of `TO_CLOB` but older versions only supports up to 4k which might be too low. It is then recommended ensure your Oracle version is 12.2.0 or later.

**Knowledge Bank Configuration:** If a Knowledge Bank is used, the web application must run locally on Dataiku DSS. This does not affect scalability despite the shift from a containerized environment.

**Streaming:** The plugin seamlessly enables responses to be streamed when supported by the configured LLM, requiring only a DSS version of 12.5.0 or higher with no additional setup (currently supports `openai GPT`, `bedrock Anthropic Claude` and `Amazon Titan` families of models).

## Configuration

Answers 2.5.0 changed significantly the configuration UI so please find below the right documentation according to your version:

## Interacting with uploaded documents

### Overview

Answers can process the following types of documents:

  * Images: `.png`, `.jpeg`, `.webp`, `.gif`.

  * Other files: `.pdf`, `.docx`, `.json`, `.py`, `.html`, `.js`, `.md`, `.pptx` (>= 2.4.0), and `.csv` ( >= 2.6.1).




The two main methods that LLMs can use to understand the documents are:

>   1. **Viewing** as an image (multi-modal). **This method is only available when LLMs have multimodal capabilities**. It can be used for image files PDFs or PPTX. **Visual agents are not compatible with this method**.
> 
>   2. **Reading** the extracted text (no images). This method is supported on all LLMs and files containing plain text.
> 
> 


Consideration needs to be taken with both methods to avoid exceeding the context window of the LLM you are using.

  * [Document upload configuration (>=2.5.0)](<answers-versions/latest-answers.html#latest-document-upload-config>).

  * [Document upload configuration (< 2.5.0)](<answers-versions/legacy-answers.html#legacy-document-upload-config>).




Note

Important Requirements:

  * PDF handling requires Answers >= 1.4.0

  * PPTX handling requires Answers >= 2.4.0




Once all the ‘Document upload’ parameters are set, different interactions with documents are possible depending on both the retrieval method you set and the user requests. Document data processing depends on whether you choose to send document data as images _(only for .pdf and .pptx)_ or as extracted text:

  * If you choose to send document pages as images, each image will be passed to the context of a multimodal _Main LLM_ completion.

  * Otherwise, the document text will be extracted and will be passed to the context of a _Main LLM_ completion.




### Usage

There are two main ways to interact with uploaded documents:

  * Upload documents without a query.

  * Upload documents with a query.




Note

Once uploaded, the document information is part of the conversation context unless users manually delete it.

### Document upload without query (triggers summarization)

When documents are uploaded without any request, the Dataiku Answers _Main LLM_ will summarize their content. The following diagram shows how this process is handled by the answers backend.

Note

One summary will be generated for each document.

### Document upload with query

When documents are uploaded with a request that does not trigger the use of your retrieval method, their data is combined with the chat history in a _Main LLM_ completion context to provide a direct answer to the user.

When documents are uploaded with a request that triggers the use of your retrieval method:

  * Their data is combined with the chat history in a _Decisions LLM_ completion context to craft a retrieval query used in your retrieval process:

    * A query for a semantic search process if you chose _Knowledge Bank Retrieval_.

    * A query for a text to SQL process if you chose _Dataset Retrieval_.

  * The _Main LLM_ will leverage the retrieved information to reply to the user.




## Dataiku Answers API (>= 2.0.0)

The Dataiku Answers API allows you to query a Dataiku Answers web application without using the Dataiku Answers UI. This is allowed by actvivating the use of the answers API in the configuration:

  * [Answers API configuration (>=2.5.0)](<answers-versions/latest-answers.html#latest-answers-api-config>).

  * [Answers API configuration (< 2.5.0)](<answers-versions/legacy-answers.html#legacy-answers-api-config>).




Dataiku Answers endpoints can be accessed using the Dataiku python API (`get_backend_client`) as shown in the example below. They can also be accessed using the URL as follows:

`<INSTANCE_URI>/web-apps-backends/<PROJECT_KEY>/<WEBAPP_ID>/api/`

**Authorization** : used to authenticate the requests. The value should be the Dataiku API token (only needed when not using dataiku api).

  * `Bearer <DATAIKU_API_TOKEN>`




### Endpoints

#### POST /api/ask (>= 2.0.0)

Processes a user query and returns an AI-generated response.

##### Headers

**Content-Type Header** : used to specify the media type of the request body.

**Accept Header** : used to specify the media type of the response body.

  * `application/json`: (default) Returns a JSON response.

  * `text/event-stream` : Enables streaming response using Server-Sent Events (SSE)




A basic one off query without streaming.

> 
>     import dataiku
>     import json
>     from datetime import datetime
>     
>     PROJECT_KEY = "<YOUR_PROJECT_KEY>"
>     WEBAPP_ID = "YOUR_WEBAPP_ID"
>     
>     client = dataiku.api_client()
>     project = client.get_project(PROJECT_KEY)
>     webapp = project.get_webapp(WEBAPP_ID)
>     backend = webapp.get_backend_client()
>     
>     context = {
>        "applicationType": "webapp",
>        "applicationId": "<YOUR_APP_ID>" + "-" + WEBAPP_ID,
>        "timestamp": datetime.now().timestamp(),
>     }
>     user_preferences = {
>           "language": {"value": "en", "description": "User's language"},
>     }
>     chat_settings = {
>           "createConversation": False, # Set True if you want to create a conversation indexing several messages
>           "withTitle": False, # Set True if you want a LLM to compute a conversation title
>           "requestedResponseFormat": "markdown"
>     }
>     
>     # `retrieval_filter_settings` allows to pass filters to the Knowledge Bank when submitting the request
>     retrieval_filter_settings = {}
>     """
>     retrieval_filter_settings = {
>           "selectedRetrieval": {
>                 "name": YOUR_KNOWLEDGE_BANK_ID,
>                 "type": "kb",
>                 # The `filters` key has the format Dict[str, List[str]]
>                 "filters": {
>                       METADATA_1: [STR_VALUE_A, STR_VALUE_B, ...] # `METADATA_1` is the name/column of an indexed metadata. `STR_VALUE_A`, `STR_VALUE_B` are string values that this metadata can take.
>                       }
>                   }
>               }
>     """
>     query = {
>        "user": "admin",
>        "query": "What's the weather like in Japan in February?",
>        "context": context,
>        "userPreferences": user_preferences,
>        "chatSettings": chat_settings,
>        "conversationId": "" # Set an existing conversation ID to index messages with their conversation
>     }
>     if retrieval_filter_settings:
>         query.update(retrieval_filter_settings)
>     
>     headers={
>        "Content-Type": "application/json",
>        "Accept": "application/json",
>     }
>     with backend.session.post(
>        backend.url_for_path("/api/ask"),
>        json.dumps(query),
>        headers=headers
>     ) as ret:
>         if ret.text:
>             try:
>                 response = json.loads(ret.text)
>                 answer = response["data"]["answer"]
>                 print("Answer: ", answer)
>             except json.JSONDecodeError:
>                 print("Unable to parse json")
>         else:
>             print("Response does not contain 'text'")
>     

A basic one off query with streaming.

> 
>     import dataiku
>     import json
>     from datetime import datetime
>     from dataikuapi.dss.llm import _SSEClient
>     
>     PROJECT_KEY = "<YOUR_PROJECT_KEY>"
>     WEBAPP_ID = "YOUR_WEBAPP_ID"
>     
>     client = dataiku.api_client()
>     project = client.get_project(PROJECT_KEY)
>     webapp = project.get_webapp(WEBAPP_ID)
>     backend = webapp.get_backend_client()
>     
>     context = {
>         "applicationType": "webapp",
>         "applicationId": "<YOUR_APP_ID>" + "-" + WEBAPP_ID,
>         "timestamp": datetime.now().timestamp(),
>     }
>     user_preferences = {
>         "language": {"value": "en", "description": "User's language"},
>     }
>     chat_settings = {
>             "createConversation": False, # Set True if you want to create a conversation indexing several messages
>             "withTitle": False, # Set True if you want a LLM to compute a conversation title
>             "requestedResponseFormat": "markdown"
>     }
>     
>     # `retrieval_filter_settings` allows to pass filters to the Knowledge Bank when submitting the request
>     retrieval_filter_settings = {}
>     """
>     retrieval_filter_settings = {
>           "selectedRetrieval": {
>                 "name": YOUR_KNOWLEDGE_BANK_ID,
>                 "type": "kb",
>                 # The `filters` key has the format Dict[str, List[str]]
>                 "filters": {
>                       METADATA_1: [STR_VALUE_A, STR_VALUE_B, ...] # `METADATA_1` is the name/column of an indexed metadata. `STR_VALUE_A`, `STR_VALUE_B` are string values that this metadata can take.
>                       }
>                   }
>               }
>     """
>     query = {
>        "user": "admin",
>        "query": "What's the weather like in Japan in February?",
>        "context": context,
>        "userPreferences": user_preferences,
>        "chatSettings": chat_settings,
>        "conversationId": "" # Set an existing conversation ID to index messages with their conversation
>     }
>     if retrieval_filter_settings:
>         query.update(retrieval_filter_settings)
>     
>     headers={
>         "Content-Type": "application/json",
>         "Accept": "text/event-stream",
>     }
>     complete_answer = ""
>     with backend.session.post(
>         backend.url_for_path("/api/ask"),
>         json.dumps(query),
>         headers=headers
>     ) as ret:
>         if not ret.ok:
>             raise Exception("Error streaming answers")
>         client = _SSEClient(ret)
>         for event in client.iterevents():
>             data = json.loads(event.data)
>             if api_error := data.get("error"):
>                 raise Exception(f"Streamed response failed with status {api_error}")
>             if event.event == "completion-chunk":
>                 text = data.get("text", "")
>                 print(text)
>                 complete_answer+=text
>             elif event.event == "completion-end":
>                 print("Streaming ended")
>         print("Complete Answer: ", complete_answer)
>     

#### Conversations endpoints (>= 2.3.0)

**Query Parameters**

  * `applicationId` (required): The identifier of the application.

  * `user` (required): The user identifier.




**Accept Header** : used to specify the media type of the response body.

  * `application/json`: Returns a JSON response.




##### GET /api/conversations

Retrieves conversation metadata associated with a specific applicationId and user.

**Response example** :
    
    
    {
    "status": "ok",
    "data": {
        "user": "admin",
        "context": {"applicationId": "hello-world-ask"},
        "conversations": [
            {
                "id": "4d02e44f-32a9-410c-94c2-59632bc96a6c",
                "title": {
                    "original": "Weather in Japan in February: A Guide ",
                    "edited": "",
                    "createdAt": "2025-05-15 17:38:39",
                },
                "createdAt": "2025-05-15 17:38:39",
                "lastMessageAt": "2025-05-15 17:38:39",
                "state": "present",
                  }
            ],
         },
      }
    

##### GET /api/conversations/{conversation_id}

Retrieves the messages for a specific conversation associated with a given applicationId and user.

**Response example** :

> 
>     {
>     "status": "ok",
>     "data": {
>         "id": "4d02e44f-32a9-410c-94c2-59632bc96a6c",
>         "title": {
>             "original": "Weather in Japan in February: A Guide ",
>             "edited": "",
>             "createdAt": "2025-05-15 17:38:39",
>         },
>         "createdAt": "2025-05-15 17:38:39",
>         "lastMessageAt": "2025-05-15 17:38:39",
>         "state": "present",
>         "user": "admin",
>         "context": {"applicationId": "hello-world-ask"},
>         "messages": [
>             {
>                 "id": "2fc5eb14-72e6-45c5-a03b-660a0d840bd0",
>                 "createdAt": "2025-05-15 17:38:39",
>                 "query": "What's the weather like in Japan in February?",
>                 "answer": "I don't have real-time data access, but I can provide you with some general information...",
>                 "usedRetrieval": {
>                     "name": "",
>                     "type": "",
>                     "alias": "",
>                     "filters": {},
>                     "sources": [],
>                     "generatedSqlQuery": "",
>                     "usedTables": [],
>                 },
>                 "feedback": {"value": "", "choice": "[]", "message": ""},
>                 "files": [],
>                 "generatedMedia": [],
>                }
>             ],
>          },
>       }
>     

##### DELETE /api/conversations

Deletes all the data associated with a specific applicationId and user, in the conversation and message datasets.

**Response example** :
    
    
    {'status': 'ok', 'message': 'Conversations deleted successfully'}
    

##### DELETE /api/conversations/{conversation_id}

Deletes the data of a single conversation associated with a specific applicationId and user, in the conversation and message datasets.

**Response example** :
    
    
    {'status': 'ok', 'message': 'Conversation deleted successfully'}
    

The following is a code sample shows how to request the conversations endpoints

> 
>     import dataiku
>     
>     
>     PROJECT_KEY = "<YOUR_PROJECT_KEY>"
>     WEBAPP_ID = "<YOUR_WEBAPP_ID>"
>     APPLICATION_ID = "<YOUR_APP_ID>"
>     USER_ID = "<YOUR_USER_ID>"
>     CONVERSATION_ID = "<YOUR_CONVERSATION_ID>"
>     
>     # Connection to the webapp:
>     client = dataiku.api_client()
>     project = client.get_project(PROJECT_KEY)
>     webapp = project.get_webapp(WEBAPP_ID)
>     backend = webapp.get_backend_client()
>     
>     # Retrieve all the conversations:
>     json_response = backend.session.get(backend.url_for_path(f'/api/conversations/?applicationId={APPLICATION_ID}&user={USER_ID}')).json()
>     print(json_response)
>     
>     # Retrieve one conversation based on its ID:
>     json_response = backend.session.get(backend.url_for_path(f'/api/conversations/{CONVERSATION_ID}?applicationId={APPLICATION_ID}&user={USER_ID}')).json()
>     print(json_response)
>     
>     # Delete one conversation based on its ID:
>     json_response = backend.session.delete(backend.url_for_path(f'/api/conversations/{CONVERSATION_ID}?applicationId={APPLICATION_ID}&user={USER_ID}')).json()
>     print(json_response)
>     
>     # Delete all the conversations:
>     json_response = backend.session.delete(backend.url_for_path(f'/api/conversations/?applicationId={APPLICATION_ID}&user={USER_ID}')).json()
>     print(json_response)
>     

## Dataiku Answers rebranding

Answers allows you to customize the interface look and feel to match your company’s brand guidelines or preferences.

  * [Answers rebranding configuration (>=2.5.0)](<answers-versions/latest-answers.html#latest-answers-rebranding-config>).

  * [Answers rebranding configuration (< 2.5.0)](<answers-versions/legacy-answers.html#legacy-answers-rebranding-config>).




## Dataiku Answers user guide

### Introduction

Dataiku Answers provides a powerful interface for querying a Large Language Model (LLM) capable of serving a wide array of domains and specialties. Tailored to your needs, it can deliver insights and answers by leveraging a configured Knowledge Bank for context-driven responses or directly accessing the LLM’s extensive knowledge base.

The application supports multi-modal queries if configured with compatible LLMs.

### Home page functionality

Query Input: The home page is centered around the query input box. Enter your question here, and the system will either:

  * Perform a semantic search within an active Knowledge Bank to provide the LLM with contextual data related to your query, enhancing the relevance and precision of the answer. Remember that queries need to be as precise as possible to maximize the quality of answers. Don’t hesitate to demand access to query guiding principles to support.

  * Send your question directly to the LLM if no Knowledge Bank is configured or activated, relying on the model’s inbuilt knowledge to provide an answer.




### Setting context with filters

Setting filters can provide a more efficient and relevant search experience in a knowledge base, maximizing the focus and relevance of the query. This is particularly relevant for knowledge bases with large or diverse content types.

#### Metadata filter configuration

If metadata filters have been enabled, select your criteria from the available options. These filters pre-define the context, enabling more efficient retrieval from the Knowledge Bank, resulting in answers more aligned with your specific domain or area of interest. Currently metadata filters are only available for ChromaDB, Qdrant and Pinecone.

### Conducting conversations

#### Engaging with the LLM

To start a conversation with the LLM

  * Set any desired filters first to establish the context for your query.

  * Enter your question in the query box.

  * Review the provided information from the contextual data retrieved by the Knowledge Bank or the LLM.




Remember, when a Knowledge Bank is activated and configured with your filters, it will enrich the LLM’s response with specific context, making your results more targeted and relevant. If part of the configuration, Dataiku Answers will allow you to see all sources and metadata for each response item, maximizing trust and understanding. This will include:

  * A thumbnail image.

  * A link to the original source.

  * A title for context.

  * An excerpt from the Knowledge Bank.

  * A list of associated metadata tags as set in the settings.

  * Interact with LLM to refine the answer, translate, summarize, or more.




#### Interaction with filters and metadata

  * Filters in Action

If you’ve set filters before starting the conversation, they’ll be displayed alongside your question. This helps to preserve the context in the LLM’s response.

  * Filter Indicators

A visual cue next to the ‘Settings’ icon indicates the presence and number of active filters, allowing you to keep track of the context parameters currently influencing the search results. 




#### Providing feedback

We encourage users to contribute their experiences:

  * Feedback Button: Visible if general feedback collection is enabled; this feature allows you to express your thoughts on the plugin’s functionality and the quality of interactions. Feedback will be collected in a General Feedback Dataset and analyzed by your Answer set-up team. 




## Conclusion

Dataiku Answers is designed to be user-centric, providing a seamless experience whether you’re seeking detailed responses with the help of a curated Knowledge Bank or Dataset or directly interfacing with the LLM. For additional support, please contact [industry-solutions@dataiku.com](</cdn-cgi/l/email-protection#e881868c9d9b9c9a91c59b87849d9c8187869bcecbdbdfd3cecbdddad3cecbdcd0d38c899c8981839dcecbdcded38b8785>).

---

## [generative-ai/chat-ui/case-study]

# Chat UIs: A Case Study

Whether adopted by a single department or rolled out across multiple teams, companies can have diverse needs regarding the integration of AI-driven chat experiences into their workflows, such as:

  * Use case n°1: The human resources department struggles to keep up with repeated questions about vacation policies, benefits enrollment, and payroll.

  * Use case n°2: The company has a wealth of internal documents, process guidelines, and best practices scattered across multiple places. All the employees waste time searching for the right information.

  * Use case n°3: In a fast-changing data privacy regulation environment, the legal department needs AI assistance to help them work with complex compliance requirements and draft updated agreements.




The type of requests and end users can be heterogeneous from one use case to another, so a good practice would be to create dedicated AI services for each of them to increase the generated answers accuracy and relevance.

The following sections explain how [Answers](<answers.html>) and [Agent Connect](<agent-connect.html>) can be used together to solve these problems.

## Leveraging Answers

[Answers](<answers.html>) is an excellent candidate for use cases ‘1’ and ‘2’ previously introduced, as it will allow the simple leveraging of the company’s data.

The following diagram outlines the creation of [Answers](<answers.html>) services to cover them, with examples of questions they could process.

## Leveraging the LLM Mesh to create an agent

With the need of multi-step reasoning and adaptation to specific tasks, the use case ‘3’ would require to leverage the [LLM Mesh](<../introduction.html>) to [build an Agent](<../../agents/index.html>).

The following diagram outlines the type of interactions users could have with such type of agentic-AI.

## Leveraging Agent Connect

Some employees might need to access several of these AI services. Finding the right entry point to consume them will become more and more complex as their number grows and sometimes the right answer requires to combine some of them.

[Agent Connect](<agent-connect.html>) solves these problems by providing a single place to interact with any of the [Answers](<answers.html>) instances and agents.

Note

‘Agent Connect’ follows the security rules set on the projects hosting [Answers](<answers.html>) or [Agent Connect](<agent-connect.html>). To go further, please [check the Agent Connect documentation](<agent-connect.html>).

Once connected to your [Answers](<answers.html>) and/or [Agents](<../../agents/index.html>), the [Agent Connect](<agent-connect.html>) service is able to smartly route user queries to the right set of generative AI services:

  * When multiple services are selected to fulfill the initial request, the requests are sent concurrently via a pool of threads.

>     * Finally, the responses from each selected AI service are presented to the Agent Connect LLM that combines them to answer the user.

  * When only one service is selected, its answer is forwarded as is to the user.

  * When no service is selected, the Agent Connect LLM answers the user according to their conversation history.




The following diagrams illustrate how Agent Connect would behave and process user requests once connected to the 3 AI services.

### Request example 1

### Request example 2

### Request example 3

---

## [generative-ai/chat-ui/index]

# Chat UI

## Agent Hub

AI chatbots have become indispensable tools for automating repetitive tasks, delivering instant support, and streamlining collaboration.

[Agent Hub](<../../agents/agent-hub.html>) is the central portal for organizations to distribute enterprise-level agents, manage access, and empower users to build their own custom agents.

> ## Other Chat UIs

In addition to Agent Hub, Dataiku also includes two fully-featured chatbot user interfaces, allowing you to expose rich chatbots to your users. They handle security, tracing, user preferences, history, and are customizable.

  * [Answers](<answers.html>) is a full-featured chat user interface for creating chatbots based on your internal knowledge and data.

>   * [Agent Connect](<agent-connect.html>) is an advanced multi-agent chat interface that provides unified access to multiple generative AI services, including:

>     * [Answers instances](<answers.html>)
> 
>     * [Agents](<../../agents/index.html>)




Warning

An [Agent Connect](<agent-connect.html>) service is not itself an agent but instead an agent router, as it routes the user requests towards the relevant generative AI services. When several services are selected to fulfill a user request, Agent Connect combines their responses to generate a final answer.

Note

You can read the [case study](<case-study.html>) to better understand how you can leverage both [Answers](<answers.html>) and [Agent Connect](<agent-connect.html>).

Note that both Agent Connect and Answers will ultimately be replaced by Agent Hub

## Messaging Apps

In addition to web-based interfaces, you can expose Dataiku Agents or LLMs in messaging applications:

  * [Slack integration](<../../agents/slack.html>) to interact with them in Slack channels or direct messages.

  * [Microsoft Teams integration](<../../agents/teams.html>) to interact with them in Teams chats or channel conversations.




## Going further

---

## [generative-ai/cost-control]

# Cost Control

Cost Control in the LLM Mesh helps you manage your LLM costs by setting alerting & blocking thresholds.

Note

You need a licence with Advanced LLM Mesh to customize quotas. If your license does not include it, you can only set up a single global quota (see _Fallback Quota_), which is applied to all LLM queries.

## Concepts

You can set **quotas** that allow you to track spending and decide whether to block queries once the quota is exhausted.

For each **quota** , you can specify:

  * **scope** : LLM queries matched by the quota. Can be all queries, or matching a filter: LLM provider, DSS project, connections, users… Note that a single query can match multiple quotas.

  * **quota amount** : maximum LLM costs, in US dollars, allocated for the quota.

  * **blocking quota** : whether the LLM queries are blocked once the quota amount is reached.

  * **reset period** : time period over which queries are aggregated, _e.g._ every calendar month or rolling 15 calendar days.

  * **alerting** : optional cost thresholds that trigger an email alert. When set up, you are also notified when the quota becomes blocked.

  * **permissions** : granular visibility settings for specific users or groups.




Note

A query can match _multiple quotas_ , in that case _all matching quotas_ see their current spend incremented.

The **Fallback Quota** applies to queries not matching any other quota.

## Limitations

Cost tracking is not supported for the following LLM providers:

  * _Amazon SageMaker LLM_

  * _Databricks Mosaic AI_

  * _Snowflake Cortex_




You cannot create a quota that targets these models specifically, but queries using these models can still match a quota (e.g. a quota with a DSS project scope). If a matched quota is blocking and exhausted, then these queries will be blocked.

_Local Hugging Face_ models cannot be targeted nor blocked by quotas.

## Permissions and Visibility

Only Administrators can create, update, or delete quotas. They can also grant visibility to other users or groups to help them monitor their own consumption.

Visibility Level | Access Details  
---|---  
**Full** | Complete read access, including the total quota amount, real-time cost progress, and configuration details (filters, alert emails, etc.).  
**Basic** | Limited access showing only the quota status (Blocking/Non blocking, Active/Exhausted), reset period, and the percentage of progress.  
  
Note

Granting Full access may expose sensitive information, such as email addresses used for alerts, specific spend amounts, or object identifiers used in custom filters.

Users or groups granted visibility can monitor these quotas by navigating to **Administration** > **Settings** > **LLM Mesh** > **Quotas**.

Note

Non-admin users will only see the Quotas section, not the rest of LLM Mesh configuration settings.

## Setup (Admin only)

Administrators can configure, edit, and manage the lifecycle of all quotas within the dedicated **Cost Control** section, found in **Administration** > **Settings** > **LLM Mesh**.

---

## [generative-ai/evaluation]

# Evaluating LLMs & GenAI use cases

With the adoption of large language models (LLMs), which are able to use natural language as input or output, along with the creation of agents based upon them, the topic of evaluating their performance is both important and not trivial. Standard model evaluation techniques are not well-suited; evaluation of LLMs and agents requires a specific treatment.

This is why Dataiku offers the “Evaluate LLM” and “Evaluate Agent” recipes. These recipes generate various outputs, the most pivotal of which is an evaluation stored in an [evaluation store](<../mlops/model-evaluations/analyzing-evaluations.html>). From this evaluation store, you can then complete your GenAIOps actions with alerting or automated actions.

Note

The “Evaluate LLM” and “Evaluate Agent” recipes are available to customers with the _Advanced LLM Mesh_ add-on.

The specific topic of agent evaluation can be found in [Agent Evaluation](<../agents/evaluation.html>).

## Overview

As LLMs and their usage can be quite diverse, the “Evaluate LLM” recipe is meant to be adaptive. Contrary to the standard [Evaluate recipe](<../mlops/model-evaluations/dss-models.html>), it does not take a model as a direct input, but a single dataset — the output of your pipeline containing all the required columns: input, output, context, ground truth, etc…

With this logic, the recipe can be used directly beyond a Prompt recipe to evaluate an LLM, or a RAG, but it can also be used at the end of a more complex pipeline that uses several techniques, models, and recipes.

When run, the recipe will compute a set of metrics based on the content of the input dataset and create a single LLM evaluation.

Note

Our [LLM evaluation tutorial](<https://knowledge.dataiku.com/latest/deploy/genai-monitoring/tutorial-llm-evaluation.html>) provides a step-by-step explanation of how to create your first LLM evaluation Flow. Do not hesitate to do it as a first experience.

There are some pre-requisites for a working recipe. Those requirements are to be done once, but may require the assistance of your instance administrator.

  * You need to have a [code environment](<../code-envs/index.html>) with the required preset installed (using Python 3.9+). Look for the preset called “Agent and LLM Evaluation”.

  * For most metrics, you will need an LLM to compute embeddings and an LLM for generic completion queries. These LLMs are to be selected from [Dataiku’s LLM Mesh](<llm-connections.html>).




## Recipe configuration

You can create an “Evaluate LLM” recipe from any dataset.

If this is your first experience with the recipe, take a dataset out of a Prompt recipe and use the predefined setup:

  * In the “Input dataset” section, set the Input Dataset Format to “Prompt Recipe” and the task to the relevant type (for example “Question answering”).

  * Ensure you have a proper code environment and LLMs for embedding and completion.

  * Finally, click on the “SELECT COMPUTABLE METRICS” button. All relevant and computable metrics will be selected for you.




With that, you should be able to run your first LLM evaluation. For the sake of understanding, let’s dive a bit more into each section to explain it.

### Input dataset

The Input Dataset Format allows the use of presets for some common tasks in DSS:

  * Prompt Recipe: The Input Dataset is the output dataset of the Prompt recipe.

  * Dataiku Answers: The Input Dataset is the conversation history dataset of the solution.




The “Task” selection allows Dataiku to better guide you in setting up the recipe. If you are not satisfied with any option, you can always use the generic “Other LLM Evaluation Task”. In addition to helpers on the expected columns, the choice of task will also influence the computable metrics.

### Metrics

The “Metrics” section is where you will define the core of the recipe. If you have selected a Task, Dataiku will highlight recommended metrics, but you can always remove metrics you are not interested in.

Below this list, you will need to enter the LLM to use to compute embeddings and the LLM for LLM-as-a-judge metrics. Those fields are not mandatory, as some metrics do not require any LLM, such as BLEU or ROUGE, but most metrics will need those models.

BLEU and ROUGE are metrics based on exact matching of words, specialised in, respectively, translation and summarization.

BERTScore is based on matching of embeddings, but uses an internal embedding model, fetched from HuggingFace ([list of possible models](<https://docs.google.com/spreadsheets/d/1RKOVpselB98Nnh_EOC4A2BYn8_201tmPODpNWu4w7xI>)). This is not an LLM-as-a-judge metric : its results are deterministic.

The other metrics (Answer correctness, Answer relevancy, Answer similarity, Context precision, Context recall, Faithfulness) are LLM-as-a-judge metrics. If you want more in-depth understanding, you can read the [RAGAS documentation](<https://docs.ragas.io/en/latest/concepts/metrics/index.html>). Note that LLM-as-a-judge metrics are computed row-by-row, and the recipe will compute the average for all rows as its final value.

Note

Your instance administrator can setup a default code environment and default LLMs for all “Evaluate LLM” recipes. Look in the section **Administration > Settings > LLM Mesh > Evaluation recipes**.

### Custom Metrics

As LLM evaluation is a quickly evolving topic, the recipe allows you to write your own metric in Python. This is done using a standard “evaluate” function and should return at least one float representing the metric.

Additionally, you can return an array of floats, each entry being the metric value for a single row. This will be used in the row-by-row analysis.

Code samples are available, which can make your first experience with custom metrics easier, or allow you to define your own samples to be reused later.

## LLM Evaluations

Each run of the “Evaluate LLM” recipe will create one LLM evaluation. This LLM evaluation will be visible in the output evaluation store.

In the main view of an LLM evaluation, you see plotted metric graphics at the top and the list of LLM evaluations at the bottom, including metadata, labels, and metrics in a table.

When you open an LLM evaluation, the first section contains: run info, the recipe configuration at the time of the run, and all metrics. You also see the labels that were added during the execution of the recipe. You can add, update or delete labels if you want.

The second section of an LLM evaluation is a row-by-row detail. This aims at helping you understand specific values of metrics, by giving you the context (row values) that precluded the value of each metric. As an example, if you have a particularly low faithfulness score, you can look at the context and the answer and assess it with your own judgement.

If you have defined custom metrics, they will be shown in the LLM evaluation summary along other metrics. If your custom metric returned the array with detailed values, you will also see it in the row-by-row analysis.

## Comparisons

This row-by-row view is very practical to analyze specific cases in a run. However, when building a complex GenAI pipeline, you will probably experiment with different LLM, different prompts, different pre- or post- processing. In such a case, the goal is not to analyze, but to compare runs using potentially very different pipelines.

Comparing runs is using [model comparisons](<../mlops/model-comparisons/index.html>). As a specific addition to the standard model comparison, the LLM Comparison has a section allowing you to perform side-by-side view for each row.

In this screen, you can select a row, and you will see outputs of each run. This allows you, for example, to spot a line where the answer relevancy is vastly different between two runs and analyze it in depth to make an informed decision about which version of your pipeline is best.

---

## [generative-ai/fine-tuning]

# Fine-tuning

Fine-tuning in the LLM Mesh specializes a pre-trained model to perform better on a specific task or domain. It requires annotated data: prompts and their expected completions. Fine-tuning can be resource-intensive, so evaluate your needs carefully.

Before resorting to fine-tuning, the [Prompt Studio](<prompt-studio.html>) can be used to craft well-designed prompts to significantly improve the model’s output without additional techniques.

Another option is to use [RAG](<knowledge/index.html>). RAG combines the LLM with a retrieval model that pulls in external knowledge.

Fine-tuning is really helpful for:

  * domain-specific tasks: to improve the model’s understanding of a particular domain.

  * specialized outputs: when the required output format is more specialized.

  * sensitive data: to ensure compliant and secure outputs for sensitive information.

  * low-resource domains: if data for your use case is limited.




Fine-tuning is supported for OpenAI, Azure OpenAI, AWS Bedrock and Local HuggingFace models.

## Setup

You either need full outgoing Internet connectivity for downloading the models or preload them in the DSS model cache in air-gapped setups.

Your admin must create a [LLM connection](<llm-connections.html>) with fine-tuning enabled.

Azure OpenAI fine-tuning and deployment requires an AzureML connection. AWS Bedrock fine-tuning and deployment requires an S3 connection.

## Using the Fine-tuning recipe

Note

The LLM fine-tuning recipe is available to customers with the _Advanced LLM Mesh_ add-on

### Standard usage

Import a dataset with two required columns : a prompt column (the input of the model) and a completion column (the ideal output). These columns must not contain missing values.

Optionally, the input dataset can include a system message column used to explain the task for a specific row. This column can contain missing values.

Run the recipe to obtain a fine-tuned model, ready for use in your LLM Mesh.

### Advanced usage

The fine-tuning recipe also supports a validation dataset as input.

When present, the loss graph in the model summary will show the evolution of the loss evaluated against the validation dataset during the fine-tuning.

### Deployments

Azure OpenAI and AWS Bedrock require fine-tuned models to be deployed before being used for inference.

Warning

Deployments are billed regardless of usage and can be very costly. Refer to the [Azure OpenAI pricing page](<https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/>) and the [AWS Bedrock pricing page](<https://aws.amazon.com/bedrock/pricing/>) to learn more.

Model deployment lifecycle can be managed by DSS: when a new fine-tuned model version is produced or made active, it can be automatically deployed and any existing deployment deleted.

Deployments can also be managed manually from the dedicated “Model deployment” tab of the saved model version page. Any pre-existing deployment can be attached to a DSS model version.

Once deployed and active, Azure OpenAI and AWS Bedrock fine-tuned models can be used in the LLM Mesh like any other LLM.

### Additional remarks

When fine-tuning a Local Huggingface model, the recipe will use the code environment defined at the connection level. Its container configuration can be set in the recipe settings. It is strongly advised to use a GPU to fine-tune HuggingFace models.

In all cases, the fine-tune recipe will **not** apply the guardrails defined in the connection (See [Guardrails](<guardrails/index.html>))

## Using Python code

To have full control over the fine-tuning process, instead of the visual fine-tuning recipe presented above, you can also [fine-tune a LLM using Python code](<https://developer.dataiku.com/latest/concepts-and-examples/llm-mesh.html#concept-and-examples-llm-mesh-fine-tuning> "\(in Developer Guide\)").

A fine-tuning Python recipe can use one of the built-in fine-tuning code snippets or fully custom code. The only requirement is to produce a model using the safetensors format in a provided directory. The resulting fine-tuned model can be used as any other fine-tuned model within DSS.

---

## [generative-ai/guardrails/bias-detection]

# Bias Detection

Note

This capability is provided by the “Bias Detection Guardrail” plugin, which you need to install. Please see [Installing plugins](<../../plugins/installing.html>).

This plugin is [Not supported](<../../troubleshooting/support-tiers.html>).

This capability is available to customers with the _Advanced LLM Mesh_ add-on.

The Bias Detection guardrail check that questions to a LLM or responses do not exhibit bias or stereotyped statements, notably racial, religious, gender-based, sexuality-based or disability-based.

The Bias Detection guardrail first uses a small specialized model to provide a first level of filtering. This small specialized model however has a significant false positive rate. Optionally, the Bias Detection guardrail can then use an auxiliary LLM to confirm or infirm the initial assumption (“LLM as a judge” approach).

It can be configured to either:

  * block the request (with an error)

  * simply audit the biased conversation

  * ask the guarded LLM to rewrite its answer

---

## [generative-ai/guardrails/custom-guardrails]

# Custom Guardrails

Note

Custom Guardrails are available to customers with the _Advanced LLM Mesh_ add-on

Custom Guardrails can be written in Python, in a plugin.

You must be familiar with plugin development (see [Developing plugins](<../../plugins/reference/index.html>) and [Plugins development](<https://developer.dataiku.com/latest/tutorials/plugins/index.html> "\(in Developer Guide\)")).

You can find a tutorial in the Developer Guide: [Creating a custom guardrail](<https://developer.dataiku.com/latest/tutorials/plugins/guardrail/generality/index.html> "\(in Developer Guide\)").

A sample Custom Guardrail can be found at <https://github.com/dataiku/dss-plugin-sample-guardrail-rewrite-answer/>

Here are some of the capabilities that Custom Guardrails can implement, in addition to the obvious “reject failing requests”

  * Modify requests (before the LLM) and responses (after the LLM)

  * Ask the LLM to retry / rewrite its answer (providing additional instructions)

  * Short-circuit the LLM and directly respond (for example, to politely decline to engage in the topic)

  * Add information to the audit log




Of course, Custom Guardrails can themselves leverage LLMs (and many will usually do). Custom Guardrails are fully integrated in Dataiku’s Unified LLM Tracing and this “sub-call” to a LLM will appear in the “upper trace”.

---

## [generative-ai/guardrails/index]

# Guardrails

The LLM Mesh provides an extensible set of Guardrails designed to ensure that queries submitted to LLMs and responses are safe and correct.

---

## [generative-ai/guardrails/introduction]

# Introduction to guardrails

## Guardrails pipeline

Each time a LLM query or response must be verified, this is handled by a _guardrails pipeline_.

A guardrails pipeline is made of a number of individual steps. Each step can perform checks on either the queries, the responses or both.

Some of the available steps are:

  * [PII detection](<pii-detection.html>)

  * Forbidden terms detection

  * [Prompt injection detection](<prompt-injection-detection.html>)

  * [Toxicity detection](<toxicity-detection.html>)

  * [Topics boundaries checking](<topics-boundaries.html>)

  * [Bias detection](<bias-detection.html>)




In addition to the builtin guardrails, you can write your own, to add your own specific rules. For example, you can write a guardrail to ensure a certain tone of response, to check correctness against custom ontologies, etc…

See [Custom Guardrails](<custom-guardrails.html>) for more details

## Connection-level guardrails

The first place where guardrails are used is at the connection level, where you define which LLMs DSS can connect to. Guardrails are per-connection, which allow you to apply differentiated policies.

For example, you could have a policy where PII can only be processed using locally-running models, but for non-PII data, you can use external providers. You would then define guardrails with PII detection enabled on the external connections, but not on the HuggingFace connection.

## Agent-level guardrails

When you use [DSS agent-building capabilities](<../../agents/index.html>), you are in effect creating a new kind of LLM, that can be leveraged in the various “usage points” of the LLM Mesh (Prompt Studio, Prompt Recipe, Chat UIs, API).

In addition to the processing done by the agent itself, you may wish to add guardrails on that agent, e.g. to make sure that an unplanned case cannot does not lead to unexpected outcomes.

## Usage-time guardrails

In addition to the “enforcement” guardrails defined on the connection, guardrails can also be defined “at time of usage”.

This allows guardrails to be used not only on a generic “per LLM” manner (where you are mostly trying to “protect the LLM and protect against the LLM”), but also on a “per use case”, whereby you can define guardrails for this use case.

For example, if you are using a Prompt Recipe to process a dataset containing customer complaints, in order to write email responses to these customers, it can make sense to add a “Topics Boundaries” guardrail on the Prompt Recipe itself to ensure that none of the generated emails is suggesting giving a discount or refund.

---

## [generative-ai/guardrails/pii-detection]

# PII detection

PII detection in the LLM Mesh can detect various forms of PII in your prompts and queries, and either block or redact the queries.

## Initial setup

You will need a setup with full outgoing Internet connectivity for downloading the models. Air-gapped setups are not supported.

  * In “Administration > Code envs > Internal envs setup”, in the “PII detection code environment” section, select a Python version in the list and click “Create code environment”

  * In “Administration > Settings > LLM Mesh”, in the “PII Detection” section, select “Use internal code env”




## Enable PII detection

Where you want to use the guardrail (either at connection level, agent level or at usage time), select PII Detector and click “Add Guardrail”

You can select whether to:

  * Reject queries where PII is detected

  * Replace PII by a placeholder, such as “John Smith” -> “<PERSON>”

  * Replace PII by a hash value, such as “John Smith” -> “0aa12bc86bd123bd”

  * Remove PII, such as “I said hello to John Smith” -> “I said hello to”

  * Replace parts of PII by stars, such as “His phone number was (570) 123-4567” -> “His phone number was ********567”




## Detected PII types

The following entity types are recognized:

Generic entities:

  * CREDIT_CARD

  * DATE_TIME

  * EMAIL_ADDRESS

  * IBAN_CODE

  * IP_ADDRESS

  * LOCATION

  * PERSON

  * PHONE_NUMBER

  * MEDICAL_LICENSE

  * URL




Country-specific entities:

  * US_BANK_NUMBER

  * US_DRIVER_LICENSE

  * US_ITIN

  * US_PASSPORT

  * US_SSN

  * UK_NHS

  * ES_NIF

  * IT_FISCAL_CODE

  * IT_DRIVER_LICENSE

  * IT_VAT_CODE

  * IT_PASSPORT

  * IT_IDENTITY_CARD

  * SG_NRIC_FIN

  * AU_ABN

  * AU_ACN

  * AU_TFN

  * AU_MEDICARE




## Details

PII Detection is based on Microsoft Presidio library: <https://microsoft.github.io/presidio>

---

## [generative-ai/guardrails/prompt-injection-detection]

# Prompt injection detection

Note

Prompt injection detection is available to customers with the _Advanced LLM Mesh_ add-on

Prompt injection detection is an LLM Mesh guardrail aiming to detect “prompt injections” (attempts to override the intended behavior of an LLM) and to block such attempts.

Prompt injection detection can use either:

>   * a local prompt injection classifier (from a [HuggingFace connection](<../huggingface-models.html>)): the specialized model classifies a prompt as possibly dangerous with a given probability, and you set the acceptability threshold
> 
>   * or any completion LLM, in LLM-as-a-judge mode: the LLM is tasked with classifying the prompt as “safe” or “unsafe”.
> 
> 


LLM-as-a-judge supports multiple detection modes:

>   * General detection: the user prompt is inspected for general attempts at subverting the LLM’s behavior
> 
>   * Detect against the system prompt: the user prompt is inspected for attempts at bypassing the system prompt
> 
>   * Write your own prompt: customize the system prompt that is passed to the LLM-as-a-judge. Its user prompt will be the user prompt from the original completion request.
> 
> 


Once a prompt injection detector is set up and enabled for an LLM connection, queries are screened before being submitted. If an injection attempt is detected, the query is rejected.

---

## [generative-ai/guardrails/topics-boundaries]

# Topics Boundaries

Note

This capability is provided by the “Topics Boundaries Guardrail” plugin, which you need to install. Please see [Installing plugins](<../../plugins/installing.html>).

This plugin is [Not supported](<../../troubleshooting/support-tiers.html>).

This capability is available to customers with the _Advanced LLM Mesh_ add-on.

The Topics Boundaries guardrail check that questions to a LLM or responses, either:

  * Discuss only about one of the allowed topics

  * Do not discuss about one of the forbidden topics




This is particularly useful to ensure that users cannot cause a Chatbot designed to discuss about a certain topic to veer off course.

Topics Boundaries guardrail leverages an auxiliary LLM for assessing whether a query or response respects the rule (“LLM as a judge” approach).

It can be configured to either:

  * block the request (with an error)

  * simply audit the off-track conversation

  * politely decline to respond

---

## [generative-ai/guardrails/toxicity-detection]

# Toxicity detection

Toxicity detection is an LLM Mesh guardrail aiming to detect toxic language in queries & responses, and to block those deemed toxic.

Toxicity detection can use either:

>   * OpenAI’s moderation API
> 
>   * or any local toxicity detection model (from a [HuggingFace connection](<../huggingface-models.html>)): the query or response text is passed to either:
> 
> 

>
>>   * a classification model outputting a probability (from 0 to 1, where 0 means safe)
>> 
>>   * or a generic LLM tasked with classifying it as “safe” or “toxic”
>> 
>> 


Note

Local toxicity detection is available to customers with the _Advanced LLM Mesh_ add-on

Once a toxicity detector is set up and enabled, queries are screened before being submitted and responses are screened before saving or displaying the LLM response.

If toxicity is detected, the request is rejected.

---

## [generative-ai/huggingface-models/model-cache]

# The model cache

DSS has its own (optional) managed cache to store models from Hugging Face.

If enabled at the connection level, the cache is automatically populated when using the [LLM Mesh](<../huggingface-models.html>) with pre-trained models from Hugging Face. Models are downloaded from [Hugging Face Hub](<https://huggingface.co/models>).

This cache is especially useful for air-gapped instances, where models need to be imported into DSS before they can be used through a Local Hugging Face connection.

## Import and export models

In DSS, the model cache can be managed from **Administration > Settings > Misc > Model cache**.

From this page, you can:

  * Monitor the disk usage of the model cache

  * View the cached models

  * Delete models

  * Export models

  * Import models




If your DSS instance does not have access to Hugging Face (huggingface.co), you can manually import a model archive, typically one exported from the model cache of another DSS design or automation node with network access.

## Build your own model archive to import

Note

It is simpler (and recommended) to import a model that was previously exported by DSS when that is possible, instead of creating an archive manually.

If you want to manually create an archive it should contain the following structure:

  * a root folder

  * a folder named `model` containing the Hugging Face model repo content

  * a file named `model_metadata.json`




To retrieve the `model` folder content from Hugging Face Hub:
    
    
    git lfs install
    git clone https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2
    

Example of a model archive content:
    
    
    sentence-transformers_2fall-MiniLM-L6-v2 ← folder at the root (its name is not important)
    ├── model ← a folder named ``model`` containing the Hugging Face model repo content
    │   ├── 1_Pooling
    │   │   └── config.json
    │   ├── README.md
    │   ├── config.json
    │   ├── config_sentence_transformers.json
    │   ├── data_config.json
    │   ├── modules.json
    │   ├── pytorch_model.bin
    │   ├── sentence_bert_config.json
    │   ├── special_tokens_map.json
    │   ├── tokenizer.json
    │   ├── tokenizer_config.json
    │   ├── train_script.py
    │   └── vocab.txt
    └── model_metadata.json ← a file named ``model_metadata.json``
    

The model_metadata.json file should have the following schema:
    
    
    {
        "commitHash": "7dbbc90392e2f80f3d3c277d6e90027e55de9125",
        "downloadDate": 1698300636139,
        "downloadedBy": "admin",
        "lastDssUsage": 1699570884724,
        "lastModified": "2022-11-07T08:44:33.000Z",
        "lastUsedBy": "admin",
        "libraryName": "sentence-transformers",
        "modelDefinition": {
            "key": "hf@sentence-transformers/all-MiniLM-L6-v2"
        },
        "pipelineName": "sentence-similarity",
        "sizeInBytes": 91652688,
        "taggedLanguages": [
            "en"
        ],
        "tags": [
            "sentence-transformers",
            "pytorch",
            "tf",
            "rust",
            "bert",
            "feature-extraction",
            "sentence-similarity",
            "en",
            "dataset:s2orc",
            "dataset:flax-sentence-embeddings/stackexchange_xml",
            ...
            "arxiv:2104.08727",
            "arxiv:1704.05179",
            "arxiv:1810.09305",
            "license:apache-2.0",
            "endpoints_compatible",
            "has_space",
            "region:us"
        ],
        "url": "https://huggingface.co/sentence-transformers%2Fall-MiniLM-L6-v2/tree/main",
        "version": 0
    }
    

Most of these fields can be retrieved from the Hugging Face model repository.

The important ones are:

  * modelDefinition:
    
    * key: consists of `hf@<modelId>` or `hf@<modelId>@<revision>` if a specific revision was used

  * version: as of now should be 0

  * url: the url used to fetch the model




## Access cache programmatically

You can access models in the DSS-managed model cache programmatically using the following code:
    
    
    from dataiku.core.model_provider import get_model_from_cache
    model_path_in_cache = get_model_from_cache(model_name)
    

The Python code shown above will work both in a local execution and in a containerized execution. It expects the model to be in the cache, it will not trigger its download to the cache.

To download a model from Hugging Face to the DSS-managed model cache programmatically, you can use the following code:
    
    
    from dataiku.core.model_provider import download_model_to_cache
    download_model_to_cache(model_name)
    

If the model is not already in the cache, this code downloads the model from Hugging Face and stores it in the DSS-managed model cache. If the user running this code is not an administrator, the specified model must be enabled in a Hugging Face connection.

If the model requires a Hugging Face access token, you can provide a connection with a configured access token to use as an optional second argument:
    
    
    from dataiku.core.model_provider import download_model_to_cache
    download_model_to_cache(model_name, connection_name=your_connection)

---

## [generative-ai/huggingface-models/other-model-types]

# Other model types

Besides text generation, text embedding, and text reranking, local Hugging Face connections can also serve other model types.

## Image generation

The image generation capabilities are only available through the Dataiku DSS API. See the [Developer Guide](<https://developer.dataiku.com/latest/tutorials/genai/multimodal/images-and-text/images-generation/index.html> "\(in Developer Guide\)") for tutorials using this feature.

Image-to-image mode is not available using local Hugging Face models.

## Image embedding

Image embedding models are supported with local Hugging Face connections.

Image embedding can be used in [Visual ML](<../../machine-learning/features-handling/images.html>) and through the DSS API.

## Other task-specific models

Other specialized local Hugging Face models can also be used in DSS.

Examples include local classifiers used by Guardrails, such as prompt injection detection and toxicity detection models. See [Prompt injection detection](<../guardrails/prompt-injection-detection.html>) and [Toxicity detection](<../guardrails/toxicity-detection.html>).

---

## [generative-ai/huggingface-models/setup]

# Setup & prerequisites

Local Hugging Face models can run either on a Kubernetes cluster with NVIDIA GPUs, or on the DSS server itself if it has NVIDIA GPUs. The Kubernetes setup is the recommended one.

## Common requirements

In order to run local Hugging Face models, you will need:

  * GPUs [compute capability level](<https://developer.nvidia.com/cuda-gpus>) >= 7.5

  * NVIDIA driver version [compatible](<https://docs.nvidia.com/deploy/cuda-compatibility>) with CUDA 12.8

  * Python 3.11




Some models are gated on Hugging Face Hub. Accessing them requires a Hugging Face access token, and gated models may require requesting access on the model repository page first.

Note

The base images and Python 3.11 requirements are automatically fulfilled when using Dataiku Cloud Stacks, so you do not need additional setup for container images, as long as you have not customized base images. See [Elastic AI computation setup](<../../containers/setup-k8s.html>).

If you require assistance with the cluster setup, please reach out to your Dataiku Technical Account Manager or Customer Success Manager

Note

For air-gapped instances, you will need to import Hugging Face models manually into DSS’s model cache and enable DSS’s model cache in the Hugging Face connection. See [The model cache](<model-cache.html>) section.

## Kubernetes setup

This setup is the recommended approach for running Hugging Face models locally in DSS.

### Prerequisites

You need:

  * A fully set up Elastic AI computation capability

  * A running Elastic AI Kubernetes cluster with NVIDIA GPUs

    * Smaller models, such as Qwen3 4B or GPT-OSS 20B, work with one `A10` GPU with 24 GB of VRAM

    * Larger models require multi-GPU nodes. For example, some models such as Llama 3.3 70B or Kimi Linear 48B A3B can run on `2 x A100` GPUs with 80 GB of VRAM each, depending on quantization and context length

    * Large image generation models such as FLUX.1-schnell require GPUs with at least 40 GB of VRAM. Local image generation models do not benefit from multi-GPU setups or quantization




### Create a containerized execution configuration

  * In **Administration > Settings > Compute & Scaling > Containerized Execution**, create a new Kubernetes containerized execution config

  * In **Custom limits** , add `nvidia.com/gpu` with value `1`

  * If you are using multi-GPU nodes, set a higher value. It is recommended to use `1`, `2`, `4`, or `8` in order to maximize compatibility with vLLM tensor parallelism constraints

  * Enable **Increase shared memory size** , without setting a specific value




Do not set memory or CPU requests or limits.

### Create the code environment and a Local Hugging Face connection

  * In **Administration > Code envs > Internal envs setup**, in the **Local Hugging Face models code environment** section, select a Python interpreter and click **Create code environment**

  * Once the code environment is created, go to its settings. In **Containerized execution** , set **Build for** to **All container configurations** , or select the relevant GPU-enabled container configurations

  * Click **Save and update** (this will take at least 10-20 minutes)

  * Create a **Local Hugging Face** connection

  * Enter the connection name

  * In **Container execution** , choose **Select a container configuration** , then choose the containerized execution config name

  * In **Code environment** , select **Use internal code env**

  * In the relevant model section of the connection, click **Add model from preset** to import a preset from the catalog

  * Click **Save**




Note

Different models can have different hardware requirements, including GPU count and GPU type. After the model is created, it is recommended to configure **Container execution** in the model’s **Deployment settings** tab rather than relying only on the connection-level default.

### Deployment settings

In the model’s **Deployment settings** tab, DSS can automatically scale the number of model instances up and down depending on the load. **Max. model instances** limits how many instances can run at the same time. **Target requests per model instance** defines the target average load per running instance and is used by DSS to decide when to add or remove instances. **Autoscaling time window** controls how quickly DSS reacts to load changes.

By default, models scale from zero, which adds latency on the first request while the model instance starts. To avoid this, configure **Min. model instances** so that the model remains always running. This setting only applies if **Reserved capacity** is enabled on the Local Hugging Face connection.

## Local DSS server setup

Running local Hugging Face models directly on the DSS server is supported when the DSS server has NVIDIA GPUs, but this is not the recommended setup.

### Create the code environment and a Local Hugging Face connection

  * In **Administration > Code envs > Internal envs setup**, in the **Local Hugging Face models code environment** section, select a Python interpreter and click **Create code environment**

  * Once the code environment is created, click **Save and update**

  * Create a **Local Hugging Face** connection

  * Enter the connection name

  * In **Container execution** , select **None - Use backend to execute**

  * In **Code environment** , select **Use internal code env**

  * In the relevant model section of the connection, click **Add model from preset** to import a preset from the catalog

  * Click **Save**




### Deployment settings

In local DSS server mode, GPU allocation is not automatic. Running multiple models on the same GPU will likely fail with out-of-memory errors.

By default, a model uses all visible GPUs. If the DSS server has several GPUs and you want to run several models, use **Cuda visible devices** to pin each model to a specific GPU.

Set **Max. model instances** to `1`. Otherwise, multiple instances are likely to run on the same GPU and fail with out-of-memory errors.

As in Kubernetes mode, models scale from zero by default. To keep a model always running, configure **Min. model instances**. This setting only applies if **Reserved capacity** is enabled on the Local Hugging Face connection.

---

## [generative-ai/huggingface-models/text-embedding]

# Text embedding

Text embedding models are supported with local Hugging Face connections.

In the **Text Embedding** section of the connection, click **Add model from preset** to import a preset from the catalog. If the model is not in the catalog, or if you want to configure a compatible Hugging Face model manually, click **Add a custom model**. Once the model is configured, click **Save**.

For compatible models and runtime environments, DSS uses [vLLM](<https://docs.vllm.ai/>) to serve text embedding models. If vLLM cannot be used, DSS falls back to [transformers](<https://huggingface.co/transformers/>). Compatibility depends on the model architecture, model packaging, quantization format, and runtime environment. For example, [Qwen/Qwen3-Embedding-4B](<https://huggingface.co/Qwen/Qwen3-Embedding-4B>) can be used as a local text embedding model.

See [Setup & prerequisites](<setup.html>) and [Text generation](<text-generation.html>) for the shared setup and compatibility considerations.

---

## [generative-ai/huggingface-models/text-generation]

# Text generation

Local Hugging Face connections support text generation models. DSS provides presets for popular models, and you can also configure custom models by specifying their Hugging Face ID.

## Preset catalog

[](<../../_images/hf-model-catalog.png>)

DSS provides presets for some common models and common hardware sizes (24GB and 48GB GPUs). This catalog is not exhaustive, and compatible Hugging Face models can always be configured manually.

Presets include default settings chosen to fit the target hardware. This can include a reduced context length on smaller GPUs. These settings are only defaults and can be adjusted after the model is created.

Some presets are tagged with capability labels such as **Reasoning** , **Image** , and **Tool**. These labels indicate capabilities supported out of the box with the preset configuration. If a label is absent, it means that the capability has not been tested with that preset, but it may work with additional configuration.

In the **Text Generation** section of the connection, click **Add model from preset** to import a preset from the catalog. If the model is not in the catalog, or if you want to configure a compatible Hugging Face model manually, click **Add a custom model**.

Once the model is configured, click **Save**.

## Compatibility

DSS leverages [vLLM](<https://docs.vllm.ai/>), a high-performance inference engine optimized for running large-scale language models on NVIDIA GPUs.

Before adding a custom model, ensure that the model meets the following requirements:

  * The model needs to use the standard Hugging Face configuration format

For example, [mistralai/Pixtral-12B-2409](<https://huggingface.co/mistralai/Pixtral-12B-2409>) uses a Mistral-specific configuration format and is not supported. A repackaged version such as [mistral-community/pixtral-12b](<https://huggingface.co/mistral-community/pixtral-12b>) is compatible.

  * The model architecture must be supported by the installed vLLM version

The model architecture can be determined from the `config.json` file in the model repository. Refer to [the list of supported architectures for vLLM](<https://docs.vllm.ai/en/stable/models/supported_models.html>).

The vLLM version installed with DSS depends on the DSS version. To determine which vLLM version is available:

    * Check **Administration > Code envs > Internal envs setup > Local Hugging Face models code environment > Currently installed packages**

    * See the [DSS release notes](<../../release_notes/index.html>) for the vLLM version included in each DSS release

  * The model must be an instruct, chat, or reasoning model

For example, [mistralai/Mistral-Small-24B-Base-2501](<https://huggingface.co/mistralai/Mistral-Small-24B-Base-2501>) is a base model and cannot be used in DSS, whereas [mistralai/Mistral-Small-24B-Instruct-2501](<https://huggingface.co/mistralai/Mistral-Small-24B-Instruct-2501>) is compatible.

  * The model weights must be packaged using Safetensors format (`*.safetensors`) or PyTorch bin format (`*.bin`)

  * Supported quantized model formats are AWQ, GPTQ, FP8, NVFP4, and BitsAndBytes. GGUF is not supported




Note

For text generation, the LLM Mesh automatically selects and configures the inference engine. It uses [vLLM](<https://docs.vllm.ai/>) by default if the model and runtime environment are compatible. If not compatible, it falls back to [transformers](<https://huggingface.co/transformers/>) as a best effort. Serving models with transformers leads to degraded performance and loss of capabilities. This legacy mode is deprecated and may be removed in future DSS versions. A warning is displayed in the Hugging Face connection UI when this fallback is used.

You can manually override this default behavior in the Hugging Face connection settings (Advanced tuning > Custom properties). To do so, add a new property `engine.completion` and set its value to `TRANSFORMERS`, `VLLM` or `AUTO` (default, recommended unless you experience issues with the automatic engine selection).

## Memory requirements

Serving a text generation model requires GPU memory for:

  * Model weights

  * KV cache

  * Runtime overhead




Memory usage depends on the number of parameters, precision, context length, and model architecture. In the preset catalog, the model weights size is displayed as **Storage size**. For example, an unquantized 24B model at BF16 precision requires about 48GB of VRAM for the weights alone, while an FP8 quantized version requires about 24GB.

Reducing the configured context length lowers KV cache usage. This is one of the adjustments made by some presets for smaller GPUs.

To reduce memory requirements:

  * Use a pre-quantized model in a supported format

  * Set **Model quantization mode** to **None** when using a pre-quantized model

  * Reduce the **Max tokens** setting when memory is constrained




Note

Using pre-quantized models is the recommended approach. In-flight quantization is discouraged because it downloads more data than needed and can be slower than serving a pre-quantized model. In addition, 8-bit in-flight quantization currently disables vLLM.

## Using a model

To test a local text generation model, create a prompt in [Prompt Studio](<../prompt-studio.html>) and select the model from the LLM list.

On the first run, the model must be downloaded and the serving instance must start. This can take several minutes.

---

## [generative-ai/huggingface-models/text-reranking]

# Text reranking

Text reranking models are supported with local Hugging Face connections.

In the **Text Reranking** section of the connection, click **Add model from preset** to import a preset from the catalog. If the model is not in the catalog, or if you want to configure a compatible Hugging Face model manually, click **Add a custom model**. Once the model is configured, click **Save**.

For compatible models and runtime environments, DSS uses [vLLM](<https://docs.vllm.ai/>) to serve text reranking models. If vLLM cannot be used, DSS falls back to [transformers](<https://huggingface.co/transformers/>). Compatibility depends on the model architecture, model packaging, quantization format, and runtime environment. For example, [Qwen/Qwen3-Reranker-4B](<https://huggingface.co/Qwen/Qwen3-Reranker-4B>) can be used as a local text reranking model.

See [Setup & prerequisites](<setup.html>) and [Text generation](<text-generation.html>) for the shared setup and compatibility considerations.

---

## [generative-ai/huggingface-models]

# Running Hugging Face models

The LLM Mesh supports locally-running Hugging Face models for several tasks:

  * Text generation

  * Text embedding

  * Text reranking

  * Image generation

  * Image embedding

  * Other task-specific models




DSS provides presets for some common Hugging Face models for easier setup. Compatible Hugging Face models can also always be configured manually.

Caution

Running local large-scale Hugging Face models is a complex and costly setup, and both quality and performance often remain below proprietary LLM APIs. For first experiments with LLMs, Dataiku recommends [hosted LLM APIs](<llm-connections.html>).

---

## [generative-ai/index]

# Generative AI and LLM Mesh

---

## [generative-ai/introduction]

# Introduction

With the recent advances in Generative AI and particularly large language models, new kind of applications are ready to be built, leveraging their power to structure natural language, generate new content, and provide powerful question answering capabilities.

However, there is a lack of oversight, governance, and centralization, which hinders deployment of LLM-based applications.

The LLM Mesh is the common backbone for Enterprise Generative AI Applications.

## Dataiku Generative AI Capabilities

### The unified secure LLM Gateway

The LLM Mesh provides

  * Connectivity to a large number of Large Language Models, both as APIs or locally hosted

  * Full permissioning of access to these LLMs, through new kinds of connections

  * Full support for locally-hosted HuggingFace models running on GPU

  * Audit and tracing for all queries

  * Cost monitoring and blocking to manage your Generative AI budget

  * Advanced Guardrails to secure your usage of Generative AI, including PII detection, Toxicity Detection, and much more

  * Governance of Generative AI Use cases

  * Caching




### Knowledge management

The LLM Mesh also provides a unified interface to Knowledge Banks and Vector Stores to build Retrieval Augmented Generation (RAG) use cases.

The embedding recipes let you build Knowledge Banks from datasets or documents (such as PDF, DOC, PPT, …) easily. These Knowledge Banks can then be queried in a secure fashion to provide contextual answers.

For more details, see [Adding Knowledge to LLMs](<knowledge/index.html>).

### Prompt Engineering and Execution

On top of the LLM Mesh, Dataiku includes a full-featured development environment for Prompt Engineering, the _Prompt Studio_. In the Prompt Studio, you can test and iterate on your prompts, compare prompts, compare various LLMs (either APIs or locally hosted), and, when satisfied, deploy your prompts as Prompt Recipes for large-scale batch generation.

For more details, see [The Prompt Studio](<prompt-studio.html>).

### Chatbot UI

Dataiku includes two fully-featured Chatbot user interfaces, allowing you to expose rich chatbots to your users. They handle security, tracing, user preferences, history, and are customizable.

  * Answers is a full-featured Chat interface for creating chat bots based on your internal knowledge and data

  * Agent Connect is a more advanced multi-agent Chat interface for unified user access to multiple Generative AI use cases




For more details, see [Chat UI](<chat-ui/index.html>)

### Agent builder

Dataiku contains a complete environment for building advanced agents, either visually or through code

Dataiku provides a complete system for managing Tools, one of the foundational building blocks of Agents.

Pervasive tracing, together with a visual traces explorer, simplify the development of advanced Generative AI applications.

For more details, see [AI Agents](<../agents/index.html>)

### Fine Tuning

Some specific use cases require adapting generic LLM models to your particular use case. Dataiku provides facilities for fine tuning LLMs, both visually or via code.

For more details, see [Fine-tuning](<fine-tuning.html>).

### Evaluation

Evaluating the quality of the outputs of a LLM on a given use case is not a trivial task. Dataiku provides helpers and building blocks for this.

For more details, see [Evaluating LLMs & GenAI use cases](<evaluation.html>)

## Using the LLM Mesh

In addition to the mentioned capabilities (Prompt Studio, Prompt Recipe, Answers, Agent Connect), the LLM Mesh is fully available via [LLM Mesh API](<api.html>).

In addition, Dataiku includes two recipes that make it very easy to perform two common LLM-powered tasks:

  * [Classifying text](<https://knowledge.dataiku.com/latest/genai/text-processing/concept-classification.html>) (either using classes that have been trained into the model, or classes that are provided by the user)

  * [Summarizing text](<https://knowledge.dataiku.com/latest/genai/text-processing/concept-summarization.html>)

---

## [generative-ai/knowledge/automated-rag-optimization]

# Automated RAG Optimization

## Overview

Automated RAG optimization in Dataiku optimizes Retrieval-Augmented Generation (RAG) configurations using Bayesian optimization techniques built on [Optuna](<https://optuna.org/>). It searches for high-performing parameter combinations to maximize answer quality while minimizing execution costs.

This optimization capability targets two main components:

  1. **Embedding optimization** : Optimizes document embedding recipe parameters.

  2. **RA-LLM optimization** : Optimizes Retrieval-Augmented LLM parameters for search and generation.




This capability is provided by the **RAG Optimization** plugin. For plugin installation instructions, see [Installing plugins](<../../plugins/installing.html>).

## How It Works

### Key Concepts

  * **Trial** : A single test run with one specific parameter combination.

  * **Study** : The complete optimization process containing all trials.

  * **Objective function** : The function that evaluates a configuration and returns a score.

  * **Score** : A composite metric combining correctness and cost efficiency.

  * **Combination** : A specific set of parameter values being tested.




### What Is Optuna?

Optuna is a hyperparameter optimization framework that uses Bayesian optimization to efficiently search for high-performing parameter combinations. Instead of testing every possible combination, Optuna:

  1. Learns from previous trials by analyzing which parameters led to better results.

  2. Suggests promising configurations using model-based sampling.

  3. Focuses on promising regions of the search space over time.




Optuna is useful here because it is efficient, adaptive, and designed for smart parameter sampling.

### Workflow Overview

The workflow automates optimization through the following high-level steps:
    
    
    1. Optimization parameters configuration
       ↓
    2. Embedding optimization
       ├── Create embedding recipes with different configurations
       ├── Evaluate each configuration
       └── Select best configuration
       ↓
    3. Build optimized Knowledge Bank
       ↓
    4. RA-LLM optimization
       ├── Create RA-LLMs with different configurations
       ├── Evaluate each configuration
       └── Select best configuration
       ↓
    5. Return results and metrics
    

  1. **Parameter space definition**

You define which parameters to optimize and their candidate values. Typical examples include embedding chunk size or RAG search type.

  2. **Trial execution**

For each trial:

     * Optuna suggests a parameter combination based on previous results.

     * The workflow creates a temporary embedding recipe or RA-LLM using those parameters.

     * Temporary objects are created in a dedicated Flow zone to keep the main Flow clean.

     * The system evaluates the configuration by building a Knowledge Bank, running evaluation queries, comparing generated answers to expected outputs, and estimating costs.

     * The workflow computes a score from correctness and cost.

  3. **Learning and iteration**

     * Optuna records trial results.

     * It updates its search strategy.

     * It proposes more promising combinations for the next trial.

     * This process repeats for `n_trials` iterations.

  4. **Best configuration selection**

After all trials, the workflow keeps the highest-scoring configuration and creates or updates the final optimized recipe and RA-LLM.




## Metrics and Scoring

### Composite Score

The score combines correctness and cost efficiency:
    
    
    if correctness < hard_min_correctness:
        score = -1.0  # Rejected
    else:
        cost_score = 1.0 / (1.0 + np.log1p(cost * 1e6))
        score = 2 * correctness * cost_score / (correctness + cost_score + 1e-9)
    

Interpretation:

  * High score means high correctness and low cost.

  * `-1.0` means correctness is below the minimum threshold.




## Usage and Configuration

### Using It in a Flow

This capability is used as a recipe in your Flow.

  1. Add the recipe to your Flow and connect the required inputs (Input Folder and Evaluation Dataset).

  2. Configure recipe settings:

     * Select evaluation dataset columns (user query and ground truth).

     * Choose embedding and completion models.

     * Review or customize optimization parameters.

     * Set execution parameters such as number of trials and parallelism.

  3. Run the recipe to start optimization.

During execution, temporary recipes, Knowledge Banks, and RA-LLMs may appear in the Flow for each trial. These temporary objects are cleaned up automatically at the end of the process.

  4. Review outputs.

The recipe produces detailed optimization datasets, including per-trial results and question-answer level evaluation details. It also creates an optimized embedding recipe, its associated Knowledge Bank, and an optimized RA-LLM.




### Requirements

  * The input folder contains supported document formats.

  * The evaluation dataset contains at least query and ground-truth columns.

  * Valid LLM connections are configured for both embedding and completion models.

  * A dedicated work zone is configured (or defaulted) for temporary optimization objects.




## Best Practices

  1. Use a representative but reasonably small evaluation dataset for faster iterations.

  2. Start with a low number of trials (for example `n_trials=5` to `10`), then increase progressively.

  3. Use `n_jobs=1` by default to reduce resource conflicts.

  4. Limit the number of optimized parameters to keep the search space manageable.

  5. Prefer discrete candidate value lists instead of continuous ranges.

  6. Keep default parameters unless you have a specific reason to change them.




## Limitations

  * Optimization runs sequentially (embedding first, then RA-LLM).

  * Automatic cleanup may fail if execution is interrupted abruptly.

  * Correctness is evaluated through an LLM judge, which can introduce variability.

---

## [generative-ai/knowledge/document-level-security]

# Document-Level Security

Document-Level Security enables granular access control over documents within a knowledge bank. It ensures that when a user performs a search or query, the results only include documents that user is authorized to view.

This feature matches permissions attached to individual documents with permissions granted to individual users.

## Security Tokens

The mechanism for document-level security relies on **security tokens**.

  * **Definition** : Security tokens are arrays of strings used to tag both documents and users.

  * **On Documents** : A document’s security tokens represent the permissions required to access it. A common implementation is to use the names of user groups that are allowed to view the document (e.g., `["legal-department", "executives"]`).

  * **On Users** : A user’s security tokens represent the permissions they possess. This is typically the list of groups they belong to.




Access is granted if a user’s list of security tokens and a document’s list of security tokens have at least one token in common (i.e. the intersection of the two lists is non-empty). You can see an example in the implementation section below.

## Implementation

The Embed Document recipe, Embed Dataset recipe, Knowledge Bank Search tool, and LLM Mesh caller (for example, your own application or Dataiku [Chat UIs](<../chat-ui/index.html>)) can work together to provide document-level security.

For a step-by-step guide, see [this tutorial](<https://knowledge.dataiku.com/latest/genai/rag/tutorial-manage-rag-access.html>) on the knowledge base.

Enabling document-level security typically involves three stages:

  1. **Tag Documents/Dataset with Security Tokens** : Before your documents/dataset are embedded, you must add a metadata table for your documents or a dedicated column to your dataset. This must contain the **security tokens** for each document, which define its access permissions. These tokens are typically formatted as a JSON array of strings (e.g., `["administrators", "legal_dept"]`).

  2. **Configure Indexing** : Next, you must configure the embedding process to recognize the security tokens. This is done within the settings of either the [Embed Dataset](<first-rag.html>) or the [Embed Documents](<documents.html>) recipes. In the recipe, you specify which column contains the security tokens, ensuring they are indexed alongside the document content in the knowledge bank.

  3. **Filter During Retrieval** : Finally, when a user makes a query, their security tokens must be passed along with it. This is handled by the calling application, such as the [Knowledge Bank Search tool](<../../agents/tools/knowledge-bank-search.html>), inside a [RAG Model](<first-rag.html>) or a custom RAG application using the LLM Mesh. Dataiku filters results by comparing the user’s tokens against the indexed tokens of each document. A document is only returned if there is at least one match. If no security tokens are provided with the query, the search will return no results, preventing unauthorized data access.




[Agent Hub](<../../agents/agent-hub.html>) and [Agent Connect](<../chat-ui/agent-connect.html>) pass user information via the completion context in the following format, here the `administrators` group matches the document’s security token we set earlier:
    
    
    {
      "context": {
        "callerSecurityTokens": [
          "administrators",               // list of user groups
          "dss_group:administrators",     // group names prefixed with "dss_group:"
          "dss_user_login:admin",         // user login
          "dss_user_emailaddress:admin@localhost" // user email address
        ]
      }
    }
    

Important

You must make sure to pass tokens of the _final_ end-user, not the technical user simply calling the agent or tool.

---

## [generative-ai/knowledge/documents]

# Embedding and searching documents

In addition to the traditional embedding of text and storage in Vector Stores, Dataiku can also work directly with unstructured documents.

The “Embed documents” recipe takes a managed folder of documents as input and outputs a Knowledge Bank that can directly be used to query the content of these documents.

To get started with document embedding, see our [Tutorial | Build a RAG system and turn it into a conversational agent](<https://knowledge.dataiku.com/latest/genai/rag/tutorial-rag-conversational-agent.html>).

## Supported document types

The “Embed documents” recipe supports the following file types:

  * PDF

  * PPTX/PPT

  * DOCX/DOC

  * ODT/ODP

  * TXT

  * MD (Markdown)

  * PNG

  * JPG/JPEG

  * HTML




## Text extraction vs. VLM extraction

The “Embed documents” recipe supports two ways of handling documents.

### Text extraction

Text extraction extracts text from documents and organizes it into meaningful units. It supports PDF, DOCX, PPTX, HTML, TXT, and MD. Image formats (PNG, JPEG, JPG) are supported if Optical Characters Recognition (OCR) is enabled.

Two engines are available for text extraction and can be configured using custom rules.

#### Raw text extraction

This engine focuses on the physical layout of the document. It extracts text in a single chunk for DOCX, or separately per slide/page for PPTX and PDF files.

If OCR is enabled, PDF files are first converted into images. The engine then extracts text from those images (useful for scanned documents).

Because this engine does not try to infer the semantic structure of the document, it is very fast.

#### Structured text extraction

Structured text extraction runs as follows:

  * The text content is extracted from the document.

  * If headers are available, they are used to divide the content into meaningful units.

  * The extracted text is split into chunks if necessary to fit the embedding model.




Text can also be extracted from images detected in the documents:

  * with the ‘Optical Character Recognition’ (OCR) image handling mode. You can either choose EasyOCR or Tesseract as OCR engines. EasyOCR does not require any configuration but is slow when running on CPU. Tesseract requires some configuration, see OCR setup below. Enabling OCR is recommended on scanned documents.

  * with the ‘VLM description’ image handling mode. A visual LLM is used to generate descriptions for each image in the document. Available for PDF, DOCX and PPTX files.




By default, the recipe uses a lightweight classification model to identify and filter out non-informative images (such as barcodes, signatures, icon, logos, or QR codes) from text processing. While these images are skipped during extraction, all images are still saved to the output folder. To process all images regardless of content, disable Skip non-informative images in the recipe’s rules advanced settings.

Note

Structured text extraction requires internet access for PDF document extraction. The models that need to be downloaded are layout models available from Hugging Face. The runtime environment will need to have access to the internet at least initially so that those models can be downloaded and placed in the huggingface cache.

If your instance does not have internet access then you can download those models manually. Here are the steps to follow:

14.3.0 and later
    

  * Go to the [model repository](<https://huggingface.co/ds4sd/docling-models/tree/v2.3.0>) and clone the repository (on the v2.3.0 revision)

  * Create a “ds4sd--docling-models” repository in the resources folder of the document extraction code environment (or the code env you chose for the recipe), under: /code_env_resources_folder/document_extraction_models/ds4sd--docling-models

>     * The folder “ds4sd--docling-models”, should contain the same files as <https://huggingface.co/ds4sd/docling-models/tree/v2.3.0/>

  * Create a “ds4sd--docling-layout-egret-medium” repository in the resources folder of the document extraction code environment (or the code env you chose for the recipe), under: /code_env_resources_folder/document_extraction_models/ds4sd--docling-layout-egret-medium

>     * The folder “ds4sd--docling-layout-egret-medium”, should contain the same files as <https://huggingface.co/docling-project/docling-layout-egret-medium/tree/main/>

  * (Optional) You can also choose to download “docling-layout-heron” model in addition to / instead of “docling-layout-egret-medium” if you need more accuracy in layout detection and sacrifice speed.

>     * Create a “ds4sd--docling-layout-heron” repository in the resources folder of the document extraction code environment (or the code env you chose for the recipe), under: /code_env_resources_folder/document_extraction_models/ds4sd--docling-layout-heron
> 
>     * The folder “ds4sd--docling-layout-heron”, should contain the same files as <https://huggingface.co/docling-project/docling-layout-heron/tree/main/>



Prior to 14.3.0
    

  * Go to the [model repository](<https://huggingface.co/ds4sd/docling-models/tree/v2.2.0>) and clone the repository (on the v2.2.0 revision)

  * Create a “ds4sd--docling-models” repository in the resources folder of the document extraction code environment (or the code env you chose for the recipe), under: /code_env_resources_folder/document_extraction_models/ds4sd--docling-models

>     * The folder “ds4sd--docling-models”, should contain the same tree structure as <https://huggingface.co/ds4sd/docling-models/tree/v2.2.0/>




If the models are not in this resources folder, then the huggingface cache will be checked and if the cache is empty, the models will be downloaded and placed in the huggingface cache.

Note

You can edit the run configuration of the text extraction engine in the **Administration** > **Settings** > **Other** > **LLM Mesh** > **Configuration** > **Document extraction recipes**.

### VLM extraction

For complex documents, Dataiku implements another strategy based on Vision LLMs (VLM), i.e. LLMs that can take images as input. If your LLM Mesh is connected to one of these (see [Multimodal capabilities](<../multimodal.html>) for a list), you can instead use the VLM strategy.

  * Instead of extracting the text, the recipe transforms each page of the document into images.

  * Ranges of images are sent to the VLM, asking for a summary.

  * The summary of each range of images is embedded.




At query time, when asking a text question:

  * Using the embedding of the question, the relevant ranges are retrieved

  * The matching images are directly passed in the context of the VLM

  * The VLM then directly uses the images to answer




The advanced image understanding capabilities of the VLM allow for much more relevant answers than just using extracted text.

The “Embed Documents” recipe supports VLM strategy for DOCX/DOC, PPTX/PPT, PDF, ODT/ODP, JPG/JPEG and PNG files.

When creating the “Embed Documents” recipe, in addition to the knowledge bank, a managed folder with the images extracted from your documents is created as output of the recipe.

## Initial document extraction setup

  * Document Extraction is automatically preinstalled when using Dataiku Cloud Stacks or Dataiku Cloud. If you are using Dataiku Custom, before using the VLM extraction, you need a server administrator with elevated (sudoers) privileges to run:



    
    
    sudo -i "/home/dataiku/dataiku-dss-VERSION/scripts/install/install-deps.sh" -with-libreoffice
    

  * Text extraction on “Embed documents” and “Extract full document” recipes on DOCX/PDF/PPTX (with both engines) requires to install and enable a dedicated code environment (see [Code environments](<../../code-envs/index.html>)):

In **Administration** > **Code envs** > **Internal envs setup** , in the Document extraction code environment section, select a Python version from the list and click Create code environment.




## OCR setup

When using the OCR mode of the text extraction, you can choose between EasyOCR and Tesseract. The AUTO mode will first use Tesseract if installed, else will use EasyOCR.

### Tesseract

Tesseract is preinstalled on Dataiku Cloud and Dataiku Cloud Stacks. If you are using Dataiku Custom, Tesseract needs to be installed on the system. Dataiku uses the tesserocr python package as a wrapper around the tesseract-ocr API. It requires libtesseract (>=3.04 and libleptonica (>=1.71).

The English language and the OSD files must be installed. Additional languages can be downloaded and added to the tessdata repository. Here is the [list](<https://tesseract-ocr.github.io/tessdoc/Data-Files-in-different-versions.html>) of supported languages.

For example on Ubuntu/Debian:
    
    
    sudo apt-get install tesseract-ocr tesseract-ocr-eng libtesseract-dev libleptonica-dev pkg-config
    

On AlmaLinux:
    
    
    sudo dnf install tesseract
    curl -L -o /usr/share/tesseract/tessdata/osd.traineddata https://github.com/tesseract-ocr/tessdata/raw/4.1.0/osd.traineddata
    chmod 0644 /usr/share/tesseract/tessdata/osd.traineddata
    

At runtime, Tesseract relies on the TESSDATA_PREFIX environment variable to locate the tessdata folder. This folder should contain the language files and config. You can either:

  * Set the TESSDATA_PREFIX environment variable (must end with a slash /). It should point to the tessdata folder of the instance.

  * Leave it unset. During the Document Extraction internal code env resources initialization, DSS will look for possible locations of the folder, copy it to the resources folder of the code env, then set the TESSDATA_PREFIX accordingly.




Note

If run in a container execution configuration, DSS handles the installation of Tesseract during the build of the image.

### EasyOCR

EasyOCR does not require any additional configuration. But it’s very slow if run on CPU. We recommend using an execution environment with GPU.

Note

By default EasyOCR will try to download missing language files. Any of the [supported languages](<https://tesseract-ocr.github.io/tessdoc/Data-Files-in-different-versions.html>) can be added in the UI of the recipe. If your instance does not have access to the internet, then all requested language models need to be directly accessible. DSS expects to find the language files in the resources folder of the code environment: /code_env_resources_folder/document_extraction_models/EasyOCR/model. You can retrieve the language files (*.pth) from [here](<https://www.jaided.ai/easyocr/modelhub/>)

## Output update methods

There are four different methods that you can choose for updating your recipe’s output and its associated folder (used for assets storage).

You can select the update method in the recipe output step.

Method | Description  
---|---  
**Smart sync** | Synchronizes the recipe’s output to match the input folder documents, smartly deciding which documents to add/update or remove.  
**Upsert** | Adds and updates the documents from the input folder into the recipe’s output. Smartly avoids adding duplicate documents. Does not delete any existing document that is no-longer present in the input folder.  
**Overwrite** | Deletes the existing output, and recreates it from scratch, using the input folder documents.  
**Append** | Adds the documents from the input folder into the recipe’s output, without deleting or updating any existing records. Can result in duplicates.  
  
Documents are identified by their path in the input folder. Renaming or moving around documents will prevent smart modes from matching them with any pre-existing documents and can result in outdated or duplicated versions of documents in the output of the recipe.

The update method also manages the output _folder_ of the recipe to ensure its content synchronisation with the recipe’s output. Non-managed deletions in the output folder is not recommended and can cause the recipe’s output to point to a missing source.

Tip

If your folder changes frequently, and you need to frequently re-run your recipe, choosing one of the smart update methods, **Smart sync** or **Upsert** , will be much more efficient than **Overwrite** or **Append**.

The smart update methods minimize the number of documents to be re-extracted, thus lowering the cost of running the recipe repeatedly.

Warning

When using one of the smart update methods, **Smart sync** or **Upsert** , all write operations on the recipe output must be performed through DSS. This also means that you cannot provide an output node that already contains data, when using one of the smart update methods.

## Metadata dataset

You can add a metadata dataset in the “Embed documents” recipe to:

  * match recipe rules on a subset of documents based on their custom properties,

  * propagate those custom properties into the knowledge bank allowing to filter search results later,

  * use [Document-level security](<document-level-security.html>)




In the metadata dataset each row corresponds to a document of your folder, with:

  * a column specifying the document path in your folder’s root,

  * (optional) a security column listing the security tokens to access the document’s extracted content ([Document-level security](<document-level-security.html>)),

  * (optional) other metadata columns, for rules matching in this recipe or filtering later in the resulting KB.




Note

If a metadata column is set to the **Bag of words** meaning in the input dataset, it will be treated as a collection of values (e.g. tags). This allows filtering the Knowledge Bank based on whether the document contains specific values in that column.

---

## [generative-ai/knowledge/first-rag]

# Embedding & searching datasets

## Your first RAG using a dataset:

  * In your project, select the dataset that will be used as your corpus. It needs to have at least one column of text

  * Create a new Embed Dataset recipe

  * Give a name to your knowledge bank

  * Select the embedding model to use

  * In the settings of the Embed Dataset recipe, select the column of text

>     * (Optional) select one or several **metadata columns**. These columns will be displayed in the **Sources** section of the answer
> 
>     * (Optional) configure [Document-Level Security](<document-level-security.html>) by selecting the column containing your security tokens
> 
> Note
> 
> If a metadata column is set to the **Bag of words** meaning in the input dataset, it will be treated as a collection of values (e.g. tags). This allows filtering the Knowledge Bank based on whether the document contains specific values in that column.

  * Run the Embed Dataset recipe

  * Open the Knowledge Bank

  * Define a Retrieval-Augmented LLM

>     * Select the underlying LLM that will be queried
> 
>     * (Optional) tune the advanced settings for the search in the vector store
> 
>     * (Optional) configure [Document-Level Security](<document-level-security.html>) to control access to documents based on end-user permissions

  * Click the **Test in Prompt Studio** button for your new Retrieval-Augmented LLM

>     * This will automatically open Prompt Studio and create a new prompt for you, with your Retrieval-Augmented LLM pre-selected

  * Ask your question

  * You will now receive an answer that feeds on info gathered from your corpus dataset, with **Sources** indicating how this answer was generated




## “Embed dataset” Update methods

There are four different methods that you can choose for updating your vector store.

You can select the update method in the embed dataset recipe settings.

Method | Description  
---|---  
**Smart sync** | Synchronizes the vector store to match the input dataset, smartly deciding which rows to add/remove/update.  
**Upsert** | Adds and updates the rows from the input dataset into the vector store. Smartly avoids adding duplicate rows. Does not delete any existing records that are not present in the input dataset.  
**Overwrite** | Deletes the existing vector store, and recreates it from scratch, using the input dataset.  
**Append** | Adds the rows from the input dataset into the vector store, without deleting existing records. Can result in duplicate records in the vector store.  
  
The two smart update methods, **Smart sync** and **Upsert** , require a **Document unique ID** parameter. This is the ID of the document before any chunking has been applied. This ID is used to avoid adding duplicate records and to smartly compute the minimum number of add/remove/update operations needed.

Tip

If your dataset changes frequently, and you need to frequently re-run your embed dataset recipe, choosing one of the smart update methods, **Smart sync** or **Upsert** , will be much more efficient than **Overwrite** or **Append**.

The smart update methods make fewer calls to the embedding model, and thus lowering the cost of running the embedding recipe repeatedly.

Warning

When using one of the smart update methods, **Smart sync** or **Upsert** , all write operations on the vector store must be performed through DSS. This also means that you cannot provide a vector store that already contains data, when using one of the smart update methods.

## Document-Level Security

[Document-level security](<document-level-security.html>) is a data governance feature that enables granular access control over documents within a collection or knowledge bank. It ensures that when a user performs a search or query, the results only include documents that the user is explicitly authorized to view.

To enable document-level security in your Embed Dataset recipe:

  * Navigate to Advanced Settings,

  * Under Document-Level Security, select the column containing your security tokens




To enable document-level security in your RAG model:

  * In the RAG model, select ‘Enforce document-level security’,

  * Provide the end-user security tokens at query time

---

## [generative-ai/knowledge/graphrag]

# GraphRAG

## Overview

GraphRAG is a powerful ability to build and query a knowledge graph from your project data within Dataiku.

The GraphRAG capability in DSS is made of two components:

  1. **GraphRAG Recipe** A _Visual Recipe_ that reads from a dataset, extracts relevant text and metadata, and builds a knowledge graph plus an associated “graph index” inside a **local managed folder** in Dataiku.

  2. **GraphRAG Search Tool** An _Agent Tool_ that enables you to perform searches against the generated GraphRAG index. It can be used within a **Visual Agent** to answer user queries, returning relevant text snippets and associated metadata from the knowledge graph.




## Initial setup

This capability is provided by the “GraphRAG” plugin, which you need to install. Please see [Installing plugins](<../../plugins/installing.html>).

## GraphRAG Recipe

The **GraphRAG Index** recipe is a standard Visual Recipe that reads from a single input dataset and writes its indexed output to a local managed folder of your choice. This output folder contains the knowledge graph files and the “graph index” used by subsequent queries.

  1. **Create the Recipe**
    

Click **\+ Recipe** and choose **GraphRAG** from the plugin recipes list. 

  2. **Configure Settings**
    

**LLMs Settings**
    
     * **Chat Completion LLM** : Select the LLM used in various knowledge graph related taks (entities extraction, summarization,..

     * **Embedding LLM** : Select the LLM used to generate embeddings of the text

**Metadata Settingss**
    
     * **Text Column** : Select which column in your dataset contains the primary textual data.

     * **Attribute Columns** : (Optional) Add any metadata columns you want to include in the knowledge graph.

**Chunking** :
    
     * Adjust the _Chunk Size_ (in characters) and the _Overlap size_ to control how large text blocks become for indexing and how much overlap in text is retained between blocks.

**Graph Embedding Settings** :
    
     * If enabled, the recipe can perform random walks on the knowledge graph to generate additional embeddings (helpful for advanced search features).

**Entities Extraction** :
    
     * Control the _types of entities_ to extract (e.g. organization, person, event, etc.) and how many extraction iterations to run.

**Prompts**
    

In this section, you will find a series of prompt templates used in the recipe. When modifying these prompts, be sure to maintain the template variables and data format. Proceed with caution:
    
     * Entities Extraction Prompt

     * Summarization Prompt

     * Community Reports Prompt

     * Claim Extraction Prompt

Each prompt can be customized to fine-tune how the LLM processes and structures your data.

  3. **Run the Recipe**
    

After configuring all settings, **Run** the recipe. The plugin reads your dataset, applies chunking & entity extraction, and stores the resulting knowledge graph plus indexing structures into your chosen managed folder.




## GraphRAG Search - Agent Tool

Once your knowledge graph has been built, you can query it using the **GraphRAG Search** tool. This tool is designed to be used within Dataiku’s _Visual Agent_ interface.

  1. **Create the tool**

In Agent Tools section of you project, click **\+ NEW AGENT TOOL** and choose the GraphRAG tool from the list.

  2. **Parameters**

> **Managed Folder Containing the Index**
>     
>      * Provide the local managed folder where you wrote the GraphRAG index (the same one you used as the recipe output).
> 
> **Search Type**
>     
>      * _Local Search_ : Focuses on more in-depth, narrower community-based queries in your dataset.
> 
>      * _Global Search_ : Searches across broader contexts, ignoring local community boundaries.
> 
> **Response Type**
>     
>      * You can choose how you want the tool to structure its answer, e.g., _“multiple paragraphs”_ , _“single paragraph”_ , etc.
> 
> **Default Community Level**
>     
>      * When using local search, set how specific the search is in terms of community boundaries. Higher numbers yield more narrow results.
> 
> **Description of the Available Content**
>     
>      * (Optional) Provide a short text describing what is in your knowledge graph. This helps the Agent decision when to leverate the tool.

  3. **Invoke the Tool**

> Once the tool is part of your Agent, you can use it in Agent Connect conversations, Prompt Recipe or using Dataiku API.
> 
> The tool returns a final textual answer plus a list of “source items” (text snippets that were relevant for the answer).

---

## [generative-ai/knowledge/index]

# Adding Knowledge to LLMs

While LLMs alone can already handle a large variety of tasks, they only “know” generic things. LLMs usually truly shine when they are augmented with your own internal company knowledge.

Retrieval-Augmented Generation, or RAG, is a standard technique used with LLMs, in order to give to standard LLMs the knowledge of your particular business problem.

RAG supposes that you already have a corpus of knowledge. When you query a Retrieval-Augmented LLM, the most relevant elements of your corpus are automatically selected, and are added into the query that is sent to the LLM, so that the LLM can synthesize an answer using that contextual knowledge.

To get started with RAG, you can refer to the following articles in the Knowledge Base:

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Embed recipe and Retrieval Augmented Generation (RAG)](<https://knowledge.dataiku.com/latest/genai/rag/concept-rag.html>)

  * [Tutorial | Use the Retrieval Augmented Generation (RAG) approach for question-answering](<https://knowledge.dataiku.com/latest/genai/rag/tutorial-rag-embed-dataset.html>)

---

## [generative-ai/knowledge/initial-setup]

# Initial setup

## Install and enable the RAG code env

In order to work with knowledge banks and perform RAG, you need a dedicated code environment (see [Code environments](<../../code-envs/index.html>)) with the appropriate packages.

  * In **Administration** > **Code envs** > **Internal envs setup** , in the **Retrieval augmented generation code environment** section, select a Python version in the list and click **Create code environment**

  * In **Administration** > **Settings** > **LLM Mesh** , in the **Retrieval augmented generation** section, select **Use internal code env**




## Embedding LLMs

In order to use RAG, you must have at least one LLM connection that supports embedding LLMs. At the moment, embedding is supported on the following connection types:

  * OpenAI

  * Azure OpenAI

  * AWS Bedrock

  * Databricks Mosaic AI

  * Snowflake Cortex

  * Local Hugging Face

  * Mistral AI

  * Vertex Generative AI

  * Amazon Sagemaker LLM

  * Custom LLM Plugins

---

## [generative-ai/knowledge/introduction]

# Introduction to Knowledge Banks and RAG

Knowledge Banks support key Generative AI features in Dataiku, such as Retrieval-Augmented Generation (RAG) and semantic search.

RAG and Knowledge Banks primarily rely on embeddings, vector representations of text or documents generated by a specialized type of LLM called an Embedding LLM.

In a RAG workflow, an LLM is augmented with a Knowledge Bank to retrieve the most relevant chunks or other contextual elements, for example, a screenshot of a document from which text has been extracted, before generating a response.

This allows the model to use information retrieved from the Knowledge Bank when formulating its answer. See [Knowledge and RAG](<first-rag.html>) for details about how Knowledge Banks are used in Retrieval-Augmented Generation workflows.

## Capabilities enabled by Knowledge Banks

From the Knowledge Bank page, you can:

### Search

Run semantic searches across your corpus. This lets you explore search results, check chunking and retrieval quality, and validate how well your content supports RAG queries.

### Create a Retrieval-Augmented LLM

Create an RA-LLM that combines your Knowledge Bank with an LLM. The model is augmented with relevant chunks or other contextual data from the Knowledge Bank before answering, providing source-based responses in Prompt Studio, Prompt Recipes, or through the LLM Mesh API.

### Create a Knowledge Bank Search Tool

Build a Knowledge Bank Search Tool to allow LLM agents or automation workflows to query the Knowledge Bank programmatically. See [Knowledge Bank Search tool](<../../agents/tools/knowledge-bank-search.html>) for details about the tool settings.

---

## [generative-ai/knowledge/kb-search-settings]

# Search settings

Retrieving relevant documents from a Knowledge Bank for RAG can be customized through three main settings: Filtering, Search type and Search mode. They can be configured in Augmented LLMs and [Knowledge Bank Search Tools](<../../agents/tools/knowledge-bank-search.html>).

## Filtering

The Filtering settings define which subset of the Knowledge Bank is available for retrieval. They can be used to narrow down the scope of the search to a specific segment of the stored knowledge.

  * Static filtering: Restricts the search to a fixed subset of the Knowledge Bank. The filter condition is defined once and remains the same for all queries.

  * Dynamic filtering: Allows the filter condition to vary for each query.




## Query Strategy

The Query Strategy defines when and how DSS queries the Knowledge Bank. Mainly useful in chat-based contexts, where the system decides dynamically whether to retrieve new information for each user message.

  * Raw mode: Always queries the Knowledge Bank with the full query history in chat mode.

  * Smart mode: First evaluates whether retrieval would add value and can automatically reformulate the query to optimize results.




## Retrieval

The Retrieval settings define how DSS selects documents from the Knowledge Bank. It includes several search types such as similarity-based search, threshold filtering, hybrid search, and diversity enhancement.

DSS leverages each vector store’s default/preferred similarity metric for vector similarity search:

  * **Euclidean distance** for Chroma, FAISS, OpenSearch

  * **Cosine similarity** for Milvus, Qdrant, Pinecone, Azure AI search, Elasticsearch

  * **Dot product** for Vertex Vector Search




Note

The similarity metric can be changed, but it is applied only when the index is created. Changing this setting on an existing index has no effect. To use a new metric, the index needs to be rebuilt.

When diversity is enabled, DSS uses the MMR (Maximal Marginal Relevance) algorithm to balance relevance and variety among retrieved documents.

Hybrid search combines similarity and keyword retrieval to improve coverage.

Note

Supported only by Azure AI Search, Elasticsearch, and Milvus (local and remote), and not compatible with the diversity option.

## Ranking and Reranking

To improve search relevance, you can refine and filter retrieved documents before they are sent to the LLM. DSS supports two methods for this: **Native Rankers** (specific to certain vector stores) and **Model-Based Rerankers** (using a dedicated model).

### Native Rankers

Native rankers rely on the internal capabilities of specific vector stores to improve result ordering. This feature is available for some vector stores when **Hybrid search** is the selected search type. Native rankers are available for Azure AI Search and Elasticsearch with a compatible subscription, as well as for Milvus (local and remote).

Vector Store | Ranker Type  
---|---  
**Azure AI Search** | Uses Azure’s proprietary [Semantic Ranker](<https://learn.microsoft.com/en-us/azure/search/semantic-search-overview>).  
**Elasticsearch** | Uses [RRF (Reciprocal Rank Fusion)](<https://www.elastic.co/guide/en/elasticsearch/reference/current/rrf.html>). This accepts two parameters: **Rank constant** and **Rank window size**.  
**Milvus** | Uses Milvus implementation of [RRF (Reciprocal Ranking Fusion)](<https://milvus.io/docs/rrf-ranker.md>) with the recommended value k=60.  
  
### Model-Based Rerankers

Model-based reranking uses a specialized machine learning model to re-score and re-order the results returned by your retriever. Unlike native rankers, these are not tied to a specific vector store; they work by passing your retrieved documents through an additional model.

Supported connections for reranking:

Connection | Reranker Capability  
---|---  
**Hugging Face** | Connects to the **Hugging Face Hub** , allowing you to run compatible open-source reranker models (such as BGE-Reranker).  
**Amazon Bedrock** | Provides access to fully managed reranking models, including **Cohere Rerank**.  
**Microsoft AI Foundry** | Provides access to Model-as-a-Service (MaaS) endpoints, including support for **Cohere Rerank** models.  
  
Note

Since model-based rerankers process results after retrieval, they may add latency to the pipeline but often provide higher accuracy for complex queries.

## Response Generation

The Response Generation settings control how the LLM synthesizes the final answer using the documents retrieved and ranked in the previous steps.

**Custom Generation Prompt** : allows you to define the instructions sent to the LLM. You can specify the tone, style, and strictness of the response (e.g., instructing the model to say “I don’t know” if the context is insufficient).

**Sources** : let you to include metadata from the retrieved documents (such as file names, URLs, or page numbers) in the final output. This helps users verify the information provided by the model.

  * Standard: Appends the selected metadata field to the output “as is.”

  * With role: Assigns a specific semantic role (_e.g._ , Title, URL) to the metadata, allowing the UI or client application to format it appropriately (for example, rendering a clickable link).

---

## [generative-ai/knowledge/rag-guardrails]

# RAG guardrails

Beware: should not be confused with the standard [Guardrails](<../guardrails/index.html>) that apply to all LLM use cases.

RAG guardrails are specific capabilities that only apply on Retrieval-Augmented LLM. Their sole focus is ensuring that the selected context and answer make sense given the question and knowledge bank.

Note

RAG Guardrails are available to customers with the _Advanced LLM Mesh_ add-on

Select an auxiliary LLM and an embedding model to evaluate the answer of an augmented LLM. Define minimum thresholds for:

  * the _relevancy_ of the response: how much it addresses the user query

  * the _faithfullness_ of the response: how consistent it is with the retrieved excerpt




Set the outcome when the output is below threshold: either reject the request or replace the answer by an explanatory response.

---

## [generative-ai/knowledge/vector-stores]

# Working with Vector stores

## Vector store types

Out of the box, Knowledge Banks are created with a Vector Store called **Chroma**. This does not require any setup, and provides good performance even for quite a large corpus.

As an alternative, other no-setup Vector Stores are available: Milvus (local), Qdrant, and FAISS.

For more advanced use cases, you may wish to use a dedicated Vector Store. Dataiku supports several third-party vector stores that require you to set up a dedicated connection beforehand:

  * Azure AI search

  * Elasticsearch

  * OpenSearch, including [AWS OpenSearch services](<../../connecting/elasticsearch.html#amazon-opensearch-service>) (both managed cluster & serverless)

  * Milvus (remote)

  * Pinecone

  * Vertex Vector Search (based on a Google Cloud Storage Connection)




When creating the Embedding recipe, select the desired vector store type, then select your connection. You can also change the vector store type later, by editing the settings of the Knowledge Bank.

For Azure AI Search, Vertex Vector Search, Elasticsearch, OpenSearch and Milvus (remote), DSS provides a default index name that you can update if needed. For Pinecone, make sure to provide the name of an existing index.

Note

When setting up an Elasticsearch, an OpenSearch or a Google Cloud Storage connection, you must allow the connection to be used with Knowledge Banks. There is a setting in the connection panel to allow this.

### Limitations

  * Rebuilding a Pinecone-based Knowledge Bank may require that you manually delete and recreate the Pinecone index.

  * You need an Elasticsearch version >=7.14.0 to store a Knowledge Bank.

  * Elasticsearch >=8.0.0 and <8.8.0 supports only embeddings of size smaller than 1024. Embedding models generating larger embedding vectors will not work.

  * Milvus (local) does not support empty values in metadata. Dataiku fills empty values with defaults depending on the type (NaN for numbers, False for booleans, and empty string for other types).

  * Milvus (local and remote) does not support adding new metadata columns to already-built Knowledge Banks created from an Embed Documents recipe. New metadata columns are ignored until the Knowledge Bank is cleared and rebuilt.

  * Milvus (local and remote) supports switching update method from **Smart sync** to **Append** only after clearing the Knowledge Bank.

  * Only Private key authentication is supported for Google Cloud Storage connections used for Knowledge bank usage.

  * Smart update methods (**Smart sync** and **Upsert**) are not supported on the following vector store types: Pinecone, AWS OpenSearch serverless.

  * Note that, after running the embedding recipe, remote vector stores might take some time to update their indexing data in their respective user interfaces.

---

## [generative-ai/llm-connections]

# LLM connections

In order to start using the LLM Mesh, an administrator first needs to define connections to LLM models.

There are two kinds of connections to LLM models:

  * Hosted LLM APIs

  * Locally-running LLM models, using HuggingFace models running on GPUs.




## Hosted LLM APIs

The LLM Mesh provides support for a vast number of LLM API providers in order to maximize your options for choosing your preferred LLM provider.

### Anthropic

The Anthropic connection provides connection to Anthropic text models. You will need a Anthropic API key.

The Claude, Claude-instant, Claude 2 and Claude 3 models are supported.

### AWS Bedrock

The Bedrock connection provides access to models through Amazon Bedrock. You will need:

  * An AWS account with Bedrock access enabled

  * An existing S3 connection with credentials properly setup.




The Bedrock connection provides access to the following Bedrock models:

  * The Anthropic Claude models family (Instant v1, v2, v3, v3.5 Sonnet)

  * The AI21 Labs Jurassic 2 models family

  * The Cohere Command models family (Command, Command Light, Command R, command R+), Cohere Embed, and Cohere Rerank models

  * The AWS Titan G1 models family, AWS Titan v2 Embeddings

  * The Mistral models family (7B, 8x7B, Large)

  * The Meta Llama2 and Llama3 Chat models

  * The Stability AI image generation models

>     * SDXL 1.0
> 
>     * Stable Image Core
> 
>     * Stable Diffusion 3 Large
> 
>     * Stable Image Ultra




Text completion, chat completion, image generation, text/image embedding, and reranking models are supported.

#### Inference profile

A cross-region inference profile allows you to distribute traffic across different AWS regions, therefore increasing throughput and resilience. When provided, an inference profile applies to all enabled models, including custom models. However, the inference profile is not applied to any custom models with an application inference profile ARN as the id.

Note that some models/regions require an inference profile to work on AWS’ side, and that Bedrock’s support for them varies by model/region. See [this list](<https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles-support.html>) of supported inference profiles by region and model. See the [AWS documentation](<https://docs.aws.amazon.com/bedrock/latest/userguide/cross-region-inference.html>) for more information.

#### Bedrock Guardrail

You may use an AWS Bedrock Guardrail created on the AWS console. To do so, enable “Bedrock Guardrail”, specify the Identifier and Version information (version is either `DRAFT` or a number), and check that the region on the connection page matches the region where the Guardrail was created.

The Bedrock Guardrail is then applied to all models of the connection, including custom models.

Only one Bedrock Guardrail can be set on a given Bedrock connection. For complex filtering, you can combine different types of filters and checks in your Guardrail on the AWS Bedrock console.

### AWS SageMaker LLM

The SageMaker LLM connection allows connecting to some completion and summarization models deployed as SageMaker endpoints. You will need an existing SageMaker connection.

The following models have builtin handling modes:

  * The Anthropic Claude models family (v1, v2)

  * The AI21 Labs Jurassic 2 models family

  * The Cohere Command and Cohere Command Light models

  * The LLama2 family (v1, v2, v3)

  * Hugging Face models




Limited support for some other models and endpoints is provided through configuration of a custom query template.

### Azure AI Foundry

The Azure AI Foundry connection provides connectivity to a wide catalog of models deployed through the Azure AI Foundry resource.

You will need: * An Azure account with an Azure AI Foundry resource * A model deployed from the Azure AI Foundry **Model Catalog** * The **Endpoint** for your Azure AI Foundry resource * An **API Key** for your resource

You will need to declare each model by its **Deployment Name** , which you specify when deploying a model from the catalog. Text completion, chat completion, image generation, text embedding, and reranking models are supported.

### Azure OpenAI

The Azure OpenAI connection provides connection to Azure OpenAI text and image models. You will need:

  * An Azure account with Azure OpenAI enabled

  * A deployed Azure OpenAI service

  * One or several Azure OpenAI model deployments

  * An Azure OpenAI API key




You will need to declare each Azure OpenAI model deployment, as well as the underlying model that is being deployed (for the purpose of cost computation).

Text completion, chat completion, image generation and text embedding models are supported.

As of October 2023, Azure OpenAI Terms and Conditions indicate that Azure will not retain your data for enhancing its models.

For Azure OpenAI connections made through an [APIM gateway](<https://azure.microsoft.com/en-us/products/api-management>), there are two available options:

  1. Custom headers can be provided in the Azure OpenAI connection, e.g. to set an APIM subscription key

  2. For more complex APIM setups, the Azure OpenAI APIM Custom LLM plugin is available on demand through the Dataiku plugin store, e.g. for setting custom OAuth scopes, and dynamic correlation IDs




### Azure LLM

The Azure LLM connection provides connectivity for models deployed with Azure Machine Learning (also known as Azure ML or Azure AI | Machine Learning Studio) or Azure AI Studio.

You will need:

  * An Azure account with Azure ML or Azure AI Studio enabled

  * If using Azure AI Studio, a deployment on a serverless endpoint

  * If using Azure ML, a serverless endpoint

  * In both cases, the Key provided by Azure




You will need to declare each Azure ML Endpoint or Azure AI Studio Deployment, with the Target URI as provided by Azure.

The serverless endpoints should conform to the [Open AI v1 API Reference](<https://platform.openai.com/docs/api-reference>). [Chat](<https://platform.openai.com/docs/api-reference/chat>) and [Embbeddings](<https://platform.openai.com/docs/api-reference/embeddings>) endpoints are supported.

### Cohere

The Cohere connection provides connection to Cohere text models. You will need a Cohere API key.

The command and command-light models are supported.

### Databricks Mosaic AI (previously MosaicML)

The Databricks Mosaic AI connection provides connection to Databricks Foundation Model APIs. You will need an existing Databricks Model Deployment connection.

The supported models are:

  * BGE Large En (text embedding)

  * DBRX Instruct

  * Llama3.1 (70B, 405B)

  * Mixtral 8x7B




Note

MosaicML Inference has been retired by MosaicML, and therefore the MosaicML connection has been removed in DSS 12.6.

Databricks Mosaic AI connections should be used as a replacement.

### Google Vertex Generative AI

The Google Vertex LLM connection provides connection to Vertex PaLM text models. You will need:

  * a service account key, or OAuth credentials

  * at least the Vertex AI Service Agent role




The Chat Bison and Gemini Pro models are supported.

Image generation Imagen 3 and Imagen 3 Fast models are also supported.

### Mistral AI

The Mistral AI connection provides connection to Mistral AI text models. You will need a Mistral AI API key.

The supported models are:

  * Mistral 7B

  * Mistral 8x7B

  * Mistral Small

  * Mistral Large

  * Mistral Embed




### NVIDIA NIM

The NVIDIA NIM connection allows you to leverage NVIDIA NIM microservices for optimized inference. You can connect to models hosted in the NVIDIA API catalog, self-hosted on-premises, or in the cloud.

Depending on your deployment, you will need:

  * An NVIDIA AI Enterprise subscription or NVIDIA Developer Program membership.

  * A NIM API Key (for hosted models).

  * A running NIM service (for self-hosted deployments).




The connection supports:

  * Text and Multimodal Chat Completion models.

  * Text Embedding models.

  * Streaming and tool calling for compatible models.




Because NIMs can be self-hosted via a dedicated Kubernetes operator, the setup involves specific plugin configurations and deployment steps. See [NVIDIA NIM](<nvidia-nim.html>) for the full setup guide and deployment instructions.

### NVIDIA NIM

The NVIDIA NIM connection supports text and multimodal models for chat and embeddings. An NVIDIA NIM API key is required.

Supported models can be found in the NVIDAI NGC catalog.

### OpenAI

The OpenAI connection provides connection to OpenAI text models (GPT 4o, O1, O3, GPT 3.5 Turbo, GPT 4) and the image generation model DALL·E 3. You will need an OpenAI API key (not to be confused with a ChatGPT account). You can select which OpenAI models are allowed.

The OpenAI connection supports text completion, image generation and embedding.

### Snowflake Cortex

The Snowflake Cortex connection provides connection to some Snowflake Cortex text models. You will need an existing Snowflake connection.

The following chat models are supported:

  * Gemma 7B

  * Llama2 70B

  * Mistral 7B

  * Mixtral 8x7B

  * Mistral Large

  * Snowflake Arctic




### Stability AI

The Stability AI connection provides connection to image generation models. You will need a Stability AI API key.

The following image generation models are supported:

  * Stable Image Core

  * Stable Diffusion 3.0 Large

  * Stable Diffusion 3.0 Large Turbo

  * Stable Image Ultra




## Locally-running HuggingFace models

See [Running Hugging Face models](<huggingface-models.html>)

---

## [generative-ai/multimodal]

# Multimodal capabilities

The LLM Mesh provides multimodal capabilities to handle:

  * Image inputs. Images can be mixed with text in LLM queries, in order to answer queries like “please describe what is in this image”

  * Image outputs. The LLM Mesh can generate images.




## Image input

### Supported models

Multimodal input with images is supported with the following providers:

  * OpenAI (GPT-4o)

  * Azure AI Foundry

  * Azure OpenAI (GPT-4o)

  * Vertex Gemini Pro

  * Bedrock Claude 3

  * Bedrock Claude 3.5

  * Local HuggingFace models




### API

Image input is available in the LLM Mesh API.

For more details, please see [LLM Mesh](<https://developer.dataiku.com/latest/concepts-and-examples/llm-mesh.html> "\(in Developer Guide\)")

### Answers

Image input is available in [the Chat UIs](<chat-ui/index.html>)

## Image output

### Supported models

Image generation is supported with the following providers:

  * OpenAI (DALL-E 3)

  * Azure AI Foundry (Stable Diffusion 3.5, DALL-E 3, FLUX 2)

  * Azure OpenAI (DALL-E 3)

  * Google Vertex (Imagen 3 and Imagen 3 Fast)

  * Stability AI

  * Bedrock Titan Image Generator

  * Bedrock Stability AI models

  * Local HuggingFace models




### Image-to-image support

Bedrock Amazon Titan Image Generator G1 supports image-to-image with the following image edition modes:

  * Image-to-image with prompt

  * Image-to-image without prompt

  * Image-to-image inpainting

>     * Black mask mode




Bedrock Stability AI SDXL 1.0 also supports image-to-image with the following image edition modes:

  * Image-to-image with prompt

  * Image-to-image inpainting

>     * Black mask mode
> 
>     * Transparent original image mode




Stability AI Stable Diffusion 3 Large supports image-to-image mode with prompt.

The Stability AI connection also supports CONTROLNET_SKETCH and CONTROLNET_STRUCTURE image edition modes.

### API

Image output is available through the LLM Mesh API. Note that some parameters are not supported by all providers / models.

For more details, please see [LLM Mesh](<https://developer.dataiku.com/latest/concepts-and-examples/llm-mesh.html> "\(in Developer Guide\)")

---

## [generative-ai/nvidia-nim]

# NVIDIA NIM

Integrating [NVIDIA NIM LLMs](<https://docs.nvidia.com/nim/large-language-models/latest/introduction.html>) into Dataiku allows you to leverage high-performance inference for both hosted and self-hosted models. This capability is enabled via the NVIDIA NIM plugin, which provides both the LLM Mesh connectivity and management tools for Kubernetes-based deployments.

## Capabilities

NVIDIA NIM integration provides three primary features to your Dataiku instance:

  * Dataiku LLM Mesh Connection \- Connect to NVIDIA NIM models for chat completion and embeddings

  * NIM Deployment Macro \- Deploy and manage NIMs on Kubernetes clusters

  * NemoGuard NIMs Guardrails \- Apply content safety, topic control, and jailbreak detection




### Dataiku LLM Mesh Connection

A specialized LLM Mesh [connection](<https://doc.dataiku.com/dss/latest/generative-ai/llm-connections.html>) with:

  * Access to NVIDIA NIM Text/Multimodal Chat Completion and Embedding models via the Dataiku LLM Mesh.

  * Support for streaming and tool calling for compatible NIM models.




This connection is infrastructure-agnostic; models can be hosted in the [NVIDIA Cloud](<https://build.nvidia.com/explore/discover>), self-hosted using the provided deployment macro, or managed on external infrastructure. To create the connection, navigate to **Administration > Connections > New Connection > NVIDIA NIM**.

Note

For embedding models that require an `input_type` parameter: You can pass it as a suffix to the model identifier (e.g., `NV-Embed-QA-query` or `NV-Embed-QA-passage`).

## NIM Deployment Macro

For teams self-hosting on Kubernetes, the NIM Deployment Macro is available to manage the underlying infrastructure directly from Dataiku:

  * Deploy, list, and remove the NVIDIA GPU Operator and NIM Operator.

  * Deploy, list, and remove NVIDIA NIM Services.




Note

Using the macro to deploy the GPU and NIM Operators is optional. In many environments, it may be preferable to manage these operators externally (e.g., via the OpenShift OperatorHub) before connecting them to Dataiku.

### Prerequisites

  * Dataiku >= v14.2.0

  * An [NVIDIA AI Enterprise](<https://www.nvidia.com/en-us/data-center/products/ai-enterprise/>) license.

  * The NVIDIA NIM Plugin installed from the Dataiku Plugin Store.

  * **NIM Container Registry** and **NIM Model Repository** credentials (these can be an NVIDIA Authentication API Key if using [NGC](<https://catalog.ngc.nvidia.com/>)).

  * An attached Kubernetes cluster with:
    
    * An auto-provisioning Storage Class that supports “ReadWriteMany” access mode (see [NIM Operator docs](<https://docs.nvidia.com/nim-operator/latest/service.html#example-create-a-pvc-instead-of-using-a-nim-cache>)).

    * (Optional) The Prometheus operator [installed on the cluster](<https://docs.nvidia.com/nim-operator/latest/service.html#prerequisites-hpa>), required if leveraging horizontal pod autoscaling.

    * (Optional) The [Nginx ingress controller](<https://github.com/kubernetes/ingress-nginx>) installed on the cluster; without this, the deployment macro defaults to exposing the NIM Services using a NodePort Kubernetes service.




### Plugin Configuration

To begin, install the NVIDIA NIM plugin (see the [plugin installation guide](<https://doc.dataiku.com/dss/latest/plugins/installing.html>)). Once installed, configure the necessary credentials via Plugin Presets.

**Self-hosted Credentials**

This preset stores the **NIM Container Registry** and **NIM Model Repository** credentials required when self-hosting NIMs on an attached Kubernetes cluster using the NIM Deployment Macro.

  * Navigate to **Plugins > Installed > NVIDIA NIM Plugin > Settings > Self-hosted credentials > Add a Preset**.

  * For the **Docker container registry** , enter the host, username, and API key.

  * For the **NIM model registry** :
    
    * If using **NGC** , simply enter your NGC API key.

    * If using an **alternative model registry** (such as JFrog), select the **override model registry** checkbox and enter the model registry host, protocol, and API key.




**NIM Environment Variables**

This preset provides a mechanism to override the values of NIM environment variables. It should only be used when self-hosting NIMs on an attached Kubernetes cluster using the NIM Deployment Macro.

  * Navigate to **Plugins > Installed > NVIDIA NIM Plugin > Settings > NIM Environment Variables > Add a Preset**.

  * Use this to override the value of any standard [NIM environment variable](<https://docs.nvidia.com/nim/large-language-models/latest/configuration.html#environment-variables>).




### Deploying NIM Services

If you are self-hosting, the NIM deployment macro is located in the **Administration > Clusters > [Cluster Name] > Actions** tab of the Kubernetes cluster.

**GPU and NIM Operators**

The macro provide the option to list, deploy, and remove the NVIDIA NIM Operator & GPU Operator. If these Operators are not already available on the cluster, you must deploy them prior to deploying your first NIM Service.

**NIM Services**

The macro provides the option to list, deploy, and remove NVIDIA NIM Services. Under the hood, Dataiku leverages the NVIDIA NIM Operator, so all options presented in the UI correspond to those described in the NIM Operator [documentation](<https://docs.nvidia.com/nim-operator/latest/service.html#about-nim-services>).

## NemoGuard NIMs Guardrails

The NemoGuard NIMs Guardrails component provides content safety, topic control, and jailbreak detection capabilities powered by NVIDIA NemoGuard microservices. Apply these guardrails to LLM conversations to detect and prevent unsafe, off-topic, or malicious content.

### Guardrail Types

**Topic Control**

Analyzes the full conversation context to ensure discussions remain within approved boundaries (e.g. product domain for a customer service chatbot). The guardrail sends the complete message history to the NemoGuard Topic Control NIM, which determines if the conversation is on-topic. [Learn more](<https://docs.nvidia.com/nim/llama-3-1-nemoguard-8b-topiccontrol/latest/prompt-template.html#system-instruction>).

**Content Safety**

Checks both user queries and model responses for unsafe content including violence, hate speech, sexual content, and harassment. The guardrail analyzes the last user message and (if present) the assistant’s response. [Learn more](<https://docs.nvidia.com/nim/llama-3-1-nemoguard-8b-contentsafety/latest/index.html>).

**Jailbreak Detection**

Identifies prompt injection attacks and attempts to manipulate the AI system. Only operates on user queries (the last message in the conversation). [Learn more](<https://docs.nvidia.com/nim/nemoguard-jailbreakdetect/latest/getting-started.html>).

### Configuration

The configuration process depends on the type of guardrail.

#### For Topic Control and Content Safety

These guardrails use standard NIM models that must first be added to an NVIDIA NIM connection in the LLM Mesh.

  1. **Add the Guardrail Model to a Connection** : Navigate to **Administration > Connections** and either create a new **NVIDIA NIM** connection or edit an existing one. Add the Topic Control or Content Safety model to this connection.




  2. **Add the Guardrail to an LLM** : Go to the LLM you want to protect (in the same or a different connection) and navigate to the **Guardrails** tab.

  3. **Configure the Guardrail** :

     * Click **Add Guardrail** and select **Nemo Guardrails NIMs**.

     * **NIM Guardrail** : Choose **Topic Control** or **Content Safety** , then specify the NVIDIA NIM Connection with the guardrail model, the model and the action to take (Reject, Audit, or Decline).




#### For Jailbreak Detection

The Jailbreak Detection guardrail uses a model that is not exposed via a standard OpenAI-compatible API. Therefore, its endpoint must be configured directly within the guardrail settings.

  1. **Create an Authentication Connection** : Ensure you have an **NVIDIA NIM** connection configured in Dataiku. This connection will be used to authenticate requests to the jailbreak model endpoint, but the model itself is not added to this connection.

  2. **Add the Guardrail to an LLM** : Go to the LLM you want to protect and navigate to the **Guardrails** tab.

  3. **Configure the Guardrail** :

     * Click **Add Guardrail** and select **Nemo Guardrails NIMs**.

     * **NIM Guardrail** : Choose **Jailbreak Protection**.

     * **NVIDIA NIM Connection** : Select the connection to use for authentication.

     * **Model Endpoint** : Enter the full endpoint URL for the Jailbreak Detection NIM.

     * **Action to take** : Define the desired behavior.




### Usage

Once configured, guardrails automatically evaluate:

  * **Queries** : Before they are sent to the LLM

  * **Responses** : After the LLM generates a response (optional, configured via “Operate on responses”)




Guardrails process the full conversation context, allowing NemoGuard NIMs to make informed decisions based on the entire dialogue history.

## Case Study: Scaling Generative AI in Financial Services

Learn how the Dataiku and NVIDIA partnership is enabling financial services institutions to scale generative AI:

[Scaling GenAI in FSI with Dataiku and NVIDIA](<https://www.dataiku.com/stories/blog/scaling-genai-in-fsi-with-dataiku-and-nvidia>)

---

## [generative-ai/prompt-optimization]

# Automated Prompt Optimization

Automated Prompt Optimization is a feature for optimizing prompts for question-answering (QA) tasks. It leverages the [dspy](<https://dspy.ai/>) library, a framework for programming with language models (LMs), to systematically improve prompt performance. It is provided by the Automated Prompt Optimization plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

Given a dataset of questions and answers, the recipe explores different prompt variations and evaluates their performance, then outputs an optimized prompt for your selected language model.

This process helps in:

  * Increasing the accuracy of QA tasks.

  * Finding the most effective instructions for a given LLM.

  * Evaluating different LLMs for a specific task.




This recipe takes a dataset of questions and answers and produces a new dataset containing the original and optimized prompts, along with their performance scores.

## Inputs

  * **Validation Dataset** : A dataset containing the data for prompt optimization. It must contain at least two columns:

    * A column with questions.

    * A column with the corresponding ground-truth answers.

    * Optionally, a column with context for each question-answer pair to help validate the answer.




## Output

  * **Optimal Prompts** : A dataset containing the results of the optimization. It will have the following columns:

    * `run`: The name of the run (`initial` for the initial prompt, `optimized` for the optimized prompt).

    * `prompt`: The text of the prompt.

    * `score_train`: The performance score on the training set.

    * `score_test`: The performance score on the test set (if a train/test split is used).




## Parameters

The recipe’s behavior can be customized with the following parameters:

### LLM configuration

  * **Target LLM** : The language model you want to optimize the prompt for. This LLM will be used to answer the questions during evaluation and to generate new prompt variations during optimization (for COPRO). It can be any LLM connection or Agent from the [LLM Mesh](<https://doc.dataiku.com/dss/latest/generative-ai/introduction.html>).

  * **LLM-based Validation** : A boolean parameter.

    * If `false` (default), the answers from the LLM are evaluated against the ground-truth answers using an exact match (F1 score).

    * If `true`, a separate `Validation LLM` is used to perform a more semantic evaluation of the answer’s quality (using the context column if it exists).

  * **Validation LLM** : The language model to use for evaluation when `LLM-based Validation` is enabled.




### Dataset mapping

  * **Question column** : The column in the input dataset that contains the questions.

  * **Ground Truth Answer column** : The column in the input dataset that contains the ground-truth answers.

  * **Context column (optional)** : The column in the input dataset that contains the context for the questions.




### Optimization settings

  * **Initial prompt (optional)** : The initial prompt to start the optimization from. If not provided, a default QA prompt is used.

  * **Train/Test Split Ratio** : The ratio to split the input dataset into a training set and a test set.

    * The training set is used by the optimizer to find the best prompt.

    * The test set is used to evaluate the performance of the initial and final prompts on unseen data.

    * If the ratio is `0`, no test set is created, and no test scores are computed.

  * **Optimizer** : The algorithm to use for optimization. The recipe supports two optimizers from `dspy`:

    * **COPRO** : “Compilation-based aPproach to pRompt Optimization”. A tree-based optimizer that explores and refines prompts by iteratively generating new instruction variations.

    * **BootstrapFewShot with Random Search** : Optimizes by selecting the best few-shot demonstrations from your training data through random search.




### Advanced parameters (Show Advanced Parameters checkbox)

**For COPRO Optimizer:**

  * **COPRO: Depth** : The number of optimization levels.

  * **COPRO: Breadth** : The number of new prompts to generate at each level.

  * **COPRO: Initial Temperature** : The temperature for prompt generation.




**For BootstrapFewShot Optimizer:**

  * **Bootstrap: Max Bootstrapped Demos** : Maximum number of bootstrapped demonstrations to generate (default: 4).

  * **Bootstrap: Max Labeled Demos** : Maximum number of labeled demonstrations to use (default: 16). Examples are included in the prompt and will leak some information if you don’t use a test set.

  * **Bootstrap: Number of Candidate Programs** : Number of candidate programs to evaluate during random search (default: 16).

  * **Bootstrap: Number of Threads** : Number of threads to use for parallel evaluation (default: 4).

---

## [generative-ai/prompt-studio]

# The Prompt Studio

Dataiku features a full-featured development environment for Prompt Engineering, the _Prompt Studio_. In the Prompt Studio, you can test and iterate on your prompts, compare prompts, compare various LLMs (either APIs or locally hosted), and, when satisfied, deploy your prompts as Prompt Recipes for large-scale batch generation. You also can use the Prompt Studio as a chat interface to interact with LLMs.

The Prompt Studio sits on top of the LLM Mesh and all benefits of the LLM Mesh fully apply to Prompt Studios.

See also

For more information, see also the following articles in the Knowledge Base:

  * [Concept | Prompt Studios and Prompt recipe](<https://knowledge.dataiku.com/latest/genai/text-processing/concept-prompt-studio.html>)

  * [Tutorial | Prompt engineering with LLMs](<https://knowledge.dataiku.com/latest/genai/text-processing/tutorial-prompt-engineering.html>)

  * [Tutorial | Processing text with the Prompt recipe](<https://knowledge.dataiku.com/latest/genai/text-processing/tutorial-prompt-recipe.html>)

---

## [generative-ai/rate-limiting]

# Rate Limiting

Rate limiting in the LLM Mesh helps manage the flow of LLM queries and ensure compliance with provider-side usage limits.

## Concepts

Rate limits are enforced per LLM model and per provider. They apply to all queries executed through the LLM Mesh — across projects, LLM connections, and users.

Limits are expressed in _requests per minute_ (_RPM_). If the rate is exceeded:

  * Requests are automatically throttled (_i.e._ , delayed).

  * If the request cannot be served within a reasonable delay, it fails with a rate limiting error.




DSS provides _baseline settings_ with sensible production-ready defaults. These settings are fully configurable, allowing you to override them as needed to match your specific use case or provider requirements.

## Rule Configuration

Rate limiting rules are defined **per provider** , and can be defined in two ways:

  * For _specific models_ within that provider.

  * As a _default fallback_ that applies to all other models from the provider.




Each provider’s default rule can target one of the following model categories:

  * Completion models

  * Embedding models

  * Image generation models




## Limitations

Rate Limiting is not supported for the following LLM connections:

  * _Amazon SageMaker LLM_

  * _Databricks Mosaic AI_

  * _Snowflake Cortex_

  * _Local Hugging Face_




## Setup

A dedicated **Rate Limiting** section lets you configure the rate limits. Find it in **Administration** > **Settings** > **LLM Mesh**.