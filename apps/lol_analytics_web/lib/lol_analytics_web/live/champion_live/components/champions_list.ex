defmodule LolAnalyticsWeb.ChampionLive.Components.ChampionsList do
  use Phoenix.Component

  attr :champion, :map

  defp render_champion(assigns) do
    detail_url =
      "/champions/#{assigns.champion.id}?team-position=#{assigns.champion.team_position}&patch=#{assigns.champion.patch_number}"

    ~H"""
    <tr>
      <td>
        <.link patch={detail_url}>
          <div class="flex cursor-pointer items-center gap-2">
            <img
              class="champion_image  rounded-md"
              src={"https://ddragon.leagueoflegends.com/cdn/14.11.1/img/champion/#{assigns.champion.image}"}
            />
            <%= @champion.name %>
          </div>
        </.link>
      </td>
      <td><%= @champion.win_rate %>%</td>
      <td><%= @champion.total_games %></td>
      <td>
        <img src={team_position_image(@champion.team_position)} class="w-5 h-5" />
      </td>
    </tr>
    """
  end

  attr :champions, :list
  attr :patch_number, :integer
  attr :position, :string

  def champions_list(assigns) do
    ~H"""
    <style>
      .champion_image {
        width: 50px;
      }
    </style>
    <table class="table w-full">
      <thead>
        <tr>
          <th scope="col" class="py-3 text-left text-gray-500 uppercase tracking-wider">
            Champion
          </th>
          <th scope="col" class="py-3 text-left text-gray-500 uppercase tracking-wider">
            Win rate
          </th>
          <th scope="col" class="py-3 text-left text-gray-500 uppercase tracking-wider">
            Total games
          </th>
          <th scope="col" class="py-3 text-left text-gray-500 uppercase tracking-wider">
            Position
          </th>
        </tr>
      </thead>
      <tbody>
        <%= for champion <- assigns.champions do %>
          <div class="cursor-pointer">
            <.link patch={"/champions/#{champion.id}?team-position=#{champion.team_position}&patch=#{champion.patch_number}"}>
              <.render_champion champion={champion} ) />
            </.link>
          </div>
        <% end %>
        <!-- table rows and cells go here -->
      </tbody>
    </table>
    """
  end

  defp team_position_image("BOTTOM"), do: "/images/lanes/bot.png"
  defp team_position_image("MIDDLE"), do: "/images/lanes/mid.png"
  defp team_position_image("TOP"), do: "/images/lanes/top.png"
  defp team_position_image("JUNGLE"), do: "/images/lanes/jungle.png"
  defp team_position_image("UTILITY"), do: "/images/lanes/utility.png"
end
