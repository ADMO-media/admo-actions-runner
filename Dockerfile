FROM summerwind/actions-runner:latest
USER root

RUN apt-get update -y \
&& apt-get install -y openjdk-17-jdk

RUN cd /tmp  \
    && curl -o ./oc.tar.gz -L  https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz \
    && tar xvf ./oc.tar.gz \
    && mv /tmp/oc /usr/local/bin/oc \
    && mv /tmp/kubectl /usr/local/bin/kubectl
USER runner
