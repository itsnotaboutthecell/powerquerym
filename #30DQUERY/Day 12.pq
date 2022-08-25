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
    UnionNames =
        Table.Combine(
            {
                Dimension_Customer,
                Dimension_Customer
            }
        ),
    #"Removed Duplicates" = Table.Distinct(UnionNames),
    #"Sorted Rows" =
        Table.Sort(
            #"Removed Duplicates",
            {
                {
                    "Primary Contact",
                    Order.Ascending
                }
            }
        )
in
    #"Sorted Rows"
