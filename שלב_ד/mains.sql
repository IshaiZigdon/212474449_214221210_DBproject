--main1:

DO $$
DECLARE
  avg_rating NUMERIC;
  rnd_fid    INT;
BEGIN
  -- חישוב ממוצע דירוג לכותרת 10
  avg_rating := get_title_avg_rating(10);
  RAISE NOTICE 'Average rating for Title 10: %', avg_rating;

  -- בחירת זיכיון אקראי
  SELECT Franchise_ID INTO rnd_fid
    FROM Franchise
    ORDER BY RANDOM() LIMIT 1;

  -- הדפסת נתוני הזיכיון לפני העדכון
  RAISE NOTICE 'Before update: Franchise % has % titles',
               rnd_fid,
               (SELECT Number_of_titles FROM Franchise WHERE Franchise_ID = rnd_fid);

  -- קריאה לפרוצדורה לעדכון
  CALL update_franchise_count(rnd_fid);

  -- הדפסת הנתונים אחרי העדכון
  RAISE NOTICE 'After update: Franchise % has % titles',
               rnd_fid,
               (SELECT Number_of_titles FROM Franchise WHERE Franchise_ID = rnd_fid);
END
$$;


--main2:

DO $$
DECLARE
  cur REFCURSOR;
  rec RECORD;
BEGIN
  -- הוספת פרס חדש
  CALL add_award('Best Visuals', 'Critics Guild', 'Won', 12);

  -- קבלת עכבר (cursor) לכותרות בז'אנר 3
  cur := list_titles_by_genre(3);

  -- הצגת 10 שורות ראשונות
  FOR i IN 1..10 LOOP
    FETCH cur INTO rec;
    EXIT WHEN NOT FOUND;
    RAISE NOTICE 'Title ID: %, Name: %', rec.title_id, rec.title_name;
  END LOOP;
  CLOSE cur;
END
$$;
