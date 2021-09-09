open Cx

@react.component
let make = (~isOpen: bool, ~title, ~onClose, ~children) => {
  let isOpenClassName = switch isOpen {
  | true => "flex"
  | false => "hidden"
  }

  <>
    <div
      className={cx([
        isOpenClassName,
        "overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none justify-center items-center",
      ])}>
      <div className="relative w-auto my-6 mx-auto max-w-3xl">
        <div
          className="border-0 rounded-lg shadow-lg relative flex flex-col w-full bg-white outline-none focus:outline-none">
          <div
            className="flex items-start justify-between p-5 border-b border-solid border-blueGray-200 rounded-t">
            <h3 className="text-3xl font-semibold"> {title->React.string} </h3>
            <button
              onClick={onClose}
              className="p-1 ml-auto bg-transparent border-0 text-black opacity-5 float-right text-3xl leading-none font-semibold outline-none focus:outline-none">
              <span
                className="bg-transparent text-black opacity-5 h-6 w-6 text-2xl block outline-none focus:outline-none">
                {"×"->React.string}
              </span>
            </button>
          </div>
          children
        </div>
      </div>
    </div>
    <div className={cx([isOpenClassName, "opacity-25 fixed inset-0 z-40 bg-black"])} />
  </>
}
