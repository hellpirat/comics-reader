/*
    Bindings for node.js module path
    require("path")
 */

@module("path") external basename: string => string = "basename"

@module("path") external join: array<string> => string = "join"

@module("path") external join2: (string, string) => string = "join"

@module("path") external extname: string => string = "extname"

@module("path") external resolve: string => string = "resolve"

@module("path") external resolve2: (string, string) => string = "resolve"
