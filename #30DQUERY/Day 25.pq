 let
	Source = Sql.Databases("localhost"),
	WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
	Dimension_Supplier = WideWorldImportersDW{[Schema = "Dimension", Item = "Supplier"]}[Data],
	#"Expanded Fact.Transaction" = Table.ExpandTableColumn(
		Dimension_Supplier, 
		"Fact.Transaction", 
		{"Is Finalized"}, 
		{"Is Finalized"}
	),
	#"Filtered Rows" = Table.SelectRows(
		#"Expanded Fact.Transaction", 
		each ([Is Finalized] = false) and [Supplier] <> "Unknown"
	),
	#"Added Custom" = Table.AddColumn(
		#"Filtered Rows", 
		"Supplier Key Reference", 
		each Text.From([Supplier Key]) & "-" & [Supplier Reference], 
		type text
	),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Added Custom", 
		{"Supplier Key Reference", "Supplier", "Category", "Primary Contact"}
	)
in
	#"Removed Other Columns"
