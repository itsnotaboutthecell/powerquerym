let
	Source = Sql.Databases("localhost"),
	AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
	dbo_DimPromotion = AdventureWorksDW2017{[Schema = "dbo", Item = "DimPromotion"]}[Data],
	#"Add Spaces" = Table.TransformColumnNames(
		dbo_DimPromotion, 
		each Text.Combine(Splitter.SplitTextByCharacterTransition({"a".."z"}, {"A".."Z"})(_), " ")
	)
in
	#"Add Spaces"
