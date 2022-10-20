defmodule Notificacions do
  @moduledoc """
  Compoñente que simula unha aplicación de notificacións.

  É un proceso que cada certo tempo (configurable no inicio) mostra alertas
  sobre a información de interese (configurable no inicio).

  Implementado con `GenServer` para poder supervisalo.
  """

  use GenServer

  require Logger

  # public API

  @doc """
  Inicia o cliente de notificacións.

  ## Exemplos:

    iex> Notificacions.start_link([])
    iex> Process.whereis(Notificacions) |> Process.alive?
    true
    iex> Notificacions.stop()

  """
  @spec start_link(list(term())) :: {:ok, pid()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @doc """
  Para o cliente de notificacións.

  ## Exemplos:

     iex> Notificacions.start_link([])
     iex> Notificacions.stop()
     iex> Process.whereis(Notificacions)
     nil

  """
  @spec stop() :: :ok
  def stop() do
    GenServer.stop(__MODULE__)
  end

  # GenServer callbacks
  @impl true
  def init(init_arg) do
    Logger.info("GenServer Notificacions initialized")
    period = Keyword.get(init_arg, :period, 3_000)
    tags = Keyword.get(init_arg, :tags, [:unread_emails])
    {:ok, _pid} = Task.start(fn -> check_new_data(__MODULE__, period) end)
    {:ok, {period, tags}}
  end

  @impl true
  def handle_info(:check, {period, tags}) do
    Enum.each(tags,
              fn t ->
                {:ok, n} = Dbus.get(t)
                Logger.info("[NOTIFICATION] #{t}: #{n}")
              end)

    {:ok, _pid} = Task.start(fn -> check_new_data(__MODULE__, period) end)
    {:noreply, {period, tags}}
  end

  defp check_new_data(notificacions, period) do
    Process.sleep(period)
    send(notificacions, :check)
  end
end
