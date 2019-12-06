use screenshots
go

alter table Size add
constraint size_pk primary key (id_size),
constraint check_w check (width > 0),
constraint check_h check (height > 0),
constraint check_scake check (scale > 0)
go

alter table Designer add
constraint pk_designer primary key (id),
constraint unique_nick UNIQUE (nick),
constraint check_email CHECK (email like '%@%.%'),
constraint check_age CHECK (age > 13)
go

alter table Device add
constraint pk_device primary key (id),
constraint device_size_fk foreign key (size) references Size(id_size),
constraint unique_code UNIQUE (code),
constraint unique_nick_device UNIQUE (nick)
go

alter table Langs add
constraint pk_langs primary key(id)
go

alter table Master add
constraint pk_master primary key (id),
constraint master_size_fk foreign key (size) references Size(id_size),
constraint fk_lang foreign key (lang_id) references Langs (id),
constraint fk_designer foreign key (designer) references Designer (id),
constraint unique_psd unique (psd),
constraint fk_master foreign key (origin_master_id) references Master (id)
go

alter table OS add
constraint pk_os primary key (id),
constraint unique_os_name unique (name),
constraint unique_os_nick unique (nick)
go

alter table OsDeviceMaster add
constraint fk_os foreign key (id_os) references Os (id),
constraint fk_device foreign key (id_device) references Device (id),
constraint fk_master_odm foreign key (id_master) references Master (id),
constraint un_id_master UNIQUE (id_master)
go

alter table ScreenShot add
constraint pk_screen primary key (id),
constraint fk_master_screen foreign key (id_master) references Master (id),
constraint unique_tiff unique (tiff),
constraint screen_size_fk foreign key (size) references Size(id_size)
go




