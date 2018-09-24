Jekyll S2I Image
================

This repository contains the source for a builder using
[Jekyll](https://jekyllrb.com/) that produces static websites utilizing
OpenShift's [source-to-image](https://github.com/openshift/source-to-image)
process.

The resulting image is not able to be run, as it only contains the generated
Jekyll website content.

For more information about using these images with OpenShift, please see the
official [OpenShift Documentation](https://docs.okd.io/latest/architecture/core_concepts/builds_and_image_streams.html#source-build).

Please note that support for CentOS is questionable at best as I have no
interest in supporting it.

Versions
----------------
Ruby versions currently supported are included with Red Hat Software
Collections, and subsequently require the host system doing the build to be
properly installed, configured and subscribed:
* rh-ruby2.5

Installation
----------------
To build the Jekyll Builder image:
*  **RHEL based image**

    This image is available on DockerHub. To download it run:

    ```
    $ docker pull mrjoshuap/s2i-jekyll
    ```

    To build this image from scratch run:

    ```
    $ git clone https://github.com/mrjoshuap/s2i-jekyll.git
    $ cd s2i-jekyll
    $ ./configure
    $ make
    ```

Usage
----------------
To build a Jekyll application image using this Builder Image (outside
of OpenShift):

* install S2I from https://github.com/openshift/source-to-image

* perform a source to image build on your Jekyll site source

  ```
  # s2i build git://<source code> jekyll-nginx <application image>
  ```

3. run the resulting application image

  ```
  # docker run -p 8080:8080 <application image>
  ```
