# Finance App 💰

Um aplicativo completo de controle financeiro pessoal desenvolvido em Flutter com arquitetura modular limpa.

## 🏗️ Arquitetura

Este projeto utiliza **Flutter Modular** para organização e **comunicação com APIs REST** para todas as regras de negócio.

### 📱 Camadas da Aplicação

```
lib/
├── app/
│   ├── modules/              # Módulos da UI (Home, Transactions, Reports)
│   │   ├── home/             # Dashboard principal
│   │   ├── transactions/     # Gestão de transações
│   │   └── reports/          # Relatórios e gráficos
│   ├── shared/
│   │   ├── constants/        # URLs da API, configurações
│   │   ├── models/           # DTOs para comunicação com API
│   │   ├── repositories/     # Abstração das chamadas de API
│   │   ├── services/         # Serviços (ApiService, AuthService)
│   │   └── widgets/          # Componentes reutilizáveis
│   ├── app_module.dart       # Configuração principal do Modular
│   └── app_widget.dart       # Widget raiz do app
└── main.dart
```

## 🔧 Configuração

### 1. Configure a URL da API
Edite o arquivo `lib/app/shared/constants/api_constants.dart`:

```dart
static const String baseUrl = 'https://sua-api.com/api';
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Execute o app
```bash
flutter run
```

## 📚 Dependências Principais

- **flutter_modular**: Organização modular e injeção de dependência
- **dio**: Cliente HTTP para comunicação com APIs
- **shared_preferences**: Armazenamento local (tokens, cache)
- **mobx**: Gerenciamento de estado reativo

## 🌐 Comunicação com Backend

### Autenticação
- Tokens JWT armazenados localmente
- Interceptor automático para adicionar tokens nas requisições
- Renovação automática de tokens expirados

### Endpoints Esperados
```
GET    /api/transactions           # Listar transações
POST   /api/transactions           # Criar transação
PUT    /api/transactions/:id       # Atualizar transação
DELETE /api/transactions/:id       # Deletar transação
GET    /api/transactions/summary   # Resumo financeiro

GET    /api/categories             # Listar categorias
POST   /api/auth/login             # Login
POST   /api/auth/register          # Registro
POST   /api/auth/logout            # Logout
```

### Formato de Resposta Esperado
```json
{
  "success": true,
  "message": "Operação realizada com sucesso",
  "data": { /* dados retornados */ }
}
```

## 🚀 Funcionalidades Implementadas

### ✅ Prontas
- 🏗️ Arquitetura modular configurada
- 🌐 Cliente HTTP com interceptors
- 🔐 Sistema de autenticação (tokens)
- 📱 Dashboard com resumo financeiro
- 🗂️ Navegação entre módulos

### 🔄 Em Desenvolvimento
- 📝 CRUD completo de transações
- 📊 Gráficos e relatórios
- 🏷️ Gestão de categorias
- ⚙️ Configurações do usuário

## 🛠️ Próximos Passos

1. **Implementar telas de transações**
   - Lista com filtros
   - Formulário de criação/edição
   
2. **Adicionar gráficos**
   - Integrar biblioteca de charts
   - Consumir dados de relatórios da API
   
3. **Melhorar UX/UI**
   - Loading states
   - Tratamento de erros
   - Offline support

## ✅ Status Atual do Projeto

### Implementado e Funcionando
- ✅ **Autenticação completa** com login/registro
- ✅ **Dashboard** com resumo financeiro
- ✅ **Listagem de transações** com paginação e busca
- ✅ **Criação de transações** com formulário completo
- ✅ **Sistema de categorias** com ícones
- ✅ **Parcelamento inteligente** (2x a 24x)
- ✅ **Filtros avançados** por tipo, categoria, data
- ✅ **Arquitetura modular** bem estruturada
- ✅ **Interface responsiva** Material Design 3

### Em Desenvolvimento
- 🔄 Edição de transações
- 🔄 Relatórios com gráficos
- 🔄 Metas financeiras
- 🔄 Backup e sincronização

### Configuração para Desenvolvimento
Para testar o aplicativo, use as credenciais:
- **Email:** `dev@finance.com`
- **Senha:** `123456`

## 🤝 Integração com Backend

O aplicativo está preparado para integração com backend REST. Configure a URL base em `lib/app/shared/constants/api_constants.dart`.
