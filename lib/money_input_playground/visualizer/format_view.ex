if Code.ensure_loaded?(Gettext.Backend) do
  defmodule MoneyInputPlayground.Visualizer.FormatView do
    @moduledoc false

    # Cross-locale format table. Take one parsed value and show how
    # `Localize.Number.to_string/2` (for `:number` mode) and
    # `Money.to_string/2` (for `:money` mode) render it in every
    # demo locale. Shows decimal-separator inversion,
    # symbol-position swap, native digit systems
    # (Arabic-Indic, Persian).

    use Localize.Message.Sigils, backend: MoneyInputPlayground.Gettext

    alias MoneyInputPlayground.Visualizer.Render

    def render(params, base) do
      amount = params.amount
      currency = params.currency
      mode = params.mode

      rows =
        for {locale, label} <- Render.locale_options() do
          case mode do
            :number ->
              decimal = parse_decimal(amount)

              {locale, label, decimal && Localize.Number.to_string!(decimal, locale: locale)}

            :money ->
              money =
                with decimal when not is_nil(decimal) <- parse_decimal(amount),
                     true <- currency not in [nil, ""] do
                  Money.new(currency, decimal)
                else
                  _ -> nil
                end

              {locale, label, money && Money.to_string!(money, locale: locale)}
          end
        end

      body = [
        "<section class=\"mi-card\">",
        "<h2>",
        ~t"Cross-locale formatting",
        "</h2>",
        "<p class=\"mi-desc\">",
        ~t"Same parsed value, every locale. Watch the decimal/grouping separators invert, the currency symbol position swap, and the native digit system change in Arabic and Persian.",
        "</p>",
        "<form method=\"get\" action=\"",
        Render.escape(base),
        "/format\" class=\"mi-form\">",
        Render.field(
          ~t"Amount (canonical form)",
          [
            "<input type=\"text\" name=\"amount\" value=\"",
            Render.escape(amount),
            "\" autocomplete=\"off\">"
          ],
          hint: ~t"Period as decimal, no grouping — e.g. 1234567.89"
        ),
        Render.field(~t"Mode", mode_select(mode)),
        Render.field(~t"Currency (money mode)", Render.currency_select("currency", currency)),
        "<div class=\"mi-actions\">",
        "<button class=\"mi-btn\" type=\"submit\">",
        ~t"Format across locales",
        "</button>",
        "</div>",
        "</form>",
        result_table(rows, mode),
        "</section>"
      ]

      Render.page(
        title: "Format",
        active: "format",
        base: base,
        body: body
      )
    end

    defp mode_select(selected) do
      options = [{"number", ~t"Plain number"}, {"money", ~t"Money"}]

      [
        "<select name=\"mode\">",
        Enum.map(options, fn {value, label} ->
          sel = if value == to_string(selected), do: " selected", else: ""

          [
            "<option value=\"",
            Render.escape(value),
            "\"",
            sel,
            ">",
            Render.escape(label),
            "</option>"
          ]
        end),
        "</select>"
      ]
    end

    defp result_table(rows, mode) do
      [
        "<table class=\"mi-table\">",
        "<thead><tr><th>",
        ~t"Locale",
        "</th><th>",
        Render.escape(
          if(mode == :money, do: "Money.to_string/2", else: "Localize.Number.to_string/2")
        ),
        "</th></tr></thead>",
        "<tbody>",
        Enum.map(rows, &result_row/1),
        "</tbody></table>"
      ]
    end

    defp result_row({locale, label, nil}) do
      [
        "<tr><td>",
        Render.escape(locale),
        " <small>(",
        Render.escape(label),
        ")</small></td>",
        "<td><em>",
        ~t"(invalid input)",
        "</em></td></tr>"
      ]
    end

    defp result_row({locale, label, formatted}) do
      [
        "<tr><td>",
        Render.escape(locale),
        " <small>(",
        Render.escape(label),
        ")</small></td>",
        "<td class=\"mi-mono\">",
        Render.escape(formatted),
        "</td></tr>"
      ]
    end

    defp parse_decimal(""), do: nil
    defp parse_decimal(nil), do: nil

    defp parse_decimal(value) when is_binary(value) do
      case Decimal.parse(value) do
        {decimal, ""} -> decimal
        _ -> nil
      end
    end
  end
end
