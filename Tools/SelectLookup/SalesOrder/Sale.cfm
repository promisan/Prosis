<cf_tl id = "POS Sales" var="1">

<!---
<cf_screentop label="#lt_text#" height="100%" scroll="no" layout="webapp" banner="blue" close="ColdFusion.Window.hide('dialog#url.box#')">
--->

<table align="center" width="100%" height="100%">

<tr><td valign="top" height="100%">

<cfoutput>

<table width="95%" height="100%" align="center">

	<tr class="line"><td style="padding-top:5px">
		
		<form name="selectsale" id="selectsale">
		
		<table width="100%" align="center"  class="formpadding"
		   onkeyup="if (window.event.keyCode == '13') { document.getElementById('salesearch').click();};">
		
		<cfinvoke component = "Service.Language.Tools"  
		   method           = "LookupOptions" 
		   returnvariable   = "SelectOptions">	
		   
		    <tr><td height="4"></td></tr>
						
			<TR class="labelmedium">
						
			<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="BatchNo">			
			<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
			
			<TD style="padding-left:5px;font-size:20px"><cf_tl id="Sales No">:</TD>
			<TD class="hide">
			      <SELECT name="Crit4_Operator" id="Crit4_Operator" style="height:25;width:60px;font:18px">
					#SelectOptions#
				</SELECT>
			</td>
			<td>			
			<INPUT type="text" name="Crit4_Value" id="Crit4_Value"  size="20" class="regularxxl" style="width:80px;height:35px;font-size:25px;"> 	
			</TD>
			
			<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="CustomerName">			
			<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
						
			<TD style="font-size:20px"><cf_tl id="Customer">:</TD>
			<TD class="hide"><SELECT name="Crit1_Operator" id="Crit1_Operator" style="height:25;font:18px">
					#SelectOptions#
				</SELECT>
			</td>
			<td>			
			<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxxl" style="height:35px;font-size:25px">	
			</TD>			
		
			<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="CustomerInvoice">
			<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		
			<TD style="padding-left:5px;font-size:20px"><cf_tl id="Customer invoice">:</TD>
			<TD class="hide"><SELECT name="Crit2_Operator" id="Crit2_Operator" style="height:25;font:18px">
					#SelectOptions#
				</SELECT>
			</td>
			<td>			
			<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxxl" style="height:35px;font-size:25px"> 
			</TD>
			
			<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
			<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="Reference">	
			<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
			
			<TD style="padding-left:5px;font-size:20px"><cf_tl id="Reference">:</TD>
			<TD class="hide"><SELECT name="Crit3_Operator" id="Crit3_Operator" style="height:25px;width:100;font:18px">
					#SelectOptions#
				</SELECT>
			</td>
			<td>				
			<INPUT type="text" name="Crit3_Value" id="Crit3_Value"  size="20" class="regularxxl" style="width:80px;height:35px;font-size:25px"> 	
			</TD>
			
			<td  align="center" style="padding:4px">

				<cf_tl id="Search" var="1">
			
				<cf_button2
					text		= "#lt_text#" 
					id			= "salesearch"  
					textsize	= "20px" 
					width		= "150px"
					height		= "35px"
					borderRadius= "3px" 
					onclick		= "_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/selectlookup/SalesOrder/SaleResult.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','#url.box#result','','','POST','selectsale')">		   
				   
			</td>
					
			</TR>
					
		</TABLE>
		
		</FORM>
	
	</td>

</tr>
	
<tr><td height="1" class="line"></td></tr>
<tr style="height:1px"><td id="#url.box#"></td></tr>
<tr>
	<td height="100%" colspan="6" align="center" id="#url.box#result"></td>
</tr>
<tr><td height="10"></td></tr>

</table>

</cfoutput>

</td></tr>

</table>


