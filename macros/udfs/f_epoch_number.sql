{% macro create_f_epoch_number() %}
CREATE OR REPLACE FUNCTION {{target.schema}}.EpochNumber(slot_time TIMESTAMP) AS (
  (SELECT DIV({{target.schema}}.SlotNumber(slot_time), 32))
)
{% endmacro %}