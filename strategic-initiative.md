# Strategic Initiative: Inventory Health and Margin Recovery

**Date:** Apr 10, 2026

## Executive Summary

This initiative is critical to improving working capital and boosting gross margin. Our objective is to proactively identify and liquidate slow-moving and excess inventory. By improving inventory turnover and minimizing write-downs, we aim to recover **$3.5M** in potential margin loss over the next two quarters. The success of this initiative depends on rapid data activation to segment and track product performance against new metrics.

## Target Categories & Scope

The focus will be on the following product categories, identified as having the highest Days in Inventory (DII) relative to sales velocity:

* Category A: Seasonal Apparel (High risk of obsolescence)  
* Category B: Outdated Electronics (Rapid depreciation of value)  
* Category C: Slow-Moving Accessories (High carrying costs)

**Goal:** Reduce the total value of inventory aged over 180 days by 25%.

## Key Performance Indicators (KPIs) & Targets

| Metric | Q2 Target | Goal |
| :---- | :---- | :---- |
| **Margin Recovery Goal** | $1.75M | Total margin recovered via targeted markdowns. |
| **Inventory Health Score** | Improve by 15% | A composite score based on DII, Gross Margin, and Stock-Out Risk. |
| **Markdown Potential** | 10% Reduction | Percentage of total inventory value designated for markdown. |
| **Inventory Turnover Ratio** | Increase by 0.5x | Measure of inventory velocity. |

## Required Data Model Measures for Tracking

1. **Inventory Health Score (Measure):** A weighted metric to rank liquidation priority.  
2. **Potential Margin Loss (Measure):** Projected loss based on current cost and DII.  
3. **Stock-Out Risk (Dimension):** A segmentation dimension for inventory that is currently critical but faces high demand risk (to be excluded from liquidation focus).  
4. **Days in Inventory (DII) by Product:** Enhanced visibility for stale inventory identification.

## Calculation Logic Definitions

*   **Inventory Health Score:** `(0.5 * (1 - DII/365)) + (0.5 * (Margin %))`. Scaled 0-100. (Items with Stock-Out Risk = 'High' are capped at 100).
*   **Potential Margin Loss:** `Inventory Cost * (Days in Inventory / 365)`.
*   **Stock-Out Risk:** `High` if `30-day Sales Units > Current Inventory Units`; `Medium` if `2 * 30-day Sales Units > Current Inventory Units`; `Low` otherwise.
*   **Inventory Turnover Ratio:** `Sold Cost (All Time) / Total Inventory Cost (All Time)`.


