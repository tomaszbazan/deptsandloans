# **Product Requirements Document (PRD) \- Depts and Loans Register (MVP)**

## **1\. Project Overview**

This document specifies the requirements for the Minimum Viable Product (MVP) of the "Depts and
Loans Register" mobile application. The project's goal is to deliver a unilateral, personal tool
that helps users manage their private financial transactions (debts and loans), providing timely
reminders and accurate repayment tracking.

* Project Title: Depts and Loans Register (MVP)
* Version: 1.0 (MVP)
* Target MVP Platform: Android (Flutter)
* Interaction Model: Unilateral, personal register
* Data Storage: Local database (Local First)

## **2\. User Problem**

The user problem can be divided into two main perspectives:

1. Lenders (Creditors): Often forget about the due date for the return of loaned funds, resulting in
   repayment delays and potential misunderstandings.
2. Borrowers (Debtors): Tend to forget to repay their obligations on time, leading to breached
   agreements and loss of trust.

The application aims to solve this problem by offering a proactive reminder system and a clear
register of all transactions.

## **3\. Functional Requirements**

### **3.1. Transaction Management**

| ID     | Requirement          | Description                                                                                                                                      |
|:-------|:---------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------|
| FR-001 | Adding Transactions  | The user must be able to add a new transaction (Debt or Loan) via a form, defining all required fields.                                          |
| FR-002 | Required Fields      | The "Name" and "Amount" fields are mandatory. The "Name" field must have a non-empty validation.                                                 |
| FR-003 | Optional Fields      | The "Description" field (max 200 characters) and "Due Date" are optional.                                                                        |
| FR-004 | Editing and Deleting | The user must be able to edit the details of an existing transaction (except the initial Amount, which is modified via Repayments) or delete it. |

### **3.2. Repayments and Transaction Status**

| ID     | Requirement            | Description                                                                                                                                                          |
|:-------|:-----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| FR-005 | Partial Repayment      | The user must be able to record partial repayments of a debt or loan.                                                                                                |
| FR-006 | Repayment Validation   | The system must prevent entering a repayment amount that exceeds the remaining transaction balance.                                                                  |
| FR-007 | Balance Visualization  | The current balance and repayment progress (e.g., progress bar) must be visually presented on the transaction details screen.                                        |
| FR-008 | Transaction Completion | A transaction must be automatically marked as complete upon reaching 100% repayment. The user must also have the option to manually mark it as complete at any time. |

### **3.3. Reminders**

| ID     | Requirement            | Description                                                                                                    |
|:-------|:-----------------------|:---------------------------------------------------------------------------------------------------------------|
| FR-009 | Reminder Types         | The user must be able to set a reminder as one-time or recurring ("remind me every X days").                   |
| FR-010 | Schedule               | All Push notifications must be sent at a fixed time of 19:00 (7:00 PM).                                        |
| FR-011 | Automatic Cancellation | Push notifications must be automatically cancelled when the associated transaction reaches 100% repaid status. |
| FR-012 | Notification Recipient | The system must generate Push notifications for the user (not for the other party of the transaction).         |

### **3.4. Interface and Visuals**

| ID     | Requirement       | Description                                                                                                                                                  |
|:-------|:------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| FR-013 | View Structure    | The main view must be divided into two separate tabs: "My Debts" and "My Loans".                                                                             |
| FR-014 | Sorting           | The list of active transactions must be sorted by default by the Due Date (ascending). Transactions without a Due Date are placed at the bottom of the list. |
| FR-015 | Archive           | Completed transactions must be presented in an "Archive" section as a collapsible accordion, located below the list of active transactions.                  |
| FR-016 | Overdue Highlight | Transactions for which the Due Date has passed must be visually highlighted (e.g., in red).                                                                  |
| FR-017 | Dark Mode         | The application must support Dark Mode according to the device's system settings.                                                                            |

### **3.5. Technical and Language Requirements**

| ID     | Requirement          | Description                                                                                                                                        |
|:-------|:---------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------|
| FR-018 | Localization         | The application must support Polish (PL) and English (EN). The language is automatically set based on the device's Locale (defaulting to English). |
| FR-019 | Currency Formatting  | The display of amounts and currencies must be adapted to the phone's regional settings (Locale) (e.g., separators, currency symbol).               |
| FR-020 | Supported Currencies | The application must support a predefined set of currencies: PLN, EUR, USD, GBP.                                                                   |

## **4\. Product Boundaries**

Boundaries define what is included in the MVP and what is moved to subsequent iterations.

| Category       | In Scope                                                                                                        | Out of Scope                                                                 |
|:---------------|:----------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------|
| Authentication | Local data saving (Local First). User identification based on an anonymous token (if required by the platform). | Registration, login, user accounts, cloud data synchronization.              |
| Interactions   | Unilateral register: Only the app user manages their transactions.                                              | Functionality for sharing debts, inviting other users, automatic settlement. |
| Platforms      | Native mobile application (Flutter) on the Android platform.                                                    | Native mobile application on the iOS platform.                               |
| Reminders      | Push notifications to the user at a fixed time of 19:00.                                                        | Notifications to the debtor/lender. Option to change the notification time.  |
| Validation     | Field validation: Name (non-empty), Description (max 200 characters).                                           | Validation of the "Name" field for minimum/maximum length.                   |

