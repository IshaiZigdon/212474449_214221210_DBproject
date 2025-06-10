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