let
	Source = Sql.Databases("localhost"),
	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
	dbo_DimEmployeee = AdventureWorksDW2017{[Schema = "dbo", Item = "DimEmployee"]}[Data],
	#"Filtered Rows" = Table.SelectRows(
		dbo_DimEmployeee, 
		each 
        (
            Date.Year([BirthDate]) * 10000
            + Date.Month([BirthDate]) * 100
            + Date.Day([BirthDate])
        ) >= 19900101
        and 
        (
            Date.Year([BirthDate]) * 10000
            + Date.Month([BirthDate]) * 100
            + Date.Day([BirthDate])
        ) < 19910101
	),
	#"Removed Other Columns" = Table.SelectColumns(
		#"Filtered Rows", 
		{"EmailAddress", "Gender", "BirthDate"}
	)
in
	#"Removed Other Columns"
