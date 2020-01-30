<cf_tl id="Payroll Validation" var="lblTitle">

<cf_screenTop 
	  height="100%" 
	  layout="webapp" 	   
      label="#url.mission# #lblTitle#"  
	  jQuery="Yes">
	  

<cfset vLowerLimit = 1>
<cfset vUpperLimit = 100>
<cfset vInitialVariationValue = 5>
<cfset vAnimationTime = 350>	  

<cfoutput>
	<link rel="stylesheet" type="text/css" href="#session.root#/scripts/slider/slider.css">
</cfoutput>

<style>
	.clsAnimate {
		-webkit-transition: all 0.5s ease;
		-moz-transition: all 0.5s ease;
		-o-transition: all 0.5s ease;
		-ms-transition: all 0.5s ease;
		transition: all 0.5s ease;
	}
</style>

<cf_layoutScript>
<cf_PresentationScript>
<cf_DialogPosition>

<cf_tl id="No payroll data was found for the entity" var="lblNoDataFound">

<cfoutput>
	<script>

		function setSliderValue(pval) {
			if ($.isNumeric(pval)) {
				$('##variationSlider').val(Math.floor(pval));
			} else {
				$('##variationSlider').val(#vInitialVariationValue#);
			}
			doChangeVariation();
		}

		function showSliderValue() {
			$('##sliderOutput').val($('##variationSlider').val());
		}

		function __parseInt(pVal) {
			var vReturn = parseInt(pVal);
			if (vReturn == "NaN") {
				vReturn = 0;
			}
			return vReturn;
		}

		function showVariation() {
			var vCurrentVariation = __parseInt($('##variationSlider').val());

			$(".clsData").each(function(){
				var vDiff = __parseInt($(this).attr('data-value'));

				if (vDiff >= vCurrentVariation && vDiff > 0) {
					$(this).find('.clsDataPercentage').fadeIn(250);
					$(this).css('background-color','##F8FFA8');
				}else{
					$(this).css('background-color','');
					$(this).find('.clsDataPercentage').fadeOut(250);
				}
			});
		}

		function doChangeVariation() {
			showSliderValue();
			showVariation();
		}

		function doFilter() {
			var vType = $('input[name=type]:checked').val();			
			var vOrder = $('input[name=order]:checked').val();
			var vSalarySchedule = $('##SalarySchedule').val();
			var vPayrollItem = $('##PayrollItem').val();
			var vFilterMode = $('input[name=filtermode]:checked').val()			
			var vPostGrade = $('##PostGrade').val();
			var vLocation = $('##Location').val();
			var vFilterPerson = $('##FilterPerson').val();
			var vMonths = "";

			if (vSalarySchedule == null) {
				vSalarySchedule = "";
			}

			if (vPayrollItem == null) {
				vPayrollItem = "";
			}
			
			if (vFilterMode == null) {
				vFilterMode = "0"
			}

			if (vPostGrade == null) {
				vPostGrade = "";
			}

			if (vLocation == null) {
				vLocation = "";
			}

			$(".clsMonth").each(function() {
				if ($(this).is(":checked")) {
					vMonths = vMonths+this.value+",";
				}
			});

			if (vMonths != "") {
				vMonths = vMonths.substring(0, vMonths.length-1);
			}
			ptoken.navigate('QualityViewContent.cfm?mission=#url.mission#&type='+vType+'&order='+vOrder+'&SalarySchedule='+vSalarySchedule+'&FilterPerson='+vFilterPerson+'&FilterMode='+vFilterMode+'&PayrollItem='+vPayrollItem+'&PostGrade='+vPostGrade+'&location='+vLocation+'&months='+vMonths,'divContent');
		}

		function clearContent() {
			$('##divContent').html("");
		}

		function showPerson(personno) {
			ptoken.open('#session.root#/Staffing/Application/Employee/PersonView.cfm?ID='+personno, '_blank');
		}

		function showEmployeeSalary(salarySchedule, personno, months) {
			if ($('##trDetail_'+personno).is(':visible')) {
				$('##twistie_'+personno).attr('src', '#session.root#/images/expand.png');
				$('##trDetail_'+personno).fadeOut(#vAnimationTime#);
			} else {
				ptoken.navigate('EmployeeSalary.cfm?salarySchedule='+salarySchedule+'&personno='+personno+'&months='+months, 'divDetail_'+personno);
				$('##twistie_'+personno).attr('src', '#session.root#/images/collapse.png');
				$('##trDetail_'+personno).fadeIn(#vAnimationTime#);
			}
		}

		function showPayrollItemDetail(personno) {
			if ($('.clsPayrollItemDetail_'+personno).is(':visible')) {
				$('##twistiePI_'+personno).attr('src', '#session.root#/images/plusBlue.png');
				$('.clsPayrollItemDetail_'+personno).fadeOut(#vAnimationTime#);
			} else {
				$('##twistiePI_'+personno).attr('src', '#session.root#/images/minusBlue.png');
				$('.clsPayrollItemDetail_'+personno).fadeIn(#vAnimationTime#);
			}
		}

		function showAllPayrollItemDetail() {
			if ($('.clsPayrollItemDetail').first().is(':visible')) {
				$('##twistiePIAll, .clsTwistiePI').attr('src', '#session.root#/images/plusBlue.png');
				$('.clsPayrollItemDetail').fadeOut(#vAnimationTime#);
			} else {
				$('##twistiePIAll, .clsTwistiePI').attr('src', '#session.root#/images/minusBlue.png');
				$('.clsPayrollItemDetail').fadeIn(#vAnimationTime#);
			}
		}

	</script>
</cfoutput>

<cfquery name="getSalarySchedules" 
	 datasource="AppsPayroll" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT DISTINCT SM.SalarySchedule, SS.Description, SS.ListingOrder
		 FROM   SalaryScheduleMission SM
		 		INNER JOIN SalarySchedule SS ON SM.SalarySchedule = SS.SalarySchedule
		 WHERE 	SM.Mission = '#url.mission#'
		 <!--- has content to report --->
		 AND	SM.SalarySchedule IN (
		 			SELECT 	SalarySchedule
		 			FROM 	EmployeeSettlementLine
		 			WHERE	Mission = '#url.mission#'
		 			UNION
		 			SELECT 	ESLx.SalarySchedule
		 			FROM   	EmployeeSalary ESx
							INNER JOIN EmployeeSalaryLine ESLx
								ON ESx.SalarySchedule = ESLx.SalarySchedule
								AND ESx.PayrollStart  = ESLx.PayrollStart
								AND ESx.PersonNo      = ESLx.PersonNo
								AND ESx.PayrollCalcNo = ESLx.PayrollCalcNo
					WHERE 	ESx.Mission = '#url.mission#'
		 		)
		 ORDER BY SS.ListingOrder ASC
</cfquery>

<cf_layout type="border" id="mainLayout" width="100%">	

	<cfset vInitCollapsed = "false">
	<cfif getSalarySchedules.recordCount eq 0>
		<cfset vInitCollapsed = "true">
	</cfif>
			
	<cf_layoutArea 
		name       ="left" 
		position   ="left" 
		collapsible="true"
		size       ="400px"
		overflow   ="scroll"
		initcollapsed="#vInitCollapsed#">
			
			<cf_divScroll>
				
				<cfoutput>
					<table width="95%" align="center">

						<tr><td height="5"></td></tr>

						<tr class="labelmedium">
							<td  width="100px"><cf_tl id="Type">:</td>
							<td>
								<table width="100%">
									<tr>
										<td class="labellarge" width="50%">
											<input type="radio" name="type" id="type1" value="1" checked="checked" style="height:15px; width:15px;"> <label for="type1"><cf_tl id="Entitlement"></label>
										</td>
										<td class="labellarge" style="padding-left:10px;">
											<input type="radio" name="type" value="0" id="type0" style="height:15px; width:15px;"> <label for="type0"><cf_tl id="Settlement"></label>
										</td>
									</tr>
								</table>
							</td>
						</tr>

						

						<tr><td height="5"></td></tr>

						<tr class="labelmedium line">
							<td><cf_tl id="Schedule">:</td>
							<td>
								<select name="SalarySchedule" id="SalarySchedule" class="regularxl" style="height:30px; width:100%;">
									<option value=""> - <cf_tl id="Select a salary schedule"> -
									<cfloop query="getSalarySchedules">
										<option value="#SalarySchedule#"> #Description# (#SalarySchedule#)
									</cfloop>
								</select>
							</td>
						</tr>
						
						<tr>
							<td colspan="2">
								<cfdiv id="divDates" bind="url:getFiltersByTypeSchedule.cfm?mission=#url.mission#&type={type}&SalarySchedule={SalarySchedule}">
							</td>
						</tr>
						
						
					</table>
				</cfoutput>

			</cf_divScroll>
					
	</cf_layoutArea>
			
	<cf_layoutArea 
		name="center" 
		position="center"
		overflow="scroll">

			<cfif getSalarySchedules.recordCount eq 0>
				<cfoutput>
					<div id="divContent" style="text-align:center; font-size:125%; color:##D64541; margin-top:200px;"><h1>[#lblNoDataFound# #url.mission#]</h1></div>
				</cfoutput>
			<cfelse>
				<cfdiv id="divContent">
			</cfif>
										

	</cf_layoutArea>	

</cf_layout>