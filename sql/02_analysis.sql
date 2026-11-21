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

