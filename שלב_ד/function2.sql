CREATE OR REPLACE FUNCTION list_titles_by_genre(p_genre_id INT)
  RETURNS REFCURSOR AS
$$
DECLARE
  cur REFCURSOR;
BEGIN
  OPEN cur FOR
    SELECT t.title_id, t.title_name
      FROM Title t
      JOIN MovieGenre mg ON t.title_id = mg.title_id
     WHERE mg.genre_id = p_genre_id
     ORDER BY t.title_name;
  RETURN cur;
END;
$$ LANGUAGE plpgsql;