# pull official base image
FROM node:13.12.0-alpine as builder
# set working directory
WORKDIR /app
# add `/app/node_modules/.bin` to $PATH
COPY . .
# install app dependencies
RUN npm install --silent  --production  -no-cache
# add app
RUN cd /app
RUN npm run-script build
#------------------------------------------------------
FROM node:13.12.0-alpine as runtime
ENV PATH /app/node_modules/.bin:$PATH
WORKDIR /app
COPY --from=builder /app/package.json /app
COPY --from=builder /app/package-lock.json /app
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/build /app/

RUN (ls -1 /)

RUN (ls -1 /app/)
EXPOSE 3000
# start app
