
<cfparam name="url.memoid" default="">
<cfparam name="url.InvoiceMemo" default="">
<cfparam name="url.Action" default="">
<cfparam name="url.Header" default="1">

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfoutput>
	
<cfswitch expression="#Trim(url.action)#"> 
    <cfcase value="delete"> 
		<cfquery name="Check" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE  InvoiceMemo
			WHERE 	InvoiceId = '#URL.InvoiceId#'
			AND     MemoId = '#memoid#' 
		</cfquery>
		<cfset memoid="">
		<cfset url.memoid="">
		
    </cfcase> 
</cfswitch> 
	
<cfif url.InvoiceMemo neq "">

	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   InvoiceMemo
		WHERE  InvoiceId = '#URL.InvoiceId#'
		AND    MemoId    = '#memoid#'	
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="Memo" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO InvoiceMemo
			(InvoiceId, MemoId, InvoiceMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#URL.InvoiceId#','#memoid#','#url.InvoiceMemo#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
		</cfquery>
			
	<cfelse>
	
		<cfquery name="update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE InvoiceMemo
			SET    InvoiceMemo = '#url.InvoiceMemo#'
			WHERE  InvoiceId   = '#URL.InvoiceId#'
			AND    MemoId      = '#memoid#'						
		</cfquery>	
	
	</cfif>
	
	<cfset url.memoid = "">
	
	</cfif>

	<cfquery name="Memo" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   InvoiceMemo
		WHERE  InvoiceId = '#URL.InvoiceId#'
		ORDER BY Created DESC
	</cfquery>
	
	<cfinvoke component="Service.Presentation.Presentation"
	       method="highlight" class="highlight4"
	    returnvariable="stylescroll"/>
	
	<table width="99%" align="center" frame="void" border="0" bordercolor="e4e4e4" cellspacing="0" cellpadding="0" class="formpadding">
	
	
	<cfif url.header eq "1">
	<tr>
	    <td width="16"></td>
		<td class="labelit" width="70%"><cf_tl id="Memo"></td>
		<td class="labelit"><cf_tl id="Officer"></td>
		<td class="labelit"><cf_tl id="Date/Time"></td>
		<td align="center"></td>
	
	</tr>
	</cfif>
		
	<cfloop query="Memo">
	
	<cfif url.memoid eq memoid and url.InvoiceMemo eq "" and SESSION.acc eq OfficerUserId>
	
		<tr bgcolor="ffffff">
		    <td class="labelit">#currentrow#.</td>
			<td colspan="4" align="center">
			<textarea name="InvoiceMemo" id="InvoiceMemo" class="regular" style="font-size:13px;padding:3px;width: 100%;height:75">#InvoiceMemo#</textarea>
			</td>
		</tr>
		
		<tr><td colspan="5" align="center">
			<button type="button" name="savem" id="savem" class="button10g" style="width:120" onclick="javascript:saveMemo('#url.invoiceId#','#memoid#')">Save</button>		
		</td></tr>
	
	<cfelse>
	
	    <cfif SESSION.acc eq OfficerUserId>
		<tr>
		<cfelse>
		<tr>
		</cfif>
		    <td class="labelit" style="padding:2">#currentrow#.</td>
			<td class="labelit" style="padding:2" width="50%">#paragraphformat(InvoiceMemo)#</td>
			<td class="labelit" style="padding:2">#OfficerFirstName# #OfficerLastName#</td>
			<td class="labelit" style="padding:2">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
			<td class="labelit" style="padding:2" align="center">
			    
				<cfif SESSION.acc eq officeruserid or getAdministrator("*") eq "1">
			    
					<table cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td>
						<cf_img icon="edit" onclick="EditMemo('#url.InvoiceId#','#memoid#')">
						</td>
						<td style="padding-left:4px">
						<cf_img icon="delete" onclick="DeleteMemo('#url.InvoiceId#','#memoid#')">
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
	
	<tr bgcolor="ffffff">
	<td> <cfoutput>#memo.recordcount+1#.</cfoutput></td>
	<td colspan="4" align="center">
	<textarea name="InvoiceMemo" id="InvoiceMemo" class="regular" style="font-size:13px;padding:3px;width: 100%;height:75"></textarea>
	</td>
	</tr>
	<tr><td colspan="5" align="center">
	    <cfoutput>
		<button name="savem" id="savem" type="button" class="button10s" style="width:120" onclick="javascript:saveMemo('#url.invoiceId#','#memoid#')">
		Save
		</button>
		</cfoutput>
	</td></tr>

	</cfif>


</table>
<br>






</cfoutput>