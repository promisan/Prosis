<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/print.css</cfoutput>" media="print"> 

<style type="text/css">
	td.memocontent{
			font-family:"Times New Roman", Courier, Garamond, serif;
			font-size : 8pt;
			font-weight:normal;
			align : justify;
		}
</style>
</head>
<body>

<cfparam name="url.mission" default="OICT">
<cfparam name="url.serviceitem" default="CU001">
<cfparam name="sel" default="#createdate(2012,4,1)#">
<cfparam name="selend" default="#createdate(2012,4,30)#">
<cfparam name="url.memo" default="0">

<cfquery name="Parameter" 
	datasource="NovaInit" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT *
	FROM   Parameter
</cfquery>

<cfif isdefined("ProcessService") eq "0" or ProcessService eq "">
	<cfset ProcessService = url.serviceitem>
</cfif>

<cfset DirName = DateFormat(selend,"YYYYMM")>	

<cfoutput>
	<cfset vPath = "#Parameter.DocumentRootPath#\ServiceFinancialsMemo\#URL.Mission#\#DirName#\#ProcessService#">

	<cfif not DirectoryExists(vPath)>				
		<cfdirectory action="CREATE" 
		   directory="#vPath#">	   
	</cfif>

</cfoutput>



<cfdocument 
	    filename="#vPath#\FinancialMemo.pdf"
	    format="PDF"
	    pagetype="letter"
		margintop="0.3" 
		marginright="0.5" 
		marginleft="0.5" 
		marginbottom = "1" 
	    orientation="portrait"
	    unit="in"
	    encryption="none"
	    fontembed="Yes"
	    overwrite="Yes"
	    backgroundvisible="Yes"
	    bookmark="True"
	    localurl="No">		

	<cfoutput>		

<!---	
	<cfdocumentitem type="footer">
		<table width="100%" height="100%" cellspacing="0" cellpadding="3">
		<tr><td style="#td05#"><cfinclude template="StatementOfAwardFooter.cfm"></td></tr>
		</table>
	</cfdocumentitem>	 
--->	


	<cfdocumentsection name="subject" marginbottom="0.3" >

		<table width="100%" height="100%" cellspacing="0" cellpadding="3">
		<tr><td><cfinclude template="FinancialsMemoData.cfm"></td></tr>
		</table>	

	</cfdocumentsection>

	</cfoutput>

</cfdocument>	



	<cfquery name="User" 
		datasource="NovaSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT *
		FROM   UserNames
		WHERE Account = '#SESSION.acc#'
	</cfquery>
		
<cfif url.memo eq "1">
	<cfif User.recordcount gt "0">
		<cfif User.eMailAddress neq "">
		
			 	<cfset mailFromName = "OICT - Cost Recovery">
				<cfset mailFromAddress = "nova@un.org">
				<cfset mFrom	= "#mailFromName#<#mailFromAddress#>">		
		
				<cfmail TO          = "#User.eMailAddress#" 
						FROM        = "#mFrom#"
						SUBJECT     = "Financial Memo - #getServiceItem.Description#"
						TYPE        = "html"
						spoolEnable = "Yes"
						wraptext    = "100">
												
					<cfmailparam file="#vPath#\FinancialMemo.pdf">
					
				</cfmail>
		
		</cfif>
	</cfif>
</cfif>


</body>