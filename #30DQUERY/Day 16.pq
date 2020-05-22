let
	Source = Sql.Databases("localhost"),
	WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
	Fact_Sale
		= WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data][[Invoice Date Key],[Profit]],
	#"Custom: YYYMM" = Table.AddColumn(
		Fact_Sale, 
		"YYYYMM", 
		each Date.Year([Invoice Date Key]) * 100 + Date.Month([Invoice Date Key]), 
		Int64.Type
	),
	#"Custom: YYYYMM Offset" = Table.AddColumn(
		#"Custom: YYYMM", 
		"Offset", 
		each if Date.Month([Invoice Date Key]) = 12 then [YYYYMM] + 100 - 11 else [YYYYMM] + 1, 
		Int64.Type
	),
	#"Grouped Rows" = Table.Group(
		#"Custom: YYYYMM Offset", 
		{"YYYYMM", "Offset"}, 
		{{"Total Profit", each List.Sum([Profit]), Currency.Type}}, 
		GroupKind.Global
	),
	#"Merge Offsets" = Table.NestedJoin(
		#"Grouped Rows", 
		{"YYYYMM"}, 
		#"Grouped Rows", 
		{"Offset"}, 
		"Offset Results", 
		JoinKind.LeftOuter
	),
	#"Expanded Grouped Rows" = Table.ExpandTableColumn(
		#"Merge Offsets", 
		"Offset Results", 
		{"Total Profit"}, 
		{"Total Profit Offset"}
	),
	#"Change Percentage" = Table.AddColumn(
		#"Expanded Grouped Rows", 
		"Change Percentage", 
		each if [Total Profit Offset] = null then 0 else ([Total Profit] - [Total Profit Offset])
			/ [Total Profit Offset], 
		type number
	),
	#"Sorted Rows" = Table.Sort(#"Change Percentage", {{"YYYYMM", Order.Ascending}}),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Sorted Rows", 
		{"YYYYMM", "Total Profit", "Change Percentage"}
	)
in
	#"Removed Other Columns"
