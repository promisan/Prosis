<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.warehouse" default="">
		
<table cellpadding="0" 
	   cellspacing="0" 
	   width="100%" 
	   height="100%" 
	   bgcolor="FFFFFF">

	<tr>
	
	<td valign="top" height="100%">
	
			<table cellpadding="0" 
			   cellspacing="0" 
			   align="center"
			   width="98%" 
			   height="100%">
			   	<tr>
					<td valign="top">
					
		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_DayTotal"> 
		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_COGS"> 			
		
		<cfquery name="get"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    Warehouse
			WHERE   Warehouse= '#url.warehouse#'			
		</cfquery>
		
		<!---	
		<cfoutput>#cfquery.executiontime#</cfoutput>	
		--->
		
			<table width="96%" height="100%" cellspacing="0" cellpadding="0" align="center">
			<tr>
					<td>
						 
						  <table cellspacing="0" cellpadding="0">
						    <tr>							
							<td style="padding-top:5px">							
                                <span id="printTitle"><h1 style="font-size:24px;"><cfoutput>#get.Mission# #get.warehouseName# #url.warehouse#</cfoutput></h1></span>
							</td>
							</tr>							
												
						   </table>						   	
						
					</td>
					<td align="right">
						
						<cf_tl id="Print" var="vPrint">
						<cf_tl id="Day Totals" var="vDayTotal">
						   
						<cf_button2
							type		= "Print"
							text		= "<span style='color:##000000;'>&nbsp;&nbsp;&nbsp;&nbsp;#vPrint#</span>" 							
							bgColor		= "ffffff"
							height		= "32px"
							width		= "150px"
							textSize	= "13px"
							printTitle	= "##printTitle"
							printContent= "##salecontent_#url.warehouse#">
						
						</td>
			</tr>
						
			<tr>
			<td valign="top" colspan="4" height="100%">					
			    <cf_divscroll id="printContent_#url.warehouse#" style="height:100%">					
					<cf_securediv style="width:98%" bind="url:../../SalesOrder/POS/Inquiry/DayTotalBase.cfm?systemfunctionid=#url.systemfunctionid#&warehouse=#url.warehouse#">				
				</cf_divscroll>
			</td>
			</tr>
			
			</table>
			
			</td></tr>
			
		</table>
	
	</td></tr>
	
</table>	
