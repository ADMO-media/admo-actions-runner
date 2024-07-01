FROM summerwind/actions-runner:latest
USER root

ENV JAVA_VERSION=17
ENV MAVEN_VERSION=3.9.8
ENV NVM_VERSION=v0.39.7
ENV NODE_VERSION=v21.7.2
ENV YARN_VERSION=1.22.19

RUN apt-get update -y \
&& apt-get install -y openjdk-${JAVA_VERSION}-jdk
#Install oc cli
RUN cd /tmp  \
    && curl -o ./oc.tar.gz -L  https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz \
    && tar xvf ./oc.tar.gz \
    && mv /tmp/oc /usr/local/bin/oc \
    && mv /tmp/kubectl /usr/local/bin/kubectl

#install maven

RUN mkdir /opt/maven && \
    curl -fL https://repo1.maven.org/maven2/org/apache/maven/apache-maven/${MAVEN_VERSION}/apache-maven-${MAVEN_VERSION}-bin.tar.gz | tar zxv -C /opt/maven --strip-components=1 && \
    chown runner:runner -R /opt/maven

ENV MAVEN_HOME /opt/maven
ENV M2_HOME /opt/maven
ENV PATH="/opt/maven/bin:${PATH}"

#install nvm


ENV NVM_DIR /usr/local/nvm
RUN mkdir $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash

ENV NODE_PATH $NVM_DIR/$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

RUN echo "source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default" | bash

#install yarn
ENV YARN_EXEC /usr/local/bin/yarn
RUN curl -fsSL --create-dirs -o $YARN_EXEC \
        https://github.com/yarnpkg/yarn/releases/download/v${YARN_VERSION}/yarn-${YARN_VERSION}.js && \
        chmod +x $YARN_EXEC


#RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
#RUN export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" && \
#  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &&  \
#  bash && nvm install ${NODE_VERSION} && nvm alias default ${NODE_VERSION} && \
#  nvm use default

USER runner
