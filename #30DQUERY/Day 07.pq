 let
    Source = Sql.Databases("localhost"),
    AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema = "dbo", Item = "DimEmployee"]}[Data],
    #"Non-Key Columns" = List.Select(Table.ColumnNames(dbo_DimEmployee), each  not Text.Contains(
        _, 
        "Key", 
        Comparer.Ordinal
    )),
    #"Removed Other Columns" = Table.SelectColumns(dbo_DimEmployee, #"Non-Key Columns")
in
    #"Removed Other Columns"
