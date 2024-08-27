{% macro create_udfs() %}

Create schema if not exists {{target.schema}};

{{create_f_slot_number()}};

{{create_f_epoch_number()}};

{% endmacro %}