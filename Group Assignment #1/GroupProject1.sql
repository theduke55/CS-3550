--DROP STATEMENTS
/*    
	DROP TABLE IF EXISTS dbo.MiniFigAccessory
	DROP TABLE IF EXISTS dbo.MiniFigs
	DROP TABLE IF EXISTS dbo.SetParts
	DROP TABLE IF EXISTS dbo.SetFamilies
	DROP TABLE IF EXISTS dbo.Parts
	DROP TABLE IF EXISTS dbo.Accessories
	DROP TABLE IF EXISTS dbo.Shapes
	DROP TABLE IF EXISTS dbo.Colors
	DROP TABLE IF EXISTS dbo.Sets
	*/
	
--CREATE STATEMENTS

CREATE TABLE dbo.Parts
(
	PartID INT NOT NULL,
	ColorID INT NOT NULL,
	ShapeID INT NOT NULL
);

CREATE TABLE dbo.Colors
(
	ColorID INT NOT NULL,
	ColorHex NVARCHAR(7) NOT NULL,
	ColorName NVARCHAR(MAX)
);

CREATE TABLE dbo.SetFamilies
(
	SetFamilyID INT IDENTITY(1,1) NOT NULL,
	SetFamilyName NVARCHAR(MAX) NOT NULL,
	SetID INT NOT NULL
);

CREATE TABLE dbo.Sets
(
	SetID INT NOT NULL,
	SetName NVARCHAR(MAX) NOT NULL,
	Cost MONEY NOT NULL

);

CREATE TABLE dbo.SetParts
(
	SetID INT NOT NULL,
	PartID INT NOT NULL,
	Quantity INT NOT NULL
);

CREATE TABLE dbo.MiniFigs
(
	MiniFigID INT IDENTITY(1,1) NOT NULL,
	PartID INT NOT NULL,
	MiniFigName NVARCHAR(MAX) NOT NULL,
	SetID INT NOT NULL
);

CREATE TABLE dbo.Accessories
(
	AccessoryID INT IDENTITY(1,1) NOT NULL,
	PartID INT NOT NULL,
	SetID INT NOT NULL,
	AccessoryName NVARCHAR(MAX) NOT NULL
);

CREATE TABLE dbo.Shapes
(
	ShapeID INT IDENTITY(1,1) NOT NULL,
	ShapeName NVARCHAR(MAX) NOT NULL
);

CREATE TABLE dbo.MiniFigAccessory
(
	AccessoryID INT NOT NULL,
	MiniFigID INT NOT NULL
)

--ADD PRIMARY KEYS
ALTER TABLE Parts
	ADD CONSTRAINT PK_Parts PRIMARY KEY CLUSTERED (PartID);
ALTER TABLE Colors
	ADD CONSTRAINT PK_Colors PRIMARY KEY CLUSTERED (ColorID);
ALTER TABLE SetFamilies
	ADD CONSTRAINT PK_SetFamilies PRIMARY KEY CLUSTERED (SetFamilyID);
ALTER TABLE Sets
	ADD CONSTRAINT PK_Sets PRIMARY KEY CLUSTERED (SetID);
ALTER TABLE SetParts
	ADD CONSTRAINT PK_SetParts PRIMARY KEY CLUSTERED (SetID,PartID);
ALTER TABLE MiniFigs
	ADD CONSTRAINT PK_MiniFigs PRIMARY KEY CLUSTERED (MiniFigID);
ALTER TABLE Accessories
	ADD CONSTRAINT PK_Accessories PRIMARY KEY CLUSTERED (AccessoryID);
ALTER TABLE Shapes
	ADD CONSTRAINT PK_Shapes PRIMARY KEY CLUSTERED (ShapeID);
ALTER TABLE MiniFigAccessory
	ADD CONSTRAINT PK_MiniFigAccessory PRIMARY KEY CLUSTERED (AccessoryID, MiniFigID);

--ADD FOREIGN KEYS
ALTER TABLE Parts
	ADD CONSTRAINT FK_Parts 
	FOREIGN KEY (ColorID) REFERENCES Colors(ColorID),
	FOREIGN KEY (ShapeID) REFERENCES Shapes(ShapeID);
ALTER TABLE SetFamilies
	ADD CONSTRAINT FK_SetFamilies 
	FOREIGN KEY (SetID) REFERENCES Sets(SetID);
ALTER TABLE SetParts
	ADD CONSTRAINT FK_SetParts
	FOREIGN KEY (SetID) REFERENCES Sets(SetID),
	FOREIGN KEY (PartID) REFERENCES Parts(PartID);
ALTER TABLE MiniFigs
	ADD CONSTRAINT FK_MiniFigs 
	FOREIGN KEY (PartID) REFERENCES Parts(PartID),
	FOREIGN KEY (SetID) REFERENCES Sets(SetID);
ALTER TABLE Accessories
	ADD CONSTRAINT FK_Accessories
	FOREIGN KEY (SetID) REFERENCES Sets(SetID);
