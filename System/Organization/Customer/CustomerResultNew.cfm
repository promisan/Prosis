		  
<cfif len(url.customerid) gte "20">  
  
	<cfquery name="Get" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Customer
			WHERE CustomerId  = '#URL.CustomerId#' 		
	</cfquery>
	
	<cfoutput>
	
	<table cellspacing="0" cellpadding="0" width="100%" class="navigation_table">
	
	<tr class="navigation_row">		
	
		<td id="box#url.customerid#" width="100%">	
				
			<table width="100%" border="0" cellspacing="0" cellpadding="0" onclick="ColdFusion.navigate('CustomerEdit.cfm?systemfunctionid=#url.systemfunctionid#&customerid=#CustomerId#&dsn=#url.dsn#','detail')">
			
					<tr>
					
						<td height="18" rowspan="2" width="20"><img src="#SESSION.root#/images/pointer.gif" height="9" alt="" border="0"></td>			
						<td class="labelit" oncontextmenu="viewOrgUnit('#get.orgunit#')">
							<font size="2" color="gray"><b>#Get.CustomerName# <cfif Get.OrgUnit neq "">[#Get.OrgUnit#]</cfif></td>
						</td>
					
					</tr>
										
			</table>		
		</td>		
		
	</tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	</table>
	
	</cfoutput>
	
</cfif>		

<cfset AjaxOnLoad("doHighlight")>	