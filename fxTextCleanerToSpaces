(textInput as text) as text =>
    let
        textValue =
            Text.Combine(
                List.Transform(
                    Text.ToList(textInput),
                    each
                        if
                            List.Contains(
                                // ASCII character codes list to be changed
                                {
                                    160
                                },
                                Character.ToNumber(_)
                            )
                        then
                            // Changed to space
                            Character.FromNumber(32)
                        else
                            _
                )
            )
    in
        textValue
