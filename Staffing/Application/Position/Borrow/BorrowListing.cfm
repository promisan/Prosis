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
<CF_RegisterAction 
SystemFunctionId="0101" 
ActionClass="Inquiry Staff" 
ActionType="Search Result" 
ActionReference="" 
ActionScript="">

<cfswitch expression="#URL.ID#">

<cfcase value="ORG"><cfset cond = "AND Org.OrgUnitCode = '#URL.ID1#'"></cfcase>
<cfcase value="GRP"><cfset cond = "AND PostGradeParent = '#URL.ID1#'"></cfcase>
<cfcase value="GRD"><cfset cond = "AND P.PostGrade = '#URL.ID1#'"></cfcase>
<cfcase value="OCG"><cfset cond = "AND F.OccupationalGroup = '#URL.ID1#'"></cfcase>
<cfcase value="FUN"><cfset cond = "AND P.FunctionNo = '#URL.ID1#'"></cfcase>

</cfswitch>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="URL.PDF" default="No">
<cfparam name="CLIENT.Sort" default="OrgUnit">
<cfif #CLIENT.Sort# neq "PostOrder" and
      #CLIENT.Sort# neq "PostClass" and
      #CLIENT.Sort# neq "Posttype" and
	  #CLIENT.Sort# neq "OrgUnit" and
	  #CLIENT.Sort# neq "DateExpiration">
	  <cfset deleted = deleteClientVariable("Sort")>
</cfif>   
<cfparam name="CLIENT.Sort" default="OrgUnit">
<cfparam name="URL.Sort" default="#CLIENT.Sort#">
<cfparam name="URL.Lay" default="Current">

<cfparam name="URL.Org" default="">
<cfparam name="URL.Act" default="">

<cfparam name="URL.ID2" default="Template">

<cfset condA = "">

<cfparam name="CLIENT.OrgUnitS" default=""> 

<cfif URL.Act eq "del">
   <cfset #CLIENT.OrgUnitS# = #Replace(CLIENT.OrgUnitS,-URL.Org, '')#>
 </cfif>

<cfif URL.Act eq "add">
  <cfset #CLIENT.OrgUnitS# = #CLIENT.OrgUnitS#&"-"&#URL.Org#>
</cfif>

<cfquery name="Default" 
datasource="AppsOrganization" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT MandateNo 
FROM Ref_Mandate
WHERE Mission = '#URL.ID2#'
ORDER BY MandateDefault DESC
</cfquery>

<cfif Default.recordCount eq 1>
   <cfparam name="URL.ID3" default="#Default.MandateNo#">
<cfelse>
   <cfparam name="URL.ID3" default="0000">   
</cfif>   


<cfparam name="URL.Mission" default="#URL.ID2#">
<cfparam name="URL.Mandate" default="#URL.ID3#">
<cfparam name="URL.page" default="1">
<cfset #CLIENT.sort# = #URL.Sort#>

<cfquery name="Parameter" 
 datasource="AppsEmployee" 
 maxrows=1 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT * 
    FROM Parameter</cfquery>
		
<cfquery name="Current" 
datasource="AppsOrganization" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
   FROM Ref_Mandate
   WHERE Mission = '#URL.ID2#'
   AND MandateNo = '#URL.Mandate#'
   </cfquery>

 <cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM Ref_Mandate
   WHERE Mission = '#URL.ID2#'
   ORDER BY MandateNo DESC
   </cfquery>
   
<cfif #URL.Sort# eq "DateExpiration">
         <cfset orderby = "P.DateExpiration DESC">
<cfelse> <cfset orderby = "#URL.Sort#">	
</cfif> 

<!--- create a temp table for later repeated usage in the template --->

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Post">

<!--- Query returning search results --->
<cfquery name="SearchResultX" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT P.*, G.PostGradeParent, G.PostOrder, O.OccupationalGroup, O.Description
  INTO userQuery.dbo.#SESSION.acc#Post
  FROM Position P, Applicant.dbo.Occgroup O, Applicant.dbo.FunctionTitle F, Ref_PostGrade G
  WHERE O.OccupationalGroup = F.OccupationalGroup
  AND G.PostGrade = P.PostGrade
  AND F.FunctionNo = P.FunctionNo 
  AND #PreserveSingleQuotes(CLIENT.MandateFilter)#
  <cfif #URL.ID# neq "ORG">#preserveSingleQuotes(cond)#</cfif> 
