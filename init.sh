#!/bin/bash

if [ ! -f ./.env ];then
	echo "please spacify .env file."
	exit 255
fi

. .env 

sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" Dockerfile.org > Dockerfile
sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" conf/spark-defaults.conf.org > conf/spark-defaults.conf
sed "s/__SPARK_CATALOG_NAME__/${SPARK_CATALOG_NAME}/g" -i conf/spark-defaults.conf
sed "s/__SPARK_DB_USERNAME__/${SPARK_DB_USERNAME}/g" -i conf/spark-defaults.conf 
sed "s/__SPARK_DB_NAME__/${SPARK_DB_NAME}/g" -i conf/spark-defaults.conf 
sed "s/__SPARK_ENDPOINT_NAME__/${SPARK_ENDPOINT_NAME}/g" -i conf/spark-defaults.conf 
sed "s/__SPARK_WAREHOUSE_NAME__/${SPARK_WAREHOUSE_NAME}/g" -i conf/spark-defaults.conf 

echo "spark.sql.catalog."${SPARK_CATALOG_NAME}".jdbc.password     "${SPARK_DB_PASSWORD} >> conf/spark-defaults.conf

COMPOSE_BAKE=true docker compose up -d --build
exit 0;
