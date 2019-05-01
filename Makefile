.PHONY: tyslin tyslin-cross evm all test clean
.PHONY: tyslin-linux tyslin-linux-386 tyslin-linux-amd64 tyslin-linux-mips64 tyslin-linux-mips64le
.PHONY: tyslin-darwin tyslin-darwin-386 tyslin-darwin-amd64

GOBIN = $(shell pwd)/build/bin
GOFMT = gofmt
GO ?= latest
GO_PACKAGES = .
GO_FILES := $(shell find $(shell go list -f '{{.Dir}}' $(GO_PACKAGES)) -name \*.go)

GIT = git

tyslin:
	build/env.sh go run build/ci.go install ./cmd/tyslin
	@echo "Done building."
	@echo "Run \"$(GOBIN)/tyslin\" to launch tyslin."

gc:
	build/env.sh go run build/ci.go install ./cmd/gc
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gc\" to launch gc."

bootnode:
	build/env.sh go run build/ci.go install ./cmd/bootnode
	@echo "Done building."
	@echo "Run \"$(GOBIN)/bootnode\" to launch a bootnode."

puppeth:
	build/env.sh go run build/ci.go install ./cmd/puppeth
	@echo "Done building."
	@echo "Run \"$(GOBIN)/puppeth\" to launch puppeth."

all:
	build/env.sh go run build/ci.go install

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# Cross Compilation Targets (xgo)

tyslin-cross: tyslin-linux tyslin-darwin
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-*

tyslin-linux: tyslin-linux-386 tyslin-linux-amd64 tyslin-linux-mips64 tyslin-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-linux-*

tyslin-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/tyslin
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-linux-* | grep 386

tyslin-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/tyslin
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-linux-* | grep amd64

tyslin-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/tyslin
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-linux-* | grep mips

tyslin-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/tyslin
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-linux-* | grep mipsle

tyslin-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/tyslin
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-linux-* | grep mips64

tyslin-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/tyslin
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-linux-* | grep mips64le

tyslin-darwin: tyslin-darwin-386 tyslin-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-darwin-*

tyslin-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/tyslin
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-darwin-* | grep 386

tyslin-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/tyslin
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/tyslin-darwin-* | grep amd64

gofmt:
	$(GOFMT) -s -w $(GO_FILES)
	$(GIT) checkout vendor
