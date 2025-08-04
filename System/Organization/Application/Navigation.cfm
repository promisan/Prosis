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

<table width="100%">
<tr>
	<td>
	 &nbsp;Record <b>#First#</b> to <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> of <b>#Counted#</b> selected records 
	</td>
	<td align="right">
	 <cfif URL.Page gt "1">
	     <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('OrganizationListingList.cfm?page=#url.page-1#&id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&id4=#url.id4#','tree')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ColdFusion.navigate('OrganizationListingList.cfm?page=#url.page+1#&id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&id4=#url.id4#','tree')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
							
</table>	
</cfoutput>						