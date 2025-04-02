CREATE TABLE Users
(
  user_id INT NOT NULL,
  name VARCHAR(25) NOT NULL,
  birth_date DATE NOT NULL,
  country VARCHAR(15) NOT NULL,
  PRIMARY KEY (user_id)
);

CREATE TABLE Subscriptions
(
  email VARCHAR(40) NOT NULL,
  password VARCHAR(30) NOT NULL,
  plan_type VARCHAR(10) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  status VARCHAR(10) NOT NULL,
  user_id INT NOT NULL,
  PRIMARY KEY (email),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Payments
(
  amount FLOAT NOT NULL,
  currency VARCHAR(10) NOT NULL,
  payment_method VARCHAR(15) NOT NULL,
  email VARCHAR(40) NOT NULL,
  PRIMARY KEY (email),
  FOREIGN KEY (email) REFERENCES Subscriptions(email)
);

CREATE TABLE content
(
  content_id INT NOT NULL,
  Name VARCHAR(30) NOT NULL,
  PRIMARY KEY (content_id)
);

CREATE TABLE profiles
(
  name VARCHAR(25) NOT NULL,
  age_rating INT NOT NULL,
  created_at DATE NOT NULL,
  profile_id INT NOT NULL,
  email VARCHAR(40) NOT NULL,
  PRIMARY KEY (profile_id),
  FOREIGN KEY (email) REFERENCES Subscriptions(email)
);

CREATE TABLE Profile_Preferences
(
  language VARCHAR(25) NOT NULL,
  quality VARCHAR(5) NOT NULL,
  notifications BOOLEAN NOT NULL,
  profile_id INT NOT NULL,
  FOREIGN KEY (profile_id) REFERENCES profiles(profile_id)
);

CREATE TABLE watch_list
(
  added_at DATE NOT NULL,
  profile_id INT NOT NULL,
  content_id INT NOT NULL,
  PRIMARY KEY (profile_id, content_id),
  FOREIGN KEY (profile_id) REFERENCES profiles(profile_id),
  FOREIGN KEY (content_id) REFERENCES content(content_id)
);

CREATE TABLE watch_history
(
  watched_at DATE NOT NULL,
  Rating INT,
  profile_id INT NOT NULL,
  content_id INT NOT NULL,
  PRIMARY KEY (profile_id, content_id),
  FOREIGN KEY (profile_id) REFERENCES profiles(profile_id),
  FOREIGN KEY (content_id) REFERENCES content(content_id)
);