
/*
    Total Staked ETH withdrawal
    https://cloud.google.com/blockchain-analytics/docs/example-ethereum#total_staked_eth_withdrawal
*/

{{ config(materialized='view') }}

WITH withdrawals AS (
  SELECT
    w.amount_lossless AS amount,
    DATE(b.block_timestamp) AS block_date
  FROM
    bigquery-public-data.goog_blockchain_ethereum_mainnet_us.blocks AS b
    CROSS JOIN UNNEST(withdrawals) AS w
)
SELECT
  block_date,
  bqutil.fn.bignumber_div(bqutil.fn.bignumber_sum(ARRAY_AGG(amount)), "1000000000") AS eth_withdrawn
FROM
  withdrawals
GROUP BY 1 ORDER BY 1 DESC
