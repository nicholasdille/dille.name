FROM alpine@sha256:7580ece7963bfa863801466c0a488f11c86f85d9988051a9f9c68cb27f6b7872 as build1
RUN mkdir /opt/tool1 \
 && touch /opt/tool1/binary1
RUN sleep 20

FROM alpine@sha256:7580ece7963bfa863801466c0a488f11c86f85d9988051a9f9c68cb27f6b7872 as build2
RUN mkdir /opt/tool2 \
 && touch /opt/tool2/binary2
RUN sleep 20

FROM alpine@sha256:7580ece7963bfa863801466c0a488f11c86f85d9988051a9f9c68cb27f6b7872
COPY --from=build1 /opt/tool1 /opt/tool1
COPY --from=build2 /opt/tool2 /opt/tool2
