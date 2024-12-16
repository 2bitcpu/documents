```bash
cargo add tokio --no-default-features --features macros,rt-multi-thread
cargo add axum --features macros

cargo add serde --no-default-features --features derive
cargo add serde_json --no-default-features --features std

cargo add async-sqlite --no-default-features
```

```rust
use axum::{
    extract::{rejection::JsonRejection, FromRequest, MatchedPath, Path, Request, State},
    http::StatusCode,
    response::{IntoResponse, Response},
    routing::get,
    BoxError, Router,
};
use serde::{Deserialize, Serialize};

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/", get(handler))
        .route("/timeout/:id", get(timeout_handler))
        .route("/badrequest/:id", get(bad_request_handler));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();

    axum::serve(listener, app).await.unwrap();
}

async fn handler() -> Result<impl IntoResponse, AppError> {
    try_thing()?;
    Ok(())
}

fn try_thing() -> Result<(), BoxError> {
    Err(Box::from("it failed!"))
}

async fn timeout_handler(Path(id): Path<usize>) -> Result<impl IntoResponse, AppError> {
    match id {
        0 => Ok(AppJson(serde_json::json!({"message":"Ok"}))),
        _ => Err(AppError::RequestTimeout),
    }
}

async fn bad_request_handler(Path(id): Path<usize>) -> Result<impl IntoResponse, AppError> {
    match id {
        0 => Ok(AppJson(serde_json::json!({"message":"Ok"}))),
        _ => Err(AppError::BadRequest),
    }
}

#[derive(FromRequest)]
#[from_request(via(axum::Json), rejection(AppError))]
struct AppJson<T>(T);

impl<T> IntoResponse for AppJson<T>
where
    axum::Json<T>: IntoResponse,
{
    fn into_response(self) -> Response {
        axum::Json(self.0).into_response()
    }
}

#[derive(Debug)]
pub enum AppError {
    BadRequest,
    RequestTimeout,
    ProcessFailed(BoxError),
}

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        #[derive(Serialize)]
        struct ErrorResponse {
            message: String,
        }

        let (status, message) = match self {
            AppError::BadRequest => (StatusCode::BAD_REQUEST, "Bad Request".to_owned()),
            AppError::RequestTimeout => (StatusCode::REQUEST_TIMEOUT, "Request Timeout".to_owned()),
            AppError::ProcessFailed(err) => (
                StatusCode::INTERNAL_SERVER_ERROR,
                format!("Internal Server Error {err}").to_owned(),
            ),
        };

        (status, AppJson(ErrorResponse { message })).into_response()
    }
}

impl From<BoxError> for AppError {
    fn from(error: BoxError) -> Self {
        Self::ProcessFailed(error)
    }
}
```