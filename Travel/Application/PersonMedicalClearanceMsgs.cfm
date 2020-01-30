<!---
	PersonMedicalClearanceMsgs.htm
	
	List messages (that authored by users) below Person MedicalClearance form
	
	This page is inserted into bottom of PersonMedicalClearanceEdit.htm
	
	Calls:  
	
	Modification history:
	1Dec04 - created by MM
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Messages</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<style>
TD.regular { 
	font-family : tahoma; 
	font-size : 8pt; 
	height : 17px; 
	color : black;
	} 
</style>

<body>

<cfquery name="GetMessages" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT RowGuid, OfficerFirstName + ' ' + Upper(OfficerLastName) AS Author, Created,
    (CASE WHEN Len(MessageText) > 95 THEN 
	    Left(MessageText,95) + '...' 
	ELSE 
		MessageText END) AS MsgText
FROM Message
WHERE ParentId = '#URL.ID1#'
ORDER BY Created DESC
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

<!---tr bgcolor="#6688aa">
   	<td class="topN" width="2%">&nbsp;</td>
   	<td class="topN" width="78%">Message</td>
   	<td class="topN" width="12%">Author</td>  		
   	<td class="topN" width="8%">Date</td>
</tr--->

<cfoutput query="GetMessages">
<tr>
	<td class="regular" width="2%">&nbsp;</td>
	<td class="regular" width="70%">
		<a href="javascript:pm_addnewmsg('#RowGuid#','E')" title="Click to view message in full."  >#MsgText#</a></td>
	<td class="regular" width="18%">#Author#</td>	
	<td class="regular" width="*">#DateFormat(Created, CLIENT.DateFormatShow)#</td>		
</tr>
</cfoutput>
</table>
</body>
</html>
