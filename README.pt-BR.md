# agent-toolkit

Skills para Claude Code e Antigravity. Cada skill é uma pasta com um `SKILL.md` e funciona sozinha.

Idiomas: [English](README.md) | Português

## Skills

| Skill | O que faz |
|-------|-----------|
| [handoff](#handoff) | Salva onde a tarefa está para uma sessão nova continuar |
| [pickup](#pickup) | Retoma a tarefa a partir do arquivo de handoff, conferido com o git |

## Convenções

- Uma skill é markdown puro em `skills/<nome>/SKILL.md`. Não há runtime.
- As skills rodam só quando você chama. O agente nunca as executa sozinho.
- A saída de uma skill é contexto. Ela nunca autoriza trabalho por conta própria.
- Fatos que importam, como hash de commit e arquivos alterados, vêm das ferramentas na hora da execução, não da memória do agente.

## Instalação

### Claude Code

```bash
mkdir -p ~/.claude/skills
cp -R skills/* ~/.claude/skills/
```

Para instalar só uma skill, copie a pasta dela, por exemplo `cp -R skills/handoff ~/.claude/skills/`.

### Antigravity

Copie as pastas das skills para a pasta de skills da ferramenta. O caminho depende da versão, então confira na documentação dela.

## Detalhes das skills

### handoff

Quando a sessão fica longa, rode `/handoff`. Ele salva onde a tarefa está em `.handoff/<topic>.md`: o objetivo, as decisões e o motivo de cada uma, os caminhos descartados e o motivo, o que já foi feito, o próximo passo e as armadilhas. O arquivo é reescrito a cada execução e fica com até 40 linhas.

Duas regras mantêm o arquivo confiável:

- O hash do commit e os arquivos alterados vêm do git na hora, não da memória do agente.
- O handoff é contexto. Ele nunca dispara trabalho sozinho.

Um arquivo real está em [examples/handoff-exemplo.pt-BR.md](examples/handoff-exemplo.pt-BR.md). O hash, a contagem de testes e os nomes são inventados.

#### Uso

- `/handoff` antes de `/clear` ou de trocar de ferramenta.
- `/handoff <topic>` para dar um nome ao arquivo.
- `/handoff done` quando a tarefa terminar e você confirmar.

#### Limites

- Uma tarefa por sessão. Com duas tarefas no mesmo repo, a lista `files` mistura as alterações.
- A regra contra segredos no arquivo é uma instrução para o agente, não uma garantia. Leia o arquivo antes de compartilhar.
- Quando fazer o handoff (tamanho do contexto, número de turnos) fica a seu critério. Defina o seu limite.

#### Manter os handoffs fora do git

O `/handoff` adiciona `.handoff/` ao `.gitignore` do projeto, se ele não estiver lá. Para ignorar em todos os projetos, rode uma vez:

```bash
echo ".handoff/" >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
```

### pickup

Na sessão nova, `/pickup` lê o arquivo de handoff, confere com o git e mostra onde a tarefa parou. Nenhum trabalho começa antes da sua confirmação.

#### Uso

- `/pickup` na sessão nova. Com um handoff ativo, ele carrega esse. Com vários, pergunta qual.

## Licença

MIT. Veja [LICENSE](LICENSE).
