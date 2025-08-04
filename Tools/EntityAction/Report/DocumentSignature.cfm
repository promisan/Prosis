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

<cfparam name="attributes.mission"     default="zzzz">
<cfparam name="attributes.header"      default="">
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
	
	<cfset header = attributes.header>
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
	
			
	<table style="width:100%" border="0"><tr><td style="padding-left:15px">

		<table style="width:500px" height="90">
			 
		 <cfif header neq "">
		 <tr class="labelmedium"><td style="font-size:16px">#header#</td></tr>
		 </cfif>		 		  
		 <cfif action neq "">
		 <tr class="labelmedium"><td style="font-size:16px">#action#:<p></td></tr>
		 </cfif>		 
		 <tr class="labelmedium"><td style="font-size:16px">#first# #ucase(last)#, #title#</td></tr>		 	 	 
		 <cfif memo neq "">
		 <tr class="labelmedium"><td style="font-size:16px">#memo#</td></tr>
		 </cfif>				 
		 <cfif unit neq "">
		 <tr class="labelmedium"><td style="font-size:16px">#unit#</td></tr>
		 </cfif>		 
		 <tr class="labelmedium"><td><font size="1" ><cf_tl id="Signed on">
		 <cfif attributes.date eq "auto" or attributes.date eq "yes">
		 #dateformat(now(),client.dateformatshow)# <cf_tl id="at"> #timeformat(now(),"kk:mm tt")#
		 <cfelse>
		 #dateformat(attributes.date,client.dateformatshow)# <cf_tl id="at"> #timeformat(attributes.date,"kk:mm tt")#
		 </cfif>	
		 </td>
		 </tr>	
		 
		</table>	
	
	</td>
	
	<td>
	
		<table>
		
		<tr><td style="width:100%" valign="top">
		
		 				
		 <cfif len(user.signature) gte "1000">
		 		 
		    <img src="#user.signature#"	align="absmiddle" height="#attributes.imageheight#" width="#attributes.imagewidth#">
		 
		 <cfelse>
	
			 <cfif FileExists("#SESSION.rootDocumentPath#\User\Signature\#attributes.account#.png")>	
							
			 	<cffile action="COPY" 
					source="#SESSION.rootDocumentPath#\User\Signature\#attributes.account#.png" 
			    	destination="#SESSION.rootPath#\CFRStage\Signature\#attributes.account#.jpg" nameconflict="OVERWRITE">  	
										
				 <cfimage name="vSignature" action="read" source="#SESSION.rootPath#\CFRStage\Signature\#attributes.account#.jpg"/> 
				 				
			 <cfelseif FileExists("#SESSION.rootDocumentPath#\User\Signature\#attributes.account#.jpg")>	 
			 	
			 	  <cffile action="COPY" 
					source="#SESSION.rootDocumentPath#\User\Signature\#attributes.account#.jpg" 
			    	destination="#SESSION.rootPath#\CFRStage\Signature\#attributes.account#.jpg" nameconflict="OVERWRITE">   	
					
				  <cfimage name="vSignature" action="read" source="#SESSION.rootPath#\CFRStage\Signature\#attributes.account#.jpg"/>
			 			 
		  	 <cfelse>	
			 			 
			 	  <cfimage name="vSignature" action="read" source="#SESSION.root#/Images/image-not-found.gif"/>		 
								  
			 </cfif>
																	
			 <img src="data:image/*;base64,#toBase64(vSignature)#"	align="absmiddle" height="#attributes.imageheight#" width="#attributes.imagewidth#">
					
			 
		</cfif>	 						
		 
		 </td></tr>
		 
		 <cfif attributes.id neq "">
		 <tr class="labelmedium"><td align="center"><font size="1" color="0080FF">id: #attributes.id#</font></td></tr>
		 </cfif>
		 
		 </table>
	 
	</td>
	
	</tr>
	
	<tr><td colspan="2"><hr noshade style="height:1px;background-color:silver"></td></tr>
	
	</table>
	
	 
</cfoutput>	 	 
 
	 
