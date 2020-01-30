
<!--- we check if the scale has component defined --->

<cf_systemscript>

<cfinvoke component = "Service.Process.Payroll.Scale"  
   method           = "setScaleComponent" 
   ScaleNo          = "#url.ScaleNo#" 
   Force            = "Yes">	
      
<cfquery name="get"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   SalaryScale
	WHERE  ScaleNo = '#URL.ScaleNo#'
</cfquery>

<cfset url.schedule  = get.SalarySchedule>
<cfset url.mission   = get.Mission>
<cfset url.location  = get.ServiceLocation>
<cfset url.effective = get.SalaryEffective>

<cfoutput>
<script>
 ptoken.open('RateEdit.cfm?schedule=#get.SalarySchedule#&mission=#get.Mission#&location=#get.ServiceLocation#&effective=#get.SalaryEffective#&mode=#url.mode#&operational=#get.operational#','right')
</script>
</cfoutput>
