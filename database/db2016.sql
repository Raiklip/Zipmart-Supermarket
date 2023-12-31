USE [ZipMart]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[categoryID] [int] IDENTITY(1,1) NOT NULL,
	[categoryName] [nvarchar](50) NULL,
	[restockThreshold] [int] NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[categoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[productID] [int] IDENTITY(1,1) NOT NULL,
	[warehouseID] [int] NOT NULL,
	[categoryID] [int] NOT NULL,
	[brandID] [int] NOT NULL,
	[supplierID] [int] NOT NULL,
	[productName] [nvarchar](255) NULL,
	[imageURL] [nvarchar](255) NULL,
	[unitPrice] [money] NULL,
	[quantity] [int] NULL,
	[quantitySold] [int] NULL,
	[quantityInStock] [int] NULL,
	[unit] [nvarchar](50) NULL,
	[newAdjustment] [int] NULL,
	[description] [varchar](max) NULL,
	[viewCount] [int] NULL,
	[discount] [int] NULL,
	[avaliable] [int] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[productID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[Products by Category]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Products by Category] AS
SELECT Categories.CategoryName, Products.ProductName, Products.quantity, Products.quantityInStock, Products.quantitySold, Categories.restockThreshold
FROM Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
--ORDER BY Categories.CategoryName, Products.ProductName
GO
/****** Object:  Table [dbo].[CreditCard]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CreditCard](
	[cardID] [int] IDENTITY(1,1) NOT NULL,
	[cardName] [nvarchar](255) NULL,
	[cardNumber] [varchar](16) NULL,
	[valueFrom] [datetime] NULL,
	[expirationDate] [datetime] NULL,
	[cvvNumber] [int] NULL,
	[cardType] [nvarchar](20) NULL,
 CONSTRAINT [PK_CreditCard] PRIMARY KEY CLUSTERED 
(
	[cardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[customerID] [int] IDENTITY(1,1) NOT NULL,
	[cardID] [int] NOT NULL,
	[accountID] [int] NULL,
	[fullname] [nvarchar](255) NULL,
	[address] [nvarchar](50) NULL,
	[phone] [nvarchar](50) NULL,
	[email] [nvarchar](255) NULL,
	[birthDate] [datetime] NULL,
	[imageURL] [nvarchar](255) NULL,
	[cardName] [nvarchar](255) NULL,
	[cardNumber] [varchar](16) NULL,
	[point] [bigint] NULL,
	[rank] [nvarchar](50) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[orderID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[employeeID] [int] NOT NULL,
	[orderDate] [datetime] NULL,
	[shipDate] [datetime] NULL,
	[shipAddress] [nvarchar](255) NULL,
	[note] [nvarchar](max) NULL,
	[status] [nvarchar](50) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[OrderByQuarter]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[OrderByQuarter] AS
SELECT
    OrderID,
    CustomerID,
    EmployeeID,
    OrderDate,
    ShipDate,
    ShipAddress,
    Note,
    Status,
    FullName,
    Address,
    Phone,
    Email,
    CardID,
    Point,
    Rank,
    CASE
        WHEN MONTH(OrderDate) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(OrderDate) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(OrderDate) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(OrderDate) BETWEEN 10 AND 12 THEN 'Q4'
        ELSE NULL
    END AS Quarter
FROM
    (
        -- Your existing join with Customers and CreditCard
        SELECT
            Orders.OrderID,
            Orders.CustomerID,
            Orders.EmployeeID,
            Orders.OrderDate,
            Orders.ShipDate,
            Orders.ShipAddress,
            Orders.Note,
            Orders.Status,
            Customers.FullName,
            Customers.Address,
            Customers.Phone,
            Customers.Email,
            Customers.CardID,
            Customers.Point,
            Customers.Rank
        FROM
            Customers
        INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
        INNER JOIN CreditCard ON Customers.CardID = CreditCard.CardID
    ) AS Subquery;

GO
/****** Object:  Table [dbo].[OrdersDetails]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdersDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[orderID] [int] NOT NULL,
	[productID] [int] NOT NULL,
	[unitPrice] [money] NULL,
	[quantity] [int] NULL,
	[discount] [int] NULL,
	[totalPrice] [money] NULL,
	[paymentMethod] [nvarchar](255) NULL,
	[cardName] [nvarchar](255) NULL,
	[cardNumber] [varchar](16) NULL,
 CONSTRAINT [PK_Order_Details] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[InvoiceView]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[InvoiceView] AS
SELECT
    O.orderID,
    O.customerID,
    O.employeeID,
    O.orderDate,
    O.shipDate,
    O.shipAddress,
    O.note,
    O.status,
    OD.productID,
	OD.unitPrice,
    OD.quantity,
    OD.discount,
    OD.totalPrice,
    OD.paymentMethod,
	C.cardName,
	C.cardNumber
FROM
    dbo.Orders AS O
JOIN
    dbo.OrdersDetails AS OD ON O.orderID = OD.orderID
INNER JOIN Customers AS C ON O.customerID = C.customerID;
GO
/****** Object:  View [dbo].[Order Subtotals]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Order Subtotals] AS
SELECT
    OD.OrderID,
    SUM(CONVERT(money, (P.unitPrice * OD.quantity * (1 - OD.Discount) / 100)) * 100) AS Subtotal
FROM
    dbo.OrdersDetails AS OD
JOIN
    dbo.Products AS P ON P.productID = OD.productID
GROUP BY
    OD.OrderID;
GO
/****** Object:  View [dbo].[Summary of Sales by Quarter]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Summary of Sales by Quarter] AS
SELECT Orders.ShipDate, Orders.OrderID, "Order Subtotals".Subtotal
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShipDate IS NOT NULL
--ORDER BY Orders.ShippedDate
GO
/****** Object:  View [dbo].[Sales Totals by Amount]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Sales Totals by Amount] AS
SELECT 
    SUM("Order Subtotals".Subtotal) AS SaleAmount, 
    Orders.OrderID, 
    Customers.fullname, 
    Orders.ShipDate,
    DATEPART(QUARTER, Orders.ShipDate) AS Quarter
FROM 
    Customers 
    INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
    INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE 
    ("Order Subtotals".Subtotal > 2500)
GROUP BY 
    Orders.OrderID, 
    Customers.fullname, 
    Orders.ShipDate, 
    DATEPART(QUARTER, Orders.ShipDate);
GO
/****** Object:  View [dbo].[Summary of Sales by Year]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Summary of Sales by Year] AS
SELECT Orders.ShipDate, Orders.OrderID, "Order Subtotals".Subtotal
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShipDate IS NOT NULL
--ORDER BY Orders.ShippedDate
GO
/****** Object:  View [dbo].[Orders Qry]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Orders Qry] AS
SELECT Orders.OrderID, Orders.CustomerID, Orders.EmployeeID, Orders.OrderDate, Orders.ShipDate, 
	Orders.ShipAddress, Orders.note, Orders.status,  
	Customers.fullname, Customers.Address, Customers.phone, Customers.email,
	CreditCard.cardName, CreditCard.cardNumber,CreditCard.cvvNumber,CreditCard.valueFrom,CreditCard.expirationDate,
	Customers.point,
	customers.rank
FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
INNER JOIN CreditCard ON Customers.cardID = CreditCard.cardID
GO
/****** Object:  View [dbo].[Products Above Average Price]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Products Above Average Price] AS
SELECT Products.ProductName, Products.UnitPrice
FROM Products
WHERE Products.UnitPrice>(SELECT AVG(UnitPrice) From Products)
--ORDER BY Products.UnitPrice DESC
GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts](
	[accountID] [int] IDENTITY(1,1) NOT NULL,
	[userName] [nvarchar](50) NULL,
	[password] [nvarchar](50) NULL,
	[hashedPassword] [varbinary](max) NULL,
	[permissionID] [int] NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED 
(
	[accountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BlogFeedBacks]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlogFeedBacks](
	[feedbackID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[title] [nvarchar](50) NULL,
	[content] [nvarchar](max) NULL,
	[date] [datetime] NULL,
 CONSTRAINT [PK_BlogFeedbacks] PRIMARY KEY CLUSTERED 
(
	[feedbackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Blogs]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Blogs](
	[blogID] [int] IDENTITY(1,1) NOT NULL,
	[employeeID] [int] NOT NULL,
	[title] [nvarchar](255) NULL,
	[imageURL] [nvarchar](255) NULL,
	[content] [nvarchar](max) NULL,
	[viewCount] [int] NULL,
 CONSTRAINT [PK_Feedback] PRIMARY KEY CLUSTERED 
(
	[blogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[branchID] [int] IDENTITY(1,1) NOT NULL,
	[companyName] [nvarchar](40) NULL,
	[branchName] [nvarchar](50) NULL,
	[address] [nvarchar](255) NULL,
	[city] [nvarchar](15) NULL,
	[phone] [nvarchar](24) NULL,
	[fax] [nvarchar](24) NULL,
	[postalCode] [nvarchar](10) NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[branchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Brand]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brand](
	[brandID] [int] IDENTITY(1,1) NOT NULL,
	[supplierID] [int] NOT NULL,
	[brandName] [nvarchar](255) NOT NULL,
	[address] [nvarchar](255) NULL,
 CONSTRAINT [PK_Brand] PRIMARY KEY CLUSTERED 
(
	[brandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[employeeID] [int] IDENTITY(1,1) NOT NULL,
	[accountID] [int] NOT NULL,
	[fullname] [nvarchar](50) NULL,
	[address] [nvarchar](255) NULL,
	[phone] [nvarchar](50) NULL,
	[email] [nvarchar](255) NULL,
	[birthDate] [datetime] NULL,
	[Notes] [nvarchar](max) NULL,
	[imageURL] [nvarchar](255) NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[employeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feedbacks]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedbacks](
	[feedbackID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[content] [nvarchar](max) NULL,
	[date] [datetime] NULL,
	[rate] [int] NULL,
 CONSTRAINT [PK_Feedback_Cus] PRIMARY KEY CLUSTERED 
(
	[feedbackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Import]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Import](
	[importID] [int] IDENTITY(1,1) NOT NULL,
	[supplierID] [int] NOT NULL,
	[brandID] [int] NOT NULL,
	[branchID] [int] NOT NULL,
	[categoryID] [int] NOT NULL,
	[companyName] [nvarchar](40) NULL,
	[dateImport] [datetime] NULL,
	[hsCode] [int] NULL,
	[nameProduct] [nvarchar](255) NULL,
	[amountDelivery] [int] NULL,
	[address] [nvarchar](255) NULL,
	[city] [nvarchar](15) NULL,
	[phone] [nvarchar](24) NULL,
	[fax] [nvarchar](24) NULL,
	[postalCode] [nvarchar](10) NULL,
	[description] [nvarchar](255) NULL,
	[status] [nvarchar](50) NULL,
	[leadtime] [int] NULL,
 CONSTRAINT [PK_Import] PRIMARY KEY CLUSTERED 
(
	[importID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InventoryStatus]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryStatus](
	[statusID] [int] IDENTITY(1,1) NOT NULL,
	[statusName] [nvarchar](50) NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[statusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Managers]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Managers](
	[managerID] [int] IDENTITY(1,1) NOT NULL,
	[accountID] [int] NOT NULL,
	[fullname] [nvarchar](50) NULL,
	[address] [nvarchar](255) NULL,
	[phone] [nvarchar](50) NULL,
	[email] [nvarchar](255) NULL,
 CONSTRAINT [PK_Managers] PRIMARY KEY CLUSTERED 
(
	[managerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Permission]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permission](
	[permissionID] [int] IDENTITY(1,1) NOT NULL,
	[permissionName] [nvarchar](50) NULL,
 CONSTRAINT [PK_Permission] PRIMARY KEY CLUSTERED 
(
	[permissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Suppliers]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Suppliers](
	[supplierID] [int] IDENTITY(1,1) NOT NULL,
	[companyName] [nvarchar](40) NULL,
	[contactName] [nvarchar](30) NULL,
	[contactTitle] [varchar](255) NULL,
	[address] [nvarchar](255) NULL,
	[city] [nvarchar](15) NULL,
	[postalCode] [nvarchar](10) NULL,
	[phone] [nvarchar](24) NULL,
	[fax] [nvarchar](24) NULL,
	[homePage] [nvarchar](max) NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED 
(
	[supplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ThresholdAdjustment]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThresholdAdjustment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[productID] [int] NOT NULL,
	[reasonAdjustment] [nvarchar](50) NULL,
	[new_restockThreshold] [int] NULL,
	[dateAdjusted] [datetime] NULL,
	[statusThresholdAdjustments] [nvarchar](50) NULL,
 CONSTRAINT [PK_Adjustment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Warehouse]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Warehouse](
	[warehouseID] [int] IDENTITY(1,1) NOT NULL,
	[companyName] [nvarchar](40) NULL,
	[warehouseName] [nvarchar](50) NULL,
	[address] [nvarchar](255) NULL,
	[city] [nvarchar](15) NULL,
	[phone] [nvarchar](24) NULL,
	[fax] [nvarchar](24) NULL,
	[postalCode] [nvarchar](10) NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_Warehouse] PRIMARY KEY CLUSTERED 
(
	[warehouseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_UnitPrice]  DEFAULT ((0)) FOR [unitPrice]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_AdjustmentThreshold]  DEFAULT ((0)) FOR [newAdjustment]
GO
ALTER TABLE [dbo].[Accounts]  WITH NOCHECK ADD  CONSTRAINT [FK_Accounts_Permission] FOREIGN KEY([permissionID])
REFERENCES [dbo].[Permission] ([permissionID])
GO
ALTER TABLE [dbo].[Accounts] CHECK CONSTRAINT [FK_Accounts_Permission]
GO
ALTER TABLE [dbo].[BlogFeedBacks]  WITH NOCHECK ADD  CONSTRAINT [FK_BlogFeedBack_Customer] FOREIGN KEY([customerID])
REFERENCES [dbo].[Customers] ([customerID])
GO
ALTER TABLE [dbo].[BlogFeedBacks] CHECK CONSTRAINT [FK_BlogFeedBack_Customer]
GO
ALTER TABLE [dbo].[Blogs]  WITH NOCHECK ADD  CONSTRAINT [FK_Blog_Employee] FOREIGN KEY([employeeID])
REFERENCES [dbo].[Employees] ([employeeID])
GO
ALTER TABLE [dbo].[Blogs] CHECK CONSTRAINT [FK_Blog_Employee]
GO
ALTER TABLE [dbo].[Brand]  WITH NOCHECK ADD  CONSTRAINT [FK_Brand_Supplier] FOREIGN KEY([supplierID])
REFERENCES [dbo].[Suppliers] ([supplierID])
GO
ALTER TABLE [dbo].[Brand] CHECK CONSTRAINT [FK_Brand_Supplier]
GO
ALTER TABLE [dbo].[Customers]  WITH NOCHECK ADD  CONSTRAINT [FK_Customer_Account] FOREIGN KEY([accountID])
REFERENCES [dbo].[Accounts] ([accountID])
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customer_Account]
GO
ALTER TABLE [dbo].[Customers]  WITH NOCHECK ADD  CONSTRAINT [FK_Customer_CreditCard] FOREIGN KEY([cardID])
REFERENCES [dbo].[CreditCard] ([cardID])
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customer_CreditCard]
GO
ALTER TABLE [dbo].[Employees]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_Account] FOREIGN KEY([accountID])
REFERENCES [dbo].[Accounts] ([accountID])
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employee_Account]
GO
ALTER TABLE [dbo].[Feedbacks]  WITH NOCHECK ADD  CONSTRAINT [FK_FeedBack_Customer] FOREIGN KEY([customerID])
REFERENCES [dbo].[Customers] ([customerID])
GO
ALTER TABLE [dbo].[Feedbacks] CHECK CONSTRAINT [FK_FeedBack_Customer]
GO
ALTER TABLE [dbo].[Import]  WITH NOCHECK ADD  CONSTRAINT [FK_Import_Branch] FOREIGN KEY([branchID])
REFERENCES [dbo].[Branch] ([branchID])
GO
ALTER TABLE [dbo].[Import] CHECK CONSTRAINT [FK_Import_Branch]
GO
ALTER TABLE [dbo].[Import]  WITH NOCHECK ADD  CONSTRAINT [FK_Import_Brand] FOREIGN KEY([brandID])
REFERENCES [dbo].[Brand] ([brandID])
GO
ALTER TABLE [dbo].[Import] CHECK CONSTRAINT [FK_Import_Brand]
GO
ALTER TABLE [dbo].[Import]  WITH NOCHECK ADD  CONSTRAINT [FK_Import_Category] FOREIGN KEY([categoryID])
REFERENCES [dbo].[Categories] ([categoryID])
GO
ALTER TABLE [dbo].[Import] CHECK CONSTRAINT [FK_Import_Category]
GO
ALTER TABLE [dbo].[Import]  WITH NOCHECK ADD  CONSTRAINT [FK_Import_Supplier] FOREIGN KEY([supplierID])
REFERENCES [dbo].[Suppliers] ([supplierID])
GO
ALTER TABLE [dbo].[Import] CHECK CONSTRAINT [FK_Import_Supplier]
GO
ALTER TABLE [dbo].[Managers]  WITH NOCHECK ADD  CONSTRAINT [FK_Manager_Accounts] FOREIGN KEY([accountID])
REFERENCES [dbo].[Accounts] ([accountID])
GO
ALTER TABLE [dbo].[Managers] CHECK CONSTRAINT [FK_Manager_Accounts]
GO
ALTER TABLE [dbo].[Orders]  WITH NOCHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([customerID])
REFERENCES [dbo].[Customers] ([customerID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
ALTER TABLE [dbo].[Orders]  WITH NOCHECK ADD  CONSTRAINT [FK_Orders_Employees] FOREIGN KEY([employeeID])
REFERENCES [dbo].[Employees] ([employeeID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Employees]
GO
ALTER TABLE [dbo].[OrdersDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_Details_Orders] FOREIGN KEY([orderID])
REFERENCES [dbo].[Orders] ([orderID])
GO
ALTER TABLE [dbo].[OrdersDetails] CHECK CONSTRAINT [FK_Order_Details_Orders]
GO
ALTER TABLE [dbo].[OrdersDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_Order_Details_Pro] FOREIGN KEY([productID])
REFERENCES [dbo].[Products] ([productID])
GO
ALTER TABLE [dbo].[OrdersDetails] CHECK CONSTRAINT [FK_Order_Details_Pro]
GO
ALTER TABLE [dbo].[Products]  WITH NOCHECK ADD  CONSTRAINT [FK_Products_Brands] FOREIGN KEY([brandID])
REFERENCES [dbo].[Brand] ([brandID])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Brands]
GO
ALTER TABLE [dbo].[Products]  WITH NOCHECK ADD  CONSTRAINT [FK_Products_Categories] FOREIGN KEY([categoryID])
REFERENCES [dbo].[Categories] ([categoryID])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories]
GO
ALTER TABLE [dbo].[Products]  WITH NOCHECK ADD  CONSTRAINT [FK_Products_InventoryStatus] FOREIGN KEY([avaliable])
REFERENCES [dbo].[InventoryStatus] ([statusID])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_InventoryStatus]
GO
ALTER TABLE [dbo].[Products]  WITH NOCHECK ADD  CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY([supplierID])
REFERENCES [dbo].[Suppliers] ([supplierID])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Suppliers]
GO
ALTER TABLE [dbo].[Products]  WITH NOCHECK ADD  CONSTRAINT [FK_Products_Warehouse] FOREIGN KEY([warehouseID])
REFERENCES [dbo].[Warehouse] ([warehouseID])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Warehouse]
GO
ALTER TABLE [dbo].[ThresholdAdjustment]  WITH NOCHECK ADD  CONSTRAINT [FK_Adjustment_WP] FOREIGN KEY([productID])
REFERENCES [dbo].[Products] ([productID])
GO
ALTER TABLE [dbo].[ThresholdAdjustment] CHECK CONSTRAINT [FK_Adjustment_WP]
GO
ALTER TABLE [dbo].[CreditCard]  WITH NOCHECK ADD  CONSTRAINT [CK_CardNumberFormat] CHECK  ((len([cardNumber])=(16) AND [cardNumber] like '[0-9][0-9][0-9][0-9] [0-9][0-9][0-9][0-9] [0-9][0-9][0-9][0-9] [0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[CreditCard] CHECK CONSTRAINT [CK_CardNumberFormat]
GO
ALTER TABLE [dbo].[CreditCard]  WITH NOCHECK ADD  CONSTRAINT [CK_cvvNumber] CHECK  ((len([cvvNumber])=(3) AND [cvvNumber] like '[0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[CreditCard] CHECK CONSTRAINT [CK_cvvNumber]
GO
ALTER TABLE [dbo].[Customers]  WITH NOCHECK ADD  CONSTRAINT [CK_Birthdate_Customer] CHECK  (([birthDate]<getdate()))
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [CK_Birthdate_Customer]
GO
ALTER TABLE [dbo].[Employees]  WITH NOCHECK ADD  CONSTRAINT [CK_Birthdate] CHECK  (([birthDate]<getdate()))
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [CK_Birthdate]
GO
ALTER TABLE [dbo].[OrdersDetails]  WITH NOCHECK ADD  CONSTRAINT [CK_Discount] CHECK  (([Discount]>=(0) AND [Discount]<=(50)))
GO
ALTER TABLE [dbo].[OrdersDetails] CHECK CONSTRAINT [CK_Discount]
GO
ALTER TABLE [dbo].[OrdersDetails]  WITH NOCHECK ADD  CONSTRAINT [CK_Quantity] CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[OrdersDetails] CHECK CONSTRAINT [CK_Quantity]
GO
ALTER TABLE [dbo].[Products]  WITH NOCHECK ADD  CONSTRAINT [CK_Products_UnitPrice] CHECK  (([unitPrice]>=(0)))
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [CK_Products_UnitPrice]
GO
ALTER TABLE [dbo].[Products]  WITH NOCHECK ADD  CONSTRAINT [CK_QuantityPro] CHECK  (([quantity]<=[quantityInStock] AND [quantitySold]<=[quantity]))
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [CK_QuantityPro]
GO
/****** Object:  StoredProcedure [dbo].[Sales by Year]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Sales by Year] 
	@Beginning_Date DateTime, @Ending_Date DateTime AS
SELECT Orders.ShipDate, Orders.OrderID, "Order Subtotals".Subtotal, DATENAME(yy,ShipDate) AS Year
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShipDate Between @Beginning_Date And @Ending_Date
GO
/****** Object:  StoredProcedure [dbo].[Ten Most Expensive Products]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Ten Most Expensive Products] AS
SET ROWCOUNT 10
SELECT Products.ProductName AS TenMostExpensiveProducts, Products.UnitPrice
FROM Products
ORDER BY Products.UnitPrice DESC
GO
/****** Object:  StoredProcedure [dbo].[TenBestSellerProducts]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TenBestSellerProducts]
AS
BEGIN
    SET ROWCOUNT 10;

    SELECT TOP 10
        Products.ProductName AS TenBestSellerProducts,
        Products.quantity
    FROM
        Products
    ORDER BY
        Products.quantity DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateTotalProductQuantities]    Script Date: 12/20/2023 12:29:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTotalProductQuantities]
AS
BEGIN
    UPDATE P
    SET P.quantity = 
        CASE 
            WHEN (P.quantity + P.quantityInStock) > C.restockThreshold THEN C.restockThreshold - P.quantityInStock
            ELSE CASE WHEN P.quantity > P.quantityInStock THEN P.quantityInStock ELSE P.quantity END
        END
    FROM dbo.Products P
    INNER JOIN dbo.Categories C ON P.categoryID = C.categoryID;
END
GO
