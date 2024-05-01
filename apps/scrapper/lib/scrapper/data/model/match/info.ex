defmodule Scrapper.Data.Model.Match.Info do
  alias Scrapper.Data.Model.Match.Participant

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