ALTER TABLE MiniFigAccessory
	ADD CONSTRAINT FK_MiniFigAccessory
	FOREIGN KEY (AccessoryID) REFERENCES Accessories(AccessoryID),
	FOREIGN KEY (MiniFigID) REFERENCES MiniFigs(MiniFigID);


--Insert data into the Shapes table
INSERT dbo.Shapes (ShapeName)
VALUES ('Rectangular Prism'),
	('Cylinder'),
	('Pipe'),
	('Chewbacca Crossbow'),
	('Triangular Prism'),
	('Chewbacca Torso'),
	('Chewbacca Head'),
	('Chewbacca Legs'),
	('Wither Skeleton Head'),
	('Wither Skeleton Legs'),
	('Wither Skeleton Arms'),
	('Wither Skeleton Torso'),
	('Alex Head'),
	('Magma Cube'),
	('Alex Torso'),
	('Alex Enchanted Axe'),
	('Wither Skeleton Sword'),
	('Zombie Pigman Legs'),
	('Zombie Pigman Torso'),
	('Zombie Pigman Head'),
	('Alex Legs'),
	('Alex Torso Armor'),
	('Zombie Pigman Sword');

--Insert data into the Colors table
INSERT dbo.Colors (ColorID, ColorHex, ColorName)
VALUES ('240240240', '#F0F0F0', 'White'),
	('505050', '#323232', 'Black'),
	('1234353', '#7B2B35', 'Red'),
	('181243227', '#B5F3E3', 'Teal'),
	('138138138', '#8A8A8A', 'Grey'),
	('808080', '#505050', 'Dark Grey'),
	('190190180', '#BEBEB4', 'Clear Grey'),
	('144128106', '#90806A', 'Tan'),
	('1106950', '#6E4532', 'Light Brown'),
	('543810', '#36260A', 'Brown'),
	('874016', '#572810', 'Dark Red'),
	('23812511', '#EE7D0B', 'Orange'),
	('10878112', '#6C4E70', 'Purple'),
	('24115559', '#F19B3B', 'Clear Orange'),
	('229220129', '#E5DC81', 'Yellow'),
	('238149187', '#EE95BB', 'Pink');

--Insert Star Wars Parts
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('300101','240240240','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('300326','505050','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('393726','505050','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('3005740','240240240','2')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('3005741','1234353','2')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4183544','181243227','2')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4211396','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4211445','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4211476','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4211508','138138138','3')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4211791','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4211881','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4222042','808080','5')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4244368','190190180','5')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4278274','808080','2')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4282789','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4290149','808080','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4290150','808080','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4521921','138138138','5')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4526932','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4527767','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4528604','144128106','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4539429','808080','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4550169','1234353','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4598526','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4617248','138138138','4')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4619636','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4654582','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('4666352','1106950','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6000606','808080','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6015349','138138138','2')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6028813','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6051334','808080','2')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6051920','181243227','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6058788','543810','6')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6063666','543810','7')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6063675','543810','8')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6066097','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6092597','1234353','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6102357','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6139403','505050','2')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6167514','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6168647','138138138','2')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6170569','138138138','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6179186','138138138','2')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6186657','138138138','5')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6196221','874016','1')
INSERT dbo.Parts (PartID, ColorID, ShapeID) VALUES ('6212316','138138138','2')

--Insert Minecraft parts
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6097028','240240240','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('302201','240240240','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('302321','1234353','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6126048','1234353','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('281726','505050','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6162511','505050','9')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6124849','505050','10')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4505757','505050','11')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6139126','505050','12')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('302326','505050','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('403226','505050','2')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4211088','138138138','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6126083','138138138','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4567887','138138138','5')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4211085','138138138','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4153825','23812511','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4558595','23812511','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4159007','23812511','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4121967','23812511','5')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6162510','23812511','13')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4153827','23812511','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4648853','23812511','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6034497','23812511','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4211405','138138138','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4211406','138138138','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4211404','138138138','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6028115','874016','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4211525','138138138','2')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4211529','138138138','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4211395','138138138','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4613761','874016','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6176402','874016','14')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6117418','874016','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4549436','144128106','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6121832','181243227','15')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6167588','10878112','16')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6134370','138138138','17')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4244369','24115559','5')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4280341','24115559','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4567338','24115559','2')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('4194746','229220129','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6112895','238149187','18')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6114330','238149187','19')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6162507','238149187','20')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6092677','543810','1')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6138047','138138138','21')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6101856','138138138','22')
INSERT INTO dbo.Parts(PartID, ColorID, ShapeID) VALUES ('6093621','23812511','23')

--Insert data into the Sets table
INSERT dbo.Sets (SetID, SetName, Cost)
VALUES ('75193', 'Millennium Falcon Microfighter', 9.99),
	('21139', 'Nether Fight', 11.99);

--Insert data into the SetFamilies
INSERT dbo.SetFamilies (SetFamilyName, SetID)
VALUES ('Star Wars', '75193'),
	('Minecraft', '21139');

