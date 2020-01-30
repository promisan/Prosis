<!--- 
	ContingentActivityListing.CFM

	View contingent activity sub records. 
	
	Modification History:
	
--->
<HTML><HEAD><TITLE>Contingent Activity</TITLE></HEAD>

<cfquery name="SearchResult" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT     
	ca.Id AS ContingentActivity_Id, 
	ca.Contingent_Id AS ContingentActivity_Contingent_Id, 
	ca.ContingentEvent_Id AS ContingentActivity_ContingentEvent_Id, 
	ca.DateEffective AS ContingentActivity_DateEffective, 
	ca.Remarks AS ContingentActivity_Remarks, 
	ca.PersonCount AS ContingentActivity_PersonCount, 	
	ca.OfficerUserId AS ContingentActivity_OfficerUserId, 
	Upper(ca.OfficerLastName) AS ContingentActivity_OfficerLastName, 
	ca.OfficerFirstName AS ContingentActivity_OfficerFirstName, 
	ca.Created AS ContingentActivity_Created, 
	ce.Name AS ContingentEvent_Name
FROM         
	ContingentActivity ca INNER JOIN
	ContingentEvent ce ON ca.ContingentEvent_Id = ce.Id
WHERE ca.Contingent_Id = #URL.CONT_ID#
ORDER BY 
	ca.DateEffective
</cfquery>

<!--- Query returning search results --->
<body class="main" onload="window.focus()" leftmargin="0" rightmargin="0" 
topmargin="0" bottommargin="0" marginheight="0" marginwidth="0">

<form name="ContingentActivityListing" id="ContingentActivityListing">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

<!--- Detail column headers --->
<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">

<tr bgcolor="#8EA4BB">
    <td class="top4n"></td>	
    <td class="top4n">Ct</td>
    <td class="top4n">Date Eff</td>	
	<td class="top4n">Event</td>
    <td class="top4n">Count</td>
    <td class="top4n">Remarks</td>	
	<td class="top4n">Entered by</td>
	<td class="top4n">Entered on</td>
</tr>
<cfset ColCnt = 7>

<cfoutput query="SearchResult">
<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
<td rowspan="1" align="center">
  <button class="button3" onClick="javascript:ShowContingentActivityDetail('#ContingentActivity_Id#')">
	  <img src="../../../Images/function.jpg" alt="" width="18" height="15" border="0">
  </button>
</td>
<td class="regular">#CurrentRow#.</td>	
<td class="regular">#Dateformat(ContingentActivity_DateEffective, "#CLIENT.dateformatshow#")#</td>
<td class="regular">#ContingentEvent_Name#</td>
<td class="regular">#ContingentActivity_PersonCount#</td>
<td class="regular">#ContingentActivity_Remarks#</td>
<td class="regular">#ContingentActivity_OfficerFirstName# #ContingentActivity_OfficerLastName#</td>
<td class="regular">#Dateformat(ContingentActivity_Created, "#CLIENT.dateformatshow#")#</td>
</tr>
</cfoutput>
	
</table>

<!--- Print a dark blue border --->
<tr><td height="10" colspan="#ColCnt#" bgcolor="#002350"></td></tr>

</table>

<hr><p align="center"><font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font></p>

</form>
</BODY></HTML>