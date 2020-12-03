let
    topPages = Table.FromList({1..10}, Splitter.SplitByNothing(), type table [ID = Int64.Type]),
    #"Added Custom" = Table.AddColumn(topPages, "Page", each "?page=" & Text.From([ID]), type text),

    ExtractPages = (PagePath as text) =>
        let
            Source = Web.Contents("https://ideas.powerbi.com/ideas/", [RelativePath=PagePath]),
            #"Extracted Table From Html" = Html.Table(Source, {
                    {"votes", ".post-column-one SPAN"}
                    , {"dateTime", ".text-capitalize + *"}
                    , {"title", ".post-title *"}
                    , {"comments", ".pull-left + *"}
                    , {"state", ".text"}
                    , {"user", ".text-capitalize"}
                }
                , [RowSelector=".col-lg-8 .list-group-item\-\-ideas"])
        in
            #"Extracted Table From Html",
    pbiIdeas = Table.AddColumn(#"Added Custom", "Ideas Page", each ExtractPages([Page]), type table),
    #"Removed Other Columns" = Table.SelectColumns(pbiIdeas,{"Ideas Page"}),
    #"Expanded Ideas Page" = Table.ExpandTableColumn(#"Removed Other Columns", "Ideas Page", {"votes", "dateTime", "title", "comments", "state", "user"}, {"votes", "dateTime", "title", "comments", "state", "user"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Ideas Page",{{"votes", Int64.Type}, {"dateTime", type text}, {"title", type text}, {"comments", type text}, {"state", type text}, {"user", type text}})
in
    #"Changed Type"
