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
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
<tr>
	<td height="23">
	 &nbsp;Record <b>#First#</b> to <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> of <b>#Counted#</b> selected positions 
	</td>
	<td align="right">
	 <cfif URL.Page gt 1>
	     <button name="Prior" class="button3" 
		 onClick="javascript:reloadForm('#URL.Page-1#','#URL.sort#','#URL.Mandate#','#URL.Lay#','1','0','#url.header#')">
		 <img src="#SESSION.root#/Images/pageprior.gif" border="0">	
		 </button>
	 </cfif>
	 <cfif URL.Page lt Pages>
	       <button name="Next" class="button3" 
		    onClick="javascript:reloadForm('#URL.Page+1#','#URL.sort#','#URL.Mandate#','#URL.Lay#','1','0','#url.header#')">
			<img src="#SESSION.root#/Images/pagenext.gif" border="0">	
			</button>
      </cfif>
	  
	</td>	
</tr>	
												
</table>	
</cfoutput>						