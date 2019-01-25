/*
    Created By: Alex Powers
    YouTube How To Video: https://www.youtube.com/watch?v=mFU9tB-pVh4
    Website: http://www.itsnotaboutthecell.com
    Contact: alexmpowers@gmail.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
*/
 
(topping as text, size as number) =>
let
    pizzaSize = if size >= 8 then "Extra Large" else "Large",
    fnPizzaParty = "I need to order a " & pizzaSize & " " & topping & " pizza."
in
    fnPizzaParty
