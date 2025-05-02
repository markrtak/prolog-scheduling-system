## Project Overview

A Prolog‑based class scheduling assistant that

* generates conflict‑free timetables for all students
* enforces exactly 2 days off per week per student
* identifies common free slots for assemblies or office hours

This tool reads a single Prolog file (`Scheduling System.pl`) containing both the student knowledge base and your implementation of the required predicates.

## Repository Structure

```
├── Scheduling System.pl    # Combined Prolog knowledge base and implementation
├── public_tests.pl         # Official PlUnit test suite for testing
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

To load your program in SWI‑Prolog:

```prolog
?- ['Scheduling System'].  
```

Then invoke any predicate, for example:

```prolog
?- university_schedule(S).
?- student_schedule(student_0, Slots).
?- assembly_hours(S, AH).
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

