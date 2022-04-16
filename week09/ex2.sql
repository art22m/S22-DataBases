CREATE OR REPLACE FUNCTION retrievecustomers(from_ int, to_ int) 
RETURNS SETOF customer AS
$BODY$
DECLARE
    r customer%rowtype;
BEGIN
	IF from_ < 1 OR (SELECT COUNT(*) FROM customer) < to_ THEN
		RAISE EXCEPTION 'Parameter from_ or to_ is out of range!';
	END IF;
	
    FOR r IN SELECT * FROM customer ORDER BY customer_id
    LOOP
		IF r.customer_id BETWEEN from_ AND to_ THEN
			RETURN NEXT r; 
		END IF;
    END LOOP;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM retrievecustomers(100,110);