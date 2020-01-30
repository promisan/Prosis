
<cfoutput>
<script>

function _getParameters() {
		var vAsOf = "";
		var vWeeks = "";
		var vEffective = "";
		var vMax = "";
		var vMaxTo = "";

		if ($('##copyAsOfDate').length == 1) { 
			vAsOf = $('##copyAsOfDate').val(); 
		} else { 
			if ($('##copyEffectiveDateTo').length == 1) { 
				vAsOf = $('##copyEffectiveDateTo').val(); 
			} else {
				vAsOf = '#dateformat(now(), client.DateFormatShow)#';
			}
		}
		if ($('##copyWeeks').length == 1) { vWeeks = $('##copyWeeks').val(); }
		if ($('##copyEffectiveDate').length == 1) { vEffective = $('##copyEffectiveDate').val(); }
		if ($('##copyMaxDate').length == 1) { vMax = $('##copyMaxDate').val(); }
		if ($('##copyMaxDateTo').length == 1) { vMaxTo = $('##copyMaxDateTo').val(); }

		return 'asof='+vAsOf+'&weeks='+vWeeks+'&effective='+vEffective+'&max='+vMax+'&maxTo='+vMaxTo;
	}

	function _getDateValueString(val) {
		var vVal = val.dd.toString() + '/' + val.mm.toString() + '/' + val.yyyy.toString();
		if ('#APPLICATION.DateFormat#' == 'US') {
			vVal = val.mm.toString() + '/' + val.dd.toString() + '/' + val.yyyy.toString();
		}
		return vVal;
	}

	function scheduleCopy(personNo,pType) {
		parent.collapseArea('mybox', 'treebox');
		expandArea('mybox', 'properties');		
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleCopy.cfm?orgunit=#url.id0#&personno='+personNo+'&type='+pType+'&'+_getParameters(), 'properties');
	}

	function doScheduleCopy() {
		Prosis.busy('yes');
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleCopySubmit.cfm?'+_getParameters(), 'targetDoCopy');
	}

	function _doScheduleChange(pAsOf) {
		var vWeeks = $('##copyWeeks').val();
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleCopyDetail.cfm?orgunit=#url.id0#&asof='+pAsOf+'&weeks='+vWeeks, 'divScheduleCopyDetail');
	}

	function doScheduleChangeDate(val){
		_doScheduleChange(_getDateValueString(val));
	}

	function doScheduleToChangeDate(val){
		var vAsOf = _getDateValueString(val);
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleCopyDetail.cfm?orgunit=#url.id0#&asof='+vAsOf+'&maxTo='+vAsOf, 'divScheduleCopyDetail');
	}

	function doScheduleChange(){
		var vAsOf = $('##copyAsOfDate').val();
		_doScheduleChange(vAsOf);
	}

	function doCopyPersonTableRemove(personNo, pType){
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleCopyPersonPurge.cfm?orgunit=#url.id0#&personno='+personNo+'&type='+pType+'&'+_getParameters(), 'properties');
	}

	function highlightTimesheePerson(personno, pColor) {
		$('.clsTimeSheetPerson_'+personno).css('background-color', pColor);
	}

	function scheduleRemove(personNo) {
		var vEffective = "";
		var vExpiration = "";

		if ($('##removeEffectiveDate').length == 1) { vEffective = $('##removeEffectiveDate').val(); }
		if ($('##removeExpirationDate').length == 1) { vExpiration = $('##removeExpirationDate').val(); }

		parent.collapseArea('mybox', 'treebox');
		expandArea('mybox', 'properties');
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleRemove.cfm?orgunit=#url.id0#&personno='+personNo+'&removeEffectiveDate='+vEffective+'&removeExpirationDate='+vExpiration, 'properties');
	}

	function doRemovePersonTableRemove(personNo){
		var vEffective = $('##removeEffectiveDate').val();
		var vExpiration = $('##removeExpirationDate').val();
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleRemovePersonPurge.cfm?orgunit=#url.id0#&personno='+personNo+'&removeEffectiveDate='+vEffective+'&removeExpirationDate='+vExpiration, 'properties');
	}

	function doScheduleRemoveChangeDate(val) {
		var vAsOf = _getDateValueString(val);
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleRemove.cfm?orgunit=#url.id0#&removeEffectiveDate='+vAsOf, 'properties');
	}

	function doScheduleRemove() {
		var vEffective = $('##removeEffectiveDate').val();
		var vExpiration = $('##removeExpirationDate').val();

		Prosis.busy('yes');
		ptoken.navigate('#session.root#/Attendance/Application/TimeView/Propagate/ScheduleRemoveSubmit.cfm?orgunit=#url.id0#&removeEffectiveDate='+vEffective+'&removeExpirationDate='+vExpiration, 'targetDoRemove');
	}
	
</script>	
</cfoutput>