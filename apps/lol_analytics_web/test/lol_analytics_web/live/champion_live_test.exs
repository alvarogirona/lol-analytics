defmodule LoLAnalyticsWeb.ChampionLiveTest do
  use LoLAnalyticsWeb.ConnCase

  import Phoenix.LiveViewTest
  import LoLAnalytics.AccountsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_champion(_) do
    champion = champion_fixture()
    %{champion: champion}
  end

  describe "Index" do
    setup [:create_champion]

    test "lists all champions", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/champions")

      assert html =~ "Listing Champions"
    end

    test "saves new champion", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/champions")

      assert index_live |> element("a", "New Champion") |> render_click() =~
               "New Champion"

      assert_patch(index_live, ~p"/champions/new")

      assert index_live
             |> form("#champion-form", champion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#champion-form", champion: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/champions")

      html = render(index_live)
      assert html =~ "Champion created successfully"
    end

    test "updates champion in listing", %{conn: conn, champion: champion} do
      {:ok, index_live, _html} = live(conn, ~p"/champions")

      assert index_live |> element("#champions-#{champion.id} a", "Edit") |> render_click() =~
               "Edit Champion"

      assert_patch(index_live, ~p"/champions/#{champion}/edit")

      assert index_live
             |> form("#champion-form", champion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#champion-form", champion: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/champions")

      html = render(index_live)
      assert html =~ "Champion updated successfully"
    end

    test "deletes champion in listing", %{conn: conn, champion: champion} do
      {:ok, index_live, _html} = live(conn, ~p"/champions")

      assert index_live |> element("#champions-#{champion.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#champions-#{champion.id}")
    end
  end

  describe "Show" do
    setup [:create_champion]

    test "displays champion", %{conn: conn, champion: champion} do
      {:ok, _show_live, html} = live(conn, ~p"/champions/#{champion}")

      assert html =~ "Show Champion"
    end

    test "updates champion within modal", %{conn: conn, champion: champion} do
      {:ok, show_live, _html} = live(conn, ~p"/champions/#{champion}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Champion"

      assert_patch(show_live, ~p"/champions/#{champion}/show/edit")

      assert show_live
             |> form("#champion-form", champion: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#champion-form", champion: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/champions/#{champion}")

      html = render(show_live)
      assert html =~ "Champion updated successfully"
    end
  end
end
