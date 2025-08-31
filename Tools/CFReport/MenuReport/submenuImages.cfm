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

  <cfif FunctionIcon eq "Maintain">
         <img src="#SESSION.root#/Images/logos/system/settings.png" width="44" height="44" valign="absmiddle" alt="Global Preferences" border="0">
  <cfelseif FunctionIcon eq "Parameter">	
         <img src="#SESSION.root#/Images/logos/system/settings.png" align="absmiddle" alt="" width="44" height="44" border="0">
  <cfelseif TemplateSQL eq "Application">	
         <img src="#SESSION.root#/Images/logos/system/modules.png" width="44" height="44" align="absmiddle" alt="Open dataset"> 	 
  <cfelseif FunctionIcon eq "DataSet">	  
         <img src="#SESSION.root#/Images/logos/system/modules.png" height="44" align="absmiddle" alt="Open dataset"> 	 	 
  <cfelseif FunctionIcon eq "Flash">	
         <img src="#SESSION.root#/Images/logos/system/reports.png"  width="44" height="44" align="absmiddle" alt="Open report"> 	 
  <cfelseif FunctionIcon eq "PDF">	
         <img src="#SESSION.root#/Images/logos/system/reports.png" width="44" height="44" align="absmiddle" alt="Open report" alt="" border="0"> 
  <cfelseif FunctionIcon eq "Listing">	
         <img src="#SESSION.root#/Images/list.png" height="24" align="absmiddle" alt="Open report" alt="" border="0"> 		
  <cfelse>	
          <img src="#SESSION.root#/Images/logos/system/reports.png"  height="44" height="44" alt="" border="0">
  </cfif>
 
 </cfoutput>