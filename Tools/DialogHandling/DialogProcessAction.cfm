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

	<cfwindow 
	     name        = "dialogemployee"
	     title       = "Employee Search"
	     height      = "540"
	     width       = "600"
		 bodystyle   = "background-color:ffffff"
	 	 headerstyle = "background-color:ActiveCaption"
	     minheight   = "540"
	     minwidth    = "600"
	     center      = "True"
	     modal       = "True"/>
	 
	<script>	 
		 
	function selectemployee(table) {
	    ColdFusion.Window.show("employee")
		ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Lookup/LookupSearch.cfm?table=purchase.dbo.stJobReviewPanel','employee');			
	</script>	

</cfoutput> 