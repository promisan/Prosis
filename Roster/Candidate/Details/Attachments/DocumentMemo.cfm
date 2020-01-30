
<cfparam name="url.memoid"       default="">
<cfparam name="form.MemoContent" default="">
<cfparam name="url.Action"       default="">
<cfparam name="url.Header"       default="1">

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfoutput>
	
<cfswitch expression="#Trim(url.action)#"> 

    <cfcase value="delete"> 
		<cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ApplicantMemo
			WHERE PersonNo = '#URL.ID#'
			AND    MemoId = '#memoid#' 
		</cfquery>
		
		<cfset memoid="">
		<cfset url.memoid="">
		
    </cfcase> 
</cfswitch> 
	
<cfif form.MemoContent neq "">

	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ApplicantMemo
		WHERE PersonNo = '#URL.ID#'
			AND    MemoId = '#memoid#' 
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="Memo" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO ApplicantMemo
			(PersonNo, MemoId, Owner, MemoContent, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#URL.ID#','#memoid#','#url.owner#','#form.MemoContent#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
		</cfquery>
			
	<cfelse>
	
		<cfquery name="update" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE ApplicantMemo
			SET    MemoContent = '#Form.MemoContent#'
			WHERE  PersonNo    = '#URL.ID#'
			AND    MemoId      = '#memoid#'						
		</cfquery>	
	
	</cfif>
	
	<cfset url.memoid = "">
	
</cfif>

	<cfquery name="Memo" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ApplicantMemo
		WHERE  PersonNo = '#URL.Id#'
		AND    Owner    = '#URL.Owner#'
		ORDER BY Created DESC
	</cfquery>
	
			
	<form name="formmemo" id="formmemo">
	
	<table width="98%" align="center" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
			
	<cfloop query="Memo">
	
	<cfif url.memoid eq memoid and SESSION.acc eq OfficerUserId>
			
		<tr class="labelmedium" bgcolor="ffffff">
		    <td width="20" style="padding-left:4px">#currentrow#.</td>
			<td width="95%" colspan="4" align="center">
			<cf_textarea name="MemoContent" id="MemoContent" 
				toolbar = "basic"	 
				init    = "yes"		
				height  = "120"		 
				style   = "font-size:14;padding:3px;width: 100%">#MemoContent#</cf_textarea>
			</td>
		</tr>
		
		<tr><td colspan="5" align="center">
		<button name="savem" type="button" class="button10g" 
		onclick="ColdFusion.navigate('attachments/DocumentMemo.cfm?owner=#url.owner#&id=#PersonNo#&memoid=#memoid#','imemo','','','POST','formmemo');">
		<cf_tl id="Save"></button>
		
		</td></tr>		
	
	<cfelse>
	
	    <cfif SESSION.acc eq OfficerUserId>
		<tr class="labelmedium navigation_row line">
		<cfelse>
		<tr class="labelmedium navigation_row line">
		</cfif>
		    <td height="19" valign="top">#currentrow#.</td>
			<td width="50%">#paragraphformat(MemoContent)#</td>
			<td valign="top">#OfficerFirstName# #OfficerLastName#</td>
			<td valign="top">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
			<td align="center"valign="top">
			
			    <cfif SESSION.acc eq officeruserid or SESSION.isAdministrator eq "Yes" or findNoCase(url.Owner,SESSION.isOwnerAdministrator)>
				
				<table>
				  <tr>
					<td>
						<cf_img icon="edit" navigation="Yes" onclick="ColdFusion.navigate('attachments/DocumentMemo.cfm?owner=#url.owner#&id=#PersonNo#&memoid=#memoid#&Action=edit','imemo')">
					</td>
					<td style="padding-left:3px;">
						<cf_img icon="delete" onclick="ColdFusion.navigate('attachments/DocumentMemo.cfm?owner=#url.owner#&id=#PersonNo#&memoid=#memoid#&Action=delete','imemo')">
					</td>
				  </tr>
				</table>
				
				</cfif>
			</td>
		</tr>
	
	</cfif>
	
	</cfloop>
	
	<cfif url.memoid eq "">
	
	<cf_assignId>
	<cfset memoid = rowguid>	
	
	<form name="formmemo" id="formmemo">
	
		<tr bgcolor="ffffff">
		<td width="20"> <cfoutput>#memo.recordcount+1#.</cfoutput></td>
		<td colspan="4" width="95%" align="center">
		<textarea name="MemoContent"
				toolbar = "basic"
				height  = "120"	 
				style   = "font-size:14;padding:3px;width: 100%"></textarea>
		</td>
		</tr>
		<tr><td colspan="5" align="right">
		    <cfoutput>
			<button name="savem" class="button10g" 
			onclick="ColdFusion.navigate('attachments/DocumentMemo.cfm?owner=#url.owner#&id=#url.id#&memoid=#memoid#','imemo','','','POST','formmemo');">		
			<cf_tl id="Add">
			</button>
			</cfoutput>
		</td></tr>
	
	</form>

	</cfif>


</table>

</form>

<cfset AjaxOnLoad("doHighlight")>


</cfoutput>