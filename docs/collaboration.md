# Dataiku Docs — collaboration

## [collaboration/discussions]

# Discussions

The discussions feature of DSS allow your team to discuss around every kind of object in DSS:

  * Projects

  * Datasets

  * Recipes

  * Notebooks

  * Models

  * Dashboards and insights

  * Workspaces and workspace objects




## Object discussions

Discussions can be accessed:

  * From each object’s pages by clicking on the discussions button




  * From the Flow or list of objects, by selecting the object, and in the right column, clicking the “Discussions tab”

  * From the workspace and workspace objects by clicking the “Discussions tab”




## Discussions inbox

All of the discussions that you take part of, or that are about objects that you are watching can be found in your global discussions inbox.

From the applications menu, select Discussions to be taken to your global discussions inbox.

## Email notifications

In order to receive email notifications for discussions you take part of, or about objects that you are watching:

  * Your administrator must have created a SMTP “messaging channel” from the administration settings, and have set this channel as the “Notification emails” channel

  * Your account needs to have a valid email address registered (accessible from your Profile page)

  * In your Profile page, in the “My Settings”, enable the various notifications options

---

## [collaboration/git]

# Working with Git

## Overview

DSS provides native integration with Git. Several parts of DSS can work with Git.

### Version control of projects

Each change that you make in the DSS UI (modify the settings of a dataset, edit a recipe, modify a dashboard, …) is automatically recorded in the version control system.

This gives you:

  * Traceability into all actions performed in DSS

  * The ability to understand the history of each object

  * The ability to revert changes




For more details, see [Version control of projects](<version-control.html>)

### Importing Python and R code

If you have code that has been developed outside of DSS and is available in a Git repository (for example, a library created by another team), you can import this repository (or a part of it) in the project libraries, and use it in any code capability of DSS (recipes, notebooks, webapps, …)

For more details, see [Importing code from Git in project libraries](<import-code-from-git.html>)

### Importing Jupyter Notebooks

If you have Notebooks that have been developed outside of DSS and are available in a Git repository, you can import these Notebooks in a DSS project. You can modify them inside DSS and push back the changes to the remote repository.

For more details, see [Importing Jupyter Notebooks from Git](<import-notebooks-from-git.html>)

### Developing plugins

When developing plugins, each plugin is a Git repository. You can view the history, revert changes, use branches, and push/pull changes from remote repositories.

For more details, see [Git integration in the plugin editor](<../plugins/reference/git-editor.html>).

### Importing plugins

If you have developed a plugin on a DSS instance and have pushed your plugin to a Git repository, you can import this plugin on another DSS instance directly from the Git repository.

For more details, see [Installing plugins](<../plugins/installing.html>)

## Working with remotes

All integration points explained above include the ability to interact with remote repositories (either pull-only or pull-and-push depending on the cases).

This section explains how you can work with remote repositories.

DSS always uses the `git` command-line client to work with remote repositories, in non-interactive mode.

This applies to all DSS Git remote features, including:

  * Project version control

  * Git references in project libraries

  * Imported Jupyter Notebooks linked to a Git remote

  * Plugin development remotes




Remote Git access is controlled in two layers:

  * Administrators define which remote repositories users may access through Git group rules

  * Users can then authenticate to allowed SSH remotes with their personal SSH keys




Interaction with SSH-based remotes can use:

  * Per-user SSH keys managed in DSS

  * Or the default system-level SSH behavior configured for the DSS server




HTTPS-based remotes are also supported. In that case, the UNIX account running DSS must have credentials available for the target repository, for example through the Git credentials cache.

### Setup

To use personal SSH authentication for Git remotes, an administrator must first enable it, then each user can generate or import their own SSH key in DSS.

#### Administrator setup

Git remote access is configured in **Administration > Settings > Git > Group rules**.

Rules are evaluated on a first-match basis: the first rule matching both the user’s groups and the remote URL is applied.

Each rule can define:

  * Whether Git is allowed for the group

  * A whitelist of allowed remote URLs

  * Additional Git configuration options

  * Whether DSS controls the SSH command

  * Whether per-user SSH keys are allowed for that rule

  * An alternate home directory for Git configuration overrides




To let users authenticate with their own SSH keys, the matching rule must:

  * Allow Git

  * Match the remote repository URL

  * Have **Let DSS control SSH command** enabled

  * Have **Allow per-user SSH keys** enabled




If a rule denies Git, no remote operation is allowed. If a rule allows Git but disables per-user SSH keys, DSS falls back to the default system-level SSH behavior for that rule.

#### User setup

Users manage their Git SSH keys in **Profile > Credentials > SSH**.

Users can:

  * Generate a new SSH key pair directly in DSS

  * Import an existing private key

  * Copy the corresponding public key

  * Reorder their keys

  * Define a **Git repos whitelist regex** on each key




The public key can then be added on the Git hosting platform, for example as a deploy key or a personal SSH key, depending on the Git provider and the desired scope.

Private keys and passphrases are stored encrypted in DSS user credentials. DSS only exposes the public key and the fingerprint back to the user interface.

#### Key selection rules

For a given SSH remote:

  * DSS first applies the matching Git group rule

  * DSS then filters the user’s SSH keys using the key-level **Git repos whitelist regex**

  * An empty regex behaves as a catch-all and matches all repositories

  * Matching keys are sorted by their configured order and loaded into an SSH agent for the Git command.

  * If no user key matches, DSS uses the default system-level SSH behavior




