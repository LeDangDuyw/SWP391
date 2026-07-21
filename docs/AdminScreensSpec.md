# ADMIN SCREENS FUNCTIONAL SPECIFICATION
## (Screen & Field Specifications - FPT Standard SRS Template)

This document contains the functional specifications, mockup descriptions, and field validation rules for the Administrator and Staff screens of the UniLap store system, covering the **Dashboard**, **Advanced Analytics**, and **Store Policies Management** (Warranty Policies & Footer Policies).

---

## TABLE OF CONTENTS
1. [Overview Dashboard Screen (UC50)](#1-overview-dashboard-screen-uc50)
2. [Advanced Business Analytics Screen (UC49)](#2-advanced-business-analytics-screen-uc49)
    - 2.1. [Common Filters](#21-common-filters)
    - 2.2. [Revenue Analysis Tab](#22-revenue-analysis-tab)
    - 2.3. [Sales Analysis Tab](#23-sales-analysis-tab)
    - 2.4. [Customer Analytics Tab](#24-customer-analytics-tab)
    - 2.5. [Product & Inventory Tab](#25-product--inventory-tab)
3. [Store Policies Management Screen (UC48 & UC52)](#3-store-policies-management-screen-uc48--uc52)
    - 3.1. [Warranty Policies Tab](#31-warranty-policies-tab)
    - 3.2. [Create New Warranty Policy Modal](#32-create-new-warranty-policy-modal)
    - 3.3. [Edit Warranty Policy Modal](#33-edit-warranty-policy-modal)
    - 3.4. [Footer Policies Tab](#34-footer-policies-tab)
    - 3.5. [Create/Edit Footer Policy Modals](#35-createedit-footer-policy-modals)

---

## 1. Overview Dashboard Screen (UC50)

*   **Description:** The default landing screen after an Administrator/Staff successfully logs into the admin console. It provides quick summary cards, a pending order status matrix, low stock alerts, and a recent activities log.
*   **Mapping Use Case:** [UC50 – View System Dashboard](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L21)
*   **Mockup Image Reference:** `docs/mockups/admindashboard.png`

### 1.1 Field & Control Description Table

| ID | Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :---: | :--- | :--- |
| **01** | **Sidebar Navigation** | Navigation Menu | N/A | Dashboard (Active) | Admin navigation sidebar:<br>- Click *Dashboard* $\rightarrow$ Redirect to current page.<br>- Click *Users* $\rightarrow$ Redirect to user management page.<br>- Click *Analytics* $\rightarrow$ Redirect to advanced analytics page ([UC49](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L20)).<br>- Click *Policies* $\rightarrow$ Redirect to warranty policy page ([UC48.1](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L104)).<br>- Click *Warranty* $\rightarrow$ Redirect to claims processing page ([UC27](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L32)). |
| **02** | **Revenue This Month** | KPI Card & Select | No | Current Month Revenue / "This Month" | - Displays total revenue of the current month with growth percentage compared to the previous month.<br>- Dropdown allows selecting other timeframes (Today, This Week, This Month, This Year). |
| **03** | **Orders Today** | KPI Card & Select | No | Current Day Orders / "Today" | - Displays the count of orders created today along with the growth rate compared to yesterday.<br>- Dropdown allows changing the filter timeframe. |
| **04** | **New Customers** | KPI Card & Select | No | 0 / "This Month" | Displays the total number of newly registered customer accounts within the selected timeframe. |
| **05** | **Active Alerts** | KPI Card & Badge | No | 5 / "Needs attention" | Displays the count of urgent warnings needing processing (Low stock, pending claims, tickets). Clicking the card redirects to the respective detail view. |
| **06** | **Revenue Analytics Bar Chart** | Interactive Chart | No | Monthly Data | Bar chart showing revenue variations over time. Hover over columns to view details. |
| **07** | **Orders Needing Process** | Grid Table | No | N/A | Table summarizing order counts by status (*Pending, Processing, Shipped, Cancelled*) split by timeframe (*Today, This Week, This Month, All*).<br>- Users can click numbers (if > 0) to navigate to the order grid pre-filtered by selected criteria. |
| **08** | **Low Stock Products** | Grid Table | No | N/A | Lists products with stock quantities (QTY) under the warning threshold ($\le 10$). Columns: *Product, Category, Qty*. |
| **09** | **Top Products / Customers** | Horizontal Bar Chart | No | Top 10 | Ranking lists:<br>- *Top Products*: Filter best sellers by quantity sold or revenue.<br>- *Top Customers*: Filter highest spending customers. |
| **10** | **Recent Activities** | Log List | No | N/A | Live feed displaying system events (Delivered orders, newly submitted claims, approved/rejected claims) with relative timestamps. |
| **11** | **Logout Button** | Action Button | N/A | N/A | Click to terminate current session and redirect to login page. |

---

## 2. Advanced Business Analytics Screen (UC49)

*   **Description:** An advanced business reporting screen providing granular analytical breakdowns of revenue, sales trends, customer acquisition rates, and product stock turnover ratios.
*   **Mapping Use Case:** [UC49 – View Advanced Analytics](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L20)
*   **Mockup Image Reference:** `docs/mockups/advanced_analytics_tab1.png` to `docs/mockups/advanced_analytics_tab4.png`

### 2.1 Common Filters
Shared filters placed at the top of the analytics pane, applying to all 4 tabs.

| Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :--- | :--- |
| **From Date** | Date (MM/DD/YYYY) | Yes | 01/01/2025 | Lọc từ ngày. Must be less than or equal to *To Date*. |
| **To Date** | Date (MM/DD/YYYY) | Yes | 12/31/2026 | Lọc đến ngày. Must be greater than or equal to *From Date*. |
| **Category** | Dropdown (Select) | No | -- All Categories -- | Filter by product category (Laptop, Headphone, Speaker, Keyboard). |
| **Brand** | Dropdown (Select) | No | -- All Brands -- | Filter by manufacturer (Apple, ASUS, HP, Dell, Lenovo, Acer, MSI...). |
| **Customer Type** | Dropdown (Select) | No | -- All Types -- | Filter by customer cohort (New, Returning). |
| **Payment Method** | Dropdown (Select) | No | -- All Methods -- | Filter by payment method (`bank_transfer`, `momo`, `credit_card`, `cod`). |
| **Group By** | Dropdown (Select) | Yes | Month | Time aggregation frequency (Day, Week, Month, Year). |
| **Apply Button** | Action Button | N/A | N/A | Validates inputs. Reloads all charts and tables in the active tab. |
| **Reset Button** | Action Button | N/A | N/A | Reverts filter fields to initial default values. |

---

## 2.2 Revenue Analysis Tab
*   **Purpose:** Deep dive into company revenue trends, categories share, and brand contributions.
*   **Mockup Reference:** `docs/mockups/advanced_analytics_tab1.png`

| Field Name (Control) | Type / Format | Description & Validation Rules |
| :--- | :--- | :--- |
| **Total Revenue (Filtered)** | Indicator Card | Net cumulative revenue of sold products matching filter criteria (prominently displayed as a large number). |
| **Revenue Trend Line** | Line Chart | X-axis shows time period (Group By), Y-axis shows amount. Helps track whether revenue is trending up or down. |
| **Revenue Share by Category** | Bar Chart | Represents total revenue generated from each product category. |
| **Revenue Share by Brand** | Bar Chart | Vertical bar chart classifying revenue by brand in descending order. |

---

## 2.3 Sales Analysis Tab
*   **Purpose:** Focuses on transaction quantities, average order sizes, and payment behaviors.
*   **Mockup Reference:** `docs/mockups/advanced_analytics_tab2.png`

| Field Name (Control) | Type / Format | Description & Validation Rules |
| :--- | :--- | :--- |
| **Total Orders** | Indicator Card | Total count of successful orders within query period. |
| **Average Order Value (AOV)** | Indicator Card | Average order value. Formula: `Total Revenue / Total Orders`. |
| **Orders Volume Trend** | Area Chart | Area chart plotting changes in order volume over time. |
| **Share by Payment Method** | Colored Bar Chart | Represents order count corresponding to each payment gateway to audit customer payment behaviors. |

---

## 2.4 Customer Analytics Tab
*   **Purpose:** Analyzes new user acquisition, customer retention, and ranks high-value VIP buyers.
*   **Mockup Reference:** `docs/mockups/advanced_analytics_tab3.png`

| Field Name (Control) | Type / Format | Description & Validation Rules |
| :--- | :--- | :--- |
| **Top Customers N** | TextInput (Integer) | Enter number of VIP customers to rank (Default: 10). Constraint: Must be a positive integer $\ge 1$. |
| **Cohort Customer Acquisition** | Line Chart | Tracks count of newly created accounts over time. |
| **New vs Returning Customers** | Donut Chart | Donut chart showing percentage split between New Customers (first purchase) and Returning Customers. |
| **Top Spending Customers Table** | Data Table (Grid) | Table listing VIP buyer details: *Rank*: Spending rank. *Customer Name*: Name. *Email Address*: Contact email. *Distinct Orders*: Count of completed orders. *Total Spending*: Total spent (VND). |

---

## 2.5 Product & Inventory Tab
*   **Purpose:** Controls cost of goods, stock value, turnover efficiency, and monitors hot/cold products.
*   **Mockup Reference:** `docs/mockups/advanced_analytics_tab4.png`

| Field Name (Control) | Type / Format | Description & Validation Rules |
| :--- | :--- | :--- |
| **Rank Limit (N)** | TextInput (Integer) | Enter count of best/worst sellers to display. Default: 10. Constraint: Integer $\ge 1$. |
| **Rank By** | Dropdown (Select) | Criteria for ranking products (Select between `Quantity Sold` or `Revenue`). |
| **Cost of Goods Sold (COGS)** | Indicator Card | Cost of goods sold. Formula: `Sum (Product Cost Price * Quantity Sold)`. |
| **Average Inventory Value** | Indicator Card | Average inventory value calculated as the average of start-of-period and end-of-period inventory values. |
| **Inventory Turnover Ratio** | Indicator Card | Inventory turnover ratio. Formula: `COGS / Average Inventory Value`. Higher ratio indicates faster, more efficient sales. |
| **Best Selling Products Table** | Data Table (Grid) | List of top 10 best-selling products: *Rank, Product/Variant, Qty Sold, Revenue*. |
| **Worst Selling Products Table** | Data Table (Grid) | List of top 10 worst-selling products for markdown or inventory clearance planning. |

---

## 3. Store Policies Management Screen (UC48 & UC52)

*   **Description:** Screen that manages store terms, privacy docs, and product warranty policies. Divided into two main sub-tabs: **Warranty Policies** and **Footer Policies**.
*   **Mapping Use Cases:** 
    *   Warranty Policies: [UC48.1](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L104) to [UC48.6](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L19).
    *   Footer Policies: [UC51](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L21) and [UC52.1](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L23) to [UC52.6](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L28).
*   **Mockup Image References:** `docs/mockups/store_policies_warranty.png`, `docs/mockups/store_policies_create_warranty.png`, `docs/mockups/store_policies_edit_warranty.png`, `docs/mockups/store_policies_footer.png`

### 3.1 Warranty Policies Tab
Screen displaying the list and details of product warranty policies.

| Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :--- | :--- |
| **Warranty Policies Tab Link** | Tab Select | Yes | Active | Clicking loads warranty policy management sub-system. |
| **Search Box** | TextInput | No | Empty | Enter keyword to search warranty policies by name. |
| **Go Button** | Button | N/A | N/A | Execute search and filter list below. |
| **Active Documents List** | Sidebar List | Yes | N/A | List of existing warranty policies in the system, showing policy name, status (`DRAFT`, `LIVE`, `DISABLED`), and last updated date. |
| **+ New Policy Button** | Action Button | N/A | N/A | Click to open modal popup to create a new warranty policy ([UC48.3](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L152)). |
| **Version History Button** | Action Button | N/A | N/A | View modification history of selected policy ([UC48.2](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L128)). |
| **Status Dropdown** | Dropdown | Yes | Based on document | Change active policy status (`Draft`, `Live`, `Disabled`). |
| **Delete Button** | Action Button (Red)| N/A | N/A | Delete selected warranty policy ([UC48.5](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L200)). Displays confirmation prompt before deletion. |
| **Edit Policy Button** | Action Button | N/A | N/A | Allows editing details of the active policy ([UC48.4](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L176)). |
| **Save Draft Button** | Action Button | N/A | N/A | Save changes as `DRAFT` without publishing. |
| **Publish Button** | Action Button (Blue)| N/A | N/A | Change status to `LIVE` and apply it to product groups (Validates business rule `BR-24`). |

---

### 3.2 Create New Warranty Policy Modal
Popup modal shown when clicking the **+ New Policy** button.

| Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :--- | :--- |
| **Policy Name \*** | TextInput | Yes | Empty | Name of the new warranty policy. Constraint: Must not contain purely numbers, maximum 150 characters, must be unique (otherwise errors with `MSG02` - "Policy name has already existed"). |
| **Description** | TextArea | No | Empty | Brief description of the policy's purpose. |
| **Policy Content** | RichText Editor | Yes | Empty | RichText editor containing detailed terms. Cannot be empty when publishing as `LIVE` (`BR-24`). |
| **Applicable Regions** | TextInput | No | Empty | Geographic regions (separated by commas, e.g. NA, EU, VN). |
| **Warranty Months** | TextInput (Number)| Yes | Empty | Warranty duration in months. Constraint: Positive integer > 0. |
| **Version** | TextInput | Yes | v1.0 | Policy version code (format e.g. v1.0, v2.0). |
| **Effective Date** | DatePicker | Yes | Current Date | Date when the policy goes into effect. |
| **Cancel Button** | Button | N/A | N/A | Close modal and discard unsaved input. |
| **Create Policy Button** | Button (Blue) | N/A | N/A | Validate inputs. If valid, save to database as `DRAFT` and close modal. |

---

### 3.3 Edit Warranty Policy Modal
Popup modal shown when selecting a policy and clicking **Edit Policy**.

| Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :--- | :--- |
| **Policy Name \*** | TextInput | Yes | Old Value | Name of policy to edit. Name uniqueness rule does not check against itself. Max 150 characters. |
| **Description** | TextArea | No | Old Value | Update brief description of the policy. |
| **Policy Content** | RichText Editor | Yes | Old Value | Update policy terms details via the editor. |
| **Applicable Regions** | TextInput | No | Old Value | Geographic regions applicable. |
| **Warranty Months** | TextInput (Number)| Yes | Old Value | Warranty duration in months. Constraint: Positive integer > 0. |
| **Version** | TextInput | Yes | Old Value | Policy version code. |
| **Effective Date** | DatePicker | Yes | Old Value | Effective date. |
| **Status** | Dropdown | Yes | Old Value | Edit active status directly (`Draft`, `Live`, `Disabled`). Selecting `Live` validates that content is not empty (`BR-24`). |
| **Cancel Button** | Button | N/A | N/A | Discard changes and close modal. |
| **Save Changes Button** | Button (Blue) | N/A | N/A | Commit updates to database, record "UPDATED" status history, and close modal ([UC48.4](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L176)). |

---

## 3.4 Footer Policies Tab
Screen that manages store terms, privacy docs, and other static articles displayed in the website footer.

| Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :--- | :--- |
| **Footer Policies Tab Link** | Tab Select | Yes | Active | Loads footer policy management data ([UC52.1](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L23)). |
| **+ New Footer Policy Button**| Action Button | N/A | N/A | Click to open modal to create a new footer policy ([UC52.3](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L25)). |
| **Footer Documents List** | Sidebar List | Yes | N/A | List of existing footer policies (Return policy, shipping, privacy, terms...). |
| **Hiển thị ở Footer** | Checkbox | Yes | Checked | Toggle to decide if this policy is shown in footer ([UC52.5](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L27)). |
| **Thứ tự hiển thị (Order)** | TextInput (Number)| Yes | 0 | Display order sorting value under footer. Smaller numbers display first. Constraint: Integer $\ge 0$. |
| **Save Settings Button** | Action Button | N/A | N/A | Save footer display settings and order sequence. |
| **Content Preview** | RichText Panel | No | N/A | Shows read-only preview of selected policy ([UC52.2](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L24)). |
| **Delete Button** | Action Button (Red)| N/A | N/A | Delete selected footer policy ([UC52.6](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L28)). |
| **Edit Content Button** | Action Button (Blue)| N/A | N/A | Open modal to edit selected footer policy title and content ([UC52.4](file:///d:/GithubSWP/SWP391/docs/UseCases.md#L26)). |

---

## 3.5 Create/Edit Footer Policy Modals
Popup modals for creating or editing footer policy content.

### 3.5.1 Create New Footer Policy Modal

| Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :--- | :--- |
| **Tiêu đề \*** | TextInput | Yes | Empty | Title of the new footer policy (e.g. Shipping Policy). Constraint: Maximum 100 characters. |
| **Mã chính sách (Code)** | TextInput | No | Empty | Unique identifier code (e.g., `SHIPPING_POLICY`). Constraint: Uppercase alphabetic string, no spaces, no accents; used for backend routing. |
| **Nội dung chính sách \*** | RichText Editor | Yes | Empty | RichText content of the detailed terms. |
| **Create Policy Button** | Button (Blue) | N/A | N/A | Submit request to save the new policy. |

### 3.5.2 Edit Footer Policy Content Modal

| Field Name (Control) | Type / Format | Required | Default Value | Description & Validation Rules |
| :--- | :--- | :--- | :--- | :--- |
| **Tiêu đề \*** | TextInput | Yes | Old Value | Edit selected footer policy title. |
| **Nội dung chính sách \*** | RichText Editor | Yes | Old Value | Update policy terms details. |
| **Save Changes Button** | Button (Blue) | N/A | N/A | Submit update request and close modal. |
