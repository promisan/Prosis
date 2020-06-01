<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Hanno van Pelt</proOwn>
 <proDes>Annotated the custom method</proDes>
 <proCom></proCom>
 <proCM></proCM>
</cfsilent>




<!--- Prosis navigation button bar which has options for 

In addition to the button you need to pass the menu reference to the <Object>Section table which is

OBJECT    : ObjectName like 'Claim'
ID        : Record Id like the value of claimId
SECTION   : The code of the current section in the Ref_ClaimSection table
GROUP     : The Group of the section like TravelClaim as defined in Ref_ClaimSection
ALIAS     : CF Datasource for the location of the MASTER table LIKE ClaimSection in AppsTravelClaim
TABLENAME : is defaulted to the OBJECT name (recommended to use the default)

ButtonClass and ButtonClassOver : default style class when opening and when moving mouse over it.
BOXCLASS  : the style of the button bar contained in a table frame
HIDEBAR   : hides the bar completely for the user

BACK, NEXT, PROCESS, RESET, HOME are the names of 5 buttons with all the following attributes as a standard

[button]ENABLE : show values : 1/0
[button]NAME : label of the button
[button]ICON : graphic to be shown in buttom

	default behavior :

	- Back tries to go back to the prior menu option, which means left menu is highlighted and right screen is reloded with prior topic
	- Next tries to go to the next menu option by submitting the form (in case NextSubmit = 1) or running a script that will complete
	the current step and launch the new step
	- Home tries to return to the home page as defined in the parameter table  Parameter.TemplateHome
	- Reset reset the <Object>Section records which means all menu options need to be completed again.
	- Process submits (in case NextSubmit = 1) or launches a script called calculate() to be defined on the template itself

BACKDEFAULT : 0 runs script, 1 applies standard IE 6/7 browser back behavior

SEXTNEXT : indicator that will set the step that is indicated in Section to completed upon loading of this template

NEXTSUBMIT : defines the Process (!!) button (see above) as a {submit} button if set to 1, allowing you to submit the form that is loaded which requires
a <form> </form> tag to be present

NEXTSCRIPT : define a script to be executed when pressing next

RELOAD : enforces the left menu to be reloades upon launching of the template.

--->

<cfparam name="URL.code"     default="0">
<cfparam name="URL.reload"   default="0">
<cfparam name="URL.owner"    default="">
<cfparam name="URL.mission"  default="">

<cfparam name="Attributes.Alias"           default="appsTravelClaim">
<cfparam name="Attributes.Object"          default="Claim">
<cfparam name="Attributes.ObjectId"        default="Id">
<cfparam name="Attributes.TableName"       default="#Attributes.Object#">
<cfparam name="Attributes.SectionTable"    default="Ref_#Attributes.TableName#Section">

<cfquery name="Section" 
		datasource="#Attributes.Alias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     #CLIENT.LanPrefix##Attributes.SectionTable#
			WHERE    Code = '#attributes.Section#' 
</cfquery>

<cfset Attributes.TriggerGroup = section.triggergroup>

<cfparam name="Alias"                      default="#Attributes.Alias#">
<cfparam name="TableName"                  default="#Attributes.TableName#">
<cfparam name="Object"                     default="#Attributes.Object#">
<cfparam name="ObjectId"                   default="#Attributes.ObjectId#">

<cfif tableName eq "">
   <cfset tableName = "#Object#">
</cfif>

<!--- presentation attributes, use defaults --->
<cfparam name="Attributes.Align"           default="Center">
<cfparam name="Attributes.Table"           default="Yes">

<cfparam name="Attributes.reload"          default="#url.reload#">
<cfparam name="Attributes.OpenDirect"      default="0"> <!--- 0, current, next --->
<cfparam name="Attributes.ButtonClass"     default="ButtonNav1">
<cfparam name="Attributes.ButtonClassOver" default="ButtonNav11">
<cfparam name="Attributes.ButtonWidth"     default="150">
<cfparam name="Attributes.ButtonHeight"    default="32">
<cfparam name="Attributes.BoxClass"        default="">
<cfparam name="Attributes.HideBar"         default="0">

