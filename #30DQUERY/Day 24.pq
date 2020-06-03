let
	Source = Sql.Databases("localhost"),
	WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
	#"Dimension_Transaction Type" = WideWorldImportersDW{[Schema = "Dimension", Item
		= "Transaction Type"]}[Data],
	#"Second Letter" = List.Select(
		#"Dimension_Transaction Type"[Transaction Type], 
		each List.Contains({"a", "e", "i", "o", "u", "y", "w"}, Text.Range(_, 1, 1), Comparer.Ordinal)
	),
	#"Filtered Rows" = Table.SelectRows(
		#"Dimension_Transaction Type", 
		each List.Contains(#"Second Letter", [Transaction Type])
	),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Filtered Rows", 
		{"Transaction Type Key", "Transaction Type"}
	)
in
	#"Removed Other Columns"
