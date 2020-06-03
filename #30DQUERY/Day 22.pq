let
	Source = Sql.Databases("localhost"),
	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
	dbo_FactInternetSales = AdventureWorksDW2017{[Schema = "dbo", Item = "FactInternetSales"]}[Data],
	#"Previous 7 Years" = Table.SelectRows(
		dbo_FactInternetSales, 
		each Date.IsInPreviousNYears([ShipDate], 7)
	),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Previous 7 Years", 
		{"ProductKey", "SalesOrderNumber", "ShipDate", "SalesAmount"}
	),
	#"Changed Type" = Table.TransformColumnTypes(#"Removed Other Columns", {{"ShipDate", type date}})
in
	#"Changed Type"
