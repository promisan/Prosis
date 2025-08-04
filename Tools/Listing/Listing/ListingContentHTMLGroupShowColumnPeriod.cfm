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

<!--- this is column presentation for date field in particular --->

<cfoutput>

<cfif url.datacell1 eq "total">		
	<cfset cwd = "50">	<!--- normal count --->		
<cfelse>		
	<cfset cwd = "70">			
</cfif>

<table style="width:100%;height:100%">	

<cfswitch expression="#attributes.mode#">

	<cfcase value="header">
		
			<cfset span = 0>
			
			<!--- year row --->	
			
				<tr class="labelmedium" style="height:15px">	    
					
				<cfloop index="yr" from="#yrs#" to="#yre#">
									
					<cfif period eq "week">
			
						<cfif yr eq yrs>
							<cfset st = mts>
							<cfset ed = 53>		
						<cfelseif yr gt yrs and yr lt yre>
							<cfset st = 1>
							<cfset ed = 53>			    
						<cfelse>
							<cfset st = 1>
							<cfset ed = mte>				
						</cfif>
						
						<cfset yearcol[yr][1] = st>
						<cfset yearcol[yr][2] = ed>
						<cfset yearcol[yr][3] = ed-st+1>	
						
					<cfelseif period eq "month">
			
						<cfif yr eq yrs>
							<cfset st = mts>
							<cfset ed = 12>		
						<cfelseif yr gt yrs and yr lt yre>
							<cfset st = 1>
							<cfset ed = 12>			    
						<cfelse>
							<cfset st = 1>
							<cfset ed = mte>				
						</cfif>
						
						<cfset yearcol[yr][1] = st>
						<cfset yearcol[yr][2] = ed>
						<cfset yearcol[yr][3] = ed-st+1>								
													
					<cfelseif period eq "quarter">
					
						<cfif yr eq yrs>
							<cfset st = mts>
							<cfset ed = 4>		
						<cfelseif yr gt yrs and yr lt yre>
							<cfset st = 1>
							<cfset ed = 4>			    
						<cfelse>
							<cfset st = 1>
							<cfset ed = mte>				
						</cfif>
						
						<cfset yearcol[yr][1] = st>
						<cfset yearcol[yr][2] = ed>
						<cfset yearcol[yr][3] = ed-st+1>																
						
					<cfelse>
					
						<cfset st = 1>	
						<cfset ed = 1>
						
						<cfset period = "year">
						
						<cfset yearcol[yr][1] = st>
						<cfset yearcol[yr][2] = ed>
						<cfset yearcol[yr][3] = ed-st+1>	
																				
					</cfif>
					
					<td align="center" style="background-color:yellow;color:black;padding-right:1px;border-left:1px solid silver;border-right:1px solid green" colspan="#yearcol[yr][3]#"><cfif period neq "year">#yr#</cfif></td>												
					<cfset span = span + yearcol[yr][3]*(cnt-1)>
					
				</cfloop>
				
					<td align="center" style="min-width:#cwd+10#px;border-left:1px solid silver;" colspan="1"><cf_tl id="Total"></td>
					<cfset span = span + (cnt-1)>						
					
				</tr>					
			
			    <!--- week,month/qtr row --->
							
			    <cfset perc = round(100/(span+1))>		
												
				<tr class="labelmedium" style="border-top:1px solid silver">
								
					<cfloop index="yr" from="#yrs#" to="#yre#">
					
						<cfset st = yearcol[yr][1]>
						<cfset ed = yearcol[yr][2]>
							
						<cfloop index="per" from="#st#" to="#ed#">	
						
							<cfif period eq "week">							
								<cfset label = per>
							<cfelseif period eq "month">							
								<cfset label = left(monthasstring(per),3)>														 
							<cfelseif period eq "quarter">	 							 
							 	<cfset label = "Q#per#">
							<cfelse>
								<cfset label = "#yr#">								
							</cfif> 
							  				 							
							<cfif cnt eq "2">						     
							     <td style="text-align:center;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:1px;<cfif per eq ed>border-right:1px solid green</cfif>">#label#</td>							 
								 <cfset cell = cell+1>
							<cfelse>	
							 	 <td style="width:#perc*(cnt-1)#%">
								 <table style="width:100%">
								 <tr class="line"><td colspan="#cnt-1#" style="text-align:center;border-left:1px solid silver;<cfif per eq ed>border-right:1px solid green</cfif>">#label#</td></tr>
								 <tr>
							     <cfloop index="itm" list="#URL.datacell1formula#">						 
								 <td style="text-align:center;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:1px">#itm#</td>
								 <cfset cell = cell+1>
								 </cfloop>	
								 </tr>
								 </table>
								 </td>							 										 							 
							</cfif>						 
							 
						</cfloop>
					
					</cfloop>
					
					<cfif cnt eq "2">						     
					     <td style="background-color:e6e6e6;text-align:center;min-width:#cwd+10#px;width:#perc#%;border-left:1px solid silver;padding-right:1px"></td>							 
						 <cfset cell = cell+1>
					<cfelse>	
						 	 <td style="width:#perc*(cnt-1)#%">
								 <table style="width:100%">
								 <tr class="line">
								 <td colspan="#cnt-1#" style="background-color:e6e6e6;text-align:center;border-left:1px solid silver">&nbsp;</td>
								 </tr>
								 <tr>
							     <cfloop index="itm" list="#URL.datacell1formula#">						 
								 <td style="background-color:e6e6e6;text-align:center;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:1px">#itm#</td>
								 <cfset cell = cell+1>
								 </cfloop>	
								 </tr>
								 </table>
							 </td>							 										 							 
					</cfif>			
																
				</tr>	
				
		</cfcase>
		
		<cfcase value="line">
		
		    <!--- line --->	
					
			<cfset perc = round(100/(span+1))>
									
			<tr class="labelmedium2" style="<cfif gridcontent eq 'total'>background-color:e6e6e6</cfif>">
									
				<cfset tot = 0>
			
				<cfloop index="yr" from="#yrs#" to="#yre#">
				
					<cfset st = yearcol[yr][1]>
					<cfset ed = yearcol[yr][2]>
						
					<cfloop index="per" from="#st#" to="#ed#">	
					
						 <cfif period eq "week">	
						
							<cfif per gte "10">
							    <cfset persel = per>
							<cfelse>
							 	<cfset persel = "0#per#">
							</cfif>	
															
							<cfscript>
								subSet=myval.filter(function(item){ return item[1]=="#yr#-#persel#"; });
							</cfscript>
							
							<cfset drillfield = "#url.listcolumn1#_WKE">
							<cfset filter     = "#yr#-#persel#">
					
					    <cfelseif period eq "month">	
						
							<cfif per gte "10">
							    <cfset persel = per>
							<cfelse>
							 	<cfset persel = "0#per#">
							</cfif>	
														
							<cfscript>
								subSet=myval.filter(function(item){ return item[1]=="#yr#-#persel#"; });
							</cfscript>
							
							<cfset drillfield = "#url.listcolumn1#_MTH">
							<cfset filter     = "#yr#-#persel#">
						 										
						<cfelseif period eq "quarter">	 							 
						
						 	<cfset persel = "Q#per#">	
							
							<cfscript>
								subSet=myval.filter(function(item){ return item[1]=="#yr#-#persel#"; });
							</cfscript>
							
							<cfset drillfield = "#url.listcolumn1#_QTR">
							<cfset filter     = "#yr#-#persel#">
													
						<cfelse>	
						
							<cfscript>
								subSet=myval.filter(function(item){ return item[1]=="#yr#"; });
							</cfscript>		
							
							<cfset drillfield = "#url.listcolumn1#_YR">		
							<cfset filter     = "#yr#">		 									
							
						</cfif>  
												
						<cfif ArrayLen(subSet) neq 0>	
									
						     <!--- IMPORTANT this takes the second field which we want to make dynamic 	
							 <cfif cnt gte "3">					
							    <cfset val = subSet[1][3]> 
							 <cfelse>
							    <cfset val = subSet[1][2]>
							 </cfif>
							 --->								 
							 								 
							 <cfloop index="itm" from="2" to="#cnt#">	
							 
								 <td style="text-align:right;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:6px;;<cfif per eq ed and itm eq cnt>;border-right:1px solid green</cfif>"
								 onclick="<cfif gridcontent eq 'row'>listgroupshow('#GroupKeyValue#','#rowdata#','#drillfield#','#filter#')</cfif>">								 
								 <cfset val = subSet[1][itm]>#val#			
								 </td>
							 								 
							 </cfloop>
							 
						<cfelse>
						
							 <cfloop index="itm" from="2" to="#cnt#">	
						     <td style="background-color:##eaeaea80;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:6px;<cfif per eq ed and itm eq cnt>;border-right:1px solid green</cfif>"></td>
							 </cfloop>															 
							 
						</cfif>	 
						 
					</cfloop>
				
				</cfloop>
				
				<!--- total column --->
				
				<cfif cnt eq "2">						     
				     <td style="text-align:right;background-color:##d6d6d680;min-width:#cwd+10#px;width:#perc#%;border-left:1px solid silver;padding-right:6px">
					 <cfparam name="myTot[#cnt#]" default="">
					 <cfset val = myTot[cnt]>#val#
						 </td>				 						
				<cfelse>	
				 	  <cfloop index="itm" from="2" to="#cnt#">	
					  <cfparam name="myTot[#cnt#]" default="">
				     <td style="text-align:right;background-color:##d6d6d680;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:6px">#myTot[itm]#</td>
					 </cfloop>						 										 							 
				</cfif>					
							
			</tr>					
			
	</cfcase>				
	
</cfswitch>
	
</table>

</cfoutput>
			
