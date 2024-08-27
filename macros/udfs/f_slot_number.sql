{% macro create_f_slot_number() %}
CREATE OR REPLACE FUNCTION {{target.schema}}.SlotNumber(slot_time TIMESTAMP) AS (
  (SELECT DIV(TIMESTAMP_DIFF(slot_time, "2020-12-01 12:00:23 UTC", SECOND), 12))
)
{% endmacro %}