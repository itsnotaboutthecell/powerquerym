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
    #"Removed Other Columns";

shared #"Day 5" = let
    Source = Sql.Databases("localhost"),
    WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
    Dimension_Employee = WideWorldImportersDW{[Schema = "Dimension", Item = "Employee"]}[Data],
    #"Filtered Rows" = Table.SelectRows(
        Dimension_Employee, 
        each (Date.Year([Valid To]) <> 9999 and [Is Salesperson] = true and Duration.TotalDays(
            [Valid To] - [Valid From]
        )
            > 365)
            or ([Is Salesperson] = true and Date.Year([Valid To]) = 9999)
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows", {
        "Employee Key", 
        "Employee", 
        "Is Salesperson", 
        "Valid From", 
        "Valid To"
    })
in
    #"Removed Other Columns"
