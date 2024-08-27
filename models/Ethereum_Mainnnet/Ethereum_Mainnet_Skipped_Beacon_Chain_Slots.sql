
/*
    Visualize the number of transactions by day over the last 6 months
    https://cloud.google.com/blockchain-analytics/docs/example-ethereum#visualize_the_number_of_transactions_by_day_over_the_last_6_months
*/

{{ config(materialized='view') }}

/* Beacon Chain slot timestamps. */
WITH slots AS (
  /* Directly generate the first day's slots. */
  SELECT * FROM UNNEST(GENERATE_TIMESTAMP_ARRAY("2020-12-01 12:00:23 UTC", "2020-12-01 23:59:59 UTC", INTERVAL 12 SECOND)) AS slot_time
  UNION ALL
  /* Join dates and times to generate up to yesterday's slots. Attempting this directly overflows the generator functions. */
  SELECT TIMESTAMP(DATETIME(date_part, TIME(time_part))) AS slot_time
  FROM UNNEST(GENERATE_DATE_ARRAY("2020-12-02", CURRENT_DATE("UTC") - 1)) AS date_part
  CROSS JOIN
  UNNEST(GENERATE_TIMESTAMP_ARRAY("1970-01-01 00:00:11 UTC", "1970-01-01 23:59:59 UTC", INTERVAL 12 SECOND)) AS time_part
)
SELECT
  {{target.schema}}.EpochNumber(slot_time) AS epoch,
  {{target.schema}}.SlotNumber(slot_time) AS slot,
  slot_time,
  FORMAT("https://beaconcha.in/slot/%d", {{target.schema}}.SlotNumber(slot_time)) AS beaconchain_url,
FROM
  slots LEFT JOIN bigquery-public-data.goog_blockchain_ethereum_mainnet_us.blocks
  ON slot_time = block_timestamp
WHERE
  block_number IS NULL AND slot_time BETWEEN "2022-09-15 06:42:59 UTC" AND CURRENT_TIMESTAMP()
ORDER BY slot_time DESC

