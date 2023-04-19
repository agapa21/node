FROM nginx:stable-alpine

COPY --from=builder node.js/build/en /usr/share/nginx/html
COPY --from=builder node.js/build/static /usr/share/nginx/html/static
