<!---
	PersonMedicalClearance.cfm
	
	Person Medical Clearance page
	
	Calls:
	PersonMedicalClearanceSubmit.cfm
	
	Includes:
	PersonMedicalClearanceDocs.cfm	- document attachments (scanned MS2 forms)
	PersonMedicalClearanceMsgs.cfm	- messages authored by medical clearance officers
		
	Modification history:
	
--->	
<HTML><HEAD><TITLE>Person Medical Clearance Form</TITLE></HEAD>

<cfinclude template="Dialog.cfm">

<cfquery name="CandAction" datasource="AppsEmployee" maxrows=1 username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DC.*, P.PersonNo, Upper(P.LastName) AS LastName, P.FirstName
	FROM TRAVEL.DBO.DocumentCandidateAction DC, Person P
    WHERE DC.PersonNo = P.PersonNo
	  AND DC.DocumentNo = #URL.ID#
	  AND DC.PersonNo = '#URL.ID1#'
	  AND DC.ActionId = '#URL.ID2#'
</cfquery>

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">
<body class="main" onload="window.focus()" top="0", bottom="0">

<cfform action="PersonMedicalClearanceSubmit.cfm" method="POST" name="PersonMedicalClearanceEdit">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="30" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Medically Clear Person</strong></font>
	</td>
	<td align="right" height="30" valign="middle" bgcolor="002350">
	<input type="submit" class="input.button1" name="Save" value=" Save ">
	<input type="button" class="input.button1" name="Close" value=" Close " onClick="window.close()">
	&nbsp;
	</td>
</tr> 	
	
<tr>
<td width="100%" colspan="2">
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
  
  <tr><td class="header" height="10" colspan="2"></td></tr>  
  <tr><td class="header" height="10" colspan="2">&nbsp;Instructions:</td></tr>
  <tr><td class="header" height="10" colspan="2">&nbsp;1. Use this page to medically clear this person.</td></tr>
  <tr><td class="header" height="10" colspan="2">&nbsp;2. Select the appropriate Clearance Status radio button.</td></tr>  
  <tr><td class="header" height="10" colspan="2">&nbsp;3. Input the Status Effectivity date.</td></tr>
  <tr><td class="header" height="10" colspan="2">&nbsp;4. Input entries in the Memo and/or Reference fields as necessary.</td></tr>
  <tr><td class="header" height="10" colspan="2">&nbsp;5. Click <b>Submit</b> to record your action.</td></tr>  
  <tr><td class="header" height="10" colspan="2"></td></tr>
  <tr>
	  <td class="header">&nbsp;Person Number:</td>
	  <td class="header">&nbsp;
	  <cfinput type="Text" name="personno" value="#CandAction.PersonNo#" required="No" size="20" maxlength="20" class="regular" passThrough="disabled">
	  </td>
  </tr>
  
  <tr><td height="4" colspan="2" class="header"></td></tr>
  
  <tr>
	  <td class="header">&nbsp;Person Name:</td>
	  <td class="header">&nbsp;
	  <cfinput type="Text" name="personname" value="#CandAction.FirstName# #CandAction.LastName#" required="No" size="50" maxlength="50" class="regular" passThrough="disabled">
	  </td>
  </tr>
  
  <tr><td height="4" colspan="2" class="header"></td></tr>

  <tr>
	  <td class="header">&nbsp;Awaiting clearance since (dd/mm/yyyy):</td>
	  <td class="header">&nbsp;
	  <cfset disp_date = DateFormat(#CandAction.ActionDateActual#,"dd/mm/yyyy")>
	  <cfinput name="pendingsince" type="text" value="#disp_date#" 
	   class="regular" style="text-align: center" size="12" passThrough="disabled">
	  </td>
  </tr>
	  
  <tr><td height="4" colspan="2" class="header"></td></tr>	

  <tr>
  	<!---note: documentcandidateaction status codes used:
			    0 - Pending : MSD is yet to act on it
				7 - In-Process : currently the default as per FGS/CPD action
				6 - Stalled: will be used by MSD to denote Pending (PM needs to submit required info)
				1 - Completed : will be used by MSD to denote Cleared 
				5 - Failed : will be used by MSD to denote Failed
	--->				
    <td class="header">&nbsp;Clearance Status:</td>
    <td class="regular">    		
		<table width="100%">
		<tr>&nbsp;
		<input type="radio" name="actionstat" value="6" <cfif #CandAction.ActionStatus# is "6"> checked</cfif>>Pending
		<input type="radio" name="actionstat" value="1" <cfif #CandAction.ActionStatus# is "1"> checked</cfif>>Cleared
		<input type="radio" name="actionstat" value="5" <cfif #CandAction.ActionStatus# is "5"> checked</cfif>>Not cleared (final)
        </tr>
		</table>
	</td>
  </tr>
	
  <tr><td height="4" colspan="1" class="header"></td></tr>

  <tr> 
	<td class="header">&nbsp;Status effectivity date (dd/mm/yyyy):</td>
	<td class="regular">&nbsp;	
	    <cf_intelliCalendarDate
		FormName="PersonMedicalClearanceEdit"
		FieldName="ActionDateActual"
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(Now(), CLIENT.DateFormatShow)#"
		AllowBlank="False">	
	</td>
  </tr>

  <tr><td height="4" colspan="1" class="header"></td></tr>		
	
  <tr>	 	 
	 <td class="header">&nbsp;Memo (100 chars max):</td>
	 <td class="regular">&nbsp;</td>
  </tr>
  <tr>
	 <td class="regular" colspan="2">&nbsp;
	  <cfinput name="actionmem" type="text" value="#CandAction.ActionMemo#" class="regular" size="100">
   	 </td>
  </tr>
  
  <tr><td height="4" colspan="1" class="header"></td></tr>	
  <tr>	 	 
	 <td class="header">&nbsp;Reference (20 chars max):</td>
	 <td class="regular">
	  <cfinput name="actionref" type="text" value="#CandAction.ActionReference#" class="regular" size="20">
   	 </td>
  </tr>
	 
  <cfoutput>	
  <input type="hidden" name="docno" value="#CandAction.DocumentNo#" class="disabled" size="10" maxlength="10" readonly>
  <input type="hidden" name="persno" value="#CandAction.PersonNo#" class="disabled" size="10" maxlength="10" readonly>  	
  <input type="hidden" name="actid" value="#CandAction.ActionId#" class="disabled" size="10" maxlength="10" readonly>  	  
  </cfoutput>
   	
  <tr><td height="4" colspan="1" class="header"></td></tr>  
</table>
</td>
</tr>

<tr><td colspan="2" align="center" class="topN">Medical Forms</td></tr>
<tr><td colspan="2" align="center"><cfinclude template="PersonMedicalClearanceDocs.cfm"></td></tr>

<tr><td colspan="2" align="center" class="topN">Messages</td></tr>
<tr><td colspan="2" align="center"><cfinclude template="PersonMedicalClearanceMsgs.cfm"></td></tr>

</table>

<table width="100%" bgcolor="#FFFFFF">
	<td align="right" class="regular">
	<td align="right" height="30" valign="middle">
	<input type="button" class="input.button1" name="Msg" value=" Add Message " 
		onClick="javascript:pm_addnewmsg('<cfoutput>#URL.ID1#</cfoutput>','A')">
	<input type="submit" class="input.button1" name="Save" value=" Save ">
	<input type="button" class="input.button1" name="Close" value=" Close " onClick="window.close()">
	&nbsp;
     </td>
</table>

</CFFORM>
</body>
</div>
</html>