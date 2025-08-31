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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfoutput>

	<cfquery name="Log" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT   * 
		 FROM     PurchaseAction P, Status S
		 WHERE    PurchaseNo = '#URL.ID1#'
		 AND      S.Status = P.ActionStatus
		 AND      S.StatusClass = 'Purchase'
		 ORDER BY ActionDate DESC
	</cfquery>
					
		<table width="98%" cellspacing="0" cellpadding="0" align="right">
		
		<tr>
		  <td width="7" height="20"></td>
		  <td class="labelit"><cf_tl id="Action"></td>
		  <td class="labelit"><cf_tl id="Date"></td>
		  <td class="labelit"><cf_tl id="Officer"></td>
		  <td class="labelit"><cf_tl id="Memo"></td>
		</tr>
		<tr><td height="1" colspan="5" class="line"></td></tr>  
		
		<cfloop query="Log">
		
		<tr>
		  <td></td>
		  <td class="labelit" height="20">#Log.Description#</td>
		  <td class="labelit">#dateformat(Log.ActionDate,CLIENT.DateFormatShow)#</td>
		  <td class="labelit">#Log.OfficerFirstName# #Log.OfficerLastName#</td>
		  <td class="labelit">#Log.ActionReference#</td>
		</tr>
		<cfif currentRow neq recordcount>
		<tr><td colspan="5" class="line"></td></tr>
		</cfif>
		
		</cfloop>
		
		</table>
		
	
</cfoutput>	
