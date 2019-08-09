#!/usr/bin/env bash

if [ ! -e "/opt/glassfish4/glassfish/domains/domain1/applications/dataverse/WEB-INF/classes/Bundle.properties" ]; then
	cd /opt/dv
	./setupIT.bash
fi

sed -e 's/<jvm-options>-Ddoi.baseurlstring=https:\/\/mds.test.datacite.org<\/jvm-options>/<jvm-options>-Ddoi.baseurlstring=https:\/\/mds.test.datacite.org<\/jvm-options>\n<jvm-options>-Ddoi.username=AND.TEST<\/jvm-options>\n<jvm-options>-Ddoi.password=tuwiendoi<\/jvm-options>/' /opt/glassfish4/glassfish/domains/domain1/config/domain.xml > tmp
rm /opt/glassfish4/glassfish/domains/domain1/config/domain.xml
mv tmp /opt/glassfish4/glassfish/domains/domain1/config/domain.xml
curl -X PUT -d 10.33581 http://localhost:8080/api/admin/settings/:Authority

curl http://localhost:8080/api/admin/datasetfield/load -H "Content-type: text/tab-separated-values" -X POST --upload-file /tmp/custom_metadata_block.tsv

echo "Don't forget to enable the custom metadata block in the frontend!"

cd /opt/glassfish4
bin/asadmin stop-domain
bin/asadmin start-domain

sleep infinity

