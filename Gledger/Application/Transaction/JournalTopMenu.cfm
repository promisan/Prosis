		 
			<cfoutput>

	         <table width="100%" align="left">
		    <tr class="labelmedium">
			
				<td style="font-size:30px;height:65px;font-weight:350">					
				#Journal.Description# <font size="2">#Journal.Journal#</font>
				</td>
			
				<td style="padding-left:4px;padding-bottom:3px;width:30px;font-weight:200">			
									
				<span style="display:none;" id="printTitle"><cf_tl id="Journal"> #Journal.Journal# #Journal.Description#</span>
				
				</td>							
			  					   
				<td height="40"> 	
				
				<!--- aded 16/6 to read this from the system journal reference table --->
				<cfquery name="check" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
			      SELECT * 
				  FROM   Ref_SystemJournal
				  WHERE  Area = '#Journal.SystemJournal#'					
				</cfquery>
				
								
			    <cfif check.DirectEntry eq "1" or check.recordcount eq "0">
				
					<!--- if no system journal OR system journal is enabled for manual entry --->
									
					<cfinvoke component="Service.Access"
					   Method="Journal"
					   Journal="#URL.Journal#"
					   OrgUnit="#URL.OrgUnit#"
					   ReturnVariable="Access">	
					   
					<cfif access eq "EDIT" or access eq "ALL">					 
					   						
						<cfif Journal.SystemJournal neq "Procurement">
						
							<cf_tl id="Record Transaction" var="journallabel">
															
							<input type="button" id="ASq" value="#journallabel#" class="button10g" style="width:240px;font-size:15;height:30px"
							    onclick="EnterTransaction('#URL.Mission#','#URL.OrgUnit#','#Journal.Journal#','#URL.Period#','#url.referenceid#','#url.referenceorgunit#')">
									
								
						</cfif>	
						
					</cfif>	
				
				</cfif>	
					
				</td>
				
				<!---
			   <td>
			   													
				<cfinvoke component="Service.Access"
				   Method="RoleAccess"
				   Role="'AccountManager'"
				   Mission="#URL.Mission#"				 				   
				   ReturnVariable="Access">							   
			   
			   <cfif access eq "GRANTED">			
			
				   <input type="button" name="Parent" value="Statement" class="button10s"
	     			style="width:125;height:20px"
					onClick="javascript:Statement('#URL.Mission#','#URL.OrgUnit#','#URL.Period#')">   
				
			   </cfif>
			   
			   								
			</td>
			
			--->									
			
		
			
	 </tr>
 
</table>

</cfoutput>
		
