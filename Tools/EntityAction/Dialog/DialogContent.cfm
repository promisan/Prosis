<cfajaximport>
<cf_menuscript>

<cf_screentop height="100%" scroll="Yes" jquery="Yes" layout="webapp" label="Action Log">

<cfquery name="Dialog" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 
   SET TextSize 400000
   SELECT *
   FROM OrganizationObjectAction OA, 
        Ref_EntityActionPublish P		
   WHERE ActionId = '#URL.ID#' 
   AND OA.ActionPublishNo = P.ActionPublishNo
   AND OA.ActionCode = P.ActionCode 
</cfquery>

<cfoutput>

<table width="100%"  cellspacing="0" cellpadding="0">

<tr><td width="100%" style="padding:10px">

<table width="95%" cellspacing="0" cellpadding="0" align="center" >

    <!---
	<tr><td align="center" height="30"><b><input type="submit" class="button10g" value="Close" name="Close" id="Close" onClick="window.close()"></td></tr>
	<tr><td align="center" colspan="2" class="line"></td></tr>
	--->
	
	<tr><td bgcolor="ffffff">
		
		<table width="99%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		
			<tr><td height="5" colspan="2"></td></tr>
			<tr class="labelmedium">
				<td width="20%"><cf_tl id="Officer">:</td>
				<td>#Dialog.OfficerFirstName# #Dialog.OfficerLastName#</td></tr>
			<tr class="labelmedium">
				<td><cf_tl id="Time stamp">:</td>
				<td><b>#dateformat(Dialog.OfficerDate,CLIENT.DateFormatShow)# #timeformat(Dialog.OfficerDate,"HH:MM")#</b></td></tr>
			<tr class="labelmedium">
				<td><cf_tl id="Action">:</td>
				<td>#Dialog.ActionDescription#</td></tr>
			<tr class="labelmedium">
				<td><cf_tl id="Action Taken">:</td>
				<td>	
				<cfif Dialog.ActionStatus eq "2"><cf_tl id="Completed">
				<cfelseif Dialog.ActionStatus eq "2N">
						<cfif Dialog.ActionGoToNoLabel neq "">#Dialog.ActionGoToNoLabel#<cfelse>No</cfif>
				<cfelse>
						<cfif Dialog.ActionGoToYesLabel neq "">#Dialog.ActionGoToYesLabel#<cfelse>Yes</cfif>
				</cfif>
				</td>
			</tr>
	
			<tr><td height="5" colspan="2"></td></tr>
			<tr class="labelmedium"><td align="center" colspan="2" bgcolor="yellow">Below a snapshot of the screen how it appeared at the moment the action was submitted</td></tr>
			<tr><td align="center" colspan="2" class="line"></td></tr>
		
		</table>
		
	</td></tr>	
	
	<tr><td>
		<table width="100%" cellspacing="0" cellpadding="0">
			<tr>
			<td style="border: 0px solid Silver;"> 
				<cf_paragraph>
					#Dialog.ActiondialogContent#
			 	</cf_paragraph>
			</td></tr>
		</table>
		</td>
	</tr>

</table>

</td></tr>

</table>

</cfoutput>

<cf_screenbottom layout="webapp">
