module DirectoriesApi = {
  let getDirectories = srcPath => {
    Js.Array2.filter(FS.readdirSync(srcPath), file =>
      FS.statSync(Path.join2(srcPath, file))->FS.Stats.isDirectory
    )
  }

  let createDirectory = name => {
    FS.mkdirSync(name)
  }

  let renameDirectory = (old, new) => {
    FS.renameSync(old, new)
  }

  let removeDirectory = (directory: string) => {
    FS.rmSync(directory, {recursive: true, force: true})
  }
}
