-- 1. חיפוש משתמשים עם יותר מ-2 פרופילים (שם, מדינה ומספר הפרופילים)
SELECT 
  u.user_id,
  u.name        AS user_name,
  u.country,
  COUNT(p.profile_id) AS profiles_count
FROM users u
JOIN subscriptions s   ON u.user_id = s.user_id
JOIN profiles p        ON p.email = s.email
GROUP BY u.user_id, u.name, u.country
HAVING COUNT(p.profile_id) > 2
ORDER BY profiles_count DESC;

-- 2. סרטים/סדרות שצפו בהם בפרופיל מסוים ב-2024 (שם הפרופיל, תאריך, כותרת, דירוג)
SELECT
  p.name              AS profile_name,
  wh.watched_at,
  c.Name              AS content_title,
  wh.Rating
FROM watch_history wh
JOIN profiles p     ON wh.profile_id = p.profile_id
JOIN content c      ON wh.content_id = c.content_id
WHERE EXTRACT(YEAR FROM wh.watched_at) = 2024
ORDER BY p.name, wh.watched_at;

-- 3. ממוצע דירוג (Rating) לכל פרופיל עם ממוצע ≥ 8
SELECT
  wh.profile_id,
  p.name                   AS profile_name,
  ROUND(AVG(wh.Rating),2)  AS avg_rating
FROM watch_history wh
JOIN profiles p ON wh.profile_id = p.profile_id
WHERE wh.Rating IS NOT NULL
GROUP BY wh.profile_id, p.name
HAVING AVG(wh.Rating) >= 8
ORDER BY avg_rating DESC;

-- 4. משתמשים עם מנוי פעיל (status='active') מתחילת השנה, כולל תאריך התחלה וסוג תכנית
SELECT
  u.user_id,
  u.name     AS user_name,
  s.plan_type,
  s.start_date
FROM users u
JOIN subscriptions s ON u.user_id = s.user_id
WHERE s.status = 'active'
  AND s.start_date >= DATE_TRUNC('year', CURRENT_DATE)
ORDER BY s.start_date;

-- 5. תכנים שהוזנו ל-watch_list ולא נצפו מעולם
SELECT
  wl.profile_id,
  p.name               AS profile_name,
  wl.content_id,
  c.Name               AS content_title,
  wl.added_at
FROM watch_list wl
JOIN profiles p   ON wl.profile_id = p.profile_id
JOIN content c    ON wl.content_id = c.content_id
LEFT JOIN watch_history wh 
  ON wl.profile_id = wh.profile_id
 AND wl.content_id = wh.content_id
WHERE wh.watched_at IS NULL
ORDER BY wl.added_at DESC;

-- 6. פילוח מספר הפרופילים שנוצרו לפי חודש ושנה
SELECT
  EXTRACT(YEAR  FROM created_at)  AS yr,
  EXTRACT(MONTH FROM created_at)  AS mo,
  COUNT(*)                        AS profiles_created
FROM profiles
GROUP BY yr, mo
ORDER BY yr, mo;

-- 7. שפות מועדפות: ספירת פרופילים לפי שדה language
SELECT
  pp.language,
  COUNT(*) AS profiles_count
FROM profile_preferences pp
GROUP BY pp.language
ORDER BY profiles_count DESC;

-- 8. תוכן הכי “פופולרי” לפי כמות צפיות (Top 5)
SELECT
  c.content_id,
  c.Name             AS content_title,
  COUNT(wh.*)        AS times_watched
FROM watch_history wh
JOIN content c ON wh.content_id = c.content_id
GROUP BY c.content_id, c.Name
ORDER BY times_watched DESC
LIMIT 5;

