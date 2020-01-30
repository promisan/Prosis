
<cfquery name="HelpId" 
datasource="AppsSystem"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  HelpProjectTopic
	WHERE TopicId   = '#URL.TopicId#' 
</cfquery>

<cfdocument 
          format="PDF"
          pagetype="letter"
          margintop="0.2"
          marginbottom="0.2"
          marginright="0.2"
          marginleft="0.2"
          orientation="portrait"
          unit="in"
          encryption="none"
          fontembed="Yes"
          backgroundvisible="Yes">			
		  
			
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	
		
	<cfoutput query="helpid">
	<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr><td height="23">
		<font size="4">			
		&nbsp;#ProjectCode# - #TopicName#</td>
		<td align="right"></td>
		</tr>
		
		</table>
	</td></tr>
	<tr><td bgcolor="808080" height="1"></td></tr>
	<tr><td valign="top" height="95%">
	
	<table width="97%" align="center">
	<tr><td height="10"></td></tr>
	
			 
	<tr><td style="border: 1px solid silver;"></td></tr>
	<tr><td>#HelpId.UITextQuestion#</td></tr>
	<tr><td height="10"></td></tr>
	
		
	<tr><td style="border: 1px solid silver;"></td></tr>
	<tr><td>#HelpId.UITextAnswer#</td></tr>
	</table>
	
	</td>
	</tr>
	
	</table>
	
	</cfoutput>
	
</cfdocument>


