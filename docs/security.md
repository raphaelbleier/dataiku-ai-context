# Dataiku Docs — security

## [security/advanced-options]

# Advanced security options

## Hiding error stacks

By default, the DSS backend sends backend error stacks to logged-in users. This makes debugging and understanding easier.

This behavior can be disabled in the following way:

  * Stop DSS



    
    
    DATADIR/bin/dss stop
    

  * Edit the `DATADIR/config/general-settings.json` file

  * Locate the `"security"` top-level key in the JSON file. If it does not exist, create it as an empty JSON object

  * Within “security”, add or edit the following key : `"hideErrorStacks" : true`

  * Start DSS



    
    
    DATADIR/bin/dss start
    

## Hiding version info

By default, the DSS backend sends DSS version information, even to non-logged in users.

This behavior can be disabled in the following way:

  * Stop DSS



    
    
    DATADIR/bin/dss stop
    

  * Edit the `DATADIR/config/general-settings.json` file

  * Locate the `"security"` top-level key in the JSON file. If it does not exist, create it as an empty JSON object

  * Within “security”, add or edit the following key : `"hideVersionStringsWhenNotLogged" : true`

  * Start DSS



    
    
    DATADIR/bin/dss start
    

## Using secure cookies

By default, DSS login cookies do not carry the `Secure` flag (which would make them unusable over non-secured HTTP connections).

If you configure DSS to using HTTPS for all users, either [natively](<../installation/custom/advanced-customization.html#config-https>) or through a [reverse proxy](<../installation/custom/reverse-proxy.html>), you can enable the use of secure cookies. This further secures user connections by ensuring the browser never sends the session cookie over unsecured connections.

  * Stop DSS



    
    
    DATADIR/bin/dss stop
    

  * Edit the `DATADIR/config/general-settings.json` file

  * Locate the `"security"` top-level key in the JSON file. If it does not exist, create it as an empty JSON object

  * Within “security”, add or edit the following key : `"secureCookies" : true`

  * Start DSS



    
    
    DATADIR/bin/dss start
    

## Expiring sessions

### DSS version ≥ 14.3.0

You can configure DSS to have sessions expire after a certain amount of time since login, and/or after a certain amount of inactivity.

Warning

  * Sessions expiration can cause lost work: if you have work open and your session expires, you may not be able to save your work

  * If you have a Jupyter notebook open and your session expires, the underlying Jupyter kernel remains alive and you can still communicate with it and execute code, until the next page refresh. However, saving updates to the notebook becomes impossible




  * In DSS, go to Administration > Settings > Security & Audit > User login & provisioning > Session management

  * Set the “Maximum session duration” and “Idle timeout” options to the desired expiration timeout, respectively since login and inactivity.

  * Save (restart is not needed)




If session expiration was previously configured using the method for DSS < 14.3.0, it is recommended to remove the key `dku.sessions.storage=memory` from the `DATADIR/config/dip.properties` file because using non-persistent session storage is no longer necessary to enable session expiration.

### DSS version < 14.3.0

You can configure DSS to have sessions expire, either after a certain amount of time since login, or after a certain amount of inactivity.

Warning

  * Enabling sessions expiration also means that all user sessions are always terminated each time the DSS backend restarts

  * Sessions expiration can cause lost work: if you have work open and your session expires, you may not be able to save your work

  * If you have a Jupyter notebook open and your session expires, the underlying Jupyter kernel remains alive and you can still communicate with it and execute code, until the next page refresh. However, saving updates to the notebook becomes impossible




  * Stop DSS



    
    
    DATADIR/bin/dss stop
    

  * Edit the `DATADIR/config/dip.properties` file and add the following key: `dku.sessions.storage=memory`

  * Edit the `DATADIR/config/general-settings.json` file

  * Locate the `"security"` top-level key in the JSON file. If it does not exist, create it as an empty JSON object

  * Within “security”, add or edit the following keys: `"sessionsMaxTotalTimeMinutes"` and `"sessionsMaxIdleTimeMinutes"`. Set them to the desired expiration timeout, respectively since login and on inactivity. 0 means no expiration for this kind.

  * Start DSS



    
    
    DATADIR/bin/dss start
    

## Forcing a single session per user

By default, DSS users can log in from multiple sessions at once. You can additionally configure DSS to only allow a single session. When a user logs in, all their other sessions are terminated.

### DSS version ≥ 14.3.0

  * In DSS, go to Administration > Settings > Security & Audit > User login & provisioning > Session management

  * Check the “Force single session per user” option to enable it

  * Save (restart is not needed)




### DSS version < 14.3.0

  * Stop DSS



    
    
    DATADIR/bin/dss stop
    

  * Edit the `DATADIR/config/general-settings.json` file

  * Locate the `"security"` top-level key in the JSON file. If it does not exist, create it as an empty JSON object

  * Within “security”, add or edit the following key : `"forceSingleSessionPerUser" : true`

  * Start DSS



    
    
    DATADIR/bin/dss start
    

## Restricting visibility of groups and users

By default, all logged-in DSS users can view the list of groups and users. This is useful for:

  * Allowing project owners to add groups to their projects

  * Allowing users to mention all users




You can select to restrict visibility of groups and users. The following rules apply:

  * If you are admin, you can see everything

  * You can see all groups to which you belong

  * You can see all users of groups to which you belong

  * In addition, you can see all users that are participants in projects in which you are participant




Instructions:

  * Stop DSS



    
    
    DATADIR/bin/dss stop
    

  * Edit the `DATADIR/config/general-settings.json` file

  * Locate the `"security"` top-level key in the JSON file. If it does not exist, create it as an empty JSON object

  * Within “security”, add or edit the following key : `"restrictUsersAndGroupsVisibility" : true`

  * Start DSS



    
    
    DATADIR/bin/dss start
    

Note

This is a best-effort feature. Obvious listing of users are suppressed, but we do not guarantee perfect isolation.

## Redirecting to a custom URL after logout

By default, when users log out from DSS, they are redirected to a standard Web page hosted by DSS.

To configure DSS to redirect users to a different URL when they log out:

  * Stop DSS



    
    
    DATADIR/bin/dss stop
    

  * Edit the `DATADIR/config/general-settings.json` file

  * Locate the `"security"` top-level key in the JSON file. If it does not exist, create it as an empty JSON object

  * Within “security”, add the following keys:



    
    
    "postLogoutBehavior": "CUSTOM_URL",
    "postLogoutCustomURL": "https:///my-custom-url"
    

  * Start DSS



    
    
    DATADIR/bin/dss start
    

## Example general-settings.json file

With the previous options enabled, your general-settings.json could look like:
    
    
    {
      "udr": true,
      "proxySettings": {
        "port": 0
      },
      "mailSettings": {},
      "maxRunningActivitiesPerJob": 5,
      "maxRunningActivities": 5,
      "ldapSettings": {
        "enabled": false,
        "useTls": false,
        "userFilter": "(\u0026(objectClass\u003dposixAccount)(uid\u003d{USERNAME}))",
        "displayNameAttribute": "cn",
        "emailAttribute": "mail",
        "enableGroups": true,
        "groupFilter": "(\u0026(objectClass\u003dposixGroup)(memberUid\u003d{USERNAME}))",
        "groupNameAttribute": "cn",
        "autoImportUsers": true
      },
      "computablesAvailabilityMode": "EXPOSED_ONLY",
      "globalCrossProjectBuildBehaviour": "STOP_AT_BOUNDARIES",
      "noLoginMode": false,
      "sessionsMaxTotalTimeHours": 0,
      "sessionsMaxIdleTimeHours": 0,
      "security" : {
        "hideVersionStringsWhenNotLogged" : true,
        "hideErrorStacks" : true,
        "secureCookies" : true,
        "sessionsMaxTotalTimeMinutes": 0,
        "sessionsMaxIdleTimeMinutes": 20,
        "forceSingleSessionPerUser": false,
        "restrictUsersAndGroupsVisibility": true,
        "postLogoutBehavior": "CUSTOM_URL",
        "postLogoutCustomURL": "https://www.dataiku.com"
      }
    }
    

## Restricting types of files that can be uploaded in wikis

By default, all logged-in DSS users can upload any type of files to wiki articles.

You can configure DSS to restrict the types of files that are allowed by specifying a list of accepted extensions.

  * Edit the `DATADIR/config/dip.properties` file

  * Add `dku.wikis.authorizedUploadExtensions=png,jpg,jpeg,gif,txt,csv` (update the list according to your security needs)




## Restricting exports

It is possible to globally restrict some export features in DSS (regardless of project permissions).

Warning

Any restriction to exports conceptually remains a “best-effort”. Any user who is granted the right to see data in DSS can, with more or less effort, manage to export it, if only by copy/pasting it.

To use these options, a DSS administrator with access to the DSS server needs to edit the “config/dip.properties” file in the DSS data dir and add one of the following lines:

  * `dku.exports.disableAllDatasetExports=true`
    
    * Disables exports of datasets globally on the instance (the exports that are restricted are the ones that are about “Download” of datasets in order to generate data files (CSV, Excel, Tableau Hyper, …).

    * Other exports (ML data, schema, SQL queries, prepared data) remain possible

    * Disables ability to include datasets in project exports and bundle downloads

    * Disables ability to attach datasets to emails in scenarios

  * `dku.exports.disableAllDataExports=true` (implies the previous one)
    
    * Disables exports of datasets globally on the instance (the exports that are restricted are the ones that are about “Download” of datasets in order to generate data files (CSV, Excel, Tableau Hyper, …).

    * Disables exports of prepared data or SQL query results

    * Exports of ML data and schemas remain possible

    * Disables ability to download files of zips from managed folders

    * Disables ability to include datasets or managed folders in project exports and bundle downloads

    * Disables ability to attach datasets or other data items to emails in scenarios

  * `dku.exports.disableAllExports=true` (implies the previous one)
    
    * Disables exports of datasets globally on the instance (the exports that are restricted are the ones that are about “Download” of datasets in order to generate data files (CSV, Excel, Tableau Hyper, …).

    * Disables exports of prepared data or SQL query results

    * Disables exports of ML data and schemas

    * Disables ability to download files of zips from managed folders

    * Disables ability to include datasets or managed folders in project exports and bundle downloads

    * Disables ability to attach datasets or other data items to emails in scenarios

  * `dku.exports.disableCopySampleToClipboard=true`
    
    * Disables the ability to copy samples to the clipboard. This option enable/disable the feature everywhere, with the exception of SQL notebook (defaults to false, i.e. enabled)

  * `dku.exports.disableSQLNotebookCopyResultToClipboard=true`
    
    * Disables the ability to copy samples to the clipboard on SQL notebook (defaults to false, i.e. enabled)




## Setting security-related HTTP headers

It is possible to set the following security-related HTTP headers:

  * X-Frame-Options

  * Content-Security-Policy

  * X-XSS-Protection

  * X-Content-Type-Options

  * Strict-Transport-Security

  * Referrer-Policy

  * Permissions-Policy

  * Cross-Origin-Embedder-Policy

  * Cross-Origin-Opener-Policy

  * Cross-Origin-Resource-Policy




All of these are configured in the `[server]` section of the `install.ini` file.

Here is a syntax example:
    
    
    [server]
    port=11000
    
    content-security-policy=script-src 'self' 'unsafe-inline' 'unsafe-eval'; frame-ancestors 'none'
    x-frame-options=SAMEORIGIN
    x-content-type-options=nosniff
    x-xss-protection=1;mode=block
    hsts-max-age=31536000
    referrer-policy=same-origin
    permissions-policy=fullscreen
    cross-origin-embedder-policy=unsafe-none
    cross-origin-opener-policy=unsafe-none
    cross-origin-resource-policy=cross-origin
    

You need to run `./bin/dssadmin regenerate-config` and to restart DSS after changing this.

## Allowing DSS to be hosted inside an iframe

By default, DSS cannot be hosted inside an iframe as Web browsers treats its authentication cookies as SameSite=Lax.

To configure DSS to emit authentication cookies using SameSite=None:

  * Stop DSS



    
    
    DATADIR/bin/dss stop
    

  * Edit the `DATADIR/config/general-settings.json` file

  * Locate the `"security"` top-level key in the JSON file. If it does not exist, create it as an empty JSON object

  * Within “security”, add or edit the following keys: `"sameSiteNoneCookies" : true` and `"secureCookies" : true`

  * Start DSS



    
    
    DATADIR/bin/dss start
    

Note

DSS must be accessed via the HTTPS protocol and cookies must be set as Secure for this option to work as Web browsers do not take into account the SameSite cookie parameter for non-secure cookies.

## Preventing links to be clickable in data tables

By default, links are displayed in dataset Explore and dataset insights.

To prevent this, edit the `DATADIR/config/dip.properties` file and add the following key: `dku.feature.dataTableLinks.enabled=false`

## Allowing DSS users to edit their display names and emails

Starting from version 13.2.0, users can no longer edit their display names and email addresses. Only DSS administrators have the ability to make these changes. This restriction helps prevent impersonation by DSS users.

To allow users to update their display names and email addresses:

  * Stop DSS



    
    
    DATADIR/bin/dss stop
    

  * Edit the `DATADIR/config/general-settings.json` file

  * Locate the `"security"` top-level key in the JSON file. If it does not exist, create it as an empty JSON object

  * Within “security”, add or edit the following keys: `"enableEmailAndDisplayNameModification" : true`.

  * Start DSS



    
    
    DATADIR/bin/dss start
    

Note

Please note that enabling email and display name modifications will disable the ability for users to share assets, such as projects, via email invitations.

---

## [security/advisories/cve-2020-25822]

# Incorrect access control allows users to edit discussions

## Information

  * CVE Id: CVE-2020-25822

  * CVSS 3.0 Score: 4.3

  * Severity: Medium

  * CWE classification: CWE-273 - Incorrect Access Control

  * CVSS 3.0 string: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N




## Summary

The discussions feature allows users to edit their own posts. Insufficient access control on the API endpoint used to edit posts allows other users (who have permission to comment and modify their posts) to modify posts of other users.

## Affected Products

Dataiku DSS in versions before 8.0.2

## Credits

This vulnerability was discovered by cobalt.io

## Mitigation

Dataiku DSS 8.0.2 has been made available to customers to remediate this issue

---

## [security/advisories/cve-2020-8817]

# Ability to tamper with creation and ownership metadata

## Information

  * CVE Id: CVE-2020-8817

  * CVSS Base Score: 4.3

  * Severity: Medium

  * CWE classification: CWE-284




## Summary

The “Created by” metadata displayed in the right column for most Dataiku object types (datasets, Wiki articles, dashboards, …) can be tampered with by users with write access to the project.

Although the audit trail and history log always reference the proper information, this allows hostile attackers to display misleading metadata information in the right column.

## Affected Products

Dataiku DSS in versions before 6.0.5

## Mitigation

Dataiku DSS 6.0.5 has been made available to customers to remediate this issue.

## Credits

This vulnerability was discovered and reported by Fábio Freitas ([@0xfabiof](<https://twitter.com/0xfabiof>)). Thanks!

---

## [security/advisories/cve-2020-9378]

# Directory traversal vulnerability in Shapefile parser

## Information

  * CVE Id: CVE-2020-9378

  * CVSS Base Score: 7.5

  * Severity: High

  * CWE classification: CWE-23




## Summary

The Shapefile parser in Dataiku DSS before 6.0.5 insufficiently sanitizes zipped Shapefiles, which allows an attacker to overwrite configuration files through crafted zipped Shapefiles.

## Affected Products

Dataiku DSS in versions before 6.0.5

## Mitigation

Dataiku DSS 6.0.5 has been made available to customers to remediate this issue

---

## [security/advisories/cve-2021-27225]

# Incorrect access control in Jupyter notebooks

## Information

  * CVE Id: CVE-2021-27225

  * CVSS Base Score: 5.4

  * Severity: Medium

  * CWE classification: CWE-284




## Credits

Dataiku would like to thank Xiejingwei Fei (jack dot fei at finra dot org) for discovering and reporting this vulnerability.

## Summary

In Dataiku DSS before 8.0.6, insufficient access control in the Jupyter notebooks integration allows users (who have coding permissions) to read and overwrite notebooks in projects that they are not authorized to access.

In order to exploit the vulnerability, the attacker must have coding permissions in Dataiku DSS and write access to a project, and must send specially-crafted HTTP queries.

## Affected Products

Dataiku DSS in versions before 8.0.6

## Mitigation

Dataiku DSS 8.0.6 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2021-001]

# Stored XSS in object titles

## Information

  * Advisory ID: DSA-2021-001

  * CVSS Base Score: 8.8

  * Severity: High

  * CWE classification: CWE-79




## Summary

In Dataiku DSS before 8.0.7, insufficient input sanitization could lead to a stored XSS in the “title” fields of projects and other Dataiku objects.

## Affected Products

Dataiku DSS in versions before 8.0.7

## Mitigation

Dataiku DSS 8.0.7 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2021-002]

# Stored XSS in object titles

## Information

  * Advisory ID: DSA-2021-002

  * CVSS Base Score: 8.8

  * Severity: High

  * CWE classification: CWE-79




## Summary

In Dataiku DSS before 9.0.4, insufficient input sanitization could lead to a stored XSS in the “title” fields of projects and other Dataiku objects.

## Affected Products

Dataiku DSS in versions before 9.0.4

## Mitigation

Dataiku DSS 9.0.4 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2021-003]

# Access control issue on downloading project exports

## Information

  * Advisory ID: DSA-2021-003

  * CVSS Base Score: 4.3

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-284




## Summary

In Dataiku DSS before 9.0.6, insufficient access control could allow logged-in attackers to download another project export, if they were able to capture the moment it was exported.

## Affected Products

  * Dataiku DSS 8 and previous versions

  * Dataiku DSS 9, before 9.0.6

  * Dataiku DSS 10, before 10.0.2




## Mitigation

Dataiku DSS 9.0.6 and 10.0.2 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2021-004]

# Access control issue on changing dataset connections

## Information

  * Advisory ID: DSA-2021-004

  * CVSS Base Score: 4.3

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N

  * Severity: Medium

  * CWE classification: CWE-284




## Summary

In Dataiku DSS before 9.0.6, insufficient access control could allow logged-in attackers to modify the connection of datasets they were not allowed to modify

## Affected Products

  * Dataiku DSS 8 and previous versions

  * Dataiku DSS 9, before 9.0.6

  * Dataiku DSS 10, before 10.0.2




## Mitigation

Dataiku DSS 9.0.6 and 10.0.2 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2021-005]

# Access control issue on dashboards listing

## Information

  * Advisory ID: DSA-2021-005

  * CVSS Base Score: 4.3

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-284




## Summary

In Dataiku DSS before 9.0.6, insufficient access control allowed logged-in users to view the existence of dashboards even if they did not have access to it, which leaked the title of the dashboard

## Affected Products

  * Dataiku DSS 8 and previous versions

  * Dataiku DSS 9, before 9.0.6

  * Dataiku DSS 10, before 10.0.2




## Mitigation

Dataiku DSS 9.0.6 and 10.0.2 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2021-006]

# Access control issue on saving project permissions

## Information

  * Advisory ID: DSA-2021-006

  * CVSS Base Score: 6.7

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:H/UI:N/S:U/C:H/I:L/A:L

  * Severity: Medium

  * CWE classification: CWE-284




## Summary

In Dataiku DSS before 9.0.6, insufficient access control could allow project administrators to modify permissions of other projects that they were not allowed to access.

## Affected Products

  * Dataiku DSS 8 and previous versions

  * Dataiku DSS 9, before 9.0.6

  * Dataiku DSS 10, before 10.0.2




## Mitigation

Dataiku DSS 9.0.6 and 10.0.2 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-001]

# PwnKit Linux vulnerability (CVE-2021-4034)

## Information

  * Advisory ID: DSA-2022-001 (original vulnerability: CVE-2021-4034)

  * CVSS Base Score: 8.8

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * Severity: High

  * CWE classification: CWE-787 / CWE-125




## Summary

A Local Privilege Escalation was found in the “PolicyKit” component of all major Linux distributions. This allows hostile local users to gain root access.

Cloud Stacks DSS instances are affected by this vulnerability.

