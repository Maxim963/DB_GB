use shop;
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
    storehouse_id int unsigned,
    product_id int unsigned,
    value int unsigned comment 'Запас товарной позиции на складе',
    created_at DATETIME default current_timestamp COMMENT 'Дата регистрации',
    updated_at DATETIME default current_timestamp ON UPDATE current_timestamp COMMENT 'Дата последнего обновления записи'
) COMMENT = 'Склады и продукты';

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
  (1, 1, 0),
    (1, 2, 5),
    (1, 3, 0),
    (2, 4, 23),
    (2, 5, 51),
    (1, 6, 0),
    (1, 9, 0),
    (1, 7, 4);
    
SELECT * FROM storehouses_products
  ORDER BY CASE WHEN value = 0 THEN 2147483647 ELSE value end;
  