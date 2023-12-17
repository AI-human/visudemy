-- get cgpa by username
CREATE OR REPLACE FUNCTION get_cgpa_by_username(username varchar)
RETURNS JSON AS
$$
DECLARE
    cgpa_data JSON;
BEGIN
    SELECT json_agg(json_build_object(
        'admitted', admitted,
        'graduate', graduate,
        '1st_sem', "1st_sem",
        '2nd_sem', "2nd_sem",
        '3rd_sem', "3rd_sem",
        '4th_sem', "4th_sem",
        '5th_sem', "5th_sem",
        '6th_sem', "6th_sem",
        '7th_sem', "7th_sem",
        '8th_sem', "8th_sem"
    ))
    INTO cgpa_data
    FROM cgpa_per_semester
    WHERE user_name = username;

    RETURN cgpa_data;
END;
$$
LANGUAGE plpgsql;

-- get projects by username
CREATE OR REPLACE FUNCTION get_projects_by_username(username varchar)
RETURNS JSON AS
$$
DECLARE 
    projects_data JSON;
BEGIN
    SELECT json_agg(json_build_object(
        'project', project,
        'link', link
    ))
    INTO projects_data
    FROM projects
    WHERE user_name = username;

    RETURN projects_data;
END;
$$
LANGUAGE plpgsql;
-- get skills by username
CREATE OR REPLACE FUNCTION get_skill_by_username(username varchar)
RETURNS JSON AS
$$
DECLARE 
    skill_data JSON;
BEGIN
    SELECT json_agg(json_build_object(
		'skill', skill
    ))
    INTO skill_data
    FROM skills
    WHERE user_name = username;

    RETURN skill_data;
END;
$$
LANGUAGE plpgsql;

-- get cp info by username
CREATE OR REPLACE FUNCTION get_cp_info_by_username(username varchar)
RETURNS JSON AS
$$
DECLARE 
    cp_data JSON;
BEGIN
    SELECT json_agg(json_build_object(
		'cf_handle',cf_handle,
		'totalsolve',totalsolve,
		'ac',ac,
		'wa',wa,
		'tle',tle,
		'leetcode_handle',leetcode_handle,
		'lc_tot_solve',lc_tot_solve,
		'easySolved',easySolved,
		'mediumSolved',mediumSolved,
		'hardSolved',hardSolved,
		'acceptancerate_leetcode',acceptancerate_leetcode
    ))
    INTO cp_data
    FROM competative_programming
    WHERE user_name = username;

    RETURN cp_data;
END;
$$
LANGUAGE plpgsql;
-- inset auth data
CREATE OR REPLACE FUNCTION insert_auth_data(json_data JSONB)
RETURNS VOID AS
$$
BEGIN
    INSERT INTO auth (user_name, email, passwd)
    VALUES (json_data->>'user_name', json_data->>'email', json_data->>'passwd');
END;
$$
LANGUAGE plpgsql;