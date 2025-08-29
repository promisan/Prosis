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
<cfoutput>

<script>

function vendor(mission,systemfunctionid,header,enforce,target) {
    if (target == "_new") {
 	ptoken.open("#SESSION.root#/Procurement/Application/Vendor/VendorView.cfm?ts="+new Date().getTime()+"&mission="+mission+"&systemfunctionid=" + systemfunctionid, "_blank");
	} else {
	ptoken.open("#SESSION.root#/Procurement/Application/Vendor/VendorView.cfm?ts="+new Date().getTime()+"&mission="+mission+"&systemfunctionid=" + systemfunctionid, "_blank", "left=20, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");	
	}
} 

function donorlist(mission,systemfunctionid,header,enforce,target) {
    if (target == "_new") {	
 	ptoken.open("#SESSION.root#/ProgramREM/Application/Program/Donor/DonorView.cfm?ts="+new Date().getTime()+"&mission="+mission+"&systemfunctionid=" + systemfunctionid, "_blank");
	} else {
	ptoken.open("#SESSION.root#/ProgramREM/Application/Program/Donor/DonorView.cfm?ts="+new Date().getTime()+"&mission="+mission+"&systemfunctionid=" + systemfunctionid, "_blank", "left=20, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");	
	}
} 

function payrollsearch() {
 	ptoken.open("#SESSION.root#/Staffing/Application/Employee/EmployeeSearch/InitView.cfm?ts="+new Date().getTime()+"&ID=Search2.cfm", "paysrc", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
}

function module(mission,systemfunctionid,header,enforce,target) {
    if (target == "_new") {		
 	ptoken.open("#SESSION.root#/System/Modules/Functions/FunctionView.cfm?ts="+new Date().getTime()+ "&systemfunctionid=" + systemfunctionid, "function");
	} else {
	ptoken.open("#SESSION.root#/System/Modules/Functions/FunctionView.cfm?ts="+new Date().getTime()+ "&systemfunctionid=" + systemfunctionid, "function", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");	
	}
}

function entity() {
 	ptoken.open("#SESSION.root#/System/EntityAction/EntityView/EntityView.cfm?ts="+new Date().getTime(), "entity", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

function workflow(mission,systemfunctionid,header,enforce,target) {  
    if (target == "_new") {	
  	ptoken.open("#SESSION.root#/System/EntityAction/EntityFlow/WorkflowView.cfm?ts="+new Date().getTime()+ "&systemfunctionid=" + systemfunctionid, "workflow");	
	} else {
	ptoken.open("#SESSION.root#/System/EntityAction/EntityFlow/WorkflowView.cfm?ts="+new Date().getTime()+ "&systemfunctionid=" + systemfunctionid, "workflow", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");		
	}
}

function monitor(id,id1,header,enforce,target) {  
    if (target == "_new") {	 
  	ptoken.open("#SESSION.root#/System/Monitor/DataSet.cfm?idmenu="+id1+"&ts="+new Date().getTime(), "monitor");	
	} else {
	ptoken.open("#SESSION.root#/System/Monitor/DataSet.cfm?idmenu="+id1+"&ts="+new Date().getTime(), "monitor", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");		
	}
}

function reporter(mission,systemfunctionid,header,enforce,target) {
    if (target == "_new") {
 	ptoken.open("#SESSION.root#/System/Modules/Distribution/DistributionView.cfm?ts="+new Date().getTime()+ "&systemfunctionid=" + systemfunctionid, "log");
	} else {
	ptoken.open("#SESSION.root#/System/Modules/Distribution/DistributionView.cfm?ts="+new Date().getTime()+ "&systemfunctionid=" + systemfunctionid, "log", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");	
	}
}

function appcode(mission,systemfunctionid,header,enforce,target) {
     if (target == "_new") {
 	ptoken.open("#SESSION.root#/System/Modification/PostFile/PostFile.cfm?mode=full&ts="+new Date().getTime()+ "&systemfunctionid=" + systemfunctionid, "appcode");
	} else {
	ptoken.open("#SESSION.root#/System/Modification/PostFile/PostFile.cfm?mode=full&ts="+new Date().getTime()+ "&systemfunctionid=" + systemfunctionid, "appcode", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");	
	}
	
}

function dictionary(mission,systemfunctionid,header,enforce,target) {
    if (target == "_new") {
 	ptoken.open("#SESSION.root#/System/Parameter/DataDictionary/DataDictionary.cfm?ts="+new Date().getTime()+ "&systemfunctionid=" + systemfunctionid, "ddictionary");
	} else {
	ptoken.open("#SESSION.root#/System/Parameter/DataDictionary/DataDictionary.cfm?ts="+new Date().getTime()+ "&systemfunctionid=" + systemfunctionid, "ddictionary", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");	
	}
}

function template() {
 	ptoken.open("#SESSION.root#/System/Template/TemplateView.cfm?ts="+new Date().getTime(), "template");
}

<!--- UN only --->
function vacancycontrol(mission,systemfunctionid,header,enforce,target) {    
    if (target == "_new") {		
 	ptoken.open("#SESSION.root#/Vacancy/Application/ControlView/ControlView.cfm", "_new");
	} else {
	ptoken.open("#SESSION.root#/Vacancy/Application/ControlView/ControlView.cfm", "_top", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");	
	}
}

function vactrack(mission,systemfunctionid,header,enforce,target) {       
    if (target == "_new") {		
 	ptoken.open("#SESSION.root#/Vactrack/Application/ControlView/ControlView.cfm?ts="+new Date().getTime()+"&mission=" + mission+"&systemfunctionid=" + systemfunctionid, "_new");
	} else {
	ptoken.open("#SESSION.root#/Vactrack/Application/ControlView/ControlView.cfm?ts="+new Date().getTime()+"&mission=" + mission+"&systemfunctionid=" + systemfunctionid, "log", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");	
	}
}

function requestcontrol() {
 	ptoken.open("ControlView/ControlView.cfm", "reqctr", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

function employee(mission,systemfunctionid,header,enforce,target) {   
    if (target == "_new") {			
	ptoken.open("#SESSION.root#/Staffing/Application/Employee/EmployeeSearch/InitView.cfm?ID=Search3.cfm&ts="+new Date().getTime(), "_new");
	} else {
	ptoken.open("#SESSION.root#/Staffing/Application/Employee/EmployeeSearch/InitView.cfm?ID=Search3.cfm&ts="+new Date().getTime(), "employ", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");	
	}

}

function rosteraccess() {
 	ptoken.open("Access/ControlView.cfm?ts="+new Date().getTime(), "rosteracc", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

function roster(passtru,systemfunctionid,header,enforce,target) {
    if (target == "_new") {		
 	ptoken.open("#SESSION.root#/Roster/RosterGeneric/RosterSearch/InitView.cfm?"+passtru, "_blank");
	} else {
	ptoken.open("#SESSION.root#/Roster/RosterGeneric/RosterSearch/InitView.cfm?"+passtru, "rostersearch", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");	
	}
}

function rosterinquiry(passtru,systemfunctionid,header,enforce,target) {
   if (target == "_new") {		
 	ptoken.open("#SESSION.root#/Roster/RosterSpecial/RosterView/RosterViewLoop.cfm?"+passtru, "_blank");
	} else {
 	ptoken.open("#SESSION.root#/Roster/RosterSpecial/RosterView/RosterViewLoop.cfm?"+passtru, "roster", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
    }	
}

function mandate(mission,systemfunctionid,header,enforce,target) {
 	ptoken.open("#SESSION.root#/Staffing/Application/Position/MandateView/InitView.cfm?ts="+new Date().getTime()+"&Mission=" + mission+"&systemfunctionid=" + systemfunctionid, "mandate", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function staffingaccess() {
 	ptoken.open("#SESSION.root#/Staffing/Application/Access/OrganizationView.cfm?ts="+new Date().getTime() ,  "stfacc", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}
  
function orgaccess(mission,systemfunctionid,header,enforce,target) {
    if (target == "_new") {		
 	ptoken.open("#SESSION.root#/System/Organization/Access/OrganizationView.cfm?ts="+new Date().getTime()+"&Mission=" + mission+"&systemfunctionid=" + systemfunctionid,  "orgacc");
	} else {
	ptoken.open("#SESSION.root#/System/Organization/Access/OrganizationView.cfm?ts="+new Date().getTime()+"&Mission=" + mission+"&systemfunctionid=" + systemfunctionid,  "orgacc", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");	
	}
}

function assetlocation(mission,systemfunctionid,header,enforce,target) {
    if (target == "_new") {		
 	ptoken.open("#SESSION.root#/Warehouse/Maintenance/Location/LocationView.cfm?mission=" + mission+"&systemfunctionid=" + systemfunctionid,  "locacc");
	} else {
	ptoken.open("#SESSION.root#/Warehouse/Maintenance/Location/LocationView.cfm?mission=" + mission+"&systemfunctionid=" + systemfunctionid,  "locacc", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
}

function program(mission,systemfunctionid,header,enforce,target) {
    if (target == "_new") {		
	ptoken.open("#SESSION.root#/ProgramREM/Application/Program/ProgramView/ProgramView.cfm?mission=" + mission+"&systemfunctionid=" + systemfunctionid,"allot"+mission)	
	} else {
 	ptoken.open("#SESSION.root#/ProgramREM/Application/Program/ProgramView/ProgramView.cfm?mission=" + mission+"&systemfunctionid=" + systemfunctionid,  "program", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
}

function allotment(mission,systemfunctionid,header,enforce,target) {
    if (target == "_new") {	
	ptoken.open("#SESSION.root#/ProgramREM/Application/Budget/AllotmentView/AllotmentView.cfm?mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "program"+mission);	
	} else {
 	ptoken.open("#SESSION.root#/ProgramREM/Application/Budget/AllotmentView/AllotmentView.cfm?mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "allotment", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
}

function progress(mission,systemfunctionid,header,enforce,target) {
 	ptoken.open("#SESSION.root#/ProgramREM/Application/Program/ProgressView/ProgressView.cfm?Mission=" + mission+ "&systemfunctionid=" + systemfunctionid,  "progress", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

function projectprogress(mission,systemfunctionid,header,enforce,target) {
 	ptoken.open("#SESSION.root#/ProgramREM/Application/Program/ProjectProgressView/ProgressView.cfm?mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "progress", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function monitoringprogress(mission,systemfunctionid,header,enforce,target) {
 	ptoken.open("#SESSION.root#/ProgramREM/Application/monitoring/monitoringProgressView/ProgressView.cfm?mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "progress", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
}

function casefile(mission,systemfunctionid,header,enforce,target) {             
    if (target == "_new") {	
	  ptoken.open("#SESSION.root#/CaseFile/Application/Case/CaseControl/CaseView.cfm?Mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "casefile");
	} else { 
 	  ptoken.open("#SESSION.root#/CaseFile/Application/Case/CaseControl/CaseView.cfm?Mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "casefile", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
}

function requisition(mission,systemfunctionid,heading,enforce,target) {
    if (target == "_new") {	
 	ptoken.open("#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionView.cfm?mission=" + mission+ "&systemfunctionid=" + systemfunctionid,  "req"+mission);
	} else {
	ptoken.open("#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionView.cfm?mission=" + mission+ "&systemfunctionid=" + systemfunctionid,  "req"+mission, "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	
	}
}

function purchase(mission,systemfunctionid,heading,enforce,target) {
    if (target == "_new") {
 	ptoken.open("#SESSION.root#/Procurement/Application/PurchaseOrder/PurchaseView/PurchaseView.cfm?ts="+new Date().getTime()+"&Mission=" + mission+ "&systemfunctionid=" + systemfunctionid,  "po");
	} else {
	ptoken.open("#SESSION.root#/Procurement/Application/PurchaseOrder/PurchaseView/PurchaseView.cfm?ts="+new Date().getTime()+"&Mission=" + mission+ "&systemfunctionid=" + systemfunctionid,  "po", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");	
	}
}

function receipt(mission,systemfunctionid,heading,enforce,target) {
   if (target == "_new") {
   ptoken.open("#SESSION.root#/Procurement/Application/Receipt/ReceiptView/ReceiptView.cfm?ts="+new Date().getTime()+"&Mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "rct"+mission);
   } else {
   ptoken.open("#SESSION.root#/Procurement/Application/Receipt/ReceiptView/ReceiptView.cfm?ts="+new Date().getTime()+"&Mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "rct"+mission, "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");  
   }
}

function invoice(mission,systemfunctionid,heading,enforce,target) {
   if (target == "_new") {
   ptoken.open("#SESSION.root#/Procurement/Application/Invoice/InvoiceView/InvoiceView.cfm?ts="+new Date().getTime()+"&Mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "inv"+mission);
   } else {
   ptoken.open("#SESSION.root#/Procurement/Application/Invoice/InvoiceView/InvoiceView.cfm?ts="+new Date().getTime()+"&Mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "inv"+mission, "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes"); 
   }
}

function asset(mission,systemfunctionid,heading,enforce,target) {
   if (target == "newfull") { 
	    ptoken.open("#SESSION.root#/Warehouse/Application/Asset/AssetControl/ControlView.cfm?ts="+new Date().getTime()+"&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "ass"+mission, "left=10, top=10, width=" + w + ", height= " + h + ", fullscreen=yes, toolbar=no, status=yes, scrollbars=no, resizable=yes");
   } else {   
 	  	if (target == "_new") {
		ptoken.open("#SESSION.root#/Warehouse/Application/Asset/AssetControl/ControlView.cfm?ts="+new Date().getTime()+"&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "ass"+mission);		
		} else {		
   	    ptoken.open("#SESSION.root#/Warehouse/Application/Asset/AssetControl/ControlView.cfm?ts="+new Date().getTime()+"&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "ass"+mission, "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
   }
}

function taskorder(mission,systemfunctionid,heading,enforce,target) {
   if (target != "newfull") { full = "no" } else { full = "yes" }    
   ptoken.open("#SESSION.root#/Warehouse/Application/StockOrder/View/StockOrderView.cfm?ts="+new Date().getTime()+"&mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "tsk"+mission, "left=10, top=10, width=" + w + ", height= " + h + ",fullscreen=" + full + ", menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function stock(mission,systemfunctionid,heading,enforce,target) {
   if (target == "newfull") {  
   ptoken.open("#SESSION.root#/Warehouse/Application/Stock/StockControl/StockView.cfm?ts="+new Date().getTime()+"&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "stc"+mission, "left=10, top=10, width=" + w + ", height= " + h + ",fullscreen=yes, toolbar=no, status=yes, scrollbars=no, resizable=yes");  
   } else {
   if (target == "_new") {
   ptoken.open("#SESSION.root#/Warehouse/Application/Stock/StockControl/StockView.cfm?ts="+new Date().getTime()+"&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "stc"+mission);     
   } else {       
   ptoken.open("#SESSION.root#/Warehouse/Application/Stock/StockControl/StockView.cfm?ts="+new Date().getTime()+"&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "stc"+mission, "left=10, top=10, width=" + w + ", height= " + h + ",fullscreen=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");
   }
   }
}


function financials(mission,systemfunctionid,header,enforce,target) {
   if (target == "_new") {	
   ptoken.open("#SESSION.root#/Gledger/Application/Transaction/JournalView.cfm?ts="+new Date().getTime()+"&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "jrv"+mission);
   } else {
   ptoken.open("#SESSION.root#/Gledger/Application/Transaction/JournalView.cfm?ts="+new Date().getTime()+"&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "jrv"+mission, "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
   }
}

function payables(mission,systemfunctionid,header,enforce,target) {
   if (target == "_new") {	
    ptoken.open("#SESSION.root#/Gledger/Inquiry/AP_AR/InquiryView.cfm?mode=ap&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "pay"+mission);
   } else {
    ptoken.open("#SESSION.root#/Gledger/Inquiry/AP_AR/InquiryView.cfm?mode=ap&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "pay"+mission, "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
  }
   
}

function receivables(mission,systemfunctionid,header,enforce,target) {
   if (target == "_new") {	
    ptoken.open("#SESSION.root#/Gledger/Inquiry/AP_AR/InquiryView.cfm?mode=ar&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "rec"+mission);
   } else {
    ptoken.open("#SESSION.root#/Gledger/Inquiry/AP_AR/InquiryView.cfm?mode=ar&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "rec"+mission, "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");  
   }
}


function advances(mission,systemfunctionid,header,enforce,target) {
   if (target == "_new") {	
   ptoken.open("#SESSION.root#/Gledger/Inquiry/AP_AR/InquiryView.cfm?mode=ad&ts="+new Date().getTime()+"&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "rec"+mission);
   } else {
   ptoken.open("#SESSION.root#/Gledger/Inquiry/AP_AR/InquiryView.cfm?mode=ad&ts="+new Date().getTime()+"&Mission=" + mission +"&systemfunctionid=" + systemfunctionid,  "rec"+mission, "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");  
   }
}

function finstatement(mission,systemfunctionid,header,enforce,target) {
   if (target == "_new") {	
   ptoken.open("#SESSION.root#/Gledger/Inquiry/Statement/StatementSelect.cfm?ts="+new Date().getTime() + "&mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "jrv"+mission);
   } else {
   ptoken.open("#SESSION.root#/Gledger/Inquiry/Statement/StatementSelect.cfm?ts="+new Date().getTime() + "&mission=" + mission + "&systemfunctionid=" + systemfunctionid,  "jrv"+mission , "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");  
   }
} 

</script>

</cfoutput>
