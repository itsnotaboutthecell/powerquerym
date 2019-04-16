/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
    Reference: https://www.excelguru.ca/blog/2019/04/15/creating-a-fiscal-saturday-calendar/
*/

let
    Source = List.Dates(StartDate, Duration.Days(EndDate - StartDate) + 1, #duration(1,0,0,0)),
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), type table [Date = date], null, ExtraValues.Error),
    meDate = Table.AddColumn(#"Converted to Table", "Fiscal ME", each returnMEDate([Date]), type date),
    yeDate = Table.AddColumn(meDate, "Fiscal YE", each returnYEDate([Date]), type date),

    returnMEDate = (meSaturday as date) =>
    let
        thisMonth = Date.EndOfMonth(meSaturday),
        nextMonth = Date.EndOfMonth(Date.AddMonths(thisMonth, 1)),
        dayOfWeek = Date.DayOfWeek(thisMonth),
        lastSaturday =  if dayOfWeek = 0 then thisMonth
                        else Date.AddDays(thisMonth, -(dayOfWeek+1)),
        monthCheck = if meSaturday > lastSaturday then nextMonth else thisMonth
        in
            Date.AddDays(monthCheck , -(Date.DayOfWeek(monthCheck)+1)),

    returnYEDate = (yeSaturday as date) =>
    let
        endOfMonth = Date.EndOfYear(
                        Date.AddMonths(yeSaturday, 1)
                    ),
        dayOfWeek = Date.DayOfWeek(endOfMonth),
        lastSaturday =  if dayOfWeek = 0 then endOfMonth 
                        else Date.AddDays(endOfMonth, -(dayOfWeek+1))
    in
        lastSaturday
in
    yeDate
