import duckdb
import pyarrow.parquet as pq

tables = [
    "customer",
    "lineitem",
    "nation",
    "orders",
    "part",
    "partsupp",
    "region",
    "supplier",
]

# accept a command line argument for sf
import sys
if len(sys.argv) > 1:
    scale_factor = int(sys.argv[1])
else:
    scale_factor = 10

# conn = duckdb.connect(database=":memory:")
conn = duckdb.connect(database="tpch.db")
conn.execute("INSTALL tpch; LOAD tpch")
for t in tables:
    conn.execute(f"DROP TABLE IF EXISTS {t}")

conn.execute(f"CALL dbgen(sf={scale_factor})")
print(conn.execute("show tables").fetchall())
# for t in tables:
#     res = conn.query("SELECT * FROM " + t)
#     pq.write_table(res.to_arrow_table(), t + ".parquet")
# Generate TPC-H tables with DOUBLE type instead of DECIMAL
n_conn = duckdb.connect(database=":memory:")
n_conn.execute("ATTACH 'tpch.db' AS other_db;")
for table in tables:
    print(f"Creating table: {table} with DOUBLE type for DECIMALS...")

    # Get table schema
    schema_query = f"DESCRIBE {table};"
    schema = conn.execute(schema_query).fetchall()

    # Modify schema: Convert DECIMAL(x,y) to DOUBLE
    column_definitions = []
    for column_name, column_type, *_ in schema:
        if "DECIMAL" in column_type:
            column_type = "DOUBLE"  # Convert DECIMAL to DOUBLE
        column_definitions.append(f"{column_name} {column_type}")

    # Create table with modified schema
    create_query = f"CREATE TABLE {table} ({', '.join(column_definitions)});"
    n_conn.execute(create_query)

    # Insert data with conversion
    insert_query = f"""
    INSERT INTO {table} 
    SELECT {', '.join([f'CAST({col[0]} AS DOUBLE)' if "DECIMAL" in col[1] else col[0] for col in schema])} 
    FROM other_db.{table};
    """
    n_conn.execute(insert_query)

print("TPC-H dataset generated successfully with DOUBLE type!")

# Verify schema change
for table in tables:
    print(f"Schema for {table}:")
    print(n_conn.execute(f"DESCRIBE {table}").fetchall())

for t in tables:
    res = n_conn.query("SELECT * FROM " + t)
    pq.write_table(res.to_arrow_table(), t + ".parquet")

conn.close()
n_conn.close()
