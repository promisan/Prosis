
<cf_screentop height="100%" scroll="no" html="No" jQuery="Yes">

<cfparam name="CLIENT.Sort" default="Gender">

<cfif CLIENT.Sort neq "Continent" and
      CLIENT.Sort neq "Gender" and
      CLIENT.Sort neq "LastName" and
	  CLIENT.Sort neq "DOB">
	  <cfset deleted = deleteClientVariable("Sort")>
	  
</cfif>   

<cfparam name="CLIENT.Sort" default="Gender">
<cfparam name="URL.Sort" default="#CLIENT.Sort#">
<cfparam name="URL.Lay" default="Listing">
<cfset condA = "">

<cfparam name="URL.page" default="1">
<cfset CLIENT.sort = URL.Sort>

<cfquery name="SearchAction" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   PersonSearch
  WHERE  SearchId = '#URL.ID1#'
</cfquery>
 
   <cfoutput>

<script>

function reloadForm(page,sort,layout,mandate,mission) {
        window.location="ResultListing.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&Page=" + page + "&Sort=" + sort + "&Lay=" + layout + "&SearchId=" + mandate;
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
	 itm.className = "highLight2 labelmedium";
	 }else{		
     itm.className = "regular labelmedium";		
	 }
  }

</script>	
</cfoutput>

<cf_dialogStaffing>

<cfset cond = "">

<cfswitch expression="#URL.ID#">

<cfcase value="GEN">
 <cfif URL.ID2 neq "B">
     <cfset cond = "AND A.Gender = '#URL.ID2#'">
 </cfif>
</cfcase>
<cfcase value="CON">
<cfif URL.ID2 neq "All">
     <cfset cond = "AND N.Continent = '#URL.ID2#'">
 </cfif>
</cfcase>
<cfcase value="COU"><cfset cond = "AND N.Code = '#URL.ID2#'"></cfcase>

</cfswitch>
  
   <cfswitch expression = #URL.Sort#>
         	 
     <cfcase value="Continent">  <cfset orderby = "N.Continent, A.Nationality"></cfcase>
     <cfcase value="Gender">     <cfset orderby = "A.Gender"></cfcase>
     <cfcase value="LastName">   <cfset orderby = "A.LastName, A.FirstName"></cfcase>
     <cfcase value="BirthDate">  <cfset orderby = "A.BirthDate"></cfcase>

    </cfswitch>
   
   <!--- Query returning search results --->
	 
	<cfquery name="Total" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT count(*) as Total
	     FROM   PersonSearchResult R, Person A, System.dbo.Ref_Nation N
	     WHERE  R.PersonNo = A.PersonNo
	     AND    A.Nationality = N.Code
	     AND    R.SearchId = #URL.ID1#
		#PreserveSingleQuotes(cond)#  
	</cfquery>

<cf_pagecountN show="100" 
    count="#Total.Total#">
			     
   <cfquery name="SearchResult" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT    TOP #last# A.*, N.Continent
	  FROM      PersonSearchResult R, Person A, System.dbo.Ref_Nation N
	  WHERE     R.PersonNo = A.PersonNo
	  AND       A.Nationality = N.Code
	  AND       R.SearchId = #URL.ID1#
	  #PreserveSingleQuotes(cond)#
	  ORDER BY  #orderby#
	</cfquery>			   
				   
<cfset counted  = total.total>		

<form method="post" name="result" style="height:99%">

<table width="99%" height="100%" align="center">

<tr><td height="3"></td></tr>

<input type="hidden" name="ID" value="<cfoutput>#URL.ID#</cfoutput>">
<input type="hidden" name="ID1" value="<cfoutput>#URL.ID1#</cfoutput>">
<input type="hidden" name="ID2" value="<cfoutput>#URL.ID2#</cfoutput>">
<input type="hidden" name="page1" value="<cfoutput>#URL.Page#</cfoutput>">
<input type="hidden" name="lay" value="<cfoutput>#URL.Lay#</cfoutput>">
  
