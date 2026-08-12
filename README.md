# Assembly-language

A small collection of 8086 assembly programs written for MS-DOS, using MASM/TASM
syntax and DOS interrupt `INT 21H` for all input and output.

Every program follows the same basic shape:

- `.MODEL SMALL` with a `100H` byte stack
- Data (messages, values) declared in the `.DATA` segment
- `MAIN PROC` in the `.CODE` segment, terminated with `MOV AH, 4CH` / `INT 21H`
- Helper procedures for printing strings (`AH=09H`) and numbers (digit-by-digit
  with `AH=02H`)

## Programs

| File | Program | What it does |
| --- | --- | --- |
| `242-115-029_01.asm` | Student result | Computes total and average marks and assigns a letter grade |
| `242-115-029_02.asm` | Simple calculator | Menu-driven addition, subtraction and multiplication |
| `242-115-029_03.asm` | Shop billing | Menu-driven cart with per-item quantities and a checkout total |
| `242-115-029_04.asm` | Password check | One-digit password with a limited number of attempts |

### 01 — Student Result

Marks for three subjects (`math`, `phy`, `programming`) are hard-coded in the
data segment. The program adds them into `totalMarks`, divides by `totalSub` to
get the average, and then picks a grade:

| Average | Grade |
| --- | --- |
| 80 and above | A |
| 70–79 | B |
| 60–69 | C |
| below 60 | F |

The total, the average and the grade are printed on separate lines.

### 02 — Simple Calculator

Displays a menu and reads a single key:

```
1. Addition
2. Subtraction
3. Multiplication
4. Exit
```

The two operands `num1` and `num2` are hard-coded in the data segment. The
subtraction branch compares the operands first and prints a `-` sign when the
result would be negative, so the magnitude is always printed correctly. Any key
other than `1`–`4` prints an error message and redisplays the menu. The loop
keeps running until `4` is chosen.

### 03 — Shop Billing

A tiny point-of-sale loop over three products with fixed prices:

| Choice | Product | Price |
| --- | --- | --- |
| 1 | Apple | 40 |
| 2 | Orange | 30 |
| 3 | Mango | 60 |

Choices `1`–`3` increment that product's quantity and echo the new count.
Choice `4` (Checkout) prints each quantity, multiplies quantity by price for
every product, sums the results into `total`, and prints the total bill.
Choice `5` exits. Anything else prints `Invalid choice`.

### 04 — Password Check

`Pass` holds a single-digit password (`8`) and `attempts` starts at 3. The
program reads one character, compares it against `Pass`, and:

- on a match, prints `ACCESS GRANTED` and exits
- on a mismatch, prints `Wrong Password`, decrements `attempts`, and shows how
  many attempts are left before prompting again
- when `attempts` reaches 0, prints `ACCESS DENIED` and exits

## Running the programs

These are 16-bit DOS programs, so they need an 8086 emulator or a DOS
environment.

**emu8086**

1. Open the `.asm` file.
2. Click **Compile**, then **Run**.

**MASM under DOSBox**

```
masm program.asm;
link program.obj;
program.exe
```

**TASM under DOSBox**

```
tasm program.asm
tlink program.obj
program.exe
```

Replace `program` with the file you want to build — for example
`242-115-029_01`.

## Notes

- Input is read one character at a time with `AH=01H`, so menu choices are
  single keys and no Enter key is required.
- Numbers are printed by repeatedly dividing by 10, pushing each remainder on
  the stack, and popping the digits back off in reverse order.
- All values are 8- or 16-bit unsigned, so results are expected to stay within
  those ranges.
