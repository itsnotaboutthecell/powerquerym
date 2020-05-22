let
	Source = Sql.Databases("localhost"),
	WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
	Dimension_City
		= WideWorldImportersDW{[Schema = "Dimension", Item = "City"]}[Data][[City Key],[City],[State Province],[Sales Territory]],
	All_Cities_List = List.Transform(Dimension_City[City], each Text.ToList(_)),
	Name_Locator = List.Select(
		All_Cities_List, 
		each List.ContainsAll(_, {"A", "d", "C"}, Comparer.Ordinal)
	),
	Matching_Cities = List.Distinct(List.Transform(Name_Locator, each Text.Combine(_, ""))),
	Filter_Cities = Table.SelectRows(Dimension_City, each List.Contains(Matching_Cities, [City]))
in
	Filter_Cities
