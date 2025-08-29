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
<title>Receipt Listing</title>

<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

</head>

<cfoutput>
	<frameset rows="140,*" frameborder="1" framespacing="0">
	  <frame src="PurchaseViewLocate.cfm?ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&Period=#URL.Period#" name="left" id="left" frameborder="0" bordercolor="silver" scrolling="No" framespacing="0" target="detail">
      <frame src="" frameborder="0" bordercolor="E2E2E2" name="detail" scrolling="No" marginwidth="0" marginheight="0" target="_self">
     </frameset>
	
	  <noframes>
	     <body>
	     <p>This page uses frames, but your browser doesn't support them.</p>
	     </body>
	  </noframes>
	</frameset>
</cfoutput>

</html>