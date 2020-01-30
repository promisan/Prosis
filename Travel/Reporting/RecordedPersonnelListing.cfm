<!--- 
	RecordedPersonnelListing.CFM

	View all UNMO/CIVPOL personnel that have disciplinary cases.
	
	Modification History:
	09Oct03 - created by MM/CP
--->

<cfset CLIENT.DataSource = "AppsTravel">

<link href="../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<!--- tools : verify is user is authenticated through login menu --->


<!--- tools : prevent caches, disabled back button --->
<cf_PreventCache>

<HTML>
<HEAD><TITLE>Personnel With Prior Disciplinary Case</TITLE></HEAD>


<cfoutput>
<SCRIPT LANGUAGE = "JavaScript">
function reloadForm(nat,group,page,mission,categ)
{
    window.location="RecordedPersonnelListing.cfm?IDNationality=" + nat + "&IDCategory=" + categ + "&IDSorting=" + group + "&Page=" + page + "&IDMission=" + mission;
}
</SCRIPT>	
</cfoutput>

<!--- tools : make available javascript for quick reference to dialog screens --->
<cfinclude template="..\Application\Dialog.cfm">

<cfparam name="URL.IDSorting" 	default="PersonName">
<cfparam name="URL.IDCategory" 	default="CIVPOL">
<cfparam name="URL.IDMission" 	default="ALL">
<cfparam name="URL.IDNationality" default="ALL">

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

<!--- dropdown select mission for view --->
<cfquery name="mission" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Mission
	FROM Document
	ORDER BY Mission
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

<cfset select = "spRecordedPersonnel">

<cfstoredproc procedure="#select#" 
 datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">

   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@USERID"      value="#SESSION.acc#"        null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SORT"        value="#URL.IDSorting#"     null="No">
   <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MISSION"     value="#URL.IDMission#"     null="No">
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
    <td width="100"><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;Nationality:</b></font></td>
	<td width="200">
    <select name="nat" style="background: #002350; color: White;" accesskey="P" title="Select Country of Nationality" 
	onChange="javascript:reloadForm(this.value,group.value,page.value,mission.value,categ.value)">
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

    <td width="100"><font face="Tahoma" size="2" color="#FFFFFF"><b>Field Mission:</b></font></td>
	<td>	
	<!--- dropdown to select a different mission --->
    <select name="mission" style="background: #002350; color: White;" accesskey="P" title="Select Field Mission" 
	onChange="javascript:reloadForm(nat.value,group.value,page.value,this.value,categ.value)">
 	<option value="ALL">
	<font face="Tahoma" size="3">
	All
	</font>
    <cfoutput query="Mission">
	<option value="#Mission#" <cfif #Mission# is '#URL.IDMission#'>selected</cfif>>
	<font face="Tahoma" size="3">
	#Mission#
	</font>
	</option>
	</cfoutput>
    </select>
    </td>
  	</tr> 	
  
  <tr><td colspan="5">

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
<!--- Start row containing the TYPE*, GROUPING and PAGE OF drop-down lists --->
<!--- *TYPE - CIVPOL or UNMO/SO --->

<tr>
	<td bgcolor="#6688AA" height="30">&nbsp;
	
	<!--- FILTER: Person CATEGORY --->	
	<select name="categ" style="background: #C9D3DE;" accesskey="P" title="Category Selection" 
	onChange="javascript:reloadForm(nat.value,group.value,page.value,mission.value,this.value)">
 <!---   	<option value="ALL">
		<font face="Tahoma" size="1">
		All
		</font>
		</option>
