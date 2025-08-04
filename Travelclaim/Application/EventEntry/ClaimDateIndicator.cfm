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

<cfparam name="header" default="0"> 
<cfset cnt  = "0">
<cfset hide = "0">

<cfif eventIndicator.recordcount eq "0">
	<cfset w = "300">
<cfelse>
	<cfset w = "#300/(EventIndicator.recordcount)#">
</cfif>

<table border="0" <!--- width="300" ---> cellspacing="0" cellpadding="0" rules="rows">
	
	<cfoutput query="EventIndicator">
		
	<!--- verify if DSA exists for the city --->
					
		<cfif LineInterface eq "list">	
			
			<cfif LineList eq "DSA">			
			
			    <!--- 17/7 : moved the DSA option to the left as a custom code --->
						
			    <!--- special condition --->
				
				<!---
				
				<cfif #cont# eq "0">
				
				   <cfquery name="VerDSA" 
				   dbtype="query">
					SELECT    *
					FROM      DSABase
					WHERE     CalendarDate   = #dte# 
					 AND     (DateEffective <= #dte# OR  DateEffective IS NULL)
					</cfquery>
														
				</cfif>
				
				<cfif #VerDSA.recordcount# gt "1">
				
					<cfquery name="Verify" 
					 datasource="appsTravelClaim" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT *
					 FROM   ClaimLineDateIndicator
					  WHERE ClaimId        = '#claimid#' 
					  AND   PersonNo       = '#Per#'
					  AND   CalendarDate   = #dte#
					  AND   IndicatorCode  = '#IndicatorCode#' 
					</cfquery>
										
					<tr>
														
					<td bgcolor="ECF5F9" style="border-left: 1px solid silver;">&nbsp;#DescriptionQuestion#:</td>
			
					<td colspan="2">
					
					<cfif #Claim.ActionStatus# lt "3">
				
					<select name="#fld#_#IndicatorCode#" style="background: Ffffef;">
						<cfloop query="VerDSA">
						<option value="#LocationCode#" 
						<cfif #LocationCode# eq #Verify.IndicatorValue#>selected</cfif>>#Description# [#LocationCode#]</option>
						</cfloop>
					</select>
					
					<cfelse>
					
					#Verify.IndicatorValue#
					
					</cfif>
					
					</td>
					
				<cfelse>
				
				    <tr>
				
					<td bgcolor="fafafa" style="border-left: 1px solid silver;" align="center">&nbsp;#DescriptionQuestion#:</td>
			
					<td colspan="5" align="left" bgcolor="ffffef">
				
						#VerDSA.Description# [#VerDSA.LocationCode#]
					
					</td>
				    
					<input type="hidden" value="" name="#fld#_#IndicatorCode#">	
				
				</cfif>
												
				</td>
				
				</tr>
				
				--->
			
			</cfif>
										
		<cfelse>	
					
			<cfif cnt lte "4">
			  <cfset cnt = cnt + 1>
			 
			<cfelse>
			  <cfset cnt = 1>
			  <tr>  			
			</cfif>			
					
			<cfquery name="Verify" 
				 datasource="appsTravelClaim" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT *
				 FROM   ClaimLineDateIndicator
				 WHERE  ClaimId        = '#claimid#' 
				  AND   PersonNo       = '#Per#'
				  AND   CalendarDate   = #dte#
				  AND   IndicatorCode  = '#IndicatorCode#' 
			</cfquery>

			 <cfif Verify.recordcount gte "1">
				 <cfset cl = "highlight2">
			 <cfelse>
				 <cfset cl = "regular">
			 </cfif>
			
			<td class="#cl#" id="#fld##IndicatorCode#"> 
			
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				
				<cfif Claim.actionStatus lte "1" and editclaim eq "1">
				   	<cfset mde = "">
				<cfelse>
				    <cfset mde = "disabled">
				</cfif>		
											
				<cfif Trigger eq "1" and header eq "1">
								
					<cfif top eq "1">
					
					<cfquery name="Verify" 
						 datasource="appsTravelClaim" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT *
						 FROM   Ref_Indicator
						 WHERE  ParentCode   = '#ParentCode#' 	
						 AND    Operational = 1					
					</cfquery>

					<!--- meals presentation --->
										
					<cfif verify.recordcount eq "3">
										
						<cfquery name="Parent" 
							 datasource="appsTravelClaim" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							 SELECT *
							 FROM   Ref_Indicator
							 WHERE  Code   = '#ParentCode#' 										
						</cfquery>
						
						<tr>	
						
							<cfif verify.code eq code> 
							
							<td align="center"
							height="14" 
							bgcolor="#listingbackground#"
						    style="width:#w#px; border-left: 1px solid silver; border-top: 0px solid silver; border-bottom: 1px solid silver;">
									
							<cfelse>
							
							<td align="center"
							height="14" 
							bgcolor="#listingbackground#"
						    style="width:#w#px; border-left: 0px solid silver; border-top: 0px solid silver; border-bottom: 1px solid silver;">
									<cfif code eq "T042">
									&nbsp;<b>#Parent.Description#</b>
									</cfif>
							
							</cfif>
							
							</td>
						</tr>
					
					</cfif>
								
					<tr>	
					
						<cfif currentrow eq recordcount>
						
						<td align="center"
						height="20"						
						bgcolor="#listingbackground#"
					    style="width:#w#px; border-right: 1px solid silver; border-left: 1px solid silver; border-top: 0px solid silver; border-bottom: 0px solid silver;">
						
						<cfelse>
						
						<td align="center"
						height="20"						
						bgcolor="#listingbackground#"
					    style="width:#w#px; border-left: 1px solid silver; border-top: 0px solid silver; border-bottom: 0px solid silver;">
	
						</cfif>
						
														
						<cfif len(DescriptionQuestion) gt "12" and parentcode neq 'P01'>
						    Accommo-<br>dation							
						<cfelse>
							#DescriptionQuestion# 
						</cfif>
						<cfif ParentCode eq 'P01'>
						<cf_helpfile 
								code    = "TravelClaim" 
								class   = "Indicator"
								id      = "R05"
								display = "icon">
					</cfif>
						</td>
					</tr>
					
					<cfelse>
															
						<cfif mde neq "disabled" and editclaim eq "1">
												
							<cfquery name="IndSet"
	        				        dbtype="query">
	       							SELECT  *
									FROM    Preset
									WHERE   IndicatorCode = '#IndicatorCode#' 
								 </cfquery>	
					 											
							<tr>

								<cfif currentrow eq recordcount>
																												
									<td align="center" 							
									class="top4n"							
									style="width:#w#px;border-right: 1px solid silver; border-left: 1px solid silver;border-top: 0px solid silver; border-bottom: 0px solid silver;">
								
								<cfelse>
								
									<td align="center" 							
									class="top4n"							
									style="width:#w#px; border-left: 1px solid silver;border-top: 0px solid silver; border-bottom: 0px solid silver;">
															
								</cfif>
								
								<input type="checkbox"
								name    = "b#fld#_#IndicatorCode#"
								id      = "b#id#_#trigger#_#IndicatorCode#"
								value   = "1"
								onClick = "hl('#id#_0_#IndicatorCode#',this.checked,'#trigger#','#IndicatorCode#','#checkExclusive#','b#fld#_#IndicatorCode#')"
								
								<!---cfif Verify.indicatorValue eq "1" or IndSet.recordcount gte "1">checked</cfif--->>
								
								<!--- 	MKM: 23-Sep-2008
									Commented out the below "if". It would always check the "Select All" box
								    when the first day was checked. Commenting it out prevents the check box from 
									being "checked" when you re-enter the screen.
								--->
								
							</td>
							</tr>
							
						</cfif>	
					
					</cfif>						
											
				</cfif>
				
				<cfif header eq "0">
								
					<tr>
					
						<cfif currentrow eq recordcount>
						
						<td align="center" height="25" 
  						 style="width:#w#px; border-right: 1px solid silver; border-left: 1px solid silver; border-top: 0px solid silver; border-bottom: 0px solid silver; font-size: xx-small; font-family: Verdana; text-overflow: clip; text-align: center; text-transform: capitalize;">
	
						
						<cfelse>
						
						<td align="center" height="25" 
						 style="width:#w#px; border-left: 1px solid silver; border-top: 0px solid silver; border-bottom: 0px solid silver; font-size: xx-small; font-family: Verdana; text-overflow: clip; text-align: center; text-transform: capitalize;">
						 
						</cfif> 
						 																						   					 							 							   							
								   <cfif Claim.ActionStatus lte "1" and editclaim eq "1">
								 								   
									   <cfquery name="IndSet"
		        				        dbtype="query">
		       							SELECT  *
										FROM    Preset
										WHERE   IndicatorCode = '#IndicatorCode#' 
										AND     CountryCityId = '#VerDSA.countrycityId#' 
									   </cfquery>	
									   									   
									   <!--- check if global entry was made --->
									   <input type="checkbox"
					       			   name  = "#fld#_#IndicatorCode#"
								       id    = "#id#_0_#IndicatorCode#"
									   #mde#
									   <cfif Verify.indicatorValue eq "1" or IndSet.recordcount gte "1">
									   checked 
									   </cfif>
									   
									   <cfif hide eq "1">disabled</cfif>
								       value = "1"		
									   <cfif CheckExclusive eq "1">
									   onclick="exclusive('#fld#','#IndicatorCode#');savebox('#dateformat(dte,client.datesql)#','#per#','DSA','#IndicatorCode#',this.checked)"
									   <cfelse>
									   onclick="savebox('#dateformat(dte,client.datesql)#','#Per#','DSA','#IndicatorCode#',this.checked)"
									   </cfif>>
									   
									   <cfif CheckExclusive eq "1" and Verify.indicatorValue eq "1">
										   <cfset hide = "1">
									   </cfif>
									   
									   <cfelse>
									  									   
									   <cfif Verify.indicatorValue eq "1">
									   	<img align="absbottom" src="#SESSION.root#/Images/checkbox-on1.gif" alt="Not selected" border="0">
									   <cfelse>
										<img align="absbottom" src="#SESSION.root#/Images/checkbox-off1.gif" alt="Selected" border="0">
									   </cfif>
								  
								   </cfif>
							
							 </td>
					
					</tr>
					
				</cfif>
				</table>
			
			</td>	
		
		</cfif>	
	
	</cfoutput>	
	
	</tr>
			
</table>		