USE COMERCIO_DB;
GO

INSERT INTO MARCAS (Nombre) VALUES
('Coop Apícola AMUYEN'),
('CAUQUEVA'),
('CEREALCOOP'),
('FECOAPI'),
('FLOR DE JARDIN'),
('FLOR DE MANZANO'),
('GRAPIA MILENARIA'),
('HUANACACHE'),
('ISONDU'),
('JUAL'),
('LA DULCERIA SAN PEDRO'),
('LA HUELLA'),
('LA OBEREÑA'),
('LA PAZ'),
('LA OTOMANA'),
('LAS TUNAS'),
('MATERIA PRIMA'),
('MULINI'),
('NINA´S'),
('OLIVOS DEL CARMEN'),
('CUCHIYACO'),
('PICADA VIEJA'),
('SOL Y LLUVIA'),
('TAIHANG'),
('TITRAYJU'),
('TUCANGUA');
GO


INSERT INTO CATEGORIAS (Nombre) VALUES
('MIEL'),
('PANADERÍA'),
('ALMACEN'),
('TOMATE'),
('MERMELADAS'),
('ENCURTIDOS'),
('HARINAS'),
('YERBA MATE'),
('ALMIBARES'),
('BEBIDAS'),
('DULCE'),
('COOPERATIVA'),
('STEVIOSIDO'),
('ACEITES'),
('FIDEOS'),
('CONDIMENTOS'),
('TE'),
('FRUTOS SECOS'),
('CEREALES'),
('ARROZ'),
('AZUCAR');
GO


