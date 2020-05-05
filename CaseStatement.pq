/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
   
    Concept: Replicate a CASE Statement with wildcards and a case sensitivty
    Instructions: Set Your Lookup Value in the First Position and the Return Value in the Values List
*/ 
(#"Input Value" as text, #"Like Match" as logical, #"Case Insensitive" as logical) as any => 
    let
        Values = {
        {"foo", "returnVal"},
        {"bar", "returnVal2"}
        },
        Result =    if #"Like Match" and #"Case Insensitive"
                        then List.First(List.Select(Values, each Text.Contains(#"Input Value", _{0}, Comparer.OrdinalIgnoreCase))){1}?
                    else if #"Like Match" and not #"Case Insensitive"
                        then List.First(List.Select(Values, each Text.Contains(#"Input Value", _{0}, Comparer.Equals))){1}? 
                    else List.First(List.Select(Values, each _{0} = #"Input Value")){1}?
    in
    if Result = null then #"Input Value" else Result
