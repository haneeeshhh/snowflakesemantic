# Financial Data Warehouse using Snowflake, dbt and AWS

## Project Overview

This project implements an end-to-end Financial Data Warehouse using Snowflake, dbt, AWS S3 and Snowpipe.

The pipeline ingests raw CSV files from Amazon S3 into Snowflake using Snowpipe. The raw data is cleaned and validated using dbt staging models, historical changes are maintained using dbt Snapshots, dimensional models are built for analytics, and business marts are created for reporting.

The project demonstrates a modern ELT architecture following Medallion principles.

---

## Technology Stack

| Technology | Purpose |
|------------|---------|
| Snowflake | Cloud Data Warehouse |
| dbt Fusion | Data Transformation & Testing |
| AWS S3 | Raw Data Storage |
| Snowpipe | Continuous Data Ingestion |
| SNS | Event Notification |
| SQS | Notification Queue |
| IAM Roles | Secure Snowflake-AWS Integration |
| SQL | Data Transformation |
| Python | Synthetic Data Generation |

---

# Architecture

```
                         CSV Files
                             │
                             ▼
                    Amazon S3 Bucket
                             │
                  S3 Event Notification
                             │
                             ▼
                         SNS Topic
                             │
                             ▼
                         SQS Queue
                             │
                             ▼
                        Snowpipe
                             │
                             ▼
                   RAW Layer (Bronze)
                             │
                             ▼
                dbt Staging Models (Silver)
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
        dbt Snapshots              Current Dimensions
                │                         │
                └────────────┬────────────┘
                             ▼
                    FACT_TRANSACTIONS
                             │
                             ▼
                    Business Data Marts
```

---

# Medallion Architecture

## Bronze Layer (RAW)

Purpose

- Stores source files exactly as received
- No business logic
- Loaded automatically using Snowpipe

Tables

- RAW_ADVISORS
- RAW_CUSTOMERS
- RAW_ACCOUNTS
- RAW_SECURITIES
- RAW_TRANSACTIONS

---

## Silver Layer (STAGING)

Purpose

- Clean source data
- Rename columns
- Cast datatypes
- Remove invalid records
- Apply business validations
- Relationship testing
- Data quality testing

Tables

- STG_ADVISORS
- STG_CUSTOMERS
- STG_ACCOUNTS
- STG_SECURITIES
- STG_TRANSACTIONS

---

## History Layer (Snapshots)

Purpose

Maintain Slowly Changing Dimension (SCD Type 2) history.

Snapshots Used

- advisors_snapshot
- customers_snapshot
- securities_snapshot

Snapshot Strategy

- Timestamp Strategy
- Updated At: record_updated_ts
- Unique Key: Business Primary Key

Generated Metadata

- dbt_scd_id
- dbt_updated_at
- dbt_valid_from
- dbt_valid_to
- dbt_is_deleted

---

## Gold Layer

### Dimension Tables

Purpose

Store only the latest version of every business entity.

Tables

- DIM_ADVISORS
- DIM_CUSTOMERS
- DIM_ACCOUNTS
- DIM_SECURITIES

---

### Fact Table

Purpose

Store every financial transaction.

Table

- FACT_TRANSACTIONS

Measures

- Quantity
- Price
- Trade Value
- Brokerage Fee

Foreign Keys

- advisor_id
- account_id
- security_id
- trade_date

---

## Business Mart Layer

Purpose

Provide reporting-ready datasets.

Tables

- MART_CUSTOMER_ACTIVITY
- MART_ADVISOR_PERFORMANCE
- MART_SECURITY_PERFORMANCE

---

# Data Model

```
                   DIM_ADVISORS
                        │
                        │ advisor_id
                        ▼

DIM_CUSTOMERS -------------------------┐
      │                                │
      │ customer_id                    │
      ▼                                │

 DIM_ACCOUNTS                          │
      │                                │
      │ account_id                     │
      ▼                                │

                 FACT_TRANSACTIONS
                   │       │
                   │       │
                   │       │
      security_id  │       │ advisor_id
                   ▼       ▼

            DIM_SECURITIES
```

---

# Entity Relationships

## Advisors

One Advisor can manage multiple Customers.

```
Advisor
   │
   ├──────── Customer 1
   ├──────── Customer 2
   └──────── Customer N
```

---

## Customers

One Customer can own multiple Accounts.

```
Customer
   │
   ├──────── Savings Account
   ├──────── Demat Account
   └──────── Investment Account
```

---

## Accounts

One Account performs multiple Transactions.