INSERT INTO PRODUCTOS (CodigoSKU, Descripcion, IdMarca, IdCategoria, StockMinimo, StockActual, PorcentajeGanancia, Activo) VALUES
('1','MIEL X 1 KILO',1,1,10,40,20,1),
('2','MIEL X 1/2 kg ',1,1,20,41,30,1),
('3','FIDEOS DE MAIZ AMARILLO CRIOLLO',2,2,10,42,40,1),
('4','FIDEOS DE MAIZ CAPIA ',2,2,20,43,20,1),
('5','FIDEOS DE MAIZ CAPIA CON PIMENTON',2,2,10,44,30,1),
('6','FIDEOS DE MAIZ CAPIA SABOR CEBOLLA,APIO Y PUERRO',2,2,20,45,40,1),
('7','FIDEOS DE MAIZ CAPIA C/ALBAHACA',2,2,10,46,20,1),
('8','FIDEOS DE MAIZ MORADO',2,2,20,47,30,1),
('9','FIDEOS DE MAIZ MORADO Y QUINOA',2,2,10,48,40,1),
('10','FIDEOS DE MAIZ AMARIILO Y ESPINACA ',2,2,20,49,20,1),
('11','QUINOA LAVADA CAUQUEVA X 200 GRS ',2,3,10,50,30,1),
('12','AVENA ARROLLADA INSTANTANEA X 350 GRS',3,3,20,51,40,1),
('13','AVENA ARROLLADA TRADICIONAL X 400 GRS',3,3,10,52,20,1),
('14','AVENA ARROLLADA TRADICIONAL EXTRAFINA X 400 GRS',3,3,20,53,30,1),
('15','SALVADO DE AVENA  X 350 GRS',3,3,10,54,40,1),
('16','CEREALES CHOCO POP X 130GR',3,3,20,55,20,1),
('17','CEREALES MIEL POP X 130GR',3,3,10,56,30,1),
('18','TRITURADO DE TOMATE X 960 GRS.',4,4,20,57,40,1),
('19','MERMELADA DE CIRUELA X 450GRS',5,5,10,58,20,1),
('20','MERMELADA DE DAMASCO X 450GRS',5,5,20,59,30,1),
('21','MERMELADA DE DURAZNO X 450GRS',5,5,10,60,40,1),
('22','MERMELADA DE HIGO X 450GRS',5,5,20,61,20,1),
('23','MERMELADA DE KINOTOS X 450GRS',5,5,10,62,30,1),
('24','MERMELADA DE NARANJA X 450GRS',5,5,20,63,40,1),
('25','MERMELADA DE PERA X 450GRS',5,5,10,64,20,1),
('26','MERMELADA DE TOMATE X 450GRS',5,5,20,65,30,1),
('27','MERMELADA DE UVA X 450GRS',5,5,10,66,40,1),
('28','MERMELADA DE ZAPALLO X 450GRS',5,5,20,67,20,1),
('29','MERMELADA DE CIRUELA X 220 GRS',5,5,10,68,30,1),
('30','MERMELADA DE DAMASCO X 220 GRS',5,5,20,69,40,1),
('31','MERMELADA DE DURAZNO X 220 GRS',5,5,10,70,20,1),
('32','MERMELADA DE HIGO X 220 GRS',5,5,20,71,30,1),
('33','MERMELADA DE KINOTOS X 220 GRS',5,5,10,72,40,1),
('34','MERMELADA DE NARANJA X 220 GRS',5,5,20,73,20,1),
('35','MERMELADA DE PERA X 220 GRS',5,5,10,74,30,1),
('36','MERMELADA DE TOMATE X 220 GRS',5,5,20,75,40,1),
('37','MERMELADA DE UVA X 220 GRS',5,5,10,76,20,1),
('38','MERMELADA DE ZAPALLO X 220 GRS',5,5,20,77,30,1),
('39','CHUTNEY DE CEBOLLA X 220 GRS',5,6,10,78,40,1),
('40','CHUTNEY DE PERA Y JENGIBRE X 220 GRS',5,6,20,79,20,1),
('41','CHUTNEY DE TOMATE X 220 GRS',5,6,10,80,30,1),
('42','CHUTNEY DE ZAPALLO X 220 GRS',5,6,20,58,40,1),
('43','CHUTNEY DE CIRUELA Y MOSTAZA X 220 GRS',5,6,10,59,20,1),
('44','HARINA DE ARROZ X 500 GRS',6,7,20,60,30,1),
('45','HARINA DE ARVEJAS X 500 GRS',6,7,10,61,40,1),
('46','HARINA DE GARBANZOS X 500 GRS',6,7,20,62,20,1),
('47','HARINA DE LENTEJAS X 500 GRS',6,7,10,63,30,1),
('48','HARINA DE MAIZ X 500 GRS',6,7,20,64,40,1),
('49','HARINA DE SOJA X 500 GRS',6,7,10,65,20,1),
('50','HARINA DE TRIGO X 500 GRS',6,7,20,66,30,1),
('51','HARINA INTEGRAL DE CENTENO X 500 GRS',6,7,10,67,40,1),
('52','HARINA INTEGRAL DE TRIGO X 500 GRS',6,7,20,68,20,1),
('53','YERBA MATE CANCHADA X 500 GRS',7,8,10,69,30,1),
('54','YERBA MATE ELABORADA X 1 KILO',7,8,20,70,40,1),
('55','YERBA MATE ELABORADA X 500 GRS',7,8,10,71,20,1),
('56','YERBA MATE ELABORADA X 250 GRS',7,8,20,72,30,1),
('57','YERBA MATE ELABORADA ORGANICA X 500 GRS',7,8,10,73,40,1),
('58','YERBA MATE BARBACUA X 500 GRS',7,8,20,74,20,1),
('59','YERBA MATE CANCHADA X 500 GRS',8,8,10,75,30,1),
('60','YERBA MATE ELABORADA X 1 KILO',8,8,20,76,40,1),
('61','YERBA MATE ELABORADA X 500 GRS',8,8,10,77,20,1),
('62','YERBA MATE ELABORADA X 250 GRS',8,8,20,78,30,1),
('63','YERBA MATE ORGANICA X 500 GRS',8,8,10,79,40,1),
('64','YERBA MATE ORGANICA X 1 KILO',8,8,20,80,20,1),
('65','YERBA MATE COMPUESTA X 500 GRS',9,8,10,81,30,1),
('66','YERBA MATE ELABORADA X 1 KILO',9,8,20,82,40,1),
('67','YERBA MATE ELABORADA X 500 GRS',9,8,10,83,20,1),
('68','YERBA MATE ELABORADA X 250 GRS',9,8,20,84,30,1),
('69','MAMON EN ALMIBAR X 450 GRS',10,9,10,85,40,1),
('70','MAMON EN ALMIBAR X 800 GRS',10,9,20,86,20,1),
('71','MAMON EN ALMIBAR X 3 KG',10,9,10,87,30,1),
('72','MAMON EN ALMIBAR X 450 GRS',11,9,20,88,40,1),
('73','MAMON EN ALMIBAR X 800 GRS',11,9,10,89,20,1),
('74','MAMON EN ALMIBAR X 3 KG',11,9,20,90,30,1),
('75','LICOR DE ANANA X 500CC',12,10,10,91,40,1),
('76','LICOR DE CAFE AL COGNAC X 500CC',12,10,20,92,20,1),
('77','LICOR DE CHOCOLATE X 500CC',12,10,10,93,30,1),
('78','LICOR DE DULCE DE LECHE X 500CC',12,10,20,94,40,1),
('79','LICOR DE NARANJA X 500CC',12,10,10,95,20,1),
('80','LICOR DE ROSAS X 500CC',12,10,20,96,30,1),
('81','YERBA MATE CANCHADA X 500 GRS',13,8,10,97,40,1),
('82','YERBA MATE ELABORADA X 1 KILO',13,8,20,98,20,1),
('83','YERBA MATE ELABORADA X 500 GRS',13,8,10,99,30,1),
('84','YERBA MATE ELABORADA X 250 GRS',13,8,20,100,40,1),
('85','DULCE DE LECHE X 440 GRS',14,11,10,54,20,1),
('86','DULCE DE LECHE X 860 GRS',14,11,20,55,30,1),
('87','DULCE DE LECHE REPOSTERO X 10 KGS',14,11,10,56,40,1),
('88','DULCE DE LECHE REPOSTERO X 4,8 KGS',14,11,20,57,20,1),
('89','DULCE DE LECHE REPOSTERO X 980 GRS',14,11,10,58,30,1),
('90','PRODUCTOS DE COOPERATIVAS',15,12,20,59,40,1),
('91','STEVIOSIDO LIQUIDO X 100CC',16,13,10,60,20,1),
('92','STEVIOSIDO LIQUIDO X 250CC',16,13,20,61,30,1),
('93','STEVIOSIDO EN POLVO X 50 GRS',16,13,10,62,40,1),
('94','ACEITE DE OLIVA EXTRA VIRGEN X 1L',17,14,20,63,20,1),
('95','ACEITE DE OLIVA EXTRA VIRGEN X 500CC',17,14,10,64,30,1),
('96','ACEITE DE OLIVA EXTRA VIRGEN X 250CC',17,14,20,65,40,1),
('97','ACEITE DE OLIVA EXTRA VIRGEN X 5L',17,14,10,66,20,1),
('98','ACEITUNAS NEGRAS EN SALMUERA X 360 GRS',17,6,20,67,30,1),
('99','ACEITUNAS NEGRAS EN SALMUERA X 2 KG',17,6,10,68,40,1),
('100','ACEITUNAS VERDES EN SALMUERA X 360 GRS',17,6,20,69,20,1),
('101','ACEITUNAS VERDES EN SALMUERA X 2 KG',17,6,10,70,30,1),
('102','FIDEOS CARACOL X 500 GRS',18,15,20,71,40,1),
('103','FIDEOS MOSTACHOL X 500 GRS',18,15,10,72,20,1),
('104','FIDEOS TIRABUZON X 500 GRS',18,15,20,73,30,1),
('105','FIDEOS CELLENTANI X 500 GRS',18,15,10,74,40,1),
('106','FIDEOS DEDALITO X 500 GRS',18,15,20,75,20,1),
('107','FIDEOS SPAGHETTI X 500 GRS',18,15,10,76,30,1),
('108','FIDEOS AVE MARIA X 500 GRS',18,15,20,77,40,1),
('109','PIMENTON DULCE X 10 GRS',19,16,10,78,20,1),
('110','PIMENTON DULCE X 50 GRS',19,16,20,79,30,1),
('111','PIMENTON DULCE X 100 GRS',19,16,10,80,40,1),
('112','PIMENTON DULCE X 250 GRS',19,16,20,81,20,1),
('113','PIMENTON DULCE X 500 GRS',19,16,10,82,30,1),
('114','PIMENTON DULCE X 1 KG',19,16,20,83,40,1),
('115','AJI TRITURADO X 10 GRS',19,16,10,84,20,1),
('116','AJI TRITURADO X 50 GRS',19,16,20,85,30,1),
('117','AJI TRITURADO X 100 GRS',19,16,10,86,40,1),
('118','AJI TRITURADO X 250 GRS',19,16,20,87,20,1),
('119','AJI TRITURADO X 500 GRS',19,16,10,88,30,1),
('120','AJI TRITURADO X 1 KG',19,16,20,89,40,1),
('121','OREGANO X 10 GRS',19,16,10,90,20,1),
('122','OREGANO X 50 GRS',19,16,20,91,30,1),
('123','OREGANO X 100 GRS',19,16,10,92,40,1),
('124','OREGANO X 250 GRS',19,16,20,93,20,1),
('125','OREGANO X 500 GRS',19,16,10,94,30,1),
('126','OREGANO X 1 KG',19,16,20,95,40,1),
('127','PROVENZAL X 10 GRS',19,16,10,96,20,1),
('128','PROVENZAL X 50 GRS',19,16,20,97,30,1),
('129','PROVENZAL X 100 GRS',19,16,10,98,40,1),
('130','PROVENZAL X 250 GRS',19,16,20,99,20,1),
('131','PROVENZAL X 500 GRS',19,16,10,100,30,1),
('132','PROVENZAL X 1 KG',19,16,20,54,40,1),
('133','CHIMICHURRI X 10 GRS',19,16,10,55,20,1),
('134','CHIMICHURRI X 50 GRS',19,16,20,56,30,1),
('135','CHIMICHURRI X 100 GRS',19,16,10,57,40,1),
('136','CHIMICHURRI X 250 GRS',19,16,20,58,20,1),
('137','CHIMICHURRI X 500 GRS',19,16,10,59,30,1),
('138','CHIMICHURRI X 1 KG',19,16,20,60,40,1),
('139','CONDIMENTO PARA PIZZA X 10 GRS',19,16,10,61,20,1),
('140','CONDIMENTO PARA PIZZA X 50 GRS',19,16,20,62,30,1),
('141','CONDIMENTO PARA PIZZA X 100 GRS',19,16,10,63,40,1),
('142','CONDIMENTO PARA PIZZA X 250 GRS',19,16,20,64,20,1),
('143','CONDIMENTO PARA PIZZA X 500 GRS',19,16,10,65,30,1),
('144','CONDIMENTO PARA PIZZA X 1 KG',19,16,20,66,40,1),
('145','CONDIMENTO PARA ARROZ X 10 GRS',19,16,10,67,20,1),
('146','CONDIMENTO PARA ARROZ X 50 GRS',19,16,20,68,30,1),
('147','CONDIMENTO PARA ARROZ X 100 GRS',19,16,10,69,40,1),
('148','CONDIMENTO PARA ARROZ X 250 GRS',19,16,20,70,20,1),
('149','CONDIMENTO PARA ARROZ X 500 GRS',19,16,10,71,30,1),
('150','CONDIMENTO PARA ARROZ X 1 KG',19,16,20,72,40,1),
('151','CONDIMENTO PARA MILANESAS X 10 GRS',19,16,10,73,20,1),
('152','CONDIMENTO PARA MILANESAS X 50 GRS',19,16,20,74,30,1),
('153','CONDIMENTO PARA MILANESAS X 100 GRS',19,16,10,75,40,1),
('154','CONDIMENTO PARA MILANESAS X 250 GRS',19,16,20,76,20,1),
('155','CONDIMENTO PARA MILANESAS X 500 GRS',19,16,10,77,30,1),
('156','CONDIMENTO PARA MILANESAS X 1 KG',19,16,20,78,40,1),
('157','NUEZ MOSCADA MOLIDA X 10 GRS',19,16,10,79,20,1),
('158','NUEZ MOSCADA MOLIDA X 50 GRS',19,16,20,80,30,1),
('159','NUEZ MOSCADA MOLIDA X 100 GRS',19,16,10,81,40,1),
('160','NUEZ MOSCADA MOLIDA X 250 GRS',19,16,20,82,20,1),
('161','NUEZ MOSCADA MOLIDA X 500 GRS',19,16,10,83,30,1),
('162','NUEZ MOSCADA MOLIDA X 1 KG',19,16,20,84,40,1),
('163','PIMIENTA BLANCA MOLIDA X 10 GRS',19,16,10,85,20,1),
('164','PIMIENTA BLANCA MOLIDA X 50 GRS',19,16,20,86,30,1),
('165','PIMIENTA BLANCA MOLIDA X 100 GRS',19,16,10,87,40,1),
('166','PIMIENTA BLANCA MOLIDA X 250 GRS',19,16,20,88,20,1),
('167','PIMIENTA BLANCA MOLIDA X 500 GRS',19,16,10,89,30,1),
('168','PIMIENTA BLANCA MOLIDA X 1 KG',19,16,20,90,40,1),
('169','PIMIENTA NEGRA MOLIDA X 10 GRS',19,16,10,91,20,1),
('170','PIMIENTA NEGRA MOLIDA X 50 GRS',19,16,20,92,30,1),
('171','PIMIENTA NEGRA MOLIDA X 100 GRS',19,16,10,93,40,1),
('172','PIMIENTA NEGRA MOLIDA X 250 GRS',19,16,20,94,20,1),
('173','PIMIENTA NEGRA MOLIDA X 500 GRS',19,16,10,95,30,1),
('174','PIMIENTA NEGRA MOLIDA X 1 KG',19,16,20,96,40,1),
('175','ACEITE DE OLIVA EXTRA VIRGEN X 250 CC',20,14,10,97,20,1),
('176','ACEITE DE OLIVA EXTRA VIRGEN X 500 CC',20,14,20,98,30,1),
('177','ACEITE DE OLIVA EXTRA VIRGEN X 1 LT',20,14,10,99,40,1),
('178','ACEITE DE OLIVA EXTRA VIRGEN X 2 LTS',20,14,20,100,20,1),
('179','ACEITE DE OLIVA EXTRA VIRGEN X 5 LTS',20,14,10,54,30,1),
('180','ACEITUNAS NEGRAS CON CAROZO X 360 GRS',20,6,20,55,40,1),
('181','ACEITUNAS NEGRAS DESCAROZADAS X 360 GRS',20,6,10,56,20,1),
('182','ACEITUNAS VERDES CON CAROZO X 360 GRS',20,6,20,57,30,1),
('183','ACEITUNAS VERDES DESCAROZADAS X 360 GRS',20,6,10,58,40,1),
('184','ACEITUNAS VERDES RELLENAS CON MORRON X 360 GRS',20,6,20,59,20,1),
('185','ACEITE DE OLIVA EXTRA VIRGEN X 250 CC',21,14,10,60,30,1),
('186','ACEITE DE OLIVA EXTRA VIRGEN X 500 CC',21,14,20,61,40,1),
('187','ACEITE DE OLIVA EXTRA VIRGEN X 1 LT',21,14,10,62,20,1),
('188','ACEITE DE OLIVA EXTRA VIRGEN X 2 LTS',21,14,20,63,30,1),
('189','ACEITE DE OLIVA EXTRA VIRGEN X 5 LTS',21,14,10,64,40,1),
('190','TOMATE TRITURADO X 960 GRS',22,4,20,65,20,1),
('191','TE EN HEBRAS NEGRO X 50 GRS',23,17,10,66,30,1),
('192','TE EN HEBRAS VERDE X 50 GRS',23,17,20,67,40,1),
('193','TE EN HEBRAS NEGRO SABORIZADO X 50 GRS (Citrus, Frutos Rojos, Vainilla y Canela)',23,17,10,68,20,1),
('194','TE EN HEBRAS VERDE SABORIZADO X 50 GRS (Maracuya y Naranja, Frutos Rojos, Tropical)',23,17,20,69,30,1),
('195','YERBA MATE ORGANICA X 500 GRS',24,8,10,70,40,1),
('196','ARROZ BLANCO X 1 KG',25,3,20,71,20,1),
('197','ARROZ BLANCO X 500 GRS',25,3,10,72,30,1),
('198','ARROZ INTEGRAL X 1 KG',25,3,20,73,40,1),
('199','ARROZ INTEGRAL X 500 GRS',25,3,10,74,20,1),
('200','POLENTA X 500 GRS',25,3,20,75,30,1),
('201','ALMENDRAS X 1 KG',17,18,10,76,40,1),
('202','ALMENDRAS X 1/2 KG',17,18,20,77,20,1),
('203','ALMENDRAS X 1/4 KG',17,18,10,78,30,1),
('204','ALMENDRAS C/CHOCOLATE X 1 KG',17,18,20,79,40,1),
('205','ALMENDRAS C/CHOCOLATE X 1/2 KG',17,18,10,80,20,1),
('206','ALMENDRAS C/CHOCOLATE X 1/4 KG',17,18,20,81,30,1),
('207','ARANDANOS C/CHOCOLATE X 1 KG',17,18,10,82,40,1),
('208','ARANDANOS C/CHOCOLATE X 1/2 KG',17,18,20,83,20,1),
('209','ARANDANOS C/CHOCOLATE X 1/4 KG',17,18,10,84,30,1),
('210','BANANA DESHIDRATADA X 1 KG',17,18,20,85,40,1),
('211','BANANA DESHIDRATADA X 1/2 KG',17,18,10,86,20,1),
('212','BANANA DESHIDRATADA X 1/4 KG',17,18,20,87,30,1),
('213','CASTAÑAS DE CAJU C/CHOCOLATE X 1 KG',17,18,10,88,40,1),
('214','CASTAÑAS DE CAJU C/CHOCOLATE X 1/2 KG',17,18,20,89,20,1),
('215','CASTAÑAS DE CAJU C/CHOCOLATE X 1/4 KG',17,18,10,90,30,1),
('216','CASTAÑAS DE CAJU S/SAL X 1 KG',17,18,20,91,40,1),
('217','CASTAÑAS DE CAJU S/SAL X 1/2 KG',17,18,10,92,20,1),
('218','CASTAÑAS DE CAJU S/SAL X 1/4 KG',17,18,20,93,30,1),
('219','CHIPS DE BANANA X 1 KG',17,18,10,94,40,1),
('220','CHIPS DE BANANA X 1/2 KG',17,18,20,95,20,1),
('221','CHIPS DE BANANA X 1/4 KG',17,18,10,96,30,1),
('222','CIRUELAS S/CAROZO X 1 KG',17,18,20,54,40,1),
('223','CIRUELAS S/CAROZO X 1/2 KG',17,18,10,55,20,1),
('224','CIRUELAS S/CAROZO X 1/4 KG',17,18,20,56,30,1),
('225','COCO EN ESCAMAS X 1 KG',17,18,10,57,40,1),
('226','COCO EN ESCAMAS X 1/2 KG',17,18,20,58,20,1),
('227','COCO EN ESCAMAS X 1/4 KG',17,18,10,59,30,1),
('228','COCO RALLADO X 1 KG',17,18,20,60,40,1),
('229','COCO RALLADO X 1/2 KG',17,18,10,61,20,1),
('230','COCO RALLADO X 1/4 KG',17,18,20,62,30,1),
('231','DATILES X 1 KG',17,18,10,63,40,1),
('232','DATILES X 1/2 KG',17,18,20,64,20,1),
('233','DATILES X 1/4 KG',17,18,10,65,30,1),
('234','DURAZNOS DESCAROZADOS X 1 KG',17,18,20,66,40,1),
('235','DURAZNOS DESCAROZADOS X 1/2 KG',17,18,10,67,20,1),
('236','DURAZNOS DESCAROZADOS X 1/4 KG',17,18,20,68,30,1),
('237','GRANOLA CROCANTE X 1 KG',17,19,10,69,40,1),
('238','GRANOLA CROCANTE X 1/2 KG',17,19,20,70,20,1),
('239','GRANOLA CROCANTE X 1/4 KG',17,19,10,71,30,1),
('240','HIGOS X 1 KG',17,18,20,72,40,1),
('241','HIGOS X 1/2 KG',17,18,10,73,20,1),
('242','HIGOS X 1/4 KG',17,18,20,74,30,1),
('243','MANI C/CHOCOLATE X 1 KG',17,18,10,75,40,1),
('244','MANI C/CHOCOLATE X 1/2 KG',17,18,20,76,20,1),
('245','MANI C/CHOCOLATE X 1/4 KG',17,18,10,77,30,1),
('246','MANI TOSTADO S/SAL X 1 KG',17,18,20,78,40,1),
('247','MANI TOSTADO S/SAL X 1/2 KG',17,18,10,79,20,1),
('248','MANI TOSTADO S/SAL X 1/4 KG',17,18,20,80,30,1),
('249','MIX ENERGETICO X 1 KG',17,18,10,81,40,1),
('250','MIX ENERGETICO X 1/2 KG',17,18,20,82,20,1),
('251','MIX ENERGETICO X 1/4 KG',17,18,10,83,30,1),
('252','MIX SALADO C/MAIZ X 1 KG',17,18,20,84,40,1),
('253','MIX SALADO C/MAIZ X 1/2 KG',17,18,10,85,20,1),
('254','MIX SALADO C/MAIZ X 1/4 KG',17,18,20,86,30,1),
('255','MIX TROPICAL X 1 KG',17,18,10,87,40,1),
('256','MIX TROPICAL X 1/2 KG',17,18,20,88,20,1),
('257','MIX TROPICAL X 1/4 KG',17,18,10,89,30,1),
('258','NUECES C/CASCARA X 1 KG',17,18,20,90,40,1),
('259','NUECES C/CASCARA X 1/2 KG',17,18,10,91,20,1),
('260','NUEZ MARIPOSA X 1 KG',17,18,20,92,30,1),
('261','NUEZ MARIPOSA X 1/2 KG',17,18,10,93,40,1),
('262','NUEZ MARIPOSA X 1/4 KG',17,18,20,94,20,1),
('263','PASAS DE ARANDANO X 1 KG',17,18,10,95,30,1),
('264','PASAS DE ARANDANO X 1/2 KG',17,18,20,96,40,1),
('265','PASAS DE ARANDANO X 1/4 KG',17,18,10,97,20,1),
('266','PASAS DE UVA C/CHOCOLATE X 1 KG',17,18,20,98,30,1),
('267','PASAS DE UVA C/CHOCOLATE X 1/2 KG',17,18,10,99,40,1),
('268','PASAS DE UVA C/CHOCOLATE X 1/4 KG',17,18,20,100,20,1),
('269','PASAS DE UVA X 1 KG',17,18,10,54,30,1),
('270','PASAS DE UVA X 1/2 KG',17,18,20,55,40,1),
('271','PASAS DE UVA X 1/4 KG',17,18,10,56,20,1),
('272','PISTACHO TOSTADO Y SALADO X 1 KG',17,18,20,57,30,1),
('273','PISTACHO TOSTADO Y SALADO X 1/2 KG',17,18,10,58,40,1),
('274','PISTACHO TOSTADO Y SALADO X 1/4',17,18,20,59,20,1),
('275','ARROZ YAMANI X 1 KG',26,20,10,60,30,1),
('276','ARROZ YAMANI X 1/2 KG',26,20,20,61,40,1),
('277','AZUCAR MASCABO X 1 KG',26,21,10,62,20,1),
('278','AZUCAR MASCABO X 1/2 KG',26,21,20,63,30,1);
GO




