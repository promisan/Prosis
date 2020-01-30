<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD>
    <TITLE>History</TITLE>
</HEAD><body bgcolor="#F6F6F6" class="dialog2" onLoad="window.focus()">

<cfparam name="URL.ID2" default="0">
<cfif #URL.ID2# neq "0">
  <cfset cond = "AND VA.PersonNo = '#URL.ID2#'">
<cfelse>
  <cfset cond = "">  
</cfif>

<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>"> 

<cfquery name="SearchResult" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * FROM 
DocumentActionAction VA 
JOIN  UserAction U ON VA.UserActionNo = U.UserActionNo 
JOIN DocumentFlow A ON  A.ActionId = VA.ActionId  AND A.DocumentNo = VA.DocumentNo 
JOIN Ref_Status R ON R.Status = VA.ActionStatus
LEFT OUTER JOIN DocumentCandidate VC
ON VC.DocumentNo = VA.DocumentNo  AND VC.PersonNo = VA.PersonNo 
WHERE 
VA.DocumentNo   = '#URL.ID#' 
AND VA.ActionId     = '#URL.ID1#' #preserveSingleQuotes(cond)#
AND R.Class = 'Action'


--SELECT *
--FROM DocumentActionAction VA, 
--     DocumentCandidate VC,
--     UserAction U, 
--	 DocumentFlow A, 
--	 Ref_Status R
--WHERE VA.UserActionNo = U.UserActionNo
--AND VA.DocumentNo   = '#URL.ID#' 
--AND VA.ActionId     = '#URL.ID1#' #preserveSingleQuotes(cond)#
--AND A.ActionId      = VA.ActionId
--AND A.DocumentNo    = VA.DocumentNo
--AND VC.DocumentNo   =* VA.DocumentNo
--AND VC.PersonNo     =* VA.PersonNo 
--AND R.Class         = 'Action'
--AND R.Status        = VA.ActionStatus
</cfquery>

<cfif SearchResult.recordCount eq 0>

<script language="JavaScript">
  alert("No history found")
  window.close()
</script>

<cfelse>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" bgcolor="#FFFFFF">
  <tr>
    <td height="30" class="BannerN">
	<b><font color="#FFFFFF">&nbsp;Step:&nbsp;<cfoutput>#SearchResult.ActionDescription#</cfoutput></font></b>
	</td>
	<td align="right" class="BannerN">
	<input type="button" class="input.button1" name="Print" value=" Print " onClick="window.print()">
    <input type="button" class="input.button1" name="Close" value=" Close " onClick="window.close()">
	&nbsp;
	</td>
    
  </tr>

  <tr><td colspan="2">

  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
	  	
  <tr align="center" bgcolor="#6688AA">
    <TD align="left" class="topN">&nbsp;&nbsp;Action Date</TD>
    <TD align="left" class="topN">Officer</TD>
    <TD align="left" class="topN">Action</TD>
	<TD align="left" class="topN">Effective</TD>
    <TD align="left" class="topN">Candidate</TD>
    <TD align="left" class="topN">Memo</TD>
    </TR>

 <cfset No = 0>	
  <cfoutput query="SearchResult">	
  
  <cfset No = No + 1>
  
  <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#">
  <TD align="left" class="regular">&nbsp;&nbsp;#Dateformat(ActionSubmitted, CLIENT.DateFormatShow)#</TD>
  <TD align="left" class="regular">#OfficerUserFirstName# #OfficerUserLastName#</TD>
  <TD align="left" class="regular">#Description#</TD>
  <TD align="left" class="regular">#Dateformat(ActionDateActual, CLIENT.DateFormatShow)#</TD>  
  <TD align="left" class="regular">#FirstName# #LastName#</TD>
  <TD align="left" class="regular">#ActionMemo#</TD>
  </TR>
  <tr><td colspan="6" bgcolor="C0C0C0"></td></tr>
   </CFOUTPUT>
   
   <cfloop index="Line" from="#No#" to="16">
   <tr><td class="regular">&nbsp;</td></tr>
   <tr><td colspan="6" bgcolor="C0C0C0"></td></tr>
   </cfloop>

</TABLE>

</td></tr>

</table>

</cfif>

</BODY></HTML>