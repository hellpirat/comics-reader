open ImagesApi
open Webapi.Dom
open Document
open Element

let root = "/comics"

type viewType = All | ByPage

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

  let handleFullScreen = event => {
    ReactEvent.Mouse.preventDefault(event)
    document->documentElement->Element.requestFullscreen
  }

  let handleNextPage = event => {
    ReactEvent.Mouse.preventDefault(event)
    setCurrentPage(prev => prev + 1)
    document
    ->documentElement
    ->Element.scrollToWithOptions({"top": 0.0, "left": 0.0, "behavior": "smooth"})
  }

  let handlePrevPage = event => {
    ReactEvent.Mouse.preventDefault(event)
    setCurrentPage(prev => prev - 1)
  }

  let renderImages = Belt.Array.mapWithIndex(images, (index, image) => {
    <img key={Belt.Int.toString(index)} src={`file://${Path.resolve2(path, image)}`} alt={image} />
  })

  let renderByPage = () => {
    let pageImage = Belt.Array.get(images, currentPage - 1)
    switch pageImage {
    | Some(pageImage) =>
      <div>
        <img
          src={`file://${Path.resolve2(path, pageImage)}`} alt={pageImage} onClick={handleNextPage}
        />
      </div>
    | None => React.null
    }
  }

  let paginationLabel =
    <div className="flex self-center">
      {`Current page ${Belt.Int.toString(currentPage)}/${Belt.Int.toString(
          imagesLength,
        )}`->React.string}
    </div>

  <div>
    <div className="flex">
      <Button onClick={_ => RescriptReactRouter.push("/")}> {"Back"->React.string} </Button>
      <Button disabled={viewType == All} onClick={_ => setViewType(_ => All)}>
        {"All"->React.string}
      </Button>
      <Button disabled={viewType == ByPage} onClick={_ => setViewType(_ => ByPage)}>
        {"By Page"->React.string}
      </Button>
      {if viewType == ByPage {
        <>
          <Button disabled={currentPage == 1} onClick={handlePrevPage}>
            {"Prev"->React.string}
          </Button>
          paginationLabel
          <Button disabled={currentPage == imagesLength} onClick={handleNextPage}>
            {"Next"->React.string}
          </Button>
        </>
      } else {
        React.null
      }}
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
