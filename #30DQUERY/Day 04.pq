let
    Source = Sql.Databases("localhost"),
    WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
    Fact_Order = WideWorldImportersDW{[Schema = "Fact", Item = "Order"]}[Data],
    #"Filtered Rows" = Table.SelectRows(
        Fact_Order, 
        each Number.Mod(Text.Length([Description]), 10) = 1
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows", {"Order Key", "Description"})
in
    #"Removed Other Columns"
