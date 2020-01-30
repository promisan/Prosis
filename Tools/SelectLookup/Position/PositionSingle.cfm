
<cf_screentop label="Search" height="100%"
    scroll="no" banner="blue" line="no" layout="webapp" close="ColdFusion.Window.hide('dialog#url.box#')">

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top" height="100%">

	<table width="96%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td style="height:20px">
	
	<cfoutput>
		
	<form name="selectpositionsingleform#url.box#" id="selectpositionsingleform#url.box#" method="post">
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfinvoke component = "Service.Language.Tools"  
		   method           = "LookupOptions" 
		   returnvariable   = "SelectOptions">	
		  
	    <tr><td height="4"></td></tr>
	  
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="SourcePostNumber">
		
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		<TR>
		<TD style="height:28px;padding:3px" width="200" class="labelmedium"><cf_tl id="Position Number">:</TD>
		<TD><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl enterastab">			
				#SelectOptions#			
			</SELECT>			
			<INPUT type="text" name="Crit1_Value" id="Crit1_Value" class="regularxl enterastab" size="20" value=""> 	
		</TD>
		</TR>
		
		<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="FunctionDescription">		
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR>
		<TD style="height:28px;padding:3px" class="labelmedium"><cf_tl id="FunctionTitle">:</TD>
		<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl enterastab">			
				#SelectOptions#			
			</SELECT>			
			<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl enterastab"> 		
		</TD>
		</TR>
		
			
		<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="PostGrade">		
		<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
		<TR>
		<TD style="height:28px;padding:3px" class="labelmedium"><cf_tl id="Grade">:</TD>
		<TD><SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl enterastab">			
				#SelectOptions#			
			</SELECT>			
			<INPUT type="text" name="Crit3_Value" id="Crit3_Value" size="20" class="regularxl enterastab"> 		
		</TD>
		</TR>	
				
	</TABLE>
	
	</FORM>
	
	</cfoutput>	
	
	</td>
	
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr><td colspan="2" align="center">
	  
		<cf_tl id="Search" var="1">
		
		<cfoutput>
		
		<input type="button"
		   name="search" 
		   id="search"
		   value="<cfoutput>#lt_text#</cfoutput>" 
		   onclick="ptoken.navigate('#SESSION.root#/tools/selectlookup/Position/PositionSingleResult.cfm?datasource=#datasource#&page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#&filter3=#filter3#&filter3value=#filter3value#','resultunit#box#','','','POST','selectpositionsingleform#box#')"
		   class="button10g">
		   
		  </cfoutput> 
		   
	</td></tr>
	
	<tr style="height:100%">
		<td colspan="2" align="center">
		<cf_divscroll>
			<cfdiv id="resultunit#box#">
		</cf_divscroll>	
		</td>
	</tr>
	
	</table>
	
</td></tr>

</table>