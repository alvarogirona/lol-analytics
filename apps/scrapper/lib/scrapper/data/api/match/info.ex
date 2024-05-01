defmodule Scrapper.Data.Api.Model.Match.Info do
  alias Scrapper.Data.Api.Model.Match.Participant

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
