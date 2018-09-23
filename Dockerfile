# s2i-jekyll
FROM registry.access.redhat.com/rhscl/s2i-base-rhel7:latest

MAINTAINER Josh Preston <the@mrjoshuap.com>

ENV BUILDER_VERSION=1.0 \
    NAME=s2i-jekyll \
    RUBY_NAME=rh-ruby \
    RUBY_VERSION=25 \
    STI_SCRIPTS_PATH=/usr/libexec/s2i

ENV SUMMARY="Platform for building a Jekyll based website" \
    DESCRIPTION="$RUBY_NAME$RUBY_VERSION is used to build a Jekyll website."

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

# Become the root user
USER 0

RUN yum install -y yum-utils && \
    prepare-yum-repositories rhel-server-rhscl-7-rpms && \
    INSTALL_PKGS="${RUBY_NAME}${RUBY_VERSION} ${RUBY_NAME}${RUBY_VERSION}-ruby-devel ${RUBY_NAME}${RUBY_VERSION}-rubygems-devel ${RUBY_NAME}${RUBY_VERSION}-rubygem-bundler" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    rm -rf /var/cache/yum

RUN /bin/bash -c "source scl_source enable ${RUBY_NAME}${RUBY_VERSION}; gem install -N jekyll; gem install -N minima"

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./.s2i/bin/ $STI_SCRIPTS_PATH
COPY ./.s2i/etc/ ${APP_ROOT}/etc
COPY ./bin/ ${APP_ROOT}/bin

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:0 ${APP_ROOT} && \
    chmod -R ug+rwx ${APP_ROOT} && \
    rpm-file-permissions

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
