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
    <TITLE>Result Listing</TITLE>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="CLIENT.Sort" default="HierarchyCode">
<cfif #CLIENT.Sort# neq "HierarchyCode">
	  <cfset deleted = deleteClientVariable("Sort")>
</cfif>   
<cfparam name="CLIENT.Sort" default="HierarchyCode">
<cfparam name="URL.Sort" default="#CLIENT.Sort#">
<cfparam name="URL.Lay" default="Programs">
<cfparam name="URL.ID2" default="All">
<cfparam name="URL.ID3" default="All">
<cfparam name="URL.page" default="1">

<cfset CLIENT.sort = URL.Sort>

<cfquery name="SearchAction" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM ProgramSearch
  WHERE SearchId = '#URL.ID1#'
</cfquery>

<cf_wait Text="Loading programs">
 
<cfoutput>

<script>

function reloadForm(page,sort,layout) {
        window.location="ResultListing.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&Page=" + page + "&Sort=" + sort + "&Lay=" + layout;
}

function excel(page,sort,layout) {
        window.location="ResultListingExcel.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&Page=" + page + "&Sort=" + sort + "&Lay=" + layout;
}


function archive() {

if (confirm("Do you want to archive this result ?")) {

window.location = "ResultArchive.cfm?ID=<cfoutput>#URL.ID1#</cfoutput>"

   	}
	{return false}
}


function process() {

if (confirm("Do you want to delete this result ?")) {

window.location = "ResultProcess.cfm?ID1=#URL.ID1#"

   	}
	{return false}
}

function info()

{ alert("Under development") }


ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 }else{
		
     itm.className = "regular";		
	 }
  }


</script>	
</cfoutput>

<cf_dialogREMProgram>

<cfset cond = "">
<cfset PAcond = "">

<cfswitch expression="#URL.ID#">

<cfcase value="ORG">
	<cfif #URL.ID2# neq "All">
	 	<cfset cond = "AND M.OrgUnit = '#URL.ID2#'">
	</cfif> 
	<cfif #URL.ID3# neq "All">
     	<cfset cond = cond & " AND Pe.Period = '#URL.ID3#'">
     	<cfset PAcond = "AND Pa.ActivityPeriod = '#URL.ID3#'">
	</cfif>
</cfcase>

</cfswitch>

<cfset orderby = "M.HierarchyCode">

<cfswitch expression = #URL.Sort#>
     	 
     <cfcase value="HierarchyCode">  
	     <cfset orderby = "M.HierarchyCode">
	 </cfcase>
    
</cfswitch>
  
<!--- Query returning search results --->

<cfquery name="SearchResultA" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT R.ProgramId
  FROM ProgramSearchResult R, ProgramPeriod Pe, Program P, Organization.dbo.Organization O, Organization.dbo.Organization M
  WHERE R.SearchId          = #URL.ID1#
  AND   R.ProgramId         = Pe.ProgramId
  AND   Pe.ProgramCode      = P.ProgramCode
  AND   Pe.OrgUnit          = O.OrgUnit
  AND   O.HierarchyRootUnit = M.OrgUnitCode
  AND   O.MandateNo         = M.MandateNo
  AND   O.Mission           = M.Mission
        #PreserveSingleQuotes(cond)#
     </cfquery>
	 
<cfset ProgressWhere = "">
	 
<!--- Progress Dates --->
<cfquery name="SelectProgressDate" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID1#'
		AND SearchClass = 'DateOperator'
</cfquery>

<cfif #SelectProgressDate.recordCount# neq 0 AND #SelectProgressDate.SelectID# neq "ANY">

	<!--- Progress Start Date --->
	<cfquery name="SelectStartDate" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID1#'
		AND SearchClass = 'StartDate'
	</cfquery>
	
