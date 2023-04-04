<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cfajaximport>
<cf_dialogMaterial>

<CFOUTPUT>		

<script LANGUAGE = "JavaScript">

	function selected(itemuomid) {
	
	    			
		<cfif url.script neq "">
					
			try {
				parent.#url.script#(itemuomid,'#url.field#','#url.scope#','#url.access#')	
			} catch(e) {}
		
		</cfif>	
			
		try {
			parent.ProsisUI.closeWindow('mystock');
		} catch(e) { parent.ColdFusion.Window.destroy('mystock',true); }
	}

</script>	

</cfoutput>



<cf_tl id="Item search" var="1">

<cf_screentop label="#lt_text#" close="parent.ColdFusion.Window.destroy('mystock',true)" jquery="Yes" height="100%" line="no" html="no" scroll="no" layout="webapp" banner="gray">

<!--- End Prosis template framework --->

<cfoutput>

	<cfparam name="url.itemmaster" default="">

	<form name="locform" style="height:100%">
	
		<input type="hidden" name="itemmaster" value="#trim(url.itemmaster)#">
	
	    <table height="98.5%" class="formspacing" width="97%" align="center">
					
		<!--- Field: Item.ItemColor=CHAR;20;FALSE --->
	
		<cf_tl id="contains" var="1">
		<cfset vcontains=lt_text>
		
		<cf_tl id="begins with" var="1">
		<cfset vbegins=lt_text>
		
		<cf_tl id="ends with" var="1">
		<cfset vends=lt_text>
		
		<cf_tl id="is" var="1">
		<cfset vis=lt_text>
		
		<cf_tl id="is not" var="1">
		<cfset visnot=#lt_text#>
		
		<cf_tl id="before" var="1">
		<cfset vbefore=#lt_text#>
		
		<cf_tl id="after" var="1">
		<cfset vafter=#lt_text#>		
		
		<cf_tl id="search" var="1">
		<cfset vsearch=#lt_text#>	
		
		<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="I.Classification">
		
		<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
		<TR class="hide" height="10">
		<TD class="labelmedium"><cf_tl id="Classification">:</font>
		<TD><SELECT name="Crit4_Operator" id="Crit4_Operator" class="regularxl">
			
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>			
			
			</SELECT> 
		</TD>
		<TD>
			
		<INPUT class="regularxl" type="text" name="Crit4_Value" id="Crit4_Value" size="20">
		
		</TD>
		</TR>
	 
		<!--- Field: Item.ItemDescription=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="I.ItemDescription">
		
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		<TR height="10">
		<TD class="labelmedium" width="80"><cf_tl id="Description">:</TD>
		<TD width="100"><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">
			
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>		
				<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
						
			</SELECT>
		</TD>
		<TD width="60%">
	
	    <INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxl">
		
		</TD>
		</TR>
		
		<!--- Field: Item.ItemDescriptionExternal=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit5_FieldName" id="Crit5_FieldName" value="U.ItemBarCode">
		
		<INPUT type="hidden" name="Crit5_FieldType" id="Crit5_FieldType" value="CHAR">
		<TR height="10">
		<TD class="labelmedium"><cf_tl id="Barcode">:</TD>
		<TD><SELECT name="Crit5_Operator" id="Crit5_Operator" class="regularxl">
			
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>		
				<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
						
			</SELECT> 
		</TD>
		<TD>		
		<INPUT type="text" name="Crit5_Value" id="Crit5_Value" size="20" class="regularxl"> 	
		</TD>
		</TR>
		
		<!--- Field: Item.Category=CHAR;20;FALSE --->
		<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="I.Category">
		
		<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
		<TR height="10">
		<TD class="labelmedium"><cf_tl id="Category">:</TD>
		<TD class="regular"><SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl">
			
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>		
				<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
						
			</SELECT>
		</TD>
		<TD>
		
		<INPUT type="text" name="Crit3_Value" id="Crit3_Value" size="20" class="regularxl"> 
		
		</TD>
		</TR>

<!--- Field: Item.ItemNoExternal=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit6_FieldName" id="Crit6_FieldName" value="I.ItemNoExternal">

		<INPUT type="hidden" name="Crit6_FieldType" id="Crit6_FieldType" value="CHAR">
		<TR height="10">
		<TD class="labelmedium"><cf_tl id="ExternalNo">:</TD>
		<TD><SELECT name="Crit6_Operator" id="Crit6_Operator" class="regularxl">

			<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
			<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
			<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
			<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
			<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>

		</SELECT>
		</TD>
		<TD>
			<INPUT type="text" name="Crit6_Value" id="Crit6_Value" size="20" class="regularxl">
		</TD>
		</TR>
		
		
		<!--- Field: Item.ItemDescriptionExternal=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="I.ItemDescriptionExternal">
		
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR height="10">
		<TD class="labelmedium"><cf_tl id="Description External">:</TD>
		<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">
			
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>		
				<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
						
			</SELECT> 
		</TD>
		<TD>		
		<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl"> 	
		</TD>
		</TR>
		
		<tr><td colspan="3" align="right" class="line"></td></tr>	
		<tr><td height="30" colspan="3" align="center">
		
		<cfoutput>
		
			<input class="button10g" type="button" name"Search" id="Search" value="#vsearch#"
				onclick="ColdFusion.navigate('ItemSearchResult.cfm?mission=#URL.Mission#','result','','','POST','locform')">
		</cfoutput>
		</td></tr>	
		
		<tr>
		    <td colspan="3" style="height:100%;border:0px solid silver" valign="top" id="result">				
			<cfinclude template="ItemSearchResult.cfm">																	
			</td>
		</tr>
					
	</table>	
	
	</form>
	
</cfoutput>	

<cf_screenBottom layout="innerbox">
