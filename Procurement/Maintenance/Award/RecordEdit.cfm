<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
 			  scroll="Yes" 
			  layout="webapp" 
			  title="Award" 
			  label="Edit" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_award
	WHERE  Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this record ?")) {	
		return true 	
		}	
		return false	
	}	

</script>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

	<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
		<tr><td height="5"></td></tr>
	
		<cfoutput>
		<TR>
		 <TD class="labelit">Code:</TD>  
		 <TD class="regular">
		 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regularxl">
			<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regular">
		 </TD>
		</TR>
		
	    <TR>
	    <TD class="labelit">Description:</TD>
	    <TD class="regular">
	  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxl">
					
	    </TD>
		</TR>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr>	
			<td align="center" colspan="2" height="30">
			<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
			<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
			<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
			</td>
		</tr>	
	
		</cfoutput>
	    	
	</TABLE>

</CFFORM>
