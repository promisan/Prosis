
<cf_dialogStaffing>

<cfoutput>

<script>

	function selectbackground(doc, pers) {
		window.open("#SESSION.root#/Custom/DPKO/Vactrack/Salary/SelectBackground.cfm?ID=" + doc + "&ID1=" + pers, "DialogWindow", "width=800, height=650, status=yes, scrollbars=yes, resizable=yes","1");
	}

</script>

</cfoutput>


<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
    
  <tr><td height="1" colspan="2" bgcolor="E4E4e4"></td></tr>  
  <tr>
    <td colspan="2">
    <table width="100%" align="center" border="0" class="formpadding">
	
	<tr><td height="4" colspan="4"><b>Select relevant back ground</td></tr>
	
	<tr><td height="1" colspan="4" bgcolor="C0C0C0"></td></tr>
		
	<tr><td colspan="4">
		<cfinclude template="SelectBackground.cfm">
	</td></tr>	
	
	<tr><td height="1" colspan="4" bgcolor="C0C0C0"></td></tr>		
	
	<tr><td height="2"></td></tr>
		  
   <input name="savecustom" type="hidden"  
    value="Staffing/Application/Employee/Workflow/ContractBackground/DocumentSubmit.cfm">
		
	<tr><td height="3" colspan="4"></td></tr> 
			
	</TABLE>

	</td>
	</tr>

	<tr><td height="1" colspan="2" bgcolor="#E4E4e4"></td></tr> 

</table>