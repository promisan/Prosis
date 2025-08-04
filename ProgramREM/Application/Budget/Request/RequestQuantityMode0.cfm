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
<cfparam name="url.mode"  default="Total">
<cfparam name="url.scope" default="Standard">
<cfparam name="url.lines" default="1">


<cfoutput>

	<cfif url.mode eq "Total">
		
		<cftry>
		
			<cfset tot = "">
			
			<cfset prc = replace(url.price,',','',"ALL")>
			
		    <cfloop index="itm" from="1" to="#url.lines#">
				
				    <cfset qty = evaluate("url.quantity_#itm#")>
								
					<cfif qty neq "">
					
						<cfset sub = prc*qty>
					
						<cfif tot eq "">
							<cfset tot = sub>	
						<cfelse>
						    <cfset tot = tot+(sub)>
						</cfif>	
						
						<cfif url.scope eq "standard">
						<div id="total_display_#itm#" style="padding-top:3px;font-size:14">#numberformat(tot,",.__")#</b></div>		
						</cfif>
										
						<script language="JavaScript">
					 
						  try {
						  document.getElementById("requestamountbase_#itm#").value = "#sub#"
						 } catch(e) {} 
					 
						</script>	
					
					</cfif>	
										
			</cfloop>
			
			<cfif url.scope eq "period">	
			
				<div id="total_display" style="font-size:15">#numberformat(tot,",.__")#</b></div>				
					
				<script>
				  try {
				  document.getElementById("requestamountbase_1").value = "#tot#"
				  } catch(e) {}
				</script>		
			
			</cfif>		
					
			<cfcatch><font color="FF0000" style="font-size:15">n/a</cfcatch>
			
		</cftry>	
	
	<cfelseif url.mode eq "Quantity">	
	  		
		<cftry>
		
			<cfset tot = "">
								
			<cfloop index="itm" from="1" to="#url.lines#">
				
			    <cfset qty = evaluate("url.quantity_#itm#")>
								
				<cfif qty neq "">
					
					<cfif tot eq "">
						<cfset tot = qty>	
					<cfelse>
					    <cfset tot = tot+qty>
					</cfif>	
						
				</cfif>	
					
			</cfloop>
					
			<div id="total_display_#itm#" style="padding-top:3px;font-size:14">#numberformat(tot,",__")#</div>
															
			<input type="hidden" name="requestquantity_sum" id="requestquantity_sum" value="#numberformat(tot,",__")#">	
									
			<cfcatch><font color="FF0000" style="font-size:14">n/a</cfcatch>
			
		</cftry>	
			
	</cfif>

</cfoutput>