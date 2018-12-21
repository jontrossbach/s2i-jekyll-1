# s2i-jekyll
FROM centos/ruby-25-centos7

MAINTAINER Josh Preston <the@mrjoshuap.com>

ENV BUILDER_VERSION=1.0 \
    NAME=s2i-jekyll

ENV SUMMARY="Platform for building a Jekyll based website" \
    DESCRIPTION="Ruby $RUBY_VERSION is used to build a Jekyll website."

# Set labels used in OpenShift to describe the builder image
LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Jekyll Source-to-Image Builder" \
      # this label tells s2i where to find its mandatory scripts
      # (run, assemble, save-artifacts)
      io.openshift.s2i.scripts-url="image://$STI_SCRIPTS_PATH" \
      io.openshift.tags="builder,jekyll,$RUBY_NAME-$RUBY_VERSION" \
      name="mrjoshuap/s2i-jekyll" \
      usage="docker run mrjoshuap/s2i-jekyll" \
      version="1"

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./.s2i/bin/ $STI_SCRIPTS_PATH
COPY ./.s2i/etc/ ${APP_ROOT}/etc
COPY ./bin/ ${APP_ROOT}/bin

# Reset permissions of filesystem to default values
RUN /usr/libexec/httpd-prepare && rpm-file-permissions

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
