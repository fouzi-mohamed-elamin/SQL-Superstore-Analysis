# Superstore Sales Analysis

## Overview
SQL-based analysis of a US retail superstore to identify sales trends, profit drivers, and areas of loss. The dataset covers 4 years of orders across different regions, categories, and customer segments.

---

## Tools
- **MySQL 8.0** — data analysis
- **MySQL Workbench** — query execution

---

## Dataset
- **Source:** Sample - Superstore (Tableau built-in dataset)
- **Also available on Kaggle:** [Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- **Period:** 2014 — 2017
- **Rows:** 9,994 orders
- **Columns:** 21 features (Order ID, Sales, Profit, Discount, Region, Category...)

---

## Project Structure

```
Superstore-Sales-Analysis/
├── README.md
├── sql/
│   └── superstore_analysis.sql
└── results/
    ├── 01_overall_performance.png
    ├── 02_top_products.png
    ├── 03_category_analysis.png
    ├── 04_regional_analysis.png
    ├── 05_states_losing_money.png
    ├── 06_discount_impact.png
    ├── 07_subcategory_best_worst.png
    ├── 08_monthly_growth.png
    └── 09_yearly_growth.png
```

---

## Analysis — 15 Questions

| # | Question | Key Finding |
|---|----------|-------------|
| 1 | Overall performance | Total sales, profit, and orders snapshot |
| 2 | Top 10 products by sales | Canon imageCLASS 2200 is the top product |
| 3 | Sales & profit by category | Technology = most profit \| Furniture = high sales, low profit |
| 4 | Sales & profit by region | West is strongest \| Central is underperforming |
| 5 | Top 10 customers by profit | High sales ≠ high profit |
| 6 | Product % of total sales | No single product dominates — revenue spread widely |
| 7 | States losing money | Several states have negative profit — pricing issue |
| 8 | Best & worst sub-categories | Copiers = best \| Tables & Bookcases = losing money |
| 9 | Shipping days by ship mode | Same Day fastest \| Standard Class up to 7 days |
| 10 | Discount impact on profit | Discount > 20% = losing money |
| 11 | Monthly sales growth | Q4 consistently highest \| overall upward trend |
| 12 | Customer profit ranking | Top customers deserve priority service |
| 13 | Running total sales | Cumulative revenue tracker over time |
| 14 | Yearly sales growth | Sales growing yearly \| profit growth slower than sales |
| 15 | Regional report by category | Stored Procedure — compare categories per region |

---

## Key Findings

- **Discount is the biggest problem** — any discount above 20% results in a loss
- **Furniture** generates high sales but consistently low or negative profit
- **Tables and Bookcases** are losing money — need pricing review
- **West region** is the most profitable \| **Central** is underperforming
- **Technology** is the most profitable category across all regions
- **Q4** is consistently the strongest sales quarter every year
- Sales are growing year over year — but **profit growth is slower than sales growth**

---

## Recommendations

1. **Cap discounts at 20%** — any higher discount directly causes losses
2. **Review Furniture pricing** — especially Tables and Bookcases sub-categories
3. **Investigate Central region** — high sales but low profit margin
4. **Focus on Technology** — highest profit margin, worth expanding
5. **Leverage Q4 trends** — increase stock and marketing budget before Q4
6. **Retain top customers** — prioritize service for highest-profit customers

---

## SQL Techniques Used

- `GROUP BY` / `HAVING` / `ORDER BY`
- `CASE WHEN` for conditional labeling
- `UNION ALL` for combining result sets
- `Subqueries` for percentage calculations
- `CTEs` (WITH clause) for multi-step queries
- `Window Functions` — `LAG()`, `RANK()`, `SUM() OVER()`
- `DATEDIFF()` for date calculations
- `Stored Procedure` with input parameter for regional reports

---

*This project is part of my Data Analyst portfolio.*
