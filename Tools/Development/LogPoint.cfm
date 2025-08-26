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
<!--- 
by dev dev dev
Promisan b.v.
This is a custom tag developed to help developer place a break point 
to troubleshoot a particular piece of code.

The tag receives a LogLine and then adds it up to a Log file 
Two modes of operation :

a) Adding to existing file
b) Writing from scratch an existing file

it can be write or append. 

The name of the output file can now be defined as well in parameter FileName. Added by dev on 27 oct 2011

--->




<cfparam name="Attributes.Mode"   default="Write">
<cfparam name="Attributes.FileName" default="Log.txt">


<cfif thisTag.ExecutionMode is 'start'>
	<!--- nada --->
	
<cfelse>
		   <cfoutput>
			   <cfsavecontent variable="LogMe">
				#now()#	
				-------------------------------
				#thisTag.GeneratedContent#
				-------------------------------
				</cfsavecontent>
				</cfoutput>
				
	 	    <cffile action="#Attributes.Mode#" 
		      file="#SESSION.rootpath#/#Attributes.FileName#" 
	    	  output="#LogMe#" 
		      addnewline="Yes" 
		      fixnewline="No"> 

</cfif>			  
 
