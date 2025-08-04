<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<table width="94%" border="0"  align="center" cellspacing="0" cellpadding="1">

	<tr><td colspan="2" align="right" style="padding-right:5px;">
		<cfoutput>
		<span id="printTitle" style="display:none;"><cf_tl id="Authorised Charges">: #SearchResult.FullName#</span>
		</cfoutput>
		<cf_tl id="Print" var="1">
		<cf_button2 
			mode		= "icon"
			type		= "Print"
			title       = "#lt_text#" 
			id          = "Print"					
			height		= "30px"
			width		= "35px"
			printTitle	= "##printTitle"
			printContent = ".clsPrintContent">
	</td></tr>

	<tr><td height="14" colspan="2"></td></tr> 	

	<tr><td colspan="2" class="clsPrintContent">
	
		<table width="99%" align="center" class="navigation_table">
		
		<tr class="labelmedium line">
		   	
			<td style="width:100"><cf_tl id="Device"></td>					
			<TD><cf_tl id="Closing Date"></TD>
			<td><cf_tl id="Start Period"></td>
			<td><cf_tl id="End Period"></td>
			<td align="right"><cf_tl id="Transactions"></td>
			<TD align="right"><cf_tl id="Total Business"></TD>
		    <TD align="right"><cf_tl id="Total Personal"></TD>
			<TD width="20"></TD>			  
		</TR>
						
		<cfoutput query="SearchResult" group="reference">
		
			<cfset row = "0">
			
			<cfif url.scope eq "portal">
			<tr>			
				<td class="labellarge" style="height:30px"><cf_stringtoformat value="#reference#" format="#ServiceDomain.DisplayFormat#">#val#</TD>	
			</tr>
			</cfif>
			
			<cfset hasDet = 0>							
			
				<cfif TransactionsApproved eq "0">
				
				<tr><td colspan="10" align="center" class="labelmedium">No approvals submitted for this device</td></tr>
						
				<cfelse>
				
					<cfoutput>
					
						<cfset hasDet = 1>
							
						<cfset row = row+1>
														    
						<TR class="navigation_row line labelmedium"> 
							
							<td></td>			
							<TD>#Dateformat(DateTimePlanning, CLIENT.DateFormatShow)#</TD>
							<TD>#Dateformat(DatePeriodStart, CLIENT.DateFormatShow)#</TD>		
							<TD>#Dateformat(DatePeriodEnd, CLIENT.DateFormatShow)#</TD>
							<TD align="right">#numberformat(TransactionsApproved,",")#</TD>		
							<TD align="right">#numberformat(TotalBusinessApproved,",.__")#</TD>		
							<TD align="right">#numberformat(TotalPersonalApproved,",.__")#</TD>		
									
							<td align="center" id="tdListing" class="line clsNoPrint" style="padding-left:8px">		
								
							   <cfif (row eq "1" and (url.scope neq "portal" and (access eq "EDIT" or access eq "ALL"))) or getAdministrator("*") eq "1">
								
									<cf_tl id="Do you want to cancel this action" var="vConfirm">
									
									<cfif url.scope neq "portal">
									
									<img height="13" width="13" src="#SESSION.root#/Images/delete5.gif" alt="Delete" 
										onclick="if (confirm('#vConfirm# ?')) {ColdFusion.navigate('#session.root#/Workorder/Application/WorkOrder/ServiceDetails/Action/ClosingListing.cfm?scope=backoffice&tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&workorderline=#url.workorderline#&workactionid=#workactionid#&action=delete','contentbox#url.tabno#')}" border="0">				
									
									<cfelse>
												
									<img height="15" width="15" src="#SESSION.root#/Images/delete5.gif" alt="Delete" 
										onclick="if (confirm('#vConfirm# ?')) {ColdFusion.navigate('#session.root#/Workorder/Application/WorkOrder/ServiceDetails/Action/ClosingListing.cfm?mission=#url.mission#&serviceitem=#url.serviceitem#&scope=portal&workactionid=#workactionid#&action=delete','submissionlog')}" border="0">				
								
									</cfif>	
															
								</cfif>
							 	
							</td>		
							
					    </TR>	
					
					</cfoutput>	
				
				</cfif>
								
			
			<cfif hasDet eq "0">	
			
			<tr><td colspan="10" class="line"></td></tr>
			
			</cfif>
		
		</cfoutput>
		
		</table>
	
	</td>
</tr>

</TABLE>

<cfset ajaxonload("doHighlight")>
