EXPLAIN ANALYZE 
SELECT id 
FROM customer 
WHERE id = 100 OR id = 25000 AND id != 10000;
-- Before indexing:
-- Bitmap Heap Scan on customer  
-- (cost=8.86..16.82 rows=2 width=4) 
-- (actual time=0.072..0.076 rows=2 loops=1)
-- Planning Time: 0.183 ms
-- Execution Time: 0.115 ms

-- After indexing:
-- Bitmap Heap Scan on customer  
-- (cost=8.02..15.98 rows=2 width=4) 
-- (actual time=0.063..0.067 rows=2 loops=1)
-- Planning Time: 0.443 ms
-- Execution Time: 0.097 ms

EXPLAIN ANALYZE 
SELECT review 
FROM customer 
WHERE LENGTH(review) < 20;
-- Before indexing:
-- Seq Scan on customer  
-- (cost=0.00..15098.56 rows=111057 width=149) 
-- (actual time=24.459..384.308 rows=29 loops=1)
-- Planning Time: 0.088 ms
-- Execution Time: 384.342 ms

-- After indexing:
-- Seq Scan on customer  
-- (cost=0.00..14086.61 rows=103614 width=149) 
-- (actual time=26.435..413.965 rows=27 loops=1)
-- Planning Time: 0.111 ms
-- Execution Time: 414.007 ms

-- DROP INDEX idx_name_btree;
-- DROP INDEX idx_review_btree;
-- DROP INDEX idx_id_hash;

EXPLAIN ANALYZE 
SELECT name 
FROM customer 
WHERE name = 'Charles Hall';
-- Before indexing:
-- Gather  
-- (cost=1000.00..8879.14 rows=3 width=14) 
-- (actual time=3.399..90.473 rows=3 loops=1)
-- Planning Time: 0.889 ms
-- Execution Time: 90.515 ms

-- After indexing:
-- Index Only Scan using idx_name_btree on customer  
-- (cost=0.42..8.47 rows=3 width=14) 
-- (actual time=0.203..0.210 rows=4 loops=1)
-- Planning Time: 1.469 ms
-- Execution Time: 0.234 ms