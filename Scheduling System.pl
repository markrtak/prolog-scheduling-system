studies(student_7, math401).
studies(student_7, csis402).
studies(student_7, csen403).
studies(student_7, csen401).
studies(student_7, rpw401).
studies(student_7, elct401).
studies(student_7, de404).
studies(student_8, math401).
studies(student_8, csis402).
studies(student_8, csen602).
studies(student_8, csen401).
studies(student_8, rpw401).
studies(student_8, elct401).
studies(student_8, de404).
studies(student_9, math401).
studies(student_9, csen601).
studies(student_9, dmet1001).
studies(student_9, csen401).
studies(student_9, rpw401).
studies(student_9, elct401).
studies(student_9, de404).




studies(student_17, csen601).
studies(student_17, csen602).
studies(student_17, csen603).
studies(student_17, csen604).
studies(student_17, dmet604).
studies(student_18, math401).
studies(student_18, csen403).
studies(student_18, csen603).
studies(student_18, csen604).
studies(student_18, dmet604).
studies(student_19, csen403).
studies(student_19, csen602).
studies(student_19, csen603).
studies(student_19, csen604).
studies(student_19, csen907).




studies(student_27, csen1003).
studies(student_27, csen1002).
studies(student_27, huma1001).
studies(student_27, dmet1001).
studies(student_27, csen907).
studies(student_27, netw1009).
studies(student_28, csen1003).
studies(student_28, csen1002).
studies(student_28, csen603).
studies(student_28, csen602).
studies(student_28, csen907).
studies(student_28, netw1009).
studies(student_29, csen403).
studies(student_29, csen1002).
studies(student_29, huma1001).
studies(student_29, dmet1001).
studies(student_29, csen907).
studies(student_29, csen401).

day_schedule(saturday, [[math401, csen602, csen601], [], [rpw401, csen602, csen601], [], []]).
day_schedule(sunday, [[csis402, csen403, dmet604, csen1003], [math401, dmet1001], [rpw401, csen403], [csen403], []]).
day_schedule(monday, [[], [csen401, csen604], [], [rpw401, csen1003], [de404]]).
day_schedule(tuesday, [[], [de404, csen1002], [csen401, dmet604, netw1009], [elct401, csis402, dmet1001], []]).
day_schedule(wednesday, [[math401], [csen604, huma1001], [csen401, elct401], [csis402, math401, csen604, huma1001], [csen1002]]).
day_schedule(thursday, [[], [csen603], [csen401, netw1009], [rpw401, elct401, csen603, csen907], [elct401, csen907]]).

university_schedule(S) :-
    findall(Student_id, studies(Student_id, _), StudentsList),
    sort(StudentsList, UniqueStudents),
    university_schedule_helper(UniqueStudents, S).

university_schedule_helper([], []).
university_schedule_helper([Student_id | Rest], [sched(Student_id, Slots) | Schedules]) :-
    student_schedule(Student_id, Slots),
    university_schedule_helper(Rest, Schedules).
	
student_schedule(Student_id, Slots) :-
    student_courses(Student_id, Courses),
    schedule_courses(Courses, Slots),
    no_clashes(Slots),
    study_days(Slots, 5).
	
student_courses(Student_id, Courses) :-
    findall(Course, studies(Student_id, Course), CoursesUnsorted),
    sort(CoursesUnsorted, Courses).
	
schedule_courses([], []).
schedule_courses([Course|RestCourses], [slot(Day, SlotNum, Course)|RestSlots]) :-
    day_schedule(Day, DaySlots),
    nth1(SlotNum, DaySlots, SlotCourses),
    member(Course, SlotCourses),
    schedule_courses(RestCourses, RestSlots).
	
no_clashes([]).	
no_clashes([H|T]):-
	H = slot(Day, Time,_),
	\+ (member(slot(Day, Time,_), T)),
	no_clashes(T).


study_days(Slots, DayCount) :-
    findall(Day, member(slot(Day, _, _), Slots), Days),
    sort(Days, UniqueDays),
    length(UniqueDays, Count),
    Count =< DayCount.
	

assembly_hours(Schedules, AH) :-
    setof(slot(Day, SlotNum), possible_slot(Day, SlotNum), AllSlots),
    include(valid_assembly_slot(Schedules), AllSlots, AH).


possible_slot(Day, SlotNum) :-
    day_schedule(Day, Slots),
    length(Slots, Len),
    between(1, Len, SlotNum).  


valid_assembly_slot(Schedules, slot(Day, SlotNum)) :-
    forall(
        member(sched(_, StudentSlots), Schedules),
        (
            member(slot(Day, _, _), StudentSlots),
            \+ member(slot(Day, SlotNum, _), StudentSlots)
        )
    ).