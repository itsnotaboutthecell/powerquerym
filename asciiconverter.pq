/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
    Challenge: https://www.excelguru.ca/blog/2018/09/11/power-query-challenge-3/
 
*/
 
(Word as text) =>
let
    getChar = (count as number) =>
    let
        char = try Character.ToNumber(Text.Lower(Text.Range(Word, count, 1))) - 96 otherwise null
    in
        if char is null then {}
        else List.Combine({{char}, @getChar (count + 1)}),
 
    Final = List.Sum(getChar(0))
in
    Final
