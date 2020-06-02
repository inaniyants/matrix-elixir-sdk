defmodule MatrixSDK.Request do
  @moduledoc """
  Provides functions which return a struct containing the data necessary for
  each HTTP request.
  """

  @enforce_keys [:method, :base_url, :path]
  defstruct([:method, :base_url, :path, headers: [], body: %{}])

  @type method :: atom
  @type base_url :: binary
  @type path :: binary
  @type headers :: [{binary, binary}]
  @type body :: any

  @type t :: %__MODULE__{
          method: method(),
          base_url: base_url(),
          path: path(),
          headers: headers(),
          body: body()
        }

  @doc """
  Returns a `%Request{}` struct used to get the versions of the Matrix specification
  supported by the server.

  ## Examples

      iex> MatrixSDK.Request.spec_versions("https://matrix.org")
      %MatrixSDK.Request{
        base_url: "https://matrix.org",
        body: %{},
        headers: [],
        method: :get,
        path: "/_matrix/client/versions"
      }
  """
  @spec spec_versions(base_url()) :: __MODULE__.t()
  def spec_versions(base_url),
    do: %__MODULE__{method: :get, base_url: base_url, path: "/_matrix/client/versions"}

  @doc """
  Returns a `%Request{}` struct used to  get discovery information about the domain. 

  ## Examples

      iex> MatrixSDK.Request.server_discovery("https://matrix.org")
      %MatrixSDK.Request{
        base_url: "https://matrix.org",
        body: %{},
        headers: [],
        method: :get,
        path: "/.well-known/matrix/client"
      }
  """
  @spec server_discovery(base_url()) :: __MODULE__.t()
  def server_discovery(base_url),
    do: %__MODULE__{method: :get, base_url: base_url, path: "/.well-known/matrix/client"}

  @doc """
  Returns a `%Request{}` struct used to  get the homeserver's supported login types to authenticate users. 

  ## Examples

      iex> MatrixSDK.Request.login("https://matrix.org")
      %MatrixSDK.Request{
        base_url: "https://matrix.org",
        body: %{},
        headers: [],
        method: :get,
        path: "/_matrix/client/r0/login"
      }
  """
  @spec login(base_url()) :: __MODULE__.t()
  def login(base_url),
    do: %__MODULE__{method: :get, base_url: base_url, path: "/_matrix/client/r0/login"}

  def login(base_url, username, password),
    do: %__MODULE__{
      method: :post,
      base_url: base_url,
      path: "/_matrix/client/r0/login",
      body: %{
        type: "m.login.password",
        user: username,
        password: password
      }
    }

  def logout(base_url, token),
    do: %__MODULE__{
      method: :post,
      base_url: base_url,
      path: "/_matrix/client/r0/logout",
      headers: [{"Authorization", "Bearer " <> token}]
    }

  def register_user(base_url),
    do: %__MODULE__{
      method: :post,
      base_url: base_url,
      path: "/_matrix/client/r0/register?kind=guest"
    }

  def register_user(base_url, username, password),
    do: %__MODULE__{
      method: :post,
      base_url: base_url,
      path: "/_matrix/client/r0/register",
      body: %{
        auth: %{type: "m.login.dummy"},
        username: username,
        password: password
      }
    }

  def room_discovery(base_url),
    do: %__MODULE__{method: :get, base_url: base_url, path: "/_matrix/client/r0/publicRooms"}
end
