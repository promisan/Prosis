
<link href="../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<!--- tools : verify is user is authenticated through login menu --->


<!--- tools : prevent caches, disabled back button --->
<cf_PreventCache>

<HTML>

<HEAD>

<TITLE>Document Listing</TITLE>

</HEAD>

<cfoutput>

<cfset CLIENT.DataSource = "AppsTravel">

<SCRIPT LANGUAGE = "JavaScript">

function showprofile(acc,mis)
{
	window.open("UserActionAdd.cfm?ID=" + acc + "&IDMission=" + mis, "UserAccess", "width=500, height=600, scrollbars=yes, resizable=yes");
}

function reloadForm(area,group,mission,fill)

{
    window.location="AuthorizationListing.cfm?IDArea=" + area + "&IDSorting=" + group + "&IDMission=" + mission + "&IDClass=" + fill;
}

</SCRIPT>	
</cfoutput>

<!--- tools : make available javascript for quick reference to dialog screens --->
<cf_dialogStaffing>

<cfparam name="URL.IDClass"    default="">
<cfparam name="URL.IDArea"     default="">
<cfparam name="URL.IDSorting"  default="Mission">

<!--- dropdown --->
<cfquery name="Class"
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM FlowClass
</cfquery>

<!--- dropdown --->
<cfquery name="Area"
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#"
cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT DISTINCT ActionArea
	FROM FlowAction
</cfquery>

<!--- dropdown select mission for view --->
<cfquery name="mission" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT Mission
FROM Ref_Mission
WHERE MissionStatus = 'Current'
</cfquery>

<cfparam name="URL.IDMission" default="Access all Missions">

<!--- define database filter criteria --->

<cfif #URL.IDMission# neq "">
    <cfset actmission = #URL.IDMission#>
<cfelse>
	<cfset actmission = "%%">
</cfif>

<cfif #URL.IDClass# neq "">
    <cfset actclass = #URL.IDClass#>
<cfelse>
	<cfset actclass = "%%">
</cfif>

<cfif #URL.IDArea# neq "">
    <cfset actarea = #URL.IDArea#>
<cfelse>
	<cfset actarea = "%%">
</cfif>

<cfif #URL.IDSorting# eq "Mission">
   <cfset sort = "A.Mission, F.ActionClass, F.ActionOrderSub">
<cfelse>
   <cfset sort = "A.Mission, U.LastName, U.FirstName, F.ActionOrderSub">
</cfif>   

<cfquery name="SearchResult"
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT     A.Mission, A.UserAccount, F.ActionClass, F.ActionArea, F.ActionDescription, 
              F.ActionOrderSub, U.LastName, U.FirstName, A.Created, U.AccountGroup,
			  C.Description as ActionClassdescription
   FROM       ActionAuthorization A, FlowAction F,System.dbo.UserNames U, FlowClass C
          
   WHERE A.ActionId = F.ActionId
   AND   A.UserAccount = U.Account
   AND   A.Mission = '#URL.IDMission#'
   AND   F.ActionArea LIKE '#actarea#'
   AND   C.ActionClass LIKE '#actclass#'
   AND   F.ActionClass = C.ActionClass
   ORDER BY #sort#
</cfquery>   


<!--- Query returning search results --->

<body class="main" onload="javascript:document.forms.result.mission.focus();">

<form name="result" id="result">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
    <td>
	
	<!--- dropdown to select a different mission --->
    <select name="mission" style="background: #002350; font: larger; color: White;" accesskey="P" title="Status Selection" 
	onChange="javascript:reloadForm(area.value,group.value,this.value,fill.value)">
	
	<option value="All Missions" <cfif "All Missions" is '#URL.IDMission#'>selected</cfif>>
	<font face="Times New Roman" size="4">
	[Access all Missions]
	</font></option>
    <cfoutput query="Mission">
	<option value="#Mission#" <cfif #Mission# is '#URL.IDMission#'>selected</cfif>>
	<font face="Times New Roman" size="4">
	#Mission#
	</font></option>
	</cfoutput>
    </select>
    </td>
    
  <td align="right" class="banner">
  
   
  </td>
  
  </tr> 	
  
  <tr><td width="2"></td>
  
<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
<tr>
<TD bgcolor="#6688AA" height="30">&nbsp;

<!--- drop down to select a action class list --->	
<select name="fill" style="background: #C9D3DE;" accesskey="P" title="Class Selection" 
onChange="javascript:reloadForm(area.value,group.value,mission.value,this.value)">
    <option value="" <cfif '#URL.IDClass#' eq "">selected</cfif>>
	<font face="Tahoma" size="1">
	[All class]
	</font>
	</option>
    <cfoutput query="Class">
	<option value="#ActionClass#" <cfif #ActionClass# is '#URL.IDClass#'>selected</cfif>>
	<font face="Tahoma" size="1">
	#Description#
	</font></option>
	</cfoutput>
    </select>	
	
<!--- drop down to select a action area list --->	
<select name="area" style="background: #C9D3DE;" accesskey="P" title="Area Selection" 
onChange="javascript:reloadForm(this.value,group.value,mission.value,fill.value)">
    <option value="" <cfif '#URL.IDArea#' eq "">selected</cfif>>
	<font face="Tahoma" size="1">
	[All areas]
	</font>
	</option>
    <cfoutput query="Area">
	<option value="#ActionArea#" <cfif #ActionArea# is '#URL.IDArea#'>selected</cfif>>
	<font face="Tahoma" size="1">
	#ActionArea#
	</font></option>
	</cfoutput>
    </select>		

