
<cfoutput>

<form name="selectuser#box#" method="post">

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top">

<table width="99%" border="0" align="center" cellspacing="0" cellpadding="0" align="center">

<tr><td>

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">

<table width="96%" class="formpadding" border="0" cellspacing="0" cellpadding="0" align="center">

    <tr><td height="7"></td></tr>
  
    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="Account">	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR>
	
	<TD style="height:30px" width="123" class="labelit">Account:</TD>
	<TD class="labelit">
	<SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">#SelectOptions#</SELECT>		
	<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxl">
	
	</TD>
	</TR>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="LastName">	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR>
	<TD style="height:30px" class="labelit">Group name:</TD>
	<TD class="labelit">
		<SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">#SelectOptions#</SELECT>		
		<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl"> 
	
	</TD>
	</TR>
				
		<!--- Field: UserNames.Group=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="AccountGroup">	
		<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
	
	<TR>
	<TD style="height:30px" class="labelit">Account group:</TD>
	<TD class="labelit">
	<SELECT name="Crit4_Operator" id="Crit4_Operator" class="regularxl">#SelectOptions#</SELECT>		
	<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="20" class="regularxl">	
	</TD>
	</TR>	
	
		<!--- Field: UserNames.Group=CHAR;40;FALSE --->
	
	<TR>
	<TD class="labelit">Account status:</TD>
	<TD class="labelit" style="height:23">
	    <table><tr>
		<td><input type="radio" name="Status" id="Status" value="0" checked></td>
		<td style="padding-left:4px" class="labelit">Active</td>
    	<td style="padding-left:8px"><input type="radio" name="Status" id="Status" value="1"></td>
		<td style="padding-left:4px" class="labelit">De-activated</td>
		</tr>
		</table>
	</TD>
	</TR>	
		
	<tr><td colspan="2" class="linedotted"></td></tr>
		
	<tr><td colspan="2" align="center" height="27">
	   
	    <table cellspacing="0" cellpadding="0">

		<tr>
		<td style="padding:1px">
		
		<cf_tl id="Close" var="1">
		<input type="button" 
		   value="#lt_text#" 
		   onclick="ColdFusion.Window.hide('dialog#url.box#')"
		   class="button10g">
		   
		</td>
		 
		<td style="padding:1px">  
		
		<cf_tl id="Search" var="1">
		<input type="button" 
		   value="#lt_text#" 
		   onclick="ptoken.navigate('#SESSION.root#/tools/selectlookup/UserGroup/UserGroupResult.cfm?close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','resultuser#box#','','','POST','selectuser#box#')"
		   class="button10g">
		</td>
		</tr>
		
		</table> 
		
	</td></tr>

	<tr>
		<td colspan="2" align="center"><cfdiv id="resultuser#box#"></td>
	</tr>

	</table>

</td></tr>

</table>

</FORM>

</cfoutput>
