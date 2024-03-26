# Use the official Golang image as a base
FROM golang:latest

# Copy the source files into the container
COPY main.go .
COPY go.mod .
COPY gopher-ascii.txt .

# Build the Go application
RUN go build .

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./cilium-gophers-demo"]