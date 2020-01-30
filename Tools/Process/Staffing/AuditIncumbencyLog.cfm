
<!--- check role --->

<!---
<cfparam name="Attributes.PositionParentId" default="">
<cfparam name="Attributes.Element"          default="">
<cfparam name="Attributes.ElementNo"        default="">
<cfparam name="Attributes.Observation"      default="">
--->

<cfparam name="Attributes.AuditElement"     default="">
<cfparam name="Attributes.AuditSourceNo"    default="">
<cfparam name="Attributes.AuditSourceId"    default="">
<cfparam name="Attributes.Observation"      default="">


<cfquery name="Insert" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO AuditIncumbency
	       (AuditElement,
		    AuditSourceNo, 
			<cfif Attributes.AuditSourceId neq "">
		    AuditSourceId, 
			</cfif>
			Observation) 
	VALUES ('#Attributes.AuditElement#',
			'#Attributes.AuditSourceNo#',
			<cfif Attributes.AuditSourceId neq "">
			'#Attributes.AuditSourceId#',
			</cfif>
	        '#Attributes.Observation#')
</cfquery>
	