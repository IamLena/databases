use master
go

if exists (select name from sys.databases where name='screenshots')
drop database screenshots
go

create database screenshots
go

use screenshots
go

CREATE TABLE Device (
	id int identity(1, 1) not null,
	code nvarchar(15) not null,
	size int not null,
	ppi int not null,
	name nvarchar(50),
	nick varchar(30) not null
)
go

CREATE TABLE Os (
	id int identity(1, 1) not null,
	name nvarchar(30) not null,
	nick varchar(15) not null,
)
go

CREATE TABLE Langs (
	id int identity(1, 1) not null,
	lang nvarchar(30) not null,
	lang_code varchar(4) not null,
	country nvarchar(40) not null,
	country_code varchar(4) not null
)
go

CREATE TABLE Designer (
	id int identity(1, 1) not null,
	nick nvarchar(20) not null,
	first_name nvarchar(30) not null,
	second_name nvarchar(30) not null,
	email nvarchar(50),
	gender char,
	age tinyint
)
go

CREATE TABLE Master (
	id int identity(1, 1) not null,
	lang_id int not null,
	content nvarchar(50) not null,
	mod_time datetime not null,
	designer int not null,
	psd nvarchar(60) not null,
	size int not null,
	origin_master_id int,
)
GO


CREATE TABLE Size (
	id_size int identity(1, 1) not null,
	width int not null,
	height int not null,
	scale int not null
)
GO

CREATE TABLE ScreenShot (
	id int identity(1, 1) not null,
	id_master int not null,
	tiff nvarchar(60) not null,
	size int
)
GO

CREATE TABLE OsDeviceMaster (
	id_device int not null,
	id_os int not null,
	id_master int not null
)
GO