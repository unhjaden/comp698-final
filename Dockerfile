FROM golang:1.10.1
WORKDIR /go/src/github.com/comp698-final/
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o comp698-final .

FROM alpine:latest
WORKDIR /root/
COPY --from=0 /go/src/github.com/comp698-final/comp698-final .
COPY static static
CMD ["./comp698-final"]
EXPOSE 80