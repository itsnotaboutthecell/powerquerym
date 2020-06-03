let
	Source = Sql.Databases("localhost"),
	WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
	Fact_Sale = WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data],
	#"Expanded Dimension.Customer(Bill To Customer Key)" = Table.ExpandRecordColumn(
		Fact_Sale, 
		"Dimension.Customer(Customer Key)", 
		{"Bill To Customer"}, 
		{"Bill To Customer"}
	),
	#"Added Conditional Column" = Table.AddColumn(
		#"Expanded Dimension.Customer(Bill To Customer Key)", 
		"Sort", 
		each if [Bill To Customer] = "N/A" then 0 else 1
	),
	#"Sorted Rows" = Table.Sort(
		#"Added Conditional Column", 
		{{"Sort", Order.Descending}, {"Bill To Customer", Order.Ascending}}
	),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Sorted Rows", 
		{"Sale Key", "Salesperson Key", "Description", "Bill To Customer"}
	)
in
	#"Removed Other Columns"
