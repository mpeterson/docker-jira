AUTHOR=mpeterson
NAME=jira
VERSION=0.1

.PHONY: all build tag_latest

all: build

build:
	docker build -t $(AUTHOR)/$(NAME):$(VERSION) --rm .

tag_latest:
	docker tag $(AUTHOR)/$(NAME):$(VERSION) $(AUTHOR)/$(NAME):latest
