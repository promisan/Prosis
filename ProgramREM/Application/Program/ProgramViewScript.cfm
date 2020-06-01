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

   parent.ptoken.open('ReviewCycle/ReviewCycleView.cfm?ProgramCode=#URL.ProgramCode#&Period='+per+'&CycleId=' + cycleid,'right')
   
   <!--- enabled for MID --->
	 //  window.urllocation.value = "ReviewCycle/ReviewCycleView.cfm?ProgramCode=#URL.ProgramCode#&Period="+per
	 //  parent.right.location.href = window.urllocation.value+"&CycleId=" + cycleid
	
}

function programlocation() {
   window.urllocation.value = "Location/LocationView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function forecast() {   
   window.urllocation.value = "../Budget/Forecast/ForecastView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function events() {   
   window.urllocation.value = "Events/EventsView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function programinfo() {
   window.urllocation.value = "Create/EntryView.cfm?Mission=#thisprogram.mission#&EditCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function risk() {
   window.urllocation.value = "Risk/Riskview.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function genderMarker() {
   window.urllocation.value = "Gender/GenderView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+"&Period=" + periodselect.value,'right')
}

function donor() {
   window.urllocation.value = "Donor/DonorView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function locations() {
   window.urllocation.value = "Location/LocationView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function beneficiary() {
   window.urllocation.value = "Beneficiary/BeneficiaryView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function authorization() {
   window.urllocation.value = "Authorization/Authorization.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function budget() {
   window.urllocation.value = "../Budget/Allotment/AllotmentViewEmbed.cfm?Mission=#URL.Mission#&Program=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function group() {
   window.urllocation.value = "Group/GroupView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function sector() {
  window.urllocation.value = "Sector/SectorView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
  parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function category() {
  window.urllocation.value = "Category/GroupView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
  parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function employee() {
   window.urllocation.value = "Employee/EmployeeView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function resource() {
   window.urllocation.value = "Resource/ResourceView.cfm?Mission=#URL.Mission#&ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
   parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function funding() {
    window.urllocation.value = "Funding/FundingView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function target(){ 
    window.urllocation.value = "#tg#/TargetView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function outcometarget(){ 
    window.urllocation.value = "Target/TargetView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function programsummary(){
    window.urllocation.value = "Summary/Summary.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

function activity() {
    window.urllocation.value = "#act#" 	
	<cfif #ThisProgram.ProgramClass# eq "Project">
       parent.ptoken.open(window.urllocation.value+'&mode=activity&Period=' + periodselect.value,'right')
	<cfelse>
	   parent.ptoken.open(window.urllocation.value+'&mode=activity&Period=' + periodselect.value,'right')
	</cfif>
}

function activityprogress() {
    window.urllocation.value = "#act#" 	
	<cfif #ThisProgram.ProgramClass# eq "Project">
       parent.ptoken.open(window.urllocation.value+'&mode=progress&Period=' + periodselect.value,'right')
	<cfelse>
	   parent.ptoken.open(window.urllocation.value+'&mode=progress&Period=' + periodselect.value,'right')
	</cfif>
}


function verify() {
    window.urllocation.value = "VerifyComponent.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')	
}

function component() {
    window.urllocation.value = "ProgramViewTop.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#"
    parent.ptoken.open(window.urllocation.value+'&Period=' + periodselect.value,'right')
}

</script>

</cfoutput>