<cfset dateValue = "">
 <CF_DateConvert Value="#SelectStartDate.SelectID#">
 <cfset STARTDTE = #dateValue#>

	<!--- Progress End Date --->
	<cfquery name="SelectEndDate" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID1#'
		AND SearchClass = 'EndDate'
	</cfquery>

 <cfset dateValue = "">
 <CF_DateConvert Value="#SelectEndDate.SelectID#">
 <cfset ENDDTE = #dateValue#>

   <cfset ProgressWhere = #ProgressWhere# & " AND Pp.Created BETWEEN #STARTDTE# AND #ENDDTE#">

</cfif>

<!--- progress status --->
<cfquery name="SelectStatus" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID1#'
		AND SearchClass = 'Status'
</cfquery>

<cfif #SelectStatus.recordCount# neq 0>
	<cfset ProgressWhere = #ProgressWhere# & " AND Pp.ProgressStatus = '#SelectStatus.SelectId#'">	
<cfelse>
	<cfset ProgressWhere = #ProgressWhere# & " AND Pp.ProgressStatus != 0">	
</cfif>   

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#ProgressResults">


<!--- KEN please review this query for the orgunit, I am not sure what you try to do here, maybe you can simplify it. --->

<cfquery name="ProgressResults" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	Select Pp.*, P.ParentCode, M.OrgUnit
    INTO  userQuery.dbo.tmp#SESSION.acc#ProgressResults	
    FROM  Program P, ProgramActivity Pa, ProgramActivityOutput Po, ProgramActivityProgress Pp,
	      Organization.dbo.Organization O, Organization.dbo.Organization M, ProgramPeriod Pe
	WHERE Pp.RecordStatus   != 9
    #PreserveSingleQuotes(ProgressWhere)# 
	AND Pp.OutputID         = Po.OutputID
	AND Po.RecordStatus    != 9
	AND Po.ActivityID       = Pa.ActivityId
	AND Pa.RecordStatus    != 9
	AND Pa.ProgramCode      = Pe.ProgramCode
	AND Pe.RecordStatus 	!= 9
	AND Pe.OrgUnit          = O.OrgUnit
	AND P.ProgramCode 		= Pe.ProgramCode
    AND O.HierarchyRootUnit = M.OrgUnitCode
    AND O.MandateNo         = M.MandateNo
    AND O.Mission           = M.Mission
</cfquery>
	   
<cfquery name="SearchResult" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT Pa.OfficerUserID, Pe.ProgramCode, P.ProgramName, Pe.Period, Pe.Reference, 
  	              Pa.OfficerUserID, Pa.OfficerFirstName, Pa.OfficerLastName, P.Created, M.HierarchyCode
  FROM            userQuery.dbo.tmp#SESSION.acc#ProgressResults Pa, 
                  ProgramSearchResult R, 
  	              ProgramPeriod Pe, 
				  #CLIENT.LanPrefix#Program P, 
				  Organization.dbo.Organization O, 
				  Organization.dbo.Organization M
  WHERE           R.SearchId = '#URL.ID1#'
  AND             R.ProgramId = Pe.ProgramId
  AND             Pe.ProgramCode = P.ProgramCode
  AND             Pe.RecordStatus != 9
  AND	          Pe.OrgUnit = O.OrgUnit
  AND   O.HierarchyRootUnit = M.OrgUnitCode
  AND   O.MandateNo         = M.MandateNo
  AND   O.Mission           = M.Mission
  AND             (P.ParentCode is NULL or P.ParentCode = '')
  		          #PreserveSingleQuotes(cond)#
  AND             Pa.ParentCode = Pe.ProgramCode 
  		          #PreserveSingleQuotes(PAcond)# 
  ORDER BY        Pa.OfficerUserID, #orderby#	
</cfquery>

    
</HEAD><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="javascript:document.forms.result.page.focus();">

<form method="post" name="result">

