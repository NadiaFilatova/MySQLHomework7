-- Используя базу данных carsshop

use carsshop;
DELIMITER |
-- создайте функцию для нахождения минимального возраста клиента
CREATE FUNCTION minAge(mark VARCHAR(30))
    RETURNS int
    LANGUAGE SQL DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER
BEGIN
RETURN (SELECT age FROM clients
        WHERE age = (SELECT min(age) FROM clients));
END|

-- сделайте выборку всех машин, которые он купил
select mark, model, price, name, minAge(mark) as  age
from cars as c
         INNER JOIN marks as m ON m.id = c.mark_id
         INNER JOIN orders as o ON c.id = o.car_id
         INNER JOIN clients as cl ON o.client_id = cl.id
WHERE age = minAge(mark);
|

DROP FUNCTION minAge;|

DELIMITER ;