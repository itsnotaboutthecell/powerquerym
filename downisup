/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
*/

let
    Source = #table(
        type table [Vendor=Text.Type, State=Text.Type, Sales=Number.Type, #"Total Amount"=Number.Type],
        {
            {"Contoso","MO",150,4013.116648},
            {"Contoso",null,5,3901.489177},
            {"Contoso","IA",4,3397.450098},
            {"Contoso",null,1,6644.073951},
            {"Blue Leaf","CT",333,3051.231318},
            {"Blue Leaf",null,12,253.3631271},
            {"Blue Leaf","CA",1,2224.051889},
            {"Blue Leaf",null,1,905.6072264},
            {"Red Heights","IL",450,9924.911047},
            {"Red Heights","MO",30,7219.495968},
            {"Red Heights",null,12,5296.912715}
        }
),
    #"Filter: non null" = Table.SelectRows(Source, each ([State] <> null)),
    // Vendor ASC, Sales DESC
    #"Sort Columns" = Table.Sort(#"Filter: non null",{{"Vendor", Order.Ascending}, {"Sales", Order.Descending}}),
    // Largest Sales of Each
    #"Remove Duplicate Vendors" = Table.Distinct(#"Sort Columns", {"Vendor"}),
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Vendor", "Sales", "Total Amount"}),
    #"Merged Queries" = Table.NestedJoin(#"Removed Other Columns",{"Vendor"},#"Remove Duplicate Vendors",{"Vendor"},"Clean States",JoinKind.Inner),
    #"Expanded Clean States" = Table.ExpandTableColumn(#"Merged Queries", "Clean States", {"State"}, {"State"})
in
    #"Expanded Clean States"
