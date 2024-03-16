class CustomersTB {
  static bool authenticate(String username, String password) {
    // Verifique se o usuário e a senha correspondem aos credenciais permitidos
    if (username == 'admin' && password == 'admin'){
      return true;
    }
    return false;
  }
}
