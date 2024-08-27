{% macro create_udfs() %}

Create schema if not exists {{target.schema}};

-- SlotNumber
CREATE OR REPLACE FUNCTION {{target.schema}}.SlotNumber(slot_time TIMESTAMP) AS (
  (SELECT DIV(TIMESTAMP_DIFF(slot_time, "2020-12-01 12:00:23 UTC", SECOND), 12))
);

-- EpochNumber
CREATE OR REPLACE FUNCTION {{target.schema}}.EpochNumber(slot_time TIMESTAMP) AS (
  (SELECT DIV({{target.schema}}.SlotNumber(slot_time), 32))
);

-- IFMINT
CREATE OR REPLACE FUNCTION {{target.schema}}.IFMINT(input STRING, ifTrue ANY TYPE, ifFalse ANY TYPE) AS (
  CASE
    WHEN input LIKE "0x40c10f19%" THEN ifTrue
    ELSE ifFalse
  END
);

-- USD
CREATE OR REPLACE FUNCTION {{target.schema}}.USD(input FLOAT64) AS (
  CAST(input AS STRING FORMAT "$999,999,999,999")
);

{% endmacro %}