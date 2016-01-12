CREATE EXTENSION pgcrypto;
CREATE TABLE batches (
       announced date NOT NULL,      -- date the batch was loaded/made/created
       seq int NOT NULL,             -- if more than one batch was made in a day, they can be numbered sequentially
       name text,
       sell_from date,
       average_price real,
       ingredients text,
       elzas_remarks text,
       PRIMARY KEY (announced, seq)
);
