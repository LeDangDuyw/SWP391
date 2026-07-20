# UML Diagrams for Inbound & Outbound Management (PlantUML)

This document contains the PlantUML source code for the class and sequence diagrams corresponding to each use case in Section **3.2 (Inbound Inventory Management Process)**, Section **3.3 (Manage Inventory and Register IMEI)**, and Section **3.7 / 3.8 (Outbound Management)**.

---

## 1. Section 3.2 & 3.3: Inbound Inventory Management Process

### 3.2.1: Create Ticket

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a
skinparam ClassFontName "Inter"

class DBContext {
    # connection: Connection
    + getConnection(): Connection
    + closeConnection(connection: Connection): void
}

class TicketDAO {
    + createTicket(ticket: Ticket, details: List<TicketDetail>): int
}

class Ticket {
    - ticketId: int
    - title: String
    - status: String
    - reason: String
    - createdBy: int
    - createdAt: LocalDateTime
    - updatedAt: LocalDateTime
    - details: List<TicketDetail>
    + getTicketId(): int
    + setTicketId(ticketId: int): void
    + getTitle(): String
    + setTitle(title: String): void
    + getStatus(): String
    + setStatus(status: String): void
    + getReason(): String
    + setReason(reason: String): void
    + getCreatedBy(): int
    + setCreatedBy(createdBy: int): void
    + getDetails(): List<TicketDetail>
    + setDetails(details: List<TicketDetail>): void
}

class TicketDetail {
    - detailId: int
    - ticketId: int
    - variantId: int
    - quantity: int
    - expectedPrice: BigDecimal
    - variantName: String
    - sku: String
    - importedQuantity: int
    + getDetailId(): int
    + setDetailId(detailId: int): void
    + getTicketId(): int
    + setTicketId(ticketId: int): void
    + getVariantId(): int
    + setVariantId(variantId: int): void
    + getQuantity(): int
    + setQuantity(quantity: int): void
    + getExpectedPrice(): BigDecimal
    + setExpectedPrice(expectedPrice: BigDecimal): void
}

class CreateTicketController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
    # doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- TicketDAO
CreateTicketController ..> TicketDAO : <<use>>
CreateTicketController ..> Ticket : <<use>>
CreateTicketController ..> TicketDetail : <<use>>
Ticket "1" *-- "many" TicketDetail : contains
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center
skinparam SequenceBoxBackgroundColor #ffffff

actor Staff

boundary "CreateTicket.jsp\n(View)" as View #lightyellow
control "CreateTicketController\n(Servlet)" as CreateController #lightgreen
entity "TicketDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

Staff -> View : 1 Input ticket title, select variants,\nfill quantities & expected prices
View -> CreateController : 2 POST /staff/ticket/create {title, variantIds, quantities, expectedPrices}
activate CreateController

alt is empty title / no variants selected
    CreateController -> View : 3 Redirect with error msg
else passes validation
    CreateController -> DAO : 4 createTicket(ticket, details)
    activate DAO
    DAO -> DB : 5 INSERT INTO Ticket (...)\nINSERT INTO TicketDetails (...)
    activate DB
    DB --> DAO : 6 Generated ticket ID
    deactivate DB
    DAO --> CreateController : 7 ticketId
    deactivate DAO
    CreateController -> View : 8 Redirect to list with success msg
end
deactivate CreateController
@enduml
```

---

### 3.2.1.2.2: View Ticket List (Staff)

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class TicketDAO {
    + getAllTickets(): List<Ticket>
}

class Ticket {
    - ticketId: int
    - title: String
    - status: String
    - reason: String
    - createdBy: int
    - createdAt: LocalDateTime
    + getTicketId(): int
    + getTitle(): String
    + getStatus(): String
}

class TicketListController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- TicketDAO
TicketListController ..> TicketDAO : <<use>>
TicketListController ..> Ticket : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "TicketList.jsp\n(View)" as View #lightyellow
control "TicketListController\n(Servlet)" as Controller #lightgreen
entity "TicketDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

Staff -> View : 1 Click "Inbound Ticket List" menu
View -> Controller : 2 GET /staff/ticket/list
activate Controller
Controller -> DAO : 3 getAllTickets()
activate DAO
DAO -> DB : 4 SELECT * FROM Ticket ORDER BY created_at DESC
activate DB
DB --> DAO : 5 ResultSet of Tickets
deactivate DB
DAO --> Controller : 6 List<Ticket>
deactivate DAO
Controller -> View : 7 Forward with "tickets" list attribute
deactivate Controller
View --> Staff : 8 Render ticket list table
@enduml
```

---

### 3.2.1.2.3: View Ticket List (Admin)

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class TicketDAO {
    + getAllTickets(): List<Ticket>
}

class Ticket {
    - ticketId: int
    - title: String
    - status: String
    - reason: String
    - createdBy: int
    - createdAt: LocalDateTime
    + getTicketId(): int
    + getTitle(): String
    + getStatus(): String
}

class AdminTicketListController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- TicketDAO
AdminTicketListController ..> TicketDAO : <<use>>
AdminTicketListController ..> Ticket : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Admin

boundary "AdminTicketList.jsp\n(View)" as View #lightyellow
control "AdminTicketListController\n(Servlet)" as Controller #lightgreen
entity "TicketDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

