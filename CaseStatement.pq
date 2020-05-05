/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@gmail.com
   
    Concept: Replicate a CASE Statement with wildcards and forced casing options
    Instructions: Set Your Lookup Value and Return Value in the Values List
*/
 
(#"Input Value" as text, Like as logical, #"Force Case" as logical) as any =>
let
 
    Values = {
        {"foo", "returnVal"},
        {"bar", "returnVal2"}
    },
    CaseSensitive = if #"Force Case" then #"Input Value" else Text.Lower(#"Input Value"),
    Result = if Like then
                    List.First(List.Select(Values, each Text.Contains(CaseSensitive, _{0}))){1}?
                     else List.First(List.Select(Values, each _{0} = CaseSensitive)){1}?
in
    Result
