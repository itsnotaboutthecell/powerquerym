let
    ideasWebsite = "https://ideas.powerbi.com/ideas/",
    Source = Web.BrowserContents(ideasWebsite),
    PageCount =
        Text.AfterDelimiter(
            Text.BetweenDelimiters(
                Source,
                "pagination-ellipses",
                "</a>"
            ),
            ">",
            2
        ),
    topPages =
        Table.FromList(
            {1..Number.From(PageCount)},
            Splitter.SplitByNothing(),
            type table [ID = Int64.Type]
        ),
    ExtractPages =
        (PagePath as number) =>
            let
                Source =
                    Web.Contents(
                        ideasWebsite,
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
    pbiIdeas =
        Table.AddColumn(
            topPages,
            "Ideas Page",
            each ExtractPages([ID]),
            type table
        ),
    #"Removed Other Columns" =
        Table.SelectColumns(
            pbiIdeas,
            {"Ideas Page"}
        ),
    #"Expanded Ideas Page" =
        Table.ExpandTableColumn(
            #"Removed Other Columns",
            "Ideas Page",
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
            #"Expanded Ideas Page",
            {
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
