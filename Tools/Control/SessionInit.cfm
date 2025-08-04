<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name = "Attributes.account"         default="">
<cfparam name = "Attributes.width"           default="1280">
<cfparam name = "Attributes.height"          default="1024">
<cfparam name = "Attributes.innerHeight"     default="">    
<cfparam name = "Attributes.color" 	         default="">    
<cfparam name = "Attributes.welcome"         default="">    

<cfparam name = "Attributes.DisableTimeout" 		default="">    
<cfparam name = "Attributes.AllowMultipleLogon" 	default="">    
<cfparam name = "Attributes.account"     			default="">   
<cfparam name = "Attributes.firstName"  			default="">    
<cfparam name = "Attributes.lastName"  				default="">    
<cfparam name = "Attributes.AccountGroup"  			default="">    
<cfparam name = "Attributes.personno"  				default="">    
<cfparam name = "Attributes.indexno"  				default="">  
<cfparam name = "Attributes.eMail"					default="">	
<cfparam name = "Attributes.eMailExt"				default="">
<cfparam name = "Attributes.actionScript"			default="">
<cfparam name = "Attributes.Pref_PageRecords"		default="40">
<cfparam name = "Attributes.Pref_SystemLanguage"	default="">
<cfparam name = "Attributes.Pref_Interface" 		default="">
<cfparam name = "Attributes.Pref_GoogleMAP"			default="">

<cfparam name = "Attributes.IndexNoName" 			default = "No">
<cfparam name = "Attributes.Interface" 				default = "No">    
<cfparam name = "Attributes.CandidateNo" 			default = "No">

<!---- PARAMETER --->

<cfquery name="Parameter" 
datasource="AppsInit">
	SELECT *
	FROM   Parameter
	WHERE  Hostname = '#CGI.HTTP_HOST#' 
</cfquery>

<cfif Len(Trim(Parameter.DefaultPassword)) gt 20> 
      <!--- encrypt password --->
      <cf_decrypt text = "#Parameter.DefaultPassword#">
	  <cfset password = Decrypted>
      <!--- end encryption --->
<cfelse>	  
      <cfset password = Parameter.DefaultPassword>
</cfif>	  

<cfset SESSION.dbpw                 = "#password#">
<cfset SESSION.login                = "#Parameter.DefaultLogin#">

<cfif Attributes.DisableTimeOut neq "">
	<cfset CLIENT.DisableTimeout    =   Attributes.DisableTimeOut>
</cfif>	

<cfif Attributes.AllowMultipleLogon neq "">
	<cfset CLIENT.MultipleLogon     =   Attributes.AllowMultipleLogon>
</cfif>	

<cfif Attributes.Account neq "">
	<cfset SESSION.Logon            =   Attributes.Account>
</cfif>

<cfif Attributes.FirstName neq "">
	<cfset SESSION.first            =   Attributes.FirstName>
</cfif>
	
<cfif Attributes.LastName neq "">
	<cfset SESSION.last             =   Attributes.LastName>
</cfif>	

<cfif Attributes.AccountGroup neq "">
	<cfset CLIENT.section           =   Attributes.AccountGroup>
</cfif>

<cfif Attributes.PersonNo neq "">	
	<cfset CLIENT.personno          =   Attributes.PersonNo>
<cfelseif NOT ISDEFINED("CLIENT.PersonNo")>
	<cfset CLIENT.personno          = "">
</cfif>
	
<cfif Attributes.IndexNo neq "">
	<cfset CLIENT.indexno           = Attributes.IndexNo>	   
</cfif>	

<cfif Attributes.welcome neq "">
	<cfset SESSION.welcome 	 		= Attributes.welcome>
</cfif>

<cfif Attributes.eMail neq "">
	   <cfset CLIENT.eMail          = Attributes.eMail>
</cfif>

<cfif Attributes.eMailExt neq "">	   
	   <cfset CLIENT.eMailExt       = Attributes.eMailExt>
</cfif>
	   
<cfif Attributes.actionScript neq "">
	   <cfset CLIENT.actionScript   = Attributes.actionScript>
</cfif>

<cfif Attributes.Pref_PageRecords neq "">	   
	<cfset CLIENT.PageRecords    	= Attributes.Pref_PageRecords>
</cfif>	

<cfif Attributes.Pref_SystemLanguage neq "">	   
	   <cfset CLIENT.SystemLanguage = Attributes.Pref_SystemLanguage>
</cfif>	   

