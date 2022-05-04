FROM openjdk:19-jdk@sha256:c6f76c9bed82c777fbc57494dec14ca0dddf04a395da9f194055d2976549d2cb as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:8-jre
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]