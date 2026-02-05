# 📊 Retail Stock Trading & PnL Analysis

## 📌 Project Overview
This project analyzes retail stock trading performance using historical market data from multiple publicly listed Indian companies across different industry sectors. The objective is to evaluate portfolio profitability, identify top- and underperforming stocks and sectors, and assess investment risk using metrics such as daily returns, profit and loss (PnL), and volatility.

The analysis combines SQL-based analytics with an interactive Power BI dashboard to transform raw stock price data into actionable insights for performance monitoring and decision support.

---

## 🎯 Business Objectives
- Analyze overall portfolio performance over time  
- Identify top-performing and loss-making stocks  
- Evaluate sector-wise contribution to total PnL  
- Assess risk and volatility at stock level  
- Enable interactive analysis using filters (year, sector, stock)  

---

## 📂 Dataset Summary (Raw Data)
- **Source:** Yahoo Finance  
- **Records:** ~7,000 daily trading records  
- **Stocks Covered:** 15 Indian stocks  
- **Sectors:** Banking, IT, FMCG, Energy, Manufacturing  

### Key Features
- Stock identifier and sector  
- Open, high, low, close prices  
- Daily trading volume  
- Daily return  
- Profit and Loss (PnL)  
- Trading date  

### Missing Data
- Daily return and PnL values are missing for the first trading day of each stock due to the absence of prior-day prices  
- No missing values in price and volume columns  

---

## 🧹 Data Preparation & Processing
- Removed duplicate and invalid records  
- Standardized stock symbols and sector names  
- Calculated daily returns using closing prices  
- Computed PnL assuming a consistent trade quantity  
- Structured the data using a star schema:
  - dim_date  
  - dim_stock  
  - fact_stock_prices  

---

## 🛠️ Tools & Technologies
- Python (Data collection and cleaning)  
- SQL / MySQL (Data modeling and analytics)  
- Power BI (Data visualization and dashboarding)  
- GitHub (Version control and documentation)  

---

## 📐 Data Model
The project uses a star schema consisting of:
- **Fact Table:** Stock prices and performance metrics  
- **Dimension Tables:** Date and stock metadata  

This model supports efficient querying and scalable analytics.

---

## 📊 SQL Analytics Performed
- Total and average PnL by stock and sector  
- Monthly and yearly performance trends  
- Best and worst trading days per stock  
- Sector-wise ranking based on profitability  
- Rolling 10-day PnL analysis  
- Volatility calculation using standard deviation of returns  

---

## 📈 Power BI Dashboard
A single-page interactive dashboard was developed to present insights clearly and concisely.

### Dashboard Highlights
- KPI Cards: Total PnL (₹), Total Volume, Number of Stocks  
- Trend Analysis: Portfolio PnL over time  
- Sector Analysis: Sector-wise contribution to profitability  
- Stock Performance: Top 5 stocks by total PnL  
- Comparative View: PnL vs Average Daily Return  
- Risk Indicators: Volatility and worst-case PnL  

### Interactive Slicers
- Year / Quarter  
- Sector  
- Stock Name  

---

## 💡 Key Insights
- A small subset of stocks contributes the majority of portfolio profits  
- Sector performance varies significantly over time  
- Higher returns often come with higher volatility  
- Portfolio performance is sensitive to time periods and sector allocation  

---

## 📜 License
This project is licensed under the MIT License.

---

## 🙋 Author
**Satvik Kumar**  
Aspiring Data Analyst | SQL | Python | Power BI
