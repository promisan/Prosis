<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_LossClass
	WHERE  	Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
 datasource="appsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT 		LossClass
 	FROM 		ItemWarehouseLocationLoss
 	WHERE 		LossClass  = '#URL.ID1#'
</cfquery>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Loss Class" 
			  option="Maintain Loss Class #URL.ID1#" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cf_tl id = "Do you want to remove this record ?" var = "vRemove">

<cfoutput>
	
	<script language="JavaScript">
	function ask() {
		if (confirm("#vRemove#")) {	
		return true 	
		}	
		return false	
	}	
	</script>

</cfoutput>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<!--- edit form --->

<table width="92%" align="center" class="formpadding formspacing">

	<tr><td colspan="2" align="center" height="10"></tr>
	
    <cfoutput>
    <TR class="labelmedium2">
    <TD><cf_tl id="Code">:</TD>
    <TD>
  	   <cfif CountRec.recordCount eq 0>
	   		<cfinput type="text" name="Code" value="#get.Code#" message="please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
	   <cfelse>
	   		#get.Code#
	   </cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="20" class="regular">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required="No" size="30" maxlenght="50" class="regularxxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <cfif CountRec.recordCount eq 0><input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()"></cfif>
    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	
	</tr>
	
</TABLE>
	
</CFFORM>

