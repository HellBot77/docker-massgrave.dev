FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/massgravel/massgrave.dev.git && \
    cd massgrave.dev && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /massgrave.dev
COPY --from=base /git/massgrave.dev .
RUN npm install && \
    npm run build

FROM lipanski/docker-static-website

COPY --from=build /massgrave.dev/build .
