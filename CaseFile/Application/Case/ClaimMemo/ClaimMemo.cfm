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

<cfparam name="url.memoid" default="">
<cfparam name="form.ClaimMemoId" default="">

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfif form.ClaimMemoId neq "">

	<cfquery name="Check" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ClaimMemo
		WHERE  ClaimId= '#URL.ClaimId#'
		AND    MemoId = '#memoid#'		
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="Memo" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO ClaimMemo
			(ClaimId, MemoId, ClaimMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#URL.ClaimId#','#memoid#','#form.ClaimMemoId#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
		</cfquery>
			
	<cfelse>
	
		<cfquery name="update" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE ClaimMemo
			SET ClaimMemo = '#form.ClaimMemoId#'
			WHERE  ClaimId = '#URL.ClaimId#'
			AND MemoId = '#memoid#'						
		</cfquery>	
	
	</cfif>
	
	<cfset url.memoid = "">
	
</cfif>

<cfquery name="Memo" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ClaimMemo
	WHERE  ClaimId = '#URL.ClaimId#'
	ORDER BY Created DESC
</cfquery>

<cfinvoke component="Service.Presentation.Presentation"
	       method="highlight" class="highlight4"
	    returnvariable="stylescroll"/>

<form method="post" name="memoform" id="memoform">

	<table width="98%" 
	  align="center" 
	  border="0" 
	  cellspacing="0" 
	  cellpadding="0" class="navigation_table">
	
	<tr class="linedotted">
	    <td height="20" width="16"></td>
		<td width="70%" class="labelmedium"><cf_tl id="Memo"></td>
		<td class="labelmedium"><cf_tl id="Officer"></td>
		<td class="labelmedium"><cf_tl id="Date/Time"></td>
		<td align="center"></td>
	
	</tr>
		
	<cfoutput query="Memo">
	
	<cfif url.memoid eq memoid and form.ClaimMemoId eq "" and SESSION.acc eq OfficerUserId>
	
		<tr>
		    <td height="20" class="labelit">#currentrow#.</td>
			<td colspan="4" align="center" height="80">
			<textarea name="ClaimMemoId" class="regular" style="font-size:13px;padding:3px;border-radius:5px;width: 100%;height:75">#ClaimMemo#</textarea>
			</td>
		</tr>
		
		<tr><td colspan="5" align="center" height="30">
		<input type="submit" name="Save" value="Save" class="button10g" onclick="ColdFusion.navigate('../ClaimMemo/ClaimMemo.cfm?target=#url.target#&ClaimId=#url.ClaimId#&memoid=#memoid#','#url.target#','','','POST','memoform')">
		</td></tr>
	
	<cfelse>
	
	    <cfif SESSION.acc eq OfficerUserId>
		<tr class="navigation_row labelit" onclick="ColdFusion.navigate('../ClaimMemo/ClaimMemo.cfm?target=#url.target#&ClaimId=#url.ClaimId#&memoid=#memoid#','#url.target#')">
		<cfelse>
		<tr class="navigation_row labelit">
		</cfif>
		    <td style="height:20px">#currentrow#.</td>
			<td width="70%">#paragraphformat(ClaimMemo)#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
			<td align="center">			
			<cf_img icon="edit" navigation="Yes" onclick="ColdFusion.navigate('../ClaimMemo/ClaimMemo.cfm?target=#url.target#&ClaimId=#url.ClaimId#&memoid=#memoid#','#url.target#')" border="0">
			</td>
		</tr>
	
	</cfif>
	
	</cfoutput>
	
	<cfif url.memoid eq "">
	
		<cf_assignId>
		<cfset memoid = rowguid>	
		
		<tr><td></td></tr>
		<tr>
		<td class="labelit"> <cfoutput>#memo.recordcount+1#.</cfoutput></td>
		<td colspan="4" align="center">
		<textarea name="ClaimMemoId" class="regular" style="font-size:13px;padding:3px;border-radius:5px;width: 100%;height:75"></textarea>
		</td>
		</tr>
		<tr><td colspan="5" align="center" height="30">
		    <cfoutput>		
			<input type="submit" name="Save" value="Save" class="button10g" onclick="ColdFusion.navigate('../ClaimMemo/ClaimMemo.cfm?target=#url.target#&ClaimId=#url.ClaimId#&memoid=#memoid#','#url.target#','','','POST','memoform')">
			</cfoutput>
		</td></tr>

	</cfif>

	</form>

</table>

<cfset ajaxonload("doHighlight")>

