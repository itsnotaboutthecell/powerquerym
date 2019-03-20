/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
*/

let
    startDateTime = #datetime(2018,1,1,0,0,0),
    endDateTime = #datetime(2019,12,31,23,0,0),
    totalHours = Duration.TotalHours(endDateTime - startDateTime) + 1,
    listHours = List.DateTimes(startDateTime, totalHours, #duration(0,1,0,0)),
    #"Converted to Table" = Table.FromList(listHours, Splitter.SplitByNothing(), type table [DateTime = datetime], null, ExtraValues.Error)
in
    #"Converted to Table"
