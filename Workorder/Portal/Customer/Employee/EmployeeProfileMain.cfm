<!--
    Copyright © 2025 Promisan B.V.

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
<cf_screentop html="no" height="100%" scroll="no" Jquery="yes" busy="busy10.gif">

<cf_layoutScript>
<cf_monthPickerScript>
<cf_calendarViewScript>
<cf_presentationScript>

<cfoutput>

<cfsavecontent variable="script">

	<script language="JavaScript">
	
		function selectPerson(customerid,workschedule,personno,selectedYear,selectedMonth) {
			//reset all
			$('.clsPersonContainer').css('background-color','');
			$('.clsPersonContainer').css('border','1px solid ##ffffff');
			
			//select person
			$('##personContainer_'+workschedule+'_'+personno).css('background-color','##FADE9C');
			$('##personContainer_'+workschedule+'_'+personno).css('border','1px solid black');
			
			ColdFusion.navigate('EmployeeProfileView.cfm?personNo='+personno+'&customerid='+customerid+'&workschedule='+workschedule+'&selectedYear='+selectedYear+'&selectedMonth='+selectedMonth,'divProfile');
		}
		
		function selectActivity(scheduleid,selectedDate,person,positionno) {
			//reset all
			$('.clsActivityContainer').css('background-color','');
			$('.clsActivityContainer').css('border','1px solid ##ffffff');
			
			//select person
			$('##activityContainer_'+scheduleid).css('background-color','##FADE9C');
			$('##activityContainer_'+scheduleid).css('border','1px solid black');
			ColdFusion.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Schedule/ScheduleDateView.cfm?scope=portal&positionno='+positionno+'&personno='+person+'&showTarget=0&showJump=0&showToday=1&showPrevious=1&scheduleId='+scheduleid+'&selectedDate='+selectedDate,'divPersonViewCalendar');
		}
		
		function toggleWorkSchedule(workschedule) {
			if($('.workScheduleContainer_'+workschedule).is(':visible')) {
				$('.workScheduleContainer_'+workschedule).css('display', 'none');
			}else{
				$('.workScheduleContainer_'+workschedule).css('display', 'table-row');
			}
			$('##filtersearchsearch').val('');
		}
		
		function toggleHeader(slideType,delay) {
			if ($('##profileHeaderPhoto').is(':visible')) {
				$('##profileHeaderPhoto').animate({opacity:0.05, slideType:'hide'}, delay);
				$('##profileHeaderDetail').animate({opacity:0.05, slideType:'hide'}, delay);
			}else{
				$('##profileHeaderPhoto').animate({slideType:'show', opacity: 1}, delay);
				$('##profileHeaderDetail').animate({slideType:'show', opacity: 1}, delay);
			}
		}
		
		function selectEmployeeCriteria() {
		    Prosis.busy('yes')
			_cf_loadingtexthtml='';	
			ColdFusion.navigate('EmployeeProfileGeneralDetail.cfm?customerid='+$('##customer').val()+'&selectedYear='+$('##monthPicker_year').val()+'&selectedMonth='+$('##monthPicker_month').val(),'divEmployeeList');
			ColdFusion.navigate('#session.root#/Tools/TreeView/TreeViewInit.cfm','divProfile');
		}
		
		function initMonthPicker() {
			__initMonthPicker('monthPicker','#year(now())#','selectEmployeeCriteria();');
		}
		
		function getActivityProcedures(id){
			alert('procedures for ' + id);
		}
		
		function customOnLoad(){
			if ($('##leftEmployeeMenu').length == 0) {
				_pLayout_EmployeeProfileLayout_initBorderLayout_EmployeeProfileLayout_leftEmployeeMenu();
				_pLayout_EmployeeProfileLayout_initBorderLayout_EmployeeProfileLayout_divProfile();
			}	
			initMonthPicker();
			fillDivEmployeeListOnLoad();
		}
		
		
		function fillDivEmployeeListOnLoad(){			
			if ($('##divEmployeeList').length) {
				ColdFusion.navigate('EmployeeProfileGeneralDetail.cfm?customerid=' + $('##customer').val() + '&selectedYear=' + $('##default_year').val() + '&selectedMonth=' + $('##default_month').val(), 'divEmployeeList');
			}			
		}
				
		
	</script>
</cfsavecontent>

<cfhtmlhead text="#script#">
	
</cfoutput>

<!--- check if the user has potential access --->

<cf_layout id="EmployeeProfileLayout" type="Border">

	<cf_layoutarea id="leftEmployeeMenu" size="25%" maxsize="28%" position="left" collapsible="true">
		<cfinclude template="EmployeeProfileGeneral.cfm"> 
	</cf_layoutarea>
	
	<cf_layoutarea id="divProfile" position="center" size="75%" minsize="72%" overflow="auto">
		
	</cf_layoutArea>

</cf_layout>

<cfset AjaxOnLoad("customOnLoad")>
