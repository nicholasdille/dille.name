FROM openjdk:8-jdk@sha256:86e863cc57215cfb181bd319736d0baf625fe8f150577f9eb58bd937f5452cb8 as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:8-jre@sha256:667a15e7bc533a90fb39ddb7e5bed63162ac3c13a97e6c698bf4f139f51b7d33
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]