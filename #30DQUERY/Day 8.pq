let
    Source = Sql.Databases("localhost"),
    WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
    Fact_Sale = WideWorldImportersDW{[Schema = "Fact", Item = "Sale"]}[Data],
    #"Filtered Rows" = Table.SelectRows(
        Fact_Sale, 
        each (if Date.Month([Invoice Date Key]) = 2
            then 28
            else if List.Contains({4, 6, 9, 11}, Date.Month([Invoice Date Key])) then 30 else 31)
            - Date.Day([Invoice Date Key]) < 1
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows", {
        "Sale Key", 
        "Customer Key", 
        "Invoice Date Key", 
        "Total Excluding Tax", 
        "Tax Amount", 
        "Profit"
    })
in
    #"Removed Other Columns"