--Insert Star Wars data into the SetParts
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','300101','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','300326','2');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','393726','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','3005740','2');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','3005741','4');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4183544','4');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4211396','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4211445','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4211476','4');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4211508','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4211791','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4211881','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4222042','4');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4244368','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4278274','4');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4282789','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4290149','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4290150','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4521921','3');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4526932','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4527767','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4528604','6');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4539429','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4550169','2');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4598526','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4617248','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4619636','4');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4654582','2');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','4666352','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6000606','3');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6015349','2');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6028813','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6051334','2');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6051920','2');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6058788','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6063666','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6063675','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6066097','3');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6092597','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6102357','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6139403','6');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6167514','2');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6168647','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6170569','2');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6179186','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6186657','2');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6196221','1');
INSERT dbo.SetParts (SetID, PartID, Quantity) VALUES ('75193','6212316','1');

--Insert Minecraft data into the SetParts table
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6097028','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','302201','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','302321','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6126048','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','281726','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6162511','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6124849','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4505757','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6139126','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','302326','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','403226','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4211088','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6126083','3')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4567887','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4211085','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4153825','4')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4558595','4')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4159007','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4121967','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6162510','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4153827','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4648853','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6034497','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4211405','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4211406','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4211404','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6028115','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4211525','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4211529','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4211395','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4613761','8')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6176402','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6117418','6')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4549436','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6121832','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6167588','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6134370','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4244369','3')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4280341','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4567338','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','4194746','2')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6112895','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6114330','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6162507','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6092677','4')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6138047','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6101856','1')
INSERT INTO dbo.SetParts(SetID, PartID, Quantity) VALUES ('21139','6093621','1')

--Insert data into the Accessories table
INSERT dbo.Accessories (PartID, SetID, AccessoryName)
VALUES ('4617248', '75193', 'Chewbacca Crossbow'), --Chewbacca Crossbow
	('6167588', '21139', 'Alex Enchanted Axe'), --Alex Enchanted Axe
	('6134370', '21139', 'Wither Skeleton Sword'), --Wither Skeleton Sword
	('6101856', '21139', 'Alex Torso Armor'), --Alex Torso Armor
	('6093621', '21139', 'Zombie Pigman Sword'); --Zombie Pigman Sword

--Insert data into the MiniFigs table
INSERT dbo.MiniFigs (PartID, MiniFigName, SetID)
VALUES ('6058788', 'Chewbacca', '75193'), 
	('6063666', 'Chewbacca', '75193'),
	('6063675', 'Chewbacca', '75193'),
	('6162511', 'Wither Skeleton', '21139'),
	('6124849', 'Wither Skeleton', '21139'),
	('4505757', 'Wither Skeleton', '21139'),
	('6139126', 'Wither Skeleton', '21139'),
	('6162510', 'Alex', '21139'),
	('6121832', 'Alex', '21139'),
	('6138047', 'Alex', '21139'),
	('6112895', 'Zombie Pigman', '21139'),
	('6114330', 'Zombie Pigman', '21139'),
	('6162507', 'Zombie Pigman', '21139');

--Insert data into the MiniFigAccessory table
INSERT dbo.MiniFigAccessory (AccessoryID, MiniFigID)
VALUES ('1', '1'),
	('2', '3'),
	('3', '2'),
	('4', '3'),
	('5', '4');

--Query for minifigures
SELECT DISTINCT
	MF.MiniFigName,
	MF.SetID,
	P.PartID,
	SH.ShapeName,
	A.AccessoryName
FROM
	dbo.MiniFigs MF 
	INNER JOIN dbo.Parts P ON MF.PartID = P.PartID
	INNER JOIN dbo.Shapes SH ON P.ShapeID = SH.ShapeID
	LEFT JOIN dbo.MiniFigAccessory MFA ON MF.MiniFigID = MFA.MiniFigID
	LEFT JOIN dbo.Accessories A ON MFA.AccessoryID = A.AccessoryID;

--Star wars parts Select
SELECT 
	P.PartID, SP.Quantity, S.ShapeName, SE.SetName
FROM
	dbo.Parts P
	INNER JOIN dbo.Shapes S
	ON P.ShapeID = S.ShapeID
	INNER JOIN dbo.SetParts SP 
	ON P.PartID = SP.PartID
	INNER JOIN dbo.Sets SE
	ON SP.SetID = SE.SetID
WHERE 
	SE.SetID = 75193;

---Minecraft part select

SELECT 
	P.PartID, SP.Quantity, S.ShapeName, SE.SetName
FROM
	dbo.Parts P
	INNER JOIN dbo.Shapes S
	ON P.ShapeID = S.ShapeID
	INNER JOIN dbo.SetParts SP 
	ON P.PartID = SP.PartID
	INNER JOIN dbo.Sets SE
	ON SP.SetID = SE.SetID
WHERE 
	SE.SetID = 21139;