<tr>
    <td height="21" class="labelmedium">
	
    	<cfoutput>
		Search: <b>#SearchAction.OfficerFirstName# #SearchAction.OfficerLastName#</b> &nbsp;Date: <b>#DateFormat(SearchAction.Created)#</b>
    	</cfoutput>
	   		
	</td>
	
	<td align="right"></TD>
 
  </tr>
   
  <tr><td height="1" colspan="2" class="line"></td></tr>
  
  <tr><td height="3"></td></tr>
  
  <tr>
      
  <td colspan="2">
  
  <table width="100%" border="0" bgcolor="#ffffff">
    
  <tr>
  <td class="labelmedium">

  <cfoutput>Name: <b>#SearchAction.Description#</b> &nbsp;<cf_tl id="Matching candidates">: <b>#Total.total#</b> </cfoutput>
   
  </td>
    
  <td align="right" height="40">
  
     <table class="formspacing"><tr><td>

	  <select name="sort" size="1" class="regularxl" onChange="javascript:reloadForm(page.value,this.value,layout.value,searchid.value)">
        <OPTION value="Gender" <cfif URL.Sort eq "Gender">selected</cfif>><cf_tl id="Group by Gender">
	    <OPTION value="Continent" <cfif URL.Sort eq "Continent">selected</cfif>><cf_tl id="Group Continent">
	    <option value="BirthDate" <cfif URL.Sort eq "BirthDate">selected</cfif>><cf_tl id="Order by DOB">
        <OPTION value="LastName" <cfif URL.Sort eq "LastName">selected</cfif>><cf_tl id="Order by Name"></select>
	 
	 </td><td>
   
       <select name="layout" size="1" class="regularxl" onChange="javascript:reloadForm(page.value,sort.value,this.value,searchid.value)">
         <OPTION value="Listing" <cfif URL.Lay eq "Listing">selected</cfif>><cf_tl id="Listing">
	     <option value="Contract" <cfif URL.Lay eq "Contract">selected</cfif>><cf_tl id="Current contract">
     	 <option value="Assignment" <cfif URL.Lay eq "Assignment">selected</cfif>><cf_tl id="Current Assignment">
  	   </select>
 	 
	 </td>
	 
	  <td>
	 	 
	   <input type="hidden" name="searchid" class="regularxl" value="<cfoutput>#URL.ID1#</cfoutput>">		
       <select name="page" size="1" class="regularxl"
        onChange="javascript:reloadForm(this.value,sort.value,layout.value,searchid.value)">
        <cfloop index="Item" from="1" to="#pages#" step="1">
           <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>><cf_tl id="Page">#Item# <cf_tl id="of"> #pages#</option></cfoutput>
        </cfloop>	 
      </SELECT> 
	  
	  </td></tr>
	  
	  </table>
    
  </td>
   
  </tr>
   </table>
  
  </td>
  
  </tr>  
  
  <tr>
 
  <td width="100%" height="100%" colspan="2">
  
