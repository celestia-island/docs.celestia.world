# Narrativa e Horizonte

## O formato do problema

Não estamos construindo um chatbot com um painel de controle aparafusado, e
também não estamos construindo um sistema de controle com um modelo de
linguagem aparafusado. As duas metades têm de ser um sistema só, porque no
momento em que um modelo pode mover equipamento físico todo item de conforto de
um produto de chat vira uma restrição de um sistema de controle: comportamento
determinístico, latência limitada, trilha de auditoria e uma forma de dizer não.

O argumento completo está em [Por que celestia-island](./why.md). Esta página é
a trajetória que decorre dele.

## Para onde vai

**Mais perto da máquina.** Hoje o ciclo vai do navegador de um operador a um
broker de protocolos e daí a um controlador. Cada passo mais perto do hardware
tem menos modelo dentro e menos rede dentro, terminando num laço que roda
localmente e não espera por uma ida e volta. Essa ordenação é o ponto: as partes
que não podem falhar são as partes que nunca chamam para fora.

**Autonomia local como horizonte.** A mesma ordenação vale onde quer que uma
ida e volta seja cara — um site remoto, um enlace intermitente, uma planta cujo
operador não está no chão de fábrica. Máquinas que não podem esperar por um
humano precisam decidir localmente, com segurança e de forma previsível: com a
autoridade de agir e a disciplina de recusar. Essa é uma direção de longo prazo,
não um plano com data, e é por isso que a camada de decisão, o modelo de mundo e
o portão de segurança são construídos como coisas separadas em vez de um
monólito.

**Reutilizável por construção.** Seja qual for o formato da próxima implantação,
ela deve ser montada a partir da mesma base de ativos em vez de reconstruída: o
protocolo de rede, o estado do mundo, os portões de segurança e o pipeline de
gravação são ativos compartilhados. Qualquer coisa que comece um novo precisa
passar por revisão de arquitetura. E nenhuma linha de produto depende jamais de
um núcleo não lançado — se o núcleo atrasar, a receita não atrasa.

## O que fica fixo

Qualquer que seja o horizonte, três coisas não se movem:

- **Segurança antes de autonomia.** Um sistema autônomo que não sabe recusar
  não é autônomo, é desprotegido. Veja os
  [Princípios de Segurança](./safety.md).
- **O ciclo permanece inteiro.** Toda capacidade é tão real quanto o ciclo
  fechado a que pertence — veja [O Ciclo Fechado](./closed-loop.md).
- **A estrutura vem primeiro.** A ordem entre dezenas de repositórios vem do
  camamento, não da disciplina do momento — veja a
  [Arquitetura em Camadas](./layered-architecture.md).

## Aprofundar-se

- [Por que celestia-island](./why.md) — a definição do problema por trás do horizonte.
- [Princípios de Segurança](./safety.md) — a semântica de tempo real em que a narrativa se apoia.
- [Mapa de Projetos](../ecosystem/projects.md) — onde mora o trabalho hoje.
