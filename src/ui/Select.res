module Select = {
  type optionSelect = {
    value: string,
    label: string,
  }

  @react.component
  let make = (~onChange, ~options: array<optionSelect>, ~value, ~name) => {
    let renderOptions = Belt.Array.map(options, option => {
      <option key={option.value} selected={value === option.value} value={option.value}>
        {option.label->React.string}
      </option>
    })
    <select
      className="w-full h-10 pl-3 pr-6 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline"
      name={name}
      onChange={onChange}>
      {React.array(renderOptions)}
    </select>
  }
}
