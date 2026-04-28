# Dataiku Docs — automation-scenarios

## [scenarios/copy-steps]

# How to Copy Scenario Steps

Existing steps in a scenario can be reused in another scenario so that you don’t have to manually replicate the steps. You can also [duplicate an existing scenario](<duplicate-scenarios.html>) to use in a project.

## Copying Steps

From within the scenario that contains the steps you want to copy:

  * Right-click on the step you want to copy and select **Copy step**.

  * Navigate to the scenario where you want to paste the step

  * Select the step that marks where the copied step should be pasted

  * Right-click on that step and select **Paste after this step**

---

## [scenarios/custom_scenarios]

# Custom scenarios

Instead of being simply step-based, custom scenarios are a full-fledged Python program which may execute everything that DSS scenarios can, while providing the user with full configurability and advanced logic capabilities.

## What can a custom scenario do

A custom scenario can:

  * Execute all steps that can be defined in a “step-based scenario”. For more information, see [Scenario steps](<steps.html>).

  * Read metadata about the executed steps, like:

>     * Failure / Success
> 
>     * Count and types of warnings
> 
>     * Detailed list of built datasets, trained models, …

  * Read details about trained models (performance metrics, …)

  * Read detailed parameters of the trigger that initiated this scenario.

  * Activate new versions of trained models

  * Read metrics and checks status for datasets

  * Read the build state: when was a dataset last built, a model last trained, …

  * Send custom messages through the reporters at any point of the scenario (not only at the beginning or end)




In addition, a custom scenario can use the whole internal and public Python API.

