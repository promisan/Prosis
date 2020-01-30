<cfquery name="ThisProgram"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Program
    WHERE ProgramCode ='#URL.ProgramCode#'
</cfquery>

<cf_dialogREMProgram>
<cf_ObjectControls>
<cf_submenuleftscript>

<cfoutput>

<script>

function updatePeriod(per) { 
   
	document.getElementById('periodselect').value = per;
	parent.right.Prosis.busy('yes');	
	parent.right.location.href = window.urllocation.value+"&period=" + per;
	_cf_loadingtexthtml='';		
	if (document.getElementById('cycleinception')) {		    
	  ptoken.navigate('ProgramViewCycle.cfm?cycleclass=inception&mission=#ThisProgram.mission#&ProgramCode=#url.programcode#&Period=' + per,'cycleinception')
	}  
	if (document.getElementById('cyclereview')) {	
	  ptoken.navigate('ProgramViewCycle.cfm?cycleclass=review&mission=#ThisProgram.mission#&ProgramCode=#url.programcode#&Period=' + per,'cyclereview')
	}
}

function reviewcycle(prg,per,cycleid) {
   window.urllocation.value = "ReviewCycle/ReviewCycleView.cfm?ProgramCode=#URL.ProgramCode#&Period="+per
   parent.right.location.href = window.urllocation.value+"&CycleId=" + cycleid
}

function programlocation() {
   window.urllocation.value = "Location/LocationView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function forecast() {   
   window.urllocation.value = "../Budget/Forecast/ForecastView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function events() {   
   window.urllocation.value = "Events/EventsView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function programinfo() {
   window.urllocation.value = "Create/EntryView.cfm?Mission=#thisprogram.mission#&EditCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function risk() {
   window.urllocation.value = "Risk/Riskview.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function genderMarker() {
   window.urllocation.value = "Gender/GenderView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function donor() {
   window.urllocation.value = "Donor/DonorView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function locations() {
   window.urllocation.value = "Location/LocationView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function beneficiary() {
   window.urllocation.value = "Beneficiary/BeneficiaryView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function authorization() {
   window.urllocation.value = "Authorization/Authorization.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function budget() {
   window.urllocation.value = "../Budget/Allotment/AllotmentViewEmbed.cfm?Mission=#URL.Mission#&Program=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function group() {
   window.urllocation.value = "Group/GroupView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function sector() {
  window.urllocation.value = "Sector/SectorView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
  parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function category() {
  window.urllocation.value = "Category/GroupView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
  parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function employee() {
   window.urllocation.value = "Employee/EmployeeView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function resource() {
   window.urllocation.value = "Resource/ResourceView.cfm?Mission=#URL.Mission#&ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function funding() {
    window.urllocation.value = "Funding/FundingView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function target(){ 
    window.urllocation.value = "#tg#/TargetView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function outcometarget(){ 
    window.urllocation.value = "Target/TargetView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function programsummary(){
    window.urllocation.value = "Summary/Summary.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

function activity() {
    window.urllocation.value = "#act#" 	
	<cfif #ThisProgram.ProgramClass# eq "Project">
       parent.right.location.href = window.urllocation.value+"&mode=activity&Period=" + periodselect.value
	<cfelse>
	   parent.right.location.href = window.urllocation.value+"&mode=activity&Period=" + periodselect.value
	</cfif>
}

function activityprogress() {
    window.urllocation.value = "#act#" 	
	<cfif #ThisProgram.ProgramClass# eq "Project">
       parent.right.location.href = window.urllocation.value+"&mode=progress&Period=" + periodselect.value
	<cfelse>
	   parent.right.location.href = window.urllocation.value+"&mode=progress&Period=" + periodselect.value
	</cfif>
}


function verify() {
    window.urllocation.value = "VerifyComponent.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value	
}

function component() {
    window.urllocation.value = "ProgramViewTop.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.right.location.href = window.urllocation.value+"&Period=" + periodselect.value
}

</script>

</cfoutput>