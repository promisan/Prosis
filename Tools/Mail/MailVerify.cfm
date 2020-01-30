
<cf_param name="URL.ID1"     default="" type="string">
<cf_param name="URL.SendTo"  default="" type="string">

<base target="_top">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<body>

<cfset st = "0">

<cfoutput>

<cf_param name="Form.SentFROM_Name" 	default="" type="string">
<cf_param name="FORM.SentFrom" 			default="" type="string">
<cf_param name="Form.Reply"         	default="" type="string">


<script>

if ("#Form.SentFROM_Name#" == "") {
  alert("You have not entered a FROM address")  
}
 
</script>

<!--- from --->

<cfparam name="form.attachment" default="">

<cfloop index="mailFrom" list="#FORM.SentFrom#" delimiters=" ,">

<script>

re = /^\w+([.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/

if (re.test("#mailFrom#")) {
   } else {
  alert("You have entered an invalid FROM email address [#mailFrom#]") 
   }

</script>

</cfloop>

<!--- to --->

<cfloop index="mailto" list="#FORM.SendTO#" delimiters=" ,">

<script>

re = /^\w+([.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/

if (re.test("#mailto#")) {
   } else {
  alert("You have entered an invalid email address [#mailto#]") 
   }

</script>

</cfloop>

</cfoutput>

<cfif st eq "1">
	<cf_alert message = "You have entered an invalid email Address TO" return="back">
    <cfabort>
</cfif>

<cfif FORM.SendTO eq "">
	<cf_alert message = "You must enter an <b>Address TO</a>" return="back">
    <cfabort>
</cfif>

<cfif FORM.Subject eq "">
	<cf_alert message = "You must enter a <b>Subject</b>" return="back">
	<cfabort>
</cfif>

<cfif Form.SentFrom eq "">

   <cfquery name="Parameter" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM Parameter
	</cfquery>

  <cfset SentFrom = "#Parameter.DefaultEmail#">
  
<cfelse>  

  <cfset SentFrom = "#Form.SentFrom#"> 
  
</cfif>


<cfif Form.Reply eq "">

   <cfquery name="Parameter" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Parameter
	</cfquery>

  <cfset Reply = "#Parameter.DefaultEmail#">
  
<cfelse>  

  <cfset Reply = "#Form.Reply#"> 
  
</cfif>

<cfset cnt = 0>

<cfparam name="Form.SendCC" default="">
<cfparam name="mailcc" default="#FORM.SendCC#">

<cfloop index="mailto" list="#FORM.SendTO#" delimiters=",">

	<cfif isValid("email", "#mailto#")>

		<!--- launches mail send template --->
		
		<cfset cnt = cnt+1>		
		
		<cfif cnt eq "1">						
				
			<cf_MailSend
			   	class        = "#Form.Source#"
				classId      = "#Form.SourceId#"
				referenceId  = ""
				to           = "#Mailto#"
				cc           = "#mailcc#"
				bcc          = "#FORM.SendBCC#"
				from         = "#Form.SentFROM_Name# <#SentFROM#>"
				FAILTO       = "#reply#"
				subject      = "#FORM.Subject#"
				bodycontent  = "#FORM.SentBODY#"
				attachment   = "#Form.Attachment#"
				saveMail     = "0">				
			
		<cfelse>
			
			<cf_MailSend
			   	class        = "#Form.Source#"
				classId      = "#Form.SourceId#"
				referenceId  = ""
				to           = "#Mailto#"			
				from         = "#Form.SentFROM_Name# <#SentFROM#>"
				FAILTO       = "#reply#"
				subject      = "#FORM.Subject#"
				bodycontent  = "#FORM.SentBODY#"
				attachment   = "#Form.Attachment#"
				saveMail     = "0">
		
		</cfif>	
		
	<cfelse>
	
		<script>
			alert("Invalid eMail address")		
		</script>
		
		<cfabort>
			
		
	</cfif>	
			
</cfloop>	

<cfajaximport tags="cfwindow">

<cfif URL.Mode eq "cfwindow">
	<cf_alert message = "Your eMail message was delivered to the mail server.">	
	<script>
	  parent.document.getElementById("close").click()
	</script>
<cfelseif URL.Mode eq "Dialog">
    <script> parent.window.close()</script>	
<cfelse>
	<cf_alert message = "Your eMail message was delivered to the mail server.">
</cfif>	
	
