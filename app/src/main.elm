import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (..)


main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model = Int

init : Model
init =
  0

type alias Version = {id : String, name: String}

-- UPDATE

type Msg = Increment | Decrement| ListVersionsRequest | ListVersionsDone (Result Http.Error (List Version))


update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

-- HTTP

listVersions : Cmd Msg
listVersions = Http.request
  {
    method = "GET"
    , headers =
        [ Http.header "Authorization" ("Bearer " ++ "TOKEN")
        , Http.header "Accept" "application/json"
        , Http.header "Content-Type" "application/json"
        ]
    , url = "http://localhost:3000/listVersions"
    , expect = Http.expectJson ListVersionsDone versionsDecoder
    , body = Http.emptyBody
    , timeout = Nothing
    , tracker = Nothing
  }

versionDecoder : Decoder Version
versionDecoder = Json.Decode.map3 Version 
          (Json.Decode.field "id" Json.Decode.string)
          (Json.Decode.field "name" Json.Decode.string)

versionsDecoder : Decoder (List Version)
versionsDecoder = Json.Decode.list versionDecoder


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]