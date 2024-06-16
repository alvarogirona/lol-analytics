defmodule LolAnalyticsWeb.PatchSelector do
  use LoLAnalyticsWeb, :live_component

  def mount(socket) do
    patches =
      LolAnalytics.Dimensions.Patch.PatchRepo.list_patches()
      |> Enum.sort(fn %{patch_number: p1}, %{patch_number: p2} ->
        [_, minor_1] = String.split(p1, ".") |> Enum.map(&String.to_integer/1)
        [_, minor_2] = String.split(p2, ".") |> Enum.map(&String.to_integer/1)

        p1 > p2 && minor_1 > minor_2
      end)

    patch_numbers = Enum.map(patches, & &1.patch_number)
    [last_patch | _] = patch_numbers

    send(self(), %{patch: last_patch})

    socket =
      assign(socket, :patch_numbers, patch_numbers)
      |> assign(:patch_form, to_form(%{"selected_patch" => last_patch}))

    {:ok, socket}
  end

  @impl true
  def handle_event("selected_patch", %{"patch" => patch} = unsigned_params, socket) do
    send(self(), %{patch: patch})

    {:noreply, assign(socket, :selected_patch, patch)}
  end

  def render(assigns) do
    ~H"""
    <div phx-feedback-for={@id}>
      <style>
        .patch-selector {
          width: 100px;
        }
      </style>
      <.form for={@patch_form} phx-change="validate" phx-target={@myself} phx-submit="save">
        <div class="flex gap-4">
          <p class="my-auto">Patch</p>
          <select
            phx-change="selected_patch"
            id="patch"
            name="patch"
            class="patch-selector block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
          >
            <%= for patch <- @patch_numbers do %>
              <option key={patch} phx-click="select-patch" name={patch} value={patch}>
                <%= patch %>
              </option>
            <% end %>
          </select>
        </div>
      </.form>
    </div>
    """
  end
end
