defmodule Scrapper.Api.Model.Info do
  alias Scrapper.Api.Model.Participant

  defstruct endOfGameResult: "",
            gameCreation: "",
            gameDuration: "",
            gameEndTimestamp: "",
            gameId: "",
            gameMode: "",
            gameName: "",
            gameStartTimestamp: "",
            gameType: "",
            gameVersion: "",
            mapId: "",
            participants: [%Participant{}],
            platformId: "",
            queueId: "",
            teams: "",
            tournamentCode: ""
end
