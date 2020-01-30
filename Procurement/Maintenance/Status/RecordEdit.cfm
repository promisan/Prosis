<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Status Edit" 
			  menuAccess="Yes"
			  banner="gray"
			  systemfunctionid="#url.idmenu#">

 
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT 	*
FROM 	#client.lanPrefix#Status
WHERE 	StatusClass = '#URL.ID1#'
AND		Status = '#URL.ID2#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this status ?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#" method="post" name="frmStatus">



<!--- edit form --->
<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	 <cfoutput>
	 <tr class="labelmedium">
	 	<td height="23" width="15%">Class:</td>
		<td><b>#get.Class#</b></td>
	 </tr>
	 
	 <tr class="labelmedium">
	 	<td height="23">Status Class:</td>
		<td><b>#get.StatusClass#</b></td>
	 </tr>
	 
	 <tr class="labelmedium">
	 	<td height="23">Status:</td>
		<td><b>#get.Status#</b></td>
	 </tr>
	 
	 <TR class="labelmedium">
	 <TD class="regular">Description:</TD>  
	 <TD class="regular">
	 	<cfinput 
			type="Text" 
			name="StatusDescription" 
			id="StatusDescription" 
			value="#get.StatusDescription#"
			size="50" 
			maxlength="40" 
			class="regularxl">
	 </TD>
	 </TR>
	 
    <TR class="labelmedium">
    <TD class="regular" valign="top">Label:&nbsp;</TD>
    <TD class="regular">
  	  	<table width="100%" align="center">
									
			<cf_LanguageInput
				TableCode       		= "StatusProcurement" 
				Mode            		= "Edit"
				Name            		= "Description"
				Key1Value       		= "#get.StatusClass#"
				Key2Value       		= "#get.Status#"
				Type            		= "Input"
				Required        		= "Yes"
				Message         		= "Please, enter a valid label."
				MaxLength       		= "50"
				Size            		= "40"
				Class           		= "regularxl"
				Operational     		= "1"
				Label           		= "Yes">	
			
			</table>
    </TD>
	</TR>
	<tr><td height="5"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" align="center" height="30">
	<input class="button10g" type="submit" name="Update" id="Update" value="  Save  ">
	</td></tr>
	
	

</cfoutput>
    	
</TABLE>

</cfform>