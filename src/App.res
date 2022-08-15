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

  let onClickTranslate = _ =>
    queryResult.refetch({
      throwOnError: false,
      cancelRefetch: false,
    })->ignore
  queryResult->Js_json.stringifyAny->Belt.Option.getWithDefault("")->Js_console.log
  <div className=" flex flex-1 h-screen p-3 bg-background container box-border">
    <div className="flex w-screen grow flex-col place-items-center ">
      <p className="text-3xl m-4 font-bold text-text">
        {"Cypher to Gremlin Online Converter"->s}
      </p>
      <div className="flex flex-wrap justify-around gap-4 items-start w-full">
        <textarea
          value=cypherContent
          placeholder="Enter Cypher query"
          className="grow side font-mono  flex min-h-full bg-surface1 p-2 rounded-sm text-text"
          onChange={updateField(setCypherContent)}
        />
        <div className="flex  flex-col gap-4">
          <div className="dropdown">
            <label tabIndex=0 className="btn m-1"> {selectedOption->s} </label>
            <ul
              tabIndex=0
              className="dropdown-content menu p-2 shadow bg-surface1 text-text rounded-box ">
              <li onClick={_ => setSelectedOption(_ => "Neptune")}> <a> {"Neptune"->s} </a> </li>
              <li onClick={_ => setSelectedOption(_ => "Tinker")}> <a> {"Tinker"->s} </a> </li>
              <li onClick={_ => setSelectedOption(_ => "Cosmos")}> <a> {"Cosmos"->s} </a> </li>
            </ul>
          </div>
          <button onClick={onClickTranslate} className="btn bg-primary btn-primary">
            {if queryResult.isFetching {
              "Loading"
            } else {
              "Translate"
            }->s}
          </button>
        </div>
        <div
          className="flex side rounded-sm break-words shrink-0 min-h-full bg-surface1 font-mono p-2 grow text-text">
          {queryResult.data->Belt.Option.getWithDefault("")->s}
        </div>
      </div>
    </div>
  </div>
}
