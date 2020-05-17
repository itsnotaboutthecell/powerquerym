let
    Source = Sql.Databases("localhost"),
    WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
    Dimension_Employee = WideWorldImportersDW{[Schema = "Dimension", Item = "Employee"]}[Data],
    #"Filtered Rows" = Table.SelectRows(
        Dimension_Employee, 
        each (Date.Year([Valid To]) <> 9999 and [Is Salesperson] = true and Duration.TotalDays(
            [Valid To] - [Valid From]
        )
            > 365)
            or ([Is Salesperson] = false and Date.Year([Valid To]) = 9999)
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
