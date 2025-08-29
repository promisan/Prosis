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
<title>Organization Lookup</title>

<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

</head>

<cfoutput>
<frameset cols="340,*" framespacing="2" frameborder="0"> 
<frame src="OrganizationTree.cfm?Source=#URL.Source#&Mission=#URL.Mission#&MandateNo=#URL.MandateNo#&ID=#URL.ID#"
  name="left" frameborder="1" framespacing="1" scrolling="auto" framespacing="0" target="_self">
  <frame src="" name="right" framespacing="1" frameborder="1" scrolling="Auto" framespacing="0" target="_self">
</frameset>
</cfoutput>
<noframes> 
<body">
<p>This page uses frames, but your browser doesn't support them.</p>
</body>
</noframes> 
</html>


