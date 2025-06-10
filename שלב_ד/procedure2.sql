CREATE OR REPLACE PROCEDURE add_award(
  p_award_name VARCHAR,
  p_given_by   VARCHAR,
  p_result     VARCHAR,
  p_title_id   INT
)
AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM Award
     WHERE award_name = p_award_name
       AND given_by   = p_given_by
       AND title_id   = p_title_id
  ) THEN
    RAISE NOTICE 'Award % by % for title % already exists.',
                 p_award_name, p_given_by, p_title_id;
    RETURN;
  END IF;
  INSERT INTO Award (award_name, given_by, result, title_id)
  VALUES (p_award_name, p_given_by, p_result, p_title_id);
END;
$$ LANGUAGE plpgsql;