/*
    Ethereum Token Transfers (last 30 days)
*/

{{ config(materialized='view') }}

SELECT 
block_timestamp,
block_number,
address,
from_address,
to_address,
quantity
FROM `bigquery-public-data.goog_blockchain_ethereum_mainnet_us.token_transfers`
WHERE DATE(block_timestamp) BETWEEN CURRENT_DATE("UTC")-31 AND CURRENT_DATE("UTC")-1