import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';
import '../models/diseno.dart';
import '../models/color.dart';
import '../models/cita.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('nail_book.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        direccion_default TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE disenos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        imagen_url TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE colores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        diseno_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        hex_code TEXT NOT NULL,
        FOREIGN KEY (diseno_id) REFERENCES disenos (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE citas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        diseno_id INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        hora TEXT NOT NULL,
        direccion TEXT NOT NULL,
        observaciones TEXT,
        estado TEXT DEFAULT 'pendiente',
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
        FOREIGN KEY (diseno_id) REFERENCES disenos (id)
      )
    ''');
  }

  // ── USUARIOS ──────────────────────────────
  Future<int> insertarUsuario(Usuario usuario) async {
    final db = await instance.database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> loginUsuario(String correo, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'usuarios',
      where: 'correo = ? AND password = ?',
      whereArgs: [correo, password],
    );
    if (result.isNotEmpty) return Usuario.fromMap(result.first);
    return null;
  }

  // ── DISEÑOS ───────────────────────────────
  Future<int> insertarDiseno(Diseno diseno) async {
    final db = await instance.database;
    return await db.insert('disenos', diseno.toMap());
  }

  Future<List<Diseno>> obtenerDisenos() async {
    final db = await instance.database;
    final result = await db.query('disenos');
    return result.map((e) => Diseno.fromMap(e)).toList();
  }

  // ── COLORES ───────────────────────────────
  Future<int> insertarColor(ColorDiseno color) async {
    final db = await instance.database;
    return await db.insert('colores', color.toMap());
  }

  Future<List<ColorDiseno>> obtenerColoresPorDiseno(int disenoId) async {
    final db = await instance.database;
    final result = await db.query(
      'colores',
      where: 'diseno_id = ?',
      whereArgs: [disenoId],
    );
    return result.map((e) => ColorDiseno.fromMap(e)).toList();
  }

  // ── CITAS ─────────────────────────────────
  Future<int> insertarCita(Cita cita) async {
    final db = await instance.database;
    return await db.insert('citas', cita.toMap());
  }

  Future<List<Cita>> obtenerCitasPorUsuario(int usuarioId) async {
    final db = await instance.database;
    final result = await db.query(
      'citas',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
    return result.map((e) => Cita.fromMap(e)).toList();
  }

  // ── CERRAR ────────────────────────────────
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}