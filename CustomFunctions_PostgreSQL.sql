/* 1.1: Создать функцию, вставляющую новую строку в таблицу Перевозка. Функция при вызове должна возвращать идентификатор добавленной записи.
*/
DROP FUNCTION inserttransportation(integer,integer,numeric,integer,character varying,date,money)
CREATE OR REPLACE FUNCTION InsertTransportation
    (TransportationID integer,
    ClientID integer,
    Weight numeric(6, 2),
    CarID integer,
    City character varying(50),
    TransportationDate date,
    Cost money)
RETURNS integer
LANGUAGE 'sql'
AS
$$
INSERT into Transportation (TransportationID,
    ClientID,
    Weight,
    CarID,
    City,
    TransportationDate,
    Cost)
    values ($1, $2, $3, $4, $5, $6, $7);
    select $1
$$;
SELECT InsertTransportation (5001, 831, 15.30, 59, 'Эль-Пасо', '2022-11-24', 8800::MONEY);

SELECT*
FROM Transportation

/* 1.2: Создать функцию, изменяющую значения столбцов Вес, Дата и Стоимость 
    у указанной строки таблицы Перевозка на переданные новые значения*/
    Drop Function Change;
    CREATE OR REPLACE FUNCTION Change
    (TransportationID integer,
    Weight numeric(6, 2),
    TransportationDate date ,
    Cost money)
    Returns void
    Language 'sql'
    AS
    $$
    Update Transportation
    Set Weight = $2,
    TransportationDate = $3, 
    Cost =$4
    Where TransportationID = $1;
    $$;
Select Change (5002, 750, '2017-11-28', 500.0000::money);

SELECT*
FROM Transportation


    /* 1.3: Создать функцию, удаляющую из таблицы Город данные о введённом городе. 
    При её запуске должны удаляться и данные о всех перевозках в указанный город.*/
    
    CREATE OR REPLACE FUNCTION delete_City
        (CityName character varying(50))
    RETURNS void
    LANGUAGE 'sql'
    AS
    $$
    DELETE FROM Transportation
        WHERE CityName = $1;
    DELETE FROM City 
        WHERE CityName = $1;
    $$;
SELECT delete_City ('Денвер');

/*Задание 2.1:
        Создать скалярную функцию, рассчитывающую цену за перевозку 1 килограмма
        груза на основании данных об общей стоимости и общем весе перевозки.
        */
        CREATE OR REPLACE FUNCTION Cost_of_Transportation 
            (TransportationID integer)
            RETURNS money
            LANGUAGE 'sql'
        AS
            $$
        Select 
            Cost/Weight
        FROM Transportation
            WHERE TransportationID = $1
        $$;
            SELECT Cost_of_Transportation  (2000)
/*
Задание 2.2:
Написать запрос, выводящий все данные из таблицы Перевозка с добавлением
столбца со стоимостью перевозки 1 килограмма груза (рассчитываемого с
использованием созданной в задании 1 функции).
*/
Select *, Cost_of_Transportation (TransportationID)
From Transportation