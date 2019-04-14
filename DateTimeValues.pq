/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
*/

let
    startTime = #datetime(2019, 1, 1, 0, 0, 0),
    endTime = DateTime.LocalNow(),
    Source = List.DateTimes(startTime, Duration.TotalSeconds(endTime - startTime), #duration(0,0,0,1)),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), type table [#"Order Date" = datetime], null, ExtraValues.Error)
in
    #"Converted to Table"
