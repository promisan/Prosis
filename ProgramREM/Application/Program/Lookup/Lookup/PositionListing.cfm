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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<body leftmargin="1" topmargin="1" rightmargin="1" bottommargin="1"></body>

<cfparam name="URL.ID1" default="">
<cfparam name="URL.ID2" default="">
<cfparam name="URL.ID3" default="">
<cfparam name="URL.source" default="">
<cfparam name="URL.Mission" default="#URL.ID2#">
<cfparam name="URL.Mandate" default="#URL.ID3#">

<cfif #URL.Mandate# eq "0000">

	<cfquery name="Verify" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT TOP 1 MandateNo
	      FROM Ref_Mandate
	   	  WHERE Mission = '#Mission#'
		  ORDER BY MandateDefault DESC</cfquery>
	  
	  <cfset #URL.Mandate# = #Verify.MandateNo#>
  
</cfif>  

<cfoutput>  

<script language="JavaScript">

	function assignment(source, positionno, applicantno, personno, recordid, documentno)
	
	{
	    window.open(root + "/Staffing/Application/Assignment/AssignmentEntry.cfm?source=" + source + "&id=" + positionno + "&applicantno=" + applicantno + "&personno=" + personno + "&recordid=" + recordid + "&documentno=" + documentno, "PositionLookup");
	}
	
	function transfer(source, positionno, personno, assignmentno, positionold)
	
	{
	    window.open(root + "/Staffing/Application/Assignment/AssignmentEdit.cfm?source=" + source + "&positionno=" + positionno + "&id=" + personno + "&Caller=P&id1=" + assignmentno + "&positionold=" + positionold, "_parent");
	}
	
	function associate(source, positionno, recordid, documentno)
	
	{
	    window.open(root + "/Staffing/Application/PostMatching/PostAssociate.cfm?source=" + source + "&positionno=" + positionno + "&recordid=" + recordid + "&documentno=" + documentno, "PositionLookup");
	}
	
	<cfif #URL.Source# eq "Lookup"> 
	
		function lookupreturn(mis,postnum,funno,funct,unit,grade,position)
		
		   {	
		
		   	var form = "#trim(URL.FormName)#";
			var pst = "#URL.fldPostNumber#";
			var fno = "#URL.fldFunctionNo#";
			var fun = "#URL.fldFunction#";
			var org = "#URL.fldOrgUnit#";
		    var grd = "#URL.fldGrade#";
			var pos = "#URL.fldPosNo#";
			
			<!--- corrected again hanno --->
				
			eval("parent.opener.document." + form + "." + pst + ".value = '" + postnum + "'");
			eval("parent.opener.document." + form + "." + fno + ".value = '" + funno + "'");
			eval("parent.opener.document." + form + "." + fun + ".value = '" + funct + "'");
			eval("parent.opener.document." + form + "." + org + ".value = '" + unit + "'");
			eval("parent.opener.document." + form + "." + grd + ".value = '" + grade + "'");
			eval("parent.opener.document." + form + "." + pos + ".value =" + position);
			parent.window.close();
		    }
		
	</cfif>	

</script>
	
</cfoutput>		

<cf_wait>

<cfif #URL.Source# eq "VAC">

<!--- retrieve position --->

<cfquery name="Position" 
   datasource="AppsVacancy" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Employee.dbo.Position Post INNER JOIN
          DocumentPost D ON Post.PositionNo = D.PositionNo INNER JOIN
          Organization.dbo.Organization Org ON Post.OrgUnitOperational = Org.OrgUnit
   WHERE  D.DocumentNo = '#URL.DocumentNo#'
     AND  Org.Mission     = '#URL.Mission#'
	 AND  Org.MandateNo   = '#URL.Mandate#'
 UNION
	SELECT *
	FROM   Employee.dbo.Position Post INNER JOIN
          DocumentPost D ON Post.SourcePositionNo = D.PositionNo INNER JOIN
          Organization.dbo.Organization Org ON Post.OrgUnitOperational = Org.OrgUnit
	WHERE  D.DocumentNo = '#URL.DocumentNo#'
    AND    Org.Mission     = '#URL.Mission#'
	AND    Org.MandateNo   = '#URL.Mandate#'	  
