/* DIM_DateTable cleaning */
-- excluded unnecessary columns, renamed columns, created new column 'MonthShort'
SELECT 
  [DateKey], 
  [FullDateAlternateKey] AS Date,
  --,[DayNumberOfWeek]
  [EnglishDayNameOfWeek] AS Day, 
  --,[SpanishDayNameOfWeek]
  --,[FrenchDayNameOfWeek]
  --,[DayNumberOfMonth]
  --,[DayNumberOfYear]
  [WeekNumberOfYear]AS WeekNumber, 
  [EnglishMonthName]AS Month,
  LEFT([EnglishMonthName], 3) AS MonthShort,
  --,[SpanishMonthName]
  --,[FrenchMonthName]
  [MonthNumberOfYear] AS MonthNumber, 
  [CalendarQuarter] AS Quarter, 
  [CalendarYear] AS Year 
  --,[CalendarSemester]
  --,[FiscalQuarter]
  --,[FiscalYear]
  -- ,[FiscalSemester]
FROM 
  [AdventureWorksDW2019].[dbo].[DimDate]
WHERE 
  CalendarYear >= 2019

/* DIM_Customers Table cleaning */
-- excluded relevant columns, renamed columns
-- joined in customer city from geography table 
SELECT 
  c.customerkey AS CustomerKey, 
  --,[GeographyKey]
  --,[CustomerAlternateKey]
  --,[Title]
  c.firstname AS [FirstName], 
  --,[MiddleName]
  c.lastname AS [LastName], 
  c.firstname + ' ' + c.lastname AS [Full Name], 
  --,[NameStyle]
  --,[BirthDate]
  --,[MaritalStatus]
  --,[Suffix]
  CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS [Gender], -- change values in the Gender column
  --,[EmailAddress]
  --,[YearlyIncome]
  --,[TotalChildren]
  --,[NumberChildrenAtHome]
  --,[EnglishEducation]
  --,[SpanishEducation]
  --,[FrenchEducation]
  --,[EnglishOccupation]
  --,[SpanishOccupation]
  --,[FrenchOccupation]
  --,[HouseOwnerFlag]
  --,[NumberCarsOwned]
  --,[AddressLine1]
  --,[AddressLine2]
  --,[Phone]
  c.datefirstpurchase AS [DateFirstPurchase], 
  --,[CommuteDistance]
  g.city AS CustomerCity 
FROM 
  [AdventureWorksDW2019].[dbo].[DimCustomer] AS c 
  LEFT JOIN AdventureWorksDW2019.dbo.DimGeography AS g ON c.geographykey = g.geographykey 
ORDER BY 
  CustomerKey

/* DIM_Products table cleaning */
-- commented out irrelevant columns and renamed columns 
-- did two LEFT JOINs to bring in product category and subcategory names 
SELECT 
  p.[ProductKey], 
  p.[ProductAlternateKey] AS ProductItemCode,
  --,[ProductSubcategoryKey]
  --,[WeightUnitMeasureCode]
  --,[SizeUnitMeasureCode]
  p.[EnglishProductName] AS ProductName, 
  ps.EnglishProductSubCategoryName AS SubCategory, 
  pc.EnglishProductCategoryName AS ProductCategory,
  --,[SpanishProductName]
  --,[FrenchProductName]
  --,[StandardCost]
  --,[FinishedGoodsFlag]
  p.[Color] AS ProductColor,
  --,[SafetyStockLevel]
  --,[ReorderPoint]
  --,[ListPrice]
  p.[Size] AS ProductSize,
  --,[SizeRange]
  --,[Weight]
  --,[DaysToManufacture]
  p.[ProductLine],
  --,[DealerPrice]
  --,[Class]
  --,[Style]
  p.[ModelName] AS ProductModelName,
  --,[LargePhoto]
  p.[EnglishDescription] AS ProductDescription, 
  --,[FrenchDescription]
  --,[ChineseDescription]
  --,[ArabicDescription]
  --,[HebrewDescription]
  --,[ThaiDescription]
  --,[GermanDescription]
  --,[JapaneseDescription]
  --,[TurkishDescription]
  --,[StartDate]
  --,[EndDate]
  ISNULL(p.Status, 'OutDated') AS ProductStatus -- NULLs in p.Status will be given the value 'OutDated'
FROM 
  [AdventureWorksDW2019].[dbo].[DimProduct] AS p 
  LEFT JOIN AdventureWorksDW2019.dbo.DimProductSubcategory AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey 
  LEFT JOIN AdventureWorksDW2019.dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY 
  p.ProductKey

/* FACT_InternetSales table cleaning */
-- excluded irrelevant columns 
SELECT 
  [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey], 
  --,[PromotionKey]
  --,[CurrencyKey]
  --,[SalesTerritoryKey]
  [SalesOrderNumber], 
  --,[SalesOrderLineNumber]
  --,[RevisionNumber]
  --,[OrderQuantity]
  --,[UnitPrice]
  --,[ExtendedAmount]
  --,[UnitPriceDiscountPct]
  --,[DiscountAmount]
  --,[ProductStandardCost]
  --,[TotalProductCost]
  [SalesAmount] 
  --,[TaxAmt]
  --,[Freight]
  --,[CarrierTrackingNumber]
  --,[CustomerPONumber]
  --,[OrderDate]
  --,[DueDate]
  --,[ShipDate]
FROM 
  [AdventureWorksDW2019].[dbo].[FactInternetSales] 
WHERE 
  LEFT(OrderDateKey, 4) >= YEAR(GETDATE()) - 2 -- ensures we always only bring in two years of date from extraction 
ORDER BY 
  OrderDateKey