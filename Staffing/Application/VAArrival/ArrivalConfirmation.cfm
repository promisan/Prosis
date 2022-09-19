
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

<!---

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
<!--- Hanno 27/10/2014 need to tune this query so it will show only if the last step has been reached --->
<!--- ----------------------------------------------------------------------------------------------- --->

<cfquery name="SearchResult"
datasource="AppsVacancy"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT    DISTINCT 
	          VA.DocumentNo, 
	          V.PostGrade, 
			  V.FunctionalTitle, 
			  VA.PersonNo, 
			  A.*,
			  (SELECT PositionNo FROM Employee.dbo.Position WHERE Positionno = VP.Positionno) as PositionLink
	FROM      Document V,
		      DocumentCandidate VA,
		      Applicant.dbo.Applicant A,
		      DocumentPost VP
	WHERE     V.DocumentNo = VA.DocumentNo
	 AND      V.Status     = '0'
	 AND      V.Mission    = '#URL.ID1#'
	 AND      V.DocumentNo = VP.DocumentNo
	 AND      VP.PositionNo is not NULL
	 AND      VA.Status    = '2s'
	 AND      VA.EntityClass is NOT NULL
	 AND      A.PersonNo   = VA.PersonNo
	 
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
		
			<tr class="labelmedium linedotted fixlengthlist">
			    <TD></TD>
			    <TD>Name</TD>
				<TD align="left">IndexNo</TD>
				<TD width="7%" align="left">Grade</TD>
				<TD align="left">Track No</TD>
				<TD width="40%" align="left">Functional title</TD>
				<td align="right">Action</td>
			</TR>
					
			<cfoutput query="SearchResult">
			
			<tr class="labelmedium navigation_row linedotted fixlengthlist">
			    <td height="20" style="padding-right:5px">#currentRow#.</td>
			    <TD><a href="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#')">#LastName#, #FirstName#</a></TD>
				<TD align="left"><a href="javascript:ShowPerson('#IndexNo#')"><font color="0080C0">#IndexNo#</a></TD>					
				<td colspan="1" align="left">
				      <!--- #Level.ContractLevel#/#Level.ContractStep# ---> #PostGrade#
			    </td>
				<TD align="left"><a href="javascript:showdocument('#documentNo#')"><font color="0080C0">#DocumentNo#</a></TD>
				<td align="left">#FunctionalTitle#</td>
				<td align="right" style="padding-top:3px">	
				
				<cfif PositionLink neq "">
				<cf_img icon="open" 
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


