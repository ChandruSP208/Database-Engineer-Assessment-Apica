CREATE TABLE Customers (
    [CustomerID] INT PRIMARY KEY IDENTITY(1,1),
    [FirstName] NVARCHAR(100) NOT NULL,
    [LastName] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(255) NOT NULL UNIQUE,
    [PasswordHash] NVARCHAR(255) NOT NULL,
    [Address] NVARCHAR(MAX) NULL,
    [City] NVARCHAR(100) NULL,
    [State] NVARCHAR(100) NULL,
    [Country] NVARCHAR(100) NULL,
    [PostalCode] NVARCHAR(20) NULL,
    [CreatedDate] DATETIME DEFAULT GETDATE(),
    [UpdatedDate] DATETIME NULL
) ON [PRIMARY]

CREATE UNIQUE INDEX IX_Customers_Email ON Customers ([Email])
ALTER TABLE Customers ADD 
CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED  ([CustomerID]) ON [PRIMARY]
GO

-----------------------------------------------------------------------------------------------

CREATE TABLE Categories (
    [CategoryID] INT PRIMARY KEY IDENTITY(1,1),
    [CategoryName] NVARCHAR(255) NOT NULL,
    [Description] NVARCHAR(MAX) NULL,
    [CreatedDate] DATETIME DEFAULT GETDATE(),
    [UpdatedDate] DATETIME NULL
) ON [PRIMARY]

CREATE UNIQUE INDEX IX_Categories_Name ON Categories ([CategoryName]);
ALTER TABLE Categories ADD
CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryID]) ON [PRIMARY]
GO

-----------------------------------------------------------------------------------------------


CREATE TABLE Products (
    [ProductID] INT PRIMARY KEY IDENTITY(1,1),
    [ProductName] NVARCHAR(100),
    [Description] NVARCHAR(200),
    [BasePrice] DECIMAL(10,2) NOT NULL CHECK (BasePrice > 0),
    [Quantity] INT NOT NULL DEFAULT 0,
    [CategoryID] INT,
    [CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Product_CreatedDate] DEFAULT (getutcdate()),
    [IsArchived] [bit] NOT NULL CONSTRAINT [DF_Product_IsArchived] DEFAULT ((0)),
    [ArchivedDate] [datetime] NULL,
    [IsDeleted] [bit] NOT NULL CONSTRAINT [DF_Product_IsDeleted] DEFAULT ((0)),
    [DeletedDate] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE Products ADD 
CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED  ([ProductID]) ON [PRIMARY]
GO
CREATE UNIQUE INDEX IX_Products_Name ON Products ([ProductName]);
GO
ALTER TABLE Products ADD 
CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)

-----------------------------------------------------------------------------------------------


CREATE TABLE ProductCategories (
    [ProductID] INT NOT NULL,
    [CategoryID] INT NOT NULL,
    CONSTRAINT [PK_ProductCategories] PRIMARY KEY CLUSTERED ([ProductID], [CategoryID]) ON [PRIMARY],
    CONSTRAINT [FK_ProductCategories_Products] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products]([ProductID]) ON DELETE CASCADE,
    CONSTRAINT [FK_ProductCategories_Categories] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Categories]([CategoryID]) ON DELETE CASCADE
) ON [PRIMARY]
GO



-----------------------------------------------------------------------------------------------

CREATE TABLE OrderStatuses (
    [StatusID] INT PRIMARY KEY IDENTITY(1,1),
    [StatusName] NVARCHAR(100) NOT NULL
) ON [PRIMARY]

----------------------------------------------------------------------------------------------

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL,
    [StatusID] INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    UpdatedDate DATETIME NULL
) ON [PRIMARY] 
ALTER TABLE Orders ADD 
CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED  ([OrderID]) ON [PRIMARY]
GO
ALTER TABLE Orders ADD 
CONSTRAINT [FK_Orders_Customers] FOREIGN KEY (CustomerID) REFERENCES Customers([CustomerID]) ON DELETE CASCADE
GO
ALTER TABLE Orders ADD 
CONSTRAINT [FK_Orders_Statuses] FOREIGN KEY (StatusID) REFERENCES OrderStatuses([StatusID]) ON DELETE CASCADE
GO


-----------------------------------------------------------------------------------------------


CREATE TABLE Order_Items (
    [OrderID] INT,
    [ProductID] INT,
    [Quantity] INT NOT NULL CHECK (Quantity > 0),
    [PriceAtOrder] DECIMAL(10, 2) NOT NULL CHECK (PriceAtOrder >= 0),
    CONSTRAINT FK_Order_OrderItem FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_Product_OrderItem FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
) ON [PRIMARY]
ALTER TABLE Order_Items ADD 
CONSTRAINT [PK_Order_Items] PRIMARY KEY CLUSTERED  ([OrderID], [ProductID]) ON [PRIMARY]
GO


-----------------------------------------------------------------------------------------------


CREATE TABLE Shipments (
    [ShipmentID] INT PRIMARY KEY IDENTITY(1,1),
    [OrderID] INT NOT NULL,
    [TrackingNumber] NVARCHAR(255) NOT NULL,
    [ShipmentDate] DATETIME DEFAULT GETDATE(),
	[ShippingMethod] NVARCHAR(100) NOT NULL,
    [UpdatedDate] DATETIME NULL
) ON [PRIMARY]
ALTER TABLE Shipments ADD 
CONSTRAINT [PK_ShipmentID] PRIMARY KEY CLUSTERED  ([ShipmentID]) ON [PRIMARY]
GO
ALTER TABLE Orders ADD 
CONSTRAINT [FK_Shipments_Orders] FOREIGN KEY ([OrderID]) REFERENCES Orders([OrderID])  ON DELETE CASCADE
