# java_switch

Somehow we asked ourself the question how many cases can be put into a java switch statement.
For Java 21, we found the number was 5481.
Then, the project escalated and with the help of Nix, we tested the limit of cases for all javac from the openjdks 15 to 17.

The java code that is tested looks like this:
```
public class Main{
    public static void main(String[] args) {
        int i=Integer.parseInt(args[0]);
        int j=plusOne(i);
        System.out.println(i+" plus one is "+j);
    }

    public static int plusOne(int i){
        return switch(i) {
            case 0 -> 1;
            case 1 -> 2;
            <...>
            default -> throw new UnsupportedOperationException();
        };
    }
}
```

## Run

```
$ export NIXPKGS_ALLOW_INSECURE=1
$ nix shell --impure github:lbeierlieb/java_switch
$ java_switch
```

Because older JDKs are at end of life, it is necessary to allow insecure packages.
For the environment variable to take effect with flakes, `--impure` has to be passed to the `nix` command.
`nix run` does not work, because the symlinks to the different javac versions in the packages bin folder would available (not added to PATH).

Also, a lot of dependencies for all the jdks will be downloaded and because they are old and not available on cache servers, a lot of the jdks or dependencies have to be compiled yourself (which takes some time).

## Results

In all javac versions, 5481 cases compiled fine, and 5482 caused the compiler to fail ("code too long");
