# Compiler-in-C
>[!IMPORTANT]
>First check whether you have installed Flex in your linux distro.
>If not run "apt install flex" and it will install flex.

1. Create the lex source program (lets say lexText.l).
2. Copy and paste the above code given in lexText.l to your file.
>[!NOTE]
>Use vim editor to edit the file.

3. Execute the below commands in your linux terminal on the directory where you created the lex source program.
    - ```lex lexText.l``` This will create the "lex.yy.c" file.
    - ```gcc lex.yy.c``` This will generate the executable file.
    - ```./a.out``` This will run the executable file.
    - Enter an input string and it will generate the token string.(eg: a=b+c-d)

  
>[!IMPORTANT]
>This a.out is the "Lexical Analyzer".
