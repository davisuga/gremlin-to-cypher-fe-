@module("./logo.svg") external logo: string = "default"
%%raw(`import './App.css'`)
open ReactQuery

let s = React.string

@react.component
let make = () => {
  let (selectedOption, setSelectedOption) = React.useState(() => "Tinker")
  let (cypherContent, setCypherContent) = React.useState(() => "")

  let queryResult = useQuery(
    queryOptions(
      ~queryFn=_ =>
        Api.translateCypher(Api.translationSourceTypeOfString(selectedOption), cypherContent),
      ~queryKey="todos",
      ~enabled=false,
      (),
    ),
  )

  let updateField = (fn, event) => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    fn(_ => value)
  }

  <div className="flex flex-1 h-screen bg-slate-100">
    <div className="flex h-full  flex-1 flex-col place-items-center p-3">
      // <img src={logo} className="App-logo" alt="logo" />
      <p className="text-3xl font-bold text-black"> {"Cypher to Gremlin Online Converter"->s} </p>
      <input value=cypherContent onChange={updateField(setCypherContent)} />
      <select name="Flavor" value=selectedOption onChange={updateField(setSelectedOption)}>
        <option selected={selectedOption == "Neptune"} value="Neptune"> {"Neptune"->s} </option>
        <option selected={selectedOption == "Cosmos"} value="Cosmos"> {"Cosmos"->s} </option>
        <option selected={selectedOption == "Tinker"} value="Tinker"> {"Tinker"->s} </option>
      </select>
      <button
        onClick={_ =>
          queryResult.refetch({
            throwOnError: false,
            cancelRefetch: false,
          }) |> ignore}
        className="p-4 border-black text-black">
        {"Translate"->s}
      </button>
      <input value={queryResult.data->Belt.Option.getWithDefault("")} />
    </div>
  </div>
}
