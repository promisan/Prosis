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

<cfset tmp = "">

<!--- make a list of all the items that are already selected in the top portion --->
					 
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
 
<cfquery name="List" 
    datasource="#alias#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
     SELECT count(*) as Total
	 FROM   #Table#
	 WHERE  #pk# IN (#preserveSingleQuotes(tmp)#)  	 
</cfquery>  
	
<cfparam name="url.order" default="">

<cfif URL.FilterString neq "">
     <cfset fil = replaceNoCase(url.filterstring,"|","'","ALL")>
	 <cfset fil = replacenoCase(fil,"@@","#URL.FilterValue#")>
</cfif>	 
 
<cfquery name="SearchResult" 
    datasource="#alias#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT TOP 300 #pk# as PK, #desc# as Display <cfif URL.Order neq "">,#URL.Order#</cfif>
	 FROM   #Table#
	 WHERE  (#pk# LIKE '#url.val#%' OR #desc# LIKE '#url.val#%')
	 AND    #pk# NOT IN (#preserveSingleQuotes(tmp)#)  
	 <cfif URL.FilterString neq "">
	 	#preserveSingleQuotes(fil)#
	 </cfif>	 
	 <cfif URL.Order neq "">ORDER BY #URL.Order#</cfif>	 	
</cfquery>
    
<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">   

	<cfif SearchResult.recordcount eq "0">	
	
		<tr><td align="center" colspan="3" class="labelmedium"><font color="gray">No records found to be selected</b></font></td></tr>	
		
	<cfelse>
					
		<CFOUTPUT query="SearchResult">
		
		<cfif SearchResult.recordcount lt "100">		
			<TR class="labelmedium linedotted navigation_row" style="cursor: pointer;">		
		<cfelse>		
			<TR class="labelmedium linedotted navigation_row" tyle="cursor: pointer;">		
		</cfif>
		
		<td style="height:20px" width="6%" align="center">#currentrow#.</td>			
		<td style="height:20px;padding-top:1px" height="20" align="center">	
			<cf_img icon="select" navigation="Yes" onClick="javascript:add('#URL.fld#','#URL.Alias#','#URL.Table#','#URL.PK#','#URL.DESC#','#URL.Order#','#URL.filterstring#','#URL.filtervalue#','#PK#')">		
		</td>		
		<TD style="height:20px">#PK#</TD>			
		<TD style="height:20px" width="70%">#Display#</TD>			
		</TR>
		
		</CFOUTPUT>
	
	</cfif>
			
</table>

<cfset ajaxonload("doHighlight")>

		
