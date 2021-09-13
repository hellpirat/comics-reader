module ImagesApi = {
  // get comics images
  let getImages = srcPath => {
    Js.Array2.filter(FS.readdirSync(srcPath), file => {
      let extension = file->Path.extname->Js.String2.toLowerCase
      extension == ".jpg"
    })
  }

  // literally this just copying files from one folder to the another lol
  let uploadToFolder = (filePath, targetPath, fileName) => {
    FS.copyFileSync(filePath, `${targetPath}/${fileName}`)
  }
}
