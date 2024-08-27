
/*
    Daily slot utilization
    https://cloud.google.com/blockchain-analytics/docs/example-ethereum#daily_slot_utilization
*/

{{ config(materialized='view') }}

SELECT
  DATE(block_timestamp) AS block_date,
  COUNT(block_number) AS daily_blocks,
  7200 - COUNT(block_number) AS skipped_slots
FROM
  bigquery-public-data.goog_blockchain_ethereum_mainnet_us.blocks
WHERE
  DATE(block_timestamp) BETWEEN DATE("2022-09-16") AND CURRENT_DATE("UTC") - 1 /* Only count complete days after The Merge */
GROUP BY block_date

