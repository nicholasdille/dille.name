FROM openjdk:8-jdk@sha256:8a8e46d5c427bbca16298e63a20dafe95ab9edcd01644d3f6132f557987a5b43 as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:8-jre@sha256:5adb76a9c2c468e80a9972d575b5b758c93ba4bcfd5d35e74ad70f2155556c80
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]