## Affected Products

  * Dataiku DSS 9.0.6 and previous versions (Cloud Stacks deployments)

  * Dataiku DSS 10.0.2 and previous versions (Cloud Stacks deployments)




Warning

Non-Cloud Stacks deployments may be affected too. However, for these deployments, Dataiku software does not manage the base OS in which the vulnerability lies.

Please refer to the mitigation instructions from your OS vendor

## Fix

Dataiku DSS 9.0.7 and 10.0.3 have been released and address the vulnerability

## Mitigation

To fix the vulnerability without upgrading to DSS 9.0.7 or 10.0.3, please follow these instructions:

  * Log onto your Fleet Manager

  * Go to the Instance template (or Instance templates) used by your instances

  * Add a setup action of type “Run Ansible Tasks”. Make sure “After DSS start” is selected as the Stage

  * Enter the following Ansible command



    
    
    ---
    - become: true
      command: /usr/bin/yum update -y polkit
    

  * Save the instance template

  * For each instance, go to the instance page, and click on Actions > Replay Setup Actions

  * Your DSS instance is now safe from the vulnerability




## Timeline

  * January 25th, 2022 (5pm): Vulnerability is disclosed

  * January 26th, 2022: Dataiku publishes mitigation instructions

  * January 27th, 2022: Dataiku notifies affected customers

  * January 28th, 2022: Dataiku publishes fixed version




If you encounter any issue following this procedure, or for any additional question, please feel free to reach out to Dataiku Support.

---

## [security/advisories/dsa-2022-002]

# Access control issue on foreign managed folders

## Information

  * Advisory ID: DSA-2022-002

  * CVSS Base Score: 5.7

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:R/S:U/C:H/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-284




## Summary

In Dataiku DSS before 10.0.6, insufficient access control could allow an authenticated attacker who has been given the internal identifier of a managed folder the ability to read and modify it

## Affected Products

  * Dataiku DSS before 10.0.6




## Fix

Dataiku DSS 10.0.6 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-003]

# Cross-script-scripting on model reports

## Information

  * Advisory ID: DSA-2022-003

  * CVSS Base Score: 7.6

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:R/S:U/C:H/I:H/A:L

  * Severity: High

  * CWE classification: CWE-79




## Summary

In Dataiku DSS before 10.0.6, insufficient input sanitization could allow an authenticated attacker to send a malicious link to a custom model report that would trigger a cross-script-scripting issue

## Affected Products

  * Dataiku DSS before 10.0.6




## Fix

Dataiku DSS 10.0.6 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-004]

# Code execution through server-side-template-injection

## Information

  * Advisory ID: DSA-2022-004

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * CVSS Base Score: 8.8 (High)

  * CWE classification: CWE-1336




## Summary

In Dataiku DSS before 10.0.6, insufficient sanitization of custom email templates could allow an authenticated attacker to perform code execution.

## Affected Products

  * Dataiku DSS before 10.0.6




## Fix

Dataiku DSS 10.0.6 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-005]

# Insufficient access control on managed cluster logs and configuration

## Information

  * Advisory ID: DSA-2022-005

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N

  * CVSS Base Score: 4.3 (Medium)

  * CWE classification: CWE-284




## Summary

In Dataiku DSS 10.0.6 and 10.0.7, users with only “Use” instead of “Manage” permission could access managed clusters logs and configuration.

## Affected Products

  * Dataiku DSS 10.0.6

  * Dataiku DSS 10.0.7




## Fix

Dataiku DSS 10.0.8 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-006]

# Multiple access control issues

## Information

  * Advisory ID: DSA-2022-006

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N

  * CVSS Base Score: 5.3 (Medium)

  * CWE classification: CWE-284




## Summary

Multiple low-impact access control issues could allow unprivileged users to access low-confidentiality information that they should not be able to access.

## Affected Products

  * Dataiku DSS in versions prior to 10.0.8




## Fix

Dataiku DSS 10.0.8 has been made available to customers to remediate this issue

Note

covers 96623, 96629, 96622, 96620, 92577

---

## [security/advisories/dsa-2022-007]

# Multiple access control issues

## Information

  * Advisory ID: DSA-2022-007

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:L

  * CVSS Base Score: 5.3 (Medium)

  * CWE classification: CWE-284




## Summary

Multiple low-impact access control issues could allow unprivileged users to cause minor service disruptions.

## Affected Products

  * Dataiku DSS in versions prior to 10.0.8




## Fix

Dataiku DSS 10.0.8 has been made available to customers to remediate this issue

Note

covers 96627, 96628

---

## [security/advisories/dsa-2022-008]

# Stored XSS in dataset settings

## Information

  * Advisory ID: DSA-2022-008

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * CVSS Base Score: 8.8 (High)

  * CWE classification: CWE-79




## Summary

Insufficient input sanitization could lead to a stored XSS in the “Preview” table of dataset settings

## Affected Products

Dataiku DSS in versions before 10.0.8

## Mitigation

Dataiku DSS 10.0.8 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-009]

# Stored XSS in machine learning results

## Information

  * Advisory ID: DSA-2022-009

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * CVSS Base Score: 8.8 (High)

  * CWE classification: CWE-79




## Summary

Insufficient input sanitization could lead to a stored XSS in the Machine Learning results component

## Affected Products

Dataiku DSS in versions before 10.0.8

## Mitigation

Dataiku DSS 10.0.8 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-010]

# Insufficient access control on export to dataset

## Information

  * Advisory ID: DSA-2022-010

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:H/A:N

  * CVSS Base Score: 6.5 (Medium)

  * CWE classification: CWE-284




## Summary

Insufficient access control could allow hostile attackers to leverage the export mechanism to overwrite a dataset in a project that they do not have access to

## Affected Products

  * Dataiku DSS before 10.0.8




## Fix

Dataiku DSS 10.0.8 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-011]

# Remote code execution in API designer

## Information

  * Advisory ID: DSA-2022-011

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H or CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H (context-dependent)

  * CVSS Base Score: 9.8 (Critical) or 8.8 (High) (context-dependent)

  * CWE classification: CWE-284




## Summary

It was discovered that a non-random internal credential could allow an attacker to execute code on the DSS API Designer component, if they are able to access its internal port.

In the vast majority of setups, this internal port can only be accessed by authenticated users of DSS. In some rare setups where this port is open, this would be accessible by non-authenticated users.

## Affected Products

  * Dataiku DSS 9 and older versions

  * Dataiku DSS 10 before 10.0.9

  * Dataiku DSS 11 before 11.0.3




## Fix

Dataiku DSS 10.0.9 and Dataiku DSS 11.0.3 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-012]

# Session credential disclosure

## Information

  * Advisory ID: DSA-2022-012

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * CVSS Base Score: 8.8 (High)

  * CWE classification: CWE-200




## Summary

It was discovered that a user’s internal session credential was mistakenly written to a location that can be obtained by attackers who have access to the same project as the victim. This could lead to account takeover.

## Affected Products

  * Dataiku DSS 9 and older versions

  * Dataiku DSS 10 before 10.0.9

  * Dataiku DSS 11 before 11.0.3




## Fix

Dataiku DSS 10.0.9 and Dataiku DSS 11.0.3 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-013]

# Insufficient access control to project variables

## Information

  * Advisory ID: DSA-2022-013

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N

  * CVSS Base Score: 4.3 (Medium)

  * CWE classification: CWE-200




## Summary

It was discovered that an endpoint allowing the read of project variables did not properly check for access to the project. This could lead to disclosure of sensitive information in project variables.

## Affected Products

  * Dataiku DSS 9 and older versions

  * Dataiku DSS 10 before 10.0.9

  * Dataiku DSS 11 before 11.0.3




## Fix

Dataiku DSS 10.0.9 and Dataiku DSS 11.0.3 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-014]

# Insufficient access control to projects list and information

## Information

  * Advisory ID: DSA-2022-014

  * CVSS String: CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N

  * CVSS Base Score: 4.3 (Medium)

  * CWE classification: CWE-200




## Summary

It was discovered that some DSS endpoints that could disclose the list of projects and some basic information about projects (such as number of datasets, recipes, …) did not perform sufficient access control. This could lead to disclosing the projects list to authenticated users.

## Affected Products

  * Dataiku DSS 9 and older versions

  * Dataiku DSS 10 before 10.0.9

  * Dataiku DSS 11 before 11.0.3




## Fix

Dataiku DSS 10.0.9 and Dataiku DSS 11.0.3 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-015]

# Insufficient access control in troubleshooting tools

## Information

  * Advisory ID: DSA-2022-015

  * CVSS String: CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N

  * CVSS Base Score: 4.3 (Medium)

  * CWE classification: CWE-200




## Summary

It was discovered that some internal troubleshooting tools in DSS did not perform sufficient access control, which could lead an attacker to introduce spurious entries in the runs list of a scenario

## Affected Products

  * Dataiku DSS 9 and older versions

  * Dataiku DSS 10 before 10.0.9

  * Dataiku DSS 11 before 11.0.3




## Fix

Dataiku DSS 10.0.9 and Dataiku DSS 11.0.3 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-016]

# Credentials disclosure through path traversal

## Information

  * Advisory ID: DSA-2022-016

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * CVSS Base Score: 8.8 (High)

  * CWE classification: CWE-23




## Summary

It was discovered that a path traversal issue could lead to the disclosure of sensitive information in the Dataiku configuration folder, including credentials.

## Affected Products

  * Dataiku DSS 9 and older versions

  * Dataiku DSS 10 before 10.0.9

  * Dataiku DSS 11 before 11.0.3




## Fix

Dataiku DSS 10.0.9 and Dataiku DSS 11.0.3 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-017]

# Cross-site-scripting through custom metric names

## Information

  * Advisory ID: DSA-2022-017

  * CVSS Base Score: 7.6

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:R/S:U/C:H/I:H/A:L

  * Severity: High

  * CWE classification: CWE-79




## Summary

In Dataiku DSS before 11.1.0, insufficient input sanitization could allow an authenticated attacker to cause a cross-site-scripting issue through custom metric names

## Affected Products

  * Dataiku DSS before 11.1.0




## Fix

Dataiku DSS 11.1.0 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-018]

# Cross-site-scripting through imported Jupyter notebooks

## Information

  * Advisory ID: DSA-2022-018

  * CVSS Base Score: 7.6

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:R/S:U/C:H/I:H/A:L

  * Severity: High

  * CWE classification: CWE-79




## Summary

In Dataiku DSS before 11.1.0, insufficient sanitization of imported Jupyter notebooks could allow an authenticated attacker to cause a cross-site-scripting issue through an imported Jupyter notebook

## Affected Products

  * Dataiku DSS before 11.1.0




## Fix

Dataiku DSS 11.1.0 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-019]

# Host blacklist bypass

## Information

  * Advisory ID: DSA-2022-019

  * CVSS Base Score: 8.1

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N

  * Severity: High

  * CWE classification: CWE-284




## Summary

In Dataiku DSS before 11.1.0, insufficient acces control could allow attackers to bypass the HTTP host blacklist

## Affected Products

  * Dataiku DSS before 11.1.0




## Fix

Dataiku DSS 11.1.0 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-020]

# Takeover of Jupyter notebooks

## Information

  * Advisory ID: DSA-2022-020

  * CVSS Base Score: 7.5

  * CVSS String: CVSS:3.0/AV:N/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H

  * Severity: High

  * CWE classification: CWE-284




## Summary

In Dataiku DSS before 11.1.0, insufficient acces control could allow an authenticated attacker to take control over another user’s Jupyter notebooks

## Affected Products

  * Dataiku DSS before 11.1.0




## Fix

Dataiku DSS 11.1.0 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-021]

# Missing authentication on internal API call

## Information

  * Advisory ID: DSA-2022-022

  * CVSS Base Score: 5.3

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-284




## Summary

In Dataiku DSS before 11.1.2, an API call listing meanings was not authenticated

## Affected Products

  * Dataiku DSS before 11.1.2




## Fix

Dataiku DSS 11.1.2 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-022]

# Cross-site-scripting through Jupyter notebooks

## Information

  * Advisory ID: DSA-2022-022

  * CVSS Base Score: 7.6

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:R/S:U/C:H/I:H/A:L

  * Severity: High

  * CWE classification: CWE-79




## Summary

In Dataiku DSS before 11.1.2, missing sandboxing of some API endpoints could lead to stored XSS through hostile notebooks

## Affected Products

  * Dataiku DSS before 11.1.2




## Fix

Dataiku DSS 11.1.2 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2022-023]

# Race condition on UIF can lead to account takeover

## Information

  * Advisory ID: DSA-2022-023

  * CVSS Base Score: 8.8

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * Severity: High

  * CWE classification: CWE-367




## Summary

It was discovered that a race condition [User Isolation](<../../user-isolation/index.html>) impersonated execution could lead to the ability for an attacker to take over another user’s UNIX account.

## Affected Products

  * Dataiku DSS before 11.1.4




## Fix

Dataiku DSS 11.1.4 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2023-001]

# Directory traversal via download action of file editor

## Information

  * Advisory ID: DSA-2023-001

  * CVSS Base Score: 8.8

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * Severity: High

  * CWE classification: CWE-35




## Summary

Before DSS 11.3.2, a directory traversal via the file editor’s download action could lead to arbitrary file access

## Affected Products

  * Dataiku DSS before 11.3.2




## Fix

Dataiku DSS 11.3.2 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2023-002]

# Directory traversal through git symlink support abuse

## Information

  * Advisory ID: DSA-2023-002

  * CVSS Base Score: 8.8

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * Severity: High

  * CWE classification: CWE-35




## Summary

It was discovered that when committing a symbolic link to the git repository of a project’s configuration, an attacker could then read files from outside that project configuration

## Affected Products

  * Dataiku DSS before 11.3.2




## Fix

Dataiku DSS 11.3.2 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2023-006]

# Insufficient access control on active web content via static insights

## Information

  * Advisory ID: DSA-2023-006

  * CVSS Base Score: 7.3

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:R/S:U/C:H/I:H/A:N

  * Severity: High

  * CWE classification: CWE-269




## Summary

It was discovered that a user who has privilege to write code but not privilege to write active web content could still cause active web content to be displayed to other users through the usage of static insights.

## Affected Products

  * Dataiku DSS before 12.1.1




## Fix

Dataiku DSS 12.1.1 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2023-007]

# Improper link resolution before file access

## Information

  * Advisory ID: DSA-2023-007

  * CVSS Base Score: 7.5

  * CVSS String: CVSS:3.0/AV:N/AC:H/PR:L/UI:N/S:U/C:H/I:H/A:H

  * Severity: High

  * CWE classification: CWE-59




## Summary

A user who has privileges to write code and leverage containerized execution could use symbolic links to gain access to restricted files.

## Affected Products

  * Dataiku DSS before 12.1.3




## Fix

Dataiku DSS 12.1.3 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2023-008]

# Improper privilege enforcement on project import

## Information

  * Advisory ID: DSA-2023-008

  * CVSS Base Score: 8.8

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * Severity: High

  * CWE classification: CWE-281




## Summary

A user who has privileges to import projects (or bundles on automation nodes) could execute an imported scenario as another user.

## Affected Products

  * Dataiku DSS before 12.1.3




## Fix

Dataiku DSS 12.1.3 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2023-009]

# Directory Traversal in cluster logs retrieval endpoint

## Information

  * Advisory ID: DSA-2023-009

  * CVSS Base Score: 4.9

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:H/UI:N/S:U/C:H/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-27




## Summary

Before DSS 12.3.2, a directory traversal via the cluster management interface could lead to arbitrary file access

## Affected Products

  * Dataiku DSS before 12.3.2




## Fix

Dataiku DSS 12.3.2 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2023-010]

# LDAP Authentication Bypass

## Information

  * Advisory ID: DSA-2023-010

  * CVE reference: CVE-2023-51717

  * CVSS Base Score: 9.8

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H

  * Severity: Critical

  * CWE classification: CWE-287

  * Advisory Release Date: Dec 21st, 2023 19:00 CET




## Summary

Before DSS 11.4.5 and 12.4.1, verification of credentials when authenticating with LDAP identity was insufficient.

Depending on the configuration of the LDAP server, this could lead to a full authentication bypass.

## Affected Products

Dataiku DSS before 11.4.5 and 12.4.1

## Affected Situations

Dataiku Cloud customers are not affected.

Only customers who have enabled LDAP support in DSS are affected.

Furthermore, to be affected, your LDAP server needs to be configured to allow “unauthenticated binds” (not to be confused with “anonymous binds”). This is a discouraged behavior as per LDAP specification, but is the default behavior of Microsoft Active Directory.

## Mitigation

Customers running DSS 12.1.0 or above, and who are using SSO in addition to LDAP (i.e., users are not authenticating to DSS through their LDAP password, but through SSO, and LDAP is only used for provisioning), can mitigate the issue by disabling “Allow user authentication” in the LDAP settings (Admin > Settings > User login & provisioning)

## Remediation

Dataiku DSS 12.4.1 has been made available to customers to remediate this issue.

In addition, for customers still running DSS 11, DSS 11.4.5 has been made available to remediate the issue.

## Acknowledgement

Dataiku would like to thank Christian Turri, consultant, for discovering and reporting the issue.

## Contact

E-mail: [security@dataiku.com](</cdn-cgi/l/email-protection#3c4f595f494e5548451a1f0f0b071a1f090e071a1f080407585d485d5557491a1f080a075f5351>)

## Last modified

Dec 22nd, 2023

## Timeline

  * Dec 20th, 2023: Issue reported to vendor

  * Dec 20th, 2023: Issue confirmed and acknowledged by vendor

  * Dec 21st, 2023: Fixed versions published and advisory published

  * Dec 22nd, 2023: CVE id assigned and added to the advisory

---

## [security/advisories/dsa-2023-026]

# Aborting scenarios with read-only permission on the project

## Information

  * Advisory ID: DSA-2023-026

  * CVSS Base Score: 4.3

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:N/A:L

  * Severity: Medium

  * CWE classification: CWE-285




## Summary

It was discovered that a user with read only permission on a project could abort scenario belonging to this project

## Affected Products

  * Dataiku DSS before 11.4.4




## Fix

Dataiku DSS 11.4.4 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2024-001]

# Improper preservation of “Run as” settings

## Information

  * Advisory ID: DSA-2024-001

  * CVSS Base Score: 8.8

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * Severity: High

  * CWE classification: CWE-281

  * Advisory Release Date: April 26th, 2024 19:00 CET




## Summary

Before DSS 12.6.1, a DSS user with ability to pull a project’s version history from an arbitrary remote could run a scenario/recipe as another arbitrary user.

## Affected Products

Dataiku DSS before 12.6.1

## Fix

Dataiku DSS 12.6.1 has been made available to customers to remediate this issue.

## Acknowledgement

Dataiku would like to thank Hugo Le Moine and Jean-Baptiste Priez, Data Scientists, for discovering and reporting the issue.

## Timeline

  * Apr 19th, 2024: Issue reported to vendor

  * Apr 19th, 2024: Issue confirmed and acknowledged by vendor

  * Apr 26th, 2024: Fixed version published and advisory published

---

## [security/advisories/dsa-2024-002]

# Improper logging of cleartext credentials

## Information

  * Advisory ID: DSA-2024-002

  * CVSS Base Score: 6.5

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-313

  * Advisory Release Date: April 26th, 2024 19:00 CET




## Summary

In DSS 12.6.0, the cleartext password/token of some SQL connections may be written in logs as cleartext.

## Affected Products

Dataiku DSS 12.6.0

## Fix

Dataiku DSS 12.6.1 has been made available to customers to remediate this issue.

## Timeline

  * Apr 19th, 2024: Issue discovered internally

  * Apr 26th, 2024: Fixed version published and advisory published

---

## [security/advisories/dsa-2024-003]

# Missing project permissions check when accessing LLM through API

## Information

  * Advisory ID: DSA-2024-003

  * CVSS Base Score: 6.5

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-862

  * Advisory Release Date: May 31st, 2024




## Summary

An authenticated user without access to a project could use the API to query LLMs of this project

## Affected Products

Dataiku DSS 12.3.0 to 12.6.3

## Fix

Dataiku DSS 12.6.3 has been made available to customers to remediate this issue.

---

## [security/advisories/dsa-2024-004]

