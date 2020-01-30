
<cfparam name="attributes.Mission"     default="">
<cfparam name="attributes.Datasource"  default="AppsOrganization">
<cfparam name="Attributes.RecordDate"  default="#DateFormat(now(), CLIENT.DateFormatShow)#">
<cfparam name="Attributes.RecordTime"  default="#TimeFormat(now(), 'HH:MM')#">

<cfset dateValue = "">
<CF_DateConvert Value="#Attributes.RecordDate#">
<cfset dte = dateValue>

<cfset dte = DateAdd("h","#TimeFormat(Attributes.RecordTime, 'HH')#", dte)>
<cfset dte = DateAdd("n","#TimeFormat(Attributes.RecordTime, 'MM')#", dte)>

<cfquery name="Param"
    datasource="#attributes.datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT * 
	FROM   System.dbo.Parameter 	
</cfquery>
	
<!--- database server timezone --->
	
<cfquery name="MissionZone"
    datasource="#attributes.datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   TOP 1 * 
	FROM     Organization.dbo.Ref_MissionTimeZone
	WHERE    Mission = '#attributes.Mission#'
	AND      DateEffective <= #dte# 
	ORDER BY DateEffective DESC 	
</cfquery>

<cfif MissionZone.recordcount eq "1">

	<!--- if server is in brindisi the time is 7 hours earlier --->
	<cfset correction = (Param.DatabaseServerTimeZone - MissionZone.TimeZone)*-1>	
	<cfset dte = DateAdd("h",correction,dte)>	
	<cfset caller.timezone  = "#MissionZone.TimeZone#:00">	
	
<cfelse>	

	<cfset caller.timezone  = "0:00">	
	<cfset correction = 0>
	
</cfif>		
	
<cfset caller.localtime = dte>
<cfset caller.correction = correction>