## **5\. User Stories**

All user stories and associated Acceptance Criteria (AC) for the MVP functionality.

| ID     | Title                            | Description                                                                                                                                             | Acceptance Criteria                                                                                                                                                                                                                                                                                                                  |
|:-------|:---------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| US-001 | Adding a new debt                | As a User, I want to quickly add a new debt, so I can track it and receive reminders.                                                                   | AC1: The user sees the "My Debts" tab as the default upon app launch. AC2: Clicking the FAB (Floating Action Button) opens the transaction addition form. AC3: The required "Name" and "Amount" fields (with currency) are filled. AC4: After clicking "Save", the new debt appears on the "My Debts" list as an active transaction. |
| US-002 | Adding a loan with currency      | As a User, I want to add a loan in a non-default currency, so I can accurately track its value.                                                         | AC1: The user can select one of the currencies: PLN, EUR, USD, GBP. AC2: After selecting the currency, the amount is displayed in the Locale format for that currency (e.g., $100.00 in US Locale). AC3: After saving, the transaction is visible on the "My Loans" list with correct currency formatting.                           |
| US-003 | Recording a partial repayment    | As a User, I want to record a partial repayment, so I can see the current, reduced transaction balance.                                                 | AC1: The user opens the details of an active transaction and finds the "Record Repayment" option. AC2: Entering a repayment amount updates the Remaining Balance and the progress bar. AC3: The system prevents entering a repayment amount that exceeds the remaining balance (per FR-006).                                         |
| US-004 | Automatic transaction completion | As a User, I want the transaction to be automatically moved to the Archive upon reaching full repayment.                                                | AC1: After entering a repayment that zeroes out the Remaining Balance, the transaction automatically receives the "Completed" status. AC2: The transaction disappears from the main active list and is available in the collapsible "Archive" Accordion. AC3: The system automatically cancels all associated Push Notifications.    |
| US-005 | Setting a recurring reminder     | As a User, I want to set a "remind me every X days" reminder for a debt, so I receive systematic notifications at 19:00 until the debt is fully repaid. | AC1: An option "Remind me every X days" is available in the editing/addition form. AC2: Setting the cycle (e.g., every 7 days) activates Push notification generation at 19:00. AC3: Notifications are generated only as long as the transaction is in "Active" status.                                                              |
| US-006 | Priority list sorting            | As a User, I want the list of active transactions to be sorted by Due Date, so I know which ones are most urgent.                                       | AC1: The "My Debts" list (and "Loans") is sorted ascendingly by Due Date. AC2: Transactions for which no Due Date was set (optional field) are consistently placed at the very bottom of the list.                                                                                                                                   |
| US-007 | Visual overdue highlight         | As a User, I want overdue payments to be visually marked, so I can immediately identify them.                                                           | AC1: If the Due Date has passed and the Remaining Balance is \> 0, the list item is highlighted in red. AC2: The highlighting applies to both the Debts and Loans lists.                                                                                                                                                             |
| US-008 | Archive management               | As a User, I want access to completed transactions, but I don't want them cluttering my view, so they are in a collapsible Accordion.                   | AC1: Completed transactions are located in the "Archive" section at the bottom of the active list. AC2: The "Archive" section is collapsed by default. AC3: Clicking the "Archive" header expands/collapses the list of completed transactions.                                                                                      |
| US-009 | Description limitation           | As a User, I want to be able to add a brief description, but I don't want to overload the database with long notes.                                     | AC1: The "Description" field in the form has a limit of 200 characters. AC2: When displaying the transaction on the main list, a maximum of the first 30 characters of the description is shown, and the rest is truncated (e.g., with "...")                                                                                        |
| US-010 | First launch and local data      | As a User, I want the app to work immediately upon download, using local data storage.                                                                  | AC1: The app loads without requiring registration or login. AC2: Upon first launch, the user is immediately on the main screen with empty lists. AC3: The app successfully saves and reads data locally after an app restart, confirming storage persistence.                                                                        |

## **6\. Success Metrics**

Success criteria (KPIs) will be measured to evaluate the value delivered by the MVP and its
usefulness to users.

### **6.1. Activity Metrics**

| Metric                                | Target                             | Rationale                                                                                         |
|:--------------------------------------|:-----------------------------------|:--------------------------------------------------------------------------------------------------|
| DAU/MAU (Daily/Monthly Active Users)  | Maintain a DAU/MAU ratio of \> 15% | Indicates regular, habitual use of the application.                                               |
| D7 Retention (Retention after 7 days) | \> 35%                             | A key indicator confirming the value of the reminder functionality and the register's usefulness. |

### **6.2. Utility Value Metrics**

| Metric                                 | Target       | Rationale                                                                                                                          |
|:---------------------------------------|:-------------|:-----------------------------------------------------------------------------------------------------------------------------------|
| Number of Active Transactions per User | Average \> 3 | The more transactions, the greater the app's integration into the user's financial life.                                           |
| Completed Cycle Ratio                  | \> 60%       | The percentage of transactions that reached 100% repaid status (automatically), confirming effective management.                   |
| Reminder Setting Rate                  | \> 75%       | The percentage of transactions with a one-time or recurring reminder set. Demonstrates the use of the product's key functionality. |

