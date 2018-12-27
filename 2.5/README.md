Ruby 2.5 Jekyll S2I Container Image
===================================

This container image extends the Ruby 2.5 [S2I](https://github.com/openshift/source-to-image)
base image to build and serve Jekyll based web sites.  Users can choose between
RHEL and CentOS based builder images.  In either scenario, the required base images
are located below:

*  [Red Hat Container Catalog](https://access.redhat.com/containers/#/registry.access.redhat.com/rhscl/ruby-25-rhel7)
   as registry.access.redhat.com/rhscl/ruby-25-rhel7.

*  [Docker Hub](https://hub.docker.com/r/centos/ruby-25-centos7/)
   as centos/ruby-25-centos7.

The resulting image can be run to serve the generated site, though it would be
preferable to copy the generated site onto a more appropriate web server such
as nginx or httpd.  If running in OpenShift, this is easily accomplished and
you'll want to follow the OpenShift build and run directions below.

Description
-----------

Ruby 2.5 available as container is a base platform for building and running
various Ruby 2.5 applications and frameworks.  Ruby is the interpreted scripting
language for quick and easy object-oriented programming.  It has many features
to process text files and to do system management tasks (as in Perl). It is
simple, straight-forward, and extensible.

This container image includes an npm utility, so users can use it to install
JavaScript modules for their web applications. There is no guarantee for any
specific npm or nodejs version, that is included in the image; those versions
can be changed anytime and the nodejs itself is included just to make the npm
work.

Usage
---------------------
To build a simple [jekyll-test-site](https://github.com/mrjoshuap/s2i-jekyll/tree/master/2.5/test/jekyll-test-site)
website using standalone [S2I](https://github.com/openshift/source-to-image) and
then run the resulting image with [Docker](http://docker.io) execute:

*  **For RHEL based image**
    ```
    $ s2i build \
        https://github.com/mrjoshuap/s2i-jekyll.git \
            --context-dir=2.5/test/jekyll-test-site/ \
        mrjoshuap/s2i-jekyll:ruby-25-rhel7 \
        jekyll-test-site

    $ docker run -p 4000:4000 jekyll-test-site
    ```

*  **For CentOS based image**
    ```
    $ s2i build \
        https://github.com/mrjoshuap/s2i-jekyll.git \
            --context-dir=2.5/test/jekyll-test-site/ \
        mrjoshuap/s2i-jekyll:ruby-25-centos7 \
        jekyll-test-site

    $ docker run -p 4000:4000 jekyll-test-site
    ```

**Accessing the Generated Website:**
```
$ curl 127.0.0.1:4000
```


OpenShift Deployment
--------------------

Pretend you want a high level of the commands for easy deployment.

Project
-------

For simplicity sake, create and/or reuse an existing OpenShift project.

```
# OCP_PROJECT=my-first-jekyll-site; export OCP_PROJECT
# oc new-project $OCP_PROJECT
Now using project "my-first-jekyll-site" on server "https://192.168.64.8:8443".
...
```

Set Up Base Images
------------------

```
# oc new-app https://github.com/mrjoshuap/s2i-jekyll -l name=s2i-jekyll --context-dir=2.5

# oc logs -f bc/s2i-jekyll
```

Image Streams
-------------

httpd-24-centos7
jekyll-httpd
jekyll-serve
ruby-25-centos7
s2i-jekyll

```
oc create imagestream httpd-24-centos7
oc create imagestream jekyll-httpd
oc create imagestream jekyll-serve
oc create imagestream ruby-25-centos7
oc create imagestream s2i-jekyll
```

Build Configs
-------------

jekyll-httpd                Docker  Dockerfile
jekyll-serve-prod-latest    Source  https://github.com/mrjoshuap/s2i-jekyll.git
s2i-jekyll                  Source  https://github.com/mrjoshuap/s2i-jekyll.git


Deployment Configs
------------------

jekyll-httpd
jekyll-serve-prod
jekyll-serve-prod-latest


Environment Variables
---------------------

To set these environment variables, you can place them as a key value pair into
a `.sti/environment` file inside your source code repository, or preferably as
build environment variables.

* **BUNDLE_CLEAN_ARGS**

* **BUNDLE_INSTALL_ARGS**

* **BUNDLE_UPDATE_ARGS**

* **JEKYLL_BUILD_ARGS**

* **JEKYLL_DRAFTS**

    When set to a non-zero value, Jekyll will render posts in the `_drafts` folder.
    Defaults to `0`

* **JEKYLL_ENV**

    This variable specifies the environment where the Ruby application will be
    deployed (unless overwritten) - `production`, `development`, `test`.
    Each level has different behaviors in terms of logging verbosity,
    error pages, ruby gem installation, etc.
    Defaults to `development`

* **JEKYLL_UNPUBLISHED**

    When set to a non-zero value, Jekyll will render posts marked as unpublished.
    Defaults to `0`

* **JEKYLL_WATCH**

    When set to a non-zero value, Jekyll will watch for changes to rebuild.
    This does only applies to sites served with the built container image.
    See Hot Deployments below.
    Defaults to `0`

* **RUBYGEM_MIRROR**

    Set this variable to use a custom RubyGems mirror URL to download required
    gem packages during build process.
    Defaults to UNSET


Services
--------
jekyll-httpd                8080/TCP, 8443/TCP
jekyll-serve-prod           4000/TCP, 8080/TCP
jekyll-serve-prod-latest    4000/TCP, 8080/TCP
s2i-jekyll                  4000/TCP


* **
Hot Deployments
---------------
In order to dynamically pick up changes made in your application source code,
you need to perform the following steps:

*  **For Ruby on Rails applications**

    Run the built Jekyll image with the `JEKYLL_WATCH=1` environment variable passed to the [Docker](http://docker.io) `-e` run flag:
    ```
    $ docker run -e JEKYLL_WATCH=1 -p 4000:4000 jekyll-test-site
    ```

To change your source code in running container, use Docker's [exec](http://docker.io) command:
```
docker exec -it <CONTAINER_ID> /bin/bash
```

After you [Docker exec](http://docker.io) into the running container, your current
directory is set to `/opt/app-root/src`, where the source code is located.

See also
--------
Dockerfile and other sources are available on https://github.com/sclorg/s2i-ruby-container.
In that repository you also can find another versions of Python environment Dockerfiles.
Dockerfile for CentOS is called `Dockerfile`, Dockerfile for RHEL is called `Dockerfile.rhel7`.
