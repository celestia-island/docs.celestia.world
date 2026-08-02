# Início Rápido

Percorra o [ciclo fechado](../philosophy/closed-loop.md) em cerca de 30
minutos. Os endereços exatos dependem da sua implantação; pergunte ao seu
administrador pela URL do painel e pelo seu convite.

## 1. Obtenha uma conta

O registro é fechado por convite: o primeiro usuário de uma implantação
torna-se o admin e, depois disso, o auto-registro trava. Entre em contato com
os mantenedores para obter um convite e registre-se pelo painel da Arona
(`https://arona.celestia.world` numa implantação pública, ou
`http://<host>:8420` internamente).

## 2. Crie uma API key

No painel da Arona, crie uma API key para a sua conta. Essa key é a sua
identidade para tudo o que vem a seguir — gerenciamento de modelos, backends
de chat e operações de agentes.

## 3. Implante um modelo

Pelo painel, escolha um runtime de modelo (por exemplo, um modelo baseado em
Ollama), implante-o num nó e vincule-o a um backend de chat. O painel mostra
saúde e uso; medição e preços são tratados pela camada de plataforma.

## 4. Converse e execute agentes

Abra o [shittim-chest](https://shittim-chest.docs.celestia.world) (aplicativo
desktop ou webUI), conecte-se com a sua API key e inicie uma conversa. Para
trabalho multiagente, o runtime scepter do entelecheia orquestra os agentes
por trás da mesma interface; os logs de agentes e as chamadas de ferramentas
são visíveis na UI.

## 5. Controle equipamentos industriais

Com o [evernight](https://evernight.docs.celestia.world) em execução, conecte
uma ponte de protocolo (Modbus, S7comm, OPC UA), assine a telemetria e — após
validação de política e confirmação humana — emita escritas. Durante a beta
interna, esse segmento roda contra equipamento simulado ou de laboratório; a
cadeia de segurança é idêntica de qualquer forma.

## 6. Verifique

Confira o status de supervisão (serviços gerenciados pelo malkuth), inspecione
os registros de uso e reporte problemas pelos canais do
[guia da beta](./beta-guide.md). Se algo estiver quebrado, o ciclo não está
pronto — diga-nos onde.

## E se algo falhar?

- **Um serviço está fora** — o malkuth deveria tê-lo reiniciado; confira a
  página de status do serviço ou os logs.
- **O painel não abre** — verifique se você está no host/porta corretos e se o
  deployer habilitou o webUI embutido.
- **Memória ou recall indisponíveis** — a resposta da API e a UI marcam isso
  explicitamente (`memory: "offline"`); o chat continua funcionando sem isso.

## Aprofundar-se

- [Guia do Beta Fechado](./beta-guide.md) — o que a beta cobre e como reportar bugs.
- [O Ciclo Fechado](../philosophy/closed-loop.md) — a filosofia por trás desses passos.