</cfquery>

<cfinclude template="../../../../Vactrack/Application/Document/Dialog.cfm">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
	
	<TR>
	    <td height="25" colspan="7" class="top3N">&nbsp;<b>Position associate to vactrack <cfoutput>#URL.DocumentNo#</cfoutput></b></td>
	</TR>

<cfoutput query="Position">

	<tr>
		<td width="6%" align="center" height="20">
		  <a href="javascript:assignment('#URL.Source#','#PositionNo#','#URL.ApplicantNo#','#URL.PersonNo#','#URL.RecordId#','#URL.DocumentNo#')" 
		  onMouseOver="document.img1_#positionno#.src='#SESSION.root#/Images/button.jpg'" 
		  onMouseOut="document.img1_#positionno#.src='#SESSION.root#/Images/view.jpg'">
	         <img src="#SESSION.root#/Images/view.jpg" alt="" 
			 name="img1_#positionno#" 
			 id="img1_#positionno#" 
			 width="13" 
			 height="13" 
			 border="0" 
			 align="middle">
	     </a>
		 </td>
	     <TD width="50%">&nbsp;#FunctionDescription#</TD>
	     <TD width="6%">#PostGrade#&nbsp;</TD>
	     <TD width="15%">#PostType#&nbsp;</TD>
		 <TD width="10%">#SourcePostNumber#&nbsp;</TD>
	     <TD width="9%">#DateFormat(DateEffective, CLIENT.DateFormatShow)#&nbsp;</TD>
	     <TD width="9%">#DateFormat(DateExpiration, CLIENT.DateFormatShow)#&nbsp;</TD>
	</tr> 
	<tr><td height="1" colspan="7" bgcolor="E5E5E5"></td></tr> 
	
</cfoutput>	 

</table>

</cfif>

<input type="hidden" name="mission" id="mission" value="<cfoutput>#URL.Mission#</cfoutput>">

 <cfquery name="Current" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM Ref_Mandate
   WHERE Mission = '#URL.Mission#'
   AND MandateNo = '#URL.Mandate#'
</cfquery>
           
<cf_dialogOrganization>

<HTML><HEAD>
    <TITLE>Search - Search Result</TITLE>

</HEAD>

<table width="100%" border="0" cellspacing="0" cellpadding="0" rules="rows" bordercolor="gray">
   
<td width="100%" colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfif '#URL.ID1#' eq "root">
    <cfset cond = "AND (O.ParentOrgUnit is NULL or O.ParentOrgUnit = '')">
<cfelse>
    <cfset cond = "AND O.OrgUnitCode = '#URL.ID1#'">
</cfif>
 
<!--- Query returning search results --->

<cfquery name="SearchResult" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT distinct O.*
    FROM Organization O
	WHERE O.Mission   = '#URL.Mission#'
	AND O.MandateNo = '#URL.Mandate#'
	#preserveSingleQuotes(cond)#
ORDER BY O.Mission, TreeOrder
</cfquery>

<table border="0" cellpadding="0" cellspacing="0" bordercolor="#8EA4BB" width="100%">

<cfif #SearchResult.recordcount# gt "0">

<TR>
    <td height="20" class="top3N"></td>
  	<TD class="top3N">&nbsp;Description</TD>
    <TD class="top3N">Class</TD>
	<TD class="top3N">Expiration&nbsp;</TD>
</TR>
<tr><td height="10"></td></tr>

</cfif>

<cfoutput query="SearchResult" group="TreeOrder">