;WITH PreciosCTE AS (
    SELECT * FROM (
        VALUES
        ('1', 5685.66),('2', 4223.63),('3', 5174.07),('4', 5174.07),('5', 5174.07),('6', 5174.07),
        ('7', 5174.07),('8', 5174.07),('9', 5174.07),('10', 5174.07),('11', 4016.9),('12', 1422.3),
        ('13', 1409.81),('14', 1433.02),('15', 1433.02),('16', 1381.9),('17', 1381.9),('18', 2197.8),
        ('19', 1729.81),('20', 1729.81),('21', 1729.81),('22', 1729.81),('23', 1729.81),('24', 1729.81),
        ('25', 1729.81),('26', 1729.81),('27', 1729.81),('28', 1729.81),('29', 1157.04),('30', 1157.04),
        ('31', 1157.04),('32', 1157.04),('33', 1157.04),('34', 1157.04),('35', 1157.04),('36', 1157.04),
        ('37', 1157.04),('38', 1157.04),('39', 1272.74),('40', 1272.74),('41', 1272.74),('42', 1272.74),
        ('43', 1272.74),('44', 2197.8),('45', 2197.8),('46', 2197.8),('47', 2197.8),('48', 2197.8),
        ('49', 2197.8),('50', 2197.8),('51', 2197.8),('52', 2197.8),('53', 3072.03),('54', 5971.21),
        ('55', 3072.03),('56', 1593.87),('57', 4426.39),('58', 4426.39),('59', 2269.83),('60', 4323.77),
        ('61', 2269.83),('62', 1184.44),('63', 3326.83),('64', 6500.22),('65', 2568.61),('66', 4921.33),
        ('67', 2568.61),('68', 1334.84),('69', 2125.77),('70', 3624.96),('71', 11333.3),('72', 2568.61),
        ('73', 4395.8),('74', 13745.34),('75', 7156.45),('76', 7156.45),('77', 7156.45),('78', 7156.45),
        ('79', 7156.45),('80', 7156.45),('81', 3509.25),('82', 6780.27),('83', 3509.25),('84', 1826.54),
        ('85', 1943.08),('86', 3558.78),('87', 32187.75),('88', 15682.02),('89', 3624.96),('90', 4323.77),
        ('91', 2228.58),('92', 4426.39),('93', 5632.98),('94', 16127.34),('95', 8246.36),('96', 4395.8),
        ('97', 76211.75),('98', 2750.64),('99', 13025.04),('100', 2496.58),('101', 11952.28),('102', 1795.99),
        ('103', 1795.99),('104', 1795.99),('105', 1795.99),('106', 1795.99),('107', 1795.99),('108', 1795.99),
        ('109', 351.4),('110', 1373.95),('111', 2697.35),('112', 6636.57),('113', 13207),('114', 26348),
        ('115', 351.4),('116', 1373.95),('117', 2697.35),('118', 6636.57),('119', 13207),('120', 26348),
        ('121', 351.4),('122', 1373.95),('123', 2697.35),('124', 6636.57),('125', 13207),('126', 26348),
        ('127', 351.4),('128', 1373.95),('129', 2697.35),('130', 6636.57),('131', 13207),('132', 26348),
        ('133', 351.4),('134', 1373.95),('135', 2697.35),('136', 6636.57),('137', 13207),('138', 26348),
        ('139', 351.4),('140', 1373.95),('141', 2697.35),('142', 6636.57),('143', 13207),('144', 26348),
        ('145', 351.4),('146', 1373.95),('147', 2697.35),('148', 6636.57),('149', 13207),('150', 26348),
        ('151', 351.4),('152', 1373.95),('153', 2697.35),('154', 6636.57),('155', 13207),('156', 26348),
        ('157', 351.4),('158', 1373.95),('159', 2697.35),('160', 6636.57),('161', 13207),('162', 26348),
        ('163', 351.4),('164', 1373.95),('165', 2697.35),('166', 6636.57),('167', 13207),('168', 26348),
        ('169', 351.4),('170', 1373.95),('171', 2697.35),('172', 6636.57),('173', 13207),('174', 26348),
        ('175', 4323.77),('176', 8063.67),('177', 15938.67),('178', 31082.78),('179', 73783.56),('180', 2697.35),
        ('181', 2829.13),('182', 2372.48),('183', 2631.17),('184', 3072.03),('185', 4323.77),('186', 8063.67),
        ('187', 15938.67),('188', 31082.78),('189', 73783.56),('190', 2197.8),('191', 3456.24),('192', 3456.24),
        ('193', 3456.24),('194', 3456.24),('195', 4511.45),('196', 3169.17),('197', 1612.73),('198', 3169.17),
        ('199', 1612.73),('200', 1264.79),('201', 14886),('202', 7450),('203', 3730),('204', 14000),
        ('205', 7010),('206', 3510),('207', 15000),('208', 7500),('209', 3760),('210', 8660),
        ('211', 4340),('212', 2180),('213', 17560),('214', 8790),('215', 4400),('216', 14750),
        ('217', 7380),('218', 3700),('219', 7700),('220', 3860),('221', 1940),('222', 4300),
        ('223', 2160),('224', 1090),('225', 8310),('226', 4160),('227', 2090),('228', 7470),
        ('229', 3740),('230', 1880),('231', 11460),('232', 5740),('233', 2880),('234', 6420),
        ('235', 3220),('236', 1620),('237', 5800),('238', 2910),('239', 1460),('240', 4510),
        ('241', 2260),('242', 1140),('243', 6260),('244', 3140),('245', 1580),('246', 3740),
        ('247', 1880),('248', 950),('249', 9360),('250', 4690),('251', 2350),('252', 5780),
        ('253', 2900),('254', 1460),('255', 7360),('256', 3690),('257', 1850),('258', 3570),
        ('259', 1790),('260', 7480),('261', 3750),('262', 1880),('263', 12430),('264', 6220),
        ('265', 3120),('266', 10780),('267', 5400),('268', 2710),('269', 3170),('270', 1600),
        ('271', 810),('272', 16100),('273', 8060),('274', 4040),('275', 2038.92),('276', 1077.31),
        ('277', 2372.48),('278', 1245.93)
    ) AS V(CodigoSKU, Precio)
)
INSERT INTO PRECIOS_COMPRA (IdProducto, Precio, Fecha)
SELECT 
    P.Id,
    CTE.Precio,
    GETDATE()
