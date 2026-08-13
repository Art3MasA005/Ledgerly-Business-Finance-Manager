# Ledgerly

## Product Requirements Document (PRD)

Bangladesh-focused small business ledger, sales, due, stock and payment tracking app

| Product Name | Platform | Backend | Subscription |
|---|---|---|---|
| Ledgerly | Flutter Android first | Supabase preferred | BDT 30/month |

Prepared for: Md. Yeasir Arafat  
Version: 1.0  
Date: 2 July 2026

**Core promise: দোকানের হিসাব, বাকি, বিক্রি, স্টক, খরচ ও রিপোর্ট - সব এক অ্যাপে।**

Note: This PRD is designed for AI-assisted Flutter development and includes MVP requirements, import/export compatibility, offline sync, Supabase data model, paywall rules, and release roadmap.

# Document Control

| **Field**            | **Value**                                                             |
|----------------------|-----------------------------------------------------------------------|
| Owner                | Md. Yeasir Arafat                                                     |
| Product              | Ledgerly                                                              |
| Document type        | Product Requirements Document                                         |
| Version              | 1.0                                                                   |
| Development approach | AI-assisted Flutter development with Supabase backend                 |
| Primary market       | Bangladesh small shops, micro-businesses, traders and service sellers |

| **Version** | **Date**    | **Author**                        | **Change Summary**                                                                                         |
|-------------|-------------|-----------------------------------|------------------------------------------------------------------------------------------------------------|
| 1.0         | 2 July 2026 | ChatGPT + Md. Yeasir Arafat input | Initial PRD with core features, TaliKhata PDF import/export, subscription, offline sync and Supabase plan. |

# Table of Contents

