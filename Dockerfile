FROM node:22.22.1-alpine AS BUILDER

RUN mkdir /user/src/app
WORKDIR /user/src/app

COPY ./package.json ./package-lock.json ./
RUN npm ci

COPY . .

RUN npm run build

FROM node:22.22.1-alpine AS PRODUCTION

WORKDIR /user/src/app

COPY --from=BUILDER /user/src/app/package.json /user/src/app/package-lock.json ./
RUN npm ci

COPY /user/src/app/dist ./dist

CMD [ "node", "dist/main" ]
