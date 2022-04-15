CREATE OR REPLACE FUNCTION retrieveAddress()  
RETURNS TABLE(address_id int, address varchar(50))  
LANGUAGE plpgsql  
AS  
$$  
BEGIN  
   RETURN QUERY
   SELECT a_.address_id, a_.address
   FROM address AS a_
   WHERE a_.address LIKE '%11%' AND a_.city_id BETWEEN 400 AND 600; 
END;  
$$;  

ALTER TABLE address ADD COLUMN longitude FLOAT DEFAULT(0);
ALTER TABLE address ADD COLUMN latitude FLOAT DEFAULT(0);
