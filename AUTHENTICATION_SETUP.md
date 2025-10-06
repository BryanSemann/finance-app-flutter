# 🔐 Implementação de Autenticação - Finance App

## ✅ O que foi implementado:

### 📱 **Telas de Autenticação**
1. **Splash Screen** (`/lib/app/modules/splash/`)
   - Verifica se o usuário está logado ao iniciar o app
   - Redireciona para login ou home automaticamente

2. **Tela de Login** (`/lib/app/modules/auth/login_page.dart`)
   - Formulário com email e senha
   - Validação de campos
   - Loading state durante autenticação
   - Tratamento de erros
   - Link para registro

3. **Tela de Registro** (`/lib/app/modules/auth/register_page.dart`)
   - Formulário completo com nome, email, senha e confirmação
   - Validação de campos e confirmação de senha
   - Loading state e tratamento de erros

### 🏗️ **Arquitetura Atualizada**

#### **Módulos Criados:**
- `AuthModule` - Gerencia login/registro
- `SplashModule` - Tela inicial com verificação de autenticação

#### **Controllers:**
- `AuthController` - Gerencia estado da autenticação

#### **Serviços:**
- `AuthService` - Comunicação com API de autenticação
- `AuthGuard` - Proteção de rotas autenticadas

#### **Fluxo de Navegação:**
```
Splash Screen → Verifica autenticação
    ├── Não logado → Login → Home
    └── Logado → Home diretamente
```

### 🛡️ **Segurança Implementada**
- **Guards de Rota**: Rotas protegidas que exigem autenticação
- **Token Management**: Armazenamento seguro de tokens JWT
- **Auto-redirect**: Redirecionamento automático em caso de token expirado
- **Interceptors**: Adição automática de tokens nas requisições

## 🔧 **Como configurar:**

### 1. **Configure sua API no backend**
Certifique-se que sua API tenha os endpoints:
- `POST /api/auth/login`
- `POST /api/auth/register` 
- `POST /api/auth/logout`

### 2. **Atualize a URL da API**
Edite `lib/app/shared/constants/api_constants.dart`:
```dart
static const String baseUrl = 'https://sua-api.com/api';
```

### 3. **Formato esperado da API**

#### **Login Request:**
```json
{
  "email": "user@example.com",
  "password": "123456"
}
```

#### **Login Response (Sucesso):**
```json
{
  "success": true,
  "message": "Login realizado com sucesso",
  "token": "jwt_token_here"
}
```

#### **Register Request:**
```json
{
  "name": "João Silva",
  "email": "user@example.com", 
  "password": "123456"
}
```

### 4. **Testando a Autenticação**

Para testar sem backend real, você pode criar um mock temporário no `AuthService`:

```dart
// No método login() do AuthService
Future<bool> login(String email, String password) async {
  // MOCK para testes - remover quando tiver backend real
  if (email == "test@test.com" && password == "123456") {
    await _saveToken("mock_token_123");
    return true;
  }
  
  // Código real da API...
}
```

## 🚀 **Como executar:**

```bash
flutter clean
flutter pub get
flutter run
```

## 📱 **Fluxo do Usuário:**

1. **App inicia** → Splash Screen (2s)
2. **Não logado** → Tela de Login
3. **Login bem-sucedido** → Redireciona para Home
4. **Na Home** → Botão de logout disponível
5. **Logout** → Volta para Login

## 🔧 **Próximas melhorias sugeridas:**

1. **Biometria** - Login com impressão digital
2. **Remember Me** - Lembrar usuário logado
3. **Recuperação de Senha** - Esqueci minha senha
4. **Social Login** - Google, Facebook, Apple
5. **2FA** - Autenticação de dois fatores

## 🐛 **Resolução de Problemas:**

### Erro de navegação:
Se aparecer erro de rota não encontrada, verifique:
- Se todos os módulos estão importados no `AppModule`
- Se as rotas estão corretas nos `pushNamed()`

### Erro de token:
Se der erro de autenticação:
- Verifique se a URL da API está correta
- Confirme se o backend está retornando o token no formato esperado
- Verifique se o token está sendo salvo corretamente

### Erro de build:
```bash
flutter clean
flutter pub get
flutter pub deps
```