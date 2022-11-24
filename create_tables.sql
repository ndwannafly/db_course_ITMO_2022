CREATE TABLE people
(
    id     SERIAL PRIMARY KEY,
    name   Varchar(32) not null,
    height integer     not null,
    birth_date    date     not null
);

CREATE TABLE devil_fruits_type
(
    id SERIAL PRIMARY KEY,
    name varchar(32) not null,
    description varchar not null
);

CREATE TABLE devil_fruits
(
  id serial primary key,
  name varchar(32) not null,
  fruit_type_id integer not null
    references devil_fruits_type,
  description varchar(32)
);

CREATE TABLE devil_fruits_owner (
    person_id integer references people,
    fruit_id integer references  devil_fruits,
    owner_level integer
                                check ( owner_level > 0 and owner_level < 1000),
    primary key (person_id, fruit_id)
);

CREATE TABLE weapon
(
    id serial primary key,
    name varchar(32) not null ,

    description varchar(32)
);

CREATE TABLE weapon_owner (
                                    person_id integer references people,
                                    weapon_id integer references  weapon,
                                    owner_level integer
                                        check ( owner_level > 0 and owner_level < 1000),
                                    primary key (person_id, weapon_id)
);

CREATE TABLE will
(
    id serial primary key,
    name varchar(32) not null ,

    description varchar(32)
);

CREATE TABLE will_owner (
                              person_id integer references people,
                              will_id integer references  will,
                              owner_level integer
                                  check ( owner_level > 0 and owner_level < 1000),
                              primary key (person_id, will_id)
);


CREATE table ship(
     id serial primary key,
     name varchar(32)
);


CREATE TABLE team
(
    id serial primary key,
    name varchar(32) NOT NULL,
    ship_id integer
        REFERENCES ship,
    value_price integer
            check ( value_price>0 )
);

CREATE TABLE pirate
(
    id serial primary key,
    person_id integer not null
        references people,
    capture_reward integer
        check ( capture_reward > 0 )
);

CREATE TABLE pirate_team
(
    pirate_id integer references pirate,
    team_id integer references team,
    title varchar(32),
    primary key (pirate_id, team_id)
);

CREATE TABLE base(
    id serial primary key ,
    name varchar(32) not null
);

CREATE TABLE Ranking(
                     id serial primary key ,
                     name varchar(32) not null
);


CREATE TABLE sentinel
(
    id serial primary key,
    person_id integer not null references people,
    ranking_id integer not null references ranking,
    base_id integer references base
);

-----------------------------
--- insert fully new person into table 'people'
create or replace function insert_person(name text, height integer, birth_date date) returns integer as
$$
declare
	person integer;

begin
	select nextval('people_id_seq') into person;

	insert into people (id, name, height, birth_date)
	values (person, insert_person.name, insert_person.height, insert_person.birth_date);
	
	return person;
end;
$$ language plpgSQL;

--- insert fully new devil_fruits_type record
create or replace function insert_devil_fruit_type(name text, description text) returns integer as
$$
declare
	type_id integer;

begin
	select nextval('devil_fruits_type_id_seq') into type_id;

	insert into devil_fruits_type (id, name, description)
	values (type_id, insert_devil_fruit_type.name, insert_devil_fruit_type.description);
	
	return type_id;
end;
$$ language plpgSQL;

--- insert fully  new devil_fruit record
create or replace function insert_devil_fruit (name text, type_id integer, description text) returns integer as 
$$
declare 
	id integer;
begin
	if (select count(*) from devil_fruits_type where devil_fruits_type.id = insert_devil_fruit.type_id) = 0 then 
		raise exception 'type id does not exists!';
	end if;
	
	select nextval('devil_fruits_id_seq' into id);

	insert into devil_fruits (id, name, fruit_type_id, description)
	values (id, insert_devil_fruit.name, insert_devil_fruit.type_id, insert_devil_fruit.description);

	return id;
end;
$$ language plpgSQL;

