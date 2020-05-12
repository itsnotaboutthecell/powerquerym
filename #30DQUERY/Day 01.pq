 let
    Source = Sql.Databases("localhost"),
    AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema = "dbo", Item = "DimEmployee"]}[Data],
    #"Added Custom" = Table.AddColumn(
        dbo_DimEmployee, 
        "FullName", 
        each if [BirthDate] >= #date(1974, 1, 1) and [BirthDate] < #date(1975, 1, 1) then [FirstName] & (if [MiddleName] = null then " " else " " & [MiddleName] & " ") & [LastName] else null, 
        type text
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Added Custom", {
        "EmployeeKey", 
        "BirthDate", 
        "Gender", 
        "FullName"
    })
in
    #"Removed Other Columns"
