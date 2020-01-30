<cf_submenuLogo module="Insurance" selection="Faqs">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>General Questions and answers</title>
</head>
<body>

<cf_screentop height="100%" scroll="yes" html="No">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<table width="99%">
<tr><td height="5"></td></tr>
<tr><td width="50">

</td>
<td><font face="Verdana" size="5"></td></tr>
<tr><td height="8"></td></tr>
</table>

<cfquery name="QA" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM      HelpProjectTopic
WHERE     ProjectCode = '#URL.ID#' 
AND       LanguageCode = '#client.Languageid#'
AND       UITextSource = 'Local'
AND       UITextAnswer is not NULL  
AND       TopicClass = 'General'
</cfquery>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<cfoutput query="QA"  >
<tr><td colspan="2" height="20"><font size="2" color="808080">&nbsp;#TopicName#</td></tr>
<tr><td colspan="2" height="1" bgcolor="silver"></td></tr>
<tr><td height="6"></td></tr>
<tr><td width="40" align="center">

<img src="#SESSION.root#/Images/pointer.gif"
	  	 alt="#UITextHeader#"
	     border="0"
	     align="absmiddle"
	     style="cursor: pointer;">
</td><td width="96%"><font color="0080FF">#UITextQuestion#</td></tr>
<tr><td height="5"></td></tr>
<tr><td align="center">
<img src="#SESSION.root#/Images/help_answer.gif"
	  	 alt="#UITextHeader#"
	     border="0"
	     align="absmiddle"
	     style="cursor: pointer;">
</td><td width="96%">#UITextAnswer#</td></tr>
<tr><td height="6"></td></tr>
</cfoutput>
</table>


</body>
</html>
