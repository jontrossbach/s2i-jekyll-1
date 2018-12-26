# mrjoshuap/s2i-jekyll:ruby-25-centos7
FROM centos/ruby-25-centos7

# This image provides a Jekyll environment you can use to generate your static website

EXPOSE 4000

ENV BUILDER_VERSION=1.0 \
    IMAGE_NAME="mrjoshuap/s2i-jekyll:ruby-25-centos7"

ENV SUMMARY="Platform for generating a Jekyll based static website" \
    DESCRIPTION="Ruby $RUBY_VERSION is used to build a Jekyll website."

# Set labels used in OpenShift to describe the builder image
LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Jekyll Source-to-Image Builder with Ruby ${RUBY_VERSION}" \
      # this label tells s2i where to find its mandatory scripts
      # (run, assemble, save-artifacts)
      io.openshift.s2i.scripts-url="image://$STI_SCRIPTS_PATH" \
      io.openshift.tags="builder,jekyll,ruby,ruby${RUBY_SCL_NAME_VERSION},${RUBY_SCL}" \
      com.redhat.component="${RUBY_SCL}-container" \
      name="${IMAGE_NAME}" \
      usage="s2i build https://github.com/mrjoshuap/s2i-jekyll.git \
--context-dir=${RUBY_VERSION}/test/example/ ${IMAGE_NAME} jekyll-artifact-image" \
      version="1" \
      maintainer="Josh Preston <the@mrjoshuap.com>"

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
