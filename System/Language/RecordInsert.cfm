<cfparam name="Attributes.Operational" default="0">

<cftry>

<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_SystemLanguage
		(Code,Description,SystemDefault,Operational)
		VALUES
		('#Attributes.Code#','#Attributes.Description#','#Attributes.Default#','#Attributes.Operational#')
	</cfquery>
	
<cfcatch></cfcatch>

</cftry>