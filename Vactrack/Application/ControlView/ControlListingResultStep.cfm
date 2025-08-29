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
<cfoutput>

<script>
	
	function listing(mission,box,ent,code) {
			
		icM  = document.getElementById("d"+box+"Min")
	    icE  = document.getElementById("d"+box+"Exp")
		se   = document.getElementById("d"+box);
		frm  = document.getElementById("i"+box);
		 		 
		if (se.className=="hide") {
		 	 icM.className = "regular";
		     icE.className = "hide";
	    	 se.className  = "regular";
			
		 } else {
		   	 icM.className = "hide";
		     icE.className = "regular";
			 se.className  = "hide"	 
		 }		 		
	  }
  
</script>  

</cfoutput>


<table style="width:98%" align="center" class="navigation_table">

 <tr class="line labelmedium fixrow fixlengthlist" style="border-top:1px solid silver">
   <td style="min-width:40"></td>
   <td><cf_tl id="Class"></td>
   <td><cf_tl id="Created"></td>
   <td><cf_tl id="Posted"></td>
   <td><cf_tl id="Reference"></td>
   <td><cf_tl id="Expected"></td>   
   <td title="Grade / Candidate">G / P</td>
   <td><cf_tl id="Position">&nbsp;&nbsp;/&nbsp;&nbsp;<cf_tl id="Vacant since"></td>		       
   <td><cf_tl id="Title"></td>
   <td><cf_tl id="Office"></td>	   
   <td><cf_tl id="Officer"></td>	   
  </tr>		

<cfoutput query="Summary">
		   
	<cfif counted gt "0">
				
		<cfif description eq "">
			<cfset desc = "<font color='FF0000'>Tracks no longer open">
		<cfelse>
			<cfset desc = Description>	
		</cfif>
					
		<tr class="labelmedium">

			<cfset vOpenDetail = "$('.cls#URL.Mission##currentrow#').toggle(); $('.clsIcon#URL.Mission##currentrow#').toggleClass('fa-caret-circle-down').toggleClass('fa-caret-circle-up');">
		
			<cfif description neq "">
		  
			  	<cfif URL.mode neq "Print" AND EntityCode neq "">
				
				    <td width="4%" height="20" align="center">
						<i class="fas fa-caret-circle-down clsIcon#URL.Mission##currentrow#" 
							style="font-size:18px; color:##A5A5A5; cursor:pointer;" 
							onclick="#vOpenDetail#">
						</i>
					</td>
				</cfif>
				
			<cfelse>
			
				<td></td>	
			
			</cfif>
			
			<td colspan="8" style="height:32px;font-size:17px">										
					
				<cfif code neq "0">
				
					<a href="javascript:#vOpenDetail#">#Desc# (#counted#)</a>
				
				<cfelse>
				
					#Desc# <font size="2">(#counted#)</font>
								
					<cfquery name="get"
					datasource="AppsQuery"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">	
						SELECT * 
						FROM   (#preservesingleQuotes(SelectedTracks)#) as T
						WHERE  ActionCode is NULL
					</cfquery>		

					<cfloop query="get">
						<a href="javascript:showdocument('#DocumentNo#','')">#documentno#</a>
						<cfif currentrow neq recordcount>,</cfif>
					</cfloop>
					
				</cfif>	
									
			</td>
			
		 </tr>
		 		 
		 <cfif currentrow neq recordcount>
		 
		 	<tr><td colspan="13" class="line"></td></tr>
			
		 </cfif>			 
	
		<cfset row = currentrow>														
		<cfinclude template="ControlListingResultStepDetail.cfm">
	
	</cfif>
			   			
</cfoutput>
	
</table>	