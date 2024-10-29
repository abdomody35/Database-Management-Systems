-- First create a temporary table with random course levels for each student
CREATE TEMPORARY TABLE student_course_level AS
SELECT 
    ID,
    -- Randomly assign a course level (1-4) to each student
    (FLOOR(RANDOM() * 4) + 1)::text AS course_level
FROM student;
-- Then use this to insert into takes
INSERT INTO
    takes (ID, course_id, sec_id, semester, year)
SELECT DISTINCT
    st.ID,
    sec.course_id,
    sec.sec_id,
    sec.semester,
    sec.year
FROM
    student st
    JOIN student_course_level scl ON st.ID = scl.ID
    CROSS JOIN section sec
WHERE
    (
        -- Only select courses that end with the student's assigned level
        sec.course_id LIKE '%' || scl.course_level || '__'
    )
    AND (
        -- Match students with appropriate courses
        (
            st.dept_name = 'computer science'
            AND (
                sec.course_id LIKE 'cs%'
                OR sec.course_id LIKE 'seng%'
            )
        )
        OR (
            st.dept_name = 'software engineering'
            AND (
                sec.course_id LIKE 'seng%'
                OR sec.course_id LIKE 'cs%'
            )
        )
        OR (
            st.dept_name = 'computer engineering'
            AND (
                sec.course_id LIKE 'comp%'
                OR sec.course_id LIKE 'cs%'
            )
        )
        OR (
            st.dept_name = 'electrical engineering'
            AND (
                sec.course_id LIKE 'elec%'
                OR sec.course_id LIKE 'comp%'
            )
        )
        OR (
            st.dept_name = 'mechanical engineering'
            AND (
                sec.course_id LIKE 'mech%'
                OR sec.course_id LIKE 'elec%'
            )
        )
        OR (
            st.dept_name = 'civil engineering'
            AND (
                sec.course_id LIKE 'civ%'
                OR sec.course_id LIKE 'mech%'
            )
        )
        OR (
            st.dept_name = 'physics'
            AND (
                sec.course_id LIKE 'phy%'
                OR sec.course_id LIKE 'mech%'
            )
        )
        OR (
            st.dept_name = 'chemistry'
            AND (
                sec.course_id LIKE 'chem%'
                OR sec.course_id LIKE 'phy%'
            )
        )
        OR (
            st.dept_name = 'biology'
            AND (
                sec.course_id LIKE 'bio%'
                OR sec.course_id LIKE 'chem%'
            )
        )
    );
-- Clean up
DROP TABLE student_course_level;