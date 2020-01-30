
<TITLE>Personal History Profile</TITLE>

<HTML><HEAD></HEAD>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_wait text="Preparing Personal History Profile in Adobe Acrobat format" 
    height="0"
	width="100%"
	border="0"
	total=""
	progress="1">
	
	<cfset FileNo = round(Rand()*100)>	

<!--- cf8 --->	
<cfinclude template="PHP_Combined_List.cfm">

<cfoutput>
	<script>
		window.open("#SESSION.root#/cfrstage/user/#SESSION.acc#/php_#fileno#.pdf?ts="+new Date().getTime(),"myPHP", "location=no, toolbar=no, scrollbars=yes, resizable=yes")
		window.close()
	</script>
</cfoutput>



