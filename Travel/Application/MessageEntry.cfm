<!---
	MessageEntry.cfm
	
	Message Entry page
	
	Calls:
	MessageEntrySubmit.cfm
	
	Includes:
		
	Modification history:
	02Dec04 - created by MM	
--->	
<HTML><HEAD><TITLE>Message Entry/View Form</TITLE></HEAD>

<body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 

<cfparam name="URL.ID1" default="E">

<cfif #URL.ID1# NEQ "A">
	<cfquery name="GetMsg" datasource="AppsTravel" 
	 username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT * FROM Message
		WHERE RowGuId = '#URL.ID#'
	</cfquery>
</cfif>
	
<cfform action="MessageEntrySubmit.cfm" method="POST" name="MessageEntry">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="30" valign="middle" bgcolor="002350">
		&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Message 
		<cfif #URL.ID1# EQ "A">Entry<cfelse>View</cfif></strong></font>
	</td>
	<td align="right" height="30" valign="middle" bgcolor="002350">
	<cfif #URL.ID1# EQ "A">
		<input type="submit" class="input.button1" name="Save" value=" Submit ">
	</cfif>
	<input type="button" class="input.button1" name="Close" value=" Close " onClick="window.close()">
	&nbsp;
	</td>
</tr> 	
	
<tr>
<td width="100%" colspan="2">
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

  <cfif #URL.ID1# EQ "A">  
  	<tr><td class="header" height="10" colspan="2"></td></tr>  
	<tr><td class="header" height="10" colspan="2">&nbsp;Instructions:</td></tr>
	<tr><td class="header" height="10" colspan="2">&nbsp;1. Use this page for message entry.</td></tr>
	<tr><td class="header" height="10" colspan="2">&nbsp;2. Click <b>Submit</b> to record your action.</td></tr>  
  </cfif>
  
  <tr><td class="header" height="4" colspan="2">
  <cfoutput>	
  <input type="hidden" name="parentid" value="#URL.ID#" class="disabled" size="20" readonly>  	
  </cfoutput>
  </td></tr>
	
  <tr>	 	 
	 <td class="header">&nbsp;Message (1000 chars max):</td>
	 <td class="regular">&nbsp;</td>
  </tr>
  <tr>
	 <td class="regular" colspan="2">&nbsp;
	 <cfif #URL.ID1# EQ "A">
	 	<textarea name="msg" cols="50" rows="20" class="regular"></textarea></textarea>
	 <cfelse>
	    <cfoutput query="GetMsg">	
		<textarea name="msg" cols="50" rows="20" readonly="readonly" class="regular">#MessageText#</textarea>
	    </cfoutput>		
	 </cfif>
   	 </td>
  </tr>
	 
  <tr><td height="4" colspan="2" class="header"></td></tr> 
</table>
</td>
</tr>
</table>

<table width="100%" bgcolor="#FFFFFF">
	<td align="right" class="regular">
	<td align="right" height="30" valign="middle">
	<cfif #URL.ID1# EQ "A">
		<input type="submit" class="input.button1" name="Save" value=" Submit ">
	</cfif>
	<input type="button" class="input.button1" name="Close" value=" Close " onClick="window.close()">
	&nbsp;
     </td>
</table>

</cfform>
</BODY></HTML>