
/*
    USDC Token Issuance
    https://cloud.google.com/blockchain-analytics/docs/example-ethereum#usdc_token_issuance
*/

{{ config(materialized='view') }}

SELECT
  DATE(block_timestamp) AS `Date`,
  {{target.schema}}.USD(SUM({{target.schema}}.IFMINT(input, 1, -1) * CAST(CONCAT("0x", LTRIM(SUBSTRING(input, {{target.schema}}.IFMINT(input, 75, 11), 64), "0")) AS FLOAT64) / 1000000)) AS `Total Supply Change`,
FROM
  bigquery-public-data.goog_blockchain_ethereum_mainnet_us.transactions
WHERE
  DATE(block_timestamp) BETWEEN "2023-03-01" AND "2023-03-07"
  AND to_address = "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48" -- USDC Coin Token
  AND (
    input LIKE "0x42966c68%" -- Burn
    OR input LIKE "0x40c10f19%" -- Mint
  )
GROUP BY `Date`
ORDER BY `Date` DESC

