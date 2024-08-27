
/*
    USDC Token Issuance
    https://cloud.google.com/blockchain-analytics/docs/example-ethereum#usdc_token_issuance
*/

{{ config(materialized='view') }}

SELECT
  TIMESTAMP_TRUNC(block_timestamp, DAY) AS timestamp1, COUNT(1) AS txn_count
FROM
  bigquery-public-data.goog_blockchain_ethereum_mainnet_us.transactions
WHERE
  block_timestamp >= CAST(DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH) AS TIMESTAMP)
GROUP BY timestamp1
ORDER BY timestamp1

