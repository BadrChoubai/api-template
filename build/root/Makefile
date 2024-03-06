include build/root/config.mk

all: # @HELP builds binaries for one platform ($OS/$ARCH)
all: build

build: # @HELP builds all apps inside of container (Docker)
build:
	$(MAKE) go-build

dist: # @HELP build docker images
dist:
	@echo docker

BUILD_DIRS := .go/bin/$(OS)_$(ARCH)               \
			  .go/cache                           \
			  .go/pkg

$(BUILD_DIRS):
	mkdir -p $@

go-build: | $(BUILD_DIRS)
	@echo "# building for $(OS)/$(ARCH)"
	$(DOCKER_CMD) run $(DOCKER_RUN_FLAGS) ./build/CI/build.sh ./...

clean: # @HELP removes built binaries and temporary files
clean: bin-clean

bin-clean:
	test -d .go && chmod -R u+w .go || true
	rm -rf .go

#	=========================================================================
#	HELP
#	=========================================================================

help: # @HELP prints this help message
help: help-docker help-go
	echo "TARGETS:"
	grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST)     \
	    | awk 'BEGIN {FS = ": *# *@HELP"}; { printf "  %-30s %s\n", $$1, $$2 };'

help-docker:
	echo "docker info:"
	echo "  BUILD_IMAGE = $(BUILD_IMAGE)"
	echo "  OS = $(OS)"
	echo "  REGISTRY = $(REGISTRY)"
	echo "  TAG = $(TAG)"
	echo

help-go:
	echo "go build info:"
	echo "  GO = $(GO_VERSION)"
	echo "  OS = $(OS)"
	echo "  ARCH = $(ARCH)"
	echo

.DEFAULT_GOAL := all 
.SILENT: help help-docker help-go
.PHONY: all build default help help-docker help-go