# Missing authentication on get-global-tags-info endpoint

## Information

  * Advisory ID: DSA-2024-004

  * CVSS Base Score: 5.3

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-27

  * Advisory Release Date: May 31st, 2024




## Summary

Until DSS 12.6.3, the `/dip/api/global-tags/get-global-tags-info` endpoint did not require authentication

## Affected Products

Dataiku DSS before 12.6.3

## Fix

Dataiku DSS 12.6.3 has been made available to customers to remediate this issue.

---

## [security/advisories/dsa-2024-005]

# Insufficient permission checks in code envs API

## Information

  * Advisory ID: DSA-2024-005

  * CVSS Base Score: 6.5

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:H/A:N

  * Severity: Medium

  * CWE classification: CWE-284

  * Advisory Release Date: July 8th, 2024




## Summary

Until DSS 12.6.5, some code env API calls did not perform enough permission checks, which could allow authenticated-but-not-permissioned users to act on code envs through the API.

## Affected Products

Dataiku DSS before 12.6.5, and 13.0.0

## Fix

Dataiku DSS 12.6.5 and 13.0.1 have been made available to customers to remediate this issue.

---

## [security/advisories/dsa-2024-006]

# Directory traversal during DSS provisioning by Fleet Manager

## Information

  * Advisory ID: DSA-2024-006

  * CVSS Base Score: 5.3

  * CVSS String: CVSS:3.0/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-27

  * Advisory Release Date: August 26th, 2024




## Summary

Until DSS 13.1.1, a path traversal issue could briefly allow an attacker with access to a DSS instance being provisioned by Fleet Manager to read files accessible to the nginx user.

## Affected Products

Dataiku DSS before 13.1.1.

## Fix

Dataiku DSS 13.1.1 have been made available to customers to remediate this issue.

---

## [security/advisories/dsa-2025-001]

# Cross-site-scripting in Prepare recipe

## Information

  * Advisory ID: DSA-2025-001

  * CVSS Base Score: 8.8

  * CVSS String: CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H

  * Severity: High

  * CWE classification: CWE-79




## Summary

In Dataiku DSS before 13.4.0, improper sanitization could lead to stored XSS in the Prepare recipe

## Affected Products

  * Dataiku DSS before 13.4.0




## Fix

Dataiku DSS 13.4.0 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2025-002]

# Incorrect type validation in image preview

## Information

  * Advisory ID: DSA-2025-002

  * CVSS Base Score: 7.6

  * CVSS String: CVSS:3.1/AV:N/AC:L/PR:L/UI:R/S:U/C:H/I:H/A:L

  * Severity: High

  * CWE classification: CWE-1287




## Summary

In Dataiku DSS before 13.5.0, improper type validation could lead to stored XSS when previewing an image stored in a managed folder

## Affected Products

  * Dataiku DSS before 13.5.0




## Fix

Dataiku DSS 13.5.0 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2025-003]

# XSS in Sanity Checks

## Information

  * Advisory ID: DSA-2025-003

  * CVSS Base Score: 7.6

  * CVSS String: CVSS:3.1/AV:N/AC:L/PR:L/UI:R/S:U/C:H/I:H/A:L

  * Severity: High

  * CWE classification: CWE-79




## Summary

In Dataiku DSS before 13.5.4, improper sanitization could lead to a stored XSS when displaying some sanity checks

## Affected Products

  * Dataiku DSS before 13.5.4




## Fix

Dataiku DSS 13.5.4 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2025-004]

# Unauthenticated Denial of Service

## Information

  * Advisory ID: DSA-2025-004

  * CVSS Base Score: 7.5

  * CVSS String: AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H

  * Severity: High

  * CWE classification: CWE-770




## Summary

In Dataiku DSS before 13.5.4, unauthenticated attackers could cause a Denial of Service by sending specifically-crafted malformed requests.

## Affected Products

  * Dataiku DSS before 13.5.4




## Fix

Dataiku DSS 13.5.4 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2025-005]

# Improper Access Control on “Copy subflow” action

## Information

  * Advisory ID: DSA-2025-005

  * CVSS Base Score: 4.3

  * CVSS String: AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:L/A:N

  * Severity: Medium

  * CWE classification: CWE-284




## Summary

In Dataiku DSS before 13.5.5, a user could use “copy subflow” action to write on a project if he has read-only access on it

## Affected Products

  * Dataiku DSS before 13.5.5




## Fix

Dataiku DSS 13.5.5 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2025-006]

# Improper logging of cleartext credentials

## Information

  * Advisory ID: DSA-2025-006

  * CVSS Base Score: 4.3

  * CVSS String: AV:N/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-313




## Summary

In Dataiku DSS 14 before 14.1.0 and Dataiku DSS 13 before 13.5.7, the Hugging Face token was printed in the job log when running a fine-tuning recipe locally (not in a container) on a Hugging Face local LLM.

## Affected Products

  * Dataiku DSS 14 before 14.1.0

  * Dataiku DSS 13 before 13.5.7




## Fix

Dataiku 14.1.0 and 13.5.7 have been made available to customers to remediate this issue

---

## [security/advisories/dsa-2025-007]

# Improper display of cleartext API Node API key in API service history tab

## Information

  * Advisory ID: DSA-2025-007

  * CVSS Base Score: 2.7

  * CVSS String: AV:N/AC:L/PR:H/UI:N/S:U/C:L/I:N/A:N

  * Severity: Low

  * CWE classification: CWE-532




## Summary

In Dataiku DSS before 14.1.1, a Dataiku deployer user could see a cleartext API node API key in the API service history tab

## Affected Products

  * Dataiku DSS before 14.1.1




## Fix

Dataiku 14.1.1 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2025-008]

# Time-of-Check / Time-of-Use issue in UIF mechanism

## Information

  * Advisory ID: DSA-2025-008

  * CVSS Base Score: 4.1

  * CVSS String: CVSS:3.1/AV:L/AC:H/PR:H/UI:N/S:U/C:N/I:H/A:N

  * Severity: Medium

  * CWE classification: CWE-367




## Summary

In Dataiku DSS before 14.2.0, a TOCTOU vulnerability could allow Dataiku administrators to escalate privileges on the underlying Linux OS. Only administrators could leverage the issue.

## Affected Products

  * Dataiku DSS before 14.2.0




## Fix

Dataiku 14.2.0 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2025-009]

# Improper identity propagation allowing data source impersonation

## Information

  * Advisory ID: DSA-2025-009

  * CVSS Base Score: 8.8

  * CVSS String: CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N

  * Severity: High

  * CWE classification: CWE-639




## Summary

In Dataiku DSS before 14.2.3, improper handling of variables could allow an attacker to forge the identity used for connecting to data sources.

## Affected Products

  * Dataiku DSS before 14.2.3




## Fix

Dataiku 14.2.3 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2026-001]

# Improper Limitation of a Pathname to a Restricted Directory

## Information

  * Advisory ID: DSA-2026-001

  * CVSS Base Score: 6.5

  * CVSS String: CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-22




## Summary

In Dataiku DSS before 14.3.2, when granting the Personal Connections right to some users, a user could leverage the Private Key parameter of a Snowflake or GCP connection to read the content of a file.

## Affected Products

  * Dataiku DSS before 14.3.2




## Fix

Dataiku 14.3.2 has been made available to customers to remediate this issue. From this version, keys can be restricted to a list of paths/globs configured by adminstrators.

---

## [security/advisories/dsa-2026-002]

# Improper logging of cleartext credentials

## Information

  * Advisory ID: DSA-2026-002

  * CVSS Base Score: 5.4

  * CVSS String: CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:L/I:L/A:N

  * Severity: Medium

  * CWE classification: CWE-313




## Summary

In Dataiku DSS before 14.3.2, a Sharepoint access token was printed in the job logs when running a recipe, and in backend logs accessible by administrators.

## Affected Products

  * Dataiku DSS from 13.0.0, before 14.3.2




## Fix

Dataiku 14.3.2 has been made available to customers to remediate this issue

---

## [security/advisories/dsa-2026-003]

# Exposure of sensitive Webapp information to Webapp read-only user

## Information

  * Advisory ID: DSA-2026-003

  * CVSS Base Score: 4.3

  * CVSS String: CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N

  * Severity: Medium

  * CWE classification: CWE-200




## Summary

In Dataiku DSS before 14.4.1, a user with read only access to the webapp and not the underlying project could leverage /webapps/get-summary to get access to webapp logs and config.

## Affected Products

  * Dataiku DSS before 14.4.1




## Fix

Dataiku 14.4.1 has been made available to customers to remediate this issue.

---

## [security/advisories/dsa-2026-004]

# Improper flow zone name sanitization

## Information

  * Advisory ID: DSA-2026-004

  * CVSS Base Score: 8.8

  * CVSS String: CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H/IR:L

  * Severity: High

  * CWE classification: CWE-79




## Summary

In Dataiku DSS before 14.5.1, improper sanitization could lead to a stored XSS when displaying flow zone

## Affected Products

  * Dataiku DSS before 14.5.1




## Fix

Dataiku 14.5.1 has been made available to customers to remediate this issue.

---

## [security/audit-trail]

# Audit Trail

DSS includes an audit trail that logs all actions performed by the users, with details about user id, timestamp, IP address, authentication method, …

For more details, please see [Audit trail](<../operations/audit-trail/index.html>)

---

## [security/authentication/azure-ad]

# Azure AD

Note

DSS Azure AD implementation is only a User Supplier. See [Authentication](<index.html>) documentation for more details.

The DSS Azure AD User Supplier allows the provisioning or synchronization of Azure AD users in DSS. However, it is important to note that the DSS Azure AD User Supplier cannot authenticate users, as it is not possible to retrieve user passwords from Azure AD or authenticate users using the Azure AD API.

To authenticate users, it is necessary to combine the DSS Azure AD User Supplier with another authentication method, such as SSO.

## Configuration

DSS connects to Azure AD using OAuth2, using either a secret or a certificate.

### Azure portal

In your company’s Azure AD portal, follow these steps:

  * Go to your Azure Active Directory > App registrations

  * Create a new application dedicated to DSS, with no redirect URI specified (DSS uses the client credential flow to connect to Azure AD).

  * Add the required credentials (secrets or certificates) in the application settings. DSS supports both types.

  * Grant the following Application permissions in the API permissions section:
    
    * Microsoft Graph -> Group.Read.All

    * Microsoft Graph -> User.Read.All




Make sure to note down the tenant ID, client ID, client secret, or certificates, as these will be needed for the DSS configuration.

### DSS security settings

