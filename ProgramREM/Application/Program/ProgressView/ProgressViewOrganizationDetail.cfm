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
<cfoutput>
<TR>
<td width="5%" align="middle" valign="top" class="regular"><a href="javascript:EditProgram('#ProgramCode#','#Period#','Program')" onMouseOver="document.img0_#programid#.src='#SESSION.root#/Images/Button.jpg'" onMouseOut="document.img0_#programid#.src='#SESSION.root#/Images/view.JPG'">
        &nbsp;<img src="#SESSION.root#/Images/view.JPG" alt="" name="img0_#programid#" id="img0_#programid#" width="13" height="16" border="0" align="middle">
    </a></td>
</TD>
<TD width="1%"class="regular"><A HREF ="javascript:EditProgram('#ProgramCode#','#Period#','Program')">&nbsp;#ProgramCode#</A></TD>
<td Colspan="2" class="regular"><A HREF ="javascript:EditProgram('#ProgramCode#','#Period#','Program')">#ProgramName#</A></td>
<td class="regular">#Reference#</td>
<TD class="regular">#OfficerFirstName# #OfficerLastName#</TD>
<TD class="regular">#DateFormat(Created, CLIENT.DateFormatShow)#</TD>

<TD align="right"> <cfset CLIENT.docdir = "#Parameter.DocumentLibrary#">
	
		<cfoutput>
			<a href="javascript:AddProgram('#Period#','#ProgramCode#','#OrgUnit#','')">
			<img src="#SESSION.root#/Images/zoomin.jpg" alt="" width="13" height="12" border="0"></A>&nbsp;
		</cfoutput>
		
		<cf_filelibraryN
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#ProgramCode#" 
		Filter=""
		Insert="yes"
		Remove="yes"
		Highlight="no"
		Listing="no">

	   &nbsp;

</TD>
</TR>

<tr>
	 <td height="10" colspan="2"></td>
	 <td height="10" colspan="5" valign="top">
	 
	 <cf_filelibraryN
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#ProgramCode#" 
		Filter=""
		Insert="no"
		Remove="yes"
		Highlight="no"
		Listing="yes"
		Color="F1F0D8">
		 
	</td>
</tr>

<!--- Begin new block --->

<cfset Per = #Period#>

<cfif #URL.Lay# eq "Components">

	<cfquery name="Components" 
	datasource="AppsProgram" >
	SELECT P.*, PA.Period
    FROM  Program P, ProgramPeriod PA
	WHERE  P.ProgramCode = PA.ProgramCode
	AND P.ParentCode = '#ProgramCode#'
	AND	PA.RecordStatus != 9
	AND PA.Period = '#URL.Period#'
	</cfquery>

  <cfloop query="Components">
   
   <tr bgcolor="EEEEEE">
     <td bgcolor="FFFFFF">1111</td>
	<td width="5%" valign="top" class="regular">
	     <img src="#SESSION.root#/Images/sub.gif" alt="" width="15" height="15" border="0" align="bottom"></A>&nbsp;&nbsp;
	    </td>
    <td colspan="3" valign="top" class="regular"><A HREF ="javascript:EditProgram('#Components.ProgramCode#','#Per#','Components')">#Components.ProgramName#</A></td>
	<TD colspan="2" valign="top" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF ="javascript:EditProgram('#Components.ProgramCode#','#Per#','Components')">&nbsp;#Components.ProgramCode#&nbsp;</A></TD>
	
	<cfoutput>
	<TD align="right"><a href="javascript:AddProgram('#Per#','#Components.ProgramCode#','#Components.OrgUnit#','')">
	<img src="#SESSION.root#/Images/zoomin.jpg" alt="" width="13" height="12" border="0"></A>

		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

	</td>
	</cfoutput>
	</tr>
	<cfquery name="Activities" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    A.*, O.OrgUnitName as OrganizationName 
	FROM      ProgramActivity A LEFT OUTER JOIN Organization.dbo.Organization O ON A.OrgUnit = O.OrgUnit
		WHERE A.ProgramCode = '#Components.ProgramCode#' 
		AND   A.ActivityPeriod = '#Components.Period#'
		AND   A.ActivityPeriodSub = '#URL.Sub#'
		AND	 (A.RecordStatus <> 9 OR A.RecordStatus is NULL)	
		ORDER BY ActivityPeriodSub, ActivityDate DESC
	</cfquery>
		

<cfloop query="Activities">

<tr bgcolor="white">
<td Colspan="2"></td>
<TD Colspan="3" class="regular">Activity: #Activities.ActivityDescription#</TD>
<TD class="regular">&nbsp;#DateFormat(Activities.ActivityDate, CLIENT.DateFormatShow)#</TD>
<TD class="regular">#Activities.Reference#</TD>
<TD>&nbsp;</td>
</TR>

<tr>
	 <td colspan="1"></td>
	 <td colspan="5"></td>
</tr>

</cfloop>

	<tr><td height=1 ColSpan=8></td></tr>	
	
	<cfquery name="SubComponents" 
	datasource="AppsProgram" >
	SELECT P.*
    FROM  Program P
	WHERE  P.ParentCode = '#Components.ProgramCode#'
	</cfquery>
			
		<cfloop query="SubComponents">
			
	   <tr bgcolor="EEEEEE">
   	    <td bgcolor="FFFFFF"></td>
		<td width="5%" valign="top" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	     <img src="#SESSION.root#/Images/sub.gif" alt="" width="15" height="15" border="0" align="bottom"></A>&nbsp;&nbsp;
	    </td>
	    <td colspan="3" valign="top" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF ="javascript:EditProgram('#SubComponents.ProgramCode#','#Per#','Components')"><i>#SubComponents.ProgramName#</i></A></td>
		<TD colspan="3" valign="top" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF ="javascript:EditProgram('#SubComponents.ProgramCode#','#Per#','Components')">&nbsp;#SubComponents.ProgramCode#&nbsp;</A></TD>
	
		</tr>
	 
	<tr><td height=1 ColSpan=8></td></tr>				
		  </cfloop>  
     
  </cfloop> 
  
</cfif>

<tr><td height=1 ColSpan=8 class="header"></td></tr>

</cfoutput>   


