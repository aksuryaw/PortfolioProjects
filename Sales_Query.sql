/* DIM_Calendar Table */

SELECT 
  [DateKey], 
  [FullDateAlternateKey] AS Date,
  [EnglishDayNameOfWeek] AS Day, 
  [WeekNumberOfYear]AS WeekNumber, 
  [EnglishMonthName]AS Month,
  LEFT([EnglishMonthName], 3) AS MonthShort,
  [MonthNumberOfYear] AS MonthNumber, 
  [CalendarQuarter] AS Quarter, 
  [CalendarYear] AS Year 
FROM 
  [AdventureWorksDW2019].[dbo].[DimDate]
WHERE 
  CalendarYear >= 2019

/* DIM_Customers Table */

SELECT 
  c.customerkey AS CustomerKey, 
  c.firstname AS [FirstName], 
  c.lastname AS [LastName], 
  c.firstname + ' ' + c.lastname AS [Full Name], 
  CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS [Gender], -- change values in the Gender column
  c.datefirstpurchase AS [DateFirstPurchase], 
  g.city AS CustomerCity 
FROM 
  [AdventureWorksDW2019].[dbo].[DimCustomer] AS c 
  LEFT JOIN AdventureWorksDW2019.dbo.DimGeography AS g ON c.geographykey = g.geographykey 
ORDER BY 
  CustomerKey

/* DIM_Products Table */

SELECT 
  p.[ProductKey], 
  p.[ProductAlternateKey] AS ProductItemCode,
  p.[EnglishProductName] AS ProductName, 
  ps.EnglishProductSubCategoryName AS SubCategory, 
  pc.EnglishProductCategoryName AS ProductCategory,
  p.[Color] AS ProductColor,
  p.[Size] AS ProductSize,
  p.[ProductLine],
  p.[ModelName] AS ProductModelName,
  p.[EnglishDescription] AS ProductDescription, 
  ISNULL(p.Status, 'OutDated') AS ProductStatus -- NULLs in p.Status will be given the value 'OutDated'
FROM 
  [AdventureWorksDW2019].[dbo].[DimProduct] AS p 
  LEFT JOIN AdventureWorksDW2019.dbo.DimProductSubcategory AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey 
  LEFT JOIN AdventureWorksDW2019.dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY 
  p.ProductKey

/* FACT_InternetSales Table */

SELECT 
  [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey], 
  [SalesOrderNumber], 
  [SalesAmount] 
FROM 
  [AdventureWorksDW2019].[dbo].[FactInternetSales] 
WHERE 
  LEFT(OrderDateKey, 4) >= YEAR(GETDATE()) - 2 -- ensures we always only bring in two years of date from extraction 
ORDER BY 
  OrderDateKey
