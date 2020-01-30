<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top">

<form name="searchselect" id="searchselect" method="post">

<table width="100%" 
	border="0" 
	align="center" 
	cellspacing="0" 
	cellpadding="0" 
	align="center"
	class="formpadding">

<tr><td>
	  
	<table width="97%" border="0" 
		cellspacing="0" 
		cellpadding="0" 
		align="center"
		class="formpadding">
			
		<!--- Field: Staff.LastName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="PathName">
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR>
		<td width="100" align="left" class="labelit">&nbsp;<cf_tl id="Path">:<input type="hidden" name="Crit2_Operator" id="Crit2_Operator" value="CONTAINS"></td>
		<TD>
			
		<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl">
	   	
		</TD>
		</TR>
		
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="FileName">	
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		<TR>
		<TD class="labelit" align="left">&nbsp;<cf_tl id="FileName">:<input type="hidden" name="Crit1_Operator" id="Crit1_Operator" value="CONTAINS"></TD>
		<TD>					
		<INPUT type="text" name="Crit1_Value" id="Crit1_Value" class="regularxl" size="20">
	    	
		</TD>
		</TR>	
	  						
	</TABLE>

</td></tr>

<cfoutput>
		
<tr><td class="linedotted" height="1"></td></tr>

<cfset nav = "#SESSION.root#/tools/selectlookup/Template/TemplateResult.cfm?close=#url.close#&box=#box#&link=#link#&des1=#des1#&&des2=#des2#">
	
<tr><td colspan="2" align="center">
	<cf_tl id="Close" var="1">
	<input type="button" 
	   value="<cfoutput>#lt_text#</cfoutput>" 
	   onclick="ColdFusion.Window.hide('dialog#url.box#')"
	   class="button10g">
	<cf_tl id="Search" var="1">
	<input type="button" 
	   value="<cfoutput>#lt_text#</cfoutput>" 
	   onclick="ColdFusion.navigate('#nav#&page=1','searchresult','','','POST','searchselect')"
	   class="button10g">
</td></tr>

</cfoutput>

<tr>
	<td colspan="2" align="center" style="padding:15px">
	<cfdiv id="searchresult">
	</td>
</tr>

</table>

</FORM>

</td></tr>

</table>
	