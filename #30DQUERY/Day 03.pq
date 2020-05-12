let
    Source = Sql.Databases("localhost"),
    AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
    // DimProduct
    dbo_DimProduct = AdventureWorksDW2017{[Schema = "dbo", Item = "DimProduct"]}[Data],
    DimProductColumns = Table.SelectColumns(dbo_DimProduct, {"ProductKey", "EnglishProductName"}),
    // FactResellerSales
    dbo_FactResellerSales = AdventureWorksDW2017{[Schema = "dbo", Item = "FactResellerSales"]}[Data][[ProductKey],[OrderQuantity],[UnitPrice]],
    #"Inserted Multiplication" = Table.AddColumn(
        dbo_FactResellerSales, 
        "TotalUnitPrice", 
        each [OrderQuantity] * [UnitPrice], 
        Currency.Type
    ),
    #"Grouped Rows" = Table.Group(#"Inserted Multiplication", {"ProductKey"}, {
        {"TotalRevenue", each List.Sum([TotalUnitPrice]), type number}
    }),
    #"Greater than 1 Million" = Table.SelectRows(
        #"Grouped Rows", 
        each [TotalRevenue] > 1000000
    ),
    #"DimProduct -> Greater Than 1 Million" = Table.Join(
        DimProductColumns, 
        "ProductKey", 
        #"Greater than 1 Million", 
        "ProductKey", 
        JoinKind.Inner
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"DimProduct -> Greater Than 1 Million", {
        "ProductKey", 
        "EnglishProductName", 
        "TotalRevenue"
    })
in
    #"Removed Other Columns"
