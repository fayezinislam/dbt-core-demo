
/*
    Earned mining transaction fees since EIP-1559
    Since EIP-1559, the base fees of transactions are burned and the miners only earn the priority fees. The following query computes the total amount of fees earned by the miners since the London hard fork.
    https://cloud.google.com/blockchain-analytics/docs/example-ethereum#earned_mining_transaction_fees_since_eip-1559
*/

{{ config(materialized='view') }}

WITH tgas AS (
  SELECT t.block_number, gas_used, effective_gas_price FROM
    bigquery-public-data.goog_blockchain_ethereum_mainnet_us.receipts AS r
    JOIN bigquery-public-data.goog_blockchain_ethereum_mainnet_us.transactions AS t
    ON t.block_number = r.block_number AND t.transaction_hash = r.transaction_hash
)
SELECT
  /* Cast needed to avoid INT64 overflow when doing multiplication. */
  SUM(CAST(tgas.effective_gas_price - b.base_fee_per_gas AS BIGNUMERIC) * tgas.gas_used) AS FEES
FROM
  bigquery-public-data.goog_blockchain_ethereum_mainnet_us.blocks b JOIN tgas
  ON b.block_number = tgas.block_number
WHERE
  b.block_number >= 12965000 /* The London hard fork. */