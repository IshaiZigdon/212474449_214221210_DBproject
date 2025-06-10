CREATE OR REPLACE FUNCTION get_title_avg_rating(p_title_id INT)
  RETURNS NUMERIC AS
$$
DECLARE
  v_avg NUMERIC;
BEGIN
  SELECT AVG(rating) INTO v_avg
    FROM watch_history
   WHERE title_id = p_title_id
     AND rating IS NOT NULL;
  IF v_avg IS NULL THEN
    RETURN 0;
  END IF;
  RETURN ROUND(v_avg,2);
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Error computing avg rating for title %: %',
                 p_title_id, SQLERRM;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;