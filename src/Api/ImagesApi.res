module ImagesApi = {
  let getImages = srcPath => {
    Js.Array2.filter(FS.readdirSync(srcPath), file => {
      let extension = file->Js.String2.toLowerCase->Path.extname
      extension == ".jpg"
    })
  }

  // to be honest this just copien files from one folder to the another lol
  let uploadToFolder = (filePath, targetPath, fileName) => {
    FS.copyFileSync(filePath, `${targetPath}/${fileName}`)
  }
}
