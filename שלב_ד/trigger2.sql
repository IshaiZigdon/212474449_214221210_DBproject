-- 1) פונקציית הטריגר: יצירת פרופיל ברירת מחדל
CREATE OR REPLACE FUNCTION fn_create_default_profile()
  RETURNS TRIGGER
AS $$
DECLARE
  v_new_profile_id INT;
BEGIN
  -- חשב profile_id חדש כ־MAX+1
  SELECT COALESCE(MAX(profile_id),0) + 1
    INTO v_new_profile_id
  FROM profiles;

  -- הוסף פרופיל ברירת מחדל
  INSERT INTO profiles (
    profile_id,
    name,
    age_rating,
    created_at,
    email
  ) VALUES (
    v_new_profile_id,
    'Default',
    0,
    CURRENT_DATE,
    NEW.email
  );

  RETURN NEW;
EXCEPTION
  WHEN unique_violation THEN
    -- במידה וכבר קיים פרופיל זהה, נתעלם ולא נזרוק שגיאה
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2) יצירת הטריגר על טבלת subscriptions
DROP TRIGGER IF EXISTS trig_create_default_profile ON subscriptions;

CREATE TRIGGER trig_create_default_profile
  AFTER INSERT ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION fn_create_default_profile();