```
Account
   │
   ├──────── Transaction
   ├──────── Transaction
   └──────── Transaction
```

---

## Securities

One Security can appear in many Transactions.

```
Security
   │
   ├──────── Transaction
   ├──────── Transaction
   └──────── Transaction
```

---

# Lineage

```
RAW_ADVISORS
       │
       ▼
STG_ADVISORS
       │
       ├──────── Snapshot
       │
       ▼
DIM_ADVISORS
       │
       ▼
FACT_TRANSACTIONS
       │
       ▼
MART_ADVISOR_PERFORMANCE



RAW_CUSTOMERS
       │
       ▼
STG_CUSTOMERS
       │
       ├──────── Snapshot
       │
       ▼
DIM_CUSTOMERS
       │
       ▼
DIM_ACCOUNTS
       │
       ▼
FACT_TRANSACTIONS
       │
       ▼
MART_CUSTOMER_ACTIVITY



RAW_SECURITIES
       │
       ▼
STG_SECURITIES
       │
       ├──────── Snapshot
       │
       ▼
DIM_SECURITIES
       │
       ▼
FACT_TRANSACTIONS
       │
       ▼
MART_SECURITY_PERFORMANCE
```

---

# Project Structure

```
financial-data-warehouse/

│
├── models/
│
├── staging/
│   ├── stg_advisors.sql
│   ├── stg_customers.sql
│   ├── stg_accounts.sql
│   ├── stg_securities.sql
│   └── stg_transactions.sql
│
├── snapshots/
│   ├── advisors_snapshot.sql
│   ├── customers_snapshot.sql
│   └── securities_snapshot.sql
│
├── history/
│   ├── advisor_history.sql
│   ├── customer_history.sql
│   └── security_history.sql
│
├── dimensions/
│   ├── dim_advisors.sql
│   ├── dim_customers.sql
│   ├── dim_accounts.sql
│   └── dim_securities.sql
│
├── facts/
│   └── fact_transactions.sql
│
├── marts/
│   ├── mart_customer_activity.sql
│   ├── mart_advisor_performance.sql
│   └── mart_security_performance.sql
│
├── macros/
│
├── tests/
│
└── dbt_project.yml
```

---

# Data Quality Tests

The project includes automated data quality validation using dbt tests.

Implemented Tests

- Not Null
- Accepted Values
- Relationships
- Custom Generic Tests
- Unique Combination Tests

Examples

- Customer belongs to a valid Advisor.
- Account belongs to a valid Customer.
- Transaction belongs to valid Account, Advisor and Security.
- No duplicate business records.
- Only valid status values are accepted.

---

# Snapshot Design

The project uses dbt Timestamp Strategy.

```
Unique Key

customer_id

Updated At

record_updated_ts
```

Whenever a tracked column changes,

Old Row

```
dbt_valid_to = Current Timestamp
```

New Row

```
dbt_valid_from = Current Timestamp
dbt_valid_to = NULL
```

Thus complete historical changes are preserved.

---

# Current Dimensions

Dimension tables always contain the latest version of each business entity.

Example

Customer Snapshot

| customer_id | location | dbt_valid_to |
|--------------|-----------|--------------|
|101|Hyderabad|2026-07-25|
|101|Mumbai|NULL|

Current Dimension

| customer_id | location |
|--------------|-----------|
|101|Mumbai|

---

# How to Run

Install dependencies

```bash
dbt deps
```

Parse project

```bash
dbt parse
```

Run transformations

```bash
dbt run
```

Run snapshots

```bash
dbt snapshot
```

Execute tests

```bash
dbt test
```

Build complete project

```bash
dbt build
```

Generate Documentation

```bash
dbt docs generate
```

Serve Documentation

```bash
dbt docs serve
```

---

# Business Use Cases

The warehouse enables reporting and analytics for:

- Customer Portfolio Analysis
- Advisor Performance Analysis
- Security Performance Analysis
- Historical Customer Tracking
- Trade Volume Analysis
- Daily Customer Activity
- Brokerage Revenue Analysis
- Transaction Trend Analysis

---

# Key Features

- Automated Snowpipe ingestion
- Incremental ELT architecture
- SCD Type 2 implementation using dbt Snapshots
- Current Dimension Tables
- Fact-Dimension Modeling
- Business Data Marts
- Automated Data Quality Testing
- AWS-Snowflake Secure Integration
- Modular dbt Project Structure
- End-to-End Financial Analytics Pipeline

---

# Author

**Haneesh Kumar**

Financial Data Warehouse Project

Built using Snowflake, dbt Fusion, AWS S3, Snowpipe and SQL.
