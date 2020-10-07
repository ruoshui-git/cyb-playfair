use cyb_playfair::Playfair;
use std::{env, process};

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 4 {
        eprintln!("program encode/decode text key");
        process::exit(1);
    }

    let text = args[2].as_str();
    let encoder = Playfair::new(args[3].as_str());

    let result = match args[1].as_str() {
        "encode" => encoder.encode(text),
        "decode" => encoder.decode(text),
        _ => {
            eprintln!("invalid command");
            process::exit(1);
        }
    };
    println!("{}", result);
}
