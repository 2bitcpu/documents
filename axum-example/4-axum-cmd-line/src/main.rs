mod args;

use axum::{routing::get, BoxError, Router};

use tower_http::services::{ServeDir, ServeFile};

#[tokio::main]
async fn main() -> Result<(), BoxError> {
    let opts = args::get_args();

    let listener = tokio::net::TcpListener::bind(&opts.host_name).await?;

    let app = match &opts.serve_dir {
        Some(d) => Router::new()
            .route("/service", get(|| async { "Hi from /foo" }))
            .fallback_service(
                ServeDir::new(d).not_found_service(ServeFile::new(d.join("index.html"))),
            ),
        None => Router::new().route("/service", get(|| async { "Hi from /foo" })),
    };

    axum::serve(listener, app).await?;

    Ok(())
}
