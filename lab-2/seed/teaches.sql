DO $$
DECLARE
    overloaded_count INTEGER;
BEGIN
    LOOP
        DELETE FROM teaches;
        INSERT INTO teaches
        SELECT DISTINCT
            instructor_section.ID,
            instructor_section.course_id,
            instructor_section.sec_id,
            instructor_section.semester,
            instructor_section.year
        FROM
            (
                SELECT
                    i.ID,
                    s.course_id,
                    s.sec_id,
                    s.semester,
                    s.year,
                    ROW_NUMBER() OVER (
                        PARTITION BY
                            s.course_id,
                            s.sec_id,
                            s.semester,
                            s.year
                        ORDER BY
                            RANDOM()
                    ) as rank,
                    COUNT(*) OVER (
                        PARTITION BY
                            i.dept_name
                    ) as instructor_count
                FROM
                    instructor i
                    JOIN section s ON (
                        (i.dept_name = 'computer engineering' AND s.course_id LIKE 'comp%')
                        OR (i.dept_name = 'computer science' AND s.course_id LIKE 'cs%')
                        OR (i.dept_name = 'software engineering' AND s.course_id LIKE 'seng%')
                        OR (i.dept_name = 'electrical engineering' AND s.course_id LIKE 'elec%')
                        OR (i.dept_name = 'mechanical engineering' AND s.course_id LIKE 'mech%')
                        OR (i.dept_name = 'civil engineering' AND s.course_id LIKE 'civ%')
                        OR (i.dept_name = 'physics' AND s.course_id LIKE 'phy%')
                        OR (i.dept_name = 'chemistry' AND s.course_id LIKE 'chem%')
                        OR (i.dept_name = 'biology' AND s.course_id LIKE 'bio%')
                    )
            ) as instructor_section
        WHERE
            rank = 1;
        -- Check if any instructor has less than 4 courses
        SELECT COUNT(*) INTO overloaded_count
        FROM (
            SELECT COUNT(*) as num 
            FROM teaches 
            GROUP BY id
        ) subquery 
        WHERE num < 4;

        -- Exit if all instructors have at least 4 courses
        EXIT WHEN overloaded_count = 0;
    END LOOP;
END $$;