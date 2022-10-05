FROM openjdk:8-jdk as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:11.0.16-jre@sha256:356949c3125c4fa8104745e7ea92bd995da4567634e6599b470d2f972d13e0e2
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]