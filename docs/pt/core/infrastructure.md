# Infraestrutura Central — Auth, RPC e Fundações

Toda plataforma que você usa repousa sobre a mesma fundação. Leia isto uma vez
e os guias de plataforma se encaixam: kirino (auth de confiança zero e RBAC),
plana (tipos de protocolo e facilidades de plataforma) e hikari (a biblioteca
de componentes de UI).

## Autenticação e autorização (kirino)

- **Identidade**: hash de senhas, tokens de sessão com vidas curtas, limite de
  taxa de login e bloqueio de conta. Os algoritmos e os seus parâmetros estão
  documentados na [documentação do próprio kirino](https://kirino.docs.celestia.world),
  não aqui.
- **RBAC**: as permissões são hierárquicas e resolvidas por chamador; papéis
  agrupam permissões (um admin vê tudo, um viewer é somente leitura). As
  atribuições persistem no banco de dados da plataforma.
- **Delegação**: um serviço que fica atrás de outro não autentica ninguém por si
  — a camada de autenticação está sempre a montante, e a identidade do chamador
  é repassada apenas para isolamento de workspace.

## Protocolo e RPC (plana)

- O tráfego da plataforma é **JSON-RPC 2.0**, sobre WebSocket para streaming e
  sobre HTTP POST para requisição/resposta. Os nomes de método são
  `<Domain>.<Action>`.
- Os tipos de rede são a única fonte de verdade do protocolo e moram no plana;
  os repositórios a jusante fixam uma versão lançada em vez de fazer um fork de
  uma cópia.
- As notificações não têm `id` e empurram eventos como pedaços de streaming e
  atualizações de painel; as requisições carregam um `id` que a resposta ecoa.
- As superfícies com estado seguem o mesmo padrão em todo lugar: o servidor é
  autoritativo, os clientes declaram o que estão vendo e o servidor transmite a
  diferença.

## Medição e preços (plana)

O uso é medido por API key e precificado a partir de uma única tabela canônica
compartilhada por todos os serviços: tokens de prompt e de conclusão, estimativa
de custo e aplicação de cotas são o mesmo cálculo em todo produto.

## Componentes de UI (hikari)

A biblioteca de componentes fornece os botões, selos, tabelas, modais e
diálogos de confirmação que toda webUI usa, para que uma tela pareça e se
comporte do mesmo jeito onde quer que esteja montada. Componentes
compartilhados são levados a montante para cá em vez de reimplementados por
repositório.

## Regras de dependência

- Camada 0: kirino (auth) → Camada 1: plana (protocolo/fundações) → Camada 2:
  hikari (UI) → Camada 3: serviços (arona, chest, entelecheia, evernight).
- Os serviços implementam apenas lógica de negócio; capacidades compartilhadas
  vêm de montante. Dependências entre repositórios usam referências git ou tags
  fixadas — nunca dependências de caminho local.
