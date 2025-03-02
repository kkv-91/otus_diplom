CREATE TABLE IF NOT EXISTS dm.taxi_trips_sums (trip_month timestamp,cnts int8,miles float8,totals float8,seconds int8);
TRUNCATE dm.taxi_trips_sums;
INSERT INTO dm.taxi_trips_sums (trip_month,cnts,miles,totals,seconds)
select date_trunc('month', trip_start_timestamp)
	,count(*)
	,sum(ds.taxi_trips.trip_miles)
	,sum(ds.taxi_trips.trip_total)
	,sum(ds.taxi_trips.trip_seconds)
from ds.taxi_trips
group by date_trunc('month', trip_start_timestamp)
;
CREATE TABLE IF NOT EXISTS dm.taxi_trips_avgs (trip_month timestamp,miles float8,totals float8,seconds int8);
TRUNCATE dm.taxi_trips_avgs;
INSERT INTO dm.taxi_trips_avgs (trip_month,miles,totals,seconds)
select date_trunc('month', trip_start_timestamp)
	,avg(ds.taxi_trips.trip_miles)
	,avg(ds.taxi_trips.trip_total)
	,avg(ds.taxi_trips.trip_seconds)
from ds.taxi_trips
group by date_trunc('month', trip_start_timestamp)
;
