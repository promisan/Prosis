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
<cfparam name="attributes.Presentation" default="">
<cfparam name="attributes.Color"        default="##eaeaea80">
<cfparam name="attributes.FontSize"     default="13">
<cfparam name="attributes.Height"       default="26">
<cfparam name="attributes.GroupField"   default="">
<cfparam name="attributes.GroupValue"   default="">
<cfparam name="attributes.Filter1Field" default="">
<cfparam name="attributes.Filter1Value" default="">
<cfparam name="attributes.Filter2Field" default="">
<cfparam name="attributes.Filter2Value" default="">
<cfparam name="attributes.Filter3Field" default="">
<cfparam name="attributes.Filter3Value" default="">
<cfparam name="attributes.Filter4Field" default="">
<cfparam name="attributes.Filter4Value" default="">

<cfset height = attributes.fontsize * 2>

<cfoutput>

	<cfsavecontent variable="FilterString">

			<cfif attributes.Filter1Field eq "AccountParent">
					AND  AccountParent = '#attributes.Filter1Value#'
			<cfelseif attributes.Filter1Field eq "AccountGroup">
					AND  AccountGroup = '#attributes.Filter1Value#'
			<cfelseif attributes.Filter1Field eq "OrgUnit">
					<cfif attributes.Filter1Value eq "0">
						AND     OrgUnitName is NULL													
					<cfelse>
						AND     OrgUnit    = '#attributes.Filter1Value#'
					</cfif> 
			<cfelseif attributes.Filter1Field eq "StatementCode">
					AND  StatementCode = '#attributes.Filter1Value#'						
			</cfif>
					
			<cfif attributes.Filter2Field eq "AccountParent">
					AND  AccountParent = '#attributes.Filter2Value#'
			<cfelseif attributes.Filter2Field eq "AccountGroup">
					AND  AccountGroup = '#attributes.Filter2Value#'		
			<cfelseif attributes.Filter2Field eq "OrgUnit">
					<cfif attributes.Filter2Value eq "0">
						AND     OrgUnitName is NULL													
					<cfelse>
						AND     OrgUnit    = '#attributes.Filter2Value#'
					</cfif> 
			<cfelseif attributes.Filter2Field eq "StatementCode">
					AND  StatementCode = '#attributes.Filter2Value#'						
			</cfif>		
			
			<cfif attributes.Filter3Field eq "AccountParent">
					AND  AccountParent = '#attributes.Filter3Value#'
			<cfelseif attributes.Filter3Field eq "AccountGroup">
					AND  AccountGroup = '#attributes.Filter3Value#'		
			<cfelseif attributes.Filter3Field eq "GLAccount">
					AND  GLAccount = '#attributes.Filter3Value#'				
			<cfelseif attributes.Filter3Field eq "OrgUnit">
					<cfif attributes.Filter3Value eq "0">
						AND     OrgUnitName is NULL													
					<cfelse>
						AND     OrgUnit    = '#attributes.Filter3Value#'
					</cfif> 
			<cfelseif attributes.Filter3Field eq "StatementCode">
					AND  StatementCode = '#attributes.Filter3Value#'						
			</cfif>		
			
			<cfif attributes.Filter4Field eq "AccountParent">
					AND  AccountParent = '#attributes.Filter4Value#'
			<cfelseif attributes.Filter4Field eq "AccountGroup">
					AND  AccountGroup = '#attributes.Filter4Value#'		
			<cfelseif attributes.Filter4Field eq "GLAccount">
					AND  GLAccount = '#attributes.Filter4Value#'				
			<cfelseif attributes.Filter4Field eq "OrgUnit">
					<cfif attributes.Filter4Value eq "0">
						AND     OrgUnitName is NULL													
					<cfelse>
						AND     OrgUnit    = '#attributes.Filter4Value#'
					</cfif> 
			<cfelseif attributes.Filter4Field eq "StatementCode">
					AND  StatementCode = '#attributes.Filter4Value#'						
			</cfif>		

	</cfsavecontent>
	
</cfoutput>

