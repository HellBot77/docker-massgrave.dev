FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/massgravel/massgrave.dev.git && \
    cd massgrave.dev && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node:alpine AS build

WORKDIR /massgrave.dev
COPY --from=base /git/massgrave.dev .
RUN npm ci && \
    npm run build

FROM joseluisq/static-web-server

COPY --from=build /massgrave.dev/build ./public
