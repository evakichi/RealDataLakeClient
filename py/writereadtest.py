from  pyspark.sql import SparkSession, DataFrame
from pyspark.sql.types import DoubleType, FloatType, LongType, StructType,StructField, StringType

spark = SparkSession.builder.getOrCreate()

schema = StructType([
  StructField("vendor_id", LongType(), True),
  StructField("trip_id", LongType(), True),
  StructField("trip_distance", FloatType(), True),
  StructField("fare_amount", DoubleType(), True),
  StructField("store_and_fwd_flag", StringType(), True)
])

df = spark.createDataFrame([], schema)
df.writeTo("demo.nyc.taxis00000").create()

schema = spark.table("demo.nyc.taxis00000").schema
data = [
    (1, 1000371, 1.8, 15.32, "N"),
    (2, 1000372, 2.5, 22.15, "N"),
    (2, 1000373, 0.9, 9.01, "N"),
    (1, 1000374, 8.4, 42.13, "Y")
  ]
df = spark.createDataFrame(data, schema)
df.writeTo("demo.nyc.taxis00000").append()

df = spark.table("demo.nyc.taxis00000").show()
