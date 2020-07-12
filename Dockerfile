FROM mhart/alpine-node AS builder

# Create app directory
RUN mkdir -p /usr/src/client
WORKDIR /usr/src/client

# Install client dependencies
COPY package.json /usr/src/client
RUN yarn

# Bundle client source
COPY . /usr/src/client

RUN yarn run build
# CMD ["yarn", "start"]

FROM mhart/alpine-node
RUN yarn global add serve
WORKDIR /usr/src/client
COPY --from=builder /usr/src/client/build .
CMD ["serve", "-p", "4000", "-s", "."]

# production setup
# FROM nginx:1.12-alpine
# COPY --from=build-deps /usr/src/app/build /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]