<!--- 
	PersonListing.CFM

	View person table records.
	
	Modification History:
	22Oct03 - created by MM
--->

<cfset CLIENT.DataSource = "AppsTravel">

<link href="../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<!--- tools : verify is user is authenticated through login menu --->


<!--- tools : prevent caches, disabled back button --->
<cf_PreventCache>

<HTML>
<HEAD><TITLE>Person Listing</TITLE></HEAD>


<cfoutput>
<SCRIPT LANGUAGE = "JavaScript">
function reloadForm1(group,mission,nat,categ,page)
{
    window.location="PersonListing.cfm?IDSorting=" + group + "&IDMission=" + mission + "&IDNationality=" + nat + "&IDCategory=" + categ + "&Page=" + page;
}

</SCRIPT>	
</cfoutput>

<!--- tools : make available javascript for quick reference to dialog screens --->
<cfinclude template="Dialog.cfm">

<cfparam name="URL.IDSorting" 		default="PersonName">
<cfparam name="URL.IDMission" 		default="ALL">
<cfparam name="URL.IDNationality" 	default="ALL">
<cfparam name="URL.IDCategory" 		default="CIVPOL">

<!--- dropdown select mission for view --->
<cfquery name="nationality" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT P.Nationality, RN.Name
	FROM Person P, Ref_Nationality RN
	WHERE P.Nationality = RN.Code
	ORDER BY RN.Name
</cfquery>

<!--- dropdown  Person Category: CIVPOL or UNMO --->
<cfquery name="category"
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#"
cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT DISTINCT TravellerType As Category
	FROM  Ref_Category
	ORDER BY TravellerType
</cfquery>

<!--- drop temp table that might be still on the server --->
<CF_DropTable dbName="#CLIENT.Datasource#" tblName="tmp#SESSION.acc#">

<cfset select = "spPersonListing">

<cfstoredproc procedure="#select#" 
 datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">

   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SORT"        value="#URL.IDSorting#"     null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NATIONALITY" value="#URL.IDNationality#" null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CATEGORY"    value="#URL.IDCategory#"    null="No">
	
   <!--- identify all actions --->
   <cfprocresult name="SearchResult" resultset="1"> 
   
</cfstoredproc>

<!--- Query returning search results --->

<body class="main" onload="javascript:document.forms.result.page.focus();">

<form name="result" id="result">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

  <tr bgcolor="#002350">
	<!-- Filter: NATIONALITY -->
    <td width="100"><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;Nationality:</b></font></td>
	<td width="200">
    <select name="nat" style="background: #C9D3DE;" accesskey="P" title="Select Country of Nationality" 
	onChange="javascript:reloadForm1(group.value,mission.value,nat.value,categ.value,page.value)">
	<option value="ALL">
	<font face="Tahoma" size="3">
	All
	</font>
    <cfoutput query="nationality">
	<option value="#Nationality#" <cfif #Nationality# is '#URL.IDNationality#'>selected</cfif>>	
	<font face="Tahoma" size="3">	
	#Name#
	</font>
	</option>
	</cfoutput>
    </select>
    </td>

	<!-- Filter: Category -->	
    <td width="100"><font face="Tahoma" size="2" color="#FFFFFF"><b>Category:</b></font></td>
	<td>	
	<select name="categ" style="background: #C9D3DE;" accesskey="P" title="Category Selection" 
	onChange="javascript:reloadForm1(group.value,mission.value,nat.value,categ.value,page.value)">
	    <cfoutput query="Category">
		<option value="#Category#" <cfif #Category# is '#URL.IDCategory#'>selected</cfif>>
		<font face="Tahoma" size="1">
		#Category#
		</font></option>
		</cfoutput>
	</select>	
	</td>
	<!--- Add Incident button --->
	<td align="right" height="30" valign="middle" bgcolor="002350">
 	<input type="button" class="input.button1" name="Associate" value="Associate Incident " 
	  onClick="javascript:listincident('personlisting','IndexNo','#searchresult.LastName#','#Dateformat(searchresult.DOB, CLIENT.DateFormatShow)#','#searchresult.Nationality#')"> 	
	  &nbsp;
	</td> 

  </tr> 	
  
