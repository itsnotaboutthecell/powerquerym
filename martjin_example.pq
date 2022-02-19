Json.Document(
    Web.Contents(
        "https://api.bsccan.com/api",
        [
            Query = [
                module = "account",
                action = "txlist",
                address = Address,
                startblock = 0,
                endblock = 99999999,
                page = [Column1],
                sort = "desc",
                apiKey = #"API KEY"
            ]
        ]
    )
)
