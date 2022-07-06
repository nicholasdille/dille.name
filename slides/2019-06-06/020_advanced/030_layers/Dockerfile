FROM openjdk:20-jdk@sha256:e014e06874b05beb3024df48e740289b319e1796383a9d92525356718d78868f as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:8-jre
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]