<cf_divscroll>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr><td colspan="10">
	<cfif URL.Page eq "1">
	
	    <cfswitch expression="#URL.ID3#">
		<cfcase value="GEN">
	    	<cfinclude template="PieGender.cfm">
		</cfcase>
		<cfcase value="CON">
	    	<cfinclude template="PieContinent.cfm">
		</cfcase>
		<cfcase value="COU">
	    	<cfinclude template="PieCountry.cfm">
		</cfcase>
		</cfswitch>
	   
	</cfif>
	</td></tr>
			 
	<tr class="labelmedium fixrow">
       <td height="20"></td> 
       <td><cf_tl id="Last Name"></td>
	   <td><cf_tl id="First Name"></td>
	   
	   <td><cf_tl id="DOB"></td>
	   <td><cf_tl id="Sex"></td>
	   <td><cf_tl id="Nat"></td>
	   <td><cfoutput>#client.IndexNoName#</cfoutput></td>
	   <td><cf_tl id="Created"></td>
	   <td></td>
   </tr>
   
   <tr class="labelmedium fixrow2"><td height="3" colspan="9">
	   <cfinclude template="ResultListingNavigation.cfm">
	</td></tr>
      
   <tr><td colspan="9"></td></tr>
	     
	<cfset currrow = 0>   
	
	<cfif first eq "0">
		<cfset first = "1">
	</cfif>
	   
	<cfoutput query="SearchResult" group="#URL.Sort#" startrow="#first#">
	 
	   <cfswitch expression = "#URL.Sort#">
	    
		 <cfcase value = "Gender">
		 <tr>
	     <td colspan="10" height="20"><font face="Verdana"><b>&nbsp;<cfif #Gender# eq "M"><cf_tl id="Male"><cfelse><cf_tl id="Female"></cfif></b></font></td>
		 </tr>
	     </cfcase>
	     <cfcase value = "Continent">
		 <tr>
	     <td colspan="10" height="20"><font face="Verdana"><b>&nbsp;#Continent#</b></font></td>
		 </tr>
	     </cfcase>
		 
	   </cfswitch>
	      
	   <cfoutput>
	      
	   <cfset currrow = currrow + 1>
	
	   <cfif currrow lte No>
	          
	     <TR class="navigation_row labelmedium" style="height:20px">
	     <TD width="40" align="center">#currentrow#.</td>		
	     <TD><a class="navigation_action" href="javascript:EditPerson('#PersonNo#')">#LastName#</a></TD>	
	     <TD>#FirstName# #MiddleName#</TD>
	     <TD>#DateFormat(BirthDate, CLIENT.DateFormatShow)#</TD>
	     <TD>#Gender#</TD>
		 <TD>#Nationality#</TD>
	     <TD>#IndexNo#</TD>
	     <TD>#DateFormat(Created, CLIENT.DateFormatShow)#</TD>
	     <TD>
		    <input type="checkbox" name="select" value="#PersonNo#" onClick="hl(this,this.checked)">
	     </TD>
	     </TR>
	       
	     <cfif URL.Lay eq "Function">
		 
		 <tr class="line">		
		 <td colspan="10">
		    
	     <cfquery name="Function" 
	      datasource="AppsSelection" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
		  SELECT S.SubmissionEdition, F1.FunctionId, F.FunctionDescription, R.OrganizationCode, 
	             R.OrganizationDescription, R.HierarchyOrder,
	             A.Status, A.FunctionJustification, S.ApplicantNo
	      FROM   ApplicantSubmission S,
	             ApplicantFunction A, 
	             FunctionTitle F, 
	      	     FunctionOrganization F1, 
		         Ref_Organization R
	      WHERE  S.PersonNo = '#PersonNo#'
	       AND   S.ApplicantNo = A.ApplicantNo
	       AND   A.FunctionId = F1.FunctionId
	       AND   F1.FunctionNo = F.FunctionNo
	       AND   R.OrganizationCode = F1.OrganizationCode
	     ORDER BY S.SubmissionEdition, R.HierarchyOrder 
		 
		 </cfquery>
	   
		     <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="6688AA" bgcolor="F0FEFF" style="border-collapse">
		     <tr><td width="100%">
			     <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="111111" width="100%">
			     <TR bgcolor="6688aa">
			        <td height="1" colspan="5"></td>
			     </TR>
				 <cfloop query="Function">
				     
			         <TR><td width="20%" class="labelit">&nbsp;#SubmissionEdition#</td>
			             <td width="30%" class="labelit">&nbsp;#OrganizationDescription#</td>
			           	 <TD width="40%" class="labelit">#FunctionDescription#</TD>
			             <TD class="regular"></TD>
			   	         <td width="10%" align="center" class="labelit">#Status#</td>
					  </TR>
			     </cfloop>
			     <TR>
			        <td class="line" colspan="5"></td>
			     </TR>
			     </table>
		     </td>
		     </table>
		 
		 </td></tr>
		 
	     </cfif>
		 
		 </cfif>
		 
		 <tr><td height="1" colspan="10" class="line"></td></tr>
		   
	   </cfoutput>
	    
	</CFOUTPUT>
  
	

</table>

</cf_divscroll>

</td></tr>

<tr>
	
	<td colspan="10">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<td height="40" colspan="1" align="left" valign="middle">
		&nbsp;
		<cfoutput>	
		<cf_tl id="Refresh" var="1"> 
		<input type="button" name="Refresh" value="#lt_text#" class="button10g" onClick="javascript:location.reload()">
		<cfif #SearchAction.Status# neq "0">
		<cf_tl id="Remove" var="1">
		<input type="button" name="Remove" value="#lt_text#" class="button10g" onClick="javascript:process()">
		<cfelse>
		<cf_tl id="Archive" var="1">
		<input type="button" name="Archive" value="#lt_text#" class="button10g" onClick="javascript:archive()">
		</cfif>
		</cfoutput>
		&nbsp;
		</td>
	
	    <td height="30" colspan="1" align="right" valign="middle">
		<cfoutput>
		 <cf_tl id="Save Selection" var="1">
		 <!---
	     <input type="button" name="Add" value="#lt_text#" class="button10g" onClick="javascript:info()">
		 --->
		</cfoutput>	 
	     </td>
	     </table>

	</td>
	</tr>

	<tr><td height="3" colspan="10">

	   <cfinclude template="ResultListingNavigation.cfm">
   
	    </td>
	</tr>

</table>

</form>

<cfset AjaxOnLoad("doHighlight")>	