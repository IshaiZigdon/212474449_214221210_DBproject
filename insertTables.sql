-- Insert data into Users table
INSERT INTO Users (user_id, name, birth_date, country) VALUES 
(1, 'Alice', '1990-01-15', 'USA'),
(2, 'Bob', '1985-07-20', 'Canada'),
(3, 'Charlie', '1992-03-10', 'UK');

-- Insert data into content table
INSERT INTO content (content_id, Name) VALUES 
(1, 'The Shawshank Redemption'),
(2, 'The Godfather'),
(3, 'Inception');

-- Insert data into Subscriptions table (depends on Users)
INSERT INTO Subscriptions (email, password, plan_type, start_date, end_date, status, user_id) VALUES 
('alice@example.com', 'password123', 'premium', '2022-01-01', NULL, 'active', 1),
('bob@example.com', 'pass456', 'basic', '2022-02-15', '2023-02-15', 'inactive', 2),
('charlie@example.com', 'charlie789', 'free', '2022-03-10', NULL, 'active', 3);

-- Insert data into Payments table (depends on Subscriptions)
INSERT INTO Payments (amount, currency, payment_method, email) VALUES 
(29.99, 'USD', 'credit card', 'alice@example.com'),
(9.99, 'CAD', 'paypal', 'bob@example.com'),
(0.00, 'USD', 'none', 'charlie@example.com');

-- Insert data into profiles table (depends on Subscriptions)
INSERT INTO profiles (name, age_rating, created_at, profile_id, email) VALUES 
('AliceProfile', 18, '2022-01-02', 1, 'alice@example.com'),
('BobProfile', 16, '2022-02-16', 2, 'bob@example.com'),
('CharlieProfile', 12, '2022-03-11', 3, 'charlie@example.com');

-- Insert data into Profile_Preferences table (depends on profiles)
INSERT INTO Profile_Preferences (language, quality, notifications, profile_id) VALUES 
('English', 'HD', TRUE, 1),
('French', 'SD', FALSE, 2),
('English', '4K', TRUE, 3);

-- Insert data into watch_list table (depends on profiles and content)
INSERT INTO watch_list (added_at, profile_id, content_id) VALUES 
('2022-01-03', 1, 1),
('2022-01-04', 1, 2),
('2022-02-17', 2, 2),
('2022-02-18', 2, 3),
('2022-03-12', 3, 1),
('2022-03-13', 3, 3);

-- Insert data into watch_history table (depends on profiles and content)
INSERT INTO watch_history (watched_at, Rating, profile_id, content_id) VALUES 
('2022-01-05', 9, 1, 1),
('2022-01-06', 8, 1, 2),
('2022-02-19', 7, 2, 2),
('2022-02-20', 6, 2, 3),
('2022-03-14', 10, 3, 1),
('2022-03-15', 7, 3, 3);
