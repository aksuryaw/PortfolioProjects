-- DIM_Products table cleaning
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