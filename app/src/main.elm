-- init : () -> (Model, Cmd Msg)
-- init _ = ({count = 0, versions= []},Cmd.none)

-- -- MODEL

-- type alias Model = {count : Int, versions: List Version}


-- type alias Version = {id : String, name: String}

-- -- UPDATE

-- type Msg = Increment | Decrement| ListVersionsRequest | ListVersionsDone (Result Http.Error (List Version))


-- update : Msg -> Model -> Model
-- update msg model =
--   case msg of
--     Increment ->
--       model + 1

--     Decrement ->
--       model - 1

-- -- HTTP

-- listVersions : Cmd Msg
-- listVersions = Http.request
--   {
--     method = "GET"
--     , headers =
--         [ Http.header "Authorization" ("Bearer " ++ "TOKEN")
--         , Http.header "Accept" "application/json"
--         , Http.header "Content-Type" "application/json"
--         ]
--     , url = "http://localhost:3000/listVersions"
--     , expect = Http.expectJson ListVersionsDone versionsDecoder
--     , body = Http.emptyBody
--     , timeout = Nothing
--     , tracker = Nothing
--   }

-- versionDecoder : Decoder Version
-- versionDecoder = Json.Decode.map2 Version 
--           (Json.Decode.field "id" Json.Decode.string)
--           (Json.Decode.field "name" Json.Decode.string)

-- versionsDecoder : Decoder (List Version)
-- versionsDecoder = Json.Decode.list versionDecoder


-- -- VIEW

-- view : Model -> Html Msg
-- view model =
--   div []
--     [ button [ onClick Decrement ] [ text "-" ]
--     , div [] [ text (String.fromInt model) ]
--     , button [ onClick Increment ] [ text "+" ]
--     ]

-- -- SUBSCRIPTION

-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--     Sub.none

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
    ( { name = "", articles = [], jwt = "JWT_TOKEN", versions = [] }, Cmd.none )



-- MODEL


type alias Model =
    { name : String, articles : List Article, jwt : String ,versions: List Version}


type Msg
    = GetProfile
    | GotProfile (Result Http.Error String)
    | GetArticles
    | GotArticles (Result Http.Error (List Article))
    | ListVersionsRequest 
    | ListVersionsDone (Result Http.Error (List Version))


type alias Article =
    { id : Int, title : String, author : String }

type alias Version = 
    { id : String, name: String}

-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetProfile ->
            ( model
            , getProfile
            )

        GotProfile result ->
            case result of
                Ok name ->
                    ( { model | name = name }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        GetArticles ->
            ( model
            , getArticles
            )

        GotArticles result ->
            case result of
                Ok articles ->
                    ( { model | articles = articles }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )
      
        ListVersionsRequest ->
              ( model
              , listVersions
              )

        ListVersionsDone result ->
            case result of
                Ok versions ->
                  ({model | versions = versions}, Cmd.none)
                
                Err _ ->
                  (model , Cmd.none)



-- VIEW


view model =
    div []
        [ button [ onClick GetProfile ] [ text "Get profile" ]
        , p [] [ text ("name: " ++ model.name) ]
        , button [ onClick GetArticles ] [ text "Get articles" ]
        , div []
            (articlesView
                model.articles
            )
        ]


articlesView : List Article -> List (Html msg)
articlesView articles =
    List.map
        (\article ->
            p []
                [ text
                    ("article: "
                        ++ "id: "
                        ++ String.fromInt article.id
                        ++ " title: "
                        ++ article.title
                        ++ " author: "
                        ++ article.author
                    )
                ]
        )
        articles



-- HTTP


getProfile : Cmd Msg
getProfile =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Authorization" ("Bearer " ++ "jwt")
            , Http.header "Accept" "application/json"
            , Http.header "Content-Type" "application/json"
            ]
        , url = "http://localhost:3000/profile"
        , expect = Http.expectJson GotProfile profileDecoder
        , body = Http.emptyBody
        , timeout = Nothing
        , tracker = Nothing
        }


profileDecoder : Decoder String
profileDecoder =
    field "name" string


getArticles : Cmd Msg
getArticles =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Authorization" ("Bearer " ++ "jwt")
            , Http.header "Accept" "application/json"
            , Http.header "Content-Type" "application/json"
            ]
        , url = "http://localhost:3000/articles"
        , expect = Http.expectJson GotArticles articlesDecoder
        , body = Http.emptyBody
        , timeout = Nothing
        , tracker = Nothing
        }


articleDecoder : Decoder Article
articleDecoder =
    Json.Decode.map3 Article
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "author" Json.Decode.string)


articlesDecoder : Decoder (List Article)
articlesDecoder =
    Json.Decode.list articleDecoder

listVersions : Cmd Msg
listVersions = Http.request
  {
    method = "GET"
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
versionDecoder = Json.Decode.map2 Version 
          (Json.Decode.field "id" Json.Decode.string)
          (Json.Decode.field "name" Json.Decode.string)

versionsDecoder : Decoder (List Version)
versionsDecoder = Json.Decode.list versionDecoder

-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none