/*¬ таблице складских запасов storehouses_products в поле value могут встречатьс€ самые разные цифры: 0, если товар закончилс€ и выше нул€, если на складе имеютс€ запасы. Ќеобходимо отсортировать записи таким образом, чтобы они выводились в пор€дке увеличени€ значени€ value. ќднако, нулевые запасы должны выводитьс€ в конце, после всех записей.*/

use shop;
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
    storehouse_id int unsigned,
    product_id int unsigned,
    value int unsigned comment '«апас товарной позиции на складе',
    created_at DATETIME default current_timestamp COMMENT 'ƒата регистрации',
    updated_at DATETIME default current_timestamp ON UPDATE current_timestamp COMMENT 'ƒата последнего обновлени€ записи'
) COMMENT = '—клады и продукты';

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
  