INSERT INTO stg.taxi_trips
(taxi_id, trip_start_timestamp, trip_end_timestamp, trip_seconds, trip_miles, pickup_census_tract, dropoff_census_tract, pickup_community_area, dropoff_community_area, fare, tips, tolls, extras, trip_total, payment_type, company, pickup_latitude, pickup_longitude, dropoff_latitude, dropoff_longitude, date_load)
SELECT
        taxi_id::int8,
        trip_start_timestamp::timestamp,
        trip_end_timestamp::timestamp,
        trip_seconds::int8,
        trip_miles::float8,
        pickup_census_tract::int8,
        dropoff_census_tract::int8,
        pickup_community_area::int8,
        dropoff_community_area::int8,
        fare::float8,
        tips::float8,
        tolls::int2,
        extras::int2,
        trip_total::float8,
        payment_type::text,
        company::int8,
        pickup_latitude::float8,
        pickup_longitude::float8,
        dropoff_latitude::float8,
        dropoff_longitude::float8,
        now()
FROM stg.taxi_trips_upload
;
