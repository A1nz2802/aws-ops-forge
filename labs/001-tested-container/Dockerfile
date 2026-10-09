# Pin base contents; update these digests deliberately for security fixes.
FROM golang:1.26-bookworm@sha256:d9c68c2c51161e12fd77e4c6320687c9cd86e1af1e3ad6e6cd63ff970641453c AS build

WORKDIR /src
COPY app/go.mod ./
COPY app/*.go ./

# Tests are a separate CI gate. This stage only builds the executable.
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -buildvcs=false -o /out/service .

FROM gcr.io/distroless/static-debian12:nonroot@sha256:afa5c872c891853ca7fcf1f12c3edb23f7eeef36189728842dd51042ff57f7ab

COPY --from=build /out/service /service
USER 65532:65532
EXPOSE 8080
ENTRYPOINT ["/service"]
