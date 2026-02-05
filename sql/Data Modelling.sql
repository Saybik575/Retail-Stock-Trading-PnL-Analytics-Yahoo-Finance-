SELECT * FROM cleaned_yahoo_stock_data;
SELECT COUNT(*) FROM cleaned_yahoo_stock_data;

CREATE TABLE dim_stock (
	stock_id INT AUTO_INCREMENT PRIMARY KEY,
    stock_name VARCHAR(20) UNIQUE,
    sector VARCHAR(50)
);

INSERT INTO dim_stock (stock_name, sector)
SELECT DISTINCT stock, sector
FROM cleaned_yahoo_stock_data;

SELECT * FROM dim_stock;
SELECT COUNT(*) FROM dim_stock;

CREATE TABLE dim_date (
	date_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE UNIQUE,
    year INT,
    month INT,
    day INT,
    weekday VARCHAR(10)
);

INSERT INTO dim_date (date, year, month, day, weekday)
SELECT DISTINCT
	date,
    YEAR(date),
    MONTH(date),
    DAY(date),
    DAYNAME(date)
FROM cleaned_yahoo_stock_data;

SELECT * FROM dim_date;
SELECT COUNT(*) FROM dim_date;

CREATE TABLE fact_stock_prices (
    fact_id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_id        INT,
    stock_id       INT,
    open_price     DECIMAL(10,2),
    high_price     DECIMAL(10,2),
    low_price      DECIMAL(10,2),
    close_price    DECIMAL(10,2),
    volume         BIGINT,
    daily_return   DECIMAL(10,4),
    pnl            DECIMAL(12,2),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (stock_id) REFERENCES dim_stock(stock_id)
);

INSERT INTO fact_stock_prices (
    date_id,
    stock_id,
    open_price,
    high_price,
    low_price,
    close_price,
    volume,
    daily_return,
    pnl
)
SELECT
    d.date_id,
    s.stock_id,
    CAST(c.Open AS DECIMAL(10,2)),
    CAST(c.High AS DECIMAL(10,2)),
    CAST(c.Low AS DECIMAL(10,2)),
    CAST(c.Close AS DECIMAL(10,2)),
    CAST(c.Volume AS SIGNED),
    NULLIF(c.Daily_Return, ''),
    NULLIF(c.PnL, '')
FROM cleaned_yahoo_stock_data c
JOIN dim_date d
    ON c.date = d.date
JOIN dim_stock s
    ON c.stock = s.stock_name;

SELECT * FROM fact_stock_prices;
SELECT COUNT(*) FROM fact_stock_prices;