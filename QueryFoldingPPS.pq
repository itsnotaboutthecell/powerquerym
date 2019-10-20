let
    Source = Sql.Databases("localhost"),
    AdventureWorksDW2016 = Source{[Name="AdventureWorksDW2016"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2016{[Schema="dbo",Item="DimEmployee"]}[Data],
    #"Filter: Salesperson = True" = Table.SelectRows(dbo_DimEmployee, each ([SalesPersonFlag] = true)),
    #"Custom: Gender Name" = Table.AddColumn(#"Filter: Salesperson = True", "Gender Name", each 
        if [Gender] = "M" 
            then "Male" 
        else if [Gender] = "F" 
            then "Female" 
        else null, type text),
    #"Custom: Full Name" = Table.AddColumn(#"Custom: Gender Name", "Full Name", each 
        [FirstName] & 
        ( 
            if [MiddleName] = null 
                then " " 
            else " " & [MiddleName] & " " 
        ) 
        & [LastName], type text),
    #"Removed Other Columns" = Table.SelectColumns(#"Custom: Full Name",{"EmployeeKey", "HireDate", "BirthDate", "EmailAddress", "Phone", "Gender Name", "Full Name"}),
    #"Custom: Column Splitter" = Table.TransformColumnNames(#"Removed Other Columns", each 
            Text.Combine(
                    Splitter.SplitTextByCharacterTransition(
                            {"a".."z"},
                            {"A".."Z"}
                        )(_)
                    , " ")
                    )
in
    #"Custom: Column Splitter"
