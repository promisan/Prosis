
<cfparam name="url.memoid" default="">
<cfparam name="form.RequisitionMemo" default="">

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfif form.RequisitionMemo neq "">

	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   RequisitionLineMemo
		WHERE  RequisitionNo = '#URL.RequisitionNo#'
		AND    MemoId = '#memoid#'		
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="Memo" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO RequisitionLineMemo
			(RequisitionNo, 
			 MemoId, 
			 RequisitionMemo, 
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
			VALUES
			('#URL.RequisitionNo#',
			 '#memoid#',
			 '#Form.RequisitionMemo#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')			
		</cfquery>
			
	<cfelse>
	
		<cfquery name="update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE RequisitionLineMemo
			SET    RequisitionMemo = '#form.RequisitionMemo#' 
			WHERE  MemoId = '#memoid#'						
		</cfquery>	
	
	</cfif>
	
	<cfset url.memoid = "">
	
</cfif>

<cfquery name="Memo" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLineMemo
	WHERE  RequisitionNo = '#URL.RequisitionNo#'
	ORDER BY Created DESC
</cfquery>

<cf_divscroll>

<cfform name="memoform" id="memoform">
	
	<table width="95%" align="center" class="navigation_table">
	 	
	<tr  class="line fixrow">
	    <td width="16"></td>
		<td class="labelit" width="70%"><cf_tl id="Memo"></td>
		<td class="labelit"><cf_tl id="Officer"></td>
		<td class="labelit"><cf_tl id="Date/Time"></td>
		<td align="center"></td>
	
	</tr>
		
	<cfoutput query="Memo">
	
	<cfif url.memoid eq memoid and form.RequisitionMemo eq "" and SESSION.acc eq OfficerUserId>
	
		<tr bgcolor="ffffff" class="line">
		    <td height="20" valign="top" style="padding-top:4px" class="labelit">#currentrow#.</td>
			<td colspan="4" align="center" height="80" style="padding-top:4px">
			<cf_textarea name="RequisitionMemo" 
				color   = "ffffff"
				toolbar = "mini"	 
				init    = "no"				 
				style=";font-size:14;padding:3px;width: 100%;height:120">#RequisitionMemo#</cf_textarea>
			</td>
		</tr>
		<tr><td height="3"></td></tr>
		<tr><td colspan="5" align="center">
		<input type="button" 
		  name="Save" 
          id="Save"
		  value="Save" 
		  class="button10g" 
		  style="width:100px" 
		  onclick="updateTextArea();ColdFusion.navigate('RequisitionEditNote.cfm?Requisitionno=#url.requisitionno#&memoid=#memoid#','contentbox2','','','POST','memoform')">
		</td></tr>
		<tr><td height="3"></td></tr>
	
	<cfelse>
			
		<tr class="navigation_row line labelmedium">
			
		    <td height="20" class="labelit" style="padding-left:3px">#currentrow#.</td>
			<td width="70%" class="labelit">#paragraphformat(RequisitionMemo)#</td>
			<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
			<td class="labelit">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
			<td class="labelit" align="center" style="padding-top:1px;padding-right:3px">
			    <cfif SESSION.acc eq OfficerUserId>
			      <cf_img icon="edit" navigation="Yes" onclick="ColdFusion.navigate('RequisitionEditNote.cfm?requisitionno=#url.RequisitionNo#&memoid=#memoid#','contentbox2')">			
				</cfif>  
			</td>
			
		</tr>
	
	</cfif>
		
	</cfoutput>
	
	<cfif url.memoid eq "">
	
		<cf_assignId>
		<cfset memoid = rowguid>	
		
		<tr><td height="4"></td></tr>
		
		<tr bgcolor="ffffff" class="line">
		<td valign="top" style="padding-left:3px;padding-top:10px"> <cfoutput>#memo.recordcount+1#.</cfoutput></td>
		<td colspan="4" align="center">
		
			<cf_textarea name="RequisitionMemo" 
			   style="width: 100%;height:120;font-size:14;padding:3px" 
				toolbar = "mini"	 
				init    = "no"				 
			   class="regular"></cf_textarea>
		</td>
		</tr>
		
		<tr><td height="3"></td></tr>
		
		<tr><td colspan="5" align="center">
		
		    <cfoutput>
			
				<input type="button" 
				    name="Save" 
	                id="Save"
					value="Save" 
					style="width:120px" 
					class="button10g" 
					onclick="updateTextArea();ColdFusion.navigate('RequisitionEditNote.cfm?requisitionno=#url.RequisitionNo#&memoid=#memoid#','contentbox2','','','POST','memoform')">
					
			</cfoutput>
			
		</td></tr>
		
		<tr><td height="3"></td></tr>

	</cfif>
	
	</table>

	</cfform>

</cf_divscroll>




<cfset AjaxOnLoad("doHighlight")>	
<cfset AjaxOnLoad("initTextArea")>