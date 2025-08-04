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
<cfparam name="url.mode"       		default="edit">
<cfparam name="url.scheduleid" 		default="">
<cfparam name="url.workorderid" 	default="">
<cfparam name="url.workorderline" 	default="">

<cfif url.workorderid eq "" or url.workorderline eq "">

	<cfquery name  = "workschedule" 
	    datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">      				 
			SELECT   *
			FROM     WorkOrderLineSchedule
			WHERE    ScheduleId = '#url.ScheduleId#'
	</cfquery>
	
	<cfif workschedule.recordcount eq "0">
	
		<table><tr><td class="labelit" align="center">Schedule could not be located</td></tr></table>
		
		<cfabort>
		
	</cfif>
	
	<cfset url.workorderid   = workschedule.workorderid>
	<cfset url.workorderline = workschedule.workorderline>

</cfif>

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder W
		WHERE   WorkOrderId = '#url.workorderid#'		
</cfquery>

<cfquery name="customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Customer
		WHERE   CustomerId = '#workorder.CustomerId#'
</cfquery>

<cf_dialogPosition>

<cfajaximport tags="cfform,cfinput-datefield,cfwindow">

<cfif url.mode eq "edit">
	<cfif url.ScheduleId eq "">
		<cf_screentop height="100%" line="no" jQuery="Yes" user="no" scroll="Yes" html="Yes" layout="webapp" label="Add Schedule" banner="gray">
	<cfelse>
		<cf_screentop height="100%" line="no" jQuery="Yes" user="no" scroll="Yes" html="Yes" layout="webapp" label="Maintain Activity schedule for #customer.customername#" banner="gray">
	</cfif>
</cfif>
	
<cfif url.mode eq "copy">
	<cf_screentop height="100%" line="no" jQuery="Yes" user="no" scroll="Yes" html="Yes" layout="webapp" label="Copy Schedule" banner="yellow" bannerforce="yes">
</cfif>
	
<cfif url.mode eq "readonly">
	<cf_screentop height="100%" line="no" jQuery="Yes" user="no" scroll="Yes" html="Yes" layout="webapp" label="Schedule" banner="yellow">
</cfif>
	
<cf_dialogStaffing>
<cf_calendarScript>
<cf_CalendarViewScript>
	
