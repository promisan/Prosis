
<!--- customer container for kendo dialo --->


<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/> 

<table width="100%" height="100%" style="overflow: hidden;">
<tr><td style="height:100%;width:100%">
<iframe src="#SESSION.root#/Warehouse/Application/Customer/View/CustomerEditTab.cfm?mission=#url.mission#&scope=#url.scope#&mid=#mid#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>

</cfoutput>

