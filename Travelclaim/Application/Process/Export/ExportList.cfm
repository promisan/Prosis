
<HTML><HEAD>
<TITLE>F.10 portal IMIS export files</TITLE>
</HEAD><body leftmargin="0" topmargin="0" rightmargin="0" bgcolor="FfFfFf" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<div class="screen">

<cfoutput>

<script language="JavaScript">
	
	function cancel(no) {
	window.location = "ExportListDelete.cfm?id="+no+"&string=#CGI.QUERY_STRING#"
	}
	
	function exportfile() {
	
	 count = 0
	 temps = ''
	 se = document.getElementsByName("select")
	 while (se[count]) {
		  if (se[count].checked == true) {
		  if (temps == '') {  
		    temps = se[count].value
		  } else {  
		    temps = temps+","+se[count].value}
		  }
		 count++ 
	  }		
	 window.location = "Export.cfm?select="+temps+"&string=#CGI.QUERY_STRING#"
	}
	
	function mergefile() {
	window.location = "../Merge/Upload.cfm?string=#CGI.QUERY_STRING#"
	}
	
	w = #CLIENT.width# - 70;
		h = #CLIENT.height# - 160;
	
	function showclaim(id0,id1,id2)	{
	  window.open("../../FullClaim/FullClaimView.cfm?home=close&ClaimId="+id1+"&RequestId="+id2,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes");
	}

</script>

</cfoutput>

<cfquery name="Parameter" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   Parameter
</cfquery>

<cfquery name="Pending" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    R.Status, 
          R.Description, 
		  COUNT(DISTINCT C.DocumentNo) AS Claim, 
		  SUM(CL.AmountClaimBase) AS Amount
FROM      Claim C,
		  ClaimLine CL,
		  Ref_Status R 
WHERE     C.ExportNo IS NULL <!--- not exported yet ---> 
AND       C.ActionStatus = R.Status
AND       C.ClaimId = CL.ClaimId
AND       R.StatusClass = 'TravelClaim' 
AND       C.ActionStatus IN ('1', '2', '3')
GROUP BY R.Status, R.Description
ORDER BY R.Status, R.Description  
</cfquery>

<cfquery name="Get" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP 60 *
FROM   stExportFile 
WHERE ActionStatus != '9'
ORDER BY ExportNo DESC
</cfquery>
				

<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center" bordercolor="C0C0C0" frame="hsides">

<tr><td align="center">
<table border="0" width="99%" cellspacing="0" align="center" cellpadding="0" bordercolor="#D4D4D4" frame="hsides" rules="none">
<tr><td height="50" align="left"><b>
<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/exchange.jpg" alt="" border="0">
<font size="2">&nbsp;Portal Exchange Manager</td></tr>
</table>
</td></tr>

<cfif Pending.recordcount neq "0">
<tr><td>
	<table width="98%" border="1" cellspacing="1" cellpadding="1" align="center" bordercolor="D4D4D4" bgcolor="ECF5FF" frame="hsides">
		
		<tr>
		
		<cfoutput query="Pending">
		<td width="250"
	    height="20"
	    colspan="2"
	    style="border-left: 0px solid Silver;border-bottom: 0px solid Silver;">&nbsp;&nbsp;<cfif #Status# eq "3">
		<img src="#SESSION.root#/Images/export.gif" alt="" border="0" align="absmiddle">
		&nbsp;<b>Ready for export</b><cfelse>#Description#</cfif></td>
		</cfoutput>		
		</tr>
		<tr>
		
		<cfoutput query="Pending">
		  <td width="100" height="20" style="border-left: 0px solid Silver;">&nbsp;&nbsp;Quantity:</td>
		  <td colspan="1" bgcolor="white">#Claim# claim<cfif #claim# neq "1">s</cfif></td>
		</cfoutput>		
		</tr>
		
		<tr>
		<cfoutput query="Pending">
		  <td height="20" style="border-left: 0px solid Silver;">&nbsp;&nbsp;Amount:</td>
		  <td colspan="1" bgcolor="white">#numberFormat(Amount, "__,__.__")#</td>
		</cfoutput>
		</tr>		
		
	  </table>
	  </td>
  </tr>
  
</cfif>

<tr><td>

<cfinclude template="ExportListClaim.cfm">

</td></tr>

<!--- check claim in export table, which has not been tagged in the Claim table --->

<cfquery name="Alert" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT DocumentNo
FROM     stExportFileLine
WHERE    DocumentNo NOT IN
           (SELECT     DocumentNo
            FROM          Claim
            WHERE      ExportNo IS NOT NULL)
</cfquery>			

    <cfif Alert.recordcount gte "1">
		
	<tr><td>
		<table width="99%" border="1" cellspacing="2" cellpadding="2" align="center" bordercolor="silver" bgcolor="FFf1f1" frame="hsides"  rules="none">
	
		<tr><td align="center">
		<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/alert_stop.gif" alt="" border="0" align="absmiddle">
		<font color="FF0000"><b>The system detected <cfoutput>#Alert.recordcount#</cfoutput> claim <cfif alert.recordcount gt "1">s</cfif> that appear<cfif alert.recordcount eq "1">s</cfif> to have been exported already. 
		</td></tr>
		<tr><td align="center">
		<cfoutput query="alert">#DocumentNo#</cfoutput>
		</td></tr>
		
		</table>
		
		</td>
	</tr>	
	
	</cfif>
	
<cfoutput>	

<cftry>

<cfquery name="Check" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    *
FROM      IMP_CLAIM I INNER JOIN
          Claim P ON I.ext_ref_num = 'TCP' + P.DocumentNo
WHERE     P.ActionStatus = '3'
</cfquery>
		
	<cfif Check.recordcount eq "1">
		
	<tr><td>
		<table width="99%"
       border="1"
       cellspacing="2"
       cellpadding="2"
       align="center"
       bordercolor="D4D4D4"
       bgcolor="E1FFE1"
       frame="border" rules="none">
	
		<tr><td align="center">
		<img src="#SESSION.root#/Images/finger.gif" alt="" border="0" align="absmiddle">
		The system detected one or more (approved) claims ready to be notified to the claimant. 
		</td></tr>
		<tr><td align="center">
		 <input type="button" 
		        style="width:260px" 
				class="buttonFlat" 
				name="Prepare" 
				value="Claimant Notification and Portal Migration" 
				onclick="mergefile()">
				
		</td></tr>
		
		</table>
		
		</td>
	</tr>	
	
	</cfif>
	
<cfcatch></cfcatch>	

</cftry>
	
</cfoutput>

<cfquery name="Export" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP 60 *
FROM   stExportFile 
ORDER BY ExportNo DESC
</cfquery>

<cfquery name="Lines" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP 60 ExportNo,count(DISTINCT DocumentNo) as Claim
FROM   stExportFileLine
GROUP BY ExportNo
ORDER BY ExportNo DESC
</cfquery>

<cfquery name="Get" 
dbtype="query">
SELECT *
FROM   Export,Lines
WHERE Export.ExportNo = Lines.ExportNo
ORDER BY ExportNo DESC</cfquery>


<tr><td>
<table width="98%" align="center" border="0" cellspacing="1" cellpadding="1" rules="none" frame="hsides" bordercolor="silver">

<tr><td height="20" colspan="10" align="left">
<cfoutput>
<img src="#SESSION.root#/Images/agent.gif" alt="" border="0" align="absmiddle">
&nbsp;<b>Export files library</td></tr>
</cfoutput>
<tr><td height="1" colspan="10" bgcolor="silver"></td></tr>
<tr>
  <td>No</td>
  <td>File name</td>
  <td>Reference</td>
  <td>Status</td>
  <td>Officer</td>
  <td>Created</td>
  <td align="right">No.</td>
  <td align="right">Lines</td>
  <td align="right">Amount</td>
  <td width="30" align="center">St</td>
</tr>

<script language="JavaScript">

function output(id) {
 window.open("ExportOutput.cfm?id="+id,"DialogWindow", "width=860, height=760, status=no,toolbar=no,scrollbars=no,resizable=yes")
} 

</script>
<tr><td height="1" colspan="10" align="left" bgcolor="e4e4e4"></td></tr>
<cfoutput query="Get">
<tr>
  <td height="18">#ExportNo#</td>
  <td>
	 <cfif not FileExists("#Parameter.DocumentLibrary#\Export\#ExportFileId#")>
		<font color="FF0000">#ExportFileId#</font>
	 <cfelse>
	 	<a title="open export file" href="javascript:output('#ExportNo#')">#ExportFileId#</a>
	 </cfif>
  </td>
  <td>#ExportFileName#</td>
  <td><cfif #ActionStatus# eq "1">Prepared<cfelse>Uploaded</cfif></td>
  <td>#OfficerLastName#</td>
  <td>#dateFormat(Created, CLIENT.DateFormatShow)#</td>
    
  <td align="right">#Claim#</td>
  <td align="right">#SummaryLines#</td>
  <td align="right" >#numberFormat(SummaryAmounts,"__,__.__")#</td>
  <td align="center">
  <cfif ActionStatus eq "1">
    <img src="#SESSION.root#/Images/trash3.gif" onclick="cancel('#ExportNo#')" alt="Cancel export file" border="0" align="absmiddle" style="cursor: hand;" title="Cancel export file">
  <cfelse>	
    <img src="#SESSION.root#/Images/validate.gif" title="Export closed" border="0" align="absmiddle">
  </cfif>
   </td>
</tr>
<cfif CurrentRow neq Recordcount>
<tr><td height="1" colspan="10" bgcolor="D1D7D0"></td></tr>
</cfif>

</cfoutput>

</table>

</td></tr></table>

</body>
</html>
