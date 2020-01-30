
<cfparam name="url.mission" default="Promisan">
<cfparam name="url.date" default="#dateformat(now(),client.dateformatshow)#">

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>

<cf_screentop 
	title="#url.mission# Activity Manager" 
	height="100%" 
	jQuery="Yes"	
	scroll="No" 
	html="No">
   
<cf_layoutscript>
<cf_CalendarViewScript>
<cf_menuscript>
<cf_DialogOrganization>
<cfajaximport tags="cfmap,cfdiv,cfwindow" params="#{googlemapkey='#client.googleMAPId#'}#">	 

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
			
			<cf_layoutarea 
			   	position  = "header"		
				style     = "height:80"		
			   	name      = "plntop">	
				
				<table cellspacing="0" height="62" width="100%" align="center" cellpadding="0">
								
					<tr><td height="40" valign="top">
				
						<cf_tl id="Medical Manager" var="1">				
						<cf_ViewTopMenu label="#url.mission# #lt_text#" background="gray">
				
					</td>
					</tr>
			
				</table>
							 			  
			</cf_layoutarea>		
			  
			<cf_layoutarea 
			    position    = "left" 
				name        = "treebox" 
				maxsize     = "20%" 		
				size        = "230" 
				minsize     = "230"
				collapsible = "true" 
				splitter    = "true"
				overflow    = "auto">			
							
				<table width="100%" height="100%" class="formpadding">				
								   
				    <tr><td valign="top" class="labellarge" style="padding:10px">
					
					1. Ability to select a Client (Family, Child) or OCYF110 No -> Show calendar activities in the center 	
							and grouped by responsible office				

					<br><br><br>
					
					2. Ability to select a AIDE -> Show the summary of the activities in the center (covering the time period involved). Also color color code possible overlap.
					
					<br><br><br>
					
				    3.    review <u>unscheduled</u> requests to assign them to a CA, but visually checking the impact and days in which over lap would occur within the work-schedule defined for the CA
															
					</td></tr>			    
									
				</table>
				
			</cf_layoutarea>
			
			<cfparam name="url.orgunit" default="0">
			
			<cf_layoutarea position="center" name="main">
			
				<table width="100%" height="100%">
					<tr>
						<td style="height:100%;padding-left:8px;padding-top:7px;padding-bottom:9px;padding-right:10px" align="center" id="main">
												
						<cfparam name="client.selecteddate" default="#now()#">
			
							<cfif client.selecteddate lt (now()-300)>
							   <cfset client.selecteddate = now()>
							</cfif>	
							
							<cfparam name="url.selecteddate" default="#client.selecteddate#">									
															
							<cf_calendarView 
							   title          = "Staff Activity schedule"	
							   selecteddate   = "#url.selecteddate#"
							   showjump       = "0"
							   relativepath   =	"../../../"				
							   autorefresh    = "0"	
							   preparation    = ""	    				  
							   content        = ""		
							   targetid       = "calendartarget"	  
							   target         = "Application/WorkOrder/Actor/Activity.cfm"
							   condition      = ""		   
							   cellwidth      = "fit"
							   cellheight     = "fit">
						
						
						</td>
					</tr>
				</table>
				
			</cf_layoutarea>
			
			<cf_layoutarea position="right" 
				name        = "right" 
			    maxsize     = "22%" 		
				collapsible = "true" 
				splitter    = "true"
				size        = "330" 
				minsize     = "330">
			
				<table width="100%" height="100%">
					<tr>
						<td class="labelmedium" 
						    style="height:100%;padding-left:8px;padding-top:7px;padding-bottom:9px;padding-right:10px" 
							align="center" 
							id="calendartarget">
						
							Show the more detailed schedule of this date by hour and link to the detailed record						
						
						</td>
					</tr>
				</table>
				
			</cf_layoutarea>
								
	</cf_layout>