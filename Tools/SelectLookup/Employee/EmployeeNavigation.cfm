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

<cfset nav = "#SESSION.root#/tools/selectlookup/Employee/EmployeeResult.cfm?height=#url.height#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#url.filter1#&filter1value=#url.filter1value#&filter2=#url.filter2#&filter2value=#url.filter2value#&filter3=#url.filter3#&filter3value=#url.filter3value#">

<table width="100%" cellspacing="0" cellpadding="0">
<tr class="line">
	<td class="labelit">
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	</td>
	<td align="right" style="padding-right:10px">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="_cf_loadingtexthtml='';ptoken.navigate('#nav#&page=#url.page-1#','searchresult#url.box#','','','POST','select_#url.box#')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="_cf_loadingtexthtml='';ptoken.navigate('#nav#&page=#url.page+1#','searchresult#url.box#','','','POST','select_#url.box#')">
	   </cfif>
	   
	</td>	
</tr>										
</table>	

</cfoutput>						