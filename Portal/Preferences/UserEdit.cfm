
<cfparam name="url.showLDAPMailbox"		default="1">
<cfparam name="url.webapp" 				default="">
<cfparam name="url.showChangePassword" 	default="0">

<cfquery name="Standard" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  = '#url.webapp#'
	AND    MenuClass      = 'function'	
	AND    FunctionName   = 'standards'	
	AND    Operational    = 1
	ORDER BY FunctionName
</cfquery>

<cfajaximport tags="cfform">

<cfinclude template="UserEditScript.cfm">

<cf_menuscript>
<cf_screentop height="100%"  html="No" jquery="Yes">
<cf_listingscript> 
<cf_textareascript>

<cfquery name="Get"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   UserNames 
	WHERE  Account = '#SESSION.acc#'
</cfquery>

<cfquery name="AccountGroup" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AccountGroup 
	WHERE  AccountGroup = '#Get.AccountGroup#'
</cfquery>

<style>
    #menu1,
    #menu2,
    #menu3,
    #menu4,
    #menu5,
    #menu6,
    #menu7,
    #menu8{
        padding: 2px 0 10px !important;
        border-bottom: 1px solid #f5f5f5!important;
    }
    #menu1_text.labelit,
    #menu2_text.labelit,
    #menu3_text.labelit,
    #menu4_text.labelit,
    #menu5_text.labelit,
    #menu6_text.labelit,
    #menu7_text.labelit,
    #menu8_text.labelit{
        padding: 0!important;
        
    }
</style>    
    
<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr class="hide"><td id="process"></td></tr>

