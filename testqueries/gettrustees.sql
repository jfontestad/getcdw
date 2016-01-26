select 
    entity_id,
    report_name
from
    cdw.d_entity_mv
where
    record_type_code = 'TR'