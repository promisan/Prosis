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
<cf_tl id="Saving..." var="vSaving">
<cf_tl id="Please select an expiration date" var="vErrorDate">

<cfoutput>

	<script>
		function saveschedule(schedule,date,action,mis,man) {
			_cf_loadingtexthtml="";		
			ColdFusion.navigate('#session.root#/staffing/application/workschedule/planning/PlanningDateDetailSubmit.cfm?action='+action+'&selecteddate='+date+'&workschedule='+schedule+'&mission='+mis+'&mandate='+man,'calendartarget','','','POST','scheduleform')
			_cf_loadingtexthtml="<div align='center'><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";
		}
		
		function saveinheritedschedule(schedule,date,action,mis,man,eNd,d1,d2,d3,d4,d5,d6,d7,upToDate) {
			if (upToDate != '') {
				$('##tdSaveAndInherit').html("<div align='center'><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/><br>#vSaving#</div>");
				_cf_loadingtexthtml="";		
				ColdFusion.navigate('#session.root#/staffing/application/workschedule/planning/PlanningDateDetailSubmit.cfm?action='+action+'&selecteddate='+date+'&workschedule='+schedule+'&mission='+mis+'&mandate='+man+'&everyNDays='+eNd+'&day_1='+d1+'&day_2='+d2+'&day_3='+d3+'&day_4='+d4+'&day_5='+d5+'&day_6='+d6+'&day_7='+d7+'&upToDate='+upToDate,'calendartarget','','','POST','scheduleform')
				_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";
			}else{
				alert('#vErrorDate#');
			}
		}
		
		function inheritschedule(schedule,date,action,mis,man) {
			var vlink = '#session.root#/staffing/application/workschedule/planning/PlanningDateCopy.cfm?action='+action+'&selecteddate='+date+'&workschedule='+schedule+'&mission='+mis+'&mandate='+man;
			try {
				ColdFusion.Window.destroy('inheritSchedule');
			}catch(e){}
			ColdFusion.Window.create('inheritSchedule', 'Inherit Schedule', vlink, {height:400,width:500,modal:true,closable:true,center:true,minheight:200,minwidth:200 });
		}
		
		function checkAllScheduleChildren(hier) {
			if ($('##parentUnit_'+hier).is(':checked')) {
				$('input[class^="cls' + hier + '"]').each(function() {
					$(this).attr('checked',true);
				});
			}else{
				$('input[class^="cls' + hier + '"]').each(function() {
					$(this).attr('checked',false);
				});
			}
		}
		
		function editWorkSchedule(mis,man,ws) {		
			ColdFusion.Window.create('scheduledialog', 'Workschedule', '',{x:100,y:100,height:400,width:600,modal:true,resizable:false,center:true})    
			ColdFusion.Window.show('scheduledialog') 					
			ColdFusion.navigate(root + '/staffing/application/workschedule/Planning/WorkScheduleEdit.cfm?mission=' + mis +'&mandate='+man + '&workSchedule=' + ws,'scheduledialog') 		
		}
		
		function editWorkScheduleRefresh(mis,man) {
		    _cf_loadingtexthtml='';
		    ColdFusion.navigate('#SESSION.root#/staffing/application/workschedule/WorkScheduleListing.cfm?mission='+mis+'&mandate='+man,'contentbox5');
		}
		
		function showPositionDetail(code) {
			$('##trPositionDetail_'+code).toggle();
		}
		
		function toggleCopyDetail(control) {
			if (control.checked) {
				$('##tr_CopyDetail').show();
			}else{
				$('##tr_CopyDetail').hide();
			}
		}
		
		function togglePositionSection(delay) {
			var cnt =0;
			$('input:checkbox.clsHours').each(function () {
				cnt = cnt + (this.checked ? 1 : 0);
 			});
			
			if (cnt == 0) {
				$('##positionContainer').hide(delay);
			}else{
				$('##positionContainer').show(delay);
			}
		}
		
		function selectAllHours(control,delay) {
			if (control.checked) {
				$('input:checkbox.clsHours').each(function () {
					this.checked = true;
 				});
			}else{
				$('input:checkbox.clsHours').each(function () {
					this.checked = false;
 				});
			}
			
			togglePositionSection(delay);
		}
	</script>

</cfoutput>