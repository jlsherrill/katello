# Content Views #

What problems do a content view solve?
 * Allow you stage content through environments (Dev, Test, Production)
 * Allow you to filter the contents of a repository (remove a particular package, blacklist certain errata, etc..).
 * Allow you to have multiple snapshots of the same product or repository

## Definitions ##


 * Content View - snapshot of one or more repositories with or without filters applied
 * Content View Definition - a list of products/repositories and filters used for generating "Content Views"
 * Publishing - Content View Definitions are 'published' to a Content View.  Products and repositoires are cloned with filters applied.


## General Workflow ##

First create a product and repository in library and populating it with content (by syncing it or uploading content to it).
A system can now register directly to library and recieve that content.  Updates will be available as soon as new content is synced or uploaded.

To utilize content views for filtering and snapshoting:

1. Create a Content View Definition
2. Add the desired product/repository to the Content View Definition
3. Publish the definition to a Content View
4. Subscribe the system to the content view

At this point the system will no longer be getting content directly from Library, but from the content view. Updates to library will not affect this system.


# Content View Definition #

A content view definition is the 'recipe' for producing a content view.  
Entire or products or individual repositories are added along with filters that help define what packages and puppet content are included.

## Creating a Content View Definition ##

To Create a Content view Definition from the Web UI, Navigate to:

Content > Content View Definitions

![Creating a definition](content_views/definition_create.png)

From the cli:

```katello -u admin -p admin  content definition create --name="Custom RHEL" --org=ACME_Corporation```


## Adding a Product or Repository ##

Adding a product to a Content View Definition means whenever a Content View is published, all of the repositories contained within are included in the content view.
If a new repository is added to the product, it will automatically be included in the next publish or refresh without any addition effort.

Adding a repository within a product means that only that repository will be included within the Content View upon publishing or refreshing.

To add a product or repository from the web ui, navigate to:

Content > Content View Definitions > Select the desired content view definition > Content (within sub navigation)

![Adding a product and/or repository to a definition](content_views/definition_repo_product.png)

From the cli, adding a product:

```
katello -u admin -p admin content definition add_product  --org=ACME_Corporation --name="Custom RHEL"
                                                          --product="Red Hat Enterprise Linux Server"
```

From the cli, adding a repository:

```
katello -u admin -p admin content definition add_repo  --org=ACME_Corporation --name="Custom RHEL"
                                                       --product="Red Hat Enterprise Linux Server"
                                                       --repo=""Red Hat Enterprise Linux 6 Server RPMs x86_64 6Server"
``` 

## Creating a filter ##

If you are just wanting to use content views as snapshots, filters are unecessary.  If, however, you want to filter what contents make it into the view, such as blacklisting a package by name or version, or blacklisting errata by date or type, filters can help accomplish these tasks.


## Publishing a Content View Definition##
 
Publishing a content view definition produces a new Content View with a version of 1, created within the Library environment.
To publish a content view definition, simply navigate to Content > Content View Definitions > Select the desired definition > Publish (upper right corner of the details pane)

<SCREENSHOT GOES HERE>

From the cli:

```
katello -u admin -p admin content definition publish --org=ACME_Corporation --name="Custom RHEL" --view_name="My RHEL View" --view_label=my_rhel_view
```


Subscribing a System
--------------------

To subscribe a system that is not currently registered to the content view, simply use subscription manager on the client system and run:

```
subscription-manager register --org=ACME_Corporation --environment=Library/my_rhel_view

```

This would subscribe the system to the Library environment and the my_rhel_view content view.

If the system is already registered, from the UI:

Navigate to Systems > All > Select the desired system > Select Content View from the upper right of the details pane.

<SCREEN SHOT GOES HERE>


If the system is already registered, from the CLI:
```
katello -u admin -p admin system update --content_view_label=my_rhel_view  --name='system name'
```



Promoting a Content View
------------------------

Initially a Content View is published to Library as Version 1.  If you have systems in other environments that would like to consume
this content view, it will need to be promoted to that environment.  For example, if i have published my content view definition as
"My RHEL View", it created Version 1 in Library.  I could then promote Version 1, into my Dev environment.  Any systems in Dev would be locked
to that version even if the version of "My RHEL View" changed in Library (at least until another promotion occured).  

To promote a content view in the Web UI:
 1. Naviagate to Content > Changesets > Changeset Management
 1. Select the environment from the environment selector that you want to promote from
 1. Select "New Changeset" and provide a name
 1. Find the desired content view on the left and click 'add'
 1. Click review on the bottom 'action' bar on the right pane
 1. Click promote on the bottom 'action' bar on the right pane

<SCREEN SHOTS GO HERE> 



To promote a content view in the CLI:
```
katello -u admin -p admin content view promote --org=ACME_Corporation --name="My RHEL View" --environment=Dev
```

Refreshing a content View
-------------------------

Refreshing a content view re-publishes the definition into an existing content view.  For example, if you have published "My RHEL View" and
new errata are released and synced that you would like to include in your view.  Refreshing the view will replace the existing version of that 
view in Library and replace it with a new version.  Any new content in the definition's repositories will appear in the version, and any new filters will 
be applied.

The versions that have been promoted to environments after Library will not be affected.  For example, if "My RHEL View" has Version 1
in Production, Version 2, in Dev and Version 3 in Library, refreshing the view would replace Version 3 in Library with a new version, 4.

Once the refresh is complete, any systems subscribe to the content view in Library will immediately have access to the new content.

To refresh a content view from the web UI:

Navigate to Content > Content View Definitions > Select the desired content view definition > Locate the desired content view and click 'refresh' on the right hand side of the pane.

<SCREENSHOT GOES HERE>

To refresh a content view from the CLI:
```
katello -u admin -p admin content view refresh --org=ACME_Corporation --name="My RHEL View"

```



