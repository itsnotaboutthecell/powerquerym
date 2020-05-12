let
    Source = Sql.Databases("localhost"),
    WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
    #"Dimension_Stock Item" = WideWorldImportersDW{[Schema="Dimension",Item="Stock Item"]}[Data],
    #"Filtered Rows" = Table.SelectRows ( #"Dimension_Stock Item" , each [Color] <> "N/A" and Number.Mod([Stock Item Key], 2) < 1),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Stock Item Key", "Stock Item", "Color"})
in
    #"Removed Other Columns"
