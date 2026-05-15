defmodule MoneyInputPlayground.Gettext do
  @moduledoc """
  Gettext backend for the visualizer's UI strings.

  Hosts the message catalog used by `MoneyInputPlayground.Visualizer`
  and its view modules — headings, descriptions, table headers,
  button labels, hints. The catalog lives in `priv/gettext/` and
  ships English source plus translations for the locales
  pre-bundled with the playground.

  The components in the `ex_money_input` library use their own
  Gettext backend (`Money.Input.Gettext`) for the picker's
  internal strings — `:ex_money_input` is the catalog for those.
  Hosts that combine the picker and the visualizer end up with
  two catalogs, which is fine: Gettext supports multiple
  backends side by side.

  Uses `Localize.Gettext.Interpolation` so all messages can use
  MF2 (MessageFormat 2) syntax for placeholders, plural/select
  selectors, and inline markup — consistent with the rest of the
  Localize ecosystem.
  """
  use Gettext.Backend,
    otp_app: :money_input_playground,
    interpolation: Localize.Gettext.Interpolation
end
