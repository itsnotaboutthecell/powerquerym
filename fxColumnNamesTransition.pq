/*
    Created By: Alex Powers
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Twitter: https://www.twitter.com/notaboutthecell
*/
(columnNames as text) =>
let 
    splitColumn = Splitter.SplitTextByCharacterTransition({"a".."z"}, {"A".."Z"})(columnNames),
    combineText = Text.Combine(splitColumn, " "),
    replaceUnderScores = Replacer.ReplaceText(combineText, "_", " "),
    ProperCasing = Text.Proper(replaceUnderScores)
in
    ProperCasing
