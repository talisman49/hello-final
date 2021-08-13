# ETAPA DE CONSTRUCCION

FROM openjdk:16 AS base
WORKDIR /opt/hello-gradle
COPY ./ ./
RUN ./gradlew assemble 
# \ && -rm -rf /root/gradle


# ETAPA DE EJECUCION

FROM openjdk:16
WORKDIR /opt/hello-gradle
COPY --from=base /opt/hello-gradle/build/libs/demo-0.0.1-SNAPSHOT.jar ./
CMD java -jar demo-0.0.1-SNAPSHOT.jar