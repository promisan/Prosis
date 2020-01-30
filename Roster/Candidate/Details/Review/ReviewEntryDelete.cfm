
<cfquery name="get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   ApplicantReview
	WHERE  ReviewId = '#URL.ReviewId#' 
</cfquery>   

<cfquery name="Delete" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM  ApplicantReview
	WHERE     ReviewId = '#URL.ReviewId#' 
</cfquery>   

<cfinvoke component = "Service.RosterStatus"  
   method           = "RosterSet" 
   personno         = "#get.PersonNo#" 
   owner            = "#get.Owner#"
   returnvariable   = "rosterstatus">	
	
<cflocation url="../General.cfm?Owner=#URL.Owner#&ID=#URL.ID#&section=general&topic=review&ID1=#URL.ID1#" addtoken="No">