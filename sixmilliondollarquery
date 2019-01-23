
/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
    
    Dataset -
      Title: Unemployment and median household income for the U.S., States, and counties, 2007-17
      Website: https://www.ers.usda.gov/data-products/county-level-data-sets/download-data/
      Privacy Settings: Anonymous, Public
*/

let
    Source = Excel.Workbook(Web.Contents("https://www.ers.usda.gov/webdocs/DataFiles/48747/Unemployment.xls"), null, true),
    #"Unemployment Med HH Inc_Sheet" = Source{[Name="Unemployment Med HH Inc"]}[Data],


/*
    A custom recursive function that looks for the header row indicator of "FIPStxt" and exits upon completion.
    To initiate a recursive event use the @ symbol and the function name.
    Ensure that you have an exit condition to avoid being stuck in an infinite loop.
*/

    getHeader = (counter as number) =>
    let
        header = #"Unemployment Med HH Inc_Sheet"[Column1]{counter}
    in
        if header = "FIPStxt" then counter
        else @getHeader(counter + 1),

    headerRow = getHeader(0),
    #"Remove Top Rows: headerRow" = Table.Skip(#"Unemployment Med HH Inc_Sheet",headerRow),
    #"Headers: Promote" = Table.PromoteHeaders(#"Remove Top Rows: headerRow", [PromoteAllScalars=true]),
    #"Headers: Uppercase" = Table.TransformColumnNames(#"Headers: Promote", Text.Upper),
    #"Headers: Replace ""_"" with "" """ = Table.TransformColumnNames(#"Headers: Uppercase", each Replacer.ReplaceText(_, "_", " ")),
    #"Unpivoted Other Columns" = Table.UnpivotOtherColumns(#"Headers: Replace ""_"" with "" """, {"FIPSTXT", "STATE", "AREA NAME"}, "Attribute", "Value"),
    #"Split Column: Right 5" = Table.SplitColumn(#"Unpivoted Other Columns", "Attribute", Splitter.SplitTextByPositions({0, 5}, true), {"Attribute.1", "Year"}),
    #"Pivoted Column" = Table.Pivot(#"Split Column: Right 5", List.Distinct(#"Split Column: Right 5"[Attribute.1]), "Attribute.1", "Value"),
    #"Changed Type" = Table.TransformColumnTypes(#"Pivoted Column",{{"FIPSTXT", Int64.Type}, {"STATE", type text}, {"AREA NAME", type text}, {"Year", Int64.Type}, {"CIVILIAN LABOR FORCE", Int64.Type}, {"EMPLOYED", Int64.Type}, {"UNEMPLOYED", Int64.Type}, {"UNEMPLOYMENT RATE", type number}, {"MEDIAN HOUSEHOLD INCOME", Int64.Type}, {"MED HH INCOME PERCENT OF STATE TOTAL", type number}, {"RURAL URBAN CONTINUUM CODE", Int64.Type}, {"URBAN INFLUENCE CODE", Int64.Type}, {"METRO", Int64.Type}})
in
    #"Changed Type"
