let
    Source = #table(
        type table [    
                        Text = text,
                        Number = number,
                        Logical = logical,
                        Date = date,
                        Time = time,
                        DateTime = datetime,
                        DateTimeZone = datetimezone,
                        Duration = duration,
                        Binary = binary,
                        Null = any,
                        List = list,
                        Record = record,
                        Table = table,
                        Function = function,
                        Type = type
                    ],
                {
                    {
                        , // Text
                        , // Number
                        , // Logical
                        , // Date - (YYYY,MM,DD)
                        , // Time - (HH, MM, SS)
                        , // DateTime - (YYYY,MM,DD,HH,MM,SS)
                        , // DateTimeZone - (YYYY,MM,DD,HH,MM,SS,Offset Hours,Offset Minutes)
                        , // Duration (D,H,M,S)
                        , // Binary
                        , // Null
                        , // List
                        , // Record
                        , // table
                        , // Function
                          // Type
                    }
                }
        ),
    #"Transposed Table" = Table.Transpose(Source, {"Values"}),
    #"Value Types" = Table.AddColumn(#"Transposed Table", "Type", each Value.Type([Values]))
in
    #"Value Types"
