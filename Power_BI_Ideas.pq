let
    topPages = Table.FromList({1..10}, Splitter.SplitByNothing(), type table [ID = Int64.Type]),
    #"Added Custom" = Table.AddColumn(topPages, "Page", each "?page=" & Text.From([ID]), type text),

    ExtractPages = (PagePath as text) =>
    let
        Source = Web.Contents("https://ideas.powerbi.com/forums/265200-power-bi-ideas/filters/top", [RelativePath=PagePath]),
        #"Extracted Table From Html" = Html.Table(Source, {{"Column1", ".uvCol-8 .uvFieldEtc-submit-button"}, {"Column2", ".uvCol-8 .uvFieldEtc-submit-button + *"}, {"Column3", ".uvCol-8 H2"}, {"Column4", ".uvCol-8 .uvSigninLegend"}, {"Column5", ".uvCol-8 .uvSigninMode"}, {"Column6", ".uvCol-8 .uvField-display_name .uvFieldPlaceholder"}, {"Column7", ".uvCol-8 .uvField-email .uvFieldPlaceholder"}, {"Column8", ".uvCol-8 .uvSignin .uvFieldEtc"}, {"Column9", ".uvCol-8 .clearfix .uvFieldPlaceholder"}, {"Column10", ".uvCol-8 STYLE + *"}, {"Column11", ".uvCol-8 .uvFieldEtc-forgot_password *"}, {"Column12", ".uvCol-8 .uvFieldEtc-create_password *"}, {"Column13", ".uvCol-8 .uvField-consent SPAN"}, {"Column14", ".uvCol-8 .color-link"}, {"Column15", ".uvCol-8 .logged_in_as + *"}, {"Column16", ".uvCol-8 .uvFormFlash-error .uvFormFlashClose"}, {"Column17", ".uvCol-8 .uvFormFlash-info .uvFormFlashClose"}, {"Column18", "STRONG"}, {"Column19", ".uvStyle-separator:nth-child(2) + A"}, {"Column20", "STRONG + *"}, {"Column21", ".uvIdeaVoteFormTriggerState-no_votes"}, {"Column22", ".uvIdeaVoteFormTriggerState-out_of_votes"}, {"Column23", ".uvIdeaVoteFormTriggerState-voting_closed"}, {"Column24", ".uvAnonymousOnly"}, {"Column25", ".uvFlagObject"}, {"Column26", ".uvSuggestion-dissociate"}, {"Column27", ".uvAdminOnly:nth-child(2)"}, {"Column28", ".uvStyle-status"}, {"Column29", ".fn"}, {"Column30", ".uvUserTitle"}, {"Column31", ".title"}, {"Column32", ".uvUserBadgeLabel"}}, [RowSelector=".uvCol-8 H2"]),
        #"Promoted Headers" = Table.PromoteHeaders(#"Extracted Table From Html", [PromoteAllScalars=true]),
        #"Removed Other Columns" = Table.SelectColumns(#"Promoted Headers",{"How can we improve Power BI?", "Column18", "Column19", "Column28"})
    in
        #"Removed Other Columns",
    pbiIdeas = Table.AddColumn(#"Added Custom", "Ideas Page", each ExtractPages([Page]), type table),
    #"Removed Other Columns" = Table.SelectColumns(pbiIdeas,{"Ideas Page"}),
    #"Expanded Ideas Page" = Table.ExpandTableColumn(#"Removed Other Columns", "Ideas Page", {"How can we improve Power BI?", "Column18", "Column19", "Column28"}, {"How can we improve Power BI?", "Column18", "Column19", "Column28"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Ideas Page",{{"How can we improve Power BI?", "Idea"}, {"Column18", "Votes"}, {"Column19", "Category"}, {"Column28", "Status"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns",{{"Idea", type text}, {"Votes", Int64.Type}, {"Category", type text}, {"Status", type text}})
in
    #"Changed Type"
