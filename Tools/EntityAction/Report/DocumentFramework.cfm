
<cfif URL.DocumentFramework eq "1">			  
			  					
	 <!--- parse the document --->				   
	    
	 <cfquery name="Language" 
		 	datasource="AppsSystem">
			 	SELECT  *
			 	FROM    Ref_SystemLanguage
			 	WHERE   Code = '#URL.language#'  
	</cfquery> 
		
	<cfif Language.SystemDefault eq "1" or Language.Operational eq "1">
	       <cfset vLanguagecode = "">
	<cfelseif URL.language eq "">	   
	       <cfset vLanguagecode = "">
	<cfelse>   
		   <cfset vLanguagecode  = "xl#URL.language#_">
	</cfif>			
					
	<cfparam name="vFormat"         default= "#URL.format#">
	<!---
	<cfparam name="vLanguagecode"   default= "#URL.language#">
	--->
	<cfparam name="vDocumentdate"   default= "#dateformat(now(),CLIENT.DateFormatShow)#">
	<cfparam name="vReference"      default= "">
	<cfparam name="vTo"             default= ""> 
	<cfparam name="vFrom"           default= "#URL.Signature#">
	<cfparam name="vSubject"        default= "#URL.Description#">
	<cfparam name="vSignatureTitle" default= "">				
	<cfparam name="vSignatureLabel" default= "">								
	<cfparam name="vLogo"           default="">
	<cfparam name="vTitleLine1"     default="">
	<cfparam name="vTitleLine2"     default="">
	<cfparam name="vTitleLine3"     default="">
	<cfparam name="vTitleLine4"     default="">
	<cfparam name="vTitleLine5"     default="">				
	<cfparam name="vSignatureLine1" default="">
	<cfparam name="vSignatureLine2" default="">
	<cfparam name="vSignatureLine3" default="">
	<cfparam name="vSignatureLine4" default="">
	<cfparam name="vClosing"        default="">		
	<cfparam name="vSectionLine"    default="No">								
	<cfparam name="vSignedby"       default="#SESSION.first# #SESSION.last#">
	
	<!--- additional initial info which is to be retrieve based on the content 
	templates name	--->
	
	<cfset l = len(URL.DocumentTemplate)>		
       <cfset path = left(URL.DocumentTemplate,l-4)>			   
  	
	<cftry>
	
	      <!--- load functions to be used --->
		 <cfinclude template="strFunctions.cfm">
		 <cfinclude template="../../../#path#_#vFormat#.cfm">					
				     					 
		 <cfcatch type="MissingInclude">
				<!--- Nada --->
		 </cfcatch>
		 
		 <cfcatch type="Any">
		 
		      <cfoutput>
			  
					<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
					
					<cfif SESSION.isAdministrator eq "Yes">
					<tr><td align="center" bgcolor="ffffaf">Template: #path#_#vFormat#</td></tr>
					</cfif>
					<tr><td bgcolor="ffffdf" align="center">
					#CFCatch.Message# - #CFCATCH.Detail#
					</td></tr>
					</table>			
					
					<cfabort>
		      </cfoutput>
		   </cfcatch>		
		   
	</cftry>		
										
	<cfsavecontent variable="text">
			
			<cf_LayoutDocument
				Class		    = "#vFormat#"
				LanguageCode    = "#vLanguageCode#"
				DocumentDate	= "#vDocumentDate#"
				Reference	    = "#vReference#"
				To			    = "#vTo#"
				From		    = "#vFrom#"
				Subject		    = "#vSubject#"
				Logo            = "#vLogo#"
				TitleLine1      = "#vTitleLine1#"
				TitleLine2      = "#vTitleLine2#"
				TitleLine3      = "#vTitleLine3#"
				TitleLine4      = "#vTitleLine4#"
				TitleLine5      = "#vTitleLine5#"
				SignatureTitle  = "#vSignatureTitle#"
				SignatureLine1  = "#vSignatureLine1#"
				SignatureLine2  = "#vSignatureLine2#"
				SignatureLine3  = "#vSignatureLine3#"
				SignatureLine4  = "#vSignatureLine4#"
				SignatureLabel  = "#vSignatureLabel#"
				SectionLine     = "#vSectionLine#"
				Closing         = "#vClosing#"								
				SignedBy        = "#vSignedBy#">								 		
     
		 	 	   <cfinclude template="../../../#URL.DocumentTemplate#">
				 						   
			</cf_LayoutDocument>
			
			<!--- Added by Jorge Armin Mazariegos, 9/3/2010 to handle
			include files to a particular document Inc sufix is concatenated --->
			
			<cftry>
			
				<cfinclude template="../../../#path#_Inc.cfm">
		        <cfcatch type="MissingInclude">
				    <!--- Nada --->
		        </cfcatch>
		   
		        <cfcatch type="Any">
			        <cfoutput>
						<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
						<cfif SESSION.isAdministrator eq "Yes">
						<tr><td align="center" bgcolor="ffffaf">Template: #path#_#vFormat#</td></tr>
						</cfif>
						<tr><td bgcolor="ffffaf" align="center">
						#CFCatch.Message# - #CFCATCH.Detail#
						</td></tr></table>												
						<cfabort>
			        </cfoutput>
		        </cfcatch>		
				
		   </cftry>				 

	  </cfsavecontent>		
		
<cfelse>
			  
		   <!--- parse the document --->				   
		    
		   <cfquery name="Language" 
			 	datasource="AppsSystem">
				 	SELECT  *
				 	FROM    Ref_SystemLanguage
				 	WHERE   Code = '#URL.language#'  
		   </cfquery> 
			
		   <cfif Language.SystemDefault eq "1" or Language.Operational eq "1">
			   <cfset vLanguagecode = "">
		   <cfelseif URL.language eq "">	   
		       <cfset vLanguagecode = "">  
		   <cfelse>   
			   <cfset vLanguagecode  = "xl#URL.language#_">
		   </cfif>							   			   
		   
		   <cftry>
		   		<cfsavecontent variable="text">
		 	      <cfinclude template="../../../#URL.DocumentTemplate#">													
		   		</cfsavecontent>
	       <cfcatch>
		   		<cfoutput>
				 Custom Document could not set the text for the document.<br>#cfcatch.type#<br>#cfcatch.message#<br>
			 	</cfoutput>
				<cfabort>
		   </cfcatch>
		   </cftry>
		   
</cfif>
			   
			   


