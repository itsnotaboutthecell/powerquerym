let
    Source = Web.Page(Web.Contents("https://docs.microsoft.com/en-us/cpp/c-runtime-library/language-strings?view=msvc-160")),
    Data0 = Source{0}[Data],
    #"Custom: DD-MM-YYYY" =
        Table.AddColumn(
            Data0,
            "DD-MM-YYYY",
            each
                Date.FromText(
                    "22-01-2021",
                    [Equivalent Locale Name]
                ),
            type date
        ),
    #"Custom: MM-DD-YYYY" =
        Table.AddColumn(
            #"Custom: DD-MM-YYYY",
            "MM-DD-YYYY",
            each
                Date.FromText(
                    "01-22-2021",
                    [Equivalent Locale Name]
                ),
            type date
        ),
    #"Custom: YYYY-MM-DD" =
        Table.AddColumn(
            #"Custom: MM-DD-YYYY",
            "YYYY-MM-DD",
            each
                Date.FromText(
                    "2021-01-22",
                    [Equivalent Locale Name]
                ),
            type date
        )
in
    #"Custom: YYYY-MM-DD"
