
<cfparam name="attributes.mission"     default="zzzz">
<cfparam name="attributes.sigaction"   default="">
<cfparam name="attributes.account"     default="">
<cfparam name="attributes.title"       default="auto">
<cfparam name="attributes.unit"        default="auto">
<cfparam name="attributes.memo"        default="">
<cfparam name="attributes.date"        default="auto">
<cfparam name="attributes.id"          default="">
<cfparam name="attributes.imageheight" default="80">
<cfparam name="attributes.imagewidth"  default="200">

<cfoutput>

	<cfquery name="user" 
	datasource="AppsSystem" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 	 SELECT   *
		 FROM     UserNames
		 WHERE    Account = '#attributes.Account#'
	</cfquery>	
	
	<cfset action = attributes.sigAction>
	<cfset first  = user.FirstName>
	<cfset last   = user.LastName>
	<cfset unit   = attributes.Unit>
	<cfset title  = attributes.Title>
	<cfset memo   = attributes.Memo>
		
	<cfif user.PersonNo neq "">
	
		<cfquery name="Person" 
		datasource="AppsEmployee" 
	    username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 	 SELECT   *
			 FROM     Person
			 WHERE    PersonNo = '#user.PersonNo#'
		</cfquery>	
		
		<cfif Person.recordcount gte "1">
		
			<cfset first = Person.FirstName>
			<cfset last  = Person.LastName>
			
			<cfquery name="OnBoard" 
				 datasource="AppsEmployee"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT   P.*, O.OrgUnitName, O.OrgUnitNameShort
				 FROM     PersonAssignment PA, Position P, Organization.dbo.Organization O
				 WHERE    PersonNo   = '#user.PersonNo#' 
				 AND      PA.PositionNo      = P.PositionNo
				 AND      PA.DateEffective   <= getdate()	 
				 AND      P.OrgUnitOperational = O.OrgUnit
				 AND      P.Mission = '#attributes.mission#'						
				 AND      PA.DateExpiration  >= getDate()						 
				 AND      PA.AssignmentStatus IN ('0','1')
				 <!---
				 AND      PA.AssignmentClass = 'Regular'
				 --->
				 AND      PA.AssignmentType  = 'Actual'
				 ORDER BY Incumbency DESC						
			 </cfquery>  
			 
			 <cfif attributes.title eq "Auto">
			 
				 <cfset title = OnBoard.FunctionDescription>			
			 
			 </cfif>	
			 
			 <cfif attributes.unit eq "Auto">
			 
			 	<cfif OnBoard.OrgUnitNameShort neq "">
				  <cfset unit = "#OnBoard.OrgUnitName# / #Onboard.OrgUnitNameShort#">				 
				<cfelse>
				  <cfset unit = "#OnBoard.OrgUnitName#">	
				</cfif> 				 
						 
			 </cfif>				
		
		</cfif>
	
	</cfif>

	<cf_assignid>
	
	<cftry>
	 <cfdirectory action="CREATE" directory="#SESSION.rootPath#\CFRStage\Signature\">
	 <cfcatch></cfcatch>
	</cftry> 

	<table width="400" height="90">

	<tr><td align="center">

	 <cfif FileExists("#SESSION.rootDocumentPath#\User\Signature\#attributes.account#.png")>	
	 
	 	<cffile action="COPY" 
			source="#SESSION.rootDocumentPath#\User\Signature\#attributes.account#.png" 
	    	destination="#SESSION.rootPath#\CFRStage\Signature\#attributes.account#.jpg" nameconflict="OVERWRITE">  	 
		 	 								 		
		  <img src="#SESSION.root#\\CFRStage\Signature\#attributes.account#.jpg?id=#rowguid#"			   
			   border="0"
			   align="absmiddle"
               height="#attributes.imageheight#" 
			   width="#attributes.imagewidth#">			  			  
						
	 <cfelseif FileExists("#SESSION.rootDocumentPath#\User\Signature\#attributes.account#.jpg")>	
	 
	 	  <cffile action="COPY" 
			source="#SESSION.rootDocumentPath#\User\Signature\#attributes.account#.jpg" 
	    	destination="#SESSION.rootPath#\CFRStage\Signature\#attributes.account#.jpg" nameconflict="OVERWRITE">   	
	 	 											 		
		  <img src="#SESSION.root#\\CFRStage\Signature\#attributes.account#.jpg?id=#rowguid#"			   
			   border="0"
			   align="absmiddle"
               height="#attributes.imageheight#" 
			   width="#attributes.imagewidth#">
		 
  	 <cfelse>		 
			 
		   <img src="#SESSION.root#/Images/image-not-found.gif" alt="Not found" 
		       style="height: auto;width: #attributes.imagewidth#px;margin: auto;" 
			   border="0" 
			   align="absmiddle">
			  
	 </cfif>
	
	 </td></tr>
	 
	 <tr class="labelit"><td align="center"><cfif action neq "">#action# </cfif>#first# #last#</td></tr>
	 	 	 
	 <cfif memo neq "">
	 <tr class="labelit"><td align="center">#memo#</td></tr>
	 </cfif>
	 
	 <cfif title neq "">
	 <tr class="labelit"><td align="center">#title#</td></tr>
	 </cfif>
	 
	 <cfif unit neq "">
	 <tr class="labelit"><td align="center">#unit#</td></tr>
	 </cfif>
	 
	 <tr class="labelit"><td align="center"><cf_tl id="Signed on">
	 <cfif attributes.date eq "auto" or attributes.date eq "yes">
	 #dateformat(now(),client.dateformatshow)# <cf_tl id="at"> #timeformat(now(),"kk:mm tt")#
	 <cfelse>
	 #dateformat(attributes.date,client.dateformatshow)# <cf_tl id="at"> #timeformat(attributes.date,"kk:mm tt")#
	 </cfif>
	 <cfif attributes.id neq ""><br><font size="1">ID: #attributes.id#</font></cfif>
	 </td></tr>
	 

	</table>	
	 
</cfoutput>	 	 
	 
 
	 
