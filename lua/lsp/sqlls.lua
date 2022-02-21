local sqlls_settings = {
    sqls = {
        connections = {
            {
                drive = "postgresql",
                dataSourceName = "host=postgres port=5430 user=newuser password=password dbname=core sslmode=disable",
            },
        },
    },
}

return {settings = sqlls_settings}
