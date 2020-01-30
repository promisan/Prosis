<cfoutput>

<cfset tReportPath = "Payroll/Maintenance/SalarySchedule/SalarySchedulePrint.cfr">

<cfquery name="getLogoInfo"
datasource="AppsInit" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Parameter
	WHERE  HostName  = '#CGI.HTTP_HOST#'
</cfquery>

<cfset Session.LogoPath = getLogoInfo.LogoPath>
<cfset Session.LogoFileName = getLogoInfo.LogoFileName>

<script>
	  window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=#URL.scaleno#&ID0=#tReportPath#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
</script>

</cfoutput>
