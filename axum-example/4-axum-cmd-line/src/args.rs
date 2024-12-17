use bpaf::Bpaf;

#[derive(Debug, Clone)]
pub struct Args {
    pub host_name: String,
    pub serve_dir: Option<std::path::PathBuf>,
}

#[derive(Debug, Clone, Bpaf)]
#[bpaf(options, version)]
#[allow(dead_code)]
struct Opts {
    #[bpaf(short('n'), long, guard(validate_host_name, "Invalid host name."))]
    host_name: Option<String>,
    #[bpaf(short, long, guard(validate_serve_dir, "Invalid directory name."))]
    serve_dir: Option<std::path::PathBuf>,
}

fn validate_host_name(input: &Option<String>) -> bool {
    if let Some(p) = input {
        return match std::net::TcpListener::bind(&p) {
            Ok(_) => true,
            Err(_) => false,
        };
    }
    true
}

fn validate_serve_dir(input: &Option<std::path::PathBuf>) -> bool {
    if let Some(p) = input {
        return p.is_dir();
    }
    true
}

pub fn get_args() -> Args {
    let p = opts().run();
    Args {
        host_name: p.host_name.unwrap_or("0.0.0.0:3000".to_owned()),
        serve_dir: p.serve_dir,
    }
}
