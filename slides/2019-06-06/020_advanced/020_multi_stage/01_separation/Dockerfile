FROM openjdk:20-jdk@sha256:48b71d82bf36b37dfd6e698a84be3abe1bee96debaa8a17d9fc6b3a7eadeed4f as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:8-jre
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]