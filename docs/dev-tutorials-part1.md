# Dataiku Docs — dev-tutorials

## [tutorials/genai/agents-and-tools/llm-agentic/agents/index]

# Creating an LLM-based agent that uses multiple tools

## Introduction

The [previous part](<../tools/index.html>) of this tutorial series showed how to define external tools so an LLM can retrieve data or perform specialized tasks. Now, let’s see how to integrate these tools into an agent capable of handling multi-step queries in a flexible conversation.

In this tutorial, you’ll create an agent to deploy multiple tools to manage user queries in a conversational workflow. Whenever a user asks for information, the agent decides how to respond. It could answer directly, but more often it might have to engage a “tool.” In this example, the agent relies on two tools from the previous tutorial. To recap, one retrieves a user’s name, position, and company based on an ID, while a second tool searches the Internet to find company information.

[tools.json](<../../../../../_downloads/0d3a74d462b62a493f2ab4bae05ac63b/tools.json>)

Previously defined tools
    
    
    {
        "tools": [
            {
                "type": "function",
                "function": {
                    "name": "get_customer_info",
                    "description": "Get customer details from the database given their ID",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "customer_id": {
                                "type": "string",
                                "description": "The unique identifier for the customer"
                            }
                        },
                        "required": ["customer_id"]
                    }
                }
            },
            {
                "type": "function", 
                "function": {
                    "name": "get_company_info",
                    "description": "Get company information from internet search",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "company_name": {
                                "type": "string",
                                "description": "Name of the company to search for"
                            }
                        },
                        "required": ["company_name"]
                    }
                }
            }
        ]
    }
    

## Agentic workflow

The workflow of our LLM-based agent is broken down into several steps:

  1. The agent receives a user query and analyzes its contents.

  2. It checks available tools that might help answer the query.

  3. When a tool is needed, the agent calls the corresponding function, waits for the output, and integrates it into its reasoning.

  4. Finally, it produces a coherent response that it returns to the user.




The corresponding and processing functions remain the same as in the previous part and are now part of a chat session involving the agent. Namely, `get_customer_details(customer_id)`, `search_company_info(company_name)`, and `process_tool_calls(tool_calls)` are called within the agent’s conversation flow.

## Using pre-defined tools

Since the tools are well-defined, they are included as a JSON file: [tools.json](<../../../../../_downloads/0d3a74d462b62a493f2ab4bae05ac63b/tools.json>). Place the file in a location accessible to code in Dataiku. An option is to use `</> > Libraries`. If you upload the file in a folder named `python`, you can access it in any Python code in the project.

Separating tools into a JSON file improves modularity and maintenance, allowing easy updates without altering the core of the application’s code. It also keeps tool definitions separate from the main application’s logic, making the code easier to understand and manage.

## Creating the agent

The agent is built around a function `create_chat_session` which sets up the LLM with the system prompt and tool definitions. You need to provide context to the LLM using a prompt that explains its role and how to use the tools. The code snippet below shows the essential pieces of the agent: system prompt definition, tool import, and conversation flow management. A function `create_chat_session` focuses on this setup, making sure the LLM is ready to use the appropriate tools.

Defining a chat session
    
    
    def create_chat_session():
        """Create a new chat session with tools and prompt"""
        chat = llm.new_completion()
        
        # Import tools from JSON file
        library = project.get_library()
        tools_file = library.get_file("/python/tools.json")
        tools_str = tools_file.read()
        tools_dict = json.loads(tools_str)
    
        chat.settings["tools"] = tools_dict["tools"]
        
        SYSTEM_PROMPT = """You are a customer information assistant. You can:
        1. Look up customer information in our database
        2. Search for additional information about companies online
    
        When asked about a customer:
        1. First look up their basic information
        2. If company information is requested, search for additional details
        3. Combine the information into a coherent, single-paragraph response"""
        
        chat.with_message(SYSTEM_PROMPT, role="system")
        return chat
    

## Accessing tools

During the next step, `process_query()` guides the conversation with the user. By structuring requests in a loop, the agent can make multiple calls to tools if the user’s question is complex. For example, if the question involves a customer’s detailed profile along with their company information, the agent can call one function for the customer’s data and another function for the company’s data before returning a final result.

How a single query is resolved
    
    
    def process_query(query):
        """Process a user query using the agent"""
        chat = create_chat_session()
    
        chat.with_message(query, role="user")
    
        conversation_log = []
        while True:
            response = chat.execute()
    
            if not response.tool_calls:
                # Final answer received
                chat.with_message(response.text, role="assistant")
                conversation_log.append(f"Final Answer: {response.text}")
                break
    
            # Handle tool calls
            chat.with_tool_calls(response.tool_calls, role="assistant")
            tool_call_result = process_tool_calls(response.tool_calls)
            chat.with_tool_output(tool_call_result, tool_call_id=response.tool_calls[0]["id"])
    
            # Log the step
            tool_name = response.tool_calls[0]["function"]["name"]
            tool_args = response.tool_calls[0]["function"]["arguments"]
            conversation_log.append(f"Tool: {tool_name}\nInput: {tool_args}\nResult: {tool_call_result}\n{'-'*50}")
        
        return "\n".join(conversation_log)
    

## Wrapping up

Here’s what a conversation with the agent could look like:

Example usage
    
    
    PROJECT = ""  # Dataiku project key goes here
    client = dataiku.api_client()
    project = client.get_project(PROJECT)
    LLM_ID = ""  # LLM ID for the LLM Mesh connection + model goes here
    llm = project.get_llm(LLM_ID)
    
    CONTENT = "Give me all the information you can find about customer with id fdouetteau"
    print(process_query(CONTENT))
    
    # Tool: get_customer_info
    # Input: {"customer_id":"fdouetteau"}
    # Result: The customer's name is "Florian Douetteau", holding the position "CEO" at the company named Dataiku
    # --------------------------------------------------
    # Tool: get_company_info
    # Input: {"company_name":"Dataiku"}
    # Result: Information found about Dataiku: Our Story. Dataiku is the leading platform for Everyday AI · 
    # Leadership and Team · Over 1000 people work hard to ensure the quality of our product and company as ...
    # --------------------------------------------------
    # Final Answer: The customer, Florian Douetteau, is the CEO of Dataiku, a leading platform for Everyday AI. 
    # Dataiku employs over 1,000 people dedicated to ensuring the quality of their products and services 
    # in the AI domain.
    

  * Now, you have an LLM-based agent that can handle multi-tool calling.

  * The system prompt and tool definitions provide a flexible and iterable way of guiding the LLM.

  * The chat session could be designed to make as many tool calls as needed to retrieve the required information or limit tool usage, according to the user’s needs.




In the [next part](<../webapps/index.html>), you’ll learn how to surface this agent in a browser-based web application.

Attention

The SQL query might be written differently depending on your SQL Engine.

[conversation.py](<../../../../../_downloads/ef89541c32e40b6d83f62b56ea443dd9/conversation.py>)

Longer code block with full script
    
    
    import dataiku
    import json
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    from duckduckgo_search import DDGS
    
    def get_customer_details(customer_id):
        """Get customer information from database"""
        dataset = dataiku.Dataset("pro_customers_sql")
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
        cid = Constant(str(customer_id))
        escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
        query_reader = executor.query_to_iter(
            f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
        for (name, job, company) in query_reader.iter_tuples():
            return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
        return f"No information can be found about the customer {customer_id}"
    
    def search_company_info(company_name):
        """Search for company information online"""
        with DDGS() as ddgs:
            results = list(ddgs.text(f"{company_name} (company)", max_results=1))
            if results:
                return f"Information found about {company_name}: {results[0]['body']}"
            return f"No information found about {company_name}"
    
    def process_tool_calls(tool_calls):
        """Process tool calls and return results"""
        tool_name = tool_calls[0]["function"]["name"]
        llm_args = json.loads(tool_calls[0]["function"]["arguments"])
        if tool_name == "get_customer_info":
            return get_customer_details(llm_args["customer_id"])
        elif tool_name == "get_company_info":
            return search_company_info(llm_args["company_name"])
    
    def create_chat_session():
        """Create a new chat session with tools and prompt"""
        chat = llm.new_completion()
        
        # Import tools from JSON file
        library = project.get_library()
        tools_file = library.get_file("/python/tools.json")
        tools_str = tools_file.read()
        tools_dict = json.loads(tools_str)
    
        chat.settings["tools"] = tools_dict["tools"]
        
        SYSTEM_PROMPT = """You are a customer information assistant. You can:
        1. Look up customer information in our database
        2. Search for additional information about companies online
    
        When asked about a customer:
        1. First look up their basic information
        2. If company information is requested, search for additional details
        3. Combine the information into a coherent, single-paragraph response"""
        
        chat.with_message(SYSTEM_PROMPT, role="system")
        return chat
    
    def process_query(query):
        """Process a user query using the agent"""
        chat = create_chat_session()
    
        chat.with_message(query, role="user")
    
        conversation_log = []
        while True:
            response = chat.execute()
    
            if not response.tool_calls:
                # Final answer received
                chat.with_message(response.text, role="assistant")
                conversation_log.append(f"Final Answer: {response.text}")
                break
    
            # Handle tool calls
            chat.with_tool_calls(response.tool_calls, role="assistant")
            tool_call_result = process_tool_calls(response.tool_calls)
            chat.with_tool_output(tool_call_result, tool_call_id=response.tool_calls[0]["id"])
    
            # Log the step
            tool_name = response.tool_calls[0]["function"]["name"]
            tool_args = response.tool_calls[0]["function"]["arguments"]
            conversation_log.append(f"Tool: {tool_name}\nInput: {tool_args}\nResult: {tool_call_result}\n{'-'*50}")
        
        return "\n".join(conversation_log)
    
    PROJECT = ""  # Dataiku project key goes here
    client = dataiku.api_client()
    project = client.get_project(PROJECT)
    LLM_ID = ""  # LLM ID for the LLM Mesh connection + model goes here
    llm = project.get_llm(LLM_ID)
    
    CONTENT = "Give me all the information you can find about customer with id fdouetteau"
    print(process_query(CONTENT))
    
    # Tool: get_customer_info
    # Input: {"customer_id":"fdouetteau"}
    # Result: The customer's name is "Florian Douetteau", holding the position "CEO" at the company named Dataiku
    # --------------------------------------------------
    # Tool: get_company_info
    # Input: {"company_name":"Dataiku"}
    # Result: Information found about Dataiku: Our Story. Dataiku is the leading platform for Everyday AI · 
    # Leadership and Team · Over 1000 people work hard to ensure the quality of our product and company as ...
    # --------------------------------------------------
    # Final Answer: The customer, Florian Douetteau, is the CEO of Dataiku, a leading platform for Everyday AI. 
    # Dataiku employs over 1,000 people dedicated to ensuring the quality of their products and services 
    # in the AI domain.

---

## [tutorials/genai/agents-and-tools/llm-agentic/index]

# LLM Mesh agentic applications  
  
This tutorial series demonstrates how to build agentic applications using the LLM Mesh in Dataiku. Through an example of building a customer information assistant, you’ll explore three parts of an agentic workflow:

  1. [Tools](<tools/index.html>) \- How to define and use tools with the LLM Mesh

  2. [Agents](<agents/index.html>) \- How to create an LLM-based agent that uses multiple tools

  3. [Webapps](<webapps/index.html>) \- How to build a web application with the agent




## Prerequisites

  * Dataiku >= 13.2

  * LLM Mesh connection to a provider that supports tool calls (tested with OpenAI GPT-4; you can find a compatible list [here](<../../../../concepts-and-examples/llm-mesh.html#llm-mesh-tool-calls>))

  * Project permissions for “Read project content” and “Write project content”

  * An SQL dataset `pro_customers_sql` (a CSV file can be downloaded [here](<../../../../_downloads/7bf56ee33dd4e8963d15ef9ed8227a0a/pro_customers.csv>) containing customer data

  * Python environment with the following packages
        
        duckduckgo_search # tested with 7.1.1

---

## [tutorials/genai/agents-and-tools/llm-agentic/tools/index]

# Defining and using tools with the LLM Mesh

## Introduction

Large Language Models (LLMs) are incredibly versatile in understanding and generating human-like text. Yet they still have notable limitations. When LLMs struggle with operations requiring precise mathematical calculations or updated data, external tools can complement them. Tools are predefined functions that an LLM can call during a conversation to solve specific problems, like performing calculations or querying databases.

In this first part of a [series of tutorials](<../index.html>), you’ll learn how to integrate tools into your workflows using the LLM Mesh, a centralized and governed interface for accessing models from multiple providers. You’ll define tools, implement tool calls, and see how the LLM interacts with these tools.

## Defining Tools

First, let’s define a tool in the context of an LLM. Tools are functions invoked during a conversation to perform a predefined task. Like functions, they accept specific parameters and return a response via a process outside the LLM workflow, which is then used as part of the conversation.

Tools can be defined using a JSON schema, specifying parameters and their types. This schema helps the LLM understand what kind of input the tool requires and what output it can expect. JSON schemas are also helpful by providing clear, human-readable descriptions and metadata.

In this tutorial, you will define two tools:

  1. Customer Information Tool - retrieves customer details from a database

  2. Company Information Tool - searches the internet for company information




JSON schema for tool definition
    
    
    tools = [
        {
            "type": "function",
            "function": {
                "name": "get_customer_info",
                "description": "Get customer details from the database given their ID",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "customer_id": {
                            "type": "string",
                            "description": "The unique identifier for the customer",
                        },
                    },
                    "required": ["customer_id"],
                },
            }
        },
        {
            "type": "function",
            "function": {
                "name": "get_company_info",
                "description": "Get company information from internet search",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "company_name": {
                            "type": "string",
                            "description": "Name of the company to search for",
                        },
                    },
                    "required": ["company_name"],
                },
            }
        }
    ]
    

## Adding the tool with an LLM Mesh workflow

You’ll create a client to interact with a specific LLM Mesh connection. Next, you’ll start a new chat, which is basically a completion task for the model based on user and tool inputs. To that chat, you’ll add tools for retrieving customer data and fetching company information.

As with any LLM workflow, providing context to the model is essential. This context defines the model’s role as well as what it can expect from the user, the tool and how to interpret the inputs it receives. You’ll specify that the LLM acts as a helpful assistant with access to customer and company information.

Chat settings and context
    
    
    chat = llm.new_completion()
    chat.settings["tools"] = tools
    
    CONTEXT = '''
      You are a helpful assistant with access to customer and company information.
      You have two tools available:
      - get_customer_info: retrieves customer details from our database
      - get_company_info: searches the internet for company information
      Use these tools to provide comprehensive responses about customers and their companies.
    '''
    
    CONTENT = 'Who are you and what is your purpose?'
    
    chat.with_message(CONTEXT, role="system")
    chat.with_message(CONTENT, role="user")
    
    response = chat.execute()
    response.text
    
    # I am an AI assistant designed to help you gather information about customers
    # and companies. My main functions include retrieving customer details from our
    # database and searching the internet for company information. If you have
    # specific questions or tasks related to customers or companies, feel free to
    # ask!
    
    chat.with_message(response.text, role="assistant")
    

## Chatting with the LLM to use the tool

Once the model shows it understands these questions, you can ask it to retrieve customer information. At this point, the LLM decides whether it needs to call the tool to help with the user’s request. Once it does, the model calls the tool as a response. The parameters needed to retrieve the information are extracted from the conversation, i.e., from the user’s statement.

Chatting with the LLM to extract parameters
    
    
    customer_id = "fdouetteau"
    CONTENT = f"The customer's id is {customer_id}"
    chat.with_message(CONTENT, role="user")
    response = chat.execute()
    
    tool_calls = response.tool_calls
    tool_calls
    
    # [{'type': 'function',
    #   'function': {'name': 'get_customer_info',
    #    'arguments': '{"customer_id":"fdouetteau"}'},
    #   'id': 'call_cQECgVOCgU7OLLb5mrBOZrg5'}]
    
    

Then, you’ll need to use the extracted request to call the tool function. Let’s implement a simple Python function (`process_tool_calls`) that calls other functions that retrieve customer information (`get_customer_info`) or search for the company online (`search_company_info`) based on the tool that was called and using the parameters provided. The `tool_call_result` is added back to the conversation.

Attention

The SQL query might be written differently depending on your SQL Engine.

Functions to retrieve customer information & search for company info
    
    
    def get_customer_details(customer_id):
        dataset = dataiku.Dataset("pro_customers_sql")
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
        cid = Constant(str(customer_id))
        escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
        query_reader = executor.query_to_iter(
            f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
        for (name, job, company) in query_reader.iter_tuples():
            return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
        return f"No information can be found about the customer {customer_id}"
    
    def search_company_info(company_name):
        """Search for company information online"""
        with DDGS() as ddgs:
            results = list(ddgs.text(f"{company_name} (company)", max_results=1))
            if results:
                return f"Information found about {company_name}: {results[0]['body']}"
            return f"No information found about {company_name}"
    
    def process_tool_calls(tool_calls):
        tool_name = tool_calls[0]["function"]["name"]
        llm_args = json.loads(tool_calls[0]["function"]["arguments"])
        if tool_name == "get_customer_info":
            return get_customer_details(llm_args["customer_id"])
        elif tool_name == "get_company_info":
            return search_company_info(llm_args["company_name"])
    

Each time the tool is called, the tool call, and the function output are logged in the conversation history. This helps the LLM record what was executed and integrate the tool workflow into the conversation.

Recording tool call and output
    
    
    chat.with_tool_calls(tool_calls, role="assistant")
    
    tool_call_result = process_tool_calls(tool_calls)
    
    chat.with_tool_output(tool_call_result, tool_call_id=tool_calls[0]["id"])
    

## Checking the results

To verify whether and how the LLM used the tools, you can look at the history of the chat. To access the entire history, you can use `chat.cq["messages"]`.

Let’s take a closer look at a possible outcome to see how tool calls are structured.

Printing out the chat history
    
    
    # Chat history
    from pprint import pprint
    pprint(chat.cq["messages"], indent=2, width=80)
    
    # [ { 'content': '\n'
    #                '  You are a helpful assistant with access to customer and '
    #                'company information.\n'
    #                '  You have two tools available:\n'
    #                '  - get_customer_info: retrieves customer details from our '
    #                'database\n'
    #                '  - get_company_info: searches the internet for company '
    #                'information\n'
    #                '  Use these tools to provide comprehensive responses about '
    #                'customers and their companies.\n',
    #     'role': 'system'},
    #   {'content': 'Who are you and what is your purpose?', 'role': 'user'},
    #   { 'content': 'I am an AI assistant designed to help you retrieve information '
    #                'about customers and companies. My purpose is to provide '
    #                'comprehensive and accurate responses based on the data '
    #                'available in our database and from online resources. Whether '
    #                "you need customer details or company information, I'm here to "
    #                'assist you. How can I help you today?',
    #     'role': 'assistant'},
    #   {'content': "The customer's id is fdouetteau", 'role': 'user'},
    #   { 'role': 'assistant',
    #     'toolCalls': [ { 'function': { 'arguments': '{"customer_id":"fdouetteau"}',
    #                                    'name': 'get_customer_info'},
    #                      'id': 'call_OoXImpZSMNYEqe5w1QT8eFUy',
    #                      'type': 'function'}]},
    #   { 'role': 'tool',
    #     'toolOutputs': [ { 'callId': 'call_OoXImpZSMNYEqe5w1QT8eFUy',
    #                        'output': 'The customer\'s name is "Florian Douetteau", '
    #                                  'holding the position "CEO" at the company '
    #                                  'named Dataiku'}]},
    #   { 'content': 'Find more information about the company from a search.',
    #     'role': 'user'},
    #   { 'role': 'assistant',
    #     'toolCalls': [ { 'function': { 'arguments': '{"company_name":"Dataiku"}',
    #                                    'name': 'get_company_info'},
    #                      'id': 'call_9KerL9juzQMJG3s8FN31yOdo',
    #                      'type': 'function'}]},
    #   { 'role': 'tool',
    #     'toolOutputs': [ { 'callId': 'call_9KerL9juzQMJG3s8FN31yOdo',
    #                        'output': 'Information found about Dataiku: Dataiku is '
    #                                  'the leading platform for Everyday AI ... '
    #                                  "We're pioneering “Everyday AI,” helping "
    #                                  'everyone in an organization — from technical '
    #                                  'teams to business leaders\xa0...'}]}]
    

## Wrapping Up

This tutorial, teaches you how to use tool calls via the LLM Mesh. By defining and implementing tools, the LLM seamlessly integrates additional functionality like querying databases or performing computations. The LLM Mesh also manages context and message history.

When building robust, extensible workflows, this approach might come in handy. Plus, with the LLM Mesh, you can worry less about manual message tracking or complex integrations, especially when handling multiple models.

The [next tutorial](<../agents/index.html>) in this series covers how to create an LLM-based agent that uses the multiple tools defined in this tutorial.

[chat.py](<../../../../../_downloads/95dbf59796aa6e516489a23669d19e6b/chat.py>)

Longer code block with full script
    
    
    import dataiku
    import json
    from dataiku import SQLExecutor2
    from duckduckgo_search import DDGS
    from dataiku.sql import Constant, toSQL, Dialects
    
    PROJECT = "" # Dataiku project key goes here
    client = dataiku.api_client()
    project = client.get_project(PROJECT)
    LLM_ID = "" # LLM ID for the LLM Mesh connection + model goes here
    llm = project.get_llm(LLM_ID)
    chat = llm.new_completion()
    
    tools = [
        {
            "type": "function",
            "function": {
                "name": "get_customer_info",
                "description": "Get customer details from the database given their ID",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "customer_id": {
                            "type": "string",
                            "description": "The unique identifier for the customer",
                        },
                    },
                    "required": ["customer_id"],
                },
            }
        },
        {
            "type": "function",
            "function": {
                "name": "get_company_info",
                "description": "Get company information from internet search",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "company_name": {
                            "type": "string",
                            "description": "Name of the company to search for",
                        },
                    },
                    "required": ["company_name"],
                },
            }
        }
    ]
    
    chat.settings["tools"] = tools
    
    CONTEXT = '''
      You are a helpful assistant with access to customer and company information.
      You have two tools available:
      - get_customer_info: retrieves customer details from our database
      - get_company_info: searches the internet for company information
      Use these tools to provide comprehensive responses about customers and their companies.
    '''
    
    CONTENT = 'Who are you and what is your purpose?'
    
    chat.with_message(CONTEXT, role="system")
    chat.with_message(CONTENT, role="user")
    
    response = chat.execute()
    response.text
    
    # I am an AI assistant designed to help you gather information about customers
    # and companies. My main functions include retrieving customer details from our
    # database and searching the internet for company information. If you have
    # specific questions or tasks related to customers or companies, feel free to
    # ask!
    
    chat.with_message(response.text, role="assistant")
    
    customer_id = "fdouetteau"
    CONTENT = f"The customer's id is {customer_id}"
    chat.with_message(CONTENT, role="user")
    response = chat.execute()
    
    tool_calls = response.tool_calls
    tool_calls
    
    # [{'type': 'function',
    #   'function': {'name': 'get_customer_info',
    #    'arguments': '{"customer_id":"fdouetteau"}'},
    #   'id': 'call_cQECgVOCgU7OLLb5mrBOZrg5'}]
    
    chat.with_tool_calls(tool_calls, role="assistant")
    
    def get_customer_details(customer_id):
        dataset = dataiku.Dataset("pro_customers_sql")
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
        cid = Constant(str(customer_id))
        escaped_cid = toSQL(cid, dialect=Dialects.POSTGRES)  # Replace by your DB
        query_reader = executor.query_to_iter(
            f"""SELECT "name", "job", "company" FROM {table_name} WHERE "id" = {escaped_cid}""")
        for (name, job, company) in query_reader.iter_tuples():
            return f"The customer's name is \"{name}\", holding the position \"{job}\" at the company named {company}"
        return f"No information can be found about the customer {customer_id}"
    
    def search_company_info(company_name):
        """Search for company information online"""
        with DDGS() as ddgs:
            results = list(ddgs.text(f"{company_name} (company)", max_results=1))
            if results:
                return f"Information found about {company_name}: {results[0]['body']}"
            return f"No information found about {company_name}"
    
    def process_tool_calls(tool_calls):
        tool_name = tool_calls[0]["function"]["name"]
        llm_args = json.loads(tool_calls[0]["function"]["arguments"])
        if tool_name == "get_customer_info":
            return get_customer_details(llm_args["customer_id"])
        elif tool_name == "get_company_info":
            return search_company_info(llm_args["company_name"])
    
    tool_call_result = process_tool_calls(tool_calls)
    
    chat.with_tool_output(tool_call_result, tool_call_id=tool_calls[0]["id"])
    
    # Continue the conversation
    CONTENT = "Find more information about the company from a search."
    
    chat.with_message(CONTENT, role="user")
    response = chat.execute()
    
    tool_calls = response.tool_calls
    tool_calls
    
    # [{'type': 'function',
    #   'function': {'name': 'get_company_info',
    #    'arguments': '{"company_name":"Dataiku"}'},
    #   'id': 'call_4lg3yspLrMdJvISnL2aBtzfn'}]
    
    chat.with_tool_calls(tool_calls, role="assistant")
    
    tool_call_result = process_tool_calls(tool_calls)
    
    chat.with_tool_output(tool_call_result, tool_call_id=tool_calls[0]["id"])
    
    # Chat history
    from pprint import pprint
    pprint(chat.cq["messages"], indent=2, width=80)
    
    # [ { 'content': '\n'
    #                '  You are a helpful assistant with access to customer and '
    #                'company information.\n'
    #                '  You have two tools available:\n'
    #                '  - get_customer_info: retrieves customer details from our '
    #                'database\n'
    #                '  - get_company_info: searches the internet for company '
    #                'information\n'
    #                '  Use these tools to provide comprehensive responses about '
    #                'customers and their companies.\n',
    #     'role': 'system'},
    #   {'content': 'Who are you and what is your purpose?', 'role': 'user'},
    #   { 'content': 'I am an AI assistant designed to help you retrieve information '
    #                'about customers and companies. My purpose is to provide '
    #                'comprehensive and accurate responses based on the data '
    #                'available in our database and from online resources. Whether '
    #                "you need customer details or company information, I'm here to "
    #                'assist you. How can I help you today?',
    #     'role': 'assistant'},
    #   {'content': "The customer's id is fdouetteau", 'role': 'user'},
    #   { 'role': 'assistant',
    #     'toolCalls': [ { 'function': { 'arguments': '{"customer_id":"fdouetteau"}',
    #                                    'name': 'get_customer_info'},
    #                      'id': 'call_OoXImpZSMNYEqe5w1QT8eFUy',
    #                      'type': 'function'}]},
    #   { 'role': 'tool',
    #     'toolOutputs': [ { 'callId': 'call_OoXImpZSMNYEqe5w1QT8eFUy',
    #                        'output': 'The customer\'s name is "Florian Douetteau", '
    #                                  'holding the position "CEO" at the company '
    #                                  'named Dataiku'}]},
    #   { 'content': 'Find more information about the company from a search.',
    #     'role': 'user'},
    #   { 'role': 'assistant',
    #     'toolCalls': [ { 'function': { 'arguments': '{"company_name":"Dataiku"}',
    #                                    'name': 'get_company_info'},
    #                      'id': 'call_9KerL9juzQMJG3s8FN31yOdo',
    #                      'type': 'function'}]},
    #   { 'role': 'tool',
    #     'toolOutputs': [ { 'callId': 'call_9KerL9juzQMJG3s8FN31yOdo',
    #                        'output': 'Information found about Dataiku: Dataiku is '
    #                                  'the leading platform for Everyday AI ... '
    #                                  "We're pioneering “Everyday AI,” helping "
    #                                  'everyone in an organization — from technical '
    #                                  'teams to business leaders\xa0...'}]}]

---

## [tutorials/genai/agents-and-tools/llm-agentic/webapps/index]

# Building a Web Application with the agent

In the previous parts of this series ([here](<../tools/index.html>) and [here](<../agents/index.html>)), you saw how to define tools and create an LLM-based agent capable of answering queries by calling those tools. This part demonstrates how to build an interactive web interface so end-users can interact with this functionality in a browser. Different frameworks can be used, as detailed below.

## Creating a webapp

First, you’ll set up the webapp framework, alongside creating the necessary infrastructure within Dataiku. Choose your preferred framework and follow the necessary steps.

DashGradioVoila

Dash applications can be created as Code webapps with the following steps:

  * Create a new webapp by clicking on **< /> > Webapps**

  * Click the **+New webapp** , choose the **Code webapp** , then click on the **Dash** button, choose the **An empty Dash app** option, and choose a meaningful name

  * In the **Code env** option of the **Settings** tabs, select the Python code environment with the packages defined in the [prerequisites](<../index.html#llm-agentic-prereqs>) for this tutorial series

  * You’ll need to add the following packages specific to Dash to the code env
        
        dash # tested with 2.18.2
          dash-bootstrap-components # tested with 1.6.0
        




Gradio applications run in Code Studios in Dataiku. To create a new application, follow the steps outlined in [Gradio: your first web application](<../../../../webapps/gradio/first-webapp/index.html>). In short, the steps are:

  * Create a Code Studio template that includes a code env with the required packages defined in the [prerequisites](<../index.html#llm-agentic-prereqs>) for this tutorial series

  * You’ll need to add the following packages specific to Gradio to the code env
        
        gradio # tested with 3.48.0
        

  * Create a Code Studio based on the template

  * Add the full script provided at the end of this tutorial to the Code Studio in the `gradio/app.py` file

  * _If you have access to the Code Studio’s workspace via a VSCode or Jupyter Lab block, then you can see the full path of the file at` /home/dataiku/workspace/code_studio-versioned/gradio/app.py`_




Voila applications run in Code Studios in Dataiku. To create a new application, follow the steps outlined in [Voilà: your first web application](<../../../../webapps/voila/first-webapp/index.html>). In short, the steps are:

  * Create a Code Studio template with JupyterLab Server and Voilà blocks.

  * When adding the Voilà block, include the required packages (`duckduckgo_search==7.1.1`) defined in the [prerequisites](<../index.html#llm-agentic-prereqs>) in the `Additional Python modules` option.

  * Create a Code Studio based on the template.

  * Using the JupyterLab interface, add the full script provided at the end of this tutorial to the Code Studio in the `code_studio-versioned/visio/app.ipynb` file.




Note

The predefined tools need to be present in a location accessible via code. You can place the file (available [here](<../../../../../_downloads/0d3a74d462b62a493f2ab4bae05ac63b/tools.json>) for download) in `</> > Libraries`. You can find detailed instructions in the [previous tutorial](<../agents/index.html#llm-agentic-predefined-tools>), plus why it is useful to follow this approach.

For similar reasons of modularity, helper functions common among the application scripts are also placed in a separate file. Specifically, the functions `create_chat_session`, `get_customer_details`, `search_company_info` and `process_tool_calls` are included in the `utils.py` (also available for [download](<../../../../../_downloads/3bd814cb0bb8e0d047754900744ed173/utils.py>)). It needs to be placed in the same location as `tools.json`, following the same steps.

## Passing on the task to the agent

After choosing our webapp framework, the crucial step is implementing the LLM agent functionality. It follows a consistent pattern across frameworks. Regardless of which one, the chat session is defined the same way.

Similar to the agent in [Part 2](<../agents/index.html>), the chat session is created by calling the `create_chat_session()` function. It sets up an LLM via the LLM Mesh with the system prompt.

The application sends the information obtained about the customer to the agent. You’ll see how each framework collects this information below. A loop is created to process the tool calls and responses, until no more tool calls are needed. The agent then returns the final response.

## Calling the agent

The next step is connecting the user interface to the agent’s functionality. Here’s how each framework runs the agent.

DashGradioVoila

Dash wires everything up with callbacks to process user queries. Connect the button to a callback function that invokes the agent with the `@app.callback` decorator. The `update_output()` function allows the user to enter the customer ID and click the button to trigger the function with the agent. The agent then processes the input via a chat session and returns the final response.

Calling the agent
    
    
    @app.callback(
        [Output("result", "value"), Output("chat-state", "data")],
        Input("search", "n_clicks"),
        [State("customer_id", "value"), State("chat-state", "data")],
        prevent_initial_call=True,
        running=[(Output("auto-toast", "is_open"), True, False),
                 (Output("search", "disabled"), True, False)]
    )
    
    def update_output(n_clicks, customer_id, chat_state):
        """Callback function that handles agent interactions"""
        if not customer_id:
            return no_update, no_update
        
        # Create new chat session
        chat = create_chat_session(llm, project)
    

Gradio’s chat interface also uses a similar function that processes the current message and all previous conversation turns. The `chat_with_agent()` function that calls the agent has two parameters:

  * message: current user message

  * history: list of (user, assistant) message tuples




The user inputs and conversation history are forwarded to the `chat_with_agent()` function. The agent then processes the input via a chat session and returns the final response.

Calling the agent
    
    
    def chat_with_agent(message, history):
        """Chat function that handles agent interactions"""
        chat = create_chat_session(llm, project)
        
        # Add history to chat context
        for user_msg, assistant_msg in history:
            chat.with_message(user_msg, role="user")
            chat.with_message(assistant_msg, role="assistant")
        
        chat.with_message(message, role="user")
    

In Voila, you’ll define a function `process_agent_response()` to deliver queries to the LLM via a chat session. It has two parameters: `chat`, which is the chat session, and `query`, which is the user’s message. The agent processes the user’s query via the chat session.

Calling the agent
    
    
    def process_agent_response(chat, query):
        """Process the agent's response and handle any tool calls"""
        chat.with_message(query, role="user")
    

## Creating the layout

Finally, to provide a UI for this agent functionality, you’ll build an interface with components that allows users to interact with it. Each framework offers its own approach.

The layout gathers user inputs (e.g. message with customer ID) and passes it to the agent functions for each framework. The agent then returns the result to be displayed in the UI.

DashGradioVoila

Create a Dash layout that constructs an application like Figure 1, consisting of an input Textbox for entering a customer ID and an output Textarea.

The callback function described above takes the user’s requests from the input Textbox and passes the entered customer ID to `create_chat_session()`, rendering the final agent response in the output Textarea.

Dash layout
    
    
    # Dash app layout
    app.layout = html.Div([
        dbc.Row([html.H2("Using LLM Mesh with an agent in Dash")]),
        dbc.Row(dbc.Label("Please enter the ID of the customer:")),
        dbc.Row([
            dbc.Col(dbc.Input(id="customer_id", placeholder="Customer Id"), width=10),
            dbc.Col(dbc.Button("Search", id="search", color="primary"), width="auto")
        ], justify="between"),
        dbc.Row([dbc.Col(dbc.Textarea(id="result", style={"min-height": "500px"}), width=12)]),
        dbc.Toast(
            [html.P("Searching for information about the customer", className="mb-0"),
             dbc.Spinner(color="primary")],
            id="auto-toast",
            header="Agent working",
            icon="primary",
            is_open=False,
            style={"position": "fixed", "top": "50%", "left": "50%", "transform": "translate(-50%, -50%)"},
        ),
        dcc.Store(id="chat-state"),
        dcc.Store(id="step", data={"current_step": 0}),
    ], className="container-fluid mt-3")
    

Figure 1: LLM Agentic – webapp.

Unlike Dash’s component-based approach, Gradio offers a more conversation-focused interface. Using its `ChatInterface` class, create a layout like Figure 1 that includes:

  * A chat message input field for queries

  * The conversation history including the agent’s replies

  * Optional features like example prompts




Gradio layout
    
    
    app = gr.ChatInterface(
        fn=chat_with_agent,
        title="Customer Information Assistant",
        description="Ask me about customers using their ID ...",
        examples=["The id is fdouetteau", 
                "Find out about id wcoyote",
                 "who is customer tcook"]
    )
    
    app.launch(server_port=7860, root_path=browser_path)
    

Figure 1: LLM Agentic – webapp.

Voila uses JupyterLab’s `ipywidgets` (imported here as `widgets`) to provide the UI for user interactions. The `query_input` provides a textbox to collect the user query and a `button` to trigger `on_button_click()`. That function calls `process_agent_response()` with the query and displays the returned message in the `result` widget.

Voila layout
    
    
    # Create widgets
    label = widgets.Label(value="Enter your query about a customer")
    query_input = widgets.Text(
        placeholder="Tell me about customer fdouetteau",
        continuous_update=False,
        layout=widgets.Layout(width='50%')
    )
    result = widgets.HTML(value="")
    button = widgets.Button(description="Ask")
    
    # Create the chat session
    chat = create_chat_session(llm, project)
    
    def on_button_click(b):
        """Handle button click event"""
        query = query_input.value
        if query:
            try:
                response = process_agent_response(chat, query)
                result.value = f"<div style='white-space: pre-wrap;'>{response}</div>"
            except Exception as e:
                result.value = f"<div style='color: red'>Error: {str(e)}</div>"
                
    button.on_click(on_button_click)
    
    # Layout
    display(widgets.VBox([
        widgets.HBox([label]),
        widgets.HBox([query_input, button]),
        widgets.HBox([result])
    ], layout=widgets.Layout(padding='20px')))
    

Figure 1: LLM Agentic – webapp.

## Conclusion

You now have an application that:

  1. Uses an LLM-based agent to process queries

  2. Imports predefined tools to complement LLM capabilities

  3. Provides a user-friendly web interface




You could enhance this interface by adding a history of previous searches or creating a more detailed and cleaner results display. This example provides a foundation for building more complex LLM-based browser applications, leveraging tool calls and webapp interfaces.

DashGradioVoila

[Dash application code](<../../../../../_downloads/f765e707266cdcd059762c7b0db72761/app-dash.py>)

Longer code block with full script
    
    
    import dataiku
    from dash import html, dcc, no_update, set_props
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input, Output, State
    import json
    from utils import get_customer_details, search_company_info, process_tool_calls, create_chat_session
    
    dbc_css = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"
    app.config.external_stylesheets = [dbc.themes.SUPERHERO, dbc_css]
    
    # LLM setup
    LLM_ID = ""  # LLM ID for the LLM Mesh connection + model goes here
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID)
    
    # Dash app layout
    app.layout = html.Div([
        dbc.Row([html.H2("Using LLM Mesh with an agent in Dash")]),
        dbc.Row(dbc.Label("Please enter the ID of the customer:")),
        dbc.Row([
            dbc.Col(dbc.Input(id="customer_id", placeholder="Customer Id"), width=10),
            dbc.Col(dbc.Button("Search", id="search", color="primary"), width="auto")
        ], justify="between"),
        dbc.Row([dbc.Col(dbc.Textarea(id="result", style={"min-height": "500px"}), width=12)]),
        dbc.Toast(
            [html.P("Searching for information about the customer", className="mb-0"),
             dbc.Spinner(color="primary")],
            id="auto-toast",
            header="Agent working",
            icon="primary",
            is_open=False,
            style={"position": "fixed", "top": "50%", "left": "50%", "transform": "translate(-50%, -50%)"},
        ),
        dcc.Store(id="chat-state"),
        dcc.Store(id="step", data={"current_step": 0}),
    ], className="container-fluid mt-3")
    
    @app.callback(
        [Output("result", "value"), Output("chat-state", "data")],
        Input("search", "n_clicks"),
        [State("customer_id", "value"), State("chat-state", "data")],
        prevent_initial_call=True,
        running=[(Output("auto-toast", "is_open"), True, False),
                 (Output("search", "disabled"), True, False)]
    )
    
    def update_output(n_clicks, customer_id, chat_state):
        """Callback function that handles agent interactions"""
        if not customer_id:
            return no_update, no_update
        
        # Create new chat session
        chat = create_chat_session(llm, project)
        
        # Start conversation about customer
        content = f"Tell me about the customer with ID {customer_id}"
        chat.with_message(content, role="user")
        
        conversation_log = []
        while True:
            response = chat.execute()
            
            if not response.tool_calls:
                # Final answer received
                chat.with_message(response.text, role="assistant")
                conversation_log.append(f"Final Answer: {response.text}")
                break
                
            # Handle tool calls
            chat.with_tool_calls(response.tool_calls, role="assistant")
            tool_call_result = process_tool_calls(response.tool_calls)
            chat.with_tool_output(tool_call_result, tool_call_id=response.tool_calls[0]["id"])
            
            # Log the step
            tool_name = response.tool_calls[0]["function"]["name"]
            tool_args = response.tool_calls[0]["function"]["arguments"]
            conversation_log.append(f"Tool: {tool_name}\nInput: {tool_args}\nResult: {tool_call_result}\n{'-'*50}")
        
        return "\n".join(conversation_log), {"messages": chat.cq["messages"]}
    

[Gradio application code](<../../../../../_downloads/047fb7d19ea51a2f0b2c309420f09c83/app-gradio.py>)

Longer code block with full script
    
    
    import dataiku
    import gradio as gr
    import os
    import re
    import json
    from utils import get_customer_details, search_company_info, process_tool_calls, create_chat_session
    
    # LLM setup
    LLM_ID = ""  # LLM ID for the LLM Mesh connection + model goes here
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID)
    
    def chat_with_agent(message, history):
        """Chat function that handles agent interactions"""
        chat = create_chat_session(llm, project)
        
        # Add history to chat context
        for user_msg, assistant_msg in history:
            chat.with_message(user_msg, role="user")
            chat.with_message(assistant_msg, role="assistant")
        
        chat.with_message(message, role="user")
        
        while True:
            response = chat.execute()
            
            if not response.tool_calls:
                # Final answer received
                chat.with_message(response.text, role="assistant")
                return response.text
                
            # Handle tool calls
            chat.with_tool_calls(response.tool_calls, role="assistant")
            tool_name = response.tool_calls[0]["function"]["name"]
            tool_args = response.tool_calls[0]["function"]["arguments"]
            
            # Process tool call and get result
            tool_call_result = process_tool_calls(response.tool_calls)
            chat.with_tool_output(tool_call_result, tool_call_id=response.tool_calls[0]["id"])
        
    
    # Gradio interface setup
    browser_path = os.getenv("DKU_CODE_STUDIO_BROWSER_PATH_7860")
    env_var_pattern = re.compile(r'(\${(.*)})')
    env_vars = env_var_pattern.findall(browser_path)
    for env_var in env_vars:
        browser_path = browser_path.replace(env_var[0], os.getenv(env_var[1], ''))
    
    # Create Gradio chat interface
    app = gr.ChatInterface(
        fn=chat_with_agent,
        title="Customer Information Assistant",
        description="Ask me about customers using their ID ...",
        examples=["The id is fdouetteau", 
                "Find out about id wcoyote",
                 "who is customer tcook"]
    )
    
    app.launch(server_port=7860, root_path=browser_path)
    

[Voila application notebook](<../../../../../_downloads/dfc40063a191a28a47c2dbf80ab0c9af/app.ipynb>)

Longer code block with full script
    
    
    import dataiku
    import ipywidgets as widgets
    import json
    import os
    from utils import get_customer_details, search_company_info, process_tool_calls, create_chat_session
    
    # LLM setup
    LLM_ID = ""  # LLM ID for the LLM Mesh connection + model goes here
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID)
    
    def process_agent_response(chat, query):
        """Process the agent's response and handle any tool calls"""
        chat.with_message(query, role="user")
        
        while True:
            response = chat.execute()
            
            if not response.tool_calls:
                # Final answer received
                chat.with_message(response.text, role="assistant")
                chat = create_chat_session(llm, project) # refresh chat
                return response.text
                
            # Handle tool calls
            chat.with_tool_calls(response.tool_calls, role="assistant")
            tool_name = response.tool_calls[0]["function"]["name"]
            tool_args = response.tool_calls[0]["function"]["arguments"]
            
            # Process tool call and get result
            tool_call_result = process_tool_calls(response.tool_calls)
            chat.with_tool_output(tool_call_result, tool_call_id=response.tool_calls[0]["id"])
    
    
    # Create widgets
    label = widgets.Label(value="Enter your query about a customer")
    query_input = widgets.Text(
        placeholder="Tell me about customer fdouetteau",
        continuous_update=False,
        layout=widgets.Layout(width='50%')
    )
    result = widgets.HTML(value="")
    button = widgets.Button(description="Ask")
    
    # Create the chat session
    chat = create_chat_session(llm, project)
    
    def on_button_click(b):
        """Handle button click event"""
        query = query_input.value
        if query:
            try:
                response = process_agent_response(chat, query)
                result.value = f"<div style='white-space: pre-wrap;'>{response}</div>"
            except Exception as e:
                result.value = f"<div style='color: red'>Error: {str(e)}</div>"
                
    button.on_click(on_button_click)
    
    # Layout
    display(widgets.VBox([
        widgets.HBox([label]),
        widgets.HBox([query_input, button]),
        widgets.HBox([result])
    ], layout=widgets.Layout(padding='20px')))

---

## [tutorials/genai/agents-and-tools/mcp/index]

# Model Context Protocol (MCP)  
  
This tutorial series demonstrates how to build custom & 3rd party MCP Servers using Code studios and Webapps in Dataiku:

  1. [Building your MCP Server in Dataiku](<my-mcp/index.html>)

---

## [tutorials/genai/agents-and-tools/mcp/my-mcp/index]

# Building your MCP Server in Dataiku

Model Context Protocol (MCP) shows significant promise as a foundational standard for the future of agentic AI applications. It is designed to make AI systems more dynamic, modular, and composable.

## Prerequisites

  * Dataiku >= 14.0

  * Create Code Studio templates - permission

  * Python >= 3.10

  * A code Environment (named `mcp_py310)`with the following packages:
        
        mcp #tested with 1.9.4
        




## Introduction

In this tutorial, you will publish Agents built in Dataiku as MCP Tools within an MCP Server. A similar process can be used to publish any Dataiku functionality as MCP Tools. You will use Dataiku Code Studios to publish the MCP server as a headless webapp in Dataiku.

To start, we need an Agent. You can pick any agent you have or build one using the [Creating and using a Code Agent](<../../code-agent/index.html>) or [Creating a custom agent](<../../../../plugins/agent/generality/index.html>) tutorials. This tutorial uses the Agent built using the tutorial [Creating and using a Code Agent](<../../code-agent/index.html>), which exposes two tools: one to search the Table, which contains a mapping of Company Names and their CEOs, and another tool that uses `duckduckgo_search` to provide company information. Name this agent in your project `company_info`

## Converting the agent into an Agent Tool

In the Dataiku Project, select **Agent Tools** in the **GenAI** menu, create a new tool of type LLM Mesh Query, select the Agent (`company_info`), and provide a meaningful full name, such as `get_company_info`. In the tool config, select the agent (`company_info`) and provide detailed information about the agent using the **Purpose** and **Additional Description** configuration. Figure 1 represents the agent configuration.
    
    
    # Purpose
    This tool provides information about companies. 
    
    # Additional description
    It can take a company name or a CEO's name as input and get information associated with it.
    

Fig. 1 - Configured LLM Mesh Query Tool

## Generating the MCP Server Code

Now we have the Agent ready as an Agent Tool. In this step, we will create an MCP Server File using Python and the MCP Python SDK to set up a server. We will add an MCP tool that can call `get_company_info` Agent Tool. To access the Agent tool using Python, you will need the Tool ID. The tool ID of the Agent Tool can be accessed from the tool browser URL or using Python, as demonstrated in Code 1.

Code 1 – Get your inline Python Tool identifier
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    project.list_agent_tools()
    

Go to Libraries, and under the `python` folder, let’s create a folder `mcp`. Under that, create a file using a name such as `company_info_mcp.py`.

Paste the code provided in Code 2, replacing the Tool ID with your Tool ID.

Code 2 – Python script of the MCP Server
    
    
    # Import required libraries
    import dataiku
    from mcp.server.fastmcp import FastMCP
    
    # Define all the Variables
    MCP_SERVER_NAME="Company Info"
    MCP_SERVER_INSTRUCTIONS="This server provides a tool which can query the web to get company info"
    HOST="0.0.0.0"
    PORT=58000
    
    TOOL_ID="" ## Fill with your agent's ID
    
    # MCP Object Initialization
    mcp = FastMCP(name=MCP_SERVER_NAME, 
                  instructions=MCP_SERVER_INSTRUCTIONS, 
                  host=HOST, 
                  port=PORT
        )
    
    # MCP Tool which connects to Agent Tool 
    @mcp.tool()
    async def get_company_info(query: str) -> str:
        """  
        This tool provides information about companies.
        It can take a company name or a CEO's name as input and get information associated with it.
        Args:
            query: User query
        
        Returns:
            Generated response as a string.
        """
        
        client = dataiku.api_client()
        tool = client.get_default_project().get_agent_tool(TOOL_ID)
        output = tool.run({"question": query})
        return output['output']['response']
    
    # Run the server
    if __name__ == "__main__":
        mcp.run(transport='streamable-http')
    

Fig. 2 - MCP Server Code File

## Building the Code Studio Template

We will use Dataiku Code Studios to host the MCP Server as a headless webapp. Go to the Code Studios tabs in the Administration menu, click the **Create code studio template** button, and choose an appropriate name for the template. We will need the MCP server file and the code environment with the MCP SDK within the Code Studio Container to run the server.

### Selecting a code environment

Go to the **Definition** Tab. Click the **Add a block** button and choose the **Add Code Environment** block type. This block allows you to add a specific code environment that is usable in the Code Studio. For the **Code environment** block, choose the code environment you previously built for this MCP server, as shown in Figure 3.

Fig. 3 - Configured Code Environment Block

### Creating a helper function

To start the MCP Server, you will rely on a helper function. In the resources tab, click the **Add button (located on top left)** , select **Create file…** , and choose a relevant filename, `run_mcp_server_1.sh` (for example). Paste the code provided in Code 3.

Code 3 – Shell script to start the MCP server (`run_mcp_server_1.sh`)
    
    
    #!/bin/sh
    
    source /opt/dataiku/python-code-envs/mcp_py310/bin/activate
    cd /home/dataiku/workspace/project-lib-versioned/python/mcp
    python company_info_mcp.py
    

This script contains three parts:

  * The first line of this command activates the code environment you previously defined.

  * The second line positions the shell in the directory where your MCP server file is.

  * The third line runs the MCP server.




Fig 4 - Shell script code under Code Studios Resources Tab

### Creating an entry point to run the MCP Server

Back to the Definition tab, click the **Add a block** button, and choose the **Add an Entrypoint** block type. This block serves the MCP Server, meaning it starts the server and exposes its port.

  * Use the previously defined helper function by copying it into the code studio block (**Scripts** part) and activating it (**Entrypoint** part).

    * Entrypoint: `/home/dataiku/run_mcp_server_1.sh`

    * Click **Add scripts to code studio**.

      * Source file: `${template.resources}/run_mcp_server_1.sh`

      * Target file: `run_mcp_server_1.sh`

  * Tick **Launch for Webapps** and **Expose port**.

    * **Launch for Webapps** is required to launch the server as an accessible API inside and outside Dataiku.

    * **Expose port** – Enter the Port used in the MCP Server File. (i.e. 58000 if you have not modified the code we provided)

  * It would help if you also chose a meaningful name (_MCP Server 1_ , for example) for the **Expose port label** field.

  * Then, choose the **Exposed port** you have defined in the MCP Server Code.

  * **Proxied subpath** – any path added here will be suffixed to the server URL.

  * Save and Build the Code Studio.




Figure 5 shows a recap of all those steps.

Fig. 5 - Configured Entry Point Block for the MCP Server

## Launching the Webapp

Go to **Project** > **Code** > **Code Studios** and create a new Code Studio Instance. Once created (no need to start the Code Studio), publish it as a webapp. Under the webapp settings (Edit), enable **API Access** and **Authentication**. Click **Save and View Webapp.**

Fig. 6 - Webapp configuration with API Access and Authentication Enabled

Since this is a headless webapp with no UI, the view tab of the App may show “Not found” message. Once the backend is up, the MCP Server will be accessible in the URL format  
`https://<DATAIKU_HOST>/webapps/<PROJECT_KEY>/<WEBAPP_ID>/mcp`
    
    
    For example- https://dataiku-dummy-host.io/webapps/MCPSERVERS/QwFomH6/mcp
    

Note

The `WEBAPP_ID` is the first seven characters (before the underscore) in the webapp URL. For example, if the webapp URL in Dataiku is `/projects/HEADLESS/webapps/kUDF1mQ_api/view`, the `WEBAPP_ID` is `kUDF1mQ` and the `PROJECT_KEY` is `HEADLESS`.

## Testing using MCP Inspector

You will set up MCP Inspector locally on your Desktop to test the remote accessibility of the Dataiku-hosted MCP server. To test the MCP Server, you first need to create a Dataiku API Key for authentication. Go to your Dataiku **Profile & Settings** and then **API Keys** Tab. Generate a new key.

Use the command below in your terminal to start the MCP inspector. It will automatically open a Tab in the browser (or you can copy and paste the printed URL in the browser). You can find detailed instructions on setting up MCP Inspector [here](<https://modelcontextprotocol.io/docs/tools/inspector>).

Code 4 - Shell command to start MCP Inspector
    
    
    npx @modelcontextprotocol/inspector 
    

In the MCP Inspector Interface, select **Transport—Streamable HTTP** , provide the server URL. Under **Bearer Token** enter `Bearer <your-dataiku-apikey>`. Replace `<your-dataiku-apikey>` with your **Dataiku API key** Then click Connect, as shown in Figure 7.

Fig. 7 - Configured MCP Inspector

Go to the **Tools Tab** , and click **List Tools**. You should see the Agent published as MCP Server tool. Run the tool to test it.

Fig. 8 - Listed MCP Server Tools of the MCP Server configured in Dataiku

## Wrapping Up

Congratulations, you have successfully configured your first MCP Server in Dataiku. Similar directions can be followed to configure any third-party MCP Server in Dataiku. You can also access remote MCP servers in Dataiku using Python Recipe or Code Agent.

This tutorial also demonstrates how to make an MCP server support HTTP Transport. Some MCP servers support HTTP Transport by default, which further simplifies the process of setting it up in Dataiku.

---

## [tutorials/genai/agents-and-tools/multi-agent/index]

# Multi agents: sequential workflow  
  
After creating agents, for example, through the [Creating and using a Code Agent](<../code-agent/index.html>) or [Creating a custom agent](<../../../plugins/agent/generality/index.html>) tutorials, you can use them and have various daily usages. You will need several agents to work together to handle more complex use cases.

## Prerequisites

  * Dataiku >= 13.4

  * An OpenAI connection

  * Python >= 3.9




## Introduction

When solving a problem using multiple agents, keeping dedicated agents for well-delimited tasks is useful. You will then articulate a multi-agent system to tackle the global topic. You will implement a first agent to call the different agents with the appropriate prompt and parameters according to a sequential workflow. This tutorial will elaborate on a multi-agent system that will produce the HTML code needed for your website from a product description. It will use two agents. The first will extract the key features, target audience, and unique selling points. The second one will format that information with the proper HTML code.

## The Concept Extractor Agent

The Concept Extractor is in charge of the description analysis from a marketing perspective. It extracts a list of key features from a product’s textual description. It will also estimate the target audience for such a product. Lastly, the description analysis will provide a list of potential selling points that would be helpful.

To create this agent, follow the [Creating and using a Code Agent](<../code-agent/index.html>) tutorial and use Code 1 below.

Code 1: Concept Extractor Agent code
    
    
    import dataiku
    from dataiku.llm.python import BaseLLM
    
    LLM_ID = "REPLACE_WITH_YOUR_LLM_ID"
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            llm = dataiku.api_client().get_default_project().get_llm(LLM_ID)
    
            user_query = query["messages"][0]["content"]
    
            concept_extractor = """You are working in a marketing team.
            Your role is to read a product description and find the key features, target audience, and unique selling points.
            Start with the product name mentioned as PRODUCT"""
    
            extract = llm.new_completion()
            extract.settings["temperature"] = 0.1
            extract.with_message(message=concept_extractor, role='system')
            extract.with_message(message=user_query, role='user')
            resp = extract.execute()
    
    
            return {"text": resp.text}
    

You can test your Concept Extractor Agent in the **Quick test** tabs by entering the following test query:

You can use the following suggestion as a test query:
    
    
    {
         "messages": [
            {
               "role": "user",
               "content": "Smart Water Bottle designed to help you stay hydrated throughout the day. ability to track water intake. sync with your smartphone. LED reminders. eco-friendly material. long-lasting battery life"
            }
         ],
         "context": {}
    }
    

Depending on the model you chose, the result will looks like the following:
    
    
    **Product Name:** Smart Water Bottle
    
    **Key Features:**
    1. Tracks water intake
    2. Syncs with smartphone
    3. LED reminders for hydration
    4. Made from eco-friendly materials
    5. Long-lasting battery life
    
    **Target Audience:**
    - Health-conscious individuals
    - Tech-savvy users
    - Environmentally conscious consumers
    - Busy professionals and students
    - Fitness enthusiasts
    
    **Unique Selling Points:**
    - Integration with smartphone for easy tracking and reminders
    - Eco-friendly construction appealing to sustainable living advocates
    - LED reminders to ensure consistent hydration throughout the day
    - Durable battery life reducing the need for frequent charging
    

## The Web Writer Agent

The Web Writer Agent is in charge of formatting the elements analyzed by the concept extractor. It will use a predefined HTML format enforced in the system prompt with a detailed example. This system prompt is the part you need to adapt and refine to have a reliable answer from the LLM you chose to use. Once again, you can follow the [Creating and using a Code Agent](<../code-agent/index.html>) tutorial and use Code 2 below.

Code 2: Web Writer Agent code
    
    
    import dataiku
    from dataiku.llm.python import BaseLLM
    
    LLM_ID = "REPLACE_WITH_YOUR_LLM_ID"
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            llm = dataiku.api_client().get_default_project().get_llm(LLM_ID)
    
            user_query = query["messages"][0]["content"]
    
            web_writer = """You are working in a web writer team.
            Your role is to read a description containing a list with the key features, target audience, and unique selling points.
            You then output a HTML code to list all categories and its sub elements as a list.
            For example, if you receive the following description:
            "
                **PRODUCT:** Smart Water Bottle
    
                **Key Features:**
                1. Ability to track water intake
                2. Syncs with your smartphone
                3. LED reminders
                4. Made from eco-friendly material
                5. Long-lasting battery life
    
                **Target Audience:**
                - Health-conscious individuals
                - Tech-savvy users
                - People with busy lifestyles
                - Environmentally conscious consumers
                - Fitness enthusiasts
    
                **Unique Selling Points:**
                - Integration with smartphone for easy tracking and monitoring
                - Eco-friendly materials appeal to environmentally conscious buyers
                - LED reminders provide a convenient way to ensure regular hydration
                - Long-lasting battery life reduces the need for frequent charging
            "
            You will output the following HTML code:
            "
            <section>
                <h2>Smart Water Bottle</h2>
    
                <h3>Key Features:</h3>
                <ul>
                    <li>Ability to track water intake</li>
                    <li>Syncs with your smartphone</li>
                    <li>LED reminders</li>
                    <li>Made from eco-friendly material</li>
                    <li>Long-lasting battery life</li>
                </ul>
    
                <h3>Target Audience:</h3>
                <ul>
                    <li>Health-conscious individuals</li>
                    <li>Tech-savvy users</li>
                    <li>People with busy lifestyles</li>
                    <li>Environmentally conscious consumers</li>
                    <li>Fitness enthusiasts</li>
                </ul>
    
                <h3>Unique Selling Points:</h3>
                <ul>
                    <li>Integration with smartphone for easy tracking and monitoring</li>
                    <li>Eco-friendly materials appeal to environmentally conscious buyers</li>
                    <li>LED reminders provide a convenient way to ensure regular hydration</li>
                    <li>Long-lasting battery life reduces the need for frequent charging</li>
                </ul>
            </section>
            "
            Do not add anything before and after the section markup tag.
            """
    
            write = llm.new_completion()
            write.settings["temperature"] = 0.1
            write.with_message(message=web_writer, role='system')
            write.with_message(message=user_query, role='user')
            resp = write.execute()
    
    
            return {"text": resp.text}
    

You can test your Web Writer Agent in the **Quick test** tabs. You can use the following suggestion as a test query:
    
    
    {
       "messages": [
          {
             "role": "user",
             "content": "**PRODUCT:** Smart Water Bottle\n\n**Key Features:**\n1. Ability to track water intake\n2. Syncs with your smartphone\n3. LED reminders\n4. Made from eco-friendly material\n5. Long-lasting battery life\n\n**Target Audience:**\n- Health-conscious individuals\n- Tech-savvy users\n- People with busy lifestyles\n- Environmentally conscious consumers\n- Fitness enthusiasts\n\n**Unique Selling Points:**\n- Integration with smartphone for easy tracking and monitoring\n- Eco-friendly materials appeal to environmentally conscious buyers\n- LED reminders provide a convenient way to ensure regular hydration\n- Long-lasting battery life reduces the need for frequent charging"
          }
       ],
       "context": {}
    }
    

Your result will looks like the following:
    
    
    <section>
        <h2>Smart Water Bottle</h2>
    
        <h3>Key Features:</h3>
        <ul>
            <li>Ability to track water intake</li>
            <li>Syncs with your smartphone</li>
            <li>LED reminders</li>
            <li>Made from eco-friendly material</li>
            <li>Long-lasting battery life</li>
        </ul>
    
        <h3>Target Audience:</h3>
        <ul>
            <li>Health-conscious individuals</li>
            <li>Tech-savvy users</li>
            <li>People with busy lifestyles</li>
            <li>Environmentally conscious consumers</li>
            <li>Fitness enthusiasts</li>
        </ul>
    
        <h3>Unique Selling Points:</h3>
        <ul>
            <li>Integration with smartphone for easy tracking and monitoring</li>
            <li>Eco-friendly materials appeal to environmentally conscious buyers</li>
            <li>LED reminders provide a convenient way to ensure regular hydration</li>
            <li>Long-lasting battery life reduces the need for frequent charging</li>
        </ul>
    </section>
    

## The Query Agent

The Query Agent will describe a product as defined in the input prompt and handle the call between the two agents. Code 3 shows how to get a handle on each agent.

Code 3: Query agent code
    
    
    import dataiku
    from dataiku.llm.python import BaseLLM
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process_stream(self, query, settings, trace):
            pass
    
        def process(self, query, settings, trace):
            prompt = query["messages"][0]["content"]
    
            project = dataiku.api_client().get_default_project()
    
            # call concept extractor
            EXTRACTOR_AGENT_ID = "<YOUR EXTRACTOR AGENT ID>"
            agent_extractor = project.get_llm(EXTRACTOR_AGENT_ID)
    
            completion = agent_extractor.new_completion()
            completion.with_message(prompt)
            resp = completion.execute()
            extractor_answer = resp.text
    
            # call web writer
            WEB_AGENT_ID = "<YOUR WEB WRITER AGENT ID>"
            agent_webwriter = project.get_llm(WEB_AGENT_ID)
    
            completion = agent_webwriter.new_completion()
            completion.with_message(extractor_answer)
            resp = completion.execute()
            webwriter_answer = resp.text
    
            return {"text": webwriter_answer}
    

This agent will first call the concept extractor agent to obtain a list of the key features, identify the potential target audience, and develop a list of selling points for this product. It will then call the web writer agent. This one will take the concept list as input and provide a piece of HTML code representing that data.

To test the whole sequence of multi agent calls, you can input the test query we used for the Concept Extractor Agent:
    
    
    {
         "messages": [
            {
               "role": "user",
               "content": "Smart Water Bottle designed to help you stay hydrated throughout the day. ability to track water intake. sync with your smartphone. LED reminders. eco-friendly material. long-lasting battery life"
            }
         ],
         "context": {}
    }
    

Your result will looks like the result from the Web Writer Agent test:
    
    
    <section>
        <h2>Smart Water Bottle</h2>
    
        <h3>Key Features:</h3>
        <ul>
            <li>Ability to track water intake</li>
            <li>Syncs with your smartphone</li>
            <li>LED reminders</li>
            <li>Made from eco-friendly material</li>
            <li>Long-lasting battery life</li>
        </ul>
    
        <h3>Target Audience:</h3>
        <ul>
            <li>Health-conscious individuals</li>
            <li>Tech-savvy users</li>
            <li>People with busy lifestyles</li>
            <li>Environmentally conscious consumers</li>
            <li>Fitness enthusiasts</li>
        </ul>
    
        <h3>Unique Selling Points:</h3>
        <ul>
            <li>Integration with smartphone for easy tracking and monitoring</li>
            <li>Eco-friendly materials appeal to environmentally conscious buyers</li>
            <li>LED reminders provide a convenient way to ensure regular hydration</li>
            <li>Long-lasting battery life reduces the need for frequent charging</li>
        </ul>
    </section>
    

## Wrapping up

Congratulations! You now have a sequential workflow to define a multi-agent system. Once you have well-delimited Agents and Tools, you can build different workflows to suit your needs. You may implement a system in which the queries to each agent are done in parallel and then collected and correctly assembled to answer the user’s question.

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

## [tutorials/genai/agents-and-tools/traces/index]

# Adding traces to your Agent

Once you have created an agent, for example, after following the [Creating and using a Code Agent](<../code-agent/index.html>) tutorial or the [Creating a custom agent](<../../../plugins/agent/generality/index.html>) tutorial, it is essential to trace its behavior to understand better what happened and to ease debugging.

## Prerequisites

  * Dataiku >= 13.4

  * An OpenAI connection

  * Python >= 3.10




Additionally, if you want to start from one of the tutorials mentioned, you will need the corresponding prerequisites, as described in each tutorial.

## Introduction

Adding traces to your Agent’s code can help you understand the path your Agent has taken. It will be a tool to diagnose the potential issues that may occur. It’s also a way to analyze each step’s performance, helping to identify the steps to focus your efforts on and allowing performance improvements.

## Adding traces to your Code Agent

At the end of the [Creating and using a Code Agent](<../code-agent/index.html>) tutorial, you end up with the following code. Let’s see how the traces can be tailored to suit your needs.

code-custom.py

Code 1: Using Custom Tools
    
    
    from langchain_core.tools import tool
    from langchain_core.messages import ToolMessage
    import dataiku
    from dataiku.llm.python import BaseLLM
    
    project = dataiku.api_client().get_default_project()
    
    OPENAI_CONNECTION_NAME = "REPLACE_WITH_YOUR_CONNECTION_NAME"  # example: "openAI"
    
    
    def find_tool(name: str):
        for tool in project.list_agent_tools():
            if tool["name"] == name:
                return project.get_agent_tool(tool['id'])
        return None
    
    
    # If you know the tool IDs, you can use them directly.
    get_customer = find_tool("Get Customer Info").as_langchain_structured_tool()
    get_company = find_tool("Get Company Info").as_langchain_structured_tool()
    
    tools = [get_customer, get_company]
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
            project = dataiku.api_client().get_default_project()
            llm = project.get_llm(f"openai:{OPENAI_CONNECTION_NAME}:gpt-5-mini").as_langchain_chat_model(completion_settings=settings)
            llm_with_tools = llm.bind_tools(tools)
    
            messages = [m for m in query["messages"] if m.get("content")]
            iterations = 0
            while True:
                iterations += 1
                if iterations < 10:
                    with trace.subspan("Invoke LLM with tools") as llm_invoke_span:
                        llm_response = llm_with_tools.invoke(messages)
                else:
                    with trace.subspan("Invoke LLM without tools") as llm_invoke_span:
                        llm_response = llm.invoke(messages)
    
                if len(llm_response.tool_calls) == 0:
                    return {"text": llm_response.content}
    
                with llm_invoke_span.subspan("Call the tools") as tools_subspan:
                    messages.append(llm_response)
                    for tool_call in llm_response.tool_calls:
                        with tools_subspan.subspan("Call a tool") as tool_subspan:
                            tool_subspan.attributes["tool_name"] = tool_call["name"]
                            tool_subspan.attributes["tool_args"] = tool_call["args"]
                            if tool_call["name"] == get_customer.name:
                                tool_output = get_customer(tool_call["args"])
                            elif tool_call["name"] == get_company.name:
                                tool_output = get_company(tool_call["args"])
                            else:
                                raise ValueError("unknown tool: " + tool_call["name"])
                        messages.append(ToolMessage(tool_call_id=tool_call["id"], content=tool_output))
    

The workflow of traces starts within the `process` function in the `MyLLM` class.
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        def process(self, query, settings, trace):
    

The `trace` object will then be used to add a `subspan` to the generated traces.
    
    
    with trace.subspan("Invoke LLM with tools") as subspan:
        ai_msg = llm_with_tools.invoke(messages)
    
    tool_messages = []
    
    with trace.subspan("Call the tools") as tools_subspan:
    

You can organize the traces by naming each step you want to identify in your workflow.

You can also enrich a `span` with specific data.
    
    
    with trace.subspan("Call a tool") as tool_subspan:
        tool_subspan.attributes["tool_name"] = tool_call["name"]
        tool_subspan.attributes["tool_args"] = tool_call["args"]
    

The global structure of the span is as described below:
    
    
    {
      "type": "span",
      "begin": "",
      "end": "",
      "duration": ,
      "name": "",
      "children": [],
      "attributes": {},
      "inputs": {},
      "outputs": {}
    }
    

You can fill out this dict with all the metadata required for your specific needs.

  * The fields `begin` and `end` are timestamps completed by the `duration` field.

  * The `name` field is the one specified when calling `trace.subspan`.

  * The `children` field represents the array of subspan for this span.

  * The attributes field is the one we modified to trace the name and arguments of a tool call.

  * The last files are the `inputs` and `outputs` used in the case of LLM calls.




Last, every LLM Mesh call has a trace, which you can append to a span. You can build your own trace hierarchy, as shown below:
    
    
    with trace.subspan("Calling a LLM") as subspan:
    
       llm = dataiku.api_client().get_default_project().get_llm(<your LLM id>)
       resp = llm.new_completion().with_message("this is a prompt").execute()
    
       subspan.append_trace(resp.trace)
    

## LangChain-compatible traces

For the specific case of a LangChain-based agent, you can easily write a LangChain-compatible trace in your Dataiku trace object.

Instantiate the `LangchainToDKUTracer` class and use it in each LangChain runnable you wish to track.

Let’s illustrate this with an example from the [Creating a custom agent](<../../../plugins/agent/generality/index.html>) tutorial.

You end up with the following code.

agent.py
    
    
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
    

The tracing workflow starts with the `aprocess_stream` function in the `MyLLM` class.
    
    
    class MyLLM(BaseLLM):
        def __init__(self):
            pass
    
        async def aprocess_stream(self, query, settings, trace):
    

You use the `trace` object to create a `LangchainToDKUTracer` object. You can then register this tracer object on all callbacks in the configuration of the `AgentExecutor` asynchronous events.
    
    
    async def aprocess_stream(self, query, settings, trace):
        prompt = query["messages"][0]["content"]
    
        tracer = LangchainToDKUTracer(dku_trace=trace)
        agent_executor = AgentExecutor(agent=self.agent, tools=tools)
    
        async for event in agent_executor.astream_events({"input": prompt}, version="v2",
                                                         config={"callbacks": [tracer]}):
    

This will collect all the traces generated by the different calls made by your LangChain-based Agent.

## Wrapping up

With this tutorial, you now have the tools at hand to architect the traces you need:

  * Create and organize your own trace with `trace.subspan`

  * Build your trace hierarchy with `span.append_trace`

  * For LangChain agents, easily log the execution with a LangChain-compatible tracer, using `LangchainToDKUTracer`




See also

More information on how Dataiku handles tracing is available in the [Tracing](<https://doc.dataiku.com/dss/latest/agents/tracing.html> "\(in Dataiku DSS v14\)") chapter of the documentation.

---

## [tutorials/genai/agents-and-tools/visual-agent/index]

# Leveraging a custom tool in a Visual Agent

In this tutorial, you will learn how to build a Visual Agent that uses tools. Those tools can be default ones (provided by Dataiku) or custom ones (provided by plugins). This tutorial will use the custom tools defined in the [Creating a custom tool](<../../../plugins/custom-tools/generality/index.html>) tutorial. However, if you haven’t followed this tutorial but already have tools to use, you can adapt this tutorial to meet your requirements.

## Prerequisites

  * Dataiku >= 13.4

  * Tools already added in Dataiku. Those tools should be visible in the **Agent Tools** menu from the **GenAI** menu.




## Creating a Visual Agent

To create a Visual Agent, go to the **Flow** , click the **Add item** button, select the **Generative AI** menu, click **Visual Agent** , enter a name, and click the **OK** button. Alternatively, you can select the **Agents & GenAI Models** item in the **GenAI** menu, click the **New Agent** button, and select the **Visual Agent** option. You should land on a page similar to the one shown in Figure 1.

Fig. 1: Visual Agent created.

This page shows the different versions of the agent’s life. As this is a new agent, only one version is available (**v1**). Click on the **v1** label to see its definition. Fill in the information on the **Config** tabs, as shown in Figure 2. For example, you could have entered for:

  * **Additional prompt** :
        
        Give all the professional information you can about the customer with ID: {customerID}.
        Also, include information about the company if you can.
        

  * the tool **Get Customer Info** :
        
        Use this tool to retrieve information about a customer with its ID.
        The expected output is a sentence where you will have the customer's name, position, and company.
        

  * the tool **Get Company Info** :
        
        Use this tool when you need to retrieve information about a company.
        The input is the company's name, and the output is a small company recap.
        




Fig. 2: Visual Agent’s configuration.

## Testing the Agent

To test the agent, click the **Quick test** tabs, fill in the information based on the prompt you have defined before, and then click the **Run** button. The result of this agent execution is shown in Figure 3.

Fig. 3: Testing the Visual Agent.

---

## [tutorials/genai/index]

# Generative AI

This section covers:

  * “Agents and Tools for Generative AI” — guides on building LLM-powered agents (e.g., Code Agents, Visual Agents), creating custom tools, and using the LLM Mesh.

  * Architecting GenAI-powered components in Dataiku (agents, tools, workflows)

  * Integrating LLMs with external systems and tooling

  * Building robust, tool-enabled AI workflows using Dataiku’s GenAI ecosystem.

  * Other core GenAI topics include retrieval-augmented generation (RAG), prompt design, monitoring, inline tools, etc.




## Agents and Tools

  * [Creating an Inline Python Tool](<agents-and-tools/inline-python-tool/index.html>)

  * [Creating a custom tool](<../plugins/custom-tools/generality/index.html>)

  * [Leveraging a custom tool in a Visual Agent](<agents-and-tools/visual-agent/index.html>)

  * [Creating and using a Code Agent](<agents-and-tools/code-agent/index.html>)

  * [Integrating an agent framework](<agents-and-tools/integrating-agent-framework/index.html>)

  * [Creating a custom agent](<../plugins/agent/generality/index.html>)

  * [Multi agents: sequential workflow](<agents-and-tools/multi-agent/index.html>)

  * [Building and using an agent with Dataiku’s LLM Mesh and Langchain](<agents-and-tools/agent/index.html>)

  * [Defining and using tools with the LLM Mesh](<agents-and-tools/llm-agentic/tools/index.html>)

  * [Creating an LLM-based agent that uses multiple tools](<agents-and-tools/llm-agentic/agents/index.html>)

  * [Building a Web Application with the agent](<agents-and-tools/llm-agentic/webapps/index.html>)

  * [Connecting to an external Vector Store](<agents-and-tools/external-vector/index.html>)

  * [Building Auto Prompt Strategies with DSPy in Dataiku](<agents-and-tools/auto-prompt/index.html>)

  * [Using the LLM Mesh to parse and output JSON objects](<agents-and-tools/json-output/index.html>)

  * [Adding traces to your Agent](<agents-and-tools/traces/index.html>)

  * [Building your MCP Server in Dataiku](<agents-and-tools/mcp/my-mcp/index.html>)




## Multi-modal capabilities

### Images and text

  * [Image generation using the LLM Mesh](<multimodal/images-and-text/images-generation/index.html>)

  * [Mixing text and images: Images labeling with the LLM Mesh](<multimodal/images-and-text/images-captioning/index.html>)




## Natural Language Processing & Generation

  * [Programmatic RAG with Dataiku’s LLM Mesh and Langchain](<nlp/llm-mesh-rag/index.html>)

  * [RAG: Improving your Knowledge Bank retrieval](<nlp/improve-kb-rag/index.html>)

  * [Creating and using a Knowledge Bank](<nlp/create-knowledge-bank/index.html>)

  * [Using LLM Mesh to benchmark zero-shot classification models](<nlp/llm-mesh-zero-shot/index.html>)

  * [Zero-shot text classification with the LLM Mesh](<nlp/llm-zero-shot-clf/index.html>)

  * [Few-shot classification with the LLM Mesh](<nlp/llm-mesh-few-shot-clf/index.html>)

  * [Using OpenAI-compatible API calls via the LLM Mesh](<nlp/openaiXmesh/index.html>)

  * [Customizing a Text Embedding Model for RAG Applications](<nlp/fine-tuning-embedding-model/index.html>)




## Webapps

### Headless API

  * [API Endpoint on LLM](<../webapps/common/api-llm/index.html>)




### Dash

  * [GPT-powered web app assistant](<../webapps/dash/chatGPT-web-assistant/index.html>)

  * [LLM based agent](<../webapps/dash/llm-based-agent/index.html>)




### Gradio

  * [First application](<../webapps/gradio/first-webapp/index.html>)

  * [LLM based agent](<../webapps/gradio/agent/index.html>)




## Voilà

  * [First application](<../webapps/voila/first-webapp/index.html>)

  * [LLM based agent](<../webapps/voila/agent/index.html>)

---

## [tutorials/genai/llm/alignment/index]

# Advanced model alignment: RLHF, RLAIF, and RLVR in Dataiku

The process of creating Large Language Models (LLMs) involves several distinct stages. While the pre-training phase creates a model that can predict the next token, it is the alignment phase that truly refines how it generates tokens to better suit its role.

While Supervised Fine-Tuning (SFT) is usually used to teach a model to follow instructions, alignment ensures the model’s behavior matches human preferences, follows specific reasoning paths, or adheres to objective truth. These techniques transition a general next-token predictor into a helpful assistant.

In this tutorial, we will explore advanced model alignment in Dataiku, with three primary methods used in the industry today: Reinforcement Learning from Human Feedback (RLHF), AI Feedback (RLAIF), and Verifiable Rewards (RLVR).

## Prerequisites

To follow along with the code examples in this tutorial, you will need:

  * Dataiku >= 14.1

  * Python >= 3.10

  * A code environment with containerized GPU support (container runtime addition `GPU support for Torch 2`) and the following packages:
        
        torch
        transformers
        datasets
        trl
        peft
        bitsandbytes
        accelerate
        

  * An LLM Mesh connection to HuggingFace.




## Reinforcement Learning from Human Feedback (RLHF)

RLHF is the industry standard for aligning models to human preferences. It uses preference-based optimization to train a model on what a human considers a “good” versus “bad” response.

Dataiku provides a complete environment for RLHF. For data collection, users can leverage AgentHub and native labeling features to create preference datasets directly from human feedback.

Typically, this data is formatted into three columns:

  * **Prompt** : The initial instruction or question.

  * **Chosen** : The response preferred by the human labeler.

  * **Rejected** : The less favorable response.




### RLHF in Dataiku

Once the data is collected, you can align your model using the `trl` (Transformer Reinforcement Learning) library and the Dataiku API. Using the Direct Preference Optimization (DPO) algorithm is often preferred over traditional Proximal Policy Optimization (PPO) as it is more stable and computationally efficient. The `trl` provides the `DPOTrainer` for that.

Note

For a complete code example of implementing DPO in Dataiku, please refer to our dedicated [Fine-Tuning Code Samples](<../../../../concepts-and-examples/llm-mesh.html#concept-and-examples-llm-mesh-fine-tuning>) section in the Developer Guide.

Once fine-tuned, use the [`create_finetuned_llm_version()`](<../../../../api-reference/python/ml.html#dataiku.Model.create_finetuned_llm_version> "dataiku.Model.create_finetuned_llm_version") method with your HuggingFace connection name as input. This saves the aligned model as a Fine-tuned LLM Saved Model version, inheriting from the connection’s configuration.

## Reinforcement Learning from AI Feedback (RLAIF)

While RLHF is highly effective, gathering human preference data is time-consuming and expensive. RLAIF solves this bottleneck by leveraging a “judge” LLM to generate synthetic feedback, drastically reducing the need for manual human labeling.

### Orchestrating RLAIF in Dataiku

Dataiku enables RLAIF by utilizing the LLM Mesh to orchestrate critique and revision workflows.

  1. **Synthetic Generation** : Use a Visual Prompt recipe to generate multiple candidate responses from your target model (here, it is the `` model from the HuggingFace connection).

  2. **AI Judging** : Use a more powerful, aligned model (e.g., GPT-5 or Claude 4 Sonnet) via the LLM Mesh to evaluate and rank the candidates based on specific criteria (e.g., helpfulness, lack of toxicity, etc).

  3. **Alignment** : The resulting dataset is then used to align the target model via DPO, exactly as you would with RLHF.




## Reinforcement Learning with Verifiable Rewards (RLVR)

For complex reasoning tasks, such as solving mathematical equations, writing functional code, or applying strict formatting rules, preference ranking is insufficient. These tasks require objective verification.

The RLVR method allows users to define strict, hard-coded reward functions to score a model, making it the right alignment method for complex & verifiable tasks. Instead of a human or an AI _assessing_ if a response is good, a rule-based logic system (like a code compiler or a math verifier) objectively scores the output.

### Recommended Dataset: GSM8k

To test RLVR, we recommend the [**`openai/gsm8k`** dataset](<https://huggingface.co/datasets/openai/gsm8k>), a standard benchmark for mathematical reasoning available on the HuggingFace Hub. It contains thousands of grade-school math problems.

If you look at the raw GSM8k dataset, the `answer` column contains both the step-by-step reasoning and the final numerical answer, separated by `####` (e.g., `...Natalia sold 48+24 = 72 clips. #### 72`).

Counterintuitively, for RLVR, **we actually want to ignore the human reasoning text**.

  * In traditional Supervised Fine-Tuning (SFT), you force the model to mimic the exact reasoning steps provided in the dataset. You teach the model _what_ to think.

  * In RLVR, you only reward the final, verifiable outcome. You let the model figure out _how_ to think.




By only rewarding the final correct answer (the number after the `####`), the model is free to explore different logical paths during training. To ensure the model still takes time to reason, we apply a secondary reward function that strictly enforces formatting, requiring the model to use `<think>...</think>` tags before outputting its final `<answer>...</answer>`.

Assuming you have synced the raw GSM8k data into a Dataiku dataset called `gsm8k_raw`, here is the Python snippet to automatically format the data (strip out the human reasoning, inject system instructions) and split it. We will create a Python recipe that outputs three new Dataiku datasets: `gsm8k_train` (85%), `gsm8k_val` (10%), and `gsm8k_test` (5%).

Code 1: data_formatting.py
    
    
    import dataiku
    from datasets import Dataset
    import pandas as pd
    
    # 1. Load raw GSM8k data from Dataiku
    raw_df = dataiku.Dataset("gsm8k_raw").get_dataframe()
    raw_dataset = Dataset.from_pandas(raw_df)
    
    SYSTEM_PROMPT = """
    Respond in the following format:
    <think>
    ...
    </think>
    <answer>
    ...
    </answer>
    """
    
    def prepare_gsm8k(example):
        """
        Extracts the final numeric answer (ignoring human reasoning), 
        removes commas for clean string matching, and injects the system prompt.
        """
        # Extract the number and remove any commas (e.g., "36,000" -> "36000")
        raw_gt = str(example["answer"].split("####")[-1].strip())
    
        # Removing commas from some groundtruth values, because an LLM would answer without comma and be penalized in the reward function.
        clean_gt = raw_gt.replace(",", "")  
        
        prompt = [
            {"role": "system", "content": SYSTEM_PROMPT}, 
            {"role": "user", "content": example["question"]}
        ]
        return {"prompt": prompt, "ground_truth": clean_gt}
    
    # 2. Apply the formatting to the dataset
    prepared_dataset = raw_dataset.map(prepare_gsm8k)
    
    # 3. Split the data into Train (85%), Validation (10%), and Test (5%)
    # First split: 85% train, 15% temp
    split_1 = prepared_dataset.train_test_split(test_size=0.15, seed=42)
    train_dataset = split_1['train']
    
    # Second split: Divide the 15% temp into 2/3 (10% overall) and 1/3 (5% overall)
    split_2 = split_1['test'].train_test_split(test_size=0.33, seed=42)
    val_dataset = split_2['train']
    test_dataset = split_2['test']
    
    # 4. Write back to Dataiku Datasets
    dataiku.Dataset("gsm8k_train").write_with_schema(pd.DataFrame(train_dataset))
    dataiku.Dataset("gsm8k_val").write_with_schema(pd.DataFrame(val_dataset))
    dataiku.Dataset("gsm8k_test").write_with_schema(pd.DataFrame(test_dataset))
    

After this transformation, your train_dataset holds the exact structure required by the TRL library for verifiable reasoning:

prompt | ground_truth  
---|---  
[{“role”: “system”, “content”: “Respond in the following format…”}, {“role”: “user”, “content”: “Natalia sold clips to 48 of her friends…”}] | 72  
  
### Implementing RLVR with GRPO in Dataiku

To train models on complex reasoning chains, we can use the Group Relative Policy Optimization (GRPO) algorithm via the `trl` library and Dataiku API. This algorithm was introduced in 2024 ([Shao et al., 2024](<https://arxiv.org/abs/2402.03300>)), and later popularized by the DeepSeek-R1 reasoning models ([DeepSeek-AI, Guo et al., 2025](<https://arxiv.org/abs/2501.12948>)).

Below is an example of how to implement an RLVR workflow in a Dataiku Python recipe. The inputs are `gsm8k_train` and `gsm8k_val`, we pass both datasets to the trainer so we can track evaluation metrics during the run. The output is a Fine-tuned LLM Saved Model named `rlvr_aligned_model`.

We’ll break this down into three steps: preparing the model, defining the rewards, and executing the training loop. A fourth section simply explains how to visually test the alignment using a Prompt recipe.

#### 1\. Model & tokenizer preparation

First, we load our base model. Here, we are using `Qwen/Qwen2.5-1.5B-Instruct`, a small model, to illustrate how it works. We are also using 4-bit quantization to fit comfortably on a single GPU.

Code 2: model_preparation.py
    
    
    import dataiku
    from datasets import Dataset
    import torch
    from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig
    
    model_name = "Qwen/Qwen2.5-1.5B-Instruct"
    connection_name = "a_huggingface_connection_name"
    
    # Load Datasets from the Flow
    train_dataset = Dataset.from_pandas(dataiku.Dataset("gsm8k_train").get_dataframe())
    val_dataset = Dataset.from_pandas(dataiku.Dataset("gsm8k_val").get_dataframe())
    
    # The output Saved Model
    saved_model = dataiku.Model("my_model_id")
    
    quantization_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.float16,
    )
    
    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        device_map="auto",
        quantization_config=quantization_config,
        use_cache=False 
    )
    
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    tokenizer.pad_token = tokenizer.eos_token
    

#### 2\. Defining verifiable rewards

Next, we define our rule-based logic. We create two functions: one that checks if the extracted answer exactly matches our `ground_truth`, and another that checks if the model successfully used the XML tags.

Code 3: verifiable_rewards.py
    
    
    import re
    
    def extract_xml_answer(text: str) -> str:
        """Helper to extract the answer from XML tags"""
        answer = text.split("<answer>")[-1]
        answer = answer.split("</answer>")[0]
        return answer.strip()
    
    def correctness_reward_func(prompts, completions, ground_truth, **kwargs) -> list[float]:
        """Awards 2.0 points if the generated answer exactly matches the ground truth."""
        responses = [completion[0]['content'] for completion in completions]
        extracted_responses = [extract_xml_answer(r) for r in responses]
        return [2.0 if str(r) == str(gt) else 0.0 for r, gt in zip(extracted_responses, ground_truth)]
    
    def format_reward_func(completions, **kwargs) -> list[float]:
        """Awards 1.0 point if the model strictly follows the <think> and <answer> XML format."""
        pattern = r"^<think>\n.*?\n</think>\n<answer>\n.*?\n</answer>\n$"
        responses = [completion[0]['content'] for completion in completions]
        return [1.0 if re.match(pattern, r, re.DOTALL) else 0.0 for r in responses]
    

#### 3\. Fine-tuning the model

Finally, we pass our dataset, model, and reward functions to the `GRPOTrainer`. Using the Dataiku API, we ensure the newly aligned model version is seamlessly saved back to the project, as a new Saved Model version.

Code 4: model_finetuning.py
    
    
    from trl import GRPOTrainer, GRPOConfig
    from peft import LoraConfig
    
    # Create a fine-tuned LLM version using the Dataiku API
    with saved_model.create_finetuned_llm_version(connection_name) as finetuned_llm_version:
    
        peft_config = LoraConfig(
            r=16,
            lora_alpha=32,
            lora_dropout=0.05,
            target_modules="all-linear",
            task_type="CAUSAL_LM",
        )
        
        # Define GRPO training parameters
        training_args = GRPOConfig(
            per_device_train_batch_size=4,
            num_train_epochs=1,
            evaluation_strategy="steps", # Evaluate during training
            eval_steps=50,
            output_dir=finetuned_llm_version.working_directory,
            gradient_checkpointing=True
        )
    
        grpo_trainer = GRPOTrainer(
            model=model,
            reward_funcs=[correctness_reward_func, format_reward_func], 
            peft_config=peft_config,
            args=training_args,
            train_dataset=train_dataset,
            eval_dataset=val_dataset, # Passing validation dataset
            processing_class=tokenizer,
        )
    
        # Fine-tune the model using verifiable rewards
        grpo_trainer.train()
        
        # Save the model and log metadata back to Dataiku
        grpo_trainer.save_model()
        config = finetuned_llm_version.config
        config["batchSize"] = grpo_trainer.state.train_batch_size
        config["eventLog"] = grpo_trainer.state.log_history
    

By completing the above steps, you apply the GRPO algorithm to train models on complex reasoning chains.

#### 4: Visual evaluation on the test set

Once your model finishes training and is registered as a fine-tuned model in the LLM Mesh, you can easily evaluate its new reasoning capabilities! This can done in code, but using Prompt recipes works just as well.

Because we safely held out `gsm8k_test` from the training process, we can use it to objectively compare performance:

  1. Create a **Prompt recipe** using your base model (e.g., Qwen 2.5 1.5B) on the `gsm8k_test` dataset.

  2. Create a second **Prompt recipe** using your new `rlvr_aligned_model` on the same `gsm8k_test` dataset.




By comparing the outputs side-by-side, you should clearly see how the aligned model now actively “thinks” through the math problems step-by-step and strictly outputs its final answer in the correct XML format, vastly improving its accuracy.

---

## [tutorials/genai/llm/pre-training/index]

# Pre-training Large Language Models in Dataiku

Large Language Models (LLMs) are at the heart of AI systems, but we often aren’t exposed to how these powerful models are created. LLMs require vast amounts of data and computational resources to learn how to perform tasks like text generation. This process generally involves several stages:

  * **Pre-training** : training a model, typically a neural network, on massive amounts of data to learn language patterns, semantics, and world knowledge. This phase creates a model that can predict the next token, but we need to refine how it generates tokens to better suit its role.

  * **Fine-tuning and Alignment** : taking a pre-trained model and aligning it to its desired use case by training it on specialized data using techniques like supervised fine-tuning (SFT) and reinforcement learning from human feedback (RLHF). These techniques transition a general next-token predictor into a helpful assistant.




In this tutorial, we will show how to pre-train models in Dataiku. We will reference Andrej Karpathy’s GitHub repository [nanoGPT](<https://github.com/karpathy/nanoGPT>), which demonstrates how to pre-train an LLM.

By following the GitHub repository, you can reproduce OpenAI’s GPT-2 (124M parameters) if you use [OpenWebText](<https://skylion007.github.io/OpenWebTextCorpus/>) data, the same hyperparameters, and train the model on 8 NVIDIA A100 GPUs for about four days. For our purpose of pre-training an LLM in Dataiku, we will adjust scripts to run smoothly, use a smaller training dataset, and modify the hyperparameters so that training can be completed more quickly on a single, smaller GPU.

## Prerequisites

  * Dataiku >= 14.1

  * Python >= 3.12

  * A code environment with:
    
    * **Container runtime additions** : “GPU support for Torch 2” (in **Containerized execution**)

    * The following packages:
          
          tiktoken                    # tested with 0.11.0
          torch                       # tested with 2.9.0
          transformers[torch]         # tested with 4.57.1
          ragas                       # tested with 0.2.12
          langchain                   # tested with 0.3.27
          numpy<1.27                  #  tested with 1.26.4
          bert-score
          sacrebleu
          rouge-score
          scikit-learn>=1.1,<1.7      # tested with 1.6.1
          

  * Access to a GPU (without a GPU, you likely won’t be able to train the required models, even with small hyperparameters)




Important

In this tutorial, we use a local filesystem to store the managed folders. If you change to cloud storage like S3, the way you read/write files will be slightly different.

## Importing Code from GitHub to Project Library

Before we start building our Flow, we will need to import code from GitHub into the project libraries section of our project. As mentioned earlier, we will use several scripts from Andrej Karpathy’s GitHub repository [nanoGPT](<https://github.com/karpathy/nanoGPT>) to pre-train our own model. To do this in Dataiku, we can create a **Git reference** that links to the nanoGPT repository and allows us to import components from the nanoGPT repository.

To import the code:

  * Click on the **Code** menu (**< />**)

  * Go to **Libraries**

  * Click on **Git** , and select **Import from Git…**

  * Use the following to fill in the blank fields
    
    * **Remote URL** : `git@github.com:karpathy/nanoGPT.git`

    * **Checkout** : `master`

    * **Local target path** : `python`




Now, you should have the entire nanoGPT repository stored under your `python` folder in your project library. For this tutorial, we will use the [model.py](<https://github.com/karpathy/nanoGPT/blob/master/model.py>) file. This script defines a neural network with a transformer deep learning architecture that we will train to create a Generative Pre-trained Transformer (GPT) language model. The transformer architecture enables the model to generate coherent text by capturing long-range dependencies between words, which builds the model’s conceptual understanding of relationships between concepts, language, and world knowledge.

## Importing the training data

The pre-training phase typically requires training our model on data collected from the entire internet. To get results similar to OpenAI’s GPT-2 (124M parameters), you would need to train on [OpenWebText](<https://skylion007.github.io/OpenWebTextCorpus/>) data, which is 41.70 GB. To avoid running into computational bottlenecks, we will instead use a file containing all of Shakespeare’s work as our pre-training dataset.

Let’s retrieve this dataset using Dataiku’s “Download” recipe:

  * Add a **Download** recipe to your Flow.

  * Set the output folder name to `docs_raw_shakespeare`.

  * Save into the server’s filesystem.

  * Click the **Create recipe** button.

  * Then click the **\+ Add a first source** button.

  * And fill the form with:
    
    * **URL** : `https://raw.githubusercontent.com/karpathy/char-rnn/master/data/tinyshakespeare/input.txt`




Now, you should have a file called `input.txt` that is 1.06 MB in size, saved in your `docs_raw_shakespeare` folder.

## Preparing the Data

Collecting ample amounts of data for pre-training is only part of the work. You will need to prepare it and transform it into a suitable format for model training. To do this, we will create a **Python Code Recipe** with `docs_raw_shakespeare` as the Input and `docs_prepared_shakespeare`, a new **Managed Folder** that will reside in the server’s filesystem, as the Output. The aim of the Python recipe is to split our Shakespeare data into a training set and a validation set, encode text into subword tokens, and save the datasets in our new output Managed Folder.
    
    
    import os
    import dataiku
    import requests
    import tiktoken
    import numpy as np
    
    # 1. Read in the tiny shakespeare dataset
    docs_raw_shakespeare = dataiku.Folder("docs_raw_shakespeare")
    folder_path = docs_raw_shakespeare.get_path()  # local filesystem path
    file_path = os.path.join(folder_path, "input.txt")
    
    with open(file_path, 'r', encoding='utf-8') as f:
        data = f.read()
    
    # 2. Split data into 90% training data and 10% validation data
    n = len(data)
    train_data = data[:int(n*0.9)]
    val_data = data[int(n*0.9):]
    
    # 3. Encode with tiktoken gpt2 bpe
    enc = tiktoken.get_encoding("gpt2")
    train_ids = enc.encode_ordinary(train_data)
    val_ids = enc.encode_ordinary(val_data)
    
    # 4. Export to bin files
    train_ids = np.array(train_ids, dtype=np.uint16)
    val_ids = np.array(val_ids, dtype=np.uint16)
    
    # 5. Save bin files to Managed Folder
    docs_prepared_shakespeare = dataiku.Folder("docs_prepared_shakespeare")
    with docs_prepared_shakespeare.get_writer("train.bin") as w:
        w.write(train_ids)
    with docs_prepared_shakespeare.get_writer("val.bin") as w:
        w.write(val_ids)
    

## Training the Language Model

We have defined our transformer-based neural network in [model.py](<https://github.com/karpathy/nanoGPT/blob/master/model.py>) and prepared a training and validation set. Now, it’s time for us to train our neural network on Shakespeare and create an LLM capable of generating Shakespeare-like text. We will create a training script using a **Python code recipe**. The **Input** will be `docs_prepared_shakespeare`, and the **Output** will be `models_shakespeare`, a new **Managed Folder** in the server’s filesystem. We will use the [train.py](<https://github.com/karpathy/nanoGPT/blob/master/train.py>) script from the nanoGPT repository with some adjustments. The primary adjustments will be saving our artifacts in **Managed Folders** rather than on the local machine and adjusting the hyperparameters to train a smaller GPT model. Let’s take a look at the components that make up the training script.

Note

For this code recipe, we will use our GPU container to train our model on a GPU.

The first section of the code imports the necessary libraries. We are also importing `GPTConfig` and `GPT` from the [model.py](<https://github.com/karpathy/nanoGPT/blob/master/model.py>) file in the project library. `GPT` is the model class that defines the neural network that implements the GPT architecture. The `GPTConfig` is a configuration class that contains hyperparameters for the GPT model.
    
    
    import os
    import time
    import math
    import pickle
    from contextlib import nullcontext
    import tempfile
    import shutil
    
    import dataiku
    import numpy as np
    import torch
    from torch.distributed import init_process_group, destroy_process_group
    
    from model import GPT, GPTConfig
    

Next, we define our input and output Managed Folder. The input folder is where the training and validation data are stored. The output folder is where we will store our PyTorch checkpoint file, which contains a dictionary with information such as model weights and training metadata. Later, we can load these model weights and use them for inference to generate text or fine-tune the model for a specific task.
    
    
    # Connect to the input and output Managed Folders
    docs_prepared_shakespeare = dataiku.Folder("docs_prepared_shakespeare")
    models_shakespeare = dataiku.Folder("models_shakespeare")
    
    # Define model hyperparameters to train a mini Shakespeare model
    eval_interval = 250 # keep frequent because we'll overfit
    eval_iters = 200
    eval_only = False # if True, script exits right after the first eval
    log_interval = 10 # don't print too too often
    
    # we expect to overfit on this small dataset, so only save when val improves
    always_save_checkpoint = False
    init_from = 'scratch' # 'scratch' or 'resume' or 'gpt2*'
    
    gradient_accumulation_steps = 1
    batch_size = 12
    block_size = 64 # context of up to 256 previous characters
    
    # baby GPT model :)
    n_layer = 4
    n_head = 4
    n_embd = 128
    dropout = 0.2
    bias = False # do we use bias inside LayerNorm and Linear layers?
    
    learning_rate = 1e-3 # with baby networks can afford to go a bit higher
    max_iters = 2000
    weight_decay = 1e-1
    min_lr = 1e-4 # learning_rate / 10 usually
    beta1 = 0.9
    beta2 = 0.99 # make a bit bigger because the number of tokens per iter is small
    grad_clip = 1.0 # clip gradients at this value, or disable if == 0.0
    
    # learning rate decay settings
    decay_lr = True # whether to decay the learning rate
    warmup_iters = 100 # not super necessary, potentially
    lr_decay_iters = 2000 # make equal to max_iters usually
    min_lr = 6e-5 # minimum learning rate, should be ~= learning_rate/10 per Chinchilla
    device = "cuda"
    dtype = 'bfloat16' if torch.cuda.is_available() and torch.cuda.is_bf16_supported() else 'float16' # 'float32', 'bfloat16', or 'float16', the latter will auto implement a GradScaler
    compile = True
    
    # This will store all hyperparameters, which will be useful for logging
    config_keys = [k for k,v in globals().items() if not k.startswith('_') and isinstance(v, (int, float, bool, str))]
    config = {k: globals()[k] for k in config_keys}
    

Here, we are calculating the total number of tokens processed in one optimization step. We also ensure reproducible results by assigning a fixed random seed and identifying the computational device available to us (CPU or GPU with CUDA).
    
    
    tokens_per_iter = gradient_accumulation_steps * batch_size * block_size
    print(f"tokens per iteration will be: {tokens_per_iter:,}")
    torch.manual_seed(1337)
    torch.backends.cuda.matmul.allow_tf32 = True # allow tf32 on matmul
    torch.backends.cudnn.allow_tf32 = True # allow tf32 on cudnn
    device_type = 'cuda' if 'cuda' in device else 'cpu' # for later use in torch.autocast
    # note: float16 data type will automatically use a GradScaler
    ptdtype = {'float32': torch.float32, 'bfloat16': torch.bfloat16, 'float16': torch.float16}[dtype]
    ctx = nullcontext() if device_type == 'cpu' else torch.amp.autocast(device_type=device_type, dtype=ptdtype)
    

Now, we define two helper functions:

  * `get_memmap_from_folder`: this function downloads a binary file from a Managed Folder, writes it locally, and returns a `np.memmap` view of the file for efficient reading of the dataset.

  * `get_batch`: This function is a simple data loader that uses `np.memmap` to load `train.bin` and `val.bin`, generating a batch of input sequences x and next-token targets y.



    
    
    def get_memmap_from_folder(folder, filename, dtype, mode='r'):
        """Download stream → write to temp file → memory‑map"""
        with folder.get_download_stream(filename) as stream:
            # create a temp file
            tmp_path = os.path.join(tempfile.mkdtemp(), filename)
            with open(tmp_path, "wb") as f:
                f.write(stream.read())
        # memory‑map the temp file
        return np.memmap(tmp_path, dtype=dtype, mode=mode)
    
    def get_batch(split):
    """Generate a batch of inputs x and targets y"""
    # We recreate np.memmap every batch to avoid a memory leak, as per
    # https://stackoverflow.com/questions/45132940/numpy-memmap-memory-usage-want-to-iterate-once/61472122#61472122
    if split == 'train':
        data = get_memmap_from_folder(docs_prepared_shakespeare, "train.bin", dtype=np.uint16, mode='r')
    else:
        data = get_memmap_from_folder(docs_prepared_shakespeare, "val.bin", dtype=np.uint16, mode='r')
    
    ix = torch.randint(len(data) - block_size, (batch_size,))
    x = torch.stack([torch.from_numpy((data[i:i+block_size]).astype(np.int64)) for i in ix])
    y = torch.stack([torch.from_numpy((data[i+1:i+1+block_size]).astype(np.int64)) for i in ix])
    if device_type == 'cuda':
        # pin arrays x,y, which allows us to move them to GPU asynchronously (non_blocking=True)
        x, y = x.pin_memory().to(device, non_blocking=True), y.pin_memory().to(device, non_blocking=True)
    else:
        x, y = x.to(device), y.to(device)
    return x, y
    

Next, we will set up the model’s initial state and training components. We are initializing counters and metrics, such as `iter_num` and `best_val_loss`. We are also setting model configurations and instantiating a new GPT model from scratch, using the architecture parameters we set earlier.
    
    
    # init these up here
    iter_num = 0
    best_val_loss = 1e9
    meta_vocab_size = None
    
    # model init
    model_args = dict(n_layer=n_layer, n_head=n_head, n_embd=n_embd, block_size=block_size,
                      bias=bias, vocab_size=None, dropout=dropout) # start with model_args from command line
    
    # init a new model from scratch
    print("Initializing a new model from scratch")
    # determine the vocab size we'll use for from-scratch training
    if meta_vocab_size is None:
        print("defaulting to vocab_size of GPT-2 to 50304 (50257 rounded up for efficiency)")
    model_args['vocab_size'] = meta_vocab_size if meta_vocab_size is not None else 50304
    gptconf = GPTConfig(**model_args)
    model = GPT(gptconf)
    
    # crop down the model block size if desired, using model surgery
    if block_size < model.config.block_size:
        model.crop_block_size(block_size)
        model_args['block_size'] = block_size # so that the checkpoint will have the right value
    model.to(device)
    
    # initialize a GradScaler. If enabled=False scaler is a no-op
    scaler = torch.cuda.amp.GradScaler(enabled=(dtype == 'float16'))
    
    # optimizer
    optimizer = model.configure_optimizers(weight_decay, learning_rate, (beta1, beta2), device_type)
    if init_from == 'resume':
        optimizer.load_state_dict(checkpoint['optimizer'])
    checkpoint = None # free up memory
    # compile the model
    if compile:
        print("compiling the model... (takes a ~minute)")
        unoptimized_model = model
        model = torch.compile(model) # requires PyTorch 2.0
    

Before we train the newly instantiated GPT model, we will define two more helper functions:

  * `estimate_loss`: This function calculates the average loss for both train and validation splits over multiple mini-batches.

  * `get_lr`: This function implements a learning rate decay scheduler that, after a linear warmup, decays the learning rate with cosine decay to a minimum learning rate.



    
    
    # helps estimate an arbitrarily accurate loss over either split using many batches
    @torch.no_grad()
    def estimate_loss():
        out = {}
        model.eval()
        for split in ['train', 'val']:
            losses = torch.zeros(eval_iters)
            for k in range(eval_iters):
                X, Y = get_batch(split)
                with ctx:
                    logits, loss = model(X, Y)
                losses[k] = loss.item()
            out[split] = losses.mean()
        model.train()
        return out
    
    # learning rate decay scheduler (cosine with warmup)
    def get_lr(it):
        # 1) linear warmup for warmup_iters steps
        if it < warmup_iters:
            return learning_rate * (it + 1) / (warmup_iters + 1)
        # 2) if it > lr_decay_iters, return min learning rate
        if it > lr_decay_iters:
            return min_lr
        # 3) in between, use cosine decay down to min learning rate
        decay_ratio = (it - warmup_iters) / (lr_decay_iters - warmup_iters)
        assert 0 <= decay_ratio <= 1
        coeff = 0.5 * (1.0 + math.cos(math.pi * decay_ratio)) # coeff ranges 0..1
        return min_lr + coeff * (learning_rate - min_lr)
    

Now, we can train our GPT language model. During training, we adjust the model weights to minimize the cross-entropy loss. At a high level, here are the steps in the training loop:

  1. Fetch a batch of training data.

  2. Determine and update the learning rate.

  3. Periodic computations of average train/validation cross-entropy loss and save to checkpoint.

  4. Compute forward pass (model computes prediction and loss) and backward pass (use backpropagation to compute gradients of the loss with respect to each model parameter).

  5. Use gradient clipping to prevent large updates to the model’s parameters.

  6. Log current loss, counters, iteration time, and Model FLOPs Utilization (MFU).

  7. Increase the iteration counter until we reach the maximum number of training iterations.



    
    
    # training loop
    X, Y = get_batch('train') # fetch the very first batch
    t0 = time.time()
    local_iter_num = 0 # number of iterations in the lifetime of this process
    raw_model = model
    running_mfu = -1.0
    while True:
    
        # determine and set the learning rate for this iteration
        lr = get_lr(iter_num) if decay_lr else learning_rate
        for param_group in optimizer.param_groups:
            param_group['lr'] = lr
    
        # evaluate the loss on train/val sets and write checkpoints
        if iter_num % eval_interval == 0:
            losses = estimate_loss()
            print(f"step {iter_num}: train loss {losses['train']:.4f}, val loss {losses['val']:.4f}")
            if losses['val'] < best_val_loss or always_save_checkpoint:
                best_val_loss = losses['val']
                if iter_num > 0:
                    checkpoint = {
                        'model': raw_model.state_dict(),
                        'optimizer': optimizer.state_dict(),
                        'model_args': model_args,
                        'iter_num': iter_num,
                        'best_val_loss': best_val_loss,
                        'config': config,
                    }
                    print(f"saving to local checkpoint")
                    # write to local temp file
                    tmp_ckpt = os.path.join(tempfile.mkdtemp(), "ckpt.pt")
                    torch.save(checkpoint, tmp_ckpt)
                    # upload to managed folder
                    with models_shakespeare.get_writer("ckpt.pt") as f:
                        with open(tmp_ckpt, "rb") as lf:
                            shutil.copyfileobj(lf, f)
        if iter_num == 0 and eval_only:
            break
    
        # forward backward update, with optional gradient accumulation to simulate larger batch size
        # and using the GradScaler if data type is float16
        for micro_step in range(gradient_accumulation_steps):
            with ctx:
                logits, loss = model(X, Y)
                loss = loss / gradient_accumulation_steps # scale the loss to account for gradient accumulation
            # immediately async prefetch next batch while model is doing the forward pass on the GPU
            X, Y = get_batch('train')
            # backward pass, with gradient scaling if training in fp16
            scaler.scale(loss).backward()
        # clip the gradient
        if grad_clip != 0.0:
            scaler.unscale_(optimizer)
            torch.nn.utils.clip_grad_norm_(model.parameters(), grad_clip)
        # step the optimizer and scaler if training in fp16
        scaler.step(optimizer)
        scaler.update()
        # flush the gradients as soon as we can, no need for this memory anymore
        optimizer.zero_grad(set_to_none=True)
    
        # timing and logging
        t1 = time.time()
        dt = t1 - t0
        t0 = t1
        if iter_num % log_interval == 0:
            # get loss as float. note: this is a CPU-GPU sync point
            # scale up to undo the division above, approximating the true total loss (exact would have been a sum)
            lossf = loss.item() * gradient_accumulation_steps
            if local_iter_num >= 5: # let the training loop settle a bit
                mfu = raw_model.estimate_mfu(batch_size * gradient_accumulation_steps, dt)
                running_mfu = mfu if running_mfu == -1.0 else 0.9*running_mfu + 0.1*mfu
            print(f"iter {iter_num}: loss {lossf:.4f}, time {dt*1000:.2f}ms, mfu {running_mfu*100:.2f}%")
        iter_num += 1
        local_iter_num += 1
    
        # termination conditions
        if iter_num > max_iters:
            break
    

## Job Monitoring

After we initiate the training of our model, we can take a closer look at what is going on behind the scenes. Dataiku automatically tracks detailed activity logs for every single job that runs on the platform. We can review the logs for our training job to retrieve detailed information about how our job is progressing. To do that, we will need to navigate to the Jobs tab by:

  * Hitting the play button in the black navigation bar

  * Selecting **Jobs**

  * Clicking on your training job

  * Clicking **VIEW LOGS**

  * Clicking the arrow next to **Activity Log**




We are capturing key metrics at a regular interval. As the model continues to update its weights, the cross-entropy loss continues to decrease. We are tracking iteration time for each training loop and Model FLOPs Utilization (MFU), which measures the efficiency of model training. We also see when the model saves a checkpoint.

## Text Generation with the Pre-trained LLM

Now that we have our pre-trained model, we can use it to generate new text. We essentially have a Shakespeare writer LLM capable of generating Shakespeare-like text. We will provide our pre-trained LLM with various types of prompts and observe its behavior. To do that, let’s first create a new **Editable dataset** called `example_prompts_shakespeare` with three columns: `prompts`, `sample_response`, and `llm_response`. Below, we have three example prompts and sample response pairs that you can add as new rows to your editable dataset.

### Example 1

**Prompt** : Who are the top 10 most prominently featured characters in Shakespeare’s work based on number of lines spoken?

**Sample Response** :

Hamlet, Richard III, Iago, Henry V, Coriolanus, Othello, Timon, Vincentio, Mark Antony, and King Lear.

### Example 2

**Prompt** : Provide a short excerpt in the style of Hamlet.

**Sample Response** :

To stand and question every breath we draw,

Is mortal substance doomed to doubt and fear:

For life’s swift tide bears all our hopes away,

Yet death’s cold shadow lingers in the near.

Shall I embrace sweet sleep that knows no pain,

Or brave the storm wherein my soul remains?

Ah, think I must—yet dread what comes thereafter,

For dreams unknown may prove a darker chapter.

### Example 3

**Prompt** : Create a short conversation between father and son.

**Sample Response** :

FATHER:

Good son, why roam’st thou with such troubled brow?

Hast thou affronted Fortune’s fickle hand?

Tell me thy heart’s afflictions, speak them plain,

That I may know the cause of all thy care.

  


SON:

My liege of blood, I bear a storm within,

For life’s perplexing course confounds my thoughts.

To choose ‘twixt duty’s weight and youthful hope

Doth press upon my spirit like a pall.

Next, we will create a **Python code recipe** that uses our pre-trained LLM and the given prompts to populate the `llm_response` column. Select the **Managed Folder** `models_shakespeare` and the **Editable dataset** `example_prompts_shakespeare`, then create a **Python Code recipe** , set the Output to a new **Dataset** called `llm_responses_shakespeare` (in CSV format), saved into the server’s filesystem.

The first step in our Python code recipe is to import the necessary packages and read the recipe inputs.
    
    
    import dataiku
    import os
    import pickle
    from contextlib import nullcontext
    import pandas as pd
    import torch
    import tiktoken
    from model import GPTConfig, GPT
    
    # Read recipe inputs
    models_shakespeare = dataiku.Folder("models_shakespeare")
    
    example_prompts_shakespeare = dataiku.Dataset("example_prompts_shakespeare")
    example_prompts_shakespeare_df = example_prompts_shakespeare.get_dataframe()
    

The next step is to wrap our LLM inference logic in a for loop that iterates through our dataset, using example prompts created earlier. We are also setting key parameters like _temperature_ and _top-k_ that affect the output of our LLM and setting PyTorch settings. One other thing to note is that we are passing our example prompt as the `start` parameter.
    
    
    for row in range(len(example_prompts_shakespeare_df)):
    
        # ------------------------------------------------------------------------
        init_from = 'resume' # either 'resume' (from an out_dir) or a gpt2 variant (e.g. 'gpt2-xl')
        out_dir = models_shakespeare.get_path() # ignored if init_from is not 'resume'
        start = example_prompts_shakespeare_df.loc[row, "prompt"] # or "<|endoftext|>" or etc. Can also specify a file, use as: "FILE:prompt.txt"
        num_samples = 1 # number of samples to draw
        max_new_tokens = 100 # number of tokens generated in each sample
        temperature = 0.7 # 1.0 = no change, < 1.0 = less random, > 1.0 = more random, in predictions
        top_k = 200 # retain only the top_k most likely tokens, clamp others to have 0 probability
        seed = 1337
        device = 'cpu' # examples: 'cpu', 'cuda', 'cuda:0', 'cuda:1', etc.
        dtype = 'bfloat16' if torch.cuda.is_available() and torch.cuda.is_bf16_supported() else 'float16' # 'float32' or 'bfloat16' or 'float16'
        compile = False # use PyTorch 2.0 to compile the model to be faster
        # -------------------------------------------------------------------------
    
        torch.manual_seed(seed)
        torch.cuda.manual_seed(seed)
        torch.backends.cuda.matmul.allow_tf32 = True # allow tf32 on matmul
        torch.backends.cudnn.allow_tf32 = True # allow tf32 on cudnn
        device_type = 'cuda' if 'cuda' in device else 'cpu' # for later use in torch.autocast
        ptdtype = {'float32': torch.float32, 'bfloat16': torch.bfloat16, 'float16': torch.float16}[dtype]
        ctx = nullcontext() if device_type == 'cpu' else torch.amp.autocast(device_type=device_type, dtype=ptdtype)
    

In the next section of the for loop, we initialize and compile our pre-trained LLM. We saved our model under a file called `ckpt.pt`, so we will load that file. We also need to load in the encodings we used during pre-training for inference. We used GPT-2 encodings, and we will use them during inference to encode the prompt and decode the LLM response.
    
    
        # model
        if init_from == 'resume':
            # init from a model saved in a specific directory
            ckpt_path = os.path.join(out_dir, 'ckpt.pt')
            checkpoint = torch.load(ckpt_path, map_location=device)
            gptconf = GPTConfig(**checkpoint['model_args'])
            model = GPT(gptconf)
            state_dict = checkpoint['model']
            unwanted_prefix = '_orig_mod.'
            for k,v in list(state_dict.items()):
                if k.startswith(unwanted_prefix):
                    state_dict[k[len(unwanted_prefix):]] = state_dict.pop(k)
            model.load_state_dict(state_dict)
        elif init_from.startswith('gpt2'):
            # init from a given GPT-2 model
            model = GPT.from_pretrained(init_from, dict(dropout=0.0))
    
        model.eval()
        model.to(device)
        if compile:
            model = torch.compile(model) # requires PyTorch 2.0 (optional)
    
        # look for the meta pickle in case it is available in the dataset folder
        load_meta = False
        if init_from == 'resume' and 'config' in checkpoint and 'dataset' in checkpoint['config']: # older checkpoints might not have these...
            meta_path = os.path.join('data', checkpoint['config']['dataset'], 'meta.pkl')
            load_meta = os.path.exists(meta_path)
        if load_meta:
            print(f"Loading meta from {meta_path}...")
            with open(meta_path, 'rb') as f:
                meta = pickle.load(f)
            # TODO want to make this more general to arbitrary encoder/decoder schemes
            stoi, itos = meta['stoi'], meta['itos']
            encode = lambda s: [stoi[c] for c in s]
            decode = lambda l: ''.join([itos[i] for i in l])
        else:
            # ok let's assume gpt-2 encodings by default
            print("No meta.pkl found, assuming GPT-2 encodings...")
            enc = tiktoken.get_encoding("gpt2")
            encode = lambda s: enc.encode(s, allowed_special={"<|endoftext|>"})
            decode = lambda l: enc.decode(l)
    
        # encode the beginning of the prompt
        if start.startswith('FILE:'):
            with open(start[5:], 'r', encoding='utf-8') as f:
                start = f.read()
        start_ids = encode(start)
        x = (torch.tensor(start_ids, dtype=torch.long, device=device)[None, ...])
    

The final section of the for loop generates new text, decodes it, and saves it to the `llm_response` column of our dataset alongside the prompts.
    
    
    # run generation
    with torch.no_grad():
        with ctx:
            y = model.generate(x, max_new_tokens, temperature=temperature, top_k=top_k)
            full_output = decode(y[0].tolist())
    
            if full_output.startswith(start):
                clean_output = full_output[len(start):].lstrip()
            else:
                clean_output = full_output
            example_prompts_shakespeare_df.loc[row, "llm_response"] = clean_output
    

After the code finishes iterating through the for loop, we save the updated dataset into our output dataset `llm_responses_shakespeare`.
    
    
    # Write recipe outputs
    llm_responses_shakespeare = dataiku.Dataset("llm_responses_shakespeare")
    llm_responses_shakespeare.write_with_schema(example_prompts_shakespeare_df)
    

## Evaluating the LLM

We successfully created new text using our pre-trained LLM. That alone is a great achievement, but we will go one step further and evaluate our pre-trained LLM. Our `llm_responses_shakespeare` has three columns: `prompt`, `sample_response`, and `llm_response`. We can use those columns within an Evaluate LLM recipe to assess the performance of our pre-trained model.

It’s essential to note that we have a pre-trained model that can predict the next token; however, it is not yet configured to align with a specific use case and serve as a helpful assistant. This means our pre-trained model isn’t following the instructions provided in the prompt accurately. If we want our pre-trained model to be more useful to us, we need a post-training stage where we can fine-tune the model and align it to our requirements.

Let’s select the `llm_responses_shakespeare` dataset and add an **Evaluate LLM** recipe to our **Flow**. This will automatically set `llm_responses_shakespeare` as an Input. We will have three Outputs:

  * **Output Dataset** : This dataset will return our original columns plus new columns for each selected metric on a per-prompt/row basis. This allows us to understand the model’s performance on each individual example. Let’s call this `output` and save it as a CSV in the server’s filesystem.

  * **Metrics** : This dataset returns one row per evaluation run, with aggregated (typically average) metrics across all prompts. This provides a summary of the model’s performance across the entire evaluation run. Let’s call this `metrics` and save it as a CSV in the server’s filesystem.

  * **LLM Evaluation Store** : This central repository stores all our LLM evaluation runs, including metrics, metadata, and visuals. This allows us to compare and track the performance of multiple evaluations over time. Let’s call this `llm_evaluation_store`.




Let’s fill in the Evaluate LLM recipe as follows:

  * **Input Dataset Format** : Custom

  * **Task** : Other LLM Evaluation Task

  * **Input column** : prompt

  * **Output column** : llm_response

  * **Ground truth column** : sample_response

  * **Sampling method** : No sampling (whole data)

  * **Metrics to compute** :
    
    * BERT Score

    * Answer correctness

    * Answer similarity

    * BLEU

    * ROUGE

  * Select an Embedding LLM and Completion LLM based on what is available to you

  * Select the appropriate code environment

  * Select a container with a GPU




After running the recipe, you should have three new objects in your **Flow**. We can take a look at our pre-trained model’s performance by double-clicking the `llm_evaluation_store` object. This provides us with an aggregated view of our LLM evaluation runs.

If we want a more granular view, we can click on the **OPEN** button, then click on **Row-by-row analysis**.

## Conclusion

In this tutorial, we successfully pre-trained a transformer-based neural network to create an LLM capable of generating coherent text. To get to this stage, we had to:

  1. Define a neural network model with a transformer architecture.

  2. Prepare a dataset by splitting into training and validation splits and encoding our text into tokens.

  3. Train our model.

  4. Monitor the model training job to ensure the model’s performance was gradually improving.

  5. Evaluate the performance of our pre-trained LLM.




By completing the above steps, you gain full control over your training dataset, tokenizer, model architecture, and other design choices. This is particularly beneficial when working with proprietary data, addressing a niche use case that doesn’t require broad capabilities offered by standard foundation models, or mitigating the risk of system disruptions from future changes by third-party LLM providers.

As a next step, you could explore expanding what we’ve done here by:

  * Fine-tuning your pre-trained model to adapt it for a specific task using Dataiku’s **Fine tune** recipe.

  * Train on your own dataset or a popular dataset like [OpenWebText](<https://skylion007.github.io/OpenWebTextCorpus/>).

  * Train a larger model across multiple GPUs.

---

## [tutorials/genai/multimodal/gan/images-generation/index]

# Using Generative Adversarial Networks to generate synthetic images

In this tutorial, we will guide you through the process of building, training, and deploying a Generative Adversarial Network (GAN) to generate synthetic images. You will learn how to set up your environment, prepare your data, construct both the generator and discriminator models, and use MLflow for experiment tracking and model deployment.

Introduced by Ian Goodfellow et al. in 2014, Generative Adversarial Networks (GANs) are common deep learning networks used for tasks such as image generation, image translation, image super-resolution, and data augmentation. In this tutorial, we will use code notebooks to design, train, and deploy a Deep Convolutional GAN (DCGAN) to create synthetic images.

Today’s most popular deep learning libraries, PyTorch and TensorFlow, both have excellent reference material and tutorials on a variety of topics. Today, we will be leveraging a modified version of TensorFlow’s Deep Convolutional Generative Adversarial Network tutorial.

## Prerequisites

  * Dataiku >= 12.0

  * Python >= 3.9

  * A code environment with the following packages:
        
        tensorflow >=2.16,<2.21
        mlflow==2.17.2
        mlflow[extras]
        




## Getting Started

To get started, create a new Dataiku project. Go to the **Code ( </>)** menu, select Notebooks (G+N), and create a notebook. When prompted, select **Write your own** and choose **Python**. Be sure to select a code environment that contains the packages defined in the prerequisites section, and the appropriate Execution environment (if necessary) before clicking Create.

Note

TensorFlow automatically uses GPUs when available. If your execution and code environments are configured correctly, no further action is required.

## Importing the required packages

We will start by importing the packages we will use throughout this tutorial.

Code 1 – Importing prerequisite packages
    
    
    import dataiku
    from datetime import datetime
    import matplotlib.pyplot as plt
    import pandas as pd
    import tensorflow as tf
    

To make our code cleaner and easier to read, we can also import the specific TensorFlow layers, losses, and optimizers we want to use.

Code 2 – Importing specific classes
    
    
    from tensorflow.keras.layers import Input, Dense, BatchNormalization, LeakyReLU, Conv2DTranspose, Dropout, Flatten, \
        Dense, Conv2D, Reshape
    from tensorflow.keras.losses import BinaryCrossentropy
    from tensorflow.keras.optimizers import Adam
    
    

## Creating our training images dataset

We will be using the [Fashion MNIST](<https://github.com/zalandoresearch/fashion-mnist>) image dataset throughout this tutorial. Structurally identical to the more traditional MNIST dataset, the Fashion MNIST dataset consists of 70,000 28x28 pixel (single-channel) images of different types of clothing. This dataset is built into TensorFlow Datasets, making it easy for us to quickly download and create our training datasets. To download the dataset, call the `load_data()` function from the `tf.keras.datasets.fashion_mnist` class, as done in the code below.

Alternatively, we can import the dataset using the download recipe and retrieve the images using a managed folder. A walkthrough of this process can be found in the [Image Classification with Code](<https://knowledge.dataiku.com/latest/ml/complex-data/images/classification-code/tutorial-index.html> "\(in Dataiku Academy v14.0\)") tutorial.

Code 3 – Loading the dataset
    
    
    # Download the images to our notebook
    (training_images, _), (_, _) = tf.keras.datasets.fashion_mnist.load_data()
    
    # Reshape and normalize the values
    training_images = training_images.reshape(training_images.shape[0], 28, 28, 1)
    training_images = training_images / 256
    

Now that we’ve created our training_images dataset, let’s define some Hyperparameters to use. Feel free to experiment with the `BATCH_SIZE` and `EPOCHS` parameter values.

Code 4 – Defining hyperparameters
    
    
    # Define our hyperparameters
    BATCH_SIZE = 256
    EPOCHS = 40
    DROPOUT = 0.30
    IMAGE_SHAPE = [28, 28, 1]  # Channel-last orientation
    NOISE_SHAPE = [100]  # Noise shape is the input size to the generator
    NUM_IMAGES = training_images.shape[0]  # Optional to help make code cleaner
    

With our `BATCH_SIZE` now defined, we can take one final step to randomize and pre-batch our training dataset.
    
    
    training_dataset = tf.data.Dataset.from_tensor_slices(training_images).shuffle(NUM_IMAGES).batch(BATCH_SIZE)
    

## Creating the Models

Generative Adversarial Networks typically consist of two neural networks, a generator and a discriminator. These networks are closely coupled in architecture and are designed to be trained side-by-side, working against each other. Our generator will start with a noise input and be trained to generate images similar to Fashion MNIST images. Our discriminator is then trained to differentiate between genuine and generated images. This process can be repeated, with continued training/refinement of the generator and discriminator until the desired performance is achieved.

### Creating the Generator

We will start by building the generator using the Keras Sequential API. Starting with the `NOISE_SHAPE` input, we will perform three convolutional transpositions (and subsequent activation and normalization) to produce our 28x28x1 clothing images.

Code 6 – Generator model creation
    
    
    # Create the Generator model
    generator = tf.keras.Sequential()
    
    # Add the Input layer 
    generator.add(Input(shape=NOISE_SHAPE))
    # Preparation Layers 
    generator.add(Dense(7 * 7 * 128))
    generator.add(Reshape([7, 7, 128]))  # Reshape to 128 7x7 'images'
    generator.add(BatchNormalization())
    
    # First convolutional transposition
    generator.add(Conv2DTranspose(128, (5, 5), strides=1, padding='same'))
    generator.add(LeakyReLU())
    generator.add(BatchNormalization())
    
    # Second convolutional transposition
    generator.add(Conv2DTranspose(64, (5, 5), strides=2, padding='same'))
    generator.add(LeakyReLU())
    generator.add(BatchNormalization())
    
    # Final convolutional transposition - produces 28x28x1 images
    generator.add(Conv2DTranspose(1, (5, 5), strides=2, padding='same', activation='tanh'))
    

We can quickly verify that our image is the correct size by generating a random noise tensor and calling the `predict()` function. Since we haven’t trained our image, we should only see noise.
    
    
    noise = tf.random.normal([1, NOISE_SHAPE[0]])  # create a 100 element tensor
    img = generator.predict(noise)  # generate a single image
    
    # Plot the image (in grayscale)
    plt.imshow(img[0], cmap='gray')
    

### Creating the Discriminator

As with the generator, our discriminator model will be built using the Keras Sequential API. Starting with the `IMAGE_SHAPE` input, we will perform two convolutions, followed by activations and dropouts, to generate a binary (fake/real) classification.
    
    
    # Create the Discriminator model
    discriminator = tf.keras.Sequential()
    
    # Add the Input layer
    discriminator.add(Input(shape=IMAGE_SHAPE))
    
    # First Convolution
    discriminator.add(Conv2D(64, (5, 5), strides=2, padding='same'))
    discriminator.add(LeakyReLU())
    discriminator.add(Dropout(DROPOUT))
    
    # Second Convolution
    discriminator.add(Conv2D(128, (5, 5), strides=2, padding='same'))
    discriminator.add(LeakyReLU())
    discriminator.add(Dropout(DROPOUT))
    
    # Flatten out latent space and add our final (Dense) layer
    discriminator.add(Flatten())
    discriminator.add(Dense(1))
    

As with the generator, we can test our untrained discriminator by calling the discriminator’s `predict()` function.
    
    
    prediction = discriminator.predict(img)
    print(prediction)  # To show the predicted value
    

## Defining the Model Training Process

With our models now defined, we can create the functions needed to train them. To define our custom loss functions, we build upon TensorFlow’s _BinaryCrossentropy_ class and calculate our loss functions so that, over epochs, our generator gets better and better at creating images that the discriminator considers to be true. Since our discriminator classifies generated images as 0 and real images as 1, we will calculate their losses with respect to those values. For the generator, however, we want to calculate the losses against a prediction of 1 (real image).
    
    
    # Define the Generator and Discriminator loss functions
    def discriminator_loss(real_data, gen_data):
        bce = BinaryCrossentropy(from_logits=True)
    
        real_loss = bce(tf.ones_like(real_data), real_data)
        gen_loss = bce(tf.zeros_like(gen_data), gen_data)
    
        total_loss = real_loss + gen_loss
    
        return total_loss
    
    
    def generator_loss(gen_image):
        bce = BinaryCrossentropy(from_logits=True)
        gen_loss = bce(tf.ones_like(gen_image), gen_image)
    
        return gen_loss
    

With our loss functions defined, we can now start defining the actual training step: generate a noise tensor, create GradientTape objects for both the generator and the discriminator, generate images and classifications, then apply the necessary gradient calculations and updates.
    
    
    # Define our optimizers for each model
    gen_optimizer = Adam(1e-4)
    disc_optimizer = Adam(1e-4)
    
    
    # Define an individual training step
    def train_step(images):
        # Generate noise tensors
        noise = tf.random.normal([BATCH_SIZE, NOISE_SHAPE[0]])
    
        # Use GradientTape objects to manually define  training step
        with tf.GradientTape() as gen_tape, tf.GradientTape() as disc_tape:
            generated_images = generator(noise, training=True)
    
            real_out = discriminator(images, training=True)
            gen_out = discriminator(generated_images, training=True)
    
            gen_loss = generator_loss(gen_out)
            disc_loss = discriminator_loss(real_out, gen_out)
    
        gen_grads = gen_tape.gradient(gen_loss, generator.trainable_variables)
        disc_grads = disc_tape.gradient(disc_loss, discriminator.trainable_variables)
    
        gen_optimizer.apply_gradients(zip(gen_grads, generator.trainable_variables))
        disc_optimizer.apply_gradients(zip(disc_grads, discriminator.trainable_variables))
    

We are ready to train our models. Since we’ve already batched our training data, we can simply iterate over our batches for every epoch. The weights will automatically be updated after each cycle, so no additional functions or definitions are required.
    
    
    for epoch in range(EPOCHS):
        print(f"training run {epoch} of {EPOCHS}")
        for batch in training_dataset:
            train_step(batch)
    

Once training is complete, you can use the `predict()` calls for both the generator and discriminator.

## Using MLFlow to store the models

To access our models outside the notebook, we will need to create a model artifact. Create a **Managed folder** in your project to store the experiments and model artifacts. Note its ID. Once the MLFlow handler has been created, we will integrate our training functions with hyperparameter and metrics logging.
    
    
    # create project and folder objects
    project = dataiku.api_client().get_default_project()
    model_folder = project.get_managed_folder('<YOUR_MANAGED_FOLDER_ID>')
    
    
    # Define helper functions
    def now_str() -> str:
        return datetime.now().strftime("%Y%m%d%H%M%S")
    
    
    # define MLFlow parameters
    MLFLOW_CODE_ENV_NAME = '<YOUR_CODE_ENV_NAME>'
    PREDICTION_TYPE = 'OTHER'
    EXPERIMENT_FOLDER_ID = '<YOUR_MANAGED_FOLDER_ID>'
    
    with project.setup_mlflow(managed_folder=model_folder) as mlflow_handle:
        mlflow_handle.set_experiment('Training')
    

To help improve the development of our models, let’s rewrite our `train_step()` to log our generator and discriminator losses as metrics. There is no change to the train function, as we will log our experiment hyperparameters with each run.
    
    
        def train_step(images):
            # Generate noise tensors
            noise = tf.random.normal([BATCH_SIZE, NOISE_SHAPE[0]])
    
            # Use GradientTape objects to manually define  training step
            with tf.GradientTape() as gen_tape, tf.GradientTape() as disc_tape:
                generated_images = generator(noise, training=True)
    
                real_out = discriminator(images, training=True)
                gen_out = discriminator(generated_images, training=True)
    
                gen_loss = generator_loss(gen_out)
                disc_loss = discriminator_loss(real_out, gen_out)
    
                # Log the losses
                mlflow_handle.log_metric("generator_loss", gen_loss)
                mlflow_handle.log_metric("discriminator_loss", disc_loss)
    
            gen_grads = gen_tape.gradient(gen_loss, generator.trainable_variables)
            disc_grads = disc_tape.gradient(disc_loss, discriminator.trainable_variables)
    
            gen_optimizer.apply_gradients(zip(gen_grads, generator.trainable_variables))
            disc_optimizer.apply_gradients(zip(disc_grads, discriminator.trainable_variables))
    
    
        # Add our train function
        def train(training_dataset, epochs):
            for epoch in range(epochs):
                for batch in training_dataset:
                    train_step(batch)
    

We can now write the code for a training run, which should include logging our experiment hyperparameters, training the models, and logging the Keras model objects. Finally, we will set our run inference info, which will allow us to create our model objects in the flow.
    
    
        with mlflow_handle.start_run(run_name="<YOUR_EXP_NAME>") as run:
            mlflow_handle.log_param('Batch Size', BATCH_SIZE)
            mlflow_handle.log_param('Epochs', EPOCHS)
            mlflow_handle.log_param('Noise Shape', NOISE_SHAPE)
            mlflow_handle.log_param('Image Shape', IMAGE_SHAPE)
    
            # Define the paths to save the models
            generator_path = f"Generator-{now_str()}"
            discriminator_path = f"Discriminator-{now_str()}"
    
            train(training_dataset, EPOCHS)
    
            # Log the models
            mlflow_handle.keras.log_model(generator, artifact_path=generator_path)
            mlflow_handle.keras.log_model(discriminator, artifact_path=discriminator_path)
    
            # set the Run Inference Info
            mlflow_ext = project.get_mlflow_extension()
            mlflow_ext.set_run_inference_info(run_id=run._info.run_id,
                                              prediction_type=PREDICTION_TYPE,
                                              code_env_name=MLFLOW_CODE_ENV_NAME)
    

## Deploying our models

We can now view our experiments in the Experiment Tracking section of our project. Each experiment and run can now be viewed individually. To deploy our models, click into a specific run and select the Deploy a model button under the Models section. You will then be prompted to select the specific model and code environment.

## Conclusion

In this tutorial, you saw how to train a generative adversarial network to generate synthetic Fashion MNIST images. You also saw how to create and log the MLFlow model objects and add them to a project flow.

Here is the complete code of the Code Agent using an agent framework:

[`Complete code of the tutorial`](<../../../../../_downloads/cd9ebf49320f3886816c0a3c6b0e3e3d/notebook.py>)
    
    
    import dataiku
    from datetime import datetime
    import matplotlib.pyplot as plt
    import pandas as pd
    import tensorflow as tf
    
    from tensorflow.keras.layers import Input, Dense, BatchNormalization, LeakyReLU, Conv2DTranspose, Dropout, Flatten, \
        Dense, Conv2D, Reshape
    from tensorflow.keras.losses import BinaryCrossentropy
    from tensorflow.keras.optimizers import Adam
    
    # Download the images to our notebook
    (training_images, _), (_, _) = tf.keras.datasets.fashion_mnist.load_data()
    
    # Reshape and normalize the values
    training_images = training_images.reshape(training_images.shape[0], 28, 28, 1)
    training_images = training_images / 256
    
    # Define our hyperparameters
    BATCH_SIZE = 256
    EPOCHS = 40
    DROPOUT = 0.30
    IMAGE_SHAPE = [28, 28, 1]  # Channel-last orientation
    NOISE_SHAPE = [100]  # Noise shape is the input size to the generator
    NUM_IMAGES = training_images.shape[0]  # Optional to help make code cleaner
    
    training_dataset = tf.data.Dataset.from_tensor_slices(training_images).shuffle(NUM_IMAGES).batch(BATCH_SIZE)
    
    # Create the Generator model
    generator = tf.keras.Sequential()
    
    # Add the Input layer 
    generator.add(Input(shape=NOISE_SHAPE))
    # Preparation Layers 
    generator.add(Dense(7 * 7 * 128))
    generator.add(Reshape([7, 7, 128]))  # Reshape to 128 7x7 'images'
    generator.add(BatchNormalization())
    
    # First convolutional transposition
    generator.add(Conv2DTranspose(128, (5, 5), strides=1, padding='same'))
    generator.add(LeakyReLU())
    generator.add(BatchNormalization())
    
    # Second convolutional transposition
    generator.add(Conv2DTranspose(64, (5, 5), strides=2, padding='same'))
    generator.add(LeakyReLU())
    generator.add(BatchNormalization())
    
    # Final convolutional transposition - produces 28x28x1 images
    generator.add(Conv2DTranspose(1, (5, 5), strides=2, padding='same', activation='tanh'))
    
    noise = tf.random.normal([1, NOISE_SHAPE[0]])  # create a 100 element tensor
    img = generator.predict(noise)  # generate a single image
    
    # Plot the image (in grayscale)
    plt.imshow(img[0], cmap='gray')
    
    # Create the Discriminator model
    discriminator = tf.keras.Sequential()
    
    # Add the Input layer
    discriminator.add(Input(shape=IMAGE_SHAPE))
    
    # First Convolution
    discriminator.add(Conv2D(64, (5, 5), strides=2, padding='same'))
    discriminator.add(LeakyReLU())
    discriminator.add(Dropout(DROPOUT))
    
    # Second Convolution
    discriminator.add(Conv2D(128, (5, 5), strides=2, padding='same'))
    discriminator.add(LeakyReLU())
    discriminator.add(Dropout(DROPOUT))
    
    # Flatten out latent space and add our final (Dense) layer
    discriminator.add(Flatten())
    discriminator.add(Dense(1))
    
    prediction = discriminator.predict(img)
    print(prediction)  # To show the predicted value
    
    
    # Define the Generator and Discriminator loss functions
    def discriminator_loss(real_data, gen_data):
        bce = BinaryCrossentropy(from_logits=True)
    
        real_loss = bce(tf.ones_like(real_data), real_data)
        gen_loss = bce(tf.zeros_like(gen_data), gen_data)
    
        total_loss = real_loss + gen_loss
    
        return total_loss
    
    
    def generator_loss(gen_image):
        bce = BinaryCrossentropy(from_logits=True)
        gen_loss = bce(tf.ones_like(gen_image), gen_image)
    
        return gen_loss
    
    
    # Define our optimizers for each model
    gen_optimizer = Adam(1e-4)
    disc_optimizer = Adam(1e-4)
    
    
    # Define an individual training step
    def train_step(images):
        # Generate noise tensors
        noise = tf.random.normal([BATCH_SIZE, NOISE_SHAPE[0]])
    
        # Use GradientTape objects to manually define  training step
        with tf.GradientTape() as gen_tape, tf.GradientTape() as disc_tape:
            generated_images = generator(noise, training=True)
    
            real_out = discriminator(images, training=True)
            gen_out = discriminator(generated_images, training=True)
    
            gen_loss = generator_loss(gen_out)
            disc_loss = discriminator_loss(real_out, gen_out)
    
        gen_grads = gen_tape.gradient(gen_loss, generator.trainable_variables)
        disc_grads = disc_tape.gradient(disc_loss, discriminator.trainable_variables)
    
        gen_optimizer.apply_gradients(zip(gen_grads, generator.trainable_variables))
        disc_optimizer.apply_gradients(zip(disc_grads, discriminator.trainable_variables))
    
    
    for epoch in range(EPOCHS):
        print(f"training run {epoch} of {EPOCHS}")
        for batch in training_dataset:
            train_step(batch)
    
    # create project and folder objects
    project = dataiku.api_client().get_default_project()
    model_folder = project.get_managed_folder('<YOUR_MANAGED_FOLDER_ID>')
    
    
    # Define helper functions
    def now_str() -> str:
        return datetime.now().strftime("%Y%m%d%H%M%S")
    
    
    # define MLFlow parameters
    MLFLOW_CODE_ENV_NAME = '<YOUR_CODE_ENV_NAME>'
    PREDICTION_TYPE = 'OTHER'
    EXPERIMENT_FOLDER_ID = '<YOUR_MANAGED_FOLDER_ID>'
    
    with project.setup_mlflow(managed_folder=model_folder) as mlflow_handle:
        mlflow_handle.set_experiment('Training')
    
    
        def train_step(images):
            # Generate noise tensors
            noise = tf.random.normal([BATCH_SIZE, NOISE_SHAPE[0]])
    
            # Use GradientTape objects to manually define  training step
            with tf.GradientTape() as gen_tape, tf.GradientTape() as disc_tape:
                generated_images = generator(noise, training=True)
    
                real_out = discriminator(images, training=True)
                gen_out = discriminator(generated_images, training=True)
    
                gen_loss = generator_loss(gen_out)
                disc_loss = discriminator_loss(real_out, gen_out)
    
                # Log the losses
                mlflow_handle.log_metric("generator_loss", gen_loss)
                mlflow_handle.log_metric("discriminator_loss", disc_loss)
    
            gen_grads = gen_tape.gradient(gen_loss, generator.trainable_variables)
            disc_grads = disc_tape.gradient(disc_loss, discriminator.trainable_variables)
    
            gen_optimizer.apply_gradients(zip(gen_grads, generator.trainable_variables))
            disc_optimizer.apply_gradients(zip(disc_grads, discriminator.trainable_variables))
    
    
        # Add our train function
        def train(training_dataset, epochs):
            for epoch in range(epochs):
                for batch in training_dataset:
                    train_step(batch)
    
    
        with mlflow_handle.start_run(run_name="<YOUR_EXP_NAME>") as run:
            mlflow_handle.log_param('Batch Size', BATCH_SIZE)
            mlflow_handle.log_param('Epochs', EPOCHS)
            mlflow_handle.log_param('Noise Shape', NOISE_SHAPE)
            mlflow_handle.log_param('Image Shape', IMAGE_SHAPE)
    
            # Define the paths to save the models
            generator_path = f"Generator-{now_str()}"
            discriminator_path = f"Discriminator-{now_str()}"
    
            train(training_dataset, EPOCHS)
    
            # Log the models
            mlflow_handle.keras.log_model(generator, artifact_path=generator_path)
            mlflow_handle.keras.log_model(discriminator, artifact_path=discriminator_path)
    
            # set the Run Inference Info
            mlflow_ext = project.get_mlflow_extension()
            mlflow_ext.set_run_inference_info(run_id=run._info.run_id,
                                              prediction_type=PREDICTION_TYPE,
                                              code_env_name=MLFLOW_CODE_ENV_NAME)

---

## [tutorials/genai/multimodal/images-and-text/images-captioning/index]

# Mixing text and images: Images labeling with the LLM Mesh

In this tutorial, you will learn how to use the LLM Mesh to add a label to classified images automatically. Suppose you have a dataset composed of images that you want to classify. You already have an ML model that classifies your pictures correctly, but you want to add a text/label to the image automatically so that you do not need any other tool to view the classification result. Usually, when you need to do such a thing, you build a (web) application that extracts the label from the data and displays it. Using an LLM with multimodal capability could help add a label to an image so that the classification result is written in the image, avoiding the need to build an additional application.

## Prerequisites

  * Dataiku > 13.3

  * A valid LLM connection with a model that can do image-to-image.




This tutorial is based on the [Image Classification](<https://academy.dataiku.com/path/ml-practitioner/image-classification-with-visual-tools-open>) tutorial from the [Academy](<https://academy.dataiku.com/>). You will use the `bean_images_test_files_scored` dataset as an input.

If you don’t want to follow the Academy’s tutorial, you will need a dataset with at least two columns (`path` and `prediction`). You can build such a dataset by uploading the content of [`this zip file`](<../../../../../_downloads/5b19560b92868fdb1df5d1ee25286ed3/test-image.zip>) into a newly created managed folder. Then, use the “List Contents” recipe with the following “Folder level mapping”: `1 prediction`.

Obviously, you will also need a set of images (corresponding to the path columns). As you will use the `"INPAINTING"` mode for the LLM, you will also need a “masked” image, like the one you can find [`here`](<../../../../../_downloads/091becd4dbe527639e0063d605cd7672/mask.png>). You will use `"INPAINTING"` mode as it is the only one, at the time of writing, that allows you to modify an image; `"VARY"` mode will generate a new image based on the provided image, but without using a prompt; `"MASK_FREE"` will generate a new image (based on the provided image) with the prompt taken into account.

This tutorial can be run in a Jupyter Notebook.

## Getting the LLM

Getting an LLM ID for image generation is not so much different than retrieving a “classical” LLM ID. Code 1 shows how to retrieve this ID.

Code1: List existing LLMs capable of image generation and their associated ID.
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms(purpose="IMAGE_GENERATION")
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    

## Checking if everything is okay

Code 2 is the code snippet to view if you can access all the required data. If everything is okay you should see an image like the one shown in Figure 1. You should also have access to a masked image. For the simplicity of this tutorial, let’s consider that this image is stored in the same folder as the image you need to label.

Code 2: Snippet code to check if everything is ok.
    
    
    from IPython.display import display, Image
    
    mydataset = dataiku.Dataset("bean_images_test_files_scored")
    mydataset_df = mydataset.get_dataframe()
    test_folder = dataiku.Folder("bean_images_test")
    data = mydataset_df.iloc[0]
    with test_folder.get_download_stream("mask.png") as img_file
        black_mask_image_data = img_file.read()
    with test_folder.get_download_stream(data.path) as img:
        img_data = img.read()
    
    Image(img_data)
    

Figure 1: Original image.

## Labeling your image

Once all the requirements are met, you can label your image using Code 3. If so, you will obtain a similar result as in Figure 3. If you want to label all the images in the `test_folder`, you must iterate over the dataframe.

Code 3: Labeling an image
    
    
    generation = imagellm.new_images_generation()
    generation.with_original_image(img_data, mode="INPAINTING", weight=1)
    generation.with_mask("MASK_IMAGE_BLACK", image=black_mask_image_data)
    generation.with_prompt(f"""Add the text "{data.prediction}" to the image""", weight=1)
    generation.fidelity = 1
    resp = generation.execute()
    

Figure 3: Result of the labeling task.

## Wrapping up

You have a working notebook for labeling images. You can iterate over the folder to label all pictures or try another dataset. Of course, you might not need an LLM to do this kind of processing, but this tutorial gives you a good understanding of how to use an LLM to modify an image.

Here is the complete code of a possible notebook:

[`notebook.py`](<../../../../../_downloads/9c9664b4823245906fea717d63f3aeca/notebook.py>)
    
    
    # ---------------------------------------------------------------- NOTEBOOK-CELL: CODE
    import dataiku
    import pprint
    from IPython.display import display, Image
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms(purpose="IMAGE_GENERATION")
    for llm in llm_list:
        # pprint.pp(llm)
        print(f"- {llm.description} (id: {llm.id})")
    
    # ---------------------------------------------------------------- NOTEBOOK-CELL: CODE
    LLM_ID = "" # FILL WITH YOUR LLM ID
    imagellm = dataiku.api_client().get_default_project().get_llm(LLM_ID)
    
    # ---------------------------------------------------------------- NOTEBOOK-CELL: CODE
    FOLDER_ID = "bean_images_train"
    folder = dataiku.Folder(FOLDER_ID)
    
    # ---------------------------------------------------------------- NOTEBOOK-CELL: CODE
    with folder.get_download_stream("/healthy/healthy_30.jpg") as img:
        img_data = img.read()
    
    Image(img_data)
    
    # ---------------------------------------------------------------- NOTEBOOK-CELL: CODE
    # Example: load a Dataiku dataset as a Pandas dataframe
    mydataset = dataiku.Dataset("bean_images_test_files_scored")
    mydataset_df = mydataset.get_dataframe()
    test_folder = dataiku.Folder("bean_images_test")
    data = mydataset_df.iloc[0]
    
    # ---------------------------------------------------------------- NOTEBOOK-CELL: CODE
    with test_folder.get_download_stream(data.path) as img:
        img_data = img.read()
    
    Image(img_data)
    
    # ---------------------------------------------------------------- NOTEBOOK-CELL: CODE
    with folder.get_download_stream("image.png") as img:
        black_mask_image_data = img.read()
    
    generation = imagellm.new_images_generation()
    generation.with_original_image(img_data, mode="INPAINTING", weight=1)
    generation.with_mask("MASK_IMAGE_BLACK", image=black_mask_image_data)
    generation.with_prompt(f"""Add the text "{data.prediction}" to the image""", weight=1)
    generation.fidelity = 1
    resp = generation.execute()
    
    # ---------------------------------------------------------------- NOTEBOOK-CELL: CODE
    Image(resp.first_image())

---

## [tutorials/genai/multimodal/images-and-text/images-generation/index]

# Image generation using the LLM Mesh

Large Language Models (LLMs) are helpful for summarization, classification, chatbots, etc. Their effectiveness can be extended with frameworks like agents and function calling, and their accuracy can be improved with RAG and fine-tuning. We usually use LLMs for textual interaction, even if we can input some images in the different models.

This tutorial explores another side of LLMs - their image generation capabilities. Dataiku LLM Mesh allows users to use Image generation models. The Python Dataiku LLM Mesh API lets users quickly set up and test various LLMs. In this tutorial, you will use the image generation capabilities of the LLM Mesh and and build a visual web application around it. You will create a movie poster from an overview of a film. This information comes from the IMDB database, but you can easily gather film information using a search tool.

## Prerequisites

  * Dataiku 13.1

  * A valid LLM connection

  * If you want to test the webapp part, a code-env with the following packages:
        
        dash
        dash-bootstrap-components
        




This tutorial has been tested with `dash==2.17.1` and `dash-bootstrap-components==1.6.0`.

You will need the IMDB database, which can be downloaded [here](<https://www.kaggle.com/datasets/harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows>).

## Getting the LLM

Getting an LLM ID for image generation is not so much different than retrieving a “classical” LLM ID. Code 1 shows how to retrieve this ID.

Code1: List existing LLMs capable of image generation and their associated ID.
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms(purpose="IMAGE_GENERATION")
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    

Once you have identified which LLM you want to use, note the associated ID (LLM_ID).

## Retrieving movie information and image creation

To query the dataset easily, create an **SQL** dataset named `movies` from the data you have previously downloaded. Then, create the search function in a notebook, as shown in Code 2.

Attention

The SQL query might be written differently depending on your SQL Engine.

Code 2: Searching for information about a movie
    
    
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    
    def search(title):
        """
        Search for information based on movie title
        Args:
            title: the movie title
    
        Returns:
            the image src, title, year, overview and genre of the movie.
        """
        dataset = dataiku.Dataset("movies")
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
        tid = Constant(str(title))
        escaped_tid = toSQL(tid, dialect=Dialects.POSTGRES)  # Replace by your DB
        query_reader = executor.query_to_iter(
            f"""SELECT "Poster_Link", "Series_Title", "Released_Year", "Overview", "Genre" FROM {table_name} WHERE "Series_Title" = {escaped_tid}""")
        for tupl in query_reader.iter_tuples():
            return tupl
    

Then, you can create a poster movie using a code similar to Code 3 from that information.

Code 3: Creating a poster movie.
    
    
    LLM_ID = ""  # Replace with a valid LLM id
    
    imagellm = dataiku.api_client().get_default_project().get_llm(LLM_ID)
    movie = search('Citizen Kane')
    img = imagellm.new_images_generation().with_prompt(f"""
    Generate a poster movie. The size of the poster should be 120x120px. 
    The title of the movie is: "{movie[1]}."
    The year of the movie is: "{movie[2]}."
    The summary is: "{movie[3]}."
    The genre of the movie is: "{movie[4]}."
    """)
    resp = img.execute()
    
    from IPython.display import display, Image
    
    if resp.success:
        display(Image(resp.first_image()))
    

Using the prompt defined in Code 3 will obtain something like the poster shown in Figure 1 and Figure 2.

Figure 1: Resulting image.

Figure 2: Resulting image – second run.

## Creating a web app

Like the previous section, the web application retrieves and displays information from the `movies` dataset. Based on the information and user needs, it generates a prompt for image generation. Once the LLM generates the image, the web application displays the poster movie next to the original.

Figure 3: Start of the webapp.

Figure 3 shows the web application when it starts. In Code 4, we import the necessary libraries and define the web application’s default values.

Code 4: Global definitions
    
    
    from dash import html
    from dash import dcc
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash import no_update
    
    import base64
    import dataiku
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    
    dbc_css = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"
    app.config.external_stylesheets = [dbc.themes.SUPERHERO, dbc_css]
    
    IMG_LLM_ID = ""
    DATASET_NAME = "movies"
    
    USE_TITLE = 1
    USE_YEAR = 2
    USE_OVERVIEW = 3
    USE_GENRE = 4
    
    imagellm = dataiku.api_client().get_default_project().get_llm(IMG_LLM_ID)
    

The highlighted lines in Code 5 display the result of the query database when the user clicks on the search button.

Code 5: Application layout
    
    
    # build your Dash app
    v1_layout = html.Div([
        dbc.Row([html.H2("Using LLM Mesh to generate of Poster movie."), ]),
        dbc.Row(dbc.Label("Please enter a name of a movie:")),
        dbc.Row([
            dbc.Col(dbc.Input(id="movie", placeholder="Citizen Kane", debounce=True), width=10),
            dbc.Col(dbc.Button("Search", id="search", color="primary"), width=2)
        ], justify="between", class_name="mt-3 mb-3"),
        dbc.Row([
            dbc.Col(dbc.Label("Select features you want to use for genrating an image:")),
            dbc.Col(dbc.Row([
                dbc.Checklist(
                    options=[
                        {"label": "Use Title", "value": USE_TITLE},
                        {"label": "Use Year", "value": USE_YEAR},
                        {"label": "Use Overview", "value": USE_OVERVIEW},
                        {"label": "Use Genre", "value": USE_GENRE}
                    ],
                    value=[USE_OVERVIEW],
                    id="features",
                    inline=True,
                ),
            ]), width=6),
            dbc.Col(dbc.Button("Generate", id="generate", color="primary"), width=2)
        ], align="center", class_name="mt-3 mb-3"),
        dbc.Row([
            dbc.Col([
                dbc.Row([html.H2("Movie information")]),
                dbc.Row([
                    html.H3(children="", id="title")
                ], align="center", justify="around"),
                dbc.Row([
                    html.H4(children="", id="year")
                ]),
                dbc.Row([
                    html.H4(children="", id="genre")
                ]),
                dbc.Textarea(id="overview", style={"min-height": "500px"})
            ], width=4),
            dbc.Col(html.Img(id="image", src="", width="95%"), width=4),
            dbc.Col(html.Img(id="generatedImg", src="", width="95%"), width=4),
        ], align="center"),
        dbc.Toast(
            [html.P("Searching for information about the movie", className="mb-0"),
             dbc.Spinner(color="primary")],
            id="search-toast",
            header="Querying the database",
            icon="primary",
            is_open=False,
            style={"position": "fixed", "top": "50%", "left": "50%", "transform": "translate(-50%, -50%)"},
        ),
        dbc.Toast(
            [html.P("Generating an image", className="mb-0"),
             dbc.Spinner(color="primary")],
            id="generate-toast",
            header="Querying the LLM",
            icon="primary",
            is_open=False,
            style={"position": "fixed", "top": "50%", "left": "50%", "transform": "translate(-50%, -50%)"},
        ),
    
        dcc.Store(id="step", data=[{"current_step": 0}]),
    ], className="container-fluid mt-3")
    
    app.layout = v1_layout
    

Code 6 shows how to connect the callbacks needed for the web application result. Figure 4 shows the result of searching “Citizen Kane,” and Figure 5 shows the result of image generation.

Attention

The SQL query might be written differently depending on your SQL Engine.

Code 6: Callbacks
    
    
    def search(movie_title):
        """
        Search information about a movie
        Args:
            movie_title: title of the movie
        Returns:
            Information of the movie
        """
        dataset = dataiku.Dataset(DATASET_NAME)
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
        tid = Constant(str(movie_title))
        escaped_tid = toSQL(tid, dialect=Dialects.POSTGRES)  # Replace by your DB
        query_reader = executor.query_to_iter(
            f"""SELECT "Poster_Link", "Series_Title", "Released_Year", "Overview", "Genre" FROM {table_name} WHERE "Series_Title" = {escaped_tid}""")
        for tupl in query_reader.iter_tuples():
            return tupl
        return None
    
    
    @app.callback([
        Output("image", "src"),
        Output("title", "children"),
        Output("year", "children"),
        Output("genre", "children"),
        Output("overview", "value")
    ],
        Input("search", "n_clicks"),
        State("features", "value"),
        Input("movie", "value"),
        prevent_initial_call=True,
        running=[(Output("search-toast", "is_open"), True, False),
                 (Output("search", "disabled"), True, False),
                 (Output("generate", "disabled"), True, False)
                 ]
    )
    def gather_information(_, value, title):
        info = search(title)
        if info:
            return [info[0], info[1], info[2], info[4], info[3]]
        else:
            return ["", "", "", "", f"""No information concerning the movie: "{title}" """]
    
    
    @app.callback([
        Output("generatedImg", "src"),
    ],
        Input("generate", "n_clicks"),
        State("title", "children"),
        State("year", "children"),
        State("genre", "children"),
        State("overview", "value"),
        State("features", "value"),
        prevent_initial_call=True,
        running=[(Output("generate-toast", "is_open"), True, False),
                 (Output("search", "disabled"), True, False),
                 (Output("generate", "disabled"), True, False)
                 ],
    )
    def generate_image(_, title, year, genre, overview, features):
        prompt = "Generate a poster movie."
        if USE_TITLE in features:
            prompt = f"""${prompt} The title of the movie is: "{title}." """
        if USE_YEAR in features:
            prompt = f"""${prompt} The film was released in: "{year}." """
        if USE_GENRE in features:
            prompt = f"""${prompt} The film genre is: "{year}." """
        if USE_OVERVIEW in features:
            prompt = f"""${prompt} The film synopsis is: "{overview}." """
    
        img = imagellm.new_images_generation().with_prompt(prompt)
        response = img.execute()
        if response.success:
            return ['data:image/png;base64,' + base64.b64encode(response.first_image()).decode('utf-8')]
        return no_update
    

Figure 4: Searching for “Citizen Kane”.

Figure 5: Generating an image from the user inputs.

## Wrapping up

You have a working web application that generates images using LLM Mesh. You can enhance this application by using an LLM to write the image prompts or by using a search engine to collect information directly from the Internet instead of a database. This tutorial is easily adaptable to other use cases for image generation. For example, if you work for a company with brands, you can adapt this tutorial to generate images of your products.

Here is the complete code of the web application:

Attention

The SQL query might be written differently depending on your SQL Engine.

[`app.py`](<../../../../../_downloads/8b8e09e2268d2142e53f642da8f93af2/webapp.py>)
    
    
    from dash import html
    from dash import dcc
    import dash_bootstrap_components as dbc
    from dash.dependencies import Input
    from dash.dependencies import Output
    from dash.dependencies import State
    from dash import no_update
    
    import base64
    import dataiku
    from dataiku import SQLExecutor2
    from dataiku.sql import Constant, toSQL, Dialects
    
    dbc_css = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"
    app.config.external_stylesheets = [dbc.themes.SUPERHERO, dbc_css]
    
    IMG_LLM_ID = ""
    DATASET_NAME = "movies"
    
    USE_TITLE = 1
    USE_YEAR = 2
    USE_OVERVIEW = 3
    USE_GENRE = 4
    
    imagellm = dataiku.api_client().get_default_project().get_llm(IMG_LLM_ID)
    
    # build your Dash app
    v1_layout = html.Div([
        dbc.Row([html.H2("Using LLM Mesh to generate of Poster movie."), ]),
        dbc.Row(dbc.Label("Please enter a name of a movie:")),
        dbc.Row([
            dbc.Col(dbc.Input(id="movie", placeholder="Citizen Kane", debounce=True), width=10),
            dbc.Col(dbc.Button("Search", id="search", color="primary"), width=2)
        ], justify="between", class_name="mt-3 mb-3"),
        dbc.Row([
            dbc.Col(dbc.Label("Select features you want to use for genrating an image:")),
            dbc.Col(dbc.Row([
                dbc.Checklist(
                    options=[
                        {"label": "Use Title", "value": USE_TITLE},
                        {"label": "Use Year", "value": USE_YEAR},
                        {"label": "Use Overview", "value": USE_OVERVIEW},
                        {"label": "Use Genre", "value": USE_GENRE}
                    ],
                    value=[USE_OVERVIEW],
                    id="features",
                    inline=True,
                ),
            ]), width=6),
            dbc.Col(dbc.Button("Generate", id="generate", color="primary"), width=2)
        ], align="center", class_name="mt-3 mb-3"),
        dbc.Row([
            dbc.Col([
                dbc.Row([html.H2("Movie information")]),
                dbc.Row([
                    html.H3(children="", id="title")
                ], align="center", justify="around"),
                dbc.Row([
                    html.H4(children="", id="year")
                ]),
                dbc.Row([
                    html.H4(children="", id="genre")
                ]),
                dbc.Textarea(id="overview", style={"min-height": "500px"})
            ], width=4),
            dbc.Col(html.Img(id="image", src="", width="95%"), width=4),
            dbc.Col(html.Img(id="generatedImg", src="", width="95%"), width=4),
        ], align="center"),
        dbc.Toast(
            [html.P("Searching for information about the movie", className="mb-0"),
             dbc.Spinner(color="primary")],
            id="search-toast",
            header="Querying the database",
            icon="primary",
            is_open=False,
            style={"position": "fixed", "top": "50%", "left": "50%", "transform": "translate(-50%, -50%)"},
        ),
        dbc.Toast(
            [html.P("Generating an image", className="mb-0"),
             dbc.Spinner(color="primary")],
            id="generate-toast",
            header="Querying the LLM",
            icon="primary",
            is_open=False,
            style={"position": "fixed", "top": "50%", "left": "50%", "transform": "translate(-50%, -50%)"},
        ),
    
        dcc.Store(id="step", data=[{"current_step": 0}]),
    ], className="container-fluid mt-3")
    
    app.layout = v1_layout
    
    
    def search(movie_title):
        """
        Search information about a movie
        Args:
            movie_title: title of the movie
        Returns:
            Information of the movie
        """
        dataset = dataiku.Dataset(DATASET_NAME)
        table_name = dataset.get_location_info().get('info', {}).get('quotedResolvedTableName')
        executor = SQLExecutor2(dataset=dataset)
        tid = Constant(str(movie_title))
        escaped_tid = toSQL(tid, dialect=Dialects.POSTGRES)  # Replace by your DB
        query_reader = executor.query_to_iter(
            f"""SELECT "Poster_Link", "Series_Title", "Released_Year", "Overview", "Genre" FROM {table_name} WHERE "Series_Title" = {escaped_tid}""")
        for tupl in query_reader.iter_tuples():
            return tupl
        return None
    
    
    @app.callback([
        Output("image", "src"),
        Output("title", "children"),
        Output("year", "children"),
        Output("genre", "children"),
        Output("overview", "value")
    ],
        Input("search", "n_clicks"),
        State("features", "value"),
        Input("movie", "value"),
        prevent_initial_call=True,
        running=[(Output("search-toast", "is_open"), True, False),
                 (Output("search", "disabled"), True, False),
                 (Output("generate", "disabled"), True, False)
                 ]
    )
    def gather_information(_, value, title):
        info = search(title)
        if info:
            return [info[0], info[1], info[2], info[4], info[3]]
        else:
            return ["", "", "", "", f"""No information concerning the movie: "{title}" """]
    
    
    @app.callback([
        Output("generatedImg", "src"),
    ],
        Input("generate", "n_clicks"),
        State("title", "children"),
        State("year", "children"),
        State("genre", "children"),
        State("overview", "value"),
        State("features", "value"),
        prevent_initial_call=True,
        running=[(Output("generate-toast", "is_open"), True, False),
                 (Output("search", "disabled"), True, False),
                 (Output("generate", "disabled"), True, False)
                 ],
    )
    def generate_image(_, title, year, genre, overview, features):
        prompt = "Generate a poster movie."
        if USE_TITLE in features:
            prompt = f"""${prompt} The title of the movie is: "{title}." """
        if USE_YEAR in features:
            prompt = f"""${prompt} The film was released in: "{year}." """
        if USE_GENRE in features:
            prompt = f"""${prompt} The film genre is: "{year}." """
        if USE_OVERVIEW in features:
            prompt = f"""${prompt} The film synopsis is: "{overview}." """
    
        img = imagellm.new_images_generation().with_prompt(prompt)
        response = img.execute()
        if response.success:
            return ['data:image/png;base64,' + base64.b64encode(response.first_image()).decode('utf-8')]
        return no_update

---

## [tutorials/genai/multimodal/index]

# Multimodal capabilities

Multimodal capabilities refer to a language model’s (LLM) ability to simultaneously process and understand various input types, such as text, images, audio, and video. Initially, these models were focused solely on text, meaning that some could not process any other medium. To utilize the multimodal capabilities of an LLM, it is necessary to use a model trained explicitly on that type of data. Additionally, some LLMs specialize in specific tasks and may be unable to handle others. Therefore, verifying whether the LLM you choose can perform the required processing before you start coding your tasks is essential.

If you need to find some information about the capacity of an LLM, you can use the [`list_llms()`](<../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms") function, as shown in Code 1:

Code 1: finding information about the available LLMs
    
    
    import dataiku
    import pprint
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms(purpose="IMAGE_GENERATION")
    
    for llm in llm_list:
        pprint.pp(llm)
    

The tutorial [Image generation using the LLM Mesh](<images-and-text/images-generation/index.html>) focuses on image generation using a prompt. Therefore, you only need a model capable of generating an image using a prompt.

The tutorial [Mixing text and images: Images labeling with the LLM Mesh](<images-and-text/images-captioning/index.html>) uses an image as an input and a prompt to modify the image. So, you will need an LLM that supports ImageInputs and is prompt-driven.

---

## [tutorials/genai/nlp/create-knowledge-bank/index]

# Creating and using a Knowledge Bank

This tutorial teaches you how to create a [Knowledge Bank](<https://doc.dataiku.com/dss/latest/generative-ai/knowledge/introduction.html> "\(in Dataiku DSS v14\)"). You will then learn how to store the embeddings of your content into the newly created Knowledge Bank. Finally, this tutorial will show you how to use this Knowledge Bank in your RAG.

## Prerequisites

  * Dataiku >= 14.1

  * permission to use a Python code environment with the **RAG and Agents** package set installed, plus the `pypdf` package

  * Python >= 3.9

  * LLM connection to a model able to embed text content




## Creating a Knowledge Bank

Dataiku provides a way to store and manipulate your embedded documents through the [`DSSKnowledgeBank`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBank> "dataikuapi.dss.knowledgebank.DSSKnowledgeBank") class. The first step is to create a Knowledge Bank from your [`DSSProject`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject").

Code 1: Creating your Knowledge Bank
    
    
    import dataiku
    
    
    # Creating your Knowledge Bank
    KB_NAME = ""
    EMBED_LLM_ID = ""
    
    client = dataiku.api_client()
    project = client.get_default_project()
    dss_kb = project.create_knowledge_bank(KB_NAME, "CHROMA", EMBED_LLM_ID)
    

The storage of the vectorized content will be based here on ChromaDB, but you have several other options as per the [`create_knowledge_bank()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_knowledge_bank> "dataikuapi.dss.project.DSSProject.create_knowledge_bank") documentation. The parameter `EMBED_LLM_ID` defines the model that will be used in the next step during vectorization of the content. This [code sample](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-native-llm-list-with-purpose>) will help you find an LLM with the proper purpose.

## Adding content to the Knowledge Bank

Now that we have a Knowledge Bank, we must add the content for our use case. It is a common practice to split the text into smaller chunks before indexing the embedded result. [This tutorial](<../llm-mesh-rag/index.html>) provides more information on the complete process.

Code 2: Adding content to your Knowledge Bank
    
    
    from langchain_community.document_loaders import PyPDFLoader
    try:
        from langchain_text_splitters.character import CharacterTextSplitter
    except ModuleNotFoundError:
        from langchain.text_splitter import CharacterTextSplitter
    
    
    FILE_URL = "https://bit.ly/GEP-Jan-2024" # Update as needed
    
    loader = PyPDFLoader(FILE_URL)
    documents = []
    async for page in loader.alazy_load():
        documents.append(page)
    
    CHUNK_SIZE = 1000
    CHUNK_OVERLAP = 100
    splitter = CharacterTextSplitter(chunk_size=CHUNK_SIZE,
                                     separator='\n',
                                     chunk_overlap=CHUNK_OVERLAP,
                                     length_function=len)
    chunked_documents = splitter.split_documents(documents)
    
    kb_core = dss_kb.as_core_knowledge_bank()
    
    with kb_core.get_writer() as writer:
        langchain_vs = writer.as_langchain_vectorstore()
        langchain_vs.add_documents(chunked_documents)
    

The combination of [`get_writer()`](<../../../../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank.get_writer> "dataiku.KnowledgeBank.get_writer") and [`as_langchain_vectorstore()`](<../../../../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank.as_langchain_vectorstore> "dataiku.KnowledgeBank.as_langchain_vectorstore") will provide access to the vector store. You can then use the [add_documents](<https://python.langchain.com/api_reference/core/vectorstores/langchain_core.vectorstores.base.VectorStore.html#langchain_core.vectorstores.base.VectorStore.add_documents>) method to embed and add the content of your chunks of content.

Caution

This tutorial uses the World Bank’s Global Economic Prospects (GEP) report. If the referenced publication is no longer available, look for the latest report’s PDF version on [this page](<https://www.worldbank.org/en/publication/global-economic-prospects>).

## Using the Knowledge Bank

Once you have a Knowledge Bank with the content you want, you can use it in your RAG. [The tutorial](<../llm-mesh-rag/index.html>) shows you a complete approach, and the Code 3 below is a good reminder of how to do a RAG query.

Code 3: Using the Knowledge Bank
    
    
    try:
        from langchain_classic.chains.question_answering import load_qa_chain
    except ModuleNotFoundError:
        from langchain.chains.question_answering import load_qa_chain
    
    
    LLM_ID = ""  # Fill with your LLM-Mesh id
    
    vector_store = kb_core.as_langchain_vectorstore()
    llm = project.get_llm(llm_id=LLM_ID).as_langchain_chat_model()
    
    # Create the question answering chain
    chain = load_qa_chain(llm, chain_type="stuff")
    query = "What will inflation in Europe look like and why?"
    search_results = vector_store.similarity_search(query)
    
    # ⚡ Get the results ⚡
    resp = chain({"input_documents":search_results, "question": query})
    print(resp["output_text"])
    

## Wrapping up

Congratulations! You are now able to create, enrich, and use a Knowledge Bank. This provides a way to improve and enrich the answers of your LLMs or your Agents.

Here is the complete code of all the steps.

Knowledge Bank tutorial complete code
    
    
    import dataiku
    from langchain_community.document_loaders import PyPDFLoader
    try:
        from langchain_text_splitters.character import CharacterTextSplitter
    except ModuleNotFoundError:
        from langchain.text_splitter import CharacterTextSplitter
    try:
        from langchain_classic.chains.question_answering import load_qa_chain
    except ModuleNotFoundError:
        from langchain.chains.question_answering import load_qa_chain
    
    
    # Creating your Knowledge Bank
    KB_NAME = ""
    EMBED_LLM_ID = ""
    
    client = dataiku.api_client()
    project = client.get_default_project()
    dss_kb = project.create_knowledge_bank(KB_NAME, "CHROMA", EMBED_LLM_ID)
    
    # Adding embeded content to your Knowledge Bank
    FILE_URL = "https://bit.ly/GEP-Jan-2024" # Update as needed
    
    loader = PyPDFLoader(FILE_URL)
    documents = []
    async for page in loader.alazy_load():
        documents.append(page)
    
    CHUNK_SIZE = 1000
    CHUNK_OVERLAP = 100
    splitter = CharacterTextSplitter(chunk_size=CHUNK_SIZE,
                                     separator='\n',
                                     chunk_overlap=CHUNK_OVERLAP,
                                     length_function=len)
    chunked_documents = splitter.split_documents(documents)
    
    kb_core = dss_kb.as_core_knowledge_bank()
    
    with kb_core.get_writer() as writer:
        langchain_vs = writer.as_langchain_vectorstore()
        langchain_vs.add_documents(chunked_documents)
    
    # Query a LLM with improved context from your Knowledge Bank
    LLM_ID = ""  # Fill with your LLM-Mesh id
    
    vector_store = kb_core.as_langchain_vectorstore()
    llm = project.get_llm(llm_id=LLM_ID).as_langchain_chat_model()
    
    # Create the question answering chain
    chain = load_qa_chain(llm, chain_type="stuff")
    query = "What will inflation in Europe look like and why?"
    search_results = vector_store.similarity_search(query)
    
    # ⚡ Get the results ⚡
    resp = chain({"input_documents":search_results, "question": query})
    print(resp["output_text"])
    

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.knowledgebank.DSSKnowledgeBank`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBank> "dataikuapi.dss.knowledgebank.DSSKnowledgeBank")(...) | A handle to interact with a DSS-managed knowledge bank.  
[`dataikuapi.dss.project.DSSProject`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject> "dataikuapi.dss.project.DSSProject")(client, ...) | A handle to interact with a project on the DSS instance.  
[`dataiku.KnowledgeBank`](<../../../../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank> "dataiku.KnowledgeBank")(id[, project_key, ...]) | This is a handle to interact with a Dataiku Knowledge Bank flow object  
  
### Functions

[`as_core_knowledge_bank`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.knowledgebank.DSSKnowledgeBank.as_core_knowledge_bank> "dataikuapi.dss.knowledgebank.DSSKnowledgeBank.as_core_knowledge_bank")() | Get the [`dataiku.KnowledgeBank`](<../../../../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank> "dataiku.KnowledgeBank") object corresponding to this knowledge bank  
---|---  
[`as_langchain_chat_model`](<../../../../api-reference/python/llm-mesh.html#dataikuapi.dss.llm.DSSLLM.as_langchain_chat_model> "dataikuapi.dss.llm.DSSLLM.as_langchain_chat_model")(**data) | Create a langchain-compatible chat LLM object for this LLM.  
[`as_langchain_vectorstore`](<../../../../api-reference/python/llm-mesh.html#dataiku.core.vector_stores.data.writer.VectorStoreWriter.as_langchain_vectorstore> "dataiku.core.vector_stores.data.writer.VectorStoreWriter.as_langchain_vectorstore")(**vectorstore_kwargs) | Gets this writer as a Langchain Vectorstore object  
[`as_langchain_vectorstore`](<../../../../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank.as_langchain_vectorstore> "dataiku.KnowledgeBank.as_langchain_vectorstore")(**vectorstore_kwargs) | Get the current version of this knowledge bank as a Langchain Vectorstore object.  
[`create_knowledge_bank`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.create_knowledge_bank> "dataikuapi.dss.project.DSSProject.create_knowledge_bank")(name, ...[, settings]) | Create a new knowledge bank in the project, and return a handle to interact with it  
[`get_default_project`](<../../../../api-reference/python/client.html#dataikuapi.DSSClient.get_default_project> "dataikuapi.DSSClient.get_default_project")() | Get a handle to the current default project, if available (i.e.  
[`get_writer`](<../../../../api-reference/python/llm-mesh.html#dataiku.KnowledgeBank.get_writer> "dataiku.KnowledgeBank.get_writer")() | Gets a writer on the latest vector store files on disk.

---

## [tutorials/genai/nlp/fine-tuning-embedding-model/index]

# Customizing a Text Embedding Model for RAG Applications

The embedding model used to create and retrieve context from a Knowledge Bank is a crucial building block of an RAG pipeline. Typical embedding models available out-of-the-box today have been pre-trained on generic data, which can limit their effectiveness for company or domain-specific use cases. Fine-tuning an embedding model can significantly improve the quality of retrieved documents and the coherence of generated responses.

In this tutorial, we walk you through customizing a text embedding model for an RAG application based on highly technical scientific content from fields like Physics, Chemistry, or Biology.

## Prerequisites

  * Dataiku > 13.3

  * The Scientific Question Answering dataset from the Ai2 non-profit AI research institute. It is available both on the [HuggingFace Hub](<https://huggingface.co/datasets/allenai/sciq>) and [Kaggle](<https://www.kaggle.com/datasets/thedevastator/sciq-a-dataset-for-science-question-answering/data>). It contains more than 13k crowdsourced science multiple-choice questions, with an additional paragraph that provides supporting evidence for the correct answer.

  * The [Sentence Transformers package](<https://www.sbert.net/index.html#>), maintained today by HuggingFace.

  * A [code environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html> "\(in Dataiku DSS v14\)") with a Python version 3.10 and with the following packages:
        
        accelerate>=0.21.0
        sentence-transformers
        datasets
        transformers
        




## Preparing the embedding dataset

The goal is to fine-tune the model to better find (and retrieve) the appropriate context for a given question. In other words, we want the model to learn the semantic similarity of highly technical scientific texts.

For this, we leverage the `question` and `support` columns of our input dataset as positive pairs of `(query, context)`.

We used a _Prepare recipe_ to keep only those two columns and renamed them `anchor` and `positive`, respectively. We also removed the rows where `positive` was empty and added an `_id` column. This is an important step since `sentence_transformers` expects input datasets and column names to match the exact format used by the target loss function for your use case.

We also used a _Split recipe_ to create train and test datasets (80/20) randomly.
    
    
    import dataiku
    import os
    import tempfile
    
    from datasets import Dataset, concatenate_datasets
    
    from sentence_transformers import SentenceTransformer
    from sentence_transformers.evaluation import InformationRetrievalEvaluator
    from sentence_transformers.losses import MultipleNegativesRankingLoss
    from sentence_transformers import SentenceTransformerTrainingArguments, SentenceTransformerTrainer
    from sentence_transformers.training_args import BatchSamplers
    
    
    # Load the Dataiku datasets as Pandas dataframes
    sci_qa_train_df = dataiku.Dataset("sci_q_and_a_train").get_dataframe()
    sci_qa_test_df = dataiku.Dataset("sci_q_and_a_test").get_dataframe()
    
    # And then from Pandas dataframes to Datasets (to be used by the trainer)
    sci_qa_train = Dataset.from_pandas(sci_qa_train_df)
    sci_qa_test = Dataset.from_pandas(sci_qa_test_df)
    
    

## Loading the embedding model

We use the embedding model [all-MiniLM-L6-v2](<https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2>) from the Hugging Face Hub. We chose a small model that can be easily fine-tuned, even on a CPU. But you can try any model with the `sentence-transformers` tag.
    
    
    model_id = "sentence-transformers/all-MiniLM-L6-v2"
    model = SentenceTransformer(model_id)
    

## Creating an evaluator and evaluating the base model

We will use the `InformationRetrievalEvaluator` to evaluate the performance of our model. For a given set of queries, it will retrieve the top-k most similar document out of a corpus (`k = 1` in our case). It then computes several metrics based on Mean Reciprocal Rank (MRR), Recall@k, Mean Average Precision (MAP), and Normalized Discounted Cumulative Gain (NDCG). NDCG is a good measure of ranking quality, so we’ll focus on this one here.

The queries come from our test set, and we create the corpus for potential retrieval from all “documents” from the train and test split.
    
    
    sci_qa_corpus = concatenate_datasets([sci_qa_train, sci_qa_test])
    # Convert the datasets to dictionaries
    corpus = dict(
        zip(sci_qa_corpus["_id"], sci_qa_corpus["positive"])
    )  # Our corpus (cid => document)
    queries = dict(
        zip(sci_qa_test["_id"], sci_qa_test["anchor"])
    )  # Our queries (qid => question)
    
    # Create a mapping of relevant document for each query
    relevant_docs = {}  # Query ID to relevant documents (qid => set([relevant_cids])
    for q_id in queries:
        relevant_docs[q_id] = [q_id] # The only revelant document, 
                                     # in our case, has the same id as the query
    
    # Given queries, a corpus and a mapping with relevant documents,
    # the InformationRetrievalEvaluator computes different IR metrics.
    ir_evaluator = InformationRetrievalEvaluator(
        queries=queries,
        corpus=corpus,
        relevant_docs=relevant_docs,
    )
    results = ir_evaluator(model)
    # print(f"cosine_ndcg@10: {results['cosine_ndcg@10']}")
    #   --> this gave use a baseline of ~0.67
    

## Initializing the loss function

We employ the standard `MultipleNegativesRankingLoss`, a well-established method in the field. This approach necessitates using positive text pairs with an anchor and a corresponding positive sample.
    
    
    training_loss = MultipleNegativesRankingLoss(model)
    

## Creating a trainer and fine-tuning the embedding model
    
    
    # Managed folder to store the fine-tuned model
    folder = dataiku.Folder("a_valid_managed_folder_id")
    
    with tempfile.TemporaryDirectory() as temp_dir:
        
        # Define training arguments
        args = SentenceTransformerTrainingArguments(
            # Required parameter:
            output_dir=temp_dir,
            
            # Optional training parameters:
            num_train_epochs=2,                        # number of epochs
            per_device_train_batch_size=8,             # train batch size
            gradient_accumulation_steps=8,             # for a global batch size of 64 (= 8 * 8)
            per_device_eval_batch_size=8,              # evaluation batch size
            learning_rate=2e-5,                        # learning rate
            warmup_ratio=0.1,                          # warmup ratio
            fp16=True,                                 # use fp16 precision (set to False if your GPU can't run on FP16)
            bf16=False,                                # use bf16 precision (set to True if your GPU can run on BF16)
            batch_sampler=BatchSamplers.NO_DUPLICATES, # losses that use "in-batch negatives" benefit from no duplicates
            
            # Optional tracking/debugging parameters:
            eval_strategy="epoch",                     # evaluate after each epoch
            save_strategy="no",                        # save after each epoch
            save_total_limit=2,                        # save the last 2 models
            save_only_model=True,                      # for each checkpoints, save only the model (no optimizer.pt/scheduler.pt) 
            logging_steps=100,                         # log every 100 steps
        )
        
        # Create a trainer & train. 
        embedding_trainer = SentenceTransformerTrainer(
            model=model,
            args=args,
            train_dataset=sci_qa_train.select_columns(
                ["anchor", "positive"]
            ),  # training dataset,
            loss=training_loss,
            evaluator=ir_evaluator,
        )
        embedding_trainer.train()
        
        # Save the fine-tuned model in the managed folder
        embedding_trainer.save_model(output_dir=temp_dir)
        for root, dirs, files in os.walk(temp_dir):
            for file in files:
                source_path = os.path.join(root, file)
                target_path = os.path.relpath(source_path, temp_dir)
                folder.upload_file(target_path, source_path)
    
    

Here, we don’t provide an eval dataset directly; we only provide the evaluator. It gives us more interesting metrics. The total number of training steps is:

\\[\text{nb_of_epochs} \times \frac{\text{size_of_training_dataset}}{(\text{batch_size} \times \text{gradient_accumulation_steps})}\\]

## Evaluating the model against baseline
    
    
    results_ft = ir_evaluator(embedding_trainer.model)
    # print(f"cosine_ndcg@10: {results['cosine_ndcg@10']}") 
    #   --> this gave use a baseline of ~0.77, which represents a 15% performance increase !
    

## Wrapping up

This tutorial demonstrated how to fine-tune an embedding model on technical, scientific content using the Sentence Transformers package. By following the steps to prepare your dataset, load the model, and fine-tune it, you can enhance document retrieval and response coherence in your Retrieval-Augmented Generation (RAG) applications for various domain-specific use cases.

Here is the complete code for this tutorial:

[`app.py`](<../../../../_downloads/865cb4b4ae75e79defcacc80f6f099d3/app.py>)
    
    
    import dataiku
    import os
    import tempfile
    
    from datasets import Dataset, concatenate_datasets
    
    from sentence_transformers import SentenceTransformer
    from sentence_transformers.evaluation import InformationRetrievalEvaluator
    from sentence_transformers.losses import MultipleNegativesRankingLoss
    from sentence_transformers import SentenceTransformerTrainingArguments, SentenceTransformerTrainer
    from sentence_transformers.training_args import BatchSamplers
    
    
    # Load the Dataiku datasets as Pandas dataframes
    sci_qa_train_df = dataiku.Dataset("sci_q_and_a_train").get_dataframe()
    sci_qa_test_df = dataiku.Dataset("sci_q_and_a_test").get_dataframe()
    
    # And then from Pandas dataframes to Datasets (to be used by the trainer)
    sci_qa_train = Dataset.from_pandas(sci_qa_train_df)
    sci_qa_test = Dataset.from_pandas(sci_qa_test_df)
    
    model_id = "sentence-transformers/all-MiniLM-L6-v2"
    model = SentenceTransformer(model_id)
    
    sci_qa_corpus = concatenate_datasets([sci_qa_train, sci_qa_test])
    # Convert the datasets to dictionaries
    corpus = dict(
        zip(sci_qa_corpus["_id"], sci_qa_corpus["positive"])
    )  # Our corpus (cid => document)
    queries = dict(
        zip(sci_qa_test["_id"], sci_qa_test["anchor"])
    )  # Our queries (qid => question)
    
    # Create a mapping of relevant document for each query
    relevant_docs = {}  # Query ID to relevant documents (qid => set([relevant_cids])
    for q_id in queries:
        relevant_docs[q_id] = [q_id] # The only revelant document, 
                                     # in our case, has the same id as the query
    
    # Given queries, a corpus and a mapping with relevant documents,
    # the InformationRetrievalEvaluator computes different IR metrics.
    ir_evaluator = InformationRetrievalEvaluator(
        queries=queries,
        corpus=corpus,
        relevant_docs=relevant_docs,
    )
    results = ir_evaluator(model)
    # print(f"cosine_ndcg@10: {results['cosine_ndcg@10']}")
    #   --> this gave use a baseline of ~0.67
    
    training_loss = MultipleNegativesRankingLoss(model)
    
    # Managed folder to store the fine-tuned model
    folder = dataiku.Folder("a_valid_managed_folder_id")
    
    with tempfile.TemporaryDirectory() as temp_dir:
        
        # Define training arguments
        args = SentenceTransformerTrainingArguments(
            # Required parameter:
            output_dir=temp_dir,
            
            # Optional training parameters:
            num_train_epochs=2,                        # number of epochs
            per_device_train_batch_size=8,             # train batch size
            gradient_accumulation_steps=8,             # for a global batch size of 64 (= 8 * 8)
            per_device_eval_batch_size=8,              # evaluation batch size
            learning_rate=2e-5,                        # learning rate
            warmup_ratio=0.1,                          # warmup ratio
            fp16=True,                                 # use fp16 precision (set to False if your GPU can't run on FP16)
            bf16=False,                                # use bf16 precision (set to True if your GPU can run on BF16)
            batch_sampler=BatchSamplers.NO_DUPLICATES, # losses that use "in-batch negatives" benefit from no duplicates
            
            # Optional tracking/debugging parameters:
            eval_strategy="epoch",                     # evaluate after each epoch
            save_strategy="no",                        # save after each epoch
            save_total_limit=2,                        # save the last 2 models
            save_only_model=True,                      # for each checkpoints, save only the model (no optimizer.pt/scheduler.pt) 
            logging_steps=100,                         # log every 100 steps
        )
        
        # Create a trainer & train. 
        embedding_trainer = SentenceTransformerTrainer(
            model=model,
            args=args,
            train_dataset=sci_qa_train.select_columns(
                ["anchor", "positive"]
            ),  # training dataset,
            loss=training_loss,
            evaluator=ir_evaluator,
        )
        embedding_trainer.train()
        
        # Save the fine-tuned model in the managed folder
        embedding_trainer.save_model(output_dir=temp_dir)
        for root, dirs, files in os.walk(temp_dir):
            for file in files:
                source_path = os.path.join(root, file)
                target_path = os.path.relpath(source_path, temp_dir)
                folder.upload_file(target_path, source_path)
    
    results_ft = ir_evaluator(embedding_trainer.model)
    # print(f"cosine_ndcg@10: {results['cosine_ndcg@10']}") 
    #   --> this gave use a baseline of ~0.77, which represents a 15% performance increase !

---

## [tutorials/genai/nlp/improve-kb-rag/index]

# RAG: Improving your Knowledge Bank retrieval

Once you have created a Knowledge Bank and used it as the base of your RAG, for example, after following the [Programmatic RAG with Dataiku’s LLM Mesh](<../llm-mesh-rag/index.html>) tutorial, you can improve the quality of your retrieval with an additional pre-retrieval step.

## Prerequisites

  * Dataiku >= 13.4

  * An OpenAI connection

  * Python >= 3.9

  * A code environment with the following packages:
        
        langchain           #tested with 0.3.13
        langchain-chroma    #tested with 0.1.4
        langchain-community #tested with 0.3.13
        langchain-core      #tested with 0.3.63
        




Additionally, we will start with the RAG developed during the [Programmatic RAG with Dataiku’s LLM Mesh](<../llm-mesh-rag/index.html>) tutorial. As described in this previous tutorial, you will need the corresponding prerequisites.

## Introduction

When a user prompt is processed by a RAG, the workflow usually involves first querying the vector store and using the result to enrich the context of the LLM query. This tutorial will explain how to improve the final answer by enhancing the initial prompt before retrieval. This additional step will clarify, rephrase, and expand the original prompt to match the context. This step will result in a broader set of relevant documents retrieved, improving the global answer’s precision.

## Starter code for your RAG

The code below is a starter code for your RAG. You define access to the Knowledge Bank with the embedded documents, and then use the corresponding vector store to run an enriched LLM query.

initial_rag.py

Code 1: Starter code for your RAG
    
    
    import dataiku
    from dataiku.langchain.dku_llm import DKUChatModel
    from langchain.chains.combine_documents import create_stuff_documents_chain
    from langchain_core.prompts import ChatPromptTemplate
    
    LLM_ID = "<fill with your LLM Id>"
    KB_ID = "fill with your Knowledge Bank Id"
    
    # Retrieve the vectore store through the Knowledge Bank
    client = dataiku.api_client()
    project = client.get_default_project()
    kb = dataiku.KnowledgeBank(id=KB_ID, project_key=project.project_key)
    vector_store = kb.as_langchain_vectorstore()
    
    # Create the LLM access
    dkullm = DKUChatModel(llm_id=LLM_ID, temperature=0)
    system_prompt = """Always state when an answer is unknown. Do not guess or fabricate a response.
        {context}"""
    prompt = ChatPromptTemplate.from_messages(
        [
            ("system", system_prompt),
            ("human", "{input}"),
        ]
    )
    # Create the chain that will combine documents in the context with the prompt
    question_answer_chain = create_stuff_documents_chain(dkullm, prompt)
    
    # an example user query
    user_query = "What will inflation in Europe look like and why?"
    
    # First, perform a similarity search with the vector store
    search_results = vector_store.similarity_search(user_query, k=10)
    
    # Run the enriched query
    resp = question_answer_chain.invoke({"context": search_results, "input": user_query})
    print(resp)
    

## Rewriting the query

If you want to improve the answer from your RAG system, you can first improve the original query. The goal is to design the system prompt to guide the query’s rewriting process, clarifying and expanding what was originally input. The following code shows how to add this rewriting.

> Code 2: Add a query rewriting before the RAG query
>     
>     
>     import dataiku
>     from langchain.chains.combine_documents import create_stuff_documents_chain
>     from langchain_core.prompts import ChatPromptTemplate
>     
>     LLM_ID = "<fill with your LLM Id>"
>     KB_ID = "fill with your Knowledge Bank Id"
>     
>     # Retrieve the vectore store through the Knowledge Bank
>     client = dataiku.api_client()
>     project = client.get_default_project()
>     kb = dataiku.KnowledgeBank(id=KB_ID, project_key=project.project_key)
>     vector_store = kb.as_langchain_vectorstore()
>     
>     # Get access to your LLM
>     llm = project.get_llm(LLM_ID)
>     
>     # define the system prompt to guide the rewriting process of the query
>     improve_system = """You are a helpful assistant improving search quality. 
>     Rewrite the following query to make it more specific, detailed, and clear for a document search system."""
>     
>     # an example user query
>     user_query = "What will inflation in Europe look like and why?"
>     
>     # Query your LLM to obtain a rephrased query
>     improve = llm.new_completion()
>     improve.settings["temperature"] = 0.1
>     improve.with_message(message=improve_system, role="system")
>     improve.with_message(message=user_query, role="user")
>     resp = improve.execute()
>     improved_query = resp.text
>     
>     print(f"Original query is:\n {user_query}")
>     print(f"Improved query is:\n {improved_query}")
>     
>     # Create the LLM access
>     dkullm = DKUChatModel(llm_id=LLM_ID, temperature=0)
>     system_prompt = """Always state when an answer is unknown. Do not guess or fabricate a response.
>         {context}"""
>     prompt = ChatPromptTemplate.from_messages(
>         [
>             ("system", system_prompt),
>             ("human", "{input}"),
>         ]
>     )
>     # Create the chain that will combine documents in the context with the prompt
>     question_answer_chain = create_stuff_documents_chain(dkullm, prompt)
>     
>     # First, perform a similarity search with the vector store
>     search_results = vector_store.similarity_search(improved_query, k=10)
>     
>     # Run the enriched query
>     resp = question_answer_chain.invoke(
>         {"context": search_results, "input": improved_query}
>     )
>     print(resp)
>     

For example, an original query like `inflation in Europe` may be improved by asking `What are the projected inflation trends in Europe for the next year, and what are the key factors influencing these trends?` You have to tailor the system prompt to rewrite the query according to the context of your project.

## Wrapping up

Congratulations! You are now able to improve the results coming from your RAG. Depending on the context of your usage, you may also use techniques like semantic enrichment or multi-query expansion.

---

## [tutorials/genai/nlp/index]

# Natural Language Processing & Generation

  * [Programmatic RAG with Dataiku’s LLM Mesh and Langchain](<llm-mesh-rag/index.html>)

  * [RAG: Improving your Knowledge Bank retrieval](<improve-kb-rag/index.html>)

  * [Creating and using a Knowledge Bank](<create-knowledge-bank/index.html>)

  * [Using LLM Mesh to benchmark zero-shot classification models](<llm-mesh-zero-shot/index.html>)

  * [Zero-shot text classification with the LLM Mesh](<llm-zero-shot-clf/index.html>)

  * [Few-shot classification with the LLM Mesh](<llm-mesh-few-shot-clf/index.html>)

  * [Using OpenAI-compatible API calls via the LLM Mesh](<openaiXmesh/index.html>)



  * [Customizing a Text Embedding Model for RAG Applications](<fine-tuning-embedding-model/index.html>)

---

## [tutorials/genai/nlp/llm-mesh-few-shot-clf/index]

# Few-shot classification with the LLM Mesh

In the [zero-shot classification tutorial](<../llm-zero-shot-clf/index.html>), you learned how to build a classifier that can perform reasonably well on a task that has not been explicitly trained. However, additional steps are required in other scenarios where the classification task can be more difficult.

In this tutorial, you will learn about few-shot learning, a convenient way to improve the model’s performance by showing relevant examples without retraining or fine-tuning it. You will also dive deeper into understanding prompt tokens and see how LLMs can be evaluated.

## Prerequisites

  * Dataiku >= 13.1

  * “Use” permission on a code environment using Python >= 3.9 with the following packages:

    * `langchain` (tested with version 0.2.0)

    * `transformers` (tested with version 4.43.3)

    * `scikit-learn` (tested with version 1.2.2)

  * Access to an existing project with the following permissions:

    * “Read project content”

    * “Write project content”

  * An LLM Mesh connection (to get a valid LLM ID, please refer to [this documentation](<../../../../concepts-and-examples/llm-mesh.html#ce-llm-mesh-get-llm-id>))

  * Reading and implementing the [tutorial on zero-shot classification](<../llm-zero-shot-clf/index.html>)




## Preparing the data

For this tutorial, you will work on a different dataset to predict more than two classes. This dataset is part of the [Amazon Review Dataset](<https://nijianmo.github.io/amazon/index.html>), and contains an extract of the “Magazine subscriptions” category. Download the data file [here](<https://jmcauley.ucsd.edu/data/amazon_v2/categoryFilesSmall/Magazine_Subscriptions_5.json.gz>) and create a dataset called `reviews_magazines` with it in your project.

### Counting tokens

Language models process text as _tokens_ , which are recurring sequences of characters, to understand the statistical links between them and infer the next probable ones. Counting tokens in a text input is helpful because:

  * It is the main pricing unit for managed LLM services (more details on [OpenAI’s dedicated page](<https://openai.com/chatgpt/pricing>)),

  * It can specify minimum/maximum thresholds for input and output lengths.




You will use the method `get_num_tokens()` to enrich your dataset with the number of tokens per review.

### Binning ratings and splitting the data

Next, select the `reviews_magazines` dataset; create a Python recipe with two outputs called `reviews_mag_train` and `reviews_mag_test`; copy Code 1 as the recipe’s content.

Code 1: compute_reviews_mag_train.py
    
    
    import dataiku
    import random
    
    LLM_ID = "" # Fill with your LLM-Mesh id
    lc_llm = dataiku.api_client().get_default_project().get_llm(LLM_ID).as_langchain_llm()
    
    
    def bin_score(x):
        return 'pos' if float(x) >= 4.0 else ('ntr' if float(x) == 3.0 else 'neg')
    
    
    random.seed(1337)
    
    input_dataset = dataiku.Dataset("reviews_magazines")
    
    output_schema = [
        {"type": "string", "name": "reviewText"},
        {"type": "int", "name": "nb_tokens"},
        {"type": "string", "name": "sentiment"}
    ]
    train_dataset = dataiku.Dataset("reviews_mag_train")
    train_dataset.write_schema(output_schema)
    w_train = train_dataset.get_writer()
    
    test_dataset = dataiku.Dataset("reviews_mag_test")
    test_dataset.write_schema(output_schema)
    w_test = test_dataset.get_writer()
    
    for r in input_dataset.iter_rows():
        text = r.get("reviewText")
        if len(text) > 0:
            out_row = {
                "reviewText": text,
                "nb_tokens": lc_llm.get_num_tokens(text),
                "sentiment": bin_score(r.get("overall"))
            }
            rnd = random.random()
            if rnd < 0.5:
                w_train.write_row_dict(out_row)
            else:
                w_test.write_row_dict(out_row)
    
    w_train.close()
    w_test.close()
    

This code bins the rating scores from the `overall` column into a new categorical column called `sentiment` where the values can be either:

  * `pos` (positive) for ratings \\(\geq 4\\),

  * `ntr` (neutral) for ratings \\(=3\\),

  * `neg` (negative) otherwise.




It also removes useless columns to keep only `sentiment` and `reviewText` (the content of the user review) and randomly dispatches output rows between:

  * `reviews_mag_test` on which you’ll run and evaluate your classifier,

  * `reviews_mag_train` which role will be explained later.




## Building a zero-shot-based baseline

Establish a baseline using a zero-shot classification prompt on the test dataset.

### Defining the prompt

Create a directory named `utils` in your project library and create `chat.py` with the content shown in Code 2.

Code 2: chat.py
    
    
    from dataikuapi.dss.langchain import DKUChatModel
    from langchain_core.messages import HumanMessage, SystemMessage, AIMessage
    import json
    from typing import Dict, List
    
    
    def predict_sentiment(chat: DKUChatModel, review: str):
        system_msg = """
        You are an assistant that classifies reviews according to their sentiment. 
        Respond strictly with this JSON format: {"llm_sentiment": "xxx"} where xxx should only be either: 
        pos if the review is positive 
        ntr if the review is neutral or does not contain enough information 
        neg if the review is negative 
        No other value is allowed.
        """
    
        messages = [
            SystemMessage(content=system_msg),
            HumanMessage(content=f"""Review: {review}""")
        ]
        resp = chat.invoke(messages)
        return json.loads(resp.content)
    
    

`predict_sentiment()` defines the multi-class classification task by telling the model which classes to expect (`pos`, `ntr`, `neg`) and how to format the output.

From there you can write the code for the zero-shot run.

### Running and evaluating the model

Create and run a Python recipe using `reviews_mag_test` as input and a new dataset called `test_zs_scored` as output, then add the following code:

Code 3: compute_test_zs_scored.py
    
    
    import dataiku
    from utils.chat import predict_sentiment
    
    LLM_ID = "" # Fill with your LLM-Mesh id
    chat = dataiku.api_client().get_default_project().get_llm(LLM_ID).as_langchain_chat_model(temperature=0)
    
    input_dataset = dataiku.Dataset("reviews_mag_test")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"},
        {"type": "int", "name": "nb_tokens"}
    ]
    output_schema = input_dataset.read_schema() + new_cols
    output_dataset = dataiku.Dataset("test_zs_scored")
    output_dataset.write_schema(output_schema)
    
    # Run prompts on test dataset
    with output_dataset.get_writer() as w:
        for i, r in enumerate(input_dataset.iter_rows()):
            print(f"{i+1}")
            out_row = {}
            # Keep columns from input dataset
            out_row.update(dict(r))
            # Add LLM output
            out_row.update(predict_sentiment(chat=chat,
                                             review=r.get("reviewText")))
            w.write_row_dict(out_row)
    

That recipe iterates over the test dataset and infers the review text’s sentiment in the `llm_sentiment` column. Once the `test_zs_scored` dataset is built, you can evaluate your classifier’s performance: in your project library, create a new file under `utils` called `evaluate.py` with Code 4.

Code 4: evaluate.py
    
    
    import pandas as pd
    
    from sklearn.metrics import precision_score
    from sklearn.metrics import recall_score
    from typing import Dict
    
    
    def get_classif_metrics(df: pd.DataFrame,
                            pred_col: str,
                            truth_col: str) -> Dict[str, float]:
        metrics = {
            "precision": precision_score(y_pred=df[pred_col],
                                         y_true=df[truth_col],
                                         average="macro"),
            "recall": recall_score(y_pred=df[pred_col],
                                   y_true=df[truth_col],
                                   average="macro")
        }
        return metrics
    

You can now use the `get_classif_metrics()` function to compute the precision and recall scores on the test dataset by running Code 5 in a notebook.

Code 5: evaluate test_zs_scored
    
    
    import warnings
    warnings.filterwarnings('ignore')
    
    ###
    import dataiku
    from utils.evaluate import get_classif_metrics
    
    df = dataiku.Dataset("test_zs_scored") \
        .get_dataframe(columns=["sentiment", "llm_sentiment"])
    metrics_zs = get_classif_metrics(df, "llm_sentiment", "sentiment")
    print(metrics_zs)
    ###
    
    
    
    {'precision': 0.61, 'recall': 0.71}
    

## Implementing few-shot learning

Next, you’ll attempt to improve the baseline model’s performance using _few-shot learning_ , which supplements the model with training examples via the prompt without requiring retraining.

There are many ways to identify relevant training examples; in this tutorial, you will use a relatively intuitive approach:

  * Start by running a zero-shot classification on the training dataset,

  * Flag a subset of the resulting false positives/negatives to add to your prompt at evaluation time.




### Retrieving relevant examples

Create and run a Python recipe using `reviews_mag_train` as input and a new dataset called `train_fs_examples` as output with the Code 6 as content.

Code 6: compute_train_fs_examples.py
    
    
    import dataiku
    from utils.chat import predict_sentiment
    
    SIZE_EX_MIN = 20
    SIZE_EX_MAX = 100
    NB_EX_MAX = 10
    
    LLM_ID = "" # Fill with your LLM-Mesh id
    chat = dataiku.api_client().get_default_project().get_llm(LLM_ID).as_langchain_chat_model(temperature=0)
    
    input_dataset = dataiku.Dataset("reviews_mag_train")
    input_schema = input_dataset.read_schema()
    
    output_dataset = dataiku.Dataset("train_fs_examples")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"}
    ]
    output_schema = input_schema + new_cols
    output_dataset.write_schema(output_schema)
    
    nb_ex = 0
    with output_dataset.get_writer() as w:
        for r in input_dataset.iter_rows():
            # Check token-base length
            nb_tokens = r.get("nb_tokens")
            if nb_tokens > SIZE_EX_MIN and nb_tokens < SIZE_EX_MAX:
                pred = predict_sentiment(chat, r.get("reviewText"))
    
                # Keep prediction only if it was mistaken
                if pred["llm_sentiment"] != r.get("sentiment"):
                    out_row = dict(r)
                    out_row["llm_sentiment"] = pred["llm_sentiment"]
                    w.write_row_dict(out_row)
                    nb_ex += 1
                    if nb_ex == NB_EX_MAX:
                        break
    

This code iterates over the training data, filters out the reviews whose (token-based) size is not between `SIZE_EX_MIN` and `SIZE_EX_MAX`, and then writes the prediction in the output dataset _only if it was mistaken_. There is also a limit of 10 examples defined by `NB_EX_MAX` to make sure that at evaluation time, the augmented prompts do not increase the model’s cost and execution time too much.

### Running and evaluating the new model

The next step is incorporating those examples into your prompt before re-running the classification process.

Let’s start by updating the prompt: Examples are added as user/assistant exchanges following the system message when using the LLM. To apply this, in your project library’s `chat.py` file, add the following functions:

Code 7: chat.py
    
    
    def build_example_msg(rec: Dict) -> List[Dict]:
        example = [
            {"Review": rec['reviewText'], "llm_sentiment": rec['sentiment']}
        ]
        return example
    

The `build_example_msg()` function helps transform a record’s raw data into dicts that follow the Langchain message formalism.

Code 8: chat.py
    
    
    def predict_sentiment_fs(chat: DKUChatModel, review: str, examples: List):
        system_msg = """
        You are an assistant that classifies reviews according to their sentiment. 
        Respond strictly with this JSON format: {"llm_sentiment": "xxx"} where xxx should only be either: 
        pos if the review is positive 
        ntr if the review is neutral or does not contain enough information 
        neg if the review is negative 
        No other value is allowed.
        """
    
        messages = [
            SystemMessage(content=system_msg),
        ]
        for ex in examples:
            messages.append(HumanMessage(ex.get('Review')))
            messages.append(AIMessage(ex.get('llm_sentiment')))
    
        messages.append(HumanMessage(content=f"""Review: {review}"""))
    
        resp = chat.invoke(messages)
        return {'llm_sentiment': resp.content}
    

The `predict_sentiment_fs()` function is a modified version of `predict_sentiment()` that adds a new `examples` argument to enrich the prompt for few-shot learning.

With these new tools, you can execute a few-shot learning run on the test dataset! Create a Python recipe with `train_fs_examples` and `reviews_mag_test` as input, and a new output dataset called `test_fs_scored` and Code 9 as content.

Code 9: compute_test_fs_scored.py
    
    
    import dataiku
    from utils.chat import predict_sentiment_fs
    from utils.chat import build_example_msg
    
    MIN_EX_LEN = 5
    MAX_EX_LEN = 200
    MAX_NB_EX = 10
    
    LLM_ID = "" # Fill with your LLM-Mesh id
    chat = dataiku.api_client().get_default_project().get_llm(LLM_ID).as_langchain_chat_model(temperature=0)
    
    input_dataset = dataiku.Dataset("reviews_mag_test")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"},
    ]
    
    # Retrieve a few examples from the training dataset
    examples_dataset = dataiku.Dataset("train_fs_examples")
    ex_to_add = []
    tot_tokens = 0
    for r in examples_dataset.iter_rows():
        nb_tokens = r.get("nb_tokens")
        if (nb_tokens > MIN_EX_LEN and nb_tokens < MAX_EX_LEN):
            ex_to_add += build_example_msg(dict(r))
            tot_tokens += nb_tokens
            if len(ex_to_add) == MAX_NB_EX:
                print(f"Total tokens = {tot_tokens}")
                break
    
    output_schema = input_dataset.read_schema() + new_cols
    output_dataset = dataiku.Dataset("test_fs_scored")
    output_dataset.write_schema(output_schema)
    
    # Run prompts on test dataset
    with output_dataset.get_writer() as w:
        for i, r in enumerate(input_dataset.iter_rows()):
            out_row = {}
            # Keep columns from input dataset
            out_row.update(dict(r))
            # Add LLM output
            result = predict_sentiment_fs(chat=chat,
                                          review=r.get("reviewText"),
                                          examples=ex_to_add)
            if result:
                out_row.update(result)
            w.write_row_dict(out_row)
    

You can now finally assess the benefits of few-shot learning by comparing the classifier’s performance with and without the examples! To do so, run this code in a notebook:
    
    
    ###
    import dataiku
    from utils.evaluate import get_classif_metrics
    
    df = dataiku.Dataset("test_fs_scored") \
        .get_dataframe(columns=["sentiment", "llm_sentiment"])
    metrics_fs = get_classif_metrics(df, "llm_sentiment", "sentiment")
    print(metrics_fs)
    ###
    
    
    
    {'precision': 0.48, 'recall': 0.54}
    

Your Flow has reached its final form and should look like this:

## Wrapping up

Congratulations on finishing this (lengthy!) tutorial on few-shot learning! You now have a better overview of how to enrich a prompt to improve the behavior of an LLM on a classification task. Feel free to play with the prompt and the various parameters to see how they can influence the model’s performance! You can also explore other leads to improve the tutorial’s code:

  * From an ML perspective, the datasets suffer from class imbalance since there are many more positive reviews than negative or neutral ones. You can mitigate that by resampling the initial dataset or by setting up class weights. You can also adjust the number and classes of the few-shot examples to help classify data points belonging to the minority classes.

  * From a tooling perspective, you can make prompt building even more modular by relying on libraries such as Langchain or Guidance that offer rich prompt templating features.




Finally, you will find below the complete versions of the code presented in this tutorial.

Happy prompt engineering !

[chat.py](<../../../../_downloads/462d183b9485669f49dea70bd5d63ac3/chat.py>)
    
    
    from dataikuapi.dss.langchain import DKUChatModel
    from langchain_core.messages import HumanMessage, SystemMessage, AIMessage
    import json
    from typing import Dict, List
    
    
    def predict_sentiment(chat: DKUChatModel, review: str):
        system_msg = """
        You are an assistant that classifies reviews according to their sentiment. 
        Respond strictly with this JSON format: {"llm_sentiment": "xxx"} where xxx should only be either: 
        pos if the review is positive 
        ntr if the review is neutral or does not contain enough information 
        neg if the review is negative 
        No other value is allowed.
        """
    
        messages = [
            SystemMessage(content=system_msg),
            HumanMessage(content=f"""Review: {review}""")
        ]
        resp = chat.invoke(messages)
        return json.loads(resp.content)
    
    
    def build_example_msg(rec: Dict) -> List[Dict]:
        example = [
            {"Review": rec['reviewText'], "llm_sentiment": rec['sentiment']}
        ]
        return example
    
    
    def predict_sentiment_fs(chat: DKUChatModel, review: str, examples: List):
        system_msg = """
        You are an assistant that classifies reviews according to their sentiment. 
        Respond strictly with this JSON format: {"llm_sentiment": "xxx"} where xxx should only be either: 
        pos if the review is positive 
        ntr if the review is neutral or does not contain enough information 
        neg if the review is negative 
        No other value is allowed.
        """
    
        messages = [
            SystemMessage(content=system_msg),
        ]
        for ex in examples:
            messages.append(HumanMessage(ex.get('Review')))
            messages.append(AIMessage(ex.get('llm_sentiment')))
    
        messages.append(HumanMessage(content=f"""Review: {review}"""))
    
        resp = chat.invoke(messages)
        return {'llm_sentiment': resp.content}
    

[compute_reviews_mag_train.py](<../../../../_downloads/3a87731635302b1f296c825d9ce633f4/compute_reviews_mag_train.py>)
    
    
    import dataiku
    import random
    
    LLM_ID = "" # Fill with your LLM-Mesh id
    lc_llm = dataiku.api_client().get_default_project().get_llm(LLM_ID).as_langchain_llm()
    
    
    def bin_score(x):
        return 'pos' if float(x) >= 4.0 else ('ntr' if float(x) == 3.0 else 'neg')
    
    
    random.seed(1337)
    
    input_dataset = dataiku.Dataset("reviews_magazines")
    
    output_schema = [
        {"type": "string", "name": "reviewText"},
        {"type": "int", "name": "nb_tokens"},
        {"type": "string", "name": "sentiment"}
    ]
    train_dataset = dataiku.Dataset("reviews_mag_train")
    train_dataset.write_schema(output_schema)
    w_train = train_dataset.get_writer()
    
    test_dataset = dataiku.Dataset("reviews_mag_test")
    test_dataset.write_schema(output_schema)
    w_test = test_dataset.get_writer()
    
    for r in input_dataset.iter_rows():
        text = r.get("reviewText")
        if len(text) > 0:
            out_row = {
                "reviewText": text,
                "nb_tokens": lc_llm.get_num_tokens(text),
                "sentiment": bin_score(r.get("overall"))
            }
            rnd = random.random()
            if rnd < 0.5:
                w_train.write_row_dict(out_row)
            else:
                w_test.write_row_dict(out_row)
    
    w_train.close()
    w_test.close()
    

[compute_test_fs_scored.py](<../../../../_downloads/a48289b06144ce0b2f2486795a124b78/compute_test_fs_scored.py>)
    
    
    import dataiku
    from utils.chat import predict_sentiment_fs
    from utils.chat import build_example_msg
    
    MIN_EX_LEN = 5
    MAX_EX_LEN = 200
    MAX_NB_EX = 10
    
    LLM_ID = "" # Fill with your LLM-Mesh id
    chat = dataiku.api_client().get_default_project().get_llm(LLM_ID).as_langchain_chat_model(temperature=0)
    
    input_dataset = dataiku.Dataset("reviews_mag_test")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"},
    ]
    
    # Retrieve a few examples from the training dataset
    examples_dataset = dataiku.Dataset("train_fs_examples")
    ex_to_add = []
    tot_tokens = 0
    for r in examples_dataset.iter_rows():
        nb_tokens = r.get("nb_tokens")
        if (nb_tokens > MIN_EX_LEN and nb_tokens < MAX_EX_LEN):
            ex_to_add += build_example_msg(dict(r))
            tot_tokens += nb_tokens
            if len(ex_to_add) == MAX_NB_EX:
                print(f"Total tokens = {tot_tokens}")
                break
    
    output_schema = input_dataset.read_schema() + new_cols
    output_dataset = dataiku.Dataset("test_fs_scored")
    output_dataset.write_schema(output_schema)
    
    # Run prompts on test dataset
    with output_dataset.get_writer() as w:
        for i, r in enumerate(input_dataset.iter_rows()):
            out_row = {}
            # Keep columns from input dataset
            out_row.update(dict(r))
            # Add LLM output
            result = predict_sentiment_fs(chat=chat,
                                          review=r.get("reviewText"),
                                          examples=ex_to_add)
            if result:
                out_row.update(result)
            w.write_row_dict(out_row)
    

[compute_test_zs_scored.py](<../../../../_downloads/b3c6208c0a75044c9ec3a0e847e5ce70/compute_test_zs_scored.py>)
    
    
    import dataiku
    from utils.chat import predict_sentiment
    
    LLM_ID = "" # Fill with your LLM-Mesh id
    chat = dataiku.api_client().get_default_project().get_llm(LLM_ID).as_langchain_chat_model(temperature=0)
    
    input_dataset = dataiku.Dataset("reviews_mag_test")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"},
        {"type": "int", "name": "nb_tokens"}
    ]
    output_schema = input_dataset.read_schema() + new_cols
    output_dataset = dataiku.Dataset("test_zs_scored")
    output_dataset.write_schema(output_schema)
    
    # Run prompts on test dataset
    with output_dataset.get_writer() as w:
        for i, r in enumerate(input_dataset.iter_rows()):
            print(f"{i+1}")
            out_row = {}
            # Keep columns from input dataset
            out_row.update(dict(r))
            # Add LLM output
            out_row.update(predict_sentiment(chat=chat,
                                             review=r.get("reviewText")))
            w.write_row_dict(out_row)
    

[compute_train_fs_examples.py](<../../../../_downloads/e7b356e8838b9ebb2a8916987618e438/compute_train_fs_examples.py>)
    
    
    import dataiku
    from utils.chat import predict_sentiment
    
    SIZE_EX_MIN = 20
    SIZE_EX_MAX = 100
    NB_EX_MAX = 10
    
    LLM_ID = "" # Fill with your LLM-Mesh id
    chat = dataiku.api_client().get_default_project().get_llm(LLM_ID).as_langchain_chat_model(temperature=0)
    
    input_dataset = dataiku.Dataset("reviews_mag_train")
    input_schema = input_dataset.read_schema()
    
    output_dataset = dataiku.Dataset("train_fs_examples")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"}
    ]
    output_schema = input_schema + new_cols
    output_dataset.write_schema(output_schema)
    
    nb_ex = 0
    with output_dataset.get_writer() as w:
        for r in input_dataset.iter_rows():
            # Check token-base length
            nb_tokens = r.get("nb_tokens")
            if nb_tokens > SIZE_EX_MIN and nb_tokens < SIZE_EX_MAX:
                pred = predict_sentiment(chat, r.get("reviewText"))
    
                # Keep prediction only if it was mistaken
                if pred["llm_sentiment"] != r.get("sentiment"):
                    out_row = dict(r)
                    out_row["llm_sentiment"] = pred["llm_sentiment"]
                    w.write_row_dict(out_row)
                    nb_ex += 1
                    if nb_ex == NB_EX_MAX:
                        break
    

[evaluate.py](<../../../../_downloads/d13f9351b7bff8daf01d42c517cc30a1/evaluate.py>)
    
    
    import pandas as pd
    
    from sklearn.metrics import precision_score
    from sklearn.metrics import recall_score
    from typing import Dict
    
    
    def get_classif_metrics(df: pd.DataFrame,
                            pred_col: str,
                            truth_col: str) -> Dict[str, float]:
        metrics = {
            "precision": precision_score(y_pred=df[pred_col],
                                         y_true=df[truth_col],
                                         average="macro"),
            "recall": recall_score(y_pred=df[pred_col],
                                   y_true=df[truth_col],
                                   average="macro")
        }
        return metrics

---

## [tutorials/genai/nlp/llm-mesh-rag/index]

# Programmatic RAG with Dataiku’s LLM Mesh and Langchain

While large language models (LLM) perform text generation well, they can only leverage the information on which they have been trained. However, many use cases might rely on data the model has not seen. This inability of LLMs to perform tasks outside their training data is a well-known shortcoming–for example, with recent or domain-specific information. This tutorial covers a technique that overcomes this common pitfall.

This tutorial implements this process known as _retrieval-augmented generation_ (RAG). To perform this task, you will use OpenAI’s GPTx model over a custom source of information, namely a PDF file. In the process, you will use Dataiku’s LLM mesh features, namely:

  1. LLM connections

  2. Knowledge Banks

  3. Dataiku’s Langchain integrations for vector stores and LLMs




## Prerequisites

  * Dataiku >= 12.4

  * permission to use a Python code environment with the **Retrieval augmented generation models** package set installed, plus the `tiktoken`, `pypdf` packages

  * OpenAI LLM connection for a GPT model enabled (preferably GPT-4)




Note

You will _index_ a document so it can be queried by an LLM. From version 12.3, Dataiku provides a native Flow item called [Knowledge Bank](<https://doc.dataiku.com/dss/latest/generative-ai/rag.html#concepts>) that points to a vector databases where its embeddings are stored.

## Converting a downloaded document into chunks

Create a Python recipe and create an output dataset named `document_splits`. Within it, run the following script that downloads a PDF document:

[Python script - split document](<../../../../_downloads/4153006218309655f829be0107f38350/recipe_split.py>)

recipe_split.py
    
    
    import dataiku
    import os
    import tiktoken
    
    try:
        from langchain_community.document_loaders import PyPDFLoader
    except ModuleNotFoundError:
        from langchain.document_loaders import PyPDFLoader
    try:
        from langchain_text_splitters.character import CharacterTextSplitter
    except ModuleNotFoundError:
        from langchain.text_splitter import CharacterTextSplitter
    
    FILE_URL = "https://bit.ly/GEP-Jan-2024" # Update as needed
    
    CHUNK_SIZE = 1000
    CHUNK_OVERLAP = 100
    
    enc = tiktoken.encoding_for_model("gpt-4")
    splitter = CharacterTextSplitter(chunk_size=CHUNK_SIZE,
                                     separator='\n',
                                     chunk_overlap=CHUNK_OVERLAP,
                                     length_function=len)
    
    docs_dataset = dataiku.Dataset("document_splits")
    docs_dataset.write_schema([
        {"name": "split_id", "type": "int"},
        {"name": "text", "type": "string"},
        {"name": "page", "type": "int"},
        {"name": "nb_tokens", "type": "int"}
    ])
    
    
    # Read PDF file, split it into smaller chunks and write each chunk data + metadata
    # in the output dataset
    splits = PyPDFLoader(FILE_URL) \
        .load_and_split(text_splitter=splitter)
    
    with docs_dataset.get_writer() as w:
        for i, s in enumerate(splits):
            d = s.dict()
            w.write_row_dict({"split_id": i,
                "text": d["page_content"],
                "page": d["metadata"]["page"],
                "nb_tokens": len(enc.encode(d["page_content"]))
                })
    

Caution

This tutorial uses the World Bank’s Global Economic Prospects (GEP) report. If the referenced publication is no longer available, look for the latest report’s PDF version on [this page](<https://www.worldbank.org/en/publication/global-economic-prospects>)

The next step will be to extract the document text, transform it into _embeddings_ and store them in a _vector database_. Before indexing a document into a vector database this way, it is a common practice to split the text into smaller chunks first. Searching across multiple smaller chunks instead of a single large document allows for a more granular match between the input prompt and the document’s content.

Once built, each row from `document_splits` will contain a distinct chunk with:

  1. an ID

  2. text

  3. origin page number

  4. length measured by the number of tokens, which allows us to quantify how much of the LLM’s context window will be consumed and the cost of computing embeddings via services like the OpenAI API




## Storing embeddings in a vector database

Embeddings capture the semantic meaning and context of the encoded text. Querying the vector database with a text input will return the most similar elements (in the semantic sense) in that database. These results from that vector database are used to _enrich_ your prompt by adding relevant text from the document. This allows the LLM to leverage the document’s data directly when asked about its content.

In Dataiku, a knowledge bank (KB) flow item represents the vector database. It is created using a visual _[embedding recipe](<https://knowledge.dataiku.com/latest/genai/rag/concept-rag.html>)_.

Implement and run a new embedding recipe (**+RECIPE > LLM Recipes > Embed**) with `document_splits` as the input dataset and a KB called `document_embedded` with the following settings:

  1. embedding model: “Embedding (Ada 002)”

  2. knowledge column -> `text`

  3. metadata columns (optional): page, split_id, nb_tokens

  4. document splitting method: “Do not split”




Note

When accessing a KB from the Dataiku UI, its URL is of the form:

`https://dss.example/projects/YOUR_PROJECT_KEY/knowledge-bank/<KB_ID>`

Take note of the KB ID. You can also retrieve this identifier later on with the [`list_knowledge_banks()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_knowledge_banks> "dataikuapi.dss.project.DSSProject.list_knowledge_banks") method.

By handling it as _Langchain vector stores_ , you can query a KB programmatically. To test, run the following code from a notebook:

[Python notebook - test kb](<../../../../_downloads/4153006218309655f829be0107f38350/recipe_split.py>)

sample_simsearch.py
    
    
    import dataiku
    
    KB_ID = ""  # Replace with your KB id
    
    client = dataiku.api_client()
    project = client.get_default_project()
    kb = dataiku.KnowledgeBank(id=KB_ID,
        project_key=project.project_key)
    vector_store = kb.as_langchain_vectorstore()
    query = "Summarize the current global status on inflation."
    search_result = vector_store.similarity_search(query, include_metadata=True)
    
    for r in search_result:
        print(r.json())
    

## Running an enriched LLM query

Now that the KB is ready to query, you can use it with an LLM. In practice, you will use your prompt as a query for similarity search to retrieve additional data as context. Before running inference on the LLM, this context can be added to the initial prompt.

Run the following code from a notebook:

sample_rag.py
    
    
    import dataiku
    try:
        from langchain_classic.chains.question_answering import load_qa_chain
    except ModuleNotFoundError:
        from langchain.chains.question_answering import load_qa_chain
    from dataiku.langchain.dku_llm import DKUChatModel
    
    KB_ID = "" # Fill with your KB id
    GPT_LLM_ID = ""  # Fill with your LLM-Mesh id
    
    # Retrieve the knowledge base and LLM handles
    client = dataiku.api_client()
    project = client.get_default_project()
    kb = dataiku.KnowledgeBank(id=KB_ID, project_key=project.project_key)
    vector_store = kb.as_langchain_vectorstore()
    gpt_lc = DKUChatModel(llm_id=GPT_LLM_ID, temperature=0)
    
    # Create the question answering chain
    chain = load_qa_chain(gpt_lc, chain_type="stuff")
    query = "What will inflation in Europe look like and why?"
    search_results = vector_store.similarity_search(query)
    
    # ⚡ Get the results ⚡
    resp = chain({"input_documents":search_results, "question": query})
    print(resp["output_text"])
    
    # Inflation in Europe is expected to remain high in the near term due to
    # persistently high inflation that will prevent a rapid easing of monetary
    # policy in most economies and weigh on private consumption. Projected fiscal
    # consolidation further dampens the outlook. Risks such as an escalation of
    # the conflict in the Middle East could increase energy prices, tighten
    # financial conditions, and negatively affect confidence.
    
    # Geopolitical risks in the region, including an escalation of the Russian
    # Federation’s invasion of Ukraine, are elevated and could materialize.
    # Higher-than-anticipated inflation or a weaker-than-expected recovery in
    # the euro area would also negatively affect regional activity. However, by
    # 2024-25, global inflation is expected to decline further, underpinned by
    # the projected weakness in global demand growth and slightly lower
    # commodity prices.
    

If you don’t have your LLM ID at hand you can use the [`list_llms()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms") method to list all available LLMs for this project.

The Dataiku-native knowledge base and the LLM objects are translated into Langchain-compatible items, which are then used to build and run the question-answering chain. This allows you to extend the capabilities of Dataiku-managed LLMs for more complex cases.

## Wrapping up

Congratulations, now you can perform RAG using Dataiku’s programmatic LLM mesh features! To go further, you can:

  * query from multiple documents

  * retrieve more results from the knowledge bank to feed the LLM

  * reinforce the retrieved context’s importance in the prompt

---

## [tutorials/genai/nlp/llm-mesh-zero-shot/index]

# Using LLM Mesh to benchmark zero-shot classification models  
  
## Prerequisites

  * Dataiku >= 12.4

  * Access to at least 2 LLM connections (see the [reference documentation](<https://doc.dataiku.com/dss/latest/generative-ai/llm-connections.html> "\(in Dataiku DSS v14\)") for configuration details). This tutorial uses OpenAI’s GPT-3.5-turbo and GPT-4, but you can easily swap them with other providers/models.

  * Access to an existing project with the following permissions:

    * “Read project content”

    * “Write project content”




## LLM mesh API basics: prompting a model

With Dataiku’s LLM mesh capabilities, you can leverage the power of various LLM types using a unified programmatic interface provided by the public API. More specifically, the Python API client allows you to easily manipulate query and response objects you send to/get from your LLM.

Authentication is fully handled by the LLM connection settings under the hood so that you can focus solely on the essentials parts of your code.

As a first example, let’s see how to query a GPT-3.5-Turbo model. Run the following code from a notebook:

basic_query.py
    
    
    import dataiku
    
    GPT_35_LLM_ID = "" # Fill with your gpt-3.5-turbo LLM id
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(GPT_35_LLM_ID)
    
    compl = llm.new_completion()
    q = compl.with_message("Write a one-sentence positive review for the Lord of The Rings movie trilogy.")
    resp = q.execute()
    if resp.success:
        print(resp.text)
    else:
        raise Exception("LLM inference failed!")
    
    # The Lord of the Rings is a thrilling epic adventure that follows a group of
    # unlikely heroes as they journey through dangerous lands in order to destroy
    # a powerful ring and save their world from eternal darkness.
    

Here is what happens under the hood with this code snippet:

  1. A `DSSLLM` object is instantiated using the LLM connection mapped associated with the specified LLM id. If you don’t have your LLM ID at hand, you can use the [`list_llms()`](<../../../../api-reference/python/projects.html#dataikuapi.dss.project.DSSProject.list_llms> "dataikuapi.dss.project.DSSProject.list_llms") method to list all available LLMs within the project.

  2. From this `DSSLLM` object, a `DSSLLMCompletionQuery` object is created to serve as the building ground for the user prompt. This prompt is built by adding one (or more) messages with the `with_message()` method.

  3. Once the prompt is built, the query is executed. It returns a `DSSLLMCompletionResponse` object that you can use to check if the model inference was run successfully and retrieve the model’s output.




Note also that your code doesn’t call any external dependency: for this simple use-case, everything you need is the Python API client.

Now for the interesting part: if you want to swap the GPT-3.5-turbo model with another LLM, _you only need to change the LLM id. The rest of the code remains exactly the same_. This is one of the main strengths of the LLM mesh: allowing developers to write provider-agnostic code when prompting models.

## Classifying movie reviews

Let’s look at a more elaborate use-case: movie review classification. To perform this task, you will need to build a more elaborate prompt that will:

  * align with the task at hand,

  * generate standardized outputs.




To do so, you can rely on _system messages_ whose role is to define the model’s behavior. In practice, you describe this behavior in the `with_message()` method by passing the `role='system'` parameter. Here is an example:

basic_review.py
    
    
    import dataiku
    
    GPT_35_LLM_ID = "" # Fill with your gpt-3.5-turbo LLM id
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(GPT_35_LLM_ID)
    
    reviews = [
        {
            "sentiment": 0,
            "text": "This movie was horrible: bad actor performance, poor scenario and ugly CGI effects."
        },
        {
            "sentiment": 1,
            "text": "Beautiful movie with an original storyline and top-notch actor performance."
        }
    ]
    
    compl = llm.new_completion()
    
    sys_msg = """
    You are a movie review expert.
    Your task is to classify movie review sentiments in two categories: 0 for negative reviews,
    1 for positive reviews. Do not answer anything else than 0 or 1."
    """
    
    for r in reviews:
        q = compl \
            .with_message(role="system", message=sys_msg) \
            .with_message(f"Classify this movie review: {r['text']}")
        resp = q.execute()
        if resp.success:
            print(f"{r[r'text']}\n Inference: {resp.text}\n Ground truth: {r['sentiment']}\n{20*'---'}")
        else:
            raise Exception("LLM inference failed!")
    

To make it more composable, you can wrap this code into a function and place it in your project Libraries. Go to your project library and, under `python/`, create a new directory called `review_code`. Inside that directory, create two files:

  * `__init__.py` that should be left empty,

  * `models.py` that will contain our helper functions.




Add the following code to `models.py`:

models.py
    
    
    from typing import Dict
    from dataikuapi.dss.llm import DSSLLM
    
    
    def zshot_clf(model: DSSLLM, row: Dict[str,str]) -> Dict[str,str]:
        
        sys_msg = """
        You are a movie review expert.
        Your task is to classify movie review sentiments in two categories: 0 for negative reviews,
        1 for positive reviews. Answer only with one character that is either 0 or 1.
        """
    
        compl = model.new_completion()
        q = compl \
            .with_message(role="system", message=sys_msg) \
            .with_message(f"Classify this movie review: {row['text']}")
        resp = q.execute()
        if resp.success:
            out_row = dict(row)
            out_row["prediction"] = str(resp.text)
            out_row["llm_id"] = model.llm_id
            return out_row
        else:
            raise Exception(f"LLM inference failed for input row:\n{row}")
    

Your next task is to gather the input dataset containing the movie reviews. The dataset you will work on is an extract from the [Large Movie Review Dataset](<https://ai.stanford.edu/~amaas/data/sentiment/>). Download the file [here](<https://cdn.downloads.dataiku.com/public/website-additional-assets/data/IMDB_train.csv.gz>) and use it to create a dataset in your project called `reviews`. In this dataset, there are two columns of interest:

  * `text` contains the reviews to be analyzed,

  * `polarity` reflects the review sentiment: 0 for negative, 1 for positive.




Next, from the `reviews` dataset, create a Python recipe with a single output dataset called `reviews_scored` with the following code:

recipe_zshot.py
    
    
    import dataiku
    from review_code.models import zshot_clf
    
    GPT_35_LLM_ID = ""  # Fill with your gpt-3.5-turbo LLM id
    N_MAX_OUTPUT_ROWS = 100  # Change this value to increase the number of rows to use
    
    # Create new schema for the output dataset
    reviews = dataiku.Dataset("reviews")
    schema = reviews.read_schema()
    reviews_scored = dataiku.Dataset("reviews_scored")
    for c in ["prediction", "llm_id"]:
        schema.append({"name": c, "type": "string"})
    reviews_scored.write_schema(schema)
    
    
    # Retrieve the LLM handle
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(GPT_35_LLM_ID)
    
    # Iteratively classify reviews
    with reviews_scored.get_writer() as w_out:
        for i, row in enumerate(reviews.iter_rows()):
            if i == N_MAX_OUTPUT_ROWS-1:
                break
            w_out.write_row_dict(zshot_clf(llm, row))
    

After running this recipe, your `reviews_scored` dataset should be populated with the predicted sentiments. The final step is to compute the performance of your zero-shot classifier since you have the ground truth at your disposal.

To compute the _accuracy_ of your model, run the following code:

acc_single_model.py
    
    
    import dataiku
    from sklearn.metrics import accuracy_score
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    review_scored_df = dataiku.Dataset("reviews_scored").get_dataframe()
    acc = accuracy_score(review_scored_df["polarity"],
                         review_scored_df["prediction"])
    print(f"ACC = {acc:.2f}")
    

You should get a decent accuracy value, but what if you wanted to see how good the model is _compared to another one_?

## Benchmarking multiple LLMs

In this section, you will see how to easily run the same operation as before over two different models. In practice, you will compare the performance of GPT-3.5-turbo with GPT-4.

Create a new Python recipe with:

  * `reviews` as input dataset,

  * `reviews_2_models_scored` as a new output dataset.




Add the following code:

recipe_2_models_zshot.py
    
    
    import dataiku
    from review_code.models import zshot_clf
    
    GPT_35_LLM_ID = ""  # Fill with your gpt-3.5-turbo LLM id
    GPT_4_LLM_ID = ""  # Fill with your gpt-4 LLM id
    N_MAX_OUTPUT_ROWS = 100  # Change this value to increase the number of rows to use
    
    # Create new schema for the output dataset
    reviews = dataiku.Dataset("reviews")
    schema = reviews.read_schema()
    reviews_scored = dataiku.Dataset("reviews_2_models_scored")
    for c in [f"pred_{GPT_35_LLM_ID}", f"pred_{GPT_4_LLM_ID}"]:
        schema.append({"name": c, "type": "string"})
    reviews_scored.write_schema(schema)
    
    # Retrieve the LLM handle
    client = dataiku.api_client()
    project = client.get_default_project()
    gpt_35 = project.get_llm(GPT_35_LLM_ID)
    gpt_4 = project.get_llm(GPT_4_LLM_ID)
    
    # Iteratively classify reviews with both models
    with reviews_scored.get_writer() as w_out:
        for i, row in enumerate(reviews.iter_rows()):
            if i == N_MAX_OUTPUT_ROWS-1:
                break
            print(i)
            gpt = {}
            gpt[f"pred_{GPT_35_LLM_ID}"] = zshot_clf(gpt_35, row).get('prediction')
            gpt[f"pred_{GPT_4_LLM_ID}"]  = zshot_clf(gpt_4, row).get('prediction')
            w_out.write_row_dict({**row, **gpt})
    

Note that the code barely changes even if you introduce a new model. You just had to create a new handle and call the scoring function a second time, but nothing more!

To compare how both models are doing in terms of performance, you can run the following code:

acc_2_models.py
    
    
    import dataiku
    from sklearn.metrics import accuracy_score
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    GPT_35_LLM_ID = ""  # Fill with your gpt-3.5-turbo LLM id
    GPT_4_LLM_ID = ""  # Fill with your gpt-4 LLM id
    
    acc = []
    
    review_scored_df = dataiku.Dataset("reviews_2_models_scored").get_dataframe()
    for m in [GPT_35_LLM_ID, GPT_4_LLM_ID]:
        acc.append({"llm_id": m,
                    "accuracy": accuracy_score(review_scored_df["polarity"],
                                               review_scored_df[f"pred_{m}"])})
                                               
    for ac in acc:
        print(f"ACC({ac.get('llm_id')}) = {ac.get('accuracy'):.2f}")
    

You will get relatively similar performances for a small value of `N_MAX_OUTPUT_ROWS`. But as you increase the number of scored records, you should see GPT-4 performing a bit better. Do not hesitate to try different models among the ones at your disposal, as you can now see it only mandates very few changes in the code!

## Wrapping up

Congratulations on finishing this tutorial! You now have a good overview of the LLM mesh completion query capabilities in Dataiku! If you want to go further, you can try:

  * tweaking the prompt,

  * running comparisons with more than two models,

  * leveraging Dataiku’s experiment tracking abilities to better log parameters, prompt variations, and resulting performances.




Here are the complete versions of the code presented in this tutorial:

[basic_query.py](<../../../../_downloads/c06dd7195f64ef0109632323347d8f93/basic_query.py>)
    
    
    import dataiku
    
    GPT_35_LLM_ID = "" # Fill with your gpt-3.5-turbo LLM id
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(GPT_35_LLM_ID)
    
    compl = llm.new_completion()
    q = compl.with_message("Write a one-sentence positive review for the Lord of The Rings movie trilogy.")
    resp = q.execute()
    if resp.success:
        print(resp.text)
    else:
        raise Exception("LLM inference failed!")
    
    # The Lord of the Rings is a thrilling epic adventure that follows a group of
    # unlikely heroes as they journey through dangerous lands in order to destroy
    # a powerful ring and save their world from eternal darkness.
    

[basic_review.py](<../../../../_downloads/f564e61a13e76ec3c6f28918e8682c42/basic_review.py>)
    
    
    import dataiku
    
    GPT_35_LLM_ID = "" # Fill with your gpt-3.5-turbo LLM id
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(GPT_35_LLM_ID)
    
    reviews = [
        {
            "sentiment": 0,
            "text": "This movie was horrible: bad actor performance, poor scenario and ugly CGI effects."
        },
        {
            "sentiment": 1,
            "text": "Beautiful movie with an original storyline and top-notch actor performance."
        }
    ]
    
    compl = llm.new_completion()
    
    sys_msg = """
    You are a movie review expert.
    Your task is to classify movie review sentiments in two categories: 0 for negative reviews,
    1 for positive reviews. Do not answer anything else than 0 or 1."
    """
    
    for r in reviews:
        q = compl \
            .with_message(role="system", message=sys_msg) \
            .with_message(f"Classify this movie review: {r['text']}")
        resp = q.execute()
        if resp.success:
            print(f"{r[r'text']}\n Inference: {resp.text}\n Ground truth: {r['sentiment']}\n{20*'---'}")
        else:
            raise Exception("LLM inference failed!")
    

[models.py](<../../../../_downloads/7d833697668f4045bc31eac01dbdb851/models.py>)
    
    
    from typing import Dict
    from dataikuapi.dss.llm import DSSLLM
    
    
    def zshot_clf(model: DSSLLM, row: Dict[str,str]) -> Dict[str,str]:
        
        sys_msg = """
        You are a movie review expert.
        Your task is to classify movie review sentiments in two categories: 0 for negative reviews,
        1 for positive reviews. Answer only with one character that is either 0 or 1.
        """
    
        compl = model.new_completion()
        q = compl \
            .with_message(role="system", message=sys_msg) \
            .with_message(f"Classify this movie review: {row['text']}")
        resp = q.execute()
        if resp.success:
            out_row = dict(row)
            out_row["prediction"] = str(resp.text)
            out_row["llm_id"] = model.llm_id
            return out_row
        else:
            raise Exception(f"LLM inference failed for input row:\n{row}")
    

[recipe_zshot.py](<../../../../_downloads/9ddcab2cee6a13103d5bc89107fed2e2/recipe_zshot.py>)
    
    
    import dataiku
    from review_code.models import zshot_clf
    
    GPT_35_LLM_ID = ""  # Fill with your gpt-3.5-turbo LLM id
    N_MAX_OUTPUT_ROWS = 100  # Change this value to increase the number of rows to use
    
    # Create new schema for the output dataset
    reviews = dataiku.Dataset("reviews")
    schema = reviews.read_schema()
    reviews_scored = dataiku.Dataset("reviews_scored")
    for c in ["prediction", "llm_id"]:
        schema.append({"name": c, "type": "string"})
    reviews_scored.write_schema(schema)
    
    
    # Retrieve the LLM handle
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(GPT_35_LLM_ID)
    
    # Iteratively classify reviews
    with reviews_scored.get_writer() as w_out:
        for i, row in enumerate(reviews.iter_rows()):
            if i == N_MAX_OUTPUT_ROWS-1:
                break
            w_out.write_row_dict(zshot_clf(llm, row))
    

[acc_single_model.py](<../../../../_downloads/be865295cbeae2558ff2832bdfc10b36/acc_single_model.py>)
    
    
    import dataiku
    from sklearn.metrics import accuracy_score
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    review_scored_df = dataiku.Dataset("reviews_scored").get_dataframe()
    acc = accuracy_score(review_scored_df["polarity"],
                         review_scored_df["prediction"])
    print(f"ACC = {acc:.2f}")
    

[recipe_2_models_zshot.py](<../../../../_downloads/a81adf520879cd932558f9c1d15ed703/recipe_2_models_zshot.py>)
    
    
    import dataiku
    from review_code.models import zshot_clf
    
    GPT_35_LLM_ID = ""  # Fill with your gpt-3.5-turbo LLM id
    GPT_4_LLM_ID = ""  # Fill with your gpt-4 LLM id
    N_MAX_OUTPUT_ROWS = 100  # Change this value to increase the number of rows to use
    
    # Create new schema for the output dataset
    reviews = dataiku.Dataset("reviews")
    schema = reviews.read_schema()
    reviews_scored = dataiku.Dataset("reviews_2_models_scored")
    for c in [f"pred_{GPT_35_LLM_ID}", f"pred_{GPT_4_LLM_ID}"]:
        schema.append({"name": c, "type": "string"})
    reviews_scored.write_schema(schema)
    
    # Retrieve the LLM handle
    client = dataiku.api_client()
    project = client.get_default_project()
    gpt_35 = project.get_llm(GPT_35_LLM_ID)
    gpt_4 = project.get_llm(GPT_4_LLM_ID)
    
    # Iteratively classify reviews with both models
    with reviews_scored.get_writer() as w_out:
        for i, row in enumerate(reviews.iter_rows()):
            if i == N_MAX_OUTPUT_ROWS-1:
                break
            print(i)
            gpt = {}
            gpt[f"pred_{GPT_35_LLM_ID}"] = zshot_clf(gpt_35, row).get('prediction')
            gpt[f"pred_{GPT_4_LLM_ID}"]  = zshot_clf(gpt_4, row).get('prediction')
            w_out.write_row_dict({**row, **gpt})
    

[acc_2_models.py](<../../../../_downloads/fbe9153596cb17c08872374246efd976/acc_2_models.py>)
    
    
    import dataiku
    from sklearn.metrics import accuracy_score
    
    client = dataiku.api_client()
    project = client.get_default_project()
    
    GPT_35_LLM_ID = ""  # Fill with your gpt-3.5-turbo LLM id
    GPT_4_LLM_ID = ""  # Fill with your gpt-4 LLM id
    
    acc = []
    
    review_scored_df = dataiku.Dataset("reviews_2_models_scored").get_dataframe()
    for m in [GPT_35_LLM_ID, GPT_4_LLM_ID]:
        acc.append({"llm_id": m,
                    "accuracy": accuracy_score(review_scored_df["polarity"],
                                               review_scored_df[f"pred_{m}"])})
                                               
    for ac in acc:
        print(f"ACC({ac.get('llm_id')}) = {ac.get('accuracy'):.2f}")

---

## [tutorials/genai/nlp/llm-zero-shot-clf/index]

# Zero-shot text classification with the LLM Mesh

Generative AI offers powerful tools that enable data scientists to integrate cutting-edge natural language processing (NLP) capabilities into their applications. In particular, it exposes its latest large language models (LLM) for easy queries. Combining these tools with the coder-oriented features of Dataiku further empowers the platform users to configure and run NLP tasks in a project.

With Dataiku’s LLM mesh capabilities, you can leverage the power of various LLM types using a unified programmatic interface provided by the public API. More specifically, the Python API client allows you to easily manipulate query and response objects you send to/get from your LLM.

In this tutorial, you will cover the basics of using the LLM Mesh within Dataiku and apply it using an LLM for a text classification problem on movie reviews.

## Prerequisites

  * Dataiku >= 12.3 (or 13.1 if you want to use Langchain-compatible functions)

  * Access to an existing project with the following permissions:

    * “Read project content”

    * “Write project content”

  * A valid LLM connection




## Getting the LLM

The first step is to get the LLM ID you want. With the LLM Mesh, you can use any generative AI model provider; Dataiku offers an abstraction over many LLM services. You can easily find the desired LLM ID by running Code 1.

Code 1: List existing LLM and their associated ID.
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms()
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    

Once you have identified which LLM you want to use, note the associated ID (`LLM_ID`)

### Initial tests

You can ask your LLM a simple question to test whether everything is OK. This is done in Code 2.

LLM MeshLangchain-compatible LLMLangchain-compatible chat LLM

Code 2: Asking a question to an LLM
    
    
    LLM_ID = "" #Fill with a valid LLM_ID
    llm = project.get_llm(LLM_ID)
    completion = llm.new_completion()
    resp = completion.with_message("When was the movie Citizen Kane released?").execute()
    if resp.success:
        print(resp.text)
    else:
        print("Something went wrong. Check you have the permission to use the LLM")
        
    # > 'Citizen Kane was released on September 5, 1941.'
    

Code 2: Asking a question to a Langchain-compatible LLM
    
    
    LLM_ID = "" #Fill with a valid LLM_ID
    llm = project.get_llm(LLM_ID)
    lcllm = llm.as_langchain_llm()
    lcllmResp = lcllm.invoke("When was the movie Citizen Kane released?")
    print(lcllmResp)
    
    # > 'Citizen Kane was released on September 5, 1941.'
    

Code 2: Asking a question to a Langchain-compatible chat LLM
    
    
    LLM_ID = "" #Fill with a valid LLM_ID
    llm = project.get_llm(LLM_ID)
    chat = llm.as_langchain_chat_model()
    chatResp = chat.invoke("When was the movie Citizen Kane released?")
    print(chatResp.content)
    
    # > Citizen Kane was released on September 5, 1941.
    

You can tweak the prompt to be more flexible on the model input. In practice, it translates into providing additional _context_ to the model about what it should know and how it should respond. Code 3 shows how to add extra context to an LLM.

LLM MeshLangchain-compatible LLMLangchain-compatible chat LLM

Code 3: Tweaking the prompt
    
    
    completion = llm.new_completion()
    
    question = "When was the movie Citizen Kane released?"
    system_msg = """You are an expert in the history of American cinema.
    You always answer questions with a lot of passion and enthusiasm.
    """
    
    resp = completion.with_message(role="system", message=system_msg).with_message(role="user", message=question).execute()
    if resp.success:
        print(resp.text)
    else:
        print("Something went wrong. Check you have the permission to use the LLM")
        
    # > 'Ah, Citizen Kane! What a masterpiece of American cinema! It was released on
    # September 5, 1941, and it completely revolutionized the film industry with its
    # innovative storytelling techniques and groundbreaking cinematography. Directed
    # by the legendary Orson Welles, Citizen Kane is a timeless classic that continues
    # to captivate audiences with its rich narrative and complex characters. It truly
    # is a must-see for anyone interested in the history of cinema!'
    

Code 3: Tweaking the prompt
    
    
    from langchain_core.messages import HumanMessage, SystemMessage
    
    question = "When was the movie Citizen Kane released?"
    system_msg = """You are an expert in the history of American cinema.
    You always answer questions with a lot of passion and enthusiasm.
    """
    
    messages = [
        SystemMessage(content=system_msg),
        HumanMessage(content=question)
    ]
    
    lcllmResp = lcllm.invoke(messages)
    print(lcllmResp)
    
    # > "Oh, Citizen Kane! What a masterpiece of American cinema. It was released on
    # September 5, 1941. Directed by Orson Welles, it is often considered one of the
    # greatest films ever made. The innovative storytelling techniques and 
    # groundbreaking cinematography truly set it apart from other films of its time.
    # It's a must-watch for any film enthusiast!"
    

Code 3: Tweaking the prompt
    
    
    from langchain_core.messages import HumanMessage, SystemMessage
    
    question = "When was the movie Citizen Kane released?"
    system_msg = """You are an expert in the history of American cinema.
    You always answer questions with a lot of passion and enthusiasm.
    """
    
    messages = [
        SystemMessage(content=system_msg),
        HumanMessage(content=question)
    ]
    
    chatResp = chat.invoke(messages)
    print(chatResp.content)
    
    # > Oh, Citizen Kane! What a masterpiece of American cinema! It was released on
    # September 5, 1941. Directed by the legendary Orson Welles, this film is often
    # considered one of the greatest films ever made. The innovative storytelling
    # techniques, groundbreaking cinematography, and powerful performances make it a
    # timeless classic that continues to captivate audiences to this day. If you haven't
    # seen it yet, I highly recommend watching it to experience the magic of this
    # cinematic gem!
    

While being fun, this example also unveils the potential of such models: _with the proper instructions and context, they can perform a wide variety of tasks based on natural language!_ In the next section, you will use this versatility to customize your prompt and turn the LLM into a text classifier.

## Classifying movie reviews

The following example will rely on an extract from the [Large Movie Review Dataset](<https://ai.stanford.edu/~amaas/data/sentiment/>). Download the file [here](<https://cdn.downloads.dataiku.com/public/website-additional-assets/data/IMDB_train.csv.gz>) and use it to create a dataset in your project called `reviews`. In this dataset, there are two columns of interest:

  * `text` contains the reviews to be analyzed

  * `polarity` reflects the review sentiment: 0 for negative, 1 for positive




To test your function, you will run it on a small sample of the `reviews` dataset. For that, create a Python recipe that outputs a single dataset called `reviews_sample_llm_scored` with Code 4. Note that the system message was thoroughly customized to align the model with the task, telling it exactly what to do and how to format the output. Crafting and iteratively adjusting the model’s input to guide it toward the desired response is known as _prompt engineering_.

LLM MeshLangchain-compatible LLMLangchain-compatible chat LLM

Code 4: Testing the classification
    
    
    import dataiku
    import ast
    
    LLM_ID = ""  # Fill with a valid LLM_ID
    SSIZE = 10
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID)
    
    input_dataset = dataiku.Dataset("reviews")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"},
        {"type": "string", "name": "llm_explanation"}
    ]
    output_schema = input_dataset.read_schema() + new_cols
    output_dataset = dataiku.Dataset("reviews_sample_llm_scored")
    output_dataset.write_schema(output_schema)
    
    system_msg = f"""
    You are an assistant that classifies reviews according to their sentiment. \
    Respond in json format with the keys: llm_sentiment and llm_explanation. \
    The value for llm_sentiment should only be either pos or neg without punctuation: pos if the review is positive, neg otherwise.\
    The value for llm_explanation should be a very short explanation for the sentiment.
    """
    
    cnt = 0
    with output_dataset.get_writer() as w:
        for r in input_dataset.iter_rows():
            completion = llm.new_completion()
            llm_out = completion.with_message(role="system", message=system_msg).with_message(r.get("text")).execute()
            w.write_row_dict({**dict(r), **(ast.literal_eval(llm_out.text))})
            cnt += 1
            if cnt == SSIZE:
                break
    

Code 4: Testing the classification
    
    
    import dataiku
    import ast
    from langchain_core.messages import HumanMessage, SystemMessage
    
    LLM_ID = ""  # Fill with a valid LLM_ID
    SSIZE = 10
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID).as_langchain_llm()
    
    input_dataset = dataiku.Dataset("reviews")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"},
        {"type": "string", "name": "llm_explanation"}
    ]
    output_schema = input_dataset.read_schema() + new_cols
    output_dataset = dataiku.Dataset("reviews_sample_llm_scored")
    output_dataset.write_schema(output_schema)
    
    system_msg = f"""
    You are an assistant that classifies reviews according to their sentiment. \
    Respond in json format with the keys: llm_sentiment and llm_explanation. \
    The value for llm_sentiment should only be either pos or neg without punctuation: pos if the review is positive, neg otherwise.\
    The value for llm_explanation should be a very short explanation for the sentiment.
    """
    
    cnt = 0
    with output_dataset.get_writer() as w:
        for r in input_dataset.iter_rows():
            messages = [
                SystemMessage(content=system_msg),
                HumanMessage(content=r.get("text"))
            ]
            llm_out = llm.invoke(messages)
            w.write_row_dict({**dict(r), **(ast.literal_eval(llm_out))})
            cnt += 1
            if cnt == SSIZE:
                break
    

Code 4: Testing the classification
    
    
    import dataiku
    import ast
    from langchain_core.messages import HumanMessage, SystemMessage
    
    LLM_ID = ""  # Fill with a valid LLM_ID
    SSIZE = 10
    
    client = dataiku.api_client()
    project = client.get_default_project()
    chat = project.get_llm(LLM_ID).as_langchain_chat_model()
    
    input_dataset = dataiku.Dataset("reviews")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"},
        {"type": "string", "name": "llm_explanation"}
    ]
    output_schema = input_dataset.read_schema() + new_cols
    output_dataset = dataiku.Dataset("reviews_sample_llm_scored")
    output_dataset.write_schema(output_schema)
    
    system_msg = f"""
    You are an assistant that classifies reviews according to their sentiment. \
    Respond in json format with the keys: llm_sentiment and llm_explanation. \
    The value for llm_sentiment should only be either pos or neg without punctuation: pos if the review is positive, neg otherwise.\
    The value for llm_explanation should be a very short explanation for the sentiment.
    """
    
    cnt = 0
    with output_dataset.get_writer() as w:
        for r in input_dataset.iter_rows():
            messages = [
                SystemMessage(content=system_msg),
                HumanMessage(content=r.get("text"))
            ]
            chat_out = chat.invoke(messages)
            w.write_row_dict({**dict(r), **(ast.literal_eval(chat_out.content))})
            cnt += 1
            if cnt == SSIZE:
                break
    

This recipe will read the input dataset line-by-line and iteratively send the review text to the LLM to retrieve:

  * the inferred sentiment (0 or 1)

  * a short explanation of why the review is good or bad




Once the output dataset is built, you can compare the values of the `polarity` and `llm_sentiment`, which should match closely: your classifier is doing well! The `llm_explanation` should also give you a quick insight into how the model understood the review.

This technique is called _zero-shot classification_ since it relies on the model’s ability to understand relationships between words and concepts without being specifically trained on labeled data.

Warning

While LLMs show promising capabilities to understand and generate human-like text, they can also sometimes create outputs with pieces of information or details that aren’t accurate or factual. These mistakes are known as _hallucinations_ and can arise due to the following:

  * limitations and biases in the model’s training data

  * the inherent nature of the model to reproduce statistical patterns rather than proper language understanding or reasoning




To mitigate their impact, you should always review any model output that would be part of a critical decision-making process.

## Wrapping up

Congratulations! You have completed this tutorial and gained valuable insights into basic coding features in Dataiku and the LLM Mesh. By understanding the basic concepts of language-based generative AI and the relevant tools in Dataiku to leverage them, you are now ready to tackle more complex use cases.

If you want to further experiment beyond this tutorial you can, for example:

  * Change the value of `SSIZE` in the recipe to increase the sample size. This should result in a decent-sized scored dataset on which you can adequately evaluate the predictive performance of your classifier with metrics such as accuracy, precision, or F1 Score.

  * Tweak the prompt to improve performance or get more specific explanations.




If you want a high-level introduction to LLMs in the context of Dataiku, check out [this guide](<https://content.dataiku.com/llms-dataiku/dataiku-llm-starter-kit>).

Here are the complete versions of the code presented in this tutorial:

LLM MeshLangchain-compatible LLMLangchain-compatible chat LLM

[notebook.py](<../../../../_downloads/ce8fc47098c5ffb575e9a4c9df4c2557/notebook.py>)
    
    
    import dataiku
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms()
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    
    LLM_ID = ""  # Fill with a valid LLM_ID
    llm = project.get_llm(LLM_ID)
    
    completion = llm.new_completion()
    resp = completion.with_message("Q1: When was the movie Citizen Kane released?").execute()
    if resp.success:
        print(resp.text)
    else:
        print("Something went wrong. Check you have the permission to use the LLM.")
    
    completion = llm.new_completion()
    question = "When was the movie Citizen Kane released?"
    system_msg = """You are an expert in the history of American cinema.
    You always answer questions with a lot of passion and enthusiasm.
    """
    
    resp = completion.with_message(role="system", message=system_msg).with_message(role="user", message=question).execute()
    if resp.success:
        print(resp.text)
    else:
        print("Something went wrong. Check you have the permission to use the LLM.")
    

[recipe.py](<../../../../_downloads/56592563fd3aef7cfdb4d0965819f1f1/recipe.py>)
    
    
    import dataiku
    import ast
    
    LLM_ID = ""  # Fill with a valid LLM_ID
    SSIZE = 10
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID)
    
    input_dataset = dataiku.Dataset("reviews")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"},
        {"type": "string", "name": "llm_explanation"}
    ]
    output_schema = input_dataset.read_schema() + new_cols
    output_dataset = dataiku.Dataset("reviews_sample_llm_scored")
    output_dataset.write_schema(output_schema)
    
    system_msg = f"""
    You are an assistant that classifies reviews according to their sentiment. \
    Respond in json format with the keys: llm_sentiment and llm_explanation. \
    The value for llm_sentiment should only be either pos or neg without punctuation: pos if the review is positive, neg otherwise.\
    The value for llm_explanation should be a very short explanation for the sentiment.
    """
    
    cnt = 0
    with output_dataset.get_writer() as w:
        for r in input_dataset.iter_rows():
            completion = llm.new_completion()
            llm_out = completion.with_message(role="system", message=system_msg).with_message(r.get("text")).execute()
            w.write_row_dict({**dict(r), **(ast.literal_eval(llm_out.text))})
            cnt += 1
            if cnt == SSIZE:
                break
    

[notebook.py](<../../../../_downloads/04fb2659e26e87971e49a4dee9108a10/notebook_lcllm.py>)
    
    
    import dataiku
    from langchain_core.messages import HumanMessage, SystemMessage
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms()
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    
    LLM_ID = ""  # Fill with a valid LLM_ID
    llm = project.get_llm(LLM_ID)
    lcllm = llm.as_langchain_llm()
    lcllmResp = lcllm.invoke("When was the movie Citizen Kane released?")
    print(lcllmResp)
    
    question = "When was the movie Citizen Kane released?"
    system_msg = """You are an expert in the history of American cinema.
    You always answer questions with a lot of passion and enthusiasm.
    """
    
    messages = [
        SystemMessage(content=system_msg),
        HumanMessage(content=question)
    ]
    
    lcllmResp = lcllm.invoke(messages)
    print(lcllmResp)
    

[recipe.py](<../../../../_downloads/9291f8ffb200dc67bd576d8d93660b7d/recipe_lcllm.py>)
    
    
    import dataiku
    import ast
    from langchain_core.messages import HumanMessage, SystemMessage
    
    LLM_ID = ""  # Fill with a valid LLM_ID
    SSIZE = 10
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm = project.get_llm(LLM_ID).as_langchain_llm()
    
    input_dataset = dataiku.Dataset("reviews")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"},
        {"type": "string", "name": "llm_explanation"}
    ]
    output_schema = input_dataset.read_schema() + new_cols
    output_dataset = dataiku.Dataset("reviews_sample_llm_scored")
    output_dataset.write_schema(output_schema)
    
    system_msg = f"""
    You are an assistant that classifies reviews according to their sentiment. \
    Respond in json format with the keys: llm_sentiment and llm_explanation. \
    The value for llm_sentiment should only be either pos or neg without punctuation: pos if the review is positive, neg otherwise.\
    The value for llm_explanation should be a very short explanation for the sentiment.
    """
    
    cnt = 0
    with output_dataset.get_writer() as w:
        for r in input_dataset.iter_rows():
            messages = [
                SystemMessage(content=system_msg),
                HumanMessage(content=r.get("text"))
            ]
            llm_out = llm.invoke(messages)
            w.write_row_dict({**dict(r), **(ast.literal_eval(llm_out))})
            cnt += 1
            if cnt == SSIZE:
                break
    

[notebook.py](<../../../../_downloads/7d96ee70be3a815f7444c217cf3e6d69/notebook_chat.py>)
    
    
    import dataiku
    from langchain_core.messages import HumanMessage, SystemMessage
    
    client = dataiku.api_client()
    project = client.get_default_project()
    llm_list = project.list_llms()
    for llm in llm_list:
        print(f"- {llm.description} (id: {llm.id})")
    
    LLM_ID = "" #Fill with a valid LLM_ID
    llm = project.get_llm(LLM_ID)
    chat = llm.as_langchain_chat_model()
    chatResp = chat.invoke("When was the movie Citizen Kane released?")
    print(chatResp.content)
    
    question = "When was the movie Citizen Kane released?"
    system_msg = """You are an expert in the history of American cinema.
    You always answer questions with a lot of passion and enthusiasm.
    """
    
    messages = [
        SystemMessage(content=system_msg),
        HumanMessage(content=question)
    ]
    
    chatResp = chat.invoke(messages)
    print(chatResp.content)
    

[recipe.py](<../../../../_downloads/137d805937cbaecea3947acbe6d53be1/recipe_chat.py>)
    
    
    import dataiku
    import ast
    from langchain_core.messages import HumanMessage, SystemMessage
    
    LLM_ID = ""  # Fill with a valid LLM_ID
    SSIZE = 10
    
    client = dataiku.api_client()
    project = client.get_default_project()
    chat = project.get_llm(LLM_ID).as_langchain_chat_model()
    
    input_dataset = dataiku.Dataset("reviews")
    new_cols = [
        {"type": "string", "name": "llm_sentiment"},
        {"type": "string", "name": "llm_explanation"}
    ]
    output_schema = input_dataset.read_schema() + new_cols
    output_dataset = dataiku.Dataset("reviews_sample_llm_scored")
    output_dataset.write_schema(output_schema)
    
    system_msg = f"""
    You are an assistant that classifies reviews according to their sentiment. \
    Respond in json format with the keys: llm_sentiment and llm_explanation. \
    The value for llm_sentiment should only be either pos or neg without punctuation: pos if the review is positive, neg otherwise.\
    The value for llm_explanation should be a very short explanation for the sentiment.
    """
    
    cnt = 0
    with output_dataset.get_writer() as w:
        for r in input_dataset.iter_rows():
            messages = [
                SystemMessage(content=system_msg),
                HumanMessage(content=r.get("text"))
            ]
            chat_out = chat.invoke(messages)
            w.write_row_dict({**dict(r), **(ast.literal_eval(chat_out.content))})
            cnt += 1
            if cnt == SSIZE:
                break

---

## [tutorials/genai/nlp/openaiXmesh/index]

# Using OpenAI-compatible API calls via the LLM Mesh

An OpenAI-compatible [Python client](<../../../../concepts-and-examples/llm-mesh.html>) is available for the LLM Mesh. You can use it to send both Chat Completions API and Responses API requests through the same governed endpoint. Instead of handling separate API keys and endpoints for each provider, you can use the LLM Mesh to:

  * Access multiple models using OpenAI’s standard Python format …

  * while maintaining centralized governance, monitoring and cost control …

  * and easily switching between different LLM providers




## Prerequisites

Before starting, ensure you have:

  * Dataiku >= 13.2 for Chat Completions API examples

  * Dataiku >= 14.4.3 for Responses API examples

  * A valid Dataiku API key

  * Project permissions for “Read project content” and “Write project content”

  * An existing OpenAI LLM Mesh connection

  * Python environment with the `openai` package installed




## OpenAI client for the LLM Mesh

Set up the OpenAI client by pointing to its LLM Mesh configuration. You will need several pieces of information for access and authentication:

  * A public Dataiku URL to access the LLM Mesh API

  * An API key for Dataiku

  * The LLM ID



    
    
    from openai import OpenAI
    
    # Specify the Dataiku OpenAI-compatible public API URL, e.g. http://my.dss/public/api/projects/PROJECT_KEY/llms/openai/v1/
    BASE_URL = ""
    
    # Use your Dataiku API key instead of an OpenAI secret
    API_KEY = ""
    
    # Fill with your LLM id - to get the list of LLM ids, you can use dataiku.api_client().project.list_llms()
    LLM_ID = "" 
    
    # Initialize the OpenAI client
    client = OpenAI(
        base_url=BASE_URL,
        api_key=API_KEY
    )
    
    # Default parameters
    DEFAULT_TEMPERATURE = 0
    DEFAULT_MAX_TOKENS = 500
    

Tip

In case you need to find the `LLM ID`, there’s a standard way to look up all available LLM Mesh configured APIs using the `dataiku` client. Use the `project.list_llms()` method and note down the OpenAI model you want to use. It will look something like `openai:CONNECTION-NAME:MODEL-NAME`.

## Choosing an API surface

The LLM Mesh exposes both OpenAI-compatible endpoints from the same base URL:

  * `client.chat.completions.create(...)` for the classic chat-completions format

  * `client.responses.create(...)` for OpenAI’s Responses API




Use the Chat Completions API when you want the familiar `messages=[...]` format. Use the Responses API when you want the newer `input` format, typed content items, or event-based streaming. The OpenAI client automatically targets the matching LLM Mesh endpoint for the method you call.

## Making requests to OpenAI via LLM Mesh

Now you can make requests to the LLM just like you would with the standard OpenAI API:

Chat Completions APIResponses API
    
    
    # Create a prompt
    
    context = '''You are a capable ghost writer 
      who helps college applicants'''
    
    content = '''Write a complete 350-word short essay 
      for a college application on the topic - 
      My first memories.'''
    
    
    prompt = [
        {"role": "system", 
          "content": context}, 
        {'role': 'user',
          'content': content}
    ]
    
    # Send the request
    try:
        response = client.chat.completions.create(
            model=LLM_ID,
            messages=prompt,
            temperature=DEFAULT_TEMPERATURE,
            max_tokens=DEFAULT_MAX_TOKENS
        )
        
        print(response.choices[0].message.content)
    except Exception as e:
        print(f"Error making request: {e}")
    
    
    
    context = '''You are a capable ghost writer
      who helps college applicants'''
    
    content = '''Write a complete 350-word short essay
      for a college application on the topic -
      My first memories.'''
    
    try:
        response = client.responses.create(
            model=LLM_ID,
            instructions=context,
            input=content,
            max_output_tokens=DEFAULT_MAX_TOKENS
        )
    
        print(response.output_text)
    except Exception as e:
        print(f"Error making request: {e}")
    

Note

The Responses API uses `input` instead of `messages`, returns generated text in `response.output_text`, and streams typed events instead of chat-completion delta chunks.

## Using typed input with the Responses API

For simple prompts, a string `input` is enough. For multimodal inputs or multi-turn conversations, pass a list of typed items instead:
    
    
    typed_input = [
        {
            "role": "user",
            "content": [
                {
                    "type": "input_text",
                    "text": "Summarize the three most important points about governed LLM access."
                }
            ]
        }
    ]
    
    response = client.responses.create(
        model=LLM_ID,
        input=typed_input,
        max_output_tokens=DEFAULT_MAX_TOKENS
    )
    
    print(response.output_text)
    

On follow-up, you can also pass prior `response.output` items back into the next `input` list, together with any `function_call_output` items you generate locally.

## Wrapping up

Now that you have the basic setup working, you can:

  * Experiment with both `client.chat.completions.create(...)` and `client.responses.create(...)`

  * Use typed `input` items with the Responses API for multimodal prompts or tool-calling loops

  * Try structured outputs with `client.responses.parse(...)` when your model and provider support them

  * Use other LLM providers available through the LLM Mesh

  * Learn more about the OpenAI-compatible setup in the [LLM Mesh concept page](<../../../../concepts-and-examples/llm-mesh.html>)




## Streaming

The Chat Completions API and the Responses API both support streaming through the same LLM Mesh endpoint, but the event shape differs:

  * The Chat Completions API streams delta chunks

  * The Responses API streams typed events such as `response.created`, `response.output_text.delta`, and `response.completed`


[chat_completions_streaming.py](<../../../../_downloads/ee3cd0d6fb4f41a4fff117b1b52124bc/chat_completions_streaming.py>)

Code 1 – Streaming with the Chat Completions API
    
    
    print("📚 .. imports ... ")
    print("🤖 .. Python client for OpenAI API calls ...")
    from openai import OpenAI
    
    print("⏱ .. library for timing ...")
    import time
    import httpx # in case of self-signed certificates
    print("\n\n")
    
    # Specify the Dataiku OpenAI-compatible public API URL, e.g. http://my.dss/public/api/projects/PROJECT_KEY/llms/openai/v1/
    BASE_URL = ""
    
    # Use your Dataiku API key instead of an OpenAI secret
    API_KEY = ""
    
    # Fill with your LLM id - to get the list of LLM ids, you can use dataiku.api_client().project.list_llms()
    LLM_ID = "" 
    
    # Create an OpenAI client
    open_client = OpenAI(
      base_url=BASE_URL,
      api_key=API_KEY,
      http_client=httpx.Client(verify=False)  # in case of self-signed certificates
    )
    
    print("🔑 .. client created, key set ...")
    
    
    DEFAULT_TEMPERATURE = 0
    DEFAULT_MAX_TOKENS = 1000
    
    print("\n\n")
    
    context = '''You are a capable ghost writer 
      who helps college applicants'''
    
    content = '''Write a complete 500-word short essay 
      for a college application on the topic - 
      My first memories.'''
    
    prompt = [
        {"role": "system", 
         "content": context}, 
        {'role': 'user',
         'content': content}
    ]
    
    
    print(f"This is the prompt: {content}")
    print("\n\n")  
    
    print("⏲ .. Record the time before the request is sent ..")
    start_time = time.time()
    
    print("📤 .. Send a ChatCompletion request ...")
    response = open_client.chat.completions.create(
        model=LLM_ID,
        stream=True,
        messages=prompt,
        temperature=DEFAULT_TEMPERATURE,
        max_tokens=DEFAULT_MAX_TOKENS
    )
    
    
    collected_chunks = []
    collected_messages = []
    
    # iterate through the stream of events
    for chunk in response:
        chunk_time = time.time() - start_time  # calculate the time delay of the chunk
        collected_chunks.append(chunk)  # save the event response
        chunk_message = chunk.choices[0].delta  # extract the message
        collected_messages.append(chunk_message)  # save the message
        if hasattr(chunk_message, 'content'):
            print(chunk_message.content, end="")
    
    print("\n\n\n")  
    
    # print the time delay and text received
    print(f"Full response received {chunk_time:.2f} seconds after request")
    full_reply_content = ''.join([m.content for m in collected_messages if hasattr(m, 'content') and m.content is not None])
    

[responses_streaming.py](<../../../../_downloads/ca123aa73380b8b226abd01290da8f3c/responses_streaming.py>)

Code 2 – Streaming with the Responses API
    
    
    from openai import OpenAI
    
    import httpx  # Optional: useful for self-signed certificates
    
    # Specify the Dataiku OpenAI-compatible public API URL, e.g. http://my.dss/public/api/projects/PROJECT_KEY/llms/openai/v1/
    BASE_URL = ""
    
    # Use your Dataiku API key instead of an OpenAI secret
    API_KEY = ""
    
    # Fill with your LLM id - to get the list of LLM ids, you can use dataiku.api_client().project.list_llms()
    LLM_ID = ""
    
    client = OpenAI(
        base_url=BASE_URL,
        api_key=API_KEY,
        http_client=httpx.Client(verify=False),  # Optional: for self-signed certificates
    )
    
    stream = client.responses.create(
        model=LLM_ID,
        input="Write a short poem about governed AI platforms.",
        stream=True,
    )
    
    collected_text = []
    
    for event in stream:
        if event.type == "response.output_text.delta":
            print(event.delta, end="")
            collected_text.append(event.delta)
        elif event.type == "response.completed":
            print("\n")
    
    full_text = "".join(collected_text)
    print(full_text)
    

Remember that all requests go through the LLM Mesh, which provides monitoring and governing capabilities while maintaining the familiar OpenAI API interface.

---

## [tutorials/govern/action-calculation/index]

# Manipulating Artifact Fields with Govern Custom Actions  
  
In this tutorial, you will learn how to use Govern Custom Actions to read from and write to artifact fields. We’ll be reading from three params and writing to two fields. We’ll be doing a simple calculation for a fictional “potential” value.

## Prerequisites

  * Govern Node 14.4 or higher with Advanced License

  * A Govern project

    * Which you can freely edit

    * Using a blueprint version you can freely edit




## Project Setup

In this tutorial, we’ll look into Custom Actions to manipulate artifact fields. In order to do this, we’ll need to configure our blueprint to have those fields. Furthermore, we’ll then add the Custom action to our blueprint that will leverage params.

To create a Govern project, head over to the **Blueprint Designer** using the top-right waffle menu, then proceed to fork the default Govern Project. Then go to the Governed Project page using the navigation bar on top, and create a new project using the blue **Create** button on the top right, and select your newly created blueprint version.

Important

If you do not know how to use the Blueprint designer to create a new version of the Govern Project blueprint, you might want to check this tutorial: [Tutorial | Custom governance templates](<https://knowledge.dataiku.com/latest/govern/customization/custom-templates/tutorial-index.html> "\(in Dataiku Academy v14.0\)").

### Set up custom fields

For this tutorial we need to create two fields where we’ll put our potential calculation results: **Q1 potential** and **Year potential**.

First, navigate to your Govern project you’re going to edit, then click the **3-dots menu** on the top right, and click the **Edit blueprint version** menu option.

You’ll be redirected to the blueprint version you’ve used to create the project. Head over to the **Fields** tab using the left-hand navigation. Next, we’ll be adding the fields. You can add a field by pressing the blue **+** button next to the **Fields** header on the left.

Add these fields, both of type **number**. Make sure the **ID** s are as follows (and name them appropriately):

  * q1_potential

  * projected_year_potential




Once you’ve added the fields, you can click **Save** on the top right; however as we’ll continue editing the blueprint, you don’t have to.

### Create custom action

Now we’ll create the custom action (placeholder). For the purpose of flow, we’ll keep the action as a placeholder. We’ll dive into editing the action after it’s been placed in the view.

As you are still editing the blueprint, you should see the **Actions** tab on the left of the screen. Click this tab and then click the blue **+** button in the left-hand sidebar.

Give the action a name such as _Potential Calculator_ and change the **ID** at this stage if you want to. As with the custom fields, you can click **Save** now on the top right.

### Adding the fields and action to a view

Now that we have created 2 fields and 1 action, it’s time to add them to a view so we can use them.

First, click the **Views** tab on the left of the screen. Then, either use an existing view or create a new view for your project. For simplicity reasons, I recommend reusing the _Exploration info_ view. Click **Exploration info** , and add all the created fields and the action. You can add any field by clicking the 3 dots at an existing field, choose **Insert View Component** , and then select either before or after.

You can see how to do this in the image below.

To add the fields you just created, select type **Fields** in the dialog, and then filter on _Potential_ to find the relevant fields.

After adding them, click the **Create** button on the bottom-right of the dialog.

Next, using the same method as before, insert another view component above “Q1 Potential”. And now you select type **Action**. Then select the action created earlier and add the **Action button label** , as shown in the image below.

We’ll also be adding 3 **input params** to the Action button. To add input params, type the name of the field and then type **,** between each param. You should be adding **January** , **February** and **March** as shown in the screenshot. Make sure you have the capitalization correct as these params are case-sensitive.

Click the **Create** button to add the action to your view.

Optionally, you can remove any fields from the **Exploration info** that are not required for this tutorial, and then click **Save** on the top right. You will get a warning dialog, and you can click **Save** again on the dialog.

## Configure the Custom Action

Now that we have all the moving parts in place, we can go ahead and actually write our custom action. Go back to the **Actions** tab on the left of the screen and click on the **Potential Calculator** action you created earlier.

At this point, you can remove the sample code provided.

First, we’ll get the fields in the current artifact.

Retrieve action fields
    
    
    from govern.core.artifact_action_handler import get_artifact_action_handler
    
    handler = get_artifact_action_handler()
    client = handler.client
    
    artifact_id = handler.enrichedArtifact.artifact.id
    artifact = client.get_artifact(artifact_id)
    
    definition = artifact.get_definition()
    raw_data = definition.get_raw()
    fields = raw_data.setdefault("fields", {})
    

In the code above, we’re getting the fields from the current artifact. But of course, this requires several steps to get the raw data.

Next, we’re going to fetch the value of the three month params we’ve defined earlier. For this, we’re also going to convert the value to float just in case the field is empty or contains non-numeric values.

Fetching month fields
    
    
    MONTH_FIELDS = ["January", "February", "March"]
    
    def to_float(value):
        if value in (None, ""):
            return 0.0
        try:
            return float(value)
        except (ValueError, TypeError):
            return 0.0
    
    params = handler.params or {}
    field_values = [to_float(params.get(key)) for key in MONTH_FIELDS]
    

Note

We’re reading from `handler.params` here to do calculations. But remember you can just as easily also read from fields by replacing `params.get` to `fields.get`.

In the code above, we have created a list of values from the three params provided. As you can see this logic can easily be expanded by adding more months or removing some. And furthermore, this script will also work if one or more fields are left empty or have non-numeric values.

The next step is to do our calculations. As you might’ve guessed from the names of the fields created, we’ll calculate the total potential of Q1, as well as full-year projections.

In practice, this means we’ll compute a `sum` for Q1 and multiply the 3-month average by 12.

In code, this looks like this:

Calculating Q1 and year projection
    
    
    q1_total = sum(field_values)
    avg_month = q1_total / len(MONTH_FIELDS)
    projected_year = avg_month * 12.0
    

As you can see, the code is relatively straightforward, just a few basic calculation lines.

Lastly, we’ll need to set the two defined fields with the values we just calculated, and save the values so they’ll be visible on screen.

Saving values
    
    
    fields["q1_potential"] = q1_total
    fields["projected_year_potential"] = projected_year
    
    definition.save()
    
    handler.status = "OK"
    handler.message = f"Updated q1_potential={q1_total:.2f} and projected_year_potential={projected_year:.2f}"
    

As you can see, for setting data, we only need the `ID` of the relevant fields. This is why you needed to have the `ID`s correct when creating the fields.

We also provided an `OK` status to the handler. Setting the status to `ERROR` would’ve displayed a red error box instead. You can use this when making more complex custom actions, or, for example, if you wanted to make the 3 “month params” mandatory to run this custom action.

The `handler.message` text will be displayed next to the action button. In our case, we’ve given the calculated values directly, but of course, they will be displayed in the fields themselves as well. Feel free to configure this as you please.

Make sure you click the **Save** button on the top right once you’ve provided the full code.

## Complete code

We’ve now gone through all the code required to make this custom action work. However, for reference, the full code is displayed below if you want an easy copy-pasteable example. In the next step, we’ll go to testing the code.

Full custom action code
    
    
    from govern.core.artifact_action_handler import get_artifact_action_handler
    
    MONTH_FIELDS = ["January", "February", "March"]
    
    def to_float(value):
        if value in (None, ""):
            return 0.0
        try:
            return float(value)
        except (ValueError, TypeError):
            return 0.0
    
    
    handler = get_artifact_action_handler()
    client = handler.client
    
    artifact_id = handler.enrichedArtifact.artifact.id
    artifact = client.get_artifact(artifact_id)
    
    definition = artifact.get_definition()
    raw_data = definition.get_raw()
    fields = raw_data.setdefault("fields", {})
    
    params = handler.params or {}
    field_values = [to_float(params.get(key)) for key in MONTH_FIELDS]
    
    q1_total = sum(field_values)
    avg_month = q1_total / len(MONTH_FIELDS)
    projected_year = avg_month * 12.0
    
    fields["q1_potential"] = q1_total
    fields["projected_year_potential"] = projected_year
    
    definition.save()
    
    handler.status = "OK"
    handler.message = f"Updated q1_potential={q1_total:.2f} and projected_year_potential={projected_year:.2f}"
    

## Testing the custom action

Now that you have the custom action configured, it is time to test it. At this point, return to your Govern Project you created for this tutorial, or create a project now using the blueprint you have just altered.

Once in your project, click the **Exploration** view on the left. In case you configured a different view for your fields, click that one instead.

Your screen should now look like this:

Click the **Edit** button on the top right and input some numbers into the January/February/March fields. Then click the **Save** button on the top right. You should now see the numbers printed above your custom action button. Click your action button **Calculate Potential** , and very quickly, you should see a success message with the correct message. And, most importantly, the calculated values should be a sum of the first 3 months, and a projection for the rest of the year.

## Wrapping up

Now you understand how to read from params (or fields) and write to fields using a custom action. This is a very important building block in understanding how to integrate with artifacts and fields, using custom actions.

As a custom action is a fully configurable Python script you can do much more with it, such as calling Scenarios on the design node. If you use the [How to trigger Scenarios from a Govern node](<../hooks-and-scenarios/index.html>) tutorial as your guideline but apply that logic in the action button instead, you now know how to call scenarios using a button click. Not only that, but you can also call any external service here, or integrate any LLM or Agent directly, so you can use GenAI to fill fields.

## Reference documentation

### Classes

[`dataikuapi.govern.artifact.GovernArtifact`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifact> "dataikuapi.govern.artifact.GovernArtifact")(...) | A handle to interact with an artifact on the Govern instance.  
---|---  
[`dataikuapi.govern.artifact.GovernArtifactDefinition`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactDefinition> "dataikuapi.govern.artifact.GovernArtifactDefinition")(...) | The definition of an artifact.  
  
### Functions

[`get_artifact`](<../../../api-reference/python/govern.html#dataikuapi.govern_client.GovernClient.get_artifact> "dataikuapi.govern_client.GovernClient.get_artifact")(artifact_id) | Return a handle to interact with an artifact.  
---|---  
[`get_definition`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifact.get_definition> "dataikuapi.govern.artifact.GovernArtifact.get_definition")() | Retrieve the artifact definition and return it as an object.  
[`get_raw`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactDefinition.get_raw> "dataikuapi.govern.artifact.GovernArtifactDefinition.get_raw")() | Get the raw content of the artifact.  
[`save`](<../../../api-reference/python/govern.html#dataikuapi.govern.artifact.GovernArtifactDefinition.save> "dataikuapi.govern.artifact.GovernArtifactDefinition.save")() | Save this settings back to the artifact.

---

## [tutorials/govern/hooks-and-scenarios/index]

# How to trigger Scenarios from a Govern node

In this tutorial, you will learn how to leverage **Hooks** inside a Govern Blueprint to initiate actions or more complex operations on your design node. This is particularly useful when you need certain Python packages, external connections, or want to initiate actions on the design node when a particular action happens on the Govern node.

## Prerequisites

  * Dataiku version 14 or higher

  * Dataiku Govern Node with a customisation license

  * A configured Govern project

  * An API key for the Design node




If you don’t yet have a configured Govern project, check this tutorial: [Tutorial | Governance basics](<https://knowledge.dataiku.com/latest/govern/overview/basics/tutorial-index.html> "\(in Dataiku Academy v14.0\)")

## Introduction

In this tutorial, you will understand how a connection works from the Govern node to the Design node. This will allow you to initiate actions on the design node triggered by events on the Govern node.

For demonstration purposes, we’ll log events on the Govern node in a dataset on the Design node.

## Setting up a scenario

Calling a scenario from a Govern node is a best practice when you want to initiate any complex code straight from the Govern node. For this reason, we’ll demonstrate how to connect to a scenario straight from a govern node.

### Creating a Design Project

On your Design node, create a blank project and give it the name `Govern Event Receiver`. If no duplicates are found, you should have a project with the key `GOVERNEVENTRECEIVER`. We’ll use this key in the Govern Node to connect to the Scenario.

### Create a dataset

In this tutorial, we’ll log some simple events in a dataset on the Design node using a Scenario. Therefore, the first thing we’ll do is create a dataset to which we can log things. We’ll keep it incredibly simple, but of course, feel free to add more fields if you prefer that.

Head over to your Design node. Then, using the top navigation, head to **Datasets** or press `G`+`D`.

Click **New Dataset** and click **Connect or create**. For this tutorial, we’ll select the `Managed Dataset` option. However, every SQL/NoSQL should work for this tutorial.

Enter the name `govern_event_log`, and choose your storage system. Click the **Create** button to initialize the dataset. You will be redirected to the **Settings** tab of the dataset. From this tab click on the **Schema** sub-tab.

Here we’ll create 3 fields in the dataset. Click the **\+ Add Column** button 3 times, and then enter the following details as the `Name` and `type`:

  * `event_type` with type `string`

  * `project_key` with type `string`

  * `timestamp` with type `datetime with tz`




Next, click the **Save** button on the top-right, and return to the **Connection** sub-tab. At this page you can now click **Create Table Now** on the bottom, which should finalize the creation of your table.

To confirm the table is created, click the **Explore** tab and you should see the 3 columns displayed with zero rows.

See also

  * [Data Exploration](<https://knowledge.dataiku.com/latest/import-data/exploration/index.html> "\(in Dataiku Academy v14.0\)")




### Create the Scenario

Now, create a Scenario by clicking the **>** menu in the top navigation bar, and then click **Scenarios**.

On the top right, click **\+ New Scenario** and choose **Custom Python Script**. Give it the name `Receiver` and click **Create**.

Then head over to the **Script** tab and paste the script below.

Code to receive events from Govern
    
    
    import dataiku
    from dataiku.scenario import Scenario
    from datetime import datetime, timezone
    sc = Scenario()
    
    # Trigger parameters passed from the Govern hook
    params = sc.get_trigger_params() or {}
    
    # Dataset where we append audit rows
    event_ds = dataiku.Dataset("govern_event_log")
    event_ds.spec_item["appendMode"] = True
    
    # Build the row to insert
    row = {
        "event_type": params.get("event_type"),
        "project_key": params.get("project_key"),
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }
    
    # Append one row to the SQL dataset
    with event_ds.get_writer() as writer:
        writer.write_row_dict(row)
    

In the code above, you can see we’re getting the parameters sent to the Scenario through the `get_trigger_params()` function. From there, we directly created a new row for the dataset we created earlier, using the provided parameters.

### Test the Scenario

Before we proceed to create the hook that sends data to your Design node, we need to ensure that the Scenario actually works.

It’s really easy to test this by using the **Run** button on the top right of your scenario screen. You can run it directly by clicking the button, or you can press the **down arrow** next to the **Run** button and click **Run with custom parameters**. Choose this and paste the following data in the dialog:
    
    
    {
       "event_type": "TEST",
       "project_key": "run.button"
    }
    

Then click the **Run** button on the dialog. The dialog should now close and the Scenario should’ve run.

To validate the run succeeded, click the **Last runs** tab, and then you should see a log like this in the left-hand sidebar:

This means your scenario ran successfully. To validate it actually has written the data, head over to Datasets by pressing `G`+`D`, and then click your `govern_event_log` dataset. You should see the data written in the **Explore** tab.

This means your Scenario ran successfully and is able to receive input from the govern node through the params. If you’ve clicked the **Run** button in Scenarios without custom parameters you will see some fields empty.

## Create a hook on the Govern node

Now that your Design node is ready to receive data, it is time to focus on actually sending logs from the Govern node.

See also

If you need details on setting up a Govern project or creating a blueprint (version), use the links below

  * [Tutorial | Governance basics](<https://knowledge.dataiku.com/latest/govern/overview/basics/tutorial-index.html> "\(in Dataiku Academy v14.0\)")

  * [Introduction to Blueprint Designer](<https://doc.dataiku.com/dss/latest/governance/blueprint-designer/blueprint-designer.html> "\(in Dataiku DSS v14\)")




First thing you’ll need to do is find your governed project in the Govern node. Navigate into your project to start our tutorial.

Hint

Your Govern project does not need to be connected to a design project for this tutorial to work. So if you do not have a ready-to-go configured Govern project, it’s fine to create one from a template. Just make sure you have an editable Blueprint to work with

### Create the blueprint

When you’re in your Govern project, click the **Additional actions** button next to the **Edit** button. Then click **Edit blueprint version**. You’ll navigate to the blueprint page. On the left-hand menu, click the **Hooks** button.

Hint

Using this flow brings you to the currently used Blueprint version in your Govern project. Keep in mind that more than one version of the Blueprint can be in use, and your edits only apply to the one you selected.

From there, create a new hook using the blue **+** button on the top of the sidebar.

For the name, enter something like `Log actions` and select all **Phases** in the dropdown: **Create** , **Update** , and **Delete**.

Then, in the script section, enter the necessary imports.

Hook code imports
    
    
    from govern.core.handler import get_handler
    import dataikuapi
    import logging
    
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    

### Configuring connection

The next step is to define constants to connect to your Design node. You will need to provide the **URL** of your node, an **API key** , **Project ID** , and **Scenario ID**.

Hook code imports
    
    
    # URL of the instance that hosts the Design project
    DSS_URL = "https://dss.example.com/"
    
    # API KEY that has access to the Scenario on your Design Node
    DSS_API_KEY = "API_KEY" 
    
    # Target project and scenario on the Design Node
    TARGET_PROJECT_ID = "DESIGN_PROJECT_KEY"
    TARGET_SCENARIO_ID = "SCENARIO_ID"
    

Hint

You can get an API key on the design node by clicking on your **profile** on the top right and then clicking on the **Cogs** to go to **Profile and settings**. There you will have a tab called **API keys**. Create a new API key and give it a descriptive name and description.

If you have the created Scenario open you can retrieve all the relevant details straight from the URL.
    
    
    https://[DSS_URL]/projects/[TARGET_PROJECT_ID]/scenarios/[TARGET_SCENARIO_ID]/script
    

### Defining the payload

The next section of our Hook code will define the payload. We’ll need to extract some information from the `handler` to log the details we discussed earlier. Then we’ll define a function to create the payload we’ll send to the Scenario.

Defining payload
    
    
    handler = get_handler()
    
    enriched = handler.newEnrichedArtifact
    artifact = enriched.artifact
    
    def build_event_payload():
        definition = artifact.json
    
        project_key = definition.get("name")
    
        event = {
            "event_type": handler.hookPhase,
            "project_key": project_key,
        }
    
        return event
    

We’ll call the function above in a next step.

### Trigger the Scenario

Triggering the Scenario is straightforward with the imported `dataikuapi`. We’ll connect to the Design node using the `URL` and `API_KEY`, and then we’ll define the `project` and `scenario` with the relevant `IDs` defined in our configuration step.

From there, we’ll only have to use the `scenario.run` function with our payload.

Calling scenario
    
    
    def trigger_dss_scenario(event_payload):
    
        dss_client = dataikuapi.DSSClient(DSS_URL, DSS_API_KEY)
    
        project = dss_client.get_project(TARGET_PROJECT_ID)
        scenario = project.get_scenario(TARGET_SCENARIO_ID)
    
        run = scenario.run(params=event_payload)
    

### Putting it together

Now that we have both relevant functions defined it is time to put them together and actually call the Scenario properly.

Defining payload
    
    
    try:
        payload = build_event_payload()
        trigger_dss_scenario(payload)
    except Exception:
        logger.exception("Failed to trigger DSS logging scenario")
    

If you have pasted all blocks of code so far consecutively, you have completed the relevant code. You can now click `Save` in the top-right button.

Your full code in the hook should match this:

Full hook code
    
    
    from govern.core.handler import get_handler
    import dataikuapi
    import logging
    
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    # URL of the instance that hosts the Design project
    DSS_URL = "https://dss.example.com/"
    
    # API KEY that has access to the Scenario on your Design Node
    DSS_API_KEY = "API_KEY" 
    
    # Target project and scenario on the Design Node
    TARGET_PROJECT_ID = "DESIGN_PROJECT_KEY"
    TARGET_SCENARIO_ID = "SCENARIO_ID"
    
    handler = get_handler()
    
    enriched = handler.newEnrichedArtifact
    artifact = enriched.artifact
    
    def build_event_payload():
        definition = artifact.json
    
        project_key = definition.get("name")
    
        event = {
            "event_type": handler.hookPhase,
            "project_key": project_key,
        }
    
        return event
    
    def trigger_dss_scenario(event_payload):
    
        dss_client = dataikuapi.DSSClient(DSS_URL, DSS_API_KEY)
    
        project = dss_client.get_project(TARGET_PROJECT_ID)
        scenario = project.get_scenario(TARGET_SCENARIO_ID)
    
        run = scenario.run(params=event_payload)
    
    try:
        payload = build_event_payload()
        trigger_dss_scenario(payload)
    except Exception:
        logger.exception("Failed to trigger DSS logging scenario")
    

## Trigger the hook and see the results

We’ve completed all the code; now it is time to see it in action. Return to your Govern project and trigger an event that you’re monitoring. If you’ve selected all methods, so **Create** , **Update** , and **Delete** , then you can edit anything on the **Overview** or in one of the **Workflows** , for example.

Once you edit something and click **Save** again, it could take a few seconds for the hook to complete its action.

After a few seconds, return to your Design node, go to **Datasets** , and preview your **govern_event_log** table. In there, you should now see another entry with the `UPDATE` `event_type`, and it should have the Govern Project name logged as well. It should look like this:

## Conclusion

In this tutorial, you wired the Govern and your Design Node together: A hook reacts to lifecycle events in your Govern project, builds a small JSON payload, and calls a DSS scenario.

This, in turn, appends each event as a row in a PostgreSQL dataset. The result is an audit table that grows over time with event_type, Govern artifact ID, and a timestamp.

The same pattern goes beyond simple logging. You can route to different scenarios depending on the event type or logic, add more context from the artifact to the payload, or replace the logging with anything that is possible within Dataiku.

This allows you to write complex actions using simple hooks.

## Reference documentation

### Classes

[`dataikuapi.DSSClient`](<../../../api-reference/python/client.html#dataikuapi.DSSClient> "dataikuapi.DSSClient")(host[, api_key, ...]) | Entry point for the DSS API client  
---|---  
[`dataikuapi.dss.scenario.DSSScenario`](<../../../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenario> "dataikuapi.dss.scenario.DSSScenario")(client, ...) | A handle to interact with a scenario on the DSS instance.  
[`dataiku.scenario.Scenario`](<../../../api-reference/python/scenarios-inside.html#dataiku.scenario.Scenario> "dataiku.scenario.Scenario")() | Handle to the current (running) scenario.  
  
### Functions

[`get_trigger_params`](<../../../api-reference/python/scenarios-inside.html#dataiku.scenario.Scenario.get_trigger_params> "dataiku.scenario.Scenario.get_trigger_params")() | Returns a dictionary of the params set by the trigger that launched this scenario run  
---|---  
[`run`](<../../../api-reference/python/scenarios.html#dataikuapi.dss.scenario.DSSScenario.run> "dataikuapi.dss.scenario.DSSScenario.run")([params]) | Request a run of the scenario.

---

## [tutorials/govern/index]

# AI Governance

This tutorial section contains all articles in the AI Governance category. These articles will teach you how to use developer tools to improve Governance.

  * [How to trigger Scenarios from a Govern node](<hooks-and-scenarios/index.html>)

  * [Manipulating Artifact Fields with Govern Custom Actions](<action-calculation/index.html>)

---

## [tutorials/index]

# Tutorials

This section contains **tutorials** which will help you learn how to use and combine programmatic features of Dataiku through step-by-step exercises.

* * *

Administration

Manage Dataiku ecosystem, users and permissions.

[](<admin/index.html>)

AI Governance

Govern

[](<govern/index.html>)

Data Engineering

Advanced data preparation and feature engineering.

[](<data-engineering/index.html>)

Developer tools

Tooling and guidance to write code efficiently.

[](<devtools/index.html>)

Generative AI

Generative AI.

[](<genai/index.html>)

Machine Learning

Train, deploy and monitor predictive and generative AI models.

[](<machine-learning/index.html>)

Plugin development

Extend the native capabilities of Dataiku with custom-built components.

[](<plugins/index.html>)

Webapps

Web application development and management.

[](<webapps/index.html>)

xOps

Create bundles, deploy projects, and control infrastructures.

[](<xOps/index.html>)

---

## [tutorials/machine-learning/code-env-resources/hf-resources/index]

# Load and re-use a Hugging Face model

Machine learning use cases can involve a lot of input data and compute-heavy thus expensive model training. It is common to download _pre-trained models_ from remote repositories and use them instead. Hugging Face hosts a well-known [one](<https://huggingface.co/models>) with models ranging from text generation to image embedding passing by reasonning. In this tutorial you will see how you can leverage Dataiku functionnality to download and save a pre-trained text classification model. You will then re-use that model to predict a masked string in a sentence.

## Loading a model leveraging the model cache (recommended)

In this section, you will use Dataiku’s [Model Cache](<https://doc.dataiku.com/dss/latest/generative-ai/huggingface-models/model-cache.html#hugging-face-model-cache> "\(in Dataiku DSS v14\)") to download, save, and retrieve your Hugging model.

### Downloading the pre-trained model

The first step is to download the required assets for your pre-trained model. Run this snippet of code anywhere in DSS (for example in a Python recipe, in a Notebook, or even in an initialization script of a code environment):
    
    
    from dataiku.core.model_provider import download_model_to_cache
    
    download_model_to_cache("distilbert/distilbert-base-uncased")
    

This script retrieves a DistilBERT model from [Hugging Face](<https://huggingface.co/distilbert-base-uncased>) and stores it in the Dataiku Instance model cache.

Note that the model must have been enabled by your Dataiku admin in an [HuggingFace connection](<https://doc.dataiku.com/dss/latest/generative-ai/huggingface-models.html> "\(in Dataiku DSS v14\)"). For gated models, you must pass a connection name to use the HuggingFace authentication token.

### Using the pre-trained model for inference

#### Prerequisites

  * Dataiku >= 14.2.0

  * Python >= 3.9

  * A [Code Environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html> "\(in Dataiku DSS v14\)") with the following packages:
        
        transformers  # tested with 4.51.3
        torch         # tested with 2.7.0
        




You can now re-use this pre-trained model in your Dataiku Project’s Python Recipe or notebook. Here is an example adapted from a sample in the [model repository](<https://huggingface.co/distilbert-base-uncased/tree/main>) that fills the masked parts of a sentence with the appropriate word:
    
    
    import os
    
    from transformers import pipeline
    from dataiku.core.model_provider import get_model_from_cache
    
    model = get_model_from_cache("distilbert/distilbert-base-uncased")
    
    # predict masked output
    unmask = pipeline("fill-mask", model=model)
    input_sentence = "Lend me your ears and I'll sing you a [MASK]"
    resp = unmask(input_sentence)
    for r in resp:
        print(f"{r['sequence']} ({r['score']})")
    

Running this code should give you an output similar to this:
    
    
    lend me your ears and i ' ll sing you a lullaby (0.29884061217308044)
    lend me your ears and i ' ll sing you a tune (0.10296323150396347)
    lend me your ears and i ' ll sing you a song (0.10061406344175339)
    lend me your ears and i ' ll sing you a hymn (0.09704922884702682)
    lend me your ears and i ' ll sing you a cappella (0.034581173211336136)
    

## Loading a model using code environment ressources

In this section, you will use Dataiku’s [Code Environment Resources](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html#code-env-resources-directory> "\(in Dataiku DSS v14\)") feature to download and save a pre-trained text classification model from Hugging Face. Be careful when using large model in code environment ressources since the full models will be packed up with your environment which can easily represents dozens of GB.

### Prerequisites

  * [Dataiku >= 10.0.0](<https://doc.dataiku.com/dss/latest/release_notes/old/10.0.html#code-env-resources-v-10-0> "\(in Dataiku DSS v14\)")

  * Python >= 3.9

  * A [Code Environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html> "\(in Dataiku DSS v14\)") with the following packages:
        
        transformers  # tested with 4.54.1
        torch         # tested with 2.7.1
        




### Downloading the pre-trained model

The first step is to download the required assets for your pre-trained model. To do so, in the _Resources_ screen of your Code Environment, input the following **initialization script** then click on _Update_ :
    
    
    ## Base imports
    import os
    
    from dataiku.code_env_resources import clear_all_env_vars
    from dataiku.code_env_resources import grant_permissions
    from dataiku.code_env_resources import set_env_path
    from dataiku.code_env_resources import set_env_var
    
    # Clears all environment variables defined by previously run script
    clear_all_env_vars()
    
    ## Hugging Face
    # Set HuggingFace cache directory
    set_env_path("HF_HOME", "huggingface")
    set_env_path("TRANSFORMERS_CACHE", "huggingface/transformers")
    hf_home_dir = os.getenv("HF_HOME")
    transformers_home_dir = os.getenv("TRANSFORMERS_CACHE")
    
    # Import Hugging Face's transformers
    import transformers
    
    # Download pre-trained models
    model_name = "distilbert-base-uncased"
    MODEL_REVISION = "1c4513b2eedbda136f57676a34eea67aba266e5c"
    model = transformers.DistilBertModel.from_pretrained(model_name, revision=MODEL_REVISION)
    unmasker = transformers.DistilBertForMaskedLM.from_pretrained(model_name, revision=MODEL_REVISION)
    tokenizer = transformers.DistilBertTokenizer.from_pretrained(model_name, revision=MODEL_REVISION)
    
    # Grant everyone read access to pre-trained models in the HF_HOME folder
    # (by default, only readable by the owner)
    grant_permissions(hf_home_dir)
    grant_permissions(transformers_home_dir)
    

This script retrieves a DistilBERT model from [Hugging Face](<https://huggingface.co/distilbert-base-uncased>) and stores it in the Dataiku Instance.

Note that it will only need to run once, after that all users allowed to use the Code Environment will be able to leverage the pre-trained model without re-downloading it again.

### Using the pre-trained model for inference

You can now re-use this pre-trained model in your Dataiku Project’s Python Recipe or notebook. Here is an example adapted from a sample in the [model repository](<https://huggingface.co/distilbert-base-uncased/tree/main>) that fills the masked parts of a sentence with the appropriate word:
    
    
    import os
    
    from transformers import pipeline
    from transformers import DistilBertTokenizer, DistilBertForMaskedLM
    
    
    # Define which pre-trained model to use
    model = {"name": "distilbert-base-uncased",
             "revision": "1c4513b2eedbda136f57676a34eea67aba266e5c"}
    
    # Load pre-trained model
    hf_home_dir = os.getenv("HF_HOME")
    model_path = os.path.join(hf_home_dir,
                              f"transformers/models--{model['name']}/snapshots/{model['revision']}")
    unmasker = DistilBertForMaskedLM.from_pretrained(model_path, local_files_only=True)
    tokenizer = DistilBertTokenizer.from_pretrained(model_path, local_files_only=True)
    
    # predict masked output
    unmask = pipeline("fill-mask", model=unmasker, tokenizer=tokenizer)
    input_sentence = "Lend me your ears and I'll sing you a [MASK]"
    resp = unmask(input_sentence)
    for r in resp:
        print(f"{r['sequence']} ({r['score']})")
    

Running this code should give you an output similar to this:
    
    
    lend me your ears and i'll sing you a lullaby (0.29883989691734314)
    lend me your ears and i'll sing you a tune (0.10296259075403214)
    lend me your ears and i'll sing you a song (0.10061296075582504)
    lend me your ears and i'll sing you a hymn (0.09704853594303131)
    lend me your ears and i'll sing you a cappella (0.034581124782562256)
    

## Wrapping up

Your pre-trained model is now operational! From there you can easily reuse it, e.g. to process multiple text records stored in a Managed Folder or within a text column of a Dataset.

---

## [tutorials/machine-learning/code-env-resources/index]

# Pre-trained Models

  * [Tensorflow](<tf-resources/index.html>)

  * [PyTorch](<pytorch-resources/index.html>)

  * [Hugging Face](<hf-resources/index.html>)

  * [SentenceTransformers](<sentence-transformers-resources/index.html>)

  * [spaCy](<spacy-resources/index.html>)

  * [NLTK](<nltk-resources/index.html>)

---

## [tutorials/machine-learning/code-env-resources/nltk-resources/index]

# Load and re-use an NLTK tokenizer

Caution

Usage of the NLTK package is now deprecated in favor of other packages.  
A good replacement could be the transformers package as used in [Load and re-use a Hugging Face model](<../hf-resources/index.html>).

## Prerequisites

  * [Dataiku >= 10.0.0](<https://doc.dataiku.com/dss/latest/release_notes/10.0.html#code-env-resources>)

  * A Python>=3.7 [code environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html>) with the following package:

    * `nltk == 3.8.1`




## Introduction

[Natural Language Toolkit (NLTK)](<https://www.nltk.org/index.html>) is a Python package to execute a variety of operations on text data. It relies on several pre-trained artifacts like word embeddings or tokenizers that are not available out-of-the-box when you install the package: by default you have to manually download them in your code.

In this tutorial, you will use Dataiku’s [code environment resources](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html#managed-code-environment-resources-directory>) to create a code environment and add the [punkt](<https://www.nltk.org/api/nltk.tokenize.punkt.html>) sentence tokenizer to it.

## Loading the tokenizer

After creating your Python code environment with the required NLTK package (see the beginning of the tutorial), in the _Resources_ screen of your Code Environment, input the following **initialization script** then click on _Update_ :
    
    
    ## Base imports
    import os
    from dataiku.code_env_resources import clear_all_env_vars
    from dataiku.code_env_resources import set_env_path
    
    # Clears all environment variables defined by previously run script
    clear_all_env_vars()
    
    ## NLTK
    # Set NLTK data directory
    set_env_path("NLTK_DATA", "nltk_data")
    
    # Import NLTK
    import nltk
    
    # Download model: automatically managed by NLTK, does not download
    # anything if model is already in NLTK_DATA.
    nltk.download('punkt', download_dir=os.environ["NLTK_DATA"])
    

This script will download the `punkt` tokenizer and store it on the Dataiku instance. Note that the script will only need to run once. Once run successfully, all users allowed to use the code environment will be able to leverage the tokenizer without having to re-download it.

## Using the tokenizer in your code

You can now use your tokenizer in your Dataiku project’s Python recipe or notebook. Here is an example:
    
    
    import nltk
    
    text = '''
    Dataiku integrates with your existing infrastructure — on-premises or in the cloud. It takes advantage of 
    each technology’s native storage and computational layers. Additionally, Dataiku provides 
    a fully hosted SaaS option built for the modern cloud data stack. With fully 
    managed elastic AI powered by Spark and Kubernetes, you can achieve maximum performance 
    and efficiency on large workloads.
    '''
    
    sent_detector = nltk.data.load('tokenizers/punkt/english.pickle')
    print('\n-----\n'.join(sent_detector.tokenize(text.replace('\n', ' ').strip())))
    

Running this code should give you an output similar to this:
    
    
    Dataiku integrates with your existing infrastructure — on-premises or in the cloud.
    -----
    It takes advantage of  each technology’s native storage and computational layers.
    -----
    Additionally, Dataiku provides  a fully hosted SaaS option built for the modern cloud data stack.
    -----
    With fully  managed elastic AI powered by Spark and Kubernetes, you can achieve maximum performance  and efficiency on large workloads.
    

Using the same process, you can easily fetch and reuse any other kind of artifact required by NLTK for your text-processing tasks.

---

## [tutorials/machine-learning/code-env-resources/pytorch-resources/index]

# Load and re-use a PyTorch model

## Prerequisites

  * [Dataiku >= 10.0.0.](<https://doc.dataiku.com/dss/latest/release_notes/10.0.html#code-env-resources>)

  * Python >= 3.9

  * A [Code Environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html>) with the following packages:

    * `torch==2.0.1`

    * `torchvision==0.15.2`




## Introduction

Machine learning use cases can involve a lot of input data and compute-heavy thus expensive model training. You might not want to retrain a model from scratch for common tasks like processing images/ text or during your initial experiments. Instead, you can load _pre-trained models_ retrieved from remote repositories and use them for generating predictions.

In this tutorial, you will use Dataiku’s [Code Environment resources](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html#managed-code-environment-resources-directory>) feature to download and save a pre-trained image classification model from [PyTorch Hub](<https://pytorch.org/hub/>). You will then re-use that model to predict the class of a downloaded image.

## Loading the pre-trained model

The first step is to download the required assets for your pre-trained model. To do so, in the _Resources_ screen of your Code Environment, input the following **initialization script** then click on _Update_ :
    
    
    ## Base imports
    from dataiku.code_env_resources import clear_all_env_vars
    from dataiku.code_env_resources import set_env_path
    from dataiku.code_env_resources import set_env_var
    from dataiku.code_env_resources import grant_permissions
    
    # Import torchvision models
    import torchvision.models as models
    
    # Clears all environment variables defined by previously run script
    clear_all_env_vars()
    
    ## PyTorch
    # Set PyTorch cache directory
    set_env_path("TORCH_HOME", "pytorch")
    
    # Download pretrained model: automatically managed by PyTorch,
    # does not download anything if model is already in TORCH_HOME
    resnet18 = models.resnet18(weights=True)
    
    # Grant everyone read access to pretrained models in pytorch/ folder
    # (by default, PyTorch makes them only readable by the owner)
    grant_permissions("pytorch")
    

This script will retrieve a ResNet18 model from [PyTorch Hub](<https://pytorch.org/hub/pytorch_vision_resnet/>) and store it on the Dataiku Instance.

Note that it will only need to run once, after that all users allowed to use the Code Environment will be able to leverage the pre-trained model with re-downloading it again.

## Using the pre-trained model for inference

You can now re-use this pre-trained model in your Dataiku Project’s Python Recipe or notebook. Here is an example adapted from a tutorial on the PyTorch website that downloads a sample image and predicts its class from the ImageNet labels.
    
    
    import torch
    
    from torchvision import models, transforms
    from PIL import Image
    
    # Import pre-trained model from cache & set to evaluation mode
    model = models.resnet18(weights=True)
    model.eval()
    
    # Download example image from pytorch (it's a doggie, but what kind?)
    img_url = "https://github.com/pytorch/hub/raw/master/images/dog.jpg"
    img_file = "dog.jpg"
    torch.hub.download_url_to_file(img_url, img_file)
    
    # Pre-process image & create a mini-batch as expected by the model
    input_image = Image.open(img_file)
    preprocess = transforms.Compose([
            transforms.Resize(256),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
        ])
    input_tensor = preprocess(input_image)
    input_batch = input_tensor.unsqueeze(0) 
    
    # Run softmax to get probabilities since the output has unnormalized scores 
    with torch.no_grad():
        output = model(input_batch)
    probabilities = torch.nn.functional.softmax(output[0], dim=0)
    
    # Download ImageNet class labels
    classes_url = "https://raw.githubusercontent.com/pytorch/hub/master/imagenet_classes.txt"
    classes_file = "imagenet_classes.txt"
    torch.hub.download_url_to_file(classes_url, classes_file)
    
    # Map prediction to class labels and print top 5 predicted classes
    with open("imagenet_classes.txt", "r") as f:
        categories = [s.strip() for s in f.readlines()]
    top5_prob, top5_catid = torch.topk(probabilities, 5)
    for i in range(top5_prob.size(0)):
        print(categories[top5_catid[i]], top5_prob[i].item())
    

Running this code should give you an output similar to this:
    
    
    Samoyed 0.8846230506896973
    Arctic fox 0.0458049401640892
    white wolf 0.044276054948568344
    Pomeranian 0.00562133826315403
    Great Pyrenees 0.004651993978768587
    

## Wrapping up

Your pre-trained model is now operational! From there you can easily reuse it, e.g. to directly classify other images stored in a Managed Folder or to fine-tune it for a more specific task.

---

## [tutorials/machine-learning/code-env-resources/sentence-transformers-resources/index]

# Load and re-use a SentenceTransformers word embedding model

## Prerequisites

  * [Dataiku version >= 10.0.0.](<https://doc.dataiku.com/dss/latest/release_notes/10.0.html#code-env-resources>)

  * A Python>=3.9 [Code Environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html>) with the following package:

    * `sentence-transformers==2.2.2`




## Introduction

Natural Language Processing (NLP) use cases typically involve converting text to word embeddings. Training your word embeddings on large corpora of texts is costly. As a result, downloading _pre-trained word embeddings models_ and re-training them as needed is a popular option. [SentenceTransformers](<https://www.sbert.net/>) is a Python framework for state-of-the-art sentence, text and image embeddings. The framework is based on [Pytorch](<https://pytorch.org/>) and [Transformers](<https://huggingface.co/docs/transformers/index>) and offers a large collection of pre-trained models. In this tutorial, you will use Dataiku’s [Code Environment resources](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html#managed-code-environment-resources-directory>) feature to download and save pre-trained word embedding models from SentenceTransformers. You will then use one of those models to map a few sentences to embeddings.

## Downloading the pre-trained word embedding model

The first step is to download the required assets for your pre-trained models. To do so, in the _Resources_ screen of your Code Environment, input the following **initialization script** then click on _Update_ :
    
    
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
    
    # Optionally restrict the GPUs this code environment can use (it can use all by default)
    # set_env_var("CUDA_VISIBLE_DEVICES", "") # Hide all GPUs
    # set_env_var("CUDA_VISIBLE_DEVICES", "0") # Allow only cuda:0
    # set_env_var("CUDA_VISIBLE_DEVICES", "0,1") # Allow only cuda:0 & cuda:1
    
    ######################## Sentence Transformers #################################
    # Set sentence_transformers cache directory
    set_env_path("SENTENCE_TRANSFORMERS_HOME", "sentence_transformers")
    
    import sentence_transformers
    
    # Download pretrained models
    MODELS_REPO_AND_REVISION = [
        ("DataikuNLP/average_word_embeddings_glove.6B.300d", "52d892b217016f53b6c717839bf62c746a658933"), 
        # Add other models you wish to download and make available as shown below (removing the # to uncomment):
        # ("bert-base-uncased", "b96743c503420c0858ad23fca994e670844c6c05"),
    ]
    
    sentence_transformers_cache_dir = os.getenv("SENTENCE_TRANSFORMERS_HOME")
    for (model_repo, revision) in MODELS_REPO_AND_REVISION:
        logger.info("Loading pretrained SentenceTransformer model: {}".format(model_repo))
        model_path = os.path.join(sentence_transformers_cache_dir, model_repo.replace("/", "_"))
    
    
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
    

This script retrieves a pre-trained model from [SentenceTransformers](<https://www.sbert.net/>) and stores them in the Dataiku Instance. To download more of them, you’ll need to add them to the list and includes their `revision`, which is the model repository’s way of [versioning these models](<https://huggingface.co/docs/transformers/model_sharing#repository-features>).

Note that the script will only need to run once. After that, all users allowed to use the Code Environment will be able to leverage the pre-trained models without having to re-download them.

## Converting sentences to embeddings using your pre-trained model

You can now use those pre-trained models in your Dataiku Project’s Python Recipe or notebook. Here is an example using the word `average_word_embeddings_glove.6B.300d` model to map each sentence in a list to a 300-dimensional dense vector space.
    
    
    import os
    from sentence_transformers import SentenceTransformer
    
    # Load pre-trained model
    sentence_transformer_home = os.getenv('SENTENCE_TRANSFORMERS_HOME')
    model_path = os.path.join(sentence_transformer_home, 'DataikuNLP_average_word_embeddings_glove.6B.300d')
    model = SentenceTransformer(model_path)
    
    sentences = ["I really like Ice cream", "Brussels sprouts are okay too"]
    
    # get sentences embeddings
    embeddings = model.encode(sentences)
    embeddings.shape
    

Running this code should output a numpy array of shape (2,300) containing numerical values.

---

## [tutorials/machine-learning/code-env-resources/spacy-resources/index]

# Load and re-use a spaCy named-entity recognition model

## Prerequisites

  * [Dataiku >= 10.0.0](<https://doc.dataiku.com/dss/latest/release_notes/10.0.html#code-env-resources>)

  * A Python>=3.9 [Code Environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html>) with the following package:

    * `spacy==3.4.4`




## Introduction

[Named-entity recognition](<https://en.wikipedia.org/wiki/Named-entity_recognition>) (NER) is concerned with locating and classifying named entities mentioned in unstructured text into pre-defined categories such as person names, organizations, locations etc. The training of a NER model might be costly. Fortunately, you could rely on pre-trained models to perform that recognition task.

In this tutorial, you will use Dataiku’s [Code Environment resources](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html#managed-code-environment-resources-directory>) to create a code environment with a [spaCy](<https://spacy.io/>) pre-trained NER model.

## Loading the pre-trained NER model

After creating your Python code environment with the required spaCy package (see beginning of tutorial), you will download the required assets for your pre-trained model. To do so, in the _Resources_ screen of your Code Environment, input the following **initialization script** then click on _Update_ :
    
    
    ## Base imports
    from dataiku.code_env_resources import clear_all_env_vars
    
    # Clears all environment variables defined by previously run script
    clear_all_env_vars()
    
    ## SpaCy
    # Import SpaCy
    import spacy
    
    # Download model: automatically managed by spacy, installs the model
    # spacy pipeline as a Python package.
    spacy.cli.download("en_core_web_sm")
    

This script will download the spaCy English pipeline [en_core_web_sm](<https://spacy.io/models/en>) and store it on the Dataiku Instance. This pipeline contains the pre-trained NER model, among other NLP tools.

Note that the script will only need to run once. After that all users allowed to use the Code Environment will be able to leverage the NER model without having to re-download it.

## Performing NER using your pre-trained model

You can now use your pre-trained model in your Dataiku Project’s Python Recipe or notebook to perform NER on some text. Here is an example:
    
    
    import spacy
    
    nlp = spacy.load('en_core_web_sm')
    text = nlp(""""
    A call for American independence from Britain,
    the Virginia Declaration of Rights was drafted
    by George Mason in May 1776""")
    
    for word in text.ents:
        print(f"{word.text} --> {word.label_}")
    

Running this code should give you an output similar to this:
    
    
    American --> NORP
    Britain --> GPE
    the Virginia Declaration of Rights --> ORG
    George Mason --> PERSON
    May 1776 --> DATE

---

## [tutorials/machine-learning/code-env-resources/tf-resources/index]

# Load and re-use a TensorFlow Hub model

## Prerequisites

  * [Dataiku >= 10.0.0.](<https://doc.dataiku.com/dss/latest/release_notes/10.0.html#code-env-resources>)

  * A [Code Environment](<https://doc.dataiku.com/dss/latest/code-envs/index.html>) with the following packages:

    * `tensorflow==2.8.0`

    * `tensorflow-estimator==2.6.0`

    * `tensorflow-hub==0.12.0`

    * `protobuf>=3.20,<3.21`

    * `requests==2.28.1`

    * `Pillow==9.3.0`




## Introduction

Machine learning use cases can involve a lot of input data and compute-heavy thus expensive model training. Instead, you might want to reuse artifacts for common tasks like pre-processing images or text for model training. You can load _pre-trained models_ from remote repositories and embed them in your code.

In this tutorial, you will use Dataiku’s [Code Environment resources](<https://doc.dataiku.com/dss/latest/code-envs/operations-python.html#managed-code-environment-resources-directory>) feature to download and save a pre-trained image classification model from the [TensorFlow Hub](<https://www.tensorflow.org/hub>). You will then reuse it to classify a picture downloaded from the Internet.

## Loading the pre-trained model

The first step is to download the required assets for your pre-trained model. To do so, in the _Resources_ screen of your Code Environment, input the following **initialization script** then click on _Update_ :
    
    
    ## Base imports
    from dataiku.code_env_resources import clear_all_env_vars
    from dataiku.code_env_resources import set_env_path
    from dataiku.code_env_resources import set_env_var
    
    # Clears all environment variables defined by previously run script
    clear_all_env_vars()
    
    ## TensorFlow
    # Set TensorFlow cache directory
    set_env_path("TFHUB_CACHE_DIR", "tensorflow")
    
    # Import TensorFlow Hub
    import tensorflow_hub as hub
    
    # Download pretrained model: automatically managed by Tensorflow,
    # does not download anything if model is already in TFHUB_CACHE_DIR
    model_hub_url = "https://tfhub.dev/google/tf2-preview/mobilenet_v2/classification/4"
    hub.KerasLayer(model_hub_url)
    

This script will retrieve a MobileNet v2 model from [Tensorflow Hub](<https://tfhub.dev/google/tf2-preview/mobilenet_v2/feature_vector/4>) and store it on the Dataiku Instance.

Note that it will only need to run once, after that all users allowed to use the Code Environment will be able to leverage the pre-trained model with re-downloading it again.

## Using the pre-trained model for inference

You can now re-use this pre-trained model in your Dataiku Project’s Python Recipe or notebook. Here is an example adapted from a [tutorial on the Tensorflow website](<https://www.tensorflow.org/tutorials/images/transfer_learning_with_hub>) that downloads a sample image and predicts its class from the ImageNet labels.
    
    
    import tensorflow as tf
    import tensorflow_hub as hub
    import numpy as np
    
    from PIL import Image
    
    model_name = "https://tfhub.dev/google/tf2-preview/mobilenet_v2/classification/4"
    
    # Load the pre-trained model
    img_shape = (224, 224)
    classifier = tf.keras.Sequential([
        hub.KerasLayer(model_name, input_shape=img_shape+(3,))
    ])
    
    # Download image and compute prediction
    img_url = "https://upload.wikimedia.org/wikipedia/commons/b/b0/Bengal_tiger_%28Panthera_tigris_tigris%29_female_3_crop.jpg"
    img = tf.keras.utils.get_file('image.jpg', img_url)
    img = Image.open(img).resize(IMAGE_SHAPE)
    img = np.array(img)/255.0
    result = classifier.predict(img[np.newaxis, ...])
    
    # Map the prediction result to the corresponding class label
    labels_url = "https://storage.googleapis.com/download.tensorflow.org/data/ImageNetLabels.txt"
    predicted_class = tf.math.argmax(result[0], axis=-1)
    labels_path = tf.keras.utils.get_file('ImageNetLabels.txt', labels_url)
    imagenet_labels = np.array(open(labels_path).read().splitlines())
    predicted_class_name = imagenet_labels[predicted_class]
    
    print(f"Predicted class name: {predicted_class_name}")
    

Running this code should give you the following output:
    
    
    Predicted class name: tiger
    

## Wrapping up

Your pre-trained model is now operational! From there you can easily reuse it, e.g. to directly classify other images stored in a Managed Folder or to fine-tune it for a more specific task.

---

## [tutorials/machine-learning/experiment-tracking/catboost/index]

# Experiment tracking with Catboost

In this tutorial you will train a model using the [Catboost](<https://catboost.ai/>) framework and use the experiment tracking abilities of Dataiku to log training runs (parameters, performance).

## Prerequisites

  * Access to a Project with a Dataset that contains the [UCI Bank Marketing data](<https://archive.ics.uci.edu/static/public/222/bank+marketing.zip>)

  * A Code Environment containing the `mlflow` and `catboost` packages




## Performing the experiment

The following code snippet provides a reusable example to train a simple gradient boosting model, with these main steps:

**(1)** : Select the features and target variables.

**(2)** : Define the hyperparameters to run the training on. Set the number of boosting rounds to 100, and to check whether overfitting is occuring during cross-validation, set `early_stopping_rounds` to 5. To cap boosting rounds, limit the training to the iteration that has the best score by setting `use_best_model` to `True`.

**(3)** : Perform the experiment run, log the hyperparameters, performance metrics (here we use the AUC) and the trained model.
    
    
    import dataiku
    from catboost import CatBoostClassifier, Pool, cv
    
    # !! - Replace these values by your own - !!
    USER_PROJECT_KEY = ""
    USER_XPTRACKING_FOLDER_ID = ""
    USER_EXPERIMENT_NAME = ""
    USER_TRAINING_DATASET = ""
    USER_MLFLOW_CODE_ENV_NAME = ""
    
    client = dataiku.api_client()
    project = client.get_project(USER_PROJECT_KEY)
    
    # (1)
    ds = dataiku.Dataset(USER_TRAINING_DATASET)
    df = ds.get_dataframe()
    
    cat_features= ["job", "marital", "education", "default",
        "housing","loan", "month", "contact", "poutcome"]
    
    target ="y"
    
    X = df.drop(target, axis=1)
    y = df[target]
    
    # (2)
    params = {
        'iterations': 100,
        'learning_rate': 0.1, 
        'depth': 10,
        'cat_features': cat_features,
        'loss_function': 'Logloss',
        'eval_metric': 'AUC',
        'early_stopping_rounds': 5,
        'use_best_model': True,
        'random_seed': 42,
    }
    
    # (3)
    mf = project.get_managed_folder(USER_XPTRACKING_FOLDER_ID)
    mlflow_extension = project.get_mlflow_extension()
    
    with project.setup_mlflow(mf) as mlflow:
        mlflow.set_experiment(experiment_name=USER_EXPERIMENT_NAME)
        with mlflow.start_run() as run:
            run_id = run.info.run_id
            
            cv_dataset = Pool(
                data=X, label=y, cat_features= cat_features)
    
            scores = cv(cv_dataset,
                        params,
                        fold_count=5,
                        seed=42,
                        plot= False)
            
            for x in range(len(scores.index)):
                mlflow.log_metric(key='mean_AUC', value=scores['test-AUC-mean'][x], step=x)
                mlflow.log_metric(key='sd_AUC', value=scores['test-AUC-std'][x], step=x)
    
            mlflow.log_params(params=params)
            
            if params['early_stopping_rounds']:
                mlflow.log_metric(key='best_iteration', value=len(scores.index))
            
            if params['use_best_model']:
                params['iterations'] = len(scores.index)
                params['use_best_model'] = False
    
            model = CatBoostClassifier(**params)
            cb_model = model.fit(X,y)
            
            mlflow.catboost.log_model(cb_model, artifact_path="model")
        
            mlflow_extension.set_run_inference_info(run_id=run_id,
                prediction_type="BINARY_CLASSIFICATION",
                classes=['no', 'yes'],
                code_env_name=USER_MLFLOW_CODE_ENV_NAME,
                target=target)
    

After these steps you should have your Experiment Run’s data available both in the [Dataiku UI](<https://doc.dataiku.com/dss/latest/mlops/experiment-tracking/viewing.html>) and programmatically via the [`DSSMLflowExtension`](<https://developer.dataiku.com/latest/api-reference/python/experiment-tracking.html#dataikuapi.dss.mlflow.DSSMLflowExtension>) object of the Python API client.

---

## [tutorials/machine-learning/experiment-tracking/index]

# Experiment Tracking

  * [With XGBoost and custom pre-processing](<xgboost-pyfunc/index.html>)

  * [With Keras/Tensorflow for sentiment analysis](<keras-nlp/index.html>)

  * [With Catboost](<catboost/index.html>)

  * [With LightGBM](<lightgbm/index.html>)

  * [With scikit-learn](<scikit-learn/index.html>)