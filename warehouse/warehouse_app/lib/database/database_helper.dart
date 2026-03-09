class DatabaseHelper {

  // Singleton
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  // In futuro qui inizializzeremo SQLite o ObjectBox
  Future<void> initDatabase() async {
    // Placeholder per lo step successivo
    print("Database inizializzato");
  }
}