<!---
	IncidentInquiryResult.cfm
	
	Display results of inquiry for incidents
	
	Called by: IncidentInquiry.cfm  (Post)

	Modification History:
	
--->

<CF_RegisterAction 
SystemFunctionId="1203" 
ActionClass="SAT Inquiry" 
ActionType="Inquire SAT" 
ActionReference="" 
ActionScript="">  

<!--- tools : make available javascript for quick reference to dialog screens --->

<cf_PreventCache>

<cfinclude template="Dialog.cfm">

<cfparam name="Form.Crit1_Value" default="">	

<cfset Criteria = ''>

<cfif #Form.Crit1_Value# IS NOT "">	
	<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
</cfif>	
<cfif #Form.Crit2_Value# IS NOT "">	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">
</cfif>	
<cfif #Form.Crit3_Value# IS NOT "">	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit3_FieldName#"
    FieldType="#Form.Crit3_FieldType#"
    Operator="#Form.Crit3_Operator#"
    Value="#Form.Crit3_Value#">
</cfif>	

<cfparam name="Form.Nationality" default="">

<cfif #Form.inclNation# EQ "0">
  <cfif #Form.Nationality# IS NOT "">
     <cfif #Criteria# is ''>
		 <cfset #Criteria# = "S.Nationality IN (#PreserveSingleQuotes(Form.Nationality)# )">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND S.Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
     </cfif>
  </cfif> 
</cfif>	

<cfparam name="Form.Category" default="">

<cfif #Form.inclCat# EQ "0">
  <cfif #Form.Category# IS NOT "">
     <cfif #Criteria# is ''>
		 <cfset #Criteria# = "S.Category IN (#PreserveSingleQuotes(Form.Category)# )">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND S.Category IN ( #PreserveSingleQuotes(Form.Category)# )" >
     </cfif>
  </cfif> 
</cfif>

<cfparam name="Form.Status" default="">

<cfif #Form.inclStat# EQ "0">
  <cfif #Form.Status# IS NOT "">
     <cfif #Criteria# is ''>
		 <cfset #Criteria# = "S.Status IN (#PreserveSingleQuotes(Form.Status)# )">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND S.Status IN ( #PreserveSingleQuotes(Form.Status)# )" >
     </cfif>
  </cfif> 
</cfif>

<!--- Query returning search results --->
<cfquery name="SearchResult" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT S.*, Upper(S.LastName) as sLastName, S.Nationality, R.Description AS sRank
	FROM   SAT S INNER JOIN Ref_Rank R ON S.Rank = R.Rank
	<cfif #PreserveSingleQuotes(Criteria)# NEQ "">
	  	WHERE #PreserveSingleQuotes(Criteria)#	
  	</cfif>
	ORDER BY S.LastName, S.FirstName 	
</cfquery>

<HTML><HEAD><TITLE>SAT Inquiry Results</TITLE></HEAD>
	
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">

<body bgcolor="#BFDFFF">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr height="20" valign="middle" bgcolor="002350">
    <td class="label">&nbsp;<b>SAT Inquiry Results</b></td> 
  </tr>
  <tr><td>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<tr bgcolor="#6688aa">
    <td class="TopN">Ctr</font></td>	
    <td class="TopN">Identifier</font></td>			
    <td class="TopN">LastName</font></td>	
    <td class="TopN">FirstName</font></td>	
    <td class="TopN">Nat</font></td>
    <td class="TopN">Gender</font></td>	
    <td class="TopN">Rank</font></td>		
    <td class="TopN">BirthDate</font></td>
    <td class="TopN">Read</font></td>			
    <td class="TopN">Write</font></td>			
    <td class="TopN">Listen</font></td>					
    <td class="TopN">Interview</font></td>						
    <td class="TopN">Driving</font></td>						
    <td class="TopN">Shooting</font></td>								
    <td class="TopN">Category</font></td>								
    <td class="TopN">SAT Date</font></td>
    <td class="TopN">Stat</font></td>											
</tr>

<cfoutput query="SearchResult">
 <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
<!---	<td rowspan="1" align="center">
	  <button class="button3" onClick="javascript:showincidentview('#SearchResult.Incident#')">
	  <img src="../../Images/function.JPG" alt="" width="18" height="15" border="0"></button></td>  --->
	<td><font size="1" face="Tahoma" color="000000">#CurrentRow#.</font></td>	  
	<td><font size="1" face="Tahoma" color="000000">#Id#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#sLastName#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#FirstName#</font></td>	
	<td><font size="1" face="Tahoma" color="000000">#Nationality#</font></td>	
	<td><font size="1" face="Tahoma" color="000000">#Gender#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#sRank#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#DateFormat(BirthDate, CLIENT.DateFormatShow)#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#Reading#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#Writing#</font></td>	
	<td><font size="1" face="Tahoma" color="000000">#Listening#</font></td>		
	<td><font size="1" face="Tahoma" color="000000">#Interviewing#</font></td>			
	<td><font size="1" face="Tahoma" color="000000">#Driving#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#Shooting#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#Category#</font></td>	
	<td><font size="1" face="Tahoma" color="000000">#DateFormat(DateSat, CLIENT.DateFormatShow)#</font></td>	
	<td><font size="1" face="Tahoma" color="000000">#Status#</font></td>		
  </tr>
</cfoutput>

</table>

</tr>
</table>

<hr>

</BODY></HTML>