<cf_tl id = "Quote" var="1">

<!---
<cf_screentop label="#lt_text#" height="100%" scroll="no" layout="webapp" banner="blue" close="ColdFusion.Window.hide('dialog#url.box#')">
--->

<cfquery name="Warehouse" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Warehouse
	   WHERE     Mission = '#url.mission#'
	   -- AND       Warehouse IN (SELECT Warehouse FROM itemTransaction)
	   AND       Operational = 1  	   
</cfquery>

<table align="center" width="100%" height="100%">

<tr><td valign="top" height="100%">

	<cfoutput>
	
		<table width="98%" height="100%" align="center">
		
			<tr class="line"><td>
				
				<form name="selectsale" id="selectsale">
				
				<table width="100%" align="center"  class="formpadding"
				   onkeyup="if (window.event.keyCode == '13') { document.getElementById('salesearch').click();};">
				
				<cfinvoke component = "Service.Language.Tools"  
				   method           = "LookupOptions" 
				   returnvariable   = "SelectOptions">	
				   
				    <tr><td height="4"></td></tr>
								
					<TR class="labelmedium">
					
					<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
					<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="Warehouse">	
					<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
					<TD class="hide"><SELECT name="Crit3_Operator" id="Crit3_Operator" style="height:25px;width:100;font:18px">
							#SelectOptions#
						</SELECT>
					</td>
					
					<td>		
					<select name="Crit3_Value" id="Crit3_Value" style="height:35px;width:160px;font:25px" class="regularxxl" onchange="document.getElementById('salesearch').click()">
					<option value="">Any</option>
					<cfloop query="Warehouse">
				     	<option value="#Warehouse#">#WarehouseName#</option>
					</cfloop>	
					</select>
					</TD>
								
					<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="RequestNo">			
					<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
					
					<TD style="padding-top:16px;padding-left:5px;font-size:11px"><cf_tl id="Quote No"></TD>
					<TD class="hide">
					      <SELECT name="Crit4_Operator" id="Crit4_Operator" style="height:25;width:60px;font:18px">
							#SelectOptions#
						</SELECT>
					</td>
					<td>			
					<INPUT type="text" name="Crit4_Value" id="Crit4_Value"  size="15" class="regularxxl" style="text-align:center;padding-left:7px;width:60px;height:35px;font-size:25px;"> 	
					</TD>
					
					<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="CustomerName">			
					<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
								
					<TD style="padding-top:16px;font-size:11px"><cf_tl id="Customer"></TD>
					<TD class="hide"><SELECT name="Crit1_Operator" id="Crit1_Operator" style="height:25;font:18px">
							#SelectOptions#
						</SELECT>
					</td>
					<td>			
					<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="15" class="regularxxl" style="padding-left:7px;height:35px;font-size:25px">	
					</TD>			
				
					<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="OfficerLastName">
					<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
				
					<TD style="padding-top:16px;padding-left:5px;font-size:11px"><cf_tl id="Officer"></TD>
					<TD class="hide"><SELECT name="Crit2_Operator" id="Crit2_Operator" style="height:25;font:18px">
							#SelectOptions#
						</SELECT>
					</td>
					<td>			
					<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="15" class="regularxxl" style="padding-left:7px;height:35px;font-size:25px"> 
					</TD>
															
					<td  align="center" style="padding:4px">
		
						<cf_tl id="Search" var="1">
										
						<cf_button2
							text		= "#lt_text#" 
							id			= "salesearch"  
							textsize	= "20px" 
							width		= "120px"
							height		= "35px"
							borderRadius= "3px" 
							onclick		= "_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/selectlookup/StockOrder/QuoteResult.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','#url.box#result','','','POST','selectsale')">		   
						   
					</td>
							
					</TR>
							
				</TABLE>
				
				</FORM>
			
			</td>
		
		</tr>
			
		<tr><td height="1" class="line"></td></tr>
		<tr style="height:1px"><td id="#url.box#"></td></tr>
		<tr><td height="100%" colspan="6" align="center" id="#url.box#result">
		<cfset url.page = "1">
		<cfinclude template="QuoteResult.cfm">
		</td></tr>
		<tr><td height="10"></td></tr>
		
		</table>
	
	</cfoutput>

</td></tr>

</table>


