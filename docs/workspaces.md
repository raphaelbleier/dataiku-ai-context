# Dataiku Docs — workspaces

## [workspaces/index]

# Workspaces

Workspaces are a streamlined access point through which stakeholders can easily find and access AI-driven insights and tools across all projects on a DSS instance. Making it easier for analytics teams to distribute their work to external audiences is key to integrating data and AI throughout an organization.

In a workspace, you’ll see the objects that have been shared there from a variety of DSS projects like **Applications, dashboards, webapps, datasets, and wiki articles**. In addition, **external** links can also be shared into a workspace. It can be accessed with **Workspace** application menu or from the home page. According to the DSS instance setup, you will see the list of workspaces available to you and according to your roles and privileges you will be able to:

  * Manage Workspaces

  * Sharing objects into Workspaces

  * Collaborate with local discussions on workspaces and objects




See also:

See also

For more information, see the [Concept | Workspaces](<https://knowledge.dataiku.com/latest/collaborate/workspaces/concept-workspaces.html>) article in the Knowledge Base.

---

## [workspaces/managing]

# Managing Workspaces

Workspaces can be created by anyone whose security group has been granted [permission](<../security/permissions.html>) to create workspaces by the instance admin in **Global group permissions**.

## Workspace settings

To populate your workspace with members and to help orient them, you can edit the workspace settings. If you are an Admin in a workspace, you can change the workspace’s name, give it a description, change the workspace icon’s color, and manage users.

## Managing Workspace Users

If you click on a workspace’s user list, you’ll see the full list of users and groups in the workspace and their roles. If you are a workspace Admin, you can add/remove DSS users and groups to this list of users and change their roles.

## Workspace Roles

Within a workspace, there are 3 types of roles: **Admins, Contributors, and Members.**

  * Admins control access to the workspace by adding and removing users. They also assign roles to users in the workspace (Admin, Contributor or Member).

  * Contributor can share content into a workspace. In order to share objects from a DSS project, a Contributor needs to have permission from the project owner; this is granted separately from workspace membership, and is granted at the project-level. See ‘Sharing DSS objects into a workspace’ for more information.

  * Members can access and interact with content in the workspace.




## Permissions

Everyone in a workspace is granted a **read** permission on objects and is able to create and contribute to [discussion threads](<../collaboration/discussions.html>). If a DSS user has more permissions on an object, previously granted through other types of project access, they’ll be able to open the object in ‘project view’ with the button **GO TO SOURCE** and perform actions there.

## Sharing workspaces via email

You can also invite non-DSS users to your workspace via email.

If a valid mail channel (e.g. SMTP) is configured in Administration > Settings > Notifications & Integrations, an invitation will be sent to the specified email.

Once the user registers with that email, they will be granted access to the workspace.

Invitations by email can be disabled on the **Administration > Settings > Access & requests** page.

---

## [workspaces/organizing-content]

# Organizing Workspace Content

Once content has been shared to a workspace, you can organize it to make navigation easier for other users.

## Pinning objects

Admins and Contributors can pin important workspace objects to make them easier to spot. Pinning is a workspace-level action: it highlights the object inside the workspace without changing the source object in its project.

Pinned objects can be unpinned at any time, and all workspace users can use the pin filter to show only pinned content.

To make pinned content stand out even more, users can also switch the workspace grouping to **Pinned first**. This view displays pinned objects in a dedicated section before the rest of the workspace content.

## Workspace tags

Workspace tags are labels attached to an object within a workspace. They help organize shared content and make it easier for users to filter the workspace.

Workspace tags are independent from the tags on the source DSS object. When sharing supported objects, you can optionally copy the source tags into workspace tags as an initial starting point.

This copy happens only when the object is added to the workspace. Later changes to tags on the source object are not synchronized to the workspace object, and changes to workspace tags do not affect the source object.

---

## [workspaces/sharing-to-workspaces]

# Sharing DSS objects into a workspace

In order to provide proper governance over access and sharing, the ability to [share objects](<../security/permissions.html>) into a Dataiku Workspace is managed at the project level.

Workspaces can be accessed either through the application menu or from the home page. You’ll see the list of workspaces you belong to and, according to your roles and privileges, will be able to manage workspaces, and share objects into workspaces.

Once granted, a user can share DSS objects into a workspace either from the object’s Right Pane within the project or from the (+) button within the workspace. The DSS object will appear in the list of workspace items once it has been successfully added.

Once an object is shared with a Dataiku Workspace, it is shared with equal visibility among all users in the workspace, regardless of role.