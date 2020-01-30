
<cfset vyear = mid(url.id3, 1, 4)>
<cfset vmonth = mid(url.id3, 6, 2)>
<cfset vday = mid(url.id3, 9, 2)>
<cfset vSelectionDate = createDate(vyear, vmonth, vday)>

<cfquery name="getMissionPosting" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ServiceItemMissionPosting
	WHERE 	ServiceItem	= '#url.id1#'
	AND		Mission = '#url.id2#'
	AND		SelectionDate < #vSelectionDate#
</cfquery>
<cfoutput>
	<font color="808080">
	#Dateformat(vSelectionDate, "#CLIENT.DateFormatShow#")#	
	</font>
</cfoutput>