<input type="hidden" name="ID" value="<cfoutput>#URL.ID#</cfoutput>">
<input type="hidden" name="ID1" value="<cfoutput>#URL.ID1#</cfoutput>">
<input type="hidden" name="ID2" value="<cfoutput>#URL.ID2#</cfoutput>">
<input type="hidden" name="ID3" value="<cfoutput>#URL.ID3#</cfoutput>">
<input type="hidden" name="pagel" value="<cfoutput>#URL.Page#</cfoutput>">
<input type="hidden" name="lay" value="<cfoutput>#URL.Lay#</cfoutput>">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
    <td class="BannerXLN">&nbsp;
	
    	<cfoutput>
		Search: #SearchResult.Recordcount# x <b>#SearchAction.OfficerFirstName# #SearchAction.OfficerLastName#</b> &nbsp;Date: <b>#DateFormat(SearchAction.Created)#</b>
    	</cfoutput>
	   		
	</td>
	
	<td align="right" class="BannerXLN">
	
	<input type="hidden" name="searchid" value="<cfoutput>#URL.ID1#</cfoutput>">
		
<!--- drop down to select only a number of record per page using a tag in tools --->	

<!---   some other time. 
<cfquery name="PageGroup" 
	dbtype="query">
	Select Distinct OfficerUserID 
		From SearchResult
	</cfquery>
	
--->
<!--- Quick fix to display all usernames on one page.  Should really make a PageCountGroup template --->

       <cfinclude template="../../../Tools/PageCount.cfm">
       <select name="page" size="1" style="background: #002350#; color: Menu;"
        onChange="javascript:reloadForm(this.value,sort.value,layout.value,searchid.value)">
        <cfloop index="Item" from="1" to="#pages#" step="1">
           <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
        </cfloop>	 
      </SELECT> &nbsp;  	

    </TD>
 
  </tr>
  
  <tr>
    
  <td colspan="2">
  
  <table width="100%" border="0" bgcolor="#C9D3DE">
    
  <tr>
  
  <td class="regular">&nbsp;

  <cfoutput>
  Name: <b>#SearchAction.Description#</b> &nbsp;Matching programs/components: <b>#SearchResult.recordcount#</b> 
  </cfoutput>
  
  </td>
    
  <td align="right">
  <select name="sort" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(page.value,this.value,layout.value,searchid.value)">
     <OPTION value="OrgUnitCode" <cfif #URL.Sort# eq "OrgUnitCode">selected</cfif>>Group by Organization
  </select>
	 &nbsp;

   <select name="layout" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(page.value,sort.value,this.value,searchid.value)">
     <OPTION value="Users" <cfif #URL.Lay# eq "Users">selected</cfif>>Users
     <OPTION value="Programs" <cfif #URL.Lay# eq "Programs">selected</cfif>>Programs
	 <option value="Components" <cfif #URL.Lay# eq "Components">selected</cfif>>Components
     <OPTION value="Details" <cfif #URL.Lay# eq "Details">selected</cfif>>Details
 </select>
 	 &nbsp;  
  </td>
   
  </tr>
  
  </table>
  
  </td>
   
  </tr>

  <tr>
  <td width="100%" colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<TR bgcolor="#6688AA">
    <td width="3%"></td>
    <td width="32%" colspan="4" class="top">Program Name</td>
    <TD width="8%" class="top"></TD>
    <TD width="27%" class="top"></TD>
    <TD width="20%" class="top"></TD>
    <TD width="10%" class="top">Initated</TD>
</TR>

<!---   <tr><td height="1" colspan="9" class="top2"></td></tr> --->

<!--- <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#KEN">	 --->

<cfset PeriodCond = "">
<cfif #URL.ID3# neq "All">
     	<cfset PeriodCond = "AND Pe.Period = '#SearchResult.Period#' AND Pa.ActivityPeriod = '#SearchResult.Period#'">
</cfif>

<cfset currrow = 0>  

<cfset CurrentOfficer = "">
   
<cfoutput query="SearchResult" startrow=#first# maxrows=#No#>

<!--- display groups by officer, print office name once per group --->

<cfif #CurrentOfficer# neq #OfficerUserID#>

	<cfset OrgCond = "">
	<cfset OrgTables = "">
	<cfif #URL.ID2# neq "All">
	 	<cfset OrgCond = "AND OrgUnit = #URL.ID2#">
