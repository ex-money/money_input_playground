defmodule MoneyInputPlaygroundTest do
  use ExUnit.Case, async: true

  import Plug.Test
  import Plug.Conn

  @opts MoneyInputPlayground.Router.init([])

  describe "host-level routes" do
    test "GET /favicon.ico returns the money logo PNG" do
      conn = conn(:get, "/favicon.ico") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 200
      assert ["image/png" <> _] = get_resp_header(conn, "content-type")
      assert <<0x89, "PNG", _::binary>> = conn.resp_body
    end

    test "GET /robots.txt disallows everything" do
      conn = conn(:get, "/robots.txt") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 200
      assert conn.resp_body =~ "Disallow: /"
    end

    test "GET /healthz returns ok" do
      conn = conn(:get, "/healthz") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 200
      assert conn.resp_body == "ok"
    end
  end

  describe "visualizer routes (forwarded)" do
    test "GET / redirects to /input" do
      conn = conn(:get, "/") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["/input"]
    end

    test "GET /input returns the components page" do
      conn = conn(:get, "/input") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 200
      assert conn.resp_body =~ "Money Input Components"
    end

    test "GET /parse returns the cross-locale parse table" do
      conn = conn(:get, "/parse") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 200
      assert conn.resp_body =~ "Cross-locale parsing"
    end

    test "GET /format returns the cross-locale format table" do
      conn = conn(:get, "/format") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 200
      assert conn.resp_body =~ "Cross-locale formatting"
    end

    test "GET /locale returns the locale-data table" do
      conn = conn(:get, "/locale") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 200
      assert conn.resp_body =~ "Locale display data"
    end

    test "GET /assets/style.css serves CSS" do
      conn = conn(:get, "/assets/style.css") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 200
      assert conn.resp_body =~ ".mi-header"
    end

    test "GET /assets/money_input.css serves the component CSS" do
      conn = conn(:get, "/assets/money_input.css") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 200
      assert conn.resp_body =~ ".money-input-wrapper"
    end

    test "GET /assets/money_input.js serves the hooks JS" do
      conn = conn(:get, "/assets/money_input.js") |> MoneyInputPlayground.Router.call(@opts)

      assert conn.status == 200
      assert conn.resp_body =~ "CurrencyPicker"
    end
  end
end
