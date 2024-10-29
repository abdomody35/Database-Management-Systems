-- Step 1: List of Instructors by Department (grouped IDs by department)
WITH instructor_department AS (
    SELECT unnest(ARRAY[1, 2, 3]) AS i_ID, 'computer science' AS dept_name
    UNION
    SELECT unnest(ARRAY[4, 5, 6]), 'software engineering'
    UNION
    SELECT unnest(ARRAY[7, 8, 9]), 'computer engineering'
    UNION
    SELECT unnest(ARRAY[10, 11, 12]), 'electrical engineering'
    UNION
    SELECT unnest(ARRAY[13, 14, 15]), 'mechanical engineering'
    UNION
    SELECT unnest(ARRAY[16, 17, 18]), 'civil engineering'
    UNION
    SELECT unnest(ARRAY[19, 20, 21]), 'physics'
    UNION
    SELECT unnest(ARRAY[22, 23, 24]), 'chemistry'
    UNION
    SELECT unnest(ARRAY[25, 26, 27]), 'biology'
),
-- Step 2: Map each student to an instructor from their department
assigned_advisors AS (
    SELECT 
        s.ID AS student_id,
        (SELECT i_ID 
         FROM instructor_department 
         WHERE dept_name = s.dept_name 
         ORDER BY RANDOM() 
         LIMIT 1) AS advisor_id
    FROM student s
)
-- Step 3: Insert into the advisor table
INSERT INTO advisor
SELECT student_id, advisor_id
FROM assigned_advisors;