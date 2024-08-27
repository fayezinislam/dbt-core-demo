
/*
    Top 5 most active traders of BAYC tokens
    https://cloud.google.com/blockchain-analytics/docs/example-ethereum#top_5_most_active_traders_of_bayc_tokens
*/

{{ config(materialized='view') }}

WITH Transfers AS (
  SELECT address AS token, to_address AS account, COUNT(*) transfer_count
  FROM `bigquery-public-data.goog_blockchain_ethereum_mainnet_us.token_transfers`
  GROUP BY token, account

  UNION ALL

  SELECT address AS token, from_address AS account, COUNT(*) transfer_count
  FROM `bigquery-public-data.goog_blockchain_ethereum_mainnet_us.token_transfers`
  WHERE from_address != '0x0000000000000000000000000000000000000000'
  GROUP BY token, account
)

SELECT account, SUM(transfer_count) quantity
FROM Transfers LEFT JOIN `bigquery-public-data.goog_blockchain_ethereum_mainnet_us.accounts` ON account = address
WHERE NOT is_contract AND token = '0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d' /* BAYC */
GROUP BY account
ORDER BY quantity DESC
LIMIT 5
