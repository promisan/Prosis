
<cf_screentop height="100%" html="Yes" layout="webapp" banner="gray" bannerheight="55" scroll="No" user="Yes" 
    close="ColdFusion.Window.destroy('recordpayable',true)" label="Register Payable">

<table width="100%" height="100%">
<tr><td>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>

		<iframe src="#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntry.cfm?salesid=#url.salesid#&mode=warehouse&Mission=#url.mission#&Warehouse=#url.warehouse#&OrgUnit=#url.orgunit#&PurchaseNo=#url.purchaseno#&currency=#url.currency#&mid=#mid#"
	        width="100%"
	        height="100%"
	        scrolling="no"
	        frameborder="0">
		</iframe>
			
</cfoutput>
</td></tr>
</table>

<cf_screenbottom layout="webapp">
