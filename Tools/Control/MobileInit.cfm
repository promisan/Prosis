<cfquery name="Parameter" 
	datasource="AppsSystem">
		SELECT 	* 
		FROM 	Parameter
</cfquery>

<cfset APPLICATION.DateFormat 		= "#Parameter.DateFormat#">	
<cfset APPLICATION.DateFormatSQL    = "#Parameter.DateFormatSQL#">

<cfif trim(ucase(APPLICATION.DateFormat)) eq "EU">
	<cfset CLIENT.DateFormatShow	= "dd/mm/yyyy">
<cfelse>
	<cfset CLIENT.DateFormatShow   	= "mm/dd/yyyy">
</cfif>

<!--- <cfset applicationStop() /> --->