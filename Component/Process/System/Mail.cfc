<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Mail functions">

	<cffunction name="MailContentConversion"
        access="public"
        returntype="string">
		
		<cfargument name="DataSource"  type="string"  required="false" default="appsOrganization">			
		<cfargument name="ObjectId"    type="string"  required="false" default="">	
		<cfargument name="ActionId"    type="string"  required="false" default="">	
		<cfargument name="PersonNo"    type="string"  required="false" default="">	
		<cfargument name="FunctionId"  type="string"  required="false" default="">
		<cfargument name="DateTime"    type="string"  required="false" default="">			
		<cfargument name="Content"     type="string"  required="yes">	 	 				
				
		<cfif ObjectId neq "">
		
			<cfquery name="Object" 
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      OrganizationObject 						
				WHERE     ObjectId = '#ObjectId#'
			</cfquery>
			
			 <cfset htmllink = "<a href='#SESSION.root#/ActionView.cfm?id=#Object.Objectid#'><font color='0080FF'>Click here to process</font></a>">			  
				  
			  <cfset content = replaceNoCase( "#content#", "@link",     "#htmllink#",                                "ALL")>				
			  <cfset content = replaceNoCase( "#content#", "@user",     "#SESSION.first# #SESSION.last#",            "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@ref1",     "#Object.ObjectReference#",                  "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@ref2",     "#Object.ObjectReference2#",                 "ALL")>			 
			  <cfset content = replaceNoCase( "#content#", "@mission",  "#Object.Mission#",                          "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@owner",    "#Object.Owner#",                            "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@holder",   "#Object.OfficerFirstName# #Object.OfficerLastName#",       "ALL")>	
			  <cfset content = replaceNoCase( "#content#", "@ipaddress","#Object.OfficerNodeIP#",                    "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@today",    "#dateformat(now(),CLIENT.DateFormatShow)#", "ALL")>
			  <cfset content = replaceNoCase( "#content#", "@time",     "#timeformat(now(),'HH:MM')#",               "ALL")>
						
		</cfif>	
		
		<cfif ActionId neq "">					
							
			 <cfquery name="Object" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT    O.*, 
					          A.ActionCode, 
							  A.TriggerActionType, 
							  A.TriggerActionId,
							  R.PersonClass,
							  AA.ActionDescription,
							  AA.ActionCompleted,
							  R.DocumentPathName,
							  R.MailFrom,
							  R.MailFromAddress,
							  R.EntityDescription,
							  C.EntityClassName,
							  R.EnableEMail,
							  C.EnableEMail as ClassMail
					FROM      OrganizationObject O, 
					          OrganizationObjectAction A,
							  Ref_EntityActionPublish AA,  
							  Ref_Entity R,
							  Ref_EntityClass C
					WHERE     O.ObjectId        = A.ObjectId 
					AND       R.EntityCode      = O.EntityCode
					AND       A.ActionPublishNo = AA.ActionPublishNo 
					AND       A.ActionCode      = AA.ActionCode
					AND       C.EntityCode      = O.EntityCode
					AND       C.EntityClass     = O.EntityClass
					AND       A.ActionId        = '#ActionId#' 	
				
			  </cfquery>	
				
			  <cfset content = replaceNoCase( "#content#", "@action",   "#Object.ActionDescription#","ALL")>
  			  <cfset content = replaceNoCase( "#content#", "@entity",   "#Object.EntityDescription#","ALL")>
  			  <cfset content = replaceNoCase( "#content#", "@class",    "#Object.EntityClassName#","ALL")>
			  
		</cfif>	  
		
		<cfif PersonNo neq "">
		
			<cfquery name="Person" 
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Employee.dbo.Person 						
				WHERE     PersonNo = '#PersonNo#'
			</cfquery>
			
			<cfif Person.recordcount eq "0">
			
				<cfquery name="Person" 
					datasource="#DataSource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    * 
					FROM      Applicant.dbo.Applicant 						
					WHERE     PersonNo = '#PersonNo#'
				</cfquery>
							
			</cfif>
						
			<cfset content = replaceNoCase( "#content#", "@personemail","#Person.EmailAddress#","ALL")>
			<cfset content = replaceNoCase( "#content#", "@person","#Person.FirstName# #Person.LastName#","ALL")>
				
		</cfif>
		
		<cfif FunctionId neq "">
		
			<cfquery name="Function" 
					datasource="#DataSource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    * 
					FROM      Applicant.dbo.FunctionOrganization 						
					WHERE     FunctionId = '#FunctionId#'
				</cfquery>
				
			<cfset content = replaceNoCase( "#content#", "@functionid","#Function.ReferenceNo#","ALL")>
				
		</cfif>
		
		<cfif DateTime neq "">
					
			<cfset content = replaceNoCase( "#content#", "@datetime","#dateformat(DateTime,'DDDD DD MMMM YYYY')# #TimeFormat(DateTime,'HH:MM')#","ALL")>
		
		</cfif>
						
		<cfreturn content>		   	
				
	</cffunction>	
	
</cfcomponent>			 