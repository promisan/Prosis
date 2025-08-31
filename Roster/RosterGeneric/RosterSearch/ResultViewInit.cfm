<!--
    Copyright © 2025 Promisan B.V.

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
<title>Access</title>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
<base target="_self">
</head>

<cfparam name="SESSION.acc" default="unknown" >

<body bgcolor="white">
<img src="../../../warehouse.jpg" alt="" width="30" height="30" border="1" align="right">
<p>&nbsp;</p>
<hr>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<body>

<table border="0" cellpadding="0" cellspacing="0" align="center" width="450">
<tr bgcolor="white" valign="top">
      <td height="200" align="center"> 
        <p>&nbsp;</p>
 		<p><strong><font size="7" color="6688aa"><cfoutput><b>#SESSION.welcome#</b></cfoutput></font></strong></p>
	    <p><strong><font size="3" color="6688aa"><cfoutput>#SESSION.authorMemo#</cfoutput></font></strong></p>	
        <table border="0" cellpadding="0" cellspacing="0" align="center">
	  <tr>
            <td><img src="<cfoutput>#SESSION.root#</cfoutput>/Images/line.gif" width="2" height="70" border="0" alt="" hspace="10"></td>
	        <td> <font class="label" color="8EA4BB"><strong style="color:#3184C2;"> 
			<font size="2">Release <cfoutput>#CLIENT.Version#</cfoutput></font></strong>
			<font size="2"><br /><cfoutput>#SESSION.author#</cfoutput><br />
              <cfoutput>#CLIENT.Manager#</cfoutput></font>
			  <font size="2"><br /><cfoutput>Server: #CLIENT.Servername#</cfoutput><br />
              
	  </td>
	<td><img src="/Images/line.gif" width="2" height="57" border="0" alt=" " hspace="10"></td></tr>
	</table>
      </td>
</tr>

</table>

</body>

</html>