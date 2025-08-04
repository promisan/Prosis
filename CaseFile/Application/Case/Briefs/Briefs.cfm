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
<cfquery name="Get" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   C.*
	FROM     Claim C
	WHERE    C.ClaimId = '#URL.claimId#' 	
</cfquery>	


<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding" align="center">
<cfform method="POST" name="briefs" action="../Briefs/BriefsSubmit.cfm?claimid=#url.claimid#">
<tr><td class="line"></td></tr>
<tr><td height="100%">

<cf_textarea name="ClaimMemo"
   toolbaronfocus="Yes"
   enabled="Yes"
   visible="Yes"		  
   richtext="Yes"	   
   toolbar="Basic"       
   skin="silver"
   class="regular">
	 <cfoutput>#get.ClaimMemo#</cfoutput>
</cf_textarea>
			 
				 <!--- toolbar="Basic" --->

</td></tr>
<tr><td colspan="2" class="line"></td></tr>
<tr><td align="center" height="30">
<input value="Save" type="submit" class="button10g" name="Save">
</td></tr>
</cfform>
</table>

