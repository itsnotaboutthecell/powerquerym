let
    Source = Sql.Databases("localhost"),
    AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
    // dbo_DimCustomer
    dbo_DimCustomer = AdventureWorksDW2017{[Schema = "dbo", Item = "DimCustomer"]}[Data],
    // FactInternetSales
    FactInternetSales = AdventureWorksDW2017{[Schema = "dbo", Item = "FactInternetSales"]}[Data],
    // Join Tables
    #"dbo_DimCustomer -> FactInterntSales" = Table.Join(
        dbo_DimCustomer, 
        "CustomerKey", 
        FactInternetSales, 
        "CustomerKey", 
        JoinKind.Inner
    ),
    #"Added Conditional Column" = Table.AddColumn(
        #"dbo_DimCustomer -> FactInterntSales", 
        "EducationSort", 
        each if [EnglishEducation] = "Partial High School"
            then 0
            else if [EnglishEducation] = "High School"
                then 1
                else if [EnglishEducation] = "Partial College"
                    then 2
                    else if [EnglishEducation] = "Bachelors"
                        then 3
                        else if [EnglishEducation] = "Graduate Degree" then 4 else null, 
        Int64.Type
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Added Conditional Column", {
        "Gender", 
        "EnglishEducation", 
        "CommuteDistance", 
        "OrderQuantity", 
        "EducationSort"
    }),
    CommuteDistances = List.Distinct(#"Removed Other Columns"[CommuteDistance]),
    ReorderCommute = List.Combine({
        List.Sort(List.Select(CommuteDistances, each _ <> "10+ Miles")), 
        List.Select(CommuteDistances, each _ = "10+ Miles")
    }),
    #"Pivoted Column" = Table.Pivot(
        #"Removed Other Columns", 
        ReorderCommute, 
        "CommuteDistance", 
        "OrderQuantity", 
        List.Sum
    ),
    #"Sorted Rows" = Table.Sort(#"Pivoted Column", {
        {"EducationSort", Order.Ascending}, 
        {"Gender", Order.Ascending}
    }),
    #"Removed Columns" = Table.RemoveColumns(#"Sorted Rows",{"EducationSort"})
in
    #"Removed Columns"
