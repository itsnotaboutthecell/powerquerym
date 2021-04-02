(#"Current Headers" as list, #"Updated Headers" as list) =>
    let
        maxSize = List.Count(#"Current Headers"),
        // Recursive Function to Map Appropriate Column Headers
        headerMap =
            (counter as number) =>
                let
                    currentRow = {
                        #"Current Headers"{counter},
                        #"Updated Headers"{counter}
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
