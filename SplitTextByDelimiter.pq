/*
    Created By: Marc Lelijveld
    Website: https://data-marc.com/
    LinkedIn: https://www.linkedin.com/in/MarcLelivjeld/
*/

let
    Source = #table(
            type table [CustomerID = Int64.Type, Customer_Name = text, Customer_City = text, Customer_State = text],
            {
                {1, "Bob Smith", "Rockford", "IL"},
                {2, "Randy Savage", "St Louis", "MO"},
                {3, "Lucy Davis", "Lansing", "MI"}
            }
    ),

    /*
        Splits Column Header Characters When Transitioning 
        Based on underscore "_" to separate words. 
        Wrapped in a Text Combine to Combine all List Values to a Scalar Text Value
    */
    
    SplitByDelimiter = Table.TransformColumnNames(Source, each 
    Text.Combine(
        Splitter.SplitTextByEachDelimiter({"_"})(_) //between the quotes is the delimited defined to split by. 
        , " ")
    )
in
    #"SplitByDelimiter"