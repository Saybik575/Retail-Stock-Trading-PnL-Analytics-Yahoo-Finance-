DESCRIBE dim_date;
DESCRIBE dim_stock;
DESCRIBE fact_stock_prices;

-- List of the top 5 stocks by average daily return (ignore NULL returns).
SELECT 
    ds.stock_name,
    ROUND(AVG(f.daily_return), 6) AS avg_daily_return
FROM fact_stock_prices f
JOIN dim_stock ds
    ON f.stock_id = ds.stock_id
GROUP BY ds.stock_name
ORDER BY avg_daily_return DESC
LIMIT 5;

-- Monthly average closing price for each stock
SELECT 
	ds.stock_name,
    dd.year,
    dd.month,
    ROUND(AVG(f.close_price), 6) AS avg_close_price
FROM fact_stock_prices f
JOIN dim_stock ds
	ON f.stock_id = ds.stock_id
JOIN dim_date dd
	ON f.date_id = dd.date_id
GROUP BY ds.stock_name, dd.year, dd.month;

-- 5-day moving average of closing price for each stock
SELECT
    dd.date,
    ds.stock_name,
    f.close_price,
    ROUND(
        AVG(f.close_price) OVER (
            PARTITION BY ds.stock_name
            ORDER BY dd.date
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_5d
FROM fact_stock_prices f
JOIN dim_stock ds
    ON f.stock_id = ds.stock_id
JOIN dim_date dd
    ON f.date_id = dd.date_id
ORDER BY ds.stock_name, dd.date;

-- Which sector generated the highest total PnL overall?
SELECT ds.sector, ROUND(SUM(f.pnl), 2) AS total_pnl
FROM dim_stock ds
JOIN fact_stock_prices f
	ON ds.stock_id = f.stock_id
GROUP BY ds.sector
ORDER BY total_pnl DESC 
LIMIT 1;

-- For each stock, the best trading day (highest daily return).
SELECT
    stock_name,
    date,
    daily_return
FROM (
    SELECT
        ds.stock_name,
        dd.date,
        f.daily_return,
        RANK() OVER (
            PARTITION BY ds.stock_name
            ORDER BY f.daily_return DESC
        ) AS rnk
    FROM fact_stock_prices f
    JOIN dim_stock ds
        ON f.stock_id = ds.stock_id
    JOIN dim_date dd
        ON f.date_id = dd.date_id
) ranked
WHERE rnk = 1;

-- Rank stocks within each sector by total PnL
SELECT 
    sector,
    stock_name,
    total_pnl,
    RANK() OVER (PARTITION BY sector ORDER BY total_pnl DESC) AS rank_in_sector
FROM (
    SELECT 
        ds.sector,
        ds.stock_name,
        SUM(f.pnl) AS total_pnl
    FROM fact_stock_prices f
    JOIN dim_stock ds ON f.stock_id = ds.stock_id
    GROUP BY ds.sector, ds.stock_name
) AS aggregated_pnl
ORDER BY sector, rank_in_sector;

-- Stocks that had positive PnL on more than 60% of trading days.
SELECT
	ds.stock_name,
    SUM(CASE WHEN f.pnl > 0  THEN 1 ELSE 0 END) AS positive_days,
    COUNT(*) AS total_days,
    ROUND (
        SUM(CASE WHEN f.pnl > 0 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS positive_ratio
FROM fact_stock_prices f
JOIN dim_stock ds
    ON f.stock_id = ds.stock_id
GROUP BY ds.stock_name
HAVING positive_ratio > 0.6;

-- For each stock, find the maximum daily loss (worst PnL day).
SELECT
    stock_name,
    date,
    pnl AS worst_pnl
FROM (
    SELECT
        ds.stock_name,
        dd.date,
        f.pnl,
        RANK() OVER (
            PARTITION BY ds.stock_name
            ORDER BY f.pnl ASC
        ) AS rnk
    FROM fact_stock_prices f
    JOIN dim_stock ds
        ON f.stock_id = ds.stock_id
    JOIN dim_date dd
        ON f.date_id = dd.date_id
	WHERE f.pnl IS NOT NULL
) ranked
WHERE rnk = 1;

-- Calculate the monthly volatility (standard deviation of daily returns) for each stock.
SELECT
    ds.stock_name,
    dd.year,
    dd.month,
    ROUND(
        STDDEV_POP(f.daily_return),
        6
    ) AS volatility
FROM fact_stock_prices f
JOIN dim_stock ds
    ON f.stock_id = ds.stock_id
JOIN dim_date dd
    ON f.date_id = dd.date_id
WHERE f.daily_return IS NOT NULL
GROUP BY ds.stock_name, dd.year, dd.month
ORDER BY ds.stock_name, dd.year, dd.month;

-- For each stock and date, calculate the rolling 10-day cumulative PnL.
SELECT
    dd.date,
    ds.stock_name,
    SUM(f.pnl) OVER (
        PARTITION BY ds.stock_name
        ORDER BY dd.date
        ROWS BETWEEN 9 PRECEDING AND CURRENT ROW
    ) AS rolling_10d_pnl
FROM fact_stock_prices f
JOIN dim_stock ds
    ON f.stock_id = ds.stock_id
JOIN dim_date dd
    ON f.date_id = dd.date_id
WHERE f.pnl IS NOT NULL
ORDER BY ds.stock_name, dd.date;