let
	Source = Sql.Databases("localhost"),
	WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
	//
	Dimension_City
		= WideWorldImportersDW{[Schema = "Dimension", Item = "City"]}[Data][[City Key],[City]],
	Fact_Order
		= WideWorldImportersDW{[Schema = "Fact", Item = "Order"]}[Data][[City Key],[Order Key],[Order Date Key]],
	Fact_Sale
		= WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data][[Sale Key],[Delivery Date Key]],
	Completed_Deliveries = Table.SelectRows(Fact_Sale, each [Delivery Date Key] <> null),
	#"Fact_Order -> Completed_Delivers" = Table.Join(
		Fact_Order, 
		"Order Key", 
		Completed_Deliveries, 
		"Sale Key", 
		JoinKind.Inner
	),
    #"Inserted Date Subtraction" = Table.AddColumn(
		#"Fact_Order -> Completed_Delivers", 
		"Days Until Delivery", 
		each Duration.TotalDays([Delivery Date Key] - [Order Date Key]), 
		Int64.Type
	),
    #"Grouped Rows" = Table.Group(#"Inserted Date Subtraction", {"City Key"}, {
		{"Average Delivery Days", each List.Average([Days Until Delivery]), type number}
	}),
	#"Rounded Down" = Table.TransformColumns(#"Grouped Rows", {
		{"Average Delivery Days", Number.RoundDown, Int64.Type}
	}),
    #"Dimension_City -> Rounded Down" = Table.Join(
		Dimension_City, 
		"City Key", 
		#"Rounded Down", 
		"City Key", 
		JoinKind.Inner
	),
    #"Sorted Average Delivery Days" = Table.Sort(#"Dimension_City -> Rounded Down",{{"Average Delivery Days", Order.Descending}}),
	#"10th Value" = List.Sort(
		List.Distinct(#"Sorted Average Delivery Days"[Average Delivery Days]), 
		Order.Descending
	){10} - 1,
	#"Filter Top 10" = Table.SelectRows(
		#"Sorted Average Delivery Days", 
		each [Average Delivery Days] > #"10th Value"
	),
	#"Sorted Rows" = Table.Sort(#"Filter Top 10", {{"Average Delivery Days", Order.Descending}})
in
	#"Sorted Rows"