This means that Git group rules and user key regexes are separate filters:

  * Group rules control whether the repository may be accessed at all

  * User key regexes control which of the user’s keys are considered for that repository




#### Legacy and admin-managed setup

Per-user SSH keys are the recommended way to authenticate users to SSH remotes.

However, DSS can still use the default system-level SSH configuration of the DSS server. This remains useful for legacy or admin-managed setups, for example when administrators configure SSH keys or Git settings outside DSS.

If you rely on system-level SSH behavior, make sure that:

  * The UNIX account running DSS can connect to the repository without any interactive prompt

  * The SSH host key of the remote server has already been validated




### Configuration and security

Interaction with remote repositories is still executed by the DSS server in non-interactive mode.

Per-user SSH keys do not bypass Git group rules. Users can only use their personal SSH keys for repositories allowed by the matching rule in **Administration > Settings > Git**.

If no rule matches for a given group, access to Git remotes is denied to this group. It is often desirable to have a catch-all rule as the last rule, i.e. a rule without a group name that catches users not handled by previous rules.

Warning

Never use `.*` as a whitelisted URL, because that allows the user to clone local repositories as the `dssuser`, which can be abused to read folders (as the `dssuser`) that a user shouldn’t be allowed to read.

The default value when adding a new rule prevents this.

#### Example 1: Allow repository URLs explicitly per group

If you want:

  * “group1” to be able to work with remotes “remote1a” and “remote1b”

  * “group2” to be able to work with remote “remote2”

  * All other groups to be denied access to any remote




Configure two rules:

  * Group=group1, URLs whitelist = 2 entries, “remote1a” and “remote1b”

  * Group=group2, URLs whitelist = 1 entry, “remote2”




If you want:

  * “group1” to be able to work only with remote “remote1”

  * All other groups to be able to work with remote “remote2”




Configure two rules:

  * Group=group1, URLs whitelist = 1 entry, “remote1”

  * Group=<empty>, URLs whitelist = 1 entry, “remote2”




#### Example 2: Use admin-managed SSH behavior per group

This is useful if you want administrators to manage SSH configuration outside DSS instead of relying on per-user SSH keys.

If you want:

  * “group1” to be able to work with any remote, but with SSH key “/home/dataiku/.ssh/group1-key”

  * “group2” to be able to work with any remote, but with SSH key “/home/dataiku/.ssh/group2-key”

  * All other groups to be denied access to any remote




Configure two rules:

  * Group=group1, URLs whitelist = default value, add a configuration option `"core.sshCommand" = "ssh -i /home/dataiku/.ssh/group1-key -o StrictHostKeyChecking=yes"`

  * Group=group2, URLs whitelist = default value, add a configuration option `"core.sshCommand" = "ssh -i /home/dataiku/.ssh/group2-key -o StrictHostKeyChecking=yes"`




Note

On Dataiku Cloud, SSH keys created via the SSH extension are available by default to the DSS instance. To specify a custom SSH key, you must also add the `-F none` option so that SSH will not load the default configuration file, otherwise SSH keys listed by default will also be used. So a full configuration would look like: `"ssh -i /home/dataiku/.ssh/group1-key -o StrictHostKeyChecking=yes -F none"`.

### Testing SSH access

Users can validate their SSH setup from **Profile > Credentials > SSH** with **Test your SSH keys with your repositories**.

The test accepts one or more repository URLs, separated by a newline or a `;`.

For each repository, DSS:

  * Checks whether the repository is allowed by the matching Git group rule

  * Tests each matching per-user SSH key individually

  * Tests the final DSS behavior using all matching user SSH keys together with the default system SSH keys




The overall status is successful only when both conditions are met:

  * The repository is allowed by Dataiku Git access rules

  * Read and write access are confirmed




When testing per-user SSH keys specifically, DSS also indicates whether:

  * Per-user SSH keys are allowed by the matching Git group rule

  * At least one user SSH key matches the repository




The read and write checks are performed as follows:

  * Read access is validated with a shallow clone

  * Write access is validated with `git push --dry-run`




If a user’s key does not match the repository because of its whitelist regex, it is shown as skipped rather than failed.

### Troubleshooting

#### “Unknown Host Key” issues

The first time you push to a remote, you might encounter an “UnknownHostKey” error. Because DSS enforces strict host key checking, the SSH host key of the remote server must already be known by the DSS server.

You need to log into the DSS server and run a single `ssh` or remote Git command to the origin you want to talk with in order to retrieve and verify the host key. The key will then be added to the relevant `known_hosts` file and DSS can connect afterwards.

For example if you want to push to `git@myserver.com:myrepo` and get an UnknownHostKey error, log in to the server and run `ssh git@myserver.com`. You will get a prompt to accept the host key. Accept it and you can then work with this remote.

#### Other common issues

If a repository test or Git remote operation fails:

  * Check that the repository URL matches an allowed Git group rule

  * Check that the matching rule allows per-user SSH keys

  * Check that at least one user SSH key matches the repository regex

  * Use the repository test tool in **Profile > Credentials > SSH** to distinguish blocked repositories, regex mismatches, and read or write access failures

---

