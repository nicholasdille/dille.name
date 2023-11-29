#syntax=docker/dockerfile:1.6.0

FROM gitlab/gitlab-runner:v16.6.1@sha256:3611cd82bb6dc0264ed1ab12121ff8cd036847a0de40ede082d5143d457dda89

RUN <<EOF
mkdir /builds
chown gitlab-runner /builds
EOF

COPY --chmod=0755 entrypoint.sh /
ENTRYPOINT /entrypoint.sh
