# דוח שלב א׳ - מודול משתמשים בסטרימינג

**מגישים:** ישי זיגדון, יצחק הלל זעפרני\
**מערכת:** שירות צפייה בסטרימינג\
**יחידה נבחרת:** מודול משתמשים

---

## תוכן עניינים

1. [מבוא](#מבוא)
2. [תרשימי ERD ו-DSD](#תרשימי-erd-ו-dsd)
3. [החלטות עיצוב ונימוקים](#החלטות-עיצוב-ונימוקים)
4. [שיטות הכנסת נתונים](#שיטות-הכנסת-נתונים)
5. [גיבוי ושחזור](#גיבוי-ושחזור)

---

## מבוא

במערכת שירות הזרמת התוכן אנו מנהלים נתונים על משתמשים, מנויים, פרופילים, היסטוריית צפייה, רשימות צפייה והעדפות פרופיל.\
המטרה העיקרית היא לאפשר:

- רישום וניהול משתמשים ומנויים.
- טיוב התכנים בהתאם לפרופילים השונים.
- מעקב אחרי דפוסי צפייה לצורך המלצות והפקת דוחות.

---

## תרשימי ERD ו-DSD

להלן תרשימי ה-Entity Relationship Diagram ו-Data Structure Diagram עבור מודול המשתמשים:

![הרצת שאילתה 1](screenshots/DSD.png)

![תוצאות שאילתה 1](screenshots/ERD.png)

\


---

## החלטות עיצוב ונימוקים

- **Users**: טבלת המשתמשים מכילה שדות `user_id`, `name`, `birth_date`, `country`. החלטנו שהשדה `user_id` יהיה מפתח ראשי אוטומטי (serial) כדי להבטיח ייחודיות ושמירה על עקביות.
- **Subscriptions**: טבלה זו מחברת בין `user_id` לכתובת `email`, וכוללת שדות `plan_type`, `start_date`, `end_date`, `status`, `password`. שימוש ב-`email` כמפתח זר מאפשר אימות משתמש אחיד.
- **Profiles**: טבלת הפרופילים כוללת `profile_id`, `name`, `age_rating`, `created_at`, `email`. החלטנו לקשר פרופילים למנויים דרך `email` כדי לאפשר לכל משתמש מספר פרופילים.
- **Watch\_History**: טבלת היסטוריית הצפייה כוללת `watched_at`, `Rating`, `profile_id`, `content_id`. שמירת הזמן והדירוג מאפשרת ניתוח התנהגות ומידול המלצות.
- **Watch\_List**: טבלה זו מתעדת תכנים שהפרופיל סימן למעקב (`added_at`, `profile_id`, `content_id`). הפרדה מ-`watch_history` נועדה לשפר ביצועים בשאילתות בדיקה.
- **Profile\_Preferences**: מכילה `language`, `quality`, `notifications`, `profile_id`. שימוש בטבלה נפרדת מאפשר הרחבה עתידית של הגדרות משתמש ללא פגיעה בטבלאות אחרות.
- **Content**: טבלת התכנים כוללת `content_id`, `Name`. אחסון מינימלי עבור תכנים מאפשר מרחב להרחיב שדות נוספים (קטגוריה, תיאור) בעתיד.
- **Payments**: טבלה זו כוללת `amount`, `currency`, `payment_method`, `email`. החלטנו להשתמש ב-`email` לקישור לתשלומים כדי לשמר היסטוריית תשלום ללא שינוי במפתח הראשי.

---

## שיטות הכנסת נתונים

1. **טעינת CSV באמצעות ****`COPY FROM`****:**
![- צילום מסך של הרצת הפקודה ב-psql.](screenshots/Screenshot%202025-04-18%20090339.png)
2. **סקריפט Python לאוטומציה:**
   ![- צילום מסך של סקריפט רץ וטעינת הקובץ.](screenshots/Screenshot%202025-04-18%20093811.png)
3. **פקודות ****`INSERT`****:**
   - צילום מסך של הוספה ידנית ב-SQL client.

---

*עד כאן שלב א׳.*

---

# חלק ב׳: תיעוד ביצוע שאילתות ושינויים

### שאילתות SELECT

1. **חיפוש משתמשים עם יותר מ-2 פרופילים**  
   - **תיאור:** שאילתה זו מאתרת משתמשים המחוברים ללפחות שלושה פרופילים שונים, מציגה את מזהה המשתמש, שמו, ארצו ומספר הפרופילים שלהם. שימוש בשאילתה מסייע בזיהוי משתמשים שמנצלים את הפלטפורמה ביותר מפרופיל אחד לצורך התאמה אישית.

![query 1](screenshots/query_1.png)

2. **סדרות/סרטים שצפו בהם ב-2024**  
   - **תיאור:** מביאה פרטי צפייה עבור כל צפייה שבוצעה בשנת 2024, כולל שם הפרופיל, תאריך הצפייה, שם התוכן והדירוג שהוענק. שימוש במידע מאפשר ניתוח מגמות צפייה עונתיות.

![query 2](screenshots/query_2.png)

 
3. **ממוצע דירוג לכל פרופיל עם ממוצע ≥ 8**  
   - **תיאור:** מחשבת את ממוצע הדירוגים לכל פרופיל ומחזירה רק פרופילים עם דירוג ממוצע של שמונה ומעלה. מאפשר לזהות פרופילים עם חווית צפייה חיובית למטרות שיווק.

![query 3](screenshots/query_3.png)
  
4. **משתמשים עם מנוי פעיל מתחילת השנה**  
   - **תיאור:** שולפת משתמשים שמצב מנויים שלהם פעיל מאז תחילת השנה, כולל סוג התוכנית ותאריך תחילת המנוי. עוזרת לעקוב אחר שמירת משתמשים (retention).

![query 4](screenshots/query_4.png)
  
5. **תכנים ב-watch_list שלא נצפו**  
   - **תיאור:** מאתרת תכנים שהוסיף הפרופיל לרשימת צפייה אך עדיין לא נצפו, כולל תאריך הוספה. מאפשרת תזכורות והמלצות משלימות לצפייה. 

![query 5](screenshots/query_5.png)

6. **פילוח פרופילים לפי חודש ושנה של יצירתם**  
   - **תיאור:** מסכמת כמות פרופילים שנוצרו בכל חודש ושנה, לחקר צמיחה חודשית של השירות. 

![query 6](screenshots/query_6.png)
 
7. **ספירת פרופילים לפי שפות מועדפות**  
   - **תיאור:** מחשבת כמה פרופילים בחרו כל שפה כהעדפה, עוזר לתעדוף ממשק משתמש לפי שפה.

![query 7](screenshots/query_7.png)
  
8. **5 התכנים הפופולריים ביותר**  
   - **תיאור:** מוצאת חמשת התכנים עם מספר הצפיות הגבוה ביותר, לרשימות Top5 ולקמפיינים שיווקיים.

![query 8](screenshots/query_8.png)
  

### שאילתות DELETE ו-UPDATE



**DELETE**


**:1**

**צילום מסך של מצב בסיס הנתונים לפני השינוי**

![Watch history before delete](screenshots/history_before_del.png)

**צילום מסך של הרצת השאילתה**

![Watch history while delete](screenshots/history_while_del.png)

**צילום מסך של מצב בסיס הנתונים אחרי השינוי**

![Watch history after delete](screenshots/history_after_del.png)


**:2**

**צילום מסך של מצב בסיס הנתונים לפני השינוי**

![Watch List before delete](screenshots/watchlist_before_del.png)

**צילום מסך של הרצת השאילתה**

![Watch List while delete](screenshots/watchlist_while_del.png)

**צילום מסך של מצב בסיס הנתונים אחרי השינוי**

![Watch List after delete](screenshots/watchlist_after_del.png)


**:3**

**צילום מסך של מצב בסיס הנתונים לפני השינוי**

![Profile Prefrences before delete](screenshots/pp_before_del.png)

**צילום מסך של הרצת השאילתה**

![Profile Prefrences before delete](screenshots/pp_while_del.png)

**צילום מסך של מצב בסיס הנתונים אחרי השינוי**

![Profile Prefrences after delete](screenshots/pp_after_del.png)


**UPDATE**


**:1**

**צילום מסך של מצב בסיס הנתונים לפני השינוי** 

![active accounts before delete](screenshots/active_b_upt.png)

**צילום מסך של הרצת השאילתה**

![Active Accounts while delete](screenshots/active_upd.png)

 **צילום מסך של מצב בסיס הנתונים אחרי השינוי**

![Active Accounts after delete](screenshots/active_a_upd.png)


**:2**

**צילום מסך של מצב בסיס הנתונים לפני השינוי** 

![Basic Subscriptions before delete](screenshots/basic_b_upd.png)

**צילום מסך של הרצת השאילתה**

![Basic Subscriptions while delete](screenshots/basic_upd.png)

 **צילום מסך של מצב בסיס הנתונים אחרי השינוי**

![Basic Subscriptions after delete](screenshots/basic_a_upd.png)


**:3**

**צילום מסך של מצב בסיס הנתונים לפני השינוי** 

![Lower case content before delete](screenshots/lower_b_upd.png)

**צילום מסך של הרצת השאילתה**

![Lower case content while delete](screenshots/lower_upd.png)

 **צילום מסך של מצב בסיס הנתונים אחרי השינוי**

![Lower case content after delete](screenshots/lower_a_upd.png)


### אילוצים (Constraints)

**1:**
**הפיכת COUNTRY בUSERS ל NOT NULL** 

   ![constrain 1](screenshots/constrain_1.png)

**2:**
   
**הוספת בדיקה ש age_rating ב profiles הוא בין 0 ל18** 
   ![constrain 2](screenshots/constrain_2.png)

**3:**
   
**ערך ברירת מחדל ל status ב subsciptions** 
   ![constrain 3](screenshots/const_3.png)


### דוגמאות ROLLBACK ו-COMMIT

 **ROLLBACK:** 
הפכנו את המדינה של המשתמש עם ID=5 ממקסיקו ל unknown ואחרי זה עשינו rollback.

1. **צילום מצב בסיס הנתונים לפני הפעולה:**  
   ![Before Transaction](screenshots/rollback_1.png)  
2. **צילום מסך של הרצת הפקודה:**  
   ![Transaction Run](screenshots/rollback_2.png)  
3. **צילום מצב בסיס הנתונים אחרי ROLLBACK:**  
   ![After Transaction](screenshots/rollback_3.png)

 **COMMIT:**
הפכנו את המדינה של המשתמש עם ID=5 ממקסיקו ל Israel ואחרי זה עשינו commit

1. **צילום מצב בסיס הנתונים לפני הפעולה:**  
   ![Before Transaction](screenshots/commit_b.png)  
2. **צילום מסך של הרצת הפקודה:**  
   ![Transaction Run](screenshots/commit_d.png)  
3. **צילום מצב בסיס הנתונים אחרי COMMIT:**  
   ![After Transaction](screenshots/commit_a.png)

---

*עד כאן שלב ב׳.*

---

# חלק ג׳: אינטגרציה ומבטים

**האגף החדש:** תוכן וסוגי מדיה

### בניית ה- ERD וה- DSD החדשים:

1. **ה- DSD של האגף החדש**  

![new DSD](שלב_ג/DSDnew.png)

2. **ה- ERD של האגף החדש**  

![new ERD](שלב_ג/ERDnew.png)


 
2. **ה- ERD המשותף**    
  כל מה שהיינו צריכים לעשות זה למחוק את טבלת ה content שהיה לנו ולחבר את כל מי שהיה קשור אליו ל title החדש.

![the combined ERD](שלב_ג/ERDco.png)

4. **ה- DSD המשותף**  
  כל מה שהיינו צריכים לעשות זה למחוק את טבלת ה content שהיה לנו ולחבר את כל מי שהיה קשור אליו ל title החדש, ולשנות את ה content_id ל title_id.

![the combined DSD](שלב_ג/DSDco.png)

### יצירת המבטים:

**האגף שלנו:** מידע על כל משתמש וכמה פרופילים יש לו

![the combined DSD](screenshots/1view.png)

**האגף החדש:** מידע על כל סרט\סדרה והז'אנרים שלה

![the combined DSD](screenshots/2view.png)


### שאילתות על המבטים
**האגף שלנו:**
1. **כל המשתמשים מישראל שיש להם חשבון פרימיום ויותר מ2 פרופילים**  
   - **תיאור:** שאילתה זו מציגה את מזהה המשתמש, שמו, ארצו, התכנית שלו ומספר הפרופילים שלו. שימוש במידע מאפשר לראות מי המשתמשים שמשלמים הכי הרבה בישראל.


![query 1](screenshots/ours1.png)

2. **סופר כמה משתמשים יש בכל תכנית לפי מדינה**  
   - **תיאור:** מביאה לכל מדינה ותכנית כמה משתמשים נמצאים בה. שימוש במידע מאפשר לראות באיזה ארצות יש צורך בעוד פרסום.

![query 2](screenshots/ours2.png)

**האגף החדש:**

1. **איזה ז'אנרים יש לכל סרט או סדרה**  
   - **תיאור:** שאילתה זו נותנת לכל סרט או סדרה את רשימת הז'אנרים שלה. שימוש במידע מאפשר המלצות למשתמשים לפי ז'אנרים.


![query 1](screenshots/theirs1.png)

2. **כמה סרטים או סדרות יש בכל ז'אנר**  
   - **תיאור:** מביאה לכל ז'אנר כמה תוכניות יש לו. שימוש במידע מאפשר לראות באיזה ז'אנרים חסר תכנים.

![query 2](screenshots/theirs2.png)
---

*עד כאן שלב ג׳.*

---
# חלק ד': פונקציות, פרוצדורות, טריגרים ותוכנית ראשית


---


## פונקציות (Functions)
### 1. `get_title_avg_rating(p_title_id INT) RETURNS NUMERIC`
תיאור מילולי:
פונקציה המקבלת Title_ID ומחזירה את ממוצע כל הדירוגים ב־watch_history עבור כותרת זו (NULL → 0).
```sql
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
```


### `2. list_titles_by_genre(p_genre_id INT) RETURNS REFCURSOR`
תיאור מילולי:
פונקציה פותחת REFCURSOR ומחזירה רשימת כותרות (title_id, title_name) עבור ז’אנר נתון.

```sql
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
```


## פרוצדורות (Procedures)
### 1. `update_franchise_count(p_franchise_id INT)`
תיאור מילולי:
פרוצדורה שמעדכנת את עמודת Number_of_titles בטבלת Franchise לפי ספירת שורות בטבלת Belongs_to עבור הזיכיון הנתון.

```sql
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
```



### 2. `add_award(p_award_name, p_given_by, p_result, p_title_id)`
תיאור מילולי:
פרוצדורה מוסיפה רשומת Award חדשה אם אינה קיימת, אחרת מדפיסה הודעת NOTICE.

```sql
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
```

## טריגרים (Triggers)
### 1. `trig_increment_season_episodes`

תיאור מילולי:
טריגר המגדיל אוטומטית את עמודת Number_of_episodes בטבלת Season בכל פעם שמתווסף רשומת Episode.

```sql
CREATE OR REPLACE FUNCTION fn_inc_season_eps()
  RETURNS TRIGGER AS
$$
BEGIN
  UPDATE Season
     SET Number_of_episodes = Number_of_episodes + 1
   WHERE Title_ID      = NEW.Title_ID
     AND Season_Number = NEW.Season_Number;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_increment_season_episodes
  AFTER INSERT ON Episode
  FOR EACH ROW
  EXECUTE FUNCTION fn_inc_season_eps();
```
### צילום מסך של הוספת Episode והרצת הטריגר:


![trig_inc_eps run](screenshots/triger1_ex.png)

### צילום מסך של הטבלה Season לפני ואחרי:



![trig_inc_eps before](screenshots/triger1_before.png)


![trig_inc_eps after](screenshots/triger1_after.png)


### 2. `trig_create_default_profil`
תיאור מילולי:
כל פעם שנכנסת שורה חדשה לטבלת subscriptions, יתווסף אוטומטית פרופיל ברירת מחדל בטבלת profiles המשויך ל־email של המנוי הזה.

```sql
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

```

### צילום מסך של הוספת Subscriber והרצת הטריגר:


![trig_inc_eps run](screenshots/trigger2_ex.png)

### צילום מסך של הטבלה Profiles לפני ואחרי:



![trig_inc_eps before](screenshots/trigger2_before.png)


![trig_inc_eps after](screenshots/trigger2_after.png)
## תוכניות ראשיות (Main Scripts)

### 1. `main_update_stats.sql`
**תיאור מילולי:**  
הרצה של פונקציה ופרוצדורה מרכזיות:  
1. קריאה ל־`get_title_avg_rating(10)` וחישוב ממוצע דירוג עבור הכותרת עם `Title_ID = 10`.  
2. קריאה ל־`update_franchise_count(<rnd_fid>)` לעדכון `Number_of_titles` לזיכיון אקראי.

```sql
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
```




### צילום מסך של הריצה ופלט ה־NOTICE:

![main_update_stats before](screenshots/main_update_stats_before.png)

הסבר על מה שרואים:

הNOTICE הראשון שהציג את התוצאה שהוחזרה מהפונקציה get_title_avg_rating(10). במקרה הזה הממוצע הוא 5.36.

הNOTICE השני שמציג את הערך הקודם בשדה Number_of_titles של הזיכיון (במקרה זה זיכיון מס׳ 6). פה רואים שהעמודה עוד לא תואמה למספר האמיתי של Belongs_to.

הNOTICE השלישי שמציג את הTitle החדש שייכנס תחת אותו franchise.

הNOTICE הרביעי שמציג את הערך החדש בשדה Number_of_titles לאחר הקריאה לפרוצדורה update_franchise_count.



### צילום מסך אחרי הריצה (טבלת Franchise):


![main_update_stats after](screenshots/main_update_stats_after.png)



### 2. `main_awards_and_list.sql`
תיאור מילולי:
הרצה של פרוצדורה ופונקציה עם Cursor:

add_award(...) להוספת פרס חדש לטבלת Award.

list_titles_by_genre(p_genre_id) לפתיחת REFCURSOR והצגת 10 רשומות.

```sql
DO $$
DECLARE
  cur REFCURSOR;
  rec RECORD;
BEGIN
  -- הוספת פרס חדש
  CALL add_award('Best Visuals', 'Critics Guild', 'Won', 12);

  -- קבלת cursor לכותרות בז'אנר 3
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
```

### צילום מסך של ההוספה והריצה:




![main_awards run](screenshots/main_awards_run.png)

הסבר על מה שרואים:
NOTICE: Award Best Visuals by Critics Guild for title 12 added.
– זה הנושא הראשון ש־add_award מוציא:
מה שמודיע שהפרוצדורה יודעת לטפל בכפילויות ומשאירה הכל תקין.

NOTICE: Title ID: 919, Name: 100 ways...
– השורה הראשונה מתוך הלולאה שמשכה את תוצאות ה־REFCURSOR של list_titles_by_genre(3).


כל הודעה כזו מציינת כותרת אחת בז’אנר 3. יהיו כ־10 הודעות כאלה (את 10 ה־FETCH הראשונות), בהתאם לאורך ה־cursor.


שאר הודעות ה־Title ID:

– המשך הלולאה. כל אחת מציגה את title_id ו־title_name של כל רשומה שנמשכה (עד 10).
---

*עד כאן שלב ד׳.*

---
# חלק ה': GUI - ממשק גרפי


---
## הוראות הפעלה של האפליקציה וצילומי מסך
יש להפעיל את הcontaniers של בסיס הנתונים בdocker.
יש להוריד את קובץ הzip בתקייה שלב_ה בשם streaming_app. לחלץ ואז להריץ את קובץ הפייתון app.py שנמצא בפנים בcmd או בכל סביבת עבודה אחרת של פייתון .הflask יספק לכם קישור לאתר שכשתלחצו עליו הוא יפתח בדפדפן שלכם.
המסך הראשון יראה כך:
![screen 1](screenshots/screen_1.png)
אפשר או להעתיק אימייל וסיסמא קיימים מהpgadmin או ליצור משתמש חדש בכפתור sign in now.
מסך ההרשמה יראה כך:
![screen 2](screenshots/screen_2.png)
יש למלא את הפרטים ואז ללחוץ על כפתור ההרשמה. המשתמש החדש ישמר בבסיס נתונים ואפשר גם להיכנס אליו בכניסות עתידיות.
אחרי שנכנסים בהצלחה רואים את מסך הפרופילים שנראה כך:
![screen 3](screenshots/screen_3.png)
במקרה של משתמש חדש הטריגר משלב 4 יופעל ותראו פרופיל בודד בשם default:
![screen 4](screenshots/screen_4.png)
ניתן להוסיף פרופילים חדשים על ידי לחיצה על עיגול ה-add profile. זה יוביל אתכם למסך הבא:
![screen 5](screenshots/screen_5.png)
יש לבחור שם והגבלת גיל עד 21 וללחוץ על create profile, זה יוביל אותך חזרה למסך הפרופילים עם הפרופיל החדש. 
לכל פרופיל יש 4 טבלאות: היסטוריית צפייה (עם פוטנציאל דירוג), רשימת צפייה (עם אפשרות 'צפיתי' שיוסיף את התוכן לרשימת ההיסטוריה), 10 התכנים הנצפים ביותר בעולם ו10 התכנים המדורגים הכי גבוה בעולם (בשתי הטבלאות אפשרות add לרשימת צפייה). כל הנתונים והשינויים נשמרים בבסיס הנתונים.
![screen 6](screenshots/screen_6.png)
![screen 7](screenshots/screen_7.png)
![screen 8](screenshots/screen_8.png)

## הסבר על דרך העבודה והכלים ליצירת האפליקציה
האפליקציה פותחה באמצעות שפת Python בשילוב עם Flask – מיקרו-פריימוורק לפיתוח אתרי אינטרנט. מטרת האפליקציה היא לאפשר למשתמשים להירשם, להיכנס, לנהל פרופילים, לצפות בתוכן ולדרג אותו. להלן פירוט מרכיבי העבודה והטכנולוגיות:
### צד שרת – Python + Flask
פיתחנו שרת אינטרנטי המאזין לבקשות HTTP ומטפל בהן בהתאם לנתיב (@app.route).

התחברות למסד הנתונים PostgreSQL מתבצעת באמצעות הספרייה psycopg2.

טיפול במצבי שגיאה, הפניות (redirect), וניהול סשנים (session) מבוצע בצורה מודולרית וברורה.

### מסד נתונים – PostgreSQL
הנתונים נשמרים במספר טבלאות: משתמשים (Users), פרופילים (Profiles), היסטוריית צפייה (Watch History), רשימות צפייה (Watch List) ועוד.

ביצענו שאילתות SQL מסוג SELECT, INSERT, UPDATE, ו-DELETE ישירות מהקוד בפייתון.

בכל שאילתה נלקחים בחשבון תרחישים כגון כפילויות, פרופילים ללא תוצאות, ותאריכים.

### צד לקוח – HTML + CSS
כלל הדפים מוצגים באמצעות תבניות Jinja2 של Flask (render_template), וכוללים עיצוב באמצעות CSS.

תבניות כוללות טפסים (Form) להזנת נתונים: התחברות, הרשמה, הוספת פרופיל, דירוג תכנים ועוד.

### תכונות בולטות באפליקציה
התחברות ואימות משתמשים לפי סטטוס מנוי.

ריבוי פרופילים למשתמש אחד.

היסטוריית צפייה ודירוגים, כולל שאילתות סטטיסטיות (Top 10).

הוספה לרשימת צפייה ודינמיות בין רשימה להיסטוריה.