FROM 
    PRODUCTOS P
JOIN 
    PreciosCTE CTE ON P.CodigoSKU = CTE.CodigoSKU
WHERE
    CTE.Precio IS NOT NULL AND CTE.Precio > 0;
GO

INSERT INTO USUARIOS (Nombre, Documento, Email, Telefono, Direccion, Localidad, Username, Password)
VALUES
('Lucas Fernández', '30111222', 'lfernandez@test.com', '1122334455', 'Av. Siempre Viva 123', 'CABA', 'lucasf', 'admin123'),
('María González', '28999111', 'mgonzalez@test.com', '1199887766', 'Calle Falsa 742', 'San Martín', 'mariag', 'vend123'),
('Javier Romero', '31222444', 'jromero@test.com', '1144556677', 'Av. Mitre 1550', 'Villa Ballester', 'jromero', 'dep123'),
('Carolina Pérez', '28777666', 'cperez@test.com', '1177223311', 'Calle San Juan 900', 'CABA', 'carop', 'sup123');
GO


INSERT INTO USUARIO_ROLES (IdUsuario, IdRol)
VALUES
(1, 1),  -- Lucas Fernández -> Admin
(2, 2),  -- Vendedor
(3, 2),  -- Vendedor
(4, 2);  -- Vendedor
GO