</cfquery>

<cfswitch expression="#URL.ID#">

<cfcase value="ORG"><cfset cond = "AND Org.OrgUnitCode = '#URL.ID1#'"></cfcase>
<cfcase value="GRP"><cfset cond = "AND PostGradeParent = '#URL.ID1#'"></cfcase>
<cfcase value="GRD"><cfset cond = "AND P.PostGrade = '#URL.ID1#'"></cfcase>
<cfcase value="OCG"><cfset cond = "AND P.OccupationalGroup = '#URL.ID1#'"></cfcase>
<cfcase value="FUN"><cfset cond = "AND P.FunctionNo = '#URL.ID1#'"></cfcase>

</cfswitch>
  
<cfoutput>

<script>
	
	function reloadForm(pdf,page,sort,layout,mandate,mission,act,org) {
	     window.location="MandateViewGeneral.cfm?PDF=" + pdf + "&ID=#URL.ID#&ID1=#URL.ID1#&Page=" + page + "&Sort=" + sort + "&Lay=" + layout + "&Mandate=" + mandate + "&Mission=" + mission + "&act=" + act + "&Org=" + org;
	}
	
	function AddAssignment(postno) {
	     window.open("../../Assignment/AssignmentEntry.cfm?ID=" + postno + "&Caller=Listing", "AssignmentNew", "width=800, height=900, toolbar=no, scrollbars=yes, resizable=no");
	}
	
	function Process(action) {
		if (confirm("Do you want to " + action + " selected positions ?")) {return true; }
		{return false}
	}
	
</script>	

</cfoutput>

<cf_dialogPosition>
<cf_dialogOrganization>

<cfif URL.PDF eq "Yes">

   <cfinclude template="../../ReportPdf/StaffingTable01.cfm">

<cfelse>

<HTML><HEAD>
    <TITLE>Search - Search Result</TITLE>
</HEAD><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<form action="../PositionBatch.cfm" method="post" name="result" id="result">

<input type="hidden" name="mission" value="<cfoutput>#URL.Mission#</cfoutput>">
<input type="hidden" name="ID" value="<cfoutput>#URL.ID#</cfoutput>">
<input type="hidden" name="ID1" value="<cfoutput>#URL.ID1#</cfoutput>">
<input type="hidden" name="page1" value="<cfoutput>#URL.Page#</cfoutput>">
<input type="hidden" name="lay" value="<cfoutput>#URL.Lay#</cfoutput>">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" style="border-collapse: collapse;">
  <tr>
    <td class="BannerXLN">&nbsp;
	
    	<cfoutput>
		Mandate: <b>#Current.Description#</b> &nbsp;Period: <b>#DateFormat(Current.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(Current.DateExpiration, CLIENT.DateFormatShow)#</b>
    	</cfoutput>
	   		
	</td>
	
	<td align="right" class="BannerXLN">

		<select name="mandate" size="1" style="background: #002350; color: Menu;" 
		onChange="javascript:reloadForm('No',page.value,sort.value,layout.value,this.value,mission.value,'x','x')">
		<cfoutput query="Mandate">
		<option value="#MandateNo#" <cfif #URL.Mandate# eq "#MandateNo#">selected</cfif>>
    		#MandateNo# #Description#
		</option>
		</cfoutput>
	    </select>

<!--- drop down to select only a number of record per page using a tag in tools --->	
    <cfinclude template="../../../../Tools/PageCount.cfm">
<select name="page" size="1" style="background: #002350; color: Menu;"
onChange="javascript:reloadForm('No',this.value,sort.value,layout.value,mandate.value,mission.value,'x','x')">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
    </cfloop>	 
</SELECT> &nbsp;  	

    </TD>
	
  
  </tr>
  
  <tr>  
  
  <tr>
  
    
  <td colspan="2">
  
  <table width="100%" border="0" bgcolor="#C9D3DE">
    
  <tr>
  <td class="regular">&nbsp;
  <cfoutput>
  <input type="button" value="Add Position" class="button1" onClick="javascript:AddPosition(<cfoutput>'#URL.ID2#'</cfoutput>,mandate.value,'','','')">
  <input type="button" value="Add Organization" class="button1" onClick="javascript:addOrgUnit('#URL.ID2#',mandate.value,'#URL.ID1#')">
  </cfoutput>
  
  </td>
    
  <td align="right" class="regular">
  
    <select name="sort" size="1" style="background: #C9D3DE;"
