CREATE ROLE rec_user WITH LOGIN ENCRYPTED PASSWORD 'rec$pass';

CREATE TABLE IF NOT EXISTS country
(
	Code char(3) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	CONSTRAINT country_PK PRIMARY KEY (Code)
);



CREATE TABLE IF NOT EXISTS "user"
(
	ID SERIAL NOT NULL,
	Full_name VARCHAR(255) NOT NULL,
	Country_code char(3) NOT NULL,
	CONSTRAINT user_PK PRIMARY KEY (ID),
	CONSTRAINT user_country_code FOREIGN KEY (Country_code)
	  REFERENCES country (Code)
);
CREATE INDEX IDX_user_country_code ON "user" (Country_code);

CREATE TABLE IF NOT EXISTS login_user
(
	User_ID INT NOT NULL,
	Token VARCHAR(500) NOT NULL,
	CONSTRAINT login_user_PK PRIMARY KEY (User_ID),
	CONSTRAINT login_user_user_ID FOREIGN KEY (User_ID)
	  REFERENCES "user" (ID)
);
CREATE INDEX IDX_login_user_token ON login_user USING Hash (Token);



CREATE TABLE IF NOT EXISTS category
(
	ID SERIAL NOT NULL,
	Name VARCHAR(255) NOT NULL,
	CONSTRAINT category_PK PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS product
(
	ID SERIAL NOT NULL,
	Name VARCHAR(255) NOT NULL,
	Category_ID INT NOT NULL,
	CONSTRAINT product_PK PRIMARY KEY (ID),
	CONSTRAINT product_category FOREIGN KEY (Category_ID)
	    REFERENCES category (ID)
);
CREATE INDEX IDX_product_category_id ON product (Category_ID);


CREATE TABLE IF NOT EXISTS user_product
(
	TS TIMESTAMP DEFAULT now(),
	User_ID INT NOT NULL,
	Product_ID INT NOT NULL,
	Rank INT,
	CONSTRAINT user_product_user_ID FOREIGN KEY (User_ID)
	  REFERENCES "user" (ID),
	CONSTRAINT user_product_product_ID FOREIGN KEY (Product_ID)
	  REFERENCES product (ID)
);

CREATE INDEX IDX_user_product_user_product_ID ON user_product (TS, User_ID, Product_ID);





---------
--------- INSERT DATA

INSERT INTO Country (Code, Name)
  VALUES ('AFG','Afghanistan'),
	('ALB','Albania'),
	('DZA','Algeria'),
	('ASM','American Samoa'),
	('AND','Andorra'),
	('AGO','Angola'),
	('AIA','Anguilla'),
	('ATA','Antarctica'),
	('ATG','Antigua and Barbuda'),
	('ARG','Argentina'),
	('ARM','Armenia'),
	('ABW','Aruba'),
	('AUS','Australia'),
	('AUT','Austria'),
	('AZE','Azerbaijan'),
	('BHS','Bahamas (the)'),
	('BHR','Bahrain'),
	('BGD','Bangladesh'),
	('BRB','Barbados'),
	('BLR','Belarus'),
	('BEL','Belgium'),
	('BLZ','Belize'),
	('BEN','Benin'),
	('BMU','Bermuda'),
	('BTN','Bhutan'),
	('BOL','Bolivia (Plurinational State of)'),
	('BES','Bonaire, Sint Eustatius and Saba'),
	('BIH','Bosnia and Herzegovina'),
	('BWA','Botswana'),
	('BVT','Bouvet Island'),
	('BRA','Brazil'),
	('IOT','British Indian Ocean Territory (the)'),
	('BRN','Brunei Darussalam'),
	('BGR','Bulgaria'),
	('BFA','Burkina Faso'),
	('BDI','Burundi'),
	('CPV','Cabo Verde'),
	('KHM','Cambodia'),
	('CMR','Cameroon'),
	('CAN','Canada'),
	('CYM','Cayman Islands (the)'),
	('CAF','Central African Republic (the)'),
	('TCD','Chad'),
	('CHL','Chile'),
	('CHN','China'),
	('CXR','Christmas Island'),
	('CCK','Cocos (Keeling) Islands (the)'),
	('COL','Colombia'),
	('COM','Comoros (the)'),
	('COD','Congo (the Democratic Republic of the)'),
	('COG','Congo (the)'),
	('COK','Cook Islands (the)'),
	('CRI','Costa Rica'),
	('HRV','Croatia'),
	('CUB','Cuba'),
	('CUW','Curaçao'),
	('CYP','Cyprus'),
	('CZE','Czechia'),
	('CIV','Côte d''Ivoire'),
	('DNK','Denmark'),
	('DJI','Djibouti'),
	('DMA','Dominica'),
	('DOM','Dominican Republic (the)'),
	('ECU','Ecuador'),
	('EGY','Egypt'),
	('SLV','El Salvador'),
	('GNQ','Equatorial Guinea'),
	('ERI','Eritrea'),
	('EST','Estonia'),
	('SWZ','Eswatini'),
	('ETH','Ethiopia'),
	('FLK','Falkland Islands (the) [Malvinas]'),
	('FRO','Faroe Islands (the)'),
	('FJI','Fiji'),
	('FIN','Finland'),
	('FRA','France'),
	('GUF','French Guiana'),
	('PYF','French Polynesia'),
	('ATF','French Southern Territories (the)'),
	('GAB','Gabon'),
	('GMB','Gambia (the)'),
	('GEO','Georgia'),
	('DEU','Germany'),
	('GHA','Ghana'),
	('GIB','Gibraltar'),
	('GRC','Greece'),
	('GRL','Greenland'),
	('GRD','Grenada'),
	('GLP','Guadeloupe'),
	('GUM','Guam'),
	('GTM','Guatemala'),
	('GGY','Guernsey'),
	('GIN','Guinea'),
	('GNB','Guinea-Bissau'),
	('GUY','Guyana'),
	('HTI','Haiti'),
	('HMD','Heard Island and McDonald Islands'),
	('VAT','Holy See (the)'),
	('HND','Honduras'),
	('HKG','Hong Kong'),
	('HUN','Hungary'),
	('ISL','Iceland'),
	('IND','India'),
	('IDN','Indonesia'),
	('IRN','Iran (Islamic Republic of)'),
	('IRQ','Iraq'),
	('IRL','Ireland'),
	('IMN','Isle of Man'),
	('ISR','Israel'),
	('ITA','Italy'),
	('JAM','Jamaica'),
	('JPN','Japan'),
	('JEY','Jersey'),
	('JOR','Jordan'),
	('KAZ','Kazakhstan'),
	('KEN','Kenya'),
	('KIR','Kiribati'),
	('PRK','Korea (the Democratic People''s Republic of)'),
	('KOR','Korea (the Republic of)'),
	('KWT','Kuwait'),
	('KGZ','Kyrgyzstan'),
	('LAO','Lao People''s Democratic Republic (the)'),
	('LVA','Latvia'),
	('LBN','Lebanon'),
	('LSO','Lesotho'),
	('LBR','Liberia'),
	('LBY','Libya'),
	('LIE','Liechtenstein'),
	('LTU','Lithuania'),
	('LUX','Luxembourg'),
	('MAC','Macao'),
	('MDG','Madagascar'),
	('MWI','Malawi'),
	('MYS','Malaysia'),
	('MDV','Maldives'),
	('MLI','Mali'),
	('MLT','Malta'),
	('MHL','Marshall Islands (the)'),
	('MTQ','Martinique'),
	('MRT','Mauritania'),
	('MUS','Mauritius'),
	('MYT','Mayotte'),
	('MEX','Mexico'),
	('FSM','Micronesia (Federated States of)'),
	('MDA','Moldova (the Republic of)'),
	('MCO','Monaco'),
	('MNG','Mongolia'),
	('MNE','Montenegro'),
	('MSR','Montserrat'),
	('MAR','Morocco'),
	('MOZ','Mozambique'),
	('MMR','Myanmar'),
	('NAM','Namibia'),
	('NRU','Nauru'),
	('NPL','Nepal'),
	('NLD','Netherlands (the)'),
	('NCL','New Caledonia'),
	('NZL','New Zealand'),
	('NIC','Nicaragua'),
	('NER','Niger (the)'),
	('NGA','Nigeria'),
	('NIU','Niue'),
	('NFK','Norfolk Island'),
	('MNP','Northern Mariana Islands (the)'),
	('NOR','Norway'),
	('OMN','Oman'),
	('PAK','Pakistan'),
	('PLW','Palau'),
	('PSE','Palestine, State of'),
	('PAN','Panama'),
	('PNG','Papua New Guinea'),
	('PRY','Paraguay'),
	('PER','Peru'),
	('PHL','Philippines (the)'),
	('PCN','Pitcairn'),
	('POL','Poland'),
	('PRT','Portugal'),
	('PRI','Puerto Rico'),
	('QAT','Qatar'),
	('MKD','Republic of North Macedonia'),
	('ROU','Romania'),
	('RUS','Russian Federation (the)'),
	('RWA','Rwanda'),
	('REU','Réunion'),
	('BLM','Saint Barthélemy'),
	('SHN','Saint Helena, Ascension and Tristan da Cunha'),
	('KNA','Saint Kitts and Nevis'),
	('LCA','Saint Lucia'),
	('MAF','Saint Martin (French part)'),
	('SPM','Saint Pierre and Miquelon'),
	('VCT','Saint Vincent and the Grenadines'),
	('WSM','Samoa'),
	('SMR','San Marino'),
	('STP','Sao Tome and Principe'),
	('SAU','Saudi Arabia'),
	('SEN','Senegal'),
	('SRB','Serbia'),
	('SYC','Seychelles'),
	('SLE','Sierra Leone'),
	('SGP','Singapore'),
	('SXM','Sint Maarten (Dutch part)'),
	('SVK','Slovakia'),
	('SVN','Slovenia'),
	('SLB','Solomon Islands'),
	('SOM','Somalia'),
	('ZAF','South Africa'),
	('SGS','South Georgia and the South Sandwich Islands'),
	('SSD','South Sudan'),
	('ESP','Spain'),
	('LKA','Sri Lanka'),
	('SDN','Sudan (the)'),
	('SUR','Suriname'),
	('SJM','Svalbard and Jan Mayen'),
	('SWE','Sweden'),
	('CHE','Switzerland'),
	('SYR','Syrian Arab Republic'),
	('TWN','Taiwan (Province of China)'),
	('TJK','Tajikistan'),
	('TZA','Tanzania, United Republic of'),
	('THA','Thailand'),
	('TLS','Timor-Leste'),
	('TGO','Togo'),
	('TKL','Tokelau'),
	('TON','Tonga'),
	('TTO','Trinidad and Tobago'),
	('TUN','Tunisia'),
	('TUR','Turkey'),
	('TKM','Turkmenistan'),
	('TCA','Turks and Caicos Islands (the)'),
	('TUV','Tuvalu'),
	('UGA','Uganda'),
	('UKR','Ukraine'),
	('ARE','United Arab Emirates (the)'),
	('GBR','United Kingdom of Great Britain and Northern Ireland (the)'),
	('UMI','United States Minor Outlying Islands (the)'),
	('USA','United States of America (the)'),
	('URY','Uruguay'),
	('UZB','Uzbekistan'),
	('VUT','Vanuatu'),
	('VEN','Venezuela (Bolivarian Republic of)'),
	('VNM','Viet Nam'),
	('VGB','Virgin Islands (British)'),
	('VIR','Virgin Islands (U.S.)'),
	('WLF','Wallis and Futuna'),
	('ESH','Western Sahara'),
	('YEM','Yemen'),
	('ZMB','Zambia'),
	('ZWE','Zimbabwe'),
	('ALA','Åland Islands');

-- category
INSERT INTO category (Name)
	VALUES ('Big Data'),
	('Cloud Computing and Storage'),
	('Data Analytics'),
	('Data Centers'),
	('Information Management');
	
-- product
INSERT INTO product (Name, Category_ID)
	VALUES ('Hadoop', 1),
	('MongoDB', 1),
	('DinamoDB', 1),
	('Redshift', 1),
	('Clickhouse', 1),
	('Tarantool', 1),
	('AvroraDB', 1),
	('Vertica', 1),
	('BigData', 1),
	('PostgreSQL', 1),
	('Oracle', 1),
	('MS SQL Server', 1)	;

-- ""user""
INSERT INTO "user" (Full_name, Country_code ) VALUES	('Test User 1','CZE'), ('Test User 2','CZE');

-- login_user
INSERT INTO login_user VALUES (1, 'tokenTest1'), (2,'tokenTest2');
	
-- user_product
INSERT INTO user_product (User_ID,Product_ID,Rank)
	VALUES (1, 1, 5),
	(1, 5, 1),
	(1, 4, 2),
	(1, 2, 4),
	(1, 3, 3),
	(1, 6, 6),
	(1, 9, 9),
	(1, 8, 8),
	(1, 7, 7),
	(1, 10, 10);

--------------

GRANT SELECT, INSERT, DELETE ON ALL TABLES IN SCHEMA public TO rec_user;