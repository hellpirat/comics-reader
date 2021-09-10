open ImagesApi
open Webapi.Dom
open Document

let root = "/comics"

@react.component
let make = (~comicsId, ~chapterId) => {
  let (images, setImages) = React.useState(() => [])

  let path = `.${root}/${comicsId}/${chapterId}`

  React.useEffect0(() => {
    let res: array<string> = ImagesApi.getImages(path)
    setImages(_ => res)
    None
  })

  let handleFullScreen = event => {
    ReactEvent.Mouse.preventDefault(event)
    document->documentElement->Element.requestFullscreen
  }

  let renderImages = Belt.Array.mapWithIndex(images, (index, image) => {
    <img key={Belt.Int.toString(index)} src={`file://${Path.resolve2(path, image)}`} alt={image} />
  })

  <div>
    <div className="flex">
      <Button onClick={_ => RescriptReactRouter.push("/")}> {"Back"->React.string} </Button>
      <Button> {"Prev"->React.string} </Button>
      <Button> {"Next"->React.string} </Button>
      <Button onClick={handleFullScreen}> {"Full Screen"->React.string} </Button>
    </div>
    {React.array(renderImages)}
  </div>
}
