
<cfparam name="#url.mission" default="Bambino">
<cfparam name="url.date" default="#dateformat(now(),client.dateformatshow)#">

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>

<cf_screentop 
	title="#url.mission# Medical Services Manager" 
	height="100%" 
	jQuery="Yes"	
	banner="blue"
	bannerforce="Yes"	
	scroll="No" 
	html="No">
		
<cf_TextAreaScript>
<cf_PresentationScript>
<cf_layoutscript>
<cf_CalendarViewScript>
<cf_menuscript>
<cf_listingscript>
<cf_actionlistingscript>
<cf_DialogStaffing>
<cf_DialogOrganization>
<cf_SubmenuLeftScript>
<cf_dialogWorkOrder>


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

<cf_tl id="Do you want to reschedule" var="txt">

<cfajaximport tags="cfmap,cfdiv" params="#{googlemapkey='#client.googleMAPId#'}#">	 

<cfinclude template="../Notification/SMTP/SMTPScript.cfm">

<cfinclude template="WorkPlanViewMenu.cfm">

<cfoutput>
	
	<script>
		
		function openaction(wli) {		  
	        h = "#client.height-100#";	 
			// ptoken.open('#session.root#/Workorder/Application/Medical/ServiceDetails/WorkOrderline/WorkOrderLineView.cfm?drillid='+wli,'w'+wli,'left=20, top=20, width=1440,height='+h+',menubar=no, status=yes, toolbar=no, scrollbars=no, resizable=yes')
			ptoken.open('#session.root#/Workorder/Application/Medical/ServiceDetails/WorkOrderline/WorkOrderLineView.cfm?drillid='+wli,'w'+wli)	
		}
		
		function openschedule(wla) {
			workplan(wla,'dialog')
		}	
		
		function deleteaction(wla,dte,mis,org,pos,per,sze) {
		    if (confirm("#txt# ?")) {
		    	_cf_loadingtexthtml='';
				ptoken.navigate('#session.root#/Workorder/Application/Medical/ServiceDetails/WorkPlan/Agenda/deleteSchedule.cfm?size='+sze+'&workactionid='+wla+'&selecteddate='+dte+'&mission='+mis+'&orgunit='+org+'&positionno='+pos+'&personno='+per,'calendartarget')
			}
		}
		
		function notification(tpe) {			
			Prosis.busy('yes')
			ptoken.navigate('#CLIENT.root#/WorkOrder/Application/Medical/ServiceDetails/Notification/'+tpe+'/'+tpe+'Listing.cfm?mission=#URL.Mission#&date=#URL.date#','dNotification')
		}	
		
		function addworkplan(mission,org,personno,date) {				  
			w = screen.width-270
		    h = screen.height-200	 
			ptoken.open('#session.root#/WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Create/PatientListing.cfm?mission=' + mission + '&orgunit=' + org + '&personno=' + personno+ '&date=' + date,'contact')			
		}		

		function toggleCalendar(dte) {
		
			$('##calendartarget').html('')		    				
						
			if ($('##mybox_borderCENTER').is(':visible')) {
				$('##mybox_borderRIGHT').animate({'width':'100%'}, 500, function(){});
				$('##mybox_borderCENTER, ##mybox_borderTogglerRIGHT, ##mybox_borderTogglerLEFT').hide();						
				calendardetail(dte,'wide');								
			} else {
				$('##mybox_borderRIGHT').animate({'width':'33%'}, 500, function(){});
				$('##mybox_borderCENTER, ##mybox_borderTogglerRIGHT, ##mybox_borderTogglerLEFT').show();				
				calendardetail(dte,'small');
			}
		}

		function scrollToHour(hr, min) {
			$('##mainAgendaListing').animate({
        		scrollTop: $('.clsHour_'+hr+'_'+min).offset().top - 160
    		}, 500);
		}
		
		function toggleLog(id) {
			if ($('##log_'+id).is(':visible')) {
				$('##log_'+id).hide();
				$('##logContent_'+id).html('');
			} else {
				window['__logDetailShowFunction'] = function(){	$('##log_'+id).show(); };
				ptoken.navigate('#session.root#/workorder/application/medical/ServiceDetails/WorkPlan/Agenda/LogDetail.cfm?workactionid='+id, 'logContent_'+id, '__logDetailShowFunction');
			}
		}
				
	</script>
	
</cfoutput>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
			
			<cf_layoutarea 
			   	position  = "header"		
				style     = "height:80"		
			   	name      = "plntop">	
				
				<table cellspacing="0" height="50" width="100%" align="center" cellpadding="0">
								
					<tr><td valign="top">
				
						<cf_tl id="Medical Manager" var="1">				
						<cf_ViewTopMenu label="#url.mission# #lt_text#" background="gray">
				
					</td>
					</tr>
			
				</table>
							 			  
			</cf_layoutarea>		
			  
			<cf_layoutarea 
			    position    = "left" 
				name        = "treebox" 
				size        = "250"
				collapsible = "true">

				<cf_divScroll>
							
				<table width="98%">			
				
					<input type="hidden" id="menu" value="schedule">	
								   
				    <tr>					
						<td id="targetleft" class="labellarge" style="font-size:22px;padding-right:20px;padding-left:10px;padding-bottom:5px">
							<cfinclude template="Agenda/ActivitySelect.cfm">
						</td>					
					</tr>
					
					<cfif hasrecords neq "0">
					
					<tr>
	  
					  <td style="padding-top:3px">
	  
					    <cf_tl id="Other Actions" var="1">
					    <cfset tResources = "#Lt_text#">
		
						<cfoutput>
							<cfset heading   = "#tResources#">
							<cfset module    = "'WorkOrder'">
							<cfset selection = "'Medical'">
							<cfset open      =  "yes">
							<cfset menuclass = "'Schedule'">
							<cfinclude template="../../../../../Tools/SubmenuLeft.cfm">
						</cfoutput>
		
					  </td>
	  
					</tr>	 
					
					</cfif>								    
									
				</table>

				</cf_divScroll>
				
			</cf_layoutarea>
			
			<cfif hasrecords neq "0">
									
				<cf_layoutarea position="center" name="main">
				
				    <table width="100%" height="99%">						
						<tr id="schedulebox">
						<td style="height:99%;width:100%;">
						<cf_divScroll overflowx="auto" id="schedule">
						<cfinclude template="WorkPlanViewDetail.cfm">
						</cf_divScroll>
						</td></tr>					
						<tr id="listingbox" class="hide"><td style="height:100%;width:100%" id="listing" valign="top"></td></tr>						
					</table>					
																		
				</cf_layoutarea>
			
				<cf_layoutarea position="right" 
					name        = "right" 						
					splitter    = "true"
					collapsible = "true"
					size        = "33%" 
					minsize     = "350">				
					
					
	
					<table width="100%" height="98%">
						<tr>
							<td class="labelmedium" 
							    style="height:100%;padding-left:7px;padding-right:5px" align="center" valign="top" id="calendartarget">
								
								<cfset url.mode = "medical">
								<cfset url.selecteddate= "#dateformat(url.date,client.dateformatshow)#">
								<cfinclude template="Agenda/ActivityList.cfm">
								
							</td>
						</tr>
					</table>
					
									
				</cf_layoutarea>
				
			</cfif>	
								
	</cf_layout>