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
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    TransactionHeader
	WHERE   TransactionId = '#Object.objectKeyValue4#'
</cfquery>

<cfoutput> 

<table align="center" class="formpadding formspacing">

	   <tr><td height="10"></td></tr>
	   	  	   
	    <tr class="labelmedium2"><td style="height:15px"><cf_tl id="Customer">:</td>
		<td style="padding-left:5px"><input type="text" class="regularxxl" name="ReferenceName" value="#get.ReferenceName#" style="width:340px"></td>
		</tr>
		
		<tr class="labelmedium2"><td style="height:15px"><cf_tl id="Tax code">:</td>
		<td style="padding-left:5px"><input type="text" class="regularxxl" name="ReferenceNo" value="#get.ReferenceNo#" style="width:120px"></td>
		</tr>	  
	  				
</table>


<input name="savecustom" type="hidden"  value="GLedger/Workflow/Customer/DocumentSubmit.cfm">
<input name="Key4" type="hidden" value="#Object.ObjectKeyValue4#">

</cfoutput>

 