<tr>

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">

  <tr bgcolor="#6688AA" height="30">
	<!--- drop down for record grouping and sorting  --->	
	<td width="150"><font face="Tahoma" size="2" color="#FFFFFF"><strong>&nbsp;Group/Sort By:</strong></font></td>
	<td>
	<select name="group" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm1(group.value,mission.value,nat.value,categ.value,page.value)">
		 <OPTION value="Nationality" <cfif #URL.IDSorting# eq "Nationality">selected</cfif>>Group by Country of Nationality
		 <OPTION value="PersonName" <cfif #URL.IDSorting# eq "PersonName">selected</cfif>>Sort by Person Name
	</select> 
	</td>

	<td align="right">
	<!--- drop down to select only a number of record per page using a tag in tools --->	
	<cfinclude template="../../Tools/PageCount.cfm">
	<select name="page" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm1(group.value,mission.value,nat.value,categ.value,page.value)">
		 <cfloop index="Item" from="1" to="#pages#" step="1">
    		  <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
	     </cfloop>	 
	</select>
	</td>
  </tr>

<!--- Detail column headers --->
<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">

<tr bgcolor="#8EA4BB">
    <td width="1%"></td>
	<td width="4%"></td>
	<td width="15%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">First Name</font></td>	
	<td width="15%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Last Name</font></td>
	<td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Rank</font></td>
	<td width="6%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Nat</font></td>
	<td width="6%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Gender</font></td>
    <td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">DOB</font></td>
	<td width="2%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Category</font></td>
	<td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>
    <td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>
    <td width="11%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">&nbsp;</font></td>
</tr>

<cfset vac     = "0">
<cfset action  = "9999">
<cfset amtT    = 0>

<cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#>

<cfset amt  = 0>
    
<!--- Display ROW containing record group headers --->
<tr bgcolor="f6f6f6">
<cfswitch expression = #URL.IDSorting#>
     <cfcase value = "Nationality">
	 <td colspan="12"><font face="Tahoma" size="2"><b>&nbsp;#Nationality#</b></font></td>
     </cfcase>
</cfswitch>   
</tr>

<!--- DETAIL RECORD SECTION --->     
<!--- Print blank row before the record --->
<tr bgcolor="C0C0C0"><td height="1" colspan="12" class="top2"></td></tr>
	
<!--- Record detail row --->
<cfoutput>
<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
		
<td rowspan="1" align="left"></td>	
<td rowspan="1" align="center">
<!---    CREATE A POP-UP PAGE THAT SHOWS PERSON DETAILS
 		<a href="javascript:showdocument('#DocumentNo#','ZoomIn')"> 
--->
<img src="../../Images/function.jpg" alt="" width="18" height="15" border="0">
</td>
	
<td class="regular">#FirstName#</td>		
<td class="regular">#LastName#</td>
<td class="regular">#sRank#</td>
<td class="regular">#Nationality#</td>
<td class="regular">#Gender#</td>
<td class="regular">#DateFormat(DOB, "#CLIENT.dateformatshow#")#</td>
<td class="regular">#Category#</td>
<td class="regular"> </td>	
<td class="regular"> </td>
<td class="regular"> </td>
</tr>

<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
<td></td>
<cfset Amt = Amt + 1>
<cfset AmtT = AmtT + 1>
</cfoutput>

<!---If record groups are being used, display the group counter section --->
<cfif #URL.IDSorting# neq "PersonName">
<tr>
<!--- Print a gray cell spanning 10 columns --->
<td colspan="11" align="center">
<!--- Print a line before the sub-total --->
<td align="right"><hr></td>	
</tr>
   
<tr>
<!--- Print a gray cell spanning 10 columns --->	
 <td colspan="11" align="center">
<!--- Print the sub-total --->
<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>	
</tr>

<tr><td height="10" colspan="11"></td></tr>
</cfif>

</cfoutput>
	
<tr bgcolor="f7f7f7">
<!--- Print a gray cell spanning 11 columns --->
<td colspan="11" align="center">
<!--- Print a line before the sub-total --->
<td align="right"><hr></td>	
</tr>
 
<tr bgcolor="f7f7f7">
<!--- Print a gray cell spanning 11 columns --->
<td colspan="11" align="center">
<!--- Print the total --->		
<td align="right"><font size="1" face="Tahoma"><b><cfoutput>#NumberFormat(AmtT,'_____,__')#&nbsp;</cfoutput></b></font></td>	
</tr>

</table>
<!--- Print a dark blue border --->
<tr><td height="10" colspan="12" bgcolor="#002350"></td></tr>

</table> 

</table>

<hr><p align="center"><font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font></p>

</form>
</BODY></HTML>