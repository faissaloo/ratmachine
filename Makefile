.PHONY: dev build deploy
dev:
	docker-compose up

build:
	shards build ratmachine --release

deploy: build
	ssh -i ~/.ssh/ratwires -p 460 root@ratwires.space "systemctl stop ratmachine"
	scp -i ~/.ssh/ratwires -P 460 -r . root@ratwires.space:/var/www/ratwires.space/
	ssh -i ~/.ssh/ratwires -p 460 root@ratwires.space "systemctl start ratmachine"
