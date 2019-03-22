/*
    Created By: Alex Powers ; George Mount
    Websites: http://www.itsnotaboutthecell.com ; http://www.georgejmount.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/ ; https://www.linkedin.com/in/gjmount/
    Contact: alexmpowers@itsnotaboutthecell.com
*/

(zipCode as text) as table =>
let
    Source = Web.Page(Web.Contents("https://weather.com/weather/tenday/l/" & Text.From(zipCode) & ":4:US")),
    #"Demote Headers" = Source{0}[Data],
    #"List Column Names" = Table.AddColumn(Table.SelectRows(Record.ToTable(Table.DemoteHeaders(Source{0}[Data]){0}), each not Text.Contains([Value], "Column")), "List of Lists", each {[Name], [Value]})[List of Lists],
    #"Demote Header Row" = Table.DemoteHeaders(Table.RemoveColumns(Source{0}[Data],List.Range(Table.ColumnNames(Source{0}[Data]), 0, 1))),
    #"Renamed Columns" = Table.RenameColumns(#"Demote Header Row",#"List Column Names"),
    #"Removed Top Rows" = Table.Skip(#"Renamed Columns",1),
    #"Split: Day - Weekday and Date" = Table.SplitColumn(#"Removed Top Rows", "Day", Splitter.SplitTextByEachDelimiter({"#(cr)"}, QuoteStyle.Csv, false), {"Weekday", "Partial Date"}),
    #"Split: Wind - Wind Direction and Wind (MPH)" = Table.SplitColumn(#"Split: Day - Weekday and Date", "Wind", Splitter.SplitTextByEachDelimiter({" "}, QuoteStyle.Csv, false), {"Wind Direction", "Wind (MPH)"}),
    #"Split High / Low - High and Low" = Table.SplitColumn(#"Split: Wind - Wind Direction and Wind (MPH)", "High / Low", Splitter.SplitTextByEachDelimiter({"°"}, QuoteStyle.Csv, false), {"High", "Low"}),
    #"Replace: mph" = Table.ReplaceValue(#"Split High / Low - High and Low","mph","",Replacer.ReplaceText,{"Wind (MPH)"}),
    #"Replace: --" = Table.ReplaceValue(#"Replace: mph","--","-",Replacer.ReplaceText,{"High"}),
    #"Replace: °" = Table.ReplaceValue(#"Replace: --","°","",Replacer.ReplaceText,{"High", "Low"}),
    #"Custom: Full Date" = Table.AddColumn(#"Replace: °", "Date", each Date.From([Partial Date] & " " & Text.From(Date.Year(DateTime.LocalNow()))), type date),
    #"Removed Other Columns" = Table.SelectColumns(#"Custom: Full Date",{"Date", "Description", "High", "Low", "Precip", "Wind Direction", "Wind (MPH)", "Humidity"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Removed Other Columns",{{"Humidity", Percentage.Type}, {"Precip", Percentage.Type}, {"Wind (MPH)", Int64.Type}, {"High", Int64.Type}, {"Low", Int64.Type}, {"Description", type text}})
in
    #"Changed Type"
