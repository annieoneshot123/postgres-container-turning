OSFLAVOR=ubuntu20.04
all:
	sudo docker build -t crunchy-pg -f Dockerfile.$(OSFLAVOR) .
	sudo docker tag crunchy-pg:latest crunchydata/crunchy-pg



