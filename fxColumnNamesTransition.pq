let
    fx =
        (#"Identifier" as table) =>
            let
                #"Column Cleaner" =
                    Table.TransformColumnNames(
                        #"Identifier",
                        each
                            Text.Proper(
                                Replacer.ReplaceText(
                                    Text.Combine(
                                        Splitter.SplitTextByCharacterTransition(
                                            {"a".."z"},
                                            {"A".."Z"}
                                        )(_),
                                        " "
                                    ),
                                    "_",
                                    " "
                                )
                            )
                    )
            in
                #"Column Cleaner",
    Documentation_Meta = [
        Documentation.Name = "Column Renamer",
        Documentation.Description = "Creates readable column names by transforming column headers and outputting in proper casing.",
        Documentation.Examples = {
            [
                Description = "Splits characters that transition from a lower case to an upper case value.",
                Code = "HelloWorld",
                Result = "Hello World"
            ],
            [
                Description = "Replaces underscores with spaces",
                Code = "Customer_Address",
                Result = "Customer Address"
            ],
            [
                Description = "Replaces underscores with a space and transforms to proper cased text.",
                Code = "FIRST_NAME",
                Result = "First Name"
            ]
        }
    ]
in
    Value.ReplaceType(
        fx,
        Value.ReplaceMetadata(
            Value.Type(fx),
            Documentation_Meta
        )
    )