<tr><td height="100%" valign="top" style="padding-top:10px">
	
	<table height="100%" width="99%" align="center">
	
	<cfoutput>
	<tr>
				
		<td width="160" valign="top" style="border-right:1px solid silver;padding:2px">
		
		<cf_space spaces="35">
		
		<table width="100%" cellspacing="0" cellpadding="0">
		
		<tr>
		
		<cfset ht = "36">
		<cfset wd = "36">
			
		<cfset itm = 0>
		
		<cfset itm = itm + 1>
		<cf_tl id="Identification" var="1">
			
		<cf_menutab item       = "#itm#" 
		        targetitem = "1"
		        iconsrc    = "Logos/User/UserEdit-ID.png"
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				class      = "highlight"
				name       = "#lt_text#"
				source     = "javascript:pref('UserIdentification.cfm')">		
				
		</tr>	
				
		<cfif standard.recordcount gte "1">
		
		<tr>
		
		<cfset itm = itm + 1>	
		<cf_tl id="Default Settings" var="1">
		<cf_menutab item       = "#itm#" 
		        targetitem = "1"
		        iconsrc    = "Logos/User/UserEdit-Signature.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 				
				name       = "#lt_text#"
				source     = "../../#standard.functiondirectory#/#standard.functionpath#?#standard.functionCondition#">		
		</tr>		
		</cfif>			
		
		<tr>
		<cfset itm = itm + 1>
		<cf_tl id="Signature" var="1">			
		<cf_menutab item       = "#itm#" 
		        targetitem = "1"
		        iconsrc    = "Logos/User/UserEdit-Signature.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				name       = "#lt_text#"
				source     = "javascript:pref('UserSignature.cfm')">	
		</tr>
		<tr>
		<cfset itm = itm + 1>			
		<cf_tl id="Features" var="1">
		
		<cf_menutab item       = "#itm#" 
		        targetitem = "1"
		        iconsrc    = "Logos/User/UserEdit-Features.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				name       = "#lt_text#"
				source     = "javascript:pref('UserPresentation.cfm')">		
		</tr>		
		<tr>
		<cfset itm = itm + 1>			
		<cf_tl id="Annotation" var="1">
				
		<cf_menutab item       = "#itm#" 
		        targetitem = "1"
		        iconsrc    = "Logos/User/UserEdit-Notes.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				name       = "#lt_text#"
				source     = "javascript:pref('UserAnnotation.cfm')">		
		</tr>
		
		<tr>
		<cfif url.webapp eq "">	
			
		<cfset itm = itm + 1>
		<cf_tl id="Workflow" var="1">
					
		<cf_menutab item       = "#itm#" 
		        targetitem = "1"
		        iconsrc    = "Logos/User/UserEdit-Workflow.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				name       = "#lt_text#"
				source     = "javascript:pref('UserWorkflow.cfm')">		
				
		<!---	
		<cfset itm = itm + 1>			
		<cf_menutab item       = "#itm#" 
		        targetitem = "1"
		        iconsrc    = "Logos/User/Dashboard.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				name       = "Dashboard"
				source     = "javascript:pref('UserDashboard.cfm')">	--->	
				
		</cfif>		
		</tr>
		
		<cfif url.showChangePassword eq 0>
		
		<tr>
		
		<cfset itm = itm + 1>
		<cf_tl id="Password&nbsp;and&nbsp;roles" var="1">
		 			
		<cf_menutab item       = "#itm#" 
		        targetitem = "1"
		        iconsrc    = "Logos/User/UserEdit-Password.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				name       = "#lt_text#"
				source     = "javascript:pref('UserPassword.cfm')">			
				
		</tr>
		
		<cfelse>
		
		<tr>
		
		<cfset itm = itm + 1>
		<cf_tl id="Password" var="1">
		 			
		<cf_menutab item       = "#itm#" 
		        targetitem = "1"
		        iconsrc    = "Logos/User/UserEdit-Password.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				name       = "#lt_text#"
				source     = "javascript:pref('../SelfService/SetInitPassword.cfm?window=no&showPicture=no&showBack=no&id=ajax')">			
				
		</tr>
		
		</cfif>
						
		<cfif url.webapp eq "">	
		
			<tr>											
			<cfset itm = itm + 1>
			<cf_tl id="Report Log" var="1">
						
			<cf_menutab item       = "#itm#" 
			        targetitem = "1"
			        iconsrc    = "Logos/User/UserEdit-Report.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					name       = "#lt_text#"
					source     = "javascript:pref('ListingReport.cfm')">		
			</tr>
					
			
			<tr>			
			<cfset itm = itm + 1>
			<cf_tl id="Mail Log" var="1">			
			
			<cf_menutab item       = "#itm#" 
			        targetitem = "1"
			        iconsrc    = "Logos/User/UserEdit-Mail.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 				
					name       = "#lt_text#"
					source     = "javascript:pref('ListingMail.cfm')">		
			</tr>		
		
		</cfif>											

		</cfoutput>
		
		</table>
		
	</td>
			
	<td height="100%" valign="top" width="99%" style="padding-left:10px">
	  <table height="100%" width="100%">
		  <tr height="10">
			<td colspan="1" bgcolor="white" class="labellarge">		
			<cfoutput>
                <h1 style="font-size: 18px;margin: 0 0 0 20px;display: block;">Account:
                    <span style="font-size: 32px;line-height: 22px; margin: 0">#Session.acc# <span style="font-size: 14px;margin:10px 0 0">[<cf_tl id="group">: #get.AccountGroup#]</span></span>
                 </h1>
			</cfoutput>
			</td>
				
		</tr>
	  
	  <tr><td width="100%" height="100%" style="padding-left:10px;padding-right:10px">
	    <cf_divscroll overflowx="auto">
		<table width="100%" height="100%">		   
			<cf_menucontainer item="1" class="regular"></cf_menucontainer>			
		</table>
		</cf_divscroll>
	</td>	
	</tr>
	</table>
	</td>
	</tr>
	</table>
	
	</td>
</tr>

</table>	

<!--- INITIALLY OPEN --->
	
<script>
	pref('UserIdentification.cfm')
</script>

<cf_screenbottom html="No">