Admin -> View : 1 Click "Inbound Approval Queue"
View -> Controller : 2 GET /admin/ticket/list
activate Controller
Controller -> DAO : 3 getAllTickets()
activate DAO
DAO -> DB : 4 SELECT * FROM Ticket ORDER BY created_at DESC
activate DB
DB --> DAO : 5 ResultSet of Tickets
deactivate DB
DAO --> Controller : 6 List<Ticket>
deactivate DAO
Controller -> View : 7 Forward with "tickets" list attribute
deactivate Controller
View --> Admin : 8 Render admin approval ticket table
@enduml
```

---

### 3.2.1.2.4: Review Ticket

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class TicketDAO {
    + getTicketById(ticketId: int): Ticket
    + updateTicketStatus(ticketId: int, status: String, reason: String): boolean
}

class Ticket {
    - ticketId: int
    - status: String
    + getStatus(): String
}

class ReviewTicketController {
    # doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- TicketDAO
ReviewTicketController ..> TicketDAO : <<use>>
ReviewTicketController ..> Ticket : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Admin

boundary "AdminTicketList.jsp\n(View)" as View #lightyellow
control "ReviewTicketController\n(Servlet)" as ReviewController #lightgreen
entity "TicketDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

Admin -> View : 1 Approve/Reject ticket with action & reason
View -> ReviewController : 2 POST /admin/ticket/review {ticketId, action, reason}
activate ReviewController
ReviewController -> DAO : 3 getTicketById(ticketId)
activate DAO
DAO -> DB : 4 SELECT * FROM Ticket WHERE ticket_id = ?
activate DB
DB --> DAO : 5 Ticket details
deactivate DB
DAO --> ReviewController : 6 Ticket object
deactivate DAO

alt status is not WAITING_FOR_ADMIN_REVIEW
    ReviewController --> View : 7 Redirect to list with error status transition
else status is WAITING_FOR_ADMIN_REVIEW
    ReviewController -> DAO : 8 updateTicketStatus(ticketId, status, reason)
    activate DAO
    DAO -> DB : 9 UPDATE Ticket SET status = ?, reason = ? WHERE ticket_id = ?
    activate DB
    DB --> DAO : 10 Success (affected rows > 0)
    deactivate DB
    DAO --> ReviewController : 11 boolean (true)
    deactivate DAO
    ReviewController --> View : 12 Redirect to list with success msg
end
deactivate ReviewController
@enduml
```

---

### 3.2.1.2.5: Cargo Workflow

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class TicketDAO {
    + getTicketById(ticketId: int): Ticket
    + updateTicketStatus(ticketId: int, status: String, reason: String): boolean
}

class Ticket {
    - ticketId: int
    - status: String
    + getStatus(): String
}

class CargoWorkflowController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
    # doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- TicketDAO
CargoWorkflowController ..> TicketDAO : <<use>>
CargoWorkflowController ..> Ticket : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "TicketDetail.jsp\n(View)" as View #lightyellow
control "CargoWorkflowController\n(Servlet)" as Controller #lightgreen
entity "TicketDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

== Load Cargo Workflow Detail Screen (GET) ==
Staff -> View : 1 Click "Receive Cargo" or "View Detail" on ticket row
View -> Controller : 2 GET /staff/ticket/workflow {id}
activate Controller
Controller -> DAO : 3 getTicketById(id)
activate DAO
DAO -> DB : 4 SELECT * FROM Ticket WHERE ticket_id = ?
activate DB
DB --> DAO : 5 Ticket data
deactivate DB
DAO --> Controller : 6 Ticket object
deactivate DAO
Controller -> View : 7 Forward with "ticket" attribute
deactivate Controller
View --> Staff : 8 Render ticket detail progress page

== Submit Cargo Status Update Action (POST) ==
Staff -> View : 9 Select action (cancel / receive / request_edit)
View -> Controller : 10 POST /staff/ticket/workflow {ticketId, action}
activate Controller
Controller -> DAO : 11 getTicketById(ticketId)
activate DAO
DAO -> DB : 12 SELECT * FROM Ticket WHERE ticket_id = ?
activate DB
DB --> DAO : 13 Ticket details
deactivate DB
DAO --> Controller : 14 Ticket object
deactivate DAO

alt action is "cancel" & status is not waiting review / approved
    Controller -> View : 15 Redirect with CannotCancelInCurrentStatus
else action is "receive" & status is not approved
    Controller -> View : 16 Redirect with CannotReceiveInCurrentStatus
else action is "request_edit" & status is not rejected
    Controller -> View : 17 Redirect with CannotRequestEditInCurrentStatus
else validation passes
    Controller -> DAO : 18 updateTicketStatus(ticketId, newStatus, "")
    activate DAO
    DAO -> DB : 19 UPDATE Ticket SET status = ?, updated_at = GETDATE() WHERE ticket_id = ?
    activate DB
    DB --> DAO : 20 Success
    deactivate DB
    DAO --> Controller : 21 true
    deactivate DAO
    Controller -> View : 22 Redirect back to workflow screen with updated state
