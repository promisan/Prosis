
<cf_screentop height="100%" 
     scroll="Vertical" 
	 html="No" title="Employee Inquiry" 
	 validateSession="Yes">

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   CODE, NAME 
    FROM     Ref_Nation
	WHERE    NAME > 'A'
	AND      Code IN (SELECT DISTINCT Nationality FROM Employee.dbo.Person)
	ORDER BY NAME
</cfquery>

<cfquery name="Mission" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission	
	<cfif getAdministrator("*") eq "0">
	WHERE  Mission IN (SELECT DISTINCT Mission 
	                   FROM   Organization.dbo.OrganizationAuthorization 
					   WHERE  UserAccount = '#session.acc#')
	</cfif>				   
</cfquery>

<cf_tl id="contains" var="1">
<cfset vcontains=#lt_text#>
<cf_tl id="begins with" var="1">
<cfset vbegins=#lt_text#>
<cf_tl id="ends with" var="1">
<cfset vends=#lt_text#>
<cf_tl id="is" var="1">
<cfset vis=#lt_text#>
<cf_tl id="is not" var="1">
<cfset visnot=#lt_text#>
<cf_tl id="before" var="1">
<cfset vbefore=#lt_text#>
<cf_tl id="after" var="1">
<cfset vafter=#lt_text#>

<cf_submenuLogo module="Staffing" selection="Inquiry">

<cfparam name="url.height"          default="800">

<cfparam name="SESSION.StaffSearch.Mode"     default="1">
<cfparam name="SESSION.StaffSearch.Mission"  default="">
<cfparam name="SESSION.StaffSearch.IndexNo"  default="">