<cfswitch expression="#attributes.GroupField#">

	<cfcase value="AccountGroup">
	
			<cfoutput>		
											
			<!--- Provision to toggle the detail --->
			<cfset vAccountGroupId = trim(replace(attributes.GroupValue, " ", "", "ALL"))>
			
			<cfset vDetailClassFn = ".clsGroupDetail_#attributes.baseid#_#vAccountGroupId#">
													
			<TR class="fixlengthlist labelmedium2 line navigation_row clsParentDetail_#attributes.baseid#" 
			     onclick="toggleSection('#vDetailClassFn#');" style="#attributes.visible#;height:#attributes.height#px">		
			
			 <td colspan="2" style="background-color:#attributes.color#;padding-left:20px;font-size:#attributes.fontsize#">#attributes.GroupValue# #attributes.GroupName#
			 			 
			 </td>
			
			 <cfif attributes.showperiod eq "1">
			 
			   <cfloop index="per" list="#attributes.periodlist#" delimiters=",">		   
			   
			   	  <!--- source data--->
				  <cfquery name="Data"
				   datasource="AppsQuery" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
						SELECT  sum(#attributes.panel#) as Total
						FROM    #SESSION.acc#PL#attributes.FileNo#
						WHERE   AccountGroup  = '#attributes.GroupValue#'
						
						#preserveSingleQuotes(FilterString)#
																
						<cfif attributes.history eq "TransactionPeriod">
						AND     TransactionPeriod = '#per#'	
						<cfelse>
						AND     AccountPeriod     = '#per#'	
						</cfif>
						
						AND     Panel = '#attributes.panel#' 
				  </cfquery>
			   			
				<td align="right" style="border-right:1px solid silver;background-color:#attributes.color#;font-size:#attributes.fontsize#">
						<font color="808080">		
							
						<cfif data.total eq "">
							-
						<cfelse>
						
							<cfif data.total lt 0>
						    <font color="FF0000">#NumberFormat(evaluate("Data.Total"),',__')#</font>
							<cfelse>
							#NumberFormat(evaluate("Data.Total"),',__')#
							</cfif>
						
						</cfif>
						
						</font>
				</td>
				
			   </cfloop>
			  
			 </cfif>
			 
			 <!--- source data--->
			 <cfquery name="Data"
			  datasource="AppsQuery" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT  SUM(#attributes.panel#) as Total
				
				FROM    #SESSION.acc#PL#attributes.FileNo#
				WHERE   AccountGroup  = '#attributes.GroupValue#'	
				
				#preserveSingleQuotes(FilterString)#
									
				AND     Panel = '#attributes.panel#'		
				
			 </cfquery>
						  	
			 <td align="right" style="border-right:1px solid silver;padding-right:3px;background-color:#attributes.color#;font-size:#attributes.fontsize#">
			 	  
			  <cfif data.total lt 0>
			  <font color="FF0000">#NumberFormat(evaluate("Data.Total"),',__')#</font>
			  <cfelse>#NumberFormat(evaluate("Data.Total"),',__')#</cfif>
			  
			 </td>		
			 
			 </tr>		
			 
			 </cfoutput>
			 
	</cfcase>

	<cfcase value="Center">
	
		<cfoutput>		
											
			<!--- Provision to toggle the detail --->
			<cfset vAccountGroupId = trim(replace(attributes.GroupValue, " ", "", "ALL"))>
			
			<cfset vDetailClassFn = ".clsGroupDetail_#attributes.baseid#_#vAccountGroupId#">
															
			<TR class="fixlengthlist labelmedium2 line navigation_row clsParentDetail_#attributes.baseid#" 
			     onclick="toggleSection('#vDetailClassFn#');" style="background-color:#attributes.color#;#attributes.visible#;height:#attributes.height#px">		
			
			 <td style="font-size:#attributes.fontsize#">#attributes.GroupValue#</b></td>
			 <td style="font-size:#attributes.fontsize#" ><cfif attributes.groupname eq ""><cf_tl id="No costcenter set"><cfelse>#attributes.GroupName#</cfif></td>
					
			 <cfif attributes.showperiod eq "1">
			
			   <cfloop index="per" list="#attributes.periodlist#" delimiters=",">
			   
			   	  <!--- source data--->
				  <cfquery name="Data"
				   datasource="AppsQuery" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
						SELECT  sum(#attributes.panel#) as Total
						FROM    #SESSION.acc#PL#attributes.FileNo#
						WHERE   OrgUnit  = '#attributes.GroupValue#'
						
						#preserveSingleQuotes(FilterString)#
																
						<cfif attributes.history eq "TransactionPeriod">
						AND     TransactionPeriod = '#per#'	
						<cfelse>
						AND     AccountPeriod     = '#per#'	
						</cfif>
						
						AND     Panel = '#attributes.panel#'
				  </cfquery>
			   			
				<td align="right" style="font-size:#attributes.fontsize#;#attributes.contentstyle#;background-color:#attributes.color#">
				
						<font color="808080">		
							
						<cfif data.total eq "">
							-
						<cfelse>
						
							<cfif data.total lt 0>
						    <font color="FF0000">#NumberFormat(evaluate("Data.Total"),',__')#</font>
							<cfelse>
							#NumberFormat(evaluate("Data.Total"),',__')#
							</cfif>
						
						</cfif>
						
						</font>
				</td>
				
			   </cfloop>
			  
			 </cfif>
			 
			 <!--- source data--->
			 <cfquery name="Data"
			  datasource="AppsQuery" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT  SUM(#attributes.panel#) as Total
				
				FROM    #SESSION.acc#PL#attributes.FileNo#
				WHERE   StatementCode  = '#attributes.GroupValue#'	
				
				#preserveSingleQuotes(FilterString)#
									
				AND     Panel = '#attributes.panel#'		
				
			 </cfquery>
						  	
			 <td align="right" style="font-size:#attributes.fontsize#;#attributes.contentstyle#;border-radius:5px;background-color:#attributes.color#">
			 	  
			  <cfif data.total lt 0>
			  <font color="FF0000">#NumberFormat(evaluate("Data.Total"),',__')#</font>
			  <cfelse>#NumberFormat(evaluate("Data.Total"),',__')#</cfif>
			  
			 </td>		
			 
			 </tr>		
			 
			 </cfoutput>
	
	</cfcase>

	<cfcase value="StatementCode">
	
			<cfoutput>
													
			<!--- Provision to toggle the detail --->
			<cfset vAccountGroupId = trim(replace(attributes.GroupValue, " ", "", "ALL"))>
			
			<cfset vDetailClassFn = ".clsGroupDetail_#attributes.baseid#_#vAccountGroupId#">
													
			<TR class="fixlengthlist labelmedium2 line navigation_row clsParentDetail_#attributes.baseid#" 
			     onclick="toggleSection('#vDetailClassFn#');" style="background-color:#attributes.color#;#attributes.visible#;height:#attributes.height#px">		
			
			 <td style="font-size:#attributes.fontsize#">#attributes.GroupValue#</b></td>
			 <td style="font-size:#attributes.fontsize#">#attributes.GroupName#</td>
			
			 <cfif attributes.showperiod eq "1">
			
			   <cfloop index="per" list="#attributes.periodlist#" delimiters=",">
			   
			   	  <!--- source data--->
				  <cfquery name="Data"
				   datasource="AppsQuery" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
						SELECT  sum(#attributes.panel#) as Total
						FROM    #SESSION.acc#PL#attributes.FileNo#
						WHERE   StatementCode  = '#attributes.GroupValue#'
						
						#preserveSingleQuotes(FilterString)#
																
						<cfif attributes.history eq "TransactionPeriod">
						AND     TransactionPeriod = '#per#'	
						<cfelse>
						AND     AccountPeriod     = '#per#'	
						</cfif>
						
						AND     Panel = '#attributes.panel#'
				  </cfquery>
			   			
				<td align="right" style="font-size:#attributes.fontsize#;#attributes.contentstyle#;background-color:#attributes.color#">
						<font color="808080">		
							
						<cfif data.total eq "">
							-
						<cfelse>
						
							<cfif data.total lt 0>
						    <font color="FF0000">#NumberFormat(evaluate("Data.Total"),',__')#</font>
							<cfelse>
							#NumberFormat(evaluate("Data.Total"),',__')#
							</cfif>
						
						</cfif>
						
						</font>
				</td>
				
			   </cfloop>
			  
			 </cfif>
			 
			 <!--- source data--->
			 <cfquery name="Data"
			  datasource="AppsQuery" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT  SUM(#attributes.panel#) as Total
				
				FROM    #SESSION.acc#PL#attributes.FileNo#
				WHERE   StatementCode  = '#attributes.GroupValue#'	
				
				#preserveSingleQuotes(FilterString)#
									
				AND     Panel = '#attributes.panel#'		
				
			 </cfquery>
						  	
			 <td class="labellarge" align="right" style="font-size:#attributes.fontsize#;#attributes.contentstyle#;border-radius:5px;background-color:#attributes.color#">
			 	  
			  <cfif data.total lt 0>
			  <font color="FF0000">#NumberFormat(evaluate("Data.Total"),',__')#</font>
			  <cfelse>#NumberFormat(evaluate("Data.Total"),',__')#</cfif>
			  
			 </td>		
			 
			 </tr>		
			 
			 </cfoutput>
			 
	</cfcase>

	<cfcase value="GLAccount">
	
			<cfoutput>
			
			<cfif Attributes.Filter1Field eq "OrgUnit">
				<cfset org = Attributes.Filter1Value>
			<cfelseif Attributes.Filter2Field eq "OrgUnit">
			    <cfset org = Attributes.Filter2Value>
			<cfelseif Attributes.Filter3Field eq "OrgUnit">
			    <cfset org = Attributes.Filter3Value>
			<cfelseif Attributes.Filter4Field eq "OrgUnit">
			    <cfset org = Attributes.Filter4Value>	
			<cfelse>
				<cfset org = form.OrgUnit>	
			</cfif>	
											
			<!--- Provision to toggle the detail --->
			<cfset vAccountId = trim(replace(attributes.GroupValue, " ", "", "ALL"))>
			
			<cfset vDetailClassFn = ".clsGroupDetail_#attributes.baseid#_#vAccountId#">
													
			<TR class="fixlengthlist labelmedium2 line navigation_row clsParentDetail_#attributes.baseid#" 
			     onclick="toggleSection('#vDetailClassFn#');" style="background-color:#attributes.color#;#attributes.visible#;height:#attributes.height#px">		
				 
			 <td colspan="2" style="padding-left:20px;font-size:#attributes.fontsize#">#attributes.GroupValue# #attributes.GroupName#</td>
								
			 <cfif attributes.showperiod eq "1">
			
			   <cfloop index="per" list="#attributes.periodlist#" delimiters=",">
			   
			   	  <cfif attributes.history eq "TransactionPeriod">
					<cfset sc = "showledger('#URL.mission#','',document.getElementById('period').value,'#attributes.GroupValue#','#per#','#org#','tab')"> 								
				<cfelse>
					<cfset sc = "showledger('#URL.mission#','','#per#','#attributes.GroupValue#','','#org#','tab')">							    
				</cfif>			
			   
			   	  <!--- source data--->
				  <cfquery name="Data"
				   datasource="AppsQuery" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
						SELECT  sum(#attributes.panel#) as Total
						FROM    #SESSION.acc#PL#attributes.FileNo#
						WHERE   GLAccount  = '#attributes.GroupValue#'					
						#preserveSingleQuotes(FilterString)#															
						<cfif attributes.history eq "TransactionPeriod">
						AND     TransactionPeriod = '#per#'	
						<cfelse>
						AND     AccountPeriod     = '#per#'	
						</cfif>					
						AND     Panel = '#attributes.panel#' 
				  </cfquery>
				
				   			
				<td align="right" onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='transparent'" 
				      style="#attributes.contentstyle#;" oncontextmenu="#sc#">		
					  					
						<cfif data.total eq "">
							-
						<cfelse>				
						
							<cfif data.total lt 0>
						    <font color="FF0000">#NumberFormat(evaluate("Data.Total"),',__')#</font>
							<cfelse>
							#NumberFormat(evaluate("Data.Total"),',__')#
							</cfif>
							
						
						</cfif>
						
				</td>
				
			   </cfloop>
			  
			 </cfif>
			 
			 <!--- source data--->
			 <cfquery name="Data"
			  datasource="AppsQuery" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT  SUM(#attributes.panel#) as Total			
				FROM    #SESSION.acc#PL#attributes.FileNo#
				WHERE   GLAccount = '#attributes.GroupValue#'				
				#preserveSingleQuotes(FilterString)#								
				AND     Panel = '#attributes.panel#'		
				
			 </cfquery>
			 
			 <cfif attributes.history eq "TransactionPeriod">
				<cfset sc = "showledger('#URL.mission#','',document.getElementById('period').value,'#attributes.GroupValue#','','#org#','tab')">
			 <cfelse>
			    <cfset sc = "showledger('#URL.mission#','',document.getElementById('period').value,'#attributes.GroupValue#','','#org#','tab')"> 
			 </cfif>		
						  	
			 <td class="labellarge" onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='transparent'" 
			     align="right" oncontextmenu="#sc#" style="#attributes.contentstyle#;border-radius:5px">
			 	  
				  <cfif data.total lt 0>
				  <font color="FF0000">#NumberFormat(evaluate("Data.Total"),',__')#</font>
				  <cfelse>#NumberFormat(evaluate("Data.Total"),',__')#</cfif>
			  
			 </td>		
			 
			 </tr>		
			 
			 </cfoutput>
			 
	</cfcase>

</cfswitch>
