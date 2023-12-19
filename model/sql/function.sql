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
    FROM cgpa
    WHERE user_name = username;

    RETURN cgpa_data;
END;
$$
LANGUAGE plpgsql;

-- insert into cgpa
CREATE OR REPLACE FUNCTION insert_into_cgpa(
  p_user_name VARCHAR(30), 
  p_admitted DATE, 
  p_graduate DATE, 
  p_1st_sem FLOAT, 
  p_2nd_sem FLOAT, 
  p_3rd_sem FLOAT, 
  p_4th_sem FLOAT, 
  p_5th_sem FLOAT, 
  p_6th_sem FLOAT, 
  p_7th_sem FLOAT, 
  p_8th_sem FLOAT
) RETURNS VOID AS $$
BEGIN
  INSERT INTO cgpa(user_name, admitted, graduate, "1st_sem", "2nd_sem", "3rd_sem", "4th_sem", "5th_sem", "6th_sem", "7th_sem", "8th_sem") 
  VALUES (p_user_name, p_admitted, p_graduate, p_1st_sem, p_2nd_sem, p_3rd_sem, p_4th_sem, p_5th_sem, p_6th_sem, p_7th_sem, p_8th_sem);
END;
$$ LANGUAGE plpgsql;

-- get users with high cgpa

CREATE OR REPLACE FUNCTION get_users_with_high_cgpa()
RETURNS JSON AS
$$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(row_to_json(t))
    INTO result
    FROM (
        SELECT a.user_name, a.email
        FROM auth AS a
        WHERE a.user_name IN (
            SELECT c.user_name
            FROM cgpa AS c
            WHERE (c."1st_sem" + c."2nd_sem" + c."3rd_sem" + c."4th_sem" + c."5th_sem" + c."6th_sem" + c."7th_sem" + c."8th_sem") / 8 > 3.5
        )
    ) t;

    RETURN result;
END;
$$
LANGUAGE plpgsql;
SELECT get_users_with_high_cgpa();

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

-- get cp info by 
CREATE OR REPLACE FUNCTION get_top_solvers()
RETURNS JSON AS
$$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(row_to_json(t))
    INTO result
    FROM (
        SELECT cf.user_name, cf.cf_tot_solve AS codeforces_solved, lc.lc_tot_solve AS leetcode_solved
        FROM competative_programming cf
        JOIN competative_programming lc ON cf.user_name = lc.user_name
        ORDER BY (cf.cf_tot_solve + lc.lc_tot_solve) DESC
        LIMIT 3
    ) t;

    RETURN result;
END;


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


CREATE OR REPLACE FUNCTION get_top_repos() RETURNS json AS $$
DECLARE
  result json;
BEGIN
  SELECT json_agg(row_to_json(t))
  INTO result
  FROM (
    SELECT user_name, github_user_name, tot_repos 
    FROM github 
    ORDER BY tot_repos DESC 
    LIMIT 10
  ) t;

  RETURN result;
END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_profile_data(p_user_name VARCHAR(30)) RETURNS json AS $$
DECLARE
  result json;
BEGIN
  SELECT row_to_json(profile)
  INTO result
  FROM (
    SELECT * 
    FROM profile 
    WHERE user_name = p_user_name
  ) profile;

  RETURN result;
END; 
$$ LANGUAGE plpgsql;