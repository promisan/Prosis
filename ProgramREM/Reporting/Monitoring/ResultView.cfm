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
	<frameset rows="33,*" framespacing="1" frameborder="1" bordercolor="DFDFDF">
	  <frame src="#SESSION.root#/Tools/Control/Banner.cfm?Header=Inquiry result set&Action=Close" name="banner" id="banner" frameborder="0" scrolling="No" noresize TARGET="contents">
      <frameset cols="200,*">
	   <frame src="SearchTree.cfm?ID=1&ID1=#URL.ID#&Mission=#URL.Mission#" name="left" frameborder="0" scrolling="no" framespacing="1" target="_self">
	   <frame src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm" name="right" id="right" frameborder="0" scrolling="Auto" marginwidth="0" marginheight="0" target="_self">
	  </frameset>
	
	  <noframes>
	     <body>
	     <p>This page uses frames, but your browser doesn't support them.</p>
	     </body>
	  </noframes>
	</frameset>
</cfoutput>

</html>