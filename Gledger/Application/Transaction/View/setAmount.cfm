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

	<cfset amt = replace(url.amount,',','',"ALL")>	
	<cfset out = replace(url.outstanding,',','',"ALL")>
	<cfset exc = replace(url.exchange,',','',"ALL")>
	
	<cfif not LSIsNumeric(amt) or not LSIsNumeric(exc)>
	   <font color="FF0000">incorrect</font>
	   <cfabort>
	</cfif>
	
	<cfif amt gt out>
		<cfset amt = out>
	</cfif>
	
	<cfset val = amt/exc>
		
	<script>			
		document.getElementById('amt_#url.field#').value = "#NumberFormat(amt,'_,____.__')#"
		document.getElementById('off_#url.field#').value = "#NumberFormat(val,'_,____.__')#"
	</script>		 
	

</cfoutput>

