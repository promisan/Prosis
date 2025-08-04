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

<cfparam name="url.batchid"    default="">

<cfinvoke component = "Service.Process.Materials.POS"  
	   method           = "PurgeTransaction" 
	   batchid          = "#url.batchid#"
	   mode             = "void">		

<cfoutput>

<!--- refresh the screen and sets the new customer --->

<script>  
	// try { ColdFusion.Window.destroy('settlement',true)} catch(e){};	
	ptoken.open("#SESSION.root#/warehouse/application/salesorder/pos/settlement/SaleInvoice.cfm?batchid=#url.batchid#, "_blank", "left=30, top=30, width=800, height=800, status=yes, toolbar=no, scrollbars=no, resizable=yes");		
    ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#','customerbox')
</script>

</cfoutput>	   

	
	