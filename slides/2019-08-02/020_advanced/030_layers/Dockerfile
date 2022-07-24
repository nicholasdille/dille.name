FROM openjdk:8-jdk as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:11-jre@sha256:b90104c2eec246d8b6aec962456499f0163a5b58fcfcb10fe802743d73f344d7
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]