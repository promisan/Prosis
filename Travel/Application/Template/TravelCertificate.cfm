<!---
TRAVELCERTIFICATE.CFM

Modification History:
080508 - redone by MM
--->

<cfquery name="MissionDetails" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT LO.LocationName, M.Missionname,D.Mission,PM.[Description]as CountryGovtName, MC.City,MC.CountryName,D.PersonCategory
	FROM Employee.dbo.Location LO INNER JOIN
		Organization.dbo.Ref_Mission M ON Lo.Mission=M.Mission INNER JOIN
		Travel.dbo.Document D ON M.Mission=D.Mission INNER JOIN
		Travel.dbo.Ref_PermanentMission PM ON D.PermanentMissionId=PM.PermanentMissionID INNER JOIN
		Travel.dbo.Ref_MissionCountry MC ON M.Mission=MC.Mission
	Where D.DocumentNo='#URL.DocNo#' AND LO.LocationClass='HQ'
</cfquery>

<cfquery name="ActionCandidateCurrent" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT VC.DocumentNo, VC.PersonNo, Upper(VC.LastName) as sLastName, 
		VC.FirstName, P.IndexNo, MIN(ActionOrderSub) as ActionOrderSub FROM DocumentCandidate
		VC INNER JOIN DocumentCandidateAction VA ON VC.DocumentNo = VA.DocumentNo AND
		VC.PersonNo = VA.PersonNo LEFT JOIN EMPLOYEE.DBO.Person P ON VC.PersonNo =
		P.PersonNo 
	WHERE VC.DocumentNo = '#URL.DocNo#' AND 
		VA.ActionStatus = '0' AND
		VC.Status < '6' 
	GROUP BY VC.DocumentNo, VC.PersonNo, VC.LastName, VC.FirstName, P.IndexNo
</cfquery>

<cfset officer ="">

<cfswitch expression="#MissionDetails.PersonCategory#">
	<cfcase value="SO">
		<cfset officer ="Staff Officer">
	</cfcase>
	<cfcase value="CIVPOL">
		<cfset officer ="Police Officer">
	</cfcase>
	<cfcase value="UNMO">
		<cfset officer ="Military Observer">
	</cfcase>
</cfswitch>

<cfinclude template="/Custom/DPKO/Vactrack/UNPageHeader.cfm">

<table width="90%" border="0" align="center">	  
	<tr><td colspan="3">&nbsp;</td></tr>
     <tr>
        <td colspan="2">&nbsp;</td>
        <td><p align="right"><font face="Times New Roman, Times, serif"><cfoutput>#DateFormat(now(),"dd-mmmm-yyyy")#</cfoutput></p></td>
	</tr>
	<tr>
		<td colspan="3" align="center" style="font-family:'Times New Roman', Times, serif; font-size:18px; font-weight:bold">TO WHOM IT MAY CONCERN</td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
		
    <tr><td colspan="3"><p align="justify">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<strong>THIS IS TO CERTIFY</strong> that the officer(s) 
		listed below is/are <cfoutput>#officer#(s)</cfoutput> from 
		the Government of <cfoutput>#MissionDetails.CountryGovtName#</cfoutput> traveling 
		on official business to <cfoutput>#MissionDetails.City# ,#MissionDetails.CountryName# </cfoutput> for 
		a tour of duty with the <strong><cfoutput>#MissionDetails.MissionName#</cfoutput></strong>.</p></td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td colspan="3">
			<table width="100%" border="0">
			<tr>
				<td width="10%">&nbsp;</td>
				<td>
				<strong>
				<cfset counter="0">
				<Cfoutput query="ActionCandidateCurrent">
					<cfset counter=counter+"1">
	  				#counter#. #ActionCandidateCurrent.FirstName#&nbsp;&nbsp;#ActionCandidateCurrent.sLastName#  (#ActionCandidateCurrent.IndexNo#)<br>
				</Cfoutput>
				</strong>
				</td>
			</tr>
			</table>          
		</td>
	</tr>
	
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	
	<tr><td colspan="3"><p align="center"><strong>Their visa is pre-arranged/will be issued upon arrival.</strong></p></td></tr>

	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>

	<tr><td colspan="3"><p align="justify">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		Any courtesy and assistance rendered to the above official(s) to facilitate 
		his/her/their smooth travel and expeditious immigration formalities would 
		be highly appreciated.</p></td>
	</tr>
	
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
		
	<tr><td width="60%">&nbsp;</td>
		<td colspan="2"><p align="center">
			Masaki Sato, Chief<br>
			Africa II, FPD<br>
			Department of Field Support<br>
			United Nations Headquarters, New York</p>
		</td>
	</tr>
</table>