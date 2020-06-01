
<cfparam name="url.mode"    default="embed"> 
<cfparam name="url.orgunit" default="">       

<style>
  .acell{text-align:center;border-left:1px solid silver;padding-left:2px;padding-right:2px;font-size:13px;min-width:30}
  .bcell{border-left:1px solid silver;padding-left:2px;padding-right:2px;font-size:14px;min-width:40}
  .ccell{min-width:20px;padding-top:2px;padding-left:2px;}
  .dcell{width:100%;padding-left:6px;padding-right:4px;font-size:13px;}
  .ecell{font-size:12px;height:20px;}
  .fcell{font-size:12px;padding-top:2px;padding-left:4px;height:20px;min-width:12px;}
  .gcell{min-width:32px;font-size:12px;padding-top:2px;height:20px;}
  .hcell{font-size:15px;padding-left:11px;min-width:70px;}  
  .lcell{height:20px;padding-right:3px;width:100%;padding-left:2px;border-right:1px solid silver;}
  .atext{height:100%;background-color:ffffcf;border-top:0px;border-bottom:0px;width:100%;}
  .amemo{height:42px;font-size:20px;background-color:ffffcf;border:0px;border-left:1px solid silver;border-right:1px solid silver;}
  TR.line td{padding-top:0px !important; padding-bottom:0px !important;}
</style>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT   W.Mission,
		         WLA.WorkActionId,
		         WL.OrgUnitImplementer, 
				 WL.PersonNo, 
				 WLA.DateTimePlanning
		FROM     WorkOrderLineAction WLA INNER JOIN
                    WorkOrderLine WL ON WLA.WorkOrderLine = WL.WorkOrderLine AND WLA.WorkOrderId = WL.WorkOrderId INNER JOIN WorkOrder W ON W.WorkOrderId = WL.WorkOrderId
		WHERE    WLA.WorkActionId = '#url.workactionid#'
		ORDER BY WLA.Created DESC
</cfquery>	

<cfparam name="url.mission" default="#line.mission#"> 

<cfquery name="Schedule" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT   *
		FROM     WorkPlanDetail INNER JOIN
                 WorkPlan ON WorkPlanDetail.WorkPlanId = WorkPlan.WorkPlanId
       WHERE     WorkActionId = '#url.workactionid#'
       AND       Operational='1'
</cfquery>	

<cfif schedule.recordcount eq "0">

	<cfset url.personNo     = Line.PersonNo>
	
	<cfquery name="Schedule" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		SELECT   P.PositionNo
		FROM     PersonAssignment AS PA INNER JOIN
		         Position AS P ON PA.PositionNo = P.PositionNo
		WHERE    PA.PersonNo = '#url.personno#' 
		AND      PA.DateEffective < '#line.DateTimePlanning#' 
		AND      AssignmentStatus IN ('0','1')
		AND      P.OrgUnitOperational = '#url.orgunit#'
		ORDER BY PA.DateExpiration DESC
	</cfquery>	
	
	<cfset url.PositionNo   = schedule.PositionNo>
	<cfset client.selecteddate = dateformat(line.DateTimePlanning,client.dateformatshow)>
	<cfset url.selecteddate = client.selecteddate>
	
		
<cfelse>

	<cfset url.personno   = schedule.PersonNo>
	<cfset url.positionno = schedule.PositionNo>
	<cfset url.orgunit    = schedule.Orgunit>
		
	<cfset client.selecteddate = Schedule.DateTimePlanning>
			
	<cfif client.selecteddate lt (now()-300)>
	   <cfset client.selecteddate = now()>
	</cfif>	

	<cfset url.selecteddate = client.selecteddate>
	<cfset url.selecteddate = dateformat(url.selecteddate,client.dateformatshow)>
	
</cfif>	
		
<cf_screentop 
	title="#url.mission# Medical Services Manager" 
	height="100%" 
	jQuery="Yes"	
	scroll="No" 	
	html="No">	
	

	
<cfoutput>
	<script>
		
		function deleteaction(wla,dte,mis,org,pos,per,siz) {
		    _cf_loadingtexthtml='';
			ptoken.navigate('#session.root#/Workorder/Application/Medical/ServiceDetails/WorkPlan/Agenda/deleteSchedule.cfm?workactionid='+wla+'&selecteddate='+dte+'&mission='+mis+'&orgunit='+org+'&positionno='+pos+'&personno='+per+'&size='+siz,'calendartarget')
		}
		
		function addworkplan(mission,org,personno,date) {				  
			w = "#client.widthfull-100#";
		    h = "#client.height-100#";	 
			ptoken.open('#session.root#/WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Create/PatientListing.cfm?mission=' + mission + '&orgunit=' + org + '&personno=' + personno+ '&date=' + date,'_blank','left=20, top=20, width='+w+',height='+h+',menubar=no, status=yes, toolbar=no, scrollbars=no, resizable=yes')			
		}		
		
		function openaction(wli) {		  
	        h = "#client.height-100#";	 
			ptoken.open('#session.root#/Workorder/Application/Medical/ServiceDetails/WorkOrderline/WorkOrderLineView.cfm?drillid='+wli,'w'+wli,'left=20, top=20, width=1440,height='+h+',menubar=no, status=yes, toolbar=no, scrollbars=no, resizable=yes')
		}
		
		function toggleCalendar(dte) {
		   
		    
			if ($('##mybox_borderCENTER').is(':visible')) {
				$('##mybox_borderCENTER').hide();
				$('##mybox_borderRIGHT').width('100%');		
				Prosis.busy('Yes')		
				_cf_loadingtexthtml='';	
				calendardetail(dte,'wide')	
							
			} else {
				$('##mybox_borderCENTER').show();
				$('##mybox_borderRIGHT').width('400px');	
				Prosis.busy('Yes')					
				_cf_loadingtexthtml='';	
				calendardetail(dte,'small')				
			}
		}
			
			
	</script>
			
