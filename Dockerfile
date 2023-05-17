# base image
FROM golang:latest
WORKDIR /builder


ENV GO111MODULE=on CGO_ENABLED=0

COPY go.mod /builder/
RUN go mod download

COPY . .
RUN go build -o /builder/hello /builder/hello.go

CMD ["./hello"]