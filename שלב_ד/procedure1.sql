CREATE OR REPLACE PROCEDURE update_franchise_count(p_franchise_id INT)
AS $$
BEGIN
  UPDATE Franchise
     SET Number_of_titles = (
       SELECT COUNT(*) FROM Belongs_to
        WHERE franchise_id = p_franchise_id
     )
   WHERE Franchise_ID = p_franchise_id;
  IF NOT FOUND THEN
    RAISE NOTICE 'No franchise % found.', p_franchise_id;
  END IF;
END;
$$ LANGUAGE plpgsql;