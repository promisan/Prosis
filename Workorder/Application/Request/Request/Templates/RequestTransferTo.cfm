<cfoutput>

    <table width="99%" align="center">
			
			<tr bgcolor="f4f4f4">
				<td  class="top4n" valign="top" colspan="3" height="30" style="padding:4px">
				
					<img src="#SESSION.root#/images/logos/workorder/userto.png" 
					height="30" width="30" alt=""  align="absmiddle" border="0">
					<font size="3">TO:</font>
					
				</td>
			</tr>
			<tr><td class="line" colspan="3"></td></tr>
			<tr><td height="5"></td></tr>		
			
			<cfquery name="Customer" 
			   datasource="AppsWorkOrder" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				 SELECT  *
			     FROM    Customer
				 <cfif LineCustomer.CustomerTo neq "">
				 WHERE   CustomerId = '#LineCustomer.CustomerTo#'		
				 <cfelse>
				 WHERE 1=0
				 </cfif>
			</cfquery>
			
			<cfquery name="Param" 
			   datasource="AppsWorkOrder" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				 SELECT  *
			     FROM    Ref_ParameterMission
				 WHERE   Mission = '#url.mission#'		
			</cfquery>
			
			<input type="hidden" name="customerto" id="customerto" value="#LineCustomer.CustomerTo#">
			
			<tr id="transfercustomer" class="#clc#">
				<td width="80" height="100%"  class="labelit" style="padding:4px">Customer:</td>
				<td>
				
				<cfif url.Accessmode eq "Edit">
				
					   <cfset link = "../Templates/RequestTransferGetCustomer.cfm?requestid=#url.requestid#">	
				
					   <cf_selectlookup
						    box          = "transferto"
							title        = "Select Customer"
							link         = "#link#"
							button       = "Yes"
							close        = "Yes"						
							icon         = "locate3.gif"
							filter1      = "mission"
							filter1value = "#param.TreeCustomer#"
							filter2      = "serviceitem"
							filter2value = "#url.serviceitem#"
							class        = "customer"
							des1         = "CustomerId">			
							
				</cfif>			
								
				</td>
				<td style="padding:4px" class="labelit" id="tocustomer">#Customer.CustomerName#</td>
			</tr>
						
			<tr id="transfercustomer" class="hide"><td id="transferto"></td></tr>		
			
			<cfquery name="Person" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    Person
					WHERE   PersonNo = '#User.personNoTo#'	
			</cfquery>				
			
			<input type="hidden" name="personnoto" id="personnoto" value="#User.PersonNoTo#">
							
			<tr id="transferperson" class="#clp#">
				<td width="80" height="100%"  class="labelit" style="padding:4px">User/Contact:</td>
				<td width="20" class="#clp#">
				
				<cfif url.Accessmode eq "Edit">
				
					   <cfset link = "../Templates/RequestTransferGetPerson.cfm?requestid=#url.requestid#">	
				
					   <cf_selectlookup
						    box        = "transferto"
							link       = "#link#"
							button     = "Yes"
							close      = "Yes"						
							icon       = "locate3.gif"
							class      = "employee"
							des1       = "PersonNo">			
							
					</cfif>			
				
				</td>
				<td style="padding:4px" id="toname" class="labelit">
				<a href="javascript:EditPerson('#User.PersonNoTo#')"><font color="0080FF"><cfif Person.LastName eq "">N/A<cfelse>#Person.FirstName# #Person.LastName#</cfif></a>
				</td>
			</tr>			
			<tr id="transferperson" class="#clp#">
				<td height="100%" style="padding:4px" class="labelit">IndexNo:</td>
				<td></td>
				<td style="padding:4px" id="toindexno" class="labelit">#Person.IndexNo#</td>
			</tr>			
			<tr id="transferperson" class="#clp#">
				<td height="100%"  style="padding:4px" class="labelit">Gender:</td>
				<td></td>
				<td style="padding:4px" id="togender" class="labelit">#Person.Gender#</td>
			</tr>			
			<tr id="transferperson" class="#clp#">
				<td height="100%"  style="padding:4px" class="labelit">Nationality:</td>
				<td></td>
				<td style="padding:4px" id="tonationality" class="labelit">#Person.Nationality#</td>
			</tr>
						
	</table>
			
</cfoutput>			