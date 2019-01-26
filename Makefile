SRC_DIR := src
SRC_FILES := $(shell find src/ -type f -regex ".*\.cr")

.PHONY: dev
dev:
	docker-compose up

bin/ratmachine: $(SRC_FILES)
	shards build ratmachine --release

build: bin/ratmachine
	@echo "Built ratmachine to bin/ratmachine"

deploy: build
	ssh -i ~/.ssh/ratwires -p 460 root@ratwires.space "systemctl stop ratmachine"
	scp -i ~/.ssh/ratwires -P 460 -r . root@ratwires.space:/var/www/ratwires.space/
	ssh -i ~/.ssh/ratwires -p 460 root@ratwires.space "systemctl start ratmachine"
