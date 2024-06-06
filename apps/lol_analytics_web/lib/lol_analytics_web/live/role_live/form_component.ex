defmodule LoLAnalyticsWeb.RoleLive.FormComponent do
  use LoLAnalyticsWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage role records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="role-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <:actions>
          <.button phx-disable-with="Saving...">Save Role</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
