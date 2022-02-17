(StartDate as date, EndDate as date, optional Culture as nullable text) as table =>
let
    DayCount =
        Duration.TotalDays(EndDate - StartDate)
        + 1,
    Source =
        List.Dates(
            StartDate,
            DayCount,
            #duration(1, 0, 0, 0)
        ),
    // I added the optional metadata header for the third argument - type table [Date = date] removing some unnecessary M
    TableFromList =
        Table.FromList(
            Source,
            Splitter.SplitByNothing(),
            type table [Date = date]
        ),
    InsertYear =
        Table.AddColumn(
            TableFromList,
            "Year",
            each Date.Year([Date]),
            Int64.Type
        ),
    InsertQuarter =
        Table.AddColumn(
            InsertYear,
            "Quarter",
            each Date.QuarterOfYear([Date]),
            Int8.Type
        ),
    InsertMonth =
        Table.AddColumn(
            InsertQuarter,
            "MonthNr",
            each Date.Month([Date]),
            Int8.Type
        ),
    InsertYearMonth =
        Table.AddColumn(
            InsertMonth,
            "YearMonth",
            each Date.ToText([Date], "yyyyMM"),
            type text
        ),
    InsertDay =
        Table.AddColumn(
            InsertYearMonth,
            "Day",
            each Date.Day([Date]),
            Int8.Type
        ),
    InsertDayInt =
        Table.AddColumn(
            InsertDay,
            "DateInt",
            each [Year] * 10000 + [MonthNr] * 100 + [Day],
            Int64.Type
        ),
    InsertMonthName =
        Table.AddColumn(
            InsertDayInt,
            "Month",
            each Date.ToText([Date], "MMMM", Culture),
            type text
        ),
    InsertMonthNameShort =
        Table.AddColumn(
            InsertMonthName,
            "Month short",
            each Date.ToText([Date], "MMM", Culture),
            type text
        ),
    InsertDayWeek =
        Table.AddColumn(
            InsertMonthNameShort,
            "DayInWeek",
            each Date.DayOfWeek([Date], Day.Monday) + 1,
            Int8.Type
        ),
    InsertDayName =
        Table.AddColumn(
            InsertDayWeek,
            "DayOfWeekName",
            each Date.ToText([Date], "dddd", Culture),
            type text
        ),
    InsertYearWeek =
        Table.AddColumn(
            InsertDayName,
            "YearWeek",
            each
                Text.From([Year])
                & Text.PadStart(
                    Text.From(Date.WeekOfYear([Date])),
                    2,
                    "0"
                ),
            type text
        ),
    InsertWeekStarting =
        Table.AddColumn(
            InsertYearWeek,
            "WeekStart",
            each Date.StartOfWeek([Date]),
            type date
        ),
    InsertWeekEnding =
        Table.AddColumn(
            InsertWeekStarting,
            "WeekEnding",
            each Date.EndOfWeek([Date]),
            type date
        ),
    InsertWeekofYear =
        Table.AddColumn(
            InsertWeekEnding,
            "WeekofYear",
            each Date.WeekOfYear([Date]),
            Int8.Type
        )
in
    InsertWeekofYear
