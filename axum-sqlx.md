# Rust + Axum + Sqlx

```toml
[package]
name = "web-api"
version = "0.1.0"
edition = "2024"

[features]
default = [ "sqlite" ]
sqlite = [ "sqlx/sqlite-unbundled" ]
sqlite-bundled = [ "sqlx/sqlite" ]

[dependencies]
axum = { version = "0.8.1", features = ["macros"] }
chrono = { version = "0.4.40", default-features = false }
rand = { version = "0.9.0", default-features = false, features = ["std", "thread_rng"] }
serde = { version = "1.0.218", features = ["derive"] }
serde_json = { version = "1.0.139", features = ["std"] }
sqlx = { version = "0.8.3", features = ["runtime-tokio-native-tls", "chrono", "derive"], default-features = false }
tokio = { version = "1.43.0", features = ["macros", "rt-multi-thread"], default-features = false }

[profile.release]
opt-level = "z"
debug = false
lto = true
strip = true
codegen-units = 1
panic = "abort"

# cargo +nightly-2025-02-20 build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --target aarch64-unknown-linux-gnu --release
# upx --best --lzma ./target/aarch64-unknown-linux-gnu/release/web-api
```

```rust
use axum::{
    Router,
    extract::{Json, Path, State},
    http::StatusCode,
    response::{IntoResponse, Response},
    routing::{get, post},
};
use serde::{Deserialize, Serialize};
use sqlx::{Row, SqlitePool};
use std::fmt;
use tokio::net::TcpListener;

#[tokio::main]
async fn main() {
    // SQLite データベース接続プールの作成
    let pool = SqlitePool::connect("sqlite:db.sqlite").await.unwrap();

    // `Router` に状態（pool）を渡す
    let app = Router::new()
        .route("/users", post(create_user)) // ユーザー作成
        .route("/users/{id}", get(get_user)) // ユーザー取得
        .with_state(pool); // 状態（pool）を渡す

    // TcpListener の作成
    let listener = TcpListener::bind("0.0.0.0:3000").await.unwrap();

    // サーバーを起動
    axum::serve(listener, app.into_make_service())
        .await
        .unwrap();
}

// ユーザーを表す構造体（データベースのスキーマに合わせている）
#[derive(Deserialize, Serialize)]
struct User {
    name: String,
    password: String,
    email: Option<String>,
    display_name: Option<String>,
}

// エラーレスポンスの構造体
#[derive(Serialize)]
struct ErrorResponse {
    message: String,
}

// 成功時のレスポンス構造体
#[derive(Serialize)]
struct SuccessResponse {
    message: String,
}

// エラーの種類を列挙
#[derive(Debug)]
pub enum AppError {
    BadRequest(String),
    NotFound,
    InternalError(String),
}

impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:?}", self)
    }
}

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let (status, message) = match self {
            AppError::BadRequest(err) => (StatusCode::BAD_REQUEST, format!("Bad Request: {}", err)),
            AppError::NotFound => (StatusCode::NOT_FOUND, "User not found".to_string()),
            AppError::InternalError(err) => (
                StatusCode::INTERNAL_SERVER_ERROR,
                format!("Internal Server Error: {}", err),
            ),
        };

        // エラーメッセージを JSON として返す
        (status, Json(ErrorResponse { message })).into_response()
    }
}

// 新しいユーザーを作成するエンドポイント
async fn create_user(
    State(pool): State<SqlitePool>, // `State` でデータベース接続プールを取得
    Json(new_user): Json<User>,     // `Json` でリクエストボディを受け取る
) -> impl IntoResponse {
    // データベースに新しいユーザーを挿入
    let query = "INSERT INTO users (name, password, email, display_name) VALUES (?, ?, ?, ?)";
    let result = sqlx::query(query)
        .bind(&new_user.name)
        .bind(&new_user.password)
        .bind(&new_user.email)
        .bind(&new_user.display_name)
        .execute(&pool)
        .await;

    match result {
        Ok(_) => Json(SuccessResponse {
            message: "User created successfully".to_string(),
        })
        .into_response(),
        Err(e) => AppError::InternalError(format!("Error creating user: {}", e)).into_response(),
    }
}

// ユーザー情報を取得するエンドポイント
async fn get_user(
    Path(id): Path<i64>,            // ユーザーIDをURLパラメータとして取得
    State(pool): State<SqlitePool>, // `State` でデータベース接続プールを取得
) -> impl IntoResponse {
    // データベースからユーザー情報を取得
    let query = "SELECT name, email, display_name, create_at, update_at FROM users WHERE id = ?";
    let result = sqlx::query(query).bind(id).fetch_one(&pool).await;

    match result {
        Ok(record) => {
            let name: String = record.get("name");
            let email: Option<String> = record.get("email");
            let display_name: Option<String> = record.get("display_name");
            let create_at: String = record.get("create_at");
            let update_at: String = record.get("update_at");

            // ユーザーが見つかった場合の成功レスポンス
            Json(SuccessResponse {
                message: format!(
                    "User found: Name: {}, Email: {:?}, Display Name: {:?}, Created At: {}, Updated At: {}",
                    name, email, display_name, create_at, update_at
                ),
            })
            .into_response()
        }
        Err(_) => AppError::NotFound.into_response(),
    }
}
```