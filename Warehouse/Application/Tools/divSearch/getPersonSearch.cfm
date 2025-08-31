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
<script>
	 try {
	   document.getElementById('assetselectbox').className = "hide" 
	 } catch(e) {}
</script>

<cfif url.search eq "">

	<script>
		 document.getElementById("personselectbox").className = "hide"
	</script> 

<cfelse>

	<script>
		 document.getElementById("personselectbox").className = ""
	</script> 
	
</cfif>

<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     TOP 7 A.*			
	FROM       Person A 
			
	WHERE      (
	            Reference LIKE '%#url.search#%' OR 
	            IndexNo LIKE '%#url.search#%' OR 
				FullName LIKE '%#url.search#%'
			   )	

    <!--- condition to filter entries which has to be revisited --->		
		  
	AND (Source = '#url.mission#' 
	     OR PersonNo IN (
		                 SELECT PersonNo 
	                     FROM   PersonAssignment PA, Position P 
						 WHERE  PersonNo = A.PersonNo
						 AND    P.PositionNo = PA.PositionNo 
						 AND    P.Mission = '#url.mission#'
						)
		 )							
	
	ORDER BY   LastName, IndexNo 
</cfquery>

<table width="500" border="0" cellspacing="0" cellpadding="0" bgcolor="fafafa" style="border:1px solid silver" bgcolor="white">

<input type="hidden" name="personselectrow" id="personselectrow" value="0">

<cfif get.recordcount eq "0">

	<tr><td height="50" align="center" class="labelit"><cf_tl id="No records found."> [<cf_tl id="Press ENTER to add the person">]</td></tr>
	
	 <script>
		document.getElementById('personidselect').value=''
	</script>

</cfif>

<cfoutput query="get">

	<cfif currentrow eq "1">

    <script>
		document.getElementById('personidselect').value='#personno#'
	</script>
	
	</cfif>

	<tr><td id       = "personline#currentrow#" 
	    name         = "personline#currentrow#" 
	    onclick      = "document.getElementById('personselect').value='<cfif get.Reference neq "">#Reference#<cfelse>#IndexNo#</cfif>';document.getElementById('personidselect').value='#personno#';ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getPerson.cfm?mission=#url.mission#&personno='+document.getElementById('personidselect').value,'personbox')" 
	    class        = "<cfif currentrow eq '1'>highlight2<cfelse>regular</cfif>" 
		style        = "cursor:pointer"
	    onmouseover  =  "if (this.className=='regular') { this.className='highlight2' }"
		onmouseout   =  "if (this.className=='highlight2') { this.className='regular' }">
		
		<cfif get.Reference neq "">		
			<input type="hidden" name="r_#currentrow#_personmeta" id="r_#currentrow#_personmeta" value="#get.Reference#">		
		<cfelse>		
		    <input type="hidden" name="r_#currentrow#_personmeta" id="r_#currentrow#_personmeta" value="#get.IndexNo#">		
		</cfif>
		
		<input type="hidden" name="r_#currentrow#_personid" id="r_#currentrow#_personid"         value="#PersonNo#">
					
		<table width="100%" cellspacing="0" cellpadding="0">
		
			<tr>
			    <td width="50%" style="padding-left:5px" class="labelmedium"><cf_space spaces="60">#get.FirstName# #get.LastName#</td>	
				<td width="30%" class="labelit">#get.Reference#</td>			
			    <td class="labelit" width="20%">#get.Nationality#</td>		
			</tr>		
									
			<cfif currentrow neq recordcount>
				<tr><td colspan="3" class="linedotted"></td></tr>
			</cfif>
		
		</table>
	
	</td></tr>
			
</cfoutput>

</table>
