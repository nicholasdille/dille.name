FROM alpine@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b as build1
RUN mkdir /opt/tool1 \
 && touch /opt/tool1/binary1
RUN sleep 20

FROM alpine@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b as build2
RUN mkdir /opt/tool2 \
 && touch /opt/tool2/binary2
RUN sleep 20

FROM alpine@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b
COPY --from=build1 /opt/tool1 /opt/tool1
COPY --from=build2 /opt/tool2 /opt/tool2
