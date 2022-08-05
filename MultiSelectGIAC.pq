let
    Source =
        Sql.Database(
            ServerAddress,
            "ContosoRetailDW"
        ),
    dbo_DimPromotion =
        Source{[
            Schema = "dbo",
            Item = "DimPromotion"
        ]}
            [Data],
    #"Filtered Rows" =
        Table.SelectRows(
            dbo_DimPromotion,
            each
                Text.Contains(
                    [PromotionDescription],
                    PromoParam
                )
        ),
    ParamType = Value.Type(PromoParam),
    ParamTypeIsList = Type.Is(ParamType, List.Type),
    queryParam =
        if ParamTypeIsList then
            List.Transform(
                PromoParam,
                each
                    [
                        Selection = _,
                        Data =
                            Table.SelectRows(
                                dbo_DimPromotion,
                                each
                                    Text.Contains(
                                        [PromotionDescription],
                                        Selection
                                    )
                            )
                    ][Data]
            )
        else
            #"Filtered Rows",
    Output =
        if ParamTypeIsList then
            Table.Combine(queryParam)
        else
            queryParam
in
    Output