</cfoutput>

<cfajaximport tags="cfmap,cfdiv" params="#{googlemapkey='#client.googleMAPId#'}#">	 

<cf_layoutscript>
<cf_CalendarViewScript>
<cf_dialogWorkOrder>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
			
		<cfif url.mode eq "embed"> 
		
			<!--- new dialog --->
		
		<cfelse>
			
			<cf_layoutarea 
			   	position  = "header"		
				style     = "height:80"		
			   	name      = "plntop">	
										
				<table cellspacing="0" height="50" width="100%" align="center" cellpadding="0">								
					<tr><td valign="top">				
						<cf_tl id="Medical Manager" var="1">		
						
						<cfif url.mode eq "embed"> 		
							<cf_ViewTopMenu close="parent.ColdFusion.Window.destroy('myworkplan',true)" label="#url.mission# #lt_text#" background="gray">				
						<cfelse>
							<cf_ViewTopMenu label="#url.mission# #lt_text#" background="gray">	
						</cfif>	
					</td>
					</tr>			
				</table>
							 			  
			</cf_layoutarea>	
		
		</cfif>						
												
		<cfparam name="url.mission"    default="">		
		<cfparam name="url.orgunit"    default="#Line.OrgUnitImplementer#">
		<cfparam name="url.modality"   default="Medical">			
		
		<cf_layoutarea 
		    position    = "left" 
			name        = "treebox" 
			maxsize     = "20%" 		
			size        = "230" 
			minsize     = "230"
			collapsible = "true" 
			initcollapsed = "true"
			splitter    = "true"
			overflow    = "auto">		
						
			<cf_divscroll>					
					
				<table width="98%" class="formpadding">				
								   
				    <tr>					
						<td id="targetleft" class="labellarge" style="font-size:22px;padding-right:20px;padding:5px;">		
												
						<cfset url.orgunit = line.orgunitimplementer>	
																		
						<cfinclude template="../../Medical/ServiceDetails/WorkPlan/Agenda/ActivitySelect.cfm">
						
						</td>					
					</tr>										    
									
				</table>				
							
			</cf_divscroll>
			
		</cf_layoutarea>			
		
		<cf_layoutarea position="center" name="main">

			<cf_divscroll>
		
				<table width="100%" height="100%">
								 					
					<tr>
						<td style="height:100%;padding-left:20px;padding-top:7px;padding-bottom:20px;padding-right:10px" align="center" id="main">											
						
							<cfparam name="url.modality"     default="Medical">	
							
							<cfif url.modality eq "Medical">		
																						
								<cfset dateValue = "">
								<CF_DateConvert Value="#url.selecteddate#">
								<cfset DTS = dateValue>
																																																															    													
								<cf_calendarView 
								    title          = "Consult and Activity schedule"	
								    selecteddate   = "#DTS#"
								    showjump       = "0"
								    relativepath   = "../../.."				
								    autorefresh    = "0"	
								    preparation    = ""	    				  
								    content        = "WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Agenda/ActivitySummary.cfm"		
								    targetid       = "calendartarget"								   
								    target         = "WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Agenda/ActivityList.cfm"
								    condition      = "mission=#url.mission#&workactionid=#workactionid#"		   
								    conditionfly   = "orgunit=#url.orgunit#&positionno=#url.positionno#&personno=#url.personno#"
								    cellwidth      = "fit"
								    cellheight     = "fit">
														
						    </cfif>	
						</td>
					</tr>
				</table>

			</cf_divscroll>
			
		</cf_layoutarea>
			
		<cf_layoutarea position="right" 
			name        = "right" 		   	
			collapsible = "false" 
			splitter    = "true"
			size        = "520" 
			minsize     = "520">
		
		    <cf_divscroll>
			
				<table width="100%" height="100%">
				
					<tr>
										
						<td class="labelmedium" 
						    style="height:100%;padding-left:8px;padding-top:7px;padding-bottom:9px;padding-right:10px" 
							align="center" valign="top">
																		
							<cfif url.workactionid neq "">						
								<cf_securediv style="height:100%" id="calendartarget"
								bind="url:#session.root#/workorder/application/Medical/ServiceDetails/WorkPlan/Agenda/ActivityList.cfm?mode=medical&workactionid=#line.workactionid#&selecteddate=#dateformat(url.selecteddate,client.dateformatShow)#&mission=#url.mission#&orgunit=#line.orgunitimplementer#&positionno=#url.positionno#&personno=#url.personno#">																						
							</cfif>
							
						</td>
						
					</tr>
				</table>
			
			</cf_divscroll>
			
		</cf_layoutarea>
								
	</cf_layout>