end
deactivate Controller
@endif
@enduml
```

---

### 3.3: Manage Inventory and Register IMEI

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class ProductDAO {
    + countSearchAllProducts(search: String, cat: String): int
    + searchAllProducts(search: String, cat: String, sort: String, page: int, limit: int): List<Product>
    + getTotalInventoryCount(search: String, cat: String, stock: String, item: String): int
    + GetProductInventoryPaginated(search: String, cat: String, sort: String, stock: String, item: String, offset: int, limit: int): List<ProductInventory>
    + hideProduct(variantId: int): void
    + unhideProduct(variantId: int): void
}

class ProductInventory {
    - variantId: int
    - sku: String
    - productName: String
    - variantName: String
    - sellingPrice: BigDecimal
    - availableQuantity: int
    - isDeleted: boolean
    + getVariantId(): int
    + getSku(): String
    + getAvailableQuantity(): int
}

class InventoryListController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
    # doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- ProductDAO
InventoryListController ..> ProductDAO : <<use>>
InventoryListController ..> ProductInventory : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "InventoryManagement.jsp\n(View)" as View #lightyellow
control "InventoryListController\n(Servlet)" as Controller #lightgreen
entity "ProductDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

== View Inventory List (GET) ==
Staff -> View : 1 Access Inventory Management page
View -> Controller : 2 GET /staff/inventory {tab, searchInput, sortBy, category, stockStatus, itemStatus}
activate Controller

alt tab is "products"
    Controller -> DAO : 3 countSearchAllProducts(searchInput, category)
    activate DAO
    DAO --> Controller : 4 count
    deactivate DAO
    Controller -> DAO : 5 searchAllProducts(searchInput, category, sortBy, page, pageSize)
    activate DAO
    DAO --> Controller : 6 List<Product>
    deactivate DAO
else tab is "variants" (default)
    Controller -> DAO : 7 getTotalInventoryCount(searchInput, category, stockStatus, itemStatus)
    activate DAO
    DAO --> Controller : 8 totalRecords count
    deactivate DAO
    Controller -> DAO : 9 GetProductInventoryPaginated(searchInput, category, sortBy, stockStatus, itemStatus, offset, pageSize)
    activate DAO
    DAO --> Controller : 10 List<ProductInventory>
    deactivate DAO
end

Controller -> View : 11 Forward products list and pagination data
deactivate Controller
View --> Staff : 12 Render inventory dashboard grid

== Delete (Hide) / Restore Product Variant (POST) ==
Staff -> View : 13 Click Delete/Hide or Restore on a variant row
View -> Controller : 14 POST /staff/inventory {action, variantIdToDelete}
activate Controller

alt action is "delete"
    Controller -> DAO : 15 hideProduct(variantId)
    activate DAO
    DAO -> DB : 16 UPDATE ProductVariant SET is_deleted = 1 WHERE variant_id = ?
    activate DB
    DB --> DAO : 17 Success
    deactivate DB
    DAO --> Controller : 18 void
    deactivate DAO
else action is "restore"
    Controller -> DAO : 19 unhideProduct(variantId)
    activate DAO
    DAO -> DB : 20 UPDATE ProductVariant SET is_deleted = 0 WHERE variant_id = ?
    activate DB
    DB --> DAO : 21 Success
    deactivate DB
    DAO --> Controller : 22 void
    deactivate DAO
end

Controller -> View : 23 Redirect to /staff/inventory
deactivate Controller
@enduml
```

---

### 3.2.2: View Product List

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class ProductDAO {
    + countSearchAllProducts(search: String): int
    + searchAllProducts(search: String, page: int, limit: int): List<Product>
    + getCategoryIdByProductSearch(search: String): Integer
}

class ProductListFilterDAO {
    + filterLaptop(brandId: Integer, seriesId: Integer, purpose: String, cpu: String, ram: String, ssd: String, gpu: String, screen: String, price: String, sort: String, page: int, limit: int, search: String): List<Product>
    + filterKeyboard(brandId: Integer, purpose: String, connectivity: String, switchType: String, price: String, sort: String, page: int, limit: int, search: String): List<Product>
    + filterMouse(brandId: Integer, purpose: String, connectivity: String, dpi: String, price: String, sort: String, page: int, limit: int, search: String): List<Product>
    + filterGeneral(catId: int, brandId: Integer, price: String, sort: String, page: int, limit: int, search: String): List<Product>
    + countFilteredLaptop(...): int
    + countFilteredKeyboard(...): int
    + countFilteredMouse(...): int
    + countFilteredGeneral(...): int
}

class CategoryDAO {
    + getCategoryIdByName(name: String): Integer
    + getAllCategories(): List<Category>
}

class BrandDao {
    + getBrandsByCategory(catId: int): List<Brand>
}

class ProductListServlet {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- ProductDAO
DBContext <|-- ProductListFilterDAO
DBContext <|-- CategoryDAO
DBContext <|-- BrandDao
ProductListServlet ..> ProductDAO : <<use>>
ProductListServlet ..> ProductListFilterDAO : <<use>>
ProductListServlet ..> CategoryDAO : <<use>>
ProductListServlet ..> BrandDao : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Customer

boundary "product_list.jsp\n(View)" as View #lightyellow
control "ProductListServlet\n(Servlet)" as Servlet #lightgreen
entity "CategoryDAO\n(Repository)" as CatDAO #lightblue
entity "ProductDAO\n(Repository)" as ProdDAO #lightblue
entity "ProductListFilterDAO\n(Repository)" as FilterDAO #lightblue
entity "BrandDao\n(Repository)" as BrandDAO #lightblue
database "SQL Server" as DB #lightcyan

Customer -> View : 1 Select category, input search query, and choose filter criteria
View -> Servlet : 2 GET /ProductListServlet {search, category, brand, price, sort...}
activate Servlet

alt search is not empty but categoryId is null
    Servlet -> CatDAO : 3 getCategoryIdByName(search)
    activate CatDAO
    CatDAO --> Servlet : 4 categoryId (e.g. 1 for Laptop)
    deactivate CatDAO
    
