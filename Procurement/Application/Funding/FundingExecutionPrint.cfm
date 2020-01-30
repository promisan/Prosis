
<cfoutput>

<title>Printable Version of Budget Execution</title>
<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#"> 		
<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
	
<cfinclude template="FundingExecutionScript.cfm">


	
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td style="padding:20px">
<cfdiv bind="url:FundingExecutionData.cfm?#CGI.QUERY_STRING#">
</td></tr>
</table>
</cfoutput>