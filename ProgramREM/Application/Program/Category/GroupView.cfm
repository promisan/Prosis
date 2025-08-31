<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cf_screenTop height="100%" html="No" jQuery="yes" scroll="yes" flush="Yes">

<script language="JavaScript">
javascript:window.history.forward(1);
</script>

<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ProgramPeriod
		WHERE  ProgramCode = '#url.ProgramCode#'
		AND    Period      = '#url.period#'		
</cfquery>	

<!--- old code on old table 

 <cfinvoke component="Service.Process.Organization.Organization"  
		   method="getUnitScope" 
		   mode="Parent" 
		   OrgUnit="#get.OrgUnit#"
		   returnvariable="orgunits">			   
  --->

<cfquery name="CategoryAll" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	F.AreaCode,
				F.Area, 
				F.Code, 
				F.DescriptionMemo, 
				F.Description, 
				ISNULL((SELECT ListingOrder FROM Ref_ProgramCategory WHERE Code = F.AreaCode),0) as ParentListingOrder,
				S.*
		FROM   	ProgramCategory S, 
		       	Ref_ProgramCategory F 
		WHERE  	S.ProgramCode = '#URL.ProgramCode#'
		AND  	S.ProgramCategory = F.Code
		AND  	S.Status != '9'
		<!--- hardcoded --->
		AND  	Area != 'Risk'
		
		 <!--- adjusted 
		  
		  AND    Code IN (
		                  SELECT Category 
		                  FROM   Ref_ParameterMissionCategory 
						  WHERE  Mission = (SELECT Mission FROM Program WHERE ProgramCode = '#url.programcode#')
						  <!--- global access or units are enabled --->
						  <cfif orgunits neq "">
						  AND    (OrgUnit = '0'  or OrgUnit IN (#preserveSingleQuotes(orgunits)#))
						  <cfelse>
						  AND    (OrgUnit = '0') 
						  </cfif>
						  AND    (Period is NULL or Period = '#url.Period#')						  
						  AND    BudgetEarmark = 0
						  AND    Operational = 1
						  )	  	
						  
			--->			  
		
		ORDER BY ParentListingOrder ASC, F.AreaCode ASC, F.ListingOrder ASC
</cfquery>

<cfinvoke component="Service.Access"
		Method="Program"
		ProgramCode="#URL.ProgramCode#"
		Period="#URL.Period#"	
		Role="'ProgramOfficer'"	
		ReturnVariable="EditAccess">
			
<cfif (EditAccess eq "EDIT" or EditAccess eq "ALL")>

	<cflocation url="CategoryEntry.cfm?header=1&ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#&mid=#url.mid#" addtoken="No">

</cfif>

<!--- JavaScript program form calls (in Tools tag directory)--->

<cf_dialogREMProgram>

<cfparam name="URL.Layout" default="Program">

<cfform action="CategoryEntry.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#"
  method="POST" 
  name="groupentry">

<table width="100%" class="formpadding">

<tr><td style="padding:10px">
	<cfinclude template="../Header/ViewHeader.cfm">
</td></tr>

<tr><td style="padding:10px">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td class="linedotted" colspan="2"></td></tr>

	<cfif EditAccess eq "EDIT" or EditAccess eq "ALL">
  
  	<tr><td height="34" align="center" colspan="2">
		 <input type="submit" name="Submit" value="Edit" class="button10g" style="font-size:13px;width:190;height:25">		
		</td>
  	</tr>

	</cfif>

	<tr>
    
	<td width="99%" colspan="2" align="center">
    <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
	
	
	<cfif CategoryAll.recordcount eq "0">
	
	<tr><td colspan="4" align="center" class="labelmedium" style="padding-top:5px"><font color="808080">There are no records to show in this view</td></tr>
	
	</cfif>
	
    <cfoutput query="CategoryAll" group="AreaCode">
    
	<!---
	<TR><td style="padding-right:20px" colspan="4" class="labellarge"><b>#Area#</b>
	<cfif descriptionmemo neq ""><font size="3">												
		: #PARAGRAPHFORMAT(DescriptionMemo)#
	</cfif>			
	</td><TR>
	--->
	    
	<cfoutput>
	
    <TR class="navigation_row">    
    <TD valign="top" style="width:200px;padding-top:4px;padding-left:20px" class="labelit"><b>#Area#</b>:&nbsp;&nbsp;#Description#</TD>
	<TD valign="top" style="width:50%;padding-top:4px;padding-right:6px" class="labelit">#DescriptionMemo#</TD>
	<TD valign="top" class="labelit" style="padding-top:4px">#OfficerLastName#</TD>
	<TD valign="top" class="labelit" style="padding-top:4px">#DateFormat(Created,CLIENT.DateFormatShow)# #TimeFormat(Created,"HH:MM")#</TD>	
    </TR>			
	
			<cfquery name="getCodes" 
				    datasource="AppsProgram" 
		   		    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
		   				SELECT *
					    FROM   Ref_ProgramCategoryProfile
					    WHERE  Code = '#Code#'			  
		    </cfquery>		
									
			<cfif getCodes.recordcount gte "1">
			
				<tr>
					
					<td colspan="4" style="padding-left:25px;padding-right:30px">
		
						<cf_ProgramTextArea
							Table           = "ProgramCategoryProfile" 
							Domain          = "Category"			
							FieldOutput     = "ProfileNotes"
							TextAreaCode    = "#quotedvalueList(getCodes.TextAreaCode)#"
							Field           = "#code#"											
							Mode            = "View"
							Key01           = "ProgramCode"
							Key01Value      = "#URL.ProgramCode#"
							Key02           = "ProgramCategory"
							Key02Value      = "#code#">
																	
					</td>
					
				</tr>
			
			</cfif>		
		
	<tr><td colspan="3" class="line"></td></tr>
	
	<tr><td></td></tr>
	
	</cfoutput>
	
	<tr><td height="4" colspan="4"></td></tr>
	
	</cfoutput>

	</table>

</tr>

</table>

</td>
</td>
 
<input type="hidden" name="programcode" id="programcode" value="<cfoutput>#URL.ProgramCode#</cfoutput>">

</table>

</cfform>

<cf_screenbottom html="No">