<cfparam name="Attributes.SetNext"         default="1">  <!--- indicates the currently loading step immediately as completed --->

<cfparam name="Attributes.NextEnable"      default="2">  <!--- show option for next button --->
<cfparam name="Attributes.NextName"        default="Save and Next">
<cfparam name="Attributes.NextIcon"        default="Nav_next.gif">
<cfparam name="Attributes.NextLastName"    default="Last">
<cfparam name="Attributes.NextLastIcon"    default="Nav_next.gif">

<cfparam name="Attributes.SaveSubmit"      default="0">  <!--- shows a save button only --->
<cfparam name="Attributes.NextSubmit"      default="0">  <!--- launches the submit method from the calling FORM --->
<cfparam name="Attributes.NextMode"        default="1">  <!--- allow user to indeed click on the next option TCP added attribute --->
<cfparam name="Attributes.NextScript"      default="">   <!--- processes a local script --->

<cfparam name="Attributes.BackEnable"      default="1">
<cfparam name="Attributes.BackDefault"     default="0">
<cfparam name="Attributes.BackName"        default="Back">
<cfparam name="Attributes.BackIcon"        default="Nav_back.gif">
<cfparam name="Attributes.BackScript"      default="prior()">

<cfparam name="Attributes.ResetEnable"     default="1">
<cfparam name="Attributes.ResetName"       default="Restart #Object#">
<cfparam name="Attributes.ResetIcon"       default="Nav_reset.gif">
<cfparam name="Attributes.ResetDelete"     default="1">
<cfparam name="Attributes.ResetQuestion"   default="1">

<cfparam name="Attributes.ProcessEnable"   default="1">
<cfparam name="Attributes.ProcessName"     default="Calculate #Object#">
<cfparam name="Attributes.ProcessIcon"     default="Nav_process.gif">

<cfparam name="Attributes.HomeEnable"      default="1">
<cfparam name="Attributes.HomeName"        default="Continue later">
<cfparam name="Attributes.HomeIcon"        default="Nav_home.gif">

<cfparam name="Attributes.IconWidth"       default="48">
<cfparam name="Attributes.IconHeight"      default="48">

<cfparam name="Attributes.Theme"      	   default="default"> <!--- default (Orange), lightblue, blue, white, gray --->

<cfset vBtnColor = "##48617C">
<cfset vBtnBorderColor = "##48617C">
<cfset vBtnTextColor = "##FFFFFF">
<cfset vBtnTextSize = "14px">
<cfset vBtnNextImg = "nav_flat_next.png">
<cfset vBtnBackImg = "Logos/PAS/nav_flat_back.png">
<cfset vBtnLastImg = "nav_flat_last.png">
<cfset vBtnProcessImg = "nav_flat_process.png">
<cfset vBtnResetImg = "nav_flat_reset.png">
<cfset vBtnImgHeight = "14px">

<cfinclude template="NavigationTheme.cfm">

<cfquery name="Parameter" 
	datasource="#Alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
    	FROM Parameter R
</cfquery>

<cfinclude template="NavigationScript.cfm">

<cfquery name="Select" 
	datasource="#Alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM   #TableName# R
    	WHERE  #Object##ObjectId# = '#Attributes.Id#' 
</cfquery>

<cftry>

	<!--- Check if the table has an underline owner restriction --->
	
	<cfquery name="qCheckOwnerSection" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     #CLIENT.LanPrefix#Ref_#Object#SectionOwner
		WHERE    Owner = <cfqueryparam value="#URL.Owner#" cfsqltype="CF_SQL_CHAR" maxlength="10"> 
	</cfquery>
	
	<cfset ValidateOwner = qCheckOwnerSection.recordcount>
		
	<cfcatch>
	
		<cfset ValidateOwner = 0>	
		
	</cfcatch>	
	
</cftry>

