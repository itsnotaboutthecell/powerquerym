let
    langCodes = () as table =>
        let
            Source = Web.Contents("https://support.microsoft.com/en-us/worldwide"),
            #"Extracted Table From Html" = Html.Table(
                Source,
                {
                    {"Language", "DIV.row.pt-2"},
                    {
                        "LanguageCode",
                        "DIV.row.pt-2 > A[data-bi-type=""link""][data-bi-name=""lp_culture_link""]:nth-child(1):nth-last-child(1)",
                        each[Attributes][href]?
                    }
                },
                [
                    RowSelector = "DIV.row.pt-2"
                ]
            ),
            #"Replaced Value" = Table.ReplaceValue(
                #"Extracted Table From Html",
                "https://support.microsoft.com/",
                "",
                Replacer.ReplaceText,
                {"LanguageCode"}
            )
        in
            #"Replaced Value",
    Source = #table(type table [Month = Int64.Type], List.Split({1..12}, 1)),
    Translations = Table.AddColumn(
        Source,
        "Translations",
        each
            [
                monthNumber = #date(2022, [Month], 1),
                Translations = List.Transform(langCodes()[LanguageCode], each Date.MonthName(monthNumber, _)),
                TranslationTable = Table.FromList(Translations, null),
                TranslationsTranspose = Table.Transpose(TranslationTable),
                TranslationsColumns = Table.RenameColumns(
                    TranslationsTranspose,
                    List.Zip(
                        {
                            Table.ColumnNames(TranslationsTranspose),
                            List.Transform(langCodes()[Language], each "Month " & _)
                        }
                    )
                )
            ]
    ),
    #"Expanded Translations" = Table.ExpandRecordColumn(
        Translations, "Translations", {"TranslationsColumns"}, {"TranslationsColumns"}
    )
in
    #"Expanded Translations"
