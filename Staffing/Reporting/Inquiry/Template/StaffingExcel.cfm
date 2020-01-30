
<cfparam name="client.recordid" default="''">

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#IndicatorStaffing">

<cfquery name="Staffing" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	INTO   userQuery.dbo.#SESSION.acc#IndicatorStaffing
	FROM   #SESSION.acc#_AppStaffingDetail_#url.fileno#	
	<cfif client.recordid neq "">
	WHERE  RecordNo IN (#preservesinglequotes(client.recordid)#)
	</cfif>	
 </cfquery> 
 
<cfset client.table1   = "#SESSION.acc#IndicatorStaffing">	


