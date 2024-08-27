
/*
    Top 10 USDC Account Balances
    https://cloud.google.com/blockchain-analytics/docs/example-ethereum#top_10_usdc_account_balances
*/

{{ config(materialized='view') }}

WITH Transfers AS (
  SELECT address token, to_address account, 0 _out, CAST(quantity AS BIGNUMERIC) _in
  FROM `bigquery-public-data.goog_blockchain_ethereum_mainnet_us.token_transfers`

  UNION ALL

  SELECT address token, from_address account, CAST(quantity AS BIGNUMERIC) _out, 0 _in
  FROM `bigquery-public-data.goog_blockchain_ethereum_mainnet_us.token_transfers`
)

/* Top 10 Holders of USDC */
SELECT account, (SUM(_in) - SUM(_out)) / 1000000 balance
FROM Transfers
WHERE token = '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
GROUP BY account
ORDER BY balance DESC
LIMIT 10
