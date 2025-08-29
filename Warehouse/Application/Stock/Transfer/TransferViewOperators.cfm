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
 <cfquery name="Actors" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Ref_TaskTypeActor
		   WHERE     Code = 'Internal'  
		   <!---  AND       EnableTransaction = 1 --->
		   ORDER BY  ListingOrder
   </cfquery>
	   				   
   <cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      TaskOrder
	   WHERE     StockOrderId = '#url.stockorderid#'					   
   </cfquery>
	
	<!--- this is a header to capture header information of the transaction --->
		
	<tr><td colspan"3">
	
	
	
	<table width="100%" class="formpadding">	
	
	<tr>			       
		<td colspan="3" style="padding-top:4px;padding-left:2px" class="labelit"><cf_tl id="Operators"></td>
	</tr>
	
	<tr>
        <td colspan="3" class="linedotted"></td>							
	</tr>
	
	<tr>
        <td></td>
		<td style="padding-left:10px;padding-top:5px">
		<table cellspacing="0" cellpadding="0">

			<tr>		
			<td width="130" class="labelit"><font size="1"><cf_tl id="First Name">:</td>
			<td width="160" class="labelit" style="padding-left:7px"><font size="1"><cf_tl id="Last Name">:</td>
			</tr>
		</table>
		
		</td>
		<td></td>
			
	</tr>
	   
	<cfoutput query="Actors">		
	
	 <cfquery name="prioractor" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
	    FROM     WarehouseBatchActor
	    WHERE    BatchNo = '#Prior.BatchNo#'	
		AND      Role = '#Role#'
	 </cfquery>			
					
	<tr>
	  <td height="24" width="230" class="labelit" style="padding-left:20px">#Description#:<cf_space spaces="60"></td>
	  
	  <td style="padding-left:10px">
	  
		    <cfif entrymode eq "Lookup">	 
								
				<cfset link = "#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/getEmployee.cfm?field=Actor_#role#">	
								
				<table cellspacing="0" cellpadding="0" class="formpadding">

					<tr>	
					
					<td>
					
					<cfif currentrow eq "1" and prioractor.ActorPersonNo eq "">												
					   <cfdiv bind="url:#link#&selected=#get.PersonNo#" id="person_#role#"/>
					<cfelse>
					   <cfdiv bind="url:#link#&selected=#priorActor.ActorPersonNo#" id="person_#role#"/>
					</cfif>
					
					</td>
										
					<td style="padding-left:4px">
					
					   <cf_selectlookup
						    box        = "person_#role#"
							link       = "#link#"
							button     = "Yes"
							icon       = "contract.gif"
							iconheight = "21"
							style      = "height:18;width:18"
							close      = "Yes"
							type       = "employee"
							des1       = "Selected">
						
					</td>
					</tr>
				
				</table>
			
			<cfelse>
	
			   <table cellspacing="0" cellpadding="0" class="formpadding">
			
				<cfif currentrow eq "1" and prioractor.ActorLastname eq "">	
			
					<cfquery name="get" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   SELECT    *
					   FROM      Person			  
					   WHERE     PersonNo = '#get.PersonNo#'				 		   
				    </cfquery>
				
				<cfelse>
				
				     <cfquery name="get" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   ActorLastName as LastName,
						         ActorFirstName as FirstName
					    FROM     WarehouseBatchActor
					    WHERE    BatchNo = '#Prior.BatchNo#'	
						AND      Role = '#Role#'
					 </cfquery>										
																			
				</cfif>
									
				<tr>
					<td width="130">
					<input type="text" name="lastname_#role#" id="lastname_#role#" value="#get.LastName#" style="width:130" maxlength="30" class="regularxl">
					</td>									
					<td  width="160" style="padding-left:8px">
					<input type="text" name="firstname_#role#" id="firstname_#role#" value="#get.FirstName#" style="width:160" maxlength="40" class="regularxl">
					</td>
				</tr>
			
			</table>
						
		</cfif>
	 		  
	  </td>	
	</tr>	
	
	</cfoutput>
		
	</table>
	</td></tr>