<cfif Select.ActionStatus neq "3">
        					
		<cfquery name="Current" 
		datasource="#Alias#">
			SELECT * 
			FROM  Ref_#Object#Section S
			WHERE Code = '#Attributes.Section#'			
			
				<cfif Object eq "Applicant">
					 AND S.TriggerGroup = '#Attributes.TriggerGroup#'	
				</cfif>
			  
				<cfif ValidateOwner neq 0>
					AND EXISTS
					(
						SELECT 'X'
						FROM #CLIENT.LanPrefix#Ref_#Object#SectionOwner
						WHERE Code = S.Code
						AND   Owner = <cfqueryparam value="#URL.Owner#" cfsqltype="CF_SQL_CHAR" maxlength="10">
						AND Operational = '1' 
					)
				</cfif>								
		</cfquery> 
		
		<cfif Attributes.SetNext eq "1">
		
			
			<cfquery name="Set" 
			datasource="#Alias#">
				UPDATE #Object#Section 
				SET    ProcessStatus       = 1, 
				       ProcessDate         = getDate(),
					   Operational		   = '#Current.Operational#',
					   OfficerUserId       = '#SESSION.acc#',
					   OfficerLastName     = '#SESSION.last#', 
					   OfficerFirstName    = '#SESSION.first#'
				WHERE  #Object##ObjectId#  = '#Attributes.Id#' 
				AND    ProcessStatus = 0
				AND    Operational = 1
				
				AND    #Object#Section IN (SELECT Code 
				                           FROM Ref_#Object#Section
										   WHERE ListingOrder <= '#Current.ListingOrder#'
										   AND   ResetOnUpdateParent is NULL AND Operational=1) 
			</cfquery> 
						
		</cfif>		
				
		<cfif Attributes.Section eq "Last">
		
		    <cfquery name="Check" 
			datasource="#Alias#">
				SELECT *
				FROM   #Object#Section S 
				WHERE  #Object##ObjectId#  = '#Attributes.Id#'
				
				<cfif Object eq "Applicant">
					 AND S.TriggerGroup = '#Attributes.TriggerGroup#'	
				</cfif>
				AND S.Operational = 1    
				AND #Object#Section IN (SELECT TOP 1 Code FROM Ref_#Object#Section WHERE Operational=1 ORDER BY Listingorder DESC)
				<cfif ValidateOwner neq 0>
					AND EXISTS
					(
						SELECT 'X'
						FROM  #CLIENT.LanPrefix#Ref_#Object#SectionOwner
						WHERE Code = S.#Object#Section
						AND   Owner = <cfqueryparam value="#URL.Owner#" cfsqltype="CF_SQL_CHAR" maxlength="10">
						AND   Operational = '1' 
					)
				</cfif>					
			</cfquery> 
			
			<cfif Check.recordcount gte "1">
		
				<cfquery name="All" 
				datasource="#Alias#">
					UPDATE #Object#Section 
					SET    ProcessStatus       = #Attributes.NextMode#, 
					       ProcessDate         = getDate(),
		   				   Operational		   = '#Current.Operational#',
						   OfficerUserId       = '#SESSION.acc#',
						   OfficerLastName     = '#SESSION.last#',
						   OfficerFirstName    = '#SESSION.first#'
					WHERE  #Object##ObjectId#  = '#Attributes.Id#' 
					AND    ProcessStatus        = '0' 
					AND    Operational = 1
				</cfquery> 
			
			</cfif>
			
			<cfset last = evaluate("Check.#Object#Section")>
		
		</cfif>
		
		<!--- ---------------------------- --->
		<!--- passtru special for TCP only --->
		<!--- ---------------------------- --->
		
		<cftry>
		
			<cfquery name="Event" 
				datasource="#Alias#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   SELECT   *
				   FROM     #Object#Event C
				   WHERE    #Object##ObjectId# = '#Attributes.Id#' 
				   ORDER BY EventDateEffective
			</cfquery>
			
			<cfset event = Event.ClaimEventid>
			
			<cfcatch>			
				<cfset event = "">			
			</cfcatch>
		
		</cftry>
				
		<cfoutput>
				
		<cfif Attributes.Table eq "Yes">
		
			<table><tr><td height="2"></td></tr></table>
		
		</cfif>		
				
		<cfif Attributes.HideBar eq "0">		
					
			<cfif Attributes.OpenDirect eq "0">
			
			      <cfif Attributes.Table eq "Yes">
			  
				  <table class="noprint" 
				         border="0" 
						 cellspacing="0" 
						 cellpadding="0"						 
						 align="#Attributes.Align#">					  
				 					  
				  <tr>
				  				  
				  </cfif>
				  			  
				  <cfif Attributes.BackEnable eq "1">
				  
				  		<cf_tl id="#Attributes.BackName#" var="1">
							
						<td style="padding:1px 1px 1px 1px">
						 <cf_button2 id     = "Back"
							text            = "#lt_text#" 
							bgcolor         = "#vBtnColor#"
							textColor       = "#vBtnTextColor#"
							textSize        = "#vBtnTextSize#"
							borderColor     = "#vBtnBorderColor#"
							borderColorInit = "#vBtnBorderColor#"
							image           = "#vBtnBackImg#"
							imageHeight     = "#vBtnImgHeight#"
							borderRadius    = "0px"
							height          = "#attributes.ButtonHeight#"						
							width           = "#Attributes.ButtonWidth#"
							onclick         = "#Attributes.BackScript#">
						</td>
						</cfif>  
						
						 <script language="JavaScript">
				  
						    function prior() {
							
							    parent.Prosis.busy('yes')	
								
							    <cfif #attributes.BackDefault# eq "0">
								
								 ptoken.location("#SESSION.root#/tools/Process/Navigation/NavigationNext.cfm?owner=#url.owner#&mission=#url.mission#&Code=#URL.Code#&alias=#Alias#&tablename=#tablename#&object=#object#&objectid=#objectid#&id=#Attributes.Id#&id1=#Event#&move=back&prior=#Current.ListingOrder#&group=#Attributes.TriggerGroup#") 
								 
								<cfelse>
								
								 history.go(-1)
								 
								</cfif> 
							 }
					 
					 	</script>
				  
				   	<cfif Attributes.ResetEnable eq "1">					
										
							<cf_tl id="#Attributes.ResetName#" var="1">
							<td style="padding:1px 1px 1px 1px">
							 <cf_button2 id="Reset"
								text   = "#lt_text#" 
								bgcolor = "#vBtnColor#"
								textColor = "#vBtnTextColor#"
								textSize = "#vBtnTextSize#"
								borderColor = "#vBtnBorderColor#"
								borderColorInit = "#vBtnBorderColor#"
								image   = "#vBtnResetImg#"
								imageHeight = "#vBtnImgHeight#"
								borderRadius = "0px"
								height = "#attributes.ButtonHeight#"
								width   = "#Attributes.ButtonWidth#"
								onclick = "javascript:revoke('#Attributes.ResetDelete#')">
					    	</td>
							
						</cfif>
						
						<script language="JavaScript">
						
							function revoke(del) {
						
							<cfif #Attributes.ResetQuestion# eq "1">
						
								if (confirm("The process information will be lost.  Are you sure that you want to restart this #Object# ?")) {
							        parent.ptoken.location("#SESSION.root#/tools/Process/Navigation/ObjectReset.cfm?owner=#url.owner#&mission=#url.mission#&Delete="+del+"&Code=#URL.Code#&alias=#Alias#&tablename=#tablename#&object=#object#&objectid=#objectid#&personNo=#CLIENT.personNo#&id=#Attributes.Id#&section=#attributes.section#")
								} else { return false }
							
							<cfelse>	
												
							    parent.ptoken.location("#SESSION.root#/tools/Process/Navigation/ObjectReset.cfm?owner=#url.owner#&mission=#url.mission#&Delete="+del+"&Code=#URL.Code#&alias=#Alias#&tablename=#tablename#&object=#object#&objectid=#objectid#&personNo=#CLIENT.personNo#&id=#Attributes.Id#")									
								  
							</cfif>
						
							}
						
						</script>
						
						<!--- no longer relevant in my views 4/9/2015
				  
				        <cfif Attributes.HomeEnable eq "1">
						
							<cf_tl id="#Attributes.HomeName#" var="1">
							<td>
							
					        <cf_button2 id="Home"
								text   = "#lt_text#"
								bgcolor = "D6D6D6" 
								width  = "#Attributes.ButtonWidth#"
								onclick = "home()">
								
							</td>
							<script language="JavaScript">
							
								function home() {
									 window.close();
								}
							
							</script>
				     						  
						</cfif>	  
						
						--->
									
						<cfif Attributes.ProcessEnable eq "1">
																								
						    <cfif Attributes.NextSubmit eq "0">
														
								<cf_tl id="#Attributes.ProcessName#" var="1">
								
								<td style="padding:1px 1px 1px 1px">
							 	
									<cf_button2 id   = "Process"
										text         = "#lt_text#"
										bgcolor      = "#vBtnColor#"
										textColor    = "#vBtnTextColor#"
										textSize     = "#vBtnTextSize#"
										borderColor  = "#vBtnBorderColor#"
										borderColorInit = "#vBtnBorderColor#"
										image        = "#vBtnProcessImg#"
										imageHeight  = "#vBtnImgHeight#"
										borderRadius = "0px"	
										imagepos     = "right"
										height       = "#attributes.ButtonHeight#"
										width        = "#Attributes.ButtonWidth#"
										onclick      = "javascript:calculate('1')">
									
							 	</td>
									
							<cfelse>
														 
								<cf_tl id="#Attributes.ProcessName#" var="1">
								
								<td style="padding:1px 1px 1px 1px">
														
																
								  <cf_button2 id = "Process"
									text         = "#lt_text#" 
									type         = "submit"
									imagepos     = "right"
									bgcolor      = "#vBtnColor#"
									textColor    = "#vBtnTextColor#"
									textSize     = "#vBtnTextSize#"
									borderColor  = "#vBtnBorderColor#"
									borderColorInit = "#vBtnBorderColor#"
									image        = "#vBtnProcessImg#"
									imageHeight  = "#vBtnImgHeight#"
									borderRadius = "0px"	
									height       = "#attributes.ButtonHeight#"
									width        = "#Attributes.ButtonWidth#">
									
								</td>
							 						 
							</cfif>
					 		
						<cfelseif Attributes.NextEnable eq "1">	
						
							<cfif Attributes.SaveSubmit eq "1">
														
								<cf_tl id="Save" var="1">
								
								<td style="padding:1px 1px 1px 1px">
							 	
									<cf_button2 
									    id              = "Current" 
										text            = "#lt_text#" 
										bgcolor         = "#vBtnColor#"
										textColor       = "#vBtnTextColor#"
										textSize        = "#vBtnTextSize#"
										borderColor     = "#vBtnBorderColor#"
										borderColorInit = "#vBtnBorderColor#"										
										borderRadius    = "0px"
										imagepos        = "right"
										width           = "#Attributes.ButtonWidth#"
										height          = "#attributes.ButtonHeight#"										
										type            = "submit">
										
										<!--- onclick      = "return #Attributes.Nextscript# ; parent.Prosis.busy('yes');" --->
									
							 	</td>
							
							
							</cfif>
												
							<cfif Attributes.NextSubmit eq "1">																		
															
								<cf_tl id="#Attributes.NextName#" var="1">
								
								<td style="padding:1px 1px 1px 1px">
																																
								    <cf_button2 id="Next" 
										text         = "#lt_text#" 
										bgcolor      = "#vBtnColor#"
										textColor    = "#vBtnTextColor#"
										textSize     = "#vBtnTextSize#"
										borderColor  = "#vBtnBorderColor#"
										borderColorInit = "#vBtnBorderColor#"
										image        = "#vBtnNextImg#"
										imageHeight  = "#vBtnImgHeight#"
										borderRadius = "0px"
										imagepos     = "right"
										width        = "#Attributes.ButtonWidth#"
										height       = "#attributes.ButtonHeight#"
										onclick      = "return #Attributes.Nextscript# ; parent.Prosis.busy('yes');"
										type         = "submit">
									
								</td>											
															  
							 <cf_tl id="#Attributes.NextLastName#" var="1">	  
								
							  <td style="padding:1px 1px 1px 1px">
							  							 																						    
									<cf_button2 id   = "NextLast" 
										text         = "#lt_text#" 
										bgcolor      = "#vBtnColor#"
										textColor    = "#vBtnTextColor#"
										textSize     = "#vBtnTextSize#"
										borderColor  = "#vBtnBorderColor#"
										borderColorInit = "#vBtnBorderColor#"
										image        = "#vBtnLastImg#"
										imageHeight  = "#vBtnImgHeight#"
										borderRadius = "0px"	
										imagepos     = "right"
										width        = "#Attributes.ButtonWidth#"
										height       = "#attributes.ButtonHeight#"
										onclick      = "parent.Prosis.busy('yes'); return #Attributes.Nextscript#"
										type         = "submit">
									
								</td>		
																					  
							<cfelseif Attributes.NextMode eq "1">		
							
							
														  
							   <cf_tl id="#Attributes.NextName#" var="1">
							  
								  <td style="padding:1px 1px 1px 1px">		
							  
							  		<cfif Attributes.Nextscript eq "" or findNoCase("(",Attributes.Nextscript)>
									
									<cfset vNextScript = trim(Attributes.Nextscript)>
									
									<cfif vNextScript eq "">
										<cfset vNextScript = "true">
									</cfif>

									<cf_button2 id      = "Next"
								    	text            = "#lt_text#"
										bgcolor         = "#vBtnColor#"
										textColor       = "#vBtnTextColor#"
										textSize        = "#vBtnTextSize#"
										borderColor     = "#vBtnBorderColor#"
										borderColorInit = "#vBtnBorderColor#"
										image           = "#vBtnNextImg#"
										imageHeight     = "#vBtnImgHeight#"
										borderRadius    = "0px"
										imagepos        = "right"
										width           = "#Attributes.ButtonWidth#"
										height          = "#attributes.ButtonHeight#"
										onclick         = "if (#vNextscript#) { nextstep('#url.mission#','#url.owner#','#url.code#','#Alias#','#tablename#','#object#','#objectid#','#Attributes.Id#','#Event#','#Current.ListingOrder#','next','#Attributes.TriggerGroup#'); }">
																	
									<cfelse>	
																		
									<cf_button2 id      = "Next"
								    	text            = "#lt_text#"
										bgcolor         = "#vBtnColor#"
										textColor       = "#vBtnTextColor#"
										textSize        = "#vBtnTextSize#"
										borderColor     = "#vBtnBorderColor#"
										borderColorInit = "#vBtnBorderColor#"
										image           = "#vBtnNextImg#"
										imageHeight     = "#vBtnImgHeight#"
										borderRadius    = "0px"
										imagepos        = "right"
										width           = "#Attributes.ButtonWidth#"
										height          = "#attributes.ButtonHeight#"
										onclick         = "doNext('#Attributes.Nextscript#','#url.mission#','#url.owner#','#url.code#','#Alias#','#tablename#','#object#','#objectid#','#Attributes.Id#','#Event#','#Current.ListingOrder#','next','#Attributes.TriggerGroup#')">
										
									</cfif>								
																
							  </td>								  
							  																					  
							<cfelse>
														
								<cf_tl id="#Attributes.NextName#" var="1">
								
								<td style="padding:1px 1px 1px 1px">
																															    
									<cf_button2 id   ="Next"
										text         = "#lt_text#" 
										bgcolor      = "#vBtnColor#"
										textColor    = "#vBtnTextColor#"
										textSize     = "#vBtnTextSize#"
										borderColor  = "#vBtnBorderColor#"
										borderColorInit = "#vBtnBorderColor#"
										image        = "#vBtnNextImg#"
										imageHeight  = "#vBtnImgHeight#"
										borderRadius = "0px"
										imagepos     = "right"
										width        = "#Attributes.ButtonWidth#"
										height       = "#attributes.ButtonHeight#"
										onclick      = "message()">
									
									
								</td>
								
								<cf_tl id="NavigationStop" var="qStop">
								
								<cfoutput>
								<script language="JavaScript">
								
								  function message() {
									  alert("#qStop#.")
								  }	
								
								</script>
								</cfoutput>
						 
							</cfif>	 
							 
						</cfif>
						
						<cfif Attributes.Table eq "Yes">
						
				 	  </td>
				  </tr>
				  </table>
				  
				  </cfif>				 
						  
			  <cfelse>
			 			  			  	
				<cfif attributes.section is "last">
				   <cfset sc = last>	 
				<cfelse>
				  <cfset sc = Attributes.Section>	 
				</cfif>
				
				<cfif ParameterExists(Form.NextLast)> 				
					<cfset moveto = "nextlast">		
				<cfelseif ParameterExists(Form.Current)> 				
					<cfset moveto = "current">							
				<cfelse>
					<cfset moveto = "next">					
				</cfif>
																	
			    <script language="JavaScript">
					{						    
			    	     parent.left.location = "#SESSION.root#/Tools/Process/Navigation/NavigationLeftMenu.cfm?mission=#url.mission#&owner=#url.owner#&alias=#alias#&tablename=#tablename#&object=#object#&objectid=#objectid#&id=#Attributes.ID#&section=#sc#&group=#Attributes.TriggerGroup#&iconWidth=#attributes.iconwidth#&iconheight=#attributes.iconheight#" 
						 nextstep('#url.mission#','#url.owner#','#URL.Code#','#Alias#','#tablename#','#object#','#objectid#','#Attributes.Id#','#Event#','#Current.ListingOrder#','#moveto#','#Attributes.TriggerGroup#')
					}
				</script>					
			  					  	    
			  </cfif>
		  
		  </cfif>
		  
		  </cfoutput>
		  		  
