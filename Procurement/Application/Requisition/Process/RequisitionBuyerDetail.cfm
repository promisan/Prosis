
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>  

<cfoutput>

	<iframe src="RequisitionBuyerDetailListing.cfm?mission=#url.mission#&mid=#mid#" width="100%" height="100%" marginwidth="1" marginheight="1" scrolling="no" frameborder="0"></iframe>
	
</cfoutput>
