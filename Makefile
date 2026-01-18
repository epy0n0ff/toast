.PHONY: all build build-all test clean vendor fmt lint help install

# Variables
BINARY_NAME=toast.exe
CLI_PATH=./cli
GOOS=windows
GOARCH=amd64

# Build output directory
BUILD_DIR=./build

all: build

## build: Build the Windows executable
build:
	@echo "Building $(BINARY_NAME) for Windows..."
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build -v -o $(BINARY_NAME) $(CLI_PATH)
	@echo "Build complete: $(BINARY_NAME)"

## build-all: Build for multiple Windows architectures
build-all:
	@echo "Building for Windows amd64..."
	@mkdir -p $(BUILD_DIR)
	GOOS=windows GOARCH=amd64 go build -v -o $(BUILD_DIR)/toast-windows-amd64.exe $(CLI_PATH)
	@echo "Building for Windows 386..."
	GOOS=windows GOARCH=386 go build -v -o $(BUILD_DIR)/toast-windows-386.exe $(CLI_PATH)
	@echo "Building for Windows arm64..."
	GOOS=windows GOARCH=arm64 go build -v -o $(BUILD_DIR)/toast-windows-arm64.exe $(CLI_PATH)
	@echo "All builds complete in $(BUILD_DIR)/"

## test: Run tests
test:
	@echo "Running tests..."
	GOOS=$(GOOS) GOARCH=$(GOARCH) go test -v ./...

## clean: Remove build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -f $(BINARY_NAME)
	@rm -rf $(BUILD_DIR)
	@echo "Clean complete"

## vendor: Update vendor directory
vendor:
	@echo "Updating vendor directory..."
	go mod tidy
	go mod vendor
	@echo "Vendor update complete"

## fmt: Format Go code
fmt:
	@echo "Formatting code..."
	go fmt ./...
	@echo "Format complete"

## lint: Run linter (requires golangci-lint)
lint:
	@echo "Running linter..."
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run; \
	else \
		echo "golangci-lint not installed. Install with: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest"; \
	fi

## install: Install the binary to GOPATH/bin
install: build
	@echo "Installing $(BINARY_NAME)..."
	@if [ -n "$$GOPATH" ]; then \
		cp $(BINARY_NAME) $$GOPATH/bin/; \
		echo "Installed to $$GOPATH/bin/$(BINARY_NAME)"; \
	else \
		echo "GOPATH not set. Cannot install."; \
		exit 1; \
	fi

## help: Show this help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | column -t -s ':' | sed -e 's/^/ /'