----------------------------------------
-- CLIENTES CREADOS POR USUARIO 2
----------------------------------------
INSERT INTO CLIENTES 
(Nombre, Documento, Email, Telefono, Direccion, Localidad, CondicionIVA, IdUsuarioAlta)
VALUES
('Sofía Benítez', '27811233', 'sbenitez@test.com', '1163441111', 'Lavalle 750', 'CABA', 'Consumidor Final', 2),
('Martín Acosta', '30955999', 'macosta@test.com', '1177884455', 'Belgrano 1020', 'San Martín', 'Monotributista', 2),
('Luciana Vega', '29844122', 'lvega@test.com', '1155661122', 'Arenales 520', 'CABA', 'Responsable Inscripto', 2),
('Hernán Maldonado', '31122999', 'hmaldonado@test.com', '1144778899', 'Mitre 2100', 'Avellaneda', 'Consumidor Final', 2);


----------------------------------------
-- CLIENTES CREADOS POR USUARIO 3
----------------------------------------
INSERT INTO CLIENTES 
(Nombre, Documento, Email, Telefono, Direccion, Localidad, CondicionIVA, IdUsuarioAlta)
VALUES
('Brenda López', '32211999', 'blopez@test.com', '1133557799', 'San Lorenzo 900', 'Tigre', 'Consumidor Final', 3),
('Pablo Ferreira', '27766333', 'pferreira@test.com', '1188991122', 'Mosconi 3400', 'San Martín', 'Responsable Inscripto', 3),
('Eliana Paredes', '30566711', 'eparedes@test.com', '1177992233', 'Constitución 430', 'CABA', 'Monotributista', 3),
('Gabriel Muñoz', '29455111', 'gmunoz@test.com', '1155227799', 'Triunvirato 2800', 'Villa Urquiza', 'Consumidor Final', 3);


