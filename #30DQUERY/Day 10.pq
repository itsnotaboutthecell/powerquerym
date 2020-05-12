let
	Source = Sql.Databases("localhost"),
	WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
	Dim_Employee
		= WideWorldImportersDW{[Schema = "Dimension", Item = "Employee"]}[Data][[Employee], [WWI Employee ID]],
	#"Removed Duplicates" = Table.Distinct(Dim_Employee),
	#"Renamed Columns" = Table.RenameColumns(#"Removed Duplicates", {{"Employee", "TeamMate"}}),
	#"Employee Offset" = Table.TransformColumns(
		#"Renamed Columns", 
		{{"WWI Employee ID", each _ - 1, type number}}
	),
	#"DimEmployee -> Employee Offset" = Table.Join(
		#"Removed Duplicates", 
		"WWI Employee ID", 
		#"Employee Offset", 
		"WWI Employee ID", 
		JoinKind.Inner, 
		JoinAlgorithm.SortMerge
	),
	#"Even Numbers" = Table.SelectRows(
		#"DimEmployee -> Employee Offset", 
		each Number.Mod([WWI Employee ID], 2) < 1
	)[[Employee],[TeamMate]]
in
	#"Even Numbers"