<tr bgcolor="FCFDBD">
   <td width="15%" class="regular">&nbsp;
     <img src="#SESSION.root#/Images/view1.jpg" alt="" name="img0_#orgunit#" id="img0_#orgunit#" width="18" height="15" border="0" align="middle" 
	 <!---onClick="Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')"--->>
      
     </td>
       <TD width="55%" class="regular"><b>#OrgUnitName#</b></TD>
       <TD width="20%" class="regular"><b>#OrgUnitClass#</b></TD>
	   <TD width="10%" class="regular"><b>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</b>&nbsp;&nbsp;</TD>	 
    </TR>
	
	<cfset #SelectOrgUnit# = #SearchResult.OrgUnit#>
	<cfinclude template="PositionListingDetail.cfm">
		
   <cfquery name="Level02" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT O.*
    FROM Organization O
	WHERE (O.ParentOrgUnit = '#SearchResult.OrgUnitCode#')
	AND O.Mission = '#URL.Mission#'
	AND O.MandateNo = '#URL.Mandate#'
	ORDER BY O.Mission, TreeOrder
   </cfquery>
   
    <cfloop query="Level02">
   
     <tr bgcolor="FDFEE0">
		
	  <td width="10%" bgcolor="FFFFFF" class="regular">&nbsp;&nbsp;&nbsp;
	      <img src="../../../../Images/view1.jpg" alt="" name="img0_#orgunit#" id="img0_#orgunit#" width="14" height="14" border="0" align="middle" 
		  <!--- onClick="Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')" --->>
   
      </td>
     <TD class="regular">#Level02.OrgUnitName#</TD>
     <TD class="regular">#Level02.OrgUnitClass#</TD>
     <TD class="regular">#DateFormat(Level02.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</TD>
     </TR> 
	 
	<cfset #SelectOrgUnit# = #Level02.OrgUnit#>
	<cfinclude template="PositionListingDetail.cfm">
	
	  <cfquery name="Level03" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT O.*
       FROM Organization O
	   WHERE (ParentOrgUnit = '#Level02.OrgUnitCode#')
       AND O.Mission = '#URL.Mission#'
       AND O.MandateNo = '#URL.Mandate#'
	   ORDER BY O.Mission, TreeOrder
    </cfquery>

    <cfloop query="Level03">
   
     <tr bgcolor="white">
		
	   <td bgcolor="FFFFFF" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         <img src="../../../../Images/view1.jpg" alt="" name="img0_#orgunit#" id="img0_#orgunit#" width="14" height="14" border="0" align="middle" 
		 <!--- onClick="Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')"--->>
       </td>
       <TD class="regular">#Level03.OrgUnitName#</font></TD>
       <TD class="regular">#Level03.OrgUnitClass#</font></TD>
	   <TD class="regular">#DateFormat(Level03.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</font></TD>
     </TR> 
	 
	 <cfset #SelectOrgUnit# = #Level03.OrgUnit#>
  	 <cfinclude template="PositionListingDetail.cfm">
	 
	 	  <cfquery name="Level04" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT O.*
       FROM Organization O
	   WHERE (ParentOrgUnit = '#Level03.OrgUnitCode#')
       AND O.Mission = '#URL.Mission#'
       AND O.MandateNo = '#URL.Mandate#'
	   ORDER BY O.Mission, TreeOrder
    </cfquery>

    <cfloop query="Level04">
   
     <tr bgcolor="white">
		
	   <td bgcolor="FFFFFF" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <img src="../../../../Images/view1.jpg" alt="" name="img0_#orgunit#" id="img0_#orgunit#" width="14" height="14" border="0" align="middle" 
		  <!--- onClick="Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')"--->>
       </td>
       <TD class="regular">#Level04.OrgUnitName#</font></TD>
       <TD class="regular">#Level04.OrgUnitClass#</font></TD>
	   <TD class="regular">#DateFormat(Level04.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</font></TD>
     </TR> 
	 
	</cfloop> 
	   
    </cfloop>
	     
    </cfloop> 
     
</CFOUTPUT>

</TABLE>
   
</table>
</table>
   
 <cf_waitEnd>

</BODY></HTML>