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
	
	<cfif url.search eq "">
	
		<script>
			 document.getElementById("select_#url.box#").className = "hide"
		</script> 
	
	<cfelse>
	
		<script>
			 document.getElementById("select_#url.box#").className = ""
		</script> 
		
	</cfif>
		
	<table width="500" style="border-top:1px solid silver" cellspacing="0" cellpadding="0" bgcolor="f1f1f1">
	
	<input type="hidden" name="selectedrow_#url.box#" id="selectedrow_#url.box#" value="0">
	
	<!--- ------------------ --->		
	<!--- --- custom code -- --->
	<!--- ------------------ --->
		
	<cfquery name="Get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     TOP 10 A.*, PostalCode as keyValue			
		FROM       PostalAddress A 			
		WHERE      Country = '#url.country#' 
		AND        Address != 'Postbus'
		AND        PostalCode LIKE '#url.search#%'
		<!--- to limit the postal codes AND        Mission = '#url.mission#' --->
		ORDER BY   PostalCode 
	</cfquery>	
	
	<cfif get.recordcount eq "0">
	
		<tr><td height="50" class="labelmedium"
		   align        = "center" 
		   id           = "line_#url.box#_1" 
		   name         = "line_#url.box#_1" 
		   onmouseover  = "if (this.className=='regular') { this.className='highlight2' }"
		   onmouseout   = "if (this.className=='highlight2') { this.className='regular' }"
		   style        = "cursor:pointer"
		   onclick="ColdFusion.navigate('#SESSION.root#/tools/input/PostalCode/setPostal.cfm?box=#url.box#&country=#url.country#&mission=#url.mission#&keyvalue=','selectcontent_#url.box#')">
		   
		   <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
				<tr>	
				<td align="center" class="labelmedium"><cf_tl id="No records found."></td>
				</tr>
			
			</table>	
		
		<input type="hidden" name="linevalue_#url.box#_1" id="linevalue_#url.box#_1"  value="9999ZZ">
			
		</td></tr>
		
	</cfif>
	
	<!--- ------------------ --->
	<!--- --end custom code- --->
	<!--- ------------------ --->
	
	<cfloop query="get">
	
		<cfif currentrow eq "1">
	
		 <!--- first value ---> 
	    <script>
		//	document.getElementById('field_#url.box#').value='#keyValue#'
		</script>
		
		</cfif>
		
		<tr><td id       = "line_#url.box#_#currentrow#" 
		    name         = "line_#url.box#_#currentrow#" 
			onclick      = "document.getElementById('select_#url.box#').className='hide';ColdFusion.navigate('#SESSION.root#/tools/input/PostalCode/setPostal.cfm?box=#url.box#&country=#url.country#&mission=#url.mission#&keyvalue=#postalcode#','selectcontent_#url.box#')" 
		    class        = "regular" 
			style        = "cursor:pointer"
		    onmouseover  =  "if (this.className=='regular') { this.className='highlight2' }"
			onmouseout   =  "if (this.className=='highlight2') { this.className='regular' }">
							
			<input type="hidden" name="linevalue_#url.box#_#currentrow#" id="linevalue_#url.box#_#currentrow#"  value="#keyValue#">
			
			<!--- ------------------------------------------------- --->		
			<!--- --- custom code for content of the select box --- --->
			<!--- ------------------------------------------------- --->
						
			<table width="100%" cellspacing="0" cellpadding="0">
			
				<tr>						  
				    <td height="20" style="height:20px;padding-left:10px" width="80" class="labelmedium">#PostalCode#</td>				
				    <td width="70%" style="height:20px;padding-right:10px" class="labelmedium">#City#</td>						
				</tr>		
				
				<tr class="line">
				    <td colspan="2" style="height:20px;padding-left:10px" class="labelmedium">					
						<b>#Address# #Address2#</b>						
				     </td>		
				</tr>								
			
			</table>
			
			<!--- --------------------------------------------- --->
			<!--- ----------------end custom code-------------- --->
			<!--- --------------------------------------------- --->
		
		</td></tr>
				
	</cfloop>
	
	</table>

</cfoutput>
