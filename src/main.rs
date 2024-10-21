use std::{
    fs::File,
    io::Write,
    process::{Command, ExitStatus, Stdio},
};

use itertools::Itertools;

const JAVA_BEFORE: &str = r#"public class Main{public static void main(String[] args){int i=Integer.parseInt(args[0]);int j=plusOne(i);System.out.println(i+" plus one is "+j);}public static int plusOne(int i){return switch(i){"#;
const JAVA_AFTER: &str = "default -> throw new UnsupportedOperationException();};}}";
const JAVA_FILENAME: &str = "Main.java";
const STEP_BEFORE_BINARY_SEARCH: u64 = 1000;
const JAVAC_VERSIONS: [&str; 8] = [
    "javac15", "javac16", "javac17", "javac18", "javac19", "javac20", "javac21", "javac22",
];

fn main() {
    for javac in JAVAC_VERSIONS {
        print!("Highest number of cases for {}:", javac);
        let limit = find_limit(JAVAC_VERSIONS[0]);
        println!(" {}", limit);
    }
}

fn find_limit(javac: &str) -> u64 {
    let mut min = 0;
    let mut max = STEP_BEFORE_BINARY_SEARCH;

    while test_if_compiles(javac, max) {
        min = max;
        max += STEP_BEFORE_BINARY_SEARCH;
    }

    while min != max {
        let mid = (max + min) / 2;
        if test_if_compiles(javac, mid) {
            min = mid + 1;
        } else {
            max = mid - 1;
        }
    }

    min
}

fn test_if_compiles(javac: &str, i: u64) -> bool {
    let code = generate_java_code(i);
    write_to_file(JAVA_FILENAME, &code).expect("failed to write java file");
    compile_java_class(javac, JAVA_FILENAME).success()
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

fn compile_java_class(javac: &str, file: &str) -> ExitStatus {
    let a: Vec<&str> = vec![file];
    Command::new(javac)
        .args(&a)
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn()
        .unwrap()
        .wait()
        .unwrap()
}
