/*
    Created By: Alex Powers
    Website: http://www.itsnotaboutthecell.com
    LinkedIn: https://www.linkedin.com/in/alexmpowers/
    Contact: alexmpowers@itsnotaboutthecell.com
*/

// This file contains your Data Connector logic
section OpenWeatherMap;

/*
    https://openweathermap.org/current
*/

[DataSource.Kind="OpenWeatherMap", Publish="OpenWeatherMap.Publish"]
shared OpenWeatherMap.Contents = (#"API Key" as text, #"Zip Code" as text) =>
let
    Source = Json.Document(Web.Contents("http://api.openweathermap.org/data/2.5/forecast?zip=" & #"Zip Code" & "&APPID=" & #"API Key" & "&units=imperial"))[list],
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), type table [OpenWeather = record], null, ExtraValues.Error),
    #"Combine All Records" = Table.AddColumn(#"Converted to Table", "Combine Records", 
        each Record.Combine(
                {
                    Record.FromList([OpenWeather][weather], {"weather"})[weather],
                    [OpenWeather][main],
                    [OpenWeather][clouds],
                    [OpenWeather][wind],
                    [OpenWeather][rain],
                    [OpenWeather][sys]
                }
            ), type record
        ),
    #"Expanded OpenWeather" = Table.ExpandRecordColumn(#"Combine All Records", "OpenWeather", {"dt_txt"}, {"dt_txt"}),
    #"Expanded Combine Records" = Table.ExpandRecordColumn(#"Expanded OpenWeather", "Combine Records", {"id", "main", "description", "icon", "temp", "temp_min", "temp_max", "pressure", "sea_level", "grnd_level", "humidity", "temp_kf", "all", "speed", "deg", "3h", "pod"}, {"id", "main", "description", "icon", "temp", "temp_min", "temp_max", "pressure", "sea_level", "grnd_level", "humidity", "temp_kf", "all", "speed", "deg", "3h", "pod"}),
    #"Split Column by Delimiter" = Table.SplitColumn(Table.TransformColumnTypes(#"Expanded Combine Records", {{"dt_txt", type text}}, "en-US"), "dt_txt", Splitter.SplitTextByEachDelimiter({" "}, QuoteStyle.Csv, false), {"Date", "Time"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"Date", type date}, {"Time", type time}, {"temp", type number}, {"temp_min", type number}, {"temp_max", type number}, {"pressure", type number}, {"sea_level", type number}, {"grnd_level", type number}, {"humidity", Int64.Type}, {"temp_kf", type number}, {"all", Int64.Type}, {"speed", type number}, {"deg", type number}, {"3h", type number}, {"pod", type text}, {"id", Int64.Type}, {"main", type text}, {"description", type text}, {"icon", type text}})
in
    #"Changed Type";

// Data Source Kind description
OpenWeatherMap = [
    Authentication = [
        // Key = []
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
OpenWeatherMap.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://openweathermap.org/current",
    SourceImage = OpenWeatherMap.Icons,
    SourceTypeImage = OpenWeatherMap.Icons
];

OpenWeatherMap.Icons = [
    Icon16 = { Extension.Contents("OpenWeatherMap16.png"), Extension.Contents("OpenWeatherMap20.png"), Extension.Contents("OpenWeatherMap24.png"), Extension.Contents("OpenWeatherMap32.png") },
    Icon32 = { Extension.Contents("OpenWeatherMap32.png"), Extension.Contents("OpenWeatherMap40.png"), Extension.Contents("OpenWeatherMap48.png"), Extension.Contents("OpenWeatherMap64.png") }
];
