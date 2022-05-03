FROM alpine@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454 as build1
RUN mkdir /opt/tool1 \
 && touch /opt/tool1/binary1
RUN sleep 20

FROM alpine@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454 as build2
RUN mkdir /opt/tool2 \
 && touch /opt/tool2/binary2
RUN sleep 20

FROM alpine@sha256:4edbd2beb5f78b1014028f4fbb99f3237d9561100b6881aabbf5acce2c4f9454
COPY --from=build1 /opt/tool1 /opt/tool1
COPY --from=build2 /opt/tool2 /opt/tool2