--->
	    <cfoutput query="Category">
		<option value="#Category#" <cfif #Category# is '#URL.IDCategory#'>selected</cfif>>
		<font face="Tahoma" size="1">
		#Category#
		</font></option>
		</cfoutput>
	</select>	

	<!--- drop down for record grouping and sorting  --->	
	<select name="group" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(nat.value,this.value,page.value,mission.value,categ.value)">
		 <OPTION value="Nationality" <cfif #URL.IDSorting# eq "Nationality">selected</cfif>>Group by Country of Nationality
		 <OPTION value="Mission" <cfif #URL.IDSorting# eq "Mission">selected</cfif>>Group by Field Mission
		 <OPTION value="CrimeDescription" <cfif #URL.IDSorting# eq "CrimeDecription">selected</cfif>>Group by Crime
 		 <OPTION value="Decision" <cfif #URL.IDSorting# eq "Decision">selected</cfif>>Group by Decision Made
		 <OPTION value="PersonName" <cfif #URL.IDSorting# eq "PersonName">selected</cfif>>Sort by Person Name
	</select> 
	</td>

	<td bgcolor="#6688AA" align="right">
	<!--- drop down to select only a number of record per page using a tag in tools --->	
	<cfinclude template="../../Tools/PageCount.cfm">
	<select name="page" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(nat.value,group.value,this.value,mission.value,categ.value)">
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
    <td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Mission</font></td>
	<td width="6%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Nat</font></td>
	<td width="7%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Rank</font></td>
	<td width="15%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">First Name</font></td>	
	<td width="15%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Last Name</font></td>
	<td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">DOB</font></td>
    <td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">DOA</font></td>
	<td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">DOR</font></td>
    <td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">IMIS No</font></td>
    <td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Passport</font></td>
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
     <cfcase value = "Mission">
     <td colspan="12"><font face="Tahoma" size="2"><b>&nbsp;#Mission#</b></font></td> 
     </cfcase>	
     <cfcase value = "CrimeDescription">
	 <td colspan="12"><font face="Tahoma" size="2"><b>&nbsp;#CrimeDescription#</b></font></td>
     </cfcase>
     <cfcase value = "Decision">
     <td colspan="12"><font face="Tahoma" size="2"><b>&nbsp;#Decision#</b></font></td> 
     </cfcase>	
</cfswitch>   
</tr>

<!--- DETAIL RECORD SECTION --->     
<!--- Print a line before the record --->
<tr bgcolor="C0C0C0"><td height="1" colspan="12" class="top2"></td></tr>
	
<!--- Record detail row --->
<cfoutput>
<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">    <!--- give every other row grey background --->
<td rowspan="1" align="left"></td>	
<td rowspan="1" align="center"><img src="../../Images/function.jpg" alt="" width="18" height="15" border="0"></td>
<td class="regular">#Mission#</td>
<td class="regular">#Nationality#</td>
<td class="regular">#Rank#</td>
<td class="regular">#FirstName#</td>		
<td class="regular">#LastName#</td>
<td class="regular">#DateFormat(BirthDate, "#CLIENT.dateformatshow#")#</td>
<td class="regular">#DateFormat(DateEffective, "#CLIENT.dateformatshow#")#</td>
<td class="regular">#DateFormat(DateExpiration, "#CLIENT.dateformatshow#")#</td>
<td class="regular">#IndexNo#</td>		
<td class="regular">#PassportNo#</td>
<td class="regular"> </td></td>
</tr>

<!--- <tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">   ---THIS CODE MAY NOT BE NEEDED!!
<td></td>
--->

<!--- Aggregate record counter --->
<cfset Amt = Amt + 1>
<cfset AmtT = AmtT + 1>
</cfoutput>

<!---If record groups are being used, display the group counter section --->
<cfif #URL.IDSorting# neq "PersonName">
	<!--- Print a row containing the blue "sub-total line" --->
	<tr>
	<td colspan="11" align="center">	<!--- Print a gray cell spanning 10 columns --->
	<td align="right"><hr></td>			<!--- Print a line before the sub-total --->
	</tr>
	<!------------------------------------------------------->
   
	<!--- Then print a row containing the sub-total value --->
	<tr>
	<td colspan="11" align="center">	<!--- Print a gray cell spanning 10 columns --->	
	<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>	
	</tr>
	<!------------------------------------------------------->

	<tr><td height="10" colspan="12"></td></tr>		<!--- Print an extra blank row --->
</cfif>
<!------------------------------------------------------------------------->

</cfoutput>

<!--- Now print the global record counter section --->	
<tr bgcolor="f7f7f7">
<td colspan="11" align="center">		<!--- Print a gray cell spanning 11 columns --->
<td align="right"><hr></td>				<!--- Print a line before the sub-total --->
</tr>
 
<tr bgcolor="f7f7f7">
<td colspan="11" align="center">		<!--- Print a gray cell spanning 11 columns --->
<td align="right"><font size="1" face="Tahoma"><b><cfoutput>#NumberFormat(AmtT,'_____,__')#&nbsp;</cfoutput></b></font></td>	
</tr>
<!-------------------------------------------------->

</table>

<!--- Print a dark blue border below the table frame --->
<tr><td height="10" colspan="12" bgcolor="#002350"></td></tr>

</table>

</table>

<hr>
<p align="center"><font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font></p>

</form>
</BODY></HTML>