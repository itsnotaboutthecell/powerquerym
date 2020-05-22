let
	Source = Sql.Databases("localhost"),
	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
	dbo_FactCallCenter
		= AdventureWorksDW2017{[Schema = "dbo", Item = "FactCallCenter"]}[Data][[DateKey],[Shift],[Calls],[AverageTimePerIssue]],
	#"Filtered Rows" = Table.SelectRows(dbo_FactCallCenter, each Text.Contains([Shift], "PM")),
	#"Inserted Multiplication" = Table.AddColumn(
		#"Filtered Rows", 
		"TotalTime", 
		each [Calls] * [AverageTimePerIssue], 
		type number
	),
	#"Sorted Ascending" = Table.Sort(#"Inserted Multiplication", {{"TotalTime", Order.Ascending}}),
	#"Total Calls" = List.Count(#"Sorted Ascending"[TotalTime]),
	#"10th Shortest Call" = #"Sorted Ascending"[TotalTime]{9},
	#"10th Longest Call" = #"Sorted Ascending"[TotalTime]{#"Total Calls" - 10},
	#"Kept Longest Calls" = Table.SelectRows(
		#"Sorted Ascending", 
		each [TotalTime] >= #"10th Longest Call" or [TotalTime] <= #"10th Shortest Call"
	)
in
	#"Kept Longest Calls"
