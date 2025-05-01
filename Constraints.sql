-- 1. NOT NULL על users.country
ALTER TABLE users
  ALTER COLUMN country SET NOT NULL;

-- 2. CHECK על profiles.age_rating בין 0–18
ALTER TABLE profiles
  ADD CONSTRAINT chk_age_rating_range
    CHECK (age_rating BETWEEN 0 AND 18);

-- 3. DEFAULT על subscriptions.status = 'active'
ALTER TABLE subscriptions
  ALTER COLUMN status SET DEFAULT 'active';
