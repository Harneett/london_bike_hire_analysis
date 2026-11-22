-- Add pricing era to separate behaviour before/after the Sep 2022 tariff change
ALTER TABLE daily_hires ADD COLUMN pricing_era VARCHAR(20);

UPDATE daily_hires
SET pricing_era = CASE
    WHEN date < '2022-09-12' THEN 'Pre-Sep 2022'
    ELSE 'Post-Sep 2022'
END;

-- Q1: Impact of rain on daily hires (current pricing era, excluding strike days)
WITH rain_bands AS (
    SELECT
        CASE
            WHEN rain_mm < 1  THEN '1. Dry (<1mm)'
            WHEN rain_mm < 5  THEN '2. Light rain (1-5mm)'
            WHEN rain_mm < 10 THEN '3. Moderate rain (5-10mm)'
            ELSE                   '4. Heavy rain (10mm+)'
        END AS rain_level,
        hires
    FROM daily_hires
    WHERE pricing_era = 'Post-Sep 2022'
      AND NOT is_tube_strike
),
summary AS (
    SELECT rain_level,
           COUNT(*)            AS days,
           ROUND(AVG(hires))   AS avg_hires
    FROM rain_bands
    GROUP BY rain_level
)
SELECT *,
       ROUND(100.0 * (avg_hires - FIRST_VALUE(avg_hires) OVER (ORDER BY rain_level))
             / FIRST_VALUE(avg_hires) OVER (ORDER BY rain_level), 1) AS pct_vs_dry
FROM summary
ORDER BY rain_level;

-- Q2: Average hires by temperature band (dry days only, to isolate temperature)
SELECT
    CASE
        WHEN temp_mean < 5  THEN '1. Below 5°C'
        WHEN temp_mean < 10 THEN '2. 5-10°C'
        WHEN temp_mean < 15 THEN '3. 10-15°C'
        WHEN temp_mean < 20 THEN '4. 15-20°C'
        ELSE                     '5. 20°C+'
    END AS temp_band,
    COUNT(*)                     AS days,
    ROUND(AVG(hires))            AS avg_hires,
    ROUND(AVG(sunshine_hrs), 1)  AS avg_sunshine_hrs
FROM daily_hires
WHERE pricing_era = 'Post-Sep 2022'
  AND NOT is_tube_strike
  AND NOT is_rainy
GROUP BY temp_band
ORDER BY temp_band;

-- Q3: Weekday vs weekend demand by season (current era, excl. strikes & bank holidays)
SELECT
    season,
    ROUND(AVG(hires) FILTER (WHERE NOT is_weekend)) AS weekday_avg,
    ROUND(AVG(hires) FILTER (WHERE is_weekend))     AS weekend_avg,
    ROUND(100.0 * (AVG(hires) FILTER (WHERE is_weekend) - AVG(hires) FILTER (WHERE NOT is_weekend))
                / AVG(hires) FILTER (WHERE NOT is_weekend), 1) AS weekend_vs_weekday_pct
FROM daily_hires
WHERE pricing_era = 'Post-Sep 2022'
  AND NOT is_tube_strike
  AND NOT is_bank_holiday
GROUP BY season
ORDER BY CASE season WHEN 'Spring' THEN 1 WHEN 'Summer' THEN 2
                     WHEN 'Autumn' THEN 3 ELSE 4 END;

-- Q4: Year-on-year trend (full years only, 2011-2025)
SELECT
    year,
    COUNT(*)            AS days,
    ROUND(AVG(hires))   AS avg_daily_hires,
    ROUND(100.0 * (AVG(hires) - LAG(AVG(hires)) OVER (ORDER BY year))
                / LAG(AVG(hires)) OVER (ORDER BY year), 1) AS yoy_change_pct
FROM daily_hires
WHERE year <= 2025
GROUP BY year
ORDER BY year;

-- Q5: Tube strike uplift vs a like-for-like baseline
-- Baseline = average of same weekday, same month, same year, excluding strike days
SELECT
    s.date,
    s.day_of_week,
    s.hires AS strike_day_hires,
    (SELECT ROUND(AVG(n.hires))
     FROM daily_hires n
     WHERE n.day_of_week = s.day_of_week
       AND n.year  = s.year
       AND n.month = s.month
       AND NOT n.is_tube_strike) AS normal_day_hires,
    ROUND(100.0 * (s.hires - (SELECT AVG(n.hires)
                              FROM daily_hires n
                              WHERE n.day_of_week = s.day_of_week
                                AND n.year  = s.year
                                AND n.month = s.month
                                AND NOT n.is_tube_strike))
          / (SELECT AVG(n.hires)
             FROM daily_hires n
             WHERE n.day_of_week = s.day_of_week
               AND n.year  = s.year
               AND n.month = s.month
               AND NOT n.is_tube_strike), 1) AS uplift_pct,
    s.rain_mm
FROM daily_hires s
WHERE s.is_tube_strike
ORDER BY s.date;