    alt categoryId still null
        Servlet -> ProdDAO : 5 getCategoryIdByProductSearch(search)
        activate ProdDAO
        ProdDAO --> Servlet : 6 categoryId
        deactivate ProdDAO
    end
end

alt categoryId is null (Global Search across all categories)
    Servlet -> ProdDAO : 7 countSearchAllProducts(search)
    activate ProdDAO
    ProdDAO --> Servlet : 8 totalProducts
    deactivate ProdDAO
    Servlet -> ProdDAO : 9 searchAllProducts(search, page, pageSize)
    activate ProdDAO
    ProdDAO --> Servlet : 10 List<Product>
    deactivate ProdDAO
    Servlet -> View : 11 Forward to product_list.jsp (Global view)
else categoryId is not null (Category-specific filtering)
    alt categoryId == 1 (Laptop Category)
        Servlet -> ProdDAO : 12 countFilteredLaptop(...)
        activate ProdDAO
        ProdDAO --> Servlet : 13 totalProducts
        deactivate ProdDAO
        Servlet -> FilterDAO : 14 filterLaptop(...)
        activate FilterDAO
        FilterDAO --> Servlet : 15 List<Product>
        deactivate FilterDAO
    else categoryId == 3 (Keyboard Category)
        Servlet -> FilterDAO : 16 countFilteredKeyboard(...)
        activate FilterDAO
        FilterDAO --> Servlet : 17 totalProducts
        deactivate FilterDAO
        Servlet -> FilterDAO : 18 filterKeyboard(...)
        activate FilterDAO
        FilterDAO --> Servlet : 19 List<Product>
        deactivate FilterDAO
    else other categoryId (Mouse/General)
        Servlet -> FilterDAO : 20 filterGeneral(...)
        activate FilterDAO
        FilterDAO --> Servlet : 21 List<Product>
        deactivate FilterDAO
    end
    
    Servlet -> BrandDAO : 22 getBrandsByCategory(categoryId)
    activate BrandDAO
    BrandDAO --> Servlet : 23 List<Brand>
    deactivate BrandDAO
    
    Servlet -> CatDAO : 24 getAllCategories()
    activate CatDAO
    CatDAO --> Servlet : 25 List<Category>
    deactivate CatDAO
    
