# What Drives London Bike Hire Demand?

Analysis of 16 years of TfL Santander Cycles daily hire data (2010–2026)
combined with historical weather data, to understand how weather, season
and day type affect demand.

## Business question
How much do weather, seasonality and weekday/weekend patterns change bike hire demand, and how could TfL use this to plan bike redistribution?

## Data sources
- TfL daily cycle hires – London Datastore ("Number of Bicycle Hires")
- Daily London weather – Open-Meteo historical API
- UK bank holidays – gov.uk

## Tools
Python (pandas), SQL (PostgreSQL), Power BI

## Project status
🚧 In progress – data collection complete

## Key findings (current pricing era, Sep 2022 – Sep 2026)
- **Rain cuts demand in proportion to how heavy it is:** light rain −11%, moderate −23%, heavy rain −29% vs dry days. Even in heavy rain, ~70% of demand remains, which suggests a large committed commuter base.
- **Temperature matters up to a point:** dry days above 20°C see 55% more hires than days below 5°C, but the effect flattens above 15°C. The biggest jump happens around 10°C.

## Limitations
- From Aug 2017, TfL notes recent daily figures may be revised slightly for ~2 weeks
- The gov.uk bank holiday feed only covers recent years