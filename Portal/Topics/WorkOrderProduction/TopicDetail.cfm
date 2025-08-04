<!--
    Copyright © 2025 Promisan

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