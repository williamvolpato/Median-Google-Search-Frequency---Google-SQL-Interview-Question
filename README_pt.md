# Solução da Frequência Mediana de Buscas

Este repositório contém a solução SQL para o desafio "Frequência Mediana de Buscas" do [DataLemur](https://datalemur.com/questions/median-search-freq).

## Enunciado do Problema

A equipe de marketing do Google está preparando um comercial para o Superbowl e precisa de uma estatística simples para o anúncio de TV: a mediana do número de buscas realizadas por uma pessoa no ano passado. Calcular essa estatística diretamente em 2 trilhões de buscas seria muito custoso, mas temos acesso a uma tabela resumida que fornece o número de buscas e a quantidade de usuários que realizaram essas buscas.

### Exemplo de Entrada

| buscas  | num_usuarios |
|---------|--------------|
| 1       | 2            |
| 2       | 2            |
| 3       | 3            |
| 4       | 1            |

### Exemplo de Saída

| mediana |
|---------|
| 2.5     |

Expandindo a tabela `search_frequency`, obtemos a lista: `[1, 1, 2, 2, 3, 3, 3, 4]`, cuja mediana é `2.5` buscas por usuário.

## Solução

A consulta utiliza uma combinação de Common Table Expressions (CTEs), a função `GENERATE_SERIES` e funções de janela para calcular a mediana de forma eficiente.

```sql
WITH expanded_searches AS (
    SELECT 
        searches
    FROM 
        search_frequency, 
        GENERATE_SERIES(1, num_users)
),
ordered_searches AS (
    SELECT 
        searches,
        ROW_NUMBER() OVER (ORDER BY searches) AS row_num,
        COUNT(*) OVER () AS total_count
    FROM 
        expanded_searches
)
SELECT 
    ROUND(AVG(searches)::NUMERIC, 1) AS median
FROM 
    ordered_searches
WHERE 
    row_num IN ((total_count + 1) / 2, (total_count + 2) / 2);
```

### Explicação

1. **`expanded_searches`:**
   - Expande a tabela usando a função `GENERATE_SERIES` para criar entradas individuais para cada usuário com base na coluna `num_users`.

2. **`ordered_searches`:**
   - Atribui um número de linha (`row_num`) a cada entrada, ordenado pelo número de buscas.
   - Calcula o total de linhas (`total_count`) para identificar a posição da mediana.

3. **Cálculo da Mediana:**
   - Identifica a mediana com base no total de elementos ser ímpar ou par.
   - Utiliza a função `AVG()` para calcular o valor da mediana, arredondado para uma casa decimal.

## Como Usar

Você pode copiar e colar a consulta SQL em seu ambiente PostgreSQL para resolver o problema. Certifique-se de que existe uma tabela chamada `search_frequency` com as colunas `searches` (inteiro) e `num_users` (inteiro).

## Notas

Este repositório foi criado como parte da minha jornada de aprendizado e portfólio em desafios SQL. O problema é originado do [DataLemur](https://datalemur.com/questions/median-search-freq).

Fique à vontade para explorar, sugerir melhorias ou utilizá-lo para seus estudos.

