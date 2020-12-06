let
    fxIdeaScrapper =
        (PagePath as number) =>
            let
                Source =
                    Web.Contents(
                        "https://ideas.powerbi.com/ideas/",
                        [
                            RelativePath =
                                Text.Combine(
                                    {
                                        "?page=",
                                        Text.From(PagePath)
                                    }
                                )
                        ]
                    ),
                #"Extracted Table From Html" =
                    Html.Table(
                        Source,
                        {
                            {
                                "votes",
                                ".post-column-one SPAN"
                            },
                            {
                                "Date",
                                ".text-capitalize + *"
                            },
                            {
                                "title",
                                ".post-title *"
                            },
                            {
                                "comments",
                                ".pull-left + *"
                            },
                            {
                                "state",
                                ".text"
                            },
                            {
                                "user",
                                ".text-capitalize"
                            }
                        },
                        [RowSelector = ".col-lg-8 .list-group-item\-\-ideas"]
                    ),
                #"Custom: Transformations" =
                    Table.TransformColumns(
                        #"Extracted Table From Html",
                        {
                            {
                                "Date",
                                each Date.From(DateTime.From(Text.AfterDelimiter(_, "on ")))
                            },
                            {
                                "comments",
                                each Number.From(Text.BeforeDelimiter(_, " Comments"))
                            }
                        }
                    )
            in
                #"Custom: Transformations",
    Source =
        List.Generate(
            () =>
                [
                    page = 1,
                    ideas = fxIdeaScrapper(page)
                ],
            each not Table.IsEmpty([ideas]),
            each
                [
                    page = [page] + 1,
                    ideas = fxIdeaScrapper(page)
                ]
        ),
    #"Converted to Table" =
        Table.FromList(
            Source,
            Splitter.SplitByNothing(),
            null,
            null,
            ExtraValues.Error
        ),
    #"Expanded Column1" =
        Table.ExpandRecordColumn(
            #"Converted to Table",
            "Column1",
            {
                "page",
                "ideas"
            },
            {
                "page",
                "ideas"
            }
        ),
    #"Expanded ideas" =
        Table.ExpandTableColumn(
            #"Expanded Column1",
            "ideas",
            {
                "votes",
                "Date",
                "title",
                "comments",
                "state",
                "user"
            },
            {
                "votes",
                "Date",
                "title",
                "comments",
                "state",
                "user"
            }
        ),
    #"Changed Type" =
        Table.TransformColumnTypes(
            #"Expanded ideas",
            {
                {
                    "page",
                    Int64.Type
                },
                {
                    "votes",
                    Int64.Type
                },
                {
                    "Date",
                    type date
                },
                {
                    "title",
                    type text
                },
                {
                    "comments",
                    Int64.Type
                },
                {
                    "state",
                    type text
                },
                {
                    "user",
                    type text
                }
            }
        )
in
    #"Changed Type"