<cf_tl id="Saving..." var="vSaving">
<cf_tl id="Please select an expiration date" var="vErrorDate">
<cf_tl id="This action will remove all your selections.  Do you want to continue ?" var="vSelectAnyTimeMessage">
	
	<cfoutput>
				
		<script>
			function selectSchedule(sche, interval, id, color) {
				var vCheck = 0;
				var pid = id.replace(/\./gi, '_');

				$('##memo_'+interval+'_'+pid).val('');
				if($('##val_'+interval+'_'+pid).is(':checked')) {
					vCheck = 1;
					$('##td_'+interval+'_'+pid).css('background-color', color);
					$('##memo_'+interval+'_'+pid).css('display', 'block');
				}else{
					vCheck = 0;
					$('##td_'+interval+'_'+pid).css('background-color','');
					$('##memo_'+interval+'_'+pid).css('display', 'none');
				}
				ColdFusion.navigate('ScheduleDetailSubmit.cfm?scheduleId='+sche+'&intervalDomain='+interval+'&intervalValue='+id+'&fieldValue='+vCheck+'&field=Operational','process_'+interval+'_'+pid);
				ColdFusion.navigate('ScheduleDetailSubmit.cfm?scheduleId='+sche+'&intervalDomain='+interval+'&intervalValue='+id+'&fieldValue=&field=Memo','process_'+interval+'_'+pid);
			}
			
			function saveMemo(sche, interval, id) {
				var pid = id.replace(/\./gi, '_');				
				if($('##val_'+interval+'_'+pid).is(':checked')) {
					ColdFusion.navigate('ScheduleDetailSubmit.cfm?scheduleId='+sche+'&intervalDomain='+interval+'&intervalValue='+id+'&fieldValue='+$('##memo_'+interval+'_'+pid).val()+'&field=Memo','process_'+interval+'_'+pid);
				}
			}
			
			function toggleIntervalDomain(domain) {
				if($('##divDetail_'+domain).is(':visible')) {
					$('##divDetail_'+domain).hide(150);
					$('##twistieDetail_'+domain).attr('src','#SESSION.root#/Images/arrow.gif');
				}else{
					$('##divDetail_'+domain).show(150);
					$('##twistieDetail_'+domain).attr('src','#SESSION.root#/Images/arrowdown.gif');
				}
			}
			
			function submitDateInterval(ScheduleId) {
				var vdate = $('##specificDate_date').val();
				var vmemo = $('##memo_date').val();
				ColdFusion.navigate('ScheduleSpecificDateSubmit.cfm?ScheduleId='+ScheduleId+'&date='+vdate+'&memo='+vmemo+'&value=&action=insert','divSpecificDate');
			}
			
			function deleteDateInterval(ScheduleId,val) {
				ColdFusion.navigate('ScheduleSpecificDateSubmit.cfm?ScheduleId='+ScheduleId+'&value='+val+'&action=delete','divSpecificDate');
			}
			
			function insertschedule() {
			    Prosis.busy('yes')
		  		ColdFusion.navigate('ScheduleEditSubmit.cfm?workorderId=#url.workorderId#&workorderline=#url.workorderline#&scheduleId=#url.scheduleId#','process','','','POST','scheduleform');	
			}			
			
			function saveschedule(ScheduleId,date,action,mode) {
				ColdFusion.navigate('ScheduleDateDetailSubmit.cfm?action='+action+'&selecteddate='+date+'&ScheduleId='+ScheduleId+'&mode='+mode,'calendartarget','','','POST','scheduleform');
			}
			
			function copyschedule(ScheduleId,selecteddate,mode) {
				var vEffective    = encodeURIComponent($('##ScheduleEffective').val());
				var vWorkSchedule = encodeURIComponent($('##WorkSchedule').val());
				var vActionClass  = encodeURIComponent($('##ActionClass').val());
				var vMemo         = encodeURIComponent($('##Memo').val());
				var vStatus       = encodeURIComponent($('##ActionStatus').val());				
				ColdFusion.navigate('ScheduleDateDetailSubmitCopy.cfm?selecteddate='+selecteddate+'&ScheduleId='+ScheduleId+'&mode='+mode+'&effective='+vEffective+'&workSchedule='+vWorkSchedule+'&actionClass='+vActionClass+'&memo='+vMemo+'&actionstatus='+vStatus,'calendartarget','','','POST','scheduleform');
			}
			
			function saveinheritedschedule(ScheduleId,date,everyNSelector,eNd,eNm,eNy,d1,d2,d3,d4,d5,d6,d7,m1,m2,m3,upToDate,mode) {
				if (upToDate != '') {
					$('##tdSaveAndInherit').html("<div align='center'><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/><br>#vSaving#</div>");
					ColdFusion.navigate('#session.root#/workorder/application/workorder/serviceDetails/schedule/ScheduleInheritSubmit.cfm?selecteddate='+date+'&ScheduleId='+ScheduleId+'&everyNSelector='+everyNSelector+'&everyNDays='+eNd+'&everyNMonths='+eNm+'&everyNYears='+eNy+'&day_1='+d1+'&day_2='+d2+'&day_3='+d3+'&day_4='+d4+'&day_5='+d5+'&day_6='+d6+'&day_7='+d7+'&mth_1='+m1+'&mth_2='+m2+'&mth_3='+m3+'&upToDate='+upToDate+'&mode='+mode,'calendartarget','','','POST','scheduleform');
				}else{
					alert('#vErrorDate#');
				}
			}
						
			function inheritschedule(scheduleId,date) {
				var vlink = '#session.root#/workorder/application/workorder/serviceDetails/schedule/ScheduleInherit.cfm?selecteddate='+date+'&scheduleId='+scheduleId;
				try {
					ColdFusion.Window.destroy('inheritWOSchedule');
				}catch(e){}
				
				ColdFusion.Window.create('inheritWOSchedule', 'Inherit Schedule', vlink, {height:400,width:500,modal:true,closable:true,center:true,minheight:200,minwidth:200 });
			}
			
			function toggleSection(section) {
				$('##'+section).toggle(150, function() {
					if ($('##'+section).is(':visible')) {
						$('##toggler'+section).attr('src' ,'#SESSION.root#/Images/arrowdown3.gif');
					}else{
						$('##toggler'+section).attr('src' ,'#SESSION.root#/Images/arrowright.gif');
					}
				});
			}
			
			function selectAnyTime(control) {
				if (control.checked) {
					if (confirm('#vSelectAnyTimeMessage#')) {
						$('.clsHour').attr('checked', false).attr('disabled','disabled');
						$('.clsHourMemo').attr('disabled','disabled');
					}else {
						control.checked = false;
					}
				}else{
					$('.clsHour').removeAttr('disabled');
					$('.clsHourMemo').removeAttr('disabled');
				}
			}
			
		</script>
</cfoutput>
		
<cf_divscroll id="editForm" style="height:100%">	
	<cfinclude template="ScheduleEditContent.cfm">
</cf_divscroll>