The details of the scenarios API can be found in [Scenarios](<https://developer.dataiku.com/latest/api-reference/python/scenarios.html> "\(in Developer Guide\)").

Note

The scenario API cannot be used in a Python recipe/Jupyter notebook.

## Examples

### Basic usage

This custom scenario builds datasets and trains models. Note that a step-based scenario suffices for this usage.
    
    
    from dataiku.scenario import Scenario
    
    # Create the main handle to interact with the scenario
    scenario = Scenario()
    
    # Build a dataset
    scenario.build_dataset("mydatasetname")
    
    # Build a partitioned data (this uses the partitions spec syntax)
    scenario.build_dataset("mydatasetname", partitions="partition1,partition2")
    
    # Train a model. The model id can be found in the URL of the model settings page
    scenario.train_model("epae130z")
    

### Send custom reports

Reports can be sent at any time of the scenario. You’ll need to have a preconfigured messaging channel.
    
    
    from dataiku.scenario import Scenario
    scenario = Scenario()
    
    message_sender = scenario.get_message_sender("channel-name")
    
    # You can then call send() with message params.
    # params are specific to each message channel types
    
    # SMTP mail example
    message_sender.send(sender="", recipient="", subject="", message="")
    
    # You can also call set_params to set params on the sender that will be reused for all subsequent 'send' calls
    message_sender.set_params(sender="[[email protected]](</cdn-cgi/l/email-protection>)", recipent="[[email protected]](</cdn-cgi/l/email-protection>)")
    message_sender.send(subject="All is well", message="Scenario is working as expected")
    
    # Twilio SMS alert example
    message_sender.send(fromNumber="", toNumber="", message="")
    

You can also send message to Microsoft Teams. Here is an example where `my-teams-channel` is a preconfigured messaging channel:
    
    
    from dataiku.scenario import Scenario
    scenario = Scenario()
    
    message_sender = scenario.get_message_sender("my-teams-channel")
    message_sender.send(message="Scenario is working as expected")
    

Here is another example that uses an ad-hoc channel:
    
    
    from dataiku.scenario import Scenario
    scenario = Scenario()
    
    message_sender = scenario.get_message_sender(None, "msft-teams-scenario")
    message_sender.send(message="Scenario is working as expected", webhookUrl="Webhook URL of the Teams channel")
    

If you want to send an email message in HTML format, you can pass the parameter `sendAsHTML=True` in your send function. Here is an example where `my-email-channel` is a preconfigured messaging channel:
    
    
    from dataiku.scenario import Scenario
    scenario = Scenario()
    
    message_sender = scenario.get_message_sender("my-email-channel")
    # some HTML-formatted text
    html_message = "<p style='color:orange'>Your scenario is running!</p><p>While waiting, check out this <a href='https://www.dataiku.com'>awesome website</a></p>"
    message_sender.send(subject="The scenario is doing well", message=html_message, sendAsHTML=True)

---

## [scenarios/definitions]

# Definitions

A **scenario** in DSS is a set of actions to do, with condition(s) to run it. DSS automatically executes scenarios whose conditions are satisfied.

## Types of scenarios

There are 2 types of scenarios, which differ in the way the sequence of actions they take is defined:

  * **step-based** scenarios are made of a fixed list of steps, parametrized by the user. The steps are all run, and always in the same order. Some level of flow control is possible (see [Step-based execution control](<step_flow_control.html>)).

  * **custom python** scenarios consist in a python script, which is run in an environment allowing it to launch scenario steps on the DSS backend.




**Custom python** scenarios offer more flexibility when it comes to deciding whether a given step needs to be run or not. For example, a step to re-train a model could be conditioned on the last known performance of that model.

## Triggers

A **trigger** is a condition attached to a scenario. A scenario can have one or more triggers attached to it. The triggers are evaluated periodically, and when a trigger condition is met, it launches the scenario.

## Reporters

Since scenarios run in the background, there is a need for knowing whether a given run is finished or not, and whether failures were recorded. This information can be read by the user when he inspects the scenario’s last runs or when he uses the monitoring plots, and can also be published on a variety of channels by **reporters**.

One or more reporters can be set up on a scenario to prepare messages and send them on **messaging channels**. These channels are configured by the DSS instance’s administrator in the **Administration** section.

## Test in DSS

This option is used to record future scenario runs as “test runs” and makes them available in the [Test Dashboard](<test_scenarios.html>).

---

## [scenarios/duplicate-scenarios]

# How to Duplicate Scenario

You can duplicate an existing scenario without having to [copy scenario steps](<copy-steps.html>) one at a time.

## Steps for Duplicating a Scenario

  * From the **Jobs** dropdown in the top navigation bar, select **Scenarios**.

  * Click on the scenario you want to duplicate

  * From the **Actions** menu, choose **Duplicate**. A window opens up, allowing you to “Duplicate this scenario”

  * Within the window, you can choose to provide a new name and id for the duplicate scenario

  * Click **Duplicate**

---

## [scenarios/index]

# Automation scenarios

Building a dataset or training a model can be done in various ways at the request of the user, for example by selecting the dataset in the flow view and using the **Build** action, but also in an automated fashion using scenarios.

---

## [scenarios/reporters]

# Reporting on scenario runs

Dataiku DSS provides the means to add reporters in a scenario. These reporters can be used to inform teams of users about scenario activities. For example, scenario reporters can update users about the training of models or changes in data quality. Reporters can also create actionable messages that users can receive within their email or through other messaging channels.

Note

See our tutorial on [reporting scenario activities](<https://knowledge.dataiku.com/latest/automate-tasks/scenarios/tutorial-reporters.html>) to learn how to send scenario updates to messaging channels.

## Executing scenario reporters

You can instruct a reporter to send messages at any point of a scenario run:

  * To send a message right before a scenario run starts, add a reporter to the scenario in the **Settings** pane, and set the value of “Send on scenario” to **Start**.

  * To send a message during the scenario run, add a **Send message** step (in a step-based scenario) or use `get_message_sender()` on the `Scenario` object (in a script scenario).

  * To send a message right after a scenario run ends, add a reporter to the scenario in the **Settings** pane, and set “Send on scenario” to **End**. You can further control whether the reporter runs at the end of the scenario, by specifying the “Run condition” as one of the expressions: `outcome == 'SUCCESS'` or `outcome == 'FAILED'` or `outcome == 'ABORTED'`. You can set up several reporters, each having a run condition and a corresponding message.




## Building the message contents

Each reporter must define a message to broadcast on the selected messaging channel, and/or define some channel variables to pass to the reporter itself.

Reporting to mail provides the most versatility when building messages.

### Mail reporter

Before you can send emails, an administrator needs to set up a mail channel (e.g. SMTP) in Administration > Settings > Notifications & Integrations. Additional configuration outside of DSS may be necessary in some cases (cf. end of this section).

Dataiku DSS sends messages by mail in either HTML or plain text format, and two engines are available to build the messages:

  * [Freemarker](<http://freemarker.org/>)-based templating

  * Variable-based formatting, using [DSS formulas](<https://knowledge.dataiku.com/latest/prepare-transform-data/prepare/formulas/concept-formula-master.html>)




In both cases, the results of the scenario run are offered to the engines as named variables.

DSS comes with a default Freemarker-based template, and changing the “Message source” to **Inline** gives you the possibility to write your own message.

The “Recipients” field of the mail reporter can take a list of recipients in any of the following syntaxes:

  * regular: `john.doe@here.com, jane.smith@there.org`

  * JSON-array style: `["john.doe@here.com", "jane.smith@there.org"]`




To send one individualized mail to each recipient, the syntax for the “Recipients” field is :
    
    
    {
       "mails": [
          {
             "to": "[[email protected]](</cdn-cgi/l/email-protection>)",
             "variables": {
                "variable1": "Sir",
                "variable2": "some special message for john"
             }
          },
          {
             "to": "[[email protected]](</cdn-cgi/l/email-protection>)",
             "variables": {
                "variable1": "Madam"
             }
          }
       ]
    }
    

The `variables` object for each recipient is then available for replacement in the mail message as a JSON string `mailVariables`, and its fields as `mailVariables_variableName`. For example, you can type:
    
    
    Dear ${mailVariables_variable1},
    
    ${if(parseJson(mailVariables).hasField("variable2"), parseJson(mailVariables).get("variable2"), "message for not-john")}
    
    Yours truly,
        A humble documentation
    

#### Microsoft 365 integration setup

DSS can send emails via Microsoft 365 using OAuth2. To do this, you have to first create and configure a new application in Azure with the right permissions:

  1. Sign in to your Azure portal and navigate to the AAD resource. Click **App registrations** and provide a name for your application (there is no need for a redirect URI). After you register your application, make a note of **Application (client) ID** and **Directory (tenant) ID**.

  2. Click **Certificates & secrets** and create a new secret for your application. Make a note of **Value** (you won’t be able to view it anymore after you refresh this page).

  3. Click **API permissions** and add permission **Mail.Send** under **Microsoft Graph** then **Application permissions** (it must be of type Application, not Delegated). Ask your Azure admin to **Grant admin consent** as well. By default, this would allow the application to send emails as any user of the Azure directory (tenant) with a valid Microsoft 365 license: the Azure admin could [restrict it to specific users](<https://learn.microsoft.com/en-us/graph/auth-limit-mailbox-access>).




Then, add a new channel in DSS, in Administration > Settings > Notifications & Integrations:

  1. Add a new **Mail (via Microsoft 365 with OAuth)** channel.

  2. Fill in **Application (client) ID** , **Directory (tenant) ID** , and **Client secret** with what you noted down earlier.

  3. Fill in **Sender email address** with the email address (AAD User Principal Name) of a user of the Azure directory (tenant) with a valid Microsoft 365 license.




### Slack, Microsoft Teams, Google Chat, Webhook and Twilio reporters

These reporters only offer variable-based formatting using DSS formulas for the message body. These reporters also take additional parameters, like message color or sender alias, that can be computed using DSS formulas. Note that Slack uses a specific [format](<https://api.slack.com/docs/message-formatting>) for its messages, and leaves html as-is.

#### Slack integration setup

Slack provides 2 methods to automatically send messages on a channel, and both are available in DSS:

  * Through an [incoming webhook](<https://api.slack.com/incoming-webhooks>)

  * Through a [bot user](<https://api.slack.com/bot-users>)




To use an incoming webhook in a DSS integration, specify “Mode” as **Use incoming webhook** and provide a value for the “Webhook URL”. In Slack, you can find the webhook URL by navigating to _Apps & Integrations_ -> _Manage_ -> _Custom integrations_ -> _Incoming webhooks_. To create an incoming webhook in your Slack channel, go to _Apps & Integrations_ -> _Build_ (top right corner) -> _Make a Custom integration_ , and from there you can create a new _Incoming webhook_.

A bot user has the advantage (over a simple incoming webhook) that the bot can have a preset appearance in the Slack channel. Using a bot user in a DSS integration means selecting the API mode and specifying the bot’s API token as authentication token. The API token can be found by navigating to _Apps & Integrations_ -> _Build_ -> _Make a Custom integration_ -> _Bots_.

Alternatively, you can use a [testing token](<https://api.slack.com/docs/oauth-test-tokens>) instead of a bot user, since they both rely on the same API token mechanism. Once they are created, you can access the token for your bot or incoming webhook by going to _Apps & Integrations_ -> _Manage_ (top right corner) -> _Custom integrations_.

#### Microsoft Teams integration setup

Integration with Microsoft Teams from DSS requires that you set up and configure a workflow based on the template “Post to a channel when a webhook request is received”. Once configured, the integration with DSS supports simple text messages, as well as more complex and rich [Adaptive Cards](<https://adaptivecards.io/>) created via JSON.

Here is an example of a card with displays a message with a title and a color depending on the outcome of the scenario:
    
    
    {
       "attachments":[
          {
             "contentType":"application/json",
             "content":{
                "$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
                "type":"AdaptiveCard",
                "version":"1.0",
                "body":[
                   {
                      "type":"Container",
                      "items":[
                         {
                            "type":"TextBlock",
                            "text":"${scenarioName} run report",
                            "weight":"bolder",
                            "size":"medium",
                            "style":"heading",
                            "wrap":true,
                            "color":"${if(outcome == 'FAILED', 'attention', 'default')}"
                         },
                         {
                            "type":"TextBlock",
                            "wrap":true,
                            "text":"[${scenarioName}](${scenarioRunURL}): **${outcome}**"
                         },
                         {
                            "type":"FactSet",
                            "facts":[
                               {
                                  "title":"Project",
                                  "value":"${scenarioProjectKey}"
                               },
                               {
                                  "title":"Triggered by",
                                  "value":"${triggerName}"
                               }
                            ]
                         }
                      ]
                   }
                ]
             }
          }
       ]
    }
    

A key advantage of this integration is the ability to utilize the power of working on data projects in DSS while harnessing the ease of communication and collaboration that Microsoft Teams provides to users.

Note that you can also send messages to Teams in custom scenarios. See [Custom scenarios](<custom_scenarios.html>) for some examples.

#### Google Chat integration setup

To send messages to Google Chat from DSS:

  * In Google Chat: [Create a webhook on the channel](<https://developers.google.com/workspace/chat/quickstart/webhooks#create-webhook>) and copy its link.

  * In DSS: Paste the link in the Webhook URL field. If you want the key or token part of the URL to be encrypted, extract them from the URL and paste them in the Webhook Key/Token fields.




In addition to using an in-place webhook URL for each reporter, you can use a Google Chat messaging channel defined at the DSS instance level. To configure such a channel, go to Administration > Settings > Notifications & Integrations.

You can [format messages](<https://developers.google.com/workspace/chat/format-messages>) sent to Google Chat but cards are not supported.

### Shell reporter

DSS sends results of the scenario run to the shell script. You can use DSS formulas in the Administration section to specify values for environment variables that define the shell script.

### Scenario run URL

In order to use the reporter variable `${scenarioRunURL}`, an administrator must configure the “DSS URL” under Administration > Settings > Notifications & Integrations > DSS Location > DSS URL.

## Common variables

You can use variables from the DSS instance, project, and scenario run, in the message. Two mechanisms are also available to help with customizing the message:

  * Define new variables with a custom Python script.

  * Handle variables in the message as DSS formulas.

---

## [scenarios/step_flow_control]

# Step-based execution control

The default behavior in step-based scenarios is to run all steps in order, until one fails or until all the steps are done.

## On failure, proceed with scenario

Some steps, among which the _Build/train_ one, can treat errors as mere warnings. This means that if some error occurs during the execution of the step, which should normally stop the execution of the whole scenario, the error is downgraded to a warning and subsequent steps in the scenario are run.

An example is the _Kill another scenario_ step: if a scenario A has a _Kill another scenario_ step where it attempts to abort another scenario B, the run of scenario A will fail if scenario B has not started or has already finished running. It may then be useful to activate the _Ignore failure_ on the _Kill another scenario_ step so that scenario A can always run subsequent steps.

## Run step conditionally

The behavior of step-based scenarios to stop at the first failing step can be overridden by using the _Run this step_ options of each step.

### Never

To disable a step, but keep it around, one should use the Never option

### Always

The step is always run, regardless of whether previous steps failed or not. This is equivalent to a finally block. For example a step that frees computational resources taken before in the scenario need to run regardless of the state of the previous step, so that resources are properly freed.

### If no prior step failed

This is the default behavior of steps.

### If some prior step failed

This mode lets the user run steps only in case of a failure in the preceding steps, like a catch clause. For example to deactivate a report or send a message if a build did not succeed.

### If current outcome is

This mode is a more generic version of the above modes.

### If condition satisfied

This mode is the most generic of all, and lets the user decide to run a step based on the current outcome of the scenario or on the value of variables set before in the scenario or in the project.

The expression is a [formula](<../formula/index.html>). The variables available in the formula are:

  * outcome : the current outcome of the scenario; possible values are ‘SUCCESS’, ‘WARNING’, ‘FAILED’, ‘ABORTED’

  * stepOutcome_stepName : the outcome of the step named ‘stepName’, if the step defined one

  * stepResult_stepName : the result of the step named ‘stepName’, if the step defined one

  * stepOutput_stepName : the output of the step named ‘stepName’, if the step defined one

  * project-level variables, scenario-level variables

  * scenarioTriggerParams : the parameters of the trigger that initiated the scenario run, if the trigger defined some. If not empty, the fields of scenarioTriggerParams are also accessible as scenarioTriggerParam_fieldName

---

## [scenarios/steps]

# Scenario steps

The following steps can be executed by a scenario.

## Build / Train

This step builds elements from the Dataiku Flow:

  * Datasets (or dataset partitions in the case of partitioned datasets)

  * Managed folders

  * Saved models




## Clear

This step clears the contents of elements from the Dataiku Flow:

  * Datasets (or dataset partitions in the case of partitioned datasets) : the corresponding data is deleted

  * Managed folders (or folder partitions in the case of partitioned folders) : all the contents of the folder (or the folder partitions) are deleted




## Verify rules or run checks

This step computes the checks or data quality rules defined on elements from the Dataiku Flow:

  * Datasets (or dataset partitions in the case of partitioned datasets)

  * Managed folders

  * Saved models

  * Model evaluation stores




For Datasets, this step computes the Data Quality rules specified in the _Data Quality_ tab of the Dataset. This includes computing the underlying metrics that may be required by the rules. Optionally, you can prevent the computation of rules that are automatically run on build. Since those rule results are likely to be up to date with the data in most use cases, it may allow you to avoid some redundant computation.

For other objects, the step runs the checks defined on the _Status_ tab of the element.

The outcomes of the checks and rules are collected and the step fails if at least one check on the selected elements fails.

The outcomes of the checks and rules (OK, ERROR, WARNING), along with the optional message, are available to subsequent steps as variables (See [Variables in scenarios](<variables.html>)).

## Compute metrics

This step runs the probes defined on elements from the Dataiku Flow:

  * Datasets (or dataset partitions in the case of partitioned datasets)

  * Managed folders




The probes are those defined on the _Status_ tab of the element.

The values of the metrics are available to subsequent steps as variables (See [Variables in scenarios](<variables.html>)).

## Synchronize Hive table

HDFS datasets can be associated by DSS to external Hive tables. This is done automatically by jobs launched in DSS, or from the dataset’s advanced settings pane, and can be scheduled in a scenario using a _Sync Hive table_ step. The schema of the Hive table is regenerated by the step so that it matches the schema of the dataset.

## Create notebook export

Python notebooks can be made into [insights](<../dashboards/insights/index.html>) by publishing them. The insight is then disconnected from the notebook. The _Create notebook export_ step re-publishes a python notebook to the insight it was published to before, and optionally runs the notebook prior to publishing it.

When checking _Execute the notebook_ in this step, one can thus refresh the data used by the published insight.

## Execute SQL

This step executes one or more SQL statements on a DSS connection. Both straight SQL connections (ex: a Postgresql connection) and HiveQL connections (Hive and Impala) can be used.

The output of the query, if there is one, is available to subsequent steps as variables (See [Variables in scenarios](<variables.html>)).

## Execute Python code

This step runs a chunk of Python code in the context of the scenario. The Dataiku API available in Python notebooks is available in this step, as well as the scenario-specific API.

To get the parameters of the trigger that started the scenario, for example, one can use:
    
    
    import dataiku.scenario
    s = dataiku.scenario.Scenario()
    params = s.get_trigger_params()
    

## Define variables, Set project variables, Set global variables

In DSS, there are instance-level variables, project-level variables, and scenario-level variables. The scenario-level variables are only visible for the duration of the scenario run, and are defined either programmatically (in Python) or using a _Define variables_ step. All 3 types of variables are available to recipes of jobs started in a scenario run.

The variables can be specified either by inputting a JSON object, in which case the variables values are fixed, or by inputting a list of key-value pairs, where the values are DSS formulas and can depend on pre-existing variables.

See [Variables in scenarios](<variables.html>) for more information.

## Run global variables update

This step runs the update of the DSS instance’s [variables](<variables.html>) as defined in the administration section, or a given update code if specified in the step.

## Send message

This step sends a message, like the [reporters](<reporters.html>) do at the end of a scenario run. The setup is the same, the only difference being that since the scenario is (obviously) not finished when the step is run, not all variables created during the run are available.

## Run another scenario

This step starts a run of a scenario and waits for its completion. The step’s outcome is the outcome of that scenario run.

Only scenarios of projects the user has access to can be used. The user under which this step is run is used for the scenario started by this step, regardless of that scenario’s _Run as user_ setting.

## Package API service

This step generates a package of the specified API service. The package identifier needs to be unique. It can be specified using an expression with variables, and can be automatically padded with a number to ensure unicity.

## Create dashboard export

This step generates a dashboard export inside a managed folder. Dashboard must be specified or the step will fail. If you don’t specify the Managed folder, files generated will be stored in temporary folder dashboard-exports inside DSS data directory.

Files generated are fully customizable so users are fully in control over what they obtain. There are several parameters that will enable it :

  * file type determine file extension type.

  * export format determine file dimensions. If a standard format (A4 or US Letter) is chosen, file dimensions will be calculated based on your screen and file will be what you see. On the contrary, Custom format allow to set custom width and offer two means of calculating file’s height :

>     * Grid cells correspond to cells displayed in dashboard’s edit mode, height will be calculated in pixels based on width, number of grid cells and their height.
> 
>     * Pixels correspond to a height in pixels (obviously).




## Execute Python unit test

This step executes one or more Python pytest tests from a project’s Libraries folder using a [Pytest selector](<https://docs.pytest.org/en/stable/>).

## Run integration test

This step is used to run non-regression tests of your Dataiku project flow. It does this by:

  * Swapping one or more datasets in the flow with reference input datasets, that are stable and known.

  * Rebuilding one or more items to generate a new set output datasets.

  * Comparing the new output with reference datasets.




## WebApp test

This step verifies that a web application is running and reachable, and can perform request/response testing.

The “up and reachable” check is always performed. It is also possible to configure the step to start the web application before running the check, in which case the webapp is automatically stopped at the end of the step.

For request/response testing, the step can be configured to perform the following actions:

  * Send `GET` and `POST` requests to a specific path with configurable query parameters. For `POST` requests, a request body (payload) and its MIME type can also be defined.

  * Optionally validate the MIME type of the response.

  * Optionally validate the contents of the response body.

  * Optionally perform JSONPath analysis on the response body.

  * Send requests authenticated as a specific DSS user or as an unauthenticated (anonymous) user.

  * Use variable expansion in both the request and response bodies.

---

## [scenarios/test_scenarios]

# Testing a project

To ensure the quality of your project over time, you can test parts of a Dataiku project using dedicated scenario steps ([Python unit test](<steps.html#python-test-step>), [Integration test](<steps.html#flow-test-step>) and [Webapp test](<steps.html#webapp-test-step>)).

## Creating a test scenario

Scenarios have an option to be marked as a [test scenario](<definitions.html#def-test-in-dss>), which will make them appear in your project’s Test Dashboard.

The Test Dashboard displays the status of all the latest test scenario runs.

## Test Dashboard

The Test Dashboard is available from the project’s Automation Monitoring tab:

  * It displays the latest run of test scenarios of the current project (design node) or selected bundle (automation node).

  * Each run shows its status, execution date, duration, and quick access to scenario settings, last run view, logs, and scenario/step reports (for pytest steps).

  * A summary of run statuses is available.

  * Users can manually download a JunitXML report or an HTML report of the Test Dashboard.




## Best practices for testing

This feature is a component that can be used in a wide range of cases, and is dependent on your need, time and requirements. Nonetheless, we can give some generic suggestions:

  1. Test scenarios are created on a Design node and can be tested there.

  2. You are not limited to dedicated Test steps in these scenarios; they can also use any other scenario step that is relevant in your test execution.

  3. Once ready, tests are meant to be executed on a dedicated QA Automation node. This execution can be done manually or automatically (using [Deployer custom Hooks](<../deployment/project-deployment-infrastructures.html#deployment-hooks>), for example).

  4. The test report on this QA Automation node can be exported for archiving, but can also be viewed directly on the Automation node and retrieved through the Python API.

  5. You can leverage the Test report as part of your deployment process. This can be done through a Custom Hook on your Production infrastructure. You can also push the test report to Dataiku Govern and have it as a resource for [sign-off](<../governance/types-govern-items.html#sign-off>).




Note

If you are interested in building a complete testing pipeline within Dataiku, you can read [our hands-on article in our Knowledge Base](<https://knowledge.dataiku.com/latest/automate-tasks/scenarios/tutorial-test-scenarios.html>).

---

## [scenarios/triggers]

# Launching a scenario

Scenarios can be started manually, or using the DSS Public API.

**Triggers** are used to automatically start a scenario, based on several conditions.

Each trigger can be enabled or disabled. In addition, the scenario must be marked as “active” for triggers to be evaluated.

## Types of triggers

In order to cover most usage cases, several types of triggers exist.

Note

If a scenarios contains multiple active triggers, the trigger conditions are evaluated independently. This means that the scenario will be triggered when **any** trigger condition is true.

### Time-based triggers

These triggers launch scenarios at regular intervals. The periodicity can be monthly, weekly, daily or hourly. Within each period, a given time point is chosen when the scenario is to run (minute of hour, hour of day, …)

### Trigger on dataset change

These triggers start a scenario whenever a dataset is changed, data-wise or settings-wise. Detection of changes to the data depends on the type of dataset. For filesystem-like datasets (Uploaded, Filesystem, HDFS), a change means a discrepancy in the file names, lengths or last modification time.

For SQL-like datasets however, changes to the data are not detected and a SQL trigger should be used.

Optionally, for filesystem-like datasets, it is possible to specify a file name as a “marker” file whose changing is understood as “the data has changed”. When a marker file is specified, changing the other files of the data doesn’t activate the **dataset modification trigger**. This makes it possible to prevent the trigger from activating while the dataset files are being modified, and protects against situation where refreshing of a dataset can hang.

### Trigger on SQL query change

When the data is stored in a SQL database, one can usually check changes with a query, for example selecting the maximum of some date. A **SQL trigger** runs a query and activates when the output of the query changes (w.r.t. the last execution of the query).

### Trigger after scenario

These triggers start a scenario after the end of another scenario, optionally with a condition on the followed scenario’s outcome (only if successful, only if failed,…).

### Python triggers

Where a fully flexible approach is required, a **Python** trigger can be set up. This type of trigger executes a Python script, and the script can decide to activate the trigger. This makes it possible to query external APIs and do all sorts of checks.

## Concurrent triggers

In order to avoid simultaneous runs of a given scenario, the following rules apply to triggers:

  * when a trigger activates, the scenario is promoted for execution

  * a promoted scenario is launched after a delay of 60 seconds. If no other trigger associated with the scenario activates during the delay, the scenario is launched; otherwise, if another trigger does activate, the scenario is not launched and the delay is reset

  * triggers are not evaluated while their scenario runs

  * each run of a scenario records the last trigger that activated as the one which launched the run




## Trigger parameters

Triggers can pass parameters to the steps and scripts executed in a scenario run. All triggers pass at least their name and type, but some triggers pass additional data:

  * SQL triggers pass the output of the query

  * Python triggers may pass any data




## Manual triggers

When you manually run a scenario (either through the DSS UI, or through the public API), you are actually using a specific “manual” trigger. The manual trigger may send parameters, which will be received like other trigger parameters.

To pass parameters through the UI, use the “Run with custom parameters” button in the Actions menu.

See the public API doc for information on how to trigger a scenario through the API.

## Evaluation

Each trigger has an evaluation interval. DSS will perform the verification (Files timestamps, SQL query, Python code) at each interval.

Note: time-based triggers do not have an evaluation interval.

## Examples

### Launch a scenario every day at 10:00PM

  * add a _Time-based trigger_

  * set its frequency to `Daily`

  * set the field _every day at_ to `22:00`




### Launch a scenario whenever a HDFS dataset changes

  * add a _Dataset change trigger_

  * select a dataset

  * set the check periodicity




### Launch a scenario whenever a SQL dataset changes

The dataset change triggers do not read the data, only the dataset’s settings, and in the case of datasets based on files, the files’ size and last modified date. These triggers will thus not see changes on a SQL dataset, for example on a SQL table not managed by DSS. For these cases, a SQL query change trigger is needed.

  * add a _SQL query change trigger_

  * write a query that will return a value which changes when the data changes. For example, a row count, or the maximum of some column in the dataset’s table.

  * set the check periodicity

---

## [scenarios/variables]

# Variables in scenarios

When run, scenarios set up a supplementary level of variables, to define or redefine instance-wide or project-wide variables. These definitions and redefinitions of variables are then accessible to all actions during the scenario run, and to all reporters executed at the end of the run.

## Variables scope

There are 3 different levels of variables depending of the step of the scenario :

  * Instance-level variables, accessible to administrators. Those variables can be set through the scenario step **Set global variables**.

  * Project-level variables, for use anywhere in a given project. Those variables can be set through the scenario step **Set project variables**.

  * Scenario-level variables, that don’t persist after a scenario ends. Those variables can be set through the scenario step **Define variables**.




Those step can evaluate a DSS formula and store the result as a variable. Subsequent steps and variable definitions will then be able to use the newly defined variable. The formulas in a **Define variables** step have access to all instance-wide and project-wide variables, and to the parameters of the trigger that initiated the scenario run.

It is also possible to update programmatically instance-level variables with the step **Run global variables update** , in which you can run Jython code, like the following snippet :
    
    
    def get_variables():
        return {"global_variable_1_key": "a_value", "global_variable_2_key": "another_value"}
    

Lastly, in all Python script scenario, variables are made available through a `Scenario` object, both for getting and setting.

See [Update variables with code](<../variables/index.html#update-variables-with-code>) for more information.

## Variables usage

Once defined, your variables can be used inside your scenario steps through expansion. You can see various usages in the page [Custom variables expansion](<../variables/index.html#variables-expansion>).

Some scenario steps, such as **Set project variables** , can also use evaluated variables through the usage of formulas. When this option is enabled, all values are evaluated as DSS formulas. However for scenarios, the `${variable}` syntax is not supported.

Please note also that any formula operation are available when computing evaluated variables. See [Formula language](<../formula/index.html#formula-language>) for more information.

## Usage in partition identifiers

When a step-based scenario is used, it is commonplace to have actions on given datasets, and if the dataset is partitioned, then specifying the partition targeted by the action is needed. This is done by setting a partition identifier in the corresponding parameter of the step. Variables are available in these fields, making it possible to use expressions to pick a specific partition.

For time partitioning, you can use special keywords. For example, “CURRENT_DAY” will be replaced by the current date when the scheduler runs the task. The complete list of time partitioning keywords is:

  * CURRENT_HOUR

  * CURRENT_DAY

  * CURRENT_MONTH

  * CURRENT_YEAR

  * PREVIOUS_HOUR

  * PREVIOUS_DAY

  * PREVIOUS_MONTH

  * PREVIOUS_YEAR




## Examples

### Using the current date to refresh a partition

Selecting the partition corresponding to the current date can be done using the _CURRENT_DAY_ and _CURRENT_MONTH_ keywords as partition identifier. In the context of scenarios, a more flexible approach is to build the partition identifier with variables. For example, to build the partition identifier corresponding the previous month:

  * add a _Define scenario variables_ step

  * add a first variable `today` whose expression is `now()`

  * add a second variable `last_month` whose expression is `today.inc(-1, 'month')`

  * finally, prepare the date as a partition identifier with a third variable `last_month_id` whose expression is `last_month.substring(0,7)`




And in a `Build` step, the partition for a dataset can be set to `${last_month_id}` . A natural extension is to launch the building of several partitions at once, ie. doing dynamic partitioning. A list of partitions to build would then be a comma-separated list of partition identifiers. For more advanced usage of partitions, see [Partition identifiers](<../partitions/identifiers.html>).

### Using the date from a time-based trigger

Triggers produce parameters that can be used in expressions. To build a variable whose value is the date of the scenario launch minus 5 days:

  * add a _Define scenario variables_ step

  * add a first variable `start` whose expression is `asDate(scenarioTriggerParam_expectedStart)`

  * add a second variable `five_days_before_start` whose expression is `start.trunc('day').inc(-5, 'day')`




In case the scenario can be launched manually, the second variable should have as expression: `if(isNull(start), now(), start).trunc('day').inc(-5, 'day')`

### Using the results of a previous SQL step

Steps produce results, which can be used to define variables.

In order to access the step’s result, the step must have a name, and can be accessed through the variable `stepOutput_<step name>`.

For example, if the _Define scenario variables_ comes after a step named _the_sql_ of type _Execute SQL_ , whose query is `select max(order_date) as m from orders`, then building a variable from the maximum date of orders can be done:

  * add a _Define scenario variables_ step

  * add a first variable `max_orderdate` whose expression is `parseJson(stepOutput_the_sql)['rows'][0][0].asDate()`




### Retrieving the message of a check

The _Run checks_ step keeps the results of the checks it has run for subsequent steps. A typical use is to insert checks results in reports sent at the end of the run.

For example, after a _Run checks_ step named _the_checks_ , the variable `stepOutput_the_checks` contains the JSON of the checks’ output. If one is interested by the checks on a dataset named _checked_ in the project _PROJ_ , then the checks’ results for that dataset is a variable `parseJson(stepOutput_the_checks)['PROJ.checked'].results` .

If the goal is to retrieve the status of a check _checkX_ , with a bit of filtering one obtain this status with :
    
    
    filter(parseJson(stepOutput_the_checks)['PROJ.checked_NP'].results, x, x.check.meta.label == 'checkX')[0].value.outcome
    

### Retrieving the value of a metric

The _Compute metrics_ step keeps the results of the metrics it has run for subsequent steps.

For example, after a _Compute metrics_ step named _the_metrics_ , the variable `stepOutput_the_metrics` contains the JSON of the metrics’ computation output, indicating which metrics got computed and their value, and which metrics were skipped. If one is interested by the value of the metrics on a dataset named _computed_ in the project _PROJ_ , then the metrics’ results for that dataset is a variable `parseJson(stepOutput_the_metrics)['PROJ.computed'].results` .

If the goal is to retrieve the value of the metric _col_stats:MIN:cost_ , with a bit of filtering one obtains this status with :
    
    
    filter(parseJson(stepOutput_the_metrics)['PROJ.computed_NP'].computed, x, x.metricId == 'col_stats:MIN:cost')[0].value
    

Similarly, if you wish to retrieve the row count metric _records:COUNT_RECORDS_ , you can do it with the following command :
    
    
    filter(parseJson(stepOutput_the_metrics)['PROJ.computed_NP'].computed, x, x.metricId == 'records:COUNT_RECORDS')[0].value
    

Note

Whenever you try to get a metric or check value from a dataset, you will need to append `_` and the partition name of your dataset to the end of its name, or `_NP` for a non-partitioned dataset.

In all the examples above, we assumed that the dataset _computed_ is not partitioned. However, if it is partitioned and we wanted to fetch the value of the metric _records:COUNT_RECORDS_ for the partition _FOO_ , then the code should be :
    
    
    filter(parseJson(stepOutput_the_metrics)['PROJ.computed_FOO'].computed, x, x.metricId == 'records:COUNT_RECORDS')[0].value