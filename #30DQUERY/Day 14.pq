let
	Source = Sql.Databases("localhost"),
	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
	dbo_DimCustomer = AdventureWorksDW2017{[Schema = "dbo", Item = "DimCustomer"]}[Data],
	#"No Weekends" = Table.SelectRows(
		dbo_DimCustomer, 
		each not List.Contains({1, 7}, Date.DayOfWeek([BirthDate]))
	),
	#"Removed Other Columns" = Table.SelectColumns(
		#"No Weekends", 
		{"CustomerKey", "EmailAddress", "EnglishEducation", "EnglishOccupation", "YearlyIncome"}
	)
in
	#"Removed Other Columns"
