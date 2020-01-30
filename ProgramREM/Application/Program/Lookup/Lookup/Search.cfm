<html>
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Position Lookup</title>

<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

</head>
	
<cfoutput>
	<frameset cols="300,*" frameborder="1"> 
	  <frame src="SearchTree.cfm?Mission=#URL.Mission#&FormName=#URL.FormName#&fldmission=#URL.fldMission#&fldpostnumber=#URL.fldPostNumber#&fldfunctionno=#URL.fldFunctionNo#&fldfunction=#URL.fldFunction#&fldorgunit=#URL.fldOrgUnit#&fldgrade=#URL.fldGrade#&fldposno=#URL.fldPosNo#" 
	  name="left" frameborder="1" scrolling="auto" framespacing="0" target="_self">
	  <frame name="right" id="right" scrolling="Yes" framespacing="0" target="_self">
	</frameset>
</cfoutput>
<noframes> 
<body onLoad="window.focus()">
<p>This page uses frames, but your browser doesn't support them.</p>
</body>
</noframes> 
</html>

