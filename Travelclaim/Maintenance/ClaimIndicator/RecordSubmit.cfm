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

<cfif #URL.action# neq "delete">

		<!--- validation of inputted values --->
		
		<cfset msg = "">
			
		<cfset dateValue = "">
				
		<cfif #URL.code# eq  "">
		
			<cfset msg = "Please enter a code">
		
		</cfif>	
						
		<cfif #URL.desc# eq "">
		
			<cfset msg = "You must enter a description">
					
		</cfif>	
		
		<cfif not isNumeric(URL.perc)>
		
			<cfset msg = "You must enter a valid percentage">
					
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
				FROM  Ref_Indicator
				WHERE Code   = '#URL.Code#' 
				</cfquery>
			
			   <cfif #Verify.recordCount# is 1>
			   
				<table width="100%" align="center">
				<tr bgcolor="red">
				<td align="center" style="border: 1px solid Gray;">
				<font color="FFFFFF">A record with this information has been registered already!</td>
				</tr>
				<cfabort>
							   				 			  
			   <cfelse>
			   
			   <!---
			   
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
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName,	
							 Created)
					  VALUES ('#URL.FundType#',
					          '#URL.Period#', 
							  #STR#,
							  '#URL.Status#',
							  '#URL.remarks#',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#',
							  getDate())
					  </cfquery>
					  
					  <input type="hidden" name="action" value="1">
					  
					  --->
															  
			    </cfif>		  
			           
			<cfelse>
			
				<cfquery name="Verify" 
				datasource="AppsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM  Ref_Indicator
				WHERE Code   = '#URL.Code#' 
				</cfquery>
			
			   <cfif #Verify.recordCount# is 1>
			   					
					<cfquery name="Update" 
					datasource="AppsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE Ref_Indicator
					SET Description         = '#URL.desc#',
						DescriptionQuestion = '#URL.ques#',
						CheckExclusive      = '#URL.excl#',
						LinePercentage      = '#URL.Perc#',
						ListingColor        = '#URL.tclr#',
						ListingBackground   = '#URL.bclr#',
						ListingOrder        = '#URL.order#'
					WHERE Code              = '#URL.code#'
					</cfquery>
					
					<input type="hidden" name="action" value="1">
															
				</cfif>	
			
			</cfif>	
		
		</cfif>
		
<cfelse>

	<!--- delete --->
						
</cfif>		
 

