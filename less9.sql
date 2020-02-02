/*В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
 Используйте транзакции.*/
START TRANSACTION;
INSERT INTO sample.users (name, age) SELECT name, age FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;
COMMIT;

USE sample;
SELECT * FROM users;
USE shop;
SELECT * FROM users;

/* Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs */
use shop;
CREATE OR REPLACE VIEW prod_cat_names AS
    SELECT p.name 'item', c.name 'catalog' FROM products p JOIN catalogs c ON p.catalog_id = c.id; 
SELECT * FROM prod_cat_names;

DROP VIEW prod_cat_names;

/* (по желанию) Пусть имеется таблица с календарным полем created_at. 
 * В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
 * Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует. */

USE shop;

DROP TABLE IF EXISTS aug;
CREATE TABLE aug (created_at DATE);
INSERT INTO aug VALUES ('2018-08-01'), ('2018-08-04'), ('2018-08-16'), ('2018-08-17');

DROP TABLE IF EXISTS aug_full;
CREATE TEMPORARY TABLE aug_full (created_at DATE);
INSERT INTO aug_full VALUES
	('2018-08-01'), ('2018-08-02'), ('2018-08-03'), ('2018-08-04'), ('2018-08-05'),
	('2018-08-06'), ('2018-08-07'), ('2018-08-08'), ('2018-08-09'), ('2018-08-10'),	
	('2018-08-11'), ('2018-08-12'), ('2018-08-13'), ('2018-08-14'), ('2018-08-15'),
	('2018-08-16'), ('2018-08-17'), ('2018-08-18'), ('2018-08-19'), ('2018-08-20'),
	('2018-08-21'), ('2018-08-22'), ('2018-08-23'), ('2018-08-24'), ('2018-08-25'),
	('2018-08-26'), ('2018-08-27'), ('2018-08-28'), ('2018-08-29'), ('2018-08-30'), ('2018-08-31');

SELECT 
    f.created_at AS created_at, 
    COUNT(a.created_at) AS is_in_aug
  FROM aug_full AS f 
  LEFT JOIN aug AS a 
    ON f.created_at = a.created_at 
 GROUP BY created_at 
 ORDER BY created_at;
 
/*  Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи". */
USE shop;

DELIMITER //

DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
    DECLARE hour TIME DEFAULT HOUR(CURTIME());
    IF hour >= 6 AND hour < 12 THEN RETURN 'Доброе утро!';
    ELSEIF hour >= 12 AND hour < 18 THEN RETURN 'Добрый день!';
    ELSEIF hour >= 18 AND hour <= 23 THEN RETURN 'Добрый вечер!';
    ELSE RETURN 'Доброй ночи!';
    END IF;
END//

SELECT hello()//

DELIMITER ;

/* В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию. */

CREATE DATABASE IF NOT EXISTS shop;
USE shop;
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание'
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.'),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.'),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.');
SELECT * FROM products;

-- ------------------------------------------------------------------------------------------------------------------------
DELIMITER //

CREATE TRIGGER check_not_null_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF 'null_try' = COALESCE(NEW.name, NEW.description, 'null_try') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Canceled. Input name or description!';
    END IF;
END//

CREATE TRIGGER check_not_null_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF 'null_try' = COALESCE(NEW.name, NEW.description, 'null_try') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Canceled. Name or description required!';
    END IF;
END//

DELIMITER ;

INSERT INTO products (name, description) VALUES ('AMD 3600', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD');
SELECT * FROM products;
INSERT INTO products (name, description) VALUES (NULL, 'Процессор для настольных персональных компьютеров, основанных на платформе AMD');
SELECT * FROM products;
INSERT INTO products (name, description) VALUES (NULL, NULL);
SELECT * FROM products;
UPDATE products SET name = NULL WHERE id = 1;
SELECT * FROM products;
UPDATE products SET description = NULL WHERE id = 1;
SELECT * FROM products;

/* (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55. */

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DELIMITER //

DROP FUNCTION IF EXISTS fib;
CREATE FUNCTION fib(num INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE x, y INT DEFAULT 1;
    DECLARE i INT DEFAULT 2;
    WHILE i < num DO
	SET y = x + y;
	SET x = y - x;
	SET i = i + 1;
    END WHILE;
    RETURN y;
END//

DELIMITER ;

SELECT fib(10);
SELECT fib(5);
SELECT fib(20);