- [1. Executive Summary](#1-executive-summary)
- [2. Background and Reference Inputs](#2-background-and-reference-inputs)
- [3. Target Users and Personas](#3-target-users-and-personas)
- [4. Product Goals, Non-goals and Success Metrics](#4-product-goals-non-goals-and-success-metrics)
- [5. MVP Scope and Future Scope](#5-mvp-scope-and-future-scope)
- [6. User Experience Requirements](#6-user-experience-requirements)
- [7. Functional Requirements](#7-functional-requirements)
- [8. TaliKhata PDF Export and Import Compatibility](#8-talikhata-pdf-export-and-import-compatibility)
- [9. Subscription, Payment and Paywall Rules](#9-subscription-payment-and-paywall-rules)
- [10. Offline-first Sync and Restore Requirements](#10-offline-first-sync-and-restore-requirements)
- [11. Supabase Architecture and Suggested Database Schema](#11-supabase-architecture-and-suggested-database-schema)
- [12. Security, Privacy and Permissions](#12-security-privacy-and-permissions)
- [13. Admin Panel Requirements](#13-admin-panel-requirements)
- [14. Analytics and Charts](#14-analytics-and-charts)
- [15. Testing and QA Plan](#15-testing-and-qa-plan)
- [16. Release Roadmap](#16-release-roadmap)
- [17. Open Questions and Assumptions](#17-open-questions-and-assumptions)
- [Appendix A: UI Reference Notes](#appendix-a-ui-reference-notes)
- [Appendix B: Future AI Features](#appendix-b-future-ai-features)
- [Appendix C: Development Backlog After PRD Approval](#appendix-c-development-backlog-after-prd-approval)
# 1. Executive Summary

Ledgerly is a mobile-first business ledger application for Bangladeshi shop owners who need a simple, low-cost way to manage daily sales, customer baki/pawna, supplier dena, cashbox, reports and business data backup. The app will be built in Flutter with an offline-first local database and Supabase cloud sync so users can safely restore their data after re-login from the same or another device.

| Main User Need | MVP Focus | Monetization | Key Differentiator |
|---|---|---|---|
| Never lose baki/sales records | Ledger + Sales + Export/Import + Sync | BDT 30 monthly subscription | Import TaliKhata PDF exports |

## 1.1 Product Vision

- Create a clean, affordable and Bangla-friendly accounting app for small businesses in Bangladesh.

- Allow users to record customer payments, due sales, supplier payable, expenses and stock without complex accounting terms.

- Support offline entry first, then automatically sync to the cloud when internet is available.

- Allow direct import of existing TaliKhata-style PDF export data so users can migrate without starting from zero.

- Provide a daily sales chart on the home page so users can understand business performance at a glance.

## 1.2 One-line Positioning

**Ledgerly - দোকানের হিসাব, বাকি, বিক্রি ও রিপোর্ট সহজে রাখার অ্যাপ।**

## 1.3 MVP Decision

The first release must not try to become a full ERP. The MVP should solve the daily pain of shop owners: add transaction fast, see due balance, export/share report, import old data, and keep cloud backup reliable.

# 2. Background and Reference Inputs

The requirement is based on the current TaliKhata-style workflow shown in the provided home page screenshot and the uploaded PDF export sample. Ledgerly should not copy brand identity, but it should preserve user expectations: quick modules, total pawna/dena, customer/supplier list, export, data backup and simple Bangla wording.

## 2.1 Reference PDF Export Structure

The uploaded sample PDF export contains a shop header, phone number, generated report time, transaction count, a customer/supplier table, Pabo/Debo columns and totals. This format is important because Ledgerly must be able to import similar exports.

| **Detected Field**  | **Example from sample**        | **Ledgerly Mapping**                                           |
|---------------------|--------------------------------|----------------------------------------------------------------|
| Shop name           | Yeasir Traders                 | businesses.name                                                |
| Shop phone          | +880 188706 1209               | businesses.phone                                               |
| Report generated at | 27 Jun 2026 - 11:37 PM         | import_jobs.source_generated_at                                |
| Transaction count   | 05                             | import_jobs.detected_row_count                                 |
| Contact row         | Rakib (Supplier) - 01843513945 | contacts.name, contacts.type, contacts.phone                   |
| Last activity       | 26 Jun - পেলাম 5,642.00        | transactions.date, transactions.direction, transactions.amount |
| Pabo column         | 150,000.00 etc.                | receivable/opening balance or ledger transaction               |
| Debo column         | 5,642.00 etc.                  | payable/opening balance or ledger transaction                  |
| Totals              | 230,000.00 / 5,642.00          | report summary and import validation                           |

## 2.2 Reference Home UI Observations

- Top area: business selector, plan/status tag, inbox/help shortcuts.

- Module grid: multi-business, stock, notes, group ledger, QR, backup, message, cashbox.

- Summary card: total pawna and total dena.

- Search/filter/export controls near customer/supplier list.

- Customer/supplier rows show initials, name, last activity/day, amount and direction.

- Bottom navigation: ledger, cashbox, wallet and menu.

## 2.3 Product Principle

Ledgerly can be inspired by familiar workflows, but should use its own branding, layout, color system, icons and wording so it becomes a distinct product.

# 3. Target Users and Personas

| **Persona**                    | **Business Type**                      | **Main Pain**                                              | **Must-have Features**                                                      |
|--------------------------------|----------------------------------------|------------------------------------------------------------|-----------------------------------------------------------------------------|
| Small shop owner               | Grocery, cosmetics, hardware, pharmacy | Forgets who owes money and cannot calculate daily profit   | Customer baki, daily sales, payment received, due report, backup            |
| Mobile seller/service provider | Local mobile repair, small electronics | Needs customer payment history and installment/due records | Customer ledger, receipt sharing, partial payment, due reminder             |
| Wholesaler                     | Supplies goods to many retailers       | Needs supplier/customer separation and statement export    | Supplier ledger, customer statement, PDF/Excel export, multi-contact search |
| Cashier/staff                  | Works inside shop                      | Needs fast entry without seeing all reports                | Role permission, add sale, collect payment, restricted delete               |
| Existing TaliKhata user        | Already has PDF/export history         | Wants to migrate without manually typing all data          | Import TaliKhata PDF/export, duplicate preview, opening balance creation    |

## 3.1 Primary Language and Tone

- App must support Bangla and English from MVP.

- Bangla wording should use familiar terms: পাবে, দেবে, বাকি, পেলাম, দিলাম, খরচ, বিক্রি, স্টক.

- Avoid accounting-heavy words in primary flows: debit, credit, receivable, payable should be secondary/help text only.

# 4. Product Goals, Non-goals and Success Metrics

## 4.1 Goals

- Allow a user to create account, setup business and add first customer transaction within 3 minutes.

- Allow existing TaliKhata users to import exported PDF data with preview and duplicate checking.

- Make all write actions offline-capable and automatically synced later.

- Restore full business data after re-login on a new or same device.

- Monetize with a simple BDT 30/month subscription without deleting or locking old data.

- Display daily sales in a bar chart/histogram on the home page.

## 4.2 Non-goals for MVP

- No formal banking/payment gateway settlement in MVP unless approved APIs are available.

- No loan/credit scoring feature in MVP.

- No tax/VAT filing automation in MVP.

- No complex ERP accounting such as journal vouchers, balance sheet or chart of accounts in MVP.

- No multi-branch inventory transfer in MVP unless core ledger is stable.

## 4.3 Success Metrics

| **Metric**             | **Target for MVP Launch**                                         | **Why it matters**                 |
|------------------------|-------------------------------------------------------------------|------------------------------------|
| Activation rate        | 60% of registered users create at least 1 business and 1 customer | Shows onboarding is understandable |
| First transaction time | Under 3 minutes from install                                      | Confirms fast entry                |
| Import success rate    | 80%+ for supported PDF exports                                    | Critical migration feature         |
| Sync reliability       | 99%+ local changes eventually reach server                        | Protects user trust                |
| Monthly conversion     | 10-15% active users subscribe at BDT 30/month                     | Tests monetization                 |
| Crash-free sessions    | 99%+                                                              | Required for business apps         |
| Data restore success   | 100% for synced users after re-login                              | Core promise                       |

# 5. MVP Scope and Future Scope

## 5.1 MVP v1 Locked Scope

| **Module**               | **Included in MVP**                                                        | **Notes**                                               |
|--------------------------|----------------------------------------------------------------------------|---------------------------------------------------------|
| Authentication           | Phone OTP, email/Gmail login, Google sign-in                               | Clarify Gmail: email/password or magic link             |
| Business setup           | Create and edit business profile                                           | Single business in MVP; multi-business later or premium |
| Customer/Supplier ledger | Add contacts, record gave/received/payable/receivable transactions         | Core app feature                                        |
| Sales entry              | Simple sale, paid amount, due amount, customer selection                   | Item-based invoice optional in v1.1                     |
| Expense entry            | Basic expense categories and daily/monthly totals                          | Needed for profit view                                  |
| Home dashboard           | Total pabo/debo, daily sales bar chart, quick actions, recent transactions | Must be simple and fast                                 |
| Export                   | PDF, CSV/Excel export for sales/customer/supplier report                   | PDF style compatible with sample expectations           |
| Import                   | TaliKhata-style PDF import with preview and duplicate handling             | High-priority differentiator                            |
| Subscription             | BDT 30/month, manual or semi-automatic bKash/Nagad/Rocket verification     | Write access blocked when expired                       |
| Offline sync             | Local database, sync queue, auto upload when internet returns              | Must never lose local data                              |
| Restore                  | After login, download business data from database                          | Same or new device                                      |
| Admin panel              | User, subscription, payment verification and support basics                | Required for business operation                         |

## 5.2 Post-MVP Scope

- Full inventory with low stock and expiry alerts.

- Bluetooth thermal printer support.

- Staff roles and permissions.

- Multi-business/multi-branch support.

- SMS reminder credits and WhatsApp message templates.

- AI assistant, OCR invoice scanning and smart insights.

- Payment API integration after legal/business approval.

# 6. User Experience Requirements

Ledgerly must feel fast, familiar and less cluttered. A shopkeeper should not need accounting knowledge. Each key action should be one or two taps from the home screen.

## 6.1 Navigation Structure

| **Tab / Area**    | **Purpose**                                         | **Key Actions**                                 |
|-------------------|-----------------------------------------------------|-------------------------------------------------|
| Home / Ledger     | Main summary and customer/supplier list             | Add sale, add payment, view due, export, filter |
| Cashbox           | Cash in/out, owner withdrawal, payment modes        | Add cash expense, daily close                   |
| Wallet / Payments | Subscription payment and optional payment records   | Pay BDT 30, add bKash/Nagad/Rocket trxID        |
| Reports           | Sales, due, expense, profit, stock reports          | Export PDF/CSV/Excel                            |
| Menu              | Business profile, backup, import, settings, support | Import TaliKhata PDF, language, security        |

## 6.2 Home Page Requirements

- Top app bar: business name selector, plan status, inbox/help icons.

- Quick action grid: Add Sale, Add Payment, Add Customer, Import, Export, Backup, Stock, Reports.

- Summary cards: Total পাবে, Total দেবে, Today Sales, Today Expense, Net Cash.

- Daily sales chart: bar chart/histogram for last 7 or 30 days, placed above or below summary cards.

- Search and filter: search by customer/supplier name or phone, filter by pabo/debo/overdue/highest amount.

- Customer/supplier list: initials/avatar, name, phone optional, last transaction, balance and arrow for details.

- Floating action button: quick add customer/transaction; blocked with payment prompt if subscription expired.

## 6.3 UX Rules

- All money fields must support Bangla and English numerals display preference, but store numeric values consistently.

- Every important write action should show immediate local success, even without internet.

- Use confirmation for delete, but allow undo within 5 seconds where possible.

- Export and import must show progress, success/failure summary and location of saved file.

- Paywall must never make user fear data loss; show read-only mode with clear reason and payment button.

# 7. Functional Requirements

Priority labels: P0 = required for MVP launch, P1 = important soon after launch, P2 = future/backlog.

## 7.1 Authentication and Account

| **ID**  | **Requirement**                                           | **Priority** | **Acceptance Criteria**                                                                |
|---------|-----------------------------------------------------------|--------------|----------------------------------------------------------------------------------------|
| AUTH-01 | User can sign up/login by phone number using OTP.         | P0           | Valid OTP creates/opens user account; invalid OTP shows clear error.                   |
| AUTH-02 | User can sign up/login with Gmail/email.                  | P0           | Email flow works as email-password or magic-link after final decision.                 |
| AUTH-03 | User can sign up/login with Google OAuth.                 | P0           | Google sign-in creates/opens account and links identity to same user if email matches. |
| AUTH-04 | User can logout and re-login from same or another device. | P0           | Synced business data restores after login.                                             |
| AUTH-05 | User can manage profile name, phone, email and language.  | P1           | Profile changes sync to cloud.                                                         |

## 7.2 Business Profile

| **ID** | **Requirement**                                                            | **Priority** | **Acceptance Criteria**                                           |
|--------|----------------------------------------------------------------------------|--------------|-------------------------------------------------------------------|
| BIZ-01 | User can create one business profile during onboarding.                    | P0           | Business name and owner phone are required.                       |
| BIZ-02 | User can edit business details: name, phone, address, logo, business type. | P0           | Updated fields appear in PDF exports.                             |
| BIZ-03 | Business selector exists on home page.                                     | P1           | Single business shown in MVP; multi-business ready in data model. |
| BIZ-04 | Business data is isolated per owner/member.                                | P0           | User cannot access another business without permission.           |

## 7.3 Contacts: Customers and Suppliers

| **ID**     | **Requirement**                                                         | **Priority** | **Acceptance Criteria**                                              |
|------------|-------------------------------------------------------------------------|--------------|----------------------------------------------------------------------|
| CONTACT-01 | User can add customer or supplier with name and phone.                  | P0           | Contact appears in list and can receive transactions.                |
| CONTACT-02 | User can mark a contact type as Customer, Supplier or Both.             | P0           | Balance and report direction are calculated correctly.               |
| CONTACT-03 | User can search contacts by name or phone.                              | P0           | Search results update instantly from local database.                 |
| CONTACT-04 | User can import contacts from phonebook with permission.                | P1           | Imported contacts can be reviewed before saving.                     |
| CONTACT-05 | User can archive a contact without deleting history.                    | P1           | Archived contacts are hidden by default but reports remain accurate. |
| CONTACT-06 | User can open contact detail with all transactions and current balance. | P0           | Balance equals sum of transactions/opening balance.                  |

## 7.4 Ledger Transactions: Gave, Received, Pabo, Debo

| **ID**    | **Requirement**                                                 | **Priority** | **Acceptance Criteria**                                               |
|-----------|-----------------------------------------------------------------|--------------|-----------------------------------------------------------------------|
| LEDGER-01 | User can record "দিলাম" / gave transaction for a contact.       | P0           | Receivable/payable direction updates correctly based on contact type. |
| LEDGER-02 | User can record "পেলাম" / received payment from a contact.      | P0           | Balance decreases or increases correctly based on direction.          |
| LEDGER-03 | User can record partial payment against an existing due amount. | P0           | Remaining balance is displayed immediately.                           |
| LEDGER-04 | User can add date, note and payment method to each transaction. | P0           | Transaction detail displays all entered data.                         |
| LEDGER-05 | User can edit/delete a transaction with audit trail.            | P1           | Edited/deleted record keeps timestamp and actor in audit log.         |
| LEDGER-06 | User can attach photo/receipt to a transaction.                 | P2           | Attachment uploads to storage when online.                            |

## 7.5 Sales

| **ID**  | **Requirement**                                                                     | **Priority** | **Acceptance Criteria**                                  |
|---------|-------------------------------------------------------------------------------------|--------------|----------------------------------------------------------|
| SALE-01 | User can add a simple sale by amount, customer/walk-in, paid amount and due amount. | P0           | Sale appears in daily sales and ledger if due exists.    |
| SALE-02 | User can select payment method: Cash, bKash, Nagad, Rocket, Bank, Other.            | P0           | Payment method appears in reports.                       |
| SALE-03 | User can record a fully paid sale.                                                  | P0           | Daily sales increases and no customer due is created.    |
| SALE-04 | User can record a due sale.                                                         | P0           | Daily sales increases and customer pabo balance updates. |
| SALE-05 | User can view sales list by date range.                                             | P0           | Today, week, month and custom date filters work.         |
| SALE-06 | User can create item-based sale/invoice with products, quantity and discount.       | P1           | Stock decreases if inventory is enabled.                 |
| SALE-07 | User can record sales return/refund.                                                | P1           | Sale and stock adjustments appear in reports.            |

## 7.6 Expenses and Cashbox

| **ID**  | **Requirement**                                                                                          | **Priority** | **Acceptance Criteria**                           |
|---------|----------------------------------------------------------------------------------------------------------|--------------|---------------------------------------------------|
| CASH-01 | User can add expense with amount, category, date and note.                                               | P0           | Expense appears in daily/monthly report.          |
| CASH-02 | User can see today cash summary: opening cash, sales received, payment received, expenses, closing cash. | P1           | Cashbox totals are mathematically consistent.     |
| CASH-03 | User can record owner withdrawal/deposit.                                                                | P1           | Cashbox updates but sales/profit remain separate. |
| CASH-04 | User can create recurring expense reminder for rent/salary/bill.                                         | P2           | Reminder notification triggers on selected date.  |

## 7.7 Inventory and Stock

| **ID**   | **Requirement**                                                     | **Priority** | **Acceptance Criteria**                         |
|----------|---------------------------------------------------------------------|--------------|-------------------------------------------------|
| STOCK-01 | User can create product with name, unit, buy price and sell price.  | P1           | Product appears in product list.                |
| STOCK-02 | User can update stock quantity manually or through purchases/sales. | P1           | Stock movement history is stored.               |
| STOCK-03 | User can receive low-stock alert.                                   | P1           | Alert appears when stock falls below threshold. |
| STOCK-04 | User can add expiry date for product batch.                         | P2           | Expiry warning appears before selected days.    |
| STOCK-05 | User can scan barcode.                                              | P2           | Barcode maps to product if saved.               |

## 7.8 Export and Reports

| **ID**    | **Requirement**                                                                 | **Priority** | **Acceptance Criteria**                                                                                     |
|-----------|---------------------------------------------------------------------------------|--------------|-------------------------------------------------------------------------------------------------------------|
| EXPORT-01 | User can export customer/supplier ledger report as PDF.                         | P0           | PDF includes business header, generated date, transaction count, pabo/debo columns, totals and page number. |
| EXPORT-02 | User can export sales report as PDF.                                            | P0           | PDF includes date range, sale rows, payment status and total sales.                                         |
| EXPORT-03 | User can export reports as CSV/Excel.                                           | P0           | File opens in spreadsheet software with correct columns.                                                    |
| EXPORT-04 | User can share exported report to WhatsApp/Messenger/email or download locally. | P0           | Android share sheet opens with generated file.                                                              |
| EXPORT-05 | User can choose Bangla or English report language.                              | P1           | Labels and date formatting change accordingly.                                                              |
| EXPORT-06 | User can export all business data as backup archive.                            | P1           | Archive can be restored/imported later.                                                                     |

## 7.9 Import

| **ID**    | **Requirement**                                                              | **Priority** | **Acceptance Criteria**                                                                              |
|-----------|------------------------------------------------------------------------------|--------------|------------------------------------------------------------------------------------------------------|
| IMPORT-01 | User can import TaliKhata-style PDF exports.                                 | P0           | App extracts shop info, contacts, phone numbers, pabo/debo values and last activity where available. |
| IMPORT-02 | Import screen shows preview before saving.                                   | P0           | User can review rows, fix errors and unselect unwanted rows.                                         |
| IMPORT-03 | Importer detects duplicate contacts by phone number.                         | P0           | User can merge with existing contact or create new contact.                                          |
| IMPORT-04 | Importer creates opening balance transactions for imported pabo/debo totals. | P0           | Balances after import match PDF totals.                                                              |
| IMPORT-05 | Importer stores import job history.                                          | P0           | User can see source file name, date, imported rows, skipped rows and errors.                         |
| IMPORT-06 | Importer supports CSV/Excel template import.                                 | P1           | User can import contacts and opening balances from spreadsheet.                                      |
| IMPORT-07 | Importer supports rollback immediately after import.                         | P1           | User can undo import batch before new edits depend on it.                                            |

## 7.10 Subscription and Write Access

| **ID** | **Requirement**                                                                               | **Priority** | **Acceptance Criteria**                                                   |
|--------|-----------------------------------------------------------------------------------------------|--------------|---------------------------------------------------------------------------|
| SUB-01 | Subscription price is BDT 30 per month.                                                       | P0           | Active subscription expiry date is stored per business/user as finalized. |
| SUB-02 | User can pay by bKash, Nagad or Rocket.                                                       | P0           | Payment method, sender number and transaction ID can be submitted.        |
| SUB-03 | If subscription expires, user cannot add new data.                                            | P0           | Write actions show payment prompt instead of saving.                      |
| SUB-04 | Expired user can still login, view data, export reports, backup/restore and pay subscription. | P0           | Data is never hidden or deleted due to expiry.                            |
| SUB-05 | Admin can verify manual payment and activate subscription.                                    | P0           | Activation changes status to active and sets next expiry date.            |
| SUB-06 | App shows subscription status and days remaining on home/menu.                                | P0           | User sees clear plan status.                                              |

## 7.11 Offline Sync and Restore

| **ID**  | **Requirement**                                                                | **Priority** | **Acceptance Criteria**                                             |
|---------|--------------------------------------------------------------------------------|--------------|---------------------------------------------------------------------|
| SYNC-01 | Every write action saves locally first.                                        | P0           | User can continue working without internet.                         |
| SYNC-02 | When internet is available, unsynced changes upload automatically to Supabase. | P0           | Sync queue becomes empty after successful upload.                   |
| SYNC-03 | App shows sync status: Synced, Syncing, Offline, Failed.                       | P0           | User understands data safety state.                                 |
| SYNC-04 | On login from a new device, app restores cloud data to local database.         | P0           | Contacts, transactions, reports and settings appear as before.      |
| SYNC-05 | Conflict handling must avoid duplicate transactions.                           | P0           | Unique operation IDs prevent same transaction from uploading twice. |
| SYNC-06 | Deleted records use soft delete.                                               | P0           | Delete syncs safely and can be audited.                             |
| SYNC-07 | Sync retry uses exponential backoff.                                           | P1           | Server/network failures do not drain battery or spam requests.      |

## 7.12 Notifications and Messages

| **ID** | **Requirement**                                    | **Priority** | **Acceptance Criteria**                                       |
|--------|----------------------------------------------------|--------------|---------------------------------------------------------------|
| MSG-01 | User can share due reminder message to customer.   | P1           | Message includes customer name, due amount and business name. |
| MSG-02 | User can receive daily sales summary notification. | P1           | Notification shows sales, received, due and expense summary.  |
| MSG-03 | User can receive subscription expiry warning.      | P0           | Warning appears before expiry and after expiry.               |
| MSG-04 | User can use custom message templates.             | P2           | Templates can be edited and reused.                           |

# 8. TaliKhata PDF Export and Import Compatibility

This section is critical because Ledgerly will use migration as a differentiator. The app must import existing TaliKhata-style PDF exports and must also export clean reports from Ledgerly.

## 8.1 Supported Import Sources

| **Source Type**                              | **MVP Support** | **Implementation Notes**                                                 |
|----------------------------------------------|-----------------|--------------------------------------------------------------------------|
| TaliKhata-style PDF customer/supplier report | Yes - P0        | Use PDF text extraction first; fallback OCR later if scanned/image-only. |
| Ledgerly PDF export                          | Yes - P1        | Should be re-importable for backup recovery.                             |
| CSV/Excel contacts and balances              | Yes - P1        | Offer downloadable template.                                             |
| Image screenshot import                      | Future - P2     | AI/OCR feature, not MVP.                                                 |

## 8.2 Import Mapping Rules

| **Source Text Pattern**          | **Meaning**                       | **Ledgerly Action**                                                  |
|----------------------------------|-----------------------------------|----------------------------------------------------------------------|
| Name - phone                     | Contact identity                  | Create/update contact.                                               |
| (সাপ্লায়ার) / Supplier            | Supplier type                     | Set contact.type = supplier.                                         |
| শেষ / সর্বশেষ date - দিলাম amount | Last gave/on-credit transaction   | Create opening balance or imported transaction based on chosen mode. |
| শেষ / সর্বশেষ date - পেলাম amount | Last received/payment transaction | Create imported payment/opening balance.                             |
| Pabo column amount               | User will receive money           | Set opening receivable.                                              |
| Debo column amount               | User has to pay money             | Set opening payable.                                                 |
| Totals row                       | Report validation                 | Imported totals must match source totals before final save.          |

## 8.3 Import Flow

1\. User opens Menu \> Import Data \> TaliKhata PDF.

2\. User selects PDF file from phone storage.

3\. App extracts text and detects report type.

4\. App shows a preview table: name, phone, type, pabo, debo, last activity, status.

5\. App highlights errors: missing phone, unreadable amount, duplicate phone, unsupported row.

6\. User chooses import mode: create opening balance only, or create imported last transaction where available.

7\. User confirms import.

8\. App saves rows locally, adds import_job record and queues cloud sync.

9\. App shows import summary: imported, merged, skipped, failed, total pabo, total debo.

## 8.4 Export PDF Layout Requirements

| **PDF Area** | **Required Content**                                        | **Notes**                                                |
|--------------|-------------------------------------------------------------|----------------------------------------------------------|
| Header       | Business name, phone, optional logo, Ledgerly branding      | Must not use TaliKhata branding.                         |
| Metadata     | Report created date/time, date range, transaction count     | Bangla and English language support.                     |
| Table        | Customer/supplier name, phone, last transaction, Pabo, Debo | Use red/green amount styling like familiar mental model. |
| Totals       | Total pabo and total debo                                   | Must match database calculations.                        |
| Footer       | Page no. X of Y, generated by Ledgerly                      | Useful for long reports.                                 |

## 8.5 Import Accuracy Rules

- Never silently import uncertain rows. Any row below confidence threshold must be marked "Needs review".

- Use phone number as strongest duplicate key; use normalized Bangladeshi phone formats.

- If both pabo and debo exist for same contact, show warning and ask user to choose/confirm.

- All imported values should be saved with source_import_id for traceability.

- Import should be idempotent: importing the same file twice should not duplicate balances without warning.

# 9. Subscription, Payment and Paywall Rules

Ledgerly will charge BDT 30 per month. The subscription should control write access, but never destroy user trust by hiding or deleting data. Expired users should be able to view old data, export, backup and pay again.

## 9.1 Subscription States

| **State**       | **Condition**                                       | **Allowed**                                                    | **Blocked**                                                                                    |
|-----------------|-----------------------------------------------------|----------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| Trial / New     | Optional first-use period if enabled                | All MVP actions                                                | None until trial ends                                                                          |
| Active          | Paid and not expired                                | All subscribed features                                        | None                                                                                           |
| Expiring soon   | 3 days before expiry                                | All features + warning                                         | None                                                                                           |
| Expired         | Expiry date passed                                  | Login, view, search, export, backup, restore, pay subscription | Add/edit sale, add payment, add customer/supplier, add expense, import new data, stock changes |
| Payment pending | User submitted trxID waiting admin/API verification | Read + maybe temporary write if policy allows                  | Final decision required                                                                        |
| Suspended/Fraud | Admin blocked account                               | View/export/pay support only                                   | All write actions                                                                              |

## 9.2 Payment Flow

1\. User taps Pay Subscription from home/menu/paywall screen.

2\. App shows price: BDT 30/month and accepted methods: bKash, Nagad, Rocket.

3\. User selects method and sees merchant/personal payment instruction or payment integration screen.

4\. User enters sender number and transaction ID if manual verification is used.

5\. App creates subscription_payment record with status pending.

6\. Admin verifies payment or automated webhook confirms payment.

7\. App activates subscription for one month and syncs status to user devices.

## 9.3 Paywall Copy

| **Situation**            | **Suggested Message**                                                                                  |
|--------------------------|--------------------------------------------------------------------------------------------------------|
| Expired when adding sale | আপনার সাবস্ক্রিপশন শেষ হয়েছে। নতুন হিসাব যোগ করতে ৩০ টাকা দিয়ে ১ মাস চালু করুন। আপনার পুরনো ডাটা নিরাপদ আছে। |
| Expired on home          | Read-only mode: সাবস্ক্রিপশন রিনিউ করলে আবার নতুন ডাটা যোগ করতে পারবেন।                                   |
| Payment pending          | আপনার পেমেন্ট যাচাই হচ্ছে। যাচাই শেষ হলে সাবস্ক্রিপশন চালু হবে।                                             |
| Payment success          | সাবস্ক্রিপশন চালু হয়েছে। আপনি এখন নতুন ডাটা যোগ করতে পারবেন।                                               |

# 10. Offline-first Sync and Restore Requirements

Offline-first is mandatory. Shop owners may add sales while internet is weak. Ledgerly must save first locally, then sync reliably with Supabase once internet returns.

## 10.1 Recommended Client Architecture

| **Layer**            | **Recommended Tool**                                        | **Responsibility**                                                      |
|----------------------|-------------------------------------------------------------|-------------------------------------------------------------------------|
| UI                   | Flutter                                                     | Screens, forms, charts, navigation                                      |
| State management     | Riverpod or Bloc                                            | App state, auth state, subscription state, sync state                   |
| Local database       | Drift/SQLite preferred                                      | Offline storage for contacts, transactions, sales, expenses, sync queue |
| Secure storage       | flutter_secure_storage                                      | Tokens, device keys, basic secrets                                      |
| Connectivity monitor | connectivity_plus                                           | Detect online/offline and trigger sync                                  |
| Cloud backend        | Supabase                                                    | Auth, Postgres, Storage, Edge Functions, RLS                            |
| PDF generation       | pdf + printing package                                      | Ledgerly reports and invoice export                                     |
| PDF import           | Dart/Python service/Edge Function depending library quality | Extract text and parse TaliKhata-style files                            |

## 10.2 Sync Process

1\. User creates/updates data in Flutter app.

2\. App writes to local database immediately with sync_status = pending and a unique operation_id.

3\. Sync engine checks subscription state for write permissions before accepting new write actions.

4\. When internet is available, app uploads pending operations to Supabase in order.

5\. Server validates ownership, subscription write access and data shape.

6\. Server stores data and returns updated_at/server_version.

7\. Client marks operation as synced and updates local server metadata.

8\. On login/reinstall/new device, client downloads latest business snapshot and changes since last sync.

## 10.3 Conflict Strategy

| **Data Type**       | **Strategy**                                        | **Reason**                             |
|---------------------|-----------------------------------------------------|----------------------------------------|
| Ledger transactions | Immutable event + correction transaction preferred  | Avoid losing accounting history.       |
| Contact profile     | Last write wins with updated_at and device_id audit | Low risk; user can edit again.         |
| Business profile    | Last write wins, owner only                         | Rare conflict.                         |
| Subscription status | Server is source of truth                           | Payment must not be client-controlled. |
| Import jobs         | Idempotent by file hash and job ID                  | Prevent duplicate imports.             |
| Deletes             | Soft delete with deleted_at                         | Allows sync and audit.                 |

## 10.4 Restore Requirements

- After login on a new device, app must show a restore progress screen if cloud data exists.

- Restore must download businesses, contacts, transactions, sales, expenses, products, settings and subscription status.

- Partial restore failures must show retry option and must not corrupt local data.

- User should be able to manually trigger Sync Now / Restore from Settings.

# 11. Supabase Architecture and Suggested Database Schema

Supabase is a good fit for the first version because it provides Postgres, authentication, row-level security, storage and serverless Edge Functions. The database should be designed for multi-business support even if MVP exposes only one business.

## 11.1 High-level Architecture

| **Component**           | **Responsibility**                                                                       |
|-------------------------|------------------------------------------------------------------------------------------|
| Flutter App             | UI, local database, offline writes, reports, import preview, sync queue                  |
| Local SQLite/Drift DB   | Offline source for user experience and pending operation queue                           |
| Supabase Auth           | Phone OTP, email/Gmail login, Google OAuth identity                                      |
| Supabase Postgres       | Main cloud database with RLS                                                             |
| Supabase Storage        | Report PDFs, receipt images, import source files if needed                               |
| Supabase Edge Functions | Payment verification, import parsing fallback, subscription activation, admin operations |
| Admin Web Panel         | Support, payment verification, user/business management                                  |

## 11.2 Suggested Tables

| **Table**             | **Purpose**                          | **Important Fields**                                                                               |
|-----------------------|--------------------------------------|----------------------------------------------------------------------------------------------------|
| profiles              | User profile linked to Supabase auth | id, name, phone, email, language, created_at                                                       |
| businesses            | Shop/business profile                | id, owner_id, name, phone, address, logo_url, business_type, created_at, updated_at                |
| business_members      | Future staff/multi-user permissions  | id, business_id, user_id, role, status                                                             |
| contacts              | Customers/suppliers                  | id, business_id, name, phone, type, address, notes, archived_at                                    |
| ledger_transactions   | Core pabo/debo events                | id, business_id, contact_id, direction, amount, date, note, payment_method, source, import_job_id  |
| sales                 | Sale header                          | id, business_id, contact_id, total_amount, paid_amount, due_amount, date, status, payment_method   |
| sale_items            | Item rows for item-based sale        | id, sale_id, product_id, quantity, unit_price, discount                                            |
| expenses              | Business expenses                    | id, business_id, category, amount, date, note, payment_method                                      |
| products              | Inventory product master             | id, business_id, name, sku, barcode, unit, buy_price, sell_price, low_stock_threshold              |
| inventory_movements   | Stock in/out/adjustment              | id, business_id, product_id, movement_type, quantity, source_id, date                              |
| import_jobs           | Data import records                  | id, business_id, source_type, file_name, file_hash, status, row_count, imported_count, error_count |
| import_rows           | Parsed row details                   | id, import_job_id, raw_text, parsed_json, status, contact_id, transaction_id                       |
| subscriptions         | Subscription status                  | id, business_id/user_id, plan, status, starts_at, expires_at                                       |
| subscription_payments | Payment submissions                  | id, subscription_id, method, amount, sender_number, trx_id, status, verified_by                    |
| sync_operations       | Optional server-side operation audit | id, business_id, operation_id, entity, entity_id, action, device_id, created_at                    |
| audit_logs            | Important changes                    | id, business_id, user_id, action, entity, entity_id, before_json, after_json                       |

## 11.3 Core Enums

| **Enum**            | **Values**                                                          |
|---------------------|---------------------------------------------------------------------|
| contact_type        | customer, supplier, both                                            |
| ledger_direction    | gave, received, opening_receivable, opening_payable, adjustment     |
| payment_method      | cash, bkash, nagad, rocket, bank, card, cheque, other               |
| subscription_status | trial, active, expiring, expired, pending, suspended                |
| sync_status         | pending, syncing, synced, failed, conflict                          |
| import_status       | draft, parsed, needs_review, imported, partial, failed, rolled_back |

## 11.4 Row-Level Security Rules

- Users can read/write businesses where they are owner or active member.

- Client cannot directly set subscription active status; only Edge Function/admin service role can verify payment.

- Expired users should fail write validation for new business data on server, even if client is modified.

- Admin panel must use separate admin role and protected operations.

- Storage paths must include business_id and enforce access through RLS/policies.

# 12. Security, Privacy and Permissions

| **Area**                 | **Requirement**                                                        |
|--------------------------|------------------------------------------------------------------------|
| Authentication           | Use Supabase Auth; do not store raw OTP/password in app database.      |
| Data isolation           | Enable RLS on every business table.                                    |
| Transport security       | All API calls over HTTPS.                                              |
| Local data               | Local DB should not expose sensitive tokens; tokens in secure storage. |
| Subscription enforcement | Enforce on both client and server.                                     |
| Backups                  | User data restored only after authenticated login.                     |
| Contact permission       | Ask permission only if importing phone contacts; explain why.          |
| Deletion                 | Support account/business deletion request in settings/admin.           |
| Audit                    | Track important edits/deletes/imports/payment verification.            |

# 13. Admin Panel Requirements

| **ID**   | **Requirement**                                          | **Priority** | **Acceptance Criteria**                                                     |
|----------|----------------------------------------------------------|--------------|-----------------------------------------------------------------------------|
| ADMIN-01 | Admin can view registered users and businesses.          | P0           | Search by phone/email/business name.                                        |
| ADMIN-02 | Admin can verify bKash/Nagad/Rocket payment submissions. | P0           | Payment changes from pending to verified/rejected and subscription updates. |
| ADMIN-03 | Admin can activate subscription manually.                | P0           | Expiry date updates and syncs to app.                                       |
| ADMIN-04 | Admin can see import errors and support tickets.         | P1           | Helps fix user migration problems.                                          |
| ADMIN-05 | Admin can send announcement/push notice.                 | P2           | Useful for maintenance or offers.                                           |
| ADMIN-06 | Admin can view app health metrics.                       | P1           | Active users, failed syncs, crashes, payment pending count.                 |

# 14. Analytics and Charts

Home must include a bar chart/histogram style sales visualization. It should be simple: last 7 days by default, switchable to last 30 days.

| **ID**   | **Requirement**                                   | **Priority** | **Acceptance Criteria**                         |
|----------|---------------------------------------------------|--------------|-------------------------------------------------|
| CHART-01 | Home shows daily sales bar chart for last 7 days. | P0           | Each bar represents total sales amount by date. |
| CHART-02 | User can switch chart period to 30 days.          | P1           | Chart reloads from local database.              |
| CHART-03 | Chart supports empty state.                       | P0           | Shows friendly message when no sales exist.     |
| CHART-04 | Tapping a bar opens daily sales report.           | P1           | Selected date report filters correctly.         |
| CHART-05 | Chart calculation works offline.                  | P0           | Uses local sales table.                         |

## 14.1 Business Reports

| **Report**       | **MVP** | **Description**                                                 |
|------------------|---------|-----------------------------------------------------------------|
| Daily Sales      | Yes     | Sales total, paid amount, due amount, payment method breakdown. |
| Customer Due     | Yes     | Customers who owe money and due amounts.                        |
| Supplier Payable | Yes     | Suppliers to whom business owes money.                          |
| Expense          | Yes     | Expense by category and date.                                   |
| Cashbox          | P1      | Cash received, cash spent, closing cash.                        |
| Profit/Loss      | P1      | Sales - cost - expense once inventory/purchase is stable.       |
| Stock            | P1      | Product quantity and stock value.                               |

# 15. Testing and QA Plan

| **Test Area**  | **Must Test**                                                                                          |
|----------------|--------------------------------------------------------------------------------------------------------|
| Authentication | Phone OTP, email/Gmail login, Google OAuth, logout/re-login, account linking.                          |
| Subscription   | Active, expired, pending, admin verify, blocked write actions, allowed read/export.                    |
| Offline sync   | Create sale offline, reconnect, verify cloud upload, reinstall and restore.                            |
| Import         | Supported PDF import, duplicate PDF import, unreadable PDF, duplicate contact merge, total validation. |
| Export         | PDF layout, Bangla text rendering, totals, long report pagination, share/download.                     |
| Ledger math    | Gave/received, pabo/debo, partial payment, opening balance, delete/edit audit.                         |
| Charts         | Daily sales calculation, empty state, date filtering, local data only.                                 |
| Security       | RLS: user cannot access another business; expired user cannot bypass write rules.                      |
| Performance    | Home loads under 1.5 seconds with 5,000 contacts and 50,000 transactions locally.                      |

## 15.1 Acceptance Criteria for MVP Launch

- A user can create account, create business, add customer, add sale, add payment and see updated balance.

- A user can export a PDF report and share it from Android.

- A user can import the provided TaliKhata-style PDF sample and get matching totals in preview.

- A user can add data offline and see it sync automatically after internet returns.

- A user can reinstall/re-login and restore synced data.

- Expired subscription blocks new data creation but does not block login, view or export.

- Daily sales chart is visible on the home page and calculates correctly.

# 16. Release Roadmap

| **Phase**                | **Duration** | **Deliverables**                                                                     |
|--------------------------|--------------|--------------------------------------------------------------------------------------|
| Phase 0 - Planning       | 3-5 days     | Finalize PRD, UI flow, database schema, subscription policy and import sample rules. |
| Phase 1 - Foundation     | 1 week       | Flutter project, theme, navigation, Supabase auth, local DB, business setup.         |
| Phase 2 - Core Ledger    | 1-2 weeks    | Contacts, ledger transactions, sales, expenses, home dashboard.                      |
| Phase 3 - Sync + Restore | 1 week       | Offline queue, upload/download, conflict handling, sync status.                      |
| Phase 4 - Export/Import  | 1-2 weeks    | PDF/CSV export, TaliKhata-style PDF parser, preview, validation, import job history. |
| Phase 5 - Subscription   | 1 week       | BDT 30 plan, bKash/Nagad/Rocket payment submission, admin verification, paywall.     |
| Phase 6 - QA + Beta      | 1 week       | Testing, bug fixes, beta with real shopkeepers.                                      |
| Phase 7 - v1 Launch      | Release      | Android APK/Play Store, support channel, tutorial videos.                            |

## 16.1 Suggested MVP Tech Packages

| **Need**                      | **Flutter Package / Tool**                           |
|-------------------------------|------------------------------------------------------|
| State management              | flutter_riverpod or bloc                             |
| Local database                | drift + sqlite3_flutter_libs                         |
| Supabase                      | supabase_flutter                                     |
| Secure storage                | flutter_secure_storage                               |
| Connectivity                  | connectivity_plus                                    |
| Charts                        | fl_chart                                             |
| PDF export                    | pdf, printing, path_provider, share_plus             |
| File picker                   | file_picker                                          |
| CSV/Excel import/export       | csv, excel                                           |
| Bangla date/number formatting | intl + custom numeral formatter                      |
| Admin panel                   | Flutter web or Next.js/Supabase dashboard custom app |

# 17. Open Questions and Assumptions

These items should be confirmed before development starts. The PRD makes practical assumptions so work can begin, but final decisions should be locked in the next meeting.

| **Question**                                                             | **Recommended Decision**                                                                                    |
|--------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| What exactly means "Gmail login" separate from Google login?             | Treat Gmail as email/password or email magic link; treat Google as OAuth sign-in.                           |
| Will subscription be per user or per business?                           | Use per business for future multi-business, but MVP can map one user to one business.                       |
| Will expired users be allowed to edit/delete old records?                | Recommended: block all business data write actions, allow profile/settings/payment/export.                  |
| Will payment be automated or manual first?                               | Start manual trxID verification in admin panel; add official API/webhook later.                             |
| Should import create detailed old transactions or only opening balances? | MVP: opening balances from PDF totals; detailed old transactions only if source file contains them clearly. |
| Is inventory required in MVP?                                            | Keep basic data model ready; release inventory as v1.1/P1 unless you need it from day one.                  |
| Will app launch only Android or also iOS/Web?                            | Android first; Flutter keeps future iOS/Web possible.                                                       |

# Appendix A: UI Reference Notes

The screenshot below is a reference for user expectations only. Ledgerly should create its own visual identity, but preserve familiar concepts such as business selector, quick action modules, total pabo/debo, search/filter/export and bottom navigation.

![TaliKhata-style home page reference](assets/talikhata_homepage_reference.jpeg)

Reference screenshot provided by user: TaliKhata-style home page. Use only for requirement understanding, not for direct copying.

# Appendix B: Future AI Features

| **AI Feature**             | **Value**                                                                 | **Priority** |
|----------------------------|---------------------------------------------------------------------------|--------------|
| AI import assistant        | Detect messy PDF rows and suggest corrected contact/amount fields         | P2           |
| Voice-to-entry             | User says: "রহিমকে ৫০০ টাকা বাকি দিলাম" and app creates draft transaction | P2           |
| OCR bill scan              | Scan supplier bill and create purchase draft                              | P2           |
| Smart business summary     | Explain sales/due/profit changes in simple Bangla                         | P2           |
| Due risk suggestion        | Identify customers with long unpaid baki                                  | P2           |
| Product reorder suggestion | Suggest stock purchase from sales trend                                   | P2           |

# Appendix C: Development Backlog After PRD Approval

- Create wireframes for 8 key screens: onboarding, home, add transaction, contact detail, sales report, import preview, subscription payment, admin payment verification.

- Finalize Supabase schema and RLS policies.

- Build Flutter theme and reusable components.

- Create PDF import parser prototype using the uploaded sample PDF.

- Build local database schema and sync queue.

- Prepare test data based on Yeasir Traders sample records.