</cfif> 

	<cfquery 
	name="Counter"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select Count(*) as UpdatedNum
		From tmp#SESSION.acc#ProgressResults
		Where OfficerUserID='#OfficerUserID#'
	  		#PreserveSingleQuotes(OrgCond)#
	</cfquery>

	<cfset CurrentOfficer = #OfficerUserID#>

<!--- 	<tr><td height="3" colspan="9"></td></tr> --->

	<tr>
		<td colspan="6" height="29" class="TOP3N">&nbsp;<font size=2><b>#OfficerFirstName# #OfficerLastName#</b></font></td>
		<td colspan="2" align="right" class="TOP3N"><b>Progress Reports Entered:</b></td>
		<td class="TOP3N"><b>&nbsp;&nbsp;#Counter.UpdatedNum#</b></td>
	</tr>
   
</cfif>

<cfif #URL.Lay# neq "Users">

	<tr><td height="3" colspan="9"></td></tr>	

	<TR>
		<td width="5%" valign="top" class="regular"> 
		&nbsp;
		<a href="javascript:EditProgram('#SearchResult.ProgramCode#','#SearchResult.Period#', 'Program')" onMouseOver="document.img0_#currentrow#.src='<cfoutput>#SESSION.root#</cfoutput>/images/button.jpg'" onMouseOut="document.img0_#currentrow#.src='<cfoutput>#SESSION.root#</cfoutput>/images/view.JPG'">
		         <img src="<cfoutput>#SESSION.root#</cfoutput>/images/view.JPG" alt="" name="img0_#currentrow#" width="13" height="16" border="0" align="middle">
		    </a></td>
		<TD valign="top" colspan="6" class="regular"><A HREF ="javascript:EditProgram('#SearchResult.ProgramCode#','#SearchResult.Period#','Program')">#SearchResult.ProgramName#</A></TD>
		<TD valign="top" class="regular"></TD>
		<TD valign="top" class="regular">#DateFormat(SearchResult.Created, CLIENT.DateFormatShow)#&nbsp;&nbsp;</TD>
	
	</TR>
	

<!--- Begin new block COMPONENTS--->

<cfif #URL.Lay# neq "Programs">

	<cfquery name="Components" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Distinct P.ProgramCode, 
	       P.ProgramName, 
		   P.ListingOrder, 
		   (SELECT OrgUnitName 
		    FROM Organization.dbo.#CLIENT.LanPrefix#Organization O
			WHERE O.OrgUnit = Pe.OrgUnit) as OrgUnitName		  
		   Pe.Period, 
		   Pe.ProgramId
    From   #CLIENT.LanPrefix#Program P, 
	       ProgramPeriod Pe, 
		   ProgramSearchResult R,
		   userQuery.dbo.tmp#SESSION.acc#ProgressResults Pa
	WHERE  R.SearchId        = #URL.ID1#
	AND    R.ProgramId       = Pe.ProgramId
	AND    Pe.ProgramCode    = P.ProgramCode
	AND    P.ParentCode      = '#SearchResult.ProgramCode#'
	AND	   Pa.ProgramCode    = P.ProgramCode
	AND    Pa.OfficerUserID  = '#CurrentOfficer#'
	AND    Pa.ActivityPeriod = '#SearchResult.Period#'
	AND    Pe.Period         = '#SearchResult.Period#'	
	ORDER BY ListingOrder
	</cfquery>

	
<cfloop query="Components">
   
   <tr bgcolor="f6f6f6">
	<TD width="5%" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;
	     <img src="#SESSION.root#/Images/sub.gif" alt="" width="15" height="15" border="0" align="bottom"></A>&nbsp;&nbsp;
	    </TD>
	<td colspan="6" class="regular"><A HREF ="javascript:EditProgram('#Components.ProgramCode#','#Components.Period#','#ProgramClass#')">&nbsp;&nbsp;&nbsp;&nbsp;#components.ProgramCode# #Components.ProgramName#</A></td>
	<td colspan="2" align="left" class="regular">&nbsp;#OrgUnitName#</td>
     </tr>
	 
	<tr bgcolor="EBEBEB"><td height=1 ColSpan="9"></td></tr>	 
	
