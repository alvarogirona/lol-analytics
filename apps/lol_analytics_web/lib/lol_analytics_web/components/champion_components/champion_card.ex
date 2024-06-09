defmodule LolAnalyticsWeb.ChampionComponents.ChampionCard.Props do
  defstruct [:id, :win_rate, :image, :name, :team_position, :wins, :total_games]
end

defmodule LolAnalyticsWeb.ChampionComponents.ChampionCard do
  use Phoenix.Component

  alias LolAnalyticsWeb.ChampionComponents.ChampionCard.Props

  attr :props, Props, default: %Props{}

  def champion_card(assigns) do
    ~H"""
    <.link patch={"/champions/#{@props.id}"}>
      <div class="flex flex-col rounded-xl bg-clip-border overflow-hidden bg-gray-200">
        <div class="flex flex-column overflow-hidden">
          <div class=" px-4 py-1 opacity-80 gap-2 absolute z-10 align-bottom flex mx-auto bg-black w-max">
            <img src={team_position_image(@props.team_position)} class="w-5 h-5" />
            <h3 class="text-white"><%= @props.name %></h3>
          </div>
          <img
            class="static w-40 h-40"
            src={"https://ddragon.leagueoflegends.com/cdn/14.11.1/img/champion/#{@props.image}"}
          />
        </div>
        <div class="py-1" />
        <div class="pl-2">
          <h3>Win rate: <%= @props.win_rate %></h3>
          <h3>Wins: <%= @props.wins %> / <%= @props.total_games %></h3>
        </div>
        <div class="py-1" />
      </div>
    </.link>
    """
  end

  defp team_position_image("BOTTOM"), do: "/images/lanes/bot.png"
  defp team_position_image("MIDDLE"), do: "/images/lanes/mid.png"
  defp team_position_image("TOP"), do: "/images/lanes/top.png"
  defp team_position_image("JUNGLE"), do: "/images/lanes/jungle.png"
  defp team_position_image("UTILITY"), do: "/images/lanes/utility.png"
end
