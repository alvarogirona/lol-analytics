defmodule LoLAnalyticsWeb.ChampionLive.FormComponent do
  use LoLAnalyticsWeb, :live_component

  alias LoLAnalytics.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage champion records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="champion-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Champion</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{champion: champion} = assigns, socket) do
    changeset = Accounts.change_champion(champion)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"champion" => champion_params}, socket) do
    changeset =
      socket.assigns.champion
      |> Accounts.change_champion(champion_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"champion" => champion_params}, socket) do
    save_champion(socket, socket.assigns.action, champion_params)
  end

  defp save_champion(socket, :edit, champion_params) do
    case Accounts.update_champion(socket.assigns.champion, champion_params) do
      {:ok, champion} ->
        notify_parent({:saved, champion})

        {:noreply,
         socket
         |> put_flash(:info, "Champion updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_champion(socket, :new, champion_params) do
    case Accounts.create_champion(champion_params) do
      {:ok, champion} ->
        notify_parent({:saved, champion})

        {:noreply,
         socket
         |> put_flash(:info, "Champion created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
