FROM node:20-alpine AS build
WORKDIR /app

RUN apk add --no-cache git
RUN git clone https://github.com/mijofr/st-panorama.git .

RUN npm ci
RUN npm run build

RUN set -eux; \
  if [ -d dist ]; then cp -a dist /out; \
  elif [ -d build ]; then cp -a build /out; \
  else echo "No dist/ or build/ output found"; ls -la; exit 1; fi

FROM nginx:alpine
COPY --from=build /out/ /usr/share/nginx/html/
EXPOSE 80
