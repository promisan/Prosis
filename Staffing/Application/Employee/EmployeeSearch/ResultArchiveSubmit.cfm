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
<!--- store search request --->

  <cfquery name="Update" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE PersonSearch 
	 SET    Status = '1', 
	        Description = '#Form.Description#', 
		    Access = '#form.Access#'
	 WHERE  SearchId = '#FORM.SearchId#'
     </cfquery>

  <script language="JavaScript">
  
   parent.ptoken.location('InitView.cfm');
  
  </script>	
  