let
    Source = Sql.Databases("localhost"),
    AdventureWorksDW2017 = Source{[Name = "AdventureWorksDW2017"]}[Data],
    // DimReseller
    dbo_DimReseller = AdventureWorksDW2017{[Schema = "dbo", Item = "DimReseller"]}[Data],
    #"Filtered Reseller" = Table.SelectRows(dbo_DimReseller, each Text.Contains(
        [ResellerName], 
        "Bike"
    ) or Text.Contains(
        [ResellerName], 
        "Bicycle"
    )),
    #"Removed Columns: Reseller" = Table.SelectColumns(#"Filtered Reseller", {
        "ResellerKey", 
        "GeographyKey", 
        "BusinessType", 
        "ResellerName", 
        "NumberEmployees", 
        "ProductLine", 
        "AnnualRevenue"
    }),
    // DimGeography
    dbo_DimGeography = AdventureWorksDW2017{[Schema = "dbo", Item = "DimGeography"]}[Data],
    #"Filtered Geography" = Table.SelectRows(dbo_DimGeography, each  not List.Contains(
        {"DE", "GB"}, 
        [CountryRegionCode]
    )),
    #"Removed Columns: Geography" = Table.SelectColumns(#"Filtered Geography", {
        "GeographyKey", 
        "CountryRegionCode", 
        "EnglishCountryRegionName"
    }),
    #"Join dbo_DimReseller -> DimGeography" = Table.Join(
        #"Removed Columns: Reseller", 
        "GeographyKey", 
        #"Removed Columns: Geography", 
        "GeographyKey", 
        JoinKind.Inner
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Join dbo_DimReseller -> DimGeography", {
        "ResellerKey", 
        "BusinessType", 
        "ResellerName", 
        "NumberEmployees", 
        "ProductLine", 
        "AnnualRevenue", 
        "EnglishCountryRegionName"
    })
in
    #"Removed Other Columns"
