
<cfparam name="url.init" default="0">


<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PositionParent		 
	 WHERE PositionParentId = '#positionparentid#'	 
</cfquery>

<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  Position		 
	 WHERE PositionParentId = '#positionparentid#'	 
	 ORDER BY DateEffective DESC
</cfquery>

<!--- check if we have an active workflow or not --->

<cfset showflow = "0">

<cfif Parent.recordcount gte "1">
				   
	<cf_wfActive entityCode="PostClassification" objectkeyvalue1="#Parent.PositionParentId#">
	
	<cfif wfStatus eq "Open" or url.init eq "1">	
		<cfset showflow = "1">
	</cfif>
	
</cfif>	

<cfif Parent.SourcePostNumber eq "">
	<cfset ref = "Classification #Parent.SourcePostNumber#">
<cfelse>
	<cfset ref = "Classification #Parent.PositionParentId#">
</cfif>

<cfif showFlow eq "1">
	
	<cfset link = "Staffing/Application/Position/PositionParent/PositionView.cfm?id2=#Position.PositionNo#">	
	
	<cfif url.init eq "1">		
	
		<cfquery name="CloseCurrent" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE  Organization.dbo.OrganizationObject
				 SET     Operational = 0
				 WHERE   ObjectKeyValue1 = '#Parent.PositionParentId#'
				 AND     EntityCode = 'PostClassification'							 
		</cfquery>
	
	</cfif>
	
	<cfquery name="Object" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT  *
			 FROM    Organization.dbo.OrganizationObject				
			 WHERE   ObjectKeyValue1 = '#Parent.PositionParentId#'
			 AND     Operational = 1							 
	</cfquery>
	
	<cfparam name="Form.EntityClass" default="#Object.EntityClass#">
			
	<cf_ActionListing 
	    EntityCode        = "PostClassification"
		EntityClass       = "#Form.EntityClass#"
		EntityGroup       = ""
		EntityStatus      = ""
		tablewidth        = "100%"
		Mission           = "#Parent.mission#"	
		OrgUnit           = "#Parent.OrgUnitOperational#"
		ObjectReference   = "#ref#"
		ObjectReference2  = "#Parent.PostGrade#" 	
	    ObjectKey1        = "#Parent.PositionParentId#"	
		AjaxId            = "#URL.ajaxId#"
		ObjectURL         = "#link#"
		Show              = "Mini"
		HideCurrent       = "No">
	
</cfif>	