</cfif>		

<cfif attributes.section is "last">
	   <cfset sc = last>	 
<cfelse>
	  <cfset sc = Attributes.Section>	 
</cfif>

<cfoutput>
	
	<cfif attributes.reload eq "1">
	
	 	<script>  	     	
		     parent.left.location = "#SESSION.root#/Tools/Process/Navigation/NavigationLeftMenu.cfm?mission=#url.mission#&owner=#url.owner#&alias=#alias#&tablename=#tablename#&object=#object#&objectid=#objectid#&id=#Attributes.ID#&section=#sc#&group=#Attributes.TriggerGroup#&iconWidth=#attributes.iconwidth#&iconheight=#attributes.iconheight#"		 
		</script>
	
	<cfelse>  	
				
			<script>	
																			   
				url = "#SESSION.root#/tools/process/navigation/NavigationLeftMenuNode.cfm?"+
							"ts="+(Math.floor(Math.random()*20)+1)+
							"&alias=#alias#"+
							"&owner=#url.owner#"+
							"&mission=#url.mission#"+
							"&group=#Attributes.TriggerGroup#"+
						    "&object=#object#"+
							"&objectid=#objectid#"+
							"&id=#attributes.id#"+
							"&section=#sc#"+
							"&process=1";
				
				_cf_loadingtexthtml='';		
				if (parent.left.document.getElementById('#sc#')) {
					parent.left.ptoken.navigate(url,'#sc#')			
				} else {				  
	  		       parent.left.location = "#SESSION.root#/Tools/Process/Navigation/NavigationLeftMenu.cfm?mission=#url.mission#&owner=#url.owner#&alias=#alias#&tablename=#tablename#&object=#object#&objectid=#objectid#&id=#Attributes.ID#&section=#sc#&group=#Attributes.TriggerGroup#&iconWidth=#attributes.iconwidth#&iconheight=#attributes.iconheight#"		 	
				}
								 
		   </script>
		  
	  
	</cfif> 

</cfoutput>

<script>
  parent.Prosis.busy('no')
</script>

<table><tr><td height="4"></td></tr></table>
