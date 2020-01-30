
<!---
<cf_screentop label="Search" height="100%" scroll="No" line="no" layout="webapp" banner="gray" close="ProsisUI.closeWindow('dialog#url.box#')">
--->

<table width="100%" height="100%" bgcolor="white">

<tr><td valign="top" style="padding-top:8px">

<cf_divscroll>

<cfoutput>

<table width="93%" border="0" align="center" align="center">

<tr><td>

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">

<form name="selectuser#box#" method="post">

<table width="100%" border="0" class="formpadding" cellspacing="0" cellpadding="0" align="center"
	onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">
    
    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="Account">
	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR>
	<TD width="123" class="labelmedium"><cf_tl id="Account">:</TD>
	<TD>
		<table cellspacing="0" cellpadding="0">
		<tr><td>
		
		<SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">
			#SelectOptions#		
			</SELECT>		
		<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxl">
		
		</td>
		
		<cfif getAdministrator("*") eq "1">
				
		<TD style="padding-left:5px">
		    <table class="formpadding" cellspacing="0" cellpadding="0">
				<tr>
					<td><input class="radiol" type="radio" name="Status" id="Status" value="0" checked></td><td style="padding-left:3px" class="labelmedium"><cf_tl id="Active"></td>
					<td style="padding-left:4px"><input class="radiol" type="radio" name="Status" id="Status" value="1"></td><td style="padding-left:3px" class="labelmedium"><cf_tl id="Disabled"></td>
				</tr>
			</table>
		</TD>
		
		<cfelse>
		
		<input type="hidden" name="Status" value="0">
		
		</cfif>
		
		</tr>
		</table>
	
	</TD>
	</TR>
	
		
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="LastName">
	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR>
	
	<cfif filter2 eq "onboard">
		<TD class="labelmedium"><cf_tl id="Last Name">:</TD>
	<cfelse>
	    <TD class="labelmedium"><cf_tl id="User/Group name">:</TD>
	</cfif>	
	
	
	<cfif url.filter1value neq "">
	
	<TD style="height:28" class="labelmedium">
	#url.filter1value#			
	<INPUT type="hidden" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl"> 
	</TD>
	
	<cfelse>
	
	<TD style="height:28">
	<SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">#SelectOptions#</SELECT>		
	<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl"> 
	</TD>
	
	</cfif>
	
	</TR>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="FirstName">
	
	<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
	<TR>
	<TD  class="labelmedium"><cf_tl id="First Name">:</TD>
	<TD><SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl">#SelectOptions#</SELECT>		
		<INPUT type="text" name="Crit3_Value" id="Crit3_Value" size="20" class="regularxl"> 	
	</TD>
	</TR>
	
	 <!--- Field: UserNames.IndexNo --->
	<INPUT type="hidden" name="Crit0_FieldName" id="Crit0_FieldName" value="IndexNo">	
	<INPUT type="hidden" name="Crit0_FieldType" id="Crit0_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="IndexNo">:</TD>
	<TD><SELECT name="Crit0_Operator" id="Crit0_Operator" class="regularxl">
		
			#SelectOptions#
		
		</SELECT>
		
	<INPUT type="text" name="Crit0_Value" id="Crit0_Value" size="20" class="regularxl"> 
	
	</TD>
	</TR>
		
	<!--- Field: UserNames.Group=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="AccountGroup">
	
	<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="Account group">:</TD>
	<TD><SELECT name="Crit4_Operator" id="Crit4_Operator" class="regularxl">
		
			#SelectOptions#
		
		</SELECT>
		
	<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="20" class="regularxl">
	
	</TD>
	</TR>			
		
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr><td colspan="2" align="center" height="26">
				   
		<cf_tl id="Search" var="1">
		<input type="button" 
		   name="search" id="search"
		   value="<cfoutput>#lt_text#</cfoutput>" 
		   onclick="ptoken.navigate('#SESSION.root#/tools/selectlookup/User/UserResult.cfm?form=#url.form#&height='+document.body.clientHeight+'&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','resultuser#box#','','','POST','selectuser#box#')"
		   class="button10g"
		   style="height:24px;width:160px">
		   
	</td></tr>

</cfoutput>

<tr>
	<td colspan="2" align="center">
	
	<cfdiv id="resultuser#box#">
	</td>
</tr>

</table>

</FORM>

</td></tr>

</table>

</cf_divscroll>

</td></tr></table>
