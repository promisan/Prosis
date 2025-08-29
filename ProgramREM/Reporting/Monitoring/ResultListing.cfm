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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="CLIENT.Sort" default="HierarchyCode">
<cfif #CLIENT.Sort# neq "HierarchyCode">
	  <cfset deleted = deleteClientVariable("Sort")>
</cfif>   
<cfparam name="CLIENT.Sort" default="HierarchyCode">
<cfparam name="URL.Sort" default="#CLIENT.Sort#">
<cfparam name="URL.Lay" default="Main">
<cfparam name="URL.ID2" default="">
<cfparam name="URL.ID3" default="All">

<cfparam name="URL.page" default="1">
<cfset #CLIENT.sort# = #URL.Sort#>

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

function reloadForm(page,sort,layout)

{
        window.location="ResultListing.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&Page=" + page + "&Sort=" + sort + "&Lay=" + layout;
}


function archive()

{

if (confirm("Do you want to archive this result ?")) {

window.location = "ResultArchive.cfm?ID=<cfoutput>#URL.ID1#</cfoutput>"

   	}
	{return false}
}


function process()

{

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
<cfset condDetails = "">

<cfswitch expression="#URL.ID#">

<cfcase value="ORG">
 <cfset #URL.ID2# neq "">
 <cfset cond = "AND M.OrgUnit = '#URL.ID2#'">
 <cfif #URL.ID3# neq "All">
     <cfset cond = cond & " AND Pe.Period = '#URL.ID3#'">
	 <cfset condDetails = condDetails & " AND Pe.Period = '#URL.ID3#'">
 </cfif>
</cfcase>

</cfswitch>

<cfswitch expression = #URL.Sort#>
     	 
     <cfcase value="HierarchyCode">  
	 	<cfset orderby = "O.HierarchyCode">
	</cfcase>
    
</cfswitch>
  
<!--- Query returning search results --->
   
<cfquery name="SearchResult" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT   DISTINCT Pe.ProgramCode, 
                    P.ProgramName, 
					Pe.Period, 
					Pe.Reference, 
					Pe.OfficerFirstName, 
                    Pe.OfficerLastName, 
					Pe.Created, 
					O.OrgUnitName, 
					O.HierarchyCode, 
					Pe.PeriodHierarchy, 
					P.ProgramClass
  FROM     ProgramSearchResult R, 
           ProgramPeriod Pe, 
	       Program P, 
	       Organization.dbo.Organization O, 
	       Organization.dbo.Organization M
  WHERE    R.SearchId = #URL.ID1#
  AND      R.ProgramId = Pe.ProgramId
  AND      Pe.ProgramCode = P.ProgramCode
  AND      Pe.OrgUnit = O.OrgUnit
  AND      P.ProgramScope = 'Unit'
  AND      O.HierarchyRootUnit = M.OrgUnitCode
  AND      O.MandateNo         = M.MandateNo 
  AND      O.Mission           = M.Mission
           #PreserveSingleQuotes(cond)#
  ORDER BY #orderby#		 
</cfquery>

<HTML><HEAD>
    <TITLE>Inquiry - Search Result</TITLE>

</HEAD><body leftmargin="4" topmargin="4" rightmargin="2" onLoad="javascript:document.forms.result.page.focus();">

<form method="post" name="result">

<input type="hidden" name="ID" value="<cfoutput>#URL.ID#</cfoutput>">
<input type="hidden" name="ID1" value="<cfoutput>#URL.ID1#</cfoutput>">
<input type="hidden" name="ID2" value="<cfoutput>#URL.ID2#</cfoutput>">
<input type="hidden" name="ID3" value="<cfoutput>#URL.ID3#</cfoutput>">
<input type="hidden" name="page1" value="<cfoutput>#URL.Page#</cfoutput>">
<input type="hidden" name="lay" value="<cfoutput>#URL.Lay#</cfoutput>">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="gray" rules="rows">
  <tr>
    <td height="26" bgcolor="<cfoutput>#client.color#</cfoutput>">&nbsp;
    	<cfoutput>
		Search: <b>#SearchAction.OfficerFirstName# #SearchAction.OfficerLastName#</b> &nbsp;Date: <b>#DateFormat(SearchAction.Created)#</b>
    	</cfoutput>
	</td>
	<td align="right" bgcolor="<cfoutput>#client.color#</cfoutput>">
	
	<input type="hidden" name="searchid" value="<cfoutput>#URL.ID1#</cfoutput>">
	
   <!--- drop down to select only a number of record per page using a tag in tools --->	
       <cfinclude template="../../../Tools/PageCount.cfm">
       <select name="page" size="1" style="background: #002350; color: Menu;"
        onChange="javascript:reloadForm(this.value,sort.value,layout.value,searchid.value)">
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
    <cfoutput>Name: <b>#SearchAction.Description#</b> &nbsp;Matching programs/components: <b>#SearchResult.recordcount#</b> </cfoutput>
  </td>
    
  <td align="right">
  <select name="sort" size="1" style="background: #C9D3DE;"
onChange="javascript:reloadForm(page.value,this.value,layout.value,searchid.value)">
     <OPTION value="HierarchyCode" <cfif #URL.Sort# eq 
"HierarchyCode">selected</cfif>>Group by Organization
  </select>
	 &nbsp;

   <select name="layout" size="1" style="background: #C9D3DE;"
onChange="javascript:reloadForm(page.value,sort.value,this.value,searchid.value)">
     <OPTION value="Main" <cfif #URL.Lay# eq "Main">selected</cfif>>Programs
	 <option value="Details" <cfif #URL.Lay# eq "Details">selected</cfif>>Details
 </select>
 	 &nbsp;
   </td>
   </tr>
   </table>
  </td>
  </tr>
  <td width="100%" colspan="2">

  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

  <TR>
    <td width="4%" class="top4n"></td>
    <TD width="8%" class="top4n">Code</TD>
    <td width="32%" colspan="3" class="top4n">Name</td>
    <TD width="27%" class="top4n">Organization</TD>
    <TD width="20%" class="top4n">Entered by</TD>
    <TD width="10%" class="top4n">Initated</TD>
  </TR>
  <tr><td height="1" colspan="8" class="top2"></td></tr>
     
<cfset currrow = 0>   
   
<cfoutput query="SearchResult" group="#URL.Sort#" startrow="#first#" maxrows="#No#">

<cfoutput>
  
	<TR>
		<td height="22" align="center"> 
		<a href="javascript:EditProgram('#SearchResult.ProgramCode#','#SearchResult.Period#', '#SearchResult.ProgramClass#')" 
		     onMouseOver="document.img0_#currentrow#.src='<cfoutput>#SESSION.root#</cfoutput>/images/button.jpg'" 
		     onMouseOut="document.img0_#currentrow#.src='<cfoutput>#SESSION.root#</cfoutput>/images/locate.JPG'">
		         <img src="<cfoutput>#SESSION.root#</cfoutput>/images/locate.JPG" alt="" name="img0_#currentrow#" width="15" height="15" border="0" align="middle">
		    </a></td>
		</TD>
		<TD><A HREF ="javascript:EditProgram('#SearchResult.ProgramCode#','#SearchResult.Period#','#SearchResult.ProgramClass#')">&nbsp;#SearchResult.ProgramCode#</A></TD>
		<TD colspan="3"><A HREF ="javascript:EditProgram('#SearchResult.ProgramCode#','#SearchResult.Period#','#SearchResult.ProgramClass#')">#SearchResult.ProgramName#</A></TD>
		<td>#OrgUnitName#</td>
		<TD>#SearchResult.OfficerFirstName# #SearchResult.OfficerLastName#</TD>
		<TD>#DateFormat(SearchResult.Created, CLIENT.DateFormatShow)#&nbsp;&nbsp;</TD>
    </TR>
	
	<cfif URL.Lay eq "Details">
	
		<cfquery name="Detail" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Program P, ProgramPeriod Pe 
		  WHERE    P.ProgramCode = Pe.ProgramCode
		  AND      PeriodHierarchy LIKE '#PeriodHierarchy#.%'
		  AND      P.ProgramScope = 'Unit'  
		  #PreserveSingleQuotes(condDetails)# 
		  ORDER BY PeriodHierarchy		
		</cfquery>
		
		<cfloop query="Detail">
		
		<TR bgcolor="ffffcf">
		<td height="22" align="center"> 
		<a href="javascript:EditProgram('#Detail.ProgramCode#','#Detail.Period#', '#Detail.ProgramClass#')" 
		     onMouseOver="document.img0_#currentrow#.src='<cfoutput>#SESSION.root#</cfoutput>/images/button.jpg'" 
		     onMouseOut="document.img0_#currentrow#.src='<cfoutput>#SESSION.root#</cfoutput>/images/join.gif'">
		         <img src="<cfoutput>#SESSION.root#</cfoutput>/images/join.gif" alt="" name="img0_#currentrow#" width="15" height="15" border="0" align="middle">
		    </a></td>
		</TD>
		<TD><A HREF ="javascript:EditProgram('#SearchResult.ProgramCode#','#SearchResult.Period#','#Detail.ProgramClass#')">&nbsp;#Detail.ProgramCode#</A></TD>
		<TD colspan="3"><A HREF ="javascript:EditProgram('#SearchResult.ProgramCode#','#SearchResult.Period#','#Detail.ProgramClass#')">#Detail.ProgramName#</A></TD>
		<td></td>
		<TD>#Detail.OfficerFirstName# #SearchResult.OfficerLastName#</TD>
		<TD>#DateFormat(Detail.Created, CLIENT.DateFormatShow)#&nbsp;&nbsp;</TD>
       </TR>
		</cfloop>
		
	</cfif>
	
	<!--- <cfinclude template="OutputResults.cfm"> --->
	
	<!--- End new block --->
		
	<tr><td height="1" class="line" colspan="8"></td></tr>
		
	</cfoutput>
	
	</cfoutput>
	
</TABLE>

</td></tr>

<tr bgcolor="#C9D3DE">

<td colspan="5">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<td height="30" colspan="1" align="left" valign="middle">
	&nbsp;
	<input type="button" name="Refresh" value="Refresh" class="button3" onClick="javascript:location.reload()">
	<cfif #SearchAction.Status# neq "0">
	<input type="button" name="Remove" value="Remove" class="button3" onClick="javascript:process()">
	<cfelse>
	<input type="button" name="Archive" value="Archive" class="button3" onClick="javascript:archive()">
	</cfif>
	
	&nbsp;
	</td>
	
	<td height="30" colspan="1" align="right" valign="middle">
	</td>
</table>

</td>
</tr>

</table>

</td></tr>

</Table>

</form>

<cf_waitEnd>


</BODY></HTML>