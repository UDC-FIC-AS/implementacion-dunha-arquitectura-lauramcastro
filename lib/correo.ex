defmodule Correo do
  @moduledoc """
  Compoñente que simula un cliente de correo electrónico.

  É un proceso que cada certo tempo (aleatorio) "finxe" recibir un novo correo electrónico.

  Implementado con `GenServer` para poder supervisalo.
  """

  use GenServer

  require Logger

  # public API

  @doc """
  Inicia o cliente de correo electrónico.

  ## Exemplos:

    iex> Correo.start()
    :ok
    iex> Process.whereis(Correo) |> Process.alive?
    true
    iex> Correo.stop()

  """
  @spec start() :: :ok
  def start() do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
    :ok
  end

  @doc """
  Marca os correos recibidos como lidos.

  ## Exemplos:

     iex> Correo.start()
     iex> Correo.ler_pendentes()
     :ok
     iex> Correo.stop()

  """
  @spec ler_pendentes() :: :ok
  def ler_pendentes() do
    GenServer.cast(__MODULE__, :mark_read)
  end

  @doc """
  Para o cliente de correo electrónico.

  ## Exemplos:

     iex> Correo.start()
     iex> Correo.stop()
     iex> Process.whereis(Correo)
     nil

  """
  @spec stop() :: :ok
  def stop() do
    GenServer.stop(__MODULE__)
  end

  # GenServer callbacks
  @impl true
  def init(_init_arg) do
    Logger.info("GenServer Correo initialized")
    {:ok, _pid} = Task.start(fn -> send_fake_emails(__MODULE__) end)
    Logger.info("Send fake emails task scheduled")
    {:ok, 0}
  end

  # @impl true
  # def handle_call(:pop, _from, [head | tail]) do
  #   {:reply, head, tail}
  # end

  @impl true
  def handle_cast(:mark_read, unread_emails) do
    Logger.info("Marking all #{unread_emails} unread emails as read")
    # : comunicarse co repositorio para eliminar a notificación de correo sen ler
    {:noreply, 0}
  end

  @impl true
  def handle_info({:receive_emails, new_emails}, unread_emails) do
    Logger.info(
      "New #{new_emails} emails received, total unread is #{new_emails + unread_emails}"
    )

    # : comunicarse co repositorio para enviar/actualizar a notificación de correos por ler
    {:ok, _pid} = Task.start(fn -> send_fake_emails(__MODULE__) end)
    Logger.info("Send fake emails task scheduled")
    {:noreply, new_emails + unread_emails}
  end

  defp send_fake_emails(correo) do
    {new_emails, timeout} = {Enum.random(1..10), Enum.random(1_000..5_000)}
    Logger.info("Sending #{new_emails} new emails after #{timeout} seconds")
    Process.sleep(timeout)
    send(correo, {:receive_emails, new_emails})
  end
end
