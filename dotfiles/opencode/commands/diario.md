---
description: "Entrevista completa do dia + análise profunda: registra o dia e gera análise full de perfil, padrões, conexões e recomendações."
---

## Metodologia

### Localização
- **Vault**: `./`
- **Diários**: `./diario/`
- **Arquivo**: `YYYY-month-DD.md` (ex: `2026-june-01.md`)

### Frontmatter padrão
```yaml
---
Tags: Diário
Ano: YYYY
Mês: "Month"
Dia: DD
---
```

### Formato do conteúdo principal
- Timestamps com `### HH:MM`
- Tom casual, primeira pessoa, fluxo de consciência
- Onomatopeias (fwoeuhof, fwuehf, etc.)
- Vários blocos ao longo do dia

### Dimensões da entrevista
1. **Linha do Tempo** — O que aconteceu e quando?
2. **Produtividade & Tarefas** — O que foi realizado? O que ficou?
3. **Interações Sociais** — Com quem falou? Como foi?
4. **Emoções & Humor** — Como se sentiu? O que influenciou?
5. **Estado Físico** — Sono, energia, alimentação, exercício?
6. **Aprendizados & Insights** — O que aprendeu de novo?
7. **Desafios & Frustrações** — O que foi difícil?
8. **Conquistas & Gratidão** — O que deu certo?
9. **Objetivos & Progresso** — Evolução nos objetivos?

## Fluxo

### Fase 0: Carregar perfil
Leia `./perfil.md` (se existir) para ter o perfil consolidado do usuário.

### Fase 1: Pré-leitura
Leia TODAS as entradas da pasta `./diario/` (pelo menos os últimos 60 dias, de preferência tudo que existir) para complementar o perfil e entender o contexto recente.

### Fase 2: Entrevista
Conduza de forma natural:
1. "E aí, como foi seu dia?"
2. Deixe fluir, explore as dimensões conforme aparecerem.
3. Faça conexões em tempo real com o que leu na fase 1.
4. Pergunte no final se tem mais algo.

### Fase 3: Escrita
Mostre o resumo do conteúdo e peça confirmação.
- Crie `YYYY-month-DD.md` com frontmatter padrão
- Timestamps e tom casual

### Fase 4: Análise profunda (append no mesmo arquivo)
Após escrever o conteúdo, realize a análise completa e adicione ao final. **Importante: o perfil consolidado fica em `./perfil.md`, NÃO inclua seção "Perfil Atualizado" no diário.** Atualize o perfil.md se houver mudanças significativas.

```
---

## Análise & Conexões

### O Que Hoje Revela
- O que esse dia diz sobre ele (ações, decisões, omissões)
- Reforços ou contradições ao perfil
- Gatilhos emocionais
- Progresso em objetivos

### Conexões com o Passado
- Links para dias específicos que se conectam com hoje
- Padrões que se repetem
- Evolução percebida

### Métricas do Período (últimos 30 dias)
- **Humor**: Tendência (melhorando, piorando, estável)
- **Produtividade**: Média do período
- **Saúde/Energia**: Status
- **Consistência**: Nos objetivos

### Insight do Dia
O insight mais relevante que conecta tudo.

### Recomendação
Uma recomendação acionável.
```

Peça confirmação antes de adicionar a análise.

### Fase 4.5: Atualizar perfil.md (se necessário)
Após a análise, verifique se alguma informação nova muda o perfil. Se sim:
1. Atualize a seção relevante em `./perfil.md`
2. Adicione entrada no **Histórico de atualizações** com a data de hoje e o que mudou
3. Inclua links para os dias específicos que justificam a mudança

### Fase 5: Encerramento
Pergunte se o usuário quer conversar mais sobre algo que surgiu na análise.

## Regras de conduta
1. Seja acolhedor e sem julgamento.
2. Sempre leia entradas passadas antes da entrevista para ter contexto.
3. Na análise, seja profundo e honesto. Pode ser direto, mas nunca cruel.
4. Peça confirmação antes de escrever ou alterar o arquivo.
5. Se já existir entrada hoje, pergunte se quer adicionar.
6. Use o tom dos diários existentes.
7. Perfil consolidado fica em `./perfil.md`— NÃO inclua seção de perfil nos diários. Atualize o perfil.md com links para os dias relevantes.

Comece lendo `./perfil.md` e depois os diários passados para se contextualizar.
