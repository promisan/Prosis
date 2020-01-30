
<cf_screentop  height="100%" scroll="vertical" html="no" ValidateSession="No">

<cf_submenuLogo module="Attendance" selection="Application">

<cfset heading = "General">
<cfset module = "'Attendance'">
<cfset selection = "'Application'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm"> 

 <cfquery name="SystemModule" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ModuleControl
		WHERE FunctionPath = 'TimeView/View.cfm'
	</cfquery>
	
<!--- specific menu--->
<cfset verifysource     = "'TimeKeeper'">
<cfset verifytable      = "">
<cfset menutemplate     = "TimeView/View.cfm">
<cfset module           = "'Attendance'">
<cfset class            = "'Time'">

<cfinclude template="../../Tools/SubmenuMission.cfm">