<tr><td colspan="9">	

<cfset CurrentProgramCode = #Components.ProgramCode#>

<cfif #URL.Lay# eq "Details">
	<cfinclude template="OutputResults.cfm"> 
</cfif>
	
</td></tr>

<!--- check for missing units
	
	<cfquery name="SubComponents" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  Distinct P.ProgramCode, 
	          P.ProgramName, 
			  P.ListingOrder, 
			  O.OrgUnitName, 
			  Pe.Period, 
			  Pe.ProgramId
    FROM     #CLIENT.LanPrefix#Program P, 
	         ProgramPeriod Pe, 
			 ProgramSearchResult R, 
			 Organization.dbo.#CLIENT.LanPrefix#Organization O, 
			 userQuery.dbo.tmp#SESSION.acc#ProgressResults Pa
	WHERE  R.SearchId         = #URL.ID1#
	AND    R.ProgramId        = Pe.ProgramId
	AND    Pe.ProgramCode     = P.ProgramCode
	AND    P.ParentCode       = '#CurrentProgramCode#'
	AND	   Pa.ProgramCode     = P.ProgramCode
	AND    Pa.OfficerUserID   = '#CurrentOfficer#'
	AND    Pa.ActivityPeriod  = '#SearchResult.Period#'
	AND    Pe.Period          = '#SearchResult.Period#'
	AND    O.OrgUnit          = Pe.OrgUnit
	ORDER BY ListingOrder
  </cfquery>						
			
<cfloop query="SubComponents">
			
   <tr bgcolor="f6f6f6">
	<TD></TD>
	<TD width="5%" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;
		  <img src="#SESSION.root#/Images/sub.gif" alt="" width="15" height="15" border="0" align="bottom">&nbsp;&nbsp;
	    </TD>
	<td colspan="5" class="regular"><A HREF ="javascript:EditProgram('#Components.ProgramCode#','#Components.Period#','#ProgramClass#')">&nbsp;&nbsp;&nbsp;&nbsp;#SubComponents.ProgramName#</A></td>
	<td colspan="2" align="left" class="regular">&nbsp;#SubComponents.OrgUnitName#</td>
     </tr>
	<tr bgcolor="EBEBEB"><td height=1 ColSpan="9"></td></tr>	 
	
<tr><td colspan="9">

<cfif #URL.Lay# eq "Details">
	<cfset CurrentProgramCode = #SubComponents.ProgramCode#>
	<cfinclude template="OutputResults.cfm">
</cfif>		

</td></tr>		
	
 </cfloop> 
	
     
  </cfloop> 
  

	<!--- End new block --->
		
<!---	<tr><td height="1" class="top" colspan="9"></td></tr>
	<tr><td height="2" colspan="9"></td></tr>
--->
</cfif>
	
</cfif>

	
	</cfoutput>
	
<!--	<tr><td height="3" colspan="9"></td></tr> -->
</TABLE>

 </td></tr>

<tr bgcolor="#C9D3DE">

<td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<td height="30" colspan="1" align="left" valign="middle">
	&nbsp;
	<input type="button" name="Refresh" value="Refresh" class="button3" onClick="javascript:location.reload()">
	<cfif #SearchAction.Status# neq "0">
	<input type="button" name="Remove" value="Remove" class="button3" onClick="javascript:process()">
	<cfelse>
	<input type="button" name="Archive" value="Archive" class="button3" onClick="javascript:archive()">
	</cfif>
	<input type="button" name="Excel" value="  Excel  " class="button3" onClick="javascript:excel(page.value,sort.value,layout.value)">
	&nbsp;
	</td>
	
	<td height="30" colspan="1" align="right" valign="middle">
	</td>
</table>

</td>
</tr>

</table>

</td></tr>

</form>

<cf_waitEnd>

</BODY></HTML>