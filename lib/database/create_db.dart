class Login {
    String userName;
    String password;

    Login({required this.userName, required this.password});

    Map<String, dynamic> toMap() {
        return {
            'userName': userName,
            'password': password,
        };
    }

    factory Login.fromMap(Map<String, dynamic> map) {
        return Login(
            userName: map['userName'],
            password: map['password'],
        );
    }
}