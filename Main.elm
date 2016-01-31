module Main (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import Task
import StartApp
import Time exposing (Time)


type alias Model =
  { time : Time
  , timestamp : Time
  }


init : ( Model, Effects Action )
init =
  ( { time = 0
    , timestamp = 0
    }
  , Effects.none
  )


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , view = view
    , update = update
    , inputs = [ Signal.map UpdateTime <| Time.every Time.millisecond ]
    }


type Action
  = DoNothing
  | UpdateTime Time
  | UpdateTimestamp


update : Action -> Model -> ( Model, Effects Action )
update action model =
  ( case action of
      DoNothing ->
        model

      UpdateTime time ->
        { model | time = time }

      UpdateTimestamp ->
        { model | timestamp = model.time + 5000 }
  , Effects.none
  )


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ p [] [ text <| "current time: " ++ toString model.time ]
    , p [] [ text <| "timestamp: " ++ toString model.timestamp ]
    , if model.time - model.timestamp > 0 then
        button [ onClick address UpdateTimestamp ] [ text "wait 5 seconds" ]
      else
        node "noscript" [] []
    ]


main : Signal Html
main =
  app.html



--- PORTS


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
