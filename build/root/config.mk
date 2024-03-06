APPS ?= service-one service-two

DBG ?=

# VERSION ?= $(shell git describe --tags --always --dirty)
VERSION ?= 0.0.0

# tools
DOCKER_CMD := docker
GO_CMD ?= go
GO_VERSION := 1.22

# Used internally.  Users should pass GOOS and/or GOARCH.
OS := $(if $(GOOS),$(GOOS),$(shell go env GOOS))
ARCH := $(if $(GOARCH),$(GOARCH),$(shell go env GOARCH))
TAG := $(VERSION)__$(OS)_$(ARCH)

BUILD_IMAGE := golang:$(GO_VERSION)-alpine
CACHE_DIR := .go/cache
REGISTRY := registry.domain

#DOCKER_COMPOSE_FLAGS := ...

GOFLAGS ?=
HTTP_PROXY ?=
HTTPS_PROXY ?=

# flags passed to `docker build`
DOCKER_BUILD_FLAGS := --progress=plain \
						--platform="$(OS)/$(ARCH)" \
						--build-arg="HTTP_PROXY=$(HTTP_PROXY)" \
						--build-arg="HTTPS_PROXY=$(HTTPS_PROXY)" \
						-t $(REGISTRY)/$(BINARY_NAME):$(TAG)

# flags passed to `docker run`
DOCKER_RUN_FLAGS := -i --rm													\
					-u $$(id -u):$$(id -g)									\
					-v $$(pwd):/src											\
					-w /src													\
					-v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin                \
					-v $$(pwd)/.go/cache:/.cache                            \
					--env GOCACHE="/.cache/gocache"                         \
					--env GOMODCACHE="/.cache/gomodcache"                   \
					--env ARCH="$(ARCH)"									\
					--env OS="$(OS)"										\
					--env VERSION="$(VERSION)"										\
					--env GOFLAGS="$(GOFLAGS)"								\
					--env HTTP_PROXY="$(HTTP_PROXY)"						\
					--env HTTPS_PROXY="$(HTTPS_PROXY)"						\
					$(BUILD_IMAGE)

# It's necessary to set this because some environments don't link sh -> bash.
SHELL := /usr/bin/env bash -o errexit -o pipefail -o nounset
