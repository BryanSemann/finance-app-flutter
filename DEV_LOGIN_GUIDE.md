# Sistema de Login de Desenvolvimento - Finance App

Este projeto agora possui um sistema de login de desenvolvimento integrado que permite fazer login offline sem usar a API, facilitando o desenvolvimento e testes.

## Como Funciona

O sistema possui dois modos de operação:
- **Produção**: Usa a API normal para autenticação
- **Desenvolvimento**: Permite login offline com credenciais predefinidas

## Configuração

### 1. Ativando o Modo de Desenvolvimento

No arquivo `lib/app/shared/constants/api_constants.dart`:
```dart
static const bool isDevelopmentMode = true; // true = desenvolvimento, false = produção
```

No arquivo `lib/app/shared/constants/dev_config.dart`:
```dart
static const bool enableDevMode = true; // Controle adicional
static const bool autoLogin = false; // Login automático (DESABILITADO)
```

### 2. Credenciais de Desenvolvimento Disponíveis

O sistema vem com 3 usuários de desenvolvimento pré-configurados:

| Email | Senha | Papel | Descrição |
|-------|-------|-------|-----------|
| `dev@finance.com` | `dev123` | Admin | Usuário desenvolvedor principal |
| `admin@finance.com` | `admin123` | Admin | Administrador do sistema |
| `test@finance.com` | `test123` | User | Usuário de testes |

## Como Usar

### 1. Login Manual de Desenvolvimento

Na tela de login, você pode:
- Digitar as credenciais manualmente (email/senha)
- O sistema detectará automaticamente que está em modo dev e fará login offline

### 2. Login Rápido (Painel de Desenvolvimento)

Quando em modo desenvolvimento, aparecerá um painel laranja na tela de login com botões para cada usuário:
- Clique em qualquer usuário para fazer login instantâneo
- Não precisa digitar senha

### 3. Auto Login

⚠️ **DESABILITADO POR PADRÃO** - Se configurado (`DevConfig.autoLogin = true`), o app faria login automático com o usuário padrão ao iniciar. 
**Atualmente configurado como `false` para permitir controle manual do login.**

### 4. Via Código (Programático)

```dart
// Login rápido de desenvolvimento
await authService.quickDevLogin('dev@finance.com');

// Auto login se habilitado
await authService.autoDevLoginIfEnabled();

// Verificar se está em modo desenvolvimento
bool isDevLogin = await authService.isDevelopmentLogin();

// Obter email do usuário de desenvolvimento atual
String? email = await authService.getDevelopmentUserEmail();
```

## Recursos do Sistema de Desenvolvimento

### 1. Indicadores Visuais
- **Banner laranja**: Mostra quando está logado em modo desenvolvimento
- **Painel de login**: Interface amigável para logins rápidos
- **Informações de debug**: Exibe configurações atuais

### 2. Bypass de Validações
- `skipEmailValidation`: Não valida formato de email
- `skipPasswordStrength`: Não valida força da senha

### 3. Persistência
- O login de desenvolvimento é salvo localmente
- Mantém estado entre reinicializações do app
- Token de desenvolvimento fixo para identificação

## Alternando Entre Modos

### Para Desenvolvimento:
```dart
// api_constants.dart
static const bool isDevelopmentMode = true;

// dev_config.dart  
static const bool enableDevMode = true;
```

### Para Produção:
```dart
// api_constants.dart
static const bool isDevelopmentMode = false;

// dev_config.dart
static const bool enableDevMode = false;
```

## Segurança

⚠️ **IMPORTANTE**: 
- Sempre definir `isDevelopmentMode = false` em builds de produção
- As credenciais de desenvolvimento são apenas para uso local
- O token de desenvolvimento não é válido na API real

## Personalizando Usuários de Desenvolvimento

Você pode adicionar/modificar usuários editando os arquivos:

### `api_constants.dart`:
```dart
static const Map<String, String> devCredentials = {
  'seu_email@dev.com': 'sua_senha',
  // ... outros usuários
};
```

### `dev_config.dart`:
```dart
static const Map<String, Map<String, dynamic>> testUsers = {
  'seu_email@dev.com': {
    'name': 'Seu Nome',
    'role': 'admin',
    'permissions': ['read', 'write']
  },
  // ... outros usuários
};
```

## Debugging

Para ver informações de debug, certifique-se de que:
```dart
// dev_config.dart
static const bool showDevInfo = true;
static const bool logApiCalls = true;
```

## Exemplo de Uso Completo

```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Banner de informações (só em dev)
          DevInfoBanner(authService: authService),
          
          // Formulário normal de login
          LoginForm(),
          
          // Painel de desenvolvimento (só em dev)
          DevLoginPanel(
            authService: authService,
            onLoginSuccess: () => Navigator.pushNamed('/home'),
          ),
        ],
      ),
    );
  }
}
```

## Troubleshooting

### Login de desenvolvimento não aparece:
- Verificar se `isDevelopmentMode = true`
- Verificar se `enableDevMode = true`
- Verificar se está usando `DevLoginPanel` widget

### Auto login não funciona:
- Verificar se `autoLogin = true`
- Verificar se está chamando `autoDevLoginIfEnabled()` no initState

### Credenciais não funcionam:
- Verificar se email/senha estão corretos em `devCredentials`
- Verificar se não há espaços ou caracteres especiais

Este sistema torna o desenvolvimento muito mais ágil, eliminando a necessidade de configurar backend ou inserir credenciais manualmente durante os testes! 🚀