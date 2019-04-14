/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
*/

let
    Source = #table(
            type table [CustomerID = Int64.Type, CustomerName = text, CustomerCity = text, CustomerState = text],
            {
                {1, "Bob Smith", "Rockford", "IL"},
                {2, "Randy Savage", "St Louis", "MO"},
                {3, "Lucy Davis", "Lansing", "MI"}
            }
    ),

    /*
        Splits Column Header Characters When Transitioning 
        From Lower Case to Upper Case to a list of Values
        Wrapped in a Text Combine to Combine all List Values to a Scalar Text Value
    */
    
    SplitByCharacter = Table.TransformColumnNames(Source, each 
    Text.Combine(
        Splitter.SplitTextByCharacterTransition({"a".."z"}, {"A".."Z"})(_)
        , " ")
    )
in
    SplitByCharacter
