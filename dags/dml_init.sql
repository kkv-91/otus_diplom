create schema if not exists stg;
create schema if not exists ds;
create schema if not exists dm;

--stg
DROP TABLE stg.taxi_trips;
CREATE TABLE stg.taxi_trips (
	id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	taxi_id int8 NULL,
	trip_start_timestamp timestamp NULL,
	trip_end_timestamp timestamp NULL,
	trip_seconds int8 NULL,
	trip_miles float8 NULL,
	pickup_census_tract int8 NULL,
	dropoff_census_tract int8 NULL,
	pickup_community_area int8 NULL,
	dropoff_community_area int8 NULL,
	fare float8 NULL,
	tips float8 NULL,
	tolls int2 NULL,
	extras int2 NULL,
	trip_total float8 NULL,
	payment_type text NULL,
	company int8 NULL,
	pickup_latitude float8 NULL,
	pickup_longitude float8 NULL,
	dropoff_latitude float8 NULL,
	dropoff_longitude float8 NULL,
	date_load timestamp NULL
);
CREATE INDEX taxi_trips_taxi_id_idx ON stg.taxi_trips USING btree (taxi_id, trip_start_timestamp, trip_end_timestamp);
DROP TABLE ds.taxi_trips;

--ds
CREATE TABLE ds.taxi_trips (
	id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	taxi_id int8 NULL,
	trip_start_timestamp timestamp NULL,
	trip_end_timestamp timestamp NULL,
	trip_seconds int8 NULL,
	trip_miles float8 NULL,
	pickup_census_tract int8 NULL,
	dropoff_census_tract int8 NULL,
	pickup_community_area int8 NULL,
	dropoff_community_area int8 NULL,
	fare float8 NULL,
	tips float8 NULL,
	tolls int2 NULL,
	extras int2 NULL,
	trip_total float8 NULL,
	payment_type text NULL,
	company int8 NULL,
	pickup_latitude float8 NULL,
	pickup_longitude float8 NULL,
	dropoff_latitude float8 NULL,
	dropoff_longitude float8 NULL
);
CREATE INDEX taxi_trips_taxi_id_idx ON ds.taxi_trips USING btree (taxi_id, trip_start_timestamp, trip_end_timestamp);
DROP TABLE dm.taxi_trips_avgs;

--dm
CREATE TABLE dm.taxi_trips_avgs (
	trip_month timestamp NULL,
	miles float8 NULL,
	totals float8 NULL,
	seconds int8 NULL
);
DROP TABLE dm.taxi_trips_sums;

CREATE TABLE dm.taxi_trips_sums (
	trip_month timestamp NULL,
	cnts int8 NULL,
	miles float8 NULL,
	totals float8 NULL,
	seconds int8 NULL
);
