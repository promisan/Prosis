
<cfquery name="OwnerParam" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterOwner
	WHERE     Owner   = '#URL.Owner#' 
</cfquery>

<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      ApplicantReview
	WHERE     PersonNo   = '#URL.ID#' 
	AND       Owner      = '#URL.Owner#' 
	AND       ReviewCode = '#URL.ID1#' 
	AND       Status = '0'
</cfquery>
		
<CFIF Verify.recordCount eq 0 or OwnerParam.AddReviewPointer eq "1">  
	
	<cf_assignId>
		
	<cfquery name="InsertRequest" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO ApplicantReview
			 (ReviewId,
		      PersonNo, 
	          ReviewCode, 
			  Status, 
			  Owner,
			  ReviewRemarks, 
			  OfficerUserId, 
	   		  OfficerLastName, 
			  OfficerFirstName)
		VALUES  ('#rowguid#',
		         '#URL.ID#', 
		         '#URL.ID1#', 
				 '0', 
				 '#URL.Owner#',
				 'Requested', 
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#')
	</cfquery>
	
	<cfset id = rowguid>	
	
<cfelse>

	<cfset id = verify.reviewid>	
					
</CFIF>

<!--- check the roster status --->
<cfinvoke component = "Service.RosterStatus"  
   method           = "RosterSet" 
   personno         = "#Verify.PersonNo#" 
   owner            = "#url.Owner#"
   returnvariable   = "rosterstatus">	
		
<cflocation url="../General.cfm?Owner=#URL.Owner#&ID=#URL.ID#&section=general&topic=review&ID1=#URL.ID1#&reviewid=#id#" addtoken="No">