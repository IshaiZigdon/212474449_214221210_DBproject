# דוח פרויקט Streaming Service - מודול משתמשים

מסמך זה מתאר את העבודה שבוצעה בשלב התשאול והאכיפה (constraints) של בסיס הנתונים עבור מודול המשתמשים בפרויקט שירות הזרמת תוכן.

## מבנה הקבצים שנמסרו
1. **Queries.sql** - כולל 8 שאילתות SELECT מורכבות, 3 שאילתות DELETE ו-3 שאילתות UPDATE.
2. **Constraints.sql** - כולל 3 אילוצים (NOT NULL, CHECK, DEFAULT) שהתווספו לטבלאות שונות באמצעות `ALTER TABLE`.
3. **RollbackCommit.sql** - דוגמאות לשימוש ב-`ROLLBACK` ו-`COMMIT` להדגמת תהליך העסקאות (transactions).

---

## חלק א׳: שאילתות SELECT
לכל אחת מ-8 השאילתות שבקובץ **Queries.sql**:
- **תיאור** (בצורה תמציתית בעברית): מה משרתת השאילתה, אילו טבלאות מצורפות, ואיזה מידע היא מציגה.
- **צילום הרצה**: צילום מסך של הרצת השאילתה ב-SQL client.
- **צילום תוצאה**: תוצאות השאילתה (עד 5 שורות).

### דוגמה:
\`\`\`markdown
### שאילתה 1: משתמשים עם יותר מ-2 פרופילים
- **תיאור**: מוצאת משתמשים המחוברים ליותר מ-2 פרופילים, כולל שם, מדינה ומספר הפרופילים.
- **צילום הרצה**:
  ![Query1 Run](screenshots/query1_run.png)
- **צילום תוצאה**:
  ![Query1 Result](screenshots/query1_result.png)
\`\`\`

## חלק ב׳: שינויים בנתונים (DELETE ו-UPDATE)
עבור כל שאילתה בקטגוריה זו (3 DELETE ו-3 UPDATE):
- **תיאור** (במקור לעברית): מה מבצעת השאילתה ומתי נדרשת.
- **צילום הרצה של השאילתה**.
- **צילום מצב בסיס הנתונים לפני השינוי**.
- **צילום מצב בסיס הנתונים אחרי השינוי**.

### דוגמה:
\`\`\`markdown
### DELETE A: מחיקת העדפות לפרופילים לא קיימים
- **תיאור**: מוחקת רשומות מטבלת \`profile_preferences\` שאין להן פרופיל תואם בטבלת \`profiles\`.
- **מצב לפני**:
  ![DeleteA Before](screenshots/deleteA_before.png)
- **הרצת השאילתה**:
  ![DeleteA Run](screenshots/deleteA_run.png)
- **מצב אחרי**:
  ![DeleteA After](screenshots/deleteA_after.png)
\`\`\`

## חלק ג׳: אילוצים (Constraints)
בקובץ **Constraints.sql** הוספנו שלושה אילוצים:
1. **NOT NULL** על \`users.country\`.
2. **CHECK** על \`profiles.age_rating\` בין 0–18.
3. **DEFAULT** על \`subscriptions.status\` = 'active'.

עבור כל אילוץ:
- **תיאור השינוי**: הסבר בעברית מהו התפקיד של האילוץ.
- **הרצת הפקודה**: צילום מסך של הרצת פקודת ALTER TABLE.
- **בדיקת תקינות**: נסיון להכניס/לעדכן ערך שסותר את האילוץ, ו-**צילום השגיאה** שחזרה.

### דוגמה:
\`\`\`markdown
### אילוץ CHECK על age_rating
- **תיאור**: מבטיח שערכי \`age_rating\` יימצאו בטווח 0–18.
- **הרצת ALTER TABLE**:
  ![Constraint Run](screenshots/constraint_check_run.png)
- **נסיון שגוי**:
  ![Constraint Error](screenshots/constraint_check_error.png)
\`\`\`

## חלק ד׳: תהליך עסקאות (Transactions)
בקובץ **RollbackCommit.sql** הדגמנו שני תרחישים:
1. **ROLLBACK**: אופן חזרה למצב קודם לאחר פקודות DML בטרנזקציה.
2. **COMMIT**: אופן שמירת השינויים לצמיתות.

לכל אחד:
- **תיאור קצר**.
- **צילום מצב לפני**.
- **צילום הרצת השאילתה**.
- **צילום מצב אחרי** (לאחר ROLLBACK / COMMIT).

### דוגמה:
\`\`\`markdown
### ROLLBACK - דוגמה לשינוי זמני
- מצב לפני:
  ![Before Rollback](screenshots/rollback_before.png)
- הרצת UPDATE:
  ![Rollback Update](screenshots/rollback_update.png)
- הרצת ROLLBACK:
  ![Rollback Rollback](screenshots/rollback_rollback.png)
- מצב אחרי:
  ![Rollback After](screenshots/rollback_after.png)
\`\`\`

---

**בהצלחה בהגשה!**

Yours,
צוות פיתוח הפרויקט Streaming Service
