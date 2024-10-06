from pyspark.sql import SparkSession

# Initialize SparkSession
spark = SparkSession.builder.appName("WordCountApp").getOrCreate()

# Sample text data
data = [("Hello World",), ("Apache Spark is awesome!",), ("Hello Spark",)]

# Create DataFrame
df = spark.createDataFrame(data, ["text"])

# Split the text into words
df_words = df.selectExpr("explode(split(text, ' ')) as word")

# Count the occurrences of each word
word_count = df_words.groupBy("word").count()

# Show the result
word_count.show()

# Stop the Spark session
spark.stop()
