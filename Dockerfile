# ETAPA DE CONSTRUCCION

FROM openjdk:16 AS base
WORKDIR /opt/hello-final
COPY ./ ./
RUN ./gradlew assemble 
# \ && -rm -rf /root/gradle


# ETAPA DE EJECUCION

FROM openjdk:16
WORKDIR /opt/hello-final
COPY --from=base /opt/hello-final/build/libs/hello-final-0.0.1-SNAPSHOT.jar ./
CMD java -jar hello-final-0.0.1-SNAPSHOT.jar