<cfif Attributes.IndexNoName eq "Yes">
	  <cf_verifyOperational module="Staffing" Warning="No">	   
	   
	  <cfif operational eq "1">
		  <cfquery name="EParameter" 
			datasource="AppsEmployee">
			 SELECT * 
	    	 FROM Parameter
		   </cfquery>

		   <cfset CLIENT.IndexNoName  = "#EParameter.IndexNoName#">
	   
	   <cfelse>
	   
	       <cfset Client.IndexNoName = "IndexNo">
		   
	   </cfif>
</cfif>

	<cfif Attributes.Interface eq "Yes">
	
		   <cfquery name="AccountGroup" 
			datasource="AppsSystem">
				SELECT *
				FROM   Ref_AccountGroup
				WHERE  AccountGroup = '#Attributes.AccountGroup#' 
		   </cfquery>	   	   
		   
		   <cfif AccountGroup.UserInterface eq "HTML">
		   	   <cfset CLIENT.interface    = AccountGroup.UserInterface>
		   <cfelse>
		   	   <cfset CLIENT.interface    = Attributes.Pref_Interface>
		   </cfif>
		   
	<cfelse>
	
			<cfset CLIENT.Interface = "HTML">	   
			
	</cfif>
	

<cfif Attributes.CandidateNo eq "Yes">
   <cf_verifyOperational module="Roster" Warning="No">
	   
   <cfparam name="CLIENT.IndexNo"    default="">
	   
   <cfif Operational eq "1" and CLIENT.IndexNo neq "">
  	   				  
	   <cfquery name="Candidate" 
	    datasource="AppsSelection">
		    SELECT PersonNo
		    FROM   Applicant
		    WHERE  IndexNo = '#Attributes.IndexNo#'
			ORDER BY CREATED DESC 
	   </cfquery> 
		   
	   	<cfset CLIENT.candNo = Candidate.PersonNo>
				  	   
   </cfif>	   
</cfif>

<!---- INITIALIZING --->

<cfparam name="CLIENT.PortalId"      default="">

<cfquery name="BaseLanguage" 
	 datasource="AppsSystem">
	 SELECT  *
	 FROM    Ref_SystemLanguage
	 WHERE   Operational IN  ('1','2') 		 
	 AND 	 SystemDefault = '1'
</cfquery>

<cfif BaseLanguage.recordcount eq "0">
	<cfparam name="CLIENT.LanguageId"    default="ENG">
<cfelse>
	<cfparam name="CLIENT.LanguageId"    default="#BaseLanguage.code#">	
</cfif>
<cfparam name="CLIENT.LanPrefix"     default="">

<!--- set locale for date expressions --->

<cfswitch expression="#CLIENT.LanguageId#">

	<cfcase value="ENG">
		<cfset session.locale = "English (US)">
	</cfcase>
	
	<cfcase value="ESP">
		<cfset session.locale = "Spanish (Standard)">
	</cfcase>
	
	<cfcase value="FRA">
		<cfset session.locale = "French (Standard)">
	</cfcase>
	
	<cfcase value="GER">
		<cfset session.locale = "German (Standard)">
	</cfcase>
	
	<cfcase value="ITA">
		<cfset session.locale = "Italian (Standard)">
	</cfcase>
	
	<cfcase value="NET">
		<cfset session.locale = "Dutch (Standard)">
	</cfcase>
	
	<cfcase value="POR">
		<cfset session.locale = "Portuguese (Standard)">
	</cfcase>

</cfswitch>

<cfparam name="URL.ID" default = "">

<!---- LAYOUT RELATED --->
<cfset CLIENT.widthFull   = Attributes.width>
<cfset CLIENT.width       = Attributes.width>
<cfset CLIENT.height      = Attributes.height>

<cfif NOT ISDEFINED("CLIENT.innerHeight")>		
	<cfset CLIENT.innerHeight = "#Attributes.innerHeight#">   
</cfif>	

<cfif NOT ISDEFINED("CLIENT.color")>
	<cfset CLIENT.color 	  = "#Attributes.color#">
</cfif>	

<!---- SYSTEM ---->
<cfquery name="System" 
   datasource="AppsSystem">
      SELECT * 
	  FROM Parameter 
</cfquery> 

<cfif System.VirtualDirectory neq "">
	<cfset CLIENT.VirtualDir  = "/#System.VirtualDirectory#">
<cfelse>
    <cfset CLIENT.VirtualDir  = "">
</cfif>

