<!--- 
	Travel/Application/Document/Request/Document.CFM

	Display template document Request to PM (TCC)
	
	Called by: Dialog.pm_createrequest(docno, actdir) which is called by Travel/Application.Template/DocumentEdit_Lines.cfm
	
	Modification History:

--->
<HTML><HEAD><TITLE>Documents List</TITLE></HEAD>

<link href="../../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">
<link href="../../../../print.css" rel="stylesheet" type="text/css" media="print">

<cfset CLIENT.DataSource = "AppsTravel">

<cf_PreventCache>

<cfoutput>
<script language="JavaScript">
function my_close() {
   	opener.location.reload()
   	window.close()
}   
</script>	
</cfoutput>

<!--- List available reports --->
<cfquery name="Docs" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * FROM FlowActionReport WHERE ActionForm ='Request'
</cfquery>

<!--- Set value of URL.ID1 based on ActionClass of current document record --->
<cfquery name="GetActionClass" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT ActionClass FROM Document WHERE DocumentNo = #URL.ID#
</cfquery>

<BODY class="main">

<cfset URL.ID1 = #GetActionClass.ActionClass#>

<cfform action="DocumentSubmit.cfm" method="POST" name="request">

<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
	<tr bgcolor="#002350" height="20" valign="middle">
    		<td colspan="4"><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;DOCUMENTS LIST</b></font>
     			<input type="hidden" value="<cfoutput>#URL.ID#</cfoutput>" name="documentno" size="10" maxlength="10" class="regular">
	     		<input type="hidden" value="#URL.ID1#" name="flag" size="10" maxlength="10" class="regular">				
			</td>
  	</tr>
  	<tr bgcolor="#002350" height="15" valign="middle">
   		<td colspan="4"><font face="Tahoma" size="1" color="#FFFFFF">
				&nbsp;&nbsp;&nbsp;This view lists all documents that may be generated in MS Word format.
		</td>
  	</tr>

  	<!--- Detail column headers --->
  	<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">
		<tr>
    		<td class="topN">&nbsp;</td>	
		    <td class="topN">Report Name</td>
			<td class="topN">Report Description</td>
		</tr>

		<cfoutput query="Docs">    
			<tr bgcolor="C0C0C0"><td height="1" colspan="13" class="top2"></td></tr>
			<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
				<td class="regular"><font color="black">#CurrentRow#.</font></td>
				<td class="regular"><font color="black">#ReportName#</font></td>
				<td class="regular"><font color="black">#ReportDescription#</font></td>
			</tr>
	  	</cfoutput>

	</table>
		
	<tr><td height="40" colspan="4" bgcolor="#FFFFFF">&nbsp;</td></tr>
	<tr align="right"><td height="40" colspan="4" bgcolor="#FFFFFF" align="right">
	<input class="input.button1" type="submit" name="Save" value="Write the document below to disk">&nbsp;&nbsp;
	<input class="input.button1" type="button" name="Close" value=" Close " onClick="javascript:window.my_close()">
	</td></tr>
	<tr><td height="40" colspan="4" bgcolor="#FFFFFF">&nbsp;</td></tr>
	<tr><td height="10" colspan="4" bgcolor="#002350"></td></tr>		<!--- Print a dark blue border --->
   	

  <tr><td height="15" colspan="4" align="left" valign="middle"></td></tr>
  
  <cfif ParameterExists(URL.ID)>
	  <tr>
   		 <td colspan="2">
	 		<cfinclude template="Templates/FaxRequestToPm.cfm">
		 </td>
	  </tr> 
  </cfif>
</TABLE>
</cfform>
</BODY></HTML>