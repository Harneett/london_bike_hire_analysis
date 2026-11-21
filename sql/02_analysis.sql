-- Add pricing era to separate behaviour before/after the Sep 2022 tariff change
ALTER TABLE daily_hires ADD COLUMN pricing_era VARCHAR(20);

UPDATE daily_hires
SET pricing_era = CASE
    WHEN date < '2022-09-12' THEN 'Pre-Sep 2022'
    ELSE 'Post-Sep 2022'
END;