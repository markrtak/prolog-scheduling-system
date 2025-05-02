## Project Overview

A Prolog‑based class scheduling assistant that

* generates conflict‑free timetables for all students
* enforces exactly 2 days off per week per student
* identifies common free slots for assemblies or office hours

This tool reads a single Prolog file (`Scheduling System.pl`) containing both the student knowledge base and your implementation of the required predicates.

## Repository Structure

```
├── Scheduling System.pl    # Combined Prolog KB and implementation
├── public_tests.pl         # Official PlUnit test suite for grading
└── README.md               # This document
```

## Prerequisites

* [SWI‑Prolog](https://www.swi-prolog.org/) (tested on v8.4+)
* Unix‑style shell (if running tests via shell), or use the SWI‑Prolog REPL.

## Installation

1. Clone this repository.
2. Ensure `Scheduling System.pl` and `public_tests.pl` are in the same folder.

## How It Works

Your `Scheduling System.pl` implements the following core predicates:

1. **`university_schedule(-S)`**
   Binds `S` to a list of `sched(StudentID, Slots)` structures, where each `Slots` is a list of `slot(Day, SlotNumber, CourseCode)`.

2. **`student_schedule(+StudentID, -Slots)`**
   Retrieves all `slot/3` entries for a given `StudentID`.

3. **`no_clashes(+Slots)`**
   Succeeds if no two slots in `Slots` share both the same day and slot number.

4. **`study_days(+Slots, +DayCount)`**
   Verifies that the student’s `Slots` span no more than `DayCount` distinct days (here, 5 – 2 days off).

5. **`assembly_hours(+Schedules, -AH)`**
   Computes a list `AH` of `slot(Day, SlotNumber)` where **all** students are simultaneously free (and not on a day off).

6. Please note that sometimes the output could be too big to be fully displayed, resulting in ellipses (`...`) in the REPL.

   To show the complete result, add this command in the Prolog REPL:

   ```prolog
   ?- set_prolog_flag(answer_write_options,[max_depth(0)]).
   ```

To load your program in SWI‑Prolog:

```prolog
?- ['Scheduling System'].
?- [public_tests].
```

Then invoke any predicate, for example:

```prolog
?- university_schedule(S).
?- student_schedule(student_0, Slots).
?- assembly_hours(S, AH).
```

## Examples

Below are sample interactions demonstrating key functionality (actual output may vary based on your KB data):

1. **Generate Full University Schedule**

```prolog
?- university_schedule(S).
S = [sched(student_17,[slot(saturday,1,csen601),slot(saturday,3,csen602),slot(thursday,2,csen603),slot(monday,2,csen604),slot(sunday,1,dmet604)]),sched(student_18,[slot(sunday,1,csen403),slot(thursday,2,csen603),slot(monday,2,csen604),slot(tuesday,3,dmet604),slot(saturday,1,math401)]),sched(student_19,[slot(sunday,1,csen403),slot(saturday,1,csen602),slot(thursday,2,csen603),slot(monday,2,csen604),slot(thursday,4,csen907)]),sched(student_27,[slot(tuesday,2,csen1002),slot(sunday,1,csen1003),slot(thursday,4,csen907),slot(sunday,2,dmet1001),slot(wednesday,2,huma1001),slot(tuesday,3,netw1009)]),sched(student_28,[slot(tuesday,2,csen1002),slot(sunday,1,csen1003),slot(saturday,1,csen602),slot(thursday,2,csen603),slot(thursday,4,csen907),slot(tuesday,3,netw1009)]),sched(student_29,[slot(tuesday,2,csen1002),slot(monday,2,csen401),slot(sunday,1,csen403),slot(thursday,4,csen907),slot(sunday,2,dmet1001),slot(wednesday,2,huma1001)]),sched(student_7,[slot(monday,2,csen401),slot(sunday,1,csen403),slot(tuesday,4,csis402),slot(monday,5,de404),slot(wednesday,3,elct401),slot(saturday,1,math401),slot(saturday,3,rpw401)]),sched(student_8,[slot(monday,2,csen401),slot(saturday,1,csen602),slot(sunday,1,csis402),slot(monday,5,de404),slot(tuesday,4,elct401),slot(sunday,2,math401),slot(saturday,3,rpw401)]),sched(student_9,[slot(monday,2,csen401),slot(saturday,1,csen601),slot(monday,5,de404),slot(sunday,2,dmet1001),slot(tuesday,4,elct401),slot(wednesday,1,math401),slot(saturday,3,rpw401)])]; 
```

2. **Retrieve a Student's Schedule**

```prolog
?- student_schedule(student_1, Slots).
Slots = [ slot(tuesday,3,phy201), slot(friday,4,eng150) ].
```

3. **Check for Clashes**

```prolog
?- no_clashes([slot(monday,1,cs101), slot(monday,1,math102)]).
false.
```

4. **Compute Common Free Slots (Assembly Hours)**

```prolog
?- university_schedule(All), assembly_hours(All, AH).
AH = [ slot(thursday,2), slot(wednesday,5) ].
```

## Testing

We employ **automated testing** using SWI‑Prolog’s PlUnit framework. The official public test suite is provided in `public_tests.pl`.

### Automated Testing (PlUnit)

To run the public tests:

1. Ensure `public_tests.pl` references `Scheduling System.pl` at the top.

2. From the UNIX shell:

   ```bash
   swipl -q -s "Scheduling System.pl" -s public_tests.pl \
          -g run_tests -g halt
   ```

3. Or within the SWI‑Prolog REPL:

   ```prolog
   ?- ['Scheduling System'], [public_tests].
   ?- run_tests, halt.
   ```

You should see output like:

```
% PL-Unit: public_tests ... done
% All public tests passed
```

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes.
4. Open a Pull Request with a clear description of your updates.
