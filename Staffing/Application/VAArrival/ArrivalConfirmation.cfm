<!--
    Copyright © 2025 Promisan

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

<!--- the purpose of this template is

1. View all document actions [deplaying the exact step that is due for easy 
reference!],
by mission using different views : pending, etc. and different sorting

2. Provide an option to show only those vacacies/candidate that require 
action of the
person this is currently logged (SESSION.acc) in

3. Provide hyperlink to the actual document action or candidate action

--->

<cf_screentop title="Vacancy" html="No" jquery="Yes" scroll="Yes">

<!--- tools : make available javascript for quick reference to dialog screens --->

<cf_dialogStaffing>
<cf_dialogPosition>
<cfinclude template="../../../Vactrack/Application/Document/Dialog.cfm">

<!--- select candidates with status 0 on that step --->

<!--- Track 1.0 2014 : nice to see 

<cfquery name="SearchResult"
datasource="AppsVacancy"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT DISTINCT VA.DocumentNo, V.PostGrade, V.FunctionalTitle, VA.PersonNo, A.* 
	FROM  DocumentCandidateAction VA, 
	      FlowActionView VW,
	      Applicant.dbo.Applicant A,
		  Document V,
		  DocumentPost VP
	WHERE  VW.ActionId = VA.ActionId
	 AND   V.DocumentNo = VA.DocumentNo
	 AND   V.Status = '0'
	 AND   V.Mission = '#URL.ID1#'
	 AND   V.DocumentNo = VP.DocumentNo
	 AND   VP.PositionNo is not NULL
	 AND   VP.PositionNo != '0'
	 AND   VW.ConditionForView = 'Assignment'
	 AND   VW.ConditionActionStatus = '0'
	 AND   VA.ActionStatus = VW.ConditionActionStatus
	 AND   A.PersonNo = VA.PersonNo
	 AND   VA.PersonNo IN (SELECT DISTINCT PersonNo 
	                       FROM DocumentCandidateAction X, FlowActionView F, Document Doc
						   WHERE X.ActionId = F.ActionId
						   AND   F.ConditionForView 		= 'Assignment'
						   AND   F.ConditionActionStatus 	= '1'
						   AND   X.ActionStatus = F.ConditionActionStatus
						   AND   Doc.DocumentNo = X.DocumentNo
						   AND   Doc.Mission = '#URL.ID1#'
						   AND   Doc.Status = '0') 
	ORDER BY LastName,	FirstName	
</cfquery>		

--->

<!--- ----------------------------------------------------------------------------------------------- --->
<!--- Hanno 27/10/2014 need to tune this query so it will show ONLY if the last step has been reached --->
<!--- Hanno 17/10/2022 was tuned --->
<!--- ----------------------------------------------------------------------------------------------- --->

