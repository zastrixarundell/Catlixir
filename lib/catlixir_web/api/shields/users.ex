defmodule CatlixirWeb.Controllers.Api.Shields.Users do
  use CatlixirWeb.Api.DataResponse

  def data do
    %{
      schemaVersion: 1,
      label: "Users",
      message: Catlixir.get_user_count!() |> to_string,
      color: "#7289DA",
      namedLogo: "Discord",
      style: "flat-square",
      logoColor: "#fff"
    }
  end
end
