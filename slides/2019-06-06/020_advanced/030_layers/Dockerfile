FROM openjdk:20-jdk@sha256:960b9e84d951d685ed29cd85be9db35b1d0c677ae98b77f788ed69c16fefb5fc as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:8-jre
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]