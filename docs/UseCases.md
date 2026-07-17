# USE CASE SPECIFICATION DOCUMENT (UNILAP SYSTEM)
## (User Requirements Level - FPT Standard Template)

This document contains the detailed Use Case Specifications for the Warranty Management, System Dashboard, Advanced Analytics, and Footer Policy features of the UniLap technology store system. 

All specifications are written at the **User Requirements Level** (goal-oriented, focused on business value, independent of technology implementations, databases, or code design) and formatted using the standard **FPT Use Case template**.

---

## TABLE OF CONTENTS
1. [UC27 – Handle Warranty Request](#uc27--handle-warranty-request)
2. [UC28 – Track Warranty Status](#uc28--track-warranty-status)
3. [UC48.1 — View & Search Warranty Policy List](#uc481--view--search-warranty-policy-list)
4. [UC48.2 — View Warranty Policy Details & History](#uc482--view-warranty-policy-details--history)
5. [UC48.3 — Create Warranty Policy](#uc483--create-warranty-policy)
6. [UC48.4 — Update Warranty Policy](#uc484--update-warranty-policy)
7. [UC48.5 — Delete Warranty Policy](#uc485--delete-warranty-policy)
8. [UC48.6 — Change Warranty Policy Status](#uc486--change-warranty-policy-status)
9. [UC49 – View Advanced Analytics](#uc49--view-advanced-analytics)
10. [UC50 – View System Dashboard](#uc50--view-system-dashboard)
11. [UC51 – Display Footer Policy](#uc51--display-footer-policy)
12. [UC52.1 – View & Search Footer Policy List](#uc521--view--search-footer-policy-list)
13. [UC52.2 – View Footer Policy Details](#uc522--view-footer-policy-details)
14. [UC52.3 – Create Footer Policy](#uc523--create-footer-policy)
15. [UC52.4 – Update Footer Policy Content](#uc524--update-footer-policy-content)
16. [UC52.5 – Update Footer Display Settings](#uc525--update-footer-display-settings)
17. [UC52.6 – Delete Footer Policy](#uc526--delete-footer-policy)

---

## UC27 – Handle Warranty Request

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC27 Handle Warranty Request |
| **Created By:** | DuyLD (Combined and updated by Antigravity) |
| **Date Created:** | 2026-06-07 (Updated: 2026-07-16) |
| **Primary Actor:** | Customer, Staff/Admin |
| **Secondary Actors:** | None |
| **Description:** | This use case allows a Customer to submit a warranty request for a purchased product, and allows a Staff/Admin member to process and resolve the submitted claim through its lifecycle (accepting, processing, approving, completing, or rejecting/cancelling). |
| **Trigger:** | **Customer:** Navigates to the Warranty Center to submit a request.<br>**Staff/Admin:** Navigates to the Warranty Console to process a request. |
| **Preconditions:** | **PRE-1.** The actor is authenticated.<br>**PRE-2 (Customer).** The Customer has at least one completed order containing a product with a registered serial number.<br>**PRE-3 (Staff/Admin).** The Staff/Admin has warranty processing permissions. |
| **Postconditions:** | **POST-1.** A new warranty claim is created with the status `PENDING`.<br>**POST-2.** The claim status reflects the Staff/Admin decision: `PROCESSING`, `APPROVED`, `REJECTED`, `COMPLETED`, or `CANCELLED`.<br>**POST-3.** Each status transition and creation event is recorded in the warranty history log. |
| **Normal Flow:** | **27.0 Handle Warranty Request (Submission to Processing Lifecycle)**<br>1. **Customer** navigates to the Warranty Center.<br>2. System retrieves and lists all products purchased by the Customer from completed orders.<br>3. **Customer** selects a product from the list, or enters the serial number directly.<br>4. System verifies the product's eligibility for warranty (Exception 27.0.E1, Exception 27.0.E2).<br>5. System displays the product's warranty status and active policy information.<br>6. **Customer** enters a title for the defect and describes the issue in detail.<br>7. **Customer** optionally uploads up to five supporting images.<br>8. **Customer** confirms and submits the request (Alternative Flow 27.1).<br>9. System validates all provided details (serial number, title, description, and image format/count/size).<br>10. System creates a new warranty claim record with `PENDING` status.<br>11. System records the creation event in the history log.<br>12. System saves any uploaded images, linking them with the claim.<br>13. System displays a confirmation message.<br>14. **Staff/Admin** requests to view the warranty claims processing queue in the Warranty Console.<br>15. System displays all claims with search, filter, and pagination options.<br>16. **Staff/Admin** selects the submitted claim to review.<br>17. System displays the claim details, uploaded evidence images, and audit history.<br>18. **Staff/Admin** reviews the claim details and evidence.<br>19. **Staff/Admin** confirms to accept the claim for processing.<br>20. System assigns the claim to the current Staff/Admin, verifies that the claim status is still `PENDING` (Exception 27.0.E3), updates the claim status to `PROCESSING`, and records the transition in the audit history log.<br>21. **Staff/Admin** inspects the physical device and provides a resolution decision and notes (Alternative Flows: 27.2 Approve, 27.3 Reject, 27.4 Cancel).<br>22. System updates the claim status and records the final transition and notes in the history log. Flow ends. |
| **Alternative Flows:** | **27.1 Customer Revises Information Before Confirmation** (triggered at Step 8)<br>1. **Customer** chooses to revise the provided information.<br>2. System allows Customer to update the defect title, description, or images.<br>3. Flow resumes at Step 8.<br><br>**27.2 Staff/Admin Approves Claim** (triggered at Step 21)<br>1. **Staff/Admin** provides approval remarks and confirms the approval decision.<br>2. System updates the claim status from `PROCESSING` to `APPROVED` and records the transition in the audit history log.<br>3. **Staff/Admin** confirms completion of physical warranty service.<br>4. System updates the claim status from `APPROVED` to `COMPLETED` and records the final transition in the audit history log. Flow ends.<br><br>**27.3 Staff/Admin Rejects Claim** (triggered at Step 21)<br>1. **Staff/Admin** provides rejection remarks and confirms the rejection decision.<br>2. System updates the claim status from `PROCESSING` to `REJECTED` and records the transition in the audit history log. Flow ends.<br><br>**27.4 Staff/Admin Cancels Claim** (triggered at Step 21 or directly when status is `PENDING`)<br>1. **Staff/Admin** provides cancellation remarks and confirms the cancellation.<br>2. System updates the claim status to `CANCELLED` and records the transition in the audit history log. Flow ends. |
| **Exceptions:** | **27.0.E1 Product Not Eligible** (triggered at Step 4 or Step 9)<br>1. System detects that the serial number does not exist, does not belong to the Customer's completed orders, or is outside its active warranty period.<br>2. System displays a message stating the specific ineligibility reason.<br>3. The submission is blocked. Flow ends.<br><br>**27.0.E2 Duplicate Active Warranty Request** (triggered at Step 4 or Step 9)<br>1. System detects that an active warranty request (`PENDING`, `PROCESSING`, or `APPROVED`) already exists for this serial number.<br>2. System displays a message: *"An active warranty request is already in progress for this product."*<br>3. The submission is blocked. Flow ends.<br><br>**27.0.E3 Claim No Longer Available for Processing** (triggered at Step 20)<br>1. System detects that the claim has already been accepted for processing by another Staff/Admin member (the claim status is no longer `PENDING`).<br>2. System notifies Staff/Admin that the claim is no longer available and prompts a page refresh.<br>3. No data modification is committed. Flow ends. |
| **Priority:** | High |
| **Frequency of Use:** | High — triggered upon product defect occurrence and processed by Staff/Admin. |
| **Business Rules:** | **BR-15:** A customer can submit a warranty request only for a product that belongs to their completed order, is linked to an active Warranty Policy, and is still within its warranty period.<br>**BR-16:** Every newly submitted warranty request shall be created with the initial status PENDING.<br>**BR-17:** Every warranty request creation, cancellation, and status transition shall be recorded in the Warranty History log together with the actor identity, action performed, and timestamp.<br>**BR-20:** Warranty request status transitions shall strictly follow the workflow: PENDING $\rightarrow$ PROCESSING $\rightarrow$ APPROVED $\rightarrow$ COMPLETED, or PENDING $\rightarrow$ PROCESSING $\rightarrow$ REJECTED. Direct transitions to any other state are not permitted.<br>**BR-21:** Staff shall provide processing remarks when approving, rejecting, or cancelling a warranty request.<br>**BR-22:** Only authorized Staff members are allowed to process warranty requests and update their processing status.<br>**BR-23:** A warranty request cannot be processed simultaneously by multiple Staff members. The system ensures that only one Staff member can process a request at a time.<br>**BR-Images:** Support up to 5 images, file formats JPEG, PNG, JPG, or WEBP, maximum size 5MB per file.<br>**BR-Length:** Serial number $\le$ 100 characters, title $\le$ 200 characters, description $\le$ 2000 characters. |
| **Other Information:** | None |
| **Assumptions:** | 1. Product serial numbers and their associated orders are accurately stored in the system at the time of order completion.<br>2. The active warranty policy linked to the product is accessible at claim submission/processing time.<br>3. The system applies a mechanism to prevent two Staff/Admin members from processing the same claim simultaneously. |

---

## UC28 – Track Warranty Status

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC28 Track Warranty Status |
| **Created By:** | DuyLD |
| **Date Created:** | 2026-06-07 (Updated: 2026-07-12) |
| **Primary Actor:** | Customer |
| **Secondary Actors:** | None |
| **Description:** | This use case enables a Customer to view all submitted warranty requests, inspect details (defect description, timeline history, staff notes, uploaded images) of a selected request, and optionally cancel a pending request. |
| **Trigger:** | The Customer requests to view warranty request status. |
| **Preconditions:** | **PRE-1.** The Customer is authenticated and holds an active session.<br>**PRE-2.** At least one warranty request has been submitted by the Customer. |
| **Postconditions:** | **POST-1.** System displays the details and history of the selected warranty request.<br>**POST-2.** The request status is updated to `CANCELLED` if successfully cancelled. |
| **Normal Flow:** | **28.0 Track Warranty Status**<br>1. Customer requests to view their warranty requests.<br>2. System retrieves and displays all warranty requests associated with the Customer account.<br>3. Customer selects a warranty request to view its details.<br>4. System displays the claim status, audit history timeline, uploaded images, and Staff resolution remarks.<br>5. Customer reviews the displayed information.<br>6. System presents available actions based on the current claim status.<br>7. Customer acknowledges the information. Flow ends. |
| **Alternative Flows:** | **28.1 Customer Cancels Pending Request** (triggered at Step 6 when claim status is `PENDING`)<br>1. Customer requests to cancel the selected warranty request.<br>2. System prompts Customer to confirm the cancellation.<br>3. Customer confirms the cancellation.<br>4. System verifies that the claim status is still `PENDING`.<br>5. System updates the claim status to `CANCELLED` and records the cancellation event in the audit history log.<br>6. System displays a cancellation confirmation message. Flow ends. |
| **Exceptions:** | **28.1.E1 Cancellation Blocked Due to Status Change** (triggered at Step 4 of Alternative Flow 28.1)<br>1. System detects that the claim status has changed from `PENDING` (e.g., to `PROCESSING`) between page load and the cancellation attempt.<br>2. System notifies the Customer that the request is already being processed and cannot be cancelled.<br>3. No data modification is committed. Flow ends. |
| **Priority:** | Medium |
| **Frequency of Use:** | Medium — triggered when a Customer checks request progress or considers cancellation. |
| **Business Rules:** | **BR-18:** A customer may view the complete information and processing history of their own warranty requests only.<br>**BR-19:** A customer may cancel a warranty request only while its status is `PENDING`. Once cancelled, the request cannot be restored. |
| **Other Information:** | None |
| **Assumptions:** | 1. Claim status transitions are recorded with accurate timestamps in the warranty audit history log.<br>2. Uploaded images remain accessible throughout the claim lifecycle. |

---

---

## UC48.1 — View & Search Warranty Policy List

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC48.1 View & Search Warranty Policy List |
| **Created By:** | DuyLD |
| **Date Created:** | 2026-06-07 (Updated: 2026-07-12) |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | This use case allows the Admin to view the list of all warranty policies and search the list by policy name. |
| **Trigger:** | Admin navigates to Warranty Policy Management from the sidebar. |
| **Preconditions:** | Admin is authenticated with policy management permissions. |
| **Postconditions:** | **POST-1.** The list of warranty policies is displayed with each policy's name, status, and update time.<br>**POST-2.** No policy data is modified. |
| **Normal Flow:** | **48.1 View & Search Warranty Policy List**<br>1. Admin opens Warranty Policy Management.<br>2. System retrieves and displays the policy list (including policy name, status, and update time).<br>3. Admin reviews the list. Flow ends. |
| **Alternative Flows:** | **48.1.1 Search by Keyword** (triggered at Step 3)<br>1. Admin enters a keyword in the search box and submits.<br>2. System searches policies whose name contains the keyword (case-insensitive partial match).<br>3. System displays the filtered results. Flow resumes at Step 3. |
| **Exceptions:** | **48.1.E1 No Matching Results** (triggered at Step 2 of Alternative Flow)<br>1. System finds zero policies matching the given keyword.<br>2. System displays an empty list state. Flow ends. |
| **Priority:** | High |
| **Frequency of Use:** | Multiple times per day. |
| **Business Rules:** | **Pagination:** Results are paginated at 5 policies per page, ordered by creation time descending. |
| **Other Information:** | None |
| **Assumptions:** | The policy list is always retrieved fresh on page load. |

---

## UC48.2 — View Warranty Policy Details & History

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC48.2 View Warranty Policy Details & History |
| **Created By:** | DuyLD |
| **Date Created:** | 2026-06-07 (Updated: 2026-07-12) |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | This use case allows the Admin to select a warranty policy from the list and view its full details (content, duration, status, dates) together with its complete change history. |
| **Trigger:** | Admin selects a policy from the list. |
| **Preconditions:** | **PRE-1.** Admin is authenticated with policy management permissions.<br>**PRE-2.** The selected policy exists. |
| **Postconditions:** | **POST-1.** The policy's full details and its change history are displayed in the detail panel.<br>**POST-2.** No policy data is modified. |
| **Normal Flow:** | **48.2 View Warranty Policy Details & History**<br>1. Admin selects a policy in the list.<br>2. System retrieves the policy details.<br>3. System calculates the Expiry Date as the Effective Date plus the Warranty Months.<br>4. System retrieves the policy's change history, ordered by most recent change first.<br>5. System displays the policy's name, version, description, content, applicable regions, warranty months, effective date, computed expiry date, and status, along with the history timeline (action type, status, and timestamp for each change).<br>6. Admin reviews the information. Flow ends. |
| **Alternative Flows:** | None |
| **Exceptions:** | **48.2.E1 Policy Not Found** (triggered at Step 2)<br>1. System cannot find the policy with the given identifier.<br>2. System returns to the list view without displaying a detail panel. Flow ends. |
| **Priority:** | Medium |
| **Frequency of Use:** | Multiple times per day. |
| **Business Rules:** | **BR-24:** A Warranty Policy must define at minimum: policy name, at least one applicable product category (or region), warranty duration in months, and terms and conditions text. |
| **Other Information:** | None |
| **Assumptions:** | Policy content is stored as formatted text and rendered as-is in the detail panel. |

---

## UC48.3 — Create Warranty Policy

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC48.3 Create Warranty Policy |
| **Created By:** | DuyLD |
| **Date Created:** | 2026-06-07 (Updated: 2026-07-12) |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | This use case allows the Admin to create a new warranty policy by entering its name, description, content, applicable regions, warranty duration, version, and effective date. New policies are created with status DRAFT. |
| **Trigger:** | Admin selects "Create New Policy" and submits the create form. |
| **Preconditions:** | Admin is authenticated with policy management permissions. |
| **Postconditions:** | **POST-1.** A new warranty policy is created with status `DRAFT`.<br>**POST-2.** A "CREATED" entry is recorded in the policy history log.<br>**POST-3.** Admin is redirected to the Warranty Policy Management list. |
| **Normal Flow:** | **48.3 Create Warranty Policy**<br>1. Admin opens the Create Policy form.<br>2. Admin enters Policy Name (required), Description, Policy Content, Applicable Regions, and Warranty Months. Version defaults to "1.0" and Effective Date defaults to the current date if left blank.<br>3. Admin submits the form.<br>4. System validates that the Policy Name is not empty.<br>5. System validates that the Policy Name contains at least one letter.<br>6. System validates that the Policy Name does not already exist (case-insensitive).<br>7. System sets the new policy's Status to `DRAFT`.<br>8. System inserts the new policy record.<br>9. System inserts a "CREATED" entry in the policy history log.<br>10. System redirects Admin to the Warranty Policy Management list. Flow ends. |
| **Alternative Flows:** | None |
| **Exceptions:** | **48.3.E1 Empty or Invalid Policy Name** (triggered at Step 4 or Step 5)<br>1. System detects the Policy Name field is empty, or consists only of numbers/special characters.<br>2. System displays an error message and redisplays the form with the previously entered data preserved. Flow resumes at Step 3.<br><br>**48.3.E2 Duplicate Policy Name** (triggered at Step 6)<br>1. System detects that a policy with the same name (case-insensitive) already exists.<br>2. System displays *"Policy name has already existed"* and redisplays the form with the previously entered data preserved. Flow resumes at Step 3. |
| **Priority:** | High |
| **Frequency of Use:** | Low — triggered when new products are introduced or warranty terms require revision. |
| **Business Rules:** | **BR-24:** A Warranty Policy must define at minimum: policy name, at least one applicable product category (or region), warranty duration in months, and terms and conditions text. |
| **Other Information:** | None |
| **Assumptions:** | Applicable regions and product categories can be entered as free text at creation time. |

---

## UC48.4 — Update Warranty Policy

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC48.4 Update Warranty Policy |
| **Created By:** | DuyLD |
| **Date Created:** | 2026-06-07 (Updated: 2026-07-12) |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | This use case allows the Admin to edit an existing warranty policy's name, description, content, applicable regions, warranty duration, version, effective date, and status. |
| **Trigger:** | Admin edits a selected policy and submits the edit form. |
| **Preconditions:** | **PRE-1.** Admin is authenticated with policy management permissions.<br>**PRE-2.** The policy exists. |
| **Postconditions:** | **POST-1.** The policy's fields are updated.<br>**POST-2.** An "UPDATED" entry is recorded in the policy history log. |
| **Normal Flow:** | **48.4 Update Warranty Policy**<br>1. Admin opens a policy's detail panel and selects Edit.<br>2. System pre-fills the edit form with the policy's current values.<br>3. Admin modifies Policy Name, Description, Policy Content, Applicable Regions, Warranty Months, Version, Effective Date, and/or Status, then submits.<br>4. System retrieves the existing policy.<br>5. System applies the submitted values to the policy; fields left blank keep their previous values.<br>6. System validates that the Policy Name is not empty.<br>7. System validates that the Policy Name contains at least one letter.<br>8. System validates that the Policy Name is not already used by another policy (excluding the policy itself).<br>9. System validates that Policy Content is not empty if the status is set to `LIVE` or `PUBLISHED`.<br>10. System updates the policy record.<br>11. System inserts an "UPDATED" entry in the policy history log.<br>12. System redirects Admin to the policy's detail view. Flow ends. |
| **Alternative Flows:** | None |
| **Exceptions:** | **48.4.E1 Empty or Invalid Policy Name** (triggered at Step 6 or Step 7)<br>1. System detects the Policy Name field is empty, or consists only of numbers/special characters.<br>2. System displays an error message and redisplays the edit view with the previously entered data preserved. Flow resumes at Step 3.<br><br>**48.4.E2 Duplicate Policy Name** (triggered at Step 8)<br>1. System detects that another policy already uses the submitted name (case-insensitive).<br>2. System displays *"Policy name has existed!"* and redisplays the edit view. Flow resumes at Step 3.<br><br>**48.4.E3 Content Empty on Live Status** (triggered at Step 9)<br>1. System detects that the policy status is set to `LIVE` or `PUBLISHED` but the policy content field is left empty.<br>2. System displays *"Policy content cannot be empty when publishing policy to Live!"* and redisplays the form. Flow resumes at Step 3. |
| **Priority:** | High |
| **Frequency of Use:** | Low — triggered when warranty terms require revision. |
| **Business Rules:** | **BR-24:** A Warranty Policy must define at minimum: policy name, at least one applicable product category (or region), warranty duration in months, and terms and conditions text. |
| **Other Information:** | None |
| **Assumptions:** | None |

---

## UC48.5 — Delete Warranty Policy

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC48.5 Delete Warranty Policy |
| **Created By:** | DuyLD |
| **Date Created:** | 2026-06-07 (Updated: 2026-07-12) |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | This use case allows the Admin to permanently remove a warranty policy and all of its recorded change history from the system. |
| **Trigger:** | Admin selects Delete on a chosen policy and confirms the action. |
| **Preconditions:** | **PRE-1.** Admin is authenticated with policy management permissions.<br>**PRE-2.** The policy exists. |
| **Postconditions:** | **POST-1.** The policy record and all of its history records are permanently removed.<br>**POST-2.** Admin is redirected to the policy list. |
| **Normal Flow:** | **48.5 Delete Warranty Policy**<br>1. Admin selects a policy and clicks Delete.<br>2. System displays a confirmation dialog: *"Are you sure you want to delete this policy? This action cannot be undone."*<br>3. Admin confirms the deletion.<br>4. System deletes all history records associated with the policy.<br>5. System deletes the policy record.<br>6. System redirects Admin to the policy list. Flow ends. |
| **Alternative Flows:** | **48.5.1 Admin Cancels Deletion**<br>1. Admin closes the confirmation dialog without confirming.<br>2. Flow ends; no data is changed. |
| **Exceptions:** | None |
| **Priority:** | Medium |
| **Frequency of Use:** | Low — deletion is irreversible; Disable is preferred when history should be preserved. |
| **Business Rules:** | None |
| **Other Information:** | None |
| **Assumptions:** | Admin understands that deletion is permanent and differs from disabling a policy. |

---

## UC48.6 — Change Warranty Policy Status

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC48.6 Change Warranty Policy Status |
| **Created By:** | DuyLD |
| **Date Created:** | 2026-06-07 (Updated: 2026-07-12) |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | This use case allows the Admin to change a warranty policy's lifecycle status between DRAFT, LIVE, and DISABLED using a status dropdown on the policy detail panel. |
| **Trigger:** | Admin selects a target status from the status dropdown on a selected policy's detail panel. |
| **Preconditions:** | **PRE-1.** Admin is authenticated with policy management permissions.<br>**PRE-2.** A policy is selected. |
| **Postconditions:** | **POST-1.** The policy's Status field is updated to the selected value.<br>**POST-2.** An "UPDATED" entry is recorded in the policy history log. |
| **Normal Flow:** | **48.6 Change Warranty Policy Status**<br>1. Admin selects a target status — Draft, Live, or Disabled — from the status dropdown.<br>2. System displays a confirmation prompt matching the target status.<br>3. Admin confirms the change.<br>4. System validates that the policy content is not empty if the target status is Live.<br>5. System updates the policy's Status field.<br>6. System inserts an "UPDATED" entry in the policy history log.<br>7. System redirects Admin to the policy's detail view showing the new status. Flow ends. |
| **Alternative Flows:** | **48.6.1 Admin Cancels the Confirmation**<br>1. Admin dismisses the confirmation prompt.<br>2. System reloads the page without changing the status. Flow ends. |
| **Exceptions:** | **48.6.E1 Empty Content on Live Status** (triggered at Step 4)<br>1. System detects that the target status is Live but the content is empty.<br>2. System displays *"Policy content cannot be empty when publishing policy to Live!"* and aborts the status change. Flow ends. |
| **Priority:** | High |
| **Frequency of Use:** | Low — triggered when a policy needs to go live or be retired. |
| **Business Rules:** | **BR-25:** Disabling a Warranty Policy does not retroactively invalidate active customer warranties; existing warranties remain valid until their individually computed expiry dates. |
| **Other Information:** | None |
| **Assumptions:** | No enforced state machine governs the transitions; Admin may move a policy directly between Draft, Live, and Disabled. |

---

## UC49 – View Advanced Analytics

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC49 View Advanced Analytics |
| **Created By:** | Antigravity |
| **Date Created:** | 2026-07-09 |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | Admin accesses the Advanced Analytics Dashboard to monitor e-commerce performance metrics divided into specialized tabs: Revenue, Sales, Customer, and Product, applying filters to visualize trends. |
| **Trigger:** | Admin navigates to the Analytics section from the Admin sidebar. |
| **Preconditions:** | Admin is authenticated with analytics access permissions. |
| **Postconditions:** | The Advanced Analytics Dashboard is rendered with up-to-date computed charts and metrics according to the active filters. |
| **Normal Flow:** | **49.0 View Advanced Analytics**<br>1. Admin opens the Advanced Analytics Dashboard.<br>2. System computes and displays the default tab (Revenue) for the default date range.<br>3. System renders the Revenue Trend chart, Revenue by Category, and Revenue by Brand.<br>4. Admin reviews the displayed metrics and chooses to toggle to other specialized tabs:<br>   - **Sales Tab:** Displays order trend, Average Order Value (AOV), and payment method breakdown.<br>   - **Customer Tab:** Displays new vs returning cohort, customer growth trend, and top spenders.<br>   - **Product Tab:** Displays ranking of best/worst selling products and inventory turnover.<br>5. Admin applies optional filters (date range, category, brand, customer type, payment method).<br>6. System recalculates and refreshes the charts and data tables. Flow ends. |
| **Alternative Flows:** | None |
| **Exceptions:** | **49.0.E1 Data Service Timeout** (triggered during calculations)<br>1. System encounters a service timeout or database timeout while computing metrics.<br>2. System displays affected panels with an appropriate "No data available" notice and a Retry button.<br>3. Admin retries; flow resumes at Step 5. |
| **Priority:** | Medium |
| **Frequency of Use:** | Low to Medium – accessed by Admin for periodic business performance reviews. |
| **Business Rules:** | **BR-26:** Revenue and Orders KPIs are computed from confirmed and completed orders only; cancelled and refunded orders are excluded.<br>**BR-27:** Conversion Rate is calculated using the total number of unique user sessions in the selected period as the denominator. |
| **Other Information:** | None |
| **Assumptions:** | 1. Session tracking data is available and accurate.<br>2. Admin has permissions to access aggregate order data. |

---

## UC50 – View System Dashboard

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC50 View System Dashboard |
| **Created By:** | DuyLD |
| **Date Created:** | 2026-06-07 (Updated: 2026-07-12) |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | The Admin accesses the Dashboard to monitor overall business performance and system operations in real time, showing today's totals, category totals, inventory alerts, and tasks awaiting processing. |
| **Trigger:** | Admin navigates to the Dashboard page. |
| **Preconditions:** | Admin is authenticated and holds an active session. |
| **Postconditions:** | **POST-1.** Dashboard information is displayed successfully.<br>**POST-2.** Business metrics, alerts, and action queues are available for review. |
| **Normal Flow:** | **50.0 View System Dashboard**<br>1. Admin navigates to the Dashboard page.<br>2. System retrieves and displays core totals: Total Users, Total Products, Total Categories, and Total Warranty Claims.<br>3. System retrieves and displays Today's Revenue, Today's Order Count, New Customers Today, and the Pending Alerts count.<br>4. System retrieves and displays Products by Category, the Low Stock Products list, and the Recently Added Products list.<br>5. System retrieves and displays Revenue Chart data grouped by month (default) or day.<br>6. System retrieves and displays Orders by Status breakdown, Top Selling Products, and Top Customers rankings.<br>7. System retrieves and displays the Pending Warranty Claims list, pending chatbot feedback/tickets, and the Recent Activities log.<br>8. System displays all KPI cards, charts, and lists on the Dashboard page.<br>9. Admin reviews the dashboard information. Flow ends. |
| **Alternative Flows:** | **50.1 Change Revenue Chart Period** (triggered at Step 5)<br>1. Admin selects Group By = Day or Month, optionally a From/To date range, and/or a Revenue Year.<br>2. System reloads the Revenue Chart using the selected parameters. Flow resumes at Step 8.<br><br>**50.2 View Full Warranty Claims Queue** (triggered at Step 9)<br>1. Admin selects a claim from the Pending Warranty Claims list.<br>2. System redirects Admin to the Warranty Processing console with that claim selected. Flow ends. |
| **Exceptions:** | **50.1.E1 Invalid Date Range** (triggered at Step 1 of Alternative Flow 50.1)<br>1. System detects that the From date is after the To date.<br>2. System discards the invalid range, displays a *"From date cannot be after To date"* error, and keeps the previous chart parameters. Flow resumes at Step 5. |
| **Priority:** | High |
| **Frequency of Use:** | Multiple times per day. |
| **Business Rules:** | **BR-28:** An Inventory Alert is triggered when a product's stock quantity falls below the defined low-stock threshold. |
| **Other Information:** | None |
| **Assumptions:** | Dashboard data services (Product, Order, User, Warranty data sources) are operational. |

---

## UC51 – Display Footer Policy

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC51 Display Footer Policy |
| **Created By:** | Antigravity |
| **Date Created:** | 2026-07-12 |
| **Primary Actor:** | Customer / Visitor |
| **Secondary Actors:** | None |
| **Description:** | Allows any site visitor to view the active general policies displayed in the website footer and view their detailed contents. |
| **Trigger:** | Visitor scrolls to the footer of any page and clicks on a policy link. |
| **Preconditions:** | The policies are set to be visible in the footer and are in an active state. |
| **Postconditions:** | The system displays the selected policy's title and contents. |
| **Normal Flow:** | **51.0 Display Footer Policy**<br>1. Visitor navigates to any page of the website.<br>2. System retrieves and displays the active policies configured to show in the footer, sorted by their display order.<br>3. Visitor clicks on a policy link (e.g., "Privacy Policy").<br>4. System retrieves the corresponding policy's title and rich text content.<br>5. System displays the detailed policy page to the Visitor. Flow ends. |
| **Alternative Flows:** | **51.1 Display Warranty Policy** (triggered at Step 3)<br>1. Visitor clicks on "Warranty Policy".<br>2. System retrieves and lists all active warranty policies of the store. Flow ends. |
| **Exceptions:** | **51.0.E1 Policy Inactive or Removed** (triggered at Step 4)<br>1. System detects that the selected policy is no longer active or does not exist.<br>2. System displays a "Not Found" error page. Flow ends. |
| **Priority:** | High |
| **Frequency of Use:** | Multiple times per day. |
| **Business Rules:** | **Footer Ordering:** Footer policies are sorted by display order (ascending), and then by title alphabetically for policies sharing the same order number. |
| **Other Information:** | None |
| **Assumptions:** | The list of footer policies is cached or loaded dynamically via a filter on every page request. |

---

## UC52.1 – View & Search Footer Policy List

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC52.1 View & Search Footer Policy List |
| **Created By:** | Antigravity |
| **Date Created:** | 2026-07-12 |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | Admin views the list of all general/footer policies in the system and filters the list using keywords. |
| **Trigger:** | Admin clicks the "Footer Policies" tab in Policy Management. |
| **Preconditions:** | Admin is authenticated with policy management permissions. |
| **Postconditions:** | The list of footer policies is displayed. No policy data is modified. |
| **Normal Flow:** | **52.1 View & Search Footer Policy List**<br>1. Admin opens Policy Management.<br>2. Admin clicks the "Footer Policies" tab.<br>3. System retrieves all policies, ordered by display order, and displays them.<br>4. Admin reviews the list. Flow ends. |
| **Alternative Flows:** | **52.1.1 Search by Keyword** (triggered at Step 4)<br>1. Admin enters a keyword in the search box and submits.<br>2. System filters and displays policies whose title contains the keyword.<br>3. Flow resumes at Step 4. |
| **Exceptions:** | **52.1.E1 No Results Found** (triggered at Step 2 of Alternative Flow)<br>1. System finds zero policies matching the keyword.<br>2. System displays a "No policies found" empty state. Flow ends. |
| **Priority:** | High |
| **Frequency of Use:** | Multiple times per day. |
| **Business Rules:** | Policies are ordered by display order (ascending), and then by creation ID. |
| **Other Information:** | None |
| **Assumptions:** | None |

---

## UC52.2 – View Footer Policy Details

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC52.2 View Footer Policy Details |
| **Created By:** | Antigravity |
| **Date Created:** | 2026-07-12 |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | Admin selects a footer policy from the list to view its rich text content preview and display configuration settings. |
| **Trigger:** | Admin clicks on a policy from the footer policy list. |
| **Preconditions:** | Admin is authenticated and the policy exists. |
| **Postconditions:** | The policy's preview and configuration settings are displayed. |
| **Normal Flow:** | **52.2 View Footer Policy Details**<br>1. Admin selects a policy in the list.<br>2. System retrieves the policy details.<br>3. System displays the "Footer Display Settings" panel and the "Content Preview" panel. Flow ends. |
| **Exceptions:** | **52.2.E1 Policy Not Found** (triggered at Step 2)<br>1. System cannot find the selected policy.<br>2. System returns to the list view and displays an error message. Flow ends. |
| **Priority:** | High |
| **Frequency of Use:** | Multiple times per day. |
| **Business Rules:** | None |
| **Other Information:** | None |
| **Assumptions:** | None |

---

## UC52.3 – Create Footer Policy

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC52.3 Create Footer Policy |
| **Created By:** | Antigravity |
| **Date Created:** | 2026-07-12 |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | Admin creates a new general policy, which is set to show in the footer by default. |
| **Trigger:** | Admin clicks the "+ New Footer Policy" button. |
| **Preconditions:** | Admin is authenticated with policy management permissions. |
| **Postconditions:** | **POST-1.** A new policy is created and set to show in the footer.<br>**POST-2.** Admin is redirected to the Footer Policies management list. |
| **Normal Flow:** | **52.3 Create Footer Policy**<br>1. Admin clicks "+ New Footer Policy".<br>2. System displays the "Create New Footer Policy" form.<br>3. Admin enters Title (required), Policy Type (optional), and Rich Text Content.<br>4. Admin submits the form.<br>5. System validates that the Title is not empty.<br>6. System formats the Policy Type if left blank (converting spaces to underscores and capitalising).<br>7. System saves the new policy as active, setting display-in-footer to true and order to 1.<br>8. System redirects Admin to the Footer Policies list. Flow ends. |
| **Exceptions:** | **52.3.E1 Empty Title** (triggered at Step 5)<br>1. System detects that the Title is empty.<br>2. System displays a *"Tiêu đề không được để trống!"* error message and preserves form inputs. Flow resumes at Step 3. |
| **Priority:** | High |
| **Frequency of Use:** | Low — triggered when new store policies need to be added to the footer. |
| **Business Rules:** | **Auto-Generation of Code:** If the Policy Type/Code is left blank, it is automatically generated from the Title by converting it to uppercase, replacing spaces with underscores, and stripping non-alphanumeric characters. |
| **Other Information:** | None |
| **Assumptions:** | None |

---

## UC52.4 – Update Footer Policy Content

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC52.4 Update Footer Policy Content |
| **Created By:** | Antigravity |
| **Date Created:** | 2026-07-12 |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | Admin updates the Title and Rich Text Content of an existing footer policy. |
| **Trigger:** | Admin clicks "Edit Content" on a selected policy's detail view. |
| **Preconditions:** | Admin is authenticated and the policy exists. |
| **Postconditions:** | The policy's Title and Content are updated in the system. |
| **Normal Flow:** | **52.4 Update Footer Policy Content**<br>1. Admin selects a policy and clicks "Edit Content".<br>2. System displays the "Edit Footer Policy Content" form pre-filled with current values.<br>3. Admin modifies Title and/or Content and submits the form.<br>4. System validates that the Title is not empty.<br>5. System updates the policy record and sets the last modified time.<br>6. System redirects Admin to the policy's detail view showing the updated content. Flow ends. |
| **Exceptions:** | **52.4.E1 Empty Title** (triggered at Step 4)<br>1. System detects that the modified Title is empty.<br>2. System displays a *"Tiêu đề không được để trống!"* error and preserves the form fields. Flow resumes at Step 3. |
| **Priority:** | High |
| **Frequency of Use:** | Low. |
| **Business Rules:** | None |
| **Other Information:** | None |
| **Assumptions:** | None |

---

## UC52.5 – Update Footer Display Settings

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC52.5 Update Footer Display Settings |
| **Created By:** | Antigravity |
| **Date Created:** | 2026-07-12 |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | Admin toggles whether a policy shows in the footer and updates its relative sorting order. |
| **Trigger:** | Admin modifies the footer checkbox and order inputs and clicks "Save Settings". |
| **Preconditions:** | Admin is authenticated and the policy is selected. |
| **Postconditions:** | The policy's footer settings are updated. |
| **Normal Flow:** | **52.5 Update Footer Display Settings**<br>1. Admin modifies the checkbox "Hiển thị ở Footer" and/or the number input "Thứ tự hiển thị" in the settings panel.<br>2. Admin clicks "Save Settings".<br>3. System reads the settings (boolean show-in-footer, integer footer-order).<br>4. System updates the policy settings in the database.<br>5. System redirects Admin to the policy's detail view showing the new settings. Flow ends. |
| **Exceptions:** | **52.5.E1 Invalid Order Input** (triggered at Step 3)<br>1. System detects that the order input is not a valid integer.<br>2. System defaults the order value to 0 and proceeds to save. Flow resumes at Step 4. |
| **Priority:** | High |
| **Frequency of Use:** | Low — triggered when footer layout needs rearrangement. |
| **Business Rules:** | Changes made to footer display settings immediately affect the links displayed under the footer on the public customer site. |
| **Other Information:** | None |
| **Assumptions:** | None |

---

## UC52.6 – Delete Footer Policy

| Field | Description |
| :--- | :--- |
| **ID and Name:** | UC52.6 Delete Footer Policy |
| **Created By:** | Antigravity |
| **Date Created:** | 2026-07-12 |
| **Primary Actor:** | Admin |
| **Secondary Actors:** | None |
| **Description:** | Admin permanently removes a general policy from the system. |
| **Trigger:** | Admin clicks "Delete" on a selected policy's detail view. |
| **Preconditions:** | Admin is authenticated and the policy exists. |
| **Postconditions:** | The policy is permanently deleted from the system. |
| **Normal Flow:** | **52.6 Delete Footer Policy**<br>1. Admin selects a policy and clicks "Delete".<br>2. System displays a confirmation warning: *"Are you sure you want to delete this footer policy? This action cannot be undone."*<br>3. Admin confirms the deletion.<br>4. System deletes the policy record from the database.<br>5. System redirects Admin to the Footer Policies management list. Flow ends. |
| **Alternative Flows:** | **52.6.1 Admin Cancels Deletion**<br>1. Admin cancels or closes the confirmation dialog.<br>2. Flow ends; no data is changed. |
| **Exceptions:** | None |
| **Priority:** | High |
| **Frequency of Use:** | Low. |
| **Business Rules:** | None |
| **Other Information:** | None |
| **Assumptions:** | Deleting a policy immediately removes it from both the admin dashboard list and the public customer footer. |
