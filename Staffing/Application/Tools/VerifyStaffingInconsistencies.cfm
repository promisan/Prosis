<!---- 1. Assignment date effective vs Contract date effective --->

<cfquery name="Insert"  datasource="AppsEmployee"  username="#SESSION.login#"  password="#SESSION.dbpw#">

	INSERT  INTO AuditIncumbency(AuditElement,AuditPersonNo,Observation)
	
	SELECT 'Person', 
			MinPC.PersonNo, 
		   'First contract effective date '+CONVERT(varchar, MinPC.MinDateEffective, 101)+' lies after first assignment effective date '+CONVERT(varchar, MinPA.MinDateEffective, 101)
    FROM   (
	       SELECT PersonNo, MIN(DateEffective)  AS MinDateEffective
	       FROM   UserQuery.dbo.#SESSION.acc#PersonContract
	       GROUP  BY PersonNo
	) MinPC
	INNER JOIN (
				SELECT   PersonNo, MIN(DateEffective) AS MinDateEffective
	        	FROM   UserQuery.dbo.#SESSION.acc#PersonAssignment
	        	GROUP  BY PersonNo
	       ) MinPA
	ON MinPC.PersonNo = MinPA.PersonNo AND MinPC.MinDateEffective > MinPA.MinDateEffective

</cfquery>


<!--- 2. Assignment Date Expiration vs. Contract Date Expiration --->

<cfquery name="Insert"  datasource="AppsEmployee"  username="#SESSION.login#"  password="#SESSION.dbpw#">

	INSERT  INTO AuditIncumbency(AuditElement,AuditPersonNo,Observation)
	SELECT 'Person', 
			MaxPC.PersonNo, 
			'Last contract expiration date '+CONVERT(varchar, MaxPC.MaxDateExpiration, 101)+' does not match last assignment expiration date ' +CONVERT(varchar, MaxPA.MaxDateExpiration, 101)
	  FROM   (
	       SELECT PersonNo, MAX(DateExpiration)  AS MaxDateExpiration
	       FROM   UserQuery.dbo.#SESSION.acc#PersonContract
	       GROUP  BY PersonNo
	) MaxPC
	INNER JOIN (
			 SELECT PersonNo, MAX(DateExpiration) AS MaxDateExpiration
	         FROM   UserQuery.dbo.#SESSION.acc#PersonAssignment
	         GROUP  BY PersonNo
	       ) MaxPA
	ON MaxPC.PersonNo = MaxPA.PersonNo AND MaxPC.MaxDateExpiration != MaxPA.MaxDateExpiration

</cfquery>


<!--- 3. Contract gaps --->

<cfquery name="Insert"  datasource="AppsEmployee"  username="#SESSION.login#"  password="#SESSION.dbpw#">

	INSERT  INTO AuditIncumbency(AuditElement,AuditPersonNo,Observation)

	SELECT DISTINCT 'Person', PersonNo, 'Contracts are not continuos for this person'
	FROM (
	    SELECT ROW_NUMBER() OVER(PARTITION BY PersonNo ORDER BY DateEffective ASC) AS RecordNo , PC.PersonNo, PC.DateEffective, PC.DateExpiration, DATEADD(day, 1,PC.DateExpiration) AS DateExpirationExtended
	    FROM   UserQuery.dbo.#SESSION.acc#PersonContract PC
	) AS RecordA
	WHERE EXISTS (
	    SELECT 'X'
	    FROM  (
			  SELECT ROW_NUMBER() OVER(PARTITION BY PersonNo ORDER BY DateEffective ASC) AS RecordNo , PC.PersonNo, PC.DateEffective, DateExpiration
			  FROM   UserQuery.dbo.#SESSION.acc#PersonContract PC
	    ) AS RecordB
	    WHERE  
		   --Same person
		   RecordA.PersonNo = RecordB.PersonNo 
		   --RecordA and B are originally consecutive
		   AND RecordA.DateExpiration < RecordB.DateEffective 
		   --Even when recordA expiration date is increased by 1 day, it is still behind effective date of recordB
		   AND RecordA.DateExpirationExtended < RecordB.DateEffective 
		   --Make sure that only consecutive records are compared
		   AND (RecordA.RecordNo + 1 = RecordB.RecordNo)
		    --There is infact an issue only if there is a valid assignment during the gap
		   AND EXISTS (
			  SELECT 'X'
			  FROM   UserQuery.dbo.#SESSION.acc#PersonAssignment PA
			  WHERE  PA.PersonNo = RecordB.PersonNo
			  AND 
			  (   
				 --Assignment's date effective falls within the gap
				 (PA.DateEffective>RecordA.DateExpiration AND PA.DateEffective < RecordB.DateEffective)
				 OR
				 --Assignment's date expiration falls within the gap
				 (PA.DateExpiration>RecordA.DateExpiration AND PA.DateExpiration<RecordB.DateEffective)
				 OR
				 --Assignment covers the full gap
				 (PA.DateEffective<=RecordA.DateExpiration AND PA.DateExpiration>=RecordB.DateEffective)
			  )
		   )
	)
	AND EXISTS (
		SELECT 'X'
		FROM   UserQuery.dbo.#SESSION.acc#PersonContract C3
		WHERE  RecordA.PersonNo = C3.PersonNo
	)
	
</cfquery>

<!--- 4. Validate number of assignments per post --->

<cfquery name="Insert"  datasource="AppsEmployee"  username="#SESSION.login#"  password="#SESSION.dbpw#">

	INSERT  INTO AuditIncumbency(AuditElement,AuditSourceNo,Observation)

	SELECT 'Position',PositionNo, 'There are '+CONVERT(VARCHAR,COUNT(*))+' '+AssignmentClass+' '+CONVERT(VARCHAR,Incumbency)+'% assignments for this post'
	FROM   UserQuery.dbo.#SESSION.acc#PersonAssignment
	GROUP  BY PositionNo, Assignmentclass, Incumbency
	HAVING  COUNT(*)>1
	
</cfquery>

<!--- 5. Check if contracts are covered by an assignment --->

<cfquery name="Insert"  datasource="AppsEmployee"  username="#SESSION.login#"  password="#SESSION.dbpw#">

	INSERT  INTO AuditIncumbency(AuditElement,AuditPersonNo,Observation)

	SELECT 'Person', PersonNo,'Contract Id '+CONVERT(VARCHAR(36),ContractId)+' is not covered by an assignment'
	FROM   UserQuery.dbo.#SESSION.acc#PersonContract PC
	WHERE  NOT EXISTS (
	    SELECT 'X'
	    FROM   UserQuery.dbo.#SESSION.acc#PersonAssignment PA
	    WHERE  PC.PersonNo = PA.PersonNo
	)
	AND NOT EXISTS (
	    SELECT 'X'
	    FROM   UserQuery.dbo.#SESSION.acc#PersonAssignment A
	    WHERE  PC.PersonNo = A.PersonNo
	)
	AND NOT EXISTS (
	    SELECT 'X'
	    FROM    UserQuery.dbo.#SESSION.acc#PersonAssignment A2
	    WHERE   PC.PersonNo = A2.PersonNo
	)
	
</cfquery>