<!--
    Copyright © 2025 Promisan

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
<!---  userQuery.dbo.tmp#SESSION.acc#ProgressResult contains ProgramActivityProgress reports based on 
selection query (create in ResultListing.cfm --->

<cfquery name="Output" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
Select Distinct PA.ActivityId, PO.ActivityOutput, PO.ActivityOutputDate, PA.Reference, PA.ActivityDescription, R.DescriptionShort,
	Pap.ProgressStatus, Pap.ProgressStatusDate, Rs.Description As ProgressDescription, Pap.Created
	FROM Program P, ProgramActivityOutput PO, ProgramActivity PA, Ref_SubPeriod R, 
		userQuery.dbo.tmp#SESSION.acc#ProgressResults Pap, Ref_Status Rs
	Where P.ProgramCode = '#CurrentProgramCode#'
	AND P.ProgramCode = PO.ProgramCode
	AND (PO.RecordStatus != 9 or PO.RecordStatus is NULL)
	AND PO.ActivityID = PA.ActivityID
	AND (PA.RecordStatus != 9 or PA.RecordStatus is NULL)
	AND PO.ActivityPeriodSub = R.SubPeriod
	AND PO.OutputID = Pap.OutputID	
	AND Pap.OfficerUserID = '#CurrentOfficer#'
	AND Rs.ClassStatus='Progress'
	AND Rs.Status = Pap.ProgressStatus
	Order by R.DescriptionShort 
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<cfset CurrentActivity = "">

<cfloop query="Output">

   	   <tr bgcolor= "FFFFCE">
		<td colspan="5"></td>
		</tr>
		
		
	<cfif #CurrentActivity# neq #Output.ActivityID#>
		<cfset CurrentActivity = #Output.ActivityID#>
   	   <tr bgcolor= "FFFFCE">
	   <td width="30"></td>
		<cfoutput>
	    <TD width="10%" valign="top"  class="regular"><A HREF ="javascript:EditProgram('#Components.ProgramCode#','#SearchResult.Period#','Components')">&nbsp;&nbsp;#Reference#</A></TD>
		<td colspan='3' valign="top"  class="regular"><A HREF ="javascript:EditProgram('#Components.ProgramCode#','#SearchResult.Period#','Components')"><b>#Output.ActivityDescription#</b></A></td>
		</cfoutput>
		</tr>
	</cfif>	
		
   	   <tr bgcolor="#FFFFE6">
	   <td></td>
		<cfoutput>
   		<td align="right"  valign="top" class="regular">#Output.DescriptionShort#&nbsp;&nbsp;&nbsp;</td>
		<td width="50%" valign="top"  class="regular">#Output.ActivityOutput#</td>
		<td valign="top" class="regular">&nbsp;
			     <cfif #Output.ProgressStatus# eq 0>
				     <img src="#SESSION.root#/Images/arrow.gif" alt="" width="10" height="10" border="0" align="bottom"></A>
				 <cfelseif #Output.ProgressStatus# eq 1>
					 <img src="#SESSION.root#/Images/check.gif" alt="" width="10" height="10" border="0" align="bottom"></A>
				 <cfelseif #Output.ProgressStatus# eq 2>
					 <img src="#SESSION.root#/Images/pending.gif" alt="" width="10" height="10" border="0" align="bottom"></A>
				 <cfelse>
					 <img src="#SESSION.root#/Images/pending.gif" alt="" width="10" height="10" border="0" align="bottom"></A>
				 </cfif>
				 &nbsp;#Output.ProgressDescription#&nbsp;&nbsp;&nbsp;(Entered: #DateFormat(Output.Created, CLIENT.DateFormatShow)#)			 
			    </td>
		</cfoutput>
   	  </tr>

  	   <tr bgcolor= "FFFFCE">
		<td colspan="5"></td>
		</tr>

	<tr bgcolor="EBEBEB"><td height=1 ColSpan="5"></td></tr>	 
		
</cfloop>

</table> 



