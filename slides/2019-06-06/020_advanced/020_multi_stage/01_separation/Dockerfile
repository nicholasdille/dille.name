FROM openjdk:21-jdk@sha256:af9de795d1f8d3b6172f6c55ca9ba1c5768baa11bb2dc8af7045c7db9d4c33ac as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:8-jre
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]