----------------------------------------
-- CLIENTES CREADOS POR USUARIO 4
----------------------------------------
INSERT INTO CLIENTES 
(Nombre, Documento, Email, Telefono, Direccion, Localidad, CondicionIVA, IdUsuarioAlta)
VALUES
('Mariela Campos', '28877333', 'mcampos@test.com', '1166994455', 'Pueyrredón 1800', 'Recoleta', 'Responsable Inscripto', 4),
('Nicolás Guzmán', '30155422', 'nguzman@test.com', '1144558899', 'Güemes 300', 'Palermo', 'Monotributista', 4),
('Celeste Navarro', '27944321', 'cnavarro@test.com', '1177445588', 'Perú 900', 'San Isidro', 'Consumidor Final', 4),
('Rodrigo Salas', '29122777', 'rsalas@test.com', '1188112233', 'Corrientes 6400', 'Chacarita', 'Consumidor Final', 4);
GO



INSERT INTO PROVEEDORES 
(Nombre, RazonSocial, Documento, Email, Telefono, Direccion, Localidad, CondicionIVA)
VALUES
('Proveedor Oeste', 'Proveedor Oeste S.A.', '30-44444444-1', 'oeste@prov.com', '1133557799', 'Av. Rivadavia 4500', 'CABA', 'Responsable Inscripto'),

('Proveedor Este', 'Proveedor Este S.R.L.', '30-55555555-4', 'este@prov.com', '1166778899', 'Av. La Plata 1200', 'CABA', 'Responsable Inscripto'),

('Proveedor Express', 'Proveedor Express S.A.', '30-66666666-2', 'express@prov.com', '1122664488', 'Córdoba 780', 'Vicente López', 'Monotributista'),

('Tecno Distribuidora', 'Tecno Distribuidora SRL', '30-77777777-8', 'tecno@dist.com', '1177445566', 'Av. Cabildo 3200', 'CABA', 'Responsable Inscripto'),

('Global Imports', 'Global Imports S.A.', '30-88888888-6', 'global@imports.com', '1188994455', 'San Martín 1500', 'San Isidro', 'Responsable Inscripto'),

('Maxi Proveedor', 'MaxiProveedor SRL', '30-99999999-0', 'contacto@maxipro.com', '1199112233', 'Pueyrredón 2500', 'CABA', 'Monotributista'),

('Suministros Delta', 'Suministros Delta S.A.', '30-10101010-1', 'delta@sum.com', '1155223344', 'Ameghino 900', 'Tigre', 'Responsable Inscripto');
GO



---------------------------------------------------------
-- VENTA 1 — 01/09/2025 — Usuario 2 — Cliente Sofía Benítez
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (2, 4, '2025-09-01', 'R-0001-00002001', 'Efectivo', 0);
DECLARE @IdVenta101 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdVenta101, 12, 2, 1422.30),
(@IdVenta101, 19, 1, 1729.81);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta101) WHERE Id = @IdVenta101;

---------------------------------------------------------
-- VENTA 2 — 02/09/2025 — Usuario 3 — Cliente Pablo Ferreira
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (3, 10, '2025-09-02', 'R-0001-00002002', 'Tarjeta', 0);
DECLARE @IdVenta102 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdVenta102, 54, 1, 5971.21),
(@IdVenta102, 94, 1, 16127.34);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta102) WHERE Id = @IdVenta102;

---------------------------------------------------------
-- VENTA 3 — 03/09/2025 — Usuario 4 — Cliente Nicolás Guzmán
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (4, 10, '2025-09-03', 'R-0001-00002003', 'Mercado Pago', 0);
DECLARE @IdVenta103 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdVenta103, 1, 1, 5685.66),
(@IdVenta103, 37, 2, 1157.04);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta103) WHERE Id = @IdVenta103;

---------------------------------------------------------
-- VENTA 4 — 04/09/2025 — Usuario 2 — Cliente Martín Acosta
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (2, 5, '2025-09-04', 'R-0001-00002004', 'Transferencia', 0);
DECLARE @IdVenta104 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdVenta104, 176, 1, 8063.67),
(@IdVenta104, 12, 3, 1422.30);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta104) WHERE Id = @IdVenta104;

---------------------------------------------------------
-- VENTA 5 — 05/09/2025 — Usuario 3 — Cliente Eliana Paredes
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (3, 12, '2025-09-05', 'R-0001-00002005', 'Efectivo', 0);
DECLARE @IdVenta105 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdVenta105, 19, 2, 1729.81),
(@IdVenta105, 53, 1, 3072.03);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta105) WHERE Id = @IdVenta105;

---------------------------------------------------------
-- VENTA 6 — 06/09/2025 — Usuario 4 — Cliente Celeste Navarro
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (4, 8, '2025-09-06', 'R-0001-00002006', 'Tarjeta', 0);
DECLARE @IdVenta106 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdVenta106, 75, 1, 7156.45),
(@IdVenta106, 85, 1, 1943.08);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta106) WHERE Id = @IdVenta106;

---------------------------------------------------------
-- VENTA 7 — 07/09/2025 — Usuario 2 — Cliente Laura Martínez
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (2, 4, '2025-09-07', 'R-0001-00002007', 'Efectivo', 0);
DECLARE @IdVenta107 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario)
VALUES (@IdVenta107, 1, 1, 5685.66);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta107) WHERE Id = @IdVenta107;

---------------------------------------------------------
-- VENTA 8 — 08/09/2025 — Usuario 3 — Cliente Gabriel Muñoz
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (3, 7, '2025-09-08', 'R-0001-00002008', 'Mercado Pago', 0);
DECLARE @IdVenta108 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdVenta108, 12, 2, 1422.30),
(@IdVenta108, 14, 1, 1433.02);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta108) WHERE Id = @IdVenta108;

---------------------------------------------------------
-- VENTA 9 — 09/09/2025 — Usuario 4 — Cliente Rodrigo Salas
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (4, 6, '2025-09-09', 'R-0001-00002009', 'Efectivo', 0);
DECLARE @IdVenta109 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdVenta109, 60, 1, 4323.77),
(@IdVenta109, 75, 1, 7156.45);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta109) WHERE Id = @IdVenta109;

---------------------------------------------------------
-- VENTA 10 — 10/09/2025 — Usuario 2 — Cliente Valentina Torres
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (2, 6, '2025-09-10', 'R-0001-00002010', 'Transferencia', 0);
DECLARE @IdVenta110 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdVenta110, 19, 1, 1729.81),
(@IdVenta110, 37, 3, 1157.04);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta110) WHERE Id = @IdVenta110;

---------------------------------------------------------
-- VENTA 11 — 01/10/2025 — Usuario 2 — Cliente Javier Romero
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (2, 7, '2025-10-01', 'R-0001-00002011', 'Efectivo', 0);
DECLARE @IdVenta201 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA VALUES
(@IdVenta201, 12, 1, 1422.30),
(@IdVenta201, 19, 2, 1729.81);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta201) WHERE Id=@IdVenta201;

---------------------------------------------------------
-- VENTA 12 — 02/10/2025 — Usuario 3 — Cliente Brenda López
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)
VALUES (3, 10, '2025-10-02', 'R-0001-00002012', 'Tarjeta', 0);

DECLARE @IdVenta202 INT = SCOPE_IDENTITY();

INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta202, 54, 1, 5971.21),
(@IdVenta202, 60, 1, 4323.77);

UPDATE VENTAS
SET Total = (SELECT SUM(Cantidad * PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta = @IdVenta202)
WHERE Id = @IdVenta202;


---------------------------------------------------------
-- VENTA 13 — 03/10/2025 — Usuario 4 — Cliente Mariela Campos
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total) VALUES (4, 8, '2025-10-03', 'R-0001-00002013', 'Mercado Pago', 0);
DECLARE @IdVenta203 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta203, 1, 1, 5685.66),
(@IdVenta203, 14, 2, 1433.02);
UPDATE VENTAS SET Total=(SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta203) WHERE Id=@IdVenta203;

