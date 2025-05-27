BEGIN;

-- 1. Drop FKs that reference content(content_id)
ALTER TABLE watch_list    DROP CONSTRAINT watch_list_content_id_fkey;
ALTER TABLE watch_history DROP CONSTRAINT watch_history_content_id_fkey;

-- 2. Recreate FKs from watch_list → title
ALTER TABLE watch_list
  RENAME COLUMN content_id TO title_id;

ALTER TABLE watch_list
  ADD CONSTRAINT fk_watch_list_title
    FOREIGN KEY (title_id) REFERENCES title(title_id);

-- 3. Recreate FKs from watch_history → title
ALTER TABLE watch_history
  RENAME COLUMN content_id TO title_id;

ALTER TABLE watch_history
  ADD CONSTRAINT fk_watch_history_title
    FOREIGN KEY (title_id) REFERENCES title(title_id);

-- 4. droping the table 'content'
DROP TABLE content;

COMMIT;