
<CFSET Value   = Attributes.FieldValue>
<CFSET Param   = Attributes.SelectParameter>
<CFSET FileNo  = Attributes.FileNo>
    
  <!--- all valid potential combinations to be used for querying--->
    
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_Interview">	  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_INTSelect">
  
   <cfquery name = "All" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT PersonNo, Max(Created) as Created
   INTO	  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_Interview
   FROM   ApplicantInterview
   WHERE  Owner      = '#Attributes.Owner#'
   GROUP BY PersonNo
   </cfquery>	
	   
  <cfquery name = "All" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT Fun.PersonNo  
   INTO	  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_INTSelect
   FROM   ApplicantInterview R, 
          userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun, 
		  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_Interview int
   WHERE  Fun.PersonNo = R.PersonNo 
    AND   R.Owner      = '#Attributes.Owner#'
    AND   INT.PersonNo = R.PersonNo
	AND   INT.Created  = R.Created

	<cfif #Param# eq "1">
    	AND   R.InterviewStatus = 1
	<cfelse>
		AND   R.InterviewStatus = 9
		UNION
		SELECT DISTINCT Fun.PersonNo 
	    FROM   userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun 
	    WHERE  Fun.PersonNo NOT IN (SELECT PersonNo 
		                            FROM   userQuery.dbo.tmp#SESSION.acc#_#fileNo#_Interview) 
	</cfif>
    
  </cfquery>  
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_Interview">	  
  
   
