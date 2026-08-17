# Web UI — a jornada começa na sua primeira frase

Duas superfícies, um fluxo: **arona** é o plano de controle headless (modelos, chaves,
registro, memória); **shittim-chest** é a bancada que você realmente vê (chat, painéis,
enxergar o mundo). Toda tela abaixo é uma visão da bancada — a bancada conversa com a
arona pela sua superfície RPC; a própria arona não inclui UI.

![Console do backend da bancada](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## Modelos: da fonte à invocação

Um modelo vai de "existir" a "pronto para o chat" em quatro estágios: **fonte** (o
catálogo de Providers — metadados, não inferência) → **registro** (um backend `ollama`
ou `external` compatível com OpenAI, persistido entre reinícios) → **implantação** (a
página Agents entrega um ID de modelo a um nó `arona-agent`; um nome de modelo vazio
escolhe automaticamente o nó mais ocioso) → **roteamento** (a página Models;
balanceamento de carga least-in-flight com afinidade de sessão). Backends externos
ficam fail-closed até a primeira sonda ter sucesso. A API exata de cada passo está
nos [arona docs](https://arona.docs.celestia.world).

## Identidade e medição

![Chaves de API da bancada](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Faturamento da bancada](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**Chaves de API** são a sua identidade — o gateway autentica `/v1/*` com tokens Bearer,
e tanto o `curl` quanto a bancada apresentam uma na entrada. **Uso** é um registro por
chamada, por chave: tokens, modelo, backend, custo. Os níveis de **Faturamento** definem
cotas (USD / tokens / limites de taxa); atingir uma delas é uma recusa direta, não uma
desaceleração.

## Chat e memória

![Chat da bancada](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

Cada turno de chat passa pelo serviço de memória — o selo em cada turno diz se
isso aconteceu. `Memory on` significa que memórias de longo prazo relevantes foram
injetadas antes do roteamento; `Memory offline` significa que o serviço de memória
está inalcançável (um sinal de honestidade, não um bug); `disabled` significa que
nada relevante foi encontrado. Turnos concluídos são extraídos em episódios e
persistidos, de modo que a memória sobrevive a reinícios — e entradas de write-back
podem ser apagadas diretamente da página Memory.

## Painéis e controle industrial

![Agentes da bancada](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

Um prompt cria um painel; o motor gera o layout e o persiste no armazenamento de
workspaces do scepter. A edição é estrutural — vínculos de fonte de dados, listas de
componentes, estados de conexão — não uma caixa-preta. Topology e Holographic são duas
visões da mesma frota; Reports adiciona busca semântica sobre o histórico. Escritas
industriais passam por validação de política e **aprovação humana** antes de qualquer
coisa se mover: o fim do ciclo fechado, e seu passo mais pesado.

![Login da bancada](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## Para ir mais fundo

- A referência completa da plataforma arona — [arona docs](https://arona.docs.celestia.world)
- A bancada de trabalho do chest e seus painéis — [shittim-chest docs](https://shittim-chest.docs.celestia.world)
- Agentes, workspaces e o gate de escrita industrial — [entelecheia docs](https://entelecheia.docs.celestia.world)
