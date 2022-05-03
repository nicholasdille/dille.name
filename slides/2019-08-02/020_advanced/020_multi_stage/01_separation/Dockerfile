FROM openjdk:8-jdk@sha256:bda4739c44b15f4a6ef4aa044e032809dd0ced24263c972bb728a0388275548b as builder
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:8-jre@sha256:702a25b0bf7725e88ef9cd7ddca71cb000baea944a8b260b5931c14f7e70f42f
COPY --from=builder /HelloWorld.class .
CMD [ "java", "HelloWorld" ]