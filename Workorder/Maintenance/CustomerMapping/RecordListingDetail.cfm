
<cfinvoke component="Service.Presentation.Presentation"
       method="highlight"
    returnvariable="stylescroll"/>

<cfset maxNumberOfRecords = 1000>

<cfquery name="GetSize" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT	COUNT(*) as Total
	FROM
		(
			SELECT	M.*, 
					isnull(C.Mission, 'Mission not defined') as mission, 
					isnull(C.CustomerName, 'Customer not defined') as customerName
			FROM	stCustomerMapping M 
					LEFT OUTER JOIN Customer C ON M.CustomerId = C.CustomerId
		) Data
	WHERE 1 = 1
	<cfif client.search neq "">AND #PreserveSingleQuotes(client.search)#</cfif>
	<cfif url.getNulls eq "0">AND CustomerId is null</cfif>
	
</cfquery>


<table width="95%" align="center">
				
    <TR height="25" valign="middle">
		<td width="50"></td>	
	   	<td>Mapping Code</td>
    </TR>	
	
	<tr><td colspan="2" class="line"></td></tr>				
		
	<cfif GetSize.Total gt maxNumberOfRecords>
	
		<cf_message	message = "Your search exceeds the #lsNumberFormat(maxNumberOfRecords, ',')# records, please narrow your search." return = "no">					
		
	<cfelse>				
	
		<cfif GetSize.Total eq 0>				
		
			<cf_message	message = "No records found for the selected criteria."return = "no">						
			
		<cfelse>	
		
			<cfquery name="Listing" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT	*
				FROM
					(
						SELECT	M.*, 
								isnull(C.Mission, 'Mission not defined') as mission, 
								isnull(C.CustomerName, 'Customer not defined') as customerName
						FROM	stCustomerMapping M 
								LEFT OUTER JOIN Customer C ON M.CustomerId = C.CustomerId
					) Data
				WHERE 1 = 1
				<cfif client.search neq "">AND #PreserveSingleQuotes(client.search)#</cfif>
				<cfif url.getNulls eq "0">AND CustomerId is null</cfif>
				ORDER BY Mission, CustomerId, MappingCode
				
			</cfquery>	

			<cfoutput query="Listing" group="mission">							
																													
					<TR>
					  <td colspan="2" height="25" class="labellarge">#mission#</td>
					</TR>					
					
					<cfoutput group="customerid">
					
						<TR >
						  <td height="25" colspan="2" class="labelmedium">&nbsp;&nbsp;&nbsp;&nbsp;#customername#</td>
						</TR>
								<cfoutput>
								
									<TR onMouseOver="this.bgColor = 'FFFFCF'" onMouseOut = "this.bgColor = 'FFFFFF'" >
									   <td align="right">
									    <table>
											<tr>
												<td>#currentrow#. &nbsp;&nbsp;</td>
												<td><cf_img icon="edit" onclick="recordeditcustomermapping('#transactionId#','#url.getNulls#')"></td>
												<td><cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) ColdFusion.navigate('RecordListingPurge.cfm?ID=#TransactionId#&getNulls=#url.getNulls#','listing');"></td>
											</tr>
										</table>
									  </td>									  									   
									  <td width="90%">#mappingCode#</td>	   
								   </tr>									  								   			 
									 					
								</cfoutput>
								
								<tr><td colspan="2" class="line"></td></tr>					
								<TR><td height="15" colspan="2"></td></tr>
								
					</cfoutput>
			</cfoutput>		
			
		</cfif>									
		
	</cfif>
				
</table>