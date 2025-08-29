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
<cfif #URL.action# neq "delete">

		<!--- validation of inputted values --->
		
		<cfset msg = "">
			
		<cfset dateValue = "">
		
		<CF_DateConvert Value="#URL.Date#">
		<cfset STR = #dateValue#>
					
		<cfif not isDate(#STR#)>
			
			<cfset msg = "Incorrect date">
			
		</cfif>
		
		<cfif #URL.FundType# eq  "">
		
			<cfset msg = "#msg# - Please enter a fund type">
		
		</cfif>	
						
		<cfif #URL.Period# lt "2000" or #URL.Period# gt "2050">
		
			<cfset msg = "#msg# - Incorrect period (2000-2050)">
					
		</cfif>	
							
		<cfif #msg# neq "">
		
			<cfoutput><table width="100%" align="center">
			<tr bgcolor="red">
			<td align="center" style="border: 1px solid Gray;">
			<font color="FFFFFF">#msg#</td>
			</tr>
			</cfoutput>
		
		<cfelse>
			
			<cfif URL.action eq "insert"> 
			
				<cfquery name="Verify" 
				datasource="AppsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM  stFundStatus
				WHERE FundType    = '#URL.FundType#' 
				AND Period        = '#URL.Period#' 
				AND DateEffective = #STR# 
				</cfquery>
			
			   <cfif #Verify.recordCount# is 1>
			   
				<table width="100%" align="center">
				<tr bgcolor="red">
				<td align="center" style="border: 1px solid Gray;">
				<font color="FFFFFF">A record with this information has been registered already!</td>
				</tr>
				<cfabort>
							   				 			  
			   <cfelse>
			   
					<cfquery name="Insert" 
					datasource="AppsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO stFundStatus
					         (FundType,
							 Period,
							 DateEffective,
							 Status,
							 Remarks,
							 DefaultAccount,							
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName,	
							 Created)
					  VALUES ('#URL.FundType#',
					          '#URL.Period#', 
							  #STR#,
							  '#URL.Status#',
							  '#URL.remarks#',
							   <cfif URL.pap neq "" and URL.Pap neq "Current">
							  '#URL.pap#',
							  <cfelse>
							  NULL,
							  </cfif>
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#',
							  getDate())
					  </cfquery>
					  
					  <input type="hidden" name="action" value="1">
															  
			    </cfif>		  
			           
			<cfelse>
			
				<cfquery name="Verify" 
				datasource="AppsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM  stFundStatus
				WHERE FundType = '#URL.FundType#' 
				AND   Period   = '#URL.Period#' 
				AND DateEffective = #STR#
				AND ValidationId != '#URL.Id#'
				</cfquery>
			
			   <cfif #Verify.recordCount# is 1>
			   
				   <table width="100%" align="center">
					<tr bgcolor="red">
					<td align="center" style="border: 1px solid Gray;">
					<font color="FFFFFF">A record with this information has been registered already!</td>
					</tr>
				   </table>	
				   <cfabort>
			  
			   <cfelse>
					
					<cfquery name="Update" 
					datasource="AppsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE stFundStatus
					SET FundType       = '#URL.FundType#',
					    Period         = '#URL.Period#',
						DateEffective  = #STR#,
						Status         = '#URL.Status#',
						<cfif URL.pap neq "" and URL.Pap neq "Current">
						DefaultAccount = '#URL.Pap#',
						<cfelse>
						DefaultAccount = NULL,
						</cfif>
						Remarks        = '#URL.Remarks#'
					WHERE ValidationId    = '#URL.id#'
					</cfquery>
					
					<input type="hidden" name="action" value="1">
															
				</cfif>	
			
			</cfif>	
		
		</cfif>
		
<cfelse>

	<!--- delete --->
			
	<cfquery name="Delete" 
    datasource="AppsTravelClaim" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
  	DELETE FROM stFundStatus
	WHERE  ValidationId = '#URL.id#'
    </cfquery>
	
	<input type="hidden" name="action" value="1">
			
</cfif>		
 

