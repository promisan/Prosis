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

<title><cfoutput>Result set: #URL.ID#</cfoutput></title>

<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

</head>

<cfparam name="URL.Mission" default="All">

<cfoutput>
	<frameset rows="33,*" frameborder="1">
	  <frame src="#SESSION.root#/Tools/Control/Banner.cfm?Header=Program inquiry&Action=Close" name="banner" id="banner" frameborder="0" scrolling="No" noresize TARGET="contents">
      <frameset cols="200,*">
	   <frame src="SearchTree.cfm?ID=1&ID1=#URL.ID#&Mission=#URL.Mission#" name="left" frameborder="1" scrolling="no" framespacing="0" target="_self">
	   <frame src="../../../Tools/Treeview/TreeViewInit.cfm" name="right" id="right" scrolling="Auto" marginwidth="0" marginheight="0" target="_self">
	  </frameset>
	
	  <noframes>
	     <body>
	     <p>This page uses frames, but your browser doesn't support them.</p>
	     </body>
	  </noframes>
	</frameset>
</cfoutput>

</html>