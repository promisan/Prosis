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
<cfparam name="url.memoid"    default="">
<cfparam name="url.action"    default="">
<cfparam name="url.controlid" default="">

<cfparam name="form.ReportMemo" default="">

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfif url.action eq "del">

	<cfquery name="update" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    DELETE FROM Ref_ReportControlMemo				
				WHERE  ControlId = '#URL.Controlid#'
				AND    MemoId = '#memoid#'						
			</cfquery>	

<cfelse>
	
	<cfif form.ReportMemo neq "">
	
		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ReportControlMemo
			WHERE  ControlId = '#URL.ControlId#'
			AND    MemoId = '#memoid#'		
		</cfquery>
		
		<cfif Check.recordcount eq "0">
	
			<cfquery name="Memo" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO Ref_ReportControlMemo
				(ControlId, MemoId, ReportMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
				VALUES
				('#URL.ControlId#','#memoid#','#form.ReportMemo#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
			</cfquery>
				
		<cfelse>
		
			<cfquery name="update" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Ref_ReportControlMemo
				SET ReportMemo   = '#form.ReportMemo#'
				WHERE  ControlId = '#URL.Controlid#'
				AND    MemoId    = '#memoid#'						
			</cfquery>	
		
		</cfif>
		
		<cfset url.memoid = "">
		
	</cfif>

</cfif>

<cfquery name="Memo" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ReportControlMemo
	WHERE  ControlId = '#URL.ControlId#'
	ORDER BY Created DESC
</cfquery>
	
	<br>
	<table width="98%" align="center" class="navigation_table">
	
	<tr><td colspan="5" class="labelmedium2" style="font-size:20px">
	
		<font color="B0B0B0">Record Additional information on this report</font></td></tr>

	<tr><td height="4"></td></tr>
	<tr class="labelmedium2 line fixlengthlist">
	    <td width="16"></td>
		<td width="70%"><cf_tl id="Memo"></td>
		<td><cf_tl id="Officer"></td>
		<td><cf_tl id="Date/Time"></td>
		<td align="center"></td>
	
	</tr>
		
	<cfoutput query="Memo">
		
	<cfif url.memoid eq memoid and form.ReportMemo eq "" and SESSION.acc eq OfficerUserId>
	
		<tr bgcolor="ffffff">
		    <td>#currentrow#.</td>
			<td colspan="4" align="center" style="padding-top:3px">
			<textarea name="ReportMemo" class="regular" style="background-color:f1f1f1;border:0px;padding:3px;font-size:12px;width: 96%;height:100">#reportMemo#</textarea>
			</td>
		</tr>
		
		<tr>
		<td colspan="5" align="center" style="padding:2px">
		    <input type="button" name="Save" id="Save" value="Delete" style="width:150" class="button10g" onclick="ptoken.navigate('RecordMemo.cfm?action=del&controlid=#url.ControlId#&memoid=#memoid#','contentbox6','','','POST','entry')">
			<input type="button" name="Save" id="Save" value="Save" style="width:150" class="button10g" onclick="ptoken.navigate('RecordMemo.cfm?action=sav&controlid=#url.ControlId#&memoid=#memoid#','contentbox6','','','POST','entry')">	
		</td>
		</tr>
	
	<cfelse>
	
	    <cfif SESSION.acc eq OfficerUserId>
		<tr class="navigation_row line fixlengthlist labelmedium2">
		<cfelse>
		<tr class="navigation_row line fixlengthlist labelmedium2">
		</cfif>
		    <td style="width:30px;padding-left:4px!important">#currentrow#.</td>
			<td style="padding-left:6px;">#paragraphformat(ReportMemo)#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
			<td align="center" style="padding-left:3px;padding-right:5px">			
				<cf_img icon="edit" navigation="Yes" onclick="ptoken.navigate('RecordMemo.cfm?controlid=#url.controlid#&memoid=#memoid#','contentbox6')">						
			</td>
		</tr>		
			
	</cfif>
	
	</cfoutput>
	
	<cfif url.memoid eq "" or Memo.recordcount eq "0">
	
		<cf_assignId>
		<cfset memoid = rowguid>	
		
		<tr bgcolor="ffffff">
		<td style="width:30px;padding-left:4px!important;padding-top:4px" valign="top" class="cenllcontent"><cfoutput>#memo.recordcount+1#.</cfoutput></td>
		<td colspan="4" align="left" style="padding-top:4px">
		     <textarea name="ReportMemo" class="regular" style="background-color:f1f1f1;border:0px;padding:3px;font-size:12px;width: 96%;height:100"></textarea>
		</td>
		</tr>
		<tr><td colspan="5" align="center" style="padding:2px">
		    <cfoutput>
				<input type="button" name="Save" id="Save" value="Add Memo"  style="width:200px" class="button10s" onclick="ColdFusion.navigate('RecordMemo.cfm?controlid=#url.controlid#&memoid=#memoid#','contentbox6','','','POST','entry')">
			</cfoutput>
		</td></tr>

	</cfif>

</table>

<cfset ajaxonload("doHighlight")>


