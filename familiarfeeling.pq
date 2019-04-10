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
    #"Struct List" = {Source, #"Something Else", Val},
    #"List – Index" = #"Struct List"{2}, // 0 Based Index
    #"Numbered List - 0 to 100" = {0..#"List – Index"},
    #"Table With Meta" = Table.FromList(#"Numbered List - 0 to 100", Splitter.SplitByNothing(), type table [Index = Int64.Type], null, ExtraValues.Error),
    #"Each Loop with ASCII Number" = Table.AddColumn(#"Table With Meta", "ASCII", each Character.FromNumber([Index]), type text),
    #"ASCII Column and Row" = #"Each Loop with ASCII Number"[ASCII]{97},
    #"Alphabetical List - a to z" = {#"ASCII Column and Row".."z"}
in
    #"Alphabetical List - a to z"
