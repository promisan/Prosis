<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD>
    <TITLE>Vacancy actions</TITLE>
</HEAD><body leftmargin="3" topmargin="3" rightmargin="3">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfinclude template="../Position/PositionViewHeader.cfm">

<!--- Query returning search results --->

<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT SourcePostNumber
FROM  Position
WHERE PositionNo = '#URL.ID#'
  </cfquery>

 <cfquery name="Vacancy" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT D.*
FROM   DocumentPost P, Document D
WHERE P.DocumentNo = D.DocumentNo
AND   ((P.PostNumber = '#Position.SourcePostNumber#' AND P.PostNumber > '') OR P.PositionNo = '#URL.ID#')
AND   D.Status IN ('0','1')
ORDER BY D.Created DESC
    </cfquery>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" class="formpadding">
  <tr>
    <td width="100%" height="24" class="top3n">&nbsp;
	<b>Vacancy action</b>
	</td>
	<cfoutput>
    <td align="right" class="top3n">
	
    </td>
	</cfoutput>
   </tr>
   <tr>
  <td width="100%" colspan="2">
  <table border="0" cellpadding="0" cellspacing="0" bordercolor="#111111" width="100%">
	
    <cfset last = '1'>
	
	<cfif Vacancy.recordcount eq "0">
		<tr><td colspan="7" align="center" class="regular"><b>No Vacancy actions found!</b></td></tr>
		<cfabort>
	</cfif>
	
	<TR>
       <td width="4%" align="center" class="top4N"></td>
       <td width="28%" align="left" class="top4N">Function</td>
       <TD width="10%" align="left" class="top4N">Grade</TD>
	   <TD width="20%" align="left" class="top4N">VA No</TD>
	   <TD width="10%" align="left" class="top4N">Status</TD>
	   <TD width="10%" align="left" class="top4N">Issued</TD>
	   <TD width="20%" align="left" class="top4N">Officer</TD>
    </TR>

    <cfoutput query="Vacancy">
   
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F6F6F6'))#">
   	   <td align="center">
	    <a href="javascript:showdocument('#Vacancy.DocumentNo#','ZoomIn')" 
    		onMouseOver="document.img0_#documentno#.src='#SESSION.root#/Images/button.jpg'" 
	    	onMouseOut="document.img0_#documentno#.src='#SESSION.root#/Images/alert.jpg'">
         <img src="#SESSION.root#/Images/alert.jpg" alt="" name="img0_#documentno#" 
		 width="14" height="14" border="0" align="middle">
        </a>
	   </td>	
       <td align="left" class="regular">#FunctionalTitle#</A></td>
       <TD align="left" class="regular">#PostGrade#</A></TD>
	   <TD align="left" class="regular">#DocumentNo#</TD>
   	   <TD align="left" class="regular"><cfif #Status# eq "0">Pending<cfelse>Completed</cfif></TD>
	   <TD align="left" class="regular">#dateFormat(Created, CLIENT.DateFormatShow)#</TD>
	   <TD align="left" class="regular">#OfficerUserFirstName# #OfficerUserLastName#</TD>
	   
	 </tr>
	 <cfif #Remarks# neq "">
     <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F6F6F6'))#">
     <td colspan="2"></td><td colspan="9" align="left" class="regular"><b>#Remarks#&nbsp;</b></td></tr>
     </cfif>
    </tr>
     
  </cfoutput>

   </TABLE>

   </td>

</table>

</BODY></HTML>