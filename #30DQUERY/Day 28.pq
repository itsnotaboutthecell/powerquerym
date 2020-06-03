let
	Source = Sql.Databases("localhost"),
	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
	dbo_DimProduct = AdventureWorksDW2017{[Schema = "dbo", Item = "DimProduct"]}[Data],
	#"Filtered Rows" = Table.SelectRows(dbo_DimProduct, each ([DealerPrice] <> null)),
	#"Calculated Sum" = List.Sum(#"Filtered Rows"[DealerPrice]),
	#"Divided Column" = Table.AddColumn(
		#"Filtered Rows", 
		"OverallPercentage", 
		each [DealerPrice] / #"Calculated Sum", 
		type number
	),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Divided Column", 
		{"ProductKey", "ProductAlternateKey", "EnglishProductName", "DealerPrice", "OverallPercentage"}
	)
in
	#"Removed Other Columns"
