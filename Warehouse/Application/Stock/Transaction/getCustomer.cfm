<!--- retrieve the item --->

<cfparam name="url.customerid"   default="">

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Customer
			WHERE    CustomerId = '#url.customerid#'		
</cfquery>

<cf_verifyOperational module="WorkOrder" Warning="No">

<cfif get.recordcount eq "0" and operational eq "1">

	<cfquery name="Get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Customer
			WHERE    CustomerId = '#url.customerid#'		
	</cfquery>
	
</cfif>

<cfoutput>
			
	<script language="JavaScript">				   
		try { document.getElementById('customerid').value = "#url.customerid#" } catch(e) {}
	</script>		
		
	<table width="100%" cellspacing="0" cellpadding="0">
	
		<tr>
		    <td width="90%" class="labelit" style="height:20;padding-left:3px">#get.customername#</td>		
		</tr>
	
	</table>	

</cfoutput>


