FROM openjdk:8-jdk as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:11-jre@sha256:797289f332e6bc2b0b58eccd10671c1bb76ab8155593096f10542862ca35fe47
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]