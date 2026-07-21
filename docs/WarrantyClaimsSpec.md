# WARRANTY CLAIMS & PROCESS FUNCTIONAL SPECIFICATION
## (Screen & Field Specifications - FPT Standard SRS Template)

This document contains the functional specifications, mockup descriptions, and field validation rules for the customer-facing **Warranty Center** and the staff-facing **Warranty Console** of the UniLap store system, covering **Handle Warranty Request (UC27)** and **Track Warranty Status (UC28)**.

---

## TABLE OF CONTENTS
1. [Warranty Center Screen - Customer Dashboard (UC27 & UC28)](#1-warranty-center-screen---customer-dashboard-uc27--uc28)
2. [Submit Warranty Request Wizard - Steps 2 to 4 (UC27)](#2-submit-warranty-request-wizard---steps-2-to-4-uc27)
3. [Warranty Claim Detail Screen (UC28)](#3-warranty-claim-detail-screen-uc28)
4. [Warranty Console Screen - Admin/Staff (UC27)](#4-warranty-console-screen---adminstaff-uc27)

---

## 1. Warranty Center Screen - Customer Dashboard (UC27 & UC28)

*   **Description:** The landing portal for customer warranty actions. It contains the first step of the warranty request wizard (Product Selection), a quick tracker for claim IDs, and a history table of the customer's recent warranty requests.
*   **Mapping Use Cases:** 
    *   [UC27 – Submit Warranty Request](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L32) (Step 1)
    *   [UC28 – Track Warranty Status](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L56) (Queue view)
*   **Mockup Image Reference:** `docs/mockups/warranty_center_landing.png`

### 1.1 Field & Control Description Table

| ID | Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **01** | **Submit Warranty Request (Wizard Step 1)** | Container / Form | N/A | N/A | Area allowing customers to initiate a warranty request by selecting an eligible purchased product. |
| **02** | **Product Selection Table** | Grid Table | Yes | N/A | List of products from completed (`COMPLETED` or `DELIVERED`) customer orders:<br>- **Select:** Radio button to select product for warranty.<br>- **Product:** Product name + Serial Number (S/N).<br>- **Purchase Date:** Date when the order was completed.<br>- **Warranty Status:** Badge displaying remaining duration or warranty status (e.g. *Under Warranty* - green, or *Expired* - gray). |
| **03** | **Next Button (Wizard)** | Action Button | N/A | Disabled | Proceed to Step 2 (Warranty Status). Enabled only when a product from the list is selected. |
| **04** | **Track Warranty Claim** | Container / Form | N/A | N/A | Area allowing customers to quickly track the status of a specific claim ID. |
| **05** | **Claim ID Input** | TextInput | Yes | Empty | Enter the claim ID (e.g., `42`).<br>- **Constraint:** Must be a positive integer > 0. |
| **06** | **Track Button** | Action Button | N/A | N/A | Validates claim ID format. If valid, redirects to the claim details page ([UC28](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L56)). If not found or not owned by the active account, displays an error message. |
| **07** | **Recent Warranty Activity** | Grid Table | No | N/A | Table listing recent warranty requests created by this account:<br>- **Claim ID / Created Date:** Clickable claim ID link (e.g. `#28`) and its creation date.<br>- **Product:** Product name + Serial Number.<br>- **Defect Title:** Summary of the defect submitted by customer.<br>- **Status:** Colored badge representing the current status (`Pending` - Yellow, `Processing` - Blue, `Approved` - Dark Blue, `Completed` - Green, `Rejected` - Red, `Cancelled` - Gray).<br>- **Actions:** Links: 1. *Details:* Go to claim details page. 2. *Cancel:* Cancel request. |
| **08** | **Cancel Action Link (Table)** | Action Link | No | N/A | - **Visibility condition:** Only visible when claim status is `PENDING` (rule `BR-19`).<br>- **Behavior:** Prompts customer to confirm cancellation. If confirmed, updates status to `CANCELLED`, records in history log, and reloads list. |
| **09** | **Pagination Controls** | Navigation | No | Page 1 | Pagination controls for "Recent Warranty Activity" grid (displays max 5 or 10 records per page). |

---

## 2. Submit Warranty Request Wizard - Steps 2 to 4 (UC27)

*   **Description:** The remaining steps of the wizard to submit a new warranty request.
    *   **Step 2:** Display comprehensive warranty information and policy coverage.
    *   **Step 3:** Enter issue details and upload image evidence.
    *   **Step 4:** Display submission success state.
*   **Mapping Use Case:** [UC27 – Submit Warranty Request](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L32) (Steps 2 to 13)
*   **Mockup Image References:** `docs/mockups/warranty_center_step2.png` to `docs/mockups/warranty_center_step4.png`

### 2.1 Step 2: Warranty Status (Warranty Policy Verification)
Screen displaying policy and warranty duration details of selected product for verification before writing the defect description.

| Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :--- | :--- |
| **Product Information** | Text Display | N/A | Selected product name | Displays full name and code of selected product. |
| **Serial Number (S/N)** | Text Display | N/A | Product S/N | Serial number of the device. |
| **Warranty Policy Name** | Text Display | N/A | Active policy name | Warranty policy applied, fetched from database (e.g. *ASUS Gaming Laptop Policy* or *Standard Warranty*). |
| **Warranty Expiry Date** | Text Display | N/A | DD/MM/YYYY | Warranty expiration date. Formula: `completed_at` + `WarrantyMonths` (rule `UC48.2`). |
| **Back Button** | Button | N/A | N/A | Go back to Step 1 (Product Selection). |
| **Next Button** | Button (Blue) | N/A | N/A | Proceed to Step 3 (Defect Description). |

---

### 2.2 Step 3: Defect Details (Submit Claim Details)
Form to input defect details and upload proof files.

| Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :--- | :--- |
| **Defect Title \*** | TextInput | Yes | Empty | Defect title summary (e.g. *Screen horizontal lines*).<br>- **Constraint:** Max 200 characters (`BR-Length`). |
| **Detailed Defect Description \*** | TextArea | Yes | Empty | Detailed defect description, circumstances of issue.<br>- **Constraint:** Max 2000 characters (`BR-Length`). |
| **Attachment Images** | File Input | No | Empty | Upload images showing product defects.<br>- **Constraint (`BR-Images`):** Max 5 images; formats: `.jpg`, `.jpeg`, `.png`, `.webp`; max 5MB per file. |
| **Back Button** | Button | N/A | N/A | Return to Step 2. |
| **Submit Request Button** | Button (Green) | N/A | N/A | - **Behavior:** Validates inputs. If valid, creates a new warranty claim in database with status `PENDING` (`BR-16`), logs to `WarrantyHistory` (`BR-17`), saves uploaded images, and moves to Step 4. |

---

### 2.3 Step 4: Completion (Confirmation)
Confirmation view shown upon successful submission.

| Field Name (Control) | Type / Format | Description & Validation Rules |
| :--- | :--- | :--- |
| **Success Message** | Text Alert | Displays green success alert banner. |
| **Created Claim ID** | Text Display | Displays auto-incremented database claim ID (e.g., `#28`). |
| **Track Request Button** | Button | Redirects to claim details page to track progress. |
| **Home Button** | Button | Redirects to UniLap home page. |

---

## 3. Warranty Claim Detail Screen (UC28)

*   **Description:** Details page for a single warranty claim from the customer's viewpoint. It displays complete metadata of the claim, uploaded evidence pictures, a visual status track line, and the full timeline history including staff notes.
*   **Mapping Use Case:** [UC28 – Track Warranty Status](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L56) (Detail view & Cancellation)
*   **Mockup Image References:** `docs/mockups/warranty_claim_detail_completed.png`, `docs/mockups/warranty_claim_detail_pending.png`

### 3.1 Field & Control Description Table

| ID | Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **01** | **Claim Header Title** | Text Title | N/A | Defect Title | Defect title + Claim ID (e.g. `abc (Claim #25)`). |
| **02** | **Status badge** | Status Badge | N/A | Based on data | Visual status badge (`PENDING`, `PROCESSING`, `APPROVED`, `REJECTED`, `COMPLETED`, `CANCELLED`). |
| **03** | **Serial Number** | Text Display | N/A | Device S/N | Serial number of the device. |
| **04** | **Product** | Text Display | N/A | Product Name | Name of the product variant. |
| **05** | **Order ID** | Text Display | N/A | Order ID | ID of the order containing this product (clickable link to view receipt). |
| **06** | **Submitted Date** | Text / Date | N/A | Creation Date | Claim submission datetime: `HH:mm, DD/MM/YYYY`. |
| **07** | **Updated Date** | Text / Date | N/A | Update Date | Most recent status update datetime. |
| **08** | **Completed Date** | Text / Date | N/A | Empty or Date | Expiry/completion datetime (only shown if status is `COMPLETED`). |
| **09** | **Defect Description** | Text Display | N/A | Description Content | Customer's defect description text. |
| **10** | **Attached Evidence** | Image Thumbnails| No | N/A | - Lists evidence images uploaded by customer.<br>- **Behavior:** Clicking thumbnail opens full-screen lightbox preview. |
| **11** | **Processing Timeline** | Visual Steps Chart| N/A | N/A | Vertical visual steps indicator:<br>1. *Request Submitted* (Active on creation)<br>2. *Processing* (Active on staff assignment)<br>3. *Approved* (Active on staff decision)<br>4. *Completed* (Active on device handover). |
| **12** | **Audit History Logs** | Timeline List | Yes | N/A | Detailed history log of status changes:<br>- Status state reached.<br>- Transition timestamp.<br>- **Staff Note:** Remarks or rejection reasons from staff (e.g. *Warranty completed. Device returned to customer*). |
| **13** | **Back to List Button** | Navigation Button| N/A | N/A | Return to Warranty Center dashboard. |
| **14** | **Cancel Request Button** | Action Button (Red)| N/A | N/A | - **Visibility condition:** Only visible when claim status is `PENDING` (`BR-19`).<br>- **Behavior:** Displays confirmation dialog. If customer accepts, updates status to `CANCELLED`, logs audit event, and reloads detail view (hides cancel button). |

---

## 4. Warranty Console Screen - Admin/Staff (UC27)

*   **Description:** The internal dashboard layout for support staff and administrators to process claims. It features a searchable/filterable queue of active claims on the left and a detailed work panel on the right for processing actions and entering resolution logs.
*   **Mapping Use Case:** [UC27 – Handle Warranty Request](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L32) (Staff processing phase)
*   **Mockup Image Reference:** `docs/mockups/admin_warranty_console.png`

### 4.1 Field & Control Description Table

| ID | Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **01** | **Search Claims Box** | TextInput | No | Empty | Enter keyword (customer name, product, claim ID, or serial) to search claims queue. |
| **02** | **Status Filter** | Dropdown | Yes | All Statuses | Filter claims by status (`All Statuses`, `Pending`, `Processing`, `Approved`, `Rejected`, `Completed`, `Cancelled`). |
| **03** | **Reset Button** | Button | N/A | N/A | Clear search terms and revert status filters to default. |
| **04** | **Claims Queue Table** | Grid Table | Yes | N/A | Table listing requests matching filter:<br>- **CLAIM ID:** Claim ID (e.g. `#28`).<br>- **CUSTOMER:** Customer name.<br>- **PRODUCT:** Product name + S/N.<br>- **STATUS:** Status colored badge.<br>- **DATE:** Submission date.<br>- **DETAIL:** "Open $\rightarrow$" link to sidebar details. |
| **05** | **Claim Detail Panel (Right)**| Sidebar Container| N/A | N/A | Displays details of selected claim. |
| **06** | **Evidence Images (Right)** | Image Grid | No | N/A | Displays proof images (or "No images uploaded"). |
| **07** | **Timeline History (Right)** | List | Yes | N/A | Log list of historical transitions with staff notes. |
| **08** | **Staff Note Input** | TextArea | Yes\* | Empty | Textarea to input resolution remarks or transition notes.<br>- **Constraint:** Required when performing Accept, Approve, Reject, Complete, or Cancel actions (`BR-21`). Max 1000 characters. |
| **09** | **Accept Button** | Action Button (Blue) | N/A | N/A | - **Visibility condition:** Only shown when claim status is `PENDING`.<br>- **Behavior:** Transitions claim status to `PROCESSING` (`BR-20`), assigns claim to active staff member (`staff_id`), and logs audit entry with text from `Staff Note Input`. |
| **10** | **Approve Button** | Action Button (Green)| N/A | N/A | - **Visibility condition:** Only shown when claim status is `PROCESSING`.<br>- **Behavior:** Transitions status to `APPROVED`, logs audit entry with text from `Staff Note Input`. |
| **11** | **Reject Button** | Action Button (Red) | N/A | N/A | - **Visibility condition:** Only shown when claim status is `PROCESSING`.<br>- **Behavior:** Transitions status to `REJECTED`. Staff must enter rejection reason in `Staff Note Input` to notify the customer. |
| **12** | **Complete Button** | Action Button (Blue) | N/A | N/A | - **Visibility condition:** Only shown when claim status is `APPROVED`.<br>- **Behavior:** Transitions status to `COMPLETED`, records completion datetime (`completed_at`), and closes the warranty lifecycle for the item. |
| **13** | **Cancel Claim Button** | Action Button (Red Outline)| N/A | N/A | - **Visibility condition:** Only shown when status is `PENDING` or `PROCESSING`.<br>- **Behavior:** Allows staff to cancel request (after client consultation). Transitions status to `CANCELLED`. Rejection/cancellation reason must be entered in `Staff Note Input`. |
