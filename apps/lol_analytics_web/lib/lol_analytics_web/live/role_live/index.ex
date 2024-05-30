defmodule LoLAnalyticsWeb.RoleLive.Index do
  use LoLAnalyticsWeb, :live_view

  alias LoLAnalytics.Accounts
  alias LoLAnalytics.Accounts.Role

  @roles ["ALL", "TOP", "MIDDLE", "JUNGLE", "UTILITY", "BOTTOM"]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :roles, @roles)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Roles")
    |> assign(:role, nil)
  end

  @impl true
  def handle_info({LoLAnalyticsWeb.RoleLive.FormComponent, {:saved, role}}, socket) do
    {:noreply, stream_insert(socket, :roles, role)}
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   role = Accounts.get_role!(id)
  #   {:ok, _} = Accounts.delete_role(role)

  #   {:noreply, stream_delete(socket, :roles, role)}
  # end
end
