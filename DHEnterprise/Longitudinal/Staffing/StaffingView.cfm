
<title>Workforce Statistics : eHub</title>

<cf_mobile appId="Hub" chartJS="yes" validateLogin="no" allowLogout="no" grid="yes">

	<script>
		
		function showDetail(title, subtitle, content) {
			var vTitle = title;
			if ($.trim(vTitle) == '') { vTitle = 'Detail'; }
			
			$('#modalDetail .modal-title').html(vTitle);
			$('#modalDetail .modal-subtitle').html(subtitle);
			$('#modalDetail .modal-body').html(content);
			$('#modalDetail').modal('show');
		}
		
		function showDrillDetail(title, subtitle, contentURL) {
			var vTitle = title;
			if ($.trim(vTitle) == '') { vTitle = 'Detail'; }
			
			ColdFusion.navigate(contentURL, 'modalBody');
			$('#modalDetail .modal-title').html(vTitle);
			$('#modalDetail .modal-subtitle').html(subtitle);
			$('#modalDetail').modal('show');
		}
	
		function clickElement(lbl, fld, division, source) {
			var vContextValue = encodeURIComponent(lbl);
			showDrillDetail('', '', 'DashboardDrill.cfm?mission='+$('#pMission').val()+'&date='+$('#pDate').val()+'&level='+$('#pLevel').val()+'&seconded='+$('#pSeconded').val()+'&context='+fld+'&contextvalue='+vContextValue+'&division='+division+'&source='+source);
		}

		var callBackDetails = function(){
 			var content = document.getElementById("rowDetail").innerHTML; 			
 			$('#modalDetail .modal-body').html(content);			
			$('#modalDetail').modal('show');
		} 

		function showdrilldown(template,source,mission,division,column,columname,field,categorydesc,pdate,category,seconded,level,condition,persongrade) {
			
			$('#modalDetail .modal-title').html(mission);
			
			var subtitle = '';
			
			if (division!='') {
				subtitle = subtitle+' Division:'+division;
			}
			
			if (categorydesc!='') {
				subtitle = subtitle+' Category:'+categorydesc;
			}

			if (level!='') {
				subtitle = subtitle+' Level:'+level;
			}
			
			$('#modalDetail .modal-subtitle').html(subtitle);			
			ColdFusion.navigate(template+'?source='+source+'&mission='+mission+'&division='+division+'&date='+pdate+'&column='+column+'&columnname='+columname+'&field='+field+'&categorydesc='+categorydesc+'&category='+category+'&seconded='+seconded+'&level='+level+'&condition='+condition+'&persongrade='+persongrade, 'rowDetail',callBackDetails);
		}


		function applyFilter(template, sd, container) {
			/*if ($('#pMission').val() == 'DPKO') { rfuentes*/
				$('.clsSecondmentContainer').show();
			/*} else {
				$('.clsSecondmentContainer').hide();
			}*/

			ColdFusion.navigate(template+'?showdivision='+sd+'&mission='+$('#pMission').val()+'&date='+$('#pDate').val()+'&seconded='+$('#pSeconded').val()+'&uniformed='+$('#pUniformed').val()+'&level='+$('#pLevel').val()+'&ts=', container);
		}		
		
		function clickMap(e){
			var vContextValue = encodeURIComponent(e.mapObject.id);
			showDrillDetail('', '', 'DashboardDrill.cfm?context=NationalityCode&contextValue='+vContextValue+'&mission='+$('#pMission').val()+'&date='+$('#pDate').val()+'&seconded='+$('#pSeconded').val());
		}
		
		function showDrillDetailContext(mission,vdate,seconded,gender,context,contextValue,division,source,level) {
			var vContextValue = encodeURIComponent(contextValue);
			ColdFusion.navigate('DashboardDrillDetail.cfm?mission='+mission+'&date='+vdate+'&seconded='+seconded+'&gender='+gender+'&context='+context+'&contextvalue='+vContextValue+'&division='+division+'&source='+source+'&level='+level, 'detailContainer');
		}
		
		function showPerson(per) {
			window.open("<cfoutput>#session.root#</cfoutput>/DWarehouse/Detail/EmployeeView.cfm?ID=" + per, "_blank");
		}
		
		function showPosition(pos) {
			window.open("<cfoutput>#session.root#</cfoutput>/Staffing/Application/Position/PositionParent/PositionView.cfm?ID2=" + pos, "_blank");
		}
		
	</script>
	
	<cfoutput>
		<script src="#session.root#/scripts/jquery/jquery.prosis.js"></script>
		<link href="#session.root#/scripts/multipleselect/multiple-select.css" rel="stylesheet">
		<script src="#session.root#/scripts/multipleselect/multiple-select.js"></script>
	</cfoutput>
	
	<cfquery name="qColorMale" 
		datasource="martStaffing">		 
			SELECT *
			FROM stLabel 
			WHERE Topic = 'M'
	</cfquery>

	<cfquery name="qColorFemale" 
		datasource="martStaffing">		 
			SELECT *
			FROM stLabel 
			WHERE Topic = 'F'
	</cfquery>
			
	<cfset colors[1] = "###qColorFemale.Color#">
	<cfset colors[2] = "###qColorMale.Color#">
			
	<cf_ProsisMap 
		id="1" 
		target="mymap"
		minValue="Female" 
		maxValue="Male"
		colorFrom="#colors[1]#"
		colorTo="##6F6F6F"
		showSmallMap="false"
		autoZoom="false"
		wheelZoom="false"
		onClick="clickMap">	
	
	<style>
		#mymap {
		  height: 90%;
		  width: 95%:
		  background-color:#EEEEEE;
		  
		}
	
		.chartwrapper {
		  width: 100%;
		  height: 100%;
		  position: relative;
		  padding-bottom: 55%;
		  box-sizing: border-box;
		}
	
		.chartdiv {
		  position: absolute;
		  width: 90%;
		  height: 90%;		 
		  align: center;
		}
		
		body.modal-open {
    		overflow: visible;
		}
		
		#side-menu li {
			height:35px;
			overflow:hidden;
		}
		
		#side-menu li a {
			padding: 10px 20px;
			text-transform:capitalize;
			font-weight:normal;
		}
		
		.modal-title {
			font-size:145%;
		}
		
		.dataTables_filter, .dataTables_info, .dataTables_length {
		    float:left !important;
		}

		.dataTables_paginate {
		    float:right !important;
		}

		.dataTableWrapper {
			height:35px;
		}
		
		.dataTables_wrapper {
			margin-top:-40px;
		}
		
		#wrapper {
			top:25px;
		}
		
		#header {
		    width: 100%;
		    position: fixed;
		    z-index: 1000;
		    height: 50px;
		}
		
		#menu {
    		position: fixed;
			overflow:auto;
			height:100%;
			-ms-overflow-style: none; 
    		overflow: -moz-scrollbars-none;
    		top: 50px;
		}
		
		#menu::-webkit-scrollbar {
			display: none;
		    width: 0px; 
		    background: transparent;
		}
		
		th {
			font-weight:normal;
		}

		#logo, .profile-picture, .color-line { 
			display: none !important;
		}

		nav img {
			margin-top: 5px !important;
			border-right: 1px solid #EEEEEE; 
		}

		nav h2 {
			margin-top: 10px !important;
			font-size: 24px;
			border:none !important;
		}
		
		table.table-bordered tbody tr td {
			padding-top:3px!important;
			padding-bottom:3px!important;
		}
		
		.ms-choice {
			height:34px!important;
			border-color: #e4e5e7 !important;
			color:#555555!important;
			font-size:14px!important;
		}
		
		.ms-choice > span {
			padding: 5px;
		    padding-left: 15px!important;
		}
		
		.ms-choice > div {  
			margin-top: 5px;
		}
		
		.ms-drop ul > li label {
			text-align:left!important;
		}
		
		.clsDirectoryDetail {
			margin-left:-40px;
			margin-right:-35px;
		}
		
		.tableFixHead { overflow-y: auto; height: 100px; }
		.tableFixHead thead th { position: sticky; top: 0; }
		
		table.tableFixHead { border-collapse: collapse; width: 100%; border-top:0px; }
		table.tableFixHead th, td { padding: 8px 16px;  }
		table.tableFixHead th { background:#E8E8E8; border:1px solid #E8E8E8; }

	</style>	

	<cf_mobileLayoutArea position="header" applicationLogo="img/Staffing.png" 
	   title="Staffing Statistics"></cf_mobileLayoutArea>
	
	<div id="rowDetail" style="display:none"></div>	
		
		<cf_mobileLayoutArea position="left" brandlogo="img/Staffing.png">
		
			<cf_mobileMenu>

				<cf_tl id="Workforce" var="1">
				<cfset vThisURL = "StaffingTable.cfm?id=Main&systemfunctionid=#url.systemfunctionid#">
				<cf_mobileMenuItem 
					description="#lt_text#"
					reference="javascript:ColdFusion.navigate('#vThisURL#','mainContainer');">
				</cf_mobileMenuItem>

				<cf_tl id="Postgrade/type matrix" var="1">
				<cfset vThisURL = "StaffingTable.cfm?id=Grd&systemfunctionid=#url.systemfunctionid#">
				<cf_mobileMenuItem 
					description="#lt_text#"
					reference="javascript:ColdFusion.navigate('#vThisURL#','mainContainer');">
				</cf_mobileMenuItem>

				<cf_tl id="Vacancies" var="1">
				<cfset vThisURL = "StaffingTable.cfm?id=Vac&systemfunctionid=#url.systemfunctionid#">
				<cf_mobileMenuItem 
					description="#lt_text#"
					reference="javascript:ColdFusion.navigate('#vThisURL#','mainContainer');">
				</cf_mobileMenuItem>

				<cf_tl id="Appointments" var="1">
				<cfset vThisURL = "StaffingTable.cfm?id=App&systemfunctionid=#url.systemfunctionid#">
				<cf_mobileMenuItem 
					description="#lt_text#"
					reference="javascript:ColdFusion.navigate('#vThisURL#','mainContainer');">
				</cf_mobileMenuItem>
				
				
			</cf_mobileMenu>
			
		</cf_mobileLayoutArea>
		<cfset vHide = "">


	<cf_mobileLayoutArea position="center">
	
		<div class="modal" id="modalDetail" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="color-line"></div>
					<div class="modal-header" style="padding-bottom:60px; min-height:100px;">
						<div style="float:left; width:95%;">
							<h4 class="modal-title">Details</h4>
							<small class="font-bold modal-subtitle"></small>
						</div>
						<button type="button" class="close clsNoPrint" data-dismiss="modal" aria-label="Close" style="float:right;">
          					<span aria-hidden="true">&times;</span>
        				</button>
					</div>
					<div class="modal-body" id="modalBody"></div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default clsNoPrint" data-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>
		
		<cf_mobileLayoutArea position="container"></cf_mobileLayoutArea>
		
		<cf_mobileLayoutArea footerRightText="Nova, #dateformat(now(), 'yyyy')#" position="footer"></cf_mobileLayoutArea>
		
	</cf_mobileLayoutArea>
	
	<!--- load first screen --->
	<cfoutput>
		<script>
			ColdFusion.navigate('StaffingTable.cfm?id=Main&systemfunctionid=#url.systemfunctionid#','mainContainer');
		</script>	
	</cfoutput>

</cf_mobile>

