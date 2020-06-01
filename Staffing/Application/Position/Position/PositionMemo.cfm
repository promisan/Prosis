
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

<cfform name="memoform" id="memoform">
	
	<table width="95%" 
	  align="center" 	 
	  border="0" 
	  bordercolor="e4e4e4" 
	  class="navigation_table"	
	  cellspacing="0" 
	  cellpadding="0">
	  
	 <tr><td height="5"></td></tr> 
	
	<tr class="labelmedium line">
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
			<td bgcolor="ffffff" colspan="4" align="center" height="80" style="padding-right:10px">
			<cf_textarea name="PositionMemo"
				color   = "ffffff"
				toolbar = "mini"	 
				init    = "no"		
				height  = "80"		 
				style   = "font-size:14;padding:3px;width:97%;height:50">#positionMemo#</cf_textarea>
			</td>
		</tr>
		
		<tr><td height="3"></td></tr>
		<tr><td colspan="5" align="center">
		<input type="button" 
		  name="Save" 
		  value="Save" 
		  class="button10g" 
		  style="width:100px" 
		  onclick="updateTextArea();ptoken.navigate('../Position/PositionMemo.cfm?positionno=#url.PositionNo#&memoid=#memoid#','contentbox2','','','POST','memoform')">
		</td></tr>
		<tr><td height="3"></td></tr>
	
	<cfelse>
	
	
	    <cfif SESSION.acc eq OfficerUserId>
		<tr class="labelmedium navigation_row line">
		<cfelse>
		<tr class="labelmedium line">
		</cfif>
		    <td height="20" style="padding-left:3px">#currentrow#.</td>
			<td width="70%" style="padding-left:3px">#paragraphformat(PositionMemo)#</td>
			<td>#OfficerLastName#</td>
			<td>#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
			<td align="center" style="padding-top:4px;padding-right:4px">		
			<cfif SESSION.acc eq OfficerUserId>
			<cf_img icon="edit" navigation="Yes" onclick="ptoken.navigate('../Position/PositionMemo.cfm?positionno=#url.PositionNo#&memoid=#memoid#','contentbox2')">
			</cfif>
			</td>
		</tr>
	
	</cfif>
		
	</cfoutput>
	
	<cfif url.memoid eq "">
	
	<cf_assignId>
	<cfset memoid = rowguid>	
	
	<tr><td height="5"></td></tr>
	
	<tr bgcolor="ffffff" class="line">
	<td valign="top" style="padding-left:3px;padding-top:5px"><cfoutput>#memo.recordcount+1#.</cfoutput></td>
	<td colspan="4" align="center" style="padding-right:10px">
		<cf_textarea 
			name="PositionMemo"
				color   = "ffffff"
				toolbar = "mini"	 
				init    = "no"
				height  = "80" 				 
				style="font-size:14;padding:3px;width:97%;"></cf_textarea>
	</td>
	</tr>
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="5" align="center">
	    <cfoutput>
			<input type="button" 
			    name="Save" 
				value="Save" 
				style="width:160px;height:25" 
				class="button10g" 
				onclick="updateTextArea();ptoken.navigate('../Position/PositionMemo.cfm?positionno=#url.PositionNo#&memoid=#memoid#','contentbox2','','','POST','memoform')">
		</cfoutput>
	</td></tr>
	
	<tr><td height="3"></td></tr>

	</cfif>

</table>

</cfform>

<cfset AjaxOnLoad("doHighlight")>	
<cfset AjaxOnLoad("initTextArea")>