<cfquery name="SearchResult"
datasource="AppsVacancy"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT    VA.DocumentNo, 
	          V.PostGrade, 
			  V.FunctionalTitle, 
			  VA.PersonNo, 
			  A.*,
			  
			  (SELECT TOP 1 PositionNo
               FROM   Vacancy.dbo.DocumentPost DP
    		   WHERE  DP.DocumentNo = V.DocumentNo
			   AND    DP.PositionNo IN (SELECT PositionNo 
						               FROM   Employee.dbo.Position P
									   WHERE  PositionNo = DP.PositionNo)) as PositionLink	 
			  
			  
	FROM      Document V
	          INNER JOIN DocumentCandidate VA ON V.DocumentNo = VA.DocumentNo
		      INNER JOIN Applicant.dbo.Applicant A ON A.PersonNo   = VA.PersonNo
			  
	WHERE     V.Status     = '0'
	 AND      V.Mission    = '#URL.ID1#'	 
	 AND      VA.Status    = '2s'
	 AND      VA.EntityClass is NOT NULL	 
	 AND      V.DocumentNo IN (SELECT DocumentNo 
	                          FROM   Vacancy.dbo.DocumentPost DP
							  WHERE  DP.DocumentNo = V.DocumentNo
							  AND    DP.PositionNo IN (SELECT PositionNo 
							                           FROM   Employee.dbo.Position P
													   WHERE  PositionNo = DP.PositionNo))	 

	 <!--- show only if the last step is open --->												   
	 AND      V.DocumentNo NOT IN (
	 
	 
				 <!--- put this into a component for easy use 22/10/2022 --->
	 
							SELECT       ObjectKeyValue1
							FROM         Organization.dbo.OrganizationObject AS OO INNER JOIN
							             Organization.dbo.OrganizationObjectAction AS OOA ON OO.ObjectId = OOA.ObjectId
							WHERE        OOA.ActionStatus = '0' 
							AND          OO.Operational = 1 
							AND          OOA.ActionCode NOT IN
							                     (SELECT  P.ActionCode AS LastAction
							                      FROM    Organization.dbo.Ref_EntityActionPublish AS P INNER JOIN
							                              (SELECT    ActionPublishNo, MAX(ActionOrder) AS Last
							                               FROM      Organization.dbo.Ref_EntityActionPublish AS P
							                               WHERE     ActionPublishNo = OO.ActionPublishNo
							                               GROUP BY ActionPublishNo) AS D ON P.ActionPublishNo = D.ActionPublishNo AND D.Last = P.ActionOrder) 
							AND          OO.Mission = '#URL.ID1#'
							AND          OO.EntityCode = 'VacCandidate' 
							
							)
	 
	 
							  		 
	 ORDER BY A.LastName,	A.FirstName	
	 
</cfquery>	
  			   
	
<!--- Query returning search results --->

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<tr><td style="padding:10px">
  
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="labellarge" style="font-size:30px">&nbsp;		
			<cfoutput><b>#URL.ID1#</b> candidates/staff awaiting arrival confirmation<b></b></cfoutput></b>
		</td>
	    <td align="right"></td>
	  </tr>
	  
	  <tr><td height="5"></td></tr>
	
	  <tr><td style="padding:10px">
	
		<table width="100%" align="center">
		
		<TR>
		<td colspan="2">
				
		<table width="100%" align="center" class="navigation_table">
		
			<tr class="labelmedium2 linedotted fixlengthlist fixrow">
			    <TD></TD>
			    <TD><cf_tl id="Name"></TD>
				<TD><cf_tl id="IndexNo"></TD>
				<TD><cf_tl id="Grade"></TD>
				<TD><cf_tl id="Track"></TD>
				<TD><cf_tl id="Title"></TD>
				<td align="right"><cf_tl id="OnBoard"></td>
			</TR>
					
			<cfoutput query="SearchResult">
			
			<tr class="labelmedium2 navigation_row linedotted fixlengthlist" style="height:20px">
			    <td height="20" style="padding-right:5px">#currentRow#.</td>
			    <TD><a href="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#')">#LastName#, #FirstName#</a></TD>
				<TD align="left"><a href="javascript:ShowPerson('#IndexNo#')">#IndexNo#</a></TD>					
				<td colspan="1" align="left">
				      <!--- #Level.ContractLevel#/#Level.ContractStep# ---> #PostGrade#
			    </td>
				<TD align="left"><a href="javascript:showdocument('#documentNo#')">#DocumentNo#</a></TD>
				<td align="left">#FunctionalTitle#</td>
				<td align="right" style="padding-top:3px">	
				
				<cfif PositionLink neq "">
				<cf_img icon="add" 
				    navigation="Yes" 
					onclick="selectposition('VAC','#URL.ID1#','0000','#PersonNo#','','#PersonNo#','#DocumentNo#')">	
				</cfif>	
				</td>
			</TR>
					
			</CFOUTPUT>
		
		</TABLE>
		
		</td></tr>
		
		</TABLE>
	
	</td></tr>
	
	</table>

</td></tr>

</table>


