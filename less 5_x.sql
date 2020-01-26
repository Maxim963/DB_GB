/*Подсчитайте средний возраст пользователей в таблице users*/
use vk2;
select year(now()) - avg(year(birthday)) as 'Sredniy vozrast' from vk2.profiles;

/*необходимо извлечь пользователей, родившихся в августе и мае. 
Месяцы заданы в виде списка английских названий ('may', 'august')*/
use vk2;
select users.*, profiles.* from users, profiles
where (month(birthday) = 5 or month(birthday) = 8) and users.id = profiles.user_id;

/*(по желанию) Подсчитайте произведение чисел в столбце таблицы*/
use shop;
select exp(sum(ln(id))) as 'proizvedenie' from catalogs;

/*Таблица users была неудачно спроектирована. 
Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.*/
use vk2;
update users
set created_at = str_to_date(created_at, '%Y-%m-%d %k:%i:%s'),
updated_at = str_to_date(updated_at, '%Y-%m-%d %k:%i:%s'),
delleted_at = str_to_date(delleted_at, '%Y-%m-%d %k:%i:%s');