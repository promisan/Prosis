<html>
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Functional Title</title>

<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

</head>

<cfparam name="URL.ID" type="string" default="0">

<cfoutput>
<frameset cols="155,*" framespacing="0"  frameborder="0"> 
  <frame src="FunctionViewMenu.cfm?ID=#URL.ID#" name="left" frameborder="0" scrolling="auto" noresize framespacing="0" target="_self">
  <frame src="FunctionViewHeader.cfm?ID=#URL.ID#" name="right" id="right" frameborder="0" scrolling="Yes" framespacing="0" target="_self">
</frameset>
</cfoutput>
<noframes> 
<body>
<p>This page uses frames, but your browser doesn't support them.</p>
</body>
</noframes> 
</html>