<cfif System.DateFormat is "EU">
     <cfset CLIENT.DateFormatShow      = "dd/mm/yyyy">
	 <cfset CLIENT.DateFormatShowS     = "mm/yyyy">
	 <cfset APPLICATION.DateFormatCal  = "%d/%m/%Y">
<cfelse> 
     <cfset CLIENT.DateFormatShow   = "mm/dd/yyyy">
     <cfset CLIENT.DateFormatShowS     = "mm/yyyy">
     <cfset APPLICATION.DateFormatCal  = "%m/%d/%Y">
</cfif>
   
<cfset APPLICATION.DateFormatSQL   = "#System.DateFormatSQL#">
<cfif System.DateFormatSQL is "EU">
       <cfset CLIENT.dateSQL   = "dd/mm/yyyy">
<cfelse> 
       <cfset CLIENT.dateSQL   = "mm/dd/yyyy">
</cfif>

<cfset CLIENT.eMailDefault      = System.DefaultEMail>
	   
<!--- the default link for the document server to be shown ideally I prefer 
  to show all documents first through a move of the file as we do 
  for opening --->	
	
<cfset SESSION.rootDocument     = System.DocumentServer>  


<cfset CLIENT.ReportingServer   = System.ReportingServer>
  
<cfset APPLICATION.BaseCurrency   = System.BaseCurrency>
<cfset SESSION.root               = Replace(#SESSION.root#,' ','','ALL')>
<cfset CLIENT.MailTo       		  = "">
<cfset CLIENT.Verbose      		  = 1>
<cfset CLIENT.mailtemplate    	  = System.ReportMailTemplate>    
<cfset CLIENT.timeout             = System.SessionExpiration>   
<cfset CLIENT.Collation           = System.SQLCollate>
<cfset SESSION.LogonMode    	  = System.LogonMode>	
		

<cfset client.googleMAPId = Parameter.GoogleMAPId>

<cfif client.googleMAPId eq "">	   
   	   <cfset CLIENT.GoogleMAP = "0">	   
<cfelse>	   
   <cfset CLIENT.GoogleMAP = Attributes.Pref_GoogleMAP>	   
</cfif>

<cfset CLIENT.Refer                = "">

<cfset CLIENT.cfpath               = "#Parameter.CFRootPath#">
<cfset CLIENT.servername           = "#Parameter.ApplicationServer#">
<cfset CLIENT.hostNo               = "#Parameter.HostSerialNo#">
<cfset CLIENT.TemplateLogging      = "#Parameter.TemplateLogging#">
<cfset CLIENT.Review               = "x">
<cfset CLIENT.DataSource           = "AppsVacancy"> <!--- default --->
<cfset CLIENT.OrgUnit              = ""> 
<cfset CLIENT.Edition              = "">
<cfset CLIENT.SubmissionEdition    = "">
<cfset CLIENT.Submission           = "MANUAL">
<cfset SESSION.author              = "#Parameter.SystemDevelopment#">
<cfset SESSION.root                 = "#Parameter.ApplicationRoot#">

<!--- temporary measurement only can likely be removed as this is part of AppInit --->
<cfset CLIENT.root                  = "#Parameter.ApplicationRoot#">

<cfset SESSION.rootPath             = "#Parameter.ApplicationRootPath#">
<cfset SESSION.protectionmode       = "#Parameter.SessionProtectionMode#">

<cfif Parameter.DocumentRoot neq "">	
	    <cfset SESSION.rootDocument = "#Parameter.DocumentRoot#"> 
</cfif>
<cfset SESSION.rootDocumentPath     = "#Parameter.DocumentRootPath#">

<cfset SESSION.rootReport           = "#Parameter.ReportRoot#">
<cfset SESSION.rootReportPath       = "#Parameter.ReportRootPath#">
<cfset CLIENT.SessionNo             = "#Parameter.SessionNo#">
<cfset CLIENT.Editing               = "#Parameter.EnableCM#">

<cfif NOT ISDEFINED("SESSION.isAdministrator")>
	<cfset SESSION.isAdministrator = "No">
</cfif>   

<cfif NOT ISDEFINED("CLIENT.style")>
	<cfset CLIENT.Style = "">
</cfif>   

<cfif NOT ISDEFINED("SESSION.acc")>
	<cfset SESSION.acc = "">
</cfif>   

<cfif Attributes.Account neq "">
	<cfset Session.ACC = Attributes.Account>
</cfif>	


