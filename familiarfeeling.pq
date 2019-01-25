/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
*/

let
    Source = "Hello, World",
    #"Something Else" = "Keepin' It",
    Val = 100,
    #"Storage Amount" = {Source, #"Something Else", Val},
    #"Storage Amount – Index" = #"Storage Amount"{2}, // 0 Based Index
    #"Numbered List - 0 to 100" = {0..#"Storage Amount – Index"},
    #"Converted to Table" = Table.FromList(#"Numbered List - 0 to 100", Splitter.SplitByNothing(), {“Index”}, null, ExtraValues.Error),
    #"Each Loop with ASCII Number" = Table.AddColumn(#"Converted to Table", "ASCII", each Character.FromNumber([Index])),
    #"ASCII Number Column" = #"Each Loop with ASCII Number"[ASCII]{97},
    #"Alphabetical List - a to z" = {#"ASCII Number Column".."z"}
in
    #"Alphabetical List - a to z"
