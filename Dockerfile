FROM node:16.5.0 as BUILD
WORKDIR /app
COPY . .
RUN yarn install
RUN yarn build
RUN cp -a dist/. public/

FROM node:16.5.0
WORKDIR /
RUN mkdir /ready
COPY --from=BUILD /app/dist/. /ready
