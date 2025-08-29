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
<cfparam name="url.memoid" default="">
<cfparam name="form.PositionMemo" default="">

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfif form.PositionMemo neq "">

	<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   PositionMemo
		WHERE  PositionNo = '#URL.PositionNo#'
		AND    MemoId = '#memoid#'		
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="Memo" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO PositionMemo
			(PositionNo, MemoId, PositionMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#URL.PositionNo#','#memoid#','#form.PositionMemo#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
		</cfquery>
			
	<cfelse>
	
		<cfquery name="update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE PositionMemo
			SET PositionMemo = '#form.PositionMemo#'
			WHERE  PositionNo = '#URL.PositionNo#'
			AND MemoId = '#memoid#'						
		</cfquery>	
	
	</cfif>
	
	<cfset url.memoid = "">
	
</cfif>

<cfquery name="Memo" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PositionMemo
	WHERE  PositionNo = '#URL.PositionNo#'
	ORDER BY Created DESC
</cfquery>

<!---
<cfform name="memoform" id="memoform">
--->
	
	<table width="99%" align="center" class="navigation_table">
	  	
	<tr class="labelmedium2 line">
	    <td height="20" style="min-width:30px"></td>
		<td width="80%"><cf_tl id="Memo"></td>
		<td style="min-width:180px"><cf_tl id="Officer"></td>
		<td style="min-width:120px"><cf_tl id="Date/Time"></td>
		<td style="width:20px" align="center"></td>	
	</tr>
		
	<cfoutput query="Memo">
	
	<cfif url.memoid eq memoid and form.PositionMemo eq "" and SESSION.acc eq OfficerUserId>
	
		<tr bgcolor="ffffff" class="line">
		    <td valign="top" style="padding-top:5px" height="20">#currentrow#.</td>
			<td bgcolor="ffffff" colspan="3" style="padding-right:10px">
						 
			<textarea name="PositionMemo"
				color   = "ffffff"
				toolbar = "mini"	 
				init    = "no"		
				height  = "80"		 
				style   = "border:0px;font-size:14px;background-color:f1f1f1;font-size:14px;padding:3px;width:100%;height:50px">#positionMemo#</textarea>
			</td>
		  <td colspan="1" align="center"  style="padding-right:4px">
		<input type="button" 
		  name="Save" 
		  value="Save" 
		  class="button10g" 
		  style="width:60px" 
		  onclick="updateTextArea();_cf_loadingtexthtml='';ptoken.navigate('../Position/PositionMemo.cfm?positionno=#url.PositionNo#&memoid=#memoid#','memo','','','POST','positionedit')">
		</td></tr>
		
	<cfelse>
	
	
	    <cfif SESSION.acc eq OfficerUserId>
		<tr class="labelmedium2 navigation_row linedotted">
		<cfelse>
		<tr class="labelmedium2 linedotted">
		</cfif>
		    <td height="20" style="padding-left:3px">#currentrow#.</td>
			<td width="70%" style="padding-left:3px">#paragraphformat(PositionMemo)#</td>
			<td>#OfficerLastName#</td>
			<td>#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
			<td align="center" style="padding-top:1px;padding-right:4px">		
			<cfif SESSION.acc eq OfficerUserId>
			<cf_img icon="open" navigation="Yes" onclick="_cf_loadingtexthtml='';ptoken.navigate('../Position/PositionMemo.cfm?positionno=#url.PositionNo#&memoid=#memoid#','memo')">
			</cfif>
			</td>
		</tr>
	
	</cfif>
		
	</cfoutput>
	
	<cfif url.memoid eq "">
	
	<cf_assignId>
	<cfset memoid = rowguid>	
	
	<tr bgcolor="ffffff" class="line">
	<td valign="top" style="padding-left:3px;padding-top:5px"><cfoutput>#memo.recordcount+1#.</cfoutput></td>
	<td colspan="3" style="padding-right:10px">
		<textarea 
			name="PositionMemo"
				color   = "ffffff"
				toolbar = "mini"	 
				init    = "no"
				height  = "80" 				 
				style="border:0px;background-color:f1f1f1;font-size:14px;padding:3px;width:100%;"></textarea>
	</td>
	<td style="padding-right:4px">
	 <cfoutput>
			<input type="button" 
			    name="Save" 
				value="Save" 
				style="width:60px;height:25" 
				class="button10g" 
				onclick="updateTextArea();_cf_loadingtexthtml='';ptoken.navigate('../Position/PositionMemo.cfm?positionno=#url.PositionNo#&memoid=#memoid#','memo','','','POST','positionedit')">
		</cfoutput>
	</td>
	
	</tr>
	
	<tr><td height="3"></td></tr>

	</cfif>

</table>

<!---
</cfform>
--->

<cfset AjaxOnLoad("doHighlight")>	

<!---
<cfset AjaxOnLoad("initTextArea")>
--->