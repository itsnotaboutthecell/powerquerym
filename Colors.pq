/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
*/

let
    Source = #table (
        type table [Sort = number, Color = text, Value = Int64.Type],
        {
                {0,"Red",10},
                {1,"Blue",15},
                {2,"Green",13},
                {2,"Green",25},
                {3,"Yellow",31},
                {3,"Yellow",41},
                {0,"Red",11},
                {1,"Blue",14},
                {4,"Purple",21},
                {5,"Orange",6},
                {0,"Red",15}
        }
    )
in
    Source
