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
- **Tube strikes are the biggest single driver of demand:** compared with the same weekday in the same month, strike days saw +48% to +114% more hires (about +80% on average). The 9 July 2015 strike was the busiest day in the scheme's history (73,094 hires). Strike-day hires cluster around 64–73k regardless of baseline, which suggests a possible fleet capacity ceiling.
- **It's mainly a commuter scheme:** weekdays are busier than weekends in every season. The weekend drop is smallest in summer (−17%) and largest in winter (−33%), so leisure riders are much more weather-sensitive than commuters.
- **The scheme has gone through four phases:** rapid growth (2011–14), maturity (2015–19), a COVID-era boom peaking in 2022 (31.7k hires/day), and a 26% drop in 2023, the first full year after the Sep 2022 tariff change. Since then demand has been recovering steadily (+2.5% in 2024, +4% in 2025), consistent with TfL/Santander's reported ~3% growth in 2025.

## Limitations
- From Aug 2017, TfL notes recent daily figures may be revised slightly for ~2 weeks
- The gov.uk bank holiday feed only covers recent years