
<!--- details --->

<cfparam name="url.Mission"            default="Fomtex">
<cfparam name="url.Year"               default="2016">
<cfparam name="url.Month"              default="">
<cfparam name="url.OrgUnitImplementer" default="">

<cfset FileNo = round(Rand()*30)>

<cfinvoke component   = "Service.Process.WorkOrder.WorkOrderLineItem"  
   method             = "getWorkOrderProduction" 
   mission            = "#url.mission#"   
   workorderyear      = "#url.year#"  
   workordermonth     = "xxx"  
   currency           = ""
   orgunitimplementer = "#url.OrgUnitImplementer#"    
   table              = "#SESSION.acc#Prod#FileNo#"    
   returnvariable     = "result">	

   
   <!--- show results --->
   
   results