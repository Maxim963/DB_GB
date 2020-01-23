use vk2;
alter table users add delleted_at varchar(30);
update users set delleted_at=current_timestamp;