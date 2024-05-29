# Stage 1: Build the Go application
FROM golang:1.17 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files
COPY go.* ./

# Download dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

# Stage 2: Create a lightweight image to run the application
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the binary from the builder stage to the final image
COPY --from=builder /app/app .

# Expose port 8080
EXPOSE 8080

# Command to run the application
CMD ["./app"]
