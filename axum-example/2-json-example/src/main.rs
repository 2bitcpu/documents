use axum::{extract, routing::post, Json, Router};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    let app = Router::new().route("/", post(handler));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;

    axum::serve(listener, app).await?;

    Ok(())
}

async fn handler(
    extract::Json(params): extract::Json<serde_json::Value>,
) -> Json<serde_json::Value> {
    Json(params)
}
