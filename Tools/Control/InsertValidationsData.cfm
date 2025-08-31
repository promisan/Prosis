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
<!--- -------------------- --->

<!--- -------------------- --->
<!--- -----ROSTER--------- --->
<!--- -------------------- --->

<cf_insertValidations  
				ValidationCode="A001" 
         		SystemModule="Roster"  
				ValidationName="System" 	
				ValidationMethod="workexperience"
				Validationscope="1"        	
				Link="">
				 
<cf_insertValidations  
				ValidationCode="A002"          
				SystemModule="Roster"  
				ValidationName="System" 	
				ValidationMethod="documents"
				Validationscope="1"        	
				Link="">	
				 
				 

<!--- -------------------- --->
<!--- -----Program-------- --->
<!--- -------------------- --->

<cf_insertValidations  
				ValidationCode="P001"             
				SystemModule="Program"  
				ValidationName="Activities Exist" 	     
				ValidationMethod="programactivity"
				Validationscope="1"                     
				Link="">	
				 
<cf_insertValidations  
				ValidationCode="P002"             
				SystemModule="Program"  
				ValidationName="Requirements recorded"  
				ValidationMethod="programrequirement"
				Validationscope="1"                     
				Link="">				 					 			 			 
