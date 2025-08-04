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


<cfif Line.recordcount gt "0">  		 
		 
		  <tr class="labelmedium2">
		      
			<td height="20" align="center" valign="middle"></td>
							
			<cfif URL.tratpe eq "2" and URL.Mode neq "Disposal">
			
			     <cfset qty = -total.quantity>
			     <cfset cst = -total.cost>
				 <cfset sal = -total.sales>
				 
			<cfelse>
					
			     <cfset qty = total.quantity> 
			     <cfset cst = total.cost>
				 <cfset sal = total.sales>
				 
			</cfif> 	
			
			<cfif presentation eq "price">	
			
			<td colspan="11" align="right">(#Total.Lines#)</td>			 
			<td align="right" style="padding-right:4px">#NumberFormat(cst,',.__')#</td>
			<td></td>
			<td align="right" style="padding-right:4px">#NumberFormat(sal,',.__')#</td>
			
			<cfelseif presentation eq "log">	
			
			<td colspan="5"></td>		
				<td colspan="1" align="right">(#Total.Lines#)</td>				
				<td align="right">#NumberFormat(qty,',._')#</td>
			<td></td>
							
			<cfelse>
					 
			<td colspan="7" align="right">(#Total.Lines#)</td>		
			<td align="right" style="padding-right:2px">#NumberFormat(qty,',.__')#</td>		
					
			</cfif>
	
		  </tr> 	
		  
		  <cfquery name="get"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   Warehouse
				WHERE  Warehouse = '#url.warehouse#'
		  </cfquery>	
		 	 
		  <cfif url.systemfunctionid neq "undefined" and url.systemfunctionid neq "">
		  	   	  
		    <cfinvoke component = "Service.Access"  
		     method             = "WarehouseProcessor"  
			 role               = "'WhsPick'"
			 mission            = "#get.mission#"
			 warehouse          = "#url.warehouse#"		
			 SystemFunctionId   = "#url.SystemFunctionId#" 
			 returnvariable     = "access">	 	
			 						 
			 <cfif access neq "ALL">
			 
			 	<cfset submit_allowed  = FALSE>		
			 
			 </cfif>
			 
		  </cfif>	 
			 
		  <cfif submit_allowed or url.mode eq "workorder">	 
		  
		  <!--- submission is only allows if the user has access rights = all --->
		  
			 <tr><td colspan="#cols#" class="linedotted"></td></tr>  	   	  
		     <tr><td colspan="#cols#" align="center" height="28">
			 
			 	   	   
			    <cf_tl id="Submit Transactions for Clearance" var="1">
								
				<input type     = "button"
					value       = "#lt_text#" 				
					onclick		= "processStockIssue('#url.mode#','#url.warehouse#','#url.tratpe#','#url.location#','#url.itemno#','#url.uom#','','#url.systemfunctionid#');"
					id          = "Save"					
					style       = "height:24;width:260">
						
			  </td>
			
		      </tr>	 
		  
		  </cfif>
		  
		</cfif>