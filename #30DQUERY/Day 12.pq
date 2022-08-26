let
    Source = Sql.Databases("localhost"),
    WideWorldImportersDW = Source{[Name = "WideWorldImportersDW"]}[Data],
    Dimension_Employee =
        WideWorldImportersDW{[
            Schema = "Dimension",
            Item = "Employee"
        ]}
            [Data]
            [[Employee]],
    Dimension_Customer =
        WideWorldImportersDW{[
            Schema = "Dimension",
            Item = "Customer"
        ]}
            [Data]
            [[Primary Contact]],
    #"Renamed Columns" =
        Table.RenameColumns(
            Dimension_Customer,
            {
                {
                    "Primary Contact",
                    "Employee"
                }
            }
        ),
    UnionNames =
        Table.Combine(
            {
                Dimension_Employee,
                #"Renamed Columns"
            }
        ),
    #"Removed Duplicates" = Table.Distinct(UnionNames),
    #"Sorted Rows" =
        Table.Sort(
            #"Removed Duplicates",
            {
                {
                    "Employee",
                    Order.Ascending
                }
            }
        )
in
    #"Sorted Rows"
