# Narrativa e Horizonte

## A latência é o destino

Uma ida e volta de sinal leva **2,6 segundos** até a Lua e **de 6 a 44
minutos** até Marte. Máquinas tão longe da Terra não podem esperar instruções
de um humano. Elas precisam tomar decisões **localmente, com segurança e
previsibilidade** — com a autoridade para agir e a disciplina para recusar.

Esse é o horizonte para o qual este ecossistema é construído. Tudo o que
construímos hoje para o controle industrial é escolhido de modo a ter a
*mesma forma* que um robô autônomo lunar ou marciano precisará:

- uma **camada de decisão de agentes** que planeja e orquestra
- um **modelo de mundo** que sabe o que está acontecendo agora
- um **portão de segurança** capaz de dizer não, respaldado por controle em
  tempo real que nunca depende da rede

A Lua não é uma história de marketing: é a razão pela qual as camadas existem.

## O caminho

O ecossistema avança por portões — uma fase só é desbloqueada quando a
anterior cumpre os seus critérios de saída:

| Fase | Alvo | Critérios de saída |
| --- | --- | --- |
| **Beta interna** | agora | Zero problemas de segurança P0; o ciclo completo passa nos testes de integração; um novo usuário percorre registro → key → chat em 30 minutos |
| **Beta pública** | 2026 | Registro aberto; documentação pública, downloads e páginas legais; revisão de segurança independente |
| **Y1 — Linhas industriais** | 2027-08 | Demonstração em linha de produção com PLC + MCU reais: sensoriamento a 100 Hz, ciclo fechado a 10 Hz, pacotes de implantação, testes de aceite |
| **Y3 — Instalações corporificadas** | 2029-08 | Pacote replicável de instalação corporificada (estado do mundo + camada de políticas + site de referência), fixado à forma *industrial embodied* |
| **Y5 — Aeroespacial** | 2031-08 | Proposta completa de software/hardware mais pelo menos uma prova em órbita ou em voo — sem herança, sem vendas |
| **Y5+ — Lunar/Marciano** | 2031+ | Narrativa de autonomia, parcerias de pesquisa, white paper |

## Quatro trilhas compartilham uma única base de ativos

1. **Trilha B — Controle industrial** ([evernight](https://github.com/celestia-island/evernight) em palco principal): pipelines de sensores, gravação/replay, loops rápidos, nós embarcados.
2. **Trilha E — Inteligência corporificada**: um serviço de estado do mundo, uma camada de políticas com pequenos modelos locais, visualização de gêmeos digitais.
3. **Trilha K — Núcleo de tempo real kei**: um kernel determinístico com uma camada de personalidade ABI Linux — a resposta de longo prazo para execução limitada e previsível.
4. **Trilha S — Aeroespacial**: redundância tripla modular em nível de sistema, herança de voo, trilha de certificação.

Uma disciplina mantém todas as trilhas unidas: **protocolo de fio, estado do
mundo, portões de segurança e o pipeline de gravação são ativos
compartilhados.** Qualquer trilha que inicie um novo deve passar por revisão de
arquitetura. E as linhas de produto nunca dependem do kei: se o kei atrasar, a
receita não atrasa.

## Aprofundar-se

- [Por que celestia-island](./why.md) — a declaração do problema por trás do horizonte.
- [Princípios de Segurança](./safety.md) — a semântica de tempo real sobre a qual a narrativa se apoia.
- [Mapa de Projetos](../ecosystem/projects.md) — onde vive hoje o trabalho de cada trilha.
