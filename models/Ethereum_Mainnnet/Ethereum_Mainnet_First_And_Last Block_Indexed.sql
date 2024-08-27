
/*
    View the first and last block indexed
    https://cloud.google.com/blockchain-analytics/docs/example-ethereum#view_the_first_and_last_block_indexed
*/

{{ config(materialized='view') }}

SELECT
  MIN(block_number) AS `First block`,
  MAX(block_number) AS `Newest block`,
  COUNT(1) AS `Total number of blocks`
FROM
  bigquery-public-data.goog_blockchain_ethereum_mainnet_us.blocks

