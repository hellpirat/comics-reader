@react.component
let make = (~currentDirectory, ~lengthDirectories, ~onBreadcrumbClick) => {
  let renderBreadcrumbs = Belt.Array.mapWithIndex(currentDirectory, (index, directory) => {
    <>
      {if index + 1 == lengthDirectories {
        <li className="pr-4 text-gray-700"> {React.string(directory)} </li>
      } else {
        <li className="pr-4">
          <button type_="button" onClick={event => onBreadcrumbClick(event, index)}>
            {React.string(directory)}
          </button>
        </li>
      }}
    </>
  })

  <nav ariaLabel="breadcrumb">
    <ol className="flex leading-none text-indigo-600 divide-x divide-indigo-400">
      {React.array(renderBreadcrumbs)}
    </ol>
  </nav>
}
