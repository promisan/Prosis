<html>
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Position Lookup</title>
</head>

<cfoutput>


<frameset cols="300,*" frameborder="1"> 
  <frame src="PositionTree.cfm?Source=#URL.Source#&Mission=#URL.Mission#&MandateNo=#URL.MandateNo#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#"
  name="left" frameborder="1" scrolling="auto" framespacing="1" target="_self">
  <frame name="right" id="right" src="PositionListing.cfm?Source=#URL.Source#&Mission=#URL.Mission#&Mandate=#URL.MandateNo#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#" scrolling="Yes" framespacing="0" target="_self">
</frameset>
<noframes> 
<body onLoad="window.focus()">
<p>This page uses frames, but your browser doesn't support them.</p>
</body>
</noframes> 
</html>

</cfoutput>
