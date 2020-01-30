<cfparam name="FORM.AuthorizationAccount" default="">

<CF_DateConvert Value="#FORM.DateEffective_Date#">
<cfset tDate = dateValue>	
<cfset hour = Evaluate("#FORM.DateEffective_hour#")>
<cfset minute = Evaluate("#FORM.DateEffective_minute#")>
<cfset vDate = DateAdd("h", hour, tDate)>		
<cfset vDateEffective = DateAdd("n", minute, vDate)>

<CF_DateConvert Value="#FORM.DateExpiration_Date#">
<cfset tDate = dateValue>	
<cfset hour = Evaluate("#FORM.DateExpiration_hour#")>
<cfset minute = Evaluate("#FORM.DateExpiration_minute#")>
<cfset vDate = DateAdd("h", hour, tDate)>		
<cfset vDateExpiration = DateAdd("n", minute, vDate)>


<cfquery name="qInsert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
INSERT INTO Ref_ModuleControlAuthorization
           (
           SystemFunctionId
		   <cfif FORM.AuthorizationAccount neq "">
	           ,Account
		   </cfif>
   		   <cfif FORM.AuthorizationMission neq "">
	           ,Mission
			</cfif>	   
			<cfif FORM.DateEffective_Date neq "">			
	           ,DateEffective
			</cfif>
			<cfif FORM.DateExpiration_Date neq "">   
	           ,DateExpiration
			</cfif>   
			<cfif FORM.AuthorizationLevel neq "">   			
	           ,AuthorizationLevel
			</cfif>   
			<cfif FORM.AuthorizationCode neq "">   									
	           ,AuthorizationCode
			</cfif>   
           ,OfficerUserId
           ,OfficerLastName
           ,OfficerFirstName)
     VALUES
           (
           '#URL.ID#'
		   <cfif FORM.AuthorizationAccount neq "">
	           ,'#FORM.AuthorizationAccount#'
		   </cfif>
   		   <cfif FORM.AuthorizationMission neq "">
	           ,'#FORM.AuthorizationMission#'
			</cfif>	   
			<cfif FORM.DateEffective_Date neq "">
	           ,#vDateEffective#
			</cfif>
			<cfif FORM.DateExpiration_Date neq "">   
	           ,#vDateExpiration#
			</cfif>   
			<cfif FORM.AuthorizationLevel neq "">   						
	           ,'#FORM.AuthorizationLevel#'
		 	</cfif>	   
			<cfif FORM.AuthorizationCode neq "">   												
	           ,'#FORM.AuthorizationCode#'
			</cfif>   
           ,'#SESSION.Acc#'
           ,'#SESSION.Last#'
           ,'#SESSION.First#')
</cfquery>

<cfset URL.mode = "active">
<cfinclude template="AuthorizationRoles.cfm">