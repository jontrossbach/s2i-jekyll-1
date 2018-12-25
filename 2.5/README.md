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
        mrjoshuap/jekyll-ruby-25-rhel7 \
        jekyll-test-site

    $ docker run -p 4000:4000 jekyll-test-site
    ```

*  **For CentOS based image**
    ```
    $ s2i build \
        https://github.com/mrjoshuap/s2i-jekyll.git \
            --context-dir=2.5/test/jekyll-test-site/ \
        mrjoshuap/jekyll-ruby-25-centos7 \
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
--> Found Docker image 29bb20d (2 weeks old) from Docker Hub for "centos/ruby-25-centos7"

    Ruby 2.5
    --------
    Ruby 2.5 available as container is a base platform for building and running various Ruby 2.5 applications and frameworks. Ruby is the interpreted scripting language for quick and easy object-oriented programming. It has many features to process text files and to do system management tasks (as in Perl). It is simple, straight-forward, and extensible.

    Tags: builder, ruby, ruby25, rh-ruby25

    * An image stream tag will be created as "ruby-25-centos7:latest" that will track the source image
    * A Docker build using source code from https://github.com/mrjoshuap/s2i-jekyll will be created
      * The resulting image will be pushed to image stream tag "s2i-jekyll:latest"
      * Every time "ruby-25-centos7:latest" changes a new build will be triggered
    * This image will be deployed in deployment config "s2i-jekyll"
    * Port 4000/tcp will be load balanced by service "s2i-jekyll"
      * Other containers can access this service through the hostname "s2i-jekyll"

--> Creating resources with label name=s2i-jekyll ...
    imagestream.image.openshift.io "ruby-25-centos7" created
    imagestream.image.openshift.io "s2i-jekyll" created
    buildconfig.build.openshift.io "s2i-jekyll" created
    deploymentconfig.apps.openshift.io "s2i-jekyll" created
    service "s2i-jekyll" created
--> Success
    Build scheduled, use 'oc logs -f bc/s2i-jekyll' to track its progress.
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose svc/s2i-jekyll'
    Run 'oc status' to view your app.
Joshuas-MacBook-Pro:s2i-jekyll jpreston$ oc logs -f bc/s2i-jekyll
Cloning "https://github.com/mrjoshuap/s2i-jekyll" ...
    Commit: cd0ebaac9bc96dc7ead6c2bf0df74835dfff7136 (update with env variables)
    Author: Joshua Preston <the@mrjoshuap.com>
    Date:   Mon Dec 24 08:52:47 2018 -0500
Replaced Dockerfile FROM image centos/ruby-25-centos7
Step 1/11 : FROM centos/ruby-25-centos7@sha256:3222ca6f052f3b3f8095b159d01dc4a73fdc307073e9445b283d391d3b39dad1
 ---> 29bb20d98d36
Step 2/11 : EXPOSE 4000
 ---> Using cache
 ---> 158f9ea59f1c
Step 3/11 : ENV BUILDER_VERSION 1.0 IMAGE_NAME "mrjoshuap/jekyll-ruby-$RUBY_SCL_NAME_VERSION-centos7"
 ---> Using cache
 ---> f6e2a74598ed
Step 4/11 : ENV SUMMARY "Platform for generating a Jekyll based static website" DESCRIPTION "Ruby $RUBY_VERSION is used to build a Jekyll website."
 ---> Using cache
 ---> 0c40bb26cfac
Step 5/11 : LABEL summary "$SUMMARY" description "$DESCRIPTION" io.k8s.description "$DESCRIPTION" io.k8s.display-name "Jekyll Source-to-Image Builder with Ruby ${RUBY_VERSION}" io.openshift.s2i.scripts-url "image://$STI_SCRIPTS_PATH" io.openshift.tags "builder,jekyll,ruby,ruby${RUBY_SCL_NAME_VERSION},${RUBY_SCL}" com.redhat.component "jekyll-${RUBY_SCL}-container" name "${IMAGE_NAME}" usage "s2i build https://github.com/mrjoshuap/s2i-jekyll.git --context-dir=${RUBY_VERSION}/test/example/ ${IMAGE_NAME} jekyll-artifact-image" version "1" maintainer "Josh Preston <the@mrjoshuap.com>"
 ---> Using cache
 ---> 79376dab1f77
Step 6/11 : COPY ./s2i/bin/ $STI_SCRIPTS_PATH
 ---> 9b62bdc1e1b7
Removing intermediate container 4f80ecd3bc33
Step 7/11 : COPY ./root/ /
 ---> 14551170a517
Removing intermediate container a064c2a1ba86
Step 8/11 : USER 1001
 ---> Running in 446566db80cf
 ---> c9521ef15a2d
Removing intermediate container 446566db80cf
Step 9/11 : CMD $STI_SCRIPTS_PATH/usage
 ---> Running in 35066917901a
 ---> 0efb1f66f715
Removing intermediate container 35066917901a
Step 10/11 : ENV "OPENSHIFT_BUILD_NAME" "s2i-jekyll-1" "OPENSHIFT_BUILD_NAMESPACE" "my-first-jekyll-site" "OPENSHIFT_BUILD_SOURCE" "https://github.com/mrjoshuap/s2i-jekyll" "OPENSHIFT_BUILD_COMMIT" "cd0ebaac9bc96dc7ead6c2bf0df74835dfff7136"
 ---> Running in 7bd282ec9fc5
 ---> 954a28d272b5
Removing intermediate container 7bd282ec9fc5
Step 11/11 : LABEL "io.openshift.build.commit.author" "Joshua Preston \u003cthe@mrjoshuap.com\u003e" "io.openshift.build.commit.date" "Mon Dec 24 08:52:47 2018 -0500" "io.openshift.build.commit.id" "cd0ebaac9bc96dc7ead6c2bf0df74835dfff7136" "io.openshift.build.commit.message" "update with env variables" "io.openshift.build.commit.ref" "master" "io.openshift.build.name" "s2i-jekyll-1" "io.openshift.build.namespace" "my-first-jekyll-site" "io.openshift.build.source-context-dir" "2.5" "io.openshift.build.source-location" "https://github.com/mrjoshuap/s2i-jekyll"
 ---> Running in 7ffff351110d
 ---> 0bbb16274e8a
Removing intermediate container 7ffff351110d
Successfully built 0bbb16274e8a
Pushing image 172.30.1.1:5000/my-first-jekyll-site/s2i-jekyll:latest ...
Pushed 0/11 layers, 18% complete
Pushed 1/11 layers, 22% complete
Pushed 2/11 layers, 36% complete
Pushed 3/11 layers, 36% complete
Pushed 4/11 layers, 36% complete
Pushed 5/11 layers, 55% complete
Pushed 6/11 layers, 55% complete
Pushed 7/11 layers, 64% complete
Pushed 8/11 layers, 77% complete
Pushed 9/11 layers, 85% complete
Pushed 10/11 layers, 97% complete
Pushed 11/11 layers, 100% complete
Push successful

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
    This does only applies to sites served with
    the built container image.  See Hot Deployments below.
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
