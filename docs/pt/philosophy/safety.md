# Princípios de Segurança

Controle industrial é segurança crítica: uma falha pode mover equipamento
físico. A segurança, portanto, é projetada na arquitetura, não acrescentada no
final.

## 1. O modelo nunca toca o mundo diretamente

Um modelo é um planejador, não um atuador. Ele pode pedir que um trabalho seja
feito; não pode executá-lo. Entre o modelo e o equipamento ficam uma sandbox,
uma verificação de política e — para ações irreversíveis — um humano. O modelo
não pode inventar comportamento fora das primitivas que a plataforma expõe.

## 2. Profundidade de segurança em múltiplas camadas

Toda operação que possa afetar o mundo físico passa pela cadeia completa, em
ordem:

1. **Revisão da instrução** — o que foi ordenado ao modelo
2. **Execução em sandbox** — o código roda isolado, com restrições de política
3. **Validação de política** — o portão de escrita: a operação obedece à política?
4. **Confirmação humana** — a palavra final para ações irreversíveis
5. **Trilha de auditoria** — tudo é registrado, nada fica silencioso

Nenhuma camada confia na anterior. Pular uma delas é um defeito, não um atalho.

## 3. Criticalidade mista: o tempo real nunca depende do modelo

O sistema é dividido por tempo de resposta, e **quanto mais rápida uma camada,
menos ela depende de um modelo estar online**:

| Camada | O que faz | Dependência de LLM |
| --- | --- | --- |
| Cognição | planejamento, conversa, orquestração | consumidor primário |
| Estado do mundo | o que é verdade agora, não o que foi dito | opcional |
| Reativa | reações locais na própria máquina | nenhuma |
| Controle em tempo real | intertravamentos e o laço rápido | nunca |

Se o modelo fica offline, a plataforma degrada com elegância: ou um estado
seguro, ou a continuação da execução de uma trajetória já aprovada. O controle
nunca espera por uma chamada de rede.

## 4. Confiança zero, falha fechada

- Autenticação e autorização vêm do
  [kirino](https://github.com/celestia-island/kirino), a camada de autenticação
  de confiança zero do ecossistema. Nada é confiável só porque está dentro da
  rede.
- O registro é fechado por convite por padrão; o primeiro usuário de uma
  implantação torna-se o admin, depois disso o auto-registro trava.
- Tudo o que não é explicitamente permitido é negado. Onde um serviço tem um
  modo *mock*, ele fica desligado por padrão e se recusa a rodar em implantações
  de produção sem uma flag explícita.

## 5. As falhas são ruidosas

Degradação silenciosa é tratada como bug de segurança. Se o recall de memória
falha, um backend está inalcançável ou uma implantação falha, a resposta da API
e a UI precisam dizer isso explicitamente — sem sucesso falso, sem cair para
dados fingidos. Essa regra existe porque incidentes reais mostraram que as
falhas invisíveis são as perigosas.

## Aprofundar-se

- [O Ciclo Fechado](./closed-loop.md) — onde os portões de segurança ficam no fluxo.
- [Arquitetura em Camadas](./layered-architecture.md) — as camadas que a segurança atravessa.
- [Documentação do kirino](https://kirino.docs.celestia.world) — o modelo de autenticação em detalhe.
