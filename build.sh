#!/bin/bash

set -e

outPlattform=linux
outArch=amd64
outPath=./output_$outPlattform_$outArch

rm -rf build
mkdir build
cd build

CGO_ENABLED=0 GOOS=$outPlattform GOARCH=$outArch go build ../gogs.go
chmod +x gogs
mv gogs gogs.bin
mkdir gogs
mv gogs.bin gogs/gogs
cp -r ../conf/ gogs/conf/
cp -r ../public/ gogs/public/
cp -r ../templates/ gogs/templates/

zip -r gogs.zip gogs

mvn deploy:deploy-file -DgroupId=uk.ac.cam.cl.dtg -DartifactId=gogs -Dversion=1.0.0-SNAPSHOT -DgeneratePom=true -Dpackaging=zip -DrepositoryId=dtg-code -Durl=http://dtg-maven.cl.cam.ac.uk/content/repositories/snapshots -Dfile=gogs.zip
