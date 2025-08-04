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
<html>

<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Bank account</title>
</head>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Bank" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Bankaccount
	WHERE Currency = '#URL.ID9#'
	
</cfquery>

<cf_dialogLedger>
	

<CFOUTPUT>	

<script>

function selected(bnk,acc)
{
	
        var form = "#URL.ID#";
		var gobnk  = "#URL.ID1#";
		var goacc  = "#URL.ID2#";
		eval("self.opener.document." + form + "." + gobnk + ".value = bnk");
		eval("self.opener.document." + form + "." + goacc + ".value = acc");
		window.close();
	
}
</script>

</CFOUTPUT>

<body onLoad="window.focus()">

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

  <tr bgcolor="#6688aa" height="30">
  </tr>
   
  <tr height="370">
  <td valign="top">
       
     <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
     <TR bgcolor="8EA4BB"> 
       <td width="8%" height="19"></td>
       <TD width="22%" align="left"><font face="Tahoma" size="1" color="FFFFFF">Bank</font></TD>
       <TD width="30%" align="left"><font face="Tahoma" size="1" color="FFFFFF">Account</font></TD>
	   <TD width="30%" align="left"><font face="Tahoma" size="1" color="FFFFFF">ABA</font></TD>
     </TR>
	 <cfoutput query="bank">
		 <TR bgcolor="ffffcf">
		 <TD>&nbsp;&nbsp;<input class="button7" type="button" name="Select" value="..." style="font: 50%;" onClick="javascript:selected('#Bank#','#BankAccount#');"></TD>
		 <TD>#Bank#</a></TD>
	     <TD>#BankAccount#</TD>
		 <TD>#AccountABA#&nbsp;</TD>
		 </tr>
	 </cfoutput>
	 </table>
  </td>
  </tr>
  
</table>
</form>

</body>

</html>
