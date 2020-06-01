
<!---
<cf_screentop label="Search" option="Locate an employee / staffmember" 
   height="100%" scroll="No" html="Yes"
   layout="webapp" banner="gray"
   close="ColdFusion.Window.hide('dialog#url.box#')">   
   
   --->

<table align="center" border="0" style="height:100%;width:100%">

<tr><td valign="top" height="20">

	<table height="100%" width="100%" border="0" align="center" class="formspacing" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td style="padding-top:4px">
		
	<cfoutput>
	
	<cfinvoke component = "Service.Language.Tools"  
		   method           = "LookupOptions" 
		   returnvariable   = "SelectOptions">	
	
	    <form name="<cfoutput>select_#url.box#</cfoutput>" id="<cfoutput>select_#url.box#</cfoutput>" method="post">
		
		<table width="94%" border="0" cellspacing="0" align="center" class="formpadding"
		onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">
				
		    <tr><td height="4"></td></tr>
				
			<!--- Field: Staff.LastName=CHAR;40;FALSE --->
			<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="FullName">
			<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
			<TR>
			<td width="100" align="left" class="labelmedium"><cf_tl id="Name">:</td>
					
			<TD>
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td>
					<SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">				
						#SelectOptions#									
					</SELECT>
					</td>
					<td style="padding-left:4px">	
						<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl" value="">
					</td>
			  
					<!--- Field: Staff.Gender=CHAR;40;FALSE --->
					<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="Gender">
					<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
					<INPUT type="hidden" name="Crit4_Operator" id="Crit4_Operator" value="CONTAINS">
				
					<TD class="labelmedium" align="left" style="padding-left:7px"><cf_tl id="Gender">: </TD>
					
					<TD style="padding-left:3px">
					
					<select name="Crit4_Value" id="Crit4_Value" class="regularxl">
						<option value="M"><cf_tl id="Male"></option>
						<option value="F"><cf_tl id="Female"></option>
						<option value="" selected><cf_tl id="All"></option>
					</select>	
						   	
					</TD>
					</TR>
				
			</table>
			</TD>
			</TR>
			
			<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="IndexNo">	
			<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
			<TR>
			<TD align="left" class="labelmedium"><cfoutput>#client.IndexNoName#</cfoutput>:</TD>
			<TD>
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td>
					<SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">#SelectOptions#</SELECT>
					</td>
					<td style="padding-left:4px">	
						<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxl" value="">
					</td>
			   	</tr>
			</table>
			</TD>
					
			</TR>	   
			
			<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="Reference">	
			<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
			
			<TR>
			
				<TD class="labelmedium"><cf_tl id="ExternalReference">:</TD>
				<TD>
				<table cellspacing="0" cellpadding="0">
					<tr>
						<td>
						<SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl">				
							#SelectOptions#									
						</SELECT>
						</td>
						<td style="padding-left:4px">	
							<INPUT type="text" name="Crit3_Value" id="Crit3_Value" size="20" class="regularxl" value="">
						</td>
				   	</tr>
				</table>
				</TD>
					
			</TR>	
			
			<!--- check access --->
					
			<cfinvoke component = "Service.Access"  
			   method           = "staffing" 		  
			   returnvariable   = "accessStaffing">	   
	      
			<cfinvoke component = "Service.Access"  
			   method           = "WorkorderProcessor" 
			   returnvariable   = "accessworkorder">	
			   
			<cfinvoke component = "Service.Access"  
			   method           = "WarehouseProcessor" 
			   mission          = "#url.filter1value#"
			   returnvariable   = "accesswarehouse">	   
	      
			<cfif accessStaffing eq "NONE" and accessworkorder eq "NONE" and accesswarehouse eq "NONE">
			
				<input type="hidden" name="Contract" id="Contract" value="1">	
				<input type="hidden" name="OnBoard"  id="OnBoard"  value="1">	
			
			<cfelse>
			
				<tr>
				
				<td height="20" align="left" class="labelmedium"><cf_tl id="Contract">: </TD>
				<td>
				  
					   <table cellspacing="0" cellpadding="0">
					   <tr>				   
						   <td><input type="checkbox" name="Contract" id="Contract" value="1"></td>
						   <td style="padding-left:5px" class="labelmedium"><cf_tl id="Required"></td>
						   <td width="20" style="padding-right:10px"></td>
						  
						   <td style="padding-left:3px"><input type="radio" name="OnBoard" id="OnBoard" value="1"></td>
						   <td style="padding-left:5px" class="labelmedium"><cf_tl id="On board"></td>
						   <td style="padding-left:10px"><input type="radio" name="OnBoard" id="OnBoard" value="0"></td>
						   <td style="padding-left:5px" class="labelmedium"><cf_tl id="Not on board"></td>
						   <td style="padding-left:10px"><input type="radio" name="OnBoard" id="OnBoard" value="" checked></td>
						   <td style="padding-left:5px" class="labelmedium"><cf_tl id="All"></td>			   
					   </tr>
					   </table>
				 
				</tr>
			
			</cfif>
			
			<!---
			<tr>  
			  
			   <TD align="left" class="labelmedium"><cf_tl id="Assignment">: </TD>
			   <td><table cellspacing="0" class="formpadding">
				   <tr>
					   <td style="padding-left:3px"><input type="radio" name="OnBoard" id="OnBoard" value="1"></td>
						   <td class="labelmedium"><cf_tl id="On board"></td>
					   <td style="padding-left:3px"><input type="radio" name="OnBoard" id="OnBoard" value="0"></td>
						   <td class="labelmedium"><cf_tl id="Not on board"></td>
					   <td style="padding-left:3px"><input type="radio" name="OnBoard" id="OnBoard" value="" checked></td>
						   <td class="labelmedium"><cf_tl id="All"></td>
					</tr>
					</table>			
			   </TD>
			    
							
			</TD>
			</TR>   
			
			--->  
									
		</TABLE>
		
		</FORM>
	
	</td></tr>
	</cfoutput>
	
	<cfoutput>
			
	<tr><td class="line" height="1"></td></tr>
	
	<cfset nav = "#SESSION.root#/tools/selectlookup/Employee/EmployeeResult.cfm?height='+document.body.clientHeight+'&close=#url.close#&box=#url.box#&link=#link#&des1=#des1#&filter1=#url.filter1#&filter1value=#url.filter1value#&filter2=#url.filter2#&filter2value=#url.filter2value#&filter3=#url.filter3#&filter3value=#url.filter3value#">
		
	<tr><td colspan="2" height="30" align="center">   
		<cf_tl id="Search" var="1">
		<input type="button" 
		   value="#lt_text#" 
		   class="button10g"
		   onclick="ptoken.navigate('#nav#&page=1','searchresult#url.box#','','','POST','select_#url.box#')"	  
		   name="search"
		   id="search">
	</td></tr>
	
	</cfoutput>
	</table>
	
</td>
</tr>

<tr>	
  <td colspan="2" align="center" height="100%" id="searchresult<cfoutput>#url.box#</cfoutput>"></td>	
</tr>

</table>
