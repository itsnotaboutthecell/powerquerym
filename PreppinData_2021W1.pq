let
    Source =
        Csv.Document(
            File.Contents("C:\Users\blah_blah_blah\Downloads\PD 2021 Wk 1 Input - Bike Sales.csv"),
            [
                Delimiter = ",",
                // Columns = 6, BAD! BAD - OPTIONAL ARGUMENT! DO NOT WANT!
                Encoding = 1252,
                QuoteStyle = QuoteStyle.None
            ]
        ),
    #"Promoted Headers" =
        Table.PromoteHeaders(
            Source,
            [PromoteAllScalars = true]
        ),
    #"Removed Top 10 Rows" = Table.Skip(#"Promoted Headers", 10),
    #"Split Column by Delimiter" =
        Table.SplitColumn(
            #"Removed Top 10 Rows",
            "Store - Bike",
            Splitter.SplitTextByDelimiter(
                " - ",
                QuoteStyle.Csv
            ),
            {
                "Store",
                "Bike"
            }
        ),
    #"Transform Columns" =
        Table.TransformColumns(
            #"Split Column by Delimiter",
            {
                {
                    "Bike",
                    each
                        if Text.StartsWith(Text.Upper(_), "R") then
                            "Road"
                        else if Text.StartsWith(Text.Upper(_), "M") then
                            "Mountain"
                        else
                            "Gravel"
                },
                {
                    "Date",
                    each Date.From(_, "en-GB")
                }
            }
        ),
    #"Inserted Quarter" =
        Table.AddColumn(
            #"Transform Columns",
            "Quarter",
            each Date.QuarterOfYear([Date]),
            Int64.Type
        ),
    #"Inserted Day" =
        Table.AddColumn(
            #"Inserted Quarter",
            "Day of Month",
            each Date.Day([Date]),
            Int64.Type
        ),
    #"Removed Columns" =
        Table.RemoveColumns(
            #"Inserted Day",
            {"Date"}
        ),
    #"Reordered Columns" =
        Table.ReorderColumns(
            #"Removed Columns",
            {
                "Quarter",
                "Store",
                "Bike",
                "Order ID",
                "Customer Age",
                "Bike Value",
                "Existing Customer?",
                "Day of Month"
            }
        ),
    #"Changed Type" =
        Table.TransformColumnTypes(
            #"Reordered Columns",
            {
                {
                    "Order ID",
                    Int64.Type
                },
                {
                    "Customer Age",
                    Int64.Type
                },
                {
                    "Bike Value",
                    Int64.Type
                },
                {
                    "Existing Customer?",
                    type text
                },
                {
                    "Store",
                    type text
                },
                {
                    "Bike",
                    type text
                },
                {
                    "Quarter",
                    Int64.Type
                },
                {
                    "Day of Month",
                    Int64.Type
                }
            }
        )
in
    #"Changed Type"
