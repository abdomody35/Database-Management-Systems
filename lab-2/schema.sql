CREATE TABLE
    IF NOT EXISTS department (
        dept_name VARCHAR(255) PRIMARY KEY,
        building VARCHAR(255) NOT NULL,
        budget INT
    );

CREATE TABLE
    IF NOT EXISTS instructor (
        ID SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        dept_name VARCHAR(255) NOT NULL,
        salary INT,
        FOREIGN KEY (dept_name) REFERENCES department (dept_name)
    );

CREATE TABLE
    IF NOT EXISTS student (
        ID SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        dept_name VARCHAR(255),
        tot_cred SMALLINT DEFAULT NULL,
        FOREIGN KEY (dept_name) REFERENCES department (dept_name)
    );

CREATE TABLE
    IF NOT EXISTS advisor (
        s_ID INT PRIMARY KEY,
        i_ID INT,
        FOREIGN KEY (s_ID) REFERENCES student (ID),
        FOREIGN KEY (i_ID) REFERENCES instructor (ID)
    );

CREATE TABLE
    IF NOT EXISTS course (
        course_id VARCHAR(7) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        dept_name VARCHAR(255),
        credits SMALLINT NOT NULL,
        FOREIGN KEY (dept_name) REFERENCES department (dept_name)
    );

CREATE TABLE
    IF NOT EXISTS time_slot (
        time_slot_id SERIAL UNIQUE,
        day VARCHAR(255) NOT NULL,
        start_time TIME NOT NULL,
        end_time TIME NOT NULL,
        CONSTRAINT time_slot_candidate_key UNIQUE (time_slot_id, day, start_time)
    );

CREATE TABLE
    IF NOT EXISTS classroom (
        building VARCHAR(255) NOT NULL,
        room_number SMALLINT NOT NULL,
        capacity INT,
        CONSTRAINT classroom_candidate_key UNIQUE (building, room_number)
    );

CREATE TABLE
    IF NOT EXISTS section (
        course_id VARCHAR(7) NOT NULL,
        sec_id SMALLINT,
        semester VARCHAR(255),
        year SMALLINT,
        building VARCHAR(255),
        room_number SMALLINT,
        time_slot_id INT,
        FOREIGN KEY (course_id) REFERENCES course (course_id),
        FOREIGN KEY (building, room_number) REFERENCES classroom (building, room_number),
        FOREIGN KEY (time_slot_id) REFERENCES time_slot (time_slot_id),
        CONSTRAINT section_candidate_key UNIQUE (course_id, sec_id, semester, year)
    );

CREATE TABLE
    IF NOT EXISTS teaches (
        ID SERIAL,
        course_id VARCHAR(7),
        sec_id SMALLINT,
        semester VARCHAR(255),
        year SMALLINT,
        FOREIGN KEY (ID) REFERENCES instructor (ID),
        FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES section (course_id, sec_id, semester, year),
        CONSTRAINT teaches_candidate_key UNIQUE (ID, course_id, sec_id, semester, year)
    );

CREATE TABLE
    IF NOT EXISTS takes (
        ID SERIAL,
        course_id VARCHAR(7),
        sec_id SMALLINT,
        semester VARCHAR(255),
        year SMALLINT,
        grade SMALLINT,
        FOREIGN KEY (ID) REFERENCES student (ID),
        FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES section (course_id, sec_id, semester, year),
        CONSTRAINT takes_candidate_key UNIQUE (ID, course_id, sec_id, semester, year)
    );

CREATE TABLE
    IF NOT EXISTS prereq (
        course_id VARCHAR(7),
        prereq_id VARCHAR(7),
        FOREIGN KEY (course_id) REFERENCES course (course_id),
        FOREIGN KEY (prereq_id) REFERENCES course (course_id),
        CONSTRAINT prereq_candidate_key UNIQUE (course_id, prereq_id)
    );