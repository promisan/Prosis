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
<HTML><HEAD>
    <TITLE>Search - Search Result</TITLE>

</HEAD><body>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_dialogStaffing>

<cfparam name="URL.Crit" default="">
<cfparam name="URL.Pages" default="0">

<cfset Criteria = #URL.Crit#>
<cfset list1 = "">
<cfset list2 = "">

<cfif Criteria eq "">

  <cfset tmp = "">

  <cfif #FORM.Criteria1# neq "">

  <!--- separate words based on space, comma, colon --->

  <cfloop index="item" list="#FORM.Criteria1#" delimiters=", ;">

  <cfif tmp eq "">
     <cfset tmp = #item#>
  <cfelse>
     <cfset tmp = #tmp#&" AND "&#item#>
  </cfif> 
  
  <cfset list1 = list1&","&#UCase(item)#>
  <cfset list2 = list2&",<b>"&#UCase(item)#&"</b>">
  
  </cfloop>
  
  <cfif Criteria eq "">
     <cfset criteria = #UCase(tmp)#>
  <cfelse>
     <cfset criteria = #Criteria#&" AND "&#UCase(tmp)#>
  </cfif> 
   

  </cfif>
  
  <!--- full sentence --->
    
  <cfif #FORM.Criteria2# neq ""> <!--- exact match --->

  <cfif Criteria eq "">
     <cfset Criteria = #UCase(FORM.Criteria2)#>
  <cfelse>
     <cfset Criteria = #UCase(Form.Criteria2)#&" AND "&#Criteria#>
  </cfif> 
  
  <cfset list1 = list1&","&#FORM.Criteria2#>
  <cfset list2 = list2&",<b>"&#FORM.Criteria2#&"</b>">

  </cfif>

  <cfif #FORM.Criteria3# neq "">

  <!--- separate words based on space, comma, colon --->

  <cfloop index="item" list="#FORM.Criteria3#" delimiters=", ;">

  <cfif tmp eq "">
     <cfset tmp = #item#>
  <cfelse>
     <cfset tmp = #tmp#&" OR "&#item#>
  </cfif> 
  
  <cfset list1 = list1&","&#UCase(item)#>
  <cfset list2 = list2&",<b>"&#UCase(item)#&"</b>">

  </cfloop>

  <cfif Criteria eq "">
     <cfset criteria = #UCase(tmp)#>
  <cfelse>
     <cfset criteria = #Criteria#&" OR ("&#UCase(tmp)#&")">
  </cfif> 

</cfif>

<cfif #FORM.Criteria4# neq "">

<!--- separate words based on space, comma, colon --->

<cfloop index="item" list="#FORM.Criteria4#" delimiters=", ;">

  <cfif tmp eq "">
     <cfset tmp = #item#>
  <cfelse>
     <cfset tmp = #tmp#&" NOT "&#item#>
  </cfif> 
  
</cfloop>

<cfif Criteria eq "">
     <cfset criteria = " NOT "&#UCase(tmp)#>
  <cfelse>
     <cfset criteria = #Criteria#&" NOT ("&#UCase(tmp)#&")">
  </cfif> 
</cfif>


<cflock name="SearchResult" timeout="120">
   <cfsearch collection="Applicant" 
      name="SearchResult" 
	  type="SIMPLE" 
	  criteria="#Criteria#">
</cflock>

</cfif>

<cfoutput>

</cfoutput>

<cfif Criteria eq "">

   <cflocation url="SearchFullInput.cfm" addtoken="No">

</cfif>

<form action="PersonEntry.cfm" name="result" id="result">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
    <td class="BannerXLN">&nbsp;<b>Search results (background)</td>
	
	<td align="right" class="BannerXLN"><a href="SearchFullInput.cfm"><font color="#FFFFFF">[Advanced search]</font></a></td>

    <td align="right" class="BannerXLN">

<!--- drop down to select only a number of record per page using a tag in tools --->
    <cfif #URL.pages# eq 0>	
       <cfinclude template="../../../Tools/PageCount.cfm">
	   <cfoutput>Total : #Searchresult.recordcount#</cfoutput>
    <cfelse> 
       <cfset Pages = #URL.Pages#> 
	   <cfset first   = ((#URL.Page#-1)*#CLIENT.PageRecords#)+1>
	   <cfset No    = #first# + #CLIENT.PageRecords#>
	   	   
	</cfif>
	<cfoutput>Record : #First# - #No# &nbsp;</cfoutput>
<select name="page" size="1" style="background: #C9D3DE;" 
onChange="javascript:reloadForm(this.value)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
    </cfloop>	 
</SELECT> &nbsp;  

<cfoutput>	

<script>

function reloadForm(page)

{
    window.location="SearchFull.cfm?Page=" + page + "&Crit=#Criteria#&Pages=#Pages#&No=#no#"
}

</script>

</cfoutput>

    </TD>
  
  </tr>
   
  </tr>
  <td width="100%" colspan="3">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<TR class="labelit">
    <TD></TD>
    <TD></TD>
    <TD>Score</TD>
    <TD>Candidate</TD>
	<TD>Organization</TD>
	<TD>Country</TD>
	<TD>From</TD>
	<TD>Until</TD>
	<TD></TD>
	
</TR>

<tr><td colspan="9" class="regular"><b>Search criteria:</b>&nbsp;<cfoutput>#criteria#</cfoutput></td></tr>

<!--- <cflock name="OutputView" timeout="120"> --->
   <cfsearch collection="Applicant" 
      name="OutputView" 
	  type="SIMPLE" 
	  criteria="#Criteria#"
	  startrow="#first#" maxrows="#No#">

<cfoutput query="OutputView">
       
   <TR bgcolor="F6F6F6">
   <td align="center" class="Regular">#CurrentRow+First-1#</td>
   <td width="20" align="center" valign="middle" class="regular">
    <A HREF ="javascript:ShowCandidate('#Custom2#')" 
	onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
	onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/view.jpg'">
         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#currentrow#"  width="14" height="14" border="0" align="middle">
        </a>
	</td>	
		
   <td width="41" class="regular">#NumberFormat(Score*100,"___")#%</A></td>

   <cfquery name="Source" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT ExperienceStart, ExperienceEnd, ExperienceCategory, OrganizationName, OrganizationCountry
    FROM ApplicantBackGround
	WHERE ExperienceId = '#key#'
</cfquery>

   <td class="regular"><A HREF ="javascript:ShowCandidate('#Custom2#')"><b>#Title#</b></A></td>
   <td class="regular">#Source.OrganizationName#</td>
   <td class="regular">#Source.OrganizationCountry#</td>
   <td class="regular">#DateFormat(Source.ExperienceStart,CLIENT.DateFormatShow)#</b></A></td>
   <td class="regular">#DateFormat(Source.ExperienceEnd,CLIENT.DateFormatShow)#</A></td>
   <td class="regular">#Source.ExperienceCategory#</A></td>
   </tr>
      
   <tr><td colspan="3"></td>
   <td colspan="6" valign="top" class="regular">
   #ReplaceList(Summary, list1, list2)#</td>
   
   </TR>
   
   <tr><td height="7" colspan="6" align="center"></td></tr>
      
</CFOUTPUT>

</TABLE>
 
</Table>

<table width="100%">
<tr><td align="right"><img src="<cfoutput>#SESSION.root#</cfoutput>/Images/verity.jpg" alt="" width="178" height="55" border="0"></td></tr>

</table>



<cfif OutputView.recordcount eq 0>

<script>

alert("No candidates found!")
<!--- window.history.back() --->


</script>

</cfif>

<p></p>


</form>

</BODY></HTML>












