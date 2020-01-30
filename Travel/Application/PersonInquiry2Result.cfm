<!--- 
	PersonInquiry2Search.cfm
	
	Create Criteria string for query from data entered thru Person search form 
	
	Called by: PersonInquiry2.cfm
	Calls:
	
	Modification History:
	10Jan04 - added new query var BirthDate
			- changed Criteria3 from MissionID to PassportNo
	
--->
<cfinclude template="Dialog.cfm">

<cfparam name="Form.Crit1_Value" default="">	

<cfset Criteria = ''>

<!--- 1. Build criteria string based on user input in calling form --->
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
<cfparam name="Form.BirthDate" default="">

<cfif #Form.Nation# EQ "0">
  <cfif #Form.Nationality# NEQ "">
     <cfif #Criteria# EQ "">
		 <cfset #Criteria# = "P.Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND P.Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
     </cfif>
  </cfif> 
</cfif>	

<cfset dateValue = "">
<cfif #Form.BirthDate# NEQ "">
 	<CF_DateConvert Value="#Form.BirthDate#">
	<cfset bDate = #dateValue#>
	<cfif #Criteria# EQ "">
		 <cfset #Criteria# = "P.BirthDate = #bDate#">
	 <cfelse>
		 <cfset #Criteria# = #Criteria#&" AND P.BirthDate = #bDate#" >
     </cfif>
</cfif> 

<!--- 2a. Retrieve all persons from Person table. --->
<cfquery name="SearchResult" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT 	P.*, PD.DocumentReference AS PassportNo,
			    (CASE WHEN (DC.PersonNo IS NULL) THEN Upper(P.LastName) ELSE P.LastName + '*' END) AS sLastName
		FROM   	Person P INNER JOIN 
				TRAVEL.DBO.Ref_Category C ON P.Category = C.Category LEFT JOIN 
               	(SELECT * FROM PersonDocument 
			   	 WHERE DocumentType = 'Passport') PD ON P.PersonNo = PD.PersonNo LEFT JOIN
				TRAVEL.DBO.DocumentCandidate DC ON P.PersonNo = DC.PersonNo
		<cfif #PreserveSingleQuotes(Criteria)# NEQ "">
		  WHERE #PreserveSingleQuotes(Criteria)#
	 	</cfif>
		ORDER BY P.LastName, P.FirstName
</cfquery>

<!--- 3. Display the results in a list --->
<html><head><title>Persons Inquiry - Search Results</title></head>
	
<link href="../../../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<body bgcolor="#BFDFFF">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr height="20" valign="middle" bgcolor="002350">
    <td class="label">&nbsp;<b>Person Inquiry - Search Results</b></td> 
  </tr>
  
  <tr>
  <td>  
   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

  	<tr bgcolor="#6688aa">
    <td class = "topN">&nbsp;</td>
    <td class = "topN">Ctr</td>
    <td class = "topN">Person No</td>	
    <td class = "topN">Index No</td>	
    <td class = "topN">First Name</td>
    <td class = "topN">Last Name</td>
    <td class = "topN">Birth Date</td>
    <td class = "topN">Gender</td>	
    <td class = "topN">Nat</td>		
    <td class = "topN">Category</td>	
    <td class = "topN">Passport</td>		
	</tr>

	<cfoutput query="SearchResult">
 	<tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
		<td class="regular">
		<button class="button3" onClick="javascript:pm_editperson('#PersonNo#')">
		<img src="#CLIENT.Root#/Images/button.jpg" alt="" name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">	
		</button>
		</td> 
   		<td class="regular">&nbsp;#CurrentRow#.</td>	
		<td class="regular">#PersonNo#</td>
		<td class="regular">#IndexNo#</td>
		<td class="regular">#FirstName#</font></td>			
		<td class="regular">#sLastName#</font></td>	
		<td class="regular">#DateFormat(BirthDate, CLIENT.DateFormatShow)#</font></td>
		<td class="regular">#Gender#</font></td>
		<td class="regular">#Nationality#</font></td>
		<td class="regular">#Category#</font></td>
		<td class="regular">#PassportNo#</font></td>
  	</tr>
	</cfoutput>
   </table>
  </td>
  </tr>
</table>

<hr>

<input type="button" name="OK"    value="    Close    " onClick="window.close()"> 

</body></html>