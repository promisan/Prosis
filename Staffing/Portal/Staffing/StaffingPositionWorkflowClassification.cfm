
<cfparam name="url.init" default="0">

<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PositionParent		 
	 WHERE PositionParentId = '#positionparentid#'	 
</cfquery>

<!--- check if we have an active workflow or not --->

<cfset showflow = "0">

<cfif Parent.recordcount gte "1">
				   
	<cf_wfActive entityCode="PostClassification" objectkeyvalue1="#Parent.PositionParentId#">
	
	<cfif wfStatus eq "Open" or url.init eq "1">	
		<cfset showflow = "1">
	</cfif>
	
</cfif>	

<cfif showFlow eq "1">
	
	<cfset link = "Staffing/Application/Position/PositionParent/ParentClassificationWorkflow.cfm?id2=#positionparentid#">			
			
	<cf_ActionListing 
	    EntityCode        = "PostClassification"
		EntityClass       = "Standard"
		EntityGroup       = ""
		EntityStatus      = ""
		tablewidth        = "100%"
		Mission           = "#Parent.mission#"	
		ObjectReference   = "Classification"
		ObjectReference2  = "#Parent.PostGrade#" 	
	    ObjectKey1        = "#Parent.PositionParentId#"	
		AjaxId            = "#URL.ajaxId#"
		ObjectURL         = "#link#"
		Show              = "Mini"
		HideCurrent       = "No">
	
</cfif>	
 	
 		
	
	
	