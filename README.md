# Otimizar imagem golang

Aplicativo Go
```
package main 

import "fmt" 

func main() { 
    fmt.Println("Full Cycle Rocks!!") 
}
```

### Dockerfile para criar imagem do golang:latest
```
FROM golang:latest
WORKDIR /builder


ENV GO111MODULE=on CGO_ENABLED=0

COPY go.mod /builder/
RUN go mod download

COPY . .
RUN go build -o /builder/hello /builder/hello.go

CMD ["./hello"]
```
Build / Imagem / Run
![image](https://github.com/and-araujo-cavalcante/minimizar-imagem-container-golang/assets/133878123/b9b58e06-cb45-4589-ad43-dae34f789814)

### Dockerfile para criar imagem otimizada
```
# base image
FROM golang:alpine as base
WORKDIR /builder
RUN apk add upx

ENV GO111MODULE=on CGO_ENABLED=0

COPY go.mod /builder/
RUN go mod download

COPY . .
RUN go build \
    -ldflags "-s -w" \
    -o /builder/hello /builder/hello.go

RUN upx -9 /builder/hello

# runner image
FROM scratch

WORKDIR /
COPY --from=base /builder/hello /hello 
CMD ["./hello"]
```
Build / Imagem / Run
![image](https://github.com/and-araujo-cavalcante/minimizar-imagem-container-golang/assets/133878123/f5aca28a-2f26-44f0-aa9c-2ceed8a4d120)

### Resultado final
![image](https://github.com/and-araujo-cavalcante/minimizar-imagem-container-golang/assets/133878123/999c96d1-2349-4758-9469-cfdddb7e6ab7)

Push da imagem no docker hub
```
docker push andersoncavalcante/golang:minimal-image
```
Pull da imagem no docker hub
```
docker pull andersoncavalcante/golang:minimal-image
```

Docker hub
https://hub.docker.com/repository/docker/andersoncavalcante/golang/general

### Referências
https://go.dev/doc/tutorial/getting-started \
https://clavinjune.dev/en/blogs/how-to-minimize-go-apps-container-image/ \
https://medium.com/swlh/reducing-container-image-size-esp-for-go-applications-db7658e9063a \
https://hub.docker.com/_/scratch/
