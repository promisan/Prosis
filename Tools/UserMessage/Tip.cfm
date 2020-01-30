
<cfparam name="Attributes.Text" default="MyMessage">

<cfoutput>
<script language="JavaScript">
  function tip(text)  {
	alert(text)
  }	
</script>

<img src="#SESSION.root#/Images/help2.gif" align="absmiddle" onclick="tip('#Attributes.Text#')" alt="#Attributes.Text#" border="0" style="cursor: pointer;">

</cfoutput>