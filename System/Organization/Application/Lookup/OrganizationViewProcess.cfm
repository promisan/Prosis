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


