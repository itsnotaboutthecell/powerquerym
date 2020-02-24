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
                        "Hello, World!", // Text
                        15.31, // Number
                        false, // Logical
                        #date(2018,9,14), // Date - (YYYY, MM, DD)
                        #time(15,36,15), // Time - (HH, MM, SS)
                        #datetime(2018,9,14,15,36,15), // DateTime - (YYYY, MM, DD, HH, MM, SS)
                        #datetimezone(2018,9,14,15,36,15,-5,-30), // DateTimeZone - (YYYY, MM, DD, HH, MM, SS, Offset Hours, Offset Minutes)
                        #duration(15,4,5,10), // Duration (D, H, M, S)
                        #binary("0000"), // Binary
                        null, // Null
                        {1..100}, // List
                        [a = 10, b = 30], // Record
                        #table({"ID"},{{1}}), // table
                        let foobar = (param) as any => foobar = param in foobar, // Function
                        Value.Type(2)  // Type
                    }
                }
        ),
    #"Transposed Table" = Table.Transpose(Source, {"Values"}),
    #"Custom Types" = Table.AddColumn(#"Transposed Table", "Type", each Value.Type([Values])),
    #"Compatability: Text" = Table.AddColumn(#"Custom Types", "Text", each [Values] & " Hello Steve!", type text),
    #"Compatability: Number" = Table.AddColumn(#"Compatability: Text", "Number", each [Values] + 45, type number),
    #"Compatability: Logical" = Table.AddColumn(#"Compatability: Number", "Logical", each false = [Values], type logical),
    #"Compatability: Date" = Table.AddColumn(#"Compatability: Logical", "Date", each #date(2022,10,31) - [Values], type date),
    #"Compatability: Time" = Table.AddColumn(#"Compatability: Date", "Time", each #time(16,52,30) - [Values], type time),
    #"Compatability: Date Time" = Table.AddColumn(#"Compatability: Time", "Date Time", each #datetime(2023,8,5,18,24,15) - [Values], type datetime),
    #"Compatability: Date Time Zone" = Table.AddColumn(#"Compatability: Date Time", "Date Time Zone", each #datetimezone(2024,7,15,19,56,12,-4,-15) - [Values], type datetimezone),
    #"Compatability: Duration" = Table.AddColumn(#"Compatability: Date Time Zone", "Duration", each #duration(20,15,45,32) + [Values], type duration),
    #"Compatability: Binary" = Table.AddColumn(#"Compatability: Duration", "Binary", each #binary({0x03, 0x01}) & [Values], type binary),
    #"Compatability: Null" = Table.AddColumn(#"Compatability: Binary", "Null", each null & [Values], type null),
    #"Compatability: List" = Table.AddColumn(#"Compatability: Null", "List", each {1..5} & [Values], type list),
    #"Compatability: Record" = Table.AddColumn(#"Compatability: List", "Record", each [d = 45, z = 105] & [Values], type record),
    #"Compatability: Table" = Table.AddColumn(#"Compatability: Record", "Table", each #table({"ID"}, {{25}}) & [Values], type table),
    #"Compatability: Function" = Table.AddColumn(#"Compatability: Table", "Function", each () => let returnVal = [Values] in returnVal, type function),
    #"Compatability: Type" = Table.AddColumn(#"Compatability: Function", "Type.1", each Value.Type("Hello, World!") & [Values], type type)
in
    #"Compatability: Type"
