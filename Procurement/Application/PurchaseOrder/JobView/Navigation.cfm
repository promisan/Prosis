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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfoutput>
<table width="100%">
<tr><td colspan="2" height="1" class="line"></td></tr>
<tr bgcolor="f4f4f4">
	<td>
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to"> <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="purchase orders">
	</td>
	<td align="right">
	 <cfif #URL.Page# gt "1">
	     <input type="button" name="Prior" id="Prior" value="<<" class="button7" onClick="javascript:reloadForm('#URL.Page-1#','#URL.View#','#URL.Lay#','#URL.sort#')">
	   </cfif>
	  <cfif #URL.Page# lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button7" onClick="javascript:reloadForm('#URL.Page+1#','#URL.View#','#URL.Lay#','#URL.sort#')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>		
<tr><td colspan="2" height="1" class="line"></td></tr>				
</table>	
</cfoutput>						
