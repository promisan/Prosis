
<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT ItemNo 
	FROM   Request
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE Request
	SET    RequestedQuantity = '#quantity#' 
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Line" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Request	
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Total" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

		SELECT sum(RequestedAmount) as Standard, sum(ItemAmount) as ItemPrice		      
		FROM  Materials.dbo.Request L
			  
			  <!---	  
			<cfif getAdministrator(url.mission) eq "1">
			<!--- no filtering --->
			<cfelse>
			   ,OrganizationAuthorization O 
			</cfif>
				--->
				
		WHERE L.Status   = '#line.Status#' 
		AND   L.Reference  = '#Line.Reference#' 
				
		
</cfquery>

<cfoutput>

	#NumberFormat(Line.RequestedAmount,'__,____.__')#	

	<script>
	    document.getElementById('sale_#URL.ID#').innerHTML = "#NumberFormat(Line.ItemAmount,',.__')#"
		document.getElementById('boxstd_#line.reference#').innerHTML = "#NumberFormat(Total.Standard,',.__')#"
		document.getElementById('boxprc_#line.reference#').innerHTML = "#NumberFormat(Total.ItemPrice,',.__')#"
	</script>

</cfoutput>



