defmodule LolAnalyticsWeb.ChampionComponents.ChampionAvatar do
  use Phoenix.Component

  attr :id, :integer, required: true
  attr :image, :string, required: true
  attr :name, :string, required: true
  attr :width, :integer, default: 100
  attr :height, :integer, default: 100

  def champion_avatar(assigns) do
    ~H"""
    <style>
      .champion-avatar {
       width: 100px;
       height: 100px;
      }
    </style>
    <div class="flex flex-col w-40">
      <img src={@image} class="champion-avatar rounded-xl" alt="champion-icon" />
    </div>
    """
  end
end
