![example workflow](https://github.com/UDC-FIC-AS/implementacion-dunha-arquitectura-lauramcastro/actions/workflows/elixir.yml/badge.svg)

# Arquitectura do Software
## Segunda práctica (curso 2021/2022)
### Implementación dunha arquitectura

A arquitectura escollida para esta demostración é a **arquitectura en
repositorio**.

Esta demostración de práctica emula o exemplo DBus: un sistema no que diferentes
aplicacións de escritorio teñen interese en intercambiar información
moitos-a-moitos, mantendo a súa total independencia. Para favorecer esa
independencia estrutúranse seguindo esta arquitectura, na que un compoñente
central é o que recibe a información que cada cliente decide enviarlle, e de
onde cada cliente, cando o considera, consulta a información que poida estar
dispoñible. Neste exemplo concreto, o repositorio non será persistente.

### Configuración e funcionamento

Este proxecto creouse con `mix new PATH --app NOME --sup`. Unha vez
descarregado, configúranse as dependencias con `mix deps.get` e execútanse as
probas con `mix test`. O sistema arráncase con `mix run --no-halt`.
A documentación en formato HTML pódese obter con `mix docs`.

Este proxecto ten soporte para [Credo](https://github.com/rrrene/credo) e
[Dialyxir/Dialyzer](https://github.com/jeremyjh/dialyxir).
