(#"Column Headers" as list, #"Current Headers" as list) =>
    let
        maxSize = List.Count(#"Column Headers"),
        // Recursive Function to Map Appropriate Column Headers
        headerMap =
            (counter as number) =>
                let
                    currentRow = {
                        #"Column Headers"{counter},
                        #"Current Headers"{counter}
                    }
                in
                    if maxSize > counter then
                        List.Combine(
                            {
                                {
                                    currentRow
                                },
                                @headerMap(counter + 1)
                            }
                        )
                    else
                        {},
        Output = headerMap(0)
    in
        Output
