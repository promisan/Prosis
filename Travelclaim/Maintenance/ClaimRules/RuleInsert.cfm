
<cfparam name="Attributes.Enforce" default="0">
<!--- check role --->

<cfquery name="Check" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Validation
WHERE Code = '#Attributes.Code#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Validation
	       (Code, TriggerGroup, ValidationClass, ValidationContext, Description, MessagePerson, MessageAuditor, Color, ValidationPath, ValidationTemplate, 
                      Remarks, Operational,Enforce)
	VALUES ('#Attributes.Code#',
	         '#Attributes.TriggerGroup#', 
			 '#Attributes.ValidationClass#', 
			 '#Attributes.ValidationContext#', 
			 '#Attributes.Description#', 
			 '#Attributes.MessagePerson#', 
			 '#Attributes.MessageAuditor#', 
			 '#Attributes.Color#', 
			 '#Attributes.ValidationPath#', 
			 '#Attributes.ValidationTemplate#', 
             '#Attributes.Remarks#', 
			 '#Attributes.Enforce#',
			 '#Attributes.Operational#')
	</cfquery>
	
</cfif>
