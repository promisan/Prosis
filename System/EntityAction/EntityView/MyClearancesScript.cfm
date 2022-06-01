
<cfquery name="Module" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ModuleControl
		WHERE    SystemModule  = 'Procurement'
		AND      FunctionClass = 'Application'
		AND      FunctionName  = 'Requisition Management'
</cfquery>	

<cfoutput>

<script>
	
	function doRefresh(due,eg,miss,owner,me,mode) {	
		ptoken.navigate('#SESSION.root#/System/EntityAction/EntityView/MyClearancesDetail.cfm?scope=#url.scope#&refresh='+mode+'&EntityDue='+due+'&EntityGroup='+eg+'&Mission='+miss+'&Owner='+owner+'&me='+me,'listing');					
	}	
		
	function process(id) {
	   ptoken.open("#SESSION.root#/ActionView.cfm?id=" + id, id);	   
	}
	
	function entity() {
       ptoken.open("#SESSION.root#/system/entityaction/entityview/EntityView.cfm", "entity");
    }
					
	function procbatch(mis,per,role,template) {
		ptoken.open("#SESSION.root#/Procurement/Application/Requisition/Process/"+template+".cfm?role="+role+"&header=1&mission=" + mis + "&Period=" + per, role, "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");	
	}
	
	function procbuyer(mis,per,role) {	
		ptoken.open("#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionView.cfm?systemfunctionid=#Module.SystemFunctionId#&role=procbuyer&mission=" + mis + "&Period=" + per, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");																		
	}

	function doSummary() {
		ptoken.navigate('#SESSION.root#/System/EntityAction/EntityView/setSummary.cfm?mode=batch&overall='+document.getElementById('batchtotal').value, 'batch');	
	}

	function localShowPerson(e, p) {
		ShowPerson(p);
		e.stopPropagation();
	}

	function toggleGroup(ent, due, eg, miss, owner, me) {
		if ($('.clsRow_'+ent).first().is(':visible')) {
			$('.entityIcon_'+ent).removeClass('fa-minus').addClass('fa-plus');
			$('.clsHeader_'+ent).removeClass('boldText');
			$('.clsRow_'+ent).slideUp(100);
			$('##container_'+ent).html('');
			toggleTextSearch();
		} else {
			$('.entityIcon_'+ent).removeClass('fa-plus').addClass('fa-minus');
			$('.clsHeader_'+ent).addClass('boldText');
			$('.clsRow_'+ent).slideDown(100);
			window['fnTextSearch'] = toggleTextSearch;			
			ptoken.navigate('#SESSION.root#/System/EntityAction/EntityView/Actions.cfm?scope=#url.scope#&entityDue='+due+'&entityCode='+ent+'&EntityGroup='+eg+'&Mission='+miss+'&Owner='+owner+'&me='+me, 'container_'+ent, 'fnTextSearch');
		}
	}

	function toggleTextSearch() {
		if ($('.clsEntityDetail').length > 0) {
			$('.clsSearchContent').show(250);
		} else {
			$('.clsSearchContent').hide(250);
			$('##fltSearchTextbox').val('');
		}
	}

	function doTextSearch(val) {
		var vVal = $.trim(val).toLowerCase();
		if (vVal != '') {
			$('.clsEntityDetail').each(function() {
				if($(this).html().trim().toLowerCase().indexOf(vVal) >= 0){
					$(this).show();
				} else {
					$(this).hide();
				}
			});
		} else {
			$('.clsEntityDetail').show();
		}
	}

	function collapseAll() {
		$('.clsEntityContainer').hide().html('');
		$('.entityIcon').removeClass('fa-minus').addClass('fa-plus');
		$('.clsHeader').removeClass('boldText');
		toggleTextSearch();
	}
			
</script>	

</cfoutput>