onChange="javascript:reloadForm('No',page.value,this.value,layout.value,mandate.value,mission.value,'x','x')">
     <OPTION value="PostOrder" <cfif #URL.Sort# eq 
"PostOrder">selected</cfif>>Group by Post grade
  <OPTION value="PostClass" <cfif #URL.Sort# eq 
"PostClass">selected</cfif>>Group by Post class
	 <option value="Posttype" <cfif #URL.Sort# eq 
"Posttype">selected</cfif>>Group by Posttype
     <OPTION value="OrgUnit" <cfif #URL.Sort# eq 
"OrgUnit">selected</cfif>>Group by Organization
	 <OPTION value="DateExpiration" <cfif #URL.Sort# eq 
"DateExpiration">selected</cfif>>Group by Expiration date
</SELECT>&nbsp;

   <select name="layout" size="1" style="background: #C9D3DE;"
onChange="javascript:reloadForm('No',page.value,sort.value,this.value,mandate.value,mission.value,'x','x')">
     <OPTION value="Listing" <cfif #URL.Lay# eq 
"Listing">selected</cfif>>Listing
	 <option value="Current" <cfif #URL.Lay# eq 
"Current">selected</cfif>>View current assignments
 	 <option value="All" <cfif #URL.Lay# eq 
"All">selected</cfif>>View all assignments
  </SELECT>&nbsp;
  
  
  </td>
   
  </tr>
   </table>
  
  </td>
  
  </tr>
  <td width="100%" colspan="2">
  
  <cfflush>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfif #URL.Sort# eq "OrgUnit">

   <cfinclude template="MandateViewOrganization.cfm">
   
<cfelse>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT P.*, Org.OrgUnitName
  FROM userQuery.dbo.#SESSION.acc#Post P, Organization.dbo.Organization Org
  WHERE P.OrgUnitOperational = Org.OrgUnit 
  AND Org.Mission   = '#URL.Mission#'
  AND Org.MandateNo = '#URL.Mandate#'
  #PreserveSingleQuotes(Cond)#
  <cfif CLIENT.OrgUnit neq "">AND Org.HierarchyRootUnit = '#CLIENT.OrgUnit#'</cfif> 
  ORDER BY #orderby#, P.PositionNo
</cfquery>


<cfif #URL.ID# neq "ORG">
     
   <TR bgcolor="#6688AA">
    <TD width="18%" class="top"></TD>
	<TD class="top">PostNo</TD>
    <TD class="top">Organization</TD>
    <TD class="top">Function</TD>
    <TD class="top">Grade</TD>
    <TD class="top">Posttype</TD>
    <TD class="top">Effective</TD>
    <TD class="top">Expiration</TD>
	<td width="15%" class="top"></td>
   </TR>
   
<cfelse>
   
   <cfswitch expression = #URL.Sort#>
         	 
     <cfcase value="PostOrder">       <cfset sel = "P.PostGrade, P.PostOrder"></cfcase>
     <cfcase value="PostClass">       <cfset sel = "P.PostClass"></cfcase>
     <cfcase value="PostType">        <cfset sel = "P.PostType"></cfcase>
     <cfcase value="DateExpiration">  <cfset sel = "P.DateExpiration"></cfcase>

    </cfswitch>
   
   <!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT #sel#
  FROM userQuery.dbo.#SESSION.acc#Post P
  ORDER BY #orderby#
</cfquery>
 
</cfif> 
   
