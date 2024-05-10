defmodule LoLAPI.Model.Info do
  alias LoLAPI.Model.Participant

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
