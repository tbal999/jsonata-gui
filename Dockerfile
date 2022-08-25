FROM golang:1.18-alpine AS build

# force dockerfile run as a basic user
RUN addgroup -g 1001 -S appuser && adduser -u 1001 -S appuser -G appuser 

COPY go.mod .

ENV GOPATH=""

RUN go mod tidy && go mod verify

COPY . .

# build the app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /bin/app

EXPOSE 8050

# run as user
USER 1001

ENTRYPOINT ["/bin/app"]