import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

void main() {
  // Seu token JWT
  const token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzbWFydGVuZXJneS4wMzNAZ21haWwuY29tIiwidXNlcklkIjoiYjJhNTdkZjAtMDRkNS0xMWVmLWFjNjQtYzFmMjE0Yzk3NzI4Iiwic2NvcGVzIjpbIlRFTkFOVF9BRE1JTiJdLCJzZXNzaW9uSWQiOiIxZDk0YmJjMS00ODEzLTQ5ZmMtYTliNy1lNTQxNjEzNmZlMjciLCJpc3MiOiJ0aGluZ3Nib2FyZC5jbG91ZCIsImlhdCI6MTcxNjMwNzIxNCwiZXhwIjoxNzE2MzM2MDE0LCJmaXJzdE5hbWUiOiJTbWFydEVuZXJneSIsImxhc3ROYW1lIjoiU21hcnRFbmVyZ3kiLCJlbmFibGVkIjp0cnVlLCJpc1B1YmxpYyI6ZmFsc2UsImlzQmlsbGluZ1NlcnZpY2UiOmZhbHNlLCJwcml2YWN5UG9saWN5QWNjZXB0ZWQiOnRydWUsInRlcm1zT2ZVc2VBY2NlcHRlZCI6dHJ1ZSwidGVuYW50SWQiOiJiMTlkZDFmMC0wNGQ1LTExZWYtYWM2NC1jMWYyMTRjOTc3MjgiLCJjdXN0b21lcklkIjoiMTM4MTQwMDAtMWRkMi0xMWIyLTgwODAtODA4MDgwODA4MDgwIn0.R_nQddbldG7i6n-NoFXxIhrFjd-kt3n_driHJ48gxpaRgJjhFdCUrDPWHkm9hSdo1AFt5C8WVEsF2Fu_UvHP1A';

  // Decodificar o token sem verificar a assinatura
  final jwt = JWT.decode(token);

  // Verificar a reivindicação 'exp'
  final exp = jwt.payload['exp'];
  if (exp is int) {
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final now = DateTime.now();

    print('Token expira em: $expiryDate');
    if (now.isAfter(expiryDate)) {
      print('Token expirado.');
    } else {
      print('Token válido.');
    }
  } else {
    print('Reivindicação exp não encontrada no token.');
  }
}
