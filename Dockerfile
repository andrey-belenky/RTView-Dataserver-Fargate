FROM openjdk:8

WORKDIR /usr/src/app

RUN wget "http://sldownloads.sl.com/.hi/upload/rtv_cloud/.direct/RTViewDataServer_5.0.0.0.zip" && \
  unzip RTViewDataServer*.zip && \
  mv "RTViewDataServer" rtview-dataserver-bin && \
  rm RTViewDataServer*.zip

RUN apt-get update && \
  apt-get install -y --no-install-recommends net-tools libmysql-java && \
  rm -rf /var/lib/apt/lists/*

COPY . .

ENV RTV_CMD_ARGS ""
ENV RTV_APP_ROOT /usr/src/app
ENV RTV_RUNTIME_ROOT ${RTV_APP_ROOT}/rtview-dataserver-bin
ENV RTV_DATASERVER_URL //localhost:3278
ENV RTV_HISTORY_DB_URL //localhost:3306
ENV RTV_HISTORY_DB_NAME RTVHISTORY
ENV RTV_HISTORY_DB_USER root
ENV RTV_HISTORY_DB_PASSWORD my-secret-pw

### Make RTView Java / JVM runtime more container aware as per
# https://developers.redhat.com/blog/2017/03/14/java-inside-docker/
#
ENV RTV_JAVAOPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"

EXPOSE 3270 3272 3275 3276 3278

VOLUME /project

RUN chmod +x scripts/run-dataserver.sh

CMD scripts/run-dataserver.sh

