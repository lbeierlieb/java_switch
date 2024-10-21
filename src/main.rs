use std::{
    env,
    fs::File,
    io::Write,
    process::{Command, ExitStatus, Stdio},
};

use itertools::Itertools;

const JAVA_BEFORE: &str = r#"public class Main{public static void main(String[] args){int i=Integer.parseInt(args[0]);int j=plusOne(i);System.out.println(i+" plus one is "+j);}public static int plusOne(int i){return switch(i){"#;

const JAVA_AFTER: &str = "default -> throw new UnsupportedOperationException();};}}";

fn main() {
    let args = env::args().collect::<Vec<_>>();
    let i = args
        .get(1)
        .and_then(|i| i.parse::<u64>().ok())
        .expect("Just supply a single number");
    let code = generate_java_code(i);
    write_to_file("Main.java", &code).expect("failed to do it");
    println!("Compilation status: {}", compile_java_class("Main.java"));
}

fn generate_java_code(i: u64) -> String {
    let mut java_code = String::new();
    java_code.push_str(JAVA_BEFORE);
    let cases = (0..=i).map(|i| format!("case {}->{};", i, i + 1)).join("");
    java_code.push_str(&cases);
    java_code.push_str(JAVA_AFTER);
    java_code
}

fn write_to_file(path: &str, content: &str) -> std::io::Result<()> {
    let mut output = File::create(path)?;
    write!(output, "{}", content)?;
    Ok(())
}

fn compile_java_class(file: &str) -> ExitStatus {
    let a: Vec<&str> = vec![file];
    Command::new("javac22")
        .args(&a)
        .stdout(Stdio::null())
        .spawn()
        .unwrap()
        .wait()
        .unwrap()
}
