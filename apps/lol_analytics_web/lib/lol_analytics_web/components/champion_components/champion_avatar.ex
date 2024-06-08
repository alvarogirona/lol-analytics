defmodule LolAnalyticsWeb.ChampionComponents.ChampionAvatar do
  use Phoenix.Component

  attr :id, :integer, required: true
  attr :image, :string, required: true
  attr :name, :string, required: true

  def champion_avatar(assigns) do
    ~H"""
    <div class="flex flex-col w-40">
      <img src={@image} alt="champion-icon" />
      <p class="w-full text-center"><%= @name %></p>
    </div>
    """
  end
end
