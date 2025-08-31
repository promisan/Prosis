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
<cfparam name="url.height" default = "450">
<cfparam name="url.width"  default = "#client.widthfull#">
<cfparam name="url.SupplyItemNo"     default = "">

	<cfif NOT ISDEFINED("myar")>				
	
		<cfset vjson  = Evaluate("CLIENT.graph_" & URL.supplyitemNo)>
		
		<cfset varr =  DeserializeJSON(vjson)>
		
		<cfset i = 1>
		<cfset j = 1>
		<cfset myar = ArrayNew(2)>
				
			<cfloop array=#varr# index="element">
				<cftry>
					<cfif Mid(element[1],4,2) eq URL.Month or URL.Month eq 0 >
							<cfset myar[j][1] = element[1] >	
							<cfset myar[j][2] = element[2] >	
							<cfset myar[j][3] = element[3] >				
							<cfset j =  j + 1>
						
					</cfif>
					<cfset i = i + 1>				
				<cfcatch>

				</cfcatch>	
				</cftry>	

			</cfloop>
			
		
	</cfif>	
	
	
	<cfif url.mode eq "chart">	
	 <cfset ht = "#url.height-330#">	 
	<cfelse>
	 <cfset ht = "190"> 
	</cfif>		
	
	<cfif url.width lt 460>
	   <cfset url.width = 800>
	</cfif>
	
	<cfif ht lt 0>
	   <cfset ht = 400>
	</cfif>

<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr><td>
			
	<!--- scaleto        = "#(url.scale+0.1)*1.1#"   --->

	<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format   = "png"
       chartheight    = "#ht#"
       chartwidth     = "#url.width-460#"			   
	   scalefrom      = "0"			  		   
	   gridlines      = "Yes"
       showygridlines = "yes"
	   seriesplacement= "cluster"	      
	   showlegend     = "yes"
       fontsize       = "12"
	   show3d         = "No"
	   font           = "Calibri"	
	   tipstyle       = "mouseOver"
       tipbgcolor     = "E9E9D1"
	   showxgridlines = "yes"
       sortxaxis      = "no">
	   				   
	<cfchartseries
           type="curve"
           serieslabel="Target"
           datalabelstyle="none"
		   seriescolor="80FF80"
           paintstyle="light"
           markerstyle="circle">
	   
	   <cfloop index="x" from="1" to="#arrayLen(myar)#">
	   		<cftry>
		       <cfchartdata item="#myar[x][1]#" value="#myar[x][2]#">
		    <cfcatch>
			</cfcatch>	   
		    </cftry>
	   </cfloop>
	   		   
	</cfchartseries> 
		
	<cfchartseries
             type="curve"	             
			 seriescolor="blue"
             serieslabel="Actually Measured"
			 datalabelstyle="none"					
             paintstyle="light"
             markerstyle="circle">
			 
			 <cfloop index="x" from="1" to="#arrayLen(myar)#">
				 <cftry>
			       	<cfchartdata item="#myar[x][1]#" value="#myar[x][3]#">
			    <cfcatch>
				</cfcatch>	   
			    </cftry>							
		    </cfloop>
								 
	</cfchartseries>
		
	</cfchart>	
	
	</td></tr>	
	
	<cfif url.mode eq "issue">
	
		<tr><td class="linedotted"></td></tr>	
		<tr>
		<td height="350" style="padding:3px">		
			<cfinclude template="AssetSupplyConsumptionViewPresentationIssues.cfm">	
		</td>
		</tr>		
	</cfif>
	
</table>
				

				