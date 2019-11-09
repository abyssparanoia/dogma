module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (..)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { name = "", versions = [] }, Cmd.none )



-- MODEL


type alias Model =
    { name : String, versions : List Version }


type Msg
    = ListVersionsRequest
    | ListVersionsDone (Result Http.Error (List Version))


type alias Version =
    { id : String, name : String }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ListVersionsRequest ->
            ( model
            , listVersions
            )

        ListVersionsDone result ->
            case result of
                Ok versions ->
                    ( { model | versions = versions }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- VIEW


view model =
    div []
        [ button [ onClick ListVersionsRequest ] [ text "Get versions" ]
        , div []
            (versionsView
                model.versions
            )
        ]


versionsView : List Version -> List (Html msg)
versionsView versions =
    List.map
        (\version ->
            p []
                [ text
                    ("version: "
                        ++ "id: "
                        ++ version.id
                        ++ " name: "
                        ++ version.name
                    )
                ]
        )
        versions



-- HTTP


listVersions : Cmd Msg
listVersions =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Authorization" ("Bearer " ++ "TOKEN")
            , Http.header "Accept" "application/json"
            , Http.header "Content-Type" "application/json"
            ]
        , url = "https://us-central1-dogma-e74db.cloudfunctions.net/ListVersions"
        , expect = Http.expectJson ListVersionsDone versionsDecoder
        , body = Http.emptyBody
        , timeout = Nothing
        , tracker = Nothing
        }


versionDecoder : Decoder Version
versionDecoder =
    Json.Decode.map2 Version
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)


versionsDecoder : Decoder (List Version)
versionsDecoder =
    Json.Decode.list versionDecoder



-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
