type filterType = {
  name: string,
  extensions: array<string>,
}

type showOpenDialogResult = {
  canceled: bool,
  filePaths: array<string>,
}

type showOpenDialogOptions = {properties: array<string>, filters: array<filterType>}

type dialog = {showOpenDialog: showOpenDialogOptions => Promise.t<showOpenDialogResult>}

type remote = {dialog: dialog}

@module("electron") external remote: remote = "remote"
