use shop;
-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
/*insert into orders (user_id, created_at, updated_at)
values (2, now(), now()), (6, now(), now());*/
select id, name from shop.users
where id in 
(select user_id from orders);

/*Выведите список товаров products и разделов catalogs, который соответствует товару.*/
select id, name, catalog_id from products
where catalog_id =
(select id from catalogs where name='Процессоры');


/*(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
Поля from, to и label содержат английские названия городов, поле name — русское. 
Выведите список рейсов flights с русскими названиями городов.
*/
drop database if exists air;
create database air;
use air;

drop table if exists flights;
create table flights (
`id` SERIAL AUTO_INCREMENT,
`from` varchar(20) not null default 'Moscow',
`to` varchar(20) not null,
primary key (id)
);

insert into flights (`from`, `to`)
values ('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');

drop table if exists cities;
create table cities (
`eng` varchar(20) not null,
`rus` varchar(20) not null
);

insert into cities (eng, rus)
values ('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

/* Select не получилось подобрать к сожалению )))  */