In DSS in the Settings > Security & Audit > User login & provisioning > Azure AD section:

  * Enable Azure AD

  * Depending on your requirements, choose to [enable user provisioning, user synchronization, or both](<index.html#synchronizing-user-attributes>).




#### Connection credential

  * Select the credential mode:
    
    * Secret if you configured the Azure application to use a client secret as a credential

    * Certificate if you configured the Azure application to use a certificate as a credential

  * Fill in the other values in the “credential” section as per the Azure portal configuration. These values should be self-explanatory.




#### User Mapping

  * User query filter: Specify the Azure AD query for the /users endpoint, which DSS will use to find users matching the specified identity. You can use simple queries like mail eq ‘$email’, userPrincipalName eq ‘$login’, startsWith(userPrincipalName,’$login’), or startsWith(mail,’$login’). You can test your query using cURL commands or directly in the DSS UI’s testing mode.

  * Groups restriction: If this list is not empty, only users who are members of one of these groups in Azure will be authorized to connect to the DSS instance.




#### On-Demand Provisioning

  * Allow on-demand provisioning: When enabled, a new view is added to the administration security settings, allowing you to fetch Azure AD users before provisioning/synchronizing them. On-demand provisioning is only available for admin users.

  * Login attribute: This is the Azure AD user attribute used as the username for the newly provisioned user.

  * Login remapping rules: The Azure AD login attribute may require remapping before being used as a DSS username. You can define remapping rules as search-and-replace Java regular expressions. Use `(...)` to capture substrings and `$1`, `$2`, etc., to insert the captured substrings in the output. The rules are applied in order, with each rule operating on the output of the previous one.




#### User Profiles

  * Group → profile mapping: Define a mapping from Azure AD group names to DSS user profiles. The rules are evaluated in order until a match is found.

  * Default user profile: This is the default profile assigned to any new user if no profile can be computed from their groups. See [Mapping profiles and groups](<index.html#mapping-profiles-and-groups>).




#### Testing

The testing section provides a way to simulate the identity and check the DSS Azure AD User supplier results. The simulation results will also show the computed DSS groups, allowing you to verify that a user will be assigned to the expected DSS groups.

#### Permissions

  * Azure AD groups readable by: this setting, if set to the option Everybody, allows all users, who run the list access recipe, to access the mappings between Azure AD groups and DSS groups defined by DSS admins.




## Troubleshooting

If you encounter any problems configuring AzureAD in DSS, you can manually check your Azure AD configuration. Note that the following testing instructions only apply to the client secret authentication method.

Follow these steps:

  * Create an access token using the provided cURL command.



    
    
    curl --location --request POST 'https://login.microsoftonline.com/$YOUR_TENANT_ID/oauth2/v2.0/token' \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data-urlencode 'grant_type=client_credentials' \
    --data-urlencode 'scope=https://graph.microsoft.com/.default' \
    --data-urlencode 'client_id=$YOUR_CLIENT_ID' \
    --data-urlencode 'client_secret=$YOUR_CLIENT_SECRET'
    

If your application is properly set up, you should receive a successful response with an access token.
    
    
    {
        "token_type": "Bearer",
        "expires_in": 3599,
        "ext_expires_in": 3599,
        "access_token": "AZURE_ACCESS_TOKEN"
    }
    

Verify the roles in the access token payload by introspecting it using <https://jwt.io/>. You should see the roles in the payload:
    
    
    {
        "roles": [
            "Group.Read.All",
            "User.Read.All"
        ]
    }
    

To confirm that your access token has indeed the permissions to read users and groups, you can try the following requests:
    
    
    curl --location --request GET 'https://graph.microsoft.com/v1.0/users?$filter=mail eq '\''[[email protected]](</cdn-cgi/l/email-protection>)'\''' \
    --header 'Authorization: Bearer $AZURE_ACCESS_TOKEN'
    

You should be able to query users, with a typical response looking like:
    
    
    {
        "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users",
        "value": [
            {
                "businessPhones": [],
                "displayName": "Alice Doe",
                "givenName": null,
                "jobTitle": null,
                "mail": "[[email protected]](</cdn-cgi/l/email-protection>)",
                "mobilePhone": null,
                "officeLocation": null,
                "preferredLanguage": null,
                "surname": null,
                "userPrincipalName": "alice",
                "id": "ee0a9719-5dd0-46a1-93de-cad4455f2863"
            }
        ]
    }
    

You can test the group permissions by querying the groups for a given user:
    
    
    curl --location --request GET 'https://graph.microsoft.com/v1.0/users/e0a9719-5dd0-46a1-93de-cad4455f2863/memberOf/microsoft.graph.group' \
    --header 'Authorization: Bearer $AZURE_ACCESS_TOKEN'
    

You should see the groups for this user, with a typical response looking like:
    
    
    {
        "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#groups",
        "value": [
            {
                "id": "b2771f37-441f-4485-7b78-cfeeed03cd8b",
                "deletedDateTime": null,
                "classification": null,
                "createdDateTime": "2021-11-03T15:26:08Z",
                "creationOptions": [],
                "description": null,
                "displayName": "group_a",
                "expirationDateTime": null,
                "groupTypes": [],
                "isAssignableToRole": null,
                "mail": null,
                "mailEnabled": false,
                "mailNickname": "group_a",
                "membershipRule": null,
                "membershipRuleProcessingState": null,
                "onPremisesDomainName": null,
                "onPremisesLastSyncDateTime": null,
                "onPremisesNetBiosName": null,
                "onPremisesSamAccountName": null,
                "onPremisesSecurityIdentifier": null,
                "onPremisesSyncEnabled": null,
                "preferredDataLocation": null,
                "preferredLanguage": null,
                "proxyAddresses": [],
                "renewedDateTime": "2021-11-03T15:26:08Z",
                "resourceBehaviorOptions": [],
                "resourceProvisioningOptions": [],
                "securityEnabled": true,
                "securityIdentifier": "S-1-12-1-eeee-1132807199-eeee-333",
                "theme": null,
                "visibility": null,
                "onPremisesProvisioningErrors": []
            }
        ]
    }

---

## [security/authentication/custom]

# Custom Authenticator and/or User Supplier

While DSS provides support for various authenticators and user suppliers, there may be cases where you require a more customized solution to meet your specific needs. DSS offers the flexibility to extend its capabilities by implementing your own custom authenticators and user suppliers.

Custom authenticators and user suppliers are Java components that can be packaged as DSS plugins. This allows for easy installation on multiple instances and sharing through the DSS plugin market.

To create a custom authenticator and/or user supplier, you can either create a new plugin or extend an existing one. You have the option to create a component that serves as:

  * Authenticator: Supports user authentication only.

  * User supplier: Provides user information to DSS only.

  * Authenticator and User supplier: Supports both user authentication and user information supply to DSS.




Please note that DSS currently does not support multiple custom user suppliers.

Once you have created the component that suits your requirements, you will need to define a new Java class within your plugin. The Java interface Javadoc should provide sufficient guidance from this point onward.

## Packaging the plugin

Since the plugin components are written in Java, the source code needs to be compiled into a .jar library. To accomplish this, you will need Apache Ant. After compilation, the DSS backend must be restarted.

To package the plugin, follow these steps:

  1. Navigate to the plugin directory where the build.xml file is located (e.g. $DSS_HOME/plugins/).

  2. Execute the ant jar command to create a .jar file in the java-lib directory.




Once the plugin is packaged, it can be shared with others, and you won’t need to rebuild the .jar file. It will be bundled within the plugin itself.

## DSS security settings

In DSS, go to Settings > Security & Audit > User login & provisioning > Custom authenticator and supplier section and perform the following steps:

  * Enable the Custom authenticator and supplier feature.

  * Specify the full class name of your custom authenticator in the Custom user authenticator full class name field, for example, com.example.MyCustomAuthenticator.

  * Specify the full class name of your custom user supplier in the Custom user supplier full class name field, for example, com.example.MyCustomUserSupplier.

  * Restart DSS for the changes to take effect.

---

## [security/authentication/index]

# Authentication

This section provides an overview of Identity Access Management (IAM) concepts in Dataiku DSS.

## Authentication and user provisioning

In Dataiku DSS, authentication and user provisioning are two separate processes.

Authentication is the process of verifying a user’s identity and granting access to the system. It involves validating username/password credentials and returning the user’s identity.

User provisioning, on the other hand, is the process of retrieving a user matching this identity from an external source (LDAP, Azure AD, a custom database…) and creating or synchronizing the corresponding user in DSS. It ensures that the user’s information and access privileges are correctly mapped within the system.

For example, you can enforce users to log in with Single Sign-On (SSO) while synchronizing their user data from an LDAP server. In this scenario, SSO serves as the authenticator, and LDAP acts as the user supplier.

User synchronization is the process of applying changes that happened on the identity of the user in the external source, to the matching user in DSS.

User synchronization and provisioning can happen automatically at login time, or on-demand by an admin either through the user interface or the public API.

## Supported authenticators and user suppliers

Dataiku DSS supports the following authenticators and user suppliers. If the authenticator or user supplier you require is not listed, you can submit a feature request or contribute a [custom authenticator/user supplier through a plugin](<custom.html>).

### Authenticators

  * Local: Allows users to log in using username/password credentials stored directly in DSS.

  * SSO: Delegates authentication to an identity manager using the SAML or OpenID Connect protocols.

  * LDAP: Enables users to log in using username/password credentials stored in an LDAP server.

  * PAM: Enables users to log in using username/password credentials via PAM (Pluggable Authentication Modules).

  * Custom: Provides the flexibility to create a custom authenticator to authenticate users using username/password credentials.




### User suppliers

  * SSO: The chosen SSO protocol returns an identity (ID token, SAML assertion, etc.) from the SSO authenticator which is used to provision or synchronize the user in DSS during login.

  * LDAP: Fetches the user information from the LDAP server and provisions/synchronizes it as a DSS user.

  * Azure AD: Fetches the user information from Azure AD and provisions/synchronizes it as a DSS user.

  * PAM: Limited functionality; PAM can only provision/synchronize a user with the username information, and only for users authenticated using PAM.

  * Custom: Allows the creation of a custom user supplier to convert the identity obtained during authentication into a DSS user.




## Mapping profiles and groups

When a user is provisioned or synchronized to DSS, their profile is determined based on the “User profiles” settings of the user supplier it originates from.

  * You can define a mapping for each group in your external source to a corresponding Dataiku DSS profile.

  * A default user profile must be defined.




The user profile is determined as follows: for each external group the user belongs to, DSS retrieves the corresponding profile mapping (if any) as well as the default profile. The user is assigned the profile that is listed first in the license, typically corresponds to the profile with the highest privileges.

Similarly, a user can be automatically added to DSS groups using group mappings. Group mappings are configured in DSS under “Administration” > “Security” > “Groups”.

The “Type” specifies the source of the external group, and the list of groups (e.g. LDAP groups) is a list of external groups. If a user belongs to an external group that has a group mapping, they will be automatically added to the corresponding DSS group.

## Synchronizing user attributes

User attribute synchronization can be enabled during login and as an on-demand option through the user interface.

To manually synchronize all external users, navigate to the users management screen (Administration > Security > Users) and click the SYNC ALL button.

To synchronize a specific user, go to their user profile page and click the SYNC button next to their Type.

Note

Only user suppliers capable of fetching a user from its identity support on-demand synchronization. For example, the SSO supplier does not allow manual synchronization and only synchronizes users during login.

You can choose which user attributes to synchronize by configuring the following settings:

In this section, you can also choose which action should be triggered when a user is either not present in the external source or not in the authorized groups anymore. Add a warning in the logs will stop the user from authenticating but won’t affect any existing API key that the user may have created. On the contrary, Disable user in DSS will alter the user and make sure all the associated API keys won’t pass the authorization phase anymore.

## Advanced functionalities

### Supporting multiple authenticators and user suppliers

Dataiku DSS offers the flexibility to configure multiple authenticators and user suppliers, allowing you to accommodate users from different user stores. When setting up multiple sources, the order of authenticators and user suppliers becomes significant, especially when a user exists in multiple sources.

To manage the order of authenticators and user suppliers, you can configure the security settings in the general-settings.json file. By default, the order in DSS is as follows: Local > LDAP > Azure AD > SSO > PAM > Custom.

When a user attempts to connect to DSS for the first time, they need to be provisioned. DSS goes through the authenticators and user suppliers in the specified order and creates a DSS user associated with the appropriate source.

Warning

Once a DSS user is associated with a given source, DSS will only try this source to synchronize the user. Changing the source is manual.

### Example scenarios

Let’s consider a setup with the following configurations:

Setup:

  * Single Sign-On (SSO) is configured using the OpenID protocol with Google as the identity provider.

  * SSO provisioning is enabled.

  * LDAP is configured, and LDAP authentication is enabled.

  * Azure AD is configured as well.

  * The LDAP server contains a user named alice.

  * The Azure AD server contains a user named bob.

  * There is a user named charlie with a Google account, but this user is not present in LDAP or Azure AD.




#### Situation 1: Alice connects to DSS

  * Alice connects using SSO.

  * DSS trusts the identity provided by SSO.

  * As DSS does not find a user named alice among its local users, it triggers the provisioning process.

  * DSS proceeds with the user suppliers, starting with LDAP (following the order specified).

  * LDAP successfully retrieves a user named alice.

  * DSS creates a DSS user named alice with the LDAP source type.




From this point on, Alice can connect to DSS either with SSO or LDAP since LDAP authentication is enabled. If you want to enforce Alice to use SSO exclusively, you can disable authentication for LDAP. DSS will synchronize Alice’s user with LDAP during each login and will not attempt to synchronize with Azure AD, even if Alice exists in Azure AD.

#### Situation 2: Bob connects to DSS

  * Bob connects using SSO.

  * DSS trusts the identity provided by SSO.

  * As DSS does not find a user named bob, it triggers the provisioning process.

  * DSS proceeds with the user suppliers, starting with LDAP (following the order specified).

  * LDAP does not find a user named bob.

  * DSS moves on to the next user supplier, which is Azure AD.

  * Azure AD successfully retrieves a user named bob.

  * DSS creates a DSS user named bob with the AZURE_AD source type.




As the DSS implementation for Azure AD only supports user supplying, Bob can only connect to DSS using SSO.

#### Situation 3: Charlie connects to DSS

  * Charlie connects using SSO.

  * DSS trusts the identity provided by SSO.

  * As DSS does not find a user named charlie, it triggers the provisioning process.

  * DSS proceeds with the user suppliers, starting with LDAP (following the order specified).

  * LDAP does not find a user named charlie.

  * DSS moves on to the next user supplier, which is Azure AD.

  * Azure AD does not find a user named charlie.

  * DSS moves on to the next user supplier, which is SSO.

  * SSO successfully returns a user named charlie using the identity returned during the SSO protocol.

  * DSS creates a DSS user named charlie with the SSO source type.




From now on, Charlie can only connect with SSO. Even if a user named charlie is created in Azure AD, DSS will not attempt to synchronize with Azure AD. To synchronize charlie with Azure AD, you would need to manually change the source type of the DSS user charlie to Azure AD.

---

## [security/authentication/ldap]

# Configuring LDAP authentication

Note

LDAP authentication is a license-controlled feature.

Note

DSS LDAP implementation is an Authenticator and a User Supplier. See [Authentication](<index.html>) documentation for more details.

Data Science Studio can authenticate users against an external LDAP directory in addition to its built-in user database. Most corporate directories provide LDAP authentication service, including Microsoft Active Directory. This enables integration of user and password management, as well as user rights assignment, with existing centrally-managed infrastructures.

To configure LDAP authentication, you first need to gather and provide technical information about your directory service (see Connecting to a LDAP directory):

  * Basic connection information to your LDAP server (host name and port, credentials, connection security).

  * A filter (LDAP query template) defining the subset of your directory corresponding to users authorized to access this DSS instance.

  * Optionally, another filter defining the groups to which a given user belongs, in order to further restrict login authorization (only members of these groups being authorized to access this DSS instance) or to define user rights within DSS.




You can then choose to have Data Science Studio automatically import valid LDAP user accounts on first login, or disable this feature and create DSS accounts for specific LDAP users only (see Managing users):

  * when automatic provisioning is enabled (the default): once a DSS administrator has configured LDAP user mapping and authorization information as defined above, any LDAP user account matching the filter and authorization groups can access this DSS instance using his/her LDAP username and password, without further intervention of the administrator.

  * if disabled: a DSS administrator configures LDAP user mapping and authorization information as defined above, and individually creates in DSS the user accounts which should be mapped to the LDAP directory. The corresponding users may then access this DSS instance using their LDAP username and password.

  * In both cases, deleting or disabling an account in the LDAP directory automatically disables the corresponding DSS account.




It is possible to assign a user profile for newly imported users. You can also set this parameter per group (see Managing groups)

You can finally define DSS groups which are automatically mapped to LDAP groups (see Managing groups), or add LDAP users to locally-defined DSS groups. These groups control user access to DSS administrative rights, as well as their access level to DSS projects (read-only, read-write, or no access). Changing group membership in the LDAP directory automatically updates the corresponding DSS access rights on next login.

When LDAP authentication is enabled, the login sequence to Data Science Studio is the following:

  * A user enters his/her username and password on Data Science Studio login page.

  * If the username is found in the DSS account database and is of type LOCAL, the provided password is validated against the local database password.

  * If the username is found in the DSS account database and is of type LDAP, or if the username is not found in the DSS account database and automatic account import is enabled, a corresponding LDAP user is searched in the directory using the configured filter.

    * if the LDAP user is found, its LDAP groups are searched in the directory using the configured group filter if any. Access is denied if the user is not found, or if authorization groups are configured and the user is a member of none.

    * the provided password is validated against the LDAP directory.

    * a new DSS account for this user is created if needed, initialized with information from the directory. Otherwise, DSS group membership information for this user is updated as needed to reflect current LDAP group membership for this user.




## Connecting to a LDAP directory

To configure the connection to the LDAP directory:

  * Go to the “Administration > Settings” page.

  * Select “User login & provisioning” on the left hand column.

  * Check the “Enable” check box on top of the LDAP section.

  * Configure the required parameters as described below.

  * You can test these parameters at any time using the “Test” button.

  * Click on the “Save” button at the bottom of the left-hand column when done, or navigate out of the settings page to cancel.

  * Optionally, configure DSS groups mapped to LDAP groups (see Managing groups).

  * Optionally, manually configure DSS users mapped to LDAP users (see Managing users).




Warning

You must be logged to DSS with administrator privileges.

### Connection parameters

Name | Description  
---|---  
LDAP server URL | Defines the LDAP server to query, using syntax: `ldap[s]://HOST[:PORT]/BASE` This parameter is mandatory.  
Use TLS | Use StartTLS command to secure LDAP connection. Valid for ldap url only, not ldaps.  
Bind DN | If the LDAP server requires authentication, specifies the DN to use for queries. If empty, DSS queries the LDAP server using anonymous bind.  
Bind password | If the LDAP server requires authentication, specifies the password to use for queries, along with the Bind DN above. Mandatory if a Bind DN is specified.  
  
  * The scheme of the server URL may be <ldap://> to query the server using LDAP, or ldaps:// to query the server using LDAP over SSL (see Using secure LDAP connections).

  * The HOST part of the server URL specifies the hostname or IP address of the server to query. This part is mandatory.

  * The PORT part of the server URL specifies an optional non-default network port. Default is 389 for <ldap://> URLs and 636 for ldaps:// URLs.

  * The BASE part of the server URL specifies the search base DN (Distinguished Name) to use for user and group queries. This part is mandatory. A valid URL would be for example: `ldap://ldap1.company.com/OU=France,DC=company,DC=com`

  * If “Use TLS” is enabled, the connection to the server will be secured using TLS encryption before sending queries. The server must support the “Start TLS” extension (see Using secure LDAP connections).

  * If the LDAP server allows anonymous binding, you can leave the “Bind DN” and “Bind password” fields empty. Otherwise, they specify credentials that DSS should use to authenticate with the LDAP server before sending queries.

  * Note that DSS uses simple bind authentication when talking to the LDAP server, both to authenticate itself using the above credentials, and to verify user passwords. To avoid clear-text passwords being sent on the network, it is **strongly suggested** to use a secure channel between DSS and the LDAP server. Additional setup may be necessary in this case, see Using secure LDAP connections.




### User mapping parameters

Name | Description  
---|---  
User filter by username | LDAP query template to use when searching a given username in the directory. This field is mandatory, and should be a valid LDAP query where the name to search is represented by `{USERNAME}`. This placeholder will be replaced by the username entered by the user on the DSS login page. Upon success, this query should return exactly one LDAP object, representing the user in the directory.  
Display name attribute | Optional attribute containing the user’s full name (First Last) in the directory. If specified, this attribute is retrieved to initialize the full name field of the DSS user account when a LDAP account is automatically imported.  
Email attribute | Optional attribute containing the user’s email in the directory. If specified, this attribute is retrieved to initialize the email field of the DSS user account when a LDAP account is automatically imported.  
  
  * Refer to LDAP directory configuration templates for typical values of the above parameters in common setups.




### Group mapping parameters

Name | Description  
---|---  
Enable group support | When enabled, DSS fetches the list of groups that the user belongs to from the directory using the parameters below. Otherwise, group-based authorization and LDAP group mapping are disabled.  
Group filter by username | LDAP query template to use when searching the list of groups for a given user in the directory. This field is mandatory when group support is enabled. It should be a valid LDAP query where the user being looked up is represented by the `{USERNAME}` and/or `{USERDN}` placeholders. `{USERNAME}` is replaced by the username entered by the user on the DSS login page. `{USERDN}` is replaced by the LDAP Distinguished Name (DN) of the user object returned by the “User filter” query above. This query should return the list of LDAP group objects of which the user is a member.  
Group name attribute | Name of the group object attribute containing the group name in the directory. This field is mandatory when group support is enabled. It is the value of this attribute which is then subsequently matched to the “Authorized groups” access list below, or when mapping LDAP groups to DSS groups.  
Groups restriction | List of LDAP group names, as returned by the “group filter” query fetching the “group name attribute” above. Only users which are member of one of these groups are then authorized to connect to this DSS instance. If this field is empty, no group-based authorization is performed. All LDAP users returned by the “User filter” query above can connect to this DSS instance.  
  
  * Refer to LDAP directory configuration templates for typical values of the above parameters in common setups.




### On-demand provisioning

Name | Description  
---|---  
Allow on-demand provisioning | When enabled, a new view is added to the administration security settings, allowing you to fetch the LDAP users before provisioning/syncing them. Provisioning users is also possible via the Public API. Note that on-demand provisioning is only available for admin users.  
All users filter | This is the LDAP query used by DSS to fetch all the LDAP users used by the external users DSS UI view.  
Username attribute | This is the LDAP attribute used as the username for the newly provisioned user.  
Login remapping rules | The LDAP username attribute may require remapping before being used as a DSS username, such as user email. These rules are defined as search-and-replace Java regular expressions. Use `(...)` to capture substrings and `$1`, `$2`, etc., to insert the captured substrings in the output. The rules are applied in order, with each rule operating on the output of the previous one.  
All groups filter | This is the LDAP query used by DSS to fetch all the LDAP groups used by the external users DSS UI view.  
Group membership attribute | This is the LDAP attribute of an LDAP group that contains the user membership information.  
Group membership user attribute | This is the LDAP attribute of an LDAP user that is used as a reference for the “group membership attribute”. DSS uses both the “group membership attribute” and this attribute to map users to groups.  
  
  * Refer to LDAP directory configuration templates for typical values of the above parameters in common setups.




Note

In both cases, DSS users mapped to LDAP accounts can be added / edited / deleted using the user management dialog described in Managing users. Note however that if the automatic import of users is enabled, deleting a DSS account does not prohibit a user to connect, as their account will be recreated on next login.

## LDAP directory configuration templates

The following tables show reference configuration templates for LDAP connection parameters in common setups.

### Standard LDAP directory using RFC2307 schema

Parameter | Value  
---|---  
User filter | (&(objectClass=posixAccount)(uid={USERNAME}))  
Display name | cn  
Email | mail  
Group filter | (&(objectClass=posixGroup)(memberUid={USERNAME}))  
Group name | cn  
All users filter | (objectClass=posixAccount)  
Username attribute | uid  
All groups filter | (objectClass=posixGroup)  
Group membership attribute | memberUid  
Group membership user attribute | UID  
  
### Standard LDAP directory using RFC2307bis schema

This is the most frequently encountered case when connecting to Unix-based LDAP directories:

Parameter | Value  
---|---  
User filter | (&(objectClass=posixAccount)(uid={USERNAME}))  
Display name | cn  
Email | mail  
Group filter | (&(objectClass=posixGroup)(member={USERDN}))  
Group name | cn  
All users filter | (objectClass=posixAccount)  
Username attribute | uid  
All groups filter | (objectClass=posixGroup)  
Group membership attribute | member  
Group membership user attribute | DN  
  
### Microsoft Active Directory

Parameter | Value  
---|---  
User filter | (&(objectClass=user)(sAMAccountName={USERNAME}))  
Display name | displayName  
Email | mail  
Group filter | (&(objectClass=group)(member={USERDN}))  
Group name | cn  
All users filter | (objectClass=user)  
Username attribute | sAMAccountName  
All groups filter | (objectClass=group)  
Group membership attribute | member  
Group membership user attribute | DN  
  
Note

Starting with Windows 2003 SP2, Active Directory servers can also resolve nested group membership using the following query for the group filter:

> (&(objectClass=group)(member:1.2.840.113556.1.4.1941:={USERDN}))

### RedHat Identity Management and FreeIPA servers

Parameter | Value  
---|---  
User filter | (&(objectClass=posixAccount)(uid={USERNAME}))  
Display name | displayName  
Email | mail  
Group filter | (&(objectClass=groupOfNames)(member={USERDN}))  
Group name | cn  
All users filter | (objectClass=posixAccount)  
Username attribute | uid  
All groups filter | (objectClass=groupOfNames)  
Group membership attribute | member  
Group membership user attribute | DN  
  
Note

These servers also expose a RFC2307bis-compatible view of the directory in the LDAP subtree rooted at “cn=accounts”.

## Using secure LDAP connections

Except in configurations where you closely control the network path between DSS and the LDAP server (or in configurations where DSS and the LDAP server are installed on the same host), it is highly recommended to use secure connections to the LDAP server, to avoid clear-text passwords being exposed to potential network eavesdroppers.

Depending on your LDAP server, there are two possible ways to configure this:

  * use the non-standard but widely available LDAPS protocol (LDAP over SSL) where the client connects to the server on a network port dedicated to secure connections (default port: 636).

DSS uses this connection mode when you configure an URL with scheme ldaps://.

  * use the “Start TLS” standard protocol extension, where the client connects to the server using a normal (clear-text) LDAP connection on the standard port (default port: 389) but negotiates the establishement of a secure SSL channel over this connection before sending sensitive data through it.

DSS uses this connection mode when you configure an URL with scheme <ldap://> and check the “Use TLS” checkbox.




In both cases, this secure connection is only established if the LDAP client (here: Data Science Studio) can validate the identity of the LDAP server, to avoid sending sensitive user passwords to a rogue server. In particular, the Java runtime system used by Data Science Studio must be configured to trust the certificate of the LDAP server.

If your LDAP server certificate has been signed by a well-known certificate authority such as Verisign, you have nothing to do since the certificate authority’s root certificate is already in the default truststore used by the Java runtime. Otherwise, you will need to obtain the root certificate of the certificate authority which issued the certificate of your LDAP server, and add it to the truststore of the Java runtime used by DSS, using one of the procedures documented at [Adding SSL certificates to the Java truststore](<../../installation/custom/advanced-java-customization.html#java-ssl-truststore>).

## Managing users

When LDAP integration is enabled, the Data Science Studio account database contains both local users and users imported from the LDAP directory.

You can manage both type of accounts using the “Users” management page, accessible from the “Administration” menu (you must be logged to DSS with administrator privileges).

  * When editing a LDAP-based user entry, the password fields are not available as the user password is only managed and stored by the LDAP server.

  * A local user entry can only be a member of local groups. A LDAP-based user can be a member of local groups as well as LDAP-based groups, but only the local group membership list can be edited. The LDAP-based group membership list for a user is dynamically read from the LDAP directory on each login.

  * You can create a LDAP-based user account before the user’s first connection, or configure DSS to automatically create it on the user’s first connection. In the latter case, the user account is created with “Display name” and “email” attributes taken from the directory entry, if the corresponding attribute is configured and exists, and with an empty local group membership list. These fields can be adjusted by a DSS administrator after automatic account creation if needed.




## Managing groups

When LDAP integration is enabled, the Data Science Studio account database contains both local DSS groups and DSS groups mapped to groups in the LDAP directory.

You can manage both type of groups using the “Groups” management page, accessible from the “Administration” menu (you must be logged to DSS with administrator privileges).

A LDAP-based DSS group is defined by specifying a list of LDAP group names. Upon login, a LDAP-based DSS user u will be assigned to a LDAP-based DSS group g whenever the LDAP user account for u is a member of any of the LDAP groups underlying g in the directory.

Both LDAP- and local-based DSS groups can convey DSS administrator privileges, and DSS projects access rights, to a LDAP-based DSS user account.

If the “automatic import user” option is enabled, you will be able the define user profile for any LDAP group . This profile will only be applied for newly imported user and if a user belongs to many groups with a profile assigned the highest profile will be applied.

---

## [security/authentication/multifactor-authentication]

# Multi-Factor Authentication

DSS does not provide builtin multi-factor authentication.

For multi-factor authentication, we recommend setting up [SSO-based login](<../sso.html>) and having the SSO identify provider mandate the multi-factor authentication.

---

## [security/authorized-objects]

# Authorized objects

[Workspaces](<../workspaces/index.html>), [DSS dashboards](<../dashboards/index.html>) and [Data Collections](<../data-catalog/data-collections/index.html>) allow users who don’t have permission to read or write the full content of a project to access a selected set of insights from the project.

Within a given project, these users (who can’t read or write the full content of a project) have thus access to a subset of the objects.

This is handled by the “Authorized objects” mechanism, which is available in Project > Settings > Security > Authorized objects.

Both project-local objects and objects shared from other projects can be “authorized”.

## Scope

The “Authorized objects” menu defines object permissions for project dashboard-only users as well as workspace members and Data Collection readers who don’t have **Read project content** permission on the project.

  * Authorized objects have an “authorization mode” that describes the level authorization granted on that object. Most objects can only have the READ mode, but other modes allow for specific behavior (DISCOVER, WRITE and RUN) and interact differently with dashboards, workspaces and Data Collections.

  * “Authorized objects” are not tied to a group, but they work in combination with dashboard, workspace and Data Collection authorizations. For example, if an object has a READ authorization mode, it will be readable by:

    * _any_ user that has the ‘Read dashboards’ authorization on the project

    * _any_ user that is a member of a workspace the object is published on

    * _any_ user that is a reader of a Data Collection the object is published to

  * the READ mode allows a user to fully read the object. Importantly, it applies to an entire DSS object (for example, a dataset itself and its associated charts). So, if a dataset is in the list of “Authorized objects” with the READ authorization mode, it is technically possible, even for users who only have access to a limited view of the dataset (a single chart insight on the dashboard for example) to access the full content of the dataset.




## Adding objects to “Authorized objects” list

You can manage which objects are in the “Authorized objects” in Project > Security > Authorized objects. In order to achieve that you need the “Manage authorized objects” project-level permission. See [Main project permissions](<permissions.html>) for more info.

If you publish an object on a dashboard (for example, a chart based on a dataset) that is not yet in the authorized objects list, you will get a warning:

  * If you don’t have “Manage authorized objects” permission, the warning will indicate that dashboard-only users won’t be able to see this insight in the dashboard

  * If you do have “Manage authorized objects” permission, the warning will include a prompt to add this item to the list of authorized objects of the project.




When you publish a dashboard or dataset in a workspace, you need a “Publish on workspaces” permission in the project. This permission also implies a “Manage authorized objects” permission and it will add the object automatically to the authorized objects list.

When you publish a dataset to a Data Collection, you will be reminded of its current authorization mode, and will have the option to increase it in order to improve the dataset discoverability.

In Project > Security > Authorized objects, it is also possible to authorize all objects present in a project for dashboards, workspaces, and Data Collections via the toggle at the top of the screen. In that case, all authorizations are considered to be READ authorized.

## Details by object type

### Dataset

Authorizing a dataset with the READ authorization mode makes it possible to view and create the following insights on this dataset:

  * Dataset table

  * Chart

  * Comments

  * Metrics




It also allows a member of a workspace it’s published on to see the dataset content or insights about it. This also applies if the dataset is published on the workspace indirectly (eg. used in a dashboard that is itself published on the workspace).

Finally, the READ authorization on a dataset allows readers of a Data Collection it’s published on to see the dataset in the Data Collection with full access to its details and the ability to preview it.

Even though the user interface only shows a limited amount of information about the dataset (only a limited chart is available on a dashboard, only the preview in a Data Collection…), authorizing a dataset with the READ mode makes it technically possible to access all data in the dataset. There is no “intra-dataset” security.

Datasets also have the DISCOVER authorization mode. This mode allows a reader of a Data Collection to see the dataset and a limited amount of metadata, but not to see its content, or even to preview it. It allows you to let users know that the dataset exists and see some detail about it, while still being able to control precisely who is allowed to access its content (see the [Data Collection documentation for details](<../data-catalog/data-collections/permissions-and-dataset-visibility.html>)). Users can request access to the project or request the dataset to be shared if those features are enabled. It does not allow anything for ‘dashboard-only’ users or workspaces members, and it doesn’t allow users to [quick share](<shared-objects.html#quick-sharing>) the dataset even if it is activated.

### Saved model

Authorizing a saved model with the READ authorization mode makes it possible to view and create the following insights on this model:

  * Model report

  * Comments

  * Metrics




It gives dashboard-only users the ability to view all details (metrics, variables, …) of the model.

### Managed folder

Authorizing a managed folder with the READ authorization mode makes it possible to view and create the following insights on this folder:

  * Managed folder (displays the content of the folder)

  * Comments

  * Metrics




It gives dashboard-only users the ability to view all files in the folder.

### Jupyter notebook

Authorizing a notebook with the READ authorization mode makes it possible to view and create “Jupyter notebook” insights. These insights are based on _exports_ of notebooks, not the notebook itself.

When a Jupyter notebook is dashboard-authorized, it does not give dashboard-only users the ability to execute code in the notebook, nor to create a new export of the notebook.

### Web app

Authorizing a web app with the READ authorization mode makes it possible to view and create the following insights on this webapp:

  * Web app (displays the content of the webapp)

  * Comments




It allows workspace and dashboard-only users to view the webapp. It does not allow them to modify the webapp or to view the backend code.

### Scenario

Authorizing a scenario with the READ authorization mode makes it possible to create an insight representing the history of runs of this scenario.

Authorizing a scenario with the RUN authorization mode makes it possible for dashboard-only users to run this scenario. This can lead to interesting use cases. For example, if a scenario takes as input a campaigns reference file on a FTP folder, the marketing team can update the file, and when they want, rerun a scenario directly from the dashboard.

---

## [security/connections]

# Connections security

## Securing access to connections

It is possible to restrict access to connections. If access to a DSS connection is restricted, only members of selected groups may “freely use” this connection.

This can be configured in the settings of each individual connection.

“Freely using” a connection means being able to:

  * Create new datasets on the connection

  * Modify the settings of a dataset using the connection

  * Browse in any way the connection

  * Send code (like SQL) which may be used indirectly to browse in any way the connection.




Note that this does NOT restrict the ability to read datasets which have already been defined on a connection.

For example, with a SQL database, you may want a few people to be able to create datasets based on specific tables of the connection, and then have a larger group of analysts using this data, but who are not allowed to read other tables in this database.

In that configuration, you would have the small group being granted the “freely use” permission on the database connection, create the datasets in a project, and grant read/write access to the project to the larger group. The analysts are able to read the data, but cannot access other tables from the database in any way.

Note that access to a connection can only be granted to a group. Thus, it cannot be granted to a non-personal API key (since these API keys do not belong to groups). In order to access connections (using the rules described above) with an API key, you will need to use either:

  * An admin API key

  * Or a personal API key




## Reading details of a connection

By default, even if a user may “freely use” a connection, he may not read the details of the connection.

The details of the connection include:

  * The path (for filesystem-connection)

  * The HDFS properties (for HDFS connections)

  * The hostname / database / … (for SQL connections)

  * The credentials (for all connections which include a credential)




In the settings page of the connection, an administrator may grant the right to some groups to read the details of a connection. The details can only be read using code, as no part in the UI will show it.

Note

Granting “Details readable by” on a connection to a group gives users access to the unencrypted credential for this connection. Make sure that you wish this.

Beware that for Hadoop filesystem datasets that actually point to S3, WASB, …, the details of the HDFS connection usually contain a secret credential in order to connect to the cloud storage.

Note

Granting “Details readable by” on HDFS and S3 connections is strongly recommended in order to obtain good performance in Spark. If Spark processes do not have the “Details readable by” permission, they are forced into a slow path that very strongly degrades performance of Spark jobs.

For more information, see [Interacting with DSS datasets](<../spark/datasets.html>)

Note that access to a connection can only be granted to a group. Thus, it cannot be granted to a non-personal API key (since these API keys do not belong to groups). In order to access connections (using the rules described above) with an API key, you will need to use either:

  * An admin API key

  * Or a personal API key




## Per-user credentials for connections

Note

While this feature is distinct from the User Isolation Framework feature, it is only available for DSS licenses where the User Isolation Framework is enabled.

For DSS connections which require credentials (most SQL connections, MongoDB, FTP, …), the administrator can configure the connection so that instead of having a global service credential, each user can enter his personal credentials. Each action on the database performed by this user will use his personal credential.

To configure a connection with per-user credentials:

  * Go to Administration > Connections and select the connection

  * In “Connections credentials”, select “Per-user”

  * Save the connection




Users can then enter their personal credentials by going to their Profile > Credentials.

Note that in this mode, there is no global credential at all anymore. Thus, it is not possible to test a connection immediately, because no credentials available. The proper initialization sequence for a new connection is thus:

  * The admin enters connection details, but no credentials, and enables per-user credentials

  * The admin saves the new connection

  * The admin goes to his profile and enters his credentials

  * The admin can then go back to the connection’s page and test the connection




User credentials are stored encrypted. Please see [Passwords security](<passwords-security.html>) for more details.

## Personal connections

You can grant to user groups the permission to create their own connections. Connections are normally only created by the DSS administrator. By granting this “personal connection” permission, end users can create their own connections.

This feature is only available for connections for which a credential is required (most SQL connections, MongoDB, FTP, …).

Personal connections run with the permissions of the DSS service account and may allow actions beyond simple data access. As a result, the permission to create personal connections should be considered an elevated permission and granted sparingly.

---

## [security/folder-defaults-access]

# Project folders - defaults and access

Project Folders are used to organize projects, and are shown in the [projects page](<../concepts/homepage/projects-page.html>).

## Project folder access and permissions

There are three levels of permission for each folder - Read, Write Contents and Admin. For each folder, you can assign these permissions to specific groups or to All Users \- click on the ellipsis in the corner of the folder and select **Permissions**. There is also a folder owner (the user who created the folder unless changed), who has Admin-level permissions.

Giving Read access to the folder will alway make it appear in the folder hierarchy. The opposite is not true, a folder can still be visible without the user having any permission on that project, for example, if it has contents that are visible to the user (see the Project Folder visibility rules section below)

## Project folder visibility rules

A user can see a folder in the hierarchy if any of following conditions are met:

  * The user has at least read permissions on the folder itself

  * The user has at least read permissions on any descendant folder in the hierarchy

  * There is a project in the folder, or one of its descendants, which is visible to the user (this can be because of project permissions or because the project is discoverable - see [project access settings](<project-access.html>))




## Folder creation configuration

There are some configuration options you can use to aid users create projects quickly in Dataiku while preventing things from becoming untidy.

The first simple thing is to limit the write access to the root folder - if all users can create projects in the root area, they will be visible from the home page of other users, and things may become disorganised. To prevent this, see: [Permissions: “Write in root project folder”](<permissions.html>)

Then there is the default folder configuration. This comes into play when users create or import a project, and they get a choice of the location in the folder hierarchy for the new project. When in the context of a specific folder for which the user has Write Contents permission, the location suggested by DSS is just that folder itself. But when it’s done in a central location, such as on the home page, or somewhere the user cannot write, DSS suggests a default folder.

The default behaviour is to suggest the “Sandbox” folder for all users - this is a top level folder that is writable for all users. The idea of this is to give users an area where they can freely create projects and experiment. (Note: only users who have permissions and a profile which allows them to create some form of project will be able to do this - the permissions in :doc: Project Permissions </security/permissions> still apply ).

To change this configuration go to the **Administration > Settings > Themes & Customization** page, to the section **Default folders for project creation** which contains the rules:

Here you can change the default folder for All Users, or add different rules for specific groups, so users from these groups are directed towards sensible default locations for their projects. (Take care to ensure the groups you choose have Write Contents access to the locations you specify for them). For example:

### Per-user folders

If you are concerned that all your users are sharing the same sandbox area and this might create confusion, you can turn on the Per-user folders setting for the rule(s). This means when a user goes to create a project, DSS will create and suggest a folder with a name derived from the user’s login (under the folder specified in the rule). This way users will automatically get their own area for experimentation. (Note: whether the users will be able to see each other users’ folders will depend on the discoverability of the projects inside them - if there are any that are discoverable, they will - see [project access settings](<project-access.html>)).

---

## [security/govern-permissions]

# Govern Security: Permissions

Note

This section only applies to [Dataiku Govern](<../governance/index.html>).

## Global Permissions: Administrator & Govern Architect

**Govern Architect**
    

Designed for users configuring the governance framework, this global permission grants full access to design blueprints, workflows, and custom pages, while also providing authority over governance settings, sign-off delegation, and access configuration through Roles and Permissions.

**Administrator**
    

Inheriting all capabilities of the **Govern Architect** , this global permission gets additional authority for system-level management, including node security and environment configurations.

Warning

For Dataiku Cloud managed instances, the **Administrator** global permission is managed via the Dataiku Cloud launchpad rather than directly within the Dataiku Govern interface.

The following table provides a comparison of their respective permissions:

Functional Access | Govern Architect | Administrator  
---|---|---  
Access Standard & Custom Pages | ✔ | ✔  
Full CRUD on All Artifacts | ✔ | ✔  
Action, Blueprint & Custom Page Designer | ✔ | ✔  
Sign-off Delegation | ✔ | ✔  
Governance Settings | ✔ | ✔  
Manage Roles and Permissions | ✔ | ✔  
Read Python Scripts Logs | ✔ | ✔  
System Administration | ✖ | ✔  
  
## Roles and Permissions

**Roles** and **Permissions** are two distinct notions that Dataiku Govern uses to configure **who** can do **what** in Govern. Note that **Govern Architect** and **Administrator** permissions take precedence over any of these configurations.

They are based on the following Govern concepts:

  * **Blueprint** : a category of objects (example: a Govern Project)

  * **Blueprint Version** : the template/schema for objects; it contains the field definitions, workflows definitions, etc. (Example: a specific template for Govern Projects, with 5 workflow steps. Another Blueprint Version for Govern Projects might have a template with 9 workflow steps, perhaps for projects on teams with many regulatory requirements.) A Blueprint can contain multiple Blueprint Versions that can be seen as variants, with slight variations in their content.

  * **Artifact** : this is the actual object. It contains the fields that are defined in the Blueprint Version and that users can fill in. (Example: a Govern Project for “North America Fraud Detection”)




Note: to learn more about them, go to the page [Navigation in Dataiku Govern](<../governance/navigation.html>).

**Roles** are simple labels created at Govern instance level. They will be assigned to Users and Global API Keys based on the contextual action and the Roles and Permissions settings.

Note

Roles are different from the Users and Groups that come from the LDAP. The LDAP Users and Groups are usually based on the company structure and so may differ from the intended usage and associated permissions needed in Govern. By using Roles instead of directly using LDAP Users and Groups in the Permissions configuration, Roles can be dynamically assigned to Users or Groups, based on any combinations of rules and criteria, making for a highly flexible permissions system.

**Roles Assignments Rules** are a configurable set of rules that define, depending on the contextual action, what Roles are assigned to which Users.

**Permissions** are configurable settings that define what actions are allowed for which Roles.

Concretely, the Roles and Permissions system works this way:

  * **User action** : A User wants to run an action that is permission-locked.

  * **Roles computation** : Given the Roles Assignments Rules settings and the action, compute the set of Roles assigned to the User.

  * **Permissions computation** : Given this set of Roles, the Permissions settings, and the action, compute the effective permissions granted to the User.

  * **Action result** : Based on the effective permissions, the User is allowed, or not allowed, to run the action




For each Blueprint, **Roles Assignment Rules** and **Permissions** settings can be defined. The **Default Permissions** are **Permissions** settings defined at Govern instance level. If no specific **Permission** is set on a Blueprint, they are used instead in the computation process.

Note

This Roles and Permissions system is not applied in the admin restricted configuration pages, like the Administration page, the Blueprint Designer page, or the Roles and Permissions page.

### User actions

The Roles and Permissions computation is entirely based on the contextual action the User runs. The following table lists the actions with their description, the involved Govern objects, and their related Permissions options in the settings.

Action | Description of the action | Blueprint involved | Blueprint Version involved | Existing Artifact involved | Permissions settings options  
---|---|---|---|---|---  
Admin Blueprint CRUD | Create, Read, Update, and Delete a Blueprint in the Blueprint Designer | **Does not apply, global admin permission is required**  
Admin Blueprint Version CRUD | Create, Read, Update, and Delete a Blueprint Version in the Blueprint Designer | **Does not apply, global admin permission is required**  
Blueprint Read | Access and see the name, icon, colors of a Blueprint | ✔ | ✖ | ✖ | Artifact Admin, or Read, or Write, or Create, or Delete  
Blueprint Version Read | Access and see the definition of a Blueprint Version | ✔ | ✔ | ✖ | Artifact Admin, or Read, or Write, or Create, or Delete  
Blueprint Version Field Read | See a specific field definition of a Blueprint Version | ✔ | ✔ | ✖ | Artifact Admin, or Read, or Write, or Create, or Delete & Field Read  
Artifact Create | Create a new Artifact | ✔ | ✔ | **✖** | Artifact Create & Field Write  
Artifact Read | Access, see the name, and the workflow status of an existing Artifact | ✔ | ✔ | ✔ | Artifact Read  
Artifact Field Read | See a specific field value of an existing Artifact | ✔ | ✔ | ✔ | Artifact Read & Field Read  
Artifact Write | Edit an existing Artifact | ✔ | ✔ | ✔ | Artifact Write  
Artifact Field Write | Edit a specific field value of an existing Artifact | ✔ | ✔ | ✔ | Artifact Write & Field Write  
Artifact Delete | Delete an existing Artifact | ✔ | ✔ | ✔ | Artifact Delete  
  
Note

  * The Admin Blueprint, and Blueprint Version Create, Read, Update, and Delete actions in the Blueprint designer are based on the global admin permission and not on the Roles and Permissions system

  * The Blueprint Read, Blueprint Version Read, and Blueprint Version Field Read actions are based on the Artifact Read and Field Read permissions, there is no Blueprint Read option in the Permissions settings (check the Permissions section to learn more)

  * No Existing Artifact is involved for the Artifact Create action because it does not exist yet (it is important to consider this when configuring Roles Assignment Rules with criteria, check the Criteria section to learn more)




### Roles Assignment

#### Roles Assignment Rules

For a specific Blueprint and for each Role, a list of Role Assignments Rules can be defined. For the Role to be assigned, at least one Rule must be valid.

A Rule is configured by selecting specific Users and Global API Keys for them to be assigned to the selected Role.

A Rule contains a list of criteria (conditions) that can be empty. For a Rule to be valid, all the criteria must comply. In the case of an empty list of criteria, the Rule is considered valid and the Role will be assigned.

The logic is to always **add** Roles. If a Rule is valid, the associated Role will be assigned to the User. There is no way to create exceptions to the Rules to remove the assigned Role afterward.

##### User & API Keys selection

There are several ways to select Dataiku Govern Users and Global API Keys to be assigned to a Role:

  * **A list of users**
    

All users in this list are selected.

  * **A list of user groups**
    

All users in these user groups are selected.

  * **A list of Global API Keys**
    

All API Keys in this list are selected. (Global API Keys are an independent way to authenticate to Dataiku Govern).

  * **A list of field IDs**
    

Only for actions involving a specific existing Artifact. This is a dynamic way to select Users and Global API Keys: all Users/Groups/Global API Keys stored in these artifact fields are selected.

Warning

Any user that can modify a field in this list on an artifact will consequently modify Users and Global API Keys permissions. Please double check who has field write access on these fields.




##### Criteria

  * Blueprint Version criterion:

    * restricts the Rule to be valid only in the context of an action involving a **Blueprint Version**

    * restricts the Role assignment to one specific Blueprint Version defined by the given Blueprint Version ID

  * Field value criterion:

    * restricts the Rule to be valid only in the context of an action involving an **Existing Artifact**

    * restricts the Role assignment based on a field value. Multiple operators exist, such as Equals or Contains

  * Workflow criterion:

    * restricts the Rule to be valid only in the context of an action involving an **Existing Artifact**

    * restricts the Role assignment based on the active step in the workflow that must be the one defined by the given Step ID

  * Artifact existing criterion:

    * restricts the Rule to be valid only in the context of an action involving an **Existing Artifact**

  * Artifact deleted criterion:

    * restricts the Rule to be valid only in the context of an action involving a **Deleted Artifact**

  * No criterion:

    * doesn’t restrict the Rule at all




Note

As it is shown on the User actions table above, the actions are involving some Govern objects. As a result, it may narrow the list of criteria that can be applied when the current action does not provide the needed object to evaluate the rule. For instance, during an **Artifact Create** action, a Rule with a **Field Value** criterion will never comply because this criterion requires the involvement of an **Existing Artifact**.

#### Roles Inheritance

In addition to Roles assignment Rules, a Blueprint can be configured to use **Roles Inheritance**. It helps centralizing Roles assignment Rules in one place when they apply to multiple Govern objects. For instance, it is useful in the context of a hierarchical structure between Govern items.

##### Blueprint Inheritance

By adding a Blueprint reference in the **Inherit Blueprint role assignment rules** settings option, the Blueprint will inherit Roles from another Blueprint. In this case, Govern will compute the assigned Roles in the context of the selected Blueprint (only involving this Blueprint). All the computed Roles will be added to the normal Role computation mechanism based on Roles Assignments Rules as described above. The logic is to always **add** Roles. So by setting up **Blueprint Inheritance** only new Roles can be added and none can be removed.

The Blueprint Inheritance involves a Blueprint but does not involve a Blueprint Version, nor an Existing Artifact, nor a Deleted Artifact. As a side effect, only Rules without criteria are valid for Blueprint Inheritance.

##### Artifact Inheritance

By setting a field ID in the **Inherit computed roles from Artifact (based on reference field)** settings option, the Blueprint will inherit Roles from an Existing Artifact. If this option contains a valid field ID, and if the field contains a valid Artifact reference to an Existing Artifact, Govern will compute the assigned Roles in the context of this referenced Existing Artifact (only involving this Existing Artifact, its related Blueprint and Blueprint Version). All the computed Roles will be added to the normal Role computation mechanism based on Roles Assignments Rules as described above. The logic is to always **add** Roles. So by setting up **Artifact Inheritance** only new Roles can be added and none can be removed.

The Artifact Inheritance involves an Existing Artifact (the referenced one) and all criteria that rely on an Existing Artifact will be based on the referenced Artifact and not another one.

### Permissions

The **Permissions** settings are configured at the Blueprint level so each Blueprint can have its own configuration. The **Default Permissions** are global settings that are used instead when the Blueprint-specific **Permissions** settings are not set.

Note

All permissions will be granted to Govern admins.

#### Artifact Permissions

##### Configuration per Role

Permissions settings are configured per Role.

There are four Artifact permissions to be configured: **Artifact Read** , **Artifact Write** , **Artifact Create** , and **Artifact Delete**. Granting any of the **Artifact Write** , **Artifact Create** and **Artifact Delete** permissions automatically also grants the **Artifact Read** permission.

There are two Artifact Field permissions to configure: **Field Read** and **Field Write**. Granting the **Field Write** permission automatically also grants the **Field Read** permission.

For any field, it is possible to define a permission exception. If a field does not have a permission exception, the computation mechanism will fall back on the **Field Read** and **Field Write** permissions.

Note

The **Default Permissions** does not have permissions exceptions for fields.

##### Configuration for Everyone

It is possible to create a permission configuration for **everyone**. These permissions will be granted to every users even to users with no assigned Roles.

The tool to configure permissions for **everyone** contains the same configuration as the configuration for specific roles:

  * **Artifact Read** , **Artifact Write** , **Artifact Create** , and **Artifact Delete** permissions

  * **Field Read** and **Field Write** permissions

  * Field permission exceptions




Note

If the **Field Read** permission is checked in this **everyone** block, every field that does not have a permission exception configured will be readable by everyone. The same applies to the **Field Write** permission.

#### Blueprint and Blueprint Version Permissions

In most cases, Users won’t interact directly with Blueprint and Blueprint Versions; instead they interact directly with Artifacts that are based on a Blueprint and a Blueprint Version.

That is why Blueprint and Blueprint Version permissions cannot be configured, they are computed based on the Artifact permissions.

In a context of an action involving an Existing Artifact, any granted Artifact permission (**Artifact Admin** , **Artifact Read** , **Artifact Write** , **Artifact Create** , **Artifact Delete**) implies the permission to read and access to the corresponding Blueprint and Blueprint Version. For all fields that the User does not have the **Field Read** permission, their definition will be filtered out of the Blueprint Version.

Note

When a User wants to access a Blueprint directly (ie. listing the available Blueprints), the Role computation will be done involving only the **Blueprint**. Thus only Rules without criteria will apply. The permissions computation will still consider the Artifact permissions to allow or not the access of the Blueprint. When a User wants to access a Blueprint Version directly (ie. listing the Blueprint Versions of a Blueprint), the Role computation will be done involving only the **Blueprint Version** and its **Blueprint**. Thus only Rules without criteria or with the Blueprint Version criteria will apply. The permissions computation will still consider the Artifact permissions and Artifact Field permissions to allow or not the access of the Blueprint and the field definitions.

Note

Only Govern admins can add, edit, or delete Blueprints and Blueprint Versions in the Blueprint Designer page.

See also

More information on Govern roles and permissions can be found in [Concept | Govern roles and permissions](<https://knowledge.dataiku.com/latest/govern/permissions/concept-roles-permissions.html>).

---

## [security/index]

# Security

---

## [security/messaging-channels-permissions]

# Messaging Channels Permissions

In the _Administration > Settings > Collaboration > Notifications & Integration_ section, for each channel, you can add or remove users or groups allowed to use that channel. A special _All users_ group allows you to allow any logged in user to use the channel. By default, channels are not restricted, i.e. channels are initialized with this special _all users_ group.

The channel permissions apply to:

  * scenario _send message_ steps and reporters

  * agent tool _send message_

  * public api usage of the send message route (including the corresponding python API method)




The channel permissions do not apply in the following channel usage:

  * Any Dataiku built-in notification (welcome email, LLM cost control notifications, project integration notifications…)

  * Unified monitoring notifications

  * Govern instances




The permissions are verified considering the user who is running the action:

  * for scenarios, the ‘run as’ user (may be different from the user who manually triggered the scenario, when applicable)

  * for an Agent Tool based recipe, this is the user who started the recipe, or the ‘run as’ user of the scenario that triggered the recipe when applicable

  * When authenticating through a personal API key, authorization to use the channel will be based on the relevant user

  * project or global API keys will be allowed to use the channel if the special _all users_ group is authorized.

---

## [security/passwords-security]

# Passwords security

## Local passwords database or not

DSS comes with its own local passwords database. When an administrator creates a user (through Administration > Security > Users), and creates a “Local” user, the password is stored encrypted in the local passwords database.

In most enterprise deployments, however, the local passwords database isn’t used. Instead, users come from a LDAP directory. Users can then login directly on DSS with their LDAP password, or use SSO to login + LDAP to fetch groups.

## Passwords complexity

DSS does not mandate any password security rules for the passwords stored in the local passwords database. If you need password security rules enforced, we strongly recommend that you use LDAP instead of the local passwords database

## Encryption of the local passwords database

Passwords in the local passwords database are encrypted using a one-way (non-reversible) hash function, which makes it extremely hard to find the original password from the encrypted hash.

The algorithm used is salted-PBKDF2, a state of the art hashing algorithm that is specifically designed to be resilient against brute-force attacks.

## 3rd party system credentials

In addition to the user passwords (in case the local passwords database is used), DSS also needs to keep passwords for all 3rd party systems it connects to:

  * Passwords for SQL and NoSQL databases

  * Cloud storages

  * Integration credentials (Slack, …)

  * [User secrets](<user-secrets.html>)

  * …




For all of these, unlike user passwords, DSS actually needs to have the decrypted password in order to send it to the 3rd party system.

These passwords are encrypted in the configuration files using a symmetric encryption algorithm. The algorithm used is authenticated AES in CTR mode. Both AES-128, AES-192 and AES-256 are supported. Authentication is performed by a HMAC-SHA256.

The encryption key is stored in the DSS data directory, and is never given out to DSS users.

Alternatively, the encryption key can be stored in your cloud secret manager (AWS Secrets Manager, Azure Key Vault or Google Cloud Secret Manager). Please reach out to your Dataiku Customer Success Manager to learn more.

Note that when using plugin “parameter sets”, if you put the credentials inline in a dataset or recipe, they are not encrypted. Use “presets” instead.

---

## [security/permissions]

# Main project permissions

DSS uses a groups-based model to allow users to perform actions through it.

The basic principle is that users are added to groups, and groups have permissions on each project.

## Per-project group permissions

On each project, you can configure an arbitrary number of groups who have access to this project. Adding permissions to projects is done in the Permissions pane of the Security menu.

Each group can have one or several of the following permissions. By default, groups don’t have any kind of access to a project.

### Admin

This group may perform any action on the project, including:

  * change the permissions and owner of the project

  * create project bundles




This permission implies all other permissions.

### Edit permissions

This group may see and edit permissions of the project.

A user with this permission cannot grant or remove a permission that they do not have themselves (i.e. cannot grant “Read project content” to a user if they do not have that right)

This permission implies the “Read dashboards” permission.

### Read project content

This group may see the Flow, access the datasets, read the recipes, … More generally speaking, this group may read every configuration and data in this project.

This permission implies the “Read dashboards” permission.

### Write project content

This group may read and write every configuration and data in this project. This includes the ability to create new datasets, recipes, …

This also includes the ability to run all jobs in this project.

Note

This permission is the “default” permission that you may want to give to your data team.

This permission implies the “Read project content”, “Read dashboards”, “Run scenarios” and “Write dashboards” permissions

### Publish to Data Collections

This group may be able to publish datasets to [Data Collections](<../data-catalog/data-collections/index.html>). Note that DSS administrators must separately grant the global group permission to Publish to Data Collections, regardless of permission on the source project.

### Publish on workspaces

This group may be able to share objects (Dashboards, Datasets, Wiki pages) to [workspaces](<../workspaces/index.html>). Note that DSS administrators must separately grant the group permission to [share content](<../workspaces/managing.html>) into workspaces, regardless of source project.

### Export datasets

This group may click on the “Download” button to retrieve the content of a dataset.

Warning

Disabling this permission removes the most obvious way to download whole datasets, but through various means, users who have at least “Read project content” will still be able to download datasets.

If you absolutely want your users not to be able to retrieve the full content of datasets, do not give them access to the project.

### Run scenarios

This group may run scenarios. They may not run jobs that are not part of a scenario. Only scenarios that have a “Run As” user may be run by users who only have this permission.

This permission is generally not very useful without the “Read project content” permission.

### Read dashboards

This group may read dashboards that have been created. They may not modify anything. They can only read dashboard insights that use project objects that have been shared with them using [Authorized objects](<authorized-objects.html>).

### Write dashboards

This group may create their own dashboards, using the project objects that have been shared with them using [Authorized objects](<authorized-objects.html>).

This permission implies “Read dashboards”.

### Manage authorized objects

This group may modify which objects of the project are usable by dashboard-only users through the [Authorized objects](<authorized-objects.html>) and accessible through a workspace or a Data Collection.

This permission is generally not very useful without the “Read project content” permission. This permission is implied by the “Publish on workspaces” and “Publish to Data Collections” permissions.

The main use case for this permission is the following:

  * A group of analysts and data scientists creates a Flow

  * The data is of medium sensitivity so all dashboard users could use any of the Flow

  * However, the dashboard users must not be able to break or modify the Flow

  * Thus, the dashboard users (or a subgroup of them) has this permission to gain access to source datasets




### Manage shared objects

This group may modify which objects of the project are available in other projects through the [Shared objects](<shared-objects.html>).

This permission is generally not very useful without the “Read project content” permission.

The main use case for this permission is the following:

  * A group of analysts and data scientists creates a Flow

  * The data is of medium sensitivity so all or some DSS users should be able to reuse it on other projects

  * However, the other projects’ users must not be able to break or modify the Flow

  * Thus, a group of other project’s users has permission to go in the project, and “pick” datasets to use in other projects.




### Execute app

This permission is only exposed on projects converted into a [Dataiku application](<../applications/index.html>) or an [application-as-recipe](<../applications/application-as-recipe.html>).

This group may execute the corresponding application if the application is configured to be instantiated only by user with this permission. Else this permission is not needed.

## Project owner

In addition to the per-group access, each project has a single user who “owns” the project. Being the owner of a project does not grant any additional permissions compared to being in a group who has Administrator access to this project.

This owner status is used mainly to actually grant access to a project to the user who just created it.

## Project visibility

It is possible to allow all users to access a project’s page displaying a limited amount of information about the project regardless of the users’ permissions. The information displayed in this case includes the project image, name, short description, owner, tags and status. This is known as a “Discoverable” project. The opposite is a “Private” project, for whom having no read permissions implies the projects existance will not be apparent to a user at all.

Which projects are Discoverable is controlled in the “Project Visibility” setting on the **Administration > Settings > Access & requests** page. You can control the defaults (Private or Discoverable) when projects are created, or you can set all projects to Discoverable, or Private.

Discoverable projects appear in the [projects page](<../concepts/homepage/projects-page.html>), in the Catalog, and in the “Search DSS Items” page for all users making them easily discoverable. If a user doesn’t have access to a discoverable project, the project is denoted with a padlock symbol.

## Per-project single user permissions

In addition to the per-group access, on each project, you can configure an arbitrary number of individual users who have access to this project. Adding permissions to projects is done in the Permissions pane of the Security menu.

Each user can be granted the same kind of project permissions than groups above. This is useful for a non-administrator to give access to a project to some users individually, without the need for those users to belong to specific groups.

Warning

When using [User Isolation](<../user-isolation/index.html>) in “DSS-managed ACL” mode, HDFS ACLs are not supported for individual user permissions on projects. See [Hadoop Impersonation (HDFS, YARN, Hive, Impala)](<../user-isolation/capabilities/hadoop-impersonation.html>).

## Sharing project via email

You can also invite non-DSS users to your project via email.

If a valid mail channel (e.g. SMTP) is configured in Administration > Settings > Notifications & Integrations, an invitation will be sent to the specified email.

Once the user registers with that email, they will be granted access to the project.

Invitations by email can be disabled on the **Administration > Settings > Access & requests** page.

## Sharing dashboards via email

It is also possible to share a dashboard with a user (by name or email) from the dashboard page.

This acts similarly to sharing a project, but the user will only be granted the “Read dashboards” permission on the project. An email will be sent to the user. If screenshot generation is possible the email will include a screenshot of the dashboard.

Invitations by email can be disabled on the **Administration > Settings > Access & requests** page.

Note

The “Read dashboards” permission is a project-level permission: the user will be able to see all promoted dashboards of the project.

## Global group permissions

In addition to the per-project permissions, groups can also be granted several global permissions that apply to all DSS.

These permissions are configured in the settings screen of the group.

  * Administrator: members of a group with this permission can perform any action on DSS. DSS administrators are implicitly administrators of all DSS projects and may access any project, even without explicitly being granted access through a project-group grant.




### Projects creation

  * Create projects: members of a group with this permission can create their own projects, using a blank project, project duplication of project import

  * Create projects using macros: members of a group with this permission can create projects using a [project creation macro](<../concepts/projects/creating-through-macros.html>)

  * Create projects using templates: members of a group with this permission can create projects using predefined templates (Dataiku samples and tutorials)

  * “Write in root project folder”: members of a group with this permission can create folders and projects in the root folder, or move them to the root.




### Workspaces

  * Create workspaces: members of a group with this permission can create their own workspaces.

  * Publish on workspaces: members of a group with this permission can share objects to workspaces.




### Data Collections

  * Create Data Collections: members of a group with this permission can create Data Collections.

  * Publish to Data Collections: members of a group with this permission can publish datasets to Data Collections.




### Code execution

  * “Write isolated code”: members of a group with this permission can write code which will run with impersonated rights. This permission is only available when [User Isolation Framework](<../user-isolation/index.html>) is enabled.

  * “Write unisolated code”: members of a group with this permission can write code which will be executed with the UNIX privileges of the DSS UNIX user.

  * “Create active Web content”: members of a group with this permission can author Web content that is able to execute Javascript when viewed by other users. This includes webapps, Jupyter notebooks and RMarkdown reports




### Code envs & Dynamic clusters

  * “Manage all/own code envs”: members of a group with this permission can create and manage [code environments](<../code-envs/index.html>); their own, those they’ve been given administrative access to, and even others, if given the ‘all’ permission.

  * “Manage all/own clusters”: members of a group with this permission can create and manage clusters; their own, those they’ve been given administrative access to, and even others, if given the ‘all’ permission.




### Advanced permissions

  * “Develop plugins”: members of a group with this permission can create and edit [development plugins](<../plugins/reference/index.html>). Be aware that this permission could allow a hostile user to circumvent the permissions system.

  * “Edit lib folders”: members of a group with this permission can edit the Python & R libraries and the static web resources in the DSS instance.

  * “Create personal connections”: members of a group with this permission can create new connections to SQL, NoSQL, and Cloud storage. Personal connections run with the permissions of the DSS service account and may allow actions beyond simple data access. As a result, the permission to create personal connections should be considered an elevated permission and granted sparingly.

  * “View indexed Hive connections”: members of a group with this permission can use the Data Catalog to view indexed Hive connections.

  * “Manage user-defined meanings”: members of a group with this permission can create instance-wide user-defined meanings, which will be accessible and usable by all DSS projects.

  * “Create published API services”: members of a group with this permission can create an API service endpoint and [publish it to a DSS API node through the DSS API Deployer](<../apinode/index.html>).




### Write unisolated code: details

For more information about enabling user isolation, see [User Isolation Framework](<../user-isolation/index.html>)

#### Regular security mode

When UIF is disabled, DSS runs as a single UNIX user. All code which is written through the interface and executed locally is therefore ran with the permissions of this said user.

This includes notably:

  * Python and R recipes

  * Python and R notebooks

  * PySpark and SparkR recipes

  * Custom Python code in preparation recipes

  * Custom Python code for machine learning models




No user (even with the Data Scientist profile) may write such code if they are not granted the “Write unisolated code” permission.

It is important to note that since the DSS Unix user has filesystem access to the DSS configuration, a user who has the “write unisolated code” permission is able to alter the DSS configuration, including security-related controls. This means that a hostile user with these privileges would be able to bypass DSS authorization mechanisms.

#### User isolation enabled

When UIF is enabled, most of the aforementioned code runs with end-user permissions. The “write unisolated code” permission only applies to the following specific locations where the code is not ran using end-user impersonation:

  * Write custom partition dependency functions

  * Write Python UDF in data preparation




## Multiple group membership

Users may belong to several groups. All permissions are cumulative: being a member of a group who has a given permission grants it, even if you are also member of a group who doesn’t have said permission.

DSS does not have negative permissions.

---

## [security/project-access]

# Project Access

Projects have two levels of access. They are either Private or with Limited Access. Both are governed by the same [Main project permissions](<permissions.html>) and can benefit from access request workflows.

The level of access and activation of request workflows can be configured in the Permissions pane of the project’s Security menu.

## Discoverable projects

Discoverable projects are visible to all users through **Home > Projects page** or the global search. Only a subset of project information is displayed to users that don’t have access to the project:

  * Project key

  * Project name

  * Project owner (name & login)

  * Project status

  * Project tags

  * Short description

  * Long description

  * Project Image

  * Creation date & author

  * Project contributors (name, login & email)

  * Whether the project is an app instance or an app-as-recipe




Discoverable projects are not displayed on the user’s homepage except if they have permissions on the project. Which projects are Discoverable is controlled in the “Project Visibility” setting on the **Administration > Settings > Access & requests** page.

## Private projects

Private projects are visible only to users having permissions on the project. No information on these projects is made available to the other users without any permission.

## Access Requests

By activating access requests on the project, project administrators allow users without permissions on the project to initiate a project permission access request. The recipients of such requests are all project administrators. See [Requests](<../collaboration/requests.html>) for more information.

### Initiating a project access request

Only users without any permissions on the project will be able to initiate a project access request. They will be able to do so through a modal that will be displayed when landing on the URL of the project or from the right-panel of the “Search DSS Items” page when such a project is selected.

Users requesting access will not be able to define the level of permissions wanted on the project. However, a free-text box in the request modal enables them to add a message to their requests in order to explain why they are requesting access and the level of permissions they want.

### Managing a project access request

Project administrators can manage access requests from within the project’s security section or by handling the request in the requests inbox.

If they manage the request in the requests inbox, they will be able to select the user or the user group they are granting permissions to and give only “read-project content” or “write-project content” permission. To provide more granular permissions, they must go to the project’s security section.

Note

Automatic updates of the request:

In the following cases, the status of the request will be automatically updated:

  * Request is considered as approved if the project administrator manually grants the requester or a group including the requester any “read” permissions

  * Request is rejected if the requester is deleted

  * Request is deleted if the project is deleted

---

## [security/redhat-cis-level1-compatibility]

# Compatibility of DSS with CIS Benchmark Level 1 on RHEL / CentOS / AlmaLinux / Rocky Linux / Oracle Linux

Dataiku DSS is compatible with all recommendations from the CIS CentOS / RedHat / AlmaLinux / Rocky Linux / Oracle Linux Benchmark Level 1, with the exceptions and cautions listed below.

## Ensure noexec option set on /tmp partition

Enabling this option will interfere with the ability to compile Python and R packages. It will usually fully prevent using R, and will hinder the ability to leverage third-party Python packages that require compilation.

## Ensure default user umask is 027 or more restrictive

If using this recommendation, and if DSS User Isolation is enabled, care must be taken to ensure that impersonated users can access both the installdir and datadir. This can be done by running chmod after untarring the DSS archive. Failure to do so would prevent most features of DSS from working.

## Ensure users’ home directories permissions are 750 or more restrictive

If the Dataiku DSS datadir is in the DSS user’s home directory, and if DSS User Isolation is enabled, care must be taken to ensure that impersonated users can access both the installdir and datadir. This can be done either by ensuring that impersonated users belong to the group of the homedir, or by changing the DSS user’s homedir permissions to 751

---

## [security/shared-objects]

# Shared objects

In DSS, projects are the main unit of permissions: groups are granted project-level permissions. Projects are also the main unit of the Flow: a job builds datasets, models, and folders of a project, from other sources in the project.

There are cases, however, when you want to have objects (datasets, models, folders, model evaluation stores, …) that are created in a project but used in another project.

  * In some of these cases, the same users will have access to both projects. This multiple-projects architecture is then most useful to keep smaller manageable projects. For example, you could want to have an “upstream” project where the initial data preparation takes place and a “downstream” project where the business analysis takes place

  * In other cases, different users have access to both projects. For example, you could have an “upstream” project which contains raw, non-anonymized data, with access restricted to a small number of trusted employees. This upstream project produces aggregated anonymized datasets that you want to make available to a large number of business projects, with more relaxed access rights.




Whether there is a security concern or not, cross-project usage of objects is configured in the “Shared objects” settings of the source project.

## Quick and managed sharing

Depending on how you prefer to manage permissions on a given object, two sharing mechanisms are available:

  * Managed sharing: only users with Manage shared objects permissions can share the object from the source project to another project. For each object, they will need to configure to which projects it is shared.

  * Quick sharing: users with Manage shared objects permissions can decide to activate quick sharing on an object. In this case, all users who can see the object will be able to use it and add it to their projects without any other intervention.




## Sharing objects between projects via managed sharing

To share an object from project A to project B with managed sharing, you need to have the Manage shared objects permission on project A. See [Main project permissions](<permissions.html>) for more information.

To see and manage the whole list of shared objects from a project, go to **Project > Security > Shared objects** screen. For each object, you can configure the projects it is shared with.

You can also share individual objects from their Actions menu (“Share” button).

## Sharing objects between projects via quick sharing

Quick sharing can be enabled on any shareable object of a project by a user with Manage shared objects permission on this project. This can be done from the Project’s top-level dropdown > Security > Shared objects screen. The object needs to be added to the list of shared objects beforehand. There is no need to select a target project when quick sharing is enabled on an object.

If quick sharing has been enabled on an object, any user who has the ability to read this object’s content (through the project of origin, through a workspace, through a Data Collection, through another project where it has been shared…) will be able to use it directly in another project. They can do so via the “Share” button from the Right Hand panel of the object or the “Use” button in the Data Catalog or the “Search DSS Items” page.

A user who can see an item but cannot read its content is, however, not allowed to quick share it. This is the case for a dataset that is authorized with the DISCOVER authorization mode and can be found in a Data Collection by a user who has no other access to it.

To deactivate quick sharing for an object, you can go to its original project’s top-level dropdown > Security > Shared objects screen or manage sharing rules via the “Share” button from the right panel of the object. Deactivating quick sharing for an object won’t unshare the object from projects with which it was already shared.

You can unshare an object shared via quick sharing by removing the desired sharing rule on the original project’s top-level dropdown > Security > Shared objects screen, or via the shared object’s Actions menu in the target project (“Delete” button), the same way you would do for an object shared through managed sharing.

Note

Quick sharing can be disabled for all projects by DSS administrators (in Administration > Settings > Other > Misc. > Access & request).

## Permissions on shared objects

When an object is shared from project A to project B, analysts of project B have read-only access to the object.

### Dataset

Analysts of project B can:

  * View the dataset’s data, with arbitrary sampling settings

  * Use it in recipes

  * Build charts on it

  * Use it in a visual analysis

  * Build machine learning models on it

  * Use it in notebooks

  * Export it (if they have “Export datasets data” permission in project B)

  * Put it on a dashboard




They cannot:

  * View or change the settings of the dataset

  * Build the dataset

  * Clear the dataset

  * View or change the metrics

  * “Analyse” in explore on the full data (only on the sample)




### Managed folder

Analysts of project B can:

  * View the contents of the folder

  * Use it in recipes

  * Use it in notebooks

  * Put it on a dashboard




They cannot:

  * Upload new files or remove files

  * Build the folder

  * View or change the metrics




### Saved model

Analysts of project B can:

  * View the reports of the model

  * Use it in a scoring or evaluation recipe

  * Put it on a dashboard




They cannot:

  * Retrain the model

  * Modify the active version

  * Remove old versions

  * View or change the metrics




### Agents & Agent tools

Analysts of project B can:

  * Use the following Agent tools without access to project A:

>     * Knowledge Bank Search
> 
>     * Model Predict
> 
>     * API endpoint
> 
>     * LLM Mesh Query using an LLM from a connection, a fine-tuned LLM, or a retrieval-augmented LLM (whose underlying model fulfills the same condition)
> 
>     * Dataset Lookup
> 
>     * Dataset Append
> 
>     * Calculator
> 
>     * Send message

  * Use Agents and other tools (including LLM Mesh Query using an Agent) if they have at least “Read project content” access to project A




### Other objects

Scenarios, Jupyter notebooks, Webapps and R Markdown reports can only be added to a dashboard by analysts of project B.

Wiki articles, Visual analyses, SQL notebooks, recipes, API services and bundles cannot be shared.

## Initiating an object-sharing request

You can request to use in your projects, any object that you can already access. This includes:

  * datasets and models contained in projects where you have the Read project content permission

  * datasets you can access through dashboards

  * datasets you can access through workspaces

  * datasets you can access through Data Collections (including datasets that are only discoverable)




You can do so through a “Share (Request)” button on the right panel which opens a modal.

You then have to select a target project where the object will be shared.

Only projects on which you have Write project content permission are available as a target.

Note

To be able to request access to objects, the option _Requests to use objects_ must be enabled, either by an administrator in the instance’s settings in **Other > Misc. > Access & requests** with the option or by a project administrator on a project level in **Project > Security > Shared objects**.

## Managing an object-sharing request

Project administrators and users with Manage shared objects project permission can manage sharing requests from within the project’s security section or by handling the request in the requests inbox.

Note

Automatic request status updates

In the following cases, the status of the request will be automatically updated in the requests inbox:

  * Request is considered as approved if the object is shared with the target project (regardless of how it’s done)

  * Request is rejected if the target project is deleted, the object is deleted, or if the requester is deleted

  * Request is deleted if the object’s project is deleted

---

## [security/sso]

# Single Sign-On

Note

DSS SSO implementation is an Authenticator and a User Supplier. See [Authentication](<authentication/index.html>) documentation for more details.

Single sign-on (SSO) refers to the ability for users to log in just one time with one set of credentials to get access to all corporate apps, websites, and data for which they have permission.

By setting up SSO in DSS, your users will be able to access DSS using their corporate credentials.

SSO solves key problems for the business by providing:

>   * Greater security and compliance.
> 
>   * Improved usability and user satisfaction.
> 
> 


Delegating the DSS authentication to your corporate identity provider using SSO allows you to enable a stronger authentication journey to DSS, with multi-factor authentication (MFA) for example.

DSS supports the following SSO protocols:

>   * OpenID Connect (OIDC)
> 
>   * SAML v2
> 
>   * SPNEGO / Kerberos
> 
> 


Warning

We strongly advise using SAML or OIDC rather than SPNEGO / Kerberos. Setting up SPNEGO is fairly difficult and may interact with connecting to Secure Hadoop clusters.

## Users supplier

In SSO mode, users don’t need to enter their password. Instead, the SSO system provides the proof that the person performing the query is who she pretends to be, and DSS verifies this proof.

However, DSS needs to map this identity to one of its users. This concept in DSS is called user supplying.

### Using SSO provisioning

DSS is able to provision users from the identity returned during the SSO protocol. It is not necessary to configure additional user sources.

By default, your identity provider usually only includes basic user attributes into the identity returned to DSS. If you want to map the user groups, you will need to contact the identity provider administrator to include the groups in the identity claims.

Warning

SSO can act as a user supplier and therefore provision/synchronize users. Since those operations can only happen during the login phase, you will therefore not be able to trigger a user synchronization manually from the UI or the API on SSO users.

### Using an other external user source

You may choose to associate SSO with an external user source, like LDAP or Azure AD. Users will be able to authentication with SSO and be provisioned/synchronized from the given external source.

It is also possible to enable SSO provisioning and still have other external user sources. In that scenario, [set the order number](<authentication/index.html#supporting-multiple-authenticators-and-user-suppliers>) of SSO to be higher than the other sources (so a larger order number).

### Using local users

If you don’t want to enable SSO provisioning or any other user suppliers like LDAP, you need to create DSS user accounts for the SSO users. When creating these users, select “SSO” as source type. This way, only a login and display name are required, you don’t need to enter a password (since DSS delegates authentication in SSO mode).

## OpenID Connect (OIDC)

### About OIDC

#### Glossary

  * **OIDC** : **O** pen**ID** **C** onnect

  * **IDP** : An **Id** entity **P** rovider is a system entity that creates, maintains, and manages identity information for principals and also provides authentication services to relying applications within a federation or distributed network

  * **End-user** : The end user is the entity for whom we are requesting identity information. In our case, it is the DSS user that need to login to access DSS.

  * **OIDC Client** : Also called Relying party **RP** in the OIDC specification, the OIDC client is the application that relies on the IDP to authenticate the end user. In our case, it is DSS.

  * **ID Token** : Similar to a ID card or passport, it contains many required attributes or claims about the user. This token is then used by DSS to map the claims to a corresponding DSS user. Digitally signed, the ID token can be verified by the intended recipients (DSS).

  * **Claim** : In DSS context, claims are name/value pairs that contain information about a user.

  * **Scope** : In the context of OIDC, scope references a set of claims the OIDC client needs. Example: email

  * **Authorization code** : During the OIDC protocol, the authorization code is generated by the IDP and sent to the end-user, which passes it to the OIDC client. It is then used by the OIDC client, who sends the authorization code to the IDP, and receives in exchange an ID token. Using an intermediate authorization code allows the IDP to mandate the OIDC client to authenticate itself in order to retrieve the ID token.

  * **Confidential client** : An OIDC client with the capacity to exchange the authorization code for an ID token in a secured back channel. This is the case of DSS.

  * **Public client** : An OIDC client not able to store secret securely and needs to exchange the authorization code for an ID token in a public channel. DSS is not a public client.

  * **PKCE** : **P** roof **K** ey for **C** ode **E** xchange is an extension of the OIDC protocol, to allow public clients to exchange the authorization code in a public channel.




#### Compatibility

DSS OIDC integration has been successfully tested against the following OIDC identity providers:

  * OKTA

  * Azure Active Directory

  * Google G.Suite

  * Keycloak




#### OIDC features supported by DSS

  * authorization code grant flow

  * simple string claims in the ID token

  * non encrypted or signed authentication requests

  * ID token signed with RSA or EC

  * DSS behind a proxy

  * response mode supported: query or fragment

  * token endpoint auth method supported: client secret basic or client secret POST

  * confidential OIDC client only (PKCE not supported)




#### How OIDC looks like with DSS

Once configured for OIDC SSO, DSS acts as an OIDC client, which delegates user authentication to an identity provider.

  1. When the end user tries to access DSS and is not authenticated yet, DSS will redirect him to the IDP. The URL used will be the authorization endpoint of the IDP, which some specific GET parameters specific to the DSS setup.

  2. The IDP will validate the GET parameters and will present a login page to the user. The authentication journey now depends on your IDP capabilities. Sometimes, when already logged-in on the IDP side, the login page is skipped and the user may not see the redirection to the IDP.

  3. The IDP has authenticated the end user and will redirect the user to DSS with an authorization code. Depending of your OIDC client setup in your IDP, the code may be passed through via the query parameters or the fragment.

  4. The front-end of DSS will parse and send the parameters, including the authorization code, to the DSS backend.

  5. The DSS backend will exchange this authorization code for an access token, by calling the token endpoint with the credentials you previously have configured in DSS SSO settings. If successful, the IDP will return an ID token corresponding the end user.

  6. DSS uses the ID token to map the end user to a DSS user. The mapping setup is part of the SSO configuration of OIDC.

  7. DSS creates a user session corresponding to the DSS user. At this point, OIDC is completed and the user session is agnostic of the authentication protocol used.




### Setup OIDC in DSS

To set up OIDC integration, you need:

  * to register a new OIDC Client (sometimes called an ‘application’) for DSS in your identity provider,

  * to configure DSS with the parameters of the identity provider as well as the parameters corresponding to the OIDC client created earlier,

  * to configure which of the user attributes returned by the IDP is to be used as the DSS username, and optionally configure rewrite rules to extract the DSS username from the chosen user attribute.




These steps are individually detailed below.

#### Registering a service provider entry for DSS on the identity provider.

The exact steps for this depend on the identity provider platform which you plan to connect to, and should be performed by your IDP administrator. This entry may also be called an “OIDC application”. You will sometimes be asked to select the type of application, which would be in our case a web application.

You will typically need:

  * to setup the OIDC client to use the authorization code grant flow,

  * a client ID,

  * a client secret,




Note

The OIDC client needed by DSS is a confidential client (opposite of public client). Meaning DSS is able to protect the client secret, by exchanging the authorization code (and using the secret in the request) from the backend.

  * setup the redirect URI BASE_URL/login/openid-redirect-uri/,




Note

This URL must be configured as BASE_URL/login/openid-redirect-uri/, where BASE_URL is the URL through which DSS users access this DSS instance.

For example, if DSS is accessed at https://dataiku.mycompany.corp/, the OIDC redirect uri must be defined as https://dataiku.mycompany.corp/login/openid-redirect-uri/.

Note that some identity providers require the redirect URI to use the HTTPS scheme.

  * associate some OIDC scopes to the OIDC client. Some IDPs refer to these as permissions, like user.read. You will need to setup the scope openid as well as some identity claims. You must ensure that DSS is able to access and retrieve all the user attributes needed to identify the corresponding user in DSS.




Note

DSS will need to map to an existing user from one of the user claims. It’s important that you allow DSS to retrieve a claim that is easily mappable to the username. A good candidate is email, of which you can strip the part after ‘@’ to compose a unique identifier for usernames.

#### Configuring DSS for OIDC authentication.

OIDC configuration is in the “Settings / Security & Audit / User login & provisioning / SSO” screen.

Select “Enable”, choose protocol “OIDC”.

##### IDP configuration

Contact your IDP administrator to retrieve this information or check your IDP documentation.

The easiest way to setup the IDP configuration is using the well-known endpoint: The OIDC standard defines an endpoint, called well-known, to discover the IDP configuration. DSS lets you enter the well-known endpoint of your IDP and fetch the rest of the configuration for you. If you don’t know the well-known endpoint, you can still enter the other configurations manually, the well-known input being optional.

  * **Well-known URL** : Optional, defines the well-known endpoint, which is a URI ending with /.well-known/openid-configuration. Click Fetch IDP configuration to auto-complete the rest of the IDP configuration.

  * **Issuer** : The issuer is a URI to identify the IDP. It is used in particular to verify that the ID token was signed by the right IDP. Per specification, the issuer is a URI, for which you can append the path /.well-known/openid-configuration to get the IDP well-known endpoint.




Note

Tips: If you have an example of a valid ID token, you can read its content with [jwt.io](<https://jwt.io>) and find the issuer value behind the iss claim. You can then build up the well-known URI by appending /.well-known/openid-configuration to it.

  * **Authorization endpoint** : The authorization endpoint is used to redirect the user to the IDP for the authentication.

  * **Token endpoint** : The token endpoint is used by DSS to exchange the authorization code with an ID token. This endpoint will be called from the backend of DSS. If DSS is behind a proxy, please make sure DSS is able to call this endpoint.

  * **JWKs URI** : The JWKs URI is a way for the IDP to specify all its public keys. This is used by DSS to verify the signature of the ID token.




Examples of well-known endpoints:

  * **Google** : <https://accounts.google.com/.well-known/openid-configuration>

  * **Azure** : <https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration>

  * **Okta** : <https://common.okta.com/.well-known/openid-configuration>

  * **Keycloak** : <https://your-keycloak-instance/auth/realms/your-realm/.well-known/openid-configuration>




Note

In some case, the well-known can be the same for everyone, like for google. In other scenario, the IDP will generate a dedicated one for your application, like Okta or Azure for which it is configured by tenant.

##### OIDC Client configuration

In the previous section, you created an OIDC client. Use this client to complete the following section:

  * **Token endpoint auth method** : This is the authentication method that DSS will use to specify the credentials during the token exchange. Most of the time, when supporting client secret, the IDP will allow either of the two methods. Leave this field by default if you are unsure, as it will most likely work.

  * **Client ID** : the client ID generated by the IDP. In the IDP portal, it could be named application id. Refer to your IDP documentation for more details on how to retrieve your client ID.

  * **Client secret** : The client secret your IDP generated for this client. Sometimes, it is not generated by default by your IDP (like Azure). In this case, look for a section ‘secrets’ in your IDP setup for the OIDC client.

  * **Scope** : Specify the scope that DSS needs to use during the login flow. As a minima, it should contain openid. The scope contains a list of scopes separated by spaces.




Note

The scope is essential for doing the mapping with the username, as it defines the user claims the IDP needs to send back to DSS. We recommend to add either email or/and profile, two common scopes supported by most IDPs. Most IDPs will mandate that you add some dedicated permissions before associating those scopes to your OIDC client. See your IDP documentation for more details.

Note

The list of scopes supported by your IDP is listed in the well-known, under the attribute claims_supported. Even if they are supported, you will still need to authorise the OIDC client to use those scopes, via your IDP portal.

##### Examples of scopes by IDPs

For Google, Azure, Okta and Keycloak, the simplest scope is email, which will return two claims - email and email_verified. Set in Identifier claim key the claim email.

Azure, Okta and Keycloak also support another claim called preferred_username, which is returned as part of the profile scope.

Resources:

  * [Google documentation](<https://developers.google.com/identity/protocols/oauth2/openid-connect#an-id-tokens-payload>)

  * [Azure documentation](<https://docs.microsoft.com/en-us/azure/active-directory/develop/id-tokens>)

  * [Okta documentation](<https://developer.okta.com/docs/reference/api/oidc/#scope-values>)

  * [Keycloak documentation](<https://www.keycloak.org/docs/latest/securing_apps/>) (search for principal-attribute in the page)




#### Mapping to the DSS user

When DSS successfully retrieves the ID token from the IDP, it needs to map it to a user in DSS. The ID token will contain user claims that depend on the scope you defined earlier. The following two fields will help DSS map the ID token to a DSS user:

  * **Identifier claim key** : Depending on the scope you configured, the IDP will return different user claims. Define here the one you want to use to map to the corresponding username in DSS. One easy way that works for most IDP, is to use the email and then strip the part after the ‘@’.

  * **Login remapping rules** : Map a claim received from the IDP to your username format. Example: stripping the part after ‘@’ in an email. You may not need this field if your IDP is returning a user claim that matches exactly the username (it’s the case of keycloak if you use the preferred_username claim for example).




Warning

The Login remapping rules are evaluated in order. If you have multiple rules and their regexes overlap (ie ^(.*)@mycompany.corp$ and ^(.*)$), make sure the most specific one is defined first.

Note

Example of mapping if you choose the email as identifier claim: ^(.*)@mycompany.corp$ -> $1

Note

DSS logs all the claims received from the IDP in the backend log file, which may help configuring the Identifier claim key and the mapping for it.

#### User Supplier

DSS SSO implementation is able to supply users from an SSO context. Meaning you can configure DSS to auto-provision or synchronize users when a user authenticates via SSO.

Once you have enabled the Login-time provisioning and/or Login-time resync options, you must configure the mapping between the ID token (the identity provider’s response to DSS) and the representation of an identity in DSS. See your OpenID identity provider’s documentation or contact your identity provider’s administrator for the required information.

#### Testing OIDC SSO

  * Configure OIDC integration as described above

  * Access the DSS URL from another browser or an anonymous window

  * You should be redirected to the IDP for authentication, then back to the DSS redirect URL, then to the DSS homepage

  * If login fails, check the logs for more information




Important

Once SSO has been enabled, if you access the root DSS URL, SSO login will be attempted. If SSO login fails, you will only see an error.

You can still use the regular login/password login by going to the `/login/` URL on DSS. This allows you to still log in using a local account if SSO login is dysfunctional.

## SAML

When configured for SAML single-sign-on, DSS acts as a SAML Service Provider (SP), which delegates user authentication to a SAML Identity Provider (IdP).

### About SAML

#### Compatibility

DSS has been successfully tested against the following SAML identity providers:

  * OKTA

  * PingFederate PingIdentity (see note below)

  * Azure Active Directory

  * Google G.Suite

  * Microsoft Active Directory Federation Service (tested against Windows 2012 R2)

  * Auth0

  * Keycloak




Note

For AD FS, it is mandatory to configure at least one claim mapping rule which maps to “Name ID”, even if another attribute is used as the DSS login attribute.

DSS does not support SAML encryption.

### Setup SAML in DSS

To set up SAML integration, you need:

  * to register a new service provider entry on your SAML identity provider, for this DSS instance. This entry is identified by a unique “entity ID”, and is bound to the SAML login URL for this DSS instance.

  * to configure DSS with the IdP parameters, so that DSS can redirect non logged-in users to the IdP for authentication, and can authentify the IdP response

  * optionally, to configure which of the user attributes returned by the IdP is to be used as the DSS username, or configure rewrite rules to extract the DSS username from the chosen IdP attribute




These steps are individually detailed below.

#### Registering a service provider entry for DSS on the identity provider.

The exact steps for this depend on the identity provider platform which you plan to connect to, and should be performed by your IdP administrator. This entry may also be called a “SAML application”.

You will typically need:

  * an “Entity ID” which uniquely represents this DSS instance on the IdP (sometimes also called “Application ID URI”).

This entity ID is allocated by the IdP, or chosen by the IdP admin.

  * the SAML login URL for DSS (“Assertion Consumer Service Endpoint”, which may also be called “Redirect URI”, “Callback URL”, or “ACS URL”).

This URL _must_ be configured as
        
        BASE_URL/dip/api/saml-callback

where `BASE_URL` is the URL through which DSS users access this DSS instance.

For example, if DSS is accessed at <https://dss.mycompany.corp>, the SAML callback URL must be defined as



    
    
    <https://dss.mycompany.corp/dip/api/saml-callback>

Note that some SAML identity providers require the callback URL to use the HTTPS scheme.

As an additional step, you may also have to authorize your users to access this new SAML application at the IdP level.

Finally, you will need to retrieve the “IdP Metadata” XML document from the identity provider, which is required to configure DSS (also called “Federation metadata document”).

#### Configuring DSS for SAML authentication.

SAML configuration is in the “Settings / Security & Audit / User login & provisioning / SSO” screen.

Select “Enable”, choose protocol “SAML” and fill up the associated configuration fields:

  * IdP Metadata XML : the XML document describing the IdP connection parameters, which you should have retrieved from the IdP.

It should contain a <EntityDescriptor> record itself containing a <IDPSSODescriptor> record.

  * SP entity ID : the entity ID (or application ID) which you have configured on the IdP in the step above

  * SP ACS URL : the redirect URL (or callback URL) which you have configured on the IdP in the step above




Warning

You need to restart DSS after any modification to the SAML configuration parameters.

##### Optional: configuring signed requests

If your IdP requires it (this is generally not the case) you can configure DSS to digitally sign SAML requests so that the IdP can authentify them.

For this, you need to provide a file containing a RSA or DSA keypair (private key plus associated certificate), which DSS will use for signing, and provide the associated certificate to the IdP so that it can verify the signatures.

This file must be in the standard PKCS#12 format, and installed on the DSS host. It can be generated using standard tools, as follows:
    
    
    # Generate a PKCS12 file containing a self-signed RSA key and certificate with the "keytool" java command:
    keytool -keystore <FILENAME>.p12 -storetype pkcs12 -storepass <PASSWORD> -genkeypair -keyalg RSA -dname "CN=DSS" -validity 3650
    
    # Generate a PKCS12 file containing a self-signed RSA key and certificate with the openssl suite:
    openssl req -x509 -newkey rsa:2048 -nodes -keyout <FILENAME>.key -subj "/CN=DSS" -days 3650 -out <FILENAME>.crt
    openssl pkcs12 -export -out <FILENAME>.p12 -in <FILENAME>.crt -inkey <FILENAME>.key -passout pass:<PASSWORD>
    

You then need to complete the DSS configuration as follows:

  * check the “Sign requests” box

  * Keystore file : absolute path to the PKCS#12 file generated above

  * Keystore password : PKCS#12 file password

  * Key alias in keystore : optional name of the key to use, in case the PKCS#12 file contains multiple entries




#### Choosing the login attribute

Upon successful authentication at the IdP level, the IdP sends to DSS an assertion, which contains all attributes of the logged in user. Each attribute is named. You need to indicate which of the attributes contains the user’s login, that DSS will use.

Note that DSS logs all attributes received from the SAML server in the backend log file, which may help configuring this field.

If this field is left empty, DSS will use the default SAML “name ID” attribute.

#### Login remapping rules

Optionally, you can define one or several rewriting rules to transform the selected SAML attribute into the intended DSS username. These rules are standard search-and-replace Java regular expressions, where `(...)` can be used to capture a substring in the input, and `$1`, `$2`… mark the place where to insert these captured substrings in the output. Rules are evaluated in order, until a match is found. Only the first matching rule is taken into account.

A standard use case for such rewriting rules would be to strip the domain part from email-address-like attributes. For example, configuring the following rule:
    
    
    ([^@]*)@mydomain.com     ->     $1
    

would rewrite a SAML attribute `first.last@mydomain.com` into `first.last`, and do nothing on SAML attribute `first.last@otherdomain.com` (as the left-hand part of the rule would not match).

Warning

The Login remapping rules are evaluated in order. If you have multiple rules and their regexes overlap (ie ^(.*)@mycompany.corp$ and ^(.*)$), make sure the most specific one is defined first.

#### User Supplier

DSS SSO implementation is able to supply users from an SSO context. Meaning you can configure DSS to auto-provision or synchronize users when a user authenticates via SSO.

Once you have enabled the Login-time provisioning and/or Login-time resync option, in the SAML context you need to configure the mapping between the SAML assertion (the identity provider’s response to DSS) and the DSS representation of an identity. (See the documentation of your identity provider or contact your identity provider’s administrator for the required information).

#### Testing SAML SSO

  * Configure SAML integration as described above

  * Restart DSS

  * Access the DSS URL from another browser or an anonymous window

  * You should be redirected to the IDP for authentication, then back to the DSS redirect URL, then to the DSS homepage

  * If login fails, check the logs for more information




Note

Once SSO has been enabled, if you access the root DSS URL, SSO login will be attempted. If SSO login fails, you will only see an error.

You can still use the regular login/password login by going to the `/login/` URL on DSS. This allows you to still log in using a local account if SSO login is dysfunctional.

If the SAML configuration is invalid (in particular if the IdP metadata XML is malformed) DSS will not restart. You will need to manually disable SAML in the general-settings.json configuration file as described below.

### Troubleshooting

No details are printed in case of wrong SSO configuration. All details are only in the logs.

Common issues include:

#### Assertion audience does not include issuer

This means that the EntityID declared in the DSS SP configuration does not match the expected EntityID / audience at the IdP level.

#### Response is destined for a different endpoint

Check the “ACS URL” in the DSS SP configuration. It must match the response destination in the IdP answer, ie generally the callback declared in the IdP.

This error message also shows up when the IdP does not include a “Destination” attribute in the response message. This attribute is mandatory and should match the DSS SAML callback URL.

When using PingFederate PingIdentity as an IdP make sure to **uncheck** the _Always Sign the SAML Assertion_ property when defining the DSS endpoint, to ensure that a Destination attribute is included in the Response message.

#### DSS would not start after configuring SAML SSO

In some cases (in particular, entering invalid XML in the IdP Metadata field), an incorrect SAML configuration may prevent the DSS backend to start. In such a case, open the `DSS_DATADIR/config/general-settings.json` configuration file with a text editor, locate the `"enabled"` field under `"ssoSettings"` and set it to `false`. You should then be able to restart and fix the configuration using the DSS interface.

#### Login fails with “Unknown user <SOME_STRING>”

This typically means that SAML authentication of the user was successful at the IdP level, but that the returned attribute does not match any username in the DSS database (or in the associated LDAP directory if one has been configured).

It might be because you did not select the correct SAML attribute name in the DSS SAML configuration. You can check the list of attributes returned by the IdP in the DSS backend log file.

It might be because the attribute rewrite rule(s) did not lead to the expected result. This can also be checked in the DSS backend log file.

It might be because no DSS user exists with this name. You can create one in the DSS “Security / Users” page, using type “Local (no auth, for SSO only)”.

#### No acceptable Single Sign-on Service found

DSS only supports the HTTP-Redirect binding for SAML requests, and requires one such binding to be defined. If configured with an IdP metadata record which does not contain such a binding, the DSS backend will fail to start and output a `SAMLException: No acceptable Single Sign-on Service found` message in the backend log file.

To fix that, you need to edit the IdP Metadata record and add a `SingleSignOnService` XML node inside the `IDPSSODescriptor` node, as follows:
    
    
    <md:EntityDescriptor ...>
        <md:IDPSSODescriptor ...>
            ...
            <md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="SOME_VALID_REDIRECT_URL"/>
        </md:IDPSSODescriptor>
    </md:EntityDescriptor>
    

This entry defines the URL to which DSS will redirect users which attempt to connect without a currently valid authentication cookie. Any valid URL can be configured in it, you can for example use the address to the login page for your IdP.

Note that this address will never be used if users only connect to DSS through IdP-initiated SAML connections. It is nevertheless mandatory to configure one.

## SPNEGO / Kerberos

Warning

While this is somewhat related to Kerberos securitization of secure Hadoop clusters, these are two very different and independent features

Warning

We strongly advise using SAML SSO rather than SPNEGO / Kerberos. Setting up SPNEGO is fairly difficult, requires specific configuration of the user browsers, and may interact with connecting to Secure Hadoop clusters.

### Keytab mode

The recommended way to setup SPNEGO authentication is to create a service principal for DSS in your Kerberos database, along with an associated keytab file. This keytab allows DSS to authenticate the users identity through the Kerberos login session of their browser.

The principal and keytab will be provided by your Kerberos administrator. The keytab file must be installed on the DSS machine, in a filesystem location readable by, and private to, the DSS Unix service account.

You may also have to provide a krb5.conf file if the server does not have a suitable one in the default system location. This file will also be provided by your Kerberos administrator.

Note

The Kerberos principal used by DSS for SPNEGO authentication MUST be of the form `HTTP/<dss_hostname>@<realm>` where <dss_hostname> is the hostname of the DSS service URL as seen from the client’s browser.

On Windows Active Directory, service principals are created by:

  * creating a user account for DSS in the domain

  * associating the required service principal to this account, using the command-line ‘setspn’ tool (you can also do it using extra arguments to the ‘ktpass’ command which issues the Kerberos keytab file).




### Custom JAAS mode

For advanced use cases not covered by the previous mode. Requires advanced knowledge of Kerberos configuration for Java.

### Login remapping rules

Optionally, you can define one or several rewriting rules to transform the user identity provided by SPNEGO (which is the Kerberos principal of the user, typically [username@REALM](</cdn-cgi/l/email-protection#e79294829589868a82c1c4d4d0dcc1c4d2d5dcc1c4d3dfdcb5a2a6abaa>)) into the intended DSS username.

These rules are standard search-and-replace Java regular expressions, where `(...)` can be used to capture a substring in the input, and `$1`, `$2`… mark the place where to insert these captured substrings in the output. Rules are evaluated in order, until a match is found. Only the first matching rule is taken into account.

For convenience, a standard rule which strips the @REALM part of the user principal can be enabled by a checkbox in the configuration. This rule is evaluated first, before any regular expression rules.

### Configuring SPNEGO SSO

  * Go to Administration > Settings > LDAP & SSO

  * Enable the SSO checkbox, select SPNEGO, and enter the required information

  * Restart DSS

  * Access the DSS URL

  * If login fails, check the logs for more information




Note

Once SSO has been enabled, if you access the root DSS URL, SSO login will be attempted. If SSO login fails, you will only see an error.

You can still use the regular login/password login by going to the `/login/` URL on DSS. This allows you to log in if SSO login is dysfunctional

Note

You will typically need to perform additional configuration on the user browsers so that they attempt SPNEGO authentication with DSS. This usually includes:

  * making sure the user session is logged on the Kerberos realm (or Windows domain) before launching the browser

  * adding the DSS URL to the list of URLs with which the browser is authorized to authenticate using Kerberos




Refer to your browser documentation and your domain administrator for the configuration procedures suitable for your site.

### Troubleshooting

No details are printed in case of wrong SSO configuration. All details are only in the logs.

SPNEGO failures are notoriously hard to debug because all communication is encrypted, and any error simply leads to decryption failures.

Usual things to double-check:

  * The mapping of `domain_realm` in your krb5.conf

  * The principal in the keytab must match the one declared in DSS

  * The principal in the keytab must be HTTP/<dss_hostname>@<realm> where <dss_hostname> matches the DSS URL hostname.

  * The browser must be configured to allow SPNEGO authentication on <dss_hostname>. In particular, error messages mentioning NTLM authentication failures actually mean that this configuration is not working as expected.

---

## [security/stories-security]

# Stories security

Note

Note that Dataiku Stories is not available in all Dataiku licenses. You may need to reach out to your Dataiku Account Manager or Customer Success Manager.

## Authentication

Stories does not handle authentication by itself.

Instead, it uses the DSS cookie, so a user must first authenticate to DSS.

## Authorization

Stories checks user authorizations against DSS workspaces.

When a user has read access to a workspace, he can read any story in the workspace.

When a user has write access to a workspace, he can write any story in the workspace.

## Internal databases credentials

Credentials of Stories internal databases (redis, clickhouse) are generated and used in the Stories docker container only.

They are not accessible by DSS or any process outside of Stories.

## Audit trail

Stories currently logs the following events in the DSS audit trail:

  * story-datastory-get: logs a story read access

  * story-datastory-get-members: logs a request to list active users on a story

---

## [security/user-profiles]

# User profiles

Each user in DSS has a single “user profile” assigned to it.

Note

User profile is **not a security feature** , but a licensing-related concept. DSS licenses are restricted in number of each profile.

We do not provide any guarantee that the user profile is strictly applied.

For security, use the regular groups authorization model described in this documentation. Do not use user profiles to implement any kind of security.

Depending on your Dataiku license, various user profiles may be available. The exact definition of user profiles that are available depends on your DSS license. In case of any doubt, please contact your Dataiku Account Manager. You may have other profiles available, or only some of them.

Some of the possible profiles are:

  * **Full Designer** : Full Designers have access to all Dataiku features.

  * **Data Designer** : Data Designers have access to most visual features, but not to coding (Python/R) features, nor to some advanced AI and ML features.

  * **Advanced Analytics Designer** : Advanced Analytics Designers have access to most features, except some advanced coding capabilities.

  * **Governance Manager** : Governance Managers can view projects in Dataiku and handle artifacts and sign-off processes in Dataiku Govern.

  * **AI Consumer** : AI Consumers can access dashboards, workspaces, webapps, as well as run [Dataiku Applications](<../applications/index.html>) that Designers have created.

  * **AI Access User** : AI Access Users can only access webapps that have been made available to them, such as [Agent Hub](<../agents/agent-hub.html>).

  * **Technical Account** : Technical Accounts technically have access to all Dataiku features, but may only perform administration / assistance tasks, not productive work. Technical Accounts can also be used as service accounts to run scenarios or webapps.




Some of the older available profiles (which you may have access to if you are an older Dataiku customer) include:

  * **Designer** : Designers have full access to all Dataiku features.

  * **Data Scientist** : Same as Designer.

  * **Data Analyst** : Data Analysts have access to most visual features, but not to coding features nor to AI and ML features.

  * **Reader** : Readers can read the content of projects but cannot perform any kind of modification. They can access dashboards and webapps.

  * **Explorer** : Explorers have the capabilities of readers, and they can also run [Dataiku Applications](<../applications/index.html>) that Designers have created. They can also create their own dashboards and insights, but only based on existing datasets/models/…

  * **Platform Admin** : Platform Admins technically have access to all Dataiku features, but may only perform administration / assistance tasks, not productive work. Note that despite the name, granting the Platform Admin user profile does not automatically grant administration rights.




Other profiles may be available, and not all of these may be available. Please contact your Dataiku Account Manager for any further information.

---

## [security/user-secrets]

# User secrets

There are various cases in which you may want to use, in code recipes, credentials that are specific to a user.

For example:

  * A code recipe or plugin dataset connecting to an external API to fetch data

  * A code recipe or custom exporter that sends data to an external service for custom exports




DSS offers a mechanism for users to enter their credentials in their profile. DSS then encrypts the credentials, and code running under the identity of a given user can then retrieve the decrypted version of the credentials.

User secrets are kept encrypted at rest. See [Passwords security](<passwords-security.html>) for more information.

User secrets are personal and cannot be shared. DSS does not have a concept of “global secrets”.

## Entering user secrets

  * Go to your profile page

  * Go to the “My Account” tab

  * In the “Other credentials”, click “Add”




Each user secret has a Name, and a value. The name is an identifier that must be used by the code that wants to retrieve the secret, in order to identify it. The value is the secret itself.

Click “Ok”, then click “Save”. Your secret is now stored by DSS

## Using user secrets

User secrets can be used in Python or R code

### Python

This can be used in any Python code that runs under the identity of a user:

  * A recipe

  * A notebook

  * A plugin recipe

  * An external public API user using a personal API key

  * …




See [Python](<https://developer.dataiku.com/latest/api-reference/python/index.html> "\(in Developer Guide\)") for more information on using API clients
    
    
    # client is a dataikuapi.DSSClient
    
    auth_info = client.get_auth_info(with_secrets=True)
    
    # retrieve the secret named "credential-for-my-api"
    secret_value = None
    for secret in auth_info["secrets"]:
            if secret["key"] == "credential-for-my-api":
                    secret_value = secret["value"]
                    break
    
    if not secret_value:
            raise Exception("secret not found")
    
    # Use secret_value
    

### R

This can be used in any R code that runs under the identity of a user:

  * A recipe

  * A notebook

  * A plugin recipe



    
    
    library(dataiku)
    
    auth_info = dkuGetAuthInfo(with_secrets = TRUE)
    
    # Find the correct secret
    secret <- auth_info$secrets[lapply(auth_info$secrets, function(d) { d$key == "credential-for-my-api"}) == TRUE]
    secret_value <- secret[[1]]$value
    
    # Use secret_value