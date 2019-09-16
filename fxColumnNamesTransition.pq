/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
*/

(columnNames as text) =>
let 
    splitColumn = Splitter.SplitTextByCharacterTransition({"a".."z"}, {"A".."Z"})(columnNames)
in
    Text.Combine(splitColumn, " ")
