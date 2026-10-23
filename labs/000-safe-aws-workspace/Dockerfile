FROM alpine:3.23

# Local tooling only. Do not embed credentials or AWS profiles in this image.
RUN apk add --no-cache \
    aws-cli=2.32.7-r0 \
    aws-cli-doc=2.32.7-r0 \
    groff \
    less

CMD ["/bin/sh"]