<!--- drop down to order the screen list --->	
<select name="group" size="1" style="background: #C9D3DE;" 
onChange="javascript:reloadForm(area.value,this.value,mission.value,fill.value)">
     <OPTION value="Mission" <cfif #URL.IDSorting# eq "Mission">selected</cfif>>Group by Action
     <option value="UserAccount" <cfif #URL.IDSorting# eq "UserAccount">selected</cfif>>Group by User
</SELECT> 

</TD>
<td bgcolor="#6688AA" align="right"></TD>
</tr>

<TR>

<td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">

<cfif #URL.IDSorting# eq "Mission">

<tr bgcolor="#8EA4BB">
    <TD width="1%"></TD>
	<TD width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Mission</font></TD>
	<TD width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Area</font></TD>
	<TD width="4%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Order</font></TD>
   	<TD width="30%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Action</font></TD>
    <TD width="20%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Officer</font></TD>
	<TD width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Group</font></TD>
	<td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Entered</font></td>
</TR>

<tr bgcolor="C0C0C0"><td height="1" colspan="8" class="top2"></td></TR>

<cfset vac     = "0">
<cfset action  = "9999">
<cfset total   = 0>
<cfset person  = 0>

<!--- <cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#> --->

<cfoutput query="SearchResult" group="Mission">

   <cfset subtotal    = 0>
    
   <tr bgcolor="f6f6f6">
   <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#Mission#</b></font></td>
   
   </tr>
   
   <cfset sub = "">
   
   <cfoutput group="ActionClass">
   
   <tr><td height="2" colspan="8" class="regular">&nbsp;&nbsp;<b>#ActionClass# #ActionClassdescription#</b></td></tr>
   <tr><td height="1" colspan="8" class="top"></td></tr>
   
   <cfoutput group="ActionOrderSub">
   
   <tr><td height="2" colspan="8"></td></tr>
           
   <CFOUTPUT>
   <tr>
     <td></td>
	 <td></td>
	 <cfif #ActionOrderSub# neq #sub#>
  	 <td class="regular">#ActionArea#</td>
     <td class="regular">#ActionOrderSub#</td>
     <td class="regular">#ActionDescription#</td>
	 <cfelse>
   	 <td class="regular"></td>
     <td class="regular"></td>
     <td class="regular"></td>
	 </cfif>
     <td class="regular">
	  <a href="javascript:showprofile('#UserAccount#','#Mission#')">
	  #FirstName# #LastName#</a>
	  </td>
	  <td class="regular">#AccountGroup#</td>
     <td class="regular">#DateFormat(Created,CLIENT.DateFormatShow)#</td>
   </tr>
   
   <cfset sub = #ActionOrderSub#>

   </CFOUTPUT>
   
   <tr><td height="2" colspan="8"></td></tr>
   
   <tr><td height="1" colspan="8" class="top"></td></tr>
   
   </cfoutput>
   
   </cfoutput>

  </CFOUTPUT>

<cfelse>

<tr bgcolor="#8EA4BB">
    <TD width="1%"></TD>
	<TD width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Mission</font></TD>
    <TD width="20%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Officer</font></TD>
	<TD width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Group</font></TD>
	<TD width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Area</font></TD>
	<TD width="4%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Order</font></TD>
   	<TD width="35%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Action</font></TD>
	<td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Entered</font></td>
</TR>

<tr bgcolor="C0C0C0"><td height="1" colspan="8" class="top2"></td></TR>

<cfset vac     = "0">
<cfset action  = "9999">
<cfset total   = 0>
<cfset person  = 0>

<!--- <cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#> --->

<cfoutput query="SearchResult" group="Mission">

   <cfset subtotal    = 0>
    
   <tr bgcolor="f6f6f6">
   <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#Mission#</b></font></td>
   
   </tr>
   
   <cfset sub = "">
   
   <cfoutput group="ActionClass">
      
   <tr><td height="2" colspan="8" class="regular">&nbsp;&nbsp;#ActionClass# #ActionClassdescription#</td></tr>
   <tr><td height="1" colspan="8" class="top"></td></tr>
   
   <cfoutput group="LastName">
   <cfoutput group="FirstName">
   
   <tr><td height="2" colspan="8"></td></tr>
           
   <CFOUTPUT>
   <tr>
     <td></td>
	  <td class="regular"></td>
	 <cfif #UserAccount# neq #sub#>
  	 <td class="regular">
	  <a href="javascript:showprofile('#UserAccount#','#Mission#')">
	  <b>#FirstName# #LastName#</b></a>
	 </td>
	 <td class="regular"><b>#AccountGroup#</b></td>
  	 <cfelse>
   	 <td class="regular"></td>
	 <td class="regular"></td>
  	 </cfif>
	
   	 <td class="regular">#ActionArea#</td>
     <td class="regular">#ActionOrderSub#</td>
     <td class="regular">#ActionDescription#</td>
      <td class="regular">#DateFormat(Created,CLIENT.DateFormatShow)#</td>
   </tr>
   
   <cfset sub = #UserAccount#>

   </CFOUTPUT>
   
   <tr><td height="2" colspan="8"></td></tr>
   
   <tr><td height="1" colspan="8" class="top"></td></tr>
   
   </cfoutput>
   </cfoutput>
   
   </cfoutput>

</CFOUTPUT>

</cfif>

</TABLE>

 </td></tr>
 <tr><td height="10" colspan="2" bgcolor="#002350"></td></tr>
 
</TABLE>

 </td></tr>
  
</table>
 
<hr>
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font> </p>

</form>

</BODY></HTML>