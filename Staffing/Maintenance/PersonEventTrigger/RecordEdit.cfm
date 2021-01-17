<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Event Trigger" 
			  menuAccess="Yes" 
			  banner="gray"
			  jQuery="yes"
			  line="No"
			  systemfunctionid="#url.idmenu#">
			  
<cfoutput>

	<script>
		
		function editPE(trig, code) {			
			ProsisUI.createWindow('mydialog', 'Person Event', '',{x:100,y:100,height:300,width:document.body.clientWidth-160,modal:true,resizable:true,center:true})    							
			ptoken.navigate('PersonEventTriggerEdit.cfm?trigger='+trig+'&code='+code, 'mydialog');	 
		}
		
		function deletePE(trig, code) {
			if (confirm('Do you want to remove person event trigger ?')) {
				ptoken.navigate('PersonEventTriggerPurge.cfm?trigger='+trig+'&code='+code, 'processDeletePE');	 
			}
		}
		
	</script>

</cfoutput>

<cfajaximport tags="cfform, cfdiv">
  
<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_EventTrigger
		WHERE 	Code = '#URL.ID1#'
</cfquery>


<cfquery name="GetEntity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Entity
		WHERE Role in 
		(
			SELECT Role
			FROM Ref_AuthorizationRole
			WHERE SystemModule = 'Staffing'
		)
		ORDER BY EntityCode
</cfquery>



<!--- edit form --->

<cfform action="RecordSubmit.cfm?id1=#URL.ID1#" method="POST"  name="dialog">

<table width="92%" align="center" class="formpadding formspacing">

    <tr><td style="height:5px"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium2" width="120">&nbsp;&nbsp;Code:</TD>
    <TD class="labelmedium2">
  	   #get.Code#
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="25" maxlength="50" class="regularxxl">
    </TD>
	</TR>

	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Entity:</TD>
    <TD>
		<select name="entity" id="entity" class="regularxxl">
			<option value="">None</option>
			<cfloop query="GetEntity">
			  <option value="#GetEntity.EntityCode#" <cfif getEntity.EntityCode eq Get.EntityCode>selected</cfif>>#GetEntity.EntityCode# - #GetEntity.EntityDescription#</option>
		  	</cfloop>
		</select>
    </TD>
	</TR>



	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a Listing Order" required="No" size="2" maxlength="2" class="regularxxl">
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		<td align="center" colspan="2">
    	<input class="button10g" style="width:200px" type="submit" name="Update" value=" Update ">
		</td>	
	</tr>


	
</TABLE>

</CFFORM>

<table width="92%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	<tr><td height="15"></td></tr>
	<tr>
		<td class="labellarge"><cf_tl id="Associated Events"></td>
	</tr>
	<tr><td class="linedotted"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td>
			<cf_securediv id="divPersonEvent" bind="url:PersonEventListing.cfm?id1=#URL.ID1#">
		</td>
	</tr>
</table>

