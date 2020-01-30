  
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Budget">  

<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   Organization WHERE OrgUnit = '#url.id1#'
</cfquery>	

<cfquery name="Resource" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    P.ProgramCode,
	          Pe.Reference, 
			  P.ProgramName, 
			  Pe.Period,
			  PA.Fund,  				 
			  Ed.Description as EditionName,		 
			  O.Listingorder, 
			  O.CodeDisplay as Code, 
			  O.Description, 
			  round(SUM(PA.Amount),0) AS Amount
	INTO      userQuery.dbo.#SESSION.acc#Budget	
	FROM      Program P INNER JOIN ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN ProgramAllotmentDetail PA ON Pe.ProgramCode = PA.ProgramCode AND Pe.Period = PA.Period
	          INNER JOIN Ref_Object O ON PA.ObjectCode = O.Code INNER JOIN Ref_AllotmentEdition ED ON PA.EditionId = ED.EditionId
	WHERE     Pe.Period      = '#url.period#' 
	  AND     PA.EditionId   = '#url.edition#' 
	  AND     Pe.Status != '9'		 
	  AND     Pe.OrgUnit IN (SELECT OrgUnit
	                         FROM   Organization.dbo.Organization
							 WHERE  Mission = '#org.Mission#' 
							 AND    MandateNo = '#org.MandateNo#' 
							 AND    HierarchyCode LIKE '#Org.HierarchyCode#%')	
	  AND     PA.Status IN ('0', '1')		  
	GROUP BY  P.ProgramCode, 
	          Pe.Reference, 
			  P.ProgramName, 
			  Ed.Description,		
			  Pe.Period,
			  PA.Fund,  
			  O.Listingorder, 
			  O.CodeDisplay, 
			  O.Description
	ORDER BY  P.ProgramCode, PA.Fund, O.ListingOrder
</cfquery>	

<cfset client.table1   = "#SESSION.acc#Budget">	

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Requirement">  

<cfquery name="Resource" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    P.ProgramCode,
	          Pe.Reference, 
			  P.ProgramName, 
			  PA.Fund,  		
			  Pe.Period,	 
			  Ed.Description as EditionName,
			  O.Listingorder, 
			  O.CodeDisplay as Code, 
			  O.Description, 
			  PA.RequestDescription,
			  PA.RequestQuantity,
			  PA.RequestPrice,
			  PA.RequestAmountBase,
			  PA.RequestRemarks			 
	INTO      userQuery.dbo.#SESSION.acc#Requirement	
	FROM      Program P INNER JOIN ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN ProgramAllotmentRequest PA ON Pe.ProgramCode = PA.ProgramCode AND Pe.Period = PA.Period
	          INNER JOIN Ref_Object O ON PA.ObjectCode = O.Code INNER JOIN Ref_AllotmentEdition ED ON PA.EditionId = ED.EditionId
	WHERE     Pe.Period        = '#url.period#' 
	  AND     PA.EditionId     = '#url.edition#' 
	  AND     Pe.Status       != '9'	
	  AND	  PA.ActionStatus != '9'
	   AND    Pe.OrgUnit IN (SELECT OrgUnit
	                         FROM   Organization.dbo.Organization
							 WHERE  Mission     = '#org.Mission#' 
							 AND    MandateNo   = '#org.MandateNo#' 
							 AND    HierarchyCode LIKE '#Org.HierarchyCode#%')	
	ORDER BY  P.ProgramCode, PA.Fund, O.ListingOrder
</cfquery>	

<cfset client.table2   = "#SESSION.acc#Requirement">	