<cfoutput query="SearchResult" group="#URL.Sort#" startrow=#first# maxrows=#No#>
      
   <tr bgcolor="f6f6f6">

   <cfswitch expression = #URL.Sort#>
     <cfcase value = "SourcePostNumber">
     
     </cfcase>
	 <cfcase value = "PostClass">
     <td colspan="10"><font face="Tahoma" size="2"><b>&nbsp;#PostClass#</b></font></td>
     </cfcase>
     <cfcase value = "PostOrder">
     <td colspan="10"><font face="Tahoma" size="2"><b>&nbsp;#PostGrade#</b></font></td>
     </cfcase>
	  <cfcase value = "Posttype">
     <td colspan="10"><font face="Tahoma" size="2"><b>&nbsp;#Posttype#</b></font></td>
     </cfcase>
	  <cfcase value = "DateExpiration">
     <td colspan="10"><font face="Tahoma" size="2"><b>&nbsp;#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</b></font></td>
     </cfcase>
   </cfswitch>

   </tr>
   
   <cfoutput>
         
   <cfif #URL.ID# eq "ORG">
   
   <cfset cond = "AND Org.OrgUnitCode = '#URL.ID1#'">
   
   <cfswitch expression = #URL.Sort#>
      
    <!--- show results in org structure --->
	 	 
     <cfcase value="PostOrder">   
	      <cfset cond = cond & " AND P.PostGrade = '#PostGrade#'">
	      <cfset condA = " AND P.PostGrade = '#PostGrade#'">
	 </cfcase>
     <cfcase value="PostClass"> 
	      <cfset cond = cond & " AND P.PostClass = '#PostClass#'">
	      <cfset condA = " AND P.PostClass = '#PostClass#'">
	 </cfcase>
     <cfcase value="PostType">  
	      <cfset cond  = cond & " AND P.PostType = '#PostType#'">
		  <cfset condA = " AND P.PostType = '#PostType#'">
	 </cfcase>
     <cfcase value="DateExpiration"> 
	     <cfset cond = cond & " AND P.DateExpiration = '#DateFormat(DateExpiration,client.dateSQL)#'">
    	 <cfset condA = " AND P.DateExpiration = '#DateFormat(DateExpiration,client.dateSQL)#'">
	 </cfcase>

    </cfswitch>
	
	 <cfinclude template="MandateViewOrganization.cfm"> 
	
   <cfelse>
   
     <cfif #DateFormat(Current.DateEffective, CLIENT.DateFormatShow)#	eq #DateFormat(DateEffective, CLIENT.DateFormatShow)#
     and #DateFormat(Current.DateExpiration, CLIENT.DateFormatShow)# eq #DateFormat(DateExpiration, CLIENT.DateFormatShow)#>
        <cfset showpdte = 0>
     <cfelse>
        <cfset showpdte = 1>
     </cfif>
       
     <TR bgcolor="<cfif #PositionStatus# neq '7'>FFFFFF<cfelse>FFFFCF</cfif>">
     <TD class="regular">&nbsp;&nbsp;
     <cfif #Current.MandateStatus# eq "1">
	
	 <a href="javascript:ViewParentPosition('#Mission#','#MandateNo#','#PositionParentId#')" onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/view.jpg'">
         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#positionno#" id="img0_#positionno#" width="14" height="14" border="0" align="middle">
        </a>
			
	 <cfelse>
	
	 <a href="javascript:EditParentPosition('#Mission#','#MandateNo#','#PositionParentId#')" onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/view.jpg'">
         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#positionno#" id="img0_#positionno#" width="14" height="14" border="0" align="middle">
      </a>
		
     </cfif>		
		
     </td>		
	
     <TD class="regular">#SourcePostNumber#</TD>	
     <TD class="regular">#OrgUnitName#</TD>
     <TD class="regular">#FunctionDescription#</TD>
     <TD class="regular">#PostGrade#</TD>
     <TD class="regular">#PostType#</TD>
     <TD class="regular"><cfif showpdte eq 1>#DateFormat(DateEffective, CLIENT.DateFormatShow)#</cfif></TD>
     <TD class="regular"><cfif showpdte eq 1>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</cfif></TD>
       <TD class="regular">&nbsp;&nbsp;
   
     <!--- <cfif #PositionStatus# neq '7'> --->
     <A HREF ="javascript:AddPosition('#Mission#','#MandateNo#','#OrgUnitOperational#','#FunctionNo#','#Posttype#','#PostGrade#','#LocationCode#')"><img src="#SESSION.root#/Images/copy.jpg" alt="" width="17" height="13" border="0" align="middle">
     </A>
     <!--- </cfif> --->
      
     <A HREF ="javascript:AddAssignment('#PositionNo#')"><img src="#SESSION.root#/Images/insert.jpg" alt="" width="17" height="13" border="0" align="middle"></a>
   
     <cfif Current.MandateStatus eq "0">
        <input type="checkbox" name="Position" value="#PositionParentId#">
     </cfif>
   
     </TD>
 
     </TR>
   
     <cfif #PositionParentId# neq "">
   
     <cfquery name="Parent" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT FunctionDescription, Org.OrgUnitName
      FROM PositionParent A, Organization.dbo.Organization Org
      WHERE A.PositionParentId = #PositionParentId#
	  AND   A.OrgUnitOperational = Org.OrgUnit 
     </cfquery>	
   
     <cfif #Parent.FunctionDescription# neq #FunctionDescription# or
       Parent.OrgUnitName neq OrgUnitName>
	   
     <tr bgcolor="EAF4FF">
     <td colspan="2" class="regular"></td>
     <td colspan="1" class="regular">Borrowed from:</TD>	
     <TD colspan="2" class="regular"><A HREF ="javascript:EditPost('#PositionNo#')"><b>#Parent.OrgUnitName#</b></A></TD>
     <td colspan="5" class="regular"><b>#Parent.FunctionDescription#</b></td>
     </TR>	   
   
     </cfif>
     </cfif>
      
     <cfif URL.Lay eq "Current">
         
     <cfquery name="Assignment" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT A.*, P.*, O.OrgUnitCode, O.OrgUnitName 
      FROM PersonAssignment A, Person P, Organization.dbo.Organization O
      WHERE A.PositionNo = #SearchResult.PositionNo#
   	  AND A.PersonNo = P.PersonNo
	  AND A.OrgUnit = O.OrgUnit
	  AND (A.DateExpiration is null or A.DateExpiration > #DateFormat(now(), CLIENT.DateSQL)#)
	  AND A.AssignmentStatus < '#Parameter.AssignmentShow#'
	  ORDER BY A.DateExpiration DESC
     </cfquery>
   
     <cfset #FunctionNoC# = #SearchResult.FunctionNo#>

     <cfloop query="Assignment">
   
     <tr bgcolor="FFFFE1"><td colspan="9">
	 <table width="100%" border="0">
	 <tr>
       <td width="5%"></td>
       <td width="5%"></td>
       <td width="10%" align="left" class="regular"><A HREF ="javascript:EditPerson('#PersonNo#')">#IndexNo#</A></td>
       <TD width="25%" align="left" class="regular"><A HREF ="javascript:EditPerson('#PersonNo#')">#FirstName# #LastName#</A></TD>
       <td width="10%" align="left" class="regular">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
       <td width="10%" align="left" class="regular">#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>
	   <TD width="20%" align="left" class="regular"><cfif #FunctionNo# neq #FunctionNoC#>#FunctionDescription#</cfif></TD>
	   <TD width="20%" align="left" class="regular"><cfif #OrgUnit# neq #SearchResult.OrgUnitOperational#>#SearchResult.OrgUnitOperational# #OrgUnitName#</cfif></TD>
		<TD width="12%"><cfif #Current.MandateStatus# eq "0">
         <input type="checkbox" name="AssignmentNo" value="#AssignmentNo#">
     </cfif></TD>
	 </tr>
	 </table>
	 </td>
     </tr>
	 
     
     </cfloop> 
  
     </cfif>
	 
	 </cfif>
   
   </cfoutput>
    
  </CFOUTPUT>

</TABLE>

</td></tr>

</cfif>

<tr bgcolor="#C9D3DE">

<td colspan="6">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<td height="30" colspan="1" align="left" valign="middle">
&nbsp;
<input type="submit" name="Refresh" value="Refresh" class="button3" onClick="javascript: window.reload()">&nbsp;
</td>

<td height="30" colspan="1" align="right" valign="middle">
&nbsp;
<input type="submit" name="Duplicate" value="Duplicate" class="button3">&nbsp;
<cfif #Current.MandateStatus# eq "0">
 <input type="submit" name="Purge" value="&nbsp;&nbsp;Remove&nbsp;&nbsp;" class="button3" onClick="javascript: return Process('purge')">&nbsp;
</cfif>
&nbsp;
</td>
</table>
</td>
</tr>

</table>

</td></tr>

</Table>

</form>

<script>

document.result.stopscroll.focus()
<!--- window.scrollBy(0,400) --->

</script>

</BODY></HTML>

   
</cfif> 