## [collaboration/import-code-from-git]

# Importing code from Git in project libraries

## Overview

If you have code that has been developed outside of DSS and is available in a Git repository (for example, a library created by another team), you can import this repository (or a part of it) in the project libraries, and use it in any code capability of DSS (recipes, notebooks, webapps, …)

In the project libraries, you can import multiple external repositories, and declare which parts of said repositories should be treated as being part of the project source paths.

This mechanism is called “Git references”.

## Importing a new repository

  * Go to the project’s library editor

  * Click “Git” > “Import from Git…”

  * Enter the URL of the Git repository. Optionally, enter a branch name, tag name or commit id to import

  * Optionally, enter a subpath if you only want to import a part of the repository

  * Enter the “Target path”: where in the hierarchy of libraries you want to import this repository




When you click “Save and Retrieve”, the repository is fetched. The page will be reloaded, so it is advised that you save your unsaved work before importing a new repository.

For more details on working with Git remotes, including SSH setup with Git group rules and per-user SSH keys in **Profile > Credentials > SSH**, see [Working with Git](<git.html>)

### Manage repositories

You can manage your libraries in a dedicated window. To access this window, go to the project’s library editor and click “Git” > “Manage repositories…” This window allows you to:

  * Push your local changes

  * Reset a library from remote HEAD

  * Edit a git reference

  * Unlink a library

  * Add a new git reference

  * Update all references




## Working with Git references

### Push local changes to git

You can push your local changes from DSS to git, using of the three possible actions:

  * Use the manage repositories window

  * Right-click on the library that contains your changes and select “Commit and push…”

  * Click on “Git” > “Commit and push all…”




Each of these actions allows you to commit your changes and push them to git. You will have the option to provide your own commit message.

In the event of a conflict, the conflicting files will be loaded into the editor, alongside the traditional git markers (<<<<, ====, >>>>). For each conflicting file, you will have to resolve the conflict and mark the file as resolved (by clicking the appropriate button located at the top right). Once all files have been marked, you can commit and push your changes.

In the event of a conflict, you can also choose to abandon the resolution of the conflict and revert to the version before the commit attempt.

### Reset from remote HEAD

Once the repository is retrieved, you can perform modifications to the files in DSS. Please note that if you are working on a library that is used in other projects, all changes to this library will be taken into account in all projects.

Once the repository has been retrieved, it can be imported in Python and R code. See [reusing Python code](<../python/reusing-code.html>) and [reusing R code](<../R/reusing-code.html>).

To update a reference, either use:

  * “Git” > “Manage repositories…” > “Reset from remote HEAD”

  * Right-click on the root path of the Git reference and click “Reset from remote HEAD”




This action will perform a true git reset, so any local changes made will be lost.

If changes have been detected, you will see a confirmation window. This happens when you (or some of your colleagues) have some “unpushed” changes.

Reset from remote HEAD

Please note that any change made on a DSS version older than DSS 10.0.0 will not be detected. For example, if you have some unpushed changes from a previous version of DSS, and then migrate to a newer version, you will not be able to see this window until you make additional changes to your library.

### Edit a git reference

The edit reference window allows you to edit and update a git reference and then import a repository. You have to provide the same information as required for importing a new repository.

To edit a git reference, either use:

  * “Git” > “Manage repositories…” > “Edit reference”

  * Right-click on the root path of the Git reference and click “Edit Git reference…”




### Unlink a reference

By selecting this option, you can unlink a library and a git repository. Please note, that this will not delete the directory where the library is stored. If you want to do both, you need to right-click on the wanted library, and select “Delete”.

To unlink a library, either use:

  * “Git” > “Manage repositories…” > “Unlink reference”

  * Right-click on the root path of the Git reference and click “Unlink remote repository…”




### Update all references

Selecting this option will reset from the remote HEAD all your libraries. Please note that if you select this option, it will override the mechanism that prevents you from pulling a library if you have made changes to a library.

---

## [collaboration/import-notebooks-from-git]

# Importing Jupyter Notebooks from Git

If you have Jupyter Notebooks that have been developed outside of DSS and are available in a Git repository, you can import these Notebooks inside a DSS project.

Note

To configure SSH access to Git remotes, including per-user SSH keys, refer to [Working with Git](<git.html>).

## Importing a new Jupyter Notebook

  * Go to the project’s Notebook list

  * Click New Notebook > Import from Git

  * Enter the URL of the Git repository

  * Optionally, specify a branch name

  * Click on List Notebooks

  * Select the Notebooks you want to import




When you click Import X Notebook(s), the repository is fetched and the notebooks are imported in your project.

For more details on working with Git remotes, see [Working with Git](<git.html>)

## Notebook lifecycle

During a Notebook import, DSS will save the reference of the remote git repository.

If you want to save your local modifications back into the remote repository, you can manually push your changes to the referenced git.

  * Go to the project’s Notebook list

  * Select one or multiple Notebooks

  * Open the right panel in the Action section

  * Open the Associated remote Git subsection

  * Click on the button Commit and push

  * DSS will check for potential conflicts

  * Optionally, write a custom commit message

  * Click on Push Notebook(s) to confirm




