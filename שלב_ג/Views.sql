
-- יצירת מבט מהאגף שלנו (משתמשים)
CREATE OR REPLACE VIEW user_overview AS
SELECT
  u.user_id,
  u.name         AS user_name,
  u.country,
  s.plan_type,
  COUNT(p.profile_id) AS profile_count
FROM users u
JOIN subscriptions s
  ON u.user_id = s.user_id
LEFT JOIN profiles p
  ON s.email = p.email
GROUP BY
  u.user_id,
  u.name,
  u.country,
  s.plan_type;
  
  
-- כל המשתמשים מישראל שיש להם חשבון פרימיום ויותר מ2 פרופילים  
SELECT *
FROM user_overview
WHERE profile_count > 2 AND plan_type = 'Premium' AND country = 'Israel'
ORDER BY profile_count DESC;

-- סופר כמה משתמשים יש בכל תכנית לפי מדינה
SELECT
  country,
  plan_type,
  COUNT(*) AS users_count
FROM user_overview
GROUP BY country, plan_type
ORDER BY country, plan_type;

-- יצירת מבט מהאגף החדש (מדיה)
CREATE OR REPLACE VIEW title_genres AS
SELECT
  t.title_id,
  t.title_name,
  g.genre_name
FROM Title AS t
JOIN MovieGenre AS mg ON mg.title_id = t.title_id
JOIN Genre      AS g  ON g.genre_id   = mg.genre_id;

-- איזה ז'אנרים יש לכל סרט או סדרה 
SELECT
  title_id,
  title_name,
  STRING_AGG(genre_name, ', ') AS genres_list
FROM title_genres
GROUP BY title_id, title_name
ORDER BY title_name;

-- כמה סרטים או סדרות יש בכל ז'אנר
SELECT
  genre_name,
  COUNT(DISTINCT title_id) AS titles_count
FROM title_genres
GROUP BY genre_name
ORDER BY titles_count DESC;