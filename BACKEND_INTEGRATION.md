# Integração com Backend - Modelos de Autenticação

## 📋 Resumo das Implementações

Baseado nas entidades `User` e `ApiError` do seu backend, foram criados e atualizados os seguintes componentes no app Flutter:

## 🗃️ Novos Modelos Criados

### 1. **User Model** (`lib/app/shared/models/user.dart`)
Mapeia a entidade User do backend:
```dart
class User {
  final String uuid;
  final String name;
  final String username; 
  final String email;
  final int statusCode;
  final DateTime updatedAt;
  final DateTime createdAt;
}
```

**Recursos:**
- ✅ Serialização JSON (toMap/fromMap)
- ✅ Método `copyWith` para atualizações
- ✅ Helper `isActive` (statusCode == 1)
- ✅ Helper `displayName` (nome ou username)

### 2. **ApiError Model** (`lib/app/shared/models/api_error.dart`)
Mapeia erros da API com factory methods para diferentes tipos:
```dart
class ApiError {
  final String code;
  final dynamic message;
  final int statusCode;
}
```

**Factory Methods:**
- `ApiError.networkError()` - Erro de rede
- `ApiError.unauthorized()` - 401 Unauthorized
- `ApiError.forbidden()` - 403 Forbidden
- `ApiError.notFound()` - 404 Not Found
- `ApiError.validationError()` - 400 Bad Request
- `ApiError.serverError()` - 500+ Server Errors

### 3. **AuthResponse Model** (`lib/app/shared/models/auth_response.dart`)
Padroniza respostas de autenticação:
```dart
class AuthResponse {
  final bool success;
  final String? token;
  final User? user;
  final String? message;
  final Map<String, dynamic>? errors;
}
```

**Classes Auxiliares:**
- `LoginRequest` - Payload para login
- `RegisterRequest` - Payload para registro

## 🔧 Serviços Atualizados

### **AuthService** (`lib/app/shared/services/auth_service.dart`)

**Métodos Atualizados:**
```dart
// Retorna AuthResponse em vez de bool
Future<AuthResponse> login(String email, String password)
Future<AuthResponse> register({required String name, username, email, password})

// Novos métodos
Future<User?> getCurrentUser()
Future<bool> validateToken()
Future<AuthResponse> refreshToken()
Future<bool> isUserActive()
```

**Recursos Adicionados:**
- ✅ Tratamento robusto de erros Dio
- ✅ Salvamento automático do usuário após login/registro
- ✅ Validação de token com backend
- ✅ Renovação de token
- ✅ Mapeamento de códigos HTTP para mensagens amigáveis

### **AuthController** (`lib/app/modules/auth/auth_controller.dart`)

**Recursos Adicionados:**
```dart
User? get currentUser          // Usuário atual logado
Future<void> loadCurrentUser() // Carregar dados do usuário
Future<bool> validateToken()   // Validar token atual
```

## 🌐 Endpoints Esperados no Backend

Com base na implementação, o app espera que o backend tenha os seguintes endpoints:

### **Autenticação**
```http
POST /api/auth/login
Content-Type: application/json
{
  "email": "user@email.com",
  "password": "senha123"
}

Response:
{
  "success": true,
  "token": "jwt-token-here",
  "user": {
    "uuid": "user-uuid",
    "name": "Nome do Usuário",
    "username": "username",
    "email": "user@email.com",
    "statusCode": 1,
    "createdAt": "2025-10-06 10:00:00",
    "updatedAt": "2025-10-06 10:00:00"
  },
  "message": "Login realizado com sucesso"
}
```

```http
POST /api/auth/register
Content-Type: application/json
{
  "name": "Nome Completo",
  "username": "username",
  "email": "user@email.com", 
  "password": "senha123"
}
```

```http
POST /api/auth/logout
Authorization: Bearer jwt-token
```

```http
GET /api/auth/me
Authorization: Bearer jwt-token
Response: { "data": { user_object } }
```

```http
POST /api/auth/refresh
Authorization: Bearer jwt-token
Response: { "token": "new-jwt-token", "user": user_object }
```

### **Tratamento de Erros**
O app espera erros no formato:
```json
{
  "success": false,
  "code": "VALIDATION_ERROR",
  "message": "Email já está em uso",
  "status": 400
}
```

## 🚀 Como Usar no App

### **Login**
```dart
final authController = Modular.get<AuthController>();
final success = await authController.login(email, password);

if (success) {
  final user = authController.currentUser;
  print('Logado como: ${user?.displayName}');
}
```

### **Registro**
```dart
final success = await authController.register(
  name: 'João Silva',
  email: 'joao@email.com', 
  password: 'senha123',
  username: 'joao_silva', // Opcional
);
```

### **Verificar Status**
```dart
final isLoggedIn = await authController.checkAuthStatus();
final isTokenValid = await authController.validateToken();
final isUserActive = await authService.isUserActive();
```

## 📝 Próximos Passos

1. **Configurar URLs da API** em `ApiConstants`
2. **Testar integração** com backend real
3. **Implementar interceptor** para renovação automática de token
4. **Adicionar validações** de formulário
5. **Criar testes unitários** para os novos modelos

## 🔐 Segurança

- ✅ Tokens JWT armazenados no SharedPreferences
- ✅ Interceptor automático para adicionar Authorization header
- ✅ Tratamento de token expirado (401)
- ✅ Limpeza de dados no logout
- ✅ Validação de token com backend