
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Claims"> 
 			             
<cfquery name="FactTable" 
   datasource="AppsIncident" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   NEWID() AS FactTableId, 
            PersonNo AS PersonNo_dim, 
			IC.Mission AS Mission_dim, 
			IC.Casualty AS Casualty_dim, 
			P.FirstName, 
			P.LastName 
	INTO    userquery.dbo.#SESSION.acc#Claims		
	FROM    Claim C, PersonClaim PC, IncidentClaim IC, Employee.dbo.Person P
	where C.ClaimId=PC.Claimid and PC.ClaimId=IC.ClaimId 
	and C.PersonNo=P.PersonNo
</cfquery>
	
<cfset client.table1_ds = "#SESSION.acc#Claims">
