
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<!--- delete cached html which triggers a refresh in postview loop --->

<cftry>
	<cffile action="DELETE" file="#SESSION.rootPath#/CFReports/Cache/#link#.htm">
	<cfcatch></cfcatch>
</cftry>

<cfset lnk = "#replace(url.link,"_","&",'ALL')#">
<script language="JavaScript">
       window.location = "PostViewLoop.cfm?#lnk#&mid=#mid#" 
</script>
	
</cfoutput>

	