    Servlet -> View : 26 Forward products, categories, brands lists
end

deactivate Servlet
View --> Customer : 27 Render product listing page with grid layout
@enduml
```

---

### 3.2.3: Add Product

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class ProductDAO {
    + isSkuExist(sku: String): boolean
    + insertProduct(p: Product): int
    + insertProductVariant(prodId: int, sku: String, name: String, impPrice: BigDecimal, price: BigDecimal, stock: int): void
    + insertProductVariant(prodId: int, sku: String, name: String, impPrice: BigDecimal, price: BigDecimal, stock: int, thumbnail: String): void
}

class CategoryDAO {
    + getAllCategories(): List<Category>
}

class BrandDao {
    + getAllBrands(): List<Brand>
}

class Product {
    - productId: int
    - productName: String
    - description: String
    - thumbnail: String
    - categoryId: int
    - brandId: int
}

class AddProductController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
    # doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- ProductDAO
DBContext <|-- CategoryDAO
DBContext <|-- BrandDao
AddProductController ..> ProductDAO : <<use>>
AddProductController ..> CategoryDAO : <<use>>
AddProductController ..> BrandDao : <<use>>
AddProductController ..> Product : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "AddProduct.jsp\n(View)" as View #lightyellow
control "AddProductController\n(Servlet)" as Controller #lightgreen
entity "CategoryDAO\n(Repository)" as CatDAO #lightblue
entity "BrandDao\n(Repository)" as BrandDAO #lightblue
entity "ProductDAO\n(Repository)" as ProdDAO #lightblue
database "SQL Server" as DB #lightcyan

== Load Add Product Page (GET) ==
Staff -> View : 1 Click "Add Product" button
View -> Controller : 2 GET /staff/inventory/add
activate Controller
Controller -> CatDAO : 3 getAllCategories()
activate CatDAO
CatDAO --> Controller : 4 List<Category>
deactivate CatDAO
Controller -> BrandDAO : 5 getAllBrands()
activate BrandDAO
BrandDAO --> Controller : 6 List<Brand>
deactivate BrandDAO
Controller -> View : 7 Forward categories and brands to JSP
deactivate Controller
View --> Staff : 8 Display blank product form with categories/brands selection

== Save New Product (POST) ==
Staff -> View : 9 Fill product info, upload main thumbnail,\nadd multiple variants (SKU, prices) -> Click Submit
View -> Controller : 10 POST /staff/inventory/add {productName, categoryId, brandId, skus[], importPrices[], prices[], thumbnails...}
activate Controller

loop for each submitted variant SKU
    Controller -> ProdDAO : 11 isSkuExist(sku)
    activate ProdDAO
    ProdDAO --> Controller : 12 boolean (true/false)
    deactivate ProdDAO
    alt Sku already exists in DB
        Controller -> View : 13 Redirect to form with errorMessage
    end
end

Controller -> Controller : 14 Process main product thumbnail upload\nand save image to Disk
Controller -> ProdDAO : 15 insertProduct(product)
activate ProdDAO
ProdDAO -> DB : 16 INSERT INTO Product (product_name, description, category_id, brand_id, thumbnail)
activate DB
DB --> ProdDAO : 17 Generated productId
deactivate DB
ProdDAO --> Controller : 18 productId
deactivate ProdDAO

loop for each variant in the arrays
    Controller -> Controller : 19 Save variant-specific thumbnail if provided
    alt variant thumbnail is uploaded
        Controller -> ProdDAO : 20 insertProductVariant(productId, sku, name, importPrice, price, 0, varThumbnail)
        activate ProdDAO
        ProdDAO -> DB : 21 INSERT INTO ProductVariant (product_id, sku, variant_name, import_price, selling_price, stock_quantity, variant_thumbnail)
        activate DB
        DB --> ProdDAO : 22 Success
        deactivate DB
        ProdDAO --> Controller : 23 void
        deactivate ProdDAO
    else no variant thumbnail
        Controller -> ProdDAO : 24 insertProductVariant(productId, sku, name, importPrice, price, 0)
        activate ProdDAO
        ProdDAO -> DB : 25 INSERT INTO ProductVariant (product_id, sku, variant_name, import_price, selling_price, stock_quantity)
        activate DB
        DB --> ProdDAO : 26 Success
        deactivate DB
        ProdDAO --> Controller : 27 void
        deactivate ProdDAO
    end
end

Controller -> View : 28 Redirect to /staff/inventory (success)
deactivate Controller
@endl
@enduml
```

---

### 3.2.4: Edit Product

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class ProductDAO {
    + getProductByVariantId(variantId: int): Product
    + getProductVariantsByProductId(productId: int): List<ProductVariant>
    + updateProductVariant(variantId: int, sku: String, variantName: String, price: BigDecimal): void
}

class EditProductController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
    # doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- ProductDAO
EditProductController ..> ProductDAO : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "EditProduct.jsp\n(View)" as View #lightyellow
control "EditProductController\n(Servlet)" as Controller #lightgreen
entity "ProductDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

== Load Product Edit Form (GET) ==
Staff -> View : 1 Click Edit on a variant row
View -> Controller : 2 GET /staff/inventory/edit {variantId}
activate Controller
Controller -> DAO : 3 getProductByVariantId(variantId)
activate DAO
DAO -> DB : 4 SELECT * FROM Product WHERE variant_id = ?
activate DB
DB --> DAO : 5 Product Record
deactivate DB
DAO --> Controller : 6 Product object
deactivate DAO

Controller -> DAO : 7 getProductVariantsByProductId(productId)
activate DAO
DAO -> DB : 8 SELECT * FROM ProductVariant WHERE product_id = ?
activate DB
DB --> DAO : 9 List of variant records
deactivate DB
DAO --> Controller : 10 List<ProductVariant>
deactivate DAO

Controller -> View : 11 Forward product, variants, and selectedVariantId to JSP
deactivate Controller
View --> Staff : 12 Display Edit form pre-populated with details

== Save Updated Variant (POST) ==
Staff -> View : 13 Edit SKU, variantName, and selling price -> Click Save
View -> Controller : 14 POST /staff/inventory/edit {action: "updateVariant", variantId, sku, variantName, price}
activate Controller
Controller -> DAO : 15 updateProductVariant(variantId, sku, variantName, price)
activate DAO
DAO -> DB : 16 UPDATE ProductVariant SET sku = ?, variant_name = ?, selling_price = ? WHERE variant_id = ?
activate DB
DB --> DAO : 17 Success
deactivate DB
DAO --> Controller : 18 void
deactivate DAO
Controller -> View : 19 Redirect back to Edit page /staff/inventory/edit?variantId=variantId
deactivate Controller
@enduml
```

---

### 3.2.5: Manage Category

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class CategoryDAO {
    + getCategoriesPaginated(search: String, offset: int, fetchSize: int): List<Category>
    + getTotalCategoryCount(search: String): int
    + insertCategory(name: String): void
    + updateCategory(id: int, name: String): void
    + deleteCategory(id: int): void
    + isCategoryExist(name: String, excludeId: int): boolean
    + countProductsByCategory(id: int): int
}

class CategoryManagementController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
    # doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- CategoryDAO
CategoryManagementController ..> CategoryDAO : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "CategoryManagement.jsp\n(View)" as View #lightyellow
control "CategoryManagementController\n(Servlet)" as Controller #lightgreen
entity "CategoryDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

== View Category List with Searching & Paging (GET) ==
Staff -> View : 1 Open Category Menu / Input Search keyword
View -> Controller : 2 GET /staff/category {searchInput, page}
activate Controller
Controller -> DAO : 3 getTotalCategoryCount(searchInput)
activate DAO
DAO -> DB : 4 SELECT COUNT(*) FROM Category WHERE category_name LIKE ?
activate DB
DB --> DAO : 5 totalCategories count
deactivate DB
DAO --> Controller : 6 totalCategories
deactivate DAO

Controller -> DAO : 7 getCategoriesPaginated(searchInput, offset, pageSize)
activate DAO
DAO -> DB : 8 SELECT * FROM Category WHERE category_name LIKE ? ORDER BY category_id DESC OFFSET ... FETCH ...
activate DB
DB --> DAO : 9 Category records
deactivate DB
DAO --> Controller : 10 List<Category>
deactivate DAO

Controller -> View : 11 Forward categories, currentPage, and totalPages to JSP
deactivate Controller
View --> Staff : 12 Render category data table list

== Category Operations: Add/Update/Delete (POST) ==
Staff -> View : 13 Trigger action (Submit Add form / Click Save on Edit / Confirm Delete)
View -> Controller : 14 POST /staff/category {action, categoryName, categoryId, categoryIdToDelete}
activate Controller

alt action is "add"
    Controller -> DAO : 15 isCategoryExist(categoryName, -1)
    activate DAO
    DAO --> Controller : 16 boolean (true/false)
    deactivate DAO
    alt name is duplicate
        Controller -> View : 17 Forward with errorMessage "Tên danh mục đã tồn tại"
    else unique name
        Controller -> DAO : 18 insertCategory(categoryName)
        activate DAO
        DAO -> DB : 19 INSERT INTO Category (category_name) VALUES (?)
        activate DB
        DB --> DAO : 20 Success
        deactivate DB
        DAO --> Controller : 21 void
        deactivate DAO
    end
    
else action is "update"
    Controller -> DAO : 22 isCategoryExist(categoryName, categoryId)
    activate DAO
    DAO --> Controller : 23 boolean (true/false)
    deactivate DAO
    alt name is duplicate
        Controller -> View : 24 Forward with errorMessage "Tên danh mục đã tồn tại"
    else unique name
        Controller -> DAO : 25 updateCategory(categoryId, categoryName)
        activate DAO
        DAO -> DB : 26 UPDATE Category SET category_name = ? WHERE category_id = ?
        activate DB
        DB --> DAO : 27 Success
        deactivate DB
        DAO --> Controller : 28 void
        deactivate DAO
    end
    
else action is "delete"
    Controller -> DAO : 29 countProductsByCategory(categoryIdToDelete)
    activate DAO
    DAO -> DB : 30 SELECT COUNT(*) FROM Product WHERE category_id = ?
    activate DB
    DB --> DAO : 31 count
    deactivate DB
    DAO --> Controller : 32 productCount
    deactivate DAO
    
    alt productCount > 0
        Controller -> View : 33 Forward with error: Category is not empty
    else productCount == 0
        Controller -> DAO : 34 deleteCategory(categoryIdToDelete)
        activate DAO
        DAO -> DB : 35 DELETE FROM Category WHERE category_id = ?
        activate DB
        DB --> DAO : 36 Success
        deactivate DB
        DAO --> Controller : 37 void
        deactivate DAO
    end
end

Controller -> View : 38 Redirect to /staff/category (preserving search query)
deactivate Controller
@endl
@enduml
```

---

### 3.2.6: View IMEI Product List

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class ImeiDAO {
    + getInventoryItems(search: String, statusFilter: String, offset: int, fetchSize: int): List<InventoryItem>
    + getTotalInventoryItemsCount(search: String, statusFilter: String): int
    + getCountByStatus(status: String): int
}

class InventoryItem {
    - itemId: int
    - serialNumber: String
    - status: String
    - importDate: String
    - soldDate: LocalDate
    - warrantyExpiredDate: LocalDate
    - sku: String
    - variantName: String
    - productName: String
}

class ImeiManagement {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- ImeiDAO
ImeiManagement ..> ImeiDAO : <<use>>
ImeiManagement ..> InventoryItem : <<use>>
@uml
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "ImeiManagement.jsp\n(View)" as View #lightyellow
control "ImeiManagement\n(Servlet)" as Controller #lightgreen
entity "ImeiDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

Staff -> View : 1 Click "IMEI Management" / Filter status or search Serial
View -> Controller : 2 GET /staff/imei {searchInput, status, page}
activate Controller

Controller -> DAO : 3 getInventoryItems(searchInput, status, offset, pageSize)
activate DAO
DAO -> DB : 4 SELECT * FROM InventoryItem joined with Variant & Product details
activate DB
DB --> DAO : 5 ResultSet rows
deactivate DB
DAO --> Controller : 6 List<InventoryItem>
deactivate DAO

Controller -> DAO : 7 getTotalInventoryItemsCount(searchInput, status)
activate DAO
DAO --> Controller : 8 totalCount
deactivate DAO

Controller -> DAO : 9 getCountByStatus(null)
activate DAO
DAO --> Controller : 10 totalUnits count
deactivate DAO

Controller -> DAO : 11 getCountByStatus("in_stock")
activate DAO
DAO --> Controller : 12 inStockUnits count
deactivate DAO

Controller -> DAO : 13 getCountByStatus("sold")
activate DAO
DAO --> Controller : 14 soldUnits count
deactivate DAO

Controller -> View : 15 Forward items list, stats summary and search parameters
deactivate Controller
View --> Staff : 16 Render Serial/IMEI tables with status badges & stats counters
@endl
@enduml
```

---

### 3.2.7: Add Product IMEI

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class ImeiDAO {
    + insertInventoryItems(items: List<InventoryItem>): void
}

class TicketDAO {
    + getTicketDetails(ticketId: int): List<TicketDetail>
    + isTicketFullyImported(ticketId: int): boolean
    + updateTicketStatus(ticketId: int, status: String, reason: String): boolean
}

class ProductDAO {
    + getVariantById(id: int): ProductVariant
    + getProductByVariantId(id: int): Product
}

class AddProductImeiController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
    # doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- ImeiDAO
DBContext <|-- TicketDAO
DBContext <|-- ProductDAO
AddProductImeiController ..> ImeiDAO : <<use>>
AddProductImeiController ..> TicketDAO : <<use>>
AddProductImeiController ..> ProductDAO : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "AddProductImei.jsp\n(View)" as View #lightyellow
control "AddProductImeiController\n(Servlet)" as Controller #lightgreen
entity "TicketDAO\n(Repository)" as TDAO #lightblue
entity "ProductDAO\n(Repository)" as PDAO #lightblue
entity "ImeiDAO\n(Repository)" as IDAO #lightblue
database "SQL Server" as DB #lightcyan

== Load Serial Registration Form (GET) ==
Staff -> View : 1 Click "Register Serial/IMEI" on variant import row
View -> Controller : 2 GET /staff/imei/add {ticketId, variantId}
activate Controller

Controller -> TDAO : 3 getTicketDetails(ticketId)
activate TDAO
TDAO --> Controller : 4 List<TicketDetail> (identify expected quantity)
deactivate TDAO

Controller -> PDAO : 5 getVariantById(variantId)
activate PDAO
PDAO --> Controller : 6 ProductVariant details
deactivate PDAO

Controller -> PDAO : 7 getProductByVariantId(variantId)
activate PDAO
PDAO --> Controller : 8 Product details
deactivate PDAO

Controller -> View : 9 Forward ticketId, expectedQuantity, Product and Variant
deactivate Controller
View --> Staff : 10 Display dynamic text fields based on expected quantity

== Register Scanned Serials (POST) ==
Staff -> View : 11 Type/Scan serial numbers and receivedDate -> Click Submit
View -> Controller : 12 POST /staff/imei/add {variantId, ticketId, serialNumbers[], receivedDate}
activate Controller

alt serialNumbers quantity does not match expected quantity
    Controller -> View : 13 Redirect to page with error MismatchImeisQuantity
end

Controller -> IDAO : 14 insertInventoryItems(itemsList)
activate IDAO
IDAO -> DB : 15 Check if any serial number is duplicate in DB
activate DB
DB --> IDAO : 16 Count (0)
deactivate DB

IDAO -> DB : 17 START TRANSACTION\nINSERT INTO InventoryItem (variant_id, serial_number, status, import_date, warranty_expired_date, ticket_id) VALUES (?, ?, ?, ?, ?, ?)\nUPDATE [Inventory] SET available_quantity = available_quantity + ? WHERE variant_id = ?\nCOMMIT
activate DB
DB --> IDAO : 18 Transaction success
deactivate DB
IDAO --> Controller : 19 void
deactivate IDAO

alt ticketId is provided (part of Ticket Inbound cargo receipt)
    Controller -> TDAO : 20 isTicketFullyImported(ticketId)
    activate TDAO
    TDAO -> DB : 21 SELECT count of variants not fully imported in this ticket
    activate DB
    DB --> TDAO : 22 Count (0 if fully imported)
    deactivate DB
    TDAO --> Controller : 23 true / false
    deactivate TDAO
    
    alt ticket is fully imported
        Controller -> TDAO : 24 updateTicketStatus(ticketId, "COMPLETED", reason)
        activate TDAO
        TDAO -> DB : 25 UPDATE Ticket SET status = 'COMPLETED' WHERE ticket_id = ?
        activate DB
        DB --> TDAO : 26 Success
        deactivate DB
        TDAO --> Controller : 27 true
        deactivate TDAO
        Controller -> View : 28 Redirect to workflow page with success message: InboundCompleted
    else ticket is partially imported (other variants waiting)
        Controller -> View : 29 Redirect to workflow page with success message: VariantImported
    end
else ticketId is null (stand-alone IMEI addition)
    Controller -> View : 30 Redirect to /staff/imei with success message: Added
end

deactivate Controller
@enduml
```

---

## 2. Section 3.7 & 3.8: Outbound Management

### 3.7.1: View Pending Orders

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class OutboundDAO {
    + getPendingOrders(offset: int, limit: int): List<Order>
    + getTotalPendingOrders(): int
    + getOrderById(orderId: int): Order
    + getOrderDetails(orderId: int): List<OrderDetail>
}

class Order {
    - orderId: int
    - totalAmount: BigDecimal
    - shippingFee: BigDecimal
    - orderStatus: String
    - shippingReceiver: String
    - shippingPhone: String
    - shippingAddress: String
    - orderCode: String
    - userId: Integer
    - trackingNumber: String
    - shippingPartner: String
    + getOrderId(): int
    + getOrderStatus(): String
    + getOrderCode(): String
}

class OutboundListController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

DBContext <|-- OutboundDAO
OutboundListController ..> OutboundDAO : <<use>>
OutboundListController ..> Order : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "OrderList.jsp\n(View)" as View #lightyellow
control "OutboundListController\n(Servlet)" as Controller #lightgreen
entity "OutboundDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

Staff -> View : 1 Access Outbound list
View -> Controller : 2 GET /staff/outbound/list {page}
activate Controller

Controller -> DAO : 3 getTotalPendingOrders()
activate DAO
DAO -> DB : 4 SELECT COUNT(*) FROM [Order] WHERE order_status IN ('pending', 'processing')
activate DB
DB --> DAO : 5 count
deactivate DB
DAO --> Controller : 6 totalRecords (e.g., 25)
deactivate DAO

Controller -> DAO : 7 getPendingOrders(offset, pageSize)
activate DAO
DAO -> DB : 8 SELECT * FROM [Order] WHERE order_status IN ('pending', 'processing')\nORDER BY completed_at OFFSET ... FETCH ...
activate DB
DB --> DAO : 9 Order records
deactivate DB
DAO --> Controller : 10 List<Order>
deactivate DAO

Controller -> View : 11 Forward with list of orders, page, totalPages
deactivate Controller
View --> Staff : 12 Render pending order queue table view
@enduml
```

---

### 3.7.2: Assign Serial/IMEI & Fulfill Order

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class OutboundDAO {
    + getOrderById(orderId: int): Order
    + getOrderDetails(orderId: int): List<OrderDetail>
    + getAvailableImeisForVariant(variantId: int): List<InventoryItem>
    + executeOutboundTransaction(orderId: int, orderDetailToItemIds: Map<Integer, List<Integer>>): boolean
}

class OutboundFulfillController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
    # doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

class OrderDetail {
    - orderDetailId: int
    - quantity: int
    - unitPrice: BigDecimal
    - orderId: int
    - variantId: int
    - variantName: String
    - sku: String
}

DBContext <|-- OutboundDAO
OutboundFulfillController ..> OutboundDAO : <<use>>
OutboundFulfillController ..> OrderDetail : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "OrderFulfillment.jsp\n(View)" as View #lightyellow
control "OutboundFulfillController\n(Servlet)" as Controller #lightgreen
entity "OutboundDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

Staff -> View : 1 Click Fulfill on order row
View -> Controller : 2 GET /staff/outbound/fulfill {orderId}
activate Controller

Controller -> DAO : 3 getOrderById(orderId)
activate DAO
DAO -> DB : 4 SELECT * FROM [Order] WHERE order_id = ?
activate DB
DB --> DAO : 5 Order Record
deactivate DB
DAO --> Controller : 6 Order object
deactivate DAO

Controller -> DAO : 7 getOrderDetails(orderId)
activate DAO
DAO -> DB : 8 SELECT * FROM [OrderDetail] WHERE order_id = ?
activate DB
DB --> DAO : 9 OrderDetail records
deactivate DB
DAO --> Controller : 10 List<OrderDetail>
deactivate DAO

loop for each OrderDetail
    Controller -> DAO : 11 getAvailableImeisForVariant(variantId)
    activate DAO
    DAO -> DB : 12 SELECT item_id, serial_number FROM [InventoryItem] WHERE variant_id = ? AND status = 'in_stock'
    activate DB
    DB --> DAO : 13 List of available Serial items
    deactivate DB
    DAO --> Controller : 14 List<InventoryItem>
    deactivate DAO
end

Controller -> View : 15 Forward to OrderFulfillment.jsp with order details & available Serials
deactivate Controller

Staff -> View : 16 Select matching Serials for each product and submit
View -> Controller : 17 POST /staff/outbound/fulfill {orderId, detail_xxxx[]}
activate Controller

Controller -> DAO : 18 executeOutboundTransaction(orderId, orderDetailToItemIds)
activate DAO
DAO -> DB : 19 START TRANSACTION
activate DB

loop for each selected serial item ID
    DAO -> DB : 20 UPDATE InventoryItem SET status = 'sold', sold_date = GETDATE() WHERE item_id = ? AND status = 'in_stock'
    DB --> DAO : 21 Success (affected row > 0)
    
    DAO -> DB : 22 INSERT INTO OrderItemSerial (order_detail_id, item_id, assigned_at) VALUES (?, ?, GETDATE())
    DB --> DAO : 23 Success
end

DAO -> DB : 24 UPDATE [Order] SET order_status = 'shipped' WHERE order_id = ?
DB --> DAO : 25 Success

DAO -> DB : 26 COMMIT TRANSACTION
DB --> DAO : 27 Transaction Committed
deactivate DB
DAO --> Controller : 28 boolean (true)
deactivate DAO

Controller -> View : 29 Redirect to Print controller (/staff/outbound/print?orderId=...)
deactivate Controller
@enduml
```

---

### 3.7.3: Print Invoice Slip

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class OutboundPrintController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

class OutboundDAO {
    + getOrderById(orderId: int): Order
    + getOrderDetails(orderId: int): List<OrderDetail>
    + getAssignedImeisForOrderDetail(orderDetailId: int): List<InventoryItem>
}

DBContext <|-- OutboundDAO
OutboundPrintController ..> OutboundDAO : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "DeliverySlip.jsp\n(View)" as View #lightyellow
control "OutboundPrintController\n(Servlet)" as Controller #lightgreen
entity "OutboundDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

Staff -> View : 1 Select to print slip / Redirected from fulfillment
View -> Controller : 2 GET /staff/outbound/print {orderId}
activate Controller

Controller -> DAO : 3 getOrderById(orderId)
activate DAO
DAO -> DB : 4 SELECT * FROM [Order] WHERE order_id = ?
activate DB
DB --> DAO : 5 Order Record
deactivate DB
DAO --> Controller : 6 Order object
deactivate DAO

Controller -> DAO : 7 getOrderDetails(orderId)
activate DAO
DAO -> DB : 8 SELECT * FROM [OrderDetail] WHERE order_id = ?
activate DB
DB --> DAO : 9 OrderDetail records
deactivate DB
DAO --> Controller : 10 List<OrderDetail>
deactivate DAO

loop for each OrderDetail
    Controller -> DAO : 11 getAssignedImeisForOrderDetail(orderDetailId)
    activate DAO
    DAO -> DB : 12 SELECT ii.item_id, ii.serial_number FROM InventoryItem ii\nJOIN OrderItemSerial ois ON ii.item_id = ois.item_id\nWHERE ois.order_detail_id = ?
    activate DB
    DB --> DAO : 13 Assigned Serial items records
    deactivate DB
    DAO --> Controller : 14 List<InventoryItem>
    deactivate DAO
end

Controller -> View : 15 Forward to DeliverySlip.jsp (Renders invoice & serials for print)
deactivate Controller
@enduml
```

---

### 3.7.4: View Outbound History

#### Class Diagram:
```plantuml
@startuml
skinparam classAttributeIconSize 0
skinparam ClassBackgroundColor #ffffff
skinparam ClassBorderColor #1a1a1a

class DBContext {
    # connection: Connection
}

class OutboundHistoryController {
    # doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

class OutboundDAO {
    + getOutboundHistory(offset: int, limit: int): List<Order>
    + getTotalOutboundHistory(): int
}

DBContext <|-- OutboundDAO
OutboundHistoryController ..> OutboundDAO : <<use>>
@enduml
```

#### Sequence Diagram:
```plantuml
@startuml
skinparam Style strictuml
skinparam SequenceMessageAlign center

actor Staff

boundary "OrderHistory.jsp\n(View)" as View #lightyellow
control "OutboundHistoryController\n(Servlet)" as Controller #lightgreen
entity "OutboundDAO\n(Repository)" as DAO #lightblue
database "SQL Server" as DB #lightcyan

Staff -> View : 1 Access Outbound History page
View -> Controller : 2 GET /staff/outbound/history {page}
activate Controller

Controller -> DAO : 3 getTotalOutboundHistory()
activate DAO
DAO -> DB : 4 SELECT COUNT(*) FROM [Order] WHERE order_status IN ('shipped', 'delivered', 'cancelled')
activate DB
DB --> DAO : 5 count
deactivate DB
DAO --> Controller : 6 totalRecords
deactivate DAO

Controller -> DAO : 7 getOutboundHistory(offset, pageSize)
activate DAO
DAO -> DB : 8 SELECT * FROM [Order] WHERE order_status IN ('shipped', 'delivered', 'cancelled')\nORDER BY completed_at DESC OFFSET ... FETCH ...
activate DB
DB --> DAO : 9 Order records
deactivate DB
DAO --> Controller : 10 List<Order>
deactivate DAO

Controller -> View : 11 Forward with list of orders, page, totalPages to OrderHistory.jsp
deactivate Controller
View --> Staff : 12 Render outbound history records table view
@enduml
```
