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

Modification History:
30Apr04 - added code to handle display of DocumentCandidate remarks (#CandidateRemarks#) as a third line
	    - in the listing view (had to modify Vacancy.spActionTravelListing stored proc to add this field in SELECT
--->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!--- tools : prevent caches, disabled back button --->
<cf_PreventCache>
<div class="screen">
<cf_Wait text="Preparing 1 of 4">
<HTML><HEAD><TITLE>Document Listing</TITLE></HEAD>

<cfoutput>
<script>

function reloadForm(layout,last,index,group,page,mission,status,fill,inbox) {

if (layout !== "Vacancy") {
   window.location="DocumentListingTravel.cfm?IDLayout=" + layout + 
"&IDLastName=" + last + "&IDIndexNo=" + index + "&IDInbox=" + inbox + 
"&IDClass=" + fill + "&IDSorting=" + group + "&Page=" + page + "&IDMission=" 
+ mission + "&IDStatus=" + status;
} else {
    window.location="DocumentListing.cfm?IDInbox=" + inbox + "&IDClass=" + 
fill + "&IDMission=" + mission + "&IDStatus=" + status;
}

}

function clearname() {
document.forms.result.slast.value = ""
}

function clearno() {
document.forms.result.sindex.value = ""
}

function search(){
if (window.event.keyCode == "13") {
 document.forms.result.submitgo.click()
}

}


</script>
</cfoutput>

<!--- tools : make available javascript for quick reference to dialog 
screens --->
<cf_dialogStaffing>
<cfinclude template="../../Application/Document/Dialog.cfm">

<cfparam name="URL.IDInbox"    default="false">
<cfparam name="URL.IDStatus"   default="0">
<cfparam name="URL.IDClass"    default="">
<cfparam name="URL.IDSorting"  default="LastName">
<cfparam name="URL.IDLayout"   default="Detail">
<cfparam name="URL.IDLastName" default="">
<cfparam name="URL.IDIndexNo"  default="">

<!--- dropdown --->
<cfquery name="Status"
datasource="AppsVacancy"
username="#SESSION.login#"
password="#SESSION.dbpw#"
cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT *
	FROM  Ref_Status
	WHERE Class = 'Document'
</cfquery>

<!---

<!--- dropdown --->
<!--- Adjusted Query Class to retrieve only active Vacncy Tracks done by CH 27/04/2004 --->
<cfquery name="Class"
datasource="AppsVacancy"
username="#SESSION.login#"
password="#SESSION.dbpw#"
cachedWithin="#CreateTimeSpan(0,0,2,0)#">
    SELECT *
	FROM  FlowClass
	where FlowClass.Operational = '1'
</cfquery>
--->

<cfquery name="Mission"
datasource="AppsOrganization"
username="#SESSION.login#"
password="#SESSION.dbpw#">
SELECT DISTINCT Mission
FROM Ref_MissionModule m
where m.SystemModule = 'Vacancy'
AND Mission IN (SELECT Mission FROM Ref_Mission WHERE Operational = 1)
Order by m.Mission  
</cfquery>

<!--- define database filter criteria --->

<cfparam name="URL.IDMission" default="%%">

<cfif URL.IDMission neq "">
    <cfset actmission = #URL.IDMission#>
<cfelse>
	<cfset actmission = "">
</cfif>

<cfif #URL.IDClass# neq "">
    <cfset actclass = #URL.IDClass#>
<cfelse>
	<cfset actclass = "%%">
</cfif>

<cfif URL.IDLastName neq ''>
    <cfset actlast = "#URL.IDLastName#">
<cfelse>
	<cfset actlast = "">
</cfif>

<cfif URL.IDIndexNo neq ''>
    <cfset actindex = "#URL.IDIndexNo#">
<cfelse>
	<cfset actindex = "">
</cfif>

<!---  select first only the candidates that meet the condition for the view --->

<cfset FileNo = "">

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Candidate"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#LastStep">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Select">

<cf_waitEnd>	
<cf_Wait text="Preparing 2 of 4">

<!--- selected candidate 
       
		  1. Selected
		  2. Track initiated
		  
		  --->
		  

	<cfquery name="Step1"
	datasource="AppsVacancy"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT  DISTINCT VA.DocumentNo, 
	        VA.PersonNo, 
			A.IndexNo, 
			'1' as Track
	 INTO   userQuery.dbo.#SESSION.acc#Candidate		
	 FROM   DocumentCandidate VA,
	        Applicant.dbo.Applicant A
	 WHERE  VA.EntityClass is not NULL  
	 AND    VA.Status = '2s'
	 <cfif actIndex neq "">
	 AND    A.IndexNo LIKE '%#actIndex#%'
	 </cfif>
	 <cfif actLast neq "">
	 AND    A.LastName LIKE '%#actLast#%'
	 </cfif>
	  <cfif actMission neq "">
	 AND    VA.DocumentNo IN (SELECT DocumentNo FROM Document WHERE Mission = '#actMission#')
	 </cfif>
	 AND    A.PersonNo = VA.PersonNo
	</cfquery>

	<!--- identify last step for the candidate --->
	
	<!--- 1. last step of candidate 
	      2. description 
	--->
	
	<cfquery name="Step2a"
	datasource="appsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#"> 
	SELECT    OA.ObjectId, 
			  O.ObjectKeyValue1,
			  O.ObjectKeyValue2,
			  MAX(OA.ActionFlowOrder) AS ActionOrderSub,
			  MAX(OA.ActionCode) as ActionCode,
			  VC.PersonNo, 
		      VC.LastName, 
	          VC.FirstName, 
		      C.IndexNo, 		     
		      VC.Remarks
	INTO      userQuery.dbo.#SESSION.acc#LastStep	  
	FROM      OrganizationObjectAction OA,
	          OrganizationObject O, 
			  userQuery.dbo.#SESSION.acc#Candidate C,
			  Vacancy.dbo.DocumentCandidate VC
	WHERE     OA.ObjectId = O.ObjectId
     AND      OA.ActionStatus <> '0'
	 AND      O.ObjectKeyValue1 = C.DocumentNo
	 AND      O.ObjectKeyValue2 = C.PersonNo
	  AND     O.ObjectKeyValue1 = VC.DocumentNo
	 AND      O.ObjectKeyValue2 = VC.PersonNo
	 AND      O.EntityCode = 'VacCandidate'
	 AND      O.Operational  = 1
    GROUP BY  OA.ObjectId, 
	          O.ObjectKeyValue1, 
			  O.ObjectKeyValue2,  
	          VC.PersonNo, 
		      VC.LastName, 
	          VC.FirstName, 
		      C.IndexNo, 		    
		      VC.Remarks 
	</cfquery>
	
	<cf_waitEnd>		
	<cf_Wait text="Preparing 3 of 4">	
	
    <!--- search candidates last step details --->

	<cfquery name="Step3"
	datasource="AppsVacancy"
	username="#SESSION.login#"
	password="#SESSION.dbpw#"> 
		
	SELECT    DISTINCT V.*, 
	          S.PersonNo, 
			  S.LastName, 
			  S.FirstName, 
			  S.IndexNo, 
			  <!---
			  S.DateArrivalExpected, 
			  S.ReAssignmentFrom, 
			  --->
			  S.Remarks AS CandidateRemarks,
			  OA.ActionFlowOrder as ActionOrder, 
			  R.ActionCompleted, 
			  OA.ActionFlowOrder as ActionOrderSub, 
			  OA.ActionStatus, 
			  OA.OfficerLastName as ActionLastName, 
			  OA.OfficerFirstName as ActionFirstName, 
			  OA.OfficerDate as ActionDate, 
			  'Travel' as ActionArea
	INTO      userQuery.dbo.#SESSION.acc#Select				  
	FROM      Organization.dbo.OrganizationObjectAction OA,
	          Organization.dbo.Ref_EntityActionPublish R, 
			  userQuery.dbo.#SESSION.acc#LastStep S,
			  Document V
	WHERE     S.ObjectId       = OA.ObjectId
     AND      S.ActionOrderSub = OA.ActionFlowOrder
	 AND      S.ActionCode = OA.ActionCode
	 AND      OA.ActionCode = R.ActionCode
     AND      OA.ActionPublishNo = R.ActionPublishNo
	 AND      S.ObjectKeyValue1 = V.DocumentNo
	 <cfif url.idsorting eq "Created" or url.idsorting eq "Mission">
	 ORDER BY V.#URL.IDSorting# 
	 <cfelse>
	 ORDER BY #URL.IDSorting# 
	 </cfif>	 
	</cfquery> 
		
	<cf_waitEnd>	
	<cf_Wait text="Preparing 4 of 4">	
	
	<cfquery name="SearchResult"
	datasource="appsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#"> 
	SELECT *
	FROM #SESSION.acc#Select V LEFT OUTER JOIN Employee.dbo.skPersonContract P ON V.IndexNo = P.IndexNo
	WHERE V.Mission IN (SELECT Mission 
	                  FROM   Organization.dbo.Ref_Mission 
					  WHERE  Operational = 1)
	  <cfif url.idsorting eq "Created" or url.idsorting eq "Mission">
	 ORDER BY V.#URL.IDSorting# 
	 <cfelse>
	 ORDER BY #URL.IDSorting# 
	 </cfif>	
    </cfquery>
	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp1"> 
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp10">
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#tmp11">
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#sup1">	


<!--- Query returning search results --->

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="javascript:document.forms.result.page.focus();">

<form name="result" id="result">

<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" rules="cols">

<tr>
<td height="25">&nbsp;

<!--- dropdown to select a different mission --->
    <select name="mission" style="background: #ffffff; color: black;" accesskey="P" title="Status Selection" style="font:10px"
	onChange="javascript:reloadForm(lay.value,slast.value,sindex.value,group.value,1,this.value,status.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	<!---
      <option value="" <cfif '#URL.IDMission#' eq "">selected</cfif>>[all missions]</option>
	  --->
	  
      <cfoutput query="Mission">
	  
	   <cfinvoke component="Service.Access"  
		          method="vacancytree" 
		    	  mission="#Mission#"
			      returnvariable="accessTree">
				  
			<cfif AccessTree neq "NONE">
					 <option value="#Mission#" <cfif #Mission# is '#URL.IDMission#'>selected</cfif>>#Mission#</option>
		    </cfif>		  
			      
      </cfoutput>
    </select>
	
	<!--- drop down to filter on a document status --->
	<select name="status" style="background: #ffffff;" accesskey="P" style="font:10px" 
	title="Status Selection"
	onChange="javascript:reloadForm(lay.value,slast.value,sindex.value,group.value,1,mission.value,this.value,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
	    <cfoutput query="Status">
		<option value="#Status#" <cfif #Status# is URL.IDStatus>selected</cfif>>
		#Description#</option>
		</cfoutput>
	    </select>
	
	<!--- drop down to select a action class list --->
	<select name="fill" style="background: #ffffff;" accesskey="P" title="Status Selection" style="font:10px"
	onChange="javascript:reloadForm(lay.value,slast.value,sindex.value,group.value,page.value,mission.value,status.value,this.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
	    <option value="" <cfif '#URL.IDClass#' eq "">selected</cfif>>
		All
		</option>
		<!---
	    <cfoutput query="Class">
		<option value="#ActionClass#" <cfif #ActionClass# is '#URL.IDClass#'>selected</cfif>>
		#Description#</option>
		</cfoutput>
		--->
	    </select>
	
	<!--- drop down to order the screen list --->
	<select name="group" size="1" style="background: #ffffff;" style="font:10px"
	onChange="reloadForm(lay.value,slast.value,sindex.value,this.value,1,mission.value,status.value,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
		 <OPTION value="LastName" <cfif #URL.IDSorting# eq 
	"LastName">selected</cfif>>Sort by LastName
	     <OPTION value="Created" <cfif #URL.IDSorting# eq 
	"Created">selected</cfif>>Sort by Vacancy Creation date
	     <option value="Mission" <cfif #URL.IDSorting# eq 
	"Mission">selected</cfif>>Group by Mission
		 <option value="ActionOrder" <cfif #URL.IDSorting# eq 
	"A.ActionOrder">selected</cfif>>Group by Status
	     <OPTION value="PostGrade" <cfif #URL.IDSorting# eq 
	"PostGrade">selected</cfif>>Group by Post grade
		 <OPTION value="DocumentNo" <cfif #URL.IDSorting# eq 
	 "DocumentNo">selected</cfif>>Sort by Document No
	
	</SELECT>

</TD>
<td align="right">

<!--- drop down to select only a number of record per page using a tag in 
tools --->
    <cfinclude template="../../../Tools/PageCount.cfm">
<select name="page" size="1" style="background: #ffffff;" style="font:10px"
onChange="javascript:reloadForm(lay.value,slast.value,sindex.value,group.value,this.value,mission.value,status.value,fill.value,<cfoutput>'#URL.IDInbox#'</cfoutput>)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq 
"#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
    </cfloop>
</SELECT> &nbsp;
</TD>
</tr>

<tr><td colspan="2" bgcolor="silver"></td></tr>

<cfif SearchResult.recordcount gt 300>
<tr><td colspan="2" height="20" bgcolor="FF0000"><font color="FFFFFF">&nbsp;<b><cfoutput>#SearchResult.recordcount#</cfoutput> people in travel status ? </td></tr>  
</cfif>
<TR>

<td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr>

<td colspan="6">
   <font size="1" face="Verdana"><b>&nbsp;&nbsp;&nbsp;Name:</b>
   <input class="regular" type="text" name="slast" 
   value="<cfoutput>#URL.IDLastName#</cfoutput>" size="15" 
   onClick="javascript:clearname()" onKeyUp="javascript:search()">

   <font size="1" face="Verdana"><b>&nbsp;&nbsp;&nbsp;IndexNo:</b>
   <input class="regular" type="text" name="sindex" 
   value="<cfoutput>#URL.IDIndexNo#</cfoutput>" size="8" 
   onClick="javascript:clearno()" onKeyUp="javascript:search()">
   <input type="button" name="submitgo" value="Go" class="button7"
   onClick="javascript:reloadForm(lay.value,slast.value,sindex.value,group.value,1,mission.value,result.status.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
</td>
	<td colspan="4" align="right">
	  <input type="radio" name="layout" value="Listing"
    <cfif "Listing" is '#URL.IDLayout#'>checked</cfif>
	onClick="javascript:reloadForm(this.value,slast.value,sindex.value,group.value,page.value,mission.value,result.status.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	Listing&nbsp;
	 <input type="radio" name="layout" value="Detail"
    <cfif "Detail" is '#URL.IDLayout#'>checked</cfif>
	onClick="javascript:reloadForm(this.value,slast.value,sindex.value,group.value,page.value,mission.value,result.status.value,fill.value,<cfoutput>'#URL.IdInbox#'</cfoutput>)">
	Detail&nbsp;<input type="hidden" name="lay" value="<cfoutput>#URL.IDLayout#</cfoutput>">

	</td>

</tr>

<tr bgcolor="d4d4d4">
    <td width="26%" colspan="4">&nbsp;Name</td>
	<TD width="8%">IndexNo</TD>
	<TD width="7%" align="left">Level</TD>
	<TD width="10%">Reass.from</TD>
	<td colspan="3" align="right">Action last completed&nbsp;</td>
</TR>

<cfif URL.IDLayout eq "Detail">
    <tr bgcolor="f0f0f0">
		<td>&nbsp;VA</td>
		<TD colspan="5">TrackNo</td>
		<TD>Mission</TD>
		<TD>ETA</TD>
	    <TD>Officer</TD>
		<td>Date</td>
		
    </TR>
</cfif>

<cfset vac     = "0">
<cfset action  = "9999">
<cfset amtT    = 0>

<cfoutput query="SearchResult" group="#URL.IDSorting#" startrow="#first#" maxrows=#No#>

   <cfset amt    = 0>

   <tr bgcolor="f6f6f6">

   <cfswitch expression = #URL.IDSorting#>
     <cfcase value = "DueDate">
     <td colspan="10"><font face="Verdana"><b>&nbsp;#Dateformat(Duedate, "#CLIENT.DateFormatShow#")#</b></font></td>
     </cfcase>
     <cfcase value = "Created">
     <td colspan="10"><font face="Verdana"><b>&nbsp;#Dateformat(Created, "#CLIENT.DateFormatShow#")#</b></font></td>
     </cfcase>
     <cfcase value = "A.ActionOrder">
     <!--- <td colspan="9"><font face="Tahoma" 
size="2"><b>&nbsp;#Dateformat(Duedate, 
"#CLIENT.DateFormatShow#")#</b></font></td>--->
     </cfcase>
     <cfcase value = "Mission">
     <td colspan="10"><font face="Verdana"><b>&nbsp;#Mission#</b></font></td>
     </cfcase>
     <cfcase value = "DocumentNo">
     <!--- <td colspan="10"><font face="Tahoma" 
size="2"><b>&nbsp;#Mission#</b></font></td>  --->
     </cfcase>
     <cfcase value = "LastName">
     <!--- <td colspan="10"><font face="Tahoma" 
size="2"><b>&nbsp;#LastName#</b></font></td>  --->
     </cfcase>
     <cfcase value = "PostGrade">
	 <td colspan="10"><font face="Verdana"><b>&nbsp;#PostGrade#</b></font></td>
     </cfcase>
   </cfswitch>

   </tr>

<CFOUTPUT>

	<tr bgcolor="C0C0C0"><td height="1" colspan="10"></td></TR>
    <cfif URL.IDLayout eq "Detail">
	<TR bgcolor="F2F2F2">
	<cfelse>
	<TR bgcolor="ffffff">
	</cfif>
	
	<cfset Amt = Amt + 1>
    <cfset AmtT = AmtT + 1>

	<cfif Status neq "1">

	<cfif URL.IDLayout eq "Detail">

    	 <td colspan="4">
	      <font color="000080">
		  <A HREF ="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#')">#LastName#, #FirstName#</a>
    	 </td>
		
		 <td colspan="1">
		   <cfif IndexNo neq "">
	       	<font color="000080"><a href="javascript:EditPerson('#IndexNo#')">#IndexNo#</a>
		   </cfif>
         </td>
				
		 <td colspan="1">
		    #ContractLevel#<cfif ContractStep neq "">/#ContractStep#</cfif>
		 </td>
		 
		 <td colspan="1">
	       <!--- #ReassignmentFrom# --->
         </td>
		
    	<td colspan="3" align="right">
    	  <cfif #Status# eq "0">&nbsp;#ActionCompleted#&nbsp;</cfif>
    	</td>

	<cfelse>

	   	<td colspan="4" height="20">
		 <A HREF ="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#')">&nbsp;#LastName#, #FirstName#</a> 
	    </td>
		
		<td width="60">
		   <cfif IndexNo neq "">
	       <a href="javascript:EditPerson('#Indexno#')">#IndexNo#</a>
		   </cfif>
        </td>
		 
		<td width="60">
		   #ContractLevel#<cfif ContractStep neq "">/#ContractStep#</cfif>
        </td>
		 
		<td  width="60"><!--- #ReassignmentFrom# ---> </td>

    	<td colspan="3" align="right">
        	<cfif #Status# eq "0">&nbsp;#ActionCompleted#&nbsp;</cfif>
    	</td>

	</cfif>

    </tr>
    </cfif>

	<cfif #URL.IDLayout# eq "Detail">
		<TR bgcolor="white">
			<Td>
			<img src="#SESSION.root#/Images/bullet.png" alt="Open track" border="0" align="absmiddle" style="cursor: pointer;" onClick="javascript:showdocument('#DocumentNo#','ZoomIn')">&nbsp;
			<a href="javascript:showdocument('#DocumentNo#')">#FunctionalTitle# #PostGrade#</a></TD>
			<td colspan="5">#documentNo#</td>
		    <TD><cfif #URL.IDMission# neq #Mission#><b>#Mission#</cfif></TD>
			<TD>
			<!---
			 <cfif #Status# eq "0"><b>#DateFormat(DateArrivalExpected, CLIENT.DateFormatShow)#&nbsp;</b></cfif>
			---> 
			</TD>
		    <TD>#ActionFirstName# #ActionLastName#</TD>
		    <td>#Dateformat(ActionDate, "#CLIENT.DateFormatShow#")#&nbsp;</td>
			
	    </TR>
	</cfif>

	<!--- added 30 Apr 04 (MM) - to show candidate comments in the travel view --->
	<!--- had to make modifications to the spActionListingTravel proc in Vacancy --->
	<cfif CandidateRemarks NEQ "" and URL.IDLayout eq "Detail">
		<tr bgcolor="ffffef">
		    <td></td>
			<td colspan="9">#CandidateRemarks#</td>	
		</tr>
	</cfif>
	<!--- end of new code added 30 Apr 04 (MM) --->
	
	<cfset vac    = DocumentNo>
	<cfset action = ActionOrder>

</CFOUTPUT>

<cfif URL.IDSorting neq "DocumentNo" and URL.IDSorting neq "LastName" >

   <TR>
    <td colspan="9" align="center">
	<td align="right"><hr></td>
   </TR>

   <TR>
    <td colspan="9" align="center">
	<td align="right"><font size="1" face="Verdana"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>
   </TR>

<tr><td height="1" colspan="10"></td></tr>

</cfif>

</CFOUTPUT>
  
   <TR bgcolor="f7f7f7">
    <td colspan="10">&nbsp;Records:<font face="Verdana"><b>
	<cfoutput>#NumberFormat(AmtT,'_____,__')#</cfoutput></b></font></td>
  </TR>

</TABLE>

</td></tr>

</TABLE>

</td></tr>

</table>

</form>

<cf_waitEnd>


<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Candidate"> 
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#LastStep">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Select">

</BODY></HTML>
