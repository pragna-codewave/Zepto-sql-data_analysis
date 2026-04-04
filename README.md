Zepto Data Analysis Project

Project Overview

This project performs **end-to-end data analysis** on a Zepto product dataset using **SQL, Excel, and Power BI**.
The goal is to extract meaningful business insights related to **pricing, discounts, inventory, and revenue performance**.

 Business Objectives

* Identify top-performing products and categories
* Analyze discount strategies across categories
* Detect high-value products that are out of stock
* Evaluate revenue distribution across categories
* Optimize inventory and pricing decisions

Tools & Technologies

* **SQL Server** → Data cleaning, transformation, and analysis
* **Excel** → Data validation and preprocessing
* **Power BI** → Interactive dashboard and visualization


 Data Cleaning Steps

* Removed records with **zero MRP or selling price**
* Converted prices from **paise to rupees**
* Checked for **missing/null values**
* Identified and handled **duplicate entries**


Key SQL Analysis Performed

* Top discounted products
* High MRP but out-of-stock products
* Revenue by category
* Price per gram (value analysis)
* Product segmentation (Low / Medium / Bulk)
* Inventory weight distribution
* Top 3 products per category (Window Function)
* Above-average revenue categories (CTE)

---

Dashboard Summary
 Key Metrics

* **Total Revenue:** ₹2.24M
* **Total Products:** 4,000+
* **Average Discount:** 7.62%
* **Out of Stock Products:** 453

---
Business Insights

1. Revenue Performance

* Top categories: **Cooking Essentials, Munchies, Personal Care**
* Low-performing categories: **Fruits & Vegetables, Meats**

Business heavily depends on **packaged and essential goods**

 2. Discount Strategy

* High discounts (~50%) in **packaged food categories**
* Low discounts in **premium & essential products**

Indicates **inconsistent pricing strategy**

 3. Inventory Issues

* 453 products are **out of stock**
* High-value products unavailable → **lost revenue opportunities**


4. Value Analysis (Price per Gram)

* Bulk products offer **better value**
* Smaller items are **relatively expensive**

5. Category Insights

* Fresh items (fruits, meat) have **higher discounts**
* Indicates **perishable inventory pressure**




Business Recommendations

* Implement **data-driven pricing strategy**
* Improve **inventory management** to reduce stockouts
* Focus marketing on **high-performing categories**
* Optimize supply chain for **fresh products**


---



