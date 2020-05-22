let
	Source = Sql.Databases("localhost"),
	WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
	#"Dimension_Stock Item" = WideWorldImportersDW{[Schema = "Dimension", Item = "Stock Item"]}[Data],
	#"Text Columns" = Table.ColumnsOfType(#"Dimension_Stock Item", {type nullable text}),
	#"Removed Other Columns" = Table.SelectColumns(#"Dimension_Stock Item", #"Text Columns")
in
	#"Removed Other Columns"