<!--- Search form --->
<FORM action="PersonSearchQuery.cfm?height=<cfoutput>#URL.height#</cfoutput>" method="post" style="padding-left:50px">

	<table width="96%" bgcolor="white" border="0" cellspacing="0" cellpadding="0" class="formpadding formspacing">
		
		<tr><td height="6"></td></tr>
		
		<tr><td height="1" class="line" colspan="2"></td></tr>
				
		<tr><td height="3" colspan="1" class="regular"></td></tr>
	
	    <!--- Field: Status=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit5_FieldName" value="PersonStatus">
		
		<INPUT type="hidden" name="Crit5_FieldType" value="CHAR">
		<INPUT type="hidden" name="Crit5_Operator" value="CONTAINS">
		<TR>
		<TD width="20%" class="labelmedium"><cf_tl id="Workforce status">:</TD>	
				
		<TD>	
			<table>
			<tr class="labelmedium">
			   
			   <td><input type="radio" class="radiol" name="Crit5_Value" value="1" onclick="document.getElementById('filter').className='regular'"  <cfif SESSION.StaffSearch["Mode"] eq "1">checked</cfif>></td>
			   <td style="font-size:17px;padding-left:5px"><cf_tl id="On board"></td>
			   <td style="padding-left:6px;padding-right:10px;padding-top:2px">
				   <select name="Mission" class="regularxl">
					   <cfoutput query="Mission">
					   	<option value="#Mission#" <cfif SESSION.StaffSearch["Mission"] eq mission>selected</cfif>>#Mission#</option>
					   </cfoutput>
				   </select>		   
			   </td>	   
			   <td style="padding-left:5px"><input type="radio" onclick="document.getElementById('filter').className='hide'" class="radiol" name="Crit5_Value" value="0" <cfif SESSION.StaffSearch["Mode"] eq "0">checked</cfif>></td>
			   <td style="padding-left:5px;font-size:17px"><cf_tl id="All recorded persons"></td>
			     	
			</tr>
			</table>
		</TD>
		</TR>
		
		<tr>
		<td></td>
		
		<cfif SESSION.StaffSearch["Mode"] eq "1">
			<cfset cl = "regular">
		<cfelse>
		   <cfset cl = "hide">
		</cfif>
		
		 <td id="filter" class="<cfoutput>#cl#</cfoutput>" style="padding-top:0px;border:0px solid e1e1e1;padding-left:3px;padding-right:7px">
	
				   <table style="width:700px">
				   <tr class="labelmedium" style="height:20px">
				   <td><img src="<cfoutput>#session.root#</cfoutput>/images/join.gif" alt="" border="0"></td>
				   <td style="padding-left:2px"><input type="radio" name="Crit9_Value" value="0" checked></td>
				   <td style="font-size:13px;padding-top:0px"><cf_tl id="All"></td>  
				   <td style="width:15px;border-right:1px solid gray"></td>		
				   <td style="padding-left:2px"><input type="radio" name="Crit9_Value" value="8"></td>
				   <td style="font-size:13px;padding-top:0px"><cf_tl id="Step Increment">..</td>  
				    <td style="padding-left:2px"><input type="radio" name="Crit9_Value" value="7"></td>
				   <td style="font-size:13px;padding-top:0px"><cf_tl id="SPA expiry">..</td>  
				   <td style="padding-left:2px"><input type="radio" name="Crit9_Value" value="9"></td>
				   <td style="font-size:13px;padding-top:0px"><cf_tl id="Appointm expiry"></td>  
				   <td style="padding-left:2px;padding-right:3px"><cf_tl id="in"></td>
				   <td style="padding-right:4px"><input type="input" name="Days_Value" style="width:30px;text-align:center" value="30" class="regularxl"></td>
				   <td style="padding-right:4px"><cf_tl id="days"></td>				   
				   </td>
				   <td style="border-left:1px solid gray;"></td>				  
				   <td style="padding-left:2px"><input type="radio" name="Crit9_Value" value="5"></td>
				   <td style="font-size:13px;padding-top:0px;padding-right:4px"><cf_tl id="Birth day"></td>  
				   <td style="border-left:1px solid gray;"></td>				  
				   <td style="padding-left:2px"><input type="radio" name="Crit9_Value" value="2"></td>
				   <td style="font-size:13px;padding-top:0px;padding-right:0px"><cf_tl id="No user"></td>  
				   	</tr>
				   </table>
			   
			   </td>
		
		</td>
			
		</tr>
		
		<tr><td height="3" colspan="1"></td></tr>
		
			
		<!--- Field: Staff.IndexNo=CHAR;20;TRUE --->
		<INPUT type="hidden" name="Crit1_FieldName" value="IndexNo">
		<INPUT type="hidden" name="Crit1_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium" style="min-width:220px"><cfoutput><cf_tl id="IndexNo"></cfoutput></TD>
		<td style="border:1px solid silver;padding:0px">
		
			<table style="min-width:300px;width:100%">
			<tr>
			<td style="width:100px;border-right:1px solid silver" align="right">
			    <SELECT name="Crit1_Operator" class="regularxl" style="width:100px;border:0px">
			
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
				<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
				<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
				<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
			
				</SELECT>
			
			</td>
			
			<td style="padding-left:3px"><INPUT type="text" name="Crit1_Value" value="<cfoutput>#SESSION.StaffSearch['IndexNo']#</cfoutput>" style="border:0px;width:95%" class="regularxl"></td>	
			</tr>
			</table>
				
		</TD>
		</TR>
		
		<!--- Field: Staff.IndexNo=CHAR;20;TRUE --->
		<INPUT type="hidden" name="Crit0_FieldName" value="PersonNo">
		<INPUT type="hidden" name="Crit0_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium"><cf_tl id="PersonNo">:</TD>
		<TD style="border:1px solid silver;padding:0px">
		
			<table style="min-width:270px;width:100%">
			<tr>
			<td style="width:100px;border-right:1px solid silver" align="right">
			    <SELECT name="Crit0_Operator" class="regularxl" style="width:100px;border:0px">
				
					<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
					<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
					<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
					<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
					<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
					<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
					<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
				
				</SELECT>
			</td>
			<td style="padding-left:3px"><INPUT type="text" name="Crit0_Value" style="border:0px;width:95%" class="regularxl"></td>	
			</tr>
			</table>
		
		</TD>
		</TR>
			
		<INPUT type="hidden" name="Crit1a_FieldName" value="Reference">	
		<INPUT type="hidden" name="Crit1a_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium"><cf_tl id="ExtReference">:</TD>
		<td style="border:1px solid silver;padding:0px">
			<table style="min-width:300px;width:100%">
			<tr>
			<td style="width:100px;border-right:1px solid silver" align="right">
			    <SELECT name="Crit1a_Operator" class="regularxl" style="width:100px;border:0px" >
					
						<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
						<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
						<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
						<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
										
					</SELECT>
					
			</td>
			<td style="padding-left:3px"><INPUT type="text" name="Crit1a_Value" style="border:0px;width:95%" class="regularxl"></td>	
			</tr>
			</table>
							
		</TD>
		</TR>	     
		
		<!--- Field: Staff.FirstName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit3b_FieldName" value="FullName">	
		<INPUT type="hidden" name="Crit3b_FieldType" value="CHAR">
		<TR><TD class="labelmedium"><cf_tl id="Full name">:</TD>
		
		<td style="border:1px solid silver;padding:0px">
			<table style="min-width:300px;width:100%">
			<tr>
			<td style="width:100px;border-right:1px solid silver" align="right">
			<select name="Crit3b_Operator" class="regularxl" style="width:100px;border:0px" >
			
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
				<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
				<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
				<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
			
			</SELECT>
			
			</td>
				
			<td style="padding-left:3px"><INPUT type="text" name="Crit3b_Value" style="border:0px;width:95%" class="regularxl"></td>	
			</tr>
			</table>
		
		</TD>
		</TR>
		
		<!--- Field: Staff.LastName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" value="LastName">	
		<INPUT type="hidden" name="Crit2_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium"><cf_tl id="Last name">/<cf_tl id="Maiden name">:</b></TD>
		
		<td style="border:1px solid silver;padding:0px">
			<table style="min-width:300px;width:100%">
				<tr>
				<td style="width:100px;border-right:1px solid silver" align="right">
				<select name="Crit2_Operator" class="regularxl" style="width:100px;border:0px" >
				
					<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
					<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
					<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
					<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
					<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
					<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
					<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
				
				</SELECT>
				
				</td>
				<td style="padding-left:3px"><INPUT type="text" name="Crit2_Value" style="border:0px;width:95%" class="regularxl"></td>	
				</tr>
			</table>
			
		</TD>
		</TR>
		
		<!--- Field: Staff.FirstName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit3_FieldName" value="FirstName">	
		<INPUT type="hidden" name="Crit3_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium"><cf_tl id="First name">:</b></TD>
		<TD style="border:1px solid silver;padding:0px">
		
		<table style="min-width:300px;width:100%">
				<tr>
				<td style="width:100px;border-right:1px solid silver" align="right">
				<select name="Crit3_Operator" class="regularxl" style="width:100px;border:0px" >
				
			
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
				<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
				<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
				<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
			
			</SELECT>
			
			</td>
			<td style="padding-left:3px">		
			<INPUT type="text" name="Crit3_Value" style="border:0px;width:95%" class="regularxl">		
			</td>
			</tr>
		   </table>
		
		</TD>
		</TR>
		
		<INPUT type="hidden" name="Crit3a_FieldName" value="MiddleName">	
		<INPUT type="hidden" name="Crit3a_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium"><cf_tl id="Middle name">:</TD>
		<TD style="border:1px solid silver;padding:0px">
		
		<table style="min-width:300px;width:100%">
				<tr>
				<td style="width:100px;border-right:1px solid silver" align="right">
				<select name="Crit3a_Operator" class="regularxl" style="width:100px;border:0px" >
				
				<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
				<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
				<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
				<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
				<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
				<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
				<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
			
			</SELECT>
			
			</td>
			<td style="padding-left:3px">		
			<INPUT type="text" name="Crit3a_Value" style="border:0px;width:95%" class="regularxl">	
			
			</td>
		
		</tr></table>
		
		</TD>
		</TR>
				
		
				
		<!--- Field: Staff.Nationality=CHAR;40;FALSE --->
		
		<TR>
		<TD class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Modality">:</TD>
		
		<TD>
		
			<table><tr><td>
			
			<cfquery name="Category" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_PostGradeParent
				ORDER BY ViewOrder
			</cfquery>
			
			<select name="PersonStatus" size="2" multiple class="regularxl" style="height:105px;min-width:200">		
			<option value="" selected><cf_tl id="All"></option>
			    <cfoutput query="Category">			
				<option value="'#Code#'">#Description#</option>
				</cfoutput>
		    </select>
			
			<!---
			
			<cfquery name="Status" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_PersonStatus
				ORDER BY Code DESC
			</cfquery>
			
			<select name="PersonStatus" size="2" style="height:80px;min-width:200" class="regularxl">		
			<option value="" selected><cf_tl id="All"></option>
			    <cfoutput query="Status">			
				<option value="#Code#">#Description# <cf_tl id="only"></option>
				</cfoutput>
		    </select>
			--->
			
			</td>
			
			
			</tr></table>
			
		</TD>
		</TR>
		
	   <!--- Field: Staff.Gender=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit4_FieldName" value="Gender">
		
		<INPUT type="hidden" name="Crit4_FieldType" value="CHAR">
		<INPUT type="hidden" name="Crit4_Operator" value="CONTAINS">
			<TR>
		<TD class="labelmedium"><cf_tl id="Gender">:</b></TD>
		
		<TD class="labelmedium">
		
			<table class="formpadding">
			<tr>
				<td><input type="radio" class="radiol" name="Crit4_Value" value="M"></td><td class="labelmedium"><cf_tl id="Male"></td>
				<td><input type="radio" class="radiol" name="Crit4_Value" value="F"></td><td class="labelmedium"><cf_tl id="Female"></td>
				<td><input type="radio" class="radiol" name="Crit4_Value" value="" checked></td><td class="labelmedium"><cf_tl id="Any"></td>
			</tr>
			</table>
	   
		</TD>
		</TR>
					
		<TR>
		<TD class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Nationality">:</b><br><br>
		<input type="radio" class="radiol" name="Nation" value="0" onclick="document.getElementById('Nationality').disabled=false"><cf_tl id="Include">
		<input type="radio" class="radiol" name="Nation" value="1" onclick="document.getElementById('Nationality').disabled=true" checked><cf_tl id="Exclude">
	 	
		</TD>
		
		<TD>
	    	<select name="Nationality" id="Nationality" size="10" multiple disabled class="regularxl" style="height:150px;min-width:200">
			    <cfoutput query="Nation">		
				<option value="'#Code#'"selected>#Name#</option>
				</cfoutput>
		    </select>
			
		</TD>
		</TR>
			
		<tr><td height="1" colspan="2" class="line"></td></tr>	
		
	    <tr>
	    <td height="40" align="center" colspan="2">
		 <cfoutput>
		 <cf_tl id="Search" var="vSearch">
		 <input type="submit" name="Submit" value="#vSearch#" class="button10g" onclick="Prosis.busy('yes')" style="width:130;height:27">
	 	 </cfoutput>
		</td>
		
	    </tr> 	
	 
	</TABLE>	

</FORM>

