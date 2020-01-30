<html>
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">

<title><cfoutput>Program and project search</cfoutput></title>

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
	   <frame src="SearchTree.cfm?ID=0&Mission=#URL.Mission#" name="left" frameborder="1" scrolling="no" framespacing="0" target="_self">
	   <frame src="Search.cfm?Mission=#URL.Mission#" name="right" id="right" scrolling="Auto" marginwidth="0" marginheight="0" target="_self">
	  </frameset>
	
	  <noframes>
	     <body>
	     <p>This page uses frames, but your browser doesn't support them.</p>
	     </body>
	  </noframes>
	</frameset>
</cfoutput>

