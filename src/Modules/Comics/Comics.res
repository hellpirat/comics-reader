open ImagesApi
open Webapi.Dom
open Document
open KeyboardEvent
open Select
// open Window

let root = "/comics"

type viewType = All | ByPage

// List style
// Paged style
// select page

@react.component
let make = (~comicsId, ~chapterId) => {
  let (viewType, setViewType) = React.useState(() => ByPage)
  let (images, setImages) = React.useState(() => [])
  let (currentPage, setCurrentPage) = React.useState(() => 1)

  let path = `.${root}/${comicsId}/${chapterId}`

  let imagesLength = Belt.Array.length(images)

  React.useEffect0(() => {
    let res: array<string> = ImagesApi.getImages(path)
    setImages(_ => res)
    None
  })

  let goToNextPage = () => {
    setCurrentPage(prev => {
      let nextState = prev + 1
      if nextState < imagesLength + 1 {
        nextState
      } else {
        prev
      }
    })
    document
    ->documentElement
    ->Element.scrollToWithOptions({"top": 0.0, "left": 0.0, "behavior": "smooth"})
  }

  let goToPrevPage = () => {
    setCurrentPage(prev => {
      let nextState = prev - 1
      if nextState > 0 {
        nextState
      } else {
        prev
      }
    })
  }

  let handleKeyDown = event => {
    let key = event->key

    if key == "ArrowRight" {
      goToNextPage()
    }

    if key == "ArrowLeft" {
      goToPrevPage()
    }
  }

  React.useEffect0(() => {
    window->Window.addKeyDownEventListener(handleKeyDown)

    let removeKeyDownListener = () => window->Window.removeKeyDownEventListener(handleKeyDown)

    Some(removeKeyDownListener)
  })

  let handleFullScreen = event => {
    ReactEvent.Mouse.preventDefault(event)
    document->documentElement->Element.requestFullscreen
  }

  let handleNextPage = event => {
    ReactEvent.Mouse.preventDefault(event)
    goToNextPage()
  }

  let handlePrevPage = event => {
    ReactEvent.Mouse.preventDefault(event)
    goToPrevPage()
  }

  let handlePaginationSelectChange = event => {
    let value = ReactEvent.Form.target(event)["value"]
    setCurrentPage(_ => value)
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

  let paginationOptions = React.useMemo1(() => {
    let res = Belt.Array.makeBy(imagesLength, index => index + 1)
    Belt.Array.map(res, item => {
      let result: Select.optionSelect = {
        label: Belt.Int.toString(item),
        value: Belt.Int.toString(item),
      }
      result
    })
  }, [imagesLength])

  <div>
    <div className="flex items-center">
      <Button onClick={_ => RescriptReactRouter.push("/")}> {"Back"->React.string} </Button>
      <Button disabled={viewType == All} onClick={_ => setViewType(_ => All)}>
        {"List style"->React.string}
      </Button>
      <Button disabled={viewType == ByPage} onClick={_ => setViewType(_ => ByPage)}>
        {"Paged style"->React.string}
      </Button>
      {if viewType == ByPage {
        <>
          <Button disabled={currentPage == 1} onClick={handlePrevPage}>
            {"Prev"->React.string}
          </Button>
          <div className="relative text-gray-700 w-44">
            <Select
              value={Belt.Int.toString(currentPage)}
              name="pagination"
              onChange={handlePaginationSelectChange}
              options={paginationOptions}
            />
          </div>
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