On the opposite, if you want to retrieve the latest modification from your remote git in your local Notebook, you can pull the referenced git.

  * Go to the project’s Notebook list

  * Select one or multiple Notebooks

  * Open the right panel in the Action section

  * Open the Associated remote Git subsection

  * Click on the button Pull

  * DSS will check for potential conflicts

  * Click on Pull Notebook(s) to confirm




Note

In case a conflict is detected, DSS proposes to override either the **local file** on pull, or the **remote file** on push. More advanced conflict resolutions must be solved outside of DSS.

## How to manage a moved or renamed file on the remote

If someone has renamed or moved a notebook that you have imported, you can reconsolidate it by editing the git reference in DSS

  * Go to the project’s Notebook list

  * Select one Notebook

  * Open the right panel in the Action section

  * Open the Associated remote Git subsection

  * Click on the button Edit

  * Enter the URL of the Git repository

  * Optionally, specify a branch name

  * Enter the path and the remote name of the Notebook. (The local and the remote name of a notebook can differ)




## Export a notebook created in DSS

If you want to add a local Notebook to a remote repository, you can associate a git reference to a Notebook

  * Go to the project’s Notebook list

  * Select one Notebook

  * Open the right panel in the Action section

  * Open the Associated remote Git subsection

  * Click on the button Add

  * Enter the URL of the Git repository

  * Optionally, specify a branch name

  * Enter the path and the remote name of the Notebook. (The local and the remote name of a notebook can differ)




You now need to push your Notebook to add it to your remote repository

---

## [collaboration/index]

# Collaboration

---

## [collaboration/markdown]

# Markdown

DSS comes with editable text fields. It ensures to improve collaboration between users. They are:

  * The short and long descriptions of any DSS object (in the Summary tab)

  * Wiki articles of a project

  * Discussions on any DSS object (by using the Discussions button on the navbar)




All of these text fields support Markdown.

## Definition

Markdown is an easy-to-use syntax that aims to prettify text by allowing to use pictures, to format text, to display advanced objects like tables, lists, etc.

