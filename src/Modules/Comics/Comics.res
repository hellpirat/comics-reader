open ImagesApi
open Webapi.Dom
open Document

let root = "/comics"

type viewType = All | ByPage

// type state = Idle | Loading | Success(MapsDecode.map, array<PointsDecode.point>) | Error(string)

@react.component
let make = (~comicsId, ~chapterId) => {
  let (viewType, setViewType) = React.useState(() => All)
  let (images, setImages) = React.useState(() => [])
  let (currentPage, setCurrentPage) = React.useState(() => 1)

  let path = `.${root}/${comicsId}/${chapterId}`

  React.useEffect0(() => {
    let res: array<string> = ImagesApi.getImages(path)
    setImages(_ => res)
    None
  })

  let imagesLength = Belt.Array.length(images)
  Js.log(imagesLength)
  Js.log(currentPage)

  let handleFullScreen = event => {
    ReactEvent.Mouse.preventDefault(event)
    document->documentElement->Element.requestFullscreen
  }

  let renderImages = Belt.Array.mapWithIndex(images, (index, image) => {
    <img key={Belt.Int.toString(index)} src={`file://${Path.resolve2(path, image)}`} alt={image} />
  })

  let renderByPage = () => {
    let pageImage = Belt.Array.get(images, currentPage - 1)
    switch pageImage {
    | Some(pageImage) => <img src={`file://${Path.resolve2(path, pageImage)}`} alt={pageImage} />
    | None => React.null
    }
  }

  let handleNextPage = event => {
    ReactEvent.Mouse.preventDefault(event)
    setCurrentPage(prev => prev + 1)
  }

  let handlePrevPage = event => {
    ReactEvent.Mouse.preventDefault(event)
    setCurrentPage(prev => prev - 1)
  }

  <div>
    <div className="flex">
      <Button onClick={_ => RescriptReactRouter.push("/")}> {"Back"->React.string} </Button>
      <Button onClick={_ => setViewType(_ => All)}> {"All"->React.string} </Button>
      <Button onClick={_ => setViewType(_ => ByPage)}> {"By Page"->React.string} </Button>
      <Button disabled={currentPage == 1} onClick={handlePrevPage}> {"Prev"->React.string} </Button>
      <Button disabled={currentPage == imagesLength} onClick={handleNextPage}>
        {"Next"->React.string}
      </Button>
      <Button onClick={handleFullScreen}> {"Full Screen"->React.string} </Button>
    </div>
    {if viewType == All {
      React.array(renderImages)
    } else if viewType == ByPage {
      renderByPage()
    } else {
      React.null
    }}
  </div>
}