--------------------------------------------------- ------
-- VENTA 14 — 04/10/2025 — Usuario 2 — Cliente Martín Acosta
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (2, 5, '2025-10-04', 'R-0001-00002014', 'Transferencia', 0);
DECLARE @IdVenta204 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta204, 176, 1, 8063.67),
(@IdVenta204, 11, 1, 4016.90);
UPDATE VENTAS SET Total=(SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta204) WHERE Id=@IdVenta204;

---------------------------------------------------------
-- VENTA 15 — 05/10/2025 — Usuario 3 — Cliente Pablo Ferreira
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (3, 10, '2025-10-05', 'R-0001-00002015', 'Efectivo', 0);
DECLARE @IdVenta205 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta205, 37, 4, 1157.04),
(@IdVenta205, 69, 1, 2125.77);
UPDATE VENTAS SET Total=(SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta205) WHERE Id=@IdVenta205;

---------------------------------------------------------
-- VENTA 16 — 06/10/2025 — Usuario 4 — Cliente Celeste Navarro
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (4, 4, '2025-10-06', 'R-0001-00002016', 'Tarjeta', 0);
DECLARE @IdVenta206 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta206, 75, 1, 7156.45),
(@IdVenta206, 85, 2, 1943.08);
UPDATE VENTAS SET Total=(SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta206) WHERE Id=@IdVenta206;

---------------------------------------------------------
-- VENTA 17 — 07/10/2025 — Usuario 2 — Cliente Sofia Benítez
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (2, 4, '2025-10-07', 'R-0001-00002017', 'Efectivo', 0);
DECLARE @IdVenta207 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta207, 1, 1, 5685.66);
UPDATE VENTAS SET Total=(SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta207) WHERE Id=@IdVenta207;

---------------------------------------------------------
-- VENTA 18 — 08/10/2025 — Usuario 3 — Cliente Gabriel Muñoz
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (3, 3, '2025-10-08', 'R-0001-00002018', 'Mercado Pago', 0);
DECLARE @IdVenta208 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta208, 14, 2, 1433.02),
(@IdVenta208, 19, 1, 1729.81);
UPDATE VENTAS SET Total=(SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta208) WHERE Id=@IdVenta208;

---------------------------------------------------------
-- VENTA 19 — 09/10/2025 — Usuario 4 — Cliente Rodrigo Salas
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (4, 2, '2025-10-09', 'R-0001-00002019', 'Efectivo', 0);
DECLARE @IdVenta209 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta209, 60, 1, 4323.77),
(@IdVenta209, 176, 1, 8063.67);
UPDATE VENTAS SET Total=(SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta209) WHERE Id=@IdVenta209;

---------------------------------------------------------
-- VENTA 20 — 10/10/2025 — Usuario 2 — Cliente Valentina Torres
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (2, 6, '2025-10-10', 'R-0001-00002020', 'Transferencia', 0);
DECLARE @IdVenta210 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta210, 19, 1, 1729.81),
(@IdVenta210, 37, 2, 1157.04),
(@IdVenta210, 53, 1, 3072.03);
UPDATE VENTAS SET Total=(SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta210) WHERE Id=@IdVenta210;

---------------------------------------------------------
-- VENTA 21 — 01/11/2025 — Usuario 2 — Cliente Juan Pérez
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (2, 1, '2025-11-01', 'R-0001-00002021', 'Efectivo', 0);
DECLARE @IdVenta301 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta301, 12, 2, 1422.30),
(@IdVenta301, 37, 1, 1157.04);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta301) WHERE Id=@IdVenta301;

---------------------------------------------------------
-- VENTA 22 — 02/11/2025 — Usuario 3 — Cliente Ana García
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (3, 2, '2025-11-02', 'R-0001-00002022', 'Tarjeta', 0);
DECLARE @IdVenta302 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta302, 54, 1, 5971.21),
(@IdVenta302, 94, 1, 16127.34);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta302) WHERE Id=@IdVenta302;

---------------------------------------------------------
-- VENTA 23 — 03/11/2025 — Usuario 4 — Cliente Carlos López
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (4, 3, '2025-11-03', 'R-0001-00002023', 'Mercado Pago', 0);
DECLARE @IdVenta303 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta303, 1, 1, 5685.66),
(@IdVenta303, 14, 2, 1433.02);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta303) WHERE Id=@IdVenta303;

---------------------------------------------------------
-- VENTA 24 — 04/11/2025 — Usuario 2 — Cliente Laura Martínez
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (2, 4, '2025-11-04', 'R-0001-00002024', 'Transferencia', 0);
DECLARE @IdVenta304 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta304, 176, 1, 8063.67),
(@IdVenta304, 60, 1, 4323.77);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta304) WHERE Id=@IdVenta304;

---------------------------------------------------------
-- VENTA 25 — 05/11/2025 — Usuario 3 — Cliente Santiago Ruiz
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (3, 7, '2025-11-05', 'R-0001-00002025', 'Mercado Pago', 0);
DECLARE @IdVenta305 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta305, 69, 1, 2125.77),
(@IdVenta305, 19, 1, 1729.81),
(@IdVenta305, 12, 1, 1422.30);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta305) WHERE Id=@IdVenta305;

---------------------------------------------------------
-- VENTA 26 — 06/11/2025 — Usuario 4 — Cliente Valentina Torres
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (4, 6, '2025-11-06', 'R-0001-00002026', 'Efectivo', 0);
DECLARE @IdVenta306 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta306, 53, 1, 3072.03),
(@IdVenta306, 37, 2, 1157.04);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta306) WHERE Id=@IdVenta306;

---------------------------------------------------------
-- VENTA 27 — 07/11/2025 — Usuario 2 — Cliente Camila Duarte
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (2, 8, '2025-11-07', 'R-0001-00002027', 'Efectivo', 0);
DECLARE @IdVenta307 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta307, 1, 1, 5685.66),
(@IdVenta307, 12, 1, 1422.30),
(@IdVenta307, 19, 1, 1729.81);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta307) WHERE Id=@IdVenta307;

---------------------------------------------------------
-- VENTA 28 — 08/11/2025 — Usuario 3 — Cliente Pedro Sánchez
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (3, 9, '2025-11-08', 'R-0001-00002028', 'Tarjeta', 0);
DECLARE @IdVenta308 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta308, 75, 1, 7156.45),
(@IdVenta308, 14, 1, 1433.02);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta308) WHERE Id=@IdVenta308;

---------------------------------------------------------
-- VENTA 29 — 09/11/2025 — Usuario 4 — Cliente Rocío Medina
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (4, 10, '2025-11-09', 'R-0001-00002029', 'Efectivo', 0);
DECLARE @IdVenta309 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta309, 60, 1, 4323.77),
(@IdVenta309, 176, 1, 8063.67),
(@IdVenta309, 12, 1, 1422.30);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta309) WHERE Id=@IdVenta309;

