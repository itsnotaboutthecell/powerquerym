 let
	Source = Sql.Databases("localhost"),
	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
	dbo_DimEmployee = AdventureWorksDW2017{[Schema = "dbo", Item = "DimEmployee"]}[Data],
	First_Letters = List.Select(
		dbo_DimEmployee[LastName], 
		each not List.Contains({"A".."E"}, Text.Start(_, 1))
	),
	employeeNames = Table.SelectRows(dbo_DimEmployee, each List.Contains(First_Letters, [LastName])),
	#"Removed Other Columns" = Table.SelectColumns(
		employeeNames, 
		{"EmployeeKey", "FirstName", "MiddleName", "LastName"}
	)
in
	#"Removed Other Columns"
