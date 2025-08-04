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

<cfset nav = "#SESSION.root#/CaseFile/application/claim/asset/Line.cfm?claimid=#URL.claimid#&id2=">

<table width="100%" cellspacing="0" cellpadding="0">
<tr><td colspan="2"></td></tr>
<tr>
	<td class="labelit">
	 <font face="Verdana" size="1">
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	 </font>
	</td>
	<td align="right">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page-1#','contentbox1')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" value=">>" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page+1#','contentbox1')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
				
</table>	

</cfoutput>		
	