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

<cfoutput>

	<cfset tmp = "">
							 
        <cfloop index="itm" list="#Selected#" delimiters=",">
      	     <cfif tmp eq "">
    	    <cfset tmp = "'#itm#'">
	     <cfelse>
	        <cfset tmp = "#tmp#,'#itm#'">
	     </cfif>
  	     </cfloop>
 
	 <cfif tmp eq "">
	   <cfset tmp = "''">
	 </cfif>
	
	<cfquery name="list" 
     datasource="#alias#" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT DISTINCT #pk# as PK, #desc# as Display
		 FROM    #Table#
		 WHERE   #pk# IN (#preserveSingleQuotes(tmp)#)
	</cfquery> 
		
	<cfset sel = "">
		
	<cfif mode eq "edit">
		 <div style="overflow: auto; height:167px; background-color:f4f4f4;scrollbar-face-color: F4f4f4;">
	</cfif>  
	
	<table width="<cfif Mode eq 'Edit'>98%<cfelse>100%</cfif>" align="center" cellspacing="0" cellpadding="0" class="navigation_table">
		
	    <cfif mode eq "edit">
		 <cfset col = "5">
		<cfelse>
		 <cfset col = "3">
		</cfif>  
															
		<cfif List.recordcount eq "0">		
			<tr><td align="center" style="padding-top:20px" height="100%" colspan="#col#" class="labelmedium"><font color="gray">No selections made</font></td></tr>		
		</cfif>
		
		<tr><td></td></tr>				
		<cfloop query = "list">
		
			<cfif sel eq "">
				<cfset sel = "#PK#">
			<cfelse>
			    <cfset sel = "#sel#,#pk#">
			</cfif>	
						
			<tr style="height:16px" class="labelmedium linedotted navigation_row">			
			<cfif mode eq "edit">					
				<td width="6%" align="center">#currentrow#.</td>			   
				<td style="padding-left:3px"><cf_img icon="delete"  navigation="Yes" onClick="javascript:remove('#URL.fld#','#URL.Alias#','#URL.Table#','#URL.PK#','#URL.DESC#','#URL.Order#','#PK#')"></td>	 		
			</cfif>	 					
			<td style="padding-left;4px">#PK#</td>		
			<td width="70%" style="padding-left:3px">#Display#</td>					
			</tr>				
		</cfloop>	
		
		<cfparam name="url.fld" default="">
				
		<script>
		  try {		 
		 document.getElementById('#url.fld#').value = '#Selected#' }
		 catch(e) {}
		</script>	
	
	</table>
	
	</div>
		
</cfoutput>	

<cfset ajaxonload("doHighlight")>

	