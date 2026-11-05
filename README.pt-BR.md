# agent-toolkit

Skills para Claude Code e Antigravity. Por enquanto tem um par: `handoff` e `pickup`.

Idiomas: [English](README.md) | Português

## handoff e pickup

Quando a sessão fica longa, rode `/handoff`. Ele salva onde a tarefa está em `.handoff/<topic>.md`: o objetivo, as decisões e o motivo de cada uma, o que já foi feito, o próximo passo e as armadilhas. O arquivo é reescrito a cada execução e fica com até 40 linhas.

Na sessão nova, `/pickup` lê esse arquivo, confere com o git e mostra onde a tarefa parou. Nenhum trabalho começa antes da sua confirmação.

Duas regras mantêm o arquivo confiável:

- O hash do commit e os arquivos alterados vêm do git na hora, não da memória do agente.
- O handoff é contexto. Ele nunca dispara trabalho sozinho.

Um arquivo real está em [examples/handoff-exemplo.pt-BR.md](examples/handoff-exemplo.pt-BR.md). O hash, a contagem de testes e os nomes são inventados.

## Instalação

### Claude Code

```bash
mkdir -p ~/.claude/skills
cp -R skills/handoff skills/pickup ~/.claude/skills/
```

### Antigravity

Copie as mesmas duas pastas para a pasta de skills da ferramenta. O caminho depende da versão, então confira na documentação dela.

### Manter os handoffs fora do git

O `/handoff` adiciona `.handoff/` ao `.gitignore` do projeto, se ela não estiver lá. Para ignorar em todos os projetos, rode uma vez:

```bash
echo ".handoff/" >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
```

## Uso

- `/handoff` antes de `/clear` ou de trocar de ferramenta.
- `/handoff <topic>` para dar um nome ao arquivo.
- `/handoff done` quando a tarefa terminar e você confirmar.
- `/pickup` na sessão nova. Com um handoff ativo, ele carrega esse. Com vários, pergunta qual.

Os dois comandos são manuais. O agente nunca os executa sozinho.

## Limites

- Uma tarefa por sessão. Com duas tarefas no mesmo repo, a lista `files` mistura as alterações.
- A regra contra segredos no arquivo é uma instrução para o agente, não uma garantia. Leia o arquivo antes de compartilhar.
- Quando fazer o handoff (tamanho do contexto, número de turnos) fica a seu critério. Defina o seu limite.

## Licença

MIT. Veja [LICENSE](LICENSE).
