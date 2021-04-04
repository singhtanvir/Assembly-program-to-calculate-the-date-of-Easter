# Assembly-program-to-calculate-the-date-of-Easter

This is the SPARC assembly implementation of the program which calculated date of easter based on given year

Instructions to execute 

First expand all the macro definitions using m4 by invoking 

```m4 main.m > main.s```

The above command will convert the m4 file to assembly (.s) file by substituting macro definitions 

& now to execute the assembly language file on SPARC machine we can use GCC

``` gcc main.s -o main ```

This will create an executable main which will be located in your current working directory
Because this is an assembly language program it will not print anything to the console by simply executing 
```./main```
The actual value of the date, month after calcualting will be stored in seperate registers

For this program we have to run GDB (The GNU Project debugger) to set the break points and check the contents of a specific register 
The value for day is stored in register %l6 and for month is stored in %o5.

> "Beware of bugs in the above code; I have only proved it correct, not tried it"
> ― Donald Knuth