For more information, please visit [Wikipedia](<https://en.wikipedia.org/wiki/Markdown>) and this [Cheatsheet](<https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet>)

## Syntax guide

Here’s an overview of Markdown syntax.

### Headlines
    
    
    # Title
    
    ## Subtitle
    

### Formatting
    
    
    You can have **bold text** and _italic text_
    

### Lists
    
    
    - element 1
    - element 2
    
    
    
    1. element 1 in numbered list
    2. element 2 in numbered list
    

### Image
    
    
    ![image label](https://upload.wikimedia.org/wikipedia/en/thumb/9/91/Dataiku_logo.png/250px-Dataiku_logo.png)
    

If the image is stored as an attachment to a wiki article, you can display it with:
    
    
    ![image label](PROJECT_KEY.attachment_id)
    

### Link
    
    
    [link label](https://www.dataiku.com/)
    

### Email link
    
    
    <[[email protected]](</cdn-cgi/l/email-protection>)>
    

### Blocks
    
    
    > quoted text
    > on two lines
    
    
    
    ```
    # This is a code snippet
    import os
    print(os.name)
    ```
    

### Table
    
    
    | Name       | Hobby             | Pet         |
    |------------|-------------------|-------------|
    | Astrid     | :fries:           | :rat:       |
    | Clément    | :computer:        | :cat2:      |
    | Sonia      | :champagne:       | :chicken:   |
    | Pierre     | :surfer:          | :palm_tree: |
    

### Emoji

DSS Markdown comes with a list of emojis (use autocompletion by typing the character `:`):
    
    
    :coffee: :soccer: :snowman:
    

### Users

You can mention an user with its username (use autocompletion by typing the character `@`):
    
    
    @admin
    

### Link to DSS object

You can create a link a specific DSS object:
    
    
    [[PROJECT_KEY.Wiki Article 1]]
    (my dataset)[dataset:PROJECT_KEY.dataset_name]
    (my model)[saved_model:PROJECT_KEY.model_id]
    (my project)[project:PROJECT_KEY]
    

### Link to article uploaded attachment

You can create a link to download an attachment to a wiki article:
    
    
    [attachment label](PROJECT_KEY.attachment_id)
    

### Formula (LaTeX)

You can insert mathematical formulas using the LaTeX syntax as a block:
    
    
    ```math
    E = \frac{mc^2}{\sqrt{1-\frac{v^2}{c^2}}}
    ```
    

The above formula is rendered as:

You can can also insert LaTeX-formatted formulas within paragraphs:
    
    
    When $`a \ne 0`$, there are two solutions to $`ax^2 + bx + c = 0`$
    

The above paragraph is rendered as:

### Advanced

You can use [HTML](<https://en.wikipedia.org/wiki/HTML>) and [CSS](<https://en.wikipedia.org/wiki/Cascading_Style_Sheets>):
    
    
    <i class="icon-dkubird" />
    <marquee direction="right">&lt;&gt;&lt;&nbsp;&hellip;</marquee>

---

## [collaboration/notification-emails/index]

# Email Notifications

---

## [collaboration/notification-emails/welcome-email]

# Welcome Email

A Welcome Email is sent when a user is added to Dataiku DSS.

## Enable Welcome Email

In order to enable the Welcome Email, you need to have an email messaging channel and a channel selected for notification emails.

## Default Welcome Email

The Welcome Email is enabled by default and is initially configured to use the provided standard template:

## Customise Welcome Email

The subject and content of the Welcome Email can be customised in the Admin Settings in the Notifications & Integrations section.

Emails can be sent as HTML or plain text format, with both supporting [Freemarker](<https://freemarker.apache.org/docs/dgui_template_overallstructure.html>) for templating.

Additionally, DSS variables are supported both for the subject and the email content.

---

## [collaboration/requests]

# Requests

Dataiku DSS allows any user to initiate a request to gain access to projects, datasets or other objects.

## Request types

The following requests are available:

### Request to access a project

It allows you to request to be granted project-level permissions on a project with “access requests” enabled.

Read [Project Access](<../security/project-access.html>) for more details on how these requests are managed and sent.

These requests are sent to the project owner and all users with [Edit permissions](<../security/permissions.html>) permission on the project.

### Request to execute an application

It allows you to request to be granted execute-permission on the application

Read [Dataiku Applications](<../applications/index.html>) for more details on how these requests are managed and sent.

These requests are sent to the application owner and all users with [Edit permissions](<../security/permissions.html>) permissions on the application.

### Request to share an object

It allows you to request that an object be shared to a target project. This request can be initiated from the object’s right panel in several places in DSS (data catalog, global search, feature store, flow…)

Read [Shared objects](<../security/shared-objects.html>) for more details on how these requests are managed and sent.

These requests are sent to all users with [Manage shared objects](<../security/permissions.html>) permissions on the object’s project.

### Request to install or update a plugin

It allows you to request a plugin installation or update.

These requests are sent to all users with [Admin](<../security/permissions.html>) permissions on the instance.

The request can be activated/deactivated in Administration > Settings > Other > Access & requests > Dataiku object access & requests. Then check/uncheck Plugins requests: “Allow non-admin users to request a plugin installation”

### Request to create a code environment

It allows you to request a new code environment.

These requests are sent to all users with [Admin](<../security/permissions.html>) permissions on the instance.

The request can be activated/deactivated in Administration > Settings > Other > Access & requests > Dataiku object access & requests. Then check/uncheck Code-env requests: “Allow non-admin users to request a code-env installation”

Note

Code environment requests are available only on Design nodes.

### Request to upgrade profile

It allows you to request a profile upgrade. You can request a profile upgrade:

  * From the navigation bar on the top right

  * When you try to perform an action for which you do not have the required profile




These requests are sent to all users with [Admin](<../security/permissions.html>) permissions on the instance. Then the admin can decide which upgraded profile to assign to the user.

The request can be activated/deactivated in Administration > Settings > Other > Misc > Access & requests > Profile upgrade requests.

Then check/uncheck Profile upgrade requests: “Allow users to request a profile upgrade. Requests are reviewed by administrators”

Note

For more information on user profiles, see [User profiles](<../security/user-profiles.html>).

## Managing requests

The recipient users of the request will be notified that a new request has been made and they will be able to manage it either from the project’s security section or directly from the request inbox.

### Notifications

All recipients of a request will be notified by a new notification on their avatars and will be able to see it from their notification panel.

Additionally all recipients of a request with a valid email address will receive an email informing them that a new request has been made.

On the other end, users who initiated a request will be notified by email when their request is approved.

Note

To receive emails:

  * Users must have enabled “Email me when users request access on my projects or objects” or “Email me when I am granted access to projects” in their profile.

  * DSS must be configured to send Notification emails (in Administration > Settings > Collaboration > Notifications & Integration > Notification emails).




### Requests Inbox

All requests made from DSS can be found and managed in the requests section of the recipient’s Inbox. The inbox is available from the applications menu.

Users initiating a request will not see their requests appearing in their request inboxes since only requests that need management do appear in the inbox.

If a request has been approved or rejected, its status will be updated for all other recipients of the same request. They will be able to see how and when the request was managed.

---

## [collaboration/send-mail]

# Send Emails to a contact list

Dataiku provides a recipe to send mails to a list of contacts.

## Overview

From a dataset containing a column of emails addresses, 1 mail per row will be sent. The email is customizable using Templating, and can be enriched with data contained within each row in the contacts dataset. It can also include other datasets as CSV or Excel attachments.

Note

This capability is provided by the “Send emails” plugin, which you need to install. Please see [Installing plugins](<../plugins/installing.html>).

This plugin is [Not supported](<../troubleshooting/support-tiers.html>)

## Send Mail recipe settings

In most settings, you have 2 main choices:

  * Getting the value from a column

  * Use a custom value directly in the form




**Channel** :

  * Recommended: An existing Dataiku channel configured for sending email

  * “Manually define SMTP” to configure a mail server directly




**Sender**

This field does not appear if the channel already has a sender.

  * Use a dataset column

  * Use a custom value




**Recipient**

The column to use with the email to send to. Addresses can be in the form: `Name <local@domain.com>` or just `local@domain.com`

**Subject**

If you use a custom value, the subject supports templating. You can use column names from the contact dataset, like `Hello {{ Name }} - Some news about {{ category }}`.

## Email Content

### Email Body

  * Use a dataset column

  * Use a custom value: in HTML or plain text (templating is supported in both cases)




### Attachments format

Choose whether to include the attachment datasets as CSV or Excel files. Each dataset will be included as a separate attachment (be careful about the file size).

**Conditional formatting** : If checked, rules defined on your dataset will also be applied to:

  * **HTML email bodies** : Conditional formatting is applied directly to the email content. Leverage directly the JINJA syntax `{{ attachments.my_dataset.html_table }}`

  * **Excel attachments** : The formatting you’ve set up will be applied to your Excel file attachments




## Templating

[JINJA templating](<https://jinja.palletsprojects.com/en/3.1.x/>) is supported. For the body and the subject, you can use:

  * Global or local Dataiku variables

  * Any column value




For the body, you can also insert:

  * An attachment as an HTML table

  * Any data from an attachment




### Dataiku variables

The pattern `${dataiku_variable}` injects a [Dataiku variable](<../variables/index.html>), for instance one set at the project level.

### Contacts dataset column values

The pattern `{{ my_column_name }}` references a dataset column. Its value for the current row of the contacts dataset will replace it.

### Basic HTML table of an attachment dataset

You can inject a dataset as an inline HTML table in the mail body. Only the first 50 rows will be included: `{{ attachments.my_dataset.html_table }}`

The dataset must be an input dataset of the recipe. If the dataset has been shared from another project, you must include the project key: `{{ attachments.other_project_key.my_dataset.html_table }}`. This will include all the columns from that dataset.

The inline HTML table can be customized using CSS.

### Custom rendering of attachment datasets

The full JINJA templating syntax is exposed for the first 50 rows of each attachment dataset using `attachments.my_dataset.data`
    
    
    {% for row in attachments.my_dataset.data %}
    <div>{{ row.my_column }}<div>
    {% endfor %}
    

## Output dataset

The output dataset will be a copy of the contacts dataset with two additional columns:

  * `sendmail_status` \- SUCCESS or FAILED, depending on the status

  * `sendmail_error` \- ordinarily empty, but if there is a failure, populated with an error message from the attempt to send the email

---

## [collaboration/tags]

# Tags

Tags in DSS help you organize your work. You can apply tags to categorize a wide range of objects in DSS such as projects, datasets, models, notebooks, wiki articles.

A tag can be either a freely entered text (project tags) or the value of a category (instance-wide tags).

## Project tags

These tags are the _classic_ tags in DSS. They help you categorize DSS objects using a lightweight user interface and are defined at the project level.

Users with “Write Project content” permission on the project can create tags on the fly everywhere tags are displayed. They can also rename and delete tags or change their colors using the Manage tags pop-up menu that appears when they click the _Add tags_ button.

Alternatively, Project administrators can do the same from the Project > … menu > Settings > Tags screen.

## Global tag categories

To avoid misspelled tags and enforce some consistency, DSS administrators can create tag categories.

A category is defined by its name and a collection of tags. Once a category is defined, DSS objects can be tagged using one or more tags from this category, but only with tags defined in this category. Only administration of the DSS instance can change the list of available tags for a given category.

To create and manage global tag categories, go to Administration > Settings > Global tag categories. From there you can create new categories, delete categories and merge tags.

For example, to categorize projects and datasets by their corresponding company department, you would create a category named “department” and one tag per department: marketing, sales, engineering.

When they are applied to DSS objects, global tags are rendered differently than project-level tags. They have an easy-to-recognize pill shape, with the category first, followed by its selected tag.

For each tag category you can select on which DSS objects the tag from that category will be suggested on. To do that, select the types of DSS objects in the “Apply to”. For all DSS objects of these types, users will be offered a button to add one or more tags from this category.

### Project import/export

When you export a project or a bundle, classic tags applied on DSS objects are exported. If the global tag categories and their tags exist on the instance importing the project, the global tags will also be applied. However, if global tag categories are not pre-existing, these tags will appear as project-level classic tags (for example: “department:marketing”). If the corresponding global tag category is later created on the DSS instance, these tags will be rendered as global tags.

Global tag categories can created manually or via the API.

---

## [collaboration/version-control]

# Version control of projects

DSS comes builtin with Git-based version control. Each project is backed by a regular Git repository. Each change that you make in the DSS UI (modify the settings of a dataset, edit a recipe, modify a dashboard, …) is automatically recorded in the Git repository

This gives you:

  * Traceability into all actions performed in DSS

  * The ability to understand the history of each object

  * The ability to revert changes

  * The ability to work with multiple branches




You don’t need to configure anything to benefit from version control. However, by switching to explicit commit modes, you can get more control.

## Viewing history

On the project menu, click on “Version Control”. The project’s history browser appears. You can view all commits made on the project. Scroll to the bottom to load more commits.

You can click on any commit to view the details and browse the changed files on this commit. By clicking on the “Compare” button, you can compare the state of the whole project between two revisions.

In addition, when you are in an object (dataset, recipe or web app), you can click on the History tab to view the history of only this specific object.

## Manual or automatic commits

In a project “Change Management” settings (Project Settings > Change management), the “Commit Mode” option defines how changes are committed to your project Git repository. You can select between “Auto” or “Explicit” commit modes, based on your workflow preferences.

By default, a Dataiku project uses the “Auto” commit mode where changes are automatically committed whenever you save recipes or other items within the project. In this mode, every time you make a change and save it, a new commit is created in the project Git repository and history.

If you select the “Explicit” commit mode, all changes will still be saved to the project, but you will need to explicitly commit your changes using the “Commit” button that will appear in the top menu on different pages. In this mode, you have more control over when your changes are committed to the Git repository, for example you can choose to commit multiple changes together in a single commit or make individual commits for each modification.

## Reverting

### Revert a project to a revision

On the project’s Version Control page, you can revert your project to a specific revision.

Warning

Reverting a project to an older revision will discard all work performed in all aspects of the project since that revision, by all users of a project.

Reverting only affects the configuration of the project (datasets, recipes, web apps, dashboards…). It does not affect data. Thus, after revert, some data might be missing and might need to be rebuilt

Click on the revision you want to revert to, and click on “Revert to this revision”.

### Revert an object to a revision

From an object’s history tab, you can revert only this object (recipes only for now) to a specific revision. Other objects in the project are not affected.

Warning

Reverting a single object is a dangerous operation, since it might make the reverted object inconsistent with the rest of the project. Various issues may appear.

Reverting a single object may cause Git conflicts. In that case, DSS will not perform the revert. You will need to perform it manually using the Git command line.

We advise that you only use this option to revert to previous revisions only in presence of “simple” changes like changes in code rather than “structural” changes (changing inputs of a recipe, …)

### Revert a single commit from a project

On the project’s Version Control page, you can revert a single previous commit. A “reverse” commit will be added to the history of the project.

Warning

Reverting a single revision is a dangerous operation, since it might make the reverted object inconsistent with the rest of the project. Various issues may appear.

Reverting a single revision may cause Git conflicts. In that case, DSS will not perform the revert. You will need to perform it manually using the Git command line.

We advise that you only use this option to cancel previous commits that only contain “simple” changes like changes in code rather than “structural” changes (changing inputs of a recipe, …)

## Working with branches

Warning

It is strongly recommended to have a good understanding of the Git model and wording before using this feature.

Warning

Merge commits make it impossible to revert a project into an anterior state from the DSS UI. To ensure projects can be reverted, prefer using squash merging, which is only available using an external tool (Github, Bitbucket, Gitlab, …).

From the project’s Version Control page, click on the branch indicator to create a new branch or switch to an existing branch.

If you have enabled a remote, this will show both local and remote branches.

### Using projects per branch

When creating a new branch or switching to a branch, you have the option to either:

  * Switch the current project to the branch

  * Duplicate the current project to a new project that will be initialized on the branch




We strongly recommend using duplicated projects. It is important to understand that a given DSS project can only be on one branch at any given time. If you switch the branch of the current project, this will affect all collaborators, and you can’t work on multiple branches at once. In addition, when using the governance capabilities, not using the recommended duplicated projects may lead to the loss of some governance data (ex: workflows attached to Saved Model Versions or Bundles).

  * If you have a remote repository and you create a duplicated project, you’ll be able to commit and push your changes in the branch from the duplicated project, merge them outside of DSS and then pull the changes in the “main” project. See Working with a remote

  * If you don’t have a remote repository, you’ll be able to commit and merge the branch into the “main” project by using merge requests. See Working with no remote




If you have already created a duplicated project for a given branch, DSS will propose to go to this duplicated project if you try to switch to this branch.

## Working with a remote

The version control in DSS is a regular Git repository (which can be managed with the `git` command line tool).

It is possible to connect the repository of each project to a Git remote. This will allow you to pull new updates and branches from the remote, and to push your changes to the remote.

Warning

**Tier 2 support** : Support for pushing to Git remotes is covered by [Tier 2 support](<../troubleshooting/support-tiers.html>)

Warning

It is strongly recommended to have a good understanding of the Git model and wording before using this feature.

To associate a remote, click on the change tracking indicator, select “Add a remote”, and enter the URL of the remote. For more details on working with Git remotes, including SSH setup with Git group rules and per-user SSH keys in **Profile > Credentials > SSH**, see [Working with Git](<git.html>).

Once the remote is associated, new options become available:

  * Fetch fetches the latest changes and branches from the remote (but does not touch the local copy)

  * Push pushes the current active branch to the remote. Push will fail if the remote has been updated first. In that case, start by pulling.

  * Pull does a “pull –rebase” action: it fetches the latest changes from the remote and attempts to rebase your local changes on top of the remote changes. In case of a conflict, pull aborts. It is not possible to edit conflicts directly in DSS. See below for help on handling conflicts

  * Drop changes allows you to drop all commits you made on the local branch, and to move back the local branch to the HEAD of the remote branch




### Handling conflicts

If pull fails because of a conflict, do the following:

  * Create a new local branch

  * Push it

  * In another Git tool (not DSS), merge the pushed local branch into the original branch, resolving conflicts

  * In DSS, switch back to the original branch and drop local changes

  * Pull

  * You will now have your merged changes




### Merging branches (outside of DSS)

Let’s say you have a project on branch “main” and want to develop a new feature.

  * In DSS, switch to a new branch “myfeature”. This will by default create a new project

  * When you are happy with the new feature, push it

  * In your Git UI (Github, Bitbucket, Gitlab, …), open a pull request from myfeature to main

  * Merge the pull request (prefer squash merging to avoid the limitations on project revert)

  * In DSS, go back to the original project (on the “main” branch)

  * Pull it, you will now have your merged changes




## Working with no remote

Note

Although it is possible to merge branches directly in DSS, we recommend working with a remote whenever possible, as it offers more options for managing merge commits and better collaboration capabilities.

### Merging branches (within DSS)

Note

To create a merge request, the user must be granted the permission to edit the destination project and must be allowed to “Write unisolated code”.

Let’s say you have a project on branch “main” and want to develop a new feature.

  * In DSS, switch to a new branch “myfeature”. Choose to duplicate the project

  * When you are happy with the new feature, go back to the main project and create a merge request

  * Select the duplicated project associated with the “myfeature” branch

  * Review the changes and resolve the conflicts if any

  * Merge the merge request.




## Per-project vs global Git

When you install DSS, it is by default configured to have one Git repository per project, plus a global Git repository for “global” configuration elements (Administration settings, connections, users and groups, …)

Note

DSS overrides the Git `excludesFile` configuration property in each project. This property references a global `.dku-projects-gitignore` file that centralizes all DSS internal project files that must be git-ignored.

DSS can also be configured to have a single Git repository for the whole configuration of all projects.

Warning

We don’t advise changing this setting. Using global repository makes it impossible to work with Git remotes.

To change this setting:

  * Stop DSS

  * Edit `install.ini`, and in the `[git]` section, set `mode = global`

  * Start DSS

---

## [collaboration/wiki]

# Wikis

Each DSS project contains a Wiki.

You can use the Wiki of a project:

  * To document the project’s goals

  * To document the project’s inputs and outputs

  * To document the inner workings of the project

  * As a way to organize your work with your colleagues

  * To keep track of planned future enhancements




The DSS wiki is based on the well-known [Markdown](<markdown.html>) language.

In addition to writing Wiki pages, the DSS wiki features powerful capabilities.

## Taxonomy

All the pages of the Wiki are organized in a hierarchical taxonomy. Each article can have a “Parent” article (articles can also have no parent and be attached to the root of the hierarchy).

The taxonomy can be browsed in order to get a quick overview of your Wiki

## Attachments and links

### Attaching files

You can attach multiple files to each Wiki article. Simply click the “Add attachment” button, and go to the “File” tab

### Directly linking to a DSS object

In your Wiki article, you can create clickable links to any DSS object (dataset, recipe, notebook, ….) in the project or in another project. See [the documentation about Markdown](<markdown.html>) for details on the syntax to create links to DSS objects

### Attaching DSS objects

In addition to links inline in the Wiki article, you can “attach” a DSS object to a Wiki article. This object will always appear in the list of attachments.

### Referencing attachments

To add a reference to an attachment in the body of an article, click the attachment name while you are in “Edit” mode for the Article

### Folder layout

Articles can be switched to a “Folder-oriented” layout where the article text appears at the top, followed by a detailed list of all attachments, including both files and DSS objects.

To switch between layouts, use the “Actions > Switch to folder layout” or “Actions > Switch to article layout” buttons in the Actions menu.

## Promoted wikis

The administrator of a DSS project can “promote” the Wiki of a project by going to Settings > Wiki.

Wikis that are promoted will appear in the DSS-wide “Wikis” (accessible from the main menu) for users who have access to the project

## Help center articles

Selected articles can be made available in the “Support Resources” section of the help center. It is recommended to use this feature to put on the help center a few articles related to your particular onboarding / getting started (for example: where is the data, who to ask for help, …)

Help center articles are controlled by global DSS administrators, from the “Administration -> Settings -> Help and support” page

Note

You can also give quick access to wiki articles in the home page, by setting them up as promoted content, from the _Administration - > Settings -> Homepage_ page. See [Managing promoted content](<../concepts/homepage/landing-page.html#id1>) for more details.

## Publishing an article on the dashboard

There is a [specific dashboard insight](<../dashboards/insights/wiki-article.html>) to show a Wiki article on the dashboard.

## Wiki Export

Wiki articles can be exported to PDF files in order to propagate information inside your organization more easily.

Wiki exports can be:

>   * Created and downloaded interactively through the wiki user interface
> 
>   * Created automatically and sent by mail using the “mail reporters” mechanism in a scenario
> 
>   * Created automatically and stored in a managed folder using a dedicated scenario step
> 
> 


### Setup

The graphics export feature must be setup prior to being usable.

If you are running Custom Dataiku, follow [Setting up DSS item exports to PDF or images](<../installation/custom/graphics-export.html>) to enable the export feature on your DSS instance. If you are running Dataiku Cloud Stacks, you do not need any setup.

### Interactive usage

Export an article directly from a wiki article.

### Options

The following options are available:

  * Export :

    * Whole wiki : export the entire wiki of the project.

    * Article and its children : export the current article and the entire hierarchy beneath it.

    * Article only : export the current article.

  * Page size : determines the dimensions of the page.

  * Export attachments : generates a zip file containing the selected articles as a PDF, along with any attachments. Linked DSS items are not exported.




### Automatic usage

In a scenario, there are two ways to create wiki exports, with the same options available as the interactive export:

  * Create a “wiki export” step that allows you to store an export in a local managed folder.




  * With a mail reporter and a valid mail channel, you can select a “wiki export” attachment. The wiki will be attached to the mail




### Page break

There will be a page break between each article in the exported document.

It is also possible to manually insert page breaks in specific places by using the thematic break markers `---` or `<hr>`.