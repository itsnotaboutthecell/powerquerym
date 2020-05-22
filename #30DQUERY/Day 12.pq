let
	Source = Sql.Databases("localhost"),
	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
	dbo_DimCustomer = AdventureWorksDW2017{[Schema = "dbo", Item = "DimGeography"]}[Data],
	#"Expanded DimCustomer" = Table.ExpandTableColumn(
		dbo_DimCustomer, 
		"DimCustomer", 
		{"FactInternetSales"}, 
		{"FactInternetSales"}
	),
	#"Expanded FactInternetSales" = Table.ExpandTableColumn(
		#"Expanded DimCustomer", 
		"FactInternetSales", 
		{"SalesAmount"}, 
		{"SalesAmount"}
	),
	#"Filtered Rows" = Table.SelectRows(#"Expanded FactInternetSales", each ([SalesAmount] = null)),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Filtered Rows", 
		{"City", "CountryRegionCode", "EnglishCountryRegionName"}
	),
	#"Removed Duplicates" = Table.Distinct(#"Removed Other Columns"),
	#"Sorted Rows" = Table.Sort(
		#"Removed Duplicates", 
		{{"CountryRegionCode", Order.Ascending}, {"City", Order.Ascending}}
	)
in
	#"Sorted Rows"
