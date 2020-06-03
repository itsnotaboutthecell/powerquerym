let
	Source = Sql.Databases("localhost"),
	WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
	Fact_Order = WideWorldImportersDW{[Schema = "Fact", Item = "Order"]}[Data],
	#"Added Custom" = Table.AddColumn(
		Fact_Order, 
		"Category", 
		each if [Quantity] < 100 then "Less than 100" else 
			if [Quantity] >= 100 and [Quantity] <= 250
			then "Between 100 and 250"
			else "More than 250", 
		type text
	),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Added Custom", 
		{"Order Key", "Description", "Quantity", "Category"}
	)
in
	#"Removed Other Columns"
