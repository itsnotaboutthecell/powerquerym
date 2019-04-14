/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
*/

let
    Source = #table(
            type table [CUSTOMER_ID = Int64.Type, CUSTOMER_NAME = text, CUSTOMER_CITY = text, CUSTOMER_STATE = text],
            {
                {1, "Bob Smith", "Rockford", "IL"},
                {2, "Randy Savage", "St Louis", "MO"},
                {3, "Lucy Davis", "Lansing", "MI"}
            }
    ),
    
    // Replaces Underscore Field Name Values and Converts to Proper Casing
    ReplaceUnderscores = Table.TransformColumnNames(Source,
      each Text.Proper(
          Replacer.ReplaceText( _ , "_", " " 
        )))
in
    ReplaceUnderscores
