# Guia do Beta Fechado

O **beta fechado interno** cobre o ciclo completo do produto, do registro da
conta ao controle industrial. A participação é somente por convite.

## O que o beta cobre

1. **Registre uma conta e crie uma API key** no painel de administração da API
   em nuvem [Arona](https://github.com/celestia-island/arona). O painel é
   somente interno durante o beta (`arona:8420` no host da implantação).
2. **Implante um modelo** e vincule-o a um backend de chat pelo painel.
3. **Converse e execute agentes** a partir do aplicativo desktop
   [shittim-chest](https://github.com/celestia-island/shittim-chest); a
   orquestração de agentes é fornecida pelo runtime **scepter** do entelecheia.
4. **Controle industrial**: operações remotas e intermediação de protocolos
   passam pelo [evernight](https://github.com/celestia-island/evernight).

## Obtendo acesso

- O acesso é **baseado em convites**. O auto-registro público é fechado por padrão.
- Os convites são emitidos pelos mantenedores e vinculados a uma única conta.
- Para dúvidas sobre acesso, fale pelos canais listados em
  [Contribuindo](../meta/CONTRIBUTING.md).

## Reportando bugs

Reporte problemas no GitHub, um problema por bug, usando os templates de issue:

| Produto | Repositório |
| --- | --- |
| Chat desktop/web — shittim-chest | [celestia-island/shittim-chest](https://github.com/celestia-island/shittim-chest/issues) |
| Orquestração de agentes — entelecheia/scepter | [celestia-island/entelecheia](https://github.com/celestia-island/entelecheia/issues) |
| Controle industrial — evernight | [celestia-island/evernight](https://github.com/celestia-island/evernight/issues) |
| Painel de administração e plataforma — arona/plana | [celestia-island/arona](https://github.com/celestia-island/arona/issues) |

Inclua sempre: informações do ambiente (SO, versões dos produtos), passos para
reproduzir, comportamento esperado vs. real e quaisquer logs relevantes.

## Limitações conhecidas

- O painel da Arona é **somente interno** e não é exposto publicamente durante o beta.
- O registro é fechado por padrão; o registro aberto ainda não está disponível.
- O relay de dispositivos WebRTC e a telemetria SCADA ao vivo exigem uma
  instância do scepter em execução; sem ela, a UI cai para dados de demo simulados.
- Aplicativos móveis e plugins de IDE não fazem parte deste beta.
- Alguns idiomas da documentação são traduções parciais.

## Aprofundar-se

- [Início Rápido](./quickstart.md) — o caminho de 30 minutos pelo ciclo.
- [Por que celestia-island](../philosophy/why.md) — a filosofia por trás do beta.
