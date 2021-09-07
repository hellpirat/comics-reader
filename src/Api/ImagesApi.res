module ImagesApi = {
  // to be honest this just copien files from one folder to the another lol
  let uploadToFolder = (filePath, targetPath, fileName) => {
    FS.copyFileSync(filePath, `${targetPath}/${fileName}`)
  }
}
