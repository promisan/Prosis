
<!--- check role --->

<cfparam name="Attributes.ValidationCode"   default="">
<cfparam name="Attributes.SystemModule"     default="">
<cfparam name="Attributes.ValidationName"   default="">
<cfparam name="Attributes.ValidationMethod" default="">
<cfparam name="Attributes.ValidationScope"  default="1">

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Validation 
WHERE   ValidationCode = '#attributes.ValidationCode#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_Validation
		       (ValidationCode, 
			    SystemModule, 
				ValidationName,
				ValidationMethod, 
				ValidationScope, 
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName)
		VALUES ('#Attributes.ValidationCode#',
		        '#Attributes.SystemModule#',
				'#Attributes.ValidationName#',
				'#Attributes.ValidationMethod#',
				'#Attributes.ValidationScope#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
			   ) 
	</cfquery>
	
<cfelse>

	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Validation
		SET    SystemModule         = '#Attributes.SystemModule#', 
		       ValidationName       = '#Attributes.ValidationName#',		  
			   ValidationMethod     = '#Attributes.ValidationMethod#',
			   ValidationScope      = '#Attributes.ValidationScope#'				  
	 	WHERE  ValidationCode = '#Attributes.ValidationCode#'
	</cfquery>	

</cfif>