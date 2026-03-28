#!/bin/bash
CP=
/usr/lib/jvm/java-21-openjdk-amd64/bin/java -Xshare:dump -XX:SharedClassListFile=/home/jvangaalen/opt/jmeter/classlist.txt -XX:SharedArchiveFile=/home/jvangaalen/opt/jmeter/lib/jmeter_cds_v2.jsa -cp  2>&1 | tail -10