---------------------------------------------------------
-- VENTA 30 — 10/11/2025 — Usuario 2 — Cliente Matías Cabrera
---------------------------------------------------------
INSERT INTO VENTAS (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, Total)VALUES (2, 5, '2025-11-10', 'R-0001-00002030', 'Transferencia', 0);
DECLARE @IdVenta310 INT = SCOPE_IDENTITY();
INSERT INTO DETALLE_VENTA (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(@IdVenta310, 37, 3, 1157.04),
(@IdVenta310, 14, 1, 1433.02);
UPDATE VENTAS SET Total = (SELECT SUM(Cantidad*PrecioUnitario) FROM DETALLE_VENTA WHERE IdVenta=@IdVenta310) WHERE Id=@IdVenta310;

---------------------------
-- COMPRAS EJEMPLO
---------------------------

-- COMPRA 1 -----------------------------------------
INSERT INTO COMPRAS (IdProveedor, IdUsuario, Fecha, Observaciones)
VALUES (1, 1, GETDATE(), 'Compra inicial de stock');

DECLARE @IdCompra1 INT = SCOPE_IDENTITY();

INSERT INTO COMPRA_LINEAS (IdCompra, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdCompra1, 1, 20, 4000),       -- Miel (ID 1)
(@IdCompra1, 12, 50, 900);       -- Avena instantánea (ID 12)

-- COMPRA 2 -----------------------------------------
INSERT INTO COMPRAS (IdProveedor, IdUsuario, Fecha, Observaciones)
VALUES (2, 1, GETDATE(), 'Reposición de mercadería variada');

DECLARE @IdCompra2 INT = SCOPE_IDENTITY();

INSERT INTO COMPRA_LINEAS (IdCompra, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdCompra2, 54, 30, 3500),   -- Yerba elaborada 1kg
(@IdCompra2, 94, 10, 12000),  -- Aceite de oliva extra virgen 1L
(@IdCompra2, 19, 40, 900);    -- Mermelada de ciruela

-- COMPRA 3 -----------------------------------------
INSERT INTO COMPRAS (IdProveedor, IdUsuario, Fecha, Observaciones)
VALUES (1, 2, GETDATE(), 'Compra por faltantes urgentes');

DECLARE @IdCompra3 INT = SCOPE_IDENTITY();

INSERT INTO COMPRA_LINEAS (IdCompra, IdProducto, Cantidad, PrecioUnitario)
VALUES
(@IdCompra3, 176, 15, 7000);   -- Aceite oliva 500cc


---------------------------
---------------------------
-- RELACIONES -----------------------------------------

INSERT INTO PRODUCTO_PROVEEDOR (IdProducto, IdProveedor) VALUES
(1,1),(1,5),
(2,1),(2,5),

(3,2),
(4,2),
(5,2),
(6,2),
(7,2),
(8,2),
(9,2),
(10,2),

(11,2),(11,3),

(12,3),
(13,3),
(14,3),
(15,3),
(16,3),
(17,3),

(18,2),

(19,1),(19,5),
(20,1),(20,5),
(21,1),(21,5),
(22,1),(22,5),
(23,1),(23,5),
(24,1),(24,5),
(25,1),(25,5),
(26,1),(26,5),
(27,1),(27,5),
(28,1),(28,5),
(29,1),(29,5),
(30,1),(30,5),
(31,1),(31,5),
(32,1),(32,5),
(33,1),(33,5),
(34,1),(34,5),
(35,1),(35,5),
(36,1),(36,5),
(37,1),(37,5),
(38,1),(38,5),

(39,4),(39,5),
(40,4),(40,5),
(41,4),(41,5),
(42,4),(42,5),
(43,4),(43,5),

(44,2),(44,3),
(45,2),(45,3),
(46,2),(46,3),
(47,2),(47,3),
(48,2),(48,3),
(49,2),(49,3),
(50,2),(50,3),
(51,2),(51,3),
(52,2),(52,3),

(53,1),(53,6),
(54,1),(54,6),
(55,1),(55,6),
(56,1),(56,6),
(57,1),(57,6),
(58,1),(58,6),
(59,1),(59,6),
(60,1),(60,6),
(61,1),(61,6),
(62,1),(62,6),
(63,1),(63,6),
(64,1),(64,6),

(65,1),(65,6),
(66,1),(66,6),
(67,1),(67,6),
(68,1),(68,6),

(69,5),
(70,5),
(71,5),
(72,5),
(73,5),
(74,5),

(75,4),
(76,4),
(77,4),
(78,4),
(79,4),
(80,4),

(81,6),
(82,6),
(83,6),
(84,6),

(85,1),(85,5),
(86,1),(86,5),
(87,1),(87,5),
(88,1),(88,5),
(89,1),(89,5),

(90,2),
(91,2),
(92,2),
(93,2),

(94,5),
(95,5),
(96,5),
(97,5),

(98,5),
(99,5),
(100,5),
(101,5),

(102,3),
(103,3),
(104,3),
(105,3),
(106,3),
(107,3),
(108,3),

-- Condimentos (proveedor 7 y 3)
(109,7),(110,7),(111,7),(112,7),(113,7),(114,7),
(115,7),(116,7),(117,7),(118,7),(119,7),(120,7),
(121,7),(122,7),(123,7),(124,7),(125,7),(126,7),
(127,7),(128,7),(129,7),(130,7),(131,7),(132,7),
(133,7),(134,7),(135,7),(136,7),(137,7),(138,7),
(139,7),(140,7),
(141,7),(142,7),(143,7),(144,7),

(145,7),(146,7),(147,7),(148,7),(149,7),(150,7),

(151,7),(152,7),(153,7),(154,7),(155,7),(156,7),

(157,7),(158,7),(159,7),(160,7),(161,7),(162,7),

(163,7),(164,7),(165,7),(166,7),(167,7),(168,7),

(169,7),(170,7),(171,7),(172,7),(173,7),(174,7),

-- Aceites OLIVOS DEL CARMEN (proveedor 5)
(175,5),
(176,5),
(177,5),
(178,5),
(179,5),

-- Aceitunas OLIVOS DEL CARMEN (proveedor 5)
(180,5),
(181,5),
(182,5),
(183,5),
(184,5),

-- Aceites CUCHIYACO (proveedor 6)
(185,6),
(186,6),
(187,6),
(188,6),
(189,6),

-- Tomate triturado (proveedor 1)
(190,1),

-- Té en hebras (proveedor 3)
(191,3),
(192,3),
(193,3),
(194,3),

-- Yerba orgánica (proveedor 5)
(195,5),

-- Arroces COOPERATIVA (proveedor 3)
(196,3),
(197,3),
(198,3),
(199,3),
(200,3),

-- Frutos secos OLIVOS DEL CARMEN (proveedor 5)
(201,5),(202,5),(203,5),(204,5),(205,5),(206,5),
(207,5),(208,5),(209,5),(210,5),
-- Frutos secos OLIVOS DEL CARMEN (proveedor 5)
(211,5),
(212,5),
(213,5),
(214,5),
(215,5),
(216,5),
(217,5),
(218,5),

(219,5),
(220,5),
(221,5),
(222,5),
(223,5),
(224,5),

(225,5),
(226,5),
(227,5),
(228,5),
(229,5),
(230,5),

(231,5),
(232,5),
(233,5),
(234,5),
(235,5),
(236,5),

-- Cereales / Granola (proveedor 3)
(237,3),
(238,3),
(239,3),

-- Frutos secos restantes OLIVOS DEL CARMEN (proveedor 5)
(240,5),
(241,5),
(242,5),

(243,5),
(244,5),
(245,5),
(246,5),
(247,5),
(248,5),

(249,5),
(250,5),
(251,5),

(252,5),
(253,5),
(254,5),

(255,5),
(256,5),
(257,5),

(258,5),
(259,5),

(260,5),
(261,5),
(262,5),

(263,5),
(264,5),
(265,5),

(266,5),
(267,5),
(268,5),

(269,5),
(270,5),
(271,5),

-- Pistachos (proveedor 5)
(272,5),
(273,5),
(274,5),

-- Arroces Yamani y Azúcar mascabo (proveedor 3)
(275,3),
(276,3),
(277,3),
(278,3);
GO