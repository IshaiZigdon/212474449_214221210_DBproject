-- מתחילים טרנזקציה כדי לבדוק שינוי בלי לשמור אותו סופית
BEGIN TRANSACTION;

-- אני עכשיו משנה את המדינה של משתמש מספר 5 ל'Unknown'
UPDATE users
SET country = 'Unknown'
WHERE user_id = 5;

-- בודק שלאט־לאט השינוי אכן הוטמע, מוציא את השורה כדי לראות
SELECT user_id, name, country
FROM users
WHERE user_id = 5;
/*
 תוצאה צפויה:
 user_id |   name   | country
 --------+----------+---------
      5  | יוסי כהן | Unknown
*/

-- בסוף מחליט שלא רוצה את השינוי הזה, בוחרים לבטל את הכול
ROLLBACK;

-- עכשיו בודקים שוב: המדינה אמורה לחזור למה שהייתה לפני
SELECT user_id, name, country
FROM users
WHERE user_id = 5;
/*
 תוצאה צפויה (לפני השינוי):
 user_id |   name   | country
 --------+----------+---------
      5  | יוסי כהן | Mexico
*/
