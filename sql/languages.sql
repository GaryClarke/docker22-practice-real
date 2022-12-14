CREATE TABLE IF NOT EXISTS language (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS translation (
   id INT AUTO_INCREMENT PRIMARY KEY,
   language_id INT NOT NULL,
   phrase VARCHAR(255) NOT NULL,
   translation VARCHAR(255) NOT NULL
);

CREATE INDEX IDX_LANGUAGE_ID ON translation (language_id);

ALTER TABLE translation ADD CONSTRAINT FK_CONFERENCE_ID FOREIGN KEY (language_id) REFERENCES language (id);

