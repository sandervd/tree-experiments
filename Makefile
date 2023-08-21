diff: deserialize.ttl test/data.ttl
	./apache-jena/bin/rdfdiff deserialize.ttl test/data.ttl ttl ttl

deserialize.ttl: apache-jena SerDes/deserialize.rq serialize.ttl
	./apache-jena/bin/sparql --query=SerDes/deserialize.rq --data=serialize.ttl > deserialize.ttl

serialize.ttl: apache-jena SerDes/serialize.rq
	./apache-jena/bin/sparql --query=SerDes/serialize.rq --data=test/data.ttl > serialize.ttl

apache-jena:
	./bin/download-jena.sh
	# Bnode descendants extention for Jena
	wget https://github.com/sandervd/jena-bnode-descendants/releases/download/v1.1/bnode-descendants-1.0-SNAPSHOT.jar -O apache-jena/lib/bnode-descendants-1.0-SNAPSHOT.jar

shacl:
	# Download TopBraid SHALC validator.
	rm -f shacl
	wget https://repo1.maven.org/maven2/org/topbraid/shacl/1.4.2/shacl-1.4.2-bin.zip
	unzip shacl-1.4.2-bin.zip
	rm shacl-1.4.2-bin.zip
	ln -s shacl-* shacl
	chmod +x shacl/bin/shaclvalidate.sh

# For performance, no need to process old suffix rules.
.SUFFIXES: 

.PHONY: diff
