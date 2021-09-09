@react.component
let make = (~placeholder, ~value, ~onChange, ~required=false) => {
  <input
    className="w-full h-10 px-3 mb-2 text-base text-gray-700 placeholder-gray-600 border rounded-lg focus:shadow-outline"
    type_="text"
    placeholder={placeholder}
    value={value}
    onChange={onChange}
    required
  />
}
