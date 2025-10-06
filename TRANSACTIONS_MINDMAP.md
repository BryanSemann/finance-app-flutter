# 🗺️ Mapa Mental - Sistema de Transações Financeiras

## 📊 Estrutura Principal da Transação

```
                           TRANSAÇÃO
                               │
                ┌──────────────┼──────────────┐
                │              │              │
          📝 DADOS BÁSICOS   💰 VALORES    📅 TEMPORAL
                │              │              │
        ┌───────┼───────┐      │       ┌──────┼──────┐
        │       │       │      │       │      │      │
    Descrição  Tipo   Categoria │    Data   Recorrência │
        │       │       │      │       │      │      │
   "Almoço"  Receita  "Alimentação"   │  "2025-10-06"  │
            Despesa   "Transporte"     │   Mensal       │
                      "Saúde"         │   Semanal      │
                                      │   Única        │
                               ┌──────┴──────┐         │
                               │             │         │
                          Valor Total   Valor Parcela  │
                               │             │         │
                           R$ 150,00    R$ 25,00      │
                                            │         │
                                     ┌─────┴─────┐    │
                                     │           │    │
                                Nº Parcelas  Parcela Atual
                                     │           │    │
                                   6x         2/6     │
                                                      │
                                              ┌───────┴───────┐
                                              │               │
                                          Próxima         Histórico
                                          Cobrança        Parcelas
```

## 🔧 Componentes Detalhados

### 1. 📝 **Dados Básicos**
- **Descrição**: Texto livre (obrigatório)
- **Tipo**: Receita ou Despesa (enum)
- **Categoria**: Predefinidas + customizáveis
- **Observações**: Campo opcional para detalhes

### 2. 💰 **Sistema de Valores**
- **Switch**: "Valor Total" vs "Valor da Parcela"
- **Valor**: Decimal com 2 casas
- **Moeda**: Padrão BRL (futuro: multi-moeda)

### 3. 📅 **Sistema Temporal**
- **Data da Transação**: Data do evento
- **Parcelamento**: 
  - Única (padrão)
  - Parcelada (2-99x)
- **Recorrência**:
  - Não recorre
  - Mensal, Semanal, Anual

### 4. 🔄 **Sistema de Parcelas**
- **Número Total**: 1-99 parcelas
- **Parcela Atual**: Ex: 3/6
- **Valor Individual**: Calculado ou informado
- **Datas**: Geração automática das próximas

## 🎯 Categorias Sugeridas

### 💸 **Despesas**
```
🍽️ Alimentação
├── Restaurante
├── Supermercado  
├── Delivery
└── Lanche

🚗 Transporte
├── Combustível
├── Uber/Taxi
├── Transporte Público
└── Manutenção

🏠 Casa
├── Aluguel
├── Contas (Luz, Água, Gas)
├── Internet/TV
└── Manutenção

👕 Pessoal
├── Roupas
├── Beleza
├── Saúde
└── Educação

🎮 Lazer
├── Cinema
├── Streaming
├── Jogos
└── Viagem
```

### 💰 **Receitas**
```
💼 Trabalho
├── Salário
├── Freelance
├── Comissão
└── Bonificação

💹 Investimentos
├── Dividendos
├── Juros
├── Venda de Ações
└── Rendimento

🎁 Extras
├── Presente
├── Reembolso
├── Vendas
└── Outros
```

## 🛠️ Funcionalidades Essenciais

### ✅ **CRUD Básico**
- Criar transação
- Listar transações
- Editar transação
- Excluir transação

### 📊 **Visualizações**
- Lista por data
- Lista por categoria
- Gráficos mensais
- Relatórios

### 🔍 **Filtros e Busca**
- Por período
- Por categoria
- Por tipo (receita/despesa)
- Por valor (range)
- Busca por descrição

### 💳 **Recursos Avançados**
- Duplicar transação
- Templates de transação
- Anexar comprovantes
- Localização (GPS)
- Split de valores

## 🎨 UX/UI Sugestões

### 📱 **Tela de Criação**
```
┌─────────────────────────────┐
│ ← Nova Transação         ✓  │
├─────────────────────────────┤
│ 💰 Valor                    │
│ R$ [_______,__]             │
│                             │
│ 📝 Descrição               │
│ [___________________]       │
│                             │
│ 📂 Categoria               │
│ [Alimentação ▼]            │
│                             │
│ 📅 Data                    │
│ [06/10/2025]               │
│                             │
│ 🔄 Parcelamento             │
│ [ ] À vista                 │
│ [●] Parcelado (6x)         │
│                             │
│ ⚡ Valor informado:         │
│ (●) Total  ( ) Por parcela  │
└─────────────────────────────┘
```

### 📋 **Lista de Transações**
```
┌─────────────────────────────┐
│ Outubro 2025        [≡]     │
├─────────────────────────────┤
│ Hoje - 06/10                │
│ ─────────────────────────── │
│ 🍽️ Almoço Restaurante      │
│    Alimentação         -R$45│
│                             │
│ ⛽ Combustível              │
│    Transporte    (3/4) -R$80│
│                             │
│ Ontem - 05/10              │
│ ─────────────────────────── │
│ 💼 Salário                 │
│    Trabalho          +R$3000│
└─────────────────────────────┘
```

## 🚀 Implementação Sugerida

### Ordem de Desenvolvimento:
1. **Modelos básicos** (Transaction, Category, etc.)
2. **CRUD simples** (criar, listar)
3. **Sistema de parcelas**
4. **Categorias**
5. **Filtros e busca**
6. **Relatórios básicos**
7. **Features avançadas**

## ✅ Implementação Realizada

### 📋 **Modelos Criados:**

1. **TransactionCategory** (`lib/app/shared/models/transaction_category.dart`)
   - Categorias padrão para receitas e despesas
   - Sistema de ícones emojis
   - Suporte a categorias customizadas

2. **Installment** (`lib/app/shared/models/installment.dart`)
   - Controle individual de parcelas
   - Status de pagamento
   - Datas de vencimento
   - Helpers para verificar atrasos

3. **Transaction** (atualizado em `lib/app/shared/models/transaction.dart`)
   - Sistema completo de parcelamento
   - Suporte a recorrência
   - Dois modos de entrada de valor (total/parcela)
   - Metadados extensíveis
   - Factory methods para criação simplificada

### 🔧 **Serviços Implementados:**

4. **TransactionRepository** (atualizado)
   - CRUD completo de transações
   - Busca e filtros avançados
   - Suporte a paginação
   - Métodos para categorias e resumos

5. **TransactionsController** (`lib/app/modules/transactions/transactions_controller.dart`)
   - Gerenciamento de estado completo
   - Carregamento paginado
   - Sistema de filtros
   - Cálculos de resumo financeiro

### 📱 **Interface Criada:**

6. **TransactionsPage** (atualizada)
   - Lista com scroll infinito
   - Card de resumo financeiro
   - Sistema de busca integrado
   - Opções contextuais (editar, duplicar, excluir)
   - Estados de loading, erro e vazio

### 🚀 **Próximos Passos:**

1. **Tela de Criação** (`/transactions/create`)
2. **Tela de Edição** (`/transactions/edit/:id`) 
3. **Integração com Modular** (registrar no módulo)
4. **Testes unitários**
5. **Validações de formulário**

Quer que eu continue com a **tela de criação de transações**?