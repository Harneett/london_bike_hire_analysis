CREATE TABLE daily_hires (
    date            DATE PRIMARY KEY,
    hires           INTEGER,
    temp_mean       NUMERIC(4,1),
    temp_max        NUMERIC(4,1),
    rain_mm         NUMERIC(5,1),
    wind_max_kmh    NUMERIC(5,1),
    sunshine_hrs    NUMERIC(4,1),
    year            INTEGER,
    month           INTEGER,
    day_of_week     VARCHAR(10),
    is_weekend      BOOLEAN,
    is_bank_holiday BOOLEAN,
    season          VARCHAR(10),
    is_rainy        BOOLEAN,
    is_outage       BOOLEAN,
    is_covid        BOOLEAN,
    is_tube_strike  BOOLEAN
);