let
	Source = Sql.Databases("localhost"),
	WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
	Fact_Sale = WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data],
	totalYears = List.Count(
		List.Distinct(
            List.Transform(
                Fact_Sale[Invoice Date Key], each Date.Year(_)
            )
        )
	),
	#"Partition By Year" = Table.Combine(
		Table.Partition(Fact_Sale, "Invoice Date Key", totalYears, Date.Year)
	)
in
	#"Partition By Year"
