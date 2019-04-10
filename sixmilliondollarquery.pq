
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
    // Extract the previous identifier's Column1 as a list. Find the position of the text "FIPStxt", its first occurence while ignoring case sensitivity
    #"Find Position" = Table.Skip(
        #"Unemployment Med HH Inc_Sheet",
        List.PositionOf(
                #"Unemployment Med HH Inc_Sheet"[Column1], "FIPStxt", 1, Comparer.OrdinalIgnoreCase
                )
            ),
    #"Promoted Headers" = Table.PromoteHeaders(#"Find Position", [PromoteAllScalars=true]),
    /*
        Clean each item in Column Names. 
            The use of a underscore avoids the hardcoding of individual column headers and instead transforms each item in the collection
            We used a Replacer to ReplaceText of underscores to spaces in our headers, this function is wrapped with a Text.Proper to standardize all column headers 
    */   
    #"Clean Headers" = Table.TransformColumnNames(
        #"Promoted Headers", 
        each 
        Text.Proper(
            Replacer.ReplaceText( _ , "_", " ")
            )
        ),
    #"Unpivoted Other Columns" = Table.UnpivotOtherColumns(#"Clean Headers", {"Fipstxt", "State", "Area Name"}, "Attribute", "Value"),
    // Rename the auto generated Attribute.2 Column Header to Year. This step avoids and unnnecessary Table.RenameColumns function
    #"Split Column by Delimiter" = Table.SplitColumn(#"Unpivoted Other Columns", "Attribute", Splitter.SplitTextByEachDelimiter({" "}, QuoteStyle.Csv, true), {"Attribute.1", "Year"}),
    #"Pivoted Column" = Table.Pivot(#"Split Column by Delimiter", List.Distinct(#"Split Column by Delimiter"[Attribute.1]), "Attribute.1", "Value", List.Count),
    #"Changed Type" = Table.TransformColumnTypes(#"Pivoted Column",{{"Fipstxt", type text}, {"State", type text}, {"Area Name", type text}, {"Year", Int64.Type}, {"Civilian Labor Force", Int64.Type}, {"Employed", Int64.Type}, {"Unemployed", Int64.Type}, {"Unemployment Rate", Int64.Type}, {"Median Household Income", Int64.Type}, {"Med Hh Income Percent Of State Total", Int64.Type}, {"Rural Urban Continuum Code", Int64.Type}, {"Urban Influence Code", Int64.Type}, {"Metro", Int64.Type}})
in
    #"Changed Type"
