let
	Source = Sql.Databases("localhost"),
	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
	dbo_FactResellerSales = AdventureWorksDW2017{[Schema = "dbo", Item = "FactResellerSales"]}[Data],
	#"Unix Conversion" = Table.AddColumn(
		dbo_FactResellerSales, 
		"UnixTimestamp", 
		each Duration.TotalSeconds([OrderDate] - #datetime(1970, 1, 1, 0, 0, 0)), 
		Int64.Type
	),
	#"Filtered Rows" = Table.SelectRows(
		#"Unix Conversion", 
		each not List.Contains({280..284}, [EmployeeKey])
	),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Filtered Rows", 
		{"SalesOrderNumber", "OrderDate", "ResellerKey", "EmployeeKey", "UnixTimestamp"}
	)
in
	#"Removed Other Columns"
