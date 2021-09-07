module ImagesApi = {
  let getImages = srcPath => {
    Js.Array2.filter(FS.readdirSync(srcPath), file => {
      let extension = file->Path.extname->Js.String2.toLowerCase
      extension == ".jpg"
    })
  }

  // to be honest this just copien files from one folder to the another lol
  let uploadToFolder = (filePath, targetPath, fileName) => {
    FS.copyFileSync(filePath, `${targetPath}/${fileName}`)
  }
}
