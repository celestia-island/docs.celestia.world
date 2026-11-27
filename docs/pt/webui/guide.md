# Web UI — a jornada a partir da sua primeira frase

Uma conta, uma chave, uma conversa. Esta página percorre o mesmo caminho que o
produto percorre — um modelo fica disponível, uma chave o autentica, um turno
roda com memória e um painel o transforma em algo que você pode operar.

![O dashboard](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## Modelos: da fonte à invocação

Um modelo vai de "existir" a "pronto para o chat" em quatro estágios: **fonte**
(o catálogo de provedores — metadados, não inferência) → **registro** (um
backend, seja um runtime local ou qualquer serviço compatível com OpenAI; ele
sobrevive a reinícios) → **implantação** (um ID de modelo é entregue a um nó,
que o baixa e inicia o runtime) → **roteamento** (balanceamento de carga
least-in-flight com afinidade de sessão). Um backend que ainda não passou pela
primeira sonda de saúde é recusado em vez de testado.

## Identidade e medição

![Chaves de API](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Uso e faturamento](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**As chaves de API** são a sua identidade — o gateway autentica com um token
Bearer, e tanto o `curl` quanto a bancada apresentam uma na entrada. **O uso**
é um registro por chamada e por chave: tokens, modelo, backend, custo. Os
níveis de **faturamento** definem cotas; atingir uma delas é uma recusa direta,
não uma desaceleração.

## Chat e memória

![Chat](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

Cada turno passa pelo serviço de memória — o selo em cada turno diz se isso
aconteceu. `Memory on` significa que memórias de longo prazo relevantes foram
injetadas antes do roteamento; `Memory offline` significa que o serviço de
memória está inalcançável (um sinal de honestidade, não um bug); `disabled`
significa que nada relevante foi encontrado. Os turnos concluídos são extraídos
e persistidos, então a memória sobrevive a reinícios — e as entradas de
writeback podem ser apagadas diretamente na página de Memória.

## Painéis e controle industrial

![Agentes](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

Um único prompt cria um painel; o motor gera o layout e o persiste no
workspace. A edição é estrutural — vínculos de fonte de dados, listas de
componentes, estados de conexão —, não uma caixa-preta. Topology e Holographic
são duas vistas da mesma frota; Reports acrescenta busca semântica sobre o
histórico. As escritas industriais passam por validação de política e por
**aprovação humana** antes de qualquer movimento: o fim do ciclo fechado, e o
seu passo mais pesado.

![Entrada](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## Aprofundar-se

- [Arona](../platforms/arona.md) — o gateway e o painel de implantação.
- [Shittim Chest](../platforms/chest.md) — a bancada e os seus painéis.
- [Entelecheia](../platforms/entelecheia.md) — agentes, workspaces e o portão de escrita industrial.
