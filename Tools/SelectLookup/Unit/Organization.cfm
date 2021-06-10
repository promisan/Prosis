<cf_tl id = "Unit" var = "vTitle">
   
<table align="center" width="100%" height="100%">

<tr><td valign="top" height="100%">

	<cfoutput>
	
		<table width="98%" height="100%" border="0" align="center" align="center">
		
		<tr>
		    <td height="30">
		   
			<form name="selectorg" method="post">
			
				<table width="100%" class="formpadding" align="center" onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">
				
				<cfinvoke component = "Service.Language.Tools"  
					   method           = "LookupOptions" 
					   returnvariable   = "SelectOptions">		   
					
				    <tr><td height="6"></td></tr>
				  
				    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
					<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="OrgUnitName">
					
					<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
					<TR class="labelmedium">
					
					<TD width="50" style="min-width:100px;padding-left:10px"><cf_tl id="Name">:</TD>
					<TD class="hide"><SELECT type="hidden" name="Crit1_Operator" id="Crit1_Operator" class="regularh">#SelectOptions#</SELECT>
					</td>
					<td style="padding-left:10px">	
					<INPUT type="text" style="height:21px" name="Crit1_Value" id="Crit1_Value" class="regularxl" size="25"> 			
					</TD>
					</tr>
					
					<tr>
						
					<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
					<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="OrgUnitCode">			
					<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
					
					<TD style="padding-left:10px"><cf_tl id="Code">:</TD>
					<TD class="hide">
					<SELECT type="hidden" name="Crit2_Operator" id="Crit2_Operator" class="regularxl">#SelectOptions#</SELECT>				
					</td>
					<td style="padding-left:10px">
					<INPUT type="text" style="height:21px" name="Crit2_Value" id="Crit2_Value" size="25" class="regularxl"> 			
					</TD>
					</TR>
							
				</TABLE>
			
			</form>
		
		</td>
		
		<td align="right">
		
		<!--- check for tree role manager --->
		
		  <cfif filter1 eq "Mission">
		  		  		
			<cfinvoke component = "Service.Access"  
			   method           = "RoleAccess" 
			   role             = "'TreeRoleManager'"
			   mission          = "#filter1value#"	   
			   returnvariable   = "access">	
			  
			  <cfif access eq "Granted">	  
				  <input type="button" style="height:40px;font-size:14px" class="button10g" name="Maintain" value="Maintain #filter1value#" onclick="opentree('#filter1value#')">	  
			  </cfif>
			  	   
		  </cfif>	   
			  
		  </td>
		
		</tr>
		
		<tr><td colspan="2" class="line"></td></tr>
			
		<tr><td style="height:35px" colspan="2" align="center">
		   
			<cf_tl id="Search" var="1">
			
			<input type="button" 
			   name="search" id="search"
			   value="<cfoutput>#lt_text#</cfoutput>" 
			   onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/selectlookup/Unit/OrganizationResult.cfm?height='+document.body.clientHeight+'&page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','resultunit#box#','','','POST','selectorg')"
			   class="button10g">
			   
		</td></tr>
		
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		<td colspan="2" align="center" height="100%"><cf_divscroll id="resultunit#box#"/></td>
	</tr>
	
	</table>

</td></tr>

</table>