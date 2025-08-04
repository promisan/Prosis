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

<!--- total amount of the workorder which is billable, exclude class is not sale --->

<cftransaction isolation="READ_UNCOMMITTED">
	
	<cfquery name="relink" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ItemTransactionShipping
		SET    Journal         = '', 		    
			   JournalSerialNo = '0',
			   Invoiceid       = NULL
		FROM   ItemTransactionShipping AS S
		WHERE  Journal > '' 
		AND    ActionStatus != '9'
		AND    NOT EXISTS (
		               SELECT       'X' 
		               FROM         Accounting.dbo.TransactionHeader
		               WHERE        Journal         = S.Journal 
					   AND          JournalSerialNo = S.JournalSerialNo
				)
	</cfquery>

</cftransaction>

<cfquery name="getMandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT  *
      FROM     Ref_MissionPeriod
   	  WHERE    Mission = '#WorkOrder.Mission#'
	  AND      Period  = (
	  					  SELECT TOP 1 Period 
	                      FROM   Program.dbo.Ref_Period 
						  WHERE  DateEffective  <= '#dateformat(now(),client.dateSQL)#' 
						  AND    DateExpiration >= '#dateformat(now(),client.dateSQL)#'
						 )
						 										
	    
</cfquery>

<cfif getMandate.recordcount eq "0">

	<cfoutput>
		<table align="center">
		  <tr><td align="center" style="padding-top:16px" class="labelmedium">#WorkOrder.Mission#, an entity period has not been defined for today's date</td></tr>
	    </table>
	</cfoutput>
		
<cfelse>		

<table width="100%" border="0">

	<tr><td style="padding-left:16px;padding-right:16px;padding-top:4px" valign="top">	
	
		<cfoutput>

			<cf_layout id="innerDetail" type="accordion">
			
				<cf_tl id="Produced Workorders" var="1">
				<cf_layoutarea id="one" title="#lt_text#">

					<table width="100%" border="0" cellspacing="0" cellpadding="0">
								
					<tr><td colspan="2">
					
						<table width="97%" align="center">
							
							<tr class="labelmedium">
							    <td><cf_tl id="Customer">:</td>
							    <td><a href="javascript:viewOrgUnit('#workorder.orgunit#')">#workorder.customername#</a></td>
								<td><cf_tl id="Terms">:</td>
								<td align="right" style="padding-right:1px">
								
								  	<cfquery name="Terms" 
											datasource="AppsWorkOrder"
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
									   	    SELECT     *
											FROM       Ref_Terms							
									</cfquery> 	
								   			  
									<select name="terms" id="terms" class="regularxxl">
											<cfloop query="Terms">
												<option value="#Code#" <cfif WorkOrder.Terms eq Code>selected</cfif>>#Description#</option>
											</cfloop>
									</select>																	
											
								</td>	
							</tr>
										
							<tr>
							<td valign="top" style="height:32px;padding-top:4px" class="labelmedium"><cf_tl id="Bill to">:</td>	
							<td colspan="3">
							
								<table width="96%" cellspacing="0" cellpadding="0">
								<tr><td>
								
									<cfset url.orgunit = workorder.OrgUnit>
									<cfinclude template="../../../../System/Organization/Application/Address/UnitAddressView.cfm">
								
								
								</td></tr>
								</table>
							
							</td>
							</tr>					
																				
							<tr><td colspan="4" id="workorder" style="border:0px dotted silver">					
							    <cfinclude template="BillingEntryWorkOrder.cfm">							
							</td></tr>				
															
							</table>
												
					</td></tr>
						
				    <tr><td	 style="padding-left:14px;padding-right:14px;padding-top:5px"><td></tr>	
								
					</table>

				</cf_layoutarea>

				<cf_tl id="Shipping Lots" var="1">
				<cf_layoutarea id="two" title="#lt_text#" initcollapsed="false">

					<div id="mycontent">
						<cfinclude template="BillingEntryDetail.cfm">	
					</div>	

				</cf_layoutarea>

			</cf_layout>
	
	</cfoutput>
	
</td></tr>

</table>	

</cfif>

