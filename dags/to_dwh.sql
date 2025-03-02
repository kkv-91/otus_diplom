INSERT INTO ds.taxi_trips (taxi_id, trip_start_timestamp, trip_end_timestamp, trip_seconds, trip_miles, pickup_census_tract, dropoff_census_tract, pickup_community_area, dropoff_community_area, fare, tips, tolls, extras, trip_total, payment_type, company, pickup_latitude, pickup_longitude, dropoff_latitude, dropoff_longitude)
with upload_dates as (
   select min(trip_start_timestamp::timestamp) as date_min
         ,max(trip_start_timestamp::timestamp) as date_max
   from stg.taxi_trips_upload
)
select distinct
       a.taxi_id
      ,a.trip_start_timestamp
      ,a.trip_end_timestamp
      ,a.trip_seconds
      ,a.trip_miles
      ,a.pickup_census_tract
      ,a.dropoff_census_tract
      ,a.pickup_community_area
      ,a.dropoff_community_area
      ,a.fare
      ,a.tips
      ,a.tolls
      ,a.extras
      ,a.trip_total
      ,a.payment_type
      ,a.company
      ,a.pickup_latitude
      ,a.pickup_longitude
      ,a.dropoff_latitude
      ,a.dropoff_longitude
from stg.taxi_trips a
join upload_dates ud on a.trip_start_timestamp between ud.date_min  and ud.date_max
where not exists (select 1
                  from ds.taxi_trips b
                  where a.taxi_id = b.taxi_id
                    and a.trip_start_timestamp = b.trip_start_timestamp
                    and a.trip_end_timestamp = b.trip_end_timestamp
                 )
