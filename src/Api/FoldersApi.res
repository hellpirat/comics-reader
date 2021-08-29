module FolderApi = {
  let getDirectories = srcPath => {
    Js.Array2.filter(FS.readdirSync(srcPath), file =>
      FS.statSync(Path.join2(srcPath, file))->FS.Stats.isDirectory
    )
  }
}
