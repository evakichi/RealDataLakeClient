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
df.writeTo("demo.nyc.taxis").create()
